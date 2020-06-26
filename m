Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C00D20B08A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgFZLbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:31:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41934 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgFZLbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:31:42 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2DFCC2007F;
        Fri, 26 Jun 2020 11:31:41 +0000 (UTC)
Received: from us4-mdac16-74.at1.mdlocal (unknown [10.110.50.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2C0986009B;
        Fri, 26 Jun 2020 11:31:41 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C726F220064;
        Fri, 26 Jun 2020 11:31:40 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7A907580064;
        Fri, 26 Jun 2020 11:31:40 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:31:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 12/15] sfc: commonise PCI error handlers
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <d96206bc-a2b4-67be-7ea7-0013bb08ee6b@solarflare.com>
Date:   Fri, 26 Jun 2020 12:31:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-6.102900-8.000000-10
X-TMASE-MatchedRID: PBCJCIUm2Vcjohs9HHP8gKiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3MjZCT0GsTWyEbT3mGmWPpNfNG9woGketilIxScKXZnK0hDW
        FNedT6Pqyt8Axij6QLEbHOBeatCiI3nEpDU+5f9nVsW2YGqoUtAqiBO2qhCIGonsmeAVBR/e1Cu
        PsjB0wVULwyPHDAF0CHHv1FJxORpcX960wGYZMylS0U/rncMc4jhdrcmlB7cNKDy5+nmfdPhRsP
        HYJMjHm9hafGKWghJnOMm2PsqmZk3uuMi0fBquFiPIR0a1i6hdJaD67iKvY08nKBKuS2VHCMFdd
        v+pLbrch+o8X0L4Y6B7c0yGrT4tekfRhdidsajM5f9Xw/xqKXXJnzNw42kCxxEHRux+uk8h+ICq
        uNi0WJLOerVoZir9YTv28SA4BORZT9SkG12ArwoZvuYNFy4d+ftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.102900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593171101-8gomG3m-8lxf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 will use the same mechanisms for PCI error recovery.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 91 ---------------------------
 drivers/net/ethernet/sfc/efx_common.c | 91 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h |  1 +
 3 files changed, 92 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 86639b1e4e5c..4c2d305089ce 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1490,97 +1490,6 @@ static const struct dev_pm_ops efx_pm_ops = {
 	.restore	= efx_pm_resume,
 };
 
-/* A PCI error affecting this device was detected.
- * At this point MMIO and DMA may be disabled.
- * Stop the software path and request a slot reset.
- */
-static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
-					      enum pci_channel_state state)
-{
-	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
-	struct efx_nic *efx = pci_get_drvdata(pdev);
-
-	if (state == pci_channel_io_perm_failure)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	rtnl_lock();
-
-	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_RECOVERY;
-		efx->reset_pending = 0;
-
-		efx_device_detach_sync(efx);
-
-		efx_stop_all(efx);
-		efx_disable_interrupts(efx);
-
-		status = PCI_ERS_RESULT_NEED_RESET;
-	} else {
-		/* If the interface is disabled we don't want to do anything
-		 * with it.
-		 */
-		status = PCI_ERS_RESULT_RECOVERED;
-	}
-
-	rtnl_unlock();
-
-	pci_disable_device(pdev);
-
-	return status;
-}
-
-/* Fake a successful reset, which will be performed later in efx_io_resume. */
-static pci_ers_result_t efx_io_slot_reset(struct pci_dev *pdev)
-{
-	struct efx_nic *efx = pci_get_drvdata(pdev);
-	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
-
-	if (pci_enable_device(pdev)) {
-		netif_err(efx, hw, efx->net_dev,
-			  "Cannot re-enable PCI device after reset.\n");
-		status =  PCI_ERS_RESULT_DISCONNECT;
-	}
-
-	return status;
-}
-
-/* Perform the actual reset and resume I/O operations. */
-static void efx_io_resume(struct pci_dev *pdev)
-{
-	struct efx_nic *efx = pci_get_drvdata(pdev);
-	int rc;
-
-	rtnl_lock();
-
-	if (efx->state == STATE_DISABLED)
-		goto out;
-
-	rc = efx_reset(efx, RESET_TYPE_ALL);
-	if (rc) {
-		netif_err(efx, hw, efx->net_dev,
-			  "efx_reset failed after PCI error (%d)\n", rc);
-	} else {
-		efx->state = STATE_READY;
-		netif_dbg(efx, hw, efx->net_dev,
-			  "Done resetting and resuming IO after PCI error.\n");
-	}
-
-out:
-	rtnl_unlock();
-}
-
-/* For simplicity and reliability, we always require a slot reset and try to
- * reset the hardware when a pci error affecting the device is detected.
- * We leave both the link_reset and mmio_enabled callback unimplemented:
- * with our request for slot reset the mmio_enabled callback will never be
- * called, and the link_reset callback is not used by AER or EEH mechanisms.
- */
-static const struct pci_error_handlers efx_err_handlers = {
-	.error_detected = efx_io_error_detected,
-	.slot_reset	= efx_io_slot_reset,
-	.resume		= efx_io_resume,
-};
-
 static struct pci_driver efx_pci_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= efx_pci_table,
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 36c0ab57d3bd..88ade7f41819 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1130,3 +1130,94 @@ void efx_fini_mcdi_logging(struct efx_nic *efx)
 	device_remove_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
 }
 #endif
+
+/* A PCI error affecting this device was detected.
+ * At this point MMIO and DMA may be disabled.
+ * Stop the software path and request a slot reset.
+ */
+static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
+					      enum pci_channel_state state)
+{
+	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
+	struct efx_nic *efx = pci_get_drvdata(pdev);
+
+	if (state == pci_channel_io_perm_failure)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	rtnl_lock();
+
+	if (efx->state != STATE_DISABLED) {
+		efx->state = STATE_RECOVERY;
+		efx->reset_pending = 0;
+
+		efx_device_detach_sync(efx);
+
+		efx_stop_all(efx);
+		efx_disable_interrupts(efx);
+
+		status = PCI_ERS_RESULT_NEED_RESET;
+	} else {
+		/* If the interface is disabled we don't want to do anything
+		 * with it.
+		 */
+		status = PCI_ERS_RESULT_RECOVERED;
+	}
+
+	rtnl_unlock();
+
+	pci_disable_device(pdev);
+
+	return status;
+}
+
+/* Fake a successful reset, which will be performed later in efx_io_resume. */
+static pci_ers_result_t efx_io_slot_reset(struct pci_dev *pdev)
+{
+	struct efx_nic *efx = pci_get_drvdata(pdev);
+	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
+
+	if (pci_enable_device(pdev)) {
+		netif_err(efx, hw, efx->net_dev,
+			  "Cannot re-enable PCI device after reset.\n");
+		status =  PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return status;
+}
+
+/* Perform the actual reset and resume I/O operations. */
+static void efx_io_resume(struct pci_dev *pdev)
+{
+	struct efx_nic *efx = pci_get_drvdata(pdev);
+	int rc;
+
+	rtnl_lock();
+
+	if (efx->state == STATE_DISABLED)
+		goto out;
+
+	rc = efx_reset(efx, RESET_TYPE_ALL);
+	if (rc) {
+		netif_err(efx, hw, efx->net_dev,
+			  "efx_reset failed after PCI error (%d)\n", rc);
+	} else {
+		efx->state = STATE_READY;
+		netif_dbg(efx, hw, efx->net_dev,
+			  "Done resetting and resuming IO after PCI error.\n");
+	}
+
+out:
+	rtnl_unlock();
+}
+
+/* For simplicity and reliability, we always require a slot reset and try to
+ * reset the hardware when a pci error affecting the device is detected.
+ * We leave both the link_reset and mmio_enabled callback unimplemented:
+ * with our request for slot reset the mmio_enabled callback will never be
+ * called, and the link_reset callback is not used by AER or EEH mechanisms.
+ */
+const struct pci_error_handlers efx_err_handlers = {
+	.error_detected = efx_io_error_detected,
+	.slot_reset	= efx_io_slot_reset,
+	.resume		= efx_io_resume,
+};
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 93a017aafb9f..68af2af3b5da 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -73,4 +73,5 @@ void efx_link_status_changed(struct efx_nic *efx);
 unsigned int efx_xdp_max_mtu(struct efx_nic *efx);
 int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
+extern const struct pci_error_handlers efx_err_handlers;
 #endif

