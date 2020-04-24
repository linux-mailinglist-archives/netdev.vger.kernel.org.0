Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E161B6F00
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDXH2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbgDXH2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PjVa021054;
        Fri, 24 Apr 2020 00:27:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=gLInBR6vDF4wYL0WUVrTpdXIanttNuSMP876Y4YXD28=;
 b=d2FNIpy39Ma+6NOvL7rh67ea3X091FNYFfsRPBSfyC5tq4LdpNSwBo8W+CpJ0SHxo09W
 n3jRcoD3XWn6dC+0alqtp729m6a3Eel/QTi1KMi3yisvrIJQsePssGq/LoIhsmQabBND
 5Aiu+/DP7J0Mr8maM6lcZpg2EpTyYbfVQXPkFlEvq2P8qZKVXQJXrUoVI7guEkewXMcO
 WWWeFDwsG7qD2qytXUwjxhYLHcbDPzPRGp0UE+k0lNgBUCCBIp8jlp1yfMdZLogjwdBu
 Ac145yTSpb7f39+UUCsuRGe0ld3/vXYh4VfV41+f36+Kwo8g3vVjTNSfW7hPnMUdSDl5 SQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb47f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:57 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id D75243F7040;
        Fri, 24 Apr 2020 00:27:55 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 07/17] net: atlantic: move IS_CHIP_FEATURE to aq_hw.h
Date:   Fri, 24 Apr 2020 10:27:19 +0300
Message-ID: <20200424072729.953-8-irusskikh@marvell.com>
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

From: Mark Starovoytov <mstarovoitov@marvell.com>

IS_CHIP feature will be used to differentiate between A1 and A2,
where necessary. Thus, move it to aq_hw.h, rename it and make
it accept the 'hw' pointer.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    | 13 +++++++
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  6 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 36 ++++++++++---------
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 11 ------
 5 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index c0dada1075cf..f420ef40b627 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -136,6 +136,19 @@ enum aq_priv_flags {
 				 BIT(AQ_HW_LOOPBACK_PHYINT_SYS) |\
 				 BIT(AQ_HW_LOOPBACK_PHYEXT_SYS))
 
+#define ATL_HW_CHIP_MIPS         0x00000001U
+#define ATL_HW_CHIP_TPO2         0x00000002U
+#define ATL_HW_CHIP_RPF2         0x00000004U
+#define ATL_HW_CHIP_MPI_AQ       0x00000010U
+#define ATL_HW_CHIP_ATLANTIC     0x00800000U
+#define ATL_HW_CHIP_REVISION_A0  0x01000000U
+#define ATL_HW_CHIP_REVISION_B0  0x02000000U
+#define ATL_HW_CHIP_REVISION_B1  0x04000000U
+#define ATL_HW_CHIP_ANTIGUA      0x08000000U
+
+#define ATL_HW_IS_CHIP_FEATURE(_HW_, _F_) (!!(ATL_HW_CHIP_##_F_ & \
+	(_HW_)->chip_features))
+
 struct aq_hw_s {
 	atomic_t flags;
 	u8 rbl_enabled:1;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 2dba8c277ecb..eee265b4415a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -267,7 +267,7 @@ static int hw_atl_a0_hw_init_tx_path(struct aq_hw_s *self)
 	hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 1U);
 
 	/* misc */
-	aq_hw_write_reg(self, 0x00007040U, IS_CHIP_FEATURE(TPO2) ?
+	aq_hw_write_reg(self, 0x00007040U, ATL_HW_IS_CHIP_FEATURE(self, TPO2) ?
 			0x00010000U : 0x00000000U);
 	hw_atl_tdm_tx_dca_en_set(self, 0U);
 	hw_atl_tdm_tx_dca_mode_set(self, 0U);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 4e2e4eef028d..3b42045b9c7d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -324,7 +324,7 @@ static int hw_atl_b0_hw_init_tx_path(struct aq_hw_s *self)
 	hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 1U);
 
 	/* misc */
-	aq_hw_write_reg(self, 0x00007040U, IS_CHIP_FEATURE(TPO2) ?
+	aq_hw_write_reg(self, 0x00007040U, ATL_HW_IS_CHIP_FEATURE(self, TPO2) ?
 			0x00010000U : 0x00000000U);
 	hw_atl_tdm_tx_dca_en_set(self, 0U);
 	hw_atl_tdm_tx_dca_mode_set(self, 0U);
@@ -372,8 +372,8 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 	hw_atl_rdm_rx_desc_wr_wb_irq_en_set(self, 1U);
 
 	/* misc */
-	aq_hw_write_reg(self, 0x00005040U,
-			IS_CHIP_FEATURE(RPF2) ? 0x000F0000U : 0x00000000U);
+	aq_hw_write_reg(self, 0x00005040U, ATL_HW_IS_CHIP_FEATURE(self, RPF2) ?
+			0x000F0000U : 0x00000000U);
 
 	hw_atl_rpfl2broadcast_flr_act_set(self, 1U);
 	hw_atl_rpfl2broadcast_count_threshold_set(self, 0xFFFFU & (~0U / 256U));
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index bd1712ca9ef2..20655a2170cc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -309,7 +309,7 @@ int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
 	for (++cnt; --cnt && !err;) {
 		aq_hw_write_reg(self, HW_ATL_MIF_CMD, 0x00008000U);
 
-		if (IS_CHIP_FEATURE(REVISION_B1))
+		if (ATL_HW_IS_CHIP_FEATURE(self, REVISION_B1))
 			err = readx_poll_timeout_atomic(hw_atl_utils_mif_addr_get,
 							self, val, val != a,
 							1U, 1000U);
@@ -405,7 +405,7 @@ static int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 addr, u32 *p,
 	if (err < 0)
 		goto err_exit;
 
-	if (IS_CHIP_FEATURE(REVISION_B1))
+	if (ATL_HW_IS_CHIP_FEATURE(self, REVISION_B1))
 		err = hw_atl_utils_write_b1_mbox(self, addr, p, cnt, area);
 	else
 		err = hw_atl_utils_write_b0_mbox(self, addr, p, cnt);
@@ -497,7 +497,7 @@ int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size)
 	struct aq_hw_atl_utils_fw_rpc_tid_s sw;
 	int err = 0;
 
-	if (!IS_CHIP_FEATURE(MIPS)) {
+	if (!ATL_HW_IS_CHIP_FEATURE(self, MIPS)) {
 		err = -1;
 		goto err_exit;
 	}
@@ -603,7 +603,7 @@ void hw_atl_utils_mpi_read_stats(struct aq_hw_s *self,
 	if (err < 0)
 		goto err_exit;
 
-	if (IS_CHIP_FEATURE(REVISION_A0)) {
+	if (ATL_HW_IS_CHIP_FEATURE(self, REVISION_A0)) {
 		unsigned int mtu = self->aq_nic_cfg ?
 					self->aq_nic_cfg->mtu : 1514U;
 		pmbox->stats.ubrc = pmbox->stats.uprc * mtu;
@@ -802,22 +802,24 @@ void hw_atl_utils_hw_chip_features_init(struct aq_hw_s *self, u32 *p)
 	u32 mif_rev = val & 0xFFU;
 	u32 chip_features = 0U;
 
+	chip_features |= ATL_HW_CHIP_ATLANTIC;
+
 	if ((0xFU & mif_rev) == 1U) {
-		chip_features |= HAL_ATLANTIC_UTILS_CHIP_REVISION_A0 |
-			HAL_ATLANTIC_UTILS_CHIP_MPI_AQ |
-			HAL_ATLANTIC_UTILS_CHIP_MIPS;
+		chip_features |= ATL_HW_CHIP_REVISION_A0 |
+			ATL_HW_CHIP_MPI_AQ |
+			ATL_HW_CHIP_MIPS;
 	} else if ((0xFU & mif_rev) == 2U) {
-		chip_features |= HAL_ATLANTIC_UTILS_CHIP_REVISION_B0 |
-			HAL_ATLANTIC_UTILS_CHIP_MPI_AQ |
-			HAL_ATLANTIC_UTILS_CHIP_MIPS |
-			HAL_ATLANTIC_UTILS_CHIP_TPO2 |
-			HAL_ATLANTIC_UTILS_CHIP_RPF2;
+		chip_features |= ATL_HW_CHIP_REVISION_B0 |
+			ATL_HW_CHIP_MPI_AQ |
+			ATL_HW_CHIP_MIPS |
+			ATL_HW_CHIP_TPO2 |
+			ATL_HW_CHIP_RPF2;
 	} else if ((0xFU & mif_rev) == 0xAU) {
-		chip_features |= HAL_ATLANTIC_UTILS_CHIP_REVISION_B1 |
-			HAL_ATLANTIC_UTILS_CHIP_MPI_AQ |
-			HAL_ATLANTIC_UTILS_CHIP_MIPS |
-			HAL_ATLANTIC_UTILS_CHIP_TPO2 |
-			HAL_ATLANTIC_UTILS_CHIP_RPF2;
+		chip_features |= ATL_HW_CHIP_REVISION_B1 |
+			ATL_HW_CHIP_MPI_AQ |
+			ATL_HW_CHIP_MIPS |
+			ATL_HW_CHIP_TPO2 |
+			ATL_HW_CHIP_RPF2;
 	}
 
 	*p = chip_features;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 086627a96746..5513254642b3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -406,17 +406,6 @@ enum hw_atl_rx_ctrl_registers_l3l4 {
 #define HW_ATL_GET_REG_LOCATION_FL3L4(location) \
 	((location) - AQ_RX_FIRST_LOC_FL3L4)
 
-#define HAL_ATLANTIC_UTILS_CHIP_MIPS         0x00000001U
-#define HAL_ATLANTIC_UTILS_CHIP_TPO2         0x00000002U
-#define HAL_ATLANTIC_UTILS_CHIP_RPF2         0x00000004U
-#define HAL_ATLANTIC_UTILS_CHIP_MPI_AQ       0x00000010U
-#define HAL_ATLANTIC_UTILS_CHIP_REVISION_A0  0x01000000U
-#define HAL_ATLANTIC_UTILS_CHIP_REVISION_B0  0x02000000U
-#define HAL_ATLANTIC_UTILS_CHIP_REVISION_B1  0x04000000U
-
-#define IS_CHIP_FEATURE(_F_) (HAL_ATLANTIC_UTILS_CHIP_##_F_ & \
-	self->chip_features)
-
 enum hal_atl_utils_fw_state_e {
 	MPI_DEINIT = 0,
 	MPI_RESET = 1,
-- 
2.17.1

