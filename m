Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD585F90D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfGDNVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:21:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727026AbfGDNVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:21:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x64DKFkf030737;
        Thu, 4 Jul 2019 06:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=lI39EMG3UN9QhqkoG0glw24VSY/3DtXjWK+88xDa9Sc=;
 b=GN0cbG27rCEm4v+W6DilvJ8x7G7JDopxlDjc64jowAOvkcdlpZBKHEb0COYPeyq5OW8k
 pRF7LyusyxDTsJ4lOt6+6FdI3g4rMI6K8yevGv08QVzWyGvK5yLAhkeCInAOtfy7C4Wn
 /eKkBg29YJQbjVi8sAj0Hyv05CL7P2N8EXhGt/svcRrUQY8SBuFho6QdThcZHr/9YlfQ
 YN8tECikZjDOzCTqbAijMpnPW9xT/mKy2CayXbtRPcDu39mFltKZInQ+rmK0eyA9Huft
 UQbJhI0uGrzEO1os3mL/tGMPZZ7xEd7zJqcW1oEXE1Y7ulrV+Dj8Xjs+nhIKSN8xCJtw bg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2th948237n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Jul 2019 06:21:37 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 4 Jul
 2019 06:21:36 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 4 Jul 2019 06:21:36 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 379873F703F;
        Thu,  4 Jul 2019 06:21:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x64DLad0013669;
        Thu, 4 Jul 2019 06:21:36 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x64DLZEe013668;
        Thu, 4 Jul 2019 06:21:35 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 4/4] qed*: Add devlink support for configuration attributes.
Date:   Thu, 4 Jul 2019 06:20:11 -0700
Message-ID: <20190704132011.13600-5-skalluru@marvell.com>
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

This patch adds implementation for devlink callbacks for reading and
configuring the device attributes.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 Documentation/networking/devlink-params-qede.txt |  72 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c       |  38 +++++
 drivers/net/ethernet/qlogic/qede/qede.h          |   3 +
 drivers/net/ethernet/qlogic/qede/qede_devlink.c  | 202 ++++++++++++++++++++++-
 drivers/net/ethernet/qlogic/qede/qede_devlink.h  |  23 +++
 include/linux/qed/qed_if.h                       |  16 ++
 6 files changed, 353 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/devlink-params-qede.txt

diff --git a/Documentation/networking/devlink-params-qede.txt b/Documentation/networking/devlink-params-qede.txt
new file mode 100644
index 0000000..f78a993
--- /dev/null
+++ b/Documentation/networking/devlink-params-qede.txt
@@ -0,0 +1,72 @@
+enable_sriov		[DEVICE, GENERIC]
+			Configuration mode: Permanent
+
+iwarp_cmt		[DEVICE, DRIVER-SPECIFIC]
+			Enable iWARP support over 100G device (CMT mode).
+			Type: Boolean
+			Configuration mode: runtime
+
+entity_id		[DEVICE, DRIVER-SPECIFIC]
+			Set the entity ID value to be used for this device
+			while reading/configuring the devlink attributes.
+			Type: u8
+			Configuration mode: runtime
+
+device_capabilities	[DEVICE, DRIVER-SPECIFIC]
+			Set the entity ID value to be used for this device
+			while reading/configuring the devlink attributes.
+			Type: u8
+			Configuration mode: runtime
+
+mf_mode			[DEVICE, DRIVER-SPECIFIC]
+			Configure Multi Function mode for the device.
+			Supported MF modes and the assoicated values are,
+			    MF allowed(0), Default(1), SPIO4(2), NPAR1.0(3),
+			    NPAR1.5(4), NPAR2.0(5), BD(6) and UFP(7)
+			Type: u8
+			Configuration mode: Permanent
+
+dcbx_mode		[PORT, DRIVER-SPECIFIC]
+			Configure DCBX mode for the device.
+			Supported dcbx modes are,
+			    Disabled(0), IEEE(1), CEE(2) and Dynamic(3)
+			Type: u8
+			Configuration mode: Permanent
+
+preboot_oprom		[PORT, DRIVER-SPECIFIC]
+			Enable Preboot Option ROM.
+			Type: Boolean
+			Configuration mode: Permanent
+
+preboot_boot_protocol	[PORT, DRIVER-SPECIFIC]
+			Configure preboot Boot protocol.
+			Possible values are,
+			    PXE(0), iSCSI Boot(3), FCoE Boot(4) and NONE(7)
+			Type: u8
+			Configuration mode: Permanent
+
+preboot_vlan		[PORT, DRIVER-SPECIFIC]
+			Preboot VLAN.
+			Type: u16
+			Configuration mode: Permanent
+
+preboot_vlan_value	[PORT, DRIVER-SPECIFIC]
+			Configure Preboot VLAN value.
+			Type: u16
+			Configuration mode: Permanent
+
+mba_delay_time		[PORT, DRIVER-SPECIFIC]
+			Configure MBA Delay Time. Supported range is [0-15].
+			Type: u8
+			Configuration mode: Permanent
+
+mba_setup_hot_key	[PORT, DRIVER-SPECIFIC]
+			Configure MBA setup Hot Key. Possible values are,
+			Ctrl S(0) and Ctrl B(1).
+			Type: u8
+			Configuration mode: Permanent
+
+mba_hide_setup_prompt	[PORT, DRIVER-SPECIFIC]
+			Configure MBA hide setup prompt.
+			Type: Boolean
+			Configuration mode: Permanent
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index f0183e2..3d43140 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2388,6 +2388,42 @@ static void qed_set_iwarp_cmt(struct qed_dev *cdev, bool iwarp_cmt)
 	cdev->iwarp_cmt = iwarp_cmt;
 }
 
+static int qed_get_cfg_attr(struct qed_dev *cdev, u16 cmd, u8 entity, u32 flags,
+			    u8 *buf, int *len)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *ptt;
+	int status = 0;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	status = qed_mcp_nvm_get_cfg(hwfn, ptt, cmd, entity, flags, buf, len);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return status;
+}
+
+static int qed_set_cfg_attr(struct qed_dev *cdev, u16 cmd, u8 entity, u32 flags,
+			    u8 *buf, int len)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *ptt;
+	int status = 0;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	status = qed_mcp_nvm_set_cfg(hwfn, ptt, cmd, entity, flags, buf, len);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return status;
+}
+
 static struct qed_selftest_ops qed_selftest_ops_pass = {
 	.selftest_memory = &qed_selftest_memory,
 	.selftest_interrupt = &qed_selftest_interrupt,
@@ -2438,6 +2474,8 @@ static void qed_set_iwarp_cmt(struct qed_dev *cdev, bool iwarp_cmt)
 	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
 	.get_iwarp_cmt = &qed_get_iwarp_cmt,
 	.set_iwarp_cmt = &qed_set_iwarp_cmt,
+	.get_cfg_attr = &qed_get_cfg_attr,
+	.set_cfg_attr = &qed_set_cfg_attr,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 35ad5cd..e175d30 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -54,6 +54,7 @@
 
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
+#include <net/devlink.h>
 
 #define QEDE_MAJOR_VERSION		8
 #define QEDE_MINOR_VERSION		37
@@ -264,6 +265,8 @@ struct qede_dev {
 	struct bpf_prog *xdp_prog;
 
 	struct devlink			*dl;
+	struct devlink_port		dl_port;
+	u8				cfg_entity_id;
 };
 
 enum QEDE_STATE {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_devlink.c b/drivers/net/ethernet/qlogic/qede/qede_devlink.c
index 3f362ac..076a66a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_devlink.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_devlink.c
@@ -2,6 +2,31 @@
 #include "qede.h"
 #include "qede_devlink.h"
 
+static const struct qede_devlink_cfg_param cfg_params[] = {
+	{DEVLINK_PARAM_GENERIC_ID_ENABLE_SRIOV, QED_NVM_CFG_ID_ENABLE_SRIOV,
+	 DEVLINK_PARAM_TYPE_BOOL},
+	{QEDE_DEVLINK_ENTITY_ID, 0, DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_DEVICE_CAPABILITIES,
+	 QED_NVM_CFG_ID_DEVICE_CAPABILITIES, DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_MF_MODE, QED_NVM_CFG_ID_MF_MODE, DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_DCBX_MODE, QED_NVM_CFG_ID_DCBX_MODE,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_PREBOOT_OPROM, QED_NVM_CFG_ID_PREBOOT_OPROM,
+	 DEVLINK_PARAM_TYPE_BOOL},
+	{QEDE_DEVLINK_PREBOOT_BOOT_PROTOCOL,
+	 QED_NVM_CFG_ID_PREBOOT_BOOT_PROTOCOL, DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_PREBOOT_VLAN, QED_NVM_CFG_ID_PREBOOT_VLAN,
+	 DEVLINK_PARAM_TYPE_U16},
+	{QEDE_DEVLINK_PREBOOT_VLAN_VALUE, QED_NVM_CFG_ID_PREBOOT_VLAN_VALUE,
+	 DEVLINK_PARAM_TYPE_U16},
+	{QEDE_DEVLINK_MBA_DELAY_TIME, QED_NVM_CFG_ID_MBA_DELAY_TIME,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_MBA_SETUP_HOT_KEY, QED_NVM_CFG_ID_MBA_SETUP_HOT_KEY,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QEDE_DEVLINK_MBA_HIDE_SETUP_PROMPT,
+	 QED_NVM_CFG_ID_MBA_HIDE_SETUP_PROMPT, DEVLINK_PARAM_TYPE_BOOL},
+};
+
 static int qede_dl_param_get(struct devlink *dl, u32 id,
 			     struct devlink_param_gset_ctx *ctx)
 {
@@ -28,11 +53,159 @@ static int qede_dl_param_set(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int qede_dl_get_perm_cfg(struct devlink *dl, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	u8 buf[QEDE_DL_PARAM_BUF_LEN];
+	struct qede_devlink *qede_dl;
+	int rc, idx, len = 0;
+	struct qede_dev *edev;
+	u32 flags;
+
+	qede_dl = devlink_priv(dl);
+	edev = qede_dl->edev;
+
+	if (id == QEDE_DEVLINK_ENTITY_ID) {
+		ctx->val.vu8 = edev->cfg_entity_id;
+		return 0;
+	}
+
+	for (idx = 0; idx < ARRAY_SIZE(cfg_params); idx++)
+		if (cfg_params[idx].id == id)
+			break;
+
+	if (idx == ARRAY_SIZE(cfg_params)) {
+		DP_ERR(edev, "Invalid command id %d\n", id);
+		return -EINVAL;
+	}
+
+	memset(buf, 0, QEDE_DL_PARAM_BUF_LEN);
+	flags = edev->cfg_entity_id ? QEDE_DL_PARAM_PF_GET_FLAGS :
+		QEDE_DL_PARAM_GET_FLAGS;
+
+	rc = edev->ops->common->get_cfg_attr(edev->cdev, cfg_params[idx].cmd,
+					     edev->cfg_entity_id, flags, buf,
+					     &len);
+	if (rc)
+		DP_ERR(edev, "Error = %d\n", rc);
+	else
+		memcpy(&ctx->val, buf, len);
+
+	return rc;
+}
+
+static int qede_dl_set_perm_cfg(struct devlink *dl, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	u8 buf[QEDE_DL_PARAM_BUF_LEN];
+	struct qede_devlink *qede_dl;
+	int rc, idx, len = 0;
+	struct qede_dev *edev;
+	u32 flags;
+
+	qede_dl = devlink_priv(dl);
+	edev = qede_dl->edev;
+
+	if (id == QEDE_DEVLINK_ENTITY_ID) {
+		edev->cfg_entity_id = ctx->val.vu8;
+		return 0;
+	}
+
+	for (idx = 0; idx < ARRAY_SIZE(cfg_params); idx++)
+		if (cfg_params[idx].id == id)
+			break;
+
+	if (idx == ARRAY_SIZE(cfg_params)) {
+		DP_ERR(edev, "Invalid command id %d\n", id);
+		return -EINVAL;
+	}
+
+	memset(buf, 0, QEDE_DL_PARAM_BUF_LEN);
+	switch (cfg_params[idx].type) {
+	case DEVLINK_PARAM_TYPE_BOOL:
+		len = 1;
+		break;
+	case DEVLINK_PARAM_TYPE_U8:
+		len = 1;
+		break;
+	case DEVLINK_PARAM_TYPE_U16:
+		len = 2;
+		break;
+	case DEVLINK_PARAM_TYPE_U32:
+		len = 4;
+		break;
+	case DEVLINK_PARAM_TYPE_STRING:
+		len = strlen(ctx->val.vstr);
+		break;
+	}
+
+	memcpy(buf, &ctx->val, len);
+	flags = edev->cfg_entity_id ? QEDE_DL_PARAM_PF_SET_FLAGS :
+		QEDE_DL_PARAM_SET_FLAGS;
+
+	rc = edev->ops->common->set_cfg_attr(edev->cdev, cfg_params[idx].cmd,
+					     edev->cfg_entity_id, flags, buf,
+					     len);
+	if (rc)
+		DP_ERR(edev, "Error = %d\n", rc);
+
+	return rc;
+}
+
 static const struct devlink_param qede_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
 			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     qede_dl_param_get, qede_dl_param_set, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_ENTITY_ID,
+			     "entity_id", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV, BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_MF_MODE,
+			     "mf_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_DEVICE_CAPABILITIES,
+			     "device_capabilities", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+};
+
+static const struct devlink_param qede_devlink_port_params[] = {
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_DCBX_MODE,
+			     "dcbx_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PREBOOT_OPROM,
+			     "preboot_oprom", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PREBOOT_BOOT_PROTOCOL,
+			     "preboot_boot_protocol", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PREBOOT_VLAN,
+			     "preboot_vlan", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_PREBOOT_VLAN_VALUE,
+			     "preboot_vlan_value", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_MBA_DELAY_TIME,
+			     "mba_delay_time", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_MBA_SETUP_HOT_KEY,
+			     "mba_setup_hot_key", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QEDE_DEVLINK_MBA_HIDE_SETUP_PROMPT,
+			     "mba_hide_setup_prompt", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qede_dl_get_perm_cfg, qede_dl_set_perm_cfg, NULL),
 };
 
 static const struct devlink_ops qede_dl_ops;
@@ -66,11 +239,34 @@ int qede_devlink_register(struct qede_dev *edev)
 	devlink_param_driverinit_value_set(dl, QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
 					   value);
 
+	devlink_port_attrs_set(&edev->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       0, false, 0, NULL, 0);
+	rc = devlink_port_register(dl, &edev->dl_port, 0);
+	if (rc) {
+		DP_ERR(edev, "devlink_port_register failed");
+		goto err_param_unregister;
+	}
+	devlink_port_type_eth_set(&edev->dl_port, edev->ndev);
+
+	rc = devlink_port_params_register(&edev->dl_port,
+					  qede_devlink_port_params,
+					  ARRAY_SIZE(qede_devlink_port_params));
+	if (rc) {
+		DP_ERR(edev, "devlink_port_params_register failed");
+		goto err_port_unregister;
+	}
+
 	devlink_params_publish(dl);
+	devlink_port_params_publish(&edev->dl_port);
 	edev->ops->common->set_iwarp_cmt(edev->cdev, false);
 
 	return 0;
 
+err_port_unregister:
+	devlink_port_unregister(&edev->dl_port);
+err_param_unregister:
+	devlink_params_unregister(edev->dl, qede_devlink_params,
+				  ARRAY_SIZE(qede_devlink_params));
 err_unregister:
 	devlink_unregister(dl);
 
@@ -86,9 +282,13 @@ void qede_devlink_unregister(struct qede_dev *edev)
 	if (!edev->dl)
 		return;
 
+	devlink_port_params_unpublish(&edev->dl_port);
+	devlink_params_unpublish(edev->dl);
+	devlink_port_params_unregister(&edev->dl_port, qede_devlink_port_params,
+				       ARRAY_SIZE(qede_devlink_port_params));
 	devlink_params_unregister(edev->dl, qede_devlink_params,
 				  ARRAY_SIZE(qede_devlink_params));
-
+	devlink_port_unregister(&edev->dl_port);
 	devlink_unregister(edev->dl);
 	devlink_free(edev->dl);
 }
diff --git a/drivers/net/ethernet/qlogic/qede/qede_devlink.h b/drivers/net/ethernet/qlogic/qede/qede_devlink.h
index 5aa79dd..57b5fcc 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_devlink.h
+++ b/drivers/net/ethernet/qlogic/qede/qede_devlink.h
@@ -3,6 +3,12 @@
 #define _QEDE_DEVLINK_H
 #include <net/devlink.h>
 
+#define QEDE_DL_PARAM_GET_FLAGS		0xA
+#define QEDE_DL_PARAM_SET_FLAGS		0xE
+#define QEDE_DL_PARAM_PF_GET_FLAGS	0x1A
+#define QEDE_DL_PARAM_PF_SET_FLAGS	0x1E
+#define QEDE_DL_PARAM_BUF_LEN		32
+
 struct qede_devlink {
 	struct qede_dev *edev;
 };
@@ -10,6 +16,23 @@ struct qede_devlink {
 enum qede_devlink_param_id {
 	QEDE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	QEDE_DEVLINK_PARAM_ID_IWARP_CMT,
+	QEDE_DEVLINK_ENTITY_ID,
+	QEDE_DEVLINK_DEVICE_CAPABILITIES,
+	QEDE_DEVLINK_MF_MODE,
+	QEDE_DEVLINK_DCBX_MODE,
+	QEDE_DEVLINK_PREBOOT_OPROM,
+	QEDE_DEVLINK_PREBOOT_BOOT_PROTOCOL,
+	QEDE_DEVLINK_PREBOOT_VLAN,
+	QEDE_DEVLINK_PREBOOT_VLAN_VALUE,
+	QEDE_DEVLINK_MBA_DELAY_TIME,
+	QEDE_DEVLINK_MBA_SETUP_HOT_KEY,
+	QEDE_DEVLINK_MBA_HIDE_SETUP_PROMPT,
+};
+
+struct qede_devlink_cfg_param {
+	u16 id;
+	u16 cmd;
+	enum devlink_param_type type;
 };
 
 int qede_devlink_register(struct qede_dev *edev);
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 7c41304..6430762 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -48,6 +48,18 @@
 #include <linux/qed/qed_chain.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
+#define QED_NVM_CFG_ID_MF_MODE			9
+#define QED_NVM_CFG_ID_DCBX_MODE		26
+#define QED_NVM_CFG_ID_PREBOOT_OPROM		59
+#define QED_NVM_CFG_ID_MBA_DELAY_TIME		61
+#define QED_NVM_CFG_ID_MBA_SETUP_HOT_KEY	62
+#define QED_NVM_CFG_ID_MBA_HIDE_SETUP_PROMPT	63
+#define QED_NVM_CFG_ID_PREBOOT_BOOT_PROTOCOL	69
+#define QED_NVM_CFG_ID_ENABLE_SRIOV		70
+#define QED_NVM_CFG_ID_DEVICE_CAPABILITIES	117
+#define QED_NVM_CFG_ID_PREBOOT_VLAN_VALUE	132
+#define QED_NVM_CFG_ID_PREBOOT_VLAN		133
+
 enum dcbx_protocol_type {
 	DCBX_PROTOCOL_ISCSI,
 	DCBX_PROTOCOL_FCOE,
@@ -1134,6 +1146,10 @@ struct qed_common_ops {
 
 	bool (*get_iwarp_cmt)(struct qed_dev *cdev);
 	void (*set_iwarp_cmt)(struct qed_dev *cdev, bool iwarp_cmt);
+	int (*get_cfg_attr)(struct qed_dev *cdev, u16 cmd, u8 entity, u32 flags,
+			    u8 *buf, int *len);
+	int (*set_cfg_attr)(struct qed_dev *cdev, u16 cmd, u8 entity, u32 flags,
+			    u8 *buf, int len);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
1.8.3.1

