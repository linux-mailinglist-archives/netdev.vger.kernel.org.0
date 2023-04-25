Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0644C6EDE2A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjDYIdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjDYIbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:49 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A00213F88;
        Tue, 25 Apr 2023 01:30:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-956ff2399c9so938829066b.3;
        Tue, 25 Apr 2023 01:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411440; x=1685003440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uLav40hri3eanK3Jy4AVy91JvuI98IGXe5BAzhG3qY=;
        b=cvjH75DPQqlRxJGSfXV8bb+spvakoCPO+pRgYvaHQhjszaR4HJIfty1kIxqdkvg507
         /kmGLkGSTYoGmbMSdDzQaG9+PPXEADtQ4T3LOTnowyVyp+boUz166MNb4r9MS4IVaBCE
         8CzFmkZtnCdxpmvkzxqpVsN0y2chhZfUo+WhJI7KldRU+TBQzt2inwO0+fEcHnJhZwlQ
         Bly5F3SodqWFsNQ2jB9pDnnCXnUKKJownQ9HUQhJV9vp9cUyNHNnADgGkl7D1qnmFrvt
         UUtQ/buQ5W63FzO+dmwUnIh/s/7F/dJ7r+2bo5QrFB3FVigVsnTCD+iNDgJDdWN+AdsK
         pdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411440; x=1685003440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uLav40hri3eanK3Jy4AVy91JvuI98IGXe5BAzhG3qY=;
        b=LA9C+/flWixLw0W5nZRqYwXhCcBedHR3qU6Tg9Aa22JVQ9ROrKkXFUOxAArV/NAzhX
         G+Cf7bsbdpvQ2Qj3wuolXobbLJnYIbYmcVIB/MjL+v2putPZrv61jBvEgcBm0CdyWxVU
         z9KTabeEBnGYDk5WEVy41AQ36s219O9RuzMGrL6892novdcZodJ4JgEYzn/aHEVg8weK
         ajyLCR8yUqhJueBo4KYEx/uj+R4T0x4RUAwovVeA3RVqI9gV7gVQRkGtONQDzpz9kTrv
         xhTB5S1a7pB+NPWLYBUF84keKwtjv1JosYpGBp39pw4gLyBWIav+Bq2NtShLZch1AV1J
         7QHQ==
X-Gm-Message-State: AAQBX9f09vq6rf0m/Il55Aw1TnxfKYPBRzF6c8IY7J9pvLbmIj327ikk
        mXC4nsUqn6GtvHAdE4cA5E4=
X-Google-Smtp-Source: AKy350ZKkzSKbtmxddOSln/bZb1aezgAR66i8vfy7x3dBj2ysqx42JxhlOsAxkxx3wSoJxv2IlopoA==
X-Received: by 2002:a17:906:ecb7:b0:8b1:3467:d71b with SMTP id qh23-20020a170906ecb700b008b13467d71bmr12844134ejb.48.1682411439716;
        Tue, 25 Apr 2023 01:30:39 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:39 -0700 (PDT)
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
Subject: [PATCH net-next 19/24] net: dsa: mt7530: remove .mac_port_config for MT7988 and make it optional
Date:   Tue, 25 Apr 2023 11:29:28 +0300
Message-Id: <20230425082933.84654-20-arinc.unal@arinc9.com>
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

For the switch on the MT7988 SoC, the code in mac_port_config for MT7988 is
not needed as the interface of the CPU port is already handled on
mt7988_mac_port_get_caps().

Make .mac_port_config optional. Before calling
priv->info->mac_port_config(), if there's no mac_port_config member in the
priv->info table, exit mt753x_mac_config() successfully.

Remove mac_port_config from the sanity check as the sanity check requires a
pointer to a mac_port_config function to be non-NULL. This will fail for
MT7988 as mac_port_config won't be a member of its info table.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Co-authored-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index aee1e4d71547..bdd3f63fe1ef 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2613,17 +2613,6 @@ static bool mt753x_is_mac_port(u32 port)
 	return (port == 5 || port == 6);
 }
 
-static int
-mt7988_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
-		  phy_interface_t interface)
-{
-	if (dsa_is_cpu_port(ds, port) &&
-	    interface == PHY_INTERFACE_MODE_INTERNAL)
-		return 0;
-
-	return -EINVAL;
-}
-
 static int
 mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -2664,6 +2653,9 @@ mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!priv->info->mac_port_config)
+		return 0;
+
 	return priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
@@ -3107,7 +3099,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
-		.mac_port_config = mt7988_mac_config,
 	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
@@ -3135,8 +3126,7 @@ mt7530_probe_common(struct mt7530_priv *priv)
 	 * properly.
 	 */
 	if (!priv->info->sw_setup || !priv->info->phy_read_c22 ||
-	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_config)
+	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps)
 		return -EINVAL;
 
 	priv->id = priv->info->id;
-- 
2.37.2

