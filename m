Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64225726FF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfGXEvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:51:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbfGXEvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:51:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6O4o3Q9029241;
        Tue, 23 Jul 2019 21:51:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=y9evbL1UZfQQPb+KhapWsLkgx7XiNibhJ3rfmq7RZmo=;
 b=xEQtlyD7duayQVxuihn1oDoUWEKbHkZC6F68gdeUjPJqgPe/Jw7Srwl/j3u561ISvmJO
 3aLCT0nCwzYRJbfPcLiOyCRVGmOn9cAZzzAxpAuJzQMvRGPgCZ/hVioSnX1h7RzcrOAc
 yByqJPXpjKasq2bzj2fCy7V59JUVS+4Phc+3ILKNDzQYUbzzzfiXj8pilKCnHWkNMjWh
 qiJAwJxHVHGPna1tfXOc3fuBvj6A/csF5uJ7H1bgM6yRDdkzMupVJpSwUYzQlmySvqN4
 Woi7VJYl4tFriotJv9X8xSapa0B8AfMs9LDlFzTilc5r9432NhlftMqwZvK3OoojWnx/ rw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tx624tf05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 21:51:53 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 23 Jul
 2019 21:51:51 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 23 Jul 2019 21:51:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E25F03F703F;
        Tue, 23 Jul 2019 21:51:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6O4poxX027744;
        Tue, 23 Jul 2019 21:51:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6O4poTa027743;
        Tue, 23 Jul 2019 21:51:50 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/2] qed: Add APIs for NVM config attributes.
Date:   Tue, 23 Jul 2019 21:51:40 -0700
Message-ID: <20190724045141.27703-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190724045141.27703-1-skalluru@marvell.com>
References: <20190724045141.27703-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-24_01:2019-07-23,2019-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds APIs for reading/configuring the NVM config attributes
using Management FW interfaces.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 17 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 64 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h | 14 +++++++
 3 files changed, 95 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index e054f6c..557a12e 100644
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

