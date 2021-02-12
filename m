Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B242C3197C6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBLBGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBLBG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:06:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D2CC0613D6;
        Thu, 11 Feb 2021 17:05:49 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y8so8989314ede.6;
        Thu, 11 Feb 2021 17:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WWIzfZdOyMaUtIDCGEeDUWrn0inM09zV0pOqalYdLuc=;
        b=mOQqJjvbyZhkzWMoDN7mP4FhPgGY9pfhyUVJ2SYIWcfAi59md2IuDzF+89HlRvhzyx
         lNC5rg5taFVQ/nreKrt7OEUXpbAN/NoXjBewXRS+xPqDygRRfX3zx6TDEv57TeyidnFu
         r4yBlK/ytvXM41tcSo0dq0134e1ZJLbTvki9b+Z4pHwBwv86nli7PlGUF54/wcKn+NbR
         S/2H9eYmdsKc9fFEJiKtBzXDG0z4KQX9DoWsT9Ce2pVjUzqIuL9Lm0/PLNz4VhXS70Bq
         1LRkk7hMg7+ReC55gix4hIa30tnx9Rw/DaJpqlIrVW7JBRJY99eNv8HwOULMAjUrVWSi
         hhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWIzfZdOyMaUtIDCGEeDUWrn0inM09zV0pOqalYdLuc=;
        b=PeYaWk7Onx7TnrBZMzTV1ga2CJqw2piHXt1puw+HnAe/a8DYHsD/vElLOddOXlbK6K
         IqTXwJXgXVvTbscROEjQkdoVwS1+Afte7GkUuhiiM55OwJj17lx2jqb0Jgy1iWgyuoSR
         2NT30t0fTrQ9fwEkQhyCkx2OYdZbCfoGHFvjCaMCbQ17AKygzyQBjHyoBjCisIvHsjil
         oeqx/2jfeFwzmwrgw4v++EnOuqJ5tQJxJqdIQOgkhE0q4eFtqfSHcdfTT3SaKpk9Fb9f
         yB1VLVCAiT3OvhN4WsehH7E1deivlQLM4P/Y76b27r2+/YbDR98FeIZEy5zxb/ZzCnCY
         6a5g==
X-Gm-Message-State: AOAM53262apDK6dQuBuiLhzlvjA08O3R2mh7KehFaZi4Lc5ehuRIJ8bC
        hXm2dHbxXp70A4u3D6Bkf5I=
X-Google-Smtp-Source: ABdhPJw+bo2CCPOPbnX/5rsduIPItZTMYyBZMT7jEtYZMmm4mFrRfAtDKZ9cCotFvT4OlezXy7OSng==
X-Received: by 2002:aa7:c755:: with SMTP id c21mr870891eds.47.1613091946314;
        Thu, 11 Feb 2021 17:05:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm5019580edc.73.2021.02.11.17.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 17:05:45 -0800 (PST)
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
Subject: [PATCH v4 net-next 2/9] net: bridge: offload all port flags at once in br_setport
Date:   Fri, 12 Feb 2021 03:05:24 +0200
Message-Id: <20210212010531.2722925-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212010531.2722925-1-olteanv@gmail.com>
References: <20210212010531.2722925-1-olteanv@gmail.com>
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

