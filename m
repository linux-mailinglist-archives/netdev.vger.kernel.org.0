Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD94B0DEA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiBJMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241771AbiBJMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:33 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4186D264E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEu6u+VXaRmXHBh6VsC0uioAeWCQj8T4VWnF5p5+qa2a2yjyYAk2Mz7B+0zYP4J27F5ORMc9xX+6BSL+XWwkxiFW+ooChsWCIU+DMdb+q13C04cuAgHIVKytTB71mtL5aGg+MKa2DGZyQskDCoArTMfQZlWBgLZAVZ8SWsI4K13PZ/F8U6MyKfpGF9M/QF+K4ZO/jkvPRv0V4f9Bg4OAdX3ObwMYhZ4sjwiXY4gCZg0MbuiC0ZTzLLgvOfl35jY6QG3/2DZsn/SttI6RbETnqZtl3GvLLEe5YP5S1XRbH0W/kZBRMOHV6Um2wAfdVKgVQeszaZhrn7I1yoOWOOQDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/4oN6G5XaPhsBMjbqQNqZJ4SyTF5+BG/cKXlNTcJ/U=;
 b=baF+5nf6vUTJ/ozWl/uoS+r2CMN9bZTpNbtp07Xkd256hbcTJWfU/jCDytHqda0IRLOmbLAqLKzEcV3BprnfowiHhFNsqSXJx+pFtLJh9ouNUYnNDbmHN+AnO6OUkvrTs2cI2GdwJllDBpWhuIZvrThO+EXK4glLcwB6uJPEt6OGI1LJt693+4AHRdmMYpRA5xUDUrxTXghVAWRuO3/P+37W0RdKWokw3eZdIQaxu0ChrUlINhFSdK1uGpFQj2uyxkBm16Q0NiT4ihBkSpbGGbGj3+Jdi0WtDjGZHcK8ksBk7IHPDTYeTKhP74xHsIEzzPvxxzCLR9yVNBwjOtlukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/4oN6G5XaPhsBMjbqQNqZJ4SyTF5+BG/cKXlNTcJ/U=;
 b=UQNsllLQyqPtIM3APtbrbURtL1L+6WIqPVlw0tEQ7/nubBgPuPLu+6xS/5mskMPUHCE6yk+Zw8/uOcX5zmQn41adatG5f0BeYLY6+WK+cNI8ykCyKJ1ZXD8cVO8gHtTbbS2WUNe+Kgjj+LaTPxNRzlGWHBMamanHnfH8DwM/XIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 09/12] net: dsa: move dsa_foreign_dev_check above dsa_slave_switchdev_event_work
Date:   Thu, 10 Feb 2022 14:51:58 +0200
Message-Id: <20220210125201.2859463-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f8cb77f-6313-4bea-213c-08d9ec9430bd
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB880617D85446B9D838E3123CE02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMKo6gHNMdw3lFEkYUe1zi2du/7bAll6iffZjAiprgpdTfH2JdRAmuCdL/n5EQ+duGSkGTlN67PH1CkBYSurlM5kkwWCPNoI80YIkv82rSl72Q8cdYIMGoMDiyrOhw3hkcEoS6tP+cI9BALjVSBvAsXR+hwSEc2nQ1LZYpPejxAQby1U/1ePeZwzy6A9Q7A7gQK0U9koG50ShB5PF/ok0jFuXGnUB0biwtUZVNkJPIIOwf7lKVhaI71EUw7/i2+9ZyJHMRY/v5DAX1lLN+a6RpaUBESpmx5DCrUgkwjYSJhbepX76zJErMDwA1VUQTsGQxhh/rtRtuDtAw8XU/iRM/TRDcNUthA9TiYn1bRWiYrWsDWZCOdRaC/hVMSIVSnNwH37Qw3P2/pagQxLNd3TVzR1GlvKMJLqEBF3KFEwgj4FszVtSBJch4mKz/jqoKQNgK6ceb/gmWKufWjZSJJadIdQigeWxEt4eZpwQYTX7sdr1nRG4RoA+ddAfCwFywjDqI52yC3BAFHwqn0E1b9M7Yuk35vI7YoSPJR0YcufAPkYFQx0XFRZ6ygT5gYyNk2L0vda4mKboIOVn1n5NNLQpeiiE7EydgIEhZawR2hvZZsruVuAl4QRGo+YUSBCxJAvrIArcFOX7z7XKVUryecCsdqlzDhdK5JG/0lx2VCdOQ+IRsl+D32mu06eDPOtL4SLFtzIb0S0VWeLuuG/KOXwtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8gO6aaTelhR4Ixdg0z6BL7qFhGVzyqeBvX1KLdl1bvobOhOV55VURxQuyZg?=
 =?us-ascii?Q?I/OP0cc1L5dd3O/Ls1CAZ/XS42hengAP6bAyEEmRZqH/kbN2bIpJ11xrISuJ?=
 =?us-ascii?Q?49tymlkDTOqpOz5JbGzfyvGMw8m8a2Zoyzv5fwnvHwFO5zP9AJxVMNxmc7lY?=
 =?us-ascii?Q?qtz4gHZNt5i9jz3qPkkbTCEADmwC8S8g9A6sssuK3uBdDYjSltsGzJSAiUTO?=
 =?us-ascii?Q?wExoLRgtVvZNxoD5gufg5vOwwFq8N417hRwrdhYRm5KApOPGFvmgRz0T9+Hv?=
 =?us-ascii?Q?Sy12BmNWBoaGRSRF9/nD2DzZJ9LuOGW9dUIT63zjZ/FimOOSnA2W8/zmf7Z/?=
 =?us-ascii?Q?BQCOxY3/ICDCRdCRt9Kpwb9mNEWSnqHoNb1aY8NlVt7EyXkef24Mf8EsebKL?=
 =?us-ascii?Q?QKf6/UFz6h1EuKjuF/POd2nK2g2V9EvdV1HMU+CQXB6gLUqsxoACGhEQBI9C?=
 =?us-ascii?Q?ssL7NzfXqZarRzT75w7BnG+YEkLtrYDbM9sfxxoI3ZwydNAQleooOuH6soA9?=
 =?us-ascii?Q?wyuNFtZqB8T/U5Q0nGAurZ9MiruRf/vlxDxvrwlr2LbOKObk1B0HQ21rxujz?=
 =?us-ascii?Q?/Pd7IGoDt2nuJuKRhPBK2kpWkFdxYBQiUrP2ebaQeT+TJWLiVOJwZ3XZErvN?=
 =?us-ascii?Q?AXOUBul+vZf9g8lc53HhBGa0aaM2EJS1yUPidPXRLpGjAeA+3uInkUoIDBxW?=
 =?us-ascii?Q?P3SC8TKuqorOhZDI+o9A3Z27NFJUAffqzpOrhUpQLmJP8E7z5kbGP6EVeNlj?=
 =?us-ascii?Q?178lIotlR9yk6qOSmsPiSvcHZEx6OOnlhzJhivtmRah1IroBSiQXiH00ry6v?=
 =?us-ascii?Q?H0jsGGgNlDbzY0YdRzV/5HJ+aGYu+BZL0600A5+oPaWdKl76ECnx31WxpvIn?=
 =?us-ascii?Q?1iASU+FnL9+MbGWKSEArFqouxjoL4gm3A8vqLeq9ZjswGHWbb8H2/s5NoSFA?=
 =?us-ascii?Q?H0b0Zhy1zKRT56fRWYxAu1rkmXj9cB5d0wYaT3bnI/GVzBu7Hqx0/TDj8JV/?=
 =?us-ascii?Q?XMuiV6cS3Qm65r5L2pCDs1ktxDcc6vHrafPMcROtBadv6fMA1XOyjhYm0YlG?=
 =?us-ascii?Q?JgrW+cUs3pqJBoMbVGnB3Uxh6jHHyWdQzR1/Co5rewT5e5AJM9ZnHVOt7go8?=
 =?us-ascii?Q?Yg0jL2lDJB848zCzcbCaMrsbddhp3iqw57y9J6RP3DAiornv5WC05B1I23C0?=
 =?us-ascii?Q?6jfOzg6OyMCYwNuEseqsJwBfVi67v0bRpmraUtMBTDAKiazHMbw2zjNMS+18?=
 =?us-ascii?Q?BrojjUeG9wni1kPohGwJrFsXQmDP2kcgobRLZ6Th8oxC5tcIjvwJ/HNkL2v/?=
 =?us-ascii?Q?SKJyBaqSDqqKc3gxSkL2Z7kp79iXsMiO9n+b7eqZcspt1gbJ2+O3QfltCYHw?=
 =?us-ascii?Q?UhOwZTiHr9xWtsdfH9TgB4FS8i9ePFOf1mAYV0oTg6Vj7wYPk8t3DJetzYXr?=
 =?us-ascii?Q?dUYo+PBG9j7mmOCK8yrIKi6c5xDITe/8Uz2l+jDtt6ap9sKCddXvKDCAs5Fy?=
 =?us-ascii?Q?CNAfP3ZlSds/g49iXh5Y36IXpa9OdTNsWJmgUml+bksjs+KHoa9g0mezj01B?=
 =?us-ascii?Q?lPE82n7/b7hT34jXs1l2VplbEpU8sqzLFWKGMAH2b422EAISqCouj72igRiG?=
 =?us-ascii?Q?BKTeGH9t2Gy5POZXEk7ZVjA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8cb77f-6313-4bea-213c-08d9ec9430bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:26.8683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytY2a0cKE8oeJ60Ymrs4FS1gVJWbgnLXGIEfzU+e5hFaqbXwerYL6rK/kY8ktw3xEWV4F0/mLX5laZpbkmS+NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of LAG FDB support, we'll need to call
switchdev_lower_dev_find in order to get a handle of a DSA user port
from a LAG interface. That function takes dsa_foreign_dev_check() as one
of its arguments. So to avoid forward declarations,
dsa_foreign_dev_check() needs to be moved above it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 34bb20647bed..273ae558ccd9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2086,6 +2086,22 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
+static bool dsa_foreign_dev_check(const struct net_device *dev,
+				  const struct net_device *foreign_dev)
+{
+	const struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch_tree *dst = dp->ds->dst;
+
+	if (netif_is_bridge_master(foreign_dev))
+		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
+
+	if (netif_is_bridge_port(foreign_dev))
+		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
+
+	/* Everything else is foreign */
+	return true;
+}
+
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
@@ -2469,22 +2485,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	kfree(switchdev_work);
 }
 
-static bool dsa_foreign_dev_check(const struct net_device *dev,
-				  const struct net_device *foreign_dev)
-{
-	const struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_switch_tree *dst = dp->ds->dst;
-
-	if (netif_is_bridge_master(foreign_dev))
-		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
-
-	if (netif_is_bridge_port(foreign_dev))
-		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
-
-	/* Everything else is foreign */
-	return true;
-}
-
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-- 
2.25.1

