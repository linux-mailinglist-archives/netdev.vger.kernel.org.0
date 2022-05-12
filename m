Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39F352536D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353653AbiELRUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356967AbiELRUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:20:04 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D3726AD8D
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:20:01 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CBUrZC008360;
        Thu, 12 May 2022 13:19:33 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2170.outbound.protection.outlook.com [104.47.75.170])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02p2sh9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:19:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4C+LCs/byeVrb7zsVc3gsPu579QRx2ArGP6/5bfv6VvQ7zJ2q8LyYMvg70wiSnZZ3xSC8+naXd1Yx5UjomMPyhSBy9s3EgDtCDbu8PGXHo6PO2aQ0KD5DgjI0HZpG1pZZifhcpjvUA4JMboU88KbvIkSM8k+/oj8PZZ/8mDfuxzyWVc088AIzKl5YH1yM3VUTgXSxgtUU6CLsgRAiomGV8stQHVmdw8sbRLoqjLKW7APxmnh5TjBI+1K/xcSABYtdsnwNyJYio2icVPSfF4e7mmnFtpVNDIQrYfkMHmwoKEJLhMuNMhgcrNohm8nBLG554vX4DmyGvdMOH9dWvSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBqAa7PQdcZwsLQl5kkoA/OKu79O/NMciK6hzUrWqyw=;
 b=l+hXiRnlne+N0kw9/3WpEeqifB6G3VoAdhtLn4JKaOcNpdq3EzHpOvn+EWIpvs0av22btRRFeJNugFcj4PJwe4AxEqP6PnRC8A6MSYnro4L1fYjiMAaGFuN8K7Pq1FDcSjHjPrqgGrze/fNAf2ToPBZZlHEj5h0L1F5GWAQ+Io57iuuhkZpnKLRKR3iTMkXon4/zCqOATVmx1QvoJ0ZmIqbomC3j76pUt+uxyN5nrAggDcHqSc3487agSt6e+7VUMfUy4r14JhDA094jzITL+eQQlwqs9SbCeyWXN9QiVTZLsuNnTuMTgs4CwQbmhjbw0o8bU23ykaaTHb3gA/J53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBqAa7PQdcZwsLQl5kkoA/OKu79O/NMciK6hzUrWqyw=;
 b=SnHS3YFsE2qQGDfXl70r4SUKfiuWBlxO1c/OqC5lPLxk/aLX/YWFfUV7vjY/ogfkNWZci4C7HG9dfUiV1+KZpb4xQkZdPxJHyap8ISh5sWmozYtAhd3dNe6dSgvEeI9WpyltwkvxkvqQRHTYElDugIeBQ9RufvQ5SvfWw+471xU=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by QB1PR01MB2340.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 17:19:31 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%5]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 17:19:31 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v7 1/2] net: axienet: Be more careful about updating tx_bd_tail
Date:   Thu, 12 May 2022 11:18:52 -0600
Message-Id: <20220512171853.4100193-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220512171853.4100193-1-robert.hancock@calian.com>
References: <20220512171853.4100193-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0154.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::33) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202ce64c-6971-4232-9c2a-08da343b93e7
X-MS-TrafficTypeDiagnostic: QB1PR01MB2340:EE_
X-Microsoft-Antispam-PRVS: <QB1PR01MB23409C3F6919760009F72648ECCB9@QB1PR01MB2340.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlnC9ZkxetwGoQGq34DwY+17khwpOiJ8hOLLNSYs5Zs16tRulgtfw3S2DCqJ8t58vJjQkIlJLvlgNgU1S9szkgHqG3dYdGBRC92UAfHFdhPza+gDFRcbJuj84q14mpt8rlr4GWq4tRnS3+E0tP6a1wsB9prxNXbMN1ete0oHTU2p5mQ3NP5qUjL5UI3EA4UuePfL1ImZ4kjOUCil0w0dUHd5dZAukEa7lEhQIebnhga0P1ClMnX69FNtijuQ61r9IWi+PCd4Sxz6yzEP1dvpqNot9X1Idj7KkxYP2vkFZDjew9LqpBEwPNOrxTjZoT1/8giKSukg0DpzwkwvKSS0qqPzmjHceoBd3XG1dlqMNXw08DV8Kw3X84Q/qFoUvjlWUTtK66IaLCB6+MRxJL1kOz4dI9Wmyu+cfMIQm/AfYfPg9yc2SzJMTL/0EfFoLrf8s2MKnBH1ARaLn4GM+Dc+yriw8W2KxPxkZKuT+TbY3pQzd9xbJYfnMfOlAzuMoTLb5yBFCmXuisCdvT2qalDyu0PXDP8YqWHf21OcIHcwvnLf8r4X3Ap/NlYK595G47yHZ9HKU+F4WPIffDHRunV4RRLAEoTvV+NIGsxCJQPv6t/Y+p5Je2b9wdAQcXsHZXto7zGyqLaqMxdHqJyieb1vCJV7qtloD1T79qR5JbBiOUGJaiAlGPLQPJmB4HVP2qKxJf+Vr6pqsbth1tiE6iZ5hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(6916009)(44832011)(6486002)(186003)(107886003)(2906002)(1076003)(508600001)(38100700002)(66946007)(83380400001)(66476007)(66556008)(316002)(6506007)(36756003)(38350700002)(8936002)(8676002)(4326008)(26005)(5660300002)(6512007)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pXwAHfLYnmnt5YhCXr2AoA+vFN0/F8c8eOpSRoaiVt8eAbqVXTwIMH6AMC6H?=
 =?us-ascii?Q?6Vn9gLfPzK5tJmJsF122HWo51pkAvflvdWD3XNyQJW/fxCcqW1qyB1hGsOiZ?=
 =?us-ascii?Q?KvDqDzJgMoXeKC2/P8qkk6xNTKv+VVuLarat02Byg/4zbJ0LPhwc2H1CV72b?=
 =?us-ascii?Q?6wtTf6Y0GaNLU2aaggJXqr6mTyqSwQ2nz2Q1V4OffxFXEFZ//lor2/aikgth?=
 =?us-ascii?Q?bpukJ6zkTbYVP+lbSZKoxI8F8CsqjUnUmC9IZCmlR+g1hQNy6dmSKzAfSEnE?=
 =?us-ascii?Q?9ndEHRYgOhFB7cIt9knlepZZCiin5IfTkurMQZ4nD6m7wYBhMA94THeEeBWk?=
 =?us-ascii?Q?xTZO45J8XcXESLsyltQAz4tLJ93wxSzNpdImZc1AlBi7TtRxXbHt5Q0Vnwog?=
 =?us-ascii?Q?BVcSM2SfUQtgMcxwYyvYbUyr91YeSBeoIdzVrtmNg8if5LiIIPI6hG5C9utW?=
 =?us-ascii?Q?5PQx7GwgF4AD2HDUjYzAKSjhs7TiRFExHzhVCCz2QdQfpI2pf8GPiA/oFzo3?=
 =?us-ascii?Q?hWKOoBKalNrdQO+3bXl/a8k9spuxWmkIawHGieAs/DaM31TwLRFkJe3Nkiq4?=
 =?us-ascii?Q?vJJh1ZmfkDZe1h9A1T3dhBsCbGDsB3p6m4ocF29b6J3uYV/jJauKw5l6bpIb?=
 =?us-ascii?Q?EV3V0A8/7zhllygkegkcFZcLHPwlpc+/S6dBU46mQ3jaUqscOeIWDm/tooBS?=
 =?us-ascii?Q?MYmFs4+1nHrTnUKzqbSeK9GbzGA/NRfBHoLNBvNbiIx9PzFK37CXs/Xf+Onl?=
 =?us-ascii?Q?hsDfTuYXC4mt9n0ugeK1su6UMjUjuusbgQPzWXkLMsEJZe19DmjU/A46fSQP?=
 =?us-ascii?Q?f+Q72Mte3tPHdTwO0NF3CdA4C2875OznWfjhe3RvlhkLAkZZ2Fg7ZWhRPTTA?=
 =?us-ascii?Q?Ap3d1J/JVcse+8LY/pvaqc6JTPwFqA2TWYA+d5921f+PWLSHAovZAkrNcCpq?=
 =?us-ascii?Q?8McJL4viJZ9C+mkt8odDUZud0EvI5hIwh5IAUCSiJhK9IFTzDr7Y+CQJE7tI?=
 =?us-ascii?Q?JxnyPqLYtVk6A4H9Gd4VFipLPpjpW9HfpNMcqPTvrBUTLxHjbfxHkHwMUjXF?=
 =?us-ascii?Q?Imlxb0Zda1VLVMZE68SpYQudhUtNbM6v7EUlYwNWV5JbV0qkho4YG7rLRrAO?=
 =?us-ascii?Q?twLeEqRoolSWDIMdF3ohKwvSnMXl3LRQfQzs7MnVxlJ3wHx9RJ9KH6vCG4LH?=
 =?us-ascii?Q?uaKs+Mw8Cp6W/uLAo18s/6sJEVkf/U85ln6z/Q5nwxG/l5gq0nv91PYpVal8?=
 =?us-ascii?Q?2GNZhsDBDEWtpnQmuE52+F2QR9ZDyGmXSQAAW0BYEZfR+dpBv4nGXU221//O?=
 =?us-ascii?Q?4xP12rb0wkb3IeG9sY7b3z0N8jTp9SlXuCwLcyKnbkKOe07AIkpY3OjsrKmM?=
 =?us-ascii?Q?fyXz4PBG7E6oRoQ6ZbzHVcdKPmB6TjGkzYb1H2OJ8OmjGtvZD2/tDOkqp5f0?=
 =?us-ascii?Q?owpIxh3ZCzvxijpQSm4Gq5tcN+belJlYJsTRWY++XXssGNttnLq2w82NH/Vq?=
 =?us-ascii?Q?N3KOgGA8NlXSEIkUPzbdHmWKIwdXiSnGhpGQbFU5mnj9C3nSnbBubMwejvlO?=
 =?us-ascii?Q?Z0hq6GS13PFG5gDk/n6lEYOF5UBofAHVUug1zksInChtSOJ9DwkOJs9NDClh?=
 =?us-ascii?Q?m0s6MP4ax5suEKDwUY8dPpGRkSruwFrKU/Pr8YPHWfY3cUveGXvCzvbgfGpt?=
 =?us-ascii?Q?qrGoYgafhlWKlsO07Hv9kK3Hx6GSbszYGf71+HDbYNgAvta/axNAIAn5rrc9?=
 =?us-ascii?Q?dbJE+HMiZFkcQtEN/IDJWfMYM+7JHIc=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202ce64c-6971-4232-9c2a-08da343b93e7
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:19:31.6563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+T4ASKBgVWx97uOlORi8XmzhIIIsapI81jIX2La4CXDgjwS939HqFzUpqQju9cuT+axkMXratrWoK3nIS+4i3xVc95mcPjI/u0TUaGnpaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB2340
X-Proofpoint-ORIG-GUID: MtrNxK9Yad-FAOKJjuN2wKMrhVYsQcS8
X-Proofpoint-GUID: MtrNxK9Yad-FAOKJjuN2wKMrhVYsQcS8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_14,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=636
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120080
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axienet_start_xmit function was updating the tx_bd_tail variable
multiple times, with potential rollbacks on error or invalid
intermediate positions, even though this variable is also used in the
TX completion path. Use READ_ONCE where this variable is read and
WRITE_ONCE where it is written to make this update more atomic, and
move the write before the MMIO write to start the transfer, so it is
protected by that implicit write barrier.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d6fc3f7acdf0..1e0f70e53991 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -746,7 +746,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
+	cur_p = &lp->tx_bd_v[(READ_ONCE(lp->tx_bd_tail) + num_frag) %
+			     lp->tx_bd_num];
 	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
@@ -807,12 +808,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 csum_index_off;
 	skb_frag_t *frag;
 	dma_addr_t tail_p, phys;
+	u32 orig_tail_ptr, new_tail_ptr;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	u32 orig_tail_ptr = lp->tx_bd_tail;
+
+	orig_tail_ptr = lp->tx_bd_tail;
+	new_tail_ptr = orig_tail_ptr;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
-	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+	cur_p = &lp->tx_bd_v[orig_tail_ptr];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		/* Should not happen as last start_xmit call should have
@@ -852,9 +856,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
-		if (++lp->tx_bd_tail >= lp->tx_bd_num)
-			lp->tx_bd_tail = 0;
-		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+		if (++new_tail_ptr >= lp->tx_bd_num)
+			new_tail_ptr = 0;
+		cur_p = &lp->tx_bd_v[new_tail_ptr];
 		frag = &skb_shinfo(skb)->frags[ii];
 		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
@@ -866,8 +870,6 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
 					      NULL);
-			lp->tx_bd_tail = orig_tail_ptr;
-
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
@@ -877,11 +879,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
 	cur_p->skb = skb;
 
-	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
+	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * new_tail_ptr;
+	if (++new_tail_ptr >= lp->tx_bd_num)
+		new_tail_ptr = 0;
+	WRITE_ONCE(lp->tx_bd_tail, new_tail_ptr);
+
 	/* Start the transfer */
 	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
-	if (++lp->tx_bd_tail >= lp->tx_bd_num)
-		lp->tx_bd_tail = 0;
 
 	/* Stop queue if next transmit may not have space */
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-- 
2.31.1

