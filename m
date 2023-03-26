Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1EC6C9501
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjCZOJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjCZOJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:09:30 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7DE7A8F;
        Sun, 26 Mar 2023 07:09:01 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 31so5166510qvc.1;
        Sun, 26 Mar 2023 07:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++RQ2Lt1GvGc7/uLgZw+p9gJX3oBQ8p2zIe2CsZw+Bg=;
        b=crLklXdx+c3qzQl0/siZYZrbmd8rJGQwNYsgtDOrzz9wBJtgI3dbjLqUiqE4W1nsJa
         oUa3jd3I8wyMpYoj6CRKEx1dfujwDPqN2YO0uSmIoeINKG3UJvCJmE/5udph8vg+qT5i
         nIF9y7J11s1tEpIaRatXwZE5h7Zt52lxT5kZ3wG3w/rLCXcO/B6Lz7r9n4kpbub36dn7
         BpFeyKwDFjpzzo73edazP3RzhTsB0N6l/LubJkyRoqsQtVZwAu8PN3UZ8GjeD57iaTDj
         oy4NbThDXJ/QHhoMTAamRa+VnNWIgpZjsSYK0H8X+wSP/jKZp+1LWcUviEz69KAfC8t9
         Z3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++RQ2Lt1GvGc7/uLgZw+p9gJX3oBQ8p2zIe2CsZw+Bg=;
        b=5cZY4SwMYs0niw74QXI+i/wfRLQ+jLtwERt3Bz/orcl3uVqKP8bSO5DEPZePjxsNE2
         7JnmoFOAVlWzA5tAKKedIP0kNNRJl4oTBGmtVjIm7I0HYzCYdJ9fwQqgLmkCh4bgRtm2
         gp7R8/TzY8juAbVUqZRfc+xaEqqF1z6DR4oerPxuOH5h/qdVSubvpNIEhgBBoA27fVhp
         MSMH7uuhzkD9gWemAf9yMj4k8Vzz+WZNZM9rck8QIIx37VA4wvzjhhhmmlkrZ+pINMYL
         TsheanQQV+W6wKEG5BK4bWUc0SS+ltMBuYS666J8RY/nEmHud5aNQEjuvylMEjzb+Ato
         LqKQ==
X-Gm-Message-State: AAQBX9eKs2/lsv0wiudx++coOLkfRjffiTEJf6uFaWd9laq+Yv/tC466
        nOTN7pVO1c+S1cGe4yslttBwimQqMBMNFA==
X-Google-Smtp-Source: AKy350ak7OnYrWTDxsSk1iFva/JE1J53KGMNkWYWKwgU8QXYnDHNNbo6uwP+El/Ra8KxTVjTQHrT/A==
X-Received: by 2002:ad4:5d66:0:b0:56e:9da4:82ff with SMTP id fn6-20020ad45d66000000b0056e9da482ffmr14059429qvb.50.1679839740380;
        Sun, 26 Mar 2023 07:09:00 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id j5-20020a0ce6a5000000b005dd8b93458esm2212220qvn.38.2023.03.26.07.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:09:00 -0700 (PDT)
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
Subject: [PATCH net 7/7] net: dsa: mt7530: remove pad_setup function pointer
Date:   Sun, 26 Mar 2023 17:08:18 +0300
Message-Id: <20230326140818.246575-8-arinc.unal@arinc9.com>
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

The pad_setup function pointer was introduced with 88bdef8be9f6 ("net: dsa:
mt7530: Extend device data ready for adding a new hardware"). It was being
used to set up the core clock and port 6 of the MT7530 switch, and pll of
the MT7531 switch.

All of these were moved to more appropriate locations so this function
pointer hasn't got a use anymore. Remove it.

Fixes: 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new hardware")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 30 ++----------------------------
 drivers/net/dsa/mt7530.h |  3 ---
 2 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8d49803f7522..83dcd888f82b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -493,12 +493,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
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
@@ -508,12 +502,6 @@ static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
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
@@ -2516,14 +2504,6 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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
@@ -2798,8 +2778,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p6_interface == state->interface)
 			break;
 
-		mt753x_pad_setup(ds, state);
-
 		if (mt753x_mac_config(ds, port, mode, state) < 0)
 			goto unsupported;
 
@@ -3215,7 +3193,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3227,7 +3204,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7530_phy_write_c22,
 		.phy_read_c45 = mt7530_phy_read_c45,
 		.phy_write_c45 = mt7530_phy_write_c45,
-		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3239,7 +3215,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write_c22 = mt7531_ind_c22_phy_write,
 		.phy_read_c45 = mt7531_ind_c45_phy_read,
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
-		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
 		.mac_port_config = mt7531_mac_config,
@@ -3297,9 +3272,8 @@ mt7530_probe(struct mdio_device *mdiodev)
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
index 6b2fc6290ea8..fd050d3110c6 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -754,8 +754,6 @@ struct mt753x_pcs {
  * @phy_write_c22:	Holding the way writing PHY port using C22
  * @phy_read_c45:	Holding the way reading PHY port using C45
  * @phy_write_c45:	Holding the way writing PHY port using C45
- * @pad_setup:		Holding the way setting up the bus pad for a certain
- *			MAC port
  * @phy_mode_supported:	Check if the PHY type is being supported on a certain
  *			port
  * @mac_port_validate:	Holding the way to set addition validate type for a
@@ -776,7 +774,6 @@ struct mt753x_info {
 			    int regnum);
 	int (*phy_write_c45)(struct mt7530_priv *priv, int port, int devad,
 			     int regnum, u16 val);
-	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
 	int (*cpu_port_config)(struct dsa_switch *ds, int port);
 	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
 				  struct phylink_config *config);
-- 
2.37.2

