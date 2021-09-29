Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB341C489
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343755AbhI2MRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:17:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47320 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343702AbhI2MQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TBKJhV014614;
        Wed, 29 Sep 2021 05:13:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=orVyzA16CjXSYivNnPOuSWRdM/+EtNJJmLIpciYux6I=;
 b=I2jxxv6B5c6v03dubbR0mJ8m0josTMmdrGm5g0I1Wm/p+gW7etBjgVT5IchxxVp79gJ1
 JpvqHxbfL+xjVHHF0K+ZsT9r5QjOBz7VKa6rXtzSyWPkJTPXmoqG81WtodPOV+YHmWgi
 LHNN4BCF1aMUtv7cmYkQC3wUrFDwx7tsaorKXvHCEo9qbsGzleoaPzAiWfZWSYwGV0e9
 uc0nwt/ZrMmDgUfy9lXyNKPWX7frIk+PAvAr7oJq9iDpefITmnVvSNSQk7nFiGuXTrIe
 MRb3A5bBYftNhWisCxFWZwYLR6NBVs1a5OdiGbRwrZr18Y9xW4gk2kLXctpCBolevpoc bA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bcq67g5yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:13:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:13:00 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:12:57 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 08/12] qed: Add '_GTT' suffix to the IRO RAM macros
Date:   Wed, 29 Sep 2021 15:12:11 +0300
Message-ID: <20210929121215.17864-9-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: h3GI10MW0d_tVcfcdg1HgIblfXlkJL8K
X-Proofpoint-GUID: h3GI10MW0d_tVcfcdg1HgIblfXlkJL8K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GTT (Global translation table) is a fast-access window in the BAR into
the register space, which only maps certain register addresses.
This change helps enforce that only those addresses which are indeed
mapped by the GTT are being accessed through it.

Adding the '_GTT' suffix to the IRO FW memory (“RAM”) macros that
access GTT-able region in FW memories (“RAM”) and use GTT macros
to access RAM BAR from drivers.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |   6 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    |  14 +-
 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h | 170 ++++++++++--------
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |  14 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |  11 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |  16 +-
 10 files changed, 143 insertions(+), 111 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 410c7f72e085..91d5ce75a549 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -945,6 +945,12 @@ void qed_db_recovery_dp(struct qed_hwfn *p_hwfn);
 void qed_db_recovery_execute(struct qed_hwfn *p_hwfn);
 bool qed_edpm_enabled(struct qed_hwfn *p_hwfn);
 
+#define GET_GTT_REG_ADDR(__base, __offset, __idx) \
+	((__base) + __offset ## _GTT_OFFSET((__idx)))
+
+#define GET_GTT_BDQ_REG_ADDR(__base, __offset, __idx, __bdq_idx) \
+	((__base) + __offset ## _GTT_OFFSET((__idx), (__bdq_idx)))
+
 /* Other Linux specific common definitions */
 #define DP_NAME(cdev) ((cdev)->name)
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index dad5cd219b0e..6823016ab5a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2477,9 +2477,8 @@ int qed_final_cleanup(struct qed_hwfn *p_hwfn,
 	u32 command = 0, addr, count = FINAL_CLEANUP_POLL_CNT;
 	int rc = -EBUSY;
 
-	addr = GTT_BAR0_MAP_REG_USDM_RAM +
-		USTORM_FLR_FINAL_ACK_OFFSET(p_hwfn->rel_pf_id);
-
+	addr = GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_USDM_RAM,
+				USTORM_FLR_FINAL_ACK, p_hwfn->rel_pf_id);
 	if (is_vf)
 		id += 0x10;
 
@@ -4968,7 +4967,7 @@ int qed_set_rxq_coalesce(struct qed_hwfn *p_hwfn,
 		goto out;
 
 	address = BAR0_MAP_REG_USDM_RAM +
-		  USTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
+		  USTORM_ETH_QUEUE_ZONE_GTT_OFFSET(p_cid->abs.queue_id);
 
 	rc = qed_set_coalesce(p_hwfn, p_ptt, address, &eth_qzone,
 			      sizeof(struct ustorm_eth_queue_zone), timeset);
@@ -5007,7 +5006,7 @@ int qed_set_txq_coalesce(struct qed_hwfn *p_hwfn,
 		goto out;
 
 	address = BAR0_MAP_REG_XSDM_RAM +
-		  XSTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
+		  XSTORM_ETH_QUEUE_ZONE_GTT_OFFSET(p_cid->abs.queue_id);
 
 	rc = qed_set_coalesce(p_hwfn, p_ptt, address, &eth_qzone,
 			      sizeof(struct xstorm_eth_queue_zone), timeset);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
index c46d809040bd..3764190b948e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
@@ -507,10 +507,9 @@ static void __iomem *qed_fcoe_get_primary_bdq_prod(struct qed_hwfn *p_hwfn,
 {
 	if (RESC_NUM(p_hwfn, QED_BDQ)) {
 		return (u8 __iomem *)p_hwfn->regview +
-		       GTT_BAR0_MAP_REG_MSDM_RAM +
-		       MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(RESC_START(p_hwfn,
-								  QED_BDQ),
-						       bdq_id);
+		    GET_GTT_BDQ_REG_ADDR(GTT_BAR0_MAP_REG_MSDM_RAM,
+					 MSTORM_SCSI_BDQ_EXT_PROD,
+					 RESC_START(p_hwfn, QED_BDQ), bdq_id);
 	} else {
 		DP_NOTICE(p_hwfn, "BDQ is not allocated!\n");
 		return NULL;
@@ -522,10 +521,9 @@ static void __iomem *qed_fcoe_get_secondary_bdq_prod(struct qed_hwfn *p_hwfn,
 {
 	if (RESC_NUM(p_hwfn, QED_BDQ)) {
 		return (u8 __iomem *)p_hwfn->regview +
-		       GTT_BAR0_MAP_REG_TSDM_RAM +
-		       TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(RESC_START(p_hwfn,
-								  QED_BDQ),
-						       bdq_id);
+		    GET_GTT_BDQ_REG_ADDR(GTT_BAR0_MAP_REG_TSDM_RAM,
+					 TSTORM_SCSI_BDQ_EXT_PROD,
+					 RESC_START(p_hwfn, QED_BDQ), bdq_id);
 	} else {
 		DP_NOTICE(p_hwfn, "BDQ is not allocated!\n");
 		return NULL;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
index ebee689676e7..3ccdd3b1d8cb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
@@ -9,14 +9,16 @@
 #include <linux/types.h>
 
 enum {
-	IRO_YSTORM_FLOW_CONTROL_MODE,
+	IRO_YSTORM_FLOW_CONTROL_MODE_GTT,
+	IRO_PSTORM_PKT_DUPLICATION_CFG,
 	IRO_TSTORM_PORT_STAT,
 	IRO_TSTORM_LL2_PORT_STAT,
-	IRO_USTORM_VF_PF_CHANNEL_READY,
-	IRO_USTORM_FLR_FINAL_ACK,
-	IRO_USTORM_EQE_CONS,
-	IRO_USTORM_ETH_QUEUE_ZONE,
-	IRO_USTORM_COMMON_QUEUE_CONS,
+	IRO_TSTORM_PKT_DUPLICATION_CFG,
+	IRO_USTORM_VF_PF_CHANNEL_READY_GTT,
+	IRO_USTORM_FLR_FINAL_ACK_GTT,
+	IRO_USTORM_EQE_CONS_GTT,
+	IRO_USTORM_ETH_QUEUE_ZONE_GTT,
+	IRO_USTORM_COMMON_QUEUE_CONS_GTT,
 	IRO_XSTORM_PQ_INFO,
 	IRO_XSTORM_INTEG_TEST_DATA,
 	IRO_YSTORM_INTEG_TEST_DATA,
@@ -30,30 +32,30 @@ enum {
 	IRO_TSTORM_OVERLAY_BUF_ADDR,
 	IRO_MSTORM_OVERLAY_BUF_ADDR,
 	IRO_USTORM_OVERLAY_BUF_ADDR,
-	IRO_TSTORM_LL2_RX_PRODS,
+	IRO_TSTORM_LL2_RX_PRODS_GTT,
 	IRO_CORE_LL2_TSTORM_PER_QUEUE_STAT,
 	IRO_CORE_LL2_USTORM_PER_QUEUE_STAT,
 	IRO_CORE_LL2_PSTORM_PER_QUEUE_STAT,
 	IRO_MSTORM_QUEUE_STAT,
 	IRO_MSTORM_TPA_TIMEOUT_US,
 	IRO_MSTORM_ETH_VF_PRODS,
-	IRO_MSTORM_ETH_PF_PRODS,
+	IRO_MSTORM_ETH_PF_PRODS_GTT,
 	IRO_MSTORM_ETH_PF_STAT,
 	IRO_USTORM_QUEUE_STAT,
 	IRO_USTORM_ETH_PF_STAT,
 	IRO_PSTORM_QUEUE_STAT,
 	IRO_PSTORM_ETH_PF_STAT,
-	IRO_PSTORM_CTL_FRAME_ETHTYPE,
+	IRO_PSTORM_CTL_FRAME_ETHTYPE_GTT,
 	IRO_TSTORM_ETH_PRS_INPUT,
 	IRO_ETH_RX_RATE_LIMIT,
-	IRO_TSTORM_ETH_RSS_UPDATE,
-	IRO_XSTORM_ETH_QUEUE_ZONE,
+	IRO_TSTORM_ETH_RSS_UPDATE_GTT,
+	IRO_XSTORM_ETH_QUEUE_ZONE_GTT,
 	IRO_YSTORM_TOE_CQ_PROD,
 	IRO_USTORM_TOE_CQ_PROD,
 	IRO_USTORM_TOE_GRQ_PROD,
-	IRO_TSTORM_SCSI_CMDQ_CONS,
-	IRO_TSTORM_SCSI_BDQ_EXT_PROD,
-	IRO_MSTORM_SCSI_BDQ_EXT_PROD,
+	IRO_TSTORM_SCSI_CMDQ_CONS_GTT,
+	IRO_TSTORM_SCSI_BDQ_EXT_PROD_GTT,
+	IRO_MSTORM_SCSI_BDQ_EXT_PROD_GTT,
 	IRO_TSTORM_ISCSI_RX_STATS,
 	IRO_MSTORM_ISCSI_RX_STATS,
 	IRO_USTORM_ISCSI_RX_STATS,
@@ -107,10 +109,10 @@ enum {
 #define ETH_RX_RATE_LIMIT_SIZE (IRO[IRO_ETH_RX_RATE_LIMIT].size)
 
 /* Mstorm ETH PF queues producers */
-#define MSTORM_ETH_PF_PRODS_OFFSET(queue_id) \
-	(IRO[IRO_MSTORM_ETH_PF_PRODS].base   \
-	 + ((queue_id) * IRO[IRO_MSTORM_ETH_PF_PRODS].m1))
-#define MSTORM_ETH_PF_PRODS_SIZE (IRO[IRO_MSTORM_ETH_PF_PRODS].size)
+#define MSTORM_ETH_PF_PRODS_GTT_OFFSET(queue_id) \
+	(IRO[IRO_MSTORM_ETH_PF_PRODS_GTT].base   \
+	 + ((queue_id) * IRO[IRO_MSTORM_ETH_PF_PRODS_GTT].m1))
+#define MSTORM_ETH_PF_PRODS_GTT_SIZE (IRO[IRO_MSTORM_ETH_PF_PRODS_GTT].size)
 
 /* Mstorm pf statistics */
 #define MSTORM_ETH_PF_STAT_OFFSET(pf_id)  \
@@ -154,21 +156,23 @@ enum {
 #define MSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_MSTORM_RDMA_ASSERT_LEVEL].size)
 
 /* Mstorm bdq-external-producer of given BDQ resource ID, BDqueue-id */
-#define MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id)      \
-	(IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].base                       \
-	 + ((storage_func_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].m1) \
-	 + ((bdq_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].m2))
-#define MSTORM_SCSI_BDQ_EXT_PROD_SIZE (IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].size)
+#define MSTORM_SCSI_BDQ_EXT_PROD_GTT_OFFSET(storage_func_id, bdq_id)      \
+	(IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD_GTT].base                       \
+	 + ((storage_func_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD_GTT].m1) \
+	 + ((bdq_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD_GTT].m2))
+#define MSTORM_SCSI_BDQ_EXT_PROD_GTT_SIZE \
+				(IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD_GTT].size)
 
 /* TPA agregation timeout in us resolution (on ASIC) */
 #define MSTORM_TPA_TIMEOUT_US_OFFSET (IRO[IRO_MSTORM_TPA_TIMEOUT_US].base)
 #define MSTORM_TPA_TIMEOUT_US_SIZE (IRO[IRO_MSTORM_TPA_TIMEOUT_US].size)
 
 /* Control frame's EthType configuration for TX control frame security */
-#define PSTORM_CTL_FRAME_ETHTYPE_OFFSET(ethtype_id) \
-	(IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].base     \
-	 + ((ethtype_id) * IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].m1))
-#define PSTORM_CTL_FRAME_ETHTYPE_SIZE (IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].size)
+#define PSTORM_CTL_FRAME_ETHTYPE_GTT_OFFSET(ethtype_id) \
+	(IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE_GTT].base     \
+	 + ((ethtype_id) * IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE_GTT].m1))
+#define PSTORM_CTL_FRAME_ETHTYPE_GTT_SIZE \
+				(IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE_GTT].size)
 
 /* Pstorm pf statistics */
 #define PSTORM_ETH_PF_STAT_OFFSET(pf_id)  \
@@ -196,6 +200,15 @@ enum {
 #define PSTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_PSTORM_OVERLAY_BUF_ADDR].base)
 #define PSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_PSTORM_OVERLAY_BUF_ADDR].size)
 
+/* Pstorm LL2 packet duplication configuration. Use pstorm_pkt_dup_cfg
+ * data type.
+ */
+#define PSTORM_PKT_DUPLICATION_CFG_OFFSET(pf_id) \
+	(IRO[IRO_PSTORM_PKT_DUPLICATION_CFG].base \
+	+ ((pf_id) * IRO[IRO_PSTORM_PKT_DUPLICATION_CFG].m1))
+#define PSTORM_PKT_DUPLICATION_CFG_SIZE \
+				(IRO[IRO_PSTORM_PKT_DUPLICATION_CFG].size)
+
 /* Pstorm queue statistics */
 #define PSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
 	(IRO[IRO_PSTORM_QUEUE_STAT].base          \
@@ -228,10 +241,11 @@ enum {
 /* RSS indirection table entry update command per PF offset in TSTORM PF BAR0.
  * Use eth_tstorm_rss_update_data for update.
  */
-#define TSTORM_ETH_RSS_UPDATE_OFFSET(pf_id)  \
-	(IRO[IRO_TSTORM_ETH_RSS_UPDATE].base \
-	 + ((pf_id) * IRO[IRO_TSTORM_ETH_RSS_UPDATE].m1))
-#define TSTORM_ETH_RSS_UPDATE_SIZE (IRO[IRO_TSTORM_ETH_RSS_UPDATE].size)
+#define TSTORM_ETH_RSS_UPDATE_GTT_OFFSET(pf_id)  \
+	(IRO[IRO_TSTORM_ETH_RSS_UPDATE_GTT].base \
+	 + ((pf_id) * IRO[IRO_TSTORM_ETH_RSS_UPDATE_GTT].m1))
+#define TSTORM_ETH_RSS_UPDATE_GTT_SIZE\
+				(IRO[IRO_TSTORM_ETH_RSS_UPDATE_GTT].size)
 
 /* Tstorm FCoE RX stats */
 #define TSTORM_FCOE_RX_STATS_OFFSET(pf_id)  \
@@ -256,16 +270,25 @@ enum {
 #define TSTORM_LL2_PORT_STAT_SIZE (IRO[IRO_TSTORM_LL2_PORT_STAT].size)
 
 /* Tstorm producers */
-#define TSTORM_LL2_RX_PRODS_OFFSET(core_rx_queue_id) \
-	(IRO[IRO_TSTORM_LL2_RX_PRODS].base           \
-	 + ((core_rx_queue_id) * IRO[IRO_TSTORM_LL2_RX_PRODS].m1))
-#define TSTORM_LL2_RX_PRODS_SIZE (IRO[IRO_TSTORM_LL2_RX_PRODS].size)
+#define TSTORM_LL2_RX_PRODS_GTT_OFFSET(core_rx_queue_id) \
+	(IRO[IRO_TSTORM_LL2_RX_PRODS_GTT].base           \
+	 + ((core_rx_queue_id) * IRO[IRO_TSTORM_LL2_RX_PRODS_GTT].m1))
+#define TSTORM_LL2_RX_PRODS_GTT_SIZE (IRO[IRO_TSTORM_LL2_RX_PRODS_GTT].size)
 
 /* Tstorm overlay buffer host address */
 #define TSTORM_OVERLAY_BUF_ADDR_OFFSET	(IRO[IRO_TSTORM_OVERLAY_BUF_ADDR].base)
 
 #define TSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_TSTORM_OVERLAY_BUF_ADDR].size)
 
+/* Tstorm LL2 packet duplication configuration.
+ * Use tstorm_pkt_dup_cfg data type.
+ */
+#define TSTORM_PKT_DUPLICATION_CFG_OFFSET(pf_id)  \
+	(IRO[IRO_TSTORM_PKT_DUPLICATION_CFG].base \
+	+ ((pf_id) * IRO[IRO_TSTORM_PKT_DUPLICATION_CFG].m1))
+#define TSTORM_PKT_DUPLICATION_CFG_SIZE \
+				(IRO[IRO_TSTORM_PKT_DUPLICATION_CFG].size)
+
 /* Tstorm port statistics */
 #define TSTORM_PORT_STAT_OFFSET(port_id) \
 	(IRO[IRO_TSTORM_PORT_STAT].base  \
@@ -293,29 +316,32 @@ enum {
 /* Tstorm (reflects M-Storm) bdq-external-producer of given function ID,
  * BDqueue-id.
  */
-#define TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id)      \
-	(IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].base                       \
-	 + ((storage_func_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].m1) \
-	 + ((bdq_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].m2))
-#define TSTORM_SCSI_BDQ_EXT_PROD_SIZE (IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].size)
+#define TSTORM_SCSI_BDQ_EXT_PROD_GTT_OFFSET(storage_func_id, bdq_id)      \
+	(IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD_GTT].base                       \
+	 + ((storage_func_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD_GTT].m1) \
+	 + ((bdq_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD_GTT].m2))
+#define TSTORM_SCSI_BDQ_EXT_PROD_GTT_SIZE \
+				(IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD_GTT].size)
 
 /* Tstorm cmdq-cons of given command queue-id */
-#define TSTORM_SCSI_CMDQ_CONS_OFFSET(cmdq_queue_id) \
-	(IRO[IRO_TSTORM_SCSI_CMDQ_CONS].base        \
-	 + ((cmdq_queue_id) * IRO[IRO_TSTORM_SCSI_CMDQ_CONS].m1))
-#define TSTORM_SCSI_CMDQ_CONS_SIZE (IRO[IRO_TSTORM_SCSI_CMDQ_CONS].size)
+#define TSTORM_SCSI_CMDQ_CONS_GTT_OFFSET(cmdq_queue_id) \
+	(IRO[IRO_TSTORM_SCSI_CMDQ_CONS_GTT].base        \
+	 + ((cmdq_queue_id) * IRO[IRO_TSTORM_SCSI_CMDQ_CONS_GTT].m1))
+#define TSTORM_SCSI_CMDQ_CONS_GTT_SIZE \
+				(IRO[IRO_TSTORM_SCSI_CMDQ_CONS_GTT].size)
 
 /* Ustorm Common Queue ring consumer */
-#define USTORM_COMMON_QUEUE_CONS_OFFSET(queue_zone_id) \
-	(IRO[IRO_USTORM_COMMON_QUEUE_CONS].base        \
-	 + ((queue_zone_id) * IRO[IRO_USTORM_COMMON_QUEUE_CONS].m1))
-#define USTORM_COMMON_QUEUE_CONS_SIZE (IRO[IRO_USTORM_COMMON_QUEUE_CONS].size)
+#define USTORM_COMMON_QUEUE_CONS_GTT_OFFSET(queue_zone_id) \
+	(IRO[IRO_USTORM_COMMON_QUEUE_CONS_GTT].base        \
+	 + ((queue_zone_id) * IRO[IRO_USTORM_COMMON_QUEUE_CONS_GTT].m1))
+#define USTORM_COMMON_QUEUE_CONS_GTT_SIZE \
+				(IRO[IRO_USTORM_COMMON_QUEUE_CONS_GTT].size)
 
 /* Ustorm Event ring consumer */
-#define USTORM_EQE_CONS_OFFSET(pf_id)  \
-	(IRO[IRO_USTORM_EQE_CONS].base \
-	 + ((pf_id) * IRO[IRO_USTORM_EQE_CONS].m1))
-#define USTORM_EQE_CONS_SIZE (IRO[IRO_USTORM_EQE_CONS].size)
+#define USTORM_EQE_CONS_GTT_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_EQE_CONS_GTT].base \
+	 + ((pf_id) * IRO[IRO_USTORM_EQE_CONS_GTT].m1))
+#define USTORM_EQE_CONS_GTT_SIZE (IRO[IRO_USTORM_EQE_CONS_GTT].size)
 
 /* Ustorm pf statistics */
 #define USTORM_ETH_PF_STAT_OFFSET(pf_id)  \
@@ -324,16 +350,16 @@ enum {
 #define USTORM_ETH_PF_STAT_SIZE	(IRO[IRO_USTORM_ETH_PF_STAT].size)
 
 /* Ustorm eth queue zone */
-#define USTORM_ETH_QUEUE_ZONE_OFFSET(queue_zone_id) \
-	(IRO[IRO_USTORM_ETH_QUEUE_ZONE].base        \
-	 + ((queue_zone_id) * IRO[IRO_USTORM_ETH_QUEUE_ZONE].m1))
-#define USTORM_ETH_QUEUE_ZONE_SIZE (IRO[IRO_USTORM_ETH_QUEUE_ZONE].size)
+#define USTORM_ETH_QUEUE_ZONE_GTT_OFFSET(queue_zone_id) \
+	(IRO[IRO_USTORM_ETH_QUEUE_ZONE_GTT].base        \
+	 + ((queue_zone_id) * IRO[IRO_USTORM_ETH_QUEUE_ZONE_GTT].m1))
+#define USTORM_ETH_QUEUE_ZONE_GTT_SIZE (IRO[IRO_USTORM_ETH_QUEUE_ZONE_GTT].size)
 
 /* Ustorm Final flr cleanup ack */
-#define USTORM_FLR_FINAL_ACK_OFFSET(pf_id)  \
-	(IRO[IRO_USTORM_FLR_FINAL_ACK].base \
-	 + ((pf_id) * IRO[IRO_USTORM_FLR_FINAL_ACK].m1))
-#define USTORM_FLR_FINAL_ACK_SIZE (IRO[IRO_USTORM_FLR_FINAL_ACK].size)
+#define USTORM_FLR_FINAL_ACK_GTT_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_FLR_FINAL_ACK_GTT].base \
+	 + ((pf_id) * IRO[IRO_USTORM_FLR_FINAL_ACK_GTT].m1))
+#define USTORM_FLR_FINAL_ACK_GTT_SIZE (IRO[IRO_USTORM_FLR_FINAL_ACK_GTT].size)
 
 /* Ustorm Integration Test Data */
 #define USTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_USTORM_INTEG_TEST_DATA].base)
@@ -380,17 +406,17 @@ enum {
 #define USTORM_TOE_GRQ_PROD_SIZE (IRO[IRO_USTORM_TOE_GRQ_PROD].size)
 
 /* Ustorm VF-PF Channel ready flag */
-#define USTORM_VF_PF_CHANNEL_READY_OFFSET(vf_id)  \
-	(IRO[IRO_USTORM_VF_PF_CHANNEL_READY].base \
-	 + ((vf_id) * IRO[IRO_USTORM_VF_PF_CHANNEL_READY].m1))
-#define USTORM_VF_PF_CHANNEL_READY_SIZE \
-				(IRO[IRO_USTORM_VF_PF_CHANNEL_READY].size)
+#define USTORM_VF_PF_CHANNEL_READY_GTT_OFFSET(vf_id)  \
+	(IRO[IRO_USTORM_VF_PF_CHANNEL_READY_GTT].base \
+	 + ((vf_id) * IRO[IRO_USTORM_VF_PF_CHANNEL_READY_GTT].m1))
+#define USTORM_VF_PF_CHANNEL_READY_GTT_SIZE \
+				(IRO[IRO_USTORM_VF_PF_CHANNEL_READY_GTT].size)
 
 /* Xstorm queue zone */
-#define XSTORM_ETH_QUEUE_ZONE_OFFSET(queue_id) \
-	(IRO[IRO_XSTORM_ETH_QUEUE_ZONE].base   \
-	 + ((queue_id) * IRO[IRO_XSTORM_ETH_QUEUE_ZONE].m1))
-#define XSTORM_ETH_QUEUE_ZONE_SIZE (IRO[IRO_XSTORM_ETH_QUEUE_ZONE].size)
+#define XSTORM_ETH_QUEUE_ZONE_GTT_OFFSET(queue_id) \
+	(IRO[IRO_XSTORM_ETH_QUEUE_ZONE_GTT].base   \
+	 + ((queue_id) * IRO[IRO_XSTORM_ETH_QUEUE_ZONE_GTT].m1))
+#define XSTORM_ETH_QUEUE_ZONE_GTT_SIZE (IRO[IRO_XSTORM_ETH_QUEUE_ZONE_GTT].size)
 
 /* Xstorm Integration Test Data */
 #define XSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_XSTORM_INTEG_TEST_DATA].base)
@@ -425,8 +451,10 @@ enum {
 #define XSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_XSTORM_RDMA_ASSERT_LEVEL].size)
 
 /* Ystorm flow control mode. Use enum fw_flow_ctrl_mode */
-#define YSTORM_FLOW_CONTROL_MODE_OFFSET (IRO[IRO_YSTORM_FLOW_CONTROL_MODE].base)
-#define YSTORM_FLOW_CONTROL_MODE_SIZE (IRO[IRO_YSTORM_FLOW_CONTROL_MODE].size)
+#define YSTORM_FLOW_CONTROL_MODE_GTT_OFFSET \
+				(IRO[IRO_YSTORM_FLOW_CONTROL_MODE_GTT].base)
+#define YSTORM_FLOW_CONTROL_MODE_GTT_SIZE \
+				(IRO[IRO_YSTORM_FLOW_CONTROL_MODE_GTT].size)
 
 /* Ystorm Integration Test Data */
 #define YSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_YSTORM_INTEG_TEST_DATA].base)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index b116b3183939..511ab214eb9c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -628,10 +628,9 @@ static void __iomem *qed_iscsi_get_primary_bdq_prod(struct qed_hwfn *p_hwfn,
 {
 	if (RESC_NUM(p_hwfn, QED_BDQ)) {
 		return (u8 __iomem *)p_hwfn->regview +
-		       GTT_BAR0_MAP_REG_MSDM_RAM +
-		       MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(RESC_START(p_hwfn,
-								  QED_BDQ),
-						       bdq_id);
+		    GET_GTT_BDQ_REG_ADDR(GTT_BAR0_MAP_REG_MSDM_RAM,
+					 MSTORM_SCSI_BDQ_EXT_PROD,
+					 RESC_START(p_hwfn, QED_BDQ), bdq_id);
 	} else {
 		DP_NOTICE(p_hwfn, "BDQ is not allocated!\n");
 		return NULL;
@@ -643,10 +642,9 @@ static void __iomem *qed_iscsi_get_secondary_bdq_prod(struct qed_hwfn *p_hwfn,
 {
 	if (RESC_NUM(p_hwfn, QED_BDQ)) {
 		return (u8 __iomem *)p_hwfn->regview +
-		       GTT_BAR0_MAP_REG_TSDM_RAM +
-		       TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(RESC_START(p_hwfn,
-								  QED_BDQ),
-						       bdq_id);
+		    GET_GTT_BDQ_REG_ADDR(GTT_BAR0_MAP_REG_TSDM_RAM,
+					 TSTORM_SCSI_BDQ_EXT_PROD,
+					 RESC_START(p_hwfn, QED_BDQ), bdq_id);
 	} else {
 		DP_NOTICE(p_hwfn, "BDQ is not allocated!\n");
 		return NULL;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 9b3850712797..a116fbc59725 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -904,9 +904,10 @@ qed_eth_pf_rx_queue_start(struct qed_hwfn *p_hwfn,
 {
 	u32 init_prod_val = 0;
 
-	*pp_prod = p_hwfn->regview +
-		   GTT_BAR0_MAP_REG_MSDM_RAM +
-		    MSTORM_ETH_PF_PRODS_OFFSET(p_cid->abs.queue_id);
+	*pp_prod = (u8 __iomem *)
+	    p_hwfn->regview +
+	    GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_MSDM_RAM,
+			     MSTORM_ETH_PF_PRODS, p_cid->abs.queue_id);
 
 	/* Init the rcq, rx bd and rx sge (if valid) producers to 0 */
 	__internal_ram_wr(p_hwfn, *pp_prod, sizeof(u32),
@@ -2099,7 +2100,7 @@ int qed_get_rxq_coalesce(struct qed_hwfn *p_hwfn,
 			      CAU_SB_ENTRY_TIMER_RES0);
 
 	address = BAR0_MAP_REG_USDM_RAM +
-		  USTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
+		  USTORM_ETH_QUEUE_ZONE_GTT_OFFSET(p_cid->abs.queue_id);
 	coalesce = qed_rd(p_hwfn, p_ptt, address);
 
 	is_valid = GET_FIELD(coalesce, COALESCING_TIMESET_VALID);
@@ -2133,7 +2134,7 @@ int qed_get_txq_coalesce(struct qed_hwfn *p_hwfn,
 			      CAU_SB_ENTRY_TIMER_RES1);
 
 	address = BAR0_MAP_REG_XSDM_RAM +
-		  XSTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
+		  XSTORM_ETH_QUEUE_ZONE_GTT_OFFSET(p_cid->abs.queue_id);
 	coalesce = qed_rd(p_hwfn, p_ptt, address);
 
 	is_valid = GET_FIELD(coalesce, COALESCING_TIMESET_VALID);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 5e586a1cf4aa..1a8c0df3d3dc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1620,8 +1620,10 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 		   p_hwfn->rel_pf_id, p_ll2_conn->input.rx_conn_type, qid);
 
 	if (p_ll2_conn->input.rx_conn_type == QED_LL2_RX_TYPE_LEGACY) {
-		p_rx->set_prod_addr = p_hwfn->regview +
-		    GTT_BAR0_MAP_REG_TSDM_RAM + TSTORM_LL2_RX_PRODS_OFFSET(qid);
+		p_rx->set_prod_addr =
+		    (u8 __iomem *)p_hwfn->regview +
+		    GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_TSDM_RAM,
+				     TSTORM_LL2_RX_PRODS, qid);
 	} else {
 		/* QED_LL2_RX_TYPE_CTX - using doorbell */
 		p_rx->ctx_based = 1;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 05658e66a20b..fe0bb11d0e43 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -865,8 +865,8 @@ static void qed_rdma_cnq_prod_update(void *rdma_cxt, u8 qz_offset, u16 prod)
 	}
 
 	qz_num = p_hwfn->p_rdma_info->queue_zone_base + qz_offset;
-	addr = GTT_BAR0_MAP_REG_USDM_RAM +
-	       USTORM_COMMON_QUEUE_CONS_OFFSET(qz_num);
+	addr = GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_USDM_RAM,
+				USTORM_COMMON_QUEUE_CONS, qz_num);
 
 	REG_WR16(p_hwfn, addr, prod);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index 65dbc08196b7..e0473729b161 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -313,8 +313,8 @@ qed_spq_unregister_async_cb(struct qed_hwfn *p_hwfn,
  ***************************************************************************/
 void qed_eq_prod_update(struct qed_hwfn *p_hwfn, u16 prod)
 {
-	u32 addr = GTT_BAR0_MAP_REG_USDM_RAM +
-		   USTORM_EQE_CONS_OFFSET(p_hwfn->rel_pf_id);
+	u32 addr = GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_USDM_RAM,
+				    USTORM_EQE_CONS, p_hwfn->rel_pf_id);
 
 	REG_WR16(p_hwfn, addr, prod);
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 47567441be3f..a020c92b4e5d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -1222,8 +1222,8 @@ static void qed_iov_send_response(struct qed_hwfn *p_hwfn,
 	 * channel would be re-set to ready prior to that.
 	 */
 	REG_WR(p_hwfn,
-	       GTT_BAR0_MAP_REG_USDM_RAM +
-	       USTORM_VF_PF_CHANNEL_READY_OFFSET(eng_vf_id), 1);
+	       GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_USDM_RAM,
+				USTORM_VF_PF_CHANNEL_READY, eng_vf_id), 1);
 
 	qed_dmae_host2host(p_hwfn, p_ptt, mbx->reply_phys,
 			   mbx->req_virt->first_tlv.reply_address,
@@ -2140,10 +2140,10 @@ static void qed_iov_vf_mbx_start_rxq(struct qed_hwfn *p_hwfn,
 	 * calculate on their own and clean the producer prior to this.
 	 */
 	if (!(vf_legacy & QED_QCID_LEGACY_VF_RX_PROD))
-		REG_WR(p_hwfn,
-		       GTT_BAR0_MAP_REG_MSDM_RAM +
-		       MSTORM_ETH_VF_PRODS_OFFSET(vf->abs_vf_id, req->rx_qid),
-		       0);
+		qed_wr(p_hwfn, p_ptt, MSEM_REG_FAST_MEMORY +
+		       SEM_FAST_REG_INT_RAM +
+		       MSTORM_ETH_VF_PRODS_OFFSET(vf->abs_vf_id,
+						  req->rx_qid), 0);
 
 	rc = qed_eth_rxq_start_ramrod(p_hwfn, p_cid,
 				      req->bd_max_bytes,
@@ -3708,8 +3708,8 @@ qed_iov_execute_vf_flr_cleanup(struct qed_hwfn *p_hwfn,
 		 * doesn't do that as a part of FLR.
 		 */
 		REG_WR(p_hwfn,
-		       GTT_BAR0_MAP_REG_USDM_RAM +
-		       USTORM_VF_PF_CHANNEL_READY_OFFSET(vfid), 1);
+		       GET_GTT_REG_ADDR(GTT_BAR0_MAP_REG_USDM_RAM,
+					USTORM_VF_PF_CHANNEL_READY, vfid), 1);
 
 		/* VF_STOPPED has to be set only after final cleanup
 		 * but prior to re-enabling the VF.
-- 
2.24.1

