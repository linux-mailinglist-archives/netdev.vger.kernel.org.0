Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF112D2A65
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgLHMKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:37 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:43431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729377AbgLHMKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6xbVbWeNNLy+ExKwL1+PWxhOnI4+qySnMaLF5Y6YPJQ+vznykSvHCyb8NSpk45H+uMzrEe9S1OfkYSucQRyS9tl/6swG5QpzrqJniOHsDzY6pQSlQhfPqjc8J07lnV5AM3fq3f3Ig15bTf9DxlOx/b7DGZh3dOgLtKBv0Y5xmwBj4pE1LFxdVvPBlHsoLqNQwHSNXD5K0bdg10P7Io90b8sD2syO6RZWrBpRPtcyvBmI/QvD4V4/1js0lCyxg+uO6etUP5FErnnvzY/EALCIrTXviRSEa3US44cmxuR16aNcK703/YX6zk6ExYa4SY8TCzA8lwb6xlZlrMo3gMdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWdlw0+R+nYJDW62R+04Nm+7bdWnO8wFYrJXMhvlNjc=;
 b=FDVWdeA+GVpPs6hltkrWPJ6hYhSIlc2NERXuqpkBYOpSOG+svbon5CnJ9nn5Cb3lzaSngLycDTGWzf/i7TlQaazHbEqN2dWH3Q5vH38F2/+FiFzT9MMk8iDr+2bLH0ojrSU3b4rjkSwVqde3Q3EuHDoKT05rSWrcdMIhqphLsEN3a3kBgc5V0mVVFxpzdarolr6hfR438eHBNsHftfgz+5VY/NGVHTicb8V05PeROT94M4LXBd2zCc6lZfXFJoaSVUAErOdfJP3DM6A/ilaP0Xoo+XpA/tXLV81ktpjOOnGaKC1kIRalTbAWv8GaiagGVViU/EwOAyYKmemjRaGwvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWdlw0+R+nYJDW62R+04Nm+7bdWnO8wFYrJXMhvlNjc=;
 b=Y1md6TZFPSQoxJfXI397It2NjwUTFwEKWEJ3Q4/VIx5/OTvUPs15sQWvS8+KaUyaUC3DfY/qSHyiL7EHVmEyshw1X20O1h2plj2Pnq4TJWRwGXb9N7N/U4G07k7UeFiXLD597Tb/PRZ3e7/RVBMxAu+uY6wgMgx4vRDViIqZLBs=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 12/16] net: mscc: ocelot: drop the use of the "lags" array
Date:   Tue,  8 Dec 2020 14:07:58 +0200
Message-Id: <20201208120802.1268708-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93a9ab57-beac-4314-a39a-08d89b71fdf5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693668B0509EB5A8C94B960E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDlz8avr+2m1ZAwbIdJezzWhYiIb1YLl908K9EeKuiJkTpKW8lidkjmW7sehgU8+UuXQTaGqRp9nkVJ6CfBLBp5FGScaCZKcECT/+tyirkqO8q1hcpWidwbkUisHq8SbAfZhqj7qF91KGbbrrcXrZolcpHooXjjUFdRBsWv3azRLhhysrAQ3zFKtr8bp+HI5CRfDX5y2SqHCQf3rbkZJawiHdHmm6fgBAsgShcF9MPWhw9jkOVmGtwLA9U/NmGJyqj8DIWeQYC2obzw6cAPCZwC/n/i6Um89DTJtNeCmKM+WtlDTjNh+XzQ2b0gcoKe+DgiVI0sebwEApMeG259NCiXS+FLmDuE9CVO+hS1C7LMZz0CYDVFdledjhHGrvOwP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i5HMabItg6eOLG8rmxQOohi2FL5BcpnsY45fY35WvJUUubUyNQp8asCvN0QU?=
 =?us-ascii?Q?mkTXGRwmpwBOfrsUbLOn7mEQkX9hQCATTvOoHvzpgXe7+wXwSG21+ATl3t8T?=
 =?us-ascii?Q?YT0i2kGYM60i4UYG0I0ycEKguF69dK73VbUcOMD3L2auec3sJkhIzRxEjJr2?=
 =?us-ascii?Q?S9d4daxa5cSOi9RAJuS5VJsAW2Dsiz06pNubcSjYAxUUBrJq21qN5idy93jN?=
 =?us-ascii?Q?f3zJsigcoHK+DjEQoT4gj4Ue113nQVc0iqFFYoVi+FEA146DsIV6Mv4SeAG+?=
 =?us-ascii?Q?HedRq9n9njWx8Jf+lMA4bTymME4Hk1ZBj59vvQUO9yW64ssASxq+M6tY0sjX?=
 =?us-ascii?Q?3BMMrVrHPF8pOjbZi2CysBaX283dnUf8iUKpB+tyAdY1JqXU0ek1n1QcH8lN?=
 =?us-ascii?Q?ipEgeBqvWD+Qf8JlReOwzyOZTUQrssh1gjr5E8k/WFEkRpeKwIJBA3PLkEug?=
 =?us-ascii?Q?0ICnnSABIDJxE9EO6TtRsBEFMnkyMBoSMtTiezP4dL8zli9JwIRcZ6vLjjDL?=
 =?us-ascii?Q?+UVMB/RxpBKb0W4/Q3AlDRGmLMnXthkBGB7za8sG7+2Fo9GWiyf8EsF6XREJ?=
 =?us-ascii?Q?s6AgfdWBn94tVcehdnRvQMmwPnlPipMoZbBHUOBEdE7SZ48J2yLzdNde34st?=
 =?us-ascii?Q?Gn9CR/Tke1a/8oHtO5R4dPZzYVXKYdR/KB1/Zg3MsWpAcRZDZIqTaBU9gK+a?=
 =?us-ascii?Q?halxGp65zYg5QpV1WwCXAIxGcMElAQ9VvXCKgUm/X0MRnLH+YZjat7iGkha9?=
 =?us-ascii?Q?BoqCAmoiBt3AI6PclK27MX2B3YNLX+Ges2zFXYTwFyNEsLLMYuSpbDXuT1aS?=
 =?us-ascii?Q?zIQQzzUwl6McajJSDT/2IjFrpZrfU6xCLF/NVNZzp3qoH1bAEK5FjJA6R7H5?=
 =?us-ascii?Q?iScSAEt72+i6U2mEuMXE7K60S8tiK+XJzgXNMviFARlr+HwebajF0vFrtlcN?=
 =?us-ascii?Q?lvLWUDjwR8lOLf1nB+TpPW998Rueyoz71DL/RVETKdtoFqv9WeRlMy5JqvQM?=
 =?us-ascii?Q?aspi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a9ab57-beac-4314-a39a-08d89b71fdf5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:37.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5xJ8I3CRA62PvXdJqSn7whe4Yxxq7iEjuJJfv3eXbdlUvvfzbw9hw4VPwgxW/Qk815oo0MXPwyLfrpoKBnlFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 drivers/net/ethernet/mscc/ocelot.c     | 104 ++++++++++---------------
 drivers/net/ethernet/mscc/ocelot.h     |   4 +-
 drivers/net/ethernet/mscc/ocelot_net.c |   4 +-
 include/soc/mscc/ocelot.h              |   2 -
 4 files changed, 47 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1a98c24af056..d4dbba66aa65 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -909,21 +909,17 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
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
@@ -1238,10 +1234,16 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
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
@@ -1250,16 +1252,26 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
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
@@ -1276,7 +1288,19 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
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
@@ -1315,59 +1339,22 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond)
 {
-	u32 bond_mask = 0;
-	int lag;
-
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
 
@@ -1543,11 +1530,6 @@ int ocelot_init(struct ocelot *ocelot)
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
index 739bd201d951..bef8d5f8e6e5 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -114,8 +114,8 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond);
-void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			   struct net_device *bond);
+int ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			  struct net_device *bond);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 77957328722a..93aaa631e347 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1035,8 +1035,8 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 			err = ocelot_port_lag_join(ocelot, port,
 						   info->upper_dev);
 		else
-			ocelot_port_lag_leave(ocelot, port,
-					      info->upper_dev);
+			err = ocelot_port_lag_leave(ocelot, port,
+						    info->upper_dev);
 	}
 
 	return notifier_from_errno(err);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b812bdff1da1..0cd45659430f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -639,8 +639,6 @@ struct ocelot {
 	enum ocelot_tag_prefix		inj_prefix;
 	enum ocelot_tag_prefix		xtr_prefix;
 
-	u32				*lags;
-
 	struct list_head		multicast;
 	struct list_head		pgids;
 
-- 
2.25.1

