Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E5D66D92B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbjAQJEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbjAQJBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:44 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B45302A2;
        Tue, 17 Jan 2023 01:00:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdylFrgfZjpJQ7qkh0E9HTCRx/CAJYjwCsgXkJ9fICX7os9qTvnTgDQ26pOJvXKdWY1X/0XIfnGg66wGWrWyrs9RwRw5Ayds+0n7+6nlNthVXTFv6ydUwYb74h2oax43A72hi+LPNgshahAGR+KCf95opWcDvPLOUCOjhuPmRxrCx9U4K58ZqrB+UF8EHE8MYnzOROPVU4VfEQ998mmQKGeGQ1NkaPtroC4ojksQguCsbxekTUm68pMdxZKAXIIyqJC+7wgVK4Jm5RUhVo5NntrEM+iJxQ3zi286llcdxjc/OKycDAzzmw5ieA9m0NOlfe5LojXyhPnGPRbgMw4DKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKksSES58XgQr62Qj6ao5CTuzUuwjhZXivOpP4Hyneo=;
 b=G9OI+eGZMHW9a36SU3MwRCXNEQO4ym7D/QLHEe52BgaQukawos0wwGSCRi2GaZOh0eaIF6QVU4INn11TEExUCYJwGUUX/TVU8s50Xa8xtUrcKpzCFLabl+cgIJmOpz1RiUWST36rTEDru/wqVgM8+8hAhz/GJDNmBhZhD2RSa9vpVMBu462bJb6oJGFM5CoaPhnAdJbhxpsMblSCZBoSAhu43iNCOadGYWt/jwGxE69+UCsbS8AeqTFNs3kSzt28WOeAQqRj3Ot5ME5r5SKY81woCGrtcG3GInG5HGem+iI+o0fyE5Hhy2Lo4i5mRO89CpgF60ie69Zs6tpWmOVC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKksSES58XgQr62Qj6ao5CTuzUuwjhZXivOpP4Hyneo=;
 b=Xgwll/oRW4oeLKpy4RPgPmlF+nWolbqSvhineDQgGTdnTVDEpTA0D4iLeEUK7C89ZszsrB9ucU3NA21/fq37SRpXZf+7FYx+X7fdB2yk2jBaVDL346wlptcSTUfOLXSMdxpLR650TlkkaY6DdOerzMghcxrGyJ9Iig8MTctmmPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9182.eurprd04.prod.outlook.com (2603:10a6:150:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:00:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 09/12] net: mscc: ocelot: allow ocelot_stat_layout elements with no name
Date:   Tue, 17 Jan 2023 10:59:44 +0200
Message-Id: <20230117085947.2176464-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|GV1PR04MB9182:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a008d3a-a64b-43d7-cc1e-08daf8693e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z50ua2adfBCer5HJZO8dpHejyrZrAjD5VywOnAmEsSMgnSBuMdCvVNvr8LdwMhAly9pD1sE7WTWltmQ/C09CfNpQBO5BuVOm6WxtXk4AIvCIGR31SHKBZTenEoj+r3ccv47dkcmbeNTkZu63H8LnyTF9QkLAfDuBYoCNwTLFvlG+WyW5lNnPditX6UP78T8oPRgO5OrVJ8dqBK8ccmzRmUq6WCA8clWiL3CqLUKHk/FbrXu2l6Z4c/Wc5ccGxZEy+qq3YmE01Mj17fqfboX9bO/y+7qQ1VM29dIWqcyh6uzQLw0LByR9y0T1ExgDBv/Fb5P39ky/+dpr63sNWxgx7ka1srNcFNHL+lUuE0NXl3Ee4izQuYjcyZa3vRiAxS5pObVkXQ/B1vdAFh6uWSzprYvuBGHLu4B+4EznUbvOxmIfidf6Kg/xyxvbWuVMlqxJIsnopMu8qovPCacDMoc2hznxA/dCrL3pY+TURA9fZawIPiIQRZR5ZMCfflGbwAMOYeirJ0T49dF9WMp8r2rzP+KfSfWho9dmLjRROwhCwzTcGg0CaAygAELw/6IpyY37JXw5bPXoGhBwGk5Gy06IMtllVRu4Yw4yikY0TSZhxihXilTG++Tmw1QgjCcu1CAxgD8lMxg3SifKj+zcAdUy3DvmFInRzZpbKvs+lW/KlKkSnxYTUOPKy9HiHeQxmIN5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(52116002)(26005)(6512007)(186003)(478600001)(6486002)(66556008)(66476007)(316002)(1076003)(6666004)(54906003)(66946007)(2616005)(8676002)(6506007)(6916009)(4326008)(38350700002)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(83380400001)(44832011)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IH6ZVRFMEdEEEg2XTQydGiMKpQbGMOF2SA3xe3qPq61YXfSAc4yvcR9Dg/9/?=
 =?us-ascii?Q?CDS2wzdaaosyWr0IXxXTFlHIu8YN1xxyvxjIdd9xiMcgNPNbCNdZhLX++hjE?=
 =?us-ascii?Q?RKHef0fCF22Oto+wiCGFGos5jIII4OH4g2LZvGJ5/dw6JbCa75w1dfFC5zGo?=
 =?us-ascii?Q?EsO30EDxMp1hFHGD2MAzxb8U6ZQw6EKXYtlRCJ5vlnkdjPzatqK059sYWzbS?=
 =?us-ascii?Q?eFV8f1xbzCjsv7ELDX0Gj/tXk1K/rmt2azfzG4MUoZQx8Zgm/ZJVejjkZYiU?=
 =?us-ascii?Q?RBBBmXeIZHXwe9op6lAnJwrOQH87r4JYHl0M/6b0Iy2++0Iv2QCwBbp2SDrQ?=
 =?us-ascii?Q?nICuqG5vV3iysuKc1qGocfg4VamVuqEIvqusZH0+nON4y2vJ//74QNySS6Rx?=
 =?us-ascii?Q?lp0ZOInGkiy4gyMwOOfso6PJ/3MTmCEoR+wctx6BPgSK6r7F012gWQlXx1Q7?=
 =?us-ascii?Q?mzflonKduVQp1zyxhELuXjbCgQSianNMERXjr2YSk5mzuHAdUSO2bKYHVDtd?=
 =?us-ascii?Q?T8MV7mNtX7sAl17cDbPW6ueHHO9jP8GLsSueUbycnYTJx19SqdXPVxRUiUwA?=
 =?us-ascii?Q?7q7OMSKmUedh4xMYUeLVyeVoRqVETBdej1+GxQHxok3TFqkXmdHKB/kNThkX?=
 =?us-ascii?Q?8S4OiP3FYodj0+MrqhtbZYJbKEtp3X3cYH0UVqTd7yyY89U9O6+qFNb+/ggZ?=
 =?us-ascii?Q?8+0RfKxQSzQn66L4cYu994B48Ex5kponCs0sDOUgL6X42d3+vx1lqSAHC1l2?=
 =?us-ascii?Q?JybDd6ZUDkUH9dFwWCdR3cNCm0ibZbKRQ8V0znOXFz3e9T/0TU3NQ8pCZsSd?=
 =?us-ascii?Q?0+ov6IufaUw8S0cRTuC4nle7jWZdiVP8moYQj/h930vvO2XMbI19YjKzJ2fQ?=
 =?us-ascii?Q?eEhc2FV00SlDFxOuj8wTFRH/Qin8H4Uli0ERK/DBSfinUxgR59Ii085U/2f5?=
 =?us-ascii?Q?HOf9IDqx1hxqHdn/FQ2oANU4PP19wBe0/QwUy9zEumA+OOOwxUP1NoAf8QcU?=
 =?us-ascii?Q?Oym1skMcv7vZeihvsdioYG5XJERKlH7nMO/kyCT7oOlakhaLov9sv9oqP/ZZ?=
 =?us-ascii?Q?9lxeQ5N8W2KQ44h6nM6B2nLPgrS/FxE0fkql8ho/lb42T69HZqx1Q9Hv9q3K?=
 =?us-ascii?Q?gHmbmd9/hIHS/ILcHOrX8B/uOdG9nCvtUdNcVFOqCwEYXU83ICN7GTsAiWaJ?=
 =?us-ascii?Q?auhHqstpDwKa84M6o9aPkCQ8+8/TLuylOXbk5t8B4CvBn0sOS0YFiMC7L5D6?=
 =?us-ascii?Q?Ik69Mcq/MmFFsHoFpr+9o7ZSGs9ECfD/0kDd8ZKjnfu8YF6G67EyC0wCDZRP?=
 =?us-ascii?Q?pu2U/kMYG903JY25WBRVC1iuErOPrc0usyprSeVodNcaXCKnaYW4H+DeGFk5?=
 =?us-ascii?Q?XmqFooj2s0cpb/IFQwuxALuY0PuDn9iNIR5+zl1A7UqgTvJXmsGmxfQk1X2t?=
 =?us-ascii?Q?owRhLx2+9+avO9vbyvRwkw4H+YOX5uGfeSdwXRbJwUMHDHb6lP0SqrqOGzPR?=
 =?us-ascii?Q?JBjohORgXVkvN5n5kXJfHbBwHnsRwoQG994dxz2qup/oXXX8JwJ5ZrHjSeXA?=
 =?us-ascii?Q?YOOz7oDfXThmhpDAUze4ykaj7vLrJR3W10JbqXOt+As0xUOwCqAOgi5QyMHj?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a008d3a-a64b-43d7-cc1e-08daf8693e84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:13.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhbVJxiPeAbmm9fQouuHmo8eInvNdKuvs4v/ECiSoQE3T+I74szcoqyWnCQC86MN8mYwX/7pMW2S+zmRKrJi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will add support for pMAC counters and MAC merge layer counters,
which are only reported via the structured stats, and the current
ocelot_get_strings() stands in our way, because it expects that the
statistics should be placed in the data array at the same index as found
in the ocelot_stats_layout array.

That is not true. Statistics which don't have a name should not be
exported to the unstructured ethtool -S, so we need to have different
indices into the ocelot_stats_layout array (i) and into the data array
(data itself).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/ethernet/mscc/ocelot_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 1478c3b21af1..01306172b7f7 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -315,8 +315,8 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 		if (ocelot_stats_layout[i].name[0] == '\0')
 			continue;
 
-		memcpy(data + i * ETH_GSTRING_LEN, ocelot_stats_layout[i].name,
-		       ETH_GSTRING_LEN);
+		memcpy(data, ocelot_stats_layout[i].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
 	}
 }
 EXPORT_SYMBOL(ocelot_get_strings);
-- 
2.34.1

