Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC54336988
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCKBUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhCKBUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:20:21 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115D3C061574;
        Wed, 10 Mar 2021 17:20:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l12so25402854wry.2;
        Wed, 10 Mar 2021 17:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/I5XVIa/3ak49+tQ5a/UWYDgjGq/vrdA4f4qkrm0hw=;
        b=sztW3hlNmsb6M+oZZIHoGQJSZ5KhwvCTCDEt9IFIU8rgcNZ/m2P58B54nIkt0apuhZ
         a4e3EBTS5skTSm8Y4i/6/wElSQf/UcoRk6jEQYLoBhU5MvQ2UkWT3HlzHgjWBqSxlcid
         W9bZcTZCDdBfT+VvQpVaLAYHzHL8xT3JqIJAOkx6v2RxP6z8oaf/GK93z69KXUOSw1HJ
         TcHjtLedWMAYzZ8wJPhCmDCo6VflLtqZJtSuTc5D9Mm3LEfPypwCeMl1gkCl4ch9KJ9z
         B553I7lzL61mV/DEp/nFhB9Mdk1R01OVofhS+D1F3h2lRrw/Qv+ckSJf4DY4dEDw5fS0
         Kmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/I5XVIa/3ak49+tQ5a/UWYDgjGq/vrdA4f4qkrm0hw=;
        b=WrnEutstKPASaM/E8e/yG6Zn8w/KVsNNgMWY74X9CeoCN6ljMRTAcXK9nCcxjH+/oJ
         CFo3byUiVrDzvTXmcp0pEKutg6TQbInm/XBms/ZhK2P9qAR1/4IIH0bycXdcBGPnb5TC
         GoVYxVaLvtnE+kZyPI2LpHya9tssxP39zxE027gy/IdM/Ct1eshjf+oU7o/K52mGBJ+4
         ZJqoo0e9L4wnJBVhRCaMeAE5EomEUw4RcY6G3QSovOId567+39aFzOOTYbdZBkwnNzFU
         4yQUODtBZllrGDLFU1YiuDSfH3XUNs8Dzy3sN6f4WtLdtKkMSHZSMqxDXzGZzuE271Fz
         0bew==
X-Gm-Message-State: AOAM5317uzVjAPodLg6uKzTuCNOUG/uqA47btPRwSIHhaD8US8ctJg6G
        +Aq+m3FoCxs7vl5HYfBu3ck=
X-Google-Smtp-Source: ABdhPJxm2mL0rrtC7BW9dJkLjYl8c9KFcyM2RXC3AqzF99Zp5TCR3Mj3FVgiPPXvY2JisCZGHIVdEA==
X-Received: by 2002:adf:e4c7:: with SMTP id v7mr6099878wrm.245.1615425619433;
        Wed, 10 Mar 2021 17:20:19 -0800 (PST)
Received: from localhost.localdomain ([81.18.95.223])
        by smtp.gmail.com with ESMTPSA id d85sm1199127wmd.15.2021.03.10.17.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:20:18 -0800 (PST)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl Ethernet MAC driver
Date:   Thu, 11 Mar 2021 03:20:13 +0200
Message-Id: <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new driver for the Ethernet MAC used on the Actions Semi Owl
family of SoCs.

Currently this has been tested only on the Actions Semi S500 SoC
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
---
 drivers/net/ethernet/Kconfig            |    1 +
 drivers/net/ethernet/Makefile           |    1 +
 drivers/net/ethernet/actions/Kconfig    |   39 +
 drivers/net/ethernet/actions/Makefile   |    6 +
 drivers/net/ethernet/actions/owl-emac.c | 1660 +++++++++++++++++++++++
 drivers/net/ethernet/actions/owl-emac.h |  278 ++++
 6 files changed, 1985 insertions(+)
 create mode 100644 drivers/net/ethernet/actions/Kconfig
 create mode 100644 drivers/net/ethernet/actions/Makefile
 create mode 100644 drivers/net/ethernet/actions/owl-emac.c
 create mode 100644 drivers/net/ethernet/actions/owl-emac.h

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index ad04660b97b8..4b85f2b74872 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -19,6 +19,7 @@ config SUNGEM_PHY
 	tristate
 
 source "drivers/net/ethernet/3com/Kconfig"
+source "drivers/net/ethernet/actions/Kconfig"
 source "drivers/net/ethernet/adaptec/Kconfig"
 source "drivers/net/ethernet/aeroflex/Kconfig"
 source "drivers/net/ethernet/agere/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 1e7dc8a7762d..9394493e8187 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_NET_VENDOR_3COM) += 3com/
 obj-$(CONFIG_NET_VENDOR_8390) += 8390/
+obj-$(CONFIG_NET_VENDOR_ACTIONS) += actions/
 obj-$(CONFIG_NET_VENDOR_ADAPTEC) += adaptec/
 obj-$(CONFIG_GRETH) += aeroflex/
 obj-$(CONFIG_NET_VENDOR_AGERE) += agere/
diff --git a/drivers/net/ethernet/actions/Kconfig b/drivers/net/ethernet/actions/Kconfig
new file mode 100644
index 000000000000..1f1480efc236
--- /dev/null
+++ b/drivers/net/ethernet/actions/Kconfig
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config NET_VENDOR_ACTIONS
+	bool "Actions Semi devices"
+	default y
+	depends on ARCH_ACTIONS
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about Actions Semi devices.  If you say Y, you will be
+	  asked for your specific card in the following questions.
+
+if NET_VENDOR_ACTIONS
+
+config OWL_EMAC
+	tristate "Actions Semi Owl Ethernet MAC support"
+	select PHYLIB
+	help
+	  This driver supports the Actions Semi Ethernet Media Access
+	  Controller (EMAC) found on the S500 and S900 SoCs.  The controller
+	  is compliant with the IEEE 802.3 CSMA/CD standard and supports
+	  both half-duplex and full-duplex operation modes at 10/100 Mb/s.
+
+config OWL_EMAC_GEN_ADDR_SYS_SN
+	bool "Enable generating MAC address based on system serial"
+	depends on OWL_EMAC
+	select CRYPTO
+	select CRYPTO_DES
+	select CRYPTO_ECB
+	select CRYPTO_SKCIPHER
+	default n
+	help
+	  If you say Y here and no MAC address is available, the Actions Semi
+	  Owl EMAC driver will generate the address based on the system serial
+	  number.  The fallback is to use a randomly generated MAC address.
+
+endif # NET_VENDOR_ACTIONS
diff --git a/drivers/net/ethernet/actions/Makefile b/drivers/net/ethernet/actions/Makefile
new file mode 100644
index 000000000000..fde8001d538a
--- /dev/null
+++ b/drivers/net/ethernet/actions/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Actions Semi Owl SoCs built-in ethernet macs
+#
+
+obj-$(CONFIG_OWL_EMAC) += owl-emac.o
diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
new file mode 100644
index 000000000000..ebd8ea88bca4
--- /dev/null
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -0,0 +1,1660 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Actions Semi Owl SoCs Ethernet MAC driver
+ *
+ * Copyright (c) 2012 Actions Semi Inc.
+ * Copyright (c) 2021 Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
+ */
+
+#include <asm/system_info.h>
+#include <crypto/skcipher.h>
+
+#include <linux/circ_buf.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/of_mdio.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/reset.h>
+
+#include "owl-emac.h"
+
+#define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
+static int debug = -1;
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
+
+static u32 owl_emac_reg_read(struct owl_emac_priv *priv, u32 reg)
+{
+	return readl(priv->base + reg);
+}
+
+static void owl_emac_reg_write(struct owl_emac_priv *priv, u32 reg, u32 data)
+{
+	writel(data, priv->base + reg);
+}
+
+static u32 owl_emac_reg_update(struct owl_emac_priv *priv,
+			       u32 reg, u32 mask, u32 val)
+{
+	u32 data, old_val;
+
+	data = owl_emac_reg_read(priv, reg);
+	old_val = data & mask;
+
+	data &= ~mask;
+	data |= val & mask;
+
+	owl_emac_reg_write(priv, reg, data);
+
+	return old_val;
+}
+
+static inline void owl_emac_reg_set(struct owl_emac_priv *priv,
+				    u32 reg, u32 bits)
+{
+	owl_emac_reg_update(priv, reg, bits, bits);
+}
+
+static inline void owl_emac_reg_clear(struct owl_emac_priv *priv,
+				      u32 reg, u32 bits)
+{
+	owl_emac_reg_update(priv, reg, bits, 0);
+}
+
+static struct device *owl_emac_get_dev(struct owl_emac_priv *priv)
+{
+	return priv->netdev->dev.parent;
+}
+
+static void owl_emac_irq_enable(struct owl_emac_priv *priv)
+{
+	/* Enable all interrupts except TU.
+	 *
+	 * Note the NIE and AIE bits shall also be set in order to actually
+	 * enable the selected interrupts.
+	 */
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR7,
+			   OWL_EMAC_BIT_MAC_CSR7_NIE |
+			   OWL_EMAC_BIT_MAC_CSR7_AIE |
+			   OWL_EMAC_BIT_MAC_CSR7_ALL_NOT_TUE);
+}
+
+static void owl_emac_irq_disable(struct owl_emac_priv *priv)
+{
+	/* Disable all interrupts.
+	 *
+	 * WARNING: Unset only the NIE and AIE bits in CSR7 to workaround an
+	 * unexpected side effect (MAC hardware bug?!) where some bits in the
+	 * status register (CSR5) are cleared automatically before being able
+	 * to read them via owl_emac_irq_clear().
+	 */
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR7,
+			   OWL_EMAC_BIT_MAC_CSR7_ALL_NOT_TUE);
+}
+
+static u32 owl_emac_irq_status(struct owl_emac_priv *priv)
+{
+	return owl_emac_reg_read(priv, OWL_EMAC_REG_MAC_CSR5);
+}
+
+static u32 owl_emac_irq_clear(struct owl_emac_priv *priv)
+{
+	u32 val = owl_emac_irq_status(priv);
+
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR5, val);
+
+	return val;
+}
+
+static dma_addr_t owl_emac_dma_map_rx(struct owl_emac_priv *priv,
+				      struct sk_buff *skb)
+{
+	struct device *dev = owl_emac_get_dev(priv);
+
+	/* Buffer pointer for the RX DMA descriptor must be word aligned. */
+	return dma_map_single(dev, skb_tail_pointer(skb),
+			      skb_tailroom(skb), DMA_FROM_DEVICE);
+}
+
+static void owl_emac_dma_unmap_rx(struct owl_emac_priv *priv,
+				  struct sk_buff *skb, dma_addr_t dma_addr)
+{
+	struct device *dev = owl_emac_get_dev(priv);
+
+	dma_unmap_single(dev, dma_addr, skb_tailroom(skb), DMA_FROM_DEVICE);
+}
+
+static dma_addr_t owl_emac_dma_map_tx(struct owl_emac_priv *priv,
+				      struct sk_buff *skb)
+{
+	struct device *dev = owl_emac_get_dev(priv);
+
+	return dma_map_single(dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
+}
+
+static void owl_emac_dma_unmap_tx(struct owl_emac_priv *priv,
+				  struct sk_buff *skb, dma_addr_t dma_addr)
+{
+	struct device *dev = owl_emac_get_dev(priv);
+
+	dma_unmap_single(dev, dma_addr, skb_headlen(skb), DMA_TO_DEVICE);
+}
+
+static unsigned int owl_emac_ring_num_unused(struct owl_emac_ring *ring)
+{
+	return CIRC_SPACE(ring->head, ring->tail, ring->size);
+}
+
+static unsigned int owl_emac_ring_get_next(struct owl_emac_ring *ring,
+					   unsigned int cur)
+{
+	return (cur + 1) & (ring->size - 1);
+}
+
+static inline void owl_emac_ring_push_head(struct owl_emac_ring *ring)
+{
+	ring->head = owl_emac_ring_get_next(ring, ring->head);
+}
+
+static inline void owl_emac_ring_pop_tail(struct owl_emac_ring *ring)
+{
+	ring->tail = owl_emac_ring_get_next(ring, ring->tail);
+}
+
+static struct sk_buff *owl_emac_alloc_skb(struct net_device *netdev)
+{
+	int offset;
+	struct sk_buff *skb;
+
+	skb = netdev_alloc_skb(netdev, OWL_EMAC_RX_FRAME_MAX_LEN +
+			       OWL_EMAC_SKB_RESERVE);
+	if (unlikely(!skb))
+		return NULL;
+
+	/* Ensure 4 bytes DMA alignment. */
+	offset = ((uintptr_t)skb->data) & (OWL_EMAC_SKB_ALIGN - 1);
+	if (unlikely(offset))
+		skb_reserve(skb, OWL_EMAC_SKB_ALIGN - offset);
+
+	return skb;
+}
+
+static int owl_emac_ring_prepare_rx(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->rx_ring;
+	struct device *dev = owl_emac_get_dev(priv);
+	struct net_device *netdev = priv->netdev;
+	struct owl_emac_ring_desc *desc;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	int i;
+
+	for (i = 0; i < ring->size; i++) {
+		skb = owl_emac_alloc_skb(netdev);
+		if (!skb)
+			return -ENOMEM;
+
+		dma_addr = owl_emac_dma_map_rx(priv, skb);
+		if (dma_mapping_error(dev, dma_addr)) {
+			dev_kfree_skb(skb);
+			return -ENOMEM;
+		}
+
+		desc = &ring->descs[i];
+		desc->status = OWL_EMAC_BIT_RDES0_OWN;
+		desc->control = skb_tailroom(skb) & OWL_EMAC_MSK_RDES1_RBS1;
+		desc->buf_addr = dma_addr;
+		desc->reserved = 0;
+
+		ring->skbs[i] = skb;
+		ring->skbs_dma[i] = dma_addr;
+	}
+
+	desc->control |= OWL_EMAC_BIT_RDES1_RER;
+
+	ring->head = 0;
+	ring->tail = 0;
+
+	return 0;
+}
+
+static void owl_emac_ring_prepare_tx(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	struct owl_emac_ring_desc *desc;
+	int i;
+
+	for (i = 0; i < ring->size; i++) {
+		desc = &ring->descs[i];
+
+		desc->status = 0;
+		desc->control = OWL_EMAC_BIT_TDES1_IC;
+		desc->buf_addr = 0;
+		desc->reserved = 0;
+	}
+
+	desc->control |= OWL_EMAC_BIT_TDES1_TER;
+
+	memset(ring->skbs_dma, 0, sizeof(dma_addr_t) * ring->size);
+
+	ring->head = 0;
+	ring->tail = 0;
+}
+
+static void owl_emac_ring_unprepare_rx(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->rx_ring;
+	int i;
+
+	for (i = 0; i < ring->size; i++) {
+		ring->descs[i].status = 0;
+
+		if (!ring->skbs_dma[i])
+			continue;
+
+		owl_emac_dma_unmap_rx(priv, ring->skbs[i], ring->skbs_dma[i]);
+		ring->skbs_dma[i] = 0;
+
+		dev_kfree_skb(ring->skbs[i]);
+		ring->skbs[i] = NULL;
+	}
+}
+
+static void owl_emac_ring_unprepare_tx(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	int i;
+
+	for (i = 0; i < ring->size; i++) {
+		ring->descs[i].status = 0;
+
+		if (!ring->skbs_dma[i])
+			continue;
+
+		owl_emac_dma_unmap_tx(priv, ring->skbs[i], ring->skbs_dma[i]);
+		ring->skbs_dma[i] = 0;
+
+		dev_kfree_skb(ring->skbs[i]);
+		ring->skbs[i] = NULL;
+	}
+}
+
+static int owl_emac_ring_alloc(struct device *dev, struct owl_emac_ring *ring,
+			       unsigned int size)
+{
+	ring->descs = dmam_alloc_coherent(dev,
+					  sizeof(struct owl_emac_ring_desc) * size,
+					  &ring->descs_dma, GFP_KERNEL);
+	if (!ring->descs)
+		return -ENOMEM;
+
+	ring->skbs = devm_kcalloc(dev, size, sizeof(struct sk_buff *),
+				  GFP_KERNEL);
+	if (!ring->skbs)
+		return -ENOMEM;
+
+	ring->skbs_dma = devm_kcalloc(dev, size, sizeof(dma_addr_t),
+				      GFP_KERNEL);
+	if (!ring->skbs_dma)
+		return -ENOMEM;
+
+	ring->size = size;
+
+	return 0;
+}
+
+static void owl_emac_dma_cmd_resume_rx(struct owl_emac_priv *priv)
+{
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR2,
+			   OWL_EMAC_VAL_MAC_CSR2_RPD);
+}
+
+static void owl_emac_dma_cmd_resume_tx(struct owl_emac_priv *priv)
+{
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR1,
+			   OWL_EMAC_VAL_MAC_CSR1_TPD);
+}
+
+static u32 owl_emac_dma_cmd_set_tx(struct owl_emac_priv *priv, u32 status)
+{
+	return owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
+				   OWL_EMAC_BIT_MAC_CSR6_ST, status);
+}
+
+static u32 owl_emac_dma_cmd_start_tx(struct owl_emac_priv *priv)
+{
+	return owl_emac_dma_cmd_set_tx(priv, ~0);
+}
+
+static u32 owl_emac_dma_cmd_set(struct owl_emac_priv *priv, u32 status)
+{
+	return owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
+				   OWL_EMAC_MSK_MAC_CSR6_STSR, status);
+}
+
+static u32 owl_emac_dma_cmd_start(struct owl_emac_priv *priv)
+{
+	return owl_emac_dma_cmd_set(priv, ~0);
+}
+
+static u32 owl_emac_dma_cmd_stop(struct owl_emac_priv *priv)
+{
+	return owl_emac_dma_cmd_set(priv, 0);
+}
+
+static void owl_emac_set_hw_mac_addr(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	u8 *mac_addr = netdev->dev_addr;
+	u32 addr_high, addr_low;
+
+	addr_high = mac_addr[0] << 8 | mac_addr[1];
+	addr_low = mac_addr[2] << 24 | mac_addr[3] << 16 |
+		   mac_addr[4] << 8 | mac_addr[5];
+
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR17, addr_high);
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR16, addr_low);
+}
+
+static void owl_emac_phy_config(struct owl_emac_priv *priv)
+{
+	u32 val, status;
+
+	if (priv->pause) {
+		val = OWL_EMAC_BIT_MAC_CSR20_FCE | OWL_EMAC_BIT_MAC_CSR20_TUE;
+		val |= OWL_EMAC_BIT_MAC_CSR20_TPE | OWL_EMAC_BIT_MAC_CSR20_RPE;
+		val |= OWL_EMAC_BIT_MAC_CSR20_BPE;
+	} else {
+		val = 0;
+	}
+
+	/* Update flow control. */
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR20, val);
+
+	val = (priv->speed == SPEED_100) ? OWL_EMAC_VAL_MAC_CSR6_SPEED_100M :
+					   OWL_EMAC_VAL_MAC_CSR6_SPEED_10M;
+	val <<= OWL_EMAC_OFF_MAC_CSR6_SPEED;
+
+	if (priv->duplex == DUPLEX_FULL)
+		val |= OWL_EMAC_BIT_MAC_CSR6_FD;
+
+	spin_lock_bh(&priv->lock);
+
+	/* Temporarily stop DMA TX & RX. */
+	status = owl_emac_dma_cmd_stop(priv);
+
+	/* Update operation modes. */
+	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
+			    OWL_EMAC_MSK_MAC_CSR6_SPEED |
+			    OWL_EMAC_BIT_MAC_CSR6_FD, val);
+
+	/* Restore DMA TX & RX status. */
+	owl_emac_dma_cmd_set(priv, status);
+
+	spin_unlock_bh(&priv->lock);
+}
+
+static void owl_emac_adjust_link(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	bool state_changed = false;
+
+	if (phydev->link) {
+		if (!priv->link) {
+			priv->link = phydev->link;
+			state_changed = true;
+		}
+
+		if (priv->speed != phydev->speed) {
+			priv->speed = phydev->speed;
+			state_changed = true;
+		}
+
+		if (priv->duplex != phydev->duplex) {
+			priv->duplex = phydev->duplex;
+			state_changed = true;
+		}
+
+		if (priv->pause != phydev->pause) {
+			priv->pause = phydev->pause;
+			state_changed = true;
+		}
+	} else {
+		if (priv->link) {
+			priv->link = phydev->link;
+			state_changed = true;
+		}
+	}
+
+	if (state_changed) {
+		if (phydev->link)
+			owl_emac_phy_config(priv);
+
+		if (netif_msg_link(priv))
+			phy_print_status(phydev);
+	}
+}
+
+static irqreturn_t owl_emac_handle_irq(int irq, void *data)
+{
+	struct net_device *netdev = data;
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+
+	if (netif_running(netdev)) {
+		owl_emac_irq_disable(priv);
+		napi_schedule(&priv->napi);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static inline void owl_emac_ether_addr_push(u8 **dst, const u8 *src)
+{
+	u32 *a = (u32 *)(*dst);
+	const u16 *b = (const u16 *)src;
+
+	a[0] = b[0];
+	a[1] = b[1];
+	a[2] = b[2];
+
+	*dst += 12;
+}
+
+static void
+owl_emac_setup_frame_prepare(struct owl_emac_priv *priv, struct sk_buff *skb)
+{
+	const u8 bcast_addr[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	const u8 *mac_addr = priv->netdev->dev_addr;
+	u8 *frame;
+	int i;
+
+	skb_put(skb, OWL_EMAC_SETUP_FRAME_LEN);
+
+	frame = skb->data;
+	memset(frame, 0, skb->len);
+
+	owl_emac_ether_addr_push(&frame, mac_addr);
+	owl_emac_ether_addr_push(&frame, bcast_addr);
+
+	/* Fill multicast addresses. */
+	WARN_ON(priv->mcaddr_list.count >= OWL_EMAC_MAX_MULTICAST_ADDRS);
+	for (i = 0; i < priv->mcaddr_list.count; i++) {
+		mac_addr = priv->mcaddr_list.addrs[i];
+		owl_emac_ether_addr_push(&frame, mac_addr);
+	}
+}
+
+static int owl_emac_setup_frame_xmit(struct owl_emac_priv *priv)
+{
+	struct net_device *netdev = priv->netdev;
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	struct owl_emac_ring_desc *desc;
+	struct sk_buff *skb;
+	unsigned int tx_head;
+	u32 status, control;
+	dma_addr_t dma_addr;
+	int ret;
+
+	skb = owl_emac_alloc_skb(netdev);
+	if (!skb)
+		return -ENOMEM;
+
+	owl_emac_setup_frame_prepare(priv, skb);
+
+	dma_addr = owl_emac_dma_map_tx(priv, skb);
+	if (dma_mapping_error(owl_emac_get_dev(priv), dma_addr)) {
+		ret = -ENOMEM;
+		goto err_free_skb;
+	}
+
+	spin_lock_bh(&priv->lock);
+
+	tx_head = ring->head;
+	desc = &ring->descs[tx_head];
+
+	status = READ_ONCE(desc->status);
+	control = READ_ONCE(desc->control);
+	dma_rmb(); /* Ensure data has been read before used. */
+
+	if (unlikely(status & OWL_EMAC_BIT_TDES0_OWN) ||
+	    !owl_emac_ring_num_unused(ring)) {
+		spin_unlock_bh(&priv->lock);
+		owl_emac_dma_unmap_tx(priv, skb, dma_addr);
+		ret = -EBUSY;
+		goto err_free_skb;
+	}
+
+	ring->skbs[tx_head] = skb;
+	ring->skbs_dma[tx_head] = dma_addr;
+
+	control &= OWL_EMAC_BIT_TDES1_IC | OWL_EMAC_BIT_TDES1_TER; /* Maintain bits */
+	control |= OWL_EMAC_BIT_TDES1_SET;
+	control |= OWL_EMAC_MSK_TDES1_TBS1 & skb->len;
+
+	WRITE_ONCE(desc->control, control);
+	WRITE_ONCE(desc->buf_addr, dma_addr);
+	dma_wmb(); /* Flush descriptor before changing ownership. */
+	WRITE_ONCE(desc->status, OWL_EMAC_BIT_TDES0_OWN);
+
+	owl_emac_ring_push_head(ring);
+
+	/* Temporarily enable DMA TX. */
+	status = owl_emac_dma_cmd_start_tx(priv);
+
+	/* Trigger setup frame processing. */
+	owl_emac_dma_cmd_resume_tx(priv);
+
+	/* Restore DMA TX status. */
+	owl_emac_dma_cmd_set_tx(priv, status);
+
+	/* Stop regular TX until setup frame is processed. */
+	netif_stop_queue(netdev);
+
+	spin_unlock_bh(&priv->lock);
+
+	return 0;
+
+err_free_skb:
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+static netdev_tx_t owl_emac_ndo_start_xmit(struct sk_buff *skb,
+					   struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	struct device *dev = owl_emac_get_dev(priv);
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	struct owl_emac_ring_desc *desc;
+	unsigned int tx_head;
+	u32 status, control;
+	dma_addr_t dma_addr;
+
+	dma_addr = owl_emac_dma_map_tx(priv, skb);
+	if (dma_mapping_error(dev, dma_addr)) {
+		dev_err_ratelimited(&netdev->dev, "TX DMA mapping failed\n");
+		dev_kfree_skb(skb);
+		netdev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
+
+	spin_lock_bh(&priv->lock);
+
+	tx_head = ring->head;
+	desc = &ring->descs[tx_head];
+
+	status = READ_ONCE(desc->status);
+	control = READ_ONCE(desc->control);
+	dma_rmb(); /* Ensure data has been read before used. */
+
+	if (!owl_emac_ring_num_unused(ring) ||
+	    unlikely(status & OWL_EMAC_BIT_TDES0_OWN)) {
+		netif_stop_queue(netdev);
+		spin_unlock_bh(&priv->lock);
+
+		dev_dbg_ratelimited(&netdev->dev, "TX buffer full, status=0x%08x\n",
+				    owl_emac_irq_status(priv));
+		owl_emac_dma_unmap_tx(priv, skb, dma_addr);
+		netdev->stats.tx_dropped++;
+		return NETDEV_TX_BUSY;
+	}
+
+	ring->skbs[tx_head] = skb;
+	ring->skbs_dma[tx_head] = dma_addr;
+
+	control &= OWL_EMAC_BIT_TDES1_IC | OWL_EMAC_BIT_TDES1_TER; /* Maintain bits */
+	control |= OWL_EMAC_BIT_TDES1_FS | OWL_EMAC_BIT_TDES1_LS;
+	control |= OWL_EMAC_MSK_TDES1_TBS1 & skb->len;
+
+	WRITE_ONCE(desc->control, control);
+	WRITE_ONCE(desc->buf_addr, dma_addr);
+	dma_wmb(); /* Flush descriptor before changing ownership. */
+	WRITE_ONCE(desc->status, OWL_EMAC_BIT_TDES0_OWN);
+
+	owl_emac_dma_cmd_resume_tx(priv);
+	owl_emac_ring_push_head(ring);
+
+	/* FIXME: The transmission is currently restricted to a single frame
+	 * at a time as a workaround for a MAC hardware bug that causes random
+	 * freeze of the TX queue processor.
+	 */
+	netif_stop_queue(netdev);
+
+	spin_unlock_bh(&priv->lock);
+
+	return NETDEV_TX_OK;
+}
+
+static bool owl_emac_tx_complete_tail(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	struct net_device *netdev = priv->netdev;
+	struct owl_emac_ring_desc *desc;
+	struct sk_buff *skb;
+	unsigned int tx_tail;
+	u32 status;
+
+	tx_tail = ring->tail;
+	desc = &ring->descs[tx_tail];
+
+	status = READ_ONCE(desc->status);
+	dma_rmb(); /* Ensure data has been read before used. */
+
+	if (status & OWL_EMAC_BIT_TDES0_OWN)
+		return false;
+
+	/* Check for errors. */
+	if (status & OWL_EMAC_BIT_TDES0_ES) {
+		dev_dbg_ratelimited(&netdev->dev,
+				    "TX complete error status: 0x%08x\n",
+				    status);
+
+		netdev->stats.tx_errors++;
+
+		if (status & OWL_EMAC_BIT_TDES0_UF)
+			netdev->stats.tx_fifo_errors++;
+
+		if (status & OWL_EMAC_BIT_TDES0_EC)
+			netdev->stats.tx_aborted_errors++;
+
+		if (status & OWL_EMAC_BIT_TDES0_LC)
+			netdev->stats.tx_window_errors++;
+
+		if (status & OWL_EMAC_BIT_TDES0_NC)
+			netdev->stats.tx_heartbeat_errors++;
+
+		if (status & OWL_EMAC_BIT_TDES0_LO)
+			netdev->stats.tx_carrier_errors++;
+	} else {
+		netdev->stats.tx_packets++;
+		netdev->stats.tx_bytes += ring->skbs[tx_tail]->len;
+	}
+
+	/* Some collisions occurred, but pkt has been transmitted. */
+	if (status & OWL_EMAC_BIT_TDES0_DE)
+		netdev->stats.collisions++;
+
+	skb = ring->skbs[tx_tail];
+	owl_emac_dma_unmap_tx(priv, skb, ring->skbs_dma[tx_tail]);
+	dev_kfree_skb(skb);
+
+	ring->skbs[tx_tail] = NULL;
+	ring->skbs_dma[tx_tail] = 0;
+
+	owl_emac_ring_pop_tail(ring);
+
+	if (unlikely(netif_queue_stopped(netdev)))
+		netif_wake_queue(netdev);
+
+	return true;
+}
+
+static void owl_emac_tx_complete(struct owl_emac_priv *priv)
+{
+	struct owl_emac_ring *ring = &priv->tx_ring;
+	struct net_device *netdev = priv->netdev;
+	unsigned int tx_next;
+	u32 status;
+
+	spin_lock(&priv->lock);
+
+	while (ring->tail != ring->head) {
+		if (!owl_emac_tx_complete_tail(priv))
+			break;
+	}
+
+	/* FIXME: This is a workaround for a MAC hardware bug not clearing
+	 * (sometimes) the OWN bit for a transmitted frame descriptor.
+	 *
+	 * At this point, when TX queue is full, the tail descriptor has the
+	 * OWN bit set, which normally means the frame has not been processed
+	 * or transmitted yet. But if there is at least one descriptor in the
+	 * queue having the OWN bit cleared, we can safely assume the tail
+	 * frame has been also processed by the MAC hardware.
+	 *
+	 * If that's the case, let's force the frame completion by manually
+	 * clearing the OWN bit.
+	 */
+	if (unlikely(!owl_emac_ring_num_unused(ring))) {
+		tx_next = ring->tail;
+
+		while ((tx_next = owl_emac_ring_get_next(ring, tx_next)) != ring->head) {
+			status = READ_ONCE(ring->descs[tx_next].status);
+			dma_rmb(); /* Ensure data has been read before used. */
+
+			if (status & OWL_EMAC_BIT_TDES0_OWN)
+				continue;
+
+			netdev_dbg(netdev, "Found uncleared TX desc OWN bit\n");
+
+			status = READ_ONCE(ring->descs[ring->tail].status);
+			dma_rmb(); /* Ensure data has been read before used. */
+			status &= ~OWL_EMAC_BIT_TDES0_OWN;
+			WRITE_ONCE(ring->descs[ring->tail].status, status);
+
+			owl_emac_tx_complete_tail(priv);
+			break;
+		}
+	}
+
+	spin_unlock(&priv->lock);
+}
+
+static int owl_emac_rx_process(struct owl_emac_priv *priv, int budget)
+{
+	struct owl_emac_ring *ring = &priv->rx_ring;
+	struct device *dev = owl_emac_get_dev(priv);
+	struct net_device *netdev = priv->netdev;
+	struct owl_emac_ring_desc *desc;
+	struct sk_buff *curr_skb, *new_skb;
+	dma_addr_t curr_dma, new_dma;
+	unsigned int rx_tail, len;
+	u32 status;
+	int recv = 0;
+
+	while (recv < budget) {
+		spin_lock(&priv->lock);
+
+		rx_tail = ring->tail;
+		desc = &ring->descs[rx_tail];
+
+		status = READ_ONCE(desc->status);
+		dma_rmb(); /* Ensure data has been read before used. */
+
+		if (status & OWL_EMAC_BIT_RDES0_OWN) {
+			spin_unlock(&priv->lock);
+			break;
+		}
+
+		curr_skb = ring->skbs[rx_tail];
+		curr_dma = ring->skbs_dma[rx_tail];
+		owl_emac_ring_pop_tail(ring);
+
+		spin_unlock(&priv->lock);
+
+		if (status & (OWL_EMAC_BIT_RDES0_DE | OWL_EMAC_BIT_RDES0_RF |
+		    OWL_EMAC_BIT_RDES0_TL | OWL_EMAC_BIT_RDES0_CS |
+		    OWL_EMAC_BIT_RDES0_DB | OWL_EMAC_BIT_RDES0_CE |
+		    OWL_EMAC_BIT_RDES0_ZERO)) {
+			dev_dbg_ratelimited(&netdev->dev,
+					    "RX desc error status: 0x%08x\n",
+					    status);
+
+			if (status & OWL_EMAC_BIT_RDES0_DE)
+				netdev->stats.rx_over_errors++;
+
+			if (status & (OWL_EMAC_BIT_RDES0_RF | OWL_EMAC_BIT_RDES0_DB))
+				netdev->stats.rx_frame_errors++;
+
+			if (status & OWL_EMAC_BIT_RDES0_TL)
+				netdev->stats.rx_length_errors++;
+
+			if (status & OWL_EMAC_BIT_RDES0_CS)
+				netdev->stats.collisions++;
+
+			if (status & OWL_EMAC_BIT_RDES0_CE)
+				netdev->stats.rx_crc_errors++;
+
+			if (status & OWL_EMAC_BIT_RDES0_ZERO)
+				netdev->stats.rx_fifo_errors++;
+
+			goto drop_skb;
+		}
+
+		len = (status & OWL_EMAC_MSK_RDES0_FL) >> OWL_EMAC_OFF_RDES0_FL;
+		if (unlikely(len > OWL_EMAC_RX_FRAME_MAX_LEN)) {
+			netdev->stats.rx_length_errors++;
+			netdev_err(netdev, "invalid RX frame len: %u\n", len);
+			goto drop_skb;
+		}
+
+		/* Prepare new skb before receiving the current one. */
+		new_skb = owl_emac_alloc_skb(netdev);
+		if (unlikely(!new_skb))
+			goto drop_skb;
+
+		new_dma = owl_emac_dma_map_rx(priv, new_skb);
+		if (dma_mapping_error(dev, new_dma)) {
+			dev_kfree_skb(new_skb);
+			netdev_err(netdev, "RX DMA mapping failed\n");
+			goto drop_skb;
+		}
+
+		owl_emac_dma_unmap_rx(priv, curr_skb, curr_dma);
+
+		skb_put(curr_skb, len - ETH_FCS_LEN);
+		curr_skb->ip_summed = CHECKSUM_NONE;
+		curr_skb->protocol = eth_type_trans(curr_skb, netdev);
+		curr_skb->dev = netdev;
+
+		netif_receive_skb(curr_skb);
+
+		netdev->stats.rx_packets++;
+		netdev->stats.rx_bytes += len;
+		recv++;
+		goto push_skb;
+
+drop_skb:
+		netdev->stats.rx_dropped++;
+		netdev->stats.rx_errors++;
+		/* Reuse the current skb. */
+		new_skb = curr_skb;
+		new_dma = curr_dma;
+
+push_skb:
+		spin_lock(&priv->lock);
+
+		ring->skbs[ring->head] = new_skb;
+		ring->skbs_dma[ring->head] = new_dma;
+
+		WRITE_ONCE(desc->buf_addr, new_dma);
+		dma_wmb(); /* Flush descriptor before changing ownership. */
+		WRITE_ONCE(desc->status, OWL_EMAC_BIT_RDES0_OWN);
+
+		owl_emac_ring_push_head(ring);
+
+		spin_unlock(&priv->lock);
+	}
+
+	return recv;
+}
+
+static int owl_emac_poll(struct napi_struct *napi, int budget)
+{
+	struct owl_emac_priv *priv;
+	u32 status, proc_status;
+	int work_done = 0, recv;
+	static int tx_err_cnt, rx_err_cnt;
+	int ru_cnt = 0;
+
+	priv = container_of(napi, struct owl_emac_priv, napi);
+
+	while ((status = owl_emac_irq_clear(priv)) &
+	       (OWL_EMAC_BIT_MAC_CSR5_NIS | OWL_EMAC_BIT_MAC_CSR5_AIS)) {
+		recv = 0;
+
+		/* TX setup frame raises ETI instead of TI. */
+		if (status & (OWL_EMAC_BIT_MAC_CSR5_TI | OWL_EMAC_BIT_MAC_CSR5_ETI)) {
+			owl_emac_tx_complete(priv);
+			tx_err_cnt = 0;
+
+			/* Count MAC internal RX errors. */
+			proc_status = status & OWL_EMAC_MSK_MAC_CSR5_RS;
+			proc_status >>= OWL_EMAC_OFF_MAC_CSR5_RS;
+			if (proc_status == OWL_EMAC_VAL_MAC_CSR5_RS_DATA ||
+			    proc_status == OWL_EMAC_VAL_MAC_CSR5_RS_CDES ||
+			    proc_status == OWL_EMAC_VAL_MAC_CSR5_RS_FDES)
+				rx_err_cnt++;
+		}
+
+		if (status & OWL_EMAC_BIT_MAC_CSR5_RI) {
+			recv = owl_emac_rx_process(priv, budget - work_done);
+			rx_err_cnt = 0;
+
+			/* Count MAC internal TX errors. */
+			proc_status = status & OWL_EMAC_MSK_MAC_CSR5_TS;
+			proc_status >>= OWL_EMAC_OFF_MAC_CSR5_TS;
+			if (proc_status == OWL_EMAC_VAL_MAC_CSR5_TS_DATA ||
+			    proc_status == OWL_EMAC_VAL_MAC_CSR5_TS_CDES)
+				tx_err_cnt++;
+		} else if (status & OWL_EMAC_BIT_MAC_CSR5_RU) {
+			/* MAC AHB is in suspended state, will return to RX
+			 * descriptor processing when the host changes ownership
+			 * of the descriptor and either an RX poll demand CMD is
+			 * issued or a new frame is recognized by the MAC AHB.
+			 */
+			if (++ru_cnt == 2)
+				owl_emac_dma_cmd_resume_rx(priv);
+
+			recv = owl_emac_rx_process(priv, budget - work_done);
+
+			/* Guard against too many RU interrupts. */
+			if (ru_cnt > 3)
+				break;
+		}
+
+		work_done += recv;
+		if (work_done >= budget)
+			break;
+	}
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		owl_emac_irq_enable(priv);
+	}
+
+	/* Reset MAC when getting too many internal TX or RX errors. */
+	if (tx_err_cnt > 10 || rx_err_cnt > 10) {
+		netdev_dbg(priv->netdev, "%s error status: 0x%08x\n",
+			   tx_err_cnt > 10 ? "TX" : "RX", status);
+		rx_err_cnt = 0;
+		tx_err_cnt = 0;
+		schedule_work(&priv->mac_reset_task);
+	}
+
+	return work_done;
+}
+
+static void owl_emac_mdio_clock_enable(struct owl_emac_priv *priv)
+{
+	u32 val;
+
+	/* Enable MDC clock generation by setting CLKDIV to at least 128. */
+	val = owl_emac_reg_read(priv, OWL_EMAC_REG_MAC_CSR10);
+	val &= OWL_EMAC_MSK_MAC_CSR10_CLKDIV;
+	val |= OWL_EMAC_VAL_MAC_CSR10_CLKDIV_128 << OWL_EMAC_OFF_MAC_CSR10_CLKDIV;
+
+	val |= OWL_EMAC_BIT_MAC_CSR10_SB;
+	val |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_CDS << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR10, val);
+}
+
+static void owl_emac_core_hw_reset(struct owl_emac_priv *priv)
+{
+	/* Trigger hardware reset. */
+	reset_control_assert(priv->reset);
+	usleep_range(10, 20);
+	reset_control_deassert(priv->reset);
+	usleep_range(100, 200);
+}
+
+static int owl_emac_core_sw_reset(struct owl_emac_priv *priv)
+{
+	u32 val;
+	int ret;
+
+	/* Trigger software reset. */
+	owl_emac_reg_set(priv, OWL_EMAC_REG_MAC_CSR0, OWL_EMAC_BIT_MAC_CSR0_SWR);
+	ret = readl_poll_timeout(priv->base + OWL_EMAC_REG_MAC_CSR0,
+				 val, !(val & OWL_EMAC_BIT_MAC_CSR0_SWR),
+				 OWL_EMAC_POLL_DELAY_USEC,
+				 OWL_EMAC_RESET_POLL_TIMEOUT_USEC);
+	if (ret)
+		return ret;
+
+	/* MDC is disabled after reset. */
+	owl_emac_mdio_clock_enable(priv);
+
+	/* Set RMII op mode and internal 50M RMII clock as output for PHY. */
+	owl_emac_reg_clear(priv, OWL_EMAC_REG_MAC_CTRL,
+			   OWL_EMAC_BIT_MAC_CTRL_RSIS |
+			   OWL_EMAC_BIT_MAC_CTRL_RRSB |
+			   OWL_EMAC_BIT_MAC_CTRL_RCPS);
+
+	/* Set FIFO pause & restart threshold levels. */
+	val = 0x40 << OWL_EMAC_OFF_MAC_CSR19_FPTL;
+	val |= 0x10 << OWL_EMAC_OFF_MAC_CSR19_FRTL;
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR19, val);
+
+	/* Set flow control pause quanta time to ~100 ms. */
+	val = 0x4FFF << OWL_EMAC_OFF_MAC_CSR18_PQT;
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR18, val);
+
+	/* Setup interrupt mitigation. */
+	val = 7 << OWL_EMAC_OFF_MAC_CSR11_NRP;
+	val |= 4 << OWL_EMAC_OFF_MAC_CSR11_RT;
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR11, val);
+
+	/* Set RX/TX rings base addresses. */
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR3,
+			   (u32)(priv->rx_ring.descs_dma));
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR4,
+			   (u32)(priv->tx_ring.descs_dma));
+
+	/* Setup initial operation mode. */
+	val = OWL_EMAC_VAL_MAC_CSR6_SPEED_100M << OWL_EMAC_OFF_MAC_CSR6_SPEED;
+	val |= OWL_EMAC_BIT_MAC_CSR6_FD;
+	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
+			    OWL_EMAC_MSK_MAC_CSR6_SPEED |
+			    OWL_EMAC_BIT_MAC_CSR6_FD, val);
+	owl_emac_reg_clear(priv, OWL_EMAC_REG_MAC_CSR6,
+			   OWL_EMAC_BIT_MAC_CSR6_PR | OWL_EMAC_BIT_MAC_CSR6_PM);
+
+	priv->link = 0;
+	priv->speed = SPEED_UNKNOWN;
+	priv->duplex = DUPLEX_UNKNOWN;
+	priv->pause = 0;
+	priv->mcaddr_list.count = 0;
+
+	return 0;
+}
+
+static int owl_emac_enable(struct net_device *netdev, bool start_phy)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	int ret;
+
+	owl_emac_dma_cmd_stop(priv);
+	owl_emac_irq_disable(priv);
+	owl_emac_irq_clear(priv);
+
+	owl_emac_ring_prepare_tx(priv);
+	ret = owl_emac_ring_prepare_rx(priv);
+	if (ret)
+		goto err_unprep;
+
+	ret = owl_emac_core_sw_reset(priv);
+	if (ret) {
+		netdev_err(netdev, "failed to soft reset MAC core: %d\n", ret);
+		goto err_unprep;
+	}
+
+	owl_emac_set_hw_mac_addr(netdev);
+	owl_emac_setup_frame_xmit(priv);
+
+	netdev_reset_queue(netdev);
+	napi_enable(&priv->napi);
+
+	owl_emac_irq_enable(priv);
+	owl_emac_dma_cmd_start(priv);
+
+	if (start_phy)
+		phy_start(netdev->phydev);
+
+	netif_start_queue(netdev);
+
+	return 0;
+
+err_unprep:
+	owl_emac_ring_unprepare_rx(priv);
+	owl_emac_ring_unprepare_tx(priv);
+
+	return ret;
+}
+
+static void owl_emac_disable(struct net_device *netdev, bool stop_phy)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+
+	owl_emac_dma_cmd_stop(priv);
+	owl_emac_irq_disable(priv);
+
+	netif_stop_queue(netdev);
+	napi_disable(&priv->napi);
+
+	if (stop_phy)
+		phy_stop(netdev->phydev);
+
+	owl_emac_ring_unprepare_rx(priv);
+	owl_emac_ring_unprepare_tx(priv);
+}
+
+static int owl_emac_ndo_open(struct net_device *netdev)
+{
+	return owl_emac_enable(netdev, true);
+}
+
+static int owl_emac_ndo_stop(struct net_device *netdev)
+{
+	owl_emac_disable(netdev, true);
+
+	return 0;
+}
+
+static void owl_emac_set_multicast(struct net_device *netdev, int count)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	struct netdev_hw_addr *ha;
+	int index = 0;
+
+	if (count <= 0) {
+		priv->mcaddr_list.count = 0;
+		return;
+	}
+
+	netdev_for_each_mc_addr(ha, netdev) {
+		if (!is_multicast_ether_addr(ha->addr))
+			continue;
+
+		WARN_ON(index >= OWL_EMAC_MAX_MULTICAST_ADDRS);
+		ether_addr_copy(priv->mcaddr_list.addrs[index++], ha->addr);
+	}
+
+	priv->mcaddr_list.count = index;
+
+	owl_emac_setup_frame_xmit(priv);
+}
+
+static void owl_emac_ndo_set_rx_mode(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	u32 status, val = 0;
+	int mcast_count = 0;
+
+	if (netdev->flags & IFF_PROMISC) {
+		val = OWL_EMAC_BIT_MAC_CSR6_PR;
+	} else if (netdev->flags & IFF_ALLMULTI) {
+		val = OWL_EMAC_BIT_MAC_CSR6_PM;
+	} else if (netdev->flags & IFF_MULTICAST) {
+		mcast_count = netdev_mc_count(netdev);
+
+		if (mcast_count > OWL_EMAC_MAX_MULTICAST_ADDRS) {
+			val = OWL_EMAC_BIT_MAC_CSR6_PM;
+			mcast_count = 0;
+		}
+	}
+
+	spin_lock_bh(&priv->lock);
+
+	/* Temporarily stop DMA TX & RX. */
+	status = owl_emac_dma_cmd_stop(priv);
+
+	/* Update operation modes. */
+	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
+			    OWL_EMAC_BIT_MAC_CSR6_PR | OWL_EMAC_BIT_MAC_CSR6_PM,
+			    val);
+
+	/* Restore DMA TX & RX status. */
+	owl_emac_dma_cmd_set(priv, status);
+
+	spin_unlock_bh(&priv->lock);
+
+	/* Set/reset multicast addr list. */
+	owl_emac_set_multicast(netdev, mcast_count);
+}
+
+static int owl_emac_ndo_set_mac_addr(struct net_device *netdev, void *addr)
+{
+	struct sockaddr *skaddr = addr;
+
+	if (!is_valid_ether_addr(skaddr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	if (netif_running(netdev))
+		return -EBUSY;
+
+	memcpy(netdev->dev_addr, skaddr->sa_data, netdev->addr_len);
+	owl_emac_set_hw_mac_addr(netdev);
+
+	return owl_emac_setup_frame_xmit(netdev_priv(netdev));
+}
+
+static int owl_emac_ndo_do_ioctl(struct net_device *netdev,
+				 struct ifreq *req, int cmd)
+{
+	if (!netif_running(netdev))
+		return -EINVAL;
+
+	return phy_mii_ioctl(netdev->phydev, req, cmd);
+}
+
+static void owl_emac_ndo_tx_timeout(struct net_device *netdev,
+				    unsigned int txqueue)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+
+	schedule_work(&priv->mac_reset_task);
+}
+
+static void owl_emac_reset_task(struct work_struct *work)
+{
+	struct owl_emac_priv *priv;
+
+	priv = container_of(work, struct owl_emac_priv, mac_reset_task);
+
+	netdev_dbg(priv->netdev, "resetting MAC\n");
+	owl_emac_disable(priv->netdev, false);
+	owl_emac_enable(priv->netdev, false);
+}
+
+static struct net_device_stats *
+owl_emac_ndo_get_stats(struct net_device *netdev)
+{
+	/* FIXME: If possible, try to get stats from MAC hardware registers
+	 * instead of tracking them manually in the driver.
+	 */
+
+	return &netdev->stats;
+}
+
+static const struct net_device_ops owl_emac_netdev_ops = {
+	.ndo_open		= owl_emac_ndo_open,
+	.ndo_stop		= owl_emac_ndo_stop,
+	.ndo_start_xmit		= owl_emac_ndo_start_xmit,
+	.ndo_set_rx_mode	= owl_emac_ndo_set_rx_mode,
+	.ndo_set_mac_address	= owl_emac_ndo_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_do_ioctl		= owl_emac_ndo_do_ioctl,
+	.ndo_tx_timeout         = owl_emac_ndo_tx_timeout,
+	.ndo_get_stats		= owl_emac_ndo_get_stats,
+};
+
+static void owl_emac_ethtool_get_drvinfo(struct net_device *dev,
+					 struct ethtool_drvinfo *info)
+{
+	strscpy(info->driver, OWL_EMAC_DRVNAME, sizeof(info->driver));
+}
+
+static u32 owl_emac_ethtool_get_msglevel(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+
+	return priv->msg_enable;
+}
+
+static void owl_emac_ethtool_set_msglevel(struct net_device *ndev, u32 val)
+{
+	struct owl_emac_priv *priv = netdev_priv(ndev);
+
+	priv->msg_enable = val;
+}
+
+static const struct ethtool_ops owl_emac_ethtool_ops = {
+	.get_drvinfo		= owl_emac_ethtool_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.get_msglevel		= owl_emac_ethtool_get_msglevel,
+	.set_msglevel		= owl_emac_ethtool_set_msglevel,
+};
+
+static int owl_emac_mdio_wait(struct owl_emac_priv *priv)
+{
+	u32 val;
+
+	/* Wait while data transfer is in progress. */
+	return readl_poll_timeout(priv->base + OWL_EMAC_REG_MAC_CSR10,
+				  val, !(val & OWL_EMAC_BIT_MAC_CSR10_SB),
+				  OWL_EMAC_POLL_DELAY_USEC,
+				  OWL_EMAC_MDIO_POLL_TIMEOUT_USEC);
+}
+
+static int owl_emac_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct owl_emac_priv *priv = bus->priv;
+	u32 data, tmp;
+	int ret;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	data = OWL_EMAC_BIT_MAC_CSR10_SB;
+	data |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_RD << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
+
+	tmp = addr << OWL_EMAC_OFF_MAC_CSR10_PHYADD;
+	data |= tmp & OWL_EMAC_MSK_MAC_CSR10_PHYADD;
+
+	tmp = regnum << OWL_EMAC_OFF_MAC_CSR10_REGADD;
+	data |= tmp & OWL_EMAC_MSK_MAC_CSR10_REGADD;
+
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR10, data);
+
+	ret = owl_emac_mdio_wait(priv);
+	if (ret)
+		return ret;
+
+	data = owl_emac_reg_read(priv, OWL_EMAC_REG_MAC_CSR10);
+	data &= OWL_EMAC_MSK_MAC_CSR10_DATA;
+
+	return data;
+}
+
+static int
+owl_emac_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	struct owl_emac_priv *priv = bus->priv;
+	u32 data, tmp;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	data = OWL_EMAC_BIT_MAC_CSR10_SB;
+	data |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_WR << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
+
+	tmp = addr << OWL_EMAC_OFF_MAC_CSR10_PHYADD;
+	data |= tmp & OWL_EMAC_MSK_MAC_CSR10_PHYADD;
+
+	tmp = regnum << OWL_EMAC_OFF_MAC_CSR10_REGADD;
+	data |= tmp & OWL_EMAC_MSK_MAC_CSR10_REGADD;
+
+	data |= val & OWL_EMAC_MSK_MAC_CSR10_DATA;
+
+	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR10, data);
+
+	return owl_emac_mdio_wait(priv);
+}
+
+static int owl_emac_mdio_init(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	struct device *dev = owl_emac_get_dev(priv);
+	struct device_node *mdio_node;
+	int ret;
+
+	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
+	if (!mdio_node)
+		return -ENODEV;
+
+	if (!of_device_is_available(mdio_node)) {
+		ret = -ENODEV;
+		goto err_put_node;
+	}
+
+	priv->mii = devm_mdiobus_alloc(dev);
+	if (!priv->mii) {
+		ret = -ENOMEM;
+		goto err_put_node;
+	}
+
+	snprintf(priv->mii->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+	priv->mii->name = "owl-emac-mdio";
+	priv->mii->parent = dev;
+	priv->mii->read = owl_emac_mdio_read;
+	priv->mii->write = owl_emac_mdio_write;
+	priv->mii->phy_mask = ~0; /* Mask out all PHYs from auto probing. */
+	priv->mii->priv = priv;
+
+	ret = devm_of_mdiobus_register(dev, priv->mii, mdio_node);
+
+err_put_node:
+	of_node_put(mdio_node);
+	return ret;
+}
+
+static int owl_emac_phy_init(struct net_device *netdev)
+{
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	struct device *dev = owl_emac_get_dev(priv);
+	struct phy_device *phy;
+
+	phy = of_phy_get_and_connect(netdev, dev->of_node,
+				     owl_emac_adjust_link);
+	if (!phy)
+		return -ENODEV;
+
+	if (phy->interface != PHY_INTERFACE_MODE_RMII) {
+		netdev_err(netdev, "unsupported phy mode: %s\n",
+			   phy_modes(phy->interface));
+		phy_disconnect(phy);
+		netdev->phydev = NULL;
+		return -EINVAL;
+	}
+
+	if (netif_msg_link(priv))
+		phy_attached_info(phy);
+
+	return 0;
+}
+
+/* Generate the MAC address based on the system serial number.
+ */
+static int owl_emac_generate_mac_addr(struct net_device *netdev)
+{
+	int ret = -ENXIO;
+
+#ifdef CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN
+	struct device *dev = netdev->dev.parent;
+	struct crypto_sync_skcipher *tfm;
+	struct scatterlist sg;
+	const u8 key[] = { 1, 4, 13, 21, 59, 67, 69, 127 };
+	u64 sn;
+	u8 enc_sn[sizeof(key)];
+
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
+
+	sn = ((u64)system_serial_high << 32) | system_serial_low;
+	if (!sn)
+		return ret;
+
+	tfm = crypto_alloc_sync_skcipher("ecb(des)", 0, 0);
+	if (IS_ERR(tfm)) {
+		dev_err(dev, "failed to allocate cipher: %ld\n", PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	ret = crypto_sync_skcipher_setkey(tfm, key, sizeof(key));
+	if (ret) {
+		dev_err(dev, "failed to set cipher key: %d\n", ret);
+		goto err_free_tfm;
+	}
+
+	memcpy(enc_sn, &sn, sizeof(enc_sn));
+
+	sg_init_one(&sg, enc_sn, sizeof(enc_sn));
+	skcipher_request_set_sync_tfm(req, tfm);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, &sg, &sg, sizeof(enc_sn), NULL);
+
+	ret = crypto_skcipher_encrypt(req);
+	if (ret) {
+		dev_err(dev, "failed to encrypt S/N: %d\n", ret);
+		goto err_free_tfm;
+	}
+
+	netdev->dev_addr[0] = 0xF4;
+	netdev->dev_addr[1] = 0x4E;
+	netdev->dev_addr[2] = 0xFD;
+	netdev->dev_addr[3] = enc_sn[0];
+	netdev->dev_addr[4] = enc_sn[4];
+	netdev->dev_addr[5] = enc_sn[7];
+
+err_free_tfm:
+	crypto_free_sync_skcipher(tfm);
+#endif /* CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN */
+
+	return ret;
+}
+
+static void owl_emac_get_mac_addr(struct net_device *netdev)
+{
+	struct device *dev = netdev->dev.parent;
+	int ret;
+
+	ret = eth_platform_get_mac_address(dev, netdev->dev_addr);
+	if (!ret && is_valid_ether_addr(netdev->dev_addr))
+		return;
+
+	ret = owl_emac_generate_mac_addr(netdev);
+	if (!ret && is_valid_ether_addr(netdev->dev_addr)) {
+		dev_info(dev, "using system S/N based MAC address %pM\n",
+			 netdev->dev_addr);
+		return;
+	}
+
+	eth_hw_addr_random(netdev);
+	dev_warn(dev, "using random MAC address %pM\n", netdev->dev_addr);
+}
+
+static __maybe_unused int owl_emac_suspend(struct device *dev)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+
+	disable_irq(netdev->irq);
+
+	if (netif_running(netdev)) {
+		owl_emac_disable(netdev, true);
+		netif_device_detach(netdev);
+	}
+
+	clk_bulk_disable_unprepare(OWL_EMAC_NCLKS, priv->clks);
+
+	return 0;
+}
+
+static __maybe_unused int owl_emac_resume(struct device *dev)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct owl_emac_priv *priv = netdev_priv(netdev);
+	int ret;
+
+	ret = clk_bulk_prepare_enable(OWL_EMAC_NCLKS, priv->clks);
+	if (ret)
+		return ret;
+
+	if (netif_running(netdev)) {
+		owl_emac_core_hw_reset(priv);
+		owl_emac_core_sw_reset(priv);
+
+		ret = owl_emac_enable(netdev, true);
+		if (ret) {
+			clk_bulk_disable_unprepare(OWL_EMAC_NCLKS, priv->clks);
+			return ret;
+		}
+
+		netif_device_attach(netdev);
+	}
+
+	enable_irq(netdev->irq);
+
+	return 0;
+}
+
+static void owl_emac_clk_disable_unprepare(void *data)
+{
+	struct owl_emac_priv *priv = data;
+
+	clk_bulk_disable_unprepare(OWL_EMAC_NCLKS, priv->clks);
+}
+
+static int owl_emac_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct net_device *netdev;
+	struct owl_emac_priv *priv;
+	int ret, i;
+
+	netdev = devm_alloc_etherdev(dev, sizeof(*priv));
+	if (!netdev)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, netdev);
+	SET_NETDEV_DEV(netdev, dev);
+
+	priv = netdev_priv(netdev);
+	priv->netdev = netdev;
+	priv->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
+
+	spin_lock_init(&priv->lock);
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(dev, "unsupported DMA mask\n");
+		return ret;
+	}
+
+	ret = owl_emac_ring_alloc(dev, &priv->rx_ring, OWL_EMAC_RX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = owl_emac_ring_alloc(dev, &priv->tx_ring, OWL_EMAC_TX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	netdev->irq = platform_get_irq(pdev, 0);
+	if (netdev->irq < 0)
+		return netdev->irq;
+
+	ret = devm_request_irq(dev, netdev->irq, owl_emac_handle_irq,
+			       IRQF_SHARED, netdev->name, netdev);
+	if (ret) {
+		dev_err(dev, "failed to request irq: %d\n", netdev->irq);
+		return ret;
+	}
+
+	for (i = 0; i < OWL_EMAC_NCLKS; i++)
+		priv->clks[i].id = owl_emac_clk_names[i];
+
+	ret = devm_clk_bulk_get(dev, OWL_EMAC_NCLKS, priv->clks);
+	if (ret)
+		return ret;
+
+	ret = clk_bulk_prepare_enable(OWL_EMAC_NCLKS, priv->clks);
+	if (ret)
+		return ret;
+
+	ret = clk_set_rate(priv->clks[OWL_EMAC_CLK_RMII].clk, 50000000);
+	if (ret) {
+		dev_err(dev, "failed to set RMII clock rate: %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_add_action_or_reset(dev, owl_emac_clk_disable_unprepare, priv);
+	if (ret)
+		return ret;
+
+	priv->reset = devm_reset_control_get(dev, NULL);
+	if (IS_ERR(priv->reset)) {
+		ret = PTR_ERR(priv->reset);
+		dev_err(dev, "failed to get reset control: %d\n", ret);
+		return ret;
+	}
+
+	owl_emac_get_mac_addr(netdev);
+
+	owl_emac_core_hw_reset(priv);
+	owl_emac_mdio_clock_enable(priv);
+
+	ret = owl_emac_mdio_init(netdev);
+	if (ret) {
+		dev_err(dev, "failed to initialize MDIO bus\n");
+		return ret;
+	}
+
+	ret = owl_emac_phy_init(netdev);
+	if (ret) {
+		dev_err(dev, "failed to initialize PHY\n");
+		return ret;
+	}
+
+	INIT_WORK(&priv->mac_reset_task, owl_emac_reset_task);
+
+	netdev->min_mtu = OWL_EMAC_MTU_MIN;
+	netdev->max_mtu = OWL_EMAC_MTU_MAX;
+	netdev->watchdog_timeo = OWL_EMAC_TX_TIMEOUT;
+	netdev->netdev_ops = &owl_emac_netdev_ops;
+	netdev->ethtool_ops = &owl_emac_ethtool_ops;
+	netif_napi_add(netdev, &priv->napi, owl_emac_poll, NAPI_POLL_WEIGHT);
+
+	ret = devm_register_netdev(dev, netdev);
+	if (ret) {
+		netif_napi_del(&priv->napi);
+		phy_disconnect(netdev->phydev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int owl_emac_remove(struct platform_device *pdev)
+{
+	struct owl_emac_priv *priv = platform_get_drvdata(pdev);
+
+	netif_napi_del(&priv->napi);
+	phy_disconnect(priv->netdev->phydev);
+	cancel_work_sync(&priv->mac_reset_task);
+
+	return 0;
+}
+
+static const struct of_device_id owl_emac_of_match[] = {
+	{ .compatible = "actions,owl-emac", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, owl_emac_of_match);
+
+static SIMPLE_DEV_PM_OPS(owl_emac_pm_ops,
+			 owl_emac_suspend, owl_emac_resume);
+
+static struct platform_driver owl_emac_driver = {
+	.driver = {
+		.name = OWL_EMAC_DRVNAME,
+		.of_match_table = owl_emac_of_match,
+		.pm = &owl_emac_pm_ops,
+	},
+	.probe = owl_emac_probe,
+	.remove = owl_emac_remove,
+};
+module_platform_driver(owl_emac_driver);
+
+MODULE_DESCRIPTION("Actions Semi Owl SoCs Ethernet MAC Driver");
+MODULE_AUTHOR("Actions Semi Inc.");
+MODULE_AUTHOR("Cristian Ciocaltea <cristian.ciocaltea@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/actions/owl-emac.h b/drivers/net/ethernet/actions/owl-emac.h
new file mode 100644
index 000000000000..e94734512cb9
--- /dev/null
+++ b/drivers/net/ethernet/actions/owl-emac.h
@@ -0,0 +1,278 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Actions Semi Owl SoCs Ethernet MAC driver
+ *
+ * Copyright (c) 2012 Actions Semi Inc.
+ * Copyright (c) 2021 Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
+ */
+
+#ifndef __OWL_EMAC_H__
+#define __OWL_EMAC_H__
+
+#define OWL_EMAC_DRVNAME			"owl-emac"
+
+#define OWL_EMAC_POLL_DELAY_USEC		5
+#define OWL_EMAC_MDIO_POLL_TIMEOUT_USEC		1000
+#define OWL_EMAC_RESET_POLL_TIMEOUT_USEC	2000
+#define OWL_EMAC_TX_TIMEOUT			(0.05 * HZ)
+
+#define OWL_EMAC_MTU_MIN			ETH_MIN_MTU
+#define OWL_EMAC_MTU_MAX			ETH_DATA_LEN
+#define OWL_EMAC_RX_FRAME_MAX_LEN		(ETH_FRAME_LEN + ETH_FCS_LEN)
+#define OWL_EMAC_SKB_ALIGN			4
+#define OWL_EMAC_SKB_RESERVE			18
+
+#define OWL_EMAC_MAX_MULTICAST_ADDRS		14
+#define OWL_EMAC_SETUP_FRAME_LEN		192
+
+#define OWL_EMAC_RX_RING_SIZE			64
+#define OWL_EMAC_TX_RING_SIZE			32
+
+/* Bus mode register */
+#define OWL_EMAC_REG_MAC_CSR0			0x0000
+#define OWL_EMAC_BIT_MAC_CSR0_SWR		BIT(0)	/* Software reset */
+
+/* Transmit/receive poll demand registers */
+#define OWL_EMAC_REG_MAC_CSR1			0x0008
+#define OWL_EMAC_VAL_MAC_CSR1_TPD		0x01
+#define OWL_EMAC_REG_MAC_CSR2			0x0010
+#define OWL_EMAC_VAL_MAC_CSR2_RPD		0x01
+
+/* Receive/transmit descriptor list base address registers */
+#define OWL_EMAC_REG_MAC_CSR3			0x0018
+#define OWL_EMAC_REG_MAC_CSR4			0x0020
+
+/* Status register */
+#define OWL_EMAC_REG_MAC_CSR5			0x0028
+#define OWL_EMAC_MSK_MAC_CSR5_TS		GENMASK(22, 20)	/* Transmit process state */
+#define OWL_EMAC_OFF_MAC_CSR5_TS		20
+#define OWL_EMAC_VAL_MAC_CSR5_TS_DATA		0x03	/* Transferring data HOST -> FIFO */
+#define OWL_EMAC_VAL_MAC_CSR5_TS_CDES		0x07	/* Closing transmit descriptor */
+#define OWL_EMAC_MSK_MAC_CSR5_RS		GENMASK(19, 17)	/* Receive process state */
+#define OWL_EMAC_OFF_MAC_CSR5_RS		17
+#define OWL_EMAC_VAL_MAC_CSR5_RS_FDES		0x01	/* Fetching receive descriptor */
+#define OWL_EMAC_VAL_MAC_CSR5_RS_CDES		0x05	/* Closing receive descriptor */
+#define OWL_EMAC_VAL_MAC_CSR5_RS_DATA		0x07	/* Transferring data FIFO -> HOST */
+#define OWL_EMAC_BIT_MAC_CSR5_NIS		BIT(16)	/* Normal interrupt summary */
+#define OWL_EMAC_BIT_MAC_CSR5_AIS		BIT(15)	/* Abnormal interrupt summary */
+#define OWL_EMAC_BIT_MAC_CSR5_ERI		BIT(14)	/* Early receive interrupt */
+#define OWL_EMAC_BIT_MAC_CSR5_GTE		BIT(11)	/* General-purpose timer expiration */
+#define OWL_EMAC_BIT_MAC_CSR5_ETI		BIT(10)	/* Early transmit interrupt */
+#define OWL_EMAC_BIT_MAC_CSR5_RPS		BIT(8)	/* Receive process stopped */
+#define OWL_EMAC_BIT_MAC_CSR5_RU		BIT(7)	/* Receive buffer unavailable */
+#define OWL_EMAC_BIT_MAC_CSR5_RI		BIT(6)	/* Receive interrupt */
+#define OWL_EMAC_BIT_MAC_CSR5_UNF		BIT(5)	/* Transmit underflow */
+#define OWL_EMAC_BIT_MAC_CSR5_LCIS		BIT(4)	/* Link change status */
+#define OWL_EMAC_BIT_MAC_CSR5_LCIQ		BIT(3)	/* Link change interrupt */
+#define OWL_EMAC_BIT_MAC_CSR5_TU		BIT(2)	/* Transmit buffer unavailable */
+#define OWL_EMAC_BIT_MAC_CSR5_TPS		BIT(1)	/* Transmit process stopped */
+#define OWL_EMAC_BIT_MAC_CSR5_TI		BIT(0)	/* Transmit interrupt */
+
+/* Operation mode register */
+#define OWL_EMAC_REG_MAC_CSR6			0x0030
+#define OWL_EMAC_BIT_MAC_CSR6_RA		BIT(30)	/* Receive all */
+#define OWL_EMAC_BIT_MAC_CSR6_TTM		BIT(22)	/* Transmit threshold mode */
+#define OWL_EMAC_BIT_MAC_CSR6_SF		BIT(21)	/* Store and forward */
+#define OWL_EMAC_MSK_MAC_CSR6_SPEED		GENMASK(17, 16)	/* Eth speed selection */
+#define OWL_EMAC_OFF_MAC_CSR6_SPEED		16
+#define OWL_EMAC_VAL_MAC_CSR6_SPEED_100M	0x00
+#define OWL_EMAC_VAL_MAC_CSR6_SPEED_10M		0x02
+#define OWL_EMAC_BIT_MAC_CSR6_ST		BIT(13)	/* Start/stop transmit command */
+#define OWL_EMAC_BIT_MAC_CSR6_LP		BIT(10)	/* Loopback mode */
+#define OWL_EMAC_BIT_MAC_CSR6_FD		BIT(9)	/* Full duplex mode */
+#define OWL_EMAC_BIT_MAC_CSR6_PM		BIT(7)	/* Pass all multicast */
+#define OWL_EMAC_BIT_MAC_CSR6_PR		BIT(6)	/* Promiscuous mode */
+#define OWL_EMAC_BIT_MAC_CSR6_IF		BIT(4)	/* Inverse filtering */
+#define OWL_EMAC_BIT_MAC_CSR6_PB		BIT(3)	/* Pass bad frames */
+#define OWL_EMAC_BIT_MAC_CSR6_HO		BIT(2)	/* Hash only filtering mode */
+#define OWL_EMAC_BIT_MAC_CSR6_SR		BIT(1)	/* Start/stop receive command */
+#define OWL_EMAC_BIT_MAC_CSR6_HP		BIT(0)	/* Hash/perfect receive filtering mode */
+#define OWL_EMAC_MSK_MAC_CSR6_STSR	       (OWL_EMAC_BIT_MAC_CSR6_ST | \
+						OWL_EMAC_BIT_MAC_CSR6_SR)
+
+/* Interrupt enable register */
+#define OWL_EMAC_REG_MAC_CSR7			0x0038
+#define OWL_EMAC_BIT_MAC_CSR7_NIE		BIT(16)	/* Normal interrupt summary enable */
+#define OWL_EMAC_BIT_MAC_CSR7_AIE		BIT(15)	/* Abnormal interrupt summary enable */
+#define OWL_EMAC_BIT_MAC_CSR7_ERE		BIT(14)	/* Early receive interrupt enable */
+#define OWL_EMAC_BIT_MAC_CSR7_GTE		BIT(11)	/* General-purpose timer overflow */
+#define OWL_EMAC_BIT_MAC_CSR7_ETE		BIT(10)	/* Early transmit interrupt enable */
+#define OWL_EMAC_BIT_MAC_CSR7_RSE		BIT(8)	/* Receive stopped enable */
+#define OWL_EMAC_BIT_MAC_CSR7_RUE		BIT(7)	/* Receive buffer unavailable enable */
+#define OWL_EMAC_BIT_MAC_CSR7_RIE		BIT(6)	/* Receive interrupt enable */
+#define OWL_EMAC_BIT_MAC_CSR7_UNE		BIT(5)	/* Underflow interrupt enable */
+#define OWL_EMAC_BIT_MAC_CSR7_TUE		BIT(2)	/* Transmit buffer unavailable enable */
+#define OWL_EMAC_BIT_MAC_CSR7_TSE		BIT(1)	/* Transmit stopped enable */
+#define OWL_EMAC_BIT_MAC_CSR7_TIE		BIT(0)	/* Transmit interrupt enable */
+#define OWL_EMAC_BIT_MAC_CSR7_ALL_NOT_TUE      (OWL_EMAC_BIT_MAC_CSR7_ERE | \
+						OWL_EMAC_BIT_MAC_CSR7_GTE | \
+						OWL_EMAC_BIT_MAC_CSR7_ETE | \
+						OWL_EMAC_BIT_MAC_CSR7_RSE | \
+						OWL_EMAC_BIT_MAC_CSR7_RUE | \
+						OWL_EMAC_BIT_MAC_CSR7_RIE | \
+						OWL_EMAC_BIT_MAC_CSR7_UNE | \
+						OWL_EMAC_BIT_MAC_CSR7_TSE | \
+						OWL_EMAC_BIT_MAC_CSR7_TIE)
+
+/* Missed frames and overflow counter register */
+#define OWL_EMAC_REG_MAC_CSR8			0x0040
+/* MII management and serial ROM register */
+#define OWL_EMAC_REG_MAC_CSR9			0x0048
+
+/* MII serial management register */
+#define OWL_EMAC_REG_MAC_CSR10			0x0050
+#define OWL_EMAC_BIT_MAC_CSR10_SB		BIT(31)	/* Start transfer or busy */
+#define OWL_EMAC_MSK_MAC_CSR10_CLKDIV		GENMASK(30, 28)	/* Clock divider */
+#define OWL_EMAC_OFF_MAC_CSR10_CLKDIV		28
+#define OWL_EMAC_VAL_MAC_CSR10_CLKDIV_128	0x04
+#define OWL_EMAC_VAL_MAC_CSR10_OPCODE_WR	0x01	/* Register write command */
+#define OWL_EMAC_OFF_MAC_CSR10_OPCODE		26	/* Operation mode */
+#define OWL_EMAC_VAL_MAC_CSR10_OPCODE_DCG	0x00	/* Disable clock generation */
+#define OWL_EMAC_VAL_MAC_CSR10_OPCODE_WR	0x01	/* Register write command */
+#define OWL_EMAC_VAL_MAC_CSR10_OPCODE_RD	0x02	/* Register read command */
+#define OWL_EMAC_VAL_MAC_CSR10_OPCODE_CDS	0x03	/* Clock divider set */
+#define OWL_EMAC_MSK_MAC_CSR10_PHYADD		GENMASK(25, 21)	/* Physical layer address */
+#define OWL_EMAC_OFF_MAC_CSR10_PHYADD		21
+#define OWL_EMAC_MSK_MAC_CSR10_REGADD		GENMASK(20, 16)	/* Register address */
+#define OWL_EMAC_OFF_MAC_CSR10_REGADD		16
+#define OWL_EMAC_MSK_MAC_CSR10_DATA		GENMASK(15, 0)	/* Register data */
+
+/* General-purpose timer and interrupt mitigation control register */
+#define OWL_EMAC_REG_MAC_CSR11			0x0058
+#define OWL_EMAC_OFF_MAC_CSR11_TT		27	/* Transmit timer */
+#define OWL_EMAC_OFF_MAC_CSR11_NTP		24	/* No. of transmit packets */
+#define OWL_EMAC_OFF_MAC_CSR11_RT		20	/* Receive timer */
+#define OWL_EMAC_OFF_MAC_CSR11_NRP		17	/* No. of receive packets */
+
+/* MAC address low/high registers */
+#define OWL_EMAC_REG_MAC_CSR16			0x0080
+#define OWL_EMAC_REG_MAC_CSR17			0x0088
+
+/* Pause time & cache thresholds register */
+#define OWL_EMAC_REG_MAC_CSR18			0x0090
+#define OWL_EMAC_OFF_MAC_CSR18_CPTL		24	/* Cache pause threshold level */
+#define OWL_EMAC_OFF_MAC_CSR18_CRTL		16	/* Cache restart threshold level */
+#define OWL_EMAC_OFF_MAC_CSR18_PQT		0	/* Flow control pause quanta time */
+
+/* FIFO pause & restart threshold register */
+#define OWL_EMAC_REG_MAC_CSR19			0x0098
+#define OWL_EMAC_OFF_MAC_CSR19_FPTL		16	/* FIFO pause threshold level */
+#define OWL_EMAC_OFF_MAC_CSR19_FRTL		0	/* FIFO restart threshold level */
+
+/* Flow control setup & status register */
+#define OWL_EMAC_REG_MAC_CSR20			0x00A0
+#define OWL_EMAC_BIT_MAC_CSR20_FCE		BIT(31)	/* Flow Control Enable */
+#define OWL_EMAC_BIT_MAC_CSR20_TUE		BIT(30)	/* Transmit Un-pause frames Enable */
+#define OWL_EMAC_BIT_MAC_CSR20_TPE		BIT(29)	/* Transmit Pause frames Enable */
+#define OWL_EMAC_BIT_MAC_CSR20_RPE		BIT(28)	/* Receive Pause frames Enable */
+#define OWL_EMAC_BIT_MAC_CSR20_BPE		BIT(27)	/* Back pressure (half-duplex) Enable */
+
+/* MII control register */
+#define OWL_EMAC_REG_MAC_CTRL			0x00B0
+#define OWL_EMAC_BIT_MAC_CTRL_RRSB		BIT(8)	/* RMII_REFCLK select bit */
+#define OWL_EMAC_BIT_MAC_CTRL_RCPS		BIT(1)	/* REF_CLK phase select */
+#define OWL_EMAC_BIT_MAC_CTRL_RSIS		BIT(0)	/* RMII/SMII interface select */
+
+/* Receive descriptor status field */
+#define OWL_EMAC_BIT_RDES0_OWN			BIT(31)	/* Ownership bit */
+#define OWL_EMAC_BIT_RDES0_FF			BIT(30)	/* Filtering fail */
+#define OWL_EMAC_MSK_RDES0_FL			GENMASK(29, 16)	/* Frame length */
+#define OWL_EMAC_OFF_RDES0_FL			16
+#define OWL_EMAC_BIT_RDES0_ES			BIT(15)	/* Error summary */
+#define OWL_EMAC_BIT_RDES0_DE			BIT(14)	/* Descriptor error */
+#define OWL_EMAC_BIT_RDES0_RF			BIT(11)	/* Runt frame */
+#define OWL_EMAC_BIT_RDES0_MF			BIT(10)	/* Multicast frame */
+#define OWL_EMAC_BIT_RDES0_FS			BIT(9)	/* First descriptor */
+#define OWL_EMAC_BIT_RDES0_LS			BIT(8)	/* Last descriptor */
+#define OWL_EMAC_BIT_RDES0_TL			BIT(7)	/* Frame too long */
+#define OWL_EMAC_BIT_RDES0_CS			BIT(6)	/* Collision seen */
+#define OWL_EMAC_BIT_RDES0_FT			BIT(5)	/* Frame type */
+#define OWL_EMAC_BIT_RDES0_RE			BIT(3)	/* Report on MII error */
+#define OWL_EMAC_BIT_RDES0_DB			BIT(2)	/* Dribbling bit */
+#define OWL_EMAC_BIT_RDES0_CE			BIT(1)	/* CRC error */
+#define OWL_EMAC_BIT_RDES0_ZERO			BIT(0)	/* Legal frame length indicator */
+
+/* Receive descriptor control and count field */
+#define OWL_EMAC_BIT_RDES1_RER			BIT(25)	/* Receive end of ring */
+#define OWL_EMAC_MSK_RDES1_RBS1			GENMASK(10, 0) /* Buffer 1 size */
+
+/* Transmit descriptor status field */
+#define OWL_EMAC_BIT_TDES0_OWN			BIT(31)	/* Ownership bit */
+#define OWL_EMAC_BIT_TDES0_ES			BIT(15)	/* Error summary */
+#define OWL_EMAC_BIT_TDES0_LO			BIT(11)	/* Loss of carrier */
+#define OWL_EMAC_BIT_TDES0_NC			BIT(10)	/* No carrier */
+#define OWL_EMAC_BIT_TDES0_LC			BIT(9)	/* Late collision */
+#define OWL_EMAC_BIT_TDES0_EC			BIT(8)	/* Excessive collisions */
+#define OWL_EMAC_MSK_TDES0_CC			GENMASK(6, 3) /* Collision count */
+#define OWL_EMAC_BIT_TDES0_UF			BIT(1)	/* Underflow error */
+#define OWL_EMAC_BIT_TDES0_DE			BIT(0)	/* Deferred */
+
+/* Transmit descriptor control and count field */
+#define OWL_EMAC_BIT_TDES1_IC			BIT(31)	/* Interrupt on completion */
+#define OWL_EMAC_BIT_TDES1_LS			BIT(30)	/* Last descriptor */
+#define OWL_EMAC_BIT_TDES1_FS			BIT(29)	/* First descriptor */
+#define OWL_EMAC_BIT_TDES1_FT1			BIT(28)	/* Filtering type */
+#define OWL_EMAC_BIT_TDES1_SET			BIT(27)	/* Setup packet */
+#define OWL_EMAC_BIT_TDES1_AC			BIT(26)	/* Add CRC disable */
+#define OWL_EMAC_BIT_TDES1_TER			BIT(25)	/* Transmit end of ring */
+#define OWL_EMAC_BIT_TDES1_DPD			BIT(23)	/* Disabled padding */
+#define OWL_EMAC_BIT_TDES1_FT0			BIT(22)	/* Filtering type */
+#define OWL_EMAC_MSK_TDES1_TBS1			GENMASK(10, 0) /* Buffer 1 size */
+
+static const char *const owl_emac_clk_names[] = { "eth", "rmii" };
+#define OWL_EMAC_NCLKS ARRAY_SIZE(owl_emac_clk_names)
+
+enum owl_emac_clk_map {
+	OWL_EMAC_CLK_ETH = 0,
+	OWL_EMAC_CLK_RMII
+};
+
+struct owl_emac_addr_list {
+	u8 addrs[OWL_EMAC_MAX_MULTICAST_ADDRS][ETH_ALEN];
+	int count;
+};
+
+/* TX/RX descriptors */
+struct owl_emac_ring_desc {
+	u32 status;
+	u32 control;
+	u32 buf_addr;
+	u32 reserved;		/* 2nd buffer address is not used */
+};
+
+struct owl_emac_ring {
+	struct owl_emac_ring_desc *descs;
+	dma_addr_t descs_dma;
+	struct sk_buff **skbs;
+	dma_addr_t *skbs_dma;
+	unsigned int size;
+	unsigned int head;
+	unsigned int tail;
+};
+
+struct owl_emac_priv {
+	struct net_device *netdev;
+	void __iomem *base;
+
+	struct clk_bulk_data clks[OWL_EMAC_NCLKS];
+	struct reset_control *reset;
+
+	struct owl_emac_ring rx_ring;
+	struct owl_emac_ring tx_ring;
+
+	struct mii_bus *mii;
+	struct napi_struct napi;
+
+	unsigned int link;
+	int speed;
+	int duplex;
+	int pause;
+	struct owl_emac_addr_list mcaddr_list;
+
+	struct work_struct mac_reset_task;
+
+	u32 msg_enable;		/* Debug message level */
+	spinlock_t lock;	/* Sync concurrent ring access */
+};
+
+#endif /* __OWL_EMAC_H__ */
-- 
2.30.2

