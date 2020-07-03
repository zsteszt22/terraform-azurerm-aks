resource "kubernetes_namespace" "cert-manager" {
  count = var.enable_cert_manager ? 1 : 0
  metadata {
    name = var.cert_manager_namespace
    labels = {
      deployed-by = "Terraform"
    }
  }
}

resource "helm_release" "cert-manager" {
  count      = var.enable_cert_manager ? 1 : 0
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = kubernetes_namespace.cert-manager.0.metadata.0.name
  version    = var.cert_manager_chart_version
  dynamic "set" {
    for_each = local.cert_manager_values
    iterator = setting
    content {
      name  = setting.key
      value = setting.value
    }
  }
}