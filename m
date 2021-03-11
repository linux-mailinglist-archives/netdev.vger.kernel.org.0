Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A48336A0D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCKCMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhCKCLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:11:39 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42FC061762;
        Wed, 10 Mar 2021 18:11:39 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d23so6246423plq.2;
        Wed, 10 Mar 2021 18:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=tVjmXz8D0DjaTjmoWHqistDrym+xbYTnEJwbOaaa4yZ1NOFOvMdMzWtNc9TMAA/O0B
         zcQi5pgNIF7Fogaq3ReeNE6T9ZdXBzO+0MER/mX5knRuCCxqTjVeuCCONRQqtrnDx1hc
         mfGPZZJVpmR7eF6jRRYPB090LmBGJPlnUqeF1uu+L5uBDe5l1BulZJpcmvpbvHMCMZnJ
         tNJsB8TteEWRJgX0EW631qHAfg1o72qZWlEzqW8yAMei17a6bf1AYnNYPczPAmZh3LOb
         i1FlLZgigsiVCar4a7KETtiqFzD399/pmxUT5LPf8fbICSqSGcal+usmRD98NzJJPkMV
         c1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=te3KkZ/7y8l0N1gnz9fMIpGsfWHYXiKPURp+vcWCB8E=;
        b=jBZ4C8yDNdvFP+z2m4+7FcAhc966ekZ2sfBYmWmTS9i5pm12pfrZMeABrTVbUtZJf5
         8JsJ02OQdqH2SVY0upb2jMV4BJGcEppOBx2N7D1Guczbx6RviiDIVR7T6j2gaGpDPphV
         yC66mOZeNv2MzB1hfgOMmK7SJqJXCNs6kslVVMZMoHrIw4dC/0y0yEIPe7egviKM5VCi
         EA4hwk9J4lzr5Koe0yGcZnWTcXDzglRzdphpG91FEftkwQRy8fIPeizJh5BbCbTaTmGz
         fFlIm4sHs4mUtDpjqbZM6IMKv4jvA5mPBPr5iQ0MBhhGpQokOmLsEDav20xuzrR/rY4i
         TgkA==
X-Gm-Message-State: AOAM530B41Y7Obue4l6uW/OKF/So7huhCF+w4Cu/pisD+SqIyW289SCp
        EbTMfosTiOeUjhYdYbfDHTWlVwrnSatPPXOa
X-Google-Smtp-Source: ABdhPJzbEp3URJUAJUmTC9QVWB1XRmvmvC/eT7dP/QVWbmPd5x+UG2+7fDGLo72jWAOVPTg54utsBA==
X-Received: by 2002:a17:902:10a:b029:e2:e8f7:2988 with SMTP id 10-20020a170902010ab02900e2e8f72988mr5733060plb.4.1615428699155;
        Wed, 10 Mar 2021 18:11:39 -0800 (PST)
Received: from z640-arch.lan ([2602:61:738f:1000::678])
        by smtp.gmail.com with ESMTPSA id p190sm672603pga.78.2021.03.10.18.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 18:11:38 -0800 (PST)
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
Subject: [PATCH net-next,v2 1/3] net: dsa: mt7530: setup core clock even in TRGMII mode
Date:   Wed, 10 Mar 2021 18:09:52 -0800
Message-Id: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
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

