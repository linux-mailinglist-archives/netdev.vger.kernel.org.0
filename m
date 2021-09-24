Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB4417D27
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbhIXVq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348636AbhIXVqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29114C061767;
        Fri, 24 Sep 2021 14:45:14 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id dw14so7907101pjb.1;
        Fri, 24 Sep 2021 14:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lrGE8kbK4wx77uFsQtJv3fgQvXuJslkax3BKAk6QNgE=;
        b=G2ImoihfQhIKqjD6Y9UQfJ1k+5NXSUFzE2/EiNnSSPx/vu+hiwf/IuxTxhKL+0V5Kt
         e1/0haHRSe4L2yaoNQ+xTYPNneFPOs1yDVyhie2joxXjINq00okLOovB+ReDKMkb84bq
         zziyGVZUn8RQF6jfb0iioCD7I4Ehjhoxl5etHMNioFljaoYhIVrzmD4G6ElTHJnHB64P
         +/EizS1RZzbA7zoP6SnNlkpKymaXtGCDNHvFr5wsA8AbDmF4dyZyLT3m3C3ILjZlWDyw
         kwBYPJVz8AsLJ2X+bZApYRo+dnl0nF5EREhjkMyUlqRxtI3oeUkvmJuts2vhcyPSGn16
         eBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lrGE8kbK4wx77uFsQtJv3fgQvXuJslkax3BKAk6QNgE=;
        b=rTyxeTB2CrrYPI4Lihuvg/f/2FZCge4OIWe3KPvM9RDparyeLZuZZ40ibzdRdNnGNM
         852NrKXQmvORfKr7AB7HLCoAX5DBy/KjPdvQhpdY0ZHngZ/sauyeXdENeLP5egrEx1hV
         1sjH8mGwDGqej3dDOGYT7cfsr/LRLHIIakjnXl4I9yEU8Y6WXxx7BNJk3QJVNnBDpL9r
         mIwxPEzDvYr4JIUZdxEu3T8puf/oaNU7K+9QBJCiFtJdVyURpkijXGdt4iAfuD/iDcz7
         2Ji3n4ri0bhraaUR1rSf+JX0HTkWj2XRmfHby67NMl6IICujV5Iy60uetVs5LEPj0UWv
         YF8w==
X-Gm-Message-State: AOAM5300VpdnLWGaIahIwJRN8lE4LBeMTkWtv0CFbr8H7n2ciwWxKiDX
        UWU1B5UivzrPiJq75ajxsnM33fX1thd/MQ==
X-Google-Smtp-Source: ABdhPJxLThCG/dvaM+QvhoW/J8kQ93BjhOmCy2eE2oPkdSe5CwVUZcSORD/UnvNaCi7eJH15CX8okw==
X-Received: by 2002:a17:902:ab16:b0:13a:356c:6a03 with SMTP id ik22-20020a170902ab1600b0013a356c6a03mr10863024plb.38.1632519911874;
        Fri, 24 Sep 2021 14:45:11 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.45.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:11 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0 Ethernet controller
Date:   Fri, 24 Sep 2021 14:44:49 -0700
Message-Id: <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Broadcom ASP 2.0 Ethernet controller which is first
introduced with 72165. This controller features two distinct Ethernet
ports that can be independently operated.

This patch supports:

- Wake-on-LAN using magic packets
- basic ethtool operations (link, counters, message level)
- MAC destination address filtering (promiscuous, ALL_MULTI, etc.)

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/Kconfig              |   11 +
 drivers/net/ethernet/broadcom/Makefile             |    1 +
 drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1351 +++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  565 ++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  628 +++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1414 ++++++++++++++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  187 +++
 8 files changed, 4159 insertions(+)
 create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 56e0fb0..244b389 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -253,4 +253,15 @@ config BNXT_HWMON
 	  Say Y if you want to expose the thermal sensor data on NetXtreme-C/E
 	  devices, via the hwmon sysfs interface.
 
+config BCMASP
+	tristate "Broadcom ASP 2.0 Ethernet support"
+	default ARCH_BRCMSTB
+	depends on OF
+	select MII
+	select PHYLIB
+	select MDIO_BCM_UNIMAC
+	help
+	  This configuration enables the Broadcom ASP 2.0 Ethernet controller
+	  driver which is present in Broadcom STB SoCs such as 72165.
+
 endif # NET_VENDOR_BROADCOM
diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 0ddfb5b..bac5cb6 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+obj-$(CONFIG_BCMASP) += asp2/
diff --git a/drivers/net/ethernet/broadcom/asp2/Makefile b/drivers/net/ethernet/broadcom/asp2/Makefile
new file mode 100644
index 0000000..e075503
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BCMASP) += bcm-asp.o
+bcm-asp-objs := bcmasp.o bcmasp_intf.o bcmasp_ethtool.o
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
new file mode 100644
index 0000000..72effa8
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -0,0 +1,1351 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Broadcom STB ASP 2.0 Driver
+ *
+ * Copyright (c) 2020 Broadcom
+ */
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/clk.h>
+
+#include "bcmasp.h"
+
+static const struct of_device_id bcmasp_of_match[] = {
+	{ .compatible = "brcm,asp-v2.0", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, bcmasp_of_match);
+
+static const struct of_device_id bcmasp_mdio_of_match[] = {
+	{ .compatible = "brcm,asp-v2.0-mdio", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, bcmasp_of_match);
+
+static inline void _intr2_mask_clear(struct bcmasp_priv *priv, u32 mask)
+{
+	priv->irq_mask &= ~mask;
+	intr2_core_wl(priv, mask, ASP_INTR2_MASK_CLEAR);
+}
+
+static inline void _intr2_mask_set(struct bcmasp_priv *priv, u32 mask)
+{
+	intr2_core_wl(priv, mask, ASP_INTR2_MASK_SET);
+	priv->irq_mask |= mask;
+}
+
+void bcmasp_enable_tx_irq(struct bcmasp_intf *intf, int en)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	int ch = intf->channel;
+
+	if (en)
+		_intr2_mask_clear(priv, ASP_INTR2_TX_DESC(ch));
+	else
+		_intr2_mask_set(priv, ASP_INTR2_TX_DESC(ch));
+}
+
+void bcmasp_enable_rx_irq(struct bcmasp_intf *intf, int en)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	int ch = intf->channel;
+
+	if (en)
+		_intr2_mask_clear(priv, ASP_INTR2_RX_ECH(ch));
+	else
+		_intr2_mask_set(priv, ASP_INTR2_RX_ECH(ch));
+}
+
+static irqreturn_t bcmasp_isr(int irq, void *data)
+{
+	struct bcmasp_priv *priv = data;
+	struct bcmasp_intf *intf;
+	u32 status, i;
+
+	status = intr2_core_rl(priv, ASP_INTR2_STATUS) &
+		~intr2_core_rl(priv, ASP_INTR2_MASK_STATUS);
+	intr2_core_wl(priv, status, ASP_INTR2_CLEAR);
+
+	if (unlikely(status == 0)) {
+		dev_warn(&priv->pdev->dev, "spurious interrupt\n");
+		return IRQ_NONE;
+	}
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		if (unlikely(!intf))
+			continue;
+
+		if (status & ASP_INTR2_RX_ECH(intf->channel)) {
+			if (likely(napi_schedule_prep(&intf->rx_napi))) {
+				bcmasp_enable_rx_irq(intf, 0);
+				__napi_schedule_irqoff(&intf->rx_napi);
+			}
+		}
+
+		if (status & ASP_INTR2_TX_DESC(intf->channel)) {
+			if (likely(napi_schedule_prep(&intf->tx_napi))) {
+				bcmasp_enable_tx_irq(intf, 0);
+				__napi_schedule_irqoff(&intf->tx_napi);
+			}
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+void bcmasp_flush_rx_port(struct bcmasp_intf *intf)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	u32 mask;
+
+	switch (intf->port) {
+	case 0:
+		mask = ASP_CTRL_UMAC0_FLUSH_MASK;
+		break;
+	case 1:
+		mask = ASP_CTRL_UMAC1_FLUSH_MASK;
+		break;
+	default:
+		/* Not valid port */
+		return;
+	}
+
+	rx_ctrl_core_wl(priv, mask, ASP_RX_CTRL_FLUSH);
+}
+
+static void bcmasp_netfilt_hw_en_wake(struct bcmasp_priv *priv,
+				      struct bcmasp_net_filter *nfilt)
+{
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_OFFSET_L3_1(64),
+			  ASP_RX_FILTER_NET_OFFSET(nfilt->hw_index));
+
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_OFFSET_L2(32) |
+			  ASP_RX_FILTER_NET_OFFSET_L3_0(32) |
+			  ASP_RX_FILTER_NET_OFFSET_L3_1(96) |
+			  ASP_RX_FILTER_NET_OFFSET_L4(32),
+			  ASP_RX_FILTER_NET_OFFSET(nfilt->hw_index + 1));
+
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->port + 8) |
+			  ASP_RX_FILTER_NET_CFG_EN |
+			  ASP_RX_FILTER_NET_CFG_L2_EN |
+			  ASP_RX_FILTER_NET_CFG_L3_EN |
+			  ASP_RX_FILTER_NET_CFG_L4_EN |
+			  ASP_RX_FILTER_NET_CFG_L3_FRM(2) |
+			  ASP_RX_FILTER_NET_CFG_L4_FRM(2) |
+			  ASP_RX_FILTER_NET_CFG_UMC(nfilt->port),
+			  ASP_RX_FILTER_NET_CFG(nfilt->hw_index));
+
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->port + 8) |
+			  ASP_RX_FILTER_NET_CFG_EN |
+			  ASP_RX_FILTER_NET_CFG_L2_EN |
+			  ASP_RX_FILTER_NET_CFG_L3_EN |
+			  ASP_RX_FILTER_NET_CFG_L4_EN |
+			  ASP_RX_FILTER_NET_CFG_L3_FRM(2) |
+			  ASP_RX_FILTER_NET_CFG_L4_FRM(2) |
+			  ASP_RX_FILTER_NET_CFG_UMC(nfilt->port),
+			  ASP_RX_FILTER_NET_CFG(nfilt->hw_index + 1));
+}
+
+#define MAX_WAKE_FILTER_SIZE		256
+enum asp_netfilt_reg_type {
+	ASP_NETFILT_MATCH = 0,
+	ASP_NETFILT_MASK,
+	ASP_NETFILT_MAX
+};
+
+static int bcmasp_netfilt_get_reg_offset(struct bcmasp_priv *priv,
+					 struct bcmasp_net_filter *nfilt,
+					 enum asp_netfilt_reg_type reg_type,
+					 u32 offset)
+{
+	u32 block_index, filter_sel;
+
+	if (offset < 32) {
+		block_index = ASP_RX_FILTER_L2;
+		filter_sel = nfilt->hw_index;
+	} else if (offset < 64) {
+		block_index = ASP_RX_FILTER_L2;
+		filter_sel = nfilt->hw_index + 1;
+	} else if (offset < 96) {
+		block_index = ASP_RX_FILTER_L3_0;
+		filter_sel = nfilt->hw_index;
+	} else if (offset < 128) {
+		block_index = ASP_RX_FILTER_L3_0;
+		filter_sel = nfilt->hw_index + 1;
+	} else if (offset < 160) {
+		block_index = ASP_RX_FILTER_L3_1;
+		filter_sel = nfilt->hw_index;
+	} else if (offset < 192) {
+		block_index = ASP_RX_FILTER_L3_1;
+		filter_sel = nfilt->hw_index + 1;
+	} else if (offset < 224) {
+		block_index = ASP_RX_FILTER_L4;
+		filter_sel = nfilt->hw_index;
+	} else if (offset < 256) {
+		block_index = ASP_RX_FILTER_L4;
+		filter_sel = nfilt->hw_index + 1;
+	}
+
+	switch (reg_type) {
+	case ASP_NETFILT_MATCH:
+		return ASP_RX_FILTER_NET_PAT(filter_sel, block_index,
+					     (offset % 32));
+	case ASP_NETFILT_MASK:
+		return ASP_RX_FILTER_NET_MASK(filter_sel, block_index,
+					      (offset % 32));
+	default:
+		return -EINVAL;
+	}
+}
+
+static void bcmasp_netfilt_wr(struct bcmasp_priv *priv,
+			      struct bcmasp_net_filter *nfilt,
+			      enum asp_netfilt_reg_type reg_type,
+			      u32 val, u32 offset)
+{
+	int reg_offset;
+
+	/* HW only accepts 4 byte aligned writes */
+	if (!IS_ALIGNED(offset, 4) || (offset > MAX_WAKE_FILTER_SIZE))
+		return;
+
+	reg_offset = bcmasp_netfilt_get_reg_offset(priv, nfilt, reg_type,
+						   offset);
+
+	rx_filter_core_wl(priv, val, reg_offset);
+}
+
+static u32 bcmasp_netfilt_rd(struct bcmasp_priv *priv,
+			     struct bcmasp_net_filter *nfilt,
+			     enum asp_netfilt_reg_type reg_type,
+			     u32 offset)
+{
+	int reg_offset;
+
+	/* HW only accepts 4 byte aligned writes */
+	if (!IS_ALIGNED(offset, 4) || (offset > MAX_WAKE_FILTER_SIZE))
+		return 0;
+
+	reg_offset = bcmasp_netfilt_get_reg_offset(priv, nfilt, reg_type,
+						   offset);
+
+	return rx_filter_core_rl(priv, reg_offset);
+}
+
+static int bcmasp_netfilt_wr_m_wake(struct bcmasp_priv *priv,
+				    struct bcmasp_net_filter *nfilt,
+				    u32 offset, void *match, void *mask,
+				    size_t size)
+{
+	u32 shift, mask_val = 0, match_val = 0;
+	bool first_byte = true;
+
+	if ((offset + size) > MAX_WAKE_FILTER_SIZE)
+		return -EINVAL;
+
+	while (size--) {
+		/* The HW only accepts 4 byte aligned writes, so if we
+		 * begin unaligned or if remaining bytes less than 4,
+		 * we need to read then write to avoid losing current
+		 * register state
+		 */
+		if (first_byte && (!IS_ALIGNED(offset, 4) || (size < 3))) {
+			match_val = bcmasp_netfilt_rd(priv, nfilt,
+						      ASP_NETFILT_MATCH,
+						      ALIGN_DOWN(offset, 4));
+			mask_val = bcmasp_netfilt_rd(priv, nfilt,
+						     ASP_NETFILT_MASK,
+						     ALIGN_DOWN(offset, 4));
+		}
+
+		shift = (3 - (offset % 4)) * 8;
+		match_val &= ~GENMASK(shift + 7, shift);
+		mask_val &= ~GENMASK(shift + 7, shift);
+		match_val |= (u32)(*((u8 *)match) << shift);
+		mask_val |= (u32)(*((u8 *)mask) << shift);
+
+
+		/* If last byte or last byte of word, write to reg */
+		if (!size || ((offset % 4) == 3)) {
+			bcmasp_netfilt_wr(priv, nfilt, ASP_NETFILT_MATCH,
+					  match_val, ALIGN_DOWN(offset, 4));
+			bcmasp_netfilt_wr(priv, nfilt, ASP_NETFILT_MASK,
+					  mask_val, ALIGN_DOWN(offset, 4));
+			first_byte = true;
+		} else {
+			first_byte = false;
+		}
+
+		offset++;
+		match++;
+		mask++;
+	}
+
+	return 0;
+}
+
+static void bcmasp_netfilt_reset_hw(struct bcmasp_priv *priv,
+				    struct bcmasp_net_filter *nfilt)
+{
+	int i;
+
+	for (i = 0; i < MAX_WAKE_FILTER_SIZE; i += 4) {
+		bcmasp_netfilt_wr(priv, nfilt, ASP_NETFILT_MATCH, 0, i);
+		bcmasp_netfilt_wr(priv, nfilt, ASP_NETFILT_MASK, 0, i);
+	}
+}
+
+static void bcmasp_netfilt_tcpip4_wr(struct bcmasp_priv *priv,
+				     struct bcmasp_net_filter *nfilt,
+				     struct ethtool_tcpip4_spec *match,
+				     struct ethtool_tcpip4_spec *mask,
+				     u32 offset)
+{
+	__be16 val_16, mask_16;
+
+	val_16 = htons(ETH_P_IP);
+	mask_16 = 0xFFFF;
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, (ETH_ALEN * 2) + offset,
+				 &val_16, &mask_16, sizeof(val_16));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 1,
+				 &match->tos, &mask->tos,
+				 sizeof(match->tos));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 12,
+				 &match->ip4src, &mask->ip4src,
+				 sizeof(match->ip4src));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 16,
+				 &match->ip4dst, &mask->ip4dst,
+				 sizeof(match->ip4dst));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 20,
+				 &match->psrc, &mask->psrc,
+				 sizeof(match->psrc));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 22,
+				 &match->pdst, &mask->pdst,
+				 sizeof(match->pdst));
+}
+
+static void bcmasp_netfilt_tcpip6_wr(struct bcmasp_priv *priv,
+				     struct bcmasp_net_filter *nfilt,
+				     struct ethtool_tcpip6_spec *match,
+				     struct ethtool_tcpip6_spec *mask,
+				     u32 offset)
+{
+	__be16 val_16, mask_16;
+
+	val_16 = htons(ETH_P_IPV6);
+	mask_16 = 0xFFFF;
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, (ETH_ALEN * 2) + offset,
+				 &val_16, &mask_16, sizeof(val_16));
+	val_16 = match->tclass << 4;
+	mask_16 = mask->tclass << 4;
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset,
+				 &val_16, &mask_16, sizeof(val_16));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 8,
+				 &match->ip6src, &mask->ip6src,
+				 sizeof(match->ip6src));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 24,
+				 &match->ip6dst, &mask->ip6dst,
+				 sizeof(match->ip6dst));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 40,
+				 &match->psrc, &mask->psrc,
+				 sizeof(match->psrc));
+	bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 42,
+				 &match->pdst, &mask->pdst,
+				 sizeof(match->pdst));
+}
+
+static int bcmasp_netfilt_wr_to_hw(struct bcmasp_priv *priv,
+				   struct bcmasp_net_filter *nfilt)
+{
+	struct ethtool_rx_flow_spec *fs = &nfilt->fs;
+	unsigned int offset = 0;
+	__be16 val_16, mask_16;
+	u8 val_8, mask_8;
+
+	/* Shouldn't get here, but just a quick sanity test */
+	if (nfilt->reserved) {
+		dev_warn(&priv->pdev->dev, "Attempted to use reserved filter\n");
+		return -EINVAL;
+	}
+
+	/* Currently only supports wake filters */
+	if (!nfilt->wake_filter)
+		return -EINVAL;
+
+	bcmasp_netfilt_reset_hw(priv, nfilt);
+
+	if (fs->flow_type & FLOW_MAC_EXT) {
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, 0, &fs->h_ext.h_dest,
+					 &fs->m_ext.h_dest,
+					 sizeof(fs->h_ext.h_dest));
+	}
+
+	if ((fs->flow_type & FLOW_EXT) &&
+	    (fs->m_ext.vlan_etype || fs->m_ext.vlan_tci)) {
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, (ETH_ALEN * 2),
+					 &fs->h_ext.vlan_etype,
+					 &fs->m_ext.vlan_etype,
+					 sizeof(fs->h_ext.vlan_etype));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ((ETH_ALEN * 2) + 2),
+					 &fs->h_ext.vlan_tci,
+					 &fs->m_ext.vlan_tci,
+					 sizeof(fs->h_ext.vlan_tci));
+		offset += VLAN_HLEN;
+	}
+
+	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	case ETHER_FLOW:
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, 0,
+					 &fs->h_u.ether_spec.h_dest,
+					 &fs->m_u.ether_spec.h_dest,
+					 sizeof(fs->h_u.ether_spec.h_dest));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_ALEN,
+					 &fs->h_u.ether_spec.h_source,
+					 &fs->m_u.ether_spec.h_source,
+					 sizeof(fs->h_u.ether_spec.h_source));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, (ETH_ALEN * 2) + offset,
+					 &fs->h_u.ether_spec.h_proto,
+					 &fs->m_u.ether_spec.h_proto,
+					 sizeof(fs->h_u.ether_spec.h_proto));
+
+		break;
+	case IP_USER_FLOW:
+		val_16 = htons(ETH_P_IP);
+		mask_16 = 0xFFFF;
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, (ETH_ALEN * 2) + offset,
+					 &val_16, &mask_16, sizeof(val_16));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 1,
+					 &fs->h_u.usr_ip4_spec.tos,
+					 &fs->m_u.usr_ip4_spec.tos,
+					 sizeof(fs->h_u.usr_ip4_spec.tos));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 9,
+					 &fs->h_u.usr_ip4_spec.proto,
+					 &fs->m_u.usr_ip4_spec.proto,
+					 sizeof(fs->h_u.usr_ip4_spec.proto));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 12,
+					 &fs->h_u.usr_ip4_spec.ip4src,
+					 &fs->m_u.usr_ip4_spec.ip4src,
+					 sizeof(fs->h_u.usr_ip4_spec.ip4src));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 16,
+					 &fs->h_u.usr_ip4_spec.ip4dst,
+					 &fs->m_u.usr_ip4_spec.ip4dst,
+					 sizeof(fs->h_u.usr_ip4_spec.ip4dst));
+		if (!fs->m_u.usr_ip4_spec.l4_4_bytes)
+			break;
+
+		/* Only supports 20 byte IPv4 header */
+		val_8 = 0x45;
+		mask_8 = 0xFF;
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset,
+					 &val_8, &mask_8, sizeof(val_8));
+		bcmasp_netfilt_wr_m_wake(priv, nfilt,
+					 ETH_HLEN + 20 + offset,
+					 &fs->h_u.usr_ip4_spec.l4_4_bytes,
+					 &fs->m_u.usr_ip4_spec.l4_4_bytes,
+					 sizeof(
+					 fs->h_u.usr_ip4_spec.l4_4_bytes));
+		break;
+	case TCP_V4_FLOW:
+		val_8 = IPPROTO_TCP;
+		mask_8 = 0xFF;
+		bcmasp_netfilt_tcpip4_wr(priv, nfilt, &fs->h_u.tcp_ip4_spec,
+					 &fs->m_u.tcp_ip4_spec, offset);
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 9,
+					 &val_8, &mask_8, sizeof(val_8));
+		break;
+	case UDP_V4_FLOW:
+		val_8 = IPPROTO_UDP;
+		mask_8 = 0xFF;
+		bcmasp_netfilt_tcpip4_wr(priv, nfilt, &fs->h_u.udp_ip4_spec,
+					 &fs->m_u.udp_ip4_spec, offset);
+
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 9,
+					 &val_8, &mask_8, sizeof(val_8));
+		break;
+	case TCP_V6_FLOW:
+		val_8 = IPPROTO_TCP;
+		mask_8 = 0xFF;
+		bcmasp_netfilt_tcpip6_wr(priv, nfilt, &fs->h_u.tcp_ip6_spec,
+					 &fs->m_u.tcp_ip6_spec, offset);
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 6,
+					 &val_8, &mask_8, sizeof(val_8));
+		break;
+	case UDP_V6_FLOW:
+		val_8 = IPPROTO_UDP;
+		mask_8 = 0xFF;
+		bcmasp_netfilt_tcpip6_wr(priv, nfilt, &fs->h_u.udp_ip6_spec,
+					 &fs->m_u.udp_ip6_spec, offset);
+		bcmasp_netfilt_wr_m_wake(priv, nfilt, ETH_HLEN + offset + 6,
+					 &val_8, &mask_8, sizeof(val_8));
+		break;
+	}
+
+	bcmasp_netfilt_hw_en_wake(priv, nfilt);
+
+	return 0;
+}
+
+void bcmasp_netfilt_suspend(struct bcmasp_intf *intf)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	bool write = false;
+	int ret, i;
+
+	/* Write all filters to HW */
+	for (i = 0; i < ASP_RX_NET_FILTER_MAX; i++) {
+		/* If the filter is reserved by firmware or does not match
+		 * the port, skip programming.
+		 */
+		if (priv->net_filters[i].reserved ||
+		    (priv->net_filters[i].port != intf->port))
+			continue;
+
+		if (i > 0 && (i % 2) &&
+		    priv->net_filters[i].wake_filter &&
+		    priv->net_filters[i - 1].wake_filter)
+			continue;
+
+		ret = bcmasp_netfilt_wr_to_hw(priv, &priv->net_filters[i]);
+		if (!ret)
+			write = true;
+	}
+
+	/* Successfully programmed at least one wake filter
+	 * so enable top level wake config
+	 */
+	if (write)
+		rx_filter_core_wl(priv, (ASP_RX_FILTER_OPUT_EN |
+				  ASP_RX_FILTER_LNR_MD |
+				  ASP_RX_FILTER_GEN_WK_EN |
+				  ASP_RX_FILTER_NT_FLT_EN),
+				  ASP_RX_FILTER_BLK_CTRL);
+}
+
+int bcmasp_netfilt_get_max(struct bcmasp_intf *intf)
+{
+	return intf->parent->net_filters_count_max;
+}
+
+void bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
+				   u32 *rule_cnt)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	int j = 0, i;
+
+	for (i = 0; i < ASP_RX_NET_FILTER_MAX; i++) {
+		if (priv->net_filters[i].reserved ||
+		    !priv->net_filters[i].claimed ||
+		    (priv->net_filters[i].port != intf->port))
+			continue;
+
+		if (i > 0 && (i % 2) &&
+		    priv->net_filters[i].wake_filter &&
+		    priv->net_filters[i - 1].wake_filter)
+			continue;
+
+		rule_locs[j++] = priv->net_filters[i].fs.location;
+	}
+
+	*rule_cnt = j;
+}
+
+int bcmasp_netfilt_get_active(struct bcmasp_intf *intf)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	int cnt = 0, i;
+
+	for (i = 0; i < ASP_RX_NET_FILTER_MAX; i++) {
+		if (priv->net_filters[i].reserved ||
+		    !priv->net_filters[i].claimed ||
+		    (priv->net_filters[i].port != intf->port))
+			continue;
+
+		/* Skip over a wake filter pair */
+		if (i > 0 && (i % 2) &&
+		    priv->net_filters[i].wake_filter &&
+		    priv->net_filters[i - 1].wake_filter)
+			continue;
+
+		cnt++;
+	}
+
+	return cnt;
+}
+
+int bcmasp_netfilt_check_dup(struct bcmasp_intf *intf,
+			     struct ethtool_rx_flow_spec *fs)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	struct ethtool_rx_flow_spec *cur;
+	size_t fs_size = 0;
+	int i;
+
+	for ( i = 0; i < ASP_RX_NET_FILTER_MAX; i++) {
+
+		if (priv->net_filters[i].reserved ||
+		    !priv->net_filters[i].claimed ||
+		    (priv->net_filters[i].port != intf->port)) {
+			continue;
+		}
+
+		cur = &priv->net_filters[i].fs;
+
+		if (cur->flow_type != fs->flow_type ||
+		    cur->ring_cookie != fs->ring_cookie)
+			continue;
+
+		switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+		case ETHER_FLOW:
+			fs_size = sizeof(struct ethhdr);
+			break;
+		case IP_USER_FLOW:
+			fs_size = sizeof(struct ethtool_usrip4_spec);
+			break;
+		case TCP_V6_FLOW:
+		case UDP_V6_FLOW:
+			fs_size = sizeof(struct ethtool_tcpip6_spec);
+			break;
+		case TCP_V4_FLOW:
+		case UDP_V4_FLOW:
+			fs_size = sizeof(struct ethtool_tcpip4_spec);
+			break;
+		default:
+			continue;
+		}
+
+		if (memcmp(&cur->h_u, &fs->h_u, fs_size) ||
+		    memcmp(&cur->m_u, &fs->m_u, fs_size))
+			continue;
+
+		if (cur->flow_type & FLOW_EXT) {
+			if ((cur->h_ext.vlan_etype != fs->h_ext.vlan_etype) ||
+			    (cur->m_ext.vlan_etype != fs->m_ext.vlan_etype) ||
+			    (cur->h_ext.vlan_tci != fs->h_ext.vlan_tci) ||
+			    (cur->m_ext.vlan_tci != fs->m_ext.vlan_tci) ||
+			    (cur->h_ext.data[0] != fs->h_ext.data[0]))
+				continue;
+		}
+		if (cur->flow_type & FLOW_MAC_EXT) {
+			if (memcmp(&cur->h_ext.h_dest,
+			    &fs->h_ext.h_dest, ETH_ALEN) ||
+			    memcmp(&cur->m_ext.h_dest,
+			    &fs->m_ext.h_dest, ETH_ALEN))
+				continue;
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/* If no network filter found, return open filter.
+ * If no more open filters return NULL
+ */
+struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
+						  int loc, bool wake_filter,
+						  bool init)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	struct bcmasp_net_filter *nfilter = NULL;
+	int i, open_index = -1;
+
+	/* Check whether we exceed the filter table capacity */
+	if (loc != RX_CLS_LOC_ANY && loc >= ASP_RX_NET_FILTER_MAX)
+		return ERR_PTR(-EINVAL);
+
+	/* If the filter location is busy (already claimed or reserved) and we
+	 * are initializing the filter (insertion), return a busy error code.
+	 */
+	if (loc != RX_CLS_LOC_ANY && init &&
+	    (priv->net_filters[loc].claimed || priv->net_filters[loc].reserved))
+		return ERR_PTR(-EBUSY);
+
+	/* We need two filters for wake-up, so we cannot use an odd filter */
+	if (wake_filter && loc != RX_CLS_LOC_ANY && (loc % 2))
+		return ERR_PTR(-EINVAL);
+
+	/* Initialize the loop index based on the desired location or from 0 */
+	i = loc == RX_CLS_LOC_ANY ? 0 : loc;
+
+	for ( ; i < ASP_RX_NET_FILTER_MAX; i++) {
+		if (priv->net_filters[i].reserved)
+			continue;
+
+		/* Found matching network filter */
+		if (!init &&
+		    priv->net_filters[i].claimed &&
+		    (priv->net_filters[i].hw_index == i) &&
+		    (priv->net_filters[i].port == intf->port))
+			return &priv->net_filters[i];
+
+		/* If we don't need a new filter or new filter already found */
+		if (!init || open_index >= 0)
+			continue;
+
+		/* Wake filter conslidates two filters to cover more bytes
+		 * Wake filter is open if...
+		 * 1. It is an even filter
+		 * 2. The current and next filter is not claimed
+		 */
+		if (wake_filter && !(i % 2) && !priv->net_filters[i].claimed &&
+		    !priv->net_filters[i + 1].claimed)
+			open_index = i;
+		else if (!priv->net_filters[i].claimed)
+			open_index = i;
+	}
+
+	if (open_index >= 0) {
+		nfilter = &priv->net_filters[open_index];
+		nfilter->claimed = true;
+		nfilter->port = intf->port;
+		nfilter->hw_index = open_index;
+	}
+
+	if (wake_filter && (open_index >= 0)) {
+		/* Claim next filter */
+		priv->net_filters[open_index + 1].claimed = true;
+		priv->net_filters[open_index + 1].wake_filter = true;
+		nfilter->wake_filter = true;
+	}
+
+	return nfilter ? nfilter : ERR_PTR(-EINVAL);
+}
+
+void bcmasp_netfilt_release(struct bcmasp_intf *intf,
+			    struct bcmasp_net_filter *nfilt)
+{
+	struct bcmasp_priv *priv = intf->parent;
+
+	if (nfilt->wake_filter) {
+		memset(&priv->net_filters[nfilt->hw_index + 1], 0,
+		       sizeof(struct bcmasp_net_filter));
+	}
+
+	memset(nfilt, 0, sizeof(struct bcmasp_net_filter));
+}
+
+static inline void bcmasp_addr_to_uint(unsigned char *addr, u32 *high, u32 *low)
+{
+	*high = (u32)(addr[0] << 8 | addr[1]);
+	*low = (u32)(addr[2] << 24 | addr[3] << 16 | addr[4] << 8 |
+		     addr[5]);
+}
+
+static void bcmasp_set_mda_filter(struct bcmasp_intf *intf,
+				  unsigned char *addr,
+				  unsigned char *mask,
+				  unsigned int i)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	u32 addr_h, addr_l, mask_h, mask_l;
+
+	/* Set local copy */
+	memcpy(priv->mda_filters[i].mask, mask, ETH_ALEN);
+	memcpy(priv->mda_filters[i].addr, addr, ETH_ALEN);
+
+	/* Write to HW */
+	bcmasp_addr_to_uint(priv->mda_filters[i].mask, &mask_h, &mask_l);
+	bcmasp_addr_to_uint(priv->mda_filters[i].addr, &addr_h, &addr_l);
+	rx_filter_core_wl(priv, addr_h, ASP_RX_FILTER_MDA_PAT_H(i));
+	rx_filter_core_wl(priv, addr_l, ASP_RX_FILTER_MDA_PAT_L(i));
+	rx_filter_core_wl(priv, mask_h, ASP_RX_FILTER_MDA_MSK_H(i));
+	rx_filter_core_wl(priv, mask_l, ASP_RX_FILTER_MDA_MSK_L(i));
+}
+
+static void bcmasp_en_mda_filter(struct bcmasp_intf *intf, bool en,
+				 unsigned int i)
+{
+	struct bcmasp_priv *priv = intf->parent;
+
+	if (priv->mda_filters[i].en == en)
+		return;
+
+	priv->mda_filters[i].en = en;
+	priv->mda_filters[i].port = intf->port;
+
+	rx_filter_core_wl(priv, ((intf->channel + 8) |
+			  (en << ASP_RX_FILTER_MDA_CFG_EN_SHIFT) |
+			  ASP_RX_FILTER_MDA_CFG_UMC_SEL(intf->port)),
+			  ASP_RX_FILTER_MDA_CFG(i));
+}
+
+/* There are 32 MDA filters shared between all ports, we reserve 4 filters per
+ * port for the following.
+ * - Promisc: Filter to allow all packets when promisc is enabled
+ * - All Multicast
+ * - Broadcast
+ * - Own address
+ *
+ * The reserved filters are identified as so.
+ * - Promisc: (Port * 4) + 0
+ * - All Multicast: (Port * 4) + 1
+ * - Broadcast: (Port * 4) + 2
+ * - Own address: (Port * 4) + 3
+ */
+enum asp_rx_filter_id {
+	ASP_RX_FILTER_PROMISC = 0,
+	ASP_RX_FILTER_ALLMULTI,
+	ASP_RX_FILTER_BROADCAST,
+	ASP_RX_FILTER_OWN_ADDR,
+	ASP_RX_FILTER_RES_COUNT,
+};
+
+#define ASP_RX_FILT_RES_COUNT(intf)	((intf)->parent->intf_count \
+					 * ASP_RX_FILTER_RES_COUNT)
+
+#define ASP_RX_FILT(intf, name)		(((intf)->port * \
+					  ASP_RX_FILTER_RES_COUNT) \
+					 + ASP_RX_FILTER_##name)
+
+void bcmasp_set_promisc(struct bcmasp_intf *intf, bool en)
+{
+	unsigned char promisc[ETH_ALEN];
+	unsigned int i = ASP_RX_FILT(intf, PROMISC);
+
+	eth_zero_addr(promisc);
+	/* Set mask to 00:00:00:00:00:00 to match all packets */
+	bcmasp_set_mda_filter(intf, promisc, promisc, i);
+	bcmasp_en_mda_filter(intf, en, i);
+}
+
+void bcmasp_set_allmulti(struct bcmasp_intf *intf, bool en)
+{
+	unsigned char allmulti[] = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+	unsigned int i = ASP_RX_FILT(intf, ALLMULTI);
+
+	/* Set mask to 01:00:00:00:00:00 to match all multicast */
+	bcmasp_set_mda_filter(intf, allmulti, allmulti, i);
+	bcmasp_en_mda_filter(intf, en, i);
+}
+
+void bcmasp_set_broad(struct bcmasp_intf *intf, bool en)
+{
+	unsigned char addr[ETH_ALEN];
+	unsigned int i = ASP_RX_FILT(intf, BROADCAST);
+
+	eth_broadcast_addr(addr);
+	bcmasp_set_mda_filter(intf, addr, addr, i);
+	bcmasp_en_mda_filter(intf, en, i);
+}
+
+void bcmasp_set_oaddr(struct bcmasp_intf *intf, unsigned char *addr, bool en)
+{
+	unsigned char mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	unsigned int i = ASP_RX_FILT(intf, OWN_ADDR);
+
+	bcmasp_set_mda_filter(intf, addr, mask, i);
+	bcmasp_en_mda_filter(intf, en, i);
+}
+
+void bcmasp_disable_all_filters(struct bcmasp_intf *intf)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	unsigned int i;
+
+	/* Disable all filters held by this port */
+	for (i = ASP_RX_FILT_RES_COUNT(intf); i < ASP_RX_FILTER_MAX; i++) {
+		if (priv->mda_filters[i].en &&
+		    (priv->mda_filters[i].port == intf->port))
+			bcmasp_en_mda_filter(intf, 0, i);
+	}
+}
+
+static inline void u64_to_mac(unsigned char *addr, u64 val)
+{
+	addr[0] = (u8)(val >> 40);
+	addr[1] = (u8)(val >> 32);
+	addr[2] = (u8)(val >> 24);
+	addr[3] = (u8)(val >> 16);
+	addr[4] = (u8)(val >> 8);
+	addr[5] = (u8)val;
+}
+
+#define mac_to_u64(a)		((((u64)a[0]) << 40) | \
+				(((u64)a[1]) << 32) | \
+				(((u64)a[2]) << 24) | \
+				(((u64)a[3]) << 16) | \
+				(((u64)a[4]) << 8) | \
+				((u64)a[5]))
+
+#define differ_one_bit(x, y)	is_power_of_2((x) ^ (y))
+
+static int bcmasp_combine_set_filter(struct bcmasp_intf *intf,
+				     unsigned char *addr, unsigned char *mask,
+				     int i)
+{
+	u64 addr1, addr2, mask1, mask2, mask3;
+	unsigned char naddr[ETH_ALEN], nmask[ETH_ALEN];
+	struct bcmasp_priv *priv = intf->parent;
+
+	/* Switch to u64 to help with the calculations */
+	addr1 = mac_to_u64(priv->mda_filters[i].addr);
+	mask1 = mac_to_u64(priv->mda_filters[i].mask);
+	addr2 = mac_to_u64(addr);
+	mask2 = mac_to_u64(mask);
+
+	/* We can only combine filters in two cases
+	 * 1. They share the same mask and are different by one bit
+	 * 2. One filter resides within the other
+	 */
+	if (mask1 == mask2) {
+		if (!differ_one_bit((addr1 & mask1), (addr2 & mask2)))
+			return -EINVAL;
+
+		/* Generate new mask */
+		mask3 = ((addr1 & mask1) ^ (addr2 & mask1)) ^ mask1;
+
+		/* Set new filter */
+		u64_to_mac(naddr, (addr1 & mask3));
+		u64_to_mac(nmask, mask3);
+		bcmasp_set_mda_filter(intf, naddr, nmask, i);
+		return 0;
+	}
+
+	/* Check if one filter resides within the other */
+	mask3 = mask1 & mask2;
+	if ((mask3 == mask1) && ((addr1 & mask1) == (addr2 & mask1))) {
+		/* Filter 2 resides within fitler 1, so everthing is good */
+		return 0;
+	} else if ((mask3 == mask2) && ((addr1 & mask2) == (addr2 & mask2))) {
+		/* Filter 1 resides within filter 2, so swap filters */
+		bcmasp_set_mda_filter(intf, addr, mask, i);
+		return 0;
+	}
+
+	/* Unable to combine */
+	return -EINVAL;
+}
+
+int bcmasp_set_en_mda_filter(struct bcmasp_intf *intf, unsigned char *addr,
+			     unsigned char *mask)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	int i, ret;
+
+	for (i = ASP_RX_FILT_RES_COUNT(intf); i < ASP_RX_FILTER_MAX; i++) {
+		/* If filter not enabled or belongs to another port skip */
+		if (!priv->mda_filters[i].en ||
+		    (priv->mda_filters[i].port != intf->port))
+			continue;
+
+		/* Attempt to combine filters */
+		ret = bcmasp_combine_set_filter(intf, addr, mask, i);
+		if (!ret) {
+			intf->mib.filters_combine_cnt++;
+			return 0;
+		}
+	}
+
+	/* Create new filter if possible */
+	for (i = ASP_RX_FILT_RES_COUNT(intf); i < ASP_RX_FILTER_MAX; i++) {
+		if (priv->mda_filters[i].en)
+			continue;
+
+		bcmasp_set_mda_filter(intf, addr, mask, i);
+		bcmasp_en_mda_filter(intf, 1, i);
+		return 0;
+	}
+
+	/* No room for new filter */
+	return -EINVAL;
+}
+
+static inline void bcmasp_core_init_filters(struct bcmasp_priv *priv)
+{
+	int i;
+
+	/* Disable all filters and reset software view since the HW
+	 * can lose context while in deep sleep suspend states
+	 */
+	for (i = 0; i < NUM_MDA_FILTERS; i++) {
+		rx_filter_core_wl(priv, 0x0, ASP_RX_FILTER_MDA_CFG(i));
+		priv->mda_filters[i].en = 0;
+	}
+
+	for (i = 0; i < NUM_NET_FILTERS; i++)
+		rx_filter_core_wl(priv, 0x0, ASP_RX_FILTER_NET_CFG(i));
+
+	/* Top level filter enable bit should be enabled at all times, set
+	 * GEN_WAKE_CLEAR to clear the network filter wake-up which would
+	 * otherwise be sticky
+	 */
+	rx_filter_core_wl(priv, (ASP_RX_FILTER_OPUT_EN |
+			  ASP_RX_FILTER_MDA_EN |
+			  ASP_RX_FILTER_GEN_WK_CLR |
+			  ASP_RX_FILTER_NT_FLT_EN),
+			  ASP_RX_FILTER_BLK_CTRL);
+}
+
+/* ASP core initalization */
+static inline void bcmasp_core_init(struct bcmasp_priv *priv)
+{
+	tx_analytics_core_wl(priv, 0x0, ASP_TX_ANALYTICS_CTRL);
+	rx_analytics_core_wl(priv, 0x4, ASP_RX_ANALYTICS_CTRL);
+
+	rx_ctrl_core_wl(priv, (ASP_RX_CTRL_S2F_DEFAULT_EN |
+		       (0xd << ASP_RX_CTRL_S2F_CHID_SHIFT)),
+			ASP_RX_CTRL_S2F);
+
+	rx_edpkt_core_wl(priv, (ASP_EDPKT_HDR_SZ_128 << ASP_EDPKT_HDR_SZ_SHIFT),
+			 ASP_EDPKT_HDR_CFG);
+	rx_edpkt_core_wl(priv,
+			 (ASP_EDPKT_ENDI_BT_SWP_WD << ASP_EDPKT_ENDI_DESC_SHIFT),
+			 ASP_EDPKT_ENDI);
+
+	rx_edpkt_core_wl(priv, 0x1b, ASP_EDPKT_BURST_BUF_PSCAL_TOUT);
+	rx_edpkt_core_wl(priv, 0x3e8, ASP_EDPKT_BURST_BUF_WRITE_TOUT);
+	rx_edpkt_core_wl(priv, 0x3e8, ASP_EDPKT_BURST_BUF_READ_TOUT);
+
+	rx_edpkt_core_wl(priv, ASP_EDPKT_ENABLE_EN, ASP_EDPKT_ENABLE);
+
+	/* Disable and clear both UniMAC's wake-up interrupts to avoid
+	 * sticky interrupts.
+	 */
+	_intr2_mask_set(priv, ASP_INTR2_UMC0_WAKE | ASP_INTR2_UMC1_WAKE);
+	intr2_core_wl(priv, ASP_INTR2_UMC0_WAKE | ASP_INTR2_UMC1_WAKE,
+		      ASP_INTR2_CLEAR);
+}
+
+static void bcmasp_core_clock_select(struct bcmasp_priv *priv, bool slow)
+{
+	u32 reg;
+
+	reg = ctrl_core_rl(priv, ASP_CTRL_CORE_CLOCK_SELECT);
+	if (slow)
+		reg &= ~ASP_CTRL_CORE_CLOCK_SELECT_MAIN;
+	else
+		reg |= ASP_CTRL_CORE_CLOCK_SELECT_MAIN;
+	ctrl_core_wl(priv, reg, ASP_CTRL_CORE_CLOCK_SELECT);
+}
+
+static void bcmasp_core_clock_set_ll(struct bcmasp_priv *priv, u32 clr, u32 set)
+{
+	u32 reg;
+
+	reg = ctrl_core_rl(priv, ASP_CTRL_CLOCK_CTRL);
+	reg &= ~clr;
+	reg |= set;
+	ctrl_core_wl(priv, reg, ASP_CTRL_CLOCK_CTRL);
+}
+
+static void bcmasp_core_clock_set(struct bcmasp_priv *priv, u32 clr, u32 set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->clk_lock, flags);
+	bcmasp_core_clock_set_ll(priv, clr, set);
+	spin_unlock_irqrestore(&priv->clk_lock, flags);
+}
+
+void bcmasp_core_clock_set_intf(struct bcmasp_intf *intf, bool en)
+{
+	u32 intf_mask = ASP_CTRL_CLOCK_CTRL_ASP_RGMII_DIS(intf->channel);
+	struct bcmasp_priv *priv = intf->parent;
+	unsigned long flags;
+	u32 reg;
+
+	/* When enabling an interface, if the RX or TX clocks were not enabled,
+	 * enable them. Conversely, while disabling an interface, if this is
+	 * the last one enabled, we can turn off the shared RX and TX clocks as
+	 * well. We control enable bits which is why we test for equality on
+	 * the RGMII clock bit mask.
+	 */
+	spin_lock_irqsave(&priv->clk_lock, flags);
+	if (en) {
+		intf_mask |= ASP_CTRL_CLOCK_CTRL_ASP_TX_DISABLE |
+			     ASP_CTRL_CLOCK_CTRL_ASP_RX_DISABLE;
+		bcmasp_core_clock_set_ll(priv, intf_mask, 0);
+	} else {
+		reg = ctrl_core_rl(priv, ASP_CTRL_CLOCK_CTRL) | intf_mask;
+		if ((reg & ASP_CTRL_CLOCK_CTRL_ASP_RGMII_MASK) ==
+		    ASP_CTRL_CLOCK_CTRL_ASP_RGMII_MASK)
+			intf_mask |= ASP_CTRL_CLOCK_CTRL_ASP_TX_DISABLE |
+				     ASP_CTRL_CLOCK_CTRL_ASP_RX_DISABLE;
+		bcmasp_core_clock_set_ll(priv, 0, intf_mask);
+	}
+	spin_unlock_irqrestore(&priv->clk_lock, flags);
+}
+
+static int bcmasp_probe(struct platform_device *pdev)
+{
+	struct bcmasp_priv *priv;
+	struct device_node *ports_node, *intf_node;
+	struct device *dev = &pdev->dev;
+	int ret, i, wol_irq, count = 0;
+	struct bcmasp_intf *intf;
+	struct resource *r;
+	u32 u32_reserved_filters_bitmask;
+	DECLARE_BITMAP(reserved_filters_bitmask, ASP_RX_NET_FILTER_MAX);
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->irq = platform_get_irq(pdev, 0);
+	if (priv->irq <= 0) {
+		dev_err(dev, "invalid interrupt\n");
+		return -EINVAL;
+	}
+
+	priv->clk = devm_clk_get(dev, "sw_asp");
+	if (IS_ERR(priv->clk)) {
+		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_warn(dev, "failed to request clock\n");
+		priv->clk = NULL;
+	}
+
+	/* Base from parent node */
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(priv->base)) {
+		dev_err(dev, "failed to iomap\n");
+		return PTR_ERR(priv->base);
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
+	if (ret)
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "unable to set DMA mask: %d\n", ret);
+		return ret;
+	}
+
+	dev_set_drvdata(&pdev->dev, priv);
+	priv->pdev = pdev;
+	spin_lock_init(&priv->mda_lock);
+	spin_lock_init(&priv->clk_lock);
+	mutex_init(&priv->net_lock);
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Enable all clocks to ensure successful probing */
+	bcmasp_core_clock_set(priv, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE, 0);
+
+	/* Switch to the main clock */
+	bcmasp_core_clock_select(priv, false);
+
+	_intr2_mask_set(priv, 0xffffffff);
+	intr2_core_wl(priv, 0xffffffff, ASP_INTR2_CLEAR);
+
+	ret = devm_request_irq(&pdev->dev, priv->irq, bcmasp_isr, 0,
+			       pdev->name, priv);
+	if (ret) {
+		dev_err(dev, "failed to request ASP interrupt: %d\n", ret);
+		return ret;
+	}
+
+	/* Register mdio child nodes */
+	of_platform_populate(dev->of_node, bcmasp_mdio_of_match, NULL,
+			     dev);
+
+	ret = of_property_read_u32(dev->of_node,
+				   "brcm,reserved-net-filters-mask",
+				   &u32_reserved_filters_bitmask);
+	if (ret)
+		u32_reserved_filters_bitmask = 0;
+
+	priv->net_filters_count_max = ASP_RX_NET_FILTER_MAX;
+	bitmap_zero(reserved_filters_bitmask, priv->net_filters_count_max);
+	bitmap_from_arr32(reserved_filters_bitmask,
+			  &u32_reserved_filters_bitmask,
+			  priv->net_filters_count_max);
+
+	/* Discover bitmask of reserved filters */
+	for_each_set_bit(i, reserved_filters_bitmask, ASP_RX_NET_FILTER_MAX) {
+		priv->net_filters[i].reserved = true;
+		priv->net_filters_count_max--;
+	}
+
+	/*
+	 * ASP specific initialization, Needs to be done irregardless of
+	 * of how many interfaces come up.
+	 */
+	bcmasp_core_init(priv);
+	bcmasp_core_init_filters(priv);
+
+	ports_node = of_find_node_by_name(dev->of_node, "ethernet-ports");
+	if (!ports_node) {
+		dev_warn(dev, "No ports found\n");
+		return 0;
+	}
+
+	priv->intf_count = of_get_available_child_count(ports_node);
+
+	priv->intfs = devm_kcalloc(dev, priv->intf_count,
+				   sizeof(struct bcmasp_intf *),
+				   GFP_KERNEL);
+	if (!priv->intfs)
+		return -ENOMEM;
+
+	/* Probe each interface (Initalization should continue even if
+	 * interfaces are unable to come up)
+	 */
+	i = 0;
+	for_each_available_child_of_node(ports_node, intf_node) {
+		wol_irq = platform_get_irq_optional(pdev, i + 1);
+		priv->intfs[i++] = bcmasp_interface_create(priv, intf_node,
+							   wol_irq);
+	}
+
+	/* Drop the clock reference count now and let ndo_open()/ndo_close()
+	 * manage it for us from now on.
+	 */
+	bcmasp_core_clock_set(priv, 0, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE);
+
+	clk_disable_unprepare(priv->clk);
+
+	/* Now do the registration of the network ports which will take care of
+	 * managing the clock properly.
+	 */
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		if (!intf)
+			continue;
+
+		ret = register_netdev(intf->ndev);
+		if (ret) {
+			netdev_err(intf->ndev,
+				   "failed to register net_device: %d\n", ret);
+			bcmasp_interface_destroy(intf, false);
+			continue;
+		}
+		count++;
+	}
+
+	dev_info(dev, "Initialized %d port(s)\n", count);
+
+	return 0;
+}
+
+static int bcmasp_remove(struct platform_device *pdev)
+{
+	struct bcmasp_priv *priv = dev_get_drvdata(&pdev->dev);
+	struct bcmasp_intf *intf;
+	int i;
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		if (!intf)
+			continue;
+
+		bcmasp_interface_destroy(intf, true);
+	}
+
+	return 0;
+}
+
+static void bcmasp_shutdown(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = bcmasp_remove(pdev);
+	if (ret)
+		dev_err(&pdev->dev, "failed to remove: %d\n", ret);
+}
+
+static int __maybe_unused bcmasp_suspend(struct device *d)
+{
+	struct bcmasp_priv *priv = dev_get_drvdata(d);
+	struct bcmasp_intf *intf;
+	unsigned int i;
+	bool wol_keep_rx_en = 0;
+	int ret = 0;
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		if (!intf)
+			continue;
+
+		ret = bcmasp_interface_suspend(intf, &wol_keep_rx_en);
+		if (ret)
+			break;
+	}
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Whether Wake-on-LAN is enabled or not, we can always disable
+	 * the shared TX clock
+	 */
+	bcmasp_core_clock_set(priv, 0, ASP_CTRL_CLOCK_CTRL_ASP_TX_DISABLE);
+
+	/* Switch to slow clock if we do not need rx */
+	if (!wol_keep_rx_en)
+		bcmasp_core_clock_select(priv, true);
+
+	clk_disable_unprepare(priv->clk);
+
+	return ret;
+}
+
+static int __maybe_unused bcmasp_resume(struct device *d)
+{
+	struct bcmasp_priv *priv = dev_get_drvdata(d);
+	struct bcmasp_intf *intf;
+	unsigned int i;
+	int ret = 0;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Switch to the main clock domain */
+	bcmasp_core_clock_select(priv, false);
+
+	/* Re-enable all clocks for re-initialization */
+	bcmasp_core_clock_set(priv, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE, 0);
+
+	bcmasp_core_init(priv);
+	bcmasp_core_init_filters(priv);
+
+	/* And disable them to let the network devices take care of them */
+	bcmasp_core_clock_set(priv, 0, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE);
+
+	clk_disable_unprepare(priv->clk);
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		if (!intf)
+			continue;
+
+		ret = bcmasp_interface_resume(intf);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(bcmasp_pm_ops,
+			 bcmasp_suspend, bcmasp_resume);
+
+static struct platform_driver bcmasp_driver = {
+	.probe = bcmasp_probe,
+	.remove = bcmasp_remove,
+	.shutdown = bcmasp_shutdown,
+	.driver = {
+		.name = "brcm,asp-v2",
+		.of_match_table = bcmasp_of_match,
+		.pm = &bcmasp_pm_ops,
+	},
+};
+module_platform_driver(bcmasp_driver);
+
+MODULE_AUTHOR("Broadcom");
+MODULE_DESCRIPTION("Broadcom ASP 2.0 Ethernet controller driver");
+MODULE_ALIAS("platform:brcm,asp-v2");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
new file mode 100644
index 0000000..e08b85e
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -0,0 +1,565 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __BCMASP_H
+#define __BCMASP_H
+
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
+#include <uapi/linux/ethtool.h>
+
+#define ASP_INTR2_OFFSET			0x1000
+#define  ASP_INTR2_STATUS			0x0
+#define  ASP_INTR2_SET				0x4
+#define  ASP_INTR2_CLEAR			0x8
+#define  ASP_INTR2_MASK_STATUS			0xc
+#define  ASP_INTR2_MASK_SET			0x10
+#define  ASP_INTR2_MASK_CLEAR			0x14
+
+#define ASP_INTR2_NUM_INTR			6
+#define ASP_INTR2_RX_ECH(intr)			BIT(intr)
+#define ASP_INTR2_TX_DESC(intr)			BIT((intr) + 14)
+#define ASP_INTR2_UMC0_WAKE			BIT(22)
+#define ASP_INTR2_UMC1_WAKE			BIT(28)
+
+
+#define ASP_TX_ANALYTICS_OFFSET			0x4c000
+#define  ASP_TX_ANALYTICS_CTRL			0x0
+
+#define ASP_RX_ANALYTICS_OFFSET			0x98000
+#define  ASP_RX_ANALYTICS_CTRL			0x0
+
+#define ASP_RX_CTRL_OFFSET			0x9f000
+#define ASP_RX_CTRL_UMAC_0_FRAME_COUNT		0x8
+#define ASP_RX_CTRL_UMAC_1_FRAME_COUNT		0xc
+#define ASP_RX_CTRL_FB_0_FRAME_COUNT		0x14
+#define ASP_RX_CTRL_FB_1_FRAME_COUNT		0x18
+#define ASP_RX_CTRL_FB_8_FRAME_COUNT		0x1c
+#define ASP_RX_CTRL_FB_OUT_FRAME_COUNT		0x20
+#define ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT	0x24
+#define ASP_RX_CTRL_FLUSH			0x28
+#define  ASP_CTRL_UMAC0_FLUSH_MASK		0x1001
+#define  ASP_CTRL_UMAC1_FLUSH_MASK		0x2002
+#define ASP_RX_CTRL_FB_RX_FIFO_DEPTH		0x30
+#define ASP_RX_CTRL_S2F				0x44
+#define  ASP_RX_CTRL_S2F_OPUT_EN		BIT(0)
+#define  ASP_RX_CTRL_S2F_VLN_EN			BIT(1)
+#define  ASP_RX_CTRL_S2F_SNP_EN			BIT(2)
+#define  ASP_RX_CTRL_S2F_BCM_TAG_EN		BIT(3)
+#define  ASP_RX_CTRL_S2F_CHID_SHIFT		8
+#define  ASP_RX_CTRL_S2F_DEFAULT_EN		\
+		(ASP_RX_CTRL_S2F_OPUT_EN |	\
+		ASP_RX_CTRL_S2F_VLN_EN |	\
+		ASP_RX_CTRL_S2F_SNP_EN)
+
+#define ASP_RX_FILTER_OFFSET			0x80000
+#define  ASP_RX_FILTER_BLK_CTRL			0x0
+#define   ASP_RX_FILTER_OPUT_EN			BIT(0)
+#define   ASP_RX_FILTER_MDA_EN			BIT(1)
+#define   ASP_RX_FILTER_LNR_MD			BIT(2)
+#define   ASP_RX_FILTER_GEN_WK_EN		BIT(3)
+#define   ASP_RX_FILTER_GEN_WK_CLR		BIT(4)
+#define   ASP_RX_FILTER_NT_FLT_EN		BIT(5)
+#define  ASP_RX_FILTER_MDA_CFG(sel)		(((sel) * 0x14) + 0x100)
+#define   ASP_RX_FILTER_MDA_CFG_EN_SHIFT	8
+#define   ASP_RX_FILTER_MDA_CFG_UMC_SEL(sel)	((sel) > 1 ? BIT(17) : BIT((sel) + 9))
+#define  ASP_RX_FILTER_MDA_PAT_H(sel)		(((sel) * 0x14) + 0x104)
+#define  ASP_RX_FILTER_MDA_PAT_L(sel)		(((sel) * 0x14) + 0x108)
+#define  ASP_RX_FILTER_MDA_MSK_H(sel)		(((sel) * 0x14) + 0x10c)
+#define  ASP_RX_FILTER_MDA_MSK_L(sel)		(((sel) * 0x14) + 0x110)
+#define  ASP_RX_FILTER_MDA_CFG(sel)		(((sel) * 0x14) + 0x100)
+#define  ASP_RX_FILTER_MDA_PAT_H(sel)		(((sel) * 0x14) + 0x104)
+#define  ASP_RX_FILTER_MDA_PAT_L(sel)		(((sel) * 0x14) + 0x108)
+#define  ASP_RX_FILTER_MDA_MSK_H(sel)		(((sel) * 0x14) + 0x10c)
+#define  ASP_RX_FILTER_MDA_MSK_L(sel)		(((sel) * 0x14) + 0x110)
+#define  ASP_RX_FILTER_NET_CFG(sel)		(((sel) * 0xa04) + 0x400)
+#define   ASP_RX_FILTER_NET_CFG_CH(sel)		((sel) << 0)
+#define   ASP_RX_FILTER_NET_CFG_EN		BIT(9)
+#define   ASP_RX_FILTER_NET_CFG_L2_EN		BIT(10)
+#define   ASP_RX_FILTER_NET_CFG_L3_EN		BIT(11)
+#define   ASP_RX_FILTER_NET_CFG_L4_EN		BIT(12)
+#define   ASP_RX_FILTER_NET_CFG_L3_FRM(sel)	((sel) << 13)
+#define   ASP_RX_FILTER_NET_CFG_L4_FRM(sel)	((sel) << 15)
+#define   ASP_RX_FILTER_NET_CFG_UMC(sel)	BIT((sel) + 19)
+#define   ASP_RX_FILTER_NET_CFG_DMA_EN		BIT(27)
+
+enum asp_rx_net_filter_block {
+	ASP_RX_FILTER_L2 = 0,
+	ASP_RX_FILTER_L3_0,
+	ASP_RX_FILTER_L3_1,
+	ASP_RX_FILTER_L4,
+	ASP_RX_FILTER_NET_BLOCK_MAX
+};
+
+#define  ASP_RX_FILTER_NET_OFFSET_MAX		32
+#define  ASP_RX_FILTER_NET_PAT(sel, block, off) \
+		(((sel) * 0xa04) + ((block) * 0x200) + (off) + 0x600)
+#define  ASP_RX_FILTER_NET_MASK(sel, block, off) \
+		(((sel) * 0xa04) + ((block) * 0x200) + (off) + 0x700)
+
+#define  ASP_RX_FILTER_NET_OFFSET(sel)		(((sel) * 0xa04) + 0xe00)
+#define   ASP_RX_FILTER_NET_OFFSET_L2(val)	((val) << 0)
+#define   ASP_RX_FILTER_NET_OFFSET_L3_0(val)	((val) << 8)
+#define   ASP_RX_FILTER_NET_OFFSET_L3_1(val)	((val) << 16)
+#define   ASP_RX_FILTER_NET_OFFSET_L4(val)	((val) << 24)
+
+#define NUM_MDA_FILTERS				32
+#define NUM_NET_FILTERS				32
+
+#define ASP_EDPKT_OFFSET			0x9c000
+#define  ASP_EDPKT_ENABLE			0x4
+#define   ASP_EDPKT_ENABLE_EN			BIT(0)
+#define  ASP_EDPKT_HDR_CFG			0xc
+#define   ASP_EDPKT_HDR_SZ_SHIFT		2
+#define   ASP_EDPKT_HDR_SZ_32			0
+#define   ASP_EDPKT_HDR_SZ_64			1
+#define   ASP_EDPKT_HDR_SZ_96			2
+#define   ASP_EDPKT_HDR_SZ_128			3
+#define ASP_EDPKT_BURST_BUF_PSCAL_TOUT		0x10
+#define ASP_EDPKT_BURST_BUF_WRITE_TOUT		0x14
+#define ASP_EDPKT_BURST_BUF_READ_TOUT		0x18
+#define ASP_EDPKT_RX_TS_COUNTER			0x38
+#define  ASP_EDPKT_ENDI				0x48
+#define   ASP_EDPKT_ENDI_DESC_SHIFT		8
+#define   ASP_EDPKT_ENDI_NO_BT_SWP		0
+#define   ASP_EDPKT_ENDI_BT_SWP_WD		1
+#define ASP_EDPKT_RX_PKT_CNT			0x138
+#define ASP_EDPKT_HDR_EXTR_CNT			0x13c
+#define ASP_EDPKT_HDR_OUT_CNT			0x140
+
+#define ASP_CTRL				0x101000
+#define  ASP_CTRL_ASP_SW_INIT			0x04
+#define   ASP_CTRL_ASP_SW_INIT_ACPUSS_CORE	BIT(0)
+#define   ASP_CTRL_ASP_SW_INIT_ASP_TX		BIT(1)
+#define   ASP_CTRL_ASP_SW_INIT_AS_RX		BIT(2)
+#define   ASP_CTRL_ASP_SW_INIT_ASP_RGMII_UMAC0	BIT(3)
+#define   ASP_CTRL_ASP_SW_INIT_ASP_RGMII_UMAC1	BIT(4)
+#define   ASP_CTRL_ASP_SW_INIT_ASP_XMEMIF	BIT(5)
+#define  ASP_CTRL_CLOCK_CTRL			0x04
+#define   ASP_CTRL_CLOCK_CTRL_ASP_TX_DISABLE	BIT(0)
+#define   ASP_CTRL_CLOCK_CTRL_ASP_RX_DISABLE	BIT(1)
+#define   ASP_CTRL_CLOCK_CTRL_ASP_RGMII_SHIFT	2
+#define   ASP_CTRL_CLOCK_CTRL_ASP_RGMII_MASK	(0x3 << ASP_CTRL_CLOCK_CTRL_ASP_RGMII_SHIFT)
+#define   ASP_CTRL_CLOCK_CTRL_ASP_RGMII_DIS(x)	BIT(ASP_CTRL_CLOCK_CTRL_ASP_RGMII_SHIFT + (x))
+#define   ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE	GENMASK(3, 0)
+#define  ASP_CTRL_CORE_CLOCK_SELECT		0x08
+#define   ASP_CTRL_CORE_CLOCK_SELECT_MAIN	BIT(0)
+
+struct bcmasp_tx_cb {
+	struct sk_buff		*skb;
+	unsigned int		bytes_sent;
+	bool			last;
+
+	DEFINE_DMA_UNMAP_ADDR(dma_addr);
+	DEFINE_DMA_UNMAP_LEN(dma_len);
+};
+
+struct bcmasp_res {
+	/* Per interface resources */
+	/* Port */
+	void __iomem		*umac;
+	void __iomem		*umac2fb;
+	void __iomem		*rgmii;
+
+	/* TX slowpath/configuration */
+	void __iomem		*tx_spb_ctrl;
+	void __iomem		*tx_spb_top;
+	void __iomem		*tx_epkt_core;
+	void __iomem		*tx_pause_ctrl;
+};
+
+#define DESC_ADDR(x)		((x) & GENMASK_ULL(39, 0))
+#define DESC_FLAGS(x)		((x) & GENMASK_ULL(63, 40))
+
+struct bcmasp_desc {
+	u64		buf;
+	#define DESC_CHKSUM	BIT_ULL(40)
+	#define DESC_CRC_ERR	BIT_ULL(41)
+	#define DESC_RX_SYM_ERR	BIT_ULL(42)
+	#define DESC_NO_OCT_ALN BIT_ULL(43)
+	#define DESC_PKT_TRUC	BIT_ULL(44)
+	/*  39:0 (TX/RX) bits 0-39 of buf addr
+	 *    40 (RX) checksum
+	 *    41 (RX) crc_error
+	 *    42 (RX) rx_symbol_error
+	 *    43 (RX) non_octet_aligned
+	 *    44 (RX) pkt_truncated
+	 *    45 Reserved
+	 * 56:46 (RX) mac_filter_id
+	 * 60:57 (RX) rx_port_num (0-unicmac0, 1-unimac1, 8-wifi)
+	 *    61 Reserved
+	 * 63:62 (TX) forward CRC, overwrite CRC
+	 */
+	u32		size;
+	u32		flags;
+	#define DESC_INT_EN     BIT(0)
+	#define DESC_SOF	BIT(1)
+	#define DESC_EOF	BIT(2)
+	#define DESC_EPKT_CMD   BIT(3)
+	#define DESC_SCRAM_ST   BIT(8)
+	#define DESC_SCRAM_END  BIT(9)
+	#define DESC_PCPP       BIT(10)
+	#define DESC_PPPP       BIT(11)
+	/*     0 (TX) tx_int_en
+	 *     1 (TX/RX) SOF
+	 *     2 (TX/RX) EOF
+	 *     3 (TX) epkt_command
+	 *   6:4 (TX) PA
+	 *     7 (TX) pause at desc end
+	 *     8 (TX) scram_start
+	 *     9 (TX) scram_end
+	 *    10 (TX) PCPP
+	 *    11 (TX) PPPP
+	 * 14:12 Reserved
+	 *    15 (TX) pid ch Valid
+	 * 19:16 (TX) data_pkt_type
+	 * 32:20 (TX) pid_channel (RX) nw_filter_id
+	 */
+};
+
+/* Rx/Tx common counter group */
+struct bcmasp_pkt_counters {
+	u32	cnt_64;		/* RO Received/Transmited 64 bytes packet */
+	u32	cnt_127;	/* RO Rx/Tx 127 bytes packet */
+	u32	cnt_255;	/* RO Rx/Tx 65-255 bytes packet */
+	u32	cnt_511;	/* RO Rx/Tx 256-511 bytes packet */
+	u32	cnt_1023;	/* RO Rx/Tx 512-1023 bytes packet */
+	u32	cnt_1518;	/* RO Rx/Tx 1024-1518 bytes packet */
+	u32	cnt_mgv;	/* RO Rx/Tx 1519-1522 good VLAN packet */
+	u32	cnt_2047;	/* RO Rx/Tx 1522-2047 bytes packet*/
+	u32	cnt_4095;	/* RO Rx/Tx 2048-4095 bytes packet*/
+	u32	cnt_9216;	/* RO Rx/Tx 4096-9216 bytes packet*/
+};
+
+/* RSV, Receive Status Vector */
+struct bcmasp_rx_counters {
+	struct  bcmasp_pkt_counters pkt_cnt;
+	u32	pkt;		/* RO (0x428) Received pkt count*/
+	u32	bytes;		/* RO Received byte count */
+	u32	mca;		/* RO # of Received multicast pkt */
+	u32	bca;		/* RO # of Receive broadcast pkt */
+	u32	fcs;		/* RO # of Received FCS error  */
+	u32	cf;		/* RO # of Received control frame pkt*/
+	u32	pf;		/* RO # of Received pause frame pkt */
+	u32	uo;		/* RO # of unknown op code pkt */
+	u32	aln;		/* RO # of alignment error count */
+	u32	flr;		/* RO # of frame length out of range count */
+	u32	cde;		/* RO # of code error pkt */
+	u32	fcr;		/* RO # of carrier sense error pkt */
+	u32	ovr;		/* RO # of oversize pkt*/
+	u32	jbr;		/* RO # of jabber count */
+	u32	mtue;		/* RO # of MTU error pkt*/
+	u32	pok;		/* RO # of Received good pkt */
+	u32	uc;		/* RO # of unicast pkt */
+	u32	ppp;		/* RO # of PPP pkt */
+	u32	rcrc;		/* RO (0x470),# of CRC match pkt */
+};
+
+/* TSV, Transmit Status Vector */
+struct bcmasp_tx_counters {
+	struct bcmasp_pkt_counters pkt_cnt;
+	u32	pkts;		/* RO (0x4a8) Transmited pkt */
+	u32	mca;		/* RO # of xmited multicast pkt */
+	u32	bca;		/* RO # of xmited broadcast pkt */
+	u32	pf;		/* RO # of xmited pause frame count */
+	u32	cf;		/* RO # of xmited control frame count */
+	u32	fcs;		/* RO # of xmited FCS error count */
+	u32	ovr;		/* RO # of xmited oversize pkt */
+	u32	drf;		/* RO # of xmited deferral pkt */
+	u32	edf;		/* RO # of xmited Excessive deferral pkt*/
+	u32	scl;		/* RO # of xmited single collision pkt */
+	u32	mcl;		/* RO # of xmited multiple collision pkt*/
+	u32	lcl;		/* RO # of xmited late collision pkt */
+	u32	ecl;		/* RO # of xmited excessive collision pkt*/
+	u32	frg;		/* RO # of xmited fragments pkt*/
+	u32	ncl;		/* RO # of xmited total collision count */
+	u32	jbr;		/* RO # of xmited jabber count*/
+	u32	bytes;		/* RO # of xmited byte count */
+	u32	pok;		/* RO # of xmited good pkt */
+	u32	uc;		/* RO (0x0x4f0)# of xmited unitcast pkt */
+};
+
+struct bcmasp_mib_counters {
+	struct bcmasp_rx_counters rx;
+	struct bcmasp_tx_counters tx;
+	u32	rx_runt_cnt;
+	u32	rx_runt_fcs;
+	u32	rx_runt_fcs_align;
+	u32	rx_runt_bytes;
+	u32	edpkt_ts;
+	u32	edpkt_rx_pkt_cnt;
+	u32	edpkt_hdr_ext_cnt;
+	u32	edpkt_hdr_out_cnt;
+	u32	umac_frm_cnt;
+	u32	fb_frm_cnt;
+	u32	fb_out_frm_cnt;
+	u32	fb_filt_out_frm_cnt;
+	u32	fb_rx_fifo_depth;
+	u32	alloc_rx_buff_failed;
+	u32	alloc_rx_skb_failed;
+	u32	rx_dma_failed;
+	u32	tx_dma_failed;
+	u32	mc_filters_full_cnt;
+	u32	uc_filters_full_cnt;
+	u32	filters_combine_cnt;
+	u32	promisc_filters_cnt;
+	u32	tx_realloc_offload_failed;
+	u32	tx_realloc_offload;
+};
+
+struct bcmasp_intf {
+	struct net_device	*ndev;
+	struct bcmasp_priv	*parent;
+
+	/* ASP Ch */
+	int			channel;
+	int			port;
+
+	struct napi_struct	tx_napi;
+	/* TX ring, starts on a new cacheline boundary */
+	void __iomem		*tx_spb_dma;
+	int			tx_spb_index;
+	int			tx_spb_clean_index;
+	struct bcmasp_desc	*tx_spb_cpu;
+	dma_addr_t		tx_spb_dma_addr;
+	dma_addr_t		tx_spb_dma_valid;
+	dma_addr_t		tx_spb_dma_read;
+	struct bcmasp_tx_cb	*tx_cbs;
+	spinlock_t		tx_lock;
+
+	/* RX ring, starts on a new cacheline boundary */
+	void __iomem		*rx_edpkt_cfg;
+	void __iomem		*rx_edpkt_dma;
+	int			rx_edpkt_index;
+	int			rx_buf_order;
+	struct bcmasp_desc	*rx_edpkt_cpu;
+	dma_addr_t		rx_edpkt_dma_addr;
+	dma_addr_t		rx_edpkt_dma_read;
+
+	/* RX buffer prefetcher ring*/
+	void			*rx_ring_cpu;
+	dma_addr_t		rx_ring_dma;
+	dma_addr_t		rx_ring_dma_valid;
+	struct napi_struct	rx_napi;
+
+	struct bcmasp_res	res;
+	unsigned int		crc_fwd;
+
+	/* PHY device */
+	struct device_node	*phy_dn;
+	struct device_node	*ndev_dn;
+	phy_interface_t		phy_interface;
+	bool			internal_phy;
+	int			old_pause;
+	int			old_link;
+	int			old_duplex;
+
+	u32			msg_enable;
+	/* MIB counters */
+	struct bcmasp_mib_counters mib;
+
+	/* Wake-on-LAN */
+	u32			wolopts;
+	u8			sopass[SOPASS_MAX];
+	int			wol_irq;
+	unsigned int		wol_irq_disabled:1;
+	unsigned int		wol_keep_rx_en:1;
+
+	struct ethtool_eee	eee;
+};
+
+#define __BCMASP_IO_MACRO(name, m)					\
+static inline u32 name##_rl(struct bcmasp_intf *intf, u32 off)		\
+{									\
+	u32 reg = readl_relaxed(intf->m + off);			\
+	return reg;							\
+}									\
+static inline void name##_wl(struct bcmasp_intf *intf, u32 val, u32 off)\
+{									\
+	writel_relaxed(val, intf->m + off);				\
+}
+
+#define BCMASP_IO_MACRO(name)		__BCMASP_IO_MACRO(name, res.name)
+#define BCMASP_FP_IO_MACRO(name)	__BCMASP_IO_MACRO(name, name)
+
+BCMASP_IO_MACRO(umac);
+BCMASP_IO_MACRO(umac2fb);
+BCMASP_IO_MACRO(rgmii);
+BCMASP_FP_IO_MACRO(tx_spb_dma);
+BCMASP_IO_MACRO(tx_spb_ctrl);
+BCMASP_IO_MACRO(tx_spb_top);
+BCMASP_IO_MACRO(tx_epkt_core);
+BCMASP_IO_MACRO(tx_pause_ctrl);
+BCMASP_FP_IO_MACRO(rx_edpkt_dma);
+BCMASP_FP_IO_MACRO(rx_edpkt_cfg);
+
+#define __BCMASP_FP_IO_MACRO_Q(name, m)					\
+static inline u64 name##_rq(struct bcmasp_intf *intf, u32 off)		\
+{									\
+	u64 reg = readq_relaxed(intf->m + off);				\
+	return reg;							\
+}									\
+static inline void name##_wq(struct bcmasp_intf *intf, u64 val, u32 off)\
+{									\
+	writeq_relaxed(val, intf->m + off);				\
+}
+
+#define BCMASP_FP_IO_MACRO_Q(name)	__BCMASP_FP_IO_MACRO_Q(name, name)
+
+BCMASP_FP_IO_MACRO_Q(tx_spb_dma);
+BCMASP_FP_IO_MACRO_Q(rx_edpkt_dma);
+BCMASP_FP_IO_MACRO_Q(rx_edpkt_cfg);
+
+#define ASP_RX_NET_FILTER_MAX		32
+#define ASP_MAX_FILTER_SIZE		128
+struct bcmasp_net_filter {
+	struct ethtool_rx_flow_spec	fs;
+
+	bool				reserved;
+	bool				claimed;
+	bool				wake_filter;
+
+	int				port;
+	unsigned int			hw_index;
+};
+
+#define ASP_RX_FILTER_MAX		32
+struct bcmasp_mda_filter {
+	/* Current owner of this filter */
+	int		port;
+	bool		en;
+	u8		addr[ETH_ALEN];
+	u8		mask[ETH_ALEN];
+};
+
+struct bcmasp_priv {
+	struct platform_device		*pdev;
+	struct clk			*clk;
+
+	int				irq;
+	u32				irq_mask;
+
+	void __iomem			*base;
+
+	unsigned int			intf_count;
+	struct bcmasp_intf		**intfs;
+
+	struct bcmasp_mda_filter	mda_filters[ASP_RX_FILTER_MAX];
+	unsigned int			filters_count;
+	/* MAC destination address filters lock */
+	spinlock_t			mda_lock;
+
+	/* Protects accesses to ASP_CTRL_CLOCK_CTRL */
+	spinlock_t			clk_lock;
+
+	struct bcmasp_net_filter	net_filters[ASP_RX_NET_FILTER_MAX];
+	/* Max amount of filters minus reserved filters */
+	unsigned int			net_filters_count_max;
+	struct mutex			net_lock;
+};
+
+#define PKT_OFFLOAD_NOP			(0 << 28)
+#define PKT_OFFLOAD_HDR_OP		(1 << 28)
+#define  PKT_OFFLOAD_HDR_WRBACK		BIT(19)
+#define  PKT_OFFLOAD_HDR_COUNT(x)	((x) << 16)
+#define  PKT_OFFLOAD_HDR_SIZE_1(x)	((x) << 4)
+#define  PKT_OFFLOAD_HDR_SIZE_2(x)	(x)
+#define  PKT_OFFLOAD_HDR2_SIZE_2(x)	((x) << 24)
+#define  PKT_OFFLOAD_HDR2_SIZE_3(x)	((x) << 12)
+#define  PKT_OFFLOAD_HDR2_SIZE_4(x)	(x)
+#define PKT_OFFLOAD_EPKT_OP		(2 << 28)
+#define  PKT_OFFLOAD_EPKT_WRBACK	BIT(23)
+#define  PKT_OFFLOAD_EPKT_IP(x)		((x) << 21)
+#define  PKT_OFFLOAD_EPKT_TP(x)		((x) << 19)
+#define  PKT_OFFLOAD_EPKT_LEN(x)	((x) << 16)
+#define  PKT_OFFLOAD_EPKT_CSUM_L3	BIT(15)
+#define  PKT_OFFLOAD_EPKT_CSUM_L2	BIT(14)
+#define  PKT_OFFLOAD_EPKT_ID(x)		((x) << 12)
+#define  PKT_OFFLOAD_EPKT_SEQ(x)	((x) << 10)
+#define  PKT_OFFLOAD_EPKT_TS(x)		((x) << 8)
+#define  PKT_OFFLOAD_EPKT_BLOC(x)	(x)
+#define PKT_OFFLOAD_END_OP		(7 << 28)
+
+struct bcmasp_pkt_offload {
+	u32		nop;
+	u32		header;
+	u32		header2;
+	u32		epkt;
+	u32		end;
+};
+
+#define BCMASP_CORE_IO_MACRO(name, offset)				\
+static inline u32 name##_core_rl(struct bcmasp_priv *priv,		\
+				 u32 off)				\
+{									\
+	u32 reg = readl_relaxed(priv->base + (offset) + off);		\
+	return reg;							\
+}									\
+static inline void name##_core_wl(struct bcmasp_priv *priv,		\
+				  u32 val, u32 off)			\
+{									\
+	writel_relaxed(val, priv->base + (offset) + off);		\
+}
+
+BCMASP_CORE_IO_MACRO(intr2, ASP_INTR2_OFFSET);
+BCMASP_CORE_IO_MACRO(tx_analytics, ASP_TX_ANALYTICS_OFFSET);
+BCMASP_CORE_IO_MACRO(rx_analytics, ASP_RX_ANALYTICS_OFFSET);
+BCMASP_CORE_IO_MACRO(rx_ctrl, ASP_RX_CTRL_OFFSET);
+BCMASP_CORE_IO_MACRO(rx_filter, ASP_RX_FILTER_OFFSET);
+BCMASP_CORE_IO_MACRO(rx_edpkt, ASP_EDPKT_OFFSET);
+BCMASP_CORE_IO_MACRO(ctrl, ASP_CTRL);
+
+struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
+					    struct device_node *ndev_dn,
+					    int wol_irq);
+
+void bcmasp_interface_destroy(struct bcmasp_intf *intf, bool unregister);
+
+void bcmasp_enable_tx_irq(struct bcmasp_intf *intf, int en);
+
+void bcmasp_enable_rx_irq(struct bcmasp_intf *intf, int en);
+
+void bcmasp_flush_rx_port(struct bcmasp_intf *intf);
+
+extern const struct ethtool_ops bcmasp_ethtool_ops;
+
+int bcmasp_interface_suspend(struct bcmasp_intf *intf, bool *wol_keep_rx_en);
+
+int bcmasp_interface_resume(struct bcmasp_intf *intf);
+
+void bcmasp_set_promisc(struct bcmasp_intf *intf, bool en);
+
+void bcmasp_set_allmulti(struct bcmasp_intf *intf, bool en);
+
+void bcmasp_set_broad(struct bcmasp_intf *intf, bool en);
+
+void bcmasp_set_oaddr(struct bcmasp_intf *intf, unsigned char *addr, bool en);
+
+int bcmasp_set_en_mda_filter(struct bcmasp_intf *intf, unsigned char *addr,
+			     unsigned char *mask);
+
+void bcmasp_disable_all_filters(struct bcmasp_intf *intf);
+
+void bcmasp_core_clock_set_intf(struct bcmasp_intf *intf, bool en);
+
+struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
+						  int loc, bool wake_filter,
+						  bool init);
+
+int bcmasp_netfilt_check_dup(struct bcmasp_intf *intf,
+			     struct ethtool_rx_flow_spec *fs);
+
+void bcmasp_netfilt_release(struct bcmasp_intf *intf,
+			    struct bcmasp_net_filter *nfilt);
+
+int bcmasp_netfilt_get_active(struct bcmasp_intf *intf);
+
+void bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
+				   u32 *rule_cnt);
+
+int bcmasp_netfilt_get_max(struct bcmasp_intf *intf);
+
+void bcmasp_netfilt_suspend(struct bcmasp_intf *intf);
+
+void bcmasp_eee_enable_set(struct bcmasp_intf *intf, bool enable);
+
+#endif
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
new file mode 100644
index 0000000..a63524c
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -0,0 +1,628 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt)				"bcmasp_ethtool: " fmt
+
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+
+#include "bcmasp.h"
+#include "bcmasp_intf_defs.h"
+
+/* private flags */
+static const char bcmasp_private_flags[][ETH_GSTRING_LEN] = {
+	"suspend-keep-rx",
+};
+
+#define BCMASP_PRIV_FLAGS_COUNT ARRAY_SIZE(bcmasp_private_flags)
+#define BCMASP_WOL_KEEP_RX_EN	BIT(0)
+
+/* standard ethtool support functions. */
+enum bcmasp_stat_type {
+	BCMASP_STAT_NETDEV = -1,
+	BCMASP_STAT_MIB_RX,
+	BCMASP_STAT_MIB_TX,
+	BCMASP_STAT_RUNT,
+	BCMASP_STAT_RX_EDPKT,
+	BCMASP_STAT_RX_CTRL,
+	BCMASP_STAT_SOFT,
+};
+
+struct bcmasp_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int stat_sizeof;
+	int stat_offset;
+	enum bcmasp_stat_type type;
+	/* register offset from base for misc counters */
+	u16 reg_offset;
+};
+
+#define STAT_NETDEV(m) { \
+	.stat_string = __stringify(m), \
+	.stat_sizeof = sizeof(((struct net_device_stats *)0)->m), \
+	.stat_offset = offsetof(struct net_device_stats, m), \
+	.type = BCMASP_STAT_NETDEV, \
+}
+
+#define STAT_BCMASP_MIB(str, m, _type) { \
+	.stat_string = str, \
+	.stat_sizeof = sizeof(((struct bcmasp_intf *)0)->m), \
+	.stat_offset = offsetof(struct bcmasp_intf, m), \
+	.type = _type, \
+}
+
+#define STAT_BCMASP_OFFSET(str, m, _type, offset) { \
+	.stat_string = str, \
+	.stat_sizeof = sizeof(((struct bcmasp_intf *)0)->m), \
+	.stat_offset = offsetof(struct bcmasp_intf, m), \
+	.type = _type, \
+	.reg_offset = offset, \
+}
+
+#define STAT_BCMASP_MIB_RX(str, m) \
+	STAT_BCMASP_MIB(str, m, BCMASP_STAT_MIB_RX)
+#define STAT_BCMASP_MIB_TX(str, m) \
+	STAT_BCMASP_MIB(str, m, BCMASP_STAT_MIB_TX)
+#define STAT_BCMASP_RUNT(str, m) \
+	STAT_BCMASP_MIB(str, m, BCMASP_STAT_RUNT)
+#define STAT_BCMASP_RX_EDPKT(str, m, offset) \
+	STAT_BCMASP_OFFSET(str, m, BCMASP_STAT_RX_EDPKT, offset)
+#define STAT_BCMASP_RX_CTRL(str, m, offset) \
+	STAT_BCMASP_OFFSET(str, m, BCMASP_STAT_RX_CTRL, offset)
+#define STAT_BCMASP_SOFT_MIB(m) \
+	STAT_BCMASP_MIB(__stringify(m), mib.m, BCMASP_STAT_SOFT)
+
+/* There is a 0x10 gap in hardware between the end of RX and beginning of TX
+ * stats and then between the end of TX stats and the beginning of the RX RUNT.
+ * The software structure already accounts for sizeof(u32) between members so
+ * need to add 0xc to offset correctly into the hardware register.
+ */
+#define BCMASP_STAT_OFFSET	0xc
+
+/* Hardware counters must be kept in sync because the order/offset
+ * is important here (order in structure declaration = order in hardware)
+ */
+static const struct bcmasp_stats bcmasp_gstrings_stats[] = {
+	/* general stats */
+	STAT_NETDEV(rx_packets),
+	STAT_NETDEV(tx_packets),
+	STAT_NETDEV(rx_bytes),
+	STAT_NETDEV(tx_bytes),
+	STAT_NETDEV(rx_errors),
+	STAT_NETDEV(tx_errors),
+	STAT_NETDEV(rx_dropped),
+	STAT_NETDEV(tx_dropped),
+	STAT_NETDEV(multicast),
+	/* UniMAC RSV counters */
+	STAT_BCMASP_MIB_RX("rx_64_octets", mib.rx.pkt_cnt.cnt_64),
+	STAT_BCMASP_MIB_RX("rx_65_127_oct", mib.rx.pkt_cnt.cnt_127),
+	STAT_BCMASP_MIB_RX("rx_128_255_oct", mib.rx.pkt_cnt.cnt_255),
+	STAT_BCMASP_MIB_RX("rx_256_511_oct", mib.rx.pkt_cnt.cnt_511),
+	STAT_BCMASP_MIB_RX("rx_512_1023_oct", mib.rx.pkt_cnt.cnt_1023),
+	STAT_BCMASP_MIB_RX("rx_1024_1518_oct", mib.rx.pkt_cnt.cnt_1518),
+	STAT_BCMASP_MIB_RX("rx_vlan_1519_1522_oct", mib.rx.pkt_cnt.cnt_mgv),
+	STAT_BCMASP_MIB_RX("rx_1522_2047_oct", mib.rx.pkt_cnt.cnt_2047),
+	STAT_BCMASP_MIB_RX("rx_2048_4095_oct", mib.rx.pkt_cnt.cnt_4095),
+	STAT_BCMASP_MIB_RX("rx_4096_9216_oct", mib.rx.pkt_cnt.cnt_9216),
+	STAT_BCMASP_MIB_RX("rx_pkts", mib.rx.pkt),
+	STAT_BCMASP_MIB_RX("rx_bytes", mib.rx.bytes),
+	STAT_BCMASP_MIB_RX("rx_multicast", mib.rx.mca),
+	STAT_BCMASP_MIB_RX("rx_broadcast", mib.rx.bca),
+	STAT_BCMASP_MIB_RX("rx_fcs", mib.rx.fcs),
+	STAT_BCMASP_MIB_RX("rx_control", mib.rx.cf),
+	STAT_BCMASP_MIB_RX("rx_pause", mib.rx.pf),
+	STAT_BCMASP_MIB_RX("rx_unknown", mib.rx.uo),
+	STAT_BCMASP_MIB_RX("rx_align", mib.rx.aln),
+	STAT_BCMASP_MIB_RX("rx_outrange", mib.rx.flr),
+	STAT_BCMASP_MIB_RX("rx_code", mib.rx.cde),
+	STAT_BCMASP_MIB_RX("rx_carrier", mib.rx.fcr),
+	STAT_BCMASP_MIB_RX("rx_oversize", mib.rx.ovr),
+	STAT_BCMASP_MIB_RX("rx_jabber", mib.rx.jbr),
+	STAT_BCMASP_MIB_RX("rx_mtu_err", mib.rx.mtue),
+	STAT_BCMASP_MIB_RX("rx_good_pkts", mib.rx.pok),
+	STAT_BCMASP_MIB_RX("rx_unicast", mib.rx.uc),
+	STAT_BCMASP_MIB_RX("rx_ppp", mib.rx.ppp),
+	STAT_BCMASP_MIB_RX("rx_crc", mib.rx.rcrc),
+	/* UniMAC TSV counters */
+	STAT_BCMASP_MIB_TX("tx_64_octets", mib.tx.pkt_cnt.cnt_64),
+	STAT_BCMASP_MIB_TX("tx_65_127_oct", mib.tx.pkt_cnt.cnt_127),
+	STAT_BCMASP_MIB_TX("tx_128_255_oct", mib.tx.pkt_cnt.cnt_255),
+	STAT_BCMASP_MIB_TX("tx_256_511_oct", mib.tx.pkt_cnt.cnt_511),
+	STAT_BCMASP_MIB_TX("tx_512_1023_oct", mib.tx.pkt_cnt.cnt_1023),
+	STAT_BCMASP_MIB_TX("tx_1024_1518_oct", mib.tx.pkt_cnt.cnt_1518),
+	STAT_BCMASP_MIB_TX("tx_vlan_1519_1522_oct", mib.tx.pkt_cnt.cnt_mgv),
+	STAT_BCMASP_MIB_TX("tx_1522_2047_oct", mib.tx.pkt_cnt.cnt_2047),
+	STAT_BCMASP_MIB_TX("tx_2048_4095_oct", mib.tx.pkt_cnt.cnt_4095),
+	STAT_BCMASP_MIB_TX("tx_4096_9216_oct", mib.tx.pkt_cnt.cnt_9216),
+	STAT_BCMASP_MIB_TX("tx_pkts", mib.tx.pkts),
+	STAT_BCMASP_MIB_TX("tx_multicast", mib.tx.mca),
+	STAT_BCMASP_MIB_TX("tx_broadcast", mib.tx.bca),
+	STAT_BCMASP_MIB_TX("tx_pause", mib.tx.pf),
+	STAT_BCMASP_MIB_TX("tx_control", mib.tx.cf),
+	STAT_BCMASP_MIB_TX("tx_fcs_err", mib.tx.fcs),
+	STAT_BCMASP_MIB_TX("tx_oversize", mib.tx.ovr),
+	STAT_BCMASP_MIB_TX("tx_defer", mib.tx.drf),
+	STAT_BCMASP_MIB_TX("tx_excess_defer", mib.tx.edf),
+	STAT_BCMASP_MIB_TX("tx_single_col", mib.tx.scl),
+	STAT_BCMASP_MIB_TX("tx_multi_col", mib.tx.mcl),
+	STAT_BCMASP_MIB_TX("tx_late_col", mib.tx.lcl),
+	STAT_BCMASP_MIB_TX("tx_excess_col", mib.tx.ecl),
+	STAT_BCMASP_MIB_TX("tx_frags", mib.tx.frg),
+	STAT_BCMASP_MIB_TX("tx_total_col", mib.tx.ncl),
+	STAT_BCMASP_MIB_TX("tx_jabber", mib.tx.jbr),
+	STAT_BCMASP_MIB_TX("tx_bytes", mib.tx.bytes),
+	STAT_BCMASP_MIB_TX("tx_good_pkts", mib.tx.pok),
+	STAT_BCMASP_MIB_TX("tx_unicast", mib.tx.uc),
+	/* UniMAC RUNT counters */
+	STAT_BCMASP_RUNT("rx_runt_pkts", mib.rx_runt_cnt),
+	STAT_BCMASP_RUNT("rx_runt_valid_fcs", mib.rx_runt_fcs),
+	STAT_BCMASP_RUNT("rx_runt_inval_fcs_align", mib.rx_runt_fcs_align),
+	STAT_BCMASP_RUNT("rx_runt_bytes", mib.rx_runt_bytes),
+	/* EDPKT counters */
+	STAT_BCMASP_RX_EDPKT("edpkt_ts", mib.edpkt_ts,
+			     ASP_EDPKT_RX_TS_COUNTER),
+	STAT_BCMASP_RX_EDPKT("edpkt_rx_pkt_cnt", mib.edpkt_rx_pkt_cnt,
+			     ASP_EDPKT_RX_PKT_CNT),
+	STAT_BCMASP_RX_EDPKT("edpkt_hdr_ext_cnt", mib.edpkt_hdr_ext_cnt,
+			     ASP_EDPKT_HDR_EXTR_CNT),
+	STAT_BCMASP_RX_EDPKT("edpkt_hdr_out_cnt", mib.edpkt_hdr_out_cnt,
+			     ASP_EDPKT_HDR_OUT_CNT),
+	/* ASP RX control */
+	STAT_BCMASP_RX_CTRL("umac_frm_cnt", mib.umac_frm_cnt,
+			    ASP_RX_CTRL_UMAC_0_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL("fb_frm_cnt", mib.fb_frm_cnt,
+			    ASP_RX_CTRL_FB_0_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL("fb_out_frm_cnt", mib.fb_out_frm_cnt,
+			    ASP_RX_CTRL_FB_OUT_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL("fb_filt_out_frm_cnt", mib.fb_filt_out_frm_cnt,
+			    ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL("fb_rx_fifo_depth", mib.fb_rx_fifo_depth,
+			    ASP_RX_CTRL_FB_RX_FIFO_DEPTH),
+	/* Software maintained statistics */
+	STAT_BCMASP_SOFT_MIB(alloc_rx_buff_failed),
+	STAT_BCMASP_SOFT_MIB(alloc_rx_skb_failed),
+	STAT_BCMASP_SOFT_MIB(rx_dma_failed),
+	STAT_BCMASP_SOFT_MIB(tx_dma_failed),
+	STAT_BCMASP_SOFT_MIB(mc_filters_full_cnt),
+	STAT_BCMASP_SOFT_MIB(uc_filters_full_cnt),
+	STAT_BCMASP_SOFT_MIB(filters_combine_cnt),
+	STAT_BCMASP_SOFT_MIB(promisc_filters_cnt),
+	STAT_BCMASP_SOFT_MIB(tx_realloc_offload_failed),
+	STAT_BCMASP_SOFT_MIB(tx_realloc_offload),
+
+};
+
+#define BCMASP_STATS_LEN	ARRAY_SIZE(bcmasp_gstrings_stats)
+
+static int bcmasp_get_sset_count(struct net_device *dev, int string_set)
+{
+	switch (string_set) {
+	case ETH_SS_STATS:
+		return BCMASP_STATS_LEN;
+	case ETH_SS_PRIV_FLAGS:
+		return BCMASP_PRIV_FLAGS_COUNT;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void bcmasp_get_strings(struct net_device *dev, u32 stringset,
+			       u8 *data)
+{
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < BCMASP_STATS_LEN; i++) {
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       bcmasp_gstrings_stats[i].stat_string,
+			       ETH_GSTRING_LEN);
+		}
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		for (i = 0; i < BCMASP_PRIV_FLAGS_COUNT; i++) {
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       bcmasp_private_flags[i],
+			       ETH_GSTRING_LEN);
+		}
+		break;
+	}
+}
+
+static void bcmasp_update_mib_counters(struct bcmasp_intf *priv)
+{
+	int i, j = 0;
+
+	for (i = 0; i < BCMASP_STATS_LEN; i++) {
+		const struct bcmasp_stats *s;
+		u16 offset = 0;
+		u32 val = 0;
+		char *p;
+
+		s = &bcmasp_gstrings_stats[i];
+		switch (s->type) {
+		case BCMASP_STAT_NETDEV:
+		case BCMASP_STAT_SOFT:
+			continue;
+		case BCMASP_STAT_RUNT:
+			offset += BCMASP_STAT_OFFSET;
+			fallthrough;
+		case BCMASP_STAT_MIB_TX:
+			offset += BCMASP_STAT_OFFSET;
+			fallthrough;
+		case BCMASP_STAT_MIB_RX:
+			val = umac_rl(priv, UMC_MIB_START + j + offset);
+			offset = 0;	/* Reset Offset */
+			break;
+		case BCMASP_STAT_RX_EDPKT:
+			val = rx_edpkt_core_rl(priv->parent, s->reg_offset);
+			break;
+		case BCMASP_STAT_RX_CTRL:
+			offset = s->reg_offset;
+			if (offset != ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT)
+				offset += sizeof(u32) * priv->port;
+			val = rx_ctrl_core_rl(priv->parent, offset);
+			break;
+		}
+
+		j += s->stat_sizeof;
+		p = (char *)priv + s->stat_offset;
+		*(u32 *)p = val;
+	}
+}
+
+static void bcmasp_get_ethtool_stats(struct net_device *dev,
+				     struct ethtool_stats *stats,
+				     u64 *data)
+{
+	struct bcmasp_intf *priv = netdev_priv(dev);
+	int i;
+
+	if (netif_running(dev))
+		bcmasp_update_mib_counters(priv);
+
+	dev->netdev_ops->ndo_get_stats(dev);
+
+	for (i = 0; i < BCMASP_STATS_LEN; i++) {
+		const struct bcmasp_stats *s;
+		char *p;
+
+		s = &bcmasp_gstrings_stats[i];
+		if (s->type == BCMASP_STAT_NETDEV)
+			p = (char *)&dev->stats;
+		else
+			p = (char *)priv;
+		p += s->stat_offset;
+		if (sizeof(unsigned long) != sizeof(u32) &&
+		    s->stat_sizeof == sizeof(unsigned long))
+			data[i] = *(unsigned long *)p;
+		else
+			data[i] = *(u32 *)p;
+	}
+}
+
+static void bcmasp_get_drvinfo(struct net_device *dev,
+			       struct ethtool_drvinfo *info)
+{
+	strlcpy(info->driver, "bcmasp", sizeof(info->driver));
+	strlcpy(info->version, "v2.0", sizeof(info->version));
+	strlcpy(info->bus_info, dev_name(dev->dev.parent),
+		sizeof(info->bus_info));
+	info->n_priv_flags = BCMASP_PRIV_FLAGS_COUNT;
+}
+
+static int bcmasp_get_link_ksettings(struct net_device *dev,
+				     struct ethtool_link_ksettings *cmd)
+{
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	phy_ethtool_ksettings_get(dev->phydev, cmd);
+
+	return 0;
+}
+
+static int bcmasp_set_link_ksettings(struct net_device *dev,
+				     const struct ethtool_link_ksettings *cmd)
+{
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	return phy_ethtool_ksettings_set(dev->phydev, cmd);
+}
+
+static u32 bcmasp_get_msglevel(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	return intf->msg_enable;
+}
+
+static void bcmasp_set_msglevel(struct net_device *dev, u32 level)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	intf->msg_enable = level;
+}
+
+static int bcmasp_nway_reset(struct net_device *dev)
+{
+	if (!dev->phydev)
+		return -ENODEV;
+
+	return genphy_restart_aneg(dev->phydev);
+}
+
+static void bcmasp_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
+	wol->wolopts = intf->wolopts;
+	memset(wol->sopass, 0, sizeof(wol->sopass));
+
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, intf->sopass, sizeof(intf->sopass));
+}
+
+static int bcmasp_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct device *kdev = &intf->parent->pdev->dev;
+
+	if (!device_can_wakeup(kdev))
+		return -EOPNOTSUPP;
+
+	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER))
+		return -EINVAL;
+
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(intf->sopass, wol->sopass, sizeof(wol->sopass));
+
+	if (wol->wolopts) {
+		device_set_wakeup_enable(kdev, 1);
+		if (intf->wol_irq_disabled)
+			enable_irq_wake(intf->wol_irq);
+		intf->wol_irq_disabled = false;
+	} else {
+		device_set_wakeup_enable(kdev, 0);
+		if (!intf->wol_irq_disabled)
+			disable_irq_wake(intf->wol_irq);
+		intf->wol_irq_disabled = true;
+	}
+
+	intf->wolopts = wol->wolopts;
+
+	return 0;
+}
+
+static int bcmasp_flow_insert(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct bcmasp_net_filter *nfilter;
+	u32 loc = cmd->fs.location;
+	bool wake = false;
+
+	if (cmd->fs.ring_cookie == RX_CLS_FLOW_WAKE)
+		wake = true;
+
+	/* Currently only supports WAKE filters */
+	if (!wake)
+		return -EOPNOTSUPP;
+
+	switch (cmd->fs.flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	case ETHER_FLOW:
+	case IP_USER_FLOW:
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if filter already exists */
+	if (bcmasp_netfilt_check_dup(intf, &cmd->fs))
+		return -EINVAL;
+
+	nfilter = bcmasp_netfilt_get_init(intf, loc, wake, true);
+	if (IS_ERR(nfilter))
+		return PTR_ERR(nfilter);
+
+	/* Return the location where we did insert the filter */
+	cmd->fs.location = nfilter->hw_index;
+	memcpy(&nfilter->fs, &cmd->fs, sizeof(struct ethtool_rx_flow_spec));
+
+	/* Since we only support wake filters, defer register programming till
+	 * suspend time.
+	 */
+	return 0;
+}
+
+static int bcmasp_flow_delete(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct bcmasp_net_filter *nfilter;
+
+	nfilter = bcmasp_netfilt_get_init(intf, cmd->fs.location, false, false);
+	if (IS_ERR(nfilter))
+		return PTR_ERR(nfilter);
+
+	bcmasp_netfilt_release(intf, nfilter);
+
+	return 0;
+}
+
+static int bcmasp_flow_get(struct bcmasp_intf *intf, struct ethtool_rxnfc *cmd)
+{
+	struct bcmasp_net_filter *nfilter;
+
+	nfilter = bcmasp_netfilt_get_init(intf, cmd->fs.location, false, false);
+	if (IS_ERR(nfilter))
+		return PTR_ERR(nfilter);
+
+	memcpy(&cmd->fs, &nfilter->fs, sizeof(nfilter->fs));
+
+	cmd->data = bcmasp_netfilt_get_max(intf);
+
+	return 0;
+}
+
+static int bcmasp_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	mutex_lock(&intf->parent->net_lock);
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		ret = bcmasp_flow_insert(dev, cmd);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		ret = bcmasp_flow_delete(dev, cmd);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&intf->parent->net_lock);
+
+	return ret;
+}
+
+static int bcmasp_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
+			    u32 *rule_locs)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	int err = 0;
+
+	mutex_lock(&intf->parent->net_lock);
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXCLSRLCNT:
+		cmd->rule_cnt = bcmasp_netfilt_get_active(intf);
+		/* We support specifying rule locations */
+		cmd->data |= RX_CLS_LOC_SPECIAL;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		err = bcmasp_flow_get(intf, cmd);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		bcmasp_netfilt_get_all_active(intf, rule_locs, &cmd->rule_cnt);
+		cmd->data = bcmasp_netfilt_get_max(intf);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	mutex_unlock(&intf->parent->net_lock);
+
+	return err;
+}
+
+static int bcmasp_set_priv_flags(struct net_device *dev, u32 flags)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	intf->wol_keep_rx_en = flags & BCMASP_WOL_KEEP_RX_EN ? 1 : 0;
+
+	return 0;
+}
+
+static u32 bcmasp_get_priv_flags(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	u32 ret_flags = 0;
+
+	ret_flags |= intf->wol_keep_rx_en ? BCMASP_WOL_KEEP_RX_EN : 0;
+
+	return ret_flags;
+}
+
+void bcmasp_eee_enable_set(struct bcmasp_intf *intf, bool enable)
+{
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_EEE_CTRL);
+	if (enable)
+		reg |= EEE_EN;
+	else
+		reg &= ~EEE_EN;
+	umac_wl(intf, reg, UMC_EEE_CTRL);
+
+	intf->eee.eee_enabled = enable;
+	intf->eee.eee_active = enable;
+}
+
+static int bcmasp_get_eee(struct net_device *dev, struct ethtool_eee *e)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct ethtool_eee *p = &intf->eee;
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	e->eee_enabled = p->eee_enabled;
+	e->eee_active = p->eee_active;
+	e->tx_lpi_enabled = p->tx_lpi_enabled;
+	e->tx_lpi_timer = umac_rl(intf, UMC_EEE_LPI_TIMER);
+
+	return phy_ethtool_get_eee(dev->phydev, e);
+}
+
+static int bcmasp_set_eee(struct net_device *dev, struct ethtool_eee *e)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct ethtool_eee *p = &intf->eee;
+	int ret;
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	if (!p->eee_enabled) {
+		bcmasp_eee_enable_set(intf, false);
+	} else {
+		ret = phy_init_eee(dev->phydev, 0);
+		if (ret) {
+			netif_err(intf, hw, dev,
+				  "EEE initialization failed: %d\n", ret);
+			return ret;
+		}
+
+		umac_wl(intf, e->tx_lpi_timer, UMC_EEE_LPI_TIMER);
+		intf->eee.eee_active = ret >= 0;
+		intf->eee.tx_lpi_enabled = e->tx_lpi_enabled;
+		bcmasp_eee_enable_set(intf, true);
+	}
+
+	return phy_ethtool_set_eee(dev->phydev, e);
+}
+
+const struct ethtool_ops bcmasp_ethtool_ops = {
+	.get_drvinfo		= bcmasp_get_drvinfo,
+	.get_wol		= bcmasp_get_wol,
+	.set_wol		= bcmasp_set_wol,
+	.get_link		= ethtool_op_get_link,
+	.get_strings		= bcmasp_get_strings,
+	.get_ethtool_stats	= bcmasp_get_ethtool_stats,
+	.get_sset_count		= bcmasp_get_sset_count,
+	.get_link_ksettings	= bcmasp_get_link_ksettings,
+	.set_link_ksettings	= bcmasp_set_link_ksettings,
+	.get_msglevel		= bcmasp_get_msglevel,
+	.set_msglevel		= bcmasp_set_msglevel,
+	.nway_reset		= bcmasp_nway_reset,
+	.get_rxnfc		= bcmasp_get_rxnfc,
+	.set_rxnfc		= bcmasp_set_rxnfc,
+	.get_priv_flags		= bcmasp_get_priv_flags,
+	.set_priv_flags		= bcmasp_set_priv_flags,
+	.set_eee		= bcmasp_set_eee,
+	.get_eee		= bcmasp_get_eee,
+};
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
new file mode 100644
index 0000000..f9c073a
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -0,0 +1,1414 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt)			"bcmasp_intf: " fmt
+
+#include <asm/byteorder.h>
+#include <linux/brcmphy.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+#include <linux/of_net.h>
+#include <linux/of_mdio.h>
+#include <linux/phy_fixed.h>
+#include <linux/ptp_classify.h>
+#include <linux/platform_device.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+#include "bcmasp.h"
+#include "bcmasp_intf_defs.h"
+
+static inline int incr_ring(int index, int ring_count)
+{
+	index++;
+	if (index == ring_count)
+		return 0;
+
+	return index;
+}
+
+/* Points to last byte of descriptor */
+static inline dma_addr_t incr_last_byte(dma_addr_t addr, dma_addr_t beg,
+					int ring_count)
+{
+	dma_addr_t end = beg + (ring_count * DESC_SIZE);
+
+	addr += DESC_SIZE;
+	if (addr > end)
+		return beg + DESC_SIZE - 1;
+
+	return addr;
+}
+
+/* Points to first byte of descriptor */
+static inline dma_addr_t incr_first_byte(dma_addr_t addr, dma_addr_t beg,
+					 int ring_count)
+{
+	dma_addr_t end = beg + (ring_count * DESC_SIZE);
+
+	addr += DESC_SIZE;
+	if (addr >= end)
+		return beg;
+
+	return addr;
+}
+
+static inline void bcmasp_enable_tx(struct bcmasp_intf *intf, int en)
+{
+	if (en) {
+		tx_spb_ctrl_wl(intf, TX_SPB_CTRL_ENABLE_EN, TX_SPB_CTRL_ENABLE);
+		tx_epkt_core_wl(intf, (TX_EPKT_C_CFG_MISC_EN |
+				TX_EPKT_C_CFG_MISC_PT |
+			       (intf->port << TX_EPKT_C_CFG_MISC_PS_SHIFT)),
+				TX_EPKT_C_CFG_MISC);
+	} else {
+		tx_spb_ctrl_wl(intf, 0x0, TX_SPB_CTRL_ENABLE);
+		tx_epkt_core_wl(intf, 0x0, TX_EPKT_C_CFG_MISC);
+	}
+}
+
+static inline void bcmasp_enable_rx(struct bcmasp_intf *intf, int en)
+{
+	if (en)
+		rx_edpkt_cfg_wl(intf, RX_EDPKT_CFG_ENABLE_EN,
+				RX_EDPKT_CFG_ENABLE);
+	else
+		rx_edpkt_cfg_wl(intf, 0x0, RX_EDPKT_CFG_ENABLE);
+}
+
+static void bcmasp_set_rx_mode(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct netdev_hw_addr *ha;
+	unsigned char mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	int ret;
+
+	spin_lock_bh(&intf->parent->mda_lock);
+
+	bcmasp_disable_all_filters(intf);
+
+	if (dev->flags & IFF_PROMISC)
+		goto set_promisc;
+
+	bcmasp_set_promisc(intf, 0);
+
+	bcmasp_set_broad(intf, 1);
+
+	bcmasp_set_oaddr(intf, dev->dev_addr, 1);
+
+	if (dev->flags & IFF_ALLMULTI) {
+		bcmasp_set_allmulti(intf, 1);
+	} else {
+		bcmasp_set_allmulti(intf, 0);
+
+		netdev_for_each_mc_addr(ha, dev) {
+			ret = bcmasp_set_en_mda_filter(intf, ha->addr, mask);
+			if (ret) {
+				intf->mib.mc_filters_full_cnt++;
+				goto set_promisc;
+			}
+		}
+	}
+
+	netdev_for_each_uc_addr(ha, dev) {
+		ret = bcmasp_set_en_mda_filter(intf, ha->addr, mask);
+		if (ret) {
+			intf->mib.uc_filters_full_cnt++;
+			goto set_promisc;
+		}
+	}
+
+	spin_unlock_bh(&intf->parent->mda_lock);
+	return;
+
+set_promisc:
+	bcmasp_set_promisc(intf, 1);
+	intf->mib.promisc_filters_cnt++;
+
+	/* disable all filters used by this port */
+	bcmasp_disable_all_filters(intf);
+
+	spin_unlock_bh(&intf->parent->mda_lock);
+}
+
+static void bcmasp_clean_txcb(struct bcmasp_intf *intf, int index)
+{
+	struct bcmasp_tx_cb *txcb = &intf->tx_cbs[index];
+
+	txcb->skb = NULL;
+	dma_unmap_addr_set(txcb, dma_addr, 0);
+	dma_unmap_len_set(txcb, dma_len, 0);
+	txcb->last = false;
+}
+
+static int tx_spb_ring_full(struct bcmasp_intf *intf, int cnt)
+{
+	int next_index, i;
+
+	/* Check if we have enough room for cnt descriptors */
+	for (i = 0; i < cnt; i++) {
+		next_index = incr_ring(intf->tx_spb_index, DESC_RING_COUNT);
+		if (next_index == intf->tx_spb_clean_index)
+			return 1;
+	}
+
+	return 0;
+}
+
+static struct sk_buff *bcmasp_csum_offload(struct net_device *dev,
+					   struct sk_buff *skb,
+					   bool *csum_hw)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	u32 header = 0, header2 = 0, epkt = 0;
+	struct bcmasp_pkt_offload *offload;
+	struct sk_buff *new_skb;
+	unsigned int header_cnt = 0;
+	u16 ip_ver;
+	u8 ip_proto;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return skb;
+
+	if (unlikely(skb_headroom(skb) < sizeof(*offload))) {
+		new_skb = skb_realloc_headroom(skb, sizeof(*offload));
+		if (!new_skb) {
+			intf->mib.tx_realloc_offload_failed++;
+			goto help;
+		}
+
+		dev_consume_skb_any(skb);
+		skb = new_skb;
+		intf->mib.tx_realloc_offload++;
+	}
+
+	ip_ver = htons(skb->protocol);
+	switch (ip_ver) {
+	case ETH_P_IP:
+		header |= PKT_OFFLOAD_HDR_SIZE_2((ip_hdrlen(skb) >> 8) & 0xf);
+		header2 |= PKT_OFFLOAD_HDR2_SIZE_2(ip_hdrlen(skb) & 0xff);
+		epkt |= PKT_OFFLOAD_EPKT_IP(0) | PKT_OFFLOAD_EPKT_CSUM_L2;
+		ip_proto = ip_hdr(skb)->protocol;
+		header_cnt += 2;
+		break;
+	case ETH_P_IPV6:
+		header |= PKT_OFFLOAD_HDR_SIZE_2((IP6_HLEN >> 8) & 0xf);
+		header2 |= PKT_OFFLOAD_HDR2_SIZE_2(IP6_HLEN & 0xff);
+		epkt |= PKT_OFFLOAD_EPKT_IP(1) | PKT_OFFLOAD_EPKT_CSUM_L2;
+		ip_proto = ipv6_hdr(skb)->nexthdr;
+		header_cnt += 2;
+		break;
+	default:
+		goto help;
+	}
+
+	switch (ip_proto) {
+	case IPPROTO_TCP:
+		header2 |= PKT_OFFLOAD_HDR2_SIZE_3(tcp_hdrlen(skb));
+		epkt |= PKT_OFFLOAD_EPKT_TP(0) | PKT_OFFLOAD_EPKT_CSUM_L3;
+		header_cnt++;
+		break;
+	case IPPROTO_UDP:
+		header2 |= PKT_OFFLOAD_HDR2_SIZE_3(UDP_HLEN);
+		epkt |= PKT_OFFLOAD_EPKT_TP(1) | PKT_OFFLOAD_EPKT_CSUM_L3;
+		header_cnt++;
+		break;
+	default:
+		goto help;
+	}
+
+	offload = (struct bcmasp_pkt_offload *)skb_push(skb, sizeof(*offload));
+
+	header |= PKT_OFFLOAD_HDR_OP | PKT_OFFLOAD_HDR_COUNT(header_cnt) |
+			  PKT_OFFLOAD_HDR_SIZE_1(ETH_HLEN);
+	epkt |= PKT_OFFLOAD_EPKT_OP;
+
+	offload->nop = htonl(PKT_OFFLOAD_NOP);
+	offload->header = htonl(header);
+	offload->header2 = htonl(header2);
+	offload->epkt = htonl(epkt);
+	offload->end = htonl(PKT_OFFLOAD_END_OP);
+	*csum_hw = true;
+
+	return skb;
+
+help:
+	skb_checksum_help(skb);
+
+	return skb;
+}
+
+static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct device *kdev = &intf->parent->pdev->dev;
+	struct bcmasp_desc *desc;
+	struct bcmasp_tx_cb *txcb;
+	dma_addr_t mapping, valid;
+	bool csum_hw = false;
+	unsigned int total_bytes, size;
+	int spb_index, nr_frags, ret, i, j;
+	skb_frag_t *frag;
+
+	spin_lock(&intf->tx_lock);
+
+	nr_frags = skb_shinfo(skb)->nr_frags;
+
+	if (tx_spb_ring_full(intf, nr_frags + 1)) {
+		netif_stop_queue(dev);
+		netdev_err(dev, "Tx Ring Full!\n");
+		ret = NETDEV_TX_BUSY;
+		goto out;
+	}
+
+	/* Save skb len before adding csum offload header */
+	total_bytes = skb->len;
+	skb = bcmasp_csum_offload(dev, skb, &csum_hw);
+	if (!skb) {
+		ret = NETDEV_TX_OK;
+		goto out;
+	}
+
+	spb_index = intf->tx_spb_index;
+	valid = intf->tx_spb_dma_valid;
+	for (i = 0; i <= nr_frags; i++) {
+		if (!i) {
+			size = skb_headlen(skb);
+			mapping = dma_map_single(kdev, skb->data, size,
+						 DMA_TO_DEVICE);
+		} else {
+			frag = &skb_shinfo(skb)->frags[i - 1];
+			size = skb_frag_size(frag);
+			mapping = skb_frag_dma_map(kdev, frag, 0, size,
+						   DMA_TO_DEVICE);
+		}
+
+		if (dma_mapping_error(kdev, mapping)) {
+			netif_err(intf, tx_err, dev,
+				  "DMA map failed at %p (len=%d\n",
+				  skb->data, skb->len);
+			ret = NETDEV_TX_OK;
+			intf->mib.tx_dma_failed++;
+			goto out_unmap_frags;
+		}
+
+		txcb = &intf->tx_cbs[spb_index];
+		desc = &intf->tx_spb_cpu[spb_index];
+		memset(desc, 0, sizeof(*desc));
+		txcb->skb = skb;
+		txcb->bytes_sent = total_bytes;
+		dma_unmap_addr_set(txcb, dma_addr, mapping);
+		dma_unmap_len_set(txcb, dma_len, size);
+		if (!i) {
+			desc->flags |= DESC_SOF;
+			if (csum_hw)
+				desc->flags |= DESC_EPKT_CMD;
+		}
+
+		if (i == nr_frags) {
+			desc->flags |= DESC_EOF;
+			txcb->last = true;
+		}
+
+		desc->buf = mapping;
+		desc->size = size;
+		desc->flags |= DESC_INT_EN;
+
+		netif_dbg(intf, tx_queued, dev,
+			  "%s dma_buf=%pad dma_len=0x%x flags=0x%x index=0x%x\n",
+			  __func__, &mapping, desc->size, desc->flags,
+			  spb_index);
+
+		spb_index = incr_ring(spb_index, DESC_RING_COUNT);
+		valid = incr_last_byte(valid, intf->tx_spb_dma_addr,
+				       DESC_RING_COUNT);
+	}
+
+	/* Ensure all descriptors have been written to DRAM for the
+	 * hardware to see up-to-date contents.
+	 */
+	wmb();
+
+	intf->tx_spb_index = spb_index;
+	intf->tx_spb_dma_valid = valid;
+	tx_spb_dma_wq(intf, intf->tx_spb_dma_valid, TX_SPB_DMA_VALID);
+
+	if (tx_spb_ring_full(intf, MAX_SKB_FRAGS + 1))
+		netif_stop_queue(dev);
+
+	spin_unlock(&intf->tx_lock);
+	return NETDEV_TX_OK;
+
+out_unmap_frags:
+	spb_index = intf->tx_spb_index;
+	for (j = 0; j < i; j++) {
+		bcmasp_clean_txcb(intf, spb_index);
+		spb_index = incr_ring(spb_index, DESC_RING_COUNT);
+	}
+out:
+	spin_unlock(&intf->tx_lock);
+	return ret;
+}
+
+static void bcmasp_netif_start(struct net_device *dev, bool start_phy)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	bcmasp_set_rx_mode(dev);
+	napi_enable(&intf->tx_napi);
+	napi_enable(&intf->rx_napi);
+
+	bcmasp_enable_rx_irq(intf, 1);
+	bcmasp_enable_tx_irq(intf, 1);
+
+	if (start_phy)
+		phy_start(dev->phydev);
+}
+
+static inline void umac_reset(struct bcmasp_intf *intf)
+{
+	umac_wl(intf, 0x0, UMC_CMD);
+	umac_wl(intf, UMC_CMD_SW_RESET, UMC_CMD);
+	udelay(10);
+	umac_wl(intf, 0x0, UMC_CMD);
+}
+
+static void umac_set_hw_addr(struct bcmasp_intf *intf,
+			     unsigned char *addr)
+{
+	u32 mac0 = (addr[0] << 24) | (addr[1] << 16) | (addr[2] << 8) |
+		    addr[3];
+	u32 mac1 = (addr[4] << 8) | addr[5];
+
+	umac_wl(intf, mac0, UMC_MAC0);
+	umac_wl(intf, mac1, UMC_MAC1);
+}
+
+static inline void umac_enable_set(struct bcmasp_intf *intf,
+				   u32 mask, unsigned int enable)
+{
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_CMD);
+	if (enable)
+		reg |= mask;
+	else
+		reg &= ~mask;
+	umac_wl(intf, reg, UMC_CMD);
+
+	/* UniMAC stops on a packet boundary, wait for a full-sized packet
+	 * to be processed (1 msec).
+	 */
+	if (enable == 0)
+		usleep_range(1000, 2000);
+}
+
+static inline void umac_init(struct bcmasp_intf *intf)
+{
+	umac_wl(intf, 0x800, UMC_FRM_LEN);
+	umac_wl(intf, 0xffff, UMC_PAUSE_CNTRL);
+	umac_wl(intf, 0x800, UMC_RX_MAX_PKT_SZ);
+}
+
+static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
+{
+	struct bcmasp_intf *intf =
+		container_of(napi, struct bcmasp_intf, tx_napi);
+	struct device *kdev = &intf->parent->pdev->dev;
+	struct bcmasp_tx_cb *txcb;
+	struct bcmasp_desc *desc;
+	unsigned long read, released = 0;
+	dma_addr_t mapping;
+
+	read = tx_spb_dma_rq(intf, TX_SPB_DMA_READ);
+	while (intf->tx_spb_dma_read != read) {
+		txcb = &intf->tx_cbs[intf->tx_spb_clean_index];
+		mapping = dma_unmap_addr(txcb, dma_addr);
+
+		dma_unmap_single(kdev, mapping,
+				 dma_unmap_len(txcb, dma_len),
+				 DMA_TO_DEVICE);
+
+		if (txcb->last) {
+			dev_consume_skb_any(txcb->skb);
+			intf->ndev->stats.tx_packets++;
+			intf->ndev->stats.tx_bytes += txcb->bytes_sent;
+		}
+
+		desc = &intf->tx_spb_cpu[intf->tx_spb_clean_index];
+
+		netif_dbg(intf, tx_done, intf->ndev,
+			  "%s dma_buf=%pad dma_len=0x%x flags=0x%x c_index=0x%x\n",
+			  __func__, &mapping, desc->size, desc->flags,
+			  intf->tx_spb_clean_index);
+
+		bcmasp_clean_txcb(intf, intf->tx_spb_clean_index);
+		released++;
+
+		intf->tx_spb_clean_index = incr_ring(intf->tx_spb_clean_index,
+						     DESC_RING_COUNT);
+		intf->tx_spb_dma_read = incr_first_byte(intf->tx_spb_dma_read,
+							intf->tx_spb_dma_addr,
+							DESC_RING_COUNT);
+	}
+
+	/* Ensure all descriptors have been written to DRAM for the hardware
+	 * to see updated contents.
+	 */
+	wmb();
+
+	napi_complete(&intf->tx_napi);
+
+	bcmasp_enable_tx_irq(intf, 1);
+
+	if (released)
+		netif_wake_queue(intf->ndev);
+
+	return 0;
+}
+
+static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
+{
+	struct bcmasp_intf *intf =
+		container_of(napi, struct bcmasp_intf, rx_napi);
+	struct device *kdev = &intf->parent->pdev->dev;
+	struct bcmasp_desc *desc;
+	struct sk_buff *skb;
+	unsigned long processed = 0;
+	dma_addr_t valid;
+	void *data;
+	u64 flags;
+	u32 len;
+
+	valid = rx_edpkt_dma_rq(intf, RX_EDPKT_DMA_VALID) + 1;
+	if (valid == intf->rx_edpkt_dma_addr + DESC_RING_SIZE)
+		valid = intf->rx_edpkt_dma_addr;
+
+	while ((processed < budget) && (valid != intf->rx_edpkt_dma_read)) {
+		desc = &intf->rx_edpkt_cpu[intf->rx_edpkt_index];
+
+		/* Ensure that descriptor has been fully written to DRAM by
+		 * hardware before reading by the CPU
+		 */
+		rmb();
+
+		/* Calculate virt addr by offsetting from physical addr */
+		data = intf->rx_ring_cpu +
+			(DESC_ADDR(desc->buf) - intf->rx_ring_dma);
+
+		flags = DESC_FLAGS(desc->buf);
+		if (unlikely(flags & (DESC_CRC_ERR | DESC_RX_SYM_ERR))) {
+			netif_err(intf, rx_status, intf->ndev, "flags=0x%llx\n",
+				  flags);
+
+			intf->ndev->stats.rx_errors++;
+			intf->ndev->stats.rx_dropped++;
+			goto next;
+		}
+
+		dma_sync_single_for_cpu(kdev, DESC_ADDR(desc->buf), desc->size,
+					DMA_FROM_DEVICE);
+
+		len = desc->size;
+
+		skb = __netdev_alloc_skb(intf->ndev, len,
+					 GFP_ATOMIC | __GFP_NOWARN);
+		if (!skb) {
+			intf->ndev->stats.rx_errors++;
+			intf->mib.alloc_rx_skb_failed++;
+			netif_warn(intf, rx_err, intf->ndev,
+				   "SKB alloc failed\n");
+			goto next;
+		}
+
+		skb_put(skb, len);
+		memcpy(skb->data, data, len);
+
+		skb_pull(skb, 2);
+		len -= 2;
+		if (likely(intf->crc_fwd)) {
+			skb_trim(skb, len - ETH_FCS_LEN);
+			len -= ETH_FCS_LEN;
+		}
+
+		if ((intf->ndev->features & NETIF_F_RXCSUM) &&
+		    (desc->buf & DESC_CHKSUM))
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		skb->protocol = eth_type_trans(skb, intf->ndev);
+
+		napi_gro_receive(napi, skb);
+
+		intf->ndev->stats.rx_packets++;
+		intf->ndev->stats.rx_bytes += len;
+
+next:
+		rx_edpkt_cfg_wq(intf, (DESC_ADDR(desc->buf) + desc->size),
+				RX_EDPKT_RING_BUFFER_READ);
+		processed++;
+		intf->rx_edpkt_dma_read =
+			incr_first_byte(intf->rx_edpkt_dma_read,
+					intf->rx_edpkt_dma_addr,
+					DESC_RING_COUNT);
+		intf->rx_edpkt_index = incr_ring(intf->rx_edpkt_index,
+						 DESC_RING_COUNT);
+	}
+
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_read, RX_EDPKT_DMA_READ);
+
+	if (processed < budget) {
+		napi_complete_done(&intf->rx_napi, processed);
+		bcmasp_enable_rx_irq(intf, 1);
+	}
+
+	return processed;
+}
+
+static void bcmasp_adj_link(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct phy_device *phydev = dev->phydev;
+	int changed = 0;
+	u32 cmd_bits = 0, reg;
+
+	if (intf->old_link != phydev->link) {
+		changed = 1;
+		intf->old_link = phydev->link;
+	}
+
+	if (intf->old_duplex != phydev->duplex) {
+		changed = 1;
+		intf->old_duplex = phydev->duplex;
+	}
+
+	switch (phydev->speed) {
+	case SPEED_2500:
+		cmd_bits = UMC_CMD_SPEED_2500;
+		break;
+	case SPEED_1000:
+		cmd_bits = UMC_CMD_SPEED_1000;
+		break;
+	case SPEED_100:
+		cmd_bits = UMC_CMD_SPEED_100;
+		break;
+	case SPEED_10:
+		cmd_bits = UMC_CMD_SPEED_10;
+		break;
+	default:
+		break;
+	}
+	cmd_bits <<= UMC_CMD_SPEED_SHIFT;
+
+	if (phydev->duplex == DUPLEX_HALF)
+		cmd_bits |= UMC_CMD_HD_EN;
+
+	if (intf->old_pause != phydev->pause) {
+		changed = 1;
+		intf->old_pause = phydev->pause;
+	}
+
+	if (!phydev->pause)
+		cmd_bits |= UMC_CMD_RX_PAUSE_IGNORE | UMC_CMD_TX_PAUSE_IGNORE;
+
+	if (!changed)
+		return;
+
+	if (phydev->link) {
+		reg = umac_rl(intf, UMC_CMD);
+		reg &= ~((UMC_CMD_SPEED_MASK << UMC_CMD_SPEED_SHIFT) |
+			UMC_CMD_HD_EN | UMC_CMD_RX_PAUSE_IGNORE |
+			UMC_CMD_TX_PAUSE_IGNORE);
+		reg |= cmd_bits;
+		umac_wl(intf, reg, UMC_CMD);
+
+		/* Enable RGMII pad */
+		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
+		reg |= RGMII_MODE_EN;
+		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
+
+		intf->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
+		bcmasp_eee_enable_set(intf, intf->eee.eee_active);
+	} else {
+		/* Disable RGMII pad */
+		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
+		reg &= ~RGMII_MODE_EN;
+		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
+	}
+
+	if (changed)
+		phy_print_status(phydev);
+}
+
+/* Restart and set the RX ring */
+static void bcmasp_rx_reset_ring(struct bcmasp_intf *intf)
+{
+	intf->rx_edpkt_dma_read = intf->rx_edpkt_dma_addr;
+	intf->rx_edpkt_index = 0;
+
+	/* Make sure channels are disabled */
+	rx_edpkt_cfg_wl(intf, 0x0, RX_EDPKT_CFG_ENABLE);
+
+	/* Rx SPB */
+	rx_edpkt_cfg_wq(intf, intf->rx_ring_dma, RX_EDPKT_RING_BUFFER_READ);
+	rx_edpkt_cfg_wq(intf, intf->rx_ring_dma, RX_EDPKT_RING_BUFFER_WRITE);
+	rx_edpkt_cfg_wq(intf, intf->rx_ring_dma, RX_EDPKT_RING_BUFFER_BASE);
+	rx_edpkt_cfg_wq(intf, intf->rx_ring_dma_valid,
+			RX_EDPKT_RING_BUFFER_END);
+	rx_edpkt_cfg_wq(intf, intf->rx_ring_dma_valid,
+			RX_EDPKT_RING_BUFFER_VALID);
+
+	/* EDPKT */
+	rx_edpkt_cfg_wl(intf, (RX_EDPKT_CFG_CFG0_RBUF_4K <<
+			RX_EDPKT_CFG_CFG0_DBUF_SHIFT) |
+		       (RX_EDPKT_CFG_CFG0_64_ALN <<
+			RX_EDPKT_CFG_CFG0_BALN_SHIFT) |
+		       (RX_EDPKT_CFG_CFG0_EFRM_STUF),
+			RX_EDPKT_CFG_CFG0);
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_addr, RX_EDPKT_DMA_WRITE);
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_addr, RX_EDPKT_DMA_READ);
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_addr, RX_EDPKT_DMA_BASE);
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_addr + (DESC_RING_SIZE - 1),
+			RX_EDPKT_DMA_END);
+	rx_edpkt_dma_wq(intf, intf->rx_edpkt_dma_addr + (DESC_RING_SIZE - 1),
+			RX_EDPKT_DMA_VALID);
+
+	/* RX Unimac Init */
+	umac2fb_wl(intf, UMAC2FB_CFG_DEFAULT_EN |
+		  ((intf->channel + 13) << UMAC2FB_CFG_CHID_SHIFT) |
+		  (0xc << UMAC2FB_CFG_OK_SEND_SHIFT), UMAC2FB_CFG);
+}
+
+static int bcmasp_init_rx(struct bcmasp_intf *intf)
+{
+	struct device *kdev = &intf->parent->pdev->dev;
+	struct net_device *ndev = intf->ndev;
+	void *p;
+	dma_addr_t dma;
+	struct page *buffer_pg;
+	int ret;
+
+	intf->rx_buf_order = get_order(RING_BUFFER_SIZE);
+	buffer_pg = alloc_pages(GFP_KERNEL, intf->rx_buf_order);
+
+	dma = dma_map_page(kdev, buffer_pg, 0, RING_BUFFER_SIZE,
+			   DMA_FROM_DEVICE);
+	if (dma_mapping_error(kdev, dma)) {
+		netdev_err(ndev, "Cannot allocate RX buffer\n");
+		__free_pages(buffer_pg, intf->rx_buf_order);
+		return -ENOMEM;
+	}
+	intf->rx_ring_cpu = page_to_virt(buffer_pg);
+	intf->rx_ring_dma = dma;
+	intf->rx_ring_dma_valid = intf->rx_ring_dma + RING_BUFFER_SIZE - 1;
+
+	p = dma_alloc_coherent(kdev, DESC_RING_SIZE, &intf->rx_edpkt_dma_addr,
+			       GFP_KERNEL);
+	if (!p) {
+		netdev_err(ndev, "Cannot allocate edpkt desc ring\n");
+		ret = -ENOMEM;
+		goto free_rx_ring;
+	}
+	intf->rx_edpkt_cpu = p;
+
+	netif_napi_add(intf->ndev, &intf->rx_napi, bcmasp_rx_poll,
+		       NAPI_POLL_WEIGHT);
+
+	bcmasp_rx_reset_ring(intf);
+
+	return 0;
+
+free_rx_ring:
+	dma_unmap_page(kdev, intf->rx_ring_dma, RING_BUFFER_SIZE,
+		       DMA_FROM_DEVICE);
+	__free_pages(virt_to_page(intf->rx_ring_cpu), intf->rx_buf_order);
+
+	return ret;
+}
+
+static void bcmasp_reclaim_free_all_rx(struct bcmasp_intf *intf)
+{
+	struct device *kdev = &intf->parent->pdev->dev;
+
+	dma_free_coherent(kdev, DESC_RING_SIZE, intf->rx_edpkt_cpu,
+			  intf->rx_edpkt_dma_addr);
+	dma_unmap_page(kdev, intf->rx_ring_dma, RING_BUFFER_SIZE,
+		       DMA_FROM_DEVICE);
+	__free_pages(virt_to_page(intf->rx_ring_cpu), intf->rx_buf_order);
+}
+
+static int bcmasp_init_tx(struct bcmasp_intf *intf)
+{
+	struct device *kdev = &intf->parent->pdev->dev;
+	void *p;
+	int ret;
+
+	p = dma_alloc_coherent(kdev, DESC_RING_SIZE, &intf->tx_spb_dma_addr,
+			       GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	intf->tx_spb_cpu = p;
+	intf->tx_spb_dma_valid = intf->tx_spb_dma_addr + DESC_RING_SIZE - 1;
+	intf->tx_spb_dma_read = intf->tx_spb_dma_addr;
+
+	intf->tx_cbs = kcalloc(DESC_RING_COUNT, sizeof(struct bcmasp_tx_cb),
+			       GFP_KERNEL);
+	if (!intf->tx_cbs) {
+		ret = -ENOMEM;
+		goto free_tx_spb;
+	}
+
+	spin_lock_init(&intf->tx_lock);
+	intf->tx_spb_index = 0;
+	intf->tx_spb_clean_index = 0;
+
+	netif_tx_napi_add(intf->ndev, &intf->tx_napi, bcmasp_tx_poll,
+			  NAPI_POLL_WEIGHT);
+
+	/* Make sure channels are disabled */
+	tx_spb_ctrl_wl(intf, 0x0, TX_SPB_CTRL_ENABLE);
+	tx_epkt_core_wl(intf, 0x0, TX_EPKT_C_CFG_MISC);
+
+	/* Tx SPB */
+	tx_spb_ctrl_wl(intf, ((intf->channel + 8) << TX_SPB_CTRL_XF_BID_SHIFT),
+		       TX_SPB_CTRL_XF_CTRL2);
+	tx_pause_ctrl_wl(intf, (1 << (intf->channel + 8)), TX_PAUSE_MAP_VECTOR);
+	tx_spb_top_wl(intf, 0x1e, TX_SPB_TOP_BLKOUT);
+	tx_spb_top_wl(intf, 0x0, TX_SPB_TOP_SPRE_BW_CTRL);
+
+	tx_spb_dma_wq(intf, intf->tx_spb_dma_addr, TX_SPB_DMA_READ);
+	tx_spb_dma_wq(intf, intf->tx_spb_dma_addr, TX_SPB_DMA_BASE);
+	tx_spb_dma_wq(intf, intf->tx_spb_dma_valid, TX_SPB_DMA_END);
+	tx_spb_dma_wq(intf, intf->tx_spb_dma_valid, TX_SPB_DMA_VALID);
+
+	return 0;
+
+free_tx_spb:
+	dma_free_coherent(kdev, DESC_RING_SIZE, intf->tx_spb_cpu,
+			  intf->tx_spb_dma_addr);
+
+	return ret;
+}
+
+static void bcmasp_reclaim_free_all_tx(struct bcmasp_intf *intf)
+{
+	struct device *kdev = &intf->parent->pdev->dev;
+
+	/* Free descriptors */
+	dma_free_coherent(kdev, DESC_RING_SIZE, intf->tx_spb_cpu,
+			  intf->tx_spb_dma_addr);
+
+	/* Free cbs */
+	kfree(intf->tx_cbs);
+}
+
+static void bcmasp_ephy_enable_set(struct bcmasp_intf *intf, bool enable)
+{
+	u32 mask = RGMII_EPHY_CFG_IDDQ_BIAS | RGMII_EPHY_CFG_EXT_PWRDOWN |
+		   RGMII_EPHY_CFG_IDDQ_GLOBAL;
+	u32 reg;
+
+	reg = rgmii_rl(intf, RGMII_EPHY_CNTRL);
+	if (enable) {
+		reg &= ~RGMII_EPHY_CK25_DIS;
+		rgmii_wl(intf, reg, RGMII_EPHY_CNTRL);
+		mdelay(1);
+
+		reg &= ~mask;
+		reg |= RGMII_EPHY_RESET;
+		rgmii_wl(intf, reg, RGMII_EPHY_CNTRL);
+		mdelay(1);
+
+		reg &= ~RGMII_EPHY_RESET;
+	} else {
+		reg |= mask | RGMII_EPHY_RESET;
+		rgmii_wl(intf, reg, RGMII_EPHY_CNTRL);
+		mdelay(1);
+		reg |= RGMII_EPHY_CK25_DIS;
+	}
+	rgmii_wl(intf, reg, RGMII_EPHY_CNTRL);
+	mdelay(1);
+}
+
+static void bcmasp_netif_deinit(struct net_device *dev, bool stop_phy,
+				bool stop_rx)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	u32 reg, timeout = 1000;
+
+	napi_disable(&intf->tx_napi);
+
+	bcmasp_enable_tx(intf, 0);
+
+	/* Flush any TX packets in the pipe */
+	tx_spb_dma_wl(intf, TX_SPB_DMA_FIFO_FLUSH, TX_SPB_DMA_FIFO_CTRL);
+	do {
+		reg = tx_spb_dma_rl(intf, TX_SPB_DMA_FIFO_STATUS);
+		if (!(reg & TX_SPB_DMA_FIFO_FLUSH))
+			break;
+		usleep_range(1000, 2000);
+	} while (timeout-- > 0);
+	tx_spb_dma_wl(intf, 0x0, TX_SPB_DMA_FIFO_CTRL);
+
+	umac_enable_set(intf, UMC_CMD_TX_EN, 0);
+
+	if (stop_phy)
+		phy_stop(dev->phydev);
+
+	/* Shut down RX */
+	umac_enable_set(intf, UMC_CMD_RX_EN, 0);
+
+	if (stop_phy || stop_rx) {
+		bcmasp_flush_rx_port(intf);
+		usleep_range(1000, 2000);
+		bcmasp_enable_rx(intf, 0);
+	}
+
+	napi_disable(&intf->rx_napi);
+
+	/* Disable interrupts */
+	bcmasp_enable_tx_irq(intf, 0);
+	bcmasp_enable_rx_irq(intf, 0);
+
+	netif_napi_del(&intf->tx_napi);
+	bcmasp_reclaim_free_all_tx(intf);
+
+	if (stop_phy || stop_rx) {
+		netif_napi_del(&intf->rx_napi);
+		bcmasp_reclaim_free_all_rx(intf);
+	}
+}
+
+static int bcmasp_stop(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	netif_dbg(intf, ifdown, dev, "%s\n", __func__);
+
+	/* Stop tx from updating HW */
+	netif_tx_disable(dev);
+
+	bcmasp_netif_deinit(dev, true, true);
+
+	phy_disconnect(dev->phydev);
+
+	/* Disable internal EPHY */
+	if (intf->internal_phy)
+		bcmasp_ephy_enable_set(intf, false);
+
+	/* Disable the interface clocks */
+	bcmasp_core_clock_set_intf(intf, false);
+
+	clk_disable_unprepare(intf->parent->clk);
+
+	return 0;
+}
+
+static void bcmasp_configure_port(struct bcmasp_intf *intf)
+{
+	u32 reg, id_mode_dis = 0;
+
+	reg = rgmii_rl(intf, RGMII_PORT_CNTRL);
+	reg &= ~RGMII_PORT_MODE_MASK;
+
+	switch (intf->phy_interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		/* RGMII_NO_ID: TXC transitions at the same time as TXD
+		 *		(requires PCB or receiver-side delay)
+		 * RGMII:	Add 2ns delay on TXC (90 degree shift)
+		 *
+		 * ID is implicitly disabled for 100Mbps (RG)MII operation.
+		 */
+		id_mode_dis = RGMII_ID_MODE_DIS;
+		fallthrough;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		reg |= RGMII_PORT_MODE_EXT_GPHY;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		reg |= RGMII_PORT_MODE_EXT_EPHY;
+		break;
+	default:
+		break;
+	}
+
+	if (intf->internal_phy)
+		reg |= RGMII_PORT_MODE_EPHY;
+
+	rgmii_wl(intf, reg, RGMII_PORT_CNTRL);
+
+	reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
+	reg &= ~RGMII_ID_MODE_DIS;
+	reg |= id_mode_dis;
+	rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
+}
+
+static int bcmasp_netif_init(struct net_device *dev, bool phy_connect,
+			     bool init_rx)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	phy_interface_t phy_iface = intf->phy_interface;
+	u32 phy_flags = PHY_BRCM_AUTO_PWRDWN_ENABLE |
+			PHY_BRCM_DIS_TXCRXC_NOENRGY |
+			PHY_BRCM_IDDQ_SUSPEND;
+	struct phy_device *phydev = NULL;
+	int ret;
+
+	/* Always enable interface clocks */
+	bcmasp_core_clock_set_intf(intf, true);
+
+	/* Enable internal PHY before any MAC activity */
+	if (intf->internal_phy)
+		bcmasp_ephy_enable_set(intf, true);
+
+	bcmasp_configure_port(intf);
+
+	/* This is an ugly quirk but we have not been correctly interpreting
+	 * the phy_interface values and we have done that across different
+	 * drivers, so at least we are consistent in our mistakes.
+	 *
+	 * When the Generic PHY driver is in use either the PHY has been
+	 * strapped or programmed correctly by the boot loader so we should
+	 * stick to our incorrect interpretation since we have validated it.
+	 *
+	 * Now when a dedicated PHY driver is in use, we need to reverse the
+	 * meaning of the phy_interface_mode values to something that the PHY
+	 * driver will interpret and act on such that we have two mistakes
+	 * canceling themselves so to speak. We only do this for the two
+	 * modes that GENET driver officially supports on Broadcom STB chips:
+	 * PHY_INTERFACE_MODE_RGMII and PHY_INTERFACE_MODE_RGMII_TXID. Other
+	 * modes are not *officially* supported with the boot loader and the
+	 * scripted environment generating Device Tree blobs for those
+	 * platforms.
+	 *
+	 * Note that internal PHY and fixed-link configurations are not
+	 * affected because they use different phy_interface_t values or the
+	 * Generic PHY driver.
+	 */
+	switch (phy_iface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		phy_iface = PHY_INTERFACE_MODE_RGMII_ID;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phy_iface = PHY_INTERFACE_MODE_RGMII_RXID;
+		break;
+	default:
+		break;
+	}
+
+	if (phy_connect) {
+		phydev = of_phy_connect(dev, intf->phy_dn, bcmasp_adj_link,
+					phy_flags, phy_iface);
+		if (!phydev) {
+			ret = -ENODEV;
+			netdev_err(dev, "could not attach to PHY\n");
+			goto err_phy_disable;
+		}
+	} else if (!intf->wolopts) {
+		ret = phy_resume(dev->phydev);
+		if (ret)
+			goto err_phy_disable;
+	}
+
+	umac_reset(intf);
+
+	umac_init(intf);
+
+	/* Disable the UniMAC RX/TX */
+	umac_enable_set(intf, (UMC_CMD_RX_EN | UMC_CMD_TX_EN), 0);
+
+	umac_set_hw_addr(intf, dev->dev_addr);
+
+	intf->old_duplex = -1;
+	intf->old_link = -1;
+	intf->old_pause = -1;
+
+	ret = bcmasp_init_tx(intf);
+	if (ret)
+		goto err_phy_disconnect;
+
+	/* Turn on asp */
+	bcmasp_enable_tx(intf, 1);
+
+	if (init_rx || phy_connect) {
+		ret = bcmasp_init_rx(intf);
+		if (ret)
+			goto err_reclaim_tx;
+		bcmasp_enable_rx(intf, 1);
+	} else if (!rx_edpkt_cfg_rl(intf, RX_EDPKT_CFG_ENABLE)) {
+		/* Do a partial init of RX if register state was reset */
+		bcmasp_rx_reset_ring(intf);
+		bcmasp_enable_rx(intf, 1);
+	}
+
+	/* Turn on UniMAC TX/RX */
+	umac_enable_set(intf, (UMC_CMD_RX_EN | UMC_CMD_TX_EN), 1);
+
+	intf->crc_fwd = !!(umac_rl(intf, UMC_CMD) & UMC_CMD_CRC_FWD);
+
+	bcmasp_netif_start(dev, phy_connect);
+
+	netif_start_queue(dev);
+
+	return 0;
+
+err_reclaim_tx:
+	bcmasp_reclaim_free_all_tx(intf);
+err_phy_disconnect:
+	if (phydev)
+		phy_disconnect(phydev);
+err_phy_disable:
+	if (intf->internal_phy)
+		bcmasp_ephy_enable_set(intf, false);
+	return ret;
+}
+
+static int bcmasp_open(struct net_device *dev)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	int ret;
+
+	netif_dbg(intf, ifup, dev, "%s\n", __func__);
+
+	ret = clk_prepare_enable(intf->parent->clk);
+	if (ret)
+		return ret;
+
+	ret = bcmasp_netif_init(dev, true, true);
+	if (ret)
+		clk_disable_unprepare(intf->parent->clk);
+
+	return ret;
+}
+
+static void bcmasp_reset_mib(struct bcmasp_intf *intf)
+{
+	umac_wl(intf, UMC_MIB_CNTRL_RX_CNT_RST |
+		UMC_MIB_CNTRL_RUNT_CNT_RST |
+		UMC_MIB_CNTRL_TX_CNT_RST, UMC_MIB_CNTRL);
+	usleep_range(1000, 2000);
+	umac_wl(intf, 0, UMC_MIB_CNTRL);
+}
+
+static void bcmasp_tx_timeout(struct net_device *dev, unsigned int txqueue)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	netif_dbg(intf, tx_err, dev, "transmit timeout!\n");
+
+	netif_trans_update(dev);
+	dev->stats.tx_errors++;
+
+	netif_wake_queue(dev);
+}
+
+static int bcmasp_get_phys_port_name(struct net_device *dev,
+				     char *name, size_t len)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	if (snprintf(name, len, "p%d", intf->port) >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct net_device_stats *bcmasp_get_stats(struct net_device *dev)
+{
+	return &dev->stats;
+}
+
+static int bcmasp_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(dev->phydev, rq, cmd);
+}
+
+static const struct net_device_ops bcmasp_netdev_ops = {
+	.ndo_open		= bcmasp_open,
+	.ndo_stop		= bcmasp_stop,
+	.ndo_start_xmit		= bcmasp_xmit,
+	.ndo_tx_timeout		= bcmasp_tx_timeout,
+	.ndo_set_rx_mode	= bcmasp_set_rx_mode,
+	.ndo_get_phys_port_name	= bcmasp_get_phys_port_name,
+	.ndo_get_stats		= bcmasp_get_stats,
+	.ndo_do_ioctl		= bcmasp_ioctl,
+};
+
+static inline void bcmasp_map_res(struct bcmasp_priv *priv,
+				  struct bcmasp_intf *intf)
+{
+	/* Per port */
+	intf->res.umac = priv->base + UMC_OFFSET(intf);
+	intf->res.umac2fb = priv->base + UMAC2FB_OFFSET(intf);
+	intf->res.rgmii = priv->base + RGMII_OFFSET(intf);
+
+	/* Per ch */
+	intf->tx_spb_dma = priv->base + TX_SPB_DMA_OFFSET(intf);
+	intf->res.tx_spb_ctrl = priv->base + TX_SPB_CTRL_OFFSET(intf);
+	/*
+	 * Stop gap solution. This should be removed when 72165a0 is
+	 * deprecated
+	 */
+	if (of_machine_is_compatible("brcm,bcm72165a0")) {
+		intf->res.tx_spb_top = priv->base +
+			TX_SPB_TOP_OFFSET_LEGACY(intf);
+	} else {
+		intf->res.tx_spb_top = priv->base +
+			TX_SPB_TOP_OFFSET(intf);
+	}
+	intf->res.tx_epkt_core = priv->base + TX_EPKT_C_OFFSET(intf);
+	intf->res.tx_pause_ctrl = priv->base + TX_PAUSE_CTRL_OFFSET(intf);
+
+	intf->rx_edpkt_dma = priv->base + RX_EDPKT_DMA_OFFSET(intf);
+	intf->rx_edpkt_cfg = priv->base + RX_EDPKT_CFG_OFFSET(intf);
+}
+
+static irqreturn_t bcmasp_wol_isr(int irq, void *dev_id)
+{
+	struct bcmasp_priv *priv = dev_id;
+
+	pm_wakeup_event(&priv->pdev->dev, 0);
+
+	return IRQ_HANDLED;
+}
+
+struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
+					    struct device_node *ndev_dn,
+					    int wol_irq)
+{
+	struct device *dev = &priv->pdev->dev;
+	struct bcmasp_intf *intf;
+	struct net_device *ndev;
+	int ch, port, ret;
+
+	if (of_property_read_u32(ndev_dn, "reg", &port)) {
+		dev_warn(dev, "%s: invalid ch number\n", ndev_dn->name);
+		goto err;
+	}
+
+	if (of_property_read_u32(ndev_dn, "channel", &ch)) {
+		dev_warn(dev, "%s: invalid ch number\n", ndev_dn->name);
+		goto err;
+	}
+
+	ndev = alloc_etherdev(sizeof(struct bcmasp_intf));
+	if (!dev) {
+		dev_warn(dev, "%s: unable to alloc ndev\n", ndev_dn->name);
+		goto err;
+	}
+	intf = netdev_priv(ndev);
+
+	/* Interrupt is optional */
+	if (wol_irq > 0) {
+		intf->wol_irq_disabled = true;
+		ret = request_irq(wol_irq, bcmasp_wol_isr, 0, ndev->name, priv);
+		if (ret) {
+			netdev_err(ndev, "unable to request WoL IRQ (%d)\n",
+				   ret);
+			goto err_free_netdev;
+		}
+		device_set_wakeup_capable(dev, 1);
+	}
+
+	intf->wol_irq = wol_irq;
+	intf->parent = priv;
+	intf->ndev = ndev;
+	intf->channel = ch;
+	intf->port = port;
+	intf->ndev_dn = ndev_dn;
+
+	ret = of_get_phy_mode(ndev_dn, &intf->phy_interface);
+	if (ret < 0) {
+		dev_err(dev, "invalid PHY mode property\n");
+		goto err_free_irq;
+	}
+
+	if (intf->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
+		intf->internal_phy = true;
+
+	intf->phy_dn = of_parse_phandle(ndev_dn, "phy-handle", 0);
+	if (!intf->phy_dn && of_phy_is_fixed_link(ndev_dn)) {
+		ret = of_phy_register_fixed_link(ndev_dn);
+		if (ret) {
+			dev_warn(dev, "%s: failed to register fixed PHY\n",
+				 ndev_dn->name);
+			goto err_free_irq;
+		}
+		intf->phy_dn = ndev_dn;
+	}
+
+	/* Map resource */
+	bcmasp_map_res(priv, intf);
+
+	if ((!phy_interface_mode_is_rgmii(intf->phy_interface) &&
+	    intf->phy_interface != PHY_INTERFACE_MODE_MII &&
+	    intf->phy_interface != PHY_INTERFACE_MODE_INTERNAL) ||
+	    (intf->port != 1 && intf->internal_phy)) {
+		netdev_err(intf->ndev, "invalid PHY mode: %s for port %d\n",
+			   phy_modes(intf->phy_interface), intf->port);
+		ret = -EINVAL;
+		goto err_free_irq;
+	}
+
+	bcmasp_reset_mib(intf);
+
+	ret = of_get_mac_address(ndev_dn, ndev->dev_addr);
+	if (ret) {
+		dev_warn(dev, "%s: using random Ethernet MAC\n",
+			 ndev_dn->name);
+		eth_hw_addr_random(ndev);
+	}
+
+	SET_NETDEV_DEV(ndev, dev);
+	ndev->netdev_ops = &bcmasp_netdev_ops;
+	ndev->ethtool_ops = &bcmasp_ethtool_ops;
+	intf->msg_enable = netif_msg_init(-1, NETIF_MSG_DRV |
+					  NETIF_MSG_PROBE |
+					  NETIF_MSG_LINK);
+	ndev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
+			  NETIF_F_RXCSUM;
+	ndev->hw_features |= ndev->features;
+	ndev->needed_headroom += sizeof(struct bcmasp_pkt_offload);
+
+	return intf;
+
+err_free_irq:
+	if (wol_irq > 0)
+		free_irq(wol_irq, priv);
+err_free_netdev:
+	free_netdev(ndev);
+err:
+	return NULL;
+}
+
+void bcmasp_interface_destroy(struct bcmasp_intf *intf, bool unregister)
+{
+	if (intf->wol_irq > 0)
+		free_irq(intf->wol_irq, intf->parent);
+	if (unregister)
+		unregister_netdev(intf->ndev);
+	if (of_phy_is_fixed_link(intf->ndev_dn))
+		of_phy_deregister_fixed_link(intf->ndev_dn);
+	free_netdev(intf->ndev);
+}
+
+static void bcmasp_suspend_to_wol(struct bcmasp_intf *intf)
+{
+	struct net_device *ndev = intf->ndev;
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_MPD_CTRL);
+	if (intf->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE))
+		reg |= UMC_MPD_CTRL_MPD_EN;
+	reg &= ~UMC_MPD_CTRL_PSW_EN;
+	if (intf->wolopts & WAKE_MAGICSECURE) {
+		/* Program the SecureOn password */
+		umac_wl(intf, get_unaligned_be16(&intf->sopass[0]),
+			UMC_PSW_MS);
+		umac_wl(intf, get_unaligned_be32(&intf->sopass[2]),
+			UMC_PSW_LS);
+		reg |= UMC_MPD_CTRL_PSW_EN;
+	}
+	umac_wl(intf, reg, UMC_MPD_CTRL);
+
+	if (intf->wolopts & WAKE_FILTER)
+		bcmasp_netfilt_suspend(intf);
+
+	/* UniMAC receive needs to be turned on */
+	umac_enable_set(intf, UMC_CMD_RX_EN, 1);
+
+	netif_dbg(intf, wol, ndev, "entered WOL mode\n");
+}
+
+static inline bool bcmasp_needs_rx_on(struct bcmasp_intf *intf)
+{
+	return intf->wol_keep_rx_en && intf->wolopts
+	       && device_may_wakeup(&intf->parent->pdev->dev);
+}
+
+int bcmasp_interface_suspend(struct bcmasp_intf *intf, bool *wol_keep_rx_en)
+{
+	struct device *kdev = &intf->parent->pdev->dev;
+	struct net_device *dev = intf->ndev;
+	bool keep_rx = bcmasp_needs_rx_on(intf);
+	int ret = 0;
+
+	if (!netif_running(dev))
+		return 0;
+
+	netif_device_detach(dev);
+
+	bcmasp_netif_deinit(dev, false, !keep_rx);
+
+	if (!intf->wolopts) {
+		ret = phy_suspend(dev->phydev);
+		if (ret)
+			goto out;
+
+		if (intf->internal_phy)
+			bcmasp_ephy_enable_set(intf, false);
+
+		/* If Wake-on-LAN is disabled, we can safely
+		 * disable the network interface clocks.
+		 */
+		bcmasp_core_clock_set_intf(intf, false);
+	}
+
+	if (device_may_wakeup(kdev) && intf->wolopts)
+		bcmasp_suspend_to_wol(intf);
+
+	clk_disable_unprepare(intf->parent->clk);
+
+	*wol_keep_rx_en |= keep_rx;
+
+	return ret;
+
+out:
+	bcmasp_netif_init(dev, false, keep_rx);
+	return ret;
+}
+
+static void bcmasp_resume_from_wol(struct bcmasp_intf *intf)
+{
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_MPD_CTRL);
+	reg &= ~UMC_MPD_CTRL_MPD_EN;
+	umac_wl(intf, reg, UMC_MPD_CTRL);
+}
+
+int bcmasp_interface_resume(struct bcmasp_intf *intf)
+{
+	struct net_device *dev = intf->ndev;
+	bool no_init_rx = bcmasp_needs_rx_on(intf);
+	int ret;
+
+	if (!netif_running(dev))
+		return 0;
+
+	ret = clk_prepare_enable(intf->parent->clk);
+	if (ret)
+		return ret;
+
+	ret = bcmasp_netif_init(dev, false, !no_init_rx);
+	if (ret)
+		goto out;
+
+	bcmasp_resume_from_wol(intf);
+
+	if (intf->eee.eee_enabled)
+		bcmasp_eee_enable_set(intf, true);
+
+	netif_device_attach(dev);
+
+	return 0;
+
+out:
+	clk_disable_unprepare(intf->parent->clk);
+	return ret;
+}
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
new file mode 100644
index 0000000..9d3d8ac
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __BCMASP_INTF_DEFS_H
+#define __BCMASP_INTF_DEFS_H
+
+#define UMC_OFFSET(intf)		\
+	((((intf)->port) * 0x800) + 0xc000)
+#define  UMC_CMD			0x008
+#define   UMC_CMD_TX_EN			BIT(0)
+#define   UMC_CMD_RX_EN			BIT(1)
+#define   UMC_CMD_SPEED_SHIFT		0x2
+#define    UMC_CMD_SPEED_MASK		0x3
+#define    UMC_CMD_SPEED_10		0x0
+#define    UMC_CMD_SPEED_100		0x1
+#define    UMC_CMD_SPEED_1000		0x2
+#define    UMC_CMD_SPEED_2500		0x3
+#define   UMC_CMD_PROMISC		BIT(4)
+#define   UMC_CMD_PAD_EN		BIT(5)
+#define   UMC_CMD_CRC_FWD		BIT(6)
+#define   UMC_CMD_PAUSE_FWD		BIT(7)
+#define   UMC_CMD_RX_PAUSE_IGNORE	BIT(8)
+#define   UMC_CMD_TX_ADDR_INS		BIT(9)
+#define   UMC_CMD_HD_EN			BIT(10)
+#define   UMC_CMD_SW_RESET		BIT(13)
+#define   UMC_CMD_LCL_LOOP_EN		BIT(15)
+#define   UMC_CMD_AUTO_CONFIG		BIT(22)
+#define   UMC_CMD_CNTL_FRM_EN		BIT(23)
+#define   UMC_CMD_NO_LEN_CHK		BIT(24)
+#define   UMC_CMD_RMT_LOOP_EN		BIT(25)
+#define   UMC_CMD_PRBL_EN		BIT(27)
+#define   UMC_CMD_TX_PAUSE_IGNORE	BIT(28)
+#define   UMC_CMD_TX_RX_EN		BIT(29)
+#define   UMC_CMD_RUNT_FILTER_DIS	BIT(30)
+#define  UMC_MAC0			0x0c
+#define  UMC_MAC1			0x10
+#define  UMC_FRM_LEN			0x14
+#define  UMC_EEE_CTRL			0x64
+#define   EN_LPI_RX_PAUSE		(1 << 0)
+#define   EN_LPI_TX_PFC			(1 << 1)
+#define   EN_LPI_TX_PAUSE		(1 << 2)
+#define   EEE_EN			(1 << 3)
+#define   RX_FIFO_CHECK			(1 << 4)
+#define   EEE_TX_CLK_DIS		(1 << 5)
+#define   DIS_EEE_10M			(1 << 6)
+#define   LP_IDLE_PREDICTION_MODE	(1 << 7)
+#define  UMC_EEE_LPI_TIMER		0x68
+#define  UMC_PAUSE_CNTRL		0x330
+#define  UMC_TX_FLUSH			0x334
+#define  UMC_MIB_START			0x400
+#define  UMC_MIB_CNTRL			0x580
+#define   UMC_MIB_CNTRL_RX_CNT_RST	BIT(0)
+#define   UMC_MIB_CNTRL_RUNT_CNT_RST	BIT(1)
+#define   UMC_MIB_CNTRL_TX_CNT_RST	BIT(2)
+#define  UMC_RX_MAX_PKT_SZ		0x608
+#define  UMC_MPD_CTRL			0x620
+#define   UMC_MPD_CTRL_MPD_EN		BIT(0)
+#define   UMC_MPD_CTRL_PSW_EN		BIT(27)
+#define  UMC_PSW_MS			0x624
+#define  UMC_PSW_LS			0x628
+
+#define UMAC2FB_OFFSET(intf)	\
+	((((intf)->port) * 0x4) + 0x9f03c)
+#define  UMAC2FB_CFG			0x0
+#define   UMAC2FB_CFG_OPUT_EN		BIT(0)
+#define   UMAC2FB_CFG_VLAN_EN		BIT(1)
+#define   UMAC2FB_CFG_SNAP_EN		BIT(2)
+#define   UMAC2FB_CFG_BCM_TG_EN		BIT(3)
+#define   UMAC2FB_CFG_IPUT_EN		BIT(4)
+#define   UMAC2FB_CFG_CHID_SHIFT	8
+#define   UMAC2FB_CFG_OK_SEND_SHIFT	24
+#define   UMAC2FB_CFG_DEFAULT_EN	\
+		(UMAC2FB_CFG_OPUT_EN | UMAC2FB_CFG_VLAN_EN \
+		| UMAC2FB_CFG_SNAP_EN | UMAC2FB_CFG_IPUT_EN)
+
+#define RGMII_OFFSET(intf)	\
+	((((intf)->port) * 0x100) + 0xd000)
+#define  RGMII_EPHY_CNTRL		0x00
+#define    RGMII_EPHY_CFG_IDDQ_BIAS	BIT(0)
+#define    RGMII_EPHY_CFG_EXT_PWRDOWN	BIT(1)
+#define    RGMII_EPHY_CFG_FORCE_DLL_EN	BIT(2)
+#define    RGMII_EPHY_CFG_IDDQ_GLOBAL	BIT(3)
+#define    RGMII_EPHY_CK25_DIS		BIT(4)
+#define    RGMII_EPHY_RESET		BIT(7)
+#define  RGMII_OOB_CNTRL		0x0c
+#define   RGMII_MODE_EN			BIT(6)
+#define   RGMII_ID_MODE_DIS		BIT(16)
+
+#define RGMII_PORT_CNTRL		0x60
+#define   RGMII_PORT_MODE_EPHY		0
+#define   RGMII_PORT_MODE_GPHY		1
+#define   RGMII_PORT_MODE_EXT_EPHY	2
+#define   RGMII_PORT_MODE_EXT_GPHY	3
+#define   RGMII_PORT_MODE_EXT_RVMII	4
+#define   RGMII_PORT_MODE_MASK		GENMASK(2, 0)
+
+#define TX_SPB_DMA_OFFSET(intf) \
+	((((intf)->channel) * 0x30) + 0x48180)
+#define  TX_SPB_DMA_READ		0x00
+#define  TX_SPB_DMA_BASE		0x08
+#define  TX_SPB_DMA_END			0x10
+#define  TX_SPB_DMA_VALID		0x18
+#define  TX_SPB_DMA_FIFO_CTRL		0x20
+#define   TX_SPB_DMA_FIFO_FLUSH		BIT(0)
+#define  TX_SPB_DMA_FIFO_STATUS		0x24
+
+#define TX_SPB_CTRL_OFFSET(intf) \
+	((((intf)->channel) * 0x68) + 0x49340)
+#define  TX_SPB_CTRL_ENABLE		0x0
+#define   TX_SPB_CTRL_ENABLE_EN		BIT(0)
+#define  TX_SPB_CTRL_XF_CTRL2		0x20
+#define   TX_SPB_CTRL_XF_BID_SHIFT	16
+
+#define TX_SPB_TOP_OFFSET_LEGACY(intf) \
+        ((((intf)->channel) * 0x14) + 0x4a0a0)
+#define TX_SPB_TOP_OFFSET(intf) \
+	((((intf)->channel) * 0x1c) + 0x4a0e0)
+#define TX_SPB_TOP_BLKOUT		0x0
+#define TX_SPB_TOP_SPRE_BW_CTRL		0x4
+
+#define TX_EPKT_C_OFFSET(intf) \
+	((((intf)->channel) * 0x120) + 0x40900)
+#define  TX_EPKT_C_CFG_MISC		0x0
+#define   TX_EPKT_C_CFG_MISC_EN		BIT(0)
+#define   TX_EPKT_C_CFG_MISC_PT		BIT(1)
+#define   TX_EPKT_C_CFG_MISC_PS_SHIFT	14
+
+#define TX_PAUSE_CTRL_OFFSET(intf) \
+	((((intf)->channel * 0xc) + 0x49a20))
+#define  TX_PAUSE_MAP_VECTOR		0x8
+
+#define RX_EDPKT_DMA_OFFSET(intf) \
+	((((intf)->channel) * 0x38) + 0x9ca00)
+#define  RX_EDPKT_DMA_WRITE		0x00
+#define  RX_EDPKT_DMA_READ		0x08
+#define  RX_EDPKT_DMA_BASE		0x10
+#define  RX_EDPKT_DMA_END		0x18
+#define  RX_EDPKT_DMA_VALID		0x20
+#define  RX_EDPKT_DMA_FULLNESS		0x28
+#define  RX_EDPKT_DMA_MIN_THRES		0x2c
+#define  RX_EDPKT_DMA_CH_XONOFF		0x30
+
+#define RX_EDPKT_CFG_OFFSET(intf) \
+	((((intf)->channel) * 0x70) + 0x9c600)
+#define  RX_EDPKT_CFG_CFG0		0x0
+#define   RX_EDPKT_CFG_CFG0_DBUF_SHIFT	9
+#define    RX_EDPKT_CFG_CFG0_RBUF	0x0
+#define    RX_EDPKT_CFG_CFG0_RBUF_4K	0x1
+#define    RX_EDPKT_CFG_CFG0_BUF_4K	0x2
+/* EFRM STUFF, 0 = no byte stuff, 1 = two byte stuff */
+#define   RX_EDPKT_CFG_CFG0_EFRM_STUF	BIT(11)
+#define   RX_EDPKT_CFG_CFG0_BALN_SHIFT	12
+#define    RX_EDPKT_CFG_CFG0_NO_ALN	0
+#define    RX_EDPKT_CFG_CFG0_4_ALN	2
+#define    RX_EDPKT_CFG_CFG0_64_ALN	6
+#define  RX_EDPKT_RING_BUFFER_WRITE	0x38
+#define  RX_EDPKT_RING_BUFFER_READ	0x40
+#define  RX_EDPKT_RING_BUFFER_BASE	0x48
+#define  RX_EDPKT_RING_BUFFER_END	0x50
+#define  RX_EDPKT_RING_BUFFER_VALID	0x58
+#define  RX_EDPKT_CFG_ENABLE		0x6c
+#define   RX_EDPKT_CFG_ENABLE_EN	BIT(0)
+
+#define RX_SPB_DMA_OFFSET(intf) \
+	((((intf)->channel) * 0x30) + 0xa0000)
+#define  RX_SPB_DMA_READ		0x00
+#define  RX_SPB_DMA_BASE		0x08
+#define  RX_SPB_DMA_END			0x10
+#define  RX_SPB_DMA_VALID		0x18
+#define  RX_SPB_DMA_FIFO_CTRL		0x20
+#define  RX_SPB_DMA_FIFO_STATUS		0x24
+
+#define RX_SPB_DPCTRL_OFFSET(intf) \
+	((((intf)->channel) * 0x20) + 0xa3000)
+#define  RX_SPB_DPCTRL_WAKE		0x0
+#define   RX_SPB_DPCTRL_WAKE_WK		BIT(0)
+#define  RX_SPB_DPCTRL_FIFO_CTRL	0x8
+#define  RX_SPB_DPCTRL_FIFO_STATUS	0xc
+#define  RX_SPB_DPCTRL_ENABLE		0x14
+#define   RX_SPB_DPCTRL_ENABLE_EN	BIT(0)
+
+#define NUM_4K_BUFFERS			32
+#define RING_BUFFER_SIZE		(PAGE_SIZE * NUM_4K_BUFFERS)
+
+#define DESC_RING_COUNT			(64 * NUM_4K_BUFFERS)
+#define DESC_SIZE			16
+#define DESC_RING_SIZE			(DESC_RING_COUNT * DESC_SIZE)
+
+#endif
-- 
2.7.4

