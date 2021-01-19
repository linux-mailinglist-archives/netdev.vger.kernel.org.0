Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F4A2FBB42
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbhASPcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:32:45 -0500
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:42328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390660AbhASPLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHIUaWOZB00fI+xNrXdVFhOJyihoOsJeGfCwv3Z6Bg5H3Qt/bM+O3R5yBNj1eYHEgqzCqILo2mWK4mFYO+prFWjkP9ParPpfey5yfatsfIRNSkHihfPNaeCtlqJscDKnQS5bdTCMeqKMrMJGlCzJpiVq/IdY+l6F5AHscXjbaURDZ8dDtBr3R2DyQrmGrXXMw9mK2bXNNNP9RL9Gclx5w+7boHglsRzMWABGvfrZ1jVGI1AVpsOBYh9Dst0XBVJnR9c/gdvVvudRibbX3bK9tOhGnCfKe1bagYVzRf0dgZ3bs1YvD8jZvYHPM3cwV/nqORmnZYBsGF8TCvNKGXHWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNkJWBr2g8u+Fd0BIWV2yxIFSqFq7M3AyyR64zBAZBw=;
 b=dF5tn/gdYXqPH4q1ZVhQsulySj/jUmGoW8B73iXOq2LJ4sEc36yVwrPbtFuuLYU13qeK2fs8hN4Deoy85b+goB5jMJHKoIgSi3ugv3AGOPrlkJcTBpZdI+bj3ikZvJFSo5tExDYXpweExXwLPdg/JhTf9gbLj+7R8O39H/rUJDKPh+963aHo415REmgoFSjd+Qvgvmczc1mtp6idlYHnfmFgH+Lht6p2IaF8MVJf0bxq1VJI2i92fuCxbam1MsS8w8W+nQTOA4gBtpefaiNFvSxK2thbyLMWW1AGOn703gVdkI+cLiMbtaLWS1POZlJD6AbuemFme1WspP1/raDMkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNkJWBr2g8u+Fd0BIWV2yxIFSqFq7M3AyyR64zBAZBw=;
 b=Dc3owMBxMXzfBf6BkLxmsLulu52nN2S42pStmfB33qH/oKxSDDHsTLeNN7Xxt8Rq0rYiyPaXQCXTIlalY45Fiq9Vq54voIrOyuBB6ynYGSlerg8vTY43QLhtgUibFMlZXna33pIobpHdpi80w/ywQCj9RjbK7Kdl6ZWGmwyrAio=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:07 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:07 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 06/17] ethernet: ucc_geth: remove unnecessary memset_io() calls
Date:   Tue, 19 Jan 2021 16:07:51 +0100
Message-Id: <20210119150802.19997-7-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dacc0ec0-3a3a-4d85-14d4-08d8bc8c2ae3
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB19220022087092AD6501E9CF93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVh6S5faa1QDifPmUsBNFDN8TFTijPM2eyx6Ff7+wCRfUujxvGJjXrPim0ffi7xo/yp3nSuF3veMhkQeQlkqxidFNRzouancaMoGp7jxrX4WbJLXfDqgXyk4nl2W8CHrQSf119SvyTuD0YzwTMNgltm3aaXAHXGaZcaRu8KlkTv9ggCug3AsuMDg1UKvAqoWiP9Z4WFZlL8SVnv28wHyDctpmHX3v9GA8mY5Rsu3+Ma5smciL8KagbFFKw4lNY2atG+MemP5/hx822sdDJrSDnE8La2TUbyAujncrzNrmeY+vTlm0MBpN+OOl2Jbo5WNZnT3ASQawWmGrBUIL+MW0ytWjduo1yN04zT2uEFsIA1OPgJN+WBscVYJBzyuCwJa7JKlHGyrUGMmnd0Bo/8xTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jw84H4/gciVVpVWPKpQYltbRJzJzhWPTC6JlCjv5HSA9OBQT4AIEyk2M7WwR?=
 =?us-ascii?Q?CKWjaRRpiAfwiEwa9pLX4rpeV33A7b3sEAAUWXMqgpeWIC3l5+3wwChhfXWe?=
 =?us-ascii?Q?oJAb4wszq8zBiFmjI5Se5YHtYL+ACNvmD24toF+PFCtOxTX/zXXzo87r7quk?=
 =?us-ascii?Q?OPugLbRaLIbmxWo45sCTsmuivtXUcavxj2x5xhlsSzGTtwjQDUYx+Ax7CX02?=
 =?us-ascii?Q?Dfkm3oApA0C3LLUcbuboYgRfcIt8JPBOdm75McUH7r9qrzSYznt+n22wFdu9?=
 =?us-ascii?Q?wrXpfVUTRzByn7W5BFX9MByCMxw+jcAndwQNk4B8thPYuQNRPW7ajOvQLmQz?=
 =?us-ascii?Q?pk1KWSHNTx5z5Lst0rli6NIkr7nWN9pkMaq+Hjxsr26nKgdAXc8RZqRis+6W?=
 =?us-ascii?Q?0Cg1QXEhiiUbIdwQYXutqNYsvhAwKb7PrMTgD3vW7vNvAvDGzOH21JSzjf+I?=
 =?us-ascii?Q?dWkSjyoFDKUQ8fkJAfDNv5yd/FMdW2O2kaM0SxUuSnx18Plw4cn63eiNB3s7?=
 =?us-ascii?Q?nSgGPHOoPrZ/tFKAeGXe7Txsit2PG6j81hBSjtcEmhKrXvSiVEK3yTvqUMyD?=
 =?us-ascii?Q?l6vTUBsv24uw3fXw6aFdEVy+ikFU0jInMlDhv20MVWSNIGMHePJR+BV3K4M5?=
 =?us-ascii?Q?EcrDugQ52lyXvqA3Q7LNkN/8HF8cvVQtw4lu+h15QpSTl5SG2VCpRkAzeEr3?=
 =?us-ascii?Q?rM8ojZybMu6ALHijc61sCEenoKSadHGKUo+ebLkJInVuS2upLsADTdpPmjn7?=
 =?us-ascii?Q?y0KzH8U/Dc5sUqmgpRMh0urCghI4RNO970ue/EmNkDtcct7Oguv4gB8sVfZH?=
 =?us-ascii?Q?AlKFhwuXDg7bYX+EJwN2lguxyPJS7Q+mF0sYUN5OMTnNl/4Pglk3ilHfHBRE?=
 =?us-ascii?Q?Ao1iZizSWdMPJvtxsCmP19sT5dfTaTJSTgfSUyeTtR1+MKVRy3YtcC0dQtoq?=
 =?us-ascii?Q?A189ootzpP/gRW5ueCTNPVqqDkxkDA8Clkv0lia4KOOIJSWAVAXaeokIFxLF?=
 =?us-ascii?Q?EqaB?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: dacc0ec0-3a3a-4d85-14d4-08d8bc8c2ae3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:07.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVRkgNm0DnD0PlU/H2/kMQfVwmyYdOs29V1lJlKR1VkplORZawapMO2eI07LhyyEVoKgo0oUN2kOnp3SOD4r2INAR+8u5MmTrxpCLc9hgxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These buffers have all just been handed out from qe_muram_alloc(), aka
cpm_muram_alloc(), and the helper cpm_muram_alloc_common() already
does

        memset_io(cpm_muram_addr(start), 0, size);

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 14c58667992e..be997b559577 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2506,9 +2506,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	ugeth->p_tx_glbl_pram =
 	    (struct ucc_geth_tx_global_pram __iomem *) qe_muram_addr(ugeth->
 							tx_glbl_pram_offset);
-	/* Zero out p_tx_glbl_pram */
-	memset_io((void __iomem *)ugeth->p_tx_glbl_pram, 0, sizeof(struct ucc_geth_tx_global_pram));
-
 	/* Fill global PRAM */
 
 	/* TQPTR */
@@ -2596,8 +2593,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 							   scheduler_offset);
 		out_be32(&ugeth->p_tx_glbl_pram->schedulerbasepointer,
 			 ugeth->scheduler_offset);
-		/* Zero out p_scheduler */
-		memset_io((void __iomem *)ugeth->p_scheduler, 0, sizeof(struct ucc_geth_scheduler));
 
 		/* Set values in scheduler */
 		out_be32(&ugeth->p_scheduler->mblinterval,
@@ -2640,9 +2635,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		ugeth->p_tx_fw_statistics_pram =
 		    (struct ucc_geth_tx_firmware_statistics_pram __iomem *)
 		    qe_muram_addr(ugeth->tx_fw_statistics_pram_offset);
-		/* Zero out p_tx_fw_statistics_pram */
-		memset_io((void __iomem *)ugeth->p_tx_fw_statistics_pram,
-		       0, sizeof(struct ucc_geth_tx_firmware_statistics_pram));
 	}
 
 	/* temoder */
@@ -2675,9 +2667,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	ugeth->p_rx_glbl_pram =
 	    (struct ucc_geth_rx_global_pram __iomem *) qe_muram_addr(ugeth->
 							rx_glbl_pram_offset);
-	/* Zero out p_rx_glbl_pram */
-	memset_io((void __iomem *)ugeth->p_rx_glbl_pram, 0, sizeof(struct ucc_geth_rx_global_pram));
-
 	/* Fill global PRAM */
 
 	/* RQPTR */
@@ -2715,9 +2704,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		ugeth->p_rx_fw_statistics_pram =
 		    (struct ucc_geth_rx_firmware_statistics_pram __iomem *)
 		    qe_muram_addr(ugeth->rx_fw_statistics_pram_offset);
-		/* Zero out p_rx_fw_statistics_pram */
-		memset_io((void __iomem *)ugeth->p_rx_fw_statistics_pram, 0,
-		       sizeof(struct ucc_geth_rx_firmware_statistics_pram));
 	}
 
 	/* intCoalescingPtr */
@@ -2803,11 +2789,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	    (struct ucc_geth_rx_bd_queues_entry __iomem *) qe_muram_addr(ugeth->
 				    rx_bd_qs_tbl_offset);
 	out_be32(&ugeth->p_rx_glbl_pram->rbdqptr, ugeth->rx_bd_qs_tbl_offset);
-	/* Zero out p_rx_bd_qs_tbl */
-	memset_io((void __iomem *)ugeth->p_rx_bd_qs_tbl,
-	       0,
-	       ug_info->numQueuesRx * (sizeof(struct ucc_geth_rx_bd_queues_entry) +
-				       sizeof(struct ucc_geth_rx_prefetched_bds)));
 
 	/* Setup the table */
 	/* Assume BD rings are already established */
-- 
2.23.0

