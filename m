Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E82315297
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhBIPUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhBIPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:20:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63D7C06178B;
        Tue,  9 Feb 2021 07:19:53 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z22so24153527edb.9;
        Tue, 09 Feb 2021 07:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0TQ433u6TQdvG5bZN+g1t41WgDj7q6Xdz7BjEG6A6c=;
        b=eMVx7hUlsN4vtaIrGOopzJ4dJMzRQ0PiEaWtL2qBfkXDxUig4Eg52vmFkNHrISaX5K
         tRrXxJldpgBfOI1uhcFlbPqut0X6qQ01wqRCPNDSBgON6A1CU4KLsqs5vhJHiSpK8mHk
         6bPLqm+isaqE1AjfqXAn2K20A37/igr8NrXWx9qEUBbHQy51THc+NDaUkE4Rh9406tIX
         9rZ8Qed96kbL+IvBfY3vr0/2tXaWY+bof65GUTUtr5mXHORY8dLUQPwOq+luiNsnYwZ3
         YuvRr0P4PRDdSaCvtqpMfCy13kWlxJePDKdIOYfwj7t7nAM3gS85X/QZgmA31Qxr0s2o
         ipDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0TQ433u6TQdvG5bZN+g1t41WgDj7q6Xdz7BjEG6A6c=;
        b=rOOSu+L2dySWLDUcUMMomdQiW+s1KdsmQMODB12w4ZQuA0n1EPxLmaG7dWlDV5B0Rz
         WdoqNKa7um+OiDI1KUrnzpHGtreZ7Scm83UyXHqjFu13ljEC361u45baYEYVKdDGYMSY
         ePkl4hUbmZVCphsWY1ovSGhCG9ewolEpHJKLGcS0OQBymO3fpeLz47Itj1owaNHk53Rd
         W7LSiDmTgrsYSzdzcaQ1yFVFomBQczop73K+YyMkFnIApWhNorXq7BgV+6eUUAT9Z4fY
         yuNN9va6OWAaPfZJBE2Kil0IFc82oDLZNe/9wiTWm6SFPAk5lJP1TQXwIyEVnWAYhdfo
         SdSg==
X-Gm-Message-State: AOAM530bPph1aHEXT07s/j8VuABEC5Mc50gePfr+MQdvxoFSwk+5Yv9n
        KihNdsAuSPlI3uOXbWnf+FU=
X-Google-Smtp-Source: ABdhPJyRzke+hcu1JR99Cvxx1kRZFuR62UMfze9akL7jXrUF5w9j9RjIPD2+8/4kLfJyYKGEnMuRoQ==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr24233485edc.102.1612883992572;
        Tue, 09 Feb 2021 07:19:52 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:19:51 -0800 (PST)
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
Subject: [PATCH v2 net-next 03/11] net: bridge: don't print in br_switchdev_set_port_flag
Date:   Tue,  9 Feb 2021 17:19:28 +0200
Message-Id: <20210209151936.97382-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently br_switchdev_set_port_flag has two options for error handling
and neither is good:
- The driver returns -EOPNOTSUPP in PRE_BRIDGE_FLAGS if it doesn't
  support offloading that flag, and this gets silently ignored and
  converted to an errno of 0. Nobody does this.
- The driver returns some other error code, like -EINVAL, in
  PRE_BRIDGE_FLAGS, and br_switchdev_set_port_flag shouts loudly.

The problem is that we'd like to offload some port flags during bridge
join and leave, but also not have the bridge shout at us if those fail.
But on the other hand we'd like the user to know that we can't offload
something when they set that through netlink. And since we can't have
the driver return -EOPNOTSUPP or -EINVAL depending on whether it's
called by the user or internally by the bridge, let's just add an extack
argument to br_switchdev_set_port_flag and propagate it to its callers.
Then, when we need offloading to really fail silently, this can simply
be passed a NULL argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- br_set_port_flag now returns void, so no extack there.
- don't overwrite extack in br_switchdev_set_port_flag if already
  populated.

 net/bridge/br_netlink.c   |  9 +++++----
 net/bridge/br_private.h   |  6 ++++--
 net/bridge/br_switchdev.c | 13 +++++++------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 2c110bcbc6d0..3ba23fb95370 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -866,7 +866,8 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 }
 
 /* Process bridge protocol info on port */
-static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
+static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
+		      struct netlink_ext_ack *extack)
 {
 	unsigned long old_flags, changed_mask;
 	bool br_vlan_tunnel_old;
@@ -898,7 +899,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 
 	spin_unlock_bh(&p->br->lock);
 
-	err = br_switchdev_set_port_flag(p, p->flags, changed_mask);
+	err = br_switchdev_set_port_flag(p, p->flags, changed_mask, extack);
 	if (err) {
 		spin_lock_bh(&p->br->lock);
 		p->flags = old_flags;
@@ -1021,7 +1022,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 			if (err)
 				return err;
 
-			err = br_setport(p, tb);
+			err = br_setport(p, tb, extack);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
@@ -1111,7 +1112,7 @@ static int br_port_slave_changelink(struct net_device *brdev,
 	if (!data)
 		return 0;
 
-	return br_setport(br_port_get_rtnl(dev), data);
+	return br_setport(br_port_get_rtnl(dev), data, extack);
 }
 
 static int br_port_fill_slave_info(struct sk_buff *skb,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d242ba668e47..a1639d41188b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1575,7 +1575,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb);
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-			       unsigned long mask);
+			       unsigned long mask,
+			       struct netlink_ext_ack *extack);
 void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
@@ -1605,7 +1606,8 @@ static inline bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 					     unsigned long flags,
-					     unsigned long mask)
+					     unsigned long mask,
+					     struct netlink_ext_ack *extack)
 {
 	return 0;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c004ade25ac0..ac8dead86bf2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -60,7 +60,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-			       unsigned long mask)
+			       unsigned long mask,
+			       struct netlink_ext_ack *extack)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
@@ -80,14 +81,15 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
-				       &info.info, NULL);
+				       &info.info, extack);
 	err = notifier_to_errno(err);
 	if (err == -EOPNOTSUPP)
 		return 0;
 
 	if (err) {
-		br_warn(p->br, "bridge flag offload is not supported %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+		if (extack && !extack->_msg)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "bridge flag offload is not supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -97,8 +99,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	err = switchdev_port_attr_set(p->dev, &attr);
 	if (err) {
-		br_warn(p->br, "error setting offload flag on port %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+		NL_SET_ERR_MSG_MOD(extack, "error setting offload flag on port");
 		return err;
 	}
 
-- 
2.25.1

