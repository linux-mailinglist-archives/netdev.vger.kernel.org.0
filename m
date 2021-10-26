Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AFA43B721
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhJZQ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:21 -0400
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:18188
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236175AbhJZQ3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwPol4MNgs/G5CdHhrSCCN3IJcrrtJ2wV1lq6uKOXfB6IvcrRF3ZW8G/0n1sw97WHNkq8hKtI9xf9qF54sVbXhcqZTqTIRqf1Y1gjekkxQ4IAWTFMcYX2snLtL+s2Qt9OFkFR7evc6MQlk6/AXLbybwckgTIxJQ09oso21Xqi9LSZv8OltXQWpEpm08GlIoUFXnBEg/yCzcOP8u0YUmrC4//gEU9jPNPBqB+TpNXztKb+2rwvYFcPvz/k1M6eopDmXDp7JYl2u8mEFDPBQs26Xy6sIUpjJQUM6EiiQAG6umrGwHtY8fLfrVjlb+Q5+cEQl7to7FiWRLUTxGniuk51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5agd6aclMLNJIidwQ1N1u5gvWKiAT9nPbb0TRvv+DM=;
 b=PehGsqBRFVhZkTT8TkXBj4l5XzwldZXLPR+FwE97+ecQsnaK02gbNhzKKkYkelD5RsuvNEXAEE7Lq3qHefHrWo+wesFU6UlbUfAryxTAPYl74j2z/T8YklYTD4cSOGsKbf4+ksERWt0jAfBNwbi5FTUgIeRJIGnTApiIhRzlDZSF1lpXPNhhF0d0jJmQpPKyWVaIsRMltjCvxOZrcqdYuOkArUL3MpYvfgm9+8Glgjh1ja8/pl19onuXknLnSlgZy0t/HWHXt6y7NNRkiZrmp//epMUtH22xa8Te1fCWEP31EERWviRzM/p0zGImPghr3EqVvTZwohYP1x5K3Nn0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5agd6aclMLNJIidwQ1N1u5gvWKiAT9nPbb0TRvv+DM=;
 b=Rs9poS+N4dETu9UN5ENgbBIlE/PNCBWKAAWb1g9F+g16PvCjvrxpjMnn2fNs40xDFz4Aw6CAlfF4vQpvMWB1Lqdi5+v3BiunWv9vfQqdQkVqDoUJ1Z7z/zveenr0nSfqnvSCTX9SKDuDbyzq4/0n7yfI7zgSEMhmHvvOiKauz20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 4/6] net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
Date:   Tue, 26 Oct 2021 19:26:23 +0300
Message-Id: <20211026162625.1385035-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca94b8db-e6e3-4b43-e4dc-08d9989d6b49
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686D9309F6BE2F0A3550376E0849@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4scGlEGWs9G41sBMCMSSHaO08gXdk1epX24/02CDEbtKzJ+e4kXHv6XzPuuZjNQ9hUuLlWETCnvn7sDghV+SQIqG57wWYvZblJjUGmMiW7/JN++5PNzFdBioJKBTRVTAYZosDOZdGNs3n6NbxQG0qmO1YNZEhevBL5y4Bz6f5r9qK1YqSy9RF6Ui1WBeyz6DN7VX9R3N0J4WbkOqrOGuiwFq+sxJRx+YHmDho9+ifR9QeloBFWkHa9HCvKv5AWvanHZ9kQfQ5CadQWOXJubWp7rfrR1mLDQVzaXJyh9AgpJyCDe4+pcgmX+OszVTFT6wuyxVfg58mwFLsmeKJmfB+zgnb1IuRBak+NoCxkruGtGQQJcRK650ZppFOTI4PJhlYEgVP4LYFQ4dHZNE57HWMveMTLCvWOweei2S2XjYLFpDQS3XQH9tHerbM6VBlBQsB9CuoD+guYCzt3oU8IZJhhYGcI/PsjVC6W9SU4/WEbgIpMuNggC4Atx+JVH9N6IScMzh9FLsvPxD13wjiOrlrDEkWPYxeKIYr3EgDTcpyHYFk9w6OAAuOz/TNksenUfV2LoW4SxOlu3Fbk0pw8/6GPO1p1jWzk6JDOEkV+iAUWeXtAa77kkRONcZX68FShwuQBjvc9GDmbxa6y0+JFQe29FQk8X8iM3G0lzR6mbKfiHPxZ9IK0bu7fDAY5YlJO0kUmGb20UmfUuCMd2TF+qYdKhhf6+xnXYBiHrjwSbKkE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6916009)(956004)(8676002)(66556008)(6506007)(1076003)(2616005)(508600001)(186003)(6512007)(38100700002)(26005)(5660300002)(6666004)(66946007)(86362001)(44832011)(6486002)(54906003)(52116002)(38350700002)(2906002)(66476007)(83380400001)(316002)(4326008)(36756003)(334744004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K0uuDw8RwQnh52B4+XrnuG6hfKf+W8iffnly+99LtJ3TGkl0tlaQ9sRiI929?=
 =?us-ascii?Q?8HqC0dRxYASXtnfOk3jBVbkAgi9XTeN/F4bLg4ru1bQzlcJghdSP9RfeEfDj?=
 =?us-ascii?Q?ojiAEQVvhdxfHwC++uRnTRFrtTwLdQd8abKEwM3UCA/M5gI+snNV8/FWhJ0h?=
 =?us-ascii?Q?Dghs1m3D/1Y3DJ9r5bf+xRimzrqFBCq0gVe3I3yDMOC04bmy9op9aSfKvV7F?=
 =?us-ascii?Q?dFUztU3BdHt6rgjVuLsaTf5PnMNLnJmikAUHsH4zH7asysQ4jnx4DoGty+hx?=
 =?us-ascii?Q?ZDT1UOkkL17EUbzmN/OIMhn6IkclxMxl5EK/RmSg+jAKN0k1TrIyq6cFBMtU?=
 =?us-ascii?Q?dsZ2p5jpEX4Bcf0MyNEJgeO4NMLce6Zs6KDeZz+v32Y6Bc7zS+EVepzsW45G?=
 =?us-ascii?Q?kL6M9EEan8lR+l3FOz4fGWxeeY1aI/WkGq7p8003enfoTr9YLYt4GUOZ/m/U?=
 =?us-ascii?Q?XHSOIKY5vDzDo3tNykrYB8zhHYndYAJ2oEL/xxqn2BBZXdzSD+G5H/ujfqJ0?=
 =?us-ascii?Q?6YLfWRVo9xnsLT3XODqpRQrN6A29wJJ54HIZ2glsv1KjV2Jf5RkIcuH3lupd?=
 =?us-ascii?Q?5EwvTCIPniYwucLqtpagAFv1IFVYyjDW4eQ6YnFBRUVwyxEHYzZFQtRBdnwk?=
 =?us-ascii?Q?LlXp4Mp9kDWP/beTpGBkh/z/VWH/GLddWLgWuI3jmTZ0QWYeL1gqvckVkz39?=
 =?us-ascii?Q?Y3HFNvdzLD9GxL/xS+KJqgwYwMXlmrBdCVcXR6yNHy98EiccAE6vut8PZRG/?=
 =?us-ascii?Q?ZG2yt/TSxj2wzpXlmvYweHpuXYOSm+mlYci/akgC620w8Gx+Jg4RqFCO+4b5?=
 =?us-ascii?Q?UDo5ZfNxtMbT38u8YUSbDbirm4ssotY+MWFJAuIJUSLAKuM0zKu2fipksRbO?=
 =?us-ascii?Q?nKaVfcqqMBKWgbGuHZwkFktb9qxWc4fUPZwtbI6faxVRdjfvruBpfqhfU21U?=
 =?us-ascii?Q?Nhc6PfkfmLO1OQTZopLJOHclW1cownbo1s3U/X3lUdeNEXlZx375gb3YiR+r?=
 =?us-ascii?Q?TBCWccC5AZVs5mMfJZU2vqoSm2SN7LX/V9IhlTxXqOm3vaM137y4QTYDUlUM?=
 =?us-ascii?Q?ilR+d0oleCJtxsYw+pI6g5dhGEUnvvJQd3yWz1RyXTwpp2SmNQ3otNKNCPhB?=
 =?us-ascii?Q?TGpmb6LMpcO/3f60Q13xrg237HopMGcDtCyfLUB4QU0bn33cA/vEg62O71sm?=
 =?us-ascii?Q?6ehEH0rWgEAua8VHnVapjwr+nemgAVreLJpJXmCIjDUvQCcHkpnPhQ8Cu2i+?=
 =?us-ascii?Q?BXPvJnZuprZ6yoY87t4SUoDlxhVAAHq/lqcqUZUaM0yK5TGDcPLr0Ee9RL8E?=
 =?us-ascii?Q?5c3Jxmf7ci8qu4PQAnEPVJgGbfrfOfmdfZAU5nOdd3Vs4d59ZQ9eeSiOjI3V?=
 =?us-ascii?Q?w46hp1KJhOPqY2+/3NotkQrdgZeRz0ywZhsHoQk7aMcE9/VM9tZj410jWr4z?=
 =?us-ascii?Q?0XjJ9zl6r392VWAD7PO5Or0Yjra/+AxB9ljDEZYYIjGR/yv74Rrie8DNVLBV?=
 =?us-ascii?Q?m1b2qTerNBt5iyL6Ntw21WuHlxh4b+gt3XiS7ZhUBPZGOTPibqWXVI1sSijz?=
 =?us-ascii?Q?TNzPw1Nht7tKU6NbQlnM5oFPGtjuhgoFRaYJc7fQRf2Etd2gtQ9lDRypclE3?=
 =?us-ascii?Q?1KXL+4b40//XspVyCHovmKQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca94b8db-e6e3-4b43-e4dc-08d9989d6b49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:52.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DicuM687Am/TjvS/UaV4tp32rKi7EnEtMCAWE82AVQqoVE1SlVenu+bMIi9M85TbfSVv3scu1+fP7dw6fM0YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the majority of dsa_port_bridge_dev_get() calls in drivers is
just to check whether a port is under the bridge device provided as
argument by the DSA API.

We'd like to change that DSA API so that a more complex structure is
provided as argument. To keep things more generic, and considering that
the new complex structure will be provided by value and not by
reference, direct comparisons between dp->bridge and the provided bridge
will be broken. The generic way to do the checking would simply be to
do something like dsa_port_offloads_bridge(dp, &bridge).

But there's a problem, we already have a function named that way, which
actually takes a bridge_dev net_device as argument. Rename it so that we
can use dsa_port_offloads_bridge for something else.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 12 +++++++-----
 net/dsa/slave.c    | 18 +++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 62b719929ef4..daba10adbd22 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -272,8 +272,9 @@ static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
 	return dsa_port_to_bridge_port(dp) == dev;
 }
 
-static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
-					    const struct net_device *bridge_dev)
+static inline bool
+dsa_port_offloads_bridge_dev(struct dsa_port *dp,
+			     const struct net_device *bridge_dev)
 {
 	/* DSA ports connected to a bridge, and event was emitted
 	 * for the bridge.
@@ -295,13 +296,14 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 }
 
 /* Returns true if any port of this tree offloads the given bridge */
-static inline bool dsa_tree_offloads_bridge(struct dsa_switch_tree *dst,
-					    const struct net_device *bridge_dev)
+static inline bool
+dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
+			     const struct net_device *bridge_dev)
 {
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge(dp, bridge_dev))
+		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
 			return true;
 
 	return false;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad873bb2f676..98fd5e972d28 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -289,14 +289,14 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
 
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
 
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
@@ -409,7 +409,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
@@ -421,13 +421,13 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_add_ring_role(dp,
@@ -483,7 +483,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
@@ -495,13 +495,13 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
 		err = dsa_port_mrp_del_ring_role(dp,
@@ -2460,7 +2460,7 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	struct dsa_switch_tree *dst = dp->ds->dst;
 
 	if (netif_is_bridge_master(foreign_dev))
-		return !dsa_tree_offloads_bridge(dst, foreign_dev);
+		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
 
 	if (netif_is_bridge_port(foreign_dev))
 		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
-- 
2.25.1

