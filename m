Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C034B0453
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiBJEPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiBJEPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931655B6;
        Wed,  9 Feb 2022 20:15:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aumz750zjEbrmhQ4gCx8Q9DT9zCgjH0tI+kyn2/fKZz/9Pah2MtiG95AmWslAlot4xspgSLJHZBPKubju0Wwm6VDSzMlBq8Jzoy9f9EveQo8EN4grcJR8F0bLKbw36ABzdG1eJKLDhJMV94sc5NIUeod+IpmW/5mJP8FJa4Tn0eslVT5VnoPPL1hcTKCqtXI0EVeKA1507rhH1ZydI9iAj+bMTR/dpRWgkbwfDSqGaGPd65P0MX9Hv8xKDjGC6rGjMQhuaVgey4LjgYeeb/7UfY6W1H4Orl67haTIoGJKTEAjgqvEBKpSprPIlJGjZ5ohxeXDUMusGPyx0zniJa2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64JdQrorSOzXXiUx/CxRquRBwwgUczwJ+Erb//gyknY=;
 b=oUOwRP/RpPiLSTKjjkKbA6mmt16hpo8oN4AXDJQxI3TtZjo3BCz1357tLy/3RFIycwrEPQvUIzp1oEYmAFzZJNhslo6Ue/pHTjXhyThx5zZQw3I0awqcJm5F2286tJ9PsWRuDCW5PLuNEkrg1CTv8aZpVUmhjISPHumpusFvKXjsanSgzrW0jenOdpCy1SbnAe4vIdsMSf2hWDx+mu27IfM9rnbI2GrWrSpLch30aITCg+Nmjgy//2krn4uU1x5BQxFGpbuot4/xluWEa//6LJdjI4dKb4R3IuYNNyZMFYGj1quePKDq1Vnh63X/YGD5FBxvngHPvk4t+IB+i3UnnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64JdQrorSOzXXiUx/CxRquRBwwgUczwJ+Erb//gyknY=;
 b=rlERPA8EBZbqa+Y5lSFes0Bh1CCBuNmHQIbv5o+taDwvs6dDSPaJXJBCEQkXaEW5OFXnm3QKE+EsL0KXcAxeT20Q29I90kyXvk9tZAuVmObu2x6FV0uPICtkCrffhePUiD9cMLL9Ywes6hTJF11M27kcOe7GJIifULp5eP/j2W4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN7PR10MB2564.namprd10.prod.outlook.com (2603:10b6:406:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:35 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:35 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v6 net-next 2/5] net: mscc: ocelot: remove unnecessary stat reading from ethtool
Date:   Wed,  9 Feb 2022 20:13:42 -0800
Message-Id: <20220210041345.321216-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210041345.321216-1-colin.foster@in-advantage.com>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eefa4083-9ead-4a6e-018f-08d9ec4bfc70
X-MS-TrafficTypeDiagnostic: BN7PR10MB2564:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2564A8A4420EE548E35BB641A42F9@BN7PR10MB2564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knRJ6UyEAnXOZnVvlgIHsNXMcVUGcgS/KtgGtn32XMUj0RauaINP/UsemDW1Z0UubeV24W+LTjC+yZ23aWnp6yC8aNNQa+nbDaHKzFqLF2MCN8rM8Y6OZeNmb3jgwvEWAOAjgNgLy8rWR8N7fsde8siSzBzGnNkGmkHwNvz56ZigN3a463CUHoW7db251N/G3GC3pUMyCKJMyzeQzbp4QOsSJiqXz03/JP1r8GsL2gFbFdrnQZ402DMVhFFNyct6JnvDw2RQsT1yTawLljhJIPd2/nCgWmD2FxhrmaRHIB168cf6nocRHAAimUUpzITQXVb4pWDwd5I80K4bM27eyCFSOTuZsnBWbO97/tHKru+wbDZpPT5rHITsNwNbHnP6eHC1d9VA7asCYnXUH3ox/z4wEGTCs8a++yj3gvIdIAq9mymY4JUnt3dypt3PLdDZS048bejUsrBuci7WiB1HQLLy++19cmsZ2A56suwlq2RJ6+B3BmVTg8vu60ZX6SkTyVxK+/kihiLMTb7bgZKaGLG0yDtwkw2Zh3Q3pPkH2yHgujThFcFqA/07jET4mplGXLiPR2PXFV8fjQPeRla67+nZhgNJPaICQu0Qzda0bFc8hxGZJZFEAVSAqFQffK6RMh38YSFzA1KwMo7F0z7XyPoJtiZkZztbFXWnrcE/PlNrkXU/Jxz0FNg1w9iJGEuQksQ+66eggi5kCo7EZRi45g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(42606007)(366004)(39830400003)(396003)(376002)(136003)(316002)(66946007)(86362001)(508600001)(8676002)(38350700002)(8936002)(4326008)(38100700002)(2616005)(54906003)(66476007)(66556008)(5660300002)(26005)(44832011)(6486002)(6512007)(2906002)(6506007)(6666004)(83380400001)(36756003)(52116002)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5c1mrxgVfSLWm/kbk9H3l19fQ9wJtV9t682NTRFpzH55JcNnJkmy4ogv3cTs?=
 =?us-ascii?Q?ODyHedXcSynd6sij4L0ZOLQp70QtmI/vZ4+qxv7Y0vTEoNFiPFvPL/xSXUHU?=
 =?us-ascii?Q?MR0idufpxqm6+Yzgyun/H5HWWAWJH+AXtUp7jGb1MVAJwAkqImhGHeczLIC9?=
 =?us-ascii?Q?E2Q1sqGns4+NXG9GCHySXqyhUoeck4WmVYyzHU6bKNd5nS4j3IegCgepz+rj?=
 =?us-ascii?Q?F8eYFfCAkyqQzHYb+G94FQCW6CLXjtViobIgOFY6feSCeaH6zJrTZtZAWm6b?=
 =?us-ascii?Q?90Uz3PldkQ7TvyLAYiU8ABP6G/aZf8FDq8udZZbnLsD4flMTgnxFlE7WfANf?=
 =?us-ascii?Q?af/5zkc4g61FNAnPPJgASjnpF8rwvc5M3xD24JI7PfpjzcRRpJoJRWZ98YW1?=
 =?us-ascii?Q?IrLaAKWlRRjtfTIshpgLtuGbQ74cxlEDlQtQ6/fKBPAtHvaa3W/uPurVvcZR?=
 =?us-ascii?Q?CBl1chNV3Q0dFBNdu5sOWMhIa4qXxi3oz+wSW1uR5q0s4qTts0ZGQxpO3+Eu?=
 =?us-ascii?Q?L+CFpa4CD09w9aMB1NgJqxY4YnS68J6eCu6ADCfzhVZriqyvn+Epw1aG16g1?=
 =?us-ascii?Q?hQWJ1x3hgj22OS+n0iexwB896E7NBD0O+PCdBHNXLte1M/Y3B9aZUP59E2ym?=
 =?us-ascii?Q?4Nc+d+a97Yewvl6Q1ADS2e9FScdsPTllz8beGuso3qM3smUm3LIfEI6k7B8P?=
 =?us-ascii?Q?XQc5sEz5J4MIoMWcuqnFvzfOQvLoZ+dsFXWfq//fg07ySzXI3Jp7zLmhJK/I?=
 =?us-ascii?Q?EJbaotsWvvbyjN630b5le6QyRRmpyTJswdVZ61IXcVuhzItrft3p2G7KVySD?=
 =?us-ascii?Q?2VDDHNjpJclH8oqAlhDPUIX22ZOdhjK+uFBmusLRG1DXOqelM1erv3gQvd4A?=
 =?us-ascii?Q?9vTj6fxEse2jnt5ekmMdcLBmJOLqzUHDCLd/S282p20SWSa7S8rBcEI4B94B?=
 =?us-ascii?Q?Qwtg88RGeDvJn6RrdvVkX9QDtW2BgCF/2LoqTOTbP9CfYfEqKeykbQl6pdyc?=
 =?us-ascii?Q?/G1YnXarddfQ0PQL+SnJdjJ5LX4fT8p957gHWWQF21hgc8Xa4nGuejgehyxb?=
 =?us-ascii?Q?MSAzIoh1u7RWBd48bDDCIGkhRkCy0xp5WnOFcao5U+idAU9IudTcPeh/g+DN?=
 =?us-ascii?Q?ILri3zUx+8DG0CrQsC9SMZwZ2wCH/8uMCksuN7OhyiNSU4PlMuBExAR3ItDc?=
 =?us-ascii?Q?QRugNhcwdbtCr4Uz0q6gTcAYJl/Z1XDTFvrqyxzkA0KWp3tScoSgFkLYkgu4?=
 =?us-ascii?Q?3Qqz3Ix+fMk7JnAloBPWgYKK5vGDz1OGqhSmcwtYMykrpRXdnO1YEFA2YopZ?=
 =?us-ascii?Q?ug0Xcsvj9KGcXx0gbEdM0ql7ClCtfbM+M8buv9FOFgF8buVabvogVF8d6G87?=
 =?us-ascii?Q?/5AS7JeJnauNDz8TTTKabZ6H3et9gR2sY3oxU2pY5lQJERRc+tMWBPm7cfzd?=
 =?us-ascii?Q?eVazkBZojzp6ISdvdwR3cuR4qcQL1kjw+kBmsRRCFwAQlxkIu+zSC7gITA1f?=
 =?us-ascii?Q?zW0JYjRTyERwPSDJsD7pCwFjv/eQ83iUnxNwWehvN+3mwmvCxb325cy01wie?=
 =?us-ascii?Q?A7iv0FJiVLcLKaFyhYqqfgGshkZpW9r+eKNDMw0T9lTQrzovMAiEI6MMGW1h?=
 =?us-ascii?Q?mzSCu9SisJsYmd/IzpV/8+P0JZJgxzNn2BJR50HiHbG+Awv+catUhvxA92AU?=
 =?us-ascii?Q?VRl9+wQF+l4vluP+4Tv0fze0j5Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefa4083-9ead-4a6e-018f-08d9ec4bfc70
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:35.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hONyVS08VSCECmBtnJ/NMrvbGdHAuunNXjgJ+T2VBXfTl9bsqakrgmR0wB81bEtgMkms1kM6MjyYgwC7jbEpdsUKmtc5J0qD8KoGgItRg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2564
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_update_stats function only needs to read from one port, yet it
was updating the stats for all ports. Update to only read the stats that
are necessary.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 33 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6933dff1dd37..ab36732e7d3f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1738,27 +1738,24 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 EXPORT_SYMBOL(ocelot_get_strings);
 
 /* Caller must hold &ocelot->stats_lock */
-static void ocelot_update_stats(struct ocelot *ocelot)
+static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
 {
-	int i, j;
+	int j;
 
-	for (i = 0; i < ocelot->num_phys_ports; i++) {
-		/* Configure the port to read the stats from */
-		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
+	/* Configure the port to read the stats from */
+	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
 
-		for (j = 0; j < ocelot->num_stats; j++) {
-			u32 val;
-			unsigned int idx = i * ocelot->num_stats + j;
+	for (j = 0; j < ocelot->num_stats; j++) {
+		u32 val;
+		unsigned int idx = port * ocelot->num_stats + j;
 
-			val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
-					      ocelot->stats_layout[j].offset);
+		val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
+				      ocelot->stats_layout[j].offset);
 
-			if (val < (ocelot->stats[idx] & U32_MAX))
-				ocelot->stats[idx] += (u64)1 << 32;
+		if (val < (ocelot->stats[idx] & U32_MAX))
+			ocelot->stats[idx] += (u64)1 << 32;
 
-			ocelot->stats[idx] = (ocelot->stats[idx] &
-					      ~(u64)U32_MAX) + val;
-		}
+		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
 	}
 }
 
@@ -1767,9 +1764,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct delayed_work *del_work = to_delayed_work(work);
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
+	int i;
 
 	mutex_lock(&ocelot->stats_lock);
-	ocelot_update_stats(ocelot);
+	for (i = 0; i < ocelot->num_phys_ports; i++)
+		ocelot_update_stats_for_port(ocelot, i);
 	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
@@ -1783,7 +1782,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	mutex_lock(&ocelot->stats_lock);
 
 	/* check and update now */
-	ocelot_update_stats(ocelot);
+	ocelot_update_stats_for_port(ocelot, port);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
-- 
2.25.1

