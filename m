Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC25F90C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfGDNVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:21:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40980 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727026AbfGDNVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:21:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x64DKFke030737;
        Thu, 4 Jul 2019 06:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=2oCZIiLBe9/N8JLYpTNaCni8lzHQnfbYEv6F9c8UJSg=;
 b=jAf+8cVpNMAoWK+lbMyx6HApGeSQ+V/r3mKGAtBN5chTrtjZgbwwrX84/aD2n/3QOhlt
 5KGBTJJrdYkSc0Cyfy54z3MwkSQXS2YNA6wT6jSOWXCMGe1rWZ/T9M4DCDHxuZlaRMFq
 FOPkVuaa1f8/ZCq3+2cnok1SzcPmtOjRpzBfzREllKQCJnATiZNM9qgZ8b9LDqHQIP97
 X3dHtK5cJVA8fZqYT4XOnmUC2UDOLAPAe1zyHP/aw1dMdQx12Ils+44pvS7MBECSjsb/
 K5FX2N/eUAWXU6PW2sZl2CuBYRognm9E54NS/KtcGNKAdqVnA9BrU1Qpen8z5OvUhy0I qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2th948237a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Jul 2019 06:21:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 4 Jul
 2019 06:21:33 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 4 Jul 2019 06:21:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F30413F703F;
        Thu,  4 Jul 2019 06:21:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x64DLW7G013665;
        Thu, 4 Jul 2019 06:21:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x64DLWYu013664;
        Thu, 4 Jul 2019 06:21:32 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 3/4] qed*: Add new file for devlink implementation.
Date:   Thu, 4 Jul 2019 06:20:10 -0700
Message-ID: <20190704132011.13600-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190704132011.13600-1-skalluru@marvell.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-04_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving devlink implementation from qed to qede driver. The change is
required as qede is the actual PCI driver and qed is only the control
driver.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h           |   1 -
 drivers/net/ethernet/qlogic/qed/qed_main.c      | 122 +++---------------------
 drivers/net/ethernet/qlogic/qede/Makefile       |   2 +-
 drivers/net/ethernet/qlogic/qede/qede.h         |   2 +
 drivers/net/ethernet/qlogic/qede/qede_devlink.c |  94 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qede/qede_devlink.h |  18 ++++
 drivers/net/ethernet/qlogic/qede/qede_main.c    |  13 +++
 include/linux/qed/qed_if.h                      |   3 +
 8 files changed, 143 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qede/qede_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qede/qede_devlink.h

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 89fe091..cebd822 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -864,7 +864,6 @@ struct qed_dev {
 	u32 rdma_max_srq_sge;
 	u16 tunn_feature_mask;
 
-	struct devlink			*dl;
 	bool				iwarp_cmt;
 };
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..f0183e2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -48,7 +48,6 @@
 #include <linux/crc32.h>
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_ll2_if.h>
-#include <net/devlink.h>
 
 #include "qed.h"
 #include "qed_sriov.h"
@@ -343,107 +342,6 @@ static int qed_set_power_state(struct qed_dev *cdev, pci_power_t state)
 	return 0;
 }
 
-struct qed_devlink {
-	struct qed_dev *cdev;
-};
-
-enum qed_devlink_param_id {
-	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	QED_DEVLINK_PARAM_ID_IWARP_CMT,
-};
-
-static int qed_dl_param_get(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	ctx->val.vbool = cdev->iwarp_cmt;
-
-	return 0;
-}
-
-static int qed_dl_param_set(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	cdev->iwarp_cmt = ctx->val.vbool;
-
-	return 0;
-}
-
-static const struct devlink_param qed_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
-			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     qed_dl_param_get, qed_dl_param_set, NULL),
-};
-
-static const struct devlink_ops qed_dl_ops;
-
-static int qed_devlink_register(struct qed_dev *cdev)
-{
-	union devlink_param_value value;
-	struct qed_devlink *qed_dl;
-	struct devlink *dl;
-	int rc;
-
-	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
-	if (!dl)
-		return -ENOMEM;
-
-	qed_dl = devlink_priv(dl);
-
-	cdev->dl = dl;
-	qed_dl->cdev = cdev;
-
-	rc = devlink_register(dl, &cdev->pdev->dev);
-	if (rc)
-		goto err_free;
-
-	rc = devlink_params_register(dl, qed_devlink_params,
-				     ARRAY_SIZE(qed_devlink_params));
-	if (rc)
-		goto err_unregister;
-
-	value.vbool = false;
-	devlink_param_driverinit_value_set(dl,
-					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
-					   value);
-
-	devlink_params_publish(dl);
-	cdev->iwarp_cmt = false;
-
-	return 0;
-
-err_unregister:
-	devlink_unregister(dl);
-
-err_free:
-	cdev->dl = NULL;
-	devlink_free(dl);
-
-	return rc;
-}
-
-static void qed_devlink_unregister(struct qed_dev *cdev)
-{
-	if (!cdev->dl)
-		return;
-
-	devlink_params_unregister(cdev->dl, qed_devlink_params,
-				  ARRAY_SIZE(qed_devlink_params));
-
-	devlink_unregister(cdev->dl);
-	devlink_free(cdev->dl);
-}
-
 /* probing */
 static struct qed_dev *qed_probe(struct pci_dev *pdev,
 				 struct qed_probe_params *params)
@@ -472,12 +370,6 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 	}
 	DP_INFO(cdev, "PCI init completed successfully\n");
 
-	rc = qed_devlink_register(cdev);
-	if (rc) {
-		DP_INFO(cdev, "Failed to register devlink.\n");
-		goto err2;
-	}
-
 	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
 	if (rc) {
 		DP_ERR(cdev, "hw prepare failed\n");
@@ -507,8 +399,6 @@ static void qed_remove(struct qed_dev *cdev)
 
 	qed_set_power_state(cdev, PCI_D3hot);
 
-	qed_devlink_unregister(cdev);
-
 	qed_free_cdev(cdev);
 }
 
@@ -2488,6 +2378,16 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	return QED_AFFIN_HWFN_IDX(cdev);
 }
 
+static bool qed_get_iwarp_cmt(struct qed_dev *cdev)
+{
+	return cdev->iwarp_cmt;
+}
+
+static void qed_set_iwarp_cmt(struct qed_dev *cdev, bool iwarp_cmt)
+{
+	cdev->iwarp_cmt = iwarp_cmt;
+}
+
 static struct qed_selftest_ops qed_selftest_ops_pass = {
 	.selftest_memory = &qed_selftest_memory,
 	.selftest_interrupt = &qed_selftest_interrupt,
@@ -2536,6 +2436,8 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	.db_recovery_del = &qed_db_recovery_del,
 	.read_module_eeprom = &qed_read_module_eeprom,
 	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
+	.get_iwarp_cmt = &qed_get_iwarp_cmt,
+	.set_iwarp_cmt = &qed_set_iwarp_cmt,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qede/Makefile b/drivers/net/ethernet/qlogic/qede/Makefile
index 3fc91d1..4585864 100644
--- a/drivers/net/ethernet/qlogic/qede/Makefile
+++ b/drivers/net/ethernet/qlogic/qede/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_QEDE) := qede.o
 
-qede-y := qede_main.o qede_fp.o qede_filter.o qede_ethtool.o qede_ptp.o
+qede-y := qede_main.o qede_fp.o qede_filter.o qede_ethtool.o qede_ptp.o qede_devlink.o
 qede-$(CONFIG_DCB) += qede_dcbnl.o
 qede-$(CONFIG_QED_RDMA) += qede_rdma.o
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index b972ab0..35ad5cd 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -262,6 +262,8 @@ struct qede_dev {
 	struct qede_rdma_dev		rdma_info;
 
 	struct bpf_prog *xdp_prog;
+
+	struct devlink			*dl;
 };
 
 enum QEDE_STATE {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_devlink.c b/drivers/net/ethernet/qlogic/qede/qede_devlink.c
new file mode 100644
index 0000000..3f362ac
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qede/qede_devlink.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "qede.h"
+#include "qede_devlink.h"
+
+static int qede_dl_param_get(struct devlink *dl, u32 id,
+			     struct devlink_param_gset_ctx *ctx)
+{
+	struct qede_devlink *qede_dl;
+	struct qede_dev *edev;
+
+	qede_dl = devlink_priv(dl);
+	edev = qede_dl->edev;
+	ctx->val.vbool = edev->ops->common->get_iwarp_cmt(edev->cdev);
+
+	return 0;
+}
+
+static int qede_dl_param_set(struct devlink *dl, u32 id,
+			     struct devlink_param_gset_ctx *ctx)
+{
+	struct qede_devlink *qede_dl;
+	struct qede_dev *edev;
+
+	qede_dl = devlink_priv(dl);
+	edev = qede_dl->edev;
+	edev->ops->common->set_iwarp_cmt(edev->cdev, ctx->val.vbool);
+
+	return 0;
+}
+
+static const struct devlink_param qede_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
+			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     qede_dl_param_get, qede_dl_param_set, NULL),
+};
+
+static const struct devlink_ops qede_dl_ops;
+
+int qede_devlink_register(struct qede_dev *edev)
+{
+	union devlink_param_value value;
+	struct qede_devlink *qede_dl;
+	struct devlink *dl;
+	int rc;
+
+	dl = devlink_alloc(&qede_dl_ops, sizeof(*qede_dl));
+	if (!dl)
+		return -ENOMEM;
+
+	qede_dl = devlink_priv(dl);
+
+	edev->dl = dl;
+	qede_dl->edev = edev;
+
+	rc = devlink_register(dl, &edev->pdev->dev);
+	if (rc)
+		goto err_free;
+
+	rc = devlink_params_register(dl, qede_devlink_params,
+				     ARRAY_SIZE(qede_devlink_params));
+	if (rc)
+		goto err_unregister;
+
+	value.vbool = false;
+	devlink_param_driverinit_value_set(dl, QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
+					   value);
+
+	devlink_params_publish(dl);
+	edev->ops->common->set_iwarp_cmt(edev->cdev, false);
+
+	return 0;
+
+err_unregister:
+	devlink_unregister(dl);
+
+err_free:
+	edev->dl = NULL;
+	devlink_free(dl);
+
+	return rc;
+}
+
+void qede_devlink_unregister(struct qede_dev *edev)
+{
+	if (!edev->dl)
+		return;
+
+	devlink_params_unregister(edev->dl, qede_devlink_params,
+				  ARRAY_SIZE(qede_devlink_params));
+
+	devlink_unregister(edev->dl);
+	devlink_free(edev->dl);
+}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_devlink.h b/drivers/net/ethernet/qlogic/qede/qede_devlink.h
new file mode 100644
index 0000000..5aa79dd
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qede/qede_devlink.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _QEDE_DEVLINK_H
+#define _QEDE_DEVLINK_H
+#include <net/devlink.h>
+
+struct qede_devlink {
+	struct qede_dev *edev;
+};
+
+enum qede_devlink_param_id {
+	QEDE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
+};
+
+int qede_devlink_register(struct qede_dev *edev);
+void qede_devlink_unregister(struct qede_dev *edev);
+
+#endif
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index d4a2966..cef946f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -62,6 +62,7 @@
 #include <linux/vmalloc.h>
 #include "qede.h"
 #include "qede_ptp.h"
+#include "qede_devlink.h"
 
 static char version[] =
 	"QLogic FastLinQ 4xxxx Ethernet Driver qede " DRV_MODULE_VERSION "\n";
@@ -1177,8 +1178,18 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	edev->rx_copybreak = QEDE_RX_HDR_SIZE;
 
 	qede_log_probe(edev);
+
+	rc = qede_devlink_register(edev);
+	if (rc) {
+		DP_INFO(edev, "Failed to register devlink.\n");
+		goto err5;
+	}
+
 	return 0;
 
+err5:
+	if (!is_vf)
+		qede_ptp_disable(edev);
 err4:
 	qede_rdma_dev_remove(edev, (mode == QEDE_PROBE_RECOVERY));
 err3:
@@ -1227,6 +1238,8 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 
 	DP_INFO(edev, "Starting qede_remove\n");
 
+	qede_devlink_unregister(edev);
+
 	qede_rdma_dev_remove(edev, (mode == QEDE_REMOVE_RECOVERY));
 
 	if (mode != QEDE_REMOVE_RECOVERY) {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index eef02e6..7c41304 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1131,6 +1131,9 @@ struct qed_common_ops {
  * @param cdev
  */
 	u8 (*get_affin_hwfn_idx)(struct qed_dev *cdev);
+
+	bool (*get_iwarp_cmt)(struct qed_dev *cdev);
+	void (*set_iwarp_cmt)(struct qed_dev *cdev, bool iwarp_cmt);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
1.8.3.1

