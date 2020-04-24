Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6E1B6F04
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgDXH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64936 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDXH2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7Qfwg021724;
        Fri, 24 Apr 2020 00:28:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=n/CN7a+9Z1C6CJC4kTDukuF94Qk5XduAml5dwTHM1js=;
 b=WKh4lT8ml4rpO88wXasvZaWsub9HemBobrN2eHW/HRFBlGPg+/yIp0bwN7uZLV/bj78f
 pySjyr3VJDg946XZJYEt85cenw+lNXF33lj9ijgBzB4eQOBOjzCmJ+GBF9flD41yynQ5
 Nk4FnboNMwUE/ysFuE41FFQHVYAagfZzDStxJoNOTdL2wE6iBXhvVuM1VqvHto2Md/C5
 Gedj/x5REHfjv20/TkHvdQjp6e6+WdXVWOQM9429rAMz7T/HkuwC1htn/x3p047ywkpt
 4uRdFcp45eCC/PZmxgb2uQsRFy/Iqitznv1oBagZ7OymaKp6SDhvIvlYq2SuPU1DNT/g Iw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb486-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:06 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 2B6673F703F;
        Fri, 24 Apr 2020 00:28:04 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 11/17] net: atlantic: A2 hw_ops skeleton
Date:   Fri, 24 Apr 2020 10:27:23 +0300
Message-ID: <20200424072729.953-12-irusskikh@marvell.com>
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

This patch adds basic hw_ops layout for A2.

Actual implementation will be added in the follow-up patches.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |   1 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   1 +
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  39 ++-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 226 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2.h       |  14 ++
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  20 ++
 6 files changed, 294 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index fa845c15d0e1..23f0e5b5fcdb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -25,6 +25,7 @@ atlantic-objs := aq_main.o \
 	hw_atl/hw_atl_utils.o \
 	hw_atl/hw_atl_utils_fw2x.o \
 	hw_atl/hw_atl_llh.o \
+	hw_atl2/hw_atl2.o \
 	hw_atl2/hw_atl2_utils_fw.o \
 	hw_atl2/hw_atl2_llh.o \
 	macsec/macsec_api.o
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index e770d91e0876..03fea9469f01 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -55,6 +55,7 @@ struct aq_hw_caps_s {
 	u8 rx_rings;
 	bool flow_control;
 	bool is_64_dma;
+	u32 priv_data_len;
 };
 
 struct aq_hw_link_status_s {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 2edf137a7030..ce46cdbc69e6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -16,6 +16,7 @@
 #include "aq_pci_func.h"
 #include "hw_atl/hw_atl_a0.h"
 #include "hw_atl/hw_atl_b0.h"
+#include "hw_atl2/hw_atl2.h"
 #include "aq_filters.h"
 #include "aq_drvinfo.h"
 #include "aq_macsec.h"
@@ -41,6 +42,13 @@ static const struct pci_device_id aq_pci_tbl[] = {
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC111S), },
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC112S), },
 
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113DEV), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113CS), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC114CS), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113C), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC115C), },
+
 	{}
 };
 
@@ -70,6 +78,13 @@ static const struct aq_board_revision_s hw_atl_boards[] = {
 	{ AQ_DEVICE_ID_AQC109S,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc109s, },
 	{ AQ_DEVICE_ID_AQC111S,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc111s, },
 	{ AQ_DEVICE_ID_AQC112S,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc112s, },
+
+	{ AQ_DEVICE_ID_AQC113DEV,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC113,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC113CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC114CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC113C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC115C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
 };
 
 MODULE_DEVICE_TABLE(pci, aq_pci_tbl);
@@ -104,10 +119,8 @@ int aq_pci_func_init(struct pci_dev *pdev)
 	int err;
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (!err) {
+	if (!err)
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-
-	}
 	if (err) {
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
@@ -237,6 +250,15 @@ static int aq_pci_probe(struct pci_dev *pdev,
 		goto err_ioremap;
 	}
 	self->aq_hw->aq_nic_cfg = aq_nic_get_cfg(self);
+	if (self->aq_hw->aq_nic_cfg->aq_hw_caps->priv_data_len) {
+		int len = self->aq_hw->aq_nic_cfg->aq_hw_caps->priv_data_len;
+
+		self->aq_hw->priv = kzalloc(len, GFP_KERNEL);
+		if (!self->aq_hw->priv) {
+			err = -ENOMEM;
+			goto err_free_aq_hw;
+		}
+	}
 
 	for (bar = 0; bar < 4; ++bar) {
 		if (IORESOURCE_MEM & pci_resource_flags(pdev, bar)) {
@@ -245,19 +267,19 @@ static int aq_pci_probe(struct pci_dev *pdev,
 			mmio_pa = pci_resource_start(pdev, bar);
 			if (mmio_pa == 0U) {
 				err = -EIO;
-				goto err_free_aq_hw;
+				goto err_free_aq_hw_priv;
 			}
 
 			reg_sz = pci_resource_len(pdev, bar);
 			if ((reg_sz <= 24 /*ATL_REGS_SIZE*/)) {
 				err = -EIO;
-				goto err_free_aq_hw;
+				goto err_free_aq_hw_priv;
 			}
 
 			self->aq_hw->mmio = ioremap(mmio_pa, reg_sz);
 			if (!self->aq_hw->mmio) {
 				err = -EIO;
-				goto err_free_aq_hw;
+				goto err_free_aq_hw_priv;
 			}
 			break;
 		}
@@ -265,7 +287,7 @@ static int aq_pci_probe(struct pci_dev *pdev,
 
 	if (bar == 4) {
 		err = -EIO;
-		goto err_free_aq_hw;
+		goto err_free_aq_hw_priv;
 	}
 
 	numvecs = min((u8)AQ_CFG_VECS_DEF,
@@ -305,6 +327,8 @@ static int aq_pci_probe(struct pci_dev *pdev,
 	aq_pci_free_irq_vectors(self);
 err_hwinit:
 	iounmap(self->aq_hw->mmio);
+err_free_aq_hw_priv:
+	kfree(self->aq_hw->priv);
 err_free_aq_hw:
 	kfree(self->aq_hw);
 err_ioremap:
@@ -332,6 +356,7 @@ static void aq_pci_remove(struct pci_dev *pdev)
 		aq_nic_free_vectors(self);
 		aq_pci_free_irq_vectors(self);
 		iounmap(self->aq_hw->mmio);
+		kfree(self->aq_hw->priv);
 		kfree(self->aq_hw);
 		pci_release_regions(pdev);
 		free_netdev(self->ndev);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
new file mode 100644
index 000000000000..58c74a73b6cf
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include "aq_hw.h"
+#include "hw_atl2_utils.h"
+#include "hw_atl2_internal.h"
+
+#define DEFAULT_BOARD_BASIC_CAPABILITIES \
+	.is_64_dma = true,		  \
+	.msix_irqs = 8U,		  \
+	.irq_mask = ~0U,		  \
+	.vecs = HW_ATL2_RSS_MAX,	  \
+	.tcs = HW_ATL2_TC_MAX,	  \
+	.rxd_alignment = 1U,		  \
+	.rxd_size = HW_ATL2_RXD_SIZE,   \
+	.rxds_max = HW_ATL2_MAX_RXD,    \
+	.rxds_min = HW_ATL2_MIN_RXD,    \
+	.txd_alignment = 1U,		  \
+	.txd_size = HW_ATL2_TXD_SIZE,   \
+	.txds_max = HW_ATL2_MAX_TXD,    \
+	.txds_min = HW_ATL2_MIN_TXD,    \
+	.txhwb_alignment = 4096U,	  \
+	.tx_rings = HW_ATL2_TX_RINGS,   \
+	.rx_rings = HW_ATL2_RX_RINGS,   \
+	.hw_features = NETIF_F_HW_CSUM |  \
+			NETIF_F_RXCSUM |  \
+			NETIF_F_RXHASH |  \
+			NETIF_F_SG |      \
+			NETIF_F_TSO |     \
+			NETIF_F_TSO6 |    \
+			NETIF_F_LRO |     \
+			NETIF_F_NTUPLE |  \
+			NETIF_F_HW_VLAN_CTAG_FILTER | \
+			NETIF_F_HW_VLAN_CTAG_RX |     \
+			NETIF_F_HW_VLAN_CTAG_TX |     \
+			NETIF_F_GSO_UDP_L4      |     \
+			NETIF_F_GSO_PARTIAL,          \
+	.hw_priv_flags = IFF_UNICAST_FLT, \
+	.flow_control = true,		  \
+	.mtu = HW_ATL2_MTU_JUMBO,	  \
+	.mac_regs_count = 72,		  \
+	.hw_alive_check_addr = 0x10U,     \
+	.priv_data_len = sizeof(struct hw_atl2_priv)
+
+const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
+	DEFAULT_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_10G |
+			  AQ_NIC_RATE_5G  |
+			  AQ_NIC_RATE_2GS |
+			  AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M      |
+			  AQ_NIC_RATE_10M,
+};
+
+static int hw_atl2_hw_reset(struct aq_hw_s *self)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_rss_hash_set(struct aq_hw_s *self,
+				   struct aq_rss_parameters *rss_params)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
+			      struct aq_rss_parameters *rss_params)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_offload_set(struct aq_hw_s *self,
+				  struct aq_nic_cfg_s *aq_nic_cfg)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	u8 base_index, count;
+	int err;
+
+	err = hw_atl2_utils_get_action_resolve_table_caps(self, &base_index,
+							  &count);
+	if (err)
+		return err;
+
+	priv->art_base_index = 8 * base_index;
+
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_tx_start(struct aq_hw_s *self,
+				    struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_rx_start(struct aq_hw_s *self,
+				    struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_start(struct aq_hw_s *self)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_tx_xmit(struct aq_hw_s *self,
+				   struct aq_ring_s *ring,
+				   unsigned int frags)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_rx_init(struct aq_hw_s *self,
+				   struct aq_ring_s *aq_ring,
+				   struct aq_ring_param_s *aq_ring_param)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_tx_init(struct aq_hw_s *self,
+				   struct aq_ring_s *aq_ring,
+				   struct aq_ring_param_s *aq_ring_param)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_rx_fill(struct aq_hw_s *self, struct aq_ring_s *ring,
+				   unsigned int sw_tail_old)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_tx_head_update(struct aq_hw_s *self,
+					  struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_rx_receive(struct aq_hw_s *self,
+				      struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_irq_enable(struct aq_hw_s *self, u64 mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_irq_disable(struct aq_hw_s *self, u64 mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_irq_read(struct aq_hw_s *self, u64 *mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_interrupt_moderation_set(struct aq_hw_s *self)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_stop(struct aq_hw_s *self)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hw_atl2_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct aq_stats_s *hw_atl2_utils_get_hw_stats(struct aq_hw_s *self)
+{
+	return &self->curr_stats;
+}
+
+const struct aq_hw_ops hw_atl2_ops = {
+	.hw_set_mac_address   = hw_atl2_hw_mac_addr_set,
+	.hw_init              = hw_atl2_hw_init,
+	.hw_reset             = hw_atl2_hw_reset,
+	.hw_start             = hw_atl2_hw_start,
+	.hw_ring_tx_start     = hw_atl2_hw_ring_tx_start,
+	.hw_ring_tx_stop      = hw_atl2_hw_ring_tx_stop,
+	.hw_ring_rx_start     = hw_atl2_hw_ring_rx_start,
+	.hw_ring_rx_stop      = hw_atl2_hw_ring_rx_stop,
+	.hw_stop              = hw_atl2_hw_stop,
+
+	.hw_ring_tx_xmit         = hw_atl2_hw_ring_tx_xmit,
+	.hw_ring_tx_head_update  = hw_atl2_hw_ring_tx_head_update,
+
+	.hw_ring_rx_receive      = hw_atl2_hw_ring_rx_receive,
+	.hw_ring_rx_fill         = hw_atl2_hw_ring_rx_fill,
+
+	.hw_irq_enable           = hw_atl2_hw_irq_enable,
+	.hw_irq_disable          = hw_atl2_hw_irq_disable,
+	.hw_irq_read             = hw_atl2_hw_irq_read,
+
+	.hw_ring_rx_init             = hw_atl2_hw_ring_rx_init,
+	.hw_ring_tx_init             = hw_atl2_hw_ring_tx_init,
+	.hw_interrupt_moderation_set = hw_atl2_hw_interrupt_moderation_set,
+	.hw_rss_set                  = hw_atl2_hw_rss_set,
+	.hw_rss_hash_set             = hw_atl2_hw_rss_hash_set,
+	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
+	.hw_set_offload              = hw_atl2_hw_offload_set,
+};
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
new file mode 100644
index 000000000000..de8723f1c28a
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef HW_ATL2_H
+#define HW_ATL2_H
+
+#include "aq_common.h"
+
+extern const struct aq_hw_caps_s hw_atl2_caps_aqc113;
+extern const struct aq_hw_ops hw_atl2_ops;
+
+#endif /* HW_ATL2_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index 233db3222bb8..f82058484332 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -9,9 +9,29 @@
 #include "hw_atl2_utils.h"
 
 #define HW_ATL2_MTU_JUMBO  16352U
+#define HW_ATL2_MTU        1514U
+
+#define HW_ATL2_TX_RINGS 4U
+#define HW_ATL2_RX_RINGS 4U
+
+#define HW_ATL2_RINGS_MAX 32U
+#define HW_ATL2_TXD_SIZE       (16U)
+#define HW_ATL2_RXD_SIZE       (16U)
+
+#define HW_ATL2_TC_MAX 1U
+#define HW_ATL2_RSS_MAX 8U
+
+#define HW_ATL2_MIN_RXD \
+	(ALIGN(AQ_CFG_SKB_FRAGS_MAX + 1U, AQ_HW_RXD_MULTIPLE))
+#define HW_ATL2_MIN_TXD \
+	(ALIGN(AQ_CFG_SKB_FRAGS_MAX + 1U, AQ_HW_TXD_MULTIPLE))
+
+#define HW_ATL2_MAX_RXD 8184U
+#define HW_ATL2_MAX_TXD 8184U
 
 struct hw_atl2_priv {
 	struct statistics_s last_stats;
+	unsigned int art_base_index;
 };
 
 #endif /* HW_ATL2_INTERNAL_H */
-- 
2.17.1

