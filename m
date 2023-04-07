Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559436DAE4E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjDGNu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbjDGNtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:06 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDCEC16E;
        Fri,  7 Apr 2023 06:47:18 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54bfce685c1so128068567b3.1;
        Fri, 07 Apr 2023 06:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jsn0NQ9CmWAx6uQ/GpiFpZY13AUB836GqLn0lOzSnMY=;
        b=dbhdUjb5Kx495YHbuaMUJ+xjTzf9UozTmMvu4Fpv2sLSGROC6B3CmnhQ2dGKQV0jCc
         8lvm1MEqANTyT3HXeuYMQdyMZYAxfnxgpc7n1e5VjMGNX8DFTJxfshel9hE45/A0mhGO
         1k4Oa/2WSb39LGib8igtf7MnAGRFXYzEWhQfHz4niOl6j1SZ3ZKTo/Q5XjcNJqc4LSYk
         SDRdgBcw7OJfMnwctk3/Z5y3ckC+lqqOnQ5ztpBm+68gWQo3Zb/MCdFHxg6fLXb0NigI
         cFGz/fzC8XyoDR+m2qJHQsQd5QwLW93/neCy2XUuNF2KPPFpuVqayNvihMZw9AgDswgL
         1GwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jsn0NQ9CmWAx6uQ/GpiFpZY13AUB836GqLn0lOzSnMY=;
        b=gaJKEZ+NaahLJqntE7Y8ayeN3oKA+3Rke7Ch3F7PSHMFn1CD9HnrdBt+avSN2ngwHL
         qMr+ZlqHy4YHh9mi3pDoznPDGN5GA3s30pLtRuDUxTODZy/hdklcA8o+iygHMWfjq6J5
         dtuKVlFHAqRzzVsCw35faHfYZE35fBjQ1ZriUQiDXAyG6Oz7Yy15kpqX4bvqiZ7M0VgL
         NRuidCl2aoi7hwStdRvrMj6umm7uNZ8l4lWV0TrlDvKr0T5oic9Rn2qv2QNMyaM/2IFG
         R2WL3VkhMw8xnokOTt82nFrIWsubtL6eb4otVbMZNCLdqSaHS6WVie7SZdfFxb9XXDAJ
         fOHw==
X-Gm-Message-State: AAQBX9e/WvOV1DkSua3LKAeDuuaCPM/KU09Jc6PTzYhIwWCxcpDjXcgk
        jRR/OkVFMGgqM8qTiod9X4M=
X-Google-Smtp-Source: AKy350ZJABInmffON1tk4bbyZjkiUG1rYtVMdfnNMubLerKmw5V+zmQ0sucFY+D6OMcTnmtsevZGvg==
X-Received: by 2002:a81:484d:0:b0:541:9671:3169 with SMTP id v74-20020a81484d000000b0054196713169mr1867341ywa.39.1680875236297;
        Fri, 07 Apr 2023 06:47:16 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:15 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 09/14] net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
Date:   Fri,  7 Apr 2023 16:46:21 +0300
Message-Id: <20230407134626.47928-10-arinc.unal@arinc9.com>
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

Enable port 6 only when port 6 is being used. Read the HWTRAP_XTAL_MASK
value from val now that val is equal to the value of MT7530_MHWTRAP.

Update the comment on mt7530_setup() with a better explanation.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 0a6d1c0872be..70a673347cf9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,9 +404,13 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal, val;
 
-	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+	val &= ~MHWTRAP_P6_DIS;
+	mt7530_write(priv, MT7530_MHWTRAP, val);
+
+	xtal = val & HWTRAP_XTAL_MASK;
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,
@@ -2235,9 +2239,9 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 			   RD_TAP_MASK, RD_TAP(16));
 
-	/* Enable port 6 */
+	/* Enable PHY access and operate in manual mode */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
+	val &= ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-- 
2.37.2

