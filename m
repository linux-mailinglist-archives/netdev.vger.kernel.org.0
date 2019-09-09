Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A77ADC10
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfIIPZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 11:25:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37797 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfIIPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 11:25:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id r195so15235783wme.2;
        Mon, 09 Sep 2019 08:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R3AmFgKIHr2+eUt61+JKy94/P0Wlw2GrMpTlHVuNEDk=;
        b=G7CWSFT4CZd9+bbsEosATLyYlVIA698RGnbGUBVbM3gkz1tz56ou5rYC6gj9MgFbJi
         0KG4jrSdkFiIK2CG/iOzyQRiBtRuyRNaXQqZ929Ci5ym8IEzKKt3ypcxqIEC0cidfaCg
         /YQA8NZb45rL5rCkfyoKDL+UQiRJ/zLV2cJqyOCwhAx55IHbQNQXPyq8jGxYg3SKeu3E
         fcBXer9fIcVAI3Ml5KHvOoO3cT9ZJfaaUVW8Bad4dQiT9H6nO3Qqf3bR9mJX0UTPRCE7
         CfIZQ5RSsBIJU/j9Z/Yg9Y59vU0bLelKljCJoYp8F/MTMGlT5vA9MMc+HaXYcqboeHC+
         115Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R3AmFgKIHr2+eUt61+JKy94/P0Wlw2GrMpTlHVuNEDk=;
        b=FASn0FPzDtt4xrrFJTjml6OTowRuq9AVQavST+kuqaLvWQCqHjwkyGRAHrixpfyFBT
         ttKQ3R33IkEnkn0ld36WVUFiP7A+mrkVvchpCbeqCf/L75B2dTd6f/T0zfDI/aZ2GVkU
         bb9chGhxihN+cIU+8cAZZjiJV19AKeYBbJrjcyfkkwzxHALYFO7KAr17jtrW6WDn3Afz
         fI9E8FKV8mBRpGvCRzcoJFaCxXi0um/qztNijM8lq+w9HrKv8IMR1R4XoJVlzD6/Lcch
         zVNYe9tzjV958jOf2DSu0zoFgJdSVgIoxUvobol4kXvyIoHnJkGv4emgYGM8Na3pIDj1
         3tSw==
X-Gm-Message-State: APjAAAWaIuo1S+WVsoUGojBo2G44eaS317HCelj3h6yfdFXzwHbbYbYQ
        bDGvAVNl1ZL85fI0qFDqIAk=
X-Google-Smtp-Source: APXvYqxZfaKzFKkTocNLZCLp3Ej++GlhMGfpyhz2jgr8N4zxCDaNaYDZG3YKVJwlM3jYEnCefAF4uA==
X-Received: by 2002:a05:600c:cf:: with SMTP id u15mr20520044wmm.168.1568042750904;
        Mon, 09 Sep 2019 08:25:50 -0700 (PDT)
Received: from localhost (p2E5BE0B8.dip0.t-ipconnect.de. [46.91.224.184])
        by smtp.gmail.com with ESMTPSA id f23sm17150694wmf.1.2019.09.09.08.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 08:25:49 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing mode for DWMAC 4.10
Date:   Mon,  9 Sep 2019 17:25:46 +0200
Message-Id: <20190909152546.383-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190909152546.383-1-thierry.reding@gmail.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
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
Changes in v2:
- also program the upper 32 bits of the DMA descriptor base address for
  each channel

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 +--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 28 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 ++
 4 files changed, 34 insertions(+), 2 deletions(-)

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
index 3ed5508586ef..e77410f21d7d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
+	if (dma_cfg->eame)
+		writel(upper_32_bits(dma_rx_phy),
+		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
+
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
 }
 
@@ -97,6 +101,10 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
+	if (dma_cfg->eame)
+		writel(upper_32_bits(dma_tx_phy),
+		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
+
 	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
 }
 
@@ -132,6 +140,9 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= DMA_SYS_BUS_AAL;
 
+	if (dma_cfg->eame)
+		value |= DMA_SYS_BUS_EAME;
+
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 }
 
@@ -354,6 +365,23 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
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

