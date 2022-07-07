Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C656ABE9
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiGGTiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 15:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGGTh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 15:37:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87232A70A
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 12:37:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id h23so34120494ejj.12
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 12:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y+Pd0C2Jgul09TUL3U/74kKKrdzHD+XdDczHatmVnZs=;
        b=IK3gzNI+jOL0G0of3wETHrg/P8KDzw6Ry651iZPE+2mMp5j3AAOhV72BfH4hKlJayv
         c3VLQpxTSCEORD0C3zQ7AB5b4UDKubO6zrKxhJtUzZXCfrALPTLmJCirlCA52jZ0Wal8
         VD48BckmSK8VokT/TlNXPv4RjHVA+n0DNK+E1QtnOmt3FB95fYEXRZnRdG52ttXLMcDA
         i/20boy/3DbbV3rz55Qdp1tPMPVvGPOLre19ZpKg2kdkmvoq8J6iZAueH0JHsWTh5WMK
         Ua9hvL0gcZ9CB0BW24HG4tJXA4pdRFWibGhG6YQRFj93biZ1HclXo54V8Lo3rq+AhmI9
         aLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+Pd0C2Jgul09TUL3U/74kKKrdzHD+XdDczHatmVnZs=;
        b=xP7OZ/T/iTS1GdlElfNcIDg+X+2SY3E2voX5agVCplQ77PCkFRWkM9nS4Xb8f/t4Tf
         QPHeP9axWGqKd/Uqvc28xnfcSS6UaWC2fohalNS4GzO1jE4uDZUhEKqvCRC0xp+1k1QE
         +SXkCZQM6m8azvd1Y2M9FGGb717VPQoMsDsxHSKzmE7+HG4lNXpgy5Ei6miT1urZ2W17
         Qgrfa60D6iRxFLqI9eWd7OR+jT1FVMIYyyYkpu6yjaNmuriShXlwhLg0mfRxWXhkdMuU
         CHO8LuJMEjL7kJdc8RvhGXQFsWmfQYX3rwnJmpyAjFeO37cp5wndINi7LPMLGrkStC2u
         l+3w==
X-Gm-Message-State: AJIora+jez99Ji+qo83qRi5mDCmg/o/TFgfhYlrBf/Ga6YvKZhBx3kyM
        Ek0ljjLLc1GWyTNu7DzKk7Q=
X-Google-Smtp-Source: AGRyM1viMS1WLe3J6Lfqog+t1VwZSwuFbxf1jMCYjES0tbSRvOTKBlGijGZWZzAKmcnlB/8LL6nqQw==
X-Received: by 2002:a17:907:6e26:b0:726:97af:9846 with SMTP id sd38-20020a1709076e2600b0072697af9846mr46805072ejc.300.1657222676241;
        Thu, 07 Jul 2022 12:37:56 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id s12-20020a170906354c00b0072637b9c8c0sm18493755eja.219.2022.07.07.12.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 12:37:55 -0700 (PDT)
Date:   Thu, 7 Jul 2022 22:37:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220707193753.2j67ni3or3bfkt6k@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
 <20220707163831.cjj54a6ys5bceb22@skbuf>
 <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 06:15:46PM +0100, Russell King (Oracle) wrote:
> > This is why dsa_port_phylink_register() calls phylink_of_phy_connect()
> > without checking whether it has a fixed-link or a PHY, because it
> > doesn't fail even if it doesn't do anything.
> > 
> > In fact I've wanted to make a correction to my previous phrasing that
> > "this function shouldn't be called if phylink_{,fwnode_}connect_phy() is
> > going to be called later". The correction is "... with a phy-handle".
> 
> I'm not sure that clarification makes sense when talking about
> phylink_connect_phy(), so I think if you're clarifying it with a
> firmware property, you're only talking about
> phylink_fwnode_connect_phy() now?

Yes, it's super hard to verbalize, and this is the reason why I didn't
add "... with a phy-handle" in the first place.

I wanted to say: phylink_connect_phy(), OR phylink_fwnode_connect_phy()
WITH a phy-handle. I shouldn't have conflated them in the first place.

> > > > Can phylink absorb all this logic, and automatically call phylink_set_max_fixed_link()
> > > > based on the following?
> > > > 
> > > > (1) struct phylink_config gets extended with a bool fallback_max_fixed_link.
> > > > (2) DSA CPU and DSA ports set this to true in dsa_port_phylink_register().
> > > > (3) phylink_set_max_fixed_link() is hooked into this -ENODEV error
> > > >     condition from phylink_fwnode_phy_connect():
> > > > 
> > > > 	phy_fwnode = fwnode_get_phy_node(fwnode);
> > > > 	if (IS_ERR(phy_fwnode)) {
> > > > 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> > > > 			return -ENODEV; <- here
> > > > 		return 0;
> > > > 	}
> > > 
> > > My question in response would be - why should this DSA specific behaviour
> > > be handled completely internally within phylink, when it's a DSA
> > > specific behaviour? Why do we need boolean flags for this?
> > 
> > Because the end result will be simpler if we respect the separation of
> > concerns that continues to exist, and it's still phylink's business to
> > say what is and isn't valid. DSA still isn't aware of the bindings
> > required by phylink, it just passes its fwnode to it. Practically
> > speaking, I wouldn't be scratching my head as to why we're checking for
> > half the prerequisites of phylink_set_max_fixed_link() in one place and
> > for the other half in another.
> > 
> > True, through this patch set DSA is creating its own context specific
> > extension of phylink bindings, but arguably those existed before DSA was
> > even integrated with phylink, and we're just fixing something now we
> > didn't realize at the time we'd need to do.
> > 
> > I can reverse the question, why would phylink even want to be involved
> > in how the max fixed link parameters are deduced, and it doesn't just
> > require that a fixed-link software node is constructed somehow
> > (irrelevant to phylink how), and phylink is just modified to find and
> > work with that if it exists? Isn't it for the exact same reason,
> > separation of concerns, that it's easiest for phylink to figure out what
> > is the most appropriate maximum fixed-link configuration?
> 
> If that could be done, I'd love it, because then we don't have this in
> phylink at all, and it can all be a DSA problem to solve. It also means
> that others won't be tempted to use the interface incorrectly.
> 
> I'm not sure how practical that is when we have both DT and ACPI to deal
> with, and ACPI is certainly out of my knowledge area to be able to
> construct a software node to specify a fixed-link. Maybe it can be done
> at the fwnode layer? I don't know.

I don't want to be misunderstood. I brought up software nodes because
I'm sure you must have thought about this too, before proposing what you
did here. And unless there's a technical reason against software nodes
(which there doesn't appear to be, but I don't want to get ahead of
myself), I figured you must be OK with phylink absorbing the logic, case
in which I just don't understand why you are pushing back on a proposal
how to make phylink absorb the logic completely.

> Do you have a handy example of what you're suggesting?

No, I didn't, but I thought, how hard can it be, and here's a hacked up
attempt on one of my boards:

From 5d002f03c91b357be304d41f7422969d0dd89f5b Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 7 Jul 2022 21:04:32 +0300
Subject: [PATCH] dsa_port_fixup_broken_dt

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts      |  5 --
 drivers/base/swnode.c                  | 14 +++-
 drivers/net/dsa/sja1105/sja1105_main.c |  4 +-
 include/linux/property.h               |  4 ++
 net/dsa/dsa_priv.h                     |  2 +-
 net/dsa/port.c                         | 99 +++++++++++++++++++++-----
 net/dsa/slave.c                        |  2 +-
 7 files changed, 100 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 1ea32fff4120..c577f90057c7 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -94,11 +94,6 @@ port@4 {
 				rx-internal-delay-ps = <0>;
 				tx-internal-delay-ps = <0>;
 				reg = <4>;
-
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
 			};
 		};
 	};
diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 0a482212c7e8..b2ea08f0e898 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -972,8 +972,9 @@ void software_node_unregister(const struct software_node *node)
 EXPORT_SYMBOL_GPL(software_node_unregister);
 
 struct fwnode_handle *
-fwnode_create_software_node(const struct property_entry *properties,
-			    const struct fwnode_handle *parent)
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name)
 {
 	struct fwnode_handle *fwnode;
 	struct software_node *node;
@@ -991,6 +992,7 @@ fwnode_create_software_node(const struct property_entry *properties,
 		return ERR_CAST(node);
 
 	node->parent = p ? p->node : NULL;
+	node->name = name;
 
 	fwnode = swnode_register(node, p, 1);
 	if (IS_ERR(fwnode))
@@ -998,6 +1000,14 @@ fwnode_create_software_node(const struct property_entry *properties,
 
 	return fwnode;
 }
+EXPORT_SYMBOL_GPL(fwnode_create_named_software_node);
+
+struct fwnode_handle *
+fwnode_create_software_node(const struct property_entry *properties,
+			    const struct fwnode_handle *parent)
+{
+	return fwnode_create_named_software_node(properties, parent, NULL);
+}
 EXPORT_SYMBOL_GPL(fwnode_create_software_node);
 
 void fwnode_remove_software_node(struct fwnode_handle *fwnode)
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b253e27bcfb4..6c7deebc8d76 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1218,8 +1218,8 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			if (!of_phy_is_fixed_link(child)) {
 				dev_err(dev, "phy-handle or fixed-link "
 					"properties missing!\n");
-				of_node_put(child);
-				return -ENODEV;
+//				of_node_put(child);
+//				return -ENODEV;
 			}
 			/* phy-handle is missing, but fixed-link isn't.
 			 * So it's a fixed link. Default to PHY role.
diff --git a/include/linux/property.h b/include/linux/property.h
index a5b429d623f6..23330ae2b1fa 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -492,6 +492,10 @@ void software_node_unregister(const struct software_node *node);
 struct fwnode_handle *
 fwnode_create_software_node(const struct property_entry *properties,
 			    const struct fwnode_handle *parent);
+struct fwnode_handle *
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name);
 void fwnode_remove_software_node(struct fwnode_handle *fwnode);
 
 int device_add_software_node(struct device *dev, const struct software_node *node);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..95c4e13e2dbf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -284,7 +284,7 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
-int dsa_port_phylink_create(struct dsa_port *dp);
+int dsa_port_phylink_create(struct dsa_port *dp, struct fwnode_handle *fwnode);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..4ed9075468f4 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1521,15 +1521,14 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.mac_link_up = dsa_port_phylink_mac_link_up,
 };
 
-int dsa_port_phylink_create(struct dsa_port *dp)
+int dsa_port_phylink_create(struct dsa_port *dp, struct fwnode_handle *fwnode)
 {
 	struct dsa_switch *ds = dp->ds;
 	phy_interface_t mode;
 	int err;
 
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err)
-		mode = PHY_INTERFACE_MODE_NA;
+	err = fwnode_get_phy_mode(fwnode);
+	mode = err < 0 ? PHY_INTERFACE_MODE_NA : err;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
 	 * an indicator of a legacy phylink driver.
@@ -1541,8 +1540,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
-				mode, &dsa_port_phylink_mac_ops);
+	dp->pl = phylink_create(&dp->pl_config, fwnode, mode,
+				&dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
 		return PTR_ERR(dp->pl);
@@ -1627,16 +1626,19 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
+	struct fwnode_handle *fwnode;
 	int err;
 
 	dp->pl_config.dev = ds->dev;
 	dp->pl_config.type = PHYLINK_DEV;
 
-	err = dsa_port_phylink_create(dp);
+	fwnode = port_dn->fwnode.secondary ? : of_fwnode_handle(port_dn);
+
+	err = dsa_port_phylink_create(dp, fwnode);
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_fwnode_phy_connect(dp->pl, fwnode, 0);
 	if (err && err != -ENODEV) {
 		pr_err("could not attach to PHY: %d\n", err);
 		goto err_phy_connect;
@@ -1649,23 +1651,82 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
+static int dsa_port_fixup_broken_dt(struct dsa_port *dp)
+{
+	struct property_entry fixed_link_props[] = {
+		PROPERTY_ENTRY_BOOL("full-duplex"),
+		PROPERTY_ENTRY_U32("speed", 1000), /* TODO determine actual speed */
+		{},
+	};
+	struct property_entry port_props[3] = {};
+	struct fwnode_handle *fixed_link_fwnode;
+	struct fwnode_handle *new_port_fwnode;
+	struct device_node *dn = dp->dn;
+	phy_interface_t mode;
+	int err;
+
+	if (of_parse_phandle(dn, "phy-handle", 0) ||
+	    of_phy_is_fixed_link(dn))
+		/* Nothing broken, nothing to fix.
+		 * TODO: As discussed with Russell, maybe phylink could provide
+		 * a more comprehensive helper to determine what constitutes a
+		 * valid fwnode binding than this guerilla kludge.
+		 */
+		return 0;
+
+	err = of_get_phy_mode(dn, &mode);
+	if (err)
+		/* TODO this may be missing too, ask the driver for the
+		 * max-speed interface mode for this port
+		 */
+		mode = PHY_INTERFACE_MODE_NA;
+
+	port_props[0] = PROPERTY_ENTRY_U32("reg", dp->index);
+	port_props[1] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
+
+	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
+	if (IS_ERR(new_port_fwnode))
+		return PTR_ERR(new_port_fwnode);
+
+	/* Node needs to be named so that phylink's call to
+	 * fwnode_get_named_child_node() finds it.
+	 */
+	fixed_link_fwnode = fwnode_create_named_software_node(fixed_link_props,
+							      new_port_fwnode,
+							      "fixed-link");
+	if (IS_ERR(fixed_link_fwnode)) {
+		fwnode_remove_software_node(new_port_fwnode);
+		return PTR_ERR(fixed_link_fwnode);
+	}
+
+	/* set_secondary_fwnode() takes a struct device as argument,
+	 * and we have none for a port. TODO we need to free this.
+	 */
+	dn->fwnode.secondary = new_port_fwnode;
+
+	return 0;
+}
+
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
 	int port = dp->index;
+	int err;
+
+	err = dsa_port_fixup_broken_dt(dp);
+	if (err) {
+		dev_err(ds->dev,
+			"Failed to fix up broken DT for shared port %d: %pe\n",
+			dp->index, ERR_PTR(err));
+		return err;
+	}
 
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
-			if (ds->ops->phylink_mac_link_down)
-				ds->ops->phylink_mac_link_down(ds, port,
-					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
-		}
-		of_node_put(phy_np);
-		return 0;
+		if (ds->ops->phylink_mac_link_down)
+			ds->ops->phylink_mac_link_down(ds, port, MLO_AN_FIXED,
+						       PHY_INTERFACE_MODE_NA);
+
+		return dsa_port_phylink_register(dp);
 	}
 
 	dev_warn(ds->dev,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..f243e73cb522 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2245,7 +2245,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		dp->pl_config.poll_fixed_state = true;
 	}
 
-	ret = dsa_port_phylink_create(dp);
+	ret = dsa_port_phylink_create(dp, of_fwnode_handle(dp->dn));
 	if (ret)
 		return ret;
 
-- 
2.25.1


It boots and works:

[    4.315754] sja1105 spi0.1: configuring for fixed/rgmii link mode
[    4.322653] sja1105 spi0.1 swp5 (uninitialized): PHY [mdio@2d24000:06] driver [Broadcom BCM5464] (irq=POLL)
[    4.334796] sja1105 spi0.1 swp2 (uninitialized): PHY [mdio@2d24000:03] driver [Broadcom BCM5464] (irq=POLL)
[    4.345853] sja1105 spi0.1 swp3 (uninitialized): PHY [mdio@2d24000:04] driver [Broadcom BCM5464] (irq=POLL)
[    4.356859] sja1105 spi0.1 swp4 (uninitialized): PHY [mdio@2d24000:05] driver [Broadcom BCM5464] (irq=POLL)
[    4.367245] device eth2 entered promiscuous mode
[    4.371864] DSA: tree 0 setup
[    4.376971] sja1105 spi0.1: Link is Up - 1Gbps/Full - flow control off
(...)
root@black:~# ip link set swp2 up && dhclient -i swp2 && ip addr show swp2
[   64.762756] fsl-gianfar soc:ethernet@2d90000 eth2: Link is Up - 1Gbps/Full - flow control off
[   64.771530] sja1105 spi0.1 swp2: configuring for phy/rgmii-id link mode
[   68.955048] sja1105 spi0.1 swp2: Link is Up - 1Gbps/Full - flow control off
12: swp2@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:1f:7b:63:02:48 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.68/24 brd 10.0.0.255 scope global dynamic swp2
       valid_lft 600sec preferred_lft 600sec

It's by far the messiest patch I've posted to the list (in the interest
of responding quickly), but if you study the code you can obviously see
what's missing, basically I've hardcoded the speed to 1000 and I'm
copying the phy-mode from the real DT node.

Unfortunately I don't have the time (and most importantly the interest)
in pushing this any further than that. If you want to take this from
here and integrate it with phylink_get_caps() I'd be glad to review
the result. Otherwise, feel free to continue with phylink_set_max_fixed_link().
