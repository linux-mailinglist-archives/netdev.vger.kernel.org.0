Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33EC3119A2
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBFDOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhBFCzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:55:18 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0737C06121E
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:12 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id q2so7558977eds.11
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=33tPkKQOYyma2ofwMWOEyRy7yLPx/4Fcn7KgmHqtobE=;
        b=mx3krhsdXsiKM1HoO1VhgYZNYY+/oZdtogTmLJZwpZDw0wX5hEth+8x7sktwU7rYI6
         B2C6/NcJoxhNx6EHCKUwA0uWuU64WephrO7iVndFwgAy2LsEPzoWbQZlIujVm0DeNesZ
         Zdog3hdb0mku/C7tuEf6oDCUMeIGzIsYXY40Eh2aYImNJZ+dwI2um4eeQy5rHZqm468r
         9zyZ0jOYDxaNTL11Ae6i6gjmo6YCNLO/03i+PXpphwm18MxX0lqshfbQWPZ+FdnrVTsP
         vw3zf/Lr5lvRIiKIHZ9//8wGcavAefziR3yMmRohD7feQpwt9gDXdaOnS6ab7FWSB4Fp
         s8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=33tPkKQOYyma2ofwMWOEyRy7yLPx/4Fcn7KgmHqtobE=;
        b=PV7bXAv+8BVWOnsz/Ai/Jc2MPBAZYdJi5Rzeb0Vh/OY1IpMNy9lJfWhtH8Q4nwrCTY
         v3r2Wr+3oSMp5e9bcVJe3TB6e1jBAjKOD+dcGw4Sec/ogS+GR8PMarBxOCWCDSolnu/h
         kQUCp8KktgvLYmIjmT3D5uArhozg9H76PLk+ySIIb+N2xnBuGzfTEv2fXop1rtmltkJi
         PQjUorgb5+fEGTE/8GG/Yad68225cp7tZxCkEyPtbjpUuXVaiOKIUY3jCEpl4TJp7M1A
         Pd1iCUy79WuyWMJFvNavArTf3MIakKDsYFOnXgt7fZ07O/m92ebD0eE5RWzvBExTF2zX
         JzPg==
X-Gm-Message-State: AOAM532lhpBwk/dkv43CMXNfac/VuQUuBFZtGJ7HgsFyPBRyiZsPUP2G
        f6Ept0ny29e5WVOkVPyRXh0ChowPuKQ=
X-Google-Smtp-Source: ABdhPJydUOBQgiLZTK7hUUpOrV3ZDTCYsJT4qI56ActtPk3c7Jm4mY3QOUPOpHw6qX9bjORir9OwvQ==
X-Received: by 2002:a50:fe18:: with SMTP id f24mr5542422edt.276.1612562591720;
        Fri, 05 Feb 2021 14:03:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 01/12] net: mscc: ocelot: rename ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Date:   Sat,  6 Feb 2021 00:02:10 +0200
Message-Id: <20210205220221.255646-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
Fixed build by removing the "event" argument of ocelot_netdevice_changeupper.

 drivers/net/ethernet/mscc/ocelot_net.c | 59 ++++++++++++--------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e6b33d9df184..c8106124f134 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1110,9 +1110,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
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
@@ -1120,28 +1119,22 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
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
@@ -1170,17 +1163,19 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
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

