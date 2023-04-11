Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DBF6DE56B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjDKUHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjDKUGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:06:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719E8559E
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2FPz5thBTiPSg91my6OG73CldgFmC3BGeQwuAs95u2g=;
        b=JQLGntm7T32Dy6aqW1Neaanro6mK6SxgMnHdwrmWieIu/zRL6YA6DYr9JlqcGVym6x6YXe
        SASySavq15UdScRoaXKbfq7q70OKtAy4yByWLwnUx0wotnFiY+ifl39w2D3x67abS3vc9G
        jpQlMEI/Jcz8P3+YG6YMuqAovQzq8ss=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-VQ-nZJkrOz6tilCiqkB-WQ-1; Tue, 11 Apr 2023 16:05:12 -0400
X-MC-Unique: VQ-nZJkrOz6tilCiqkB-WQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-17fd0d597dcso20408409fac.6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FPz5thBTiPSg91my6OG73CldgFmC3BGeQwuAs95u2g=;
        b=unT4PzeLlIxlGoqeuDPdkyH7i7Zx9lA1ZDaafHZCyut8f1qYKf3LM5p9RBUOWp/DRM
         MWxNRO2BnM8BCMwVPVgJSfRN41dipcYbWGTQj9HYC1Y02g7vGbgrQ8nHssMsdwVW0//r
         kAhJCcud75Ug3d4Fzz48u47DJ6F1j6NiUzl3GniJsb4fQK/k+GMsZXHEoT8I/ns5B6b9
         Uhhc1e95/YAseIJSwilhPXbVbxgiG8BuYEDtLGrfTzkopuNY77bk9JogyeMrF0PoV1QI
         RImloPJ5g4+iAjlZO3ewh02XdhCvUKdrchPlw1fKRZwPlE4FrXI3W2XrQI4JqlFSiNlR
         yMEQ==
X-Gm-Message-State: AAQBX9dtyj7eaVm5cB5tAv8M595WPUpVKy7UYmSOSaJaciqaZcfhfJmd
        ASfEI7OhdrkbQPJDXrJL79OQWkkFB6b0trzHoblTOXfMsbGMYzaYN9j0aLlwD7XtPDHJtQW32cC
        Uttm+be+sByb1ci30
X-Received: by 2002:a54:460d:0:b0:38b:7fc2:2df6 with SMTP id p13-20020a54460d000000b0038b7fc22df6mr6882680oip.57.1681243511050;
        Tue, 11 Apr 2023 13:05:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350bRHGxZaUfXEJdlSmA1DNM9jmzwTdsEeARpU9XCn6ggL3BViiOfBqqQbLXTBRg6unb92Evr9w==
X-Received: by 2002:a54:460d:0:b0:38b:7fc2:2df6 with SMTP id p13-20020a54460d000000b0038b7fc22df6mr6882670oip.57.1681243510552;
        Tue, 11 Apr 2023 13:05:10 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:05:10 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v4 08/12] net: stmmac: Pass stmmac_priv in some callbacks
Date:   Tue, 11 Apr 2023 15:04:05 -0500
Message-Id: <20230411200409.455355-9-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing stmmac_priv to some of the callbacks allows hwif implementations
to grab some data that platforms can customize. Adjust the callbacks
accordingly in preparation of such a platform customization.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v3:
    * None, evaluated a static inline approach for hwif functions but
      deemed the current approach to be better for changing these
      functions (Simon)

Changes since v2:
    * New, replacing old wrapper approach. Requested here:
      https://lore.kernel.org/netdev/20230320204153.21736840@kernel.org/

 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  36 +++--
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   3 +-
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  19 ++-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |  10 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  14 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  44 ++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  38 +++--
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  38 +++--
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  22 ++-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  18 ++-
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   |   9 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  71 ++++++---
 drivers/net/ethernet/stmicro/stmmac/hwif.h    | 146 ++++++++++--------
 13 files changed, 291 insertions(+), 177 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index f834472599f7..c2c592ba0eb8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -304,7 +304,8 @@ static void sun8i_dwmac_dma_init(void __iomem *ioaddr,
 	writel(0x1FFFFFF, ioaddr + EMAC_INT_STA);
 }
 
-static void sun8i_dwmac_dma_init_rx(void __iomem *ioaddr,
+static void sun8i_dwmac_dma_init_rx(struct stmmac_priv *priv,
+				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_rx_phy, u32 chan)
 {
@@ -312,7 +313,8 @@ static void sun8i_dwmac_dma_init_rx(void __iomem *ioaddr,
 	writel(lower_32_bits(dma_rx_phy), ioaddr + EMAC_RX_DESC_LIST);
 }
 
-static void sun8i_dwmac_dma_init_tx(void __iomem *ioaddr,
+static void sun8i_dwmac_dma_init_tx(struct stmmac_priv *priv,
+				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_tx_phy, u32 chan)
 {
@@ -324,7 +326,8 @@ static void sun8i_dwmac_dma_init_tx(void __iomem *ioaddr,
  * Called from stmmac_dma_ops->dump_regs
  * Used for ethtool
  */
-static void sun8i_dwmac_dump_regs(void __iomem *ioaddr, u32 *reg_space)
+static void sun8i_dwmac_dump_regs(struct stmmac_priv *priv,
+				  void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
 
@@ -352,7 +355,8 @@ static void sun8i_dwmac_dump_mac_regs(struct mac_device_info *hw,
 	}
 }
 
-static void sun8i_dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan,
+static void sun8i_dwmac_enable_dma_irq(struct stmmac_priv *priv,
+				       void __iomem *ioaddr, u32 chan,
 				       bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + EMAC_INT_EN);
@@ -365,7 +369,8 @@ static void sun8i_dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan,
 	writel(value, ioaddr + EMAC_INT_EN);
 }
 
-static void sun8i_dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan,
+static void sun8i_dwmac_disable_dma_irq(struct stmmac_priv *priv,
+					void __iomem *ioaddr, u32 chan,
 					bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + EMAC_INT_EN);
@@ -378,7 +383,8 @@ static void sun8i_dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan,
 	writel(value, ioaddr + EMAC_INT_EN);
 }
 
-static void sun8i_dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan)
+static void sun8i_dwmac_dma_start_tx(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 chan)
 {
 	u32 v;
 
@@ -398,7 +404,8 @@ static void sun8i_dwmac_enable_dma_transmission(void __iomem *ioaddr)
 	writel(v, ioaddr + EMAC_TX_CTL1);
 }
 
-static void sun8i_dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+static void sun8i_dwmac_dma_stop_tx(struct stmmac_priv *priv,
+				    void __iomem *ioaddr, u32 chan)
 {
 	u32 v;
 
@@ -407,7 +414,8 @@ static void sun8i_dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 	writel(v, ioaddr + EMAC_TX_CTL1);
 }
 
-static void sun8i_dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan)
+static void sun8i_dwmac_dma_start_rx(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 chan)
 {
 	u32 v;
 
@@ -417,7 +425,8 @@ static void sun8i_dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan)
 	writel(v, ioaddr + EMAC_RX_CTL1);
 }
 
-static void sun8i_dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+static void sun8i_dwmac_dma_stop_rx(struct stmmac_priv *priv,
+				    void __iomem *ioaddr, u32 chan)
 {
 	u32 v;
 
@@ -426,7 +435,8 @@ static void sun8i_dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 	writel(v, ioaddr + EMAC_RX_CTL1);
 }
 
-static int sun8i_dwmac_dma_interrupt(void __iomem *ioaddr,
+static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
+				     void __iomem *ioaddr,
 				     struct stmmac_extra_stats *x, u32 chan,
 				     u32 dir)
 {
@@ -492,7 +502,8 @@ static int sun8i_dwmac_dma_interrupt(void __iomem *ioaddr,
 	return ret;
 }
 
-static void sun8i_dwmac_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
+static void sun8i_dwmac_dma_operation_mode_rx(struct stmmac_priv *priv,
+					      void __iomem *ioaddr, int mode,
 					      u32 channel, int fifosz, u8 qmode)
 {
 	u32 v;
@@ -515,7 +526,8 @@ static void sun8i_dwmac_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
 	writel(v, ioaddr + EMAC_RX_CTL1);
 }
 
-static void sun8i_dwmac_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
+static void sun8i_dwmac_dma_operation_mode_tx(struct stmmac_priv *priv,
+					      void __iomem *ioaddr, int mode,
 					      u32 channel, int fifosz, u8 qmode)
 {
 	u32 v;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 0e00dd83d027..3927609abc44 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -414,7 +414,8 @@ static void dwmac1000_get_adv_lp(void __iomem *ioaddr, struct rgmii_adv *adv)
 	dwmac_get_adv_lp(ioaddr, GMAC_PCS_BASE, adv);
 }
 
-static void dwmac1000_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+static void dwmac1000_debug(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    struct stmmac_extra_stats *x,
 			    u32 rx_queues, u32 tx_queues)
 {
 	u32 value = readl(ioaddr + GMAC_DEBUG);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index f5581db0ba9b..daf79cdbd3ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -110,7 +110,8 @@ static void dwmac1000_dma_init(void __iomem *ioaddr,
 	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
 }
 
-static void dwmac1000_dma_init_rx(void __iomem *ioaddr,
+static void dwmac1000_dma_init_rx(struct stmmac_priv *priv,
+				  void __iomem *ioaddr,
 				  struct stmmac_dma_cfg *dma_cfg,
 				  dma_addr_t dma_rx_phy, u32 chan)
 {
@@ -118,7 +119,8 @@ static void dwmac1000_dma_init_rx(void __iomem *ioaddr,
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_RCV_BASE_ADDR);
 }
 
-static void dwmac1000_dma_init_tx(void __iomem *ioaddr,
+static void dwmac1000_dma_init_tx(struct stmmac_priv *priv,
+				  void __iomem *ioaddr,
 				  struct stmmac_dma_cfg *dma_cfg,
 				  dma_addr_t dma_tx_phy, u32 chan)
 {
@@ -147,7 +149,8 @@ static u32 dwmac1000_configure_fc(u32 csr6, int rxfifosz)
 	return csr6;
 }
 
-static void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
+static void dwmac1000_dma_operation_mode_rx(struct stmmac_priv *priv,
+					    void __iomem *ioaddr, int mode,
 					    u32 channel, int fifosz, u8 qmode)
 {
 	u32 csr6 = readl(ioaddr + DMA_CONTROL);
@@ -175,7 +178,8 @@ static void dwmac1000_dma_operation_mode_rx(void __iomem *ioaddr, int mode,
 	writel(csr6, ioaddr + DMA_CONTROL);
 }
 
-static void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
+static void dwmac1000_dma_operation_mode_tx(struct stmmac_priv *priv,
+					    void __iomem *ioaddr, int mode,
 					    u32 channel, int fifosz, u8 qmode)
 {
 	u32 csr6 = readl(ioaddr + DMA_CONTROL);
@@ -208,7 +212,8 @@ static void dwmac1000_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
 	writel(csr6, ioaddr + DMA_CONTROL);
 }
 
-static void dwmac1000_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
+static void dwmac1000_dump_dma_regs(struct stmmac_priv *priv,
+				    void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
 
@@ -263,8 +268,8 @@ static int dwmac1000_get_hw_feature(void __iomem *ioaddr,
 	return 0;
 }
 
-static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
-				  u32 queue)
+static void dwmac1000_rx_watchdog(struct stmmac_priv *priv,
+				  void __iomem *ioaddr, u32 riwt, u32 queue)
 {
 	writel(riwt, ioaddr + DMA_RX_WATCHDOG);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index f6abc7bfd29d..1c32b1788f02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -29,7 +29,7 @@ static void dwmac100_dma_init(void __iomem *ioaddr,
 	writel(DMA_INTR_DEFAULT_MASK, ioaddr + DMA_INTR_ENA);
 }
 
-static void dwmac100_dma_init_rx(void __iomem *ioaddr,
+static void dwmac100_dma_init_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
 				 struct stmmac_dma_cfg *dma_cfg,
 				 dma_addr_t dma_rx_phy, u32 chan)
 {
@@ -37,7 +37,7 @@ static void dwmac100_dma_init_rx(void __iomem *ioaddr,
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_RCV_BASE_ADDR);
 }
 
-static void dwmac100_dma_init_tx(void __iomem *ioaddr,
+static void dwmac100_dma_init_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
 				 struct stmmac_dma_cfg *dma_cfg,
 				 dma_addr_t dma_tx_phy, u32 chan)
 {
@@ -50,7 +50,8 @@ static void dwmac100_dma_init_tx(void __iomem *ioaddr,
  * The transmit threshold can be programmed by setting the TTC bits in the DMA
  * control register.
  */
-static void dwmac100_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
+static void dwmac100_dma_operation_mode_tx(struct stmmac_priv *priv,
+					   void __iomem *ioaddr, int mode,
 					   u32 channel, int fifosz, u8 qmode)
 {
 	u32 csr6 = readl(ioaddr + DMA_CONTROL);
@@ -65,7 +66,8 @@ static void dwmac100_dma_operation_mode_tx(void __iomem *ioaddr, int mode,
 	writel(csr6, ioaddr + DMA_CONTROL);
 }
 
-static void dwmac100_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
+static void dwmac100_dump_dma_regs(struct stmmac_priv *priv,
+				   void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 36251ec2589c..f44180519638 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -198,7 +198,8 @@ static void dwmac4_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 	writel(value, ioaddr + MTL_OPERATION_MODE);
 }
 
-static void dwmac4_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+static void dwmac4_set_mtl_tx_queue_weight(struct stmmac_priv *priv,
+					   struct mac_device_info *hw,
 					   u32 weight, u32 queue)
 {
 	void __iomem *ioaddr = hw->pcsr;
@@ -227,7 +228,8 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	}
 }
 
-static void dwmac4_config_cbs(struct mac_device_info *hw,
+static void dwmac4_config_cbs(struct stmmac_priv *priv,
+			      struct mac_device_info *hw,
 			      u32 send_slope, u32 idle_slope,
 			      u32 high_credit, u32 low_credit, u32 queue)
 {
@@ -253,7 +255,7 @@ static void dwmac4_config_cbs(struct mac_device_info *hw,
 	writel(value, ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(queue));
 
 	/* configure idle slope (same register as tx weight) */
-	dwmac4_set_mtl_tx_queue_weight(hw, idle_slope, queue);
+	dwmac4_set_mtl_tx_queue_weight(priv, hw, idle_slope, queue);
 
 	/* configure high credit */
 	value = readl(ioaddr + MTL_HIGH_CREDX_BASE_ADDR(queue));
@@ -759,7 +761,8 @@ static void dwmac4_phystatus(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 	}
 }
 
-static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
+static int dwmac4_irq_mtl_status(struct stmmac_priv *priv,
+				 struct mac_device_info *hw, u32 chan)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 mtl_int_qx_status;
@@ -833,7 +836,8 @@ static int dwmac4_irq_status(struct mac_device_info *hw,
 	return ret;
 }
 
-static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+static void dwmac4_debug(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 struct stmmac_extra_stats *x,
 			 u32 rx_queues, u32 tx_queues)
 {
 	u32 value;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index d99fa028c646..6f255d12f60f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -68,7 +68,8 @@ static void dwmac4_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 }
 
-static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
+static void dwmac4_dma_init_rx_chan(struct stmmac_priv *priv,
+				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_rx_phy, u32 chan)
 {
@@ -86,7 +87,8 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
 }
 
-static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
+static void dwmac4_dma_init_tx_chan(struct stmmac_priv *priv,
+				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_tx_phy, u32 chan)
 {
@@ -108,7 +110,8 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
 }
 
-static void dwmac4_dma_init_channel(void __iomem *ioaddr,
+static void dwmac4_dma_init_channel(struct stmmac_priv *priv,
+				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg, u32 chan)
 {
 	u32 value;
@@ -124,7 +127,8 @@ static void dwmac4_dma_init_channel(void __iomem *ioaddr,
 	       ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-static void dwmac410_dma_init_channel(void __iomem *ioaddr,
+static void dwmac410_dma_init_channel(struct stmmac_priv *priv,
+				      void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
 {
 	u32 value;
@@ -176,7 +180,8 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 
 }
 
-static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
+static void _dwmac4_dump_dma_regs(struct stmmac_priv *priv,
+				  void __iomem *ioaddr, u32 channel,
 				  u32 *reg_space)
 {
 	reg_space[DMA_CHAN_CONTROL(channel) / 4] =
@@ -215,20 +220,23 @@ static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
 		readl(ioaddr + DMA_CHAN_STATUS(channel));
 }
 
-static void dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
+static void dwmac4_dump_dma_regs(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 u32 *reg_space)
 {
 	int i;
 
 	for (i = 0; i < DMA_CHANNEL_NB_MAX; i++)
-		_dwmac4_dump_dma_regs(ioaddr, i, reg_space);
+		_dwmac4_dump_dma_regs(priv, ioaddr, i, reg_space);
 }
 
-static void dwmac4_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
+static void dwmac4_rx_watchdog(struct stmmac_priv *priv, void __iomem *ioaddr,
+			       u32 riwt, u32 queue)
 {
 	writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(queue));
 }
 
-static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
+static void dwmac4_dma_rx_chan_op_mode(struct stmmac_priv *priv,
+				       void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
 	unsigned int rqs = fifosz / 256 - 1;
@@ -295,7 +303,8 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
 }
 
-static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
+static void dwmac4_dma_tx_chan_op_mode(struct stmmac_priv *priv,
+				       void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
 	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
@@ -442,7 +451,8 @@ static int dwmac4_get_hw_feature(void __iomem *ioaddr,
 }
 
 /* Enable/disable TSO feature and set MSS */
-static void dwmac4_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
+static void dwmac4_enable_tso(struct stmmac_priv *priv, void __iomem *ioaddr,
+			      bool en, u32 chan)
 {
 	u32 value;
 
@@ -459,7 +469,8 @@ static void dwmac4_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
 	}
 }
 
-static void dwmac4_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
+static void dwmac4_qmode(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 channel, u8 qmode)
 {
 	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
 
@@ -472,7 +483,8 @@ static void dwmac4_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
 }
 
-static void dwmac4_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
+static void dwmac4_set_bfsize(struct stmmac_priv *priv, void __iomem *ioaddr,
+			      int bfsize, u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
@@ -482,7 +494,8 @@ static void dwmac4_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 }
 
-static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
+static void dwmac4_enable_sph(struct stmmac_priv *priv, void __iomem *ioaddr,
+			      bool en, u32 chan)
 {
 	u32 value = readl(ioaddr + GMAC_EXT_CONFIG);
 
@@ -498,7 +511,8 @@ static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
 }
 
-static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+static int dwmac4_enable_tbs(struct stmmac_priv *priv, void __iomem *ioaddr,
+			     bool en, u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 9321879b599c..740c3bc8d9a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -220,19 +220,31 @@
 #define DMA_CHAN0_DBG_STAT_RPS_SHIFT	8
 
 int dwmac4_dma_reset(void __iomem *ioaddr);
-void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan);
-void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan);
-void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan);
-void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan);
-int dwmac4_dma_interrupt(void __iomem *ioaddr,
+void dwmac4_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   u32 chan, bool rx, bool tx);
+void dwmac410_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			     u32 chan, bool rx, bool tx);
+void dwmac4_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 chan, bool rx, bool tx);
+void dwmac410_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			      u32 chan, bool rx, bool tx);
+void dwmac4_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan);
+void dwmac4_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+void dwmac4_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan);
+void dwmac4_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan, u32 dir);
-void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
-void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
-void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
-void dwmac4_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
+void dwmac4_set_rx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 len, u32 chan);
+void dwmac4_set_tx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 len, u32 chan);
+void dwmac4_set_rx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 tail_ptr, u32 chan);
+void dwmac4_set_tx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 tail_ptr, u32 chan);
 
 #endif /* __DWMAC4_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index d1c605777985..5e9c495aa03e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -25,17 +25,20 @@ int dwmac4_dma_reset(void __iomem *ioaddr)
 				 10000, 1000000);
 }
 
-void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
+void dwmac4_set_rx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 tail_ptr, u32 chan)
 {
 	writel(tail_ptr, ioaddr + DMA_CHAN_RX_END_ADDR(chan));
 }
 
-void dwmac4_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
+void dwmac4_set_tx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 tail_ptr, u32 chan)
 {
 	writel(tail_ptr, ioaddr + DMA_CHAN_TX_END_ADDR(chan));
 }
 
-void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan)
+void dwmac4_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
@@ -47,7 +50,8 @@ void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + GMAC_CONFIG);
 }
 
-void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+void dwmac4_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
@@ -55,7 +59,8 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
 }
 
-void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
+void dwmac4_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
@@ -68,7 +73,8 @@ void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + GMAC_CONFIG);
 }
 
-void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+void dwmac4_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
@@ -76,17 +82,20 @@ void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 }
 
-void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+void dwmac4_set_tx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 len, u32 chan)
 {
 	writel(len, ioaddr + DMA_CHAN_TX_RING_LEN(chan));
 }
 
-void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+void dwmac4_set_rx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 len, u32 chan)
 {
 	writel(len, ioaddr + DMA_CHAN_RX_RING_LEN(chan));
 }
 
-void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac4_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
@@ -98,7 +107,8 @@ void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac410_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			     u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
@@ -110,7 +120,8 @@ void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac4_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
@@ -122,7 +133,8 @@ void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac410_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			      u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
 
@@ -134,7 +146,7 @@ void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-int dwmac4_dma_interrupt(void __iomem *ioaddr,
+int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
 	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(chan));
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index acd70b9a3173..72672391675f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -153,14 +153,20 @@
 #define NUM_DWMAC4_DMA_REGS	27
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
-void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
-void dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan);
-void dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan);
-void dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan);
-void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan);
-int dwmac_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
-			u32 chan, u32 dir);
+void dwmac_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			  u32 chan, bool rx, bool tx);
+void dwmac_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   u32 chan, bool rx, bool tx);
+void dwmac_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+void dwmac_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+		       u32 chan);
+void dwmac_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+void dwmac_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+		       u32 chan);
+int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
+			struct stmmac_extra_stats *x, u32 chan, u32 dir);
 int dwmac_dma_reset(void __iomem *ioaddr);
 
 #endif /* __DWMAC_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 9b6138b11776..0b6f999a8305 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -32,7 +32,8 @@ void dwmac_enable_dma_transmission(void __iomem *ioaddr)
 	writel(1, ioaddr + DMA_XMT_POLL_DEMAND);
 }
 
-void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			  u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_INTR_ENA);
 
@@ -44,7 +45,8 @@ void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
 
-void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+void dwmac_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   u32 chan, bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + DMA_INTR_ENA);
 
@@ -56,28 +58,30 @@ void dwmac_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_INTR_ENA);
 }
 
-void dwmac_dma_start_tx(void __iomem *ioaddr, u32 chan)
+void dwmac_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CONTROL);
 	value |= DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CONTROL);
 }
 
-void dwmac_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+void dwmac_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr, u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CONTROL);
 	value &= ~DMA_CONTROL_ST;
 	writel(value, ioaddr + DMA_CONTROL);
 }
 
-void dwmac_dma_start_rx(void __iomem *ioaddr, u32 chan)
+void dwmac_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CONTROL);
 	value |= DMA_CONTROL_SR;
 	writel(value, ioaddr + DMA_CONTROL);
 }
 
-void dwmac_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+void dwmac_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr, u32 chan)
 {
 	u32 value = readl(ioaddr + DMA_CONTROL);
 	value &= ~DMA_CONTROL_SR;
@@ -154,7 +158,7 @@ static void show_rx_process_state(unsigned int status)
 }
 #endif
 
-int dwmac_dma_interrupt(void __iomem *ioaddr,
+int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
 	int ret = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index c6c4d7948fe5..a0c2ef8bb0ac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -187,7 +187,8 @@ static void dwxgmac2_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 	}
 }
 
-static void dwxgmac2_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+static void dwxgmac2_set_mtl_tx_queue_weight(struct stmmac_priv *priv,
+					     struct mac_device_info *hw,
 					     u32 weight, u32 queue)
 {
 	void __iomem *ioaddr = hw->pcsr;
@@ -212,7 +213,8 @@ static void dwxgmac2_map_mtl_to_dma(struct mac_device_info *hw, u32 queue,
 	writel(value, ioaddr + reg);
 }
 
-static void dwxgmac2_config_cbs(struct mac_device_info *hw,
+static void dwxgmac2_config_cbs(struct stmmac_priv *priv,
+				struct mac_device_info *hw,
 				u32 send_slope, u32 idle_slope,
 				u32 high_credit, u32 low_credit, u32 queue)
 {
@@ -276,7 +278,8 @@ static int dwxgmac2_host_irq_status(struct mac_device_info *hw,
 	return ret;
 }
 
-static int dwxgmac2_host_mtl_irq_status(struct mac_device_info *hw, u32 chan)
+static int dwxgmac2_host_mtl_irq_status(struct stmmac_priv *priv,
+					struct mac_device_info *hw, u32 chan)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	int ret = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 5e98355f422b..dfd53264e036 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -33,7 +33,8 @@ static void dwxgmac2_dma_init(void __iomem *ioaddr,
 	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
 }
 
-static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
+static void dwxgmac2_dma_init_chan(struct stmmac_priv *priv,
+				   void __iomem *ioaddr,
 				   struct stmmac_dma_cfg *dma_cfg, u32 chan)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_CONTROL(chan));
@@ -45,7 +46,8 @@ static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
 	writel(XGMAC_DMA_INT_DEFAULT_EN, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
-static void dwxgmac2_dma_init_rx_chan(void __iomem *ioaddr,
+static void dwxgmac2_dma_init_rx_chan(struct stmmac_priv *priv,
+				      void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg,
 				      dma_addr_t phy, u32 chan)
 {
@@ -61,7 +63,8 @@ static void dwxgmac2_dma_init_rx_chan(void __iomem *ioaddr,
 	writel(lower_32_bits(phy), ioaddr + XGMAC_DMA_CH_RxDESC_LADDR(chan));
 }
 
-static void dwxgmac2_dma_init_tx_chan(void __iomem *ioaddr,
+static void dwxgmac2_dma_init_tx_chan(struct stmmac_priv *priv,
+				      void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg,
 				      dma_addr_t phy, u32 chan)
 {
@@ -131,7 +134,8 @@ static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	writel(XGMAC_RDPS, ioaddr + XGMAC_RX_EDMA_CTRL);
 }
 
-static void dwxgmac2_dma_dump_regs(void __iomem *ioaddr, u32 *reg_space)
+static void dwxgmac2_dma_dump_regs(struct stmmac_priv *priv,
+				   void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
 
@@ -139,8 +143,8 @@ static void dwxgmac2_dma_dump_regs(void __iomem *ioaddr, u32 *reg_space)
 		reg_space[i] = readl(ioaddr + i * 4);
 }
 
-static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
-				 u32 channel, int fifosz, u8 qmode)
+static void dwxgmac2_dma_rx_mode(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 int mode, u32 channel, int fifosz, u8 qmode)
 {
 	u32 value = readl(ioaddr + XGMAC_MTL_RXQ_OPMODE(channel));
 	unsigned int rqs = fifosz / 256 - 1;
@@ -205,8 +209,8 @@ static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
 	writel(value | XGMAC_RXOIE, ioaddr + XGMAC_MTL_QINTEN(channel));
 }
 
-static void dwxgmac2_dma_tx_mode(void __iomem *ioaddr, int mode,
-				 u32 channel, int fifosz, u8 qmode)
+static void dwxgmac2_dma_tx_mode(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 int mode, u32 channel, int fifosz, u8 qmode)
 {
 	u32 value = readl(ioaddr + XGMAC_MTL_TXQ_OPMODE(channel));
 	unsigned int tqs = fifosz / 256 - 1;
@@ -248,7 +252,8 @@ static void dwxgmac2_dma_tx_mode(void __iomem *ioaddr, int mode,
 	writel(value, ioaddr +  XGMAC_MTL_TXQ_OPMODE(channel));
 }
 
-static void dwxgmac2_enable_dma_irq(void __iomem *ioaddr, u32 chan,
+static void dwxgmac2_enable_dma_irq(struct stmmac_priv *priv,
+				    void __iomem *ioaddr, u32 chan,
 				    bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
@@ -261,7 +266,8 @@ static void dwxgmac2_enable_dma_irq(void __iomem *ioaddr, u32 chan,
 	writel(value, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
-static void dwxgmac2_disable_dma_irq(void __iomem *ioaddr, u32 chan,
+static void dwxgmac2_disable_dma_irq(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 chan,
 				     bool rx, bool tx)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
@@ -274,7 +280,8 @@ static void dwxgmac2_disable_dma_irq(void __iomem *ioaddr, u32 chan,
 	writel(value, ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 }
 
-static void dwxgmac2_dma_start_tx(void __iomem *ioaddr, u32 chan)
+static void dwxgmac2_dma_start_tx(struct stmmac_priv *priv,
+				  void __iomem *ioaddr, u32 chan)
 {
 	u32 value;
 
@@ -287,7 +294,8 @@ static void dwxgmac2_dma_start_tx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + XGMAC_TX_CONFIG);
 }
 
-static void dwxgmac2_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+static void dwxgmac2_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 u32 chan)
 {
 	u32 value;
 
@@ -300,7 +308,8 @@ static void dwxgmac2_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + XGMAC_TX_CONFIG);
 }
 
-static void dwxgmac2_dma_start_rx(void __iomem *ioaddr, u32 chan)
+static void dwxgmac2_dma_start_rx(struct stmmac_priv *priv,
+				  void __iomem *ioaddr, u32 chan)
 {
 	u32 value;
 
@@ -313,7 +322,8 @@ static void dwxgmac2_dma_start_rx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + XGMAC_RX_CONFIG);
 }
 
-static void dwxgmac2_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+static void dwxgmac2_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 u32 chan)
 {
 	u32 value;
 
@@ -322,7 +332,8 @@ static void dwxgmac2_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
 }
 
-static int dwxgmac2_dma_interrupt(void __iomem *ioaddr,
+static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
+				  void __iomem *ioaddr,
 				  struct stmmac_extra_stats *x, u32 chan,
 				  u32 dir)
 {
@@ -449,32 +460,38 @@ static int dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	return 0;
 }
 
-static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
+static void dwxgmac2_rx_watchdog(struct stmmac_priv *priv, void __iomem *ioaddr,
+				 u32 riwt, u32 queue)
 {
 	writel(riwt & XGMAC_RWT, ioaddr + XGMAC_DMA_CH_Rx_WATCHDOG(queue));
 }
 
-static void dwxgmac2_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+static void dwxgmac2_set_rx_ring_len(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 len, u32 chan)
 {
 	writel(len, ioaddr + XGMAC_DMA_CH_RxDESC_RING_LEN(chan));
 }
 
-static void dwxgmac2_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+static void dwxgmac2_set_tx_ring_len(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 len, u32 chan)
 {
 	writel(len, ioaddr + XGMAC_DMA_CH_TxDESC_RING_LEN(chan));
 }
 
-static void dwxgmac2_set_rx_tail_ptr(void __iomem *ioaddr, u32 ptr, u32 chan)
+static void dwxgmac2_set_rx_tail_ptr(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 ptr, u32 chan)
 {
 	writel(ptr, ioaddr + XGMAC_DMA_CH_RxDESC_TAIL_LPTR(chan));
 }
 
-static void dwxgmac2_set_tx_tail_ptr(void __iomem *ioaddr, u32 ptr, u32 chan)
+static void dwxgmac2_set_tx_tail_ptr(struct stmmac_priv *priv,
+				     void __iomem *ioaddr, u32 ptr, u32 chan)
 {
 	writel(ptr, ioaddr + XGMAC_DMA_CH_TxDESC_TAIL_LPTR(chan));
 }
 
-static void dwxgmac2_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
+static void dwxgmac2_enable_tso(struct stmmac_priv *priv, void __iomem *ioaddr,
+				bool en, u32 chan)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
 
@@ -486,7 +503,8 @@ static void dwxgmac2_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
 }
 
-static void dwxgmac2_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
+static void dwxgmac2_qmode(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   u32 channel, u8 qmode)
 {
 	u32 value = readl(ioaddr + XGMAC_MTL_TXQ_OPMODE(channel));
 	u32 flow = readl(ioaddr + XGMAC_RX_FLOW_CTRL);
@@ -503,7 +521,8 @@ static void dwxgmac2_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 	writel(value, ioaddr +  XGMAC_MTL_TXQ_OPMODE(channel));
 }
 
-static void dwxgmac2_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
+static void dwxgmac2_set_bfsize(struct stmmac_priv *priv, void __iomem *ioaddr,
+				int bfsize, u32 chan)
 {
 	u32 value;
 
@@ -513,7 +532,8 @@ static void dwxgmac2_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
 }
 
-static void dwxgmac2_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
+static void dwxgmac2_enable_sph(struct stmmac_priv *priv, void __iomem *ioaddr,
+				bool en, u32 chan)
 {
 	u32 value = readl(ioaddr + XGMAC_RX_CONFIG);
 
@@ -529,7 +549,8 @@ static void dwxgmac2_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_CONTROL(chan));
 }
 
-static int dwxgmac2_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+static int dwxgmac2_enable_tbs(struct stmmac_priv *priv, void __iomem *ioaddr,
+			       bool en, u32 chan)
 {
 	u32 value = readl(ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 7f906ef3ea4f..6ee7cf07cfd7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -26,6 +26,7 @@
 })
 
 struct stmmac_extra_stats;
+struct stmmac_priv;
 struct stmmac_safety_stats;
 struct dma_desc;
 struct dma_extended_desc;
@@ -171,109 +172,125 @@ struct stmmac_dma_ops {
 	int (*reset)(void __iomem *ioaddr);
 	void (*init)(void __iomem *ioaddr, struct stmmac_dma_cfg *dma_cfg,
 		     int atds);
-	void (*init_chan)(void __iomem *ioaddr,
+	void (*init_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			  struct stmmac_dma_cfg *dma_cfg, u32 chan);
-	void (*init_rx_chan)(void __iomem *ioaddr,
+	void (*init_rx_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			     struct stmmac_dma_cfg *dma_cfg,
 			     dma_addr_t phy, u32 chan);
-	void (*init_tx_chan)(void __iomem *ioaddr,
+	void (*init_tx_chan)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			     struct stmmac_dma_cfg *dma_cfg,
 			     dma_addr_t phy, u32 chan);
 	/* Configure the AXI Bus Mode Register */
 	void (*axi)(void __iomem *ioaddr, struct stmmac_axi *axi);
 	/* Dump DMA registers */
-	void (*dump_regs)(void __iomem *ioaddr, u32 *reg_space);
-	void (*dma_rx_mode)(void __iomem *ioaddr, int mode, u32 channel,
-			    int fifosz, u8 qmode);
-	void (*dma_tx_mode)(void __iomem *ioaddr, int mode, u32 channel,
+	void (*dump_regs)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			  u32 *reg_space);
+	void (*dma_rx_mode)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    int mode, u32 channel,
 			    int fifosz, u8 qmode);
+	void (*dma_tx_mode)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    int mode, u32 channel, int fifosz, u8 qmode);
 	/* To track extra statistic (if supported) */
 	void (*dma_diagnostic_fr)(struct net_device_stats *stats,
 				  struct stmmac_extra_stats *x,
 				  void __iomem *ioaddr);
 	void (*enable_dma_transmission) (void __iomem *ioaddr);
-	void (*enable_dma_irq)(void __iomem *ioaddr, u32 chan,
-			       bool rx, bool tx);
-	void (*disable_dma_irq)(void __iomem *ioaddr, u32 chan,
-				bool rx, bool tx);
-	void (*start_tx)(void __iomem *ioaddr, u32 chan);
-	void (*stop_tx)(void __iomem *ioaddr, u32 chan);
-	void (*start_rx)(void __iomem *ioaddr, u32 chan);
-	void (*stop_rx)(void __iomem *ioaddr, u32 chan);
-	int (*dma_interrupt) (void __iomem *ioaddr,
-			      struct stmmac_extra_stats *x, u32 chan, u32 dir);
+	void (*enable_dma_irq)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			       u32 chan, bool rx, bool tx);
+	void (*disable_dma_irq)(struct stmmac_priv *priv, void __iomem *ioaddr,
+				u32 chan, bool rx, bool tx);
+	void (*start_tx)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan);
+	void (*stop_tx)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+	void (*start_rx)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			 u32 chan);
+	void (*stop_rx)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			u32 chan);
+	int (*dma_interrupt)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			     struct stmmac_extra_stats *x, u32 chan, u32 dir);
 	/* If supported then get the optional core features */
 	int (*get_hw_feature)(void __iomem *ioaddr,
 			      struct dma_features *dma_cap);
 	/* Program the HW RX Watchdog */
-	void (*rx_watchdog)(void __iomem *ioaddr, u32 riwt, u32 queue);
-	void (*set_tx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
-	void (*set_rx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
-	void (*set_rx_tail_ptr)(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
-	void (*set_tx_tail_ptr)(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
-	void (*enable_tso)(void __iomem *ioaddr, bool en, u32 chan);
-	void (*qmode)(void __iomem *ioaddr, u32 channel, u8 qmode);
-	void (*set_bfsize)(void __iomem *ioaddr, int bfsize, u32 chan);
-	void (*enable_sph)(void __iomem *ioaddr, bool en, u32 chan);
-	int (*enable_tbs)(void __iomem *ioaddr, bool en, u32 chan);
+	void (*rx_watchdog)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			    u32 riwt, u32 queue);
+	void (*set_tx_ring_len)(struct stmmac_priv *priv, void __iomem *ioaddr,
+				u32 len, u32 chan);
+	void (*set_rx_ring_len)(struct stmmac_priv *priv, void __iomem *ioaddr,
+				u32 len, u32 chan);
+	void (*set_rx_tail_ptr)(struct stmmac_priv *priv, void __iomem *ioaddr,
+				u32 tail_ptr, u32 chan);
+	void (*set_tx_tail_ptr)(struct stmmac_priv *priv, void __iomem *ioaddr,
+				u32 tail_ptr, u32 chan);
+	void (*enable_tso)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   bool en, u32 chan);
+	void (*qmode)(struct stmmac_priv *priv, void __iomem *ioaddr,
+		      u32 channel, u8 qmode);
+	void (*set_bfsize)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   int bfsize, u32 chan);
+	void (*enable_sph)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			   bool en, u32 chan);
+	int (*enable_tbs)(struct stmmac_priv *priv, void __iomem *ioaddr,
+			  bool en, u32 chan);
 };
 
 #define stmmac_dma_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, init_chan, __args)
+	stmmac_do_void_callback(__priv, dma, init_chan, __priv, __args)
 #define stmmac_init_rx_chan(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, init_rx_chan, __args)
+	stmmac_do_void_callback(__priv, dma, init_rx_chan, __priv, __args)
 #define stmmac_init_tx_chan(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, init_tx_chan, __args)
+	stmmac_do_void_callback(__priv, dma, init_tx_chan, __priv, __args)
 #define stmmac_axi(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, axi, __args)
 #define stmmac_dump_dma_regs(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, dump_regs, __args)
+	stmmac_do_void_callback(__priv, dma, dump_regs, __priv, __args)
 #define stmmac_dma_rx_mode(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, dma_rx_mode, __args)
+	stmmac_do_void_callback(__priv, dma, dma_rx_mode, __priv, __args)
 #define stmmac_dma_tx_mode(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, dma_tx_mode, __args)
+	stmmac_do_void_callback(__priv, dma, dma_tx_mode, __priv, __args)
 #define stmmac_dma_diagnostic_fr(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, dma_diagnostic_fr, __args)
 #define stmmac_enable_dma_transmission(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, enable_dma_transmission, __args)
 #define stmmac_enable_dma_irq(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, enable_dma_irq, __args)
+	stmmac_do_void_callback(__priv, dma, enable_dma_irq, __priv, __args)
 #define stmmac_disable_dma_irq(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, disable_dma_irq, __args)
+	stmmac_do_void_callback(__priv, dma, disable_dma_irq, __priv, __args)
 #define stmmac_start_tx(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, start_tx, __args)
+	stmmac_do_void_callback(__priv, dma, start_tx, __priv, __args)
 #define stmmac_stop_tx(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, stop_tx, __args)
+	stmmac_do_void_callback(__priv, dma, stop_tx, __priv, __args)
 #define stmmac_start_rx(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, start_rx, __args)
+	stmmac_do_void_callback(__priv, dma, start_rx, __priv, __args)
 #define stmmac_stop_rx(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, stop_rx, __args)
+	stmmac_do_void_callback(__priv, dma, stop_rx, __priv, __args)
 #define stmmac_dma_interrupt_status(__priv, __args...) \
-	stmmac_do_callback(__priv, dma, dma_interrupt, __args)
+	stmmac_do_callback(__priv, dma, dma_interrupt, __priv, __args)
 #define stmmac_get_hw_feature(__priv, __args...) \
 	stmmac_do_callback(__priv, dma, get_hw_feature, __args)
 #define stmmac_rx_watchdog(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, rx_watchdog, __args)
+	stmmac_do_void_callback(__priv, dma, rx_watchdog, __priv, __args)
 #define stmmac_set_tx_ring_len(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, set_tx_ring_len, __args)
+	stmmac_do_void_callback(__priv, dma, set_tx_ring_len, __priv, __args)
 #define stmmac_set_rx_ring_len(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, set_rx_ring_len, __args)
+	stmmac_do_void_callback(__priv, dma, set_rx_ring_len, __priv, __args)
 #define stmmac_set_rx_tail_ptr(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, set_rx_tail_ptr, __args)
+	stmmac_do_void_callback(__priv, dma, set_rx_tail_ptr, __priv, __args)
 #define stmmac_set_tx_tail_ptr(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, set_tx_tail_ptr, __args)
+	stmmac_do_void_callback(__priv, dma, set_tx_tail_ptr, __priv, __args)
 #define stmmac_enable_tso(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, enable_tso, __args)
+	stmmac_do_void_callback(__priv, dma, enable_tso, __priv, __args)
 #define stmmac_dma_qmode(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, qmode, __args)
+	stmmac_do_void_callback(__priv, dma, qmode, __priv, __args)
 #define stmmac_set_dma_bfsize(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, set_bfsize, __args)
+	stmmac_do_void_callback(__priv, dma, set_bfsize, __priv, __args)
 #define stmmac_enable_sph(__priv, __args...) \
-	stmmac_do_void_callback(__priv, dma, enable_sph, __args)
+	stmmac_do_void_callback(__priv, dma, enable_sph, __priv, __args)
 #define stmmac_enable_tbs(__priv, __args...) \
-	stmmac_do_callback(__priv, dma, enable_tbs, __args)
+	stmmac_do_callback(__priv, dma, enable_tbs, __priv, __args)
 
 struct mac_device_info;
 struct net_device;
@@ -305,21 +322,23 @@ struct stmmac_ops {
 	/* Program TX Algorithms */
 	void (*prog_mtl_tx_algorithms)(struct mac_device_info *hw, u32 tx_alg);
 	/* Set MTL TX queues weight */
-	void (*set_mtl_tx_queue_weight)(struct mac_device_info *hw,
+	void (*set_mtl_tx_queue_weight)(struct stmmac_priv *priv,
+					struct mac_device_info *hw,
 					u32 weight, u32 queue);
 	/* RX MTL queue to RX dma mapping */
 	void (*map_mtl_to_dma)(struct mac_device_info *hw, u32 queue, u32 chan);
 	/* Configure AV Algorithm */
-	void (*config_cbs)(struct mac_device_info *hw, u32 send_slope,
-			   u32 idle_slope, u32 high_credit, u32 low_credit,
-			   u32 queue);
+	void (*config_cbs)(struct stmmac_priv *priv, struct mac_device_info *hw,
+			   u32 send_slope, u32 idle_slope, u32 high_credit,
+			   u32 low_credit, u32 queue);
 	/* Dump MAC registers */
 	void (*dump_regs)(struct mac_device_info *hw, u32 *reg_space);
 	/* Handle extra events on specific interrupts hw dependent */
 	int (*host_irq_status)(struct mac_device_info *hw,
 			       struct stmmac_extra_stats *x);
 	/* Handle MTL interrupts */
-	int (*host_mtl_irq_status)(struct mac_device_info *hw, u32 chan);
+	int (*host_mtl_irq_status)(struct stmmac_priv *priv,
+				   struct mac_device_info *hw, u32 chan);
 	/* Multicast filter setting */
 	void (*set_filter)(struct mac_device_info *hw, struct net_device *dev);
 	/* Flow control setting */
@@ -339,8 +358,9 @@ struct stmmac_ops {
 	void (*set_eee_lpi_entry_timer)(struct mac_device_info *hw, int et);
 	void (*set_eee_timer)(struct mac_device_info *hw, int ls, int tw);
 	void (*set_eee_pls)(struct mac_device_info *hw, int link);
-	void (*debug)(void __iomem *ioaddr, struct stmmac_extra_stats *x,
-		      u32 rx_queues, u32 tx_queues);
+	void (*debug)(struct stmmac_priv *priv, void __iomem *ioaddr,
+		      struct stmmac_extra_stats *x, u32 rx_queues,
+		      u32 tx_queues);
 	/* PCS calls */
 	void (*pcs_ctrl_ane)(void __iomem *ioaddr, bool ane, bool srgmi_ral,
 			     bool loopback);
@@ -420,17 +440,17 @@ struct stmmac_ops {
 #define stmmac_prog_mtl_tx_algorithms(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, prog_mtl_tx_algorithms, __args)
 #define stmmac_set_mtl_tx_queue_weight(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, set_mtl_tx_queue_weight, __args)
+	stmmac_do_void_callback(__priv, mac, set_mtl_tx_queue_weight, __priv, __args)
 #define stmmac_map_mtl_to_dma(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, map_mtl_to_dma, __args)
 #define stmmac_config_cbs(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, config_cbs, __args)
+	stmmac_do_void_callback(__priv, mac, config_cbs, __priv, __args)
 #define stmmac_dump_mac_regs(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, dump_regs, __args)
 #define stmmac_host_irq_status(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, host_irq_status, __args)
 #define stmmac_host_mtl_irq_status(__priv, __args...) \
-	stmmac_do_callback(__priv, mac, host_mtl_irq_status, __args)
+	stmmac_do_callback(__priv, mac, host_mtl_irq_status, __priv, __args)
 #define stmmac_set_filter(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_filter, __args)
 #define stmmac_flow_ctrl(__priv, __args...) \
@@ -452,11 +472,11 @@ struct stmmac_ops {
 #define stmmac_set_eee_pls(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_eee_pls, __args)
 #define stmmac_mac_debug(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, debug, __args)
+	stmmac_do_void_callback(__priv, mac, debug, __priv, __args)
 #define stmmac_pcs_ctrl_ane(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, pcs_ctrl_ane, __args)
 #define stmmac_pcs_rane(__priv, __args...) \
-	stmmac_do_void_callback(__priv, mac, pcs_rane, __args)
+	stmmac_do_void_callback(__priv, mac, pcs_rane, __priv, __args)
 #define stmmac_pcs_get_adv_lp(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, pcs_get_adv_lp, __args)
 #define stmmac_safety_feat_config(__priv, __args...) \
@@ -504,8 +524,6 @@ struct stmmac_ops {
 #define stmmac_fpe_irq_status(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, fpe_irq_status, __args)
 
-struct stmmac_priv;
-
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
 	void (*config_hw_tstamping) (void __iomem *ioaddr, u32 data);
-- 
2.39.2

