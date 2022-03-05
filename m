Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4DE4CE177
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiCEAZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiCEAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:03 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92997EA04
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:14 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2250NPGj018659;
        Fri, 4 Mar 2022 19:23:42 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8phd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKEFQB1Edc7K3LI4f2LmbbDCPF0smOtHNGqdTXS5uCA93gtoVsysyVRmo9D4chZmPGMRMmDi8vZn4i2tL7u9V67PpjX5dTA7aQTegzcuvYLMJm+xycj8vsd06MlUX2UcYFDzKUhSWhznRjzWuLTVJ3uBWaAzEsjWtWapwgWC5OS5PHHE2lPEXmN4+jE+SB3pfM6gq2hpY7qRtgJL3u9nq/hUHQR5Sv4Ylnch9aQymHRtTxfq9avHzxZi+9P3zbO0prcyZMMLzm9OVPloIVVVYHWMdjJXw/5wnljb5xPqeWY/ZZMFRmN7tHpFgkmrP6+DR0CWrz/9ZTm6RpcQYTLiFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=NFSX+hQSmdD9cJEYaIa+tInaKZGl+Zy1t/mPTJS1ZCmTV/nAk1+ax79QgzofK03/UrocHfdDDGym/oxSCTXS6N/Qtm0OJfzgj1OqrJJFpvF1AsYVJoO3elL2hZn7PMbPfgaCdVmBc+Y3N9TcUObcIGYzwVY+sTgCSB1EVr3WORpVs/m2mpDstW0a7oxIH4SVJDFW7zNp2EnGmo1oGekt1Y5wHkF32yCFST3HsdeN3SaONDdj1g/M32q8zLBEu1u6eLtuVQGWl2z+dd5Ut21hLBRSYTG8q7YzYDfeugWbyVQK2M/17KdLNJOmElPfKBRW0VtU1um4flgcJeDESjRtww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=u1Nf/026ppBYD7HAIL0gHpfE0irMu25+GeoIkm8swTb3SkYUpwJgwr7TzIJkKfG4u9kM/9t92Uhr2QRf7Ex6rHZkgDthpSmBMD/4WSDl28lJpzJRvXvuQrQttRvljjEdDfEVQJW+igkIOQAqDyLf7cVIvilVPDudBuwiWU4Ch+w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sat, 5 Mar
 2022 00:23:40 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:40 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/7] net: axienet: Clean up device used for DMA calls
Date:   Fri,  4 Mar 2022 18:23:00 -0600
Message-Id: <20220305002305.1710462-3-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 22552214-4ea5-47b3-3e0f-08d9fe3e6654
X-MS-TrafficTypeDiagnostic: YQXPR01MB2758:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB275884A4E8E1505506A1DBD5EC069@YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gydTeFr53bvivkTa2ciB2dWTV0v73H0nFYU75E+sse7XdqvFFPBBnZX2BARqLdFWXBcT0gi5MD8K+3Lp+ZfaadFnfXI8LJL4KZmX/o9ug+q+wTTisPURh20s1VPBzUX3JVGoSzJomIi8TW/gNT/kyhmFZtGmuewRrXdZR0HNSZWVdPvbDp6VADHaIxFnkHvgaP8hcnmtGL/T7x76VqiSOMCczGlbPQnlCUFyy9cFCM6h7oaeK2O8kWZOSP46nAbbHXBmTmznV+3IOBVb51T5FH67BolWQmvb4wXvqd1zY3+S9XBqCWyF/JgHUitBtD84r4XjcYoFf41fHGm3mWbvQfHmx1fG1iYao89/WBh4wjk1dYxJ6E/JAEyMcwislpjJ4tGCIGSp7Pljg1tE3iGKvpt5K46/Z47Ci78KsomgPR/v8HQwDFLAs46stQSFPe3LBBs4Xe0ky/pfK+6FhZKmuF+cmWCGPUBaF6sIFRRfwUwyFUf2iMTFFpO8AROOZ5JIZb1f9wxKFlHe85AUIojuJ7uPZZqOs9/BqvLAaTKuM80rFzfr9QUQyaszlFcSuuySyJRwehAAOyqPGwylBy7TRgSd6XaTKBOXlBOlVHr4Q2ht/W5fgvVJ4ARA/kHvKpUWnx0Xe6ZdqImgMdsRXH6lw/oLJmLhEhLyY02F3p+azD1D/HItYIngP01sUoH3kFtX0lkQgtalVqZl+WChCnOB5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6486002)(107886003)(6666004)(1076003)(8936002)(86362001)(8676002)(4326008)(508600001)(66946007)(66556008)(66476007)(38100700002)(38350700002)(83380400001)(6916009)(2616005)(6506007)(52116002)(2906002)(6512007)(316002)(44832011)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tP16FFzq+P8+l8ukt24zRcmcij/q14/79mC4iuz4fGF/mytAmM8Scp1hzaNP?=
 =?us-ascii?Q?1w2YumTP11uiAwdZCqTCOE/uPb9ZsamLoHeHn7W/Jerq5Jhqc/UahbM9MHy3?=
 =?us-ascii?Q?l90cK9wnUT2YyNn9+TgBXiz0a1NrUjiBZjt1FScYMYJeeu2TQtloJ72E3yto?=
 =?us-ascii?Q?Icq4AB9dzQCCqPHNDgJIYuKIDNkkfI5Z40WfbuTt8n2y4NKAom/1/WE2oWcR?=
 =?us-ascii?Q?7aKDN5ehVI8ZZW7mIy/xwaYw1/qTB7vs5XiBxEpfZVEQHI6FYeyKycbXHoRw?=
 =?us-ascii?Q?CggfVXQUjvkf0dZfAa2kI09RSIDnq9tTgUpWppD/wqk8XKRDy7NlDSlfWAP6?=
 =?us-ascii?Q?BRSmYuFySf5YYyMBhECNxeVPb0DbCJX5J+UbY5rsnhizIHspJUOjuMVD3qLN?=
 =?us-ascii?Q?p/xcdQdqSwfXeEFNfD3u+3Ztrwp0q4gyQthb420aocp+SF842NCt75w7hPf5?=
 =?us-ascii?Q?Jr7d+PAYoRD4Wx1URJvFivQfCGXEAQkR4HKhBZRmZZiYMHPxp4qSee2nOv/P?=
 =?us-ascii?Q?V/1CsKhbIwUDZr5wZyUlPyhmfx/JTAekuduYNwjGy3Yz3gfAG+2GUbJyc5XG?=
 =?us-ascii?Q?BwhkADLNts1eJjC0687f790xE2CWVgO2Iev7bX3/0Kfe3Gx8Oe0LoGl/ky8C?=
 =?us-ascii?Q?fctajntBVmxvLRXq8cF9BgYT1DMo81ViQQ0PHe6hkhR0a/p7umQeCZwROvMX?=
 =?us-ascii?Q?HlkMKLcsg1IlMEXmtStVWMvwsYVM3hbDerS3qOA9TNcFTypEHL23X2R9kv3e?=
 =?us-ascii?Q?ikynIvcPqchAoNmRXpomUuE66TPXmmrLETMel3cKnReQsUKgrUouZ4owz7FJ?=
 =?us-ascii?Q?/ZUtrJVBZgjiwJcqbu9VmXW/9I3ZEn9vWsgruZ85E7Nc+qToeqU03cl+SbJW?=
 =?us-ascii?Q?FBcuzRH80csegcpaNnInHiQ3aDWJCIExwrSxHFOLKO7+3ESzKqZdPaFOYbKN?=
 =?us-ascii?Q?TFzFh1V6Gk3OKAbN1BeUI/ks9O9qCvt11pzJ2mzn0X8vBUrmxvn/HcSjfyuX?=
 =?us-ascii?Q?DqraBrWRPI3XKaDTsI2blvGEu111rQ0XI8qrlfGzFJjTSBOSONs7pn3cM2DS?=
 =?us-ascii?Q?vXT4Fuis7T2mu4/Zkft3INOh6H9BpB/uekiPaZxCkvlGHuW+eLJXtIVIqxf/?=
 =?us-ascii?Q?aELLAlGvbrh0wAxA/aWXQcfULMHk6P7GdhapPfa4gQFINOsykA9VN6iyVZj3?=
 =?us-ascii?Q?/h+xP3GH84LxCmZU1r6nR5Z4y04j7DiOTXqfb0ZbPS7ZQy0r7XuA2VvJXP5T?=
 =?us-ascii?Q?xBrBAffoELonDQ3C0m3BCSzv0YvrRmkRZN51U/5BzfeEC270m/ByE01y5/41?=
 =?us-ascii?Q?hIvlwq21yAwg9OYkqHy69TEKJlgoR8DtGmZkQBc2b28+RP1Ep/n1rccv5aJ9?=
 =?us-ascii?Q?0wiclkUhpSkZhDyZGkxVSE5QeNc2shSgCJ9gFPgx3r6ODyAN++gNY0wum+RL?=
 =?us-ascii?Q?pyOz4LV2AxK4TSLnkkdZwBnx+JqlWtz2Ymstm4yXuwcc2dIpy24kvSu9btk5?=
 =?us-ascii?Q?VgCeGAHg0IEpL9wJhTC9t5H5RF+wG4asTjzqnkXxAPYhXzUSxIa5OyrUW6VG?=
 =?us-ascii?Q?ZY3clJpOUo4vB9PlBeSqqgaR5JpTIoMVs7Y9u+neogtp9PcYeB51A4J/le+t?=
 =?us-ascii?Q?JkS8nfDKciXU937ERNNfy9F8HwJfPk7hb9hU4ZLV6ZxUiyGccbNu4/Pxl1Wk?=
 =?us-ascii?Q?CKGPN3U97HA5jMK2GqYwHYuM3uQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22552214-4ea5-47b3-3e0f-08d9fe3e6654
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:40.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlSGyn0yx9Jz8dgUWOd/iXhzvHen8Vk+yDWllAePsBvtRZlqg2vWLz8ID09AVSB+zPP425hLocYwRaBzkX/Xb1eYnGr2wqXtgVBbbFZKWxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB2758
X-Proofpoint-ORIG-GUID: ee6k4DxvQw54m-MpEzj3FC7RGWArZ5WE
X-Proofpoint-GUID: ee6k4DxvQw54m-MpEzj3FC7RGWArZ5WE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=756 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using lp->ndev.parent to find the correct device to use for
DMA API calls, just use the dev attribute in the device structure.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3457a7f13747..5a1ffdf9d8f7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -190,7 +190,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 			  lp->tx_bd_v,
 			  lp->tx_bd_p);
@@ -215,12 +215,12 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 */
 		if (lp->rx_bd_v[i].cntrl) {
 			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(ndev->dev.parent, phys,
+			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
 	}
 
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 			  lp->rx_bd_v,
 			  lp->rx_bd_p);
@@ -249,13 +249,13 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	lp->rx_bd_ci = 0;
 
 	/* Allocate the Tx and Rx buffer descriptors. */
-	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->tx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
 		return -ENOMEM;
 
-	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->rx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 					 &lp->rx_bd_p, GFP_KERNEL);
 	if (!lp->rx_bd_v)
@@ -285,9 +285,9 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		addr = dma_map_single(ndev->dev.parent, skb->data,
+		addr = dma_map_single(lp->dev, skb->data,
 				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, addr)) {
+		if (dma_mapping_error(lp->dev, addr)) {
 			netdev_err(ndev, "DMA mapping error\n");
 			goto out;
 		}
@@ -636,7 +636,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys,
+		dma_unmap_single(lp->dev, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				 DMA_TO_DEVICE);
 
@@ -774,9 +774,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	phys = dma_map_single(ndev->dev.parent, skb->data,
+	phys = dma_map_single(lp->dev, skb->data,
 			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+	if (unlikely(dma_mapping_error(lp->dev, phys))) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
@@ -790,11 +790,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(ndev->dev.parent,
+		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
 				      skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -872,7 +872,7 @@ static void axienet_recv(struct net_device *ndev)
 			length = cur_p->app4 & 0x0000FFFF;
 
 			phys = desc_get_phys_addr(lp, cur_p);
-			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+			dma_unmap_single(lp->dev, phys, lp->max_frm_size,
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
@@ -905,10 +905,10 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			break;
 
-		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+		phys = dma_map_single(lp->dev, new_skb->data,
 				      lp->max_frm_size,
 				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
@@ -1731,7 +1731,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 		if (cur_p->cntrl) {
 			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
 
-			dma_unmap_single(ndev->dev.parent, addr,
+			dma_unmap_single(lp->dev, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-- 
2.31.1

