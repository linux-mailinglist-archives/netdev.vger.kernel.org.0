Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFEF60D549
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiJYUMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiJYUMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:12:22 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDCE7B1CA;
        Tue, 25 Oct 2022 13:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGJhdQGWllLlZmTbJ5F3IYZWFIv2kqcQrhzy+Q2XAwTabVSafFDUWRm235PPwaNL5PAMwC51zLTUPztBsvyJRAURCLVccCNx48MTJ13elVvDavJRvopU//iOgbDl3LRQmCS3YOzg6X6LJCElvxY9fMD2iF70OP+9QOrzs5zZ+BmqJcU0EP71ZkKnor58SaM3ojCnSOzOY3rRkmAn9of38lBBXFCKzp8IKZQ9UEd5phcIoK9l7MUXGWU9S5fZk2DIBjM4/GV5FfDVtAj4g1nMqUTXJXt6YrBLUq66+t2hjGlRyAw1/3GiWfCaDFEEa+0V/hVkDaiiZB4dq13NHtyH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CY0Mf+cak8f1Yg+uXoFTHb7p8Zaewn/8Cs6hhcjobSc=;
 b=Qw4X2Yd2sBkS74TqwdstNpDxQSZ1fjPiREynpNcOqgoyOEIckm1E3K2nHbX8yNoBVi1HPHYqCHx+jzg5mexjNID4M3WhXPSPBfiG2TlxTtrzv6uaUjdDJTvT85fTQKSRApJx3j9jOZUDK9LAFZvaeeYIkYmACVSJ/DqvOOueTK6Q01TGE/RygFtA6BDd1Oe9tDlPfveAcLAa/a2xttCl6YJC8Pw4tyeYTE+OdLt9cAGZ2NwyaKdNJRy8ynYmU41t4kOuomrFjUCOTI9vPLphVmroBzK4Vo5sUpvKnNZuGs66XoSDPC4hNN0NuY9RUPQPNoLoFUw3GnZoYKTiyC9Yag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CY0Mf+cak8f1Yg+uXoFTHb7p8Zaewn/8Cs6hhcjobSc=;
 b=jQD/n4osJmHitDu3cVezdzz3z1bZc8UThq5lvXbLnb9RiyyZrXJWlirN3QaB/lS2Ta2QkwfYHaNbMKMUJKiYZYjJSXwpbyN6Zet74LGq32wER8nrtJSZUsDYuMInngPF2z5kdXZAo0OgnxAWoE7O5xBNXLUD4Kke4VhtdIRBc+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8404.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 20:12:09 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%9]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 20:12:09 +0000
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
Subject: [PATCH 1/1] net: fec: add initial XDP support
Date:   Tue, 25 Oct 2022 15:11:56 -0500
Message-Id: <20221025201156.776576-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0137.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::22) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB8404:EE_
X-MS-Office365-Filtering-Correlation-Id: 05468644-8774-47f3-4e78-08dab6c531f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+jRKSzmf7i0kES7dtgMOzO5sBfdiNaHLwqMDIjh7nnDlwf88UDUiET9MDpFx+YUmxX3dYFP7g+GphBm6P8EwXfuVRN819PCBI1ld+pnciRZE43Fk2T62gCXndXU/PCupARykGjkmOgs8mKS2XEhn5SZ0wn2KfHFB9sK/TACbR27sfvsL3DTrrDfhSFLSbYtKLIOqzpeajtuwgWvtK7KRoTJe2xNrUqy30pLDfsfMVqphm6juYl+54m5N5rqqdVryb6c0ZLIWpzkgnvpohDxX+b0h4jC+gi6kX6xZseXrmsAwxjylW8FYHcLdEr6OAAdDxVpgAwqmdM0Zf5ypJKdzywiwlbp+6inerLjEzOksRXaeUME+OxzJCC0VuQ1/56VVBZ/7Bw9vRjrcy+4eF7LaJq0lQlEgmXh1f0b42lardQyDWSEVpQelbsXjE5GRhxciqeQLXrm5XJsUeLMGiLa9F9utYw/mYNNnUuySDMyHoPTV/1yicBDs7FHZ9lW4kc9mDC57F4KcIFZY8D+vQi9W78wo9b/gCVQO4dCoVGNc2MmWt08or6hv5A5ELdB3wLMvcCEkkB32e3SZ6k+t9mimzVmhUVkAslBIhT2WbKQdpuFO6Mb0XCssugUAaAppos6YqO2qG2nQIMx81MerJt9pCMlfoq7XHsmXS+h+qcHmzXRYhs+UhENDtZCfrSoRxD72ggg87ux0tca27qZxF3K6CJCXFI5JSR6LKnncmVFV4kjDl6wp76QfNMLoEeXW9iqKwKJR5f9vyQM/o7HdBz8Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(478600001)(110136005)(8936002)(38100700002)(36756003)(6486002)(54906003)(83380400001)(44832011)(38350700002)(30864003)(2906002)(66556008)(7416002)(66946007)(8676002)(5660300002)(316002)(66476007)(4326008)(6512007)(1076003)(186003)(2616005)(41300700001)(6666004)(26005)(55236004)(86362001)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+PLHqvcJEzL9w83GGeOMcwnajw/id0GIy8ThvLjOtKdmH5zUn8pISBqU8q8?=
 =?us-ascii?Q?Q20ZZniNrY58qaUSIkXtfcO131EVwZAyDgLJEHqsjl7hsG6A3ZF1FmSmma2p?=
 =?us-ascii?Q?BNKrGPBHDskPAsfZdqYej20YvwHHoHVliIdhqAxhvtu8+tVNVLFQYZbKdMLd?=
 =?us-ascii?Q?7rEH68NfVNs36Sg9CYRTcrg0fH+LuhQt2JpmzYNQowX/bvJeGXXUjnaQ2FJF?=
 =?us-ascii?Q?T5iYPilhf0Z1X9241AizUJu27SNwFabE5zPdp205cNwj87ipnp0TXPpIGwXe?=
 =?us-ascii?Q?woOgyvoGfkIWi0lHguPaSxwfB+nUIpIeUhDuTHybrhArdK7mJ5lv0aZFzcS4?=
 =?us-ascii?Q?MbFGLSGOZZyu+EU/5V8tA7rooE7h2Jkl07WlGmljeQVuZqLObXiEq7FitDvM?=
 =?us-ascii?Q?oc3ZD9yWT+ZFUdTErMDdjtehbb6yWXW8vYoTl2bXUncJtQ1V4t8++TAdoL1Y?=
 =?us-ascii?Q?zhCcOnckdYuo5tFsOn2HZ/n78OWusl0fFO7ZTtzriYPy+VpptIG2YfGekBTC?=
 =?us-ascii?Q?Ia5Jxk1W6kqc6Dnqtq032hQzNAUm+bMrjULEgoiidVKuO47MMQQEyUUux1H7?=
 =?us-ascii?Q?hByaGvDAl0uJcoPPMBInTDedp1JHE45E3HgYn0TYOIAquvWSShm2JSRAs8gQ?=
 =?us-ascii?Q?awB7R6/CQXoTctTOqvn+T3443gH2Dg3uk0F13B1f3uaIcKas9hxDu6m8/3Ft?=
 =?us-ascii?Q?yRMPbo8fZ/lrTE4u+ZXqkoQklHUOjH6tUKCegGboRF75ehhQgKs6X3ubDwKf?=
 =?us-ascii?Q?KgRdG5bFPfY9EhB0mzEHIRDEf2/XDp9oGvcAp2zzneIV/5gQPg69St4nr01K?=
 =?us-ascii?Q?8SmjTDBEPQ1vbjq49XhKmjON324rpsoQkwlI7eJEWdZCg3cOYH0jzdp62GJ6?=
 =?us-ascii?Q?xvItjdbQgjOalygODlOlRDLxJTPmckNjqcAOcclEj5eeSs2+gGtzp9+IsnAi?=
 =?us-ascii?Q?8nu+KAZVzEeIRaJk2I5cJljYPw5WU5Xhb4eQwMPX7BUhzSx20zu9JISQxAZl?=
 =?us-ascii?Q?AtQEYKWhzcXAZVXQHGyehv4NcTODIAa+OyzNEUXE9lBkFtodd0vOTqN6/cmB?=
 =?us-ascii?Q?Vvk6VCGYoXNoESC9q1svP65malGRmeij2BIav1L/3hcz4qmJ4dy4ZmVGzL8n?=
 =?us-ascii?Q?PYbpd6fUjWrjRAr6yTMR991CORUSsP7aqDPv0BsuwF8QfEkUzPbyW8yYBzCV?=
 =?us-ascii?Q?s0mUIhG4KEUihtsba0iX/ZQETYQ9JK74M4Jx/wfuHYB/453pNAm2GLN/ScNY?=
 =?us-ascii?Q?LD5H6YgWqYa0G7QrNb2qDJ8+XEUq2aZ15JrUsqw8qoH4S7ajPa1kllJKUJcq?=
 =?us-ascii?Q?MarzO1aUwfAJXda8gddtnOLi4WQdgmmf7x2putSlmJH4Pl6eOdhY40MGnZLB?=
 =?us-ascii?Q?fpFb6NOiUooGbWK/p2RKjfgjm58qeKzcdUaoOUtp8m7u+gyWAJSWdGKDjumf?=
 =?us-ascii?Q?SL607CaqiUVWsLcbF4QbuvxQHKgl/H5YfmgOM5RNV8FWO30WSvBtNoRTIhFz?=
 =?us-ascii?Q?dHhVt4E7ce3XOozxJOcaVVLw5toynnxZrIYaN3TauAfWuBi8BS5nTlAcN2VP?=
 =?us-ascii?Q?2hA3g0O+yJ14GqIrR7TAq7Gd6SUlGZV/gPTma/XUks+RHhRAU3cbGwTyQECn?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05468644-8774-47f3-4e78-08dab6c531f5
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 20:12:09.1193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRPH21lvDofqjXJ9cwdSC09oKeKRWpBNntukqDuwkMk2sStwkDf8XtEXp8oqe9ycv27wFQgHmIV8cCOvqeUSOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8404
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the initial XDP support to Freescale driver. It supports
XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
support for XDP_TX and Zero Copy features.

As the patch is rather large, the part of codes to collect the
statistics is separated and will prepare a dedicated patch for that
part.

The driver has a macro RX_RING_SIZE to configure the RX ring size. After
testing with the RX ring size, it turned out the small the rign size the
better the better performance for XDP mode. So the different ring size is
selected for XDP mode and normal mode in this patch.

I just tested with the application of xdpsock.
  -- Native here means running command of "xdpsock -i eth0"
  -- SKB-Mode means running command of "xdpsock -S -i eth0"

RX Ring Size       16       32        64       128
      Native      230K     227K      196K      160K
    SKB-Mode      207K     208K      203K      204K

Normal mode performance by iperf.

RX Ring Size         16         64       128
iperf              300Mbps    830Mbps   933Mbps

The following are the testing result relating to XDP mode:

 # ./xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
 rx                 231166         905984
 tx                 0              0

 # xdpsock -S -i eth0         // skb-mode
 sock0@eth0:0 rxdrop xdp-skb
                    pps            pkts           1.00
 rx                 205638         917288
 tx                 0              0

 # xdp2 eth0
 proto 0:     571382 pkt/s
 proto 0:     579849 pkt/s
 proto 0:     582110 pkt/s

 # xdp2 -S eth0    // skb-mode
 proto 17:      71999 pkt/s
 proto 17:      72000 pkt/s
 proto 17:      71988 pkt/s

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |   4 +
 drivers/net/ethernet/freescale/fec_main.c | 241 +++++++++++++++++++++-
 2 files changed, 244 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 476e3863a310..07e85fc3d7ba 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -348,6 +348,7 @@ struct bufdesc_ex {
  */
 
 #define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
+#define XDP_RX_RING_SIZE	16
 
 #define FEC_ENET_RX_PAGES	256
 #define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
@@ -663,6 +664,9 @@ struct fec_enet_private {
 
 	struct imx_sc_ipc *ipc_handle;
 
+	/* XDP BPF Program */
+	struct bpf_prog *xdp_prog;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6986b74fb8af..2e4be4590f77 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -89,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
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
@@ -418,13 +423,14 @@ static int
 fec_enet_create_page_pool(struct fec_enet_private *fep,
 			  struct fec_enet_priv_rx_q *rxq, int size)
 {
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.pool_size = size,
 		.nid = dev_to_node(&fep->pdev->dev),
 		.dev = &fep->pdev->dev,
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
 		.offset = FEC_ENET_XDP_HEADROOM,
 		.max_len = FEC_ENET_RX_FRSIZE,
 	};
@@ -1499,6 +1505,59 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
 }
 
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
+		ret = FEC_ENET_XDP_PASS;
+		break;
+
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(fep->netdev, xdp, prog);
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
+	case XDP_TX:
+		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
+		fallthrough;
+
+	case XDP_ABORTED:
+		fallthrough;    /* handle aborts by dropping packet */
+
+	case XDP_DROP:
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
@@ -1520,6 +1579,9 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	u16	vlan_tag;
 	int	index = 0;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
+	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
+	struct xdp_buff xdp;
 	struct page *page;
 
 #ifdef CONFIG_M532x
@@ -1531,6 +1593,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	 * These get messed up if we get called due to a busy condition.
 	 */
 	bdp = rxq->bd.cur;
+	xdp_init_buff(&xdp, PAGE_SIZE, &rxq->xdp_rxq);
 
 	while (!((status = fec16_to_cpu(bdp->cbd_sc)) & BD_ENET_RX_EMPTY)) {
 
@@ -1580,6 +1643,17 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		prefetch(page_address(page));
 		fec_enet_update_cbd(rxq, bdp, index);
 
+		if (xdp_prog) {
+			xdp_buff_clear_frags_flag(&xdp);
+			xdp_prepare_buff(&xdp, page_address(page),
+					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
+
+			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
+			xdp_result |= ret;
+			if (ret != FEC_ENET_XDP_PASS)
+				goto rx_processing_done;
+		}
+
 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
@@ -1675,6 +1749,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		writel(0, rxq->bd.reg_desc_active);
 	}
 	rxq->bd.cur = bdp;
+
+	if (xdp_result & FEC_ENET_XDP_REDIR)
+		xdp_do_flush_map();
+
 	return pkt_received;
 }
 
@@ -3476,6 +3554,165 @@ static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
 }
 
+static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	bool is_run = netif_running(dev);
+	struct bpf_prog *old_prog;
+	unsigned int dsize;
+	int i;
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		if (is_run)
+			fec_enet_close(dev);
+
+		old_prog = xchg(&fep->xdp_prog, bpf->prog);
+
+		/* Update RX ring size */
+		dsize = fep->bufdesc_ex ? sizeof(struct bufdesc_ex) :
+			sizeof(struct bufdesc);
+		for (i = 0; i < fep->num_rx_queues; i++) {
+			struct fec_enet_priv_rx_q *rxq = fep->rx_queue[i];
+			struct bufdesc *cbd_base;
+			unsigned int size;
+
+			cbd_base = rxq->bd.base;
+			if (bpf->prog)
+				rxq->bd.ring_size = XDP_RX_RING_SIZE;
+			else
+				rxq->bd.ring_size = RX_RING_SIZE;
+			size = dsize * rxq->bd.ring_size;
+			cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
+			rxq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
+		}
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
+	unsigned int index, status, estatus;
+	struct bufdesc *bdp, *last_bdp;
+	dma_addr_t dma_addr;
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
@@ -3490,6 +3727,8 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
 	.ndo_set_features	= fec_set_features,
+	.ndo_bpf		= fec_enet_bpf,
+	.ndo_xdp_xmit		= fec_enet_xdp_xmit,
 };
 
 static const unsigned short offset_des_active_rxq[] = {
-- 
2.34.1

