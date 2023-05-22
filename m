Return-Path: <netdev+bounces-4265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4107470BD7E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0336280D60
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D034408;
	Mon, 22 May 2023 12:17:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA2714A85
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:01 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF851BDD;
	Mon, 22 May 2023 05:16:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96f7bf29550so456816966b.3;
        Mon, 22 May 2023 05:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757788; x=1687349788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXJvm4BanXy98faJtbpsaIfSwxdUE0yan5VZ72bTyhw=;
        b=JFML/u+TZX374inSW9dEos+1RCN6m2sGTv63O/EfGGpmOJhQQ8zqpNh8cRppdWf6lq
         ymtwX6Y+BdlMhtGfP3cEfoIq6tCmI20/SW0P7pS4lumP3KLTKIBmVIFxResi0X2aX+vx
         tke2x165gkXom6+/GJc1qS8fTaXlif3ynvr1PR7AYCS+1NGwKINg9ZvJndQj++BiPJXt
         BSJzvT+aIOM1QbGeJE6tvr2JonPJ22OOI2QaCQFGEFZRdA+un4O9XAugd3E0qrC+DhXZ
         8LjrEhGpP4PY0IPPRcOkPXfhXq/fR/cZUY8VA5RY2NwPmB8zghJLyL3Lza4loz0O7b3F
         wyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757788; x=1687349788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXJvm4BanXy98faJtbpsaIfSwxdUE0yan5VZ72bTyhw=;
        b=KrkKU4s2Ssa/ByOWeUK+rMzeBJibee/gqyeE5PE44wTNNotVy5z5zKUjzBYi0Wy5Z0
         oYVAhT39UCqLUFpptiT7a03X6g6AjHBeuRNKhoHeUySbwpwV2oXkmUizlRvxrD+wZs7j
         5mc87kaZTejf9xWYAFvq+nZOZlRgSUQPdyqAJIdWTL6T4IG1j65EnnoDRKkkwgl+tnnk
         Ac3UGG8lnRdCtNXvWQCCJbxF+bJwi8NshPWfw2ZEAoHfv9KwW4ah/mCff5MCTFadtHj1
         ZBRgR5QKNGwE/vqj8Eiv0dJ9NEQKiLgTzTcRF72JvNh5F3wDXe0ytaC/kRkgF7hPkJNh
         SvTg==
X-Gm-Message-State: AC+VfDw26UPpU+V0icPt/QHvfK0AUszeMDE7mKK54W/Bq9Fft0sdkA3U
	9e7URG3dhjfl1tawmlgdTlQ=
X-Google-Smtp-Source: ACHHUZ6vJ8AzE8PNAfVN1zoa1xmkJap1GYfYdM/+VUy2HoekWvjptqJ31qOUOdDQPBDRBrJsLfLySw==
X-Received: by 2002:a17:907:3206:b0:94f:6058:4983 with SMTP id xg6-20020a170907320600b0094f60584983mr8336972ejb.76.1684757787991;
        Mon, 22 May 2023 05:16:27 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:27 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 14/30] net: dsa: mt7530: switch to if/else statements on mt7530_setup_port6()
Date: Mon, 22 May 2023 15:15:16 +0300
Message-Id: <20230522121532.86610-15-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

This code is from before this driver was converted to phylink API. Phylink
deals with the unsupported interface cases before mt7530_setup_port6() is
run. Therefore, the default case would never run. However, it must be
defined nonetheless to handle all the remaining enumeration values, the
phy-modes.

Switch to if/else statements which simplifies the code.

Change mt7530_setup_port6() to void now that there're no error cases left.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 47b89193d4cc..744787e38ecc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -400,26 +400,28 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 }
 
 /* Setup port 6 interface mode and TRGMII TX circuit */
-static int
+static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal;
+	u32 ncpo1, ssc_delta, xtal;
 
 	mt7530_clear(priv, MT7530_MHWTRAP, MHWTRAP_P6_DIS);
 
 	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
-	switch (interface) {
-	case PHY_INTERFACE_MODE_RGMII:
-		trgint = 0;
-		break;
-	case PHY_INTERFACE_MODE_TRGMII:
-		trgint = 1;
+	if (interface == PHY_INTERFACE_MODE_RGMII) {
+		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
+			   P6_INTF_MODE(0));
+	} else {
+		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
+			   P6_INTF_MODE(1));
+
 		if (xtal == HWTRAP_XTAL_25MHZ)
 			ssc_delta = 0x57;
 		else
 			ssc_delta = 0x87;
+
 		if (priv->id == ID_MT7621) {
 			/* PLL frequency: 125MHz: 1.0GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
@@ -432,17 +434,7 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 			if (xtal == HWTRAP_XTAL_25MHZ)
 				ncpo1 = 0x1400;
 		}
-		break;
-	default:
-		dev_err(priv->dev, "xMII interface %d not supported\n",
-			interface);
-		return -EINVAL;
-	}
 
-	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
-		   P6_INTF_MODE(trgint));
-
-	if (trgint) {
 		/* Disable the MT7530 TRGMII clocks */
 		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
@@ -464,8 +456,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 	}
-
-	return 0;
 }
 
 static void
@@ -2563,14 +2553,11 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	int ret;
 
 	if (port == 5) {
 		mt7530_setup_port5(priv->ds, interface);
 	} else if (port == 6) {
-		ret = mt7530_setup_port6(priv->ds, interface);
-		if (ret)
-			return ret;
+		mt7530_setup_port6(priv->ds, interface);
 	}
 
 	return 0;
-- 
2.39.2


