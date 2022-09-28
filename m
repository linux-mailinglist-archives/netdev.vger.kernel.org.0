Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A9A5EE053
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiI1P1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiI1P0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:26:46 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2077.outbound.protection.outlook.com [40.107.104.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3705BC3D;
        Wed, 28 Sep 2022 08:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLTduP79x8Xen+o4Iq1I5qyHIWGUJwOiHjAG/QSybZuYoWEbbGW3JxJ0JO4cvrCeGMaM7TsB1c8grVV6dcZxQl8nneYY9caXa4EB1Io5wxB+aUegjTyNWJbWRt/fAY7wuluFHWWxL5y0N1Ftq8pz04xh22g4ow2Tl1Y+auvSDWEATA/XnxYOoQ3m2qaUXGcRleZY3Cw30oNjvvGY26XUv+tiqFIEOSMvO3veYJgauIo7B3ASYScWKZYpdIkaYd+b9ABqv43mP5nkKMwe2eYmqneuLHKrdKO+wne2mZ7cz+s8iEJi4PaBV1ifX2kWCdcwv/FaGzK9At78xJ8UaVWTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWtR7mxIhdH8XVFmXGVMp8l30KHntQ3b7JpqGW6vW9k=;
 b=mXDbZvYiFAqmWEn/SqB8wSUIKxwLUSX45r9NF0UWy7qxrUXxsytQ9y9KNa197OdmXF/DlkOOKAgQLfz3x4789CLM4XbGuGnyjjLBvwzJiHs0n23XT3QH7Bbm7cKYa9wjhEctnaZi17eEYKyxwupYkGZJbLn3APocVo8psx6o3CFbNHvaD9ejTHpWSM6RjD8CfDH9+0GIAlwKXd2J8XWL6PzT3ZBL9Gu483ATP9iPXec1LH8Oeq+6XBbJxlyuU3KLmEnPbHk6O71St0MDp2AYBOIV3Uuur8LcyDgt462et5PSM2vgDiyioca8kxYsWAaiTetz7J6CQmYSyrPoTRQM4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWtR7mxIhdH8XVFmXGVMp8l30KHntQ3b7JpqGW6vW9k=;
 b=smKfX3ks4CtiABdpOLIHzGe79ekD3uZ7UXEo4W6rUuKAcVGHEm7dekosYg1EpbT+v1ivwLc8jYPaSwGTUoIa1Cw/DgGyXjFhslVrMvByiZhC299daBzAn/znj8M7MYOaNSn4GdJKhilJcySPvD9XM9k9BY38a+XAZJiAcj8D0KU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBAPR04MB7399.eurprd04.prod.outlook.com (2603:10a6:10:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 15:26:26 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 15:26:26 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: fec: add initial XDP support
Date:   Wed, 28 Sep 2022 10:25:09 -0500
Message-Id: <20220928152509.141490-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::12) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBAPR04MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e285e1-470f-4387-a4ce-08daa165ce95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzCqMbf1ueBxbLqPiuXNcDC+QvSCf+UqzU21CH5CNN1UcgU6D1BICxGKO8p56wAk9C1Te8j2oJXorgybPrEc1BnxPV60QbFcLwroBR0xBZqLQM8i37uOxlw7f/X2NsjO/JVuCDfS2UypTaxS7LWvaSPskHg8Rf1oVbRIQty34rmw8LH8yKNf5HpCETZ3BnqrwnpEborEHrK/QyVh7AgP/HhuDF2e7xdi7BDyzlQQkPSgEUIg9H++yyw3bKyvVkprvbI+n+4HREFxpwF1wRHC12R9RfLU3I9wWmHGlkX0VZuk9TRBLPbVqZQhP9gpeidG8P1hOWWNo+JZ/TnBPlVKJn/FPhDy4+8cpRTXIEYcgFTj38A/Fqy3afKGHmXc898nzj7oT50Mj3LXlNhl9bbWx6Z2iOPWjhz0EeHVJ1SGxwSVaKxzsXImNyVkE5IZ4mwnCYuvfZIRlIwGzlUrRpjhPPstmb53ounQohqR2YhwfVo0tVDmMwXj/ILlPrp4hlhBHTGQFlWeDMH9/m0qNde0FQFfhUAcEquZVAEJt3Gwe/L/W+jtXVyY9pjW4cbxtngxFwMU/e1gw8T7sIqtvcoUJdg54hvEA/l/yKDgwiYG2EY37JUcGfw/gBEbCQVHZjJpJ8THwI7AmQ8+uSa21YFToPJSPws1mXfntYE103v86UDmO6Z3jk0YZQ5nnikd1caWCHvRMpxFWuTdPBu+j4IAfy3oEWCOjd0QGI2Yg+JgZD4qgTmYudXyqjjB721d9kJ8FH/SAZuKFXO/P4Rb5e6QUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(44832011)(2906002)(30864003)(7416002)(5660300002)(4326008)(38350700002)(38100700002)(36756003)(41300700001)(66476007)(66556008)(66946007)(8676002)(6486002)(110136005)(54906003)(8936002)(478600001)(316002)(2616005)(186003)(86362001)(6506007)(55236004)(52116002)(26005)(6666004)(1076003)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FieJ3c/mWCCHjAHkDJcS/VnF8zpi9Cd3LICkB9JUDnaJSk3MzuGeTKZPCD9u?=
 =?us-ascii?Q?d40pFlpuoBt7sbRSJry7DgBeP3T3qhXCcVNmWE9/GSutbFNZnHGFji7JoBg/?=
 =?us-ascii?Q?+qob4aVMKK9OY3U/+lTOcQqbVOQFE1vHC80YDQUrUI0BH0k/wze9i8Aulcr3?=
 =?us-ascii?Q?CJdf4KM1TvB7z2VoTTFZTAhmYQCfZkSGwGoZ/u1Vhsx1Dph6bUJ7SnpQeDiD?=
 =?us-ascii?Q?6wQCsWilp+UmASRhXMVB4uAs58mhiYPan97qyePVPIOI8J6rJ/u/bYU0byyN?=
 =?us-ascii?Q?YjRc5DCJ+SX/wExR3c5n889b9xEfJRW2fHdjxjl/3f5LgEtL109jU9KEaM9N?=
 =?us-ascii?Q?jJdwP2ZyFtSoOV7wA86idApWYqxKO3bm1Id2t39jHxuuJ2XS0RYWI9phfbgT?=
 =?us-ascii?Q?H3iRXMPcCjtFVEaZwenDHHgEMoGl96fgPNJMQeC9LgdOctmS1zgAvIi6CzGT?=
 =?us-ascii?Q?8aacXpHGXAreCXZdWJYeyRGlKFo9TVPgtB8+yeQp3FBK1JrpzopHB+mgVbKs?=
 =?us-ascii?Q?3fyiMZhD17ukYZOn+Kascw+TUXeRfp1vvk97ge92YFUxVwwezb9v/oQD4NXa?=
 =?us-ascii?Q?a8a1wY+Fm9U838aEU+6QXMX6gVQdAA18mnLDoiWA4dhIEI3rVDxpm+AujUFi?=
 =?us-ascii?Q?riJAxI+39ZRJxlr45Q2wY/fEbu6S1fSZemd9tAEPT2Ujg1gKbzLG1Qozuc6q?=
 =?us-ascii?Q?Spwdpfn4hdDI9SxMsV11tYS3PLuDwv7Bl0S9gP3rRRm5L4Jco8Fc26QUwg3I?=
 =?us-ascii?Q?a8JkfmUBbc/ILvFJuE1qKkk3T8Vdo9t5AF5XnjDD6xZh5PTJlirOFPjDwz+g?=
 =?us-ascii?Q?X+eNKdgu5jJ8HN7QxVbB7oGUCmc97QHBFyGh6XADeyz31dxPA9ETAp80u+Gn?=
 =?us-ascii?Q?NoSbo749EWOVQ9yHXlWr3KsDqCxglATt9VPupueGAmMYSwkh67TDMT942oXV?=
 =?us-ascii?Q?MxtpbfRmyRxICE1SDVWUWRmCAIyuMpL0TW5SZKzqRKLH+8QDpiiLG73ubLab?=
 =?us-ascii?Q?j3T1IHAgHiQx5dRQCjtCoU/baS6iv6k1r2KH3JPeboq6SFjaAaIFy4ge/d42?=
 =?us-ascii?Q?QDxZIlDHfPNfoJYhSgr7oXUKHHyBgN7sq2V80D8wav7yl41ad/CAX3EO+miv?=
 =?us-ascii?Q?MTc5IM1/UAl9768CvW34A5ql8fnqv34QL0EF9P2hlzTodaVadbTgLs5Jp5N9?=
 =?us-ascii?Q?X0cD8yUTiRdqEOkuK2nOaJ7lUTO4wSbAkl+a8JRlLGVAm36yiTV+vZe7lPYU?=
 =?us-ascii?Q?WmqDSxaYFRCSe7U3MexE4jptn0KRjKxf+a8n6n1ouvbI83Dbns5gIzj7rUb0?=
 =?us-ascii?Q?nkQNw8QfBDRsKDCFZH2It4QE/t1sVIRWx+0w72MC2ZSAM9XTxM/P89J++Dzm?=
 =?us-ascii?Q?7fYIXL4yt84B1pla0bXDxtWHJHys4SvchGGpgIhY36JyKXZmtl+yXJePplis?=
 =?us-ascii?Q?WVq39xk0tBTcaCMSp/lA3dLaVefpE2wZjdxMYfYkaI6/8FKPi91PUTMl1cpu?=
 =?us-ascii?Q?vwuWlucwslNLgRc/IsODYlMVWjDvJkIlzsH0XrBHs8xRCsoUW/Zk6+GcNpiw?=
 =?us-ascii?Q?sdLxN3pbFzhPSCrXJHFmc0X+dKKzI8a1AQ+xayP/k8WiY+m+ZTNjFLS/lavy?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e285e1-470f-4387-a4ce-08daa165ce95
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 15:26:25.9934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQ+0fswAI3Zruk5/vgTpSI2uKVrKXaNX3I1jvHP1iZTBOFPYTCgdGg07Nv0wmb5JERlds+lhCe6TRDSfUe3CBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the initial XDP support to Freescale driver. It supports
XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
support for XDP_TX and Zero Copy features.

This patch also optimizes the RX buffers by using the page pool, which
uses one frame per page for easy management. In the future, it can be
further improved to use two frames per page.

This patch has been tested with the sample apps of "xdpsock" and "xdp2" in
samples/bpf directory for both SKB and Native (XDP) mode. The following
are the testing result comparing with the XDP skb-mode.

 # xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
 rx                 198798         1040011
 tx                 0              0

 # xdpsock -S -i eth0         // skb-mode
 sock0@eth0:0 rxdrop xdp-skb
                    pps            pkts           1.00
 rx                 95638          717251
 tx                 0              0

 # xdp2 eth0
 proto 0:     475362 pkt/s
 proto 0:     475549 pkt/s
 proto 0:     475480 pkt/s
 proto 0:     143258 pkt/s

 # xdp2 -S eth0    // skb-mode
 proto 17:      56468 pkt/s
 proto 17:      71999 pkt/s
 proto 17:      72000 pkt/s
 proto 17:      71988 pkt/s

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  34 +-
 drivers/net/ethernet/freescale/fec_main.c | 414 +++++++++++++++++++---
 2 files changed, 393 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index b0100fe3c9e4..f7531503aa95 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -346,8 +346,10 @@ struct bufdesc_ex {
  * the skbuffer directly.
  */
 
+#define FEC_ENET_XDP_HEADROOM	(512) /* XDP_PACKET_HEADROOM + NET_IP_ALIGN) */
+
 #define FEC_ENET_RX_PAGES	256
-#define FEC_ENET_RX_FRSIZE	2048
+#define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM)
 #define FEC_ENET_RX_FRPPG	(PAGE_SIZE / FEC_ENET_RX_FRSIZE)
 #define RX_RING_SIZE		(FEC_ENET_RX_FRPPG * FEC_ENET_RX_PAGES)
 #define FEC_ENET_TX_FRSIZE	2048
@@ -517,6 +519,22 @@ struct bufdesc_prop {
 	unsigned char dsize_log2;
 };
 
+struct fec_enet_priv_txrx_info {
+	int	offset;
+	struct	page *page;
+	struct  sk_buff *skb;
+};
+
+struct fec_enet_xdp_stats {
+	u64	xdp_pass;
+	u64	xdp_drop;
+	u64	xdp_xmit;
+	u64	xdp_redirect;
+	u64	xdp_xmit_err;
+	u64	xdp_tx;
+	u64	xdp_tx_err;
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -532,7 +550,15 @@ struct fec_enet_priv_tx_q {
 
 struct fec_enet_priv_rx_q {
 	struct bufdesc_prop bd;
-	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
+	struct  fec_enet_priv_txrx_info rx_skb_info[RX_RING_SIZE];
+
+	/* page_pool */
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+	struct fec_enet_xdp_stats stats;
+
+	/* rx queue number, in the range 0-7 */
+	u8 id;
 };
 
 struct fec_stop_mode_gpr {
@@ -644,6 +670,10 @@ struct fec_enet_private {
 
 	struct imx_sc_ipc *ipc_handle;
 
+	/* XDP BPF Program */
+	unsigned long *af_xdp_zc_qps;
+	struct bpf_prog *xdp_prog;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 59921218a8a4..2e30182ed770 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -66,6 +66,8 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
 
 #include <asm/cacheflush.h>
 
@@ -87,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
 #define FEC_ENET_OPD_V	0xFFF0
 #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
 
+#define FEC_ENET_XDP_PASS          0
+#define FEC_ENET_XDP_CONSUMED      BIT(0)
+#define FEC_ENET_XDP_TX            BIT(1)
+#define FEC_ENET_XDP_REDIR         BIT(2)
+
 struct fec_devinfo {
 	u32 quirks;
 };
@@ -422,6 +429,49 @@ fec_enet_clear_csum(struct sk_buff *skb, struct net_device *ndev)
 	return 0;
 }
 
+static int
+fec_enet_create_page_pool(struct fec_enet_private *fep,
+			  struct fec_enet_priv_rx_q *rxq, int size)
+{
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = dev_to_node(&fep->pdev->dev),
+		.dev = &fep->pdev->dev,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+		.offset = FEC_ENET_XDP_HEADROOM,
+		.max_len = FEC_ENET_RX_FRSIZE,
+	};
+	int err;
+
+	rxq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rxq->page_pool)) {
+		err = PTR_ERR(rxq->page_pool);
+		rxq->page_pool = NULL;
+		return err;
+	}
+
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, fep->netdev, rxq->id, 0);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 rxq->page_pool);
+	if (err)
+		goto err_unregister_rxq;
+
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(rxq->page_pool);
+	rxq->page_pool = NULL;
+	return err;
+}
+
 static struct bufdesc *
 fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			     struct sk_buff *skb,
@@ -1285,7 +1335,6 @@ fec_stop(struct net_device *ndev)
 	}
 }
 
-
 static void
 fec_timeout(struct net_device *ndev, unsigned int txqueue)
 {
@@ -1450,7 +1499,7 @@ static void fec_enet_tx(struct net_device *ndev)
 		fec_enet_tx_queue(ndev, i);
 }
 
-static int
+static int __maybe_unused
 fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
@@ -1470,8 +1519,9 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
 	return 0;
 }
 
-static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
-			       struct bufdesc *bdp, u32 length, bool swap)
+static bool __maybe_unused
+fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
+		   struct bufdesc *bdp, u32 length, bool swap)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
 	struct sk_buff *new_skb;
@@ -1496,6 +1546,78 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
 	return true;
 }
 
+static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
+				struct bufdesc *bdp, int index)
+{
+	struct page *new_page;
+	dma_addr_t phys_addr;
+
+	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
+	WARN_ON(!new_page);
+	rxq->rx_skb_info[index].page = new_page;
+
+	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
+	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
+	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
+}
+
+static u32
+fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
+		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
+{
+	unsigned int sync, len = xdp->data_end - xdp->data;
+	u32 ret = FEC_ENET_XDP_PASS;
+	struct page *page;
+	int err;
+	u32 act;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - FEC_ENET_XDP_HEADROOM;
+	sync = max(sync, len);
+
+	switch (act) {
+	case XDP_PASS:
+		rxq->stats.xdp_pass++;
+		ret = FEC_ENET_XDP_PASS;
+		break;
+
+	case XDP_TX:
+		rxq->stats.xdp_tx++;
+		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
+		fallthrough;
+
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(fep->netdev, xdp, prog);
+		rxq->stats.xdp_redirect++;
+		if (!err) {
+			ret = FEC_ENET_XDP_REDIR;
+		} else {
+			ret = FEC_ENET_XDP_CONSUMED;
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(rxq->page_pool, page, sync, true);
+		}
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
+		fallthrough;
+
+	case XDP_ABORTED:
+		fallthrough;    /* handle aborts by dropping packet */
+
+	case XDP_DROP:
+		rxq->stats.xdp_drop++;
+		ret = FEC_ENET_XDP_CONSUMED;
+		page = virt_to_head_page(xdp->data);
+		page_pool_put_page(rxq->page_pool, page, sync, true);
+		break;
+	}
+
+	return ret;
+}
+
 /* During a receive, the bd_rx.cur points to the current incoming buffer.
  * When we update through the ring, if the next incoming buffer has
  * not been given to the system, we just set the empty indicator,
@@ -1508,7 +1630,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct fec_enet_priv_rx_q *rxq;
 	struct bufdesc *bdp;
 	unsigned short status;
-	struct  sk_buff *skb_new = NULL;
 	struct  sk_buff *skb;
 	ushort	pkt_len;
 	__u8 *data;
@@ -1517,8 +1638,12 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	bool	vlan_packet_rcvd = false;
 	u16	vlan_tag;
 	int	index = 0;
-	bool	is_copybreak;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
+	struct page *page;
+	struct xdp_buff xdp;
+	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
+
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 
 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1529,6 +1654,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	 * These get messed up if we get called due to a busy condition.
 	 */
 	bdp = rxq->bd.cur;
+	xdp_init_buff(&xdp, PAGE_SIZE, &rxq->xdp_rxq);
 
 	while (!((status = fec16_to_cpu(bdp->cbd_sc)) & BD_ENET_RX_EMPTY)) {
 
@@ -1570,31 +1696,37 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_bytes += pkt_len;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
-		skb = rxq->rx_skbuff[index];
+		page = rxq->rx_skb_info[index].page;
+
+		dma_sync_single_for_cpu(&fep->pdev->dev,
+					fec32_to_cpu(bdp->cbd_bufaddr),
+					pkt_len,
+					DMA_FROM_DEVICE);
+
+		prefetch(page_address(page));
+		fec_enet_update_cbd(rxq, bdp, index);
+
+		if (xdp_prog) {
+			xdp_prepare_buff(&xdp, page_address(page),
+					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
+
+			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
+			xdp_result |= ret;
+			if (ret != FEC_ENET_XDP_PASS)
+				goto rx_processing_done;
+		}
 
 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
 		 */
-		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
-						  need_swap);
-		if (!is_copybreak) {
-			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
-			if (unlikely(!skb_new)) {
-				ndev->stats.rx_dropped++;
-				goto rx_processing_done;
-			}
-			dma_unmap_single(&fep->pdev->dev,
-					 fec32_to_cpu(bdp->cbd_bufaddr),
-					 FEC_ENET_RX_FRSIZE - fep->rx_align,
-					 DMA_FROM_DEVICE);
-		}
-
-		prefetch(skb->data - NET_IP_ALIGN);
+		skb = build_skb(page_address(page), FEC_ENET_RX_FRSIZE);
+		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
 		skb_put(skb, pkt_len - 4);
 		data = skb->data;
+		page_pool_release_page(rxq->page_pool, page);
 
-		if (!is_copybreak && need_swap)
+		if (need_swap)
 			swap_buffer(data, pkt_len);
 
 #if !defined(CONFIG_M5272)
@@ -1649,16 +1781,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		skb_record_rx_queue(skb, queue_id);
 		napi_gro_receive(&fep->napi, skb);
 
-		if (is_copybreak) {
-			dma_sync_single_for_device(&fep->pdev->dev,
-						   fec32_to_cpu(bdp->cbd_bufaddr),
-						   FEC_ENET_RX_FRSIZE - fep->rx_align,
-						   DMA_FROM_DEVICE);
-		} else {
-			rxq->rx_skbuff[index] = skb_new;
-			fec_enet_new_rxbdp(ndev, bdp, skb_new);
-		}
-
 rx_processing_done:
 		/* Clear the status flags for this buffer */
 		status &= ~BD_ENET_RX_STATS;
@@ -1689,6 +1811,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		writel(0, rxq->bd.reg_desc_active);
 	}
 	rxq->bd.cur = bdp;
+
+	if (xdp_result & FEC_ENET_XDP_REDIR)
+		xdp_do_flush_map();
+
 	return pkt_received;
 }
 
@@ -2584,15 +2710,46 @@ static const struct fec_stat {
 	{ "IEEE_rx_octets_ok", IEEE_R_OCTETS_OK },
 };
 
-#define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))
+static struct fec_xdp_stat {
+	char name[ETH_GSTRING_LEN];
+	u32 count;
+} fec_xdp_stats[] = {
+	{ "rx_xdp_redirect", 0 },
+	{ "rx_xdp_pass", 0 },
+	{ "rx_xdp_drop", 0 },
+	{ "rx_xdp_tx", 0 },
+	{ "rx_xdp_tx_errors", 0 },
+	{ "tx_xdp_xmit", 0 },
+	{ "tx_xdp_xmit_errors", 0 },
+};
+
+#define FEC_STATS_SIZE	((ARRAY_SIZE(fec_stats) + \
+			ARRAY_SIZE(fec_xdp_stats)) * sizeof(u64))
 
 static void fec_enet_update_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_rx_q *rxq;
+	struct fec_xdp_stat xdp_stats[7];
+	int off = ARRAY_SIZE(fec_stats);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		xdp_stats[0].count += rxq->stats.xdp_redirect;
+		xdp_stats[1].count += rxq->stats.xdp_pass;
+		xdp_stats[2].count += rxq->stats.xdp_drop;
+		xdp_stats[3].count += rxq->stats.xdp_tx;
+		xdp_stats[4].count += rxq->stats.xdp_tx_err;
+		xdp_stats[5].count += rxq->stats.xdp_xmit;
+		xdp_stats[6].count += rxq->stats.xdp_xmit_err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++)
+		fep->ethtool_stats[i + off] = xdp_stats[i].count;
 }
 
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
@@ -2609,12 +2766,16 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
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
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2626,7 +2787,7 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(fec_stats);
+		return ARRAY_SIZE(fec_stats) + ARRAY_SIZE(fec_xdp_stats);
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2645,6 +2806,8 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);
 
+	for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++)
+		fec_xdp_stats[i].count = 0;
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
@@ -3011,17 +3174,14 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 		rxq = fep->rx_queue[q];
 		bdp = rxq->bd.base;
 		for (i = 0; i < rxq->bd.ring_size; i++) {
-			skb = rxq->rx_skbuff[i];
-			rxq->rx_skbuff[i] = NULL;
-			if (skb) {
-				dma_unmap_single(&fep->pdev->dev,
-						 fec32_to_cpu(bdp->cbd_bufaddr),
-						 FEC_ENET_RX_FRSIZE - fep->rx_align,
-						 DMA_FROM_DEVICE);
-				dev_kfree_skb(skb);
-			}
+			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
 			bdp = fec_enet_get_nextdesc(bdp, &rxq->bd);
 		}
+
+		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+			xdp_rxq_info_unreg(&rxq->xdp_rxq);
+		page_pool_destroy(rxq->page_pool);
+		rxq->page_pool = NULL;
 	}
 
 	for (q = 0; q < fep->num_tx_queues; q++) {
@@ -3111,24 +3271,32 @@ static int
 fec_enet_alloc_rxq_buffers(struct net_device *ndev, unsigned int queue)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	unsigned int i;
-	struct sk_buff *skb;
+	unsigned int i, err;
 	struct bufdesc	*bdp;
 	struct fec_enet_priv_rx_q *rxq;
 
+	dma_addr_t phys_addr;
+	struct page *page;
+
 	rxq = fep->rx_queue[queue];
 	bdp = rxq->bd.base;
+
+	err = fec_enet_create_page_pool(fep, rxq, rxq->bd.ring_size);
+	if (err < 0) {
+		netdev_err(ndev, "%s failed queue %d (%d)\n", __func__, queue, err);
+		return err;
+	}
+
 	for (i = 0; i < rxq->bd.ring_size; i++) {
-		skb = __netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE, GFP_KERNEL);
-		if (!skb)
+		page = page_pool_dev_alloc_pages(rxq->page_pool);
+		if (!page)
 			goto err_alloc;
 
-		if (fec_enet_new_rxbdp(ndev, bdp, skb)) {
-			dev_kfree_skb(skb);
-			goto err_alloc;
-		}
+		phys_addr = page_pool_get_dma_addr(page) + FEC_ENET_XDP_HEADROOM;
+		bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
 
-		rxq->rx_skbuff[i] = skb;
+		rxq->rx_skb_info[i].page = page;
+		rxq->rx_skb_info[i].offset = FEC_ENET_XDP_HEADROOM;
 		bdp->cbd_sc = cpu_to_fec16(BD_ENET_RX_EMPTY);
 
 		if (fep->bufdesc_ex) {
@@ -3490,6 +3658,144 @@ static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
 }
 
+static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	bool is_run = netif_running(dev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		if (is_run)
+			fec_enet_close(dev);
+		old_prog = xchg(&fep->xdp_prog, bpf->prog);
+
+		if (is_run)
+			fec_enet_open(dev);
+
+		if (old_prog)
+			bpf_prog_put(old_prog);
+
+		return 0;
+
+	case XDP_SETUP_XSK_POOL:
+		return -EOPNOTSUPP;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int
+fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int cpu)
+{
+	int index = cpu;
+
+	if (unlikely(index < 0))
+		index = 0;
+
+	while (index >= fep->num_tx_queues)
+		index -= fep->num_tx_queues;
+
+	return index;
+}
+
+static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
+				   struct fec_enet_priv_tx_q *txq,
+				   struct xdp_frame *frame)
+{
+	struct bufdesc *bdp, *last_bdp;
+	dma_addr_t dma_addr;
+	unsigned int index, status, estatus;
+	int entries_free;
+
+	entries_free = fec_enet_get_free_txdesc_num(txq);
+	if (entries_free < MAX_SKB_FRAGS + 1) {
+		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
+		return NETDEV_TX_OK;
+	}
+
+	/* Fill in a Tx ring entry */
+	bdp = txq->bd.cur;
+	last_bdp = bdp;
+	status = fec16_to_cpu(bdp->cbd_sc);
+	status &= ~BD_ENET_TX_STATS;
+
+	index = fec_enet_get_bd_index(bdp, &txq->bd);
+
+	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
+				  frame->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
+		return FEC_ENET_XDP_CONSUMED;
+
+	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
+	if (fep->bufdesc_ex)
+		estatus = BD_ENET_TX_INT;
+
+	bdp->cbd_bufaddr = cpu_to_fec32(dma_addr);
+	bdp->cbd_datlen = cpu_to_fec16(frame->len);
+
+	if (fep->bufdesc_ex) {
+		struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
+
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
+			estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
+
+		ebdp->cbd_bdu = 0;
+		ebdp->cbd_esc = cpu_to_fec32(estatus);
+	}
+
+	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
+	txq->tx_skbuff[index] = NULL;
+
+	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
+	 * it's the last BD of the frame, and to put the CRC on the end.
+	 */
+	status |= (BD_ENET_TX_READY | BD_ENET_TX_TC);
+	bdp->cbd_sc = cpu_to_fec16(status);
+
+	/* If this was the last BD in the ring, start at the beginning again. */
+	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+
+	txq->bd.cur = bdp;
+
+	return 0;
+}
+
+static int fec_enet_xdp_xmit(struct net_device *dev,
+			     int num_frames,
+			     struct xdp_frame **frames,
+			     u32 flags)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_tx_q *txq;
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	unsigned int queue;
+	int i, nxmit = 0;
+
+	queue = fec_enet_xdp_get_tx_queue(fep, cpu);
+	txq = fep->tx_queue[queue];
+	nq = netdev_get_tx_queue(fep->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	for (i = 0; i < num_frames; i++) {
+		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
+		nxmit++;
+	}
+
+	/* Make sure the update to bdp and tx_skbuff are performed. */
+	wmb();
+
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
+	__netif_tx_unlock(nq);
+
+	return num_frames;
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
@@ -3504,6 +3810,8 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
 	.ndo_set_features	= fec_set_features,
+	.ndo_bpf		= fec_enet_bpf,
+	.ndo_xdp_xmit		= fec_enet_xdp_xmit,
 };
 
 static const unsigned short offset_des_active_rxq[] = {
-- 
2.25.1

