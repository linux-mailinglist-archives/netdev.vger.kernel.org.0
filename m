Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E036D88D1
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbjDEUkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbjDEUkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:40:04 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8567ECD;
        Wed,  5 Apr 2023 13:39:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so19156898wmq.3;
        Wed, 05 Apr 2023 13:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wk3K9bbT+tv5kBnVohJcLc2nqRP/uYdhv43DLYVwvrA=;
        b=Nbp9QixTsTqXq+nlznFJzTPRU25T0EZ9MfYB0i3Bd1kaz5zF7jLHuPO4ztD5MflGWR
         AN5suyxWvODfN++LkEf+UECj7CDSevmkzrBgi2ZCzKzZ/BV4DYNWV8zJjeenQrSm4KbQ
         aQIZRGNJMAzD+Omq1Z53JJ9iH6Jah9w3XpnoC0d0WC9bXqgfFK+UtRuDJIBPJzAenZ4S
         0JGtpgmFd1p4bI7KdW7XrBjdmn7NVm3SGGDWZP8BDs9IqegGqmd4aQ/WgMsbzzRhJP0E
         W/WQeSkfeB/wwl9yl+SR4cGk2VknUiNU07J2Ua0LjagY+kM6F+4lA47K4LU7affatRR4
         +6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wk3K9bbT+tv5kBnVohJcLc2nqRP/uYdhv43DLYVwvrA=;
        b=p42KtFOS0/pdLZ4QkXu7HCFRQAQT8QN0eOnmqYYq5J23NRPnKrQ56YbRsooY9p0Sz2
         +g0qpUcIikCZLTP2ejMIwfn5YWYzBOFX39q0ibfYRQEmdwzvZ5J10Xl1varVK8MmEpHJ
         r39psTHH0uknZcrosCilSuYUBM0ede7RyLHwU6aD1kcg9KjlGfBypaOEuOyNIeWRsNCp
         gOw7q2hnBx3UdqwIFVbO6o6VtTWZMJKniDr/RZdoPmeGFYgSu/6Jfl/ZbP6/GaEZ2v+2
         4l12ufAE80om6V/1abshnTxYXA+eiHB9zyPrq0EudeVbBxcrgzRT5PQVFPGuW1ztq2eF
         a7aQ==
X-Gm-Message-State: AAQBX9fwgxNrWe83Ee26sf0sbASuoJV+YexnZlF/hg+MuLvoBfkMlCgO
        zOmUMYIxE+/kuJeIEtjZ3xA=
X-Google-Smtp-Source: AKy350aFpJYsbdWGizzfVNQlwDH+aMdywoXrMBy75yzELYvUe4GwnL9XMmWJ89kOSD/km6FgxUxAYg==
X-Received: by 2002:a7b:c38a:0:b0:3ed:e715:1784 with SMTP id s10-20020a7bc38a000000b003ede7151784mr6432135wmj.15.1680727167948;
        Wed, 05 Apr 2023 13:39:27 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:27 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>,
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
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 10/12] net: dsa: mt7530: switch to if/else statements on mt7530_setup_port6()
Date:   Wed,  5 Apr 2023 23:38:57 +0300
Message-Id: <20230405203859.391267-11-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230405203859.391267-1-arinc.unal@arinc9.com>
References: <20230405203859.391267-1-arinc.unal@arinc9.com>
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

