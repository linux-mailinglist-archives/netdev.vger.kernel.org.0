Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5160D5158BD
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381642AbiD2XBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbiD2XBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:01:12 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Apr 2022 15:57:52 PDT
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5D8CE4A5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:57:52 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TJlrLT015844;
        Fri, 29 Apr 2022 18:31:50 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fprskj8gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:31:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9YjViWDn/ySvRyDEr2kIjh5NumtnPLyaQmcBD2lJHS2d8yg5KmoCOaQruLEf19fOMQN6AHc+T64XgWlFQn21BIEF0vB8HtYQdlI3pUMNN/Tv0PC2aYSqpEbF6VQE0fggljKhFJsfjrv0B/StuGlFIiSRyH5Aq98OKJtyT9uF0H7P71qPRv7+7YtbhpsYF8spnennzmfX/p0Lzfbbvbu3iWqDEy4io3n9LjSxmaPBBpPICZNElyHaYWRe/YUN6J1alL/8XjbuS2xHIIy0c44MaVVAlUflPlKf9LoW6NC5uZTUF/Asn82ny3FeaU4Gqv/JdniUUnn/Bmexad9F3KL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LzAaFLsdzcmEsfjoiGZtzy/75gN7h90SJNzJLUh6oY=;
 b=H8XWpM5YWPWL0y66NBbH5TuealM63/bBzQq3/3P63duB1QzP/iyXmFzDBnR5HAO71IRk7A2lTL4JbJFrYFxG3Ti1rmMfmKciFC+u/UmkEi5PID9g5MhisBk31kXswwigHPbunNMjOh0MDAuOyrg1THjcDcYfoVemaenKoHhJcaMGXT1NZ9A5xuLwDb+crBNXQjFhpEDu0oQqjDFzqFDjHLbqMNaXaT7G2A3KKkWq7bUwbFI9rADTFs4qiu5wdmX11O+b3q28omRsOzt4ptZ2QzOURz1OJKn9d6APuTrpgfFplwJIabCF+y2HIwfA1kTeYFYSX2SbhqOa3H6g9+EfrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LzAaFLsdzcmEsfjoiGZtzy/75gN7h90SJNzJLUh6oY=;
 b=JGDPoJL/VSttEK8RN0m+slqDUHcQnPJYlu8OX8vnZqQnN/6dgxIO7VBJ82DdHHPoOElkqwAgsGsZsrg2gJP51dqEwv4borKFe53UTosRvXOlE1p4tY3HGmp1TFKksDkzOae+DTwZKDiW6CNoP5YLBfqwGiE3KlkJkMUNyJv78/Q=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 22:31:48 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 22:31:48 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Date:   Fri, 29 Apr 2022 16:31:22 -0600
Message-Id: <20220429223122.3642255-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220429223122.3642255-1-robert.hancock@calian.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0097.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 865ba5c1-bde0-4c1f-d1b5-08da2a300c82
X-MS-TrafficTypeDiagnostic: YT1PR01MB8361:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB836155F659BFC7C6995F8670ECFC9@YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JADkfwgvyu1RP7r8J/7pIa2WX1q4haQsprLuOtRIVkZDnlyWQBvDJ6MCOXHT2Ss5/Eh+mYiiXG8TCSB8b2QvXYdo+HMWTNVr3O8/0s9s8rcBHktPEcF4jM7jH29PNGJDjZ74hBgrujvpbdMDEWHVa2bMi4dOeF6d49PflVFqpx4eZNmJ3/OEvGYm5qDxHBtzzuLjNIR7MrQizW6k+2qSoY0wPPmXsN6qXojCJLgwsEelt7sYGA8jaQcQQfSlTGbIdKObfVqKmsnuHdua0J2iSkDDX7rHwMqZ6ku/Cy/Koz7P+o5i4O3QbFD9oFeWPsJLwsoy+hkS49CySxqI0j7gfZZkkSgFwFo40wfdfLXP4wL0bAfWdtE07pzl9s/dmWMykEsfI/BOeZ30F6K/dAG1kCI/5f+NJJ/WWNet04QvKSB5k0N6RIwqRkfeYIzSXP/EW/Ym0mYp1Lkt/K1cfEZiy2NwnYNiySFUaTN2kp97FbF2So6m79JpOdTxSMU+8J2h1wWP3aojGo3p2y6sZ1ZTkYYMij6U3aaDIgILgoWwNsWhj4NVQBZ4VnjE3mbGNY/1m9yAubKehvqjr3RtXbbtXyzT2w5DztXk9+sD/zpPkaYzsyb6FDmaRaoWufvFKrD3CFZ3tl/F82Ki8IZ3hMJjLzJ4cc2ZL8fG/A5TXB1bIEudL/KE2gY535Xx9H+WsxYJejY12WrtPoXy4WoygMZLug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(36756003)(6916009)(1076003)(6666004)(316002)(2906002)(2616005)(107886003)(44832011)(6486002)(508600001)(5660300002)(186003)(8936002)(83380400001)(8676002)(66476007)(4326008)(6512007)(66946007)(66556008)(26005)(86362001)(38350700002)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r9AhS8ouMRIWQfn3gonhYtjIvqiWM0PeiE+HSCEDu3i1GL5oYigmf3APGBgP?=
 =?us-ascii?Q?NWAZU8S51JGRgInQ2eK1tnsv/1BSDgPS6RBTwF/q+ac6zIQTnFgcYnQ4VIqB?=
 =?us-ascii?Q?UNTiWC8txbBWx40cBWyXmUOskJAmt1vqly44BZM5uQRnYfVKaWBKBtEG4s8A?=
 =?us-ascii?Q?ryV+/+wGkcIpk0hWo4ntyq0KuRa1Yy01g29Vync/oUQrHo9/+/sP48W3dheE?=
 =?us-ascii?Q?jZixLfrtQ1gTM8sSRnp+ydGcy+1w8+2zIBd00Er1BfxFUNOjXgjqpQNRr2VI?=
 =?us-ascii?Q?tUrZw+vPX/gfGhbmnnYflsP4TpJZ6CitFlQuu/Z71pu6xzqYG5TUCHpaVs9Z?=
 =?us-ascii?Q?d+qZcMrHBgS6c+EAiFjGbA1eQz7MYc//K6s1qm0gqH7M2/heAnyb0IY9Q8A5?=
 =?us-ascii?Q?rZexZjLbUfm0PTrWKg+4vPt4PPXkoaJJbkXi9v22rBSl4dAPvTCOZWAzpFkh?=
 =?us-ascii?Q?irgfu+J/x24XiOSSkkj9HtyAJhDQE5w2AE9+9mm87yrvBmZiqDfK2FdJ9yaz?=
 =?us-ascii?Q?cMBIXAqlHzcC6g4AIphjyy+tyrDcAEiklmGfgnEo97S0K9yNT0BARLJkur9y?=
 =?us-ascii?Q?YFe6yRHqN7BY6+UdKv55ifV5PHi2w4vH619o0bsV/B2soeujhfM49C9XLjqS?=
 =?us-ascii?Q?4zIODm+OD1LnuAOcIvcXwn1NlShoLjhlylWEqp5AL++AUwYXAKMVjQNpyTow?=
 =?us-ascii?Q?FkPtAcemjNN7zqBzXsQPLK8Q9MrgpLHh8LOn5Do89XTgloONnSGuegXfwnEK?=
 =?us-ascii?Q?dSmxIVJXHmRRX41FgWaxdteZA6/ifHQ0IJ+kAq8fypIraUADmTEDhWUqQqOv?=
 =?us-ascii?Q?KzZibLqJH3qhcDEwcBrubenb+wh9zJp2Q2jWvRyfHgBjY6djB7axeqTDbW6U?=
 =?us-ascii?Q?/ZIdXlcQrGr1bqyQfzUngfyLtG1/WreI8sNInETSQvCEOWy/n1gl3/xxQOSU?=
 =?us-ascii?Q?Tuk3II91LGlDiGVGAAGClA1qWfpke3qkYM+csjSrr6N6zcbKrVZz/eJRQZmJ?=
 =?us-ascii?Q?XN5jvxgQ3WDCNIMX32CZ8ygc+YQ6+tFqpRPqIGoziRQY4oEuK3mFZAaADntK?=
 =?us-ascii?Q?A/mScJeNSd4OybaJ/5S/V9LEQfXrNpRSnYCBzuyIIMx511DTw8wBz5UIPg40?=
 =?us-ascii?Q?WHFYW1FYtYc7Hc8ai2j93NvmPkGzPtzw2Y3KNFM+wiQbMNe0hB3LcCLGreHD?=
 =?us-ascii?Q?Ja5+i1sffs+SJw6U7f7q05WH4LWiGv5u860im1+2kxJQCF4pv5LnBE6e8dry?=
 =?us-ascii?Q?4oQBUkoC3HkOBzSOrisCulyIhdIn+nZiVIoI9RiKNFVMt0aRJ2T5G0ZEqQkr?=
 =?us-ascii?Q?JG3CdQDST2I9g+/nvzsd5MCUZpM1Ngixvl07kgefx55UrWLsdU1DSGNqgIDf?=
 =?us-ascii?Q?Zj4oCNtyGzoTZKxswocTP1LRaRHmkD+90/4SjEtmKnJ40fAw+Cy+TV6iry9W?=
 =?us-ascii?Q?Dktf7jqx/bRY/ln/ZllVeQbqRdrOeGUpRWVK+EYmj3v191tqB+Do87CZxO4o?=
 =?us-ascii?Q?4WMLSgso1SQeg5A6VNbfOOYAD4cuQxt6QBHMGcqYoRP0mqBl5E9Spb5RClth?=
 =?us-ascii?Q?OdnXXF0s3+VwjQqMexaVjHZqn+H5OCysKT8+eAqolVxF8DiFOyr0OK4XO0X4?=
 =?us-ascii?Q?q+nXPbERkSdsxyA1+a+QoQDMrtED5wyNzMVVquj5nos3HPedFxkSShgH6Prg?=
 =?us-ascii?Q?9OgHjHIlaeL1wksBLHUVIgjKvJ6XrjigCAFyWlEhZtV6okHzXYPsbX4sE4Pr?=
 =?us-ascii?Q?KyuwRSquF/pDOEy911p2uy+czo1ZIFw=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865ba5c1-bde0-4c1f-d1b5-08da2a300c82
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 22:31:48.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsM5S1msmqenFH/dD1j4lmtOhFyzPGcaGGU2LGeakhegzxTioGWD9YwDhTe8Rg2fy1P6AcqsmGSQdXqbgkvqAgekQgDz1ONf1h5uiFRL8M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8361
X-Proofpoint-GUID: WPiMEMZXxDEkUe9jlbFucPe3OztwhqE_
X-Proofpoint-ORIG-GUID: WPiMEMZXxDEkUe9jlbFucPe3OztwhqE_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_10,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=445
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Switch to using the NAPI poll handler to perform the TX completion work
to get this out of hard IRQ context and avoid the IRQ latency impact.

The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved
into the NAPI poll handler to maintain the proper order of operations. A
flag is used to notify the poll handler that a UBR condition needs to be
handled. The macb_tx_restart handler has had some locking added for global
register access, since this could now potentially happen concurrently on
different queues.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb.h      |   1 +
 drivers/net/ethernet/cadence/macb_main.c | 138 +++++++++++++----------
 2 files changed, 80 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index f0a7d8396a4a..5355cef95a9b 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1209,6 +1209,7 @@ struct macb_queue {
 	struct macb_tx_skb	*tx_skb;
 	dma_addr_t		tx_ring_dma;
 	struct work_struct	tx_error_task;
+	bool			txubr_pending;
 
 	dma_addr_t		rx_ring_dma;
 	dma_addr_t		rx_buffers_dma;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 160dc5ad84ae..1cb8afb8ef0d 100644
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
+	/* Prevent the queue NAPI poll from running, as it calls
+	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
 	 * As explained below, we have to halt the transmission before updating
 	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
 	 * network engine about the macb/gem being halted.
 	 */
+	napi_disable(&queue->napi);
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
@@ -1118,25 +1119,28 @@ static void macb_tx_error_task(struct work_struct *work)
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 
 	spin_unlock_irqrestore(&bp->lock, flags);
+	napi_enable(&queue->napi);
 }
 
-static void macb_tx_interrupt(struct macb_queue *queue)
+static bool macb_tx_complete_pending(struct macb_queue *queue)
+{
+	if (queue->tx_head != queue->tx_tail) {
+		/* Make hw descriptor updates visible to CPU */
+		rmb();
+
+		if (macb_tx_desc(queue, queue->tx_tail)->ctrl & MACB_BIT(TX_USED))
+			return true;
+	}
+	return false;
+}
+
+static void macb_tx_complete(struct macb_queue *queue, int budget)
 {
 	unsigned int tail;
 	unsigned int head;
-	u32 status;
 	struct macb *bp = queue->bp;
 	u16 queue_index = queue - bp->queues;
 
-	status = macb_readl(bp, TSR);
-	macb_writel(bp, TSR, status);
-
-	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-		queue_writel(queue, ISR, MACB_BIT(TCOMP));
-
-	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
-		    (unsigned long)status);
-
 	head = queue->tx_head;
 	for (tail = queue->tx_tail; tail != head; tail++) {
 		struct macb_tx_skb	*tx_skb;
@@ -1182,7 +1186,7 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 			}
 
 			/* Now we can safely release resources */
-			macb_tx_unmap(bp, tx_skb);
+			macb_tx_unmap(bp, tx_skb, budget);
 
 			/* skb is set only for the last buffer of the frame.
 			 * WARNING: at this point skb has been freed by
@@ -1569,23 +1573,55 @@ static bool macb_rx_pending(struct macb_queue *queue)
 	return (desc->addr & MACB_BIT(RX_USED)) != 0;
 }
 
+static void macb_tx_restart(struct macb_queue *queue)
+{
+	unsigned int head = queue->tx_head;
+	unsigned int tail = queue->tx_tail;
+	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
+
+	if (head == tail)
+		return;
+
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
+	spin_lock_irq(&bp->lock);
+	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+	spin_unlock_irq(&bp->lock);
+}
+
 static int macb_poll(struct napi_struct *napi, int budget)
 {
 	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
 	struct macb *bp = queue->bp;
 	int work_done;
 
+	macb_tx_complete(queue, budget);
+
+	rmb(); // ensure txubr_pending is up to date
+	if (queue->txubr_pending) {
+		queue->txubr_pending = false;
+		netdev_vdbg(bp->dev, "poll: tx restart\n");
+		macb_tx_restart(queue);
+	}
+
 	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
 
 	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
 		    (unsigned int)(queue - bp->queues), work_done, budget);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		queue_writel(queue, IER, bp->rx_intr_mask);
+		queue_writel(queue, IER, bp->rx_intr_mask |
+					 MACB_BIT(TCOMP));
 
 		/* Packet completions only seem to propagate to raise
 		 * interrupts when interrupts are enabled at the time, so if
-		 * packets were received while interrupts were disabled,
+		 * packets were sent/received while interrupts were disabled,
 		 * they will not cause another interrupt to be generated when
 		 * interrupts are re-enabled.
 		 * Check for this case here to avoid losing a wakeup. This can
@@ -1593,10 +1629,13 @@ static int macb_poll(struct napi_struct *napi, int budget)
 		 * actions if an interrupt is raised just after enabling them,
 		 * but this should be harmless.
 		 */
-		if (macb_rx_pending(queue)) {
-			queue_writel(queue, IDR, bp->rx_intr_mask);
+		if (macb_rx_pending(queue) ||
+		    macb_tx_complete_pending(queue)) {
+			queue_writel(queue, IDR, bp->rx_intr_mask |
+						 MACB_BIT(TCOMP));
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-				queue_writel(queue, ISR, MACB_BIT(RCOMP));
+				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
+							 MACB_BIT(TCOMP));
 			netdev_vdbg(bp->dev, "poll: packets pending, reschedule\n");
 			napi_schedule(napi);
 		}
@@ -1646,29 +1685,6 @@ static void macb_hresp_error_task(struct tasklet_struct *t)
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
@@ -1754,19 +1770,29 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 			    (unsigned int)(queue - bp->queues),
 			    (unsigned long)status);
 
-		if (status & bp->rx_intr_mask) {
-			/* There's no point taking any more interrupts
-			 * until we have processed the buffers. The
+		if (status & (bp->rx_intr_mask |
+			      MACB_BIT(TCOMP) |
+			      MACB_BIT(TXUBR))) {
+			/* There's no point taking any more RX/TX completion
+			 * interrupts until we have processed the buffers. The
 			 * scheduling call may fail if the poll routine
 			 * is already scheduled, so disable interrupts
 			 * now.
 			 */
-			queue_writel(queue, IDR, bp->rx_intr_mask);
+			queue_writel(queue, IDR, bp->rx_intr_mask |
+						 MACB_BIT(TCOMP));
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-				queue_writel(queue, ISR, MACB_BIT(RCOMP));
+				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
+							 MACB_BIT(TCOMP) |
+							 MACB_BIT(TXUBR));
+
+			if (status & MACB_BIT(TXUBR)) {
+				queue->txubr_pending = true;
+				wmb(); // ensure softirq can see update
+			}
 
 			if (napi_schedule_prep(&queue->napi)) {
-				netdev_vdbg(bp->dev, "scheduling RX softirq\n");
+				netdev_vdbg(bp->dev, "scheduling NAPI softirq\n");
 				__napi_schedule(&queue->napi);
 			}
 		}
@@ -1781,12 +1807,6 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
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
@@ -2019,7 +2039,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 	for (i = queue->tx_head; i != tx_head; i++) {
 		tx_skb = macb_tx_skb(queue, i);
 
-		macb_tx_unmap(bp, tx_skb);
+		macb_tx_unmap(bp, tx_skb, 0);
 	}
 
 	return 0;
-- 
2.31.1

