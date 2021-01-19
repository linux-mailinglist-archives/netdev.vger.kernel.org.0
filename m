Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1962FBAEE
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391164AbhASPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:19:14 -0500
Received: from mail-eopbgr80120.outbound.protection.outlook.com ([40.107.8.120]:49294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390928AbhASPLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAx+QCHGYLN8m0Q2z13d+vR3k/uK1iiKnkwFP/Y1IguF3oMIXyFqmFQJXbY783uIa9ZO0XNGD1WRhxetBEOLyfm8cycLcEPsaJfLCT7E5p88jeFdCdbCo60cWLa3/lhsJgpUDH4f/wRFtPpctAB1xlROrUvBdDgKMK2Yp5EYpuVHKN9QmE28mlUZG2gOGIXb3X6HSvVZ0ER2WNhfIYigsLVkFF6t2laFzD7ThYhNMPHE0OU3jkysVpi49PHWG4JSyEEcPUdFLznRT7oyLQ9zAVbyMoajv6xFlRMj2ZuuIdLLnKb98brtDXuCscxpAGnhVV6ls/qNP5ffX6d+4BSwXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJ3XRP0oKsSG7l14/Pwn6UoRvn87pRhIvThvNy5H3Eo=;
 b=b3RzfTyEJNjzUMUH1QIxVTLfG7XBH728k8w84ONVwLNhA3H+/FIh/lCL7Xe0WC/uFj3VPTD6gDcTmMg29lp+E/rT0J9LbHhwMHJ2dJy29hf6d9xCpV8oImwdrwepxy41nzT2MAFRvkoAqKLu+YQPK9dMTZxd448POs1R1+jAhEwxcx93IveC37OCwKoHafEqzuNAzMJdhL0tCpU7GelTHSUMrGMipFDWeot8pNnRFQdNYQlwgaHUIpiO+WA9V8yNpOGmBpuOeJh74nThTR/UXJNVsp62wJzWAiyZ0kCT/Rlvm1t1LW/8UTMvifRZQLfPl2yf2RhVx/MbNfl57BmNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJ3XRP0oKsSG7l14/Pwn6UoRvn87pRhIvThvNy5H3Eo=;
 b=GIKfvKyZMXBnotnW3yIQFv6MyF27HDCjEph9cQ5oFjxWrHr2QpMpMYjs3BMylXK5q+McFY3ZXeHLjrqTL1swH2ax75nvo99B2V0kwYCYKAYXZ2vQCFYPayTIaB9Ws52vN1Nb32+YoKSl9hotNhkSMnHx96uhF1dc0yWfJSMfg64=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:18 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:18 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 14/17] ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
Date:   Tue, 19 Jan 2021 16:07:59 +0100
Message-Id: <20210119150802.19997-15-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f39978d5-5d9a-4912-4ca3-08d8bc8c3189
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB192252A7393436C8C1B7BFFD93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYWBJEVsc5Xm/8aqFd8blE2UybG97EotXl4NkA2bSp3MR3cAu+3cCLyiz5jdgx8LmMSYWKr20eu0RFyjTXVvJciEfGKYtdv2Q9sb5Aqs5V6FfQnjnPBdwXh5HS3zJmLoFAIcoM4xWMxDS83oL5m/5p+5noPvpjtp0f5AR3HbIVAjzAmbMs7ooNG5BGLsEW2VRy4lcHc6MHTjcTUzag66lTG9QNcfARFxf3qp3CgFYZEr3/HSE4mYDfjtxQji2IwSVI+lUFxHo4TFP6tYlFEGTCFrP3IJTzaoxLNIRH3+HSQPaxjWBy23UH9+ck0ZEOoS4ljwLAqJCQcbtyPk1ux8bQ+Uqg1A/bar590RQe9edfrLf4zo8fo+lVnjoTGf8uF5c29BtcQe7+YZvY0fe5b5lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iZI3PJwMkuG5/jFejZSnL/P8ubhjB+vGYHWpo/H3czlDE43KXvLsg45yeKWg?=
 =?us-ascii?Q?YrIV7x7WFpCkjq/ju+ZbLm6CRAmgcwk/U/5dLRRQ9IHOjzWcG2jzPbi9Emt4?=
 =?us-ascii?Q?UTH6N6xrJ1GOR1rUJPJlmfrhzWlJkj6hYcOHewkxJfA4H1pRzN5Uo6WcMLBe?=
 =?us-ascii?Q?wokh5zOWXchDKWGs38FusU99jxswmGcINPX3sCvkKkvCgheQn/UzKfa2WMHg?=
 =?us-ascii?Q?tjLJZUM/yD/yOQkNEfywiq8bXcQZowVNGLM/60SAOq1wNW0yjYoJKsAnqv82?=
 =?us-ascii?Q?RdpJTGpGUzGD+2T8etmiiQXIK8TQhf7maAq76RvEFAIojiv+5UCvbg/6g+vW?=
 =?us-ascii?Q?pUCFJth5kCCzpadNPi9lzWsWqZNiQ1NtqxLjucWW4W67628ZmcuXzxMNmfVC?=
 =?us-ascii?Q?MpHkPbWWnco0Bv3sQGVLKV5Pab6JfRpZtPLy1PtcnTUk8mb5hNNtVg+/PF8e?=
 =?us-ascii?Q?NIQHsBmr5qJeaZuS8OJZDMnqUDJ0Kig76DFmsVzhLwfBfxrYXFkHlkVSvHli?=
 =?us-ascii?Q?BUI9M1T7gMI8Sd9Y+LF4ixwLm6B8uwh75xy2OOoKlRdREEOwmTPIr/daJ7uN?=
 =?us-ascii?Q?NKDorPjiH79kSlJ73HC2M2OasCn/LZBNMq90rXTnF+vFmH2fA4YGUNnvA7MP?=
 =?us-ascii?Q?qQcyfjfPN5uV0FIY98pulE/6Luds45RBISoDZI/V0gVmckBR2K9jIuZ8HMeo?=
 =?us-ascii?Q?/vLb+8o7Xd6BlZ3AEAZbcnByn6pAGG47wHwEZf3FMo1dpXWFxhS6yNW5Qevc?=
 =?us-ascii?Q?ZB/seg6ExjyBqxNBGuoFP3Un4VxCSlLbxpaAnP5U8+kIa1GrwGP6oL00oxg0?=
 =?us-ascii?Q?rcYDp/xWcXC2Lt1OqvzsMUGEdt1Zv7pJ/IJ9mNjE5IkryTVL4lDutBgrVm8J?=
 =?us-ascii?Q?yAMyg1CDoyZiZph6o4dBG6I7xPl81mNXQHRHFNCJYqf1FMI0Tb+J841KVim+?=
 =?us-ascii?Q?3BaBLY8Vgz9ZBXA23lD9vebbcbMWcoBL4th7ZXTlc/JLD7tFaZZLzl2fMlLz?=
 =?us-ascii?Q?usux?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f39978d5-5d9a-4912-4ca3-08d8bc8c3189
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:18.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKmH0+wkd8BrZSpkHvov17Y8K+LRdr0anv6e9UwCa0eWPprnZlBhojtDl8+TcweVu0Vl1HJbfCMeytCDg+zuT/BDU2RvCeb4+aje/cZWBc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 1e9d2f3f47a3..621a9e3e4b65 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2203,8 +2203,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesTx; j++) {
 		/* Setup the skbuff rings */
 		ugeth->tx_skbuff[j] =
-			kmalloc_array(ugeth->ug_info->bdRingLenTx[j],
-				      sizeof(struct sk_buff *), GFP_KERNEL);
+			kcalloc(ugeth->ug_info->bdRingLenTx[j],
+				sizeof(struct sk_buff *), GFP_KERNEL);
 
 		if (ugeth->tx_skbuff[j] == NULL) {
 			if (netif_msg_ifup(ugeth))
@@ -2212,9 +2212,6 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 
-		for (i = 0; i < ugeth->ug_info->bdRingLenTx[j]; i++)
-			ugeth->tx_skbuff[j][i] = NULL;
-
 		ugeth->skb_curtx[j] = ugeth->skb_dirtytx[j] = 0;
 		bd = ugeth->confBd[j] = ugeth->txBd[j] = ugeth->p_tx_bd_ring[j];
 		for (i = 0; i < ug_info->bdRingLenTx[j]; i++) {
@@ -2266,8 +2263,8 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
 		/* Setup the skbuff rings */
 		ugeth->rx_skbuff[j] =
-			kmalloc_array(ugeth->ug_info->bdRingLenRx[j],
-				      sizeof(struct sk_buff *), GFP_KERNEL);
+			kcalloc(ugeth->ug_info->bdRingLenRx[j],
+				sizeof(struct sk_buff *), GFP_KERNEL);
 
 		if (ugeth->rx_skbuff[j] == NULL) {
 			if (netif_msg_ifup(ugeth))
@@ -2275,9 +2272,6 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 
-		for (i = 0; i < ugeth->ug_info->bdRingLenRx[j]; i++)
-			ugeth->rx_skbuff[j][i] = NULL;
-
 		ugeth->skb_currx[j] = 0;
 		bd = ugeth->rxBd[j] = ugeth->p_rx_bd_ring[j];
 		for (i = 0; i < ug_info->bdRingLenRx[j]; i++) {
-- 
2.23.0

