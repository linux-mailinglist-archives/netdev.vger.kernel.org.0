Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA1D6C94FF
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjCZOJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjCZOJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:09:19 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16FE5FC2;
        Sun, 26 Mar 2023 07:08:56 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id oe8so5102312qvb.6;
        Sun, 26 Mar 2023 07:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2Yyxz9FOXIN+XxKXysP1ZnBuTmwMg6crObSsecZNr8=;
        b=NI8IIylXLN/RgzXXWYF7gu7Y136mGEoIWcy2BmwQXde1fXTgnW85aakyi2zYxJvTyb
         Vba+bXe6E09H/83NDOXX2JN/fSi0a2BP1xX5+FkEygF3z4Fmn891UFnE98kezsNnENwt
         KcNY+pC2skaiTOzjjzBbKhwTUao1aGM5MCC9DhfdCfMRSFfFmKE3/gRFnBAQy6V6Epuf
         /oRDgs9UNYCJVwcMWBpwlwCL1PJt0T15cgWtkN1eYaRXiIjIxrSeowGNfQzedRtMQHYQ
         OqS3fhzbhKPaUtQg6NtU19Sl77qMGDA3K+4bdcITqZ2IFMXEkgbQKXL68JeBCWtYKf81
         oZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2Yyxz9FOXIN+XxKXysP1ZnBuTmwMg6crObSsecZNr8=;
        b=ad5jFGxEfkkSeij2GPc25wBOgpQwKngYRMQigIHrHWuR/vt6Z4D90+qCkml5t8FH7m
         Av47e9TGOdzshS/VxYR8nBFHEViqmFpOxK8v3aohxvprKH1TgIvZpGzQZ6b4Cpe4qs1P
         aVc/uz4R8mNLPQQvEC+bb9C+SsJF/F0FE62Wpb4NLu+eSQpJqQnNfCukiAex3BqO8ndw
         lvf0/Hfk6lPGD+oBTIQemgakE1xGjDNQ0pA11EIGNp+mIMN7Hqyx0it5irK72ipl3UK1
         Uj9w00YBKiBBeUjFILeoiQGfwywaj9+bmTQTTqN8hicRarWCPl1yNIUSdGtKTJzCx105
         2jRA==
X-Gm-Message-State: AAQBX9eT3b17HnlcJAA7V8LG+mujHd6EJ6IQeGvCHH9qkihQBR79qwCG
        4jBcT0KOD+05cI+2r5GNn3c=
X-Google-Smtp-Source: AKy350YkM0qBbgWrY++La63ZQ5ay+0ryc/egnIbwxo+Lx1fiSX0CpeFm7wpYaKIwrXkCFUdAnjYgxw==
X-Received: by 2002:a05:6214:48e:b0:5c2:7d8d:ed0f with SMTP id pt14-20020a056214048e00b005c27d8ded0fmr16735897qvb.12.1679839735529;
        Sun, 26 Mar 2023 07:08:55 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id j5-20020a0ce6a5000000b005dd8b93458esm2212220qvn.38.2023.03.26.07.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:08:55 -0700 (PDT)
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
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 6/7] net: dsa: mt7530: call port 6 setup from mt7530_mac_config()
Date:   Sun, 26 Mar 2023 17:08:17 +0300
Message-Id: <20230326140818.246575-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230326140818.246575-1-arinc.unal@arinc9.com>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
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

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2397d63cec29..8d49803f7522 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -421,7 +421,7 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 
 /* Setup port 6 interface mode and TRGMII TX circuit */
 static int
-mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
@@ -493,6 +493,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	return 0;
 }
 
+static int
+mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+{
+	return 0;
+}
+
 static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 {
 	u32 val;
@@ -2523,12 +2529,15 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

