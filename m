Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67CD2FC360
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbhASRp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:45:56 -0500
Received: from mail-eopbgr00122.outbound.protection.outlook.com ([40.107.0.122]:51363
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389198AbhASPKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wc25o018ANbJSgBM0XaWVNVTuAjtHf1cIvbfm3VHUkoRg5l7YScQ4RP8VC9Dv8toeNWcD45LGVgaR3jVunnSlnlLx7bwPL8o3TJDd+xwXc8NzWqxW61Kmh69q7GyjpQvZvVJFPw+K2bYTK2Fq1nWg82SasU/e16uYx9Llam+oMya2+9CdeG8aIzufOdP64QVzqgQynoO+G2vsskXn2wFBWynKCFqyPZkqW/iIvO7PbKIB8ru3P1/HnTfsskLT7zw8g9CJrK703C/O/Y+5QOqApFsqESZnhuDYEJuao0m+lJ/7xSc6bqutvQqS+RsOhKnywz+34dhXy/a36HWMm1GeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Po+2fmCCMu4/YlA+Ht6dyqcd1wSfreSr7h6ENUs6K+4=;
 b=CMqYJLkmO3T1QTYxw79FVF6CqbgLNNAZA+ZyoQw1S/0DKMZ34/eZwbpb6Rqg/oiS+Bm4nSp57qTDmsfkzBFcPtgRr//quaT52hl71x8S4RtRXiScejsJg5EHVJ+QVYIma3YjokGzA8xZ7uMvGe3mpH8DzOt2DUomW2GQm4WNbjj0YeKUWOjnD+pkx7xovkmT+pgFYKEfJ7mYMLay6ugq215sDy6KXQfKDWdycySkqM84pXHicdzvwsfqvke+yrjxCGPxLIzQmSdOvRRXAhEjp9pFybzfoxcKiPqn15Yu3PKoWFjOlsApuYOBXMycGTTTrogruSEgdtCjZ+IuurEtHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Po+2fmCCMu4/YlA+Ht6dyqcd1wSfreSr7h6ENUs6K+4=;
 b=mYuhOte7ANTyT9W2Y/FIuzFnsLRjee/qDOThPjxMfhe0aOi+Dx7819Flh+u1PEtThm9dxsIVcJD/PCa0cN60/M8IuROv0BaM8R+ejjvbX8RLpoAoGbmBwAS8Bv+jO4q/7OxtLLCif7fzR9LARgDIn8pOXfGBhsOjmniCwykTnMU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:09 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:09 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 08/17] ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct ucc_geth_private
Date:   Tue, 19 Jan 2021 16:07:53 +0100
Message-Id: <20210119150802.19997-9-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150e387f-8120-47cd-1428-08d8bc8c2c26
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB36815D9050AE8080106385B493A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: digAH/alQTzFEXjLe9zQiekxDGcwZurp0drGo8gUAhCUp63s4npk4RuzoJXoAT8qnQuUo/DorTKvKFAIKPCZLoTTQM2A3oBRcVCI3zuvDxz3g+Q5GlYSHDieGbu4QPAEq5LD84MF3inhkzIHWNB9QQwnVbfehb7kDydw2DS3WQBVYvh5rHMvuyiLz/qGN1Zxq0pEulYqm9GxxZA6T+bbmLPSM4bZDvlb9Sw9gazKUW8EIgyc3WM5ZN0gl7+zj3fJQHeked3HndUyiWEBbYZnSpB8BTKvG47iqTiS77Y1ORcRuM7euGSVuucJKIdOO3JTuoQeoNt0PmIU9OhgITld8LN452O49PHyIy3U/xQ6IRSK7elaiTMx2AGvzAxFlDRuJtCMkT3/gRhtTGH6ZWOIxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?COX8GyUbP0sBg+y79CCRmfeR8y1H5gmyp564vw3d2vDMnqqDARxTzbY8M78h?=
 =?us-ascii?Q?zJxh82X79i3CCjINPaZwEgZDLQ2fKJo+FRRaO58vIbddr2T/P0uoIgUsiJaY?=
 =?us-ascii?Q?P0QGR+HuSJpozCdWlWEgQnOlgmrhV/S2+DdfXssjeN8Hy01EhMSdc9z5uBLJ?=
 =?us-ascii?Q?I7SDG9nApYl7ki2DJJgLctbAgWpPLuzq+ubmxUxoBJ/kAgFbHmv/Ue4nzylP?=
 =?us-ascii?Q?0KEVPwB56jBcaNxQwIuGmCeP6vMWqoJghOqpWRa4vwaDiSY+N9FtrHXmF9Qd?=
 =?us-ascii?Q?dopZKlhWs/0GLa3BFDjTHDEs7dFoiZz4WlkEyakZxxWaE2GeBsi7GP4qlao2?=
 =?us-ascii?Q?nG08AdPy2zl5FukPPVv8nLL4a+/Vh2sPzXqUQmF4zY06nv9Y81ml+zr2Jenb?=
 =?us-ascii?Q?Yk7xqco3FT5LmIvadVDLwj3KN8tZKPoKG4uH/BXA2kg2lLIhsfsnXLdY3vbX?=
 =?us-ascii?Q?7is9Ni0MtQmtwF6aFdnG06lHzsHvWU2+JCFSz0QY3n5MCm84McTg9Ymtqjbj?=
 =?us-ascii?Q?XRzhfaT2i20+c+ncITIX59ZyboKESYwcIwJ/9OPdOnFAozF8BGiCse2zhd/w?=
 =?us-ascii?Q?eG1/yKc3UTNge2b+XiR1QrXOKG3iGEARCyXHi/HknkqTe1P/Vk7tq/iOlr/e?=
 =?us-ascii?Q?4p7VgU6omXaNe98TrN6PTsJ3GgmxJAcGXrOeqs7UzmYItBeqio5be7aVBgyn?=
 =?us-ascii?Q?5p1eoHt6Jxfoza9LNoWZ5GRn2PRM8KAHWyk/Sy9f4hyUINc/6k1nPPHCiXtS?=
 =?us-ascii?Q?kUbFTXPLzGOsGIrB9QPR04+TNoDcMMtw1Xwtcy7m+OW6wLDG8YXMf2knypUv?=
 =?us-ascii?Q?8Zj2OFcYGldHzv39m7xQHn6+4GYHDvEPH01+6G92Zq8roDJ/l+dGttsaiycm?=
 =?us-ascii?Q?ZexyEa5/33+Lvx+cFAuLfGmA1J4RUp+6f4Jnt0peNUw8CUj/oLPWTrCB56pz?=
 =?us-ascii?Q?K/cnoBOX34OE1kms9huWIkG9zu09voVYljEw45KBcKN17UJlW2yRZJezLT+J?=
 =?us-ascii?Q?YXsj?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 150e387f-8120-47cd-1428-08d8bc8c2c26
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:09.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9K9JDEQgbq2Iomhz7AWSvO149/ThcxI3GPxGqvcyXdNHnqUlEUAvtV1r7a3gKQdM6gRZYpy/SmC/mI+mymjHcd+tx2UY+gl4KkZBESPwvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fields are only used within ucc_geth_startup(), so they might as
well be local variables in that function rather than being stashed in
struct ucc_geth_private.

Aside from making that struct a tiny bit smaller, it also shortens
some lines (getting rid of pointless casts while here), and fixes the
problems with using IS_ERR_VALUE() on a u32 as explained in commit
800cd6fb76f0 ("soc: fsl: qe: change return type of cpm_muram_alloc()
to s32").

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 21 +++++++++------------
 drivers/net/ethernet/freescale/ucc_geth.h |  2 --
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 74ee2ed2fbbb..75466489bf9a 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2351,6 +2351,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	u8 function_code = 0;
 	u8 __iomem *endOfRing;
 	u8 numThreadsRxNumerical, numThreadsTxNumerical;
+	s32 rx_glbl_pram_offset, tx_glbl_pram_offset;
 
 	ugeth_vdbg("%s: IN", __func__);
 	uccf = ugeth->uccf;
@@ -2495,17 +2496,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	 */
 	/* Tx global PRAM */
 	/* Allocate global tx parameter RAM page */
-	ugeth->tx_glbl_pram_offset =
+	tx_glbl_pram_offset =
 	    qe_muram_alloc(sizeof(struct ucc_geth_tx_global_pram),
 			   UCC_GETH_TX_GLOBAL_PRAM_ALIGNMENT);
-	if (IS_ERR_VALUE(ugeth->tx_glbl_pram_offset)) {
+	if (tx_glbl_pram_offset < 0) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate DPRAM memory for p_tx_glbl_pram\n");
 		return -ENOMEM;
 	}
-	ugeth->p_tx_glbl_pram =
-	    (struct ucc_geth_tx_global_pram __iomem *) qe_muram_addr(ugeth->
-							tx_glbl_pram_offset);
+	ugeth->p_tx_glbl_pram = qe_muram_addr(tx_glbl_pram_offset);
 	/* Fill global PRAM */
 
 	/* TQPTR */
@@ -2656,17 +2655,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* Rx global PRAM */
 	/* Allocate global rx parameter RAM page */
-	ugeth->rx_glbl_pram_offset =
+	rx_glbl_pram_offset =
 	    qe_muram_alloc(sizeof(struct ucc_geth_rx_global_pram),
 			   UCC_GETH_RX_GLOBAL_PRAM_ALIGNMENT);
-	if (IS_ERR_VALUE(ugeth->rx_glbl_pram_offset)) {
+	if (rx_glbl_pram_offset < 0) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate DPRAM memory for p_rx_glbl_pram\n");
 		return -ENOMEM;
 	}
-	ugeth->p_rx_glbl_pram =
-	    (struct ucc_geth_rx_global_pram __iomem *) qe_muram_addr(ugeth->
-							rx_glbl_pram_offset);
+	ugeth->p_rx_glbl_pram = qe_muram_addr(rx_glbl_pram_offset);
 	/* Fill global PRAM */
 
 	/* RQPTR */
@@ -2928,7 +2925,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	    ((u32) ug_info->numThreadsTx) << ENET_INIT_PARAM_TGF_SHIFT;
 
 	ugeth->p_init_enet_param_shadow->rgftgfrxglobal |=
-	    ugeth->rx_glbl_pram_offset | ug_info->riscRx;
+	    rx_glbl_pram_offset | ug_info->riscRx;
 	if ((ug_info->largestexternallookupkeysize !=
 	     QE_FLTR_LARGEST_EXTERNAL_TABLE_LOOKUP_KEY_SIZE_NONE) &&
 	    (ug_info->largestexternallookupkeysize !=
@@ -2966,7 +2963,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	}
 
 	ugeth->p_init_enet_param_shadow->txglobal =
-	    ugeth->tx_glbl_pram_offset | ug_info->riscTx;
+	    tx_glbl_pram_offset | ug_info->riscTx;
 	if ((ret_val =
 	     fill_init_enet_entries(ugeth,
 				    &(ugeth->p_init_enet_param_shadow->
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index c80bed2c995c..be47fa8ced15 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -1166,9 +1166,7 @@ struct ucc_geth_private {
 	struct ucc_geth_exf_global_pram __iomem *p_exf_glbl_param;
 	u32 exf_glbl_param_offset;
 	struct ucc_geth_rx_global_pram __iomem *p_rx_glbl_pram;
-	u32 rx_glbl_pram_offset;
 	struct ucc_geth_tx_global_pram __iomem *p_tx_glbl_pram;
-	u32 tx_glbl_pram_offset;
 	struct ucc_geth_send_queue_mem_region __iomem *p_send_q_mem_reg;
 	u32 send_q_mem_reg_offset;
 	struct ucc_geth_thread_data_tx __iomem *p_thread_data_tx;
-- 
2.23.0

