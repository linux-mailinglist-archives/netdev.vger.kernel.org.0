Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B96B376B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjCJHd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCJHdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:33:49 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C16DDF3D;
        Thu,  9 Mar 2023 23:33:47 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so5306733wms.2;
        Thu, 09 Mar 2023 23:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678433626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1qQOPUYZltp62usDX13u0lfSl6bY/5+CW4Brvbfffs=;
        b=qGCFeI2uqTNIpuk4x4yI01LMktwcIsPFqS6d7dSQ61jZXyA0sm5CKaie+4FhNm8xig
         guwmjxnV/UyBRNKxExDQZ7e7+WrHvR7BDnlzrI0BpqXkCeE2UYwV7zvkV8zDXTf3bMQF
         6o1OzgUtsGCuFm25+oaHLGwLclmGjSGTK8Q83uOeGK8R6/2Dx4Zy0sezKPjBlyBT63jG
         lGAq5gxKDe5ZAIcviO1IXpfj97Q9DyOkvY9/lbIkLaHYODABPpkj631SZLGh31D603UT
         7WkoTraZV7kSTsfjhsWUa5o0QtA+GHRw/9icYx7mzC7BslR/A3bDermFZ9abXMSewRz6
         oTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678433626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1qQOPUYZltp62usDX13u0lfSl6bY/5+CW4Brvbfffs=;
        b=27ysCY1t/tpvbTfIl2hc+c3hhcDJG7uCY0DKEviY62o1ryPkO47OEHxsoshA7Rrh/2
         AZ5276+MpzhlRZhil0p0BSRXHsvXV6BcPsIcYqkE9IOK2cLW3W+/VtKFCcmtjUgYjZGU
         RqlZMas4ojki8Y21ZnjNA9eL+QVGLd93IiNmtp7lR1tqbjpXR6wLUyCCBT2QYl/RBHBC
         6I4PIBgyT5Bdv8lPICynDSPOO8H7K1/qTOoHr4QCenAjFW0SfADQVVPYApp2CarE+1P0
         KzCtOEFRrxYSHNP6foDc86iJ7Aj+5FNaPkVTmhGeeXXhX5wFn4P8v5Q6G4lClz2b4lKD
         oIqw==
X-Gm-Message-State: AO0yUKUgXxnLPu/lkIuSRhaC0Ai0LwLrRqZJSB/Dvg17nzsDDnB8ZXld
        CaYhbcSKkmB+liVNNVlAFyc=
X-Google-Smtp-Source: AK7set++j3HjZjV2R6SCTjuiZsJUwAPEIbbQJZLscHhcR/855Ychfiok3Wx21zhrfFuBw8+bVXZhcg==
X-Received: by 2002:a05:600c:474d:b0:3eb:39e2:915b with SMTP id w13-20020a05600c474d00b003eb39e2915bmr1654219wmo.31.1678433626057;
        Thu, 09 Mar 2023 23:33:46 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b003daffc2ecdesm2023129wmb.13.2023.03.09.23.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 23:33:45 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, erkin.bozoglu@xeront.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 net 2/2] net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used
Date:   Fri, 10 Mar 2023 10:33:38 +0300
Message-Id: <20230310073338.5836-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230310073338.5836-1-arinc.unal@arinc9.com>
References: <20230310073338.5836-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

As my testing on the MCM MT7530 switch on MT7621 SoC shows, setting the PLL
frequency does not affect MII modes other than trgmii on port 5 and port 6.
So the assumption is that the operation here called "setting the PLL
frequency" actually sets the frequency of the TRGMII TX clock.

Make it so that it and the rest of the trgmii setup run only when the
trgmii mode is used.

Tested rgmii and trgmii modes of port 6 on MCM MT7530 on MT7621AT Unielec
U7621-06 and standalone MT7530 on MT7623NI Bananapi BPI-R2.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 62 ++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b1a79460df0e..c2d81b7a429d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
-		/* PLL frequency: 125MHz */
-		ncpo1 = 0x0c80;
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
@@ -462,38 +460,40 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
-	/* Lower Tx Driving for TRGMII path */
-	for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-	/* Disable MT7530 core and TRGMII Tx clocks */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-		   REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	/* Setup the MT7530 TRGMII Tx Clock */
-	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
-	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
-	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP4,
-		   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
-		   RG_SYSPLL_BIAS_LPF_EN);
-	core_write(priv, CORE_PLL_GROUP2,
-		   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
-		   RG_SYSPLL_POSDIV(1));
-	core_write(priv, CORE_PLL_GROUP7,
-		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
-		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
-
-	/* Enable MT7530 core and TRGMII Tx clocks */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-		 REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	if (!trgint)
+	if (trgint) {
+		/* Lower Tx Driving for TRGMII path */
+		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
+			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+		/* Disable MT7530 core and TRGMII Tx clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+
+		/* Setup the MT7530 TRGMII Tx Clock */
+		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
+		core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
+		core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP4,
+			   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
+			   RG_SYSPLL_BIAS_LPF_EN);
+		core_write(priv, CORE_PLL_GROUP2,
+			   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
+			   RG_SYSPLL_POSDIV(1));
+		core_write(priv, CORE_PLL_GROUP7,
+			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
+			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+		/* Enable MT7530 core and TRGMII Tx clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
+			 REG_GSWCK_EN | REG_TRGMIICK_EN);
+	} else {
 		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
+	}
+
 	return 0;
 }
 
-- 
2.37.2

