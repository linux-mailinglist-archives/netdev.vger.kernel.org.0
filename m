Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A09523CCA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346454AbiEKSpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 14:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346450AbiEKSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 14:45:17 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE679E15C0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 11:45:16 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BBKUFF030957;
        Wed, 11 May 2022 14:44:55 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02p2rnjq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 14:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqKI84QGJ1YPgCGbWC9G2Fc88P5N0xqDjoWdJdpBvIZ6QJRAfURV0CslrINud6oztpxUetAe6ccbE395/ylOmjRy20tfNlZw/5veUhFiO4FNGMS/4/7iQ2frnKE9MheHGNyShcvcGqrr8WvQ4K3NQ+fT8zNiMLrSwZDWg7Oec+Fyy1j20hatapvtR6x8j/XiWJSQmYtC4m3BJ0oeeodcRPo29KU7+QqyV+UZAKTS4X4ECFsOdyjCuy8ism+V9x9lSuokY0mdOo9Eqk1f0qM24KwDLatJ/ek/UM766hnmzk9slXWexxSj5cXleKQ9Np3M4sr0+bEqUzs1XDZ25+g8hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KR86AYjvDlwiMHH86oLOoefoVhOtD8eH3qP9z/88h+M=;
 b=bKLl0LAwmOT9A/mXCK59AjP2kqrC/avxks/LOpv0E/vMnCBRJL+FVm3iyf7c5fkb1S0VfDX3cAlqBNAloDNb3p8q+bUJ6ctsJ1aENvIuLLNdD7upcnnaOW60l5NDq4+qF4FCfbm+sGO134zHhkdQkZOuP+SFENnuyPcBlsKPItFj1vJM8jAF3tDqiqCi5IwuVrvjd0QQP6AJgoLB4QQXHVxSpkvCBqFXbVAdeYRDY03/GOuwwQcvecgakQNWHPHhsN5BnnF6Njf0c7yxnJjMaP242X6NFDN+ZEGjXwSR87tUC5im3tCWqvGAApPa0520gC/i3Rs2jW2V6Ezfr88eIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR86AYjvDlwiMHH86oLOoefoVhOtD8eH3qP9z/88h+M=;
 b=2Hw8zUboeTeQV+mwth5HeKKotz1Mlq7DUd9snG404tj4Q+YogPoZtcSXpkfvu9KCEOfLENNt/DxE5jwRcoVfwUHQdjoZj/R0VCctPd7UoesbjbyP++pBE8RoTubCWFYOgYiXHNQOMTL6yRFtGZE3ZnC92GGFRkjzMSQ3Nm8RWxk=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:52::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 18:44:54 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:44:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v6 1/2] net: axienet: Be more careful about updating tx_bd_tail
Date:   Wed, 11 May 2022 12:44:31 -0600
Message-Id: <20220511184432.1131256-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220511184432.1131256-1-robert.hancock@calian.com>
References: <20220511184432.1131256-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::18) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b2570ac-db61-4ef3-2a46-08da337e567a
X-MS-TrafficTypeDiagnostic: YT2PR01MB5427:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB542793A50FFD7B01F380C601ECC89@YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwpRW3rBdePt/FEbReObxkcRj+YmAGa3FbkuXFcN/EA17muALSBI0H+4eRmHJueFWzGlM8s3U3cDaqDphjTvvaax67VSrihG9SSP0lgpgctPesXx/pmynZlOmG9pjiW1USK8FVNG7MCmtDEpaOGZYfzuPll8jNgtkCssGqXbYiztQwVKhT0ocLeiQtrFbtAJ1lM8bs4xIr/4c13Jz1FgFMxo3FQP4SLxU19XWhe2L76BBnoDNkc+LHCO93NbLX3Ov4bJ4hzjOjw4dHpWYiYelf8bYTbfuOAHjKRPlWpZCZ80RsbqOAyCd86h0qU3T3wk56qos9UTXwQh/N6Ya+roBGdJLUOGzXTLcyZOe/JAPdAyXlXmD3Q6ZAvZMASorH10vgTKPQ+5MdiXr74mCvCa+OKOE5+kftejKmjc23QJBONJ6hWXeyyqR/e+fL4C6hUWvaYSzU+Qk6mdw8gk8S50RyWFfKo/z//cMaOr7ls6O9inIb2HeqnhQpLgiqD7hgx0rHxPggF3aDWsUx2IvzPOVvMCaKDxphZn1rQ99Aoww0BqNxlHRIIm+qDpX1s5BMtRzVziO6s0kECfaNATvYyUhO7quXuGIWOoH/O7LBzi8TiFMx1x5mlnrrORV/o9/yJgp9Hz5WfJpGQL5cka5B6O6myKIepdahbAPT2C8tSBOUycsNns4brpdZYob3Rji0LR33+bPmU1Qmuj8HE580DrQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(44832011)(36756003)(8936002)(2616005)(66476007)(6916009)(8676002)(66946007)(4326008)(66556008)(38350700002)(38100700002)(26005)(107886003)(6512007)(6486002)(316002)(508600001)(2906002)(5660300002)(186003)(6666004)(52116002)(1076003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tzofr6NvCTgzqt11bial56k9VyUd3aPNdYQhWBpKEKE3g95OgkMwJToBA/pZ?=
 =?us-ascii?Q?JBflRHE/OtEbvTtyUJdLn8k6h89eys1qKo64NbShq1A9yNQfdaPwmKe8xcCd?=
 =?us-ascii?Q?7snaeUwvLbutrUrceUpH4EM2cAgudpUrPkSqb9RW+RvOg4g2+MULe1+1IGtE?=
 =?us-ascii?Q?51/TGV56fjyJUI4DDnl3xu67EwHgfBsWp+7QFR2CCtcYieuWtppEr311Amc+?=
 =?us-ascii?Q?XuURgYTBiROWD06h15ZgQ0aE8xEmHkeCa4DHsNBj5um9AtPkUkz3f5JpWAc9?=
 =?us-ascii?Q?TjRug94Y9LVDOxVrVMXBuPCXS5em0bYLWJIRUCHr9hKYoH1gZRp6Qbg2MTj0?=
 =?us-ascii?Q?2Zm7XCznYf7oWHHxdDvBiYwGOmLks1rnRFCWgmgLKcB3yLfMg/oPeDLDa1d+?=
 =?us-ascii?Q?VyDD983Ivo43smWkJZHKxTgNk+FXrT5x4ZgeXgHr58r9ceIIfevLsX12UxoJ?=
 =?us-ascii?Q?yCqXrf4myWuD4vh4XDN7RDdEnGeMckcMJoudLUk3AY1IZL1w1sjkfwOgrf3e?=
 =?us-ascii?Q?Mne9VM/Tpc+NWg0+vct563BY2EN7D5Se/jfPbuG4s9plEyErbQ3xZ2+YqJvE?=
 =?us-ascii?Q?hedrtWzp/stOocaaMPq2ka+qPbkEDBWdWYzcVkYPBDIe9cWUbw7PhwccpIfF?=
 =?us-ascii?Q?o/Pg27Fi1rkOK7S/QUYXf32XmE6YThNb+7MiRnxsC0IyiInsNscKn7eK3/EN?=
 =?us-ascii?Q?Jdrno3yvjZ5GMgUrUFVeLqeFqcwrOhuq4MbkfR+WuSwDXvymkhly1sCYq06q?=
 =?us-ascii?Q?7J4tfax4GbW/J+TLEaC/NU1WjwDQa+WWrJqqrxQ4mUKZDiKCMiMGXXTyWyPC?=
 =?us-ascii?Q?iKt7Eyitc9L/L+SDSLxrcqb1GPWMZ4MHThwqjyJRbBQQon/2Qh/4zNcex9cf?=
 =?us-ascii?Q?hdjJ0B4wEYCrZuDjMirSiBrS8WXcJbS/aUCmiM4vip6OD2GxzgAUnXC3QUaL?=
 =?us-ascii?Q?eeKTSK8m95j1iyPjtKUQ8g8EkIws3nZkWOkv0CFAy2oprWNn0b7eTzRelp2y?=
 =?us-ascii?Q?e6dOVoBdtCXzPVP4Ff/sfwHL8/HbKkg5VExGt/CWC0dlEdV5nS9+eDFxU3v1?=
 =?us-ascii?Q?8wdHWehNDVr67f1LkImuifa/tjoOLJ+geGreDd+GMtgunYYD5tfKjf4ePT3R?=
 =?us-ascii?Q?08RXztvvLkApZXd9aUBotUMrFAAqut4MUaAERYax54JJsQXaTimaUx1K+pJE?=
 =?us-ascii?Q?ja+wcqj0xNDVBdFiCnfhuKS2L5KEVzmtzdafbnsHafxu7DLzflm8uStbWX8s?=
 =?us-ascii?Q?VS0fZOdyWDU0FJUeiTHYlchc50xwTtEpjSE/0hVVVQ0najwYClTz6iLWcu5k?=
 =?us-ascii?Q?gB0EcISKvYk/hX/ce36bpcE1QOmWmdPD8m3knBRDQ0Yu1O9s7oWxCJRHIo8P?=
 =?us-ascii?Q?gcUE0vX/nM8E0fBvu6dmvbYgfkmzxDg24pg/AS5EHTPvZ9Opp57Jbtr8pfXi?=
 =?us-ascii?Q?GMSdo39w/s/asGSOYs0Gdi6ou4vRsFTwa5K7eF+0DL76icJ9ZMrr9S7/uTPj?=
 =?us-ascii?Q?TxHihb6eMNGCOb4zTuUqmEvxLhQkYbUZYRo2AlIX/I/5Jq7h4o2aA85Cd9Td?=
 =?us-ascii?Q?EDa0BtO3LTMQvafOpPkyfbXzJo5/KoQzp/mf+3y0kRd6OAFDhq7rZWRuFYkd?=
 =?us-ascii?Q?0CMFUI5rVCUYxOHJwkJg12U/xA4veJBipClt+Ebfrgl7zXstnt2sYIeUPFAH?=
 =?us-ascii?Q?ZP7cgJjDDmi3sq/FIEK5nKGu7CMbdwtjfIEsvk9rEANbye5hxE+t0e2wqDE4?=
 =?us-ascii?Q?LO5mWqkM5zDv3yvwG6YeLQ7mabYWwyA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2570ac-db61-4ef3-2a46-08da337e567a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:44:53.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DYuFfCuL4Q0UZrLvWF4nZooE1Wr/0plDXra6FCLxin6cKNCUMy2Ad3x9ygtoD8z87ZMbor1s2cGWRfgMmVRe7SwoSWY6byV4lJyB0UILaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5427
X-Proofpoint-ORIG-GUID: z6v_3Y9vBfIhPaS0-eC7n9SdLdhubR8b
X-Proofpoint-GUID: z6v_3Y9vBfIhPaS0-eC7n9SdLdhubR8b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=640
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axienet_start_xmit function was updating the tx_bd_tail variable
multiple times, with potential rollbacks on error or invalid
intermediate positions, even though this variable is also used in the
TX completion path. Use READ_ONCE and WRITE_ONCE to make this update
more atomic, and move the write before the MMIO write to start the
transfer, so it is protected by that implicit write barrier.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d6fc3f7acdf0..2f39eb4de249 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -807,12 +807,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 csum_index_off;
 	skb_frag_t *frag;
 	dma_addr_t tail_p, phys;
+	u32 orig_tail_ptr, new_tail_ptr;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	u32 orig_tail_ptr = lp->tx_bd_tail;
+
+	orig_tail_ptr = READ_ONCE(lp->tx_bd_tail);
+	new_tail_ptr = orig_tail_ptr;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
-	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+	cur_p = &lp->tx_bd_v[orig_tail_ptr];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		/* Should not happen as last start_xmit call should have
@@ -852,9 +855,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
@@ -866,8 +869,6 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
 					      NULL);
-			lp->tx_bd_tail = orig_tail_ptr;
-
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
@@ -877,11 +878,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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

