Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7863448796E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348016AbiAGPBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:33 -0500
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:43678
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347991AbiAGPBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaMI2LTBk6kcMZhJbw6J1UhN2Qo/kC3m/H9ZMiQzIFJjTLmMWikXFJXS1/OSNlSrGZyaXIf4l6iGXY86WaXoo78ex6+OdkYRYFfohFlw6Ffg0U6y+yurgyRdktwDVVKZ8tkPDWkwGxNWeCW1748SR+3YNKURx+eW4yPvkgIqPzYbspM5tMg5X+aP/Fj5LJzGGCVCFMtHqelvZdlvKrBwzAkZMpUpX1z8WbRX+uBjZ2+Hu+crfOv5J8Z1ysqqJGlef+QKY42oAz+wDWgCvm+TOQ7+QKRMkUK+VTji84WelMHtoDW5NFHr6NDY30sikRW3UmeI7UN6JH47b229Kowqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QE/9CTPAlBcPPJ8yd5e6BtMoFgRMb9pcaUqLip8tbZ0=;
 b=dZuku3dtd9owPplL9EkfcYhrwmEPjWHu5NGxcvfMSfIhCI9CoP/lWOlUj2l3/NZfm6XkKsQh61OOm9Vw2Nab4d6lFQp5yjsAvtQi9VW97nelEUzyyLcS7Y2ysz7kbl4ZKl9prvj/aEwAWAQs5ju7nMazc4uEN4xb8Erlb/GZjFnsj1DZiX39KmR1ZE5fRQzXZYUmUE9/OTlfAzaWQ1q2XSuq3bDPjbt8tgHNLhqHiVofiC2RkJD7UzJ/s3fNAXMsB/jSpe2K58zgzJoGEo5KDq3oXO1Cq9SLaLNKI/O4Fl1HVrh7HDqQs6NF41xUiExPYg9lRy9TEetlcgvB07fTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QE/9CTPAlBcPPJ8yd5e6BtMoFgRMb9pcaUqLip8tbZ0=;
 b=hpmMkkdXq8dGqEstnz7VuLd2D4JNESPSPsROrYyNbxEPKcaDsNKc8/IsDdShdvd0CCLHHa/DdnSTaqHsnpYROAp601iXNjjxR0lhZutjAsXJATvhiZ02eNRD16DyVmiFVlOeDGmqUvS1yJVAq2onhXQlWEif0dHB4ouRWblv9yE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 01/12] net: dsa: rename references to "lag" as "lag_dev"
Date:   Fri,  7 Jan 2022 17:00:45 +0200
Message-Id: <20220107150056.250437-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1330cc19-9b3b-4618-f178-08d9d1ee88e9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340820F1E5F386F15B7C0788E04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYmPigC5T/8fLBdjwDIeBJDHBtFebO9uJPLLyyCyPBWrrRrKfzkgLTYhFBBqc2aQiCXh2sx47oxEVE+vRh5Y7usnu7TGiI+t9GIcOnzzXIBhW+4DWBhYe/Mnr4JEqoKJRwsLWqs196OEsKL8amInRby6PMZ4tdwA5KcYTttPLz0PRnKTj0RPJsps94wREWOIzh6rsdqOyCL5HSfoS1sN3ENiOkeHg89vL+4RptYACbpufVZ6TO2xtcDTkojYXvyvQ+kaXcGIZvcURdgwGn6yhuM/TQ1rNoHI/Jwj8u444CX/vvebSb/SS3icMgae7LKvPTHNRxN8VbYUObUuYy6SThO7bXL+uMPUTLHV1O0TNexTNI32RARrLYgW/lSLtTUsf7u4KR0Wfqcs5LZ72lm7t2oIfFdZacUhsGsZ/BXxwDX+OJnncy79bMLD0GFyFSCXnyyTSolvCAfrcrS/SPj/MI0iVRkaeJ4VPjgTHV7f95KCw6zVHx8zWzbCUuh3HYRDbFGclvBQUWkx32pbB8OiVJCb2mba9mmpE4LJjU+jdc/xuHtOvSdh2brzHdW9WPYqGhK6o0cxVQOIlkWUZ6EqyXaiVvx182lHXIXGYx8OTE0M2h3I66dR5l/Nt5R5Ivc2zqAdr4BIJsTGYJgX69IXJ04Ln3kJpDNqWbeXzHFn9E4DkqKPHm6rX29FsPSSndmhJyvH286CjhCCwlUC9+CrWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MLu1rr+RLmvIm5WzbITXdXbHkaePnvYG+Wif4XJ2VaxmNM7lAW5OVN9bhHGQ?=
 =?us-ascii?Q?9H6ceGDG2CdCecQgToJZ63JHBq8HHWYpSL5JK378EPkrehre9MxRCQCY8I+Y?=
 =?us-ascii?Q?v/sMJxdnwtyIeH0s0j97/kF/5uk++YyhwdeURdVegyKwOcQi9ot80TAJeUwx?=
 =?us-ascii?Q?iTYjaR5DlH3bNMQxHz0Y4An55E4Txk6DVXFMBKj3YBKAslGDJSivGED4lwre?=
 =?us-ascii?Q?7XtyLSzXQeeWlKC5XjTr1O6RLAEC0xLIyuGfjalxRaTntmI6sl2FRV8pSJY5?=
 =?us-ascii?Q?9a7xFEWfoEms5ZQzmB14GFIuNkZYFBcxE+H4ejgmJoetuqi4tWRLoHCaqkHG?=
 =?us-ascii?Q?um+A/a6Z8APK1W9jqfqJgnKytVI0+OlpVDRguxXJH8RHdmhOlGXDC9G6phT2?=
 =?us-ascii?Q?CpIXxBZXaGYz/f9itiR7bDJ2sUutn540KtnBZdR7P9OJMedRkfRmZEuAz2i1?=
 =?us-ascii?Q?Utq8J5bYbFydYFcNqbkw9lXbUvOdgZ0QYZz+NSK1WV/sJnv6e57vgZ7DEq9O?=
 =?us-ascii?Q?65OwrMIsqwgV2yVO9UUzkea01lhBJuPopp2PR0NqFvhEyNTrfb1UmiePhCYu?=
 =?us-ascii?Q?YhkWmDgN2IAZsGz2gk53kdpVr0PmImpImxmZVvSrzb4GD4X1pmiIfucboM3p?=
 =?us-ascii?Q?h8It+TkuguX6gPNclCr7QKhEOUAXQibZ7j6eQ8QtwkbgXn4IZJmFbvdfMeuS?=
 =?us-ascii?Q?MtlchOIy59WFGzIFcLZ0tHBZXm+9R6WOyCbqTZhBHs7xb79bkmNJCj7VjaHp?=
 =?us-ascii?Q?XQqTLgPsEe3LBmyn1NAR7dbno8bmGSBx9pqRRAXJziQAW/x7KSZhXB2X/sTr?=
 =?us-ascii?Q?M6UwljHPBp0uny1ot+gHBaFYe5MrqnVDQyBJiXO3G6CsYbZJZtA8xW6wKXN5?=
 =?us-ascii?Q?7n54acWHgOp/wwW1jxtFXekc5cIovPUihyPBqRwH8cNnVuGk7CGG1g7o6UUJ?=
 =?us-ascii?Q?65msRf9xGZoe6eyImlQ+02p8SncvX3I3NFhTZDFawCWPrZmaTcrchQgeT4Eq?=
 =?us-ascii?Q?boKX6MMPIwyjJQxZ4vRt67tWr1B/uJehdo5733ZtfXsHH8OFcWUJ6z6ZILDa?=
 =?us-ascii?Q?1KRcyVyiTzhJ3bDujoeWSOoDzxYxpQJY/8K676GjwAiWFXufxmx3IPUB/DZv?=
 =?us-ascii?Q?OBf42XNqUX2+1WJth7lrGOlqs9CzGmixZJDligBXDD0vfPD24bqmvoA/JeX9?=
 =?us-ascii?Q?/ZFW3TPP1ux5TKosHeA89hIKs0WDyQoEZxuwSqGhvCfHsZe51DhteNzPpaYK?=
 =?us-ascii?Q?Tq+tFgMkpMF0ymWUC100rb6LPJETo6m4NCV2+QLQGyO5a3paC3u1pGZSoQgE?=
 =?us-ascii?Q?i2F4ZP/oAaaenG9bHXkWIUSB8m5hCoMVgJ6RO/zfbbjFV+z+h1lF/POe4nqx?=
 =?us-ascii?Q?yZI5FURCVsAvh416U5wqRSrfByn9rsecPxDxKvrgrvYtG2ZRrszK96U7hkjV?=
 =?us-ascii?Q?Z3qXZVT7/Wa8YtSdjkyqr8BnMKpXfJZDP/Ktg2hR6nBEK1CrjJSUuxttNTci?=
 =?us-ascii?Q?/rRbzi3MuRvGOJYGgJPockbDP2ey95FDsNcCp1CY8smpGd11tqXwghsNTdLh?=
 =?us-ascii?Q?6yqM1m1LgNhPG1v4Sz7WFKkkoDx2BxqYB5NejouPU7sqbgqWRMVWxECyGNpt?=
 =?us-ascii?Q?8vqBz+uJld2/a3qyshFBxBI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1330cc19-9b3b-4618-f178-08d9d1ee88e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:08.0652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qf5IKHNlPvOIkva3v7lCnRhdHZDPvUyFABwg8EP1+/Lwi/HeuZk/bZWxkP7stzP4CeAhQYTMRQENPkyCZRS4yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in the DSA core to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 12 ++++++------
 net/dsa/dsa2.c     | 16 ++++++++--------
 net/dsa/dsa_priv.h |  6 +++---
 net/dsa/port.c     | 20 ++++++++++----------
 net/dsa/switch.c   |  8 ++++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b3e4e7413b..9af3a8952256 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -182,12 +182,12 @@ static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 }
 
 static inline int dsa_lag_id(struct dsa_switch_tree *dst,
-			     struct net_device *lag)
+			     struct net_device *lag_dev)
 {
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag)
+		if (dsa_lag_dev(dst, id) == lag_dev)
 			return id;
 	}
 
@@ -930,10 +930,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag,
+				      int port, struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag);
+				       int port, struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -1005,10 +1005,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag,
+				 struct net_device *lag_dev,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag);
+				  struct net_device *lag_dev);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3d21521453fe..16ba252d1417 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -73,7 +73,7 @@ int dsa_broadcast(unsigned long e, void *v)
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
- * @lag: Netdev that is to be mapped to an ID.
+ * @lag_dev: Netdev that is to be mapped to an ID.
  *
  * dsa_lag_id/dsa_lag_dev can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
@@ -81,17 +81,17 @@ int dsa_broadcast(unsigned long e, void *v)
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag) >= 0)
+	if (dsa_lag_id(dst, lag_dev) >= 0)
 		/* Already mapped */
 		return;
 
 	for (id = 0; id < dst->lags_len; id++) {
 		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id] = lag;
+			dst->lags[id] = lag_dev;
 			return;
 		}
 	}
@@ -107,22 +107,22 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag: Netdev that was mapped.
+ * @lag_dev: Netdev that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag)
+	dsa_lag_foreach_port(dp, dst, lag_dev)
 		/* There are remaining users of this mapping */
 		return;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag) {
+		if (dsa_lag_dev(dst, id) == lag_dev) {
 			dst->lags[id] = NULL;
 			break;
 		}
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 760306f0012f..9a5cca9a42ce 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -73,7 +73,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag;
+	struct net_device *lag_dev;
 	int sw_index;
 	int port;
 
@@ -474,8 +474,8 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..bb42ac7ed53f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -440,27 +440,27 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
-int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag);
-	dp->lag_dev = lag;
+	dsa_lag_map(dp->ds->dst, lag_dev);
+	dp->lag_dev = lag_dev;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
 
-	bridge_dev = netdev_master_upper_dev_get(lag);
+	bridge_dev = netdev_master_upper_dev_get(lag_dev);
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
@@ -474,11 +474,11 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
 	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 	return err;
 }
 
-void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 
@@ -486,13 +486,13 @@ void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 		dsa_port_pre_bridge_leave(dp, br);
 }
 
-void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 	};
 	int err;
 
@@ -514,7 +514,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..51d7045a573e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -454,12 +454,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag,
+		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag,
+						   info->port, info->lag_dev,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -469,11 +469,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag);
+						    info->port, info->lag_dev);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

