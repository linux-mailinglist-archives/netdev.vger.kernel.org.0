Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31C54812D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfFQLqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:46:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44004 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbfFQLqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:46:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBihKs027792;
        Mon, 17 Jun 2019 04:46:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=cTc1rA6ozewh9fGy71dQ6chbieKop+eVPXH+yA7/QOY=;
 b=EllgMjl8TgyZARHbCtuLPsgd2pkzbwbN9W1k7Ijd84HPMjHEGvZ4MzaYeq9IO4FIy0Fb
 4fxQ+P5ZK5QR2wdhm1FkgtKgik+wa+ZN4yI2BUzI/yroAtZAfsmz7vXpQtv1loK5zekE
 29pogbX4HfL+ssr0TvCBXy7/OhfQjrHW+7T3G0gclAzQcAFdrjk0S7F40112LDeVgBIp
 vO8Df8oMKuiE/BBDAXb8d2NwGLvkvNG6dnE3/p3SUgvrhfqyTZe6ybQP2yvviHqaowup
 5krloDkDkeTS6CXRG6I4Cy3Xw13mEYqBgIJpbb7pLV6rzg/P3az//EmAyzZ41qXL1yXX 0A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t68rp8ahw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:46:00 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:45:59 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 17 Jun 2019 04:45:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 289CF3F703F;
        Mon, 17 Jun 2019 04:45:59 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x5HBjxx0017135;
        Mon, 17 Jun 2019 04:45:59 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x5HBjwu5017134;
        Mon, 17 Jun 2019 04:45:58 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/4] qed: Add APIs for device attributes configuration.
Date:   Mon, 17 Jun 2019 04:45:25 -0700
Message-ID: <20190617114528.17086-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190617114528.17086-1-skalluru@marvell.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds APIs for reading/configuring the device attributes using
mailbox interfaces.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 20 ++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 64 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h | 14 +++++++
 3 files changed, 98 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index e054f6c..5091f5b1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12580,6 +12580,8 @@ struct public_drv_mb {
 #define DRV_MSG_CODE_BW_UPDATE_ACK		0x32000000
 #define DRV_MSG_CODE_NIG_DRAIN			0x30000000
 #define DRV_MSG_CODE_S_TAG_UPDATE_ACK		0x3b000000
+#define DRV_MSG_CODE_GET_NVM_CFG_OPTION		0x003e0000
+#define DRV_MSG_CODE_SET_NVM_CFG_OPTION		0x003f0000
 #define DRV_MSG_CODE_INITIATE_PF_FLR            0x02010000
 #define DRV_MSG_CODE_VF_DISABLED_DONE		0xc0000000
 #define DRV_MSG_CODE_CFG_VF_MSIX		0xc0010000
@@ -12748,6 +12750,21 @@ struct public_drv_mb {
 #define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE		0x00000002
 #define DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK		0x00010000
 
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_SHIFT		0
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_MASK		0x0000FFFF
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_SHIFT		16
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_MASK		0x00010000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_SHIFT		17
+#define DRV_MB_PARAM_NVM_CFG_OPTION_INIT_MASK		0x00020000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_SHIFT	18
+#define DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT_MASK		0x00040000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_SHIFT		19
+#define DRV_MB_PARAM_NVM_CFG_OPTION_FREE_MASK		0x00080000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_SHIFT	20
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL_MASK	0x00100000
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_SHIFT	24
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID_MASK	0x0f000000
+
 	u32 fw_mb_header;
 #define FW_MSG_CODE_MASK			0xffff0000
 #define FW_MSG_CODE_UNSUPPORTED                 0x00000000
@@ -13319,6 +13336,9 @@ enum spad_sections {
 	SPAD_SECTION_MAX
 };
 
+#define NVM_CFG_ID_MAC_ADDRESS			1
+#define NVM_CFG_ID_MF_MODE			9
+
 #define MCP_TRACE_SIZE          2048	/* 2kb */
 
 /* This section is located at a fixed location in the beginning of the
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 758702c..573911a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3750,3 +3750,67 @@ int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 	return 0;
 }
+
+int qed_mcp_nvm_get_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
+			u32 *p_len)
+{
+	u32 mb_param = 0, resp, param;
+	int rc;
+
+	QED_MFW_SET_FIELD(mb_param, DRV_MB_PARAM_NVM_CFG_OPTION_ID, option_id);
+	if (flags & QED_NVM_CFG_OPTION_INIT)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_INIT, 1);
+	if (flags & QED_NVM_CFG_OPTION_FREE)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_FREE, 1);
+	if (flags & QED_NVM_CFG_OPTION_ENTITY_SEL) {
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL, 1);
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID,
+				  entity_id);
+	}
+
+	rc = qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
+				DRV_MSG_CODE_GET_NVM_CFG_OPTION,
+				mb_param, &resp, &param, p_len, (u32 *)p_buf);
+
+	return rc;
+}
+
+int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
+			u32 len)
+{
+	u32 mb_param = 0, resp, param;
+	int rc;
+
+	QED_MFW_SET_FIELD(mb_param, DRV_MB_PARAM_NVM_CFG_OPTION_ID, option_id);
+	if (flags & QED_NVM_CFG_OPTION_ALL)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_ALL, 1);
+	if (flags & QED_NVM_CFG_OPTION_INIT)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_INIT, 1);
+	if (flags & QED_NVM_CFG_OPTION_COMMIT)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_COMMIT, 1);
+	if (flags & QED_NVM_CFG_OPTION_FREE)
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_FREE, 1);
+	if (flags & QED_NVM_CFG_OPTION_ENTITY_SEL) {
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_SEL, 1);
+		QED_MFW_SET_FIELD(mb_param,
+				  DRV_MB_PARAM_NVM_CFG_OPTION_ENTITY_ID,
+				  entity_id);
+	}
+
+	rc = qed_mcp_nvm_wr_cmd(p_hwfn, p_ptt,
+				DRV_MSG_CODE_SET_NVM_CFG_OPTION,
+				mb_param, &resp, &param, len, (u32 *)p_buf);
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index e4f8fe4..550b4dd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -251,6 +251,12 @@ struct qed_mfw_tlv_generic {
 	struct qed_mfw_tlv_iscsi iscsi;
 };
 
+#define QED_NVM_CFG_OPTION_ALL		BIT(0)
+#define QED_NVM_CFG_OPTION_INIT		BIT(1)
+#define QED_NVM_CFG_OPTION_COMMIT       BIT(2)
+#define QED_NVM_CFG_OPTION_FREE		BIT(3)
+#define QED_NVM_CFG_OPTION_ENTITY_SEL	BIT(4)
+
 /**
  * @brief - returns the link params of the hw function
  *
@@ -1202,4 +1208,12 @@ void qed_mcp_resc_lock_default_init(struct qed_resc_lock_params *p_lock,
  */
 int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
 
+int qed_mcp_nvm_get_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
+			u32 *p_len);
+
+int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
+			u32 len);
+
 #endif
-- 
1.8.3.1

