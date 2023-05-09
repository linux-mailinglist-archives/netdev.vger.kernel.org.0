Return-Path: <netdev+bounces-1248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D6F6FCEA9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 410E628137C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C1A14A92;
	Tue,  9 May 2023 19:39:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C62174E8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 19:39:27 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2081.outbound.protection.outlook.com [40.107.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC394EE4;
	Tue,  9 May 2023 12:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UebSHqaibrODI4hLl4K+8FII8JYVe1WQZcSRReBbyff0JCJvKV1c/Rfcp4Cn0hEGHSINA/aLZojmVOCH1fKvl7WDrvxd7z6q1P5MnxaIBhQcJZ6bKA+Jq6Q8eVRdha+/nHBaSvdg9bBDhqr9Irh0DnHpa340yyO+ItFwJJN7OmVtoFGuXq3MBh5RVJdicE6AHnl+LUMIxO3edZxKmCjXz1H7pkz9WUq8KVI2MnuWkS814hkUoKDySnxd5attZM3K/2kCaRq5+N2Za6QbV7v7/uwGTdgTEu9v4YXgwRZRQ1cDhvDKWCW+SCJCJ1nwiHLnc9rGQFqKcGUp9au3zGbBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EGPd5u6hNOZNDVhEzExkqKCgikBQi9KIyjSLctNLVo=;
 b=fkD+SjK3OinAxVzFPhZukuj4igTWJj+ImrhnaAFOtbxPdLUyCimv9HdLvp25Xstd/pTltV1lgRcfd4dddmSnaNneRsEpq7FsgwMuFTCiBTT7VpVSDI+bsI2KwNxcPMWvgdL2wqWS18tqAlkDVWr2GSNxga3/7ZE/lqftot8YSFy89NQVBnWkNUPeUNE0EdHD1cVnYNaQevzBmQ8pR8URfxFERT4drWWoPmwmyv2+TEFzw+Jmoe5wd6l4ukctYsbcnD93Lu39a7B98D8VgZUjbnqdP3qz6ChuxD0P39PWOR83Y65Qq/DMf0tA83rTCU5JCwUw9f61AVoC8locb3Ipeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EGPd5u6hNOZNDVhEzExkqKCgikBQi9KIyjSLctNLVo=;
 b=deThfI8ZIu5P4xqKKZPLEGko0T2HgXNi8EwYvhX3AWcwKt8zGAu1zZAZ0w/wwEZpe6KBh2mNsqw423QrsdgJ6MILKi2USseudeJA17R4061d2QjKsuACnSdZdfZZl7pT4UcINLy3CuDGb6H8UpfnUKToDcrbXrHzN4tAudXsW+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 19:39:20 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 19:39:19 +0000
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
	imx@lists.linux.dev
Subject: [PATCH net 1/1] net: fec: using the standard return codes when xdp xmit errors
Date: Tue,  9 May 2023 14:38:45 -0500
Message-Id: <20230509193845.1090040-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::20) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM0PR04MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b65eca2-f90d-4b28-a059-08db50c514df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	G6UoftVEYAmW9oiET3d+0Dm58P1D5UoRDMATSB9DXGUpEG/Kuecf+TDsRfnEuDtnmjB93p5u2uqoYYtPl4LruPswNtdLvbrMs/YoK8aggr30CdyQ4nyebD1LVVoXmTLzn5T5RCFN+GRqD2FE1MNxPW7sKu2hyoynoWoE+zdmJqIzLHtE2QYk8cpSiWzeWZkcqKnGLFMKYMCMPHpd0Yl2/Bjf9ZwmNhvfrRza7qS4P0QKVACOKAsOJ0qeAT5kuVJa+0u3NyeVx2ysCrMQur9Y/ReJL8Yn1akmTDzs4r1mWUYLxhj38mU4tYL3q0xnXBmG9bG+DlFtjQ8Ootn01RTrW2wKaJbD5dskP03ou7w2kfJgvxxwZh4zF5l75l/r1WlTL/CX/s6p8Ydce0QCcXomYY//6irnwOybIO0wvymBsbKsh/TXuJbA3GXIgHqg4dLJT9x53PkHqj4ARbWeyAlWKMvFsfpH0508J3C/sjk3BhgXEmsCvGdZD5/OAe+n6o2vgoYuxOwPfp5trKF0k7YTk5tDMAMOm+P6MIpk2vll8Bh9Z4LjmrJEpwF1OJ9+jPfyqUYetuamz2dBjal/6c4W3ySyr50CNqYJWosTccKPbHw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(52116002)(54906003)(110136005)(86362001)(316002)(6486002)(66476007)(6666004)(66946007)(41300700001)(4326008)(66556008)(5660300002)(44832011)(8936002)(7416002)(8676002)(478600001)(6512007)(186003)(1076003)(38100700002)(6506007)(26005)(2906002)(55236004)(2616005)(83380400001)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6a7W9JppOyRdtQzHlaTGvZw94g4BgCpIAkGxXasK2Zlime7DGAvzJ1TNtKh2?=
 =?us-ascii?Q?BcPkzOTEAxq7vmT7cxf9Qy6oLRIB6skRLcQrlgIAr33H/mqXPSggY8wZi3ku?=
 =?us-ascii?Q?n8AE+PRiaPTTrVWaNkrdFdPCnJyRs8L+NLXzHk7XtkAVMTqZVG57HoiIzTr9?=
 =?us-ascii?Q?pCPh2TRusYSE/9CCxOxJ/YmKbJey59+Papdnxj0BKJKc2ZGZbAT21uQ+IypR?=
 =?us-ascii?Q?+fatOgGGwCPWT+14+reo6Cu4hDD/UZ4vW2CcUINe2CQPqKP4ivPIwuTHmkIk?=
 =?us-ascii?Q?c1t/WvPBTEZ9xcmCWDRud0J6PyWPj2X/owWLP5TDyoWPaceNDnXlYxI2x6tn?=
 =?us-ascii?Q?kFLOaXyScuHaKF8FAJ/ky/s/yPJrFRIr6jzOq6labrJOF7Hh5jUhJO0QBnvo?=
 =?us-ascii?Q?CAumuvAFVbhGMk1W9/iknKXmLUcADmtk1aVmiK6d+tgvwnutkKIxPItGu7cM?=
 =?us-ascii?Q?vRr9GVakRHD7969doTEX8P+6d8b7ynl5JcEY2P1ar98WX5bIS0w/c9G6jL3E?=
 =?us-ascii?Q?IdEI9ni1APW00PoNKEPJCBYJEsETcm7ihgtnJzybNYVEw+0Xogqk3PmOID7L?=
 =?us-ascii?Q?Tsj4zdNpI/cEI18UVpw0hndj39szZiDKIS6j155CxSGkvOMuPlAiiBzshHpE?=
 =?us-ascii?Q?InozaAh7FVuYNKaYjoE3vOKzaAsnpn3K7L7MTmjIOtfs2Flp2XrBstZBF7n6?=
 =?us-ascii?Q?IN0Xu7l6IOKl4EChFxUDRlaIWaZ2glmDYhe/g9BwggTn9/fzPVBEkdH1QcIQ?=
 =?us-ascii?Q?c0VKyalOGuE/8cB02G1IX9aJ5nZ6rnum1G1g5KB8PKXimc1XomIJUFu0AQqn?=
 =?us-ascii?Q?W6hoZff6ninbaocdjJkkAIjUpCrOrjY1ucsqxjfOK01kYud+yYLg6SOhBko0?=
 =?us-ascii?Q?hlGkOjxT3BVr/eBSobwybxN67v0XmdDtPErkR77MmAT3CPnIQE8lq1Uhyfmw?=
 =?us-ascii?Q?lUa84lnCYeNp2NlM5AROieg6wcYvnPVzwO5qPD6Prk5AjaA2BVwqRbm01mNe?=
 =?us-ascii?Q?GZmlfjSq15n7x//38JDyxEMx/nUgBmcXXvCtjK2Y2ZF85K0eGje0LlK6/DcP?=
 =?us-ascii?Q?v3XwSjB2RO8AkkHQm4UCQN/ZKnmQvfRtipUGjNK4StTS28v3m9tkbYpxPqh4?=
 =?us-ascii?Q?WMl9UbCKVMVu89nywNYJBkMqjdg3eJVMo1FxcNxT7IkYSP0D8r+Ujbfyoiy9?=
 =?us-ascii?Q?EORQHaflC4obgzSyy9UNFv1/9NBdJJlw/Ina31MhWGy5Zm+Yf0rZf+vd8nQJ?=
 =?us-ascii?Q?twNPkZdwJqY/+HlFlum1IbDvVnua23awl0/Vc/yE9RHJBdkqoO0/mbr3b8i1?=
 =?us-ascii?Q?h31bLAQJYqxFVDIAV0X8LYRfSU+uPmjYntvnppXxR9PCNdx561JrEh2nTMCd?=
 =?us-ascii?Q?D73CLPud8RWYvCqCqZYLBG83KZ1lwOtdU0JNQN4Z8M8hV4VQkYAD53qBFNj1?=
 =?us-ascii?Q?PENjpdnyROJ0fg80IdvWKkLMZbusOGhMRZlMlQ0xpBRpePB7kzuZT8p0n9zE?=
 =?us-ascii?Q?2teLE+o3+t1x1osRzvjCi88yozodH50YJ4pmehka18VOxv4lSI1oAX7vrKJo?=
 =?us-ascii?Q?u++ETwPiFTdpZCiI65IZYEwUPpDgb65ogvs10eFW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b65eca2-f90d-4b28-a059-08db50c514df
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 19:39:19.5516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cO+AjZjsZmhtj5SCwN/quCgVoexdQeFUEVRXVxsUmM/3mBdvZKLedtiBDNi9k5kJWFcTl6FsjHLMP2w7YbD3rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7041
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The existing logic did not properly handle unsuccessful xdp xmit frames,
this patch revises the logic to return standard error codes (-EBUSY or
-ENOMEM) on unsuccessful transmit.

Start the xmit of the frame immediately right after configuring the
tx descriptors.

Fixes: e8a17397180f ("net: fec: correct the counting of XDP sent frames")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 25 ++++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..438fc1c3aea2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,8 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		xdp_return_frame(frame);
-		return NETDEV_TX_BUSY;
+		return -EBUSY;
 	}
 
 	/* Fill in a Tx ring entry */
@@ -3813,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
 				  frame->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
+		return -ENOMEM;
 
 	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
 	if (fep->bufdesc_ex)
@@ -3835,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
+	/* Make sure the updates to rest of the descriptor are performed before
+	 * transferring ownership.
+	 */
+	wmb();
+
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -3844,8 +3848,15 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	/* If this was the last BD in the ring, start at the beginning again. */
 	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
 
+	/* Make sure the update to bdp and tx_skbuff are performed before
+	 * txq->bd.cur.
+	 */
+	wmb();
 	txq->bd.cur = bdp;
 
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
 	return 0;
 }
 
@@ -3869,17 +3880,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	__netif_tx_lock(nq, cpu);
 
 	for (i = 0; i < num_frames; i++) {
-		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
 			break;
 		sent_frames++;
 	}
 
-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
 	__netif_tx_unlock(nq);
 
 	return sent_frames;
-- 
2.34.1


