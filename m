Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0362CFE34
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgLETU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:59 -0500
Received: from mail-am6eur05on2134.outbound.protection.outlook.com ([40.107.22.134]:19809
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727459AbgLETUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPPvydt6oqU6Bk4Y8akwtICqYGQgoAhrxMC6bBwsMkiMlpPl1s549Vl8GT2SDTFms9f7C0kk4kqzp9GBaawcEibIYWmc3MsXeTc15tt4qWyDcvj9Q2cHisjpgnden7bqorFCqsopH2jBYCdYIhDs65zKY4lCzwZoAql7kBV0wCCNvihgvPksBWFVT+P9m9qFuIlsfTmsNN021G0TgAFdi5ySE/6ZRN5zf9Oktq15WkeqFAgob3y2G8t5jW2nXm4+VGT9v98z5sQ8hlcDcjNJtExGDAeyiE0vgXrp5uqYxVvXOvUHzTiWKFa7l0pzbeQsawzGVU+2waCl5Y6tndmTVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID8pKmvEHso/KX3ER46Yz24FsRfomcqLd/RbPmPbSeo=;
 b=DdNCu/vF5Ifo/YM1tJ0qI9p9uyHJp3AlLG4yF9llziOClgBMJp3VXf0vjreHEvsheNWOzgcCX6kx54l8HGqihQXKXxedaudcoN8YwyGtGOvBq7Sm7ZiRP/Dx+OUJukPt47PYpYpHwbNojfSv42CQPELdpYgLrf7IEm8P9Dd6FKeN2cmpeyTlR1JYNzLH2BcWJpRddoXE6Cs5IbfQf7FutY+1sxK1JMMIOe4bDCqjK10zJGYd8+85s2ubr3DVpINP2i7WzbtePqPUe+4vI1lTdnPel2MpUaGXcvPrk2K7EIPRM4ynju3Y51A21FbWPkPhnYjvinbz1wNs/3+V865HuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID8pKmvEHso/KX3ER46Yz24FsRfomcqLd/RbPmPbSeo=;
 b=Gl4CpnYxgPh+GcE4GdK5vH2pMtjolDZikS/1GFtK4RXqq6aeetpkH8n+BiDcNuj4FFFtvTt7yRfHWggmX54x0fA0pqrnAryHgvOvONaHtpY8PSj/etrS0mwD5yEORx+bUJ/xHLp+rn+tkTAHysKLtipW6QD8gbYvh+QB/ORyT5U=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:33 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:33 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] ethernet: ucc_geth: inform the compiler that numQueues is always 1
Date:   Sat,  5 Dec 2020 20:17:42 +0100
Message-Id: <20201205191744.7847-20-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b71f8df4-0150-43fd-2a29-08d899528eb9
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363AD93B08760DA4E9CBC1893F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPfw0UduCwAbCzL9RZ3af525rOyOQnCZD9h3kjZqAsdBJBidRb3Poat5HX98C6YXmVRvcDqCQcY8eVE28dWTNvlVgdJBx/bdF/gdVz9JFnzgjsftoQ+LQkqpnRbUMiv0sYKKJN6irXgnwR2kzBkgnUdt2j7tuwz//HHpM6HU6NOidT7uXV/05Ucqt8taUwCeWDtqb5AfbHO06SbDDQHxuyY3l2FiOG8Q6bkpEWl3kbuThQ0ibI6hXzFTaN1usEHA/miJCZA9pHYZKfyViS8aYAlSKZTR9j3PjyAaRwPtdMkr8dtmUN9iEOYZnMLblyWPIPusXm7dO+IaPOccetXBhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(19627235002)(4326008)(8976002)(5660300002)(1076003)(30864003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o0ficTIUPQX3ctAGSBwWt/XE35tFx7ptwdEl3TcSuk9WPe8gwQ4BNy0rg/VG?=
 =?us-ascii?Q?J9qhnnpIKPKGZg6k4qMJ3xKT1ZqZUDuq3mFWszzi7Jra3uJxi1aIxB2ea0ab?=
 =?us-ascii?Q?MHSD2uZd561vZd2ZENhswHgFtx/REAIojSiu+vOqGzujc+3mitsgceEBVwp4?=
 =?us-ascii?Q?th12aWvnh4AuZj4u9jd+H3ekJ8tomNh/nj274GYSgV1qPH2O5ru4chm3uUwn?=
 =?us-ascii?Q?0Wgea12LBO6lRaWJfE7mu2VtcLoNZgakJbUD+rtmXMuI6DqMD8UaCjCiEhY/?=
 =?us-ascii?Q?XwXOySHkisULnLNdAJMeo0aaoylM8mxfRX+YJJoTNKMn9TLePhU6nbibq7tz?=
 =?us-ascii?Q?079LKEg9FEbu+Xnbxt+KRJ+0ac3bcVV+jqSXfhDz+g6yuila79A1UHCa/O/O?=
 =?us-ascii?Q?b3YTV6YMag/iPdhZXoBSEnsbcQ2pyiJ6HVJCx5qQ0nPrUHGry0Mg4ewnfius?=
 =?us-ascii?Q?cssXzXx9Yski7/qZGpFCWAil6uOT7l8jUwlm5f8zSQjINqKDAl7H4RJdWyyv?=
 =?us-ascii?Q?lwAjtidDvcw6A7qVOWF46t/iL/gb1UsEQ6bmpt7Bz/JLB/OZuUF1nQ9U1TER?=
 =?us-ascii?Q?TKHEV7ssQOySe0vUOFwboHYz1n0QUTz1X+AZz5Lcp+mEKEhBMPCSvEOYVJ5a?=
 =?us-ascii?Q?ptId/t+jqgIO4+RAeCmP7gPJ3bwOXevSH7kPEhb5RG2Hqnc3YSh6KLLy7f5W?=
 =?us-ascii?Q?+6UtGmRA9GlYvCMNJ/S1Z/KQjXQirqGazUMmn+CqY1COub51tkGk884lGq13?=
 =?us-ascii?Q?LMa0yOGDGgNk8j/bRaJb8tzkg8jKN4taDwch1cwaa/ytmU+5iO0/cmC6wknt?=
 =?us-ascii?Q?y3C53kkwJ+4tLt5YullH8C5leeFE21lyMvX1fMbbQXCZRzI8MENqL0RsK1Nu?=
 =?us-ascii?Q?0gvv0TuNskkjlFAENkCYZMGymwJj+z5gcxxidLdiu6gUCu4Q8WPxCq1Pv+p0?=
 =?us-ascii?Q?JfHgJms9DO/kgQDIkC+DO+LBDCEWxHBLwFj52J8Z5iDd1a4yhEqNVnKmhESC?=
 =?us-ascii?Q?xqLY?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b71f8df4-0150-43fd-2a29-08d899528eb9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:33.5152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1eEWfeJ9FbGswdLcql50q19m/KGP6Uq17+VQAWK/uL3Z9gPHDWWoBn4MbdOirZMLq9UmydWGGQ1ad7YiVD0ssEnFHp/8Wn6tPIEsxA/aI2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
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
index a26d1feb7dab..3cad2255bd97 100644
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

