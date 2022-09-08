Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CD55B23E6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiIHQuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiIHQtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:20 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A3312BF98;
        Thu,  8 Sep 2022 09:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk/BX8p3fmK0gFSbLjjEH+kBnLLFm3EoyfdMi2+810jnw4m6QDykH68tCvCzilx5rU+ObFamzLvA4jseVjosro+bD1sfFFTObC58L8IGKUQBmCBXQJKDWUNl2JE5aIPALzql1MdvaXUQdIgt+9n2EVUgHtBYZVoz53E1eiYqkleN2XPAGhiCzOlMTqPdw+rFC+z4lGUbvqPqnFP54baQT27AixvjKmQl2TePm5QWYyCuE3kKqHpx5nmnq4zhSVeFg18FcQDqaAB4QVRrBcZpsDEvThRQFMmgfWhAF9jmq7vhb6AiQgYObVWCldtZ0FLweHP6XolLyVIW/ABvs0FSlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iQqOY1/tDR8KDGSOtNUmtcN+KlaNtXZM2GaBrgmGOo=;
 b=NZnjPrbk64TppRPyfkwyjgCghntP5v6vrM64IViZqKcovr4WcolfKOHMITO4t5w9/D+X7ZioGeedOpYqkscpk+wrGeo3GScOkCQqdxOiuMmYfHDoT+0WO1ek20zXgbUTR24WJJw8V4JrE9iyMICnvxe8+7owyzUdHSDyoHA6TDYFzWAavnaffXIWDNScIdaZJvCo4XsYMuqAKsf+fd/RQP3pMm/3FxwSDzFmES2yGS8WrFi9ZS3ewwaZluVwNN0dEaOY4EmCMpH5kXlbg0rrwdQnm2Q7K4Z1u8miGSp3QhLeRhIGpNpeA23sPT7iMlYWf2bdTB3iL6suVKI7LTmlgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iQqOY1/tDR8KDGSOtNUmtcN+KlaNtXZM2GaBrgmGOo=;
 b=ASArvijFeiyLC/Q6lRUR28fAvrTVvLa+3/3QPwmnmZlWzRjIP16F/yx82ESFOYhB0VTR3smWCY+5nxSIeVSUhyfkT/i3ZK116leEsKAKr0Bre56WvrSqhF9n9eFuSR8+fQhKQypXaO/7zlzXJ1N8iAJjZpngakOVbTagBdjzgf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/14] net: mscc: ocelot: add support for all sorts of standardized counters present in DSA
Date:   Thu,  8 Sep 2022 19:48:13 +0300
Message-Id: <20220908164816.3576795-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57bb4739-3121-44ff-f966-08da91b9fbfe
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHHBPUFVW5PzFPwC3AwjHOuFpzNET55qVgRO2gwB+iyA8h373fBCXMKa8GgL8hhvq4YzmP3NgFMjSYf95vaQN74t2PERN3c3/o6jBsVSiRnTRym199+P9ZVUrhadRAKooZP1gg+Z/Co003h3RktsCuHl/ZEzouqBi8DPKnxfOmK36zwBfMrVIvq90yu/RlzzlzEz/c3cmiq5prslLSBBtE8TjEC/YmxayRnBkpB3tvAtBoaiZ3dqVeKrD5hBxzUSQz1t7AoyPbu8U1EHhYfSFU8fJPDBQT1GtyuTqaqQNM/iO/z06MBX+pwY0hLL/ksXwPvEsaxydHmYGTwob5UzCXJl2bWdhTysYDqQweY16PxbRLmCen/C21WMgAEJ4/BKSYL+somRstPOBxxHf6nnrn3b6tMcOm+y6/38pO09Ra4QY2O7rPgUcbgEChkKElvtGeZfOataaOeX6C0e9Nac+gNKKAzg/6nMYS8gx1MrH9ORrYVY/okgdGwVba6pbTf3Xu7LzIxKKqC2NxatsXW2gAmo/Kw0eenO3xAE1P3qONtXzP0V0SexVdw4vjj9Wqe+dUCqECNOxkHh68mWUHOcJkug5xlwqL34fCgqJtOnSiKL9K3Jku3HgJxfmnJIM92zrHmUhqCTRwZf4r/L3Xzqvt/N2EaLXak8Xc9pOzqSqR3xy4CCLAPTegaejZKAxr0Q8REp5DkXxeyBSCIMt6i5gDgnWw2zggb/xlTbtx7T4MeIvLBzHy0ITS4btUlNzJ9Zw1nMVGdmsOVhg3ib69ni4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(30864003)(7416002)(52116002)(41300700001)(6506007)(40140700001)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HfgPmuyZOW8iepf1Wr1tZ1FKp6qu3WpZkxGwcW5VFUJrKn8bM07qazuy/L9F?=
 =?us-ascii?Q?r5CObZV0XvOvy4Uu/l3QPui63jjmYAr7CYCCRd26y/Wbjg0zau1gKD8CYk4T?=
 =?us-ascii?Q?TuJuJwSr0Y7NPYuz4HI+ilp1uBE3YatgdhAHO5REsN05b61N2yBcGQU68xou?=
 =?us-ascii?Q?QLWMDc2oZiYpNqTLAS9yZN/rmL/f3GFJvfIbW/QjD31jIp8Rz4/zgBxsXLNl?=
 =?us-ascii?Q?CSIEAGNFkgbijSiTv+vIdGJ+GAll2/iyUttKG3Vx1/h1dzLLKoTHCyrHsRa1?=
 =?us-ascii?Q?UAyb2VmmZjN8lmTBk80A/KDAMeh4eTJOf7zDjZhmuZqUgSqC1CtFdoUvb7yQ?=
 =?us-ascii?Q?XnZp4/6y7hLo9Tnka/zguy3xqoSdKBWNAVPopAf97ZAh1p1Z9sJ74wwqj7+c?=
 =?us-ascii?Q?vfyGyt1NJuUqMF+z8NqOAuokOFl6U9H4Nd4l6N09OruPmbfLufqeBYTkbfZq?=
 =?us-ascii?Q?TmaOpZYNTBJhsfjB8ANzCOvh8NAO4ZAeUrVZ5djLLpS/WUQc15Anb3n/4pYQ?=
 =?us-ascii?Q?RCtlayyZm5iHaZR0e5EsofhN3Hew+R1CmmpizVaehA6JKJKTjv9FslWwZfvl?=
 =?us-ascii?Q?xcMskkYyGL4KyzRVt2LRj79E31WSn/i2GwTim0gOdOomsr0P/UYDiV0BhLhK?=
 =?us-ascii?Q?Dt5s0zRMDvQcGXKGJgLcd+3HwPgkt8iM2vdoW/ia3zXL9gudZuUx1ZFtdF/F?=
 =?us-ascii?Q?qHdGXUHfFcT5PzdWEtBFeS17Nwj38+CHVFbxzad01kVTFy5ASeAEWDSO7FCx?=
 =?us-ascii?Q?MHxz6cbu6HoQuXqAeV6TigBnLGD+N0WhicIY7BK2i0QYnv66fv2eLlueeIl/?=
 =?us-ascii?Q?7vDz5sQoBFsVd69eFbZptLhWe3J3s6ISnKxz+qcT9NPiNpXqZYYLle/bV6qP?=
 =?us-ascii?Q?6aHxY6Pu8qtjiZPIFljIQvUSBEy8PbjAAeIMergGm4mhQ7pCR1WdI0A2LGbF?=
 =?us-ascii?Q?srwXRVJ0y0JH1ozybgvUGZDdqLivQxf7DvLphUUNOsvBp9w2PadTp+gEL26a?=
 =?us-ascii?Q?DzxgWKqtf4G5kFj85L64jij29dFPejEwEIYUne5qSjYh4rz/aiAhS3g1c7pM?=
 =?us-ascii?Q?4OvBpTPqrFWa6lQNhDs5bG8R8UP+FBfBTD4IkYxE7zpIobqmfzGqjVi7BLUE?=
 =?us-ascii?Q?NdpAj9OddIJf5dIF7cZeLiRL8DsKsM7WSGKd7JFlhlr28WwBUodGDgAjwjSH?=
 =?us-ascii?Q?i8pEaxyg0edcebzrO7BetNQSfeygrruWXPjfk6XvfWZKgO1nlOJoewiVIsmh?=
 =?us-ascii?Q?hw9v8uFlHsr8JpGlq3YR2C4jFiqVH2vKi8buhT43U4potKc4Rr/K8ZRigI0Z?=
 =?us-ascii?Q?jknnJ4+jJEbJ7hl0TzIzjKNQUBNQvrsmdj1bJk0qmPLANxzz6ujtcLbR/Eup?=
 =?us-ascii?Q?S3FpfEaIzGzRgVQ+sNj834fxhnH5ohH64L0UsVO5zIxdO7gJ9EczJ8m92wY3?=
 =?us-ascii?Q?SmR4LQ3uQNN0yh8SkSi7pTV+wlCI34wCIdc4aZBY65PhDND3Up5/XpbUIQKw?=
 =?us-ascii?Q?9Eil6/8VKE3Eg6gMzEgTfctAnMg1n3S27G9vBP3rH+Ib1UHUXqNvGcgosFUS?=
 =?us-ascii?Q?5msvgJ80xqa4ALWVTp0rxsp06b8juLOWXRLRIws+8HnUUM40n/dRBj7ubMZg?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bb4739-3121-44ff-f966-08da91b9fbfe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:41.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5Dm/I2NKs/1hILZkRpVzAekBmjiPl0GJGYfg1Wyvo3dn7xsIQTBBAw7PlurRCTIFTdT5D4qLPS5c2q4uXOsrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA is integrated with the new standardized ethtool -S --groups option,
but the felix driver only exports unstructured statistics.

Reuse the array of 64-bit statistics collected by ocelot_check_stats_work(),
but just export select values from it.

Since ocelot_check_stats_work() runs periodically to avoid 32-bit
overflow, and the ethtool calling context is sleepable, we update the
64-bit stats one more time, to provide up-to-date values. The locking
scheme with a mutex followed by a spinlock is a bit hard to digest, so
we create and use a ocelot_port_stats_run() helper with a callback that
populates the ethool stats group the caller is interested in.

The exported stats are:
ethtool -S swp0 --groups eth-phy
ethtool -S swp0 --groups eth-mac
ethtool -S swp0 --groups eth-ctrl
ethtool -S swp0 --groups rmon
ethtool --include-statistics --show-pause swp0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           |  46 ++++++
 drivers/net/ethernet/mscc/ocelot_stats.c | 201 +++++++++++++++++++++--
 include/soc/mscc/ocelot.h                |  11 ++
 3 files changed, 241 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 71e22990aa67..c73ef5f7aa64 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1042,6 +1042,47 @@ static void felix_get_stats64(struct dsa_switch *ds, int port,
 	ocelot_port_get_stats64(ocelot, port, stats);
 }
 
+static void felix_get_pause_stats(struct dsa_switch *ds, int port,
+				  struct ethtool_pause_stats *pause_stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_pause_stats(ocelot, port, pause_stats);
+}
+
+static void felix_get_rmon_stats(struct dsa_switch *ds, int port,
+				 struct ethtool_rmon_stats *rmon_stats,
+				 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_rmon_stats(ocelot, port, rmon_stats, ranges);
+}
+
+static void felix_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_eth_ctrl_stats(ocelot, port, ctrl_stats);
+}
+
+static void felix_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				    struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_eth_mac_stats(ocelot, port, mac_stats);
+}
+
+static void felix_get_eth_phy_stats(struct dsa_switch *ds, int port,
+				    struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_eth_phy_stats(ocelot, port, phy_stats);
+}
+
 static void felix_get_strings(struct dsa_switch *ds, int port,
 			      u32 stringset, u8 *data)
 {
@@ -1857,6 +1898,11 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
 	.get_stats64			= felix_get_stats64,
+	.get_pause_stats		= felix_get_pause_stats,
+	.get_rmon_stats			= felix_get_rmon_stats,
+	.get_eth_ctrl_stats		= felix_get_eth_ctrl_stats,
+	.get_eth_mac_stats		= felix_get_eth_mac_stats,
+	.get_eth_phy_stats		= felix_get_eth_phy_stats,
 	.get_strings			= felix_get_strings,
 	.get_ethtool_stats		= felix_get_ethtool_stats,
 	.get_sset_count			= felix_get_sset_count,
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 2926d2661af4..dbd20b125cea 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -2,6 +2,7 @@
 /* Statistics for Ocelot switch family
  *
  * Copyright (c) 2017 Microsemi Corporation
+ * Copyright 2022 NXP
  */
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
@@ -101,37 +102,32 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
-void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
+/* Update ocelot->stats for the given port and run the given callback */
+static void ocelot_port_stats_run(struct ocelot *ocelot, int port, void *priv,
+				  void (*cb)(struct ocelot *ocelot, int port,
+					     void *priv))
 {
-	int i, err;
+	int err;
 
 	mutex_lock(&ocelot->stat_view_lock);
 
-	/* check and update now */
 	err = ocelot_port_update_stats(ocelot, port);
+	if (err) {
+		dev_err(ocelot->dev, "Failed to update port %d stats: %pe\n",
+			port, ERR_PTR(err));
+		goto out_unlock;
+	}
 
 	spin_lock(&ocelot->stats_lock);
 
 	ocelot_port_transfer_stats(ocelot, port);
-
-	/* Copy all supported counters */
-	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		int index = port * OCELOT_NUM_STATS + i;
-
-		if (ocelot->stats_layout[i].name[0] == '\0')
-			continue;
-
-		*data++ = ocelot->stats[index];
-	}
+	cb(ocelot, port, priv);
 
 	spin_unlock(&ocelot->stats_lock);
 
+out_unlock:
 	mutex_unlock(&ocelot->stat_view_lock);
-
-	if (err)
-		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
 }
-EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
@@ -148,6 +144,177 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
+static void ocelot_port_ethtool_stats_cb(struct ocelot *ocelot, int port,
+					 void *priv)
+{
+	u64 *data = priv;
+	int i;
+
+	/* Copy all supported counters */
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		int index = port * OCELOT_NUM_STATS + i;
+
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
+		*data++ = ocelot->stats[index];
+	}
+}
+
+void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
+{
+	ocelot_port_stats_run(ocelot, port, data, ocelot_port_ethtool_stats_cb);
+}
+EXPORT_SYMBOL(ocelot_get_ethtool_stats);
+
+static void ocelot_port_pause_stats_cb(struct ocelot *ocelot, int port, void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_pause_stats *pause_stats = priv;
+
+	pause_stats->tx_pause_frames = s[OCELOT_STAT_TX_PAUSE];
+	pause_stats->rx_pause_frames = s[OCELOT_STAT_RX_PAUSE];
+}
+
+void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
+				 struct ethtool_pause_stats *pause_stats)
+{
+	ocelot_port_stats_run(ocelot, port, pause_stats,
+			      ocelot_port_pause_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_pause_stats);
+
+static const struct ethtool_rmon_hist_range ocelot_rmon_ranges[] = {
+	{   64,    64 },
+	{   65,   127 },
+	{  128,   255 },
+	{  256,   511 },
+	{  512,  1023 },
+	{ 1024,  1526 },
+	{ 1527, 65535 },
+	{},
+};
+
+static void ocelot_port_rmon_stats_cb(struct ocelot *ocelot, int port, void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_rmon_stats *rmon_stats = priv;
+
+	rmon_stats->undersize_pkts = s[OCELOT_STAT_RX_SHORTS];
+	rmon_stats->oversize_pkts = s[OCELOT_STAT_RX_LONGS];
+	rmon_stats->fragments = s[OCELOT_STAT_RX_FRAGMENTS];
+	rmon_stats->jabbers = s[OCELOT_STAT_RX_JABBERS];
+
+	rmon_stats->hist[0] = s[OCELOT_STAT_RX_64];
+	rmon_stats->hist[1] = s[OCELOT_STAT_RX_65_127];
+	rmon_stats->hist[2] = s[OCELOT_STAT_RX_128_255];
+	rmon_stats->hist[3] = s[OCELOT_STAT_RX_256_511];
+	rmon_stats->hist[4] = s[OCELOT_STAT_RX_512_1023];
+	rmon_stats->hist[5] = s[OCELOT_STAT_RX_1024_1526];
+	rmon_stats->hist[6] = s[OCELOT_STAT_RX_1527_MAX];
+
+	rmon_stats->hist_tx[0] = s[OCELOT_STAT_TX_64];
+	rmon_stats->hist_tx[1] = s[OCELOT_STAT_TX_65_127];
+	rmon_stats->hist_tx[2] = s[OCELOT_STAT_TX_128_255];
+	rmon_stats->hist_tx[3] = s[OCELOT_STAT_TX_128_255];
+	rmon_stats->hist_tx[4] = s[OCELOT_STAT_TX_256_511];
+	rmon_stats->hist_tx[5] = s[OCELOT_STAT_TX_512_1023];
+	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_1024_1526];
+}
+
+void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
+				struct ethtool_rmon_stats *rmon_stats,
+				const struct ethtool_rmon_hist_range **ranges)
+{
+	*ranges = ocelot_rmon_ranges;
+
+	ocelot_port_stats_run(ocelot, port, rmon_stats,
+			      ocelot_port_rmon_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_rmon_stats);
+
+static void ocelot_port_ctrl_stats_cb(struct ocelot *ocelot, int port, void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_ctrl_stats *ctrl_stats = priv;
+
+	ctrl_stats->MACControlFramesReceived = s[OCELOT_STAT_RX_CONTROL];
+}
+
+void ocelot_port_get_eth_ctrl_stats(struct ocelot *ocelot, int port,
+				    struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	ocelot_port_stats_run(ocelot, port, ctrl_stats,
+			      ocelot_port_ctrl_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_eth_ctrl_stats);
+
+static void ocelot_port_mac_stats_cb(struct ocelot *ocelot, int port, void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_mac_stats *mac_stats = priv;
+
+	mac_stats->OctetsTransmittedOK = s[OCELOT_STAT_TX_OCTETS];
+	mac_stats->FramesTransmittedOK = s[OCELOT_STAT_TX_64] +
+					 s[OCELOT_STAT_TX_65_127] +
+					 s[OCELOT_STAT_TX_128_255] +
+					 s[OCELOT_STAT_TX_256_511] +
+					 s[OCELOT_STAT_TX_512_1023] +
+					 s[OCELOT_STAT_TX_1024_1526] +
+					 s[OCELOT_STAT_TX_1527_MAX];
+	mac_stats->OctetsReceivedOK = s[OCELOT_STAT_RX_OCTETS];
+	mac_stats->FramesReceivedOK = s[OCELOT_STAT_RX_GREEN_PRIO_0] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_1] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_2] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_3] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_4] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_5] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_6] +
+				      s[OCELOT_STAT_RX_GREEN_PRIO_7] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_0] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_1] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_2] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_3] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_4] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_5] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_6] +
+				      s[OCELOT_STAT_RX_YELLOW_PRIO_7];
+	mac_stats->MulticastFramesXmittedOK = s[OCELOT_STAT_TX_MULTICAST];
+	mac_stats->BroadcastFramesXmittedOK = s[OCELOT_STAT_TX_BROADCAST];
+	mac_stats->MulticastFramesReceivedOK = s[OCELOT_STAT_RX_MULTICAST];
+	mac_stats->BroadcastFramesReceivedOK = s[OCELOT_STAT_RX_BROADCAST];
+	mac_stats->FrameTooLongErrors = s[OCELOT_STAT_RX_LONGS];
+	/* Sadly, C_RX_CRC is the sum of FCS and alignment errors, they are not
+	 * counted individually.
+	 */
+	mac_stats->FrameCheckSequenceErrors = s[OCELOT_STAT_RX_CRC_ALIGN_ERRS];
+	mac_stats->AlignmentErrors = s[OCELOT_STAT_RX_CRC_ALIGN_ERRS];
+}
+
+void ocelot_port_get_eth_mac_stats(struct ocelot *ocelot, int port,
+				   struct ethtool_eth_mac_stats *mac_stats)
+{
+	ocelot_port_stats_run(ocelot, port, mac_stats,
+			      ocelot_port_mac_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_eth_mac_stats);
+
+static void ocelot_port_phy_stats_cb(struct ocelot *ocelot, int port, void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_phy_stats *phy_stats = priv;
+
+	phy_stats->SymbolErrorDuringCarrier = s[OCELOT_STAT_RX_SYM_ERRS];
+}
+
+void ocelot_port_get_eth_phy_stats(struct ocelot *ocelot, int port,
+				   struct ethtool_eth_phy_stats *phy_stats)
+{
+	ocelot_port_stats_run(ocelot, port, phy_stats,
+			      ocelot_port_phy_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_eth_phy_stats);
+
 void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
 			     struct rtnl_link_stats64 *stats)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f639ef88f8f..050e142518e6 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1045,6 +1045,17 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
 			     struct rtnl_link_stats64 *stats);
+void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
+				 struct ethtool_pause_stats *pause_stats);
+void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
+				struct ethtool_rmon_stats *rmon_stats,
+				const struct ethtool_rmon_hist_range **ranges);
+void ocelot_port_get_eth_ctrl_stats(struct ocelot *ocelot, int port,
+				    struct ethtool_eth_ctrl_stats *ctrl_stats);
+void ocelot_port_get_eth_mac_stats(struct ocelot *ocelot, int port,
+				   struct ethtool_eth_mac_stats *mac_stats);
+void ocelot_port_get_eth_phy_stats(struct ocelot *ocelot, int port,
+				   struct ethtool_eth_phy_stats *phy_stats);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-- 
2.34.1

