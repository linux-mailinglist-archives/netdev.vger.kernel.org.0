Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5C2FBAEC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390977AbhASPSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:18:07 -0500
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:58206
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391095AbhASPMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:12:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MG6OqGJwPZKjv71d9GifAv7ddQ4QHhG1CvcA1wgva100u7Vskl27x8tE48rTqRlbXTzPtn+T1QYGTlD0hgKhSnOGVP0ozNph6N8Qg6IpWYgApu8EmbAB1idtx6tWbamVuaPSx+vQLUOskuGaP8WUMTbFpJfMx3k2/efymNgcLUn+ovtkMGoxWIZq6H6Q2hv2yU2JQieLOGn7dqpwczQ20cV0KA4fdGTCdzIrR70YbmofThAgDCR+SqFaNba4i6wAaoSCsAwR8+IG69v+tfbetHVB+xWIrRekZHsoXt8nx700ooEeS2x5+g7tRckHwDsVFaU+XtagaqIb6F2Lcdp/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kg5ZponnjqRkw9H8N5NCmPdzdftMGmXJ7q7nJcOMQ8=;
 b=QG8s4nQySdg7XBIFmk0dm3uhKO2jJlueg3gEK0qzDk/V1TlbfKRufeLch9s/tEOqrbiHjaeQP2FcfCq8GU10DfUF9D7IFKWmQnlZGu2cMnWn1VsYLZrCsBr1s7nbHeNdAfHYMwxkOO1E7LE9miDIHJKub3P6ko6TWzBmjBJup7Otya2vfFPUi/Rtr5bPFRwm+rPCmkOnHLK9ZkvqP5PSiqcKUsMFfX4EZ1FQtqbeZpaIYfJXvzrhPjQmjT/y98l7jVOWZ9kHPhshMfH7QW0M8ZMudyQoJPY5RU3bLRA3ylaOrX+TJwWGiDFB8uYz2pEMEjAO1+iMxbFXW5llJ7oC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kg5ZponnjqRkw9H8N5NCmPdzdftMGmXJ7q7nJcOMQ8=;
 b=D8CmEmMcyAU9L6mqcXc/c3sPanbQ8jy5ec2aaeGjP+qPZgORU9e4ZriLha4OyQb+0XOyAGtJqgDmWdYmPfT7wnD/cz7if2SAdTJnZsxZl9QwaNirix/rXamE/Ii4NN5WY4bVbtxMt3JB9KGRQSSzgpp6W5CwwU9PfwlNxWuk52g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:24 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:21 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 16/17] ethernet: ucc_geth: inform the compiler that numQueues is always 1
Date:   Tue, 19 Jan 2021 16:08:01 +0100
Message-Id: <20210119150802.19997-17-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d8a470b-65c6-427c-2035-08d8bc8c3254
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB19226C6537FAE026BE96C4AB93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swJv62EsVCQ1jv24JKhUt3DLrPhz4r5vRW1/pfjoqIWoL2psJB9CAVN/yXe/kzFR5N/zo3q6/g/1n/7tU+No6EaRuiPg+pSniAZ7EjL0djV1jT8dyhirqHfE5nlBqFaP6UsRzlpIJCjwqXduZQxRSwJM6E+RQnuft3bxgY8oTFGz36QMz4MKwNSnebnXgvPhx3WRM9p3Sn3j2LnreKmzBP8PZeh1sB1fT/5KKPMAycwsQG1zgWUehGWtD1U3XEE6+GzMZ2/lQyPTTPeCb2Tx8+NlUOWO9t7nNJtIAja2UvNQ53KJbTeOdQVOIz7Gktn7aA7VR7BdYuZjc2BFSrf7Wn/caWrwzTK6L+xLVtQndTaEMgfZCWLxQL7Jhg6ewWRi1fB0ZqDjtVX1qNm2QNB9yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(30864003)(6486002)(5660300002)(478600001)(19627235002)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HrMjh+XM5asX+dMFnjksGgfq2CHwGsp0Uph4vfv1ZBUvPj9LfuAQUoYjydZ8?=
 =?us-ascii?Q?qEMFdt1JoFOCThG7kCGzghU4wo5JtLHQW/lvXpWr9wUksQ+8oarcTjZpwiz5?=
 =?us-ascii?Q?ZxKREdiWjC3Gwxed7fZyWSGiFvCw+PtLTtZa2+D7lYQEIfYAvKtxpJG+gy96?=
 =?us-ascii?Q?Pci+JFWfWfGjlrsKxfLdjunaAO36IPaHKMAZUW/MxcTlyCMQUgMInEegvG9g?=
 =?us-ascii?Q?muz4L0vjh2U1VR1nk6dQUru5YgdGm3twzGcgo2ItCyV235w/CjeuHgigGN1e?=
 =?us-ascii?Q?x2AMwJI2f5ljE3udPHRXUSiqOkpMBUhdA7j+YlXQLLy41TntU4jg7HAmPtY8?=
 =?us-ascii?Q?0KyzciYOV7T3pgPkRmv+FXUOHxUKMlzhb80EM7AIygN/tmfrPbs0SHwC5K4+?=
 =?us-ascii?Q?0wd0/0+3rhCVYCbo+PEjdt7hJG+NPcsgzaJH4BK3Y9YA9EvbdxNsnZePQwAW?=
 =?us-ascii?Q?sbGJkZZpP4j2FYhmox5Ts8b+8IQ7o5CsIZvaLYJZXhdN2KUhgvCRyRnlV7IK?=
 =?us-ascii?Q?NLGtPkIr/LuVRt93To7Eo5NZh4zTUdXoHQDmbcvsDbWoENhMX+h4cL15LORD?=
 =?us-ascii?Q?BTmf+afc11erYakqeWYBg6UzT/Pbr1T9ZPLxnx2RYK0n34RBwR+3kkrHwV2Y?=
 =?us-ascii?Q?bxVXW5CqRmNoQN1hVA4ytzrAqZevDdoKrmSbcfRCMonhUSEe34kCd6OYa4kC?=
 =?us-ascii?Q?0KcMYeJzXIANKT+17BngmVOpWP2TwSHtyWyh1DNkrcVcsjXYR5d4UntrYuUH?=
 =?us-ascii?Q?2nI+zpISWCt+nEZblHaBO0mYwSiw1W3DBlyyUgyOkIlo66pY7549v/Ivsuo8?=
 =?us-ascii?Q?2pfYvZx8BR0wna9nL6zfbyaSLQJOeE6xueE+bisMOuJ10jFfxLlC9fGjZ2gJ?=
 =?us-ascii?Q?2j7eJ3iwlXlZFzpDw5RJ+Qr8kFHQ7f1SFg7Aaqf5W2NJuX8NVVQox3gGZvCn?=
 =?us-ascii?Q?Cy5fDac2R6r6EMvZNv6hJaZyIaVnaCv6FOKDJQHaLmAi8+ilArgaxMPM8IZe?=
 =?us-ascii?Q?Q9Y7?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8a470b-65c6-427c-2035-08d8bc8c3254
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:20.8656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPP14OM1fCz/CvRd/UBzWaU6FIZEBChXEcfKfoehcOoA8gA96dvNdWpTFuJOmexKeTLsb9TnkBy6cXByfOdOWit9uv7EqRNkIkIUr+Z8d7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The numQueuesTx and numQueuesRx members of struct ucc_geth_info are
never set to anything but 1, and never have been. It's unclear how
well the code supporting multiple queues would work. Until somebody
wants to play with enabling that, help the compiler eliminate a lot of
dead code and loops that are not really loops by creating static
inline helpers. If and when the numQueuesTx/numQueuesRx fields are
re-introduced, it suffices to update those helper to return the
appropriate field.

This cuts the .text segment of ucc_geth.o by 8%.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 76 +++++++++++++----------
 drivers/net/ethernet/freescale/ucc_geth.h |  2 -
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 960b19fc4fb8..9be1d4455a6b 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -84,6 +84,16 @@ static int ucc_geth_thread_count(enum ucc_geth_num_of_threads idx)
 	return count[idx];
 }
 
+static inline int ucc_geth_tx_queues(const struct ucc_geth_info *info)
+{
+	return 1;
+}
+
+static inline int ucc_geth_rx_queues(const struct ucc_geth_info *info)
+{
+	return 1;
+}
+
 static const struct ucc_geth_info ugeth_primary_info = {
 	.uf_info = {
 		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
@@ -103,8 +113,6 @@ static const struct ucc_geth_info ugeth_primary_info = {
 		    .tcrc = UCC_FAST_16_BIT_CRC,
 		    .synl = UCC_FAST_SYNC_LEN_NOT_USED,
 		    },
-	.numQueuesTx = 1,
-	.numQueuesRx = 1,
 	.extendedFilteringChainPointer = ((uint32_t) NULL),
 	.typeorlen = 3072 /*1536 */ ,
 	.nonBackToBackIfgPart1 = 0x40,
@@ -569,7 +577,7 @@ static void dump_bds(struct ucc_geth_private *ugeth)
 	int i;
 	int length;
 
-	for (i = 0; i < ugeth->ug_info->numQueuesTx; i++) {
+	for (i = 0; i < ucc_geth_tx_queues(ugeth->ug_info); i++) {
 		if (ugeth->p_tx_bd_ring[i]) {
 			length =
 			    (ugeth->ug_info->bdRingLenTx[i] *
@@ -578,7 +586,7 @@ static void dump_bds(struct ucc_geth_private *ugeth)
 			mem_disp(ugeth->p_tx_bd_ring[i], length);
 		}
 	}
-	for (i = 0; i < ugeth->ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ugeth->ug_info); i++) {
 		if (ugeth->p_rx_bd_ring[i]) {
 			length =
 			    (ugeth->ug_info->bdRingLenRx[i] *
@@ -876,7 +884,7 @@ static void dump_regs(struct ucc_geth_private *ugeth)
 	if (ugeth->p_send_q_mem_reg) {
 		pr_info("Send Q memory registers:\n");
 		pr_info("Base address: 0x%08x\n", (u32)ugeth->p_send_q_mem_reg);
-		for (i = 0; i < ugeth->ug_info->numQueuesTx; i++) {
+		for (i = 0; i < ucc_geth_tx_queues(ugeth->ug_info); i++) {
 			pr_info("SQQD[%d]:\n", i);
 			pr_info("Base address: 0x%08x\n",
 				(u32)&ugeth->p_send_q_mem_reg->sqqd[i]);
@@ -908,7 +916,7 @@ static void dump_regs(struct ucc_geth_private *ugeth)
 		pr_info("RX IRQ coalescing tables:\n");
 		pr_info("Base address: 0x%08x\n",
 			(u32)ugeth->p_rx_irq_coalescing_tbl);
-		for (i = 0; i < ugeth->ug_info->numQueuesRx; i++) {
+		for (i = 0; i < ucc_geth_rx_queues(ugeth->ug_info); i++) {
 			pr_info("RX IRQ coalescing table entry[%d]:\n", i);
 			pr_info("Base address: 0x%08x\n",
 				(u32)&ugeth->p_rx_irq_coalescing_tbl->
@@ -930,7 +938,7 @@ static void dump_regs(struct ucc_geth_private *ugeth)
 	if (ugeth->p_rx_bd_qs_tbl) {
 		pr_info("RX BD QS tables:\n");
 		pr_info("Base address: 0x%08x\n", (u32)ugeth->p_rx_bd_qs_tbl);
-		for (i = 0; i < ugeth->ug_info->numQueuesRx; i++) {
+		for (i = 0; i < ucc_geth_rx_queues(ugeth->ug_info); i++) {
 			pr_info("RX BD QS table[%d]:\n", i);
 			pr_info("Base address: 0x%08x\n",
 				(u32)&ugeth->p_rx_bd_qs_tbl[i]);
@@ -1806,7 +1814,7 @@ static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
 	ug_info = ugeth->ug_info;
 	uf_info = &ug_info->uf_info;
 
-	for (i = 0; i < ugeth->ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ugeth->ug_info); i++) {
 		if (ugeth->p_rx_bd_ring[i]) {
 			/* Return existing data buffers in ring */
 			bd = ugeth->p_rx_bd_ring[i];
@@ -1846,7 +1854,7 @@ static void ucc_geth_free_tx(struct ucc_geth_private *ugeth)
 	ug_info = ugeth->ug_info;
 	uf_info = &ug_info->uf_info;
 
-	for (i = 0; i < ugeth->ug_info->numQueuesTx; i++) {
+	for (i = 0; i < ucc_geth_tx_queues(ugeth->ug_info); i++) {
 		bd = ugeth->p_tx_bd_ring[i];
 		if (!bd)
 			continue;
@@ -2024,7 +2032,7 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 	uf_info = &ug_info->uf_info;
 
 	/* Rx BD lengths */
-	for (i = 0; i < ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++) {
 		if ((ug_info->bdRingLenRx[i] < UCC_GETH_RX_BD_RING_SIZE_MIN) ||
 		    (ug_info->bdRingLenRx[i] %
 		     UCC_GETH_RX_BD_RING_SIZE_ALIGNMENT)) {
@@ -2035,7 +2043,7 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 	}
 
 	/* Tx BD lengths */
-	for (i = 0; i < ug_info->numQueuesTx; i++) {
+	for (i = 0; i < ucc_geth_tx_queues(ug_info); i++) {
 		if (ug_info->bdRingLenTx[i] < UCC_GETH_TX_BD_RING_SIZE_MIN) {
 			if (netif_msg_probe(ugeth))
 				pr_err("Tx BD ring length must be no smaller than 2\n");
@@ -2052,14 +2060,14 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 	}
 
 	/* num Tx queues */
-	if (ug_info->numQueuesTx > NUM_TX_QUEUES) {
+	if (ucc_geth_tx_queues(ug_info) > NUM_TX_QUEUES) {
 		if (netif_msg_probe(ugeth))
 			pr_err("number of tx queues too large\n");
 		return -EINVAL;
 	}
 
 	/* num Rx queues */
-	if (ug_info->numQueuesRx > NUM_RX_QUEUES) {
+	if (ucc_geth_rx_queues(ug_info) > NUM_RX_QUEUES) {
 		if (netif_msg_probe(ugeth))
 			pr_err("number of rx queues too large\n");
 		return -EINVAL;
@@ -2067,7 +2075,7 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 
 	/* l2qt */
 	for (i = 0; i < UCC_GETH_VLAN_PRIORITY_MAX; i++) {
-		if (ug_info->l2qt[i] >= ug_info->numQueuesRx) {
+		if (ug_info->l2qt[i] >= ucc_geth_rx_queues(ug_info)) {
 			if (netif_msg_probe(ugeth))
 				pr_err("VLAN priority table entry must not be larger than number of Rx queues\n");
 			return -EINVAL;
@@ -2076,7 +2084,7 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 
 	/* l3qt */
 	for (i = 0; i < UCC_GETH_IP_PRIORITY_MAX; i++) {
-		if (ug_info->l3qt[i] >= ug_info->numQueuesRx) {
+		if (ug_info->l3qt[i] >= ucc_geth_rx_queues(ug_info)) {
 			if (netif_msg_probe(ugeth))
 				pr_err("IP priority table entry must not be larger than number of Rx queues\n");
 			return -EINVAL;
@@ -2099,10 +2107,10 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 
 	/* Generate uccm_mask for receive */
 	uf_info->uccm_mask = ug_info->eventRegMask & UCCE_OTHER;/* Errors */
-	for (i = 0; i < ug_info->numQueuesRx; i++)
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++)
 		uf_info->uccm_mask |= (UCC_GETH_UCCE_RXF0 << i);
 
-	for (i = 0; i < ug_info->numQueuesTx; i++)
+	for (i = 0; i < ucc_geth_tx_queues(ug_info); i++)
 		uf_info->uccm_mask |= (UCC_GETH_UCCE_TXB0 << i);
 	/* Initialize the general fast UCC block. */
 	if (ucc_fast_init(uf_info, &ugeth->uccf)) {
@@ -2141,7 +2149,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 	uf_info = &ug_info->uf_info;
 
 	/* Allocate Tx bds */
-	for (j = 0; j < ug_info->numQueuesTx; j++) {
+	for (j = 0; j < ucc_geth_tx_queues(ug_info); j++) {
 		u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
 
 		/* Allocate in multiple of
@@ -2174,7 +2182,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 	}
 
 	/* Init Tx bds */
-	for (j = 0; j < ug_info->numQueuesTx; j++) {
+	for (j = 0; j < ucc_geth_tx_queues(ug_info); j++) {
 		/* Setup the skbuff rings */
 		ugeth->tx_skbuff[j] =
 			kcalloc(ugeth->ug_info->bdRingLenTx[j],
@@ -2215,7 +2223,7 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	uf_info = &ug_info->uf_info;
 
 	/* Allocate Rx bds */
-	for (j = 0; j < ug_info->numQueuesRx; j++) {
+	for (j = 0; j < ucc_geth_rx_queues(ug_info); j++) {
 		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
 
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
@@ -2234,7 +2242,7 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	}
 
 	/* Init Rx bds */
-	for (j = 0; j < ug_info->numQueuesRx; j++) {
+	for (j = 0; j < ucc_geth_rx_queues(ug_info); j++) {
 		/* Setup the skbuff rings */
 		ugeth->rx_skbuff[j] =
 			kcalloc(ugeth->ug_info->bdRingLenRx[j],
@@ -2437,7 +2445,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	/* SQPTR */
 	/* Size varies with number of Tx queues */
 	ugeth->send_q_mem_reg_offset =
-	    qe_muram_alloc(ug_info->numQueuesTx *
+	    qe_muram_alloc(ucc_geth_tx_queues(ug_info) *
 			   sizeof(struct ucc_geth_send_queue_qd),
 			   UCC_GETH_SEND_QUEUE_QUEUE_DESCRIPTOR_ALIGNMENT);
 	if (IS_ERR_VALUE(ugeth->send_q_mem_reg_offset)) {
@@ -2453,7 +2461,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* Setup the table */
 	/* Assume BD rings are already established */
-	for (i = 0; i < ug_info->numQueuesTx; i++) {
+	for (i = 0; i < ucc_geth_tx_queues(ug_info); i++) {
 		endOfRing =
 		    ugeth->p_tx_bd_ring[i] + (ug_info->bdRingLenTx[i] -
 					      1) * sizeof(struct qe_bd);
@@ -2466,7 +2474,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* schedulerbasepointer */
 
-	if (ug_info->numQueuesTx > 1) {
+	if (ucc_geth_tx_queues(ug_info) > 1) {
 	/* scheduler exists only if more than 1 tx queue */
 		ugeth->scheduler_offset =
 		    qe_muram_alloc(sizeof(struct ucc_geth_scheduler),
@@ -2529,11 +2537,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	/* temoder */
 	/* Already has speed set */
 
-	if (ug_info->numQueuesTx > 1)
+	if (ucc_geth_tx_queues(ug_info) > 1)
 		temoder |= TEMODER_SCHEDULER_ENABLE;
 	if (ug_info->ipCheckSumGenerate)
 		temoder |= TEMODER_IP_CHECKSUM_GENERATE;
-	temoder |= ((ug_info->numQueuesTx - 1) << TEMODER_NUM_OF_QUEUES_SHIFT);
+	temoder |= ((ucc_geth_tx_queues(ug_info) - 1) << TEMODER_NUM_OF_QUEUES_SHIFT);
 	out_be16(&ugeth->p_tx_glbl_pram->temoder, temoder);
 
 	/* Function code register value to be used later */
@@ -2597,7 +2605,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* Size varies with number of Rx queues */
 	ugeth->rx_irq_coalescing_tbl_offset =
-	    qe_muram_alloc(ug_info->numQueuesRx *
+	    qe_muram_alloc(ucc_geth_rx_queues(ug_info) *
 			   sizeof(struct ucc_geth_rx_interrupt_coalescing_entry)
 			   + 4, UCC_GETH_RX_INTERRUPT_COALESCING_ALIGNMENT);
 	if (IS_ERR_VALUE(ugeth->rx_irq_coalescing_tbl_offset)) {
@@ -2613,7 +2621,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		 ugeth->rx_irq_coalescing_tbl_offset);
 
 	/* Fill interrupt coalescing table */
-	for (i = 0; i < ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++) {
 		out_be32(&ugeth->p_rx_irq_coalescing_tbl->coalescingentry[i].
 			 interruptcoalescingmaxvalue,
 			 ug_info->interruptcoalescingmaxvalue[i]);
@@ -2662,7 +2670,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	/* RBDQPTR */
 	/* Size varies with number of Rx queues */
 	ugeth->rx_bd_qs_tbl_offset =
-	    qe_muram_alloc(ug_info->numQueuesRx *
+	    qe_muram_alloc(ucc_geth_rx_queues(ug_info) *
 			   (sizeof(struct ucc_geth_rx_bd_queues_entry) +
 			    sizeof(struct ucc_geth_rx_prefetched_bds)),
 			   UCC_GETH_RX_BD_QUEUES_ALIGNMENT);
@@ -2679,7 +2687,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* Setup the table */
 	/* Assume BD rings are already established */
-	for (i = 0; i < ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++) {
 		out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
 			 (u32) virt_to_phys(ugeth->p_rx_bd_ring[i]));
 		/* rest of fields handled by QE */
@@ -2702,7 +2710,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	    ug_info->
 	    vlanOperationNonTagged << REMODER_VLAN_OPERATION_NON_TAGGED_SHIFT;
 	remoder |= ug_info->rxQoSMode << REMODER_RX_QOS_MODE_SHIFT;
-	remoder |= ((ug_info->numQueuesRx - 1) << REMODER_NUM_OF_QUEUES_SHIFT);
+	remoder |= ((ucc_geth_rx_queues(ug_info) - 1) << REMODER_NUM_OF_QUEUES_SHIFT);
 	if (ug_info->ipCheckSumCheck)
 		remoder |= REMODER_IP_CHECKSUM_CHECK;
 	if (ug_info->ipAddressAlignment)
@@ -2861,7 +2869,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	}
 
 	/* Load Rx bds with buffers */
-	for (i = 0; i < ug_info->numQueuesRx; i++) {
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++) {
 		if ((ret_val = rx_bd_buffer_set(ugeth, (u8) i)) != 0) {
 			if (netif_msg_ifup(ugeth))
 				pr_err("Can not fill Rx bds with buffers\n");
@@ -3132,12 +3140,12 @@ static int ucc_geth_poll(struct napi_struct *napi, int budget)
 
 	/* Tx event processing */
 	spin_lock(&ugeth->lock);
-	for (i = 0; i < ug_info->numQueuesTx; i++)
+	for (i = 0; i < ucc_geth_tx_queues(ug_info); i++)
 		ucc_geth_tx(ugeth->ndev, i);
 	spin_unlock(&ugeth->lock);
 
 	howmany = 0;
-	for (i = 0; i < ug_info->numQueuesRx; i++)
+	for (i = 0; i < ucc_geth_rx_queues(ug_info); i++)
 		howmany += ucc_geth_rx(ugeth, i, budget - howmany);
 
 	if (howmany < budget) {
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index be47fa8ced15..6539fed9cc22 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -1077,8 +1077,6 @@ struct ucc_geth_tad_params {
 /* GETH protocol initialization structure */
 struct ucc_geth_info {
 	struct ucc_fast_info uf_info;
-	u8 numQueuesTx;
-	u8 numQueuesRx;
 	int ipCheckSumCheck;
 	int ipCheckSumGenerate;
 	int rxExtendedFiltering;
-- 
2.23.0

