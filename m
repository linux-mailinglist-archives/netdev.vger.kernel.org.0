Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD86221F5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiKICcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKICcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:32:06 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239465E3F6;
        Tue,  8 Nov 2022 18:32:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoqQ7loitkDKtqgOiDxFqtpB07i4C2oUXAf2vOejg3B4zF40glkIMdRwIpi52dsXXuJGi1NzRHYw8Yvm0Rx9DqUxfbGBF8wwdLPNukXa/9q3SSfW6uYl4DkUoGlArtPJqAcuA0QaY+Bkr92glkm7dJr7eshnpb7zmbPvjOD1LPTQTPNpLmo6Izs1FH6ttvZ6Xe6ApC+DxG1kWzglX++7tBa/khHz5r8A/Dj11AgD8CIXT+tejFuyxg0CjfZghqzxys1C3vZCmLsfd670CiGnfMMg2CE8XDKETU2mTQ++1fmqnJlyAHhcJLn1Dt4mjlJBG1r+FOZsqjN6LHIrA17MnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLRbQkprWioCUp/1ULcMQuZ9zQS08x/WBZSo7F5E2RU=;
 b=bz3t3afxVPjcf/vWkVCyI1SD7InKuqS5GWvi7MtFd9lZrO/SrwKVHLWgH5k4d9RMFDvn2s9Va+igtFynoQQX8bR4H28nQwlJQ+LEY/SdsV70xyaMpRU433877SPUiftL5JUVd+4sp/bKYIc3uAEYl6kMpEzehg1k+bXwppMxDH0Eo6MMq66QGJZgi8o7AF8h/t8w5icNbiqJhcfOB1Qh6e7Kvc5u3cYSbkkgSVRwaOY68sY7/uoxTKwW4fWebrwHAUK+u5+yTXULCszsa02TqmOJqLlD+BPekjoe0zaU3+iu9Ytx/5s/5hjZ07tqEl/zeFK+SccHZUF7eY+Ww6OdGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLRbQkprWioCUp/1ULcMQuZ9zQS08x/WBZSo7F5E2RU=;
 b=sgoQKRGYACkSDQjctaJNH3AU+CHZ1zyryEEgS3WPttztsbUW3doMTCND4ZZLtg7aYYJTxsOfTteUfGgGiWM7qOh/DJn2feoxXSnWoC5dqyy9/s+wg+IiTjz7iSVsPSz4inDlkF8BKLVB+MlXbYuPxrIndkTihHBIL4MaImtjSK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB7542.eurprd04.prod.outlook.com (2603:10a6:20b:299::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 9 Nov
 2022 02:32:02 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 02:32:02 +0000
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
Subject: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool statistics
Date:   Tue,  8 Nov 2022 20:31:47 -0600
Message-Id: <20221109023147.242904-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0111.namprd11.prod.outlook.com
 (2603:10b6:806:d1::26) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b1f8b0b-c7f7-4fb3-72b8-08dac1fa959e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtVhDz8GfgxZduQXic4DddWF6Z4j2Y1SSHPOzCzJU8EwJ4H0tFwGduagLLtwI3L17onYJokBRm9jeXiKxrLs9TgVLHFNY1RHgNo6J1dSwMl0YdaqK1Yj1A/cwEOxsH0ERtbLLokwllUJAs7z16wZ7ldWYioB3MXw6eEazv7VKTLgADykU/iX/sJj/6jYlp3WnTHkdEJqFFk+vEwQQkuyUwhCR8gflCTz8HG3aXEkZGOOe2VOkS4pqGgE9vID2OFAQuhURQGQ4I+hJ8PL0W/YUjkZKKwV14lB4kQuCCySUW5XbgXtMxbb0evsiSjqhSug5r+FjtUO/G4jKhBRuBTeZJOtbO9TLQBv9fKHyrVEv79B6hfpeDGyrCoiGGSaDLnX1Yahpn5zS2p6kHpYYB7plTZPmjtNyA8pj9Ypj3deGusHrOzXhrkrDD7txocrHZkMffZiTcVCzVpmtNdrCdNhywV8aSpDNSOdX/TBfzz6sjfjgOBJEurgThKrkYkZFAS4DZbQs1MaXNwWnJEOtfNjmRKzkYzrbbDLOTwqslTTnzZaPWJFI9VO9saL32RIF4e68Mo8E0K+xmo/N+oWv4EVxCRLDuY6E+F6mHNCUtaBJXHVlPdnNyV2wK6/WdnTSfu2dARXHZRf38OVnragL4M7rKaebshQ+cNyKjXos8rGRB2EVDXvZvAL9aEI4UPrYn2JdSE2mTEWpsC7YN2XJKl3uVjfA5wHr1DxrvtgHKHfmy/PuSeD9Da5GWWxfSqsEIGwMLBU5YLQW544xJlax/XnnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(36756003)(38100700002)(38350700002)(66946007)(478600001)(86362001)(44832011)(4326008)(6506007)(6486002)(2906002)(55236004)(52116002)(41300700001)(6666004)(66476007)(8676002)(66556008)(7416002)(5660300002)(8936002)(1076003)(110136005)(186003)(316002)(26005)(2616005)(6512007)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0v5e/k48hkDKjIKsZ1dgncxwcRCaMgNK9XYSiNkNhcA+PuHUQJtKNTvRhb0N?=
 =?us-ascii?Q?CpZH/U7YOF9g3w0W6BMV6oNG274oLSrb2N2QmWbOzsdi3JQITpH5R2Q1cMI5?=
 =?us-ascii?Q?jFnC25trGC8K70rPJbhJEaWULeRWEKspFRpDBhr/+RfqKFfuTVnxcvrAyUAT?=
 =?us-ascii?Q?Hu4bAoHX8Hid6dF3FlqQEb4farLd4n4QK5Vqu0cSWL+1qhZsmvNddu0FhllL?=
 =?us-ascii?Q?FjNn+4Hhc9m09b3jiz6bm4xevtFp1NYHiIpjnRuaKXK8GqVDfpk3U4cyxM9w?=
 =?us-ascii?Q?HrZ6kD68iRTaV9mO4tyu0f1x/Mt4yFIkDxxoYEtSOw3gkvUMrSwXsyx0qqpE?=
 =?us-ascii?Q?JBu9BXTJdzKCl+RaDgqUiRtfZTGdKMa6gDtOAci0LS9Br3cur4eQpMbD8G+c?=
 =?us-ascii?Q?+dQ+HwxA8/RR6oJn9ot1d3JcgWFcHNaj6UR/uDJXye48Wm2W8GT/Qh+YC23P?=
 =?us-ascii?Q?YETWI7wxleShMc35p966NOnwkUZdBldghLh3gtl9JrUFBD5+cAanXl8UW5Qo?=
 =?us-ascii?Q?cw3hjkIYWiCEHN0rIEUoBPlnIaEjZynGQIc4lw03Hsu0u0UhQF3wG7Eql7ea?=
 =?us-ascii?Q?xDVfXV/SHZs2uHX2iu/0TyOr55YWD3USVDCb51xHmNmVxcVtlHXvJWMqH+6J?=
 =?us-ascii?Q?C5GsVDIGREL1i9bjuX8Wk0uBvW31Zk5rgJtdG018U8azmn0gz12ASzpzkusr?=
 =?us-ascii?Q?a4M85cdCePuu6c0Sz2RFXYLuLsomioZ4EV+88lEdQ9E3WcbG3RXHys4vDCHB?=
 =?us-ascii?Q?Ef4+yvCxBJFkizstZnaqUaE/HlpSdYD0skkxlfx2qDi79+ERzFV29PD5LC1a?=
 =?us-ascii?Q?GDOegPCqMLnFoHXGKQBdRnwvQOdRfVERAQ9IoBC5my47/CxGcY1UOxOeg3nx?=
 =?us-ascii?Q?guAVc37LY3i8r+ZL9ShqmJ8UDnkV0fcMgFsqvgm1oDvlcZPZyNz9iYd4ljve?=
 =?us-ascii?Q?J6xaux3g10XFDJXjG45D9sbQ4aAAn0Bqrk/HloqVjEvegoi1B3HsYMKxWWsM?=
 =?us-ascii?Q?dhwLExIbJaLmYCuneqVScoxp5FYvZjCWTGek5YBgahpA120OfaBCzrA533/h?=
 =?us-ascii?Q?0rolIYkMpnai5o+6VhgbZ+gOylgC78PDmL0ebM9I9KfP/Q7q8csp1yMdCqVd?=
 =?us-ascii?Q?PMDOPiR5p3aCKLFG2pUvZ7km6Q+gT7ZAiHACVdXjSW7tVM7s9XgQdfmulklT?=
 =?us-ascii?Q?FKARAvBvUY+G2wvqtl2yZsv0a9Os7UyRLLglpXeLRBt5LveD2ZOYGe9rYCfX?=
 =?us-ascii?Q?E3grGJlvDswcHKUTaexJ+svCQw5j4fiMoCG2XhxDzEDpWyvqKeGvhd81Icis?=
 =?us-ascii?Q?jlpVlczaG1CAByISH0dVr/PrvqJ2quoXf0YC+MT9ySyJAb1sIo4Ha32NNFZ9?=
 =?us-ascii?Q?jUUSmCTvSNoHERamTRQ7JlzDKNcUvMFuD0jQI1rhSiwPSQ9XAJqHsMFGoAuu?=
 =?us-ascii?Q?1eZa6S8Z1N9aiApd0yDorHTMEBusGjkJMVO/6ssMdeJmmWbqQi28vlTrgM2N?=
 =?us-ascii?Q?aEZ98+uiAVwuOISgNKKEty8Ru0aq7OcLTlxh16PhLSvt38Ho0G7lQ2vQXbtf?=
 =?us-ascii?Q?NMcVtNqNHRXqWx22CeIt8WiPwxyp/P3yMuWiFahX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1f8b0b-c7f7-4fb3-72b8-08dac1fa959e
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 02:32:02.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgQAIh2gBAtmLoRWb8utUZ5+txUklP3pwaemB35WyM6AZYn0GyZuvx6vLpp6Px7GsaybCBGQ+nGEU8UpjUL28g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7542
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
 Changes in v2:
 - clean up and restructure the codes per Andrew Lunn's review comments
 - clear the statistics when the adaptor is down

 drivers/net/ethernet/freescale/fec.h      | 14 ++++
 drivers/net/ethernet/freescale/fec_main.c | 85 +++++++++++++++++++++--
 2 files changed, 94 insertions(+), 5 deletions(-)

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
index 3fb870340c22..d18e50871c42 100644
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
+			memcpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
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

