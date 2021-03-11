Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D8B336991
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCKBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhCKBVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:21:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C3FC061574;
        Wed, 10 Mar 2021 17:21:10 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n9so11638027pgi.7;
        Wed, 10 Mar 2021 17:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=Au+RBIDSlz3wCuB/gOx33O1w5AROEEMoqV2WiwYIkaqfiSq5If3GPNfTo4eKol3JQ4
         Eml/1T0KBGaXSkuPgFUmVompKUMjCZcjkA5FbWidBCi2qGUpae5SYoxAo/lGyrO/0OaB
         7CiWJw6z8ttZuazqW32CJ9OifmAson1OXihNyRbijeKyHXSjiguefsl4DjJocHNr3LgO
         zLY+oXDx1E0VFOLORK2ljBX/5s66zo1Wn2o29peHdEr6+pedp7ldmPgrsjPmj6AVfuVG
         c6ZEXgCDW9AGspuGz/YfpjcauGdltXbLLLjFvBW7fU9CBfc/CjEk9N11G8wK3qv/P/zC
         bk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=CuPnNRZQEf1H9w1CUbZLDCGf1scFM69M+zY4U0DzP2HQCDN2JUJ7LpcMWJ6mRP31lO
         jTSem1Q4ktRwc7cdC6YkdF4qekIYFnDpZCWeXhOXq7RM5GOsrEO83FGQyiXHckWLs/B6
         tZs79Wp0Jz2dw+1HHZLP8xNVxiyf2PWrMrqQyLOs6VDMZfVlDptRs3Uvn3C91lIzkKZ1
         UjuTt85yGXgAcamb2Up+IG5tNp+JIadBPb/Ip3au4xszCemM/jbsCo3uFqk4TJOCrnsX
         VvZ/bXxV/Z5dYBBTWD+JgDZ4YBHWmMyVC4eHePxzEXHv4yGoQQi3Kb3pa33AjIn2ue1i
         z1Cw==
X-Gm-Message-State: AOAM533uzLfCNObkGiIb4qfs6DK2YBYuzV5aTM4331zNN/et+T941CUF
        A3BBpUWqxUHVQXR6Iq7Wuv8=
X-Google-Smtp-Source: ABdhPJzfCTM0tCmlERAEvAYmQCorqH4rabL9SlWfRvF5lqGrcyno8QV1gtoYRxQjOM8CF4PXaClBkQ==
X-Received: by 2002:aa7:8286:0:b029:1e2:70ef:c410 with SMTP id s6-20020aa782860000b02901e270efc410mr5058738pfm.45.1615425670189;
        Wed, 10 Mar 2021 17:21:10 -0800 (PST)
Received: from z640-arch.lan ([2602:61:738f:1000::678])
        by smtp.gmail.com with ESMTPSA id g7sm595470pgb.10.2021.03.10.17.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:21:09 -0800 (PST)
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
Subject: [PATCH net] net: dsa: mt7530: setup core clock even in TRGMII mode
Date:   Wed, 10 Mar 2021 17:21:08 -0800
Message-Id: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.2
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

