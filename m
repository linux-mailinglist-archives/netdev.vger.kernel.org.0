Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6B2F8A2B
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbhAPBB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhAPBBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:55 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA7C061799
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:42 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d22so498636edy.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYPOvC8LD5eCXYawgiYS1T39o/4TAiOe81TLJkBUT5I=;
        b=XuW8tLy74tIFeHoYauzVm33WP5t9q/HEMmmcHE8A5kpI+EiF3yIehHJMJF56GdotpJ
         VplT3WQgUgvakkp2c7PxTQXTLlMyQmBOATr1lWmNiO+Z+DqhpASbzTax/gO6ZDa3xUES
         vjwocQ2gdiIk2xq7UhlBq6vYf8v0ULghGDo27GElgCB+uCjbBM6+J56hzooAun8aaZ0V
         nP/WicdtxBVm/x1bY6f8w/MzOuRAxKeNuio/TQks7dd+nwbTq+Dt8VDw8leOmxrDaXqO
         s1OwlOKT+wOwCbP0VnyLT2JRtIZ7i2uBy+eIo2WtGubAyn0Naqn0ptIX1dhG192Fl7n0
         hd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYPOvC8LD5eCXYawgiYS1T39o/4TAiOe81TLJkBUT5I=;
        b=pAHd67dpZL7Dfx+Soxv7neLQhSc+fc/qyRsPnJuiPvuMWhlEJ3I11Om8OFa+/4UL8x
         pXcwkQGjyd1smiiI9KfzgaU4WsS5Cj+vtQZPZaufNFAI6HLIckfUNr3uMbTmGeGIm3o0
         mMhDHdOjB7t0k8ny3NMgSNJzIwsftYF/HAbiICTseYrQVHctRLGVNDKEWyfrCyUdRqCq
         f3yFj359h+qTRJ9lPjJ8fkJl5FP/31cG6ju3zE0Tb44+pQatlCUNIn+dGMXEZSSuUMZ1
         fuUryz2Zsi+EpkJbisxSkQCdBDKFvvBh89qsEVupvce0E6TNS1SZwdCWh0/EYC0RhjO8
         h4Cw==
X-Gm-Message-State: AOAM532LW89DZ4P1h4ufc4RgNeAGS85dH8QwUQuvIeIub9rEQBF3wEkL
        5togwvcOQCjcb4MBa9w4kMQ=
X-Google-Smtp-Source: ABdhPJzJTtQ5rhGAKP5L1jJGLsYRro8LsmsTlabyOCrcNcHmn4JHz2k+5cH6tmnzO7+jTk6ImVp+uA==
X-Received: by 2002:a05:6402:1748:: with SMTP id v8mr11969137edx.136.1610758840838;
        Fri, 15 Jan 2021 17:00:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:40 -0800 (PST)
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
Subject: [PATCH v2 net-next 06/14] net: mscc: ocelot: set up the bonding mask in a way that avoids a net_device
Date:   Sat, 16 Jan 2021 02:59:35 +0200
Message-Id: <20210116005943.219479-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since this code should be called from pure switchdev as well as from
DSA, we must find a way to determine the bonding mask not by looking
directly at the net_device lowers of the bonding interface, since those
could have different private structures.

We keep a pointer to the bonding upper interface, if present, in struct
ocelot_port. Then the bonding mask becomes the bitwise OR of all ports
that have the same bonding upper interface. This adds a duplication of
functionality with the current "lags" array, but the duplication will be
short-lived, since further patches will remove the latter completely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
Adapted to the merged version of the DSA API for LAG offload (i.e.
rejecting a bonding interface due to tx_type now done within the
.port_lag_join callback, caller is supposed to handle -EOPNOTSUPP).

 drivers/net/ethernet/mscc/ocelot.c | 29 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2b542f286739..e2744b921a97 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,6 +876,24 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+{
+	u32 bond_mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->bond == bond)
+			bond_mask |= BIT(port);
+	}
+
+	return bond_mask;
+}
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
@@ -1254,20 +1272,15 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(bond, ndev) {
-		struct ocelot_port_private *priv = netdev_priv(ndev);
+	ocelot->ports[port]->bond = bond;
 
-		bond_mask |= BIT(priv->chip_port);
-	}
-	rcu_read_unlock();
+	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 	lp = __ffs(bond_mask);
 
@@ -1300,6 +1313,8 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	u32 port_cfg;
 	int i;
 
+	ocelot->ports[port]->bond = NULL;
+
 	/* Remove port from any lag */
 	for (i = 0; i < ocelot->num_phys_ports; i++)
 		ocelot->lags[i] &= ~BIT(port);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cdc33fa05660..d2c587f099c8 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -610,6 +610,8 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+
+	struct net_device		*bond;
 };
 
 struct ocelot {
-- 
2.25.1

