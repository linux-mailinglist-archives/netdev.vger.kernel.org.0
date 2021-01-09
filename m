Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7418D2EFBFA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbhAIADh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAIADe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0EFC061786
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:25 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id cm17so12921297edb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUkakTRUrylPdg+sWUBndvzR1CjNHRZ1z22KOPvmG+k=;
        b=Fi/nILXUo8Xj7oVCpz51R8zb4+DO12JR+Y3+va6VlTZ1Pdjsn7q9hxy9EgBhjg1Qz2
         82neLQ3n6CvXmgdxLQFHL2xiNSU9Svja6luTKGDHJmE+uTwiwpRgjjeBb3FD/D8SuBZU
         e0qxXxaBBJMC58l53ZvupgjYOpfGn3nifEdsY8FhteJhiyUkwQy0PR8QFljuNuxpjsZk
         I7qebQs91SKk3gguBS97VpFUbwSslqIfhBrKvr5tfoQ9OkK131us6siCe9m43EQO6Upm
         X0li/5p1Zn4a9GRIQANthPgXdynRs41TK8JtLD3k8raS+JyoX/eRw4Zn1GKnLqtJi489
         0j7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUkakTRUrylPdg+sWUBndvzR1CjNHRZ1z22KOPvmG+k=;
        b=i5VxJXVr3MO6ku7w1jxMVD9Fh7xSvtYBc2Z91ECf1nHMqQ6uCLqlROLNmSoQDbXLB9
         fbY5qmlHI3+5PHOz9hK32L3oMOSwpqgtg7sQi7/tj4AhGyCMPALjNpKAS98yIH7HJ4aP
         uSLKPd14pwg0x7VBknBkaWKPV5dYPO2wIj27cxRKeLrGmTw1mkCTJrVzfgXpOy6df4lZ
         zknoKUnfLPcrMfazSXGzTgB5xxURIYVZnUr23Mo1icmYPcssHhvXQ6FW3BbTvLhHRN3P
         CEbz+DVtFXW2mgUd9rhXy2Dtya5kJWb/p22MwNW9y30d/fcV5OXjZIa86XdyS2WQNFq8
         Xwtw==
X-Gm-Message-State: AOAM5338a7413H+S6E87b0K3cE4vLxeHtMLfui59n7PMOyfvMZ9ve3bo
        ipXPdqf8NUU1Smk7RAlbX0IhI0sBlGY=
X-Google-Smtp-Source: ABdhPJyKw+3hbfsfcZGuH4MU59USRAtr7ujEpX2dVMJ/gcSjxsCCzT7VEYtS1xlQNOxlEno7/f+lPA==
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr6944479edu.170.1610150544394;
        Fri, 08 Jan 2021 16:02:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 08/11] net: dsa: remove the transactional logic from VLAN objects
Date:   Sat,  9 Jan 2021 02:01:53 +0200
Message-Id: <20210109000156.1246735-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It should be the driver's business to logically separate its VLAN
offloading into a preparation and a commit phase, and some drivers don't
need / can't do this.

So remove the transactional shim from DSA and let drivers propagate
errors directly from the .port_vlan_add callback.

It would appear that the code has worse error handling now than it had
before. DSA is the only in-kernel user of switchdev that offloads one
switchdev object to more than one port: for every VLAN object offloaded
to a user port, that VLAN is also offloaded to the CPU port. So the
"prepare for user port -> check for errors -> prepare for CPU port ->
check for errors -> commit for user port -> commit for CPU port"
sequence appears to make more sense than the one we are using now:
"offload to user port -> check for errors -> offload to CPU port ->
check for errors", but it is really a compromise. In the new way, we can
catch errors from the commit phase that we previously had to ignore.
But we have our hands tied and cannot do any rollback now: if we add a
VLAN on the CPU port and it fails, we can't do the rollback by simply
deleting it from the user port, because the switchdev API is not so nice
with us: it could have simply been there already, even with the same
flags. So we don't even attempt to rollback anything on addition error,
just leave whatever VLANs managed to get offloaded right where they are.
This should not be a problem at all in practice.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v4:
- s/vid_end/vid in dsa_loop.
- Removed unused vid variable in hellcreek.

Changes in v3:
None.

Changes in v2:
- Rebased on top of the VLAN ranges removal.
- Propagating errors better now.

 drivers/net/dsa/b53/b53_common.c       | 17 ++++++----
 drivers/net/dsa/b53/b53_priv.h         |  6 ++--
 drivers/net/dsa/bcm_sf2.c              |  1 -
 drivers/net/dsa/bcm_sf2_cfp.c          |  7 ++--
 drivers/net/dsa/dsa_loop.c             | 28 ++++------------
 drivers/net/dsa/hirschmann/hellcreek.c | 12 +++++--
 drivers/net/dsa/lantiq_gswip.c         | 15 ++++++---
 drivers/net/dsa/microchip/ksz8795.c    |  7 ++--
 drivers/net/dsa/microchip/ksz9477.c    | 18 +++++++----
 drivers/net/dsa/microchip/ksz_common.c |  9 ------
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 drivers/net/dsa/mt7530.c               | 14 ++------
 drivers/net/dsa/mv88e6xxx/chip.c       | 34 ++++++++++++--------
 drivers/net/dsa/ocelot/felix.c         | 16 ++++++----
 drivers/net/dsa/qca8k.c                | 14 +++-----
 drivers/net/dsa/realtek-smi-core.h     |  6 ++--
 drivers/net/dsa/rtl8366.c              | 44 +++++++++++---------------
 drivers/net/dsa/rtl8366rb.c            |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 43 +++++++++----------------
 include/net/dsa.h                      |  4 +--
 net/dsa/switch.c                       |  8 ++---
 21 files changed, 133 insertions(+), 173 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 122636eb362e..26693b684bde 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1384,8 +1384,8 @@ int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 EXPORT_SYMBOL(b53_vlan_filtering);
 
-int b53_vlan_prepare(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan)
+static int b53_vlan_prepare(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct b53_device *dev = ds->priv;
 
@@ -1407,15 +1407,19 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 
 	return 0;
 }
-EXPORT_SYMBOL(b53_vlan_prepare);
 
-void b53_vlan_add(struct dsa_switch *ds, int port,
-		  const struct switchdev_obj_port_vlan *vlan)
+int b53_vlan_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct b53_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct b53_vlan *vl;
+	int err;
+
+	err = b53_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	vl = &dev->vlans[vlan->vid];
 
@@ -1438,6 +1442,8 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 			    vlan->vid);
 		b53_fast_age_vlan(dev, vlan->vid);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(b53_vlan_add);
 
@@ -2185,7 +2191,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_fast_age		= b53_br_fast_age,
 	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
-	.port_vlan_prepare	= b53_vlan_prepare,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
 	.port_fdb_dump		= b53_fdb_dump,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 224423ab0682..7cdf36755a2b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -348,10 +348,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     int speed, int duplex,
 			     bool tx_pause, bool rx_pause);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
-int b53_vlan_prepare(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan);
-void b53_vlan_add(struct dsa_switch *ds, int port,
-		  const struct switchdev_obj_port_vlan *vlan);
+int b53_vlan_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_vlan *vlan);
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 4c493bb47d30..e377ab142e41 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1113,7 +1113,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
-	.port_vlan_prepare	= b53_vlan_prepare,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
 	.port_fdb_dump		= b53_fdb_dump,
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 59d799ac1b60..ed45d16250e1 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -891,11 +891,9 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 		else
 			vlan.flags = 0;
 
-		ret = ds->ops->port_vlan_prepare(ds, port_num, &vlan);
+		ret = ds->ops->port_vlan_add(ds, port_num, &vlan);
 		if (ret)
 			return ret;
-
-		ds->ops->port_vlan_add(ds, port_num, &vlan);
 	}
 
 	/*
@@ -941,8 +939,7 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 		return -EINVAL;
 
 	if ((fs->flow_type & FLOW_EXT) &&
-	    !(ds->ops->port_vlan_prepare || ds->ops->port_vlan_add ||
-	      ds->ops->port_vlan_del))
+	    !(ds->ops->port_vlan_add || ds->ops->port_vlan_del))
 		return -EOPNOTSUPP;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 8e3d623f4dbd..be61ce93a377 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -198,26 +198,8 @@ static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-dsa_loop_port_vlan_prepare(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_vlan *vlan)
-{
-	struct dsa_loop_priv *ps = ds->priv;
-	struct mii_bus *bus = ps->bus;
-
-	dev_dbg(ds->dev, "%s: port: %d, vlan: %d", __func__, port, vlan->vid);
-
-	/* Just do a sleeping operation to make lockdep checks effective */
-	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
-
-	if (vlan->vid > ARRAY_SIZE(ps->vlans))
-		return -ERANGE;
-
-	return 0;
-}
-
-static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_vlan *vlan)
+static int dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
@@ -225,6 +207,9 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 	struct mii_bus *bus = ps->bus;
 	struct dsa_loop_vlan *vl;
 
+	if (vlan->vid > ARRAY_SIZE(ps->vlans))
+		return -ERANGE;
+
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
@@ -241,6 +226,8 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 
 	if (pvid)
 		ps->ports[port].pvid = vlan->vid;
+
+	return 0;
 }
 
 static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
@@ -300,7 +287,6 @@ static const struct dsa_switch_ops dsa_loop_driver = {
 	.port_bridge_leave	= dsa_loop_port_bridge_leave,
 	.port_stp_state_set	= dsa_loop_port_stp_state_set,
 	.port_vlan_filtering	= dsa_loop_port_vlan_filtering,
-	.port_vlan_prepare	= dsa_loop_port_vlan_prepare,
 	.port_vlan_add		= dsa_loop_port_vlan_add,
 	.port_vlan_del		= dsa_loop_port_vlan_del,
 	.port_change_mtu	= dsa_loop_port_change_mtu,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4e1dbf91720c..205249504289 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -438,18 +438,25 @@ static void hellcreek_unapply_vlan(struct hellcreek *hellcreek, int port,
 	mutex_unlock(&hellcreek->reg_lock);
 }
 
-static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_vlan *vlan)
+static int hellcreek_vlan_add(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct hellcreek *hellcreek = ds->priv;
+	int err;
+
+	err = hellcreek_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	dev_dbg(hellcreek->dev, "Add VLAN %d on port %d, %s, %s\n",
 		vlan->vid, port, untagged ? "untagged" : "tagged",
 		pvid ? "PVID" : "no PVID");
 
 	hellcreek_apply_vlan(hellcreek, port, vlan->vid, pvid, untagged);
+
+	return 0;
 }
 
 static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
@@ -1146,7 +1153,6 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_vlan_add	     = hellcreek_vlan_add,
 	.port_vlan_del	     = hellcreek_vlan_del,
 	.port_vlan_filtering = hellcreek_vlan_filtering,
-	.port_vlan_prepare   = hellcreek_vlan_prepare,
 	.setup		     = hellcreek_setup,
 };
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 805421f354eb..cc0b448d998e 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1167,13 +1167,18 @@ static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_vlan *vlan)
+static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	int err;
+
+	err = gswip_port_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	/* We have to receive all packets on the CPU port and should not
 	 * do any VLAN filtering here. This is also called with bridge
@@ -1181,9 +1186,10 @@ static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
 	 * this.
 	 */
 	if (dsa_is_cpu_port(ds, port))
-		return;
+		return 0;
 
-	gswip_vlan_add_aware(priv, bridge, port, vlan->vid, untagged, pvid);
+	return gswip_vlan_add_aware(priv, bridge, port, vlan->vid,
+				    untagged, pvid);
 }
 
 static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1579,7 +1585,6 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_bridge_leave	= gswip_port_bridge_leave,
 	.port_fast_age		= gswip_port_fast_age,
 	.port_vlan_filtering	= gswip_port_vlan_filtering,
-	.port_vlan_prepare	= gswip_port_vlan_prepare,
 	.port_vlan_add		= gswip_port_vlan_add,
 	.port_vlan_del		= gswip_port_vlan_del,
 	.port_stp_state_set	= gswip_port_stp_state_set,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 89e1c01cf5b8..d639f9476bd9 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -792,8 +792,8 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
@@ -828,6 +828,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 		vid |= new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
 	}
+
+	return 0;
 }
 
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1110,7 +1112,6 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.port_stp_state_set	= ksz8795_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz8795_port_vlan_filtering,
-	.port_vlan_prepare	= ksz_port_vlan_prepare,
 	.port_vlan_add		= ksz8795_port_vlan_add,
 	.port_vlan_del		= ksz8795_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 08bf54eb9f5f..71cf24f20252 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -510,16 +510,18 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	int err;
 
-	if (ksz9477_get_vlan_table(dev, vlan->vid, vlan_table)) {
+	err = ksz9477_get_vlan_table(dev, vlan->vid, vlan_table);
+	if (err) {
 		dev_dbg(dev->dev, "Failed to get vlan table\n");
-		return;
+		return err;
 	}
 
 	vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
@@ -531,14 +533,17 @@ static void ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 
 	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
 
-	if (ksz9477_set_vlan_table(dev, vlan->vid, vlan_table)) {
+	err = ksz9477_set_vlan_table(dev, vlan->vid, vlan_table);
+	if (err) {
 		dev_dbg(dev->dev, "Failed to set vlan table\n");
-		return;
+		return err;
 	}
 
 	/* change PVID */
 	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
 		ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
+
+	return 0;
 }
 
 static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1394,7 +1399,6 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_stp_state_set	= ksz9477_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
-	.port_vlan_prepare	= ksz_port_vlan_prepare,
 	.port_vlan_add		= ksz9477_port_vlan_add,
 	.port_vlan_del		= ksz9477_port_vlan_del,
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f2c9ff3ea4be..4e0619c66573 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -213,15 +213,6 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_port_fast_age);
 
-int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_vlan *vlan)
-{
-	/* nothing needed */
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ksz_port_vlan_prepare);
-
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a1f0929d45a0..f212775372ce 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -161,8 +161,6 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct net_device *br);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
-int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_vlan *vlan);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fcaddc9c9370..199a135125b2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1393,15 +1393,6 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-mt7530_port_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan)
-{
-	/* nothing needed */
-
-	return 0;
-}
-
 static void
 mt7530_hw_vlan_add(struct mt7530_priv *priv,
 		   struct mt7530_hw_vlan_entry *entry)
@@ -1489,7 +1480,7 @@ mt7530_hw_vlan_update(struct mt7530_priv *priv, u16 vid,
 	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, vid);
 }
 
-static void
+static int
 mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1510,6 +1501,8 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
 }
 
 static int
@@ -2608,7 +2601,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_fdb_del		= mt7530_port_fdb_del,
 	.port_fdb_dump		= mt7530_port_fdb_dump,
 	.port_vlan_filtering	= mt7530_port_vlan_filtering,
-	.port_vlan_prepare	= mt7530_port_vlan_prepare,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.port_mirror_add	= mt753x_port_mirror_add,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e9c517c0f89c..4aa7d0a8f197 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1617,9 +1617,6 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	err = mv88e6xxx_port_check_hw_vlan(ds, port, vlan->vid);
 	mv88e6xxx_reg_unlock(chip);
 
-	/* We don't need any dynamic resource from the kernel (yet),
-	 * so skip the prepare phase.
-	 */
 	return err;
 }
 
@@ -1963,17 +1960,19 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
-				    const struct switchdev_obj_port_vlan *vlan)
+static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
+				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	bool warn;
 	u8 member;
+	int err;
 
-	if (!mv88e6xxx_max_vid(chip))
-		return;
+	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
@@ -1989,15 +1988,25 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mv88e6xxx_port_vlan_join(chip, port, vlan->vid, member, warn))
+	err = mv88e6xxx_port_vlan_join(chip, port, vlan->vid, member, warn);
+	if (err) {
 		dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
 			vlan->vid, untagged ? 'u' : 't');
+		goto out;
+	}
 
-	if (pvid && mv88e6xxx_port_set_pvid(chip, port, vlan->vid))
-		dev_err(ds->dev, "p%d: failed to set PVID %d\n", port,
-			vlan->vid);
-
+	if (pvid) {
+		err = mv88e6xxx_port_set_pvid(chip, port, vlan->vid);
+		if (err) {
+			dev_err(ds->dev, "p%d: failed to set PVID %d\n",
+				port, vlan->vid);
+			goto out;
+		}
+	}
+out:
 	mv88e6xxx_reg_unlock(chip);
+
+	return err;
 }
 
 static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
@@ -5388,7 +5397,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
-	.port_vlan_prepare	= mv88e6xxx_port_vlan_prepare,
 	.port_vlan_add		= mv88e6xxx_port_vlan_add,
 	.port_vlan_del		= mv88e6xxx_port_vlan_del,
 	.port_fdb_add           = mv88e6xxx_port_fdb_add,
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2825dd11feee..768a74dc462a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -134,15 +134,20 @@ static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	return ocelot_port_vlan_filtering(ocelot, port, enabled);
 }
 
-static void felix_vlan_add(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_vlan *vlan)
+static int felix_vlan_add(struct dsa_switch *ds, int port,
+			  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
+	int err;
+
+	err = felix_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
-	ocelot_vlan_add(ocelot, port, vlan->vid,
-			flags & BRIDGE_VLAN_INFO_PVID,
-			flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	return ocelot_vlan_add(ocelot, port, vlan->vid,
+			       flags & BRIDGE_VLAN_INFO_PVID,
+			       flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
 static int felix_vlan_del(struct dsa_switch *ds, int port,
@@ -770,7 +775,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_bridge_join	= felix_bridge_join,
 	.port_bridge_leave	= felix_bridge_leave,
 	.port_stp_state_set	= felix_bridge_stp_state_set,
-	.port_vlan_prepare	= felix_vlan_prepare,
 	.port_vlan_filtering	= felix_vlan_filtering,
 	.port_vlan_add		= felix_vlan_add,
 	.port_vlan_del		= felix_vlan_del,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1de6473b221b..f54e8b6c8621 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1312,13 +1312,6 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 
 static int
-qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
-			const struct switchdev_obj_port_vlan *vlan)
-{
-	return 0;
-}
-
-static void
 qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 		    const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1328,8 +1321,10 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	int ret = 0;
 
 	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
-	if (ret)
+	if (ret) {
 		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+		return ret;
+	}
 
 	if (pvid) {
 		int shift = 16 * (port % 2);
@@ -1340,6 +1335,8 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 			    QCA8K_PORT_VLAN_CVID(vlan->vid) |
 			    QCA8K_PORT_VLAN_SVID(vlan->vid));
 	}
+
+	return 0;
 }
 
 static int
@@ -1382,7 +1379,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
-	.port_vlan_prepare	= qca8k_port_vlan_prepare,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
 	.phylink_validate	= qca8k_phylink_validate,
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index bc7bd47fb037..26376b052594 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -132,10 +132,8 @@ int rtl8366_reset_vlan(struct realtek_smi *smi);
 int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
 			   bool vlan_filtering);
-int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan);
-void rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan);
+int rtl8366_vlan_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_vlan *vlan);
 int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan);
 void rtl8366_get_strings(struct dsa_switch *ds, int port, u32 stringset,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 27f429aa89a6..3b24f2e13200 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -374,36 +374,26 @@ int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_filtering);
 
-int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan)
+int rtl8366_vlan_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_vlan *vlan)
 {
+	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
 	struct realtek_smi *smi = ds->priv;
+	u32 member = 0;
+	u32 untag = 0;
+	int ret;
 
 	if (!smi->ops->is_vlan_valid(smi, vlan->vid))
 		return -EINVAL;
 
-	dev_info(smi->dev, "prepare VLAN %04x\n", vlan->vid);
-
 	/* Enable VLAN in the hardware
 	 * FIXME: what's with this 4k business?
 	 * Just rtl8366_enable_vlan() seems inconclusive.
 	 */
-	return rtl8366_enable_vlan4k(smi, true);
-}
-EXPORT_SYMBOL_GPL(rtl8366_vlan_prepare);
-
-void rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan)
-{
-	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
-	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
-	struct realtek_smi *smi = ds->priv;
-	u32 member = 0;
-	u32 untag = 0;
-	int ret;
-
-	if (!smi->ops->is_vlan_valid(smi, vlan->vid))
-		return;
+	ret = rtl8366_enable_vlan4k(smi, true);
+	if (ret)
+		return ret;
 
 	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
 		 vlan->vid, port, untagged ? "untagged" : "tagged",
@@ -418,20 +408,22 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		untag |= BIT(port);
 
 	ret = rtl8366_set_vlan(smi, vlan->vid, member, untag, 0);
-	if (ret)
+	if (ret) {
 		dev_err(smi->dev, "failed to set up VLAN %04x", vlan->vid);
+		return ret;
+	}
 
 	if (!pvid)
-		return;
+		return 0;
 
 	ret = rtl8366_set_pvid(smi, port, vlan->vid);
-	if (ret)
+	if (ret) {
 		dev_err(smi->dev, "failed to set PVID on port %d to VLAN %04x",
 			port, vlan->vid);
+		return ret;
+	}
 
-	if (!ret)
-		dev_dbg(smi->dev, "VLAN add: added VLAN %d with PVID on port %d\n",
-			vlan->vid, port);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index cfe56960f44b..896978568716 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1504,7 +1504,6 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
 	.port_vlan_filtering = rtl8366_vlan_filtering,
-	.port_vlan_prepare = rtl8366_vlan_prepare,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
 	.port_enable = rtl8366rb_port_enable,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index be200d4289af..050b1260f358 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2600,26 +2600,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	return rc;
 }
 
-static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_vlan *vlan)
-{
-	struct sja1105_private *priv = ds->priv;
-
-	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
-		return 0;
-
-	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
-	 * bridge plus tagging), be sure to at least deny alterations to the
-	 * configuration done by dsa_8021q.
-	 */
-	if (vid_is_dsa_8021q(vlan->vid)) {
-		dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /* The TPID setting belongs to the General Parameters table,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
@@ -2779,26 +2759,34 @@ static int sja1105_vlan_del_one(struct dsa_switch *ds, int port, u16 vid,
 	return 0;
 }
 
-static void sja1105_vlan_add(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_vlan *vlan)
+static int sja1105_vlan_add(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
 	int rc;
 
+	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
+	 * bridge plus tagging), be sure to at least deny alterations to the
+	 * configuration done by dsa_8021q.
+	 */
+	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL &&
+	    vid_is_dsa_8021q(vlan->vid)) {
+		dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
+		return -EBUSY;
+	}
+
 	rc = sja1105_vlan_add_one(ds, port, vlan->vid, vlan->flags,
 				  &priv->bridge_vlans);
 	if (rc < 0)
-		return;
+		return rc;
 	if (rc > 0)
 		vlan_table_changed = true;
 
 	if (!vlan_table_changed)
-		return;
+		return 0;
 
-	rc = sja1105_build_vlan_table(priv, true);
-	if (rc)
-		dev_err(ds->dev, "Failed to build VLAN table: %d\n", rc);
+	return sja1105_build_vlan_table(priv, true);
 }
 
 static int sja1105_vlan_del(struct dsa_switch *ds, int port,
@@ -3277,7 +3265,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
 	.port_stp_state_set	= sja1105_bridge_stp_state_set,
-	.port_vlan_prepare	= sja1105_vlan_prepare,
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
 	.port_vlan_del		= sja1105_vlan_del,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b8c0550dfa74..c9a3dd7588df 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -566,10 +566,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
 				       bool vlan_filtering);
-	int (*port_vlan_prepare)(struct dsa_switch *ds, int port,
+	int	(*port_vlan_add)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
-	void (*port_vlan_add)(struct dsa_switch *ds, int port,
-			      const struct switchdev_obj_port_vlan *vlan);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	/*
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5f5e19c5e43a..f92eaacb17cf 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -227,21 +227,17 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 {
 	int port, err;
 
-	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
+	if (!ds->ops->port_vlan_add)
 		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = ds->ops->port_vlan_prepare(ds, port, info->vlan);
+			err = ds->ops->port_vlan_add(ds, port, info->vlan);
 			if (err)
 				return err;
 		}
 	}
 
-	for (port = 0; port < ds->num_ports; port++)
-		if (dsa_switch_vlan_match(ds, port, info))
-			ds->ops->port_vlan_add(ds, port, info->vlan);
-
 	return 0;
 }
 
-- 
2.25.1

