Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74103316223
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBJJZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhBJJVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:21:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4214FC0617A7;
        Wed, 10 Feb 2021 01:19:24 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p20so2810526ejb.6;
        Wed, 10 Feb 2021 01:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GnyLHUEqfbFZKhOko3snrMsD4MwmfsvRgnw9w/p/K9Y=;
        b=u9lYigzYSZDqsQeewhDtyFqT2feyd8uExMZ99sCmsGwDZEr4qukTvPXyWtXMqdKBCz
         sgNljAdQ35O8U0nq0DZLjlZRvAn0JMzWNHKZ6eT0gbZkn0CSvslwFdkUiw7dlXSJvViJ
         TzB+LZIO+2wAhAfLBBSo5PdvRB6tNUFNlBUaSgGw04cETTKFGlYt42Zv3V43N1mvKGb6
         s9WRVKSbpxVH2cHLbrT8tKthcX/XLGQN4hWBqQcle4+0tQDL3uf5kDVzHd6/4rAUu6Yd
         CedBMG1ecR4MmrXMIAXSIahbV3aw3GUxH4BNQne+K6LG9NGv4d69KAIcdHM3Jfdor5Kv
         2VYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GnyLHUEqfbFZKhOko3snrMsD4MwmfsvRgnw9w/p/K9Y=;
        b=e56Ma0qcBk7YCJuy8PtJxrc0o1B2fFgZuUP9Fvefj0llVP0VZdWSHdQt/8jVISfoo3
         y1Ir+bCjXP43icMu4yqtz4/MKJcrc5A4k48VOuZy+cUznyzgjI6lyJ+tI+wWs29TeVMF
         xbxIbmZYX9Ee6NfbrYaDQ4aYtC3NyV7vKzYUc9suYS1tP+9/aS30IIWGfq8/jrzKUbYz
         jRPV8ZXT/CHZBlAXFDHvKu0fimQzFlpkMJUrc/b/2HYAAWtQBtjV0d2nQpvN7J8RJw/5
         RTrqBN70BVONOiapCQG3ViwVkBGk758LbaddhtVKvwislEctgV5ak3jzBWdQPdi16x2N
         b9/Q==
X-Gm-Message-State: AOAM533KNmoZdeWvHclptxwQUE2b5LH5W6MmBTq3p7BB2jrM4YvLSq+3
        d2ln7QMEQdAbwlVJQg/uF/kbIgqddus=
X-Google-Smtp-Source: ABdhPJzHfa/Xt2JNGhhcBFG62C+Zh1B+ARAz8gU1BHt1a9RX98M2FdUaEqP8S5Gi2ETw8IbDazbwQQ==
X-Received: by 2002:a17:907:35ca:: with SMTP id ap10mr2021833ejc.451.1612948762908;
        Wed, 10 Feb 2021 01:19:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:22 -0800 (PST)
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
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v3 net-next 06/11] net: dsa: kill .port_egress_floods overengineering
Date:   Wed, 10 Feb 2021 11:14:40 +0200
Message-Id: <20210210091445.741269-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
References: <20210210091445.741269-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge offloads the port flags through a single bit mask using
switchdev, which among others, contains learning and flooding settings.

The commit 57652796aa97 ("net: dsa: add support for bridge flags")
missed one crucial aspect of the SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS API
when designing the API one level lower, towards the drivers.
This is that the bitmask of passed brport flags never has more than one
bit set at a time. On the other hand, the prototype passed to the driver
is .port_egress_floods(int port, bool unicast, bool multicast), which
configures two flags at a time.

DSA currently checks if .port_egress_floods is implemented, and if it
is, reports both BR_FLOOD and BR_MCAST_FLOOD as supported. So the driver
has no choice if it wants to inform the bridge that, for example, it
can't configure unicast flooding independently of multicast flooding -
the DSA mid layer is standing in the way. Or the other way around: a new
driver wants to start configuring BR_BCAST_FLOOD separately, but what do
we do with the rest, which only support unicast and multicast flooding?
Do we report broadcast flooding configuration as supported for those
too, and silently do nothing?

Secondly, currently DSA deems the driver too dumb to deserve knowing that
a SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute was offloaded, because it
just calls .port_egress_floods for the CPU port. When we'll add support
for the plain SWITCHDEV_ATTR_ID_PORT_MROUTER, that will become a real
problem because the flood settings will need to be held statefully in
the DSA middle layer, otherwise changing the mrouter port attribute will
impact the flooding attribute. And that's _assuming_ that the underlying
hardware doesn't have anything else to do when a multicast router
attaches to a port than flood unknown traffic to it. If it does, there
will need to be a dedicated .port_set_mrouter anyway.

Lastly, we have DSA drivers that have a backlink into a pure switchdev
driver (felix -> ocelot). It seems reasonable that the other switchdev
drivers should not have to suffer from the oddities of DSA overengineering,
so keeping DSA a pass-through layer makes more sense there.

To simplify the brport flags situation we just delete .port_egress_floods
and we introduce a simple .port_bridge_flags which is passed to the
driver. Also, the logic from dsa_port_mrouter is removed and a
.port_set_mrouter is created.

Functionally speaking, we simply move the calls to .port_egress_floods
one step lower, in the two drivers that implement it: mv88e6xxx and b53,
so things should work just as before.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Pass extack through the newly introduce dsa_port_change_brport_flags.

Changes in v2:
- Reordered with previous patch such that we don't need to introduce
  .port_pre_bridge_flags
- Pass extack to drivers.

 drivers/net/dsa/b53/b53_common.c | 20 +++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++++++++++++++-
 include/net/dsa.h                |  7 +++++--
 net/dsa/dsa_priv.h               |  6 ++++--
 net/dsa/port.c                   | 20 +++++++++-----------
 net/dsa/slave.c                  |  4 ++--
 6 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 23fc7225c8d1..d480493cb64d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1948,6 +1948,23 @@ int b53_br_egress_floods(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_egress_floods);
 
+static int b53_br_flags(struct dsa_switch *ds, int port,
+			struct switchdev_brport_flags flags,
+			struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return b53_br_egress_floods(ds, port, flags.val & BR_FLOOD,
+				    flags.val & BR_MCAST_FLOOD);
+}
+
+static int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
+			   struct netlink_ext_ack *extack)
+{
+	return b53_br_egress_floods(ds, port, true, mrouter);
+}
+
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -2187,9 +2204,10 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
+	.port_bridge_flags	= b53_br_flags,
+	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
-	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ae0b490f00cd..b230bfcc4050 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5380,6 +5380,24 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
+				       struct switchdev_brport_flags flags,
+				       struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return mv88e6xxx_port_egress_floods(ds, port, flags.val & BR_FLOOD,
+					    flags.val & BR_MCAST_FLOOD);
+}
+
+static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
+				      bool mrouter,
+				      struct netlink_ext_ack *extack)
+{
+	return mv88e6xxx_port_egress_floods(ds, port, true, mrouter);
+}
+
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
@@ -5678,7 +5696,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
 	.port_bridge_join	= mv88e6xxx_port_bridge_join,
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
-	.port_egress_floods	= mv88e6xxx_port_egress_floods,
+	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
+	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 60acb9fca124..09aa28e667c7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -621,8 +621,11 @@ struct dsa_switch_ops {
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
-	int	(*port_egress_floods)(struct dsa_switch *ds, int port,
-				      bool unicast, bool multicast);
+	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
+				     struct switchdev_brport_flags flags,
+				     struct netlink_ext_ack *extack);
+	int	(*port_set_mrouter)(struct dsa_switch *ds, int port, bool mrouter,
+				    struct netlink_ext_ack *extack);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 63770e421e4d..8125806ee135 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -175,8 +175,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
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
index 736c5debcb96..545f83c7b193 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -140,7 +140,7 @@ static void dsa_port_change_brport_flags(struct dsa_port *dp,
 		tmp.val = flags.val & BIT(flag);
 		tmp.mask = BIT(flag);
 
-		dsa_port_bridge_flags(dp, tmp);
+		dsa_port_bridge_flags(dp, tmp, NULL);
 	}
 }
 
@@ -425,28 +425,26 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 }
 
 int dsa_port_bridge_flags(const struct dsa_port *dp,
-			  struct switchdev_brport_flags flags)
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
 
-	if (!ds->ops->port_egress_floods ||
-	    (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD)))
+	if (!ds->ops->port_bridge_flags)
 		return -EINVAL;
 
-	return ds->ops->port_egress_floods(ds, port, flags.val & BR_FLOOD,
-					   flags.val & BR_MCAST_FLOOD);
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
index 0e1f8f1d4e2c..4a979245e059 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -291,10 +291,10 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
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

