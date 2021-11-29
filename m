Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB51461677
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343870AbhK2Nfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229814AbhK2Ndh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGY010651;
        Mon, 29 Nov 2021 05:30:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DICiycX/93/n3U3TyllaK5CQ4nReWTIIfBgw244DCdw=;
 b=Q94tN3oczyxDScC9wJW3Cw70yHd+66pXlrRrxz5EUbfd1V9JbjWPbIDx/Aj05olm9Mny
 9Mh40YH6rYDDKb24mT+myVembTyiWouM98DXLe5WNFdM+kpIONV2oR3L/iano9IQDFz6
 Z+b7i5MwRbBT/6s4nbpAcDxqRlgORn/hxpfw16rcGYQIYHQpIXHBGgxflQiFn4dTAuLU
 9i8EJYGYPvbJFfMTmPxdbwS1bUAdnbeHexbQKBoFyuIMiDjVWBMsq2io5LQtIxdYUWyP
 eARoqTsJjm9aO0xd6pHG10clCJoR/j9B4sWGBcNUCIym4zwHTNs4Y0IJOWw9Usl/Zmym OA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7D1543F70B8;
        Mon, 29 Nov 2021 05:30:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDUHLK016172;
        Mon, 29 Nov 2021 05:30:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDUHSB016171;
        Mon, 29 Nov 2021 05:30:17 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>
Subject: [PATCH net 6/7] atlantic: Fix statistics logic for production hardware
Date:   Mon, 29 Nov 2021 05:28:28 -0800
Message-ID: <20211129132829.16038-7-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rRL8g6C4BSpoLNl2TsjymyNU4RIc0OZT
X-Proofpoint-GUID: rRL8g6C4BSpoLNl2TsjymyNU4RIc0OZT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbezrukov@marvell.com>

B0 is the main and widespread device revision of atlantic2 HW. In the
current state, driver will incorrectly fetch the statistics for this
revision.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  10 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  15 ++-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |  38 ++++++-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 101 ++++++++++++++----
 5 files changed, 139 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 062a300a566a..dbd284660135 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -80,6 +80,8 @@ struct aq_hw_link_status_s {
 };
 
 struct aq_stats_s {
+	u64 brc;
+	u64 btc;
 	u64 uprc;
 	u64 mprc;
 	u64 bprc;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 1acf544afeb4..02c4e3b4a6a5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -905,8 +905,14 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 	data[++i] = stats->mbtc;
 	data[++i] = stats->bbrc;
 	data[++i] = stats->bbtc;
-	data[++i] = stats->ubrc + stats->mbrc + stats->bbrc;
-	data[++i] = stats->ubtc + stats->mbtc + stats->bbtc;
+	if (stats->brc)
+		data[++i] = stats->brc;
+	else
+		data[++i] = stats->ubrc + stats->mbrc + stats->bbrc;
+	if (stats->btc)
+		data[++i] = stats->btc;
+	else
+		data[++i] = stats->ubtc + stats->mbtc + stats->bbtc;
 	data[++i] = stats->dma_pkt_rc;
 	data[++i] = stats->dma_pkt_tc;
 	data[++i] = stats->dma_oct_rc;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 3f1704cbe1cb..7e88d7234b14 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -867,12 +867,20 @@ static int hw_atl_fw1x_deinit(struct aq_hw_s *self)
 int hw_atl_utils_update_stats(struct aq_hw_s *self)
 {
 	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
 	struct hw_atl_utils_mbox mbox;
+	bool corrupted_stats = false;
 
 	hw_atl_utils_mpi_read_stats(self, &mbox);
 
-#define AQ_SDELTA(_N_) (self->curr_stats._N_ += \
-			mbox.stats._N_ - self->last_stats._N_)
+#define AQ_SDELTA(_N_)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(mbox.stats._N_ - self->last_stats._N_)) >= 0) \
+		curr_stats._N_ += mbox.stats._N_ - self->last_stats._N_; \
+	else \
+		corrupted_stats = true; \
+} while (0)
 
 	if (self->aq_link_status.mbps) {
 		AQ_SDELTA(uprc);
@@ -892,6 +900,9 @@ int hw_atl_utils_update_stats(struct aq_hw_s *self)
 		AQ_SDELTA(bbrc);
 		AQ_SDELTA(bbtc);
 		AQ_SDELTA(dpc);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
 	}
 #undef AQ_SDELTA
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
index b66fa346581c..6bad64c77b87 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -239,7 +239,8 @@ struct version_s {
 		u8 minor;
 		u16 build;
 	} phy;
-	u32 rsvd;
+	u32 drv_iface_ver:4;
+	u32 rsvd:28;
 };
 
 struct link_status_s {
@@ -424,7 +425,7 @@ struct cable_diag_status_s {
 	u16 rsvd2;
 };
 
-struct statistics_s {
+struct statistics_a0_s {
 	struct {
 		u32 link_up;
 		u32 link_down;
@@ -457,6 +458,33 @@ struct statistics_s {
 	u32 reserve_fw_gap;
 };
 
+struct __packed statistics_b0_s {
+	u64 rx_good_octets;
+	u64 rx_pause_frames;
+	u64 rx_good_frames;
+	u64 rx_errors;
+	u64 rx_unicast_frames;
+	u64 rx_multicast_frames;
+	u64 rx_broadcast_frames;
+
+	u64 tx_good_octets;
+	u64 tx_pause_frames;
+	u64 tx_good_frames;
+	u64 tx_errors;
+	u64 tx_unicast_frames;
+	u64 tx_multicast_frames;
+	u64 tx_broadcast_frames;
+
+	u32 main_loop_cycles;
+};
+
+struct __packed statistics_s {
+	union __packed {
+		struct statistics_a0_s a0;
+		struct statistics_b0_s b0;
+	};
+};
+
 struct filter_caps_s {
 	u8 l2_filters_base_index:6;
 	u8 flexible_filter_mask:2;
@@ -545,7 +573,7 @@ struct management_status_s {
 	u32 rsvd5;
 };
 
-struct fw_interface_out {
+struct __packed fw_interface_out {
 	struct transaction_counter_s transaction_id;
 	struct version_s version;
 	struct link_status_s link_status;
@@ -569,7 +597,6 @@ struct fw_interface_out {
 	struct core_dump_s core_dump;
 	u32 rsvd11;
 	struct statistics_s stats;
-	u32 rsvd12;
 	struct filter_caps_s filter_caps;
 	struct device_caps_s device_caps;
 	u32 rsvd13;
@@ -592,6 +619,9 @@ struct fw_interface_out {
 #define  AQ_HOST_MODE_LOW_POWER    3U
 #define  AQ_HOST_MODE_SHUTDOWN     4U
 
+#define  AQ_A2_FW_INTERFACE_A0     0
+#define  AQ_A2_FW_INTERFACE_B0     1
+
 int hw_atl2_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops);
 
 int hw_atl2_utils_soft_reset(struct aq_hw_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index e164ac5b55a8..58d426dda3ed 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -333,18 +333,22 @@ static int aq_a2_fw_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 	return 0;
 }
 
-static int aq_a2_fw_update_stats(struct aq_hw_s *self)
+static void aq_a2_fill_a0_stats(struct aq_hw_s *self,
+				struct statistics_s *stats)
 {
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
-	struct statistics_s stats;
-	int err;
-
-	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
-	if (err)
-		return err;
-
-#define AQ_SDELTA(_N_, _F_) (self->curr_stats._N_ += \
-			stats.msm._F_ - priv->last_stats.msm._F_)
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
+	bool corrupted_stats = false;
+
+#define AQ_SDELTA(_N, _F)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(stats->a0.msm._F - priv->last_stats.a0.msm._F)) >= 0) \
+		curr_stats._N += stats->a0.msm._F - priv->last_stats.a0.msm._F;\
+	else \
+		corrupted_stats = true; \
+} while (0)
 
 	if (self->aq_link_status.mbps) {
 		AQ_SDELTA(uprc, rx_unicast_frames);
@@ -363,17 +367,76 @@ static int aq_a2_fw_update_stats(struct aq_hw_s *self)
 		AQ_SDELTA(mbtc, tx_multicast_octets);
 		AQ_SDELTA(bbrc, rx_broadcast_octets);
 		AQ_SDELTA(bbtc, tx_broadcast_octets);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
+	}
+#undef AQ_SDELTA
+
+}
+
+static void aq_a2_fill_b0_stats(struct aq_hw_s *self,
+				struct statistics_s *stats)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
+	bool corrupted_stats = false;
+
+#define AQ_SDELTA(_N, _F)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(stats->b0._F - priv->last_stats.b0._F)) >= 0) \
+		curr_stats._N += stats->b0._F - priv->last_stats.b0._F; \
+	else \
+		corrupted_stats = true; \
+} while (0)
+
+	if (self->aq_link_status.mbps) {
+		AQ_SDELTA(uprc, rx_unicast_frames);
+		AQ_SDELTA(mprc, rx_multicast_frames);
+		AQ_SDELTA(bprc, rx_broadcast_frames);
+		AQ_SDELTA(erpr, rx_errors);
+		AQ_SDELTA(brc, rx_good_octets);
+
+		AQ_SDELTA(uptc, tx_unicast_frames);
+		AQ_SDELTA(mptc, tx_multicast_frames);
+		AQ_SDELTA(bptc, tx_broadcast_frames);
+		AQ_SDELTA(erpt, tx_errors);
+		AQ_SDELTA(btc, tx_good_octets);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
 	}
 #undef AQ_SDELTA
-	self->curr_stats.dma_pkt_rc =
-		hw_atl_stats_rx_dma_good_pkt_counter_get(self);
-	self->curr_stats.dma_pkt_tc =
-		hw_atl_stats_tx_dma_good_pkt_counter_get(self);
-	self->curr_stats.dma_oct_rc =
-		hw_atl_stats_rx_dma_good_octet_counter_get(self);
-	self->curr_stats.dma_oct_tc =
-		hw_atl_stats_tx_dma_good_octet_counter_get(self);
-	self->curr_stats.dpc = hw_atl_rpb_rx_dma_drop_pkt_cnt_get(self);
+}
+
+static int aq_a2_fw_update_stats(struct aq_hw_s *self)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct statistics_s stats;
+	struct version_s version;
+	int err;
+
+	err = hw_atl2_shared_buffer_read_safe(self, version, &version);
+	if (err)
+		return err;
+
+	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	if (err)
+		return err;
+
+	if (version.drv_iface_ver == AQ_A2_FW_INTERFACE_A0)
+		aq_a2_fill_a0_stats(self, &stats);
+	else
+		aq_a2_fill_b0_stats(self, &stats);
+
+	cs->dma_pkt_rc = hw_atl_stats_rx_dma_good_pkt_counter_get(self);
+	cs->dma_pkt_tc = hw_atl_stats_tx_dma_good_pkt_counter_get(self);
+	cs->dma_oct_rc = hw_atl_stats_rx_dma_good_octet_counter_get(self);
+	cs->dma_oct_tc = hw_atl_stats_tx_dma_good_octet_counter_get(self);
+	cs->dpc = hw_atl_rpb_rx_dma_drop_pkt_cnt_get(self);
 
 	memcpy(&priv->last_stats, &stats, sizeof(stats));
 
-- 
2.27.0

