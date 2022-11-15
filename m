Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5BD629E4E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbiKOP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiKOP6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:58:42 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0A42700;
        Tue, 15 Nov 2022 07:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbM39w1Zc51IRsfPUE6GwNukMPD7BjVllGUxg6Zi37FZW+uyohGgWRuSct2SrNcu8IfxCkSEX5XhOdujEYR9+K5haSFdXdyh0OBes8S0vaIUmfSMYUaRDxAFsQRnd8zSXDT/fUdTrSn41V6dyEhvH0liCADUiFbzB0Co3FRsXhGoifAgzi9M9OVXsbi9YNgnphoFKvNCrrYVziBBIKzuC4djmT6zZDLXdVF1Z/rUyLyM38FetgEuFdM/PlQPPUw7WCukD3KyiRfxV0XQAUnvCqttqwgCwg/HirRsK47BeKDbuwqzZqKMEUYV3IwfxuXLftgWsIMG+WJ4dze9532VwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rj6CpXsQDirCu5nSi29mpRNvvXjf/13WMKXtJ6W3c+o=;
 b=J0bcmVka2PXZYvbfEI3EvBVvwE6ynZGr8QJ6GEMzAAm6eEyenVCWDS1rL779s/Eh+xvJg1oWrNY+0QSAtPW93+UJwhC4ZwMTnyHIm1Ug4fgUBIOtbcnD+XcDBAFzKf96DSR0+csBHSIzwZKKPcoWx/d6iKFV/I1rP37oFLsVf4S8Shzgmge14sM3MEKu9jRRpfbRg3qy5ZefaYNpZNyLXO9+2HQwfGqM7jDSHxXiTjeAserabYzsOC7E+rkD/IoptM3mVs/2u+KnQHvKvfOgUk9C49JMGOrc4V9pJIopwMaYexrAdBfIA4sX5I12mfY6eT287THXVro8PSLyUyuyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rj6CpXsQDirCu5nSi29mpRNvvXjf/13WMKXtJ6W3c+o=;
 b=q2o5KMcWCoJWcv3CkhU6gVikMNq6p2y31cuveK2RN5MBYAgudmu6eSrcPSoAYWoKpaVEuXy16hBisgMcDjRgg8ZHbzSX/XYRtfxT8aiQSq6Nmcy8UWme708QLb4H/WqhiY+KdAS94tPLeXGbWZbl59L997sbhUCLFAGyQ8R00tQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBBPR04MB7690.eurprd04.prod.outlook.com (2603:10a6:10:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 15:58:24 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 15:58:24 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 2/2] net: fec: add xdp and page pool statistics
Date:   Tue, 15 Nov 2022 09:57:44 -0600
Message-Id: <20221115155744.193789-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115155744.193789-1-shenwei.wang@nxp.com>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0083.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::24) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBBPR04MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: fb95db40-7432-45ba-839c-08dac72239fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPXh6PouErTlMlqXmvYQ2q3kaWILAmYUx6jBDCGr92IbVnWtcmLHrzvxORkxGcjy9bQKIRWX+pZw0ydnv+EzoXg1YPXC2OFiMuRKL77P7Nf+mKZRTtYmiZneEC48HYV7pdbC5laZX8MMsGY3+pxUFPA/XK82RbIyKoNNcZIBVVwVhEoBWQ9ebzk0NK8Wj4YRgwt6wmv5CAUySof//LrOmz+Xs25cZzVGiC9ZQokqerkMs6gx2Dh9/zwZQZKvAzyUv1+/YZegHwYtOwRModyr4sWqDdx0RVdOI0FBq6fQd7IZGawmG5z68m42qfeR3623HMrKPoam+5WsJgmqybEKsO+zjYQlnJAE7YRwyQYf5w/1e6evJRADMa3U/DZcnPbfkWXNhwiaQ1DcgUVFkEeJIsbC1k5BSZyEvq7gp1pMKr/LvNU/xyotTZqCMbuG8uT4xDZYHkOZc2gm9Be53vIk7Gr3QeT6HVOhwwf74F/FWz+7mpJOmCOWVjyfwwjx9hrbciQkybuNrrEmd8brFjkDN53UohYpTyuFBil0CUvi3jfHhfloAngbdTdijPIvbMXV9WT//ft3g4u+ZhfaWSRTseyBsNal+qjwQ/kTn+92HNZbJCPCcIe+ixit+Fcj9dyz5gBNS6D/1leL4d26njuGnziLbknnXGOVcfkyejR4ooBgqjLBIxCuwe8/agxrAML+IbfxqVB9fU+wxooD6nR+GkjkQV3+GJVIWEX+8F9dOoxobBSie0JW8i0wD7REcGRN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(6512007)(186003)(83380400001)(26005)(86362001)(2616005)(38350700002)(5660300002)(38100700002)(7416002)(2906002)(44832011)(41300700001)(8936002)(478600001)(52116002)(55236004)(6486002)(316002)(1076003)(54906003)(110136005)(66476007)(66946007)(6666004)(6506007)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MVXfFengyfM4VK6c34f+O2rHMs+aID5vPbToHB1CxHycVrC1jTjtcWWJKXsI?=
 =?us-ascii?Q?q2lLAsFo91IYjAz9djo53WYeEKkZU9uQNaS7DmfW9Ks6A8p4CNI3cMCsjZN5?=
 =?us-ascii?Q?wzD+cbm1yfhDAgd+fsPJiLzWYlNDkL7jXMO8iNp0YPq7av9osyw+l7v9cDl2?=
 =?us-ascii?Q?0XKAKC06DJYUk7rI48RpeClyrFuKQDtiIkApCMf1hhmJVWAaufPz4fUP+2oz?=
 =?us-ascii?Q?OacD0TWQ38dbO98xjruZqx+6XqHGSaOS/hh/oq+gbzpYCTGLfyCX+2DtvzyY?=
 =?us-ascii?Q?G+4kgKZ4vsML8hj2XJgMRK223DoHoO+b6SXT7pvMKynZk5ao6VEAVJ9GYcO3?=
 =?us-ascii?Q?OKCE2qlv53XOkCXdMKIbFrGhlIpJCv//WokKQZM0EodoRFYwCk4OUsNp+wIQ?=
 =?us-ascii?Q?AUL3K56wF+Fo0O4ES4o6XO2xcZ7h3kPo87gC8zozjI6MA4rOCVZtSaFLIPNh?=
 =?us-ascii?Q?CoOUKFVAwYFL1YiWX4Yz/tlZlyHON43Q2k666wFf132F+ZKx6xeXJ2DkyrAa?=
 =?us-ascii?Q?7xhLnJ8kT57mBGQClUHEapmhdlibgbSIKjtxXN9MCEsnnGr2KMXB9WThYKgZ?=
 =?us-ascii?Q?rLUFzcUGh5HxAiKEC8MF1uSciZcLGenmhL8piu+JcGs4PHz6Ire/NW6ijn8+?=
 =?us-ascii?Q?9Ad07kyXAsA0Z2FwERucGb+qKh9wOCs+iPBk/KNC69ZCOb08D3B3MMkzuVYJ?=
 =?us-ascii?Q?X/0Xyb0d5I4miBeTpwt0vQfysfULjY1B5EHyFR14vHDucUk6ieqXagIvT6Q5?=
 =?us-ascii?Q?uTDV4LC7rl4q/YO2hkl1w9KO7TfX00GCI6BoMEEWT2yRRFYixSGw+auaQ9ak?=
 =?us-ascii?Q?p8U5LjQkoXSfzUvpMp8/Boa770G6aShCFFGJIWicq9zdyqAaQ7TeoXevVHL0?=
 =?us-ascii?Q?5596M/O0Liqj5oRd1Z+uOTipxTQzhyNcWm938W+UmsO7qEp0mMqVmswrT1Hc?=
 =?us-ascii?Q?xVus8EjXTKBUp4pCePgP87Nst2WuASOBHt08mxYFlVtla02xrlNQPYGPxSOt?=
 =?us-ascii?Q?9qhnpMzcfNW1D0QFO7HUfrl2VBHSr4OnmaKTcYlTMPsrlkHQ9Ftjjoq6zRP4?=
 =?us-ascii?Q?Cu3FDuPbRKQaXBQcvbvxCRbQwwqfboiPujcUy5wDjKnZrTUsJUwoHl9bZ06o?=
 =?us-ascii?Q?vyuNVrAYcWip02QgNhb32kkyXnqYAP15zWtrYvqnr1Y7Sb9bqKvUwHoax73u?=
 =?us-ascii?Q?n2PzBMeOZMBSjFTa7iKDz4/5NOhHFReYQTo97E07Iid5UIdN2cfhhSkPmRDR?=
 =?us-ascii?Q?K4qciZYgSO7LJaDwq6dPGOtedqZ6IcwU72Bm3AlY2Uv8Ti1ck4jHbCgmfK4i?=
 =?us-ascii?Q?R6Ht+NuQfssWNZ/rWjC2EF+mv1tI7wBcO/UVAyAnW72yGhal3URFjPzlcQOY?=
 =?us-ascii?Q?3tF3rsgrK53Zq8QTqS7gNN9HrLo0OosDJVctx8lEUa41lzqYa9tbRElgpeTZ?=
 =?us-ascii?Q?IPJwM9lEmbB9t96MsnjtUjQcQwezyzbIY4uq4LlytPLJFhPgMsmYwSZpI6RL?=
 =?us-ascii?Q?r404s9covW0nyXBO5OX+EBsnwgWWsD63m+QNx0NXIMeA53V76UkkMFPML14a?=
 =?us-ascii?Q?aXU06K0wddxmHlqHiAoekBWShOErvJn1KJaGdGrY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb95db40-7432-45ba-839c-08dac72239fc
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 15:58:24.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RM1fbGDc9p0wba2aPtG5ATjhXmVg2S7ISCHjBc9O+UpF6u4mPchCj3Geucgr4DOFcjhlX2nivR5P7ukpkGsAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7690
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

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/ethernet/freescale/fec.h      |  15 ++++
 drivers/net/ethernet/freescale/fec_main.c | 100 ++++++++++++++++++++--
 2 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 61e847b18343..adbe661552be 100644
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
@@ -546,6 +559,8 @@ struct fec_enet_priv_rx_q {
 	/* page_pool */
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	struct u64_stats_sync syncp;
+	u64 stats[XDP_STATS_TOTAL];
 
 	/* rx queue number, in the range 0-7 */
 	u8 id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 616eea712ca8..4706cbc8ec5c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1507,7 +1507,8 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 
 static u32
 fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
-		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
+		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq,
+		 u32 stats[], int index)
 {
 	unsigned int sync, len = xdp->data_end - xdp->data;
 	u32 ret = FEC_ENET_XDP_PASS;
@@ -1523,10 +1524,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 
 	switch (act) {
 	case XDP_PASS:
+		stats[RX_XDP_PASS]++;
 		ret = FEC_ENET_XDP_PASS;
 		break;
 
 	case XDP_REDIRECT:
+		stats[RX_XDP_REDIRECT]++;
 		err = xdp_do_redirect(fep->netdev, xdp, prog);
 		if (!err) {
 			ret = FEC_ENET_XDP_REDIR;
@@ -1549,6 +1552,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		fallthrough;    /* handle aborts by dropping packet */
 
 	case XDP_DROP:
+		stats[RX_XDP_DROP]++;
 		ret = FEC_ENET_XDP_CONSUMED;
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(rxq->page_pool, page, sync, true);
@@ -1582,6 +1586,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
 	u32 data_start = FEC_ENET_XDP_HEADROOM;
+	u32 xdp_stats[XDP_STATS_TOTAL];
 	struct xdp_buff xdp;
 	struct page *page;
 	u32 sub_len = 4;
@@ -1656,11 +1661,13 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		fec_enet_update_cbd(rxq, bdp, index);
 
 		if (xdp_prog) {
+			memset(xdp_stats, 0, sizeof(xdp_stats));
 			xdp_buff_clear_frags_flag(&xdp);
 			/* subtract 16bit shift and FCS */
 			xdp_prepare_buff(&xdp, page_address(page),
 					 data_start, pkt_len - sub_len, false);
-			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
+			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq,
+					       xdp_stats, index);
 			xdp_result |= ret;
 			if (ret != FEC_ENET_XDP_PASS)
 				goto rx_processing_done;
@@ -1762,6 +1769,15 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	if (xdp_result & FEC_ENET_XDP_REDIR)
 		xdp_do_flush_map();
 
+	if (xdp_prog) {
+		int i;
+
+		u64_stats_update_begin(&rxq->syncp);
+		for (i = 0; i < XDP_STATS_TOTAL; i++)
+			rxq->stats[i] += xdp_stats[i];
+		u64_stats_update_end(&rxq->syncp);
+	}
+
 	return pkt_received;
 }
 
@@ -2701,6 +2717,16 @@ static const struct fec_stat {
 
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
@@ -2710,6 +2736,44 @@ static void fec_enet_update_ethtool_stats(struct net_device *dev)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
 }
 
+static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
+{
+	u64 xdp_stats[XDP_STATS_TOTAL] = { 0 };
+	struct fec_enet_priv_rx_q *rxq;
+	unsigned int start;
+	int i, j;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		do {
+			start = u64_stats_fetch_begin(&rxq->syncp);
+			for (j = 0; j < XDP_STATS_TOTAL; j++)
+				xdp_stats[j] += rxq->stats[j];
+		} while (u64_stats_fetch_retry(&rxq->syncp, start));
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
@@ -2719,6 +2783,12 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
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
@@ -2727,9 +2797,15 @@ static void fec_enet_get_strings(struct net_device *netdev,
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
+			strscpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+		page_pool_ethtool_stats_get_strings(data);
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2739,9 +2815,13 @@ static void fec_enet_get_strings(struct net_device *netdev,
 
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
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2752,6 +2832,7 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_rx_q *rxq;
 	int i;
 
 	/* Disable MIB statistics counters */
@@ -2760,6 +2841,11 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);
 
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		memset(rxq->stats, 0, sizeof(rxq->stats));
+	}
+
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
@@ -3126,6 +3212,8 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 		for (i = 0; i < rxq->bd.ring_size; i++)
 			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
 
+		memset(rxq->stats, 0, sizeof(rxq->stats));
+
 		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 			xdp_rxq_info_unreg(&rxq->xdp_rxq);
 		page_pool_destroy(rxq->page_pool);
-- 
2.34.1

