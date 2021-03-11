Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2AC336A0C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhCKCMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhCKCLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:11:40 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D820C061574;
        Wed, 10 Mar 2021 18:11:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u18so9437636plc.12;
        Wed, 10 Mar 2021 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B3NvjxFQkBW7qiD7WXidQCqOgaMtOHmNc5t+RjW8jYs=;
        b=Ag4U2H/cx+7yWjZGqdF8jnN9Ftc1pFYjhKg1Qw/pfE+4UNlElJXTGt+DRYq5/fLFcf
         4ihweh8lj8HfxiisnOoSxxoIio7jJX9I2f3X9SVyKbILLCPRzbVGzxDXjcZsbELf4xVB
         lRvDAbE6Z12HPMYC1h+p2qvPAU1vTXFHbRn2mVkkm+WI2Q7lS45WcUQ6YwhofEtXKGkB
         ZSrUAj8Jk2C12+mZyhZHZF4oRkdrc7rHgRDmG0+Qge+kCeou2tb+ZuzUgAUz+Xc6ejHW
         T+IU2eBT8bjy+9cpBIgrxWSXPM5bkWXaQ4vZppl58LNITAeZvnWoAeWuCW3QDMtNP4ex
         p77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3NvjxFQkBW7qiD7WXidQCqOgaMtOHmNc5t+RjW8jYs=;
        b=s0/YdcmEQl602VGdYGqKzT/8aVt5j9fXQ/1vey1qhld6cThdtfyitM8zHuYIFyg04a
         0DQ+/h74CweJA6qW2cwlQQwJFkmCOqN0eRKCZfNAlcWxRnd/wJvTrNeX2KEmuZSEtet+
         e0BEfGG68KW3M9S2x2vavVdRwMQivzn3ST/niB6fVT5WZgG33JnE7Qc2lAWvZ2SIlOXK
         Rxlvh0k2339tX2lLSnP8TiaAXWCG/hFWrHcbMkxEQS+4eCZqZZ/DNMnf49Uu+fNAUxrt
         bX8hci7xEH/LfA5GmfF/nq+BFxtQqb1s6a1i/CiomP42ditGJwdZWY8oIfHvEFgUKy8U
         oZSA==
X-Gm-Message-State: AOAM532EjrrlCBOAfoGXAnRjXtST3yS+dPWOWrC9cOykoxn7JHYGf/Oc
        pg4Ib38TcxPotsfH7g7FEQg=
X-Google-Smtp-Source: ABdhPJypqyrbNio+ygSelexHSUtxznF8mzVzEBNNmvXV5kFlJJk14K7c2oLyfeZUSoVWv9YhxHNb/Q==
X-Received: by 2002:a17:90a:c84:: with SMTP id v4mr6627560pja.228.1615428699863;
        Wed, 10 Mar 2021 18:11:39 -0800 (PST)
Received: from z640-arch.lan ([2602:61:738f:1000::678])
        by smtp.gmail.com with ESMTPSA id p190sm672603pga.78.2021.03.10.18.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 18:11:39 -0800 (PST)
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
Subject: [PATCH net-next,v2 2/3] net: dsa: mt7530: clean up redundant clock enables
Date:   Wed, 10 Mar 2021 18:09:53 -0800
Message-Id: <20210311020954.842341-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
References: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two minor changes:

- In RGMII mode, the REG_GSWCK_EN bit of CORE_TRGMII_GSW_CLK_CG gets
  set three times in a row. In TRGMII mode, two times. Simplify the code
  and only set it once for both modes.

- When disabling PLL, there is no need to call core_write_mmd_indirect
  directly, use the core_write wrapper instead like the rest of the code
  in the function does. This change helps with consistency and
  readability.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9871d7cff93a..80a35caf920e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -444,10 +444,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	 * provide our own core_write_mmd_indirect to complete this
 	 * function.
 	 */
-	core_write_mmd_indirect(priv,
-				CORE_GSWPLL_GRP1,
-				MDIO_MMD_VEND2,
-				0);
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
 	/* Set core clock into 500Mhz */
 	core_write(priv, CORE_GSWPLL_GRP2,
@@ -460,11 +457,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
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
@@ -478,6 +471,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_write(priv, CORE_PLL_GROUP7,
 		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+	/* Enable MT7530 core and TRGMII Tx clocks */
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
 		 REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-- 
2.30.2

