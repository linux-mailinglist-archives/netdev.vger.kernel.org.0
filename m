Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2C55F481
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiF2DzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiF2Dy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:54:59 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5827F2ED56
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:58 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id h65so19952720oia.11
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLWIIMMtnGdD1IKiWzRd6SzAH7vtKRCUdPqnUchpkWY=;
        b=F6/E/uLBnQhnEiIGjT3zYi+fPcKtVWUjg4/7Q39jHlc5uweRPC2u2In0I7MkA2Whmn
         /I9YaXTfAew+kxh3czyy6gyVpdY31+0T9ucYt2WDYn+sswZ+aPzokYssD9NIubT56uyB
         jw7+OVi/AA3DZQvGicMppcAfNSn7dmmbo5lIoaeYgJFwzABTQ7xe8UllI8IsauNhfNI5
         P9C2ObAtruVcSeAwlUiOeo+bWHmlNqVzPuQGD/vrmdh+n4/i0wBFKUqD60hFwYevYV+3
         bj0exJmu9O9x/JIvLWGpzbPYV9yTTZXz9TU0cl7IQxYavryIP1Yx4/rem05qqcJdE2Z7
         z5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLWIIMMtnGdD1IKiWzRd6SzAH7vtKRCUdPqnUchpkWY=;
        b=v2DZuJic8eHL2CFP7QqraTX0xd8JeAMqwXCVoqZd1q9A2q+cLzM0Pg6y+IC6GpXBEK
         QQSiywaWIUwK/fRflbr3cw2fiLzrjWWnl1RgmQNUnzQPYZJ+swN03VrgJhjzd5VKtNoj
         nCuEsa+LW8G3fSOip9WYKA9glNCRH+tBE7dtGSdYjgSUyLLr3Da88Q8v3Y8/S1K9YsBQ
         m55zzdP6MTfX+vxqnQWMP/FDNd3+hfPa6iPCRuSGrXNtQ5f+vtgBFmda4qPoPB3XNEMD
         03aEDntwsOJe8oY1ajCfPFpahsd+C4RhoHF/EeeDwHDT4f9cXeQafGzv/IxWhPOjfe2L
         EXVw==
X-Gm-Message-State: AJIora8IADyliLS9/T+/z65kC+Xg0pHFAkbRkl37KRnv5sVuEx+Vvr2l
        dULRa+YL8hYk63ey69CGH2WSpioxWkC0gQ==
X-Google-Smtp-Source: AGRyM1tJQc6ol2EUyfexWAYtLORRgahzaBnDbtH9yZDndkfV2HIlpLYDTc4S4/tqQ1/YCjkq5cd6yA==
X-Received: by 2002:a05:6808:1691:b0:2f9:4bd7:581e with SMTP id bb17-20020a056808169100b002f94bd7581emr1830102oib.144.1656474897397;
        Tue, 28 Jun 2022 20:54:57 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id r6-20020a056870580600b001089aef1815sm5636756oap.20.2022.06.28.20.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:54:56 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next RFC 3/3] net: dsa: realtek: remove deprecated custom slave mii
Date:   Wed, 29 Jun 2022 00:54:34 -0300
Message-Id: <20220629035434.1891-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629035434.1891-1-luizluca@gmail.com>
References: <20220629035434.1891-1-luizluca@gmail.com>
MIME-Version: 1.0
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

Drop the code path using the custom slave mii. It still warns if there
is a compatible string in "mdio" node. However, if that compatible
string is in a node not named "mdio", it will show an error. In that
case, it might still work using polling instead of interruptions.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi.c | 71 +++------------------------
 drivers/net/dsa/realtek/realtek.h     |  5 --
 drivers/net/dsa/realtek/rtl8365mb.c   | 30 -----------
 drivers/net/dsa/realtek/rtl8366rb.c   | 34 -------------
 4 files changed, 8 insertions(+), 132 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index c3668a9208ac..5de0b1563e44 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -352,67 +352,6 @@ static const struct regmap_config realtek_smi_nolock_regmap_config = {
 	.disable_locking = true,
 };
 
-static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
-{
-	struct realtek_priv *priv = bus->priv;
-
-	return priv->ops->phy_read(priv, addr, regnum);
-}
-
-static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
-				  u16 val)
-{
-	struct realtek_priv *priv = bus->priv;
-
-	return priv->ops->phy_write(priv, addr, regnum, val);
-}
-
-static int realtek_smi_setup_mdio(struct dsa_switch *ds)
-{
-	struct realtek_priv *priv =  ds->priv;
-	struct device_node *mdio_np;
-	int ret;
-
-	mdio_np = of_get_compatible_child(priv->dev->of_node, "realtek,smi-mdio");
-	if (!mdio_np) {
-		dev_err(priv->dev, "no MDIO bus node\n");
-		return -ENODEV;
-	}
-
-	dev_warn(priv->dev,
-		 "Rename '%s' to 'mdio' and remove the compatible string\n",
-		  mdio_np->full_name);
-
-	priv->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
-	if (!priv->slave_mii_bus) {
-		ret = -ENOMEM;
-		goto err_put_node;
-	}
-	priv->slave_mii_bus->priv = priv;
-	priv->slave_mii_bus->name = "SMI slave MII";
-	priv->slave_mii_bus->read = realtek_smi_mdio_read;
-	priv->slave_mii_bus->write = realtek_smi_mdio_write;
-	snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
-		 ds->index);
-	priv->slave_mii_bus->dev.of_node = mdio_np;
-	priv->slave_mii_bus->parent = priv->dev;
-	ds->slave_mii_bus = priv->slave_mii_bus;
-
-	ret = devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, mdio_np);
-	if (ret) {
-		dev_err(priv->dev, "unable to register MDIO bus %s\n",
-			priv->slave_mii_bus->id);
-		goto err_put_node;
-	}
-
-	return 0;
-
-err_put_node:
-	of_node_put(mdio_np);
-
-	return ret;
-}
-
 static int realtek_smi_probe(struct platform_device *pdev)
 {
 	const struct realtek_variant *var;
@@ -510,8 +449,14 @@ static int realtek_smi_probe(struct platform_device *pdev)
 				 mdio_np->full_name);
 		of_node_put(mdio_np);
 	} else {
-		priv->ds->ops = var->ds_ops_custom_slavemii;
-		priv->setup_interface = realtek_smi_setup_mdio;
+		mdio_np = of_get_compatible_child(priv->dev->of_node,
+						  "realtek,smi-mdio");
+		if (mdio_np) {
+			dev_err(priv->dev,
+				"Rename '%s' to 'mdio' and remove the compatible string\n",
+				mdio_np->full_name);
+			of_node_put(mdio_np);
+		}
 	}
 
 	ret = dsa_register_switch(priv->ds);
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 004a9ae91ccf..972a87be7e39 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -73,7 +73,6 @@ struct realtek_priv {
 	struct rtl8366_mib_counter *mib_counters;
 
 	const struct realtek_ops *ops;
-	int			(*setup_interface)(struct dsa_switch *ds);
 	int			(*write_reg_noack)(void *ctx, u32 addr, u32 data);
 
 	int			vlan_enabled;
@@ -110,13 +109,9 @@ struct realtek_ops {
 	int	(*enable_vlan)(struct realtek_priv *priv, bool enable);
 	int	(*enable_vlan4k)(struct realtek_priv *priv, bool enable);
 	int	(*enable_port)(struct realtek_priv *priv, int port, bool enable);
-	int	(*phy_read)(struct realtek_priv *priv, int phy, int regnum);
-	int	(*phy_write)(struct realtek_priv *priv, int phy, int regnum,
-			     u16 val);
 };
 
 struct realtek_variant {
-	const struct dsa_switch_ops *ds_ops_custom_slavemii;
 	const struct dsa_switch_ops *ds_ops;
 	const struct realtek_ops *ops;
 	unsigned int clk_delay;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 35fd32c4d340..bca4019f4fca 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1987,14 +1987,6 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 	if (ret)
 		goto out_teardown_irq;
 
-	if (priv->setup_interface) {
-		ret = priv->setup_interface(ds);
-		if (ret) {
-			dev_err(priv->dev, "could not set up MDIO bus\n");
-			goto out_teardown_irq;
-		}
-	}
-
 	/* Start statistics counter polling */
 	rtl8365mb_stats_setup(priv);
 
@@ -2086,25 +2078,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8365mb_switch_ops_custom_slavemii = {
-	.get_tag_protocol = rtl8365mb_get_tag_protocol,
-	.change_tag_protocol = rtl8365mb_change_tag_protocol,
-	.setup = rtl8365mb_setup,
-	.teardown = rtl8365mb_teardown,
-	.phylink_get_caps = rtl8365mb_phylink_get_caps,
-	.phylink_mac_config = rtl8365mb_phylink_mac_config,
-	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
-	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
-	.port_stp_state_set = rtl8365mb_port_stp_state_set,
-	.get_strings = rtl8365mb_get_strings,
-	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
-	.get_sset_count = rtl8365mb_get_sset_count,
-	.get_eth_phy_stats = rtl8365mb_get_phy_stats,
-	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
-	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
-	.get_stats64 = rtl8365mb_get_stats64,
-};
-
 static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.change_tag_protocol = rtl8365mb_change_tag_protocol,
@@ -2128,12 +2101,9 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 
 static const struct realtek_ops rtl8365mb_ops = {
 	.detect = rtl8365mb_detect,
-	.phy_read = rtl8365mb_phy_read,
-	.phy_write = rtl8365mb_phy_write,
 };
 
 const struct realtek_variant rtl8365mb_variant = {
-	.ds_ops_custom_slavemii = &rtl8365mb_switch_ops_custom_slavemii,
 	.ds_ops = &rtl8365mb_switch_ops,
 	.ops = &rtl8365mb_ops,
 	.clk_delay = 10,
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 7c3de3be3a53..d2f4ccaaf54f 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1030,14 +1030,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		dev_info(priv->dev, "no interrupt support\n");
 
-	if (priv->setup_interface) {
-		ret = priv->setup_interface(ds);
-		if (ret) {
-			dev_err(priv->dev, "could not set up MDIO bus\n");
-			return -ENODEV;
-		}
-	}
-
 	return 0;
 }
 
@@ -1793,29 +1785,6 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8366rb_switch_ops_custom_slavemii = {
-	.get_tag_protocol = rtl8366_get_tag_protocol,
-	.setup = rtl8366rb_setup,
-	.phylink_mac_link_up = rtl8366rb_mac_link_up,
-	.phylink_mac_link_down = rtl8366rb_mac_link_down,
-	.get_strings = rtl8366_get_strings,
-	.get_ethtool_stats = rtl8366_get_ethtool_stats,
-	.get_sset_count = rtl8366_get_sset_count,
-	.port_bridge_join = rtl8366rb_port_bridge_join,
-	.port_bridge_leave = rtl8366rb_port_bridge_leave,
-	.port_vlan_filtering = rtl8366rb_vlan_filtering,
-	.port_vlan_add = rtl8366_vlan_add,
-	.port_vlan_del = rtl8366_vlan_del,
-	.port_enable = rtl8366rb_port_enable,
-	.port_disable = rtl8366rb_port_disable,
-	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
-	.port_bridge_flags = rtl8366rb_port_bridge_flags,
-	.port_stp_state_set = rtl8366rb_port_stp_state_set,
-	.port_fast_age = rtl8366rb_port_fast_age,
-	.port_change_mtu = rtl8366rb_change_mtu,
-	.port_max_mtu = rtl8366rb_max_mtu,
-};
-
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
@@ -1853,12 +1822,9 @@ static const struct realtek_ops rtl8366rb_ops = {
 	.is_vlan_valid	= rtl8366rb_is_vlan_valid,
 	.enable_vlan	= rtl8366rb_enable_vlan,
 	.enable_vlan4k	= rtl8366rb_enable_vlan4k,
-	.phy_read	= rtl8366rb_phy_read,
-	.phy_write	= rtl8366rb_phy_write,
 };
 
 const struct realtek_variant rtl8366rb_variant = {
-	.ds_ops_custom_slavemii = &rtl8366rb_switch_ops_custom_slavemii,
 	.ds_ops = &rtl8366rb_switch_ops,
 	.ops = &rtl8366rb_ops,
 	.clk_delay = 10,
-- 
2.36.1

