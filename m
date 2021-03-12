Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772B4338714
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhCLIIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhCLIHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:07:37 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5328C061574;
        Fri, 12 Mar 2021 00:07:36 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id w34so14291649pga.8;
        Fri, 12 Mar 2021 00:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=FihTQ2zVIfHyWNyLkfgjwMHDyPxCwUHIqC185KqAZJEdBqYjqLCb1Q/l5CK+41xDCf
         AiNkLws86GhP4FP3Acc+xWa2+xXBenk6JZEsb9HbOcvdBcQgDSA8p3761b2pPRUhWgr+
         nSLqprGw/+owuMqtBkPCiyjVGpguvMpen4mGlBbsGw4Yi/Crvuk+MzVCI00GfuWX1afu
         ddFffOoJ06oXlfWpzRaLscR00h9VQdXQX3fEO9OMwiUs/wn+0XOmsjkd8FaljK1lpRVw
         de2s8KqSdI1oMi52qdtFwwZRqieQZlojKTfkotKkvXutErd8kzYiMMrJqPic7grk6wkL
         z4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=uMn0gFTD64Dxn0pLJb9cp6TmWpvDpxP8TrqfGXTfoEzaVl3Z5eS5jJJ0IgIun3B3ni
         qph2mKNFRUBWAyclcVtL1RttpvvvvyUrDll5JsaIWehDtGHu8Xv5ddHeoneg+bqwL6Ol
         bwdRZqw1I7i/QMy39YvNNgHpjy/1bRb1VIetScFnFyCeDBDkyTHU/BTopCllfvgmfFZt
         a6XPOqjLdMDI+c2EsZApYvfijtUyXKOqJq896BOSTLzV7G7Cdu5PGwG9fEJrDiSuyNrs
         gYFvOX2vhnwKPwMcU2mKdBh/+25OnBdTmpU49yL0J54DuD+NWlONs+cNo+QwR5vaoHhb
         Gfiw==
X-Gm-Message-State: AOAM533SGVNtK/8Ga9fOonXj70NfVswKo5S0khd5qpPJTtKDo3GTk93t
        9GGhX422yP1ehaecrz4a3xY=
X-Google-Smtp-Source: ABdhPJyAJm82NZ7DHwzELUMbIN2BgR52bHmEYM8VjrfkOBKeQ1wmBxxKrehZJ/MjRIv0iXyZEAOymg==
X-Received: by 2002:a63:3544:: with SMTP id c65mr10768213pga.284.1615536456233;
        Fri, 12 Mar 2021 00:07:36 -0800 (PST)
Received: from z640-arch.lan ([2602:61:738f:1000::678])
        by smtp.gmail.com with ESMTPSA id h5sm4459973pgv.87.2021.03.12.00.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 00:07:35 -0800 (PST)
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        sander@svanheule.net, tsbogend@alpha.franken.de, john@phrozen.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net,v2] net: dsa: mt7530: setup core clock even in TRGMII mode
Date:   Fri, 12 Mar 2021 00:07:03 -0800
Message-Id: <20210312080703.63281-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
References: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change to MIPS ralink reset logic made it so mt7530 actually
resets the switch on platforms such as mt7621 (where bit 2 is the reset
line for the switch). That exposed an issue where the switch would not
function properly in TRGMII mode after a reset.

Reconfigure core clock in TRGMII mode to fix the issue.

Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.

Fixes: 3f9ef7785a9c ("MIPS: ralink: manage low reset lines")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 52 +++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f06f5fa2f898..9871d7cff93a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -436,34 +436,32 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
 	/* Setup core clock for MT7530 */
-	if (!trgint) {
-		/* Disable MT7530 core clock */
-		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-
-		/* Disable PLL, since phy_device has not yet been created
-		 * provided for phy_[read,write]_mmd_indirect is called, we
-		 * provide our own core_write_mmd_indirect to complete this
-		 * function.
-		 */
-		core_write_mmd_indirect(priv,
-					CORE_GSWPLL_GRP1,
-					MDIO_MMD_VEND2,
-					0);
-
-		/* Set core clock into 500Mhz */
-		core_write(priv, CORE_GSWPLL_GRP2,
-			   RG_GSWPLL_POSDIV_500M(1) |
-			   RG_GSWPLL_FBKDIV_500M(25));
+	/* Disable MT7530 core clock */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 
-		/* Enable PLL */
-		core_write(priv, CORE_GSWPLL_GRP1,
-			   RG_GSWPLL_EN_PRE |
-			   RG_GSWPLL_POSDIV_200M(2) |
-			   RG_GSWPLL_FBKDIV_200M(32));
-
-		/* Enable MT7530 core clock */
-		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-	}
+	/* Disable PLL, since phy_device has not yet been created
+	 * provided for phy_[read,write]_mmd_indirect is called, we
+	 * provide our own core_write_mmd_indirect to complete this
+	 * function.
+	 */
+	core_write_mmd_indirect(priv,
+				CORE_GSWPLL_GRP1,
+				MDIO_MMD_VEND2,
+				0);
+
+	/* Set core clock into 500Mhz */
+	core_write(priv, CORE_GSWPLL_GRP2,
+		   RG_GSWPLL_POSDIV_500M(1) |
+		   RG_GSWPLL_FBKDIV_500M(25));
+
+	/* Enable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1,
+		   RG_GSWPLL_EN_PRE |
+		   RG_GSWPLL_POSDIV_200M(2) |
+		   RG_GSWPLL_FBKDIV_200M(32));
+
+	/* Enable MT7530 core clock */
+	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-- 
2.30.2

