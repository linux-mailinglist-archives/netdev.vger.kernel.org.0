Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E766E41C47B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343737AbhI2MRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:17:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343733AbhI2MQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8e1Cw008266;
        Wed, 29 Sep 2021 05:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zE7iLQ6UEa4gLZsW0qUpAEqEs8YLquffIEABf1CEG04=;
 b=JX1KUnHVJIc2KXZT+lYK3BZxHYj4cv/UOYc4qoOLllSV2oZ2DiaEVd1kPshLaOTssUGy
 MpSpt1ndlG+A/o6/9wH85Lw5CO785zlYLv0DdHOQxaFIIDHQSbJOPWyiz9Xz1BkatF5c
 MbXuHYvANHlG73+MMFCMB0Z86mWYICRsEkqIJNZ7RAacxBx+ticHHhLEGd31t6LIMPlf
 mi6l+lcQ87C/ZoTBL7wA84+zvTX5PozEL05ye9tB+E4q/keOM/qtvvkgQpmiEtfGHuYD
 cyP1DlL9PyZ84nfpIByKxyS5qIMxyIoBhQ8+P9cD+fTW8RxoEogRlkk/H7vqpYzDobZY Yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bcfd4a0a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:12:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:12:51 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:12:48 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 06/12] qed: Use enum as per FW 8.59.1.0 in qed_iro_hsi.h
Date:   Wed, 29 Sep 2021 15:12:09 +0300
Message-ID: <20210929121215.17864-7-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: yBCazWW2KTC5H0PDyN6m7IWVF46YWmv6
X-Proofpoint-ORIG-GUID: yBCazWW2KTC5H0PDyN6m7IWVF46YWmv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_iro_hsi.h contains HSI changes related to storm memories access.
Existing code is based on hard-coded index.
Use enum as defined for FW HSI 8.59.1.0, instead of hard-coded index.

This patch also removes unnecessary header file inclusion.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h | 647 +++++++++++-------
 1 file changed, 390 insertions(+), 257 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
index 4999d524930f..ebee689676e7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
@@ -8,332 +8,465 @@
 
 #include <linux/types.h>
 
-/* Ystorm flow control mode. Use enum fw_flow_ctrl_mode */
-#define YSTORM_FLOW_CONTROL_MODE_OFFSET			(IRO[0].base)
-#define YSTORM_FLOW_CONTROL_MODE_SIZE			(IRO[0].size)
+enum {
+	IRO_YSTORM_FLOW_CONTROL_MODE,
+	IRO_TSTORM_PORT_STAT,
+	IRO_TSTORM_LL2_PORT_STAT,
+	IRO_USTORM_VF_PF_CHANNEL_READY,
+	IRO_USTORM_FLR_FINAL_ACK,
+	IRO_USTORM_EQE_CONS,
+	IRO_USTORM_ETH_QUEUE_ZONE,
+	IRO_USTORM_COMMON_QUEUE_CONS,
+	IRO_XSTORM_PQ_INFO,
+	IRO_XSTORM_INTEG_TEST_DATA,
+	IRO_YSTORM_INTEG_TEST_DATA,
+	IRO_PSTORM_INTEG_TEST_DATA,
+	IRO_TSTORM_INTEG_TEST_DATA,
+	IRO_MSTORM_INTEG_TEST_DATA,
+	IRO_USTORM_INTEG_TEST_DATA,
+	IRO_XSTORM_OVERLAY_BUF_ADDR,
+	IRO_YSTORM_OVERLAY_BUF_ADDR,
+	IRO_PSTORM_OVERLAY_BUF_ADDR,
+	IRO_TSTORM_OVERLAY_BUF_ADDR,
+	IRO_MSTORM_OVERLAY_BUF_ADDR,
+	IRO_USTORM_OVERLAY_BUF_ADDR,
+	IRO_TSTORM_LL2_RX_PRODS,
+	IRO_CORE_LL2_TSTORM_PER_QUEUE_STAT,
+	IRO_CORE_LL2_USTORM_PER_QUEUE_STAT,
+	IRO_CORE_LL2_PSTORM_PER_QUEUE_STAT,
+	IRO_MSTORM_QUEUE_STAT,
+	IRO_MSTORM_TPA_TIMEOUT_US,
+	IRO_MSTORM_ETH_VF_PRODS,
+	IRO_MSTORM_ETH_PF_PRODS,
+	IRO_MSTORM_ETH_PF_STAT,
+	IRO_USTORM_QUEUE_STAT,
+	IRO_USTORM_ETH_PF_STAT,
+	IRO_PSTORM_QUEUE_STAT,
+	IRO_PSTORM_ETH_PF_STAT,
+	IRO_PSTORM_CTL_FRAME_ETHTYPE,
+	IRO_TSTORM_ETH_PRS_INPUT,
+	IRO_ETH_RX_RATE_LIMIT,
+	IRO_TSTORM_ETH_RSS_UPDATE,
+	IRO_XSTORM_ETH_QUEUE_ZONE,
+	IRO_YSTORM_TOE_CQ_PROD,
+	IRO_USTORM_TOE_CQ_PROD,
+	IRO_USTORM_TOE_GRQ_PROD,
+	IRO_TSTORM_SCSI_CMDQ_CONS,
+	IRO_TSTORM_SCSI_BDQ_EXT_PROD,
+	IRO_MSTORM_SCSI_BDQ_EXT_PROD,
+	IRO_TSTORM_ISCSI_RX_STATS,
+	IRO_MSTORM_ISCSI_RX_STATS,
+	IRO_USTORM_ISCSI_RX_STATS,
+	IRO_XSTORM_ISCSI_TX_STATS,
+	IRO_YSTORM_ISCSI_TX_STATS,
+	IRO_PSTORM_ISCSI_TX_STATS,
+	IRO_TSTORM_FCOE_RX_STATS,
+	IRO_PSTORM_FCOE_TX_STATS,
+	IRO_PSTORM_RDMA_QUEUE_STAT,
+	IRO_TSTORM_RDMA_QUEUE_STAT,
+	IRO_XSTORM_RDMA_ASSERT_LEVEL,
+	IRO_YSTORM_RDMA_ASSERT_LEVEL,
+	IRO_PSTORM_RDMA_ASSERT_LEVEL,
+	IRO_TSTORM_RDMA_ASSERT_LEVEL,
+	IRO_MSTORM_RDMA_ASSERT_LEVEL,
+	IRO_USTORM_RDMA_ASSERT_LEVEL,
+	IRO_XSTORM_IWARP_RXMIT_STATS,
+	IRO_TSTORM_ROCE_EVENTS_STAT,
+	IRO_YSTORM_ROCE_DCQCN_RECEIVED_STATS,
+	IRO_YSTORM_ROCE_ERROR_STATS,
+	IRO_PSTORM_ROCE_DCQCN_SENT_STATS,
+	IRO_USTORM_ROCE_CQE_STATS,
+};
 
-/* Tstorm port statistics */
-#define TSTORM_PORT_STAT_OFFSET(port_id) \
-	(IRO[1].base + ((port_id) * IRO[1].m1))
-#define TSTORM_PORT_STAT_SIZE				(IRO[1].size)
+/* Pstorm LiteL2 queue statistics */
 
-/* Tstorm ll2 port statistics */
-#define TSTORM_LL2_PORT_STAT_OFFSET(port_id) \
-	(IRO[2].base + ((port_id) * IRO[2].m1))
-#define TSTORM_LL2_PORT_STAT_SIZE			(IRO[2].size)
+#define CORE_LL2_PSTORM_PER_QUEUE_STAT_OFFSET(core_tx_stats_id) \
+	(IRO[IRO_CORE_LL2_PSTORM_PER_QUEUE_STAT].base           \
+	+ ((core_tx_stats_id) * IRO[IRO_CORE_LL2_PSTORM_PER_QUEUE_STAT].m1))
+#define CORE_LL2_PSTORM_PER_QUEUE_STAT_SIZE \
+				(IRO[IRO_CORE_LL2_PSTORM_PER_QUEUE_STAT].size)
 
-/* Ustorm VF-PF Channel ready flag */
-#define USTORM_VF_PF_CHANNEL_READY_OFFSET(vf_id) \
-	(IRO[3].base + ((vf_id) * IRO[3].m1))
-#define USTORM_VF_PF_CHANNEL_READY_SIZE			(IRO[3].size)
+/* Tstorm LightL2 queue statistics */
+#define CORE_LL2_TSTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
+	(IRO[IRO_CORE_LL2_TSTORM_PER_QUEUE_STAT].base           \
+	 + ((core_rx_queue_id) * IRO[IRO_CORE_LL2_TSTORM_PER_QUEUE_STAT].m1))
+#define CORE_LL2_TSTORM_PER_QUEUE_STAT_SIZE \
+				(IRO[IRO_CORE_LL2_TSTORM_PER_QUEUE_STAT].size)
 
-/* Ustorm Final flr cleanup ack */
-#define USTORM_FLR_FINAL_ACK_OFFSET(pf_id) \
-	(IRO[4].base + ((pf_id) * IRO[4].m1))
-#define USTORM_FLR_FINAL_ACK_SIZE			(IRO[4].size)
+/* Ustorm LiteL2 queue statistics */
+#define CORE_LL2_USTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
+	(IRO[IRO_CORE_LL2_USTORM_PER_QUEUE_STAT].base           \
+	 + ((core_rx_queue_id) * IRO[IRO_CORE_LL2_USTORM_PER_QUEUE_STAT].m1))
+#define CORE_LL2_USTORM_PER_QUEUE_STAT_SIZE \
+				(IRO[IRO_CORE_LL2_USTORM_PER_QUEUE_STAT].size)
 
-/* Ustorm Event ring consumer */
-#define USTORM_EQE_CONS_OFFSET(pf_id) \
-	(IRO[5].base + ((pf_id) * IRO[5].m1))
-#define USTORM_EQE_CONS_SIZE				(IRO[5].size)
+/* Tstorm Eth limit Rx rate */
+#define ETH_RX_RATE_LIMIT_OFFSET(pf_id)  \
+	(IRO[IRO_ETH_RX_RATE_LIMIT].base \
+	 + ((pf_id) * IRO[IRO_ETH_RX_RATE_LIMIT].m1))
+#define ETH_RX_RATE_LIMIT_SIZE (IRO[IRO_ETH_RX_RATE_LIMIT].size)
 
-/* Ustorm eth queue zone */
-#define USTORM_ETH_QUEUE_ZONE_OFFSET(queue_zone_id) \
-	(IRO[6].base + ((queue_zone_id) * IRO[6].m1))
-#define USTORM_ETH_QUEUE_ZONE_SIZE			(IRO[6].size)
+/* Mstorm ETH PF queues producers */
+#define MSTORM_ETH_PF_PRODS_OFFSET(queue_id) \
+	(IRO[IRO_MSTORM_ETH_PF_PRODS].base   \
+	 + ((queue_id) * IRO[IRO_MSTORM_ETH_PF_PRODS].m1))
+#define MSTORM_ETH_PF_PRODS_SIZE (IRO[IRO_MSTORM_ETH_PF_PRODS].size)
 
-/* Ustorm Common Queue ring consumer */
-#define USTORM_COMMON_QUEUE_CONS_OFFSET(queue_zone_id) \
-	(IRO[7].base + ((queue_zone_id) * IRO[7].m1))
-#define USTORM_COMMON_QUEUE_CONS_SIZE			(IRO[7].size)
+/* Mstorm pf statistics */
+#define MSTORM_ETH_PF_STAT_OFFSET(pf_id)  \
+	(IRO[IRO_MSTORM_ETH_PF_STAT].base \
+	 + ((pf_id) * IRO[IRO_MSTORM_ETH_PF_STAT].m1))
+#define MSTORM_ETH_PF_STAT_SIZE (IRO[IRO_MSTORM_ETH_PF_STAT].size)
 
-/* Xstorm common PQ info */
-#define XSTORM_PQ_INFO_OFFSET(pq_id) \
-	(IRO[8].base + ((pq_id) * IRO[8].m1))
-#define XSTORM_PQ_INFO_SIZE				(IRO[8].size)
+/* Mstorm ETH VF queues producers offset in RAM. Used in default VF zone
+ * size mode.
+ */
+#define MSTORM_ETH_VF_PRODS_OFFSET(vf_id, vf_queue_id) \
+	(IRO[IRO_MSTORM_ETH_VF_PRODS].base             \
+	 + ((vf_id) * IRO[IRO_MSTORM_ETH_VF_PRODS].m1) \
+	 + ((vf_queue_id) * IRO[IRO_MSTORM_ETH_VF_PRODS].m2))
+#define MSTORM_ETH_VF_PRODS_SIZE (IRO[IRO_MSTORM_ETH_VF_PRODS].size)
 
-/* Xstorm Integration Test Data */
-#define XSTORM_INTEG_TEST_DATA_OFFSET			(IRO[9].base)
-#define XSTORM_INTEG_TEST_DATA_SIZE			(IRO[9].size)
+/* Mstorm Integration Test Data */
+#define MSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_MSTORM_INTEG_TEST_DATA].base)
+#define MSTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_MSTORM_INTEG_TEST_DATA].size)
 
-/* Ystorm Integration Test Data */
-#define YSTORM_INTEG_TEST_DATA_OFFSET			(IRO[10].base)
-#define YSTORM_INTEG_TEST_DATA_SIZE			(IRO[10].size)
+/* Mstorm iSCSI RX stats */
+#define MSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
+	(IRO[IRO_MSTORM_ISCSI_RX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_MSTORM_ISCSI_RX_STATS].m1))
+#define MSTORM_ISCSI_RX_STATS_SIZE (IRO[IRO_MSTORM_ISCSI_RX_STATS].size)
 
-/* Pstorm Integration Test Data */
-#define PSTORM_INTEG_TEST_DATA_OFFSET			(IRO[11].base)
-#define PSTORM_INTEG_TEST_DATA_SIZE			(IRO[11].size)
+/* Mstorm overlay buffer host address */
+#define MSTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_MSTORM_OVERLAY_BUF_ADDR].base)
+#define MSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_MSTORM_OVERLAY_BUF_ADDR].size)
 
-/* Tstorm Integration Test Data */
-#define TSTORM_INTEG_TEST_DATA_OFFSET			(IRO[12].base)
-#define TSTORM_INTEG_TEST_DATA_SIZE			(IRO[12].size)
+/* Mstorm queue statistics */
+#define MSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
+	(IRO[IRO_MSTORM_QUEUE_STAT].base          \
+	 + ((stat_counter_id) * IRO[IRO_MSTORM_QUEUE_STAT].m1))
+#define MSTORM_QUEUE_STAT_SIZ (IRO[IRO_MSTORM_QUEUE_STAT].size)
 
-/* Mstorm Integration Test Data */
-#define MSTORM_INTEG_TEST_DATA_OFFSET			(IRO[13].base)
-#define MSTORM_INTEG_TEST_DATA_SIZE			(IRO[13].size)
+/* Mstorm error level for assert */
+#define MSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_MSTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_MSTORM_RDMA_ASSERT_LEVEL].m1))
+#define MSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_MSTORM_RDMA_ASSERT_LEVEL].size)
 
-/* Ustorm Integration Test Data */
-#define USTORM_INTEG_TEST_DATA_OFFSET			(IRO[14].base)
-#define USTORM_INTEG_TEST_DATA_SIZE			(IRO[14].size)
+/* Mstorm bdq-external-producer of given BDQ resource ID, BDqueue-id */
+#define MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id)      \
+	(IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].base                       \
+	 + ((storage_func_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].m1) \
+	 + ((bdq_id) * IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].m2))
+#define MSTORM_SCSI_BDQ_EXT_PROD_SIZE (IRO[IRO_MSTORM_SCSI_BDQ_EXT_PROD].size)
 
-/* Xstorm overlay buffer host address */
-#define XSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[15].base)
-#define XSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[15].size)
+/* TPA agregation timeout in us resolution (on ASIC) */
+#define MSTORM_TPA_TIMEOUT_US_OFFSET (IRO[IRO_MSTORM_TPA_TIMEOUT_US].base)
+#define MSTORM_TPA_TIMEOUT_US_SIZE (IRO[IRO_MSTORM_TPA_TIMEOUT_US].size)
 
-/* Ystorm overlay buffer host address */
-#define YSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[16].base)
-#define YSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[16].size)
+/* Control frame's EthType configuration for TX control frame security */
+#define PSTORM_CTL_FRAME_ETHTYPE_OFFSET(ethtype_id) \
+	(IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].base     \
+	 + ((ethtype_id) * IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].m1))
+#define PSTORM_CTL_FRAME_ETHTYPE_SIZE (IRO[IRO_PSTORM_CTL_FRAME_ETHTYPE].size)
 
-/* Pstorm overlay buffer host address */
-#define PSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[17].base)
-#define PSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[17].size)
+/* Pstorm pf statistics */
+#define PSTORM_ETH_PF_STAT_OFFSET(pf_id)  \
+	(IRO[IRO_PSTORM_ETH_PF_STAT].base \
+	 + ((pf_id) * IRO[IRO_PSTORM_ETH_PF_STAT].m1))
+#define PSTORM_ETH_PF_STAT_SIZE (IRO[IRO_PSTORM_ETH_PF_STAT].size)
 
-/* Tstorm overlay buffer host address */
-#define TSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[18].base)
-#define TSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[18].size)
+/* Pstorm FCoE TX stats */
+#define PSTORM_FCOE_TX_STATS_OFFSET(pf_id)  \
+	(IRO[IRO_PSTORM_FCOE_TX_STATS].base \
+	 + ((pf_id) * IRO[IRO_PSTORM_FCOE_TX_STATS].m1))
+#define PSTORM_FCOE_TX_STATS_SIZE (IRO[IRO_PSTORM_FCOE_TX_STATS].size)
 
-/* Mstorm overlay buffer host address */
-#define MSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[19].base)
-#define MSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[19].size)
+/* Pstorm Integration Test Data */
+#define PSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_PSTORM_INTEG_TEST_DATA].base)
+#define PSTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_PSTORM_INTEG_TEST_DATA].size)
 
-/* Ustorm overlay buffer host address */
-#define USTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[20].base)
-#define USTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[20].size)
+/* Pstorm iSCSI TX stats */
+#define PSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[IRO_PSTORM_ISCSI_TX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_PSTORM_ISCSI_TX_STATS].m1))
+#define PSTORM_ISCSI_TX_STATS_SIZE (IRO[IRO_PSTORM_ISCSI_TX_STATS].size)
 
-/* Tstorm producers */
-#define TSTORM_LL2_RX_PRODS_OFFSET(core_rx_queue_id) \
-	(IRO[21].base + ((core_rx_queue_id) * IRO[21].m1))
-#define TSTORM_LL2_RX_PRODS_SIZE			(IRO[21].size)
+/* Pstorm overlay buffer host address */
+#define PSTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_PSTORM_OVERLAY_BUF_ADDR].base)
+#define PSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_PSTORM_OVERLAY_BUF_ADDR].size)
 
-/* Tstorm LightL2 queue statistics */
-#define CORE_LL2_TSTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
-	(IRO[22].base + ((core_rx_queue_id) * IRO[22].m1))
-#define CORE_LL2_TSTORM_PER_QUEUE_STAT_SIZE		(IRO[22].size)
+/* Pstorm queue statistics */
+#define PSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
+	(IRO[IRO_PSTORM_QUEUE_STAT].base          \
+	 + ((stat_counter_id) * IRO[IRO_PSTORM_QUEUE_STAT].m1))
+#define PSTORM_QUEUE_STAT_SIZE (IRO[IRO_PSTORM_QUEUE_STAT].size)
 
-/* Ustorm LiteL2 queue statistics */
-#define CORE_LL2_USTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
-	(IRO[23].base + ((core_rx_queue_id) * IRO[23].m1))
-#define CORE_LL2_USTORM_PER_QUEUE_STAT_SIZE		(IRO[23].size)
+/* Pstorm error level for assert */
+#define PSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_PSTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_PSTORM_RDMA_ASSERT_LEVEL].m1))
+#define PSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_PSTORM_RDMA_ASSERT_LEVEL].size)
 
-/* Pstorm LiteL2 queue statistics */
-#define CORE_LL2_PSTORM_PER_QUEUE_STAT_OFFSET(core_tx_stats_id) \
-	(IRO[24].base + ((core_tx_stats_id) * IRO[24].m1))
-#define CORE_LL2_PSTORM_PER_QUEUE_STAT_SIZE		(IRO[24].size)
+/* Pstorm RDMA queue statistics */
+#define PSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
+	(IRO[IRO_PSTORM_RDMA_QUEUE_STAT].base               \
+	 + ((rdma_stat_counter_id) * IRO[IRO_PSTORM_RDMA_QUEUE_STAT].m1))
+#define PSTORM_RDMA_QUEUE_STAT_SIZE (IRO[IRO_PSTORM_RDMA_QUEUE_STAT].size)
 
-/* Mstorm queue statistics */
-#define MSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
-	(IRO[25].base + ((stat_counter_id) * IRO[25].m1))
-#define MSTORM_QUEUE_STAT_SIZE				(IRO[25].size)
+/* DCQCN Sent Statistics */
+#define PSTORM_ROCE_DCQCN_SENT_STATS_OFFSET(roce_pf_id) \
+	(IRO[IRO_PSTORM_ROCE_DCQCN_SENT_STATS].base     \
+	 + ((roce_pf_id) * IRO[IRO_PSTORM_ROCE_DCQCN_SENT_STATS].m1))
+#define PSTORM_ROCE_DCQCN_SENT_STATS_SIZE \
+				(IRO[IRO_PSTORM_ROCE_DCQCN_SENT_STATS].size)
 
-/* TPA agregation timeout in us resolution (on ASIC) */
-#define MSTORM_TPA_TIMEOUT_US_OFFSET			(IRO[26].base)
-#define MSTORM_TPA_TIMEOUT_US_SIZE			(IRO[26].size)
+/* Tstorm last parser message */
+#define TSTORM_ETH_PRS_INPUT_OFFSET (IRO[IRO_TSTORM_ETH_PRS_INPUT].base)
+#define TSTORM_ETH_PRS_INPUT_SIZE (IRO[IRO_TSTORM_ETH_PRS_INPUT].size)
 
-/* Mstorm ETH VF queues producers offset in RAM. Used in default VF zone size
- * mode
+/* RSS indirection table entry update command per PF offset in TSTORM PF BAR0.
+ * Use eth_tstorm_rss_update_data for update.
  */
-#define MSTORM_ETH_VF_PRODS_OFFSET(vf_id, vf_queue_id) \
-	(IRO[27].base + ((vf_id) * IRO[27].m1) + ((vf_queue_id) * IRO[27].m2))
-#define MSTORM_ETH_VF_PRODS_SIZE			(IRO[27].size)
-
-/* Mstorm ETH PF queues producers */
-#define MSTORM_ETH_PF_PRODS_OFFSET(queue_id) \
-	(IRO[28].base + ((queue_id) * IRO[28].m1))
-#define MSTORM_ETH_PF_PRODS_SIZE			(IRO[28].size)
+#define TSTORM_ETH_RSS_UPDATE_OFFSET(pf_id)  \
+	(IRO[IRO_TSTORM_ETH_RSS_UPDATE].base \
+	 + ((pf_id) * IRO[IRO_TSTORM_ETH_RSS_UPDATE].m1))
+#define TSTORM_ETH_RSS_UPDATE_SIZE (IRO[IRO_TSTORM_ETH_RSS_UPDATE].size)
 
-/* Mstorm pf statistics */
-#define MSTORM_ETH_PF_STAT_OFFSET(pf_id) \
-	(IRO[29].base + ((pf_id) * IRO[29].m1))
-#define MSTORM_ETH_PF_STAT_SIZE				(IRO[29].size)
-
-/* Ustorm queue statistics */
-#define USTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
-	(IRO[30].base + ((stat_counter_id) * IRO[30].m1))
-#define USTORM_QUEUE_STAT_SIZE				(IRO[30].size)
+/* Tstorm FCoE RX stats */
+#define TSTORM_FCOE_RX_STATS_OFFSET(pf_id)  \
+	(IRO[IRO_TSTORM_FCOE_RX_STATS].base \
+	 + ((pf_id) * IRO[IRO_TSTORM_FCOE_RX_STATS].m1))
+#define TSTORM_FCOE_RX_STATS_SIZE (IRO[IRO_TSTORM_FCOE_RX_STATS].size)
 
-/* Ustorm pf statistics */
-#define USTORM_ETH_PF_STAT_OFFSET(pf_id) \
-	(IRO[31].base + ((pf_id) * IRO[31].m1))
-#define USTORM_ETH_PF_STAT_SIZE				(IRO[31].size)
+/* Tstorm Integration Test Data */
+#define TSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_TSTORM_INTEG_TEST_DATA].base)
+#define TSTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_TSTORM_INTEG_TEST_DATA].size)
 
-/* Pstorm queue statistics */
-#define PSTORM_QUEUE_STAT_OFFSET(stat_counter_id)	\
-	(IRO[32].base + ((stat_counter_id) * IRO[32].m1))
-#define PSTORM_QUEUE_STAT_SIZE				(IRO[32].size)
+/* Tstorm iSCSI RX stats */
+#define TSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
+	(IRO[IRO_TSTORM_ISCSI_RX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_TSTORM_ISCSI_RX_STATS].m1))
+#define TSTORM_ISCSI_RX_STATS_SIZE (IRO[IRO_TSTORM_ISCSI_RX_STATS].size)
 
-/* Pstorm pf statistics */
-#define PSTORM_ETH_PF_STAT_OFFSET(pf_id) \
-	(IRO[33].base + ((pf_id) * IRO[33].m1))
-#define PSTORM_ETH_PF_STAT_SIZE				(IRO[33].size)
+/* Tstorm ll2 port statistics */
+#define TSTORM_LL2_PORT_STAT_OFFSET(port_id) \
+	(IRO[IRO_TSTORM_LL2_PORT_STAT].base  \
+	 + ((port_id) * IRO[IRO_TSTORM_LL2_PORT_STAT].m1))
+#define TSTORM_LL2_PORT_STAT_SIZE (IRO[IRO_TSTORM_LL2_PORT_STAT].size)
 
-/* Control frame's EthType configuration for TX control frame security */
-#define PSTORM_CTL_FRAME_ETHTYPE_OFFSET(eth_type_id)	\
-	(IRO[34].base + ((eth_type_id) * IRO[34].m1))
-#define PSTORM_CTL_FRAME_ETHTYPE_SIZE			(IRO[34].size)
+/* Tstorm producers */
+#define TSTORM_LL2_RX_PRODS_OFFSET(core_rx_queue_id) \
+	(IRO[IRO_TSTORM_LL2_RX_PRODS].base           \
+	 + ((core_rx_queue_id) * IRO[IRO_TSTORM_LL2_RX_PRODS].m1))
+#define TSTORM_LL2_RX_PRODS_SIZE (IRO[IRO_TSTORM_LL2_RX_PRODS].size)
 
-/* Tstorm last parser message */
-#define TSTORM_ETH_PRS_INPUT_OFFSET			(IRO[35].base)
-#define TSTORM_ETH_PRS_INPUT_SIZE			(IRO[35].size)
+/* Tstorm overlay buffer host address */
+#define TSTORM_OVERLAY_BUF_ADDR_OFFSET	(IRO[IRO_TSTORM_OVERLAY_BUF_ADDR].base)
 
-/* Tstorm Eth limit Rx rate */
-#define ETH_RX_RATE_LIMIT_OFFSET(pf_id)	\
-	(IRO[36].base + ((pf_id) * IRO[36].m1))
-#define ETH_RX_RATE_LIMIT_SIZE				(IRO[36].size)
+#define TSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_TSTORM_OVERLAY_BUF_ADDR].size)
 
-/* RSS indirection table entry update command per PF offset in TSTORM PF BAR0.
- * Use eth_tstorm_rss_update_data for update
- */
-#define TSTORM_ETH_RSS_UPDATE_OFFSET(pf_id) \
-	(IRO[37].base + ((pf_id) * IRO[37].m1))
-#define TSTORM_ETH_RSS_UPDATE_SIZE			(IRO[37].size)
+/* Tstorm port statistics */
+#define TSTORM_PORT_STAT_OFFSET(port_id) \
+	(IRO[IRO_TSTORM_PORT_STAT].base  \
+	 + ((port_id) * IRO[IRO_TSTORM_PORT_STAT].m1))
+#define TSTORM_PORT_STAT_SIZE (IRO[IRO_TSTORM_PORT_STAT].size)
 
-/* Xstorm queue zone */
-#define XSTORM_ETH_QUEUE_ZONE_OFFSET(queue_id) \
-	(IRO[38].base + ((queue_id) * IRO[38].m1))
-#define XSTORM_ETH_QUEUE_ZONE_SIZE			(IRO[38].size)
+/* Tstorm error level for assert */
+#define TSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_TSTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_TSTORM_RDMA_ASSERT_LEVEL].m1))
+#define TSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_TSTORM_RDMA_ASSERT_LEVEL].size)
 
-/* Ystorm cqe producer */
-#define YSTORM_TOE_CQ_PROD_OFFSET(rss_id) \
-	(IRO[39].base + ((rss_id) * IRO[39].m1))
-#define YSTORM_TOE_CQ_PROD_SIZE				(IRO[39].size)
+/* Tstorm RDMA queue statistics */
+#define TSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
+	(IRO[IRO_TSTORM_RDMA_QUEUE_STAT].base               \
+	 + ((rdma_stat_counter_id) * IRO[IRO_TSTORM_RDMA_QUEUE_STAT].m1))
+#define TSTORM_RDMA_QUEUE_STAT_SIZE (IRO[IRO_TSTORM_RDMA_QUEUE_STAT].size)
 
-/* Ustorm cqe producer */
-#define USTORM_TOE_CQ_PROD_OFFSET(rss_id) \
-	(IRO[40].base + ((rss_id) * IRO[40].m1))
-#define USTORM_TOE_CQ_PROD_SIZE				(IRO[40].size)
+/* Tstorm RoCE Event Statistics */
+#define TSTORM_ROCE_EVENTS_STAT_OFFSET(roce_pf_id) \
+	(IRO[IRO_TSTORM_ROCE_EVENTS_STAT].base     \
+	 + ((roce_pf_id) * IRO[IRO_TSTORM_ROCE_EVENTS_STAT].m1))
+#define TSTORM_ROCE_EVENTS_STAT_SIZE (IRO[IRO_TSTORM_ROCE_EVENTS_STAT].size)
 
-/* Ustorm grq producer */
-#define USTORM_TOE_GRQ_PROD_OFFSET(pf_id) \
-	(IRO[41].base + ((pf_id) * IRO[41].m1))
-#define USTORM_TOE_GRQ_PROD_SIZE			(IRO[41].size)
+/* Tstorm (reflects M-Storm) bdq-external-producer of given function ID,
+ * BDqueue-id.
+ */
+#define TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id)      \
+	(IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].base                       \
+	 + ((storage_func_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].m1) \
+	 + ((bdq_id) * IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].m2))
+#define TSTORM_SCSI_BDQ_EXT_PROD_SIZE (IRO[IRO_TSTORM_SCSI_BDQ_EXT_PROD].size)
 
 /* Tstorm cmdq-cons of given command queue-id */
 #define TSTORM_SCSI_CMDQ_CONS_OFFSET(cmdq_queue_id) \
-	(IRO[42].base + ((cmdq_queue_id) * IRO[42].m1))
-#define TSTORM_SCSI_CMDQ_CONS_SIZE			(IRO[42].size)
+	(IRO[IRO_TSTORM_SCSI_CMDQ_CONS].base        \
+	 + ((cmdq_queue_id) * IRO[IRO_TSTORM_SCSI_CMDQ_CONS].m1))
+#define TSTORM_SCSI_CMDQ_CONS_SIZE (IRO[IRO_TSTORM_SCSI_CMDQ_CONS].size)
 
-/* Tstorm (reflects M-Storm) bdq-external-producer of given function ID,
- * BDqueue-id
- */
-#define TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id) \
-	(IRO[43].base + ((storage_func_id) * IRO[43].m1) + \
-	 ((bdq_id) * IRO[43].m2))
-#define TSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[43].size)
+/* Ustorm Common Queue ring consumer */
+#define USTORM_COMMON_QUEUE_CONS_OFFSET(queue_zone_id) \
+	(IRO[IRO_USTORM_COMMON_QUEUE_CONS].base        \
+	 + ((queue_zone_id) * IRO[IRO_USTORM_COMMON_QUEUE_CONS].m1))
+#define USTORM_COMMON_QUEUE_CONS_SIZE (IRO[IRO_USTORM_COMMON_QUEUE_CONS].size)
 
-/* Mstorm bdq-external-producer of given BDQ resource ID, BDqueue-id */
-#define MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id) \
-	(IRO[44].base + ((storage_func_id) * IRO[44].m1) + \
-	 ((bdq_id) * IRO[44].m2))
-#define MSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[44].size)
+/* Ustorm Event ring consumer */
+#define USTORM_EQE_CONS_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_EQE_CONS].base \
+	 + ((pf_id) * IRO[IRO_USTORM_EQE_CONS].m1))
+#define USTORM_EQE_CONS_SIZE (IRO[IRO_USTORM_EQE_CONS].size)
 
-/* Tstorm iSCSI RX stats */
-#define TSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
-	(IRO[45].base + ((storage_func_id) * IRO[45].m1))
-#define TSTORM_ISCSI_RX_STATS_SIZE			(IRO[45].size)
+/* Ustorm pf statistics */
+#define USTORM_ETH_PF_STAT_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_ETH_PF_STAT].base \
+	 + ((pf_id) * IRO[IRO_USTORM_ETH_PF_STAT].m1))
+#define USTORM_ETH_PF_STAT_SIZE	(IRO[IRO_USTORM_ETH_PF_STAT].size)
 
-/* Mstorm iSCSI RX stats */
-#define MSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
-	(IRO[46].base + ((storage_func_id) * IRO[46].m1))
-#define MSTORM_ISCSI_RX_STATS_SIZE			(IRO[46].size)
+/* Ustorm eth queue zone */
+#define USTORM_ETH_QUEUE_ZONE_OFFSET(queue_zone_id) \
+	(IRO[IRO_USTORM_ETH_QUEUE_ZONE].base        \
+	 + ((queue_zone_id) * IRO[IRO_USTORM_ETH_QUEUE_ZONE].m1))
+#define USTORM_ETH_QUEUE_ZONE_SIZE (IRO[IRO_USTORM_ETH_QUEUE_ZONE].size)
+
+/* Ustorm Final flr cleanup ack */
+#define USTORM_FLR_FINAL_ACK_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_FLR_FINAL_ACK].base \
+	 + ((pf_id) * IRO[IRO_USTORM_FLR_FINAL_ACK].m1))
+#define USTORM_FLR_FINAL_ACK_SIZE (IRO[IRO_USTORM_FLR_FINAL_ACK].size)
+
+/* Ustorm Integration Test Data */
+#define USTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_USTORM_INTEG_TEST_DATA].base)
+#define USTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_USTORM_INTEG_TEST_DATA].size)
 
 /* Ustorm iSCSI RX stats */
 #define USTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
-	(IRO[47].base + ((storage_func_id) * IRO[47].m1))
-#define USTORM_ISCSI_RX_STATS_SIZE			(IRO[47].size)
+	(IRO[IRO_USTORM_ISCSI_RX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_USTORM_ISCSI_RX_STATS].m1))
+#define USTORM_ISCSI_RX_STATS_SIZE (IRO[IRO_USTORM_ISCSI_RX_STATS].size)
 
-/* Xstorm iSCSI TX stats */
-#define XSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
-	(IRO[48].base + ((storage_func_id) * IRO[48].m1))
-#define XSTORM_ISCSI_TX_STATS_SIZE			(IRO[48].size)
+/* Ustorm overlay buffer host address */
+#define USTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_USTORM_OVERLAY_BUF_ADDR].base)
+#define USTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_USTORM_OVERLAY_BUF_ADDR].size)
 
-/* Ystorm iSCSI TX stats */
-#define YSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
-	(IRO[49].base + ((storage_func_id) * IRO[49].m1))
-#define YSTORM_ISCSI_TX_STATS_SIZE			(IRO[49].size)
+/* Ustorm queue statistics */
+#define USTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
+	(IRO[IRO_USTORM_QUEUE_STAT].base          \
+	 + ((stat_counter_id) * IRO[IRO_USTORM_QUEUE_STAT].m1))
+#define USTORM_QUEUE_STAT_SIZE (IRO[IRO_USTORM_QUEUE_STAT].size)
 
-/* Pstorm iSCSI TX stats */
-#define PSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
-	(IRO[50].base + ((storage_func_id) * IRO[50].m1))
-#define PSTORM_ISCSI_TX_STATS_SIZE			(IRO[50].size)
+/* Ustorm error level for assert */
+#define USTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_USTORM_RDMA_ASSERT_LEVEL].m1))
+#define USTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_USTORM_RDMA_ASSERT_LEVEL].size)
 
-/* Tstorm FCoE RX stats */
-#define TSTORM_FCOE_RX_STATS_OFFSET(pf_id) \
-	(IRO[51].base + ((pf_id) * IRO[51].m1))
-#define TSTORM_FCOE_RX_STATS_SIZE			(IRO[51].size)
+/* RoCE CQEs Statistics */
+#define USTORM_ROCE_CQE_STATS_OFFSET(roce_pf_id) \
+	(IRO[IRO_USTORM_ROCE_CQE_STATS].base     \
+	 + ((roce_pf_id) * IRO[IRO_USTORM_ROCE_CQE_STATS].m1))
+#define USTORM_ROCE_CQE_STATS_SIZE (IRO[IRO_USTORM_ROCE_CQE_STATS].size)
 
-/* Pstorm FCoE TX stats */
-#define PSTORM_FCOE_TX_STATS_OFFSET(pf_id) \
-	(IRO[52].base + ((pf_id) * IRO[52].m1))
-#define PSTORM_FCOE_TX_STATS_SIZE			(IRO[52].size)
+/* Ustorm cqe producer */
+#define USTORM_TOE_CQ_PROD_OFFSET(rss_id) \
+	(IRO[IRO_USTORM_TOE_CQ_PROD].base \
+	 + ((rss_id) * IRO[IRO_USTORM_TOE_CQ_PROD].m1))
+#define USTORM_TOE_CQ_PROD_SIZE (IRO[IRO_USTORM_TOE_CQ_PROD].size)
 
-/* Pstorm RDMA queue statistics */
-#define PSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
-	(IRO[53].base + ((rdma_stat_counter_id) * IRO[53].m1))
-#define PSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[53].size)
+/* Ustorm grq producer */
+#define USTORM_TOE_GRQ_PROD_OFFSET(pf_id)  \
+	(IRO[IRO_USTORM_TOE_GRQ_PROD].base \
+	 + ((pf_id) * IRO[IRO_USTORM_TOE_GRQ_PROD].m1))
+#define USTORM_TOE_GRQ_PROD_SIZE (IRO[IRO_USTORM_TOE_GRQ_PROD].size)
 
-/* Tstorm RDMA queue statistics */
-#define TSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
-	(IRO[54].base + ((rdma_stat_counter_id) * IRO[54].m1))
-#define TSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[54].size)
+/* Ustorm VF-PF Channel ready flag */
+#define USTORM_VF_PF_CHANNEL_READY_OFFSET(vf_id)  \
+	(IRO[IRO_USTORM_VF_PF_CHANNEL_READY].base \
+	 + ((vf_id) * IRO[IRO_USTORM_VF_PF_CHANNEL_READY].m1))
+#define USTORM_VF_PF_CHANNEL_READY_SIZE \
+				(IRO[IRO_USTORM_VF_PF_CHANNEL_READY].size)
 
-/* Xstorm error level for assert */
-#define XSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[55].base + ((pf_id) * IRO[55].m1))
-#define XSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[55].size)
+/* Xstorm queue zone */
+#define XSTORM_ETH_QUEUE_ZONE_OFFSET(queue_id) \
+	(IRO[IRO_XSTORM_ETH_QUEUE_ZONE].base   \
+	 + ((queue_id) * IRO[IRO_XSTORM_ETH_QUEUE_ZONE].m1))
+#define XSTORM_ETH_QUEUE_ZONE_SIZE (IRO[IRO_XSTORM_ETH_QUEUE_ZONE].size)
 
-/* Ystorm error level for assert */
-#define YSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[56].base + ((pf_id) * IRO[56].m1))
-#define YSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[56].size)
+/* Xstorm Integration Test Data */
+#define XSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_XSTORM_INTEG_TEST_DATA].base)
+#define XSTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_XSTORM_INTEG_TEST_DATA].size)
 
-/* Pstorm error level for assert */
-#define PSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[57].base + ((pf_id) * IRO[57].m1))
-#define PSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[57].size)
+/* Xstorm iSCSI TX stats */
+#define XSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[IRO_XSTORM_ISCSI_TX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_XSTORM_ISCSI_TX_STATS].m1))
+#define XSTORM_ISCSI_TX_STATS_SIZE (IRO[IRO_XSTORM_ISCSI_TX_STATS].size)
 
-/* Tstorm error level for assert */
-#define TSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[58].base + ((pf_id) * IRO[58].m1))
-#define TSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[58].size)
+/* Xstorm iWARP rxmit stats */
+#define XSTORM_IWARP_RXMIT_STATS_OFFSET(pf_id)  \
+	(IRO[IRO_XSTORM_IWARP_RXMIT_STATS].base \
+	 + ((pf_id) * IRO[IRO_XSTORM_IWARP_RXMIT_STATS].m1))
+#define XSTORM_IWARP_RXMIT_STATS_SIZE (IRO[IRO_XSTORM_IWARP_RXMIT_STATS].size)
 
-/* Mstorm error level for assert */
-#define MSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[59].base + ((pf_id) * IRO[59].m1))
-#define MSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[59].size)
+/* Xstorm overlay buffer host address */
+#define XSTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_XSTORM_OVERLAY_BUF_ADDR].base)
+#define XSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_XSTORM_OVERLAY_BUF_ADDR].size)
 
-/* Ustorm error level for assert */
-#define USTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[60].base + ((pf_id) * IRO[60].m1))
-#define USTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[60].size)
+/* Xstorm common PQ info */
+#define XSTORM_PQ_INFO_OFFSET(pq_id)  \
+	(IRO[IRO_XSTORM_PQ_INFO].base \
+	 + ((pq_id) * IRO[IRO_XSTORM_PQ_INFO].m1))
+#define XSTORM_PQ_INFO_SIZE (IRO[IRO_XSTORM_PQ_INFO].size)
 
-/* Xstorm iWARP rxmit stats */
-#define XSTORM_IWARP_RXMIT_STATS_OFFSET(pf_id) \
-	(IRO[61].base + ((pf_id) * IRO[61].m1))
-#define XSTORM_IWARP_RXMIT_STATS_SIZE			(IRO[61].size)
+/* Xstorm error level for assert */
+#define XSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_XSTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_XSTORM_RDMA_ASSERT_LEVEL].m1))
+#define XSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_XSTORM_RDMA_ASSERT_LEVEL].size)
 
-/* Tstorm RoCE Event Statistics */
-#define TSTORM_ROCE_EVENTS_STAT_OFFSET(roce_pf_id)	\
-	(IRO[62].base + ((roce_pf_id) * IRO[62].m1))
-#define TSTORM_ROCE_EVENTS_STAT_SIZE			(IRO[62].size)
+/* Ystorm flow control mode. Use enum fw_flow_ctrl_mode */
+#define YSTORM_FLOW_CONTROL_MODE_OFFSET (IRO[IRO_YSTORM_FLOW_CONTROL_MODE].base)
+#define YSTORM_FLOW_CONTROL_MODE_SIZE (IRO[IRO_YSTORM_FLOW_CONTROL_MODE].size)
+
+/* Ystorm Integration Test Data */
+#define YSTORM_INTEG_TEST_DATA_OFFSET (IRO[IRO_YSTORM_INTEG_TEST_DATA].base)
+#define YSTORM_INTEG_TEST_DATA_SIZE (IRO[IRO_YSTORM_INTEG_TEST_DATA].size)
+
+/* Ystorm iSCSI TX stats */
+#define YSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[IRO_YSTORM_ISCSI_TX_STATS].base          \
+	 + ((storage_func_id) * IRO[IRO_YSTORM_ISCSI_TX_STATS].m1))
+#define YSTORM_ISCSI_TX_STATS_SIZE (IRO[IRO_YSTORM_ISCSI_TX_STATS].size)
+
+/* Ystorm overlay buffer host address */
+#define YSTORM_OVERLAY_BUF_ADDR_OFFSET (IRO[IRO_YSTORM_OVERLAY_BUF_ADDR].base)
+#define YSTORM_OVERLAY_BUF_ADDR_SIZE (IRO[IRO_YSTORM_OVERLAY_BUF_ADDR].size)
+
+/* Ystorm error level for assert */
+#define YSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id)  \
+	(IRO[IRO_YSTORM_RDMA_ASSERT_LEVEL].base \
+	 + ((pf_id) * IRO[IRO_YSTORM_RDMA_ASSERT_LEVEL].m1))
+#define YSTORM_RDMA_ASSERT_LEVEL_SIZE (IRO[IRO_YSTORM_RDMA_ASSERT_LEVEL].size)
 
 /* DCQCN Received Statistics */
-#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_OFFSET(roce_pf_id)\
-	(IRO[63].base + ((roce_pf_id) * IRO[63].m1))
-#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_SIZE		(IRO[63].size)
+#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_OFFSET(roce_pf_id) \
+	(IRO[IRO_YSTORM_ROCE_DCQCN_RECEIVED_STATS].base     \
+	 + ((roce_pf_id) * IRO[IRO_YSTORM_ROCE_DCQCN_RECEIVED_STATS].m1))
+#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_SIZE \
+			(IRO[IRO_YSTORM_ROCE_DCQCN_RECEIVED_STATS].size)
 
 /* RoCE Error Statistics */
-#define YSTORM_ROCE_ERROR_STATS_OFFSET(roce_pf_id)	\
-	(IRO[64].base + ((roce_pf_id) * IRO[64].m1))
-#define YSTORM_ROCE_ERROR_STATS_SIZE			(IRO[64].size)
+#define YSTORM_ROCE_ERROR_STATS_OFFSET(roce_pf_id) \
+	(IRO[IRO_YSTORM_ROCE_ERROR_STATS].base     \
+	 + ((roce_pf_id) * IRO[IRO_YSTORM_ROCE_ERROR_STATS].m1))
+#define YSTORM_ROCE_ERROR_STATS_SIZE (IRO[IRO_YSTORM_ROCE_ERROR_STATS].size)
 
-/* DCQCN Sent Statistics */
-#define PSTORM_ROCE_DCQCN_SENT_STATS_OFFSET(roce_pf_id)	\
-	(IRO[65].base + ((roce_pf_id) * IRO[65].m1))
-#define PSTORM_ROCE_DCQCN_SENT_STATS_SIZE		(IRO[65].size)
-
-/* RoCE CQEs Statistics */
-#define USTORM_ROCE_CQE_STATS_OFFSET(roce_pf_id)	\
-	(IRO[66].base + ((roce_pf_id) * IRO[66].m1))
-#define USTORM_ROCE_CQE_STATS_SIZE			(IRO[66].size)
+/* Ystorm cqe producer */
+#define YSTORM_TOE_CQ_PROD_OFFSET(rss_id) \
+	(IRO[IRO_YSTORM_TOE_CQ_PROD].base \
+	 + ((rss_id) * IRO[IRO_YSTORM_TOE_CQ_PROD].m1))
+#define YSTORM_TOE_CQ_PROD_SIZE (IRO[IRO_YSTORM_TOE_CQ_PROD].size)
 
+/* Per-chip offsets in iro_arr in dwords */
+#define E4_IRO_ARR_OFFSET    0
 #endif
-- 
2.24.1

