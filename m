Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34EA31A16A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhBLPR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhBLPQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:16:54 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4E3C0613D6;
        Fri, 12 Feb 2021 07:16:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id z19so2995380eju.9;
        Fri, 12 Feb 2021 07:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VKLSm6k3jPNeAszvbHQZ5QowrDxdUrXYZ8jPfbijTRo=;
        b=I/Nj9W2AT0IDSHVhkKm4AvrrFuIB7vP9GTj39e3vFUswX8Y0eOd/yO7MEGCabTyby2
         52Mvsx3pzYv/uunX2v9JmyvR4Stz+cd2HAMECZT/mGPWQytrQnJimEPhg9aL3WICtPEC
         my09/Z1WG/lvbemAHHBB9i1NA4Np4e+AQlVBUIyCrQSZwHl+sSJ62XrWck7ucoVxq6oD
         cS2Lfh46ZftFs8+kxJ2lfo0aPuIKLzxbzzs58FP1UO5V8957cgX0jg5S/VLoiPZ13bXB
         J0YLYYAm0oIABwxdhUOA2LmdAFxR1UOJPJR6oWHslrZS1nvjF0Vo9HL2wFUX4T3ayV+I
         cDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VKLSm6k3jPNeAszvbHQZ5QowrDxdUrXYZ8jPfbijTRo=;
        b=k2vCN4jaZP8NfMUJrBj8hwzg0IpxbPbAdENoVep9C/ZrUVunVjAoR1a6086s83/BQE
         T9E01Y1aP6pRCXGCBshQIX5iQlEBF3m0Z6M3x7p2L+DssVzzCC8crA4YIitudFxFK1C1
         JCjqYRf9II5sJycq8ArNygLVMXe+kMzkxnpFVgEdK7sCwl0IibU4rcXmI0d5T9hGxYj2
         QUT7VPJmikF5fSCgVGCFB5WL6wHK9kzuhkcd4SNhjl4TU1EqQ3loDWxihZIHEa3DOlRt
         TGv4tP1t6KE1LeTbJxncfiHDnu2t1KeolGOCPzuZgXxPz8zEZwKBsPih/7BT/f5zrENM
         ehTQ==
X-Gm-Message-State: AOAM530Rw5G749kiY/8LplGMavnLpNiyYZJIBsJKRQRVd9qGA3fq0zLt
        Oge2llp8OJ3NtCT3hnMdKJs=
X-Google-Smtp-Source: ABdhPJxf/b6pENTG+Sv+Pp+maBaS3X8/VWk+TsdRNEnhtZpEeZe6fEYB3IeJZ/PMpqb60cyh3JnY8A==
X-Received: by 2002:a17:906:fb9a:: with SMTP id lr26mr3581412ejb.474.1613142971907;
        Fri, 12 Feb 2021 07:16:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:11 -0800 (PST)
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
Subject: [PATCH v5 net-next 02/10] net: bridge: offload all port flags at once in br_setport
Date:   Fri, 12 Feb 2021 17:15:52 +0200
Message-Id: <20210212151600.3357121-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If for example this command:

ip link set swp0 type bridge_slave flood off mcast_flood off learning off

succeeded at configuring BR_FLOOD and BR_MCAST_FLOOD but not at
BR_LEARNING, there would be no attempt to revert the partial state in
any way. Arguably, if the user changes more than one flag through the
same netlink command, this one _should_ be all or nothing, which means
it should be passed through switchdev as all or nothing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
None.

Changes in v4:
Leave br->lock alone completely.

Changes in v3:
Don't attempt to drop br->lock around br_switchdev_set_port_flag now,
move that part to a later patch.

Changes in v2:
Patch is new.

Changes in v2:
Patch is new.

 net/bridge/br_netlink.c   | 109 ++++++++++++--------------------------
 net/bridge/br_switchdev.c |   6 ++-
 2 files changed, 39 insertions(+), 76 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bd3962da345a..bf469f824944 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -853,87 +853,58 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
 }
 
 /* Set/clear or port flags based on attribute */
-static int br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
-			    int attrtype, unsigned long mask)
+static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
+			     int attrtype, unsigned long mask)
 {
-	unsigned long flags;
-	int err;
-
 	if (!tb[attrtype])
-		return 0;
+		return;
 
 	if (nla_get_u8(tb[attrtype]))
-		flags = p->flags | mask;
+		p->flags |= mask;
 	else
-		flags = p->flags & ~mask;
-
-	err = br_switchdev_set_port_flag(p, flags, mask);
-	if (err)
-		return err;
-
-	p->flags = flags;
-	return 0;
+		p->flags &= ~mask;
 }
 
 /* Process bridge protocol info on port */
 static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 {
-	unsigned long old_flags = p->flags;
-	bool br_vlan_tunnel_old = false;
+	unsigned long old_flags, changed_mask;
+	bool br_vlan_tunnel_old;
 	int err;
 
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_MODE, BR_HAIRPIN_MODE);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_GUARD, BR_BPDU_GUARD);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_FAST_LEAVE, BR_MULTICAST_FAST_LEAVE);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_PROTECT, BR_ROOT_BLOCK);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_LEARNING, BR_LEARNING);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_UNICAST_FLOOD, BR_FLOOD);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_TO_UCAST, BR_MULTICAST_TO_UNICAST);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP, BR_PROXYARP);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP_WIFI, BR_PROXYARP_WIFI);
-	if (err)
-		return err;
-
-	br_vlan_tunnel_old = (p->flags & BR_VLAN_TUNNEL) ? true : false;
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
-	if (err)
+	old_flags = p->flags;
+	br_vlan_tunnel_old = (old_flags & BR_VLAN_TUNNEL) ? true : false;
+
+	br_set_port_flag(p, tb, IFLA_BRPORT_MODE, BR_HAIRPIN_MODE);
+	br_set_port_flag(p, tb, IFLA_BRPORT_GUARD, BR_BPDU_GUARD);
+	br_set_port_flag(p, tb, IFLA_BRPORT_FAST_LEAVE,
+			 BR_MULTICAST_FAST_LEAVE);
+	br_set_port_flag(p, tb, IFLA_BRPORT_PROTECT, BR_ROOT_BLOCK);
+	br_set_port_flag(p, tb, IFLA_BRPORT_LEARNING, BR_LEARNING);
+	br_set_port_flag(p, tb, IFLA_BRPORT_UNICAST_FLOOD, BR_FLOOD);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_TO_UCAST,
+			 BR_MULTICAST_TO_UNICAST);
+	br_set_port_flag(p, tb, IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD);
+	br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP, BR_PROXYARP);
+	br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP_WIFI, BR_PROXYARP_WIFI);
+	br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
+	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
+	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
+
+	changed_mask = old_flags ^ p->flags;
+
+	err = br_switchdev_set_port_flag(p, p->flags, changed_mask);
+	if (err) {
+		p->flags = old_flags;
 		return err;
+	}
 
 	if (br_vlan_tunnel_old && !(p->flags & BR_VLAN_TUNNEL))
 		nbp_vlan_tunnel_info_flush(p);
 
+	br_port_flags_change(p, changed_mask);
+
 	if (tb[IFLA_BRPORT_COST]) {
 		err = br_stp_set_path_cost(p, nla_get_u32(tb[IFLA_BRPORT_COST]));
 		if (err)
@@ -982,15 +953,6 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 		p->group_fwd_mask = fwd_mask;
 	}
 
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS,
-			       BR_NEIGH_SUPPRESS);
-	if (err)
-		return err;
-
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
-	if (err)
-		return err;
-
 	if (tb[IFLA_BRPORT_BACKUP_PORT]) {
 		struct net_device *backup_dev = NULL;
 		u32 backup_ifindex;
@@ -1008,7 +970,6 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 			return err;
 	}
 
-	br_port_flags_change(p, old_flags ^ p->flags);
 	return 0;
 }
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a9c23ef83443..6a9db6aa5c04 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -65,16 +65,18 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
 		.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
-		.u.brport_flags = mask,
 	};
 	struct switchdev_notifier_port_attr_info info = {
 		.attr = &attr,
 	};
 	int err;
 
-	if (mask & ~BR_PORT_FLAGS_HW_OFFLOAD)
+	mask &= BR_PORT_FLAGS_HW_OFFLOAD;
+	if (!mask)
 		return 0;
 
+	attr.u.brport_flags = mask;
+
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
 				       &info.info, NULL);
-- 
2.25.1

