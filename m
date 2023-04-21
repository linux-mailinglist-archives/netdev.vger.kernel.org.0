Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949D36EAD32
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjDUOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjDUOhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:24 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE19F13FAF;
        Fri, 21 Apr 2023 07:37:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94eff00bcdaso288447666b.1;
        Fri, 21 Apr 2023 07:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087839; x=1684679839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KiBaVS3rBZL46ZkQA5szEuPGIfAQTTXY9i0okmVBlQ=;
        b=cZ6sRw0lbJpWLND6lATpwXgJ92zCE3aNNRpTtdZph7X3D7ft5vWHRKzIV5epNP1v96
         2w2xjIsERO9EJOrPXYOnzYJpPx0Ce2umfFQz/dqR2dXzeU3o0VpnEsQSO3mBP5NBzUTW
         5sU6pExF59smx7ZTWZsllRvG1fDZdmYBQjacd8AmP4BkRRXqRZVBvd42XzcYoYgx4ukO
         pEEM7emL57SXMJyMRQs8QV/fsxXTG5yHRzaOrS3xqqHrsxqdSKhWFz91Nt975t8/XLp5
         Bsfaz26iztGa7H2Ndt1FENtsndXQGRGJxXj0SQfXNvkyYNc6ML3TbldTATqINp6c9ebG
         9g9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087839; x=1684679839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KiBaVS3rBZL46ZkQA5szEuPGIfAQTTXY9i0okmVBlQ=;
        b=K7ZHXGYObO8lscymABqpRjwfglSYuFQ+27JhFkUY708b5JWNR/zXf8aZuwCTKmpA73
         8MwAjMesDt15t+WdtIQXV1boGnLF8menxd6WeIBqx12AMPp3t9cLVEk4LeIyocpEprM1
         61qDb1aEE6jOOqCQR4CUZIfVr1hIBqmRseF+wMBW2Y77Ca4oP7YNsoJMGjjpB1/YO8Js
         f+DrPNJdixJv6qqt3Rz4eZ6iNHCnLzfp82wl9wWqoeO6YGrV3oCHA33g3c3vkFC603QM
         SxE95IzoiVbUOJThnjxyVGQODBHBtMi8l+FrXl0DVjymW4eL2GsbmA+3BEITUBnBm0Xl
         2C4w==
X-Gm-Message-State: AAQBX9frv5ZB2qdUMG02iw1/XvO+YDkOYSnn1uT4epcWljucnSpgEpqu
        JuaVS7LaPlTpFJ8PeVZ8QVY=
X-Google-Smtp-Source: AKy350YK6ZXedBig5mHmtOyoPrGMFSbVmiHuPdA1NfRLq4EnkOhsj3geYQNtVkOLVZKiA/kig5Xpcg==
X-Received: by 2002:a17:906:f757:b0:94e:c142:df98 with SMTP id jp23-20020a170906f75700b0094ec142df98mr2497344ejb.60.1682087839104;
        Fri, 21 Apr 2023 07:37:19 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:18 -0700 (PDT)
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
Subject: [RFC PATCH net-next 11/22] net: dsa: mt7530: remove pad_setup function pointer
Date:   Fri, 21 Apr 2023 17:36:37 +0300
Message-Id: <20230421143648.87889-12-arinc.unal@arinc9.com>
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

The pad_setup function pointer was introduced with 88bdef8be9f6 ("net: dsa:
mt7530: Extend device data ready for adding a new hardware"). It was being
used to set up the core clock and port 6 of the MT7530 switch, and pll of
the MT7531 switch.

All of these were moved to more appropriate locations, and it was never
used for the switch on the MT7988 SoC. Therefore, this function pointer
hasn't got a use anymore. Remove it.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 36 ++----------------------------------
 drivers/net/dsa/mt7530.h |  3 ---
 2 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 58eff6568d4c..a1627e20675d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -473,18 +473,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 	return 0;
 }
 
-static int
-mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
-{
-	return 0;
-}
-
-static int
-mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
-{
-	return 0;
-}
-
 static void
 mt7531_pll_setup(struct mt7530_priv *priv)
 {
@@ -2569,14 +2557,6 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
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
@@ -2743,8 +2723,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p6_configured)
 			break;
 
-		mt753x_pad_setup(ds, state);
-
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
 		break;
@@ -3046,11 +3024,6 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
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
@@ -3112,7 +3085,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3124,7 +3096,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3136,7 +3107,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
 		.phy_read_c45 = mt7531_ind_c45_phy_read,
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
-		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.mac_port_config = mt7531_mac_config,
@@ -3149,7 +3119,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
 		.phy_read_c45 = mt7531_ind_c45_phy_read,
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
-		.pad_setup = mt7988_pad_setup,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
 		.mac_port_config = mt7988_mac_config,
@@ -3179,9 +3148,8 @@ mt7530_probe_common(struct mt7530_priv *priv)
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
index c3a37a0f4843..cad9115de22b 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -696,8 +696,6 @@ struct mt753x_pcs {
  * @phy_write_c22:	Holding the way writing PHY port using C22
  * @phy_read_c45:	Holding the way reading PHY port using C45
  * @phy_write_c45:	Holding the way writing PHY port using C45
- * @pad_setup:		Holding the way setting up the bus pad for a certain
- *			MAC port
  * @phy_mode_supported:	Check if the PHY type is being supported on a certain
  *			port
  * @mac_port_validate:	Holding the way to set addition validate type for a
@@ -718,7 +716,6 @@ struct mt753x_info {
 			    int regnum);
 	int (*phy_write_c45)(struct mt7530_priv *priv, int port, int devad,
 			     int regnum, u16 val);
-	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
 				  struct phylink_config *config);
-- 
2.37.2

