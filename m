Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5397B6DAE4D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjDGNu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjDGNth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:37 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F6FC177;
        Fri,  7 Apr 2023 06:47:27 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-54e40113cf3so15928167b3.12;
        Fri, 07 Apr 2023 06:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wk3K9bbT+tv5kBnVohJcLc2nqRP/uYdhv43DLYVwvrA=;
        b=fRjxo2IWvt0K0aWF+f+Tf9xJkNfm8WGeqv4Fe295l8jhZZax7oguW/1MS97hQV4xEj
         mnXLBdgAoEP0hELbN0xHJmI94v+bITujHpGafKIL1p0t8KjZrY8/f6HV3i1y39k8lsxL
         xhPD0Su2OTMk7ob8ZiAS88FmoadArFKiAyiz6rHs6R84tg4J/fqMD0E1iOyUgHL+z9Wr
         vjETfz0YBwcNSJG3cGLV19YNnMW2Ktpvsjbq5HS9dKphz+RKhqbNLEf3TOL4iYrNyOmh
         1wyHPDUUmH+Qe27vNZnnTCFa+O/bTkBIGWjYfldCL+MfHNyyl4MrYOvnOt0eqr1JHLOo
         RdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wk3K9bbT+tv5kBnVohJcLc2nqRP/uYdhv43DLYVwvrA=;
        b=fsa+DpqZNMmkhYku9yBkmziKP62xWyH5DdvWLZWIrnQfoWe+bAHgZgEu+OyYqkVkd9
         zz+X8UV56rDKFdV2Y+NY+VRBwROBmYaXaxdWO8+pJd6WM6Zwx9r7QPusEGRjBH6jkKh3
         we1zzGgXCHgDbdFDGN891MjWP4gBYMWJ2BPrBHNzCVaq41lMOgyyvFXP4pEWUW4uqnvG
         OyZMX6qcpnqAS12p3HhWyFkFoC1vrNlV3kMCiHBFBY9qcJV78QAZv0XYtpY2iRnUWSjN
         73bWhGs8FZZmXx4fT277OB/u0dIN1ZQYS/L3bT0q5p8/wPbp8EndBZ5rYVtCz6TZ63D2
         xcIQ==
X-Gm-Message-State: AAQBX9cV0ZZm4SogupZLTac/XzDLIj7x//3P9tvUkRwMP41TNTDIZyQ2
        ZWclxCEG25hd0PW8XSxUPZo=
X-Google-Smtp-Source: AKy350Y+xClOt7UnfrOknFMaUzg6EYYLGiTjzWRlZX4ygI1vDO6kxkLttmAB/nx9RnSeTOvVeIvzog==
X-Received: by 2002:a0d:e682:0:b0:53c:d480:f510 with SMTP id p124-20020a0de682000000b0053cd480f510mr1915752ywe.0.1680875240763;
        Fri, 07 Apr 2023 06:47:20 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:20 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH v2 net-next 10/14] net: dsa: mt7530: switch to if/else statements on mt7530_setup_port6()
Date:   Fri,  7 Apr 2023 16:46:22 +0300
Message-Id: <20230407134626.47928-11-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 70a673347cf9..fe496d865478 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal, val;
+	u32 ncpo1, ssc_delta, xtal, val;
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS;
@@ -419,16 +419,18 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 		return -EINVAL;
 	}
 
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
 			/* PLL frequency: 150MHz: 1.2GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
@@ -441,17 +443,7 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 			if (xtal == HWTRAP_XTAL_25MHZ)
 				ncpo1 = 0x1400;
 		}
-		break;
-	default:
-		dev_err(priv->dev, "xMII interface %d not supported\n",
-			interface);
-		return -EINVAL;
-	}
-
-	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
-		   P6_INTF_MODE(trgint));
 
-	if (trgint) {
 		/* Disable the MT7530 TRGMII clocks */
 		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
-- 
2.37.2

