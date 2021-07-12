Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBDB3C5F23
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhGLPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:20 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:23777
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235495AbhGLPZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GP/UBJSm1anMp/xsWteTdtCdyPisd9JpZT8b6lsMfBZVxZ2Fx6UktnS7HSlroMcYpa2VDBtvHWud0RPYj8wP9bYuieHV9DWK79kwYmJsW/ReddXzkWRzhrtEEHVmHWUdoiYqyDW9UC4k2pPyFY+zcdPxTOzpmpo7yX3aZOGe3G7XwpsDQCEXF7xtE7IGxlsqHImNExQykCPAUFZV3nV5eB2zVSbY2DGPBLNoTkc8RM9XwgMbFPEjALhaGqD91Nu85Lge8qFw1F1dWkv5T80srPWZcMGM1HDDDpiQqp9SWao6zEQFvuxEQihsQUeKtlKJ5ZLQo6Ml3Z5ngk+ZCBtzmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMV1rNTy+B73je0YKCFaLZbYflrMYlTRHnsjo3Wx6zU=;
 b=mLgZIGOgvcswiW0LJqWa0ksRkmi+B+LvkTIoQXfAwxz8NysCW8JXm61qKbk28X2iDtrsH6wXa4KoSkXy1OML25psEl8402k4APGuebGLdsemCC9/qgN7cAcwAszxikXHCHxHT79yQgfd/Fx/vELJHLM+i9QZgF4GcEnkhp5VcIy17sqik9wMW4+jddzHP1X7lSEwMn5Rii0U9pZrAxVsyhUjfeRPBhCNqsey/1K+3RFfmmF61LnCZRVPe5a2EuMTH3A0zGIpkqo7y23N5tA7OhgjKKG+r17+3z1E2GClrbY5MEhPIpneCf6Y3CQRuSSgJijfb8wjx9CIqscjReCAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMV1rNTy+B73je0YKCFaLZbYflrMYlTRHnsjo3Wx6zU=;
 b=d7e7bcWSJJT1bCTeJk40jf7yVWOU+NDWX1c/VCVpODDi3YCfLKTmULaJVdsiluP+PCOyf35e+/DzQfFrZFT6hJoYzvB9ru76UyB/Sbv1awEGaD1Y6+J2zYtb33bNVYU5zIebHEnboV3114Z4lMLWsLX+BzceSgEYtxUIkXOmkjo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 12/24] net: bridge: drop context pointer from br_fdb_replay
Date:   Mon, 12 Jul 2021 18:21:30 +0300
Message-Id: <20210712152142.800651-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a6b6a3-985d-430b-5b2a-08d94548d949
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549A4019530AEF937791916E0159@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSQwQXrof0OXl5XO6iCPXrlL7pYNLeojXPrK/VJtbY64E9XExzJveYcTdkk13oxAvObGeL2InZuBqrHS35MXu+Gs6x4OqQkSOp5ynp3Dbqhdee86JTAwQilgWbinayTrd6phjcUA/XSuNJLqH7bRI3BdUfhRI+nY47EgbZCag1aIRZoYTcaIYYPfLN9y4GIuZvRRj9g+ReAxMoMlvSpBYe/meG10XwLmGxvBaYCqfWBQeb5OUmcJNdi0tlT4GIOJCnDt/YR/lqIlmNyZNZp/57JbXM/Pm3diMDXyxMtxuISq26zWLA+eaqZuqKo5Z61T/0EktNd6ImqHECL5+aLkgIkFx5ZZcYDMI/u2dXrrgP67A6MypFITcJ73iE2wiWm/PxQGd9N4/YGro8F2vPp9fGVhpCAhkWjTR2P96XySTFWGySt6PLoUHqXzldGaJRC/y6L2/xEZjug4+AXBJi98rek0PKfzMGAUsVALpD+uQJ4r3naRLT7H2u6qplTBQUh5qEiUutI9KDArl0wAFzlc6jjinWsHVXMK85lAaDhsGmvXEFRHjo8/lBkiDrTDHDXrZR0pHUUZMOltDjjurRY1/VgqIIxJdXFqDtdxN9a6TfgF2deClZvsNncWVieKDFpE4tu6M6Fhv7uV7nUunGkfQkYaLJseg8ZCvthuU903311Vd8zaDomE8VP1+v65+wckGZaXjFeEe0cdLCMQPHcqUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(6506007)(6666004)(478600001)(26005)(186003)(83380400001)(66476007)(66556008)(2616005)(2906002)(7416002)(6512007)(316002)(956004)(44832011)(54906003)(110136005)(4326008)(8676002)(66946007)(8936002)(86362001)(38100700002)(52116002)(1076003)(5660300002)(6486002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?91yA75kC1wCNNjIOnGxofJEhrf9C1GCGS+fgYgFCqEbL5Mnewm6YZWsHB47N?=
 =?us-ascii?Q?WcyyduQiciVdygylNPGuF2pM2Pm73D5uCUdqLJo5BF5oqWEUu+rOvXm/5bkZ?=
 =?us-ascii?Q?iE5j7JANrC3UsyM3GtmIkl5ClWpgRe2OfWf/UmCOYuLnDDfOj9BsvqxujrsX?=
 =?us-ascii?Q?kun1rHWAqeyquhplLUPI8HZ4i8v3uc4DzKGVGNmhO/gCrcWOgeXa7CkNKk5h?=
 =?us-ascii?Q?EXF0g4cp90bytuSH99s+jKyPIM8frEUg22u/vz7nM/ClVyg8g0e12o/yg4/W?=
 =?us-ascii?Q?AbRXF7elrbCfiIszSQCxn8SoezJJ27kASjef9kJJ7LDtz2BAHB4tql63oz8x?=
 =?us-ascii?Q?pEyHslU60OqbbzZGduylgVlejTlFk+RkiAxkfkamXJyTa3qQVj2oGVJvCclE?=
 =?us-ascii?Q?XlBa3CzEUvpFOMy/jRGwtq2CUyfC5f/ijSwYfs0DY/vQd+PsQ4wVRIIjDFlI?=
 =?us-ascii?Q?V1Zb2GtlMXhp1J46ldtibiUQBL+Ky9oll1ovV80o+M4+zxluf+vZ3oslpWc0?=
 =?us-ascii?Q?/0pD4LfqL73v00dL4/zxRdN7rQDd9+AV9e4BJuF6sgCIlhbwW1ssItCQaAG1?=
 =?us-ascii?Q?JAN0rHlK5/IiTya0dbGH8/sDomhUfPtsVM4dgt4zOOdIMBScWo98liijezTE?=
 =?us-ascii?Q?wZJc2Jab6xYFzQAxPrKkwM6qlAXq0f2LHiYF2Bd/beWwTLxkWbJyY4ajMIjR?=
 =?us-ascii?Q?JUX+URPOblAVBfNGA6Q+6O8MgqvMvHGS2zHUjdhOw2hMOA5Hi+xmO5SALMSM?=
 =?us-ascii?Q?3bfrjFrOHB+PjfhiBhxua8nqgtxzacEF3naH52KQQ7l10TDevcwkvG0P89LZ?=
 =?us-ascii?Q?do6SCabzoaM/h3H9Q8fcPr+XUcHZxnwH1LttBUwjrGdw5qwrAXOUUkoW5Zf2?=
 =?us-ascii?Q?bTO4uCER4EVS+EBFLdLOmVaZRRK6HpLY78twFyP4vTyz040RcVuEWWvBpzi0?=
 =?us-ascii?Q?yWyU2wjFZTXL+g25kxDAzSSiDu3MlHANd3ZXNtFBilyrBaZ8IcDiwH04yG3/?=
 =?us-ascii?Q?kdcTipxueOt30snReatstzlRyMuy2yEuZ7U637kR3Obkq7jmlpfW5AldwSwf?=
 =?us-ascii?Q?unAIiiQWFiuSDl+neJLLSC9AhZsyGMtfPBUIdNJ36hBsJqT6jXLIEs7XTX0t?=
 =?us-ascii?Q?mmczU9GeT1FMgKy0zB9njBZGhHg/uBA/JLuo8yPIx7aZ8hvGqgOBy1ReS8rR?=
 =?us-ascii?Q?h/NweuqXoFDTOzY5Le+UCml/eGQFWjWr94plrZGxnPYEy4LDuKBKlJwEMyiI?=
 =?us-ascii?Q?oDg2ZnVu8f0gGRVbOVDaprln3S0wgXz4QOg2ayDVMN+aEr44D08Ic/NMQVz+?=
 =?us-ascii?Q?4RfR0PZy4M5kGkCkosOD3tw9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a6b6a3-985d-430b-5b2a-08d94548d949
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:23.6720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdrTrYUkzvJgMwEEVfX/wAuBJuMIk2pr9XYQA6QuGKFkOIp9V/ksY4RCdL3guoHQLHKWxibyBonL4uddH6dXRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As opposed to the port objects (mdb, vlan), the FDB entries on a LAG are
a bit special.

While a VLAN installed on a bridge port that is a LAG can reasonably be
modeled from the bridge's perspective as individual VLANs being
installed on all physical ports that are beneath that LAG (and similar
for multicast addresses), the same cannot really be said about a unicast
forwarding destination MAC address.

Actually there is no driver today that makes meaningful use of FDB
entries towards bridge ports that are LAG (bond/team) interfaces, so it
is hard to assume anything. But intuitively, since FDB entries are
usually exclusive to a single destination port, replicating them on all
LAG lowers sounds like a bad idea. Maybe, instead, the switchdev driver
models the LAG as a logical port, and the FDB entries associated with
the LAG target that.

Anyway, do not assume anything and drop the context pointer from the fdb
replay helpers. The context pointer was introduced specifically for the
case where the bridge port is a LAG, beneath which there are multiple
switchdev lowers, all of which must do the same thing when offloading a
given switchdev object, and none of the ports must act on the same
object twice. It appears that in the case of FDB entries it is not
useful: the driver appears to be required to be able to do something
more elaborate even though it is not clear what.

The trouble, really, is that call_switchdev_notifiers() is not able
today to pass the context pointer, but br_fdb_replay calls a hand-coded
version of that function which is. Refactoring call_switchdev_notifiers
does not appear really worth it without at least knowing the requrements,
so drop the functionality with no users for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h | 4 ++--
 net/bridge/br_fdb.c       | 8 +++-----
 net/dsa/port.c            | 8 ++++----
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index d0bec83488b9..13acc1ff476c 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -168,7 +168,7 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb);
+		  bool adding, struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -199,7 +199,7 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 }
 
 static inline int br_fdb_replay(const struct net_device *br_dev,
-				const struct net_device *dev, const void *ctx,
+				const struct net_device *dev,
 				bool adding, struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2b862cffc03a..c93a2b3a0ad8 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -734,8 +734,7 @@ static inline size_t fdb_nlmsg_size(void)
 
 static int br_fdb_replay_one(struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
-			     struct net_device *dev, unsigned long action,
-			     const void *ctx)
+			     struct net_device *dev, unsigned long action)
 {
 	struct switchdev_notifier_fdb_info item;
 	int err;
@@ -746,14 +745,13 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
 	item.info.dev = dev;
-	item.info.ctx = ctx;
 
 	err = nb->notifier_call(nb, action, &item);
 	return notifier_to_errno(err);
 }
 
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb)
+		  bool adding, struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
@@ -783,7 +781,7 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 		if (dst_dev != br_dev && dst_dev != dev)
 			continue;
 
-		err = br_fdb_replay_one(nb, fdb, dst_dev, action, ctx);
+		err = br_fdb_replay_one(nb, fdb, dst_dev, action);
 		if (err)
 			break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index b824b6f8aa84..34b7f64348c2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -200,13 +200,13 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 		return err;
 
 	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, dp, true,
+	err = br_fdb_replay(br, brport_dev, true,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, dp, true, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, br, true, &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -232,13 +232,13 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 		return err;
 
 	/* Forwarding and termination FDB entries on the port */
-	err = br_fdb_replay(br, brport_dev, dp, false,
+	err = br_fdb_replay(br, brport_dev, false,
 			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	/* Termination FDB entries on the bridge itself */
-	err = br_fdb_replay(br, br, dp, false, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, br, false, &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-- 
2.25.1

