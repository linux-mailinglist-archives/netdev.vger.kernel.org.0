Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988896EAD25
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbjDUOh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjDUOhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED7DC660;
        Fri, 21 Apr 2023 07:37:18 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-5052caa1e32so2984504a12.2;
        Fri, 21 Apr 2023 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087837; x=1684679837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGp4Tpz0L6Hnx+AZWBjvMZvm9IQMQXkz0B/FgdPBTn4=;
        b=DKxnRcq+RzWJO70d64SCwn8dKlPjog49hc1bI/lDUd7zvlQYM1FDq/Uo0qUyQmhe6C
         XP29nVBG8TX2btLkfSZkKnuIZZD4/9USpgryKZHyukz1kwwLgkmrARL/z9tECfFyHF+C
         +L5anr9HLc5WuXgyatHdVLa7hvHrnr0L+MPIiofw/C25wuOmG2+0/ugEZuWQh7jdA8S1
         DmqqAbadrq7BjVR3QyNXQiUHSw2pUsqQVFcj80FHg0Nh0QJwGfYGpGt8gCZJRPp1+F2m
         MztENz1X7w+8PIij286h4jj6YK7bG2T+D+RK3MZnbe2PcIauAxTTGMitEGzmGusGfDxN
         DRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087837; x=1684679837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGp4Tpz0L6Hnx+AZWBjvMZvm9IQMQXkz0B/FgdPBTn4=;
        b=fvEG0Q46nZMeYQ/lf6hhf+/5eCSI+m0fgZvKlHFdBLtAk7XQh8ZQAc8dHvHS9xquW+
         6/XjXMGHHSTgcmA/xPW5FRe2XUj9vNJXUcDu1nNGVlCbluFnFm/sGdoKe+lyw9I8HbTy
         IaayyGVHnmLeDTI32eAE7wGVtuDuKJDvfqdzUgvfZItktl4X/KzjzAhluY6bJ0H/akoV
         IrtN2qOxUuMs5ULiMkQckw10bqzfk+5AcjrxUzL0hkB50dmfDD+nrU4l7uajfCmnCgmW
         2+fN0RNhfUe6Bs3E55Q2fMGaTKugffT35NIjcnIxXCLaNtoW0LEMJvSe1Wz8dQFBYxt5
         0Kbg==
X-Gm-Message-State: AAQBX9eeIXKkv6D3u+T4NVihWgnuDCeuCefxcq8gwsmKq3/W20hpdxhG
        btLhWzLk6jTjKy7/uHBkWBU=
X-Google-Smtp-Source: AKy350ZyJxzUXfFeHkyBC3lf1xyUpQmcxh9PNWSCXHCnxZOLSjFWKs9A4jyqL5PVYZjHgRPrZllv2g==
X-Received: by 2002:a17:907:2090:b0:94a:5ecb:6ea7 with SMTP id pv16-20020a170907209000b0094a5ecb6ea7mr2424974ejb.43.1682087836909;
        Fri, 21 Apr 2023 07:37:16 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:16 -0700 (PDT)
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
Subject: [RFC PATCH net-next 10/22] net: dsa: mt7530: call port 6 setup from mt7530_mac_config()
Date:   Fri, 21 Apr 2023 17:36:36 +0300
Message-Id: <20230421143648.87889-11-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
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

mt7530_pad_clk_setup() is called if port 6 is enabled. It used to do more
things than setting up port 6. That part was moved to more appropriate
locations, mt7530_setup() and mt7530_pll_setup().

Now that all it does is set up port 6, rename it to mt7530_setup_port6(),
and move it to a more appropriate location, under mt7530_mac_config().

Leave an empty mt7530_pad_clk_setup() to satisfy the pad_setup function
pointer.

This is the call path for setting up the ports before:

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
-> mt753x_pad_setup()
   -> mt7530_pad_clk_setup()

This is after:

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
      -> mt7530_setup_port6()

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index be143da94add..58eff6568d4c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -401,7 +401,7 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 
 /* Setup port 6 interface mode and TRGMII TX circuit */
 static int
-mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
@@ -473,6 +473,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	return 0;
 }
 
+static int
+mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+{
+	return 0;
+}
+
 static int
 mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
@@ -2576,12 +2582,15 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret;
 
-	/* Only need to setup port5. */
-	if (port != 5)
-		return 0;
-
-	mt7530_setup_port5(priv->ds, interface);
+	if (port == 5) {
+		mt7530_setup_port5(priv->ds, interface);
+	} else if (port == 6) {
+		ret = mt7530_setup_port6(priv->ds, interface);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.37.2

