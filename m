Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0969D520572
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiEITv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240666AbiEITvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:51:23 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A21248DF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:47:27 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249JYHIN026003;
        Mon, 9 May 2022 15:47:07 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2170.outbound.protection.outlook.com [104.47.75.170])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fwnp40wq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 15:47:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mouQopV8dIxlQ1gaE8h5nnPa5w145Qn8UE7xfe4x+6G8REO5XbVRyqYsLA3tS9Aa+YrByUSU/YX9WaVrB9YsPoNNzzR3OJvWqMzIUkBo16kzMyjGF0lFO4HR50D//4BbuWiRtDRQK/6zvFIHp9gktdzBzLvpdPy6PgzRJtF/Gqj/7n4N6dwYNDWOBhc1umINC8yd4OvIVed686XSNgN2QPCrSdyj8wJioE4vuXhVaK4nG4osUVLd3/wqo6rgUww9aOLvxlewujdqLJEd4L3yEkav+A7jOd59hSl2HNTPFoLWkCVFTIgXgqAj2yA3n45acd7IQX4K6B3lkCptkXFBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGCBPWD87fqtUJ0w3QdnNp2RL6pV57WHp/w1Vfve2BI=;
 b=LOJWtiLbCfVtIK1LBqPcm1cXPZ4lKRu/4ktRe5oVzhfs8m7X0M6JoYnOm1FhLGGDPTOTI1xl2bUYKmnIC+rke0ccrt9H6tb8tq9Ls881VaZI7Za/yRraO2qYK8bna6SC1spzuzD1V9CuYDcJriWK43xHsgYz6CCFlnZRA4/iNXUH6P08Z1CZe2n0dEXnGJks3gSFQHcPiH+bF5KxJpk1FsTY7AhrpHFJDiTO9iTYmYV57RNmNPxbRzNeMtrxsUc4YfMiTh+97IJc2lAF47G3Aj4UNBy+3vjSJ41Paxe1Mwst9wHx7pEXAoTHtPs664l2+msSbxgN9v5/aGBqKsUB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGCBPWD87fqtUJ0w3QdnNp2RL6pV57WHp/w1Vfve2BI=;
 b=2AO3x67Be6kEAhxS+B+ipHrHV9gZKZRQ93D71B7n+n5LhwinYMLWKdcWZTUn2PWHR5YgnRnHKrAUD7CJnxEiG6XCx0Rh8fxXWqiZW2tLns7KNwR9TcDeMEtc5xCYjAtGWPjjNNk8zKgZrD0P4MZoW5S4iq6T3nxr/hspVZ0ivFM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 19:47:06 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:47:06 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, tomas.melin@vaisala.com,
        harinik@xilinx.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/2] net: macb: use NAPI for TX completion path
Date:   Mon,  9 May 2022 13:46:35 -0600
Message-Id: <20220509194635.3094080-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220509194635.3094080-1-robert.hancock@calian.com>
References: <20220509194635.3094080-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d82ee3d-1a6d-46b4-1264-08da31f4b23a
X-MS-TrafficTypeDiagnostic: YT2PR01MB5904:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB590486C4A61DDA8CDED8404AECC69@YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UL24ZIn7KnzcBT18ZZuqPMyfMJcD9TIWwbxBxG95IgOg++EWFYYio6UmBC0VUqEVaGVqV8qGswZ0V5lETbxCye2Ru87efIJZNRtIBvGkRFw3kI0ybrQZiUT2wowUYTvaQWTSUnO7pfhEZ19sIjo+nVpVw22EAC0tgLCHxluIgub7G9lAsgG45I5xc+dtl+eJzLXr6nkCy1jVNWSgyl8XpV0k1lCQtSIo/rkd/GIEtzobhAofpgus4A1JTuLjesWmycgQRRdbFYY3j+hDJlJHJVlU5uDHgGetXVRbJdeo2T7WPY2YjN1m7h3zx65L2RWFhfrdYU8Llbv7bygzQu9k+EgX9e6FxeyNrJp4ucSKyHlplLU5HOS8v1mZjT9ae+7j0uJt6UvfcpsV/qJ+KIoneHgmr4qThlaszDeCF7zh8SgnNQ5tvb9By12N5Ht3En3lioM7FayrmbjH0zOOdFsULAzaE/hIlh0XKSm6JJLpKakJlrG7ZHVY+8UIQ4e2xq/vlC4g/PJ3OERuJonv7jzAKcukv1qk5JF2CdFNJN+is/tXOF0iJwh5k7+6160CsH3AjydbGZ7stN4DbrR8dDNNXxDgDsmWINaPNdDLsV69Moa9nn8ot5vzpufiPbYWtKenrplj9Tx1+oX4FBivLTbySWAfcJZj6c05Gm71HXrav+WWIUTzmqSlBBW8rNuCTz6/kZqnPBZEKTYtU1h1ZrX43w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(38350700002)(6506007)(6916009)(86362001)(316002)(6486002)(2906002)(6666004)(38100700002)(186003)(66946007)(36756003)(26005)(83380400001)(2616005)(5660300002)(6512007)(107886003)(1076003)(7416002)(30864003)(8676002)(4326008)(44832011)(66556008)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HjUe29yOtVhipz+8Hl/RBM02ifDKzYAq9QR67+3+1DF7IE+Uiz2O8rkjx8YO?=
 =?us-ascii?Q?RT3/LZcgJtERHu5vBaBCdAfUkXGamAlnZddce7HAp3EXGz2j2jOTAVTsCBRC?=
 =?us-ascii?Q?qRQcJ4G2c/UmR3Elvp1joTyUEFxBbGMswCO/HCF6zcq5i7YWRATgNfq9UnCb?=
 =?us-ascii?Q?zYOmIPzJqTA1YCo771iKGTirN28lRlrCGmwr8xHFdaeRVeKFTeXs15y177v6?=
 =?us-ascii?Q?p6EvMBG4U/FO814H2aN6+4rzmuu7LMBw3kD1SPWcUoM2wxhQdEeEazJi5T+h?=
 =?us-ascii?Q?93rY4BjfRFD6QXrkAfNjwZaECftMdlPWbSGwOwGWT9DkLeWuUIq74HEUeGoz?=
 =?us-ascii?Q?9YN07ZqvYQ4nzQGQ67CqwLj9UlZfnyJCv8ujI/nTtut/bu+tOPRS9OoAaxPP?=
 =?us-ascii?Q?RfaOpaC8sxgVK8f7caEB8s1NgxuO02vUodGC+SWJs9t0n0crqrX3pMpmwZu1?=
 =?us-ascii?Q?hx1wyMknvrkHKTQ8JsFAkslZFn6IeHsZQWl2DG0Z+5imyZlOERYDGsZqPQl1?=
 =?us-ascii?Q?xwwik/2XjF0tr1gLnfbh88EJyc557gfl3DhlVBJggZLW4UNn+Sc5L1W/wzVO?=
 =?us-ascii?Q?NsQRerY3MJG4xYe4h/QOluQrADET5wZ92Pic1B2tMHXMm4JAhVd+bJSY70ft?=
 =?us-ascii?Q?F9U64/gW8+g0+51krErD+9rCnq5F3w5uBUGyKK3FKM+BzK1r7CPV8Kc1kHQc?=
 =?us-ascii?Q?wHU1dTly/e9JUnstUsOtBkrfv6lQKwOUJIjAxJ8tN/1R5xaPrZDHPwQkHuCa?=
 =?us-ascii?Q?GYrDIxGD5LFdNFqKER3Hugd+BvDTcvo+WycetkyQtWmwfAhaLZ8OTrc+HYsG?=
 =?us-ascii?Q?Im5OB/tUtiD1Q96b1b81Ay4uuF1yDhlPH9CkL5qTEvlpvSDFe7Vt+w1a3QLy?=
 =?us-ascii?Q?VrjUKqByG/93w7JYgLBbfVTOKO2xJCBoeQl6bZZSU7QQCQ3DSWsf1XaNK79a?=
 =?us-ascii?Q?N7pIAJdVGjr1ctNxzYg28RlyytsFA/KDnJzRRvpbTRyMMp/4pEt64zGFJ56E?=
 =?us-ascii?Q?dbLWhE4Qj7wTZZQp5YOFoL3YjpYjTi0K+FaaKpkQNh2RThh5Gnc6/Idgn06T?=
 =?us-ascii?Q?mbWiX/VkzB1jXdbJmDk6YeepGOqZcBgL49QWBDOT+ea1OjYBsHP8APqMzZsJ?=
 =?us-ascii?Q?oemPhetdjrblgjZ1Ac5Cz/H/pwMfV5L3Q9tO58RXFkdMeiwX5Hl33HGh+Sil?=
 =?us-ascii?Q?ZDfXE4H+oGUs37Vh8YdOSLlUf4eKMN23TVR6Lru1zQjqV45NDFJQKqM/9NiW?=
 =?us-ascii?Q?ZMfzg0bhVhxMJkXnii4hbXXPlDOqzmRMiE/Xt/6r2JIA3djqH2kTFW1/SwUT?=
 =?us-ascii?Q?9XuqGj92VQn+0Lv1e4Xn2R2Q5z+MJj1Qj2hFpQhHvxOATSxOT2eeL1rFQIQt?=
 =?us-ascii?Q?k3OZexSDCXGz9YihPdywG+s+C7B3wIhWTpe+jwipbwKNXZWsfNXXUHnbn5Hh?=
 =?us-ascii?Q?b6cGnwEYnTsTA3lg4Nze2E0QbIhTctrETjzksetH/JnM1jQKlF/Ei3PTNeFt?=
 =?us-ascii?Q?A+EFErbCHFuzbeI/A/CfFvk68/sQNn88EpZ1rGVMoywTHyXJfgCusHWLi8dB?=
 =?us-ascii?Q?9+ozPPh96HaPedaOSVjDH0bu8t6Jh5Syx0w7JTGdaUxnc6XbFY4yNEAYgkYs?=
 =?us-ascii?Q?dUdzOPV0GSZAF7pZ03ddj1zjIfGRF9T13r7nw4od/+uCTAFX0fPegu+UUt2D?=
 =?us-ascii?Q?zHw5qETTfbLliNuEJarCO9rUkAZdqeSQfJ9c7FbGhnBuYnFD1j54WFDszQ7I?=
 =?us-ascii?Q?GJF51ZrSV6rAquCF2WkRRahWhsfPXaM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d82ee3d-1a6d-46b4-1264-08da31f4b23a
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 19:47:05.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AoWVPs3E0+lhHjmmZIU0isjBLJHcq3/ZuV3+5UVVEP1myuuvpaQ24Z8rLsqvdRimN+ot+jl+6jfG0ueuC4TW8eMWTsqwlL3MJDNQL0v4oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5904
X-Proofpoint-ORIG-GUID: 3qa5mQB3PZGuEkRd2nSST8UMzPcJU1I5
X-Proofpoint-GUID: 3qa5mQB3PZGuEkRd2nSST8UMzPcJU1I5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=930
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was using the TX IRQ handler to perform all TX completion
tasks. Under heavy TX network load, this can cause significant irqs-off
latencies (found to be in the hundreds of microseconds using ftrace).
This can cause other issues, such as overrunning serial UART FIFOs when
using high baud rates with limited UART FIFO sizes.

Switch to using a NAPI poll handler to perform the TX completion work
to get this out of hard IRQ context and avoid the IRQ latency impact. A
separate NAPI instance is used for TX and RX to avoid checking the other
ring's state unnecessarily when doing the poll, and so that the NAPI
budget handling can work for both TX and RX packets.

A new per-queue tx_ptr_lock spinlock has been added to avoid using the
main device lock (with IRQs needing to be disabled) across the entire TX
mapping operation, and also to protect the TX queue pointers from
concurrent access between the TX start and TX poll operations.

The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved into
the TX NAPI poll handler to maintain the proper order of operations. A flag
is used to notify the poll handler that a UBR condition needs to be
handled. The macb_tx_restart handler has had some locking added for global
register access, since this could now potentially happen concurrently on
different queues.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb.h      |   6 +-
 drivers/net/ethernet/cadence/macb_main.c | 228 ++++++++++++++++-------
 2 files changed, 161 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index f0a7d8396a4a..7ca077b65eaa 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1204,11 +1204,15 @@ struct macb_queue {
 	unsigned int		RBQP;
 	unsigned int		RBQPH;
 
+	/* Lock to protect tx_head and tx_tail */
+	spinlock_t		tx_ptr_lock;
 	unsigned int		tx_head, tx_tail;
 	struct macb_dma_desc	*tx_ring;
 	struct macb_tx_skb	*tx_skb;
 	dma_addr_t		tx_ring_dma;
 	struct work_struct	tx_error_task;
+	bool			txubr_pending;
+	struct napi_struct	napi_tx;
 
 	dma_addr_t		rx_ring_dma;
 	dma_addr_t		rx_buffers_dma;
@@ -1217,7 +1221,7 @@ struct macb_queue {
 	struct macb_dma_desc	*rx_ring;
 	struct sk_buff		**rx_skbuff;
 	void			*rx_buffers;
-	struct napi_struct	napi;
+	struct napi_struct	napi_rx;
 	struct queue_stats stats;
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 160dc5ad84ae..e993616308f8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -959,7 +959,7 @@ static int macb_halt_tx(struct macb *bp)
 	return -ETIMEDOUT;
 }
 
-static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
+static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int budget)
 {
 	if (tx_skb->mapping) {
 		if (tx_skb->mapped_as_page)
@@ -972,7 +972,7 @@ static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
 	}
 
 	if (tx_skb->skb) {
-		dev_kfree_skb_any(tx_skb->skb);
+		napi_consume_skb(tx_skb->skb, budget);
 		tx_skb->skb = NULL;
 	}
 }
@@ -1025,12 +1025,13 @@ static void macb_tx_error_task(struct work_struct *work)
 		    (unsigned int)(queue - bp->queues),
 		    queue->tx_tail, queue->tx_head);
 
-	/* Prevent the queue IRQ handlers from running: each of them may call
-	 * macb_tx_interrupt(), which in turn may call netif_wake_subqueue().
+	/* Prevent the queue NAPI TX poll from running, as it calls
+	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
 	 * As explained below, we have to halt the transmission before updating
 	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
 	 * network engine about the macb/gem being halted.
 	 */
+	napi_disable(&queue->napi_tx);
 	spin_lock_irqsave(&bp->lock, flags);
 
 	/* Make sure nobody is trying to queue up new packets */
@@ -1058,7 +1059,7 @@ static void macb_tx_error_task(struct work_struct *work)
 		if (ctrl & MACB_BIT(TX_USED)) {
 			/* skb is set for the last buffer of the frame */
 			while (!skb) {
-				macb_tx_unmap(bp, tx_skb);
+				macb_tx_unmap(bp, tx_skb, 0);
 				tail++;
 				tx_skb = macb_tx_skb(queue, tail);
 				skb = tx_skb->skb;
@@ -1088,7 +1089,7 @@ static void macb_tx_error_task(struct work_struct *work)
 			desc->ctrl = ctrl | MACB_BIT(TX_USED);
 		}
 
-		macb_tx_unmap(bp, tx_skb);
+		macb_tx_unmap(bp, tx_skb, 0);
 	}
 
 	/* Set end of TX queue */
@@ -1118,27 +1119,20 @@ static void macb_tx_error_task(struct work_struct *work)
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 
 	spin_unlock_irqrestore(&bp->lock, flags);
+	napi_enable(&queue->napi_tx);
 }
 
-static void macb_tx_interrupt(struct macb_queue *queue)
+static int macb_tx_complete(struct macb_queue *queue, int budget)
 {
-	unsigned int tail;
-	unsigned int head;
-	u32 status;
 	struct macb *bp = queue->bp;
 	u16 queue_index = queue - bp->queues;
+	unsigned int tail;
+	unsigned int head;
+	int packets = 0;
 
-	status = macb_readl(bp, TSR);
-	macb_writel(bp, TSR, status);
-
-	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-		queue_writel(queue, ISR, MACB_BIT(TCOMP));
-
-	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
-		    (unsigned long)status);
-
+	spin_lock(&queue->tx_ptr_lock);
 	head = queue->tx_head;
-	for (tail = queue->tx_tail; tail != head; tail++) {
+	for (tail = queue->tx_tail; tail != head && packets < budget; tail++) {
 		struct macb_tx_skb	*tx_skb;
 		struct sk_buff		*skb;
 		struct macb_dma_desc	*desc;
@@ -1179,10 +1173,11 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 				queue->stats.tx_packets++;
 				bp->dev->stats.tx_bytes += skb->len;
 				queue->stats.tx_bytes += skb->len;
+				packets++;
 			}
 
 			/* Now we can safely release resources */
-			macb_tx_unmap(bp, tx_skb);
+			macb_tx_unmap(bp, tx_skb, budget);
 
 			/* skb is set only for the last buffer of the frame.
 			 * WARNING: at this point skb has been freed by
@@ -1198,6 +1193,9 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 	    CIRC_CNT(queue->tx_head, queue->tx_tail,
 		     bp->tx_ring_size) <= MACB_TX_WAKEUP_THRESH(bp))
 		netif_wake_subqueue(bp->dev, queue_index);
+	spin_unlock(&queue->tx_ptr_lock);
+
+	return packets;
 }
 
 static void gem_rx_refill(struct macb_queue *queue)
@@ -1569,15 +1567,15 @@ static bool macb_rx_pending(struct macb_queue *queue)
 	return (desc->addr & MACB_BIT(RX_USED)) != 0;
 }
 
-static int macb_poll(struct napi_struct *napi, int budget)
+static int macb_rx_poll(struct napi_struct *napi, int budget)
 {
-	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
+	struct macb_queue *queue = container_of(napi, struct macb_queue, napi_rx);
 	struct macb *bp = queue->bp;
 	int work_done;
 
 	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
 
-	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
+	netdev_vdbg(bp->dev, "RX poll: queue = %u, work_done = %d, budget = %d\n",
 		    (unsigned int)(queue - bp->queues), work_done, budget);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -1607,6 +1605,90 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
+static void macb_tx_restart(struct macb_queue *queue)
+{
+	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
+
+	spin_lock(&queue->tx_ptr_lock);
+
+	if (queue->tx_head == queue->tx_tail)
+		goto out_tx_ptr_unlock;
+
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, queue->tx_head));
+
+	if (tbqp == head_idx)
+		goto out_tx_ptr_unlock;
+
+	spin_lock_irq(&bp->lock);
+	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+	spin_unlock_irq(&bp->lock);
+
+out_tx_ptr_unlock:
+	spin_unlock(&queue->tx_ptr_lock);
+}
+
+static bool macb_tx_complete_pending(struct macb_queue *queue)
+{
+	bool retval = false;
+
+	spin_lock(&queue->tx_ptr_lock);
+	if (queue->tx_head != queue->tx_tail) {
+		/* Make hw descriptor updates visible to CPU */
+		rmb();
+
+		if (macb_tx_desc(queue, queue->tx_tail)->ctrl & MACB_BIT(TX_USED))
+			retval = true;
+	}
+	spin_unlock(&queue->tx_ptr_lock);
+	return retval;
+}
+
+static int macb_tx_poll(struct napi_struct *napi, int budget)
+{
+	struct macb_queue *queue = container_of(napi, struct macb_queue, napi_tx);
+	struct macb *bp = queue->bp;
+	int work_done;
+
+	work_done = macb_tx_complete(queue, budget);
+
+	rmb(); // ensure txubr_pending is up to date
+	if (queue->txubr_pending) {
+		queue->txubr_pending = false;
+		netdev_vdbg(bp->dev, "poll: tx restart\n");
+		macb_tx_restart(queue);
+	}
+
+	netdev_vdbg(bp->dev, "TX poll: queue = %u, work_done = %d, budget = %d\n",
+		    (unsigned int)(queue - bp->queues), work_done, budget);
+
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		queue_writel(queue, IER, MACB_BIT(TCOMP));
+
+		/* Packet completions only seem to propagate to raise
+		 * interrupts when interrupts are enabled at the time, so if
+		 * packets were sent while interrupts were disabled,
+		 * they will not cause another interrupt to be generated when
+		 * interrupts are re-enabled.
+		 * Check for this case here to avoid losing a wakeup. This can
+		 * potentially race with the interrupt handler doing the same
+		 * actions if an interrupt is raised just after enabling them,
+		 * but this should be harmless.
+		 */
+		if (macb_tx_complete_pending(queue)) {
+			queue_writel(queue, IDR, MACB_BIT(TCOMP));
+			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+				queue_writel(queue, ISR, MACB_BIT(TCOMP));
+			netdev_vdbg(bp->dev, "TX poll: packets pending, reschedule\n");
+			napi_schedule(napi);
+		}
+	}
+
+	return work_done;
+}
+
 static void macb_hresp_error_task(struct tasklet_struct *t)
 {
 	struct macb *bp = from_tasklet(bp, t, hresp_err_tasklet);
@@ -1646,29 +1728,6 @@ static void macb_hresp_error_task(struct tasklet_struct *t)
 	netif_tx_start_all_queues(dev);
 }
 
-static void macb_tx_restart(struct macb_queue *queue)
-{
-	unsigned int head = queue->tx_head;
-	unsigned int tail = queue->tx_tail;
-	struct macb *bp = queue->bp;
-	unsigned int head_idx, tbqp;
-
-	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-		queue_writel(queue, ISR, MACB_BIT(TXUBR));
-
-	if (head == tail)
-		return;
-
-	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
-	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
-	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
-
-	if (tbqp == head_idx)
-		return;
-
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
-}
-
 static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
 {
 	struct macb_queue *queue = dev_id;
@@ -1765,9 +1824,27 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, MACB_BIT(RCOMP));
 
-			if (napi_schedule_prep(&queue->napi)) {
+			if (napi_schedule_prep(&queue->napi_rx)) {
 				netdev_vdbg(bp->dev, "scheduling RX softirq\n");
-				__napi_schedule(&queue->napi);
+				__napi_schedule(&queue->napi_rx);
+			}
+		}
+
+		if (status & (MACB_BIT(TCOMP) |
+			      MACB_BIT(TXUBR))) {
+			queue_writel(queue, IDR, MACB_BIT(TCOMP));
+			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+				queue_writel(queue, ISR, MACB_BIT(TCOMP) |
+							 MACB_BIT(TXUBR));
+
+			if (status & MACB_BIT(TXUBR)) {
+				queue->txubr_pending = true;
+				wmb(); // ensure softirq can see update
+			}
+
+			if (napi_schedule_prep(&queue->napi_tx)) {
+				netdev_vdbg(bp->dev, "scheduling TX softirq\n");
+				__napi_schedule(&queue->napi_tx);
 			}
 		}
 
@@ -1781,12 +1858,6 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 			break;
 		}
 
-		if (status & MACB_BIT(TCOMP))
-			macb_tx_interrupt(queue);
-
-		if (status & MACB_BIT(TXUBR))
-			macb_tx_restart(queue);
-
 		/* Link change detection isn't possible with RMII, so we'll
 		 * add that if/when we get our hands on a full-blown MII PHY.
 		 */
@@ -2019,7 +2090,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 	for (i = queue->tx_head; i != tx_head; i++) {
 		tx_skb = macb_tx_skb(queue, i);
 
-		macb_tx_unmap(bp, tx_skb);
+		macb_tx_unmap(bp, tx_skb, 0);
 	}
 
 	return 0;
@@ -2141,7 +2212,6 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 queue_index = skb_get_queue_mapping(skb);
 	struct macb *bp = netdev_priv(dev);
 	struct macb_queue *queue = &bp->queues[queue_index];
-	unsigned long flags;
 	unsigned int desc_cnt, nr_frags, frag_size, f;
 	unsigned int hdrlen;
 	bool is_lso;
@@ -2198,16 +2268,16 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		desc_cnt += DIV_ROUND_UP(frag_size, bp->max_tx_length);
 	}
 
-	spin_lock_irqsave(&bp->lock, flags);
+	spin_lock_bh(&queue->tx_ptr_lock);
 
 	/* This is a hard error, log it. */
 	if (CIRC_SPACE(queue->tx_head, queue->tx_tail,
 		       bp->tx_ring_size) < desc_cnt) {
 		netif_stop_subqueue(dev, queue_index);
-		spin_unlock_irqrestore(&bp->lock, flags);
 		netdev_dbg(bp->dev, "tx_head = %u, tx_tail = %u\n",
 			   queue->tx_head, queue->tx_tail);
-		return NETDEV_TX_BUSY;
+		ret = NETDEV_TX_BUSY;
+		goto unlock;
 	}
 
 	/* Map socket buffer for DMA transfer */
@@ -2220,13 +2290,15 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	wmb();
 	skb_tx_timestamp(skb);
 
+	spin_lock_irq(&bp->lock);
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+	spin_unlock_irq(&bp->lock);
 
 	if (CIRC_SPACE(queue->tx_head, queue->tx_tail, bp->tx_ring_size) < 1)
 		netif_stop_subqueue(dev, queue_index);
 
 unlock:
-	spin_unlock_irqrestore(&bp->lock, flags);
+	spin_unlock_bh(&queue->tx_ptr_lock);
 
 	return ret;
 }
@@ -2760,8 +2832,10 @@ static int macb_open(struct net_device *dev)
 		goto pm_exit;
 	}
 
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
-		napi_enable(&queue->napi);
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+		napi_enable(&queue->napi_rx);
+		napi_enable(&queue->napi_tx);
+	}
 
 	macb_init_hw(bp);
 
@@ -2785,8 +2859,10 @@ static int macb_open(struct net_device *dev)
 
 reset_hw:
 	macb_reset_hw(bp);
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
-		napi_disable(&queue->napi);
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+		napi_disable(&queue->napi_rx);
+		napi_disable(&queue->napi_tx);
+	}
 	macb_free_consistent(bp);
 pm_exit:
 	pm_runtime_put_sync(&bp->pdev->dev);
@@ -2802,8 +2878,10 @@ static int macb_close(struct net_device *dev)
 
 	netif_tx_stop_all_queues(dev);
 
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
-		napi_disable(&queue->napi);
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+		napi_disable(&queue->napi_rx);
+		napi_disable(&queue->napi_tx);
+	}
 
 	phylink_stop(bp->phylink);
 	phylink_disconnect_phy(bp->phylink);
@@ -3865,7 +3943,9 @@ static int macb_init(struct platform_device *pdev)
 
 		queue = &bp->queues[q];
 		queue->bp = bp;
-		netif_napi_add(dev, &queue->napi, macb_poll, NAPI_POLL_WEIGHT);
+		spin_lock_init(&queue->tx_ptr_lock);
+		netif_napi_add(dev, &queue->napi_rx, macb_rx_poll, NAPI_POLL_WEIGHT);
+		netif_napi_add(dev, &queue->napi_tx, macb_tx_poll, NAPI_POLL_WEIGHT);
 		if (hw_q) {
 			queue->ISR  = GEM_ISR(hw_q - 1);
 			queue->IER  = GEM_IER(hw_q - 1);
@@ -4972,8 +5052,10 @@ static int __maybe_unused macb_suspend(struct device *dev)
 
 	netif_device_detach(netdev);
 	for (q = 0, queue = bp->queues; q < bp->num_queues;
-	     ++q, ++queue)
-		napi_disable(&queue->napi);
+	     ++q, ++queue) {
+		napi_disable(&queue->napi_rx);
+		napi_disable(&queue->napi_tx);
+	}
 
 	if (!(bp->wol & MACB_WOL_ENABLED)) {
 		rtnl_lock();
@@ -5051,8 +5133,10 @@ static int __maybe_unused macb_resume(struct device *dev)
 	}
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues;
-	     ++q, ++queue)
-		napi_enable(&queue->napi);
+	     ++q, ++queue) {
+		napi_enable(&queue->napi_rx);
+		napi_enable(&queue->napi_tx);
+	}
 
 	if (netdev->hw_features & NETIF_F_NTUPLE)
 		gem_writel_n(bp, ETHT, SCRT2_ETHT, bp->pm_data.scrt2);
-- 
2.31.1

