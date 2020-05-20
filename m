Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7131DB588
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgETNsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:48:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60982 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726933AbgETNsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:48:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDetgV015025;
        Wed, 20 May 2020 06:48:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u9pZJDnhJX0kpdc/xUg0U89YnqUxTvOqpjsBd80uxQY=;
 b=Q2vdDk1b4jZ007x0MwXlPIj3vsk349Y7k84WUFBMtKzBFWwUTjR+Zji+xVOBWqP/oypj
 vN9ZMH/pEFzPmAQ41HoeULKWZVnodLdYvrqqTJVf+3352twIpCoWYrvxfm+6FQZpv8+W
 cnPE8PV+TMPW1TTLDGcdSkQP1EMpQa7wG8mPuzwd9gqqoRBOJK4dirc3o/HZUeBGuVzo
 oecbgaQa7ceGgws6/hjHR9kOQSInq2GU0cq0FVQayjqmx7fggrUYlAf9NVJKHI5t5hf2
 E+ELSC/CRzSQSRWs0A/j9gZ5iYzBs1k3ssD9I5zDvrsVKBF4/Eu+BnaqYvku3CvMmqrm kg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp8ksj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:48:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:48:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:48:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:48:00 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id BD9D83F7040;
        Wed, 20 May 2020 06:47:58 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 10/12] net: atlantic: change the order of arguments for TC weight/credit setters
Date:   Wed, 20 May 2020 16:47:32 +0300
Message-ID: <20200520134734.2014-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch changes the order of arguments for TC weight/credit setter
functions.
Having the "value to be set" on the right is slightly more robust in
a sense that it's more natural for the humans, so it's a bit more
error-proof this way.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  8 ++++----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  8 ++++----
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 20 +++++++++----------
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 16 +++++++--------
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   | 10 +++++-----
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  8 ++++----
 6 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 88b17cf77625..a312864969af 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -136,10 +136,10 @@ static int hw_atl_a0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
-	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, 0U);
-	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, 0U);
-	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, 0U);
-	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, 0U);
+	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0U, 0xFFF);
+	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0U, 0x64);
+	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0U, 0x50);
+	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0U, 0x1E);
 
 	/* Tx buf size */
 	buff_size = HW_ATL_A0_TXBUF_MAX;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index abc86eb4f525..2448a09ef7b9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -161,8 +161,8 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 		u32 threshold = 0U;
 
 		/* TX Packet Scheduler Data TC0 */
-		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
-		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
+		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, tc, 0xFFF);
+		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, tc, 0x64);
 
 		/* Tx buf size TC0 */
 		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
@@ -334,8 +334,8 @@ int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
 		const u32 en = (nic_cfg->tc_max_rate[tc] != 0) ? 1U : 0U;
 		const u32 desc = AQ_NIC_CFG_TCVEC2RING(nic_cfg, tc, 0);
 
-		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
-		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, tc, 0x50);
+		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, tc, 0x1E);
 
 		hw_atl_tps_tx_desc_rate_en_set(self, desc, en);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 0ea791a9c100..3c8e8047ea1e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1463,8 +1463,8 @@ void hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(struct aq_hw_s *aq_hw,
-						   u32 max_credit,
-						   u32 tc)
+						   const u32 tc,
+						   const u32 max_credit)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DESC_TCTCREDIT_MAX_ADR(tc),
 			    HW_ATL_TPS_DESC_TCTCREDIT_MAX_MSK,
@@ -1473,13 +1473,13 @@ void hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(struct aq_hw_s *aq_hw,
-					       u32 tx_pkt_shed_desc_tc_weight,
-					       u32 tc)
+					       const u32 tc,
+					       const u32 weight)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DESC_TCTWEIGHT_ADR(tc),
 			    HW_ATL_TPS_DESC_TCTWEIGHT_MSK,
 			    HW_ATL_TPS_DESC_TCTWEIGHT_SHIFT,
-			    tx_pkt_shed_desc_tc_weight);
+			    weight);
 }
 
 void hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(struct aq_hw_s *aq_hw,
@@ -1492,8 +1492,8 @@ void hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
-						   u32 max_credit,
-						   u32 tc)
+						   const u32 tc,
+						   const u32 max_credit)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DATA_TCTCREDIT_MAX_ADR(tc),
 			    HW_ATL_TPS_DATA_TCTCREDIT_MAX_MSK,
@@ -1502,13 +1502,13 @@ void hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
-					       u32 tx_pkt_shed_tc_data_weight,
-					       u32 tc)
+					       const u32 tc,
+					       const u32 weight)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DATA_TCTWEIGHT_ADR(tc),
 			    HW_ATL_TPS_DATA_TCTWEIGHT_MSK,
 			    HW_ATL_TPS_DATA_TCTWEIGHT_SHIFT,
-			    tx_pkt_shed_tc_data_weight);
+			    weight);
 }
 
 void hw_atl_tps_tx_desc_rate_mode_set(struct aq_hw_s *aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index c56cc4e8e13c..61a6f70c51cd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -688,13 +688,13 @@ void hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(struct aq_hw_s *aq_hw,
 
 /* set tx packet scheduler descriptor tc max credit */
 void hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(struct aq_hw_s *aq_hw,
-						   u32 max_credit,
-					    u32 tc);
+						   const u32 tc,
+						   const u32 max_credit);
 
 /* set tx packet scheduler descriptor tc weight */
 void hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(struct aq_hw_s *aq_hw,
-					       u32 tx_pkt_shed_desc_tc_weight,
-					u32 tc);
+					       const u32 tc,
+					       const u32 weight);
 
 /* set tx packet scheduler descriptor vm arbitration mode */
 void hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(struct aq_hw_s *aq_hw,
@@ -702,13 +702,13 @@ void hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(struct aq_hw_s *aq_hw,
 
 /* set tx packet scheduler tc data max credit */
 void hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
-						   u32 max_credit,
-					    u32 tc);
+						   const u32 tc,
+						   const u32 max_credit);
 
 /* set tx packet scheduler tc data weight */
 void hw_atl_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
-					       u32 tx_pkt_shed_tc_data_weight,
-					u32 tc);
+					       const u32 tc,
+					       const u32 weight);
 
 /* set tx descriptor rate mode */
 void hw_atl_tps_tx_desc_rate_mode_set(struct aq_hw_s *aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index 6817fa57cc83..c6a6ba66eb05 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -94,8 +94,8 @@ void hw_atl2_reg_tx_intr_moder_ctrl_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
-						    u32 max_credit,
-						    u32 tc)
+						    const u32 tc,
+						    const u32 max_credit)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPS_DATA_TCTCREDIT_MAX_ADR(tc),
 			    HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSK,
@@ -104,13 +104,13 @@ void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
-						u32 tx_pkt_shed_tc_data_weight,
-						u32 tc)
+						const u32 tc,
+						const u32 weight)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPS_DATA_TCTWEIGHT_ADR(tc),
 			    HW_ATL2_TPS_DATA_TCTWEIGHT_MSK,
 			    HW_ATL2_TPS_DATA_TCTWEIGHT_SHIFT,
-			    tx_pkt_shed_tc_data_weight);
+			    weight);
 }
 
 u32 hw_atl2_get_hw_version(struct aq_hw_s *aq_hw)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index d4b087d1dec1..883fa009bc0e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -47,13 +47,13 @@ void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en);
 
 /* set tx packet scheduler tc data max credit */
 void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
-						    u32 max_credit,
-						    u32 tc);
+						    const u32 tc,
+						    const u32 max_credit);
 
 /* set tx packet scheduler tc data weight */
 void hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
-						u32 tx_pkt_shed_tc_data_weight,
-						u32 tc);
+						const u32 tc,
+						const u32 weight);
 
 u32 hw_atl2_get_hw_version(struct aq_hw_s *aq_hw);
 
-- 
2.25.1

