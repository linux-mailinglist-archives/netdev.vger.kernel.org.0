Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81283349B8
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhCJVOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhCJVO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:14:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260B3C061574;
        Wed, 10 Mar 2021 13:14:29 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so7944733pjh.1;
        Wed, 10 Mar 2021 13:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+v6qAt05GB3pyWDepiyyyWC9bZx8wHfiUnSye/9786g=;
        b=Bfqtm0qvVc7TNTh3q4/EWyuJxpXX1jie2lxkaJCEITbnbLyk0BhgBkeuSK8vlurR3I
         tHGC2RErjqD8Us9Bkr/Oy5IwY/9UbbTnbCJNyit/Z2EFVhC9DrB1yUtiZj8oN6U7R093
         RfQEKm6ske5N6nQN3d35cJcADPN2pmjnYHYQMxea6SB80bI5w1wTZGPvNaHHjOyW3TL4
         K29LwBcVT1BvpysQmbya22RNFNTMpAbOuwb6elDvr6QK4EuudQ6Y2nwpeDUC6rJ4kngV
         yMuvwW5/lxRwCHbHlceUYpFBgVTgH7xDbMAJi+D7Pybpef7uE42zewEDfeAX4MV93Wh9
         eSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v6qAt05GB3pyWDepiyyyWC9bZx8wHfiUnSye/9786g=;
        b=Nw+X7P9RLENEoeOhfnWOEWIz6yFNnbAN0bWYw9jxFfESm1OpX9SjenHb67anG9lTUx
         nQl3TaV+s101Lvyw7w0Ve5rbSf2gZWJ6ZvWclWXhF5Z35ENp2xvYwJCHCGk9a96HUa0C
         yLJah7V6wCDkIiQq/lY0Tmz1WPrSPG8rINY+UiHIDkMqkCH1FGJeD5/jIr8c8XwDxtng
         LkbGcBWj1VeFmFasrOzqeJnX7vKlhs1QPGUib2cpqsOZeg0Ad4IUlviYGDs6Va5T8iwk
         WNu38hflniVgqLbKBg9LvVq4YWLr9yJ6GHMycWMmFBK2z/JF4OUnmbMqVZjbXm6m1vrm
         CYmg==
X-Gm-Message-State: AOAM530z/TEo7lWL/NR361f2jr7YPjXCd/koGduP9tyP4l7mGUGc0nFg
        eTkAfwefCSGEZ5Pj8g1wX+s=
X-Google-Smtp-Source: ABdhPJzQXy7sfY96AqR6uwF3anxp4aOhTVgA5r50zW/IN+aChTsFBaAEqBcwxyoybmQBG0s5wUTYQw==
X-Received: by 2002:a17:90a:7182:: with SMTP id i2mr5360459pjk.111.1615410868697;
        Wed, 10 Mar 2021 13:14:28 -0800 (PST)
Received: from ilya-fury.lan ([2602:61:738f:1000::b87])
        by smtp.gmail.com with ESMTPSA id 35sm412090pgr.14.2021.03.10.13.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 13:14:27 -0800 (PST)
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
Subject: [PATCH 3/3] net: dsa: mt7530: setup core clock even in TRGMII mode
Date:   Wed, 10 Mar 2021 13:14:20 -0800
Message-Id: <20210310211420.649985-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3f9ef7785a9c ("MIPS: ralink: manage low reset lines") made it so mt7530
actually resets the switch on platforms such as mt7621 (where bit 2 is
the reset line for the switch). That exposed an issue where the switch
would not function properly in TRGMII mode after a reset.

Reconfigure core clock in TRGMII mode to fix the issue.

Also, disable both core and TRGMII Tx clocks prior to reconfiguring.
Previously, only the core clock was disabled, but not TRGMII Tx clock.

Tested on Ubiquity ER-X (MT7621) with TRGMII mode enabled.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 44 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b106ea816778..7ef5e7c23e05 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -435,30 +435,30 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	/* Setup core clock for MT7530 */
-	if (!trgint) {
-		/* Disable MT7530 core clock */
-		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-
-		/* Disable PLL, since phy_device has not yet been created
-		 * provided for phy_[read,write]_mmd_indirect is called, we
-		 * provide our own core_write_mmd_indirect to complete this
-		 * function.
-		 */
-		core_write(priv, CORE_GSWPLL_GRP1, 0);
-
-		/* Set core clock into 500Mhz */
-		core_write(priv, CORE_GSWPLL_GRP2,
-			   RG_GSWPLL_POSDIV_500M(1) |
-			   RG_GSWPLL_FBKDIV_500M(25));
+	/* Since phy_device has not yet been created and
+	 * phy_[read,write]_mmd_indirect is not available, we provide our own
+	 * core_write_mmd_indirect with core_{clear,write,set} wrappers to
+	 * complete this function.
+	 */
 
-		/* Enable PLL */
-		core_write(priv, CORE_GSWPLL_GRP1,
-			   RG_GSWPLL_EN_PRE |
-			   RG_GSWPLL_POSDIV_200M(2) |
-			   RG_GSWPLL_FBKDIV_200M(32));
+	/* Disable MT7530 core and TRGMII Tx clocks */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	}
+	/* Setup core clock for MT7530 */
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
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
 
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
-- 
2.30.1

