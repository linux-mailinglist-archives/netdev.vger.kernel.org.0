Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828505A02D7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiHXUfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiHXUfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:35:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4291C1A06C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:34:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u14so22139494wrq.9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=POi4hFc+gT1EkX4nPsQgNWfQX18l5gCV7T3rOCIonGM=;
        b=FZ+Xf1MRzXvpmhNHqPc2EePKUbklI/0FZjUYDen+1mw5aNhAu/hpI2e8k2vh0TG8IY
         99/skphyC+XLZ0YaeZt7yfVhMMiu8+VkrUd8rEeRwtMloH6C7Zik2h6R1ZCQjnKLLxiU
         mkY98XkjXamZiLpQ8S5z4opJT1BtcSJfwXZEWR6Hu8FszhwlKH9ES1lIXKn8WEyhIKC5
         PF9+F13olVYZy3zFTe8KI1232uAfkovKKKxpGGszEsqJy1VCvWYiY59I9ECTQCgNwJIE
         fLmoapu/GeqmOBqJrv3oaDz6S16DPH7JqSIx9AxKvD+Z6Sg0C4Js2nIcv81lJIBeKqJ6
         mFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=POi4hFc+gT1EkX4nPsQgNWfQX18l5gCV7T3rOCIonGM=;
        b=376m/fT0PzhZJZK3QTSRHL7UIcEmjRl60xitd+AGmfYmI9FtDvUEqvEHMYeGQywqTL
         D7Ai1Dnj0xsHYSRP5glh+0JjZgOOp9jf7FviEEQbs+c9qoyHF7ageC8pBjXEV8RsCuNO
         LmlpUVZHSxYe7giCapc2jxi/WQULhK27aL2x+NKGyEIpYrA7KDKIlFNyNNdxjwdeepnx
         tCQm3qhpqX60V3Tz2dtQn+mFG/HeIX0xHKi7w4+162Fn6oH4hzrvO8B2E2IW8Ig7a2tb
         J9nDfXjUxysr+ERpYewefVegU8IhbQZdG5Y6ywp2WEEQTX9DA4mWYGC0OqeYWDd6at2U
         fjQg==
X-Gm-Message-State: ACgBeo0s2+GSJrXG7w+Uipgn++B+2tJffSwxs5k1y8DxoECreYtf7k/9
        mluA7VUa+BaTIsaksW8o4ig=
X-Google-Smtp-Source: AA6agR7/fqfPu8mLXwbFrXsWyggUliREN5FH5jjzxB3kXibRHkWwoPpvxXHT0f+TYoAHRZIdcBdOQw==
X-Received: by 2002:adf:f74b:0:b0:225:1fdb:a787 with SMTP id z11-20020adff74b000000b002251fdba787mr464018wrp.33.1661373297511;
        Wed, 24 Aug 2022 13:34:57 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7aa2:100:8857:e17a:56:c2b2? (dynamic-2a01-0c22-7aa2-0100-8857-e17a-0056-c2b2.c22.pool.telefonica.de. [2a01:c22:7aa2:100:8857:e17a:56:c2b2])
        by smtp.googlemail.com with ESMTPSA id k6-20020a5d6d46000000b00225221fd286sm17844759wri.114.2022.08.24.13.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 13:34:56 -0700 (PDT)
Message-ID: <e99857ce-bd90-5093-ca8c-8cd480b5a0a2@gmail.com>
Date:   Wed, 24 Aug 2022 22:34:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Qi Duan <qi.duan@amlogic.com>, Da Xue <da@lessconfused.com>,
        Jerome Brunet <jbrunet@baylibre.com>, rayagond@vayavyalabs.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Language: en-US
Subject: [PATCH v2 net] net: stmmac: work around sporadic tx issue on link-up
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up to the discussion in [0]. It seems to me that
at least the IP version used on Amlogic SoC's sometimes has a problem
if register MAC_CTRL_REG is written whilst the chip is still processing
a previous write. But that's just a guess.
Adding a delay between two writes to this register helps, but we can
also simply omit the offending second write. This patch uses the second
approach and is based on a suggestion from Qi Duan.
Benefit of this approach is that we can save few register writes, also
on not affected chip versions.

[0] https://www.spinics.net/lists/netdev/msg831526.html

v2:
- change Fixes tag to the commmit that added stmmac_set_mac() 11yrs ago

Fixes: bfab27a146ed ("stmmac: add the experimental PCI support")
Suggested-by: Qi Duan <qi.duan@amlogic.com>
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c   | 8 ++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index caa4bfc4c..9b6138b11 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -258,14 +258,18 @@ EXPORT_SYMBOL_GPL(stmmac_set_mac_addr);
 /* Enable disable MAC RX/TX */
 void stmmac_set_mac(void __iomem *ioaddr, bool enable)
 {
-	u32 value = readl(ioaddr + MAC_CTRL_REG);
+	u32 old_val, value;
+
+	old_val = readl(ioaddr + MAC_CTRL_REG);
+	value = old_val;
 
 	if (enable)
 		value |= MAC_ENABLE_RX | MAC_ENABLE_TX;
 	else
 		value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
 
-	writel(value, ioaddr + MAC_CTRL_REG);
+	if (value != old_val)
+		writel(value, ioaddr + MAC_CTRL_REG);
 }
 
 void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 070b5ef16..592d29abc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -986,10 +986,10 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 			       bool tx_pause, bool rx_pause)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-	u32 ctrl;
+	u32 old_ctrl, ctrl;
 
-	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
-	ctrl &= ~priv->hw->link.speed_mask;
+	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII) {
 		switch (speed) {
@@ -1064,7 +1064,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (tx_pause && rx_pause)
 		stmmac_mac_flow_ctrl(priv, duplex);
 
-	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+	if (ctrl != old_ctrl)
+		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-- 
2.37.2

