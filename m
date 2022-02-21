Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0F4BEA29
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiBUSFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiBUSC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5915A36
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g51+RZEQo6MbMx1PiHJqTuovrmrHY2pxqIRGUG0LAh/TlwMuI99K5OlQqzkIoQO1k/9lDHnecemL200ydKXKt6JQQbbjqMOMj1b5eFhv5+ewKJsjbllqz8kAs42CxfWdgrqUcUhl0Ro8KHujxEETSlw5/S+XAXVBftW+T3ii1KIYzDsJ2lsqiepW+SEv15Z1d1BKe2WTQktUju7G8uocLvqqCmXapstmVJH86i0FAvWkA7umJxdrxjyOeJwI+Jyn3mHUPr/iP6aNvpVehP6rnDD6IWpTnqG1I3MtWuDovTykh77Di1fZD3OugyPojBsuRtKyjZ9VMcVjlBJPezTFOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vp4oLbQWTz4DroutKerewqqTiBAy8Mk7byyBUzNRkng=;
 b=dR3yiDCVM8/J5aMJ4AlXQjmXzFLqwd+5eQCQcf6iPDD981+MU3Kn+uxjkk4U96jusvaUDtLE72Yv28Ghb2R81pRLMEJoP6ZUL7nXviGxxZGi0SAXVel+32MISUnzh06WwMlCZ6s8lpzCWBRaGGj1B/vsp6ur3MDcreeTgugoGnmF+9mv8lmCp+CQXzJYcLEl4UZmsVNHxPixKUBRYvULbMRRqfUVlAfmwSpaLJ17hTzfiqsfG9o9xWGhJWY84X2/hmyC6g+WNiW+CikfgZecpco+jp7u4yl1r+WJWtYNppu+IFnS5tsRRopmFiAb92oVApsnmjfgWp9OT2Y8jNx6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vp4oLbQWTz4DroutKerewqqTiBAy8Mk7byyBUzNRkng=;
 b=rFnFzeQorGNpNa8AbC2cIysIvK+Un1Ep3B7xBBIztxBwEaLEze4GY3VtLt8WbvNHj0uKYeoE0ZDm8yATF6w00/eNPShUtRY2F46mK9NS8kbPtMpmiZqKs5zWfUjNxPJkNZIwP38E/Q2fM7NCMTHM3WXc5EwuqTpvS6eG7GlFxIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 03/11] net: dsa: qca8k: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 19:53:48 +0200
Message-Id: <20220221175356.1688982-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48a28e04-176d-4143-1a03-08d9f5632975
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3693D4063EE1430BBD43FE8AE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qw6m/+rTi5bhkJmTs5HdAnZnVsUocy7fA8yew/CkBJlJ0iJvm77RME+IJ9Y1lLPJrhRg0ZX+gnUy0VeOocOPr/4Fa2rVlveNOZHJkN4NULoZUCqLhFzzM4sYJaBCRvQV7RTOLvH7ivU7PB7pjCZS9oA5QNckah26n/FGwnwoFDWfCtvGEY9LlBvJLb2ZMbB/BLwVrtVvMMVvvO4Sgd+H/UkA+BWBUiWx6LVNSKiIYmsUzh8B1kddZF2wt/N2wJQW8A2WCEpwTx7uCjOCLIkRM8icLGI8cglZ0ICheS6jCzjns8m2C5LYZEyvUW46I+y5TajEzbvTT21Bb+uBMWKAsdyUsvhSEZbJzUHShZNFQ958RLfgnfAJIyqGc3HEtsPsG8mjzbHYnH044b3Y5nLwaxHud0RdJxtfSsz+E4dxMQ2R4nxu6FS8aKi1uyik3PcHsRx77jWZJajuGgoUgu8lJMr7l6I5decjctzyn1Kly87hSMoe33jZWZ+EZwVbPCujjjQwoyZ+VeMuBdhipRAFEtrbfk8PHZfwci5869fLxrJpeKoe+lfeMzgqZgE4gOzHRALuq9lVnPxCc4oyH2PU4aEvFjKmAAw3uQlc/t4X2GKIZUpGVTptsi4zu6jbCKvIFYZr2HS2HB/IMuUPaJ2igavmh62m1YMx2m0rm7JOMmhQDEVawL6bDlsjQYG9mUKMaZAGYZCPujn94huhaetWcTiqmbTcqQc1glPqlwZDa8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SUVnH3MWbdhihUqMSrI+bbDW2DSltoEFaXcwMnz/cBqdWtj3yi8ndBquEQ9L?=
 =?us-ascii?Q?LDc4NRm9ihbFztvBKmwEalldMkdI48tXsaV4vXxvXwbAYfZY06Kup/ja9IiQ?=
 =?us-ascii?Q?zXjZjfTJzh13YEZ5lyrdLOd3Sa+lTRALUqiV9eVHjrRDLYYbQZbEB9FbuC4+?=
 =?us-ascii?Q?XsKDFdjcStUs5PayrbO/O6MtU8NSoF9JbjFQDVjR121CS2aPYcdhGRNtJ22E?=
 =?us-ascii?Q?i8mEpih7EiaQ9aqxq5isAzka5v9pjmNbslUzrvhnX+F6R8tnju6p/IwIq92L?=
 =?us-ascii?Q?akcKXwV3FE8obCmwecjGBoF8WS9oLhWu142j7crp3i9fygBuWMhB7wVCmLhn?=
 =?us-ascii?Q?Tr+DNAjl0do7VMWyDxrtcS4NAuFXrwx542sP7hrpd2cB7V6SE/v+CbEetMUe?=
 =?us-ascii?Q?3tIJKq8E5LMK40U6hlFjCIwYglkhhxNEF8O+QhgrgjOOq310Kjcxgl0rY1gq?=
 =?us-ascii?Q?SDburRSWO9vUKX7ILnczUgMLkdPeFT72NO5yX+5/eh8Hq2ogvKxa46QcCIGW?=
 =?us-ascii?Q?ai1/NdW7sADwUgi+124N8ADFQEcilsvtilojaOUOrNuexD24qmF7km/PxIeQ?=
 =?us-ascii?Q?BC//hnhCEgR0Cdb8gaHNHtarZSHPANe5qubBd+VxCLANniNvThnt8LUU+5Oh?=
 =?us-ascii?Q?6iNsBUjRn0pwMUUnzzT9sqG/Z2VAgwjibWwu8sC6GDypmMHmLgvpNlRbYvGh?=
 =?us-ascii?Q?vssbILYuY+uPsUOgxwEsKb37Fd0h6KPe7AVYVFiu9UJJjbKYgk2G0Mz8D1e4?=
 =?us-ascii?Q?Wb5gdHtbCzRUd//1EtVaRsjDhXKAsdKwowDBEe/+kuzxBx5ikmncHr9sG2l5?=
 =?us-ascii?Q?bBY5uCq1hwUwhcFlUEPsX3B1zXGcj362uH0pqYaM3QIYgpy+xxeibYltVFOB?=
 =?us-ascii?Q?47W44cGdHsiS617O25JWRsFEzoGZH+JXaQ3f2UD8mIl6UKTIPdk/w947NRaz?=
 =?us-ascii?Q?jiY34Bw3ZF4X37xdTmfLkkd2bKlTt39Em0xH/YgDyfFUnxYbuk6eZyS3YLdG?=
 =?us-ascii?Q?tDdP6CbM3JxAhMVlA/URDTMBtF54FjZE74yXnYjFo0W/AxtzuDgyuGsSmBlV?=
 =?us-ascii?Q?uec70lBLLYvABvY9e9UWMkRTsZ8Be68YZBQtPvkR0Ugk0vcuDiPRr1Vo3l8v?=
 =?us-ascii?Q?3BNupuuIQQSf/oN8XjyAJeoAdlX8xASBM2QLX/qo4yCvaxVALJjAqaiSBsfV?=
 =?us-ascii?Q?0YqdGtk+HtcrRuj+sz/LyyVyG6HSjwYpeciOBWAMvoJ409QvYXgeH1ZRR1AU?=
 =?us-ascii?Q?6EbCA+UlvRM0XjdtNPVqpdUAdQMcux71HXNmsW9kaPUDKdKM1+C6gLT7JMMi?=
 =?us-ascii?Q?C9YJWZ8CiXBS3MbhjIgW4Q3S4BfKNu4h3eCc8cxEmX2gbat8xoTZDLsz/xcH?=
 =?us-ascii?Q?pOJuGipLygJsoMbEbUVdidmGcbppWhPZ6lEJVn0FlWikSlO1rDBJe/Y3Nh05?=
 =?us-ascii?Q?4iiD53XePImKlLMg+PkwGYrTzgYD2H2wmmKDNyG1nDHWlvMewhdO9IPc3sOy?=
 =?us-ascii?Q?Zx8YVSkm1YiSldcsivo3z34chSQSy7E7K37cnHIP0oxCIYQlzyJtT4QvU/zD?=
 =?us-ascii?Q?thqIXYDxTErax6J57zd2zeyhJeMKp0/RZ/EY6wNRifmWPEOLTJEZzLhXrh6O?=
 =?us-ascii?Q?rtMs6h6doLgVzo2onR9fXg0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a28e04-176d-4143-1a03-08d9f5632975
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:09.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLHCHHOpf+ZOQTzpFv/ANVDmqkmxi62O+7MnwOQAY7UHXkMBP9g1RGhzB0H7FAkjmZAW/2MG4zoNqm5x7hquXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in qca8k to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: none

 drivers/net/dsa/qca8k.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index c09d1569e66b..b2927cd776dc 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2780,17 +2780,17 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 
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
 
@@ -2809,7 +2809,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 
 static int
 qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag,
+		     struct net_device *lag_dev,
 		     struct netdev_lag_upper_info *info)
 {
 	struct qca8k_priv *priv = ds->priv;
@@ -2817,7 +2817,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	u32 hash = 0;
 	int i, id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2849,7 +2849,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2859,13 +2859,13 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
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
@@ -2928,26 +2928,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 
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
 
 static void
-- 
2.25.1

