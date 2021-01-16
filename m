Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB42F8A2D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbhAPBB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbhAPBB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:58 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A0DC06179F
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id q22so15848743eja.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pKD28HIKQQp15q4L/I295JSmURZh7prtkZRo0P59bf8=;
        b=dE35oUhCtolz66u4FWe+rFmfMMvCJlt9HpLLBvSvCBuxrdDG9+sJ3NLaj0jUinWtet
         QFwsYOg7WD0hyr3rrlddwa2M+VOW/aqBJPhKEFV948e8vdMq8jg6N84WAj/3EjM1wUiY
         NkocUl92010OsIBUw1/4qlV9Bn+O+p7wcPdVkcRAUlaMWLBYx/tMtpkHP0Szzzo9Ck5a
         /EZfzf5ndBRAcS+MYlKZJ9fpzGVYPzgQ1BA1lPmnJBdtcEbjJOpr29qot+L1hofdNR5B
         sZDLsIbhSh6LbWpGyzbec7AoqOtGohqxBuFTTuvO66f7ffAopDZk/ZpaEshKIcbI/35g
         nfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pKD28HIKQQp15q4L/I295JSmURZh7prtkZRo0P59bf8=;
        b=n8TTOzLy7MlLOoc2P4Mxuh9DdGbwuo871xhQB0G9xKwlH/F1FZcJPeI3wQd0PICh5p
         4TXLNw1d9SE/a6JPU7sqxnVSVOhsjRqNvv8Uz7qYA8RM1GObhl7qEHycx+QAaXWj/tjz
         mZs8pL3fmIc8/v8DTjvfZXeud3SfuVMsQFrNVUYGnsMdoU0JQoqZFqqkNHYDURa5fpoN
         OKze99+CugDrV1LyeuT1uICwEFyvXB8m8nVfIXl+ifv67ifibUYm9+fnlJHlUxBJfLkv
         gCVWblY/DUMwPkCpm8mc6p0VuPlx0hkqpI6U93XlNWL1SA41rJWHoLOAIllPAo3FdSZu
         bqhg==
X-Gm-Message-State: AOAM531prkpQUjZOGt/w4GXjAhlX1EEEpgHGYVF/yVWEzxWFb7FPBtVm
        +JulPcatEJMxnLAX/DHkSSjL2nfxMsM=
X-Google-Smtp-Source: ABdhPJyy1/BgmisT3dpsKo8vQoxnWeFZGtZ46EsIo87wkKX1eupmhOQxNhSxCYmz8yFK+g1oavfOFw==
X-Received: by 2002:a17:906:d0c2:: with SMTP id bq2mr10679203ejb.1.1610758847141;
        Fri, 15 Jan 2021 17:00:47 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:46 -0800 (PST)
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
Subject: [PATCH v2 net-next 11/14] net: mscc: ocelot: drop the use of the "lags" array
Date:   Sat, 16 Jan 2021 02:59:40 +0200
Message-Id: <20210116005943.219479-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We can now simplify the implementation by always using ocelot_get_bond_mask
to look up the other ports that are offloading the same bonding interface
as us.

In ocelot_set_aggr_pgids, the code had a way to uniquely iterate through
LAGs. We need to achieve the same behavior by marking each LAG as visited,
which we do now by temporarily allocating an array of pointers to bonding
uppers of each port, and marking each bonding upper as NULL once it has
been treated by the first port that is a member. And because we now do
some dynamic allocation, we need to propagate errors from
ocelot_set_aggr_pgid all the way to ocelot_port_lag_leave.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Context looks a bit different.

 drivers/net/ethernet/mscc/ocelot.c     | 104 ++++++++++---------------
 drivers/net/ethernet/mscc/ocelot.h     |   4 +-
 drivers/net/ethernet/mscc/ocelot_net.c |   4 +-
 include/soc/mscc/ocelot.h              |   2 -
 4 files changed, 47 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1bcf68bd1bff..fa2ebfbb33eb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -904,21 +904,17 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 	 * source port's forwarding mask.
 	 */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (ocelot->bridge_fwd_mask & BIT(port)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
-			int lag;
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-				unsigned long bond_mask = ocelot->lags[lag];
+		if (!ocelot_port)
+			continue;
 
-				if (!bond_mask)
-					continue;
+		if (ocelot->bridge_fwd_mask & BIT(port)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			struct net_device *bond = ocelot_port->bond;
 
-				if (bond_mask & BIT(port)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 
 			ocelot_write_rix(ocelot, mask,
 					 ANA_PGID_PGID, PGID_SRC + port);
@@ -1219,10 +1215,16 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
-static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
+static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 {
+	struct net_device **bonds;
 	int i, port, lag;
 
+	bonds = kcalloc(ocelot->num_phys_ports, sizeof(struct net_device *),
+			GFP_KERNEL);
+	if (!bonds)
+		return -ENOMEM;
+
 	/* Reset destination and aggregation PGIDS */
 	for_each_unicast_dest_pgid(ocelot, port)
 		ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, port);
@@ -1231,16 +1233,26 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		ocelot_write_rix(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
 				 ANA_PGID_PGID, i);
 
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		bonds[port] = ocelot_port->bond;
+	}
+
 	/* Now, set PGIDs for each LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 		unsigned long bond_mask;
 		int aggr_count = 0;
 		u8 aggr_idx[16];
 
-		bond_mask = ocelot->lags[lag];
-		if (!bond_mask)
+		if (!bonds[lag])
 			continue;
 
+		bond_mask = ocelot_get_bond_mask(ocelot, bonds[lag]);
+
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
@@ -1257,7 +1269,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			ac |= BIT(aggr_idx[i % aggr_count]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
+
+		/* Mark the bonding interface as visited to avoid applying
+		 * the same config again
+		 */
+		for (i = lag + 1; i < ocelot->num_phys_ports; i++)
+			if (bonds[i] == bonds[lag])
+				bonds[i] = NULL;
+
+		bonds[lag] = NULL;
 	}
+
+	kfree(bonds);
+	return 0;
 }
 
 /* When offloading a bonding interface, the switch ports configured under the
@@ -1297,62 +1321,25 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	u32 bond_mask = 0;
-	int lag;
-
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
 	ocelot->ports[port]->bond = bond;
 
-	bond_mask = ocelot_get_bond_mask(ocelot, bond);
-
-	lag = __ffs(bond_mask);
-
-	/* If the new port is the lowest one, use it as the logical port from
-	 * now on
-	 */
-	if (port == lag) {
-		ocelot->lags[port] = bond_mask;
-		bond_mask &= ~BIT(port);
-		if (bond_mask)
-			ocelot->lags[__ffs(bond_mask)] = 0;
-	} else {
-		ocelot->lags[lag] |= BIT(port);
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
-	ocelot_set_aggr_pgids(ocelot);
-
-	return 0;
+	return ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_join);
 
-void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			   struct net_device *bond)
+int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			  struct net_device *bond)
 {
-	int i;
-
 	ocelot->ports[port]->bond = NULL;
 
-	/* Remove port from any lag */
-	for (i = 0; i < ocelot->num_phys_ports; i++)
-		ocelot->lags[i] &= ~BIT(port);
-
-	/* if it was the logical port of the lag, move the lag config to the
-	 * next port
-	 */
-	if (ocelot->lags[port]) {
-		int n = __ffs(ocelot->lags[port]);
-
-		ocelot->lags[n] = ocelot->lags[port];
-		ocelot->lags[port] = 0;
-	}
-
 	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
-	ocelot_set_aggr_pgids(ocelot);
+	return ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
@@ -1531,11 +1518,6 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
-	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
-				    sizeof(u32), GFP_KERNEL);
-	if (!ocelot->lags)
-		return -ENOMEM;
-
 	ocelot->stats = devm_kcalloc(ocelot->dev,
 				     ocelot->num_phys_ports * ocelot->num_stats,
 				     sizeof(u64), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index b6c9ddcee554..c018a54f4e49 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -112,8 +112,8 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info);
-void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			   struct net_device *bond);
+int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			  struct net_device *bond);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index f246f8fc535d..871bfbaa8ff1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1138,8 +1138,8 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 				err = 0;
 			}
 		} else {
-			ocelot_port_lag_leave(ocelot, port,
-					      info->upper_dev);
+			err = ocelot_port_lag_leave(ocelot, port,
+						    info->upper_dev);
 		}
 	}
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d2c587f099c8..1bb16527f490 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -656,8 +656,6 @@ struct ocelot {
 	enum ocelot_tag_prefix		inj_prefix;
 	enum ocelot_tag_prefix		xtr_prefix;
 
-	u32				*lags;
-
 	struct list_head		multicast;
 	struct list_head		pgids;
 
-- 
2.25.1

