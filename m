Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A521851C689
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382384AbiEERwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344847AbiEERwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:52:49 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6438F2AC70
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:49:09 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245AxnwL032410;
        Thu, 5 May 2022 13:48:45 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv458gm5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:48:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL4L1s7E+sL3FnTkUPzuFHXpYsUrPqmgrkLMLAbhSaKiEy3F0wkrf2f8llljjxN8bSbCjUxQXyp4X8J3cduNXKypaP2oYvEaiREamgRqcGtXfYpmdOpjnxLYD2lmNl5lHeLqFwzknWqjCuvcj8EfRNEi5DB+d7m2lPT+gbynbwhp+3HlxtGUFBmh1p2LEFslAElBU1QmwCnbj5eFSKsCpCm2u6RTxkdbGiCLk1Y4rU0W4PCA0MK3Brow43jOuin/BiVWxUXCzfn1L91obu8O9yWBmA9mX/l1nuuL9yxoJ9U014GUH7gsMMXiFAb3XhnQ2/Mc06mlF8eZbs58BG0xmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKB2BpJa22Y0IO6cWlVFNVYNAR4creBOI/qceP12j50=;
 b=MQfstCUOaouv2UXWHtIEDoKxCm2hirPvZietx39tQUvfGvhcMF/mCmJs0657FU3bJXlbedN1iNTm8//AQfMS1dGo5TdT0yVRNTH7rPRSlRoCsAYHkDX3J5x5wuV/7o3tBpdG2aopv0mPEfIJ44beKJDL6Xp0Qzqj7ZZIVu+90qFt0BrmN8xvoxpbiKJxlrQlBsXsGVkrsbjL6madcgVWSKz+hyln/061lnutds8stLchh6FdOI/zYdCSmxbAkejAQ6BJGNqvpkvwtAm6rLBMhWc08oc73eVAZzoKM2IGCcgR+vedrTsINgKf/7MNDurVdW2YCC5mvNirFJ/coSsl9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKB2BpJa22Y0IO6cWlVFNVYNAR4creBOI/qceP12j50=;
 b=4OfdrfePoLh/oLJKB/Fzbsks8g3Lt1FXSHOrJoeMWqWi8QIySiMjpxJwz+VJ7KLS79RDYnh5xEZYYBclg3EtzbBNXHedZTRZRP2GFX9KF1IikK7MrVTsIrzr9kvlNN3H1yG4soq7sn1VcjXik8bj1tcYnIYvXdaajIGcvNCzBoA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT3PR01MB10267.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:8f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 17:48:43 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:48:43 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2] net: axienet: Use NAPI for TX completion path
Date:   Thu,  5 May 2022 11:48:23 -0600
Message-Id: <20220505174823.3585105-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::7) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c0bb4cd-6fcb-489c-c020-08da2ebf7f1d
X-MS-TrafficTypeDiagnostic: YT3PR01MB10267:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB10267C11D8270B3CE9A3E5ABFECC29@YT3PR01MB10267.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdRhkzw3rTZlOamb5G7wI9u4pryVwKFUTleFHBgv8c93ArAwTcCZeMejO1lfxxVtJPPaKk4hGGxZ7wANwH5ag+Q55LR949b2SyziWc+vlKGNhMy+581b0asM2nHd1qRztYI6PlSReYQkHjY/YcWeuIJWH1GbuX0age4ou84cSsI5LlKqOR0Yikc+dBxY6l3nZJbwyFXRqukQzfk32Hx8FD+PRyXuNvXtzaNXYIAcELDzsRiUY9KlUtmJCmfI8gi9j35keJgsjHrltMhdSjOUkNv4vfCeV8T5jJWP1lRVqhMTg+e7IZKXfYvt0TWdU4TI9ytB+35NHzs9UtToMrK0w4ghHE/yEHq1S/AfcXqxFSSlWotpzHM4ock1pxpY+oWTPD7lhr7+ZRRoXK/wXU10MrWAMWDjvnBMOESPGoMX0jNK3ZmiOymHxZBn2IOHZ0RUkceYJr/SPDi2Sjj9UoGAg9zNme64QomaI0MbZgu7KIVXeGIZStlA/ThiveMCldVGzmUVBKYCgd5qoQNOZWwGSaJMbZB3bvHhwJAKDywVMmQm1LN13po/r47OXla3ZjTYXQP8rbmGVm/kNbIxHaTGAQXa2ze5v1VmSkSTU7xkajAk0Lvd8lwnUaEbGUPG1oiOdbzffxz7R2XeWKCl5ZKkN3jznqQEdsCbTe7C0lfhrgl22VoDzp7NyIQAhnjPT/6hrU8ze20L18z/zn7q6qzjj+Cq9nPJiXLJOjQdlgUO9Y0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(26005)(66946007)(52116002)(66476007)(8936002)(4326008)(86362001)(8676002)(6666004)(2906002)(6486002)(44832011)(6512007)(36756003)(316002)(6916009)(6506007)(83380400001)(38100700002)(38350700002)(2616005)(5660300002)(107886003)(1076003)(186003)(508600001)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u6yTePIO1PaR6Pwdw/acF/3/bwrNKJ2Bu5EPOtbplwOBSLPOocb6ycLdX0jy?=
 =?us-ascii?Q?+4W7k+Lcg1daDwvmIk3KH3cF91gyYBQGiJeNU8W/hY9Rl1yB0e9e7d9aOdnd?=
 =?us-ascii?Q?No5o4WHNiA4FX66cXQjAfKZQyP5zhkapnDt1Hf5W1WE4M3txQprsmP5fgztn?=
 =?us-ascii?Q?sOuVWEiVpsfTlTFcdMqIWqs/qe59ztBFo6r8AYFuB3vl9LA4fDZ8ya+wR/9R?=
 =?us-ascii?Q?n4EVDRPOQqyjjgSB71BFPvzU0pns0YFrE3brJ1sKH16qb4I/DxKYe+3lRNgP?=
 =?us-ascii?Q?6nT7RFqRr26zrFEcgQfdJ6bfFCu+F9VtAejDYWUDmnlZhuFB+JzHX/X23qFB?=
 =?us-ascii?Q?iIe9Yqcf1n/nIilY0AiF9kCltAnEO7mBIMh4O1K/20XdeeR+A42eBQJsX2Ah?=
 =?us-ascii?Q?AsbQkzTPTBaT1QpME6NTv8vFMexwH84xlGNPa4gkTtKnaB5rrgL6AtsdHk2Z?=
 =?us-ascii?Q?9g+fpZNKjdY47B/rEWwBTXfGF3aymwffx27bv1H0VT3jalPfZ0gl3xOjgp6b?=
 =?us-ascii?Q?nlj8/9g3PulwsTxLd18VZr1IIEOCmQ8Li6ErcktvMprA4BhTLjiqMKtO13GW?=
 =?us-ascii?Q?7ejRpECFLEXM990wCljWq8VSF/WiMOCOtwgMkjNTt1uB0jxwFISZ0affFegd?=
 =?us-ascii?Q?TjNpQvObU3c8YR8ABNMkN0CmHn8Z1Bqfh86wj3GGZcmT98YuGvDq/Mbve62c?=
 =?us-ascii?Q?AQVIvJC1CwnqPOl81KjF9QAgy1AH8YTG4AwAgRuIZHDi22l7fqBTTQe55l3y?=
 =?us-ascii?Q?/U9AUOAKEm5wPYYZ0ZKGcqaK8xeJvpJ7jJWWsjptKAJwm9gisR97L+LKM1Jw?=
 =?us-ascii?Q?kXLZpgnwN5r+yLwcrLmKpSMq0izIwCeAgzNi9T6fRgN5Aahh+xMTSpus+qwO?=
 =?us-ascii?Q?Z7lhL6U7mSh0pbyKhB75bdNkVf4MzH/uf+dWEoyo5r8U+dhANd0AUK6lRKsD?=
 =?us-ascii?Q?Bg/OqPeWSaTKGypp2de+6ErcIpqDGFaPDGCkW1/nxoDFuuIPxryXDIacs/V1?=
 =?us-ascii?Q?67Ow/QRd2Kx8g1QIv8dfHETjaQYbNVXsv9c544Q/l2+Tw+vO9JRhxkAkDST7?=
 =?us-ascii?Q?aRUy2VvhHBk2eg1GiO0p7AtgJwfR3g8x0QehJIZ6nl+U9Rgj4es22z2g4U94?=
 =?us-ascii?Q?HHhHrLYpQcr6BOg9msbfaUsGUEEcpALmMijY0+vOikKTQ1iF17PzaZEwZ4xe?=
 =?us-ascii?Q?RN6d7kMQYhyx3y9/s+zmBhRk7psRKDC/5fzT16SBl3sWU+aInpkXd1Xw7YIE?=
 =?us-ascii?Q?h0unEct8EwcJqmWJ5gkBn2gZ7dOP8ZHFrszFF37qrqDCiXHUlB8qOTXS8ArR?=
 =?us-ascii?Q?we1M/G9WjZTNg/2rXSLgqVGLRf90NdiOYxmSkV9pdWVFa4uIm5urAWECN2Ij?=
 =?us-ascii?Q?CVfh0yFX8whB8dTVhod4rP9FJTqz5ieRr40iA/KcQC95gbU1Fm4NGSGcowSe?=
 =?us-ascii?Q?NioAAlM+2DWBDgIMD/erLjI9yJZNvzyPOX7egwPjO8RY4/r1LcKHJk51+eQa?=
 =?us-ascii?Q?qqjhzuS8GWCs3aZqCapMyDPVLaYe6aAh04QNRwOle/b3rh3LYOTxzA4pTJDy?=
 =?us-ascii?Q?nlYKvfR9qHGH0+FVCi7kZvMncEdDOD3OQToEvGQ7B7W3MIJv1JyTO6D2lHxb?=
 =?us-ascii?Q?/iQ9PfxuT972fHQXDCSy0TrhcLw0aZZRys0YlQS5PKpb4p500G7Y88OvdthS?=
 =?us-ascii?Q?RPdbMfiRYZ6dZfmflstvsC/Z9fTdde2v/osP5TzsEJimjsWiZzNih7xUy0LA?=
 =?us-ascii?Q?CBFYpqmBvZAlnjxnPLnEPEv5ezQ84JI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0bb4cd-6fcb-489c-c020-08da2ebf7f1d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 17:48:43.4352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nkr+emFLzpgQNXwfJf+PvEpFJz+u5X86gEeGyQz7BCT4NFa5rk3uAMWaX4RjJgsovx82Gx4fJtpcN9mNwZd3Lowtayqe8/J4YGyyS+I11BA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB10267
X-Proofpoint-GUID: O_4OnUZz5KJZ-mTGjzwtYgkppwzQyHc3
X-Proofpoint-ORIG-GUID: O_4OnUZz5KJZ-mTGjzwtYgkppwzQyHc3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=630 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was using the TX IRQ handler to perform all TX completion
tasks. Under heavy TX network load, this can cause significant irqs-off
latencies (found to be in the hundreds of microseconds using ftrace).
This can cause other issues, such as overrunning serial UART FIFOs when
using high baud rates with limited UART FIFO sizes.

Switch to using the NAPI poll handler to perform the TX completion work
to get this out of hard IRQ context and avoid the IRQ latency impact.

Testing on Xilinx MPSoC ZU9EG platform using iperf3 from a Linux PC
through a switch at 1G link speed showed no significant change in TX or
RX throughput, with approximately 941 Mbps before and after.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changed since v1: Added benchmark information to commit message, no
code changes.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 56 ++++++++++++-------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d5c1e5c4a508..6e58d034fe90 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -397,6 +397,7 @@ struct axidma_bd {
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
  * @rx_dma_cr:  Nominal content of RX DMA control register
+ * @tx_dma_cr:  Nominal content of TX DMA control register
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -454,6 +455,7 @@ struct axienet_local {
 	void __iomem *dma_regs;
 
 	u32 rx_dma_cr;
+	u32 tx_dma_cr;
 
 	struct work_struct dma_err_task;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d6fc3f7acdf0..a52e616275e4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -254,8 +254,6 @@ static u32 axienet_usec_to_timer(struct axienet_local *lp, u32 coalesce_usec)
  */
 static void axienet_dma_start(struct axienet_local *lp)
 {
-	u32 tx_cr;
-
 	/* Start updating the Rx channel control register */
 	lp->rx_dma_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
 			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
@@ -269,16 +267,16 @@ static void axienet_dma_start(struct axienet_local *lp)
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 
 	/* Start updating the Tx channel control register */
-	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
-		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	lp->tx_dma_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
+			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
 	/* Only set interrupt delay timer if not generating an interrupt on
 	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_tx > 1)
-		tx_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
-				<< XAXIDMA_DELAY_SHIFT) |
-			 XAXIDMA_IRQ_DELAY_MASK;
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+		lp->tx_dma_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
+					<< XAXIDMA_DELAY_SHIFT) |
+				 XAXIDMA_IRQ_DELAY_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
 
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
 	 * halted state. This will make the Rx side ready for reception.
@@ -294,8 +292,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * tail pointer register that the Tx channel will start transmitting.
 	 */
 	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	tx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+	lp->tx_dma_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
 }
 
 /**
@@ -671,13 +669,14 @@ static int axienet_device_reset(struct net_device *ndev)
  * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
  * @sizep:	Pointer to a u32 filled with the total sum of all bytes
  * 		in all cleaned-up descriptors. Ignored if NULL.
+ * @budget:	NAPI budget (use 0 when not called from NAPI poll)
  *
  * Would either be called after a successful transmit operation, or after
  * there was an error when setting up the chain.
  * Returns the number of descriptors handled.
  */
 static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
-				 int nr_bds, u32 *sizep)
+				 int nr_bds, u32 *sizep, int budget)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
@@ -707,7 +706,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 				 DMA_TO_DEVICE);
 
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			dev_consume_skb_irq(cur_p->skb);
+			napi_consume_skb(cur_p->skb, budget);
 
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
@@ -756,20 +755,24 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
  * @ndev:	Pointer to the net_device structure
+ * @budget:	NAPI budget
  *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
+ * This function is invoked from the NAPI processing to notify the completion
  * of transmit operation. It clears fields in the corresponding Tx BDs and
  * unmaps the corresponding buffer so that CPU can regain ownership of the
  * buffer. It finally invokes "netif_wake_queue" to restart transmission if
  * required.
  */
-static void axienet_start_xmit_done(struct net_device *ndev)
+static void axienet_start_xmit_done(struct net_device *ndev, int budget)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 	u32 packets = 0;
 	u32 size = 0;
 
-	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
+	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size, budget);
+
+	if (!packets)
+		return;
 
 	lp->tx_bd_ci += packets;
 	if (lp->tx_bd_ci >= lp->tx_bd_num)
@@ -865,7 +868,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
-					      NULL);
+					      NULL, 0);
 			lp->tx_bd_tail = orig_tail_ptr;
 
 			return NETDEV_TX_OK;
@@ -899,9 +902,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 }
 
 /**
- * axienet_poll - Triggered by RX ISR to complete the received BD processing.
+ * axienet_poll - Triggered by RX/TX ISR to complete the BD processing.
  * @napi:	Pointer to NAPI structure.
- * @budget:	Max number of packets to process.
+ * @budget:	Max number of RX packets to process.
  *
  * Return: Number of RX packets processed.
  */
@@ -916,6 +919,8 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 	struct sk_buff *skb, *new_skb;
 	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
 
+	axienet_start_xmit_done(lp->ndev, budget);
+
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
 	while (packets < budget && (cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
@@ -1001,11 +1006,12 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
 
 	if (packets < budget && napi_complete_done(napi, packets)) {
-		/* Re-enable RX completion interrupts. This should
-		 * cause an immediate interrupt if any RX packets are
+		/* Re-enable RX/TX completion interrupts. This should
+		 * cause an immediate interrupt if any RX/TX packets are
 		 * already pending.
 		 */
 		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
+		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
 	}
 	return packets;
 }
@@ -1040,7 +1046,15 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 			   (lp->tx_bd_v[lp->tx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
 	} else {
-		axienet_start_xmit_done(lp->ndev);
+		/* Disable further TX completion interrupts and schedule
+		 * NAPI to handle the completions.
+		 */
+		u32 cr = lp->tx_dma_cr;
+
+		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
+		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+
+		napi_schedule(&lp->napi);
 	}
 
 	return IRQ_HANDLED;
-- 
2.31.1

