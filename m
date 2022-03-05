Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3E4CE17A
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiCEAZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiCEAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:05 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF26AA1453
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:15 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224M4Hd0004102;
        Fri, 4 Mar 2022 19:23:45 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hw0xyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cx8fZvdg9Mk7XGnmwkwmURVV78SFkCPiqlIykVz7ewODXVSGywnb/q5F/mlUIHc/qFHU3WtqefgaUP4WmzLNvwpDDpfrdAc2t0j604LqbzQXb6n4P/Yhve3YREHJDkUa3f25AVXAoDkPGYpdTwWqPp4L695Sr7D6nrP9GCTgsePfi+sE13A9InHUkKGr7Tus7QB8xqHJ1vQlHaASasiiZJNZ1y+a3k5TzNVD/0uHwk5IewNEK0GMY3hquIl62kJqw8e6Cp0IdLGb/W7eJllUdo+YtoFTCrsJwOxwk7qc2dIJGiAdLPLBYw9zLBFB+TRatAEOtqZfkGZRSOEOJCwRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=OlvEzMp6xWlq+jGpsEFAi948UtN5T9gDayRgj+ljaYpqo+gpNJ2EMMeaUL2ao3Qc4XAACvkhE/0nNv4tR66nnCiVs3wmFBvopmgjGJAW6bd7MjQu7Y13GXatFyXzpKPrmsdkCXB5MXr9WA2e+9YYWzRTZmGYFdTH6kGkIl6MS5J+ccdc8D+/4kP8APpPSM26dW1Yah5kVCT/d2R81Sf5CN1Bf5EwYrTVeriAdLFkGaRJRh9zvUSvMKc+2sLbGnAMCxZuZXaV0tvn01T34SKRo3/J/AomsK8ix6o3pootkv4yoZLmiqViCOpqzU03lPGIBlHgbgMeH2BdNpCPQ3WLIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=kUnh+1Fbx2B4xv17cuMEyPzNwHUnZfVXIQ1M2A3sTiayb4uaCo0llDkVtUcKwH3ly9+JoJdg8vZ0VMJ4UWHyOgPzrMdYFu8/Ij/ZPgWoblXzqG5dNR9fGBmWg1ExPgB2xKOd5n4vfIN9LeidxzsBJ3tPpYAQagru/x4w3+7RhvU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 00:23:42 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:42 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 3/7] net: axienet: Clean up DMA start/stop and error handling
Date:   Fri,  4 Mar 2022 18:23:01 -0600
Message-Id: <20220305002305.1710462-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305002305.1710462-1-robert.hancock@calian.com>
References: <20220305002305.1710462-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6422c8a7-ed30-46aa-5ef0-08d9fe3e674c
X-MS-TrafficTypeDiagnostic: YQXPR01MB3701:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB37011C08B84E22B4DB8D8B01EC069@YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unwpeX4kOX0G+5xFyRF16zz53tTYiNRs7uIfS4UnoKJrQt3rFFhUO8bpxNSSRtwVjNyl/5y0+1vHxjv2v0sfb0WGOid+fusPOLngtxQlIIXQyavtPJ1cqNKH2F2OuqCcktxP70/xZA1fns2LcjLwxVSX2i9HKaekkRk6D7EC0Nvw8+TIZ20IhxZTofE3TAs7Ahgsg88kwn+4XbrOpDYqH8G0eZrGd3f6V2wUMrmEOjDtUjdB6Kwuzy2XIgyutQ369VYSH9/4vpLkILgaTawuqxymC3vombi70lqqscg0gdg5ODdJBBeVUDuSejdzSsfcdUzgOTy61SeZjYMCr/EmXut/93oNHwE9KOr8Rksoeei+QVm47kSXhCKxo+TdFdL51sM18SFkxq7KxdrmMLwUIqGnKtiATXLgxox3PjRMRMSnaF4/onsA4OwGLz9pYM1bpYlbQbgCPEajPAeaKj7EwEb1qZJPRlTjUNDjl8rjpC38rpl7RoMC97tORsNg0FtPg1k/5p4nfv8SA+WrLuO+HP7bZG11ARA0ZgDuNyq0C7qLK1hNAbyGus/JiuZo74We8kO3S9avKL0soTLcWCUxhAEpbgJfXnwx2xsOcnQQVur0cva1hc8Tg5ppcezuqYFr110BUbOYfDorgb39tbxyMW1uq4c8cZfQEjaqMW/0PNDub3IpUI0w5ecf9eEGJ6U/p0SKShBlq9i1pi0oSxt6sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(6512007)(5660300002)(52116002)(44832011)(6506007)(6916009)(30864003)(2906002)(83380400001)(186003)(26005)(107886003)(8936002)(36756003)(1076003)(316002)(6666004)(38350700002)(38100700002)(66946007)(66556008)(508600001)(8676002)(66476007)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wREy5unGbVyuv1vuZoqZwyakrWTiuBof+LYn5Q0MOMjMB/Uas8Q8xmSpCHJr?=
 =?us-ascii?Q?699D4Xr+dUj1L+TP7sNiLW8XsBkdx8XI9CXjpCWTOCdM9g98o8iUgCc3VztK?=
 =?us-ascii?Q?TbBZkSX7QtUqMyyvKFyrkuJilJBvcI57vXaVaN47hT4Ab1iiXo568jRvuPuh?=
 =?us-ascii?Q?86Kkx99YNS6l7CppY0IphMykVE+Gzd+ACGx0tYUP8cegGIm4Q+VT/7qHDEjR?=
 =?us-ascii?Q?Wkdm8DqqwOvfJwVLPqgDsu+g8AS9Tz1r0JEYt+un19BIH5CLTWBsrWJ0haoE?=
 =?us-ascii?Q?ngomRmPNI/GTFN7FyqjJ9AVc+Ucmku4BtcLyFEguPsYtaU4l5oRavU5JiVnm?=
 =?us-ascii?Q?UaWNXEctx+vrxaxCkYuOt9/bomajAl4eyOzx9BLlQLkgk4JxPQqXmAbUfB1m?=
 =?us-ascii?Q?7OpI8Xf1c4EjPjyFymWY9T74NWHDtrDiJNGEH+DWQAV+x5+PIt1DDs1QV0ly?=
 =?us-ascii?Q?DaJqt3swOYiOjw+9dEB+QBes54pPQ2ywv1DmVNbmo6vmyL78bcZLIR0HODck?=
 =?us-ascii?Q?KSsNJiKv1ZjjJ0UdubHgtpSTvDjnnuz+/6Y+V754eP5RfIp0lhL3QafQfSh6?=
 =?us-ascii?Q?66NfXR4wfeZ0KuGMg9l9Oa4kDIzgt3dfpm0SMWLVBxbLD9EmFcloAFB33+0J?=
 =?us-ascii?Q?xhkHhs4UK3gOhlttizT3Ulcok9Ps7KIyTJX3wvF7Jd/viAimjo+Vk2j3D/Ra?=
 =?us-ascii?Q?H0U8Y+SfBOOq98Q7FNOlH+Rz1JvLea2NJP+Xqj6ZUgvPZdAInZ4DAQqplhEg?=
 =?us-ascii?Q?KJsjoQ68PvQ0UeF+MtWMQQ21L5PKM3SekdJKsXciH605eRPUYOfwt14Hl87w?=
 =?us-ascii?Q?FkZnZKD0qqzovmMB/BbaTJDVCjQPuPmQk5BH9jZ47z4HR8mAiAhgIGWxq2Jq?=
 =?us-ascii?Q?cLvLLYGRli3dCuPymVHeke3e5i2J3Vh/7DdHqzDec5vxO2p1X7PhhV87pGCr?=
 =?us-ascii?Q?usEiME/A8X4nqnXThTD1y2zRYLZk0Zv0JYA/uu7A6gKMSoTUPuVUbXFXj5N6?=
 =?us-ascii?Q?ZWfiEengI+SzSUe5oyKX7d29MCJdf/62ri4ZNoD9W5b7A8CUNQrJHhP8TTDK?=
 =?us-ascii?Q?ZsBqvHGooFgn7gxTK4FhOS0da11syEhZridDt8yTC7EZsCm7kQyFijqkMnZ1?=
 =?us-ascii?Q?TfzUawSJJpjfcqLASOQIvUtXm4b3N67pqjlk68EstVKlgLfjKYYSly35dQKA?=
 =?us-ascii?Q?PM7o25jTwpgJNwpJGIbs5I5z0PZaoP30SDkASidD5ZWlRBgX42qAvcIbtLVO?=
 =?us-ascii?Q?pOMZmvaAjjg4RdETanawBYniuYLaT1R1uP8hJa80fjY2Cf1PQKDA9D2QgSjC?=
 =?us-ascii?Q?r8ZK1Cu4RZf5NTKOvgj6mXBUe7nzv2cFxGeYdcqCefVwn0f/8Qg6OLd1LkOM?=
 =?us-ascii?Q?L+k/r221+kPrVgHiXjhATApkiZ9s+0k3SYEI/ztiVTibAN/TVWReVcG51irI?=
 =?us-ascii?Q?tEMQMfVzqFxQMNd4cbVVY+Fl892vWn+j54SYf8ICEPoh5mI+uGohYLrJDuST?=
 =?us-ascii?Q?yHfUGU829RCN5LGgcn/nLaUF4OhhYujARTMlrzzuDLsEeEmPzkb2aoBgtjSb?=
 =?us-ascii?Q?6jTQqE0w1PPWJ7Rm+JI8z1tjmSrt1CBx0GKgfClpU+jN2kpS2q/p2AL2wb0h?=
 =?us-ascii?Q?+ykrgwdmbxFPU8c0yvx4y4CGQrMV7HYX5bEjlIGXLrOVsO7Jjpv9iQ3TwWsf?=
 =?us-ascii?Q?LbnSKB/dY1IzbCjVQqPGofvvGOA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6422c8a7-ed30-46aa-5ef0-08d9fe3e674c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:42.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUum9s9eTNCvl2O09WfRp5hOAA0eCVHMw18QsH8RdwLH6QFowfJY2zGaqZ0DiZRbFf1h2L0XCDn511v/04XNAH9SZFZDJvALkgcoEds/sPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3701
X-Proofpoint-GUID: X31M7-WDdr-J1YXXkjRvOdrMh_TdKPwG
X-Proofpoint-ORIG-GUID: X31M7-WDdr-J1YXXkjRvOdrMh_TdKPwG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the DMA error handling process, and remove some duplicated code
between the DMA error handling and the stop function.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 280 +++++++-----------
 1 file changed, 105 insertions(+), 175 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5a1ffdf9d8f7..d705b62c3958 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -226,6 +226,44 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			  lp->rx_bd_p);
 }
 
+/**
+ * axienet_dma_start - Set up DMA registers and start DMA operation
+ * @lp:		Pointer to the axienet_local structure
+ */
+static void axienet_dma_start(struct axienet_local *lp)
+{
+	u32 rx_cr, tx_cr;
+
+	/* Start updating the Rx channel control register */
+	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
+		(XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		XAXIDMA_IRQ_ALL_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+
+	/* Start updating the Tx channel control register */
+	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
+		(XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		XAXIDMA_IRQ_ALL_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+
+	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
+	 * halted state. This will make the Rx side ready for reception.
+	 */
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	rx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+
+	/* Write to the RS (Run-stop) bit in the Tx channel control register.
+	 * Tx channel is now ready to run. But only after we write to the
+	 * tail pointer register that the Tx channel will start transmitting.
+	 */
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	tx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+}
+
 /**
  * axienet_dma_bd_init - Setup buffer descriptor rings for Axi DMA
  * @ndev:	Pointer to the net_device structure
@@ -238,7 +276,6 @@ static void axienet_dma_bd_release(struct net_device *ndev)
  */
 static int axienet_dma_bd_init(struct net_device *ndev)
 {
-	u32 cr;
 	int i;
 	struct sk_buff *skb;
 	struct axienet_local *lp = netdev_priv(ndev);
@@ -296,50 +333,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
 
-	/* Start updating the Rx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = ((cr & ~XAXIDMA_COALESCE_MASK) |
-	      ((lp->coalesce_count_rx) << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = ((cr & ~XAXIDMA_DELAY_MASK) |
-	      (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Write to the Rx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	/* Start updating the Tx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = (((cr & ~XAXIDMA_COALESCE_MASK)) |
-	      ((lp->coalesce_count_tx) << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = (((cr & ~XAXIDMA_DELAY_MASK)) |
-	      (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Write to the Tx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-	 * halted state. This will make the Rx side ready for reception.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
-
-	/* Write to the RS (Run-stop) bit in the Tx channel control register.
-	 * Tx channel is now ready to run. But only after we write to the
-	 * tail pointer register that the Tx channel will start transmitting.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
+	axienet_dma_start(lp);
 
 	return 0;
 out:
@@ -530,6 +524,44 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	return 0;
 }
 
+/**
+ * axienet_dma_stop - Stop DMA operation
+ * @lp:		Pointer to the axienet_local structure
+ */
+static void axienet_dma_stop(struct axienet_local *lp)
+{
+	int count;
+	u32 cr, sr;
+
+	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+	synchronize_irq(lp->rx_irq);
+
+	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+	synchronize_irq(lp->tx_irq);
+
+	/* Give DMAs a chance to halt gracefully */
+	sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	}
+
+	sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	}
+
+	/* Do a reset to ensure DMA is really stopped */
+	axienet_lock_mii(lp);
+	__axienet_device_reset(lp);
+	axienet_unlock_mii(lp);
+}
+
 /**
  * axienet_device_reset - Reset and initialize the Axi Ethernet hardware.
  * @ndev:	Pointer to the net_device structure
@@ -949,41 +981,27 @@ static void axienet_recv(struct net_device *ndev)
  */
 static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 {
-	u32 cr;
 	unsigned int status;
 	struct net_device *ndev = _ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	status = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
-		axienet_start_xmit_done(lp->ndev);
-		goto out;
-	}
+
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
 		return IRQ_NONE;
-	if (status & XAXIDMA_IRQ_ERROR_MASK) {
-		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
-			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
-			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Write to the Tx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Write to the Rx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
+	axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
+
+	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
+		netdev_err(ndev, "DMA Tx error 0x%x\n", status);
+		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
+			   (lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
+			   (lp->tx_bd_v[lp->tx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
+	} else {
+		axienet_start_xmit_done(lp->ndev);
 	}
-out:
+
 	return IRQ_HANDLED;
 }
 
@@ -999,41 +1017,27 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  */
 static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 {
-	u32 cr;
 	unsigned int status;
 	struct net_device *ndev = _ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	status = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
-		axienet_recv(lp->ndev);
-		goto out;
-	}
+
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
 		return IRQ_NONE;
-	if (status & XAXIDMA_IRQ_ERROR_MASK) {
-		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
-			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
-			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Finally write to the Tx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* write to the Rx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
+	axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
+
+	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
+		netdev_err(ndev, "DMA Rx error 0x%x\n", status);
+		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
+			   (lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
+			   (lp->rx_bd_v[lp->rx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
+	} else {
+		axienet_recv(lp->ndev);
 	}
-out:
+
 	return IRQ_HANDLED;
 }
 
@@ -1151,8 +1155,6 @@ static int axienet_open(struct net_device *ndev)
  */
 static int axienet_stop(struct net_device *ndev)
 {
-	u32 cr, sr;
-	int count;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
@@ -1163,34 +1165,10 @@ static int axienet_stop(struct net_device *ndev)
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+	axienet_dma_stop(lp);
 
 	axienet_iow(lp, XAE_IE_OFFSET, 0);
 
-	/* Give DMAs a chance to halt gracefully */
-	sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
-		msleep(20);
-		sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	}
-
-	sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
-		msleep(20);
-		sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	}
-
-	/* Do a reset to ensure DMA is really stopped */
-	axienet_lock_mii(lp);
-	__axienet_device_reset(lp);
-	axienet_unlock_mii(lp);
-
 	cancel_work_sync(&lp->dma_err_task);
 
 	if (lp->eth_irq > 0)
@@ -1709,22 +1687,17 @@ static const struct phylink_mac_ops axienet_phylink_ops = {
  */
 static void axienet_dma_err_handler(struct work_struct *work)
 {
+	u32 i;
 	u32 axienet_status;
-	u32 cr, i;
+	struct axidma_bd *cur_p;
 	struct axienet_local *lp = container_of(work, struct axienet_local,
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
-	struct axidma_bd *cur_p;
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	/* When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting.
-	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
-	 */
-	axienet_lock_mii(lp);
-	__axienet_device_reset(lp);
-	axienet_unlock_mii(lp);
+
+	axienet_dma_stop(lp);
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
@@ -1764,50 +1737,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
 
-	/* Start updating the Rx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = ((cr & ~XAXIDMA_COALESCE_MASK) |
-	      (XAXIDMA_DFT_RX_THRESHOLD << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = ((cr & ~XAXIDMA_DELAY_MASK) |
-	      (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Finally write to the Rx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	/* Start updating the Tx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = (((cr & ~XAXIDMA_COALESCE_MASK)) |
-	      (XAXIDMA_DFT_TX_THRESHOLD << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = (((cr & ~XAXIDMA_DELAY_MASK)) |
-	      (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Finally write to the Tx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-	 * halted state. This will make the Rx side ready for reception.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
-
-	/* Write to the RS (Run-stop) bit in the Tx channel control register.
-	 * Tx channel is now ready to run. But only after we write to the
-	 * tail pointer register that the Tx channel will start transmitting
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
+	axienet_dma_start(lp);
 
 	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
 	axienet_status &= ~XAE_RCW1_RX_MASK;
-- 
2.31.1

