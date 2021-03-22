Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6934535E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhCVXwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhCVXwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB94C061574;
        Mon, 22 Mar 2021 16:52:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r12so24121125ejr.5;
        Mon, 22 Mar 2021 16:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6pdAPojJ5CzZpeJIbTb0+ylqgkWkyvqwhDkz8RlT1bc=;
        b=cmHU9E5uA6AtZOy4eF9EzzNq8ezxt3tMYlrlDhLp25TRjYAthecfBdDSftaRhgt+mb
         JUV5C/TN6wSZeHXM6oE7pTEZ2Tky+GNkSmFgt75neh4s2x45noY60I3h2DGyuP6CtIdb
         B7sGQbZ3llZ/gjJcxbSsFst7+NcCszJ2YwFnHo9YE1iDQVEp+hpaUMljbzzRjc/JccXI
         oa+H+CAbpzT2D9SOG6Aa/uPrYIH830DVpCBOF7naU+sTdUHaebEQj+zrPLYAri9fwE+m
         0wyC63nopoARd3Vt4KGGzjsz6wxbXAnxk3oMwIbfQ+vmiJotrbtyxdhUGbGmW55nwrEm
         OFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6pdAPojJ5CzZpeJIbTb0+ylqgkWkyvqwhDkz8RlT1bc=;
        b=hJdFtKLCS524vTw2yHWApUe2oe8ciSt+Fygz9As7dK1QCXoppJmcye9daYqbValCW1
         bzDHCzlbP5lWcI7CQdLHzU8cVL5RlQ9qbq/DOxQ3TotinK7e34lyNW8E1UaOeEL4HZZN
         gdiSX6EIFckLympp2i7M11409WQUGZqnbHp/IQ4G7ldCOTqQ4QCKormnglJqoZEnTttF
         yMeT9NpZZztKi1SK0bhzlwUPENTIBD2BTXFBmzIh0EOYEdIGGdn11jQVE/HU6Qxqgc9d
         VnFz1N6a+LuEMpQiZJHQYD9b92kuAB1TUlW+sQBDIYwr9zHs2zDcMYiZkJt+N8thbvrx
         By7g==
X-Gm-Message-State: AOAM532lfneM77lwUUIsTyroZNJD++RZj86kIvo/CEgEnYrc2w6Egpzk
        lRYQY4PUo0fMBaKGEy7PJu8=
X-Google-Smtp-Source: ABdhPJyXHNdQO4954pyNe0ODd3gSqVFHW7Fg3zF1frnutuVUxxGHyP8j0WCanxvX0v9ty71fBo2QhA==
X-Received: by 2002:a17:906:9bdb:: with SMTP id de27mr2128841ejc.459.1616457134704;
        Mon, 22 Mar 2021 16:52:14 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 10/11] net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged LAG
Date:   Tue, 23 Mar 2021 01:51:51 +0200
Message-Id: <20210322235152.268695-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Similar to the DSA situation, ocelot supports LAG offload but treats
this scenario improperly:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0

We do the same thing as we do there, which is to simulate a 'bridge join'
on 'lag join', if we detect that the bonding upper has a bridge upper.

Again, same as DSA, ocelot supports software fallback for LAG, and in
that case, we should avoid calling ocelot_netdevice_changeupper.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 111 +++++++++++++++++++------
 1 file changed, 86 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c08164cd88f4..d1376f7b34fd 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1117,10 +1117,15 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_netdevice_bridge_join(struct ocelot *ocelot, int port,
-					struct net_device *bridge)
+static int ocelot_netdevice_bridge_join(struct net_device *dev,
+					struct net_device *bridge,
+					struct netlink_ext_ack *extack)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct switchdev_brport_flags flags;
+	int port = priv->chip_port;
 	int err;
 
 	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
@@ -1135,10 +1140,14 @@ static int ocelot_netdevice_bridge_join(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-static int ocelot_netdevice_bridge_leave(struct ocelot *ocelot, int port,
+static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 					 struct net_device *bridge)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct switchdev_brport_flags flags;
+	int port = priv->chip_port;
 	int err;
 
 	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
@@ -1151,43 +1160,89 @@ static int ocelot_netdevice_bridge_leave(struct ocelot *ocelot, int port,
 	return err;
 }
 
-static int ocelot_netdevice_changeupper(struct net_device *dev,
-					struct netdev_notifier_changeupper_info *info)
+static int ocelot_netdevice_lag_join(struct net_device *dev,
+				     struct net_device *bond,
+				     struct netdev_lag_upper_info *info,
+				     struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct net_device *bridge_dev;
 	int port = priv->chip_port;
+	int err;
+
+	err = ocelot_port_lag_join(ocelot, port, bond, info);
+	if (err == -EOPNOTSUPP) {
+		NL_SET_ERR_MSG_MOD(extack, "Offloading not supported");
+		return 0;
+	}
+
+	bridge_dev = netdev_master_upper_dev_get(bond);
+	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
+		return 0;
+
+	err = ocelot_netdevice_bridge_join(dev, bridge_dev, extack);
+	if (err)
+		goto err_bridge_join;
+
+	return 0;
+
+err_bridge_join:
+	ocelot_port_lag_leave(ocelot, port, bond);
+	return err;
+}
+
+static int ocelot_netdevice_lag_leave(struct net_device *dev,
+				      struct net_device *bond)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct net_device *bridge_dev;
+	int port = priv->chip_port;
+
+	ocelot_port_lag_leave(ocelot, port, bond);
+
+	bridge_dev = netdev_master_upper_dev_get(bond);
+	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
+		return 0;
+
+	return ocelot_netdevice_bridge_leave(dev, bridge_dev);
+}
+
+static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
 	int err = 0;
 
+	extack = netdev_notifier_info_to_extack(&info->info);
+
 	if (netif_is_bridge_master(info->upper_dev)) {
-		if (info->linking) {
-			err = ocelot_netdevice_bridge_join(ocelot, port,
-							   info->upper_dev);
-		} else {
-			err = ocelot_netdevice_bridge_leave(ocelot, port,
-							    info->upper_dev);
-		}
+		if (info->linking)
+			err = ocelot_netdevice_bridge_join(dev, info->upper_dev,
+							   extack);
+		else
+			err = ocelot_netdevice_bridge_leave(dev, info->upper_dev);
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
-		if (info->linking) {
-			err = ocelot_port_lag_join(ocelot, port,
-						   info->upper_dev,
-						   info->upper_info);
-			if (err == -EOPNOTSUPP) {
-				NL_SET_ERR_MSG_MOD(info->info.extack,
-						   "Offloading not supported");
-				err = 0;
-			}
-		} else {
-			ocelot_port_lag_leave(ocelot, port,
-					      info->upper_dev);
-		}
+		if (info->linking)
+			err = ocelot_netdevice_lag_join(dev, info->upper_dev,
+							info->upper_info, extack);
+		else
+			ocelot_netdevice_lag_leave(dev, info->upper_dev);
 	}
 
 	return notifier_from_errno(err);
 }
 
+/* Treat CHANGEUPPER events on an offloaded LAG as individual CHANGEUPPER
+ * events for the lower physical ports of the LAG.
+ * If the LAG upper isn't offloaded, ignore its CHANGEUPPER events.
+ * In case the LAG joined a bridge, notify that we are offloading it and can do
+ * forwarding in hardware towards it.
+ */
 static int
 ocelot_netdevice_lag_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -1197,6 +1252,12 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 
 	netdev_for_each_lower_dev(dev, lower, iter) {
+		struct ocelot_port_private *priv = netdev_priv(lower);
+		struct ocelot_port *ocelot_port = &priv->port;
+
+		if (ocelot_port->bond != dev)
+			return NOTIFY_OK;
+
 		err = ocelot_netdevice_changeupper(lower, info);
 		if (err)
 			return notifier_from_errno(err);
-- 
2.25.1

