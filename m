Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DEF2F8A27
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbhAPBBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPBBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:17 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A269C061794
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id by1so9439238ejc.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zWY1y/upwUg3KwqCCaa8Z32+CPv07G2C/0JemH6mgoM=;
        b=iJEO+2PBD+GfL9kSOdFsYfOe4QFeA58aC6yIcwWFG+FKplluiXi8uxDBblh7HQsSWx
         IOPKNGiUtiK6QV1Fm75C4p2XSkinHK9ct4+e5+h//ntWNcP/2kMmsPrCN/gKQ1g1rneg
         Ay2xIESCfDvVTILz50yUHVc/i0h0lRStfc4H8yRD7KNPKXuuRvPSbMmxDdju3dwMlmVu
         6RIfaesyxe3PsLZVFbEPb3MjeaKY9jVi//hyCk6gr03UyKIR522g0cF/RH++2esqUnf2
         yFRsZe5nz1C3YhnPP6pwogIHEhB0QkdCnt7NL1DQSIOh21y8HfhMZJVuHRPW3m1t1/hx
         1sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zWY1y/upwUg3KwqCCaa8Z32+CPv07G2C/0JemH6mgoM=;
        b=J7DGhiY/MC5VlApFoQZ2E1uJSZoyy9o808oVwzyE0bTf9ESmbqKqy/3oOUD7nxteUx
         VA54RD9ahKEFyxDBFFn8B0JuUH4uRtWqThDrhJC75uohVwQB6ZA/d2TdI8DnL+McM2ve
         aXiB1kyzNSFYSF0EQO8ecAtf497hLgBhGTaUwjiGIyloqUY5lxdIE9yNwgo0HLQQGsFc
         hWTKIpdb5GQB+sX+LnMOsU4hSYTsCg07g4tUTm2Vv3UBqPd+BgLNBexUnIQXlOiIJZBo
         MCB6SbGDbErhWlrVXUjC8JmprmtzU3pOoQgf7NYzXmg8glX1EVRbOlOPd7x4zSGJjpvf
         Qfqw==
X-Gm-Message-State: AOAM532VfmDLyimDq5+HkeRnqeOcZx4qlrHY2N8c0n+ICg1/I5OZiCS4
        AZgK+cxQ353hqUoGMMQ8zXo=
X-Google-Smtp-Source: ABdhPJxLNg1rAuN4pcNE3O5GjplzE2LXO800MJFIi/mxqQeFNCVwj5rIDwjoQUUP6kcJ/eUvq8CZ/w==
X-Received: by 2002:a17:906:7118:: with SMTP id x24mr10739722ejj.333.1610758835784;
        Fri, 15 Jan 2021 17:00:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 02/14] net: mscc: ocelot: rename ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Date:   Sat, 16 Jan 2021 02:59:31 +0200
Message-Id: <20210116005943.219479-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_netdevice_port_event treats a single event, NETDEV_CHANGEUPPER.
So we can remove the check for the type of event, and rename the
function to be more suggestive, since there already is a function with a
very similar name of ocelot_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Fixed build by removing the "event" argument of ocelot_netdevice_changeupper.

 drivers/net/ethernet/mscc/ocelot_net.c | 59 ++++++++++++--------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 467170363ab2..f15f38f45249 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1109,9 +1109,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_netdevice_port_event(struct net_device *dev,
-				       unsigned long event,
-				       struct netdev_notifier_changeupper_info *info)
+static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct netdev_notifier_changeupper_info *info)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1119,28 +1118,22 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 	int port = priv->chip_port;
 	int err = 0;
 
-	switch (event) {
-	case NETDEV_CHANGEUPPER:
-		if (netif_is_bridge_master(info->upper_dev)) {
-			if (info->linking) {
-				err = ocelot_port_bridge_join(ocelot, port,
-							      info->upper_dev);
-			} else {
-				err = ocelot_port_bridge_leave(ocelot, port,
-							       info->upper_dev);
-			}
-		}
-		if (netif_is_lag_master(info->upper_dev)) {
-			if (info->linking)
-				err = ocelot_port_lag_join(ocelot, port,
-							   info->upper_dev);
-			else
-				ocelot_port_lag_leave(ocelot, port,
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking) {
+			err = ocelot_port_bridge_join(ocelot, port,
 						      info->upper_dev);
+		} else {
+			err = ocelot_port_bridge_leave(ocelot, port,
+						       info->upper_dev);
 		}
-		break;
-	default:
-		break;
+	}
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking)
+			err = ocelot_port_lag_join(ocelot, port,
+						   info->upper_dev);
+		else
+			ocelot_port_lag_leave(ocelot, port,
+					      info->upper_dev);
 	}
 
 	return err;
@@ -1169,17 +1162,19 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		}
 	}
 
-	if (netif_is_lag_master(dev)) {
-		struct net_device *slave;
-		struct list_head *iter;
+	if (event == NETDEV_CHANGEUPPER) {
+		if (netif_is_lag_master(dev)) {
+			struct net_device *slave;
+			struct list_head *iter;
 
-		netdev_for_each_lower_dev(dev, slave, iter) {
-			ret = ocelot_netdevice_port_event(slave, event, info);
-			if (ret)
-				goto notify;
+			netdev_for_each_lower_dev(dev, slave, iter) {
+				ret = ocelot_netdevice_changeupper(slave, info);
+				if (ret)
+					goto notify;
+			}
+		} else {
+			ret = ocelot_netdevice_changeupper(dev, info);
 		}
-	} else {
-		ret = ocelot_netdevice_port_event(dev, event, info);
 	}
 
 notify:
-- 
2.25.1

