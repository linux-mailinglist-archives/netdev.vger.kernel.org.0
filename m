Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF36B312844
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBGXYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBGXYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:24:22 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608CBC06178B;
        Sun,  7 Feb 2021 15:23:10 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bl23so21822698ejb.5;
        Sun, 07 Feb 2021 15:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ThCOkenuQFpeKsMtK2nCof+I8uOT9vtJkcRp6jlfyM=;
        b=S0uj7F9ziMIrG/frHxikHmNavPB2oPJMgnfejwjEnf3++bLVO+jiSXqXDb67RilIRK
         ZNFKZ3yUAJHrinDluQDa8Q9kIUb6OK/H0MnWmdZ7KtEpcmE+FnHo+BaZltqmaj+Y/Iom
         QRsFOB6WjOHnJCo7gpaTf+/Rvki0zXdNclhfksklp7YlDrxLk1E1EIuC/YgBiJRyF4Ep
         jClRQZU/zLQmciVUCcWhA4JB7kzlmsjubtvYC6FFja0ZotO/e/7VhCUGR3mVIrLG5N/o
         w5yuaF/SO7BwtBgb8lC8ihjLQEY96ou2Fp/C3/J131MFOP98nzMnwhp5Aa8I66doGGLG
         7n6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ThCOkenuQFpeKsMtK2nCof+I8uOT9vtJkcRp6jlfyM=;
        b=KhmEfUJ1iclljs1APenx+qYce+KgnoobIdn5HOT8RsdHIJdbzR4pNKeACdorrDOY71
         FxBV3iPj7/1MiyQdplZhUTjYAvNZhWVIy/jLs/1vI4zyOq36Bfjww0kdsGYFiwh9NXrG
         Wx1oaRCLyo2G5u7LLsuXXeYIaBrPwu7Dr6w8Sb3rA4CznxUyCmkbN7neG2+jotOnvtdp
         MT95n1VzWRTNNRlCxB8v3I0bzHtF8Ukbiw87KJ1G3yQVzDCdU+gGvvtmNNtUiG3sBq18
         TOwSXg22RYJWGRWo/Al0SMoYd+9eoOIpXbayBUmKSCIxWItugX3SdaPucT6OYvpREScO
         i7OA==
X-Gm-Message-State: AOAM531EOvO63XCkWJffPWDgahocHyj9Cbg9AjCftt4GtV/walP38Dc4
        8lL4HLSG8HSwmxrYsfjLOd0I+FyELIQ=
X-Google-Smtp-Source: ABdhPJxPH2FRRS6x0ZxKv+1VDOQZw4FUBawIfctuOxS/cHD2Eu6xWRK+tp6UXAOBLXpdNImeR/pj8Q==
X-Received: by 2002:a17:906:9249:: with SMTP id c9mr14454993ejx.416.1612740188939;
        Sun, 07 Feb 2021 15:23:08 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:08 -0800 (PST)
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
Subject: [PATCH net-next 4/9] net: dsa: kill .port_egress_floods overengineering
Date:   Mon,  8 Feb 2021 01:21:36 +0200
Message-Id: <20210207232141.2142678-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207232141.2142678-1-olteanv@gmail.com>
References: <20210207232141.2142678-1-olteanv@gmail.com>
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

If the bridge wants to see what flags are supported by the device, it
emits a SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS attribute. DSA currently
checks if .port_egress_floods is implemented, and if it is, reports both
BR_FLOOD and BR_MCAST_FLOOD. So the driver has no choice if it wants to
inform the bridge that it can configure unicast flooding but not
multicast flooding - the DSA mid layer is standing in the way.

Secondly, as outlined in the first paragraph, flooding is not all that
is passed through the brport flags bitmask, but also learning. If a DSA
switch wanted to configure its learning parameter in spirit of the
current API, new logic would need to be added to DSA for
.port_set_learning. This implies that dsa_port_pre_bridge_flags would
have to deduce, based on which of .port_set_learning and
.port_egress_floods are implemented, what to mark as supported, and then
figure out which of .port_set_learning or .port_egress_floods to call
from dsa_port_bridge_flags. The latter is non-trivial because, as
mentioned, all brport flags finally end up offloaded in the same bitmask,
and ideally we wouldn't want DSA to call an unneeded method, i.e.
.port_set_learning when nothing learning-related has changed, or
.port_egress_floods when nothing flooding-related has changed,
especially when the reconfiguration for that might involve a switch reset.
So to avoid that, DSA's only option would be to perform 'edge detection'
by keeping an unsigned long dsa_port::brport_flags and check for the XOR
between the cached value and the new flags in order to determine what
changed. Either that, or make the drivers check early if anything has
changed, and return if not. But either way, this is fairly overengineered.

Thirdly, currently DSA deems the driver too dumb to deserve knowing that
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
and we introduce .port_pre_bridge_flags and .port_bridge_flags which are
passed to the driver. Also, the logic from dsa_port_mrouter is removed
and a .port_set_mrouter is created. The .port_pre_bridge_flags callback
is temporary and will be removed in a later patch, together with
SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS.

Functionally speaking, we simply move the calls to .port_egress_floods
one step lower, in the two drivers that implement it: mv88e6xxx and b53,
so things should work just as before.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c | 24 +++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.c | 26 +++++++++++++++++++++++++-
 include/net/dsa.h                |  8 ++++++--
 net/dsa/dsa_priv.h               |  2 +-
 net/dsa/port.c                   | 21 ++++++++-------------
 5 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 23fc7225c8d1..0c4000783b15 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1948,6 +1948,26 @@ int b53_br_egress_floods(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_egress_floods);
 
+static int b53_pre_br_flags(struct dsa_switch *ds, int port,
+			    unsigned long mask)
+{
+	if (mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int b53_br_flags(struct dsa_switch *ds, int port, unsigned long flags)
+{
+	return b53_br_egress_floods(ds, port, flags & BR_FLOOD,
+				    flags & BR_MCAST_FLOOD);
+}
+
+static int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter)
+{
+	return b53_br_egress_floods(ds, port, true, mrouter);
+}
+
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -2187,9 +2207,11 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
+	.port_bridge_flags	= b53_br_flags,
+	.port_pre_bridge_flags	= b53_pre_br_flags,
+	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
-	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ae0b490f00cd..bd986244aa27 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5380,6 +5380,28 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+					   unsigned long mask)
+{
+	if (mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
+				       unsigned long flags)
+{
+	return mv88e6xxx_port_egress_floods(ds, port, flags & BR_FLOOD,
+					    flags & BR_MCAST_FLOOD);
+}
+
+static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
+				      bool mrouter)
+{
+	return mv88e6xxx_port_egress_floods(ds, port, true, mrouter);
+}
+
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
@@ -5678,7 +5700,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 60acb9fca124..e37fee22caab 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -621,8 +621,12 @@ struct dsa_switch_ops {
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
-	int	(*port_egress_floods)(struct dsa_switch *ds, int port,
-				      bool unicast, bool multicast);
+	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
+					 unsigned long mask);
+	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
+				     unsigned long flags);
+	int	(*port_set_mrouter)(struct dsa_switch *ds, int port,
+				    bool mrouter);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8a1bcb2b4208..da99961599de 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -174,7 +174,7 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long mask);
 int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags);
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
 int dsa_port_vlan_add(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index aa1cbba7f89f..8df492412138 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -382,39 +382,34 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	return 0;
 }
 
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long mask)
 {
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->port_egress_floods ||
-	    (flags & ~(BR_FLOOD | BR_MCAST_FLOOD)))
+	if (!ds->ops->port_pre_bridge_flags)
 		return -EINVAL;
 
-	return 0;
+	return ds->ops->port_pre_bridge_flags(ds, dp->index, mask);
 }
 
 int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags)
 {
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
-	int err = 0;
 
-	if (ds->ops->port_egress_floods)
-		err = ds->ops->port_egress_floods(ds, port, flags & BR_FLOOD,
-						  flags & BR_MCAST_FLOOD);
+	if (!ds->ops->port_bridge_flags)
+		return -EINVAL;
 
-	return err;
+	return ds->ops->port_bridge_flags(ds, dp->index, flags);
 }
 
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter)
 {
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
 
-	if (!ds->ops->port_egress_floods)
+	if (!ds->ops->port_set_mrouter)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_egress_floods(ds, port, true, mrouter);
+	return ds->ops->port_set_mrouter(ds, dp->index, mrouter);
 }
 
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-- 
2.25.1

