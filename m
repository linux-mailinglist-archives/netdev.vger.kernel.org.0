Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5D4CE17B
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiCEAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiCEAZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:04 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281B972EC
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:14 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2250DfZo005740;
        Fri, 4 Mar 2022 19:23:41 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hw0xyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRLkXZIBMIw0DAFJ8PgXwfveK99gjmKZN0uuw7lEf5FXnSNm5flXy9FzK4GErth+JaHUmAFBi+2hef7glxJXLMocAQUIwXnxJbi90AbC1gHqzV7pWmTfzoOGMpprcWpqe1lUvSqwN55xQOVFS5lgH8FSCDLc5wp6PBQLdJJCoTO7Iqp2EukA+A3Bu0Fkg86UtBKxIUi2TZtOzqqXH6jiJQa3ey7WKC//X5Ywc1nknuNxQlbkv4bQ0INGCNVjTKXxUNP5KZw2QW5TWiv9lfA7rG4mgmjGUdVYl4dI6vPJ5xtBkFXtCofSf5fKBClX8E5WKC4WADIQzZtV/mCsjPN4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=CBIkJk/9TXcXn+O+fqlBZJWA719E0oawxEjjmo1OTP4VPhw2oOV56/sM+QB09uqMulV0mogjrVzkwtRblVQnSkrJO/QuPJo6yd8YTnAoUrhHQykiibKGz89XlB+cmJtOEqHWclXInklAthC4HymsLPa7hrT+YNDRxyiPXwI0X7d4a6xEJCjuWwxcOPZwcCS8yaWyvzdfgsezPZxYqP16YNC/zLeCXJ/h7gHhcQ5YgJ+r24jOYoUes0IwlIg28Uac8We0tiqE6H+7Qo/IM62oqo+Ikkj3qBaVatz5e/5ZQ2OI1PYkTniZngi9YM8/9Z3irpDAP9oI5Fpmb6dWYPxMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=Fwf19O2h2vR40SJDssqqs/017afII+zvXeRA/5Jw2ov8P5d2ovdWPhYHrSvX8I89MniiGUOu84ocJ2gmys9JeLs5Q4HM3spAXwVGmy/i+J2gkDr9TklidpbyiSVQ3tn0NwGYz5i2d3evvQMP2w2FBLmi3tfmk0YkgIrpoeWoRQg=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sat, 5 Mar
 2022 00:23:39 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/7] net: axienet: fix RX ring refill allocation failure handling
Date:   Fri,  4 Mar 2022 18:22:59 -0600
Message-Id: <20220305002305.1710462-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305002305.1710462-1-robert.hancock@calian.com>
References: <20220305002305.1710462-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3bc2f12-0984-4905-4a04-08d9fe3e6563
X-MS-TrafficTypeDiagnostic: YQXPR01MB2758:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB27586B73A17793D3BD618C77EC069@YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3s7LG8hCS+PqXC87PN1FSBc4bahSIecQ7t7s06pRtUAfSAC8wV2/eCbzfJrLX/7nFOE4V4N3tjTzqWVzPuQKWAStgVx1xWqZh3yhfrejoRsTHbRbjv1ahHA9UIx316itH+8qudBEGa70q1/v1FPMPu/Jbb9vhD0n6pVjKRCtuvdhv/Xl7/phSm3vwwzw7IGKLulVoQCQQk4KHNHFyHm0PJ5NXvHcH/j0DjUW12stHTD7fgcz0P6apmBzL3usNigWiSFobnQSroF+444/D9qtJhnLTT1SDRt4njfVf6DKo18SKdFYApZ6tM0Jd+n3NdQWmh6/mtzCbNoy7V9s4OGcdJz3mW2ia5H3d1OCEIDVZo4UPZixSLTaiHO1K7ItxVIJe2Q+FMFGrRKB66XSEqx8xIOx0KX6FL83IIxNayZw5mmj8UlKkyKdNHwSlZFiff+ON3fLxxCasARBJeTufg61FTMMfD+Koss62tD/6geEX1VU0vzrGi4TsMBa9jmLy+V6QQj/h8z41RF2OmHaxgjPuAf3RyQgNjLnWMgqiBM8TIdHcxVgwJSNUje4Gj4GtqGeBc5q37fCOD1SVfsU7pFQRaujdzupvvsMJ/WzF3Ef07u4B4EIv3yDlMxUVUUNe3d3NLskD0+b+H2HIvHAqeEB8vZ6Z1Yw6cZAC6OdpJEUEtKEm6F05i8Pf4ChaNlAsRTqcyAKu2ucb35aIabUEo28SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6486002)(107886003)(6666004)(1076003)(8936002)(86362001)(8676002)(4326008)(508600001)(66946007)(66556008)(66476007)(38100700002)(38350700002)(83380400001)(6916009)(2616005)(6506007)(52116002)(2906002)(6512007)(316002)(44832011)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K7b4HfiRdxeB/vVJfKoMR9p5MTFTl3di/1jrRVZYrOUoaxWjkwBUSd58xuFe?=
 =?us-ascii?Q?qn0MrfuGdlHjyCX3NWCirR5LKvuFcQpDhhl1eRGMeMvXnL678QMTLKghSs8r?=
 =?us-ascii?Q?8qG0clyPVa1Ae4m1m9alng8UIGwnTVVoQgFYLNOziJ8tLCpdhYtsOsjt0lMh?=
 =?us-ascii?Q?8mH3gTxe7gif+yxIxFsbauK8K22cZMIFCbWBuxG2lvho8lbsV4bQeweEZuWx?=
 =?us-ascii?Q?9JK0cD0E+HkOuUV869nDg6O91Y3Q+0FQivGKAqAXkB/vgVHfwUipQ3j2BKEa?=
 =?us-ascii?Q?ArPLsTifMUnnpITihwxjfqIm5WXxwMnXAjtggH81JgjHA+S72yJ21v9uiInj?=
 =?us-ascii?Q?YMNpLk5ynSGWhMeJf2hDB1mpTNR7Ra5OdvUlhFxG7SvOETTDOFnSim2oDuzY?=
 =?us-ascii?Q?rzmN9GK/JA1jSPudywdNNI69rMrpEZ7b/xt3iPd1EhUko/FpnkPCjnW1AimP?=
 =?us-ascii?Q?2rjV1zLqDhtarmzQTEj7aubMdYXaDH3h+WcQKfqBn+hsTqcESb/LU+uvOgCF?=
 =?us-ascii?Q?JN2xTtQQ1XzJJCI6jpZ1FB4oTGkVOyBbgUfpGHEnr5T4zAEvEcO2bE3+AcgZ?=
 =?us-ascii?Q?NMKtwOf2gT6Rhu78huzHxcHMWAdeBPixTHpv0+Vn5a9PCUwDuemVFde+UZ0Y?=
 =?us-ascii?Q?brF+oex1shBLWtYaAijqo8JicbscLvfX/enp0WpOfsb0WxzMeZqJAn6PDiBz?=
 =?us-ascii?Q?nzfrnDR2o8magD7MTALI3F6I58tLoIFbFm5aBMBw1WMk5vPqkImfW4mWDZmf?=
 =?us-ascii?Q?+STbYFRMoxzZhF9So1fM4+djvWPwSCa+XX/jvsC58Kzu768gUUooPBqs04r8?=
 =?us-ascii?Q?/L1J006X2XiPzzLw4WMaV56vA0rvczvNLGJkZE0YKrfaB6/Q/Fbr4ehqtmU6?=
 =?us-ascii?Q?jHGzD2v6bspSrYuV8Zq6j1YKpR+RIkOLyS+IGmCy6hzVvbGHZ2PNKVG4BYKv?=
 =?us-ascii?Q?TALFKYp7fPL6w5jZFsulhKTcnKuc4qPWZVnW6tCGGq4Ir4+MZ8Rg+i3PFa8M?=
 =?us-ascii?Q?EXZfWzHq/3P91/CB8ovezSlUdkv6TgBXFLmVeLcCTEMQRy2czEFlEemYHiVT?=
 =?us-ascii?Q?ClaGGBVvZckzQaX+O4GQQoJoiqYrgeMloixxY7UnGSd9ae59+2DnGeVdaKTu?=
 =?us-ascii?Q?5iI91RcO2N5qkxJjXgsWqCdD0ZZGK82MvhUb9MdzfSJ1z690OA5Y6yXDP7KW?=
 =?us-ascii?Q?0yQdMXZTpge7xzV9C9QdG8FFwHHpGK/lzX/Yk5TMFXZP5GyyYslitEPhWbbc?=
 =?us-ascii?Q?ek+QxYCZJ9H2qvlRDFLoREt2ai6B7ORL+j2IZJtHWjKPWeJE+WqEh+Tn4++4?=
 =?us-ascii?Q?jEy8I+psXjwho1wKYb+YIi2Dvr05ISnfYBiJAXvsW+iOGN3kK/6LYpIFFIvE?=
 =?us-ascii?Q?W4HMd0XMpRKrrBUk45sZlXjKuJSU5FN3NuTly4ZBSGUiebG3RRienXK4z1nS?=
 =?us-ascii?Q?mxjy4qEKYXelvgtqiL9mvscoksgymGsHSj8Cm+BUfyS+OLALd5dXBDAjf28h?=
 =?us-ascii?Q?yUS/sUMpxzMi+BmbO22h2lYksMSgdOIhAU36BR2wB/vaBEFJDlt0ckjg3dzW?=
 =?us-ascii?Q?lEw+1SJ1/cdjDWnyQNX/YDfzSFM7wPvPbu9OxXY5+0XRAAZfNxa8B8sLowSO?=
 =?us-ascii?Q?5avI0zSq/od0l9++vM4grqeBaU5dx8dSCpsmkl+zPHeXlFwBXfnTpTC46yhx?=
 =?us-ascii?Q?xNInAHZAMFQsYdV5cqLAsXCw7uM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3bc2f12-0984-4905-4a04-08d9fe3e6563
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:39.3475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCSln3+EcXhGcZkaRkPAD+Blmrh/PsvDW95sTcaMaWhXT3PxVezEGMhP2wEGUGbnoGNuDDcCyuG0DVmzKJjxNOTd43g5LG6ilG4eDRXYZfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB2758
X-Proofpoint-GUID: y4EdU0KEc_NCEadrTJa9O7y7j0hqqgy-
X-Proofpoint-ORIG-GUID: y4EdU0KEc_NCEadrTJa9O7y7j0hqqgy-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 mlxlogscore=464 lowpriorityscore=0 mlxscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a memory allocation error occurred during an attempt to refill a slot
in the RX ring after the packet was received, the hardware tail pointer
would still have been updated to point to or past the slot which remained
marked as previously completed. This would likely result in the DMA engine
raising an error when it eventually tried to use that slot again.

If a slot cannot be refilled, then just stop processing and do not move
the tail pointer past it. On the next attempt, we should skip receiving
the packet from the empty slot and just try to refill it again.

This failure mode has not actually been observed, but was found as part
of other driver updates.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 72 +++++++++++--------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 336929511e42..3457a7f13747 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -857,46 +857,53 @@ static void axienet_recv(struct net_device *ndev)
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		dma_addr_t phys;
 
-		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
-		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
-				 DMA_FROM_DEVICE);
 
 		skb = cur_p->skb;
 		cur_p->skb = NULL;
-		length = cur_p->app4 & 0x0000FFFF;
-
-		skb_put(skb, length);
-		skb->protocol = eth_type_trans(skb, ndev);
-		/*skb_checksum_none_assert(skb);*/
-		skb->ip_summed = CHECKSUM_NONE;
-
-		/* if we're doing Rx csum offload, set it up */
-		if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
-			csumstatus = (cur_p->app2 &
-				      XAE_FULL_CSUM_STATUS_MASK) >> 3;
-			if ((csumstatus == XAE_IP_TCP_CSUM_VALIDATED) ||
-			    (csumstatus == XAE_IP_UDP_CSUM_VALIDATED)) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* skb could be NULL if a previous pass already received the
+		 * packet for this slot in the ring, but failed to refill it
+		 * with a newly allocated buffer. In this case, don't try to
+		 * receive it again.
+		 */
+		if (likely(skb)) {
+			length = cur_p->app4 & 0x0000FFFF;
+
+			phys = desc_get_phys_addr(lp, cur_p);
+			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+					 DMA_FROM_DEVICE);
+
+			skb_put(skb, length);
+			skb->protocol = eth_type_trans(skb, ndev);
+			/*skb_checksum_none_assert(skb);*/
+			skb->ip_summed = CHECKSUM_NONE;
+
+			/* if we're doing Rx csum offload, set it up */
+			if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
+				csumstatus = (cur_p->app2 &
+					      XAE_FULL_CSUM_STATUS_MASK) >> 3;
+				if (csumstatus == XAE_IP_TCP_CSUM_VALIDATED ||
+				    csumstatus == XAE_IP_UDP_CSUM_VALIDATED) {
+					skb->ip_summed = CHECKSUM_UNNECESSARY;
+				}
+			} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
+				   skb->protocol == htons(ETH_P_IP) &&
+				   skb->len > 64) {
+				skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
+				skb->ip_summed = CHECKSUM_COMPLETE;
 			}
-		} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
-			   skb->protocol == htons(ETH_P_IP) &&
-			   skb->len > 64) {
-			skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
-			skb->ip_summed = CHECKSUM_COMPLETE;
-		}
 
-		netif_rx(skb);
+			netif_rx(skb);
 
-		size += length;
-		packets++;
+			size += length;
+			packets++;
+		}
 
 		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
 		if (!new_skb)
-			return;
+			break;
 
 		phys = dma_map_single(ndev->dev.parent, new_skb->data,
 				      lp->max_frm_size,
@@ -905,7 +912,7 @@ static void axienet_recv(struct net_device *ndev)
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
-			return;
+			break;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
 
@@ -913,6 +920,11 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
 
+		/* Only update tail_p to mark this slot as usable after it has
+		 * been successfully refilled.
+		 */
+		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
+
 		if (++lp->rx_bd_ci >= lp->rx_bd_num)
 			lp->rx_bd_ci = 0;
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-- 
2.31.1

