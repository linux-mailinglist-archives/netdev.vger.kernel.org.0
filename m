Return-Path: <netdev+bounces-888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D726FB312
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A0A1280F74
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564E517D0;
	Mon,  8 May 2023 14:38:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58E17CF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:38:54 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2074.outbound.protection.outlook.com [40.107.8.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7F0E4C;
	Mon,  8 May 2023 07:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mp3IvDfhNaR6Kh5B5bG88dYXwzbqB9BtF3GjQy1RKze/7mAMUJ1xk0qyVxiMUfAixZBclbQLZXGgRHmzSzPCvf8211Yj0ahfzbaqfARDc0ORIKkBaJru3egsI69sbNysJVxXGqazkG3lPOC+DPgs5dC++IA57uS840xT2WxZqJRqJIS5ITcY94WFBzMI7trLeeX9RpbOcbgw1cLsbW+OYHgcO9ggK8KlSzJuDhpZFhrnsMWS0AKWYV2V155dRGwbU9YECKISwS/ZQlRNTdqR3ZdPykN0lh8sVOD0KHTAUxtRu+64mKv1MqvFGvYsHNHURrtA4+kwYCxozIoC78n3QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUjOTXCujI1Ixal2+7VYOS4B39m/XSniOvDRXHTOZOQ=;
 b=bGEsVHhdLHhliiPuEMWiJ/nL08q5g2zcM0WQJ47zI731pFf/jKWpmF+/HlxrnnQl4/pTFptUUht8/3T5W+p4tyKOtropZOWNIEahYlJ7XwaKbR7vDfEteCj/vHwKe7zbbTlkPObDGLrOu1FhroxfB8+x8cHmNgmYTSZew3IttVxF4mhKyhRfaIHotnNBCbC8SXs5J0cEUfjQd08gbMOz6jxI++JkmMl824Qodz61nDeo2Dl39iBslWDZeHZxwey5tc/ovnTtjFMLVtJzQQ9LIkFmor4yoPdWFtUY3eAh2Be3DTZbpJicv5gzvOG6kYaPRjk7YARguR3AyJruiHG1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUjOTXCujI1Ixal2+7VYOS4B39m/XSniOvDRXHTOZOQ=;
 b=LDfn/BA887c4cvR/QytrHRsF3e8UjbJk3WfjA8/HCm2bXcnRcEqjUtXdwB03NnQmGDHzFwJUYWOVHPYNR9OD9lEOWZPJEmElhDWxqWUA2dO53gIgNeP6Hyal8UIpe7gdFJnbn3YLVMr8OshdlFhgJMixa1Tqx7PgsrtyU9XNaos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM8PR04MB7361.eurprd04.prod.outlook.com (2603:10a6:20b:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Mon, 8 May
 2023 14:38:49 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 14:38:49 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	Gagandeep Singh <g.singh@nxp.com>
Subject: [RESEND PATCH v4 net 1/1] net: fec: correct the counting of XDP sent frames
Date: Mon,  8 May 2023 09:38:31 -0500
Message-Id: <20230508143831.980668-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:a03:331::19) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM8PR04MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 0212e884-27ed-4076-a098-08db4fd1efce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/xP3XL7VT9IZYQOf1n2ogTAWq8DpcPcWJqR6R6Mmc17OA6gjg6UMJZj9o4GoxEDgF8W8tvqtRP/sxf5GlnU84GyWwX+vgeMWRYnzD1aX1NQ4YWqJonqQ0wmXSQL829EL+BTKTIAgJXrRsNYY5duF/pMUVRBw2sMFwmkNWDkw6BW8xSWtW46BAFDcJCYm/DwkW/YYzufcnYTUU6dysrFQ9QmYvVZzIBdPEao9QJ7mIvjkpSFGHsTbI1pN5OUOAHYxtoKp69cZTOPhT/I5kq60KXiFjqU+74Zz8TtFeIwBTkSQrChhmQgbA31jXZLJuPirXD7MyVzwz8wr3THA4JYWRcJY2YYEvOJdIhXpHzOUUTvBQ3L0ap4M/SNRjjNTcsBKl3vsbD9merN7qsxQcrc4y/Qd4IHhGkrvjltYfDRLu8HWpG6G1mJfFp3Qo999Kr6sNfHfdmGO5AS+3FUV3sv1e79KgnZ7Dja6pnMGOxkXkpWzuA5W68xTptVjFPZqwKTqi+e+nZe3UwQk7gdkRSaMQ4Vk309rbFSQYV2Xip6Oy3Gf+032Mzxa228CwA07UYu+6Ohhl2J7rxrlAwNhGuRssF43rP2r40lpHMf6whyMSN6VjemMbQAWBISHZT+hd1Ra
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(38100700002)(38350700002)(52116002)(54906003)(110136005)(6486002)(6666004)(316002)(36756003)(478600001)(41300700001)(86362001)(66556008)(66946007)(4326008)(66476007)(55236004)(83380400001)(186003)(8936002)(2616005)(26005)(6506007)(6512007)(5660300002)(8676002)(44832011)(7416002)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3DUcvYUliLujvAwxjcn+DaNcUVT+4lBGqtOGJQXuZZkxvqTJXxrXdeoOvVNg?=
 =?us-ascii?Q?+2wVzIcHCGwzXHVywLMStXBntyAuDBgsLnBj2jCSTi/N49Rk/MtcF/heQAEl?=
 =?us-ascii?Q?ZyJmW/n6jbWIZItwVtv8tOh/Hj6VroOVHGZIGFZ1vg5LQ7iuFCu4jn9+aw52?=
 =?us-ascii?Q?kpLDIDuoz3i3VcOvzOyDQaXlYLmbxA7mjNNnDFtvMaivKdet00AFj8yxEC2E?=
 =?us-ascii?Q?QaQz2xWEL6vVm9ygUIfVoZn1AIEKDXHced6bMyaDKL5zPfL+ocFWOEvuAZd2?=
 =?us-ascii?Q?WGQ7GxsrWZx6vP18FQpoWR31Fi5IKTyNDuBo5YJfmY5GYRUFiLNwrKLM/hA1?=
 =?us-ascii?Q?UaN9bRy3Gr25a9l5i7n22XcHuddFxv34e5ff1JAWLCaElunRcU3SdM0c6h5h?=
 =?us-ascii?Q?7F6JURXRPgJxlsyLPr5NkqRXLF+DxbJnaLCpTGfHmd0HRKwiMWMJxANiBSTj?=
 =?us-ascii?Q?srniHVpqe0uhs734pOjONBJEwGBY5YJSxqTmjxr1WeJfewlyfgm6Tjf75JmK?=
 =?us-ascii?Q?VmeN3RZbI9dj1/qHb8xcX5JHXQI88MG4Ha2OgDJBmAwaj4/Dlue5Gvyt7C2i?=
 =?us-ascii?Q?gBkBCIPLW/LDjQHoHG9AASEUyRe0V904zcHM+EL4kCYEBN2mSBY/4NL98VcM?=
 =?us-ascii?Q?5V2ikdo4uqYn7JkcgzSutt0z1QyLXyUgmJrqSKaj4N3klYQazVo8Vo4cuMh7?=
 =?us-ascii?Q?Ffxmx9V1XNncGqSBp0GT22lITPxRjb3rPzpS0i0DwhVUSxYbdlZWBRw5H5AT?=
 =?us-ascii?Q?0NNHqr3lN1YiWkHqIExsY+wArkMH4Gn9pZFM6eRsrMcB5qc7f2RcZdrGf3uf?=
 =?us-ascii?Q?TCxnYVFx+3xXLQ13wGjtPss+xE1WmwiTLzhDVqqrcTFRukLjgqp7mrJRBbIT?=
 =?us-ascii?Q?ud1JRM7qTgYvqMEcLvqqDQg6jTe+15SoRAb7zqrcwgVLMjxF/s5BCKrCDfyJ?=
 =?us-ascii?Q?edc3l0DSYf98SGoSuy8EO9s+Of52uLYCErL9ODAH1SqitxRlDjsK9vKynQrM?=
 =?us-ascii?Q?dEa+jfRyb2nMD929zt09wDt1hddTVwrOXL4GoecICtNbN9zsX11G1iDlYGEs?=
 =?us-ascii?Q?rdI66uA6XZMIearSmVjS+dQC3EdVzFgecO41cdQX/4yoni3jWoQ9L1msc3fW?=
 =?us-ascii?Q?h0E7onyb0gXv5970ILUmXKy90dfecUrz+24JWduWH5BVfIoToDEo189EDTzJ?=
 =?us-ascii?Q?vG2lCSMnLaOCCi3SMMcrRvhpcCjEmVZsc7EyyZHwL+6xSwMooohUGHM8xXbb?=
 =?us-ascii?Q?99uBk3nDPYKyUEdnZTT/deSXfdXFp2cnL8yBGIBWRaNTa8ghGRgXiBg/jZE1?=
 =?us-ascii?Q?i1fqDE7vXuoEvb6NH40etej86ydU5JeTcuQ6SiXjbHkhXJBXXNtPLoIVg1JE?=
 =?us-ascii?Q?zZ6pdJvhT2HE2hyvi5Ktb5QuenzXkbvkh+b9hOFuuZdcm6+oEi0CRnVk68Cp?=
 =?us-ascii?Q?UI1E78z7kJNuNkYCiiT5G+F4HYCX8IbDT/INvo52HgGj3ChVO8fNRpGbtUrg?=
 =?us-ascii?Q?g9nYEOZ7zaV0H1GxmkKTfaAapfCCNc5vyepRI32uCEi9pF0GvkmzyPcE5Ufm?=
 =?us-ascii?Q?Vs4o5/fyqjiU/2lMv4AmLzlrY/uT3eyusyvLExQ4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0212e884-27ed-4076-a098-08db4fd1efce
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 14:38:49.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqHPxCk8nMy5t4eP3VJABmSNTj8V+0yhdZIa1ehRNRrEb6zoywgu/+ZSAqpHhJlRqGRNOiQskPhS83bZWwlddg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7361
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the current xdp_xmit implementation, if any single frame fails to
transmit due to insufficient buffer descriptors, the function nevertheless
reports success in sending all frames. This results in erroneously
indicating that frames were transmitted when in fact they were dropped.

This patch fixes the issue by ensureing the return value properly
indicates the actual number of frames successfully transmitted, rather than
potentially reporting success for all frames when some could not transmit.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v4:
  - resend for net
  - the tx frame shouldn't be returned when error occurs.
  - changed the function return values by using the standard errno.

 v3:
  - resend the v2 fix for "net" as the standalone patch.

 v2:
  - only keep the bug fix part of codes according to Horatiu's comments.
  - restructure the functions to avoid the forward declaration.

 drivers/net/ethernet/freescale/fec_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 160c1b3525f5..36a3ee304482 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,7 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		return NETDEV_TX_OK;
+		return -EBUSY;
 	}

 	/* Fill in a Tx ring entry */
@@ -3812,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
 				  frame->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
+		return -ENOMEM;

 	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
 	if (fep->bufdesc_ex)
@@ -3856,6 +3856,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct fec_enet_priv_tx_q *txq;
 	int cpu = smp_processor_id();
+	unsigned int sent_frames = 0;
 	struct netdev_queue *nq;
 	unsigned int queue;
 	int i;
@@ -3866,8 +3867,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

 	__netif_tx_lock(nq, cpu);

-	for (i = 0; i < num_frames; i++)
-		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
+	for (i = 0; i < num_frames; i++) {
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+			break;
+		sent_frames++;
+	}

 	/* Make sure the update to bdp and tx_skbuff are performed. */
 	wmb();
@@ -3877,7 +3881,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

 	__netif_tx_unlock(nq);

-	return num_frames;
+	return sent_frames;
 }

 static const struct net_device_ops fec_netdev_ops = {
--
2.34.1


