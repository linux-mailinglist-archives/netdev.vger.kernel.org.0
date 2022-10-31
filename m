Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF8613DD3
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJaSyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJaSyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:54:16 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2051.outbound.protection.outlook.com [40.107.249.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED97AE5C;
        Mon, 31 Oct 2022 11:54:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2c8Hbr8E1zCqiedSp/HusYh/4guUe76hKUsGid8++1+OLjRz9Pt2OTZOa57vgQVfx+uvON3xRe9TNhlhQnZuzf8xYvdIIS7vV4xVAmb9vlM+7JhTQ7hr8a0Z8deqjgsqPLMxRO6NYgYcS4TiYQrZuDjxQp/FPqhCnOqO7Tp6oTvcDAchsyvhW6keudD1BR4m2E0wPbJDFY7wiSH0bJ1iVAsTcfq3TuGJnbNnsRGeZjk0MGkG3ZzsHWgHtKZJxGzYyhiqheq4zDthLJR0jKPb/0uuSUaOJhrN95ZAtpJns+TvMkl9FE/Fxw/9RtaY46AR/S7SKJ6wscSOeWadSncTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmZlLSHpsbeGPboQ+tk1XiSvEdLBzdAys6AABS5V3xA=;
 b=lztq9el71Nv1H2aXZZyjuW7IVui7nNQBI0EjIwwSRPh9h7E09iMa98nc9bLL0kxOjSRi+7H8Huz5zKC/6BCzYUwoPfFje7ZAwj2SWbLVk/qM0pOVVOE/L4CgYYS+ChFF0eHxvfyJ6WsRZANCNoblMJ8p2G82OnBeTb+BKEBg+FP9+ZWw/0FtCWT5cMhTEz2KU8Lx4XP3ku88wz3blu2hMjIiIR1ZZo7uKIn+LaA4JVfVyFuAqwyOo88SYNv/Rh8/ytGGzrTux+47B73NzWyl5OJrYLt6XeikaBaHq63F+P+1L1OsvyvBROTqTpk8mA8g4ikrKhuc7R3UgfKeel8vWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmZlLSHpsbeGPboQ+tk1XiSvEdLBzdAys6AABS5V3xA=;
 b=HSYlY9IuvwZBZ8FkbNH5GUi/hjk+Ql03MD0Yt//ZFmhS3nlPc8Nv38ndFIqVNB0G3Pls+IJVkOyAfWGtZAyisuxMU+Z7VraJSDYT3uwd0fwbb/LH+wjfDDZwJQrQLAAmGmXeE8shXotLYMmUhJ+tQeMBO1gs+h5tZ6sE7BU0PYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VI1PR04MB6782.eurprd04.prod.outlook.com (2603:10a6:803:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 18:54:11 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 18:54:11 +0000
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
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3 1/1] net: fec: add initial XDP support
Date:   Mon, 31 Oct 2022 13:53:50 -0500
Message-Id: <20221031185350.2045675-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::27) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|VI1PR04MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: c37588e6-9f95-49cd-6d07-08dabb714c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPV50Idi5iYmKYR4nXrJkZzUw3oRZXp1Uqic34DHwVDi2G9hfgkyAnQi7Q3j0z3X13/s1TusKMWOW/CbziPtjm4+AkNhIwJIKgMS2IpnLMkbiQvuu23PEYt/ZgwDGZzEIQFkJwErXriQUTpw79xI4skVMAwjbaZEBB/HQOLrdTJagBqRr5heUHOx8/0xyxeGwYwWULQcl+DL/Tz6qkCeYYYWpu8OS2XlJMbilqkFW2m/WU7RDIqf5c1MZJcQ/teZ04wCrwf9vUafBHJP/QMNAntN+1Be8s0ibjx6hHw5st0zQE7l6Dr2KYyeK176iTrbOXcZ2EVc95MnNuGCVoCVBeCgYRWOMvAcB4EMLFGAby2yNC0OioEvOdnn8uXZnjIkbSwxCBU9U0vAFuL6W8O+mmnYzXDrV6xEh79kX8H6kuF5iDPelso3lX7wwM7nKYeRNkXkvXXWgTAFrZRtWoCPn942HP5v8iU8UXai2bMaiUehd4TQ4fkZCcxsQDLkxULayJwnl4Ip8w5tGftqF7mETjr9bM3r1fp/VS7zwDcYRVQVu6BU67oSE4mKPBtGd75h6bQiwW2/meahA1HoezyvneESVI7FlLEP/kgoYxwKWVBDTCjvTZNJOlPl4uxMlxuccpYB+nDjOpdt692ZjAz/jHU/82u4xJNH3eH9pn0URHZYCL1r5xXxBnDX3rO4B9exN80giLh3yCXAmA+TTVADXWFMmESZ8TmdEUbd85WdOx076vwSsIsarb19zrZwlDhM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(478600001)(6486002)(38100700002)(55236004)(52116002)(38350700002)(6506007)(41300700001)(83380400001)(36756003)(8676002)(54906003)(4326008)(26005)(66946007)(66556008)(66476007)(6512007)(86362001)(2906002)(8936002)(110136005)(1076003)(186003)(7416002)(5660300002)(44832011)(316002)(2616005)(30864003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8YbjJTACH+0k/vj+A3o3Y4DXxNH+BebsorOTipBTgM1KCl5s02Yd7TN7AMkZ?=
 =?us-ascii?Q?TJVTrVfTbwvBdV+3/kKV5qmVJy5CQVx808FKeIcJcNVEliZ0KqD0ylkHOk8k?=
 =?us-ascii?Q?IF57ym9jf0v1WcHZOYQuCwewGn1rrFnfQeF9TsxCgm69J6io6aSasDoQ0YkD?=
 =?us-ascii?Q?ZfvZIq8ks8tgMcDDwi8MBiVO8wCCaohjmmad2tSY3SfNa6QT7nk+TMWvaN33?=
 =?us-ascii?Q?N4znNjOwi6lP9cMVkfokIOxS3vy9cw8VdGEOLX+xUbGXvDYUbz8mkrGndb74?=
 =?us-ascii?Q?qYii+znqUp5RApfHeOHZHhlQHWki3hr7HpylyXHeSpHuQha9GAUaOA+d/ARW?=
 =?us-ascii?Q?K+1ireOwaj0o+ldQE8rUkQjA5SGJOx+etb0gyTY9bkvNXAiCkTMbgRVRALrS?=
 =?us-ascii?Q?OGpMPO9k8/kzvuNJXM1K0zAUmYEdaX/NI4bOIJVFWnxXf2gCTNP6aVAWCCr1?=
 =?us-ascii?Q?SXFdM/tRwOrgY11b1OELQZ+YI6Fj9gGzGLG/rYXja3Tc2vcr5yCoWBHUMXyW?=
 =?us-ascii?Q?I+mxcbZt8jnwrr6rDS0tWdZijt6NQ7WSTrIWmx4x/T0SUbc8WjBeZ5W6Zh2V?=
 =?us-ascii?Q?TojSeKGHQ4zIqBoOmIAXzH1QSSr2XgzruyH64Wf9Mm/oBSDbKU5U3/t4SeBH?=
 =?us-ascii?Q?WL415+BbF+vGvUm0BKX3gmtr+DaPg49O6EJj3MwMa0mDKHqWmJcaSUQah5Rl?=
 =?us-ascii?Q?7B9iLJH13o6KSA6n6YRFEXk/5rGqw8cRxdBPyV1Z9qF+Mz8j3wkSZf6LsQG5?=
 =?us-ascii?Q?2FhDG/I5W+SJP3HP0POzqpOflwP0Dfr4kK8RgBbSL9W2XtixZOYtBQBYHUkq?=
 =?us-ascii?Q?7Y2QYb1qqGahVM5B71SUrbSLC8Jn1vDc4OkO68SvkQYHXn9U5dxmD3nIfeYO?=
 =?us-ascii?Q?BS6JkoJuhaPPgd0VlYeBHnL831FtrNGWs2bTtWAaUEs26PRoMKBoorHTV4Zt?=
 =?us-ascii?Q?tqYSuTX7sOz4HKnVs2v9hUGuWPdee9AICzd4jnQjgPT/knGjfSTEuxk7E229?=
 =?us-ascii?Q?PA93dFO2LJ+WU1USLpMrErhAht34Tl7KjcMpQhIXND2hCQywbQfq42j2zWbW?=
 =?us-ascii?Q?kUbXORCn7dXLfnvKfeag2HIy32Db9GGdOl+T3ZwjQaE2C+zuqrTtsWNCelqe?=
 =?us-ascii?Q?qeyClaHCUNH0z0Lbl+h5fpE+uUr+bd+/yeiOMMpLOkCmEOtr0nTwU4A0a05r?=
 =?us-ascii?Q?oKKuj8r85ViNGeGHGB6SokuVYdqFanIm2KXCDsNlad7i3AkchX5gcQ9Pj5j5?=
 =?us-ascii?Q?V4nVTkV1UIe1A3CIwWYvuAYoUsVMVQezQanyheafJ7fg8ji/jZhUjNcCkBs0?=
 =?us-ascii?Q?HDLkrIcMNBSA3t63I5XazWfuyJ4IRMTfiLlqFOEtJtnaWsvOphZSDavyWpaX?=
 =?us-ascii?Q?BozR7xKtYGVPBl+8cdq/Uyrifk8nMBfKRBNsM1Q1SouvcCpDOwI/LF+vJ8XM?=
 =?us-ascii?Q?JtiIs+2KyAcHdWd0UEOOteaOwCMDdWtKQl51lDzKXX8RmAED43JtAhl9vFcB?=
 =?us-ascii?Q?f/zRJX6LPHRwAzkuU6SpK6FcLnIpCx3aht/1KTao4qO2ri3Zvma4vSgf/J8U?=
 =?us-ascii?Q?nNWUMhRoUzbf0DFwaVFNSUcfmOHRiBRjOirJ50j+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37588e6-9f95-49cd-6d07-08dabb714c22
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 18:54:11.2798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjPCJi2vfMdLz+dWcqQsk7bUVpZjjLsaEFs/8Zh0m5DqdyehmzjP5/sHqvXeMN5XhISg6LLKccuZ1vLzcfAPIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6782
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

I just tested with the application of xdpsock.
  -- Native here means running command of "xdpsock -i eth0"
  -- SKB-Mode means running command of "xdpsock -S -i eth0"

The following are the testing result relating to XDP mode:

root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 371347         2717794
tx                 0              0

root@imx8qxpc0mek:~/bpf# ./xdpsock -S -i eth0
 sock0@eth0:0 rxdrop xdp-skb
                   pps            pkts           1.00
rx                 202229         404528
tx                 0              0

root@imx8qxpc0mek:~/bpf# ./xdp2 eth0
proto 0:     496708 pkt/s
proto 0:     505469 pkt/s
proto 0:     505283 pkt/s
proto 0:     505443 pkt/s
proto 0:     505465 pkt/s

root@imx8qxpc0mek:~/bpf# ./xdp2 -S eth0
proto 0:          0 pkt/s
proto 17:     118778 pkt/s
proto 17:     118989 pkt/s
proto 0:          1 pkt/s
proto 17:     118987 pkt/s
proto 0:          0 pkt/s
proto 17:     118943 pkt/s
proto 17:     118976 pkt/s
proto 0:          1 pkt/s
proto 17:     119006 pkt/s
proto 0:          0 pkt/s
proto 17:     119071 pkt/s
proto 17:     119092 pkt/s

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 changes in V3:
 - remove the codes to update the RX ring size to avoid potential risk.
 - update the testing data based on the new implementation.

 changes in V2:
 - Get rid of the expensive fec_net_close/open function calls during
   XDP/Normal Mode switch.
 - Update the testing data on i.mx8qxp mek board.
 - fix the compile issue reported by kernel_test_robot

 drivers/net/ethernet/freescale/fec.h      |   4 +-
 drivers/net/ethernet/freescale/fec_main.c | 224 +++++++++++++++++++++-
 2 files changed, 226 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 476e3863a310..61e847b18343 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -348,7 +348,6 @@ struct bufdesc_ex {
  */

 #define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
-
 #define FEC_ENET_RX_PAGES	256
 #define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
 		- SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
@@ -663,6 +662,9 @@ struct fec_enet_private {

 	struct imx_sc_ipc *ipc_handle;

+	/* XDP BPF Program */
+	struct bpf_prog *xdp_prog;
+
 	u64 ethtool_stats[];
 };

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6986b74fb8af..6b062a0663f4 100644
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

@@ -3476,6 +3554,148 @@ static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
 }

+static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	bool is_run = netif_running(dev);
+	struct bpf_prog *old_prog;
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		if (is_run) {
+			napi_disable(&fep->napi);
+			netif_tx_disable(dev);
+		}
+
+		old_prog = xchg(&fep->xdp_prog, bpf->prog);
+		fec_restart(dev);
+
+		if (is_run) {
+			napi_enable(&fep->napi);
+			netif_tx_start_all_queues(dev);
+		}
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
+	int i;
+
+	queue = fec_enet_xdp_get_tx_queue(fep, cpu);
+	txq = fep->tx_queue[queue];
+	nq = netdev_get_tx_queue(fep->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	for (i = 0; i < num_frames; i++)
+		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
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
@@ -3490,6 +3710,8 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
 	.ndo_set_features	= fec_set_features,
+	.ndo_bpf		= fec_enet_bpf,
+	.ndo_xdp_xmit		= fec_enet_xdp_xmit,
 };

 static const unsigned short offset_des_active_rxq[] = {
--
2.34.1

