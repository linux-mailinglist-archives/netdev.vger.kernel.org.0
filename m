Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52C360B7A6
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiJXT2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiJXT2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:28:24 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060.outbound.protection.outlook.com [40.107.21.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E138789AD4;
        Mon, 24 Oct 2022 11:00:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcsNaoDJ8e8IVB5zQyg2QI9vSaB98f/rjBvMmHX2z55iYWB3v9yTXZts/YSi1Bxx1ouYtFfiEx0J8yozvFfBmmty+Pyqw9y8N7xAAuRKBsQR0Hn+vyEJp+uUppKT0APYEIrt4zUhdyoi1jaRKEAfB4f+nluNEQOxcXYZDTTGfnEymOlFY9De07viyGZ0mK2AamikCXJ5r45iDNl5Zak8BlRlBYocTxxvBmAx/q9y+3E69+lxHTkn5bleNTgvl+5DGxtLAp11gDaqmjjDAXJXVUMfthoyShT2loN6q2Pc5WYQiKxJsz7Pp1qTx5C87qztpY+zA+Qxs3km9rS+KPgc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTdZENDnAlB3WGZgSUV+RqEFPZDGBtss7vabhUgnqvQ=;
 b=BhDM+++VDtQDwn9eRs0gBUYhU+tzJTlDGnmibmQWlIMGG+jrRD4DzwpmRAR179o9tn/8SwIT3nOSJeIqX9wcXIEEG/whwx3RfE3IDWCkmj2I3J5jqNVj/NqtPc8gRa5C+FsCamupQCcSiGPeqrjCw01lQTGAbWu5xP4nPvx8za6ybz3VICgoFt1+OmQZDt4Pb06cRZ8Vkd4q5M1CuXrvbqmKzPtOwAsIGFhYyG/7jcUFsy5mNFH4l6XRbY82GDTg+Gx8eTKRCjGatc0WTWY9+PAbCevzd3QYleY0szWF2pBBx9vibuEmePHpo5On46zS4Ty8LzktYDOpzfPKOj8KBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTdZENDnAlB3WGZgSUV+RqEFPZDGBtss7vabhUgnqvQ=;
 b=cB4g+29NRGovqIZmxToaGhyKISthdM+Yk0tmEjM4pjeIP1LH+wVZEu7h+JaVPXFB0PRanWj73nP6e7dIFADcBAFufdwhxCSDWbbzXwG01FumZ8qCtiQ8LqTwLRWx8uwkTJkoLHHjrCysKU8HXx+Xo0/KdDalrez7M7iC7nGgJVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7003.eurprd04.prod.outlook.com (2603:10a6:10:11d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 17:21:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 17:21:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: zeroize buffer descriptors in enetc_dma_alloc_bdr()
Date:   Mon, 24 Oct 2022 20:20:49 +0300
Message-Id: <20221024172049.4187400-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 4618dcda-9908-4a73-e115-08dab5e42248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esQ9NGUPeCKZWubSmECc/XimKoJ7AR3/E1djEfU10RHQJFHsCIqL5yBLAoXj/5lP4Fs7CBdLMBLgNE+fUdu1aUXjQz57JBEd5VKmdzKt3mAUu8zjmJTU5qfDdTSIDbbDhyjRSBjOc5HsSUuUvDkuNQ2QDArRlMHNhYfW4cEAUzX25WOHcUGi7Hl0KvJAV7SLachOoA1LoyERFSSLFOzapXciHC5YdHOTDtAOcGaOmNz6J9ESm1oZAP8/gdGn1pYAIeZ1HB+P8hEvYli7OvGIWn/mfcp+BO0d+Q6ceFY9JsRwDOc32oW2MFy936Psb0BuT6fg4Y8MYCejKocpjDa/yCW7ceNXwV2o2SaNbBw7x6H5ErqsrwbqkJsubznm36aPu1DuUNP9b3n7QqM3DHYAGvvqGJc7rjeXKbkn264lqoDdBN4AF2TXoBkw/comCtLs6v29BwYagyoAJIYVy4W0diPg+aHE2GwumR1EYwY+6WmZv88pe68b/86b4a3XvfGhhSOuOzNyEsfMzWsc/NDHXrdtFoo2m+7KNb1hRUR0/RYj85cmVaMb0w9N3FZ0IzADDv4kH5B9d/DQek8zc9qrWxQKsZbIizX4qnNRpK54GpT9AhUVnPDdjDhEJ0w1sIg/cLqXmOz9wlhqW57B4awBYzGmTWy9y7HiUHpVw5rHBMY03IqU7tL6dW0s01JH3Tzg6023V4va+82naxZH/Av01kU/KNGHuQHmtal0QupSkT2O5gBXgRNkj4rth3yBVUbSFBq0xha/VrwYw5qdY1OfJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199015)(36756003)(86362001)(38350700002)(2906002)(44832011)(1076003)(5660300002)(186003)(2616005)(38100700002)(83380400001)(52116002)(6666004)(316002)(6506007)(26005)(6512007)(6486002)(6916009)(54906003)(8676002)(66556008)(66946007)(66476007)(4326008)(41300700001)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XDMETNTMAA2Kf3LwfjWjlpf+0V+6DeI7nPIVmyhkMnWbzyTVwvSg7ITmypCq?=
 =?us-ascii?Q?Q13ACmHqIB3j7mJK81RMDWCg/LXstpG2csLHr4F8Pcl2hG3tVvGXAMNiJpsn?=
 =?us-ascii?Q?ktQ4TUNruH+cMSIKcJqgdd2oYBD3Ibk2v41vYgdIiwdX9STa8HgzUNUdgL28?=
 =?us-ascii?Q?xvvKryXC0f8SiHQ3wuw5Foua8sJNCkU/z5woqlmnp8fnl9aidb6o5qturhw/?=
 =?us-ascii?Q?ywehmlNuSeYQpO2C8l8XxA87ZFucpAc3Ct8q4/0Zx4ZuNd+OGEEM5FOhk0LZ?=
 =?us-ascii?Q?AKPylsh4XX6nwpzAJlrM61ZteCMGizSYekDIIs17AKojbrqB67xbAc/MDEzj?=
 =?us-ascii?Q?UaEEuBtHq4DGt46IxPydVK5MeECkASROCj6jc/l9HFggVNLXDf0T30azOStM?=
 =?us-ascii?Q?zOEQFTloewWrgJQuLG62thmq5NeKQjWe237x9PmJqpDcpCgFbaXJ0Iz1s+fW?=
 =?us-ascii?Q?kqQA2iPCH4oQGWPhObSUgTtR6ztH0n8AZbOHRre+xsmdCyyHieAlIJlXEmQB?=
 =?us-ascii?Q?m3LUphi9LX/yzkC7zGxmheHVWD9EtDO0+S7NFhLsKZy7geOBndzV6J5U5F/J?=
 =?us-ascii?Q?biM4i/RXam9y6awjYbvSvuNH8GSJi6jeQ6XhUFzOrk3/Sn4PQHrgrvA6GyMu?=
 =?us-ascii?Q?1NFPGn/7VGCq1/SVj1LjMTdNpCWHQC+J5Mj5pMHFjdojSDJcqYX4GWZA/qj7?=
 =?us-ascii?Q?DyKi5bVNBujaOG/7xIS1SLYdxKiS9yaSZDexblf/FK2MACBPcSeGNaOicBC7?=
 =?us-ascii?Q?W9gEPS8PnP98Wfvbhmj9nJRZr73Reh3/6v29KBHHZ6yenc6PuHF0MvObOFEe?=
 =?us-ascii?Q?JlXDEgWjqRSsqqgdgjavLlqtQ0Yjtf0wrMP2lyZWJVTXY/SnjDKjmnsVEqyS?=
 =?us-ascii?Q?OIdBRH3uMvbKM8atNRKHbNJ4JA6DypiKTfuesMcpWPYjDH+TH1bA3uyhVgWP?=
 =?us-ascii?Q?0VhkPn1jYjRxYiv8Zl9Y2YJXSnQQJ129SS8ByEWIuDoSZ1yYz20cw+eUS3+a?=
 =?us-ascii?Q?/pWnAtamsy5+PHPm+eWPktGZjRiqGKWYU28YIWKrAToY2DfN5Mo2FguazFEQ?=
 =?us-ascii?Q?79BWE13u5lEyjvV06RBaeCoYPnO96sEfv19BfDXqSTSGtGUe2+uUJ7xFs2e4?=
 =?us-ascii?Q?H6zenh6xpTvfgtNHEPs5OZCiXT7q/nyQns9RHCiYODo/39QP4M/9DywTYLw2?=
 =?us-ascii?Q?GwG2XQLhmhQjJGbloNSNe1lRg6qirdC6D5Yvv5XvuHnHd8TtOwkl4DXH45Kr?=
 =?us-ascii?Q?P86J7LpPfbf/n68ImTaNpkGXN7SEur9saja7/yrQM6zFS6vvwSruWe1LOn2y?=
 =?us-ascii?Q?P5LB7XJW3ASPqP2gDVMUY5bd4ec1AYbw45G5pWDpfXcFE4ju59WaTPnWmLxT?=
 =?us-ascii?Q?51POiqu6wFzhhwGpaQVM0Un+UHRb481+/mULPk6mcs9jdf4TSKB2ItZ1obF/?=
 =?us-ascii?Q?Zxepbc60lh7zWShpo5JOD5ZGVL38XXVKicjh6DTLzptgq9JWDVKNpZjmpsXr?=
 =?us-ascii?Q?xgkB+t6dUG/Z+jxZZkQT7iGwjyDw7AvczJT/3gh4+KSovtSIdMGvbMX3zLLN?=
 =?us-ascii?Q?vISDfZskQLtb+KLhByNS+RWZbOVI5RR6D4w2nZAUXaj8b+jUbmv6se89JhCv?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4618dcda-9908-4a73-e115-08dab5e42248
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 17:21:06.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmKmiKEfhAXbiw2yyxiSOvWpcZ0biOrN3uRD531bOwQ1aABFmDsfdCRmwjfgSZ18ACbaK7MFaTI6I6/xBgdiBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7003
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under memory pressure, enetc_refill_rx_ring() may fail, and when called
during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
checked for.

An extreme case of memory pressure will result in exactly zero buffers
being allocated for the RX ring, and in such a case it is expected that
hardware drops all RX packets due to lack of buffers.

The hardware drop happens, however the driver has undefined behavior and
may even crash. Explanation follows below.

The enetc NAPI poll procedure is shared between RX and TX conf, and
enetc_poll() calls enetc_clean_rx_ring() even if the reason why NAPI was
scheduled is TX.

The enetc_clean_rx_ring() function (and its XDP derivative) is not
prepared to handle such a condition. It has this loop exit condition:

		rxbd = enetc_rxbd(rx_ring, i);
		bd_status = le32_to_cpu(rxbd->r.lstatus);
		if (!bd_status)
			break;

otherwise said, the NAPI poll procedure does not look at the Producer
Index of the RX ring, instead it just walks circularly through the
descriptors until it finds one which is not Ready.

The problem is that the enetc_rxbd(rx_ring, i) RX descriptor is only
initialized by enetc_refill_rx_ring() if page allocation has succeeded.

So if memory allocation ever failed, enetc_clean_rx_ring() looks at
rxbd->r.lstatus as an exit condition, but "rxbd" itself is uninitialized
memory. If it contains junk, then junk buffers will be processed.

To fix the problem, memset the DMA coherent area used for BD rings.
This makes all BDs be "not ready" by default, which makes
enetc_clean_rx_ring() exit early from the BD processing loop when there
is no valid buffer available.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 54bc92fc6bf0..1c272ca3a05a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1738,18 +1738,21 @@ void enetc_get_si_caps(struct enetc_si *si)
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
 {
-	r->bd_base = dma_alloc_coherent(r->dev, r->bd_count * bd_size,
-					&r->bd_dma_base, GFP_KERNEL);
+	size_t size = r->bd_count * bd_size;
+
+	r->bd_base = dma_alloc_coherent(r->dev, size, &r->bd_dma_base,
+					GFP_KERNEL);
 	if (!r->bd_base)
 		return -ENOMEM;
 
 	/* h/w requires 128B alignment */
 	if (!IS_ALIGNED(r->bd_dma_base, 128)) {
-		dma_free_coherent(r->dev, r->bd_count * bd_size, r->bd_base,
-				  r->bd_dma_base);
+		dma_free_coherent(r->dev, size, r->bd_base, r->bd_dma_base);
 		return -EINVAL;
 	}
 
+	memset(r->bd_base, 0, size);
+
 	return 0;
 }
 
-- 
2.34.1

