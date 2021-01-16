Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698162F8A31
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbhAPBCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbhAPBCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:02:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F27BC0617A2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id f4so15835418ejx.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NjEAA2DJmjSD/q4DlZ6it26CzmdA3ef8cg3M5pyv52M=;
        b=fm97Tnt5MwI9Wpmy85ICZGxAMA2zJ25cvTS1ydDeJgmN39PYAB3x2JxYqRhwQICKLT
         2oLQvN3NoItEzEW2YAUO5dYKe3BEa6PzA4NC0QZlUZfVPnOIX3aT+4Ylj7f1GA2tdLIt
         goVBrOlQNzXznds5ISbCVN3zzoFEoOpFaYlM4XWS/IW+zegyH3Cws6LD0C7V5jmGfRp2
         D3lWzFpIZhKRqgs5zydF7YA9tKnmiY+iSkumZ3M+9umWBauZ63GyU2QG7C3bKwhYZTfB
         EhVeMy55ISzGA1F0s/K3xTJUxQ62R973eaxjsQyrZbM6LoxOkifyS2JVwvgWeayoeivS
         sueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjEAA2DJmjSD/q4DlZ6it26CzmdA3ef8cg3M5pyv52M=;
        b=Z4qi46V1mao34N6wNK3LA1bku0TkfGoZaLrCKDNXKHao1q8OOesUf9fAFE6V12qtlz
         Ik2I8OQ0jsjNPrRE9GjG6jkkPk1KV1/Q5yEpCZx4+s/ZAa6FoxFhsN6gT4pFFMfWa/FU
         Eo5rhEgvOGwlA/yyeCOKgHBTjDBHVzlxfz9Gg7PrLxD2gt6JO6/XBEzb0L8De3zJOdxu
         JAo04wFELDdivHvIdQHoH2nfmd36K4OjTHW5VUaM3uT7B8SxhxsLExQvGen1JJNTdPpR
         tWqGBGhVnqcO1fii+2PSZvjplCgzWX3SjnCRb8vuVb5w3rINGKrlb/IP3Gg/uP9Sfqav
         G2Ng==
X-Gm-Message-State: AOAM530JMcT2OXGy0l2SaDYw8vgF6fJxpnlyiaqbokzm8q8K7HfYWSCc
        sXcwFl2kwflqXyN67FK4h9Q=
X-Google-Smtp-Source: ABdhPJxymBwuNtKGeQMx2JHwgXbqh+Mx/qa1m28S2mkmkmVe/lddltlI9Wa/zvOl/ap0qhoteKGSBw==
X-Received: by 2002:a17:906:65a:: with SMTP id t26mr10378870ejb.394.1610758850998;
        Fri, 15 Jan 2021 17:00:50 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:50 -0800 (PST)
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
Subject: [PATCH v2 net-next 14/14] net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
Date:   Sat, 16 Jan 2021 02:59:43 +0200
Message-Id: <20210116005943.219479-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot switch has been supporting LAG offload since its initial
commit, however felix could not make use of that, due to lack of a LAG
abstraction in DSA. Now that we have that, let's forward DSA's calls
towards the ocelot library, who will deal with setting up the bonding.

Note that ocelot_port_lag_leave can return an error due to memory
allocation but we are currently ignoring that, because the DSA method
returns void.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
s/lag_dev/bond/g

 drivers/net/dsa/ocelot/felix.c     | 28 ++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  1 +
 drivers/net/ethernet/mscc/ocelot.h |  6 ------
 include/soc/mscc/ocelot.h          |  6 ++++++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2c6ac2b137ec..af867535f9eb 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -105,6 +105,31 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 	ocelot_port_bridge_leave(ocelot, port, br);
 }
 
+static int felix_lag_join(struct dsa_switch *ds, int port,
+			  struct net_device *bond,
+			  struct netdev_lag_upper_info *info)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_join(ocelot, port, bond, info);
+}
+
+static int felix_lag_leave(struct dsa_switch *ds, int port,
+			   struct net_device *bond)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_leave(ocelot, port, bond);
+}
+
+static int felix_lag_change(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_change(ocelot, port, dp->lag_tx_enabled);
+}
+
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
@@ -881,6 +906,9 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mdb_del			= felix_mdb_del,
 	.port_bridge_join		= felix_bridge_join,
 	.port_bridge_leave		= felix_bridge_leave,
+	.port_lag_join			= felix_lag_join,
+	.port_lag_leave			= felix_lag_leave,
+	.port_lag_change		= felix_lag_change,
 	.port_stp_state_set		= felix_bridge_stp_state_set,
 	.port_vlan_filtering		= felix_vlan_filtering,
 	.port_vlan_add			= felix_vlan_add,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c31a63d9fe2a..b2fdee8a713c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1361,6 +1361,7 @@ int ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
 	/* Rebalance the LAGs */
 	return ocelot_set_aggr_pgids(ocelot);
 }
+EXPORT_SYMBOL(ocelot_port_lag_change);
 
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index fc055525fd88..e3352ae7b11f 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -109,12 +109,6 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      unsigned int vid, enum macaccess_entry_type type);
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
-int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond,
-			 struct netdev_lag_upper_info *info);
-int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			  struct net_device *bond);
-int ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 7bd7c58a7490..d9b5d31bb181 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -796,6 +796,12 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
+int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			  struct net_device *bond);
+int ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.25.1

