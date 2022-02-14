Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639544B5E4A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiBNXc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiBNXcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:20 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FBA109A70
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV5cXM2+NJs8LbVyfAqFXbi9sl/uTishSKn3XyH/MZnRAcK03ifXVRruSHbuzmzh4cjgKm/cnHNnoteVJLVSGhK1MVMXiNEP+zThkaZQT9inC5qKKJ8BiNmM9MK69zcIXxHHfNbt4oFIcI+3EfdqnUOr114Fh2NXDMPgbJXuvCn3mHBamxzsIcuHwHD2C/kAuBEL8SpRTQ8kC08fReGU5w2dvcM0CTUmPPRrWkZrZVL0zROH7ek6VSgF1wdb2VUqdMS8G9zcG9PrCQLknHE0wY3FPmxCXjrY93halGj4TcvUTB/iTGiBxg6wOkXT6em6iS/qrjsjhdlX41g92r/bZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Y5TfbSjVUjHvJiyAYIr0Lm2tINnl5Npd83qbRJObho=;
 b=iUzsEK06DtvPf58e+JPKpVENgRyLpxiMDBKYTdR+8bU6QMSme61oofhVWzXKRVmlYBR3J0gKQprLQhxsGVUMM5k7X2RnIktWelB8W8lYBW2MXoGuBc7AFgMoIQwo1fHYn1Y6Zdtjb+xCa3zA1eB6yW3+3lKWDUGgN5wsP+x0GQLdkwP01jvXSIwSESvqH7OREtDf9zVDiE2B0kBXHN6dQGLTwc9l9VQ97sJvLIm79Dv3FmjKCUOCPffO+t4SYu3OomUZEsShbKCz7S5HyO+v3zMZeqGQ/GfJdezmOEBhP/DCZgYZLj7y1EK839suvxSFFNsw7Sk7awzGeAlv3u/eaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Y5TfbSjVUjHvJiyAYIr0Lm2tINnl5Npd83qbRJObho=;
 b=Z37Ru+niYS39EjHFuOAI+ixlUHa71MTJeURhXprufOj5zgv8DVuhYhuzM+1lJzIIkcUm376OIITiJZiHHxzdmpXayra9ZZDWhMKRR70J2tKPuQKP33KhCaQ34JoKaCCqpNrjkphJcqtpgWcMqJV+7lyIoUTKABT1f/kB8R0zIOs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 5/8] net: switchdev: rename switchdev_lower_dev_find to switchdev_lower_dev_find_rcu
Date:   Tue, 15 Feb 2022 01:31:08 +0200
Message-Id: <20220214233111.1586715-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5da523f-d963-43d1-330b-08d9f0123825
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504D74751C5BA69ABD7A568E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTZjHMcvTlgQcI7HHRQpnRRLmmolgxO3+iERdMGBgIDhjtWFSpiu38yxihyqM4DhozEGGOoEUIKQqbj4ZjAFJLBg1uC3R9K0vY84a5A141MBCA6Xz/HSADKZk3S2erZ2BhHMOrVpcU2BMaaM1OAPz2RUoc6UyuFS6PO/ALDPbbXkOWj/ozxw44tN5BO2uSpbOvj65K5wbkfeCQDfvgXEf0hJSkeA8iDJI+ocXul1500wCpqw5VAiY2catWJt+5jkUOSTQwQvlN3jB4lRzV+EoZDpI36ez7kbO8m5ilBD0x5YX0CnpdysPMTbcYseRctu7gePikUAJX48lUVluFULC04k66SlnvHkz6iurNk5rSJ7aU/bjiqqqn9FVkjhNqw/bOwWL8UclIYBkR6E99cmJleeuzoaSJDIwuqO3g/J4fBd4+KRwJD2Dx2y38nry4aQQ+Gp4e4en9ZIG9c+Xb0YHZGrN03167doxM8YYLy/0Xru5EBKll0idTJYEW9JnkMN23/Gz1EMZ2QRYWubfAGhVc19WaWqSs0kHNX9tdtjHWpinsBWDFEEPx+7IzLdGt/JdyjNUbrUGGY3oxVCayrtMExaGJxeMrSXV49ckv4IbggL03Jvdv1+AUM2CIs/SVM1Y7Gm+30UdxJp4+VvsV6hpxxCswl277h0Ln0HZvKULSDgmbdLhZfjKIuUC33DXpzfG1Iw8E2m/LLvivo2PGO7Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jJ4H+G7Ibe1e4s9Fi6w1RbNdnpF1qkalnpcIAidFswTddtTqDTxfzNLJVk24?=
 =?us-ascii?Q?Y5uVrH3bVkIXTc5Cqk+v3bk6ux4BQJ8O/UJa2yz6X9lpbnpQ8x7nQY9rBVUk?=
 =?us-ascii?Q?wQN1Nz0+eSwzUmAQNU1iytbsQsgZ/hFIcr7yc1d/NHYeHRPPxk199sXJH5wW?=
 =?us-ascii?Q?kUC2AxKNV6gWlQe2nUXaDNaLi1/btaNKdmKfFvfqiRYgbWZnezUoi5k8W+uv?=
 =?us-ascii?Q?dg9Bso5KGs1x70gOpUFvO8YPLNe41LIVV9TKMA+wE5APiUsvhaoOu262zyhN?=
 =?us-ascii?Q?/2ZafXAA8wuxBEDU7x5KypQhyxaw4nDBVr/ugEl7rJRJeI4RRn6KpxRtUZUQ?=
 =?us-ascii?Q?3BojRum1zFq57rYKurYhddri7PeP1+goYokDgopLzYNZu0AjA6f7RdZFGkjN?=
 =?us-ascii?Q?5i38y/cRoRVOMqk/rwxN0XmbdgkXgAS1prRgBdG64kkMFGwPCnO/08nySa4l?=
 =?us-ascii?Q?Z0pQMkYmViW8774wKRHY3rU1HNkZL5nHtv+wDt5Jok2NZF+O8f261529ZbaO?=
 =?us-ascii?Q?o5fOYM68Ns4WWvId9w7010sFD6RDRjRnCrKKDDunUpezRnSp4RSANZqlS9AP?=
 =?us-ascii?Q?A+u3wP/i+QfkKMuyAyhrGW9C46KvJrsxZYREvVnOmrMXjNOMrJzZ5Gv7kSmx?=
 =?us-ascii?Q?jbF/BJwzGelNXiFEWifbeaxN5B428a5g/f9RxO6YvyQZbKmrten4yBNfHE9Q?=
 =?us-ascii?Q?FX0VeHw3RXSnX7VFvh3s4FepuLEQ6dLsdRkXOyBH/ygQwuLhzN8ofbdD6I10?=
 =?us-ascii?Q?KCaArcHbF8zgOHrUTkjI+x1yW2ZB809PPrIP91Zs8Rd6+6ohOeCc6C6w+Vr2?=
 =?us-ascii?Q?h9JiADeG7sbKVXtANftnM+atisfnYPF4bWMb8bbbje2P4Q+0zO9XrKQA1wPo?=
 =?us-ascii?Q?U+1WTjPT5uZHECFSxm+6DVQSVvrO7jG0S/hRifNoC9Bk6f8aZG9ZkyhavI0U?=
 =?us-ascii?Q?2XK4T/Sjl4iBSxRXrZdpPp+zru5uyWwHBJku4mk6j8MIGfxeOFMutAlcnye1?=
 =?us-ascii?Q?JFfJygiFrdI3ZrtWYg6sThlcW4kAsUmAGS43T6ofqdt9R03QXL4sVOYhwSsA?=
 =?us-ascii?Q?zO1OdL4gg1ZrHejpV/G1eQ00t6tXxe+6T755dKHjn7okG5Q3idwA1hIUGtQF?=
 =?us-ascii?Q?tA/cIoKlEuiJr2GMZpO0kHRdJfoGdSlM31cseWxDiNUlcFf4Q+TpAdAR9PtY?=
 =?us-ascii?Q?YA1nIrblO1p9JGBLj/H9pLU2U7aVv34qWxgC81ZOYokKVJ5MoIAaJQdiDr4L?=
 =?us-ascii?Q?IQflYvSWZ0kB3azl3iLkTJAvSVZCwhFrorhFlKBry+9XunYhm/ZQ2lGJjRLL?=
 =?us-ascii?Q?HkirnDSULuhvFuq2jYWxNz9Xgma5nGZzEL+8vZG5ZUVgW6/YfUPWlDjAIjmn?=
 =?us-ascii?Q?7oulbbykhfMEUHqOdUIjkF/XHGIrsHfLAJz7BEvchexedZizbrT9tjXGS5hZ?=
 =?us-ascii?Q?9euM1Aozu0Z4L2HRCkQ8y1CoOZLyAXkbvvMGELwizKPPZsLFXbWSfQ1w+4Hx?=
 =?us-ascii?Q?gPmPKH2tfQmmrPRzSgAUsEKEIu1Xh5PW1atQEjniq6MtZ+Xt32JNg55KNKp4?=
 =?us-ascii?Q?5whJM4zlRwRnnmW17hgfNtrbUwacNpRozlIwaS/B/jFSi9Jq7JDjsHMDoojL?=
 =?us-ascii?Q?rx0Fub6hfBjcWwWvDWbo0ug=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5da523f-d963-43d1-330b-08d9f0123825
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:09.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jasHzTw0GNplbj0XM5N6R5bKN+QI/2heabsEFezRXcrObt6rhc7HIUAUEAH/lmjBWaDLtLgeRpBSvQyN3RHk+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

switchdev_lower_dev_find() assumes RCU read-side critical section
calling context, since it uses netdev_walk_all_lower_dev_rcu().

Rename it appropriately, in preparation of adding a similar iterator
that assumes writer-side rtnl_mutex protection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/switchdev/switchdev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 12e6b4146bfb..d53f364870a5 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -409,10 +409,10 @@ static int switchdev_lower_dev_walk(struct net_device *lower_dev,
 }
 
 static struct net_device *
-switchdev_lower_dev_find(struct net_device *dev,
-			 bool (*check_cb)(const struct net_device *dev),
-			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
-						      const struct net_device *foreign_dev))
+switchdev_lower_dev_find_rcu(struct net_device *dev,
+			     bool (*check_cb)(const struct net_device *dev),
+			     bool (*foreign_dev_check_cb)(const struct net_device *dev,
+							  const struct net_device *foreign_dev))
 {
 	struct switchdev_nested_priv switchdev_priv = {
 		.check_cb = check_cb,
@@ -451,7 +451,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
 	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
 			goto maybe_bridged_with_us;
 
 		/* This is a LAG interface that we offload */
@@ -465,7 +465,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	 * towards a bridge device.
 	 */
 	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
+		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
 			return 0;
 
 		/* This is a bridge interface that we offload */
@@ -478,8 +478,8 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 			 * that we offload.
 			 */
 			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find(lower_dev, check_cb,
-						      foreign_dev_check_cb))
+			    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
+							  foreign_dev_check_cb))
 				continue;
 
 			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
@@ -501,7 +501,7 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+	if (!switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb))
 		return 0;
 
 	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
-- 
2.25.1

