Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC034B49E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 07:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhC0GI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 02:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhC0GHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 02:07:55 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557D3C0613AA;
        Fri, 26 Mar 2021 23:07:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m11so6286264pfc.11;
        Fri, 26 Mar 2021 23:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OWHAq67WtUfBkQ1gKa/GLNLXtx3wsfXb42bm9Q2dUIw=;
        b=iGuCDDCCSLzOJZLkvL8FKN4srNRaWpeJyzWh7IENO1Xsp+p/LRBaduih39M/eI9w9D
         jFZMX9TC3yRplCoXiF0SQP9k2SPPViJisj5t8zuald885Ud4leRTx7GB/D40EHN7K8Ya
         T/ArbEyPE+FwqKOT4/zlmwY4VnJeQLUR7mpW15VM3zShCYKUQVzjVtJTyu7rcuhMYD7n
         oHbpwW+pPXq8efGfd9lgwx7V0ZrUYW9U1WsJiyLWy9l+AFK48CGACPcsl7StAcv0zMpl
         7qTxYBeO6R4Tnq4wmDhe/Fj/2Tm2HTrlOTtqnjr3Hmk3mK3HxEK4wpyKfV7ia+sDqL2f
         SDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OWHAq67WtUfBkQ1gKa/GLNLXtx3wsfXb42bm9Q2dUIw=;
        b=AcaeFVnkoIH8JdJGrr/h1k5pQTzGPoZNHjSgckAOEYXYt8cX6TU5WJjYCGBr2XeeEX
         oRxar9iAMjLGe5rLK9zp7uBPr0osAIizc+RWa900UxE1PE2YHus3RNM3CKWk1XKOTnn+
         q3xkgoJvb7sNNfGE8fALisM9qG5AZMZMDuaf3xAuPo1jcGOGWoGppeU2YR7XP77RIGpO
         5QUKr0HuXyO72dSXp4Zc5aCaRPBPDpb1DEqbmAdOKoKjWEVZnQH+KUyErInLK61F+fWJ
         6vNKA1HVbK/0n0+UTee6Z74sAhq9y10+DvLM94jlO14suzoUwMr0KzMyDp47f8aHWyly
         xXog==
X-Gm-Message-State: AOAM531NB4CzpiscUfvXV7ZxxtFbydKFe0lUstjO4xNnUJQAlkGZdeqL
        lunwkSs8yyioErALqp3KWkY=
X-Google-Smtp-Source: ABdhPJzS/Xl8JjciKMul/Yyn/G/TvKxIhsFlJU+pjB6636PT98PdIqvft5Tgm9PrUsIMyu69HChUtQ==
X-Received: by 2002:a63:525c:: with SMTP id s28mr15118967pgl.317.1616825274706;
        Fri, 26 Mar 2021 23:07:54 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id e131sm11531843pfh.176.2021.03.26.23.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 23:07:54 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next,v2] net: dsa: mt7530: clean up core and TRGMII clock setup
Date:   Fri, 26 Mar 2021 23:07:52 -0700
Message-Id: <20210327060752.474627-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210327055543.473099-1-ilya.lipnitskiy@gmail.com>
References: <20210327055543.473099-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three minor changes:

- When disabling PLL, there is no need to call core_write_mmd_indirect
  directly, use the core_write wrapper instead like the rest of the code
  in the function does. This change helps with consistency and
  readability. Move the comment to the definition of
  core_read_mmd_indirect where it belongs.

- Disable both core and TRGMII Tx clocks prior to reconfiguring.
  Previously, only the core clock was disabled, but not TRGMII Tx clock.
  So disable both, then configure them, then re-enable both, for
  consistency.

- The core clock enable bit (REG_GSWCK_EN) is written redundantly three
  times. Simplify the code and only write the register only once at the
  end of clock reconfiguration to enable both core and TRGMII Tx clocks.

Tested on Ubiquiti ER-X running the GMAC0 and MT7530 in TRGMII mode.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c442a5885fca..2bd1bab71497 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -67,6 +67,11 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(1, 0xb8, "RxArlDrop"),
 };
 
+/* Since phy_device has not yet been created and
+ * phy_{read,write}_mmd_indirect is not available, we provide our own
+ * core_{read,write}_mmd_indirect with core_{clear,write,set} wrappers
+ * to complete this function.
+ */
 static int
 core_read_mmd_indirect(struct mt7530_priv *priv, int prtad, int devad)
 {
@@ -435,19 +440,13 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	/* Setup core clock for MT7530 */
-	/* Disable MT7530 core clock */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
+	/* Disable MT7530 core and TRGMII Tx clocks */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Disable PLL, since phy_device has not yet been created
-	 * provided for phy_[read,write]_mmd_indirect is called, we
-	 * provide our own core_write_mmd_indirect to complete this
-	 * function.
-	 */
-	core_write_mmd_indirect(priv,
-				CORE_GSWPLL_GRP1,
-				MDIO_MMD_VEND2,
-				0);
+	/* Setup core clock for MT7530 */
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
 	/* Set core clock into 500Mhz */
 	core_write(priv, CORE_GSWPLL_GRP2,
@@ -460,11 +459,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		   RG_GSWPLL_POSDIV_200M(2) |
 		   RG_GSWPLL_FBKDIV_200M(32));
 
-	/* Enable MT7530 core clock */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-
 	/* Setup the MT7530 TRGMII Tx Clock */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
 	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
@@ -478,6 +473,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_write(priv, CORE_PLL_GROUP7,
 		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+	/* Enable MT7530 core and TRGMII Tx clocks */
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
 		 REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-- 
2.31.0

