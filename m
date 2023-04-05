Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA146D88C5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjDEUjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjDEUjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:35 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FA26E8D;
        Wed,  5 Apr 2023 13:39:17 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n19so21596919wms.0;
        Wed, 05 Apr 2023 13:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jp4sFg0ojMV8MMU8A9Bkb7JvDbiYw4w687Rv39wQaSk=;
        b=ogrQ00Dp40q8HszYOjDW7BkHkbDsaeh3gTS3X2D8xEh8EyqwhN2zlRUj4CxUSH53gD
         bWQ7QRsAkRS8V8byFcM4sAvzSvnh1MmD3JPIiSVk5NcSczRX50Hc9yjKx4J25aXqw1dy
         Ni/W6LBRqD5VaXUjJiwFb4POV7CM1UqLnj/NucR1ltexeiWhjH7zhWo5vON9+Ts+UDHG
         xZRMXaxHTU5Q9dx4NKypSpTFdU9AsyV561K2f6u/nj2rqvgnyUxO2RhwCpgs5yoGFjcv
         Fn//gj1hdEvVhTq28x67GvvPz9Ch2OdhakpzXrF25he58FllBXn8PqXws8ZIwVz2U4My
         IBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jp4sFg0ojMV8MMU8A9Bkb7JvDbiYw4w687Rv39wQaSk=;
        b=sJ2YpESFRx/hqM3hxxtwRsArxXLw44RyndoEV5nAfA+lOhjKuiNmx5r9zecmffGvnt
         y2QRAg1MnhD746pAkyWM0RH6IKSfqd12x1OQXZ8o7EVkxGd/y/k2xfgBKtiu7cm9wMg7
         PmdShuFZdt+TNps0x8sx5rv59Tw1XMN03bnwdcLPpEgGY5Ua0Q4UqtS7IKcdY7J/vNF8
         TDpOdQ75SE9Bnp3tBKJ90Vi15np8nu4CkMB5gtYhuOdJ/7FeVuBvOzt2Ywi7YrN2k/w8
         Ka4Ci8x+kEu0nQhlDZoN7rN6hVLMlmHZqCOtnQ0eL660xLrVXQFEcDADDD0n8TEuoLK+
         9rBg==
X-Gm-Message-State: AAQBX9fKKejc/xao7l5UIgcmw5kgA5L5eKJNJAFFPvS2Md0542dSxbDC
        bT4fTmn7t4Zk37tCzkR92ag=
X-Google-Smtp-Source: AKy350ZVk8+Ei+TV+4GGdj0W1xwoZVPnMiI9MhynZB1AsFil19iJwi0XmYRr9kmqdo9q1BV4k/E/1A==
X-Received: by 2002:a05:600c:acb:b0:3ed:b6ad:54d with SMTP id c11-20020a05600c0acb00b003edb6ad054dmr5675428wmr.18.1680727155894;
        Wed, 05 Apr 2023 13:39:15 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:15 -0700 (PDT)
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
Subject: [RFC PATCH net-next 05/12] net: dsa: mt7530: remove p5_intf_sel default case from mt7530_setup_port5()
Date:   Wed,  5 Apr 2023 23:38:52 +0300
Message-Id: <20230405203859.391267-6-arinc.unal@arinc9.com>
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

There're two code paths for setting up port 5:

mt7530_setup()
-> mt7530_setup_port5()

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()

On the first code path, priv->p5_intf_sel is either set to
P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4 when mt7530_setup_port5() is run.

On the second code path, priv->p5_intf_sel is set to P5_INTF_SEL_GMAC5 when
mt7530_setup_port5() is run.

Remove this default case which will never run.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fccd59564532..8a47dcb96cdf 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -943,10 +943,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
 		val &= ~MHWTRAP_P5_DIS;
 		break;
-	default:
-		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
-			priv->p5_intf_sel);
-		goto unlock_exit;
 	}
 
 	/* Setup RGMII settings */
@@ -980,7 +976,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	    priv->p5_intf_sel == P5_INTF_SEL_PHY_P4)
 		priv->p5_interface = interface;
 
-unlock_exit:
 	mutex_unlock(&priv->reg_mutex);
 }
 
-- 
2.37.2

