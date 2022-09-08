Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5744C5B23E2
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiIHQtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiIHQtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C1212BFAE;
        Thu,  8 Sep 2022 09:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7xGmPyq1TROg3h4Ui8H0nRwAN7s11tSE5qQq/cp2zFUrWchzB1RU16OXpr7qLzkC3t1/v/AxjcK52QiuHBic2lJhJt3G0FRdJ5/+pmzkoHZoCKLQewxzFbJ467tO+aYM3lNiqFM9jJ6bl6p2lkWEQlUAhy/AVsNU3rNkXyErUXlby/P1tBc8iVt4M4bmkQ0PZZHpp4Zeirqycn3zprdY1NZzxDa+SBI1xrUN0hTWtCY6ApeCe4QidynSGu644xbilkvmURPkE6hV/OdA/Kyei3wescQkRPbq7QgRAGxlOmH65RCykwzo4KSvB5tvix0E8oZxCj5ZG8ushxqUuKjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQ/7yZplwdr2eHPsy6FblXlqRUMxVCEJov26ATdLlg4=;
 b=Lycc38bCmS7UZNum12/w6hqIj27ZgS/O6dAX4PF6oJwUJX4zLQLDzGl0ReaURZGpveT62ktoHqcU38lK8zzOzeh6iC6b5P+pon9lhKV5vcm24FttaUI3SrXg3MlToIjV/U+Maj3KIc6f/Kijeb3XMX6UnByat/rUrSQgUtSX1xqbfry4xWHOAMPQDZRV9XJqvTQARPRTasMNdsgCUreFCFCKlY+riWnXLVpgWqCciJ8t8XTt92mpxkMAk6RXjNjLEJ343PTnErvk4dAN8te0qwlEUsinqq+eKe4YOjuMfol32Q94pYv57qhFWQ11x18HwAyOU5VSTreJ2Bx2QQb/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQ/7yZplwdr2eHPsy6FblXlqRUMxVCEJov26ATdLlg4=;
 b=oYifQaWrV3STKzhHUo80y5O+9ApuyhcHGKi1cF07EAXB/2HpT/WoFDz6i9gYUfaAld7lGhyfeJnDtOjgVcwdd2Dj35kpBpigedTNbCKnkXiiqGrJKUHiTWtxkUliOj4Jbj/35Il9ARHqVfw9smKrf8N5AEsVkJ8Xg5YDzkX7NB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:09 +0000
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
Subject: [PATCH net-next 09/14] net: dsa: felix: use ocelot's ndo_get_stats64 method
Date:   Thu,  8 Sep 2022 19:48:11 +0300
Message-Id: <20220908164816.3576795-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3237aa52-c53d-4078-25b3-08da91b9fa7f
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tatO+I0c8nGTgeKWarSpV2qTknL/Fp1uHO/UQ8OBw68g1VQRKPdKMLHyqWvenxtzKAE08FC3t6d8UfW3n2dPUCR0MKm7iFOO1YMRpdOHjgAlb1RqgqJQMZfPAoKYFJ+ZRjkXbVFsJvJaXLAi5uTWG/S0UrvySOjG9GxMlnS/PlDiDO3ApjHkiETqP+zhilXta7MUl1zi+yKw0dgyXeGw4GLncw37LeJCcoQk0/LHIB5qQVGLNfi+VuGQ1iOdxMIfcMPtPRn13k01szv6KolBGtWJrYb8FEFpFRTSdLvA0UBteS4EaEj8Uj/dC4Qn2Hobx3wc/QgxHaMmkX/EV3xs9PONFVVomAWg6Xn6St22se+xv6WNdN2TEr/6YOT7HQd2+YfD+wnc/i+s809pQkS73gEJohU46llNl0abyy+jzXOd/dd38rp10jHWpZkjhNLT1cJ3SHIEg7m+Rv1gdTXAzbjQKMt3fGKLXmSpwJhqvJBhISkWClPOz6lqJKz63OVxM+fTggmB75x/oWfI5YUXVEhnO1R/3mWmkGePh4z+H16VNw9l5jrSn/dBfVMQ4/rLCzc/QtzhbrepkVsHbmdobD7zBJX150u/ovwa4jU7Z6WjOKgflG/iglB2eSHDb9G4hn6t+dk0kibHsLo4XdwGAJF+7H4VjMIAGf8WxW9C2+QGVVs2Uojyudzwe3REwkqcC2h+dJZVeZZvcfQTm7Sxp415BQjxznONH6ZomOoIyoL/WC/DjhyXYg5J4Q2z/6wz+EuKmg+viSmCRv7GuW1Frw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(7416002)(52116002)(41300700001)(6666004)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7byR3AIYTtHYstiuyHVGKo7EzyBKK1HY+PXnkEZdOk9xpoQ0/2sSwBh67Ws?=
 =?us-ascii?Q?zq1sUZ1cEeCt3ls36MnYbixanPYou06BWPRFsjdqjK/X+lM0RHB6HcfXaPZV?=
 =?us-ascii?Q?rGVqdrRsPOcbCFwbN5bR0CzxZFmETNV7WLkV6NlfVZKsi0BsXVY6wh51I5VL?=
 =?us-ascii?Q?Y//KxcrN/UgUcInU0WCyj+P1/DIGpGQL1Wwu47slBp/6wp8eI/IFoU+Hrc7c?=
 =?us-ascii?Q?xm/pl8vU3ORMFVjK4TmumQqXiGmXQWrfFkoHzot+ruiSe4mT4dGYF7FhpjoP?=
 =?us-ascii?Q?N+JJt5c+dT80oswx5S0AQ1jvBiRDEPFk4QX8/MNrQm+A5gDHWNZRWAry2+3q?=
 =?us-ascii?Q?KeHzJqXXTSLECQGzl5DaSfkHE4hxhQK0o3OUfWW5kETJiFfZJyBo5rkiOkE5?=
 =?us-ascii?Q?yCkI+AKhi42Ccjw/1aLlCnzXM537eQYfjtxccDD9m7DSlx1ZJp5LVTydE0ku?=
 =?us-ascii?Q?HXnYrGie4V4K4D12rzEnYpR3szgSDFH6Eafeie6vUmkgPTK5bRihYNTqpJbm?=
 =?us-ascii?Q?4eCurMOhbRY0cpdQZr4byWXklsdRgFmyTCwn5a1vq2RG/hZjrPoy7W2ZOb2i?=
 =?us-ascii?Q?7Xpfj0JKC68BeDmP8XFK0mJYPcYwD02JOnLRFt06BlIrWXVtL+KVfuLFNd/U?=
 =?us-ascii?Q?TRCxVz6/yPBnhkyyu2US9tov0TBVIuaN1GMc0/DI9bJwyq9t+4SQifXXcZSu?=
 =?us-ascii?Q?9USrsZsvaPejYM9dy15aTF0phXLyuig+3BXy+T+ItLD4DFBFdlMBjkshGBCp?=
 =?us-ascii?Q?FU+cuQztePuPDHRVmhTgEqYaBnnqOw8+8OOjP2EAn9bAFQ0TKGtYNY01rUtM?=
 =?us-ascii?Q?NAZ+EsA2mGB5bMAamShbMhysAQ34r5criNjvigiVSRXDE+JVg43Tj4KcGLni?=
 =?us-ascii?Q?qmrbSa8kYlYFxg6yUP5qRzNIu0awYUNcBOK39iqUAI+NnDTddvZLTdQhlVcf?=
 =?us-ascii?Q?lV3qNFpSmo1uGqowUi51EyXdmDqTjDTJXGEayLIrolCvuV2+OHS+omLoFyZn?=
 =?us-ascii?Q?Ot1RULQomfm0b7bKHsX8YMp80/ByBU/gkRdev1hAkUvN20txFMFqoX0/D3G8?=
 =?us-ascii?Q?5LIG9vB2o67we4p//4v/x7F8NOXYpaFCdFxYp9WcfQ31akj0eIjW/URvKFB/?=
 =?us-ascii?Q?x3rmIz5AHhvmZ0Y9W7FQhKX/I9oN3JDvAECoxDGb/vombMe4VdSYwvQIDQHq?=
 =?us-ascii?Q?6gFhq+m2ZJ9A976gyer/vRQjSa1CWceOV42ERZ+CBzeMGzMtciVuJtjVVGcC?=
 =?us-ascii?Q?8DSTp8kdvnPpI83JxUwgwSeZZ2F5lGa/JPeFMIL9vOV2OIi4rwc92VQE1jzb?=
 =?us-ascii?Q?acDMNWggfKdyjUpSq1N2L6G08IZ5lIbOJwqc0VnMnwAw2R/4UtgX9EBwr8Dz?=
 =?us-ascii?Q?qt2GEXK+IR1SJK7osHNPDciKVNkOLPMx5B+Jc2ZSEvnPKXmr6vfSA0lahPug?=
 =?us-ascii?Q?0gSzgKpJBHXQJdDxqkB1/e3DVS3HpqKh2ooSbhBfZLOEFtRlBsCuLqZxk117?=
 =?us-ascii?Q?xDE0prM+Gyoj+4GTbYgh+vD60H7phrZSDa2gEuKBQ5hoeuSVSXNdPvSIZBv4?=
 =?us-ascii?Q?RHI885Yj7FhjmWUq0UGjK9GKnKqFrkXz144oOoJHDeaqrpYrFHeJZYxdaBYR?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237aa52-c53d-4078-25b3-08da91b9fa7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:38.5835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fRenNwn2f5oy2ZX2KOpXFfeP2UR7ledivJSo1V3jSY9pH7UixFHsGtch4OpjWINKOu9ByAJ6WeqUQwKsfX/bg==
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

Move the logic from the ocelot switchdev driver's ocelot_get_stats64()
method to the common switch lib and reuse it for the DSA driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           |  9 ++++
 drivers/net/ethernet/mscc/ocelot_net.c   | 63 +----------------------
 drivers/net/ethernet/mscc/ocelot_stats.c | 65 ++++++++++++++++++++++++
 include/soc/mscc/ocelot.h                |  2 +
 4 files changed, 78 insertions(+), 61 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ee19ed96f284..71e22990aa67 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1034,6 +1034,14 @@ static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 	}
 }
 
+static void felix_get_stats64(struct dsa_switch *ds, int port,
+			      struct rtnl_link_stats64 *stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_stats64(ocelot, port, stats);
+}
+
 static void felix_get_strings(struct dsa_switch *ds, int port,
 			      u32 stringset, u8 *data)
 {
@@ -1848,6 +1856,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
+	.get_stats64			= felix_get_stats64,
 	.get_strings			= felix_get_strings,
 	.get_ethtool_stats		= felix_get_ethtool_stats,
 	.get_sset_count			= felix_get_sset_count,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 6d41ddd71bf4..2979fb1ba0f7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -732,67 +732,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
-	u64 *s;
-
-	spin_lock(&ocelot->stats_lock);
-
-	s = &ocelot->stats[port * OCELOT_NUM_STATS];
-
-	/* Get Rx stats */
-	stats->rx_bytes = s[OCELOT_STAT_RX_OCTETS];
-	stats->rx_packets = s[OCELOT_STAT_RX_SHORTS] +
-			    s[OCELOT_STAT_RX_FRAGMENTS] +
-			    s[OCELOT_STAT_RX_JABBERS] +
-			    s[OCELOT_STAT_RX_LONGS] +
-			    s[OCELOT_STAT_RX_64] +
-			    s[OCELOT_STAT_RX_65_127] +
-			    s[OCELOT_STAT_RX_128_255] +
-			    s[OCELOT_STAT_RX_256_511] +
-			    s[OCELOT_STAT_RX_512_1023] +
-			    s[OCELOT_STAT_RX_1024_1526] +
-			    s[OCELOT_STAT_RX_1527_MAX];
-	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
-	stats->rx_missed_errors = s[OCELOT_STAT_DROP_TAIL];
-	stats->rx_dropped = s[OCELOT_STAT_RX_RED_PRIO_0] +
-			    s[OCELOT_STAT_RX_RED_PRIO_1] +
-			    s[OCELOT_STAT_RX_RED_PRIO_2] +
-			    s[OCELOT_STAT_RX_RED_PRIO_3] +
-			    s[OCELOT_STAT_RX_RED_PRIO_4] +
-			    s[OCELOT_STAT_RX_RED_PRIO_5] +
-			    s[OCELOT_STAT_RX_RED_PRIO_6] +
-			    s[OCELOT_STAT_RX_RED_PRIO_7] +
-			    s[OCELOT_STAT_DROP_LOCAL] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_0] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_1] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_2] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_3] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_4] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_5] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_6] +
-			    s[OCELOT_STAT_DROP_YELLOW_PRIO_7] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_0] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_1] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_2] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_3] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_4] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_5] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_6] +
-			    s[OCELOT_STAT_DROP_GREEN_PRIO_7];
-
-	/* Get Tx stats */
-	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
-	stats->tx_packets = s[OCELOT_STAT_TX_64] +
-			    s[OCELOT_STAT_TX_65_127] +
-			    s[OCELOT_STAT_TX_128_255] +
-			    s[OCELOT_STAT_TX_256_511] +
-			    s[OCELOT_STAT_TX_512_1023] +
-			    s[OCELOT_STAT_TX_1024_1526] +
-			    s[OCELOT_STAT_TX_1527_MAX];
-	stats->tx_dropped = s[OCELOT_STAT_TX_DROPS] +
-			    s[OCELOT_STAT_TX_AGED];
-	stats->collisions = s[OCELOT_STAT_TX_COLLISION];
-
-	spin_unlock(&ocelot->stats_lock);
+
+	return ocelot_port_get_stats64(ocelot, port, stats);
 }
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index f0f5f06af2e1..64356614e69a 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -148,6 +148,71 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
+void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
+			     struct rtnl_link_stats64 *stats)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+
+	spin_lock(&ocelot->stats_lock);
+
+	/* Get Rx stats */
+	stats->rx_bytes = s[OCELOT_STAT_RX_OCTETS];
+	stats->rx_packets = s[OCELOT_STAT_RX_SHORTS] +
+			    s[OCELOT_STAT_RX_FRAGMENTS] +
+			    s[OCELOT_STAT_RX_JABBERS] +
+			    s[OCELOT_STAT_RX_LONGS] +
+			    s[OCELOT_STAT_RX_64] +
+			    s[OCELOT_STAT_RX_65_127] +
+			    s[OCELOT_STAT_RX_128_255] +
+			    s[OCELOT_STAT_RX_256_511] +
+			    s[OCELOT_STAT_RX_512_1023] +
+			    s[OCELOT_STAT_RX_1024_1526] +
+			    s[OCELOT_STAT_RX_1527_MAX];
+	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
+	stats->rx_missed_errors = s[OCELOT_STAT_DROP_TAIL];
+	stats->rx_dropped = s[OCELOT_STAT_RX_RED_PRIO_0] +
+			    s[OCELOT_STAT_RX_RED_PRIO_1] +
+			    s[OCELOT_STAT_RX_RED_PRIO_2] +
+			    s[OCELOT_STAT_RX_RED_PRIO_3] +
+			    s[OCELOT_STAT_RX_RED_PRIO_4] +
+			    s[OCELOT_STAT_RX_RED_PRIO_5] +
+			    s[OCELOT_STAT_RX_RED_PRIO_6] +
+			    s[OCELOT_STAT_RX_RED_PRIO_7] +
+			    s[OCELOT_STAT_DROP_LOCAL] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_0] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_1] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_2] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_3] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_4] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_5] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_6] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_7] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_0] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_1] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_2] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_3] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_4] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_5] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_6] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_7];
+
+	/* Get Tx stats */
+	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
+	stats->tx_packets = s[OCELOT_STAT_TX_64] +
+			    s[OCELOT_STAT_TX_65_127] +
+			    s[OCELOT_STAT_TX_128_255] +
+			    s[OCELOT_STAT_TX_256_511] +
+			    s[OCELOT_STAT_TX_512_1023] +
+			    s[OCELOT_STAT_TX_1024_1526] +
+			    s[OCELOT_STAT_TX_1527_MAX];
+	stats->tx_dropped = s[OCELOT_STAT_TX_DROPS] +
+			    s[OCELOT_STAT_TX_AGED];
+	stats->collisions = s[OCELOT_STAT_TX_COLLISION];
+
+	spin_unlock(&ocelot->stats_lock);
+}
+EXPORT_SYMBOL(ocelot_port_get_stats64);
+
 static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 {
 	struct ocelot_stats_region *region = NULL;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index bc6ca1be08f3..2f639ef88f8f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1043,6 +1043,8 @@ u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
+void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
+			     struct rtnl_link_stats64 *stats);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-- 
2.34.1

