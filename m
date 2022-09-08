Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FA05B23DF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiIHQtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiIHQtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:06 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20043.outbound.protection.outlook.com [40.107.2.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AEC12BFBD;
        Thu,  8 Sep 2022 09:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYetsb605grqQz6o74djdPpmMFHrhB/at1cJjB084VsBleExaLlq7Vjm7pXWqhC3QUGoo/W2NdkCRnE8pkMSI7nHo3V9C5U2qfG0L52+DO7kFB2wpYIAdc9rF6XMr19xiIETMHbQnONWoSnNQVjdQGL98c0ZurGvxu3NMQheaxY+JMVF195t5XJp29oGv+HdWb46Lq+2ci+LBbkQjyDZ7SRoADMiq3Q1J0B88da5tjubFUE9VaGTIS3ZDlBdjim14qaO1qkqOH+VfbxEfnDrsAYXAN7mRyr2g0MA05YX5SOFq5Mg35EWG9xTiNdV+wqcmPK4OYDZMN3KwObb9GyUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGOygotCz6ZAX0Td7fbHo+E/YH/NBEWjC6Yb9rhPQnk=;
 b=UsvZYEpminTy/E1NQJkL3qt/x/ZZvSxwrDPWNXy8DJi4EIByF5ksEnpFw14Wn9E6XYbacmUuKcPrta9F3cnnOJtW492YMyYJwVYyx6MuFtb9UI284N79+hNLH9mHsbsfJXYuSYp1Ln+sWqb26a3m3XzcgsJI34J620HcXOWX6bQGcfkm/42wsMQ21T42c51IqFnxCSo+z7DKEsQtLMs2b4F1YhI4YhzHU0KYzk0BKmg3mB0yCQRhUZQbK+8sT44EHZRzy6cKwg8aHa7xZMaQQlgoE/9xAK6A97ftLl6L2VRo//bZ77VhAVT/mjeMFVo8hCpiU8zw5pl3dhzYVSyGKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGOygotCz6ZAX0Td7fbHo+E/YH/NBEWjC6Yb9rhPQnk=;
 b=CS7DtJl/ArlG9xsviG9gsZKzb83VzfCcYmd0ClIEckNf2IGaH9svIZ46soUdyntf8RbW1s+0AjHUG47MZs9gpwl0X7T9Td1vw77ARWbM1eVJRQd+ZHpPq/8u3+oIVzERJDgKTDZSrOnnPeeekYi/DyYHzPsDfbjYPilGzkSqHjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:48:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:54 +0000
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
Subject: [PATCH net-next 06/14] net: mscc: ocelot: move stats code to ocelot_stats.c
Date:   Thu,  8 Sep 2022 19:48:08 +0300
Message-Id: <20220908164816.3576795-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ab84009-a164-492a-88d5-08da91b9f80e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWXHfho1tf0IyR4VOytzfA5A8uVWAzLKjQyF0SD1ZOO0ciRjsKwzvzPBAof+tpUbAYjcKM35bvci990lWySBcaWQVh1tX/KrbfTvosHLzAusVSYbxk4AFojrlvmW2iMKdnTtqYeFU5mzhz+u+8NQPdXyAFNFT7xFF0FDJ/Wbe3b1+2hNJJDLT7SCEJ0/Qmkm/LhKq8XayzEP/rdDWkDG0rwbkDibZJQ1JwgAwpD8fPfpm47bohNmwoXgy4QOJe9UkQhPWkqcHJwQKznR+1urktrZAVFXk0EiDyz+ejtvxWvDOD6D8vmRHAGl5YxgbQakZKCAdhk37Kmg5nUmipmqFWW63zyJ+iLuL0NJWXl2JwQrtd7qwfVoH5zcZZYyBu13Hq7P/qxi6t/9Nycek97frTL5wqYV0Jo9huNbOuS2CJfCsm7eVMXMTyOXNvuK0IZ94ToWJ5ekhF76NkreUD7OFspeIviOin21a4/S0H6Ho2NE43QMXFJb2YpHagSS9OjJmyYtY/ouZPZhEXE0PisiInOZ5WBt6b2zT5kum4aEGAGtX3SNXr2pqlMK3vOkN/ibqE8RNrkBMgt1jZLab2xLdt1vhoIxn8yN0p5CbXZiUO73MfwEPr/SqfOILULBVBL+xi8c/F9U3iPZIYoPufp3K+YK+XQV72pkhYRmMm5twr5fbKvML7w2p6OhY0zWh1+j3xwsLxsbLa4PwRYxKiKdD58/ObPcVmbBL/GQIkaTqBeGiMXJIUQ4vhyIQKiewcioTRejSVV6GT2Fg9WQOT0CTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(30864003)(7416002)(52116002)(41300700001)(6666004)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bR5quzM2GG/xdKKrvGeqV4Y9AAVp8cYa0ariWcWxYDaaxjGaOkP+pnAxARzu?=
 =?us-ascii?Q?9zWgjpC0AiMQZjU0naSDlIR5aK9dYDQgfknO/PWiGcy261g3nnNAWfwnHMLe?=
 =?us-ascii?Q?vtoqeIayE8ZvbkJhY8qGNjnI63PvcqYsh/Jss/l5Cqjciem7M59envM9zdZd?=
 =?us-ascii?Q?DrZnSCTuptTNrnsWPJDKRFQlBYnT6a7vbvsFD+oL+Aq74oBvlfqhWQekrfkq?=
 =?us-ascii?Q?JbKIf6R9dgL4cxKDjU2Gn7URhZGvFbBi7IddIxCVG5AEhqSYihHWdtxrnaoX?=
 =?us-ascii?Q?YlN2hMIYIgg8Qykp4Ou09TkpmuPUjEnkP3OWKDC+0YDOSlnq8YvrfYJV7TeU?=
 =?us-ascii?Q?dlPs6QG1zlZMrb/N39zQrW3++m5b/5MONuSreDPQP9il4zSEsSSQ5XwLuR1i?=
 =?us-ascii?Q?SdhmO/GcdnE6MJ3CppU5xgNDyeX0AUBkmosFtGOTSMwpiMYwoas3aNb66Xsd?=
 =?us-ascii?Q?cMn6uAlBIB6hAJBZelAfjMNugwte/JumjzsYlf1alWJKgy+b3BbYrSa5lRLw?=
 =?us-ascii?Q?p5nPytWdNEurXLOpV5O+2NnTie1B1DUgqNNAcJRkqbelH2Ol2gj2/dv+GuMW?=
 =?us-ascii?Q?/3D85BmYcVN6JOedHs+H3mMqfk0xncuNtp/G4EeazvMEm+vL1EoTyLboTEEp?=
 =?us-ascii?Q?RkkeGaix5TVTKo1IxzXnVVlmpTt2KvCJku4rmJB751i8nr3MwDbLU8jj+1Gu?=
 =?us-ascii?Q?4BjMP19l/Hi9apaZY0U1SwATAfqezRsz2L2EWAblDz/fCQN1pDvq6XmdBet+?=
 =?us-ascii?Q?iziQA1umxMT5NVVTPDvIPisaFCNPCuxCmfeBRUfUMjRbvETgXoKNBa+5hQX3?=
 =?us-ascii?Q?7mJdggb3gW/HftPdp67ZYWWoe5Ed09zgfe0kOJtyZK09FStSHIU/39OQye11?=
 =?us-ascii?Q?MiG4pl0APer9m3AFjEmdQ1iPXd94zkzYBAmELAMHNwTB61F06efMlHZRbFoW?=
 =?us-ascii?Q?z568Ji/WpiNHQa3U1C6SPsYj/5+HZgzvRZNywCpcsHtYWEEZX/wIj52TCsY4?=
 =?us-ascii?Q?M5zKxeQ0WFyMP4HdJVv50BLTrNyX2bbzNnDAsornJxy838UKAxyXP+B14Tik?=
 =?us-ascii?Q?qblJ3u4bBrSLPjfcgX7a3dNyLB6opX76Tp43QZIV3FHUCGaGMBZ8wIs1VRo4?=
 =?us-ascii?Q?0hoviQ92eJUzWNwJSWBnRZTReIb1Ry9OsmDGL/aPkNb6mBm7F/0Yvz5pdwUW?=
 =?us-ascii?Q?1wWiuiCRWhlMA9GHZZPjpe7vNtPew1SllLlhNPryAnGaWS3rMEeS5zvbXeB3?=
 =?us-ascii?Q?y7tRSgpBl+k9USBuifk7LSuHtuXj7oCIutXh6Z4vU/ot6nUcopr9Oa5h+6z+?=
 =?us-ascii?Q?42VXj/+KUnwxoqAUsRhL5u3ec2pV3HdUd1PmhHVft9CZ3Oka+0Iq+SsEf0R2?=
 =?us-ascii?Q?7tv3lUOzEOAZ/c4fFAdrRe3Dh4xhD9w9O7rXtRuPAOvHzrK4akjEpz9Ot/Gi?=
 =?us-ascii?Q?nbHBt5W7WjMnB6wDVB/elx4fcoZ8+Se9SARjz7aiUZ3cqcjS1VTjbAsdSDOl?=
 =?us-ascii?Q?tzBCcJE4jVKQd5qRrDYyO2GvTEZoDh4MvDRLM4YEB8JlgebKtQlFsEbQsD0E?=
 =?us-ascii?Q?q1dEztYsYa+Y4H4E0wRRbzNdUNsTCtoyuZRqgeCNg2+RmwvNgF8R+DLNjbEx?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab84009-a164-492a-88d5-08da91b9f80e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:34.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nqd7LyvXHFUlwY8n2AhqgPIOmn7mBg2paLJb0JVVdwRnLlQzjCx/cE1FGGZ+Gqp1nso8l6nUfyosLZYK9ifQXg==
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

The main C file of the ocelot switch lib, ocelot.c, is getting larger
and larger, and there are plans to add more logic related to stats.
So it seems like an appropriate moment to split the statistics code to a
new file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile       |   1 +
 drivers/net/ethernet/mscc/ocelot.c       | 214 +--------------------
 drivers/net/ethernet/mscc/ocelot.h       |   3 +
 drivers/net/ethernet/mscc/ocelot_stats.c | 226 +++++++++++++++++++++++
 4 files changed, 237 insertions(+), 207 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_stats.c

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index e8427d3b41e4..5d435a565d4c 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -7,6 +7,7 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_io.o \
 	ocelot_police.o \
 	ocelot_ptp.o \
+	ocelot_stats.o \
 	ocelot_vcap.o \
 	vsc7514_regs.o
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8e063322625a..be3c25ea278a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1853,184 +1853,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 }
 EXPORT_SYMBOL(ocelot_hwstamp_set);
 
-void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
-{
-	int i;
-
-	if (sset != ETH_SS_STATS)
-		return;
-
-	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (ocelot->stats_layout[i].name[0] == '\0')
-			continue;
-
-		memcpy(data + i * ETH_GSTRING_LEN, ocelot->stats_layout[i].name,
-		       ETH_GSTRING_LEN);
-	}
-}
-EXPORT_SYMBOL(ocelot_get_strings);
-
-/* Read the counters from hardware and keep them in region->buf.
- * Caller must hold &ocelot->stat_view_lock.
- */
-static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
-{
-	struct ocelot_stats_region *region;
-	int err;
-
-	/* Configure the port to read the stats from */
-	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
-
-	list_for_each_entry(region, &ocelot->stats_regions, node) {
-		err = ocelot_bulk_read(ocelot, region->base, region->buf,
-				       region->count);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/* Transfer the counters from region->buf to ocelot->stats.
- * Caller must hold &ocelot->stat_view_lock and &ocelot->stats_lock.
- */
-static void ocelot_port_transfer_stats(struct ocelot *ocelot, int port)
-{
-	unsigned int idx = port * OCELOT_NUM_STATS;
-	struct ocelot_stats_region *region;
-	int j;
-
-	list_for_each_entry(region, &ocelot->stats_regions, node) {
-		for (j = 0; j < region->count; j++) {
-			u64 *stat = &ocelot->stats[idx + j];
-			u64 val = region->buf[j];
-
-			if (val < (*stat & U32_MAX))
-				*stat += (u64)1 << 32;
-
-			*stat = (*stat & ~(u64)U32_MAX) + val;
-		}
-
-		idx += region->count;
-	}
-}
-
-static void ocelot_check_stats_work(struct work_struct *work)
-{
-	struct delayed_work *del_work = to_delayed_work(work);
-	struct ocelot *ocelot = container_of(del_work, struct ocelot,
-					     stats_work);
-	int port, err;
-
-	mutex_lock(&ocelot->stat_view_lock);
-
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		err = ocelot_port_update_stats(ocelot, port);
-		if (err)
-			break;
-
-		spin_lock(&ocelot->stats_lock);
-		ocelot_port_transfer_stats(ocelot, port);
-		spin_unlock(&ocelot->stats_lock);
-	}
-
-	if (!err && ocelot->ops->update_stats)
-		ocelot->ops->update_stats(ocelot);
-
-	mutex_unlock(&ocelot->stat_view_lock);
-
-	if (err)
-		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
-
-	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
-			   OCELOT_STATS_CHECK_DELAY);
-}
-
-void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
-{
-	int i, err;
-
-	mutex_lock(&ocelot->stat_view_lock);
-
-	/* check and update now */
-	err = ocelot_port_update_stats(ocelot, port);
-
-	spin_lock(&ocelot->stats_lock);
-
-	ocelot_port_transfer_stats(ocelot, port);
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
-
-	spin_unlock(&ocelot->stats_lock);
-
-	mutex_unlock(&ocelot->stat_view_lock);
-
-	if (err)
-		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
-}
-EXPORT_SYMBOL(ocelot_get_ethtool_stats);
-
-int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
-{
-	int i, num_stats = 0;
-
-	if (sset != ETH_SS_STATS)
-		return -EOPNOTSUPP;
-
-	for (i = 0; i < OCELOT_NUM_STATS; i++)
-		if (ocelot->stats_layout[i].name[0] != '\0')
-			num_stats++;
-
-	return num_stats;
-}
-EXPORT_SYMBOL(ocelot_get_sset_count);
-
-static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
-{
-	struct ocelot_stats_region *region = NULL;
-	unsigned int last;
-	int i;
-
-	INIT_LIST_HEAD(&ocelot->stats_regions);
-
-	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (ocelot->stats_layout[i].name[0] == '\0')
-			continue;
-
-		if (region && ocelot->stats_layout[i].reg == last + 4) {
-			region->count++;
-		} else {
-			region = devm_kzalloc(ocelot->dev, sizeof(*region),
-					      GFP_KERNEL);
-			if (!region)
-				return -ENOMEM;
-
-			region->base = ocelot->stats_layout[i].reg;
-			region->count = 1;
-			list_add_tail(&region->node, &ocelot->stats_regions);
-		}
-
-		last = ocelot->stats_layout[i].reg;
-	}
-
-	list_for_each_entry(region, &ocelot->stats_regions, node) {
-		region->buf = devm_kcalloc(ocelot->dev, region->count,
-					   sizeof(*region->buf), GFP_KERNEL);
-		if (!region->buf)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info)
 {
@@ -3405,7 +3227,6 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 
 int ocelot_init(struct ocelot *ocelot)
 {
-	char queue_name[32];
 	int i, ret;
 	u32 port;
 
@@ -3417,30 +3238,21 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
-	ocelot->stats = devm_kcalloc(ocelot->dev,
-				     ocelot->num_phys_ports * OCELOT_NUM_STATS,
-				     sizeof(u64), GFP_KERNEL);
-	if (!ocelot->stats)
-		return -ENOMEM;
-
-	spin_lock_init(&ocelot->stats_lock);
-	mutex_init(&ocelot->stat_view_lock);
 	mutex_init(&ocelot->ptp_lock);
 	mutex_init(&ocelot->mact_lock);
 	mutex_init(&ocelot->fwd_domain_lock);
 	mutex_init(&ocelot->tas_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	spin_lock_init(&ocelot->ts_id_lock);
-	snprintf(queue_name, sizeof(queue_name), "%s-stats",
-		 dev_name(ocelot->dev));
-	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
-	if (!ocelot->stats_queue)
-		return -ENOMEM;
 
 	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", 0);
-	if (!ocelot->owq) {
-		destroy_workqueue(ocelot->stats_queue);
+	if (!ocelot->owq)
 		return -ENOMEM;
+
+	ret = ocelot_stats_init(ocelot);
+	if (ret) {
+		destroy_workqueue(ocelot->owq);
+		return ret;
 	}
 
 	INIT_LIST_HEAD(&ocelot->multicast);
@@ -3552,25 +3364,13 @@ int ocelot_init(struct ocelot *ocelot)
 				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
 				 ANA_CPUQ_8021_CFG, i);
 
-	ret = ocelot_prepare_stats_regions(ocelot);
-	if (ret) {
-		destroy_workqueue(ocelot->stats_queue);
-		destroy_workqueue(ocelot->owq);
-		return ret;
-	}
-
-	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
-	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
-			   OCELOT_STATS_CHECK_DELAY);
-
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
-	cancel_delayed_work(&ocelot->stats_work);
-	destroy_workqueue(ocelot->stats_queue);
+	ocelot_stats_deinit(ocelot);
 	destroy_workqueue(ocelot->owq);
 }
 EXPORT_SYMBOL(ocelot_deinit);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 6d65cc87d757..37b79593cd5f 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -115,6 +115,9 @@ struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
 					struct netlink_ext_ack *extack);
 void ocelot_mirror_put(struct ocelot *ocelot);
 
+int ocelot_stats_init(struct ocelot *ocelot);
+void ocelot_stats_deinit(struct ocelot *ocelot);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
new file mode 100644
index 000000000000..f0f5f06af2e1
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Statistics for Ocelot switch family
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ */
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include "ocelot.h"
+
+/* Read the counters from hardware and keep them in region->buf.
+ * Caller must hold &ocelot->stat_view_lock.
+ */
+static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
+{
+	struct ocelot_stats_region *region;
+	int err;
+
+	/* Configure the port to read the stats from */
+	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
+
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		err = ocelot_bulk_read(ocelot, region->base, region->buf,
+				       region->count);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Transfer the counters from region->buf to ocelot->stats.
+ * Caller must hold &ocelot->stat_view_lock and &ocelot->stats_lock.
+ */
+static void ocelot_port_transfer_stats(struct ocelot *ocelot, int port)
+{
+	unsigned int idx = port * OCELOT_NUM_STATS;
+	struct ocelot_stats_region *region;
+	int j;
+
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		for (j = 0; j < region->count; j++) {
+			u64 *stat = &ocelot->stats[idx + j];
+			u64 val = region->buf[j];
+
+			if (val < (*stat & U32_MAX))
+				*stat += (u64)1 << 32;
+
+			*stat = (*stat & ~(u64)U32_MAX) + val;
+		}
+
+		idx += region->count;
+	}
+}
+
+static void ocelot_check_stats_work(struct work_struct *work)
+{
+	struct delayed_work *del_work = to_delayed_work(work);
+	struct ocelot *ocelot = container_of(del_work, struct ocelot,
+					     stats_work);
+	int port, err;
+
+	mutex_lock(&ocelot->stat_view_lock);
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		err = ocelot_port_update_stats(ocelot, port);
+		if (err)
+			break;
+
+		spin_lock(&ocelot->stats_lock);
+		ocelot_port_transfer_stats(ocelot, port);
+		spin_unlock(&ocelot->stats_lock);
+	}
+
+	if (!err && ocelot->ops->update_stats)
+		ocelot->ops->update_stats(ocelot);
+
+	mutex_unlock(&ocelot->stat_view_lock);
+
+	if (err)
+		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
+
+	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
+			   OCELOT_STATS_CHECK_DELAY);
+}
+
+void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
+{
+	int i;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
+		memcpy(data + i * ETH_GSTRING_LEN, ocelot->stats_layout[i].name,
+		       ETH_GSTRING_LEN);
+	}
+}
+EXPORT_SYMBOL(ocelot_get_strings);
+
+void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
+{
+	int i, err;
+
+	mutex_lock(&ocelot->stat_view_lock);
+
+	/* check and update now */
+	err = ocelot_port_update_stats(ocelot, port);
+
+	spin_lock(&ocelot->stats_lock);
+
+	ocelot_port_transfer_stats(ocelot, port);
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
+
+	spin_unlock(&ocelot->stats_lock);
+
+	mutex_unlock(&ocelot->stat_view_lock);
+
+	if (err)
+		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
+}
+EXPORT_SYMBOL(ocelot_get_ethtool_stats);
+
+int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
+{
+	int i, num_stats = 0;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < OCELOT_NUM_STATS; i++)
+		if (ocelot->stats_layout[i].name[0] != '\0')
+			num_stats++;
+
+	return num_stats;
+}
+EXPORT_SYMBOL(ocelot_get_sset_count);
+
+static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
+{
+	struct ocelot_stats_region *region = NULL;
+	unsigned int last;
+	int i;
+
+	INIT_LIST_HEAD(&ocelot->stats_regions);
+
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
+		if (region && ocelot->stats_layout[i].reg == last + 4) {
+			region->count++;
+		} else {
+			region = devm_kzalloc(ocelot->dev, sizeof(*region),
+					      GFP_KERNEL);
+			if (!region)
+				return -ENOMEM;
+
+			region->base = ocelot->stats_layout[i].reg;
+			region->count = 1;
+			list_add_tail(&region->node, &ocelot->stats_regions);
+		}
+
+		last = ocelot->stats_layout[i].reg;
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
+int ocelot_stats_init(struct ocelot *ocelot)
+{
+	char queue_name[32];
+	int ret;
+
+	ocelot->stats = devm_kcalloc(ocelot->dev,
+				     ocelot->num_phys_ports * OCELOT_NUM_STATS,
+				     sizeof(u64), GFP_KERNEL);
+	if (!ocelot->stats)
+		return -ENOMEM;
+
+	snprintf(queue_name, sizeof(queue_name), "%s-stats",
+		 dev_name(ocelot->dev));
+	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!ocelot->stats_queue)
+		return -ENOMEM;
+
+	spin_lock_init(&ocelot->stats_lock);
+	mutex_init(&ocelot->stat_view_lock);
+
+	ret = ocelot_prepare_stats_regions(ocelot);
+	if (ret) {
+		destroy_workqueue(ocelot->stats_queue);
+		return ret;
+	}
+
+	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
+	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
+			   OCELOT_STATS_CHECK_DELAY);
+
+	return 0;
+}
+
+void ocelot_stats_deinit(struct ocelot *ocelot)
+{
+	cancel_delayed_work(&ocelot->stats_work);
+	destroy_workqueue(ocelot->stats_queue);
+}
-- 
2.34.1

