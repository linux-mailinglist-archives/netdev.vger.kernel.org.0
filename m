Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBD4CE23D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiCEC0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiCEC0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:10 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813EF22C889
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:20 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22524FEl004428;
        Fri, 4 Mar 2022 21:25:00 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:25:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC3PtFfDVZIISjsVQCCaPH8DKVr6gzPdJviXtMhCqT52kGHVUkgJml63m8zGjqmaiagMFrWofBGoNu+31yPBCUWyd7eDbiB97Vh1Ab0W3pyb7kUfwPle1k8bmVZUjuzbCkuluJSCfGpq97QvJ09QabXqxkqqhlEXvpYbGVqMJZyPDFF7pwHBbcLB7UqVzWEyzazwOIzpe5LpJE/L1mKXDsnWLrReLS+WmyWcNVPcUs8pJjOu1yJYpW7nwEHztXsYHcsxQ95NPvP3NTnqlRPIEq+JBFQsrKImNCKgkEQcupZ4Bsgv8b8Ezv/xvfDhrYp1jpEBUM8jH4lvzjWdQc0IzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=LnnMEPvJaYH9JTpetvZ8vOU+oUzs/n9ekL9ugq379A29XWYONWbKQ99jHU6tDdooK/M/96IPC4COWinyHPDdD+f5jjT1RkBelW2mdPOpPVYa4U2ITUI3eKjqhupku5ZbD8V9MH3+k+kDf3/lCY0K0t62VKyrkrBoekOOzx2m58Mq11H223zQqMfPR2iP0p6gy+peiKZZQHc2Wzqeria0naktiAexSrGfnU3epj6bYp8SA5tFNJYxYV7n2Kz+Ztxt6usmZPCJIoC8dQ7TJoa1YCjvSAEL+RAa/Yi5iRTDz49ZtRW9R8estRv2dHSllQzuj9rOBQM9fsfLlF5vzL8IwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=UBWTN8WsEdi245hZyJAG+TTVAFuLS5etL4s/pe9sO77uP8uUDc+OgTi0z69NMMcCtnetThNz+Yt4P9Fc8SdaCfhniQPk2U8+oD+Iot/Ln8koXECaiJ++NTMFXZCqWgvdh7hmHGM/LyC7iE9Zd1+L8diFuqFgI5UIS5M0i2nEY+s=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:24:58 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:24:58 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 3/7] net: axienet: Clean up DMA start/stop and error handling
Date:   Fri,  4 Mar 2022 20:24:39 -0600
Message-Id: <20220305022443.2708763-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979bc3e3-edaf-48f9-1afa-08d9fe4f584f
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184F80F7C5C7B34E98CC95FEC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t3hWUor4ca4bbvF/vCj1W2/pu8Dn8wab23mHu//tN5oLXlAEkbHgLspXodZhrteUpPJCZGkiaeE5rRSxzYXpFyRCfwv/+qruqAubz3Ive6gIwENlNP2hhOXaRG/jq58KKfAMeo3u7dbE9O48EMi3/4cotzlUsxQtWrx8Mv6h5W6dkrLLAyopMdRDaElf1S+aA5G1RgryGbvyLVpcbzAdBPkPck2s/1Ye2e6zLNb03/KW/d0r9pfTdl2uVhnwwfsQRQ5yehDyHJ+mCRafpvlxOZmVO5uoTeXq3Di5yJ1FAktkr9wdAUafCCwxVdDZ7GkCq7gDNc2ewGf459eEKrXuyG30EsQI86YP3Xjf0T7XzR73hD6FDgknfh3GWA4l0eEwcS2BRTleFC06aqSXq8SErczAj3nCjkVJBrKwONd47LxOnaYjxzAsbE+R1duIdiMLuxZ7/nTrwl8e6Sv+VSDv4e7qUzD0R/irv5Ne30PR9OG8aQgHBNMWBztkJz0VcCathlYE4AtPyby1PBEs/4V0S3Ps/ESlpdUQRqaW10Jb0P6Iy0Kn9L57JlSzfsyhcNmJ9hAAM28xyXTGaGVF8ZibqZBgsmJierh6jspeG+zWU1h5yYdIRj9QMP7lWu4njBxjUFLneWEcKD9rE0nnCfDasbzXtfSQyaUIrC+s67GMHY+YgUil7tQq9GuU2O7v4iGSdbpnlai1p8zUzVMavrUVfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(30864003)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0A/JQD9KDuPiIgZzqUU3Dv4OssL+np9JCYQc4NhmHsDIFe9CMl6XL2EoBOq5?=
 =?us-ascii?Q?edOAurgWDQFNqWTPylrsrX5KnBYg3X+3egQnjvYptXu0c8ayAnBdBQ7GmObT?=
 =?us-ascii?Q?9OIMqAMIVB0ozZdA5Ji8hybYHNffgqg65dtT7PC54xWvzGFRUw8JshfK/xvB?=
 =?us-ascii?Q?4Unv1H9zcHZpA3vaUfbItLxGGLPEx9M/CMCTOGsXctCPcRdjBsSnKf0HWRyC?=
 =?us-ascii?Q?bipgP3Un02QvUEMA/LWJ62NuzGnQTP/aHx5cHHjaF9RHOTFlEHBg5lP+5zd9?=
 =?us-ascii?Q?d3tivhkBsQC2CEkLgwqBZQHW7sSBHK1JT36O1I6bwVSdDxSBtiTm2Z0OMtWs?=
 =?us-ascii?Q?Cn0wsTUwtwqh4Fma1p/G/9nlx/i7Ln/E/GIufTVMn9n7V+rgbVpz2pgSbd7p?=
 =?us-ascii?Q?P8gUCFroH+YPJsdooMeZO4VzbscYZRRg97qSAWFzkCHHrvPtcx/wDYnyctS6?=
 =?us-ascii?Q?XzAHwid4ZmEV6tZ4myJerfmsGoAASn6LkxoQHp/uBlkEzCDtMpLlT4R6ozcQ?=
 =?us-ascii?Q?Ix2+v5YiSbeSXcovmXCHvZzB2Neb4qSr0AYRVSmou++HViwl46B8HuOTrCZB?=
 =?us-ascii?Q?QA8wt3Hq2JoPIXLfaju9doSyouA8GtUWWOcK3z4OS1FunM1aHOL3LGOTEkcp?=
 =?us-ascii?Q?i+3pXJnNo7GjxifjNohoSo5v67mUGAMeBa+B3j0Jf0nf9PA9gFDM10D7p1F0?=
 =?us-ascii?Q?U8f4hu72QpMYkltM/+aNjLQJZtwkxSqWOnvJRrYoxlZNkE4TuQ0bN1AhXWmw?=
 =?us-ascii?Q?EyZN7PhsdOUvQ3k7B2JOaDXSwR5sCFOgvcGNAGZEDpFRqCxHOUe7BNdDBJ32?=
 =?us-ascii?Q?VcwDcer8ujHT/Aw6aU6dAN2iOMqUJWLwa+F+HEEBkKysuucd54Zm1xBl7RXr?=
 =?us-ascii?Q?BvZSgfsCb7SIF4uOD+4EKzP/qtgxS4Y60c/Yg0UL0GKfS/JPCO5w25EyZLT7?=
 =?us-ascii?Q?2Z6UY8EQi7Z38h0IzlBwUn79Z1L6s898mvnrBks0wPL43FAGFJrf13b5Z95q?=
 =?us-ascii?Q?m04jegmRe9yxI70FDPvkXg0MbnBj3Hfy4Hkp4h0qwRLsG3xwCA8rv01jEBXi?=
 =?us-ascii?Q?O4LDi5XrbIhJ8NglkskvbeEHijqIGlm1HE1+pzFjQUv/q7fZzJBcNVCmfKHr?=
 =?us-ascii?Q?H/dwf/45DbponjI/ThZSPNj3VNcJK7F4ZjBVtNsw/lNJYv/x8PG8LG4HmzQb?=
 =?us-ascii?Q?dwYmCwKGAFgj8efHqxwrZpBe3sy7csZFS4eM/pf8PBOjUHTUQcnMaGn4q4D/?=
 =?us-ascii?Q?S4trTqDTTZ8UG9uWX+4PFPLzSS/huvN7dzcfAVqdVM94v/6A19UhyFoQ5dMd?=
 =?us-ascii?Q?wCtkL7vS3oC9odEJIQxCv4Iyk8UD9XYMHjXff+ZbmLKuVTFPQB88BlWGvt4X?=
 =?us-ascii?Q?mFcza9D/lJhAYxGnwnTVzHjvNWUfKvCdcvhaGGYoKnM5WhZ/aWwL5EwGzZBc?=
 =?us-ascii?Q?DMElEr0dJ/NKB0fcxqGnuBBHWpY/95DIv2zpLmiCV8yZwANpTt0joZf8PGXN?=
 =?us-ascii?Q?j0QNNSS92PBrAHg+q6ZZiiS6QlCGigEzjUVggpqPwyiOprK5sNTDLjQMFzyi?=
 =?us-ascii?Q?fwIULI5rVh9dmFQ7CQRioD6jLIuOjKNuI4+8+j1egXhUTXWgq3FaEkQ30KvG?=
 =?us-ascii?Q?TCH9kTVRD4KT2qsI2pebDhZ7+r5yh6tHSpL85jB0D1SwfVH6ngwwmoDov+Wx?=
 =?us-ascii?Q?8Nh5LEQgNdhrc9FeM7BXeWuc3rI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979bc3e3-edaf-48f9-1afa-08d9fe4f584f
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:24:58.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmHh7Z/SXBaLcPf6tsh8JuXLww3YitCt/qx+9+U3tO1FY2FGx0elB84uC+6PeP/MbPzOHKxw5ifweqeD1vBGviZ+Wb4LpL2ayGQQ5osDJ4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: tzWceT-HM_rcVZ3vN4MGYjfbeC0vBNDo
X-Proofpoint-GUID: tzWceT-HM_rcVZ3vN4MGYjfbeC0vBNDo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
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

