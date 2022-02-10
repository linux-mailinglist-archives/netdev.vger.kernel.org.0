Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7299E4B0458
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiBJEP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiBJEPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2134.outbound.protection.outlook.com [40.107.243.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B7555A6;
        Wed,  9 Feb 2022 20:15:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0j2gcqgSe/7QN/2xh4nJnNf73KktUzIqqAnBB1orB74fiTdGPCPj/cKU3GbCQluomnwtcm+JnPv4oCx6I01EIdFzj2k4LIqFTiRkT/iLCbh6ODeoF5Pafc4g+4s/KNju0sBS9Fyo9xJ1YS+u8AeyP5wifQipvlt4/PjgdrFAOTnPG5eWIrJyVW9FFfF/dd1Vz1Hqhr6eDW8/wN/1/X5SsmjayXHenS37+empPMunzHN+wDmNodnCoFuzdGRKTSUA0xdcSp9dHRyzCE99QghbbkcN3P4eMaGiMPdi9UJwWNk06/ohW141vCE6q4fF/k33orw3/VDL1KE9n7Tp52x4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCdbYV1Xq8sohXnLl98Hp3cJeFl4JNmhf19w3d0IQbA=;
 b=Q0JPFkNz4Q1FI1yiFsLmNiBJRBVszZqg2Bur1M5lUkPl4go0ARhNdTj/+KZkefJ0eRRMLbhemzLinawLPcbgk6Xd5T+1UxM31bo14HYWPr75/I3fUjioksTDrAHxuEQ6cIw2wyEpj7l4Y23EgQoGFCxQ6Y4t9+SOSr4ihb5puJm4yqsPBy0GjoBCJfvGqB2LiCXQ1ALPhFRKzlJw8Hw3QzQjZbnAqAEA3rq6ghVpLRilvckscpMsKU5yvLjASVrgJjvZi0vXLCrFLdfzh/NSL4g1MR97/1NPE2MFL7Z3O2RwuIHauR71j/ihoc1VnaLzBS7CFFNDASyPgQBHj693dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCdbYV1Xq8sohXnLl98Hp3cJeFl4JNmhf19w3d0IQbA=;
 b=qsxgxWPUso7PpgHTlU3T87w+IHofy7w9usptO/XbmyXKYz9Zzy2DxliArZvtU9c9syqj1Bblm3jRtO/FggwfnWIa3HPqhSEakaRF1h1U1EKJEhi4JOE9YuIaafvHPfZX+USq/q6Bgx5XTyNuroc4WOlwrL2eUmvMZvbq6Sb3eOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:38 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:38 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for stats
Date:   Wed,  9 Feb 2022 20:13:45 -0800
Message-Id: <20220210041345.321216-6-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: c9749d73-4807-40b7-e1ad-08d9ec4bfe5f
X-MS-TrafficTypeDiagnostic: BN0PR10MB5048:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB50482F5F58AA7A849CA34C5BA42F9@BN0PR10MB5048.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUVMUOiTr8t9/q7D6w5Yo+FhYxIwVnfPHKJoyCjYyHF1bA2yKwmLa223Yy20QLCSgOEXxHgnvXfdVHVQ9+BPPf+RraSF+Ovhs2PFDT4m9Vw/mM8zQgVRCE+K2NAB07yPts5NK8p2jQzn6SqTqF40SP3Tv7rxU8fDrpUkCIEL1LFdpKYHqa6hIiLLBCsxjlO4CYa9vK+zVQzhBriX35bOZdu76a3xLNRMw685koVXIxAj7JDxE9fCHCEJKTMH+u3yhbmpQGDLRiLoSTyVN2bqKZA+FKL2LYrm3s0yYKGEUlOw0p9x1von65Ae4jne79PfhH2sB89QSQuy5EXx94m+8/GBpM77Hwflz0pTifb5NkEXMwga1kvmCjxSsecqsrGM2NUiFkNegjWQtxwF3dptalCKNBnbyt9/Lx09ZNnF0NYo/umrx3y1He/07PWPwmz8/97Rqd7onYQWbHjOP5zyIlsETknqYxLawNs0mS3uBqV3rhGe3zEYqUKL//XSf5Sxo33kExK4Q4Kr2Ck1cNQE63QI8d2EXESXHyiu4/s6ZbPO0NPb/+UExepxsS2v4F3NfWh0YpRPLXYabhVBsOp7vDUh2+nF3kQvU3TZ0MrpDEmUjNx+HRCt7JcyOsDzf7GVifkxU1AlrIvOol47YVS9i61SkaUWhC6eQUVXZCFd0v9lTV0kpNoqDphL9DWK/kYk0M9fAFmWH7J9DRTUuF1SYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(42606007)(136003)(39830400003)(396003)(376002)(316002)(4326008)(44832011)(66946007)(6512007)(86362001)(52116002)(66476007)(8936002)(6506007)(66556008)(54906003)(83380400001)(8676002)(1076003)(36756003)(2906002)(186003)(2616005)(5660300002)(26005)(38350700002)(38100700002)(6486002)(508600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fD6NPwvY7oksXDFeK37epNxlB+KNs+S+VajJoU1mu+jrUM00wlf3zxmM+ZIH?=
 =?us-ascii?Q?kerPbDgeYbqgLbaMCp+/qfgydWydfwD6jybzW/DOH39cTDly7WxIM0FcWceQ?=
 =?us-ascii?Q?AMatk33GOa+Gi9H8dhZdQTWUGVRPTQYN4+qAjwS0GSI5WccN/U4PWKADvxW5?=
 =?us-ascii?Q?N6CGXzVylWZ/2YJP1WUf+ywwxm/uiBEeBqUO1ZRCGJsAF4IVjhYoLaCA3LYS?=
 =?us-ascii?Q?tjM8qNTEvAw3w/Zbt8qpVkT3Mgrl2w1Cr/rggzYpqm/fHHHn9KaXPV/ejfWp?=
 =?us-ascii?Q?FkbMNA7CdV6caA9Uvb5Mh6nCwHIBdOwoxF9kiOkllnifF201zmZg4hAZO2Vu?=
 =?us-ascii?Q?Rvob7d/1ZWJbBbPYkq057+uC+bJRdkD2PTqb3JJQZgtQVTj+j6vWczD7hsE8?=
 =?us-ascii?Q?0QbF6cYI626JnsaRixKFSo/yqEHhY+b3jw319qHYwLcJj0TPV2CaUTbXmyFy?=
 =?us-ascii?Q?Loc5NP0clWHU4eYobKwV7uNhV73o0HivvCfp8WYmokbZplz5W0GJkXzB0GSD?=
 =?us-ascii?Q?OaRcrCSBHLSuZHvIrE9AfuIw8hs/ZL+puaBKLUWoPBy2ZvD8VkopqmKPRiZH?=
 =?us-ascii?Q?ZgZSUsbATlBoMaGAa1sLYJIX7NIr5CB+9S+npxoJoOciM3Ie2WckI7dBS1M3?=
 =?us-ascii?Q?b5aS3sJvy3Ku4lclQ5/7a1G/H0x3kW5JgTe+KeLD2zISeA0S2maN+GkUr13o?=
 =?us-ascii?Q?KGv2d3knftYPdNxjxTqZNKj32Tt9XL2YlOsbEDsFEjOFs6UDjDG0s/MBaKWP?=
 =?us-ascii?Q?SZct0BIj/Z8labu4YfdSZeVotPa2HM3zqNqZaV76+O/ldZ3Q4pk+i2Fh2Upj?=
 =?us-ascii?Q?6wT7R28h0EEyvbb8oYF6pGcHKBXC9QNPj+/L0faVfkCvazpyETAi5hNWEve1?=
 =?us-ascii?Q?tGhohUeI7p48+HV80gjARa15R/wW8Tm7dxLhQvGtOAGNBnfwTlRLzpeDBQk1?=
 =?us-ascii?Q?jQlWBF2nYaOuxKCAn4XOiuXLGyNeDnJEP/95kTZ+ZAPwWk6vxmWlcMr5fpib?=
 =?us-ascii?Q?V5uAymqCDMdXcU3vzCuG+vH+l4/qFme1s9l1RSvVwZT01SmxDvmRAEi3axbG?=
 =?us-ascii?Q?BEFMDGR3wklClPLMp6Fn8gm6cWtm0mCE5lvGXIdLD4QToafTs/cfmqx9RBTj?=
 =?us-ascii?Q?FOALMEhlOun3lRr3DsMwtwCYjrh9p6dY3Cfe2oqbDEN6JDjA3ykU4FqwCJC6?=
 =?us-ascii?Q?1kf7u7WWTYYs39ZjOtjOfNV/YfbqPaiQ8MumDHW54NNheP435Osz9+MJgNQ2?=
 =?us-ascii?Q?6vY2KWKvZkUU6OoOD12b5ErRG45S7TWOTHfnM9swrABhdYHHtQfpc07L3Upj?=
 =?us-ascii?Q?NBgzNWWBsq6Jxmk4kuAttUCYyLYqH9qDGORtB7z7Rn/c6Tt9/vOA7HtybQtT?=
 =?us-ascii?Q?y2bCMcsxYmpkNbOd+SpR8h0aSG3gDv92h/WtbkxmWhakalit+17JQJeqSNy5?=
 =?us-ascii?Q?ALYlbcUeqz0FRtKf5UeQQtxB03sJA29dexuSPadQ4Ya7e3eqCoUUwu6vFBnJ?=
 =?us-ascii?Q?hPt6nad5zCSOTr1JU/6WMS93BmCEOFoMOFabqnVlHz3D0g5fQg/3fojLGQSI?=
 =?us-ascii?Q?RvyJP0MqlgYWOws6Fjs8474EdGtl12wz46zjT34vtUz1cA7BimYvBamow5wk?=
 =?us-ascii?Q?MYhk7fumBbpvQ7PGuuhjeL2ofkHYz2+I+RU0JT2nUgXgatX1WDiI/GL5ReXU?=
 =?us-ascii?Q?wSL33w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9749d73-4807-40b7-e1ad-08d9ec4bfe5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:38.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRnIRwsVyYe7QWxKXhEnK83fBDVai3rGPquoTY4/dGUYV2Dku6QSr5CfWRyDy2LX6jhkFSn682KjwUj5WRm5AJ6BNelB9KPa0qVxmymdV/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and utilize bulk regmap reads instead of single access for gathering
stats. The background reading of statistics happens frequently, and over
a few contiguous memory regions.

High speed PCIe buses and MMIO access will probably see negligible
performance increase. Lower speed buses like SPI and I2C could see
significant performance increase, since the bus configuration and register
access times account for a large percentage of data transfer time.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 79 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  8 +++
 2 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ab36732e7d3f..fdbd31149dfc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1738,25 +1738,36 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 EXPORT_SYMBOL(ocelot_get_strings);
 
 /* Caller must hold &ocelot->stats_lock */
-static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
+static int ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
 {
-	int j;
+	unsigned int idx = port * ocelot->num_stats;
+	struct ocelot_stats_region *region;
+	int err, j;
 
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
 
-	for (j = 0; j < ocelot->num_stats; j++) {
-		u32 val;
-		unsigned int idx = port * ocelot->num_stats + j;
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
+					   region->offset, region->buf,
+					   region->count);
+		if (err)
+			return err;
 
-		val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
-				      ocelot->stats_layout[j].offset);
+		for (j = 0; j < region->count; j++) {
+			u64 *stat = &ocelot->stats[idx + j];
+			u64 val = region->buf[j];
 
-		if (val < (ocelot->stats[idx] & U32_MAX))
-			ocelot->stats[idx] += (u64)1 << 32;
+			if (val < (*stat & U32_MAX))
+				*stat += (u64)1 << 32;
+
+			*stat = (*stat & ~(u64)U32_MAX) + val;
+		}
 
-		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
+		idx += region->count;
 	}
+
+	return err;
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1777,12 +1788,14 @@ static void ocelot_check_stats_work(struct work_struct *work)
 
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
-	int i;
+	int i, err;
 
 	mutex_lock(&ocelot->stats_lock);
 
 	/* check and update now */
-	ocelot_update_stats_for_port(ocelot, port);
+	err = ocelot_update_stats_for_port(ocelot, port);
+	if (err)
+		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
@@ -1801,6 +1814,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
+static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
+{
+	struct ocelot_stats_region *region = NULL;
+	unsigned int last;
+	int i;
+
+	INIT_LIST_HEAD(&ocelot->stats_regions);
+
+	for (i = 0; i < ocelot->num_stats; i++) {
+		if (region && ocelot->stats_layout[i].offset == last + 1) {
+			region->count++;
+		} else {
+			region = devm_kzalloc(ocelot->dev, sizeof(*region),
+					      GFP_KERNEL);
+			if (!region)
+				return -ENOMEM;
+
+			region->offset = ocelot->stats_layout[i].offset;
+			region->count = 1;
+			list_add_tail(&region->node, &ocelot->stats_regions);
+		}
+
+		last = ocelot->stats_layout[i].offset;
+	}
+
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		region->buf = devm_kcalloc(ocelot->dev, region->count,
+					   sizeof(*region->buf), GFP_KERNEL);
+		if (!region->buf)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info)
 {
@@ -2801,6 +2849,13 @@ int ocelot_init(struct ocelot *ocelot)
 				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
 				 ANA_CPUQ_8021_CFG, i);
 
+	ret = ocelot_prepare_stats_regions(ocelot);
+	if (ret) {
+		destroy_workqueue(ocelot->stats_queue);
+		destroy_workqueue(ocelot->owq);
+		return ret;
+	}
+
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 312b72558659..d3291a5f7e88 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -542,6 +542,13 @@ struct ocelot_stat_layout {
 	char name[ETH_GSTRING_LEN];
 };
 
+struct ocelot_stats_region {
+	struct list_head node;
+	u32 offset;
+	int count;
+	u32 *buf;
+};
+
 enum ocelot_tag_prefix {
 	OCELOT_TAG_PREFIX_DISABLED	= 0,
 	OCELOT_TAG_PREFIX_NONE,
@@ -673,6 +680,7 @@ struct ocelot {
 	struct regmap_field		*regfields[REGFIELD_MAX];
 	const u32 *const		*map;
 	const struct ocelot_stat_layout	*stats_layout;
+	struct list_head		stats_regions;
 	unsigned int			num_stats;
 
 	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
-- 
2.25.1

