Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A776EDE26
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjDYIcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjDYIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:45 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D913913F89;
        Tue, 25 Apr 2023 01:30:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94f3df30043so855667266b.2;
        Tue, 25 Apr 2023 01:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411430; x=1685003430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=co2jsjwTwJzbd0CfvHd0rFDJW53+yrpC0IXVfcexPcs=;
        b=XKb6hqva9cpaCTomkMHevUFoOT7/EU2Bze1fOeF/HN9vi9NOc1a+AGZkDack/8l0MD
         CdM/Ra+IIeBSyktSfQbpm8gj15u1/9FXIW0O+Js7Q/Zl/xgIyxVlCtvzxz8Sy2x49uxo
         LZKNfuW3TxpjjSjRph7wkZHXTgWZZCfeH3jdjen2DgyAWNwf0mYfOkNd6TV4NKXQqkit
         yeL2gxBcpSfcHwx9HlamE1NhYdEkYIpH1YEyXBfnhgiJch7oesiUG4A+HnisISEyjG3p
         6sbfi3IxOUWc/OL21CNwTZVx2ETn3oV+llgn4CMEDJtM2pLu+L+nG4oFDQDgIJTm+wuV
         I9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411430; x=1685003430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=co2jsjwTwJzbd0CfvHd0rFDJW53+yrpC0IXVfcexPcs=;
        b=Z7CDEAD+LWOUTns78NwwzOSboZ7WEolQE4m9eeMrFgCoopQQyLOB4LlR6O4gd3Einn
         jKzclLSPT/y3vx2PW5YALEedaJc1A5F99XReFkTZ9Gi+8ZxeCJh+e/oRBIGiN+1NxrbJ
         D9wX888WLuowvpeJ8iDfUKYybE0xkfZSS6XsMQbE0ZGBnowGUNxKz6K/qsLzUdrQz+bp
         o6tv4KUbCUnywWpctMndCqzYrypP1261sp7Xsi89SpMLZj8JBnswdOnHdIRKO+5SMWD4
         tV4bVn2ybvuWw7K8Cz4NH5ean2K/rRWhU0N2t0+uYo6kbHr1/syZj3S2iQdJhoTt1NyK
         Sing==
X-Gm-Message-State: AAQBX9eNtWd5H9ekaOLMkp+I23/Ox7YFLXvQC8uLgq2d1EswBOIiaqV3
        6WCUdHyloMM/tLE4OVNfzZU=
X-Google-Smtp-Source: AKy350byQOy4L1omedzexSzAU2byBGn+c47N2fDo8+2S0flJALDDrH1iY3icL0zV3jg3N5AK/4u2nA==
X-Received: by 2002:a17:906:69ca:b0:94a:5925:56e2 with SMTP id g10-20020a17090669ca00b0094a592556e2mr12028586ejs.22.1682411429791;
        Tue, 25 Apr 2023 01:30:29 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:29 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 15/24] net: dsa: mt7530: switch to if/else statements on mt7530_setup_port6()
Date:   Tue, 25 Apr 2023 11:29:24 +0300
Message-Id: <20230425082933.84654-16-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 980d59170ba2..ea023e32313c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -400,11 +400,11 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 }
 
 /* Setup port 6 interface mode and TRGMII TX circuit */
-static int
+static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal, val;
+	u32 ncpo1, ssc_delta, xtal, val;
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS;
@@ -412,16 +412,18 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
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
@@ -434,17 +436,7 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
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
 
@@ -466,8 +458,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 	}
-
-	return 0;
 }
 
 static void
@@ -2562,14 +2552,11 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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
2.37.2

