Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261CC6D88CB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjDEUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbjDEUjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:47 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A09476B1;
        Wed,  5 Apr 2023 13:39:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t4so32196455wra.7;
        Wed, 05 Apr 2023 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6c6V/5LU1iA96LbQDMn3nYNgJi0pITa7Rc7pXzjwd8=;
        b=XZPhIj2o/qg1/gyE2R6SPJrBAUKxbIiUIuTX1is2BacHL8r50IEfMUej2/1aeuvtRV
         FdRSkJedwOlA+GjuTSfYFbO0jbUSHLDwlxNCu1bTXlHHQhMGoKi3v7rzMDhM4Fgw6PxN
         ugXbeFcxI/o3hHz1ZXOpPUp52OLB69TBFPocWKq4zauwDZzC4/8vWtZEvqrRWRTYH4Bs
         HS+/Pye0eX11PtDcKNvZqXfYeBlPAy0tDwWnlhJS91qZGTT6rK6pfnH1j/ERxAdhv3s3
         it8aETPSNAzlrsqW7Wms//IdIcPSgrzimpzZSIXcQxwhhRA+K8NcFFELmYbbnxlpOyu3
         0PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6c6V/5LU1iA96LbQDMn3nYNgJi0pITa7Rc7pXzjwd8=;
        b=uS4GYhkbmJjV1BLJcf5hNhvhuZ48xi8hqK+WGKt7v3f+ieSKvZtjjn0wp7MOWqZ6Fz
         0mI2TND6AwV6n1zqDuZfsBBA+THoIHivQP+Gkx3kCrwXfNWIL5lbWX0UI6fCGUMO36Od
         CJByANj88Yxg9vGO/VaoeowC7yAXBjLOX5YQXnkkh3OuDClrVJOt4v+VCa0Tz5MqjV6A
         Z7V0QHVJYIoR6nXFQjEgBQ4mTjsuKc3vCU909O+g64GVO37ldbsi/QEq4xHWnQdCDfqG
         W1NM28+CJ58+OqCeSpQiLNH5XjLqNKjon9bCv725j224b8KM0QaXB+kGEnwgRvdT7bQK
         Q7RA==
X-Gm-Message-State: AAQBX9dL9FdFjFmx+KPlfPZTMhWZKEeGJDzx9qgDD3CTLjU+Fwj2CZWh
        59YrqGPi3hQ2YFZXZ0DeTm0=
X-Google-Smtp-Source: AKy350Y6Oh6tCjeg4QzeeYsJD/AXXzE1Hsqg2ZRfWrjUjrNhiARwwu9Gc4MrcPLsHmPZe9yOMswj3w==
X-Received: by 2002:a05:6000:14f:b0:2d2:29a4:4457 with SMTP id r15-20020a056000014f00b002d229a44457mr4491825wrx.13.1680727162992;
        Wed, 05 Apr 2023 13:39:22 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:22 -0700 (PDT)
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
Subject: [RFC PATCH net-next 08/12] net: dsa: mt7530: remove pad_setup function pointer
Date:   Wed,  5 Apr 2023 23:38:55 +0300
Message-Id: <20230405203859.391267-9-arinc.unal@arinc9.com>
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

The pad_setup function pointer was introduced with 88bdef8be9f6 ("net: dsa:
mt7530: Extend device data ready for adding a new hardware"). It was being
used to set up the core clock and port 6 of the MT7530 switch, and pll of
the MT7531 switch.

All of these were moved to more appropriate locations, and it was never
used for the switch on the MT7988 SoC. Therefore, this function pointer
hasn't got a use anymore. Remove it.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 36 ++----------------------------------
 drivers/net/dsa/mt7530.h |  3 ---
 2 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c636a888d194..0a6d1c0872be 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -473,12 +473,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 	return 0;
 }
 
-static int
-mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
-{
-	return 0;
-}
-
 static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 {
 	u32 val;
@@ -488,12 +482,6 @@ static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 	return (val & PAD_DUAL_SGMII_EN) != 0;
 }
 
-static int
-mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
-{
-	return 0;
-}
-
 static void
 mt7531_pll_setup(struct mt7530_priv *priv)
 {
@@ -2576,14 +2564,6 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
-static int
-mt753x_pad_setup(struct dsa_switch *ds, const struct phylink_link_state *state)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	return priv->info->pad_setup(ds, state->interface);
-}
-
 static int
 mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -2754,8 +2734,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p6_interface == state->interface)
 			break;
 
-		mt753x_pad_setup(ds, state);
-
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
 
@@ -3053,11 +3031,6 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int mt7988_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
-{
-	return 0;
-}
-
 static int mt7988_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -3119,7 +3092,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3131,7 +3103,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3143,7 +3114,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
 		.phy_read_c45 = mt7531_ind_c45_phy_read,
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
-		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.mac_port_config = mt7531_mac_config,
@@ -3156,7 +3126,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
 		.phy_read_c45 = mt7531_ind_c45_phy_read,
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
-		.pad_setup = mt7988_pad_setup,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
 		.mac_port_config = mt7988_mac_config,
@@ -3186,9 +3155,8 @@ mt7530_probe_common(struct mt7530_priv *priv)
 	/* Sanity check if these required device operations are filled
 	 * properly.
 	 */
-	if (!priv->info->sw_setup || !priv->info->pad_setup ||
-	    !priv->info->phy_read_c22 || !priv->info->phy_write_c22 ||
-	    !priv->info->mac_port_get_caps ||
+	if (!priv->info->sw_setup || !priv->info->phy_read_c22 ||
+	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps ||
 	    !priv->info->mac_port_config)
 		return -EINVAL;
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 01db5c9724fa..9e5b99b853ba 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -697,8 +697,6 @@ struct mt753x_pcs {
  * @phy_write_c22:	Holding the way writing PHY port using C22
  * @phy_read_c45:	Holding the way reading PHY port using C45
  * @phy_write_c45:	Holding the way writing PHY port using C45
- * @pad_setup:		Holding the way setting up the bus pad for a certain
- *			MAC port
  * @phy_mode_supported:	Check if the PHY type is being supported on a certain
  *			port
  * @mac_port_validate:	Holding the way to set addition validate type for a
@@ -719,7 +717,6 @@ struct mt753x_info {
 			    int regnum);
 	int (*phy_write_c45)(struct mt7530_priv *priv, int port, int devad,
 			     int regnum, u16 val);
-	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
 				  struct phylink_config *config);
-- 
2.37.2

