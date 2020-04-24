Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034C31B6F0A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDXH23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbgDXH23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PoCQ021067;
        Fri, 24 Apr 2020 00:28:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZdaSuBn2MsXC4xuDkYsJYOVoGe5Nej9mYKH2LinX6Cs=;
 b=JkIW5kbwkKybsHAiXfJHfDh61JZ1AIXEpQbZX47qa9sFm98yOsu5qdUb8NOFviRqpLHK
 B5kbNdFZvDkEgvNMMsZNKK4lDkFIRF4MMLnJQshywSWe7WE2iHGZKrEtMaPH0bOOa0y+
 639WhTtvKiXfz9fF3/UBb2aZD0Up9jHBobQtQsdKVDQhA7M5az2pZ/v6PcR4w/9r89bZ
 dOVHC5Oqp4jGtihfL3qPqTBp52nwbAudaTDosNfrptEllJVQNBYDWwAJbQLqfuoGkmxM
 3trg5uk4UfacoseADv/jDAkd9MFOxsfgLIDYzwT55bPS/weQ1MwBTdoIg3hHa6PbF7ZA tQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb49c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:19 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 7CB893F7041;
        Fri, 24 Apr 2020 00:28:17 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>
Subject: [PATCH net-next 16/17] net: atlantic: basic A2 init/deinit hw_ops
Date:   Fri, 24 Apr 2020 10:27:28 +0300
Message-ID: <20200424072729.953-17-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic A2 HW initialization / deinitialization.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   3 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  24 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  14 +
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |   4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   4 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 343 ++++++++++++++----
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  21 ++
 7 files changed, 334 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 2dbea5cd7684..f97b073efd8e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -378,7 +378,8 @@ int aq_nic_init(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
 
-	if (self->aq_nic_cfg.aq_hw_caps->media_type == AQ_HW_MEDIA_TYPE_TP) {
+	if (ATL_HW_IS_CHIP_FEATURE(self->aq_hw, ATLANTIC) &&
+	    self->aq_nic_cfg.aq_hw_caps->media_type == AQ_HW_MEDIA_TYPE_TP) {
 		self->aq_hw->phy_id = HW_ATL_PHY_ID_MAX;
 		err = aq_phy_init(self->aq_hw);
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 3b42045b9c7d..c46199f14ec4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -187,8 +187,8 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
-				     struct aq_rss_parameters *rss_params)
+int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
+			      struct aq_rss_parameters *rss_params)
 {
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int addr = 0U;
@@ -215,8 +215,8 @@ static int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
 	return err;
 }
 
-static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
-				struct aq_rss_parameters *rss_params)
+int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
+			 struct aq_rss_parameters *rss_params)
 {
 	u32 num_rss_queues = max(1U, self->aq_nic_cfg->num_rss_queues);
 	u8 *indirection_table =	rss_params->indirection_table;
@@ -314,7 +314,7 @@ static int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 static int hw_atl_b0_hw_init_tx_path(struct aq_hw_s *self)
 {
 	/* Tx TC/Queue number config */
-	hw_atl_rpb_tps_tx_tc_mode_set(self, 1U);
+	hw_atl_tpb_tps_tx_tc_mode_set(self, 1U);
 
 	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
 	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
@@ -495,7 +495,7 @@ static int hw_atl_b0_hw_ring_rx_start(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_start(struct aq_hw_s *self)
+int hw_atl_b0_hw_start(struct aq_hw_s *self)
 {
 	hw_atl_tpb_tx_buff_en_set(self, 1);
 	hw_atl_rpb_rx_buff_en_set(self, 1);
@@ -854,14 +854,14 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask)
+int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask)
 {
 	hw_atl_itr_irq_msk_setlsw_set(self, LODWORD(mask));
 
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask)
+int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask)
 {
 	hw_atl_itr_irq_msk_clearlsw_set(self, LODWORD(mask));
 	hw_atl_itr_irq_status_clearlsw_set(self, LODWORD(mask));
@@ -871,7 +871,7 @@ static int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
+int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 {
 	*mask = hw_atl_itr_irq_statuslsw_get(self);
 
@@ -880,8 +880,8 @@ static int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 
 #define IS_FILTER_ENABLED(_F_) ((packet_filter & (_F_)) ? 1U : 0U)
 
-static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
-					  unsigned int packet_filter)
+int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
+				   unsigned int packet_filter)
 {
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int i = 0U;
@@ -1089,7 +1089,7 @@ static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self,
 
 static int hw_atl_b0_tx_tc_mode_get(struct aq_hw_s *self, u32 *tc_mode)
 {
-	*tc_mode = hw_atl_rpb_tps_tx_tc_mode_get(self);
+	*tc_mode = hw_atl_tpb_tps_tx_tc_mode_get(self);
 	return aq_hw_err_from_flags(self);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index 09af1683034b..ea7136b06b32 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -33,4 +33,18 @@ extern const struct aq_hw_ops hw_atl_ops_b0;
 
 #define hw_atl_ops_b1 hw_atl_ops_b0
 
+int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
+			      struct aq_rss_parameters *rss_params);
+int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
+			 struct aq_rss_parameters *rss_params);
+
+int hw_atl_b0_hw_start(struct aq_hw_s *self);
+
+int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask);
+int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask);
+int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask);
+
+int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
+				   unsigned int packet_filter);
+
 #endif /* HW_ATL_B0_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 8dd3232d72c4..9e2d01a6aac8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1318,14 +1318,14 @@ void hw_atl_tpb_tx_buff_en_set(struct aq_hw_s *aq_hw, u32 tx_buff_en)
 			    HW_ATL_TPB_TX_BUF_EN_SHIFT, tx_buff_en);
 }
 
-u32 hw_atl_rpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw)
+u32 hw_atl_tpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw)
 {
 	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TPB_TX_TC_MODE_ADDR,
 			HW_ATL_TPB_TX_TC_MODE_MSK,
 			HW_ATL_TPB_TX_TC_MODE_SHIFT);
 }
 
-void hw_atl_rpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
+void hw_atl_tpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
 				   u32 tx_traf_class_mode)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPB_TX_TC_MODE_ADDR,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index a4699a682973..b88cb84805d5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -616,11 +616,11 @@ void hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(struct aq_hw_s *aq_hw,
 /* tpb */
 
 /* set TX Traffic Class Mode */
-void hw_atl_rpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
+void hw_atl_tpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
 				   u32 tx_traf_class_mode);
 
 /* get TX Traffic Class Mode */
-u32 hw_atl_rpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw);
+u32 hw_atl_tpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw);
 
 /* set tx buffer enable */
 void hw_atl_tpb_tx_buff_en_set(struct aq_hw_s *aq_hw, u32 tx_buff_en);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 7dd5f9a1c505..de21d41c8c35 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -6,11 +6,13 @@
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
 #include "aq_nic.h"
+#include "hw_atl/hw_atl_b0.h"
 #include "hw_atl/hw_atl_utils.h"
 #include "hw_atl/hw_atl_llh.h"
 #include "hw_atl2_utils.h"
 #include "hw_atl2_llh.h"
 #include "hw_atl2_internal.h"
+#include "hw_atl2_llh_internal.h"
 
 static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 				       u32 tag, u32 mask, u32 action);
@@ -70,19 +72,106 @@ static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
 
 static int hw_atl2_hw_reset(struct aq_hw_s *self)
 {
-	return -EOPNOTSUPP;
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	int err;
+
+	err = hw_atl2_utils_soft_reset(self);
+	if (err)
+		return err;
+
+	memset(priv, 0, sizeof(*priv));
+
+	self->aq_fw_ops->set_state(self, MPI_RESET);
+
+	err = aq_hw_err_from_flags(self);
+
+	return err;
 }
 
-static int hw_atl2_hw_rss_hash_set(struct aq_hw_s *self,
-				   struct aq_rss_parameters *rss_params)
+static int hw_atl2_hw_queue_to_tc_map_set(struct aq_hw_s *self)
 {
-	return -EOPNOTSUPP;
+	if (!hw_atl_rpb_rpf_rx_traf_class_mode_get(self)) {
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(0), 0x11110000);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(8), 0x33332222);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(16), 0x55554444);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(24), 0x77776666);
+	} else {
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(0), 0x00000000);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(8), 0x11111111);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(16), 0x22222222);
+		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(24), 0x33333333);
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
+{
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	u32 tx_buff_size = HW_ATL2_TXBUF_MAX;
+	u32 rx_buff_size = HW_ATL2_RXBUF_MAX;
+	unsigned int prio = 0U;
+	u32 threshold = 0U;
+	u32 tc = 0U;
+
+	/* TPS Descriptor rate init */
+	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
+	hw_atl_tps_tx_pkt_shed_desc_rate_lim_set(self, 0xA);
+
+	/* TPS VM init */
+	hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(self, 0U);
+
+	/* TPS TC credits init */
+	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
+	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
+
+	tc = 0;
+
+	/* TX Packet Scheduler Data TC0 */
+	hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0, tc);
+	hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
+	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
+	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
+
+	/* Tx buf size TC0 */
+	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
+
+	threshold = (tx_buff_size * (1024 / 32U) * 66U) / 100U;
+	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+
+	threshold = (tx_buff_size * (1024 / 32U) * 50U) / 100U;
+	hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+
+	/* QoS Rx buf size per TC */
+	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
+
+	threshold = (rx_buff_size * (1024U / 32U) * 66U) / 100U;
+	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+
+	threshold = (rx_buff_size * (1024U / 32U) * 50U) / 100U;
+	hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+
+	/* QoS 802.1p priority -> TC mapping */
+	for (prio = 0; prio < 8; ++prio)
+		hw_atl_rpf_rpb_user_priority_tc_map_set(self, prio,
+							cfg->tcs * prio / 8);
+
+	/* ATL2 Apply legacy ring to TC mapping */
+	hw_atl2_hw_queue_to_tc_map_set(self);
+
+	return aq_hw_err_from_flags(self);
 }
 
 static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 			      struct aq_rss_parameters *rss_params)
 {
-	return -EOPNOTSUPP;
+	u8 *indirection_table =	rss_params->indirection_table;
+	int i;
+
+	for (i = HW_ATL2_RSS_REDIRECTION_MAX; i--;)
+		hw_atl2_new_rpf_rss_redir_set(self, 0, i, indirection_table[i]);
+
+	return hw_atl_b0_hw_rss_set(self, rss_params);
 }
 
 static int hw_atl2_hw_offload_set(struct aq_hw_s *self,
@@ -91,6 +180,80 @@ static int hw_atl2_hw_offload_set(struct aq_hw_s *self,
 	return -EOPNOTSUPP;
 }
 
+static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
+{
+	/* Tx TC/RSS number config */
+	hw_atl_tpb_tps_tx_tc_mode_set(self, 1U);
+
+	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
+	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
+	hw_atl_thm_lso_tcp_flag_of_last_pkt_set(self, 0x0F7FU);
+
+	/* Tx interrupts */
+	hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 1U);
+
+	/* misc */
+	hw_atl_tdm_tx_dca_en_set(self, 0U);
+	hw_atl_tdm_tx_dca_mode_set(self, 0U);
+
+	hw_atl_tpb_tx_path_scp_ins_en_set(self, 1U);
+
+	hw_atl2_tpb_tx_buf_clk_gate_en_set(self, 0U);
+
+	return aq_hw_err_from_flags(self);
+}
+
+static void hw_atl2_hw_init_new_rx_filters(struct aq_hw_s *self)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	u8 index;
+
+	hw_atl2_rpf_act_rslvr_section_en_set(self, 0xFFFF);
+	hw_atl2_rpfl2_uc_flr_tag_set(self, HW_ATL2_RPF_TAG_BASE_UC,
+				     HW_ATL2_MAC_UC);
+	hw_atl2_rpfl2_bc_flr_tag_set(self, HW_ATL2_RPF_TAG_BASE_UC);
+
+	index = priv->art_base_index + HW_ATL2_RPF_L2_PROMISC_OFF_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0,
+				    HW_ATL2_RPF_TAG_UC_MASK |
+					HW_ATL2_RPF_TAG_ALLMC_MASK,
+				    HW_ATL2_ACTION_DROP);
+
+	index = priv->art_base_index + HW_ATL2_RPF_VLAN_PROMISC_OFF_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0,
+				    HW_ATL2_RPF_TAG_VLAN_MASK |
+					HW_ATL2_RPF_TAG_UNTAG_MASK,
+				    HW_ATL2_ACTION_DROP);
+
+	index = priv->art_base_index + HW_ATL2_RPF_VLAN_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_VLAN,
+				    HW_ATL2_RPF_TAG_VLAN_MASK,
+				    HW_ATL2_ACTION_ASSIGN_TC(0));
+
+	index = priv->art_base_index + HW_ATL2_RPF_MAC_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_UC,
+				    HW_ATL2_RPF_TAG_UC_MASK,
+				    HW_ATL2_ACTION_ASSIGN_TC(0));
+
+	index = priv->art_base_index + HW_ATL2_RPF_ALLMC_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_ALLMC,
+				    HW_ATL2_RPF_TAG_ALLMC_MASK,
+				    HW_ATL2_ACTION_ASSIGN_TC(0));
+
+	index = priv->art_base_index + HW_ATL2_RPF_UNTAG_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_UNTAG_MASK,
+				    HW_ATL2_RPF_TAG_UNTAG_MASK,
+				    HW_ATL2_ACTION_ASSIGN_TC(0));
+
+	index = priv->art_base_index + HW_ATL2_RPF_VLAN_PROMISC_ON_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0, HW_ATL2_RPF_TAG_VLAN_MASK,
+				    HW_ATL2_ACTION_DISABLE);
+
+	index = priv->art_base_index + HW_ATL2_RPF_L2_PROMISC_ON_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0, HW_ATL2_RPF_TAG_UC_MASK,
+				    HW_ATL2_ACTION_DISABLE);
+}
+
 static void hw_atl2_hw_new_rx_filter_vlan_promisc(struct aq_hw_s *self,
 						  bool promisc)
 {
@@ -145,6 +308,56 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 	return err;
 }
 
+static int hw_atl2_hw_init_rx_path(struct aq_hw_s *self)
+{
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	int i;
+
+	/* Rx TC/RSS number config */
+	hw_atl_rpb_rpf_rx_traf_class_mode_set(self, 1U);
+
+	/* Rx flow control */
+	hw_atl_rpb_rx_flow_ctl_mode_set(self, 1U);
+
+	hw_atl2_rpf_rss_hash_type_set(self, 0x1FFU);
+
+	/* RSS Ring selection */
+	hw_atl_reg_rx_flr_rss_control1set(self, cfg->is_rss ? 0xB3333333U :
+							      0x00000000U);
+
+	/* Multicast filters */
+	for (i = HW_ATL2_MAC_MAX; i--;) {
+		hw_atl_rpfl2_uc_flr_en_set(self, (i == 0U) ? 1U : 0U, i);
+		hw_atl_rpfl2unicast_flr_act_set(self, 1U, i);
+	}
+
+	hw_atl_reg_rx_flr_mcst_flr_msk_set(self, 0x00000000U);
+	hw_atl_reg_rx_flr_mcst_flr_set(self, 0x00010FFFU, 0U);
+
+	/* Vlan filters */
+	hw_atl_rpf_vlan_outer_etht_set(self, 0x88A8U);
+	hw_atl_rpf_vlan_inner_etht_set(self, 0x8100U);
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self, 1);
+
+	/* Always accept untagged packets */
+	hw_atl_rpf_vlan_accept_untagged_packets_set(self, 1U);
+	hw_atl_rpf_vlan_untagged_act_set(self, 1U);
+
+	hw_atl2_hw_init_new_rx_filters(self);
+
+	/* Rx Interrupts */
+	hw_atl_rdm_rx_desc_wr_wb_irq_en_set(self, 1U);
+
+	hw_atl_rpfl2broadcast_flr_act_set(self, 1U);
+	hw_atl_rpfl2broadcast_count_threshold_set(self, 0xFFFFU & (~0U / 256U));
+
+	hw_atl_rdm_rx_dca_en_set(self, 0U);
+	hw_atl_rdm_rx_dca_mode_set(self, 0U);
+
+	return aq_hw_err_from_flags(self);
+}
+
 static int hw_atl2_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 {
 	return -EOPNOTSUPP;
@@ -152,7 +365,15 @@ static int hw_atl2_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 
 static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 {
+	static u32 aq_hw_atl2_igcr_table_[4][2] = {
+		[AQ_HW_IRQ_INVALID] = { 0x20000000U, 0x20000000U },
+		[AQ_HW_IRQ_LEGACY]  = { 0x20000080U, 0x20000080U },
+		[AQ_HW_IRQ_MSI]     = { 0x20000021U, 0x20000025U },
+		[AQ_HW_IRQ_MSIX]    = { 0x20000022U, 0x20000026U },
+	};
+
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct aq_nic_cfg_s *aq_nic_cfg = self->aq_nic_cfg;
 	u8 base_index, count;
 	int err;
 
@@ -163,7 +384,49 @@ static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 
 	priv->art_base_index = 8 * base_index;
 
-	return -EOPNOTSUPP;
+	hw_atl2_init_launchtime(self);
+
+	hw_atl2_hw_init_tx_path(self);
+	hw_atl2_hw_init_rx_path(self);
+
+	hw_atl2_hw_mac_addr_set(self, mac_addr);
+
+	self->aq_fw_ops->set_link_speed(self, aq_nic_cfg->link_speed_msk);
+	self->aq_fw_ops->set_state(self, MPI_INIT);
+
+	hw_atl2_hw_qos_set(self);
+	hw_atl2_hw_rss_set(self, &aq_nic_cfg->aq_rss);
+	hw_atl_b0_hw_rss_hash_set(self, &aq_nic_cfg->aq_rss);
+
+	hw_atl2_rpf_new_enable_set(self, 1);
+
+	/* Reset link status and read out initial hardware counters */
+	self->aq_link_status.mbps = 0;
+	self->aq_fw_ops->update_stats(self);
+
+	err = aq_hw_err_from_flags(self);
+	if (err < 0)
+		goto err_exit;
+
+	/* Interrupts */
+	hw_atl_reg_irq_glb_ctl_set(self,
+				   aq_hw_atl2_igcr_table_[aq_nic_cfg->irq_type]
+						 [(aq_nic_cfg->vecs > 1U) ?
+						  1 : 0]);
+
+	hw_atl_itr_irq_auto_masklsw_set(self, aq_nic_cfg->aq_hw_caps->irq_mask);
+
+	/* Interrupts */
+	hw_atl_reg_gen_irq_map_set(self,
+				   ((HW_ATL2_ERR_INT << 0x18) |
+				    (1U << 0x1F)) |
+				   ((HW_ATL2_ERR_INT << 0x10) |
+				    (1U << 0x17)), 0U);
+
+	hw_atl2_hw_offload_set(self, aq_nic_cfg);
+
+err_exit:
+	return err;
 }
 
 static int hw_atl2_hw_ring_tx_start(struct aq_hw_s *self,
@@ -178,11 +441,6 @@ static int hw_atl2_hw_ring_rx_start(struct aq_hw_s *self,
 	return -EOPNOTSUPP;
 }
 
-static int hw_atl2_hw_start(struct aq_hw_s *self)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hw_atl2_hw_ring_tx_xmit(struct aq_hw_s *self,
 				   struct aq_ring_s *ring,
 				   unsigned int frags)
@@ -222,58 +480,14 @@ static int hw_atl2_hw_ring_rx_receive(struct aq_hw_s *self,
 	return -EOPNOTSUPP;
 }
 
-static int hw_atl2_hw_irq_enable(struct aq_hw_s *self, u64 mask)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_irq_disable(struct aq_hw_s *self, u64 mask)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_irq_read(struct aq_hw_s *self, u64 *mask)
-{
-	return -EOPNOTSUPP;
-}
-
 #define IS_FILTER_ENABLED(_F_) ((packet_filter & (_F_)) ? 1U : 0U)
 
 static int hw_atl2_hw_packet_filter_set(struct aq_hw_s *self,
 					unsigned int packet_filter)
 {
-	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
-	u32 vlan_promisc;
-	u32 l2_promisc;
-	unsigned int i;
-
-	l2_promisc = IS_FILTER_ENABLED(IFF_PROMISC) ||
-		     !!(cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET));
-	vlan_promisc = l2_promisc || cfg->is_vlan_force_promisc;
-
-	hw_atl_rpfl2promiscuous_mode_en_set(self, l2_promisc);
-
-	hw_atl_rpf_vlan_prom_mode_en_set(self, vlan_promisc);
-
 	hw_atl2_hw_new_rx_filter_promisc(self, IS_FILTER_ENABLED(IFF_PROMISC));
 
-	hw_atl_rpfl2multicast_flr_en_set(self,
-					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
-					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
-
-	hw_atl_rpfl2_accept_all_mc_packets_set(self,
-					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
-					      IS_FILTER_ENABLED(IFF_MULTICAST));
-
-	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
-
-	for (i = HW_ATL2_MAC_MIN; i < HW_ATL2_MAC_MAX; ++i)
-		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (cfg->is_mc_list_enabled &&
-					    (i <= cfg->mc_list_count)) ?
-				    1U : 0U, i);
-
-	return aq_hw_err_from_flags(self);
+	return hw_atl_b0_hw_packet_filter_set(self, packet_filter);
 }
 
 #undef IS_FILTER_ENABLED
@@ -326,7 +540,9 @@ static int hw_atl2_hw_interrupt_moderation_set(struct aq_hw_s *self)
 
 static int hw_atl2_hw_stop(struct aq_hw_s *self)
 {
-	return -EOPNOTSUPP;
+	hw_atl_b0_hw_irq_disable(self, HW_ATL2_INT_MASK);
+
+	return 0;
 }
 
 static int hw_atl2_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
@@ -400,10 +616,12 @@ static int hw_atl2_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
 }
 
 const struct aq_hw_ops hw_atl2_ops = {
+	.hw_soft_reset        = hw_atl2_utils_soft_reset,
+	.hw_prepare           = hw_atl2_utils_initfw,
 	.hw_set_mac_address   = hw_atl2_hw_mac_addr_set,
 	.hw_init              = hw_atl2_hw_init,
 	.hw_reset             = hw_atl2_hw_reset,
-	.hw_start             = hw_atl2_hw_start,
+	.hw_start             = hw_atl_b0_hw_start,
 	.hw_ring_tx_start     = hw_atl2_hw_ring_tx_start,
 	.hw_ring_tx_stop      = hw_atl2_hw_ring_tx_stop,
 	.hw_ring_rx_start     = hw_atl2_hw_ring_rx_start,
@@ -416,9 +634,9 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_ring_rx_receive      = hw_atl2_hw_ring_rx_receive,
 	.hw_ring_rx_fill         = hw_atl2_hw_ring_rx_fill,
 
-	.hw_irq_enable           = hw_atl2_hw_irq_enable,
-	.hw_irq_disable          = hw_atl2_hw_irq_disable,
-	.hw_irq_read             = hw_atl2_hw_irq_read,
+	.hw_irq_enable           = hw_atl_b0_hw_irq_enable,
+	.hw_irq_disable          = hw_atl_b0_hw_irq_disable,
+	.hw_irq_read             = hw_atl_b0_hw_irq_read,
 
 	.hw_ring_rx_init             = hw_atl2_hw_ring_rx_init,
 	.hw_ring_tx_init             = hw_atl2_hw_ring_tx_init,
@@ -428,7 +646,8 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_multicast_list_set       = hw_atl2_hw_multicast_list_set,
 	.hw_interrupt_moderation_set = hw_atl2_hw_interrupt_moderation_set,
 	.hw_rss_set                  = hw_atl2_hw_rss_set,
-	.hw_rss_hash_set             = hw_atl2_hw_rss_hash_set,
+	.hw_rss_hash_set             = hw_atl_b0_hw_rss_hash_set,
 	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
+	.hw_get_fw_version           = hw_atl2_utils_get_fw_version,
 	.hw_set_offload              = hw_atl2_hw_offload_set,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index dccc89df2223..bc9aa67a5cdc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -22,6 +22,15 @@
 #define HW_ATL2_MAC_MIN  1U
 #define HW_ATL2_MAC_MAX  38U
 
+/* interrupts */
+#define HW_ATL2_ERR_INT 8U
+#define HW_ATL2_INT_MASK  (0xFFFFFFFFU)
+
+#define HW_ATL2_TXBUF_MAX              128U
+#define HW_ATL2_RXBUF_MAX              192U
+
+#define HW_ATL2_RSS_REDIRECTION_MAX 64U
+
 #define HW_ATL2_TC_MAX 1U
 #define HW_ATL2_RSS_MAX 8U
 
@@ -57,6 +66,11 @@
 #define HW_ATL2_RPF_TAG_L4_MASK    (0x00000007 << HW_ATL2_RPF_TAG_L4_OFFSET)
 #define HW_ATL2_RPF_TAG_PCP_MASK   (0x00000007 << HW_ATL2_RPF_TAG_PCP_OFFSET)
 
+#define HW_ATL2_RPF_TAG_BASE_UC    BIT(HW_ATL2_RPF_TAG_UC_OFFSET)
+#define HW_ATL2_RPF_TAG_BASE_ALLMC BIT(HW_ATL2_RPF_TAG_ALLMC_OFFSET)
+#define HW_ATL2_RPF_TAG_BASE_UNTAG BIT(HW_ATL2_RPF_TAG_UNTAG_OFFSET)
+#define HW_ATL2_RPF_TAG_BASE_VLAN  BIT(HW_ATL2_RPF_TAG_VLAN_OFFSET)
+
 enum HW_ATL2_RPF_ART_INDEX {
 	HW_ATL2_RPF_L2_PROMISC_OFF_INDEX,
 	HW_ATL2_RPF_VLAN_PROMISC_OFF_INDEX,
@@ -65,6 +79,13 @@ enum HW_ATL2_RPF_ART_INDEX {
 	HW_ATL2_RPF_VLAN_USER_INDEX	= HW_ATL2_RPF_ET_PCP_USER_INDEX + 16,
 	HW_ATL2_RPF_PCP_TO_TC_INDEX	= HW_ATL2_RPF_VLAN_USER_INDEX +
 					  HW_ATL_VLAN_MAX_FILTERS,
+	HW_ATL2_RPF_VLAN_INDEX		= HW_ATL2_RPF_PCP_TO_TC_INDEX +
+					  AQ_CFG_TCS_MAX,
+	HW_ATL2_RPF_MAC_INDEX,
+	HW_ATL2_RPF_ALLMC_INDEX,
+	HW_ATL2_RPF_UNTAG_INDEX,
+	HW_ATL2_RPF_VLAN_PROMISC_ON_INDEX,
+	HW_ATL2_RPF_L2_PROMISC_ON_INDEX,
 };
 
 #define HW_ATL2_ACTION(ACTION, RSS, INDEX, VALID) \
-- 
2.17.1

