Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEFC4CE054
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiCDWo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiCDWo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:26 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA4C5F4FD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:36 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224MaIDe005553;
        Fri, 4 Mar 2022 17:43:02 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPijAr9dafQAAZcZkIUnFJb5rANedNMVuricCYRzS44zn0LjLNTsk9CKTvJTOKKyvSFmf0dqlSv5xeyLeayPjPL3yhKC5GTuTpNJB7fjvLQ3fQJPpIM3agODAN78tK5dV/2/oDzDn4l+EW+nPiJIOKs+PgXEOZggCSRFVId5sBvRpyGscrYfdZLb0bvu8Cqkgw/X1gXSS+au6Tn2X9BgYDNyguVuR7GNNHaVKvRPEsddNfKYFDn+9msH5ZRyJg/BrBSqO5fLV30fQCwI1Ol/tvT0p0b742APZyJksK5NUwAaNT3IH7QlsLUJ3midwgstQQt+hzFBdeEZIFzLmYTxqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=REN41masQEXX2EsfjBYgHCLJOI9u33HkJ2jZ4npsRPC6prdMFQIuNOLLlhIPLT9/LYWwCgN8qVb+s/A7wa3VG/b3IvgUBazwQVjZVG75UbwUSI6JtPBMcqT1NVttlPnVuOqn9m5+GRD3tJuMp16Shlfrjkn5AgE+41JvlSsi2Zslyis8rNUGj8zzgzt66CwK/oPDP173+bNpsIbokMkmt7QNXSK2ny72yrhfinTFfG5I5a4bjuI2MxGOzo/NhVK/zDiMRmaiUx4FxKZWNjhcOBw0uSyc0MYH9oxxGGFNmWQtm2mf3VSjhsPg3Pb1LXWISC9iegcVCGzJd9+FFnvgvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=fPfpZPOZA/w70q6fg4idArQ4KnVJZQDyt3X3/nf0NrJIDFMTSigulP8FOzPdAI0rsOLKSUSeHHLPxbW3OVDXhr0RCJPJeOS79IrheR0jr/RyaL7mOYVWyuh9310Hf/3kSQKIH6ukhn97Fb7nA6Q4+b5ZQ6Fpy+pRhwREdx4SZO0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:01 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:01 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/7] net: axienet: fix RX ring refill allocation failure handling
Date:   Fri,  4 Mar 2022 16:41:59 -0600
Message-Id: <20220304224205.3198029-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220304224205.3198029-1-robert.hancock@calian.com>
References: <20220304224205.3198029-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:610:b1::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcab0dde-b68c-4daf-968f-08d9fe305674
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB65401860B62CF476D6E070A1EC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 437BOfoI4ANTUULi3/Ma23tq3Nh+HCAaob9EkdlR0QAFtFepbUA66ZbmPM19gfw8j8YFuQF2ziALpBrnVQKrNKL9hCuEeaMGDDxKApZlD0QJYGxkP5YtDBNwE/SW9kNbBvwMkSwNTaLLM0vT/An/k+S/jdaj0kT+r12zN54x5UAYJribTG8+g8d6zp9kXq0Kp2/ws2GFX/XTAgZRS5eubxd1w09phkO5/57rpDiDfA0DVsbzxI4gwmaPST91hXQbl9RlELRXvtcUbr5MiSSGw8PJyLvvR4C0HKodXRNM87BxhYPAKKpDRW+mk8OkfS4r4sZ9UNKT7qGReAWsNIHbAGwA3Nh02b7sD4NueFs9wxIGeXsePlxGRePQZkHncFYfdkc4mfWCHJRFilre5JipNv7nS+nWPJqZHbx8+75wMQpz35UHAjGCHMciJsAb0TEpHQaVr4/pvFbRRKiOXejc34segyigxl8ueXDMNCTaaSa/HbOKJSipZJQzHIcHeoh1YxSQrjM91/CRCQrdQQYXY/ifc8V6cVgGwfwlvDxRJgFWt7n4YCJbrouzJqAigg0+uqyso8ox4GUf0rhaGFXQ9N/QiW+Pt2qeB0yffjiEApIPxKUrd9vi4dhrXFNhpYhkpmZHK2SQUMNUFJS+TJAnNzby3CYWeNygvYfHwkB7Ke6JEetn5bFd7e15k2vrYKLrdLcY2V5Tm25wM0reo9HkLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RKZof7njn55F9P/sVGjRBdAR0sWZxm+Dln+0zNKI/UZqV9mMH6cQv13/3MOG?=
 =?us-ascii?Q?oCJDJmZRyi7m4fPa0i6RZN8PW3L09meb6IDX8gtWPA3v3+mfSS040OQFb4Lg?=
 =?us-ascii?Q?NDfkqBI4tF8ok5Z2tG1Jo1f9O9Dlz5JAEnRx0V0xkDR+jT2u8rO3AOA5p4lC?=
 =?us-ascii?Q?w/lf9OnlZvo3e7L+10OLvPmxy66PQ5lCRRnIEMPuWcfu9JdjXxcosNfJAzxg?=
 =?us-ascii?Q?cWYadxqtlvmjC6+KhF/2BZcqnlciLL6IFl6cPfY+tvFLZX1ScUTdce91l0Ci?=
 =?us-ascii?Q?aiG2f19TmSJqlrrnUzbuQCpZjlSvX9pRah+S6JBmS+LvA+BsPPcrDsrSBHEL?=
 =?us-ascii?Q?LSsaeQUUX4H6igH+RMBX1WMyW5LZlHOoaw+btBEHl1QitnHvxTNzJlGdvTaG?=
 =?us-ascii?Q?jTHhI8lasaPLsx1dx7EFy4WS20K75bn4jAj4t/E32b6hki3pAFnQmAIVnsxq?=
 =?us-ascii?Q?Rct/GPyD5xAtAsQxgmURXy+UCG59GoYq8S/4faELCHLXTWLDtZMy0ndjTlOp?=
 =?us-ascii?Q?SM/TRcf/WbkBKP9HoSAu2IA6tXcAAXqqrhoiBnii9Xm5U+Wz9vDQJHOGwaHV?=
 =?us-ascii?Q?tiyBhEibWwLGklBoDh5m8Yh9XrYqeCloZoz/61+7bd1cPoy1ZP78WHnVlIvS?=
 =?us-ascii?Q?3PaIwWB7l9DCaQHZebAonAVmYhXwqD1nz319IwNLh4+rCAKOv4oCVRb3hMGL?=
 =?us-ascii?Q?0xVLGjuLc77P58h/WDRtptRi3y4YZSlVAZ93Ag6l59KGvw5hsx/rMfki5kt/?=
 =?us-ascii?Q?zx5t40v6tBNAB16o2wr1I4710C03olAFKBQtlxpo3V/GSS3Jx1EWYjx3LKus?=
 =?us-ascii?Q?5rdMfS2Dbz04CcUjKTdx+heZqe99PycBzDFPbEUIPMDBF9fvob3KXC+UJ38y?=
 =?us-ascii?Q?40Zk9/xJe1e80k+CdoorxaF0EnbbF5FEnk3y3sTAFssIy9d7r9jY2+r5N2tw?=
 =?us-ascii?Q?IZc6MHF61q3U+DatVOlIcJOj/plee99Dfizd+Qhbs42+4CnLh1d0vECIkD2X?=
 =?us-ascii?Q?lPZ4ypp0jJ8WYSBmSlbmIn0Jx1OH66DzYHqa5e6KXBNG7ucgCOND9ogr2k20?=
 =?us-ascii?Q?aXjFheCE7VnQZPsNLWr5tOtCFiB1m+VqB8bghsaxCj+W+ULIXQPEnkK4HarX?=
 =?us-ascii?Q?4qssSjRAHnNwjvS7+5l0JPHjJ8ZJJrVGKYDdBrFm/FBPZKXy+b9xqv2rIbOO?=
 =?us-ascii?Q?DQ+aQj0uqoh5sHQlewxP8QsD8DScgraTp6xfOdr/rscV6ufRzfbRAl6tip68?=
 =?us-ascii?Q?OzbLNC0uWZ8gMFcFXy7hXYQXN9Jj7zJxOODBul42PyXtS1ullyzpVG22DiLx?=
 =?us-ascii?Q?xsUmQrM+6LgKOL099/KN0qROo8W9VQbb+ANQEH9RpYr1a/zWcJPQWGXcuZL5?=
 =?us-ascii?Q?1WmFV2C0VaGpP6SOY8chgFlNF1S8t44kZOMt6jNiSydBhiy5YDnuG9fnxwAm?=
 =?us-ascii?Q?U2pX0lhhesH5qSnzKDST1RoesbWpDYTdc6s9/+ktbm0xHieRxcj5S7tpsr4i?=
 =?us-ascii?Q?b+CfwSeBX9oBAq5IcUi6gsod31294KmXnBhRMq5fHqal+pcy2y80dyrLM6ht?=
 =?us-ascii?Q?rcM9xbYnvjzuur+WatjSCrorfPXIEc1QfvcvUpLNOj/JwXFMrbrMBQvt2n07?=
 =?us-ascii?Q?7qqcm7fpl53fbv5Ro2210X3hX3vMNHrBd3qMIa0ELMhrp0QDbLmNLShQmxGJ?=
 =?us-ascii?Q?O52RZ8Ba2+r2L4FKhHmu3u7IoAA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcab0dde-b68c-4daf-968f-08d9fe305674
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:01.3252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zi4l9ezdrZQmLnNfDZa42WA2EkMHJvCg4cQWCbU2wjfm7WRWK6OzG/xqIJar7ABsFakpvPVoyk5cNvYp3p/CbvruI4YkRuNWGXxliLvddHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: 7I-vqOEluulXDGgt83PbmPMDFFC93oDH
X-Proofpoint-GUID: 7I-vqOEluulXDGgt83PbmPMDFFC93oDH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=464 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040112
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

