Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE05B23F3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiIHQvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiIHQuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:50:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20087.outbound.protection.outlook.com [40.107.2.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C69120AA;
        Thu,  8 Sep 2022 09:49:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwvjeyx4VElShYlqy2XzUUwLtYyhBrvQBn1FAPhopGk/GxTaPVeNH2tmhk233zDjDtaRWMB/TxKSlEeNSV73/1KhN9A0qIxR0GKhlMLxpsrS2fKD6+uluWUsUT/MwHD9+nhaL1ElHV4WDEoWnufkJ5j80rjsRIGcUHZQu3irphdXy3chAEtREPT2O6Dv81Ln9sGMOYwJjAulSx5fMDLqwMTaeRV/n6LJ9taSr55NuU0bi3G9kpk9v5akrNgymLpBZS/O6dls1ADW9LW3k6f3zeeaIO+0wiaH6I1FxzbUcWAj85asLuQuoFWYZwm9hOgMzql8zHrGtsu1FtwRO9Mejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JPN3KKEzoXiekZ0SGOifkdlMTJn/56/zD2mO4ND4tI=;
 b=D+Q+2yCbgrkSQUhiDVvmcPfcwJLydwto5kRs1pENG1PlG83kjODHWPU/p9tiHjp3tJU7VYzSa02rDt1pGIOEzZcSypUd+Ke7sptQC8UAnOPdTQru9HIymz8TPqDISdOnhTjFqYJxbKsmFgiBr4R2YwE4j9YDDDodttemQhwyipQHB5LT6ncgvgO3FeGpW3c8vffSsNmQrSEnOLFkKYxMQPM/Rx+hJiBLSyM6g9PPBmE40VI0wjVu5dae+5zeyIH43131anhNgOdUcnMT6LIvdwuMn6f0Gzg4IMXmNVQsLJZ9TzjMo/nFpryMkpoxWIX5xcq5lMCLZ9zUzY+nGRmQfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JPN3KKEzoXiekZ0SGOifkdlMTJn/56/zD2mO4ND4tI=;
 b=Zd7qBTXnifKqefYs9ShyYTGhe1PLb+B8OtUBvpPYzW12AbbrHSMKaMkIqO7wWRGUeQBKc2wSRcWNgsI3zbu54iVwnAvQ0xcZhTOT8HDWBIDMoNH34h5KNmb/VVByzKUgf+pzGOrxzVNNuULayo39w2AViprkSkaTe02uF553Zc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5154.eurprd04.prod.outlook.com (2603:10a6:208:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 16:48:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:45 +0000
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
Subject: [PATCH net-next 04/14] net: mscc: ocelot: report FIFO drop counters through stats->rx_dropped
Date:   Thu,  8 Sep 2022 19:48:06 +0300
Message-Id: <20220908164816.3576795-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b84bb84f-9a07-41f4-f080-08da91b9f689
X-MS-TrafficTypeDiagnostic: AM0PR04MB5154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UL/qX+gGDal0gFtU1dPholLwqfM87hkZSZb7z5Xrm/DFlkhUJVs1Ee6dwTXJXUhYBhk+ZZFV5pX/Pb05GZzqaJYcVTUypKj25Nv9vwYKgsgJ+Bntfk8Yg7ELk98MLA1TuKzIZbTYq5ckT1LhmpOknPaO358ltHMjiI9Pir3rxoYWUcTtgSwX2PRJw5rADssPr2VqtKLHz0yRFKA/+XNf/yo7/HE4y1ven0BA/cznaRlLwvOz//AM8GQj8nWp759R/9BRuyJqqVNVB3ROcTY4FQ9M4pb0QdWhif8+SijsQpqSBr/P0rWUi69zd1EjvUb+2isDPcp1cogKv7sLxM58Q/kuOrDS+yc4LjPVaCOt55kMS2XCla66ABKd6/IOz7nJ1VWBx1mnV1kaL6tYZnei1br2w/29wK70KB9wYN5QJ7reGxH1KeV9V+aUm52z5Somrvo4vv67rgNPlRm3547hK2vVUQF6U89iMtDcUKFxgYQo07htZvyyvaDMEtrhcujcgWxn0p0CE9i7OOi5X94FUvpiUtK1sUhRLT7RxcdYUcjfRBg/Cdc+hC0fVHWELwVkYmSr0anJp0fscufKNvnJp4hly80P8jj9WxmFv18w6SIQRr1Co7592ojOQ2YeFSDH8KQacoZ7toaUA4NbHpc1E/zZ88tO8V5NKl9/MmvFBP1s/MCYZpE8ivvkLzuz0qQtgYThdt4NDil0idMJLhRUSm87yGs7lDFqguDdq+nwKKEHDzpb94j9lnzmd+zOBAx3fIY3h3wxIA/W7fWhrXSdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(6506007)(41300700001)(1076003)(6512007)(6666004)(478600001)(6486002)(2616005)(26005)(52116002)(38100700002)(86362001)(38350700002)(5660300002)(83380400001)(54906003)(316002)(44832011)(4326008)(8676002)(2906002)(8936002)(66476007)(66556008)(66946007)(6916009)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tKGoDptsz5+rYZcPsBU+Wx3hz/61V0Oo6iWH6OD++Xkbpsewe9vqb80NPv8?=
 =?us-ascii?Q?2ZXYyVYso+CFywKqXSfnqy7casn55OC0GQ6KYm3bsLmW9kxveg832cUV66ta?=
 =?us-ascii?Q?VgIU3C0BUP5EfXtZH2gHh1Y9U7G7VQSsTRH5jiS3mv+vGnBHZlxnr6Kt5D2k?=
 =?us-ascii?Q?3A85o6lTrSw7ZPentr7dC81u7tMoGImKtG6AhjymzVyOkZkiZy/3nKAjGQDq?=
 =?us-ascii?Q?ykBZUVsLAToa+YCQL51ir+4lIkqXYFzZXSMXEhJlBAJfWnIzXeQlDjRLPWhY?=
 =?us-ascii?Q?maucMr5h1fxkU2N9oW1+PPu4ptYZD3nTukibnahu5Ww/H/xCXdypH5txa37a?=
 =?us-ascii?Q?ZI7hmk2R+D/whJzSfHnG4xe3K9MtYwBdMFAgBzHm2N/hXJMFNK5NTxCrgQpK?=
 =?us-ascii?Q?8DXM5hiJEtA0sHhWz2czoCKdSWZrIY1JDBxa9ew19YNPm+0JdpZg5zBffX09?=
 =?us-ascii?Q?tHvygdoLrflGdk73BQnPnCrRNNG5TvZD0LPp6aJvbd1LNUaUmwbHlyUGm4N1?=
 =?us-ascii?Q?95Jy6SD+oYbDmLSwNEmTOOb2Gi8o3582OBD9bVIXh2pEWH5wzi2z+dv+VygP?=
 =?us-ascii?Q?6o9x16gIkFMufw59CVvTZVOA8u9iVcBafuUljBTqnO0xMAArIwdkIu4KTW3S?=
 =?us-ascii?Q?30kUb8sJIbjFf2jZIckyf5SOISCtFvIpKB96eLLrJ1lebiL2ifxtFEV1vp4l?=
 =?us-ascii?Q?NKTBegfGgs+mtHf7iWMIao/H5Ze2CweZeDEnvlXrE6BlKQWkXnhN3s9KLXYo?=
 =?us-ascii?Q?k3vIkH7/OTJpGCoqd1koMrOJCrd5jn7KJ0xw1V9v/FSpexWB3joPH//I2eMH?=
 =?us-ascii?Q?xI1ModiGzQpIzHmtm5jcr8FNIhnQWEIKrXx81bHOSF3PWThSLi8nW2XhAoie?=
 =?us-ascii?Q?M5HL+ZBjg0oDN0MlMB2i2I6e5DeUIO2f/X6sk3zkdSoDICtceSMre1eVwTk4?=
 =?us-ascii?Q?KcYw1sBP28gCzOlxebpt8o0ym6z3Q4LB+Qy/mU8hyuaunpUZM20cePTTc/2f?=
 =?us-ascii?Q?FElG0xiRjDbEIrWYz2EZeuoUqKBO1EnCr4b22o9M5h0gbjhRaB14rmwZ1j3Y?=
 =?us-ascii?Q?dT+24BnLdIjXGtPlcsOlschhg5AWXYU+ibsvzzM/JPzBfNpl+NZgvEUBykQD?=
 =?us-ascii?Q?ePyH3WB0yLRNeP9A4AHDhfI9Vxk7FmOLMyvgBa0iGf3/9wsyaDWTsiLFIRH2?=
 =?us-ascii?Q?JUedNwuRFfxA+dclPHVlYzXh7q1chQwcWo5Oy1xDN3h9sHEFqIa/OFcN4CTI?=
 =?us-ascii?Q?iXVB4o1FfOcqQ7uoQJ/OXU3sQ/kbrrkElHN7wQVV+OfODzt6tP8Yb+kuYOOH?=
 =?us-ascii?Q?UCWGn4qRR6U0Czrorr7s0xEI9amxwrSM0mfkzt1bDCKpDlqIdnEubWabceua?=
 =?us-ascii?Q?gCKIVtMIJrWeBWz7pni6o9h8ssVJDs2PCmH/E+q0TJbXAaW4QLYPXSOgMz6G?=
 =?us-ascii?Q?v7kQtR3Gsca/DVXuqptFJvIY5up96sifcuGrzNBrQMTE053RkXz6RSrniZT8?=
 =?us-ascii?Q?kSNl4Nf/lX7QtyrpmnA2LEaTR5RzVHUeiKU4MwVpFlBLIYqZ0heNPKATu/xX?=
 =?us-ascii?Q?ybBhKYB4vcOAVTe8bOADB1CR/cB+UEWETycCL2soQxjDufZqv7mKwClhe5TI?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84bb84f-9a07-41f4-f080-08da91b9f689
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:31.9433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEwF9iGSH6mj8s5HTLZTfE1JblHN5BfYcsAIaKtCmVQLT+Vy3831qjReobgQjz74wGnUu/0mjMJfkgod9EC41g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_link.h says:

 * @rx_dropped: Number of packets received but not processed,
 *   e.g. due to lack of resources or unsupported protocol.
 *   For hardware interfaces this counter may include packets discarded
 *   due to L2 address filtering but should not include packets dropped
 *   by the device due to buffer exhaustion which are counted separately in
 *   @rx_missed_errors (since procfs folds those two counters together).

Currently we report "stats->rx_dropped = dev->stats.rx_dropped", the
latter being incremented by various entities in the stack. This is not
wrong, but we'd like to move ocelot_get_stats64() in the common ocelot
switch lib which is independent of struct net_device.

To do that, report the hardware RX drop counters instead. These drops
are due to policer action, or due to no destinations. When we have no
memory in the queue system, report this through rx_missed_errors, as
instructed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 27 +++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 330d30841cdc..d7956fd051e6 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -745,7 +745,32 @@ static void ocelot_get_stats64(struct net_device *dev,
 			    s[OCELOT_STAT_RX_1024_1526] +
 			    s[OCELOT_STAT_RX_1527_MAX];
 	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
-	stats->rx_dropped = dev->stats.rx_dropped;
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
 
 	/* Get Tx stats */
 	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
-- 
2.34.1

