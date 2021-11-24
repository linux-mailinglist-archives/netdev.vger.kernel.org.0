Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5060F45B7A8
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhKXJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:46:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238060AbhKXJqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:46:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AO2UgiR007763;
        Wed, 24 Nov 2021 01:43:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NTiuxJ6FFy9T9xjKENu7sHwqetnPDKpj2Bi4DP+kCFw=;
 b=PPqrAm+qOn2b5ht/IlUnSTfZpVV6QsaYjAVjeEI68hjC1AnOolzPlxboRuU67/yopBSe
 U/DW4fQi5AfeI0w1SdF4unU3VYIGePlSthyn9DAg6paUSUjowA20F3IKYBxXVDMqZ9Fx
 FVghqMKgwWsn2ainlY9VceUQnpG7Nky+2EA4a5U4jVoOP6rvyjYYJQA6LqnobLYxbuAf
 YpUTjfrnxatCLtYHRSXgQzKgU+YNjLJMV3+doHhwr6j5MeOT7SPwKSqMr/7tT11tLMGS
 p+Yq6c6K1PSPuicbo7qqq2K8SOELfuFMB56CbCggfZpL2Ft4qMm8tw6i+IlN2KOT37nV HQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tt24q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 01:43:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 24 Nov
 2021 01:43:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 24 Nov 2021 01:43:33 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E9B845B692F;
        Wed, 24 Nov 2021 01:43:32 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1AO9hTWi029440;
        Wed, 24 Nov 2021 01:43:29 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1AO9hOIf029439;
        Wed, 24 Nov 2021 01:43:24 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH net-next 1/2] qed*: enhance tx timeout debug info
Date:   Wed, 24 Nov 2021 01:43:02 -0800
Message-ID: <20211124094303.29390-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211124094303.29390-1-manishc@marvell.com>
References: <20211124094303.29390-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2PDEwk2rZffu2yICiT56NmsmCUUnpqwR
X-Proofpoint-GUID: 2PDEwk2rZffu2yICiT56NmsmCUUnpqwR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_03,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add some new qed APIs to query status block
info and report various data to MFW on tx timeout event

Along with that it enhances qede to dump more debug logs
(not just specific to the queue which was reported by stack)
on tx timeout which includes various other basic metadata about
all tx queues and other info (like status block etc.)

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 23 +++++
 drivers/net/ethernet/qlogic/qed/qed_int.h     | 13 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 47 ++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |  2 +
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    |  2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 94 ++++++++++++++++---
 include/linux/qed/qed_if.h                    | 11 +++
 7 files changed, 177 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index a97f691839e0..f9744c089f1f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -2399,3 +2399,26 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 
 	return rc;
 }
+
+int qed_int_get_sb_dbg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       struct qed_sb_info *p_sb, struct qed_sb_info_dbg *p_info)
+{
+	u16 sbid = p_sb->igu_sb_id;
+	u32 i;
+
+	if (IS_VF(p_hwfn->cdev))
+		return -EINVAL;
+
+	if (sbid >= NUM_OF_SBS(p_hwfn->cdev))
+		return -EINVAL;
+
+	p_info->igu_prod = qed_rd(p_hwfn, p_ptt, IGU_REG_PRODUCER_MEMORY + sbid * 4);
+	p_info->igu_cons = qed_rd(p_hwfn, p_ptt, IGU_REG_CONSUMER_MEM + sbid * 4);
+
+	for (i = 0; i < PIS_PER_SB; i++) {
+		p_info->pi[i] = (u16)qed_rd(p_hwfn, p_ptt,
+					    CAU_REG_PI_MEMORY + sbid * 4 * PIS_PER_SB + i * 4);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index 84c17e97f569..49ebb5d9f767 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -185,6 +185,19 @@ void qed_int_disable_post_isr_release(struct qed_dev *cdev);
  */
 void qed_int_attn_clr_enable(struct qed_dev *cdev, bool clr_enable);
 
+/**
+ * qed_int_get_sb_dbg: Read debug information regarding a given SB
+ *
+ * @p_hwfn: hw function pointer
+ * @p_ptt: ptt resource
+ * @p_sb: pointer to status block for which we want to get info
+ * @p_info: pointer to struct to fill with information regarding SB
+ *
+ * Return: Int
+ */
+int qed_int_get_sb_dbg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       struct qed_sb_info *p_sb, struct qed_sb_info_dbg *p_info);
+
 /**
  * qed_db_rec_handler(): Doorbell Recovery handler.
  *          Run doorbell recovery in case of PF overflow (and flush DORQ if
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 7673b3e07736..a18d2ea96b26 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2936,6 +2936,30 @@ static int qed_update_mtu(struct qed_dev *cdev, u16 mtu)
 	return status;
 }
 
+static int
+qed_get_sb_info(struct qed_dev *cdev, struct qed_sb_info *sb,
+		u16 qid, struct qed_sb_info_dbg *sb_dbg)
+{
+	struct qed_hwfn *hwfn = &cdev->hwfns[qid % cdev->num_hwfns];
+	struct qed_ptt *ptt;
+	int rc;
+
+	if (IS_VF(cdev))
+		return -EINVAL;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt) {
+		DP_NOTICE(hwfn, "Can't acquire PTT\n");
+		return -EAGAIN;
+	}
+
+	memset(sb_dbg, 0, sizeof(*sb_dbg));
+	rc = qed_int_get_sb_dbg(hwfn, ptt, sb, sb_dbg);
+
+	qed_ptt_release(hwfn, ptt);
+	return rc;
+}
+
 static int qed_read_module_eeprom(struct qed_dev *cdev, char *buf,
 				  u8 dev_addr, u32 offset, u32 len)
 {
@@ -2978,6 +3002,27 @@ static int qed_set_grc_config(struct qed_dev *cdev, u32 cfg_id, u32 val)
 	return rc;
 }
 
+static __printf(2, 3) void qed_mfw_report(struct qed_dev *cdev, char *fmt, ...)
+{
+	char buf[QED_MFW_REPORT_STR_SIZE];
+	struct qed_hwfn *p_hwfn;
+	struct qed_ptt *p_ptt;
+	va_list vl;
+
+	va_start(vl, fmt);
+	vsnprintf(buf, QED_MFW_REPORT_STR_SIZE, fmt, vl);
+	va_end(vl);
+
+	if (IS_PF(cdev)) {
+		p_hwfn = QED_LEADING_HWFN(cdev);
+		p_ptt = qed_ptt_acquire(p_hwfn);
+		if (p_ptt) {
+			qed_mcp_send_raw_debug_data(p_hwfn, p_ptt, buf, strlen(buf));
+			qed_ptt_release(p_hwfn, p_ptt);
+		}
+	}
+}
+
 static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 {
 	return QED_AFFIN_HWFN_IDX(cdev);
@@ -3038,6 +3083,8 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.read_nvm_cfg = &qed_nvm_flash_cfg_read,
 	.read_nvm_cfg_len = &qed_nvm_flash_cfg_len,
 	.set_grc_config = &qed_set_grc_config,
+	.mfw_report = &qed_mfw_report,
+	.get_sb_info = &qed_get_sb_info,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 564723800d15..2c28d5f86497 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -15,6 +15,8 @@
 #include "qed_hsi.h"
 #include "qed_dev_api.h"
 
+#define QED_MFW_REPORT_STR_SIZE	256
+
 struct qed_mcp_link_speed_params {
 	bool					autoneg;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
index 6f1a52e6beb2..b5e35f433a20 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
@@ -550,6 +550,8 @@
 		0x1 << 1)
 #define  IGU_REG_BLOCK_CONFIGURATION_PXP_TPH_INTERFACE_EN	( \
 		0x1 << 0)
+#define IGU_REG_PRODUCER_MEMORY 0x182000UL
+#define IGU_REG_CONSUMER_MEM 0x183000UL
 #define  IGU_REG_MAPPING_MEMORY \
 	0x184000UL
 #define IGU_REG_STATISTIC_NUM_VF_MSG_SENT \
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 06c6a5813606..f37604da79e9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -509,34 +509,98 @@ static int qede_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return 0;
 }
 
-static void qede_tx_log_print(struct qede_dev *edev, struct qede_tx_queue *txq)
+static void qede_fp_sb_dump(struct qede_dev *edev, struct qede_fastpath *fp)
 {
+	char *p_sb = (char *)fp->sb_info->sb_virt;
+	u32 sb_size, i;
+
+	sb_size = sizeof(struct status_block);
+
+	for (i = 0; i < sb_size; i += 8) {
+		DP_NOTICE(edev,
+			  "%02hhX %02hhX %02hhX %02hhX  %02hhX %02hhX %02hhX %02hhX\n",
+			  p_sb[i], p_sb[i + 1], p_sb[i + 2], p_sb[i + 3],
+			  p_sb[i + 4], p_sb[i + 5], p_sb[i + 6], p_sb[i + 7]);
+	}
+}
+
+static void
+qede_txq_fp_log_metadata(struct qede_dev *edev,
+			 struct qede_fastpath *fp, struct qede_tx_queue *txq)
+{
+	struct qed_chain *p_chain = &txq->tx_pbl;
+
+	/* Dump txq/fp/sb ids etc. other metadata */
 	DP_NOTICE(edev,
-		  "Txq[%d]: FW cons [host] %04x, SW cons %04x, SW prod %04x [Jiffies %lu]\n",
-		  txq->index, le16_to_cpu(*txq->hw_cons_ptr),
-		  qed_chain_get_cons_idx(&txq->tx_pbl),
-		  qed_chain_get_prod_idx(&txq->tx_pbl),
-		  jiffies);
+		  "fpid 0x%x sbid 0x%x txqid [0x%x] ndev_qid [0x%x] cos [0x%x] p_chain %p cap %d size %d jiffies %lu HZ 0x%x\n",
+		  fp->id, fp->sb_info->igu_sb_id, txq->index, txq->ndev_txq_id, txq->cos,
+		  p_chain, p_chain->capacity, p_chain->size, jiffies, HZ);
+
+	/* Dump all the relevant prod/cons indexes */
+	DP_NOTICE(edev,
+		  "hw cons %04x sw_tx_prod=0x%x, sw_tx_cons=0x%x, bd_prod 0x%x bd_cons 0x%x\n",
+		  le16_to_cpu(*txq->hw_cons_ptr), txq->sw_tx_prod, txq->sw_tx_cons,
+		  qed_chain_get_prod_idx(p_chain), qed_chain_get_cons_idx(p_chain));
+}
+
+static void
+qede_tx_log_print(struct qede_dev *edev, struct qede_fastpath *fp, struct qede_tx_queue *txq)
+{
+	struct qed_sb_info_dbg sb_dbg;
+	int rc;
+
+	/* sb info */
+	qede_fp_sb_dump(edev, fp);
+
+	memset(&sb_dbg, 0, sizeof(sb_dbg));
+	rc = edev->ops->common->get_sb_info(edev->cdev, fp->sb_info, (u16)fp->id, &sb_dbg);
+
+	DP_NOTICE(edev, "IGU: prod %08x cons %08x CAU Tx %04x\n",
+		  sb_dbg.igu_prod, sb_dbg.igu_cons, sb_dbg.pi[TX_PI(txq->cos)]);
+
+	/* report to mfw */
+	edev->ops->common->mfw_report(edev->cdev,
+				      "Txq[%d]: FW cons [host] %04x, SW cons %04x, SW prod %04x [Jiffies %lu]\n",
+				      txq->index, le16_to_cpu(*txq->hw_cons_ptr),
+				      qed_chain_get_cons_idx(&txq->tx_pbl),
+				      qed_chain_get_prod_idx(&txq->tx_pbl), jiffies);
+	if (!rc) {
+		edev->ops->common->mfw_report(edev->cdev,
+					      "Txq[%d]: SB[0x%04x] - IGU: prod %08x cons %08x CAU Tx %04x\n",
+					      txq->index, fp->sb_info->igu_sb_id,
+					      sb_dbg.igu_prod, sb_dbg.igu_cons,
+					      sb_dbg.pi[TX_PI(txq->cos)]);
+	}
 }
 
 static void qede_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_tx_queue *txq;
-	int cos;
+	int i;
 
 	netif_carrier_off(dev);
 	DP_NOTICE(edev, "TX timeout on queue %u!\n", txqueue);
 
-	if (!(edev->fp_array[txqueue].type & QEDE_FASTPATH_TX))
-		return;
+	for_each_queue(i) {
+		struct qede_tx_queue *txq;
+		struct qede_fastpath *fp;
+		int cos;
 
-	for_each_cos_in_txq(edev, cos) {
-		txq = &edev->fp_array[txqueue].txq[cos];
+		fp = &edev->fp_array[i];
+		if (!(fp->type & QEDE_FASTPATH_TX))
+			continue;
+
+		for_each_cos_in_txq(edev, cos) {
+			txq = &fp->txq[cos];
 
-		if (qed_chain_get_cons_idx(&txq->tx_pbl) !=
-		    qed_chain_get_prod_idx(&txq->tx_pbl))
-			qede_tx_log_print(edev, txq);
+			/* Dump basic metadata for all queues */
+			qede_txq_fp_log_metadata(edev, fp, txq);
+
+			if (qed_chain_get_cons_idx(&txq->tx_pbl) !=
+			    qed_chain_get_prod_idx(&txq->tx_pbl)) {
+				qede_tx_log_print(edev, fp, txq);
+			}
+		}
 	}
 
 	if (IS_VF(edev))
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 0dae7fcc5ef2..9f4bfa2a4829 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -807,6 +807,12 @@ struct qed_devlink {
 	struct devlink_health_reporter *fw_reporter;
 };
 
+struct qed_sb_info_dbg {
+	u32 igu_prod;
+	u32 igu_cons;
+	u16 pi[PIS_PER_SB];
+};
+
 struct qed_common_cb_ops {
 	void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);
 	void (*link_update)(void *dev, struct qed_link_output *link);
@@ -1194,6 +1200,11 @@ struct qed_common_ops {
 	struct devlink* (*devlink_register)(struct qed_dev *cdev);
 
 	void (*devlink_unregister)(struct devlink *devlink);
+
+	__printf(2, 3) void (*mfw_report)(struct qed_dev *cdev, char *fmt, ...);
+
+	int (*get_sb_info)(struct qed_dev *cdev, struct qed_sb_info *sb,
+			   u16 qid, struct qed_sb_info_dbg *sb_dbg);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
2.27.0

