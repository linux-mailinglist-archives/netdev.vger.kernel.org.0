Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFDA31A8B3
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhBMAQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBMAPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:52 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154C7C061794
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:38 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lg21so2083530ejb.3
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GuwuArJloYYLrD4REsWS+UHCxUSfZVBRRaUhVCSd3HI=;
        b=SQKzbPD75hMLTOHGl01G9ZuhkbyrAwOZ6E9ydWZxHnp6WZOdL1OQxcPosRgupxMJ+E
         946kNzWSh+4isl4Duz8Is8Xuh6ac62Xjge6XlGPofNX5oKK9i4N70e0lg/AiKp2Dekay
         1umdsPWono8D4WU4ey6YOcscSk8hpqBzh08xGGsSQVvTiJZYODA7eBMhr4MC06IdlIkQ
         S4vvsrsrAb7U8df2rQoynZhlinXfgAZ4dTUByVSylKz6ejY2lXo3TotGJyUNmFsiFRNi
         zYmEWo+uNlq6y9sbzuXjgNcSkoWJ7sgtBXcXTRpBqJxE3kSVK0024fhq+pGVyHZDxZJG
         9YSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GuwuArJloYYLrD4REsWS+UHCxUSfZVBRRaUhVCSd3HI=;
        b=Zw3b9hhEt7ZqOwkkCSXXYEtksMjafjzpr8mOYaWMJG/CLSW6leCUsOTeuXBfV4fwV4
         E0MDfJsdAHyHCZkJLpGgDbXyp2B9ZZWBxziPQY7aLDV+d39Is/+taUKwqzgGgt0LtenG
         4k52b8DFiyyf1tM4DlN3HqysrfWkGWoWgjhgjv6EIt+OHxBVBFGOEpu38DLohA4JYO0F
         83VMWSa5B2/0ZSjU2xsSqNqXR/8r2LHUenaXcYoT0nEoF6A3BaeH1Bd9wC3X1dAjPKe6
         udSjJkmHORokzEYU06L7st0pGL8ETCiluKmUmIUcX5VwzH7UT3CrQPr4waN5drCJKKGP
         AcaA==
X-Gm-Message-State: AOAM53129A+toD19trKwWhE8fjD2jdG5mdQbEYTDcR14f2xgG4jJmFvq
        fst+trjXE6kDrQ1JscQQASU=
X-Google-Smtp-Source: ABdhPJyPIQu/8yOYbC4Jp7B+gV29gEZSc9l25f2TcVZK87rgAU4NuQAhdH/I2on87wa5VlL1S4KUdw==
X-Received: by 2002:a17:906:46ce:: with SMTP id k14mr5443708ejs.480.1613175276788;
        Fri, 12 Feb 2021 16:14:36 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 09/12] net: dsa: tag_ocelot: create separate tagger for Seville
Date:   Sat, 13 Feb 2021 02:14:09 +0200
Message-Id: <20210213001412.4154051-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot tagger is a hot mess currently, it relies on memory
initialized by the attached driver for basic frame transmission.
This is against all that DSA tagging protocols stand for, which is that
the transmission and reception of a DSA-tagged frame, the data path,
should be independent from the switch control path, because the tag
protocol is in principle hot-pluggable and reusable across switches
(even if in practice it wasn't until very recently). But if another
driver like dsa_loop wants to make use of tag_ocelot, it couldn't.

This was done to have common code between Felix and Ocelot, which have
one bit difference in the frame header format. Quoting from commit
67c2404922c2 ("net: dsa: felix: create a template for the DSA tags on
xmit"):

    Other alternatives have been analyzed, such as:
    - Create a separate tag_seville.c: too much code duplication for just 1
      bit field difference.
    - Create a separate DSA_TAG_PROTO_SEVILLE under tag_ocelot.c, just like
      tag_brcm.c, which would have a separate .xmit function. Again, too
      much code duplication for just 1 bit field difference.
    - Allocate the template from the init function of the tag_ocelot.c
      module, instead of from the driver: couldn't figure out a method of
      accessing the correct port template corresponding to the correct
      tagger in the .xmit function.

The really interesting part is that Seville should have had its own
tagging protocol defined - it is not compatible on the wire with Ocelot,
even for that single bit. In principle, a packet generated by
DSA_TAG_PROTO_OCELOT when booted on NXP LS1028A would look in a certain
way, but when booted on NXP T1040 it would look differently. The reverse
is also true: a packet generated by a Seville switch would be
interpreted incorrectly by Wireshark if it was told it was generated by
an Ocelot switch.

Actually things are a bit more nuanced. If we concentrate only on the
DSA tag, what I said above is true, but Ocelot/Seville also support an
optional DSA tag prefix, which can be short or long, and it is possible
to distinguish the two taggers based on an integer constant put in that
prefix. Nonetheless, creating a separate tagger is still justified,
since the tag prefix is optional, and without it, there is again no way
to distinguish.

Claiming backwards binary compatibility is a bit more tough, since I've
already changed the format of tag_ocelot once, in commit 5124197ce58b
("net: dsa: tag_ocelot: use a short prefix on both ingress and egress").
Therefore I am not very concerned with treating this as a bugfix and
backporting it to stable kernels (which would be another mess due to the
fact that there would be lots of conflicts with the other DSA_TAG_PROTO*
definitions). It's just simpler to say that the string values of the
taggers have ABI value starting with kernel 5.12, which will be when the
changing of tag protocol via /sys/class/net/<dsa-master>/dsa/tagging
goes live.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 18 ++-----
 drivers/net/dsa/ocelot/felix.h           |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 26 ---------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 28 +---------
 include/linux/dsa/ocelot.h               | 10 ++++
 include/net/dsa.h                        |  2 +
 net/dsa/tag_ocelot.c                     | 68 ++++++++++++++++++------
 7 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4af1187f4d69..f294f5f62505 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -431,6 +431,7 @@ static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
 	int err;
 
 	switch (proto) {
+	case DSA_TAG_PROTO_SEVILLE:
 	case DSA_TAG_PROTO_OCELOT:
 		err = felix_setup_tag_npi(ds, cpu);
 		break;
@@ -448,6 +449,7 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
 				   enum dsa_tag_protocol proto)
 {
 	switch (proto) {
+	case DSA_TAG_PROTO_SEVILLE:
 	case DSA_TAG_PROTO_OCELOT:
 		felix_teardown_tag_npi(ds, cpu);
 		break;
@@ -471,7 +473,8 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
 	int err;
 
-	if (proto != DSA_TAG_PROTO_OCELOT &&
+	if (proto != DSA_TAG_PROTO_SEVILLE &&
+	    proto != DSA_TAG_PROTO_OCELOT &&
 	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
@@ -1003,7 +1006,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		struct regmap *target;
-		u8 *template;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -1029,22 +1031,10 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return PTR_ERR(target);
 		}
 
-		template = devm_kzalloc(ocelot->dev, OCELOT_TOTAL_TAG_LEN,
-					GFP_KERNEL);
-		if (!template) {
-			dev_err(ocelot->dev,
-				"Failed to allocate memory for DSA tag\n");
-			kfree(port_phy_modes);
-			return -ENOMEM;
-		}
-
 		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
 		ocelot_port->target = target;
-		ocelot_port->xmit_template = template;
 		ocelot->ports[port] = ocelot_port;
-
-		felix->info->xmit_template_populate(ocelot, port);
 	}
 
 	kfree(port_phy_modes);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9d4459f2fffb..b2ea425c5803 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -34,7 +34,6 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
-	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index cacc6f9c0113..32b885fcaf90 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1339,31 +1339,6 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	}
 }
 
-static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u8 *template = ocelot_port->xmit_template;
-	u64 bypass, dest, src;
-	__be32 *prefix;
-	u8 *injection;
-
-	/* Set the source port as the CPU port module and not the
-	 * NPI port
-	 */
-	src = ocelot->num_phys_ports;
-	dest = BIT(port);
-	bypass = true;
-
-	injection = template + OCELOT_SHORT_PREFIX_LEN;
-	prefix = (__be32 *)template;
-
-	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &dest,    68,  56, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
-
-	*prefix = cpu_to_be32(0x8880000a);
-}
-
 static const struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
@@ -1386,7 +1361,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
-	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index d7348ea4831e..84f93a874d50 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1165,31 +1165,6 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_unregister(felix->imdio);
 }
 
-static void vsc9953_xmit_template_populate(struct ocelot *ocelot, int port)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u8 *template = ocelot_port->xmit_template;
-	u64 bypass, dest, src;
-	__be32 *prefix;
-	u8 *injection;
-
-	/* Set the source port as the CPU port module and not the
-	 * NPI port
-	 */
-	src = ocelot->num_phys_ports;
-	dest = BIT(port);
-	bypass = true;
-
-	injection = template + OCELOT_SHORT_PREFIX_LEN;
-	prefix = (__be32 *)template;
-
-	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &dest,    67,  57, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
-
-	*prefix = cpu_to_be32(0x88800005);
-}
-
 static const struct felix_info seville_info_vsc9953 = {
 	.target_io_res		= vsc9953_target_io_res,
 	.port_io_res		= vsc9953_port_io_res,
@@ -1206,7 +1181,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
-	.xmit_template_populate	= vsc9953_xmit_template_populate,
 };
 
 static int seville_probe(struct platform_device *pdev)
@@ -1246,7 +1220,7 @@ static int seville_probe(struct platform_device *pdev)
 	ds->ops = &felix_switch_ops;
 	ds->priv = ocelot;
 	felix->ds = ds;
-	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
+	felix->tag_proto = DSA_TAG_PROTO_SEVILLE;
 
 	err = dsa_register_switch(ds);
 	if (err) {
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index add2b38a2c76..59eadd73289a 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -195,6 +195,16 @@ static inline void ocelot_ifh_set_qos_class(void *injection, u64 qos_class)
 	packing(injection, &qos_class, 19, 17, OCELOT_TAG_LEN, PACK, 0);
 }
 
+static inline void seville_ifh_set_dest(void *injection, u64 dest)
+{
+	packing(injection, &dest, 67, 57, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_src(void *injection, u64 src)
+{
+	packing(injection, &src, 46, 43, OCELOT_TAG_LEN, PACK, 0);
+}
+
 static inline void ocelot_ifh_set_tag_type(void *injection, u64 tag_type)
 {
 	packing(injection, &tag_type, 16, 16, OCELOT_TAG_LEN, PACK, 0);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 74457aaffec7..b095ef114fe8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -48,6 +48,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_HELLCREEK_VALUE		18
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
+#define DSA_TAG_PROTO_SEVILLE_VALUE		21
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -71,6 +72,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
+	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index fe00519229d7..a7dd61c8e005 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -24,33 +24,52 @@ static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
 	ocelot_ifh_set_rew_op(injection, rew_op);
 }
 
-static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
-				   struct net_device *netdev)
+static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
+			       __be32 ifh_prefix, void **ifh)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
 	struct dsa_switch *ds = dp->ds;
-	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port;
-	u8 *prefix, *injection;
-
-	ocelot_port = ocelot->ports[dp->index];
+	void *injection;
+	__be32 *prefix;
 
 	injection = skb_push(skb, OCELOT_TAG_LEN);
-
 	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
 
-	memcpy(prefix, ocelot_port->xmit_template, OCELOT_TOTAL_TAG_LEN);
-
-	/* Fix up the fields which are not statically determined
-	 * in the template
-	 */
+	*prefix = ifh_prefix;
+	memset(injection, 0, OCELOT_TAG_LEN);
+	ocelot_ifh_set_bypass(injection, 1);
+	ocelot_ifh_set_src(injection, ds->num_ports);
 	ocelot_ifh_set_qos_class(injection, skb->priority);
 
 	/* TX timestamping was requested */
 	if (clone)
 		ocelot_xmit_ptp(dp, injection, clone);
 
+	*ifh = injection;
+}
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	void *injection;
+
+	ocelot_xmit_common(skb, netdev, cpu_to_be32(0x8880000a), &injection);
+	ocelot_ifh_set_dest(injection, BIT(dp->index));
+
+	return skb;
+}
+
+static struct sk_buff *seville_xmit(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	void *injection;
+
+	ocelot_xmit_common(skb, netdev, cpu_to_be32(0x88800005), &injection);
+	seville_ifh_set_dest(injection, BIT(dp->index));
+
 	return skb;
 }
 
@@ -147,7 +166,26 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 	.promisc_on_master	= true,
 };
 
-MODULE_LICENSE("GPL v2");
+DSA_TAG_DRIVER(ocelot_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT);
 
-module_dsa_tag_driver(ocelot_netdev_ops);
+static const struct dsa_device_ops seville_netdev_ops = {
+	.name			= "seville",
+	.proto			= DSA_TAG_PROTO_SEVILLE,
+	.xmit			= seville_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.promisc_on_master	= true,
+};
+
+DSA_TAG_DRIVER(seville_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SEVILLE);
+
+static struct dsa_tag_driver *ocelot_tag_driver_array[] = {
+	&DSA_TAG_DRIVER_NAME(ocelot_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(seville_netdev_ops),
+};
+
+module_dsa_tag_drivers(ocelot_tag_driver_array);
+
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

