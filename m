Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5125D2FBAEB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389891AbhASPRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:17:50 -0500
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:42328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391122AbhASPMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:12:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGPBFWRZm40OPU0ArKgn9WBzUz3j2fVdpLlWVTLgG/F7whgV3j9Ltk/l/rnldpDHSfxbOHcBLq9LF+0/Zpio438DxEufzUTxwoEpiiPH6bMeT9XQPJHal4RKWNd2OBo/MadtdopArX9XzZAOqfWJsnUEbvrZY0sLF4SXSaeYqMYTA00xWDG1suDewhaVW+AiyXXpZ9Tgp9GHr5afTwpWfrrIegCnTw3zDLzQfjgfqPHQPN0ewZLmvRoJiZBPSH/dXMl744s6cQA1tS4xk5nrCArgOkzMlp7vVilStC0eAlL432dQCA0sVlsUpd2zQKyjVHI2+uSg8SMKZzD/EojT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4pNhHaUZFfhMDCoQGHOvyvSQKykMlhyBjOkwek1q1k=;
 b=j0/g9cT1HUHtAym5sFWff8QzE0rfgIN2vX+GTH0glQZy6VJnIzOakBEzVd7LMVOLYmSNctMKceND+FheRJeo0ZE9J5sWnKTDIXuEqDjuvtcF1Ic976GGtsZGG+S2xkoVVbUqYjVbHjkk6U/HGFmewVZ2I7/d4Vg6l2bCKloJvZE+QmpGYBZI7DD0Di39yDx5a80lO9jMru9QOkfZXcnVeRRdn+66ySvRKZ+X2reTbfjS4bqsaQK9AGteVQm1p1xuffH6Xj7lAZvqG1b24QukG77He5shfhkNwLyVGfanoSv8f2moGrU+Fq2eaKpJLhmXjNgz2pCb6JdysvDphNVMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4pNhHaUZFfhMDCoQGHOvyvSQKykMlhyBjOkwek1q1k=;
 b=dMW8wbo2D2foXl6Bzj6vxZ5qmrWX5kH9ZYkdkTOyzG0GpQKnwmJR66Bfx7oM8dFPr+OsBJS4eQX6gUhP/glplq7hsh+zou8B1rFSwC+A72e1kHZG7NAZXpozwBq9oONkIhQ6fvR3PHLDqGVMkJWx20AfukC8yC0EUXNATaWM1FY=
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
 15:09:24 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 17/17] ethernet: ucc_geth: simplify rx/tx allocations
Date:   Tue, 19 Jan 2021 16:08:02 +0100
Message-Id: <20210119150802.19997-18-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 216ee5c0-22fe-45c6-2b22-08d8bc8c33ac
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB192209F2500C5F109C372AD093A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhRK28E8Ht2kXFegwJSp8Y/YUf6l4cEXxoWltF8+KAYr7qIvWXbOIz7TK6/U2mrBBj6DsVs8gD0mj4VfppMnO6pqCacN7hdnHneKwK+kPE9me/V8fve0/du12IE1tIlg9oHlnbzkPZK5TyIwKpEW05wkPo+P6wk+83L4KNxCkGjoM7D8voM5JtzoclfyukwjGLulyAaq6j2rTnc9+cAo4WcC92X0iBIL9KRdABr8U8MB6SBzSkGPRpPmdhcYScbnwO6q/ouRtlm4u3EyIWTPDbgcQ8Zi2X2sjlYNflbx005wXMnMzWB1bjGPFPXfcTYc7fXnfIB/XBDCk1+qliJeMXz2DNOCNbSogMGo22WTYmNlHC/N9ftxJEqPhREI/OW7BQF1RPdRoe1nMvtaX/6VEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jkmpiMXDY8871VHqOIC0Z+wOD7JDjUhAOF511yNo9wfP15oawUk1DGPFfqRv?=
 =?us-ascii?Q?NhkH9zBf44zZbeJMiAFyG7TOXlV28/tb8Wi4ImFripFai5mllUDZf1+w8bro?=
 =?us-ascii?Q?gvu3+8OxEG3vZmIKh6CVo3i69XXEiyJb+E8yfUa55LWtmF5RyznGwHmAy4KT?=
 =?us-ascii?Q?y061I2O3hHYWAZZ7s2qkbr81XdI11b2WDDTt/br2IUmj7X7buLTk/qsOIJDn?=
 =?us-ascii?Q?G0FPFtn+izGTsTiYlVJcU5JtCB7KWnyT0rzI+6IonVJnqzxPgNBF1fw9niD7?=
 =?us-ascii?Q?Tm+xmPDNbKWwa1Avp8+9d+f0/N3oPfZ+hUCA7A5+EEV6QKMa+2M3WiGbnbDZ?=
 =?us-ascii?Q?n9Wk4vFNijjCjGhvgXOah/AkIQbIq8YTEcXYTkXVyVWy/DdYpSmqQ15avVcw?=
 =?us-ascii?Q?RHYeNTDb4mdzr6tNiYBPv+r1Su4oAY061ISF8ym31QM75cTHoaC4LrVvE1FT?=
 =?us-ascii?Q?f638f8mexKjHMPmJuh1qhacIxneGn2PLYHAkZM0hT/icCyrlENM6VMvx0vWJ?=
 =?us-ascii?Q?JlYyU321VTE5cP+bwm3nR49Ok0DQZ+UtOGEnVPvGouz1qr08e3sLQApuPtBe?=
 =?us-ascii?Q?iS3yX7GeQwW+KPF/gY0yhqrJEV8JswSOTynOXl/AA8q54n1AZdfiCGgwh+Li?=
 =?us-ascii?Q?4mR2hm15z0YgtMm7yaS42HknAd98U5NEhXZAAbBG1I2aZMT3mU4nc3TrnBXU?=
 =?us-ascii?Q?hpUlMve7YJ+jiaHmd5Y38Wy24xelQIyRSkl7aAXxyT8Is1XlrG8evUyJg4zT?=
 =?us-ascii?Q?emFmqE097kEhu/CPit4j0+6sxY1QgNvPAkj5kq0mldWDgBkQq269z6sQYOnk?=
 =?us-ascii?Q?AjrCO+d0a86G/C5IJUbWQLGP19YKvy6RRajuoyz2iRIJZDV2tUP4w9WpG5zE?=
 =?us-ascii?Q?G80QhtAeafl3NT/04xIElRWPInFLV1UDL7HJkPl2wbj2oh0n4t5wOAjj6b4W?=
 =?us-ascii?Q?oYCkBWkfo0wQCHxW6LiaIh3LcibiUe0Eo3UAb6VIb7M8j1+oEKe2ooTVfdK1?=
 =?us-ascii?Q?AJf3?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 216ee5c0-22fe-45c6-2b22-08d8bc8c33ac
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:23.6421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYzoBD+gEIsEjT0DIpNv1ocBUTJKXP7JK/FAwscDXZig4d9lyAm3AKRhvBIXF/2fkqJMmodiccr8UR+6xCSG216nJRM7MOa7GKqPhhnpedk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kmalloc() is nowadays [1] guaranteed to return naturally
aligned (i.e., aligned to the size itself) memory for power-of-2
sizes, we don't need to over-allocate the align amount, compute an
aligned address within the allocation, and (for later freeing) also
storing the original pointer [2].

Instead, just round up the length we want to allocate to the alignment
requirements, then round that up to the next power of 2. In theory,
this could allocate up to about twice as much memory as we needed.  In
practice, (a) kmalloc() would in most cases anyway return a
power-of-2-sized allocation and (b) with the default values of the
bdRingLen[RT]x fields, the length is already itself a power of 2
greater than the alignment.

So we actually end up saving memory compared to the current
situtation (e.g. for tx, we currently allocate 128+32 bytes, which
kmalloc() likely rounds up to 192 or 256; with this patch, we just
allocate 128 bytes.) Also struct ucc_geth_private becomes a little
smaller.

[1] 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment for
kmalloc(power-of-two)")

[2] That storing was anyway done in a u32, which works on 32 bit
machines, but is not very elegant and certainly makes a reader of the
code pause for a while.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 50 ++++++++---------------
 drivers/net/ethernet/freescale/ucc_geth.h |  2 -
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 9be1d4455a6b..ef4e2febeb5b 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -1835,7 +1835,7 @@ static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
 
 			kfree(ugeth->rx_skbuff[i]);
 
-			kfree((void *)ugeth->rx_bd_ring_offset[i]);
+			kfree(ugeth->p_rx_bd_ring[i]);
 			ugeth->p_rx_bd_ring[i] = NULL;
 		}
 	}
@@ -1872,10 +1872,8 @@ static void ucc_geth_free_tx(struct ucc_geth_private *ugeth)
 
 		kfree(ugeth->tx_skbuff[i]);
 
-		if (ugeth->p_tx_bd_ring[i]) {
-			kfree((void *)ugeth->tx_bd_ring_offset[i]);
-			ugeth->p_tx_bd_ring[i] = NULL;
-		}
+		kfree(ugeth->p_tx_bd_ring[i]);
+		ugeth->p_tx_bd_ring[i] = NULL;
 	}
 
 }
@@ -2150,25 +2148,15 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 
 	/* Allocate Tx bds */
 	for (j = 0; j < ucc_geth_tx_queues(ug_info); j++) {
-		u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
-
-		/* Allocate in multiple of
-		   UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT,
-		   according to spec */
-		length = ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd))
-			  / UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
-		    * UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-		if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
-		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
-			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-
-		ugeth->tx_bd_ring_offset[j] =
-			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-
-		if (ugeth->tx_bd_ring_offset[j] != 0)
-			ugeth->p_tx_bd_ring[j] =
-				(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
-						align) & ~(align - 1));
+		u32 align = max(UCC_GETH_TX_BD_RING_ALIGNMENT,
+				UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT);
+		u32 alloc;
+
+		length = ug_info->bdRingLenTx[j] * sizeof(struct qe_bd);
+		alloc = round_up(length, align);
+		alloc = roundup_pow_of_two(alloc);
+
+		ugeth->p_tx_bd_ring[j] = kmalloc(alloc, GFP_KERNEL);
 
 		if (!ugeth->p_tx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
@@ -2176,9 +2164,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 		/* Zero unused end of bd ring, according to spec */
-		memset_io((void __iomem *)(ugeth->p_tx_bd_ring[j] +
-		       ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)), 0,
-		       length - ug_info->bdRingLenTx[j] * sizeof(struct qe_bd));
+		memset(ugeth->p_tx_bd_ring[j] + length, 0, alloc - length);
 	}
 
 	/* Init Tx bds */
@@ -2225,15 +2211,13 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	/* Allocate Rx bds */
 	for (j = 0; j < ucc_geth_rx_queues(ug_info); j++) {
 		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+		u32 alloc;
 
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
-		ugeth->rx_bd_ring_offset[j] =
-			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-		if (ugeth->rx_bd_ring_offset[j] != 0)
-			ugeth->p_rx_bd_ring[j] =
-				(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
-						align) & ~(align - 1));
+		alloc = round_up(length, align);
+		alloc = roundup_pow_of_two(alloc);
 
+		ugeth->p_rx_bd_ring[j] = kmalloc(alloc, GFP_KERNEL);
 		if (!ugeth->p_rx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
 				pr_err("Can not allocate memory for Rx bd rings\n");
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index 6539fed9cc22..ccc4ca1ae9b6 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -1182,9 +1182,7 @@ struct ucc_geth_private {
 	struct ucc_geth_rx_bd_queues_entry __iomem *p_rx_bd_qs_tbl;
 	u32 rx_bd_qs_tbl_offset;
 	u8 __iomem *p_tx_bd_ring[NUM_TX_QUEUES];
-	u32 tx_bd_ring_offset[NUM_TX_QUEUES];
 	u8 __iomem *p_rx_bd_ring[NUM_RX_QUEUES];
-	u32 rx_bd_ring_offset[NUM_RX_QUEUES];
 	u8 __iomem *confBd[NUM_TX_QUEUES];
 	u8 __iomem *txBd[NUM_TX_QUEUES];
 	u8 __iomem *rxBd[NUM_RX_QUEUES];
-- 
2.23.0

