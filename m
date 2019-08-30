Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62054A3157
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfH3Hm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:42:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726655AbfH3Hm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:42:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7eq2w021429;
        Fri, 30 Aug 2019 00:42:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hOl8voFw5xOjxFWpRL8Y4wJyhMahMYrIzHEsfHIvUuo=;
 b=EN527LBXdaNlFyulhbsgUpLwnMOrjtxrguneJQuPor52z/tH0ONMegTm7mXTTsEtpDyI
 3DqWM9Oey8+APHII84+3ECmRNop6/OISbRB6AeJxqQw1byHx/fWdQJgIdIOQPW5f7DaX
 i/Q5+v65mdyAO4FDzFRy5HAH+n6KZx8P5lHSxHGru13FxeBtk+3fK5XXEY/Iv1W2t/qe
 LF5UPYVKZtiixxDqlf6tbdX8cOsGioPPN5ExCNOmw2eNPLSFzUFaGwsz16myA2riHp+E
 y3JZ+r1HZs/3szrU4Osz4ykEfuCSq13IAriB4PN7R+mnbSePq768SqbqvOp2Wuz4Rp76 Dw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rkypr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:42:23 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 00:42:20 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 00:42:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 333993F7043;
        Fri, 30 Aug 2019 00:42:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7U7gJbI008880;
        Fri, 30 Aug 2019 00:42:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7U7gJIq008879;
        Fri, 30 Aug 2019 00:42:19 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/4] qed: Add APIs for reading config id attributes.
Date:   Fri, 30 Aug 2019 00:42:03 -0700
Message-ID: <20190830074206.8836-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830074206.8836-1-skalluru@marvell.com>
References: <20190830074206.8836-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds driver support for reading the config id attributes from NVM
flash partition.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 27 +++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 29 +++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  | 15 +++++++++++++++
 include/linux/qed/qed_if.h                 | 11 +++++++++++
 4 files changed, 82 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 7891f8c..c9a7571 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -69,6 +69,8 @@
 #define QED_RDMA_SRQS                   QED_ROCE_QPS
 #define QED_NVM_CFG_SET_FLAGS		0xE
 #define QED_NVM_CFG_SET_PF_FLAGS	0x1E
+#define QED_NVM_CFG_GET_FLAGS		0xA
+#define QED_NVM_CFG_GET_PF_FLAGS	0x1A
 
 static char version[] =
 	"QLogic FastLinQ 4xxxx Core Module qed " DRV_MODULE_VERSION "\n";
@@ -2298,6 +2300,30 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 	return rc;
 }
 
+static int qed_nvm_flash_cfg_read(struct qed_dev *cdev, u8 **data,
+				  u32 cmd, u32 entity_id)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *ptt;
+	u32 flags, len;
+	int rc = 0;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	DP_VERBOSE(cdev, NETIF_MSG_DRV,
+		   "Read config cmd = %d entity id %d\n", cmd, entity_id);
+	flags = entity_id ? QED_NVM_CFG_GET_PF_FLAGS : QED_NVM_CFG_GET_FLAGS;
+	rc = qed_mcp_nvm_get_cfg(hwfn, ptt, cmd, entity_id, flags, *data, &len);
+	if (rc)
+		DP_ERR(cdev, "Error %d reading %d\n", rc, cmd);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
 static int qed_nvm_flash(struct qed_dev *cdev, const char *name)
 {
 	const struct firmware *image;
@@ -2610,6 +2636,7 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	.db_recovery_del = &qed_db_recovery_del,
 	.read_module_eeprom = &qed_read_module_eeprom,
 	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
+	.read_nvm_cfg = &qed_nvm_flash_cfg_read,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 89462c4..36ddb89 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3751,6 +3751,35 @@ int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
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
 int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
 			u32 len)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 83649a8..9c4c276 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1209,6 +1209,21 @@ void qed_mcp_resc_lock_default_init(struct qed_resc_lock_params *p_lock,
 int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
 
 /**
+ * @brief Get NVM config attribute value.
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ * @param option_id
+ * @param entity_id
+ * @param flags
+ * @param p_buf
+ * @param p_len
+ */
+int qed_mcp_nvm_get_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
+			u32 *p_len);
+
+/**
  * @brief Set NVM config attribute value.
  *
  * @param p_hwfn
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index e366399..06fd958 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1132,6 +1132,17 @@ struct qed_common_ops {
  * @param cdev
  */
 	u8 (*get_affin_hwfn_idx)(struct qed_dev *cdev);
+
+/**
+ * @brief read_nvm_cfg - Read NVM config attribute value.
+ * @param cdev
+ * @param buf - buffer
+ * @param cmd - NVM CFG command id
+ * @param entity_id - Entity id
+ *
+ */
+	int (*read_nvm_cfg)(struct qed_dev *cdev, u8 **buf, u32 cmd,
+			    u32 entity_id);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
1.8.3.1

