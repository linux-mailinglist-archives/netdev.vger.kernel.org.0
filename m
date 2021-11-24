Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9145B7A7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhKXJqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:46:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237834AbhKXJqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:46:45 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AO8SrEN015559;
        Wed, 24 Nov 2021 01:43:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Vl177cFdquIpL5qJMiAHz6JT8sCBHYptjSk+WUkZxFo=;
 b=X88C3UF9+ZGkZ9RxGAAZNgALvfOE99vEIXttmWFninG/Z02PVoXsn0QndNeT0UqzD029
 DgP7ObiG/ff7p6fr4uB2kIPQ8NPKjcZOSsP9qpoIRwE+WBM04UJQGQY8E77D+gL2Z+k6
 A+Udb+H/QykubWXekXFyZOyyAbOMjLfBCtgT388WP6jRHWeMQIHEZdNtrE1UfvBKN821
 0RYHT9GSjxlZihzaPSAQf5u7imHH2Ydkxif5+m7p/tjWAk4zXT93VBSkxtdigOyrgvpy
 DYoasznt+ByKNUg4YbmInFfYaWpcq3Wja95af71lXZOLtPLx7AoLQO6NTWYiugTKpcpp sQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tr25se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 01:43:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Nov
 2021 01:43:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Nov 2021 01:43:32 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 177AE5B6934;
        Wed, 24 Nov 2021 01:43:33 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1AO9hWMH029444;
        Wed, 24 Nov 2021 01:43:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1AO9hW3l029443;
        Wed, 24 Nov 2021 01:43:32 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH net-next 2/2] qed*: esl priv flag support through ethtool
Date:   Wed, 24 Nov 2021 01:43:03 -0800
Message-ID: <20211124094303.29390-3-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211124094303.29390-1-manishc@marvell.com>
References: <20211124094303.29390-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TziKMrOaixE2dRWZGiE0SjQTu7ADwX-v
X-Proofpoint-GUID: TziKMrOaixE2dRWZGiE0SjQTu7ADwX-v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_03,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds relevant qed APIs to get ESL (enhance system lockdown)
capabilities and current status for ESL, which can be queried via qede
.get_priv_flags() ethtool interface

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 25 ++++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 22 ++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 20 +++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  1 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 13 ++++++++++
 include/linux/qed/qed_if.h                    |  3 +++
 6 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index a18d2ea96b26..46d4207f22a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -447,7 +447,7 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 			dev_info->wol_support = true;
 
 		dev_info->smart_an = qed_mcp_is_smart_an_supported(p_hwfn);
-
+		dev_info->esl = qed_mcp_is_esl_supported(p_hwfn);
 		dev_info->abs_pf_id = QED_LEADING_HWFN(cdev)->abs_pf_id;
 	} else {
 		qed_vf_get_fw_version(&cdev->hwfns[0], &dev_info->fw_major,
@@ -3028,6 +3028,28 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	return QED_AFFIN_HWFN_IDX(cdev);
 }
 
+static int qed_get_esl_status(struct qed_dev *cdev, bool *esl_active)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *ptt;
+	int rc = 0;
+
+	*esl_active = false;
+
+	if (IS_VF(cdev))
+		return 0;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	rc = qed_mcp_get_esl_status(hwfn, ptt, esl_active);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
 static struct qed_selftest_ops qed_selftest_ops_pass = {
 	.selftest_memory = &qed_selftest_memory,
 	.selftest_interrupt = &qed_selftest_interrupt,
@@ -3085,6 +3107,7 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.set_grc_config = &qed_set_grc_config,
 	.mfw_report = &qed_mfw_report,
 	.get_sb_info = &qed_get_sb_info,
+	.get_esl_status = &qed_get_esl_status,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 64678a256f3b..da1eadabcb41 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -4158,3 +4158,25 @@ qed_mcp_send_raw_debug_data(struct qed_hwfn *p_hwfn,
 	return qed_mcp_send_debug_data(p_hwfn, p_ptt,
 				       QED_MCP_DBG_DATA_TYPE_RAW, p_buf, size);
 }
+
+bool qed_mcp_is_esl_supported(struct qed_hwfn *p_hwfn)
+{
+	return !!(p_hwfn->mcp_info->capabilities &
+		  FW_MB_PARAM_FEATURE_SUPPORT_ENHANCED_SYS_LCK);
+}
+
+int qed_mcp_get_esl_status(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, bool *active)
+{
+	u32 resp = 0, param = 0;
+	int rc;
+
+	rc = qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_GET_MANAGEMENT_STATUS, 0, &resp, &param);
+	if (rc) {
+		DP_NOTICE(p_hwfn, "Failed to send ESL command, rc = %d\n", rc);
+		return rc;
+	}
+
+	*active = !!(param & FW_MB_PARAM_MANAGEMENT_STATUS_LOCKDOWN_ENABLED);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 2c28d5f86497..3cf6dab9e582 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1339,4 +1339,24 @@ int qed_mcp_nvm_get_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
 			u32 len);
+
+/**
+ * qed_mcp_is_esl_supported(): Return whether management firmware support ESL or not.
+ *
+ * @p_hwfn: hw function pointer
+ *
+ * Return: bool
+ */
+bool qed_mcp_is_esl_supported(struct qed_hwfn *p_hwfn);
+
+/**
+ * qed_mcp_get_esl_status(): Get enhanced system lockdown status
+ *
+ * @p_hwfn: hw function pointer
+ * @p_ptt: ptt resource pointer
+ * @active: ESL active status data pointer
+ *
+ * Return: Int
+ */
+int qed_mcp_get_esl_status(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, bool *active);
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
index 8a0e3c5d4bda..b70ee8200e15 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
@@ -1191,6 +1191,7 @@ enum drv_msg_code_enum {
 	DRV_MSG_CODE_CFG_VF_MSIX = DRV_MSG_CODE(0xc001),
 	DRV_MSG_CODE_CFG_PF_VFS_MSIX = DRV_MSG_CODE(0xc002),
 	DRV_MSG_CODE_DEBUG_DATA_SEND = DRV_MSG_CODE(0xc004),
+	DRV_MSG_CODE_GET_MANAGEMENT_STATUS = DRV_MSG_CODE(0xc007),
 };
 
 #define DRV_MSG_CODE_VMAC_TYPE_SHIFT            4
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 100c9c52c20b..97a7ab0826ed 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -168,6 +168,8 @@ enum {
 	QEDE_PRI_FLAG_CMT,
 	QEDE_PRI_FLAG_SMART_AN_SUPPORT, /* MFW supports SmartAN */
 	QEDE_PRI_FLAG_RECOVER_ON_ERROR,
+	QEDE_PRI_FLAG_ESL_SUPPORT, /* MFW supports Enhanced System Lockdown */
+	QEDE_PRI_FLAG_ESL_ACTIVE, /* Enhanced System Lockdown Active status */
 	QEDE_PRI_FLAG_LEN,
 };
 
@@ -175,6 +177,8 @@ static const char qede_private_arr[QEDE_PRI_FLAG_LEN][ETH_GSTRING_LEN] = {
 	"Coupled-Function",
 	"SmartAN capable",
 	"Recover on error",
+	"ESL capable",
+	"ESL active",
 };
 
 enum qede_ethtool_tests {
@@ -478,6 +482,7 @@ static int qede_get_sset_count(struct net_device *dev, int stringset)
 static u32 qede_get_priv_flags(struct net_device *dev)
 {
 	struct qede_dev *edev = netdev_priv(dev);
+	bool esl_active;
 	u32 flags = 0;
 
 	if (edev->dev_info.common.num_hwfns > 1)
@@ -489,6 +494,14 @@ static u32 qede_get_priv_flags(struct net_device *dev)
 	if (edev->err_flags & BIT(QEDE_ERR_IS_RECOVERABLE))
 		flags |= BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR);
 
+	if (edev->dev_info.common.esl)
+		flags |= BIT(QEDE_PRI_FLAG_ESL_SUPPORT);
+
+	edev->ops->common->get_esl_status(edev->cdev, &esl_active);
+
+	if (esl_active)
+		flags |= BIT(QEDE_PRI_FLAG_ESL_ACTIVE);
+
 	return flags;
 }
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 9f4bfa2a4829..6dc4943d8aec 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -652,6 +652,7 @@ struct qed_dev_info {
 
 	bool wol_support;
 	bool smart_an;
+	bool esl;
 
 	/* MBI version */
 	u32 mbi_version;
@@ -1205,6 +1206,8 @@ struct qed_common_ops {
 
 	int (*get_sb_info)(struct qed_dev *cdev, struct qed_sb_info *sb,
 			   u16 qid, struct qed_sb_info_dbg *sb_dbg);
+
+	int (*get_esl_status)(struct qed_dev *cdev, bool *esl_active);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
2.27.0

