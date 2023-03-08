Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429936B07FF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjCHNJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCHNJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:09:15 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8FEC80B4;
        Wed,  8 Mar 2023 05:07:36 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bx12so15278545wrb.11;
        Wed, 08 Mar 2023 05:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678280846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1qQOPUYZltp62usDX13u0lfSl6bY/5+CW4Brvbfffs=;
        b=LoOmc33r6hDYRPAbUIc7PLTQTmw1nd1Yu1JjIRp7tohLlnWvHQuQCbrLVsYxnwhoAf
         7VAG8+bxYrXzKq7/ZvkKKQaAzMUUmJZIv36GBOP2aOmn9aLjsKnMVBeidiPun1jUfnAu
         xpV9uTVIs4cdbz0bmyRk12AxbOUz80jMj9C7KVzL2WdVbEwwOj2l5dkkcWnWLZJVT99W
         EKbq0sEzdSCv6kVAJ2AqPWtCQC8j5ocjlB1nfwwNOBUE9IpXxUm1OYnpTuRMufAUweQU
         FuOHJQOcV776gVr4QYPigLCgBUdJxaFpYbwEDAZs46B9QkzfG/aYe2ZnunJfFjCfWTkY
         f8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678280846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1qQOPUYZltp62usDX13u0lfSl6bY/5+CW4Brvbfffs=;
        b=o3ti51gJ1TesWwXEefALBVy3oIE+TS9OSA1/k/MlxuMfmxgw5wK8KuWCRvlnUBQ0dh
         +HnNcdkM7gJ+eITNROgEPiJs8jJizCJpcl8OKJZnMwltzsDtFcERrJbZOHoELHEya4al
         0GToTkD6wNchj/RZAM+mDdymXfZQPOkQ2yqLaT/ccTXN8DYZ2ppCJhmDDM9dihrK03Xf
         CPXW5+ngZMtR3/C4hSWPhQf9qafuWNIcWcUi2mMIXrVDY78pIZ30VJoBK6ykVorXpxvO
         L5z4b0aZGQvtz2pXHTi/WLRP7I+5pXKfRejKz4w+EtU6dpA8CgHVpjktJFqzlvxrkRiC
         JBHQ==
X-Gm-Message-State: AO0yUKXrzVrV+uF5BcYLvl4xQCSvxBfCEq6jCeBVmFUhlsNC85kPCE9G
        K/cvK+ne0RSX6hiEIR++/98=
X-Google-Smtp-Source: AK7set+chCvVyMu/Alk9YMPkc6M1D5hQo3UquQkcmNKdIEeu879ufUQb+Tt+MiE42KL0vZoz6/4HBQ==
X-Received: by 2002:adf:e606:0:b0:2c5:587e:75ba with SMTP id p6-20020adfe606000000b002c5587e75bamr10918723wrm.55.1678280845802;
        Wed, 08 Mar 2023 05:07:25 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id b3-20020a5d40c3000000b002ce37d2464csm11461328wrq.83.2023.03.08.05.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 05:07:25 -0800 (PST)
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net 2/2] net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used
Date:   Wed,  8 Mar 2023 16:07:15 +0300
Message-Id: <20230308130714.77397-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230308130714.77397-1-arinc.unal@arinc9.com>
References: <20230308130714.77397-1-arinc.unal@arinc9.com>
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

