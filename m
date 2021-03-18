Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF54B3410E7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhCRXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhCRXTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB6DC06174A;
        Thu, 18 Mar 2021 16:19:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hq27so6628190ejc.9;
        Thu, 18 Mar 2021 16:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6pdAPojJ5CzZpeJIbTb0+ylqgkWkyvqwhDkz8RlT1bc=;
        b=Ulm4aBBIiDueynmHRWLTvLIAUBc5LnRcngLWbjztFYxITWtvVE0ERkdvcdqc/J82zB
         0gGp2WYj/0xQPrWTZH8qLpY/FXaIhc/iHg2uGegXDHdPIzJoAK/iZSW19YqpBgpn0VQc
         q+K0zUBTQDWDj6fMt8xW/iErskM+vtU2if4e1ekCxGjJ3R989ks1gthb+bidZkxt1jEz
         eETkq51niNCGW7FVzolrEbUCMiDqVmemMtRo+1WIaFghT+mwrkhajDTSRQokMbh0KEHq
         jsA9XJbEIW5OH3iRt+tvyHidM7g7yBLGC5DtM78TjtiKteWVTL+ZhBQWwaWbWrQdZn0L
         G3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6pdAPojJ5CzZpeJIbTb0+ylqgkWkyvqwhDkz8RlT1bc=;
        b=V61f4Ez1UnmmkB2veXps9DG49nQByEUCmGBYuMxoKkxKAlsXfL6fgjztepviEKF330
         9guTGuAr4qERuTHO9CbthBHjn/s3TeoCAZYGoGEpOgCQ6R/Chi+yWCvb0TNuMtNXI6tR
         1m0HqyMBCBTMG9uOGHBjJEktRd6nT+uwvHoO7naHvcShhYCiLa0QvtDytiwmT7q0oaGq
         1bsZKyCSGJPk29lBM9NqI4wKUYcrT6zVSQq60J09SqXY+gdjM2VWsfxbZj/oiNUMHpnD
         VxUPFEZwcjYP+xEGt5vfBcqp/rWYIZnB0Px49sz3evpoHJXfxyVoHLcAG5LMpgy3nqvq
         Scug==
X-Gm-Message-State: AOAM531YHh668pdVJPTEFPdWVBsHzvRo2y0Jf5tXFMRQHh4DBY0bCm2p
        dn6z9D0NG0PqLccNS5aNzw0=
X-Google-Smtp-Source: ABdhPJy80ve+cUP7ecgjTTz83mvvtzj27vUHxlBOEp5Hcj6IVw/strv3r92GXA0Yd9aNJvT56NnngA==
X-Received: by 2002:a17:906:405b:: with SMTP id y27mr1121593ejj.332.1616109541369;
        Thu, 18 Mar 2021 16:19:01 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:19:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 12/16] net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged LAG
Date:   Fri, 19 Mar 2021 01:18:25 +0200
Message-Id: <20210318231829.3892920-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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

