Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606444B3D12
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiBMTNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:13:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbiBMTNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:13:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2130.outbound.protection.outlook.com [40.107.236.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1862593BF;
        Sun, 13 Feb 2022 11:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxFnbPxCm2WYDIZFmye2bah4wFkUE+gxVXGSSoXmAz3hHUKuQFrjCty6QdJlqdQqw0drtzvQA74wMGvDTbsIz13owh6rS5hBrMsm8rpogTfOEdurzZdcpLyoBV6ED9MSA5OXYX9km97i4WgOMSSU9ccMBst4jYBORHn5FKompTjQyp92vfOxxrlt1LR5mqusOubGJdtqtUrL1JoI/yKTALADSnI06xBzLY6kjAbL0ZhxcEWgksPpi0rJXRZVCVFGvdgPaCX3DsLNhx/xKg4YBL99TmueWBMODvB1i5ZLjM+SON2QVe6pM2IUTNtMMDa+YtyUn2Vujn9Ufleyi6NMnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZHj/DHgAuUXu1C0ErXL6Y79QyrspA4UNH5Q+pqM660=;
 b=i0euhPkgLu7gJuqnoMDeY+A0pLyDR2rokSusFAGfq3n1SAFVU2MoRiqdQMPaPe+5z1qoA4ohRItRKIa/FW3monOC9mFVmkEM0EYbYbXzHbo+fJXI2c994gM7mBN8UFxeTRF3jMrarUWK5MF391P7HvL0Gfj11gn3FUbsIqgaCqutekyMVA42jPAo2C7gQfY8xq+TXSscq/HVgp5UXuZZLGRyK6PjRR6UNFn+jI77kNV2NbPuWUOAYsguXwMCIqBmxUKOT+LJfCzmk0ojeG3hxh95NBsoIagPGxhkWodeLlDiuec35cS9RTvZtmUm5DDit/dAGBSzSVjd4ff3bOuOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZHj/DHgAuUXu1C0ErXL6Y79QyrspA4UNH5Q+pqM660=;
 b=S9d2ML11NanNWhZxHTOISotcTeTilBjAu4gvRs9kmEr1Yn7w+4XoDnz6sUO/26xhio2tp5t0VAb3JZ54TsbM3a919L6p1sGH+PmCxFyAG32S6v6SSfdB7ImV/v+OSuylVg0i76YvyTKyM76jCYqUsJwgUnZ5wSYMvS+k6dbS8Cg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3315.namprd10.prod.outlook.com
 (2603:10b6:408:c8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 19:13:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 19:13:10 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v7 net-next 4/4] net: mscc: ocelot: use bulk reads for stats
Date:   Sun, 13 Feb 2022 11:12:54 -0800
Message-Id: <20220213191254.1480765-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220213191254.1480765-1-colin.foster@in-advantage.com>
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e1b6391-d6d5-45cf-f144-08d9ef24dd20
X-MS-TrafficTypeDiagnostic: BN8PR10MB3315:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3315BEE7EDFA862A8288077AA4329@BN8PR10MB3315.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7wElJkUaqwcyVUa9NdWbb3j8L88JR5YXz/DWLFEtFu1NP+tVZFDqT8EbKZ9OoERh7zBrjwGUPdtiD9fus264NJcMGcuZ+XilmZJFpnald0A7nekpeVW2Gi0JJwavcWOP3iMi1XjeeX4bxolYDHlquZYfe8B20kmnfqVAR0SCNpjbXkOUYEHCdInP9CuQXe7mK7TLT/rIOXkn7Ad8V6wSDPIWu7aCsoF1Mxlg+Mq3Gl2h5iUDRbCl662rMe+vGRKC8O5rCZqPBw8Zc/4/0oHdMrECm2C6k1W7lD0SifJhEQCNv5M2+Pa4x+b/1lpdvY/1e3IdjXFXzHfZwgPjRW18PFcPY+DT2AxS4BqEyKKylKj+zo/Q4wUsBkJCU76jrNyDljD7YYmflWwhU3pfbmndt8xgVu5F01Ror3Bw8dR6s3CNViAc66ZcS9sutyA5fCflcFZ8xE5kHeF57gTWLpneC3Cb1tudnA0/qfJNAUBWOVYLQY9a22ADffdUV+ioaced7izequQHoH5swpxy7rBcvVu03AfiKD2XXXeZK62+0PbOa0Kvz/OzQBL6G2w9nLQfYnmVtXyKRFlTMTPfsHWx0YcLJAloJpW6v93kYIvTl1rztoB2bfn8bsLRpKrcJUwhkOHIoL0MUtqgn1z0aQO8aqI0TkvgOsfb7qGW+zaSBwnDgcTVeScGGJmaZFPXCEe/XkY0Rdsyly5YmzmJEWYgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(376002)(39830400003)(346002)(396003)(26005)(186003)(2616005)(508600001)(6486002)(6512007)(66556008)(66476007)(38100700002)(4326008)(66946007)(44832011)(1076003)(38350700002)(5660300002)(8676002)(36756003)(83380400001)(52116002)(6506007)(86362001)(6666004)(8936002)(2906002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ns/Eumri1xPXnTpsJGAvEsrpLxmykYENGYkusdWoAa3EzgIirZTSBKkjV5FV?=
 =?us-ascii?Q?VTq8+NwYXeuqJ0v6rr325tZ63EC7lZQsAxGI41zbrsG0cMDgvxZmqLaSA/9O?=
 =?us-ascii?Q?LDH/vxeVBZy3WfRmuyLQOXFUGkWSJjKYNQOYZxwUPbv0sv3uIBWLgAWWPq+W?=
 =?us-ascii?Q?bW/RcooFpkVU+6cmdRGIrhKeKSC5Ma0a0zNe3x6iJfI6cOKOpJNP7sGJdU5p?=
 =?us-ascii?Q?YMv/VKI0g4FrpTShBdNQmFVm1T2Df7b7OT1/03VstVYN5N/OmLbAZtA9Dydd?=
 =?us-ascii?Q?dMeeFnebVR4rdqofgHYaXq8EbVNw5G4da27bNJFVIpeGWBAnJVIgMsP52n9P?=
 =?us-ascii?Q?bsUH4Bt0h9M8aVfjAkMBsVWi515gKb8TluD9Y+ms2tX2l+T+dckvdmHP7DB0?=
 =?us-ascii?Q?rG6gWN9ULXSaRV/sJNLzF39St0+ojUzmC5Q12gx7Bin3mcxnW29IOs7pKhiR?=
 =?us-ascii?Q?po7u6d1IAR7tZAONS2r+a03p4b844LH6OE9uRGqfOfAgENbczrdRrQap53ME?=
 =?us-ascii?Q?zbQqk2/seZyOoV34vPoI4QWoK+G6P0HZfCB8bqIbyaK+XzMAQUt/lCiZ3dPG?=
 =?us-ascii?Q?v0rxWetqaNhf7qAC4Y0e4WUCyLY/KV8ouwBcpVdQF4zuFL0zUOfIctWj05vy?=
 =?us-ascii?Q?3/vHUcOQgjg4s+AGOso8B63ygWDSbRsuHDLCujdLfk6cKRp1W6bCfosQV/zn?=
 =?us-ascii?Q?0YTWS4EKDqAjpvWstBKPiVkPfhoH/cd5UwHvA9/kboN7pNx0zaJ7KICtUDb1?=
 =?us-ascii?Q?k1t76+ekbaMwyeAnEyZxcFwVv0vYYPvOlL1JpPFCOKO1f8kEE6Bc88CHe+wE?=
 =?us-ascii?Q?/hUX2jgHPwmQu3oa5rCdQQ01nZjzMmBFKxB3gSgmGNCTaXUsIDmbvZV4JDkW?=
 =?us-ascii?Q?G1XfkwPwUWZEp39wicHQ9qB/+g1uzjEDCkpWTaS3xk/CSCbHUu3HAxiFkYB2?=
 =?us-ascii?Q?5FOyhhhukQgcAB4enhwSdZxKJL7bezJmQ9AvJNoulCNaAKdRz45ZZwb/0ykB?=
 =?us-ascii?Q?Z98TIVErvUm6yDrcTztwZaWl+MqtuGGVxEI01Htl3WvNldv8WXBsIssTRiC/?=
 =?us-ascii?Q?W/DS8XiNJ0azV5dtoMzOKQme+e5x7rYPEyeQHydiClixHzpAXxf870H+0t1w?=
 =?us-ascii?Q?9gFyCas4ZFluBKZY3n8R2dN1JphLqcPAa/PP69A4RVzPtPgrXTeuaGVDyxM/?=
 =?us-ascii?Q?3F/MDlgWLHX+OHz3JgEvBKf50xtYAWvdRJo+b4Xhi8MpyHSxU1Nks9IwE0vt?=
 =?us-ascii?Q?SN4QQ2URJq3KjYmdI/4nC9Wpu5X+4hz5/WnvTIv78xVkkEU9HTGtVKm9orb1?=
 =?us-ascii?Q?tLUwg2zw+QXZHEHRvMMzTybGYnWsRwR0A5fQfTrbIh2YzvyEjwRLSyUP6GJf?=
 =?us-ascii?Q?wYhYk4YDg1pMOYwIs/RnCiZTY1PMGJxT0DcqdUlTnJxFz/9gjACws5rx22ZF?=
 =?us-ascii?Q?u5DNgsNu06knVTfzKxA4Hs/QCGDL1vD9BibRoteK5HzRvSSRJzhN01slo8zG?=
 =?us-ascii?Q?FsyHVMeWjmpyyZAcM+WVTLSBXEguJOoP/FfqFoexHMdHQox29MU6AewJ5ycy?=
 =?us-ascii?Q?TTiamXL5XvhhJdPPmT+lEdXtn9mbeDObc0W6BMWQ9V6lEPL6iRf+YPhXBvGR?=
 =?us-ascii?Q?25RJLfdcfUjHiTMZmfM/uaa6mUKCEgx1k7JJhOt6tFoMxKTnCXuorYAaqe5C?=
 =?us-ascii?Q?e4xqnQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1b6391-d6d5-45cf-f144-08d9ef24dd20
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 19:13:05.8826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtMI1/AQIR9ZjmHxa5d6YPu8itlFcj06T0NfeHKAN0fGVnI2955MeLIwvSdjlkG9jpR9UxIXiswDIFZO3fWaRJl9tPMcqFC9SkNCQtm9+vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3315
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
 drivers/net/ethernet/mscc/ocelot.c | 92 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  8 +++
 2 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 885288eb389c..637fd79402e0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1746,25 +1746,36 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 EXPORT_SYMBOL(ocelot_get_strings);
 
 /* Caller must hold &ocelot->stats_lock */
-static void ocelot_port_update_stats(struct ocelot *ocelot, int port)
+static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
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
 
-		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
+			*stat = (*stat & ~(u64)U32_MAX) + val;
+		}
+
+		idx += region->count;
 	}
+
+	return err;
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1772,31 +1783,40 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct delayed_work *del_work = to_delayed_work(work);
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
-	int i;
+	int i, err;
 
 	mutex_lock(&ocelot->stats_lock);
-	for (i = 0; i < ocelot->num_phys_ports; i++)
-		ocelot_port_update_stats(ocelot, i);
+	for (i = 0; i < ocelot->num_phys_ports; i++) {
+		err = ocelot_port_update_stats(ocelot, i);
+		if (err)
+			break;
+	}
 	mutex_unlock(&ocelot->stats_lock);
 
+	if (err)
+		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
+
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
 }
 
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
-	int i;
+	int i, err;
 
 	mutex_lock(&ocelot->stats_lock);
 
 	/* check and update now */
-	ocelot_port_update_stats(ocelot, port);
+	err = ocelot_port_update_stats(ocelot, port);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 
 	mutex_unlock(&ocelot->stats_lock);
+
+	if (err)
+		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
@@ -1809,6 +1829,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
@@ -2809,6 +2864,13 @@ int ocelot_init(struct ocelot *ocelot)
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

