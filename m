Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4861F649
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiKGOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiKGOjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:39:07 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499D6460;
        Mon,  7 Nov 2022 06:39:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuZTMxuSE3DGv0q9+MJw0rQlw03oMmABqyvIFLk+wmgwrOX/bI4tdluz/J8GBrZnLVLCi94Qt0eCjIodGWNuEZ5osY3yJ2xKm8hoy8fI59c5l+DKY8angdDRC5u9uDG4kiAHKt3xaFn7RaciL/ZMUhX5GO5o3fTuq/qA8xhTN+VgEMoPDWilapMildaYAzNIqIqy+BoAwlDFfqDoWy7O4ithhpdUlD0sqVsFYNiQFvtEIL3K1/CTmf/8WrUPb9AJqtCD1iKdst6n+TyRArH/dVMx9OvFTrUGBkdqJiMIu7OK2KvN1ZZKRb2VL+Hnz1rW2cPOpLbHoE5D8fbvKetKeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKkFOHba/7wyF99Qm8WRBdJIHKC3++fDQAnGsKMf4CE=;
 b=X8qi9cd5lZjYXVrQEwx/p+dteTiSzdJS8xGmEmNGwg71llsRvzti/ADS5KuW16CBMD16BQq2BNw//F3S2U/8iKT8OhwmAkFtaf4VE8Xl5nEFmG/taa+bIvT0MBGl9aKm+46dXjic0JtBDFLDMiNOCNLB+aDwMFMgNHVbLGo4jtZTVqioZDBeBqBY6/tPF8VWQ4gJfDKCb9Yj6mPdCXyQsRBDYpgnL2dZVb0YID0ikJuUprA/dmbZR7/UKT2em4OereIgn/gvhmdz1NyHB5fRaIxb9EToucmxDSmPHcBTIN8wcZ8Quk9J+i2RiIFV5SoqwPyoLQ+QF+SmRgaIa9uS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKkFOHba/7wyF99Qm8WRBdJIHKC3++fDQAnGsKMf4CE=;
 b=j6+KTX9NxEo5YbZ9iEzpvVRTBT9MChglGK7JfGJE/sFuFmmU1NWfwfZrw7PM57A2HajJSYwUGaVyABNZkdrZ72Ch8RMw89PceHQNC6ufrKueL/gNuim8DXy56C3RliA8QJplBosuuplx1/iIP3qYiRpNoi6Aryh50YuzxerMMXY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8385.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Mon, 7 Nov
 2022 14:39:03 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 14:39:03 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 2/2] net: fec: add xdp and page pool statistics
Date:   Mon,  7 Nov 2022 08:38:25 -0600
Message-Id: <20221107143825.3368602-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107143825.3368602-1-shenwei.wang@nxp.com>
References: <20221107143825.3368602-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::34) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB8385:EE_
X-MS-Office365-Filtering-Correlation-Id: a7525b33-1ef1-4c06-3aa6-08dac0cdd0c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRrpZCSciBXCMw2rfjINpubPulApRyShhviQ20vajhrxgoO0BNIvELl2OyNqN3Y02oUijS4OmK4orYOw8HQAwR7eA/xcyZNpUhgJrupApJ0P7gDSU/ssUTC1/ODY701RJe9viiEIMLhrFQGjFSP3cLvZV91n5Z0lVZqM3H6NIjSw1ULlaVYcMqkS9rJgY6N5H5HZda30YdDvQvXQRw5E41OqsD7sIThJa7gKfeS1JR+JUThvppx0efEaNV+5kbkMyJXs/z3PIjtlTQbeHPPWIPUf1uQR+yYj6DdBMK0ay0fcZRYIUzPFn6Bsha83iytwBxYRQoL7sqA226IES4YD9IlaK63GuizUuVmc8I2xlrdw0m1a6a4Wqis/nDYBzkvVDN0VB3cgw0zso2UUzEH0rdUlm9581pdf0khJLrDXMuQMrVNS2qAEqq0//xfxHBnSKS75CtinZkp8zo/mCxoKpn3Xvq0I1sSkCBMa5Ly8o8GjGRUX216Y+nuozBNrk9P0yioJrAMmJC4G5Mv7gCII5m8W7+TN71ZfrlLTdkjK3J4hAwkKnfJQ9x8T7nOVJs+wZTNAvNgF/jhtB1wIoJ87N0alnW6el8OCsUU4VtQbnIB/bbSiJuiNwW7EnBf7QLorCJSdgaXN5K99KulZVNfo2s84mFyUPVmd7ZSg7PJGSCcFyfKc3TfdCqaMcNCgh1i9dQlLD8TvHbyagWC/+ssAykOtc8eH+yzXEFeiLGrMsktBO/yd1x3LDD8hFxiUQjLO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(2906002)(66556008)(66476007)(8676002)(4326008)(66946007)(83380400001)(55236004)(52116002)(6666004)(6506007)(478600001)(86362001)(6486002)(2616005)(1076003)(186003)(316002)(6512007)(26005)(110136005)(36756003)(54906003)(5660300002)(8936002)(7416002)(38350700002)(38100700002)(41300700001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rLVB8nULxjHkhhGWYfahL1Kac4O6tz9gyVI1yy/lEAtd1kg9w+Z96vbF6e4W?=
 =?us-ascii?Q?CeXkVxgRm6C5xBYS5JoaiFK8IayJ1x8xPqHp4/a+iLP8s+swosg2UjUL422z?=
 =?us-ascii?Q?Ez3vhoy/l1aJ1UbLvrjfgtE4ZXVenCdJHFytvhEL4HDt3LeKVwLwD2AgRblo?=
 =?us-ascii?Q?TtFJ7JtLVMGLL6VB6Wi54FNfCRgcaWsEoJWF29SFEIntUO7Wyg8zzdSCBe+V?=
 =?us-ascii?Q?fFvtUw5/yXlMtQuXRDAgT5QBWXi84TYujGf/2vnfrcLyELsxNpbiFrV16Qyi?=
 =?us-ascii?Q?2tYpyYltZGgSRETX0x68PWBeXI1hQhoh4HZDQ6PEbn3HhOXHxJxMMKCQM2O8?=
 =?us-ascii?Q?pzdiUOMJfAtJ+yZQmF6GFKy9nHlDi9t0DycrILeuBwzXv6F4n9719D5xXwBM?=
 =?us-ascii?Q?h3zUttgk0oQ0CiVv+xt7pT0EB84g1EsT7WGivU0b0GeMg2QYXvzuELCmnRl/?=
 =?us-ascii?Q?eIdoZ9dIJEB+EfyydA5MvdHlyHZW5vCGApNooDfvjF5kCNXesj1lmHrHNc5f?=
 =?us-ascii?Q?zF3AiXhzSyz7dbdbuCczUYZcC7MqaBvUQWSpyDy/0L73e8gGr83kqDoT6+kC?=
 =?us-ascii?Q?WpkekOZGBTZN9Za3r1ioINiUNP4Mt3+DDDlPXr0CjRIarSMORf2AcTg51Rb5?=
 =?us-ascii?Q?x+l1uLQYrjE2wEkCUis6aGndOQbv4FwD3tZa/BBSlrV10oN0DuCw3+Tdq5CY?=
 =?us-ascii?Q?UJNTaXPEGG9SOnXMwYG/cU0jHWLr30ll8EInBGuwQVHQk8E2UYcAEQ5Q410a?=
 =?us-ascii?Q?GHJD+C0pby1SKicOOXHVtiqRVlMmnnwlZdmBJDR4fP9qgbPTBsS52F20lSlS?=
 =?us-ascii?Q?dHRGB6C/QVXBErL7q9od9Y220Fg/hpJmuUKPNrLajPq/4c7aY68PhZ5u0HW0?=
 =?us-ascii?Q?WopqS/J08L30WZ37P9kmNI2f5Ab9W6lKuWBQ85xkKvBxrjD9umsf3UGvqnwp?=
 =?us-ascii?Q?OzxbotOazr5hcPDUpsEdjOohFO+8rzw//sTKU8M5P6anfVU/frYYHpe7aEpT?=
 =?us-ascii?Q?K6XKLWGdaapuF+9TBa8vFXgMT1EudknOJjzIhntp1KsA8GxAryJJysnXlG7l?=
 =?us-ascii?Q?N6tekJ/Ua+yqElXkVlm6tqm9rzai4DgfIbgl4UPD7eQ5vD7kuBOwordnWGtG?=
 =?us-ascii?Q?GVGGUdrWO3ip6osHVne+qvjxRqBuoNqIPzMl+iXjbs8AMDFp3MrkMgLzuD/4?=
 =?us-ascii?Q?aDM+9XeIBV7WrN/AaQzMH+mzZ4zSQxvede0SmznOD+CnsIehcc4bs9jnf7OP?=
 =?us-ascii?Q?P+S3u9Pao1tDbhVJ1qyPN11vazKnoCfTYWBLdW7fxqHf4vutrb/ZLJoMKdF1?=
 =?us-ascii?Q?OnVG+6OXdiB64QMzNngS2Lv53v0D46fycfXmSh0N8gwhEfDdGawtL6F/30Qj?=
 =?us-ascii?Q?WnruFtyxbJZREYVbFZxLKpI/iDuChdFS+y80JJPZSSpP1WuA8iWJRXHfdNJP?=
 =?us-ascii?Q?jYgvEkr+3ZQvDHrdXpj7cbdoVf6//Da3pNKPIgDUwh2qZiy0iARRFmpV8FHf?=
 =?us-ascii?Q?jh0FfaCzVBRAp5/PTn3KeEsPV5wQomglmNiv4i1C3YXnD+JSBd+hwBxDk2AH?=
 =?us-ascii?Q?jCD8o7N4bv02nxrQyhdpz1nT/2vtgXWDMU1X7FRk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7525b33-1ef1-4c06-3aa6-08dac0cdd0c3
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 14:39:03.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IW3oxEdEIHayPl4Jq1H5wFRdwUfYSJaMDcGwoKkruU8bxSjOX7WQmbgoOKFKzrh/89tZ06WL8CG6FsuB0s984w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8385
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
---
 drivers/net/ethernet/freescale/fec.h      | 12 ++++
 drivers/net/ethernet/freescale/fec_main.c | 70 ++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 61e847b18343..e3159234886c 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -526,6 +526,17 @@ struct fec_enet_priv_txrx_info {
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
+	XDP_STATS_TOTAL,
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -546,6 +557,7 @@ struct fec_enet_priv_rx_q {
 	/* page_pool */
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	u32 stats[XDP_STATS_TOTAL];
 
 	/* rx queue number, in the range 0-7 */
 	u8 id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3fb870340c22..89fef370bc10 100644
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
@@ -2657,37 +2660,91 @@ static const struct fec_stat {
 	{ "IEEE_rx_octets_ok", IEEE_R_OCTETS_OK },
 };
 
-#define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))
+static struct fec_xdp_stat {
+	char name[ETH_GSTRING_LEN];
+	u64 count;
+} fec_xdp_stats[XDP_STATS_TOTAL] = {
+	{ "rx_xdp_redirect", 0 },           /* RX_XDP_REDIRECT = 0, */
+	{ "rx_xdp_pass", 0 },               /* RX_XDP_PASS, */
+	{ "rx_xdp_drop", 0 },               /* RX_XDP_DROP, */
+	{ "rx_xdp_tx", 0 },                 /* RX_XDP_TX, */
+	{ "rx_xdp_tx_errors", 0 },          /* RX_XDP_TX_ERRORS, */
+	{ "tx_xdp_xmit", 0 },               /* TX_XDP_XMIT, */
+	{ "tx_xdp_xmit_errors", 0 },        /* TX_XDP_XMIT_ERRORS, */
+};
+
+#define FEC_STATS_SIZE	((ARRAY_SIZE(fec_stats) + \
+			ARRAY_SIZE(fec_xdp_stats)) * sizeof(u64))
 
 static void fec_enet_update_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
-	int i;
+	struct fec_xdp_stat xdp_stats[7];
+	int off = ARRAY_SIZE(fec_stats);
+	struct fec_enet_priv_rx_q *rxq;
+	int i, j;
 
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		for (j = 0; j < XDP_STATS_TOTAL; j++)
+			xdp_stats[j].count += rxq->stats[j];
+	}
+
+	for (i = 0; i < XDP_STATS_TOTAL; i++)
+		fep->ethtool_stats[i + off] = xdp_stats[i].count;
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
 }
 
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
 				       struct ethtool_stats *stats, u64 *data)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
+	u64 *dst = data + FEC_STATS_SIZE / 8;
 
 	if (netif_running(dev))
 		fec_enet_update_ethtool_stats(dev);
 
 	memcpy(data, fep->ethtool_stats, FEC_STATS_SIZE);
+
+	fec_enet_page_pool_stats(fep, dst);
 }
 
 static void fec_enet_get_strings(struct net_device *netdev,
 	u32 stringset, u8 *data)
 {
+	int off = ARRAY_SIZE(fec_stats);
 	int i;
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 			memcpy(data + i * ETH_GSTRING_LEN,
 				fec_stats[i].name, ETH_GSTRING_LEN);
+		for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++)
+			memcpy(data + (i + off) * ETH_GSTRING_LEN,
+			       fec_xdp_stats[i].name, ETH_GSTRING_LEN);
+		off = (i + off) * ETH_GSTRING_LEN;
+		page_pool_ethtool_stats_get_strings(data + off);
+
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2697,9 +2754,14 @@ static void fec_enet_get_strings(struct net_device *netdev,
 
 static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
+	int count;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(fec_stats);
+		count = ARRAY_SIZE(fec_stats) + ARRAY_SIZE(fec_xdp_stats);
+		count += page_pool_ethtool_stats_get_count();
+		return count;
+
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2718,6 +2780,8 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);
 
+	for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++)
+		fec_xdp_stats[i].count = 0;
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
-- 
2.34.1

