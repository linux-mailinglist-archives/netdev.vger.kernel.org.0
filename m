Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6DB4CE23B
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiCEC0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCEC0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:06 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA33A22C6F5
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:17 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22524FEj004428;
        Fri, 4 Mar 2022 21:24:58 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qgy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:24:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5cqxkflMskpb3E3E+YqTyE3R3pfOlrGUq2jtaXdBkHqmiDa5d0MCnYOEbGBQSkSGMXdXmdZdHsSiqzrH6HOznGXTifxp7byCKOqtK65cLLtVlsi1q6c237kA562bJ0aQkLTJRVpt4zSo9n5kt485ynzYe/yltpZIwTf185IFq0TWI7rSObj+9U5QotZgchjlNU4qMxeGzrIjXvV5px41Psb0FZ4421ZhwF5nk4gXqPfRWe6AIZIIHTcy28pJCVBq3lEs+B7zC8dj0QR3cl00VSZCl12hQN/vDDn8q6bku2qU2i7T5Q2DgMVLh/5fDBtQVD0nSsSjSWXAV+SvOkwZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=jTlPf9ZZENoUEY+8w6IDBsHUD5IOvLTp2C1z0JtQhqxnBALJoGTnlGBuQGhywAFOu6jYAcbEeckwkWsFaOuUtCHo3EdGHhwBqFjaPLvJG59+RfyOXF5AiRcToz/WwCTUWN5lxuI1OK/f1i9IghSe4i/oThBXd8XdoRcpE4lia9f9bpGRzYydbFMD/Pc1xQgAE11WE0w4DrjuiQ1G1vyE30vag+HoVnpPwjx8oP/WQBHr4/2d8R/Y736CoeqUKRhci+b9APMksziRl2INc2CCEyBSxUUXFYBOuApUe3NOWagnHrX44prgf6acVu+6hSeWkIoyeS7/5VobkNj4JwzPxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Uide2juYgLn/TgW4aWVCZGgm4nlf6vsd4r88ZedTZ0=;
 b=gbS4g4nQajdsqhOgZaoV6h/0qV/G7zigK1WtZjMI58yrJGtHxFXJdw2/8HCIxNERjnviGEh7MQqGi4MIsaghGS6herjTHvXEwKmxZWkHHxCCcvQDJBT6m5JZY4ZlM9NPYqUMxOQx7z0WGnE/HN6JQwNnVp4m1RKSa/BrYV4VitU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:24:56 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:24:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 1/7] net: axienet: fix RX ring refill allocation failure handling
Date:   Fri,  4 Mar 2022 20:24:37 -0600
Message-Id: <20220305022443.2708763-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fb5465e-8abc-470a-1828-08d9fe4f56c8
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184C7F945DE374D661CCAE9EC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEM+8zwHSC56DhkZn8zjl8hLQabZ+5SCryW7vg1ubxoop3M1pPIunEWKcU+BS66ghiLR8UNyb+9DKTRHy9zuYu3YGtCifLwNV+B9c0WWC1bVt4S9rRhCOUPqfmmcP1YdK0PKLw4vHcRnwPDHEkxJ9RPn6xPO0tdOMKBGR7v0IiDHYxM39YxQ3MNCnmWrjRWKwGq4DOYaDa35oqGj/C7IbnSjqQ7rDEOWvxZVu87KA2jZ5h4K5ywsP35GppNk6GdT4wl0wsQA1oXp6vzBWSMdgI/SxkZaoNazTy03JpHl/OR5dUU8XnVVf2nRS/On5LU97FX7SFHp6e1/sv8Pnfm8txQ9Itfd6wr2INjUbYM6utYsVRW0RNtgD8kazccb5a6MQhPe+YNgs2/ricT4L8n0Na/RJkzXVDrFBYg3N4uTNJpGBvr+OBQk/PQewi1eJ1EhAobQfEGd6BlSiI0DxHr5QOQ3aHsCa7zHDTNy8bzn3gkABZ6WRafMumUfUu/p4KNRtKq/LrHwL/Svon7ZuAaLe1TUIqysWUNtUFUF51DtF/pwHpErONNUtDmsJPYj/k4cvmq3wU8uVgOeBB91/KP0oovlbzfdvHpvcPSiyLxoJ2JDlgCs3qCOIXOe7qxoAOg2iGq+T/7QP8vsvRrZVFWr36bl2y0/xpALJNh+C6s961hTfSScpIwxL5DdE0jt8jZLuzezW1QnNguqJvuPmeOavA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCrySQlOHdfzw99XBk3artpnDOZAE/WVLONA+RXI8a+n4JuES+mdt1nVYy83?=
 =?us-ascii?Q?Si1TzLgWX0DRpv8ZMtMXrrOKK5leOUzMvhmxKHMNbIHS4UWIuovTYfJgkMSx?=
 =?us-ascii?Q?/p2jHxo57hZLndFSHegtraR844GO51WAHlE8gEjGD0sZ2bDMgo2hiZpWG8NJ?=
 =?us-ascii?Q?jc6rhrqkjTdajXtnIqAxmWDMoBENlm6fH6kYwghcebR12NwPqCJ1rDn0Pjt3?=
 =?us-ascii?Q?tAwd6iaMGXd7zxV4SaU/CMm6wovto7ws6a6UpcInnjiW02lvuJA/5a4+BE2c?=
 =?us-ascii?Q?QUM3kyvlnnqCP9ilXous/gI4ehYDAh50u6ILQxVmGGpX6qvYRYFqFTPHnmpz?=
 =?us-ascii?Q?eH5Hqx+NPcG6iogQJDVe4XGiWr3TpFnLDbZPYb3jnXssY6Rt1MkI0aaUDpAe?=
 =?us-ascii?Q?+qkvUcJy3OKBLZOmyHbVCGZlDqdZ7FQEKHtemmArKBcMpThuWv5FMjPb4p+6?=
 =?us-ascii?Q?fRSaiT0bhnQKZYyG2/cbDSj1Ub4H6hw3PXvxl0MoMYiNsAuZfyp9zX2k5YaP?=
 =?us-ascii?Q?va5vICkLWjeJKU7cjxvz6Bd2nYlZtTtDwDbg+6i8jk/6MAZrVTugYCWYMUB0?=
 =?us-ascii?Q?CHL6QwQPGMuMTenK8jxsNlKo4M+LlL+yzLyVzNzi+XEwPRq/rZGiyv0mi19P?=
 =?us-ascii?Q?v95UXHhdKuxYxCmi/Gos/zGwk9rim1QjxhK/kCAwwHdViOpunmbUgQWuqufC?=
 =?us-ascii?Q?Wy6ehl76ZgR9FagY6+VehB4By/9srfjl8N5dM7xxw4cryIXg9i4GU1/iN0Re?=
 =?us-ascii?Q?7BLk+DPmM4MSHs+rTFwX/JCQB+qQCYd1xwZj4sDww0EWHK0ncHxSiOMdHXM3?=
 =?us-ascii?Q?jPanxkfjLagLKRnxLllhOf77KCL2UdDY7GSR9Z/Ky3GwuOAEANejBIySM4I+?=
 =?us-ascii?Q?7jrcku+CBARR6+B7sHtrovaBZbwhm1lneAvDYRnwqMTmDFT8iTtuX9DOO2mF?=
 =?us-ascii?Q?DSVWv9lFLrtSI4Xkjfjzeyd8Q+tP/GU4Sda3rGj1IdhrxeBb0gcYVcRu3ZCP?=
 =?us-ascii?Q?pNV3WRlEhOeRd4tv/oIH9xXMC0XKALe2dqDawN+FoArqazUdQAiBJLJODPNb?=
 =?us-ascii?Q?uMRVzQRZTu3lKZKG/4AbZiHTAf4cm+D1QD8wYAMFJH2PbtWvVPhznAUFGHgu?=
 =?us-ascii?Q?FwYQunDaHsDuWSb3NfbSv/Wx1O6CiyvCTRLYu+tj2nLpWcMwchWR6Yv5Jk+L?=
 =?us-ascii?Q?wUGQDThUQjztF2AWem7WhIQ6rwCakS1g0IRlh6eEleMlhMsugnTJum72WxyL?=
 =?us-ascii?Q?37iber+XbvRv2z7RqH3bVag52ie27/fGjtAVcF6WF6PiJzCvDCAtlNzhcrb9?=
 =?us-ascii?Q?l3IgV8StqYucIbzrTdEPAwxVxE9Ca944ahaQZHIVglb7kIpbCyF5e5uVs79+?=
 =?us-ascii?Q?HS5TIQ+Ph4Y3Il/NBgkky1dvmQqU3B7DRkB9key8lAsyx10PofDHiL0F+Ua0?=
 =?us-ascii?Q?7ikdUK4RNtP88U14KnEM+a26fVdHeci/pp6A7U2zniR6Vzj/Y3BvvjHYA+cK?=
 =?us-ascii?Q?jT38c69iEyQxtBOD8V9BAXjSXnG+kGB2RBmEg9yZuf++CfNnrEjXoG6M9ZwU?=
 =?us-ascii?Q?GhW1FcLv/rFDmOKbEaM/9nK/qrxno9Lpcsxw/HMR572Fllr8UcHMHUOlettJ?=
 =?us-ascii?Q?hlnxFi6WzsYTQTmQ6Sgvb3PmmVIy8eBIY2v1x2XPvbJnU7XGFo5dxMip5baA?=
 =?us-ascii?Q?GDb76WpJXpd5LctGyUmoQRbtMLE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb5465e-8abc-470a-1828-08d9fe4f56c8
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:24:56.2867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYnUSNPo3VyO5nh/ipR3Ce1bnFZbrlkSFsNfU0xZXffx/kFetTP9uXDjKUnopW3TJRtMMBYVmakHSrdHQY8yZHtFm6mLv4KG6kQdQy9OOFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: T7u1PyLK3pKL9M24NiPW5RZE4eqU_Ydp
X-Proofpoint-GUID: T7u1PyLK3pKL9M24NiPW5RZE4eqU_Ydp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=481 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
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

