Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A794CE055
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiCDWoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiCDWo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:26 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DC606ED
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:37 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224MaIDf005553;
        Fri, 4 Mar 2022 17:43:03 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktMTPXs4b/w57CRcUn4QxQqHSPV7juWdkd4gp40lCi6P4xeA+eaWyJVgwQKm68cMvzdhANl7G21nN+CILwxPeE6OMl5qbndUyAfjrSK2vcbzLDbopFPvMPlIcsRO2eCTuc031QUJuJwqLd7yLrk+Ugz0DxwDfEzo2cHn9jq7Y8B5ZOgPuqzz6E0dFR0lKnQWVlBlxP2aKg9rUGj6CAKD2NA34lClXlUVGczCaJ0h4qpe6a8hz8E6sdRD69ppw1lXcXMC5glOHmwoLt4BZl7BeN7NH6dqSKqhuCfavKZyGzjP2zLGv+wzkkTpF/JWJb8qL5XOMQzzK7Jc7tZ6n+LPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=VG8f8aQOWmyu4a72eqzjN28Qm6TYHnYGg308a+Y9UJ++mUwG1zfl2RjTVlo3W6pjBBd+6AMEwFxAHiMeYHKm8IsFEZ15TZ/XuwCbcd7YlkW9NrU+c2yeMzCwQyKi9jsvhfzly0wZ3uvaqUQeUqlf5CSdlQeXk7nKe1XoFbQKe18V62d2UkyvJbWawyFGhNT2N9Wilq987x05RGLPcAzmvX820j4d2NrOB+E8ELE0/uLdxAVv5pTV4F+CUJTvCj7pyQHk//3cGvNDIT0xz2FQGMTdmLAz5JPaWMlspWKlgUYL8+eVGP/06Vh+hP0l6sqrxS6uzKHrO9rPXYz1jD/L5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=bwsgA1H+N1H03HkmZQR1QtsZCsqAnphmETlHpAQdMExkpN+EGq4MKRHJd8C0tPVt8PWu2j/8KyiB7kLj5u8orO2TVWTmNAA3aWwX3jR7tT2U953SPdPlt2k3smFq2oaqzP0vJNDU8Jzl8IEsdJaM7dyPo/SGNZOJOviyNvXeO3w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:02 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:02 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/7] net: axienet: Clean up device used for DMA calls
Date:   Fri,  4 Mar 2022 16:42:00 -0600
Message-Id: <20220304224205.3198029-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220304224205.3198029-1-robert.hancock@calian.com>
References: <20220304224205.3198029-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:610:b1::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a815c8-e12e-4844-13ff-08d9fe3056fa
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB6540233CFC1D3C8424B738DFEC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MF7Ye8Ky0uwUsOzzZOQNT2jzcNvsYjl0qgrFWhKKSWiXwix1Pr1rsOIAhPiLBcjvTd/utRWg8CYiEOMAnzvKC8iS7EFcjPDVXjc28JQ8ETCGYUPmOGxYNRsR7HZY4qIUgmWWtoFamVKxJoYGYW/Q6Mf3Uw+fzUUd3OS1dV1iWlsIGKyptfQ/g8PwNuA5V/Dv7xNBZhOqoyCYr0NPghlFhSISOPDsUQRN+bJxL2Bqoe1KuwnTQ0uKx31Q53fSuiizBGIG4PEx3HhshdwyC1epX2S8z044+RwJUQXYaC+Rx/UICxscOWewQnhs8VIfgGqtqGcmxtGCKrPdXy3PVcRqBexBrKQoerwTpx0BURXl+w5z2lwqNpxhndFskCsV+P+xD7L2mckixwQfs42h7Sb5SuLSaZKbNryi8LMLU/XXwGrEUld8ncMPcwbhcsaMbzKnlWqDXrvT0/sKhGJN8NYUeJiFJjWhrzDVkKnbjU6e0WYbDMYmh4WJKKMdqWytdk0CdF07nvB0WHgT3vfZpMegzGIMHK6BEZhX0jNCTWA+Ao26KF9wKwo6g7rqsgcEY+DYn9qfMqcyUGlT7m8gUpRDS3ExtDaRiK8IEIcjU/RFXw7dmESfJdk8KZetjTYcU6wKWDLNQl2LMiIsIlYkBYjP/18QA0+Vd67WVgGtV53FzUAP+rd3M8DrkzPqZrN+ZqnE8KSlobDxvIsN7JlcC/XLYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWSPBwPtJynBjiuy5UXLkcrVC/wOPCxzTZaOKENCWWo50jrV2gRcj7SxUdID?=
 =?us-ascii?Q?BVqIbOMsDRUQH6cMkPyGuxz38mpZArai4th/WnukZl++y6LiNQYISDBqETtx?=
 =?us-ascii?Q?mDzBv+EVXS1WmsiXs7IQk2aihxLyAey9IYuFKZ6pWAMaGcA8nHPwQXbMstEM?=
 =?us-ascii?Q?UnszFu5RXC0O6R8y8v7l3cdTyrpQTrvmIpexnsMh+g4etyy/2lxhgXeQcSBY?=
 =?us-ascii?Q?LJ1zwGGzv35LwM2rAJuQE8rELHGEBDTG3DEA1VYJmQiXVhps4SZMp4CR0OdO?=
 =?us-ascii?Q?/7ndleXeIN7nxlE0svIpUjiXdGZfipq75kYH2FO4Qyxp1MW55feKs9W5g+ZE?=
 =?us-ascii?Q?nAYgLS/Z81Rr64TH7VUInaI7lz45swSC0dD/qJSbPZS05XQnkqujAmHHEYiV?=
 =?us-ascii?Q?KXX5oNaQ979mkaVVC8GT8XwOtwsQww6oO42gNMgXOwoCMp0U3aOHV1dVpyeH?=
 =?us-ascii?Q?zpiqdQFytJrAMkZPqMqi/WSOF/aDjHm0+xvBZk3rsl729HHbPuvQY3ysr5L+?=
 =?us-ascii?Q?roUwoNz+q+2Bb5mh0CBwV/mq4If5X6gmdzJPa7yzcUvLeUU8Smnadwhwp08j?=
 =?us-ascii?Q?p0rXmO9JYkWUlV3fxEEz1CYcCzMfcsLVVbmb7y+A7D6zh3V1gu16C1zWiLyZ?=
 =?us-ascii?Q?+rLPilb4L1YK/4Nacf9SLpFAaXxq1h3Q4HSrcCTzNGQxBQZs2qNDE65q0b+5?=
 =?us-ascii?Q?qQ9dnNVuZP26wKnFvABw0fqPE9bp1UnY+8Dn79KryGlPSlXzWs+xlWTrVuQH?=
 =?us-ascii?Q?3aHei52+GwcvQVr5SOott+qpv+tf/NIi1NRR674fwIXbFuQCgZ+h3E95Z+kw?=
 =?us-ascii?Q?4yf0YqicfR88Y0Yfz7Qs/rUPzhHcsB14BX4YTDfAWTSa9K6Htd261tbCQoTi?=
 =?us-ascii?Q?VDE4uC7ft4b1Rxx5gm7cR8xF+IIF3fd9Tkwx+T2VUuMM3557FONuQJn6wCsA?=
 =?us-ascii?Q?pLag4JL30RgJPc4lu0M8H6b2Lt3T2jhFVrnmDXGBw2fiuFNYEYKvfa8hvLg3?=
 =?us-ascii?Q?XdX7s6vJQ0Vajj41kAvhIXcN6wX7Ult2YJ9I/nDjABPu+O0jMLah+ef06dRH?=
 =?us-ascii?Q?9MMCQW3iaJWLl9FtgT42FnM5JO5Um0FV+od9SZKB1U77nQeo7MWSiNyddTJD?=
 =?us-ascii?Q?KrWrfKRShMcr6mHAzwpKxt4VmqqTYOKVMXurHSeyZXoEMzmA6wPUMUP7yEEx?=
 =?us-ascii?Q?2pwIeFZQZv53btWZUE5Pstd2d7gvfdXA14MICif22uo7f7w0Vb2dlwN8ttKw?=
 =?us-ascii?Q?f/rkUc2J25wPO3kOSW8ajJuJwjhURf1UXhnCZXpUDCjGI8up9N0og4SuT727?=
 =?us-ascii?Q?fpQtRF+Gmnn0Dir2VXohmvx68BZIMXJvRKjBl2oio8OWm+V2Ee7jCnEBDU4F?=
 =?us-ascii?Q?X4hAAY70zlyXuLP4y5ifa6HRFerxQFZApajBr0e7oJQww5BKE7dzjUkcS7Xo?=
 =?us-ascii?Q?kgz3gJf6H5bdY9F0ROPdDiVWBTkCnvTrdbaX4LDJBmM3yP8cNq0aiU9An3tv?=
 =?us-ascii?Q?yxCSOsQ94dgFtwINzJuSlj09o3h7NXMfyno5BCwAWoWFNqHjCnELd52K8TG1?=
 =?us-ascii?Q?4Fm/kXHczjqVlWvNQm80CCX+xErk29QOVBMAOMJikkJeTG+MYjYMDstvvpeZ?=
 =?us-ascii?Q?S6/MEfOCIjSHgGBbyNFB4XYSEUe0Y4QR12rNyrEizYkKh3lN7jD3Pa9Xu2PM?=
 =?us-ascii?Q?oqFnieWnf93rW+PeuKvnJxboua0=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a815c8-e12e-4844-13ff-08d9fe3056fa
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:02.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U0qg7hPt+zldvGjLqEMp4XeWLC5Um6yM4/a5iXAjTBy1CyW2Ihd131D/1fVce+xM9yT7A9waJyfiNlWpRTHqQXDEwymQ3QQSoLV+e9oxUOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: M7fF-B-rIOEhPVLxTp1gfaWF0BVmnG8J
X-Proofpoint-GUID: M7fF-B-rIOEhPVLxTp1gfaWF0BVmnG8J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=756 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040112
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

