Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C548B9BD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245366AbiAKVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:35:33 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:16703 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245384AbiAKVfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:35:31 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBWJUk022122;
        Tue, 11 Jan 2022 16:14:30 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGX2L1+SS0Svi2p5qlNdjkxjv+g+rmUA0Dde/KUSO3WdhSVgJhg4Sr66276uQdUqwhelVY9Zh/PxdVxKvTiKZ6vd3mHq7yc0gJYl6SemADYRyM/fh26GalNm9jH56ebLBA40AO8uup7pnm+N2rX1YEd3sPO0KEgYvjUp0m4IGo89tAP9m3++lbtJAWOt2OAnJv75Bi6nu6VgPhEQ+Q0EiYgVzslmr6mxOoeQOsbolMvtJUCa2OavguZWx0TB2iYYOsZW9y1/sdZ3+Jh6coG+6FYi7XSp3HGdIFO+P69YLD6UGKKt+yJOXNPLWANERwBaW0VAFqWL5fSZwKV3N3uDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPp8Tc5o958at93hIiyc4I29AVhusfEQyWU5KGxFcNg=;
 b=EffuHBm1xJgKh8gb/tCRUkePQDjBrh1w42qL8Kowrfa8s56cxZpW+oBHG0OY26JGlM/kymw/c/aZfouX8LpSCI8Yjbdk3HQabfnTDrZoEYc0fePWL46Q0CxtmKL8tIY6f8ZPvJeAE7jouTnhG6Gmeg2ehZfiYphIEmfec7XStO1YNpySmtgd2Ql8cW5/JFeCSO7GxOR3oileQcjwucL2G9OAduZeDKkLxvcI1inqRKBpD0HPk3jZ1QDHWhotdZpw+0yvyb4MY6/imgC3Ik+5b0+0opLDBoSgR/+Ys/qw273xAyOWQkVthJYveLMyvOG46mxKGJaZ+bEn9epCtqYwLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPp8Tc5o958at93hIiyc4I29AVhusfEQyWU5KGxFcNg=;
 b=qJnKW461+kEN1X8SYnFDwVokpuDW0ghWHSdcFY0Stu1qS6v3w4bRmVsPPUFrmErL7iVzHnbp6zEEgBO7tso1z2fRw+2p8rnsKBZDPWIjJ9Dtsk7eGZOdGgjoWbleiFoxcmA5NM6rb/fiFUgb9AmSrMM9dcMrNaygCd4S9/Q/Ask=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:28 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:28 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 2/7] net: axienet: add missing memory barriers
Date:   Tue, 11 Jan 2022 15:13:53 -0600
Message-Id: <20220111211358.2699350-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fc4e2f5-b5f1-447e-22af-08d9d5475a4f
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB92187048C77D485799BB7644EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5oXCrwXgpw+/Y2ITpx1LF1M5WAzmtve8hHAMJgxy3w9z3ia3K9mbzE1ZY7/REmXtDf5LFu3AlXH3G5a+zpIU1t47WAcRuQB2ro7l7uRzhE4l3t3mpwRzx7NcKtwmFZML4UEKsmeJWoFVNaTPMRrepp+uuK+RgY5o99RJf/7R0DXIBIwthwvuGDvDWe3dhTlBOJ9/qUYKO+Fu3e5WFXKYSOBQBX7Hw481VGk0CCot5F9wPHyUS4p9X5O6ttc1CPqraOVTzaTwEzUlrpjY9HnmsN2/x2b0E4ipt8Zt/xy7n3NNAxI6YMXnU7+40E3mCQY+GR8mV4DazB6p16+RXkYIXYVcCcrmRGKZgRgA6LC/xltRoy07gC73CmE0+B+ur9CJDaxaevbkRv+7cergpnK/mWFX4jIaYYS2X5iSCehETeyxjLVLW6AuR1510RorGjqdrLYvW6kKJuX+0ZbaCqU9j4qNqHvnXDEyKEeaCJp4Wdf7YmDCQaD4GYWa6rn3Wu7SkrFG/8103K0CTQGWyMQCuPtzg4PBVNNlfrYIZjLQKcP/zxNfWV/64vXh7940ZGHtY42Try5RCYW7Uqm31P7eybHvdxbXT3SC18QTTsJ/+Azy2xG6TG2HvxTdTJZEaCp0q5cr2x77kwSHn9bdjFQQ3NLE9rJSyEdplIOzspN9pCEuCgWLOn6ka08X2LtodSLTyr/k+OQK7momQFH7oybBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hW32TeJolecs/mmLLi5OMRkI8btRl+H+NWMz+viK3NhA3UYH+CNTw4x2aT/b?=
 =?us-ascii?Q?nZdqlNgQdXaITTD60xHKwe9LZnRxRqNHDRR04RAgHYxjZlM73auzxP2nWtyc?=
 =?us-ascii?Q?OyFGUcRtvLACxMve27Ir41DoZ51YuQsnx+55dKcbekoRwNSe2di0SVYQZs/M?=
 =?us-ascii?Q?oI/PfMHmQP2t+3ndYadJLJjIY/YvxeEiBtPPGZcRJJkHF81cBhu9vXiYkiHj?=
 =?us-ascii?Q?cR1hzzgIAuMVQAQO+bUna/evy4Bq6ABRLnl6MXBD0NOxbKSCDuuiN2eEwfCx?=
 =?us-ascii?Q?y44aRP837/X9UVnY5q8ZO5+BYJxK9/MYrhy//jpGSfQC9SVPTGdFwO+OO8iu?=
 =?us-ascii?Q?mzeO1J4NHvgmNuLNLiLqpqHwOvauhWHyCS+Kssf5D2O0K4DRdTB3FsLELOzw?=
 =?us-ascii?Q?e9QPikdaV/gi0LRaLD9g8b4jCj0b/RNGspVx22N6YznWTVF7LGupdB45ssNl?=
 =?us-ascii?Q?kssIqLshEvSuDMgZagw2BUGKRTV4/2YozikRqca+upjCgikt5p8d6Fz0tO0S?=
 =?us-ascii?Q?Cu6yJoJId00NtfniVMx8krGP/1aZNf5ntK/c9Ymw4bDfz18LqOVZcQZveWDe?=
 =?us-ascii?Q?/N5j7kFPNcwgZUoaew7YUiSJUtHoOHPno9oi4sDSKWOmpn07jAhi/bC6XX4y?=
 =?us-ascii?Q?NTZ46RuQGAynVVIv+eQXrjDZksjTUfQmcnYPufUZC7BtR6N1dFl7qWiDGaUU?=
 =?us-ascii?Q?/VPYfaE/FxXvCx7BbGP+1JmVmG/eNNR2IbIZNWhnV2m/FfrvxRrsMcqcofpZ?=
 =?us-ascii?Q?Ro1Pr4t/e+pTNlZ8tlfsfSjJjPAM6idusSY+W+kl148nRpHWxWqPkCoXa4Jd?=
 =?us-ascii?Q?FveokoxpUc2c9kWuGwNGtjzKeozdYx7vnBgyRDQueU0c9bUldkf9BG/tF1EO?=
 =?us-ascii?Q?oGaLcaqiH7cQhLfq2ZiDqGiPiv04xxa5pBfI4j0xFNvVLNjkd99bLPr9KAbf?=
 =?us-ascii?Q?WGQ3UkeZZQqh6C1MBxFVL6SQa4TJtRhCdqmzI20Ckit/84+8CG+oGjKyV4zI?=
 =?us-ascii?Q?N0PKYKSQdlrs6UKtTmikDcBx/sUyyKFAH5MHFcvpYeztrlik2bd3qgD+lSqC?=
 =?us-ascii?Q?lRSuLXjt181NfAfY1YSlNFhn7PtEQBckiZMTqhrK+nG35Mgo2glEKdKoV+Ex?=
 =?us-ascii?Q?Apr/JDsGSas4lysjgyVFHIs7vBqy17RShEhkqI/NtehZs13/tZKrheoXbIdr?=
 =?us-ascii?Q?Y+CYVIMX13Imzh3//0TKXca7xKwWkzt5CdZmmwJHOilEd8LfZUWXk8DIjtxx?=
 =?us-ascii?Q?id7hoTvTBUxAINJJ+U8VS9/DAu3EzgHOjtIswkTRQOiT/3691c7bTN13NU2v?=
 =?us-ascii?Q?DYCpqEKfqSnZiLLAKcd3HXcUMpeWQCOoR8jQm9o/tiJ641fSGRaIFVlQsaEN?=
 =?us-ascii?Q?9RvFe04BDyJYxsCU//hTTEznekIPnNQgL0BfTUsBw6khnsAu7KGU0tuVLjAI?=
 =?us-ascii?Q?6kNZX4zJm2AkiKs8KB722Ab7gcT4IAOOgPc7jrMvzQaqPNihQvtMISh7qvkf?=
 =?us-ascii?Q?NjI+9BHBddwprKaWYJYHpYNAA/oFogU1tDOoLvtIl+JTD9brAEGPPuTkszZp?=
 =?us-ascii?Q?Eawo8muK0QW5h34rvbtR1BDuXB8IKWHFx3NAOrRLf69LC8YQkKoD+AcyqxU0?=
 =?us-ascii?Q?4fWEunApQ5L5Bm/nrdKKsPfkxfWWnC37woH+2V0rmFhT+zuTCQ25oy6gfDC7?=
 =?us-ascii?Q?cbQRXg=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc4e2f5-b5f1-447e-22af-08d9d5475a4f
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:28.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POIGZwB0dBT4auYH3z3e52nb7pyxTPwKBGMDWFI/chzMdY1QX/x1EJGk4hvROOkFkk4p2mcbrs7ZEO8j4NsRRsw1O8gxcVg019NN6gfSxZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: ZY9ugOZKPcPlUb-6EsTJ3qxeW3OXM5WB
X-Proofpoint-GUID: ZY9ugOZKPcPlUb-6EsTJ3qxeW3OXM5WB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=635 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
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
index f4ae035bed35..de8f85175a6c 100644
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

