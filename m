Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8A31A174
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBLPSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhBLPRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:17:33 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ED3C06178B;
        Fri, 12 Feb 2021 07:16:19 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g21so73704edm.6;
        Fri, 12 Feb 2021 07:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RdbgZt6+Ejd8o9yX3QH8zWAkNieI+hNY0rfhSAt45Bg=;
        b=SZqqc5U/A86HM9bbdAwU6IRRcZjOIhiKBcMd60KQiyl67X4+lFWyizRLdlyTr0heMq
         hyY47CFilr2OtOd1PNgUEN8fuWxRN7joWgMpIZt7SdXuk557EX+0cAoAHuMy+/cY3SsF
         e9VL3MJlJx8k3PGklOaCuo1CArEuh9vL+g0K0QYvPHO9Cwa750OrQABUqgh1OO+oHKIl
         7zqEWoJFs7xJDQplndQHiUYI4QZCQwvWrG8KQ13Uv2Uul3Jj8Ukff7Le1dQzyKCobykM
         OAzqwwU6numx1g3vmRXLtndhrnCo25LT0LAN+mlCqxev676Z2u3vBF0kqo1i2JdP8Qwp
         ThIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RdbgZt6+Ejd8o9yX3QH8zWAkNieI+hNY0rfhSAt45Bg=;
        b=Q+JzTixGzQOGua9HBQgSIu3cBL6rFVQV7Of7pAd1nh+LPlU1XzrD0kYTZfFVTXcNvB
         ftqb7NfA/+YcDucmm19XoV/dlSusi3uAG5S3O/PUPXMWaDfFXyATlnnKwjMyVnLqOSXi
         1Ex00u0A7tuHDS+C2vxtyELH76+flEF9VuMxoFVGCSe5+GpiQxunf4tmVEDRwkBpHLI0
         N3MJNEKcto1y1F8t524wMXOfKrXqbuegKFoOmVD0U1XkUEYhQnLLMJy2TvpkHTt9JB3P
         F4eF0nsAixY9wA3BophQzJ4lSJXhCsNUAl8vKe/rr8t+n7g7qvNAxMRJE9qdSogm7gYv
         jMwg==
X-Gm-Message-State: AOAM533lafiq2Yv1P6HbrwSN1xB6kOMv0n356G0NkTVx1lXsEfJnOJsN
        NdqjGy+a+pN/cK5STEvDbhA=
X-Google-Smtp-Source: ABdhPJwVY5bOoX+1HU+OD7DdvciDxZJr8jB/ArPHGd8J6J5S9bwr+FmI5cLUoej5auN6QMhY0zizzQ==
X-Received: by 2002:a50:f318:: with SMTP id p24mr3898968edm.13.1613142977881;
        Fri, 12 Feb 2021 07:16:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 06/10] net: dsa: act as passthrough for bridge port flags
Date:   Fri, 12 Feb 2021 17:15:56 +0200
Message-Id: <20210212151600.3357121-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are multiple ways in which a PORT_BRIDGE_FLAGS attribute can be
expressed by the bridge through switchdev, and not all of them can be
emulated by DSA mid-layer API at the same time.

One possible configuration is when the bridge offloads the port flags
using a mask that has a single bit set - therefore only one feature
should change. However, DSA currently groups together unicast and
multicast flooding in the .port_egress_floods method, which limits our
options when we try to add support for turning off broadcast flooding:
do we extend .port_egress_floods with a third parameter which b53 and
mv88e6xxx will ignore? But that means that the DSA layer, which
currently implements the PRE_BRIDGE_FLAGS attribute all by itself, will
see that .port_egress_floods is implemented, and will report that all 3
types of flooding are supported - not necessarily true.

Another configuration is when the user specifies more than one flag at
the same time, in the same netlink message. If we were to create one
individual function per offloadable bridge port flag, we would limit the
expressiveness of the switch driver of refusing certain combinations of
flag values. For example, a switch may not have an explicit knob for
flooding of unknown multicast, just for flooding in general. In that
case, the only correct thing to do is to allow changes to BR_FLOOD and
BR_MCAST_FLOOD in tandem, and never allow mismatched values. But having
a separate .port_set_unicast_flood and .port_set_multicast_flood would
not allow the driver to possibly reject that.

Also, DSA doesn't consider it necessary to inform the driver that a
SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute was offloaded, because it
just calls .port_egress_floods for the CPU port. When we'll add support
for the plain SWITCHDEV_ATTR_ID_PORT_MROUTER, that will become a real
problem because the flood settings will need to be held statefully in
the DSA middle layer, otherwise changing the mrouter port attribute will
impact the flooding attribute. And that's _assuming_ that the underlying
hardware doesn't have anything else to do when a multicast router
attaches to a port than flood unknown traffic to it.  If it does, there
will need to be a dedicated .port_set_mrouter anyway.

So we need to let the DSA drivers see the exact form that the bridge
passes this switchdev attribute in, otherwise we are standing in the
way. Therefore we also need to use this form of language when
communicating to the driver that it needs to configure its initial
(before bridge join) and final (after bridge leave) port flags.

The b53 and mv88e6xxx drivers are converted to the passthrough API and
their implementation of .port_egress_floods is split into two: a
function that configures unicast flooding and another for multicast.
The mv88e6xxx implementation is quite hairy, and it turns out that
the implementations of unknown unicast flooding are actually the same
for 6185 and for 6352:

behind the confusing names actually lie two individual bits:
NO_UNKNOWN_MC -> FLOOD_UC = 0x4 = BIT(2)
NO_UNKNOWN_UC -> FLOOD_MC = 0x8 = BIT(3)

so there was no reason to entangle them in the first place.

Whereas the 6185 writes to MV88E6185_PORT_CTL0_FORWARD_UNKNOWN of
PORT_CTL0, which has the exact same bit index. I have left the
implementations separate though, for the only reason that the names are
different enough to confuse me, since I am not able to double-check with
a user manual. The multicast flooding setting for 6185 is in a different
register than for 6352 though.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Adjust commit title.

Changes in v4:
- Adjust commit title and message.
- Reintroduce the .port_pre_bridge_flags method.
- Split the unicast and multicast flooding settings in mv88e6xxx and b53.

Changes in v3:
- Pass extack through the newly introduce dsa_port_change_brport_flags.

Changes in v2:
- Reordered with previous patch such that we don't need to introduce
  .port_pre_bridge_flags
- Pass extack to drivers.

 drivers/net/dsa/b53/b53_common.c |  91 ++++++++++++-----
 drivers/net/dsa/b53/b53_priv.h   |   2 -
 drivers/net/dsa/mv88e6xxx/chip.c | 163 ++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c |  52 +++++-----
 drivers/net/dsa/mv88e6xxx/port.h |  19 ++--
 include/net/dsa.h                |  10 +-
 net/dsa/dsa_priv.h               |   9 +-
 net/dsa/port.c                   |  31 +++---
 net/dsa/slave.c                  |   7 +-
 10 files changed, 263 insertions(+), 127 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 23fc7225c8d1..72c75c7bdb65 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -510,6 +510,39 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 }
 EXPORT_SYMBOL(b53_imp_vlan_setup);
 
+static void b53_port_set_ucast_flood(struct b53_device *dev, int port,
+				     bool unicast)
+{
+	u16 uc;
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, &uc);
+	if (unicast)
+		uc |= BIT(port);
+	else
+		uc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, uc);
+}
+
+static void b53_port_set_mcast_flood(struct b53_device *dev, int port,
+				     bool multicast)
+{
+	u16 mc;
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, &mc);
+	if (multicast)
+		mc |= BIT(port);
+	else
+		mc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, mc);
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, &mc);
+	if (multicast)
+		mc |= BIT(port);
+	else
+		mc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, mc);
+}
+
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct b53_device *dev = ds->priv;
@@ -522,7 +555,8 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
-	b53_br_egress_floods(ds, port, true, true);
+	b53_port_set_ucast_flood(dev, port, true);
+	b53_port_set_mcast_flood(dev, port, true);
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -655,7 +689,8 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 
 	b53_brcm_hdr_setup(dev->ds, port);
 
-	b53_br_egress_floods(dev->ds, port, true, true);
+	b53_port_set_ucast_flood(dev, port, true);
+	b53_port_set_mcast_flood(dev, port, true);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1916,37 +1951,37 @@ void b53_br_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_br_fast_age);
 
-int b53_br_egress_floods(struct dsa_switch *ds, int port,
-			 bool unicast, bool multicast)
+static int b53_br_flags_pre(struct dsa_switch *ds, int port,
+			    struct switchdev_brport_flags flags,
+			    struct netlink_ext_ack *extack)
 {
-	struct b53_device *dev = ds->priv;
-	u16 uc, mc;
-
-	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, &uc);
-	if (unicast)
-		uc |= BIT(port);
-	else
-		uc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, uc);
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, &mc);
-	if (multicast)
-		mc |= BIT(port);
-	else
-		mc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, mc);
+	return 0;
+}
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, &mc);
-	if (multicast)
-		mc |= BIT(port);
-	else
-		mc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, mc);
+static int b53_br_flags(struct dsa_switch *ds, int port,
+			struct switchdev_brport_flags flags,
+			struct netlink_ext_ack *extack)
+{
+	if (flags.mask & BR_FLOOD)
+		b53_port_set_ucast_flood(ds->priv, port,
+					 !!(flags.val & BR_FLOOD));
+	if (flags.mask & BR_MCAST_FLOOD)
+		b53_port_set_mcast_flood(ds->priv, port,
+					 !!(flags.val & BR_MCAST_FLOOD));
 
 	return 0;
+}
 
+static int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
+			   struct netlink_ext_ack *extack)
+{
+	b53_port_set_mcast_flood(ds->priv, port, mrouter);
+
+	return 0;
 }
-EXPORT_SYMBOL(b53_br_egress_floods);
 
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
@@ -2187,9 +2222,11 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
+	.port_pre_bridge_flags	= b53_br_flags_pre,
+	.port_bridge_flags	= b53_br_flags,
+	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
-	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 0d2cc0453bef..ae72ef46b0b6 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -326,8 +326,6 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
-int b53_br_egress_floods(struct dsa_switch *ds, int port,
-			 bool unicast, bool multicast);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ae0b490f00cd..0ef1fadfec68 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2434,12 +2434,20 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
 	bool flood;
+	int err;
 
 	/* Upstream ports flood frames with unknown unicast or multicast DA */
 	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
-	if (chip->info->ops->port_set_egress_floods)
-		return chip->info->ops->port_set_egress_floods(chip, port,
-							       flood, flood);
+	if (chip->info->ops->port_set_ucast_flood) {
+		err = chip->info->ops->port_set_ucast_flood(chip, port, flood);
+		if (err)
+			return err;
+	}
+	if (chip->info->ops->port_set_mcast_flood) {
+		err = chip->info->ops->port_set_mcast_flood(chip, port, flood);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
@@ -3239,7 +3247,8 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
@@ -3278,7 +3287,8 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.port_sync_link = mv88e6185_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6185_port_set_forward_unknown,
+	.port_set_mcast_flood = mv88e6185_port_set_default_forward,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3313,7 +3323,8 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
@@ -3357,7 +3368,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6185_port_get_cmode,
@@ -3393,7 +3405,8 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6185_port_set_forward_unknown,
+	.port_set_mcast_flood = mv88e6185_port_set_default_forward,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
@@ -3437,7 +3450,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3487,7 +3501,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3565,7 +3580,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3609,7 +3625,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3660,7 +3677,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3704,7 +3722,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -3755,7 +3774,8 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_sync_link = mv88e6185_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6185_port_set_forward_unknown,
+	.port_set_mcast_flood = mv88e6185_port_set_default_forward,
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_pause = mv88e6185_port_set_pause,
@@ -3800,7 +3820,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_pause_limit = mv88e6390_port_pause_limit,
@@ -3860,7 +3881,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_pause_limit = mv88e6390_port_pause_limit,
@@ -3919,7 +3941,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3979,7 +4002,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4037,7 +4061,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.port_set_speed_duplex = mv88e6250_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
@@ -4077,7 +4102,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -4136,7 +4162,8 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4179,7 +4206,8 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4222,7 +4250,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4275,7 +4304,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4316,7 +4346,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4362,7 +4393,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4424,7 +4456,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -4488,7 +4521,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
-	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
@@ -5364,17 +5398,72 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 	mutex_unlock(&chip->reg_lock);
 }
 
-static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
-					 bool unicast, bool multicast)
+static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+					   struct switchdev_brport_flags flags,
+					   struct netlink_ext_ack *extack)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	const struct mv88e6xxx_ops *ops;
+
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	ops = chip->info->ops;
+
+	if ((flags.mask & BR_FLOOD) && !ops->port_set_ucast_flood)
+		return -EINVAL;
+
+	if ((flags.mask & BR_MCAST_FLOOD) && !ops->port_set_mcast_flood)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
+				       struct switchdev_brport_flags flags,
+				       struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err = -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
-	if (chip->info->ops->port_set_egress_floods)
-		err = chip->info->ops->port_set_egress_floods(chip, port,
-							      unicast,
-							      multicast);
+
+	if (flags.mask & BR_FLOOD) {
+		bool unicast = !!(flags.val & BR_FLOOD);
+
+		err = chip->info->ops->port_set_ucast_flood(chip, port,
+							    unicast);
+		if (err)
+			goto out;
+	}
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
+
+		err = chip->info->ops->port_set_mcast_flood(chip, port,
+							    multicast);
+		if (err)
+			goto out;
+	}
+
+out:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
+				      bool mrouter,
+				      struct netlink_ext_ack *extack)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	if (!chip->info->ops->port_set_mcast_flood)
+		return -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+	err = chip->info->ops->port_set_mcast_flood(chip, port, mrouter);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -5678,7 +5767,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
 	.port_bridge_join	= mv88e6xxx_port_bridge_join,
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
-	.port_egress_floods	= mv88e6xxx_port_egress_floods,
+	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
+	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
+	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 788b3f585ef3..a57c8886f3ac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -454,8 +454,10 @@ struct mv88e6xxx_ops {
 
 	int (*port_set_frame_mode)(struct mv88e6xxx_chip *chip, int port,
 				   enum mv88e6xxx_frame_mode mode);
-	int (*port_set_egress_floods)(struct mv88e6xxx_chip *chip, int port,
-				      bool unicast, bool multicast);
+	int (*port_set_ucast_flood)(struct mv88e6xxx_chip *chip, int port,
+				    bool unicast);
+	int (*port_set_mcast_flood)(struct mv88e6xxx_chip *chip, int port,
+				    bool multicast);
 	int (*port_set_ether_type)(struct mv88e6xxx_chip *chip, int port,
 				   u16 etype);
 	int (*port_set_jumbo_size)(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 4b46e10a2dde..4561f289ab76 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -789,8 +789,8 @@ int mv88e6351_port_set_frame_mode(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 }
 
-static int mv88e6185_port_set_forward_unknown(struct mv88e6xxx_chip *chip,
-					      int port, bool unicast)
+int mv88e6185_port_set_forward_unknown(struct mv88e6xxx_chip *chip,
+				       int port, bool unicast)
 {
 	int err;
 	u16 reg;
@@ -807,8 +807,8 @@ static int mv88e6185_port_set_forward_unknown(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 }
 
-int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
-				     bool unicast, bool multicast)
+int mv88e6352_port_set_ucast_flood(struct mv88e6xxx_chip *chip, int port,
+				   bool unicast)
 {
 	int err;
 	u16 reg;
@@ -817,16 +817,28 @@ int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	reg &= ~MV88E6352_PORT_CTL0_EGRESS_FLOODS_MASK;
+	if (unicast)
+		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_UC;
+	else
+		reg &= ~MV88E6352_PORT_CTL0_EGRESS_FLOODS_UC;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
+}
+
+int mv88e6352_port_set_mcast_flood(struct mv88e6xxx_chip *chip, int port,
+				   bool multicast)
+{
+	int err;
+	u16 reg;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
+	if (err)
+		return err;
 
-	if (unicast && multicast)
-		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_ALL_UNKNOWN_DA;
-	else if (unicast)
-		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_MC_DA;
-	else if (multicast)
-		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_UC_DA;
+	if (multicast)
+		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_MC;
 	else
-		reg |= MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_DA;
+		reg &= ~MV88E6352_PORT_CTL0_EGRESS_FLOODS_MC;
 
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 }
@@ -1013,8 +1025,8 @@ static const char * const mv88e6xxx_port_8021q_mode_names[] = {
 	[MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE] = "Secure",
 };
 
-static int mv88e6185_port_set_default_forward(struct mv88e6xxx_chip *chip,
-					      int port, bool multicast)
+int mv88e6185_port_set_default_forward(struct mv88e6xxx_chip *chip,
+				       int port, bool multicast)
 {
 	int err;
 	u16 reg;
@@ -1031,18 +1043,6 @@ static int mv88e6185_port_set_default_forward(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
-int mv88e6185_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
-				     bool unicast, bool multicast)
-{
-	int err;
-
-	err = mv88e6185_port_set_forward_unknown(chip, port, unicast);
-	if (err)
-		return err;
-
-	return mv88e6185_port_set_default_forward(chip, port, multicast);
-}
-
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index a729bba050df..e6d0eaa6aa1d 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -154,11 +154,8 @@
 #define MV88E6185_PORT_CTL0_USE_IP				0x0020
 #define MV88E6185_PORT_CTL0_USE_TAG				0x0010
 #define MV88E6185_PORT_CTL0_FORWARD_UNKNOWN			0x0004
-#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_MASK			0x000c
-#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_DA		0x0000
-#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_MC_DA	0x0004
-#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_NO_UNKNOWN_UC_DA	0x0008
-#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_ALL_UNKNOWN_DA	0x000c
+#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_UC			0x0004
+#define MV88E6352_PORT_CTL0_EGRESS_FLOODS_MC			0x0008
 #define MV88E6XXX_PORT_CTL0_STATE_MASK				0x0003
 #define MV88E6XXX_PORT_CTL0_STATE_DISABLED			0x0000
 #define MV88E6XXX_PORT_CTL0_STATE_BLOCKING			0x0001
@@ -343,10 +340,14 @@ int mv88e6085_port_set_frame_mode(struct mv88e6xxx_chip *chip, int port,
 				  enum mv88e6xxx_frame_mode mode);
 int mv88e6351_port_set_frame_mode(struct mv88e6xxx_chip *chip, int port,
 				  enum mv88e6xxx_frame_mode mode);
-int mv88e6185_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
-				     bool unicast, bool multicast);
-int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
-				     bool unicast, bool multicast);
+int mv88e6185_port_set_forward_unknown(struct mv88e6xxx_chip *chip,
+				       int port, bool unicast);
+int mv88e6185_port_set_default_forward(struct mv88e6xxx_chip *chip,
+				       int port, bool multicast);
+int mv88e6352_port_set_ucast_flood(struct mv88e6xxx_chip *chip, int port,
+				   bool unicast);
+int mv88e6352_port_set_mcast_flood(struct mv88e6xxx_chip *chip, int port,
+				   bool multicast);
 int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 			      enum mv88e6xxx_policy_mapping mapping,
 			      enum mv88e6xxx_policy_action action);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d8de23ce7221..74457aaffec7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -626,8 +626,14 @@ struct dsa_switch_ops {
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
-	int	(*port_egress_floods)(struct dsa_switch *ds, int port,
-				      bool unicast, bool multicast);
+	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
+					 struct switchdev_brport_flags flags,
+					 struct netlink_ext_ack *extack);
+	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
+				     struct switchdev_brport_flags flags,
+				     struct netlink_ext_ack *extack);
+	int	(*port_set_mrouter)(struct dsa_switch *ds, int port, bool mrouter,
+				    struct netlink_ext_ack *extack);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index bc835f3de2be..f5949b39f6f7 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -184,10 +184,13 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
-			      struct switchdev_brport_flags flags);
+			      struct switchdev_brport_flags flags,
+			      struct netlink_ext_ack *extack);
 int dsa_port_bridge_flags(const struct dsa_port *dp,
-			  struct switchdev_brport_flags flags);
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack);
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
+		     struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vlan_del(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 368064dfd93e..80e6471a7a5c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -140,7 +140,7 @@ static void dsa_port_change_brport_flags(struct dsa_port *dp,
 		tmp.val = flags.val & BIT(flag);
 		tmp.mask = BIT(flag);
 
-		dsa_port_bridge_flags(dp, tmp);
+		dsa_port_bridge_flags(dp, tmp, NULL);
 	}
 }
 
@@ -425,41 +425,38 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 }
 
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
-			      struct switchdev_brport_flags flags)
+			      struct switchdev_brport_flags flags,
+			      struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->port_egress_floods ||
-	    (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD)))
+	if (!ds->ops->port_pre_bridge_flags)
 		return -EINVAL;
 
-	return 0;
+	return ds->ops->port_pre_bridge_flags(ds, dp->index, flags, extack);
 }
 
 int dsa_port_bridge_flags(const struct dsa_port *dp,
-			  struct switchdev_brport_flags flags)
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
-	int err = 0;
 
-	if (ds->ops->port_egress_floods)
-		err = ds->ops->port_egress_floods(ds, port,
-						  flags.val & BR_FLOOD,
-						  flags.val & BR_MCAST_FLOOD);
+	if (!ds->ops->port_bridge_flags)
+		return -EINVAL;
 
-	return err;
+	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
 }
 
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter)
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
+		     struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
 
-	if (!ds->ops->port_egress_floods)
+	if (!ds->ops->port_set_mrouter)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_egress_floods(ds, port, true, mrouter);
+	return ds->ops->port_set_mrouter(ds, dp->index, mrouter, extack);
 }
 
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index be29008477d3..8c9a41a7209a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -292,13 +292,14 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags);
+		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags,
+						extack);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags);
+		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter);
+		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.25.1

