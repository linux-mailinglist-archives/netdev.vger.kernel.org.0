Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25367B961E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391425AbfITRAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:00:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38247 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391591AbfITRAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 13:00:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so7479709wrx.5;
        Fri, 20 Sep 2019 10:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AOBfqbVXzAlxSsTo7twuMhvYkmI6Dik7sGdBy1OQnRw=;
        b=gJiY4NmdHBtIvaxk6Ijre/8ZmGvdlA8ITr4X26dAXp+W/UfqbWMvG3bi3zLsqMpN/E
         6R2Dxoc/1RwoQp3E5EsnLWYgkcYJDfu62x/Qcger+pG9q0xSgWenItqsZlF2BCwPhwX6
         DCsqqLvdnbyEBQ7OTy7Vb0UW7Iu+Ei5x40QGn75ntz/X7LFDtxFBTa0pMQJ5mQ6u7qo+
         rSWBnxZNekxZ8l27DvK+2LGj194KKp5Yrq97T48d5EWIWhKb/a97FopGS5asDMSENNNR
         J6AaR8ZAdyJah4kyJ8vedHRo5qukNg8O6KxnE5IRQmI8D1Ao2xWJLk+bl+ZtmMFR3vZW
         UBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AOBfqbVXzAlxSsTo7twuMhvYkmI6Dik7sGdBy1OQnRw=;
        b=thmFlyscF6LaFQIs45+KXWn8FknvEopPbrYF/2+u+uyQuqtonNzV5KzsS+5MS1+cU+
         OcRbqx/TNOsoAp+C+R7/1P1OMTLhXtc2mlhPANNAC8KPCfab+qfWZ+vaQy+eux4enHna
         yhB2Pajb15uR6Ue+BguDb07uoU7v/yDoFar9C95lIXp9krwlTv+n0lWWyP1UcPsiCJhZ
         9e21wa7KERINghqGnNKOqDu2jrKhY3ryBnjZt6RabtMrB12pD84Qr8AYBZEIKuRk6qO9
         FNAEhdpCJdVGQ75DSoBXkEAFqRjZtxJ01izipE42NdJ5gTITtZJd6vjp/B+TCjSzNJ1K
         2ASg==
X-Gm-Message-State: APjAAAWl+uAfmq6eKu7f3y0AAXU26UGNnmXYdKfIcUmkqnnelQBBNBCS
        hC2rRAqolBPFKQHzN/rlvTg=
X-Google-Smtp-Source: APXvYqzHRXBzqtaLZXmoyzQcfliuExv+Zq02rByaIw9P8b9cwUUmtmg2bpJKXRDSzWYFsN0rkSUZng==
X-Received: by 2002:adf:ead2:: with SMTP id o18mr12563892wrn.107.1568998842562;
        Fri, 20 Sep 2019 10:00:42 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id a18sm4902104wrh.25.2019.09.20.10.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 10:00:41 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v3 2/2] net: stmmac: Support enhanced addressing mode for DWMAC 4.10
Date:   Fri, 20 Sep 2019 19:00:36 +0200
Message-Id: <20190920170036.22610-3-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190920170036.22610-1-thierry.reding@gmail.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The address width of the controller can be read from hardware feature
registers much like on XGMAC. Add support for parsing the ADDR64 field
so that the DMA mask can be set accordingly.

This avoids getting swiotlb involved for DMA on Tegra186 and later.

Also make sure that the upper 32 bits of the DMA address are written to
the DMA descriptors when enhanced addressing mode is used. Similarily,
for each channel, the upper 32 bits of the DMA descriptor ring's base
address also need to be programmed to make sure the correct memory can
be fetched when the DMA descriptor ring is located beyond the 32-bit
boundary.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v3:
- unconditionally write upper 32 bits

Changes in v2:
- also program the upper 32 bits of the DMA descriptor base address for
  each channel

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 ++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 22 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2ed11a581d80..f634fa09dffc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -183,6 +183,7 @@ enum power_event {
 #define GMAC_HW_HASH_TB_SZ		GENMASK(25, 24)
 #define GMAC_HW_FEAT_AVSEL		BIT(20)
 #define GMAC_HW_TSOEN			BIT(18)
+#define GMAC_HW_ADDR64			GENMASK(15, 14)
 #define GMAC_HW_TXFIFOSIZE		GENMASK(10, 6)
 #define GMAC_HW_RXFIFOSIZE		GENMASK(4, 0)
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index dbde23e7e169..d546041d2fcd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -431,8 +431,8 @@ static void dwmac4_get_addr(struct dma_desc *p, unsigned int *addr)
 
 static void dwmac4_set_addr(struct dma_desc *p, dma_addr_t addr)
 {
-	p->des0 = cpu_to_le32(addr);
-	p->des1 = 0;
+	p->des0 = cpu_to_le32(lower_32_bits(addr));
+	p->des1 = cpu_to_le32(upper_32_bits(addr));
 }
 
 static void dwmac4_clear(struct dma_desc *p)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 3ed5508586ef..8439dd84f786 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -79,6 +79,7 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
+	writel(upper_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
 }
 
@@ -97,6 +98,7 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
+	writel(upper_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
 	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
 }
 
@@ -132,6 +134,9 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= DMA_SYS_BUS_AAL;
 
+	if (dma_cfg->eame)
+		value |= DMA_SYS_BUS_EAME;
+
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 }
 
@@ -354,6 +359,23 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->hash_tb_sz = (hw_cap & GMAC_HW_HASH_TB_SZ) >> 24;
 	dma_cap->av = (hw_cap & GMAC_HW_FEAT_AVSEL) >> 20;
 	dma_cap->tsoen = (hw_cap & GMAC_HW_TSOEN) >> 18;
+
+	dma_cap->addr64 = (hw_cap & GMAC_HW_ADDR64) >> 14;
+	switch (dma_cap->addr64) {
+	case 0:
+		dma_cap->addr64 = 32;
+		break;
+	case 1:
+		dma_cap->addr64 = 40;
+		break;
+	case 2:
+		dma_cap->addr64 = 48;
+		break;
+	default:
+		dma_cap->addr64 = 32;
+		break;
+	}
+
 	/* RX and TX FIFO sizes are encoded as log2(n / 128). Undo that by
 	 * shifting and store the sizes in bytes.
 	 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index b66da0237d2a..5299fa1001a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -65,6 +65,7 @@
 #define DMA_SYS_BUS_MB			BIT(14)
 #define DMA_AXI_1KBBE			BIT(13)
 #define DMA_SYS_BUS_AAL			BIT(12)
+#define DMA_SYS_BUS_EAME		BIT(11)
 #define DMA_AXI_BLEN256			BIT(7)
 #define DMA_AXI_BLEN128			BIT(6)
 #define DMA_AXI_BLEN64			BIT(5)
@@ -91,7 +92,9 @@
 #define DMA_CHAN_CONTROL(x)		DMA_CHANX_BASE_ADDR(x)
 #define DMA_CHAN_TX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x4)
 #define DMA_CHAN_RX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x8)
+#define DMA_CHAN_TX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x10)
 #define DMA_CHAN_TX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x14)
+#define DMA_CHAN_RX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x18)
 #define DMA_CHAN_RX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x1c)
 #define DMA_CHAN_TX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x20)
 #define DMA_CHAN_RX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x28)
-- 
2.23.0

