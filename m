Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C608B625E72
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 16:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiKKPf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 10:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiKKPf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 10:35:27 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3301DDF60;
        Fri, 11 Nov 2022 07:35:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1Pf1Cf5ZOuEg/tUA7VaMxeXdgiN1iq8JgsjoRObHXSqIdEuXfFCsXcO056yOLU2doFTv5lw2al9SQXOj5WqbvDXygDaI8JNpIjwLdu9FLX2v0GYED42mQzwkA6JPf/LF/zPDrdPDxAgV3wq+1PE9MwTPePcRdFw2IG3M2T8vSLD8UMKlW8i3DvYx/fiUZR52R3NfR5+1P6zAhMHCc89QX9DFxbrsPl0tTJhcCKf2Ji7vBQBwVLY2agwNVhlJ7K9h0YJZLmem/E0dHPyfGKB7zOxDdawCkqBs4mQpNx4eXmgexymioOvMhIekym44/GbKA6JhVIAe4yX9AvDQ3K7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zaverlrmz9D2s+LY2jz8pXhIGP+SQxVmyToq8RrYgnM=;
 b=gAUDgwWNQZh1aPJGmI2LYBWxOkWJ/ainyXDDK92T/yXZroHbngF0qaYk0NHp1/v/d8oHxIRaBguqDSaqgbtSJV36hwFXDcVUUezYXl2PVR5bJA7Zj9aKW9d1JLPoGYlBZpfZTMBTBOj7I1a6W0gjIfGQOCgvwvRC3/X9uu94hF6Z5vxTf/RLOEd6fPTQrUbmdufW0DO1FImz6hxaUWBifHrbinPeUWmG1rAzhX5eaywlsR7YqGIpvi3fsZ3H5pVYp22Tlmz74c6cxlUdfS58CSSmdyURPDunqiTzT1XD+4GoNWFtKnMOq4yPFs+M5xdRxlMbSWDGlBKD5NZ2bQCCDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zaverlrmz9D2s+LY2jz8pXhIGP+SQxVmyToq8RrYgnM=;
 b=MVzeszlttS4nGDJX7URRWPY2bpcUoUP3Fbahi4YC7ouvwb2GsEbGClqbfBTihC0JC0//NzppsFktI1mj6U9gvbP3Plwod0qvaM5AFc2kDmAdIyYgkI3MsvE+IU+ZE+GQlgb9293v/8TtV7BQ5wB65b2EoX2K+nW1kvSfEYUfRss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM8PR04MB7890.eurprd04.prod.outlook.com (2603:10a6:20b:24e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 11 Nov
 2022 15:35:22 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 15:35:22 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
Date:   Fri, 11 Nov 2022 09:35:05 -0600
Message-Id: <20221111153505.434398-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::26) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM8PR04MB7890:EE_
X-MS-Office365-Filtering-Correlation-Id: dc793eb7-434d-42eb-1e72-08dac3fa58b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: seVO5TjBRXLTPh6QXgLHqf/zOGnoCrRGGmOqTSkh9TDweXm0Bsx6zwbjkqhmzS6JyoxQjUnnvx1gdMTBijkRCiVnwUe5V7qwyYGakjwRu5G6lSOSj0FvlyKS7LBR+Z/RmEeU60ci8WiGwmuuiBBBRSfAJXFLHDZcBne/s61pa0jVCqE11reTsBEfHiBrvliFjxYCCHfZIQM5/TJx/DBQTXtg/PKvzmjdyF32ZThzyZmkeESEpBqWfVdzghcTE9aKWYPb75AfMYlJORsdDGKir0vIBvvv0GPocdbUqHqvXWvxvxUEGLcE30cZneJyZBGLjXgAAzVrji7w0Up5m9ICbQrBLXLIRXWIEaEkiH95rdr/vclDuiaRSMBxj12veRlg3C4RFyRks1079t9Ble72sGmP3FQTLNyAec3s+Xxa5mQQroltcJkhufwktTiN/SrkJ2bYRRa8tvVyoq08Cv4T0ERgsqmJwSBAzi26oY6HzQWBmQhK46qflkNwIKDDVtPrxEULl7mH6IvoqqNtbj12GeEloS6VGfk+rLKZ2xDuSt8CwfQPxPj26oogWMY0cUvhISN/3H/qN78h0gZHrpYfERz+nc/k+fWbFdsGw3N8cS9Qg9ioy3u81kqQY6zWT2c/xFVLW+7zRC8UJ6bdaAsp7smhlCbw3df0rzvZDMtlFGTtOwqBuyhMNh0OIBthH+4IoKQc1oFACxbuPJ0+qLPELbn9Z+fPLVkiYie7tFRSJSVtS5OCrQPGUAbK1lFwqDPd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199015)(36756003)(38100700002)(44832011)(2906002)(8936002)(4326008)(5660300002)(7416002)(38350700002)(66946007)(86362001)(83380400001)(316002)(110136005)(54906003)(2616005)(6486002)(478600001)(186003)(66476007)(8676002)(41300700001)(1076003)(55236004)(66556008)(6512007)(6666004)(52116002)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S+F8CGIdXyLiOkbUR65S1I7vUoNDK1zHoIFZOjprPqZp23poz2OISeT5OYAi?=
 =?us-ascii?Q?VmPNMgvFgErxZf1OHLhJDU1M3CqpsR7dLtKh4SDjNEWvBMQo4nhBYXE0DGOZ?=
 =?us-ascii?Q?RThha2xFJfDNqtMVWZGQIkZY7tyNaOYOb1q8CQ3WIaZd56oPZ9wDoDg3kaR8?=
 =?us-ascii?Q?6c+3bUffh753jTcc9BRCToLcW66KqaiS6xFnIvuA8KcZwpbIhhLLSiKhHbJf?=
 =?us-ascii?Q?Yb1GBWoLFJtLt7PEE07VFE4LBSdAyRU89eQBXo9VPrErw2A1F88usJddUU5y?=
 =?us-ascii?Q?D9dARIONpA/gPcEevwKG4T0eBQlhV/TNoCOqNS3KAfLJ9MG05/EvTuocLDbE?=
 =?us-ascii?Q?jMdnewBHW1nNUmjtZpbis+cFjww4AhfVR+fkQIvDeu5BCFF4GLRk92XIVYpP?=
 =?us-ascii?Q?w47q4YzwLmRtV0sPiMkyeDX0e9pirX8KfG9am5e5JSA8ZP8FC+IhCxpLeiN2?=
 =?us-ascii?Q?JEyOfmKxwNejPaJb1NiLnJh2iB1+P94NJtD359E/nE8EQ8rIjYClXzYcdDey?=
 =?us-ascii?Q?QJeh9676FaYB0Xce2AAvMWNDE2c7OSqdwCHc18HzP7V0RjtKn1mu1L9t6Sk7?=
 =?us-ascii?Q?JF/So+ImqQe1Jnd4Zbu8MD0+8hbFRD0z9tT51YQYHyCmkKZfKo2Nx0ipEK+o?=
 =?us-ascii?Q?cjEKZQLfmNJHbgp8JQb5+TRkvdgKbGSQQI/Xdt8G8w+bhlMxubPMlIWJCIXS?=
 =?us-ascii?Q?pRZRVnFrqP1wsa1pxEeiMsdoXUoXCL4b7QlVfGeVEsrs9fa6G/WnTaEPd+Js?=
 =?us-ascii?Q?Ym/w/nYzt+bSEwjW9G2J2rpIf3/cQWv/6lLWi3BuOhpMB9830ja34rkswk1F?=
 =?us-ascii?Q?aHN91nEwPZaGkJJttKBY1+8mSUjQxWqOxcL+2jhPFxjqUmmL2jMYpv/1tIE2?=
 =?us-ascii?Q?Q4rFiTaYQ7bQrrtV5q6AQiNuxWqqQRAHXJtapm7lYBSkVoogwM0d24gU+Gan?=
 =?us-ascii?Q?hh857QQBx7zQL0cxEtjW4Huo7abc+BLKJfWMjajwClCSLg8IvqeyJ70sXfI5?=
 =?us-ascii?Q?wM8kKf22swf0SAdCJ45Ly0Nlu+gnOIk9s/W5KQDPkc22F21YY0q5eiHj6Fkk?=
 =?us-ascii?Q?lh+D16C6rs/xxjJzn7KqHBEwV6/XksXzY3SrwrW0cfF+HXKaycDVzNo/smAk?=
 =?us-ascii?Q?7MIu9kziO3xLKuRPI8FAInODYteDCC1F4fllzW+AyYWfGneIKwNQ0BO/IiUe?=
 =?us-ascii?Q?K4uA0CYn5TSj6HaOTdIwzSEu8DDgbyXGIKMI3ssZu+jsLJ/d233Tb9NOr7jn?=
 =?us-ascii?Q?iwUpOOBtPcvIjGImiQ0eOdcY4//NrpneHkaBV1UPcxyw3VZuXjHsN8opnqLo?=
 =?us-ascii?Q?/bWuiROMhY+U5qwxPIPGqqsXpg3xKH8FxnPr6gljDK5LDWzwmbThssj1G9E/?=
 =?us-ascii?Q?6mmPX2vkdB2xDm2Ny0snxuVcCvuaGwzOoAM3M3cWW9Vb5Vp/M5cSZcFclRTG?=
 =?us-ascii?Q?kBV9Bk8tMqF7d3bWFAItZZYHtoxAXmgtDuqW2tMi6Jffter7bXpEcPEKmTYJ?=
 =?us-ascii?Q?pLxmeOUpX0TntEoQtHZrZRSvHK2AT90G1oSmDeO8yjwaDIDk8kaiyw1ULthw?=
 =?us-ascii?Q?yk2LEUua1WjqMVtPXR67YfqVEWZm984Z3hzpaggR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc793eb7-434d-42eb-1e72-08dac3fa58b2
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 15:35:22.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0Vd++9ob96WFMIwXSRXYxUNevYTbX+XPlcv1fWT45NLbeXfblOiYljpwRsACR9VCQkZZGzH2gOFlGfE4hTUlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added xdp and page pool statistics.
In order to make the implementation simple and compatible, the patch
uses the 32bit integer to record the XDP statistics.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 Changes in v3:
 - change memcpy to strncpy to fix the warning reported by Paolo Abeni
 - fix the compile errors on powerpc

 Changes in v2:
 - clean up and restructure the codes per Andrew Lunn's review comments
 - clear the statistics when the adaptor is down

 drivers/net/ethernet/freescale/Kconfig    |  1 +
 drivers/net/ethernet/freescale/fec.h      | 14 ++++
 drivers/net/ethernet/freescale/fec_main.c | 85 +++++++++++++++++++++--
 3 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index ce866ae3df03..f1e80d6996ef 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -29,6 +29,7 @@ config FEC
 	select CRC32
 	select PHYLIB
 	select PAGE_POOL
+	select PAGE_POOL_STATS
 	imply NET_SELFTESTS
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 61e847b18343..5ba1e0d71c68 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -526,6 +526,19 @@ struct fec_enet_priv_txrx_info {
 	struct  sk_buff *skb;
 };

+enum {
+	RX_XDP_REDIRECT = 0,
+	RX_XDP_PASS,
+	RX_XDP_DROP,
+	RX_XDP_TX,
+	RX_XDP_TX_ERRORS,
+	TX_XDP_XMIT,
+	TX_XDP_XMIT_ERRORS,
+
+	/* The following must be the last one */
+	XDP_STATS_TOTAL,
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -546,6 +559,7 @@ struct fec_enet_priv_rx_q {
 	/* page_pool */
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	u32 stats[XDP_STATS_TOTAL];

 	/* rx queue number, in the range 0-7 */
 	u8 id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3fb870340c22..d3bf3ffe8349 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1523,10 +1523,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,

 	switch (act) {
 	case XDP_PASS:
+		rxq->stats[RX_XDP_PASS]++;
 		ret = FEC_ENET_XDP_PASS;
 		break;

 	case XDP_REDIRECT:
+		rxq->stats[RX_XDP_REDIRECT]++;
 		err = xdp_do_redirect(fep->netdev, xdp, prog);
 		if (!err) {
 			ret = FEC_ENET_XDP_REDIR;
@@ -1549,6 +1551,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		fallthrough;    /* handle aborts by dropping packet */

 	case XDP_DROP:
+		rxq->stats[RX_XDP_DROP]++;
 		ret = FEC_ENET_XDP_CONSUMED;
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(rxq->page_pool, page, sync, true);
@@ -2659,6 +2662,16 @@ static const struct fec_stat {

 #define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))

+static const char *fec_xdp_stat_strs[XDP_STATS_TOTAL] = {
+	"rx_xdp_redirect",           /* RX_XDP_REDIRECT = 0, */
+	"rx_xdp_pass",               /* RX_XDP_PASS, */
+	"rx_xdp_drop",               /* RX_XDP_DROP, */
+	"rx_xdp_tx",                 /* RX_XDP_TX, */
+	"rx_xdp_tx_errors",          /* RX_XDP_TX_ERRORS, */
+	"tx_xdp_xmit",               /* TX_XDP_XMIT, */
+	"tx_xdp_xmit_errors",        /* TX_XDP_XMIT_ERRORS, */
+};
+
 static void fec_enet_update_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
@@ -2668,6 +2681,40 @@ static void fec_enet_update_ethtool_stats(struct net_device *dev)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
 }

+static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
+{
+	u64 xdp_stats[XDP_STATS_TOTAL] = { 0 };
+	struct fec_enet_priv_rx_q *rxq;
+	int i, j;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		for (j = 0; j < XDP_STATS_TOTAL; j++)
+			xdp_stats[j] += rxq->stats[j];
+	}
+
+	memcpy(data, xdp_stats, sizeof(xdp_stats));
+}
+
+static void fec_enet_page_pool_stats(struct fec_enet_private *fep, u64 *data)
+{
+	struct page_pool_stats stats = {};
+	struct fec_enet_priv_rx_q *rxq;
+	int i;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		if (!rxq->page_pool)
+			continue;
+
+		page_pool_get_stats(rxq->page_pool, &stats);
+	}
+
+	page_pool_ethtool_stats_get(data, &stats);
+}
+
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
 				       struct ethtool_stats *stats, u64 *data)
 {
@@ -2677,6 +2724,12 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
 		fec_enet_update_ethtool_stats(dev);

 	memcpy(data, fep->ethtool_stats, FEC_STATS_SIZE);
+	data += FEC_STATS_SIZE / sizeof(u64);
+
+	fec_enet_get_xdp_stats(fep, data);
+	data += XDP_STATS_TOTAL;
+
+	fec_enet_page_pool_stats(fep, data);
 }

 static void fec_enet_get_strings(struct net_device *netdev,
@@ -2685,9 +2738,16 @@ static void fec_enet_get_strings(struct net_device *netdev,
 	int i;
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-				fec_stats[i].name, ETH_GSTRING_LEN);
+		for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
+			memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+		for (i = 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
+			strncpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+		page_pool_ethtool_stats_get_strings(data);
+
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2697,9 +2757,14 @@ static void fec_enet_get_strings(struct net_device *netdev,

 static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
+	int count;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(fec_stats);
+		count = ARRAY_SIZE(fec_stats) + XDP_STATS_TOTAL;
+		count += page_pool_ethtool_stats_get_count();
+		return count;
+
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2710,7 +2775,8 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
-	int i;
+	struct fec_enet_priv_rx_q *rxq;
+	int i, j;

 	/* Disable MIB statistics counters */
 	writel(FEC_MIB_CTRLSTAT_DISABLE, fep->hwp + FEC_MIB_CTRLSTAT);
@@ -2718,6 +2784,12 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);

+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		for (j = 0; j < XDP_STATS_TOTAL; j++)
+			rxq->stats[j] = 0;
+	}
+
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
@@ -3084,6 +3156,9 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 		for (i = 0; i < rxq->bd.ring_size; i++)
 			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);

+		for (i = 0; i < XDP_STATS_TOTAL; i++)
+			rxq->stats[i] = 0;
+
 		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 			xdp_rxq_info_unreg(&rxq->xdp_rxq);
 		page_pool_destroy(rxq->page_pool);
--
2.34.1

