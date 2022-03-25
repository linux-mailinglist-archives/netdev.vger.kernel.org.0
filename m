Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FF94E6E5C
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 07:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244873AbiCYGwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 02:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239394AbiCYGwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 02:52:34 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50062.outbound.protection.outlook.com [40.107.5.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719831DE4
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 23:50:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVJB3tgzL0aivtwb2AE//6dApuFys5EaYPAw+AdJ8U/66lpPfYHyMxB4BS62LKwN6s6nj9SF1RP2tS+TXVf9q/PZjXp3yqmCKCCeLwh1VRgduxvGiQbKeVLTIgMsVkQrAzrdQCOC8gPVInw4jloq7asZdKMi3wHAJ6QwaBFPfEx92lJMe3e8lLDqgXjktAnHVbxlbxHTii4tIOdZ9Q51tLG9LixMxDq7vbTyjZW4eaq9fDg5DTTlgCak31dnVWwVBukm0g6a+BHi33rDTO74QtHctl+fiRK6iAN2551VtuHjoQSp0h8pWJwQr5MLLF2pR/z/tzyufuZiFuFavKfe9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/K0tYg9AT2USg0ayepb8Vh2xGZ+cAql60+7XhoPO3A=;
 b=O3nb5062e8jHafmXV+zg+pTL2t0/RF+jivXDZMpjGWHdpY+eVCQ//yQPZ51+7GBUg+KpNilbxFJnJ7DaMpLSRozCuZQSybwr0NhoYf1BYVsvKX235HNHeHbJvwVYaglb4dtP3jL3yzYRssNltb0mP+xVPZHVK1aaSxaq16aHBIhACx/RBZ+5rKzCU4GQohostPwgc8zqlEHjfInEnhgSyr/7DxCvHNkC1yAVIbvSG6LwZPB8whjZ1W24cN9KaZMZAtu6TP47cVxtOCr3/qDRl7392AvwAeHwnjG3at+703UKVbtY9IqoZgJ4hli6MGihbNUyIj8mE3CmoKKj1g9qsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/K0tYg9AT2USg0ayepb8Vh2xGZ+cAql60+7XhoPO3A=;
 b=cSAtPaPebXOLIEm0khkS/jwEIm1Ws4sseLHriR8ukMisOkBx2H5fqwCPnUgREjtaMuyQY/f7kFmEmP7BhgZkvcgrBARoF75SA7pkMsb1p//vA0WFIBLiHteOtzBmAd0OjMKjLKlWuP4+EE5hfpUAFmR95Wvt87IgSyJ0TenO58nXSGRyn2KUFfG0q+AraD2ZaX8zRoZbCP6ry+tpm4dd+n+Z0g9x/XjQvuu3nGYA9M2IZLkQIUGyoYB75up/XtGPg7J/jiCoVY01b+YR3NMiumucnPXa/BXnd5jQmf7D3xiyDW7ra4hG24NrNgaJ8xPJI6in5Xe0tFsqnDTBNOxuXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by PA4PR06MB7311.eurprd06.prod.outlook.com (2603:10a6:102:ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:50:55 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.025; Fri, 25 Mar 2022
 06:50:54 +0000
From:   Tomas Melin <tomas.melin@vaisala.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Tomas Melin <tomas.melin@vaisala.com>
Subject: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Date:   Fri, 25 Mar 2022 08:50:12 +0200
Message-Id: <20220325065012.279642-1-tomas.melin@vaisala.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0110.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::17) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 510ea6ac-65f0-48df-cbe1-08da0e2bcf12
X-MS-TrafficTypeDiagnostic: PA4PR06MB7311:EE_
X-Microsoft-Antispam-PRVS: <PA4PR06MB73113070473ED8188405E1CAFD1A9@PA4PR06MB7311.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CblUuTEnhs+YPydBHCdA9LHbxd+Go8jcGBafRJpJCtoTtY9YOHUdhguUvYFkNBmd1oJJsbKLhUB2Xp0WbdwOR9tFswIvsuTxbSfbLinDiaG2DOQ+7Ui9fyQKBOYDTe6ZZgpxvZDNS9IXTG6lTv2x1C90IatibZN3r+i4K+s3tSF6tE90U8xigEVWiUqAQhnqSfDfM/S4ZWYwW4Ci+uVd7Lv4CSEqHbKPBPL/Ibby0MbXxfCIadt6OXcHlOH3n5B+CTcU0sJr3DrSagjhFswBKWtm5aFFaBG5K9DxtcHFe54IUBwd9lZ7ChTwtTdFRLEx0GeeFu/8295t7aVVtiXmsswac4sucpgsW1CAi5LMjwIQnU2MTRO7bYI6EQEpxLfLC9RS8WPpVH8YA9aUSEcDTh0yFgFEKyAEPIzX44dPzuLGrP506jPMQqFKWQYg6vVmpkdIaa6zp5yXnP1Ymx3Fztd3m7mu211ot75GsF7E5HZjnTIjX35zCofkYyUmV95UPPzBmMNClme0vbB2k7HkGjqzFEv0XW6BkQuNT4+V4wG03httplwrr2mjlncbIx3fk1X5KUBU/5sriEFBHG+h5LTUu4+80s0/R3Y0p6BM2G7vIhnUBK9C6Ye+xtrS3gIa3ys24k7/+aCwGlcFRVhnT/uzn2XKETT88G8y1aAupMQZ7H+PuqgVJaQu8cmGsn2qLezIebk8zyasVkJvDeU6Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66946007)(4326008)(6486002)(316002)(8676002)(6506007)(2616005)(508600001)(186003)(66556008)(44832011)(83380400001)(86362001)(36756003)(8936002)(38350700002)(6666004)(5660300002)(38100700002)(6512007)(26005)(107886003)(52116002)(6916009)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UZlgs4BDh15HGkeY8tUlE5QhlCiU/yYXGQoIidfwP6txTzfvrK/PLWIpNh/p?=
 =?us-ascii?Q?0a2dTObsGGQRpMI+mGXw6wyx3cIisOGWV2v7FO3Wofiyk9gSOCaL//dM1cTp?=
 =?us-ascii?Q?mrxE5h73/2r+6i+ZWRsgSRId4SkQx8EDZDptC1Ba2RIIei2yZmaeEMQU7+8w?=
 =?us-ascii?Q?0G1JIapUEoOUkb02+Nd+UMnkKmUhsjPP3qDoGRW/D1vNRVz8rVLymHGxv/Ja?=
 =?us-ascii?Q?sOFobMhapwUBUhfWLzSsnIs49tz39GXbSn76mW6moXoDjGXc8QFAge93+0i8?=
 =?us-ascii?Q?vT6K4uZ0Zt8mv8x2iohZ6ORfMUc3Ls80j1C6aqD4Poiy2OUsht1iRpHgYihP?=
 =?us-ascii?Q?ZpVDdeXTuKrAE1Is5KmoyQl4JT63elB9zuEkk+xz6SAig//BS/hqZJ9CGG19?=
 =?us-ascii?Q?FD6dR0R5uyoaRPDBhSWWbdcjk9IQqPk+7GsG4vH7xzdrxYShRLww0cojchLq?=
 =?us-ascii?Q?qchtSfMGbiyQxg3V+k7NeXyw7nGR1HAmJvSczKaQS3hQiIH5OC6JgbbfGlAP?=
 =?us-ascii?Q?47MZOdXYAurQFHujIpd37AwFFxUne0U7UIrW+MkhKTT2BOQ3peEsGigNVw0M?=
 =?us-ascii?Q?k8MyHfBe1CS9lVD7iC4Uyq8TRuSnN+r8Po5+WJG+WCTLx9m5mI+RvNtdEDR/?=
 =?us-ascii?Q?5rdF+tYJ6laWw6CsHZViIAs5/lP0Pg8lXnzeC2SZtWE24fgcfRtLbEfxbXuU?=
 =?us-ascii?Q?mOLuPSToRaqa8R09+7gwIILg1ip6D0cBjXTfuz63KH0j4/J4CNOBYxIhAvPb?=
 =?us-ascii?Q?cG9qDzcPSkMgMbQmVi6ppQGx6sWv4eutkGVXq4Nh71dwyehW8iAciPe5fdlP?=
 =?us-ascii?Q?670HvAhsJdMRNOAyYRh520r97cXBvnU86eJj/UyygcOpf4UWtI2Pl7YGTy9B?=
 =?us-ascii?Q?lJ77ZhyYSsdtx6cP+XJE3QKL3OO2JoAiSqIKSeOXPvGCI+hPHf4bLhJzf4eK?=
 =?us-ascii?Q?FC/EchTal0K0cbw83LZYHNs5BNcAuPKHnJQI77wlNDJTeBdIogd7qFCuYCjC?=
 =?us-ascii?Q?yvXkzveQDDUfilPjqr+slhMqBFJ+WqBJDAsa1L8KCuDR8XOmjO3kvRDnk+n1?=
 =?us-ascii?Q?L3QsOFRdFPMeAKpJslliQG0zLwM6BjcoqlLkxezGWjRNgT/fhry7VihEkPBy?=
 =?us-ascii?Q?VpV/B3EuUAGpIOdEGVEYbK70N2VXiHNlhkejNTLskGPy6XF2G+wJ82LHx9xV?=
 =?us-ascii?Q?D1GFwK5Qm0FlbW7WbyEit9tQNIyC6+iEACVI3RM5Qb+4Ecy6kQx82a4CwXa6?=
 =?us-ascii?Q?7xv599M2Fd6bQeFfSuNQ7GuHme1sb0dOi1rV0jnFAt7Lyr/irHDRA873wbmR?=
 =?us-ascii?Q?QrjoA9SdBG7dl5tNFWjobsa6ejSUewjsWkn7l4DxIRAb+vRCXw8qufTTSd0X?=
 =?us-ascii?Q?jABwd3UpraIZCHfq+k3XF1AsTDro+eE/f/E0/5dxGpG5RH96k9gtLjDnxyyV?=
 =?us-ascii?Q?39s5Ahj33Cpq0Sx9e5HFLs7JSOeIhKVbeFbWy9wyg6hrOjzxG51VYlAih406?=
 =?us-ascii?Q?GWd14mp0TK216U0moTCkDklvVp6KoruL/lc6KXhZr6FkZNl/6NwMc8e6hAQz?=
 =?us-ascii?Q?BQRu1L2HvbzHe47SpOUuQ9rrPoRDrXJQ+J+BSYzc+sNueFM5qZLRgmy4Jwa7?=
 =?us-ascii?Q?toFqT5tUJkuCCMUkclobEE/NgHNoTCnxRvIgWCWaqdsrIolZWb/JyaBMfpwc?=
 =?us-ascii?Q?LlmEge/kKOsgGaMYyfS4vhUZtSXQQKTuX5xQFJpIVCtXAJqEy4AFv8yvxRcu?=
 =?us-ascii?Q?vK6uWnhB/7Z8EBvr69ORDYAvnGe4xsg=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510ea6ac-65f0-48df-cbe1-08da0e2bcf12
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:50:54.8407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huqDtm0ZXnudXVdUkpTpdmhxrMwY476jVQ7N01nKj6FTFN5ftmvHPjejXRAA/Sn1Sy+LINE6hgUN++dp4OoSwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR06MB7311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5ea9c08a8692 ("net: macb: restart tx after tx used bit read")
added support for restarting transmission. Restarting tx does not work
in case controller asserts TXUBR interrupt and TQBP is already at the end
of the tx queue. In that situation, restarting tx will immediately cause
assertion of another TXUBR interrupt. The driver will end up in an infinite
interrupt loop which it cannot break out of.

For cases where TQBP is at the end of the tx queue, instead
only clear TXUBR interrupt. As more data gets pushed to the queue,
transmission will resume.

This issue was observed on a Xilinx Zynq based board. During stress test of
the network interface, driver would get stuck on interrupt loop
within seconds or minutes causing CPU to stall.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 800d5ced5800..e475be29845c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1665,6 +1666,13 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (head == tail)
 		return;
 
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
-- 
2.35.1

