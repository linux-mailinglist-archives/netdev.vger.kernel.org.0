Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AE0315293
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhBIPUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhBIPUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:20:32 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3299CC06178A;
        Tue,  9 Feb 2021 07:19:52 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id f14so32208457ejc.8;
        Tue, 09 Feb 2021 07:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JZuvpaxw4BnzPyO0xlmmBjHMG6Y20oqe4rr17OH0RoI=;
        b=IQC4M9bKuAjm0sORNwVj/LgFkP/rOwA11Hkk6OLlVQkoui3IvWcs8ydgoQgfAbzIj7
         sSpOwVGJ+2tSnYGf/9vjrDhSJekf+l5DAz1eNOQoEOoCfigLOhVLrnmDkIV+A38PaCrQ
         rTPlyAdxFT3iQmA95aDQxihBfj9YUaBuIdUv0OlgCPWGSMu4nNpu6DclaNMxgZzzw4at
         8TpVuB90BCsPfVbwBwH7TRIJc88F4TuJs3/IQoTolRPsi5Z6YuOFEsnR6THxVPKwb4Ba
         nFbekA79mL3wUWFeQtmOK+hmkk5u5/0Q42Y1t6QQqGw/T4BUONvK2lUsXisanTwaxUo3
         31Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JZuvpaxw4BnzPyO0xlmmBjHMG6Y20oqe4rr17OH0RoI=;
        b=g8OtN0f0xHw4PLoEJzCraQ6BziFnulXVPGX2ReWcGkggW1dKoKGPhtb7JlT68A19O3
         ITgLrONjhV1iq8k+GtrohnOW7SK5DvxmeT21SidIEmKUE3+IpOpFVocCGsUxK/Fnzl7i
         3T6LoWsuMJ91Adcyfxee+UCuN892rodvBTIRDtjVyqxFXBLpCyqW58eygVS+1ZISJ1N2
         T+o3ZhOOCcRRKxZjYfSFJ04SlyOgLUqO37RRpQIzHCLifAL7xlX1Z6y5ewRGaWMieb3V
         D/PUFYtsn4feLDL7uPksAq7Gcsf0lZOoDrimdU9B3cVcGS+2vBMWzz9MyqnMG8DfUMSd
         I0CQ==
X-Gm-Message-State: AOAM531cZ9hP64cDa6B4dn6fY4nMjth9c4pT/GAzu+wV8CcNmNRM+G66
        ykjKwE6EafUyA6H8l8xrkH4=
X-Google-Smtp-Source: ABdhPJwPbD++/+I1yN8fN6BxS/Lj47ibw7R7dNwQZXmfM9cimWhibyoMUJ/pb3LPd6JMXd9dNpa7qw==
X-Received: by 2002:a17:906:7d4d:: with SMTP id l13mr22404984ejp.107.1612883990797;
        Tue, 09 Feb 2021 07:19:50 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:19:49 -0800 (PST)
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
Subject: [PATCH v2 net-next 02/11] net: bridge: offload all port flags at once in br_setport
Date:   Tue,  9 Feb 2021 17:19:27 +0200
Message-Id: <20210209151936.97382-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The br_switchdev_set_port_flag function uses the atomic notifier call
chain because br_setport runs in an atomic section (under br->lock).
This is because port flag changes need to be synchronized with the data
path. But actually the switchdev notifier doesn't need that, only
br_set_port_flag does. So we can collect all the port flag changes and
only emit the notification at the end, then revert the changes if the
switchdev notification failed.

There's also the other aspect: if for example this command:

ip link set swp0 type bridge_slave flood off mcast_flood off learning off

succeeded at configuring BR_FLOOD and BR_MCAST_FLOOD but not at
BR_LEARNING, there would be no attempt to revert the partial state in
any way. Arguably, if the user changes more than one flag through the
same netlink command, this one _should_ be all or nothing, which means
it should be passed through switchdev as all or nothing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 net/bridge/br_netlink.c   | 155 +++++++++++++++-----------------------
 net/bridge/br_switchdev.c |   7 +-
 2 files changed, 66 insertions(+), 96 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bd3962da345a..2c110bcbc6d0 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -853,103 +853,82 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
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
+	spin_lock_bh(&p->br->lock);
+
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
+	spin_unlock_bh(&p->br->lock);
+
+	err = br_switchdev_set_port_flag(p, p->flags, changed_mask);
+	if (err) {
+		spin_lock_bh(&p->br->lock);
+		p->flags = old_flags;
+		spin_unlock_bh(&p->br->lock);
 		return err;
+	}
 
-	br_vlan_tunnel_old = (p->flags & BR_VLAN_TUNNEL) ? true : false;
-	err = br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
-	if (err)
-		return err;
+	spin_lock_bh(&p->br->lock);
 
 	if (br_vlan_tunnel_old && !(p->flags & BR_VLAN_TUNNEL))
 		nbp_vlan_tunnel_info_flush(p);
 
+	br_port_flags_change(p, changed_mask);
+
 	if (tb[IFLA_BRPORT_COST]) {
 		err = br_stp_set_path_cost(p, nla_get_u32(tb[IFLA_BRPORT_COST]));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (tb[IFLA_BRPORT_PRIORITY]) {
 		err = br_stp_set_port_priority(p, nla_get_u16(tb[IFLA_BRPORT_PRIORITY]));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (tb[IFLA_BRPORT_STATE]) {
 		err = br_set_port_state(p, nla_get_u8(tb[IFLA_BRPORT_STATE]));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (tb[IFLA_BRPORT_FLUSH])
@@ -961,7 +940,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 
 		err = br_multicast_set_port_router(p, mcast_router);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (tb[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT]) {
@@ -970,27 +949,20 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 		hlimit = nla_get_u32(tb[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT]);
 		err = br_multicast_eht_set_hosts_limit(p, hlimit);
 		if (err)
-			return err;
+			goto out;
 	}
 #endif
 
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
 		u16 fwd_mask = nla_get_u16(tb[IFLA_BRPORT_GROUP_FWD_MASK]);
 
-		if (fwd_mask & BR_GROUPFWD_MACPAUSE)
-			return -EINVAL;
+		if (fwd_mask & BR_GROUPFWD_MACPAUSE) {
+			err = -EINVAL;
+			goto out;
+		}
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
@@ -999,17 +971,21 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 		if (backup_ifindex) {
 			backup_dev = __dev_get_by_index(dev_net(p->dev),
 							backup_ifindex);
-			if (!backup_dev)
-				return -ENOENT;
+			if (!backup_dev) {
+				err = -ENOENT;
+				goto out;
+			}
 		}
 
 		err = nbp_backup_change(p, backup_dev);
 		if (err)
-			return err;
+			goto out;
 	}
 
-	br_port_flags_change(p, old_flags ^ p->flags);
-	return 0;
+out:
+	spin_unlock_bh(&p->br->lock);
+
+	return err;
 }
 
 /* Change state and parameters on port. */
@@ -1045,9 +1021,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 			if (err)
 				return err;
 
-			spin_lock_bh(&p->br->lock);
 			err = br_setport(p, tb);
-			spin_unlock_bh(&p->br->lock);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
@@ -1134,17 +1108,10 @@ static int br_port_slave_changelink(struct net_device *brdev,
 				    struct nlattr *data[],
 				    struct netlink_ext_ack *extack)
 {
-	struct net_bridge *br = netdev_priv(brdev);
-	int ret;
-
 	if (!data)
 		return 0;
 
-	spin_lock_bh(&br->lock);
-	ret = br_setport(br_port_get_rtnl(dev), data);
-	spin_unlock_bh(&br->lock);
-
-	return ret;
+	return br_setport(br_port_get_rtnl(dev), data);
 }
 
 static int br_port_fill_slave_info(struct sk_buff *skb,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a9c23ef83443..c004ade25ac0 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -65,16 +65,19 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
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
+	flags &= BR_PORT_FLAGS_HW_OFFLOAD;
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

