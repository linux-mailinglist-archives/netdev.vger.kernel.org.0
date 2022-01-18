Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0FD493014
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349657AbiARVnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:43:06 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:1123 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349549AbiARVmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:49 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20ICiDwW001396;
        Tue, 18 Jan 2022 16:42:28 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnapfs2m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dj/ro1PhcZ1S/FIyT/xGfJwCN5L3N814+PUvrxHzHZjo6SjxR/vZ76BjRdWgBcdcEKVpO5KauSN+BsdYfh66sWQ9qa4d5Iy/tsnnuLQ6KKcieco7eJp3fYHiCMx25uVST0A6N0i6adw9veb3a+v49w9nBl3r5k1ioKnRD1uXKX4SRoCRwbNtoxwWLdMXf1AkLzp9oWx37p7sOeb/zuUyNWs/YAMK6waOuspJc8V2elOQnLI6VackUs18ytczrT6QPRNVofV/RX3I/fdHM1pIN/tROkVWxwvUOs1inhzF5LA/Mm2RgMfUhKZez+93rtgklpXXcZJsIIQ5pRXHHbKteg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mS9qW9h/D477kjIlSyIvVI+5gM++DTlsJEuoteorGBU=;
 b=BdnSVBTeuedX4KylRa6aNqjhboMBMH3QExFsR4F35f0hh9jKOVCVhnMwUfPUuphF2+amzLMw+FMATK+RLhETVjUlPRnAUt1Chk0yTUCnHTyBjmEk+bIp9Rmr0VtvtsHXrnaaCwmxkWS8WK4AGFXxJZNb6lG/Av20Vsr5NiQZ6//payYcIlIZijAB1BN5CWqPUjbQRS1nMK43cUk1rJrK7SN1rJ0zMOodz+R/wPYV3kDkQ2/iFoKErwv7BM0Eug1o1MlvYXb6DtBJxVRrEfpE60k5C6LGLM3Aq/+Bkq+JH5QVPEhA5xAR1XWn8a65iz79CEU59at6DCgaSXE4aKmYLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS9qW9h/D477kjIlSyIvVI+5gM++DTlsJEuoteorGBU=;
 b=3WZuF4zoQVwefAcFTLjnC4FlApRSOCxBMo/aFj1WnFF3lW7Gep3K+TZUT/fd+p0HGq5bZaEgfxjhrf96gj2PVfY76P1zF6R6EZ3rGjCwEvMJ42UqsTUV3iOoJqhOuh1P+x2/5jzl2e+3d6jpZoSr89YFFPpSYgqv8cfBlzHkjd8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:26 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:26 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 4/9] net: axienet: add missing memory barriers
Date:   Tue, 18 Jan 2022 15:41:27 -0600
Message-Id: <20220118214132.357349-5-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc3ecef2-a782-4f7d-e2a9-08d9dacb6b7a
X-MS-TrafficTypeDiagnostic: YT3PR01MB6003:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB600363B4611AB37B9F55F816EC589@YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lB5yIkC76vqsHkmpbVRmM91fI0gkfGj62ZplSjVlHufvYbvIMofut0wOcI0zlzdQMO6+WyORrEagQCj+BLth4kfoeemiV1HyywB00jyraa6d8nCAopAB2X2rBPwwhD1O7/ilXzWNbx1nfQO12Wqq1kwHsSh1aOepAu8zx3HTQ45CaAOcz80KJzRZFZJ1EV1h0XABWbeokoi0dkkclxjQeynK624QIU2mYAEQrG+Y4MWU4HtbdfbKhcAsyqcyN00EqZP03bwzQZ7/2u3B14oKf6rBuRMNLjBa1PjdfBB+HZ0aMguK/k2YWplJ6qFKnlZZBAZ2wz6ZrHgBdOPU48ya4CDXHxjeEIkvRbzxoR3ZZUkgCVfAnNP8itRlnN+GMTuB8TXab8h3SzMupSIDK1rn0Bj+6bdqa/yJK/hCI+RHKSCF2qF7Og2DHWl+SHEo+4G5bKCcpjotZorNRLdBb8lCoSHuMrTxiSPvgERjspy4QKNDVkmz+w8nPI4b4YAJ2UbqX9ijFVAMY31mV4I8NpyyrwCR1+dftxOMB/m7z6hdwMXiPMGJwqxc3z22EdXKFjkDetz7ZF7lYePsqIw+OdC15NbjFpmyU/Y6W6YMYH3wMCyC3JTv9c8w8hSfliEcv35mZy/bd3RBNXTVnGVVdMc6ThEvxQVY6nxLBfkCB/Ea0zkjDlTdUf+EG9zVB1yCUxDzCAeZaS/T8u6pa/7LitmyUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(1076003)(66556008)(6486002)(86362001)(66476007)(8676002)(38350700002)(83380400001)(186003)(66946007)(6916009)(26005)(2616005)(4326008)(36756003)(508600001)(2906002)(8936002)(38100700002)(52116002)(107886003)(44832011)(6512007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u8ZPhqtHvB8FU1exd/VzK0oS4+pyNqQl6EXzLXGR5gfFwkN61jv7FG0BWxzj?=
 =?us-ascii?Q?Ek+aROXFtst+Ww5yokvT9vdWxe4KNb/+liV3Zxtf2SwSNNlyIP0ZtNhZA0po?=
 =?us-ascii?Q?OnFeB7U0Dg1xvJAhJJUA1F4QpczLK9QplsPOEUCtJEONpmVKKwO9htT/mE3X?=
 =?us-ascii?Q?4tXAWf7/mynbGz4HYNxQz9cXaPK/fWvYwcbNznOdwywpBIBjk6NfL0iljT1V?=
 =?us-ascii?Q?i5NZ9XztoJeKYhtEX3j79kBTeS6E9z8BZRT2K2ubYGNtZHwz5tmxN7r18ErZ?=
 =?us-ascii?Q?oXC3jHBEr4zvTVG38jhhVy9tGDD+wkPDraWfhTKs0RTWjOdnBFyy9aABoHhK?=
 =?us-ascii?Q?3r5gLgc/tu1D6iiUjlOl9PKzMzyzc/ZEzf1jhkMZOXCBX5Xn6T7FW2tsA8Ws?=
 =?us-ascii?Q?gC6GQiQCO69CtCPJ7tfhMZj3okz+O9oXR3My5/dxHaZuc66z0BdES16pMh+0?=
 =?us-ascii?Q?m1vT2834Xx3rK9Nd7eYFr4rVWsZzchJmmrXsJ0YZICuyZbAGRARhq6BYji9p?=
 =?us-ascii?Q?1Z9QkcLqYANP9JufF/NmGjUiK2Prc+X8zAyJgtACDDHH7TUaafp1oPp9oxb7?=
 =?us-ascii?Q?F/GN56JdbX94qyJc0SsiuXXFb50w5w2ziMk9zBl1iI5CmdV2dqDbz1Tx3kh2?=
 =?us-ascii?Q?S8CA9J5hOkj4f5SZf7hz42MEggNw1vQOwnpusB0Qu+T+3/ux0SKlWGzOIYj0?=
 =?us-ascii?Q?uLF9Dtdk4aL/IBprD9AL+SSBDdH0x6Ua3VP0mbT3U5LI6j1+yNbhJ/rBA04J?=
 =?us-ascii?Q?cW7uccAl3GPjKNoZ+ATouUkiAHWGBtQbAiM6e+oOv9iMT+mQrKhtTiDObFj7?=
 =?us-ascii?Q?ed7h26nSix20w2F0F0yhCZWZZoUbGvsKaIPnHP/NqJZs52JsY0eEal7CsMbp?=
 =?us-ascii?Q?P//CnIb2U+n4NGW3e5fsGcdYLEa8YjgUhcRADHNfl3qSqHfTSL1McWrFEB/4?=
 =?us-ascii?Q?vVwqLJ562TRNUXzfoK6zB48qqRqp+OCQg6RP8NBl7UsXuO2GAt9QxTGPfODw?=
 =?us-ascii?Q?rqro9i0QCGJLW4whKpft0v0ncVRYtexJN+a/S5I2r/qdXQxK8lSh4T6yyByh?=
 =?us-ascii?Q?1orkAA+7h7w9VAfamTDeGS0P2BSlpitTO1oCYzRfMf29A7PYE9ezFaCaDh8D?=
 =?us-ascii?Q?rY0eOxDQKW3PwHRQP0IzxmEUfJLQrdx8sjOgJ4XgUYQFPOgpw0rnxOMhmjOe?=
 =?us-ascii?Q?+FIi9rnqsH4IGEMSJRBFXy+9/xCCbwIStwHy4fUfVhjodmBL0VeXSUVK4G9i?=
 =?us-ascii?Q?wHYhJ+wKcVxgoYOH4kwKCxxI8g8tGHSNlwdHbiXUkXPn3i64ZyhXrEILvBiV?=
 =?us-ascii?Q?lQ/GCrBdalEHfDReE5rniPq3NdrCLAWt5wzb2BBx/kkaziOhlbxpsEdTYEAi?=
 =?us-ascii?Q?0B1HTJAs8ZXGxmW1XqTbuVtlKo1aq7Aka7c9vHaBAdiw7YfDWuEHyfSncqF2?=
 =?us-ascii?Q?gEkC7wzQY8tutKlOtorAkRe2tkAxsrN1n9PxVkuHiXff++iN9SegHL8nqofm?=
 =?us-ascii?Q?nNC1n4WBx2dssr6sbdggkFT44U5rU77RkZ/FIoG57AhPsx38+MuLGuod3I3Z?=
 =?us-ascii?Q?YOVgpZLu1KdE+XYb3N1fJrxr2UcFeVVyTtWViCHN8lpPCSqiBxAGB6cfaUoo?=
 =?us-ascii?Q?f+kPwHvZIPuc3YWxGlK4iGR//X47RgeYJybZOx/QBA71YQBhPm12Qo6+IOiU?=
 =?us-ascii?Q?4PKLe3aTaHAtICc3mO6ZRlrU30M=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3ecef2-a782-4f7d-e2a9-08d9dacb6b7a
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:26.7161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LWPHcyE9fz0YaKpTy6AWdLSARcc7gETTDYpF3/Uou6SVH8KKfsTQYm52eqBB1N12QXOJqLQtr5NmhUR3wSYRPeNCRbpEqysoGjZnrLohKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6003
X-Proofpoint-GUID: DwqWuOldaR3XhlpfDicT4sGUJnGs15E5
X-Proofpoint-ORIG-GUID: DwqWuOldaR3XhlpfDicT4sGUJnGs15E5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=652 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was missing some required memory barriers:

Use dma_rmb to ensure we see all updates to the descriptor after we see
that an entry has been completed.

Use wmb and rmb to avoid stale descriptor status between the TX path and
TX complete IRQ path.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 53ff38cbc37b..fb486a457c76 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -632,6 +632,8 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
@@ -645,8 +647,10 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app4 = 0;
-		cur_p->status = 0;
 		cur_p->skb = NULL;
+		/* ensure our transmit path and device don't prematurely see status cleared */
+		wmb();
+		cur_p->status = 0;
 
 		if (sizep)
 			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
@@ -704,6 +708,9 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
@@ -843,6 +850,8 @@ static void axienet_recv(struct net_device *ndev)
 
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);
-- 
2.31.1

