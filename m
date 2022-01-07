Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54348796B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347987AbiAGPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:19 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347974AbiAGPBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obCn4nbIdsJmKaUJQGq8XikqdgNJKg8T++qaJ58O1SpsdIXSP0maIW5bb/23FDUux3Lz5rxq+SKp1ZcmKQNaRBaWwN6zazLgZQ2ZtEd/wm0Lys/5Zt4KxS7AjT/G1PJ59alYhUE2cK2u/MllBvza0la0zIh1EjOA3Rb/IUI+UxgvTBpln4v1uEUSM/cnDMiKrqHYxwUwf0u6vAAsPqWbib/BiIUb4j6jwA99510Kekdrkal0vBYyCAB62RFuzJJUK7vNh6+1i4PckQeZv6vDyC6GWnzuJUnOx0uzusgU9+jkoZ3Tgb4iun0nKA3pOq+NM+V38Z4IZBFM+WbSF8AaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3W7J5nHui8RUgOAVSlBNYfnRlU2JtfZ/fFlexXZRjjI=;
 b=AeLg57KP9cSa5f0it6ZZvJPJYgxVO/oNeC2p6DTUfY0puifh31+wTR8NvRjzxpfrW7/C7Ps9xxNoSMV3wjVmWIlWx0ewMuEy6bq2hg57AqAxgUMv0/A1wWaY6rcjCEd/CF6fXxFAxq7o8jz6gFF9J1yvZHmOluY5vKgjQ6fgL0aL7iFAP2aayRuxUwIwab9pGJ/80hl1k+KNuXBIJj9Bg/ERVZxa2KPaDTndTbokf3qKiD2JJipmhiXs7asV9SdAWcjxJfzY+hhqwfJAgM+X5jzbau+fFnoCyP+ETLSDha3k+2Y5FeXSU2ErrQDPvQGLIeTbQc3JdMWgCBb8KiuxTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3W7J5nHui8RUgOAVSlBNYfnRlU2JtfZ/fFlexXZRjjI=;
 b=IpmMbPgEg8Cx/kMo7h/YOZ/eHWN5KQUHeC+EIv57RYi8htQs1fgdPYspYXGhiB+gAr2j0qyDyVbvbjcqtVaVOMjRAX5jYVg9u+xXZOAzYLfVhFTzVOucmVH85prOwbJb0ktD6Z7BYfFiMqhz883JhGOqPD+jN27cl3PyfvAbAsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 03/12] net: dsa: qca8k: rename references to "lag" as "lag_dev"
Date:   Fri,  7 Jan 2022 17:00:47 +0200
Message-Id: <20220107150056.250437-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4c241df7-d75e-4954-6aa9-08d9d1ee89eb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340883F60E1B4737643D78ECE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3CENaBaPHvUtLlHvPOHTmnT3cVXtab60P7Kb1gD+J2zdipywooflIGv8WWt4dgl/KwicwlqQ9sOYbryX8Tl2lnZUehG03XD4/UhjDaFbvLdO8Hyd4kISETrQyZRv5G1627x6d2U9776C9Y/KQi35zy2YdwhChwN2or7fba/cy9mc3xs5cnNlw/kgDDd/ix4B+QP2bBYniAFtyngDryEMdLkWXI3XKN9vklNf+e/IrL9gey6T3cmMDItSo6370RXRNgIu4WSZhFtarcxzWD0ujTkke4JhGD6AQSPg1lo0zkatu7wSRX6Fhfksqjf0oNPQ+n8Xyo7YBfvdspnNxwrh/ZhbFWqUqGSGL/94bhnvogXiw4kTEpTpCWtyRQpEBqyMQ7B9YkratrEZQOKVR2M+bljx3E6vMZgkkxjAaZOieqsl7XkAckgRe7WoEJfasq1YmtM1G3z73KtOYeBw8VBOXFw1B3g4WUZ5bc/2lBiObERADIzJp+ozlQhHvQBaRT0eScMhpAGf4M5iV/1N+lBOwDNV8iO1rSCn20Q4UfK9dWzRAQ/MECCGzH0ofbocH7sbD3r5IDL5pZ1w1Oe9YE8Ws8uhJ7CfncRV6BrrZ8hWVF4PxqtzM2O0GDE8Sf6Q4IZ5JtEn7tmzk5rCoJYQHtCvf47ZKlBycfGNPOFxEQdxYB59B1SeJU2NindqZe7CEpP4z3j0zNrkdg5tljeheJg+6GrjS3/GxTNEhbHJfHSjFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1pv2h3QrUwWS+oO2iO5XgbQedgQHWV2udU8PcF+1pT/LDdGcvm19T62L3OsW?=
 =?us-ascii?Q?B7hrxXfIZZVC22BoQvXSrpP59Jlc00y6SbBIWSMv6XUrhZIJeE7l0aw39arZ?=
 =?us-ascii?Q?IA0OPY/NJnWdnePJiM10ZjxcsRc9Y/lmCfKyhh6n4SnMTmvUZd5KVV3zqae1?=
 =?us-ascii?Q?cLDNQkZiuZR9knqfFcJkq/u9+bl+RAvTzQ/hkJVvMuHnvcEDoLE/YSvNkFX/?=
 =?us-ascii?Q?B3D+yD70nQAsOZn02zNHH1NkRm/X0DtuIyiJi1qhBo7ocqp+QjR6q4ZiZrDt?=
 =?us-ascii?Q?bXby5ggEQmrOImWa0S/U91Logi6NHfhtsnEsRj7rLjqRvLfUgsg5hmCoMCuk?=
 =?us-ascii?Q?goNQUCCxEFPCPgKrVMVGdxJP7FUMvWcwCuxUxAAMOPobqKwCbhuEmOWtVQLn?=
 =?us-ascii?Q?revxtgGlRJdN6Vt3ZcEjuNikKIDIjPadI9aAAxWfVzCtAgNK2QB6FNUiM6nr?=
 =?us-ascii?Q?mq6kbTH9r/DgO750EHQFG5kj7EkomS5ixGubw5OKnEezgyH0tHTIj7421mk8?=
 =?us-ascii?Q?J7SXZ3KpC1e4/XW6s0+Gy3qkdLsD1hpqi+vnEvRroHnqWWyXUU6byN+H3eU9?=
 =?us-ascii?Q?ajDnjk39NNXlvLxlk8x6IJeFuLMPtul3+LdykOTBwxPLtTE9bWAjM/1OJ6n7?=
 =?us-ascii?Q?qBCXwhngwk7rR8oMLi9X4XCg4yi7a70q++eyNon1VRAusUW0Cz3UfUK1Zw8Q?=
 =?us-ascii?Q?viwdqfkxqFEueHDS6oeViGmCCeX3wsemI3yn714yBzrZsgGZ7Cwa2ZRdniaQ?=
 =?us-ascii?Q?zROukgEfj9B5V1imbqu4X6QT3PXY34pv+YV2Y1FB1AL5/7YydTEunM1oWn7y?=
 =?us-ascii?Q?6zU5I1+B510HE5ZT8zXhn7bFxtCfHRGqv/eZmzekID4WLButv2wnh5QQDK61?=
 =?us-ascii?Q?4Bl5xN0u4iPn8gD2DDlhrVqGZV7FwH644F/dMgyEpDjCvr+SwUZqLr2/0po+?=
 =?us-ascii?Q?nqNa9j5dYr9Fhw5lCWc2LCxPF5RySeiLVUSP7FdnyYxpF+DKqiAm2OGeBeoE?=
 =?us-ascii?Q?dEs1yRd47QL+tNgcziVGzRjv6Hzrnq7GXNzwqZ7HkQ5zGjuBZBLu8oVxl6eP?=
 =?us-ascii?Q?ln3OsBHHgOBbA2QTNx6WJlmdRKvXSWWS6wuffQZ2m6KArG/2h3f3lsm3SL4P?=
 =?us-ascii?Q?3rd5HmxoNRAwnvP5z82yJ+LVYmkm5SnSeyWUatjt3HYuZN80nJbFxiWna9nr?=
 =?us-ascii?Q?f2Dymux0tew9DFcpqwdhxLxiMNHnn6czMuCTflYYugc+p7m4QVXTgTNHoRlh?=
 =?us-ascii?Q?/O9FWVq0fpvravd5se/VlpT/Rd3k/vrNzjGxGGIXzIcjbfCCdsbvVD2Xw+fb?=
 =?us-ascii?Q?Rm9GNyTPjGtGgEUn8HR39rq8uUudEwCedvj0F491YoS91ChR4aJck8rfpeZc?=
 =?us-ascii?Q?OdeTv8r3qbgiO8zzwqtE+m3lXX33YD1SRAh4HjPMf6H01XREXUfGzcgqg/3w?=
 =?us-ascii?Q?xUzvV/ZkAEyqR6suj4jcuCobZjxuv8UplSpt6wInxSz4KCIJo9TsaK8y/J9C?=
 =?us-ascii?Q?EwJWe3rteoeFQ669qW2oXRNwOAsVEfZ2WTiC32xizBDtB9eJn9odwMqusPeq?=
 =?us-ascii?Q?wJXFQNd78fe7OXcaTl8hVmkNB6dzdhh9xWsLT8ngzbQ2u3+uWJ4FjjmGcffd?=
 =?us-ascii?Q?s32sjFznhYtPzqf4tqDmh1U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c241df7-d75e-4954-6aa9-08d9d1ee89eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:09.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwCEyCHh4d/CTj2ow4rdtKsdPV9Mh8s5jp4oSKu3Z/QlKGRWx+7jffSRuOiNP/SFYHw+Bjxcy//NXqL1karYzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in qca8k to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/qca8k.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..253de3993a95 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2213,17 +2213,17 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 
 static bool
 qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag,
+		      struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
 	int id, members = 0;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2242,7 +2242,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 
 static int
 qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag,
+		     struct net_device *lag_dev,
 		     struct netdev_lag_upper_info *info)
 {
 	struct qca8k_priv *priv = ds->priv;
@@ -2250,7 +2250,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	u32 hash = 0;
 	int i, id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2292,13 +2292,13 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag, bool delete)
+			  struct net_device *lag_dev, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2361,26 +2361,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag,
+		    struct net_device *lag_dev,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag, info))
+	if (!qca8k_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag, info);
+	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag)
+		     struct net_device *lag_dev)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
 }
 
 static const struct dsa_switch_ops qca8k_switch_ops = {
-- 
2.25.1

