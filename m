Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34745515864
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbiD2Wcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381061AbiD2Wco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:32:44 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815F619C0D
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:29:24 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TK0YH8032058;
        Fri, 29 Apr 2022 18:28:54 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fprsjavj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:28:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftAz2wPXeiasAhQkbOWnYgHG9YfEut2XXMv+roISQOi8N380BmNtr5ehtjaDSsdsBdavCjYHdnC873rhc9GLZlgX9IcsPITE2ftV3/47c/BghYkFQkYFzXC9fAoM9J1im2e2RXD7L92/immZ53SvD+jpELlFToPrcZGJOtPyYz4K3kSquo3wErylScmf3e+9Q5bBozrcIEpCxyAs9MxGmkX2DbbGR5oVULABYrpjjCP9KXcVHwGSnveAaAjqP8SSqNWJ8g/tW+DKQooXB0LQcYEhvgGKCwkoJa3rrsbls26TBgXU6v5sqN6tNmDkv/wRUzo7qVawrF755X5k0Oc1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCk6DoGuZAKe3EMvW4vIMpUmWSKEJTNAO3/vU+kzD8U=;
 b=Tie9P1i3Z3uvvdVf84uLIKzvyE6m5xokKPiFbslnwSuur6Q/gvx8PCT13wZbwPJ+VYOXTOWrzWFBXCcKWS58nSUXkJsKaW9ZzocW2pSLUDjs4gUKbo+ajIsXUPcsTwJfRqDFYXeZNtPXlgYl/jPTmRfZq5lHObu51nUaBbpyOCQS+dhLfeODHtBzleVXvT27bYm9bFi+hZHs3TJof+ywqxY3ctOBoshDiFk15+sgck4hrqgFKqzs7rMmUbOyc1NZ7lOpYvFkyl2wRKXWRU8IyKSz9AjUBofWeNoyA0eYK+S0B4m9cZAtXOAZsHkctJHCg2e4L819bKyJ1zlqZUHhng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCk6DoGuZAKe3EMvW4vIMpUmWSKEJTNAO3/vU+kzD8U=;
 b=Jk3piyy473EvzGXF+bdhh4oLqMQRg6xIdJBPkvbAIumsX7u3mOgtJC4RDezUtj2H2HAMabDSuweCFzKM+q30EKcDN3foyoh2PMz378XMnIPLSekDkxdllnoZOfxLompvwyQWd00mtRPcxWKs0aMBOEDNeIw1lQsPc0vAndYy3gE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB2505.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 22:28:52 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 22:28:52 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Date:   Fri, 29 Apr 2022 16:28:35 -0600
Message-Id: <20220429222835.3641895-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::14) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d7b89a9-5252-4762-444b-08da2a2fa34e
X-MS-TrafficTypeDiagnostic: YT1PR01MB2505:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB25053809E82E3D1E63E9E427ECFC9@YT1PR01MB2505.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpRL6Kjg6dQgOkc1TNYEgWkiml757BNeTPr6O93XdedLy8lJnM6U6sfSyVkrvJzcBtfxEldlpY23eDoZiqaaW9QTXfXWr3seG4I+A/Sd5CIcGWLoIitZChdDHiQWVYWiQUV12hKANcLCoyITcnF4oHm/3vJ7X6olB9cEimi3YuIkXSpiOK2AELpt9HFfLIzPNxRGTwJy9aRShkjlNEsaEpG8jVCxzHgueCJ72FtAzb3PnowlEqtItr2M+YCCaYALO4oJzMscvWIhz0OcGD9k64B7o38qNKNwA6WXcErLduCTq+L5kSLhcCdxN2gi+YV6KmJRuGDkoze7F+8+1LLFVAAsGsYFelAU8xeeRHzY3OX/7ehlLQovx4tI442+7z5DUppLDN6eMMdCQY4w+CmpxzLovj8iyHH/Mzru5NjDRLYp+jqK4SYZIsUqgB56THL6UBhWhy798tJUwUSCXm+CtXeyp5PFFJOSZ41FD8LVpXFVzP+/vSXh480LhOJwy2I883ffyvpSa9tLPKyDcDAFlOe3UrPLXRoWhuWu8wQbyyDUFp2VlT7WdNGlLRqkLkML+hOOysDGwhNwT6tw0b2Jb58cBk3bY8gBXVr/WT4movvmSb8S58plaTjdsv9MVCAIyS1mSIKmoyHSGe1fDUFe15ayTBMq75OIHCZ+xN/vD30gWdOMi+E+T7DrDlTDyt1fGD84Npu+3pyR5GIIURSjF8FBXCiY5MzBuX39L9g4Jw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6486002)(508600001)(2616005)(52116002)(107886003)(1076003)(26005)(6512007)(6506007)(38100700002)(38350700002)(6666004)(66556008)(186003)(66476007)(316002)(2906002)(66946007)(44832011)(5660300002)(36756003)(8936002)(4326008)(83380400001)(6916009)(8676002)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MZQ1bsziXr7T41MC7061M9u6B0qmU3Jee23Ax7++iD4N8Rj1M8q4cqN7MB6G?=
 =?us-ascii?Q?hqdgNobr6mCxf9BJqgZjkvI1d7PWmWl0wYem/Q/QCse8CU0QbpAC6qmo5NEQ?=
 =?us-ascii?Q?P4+OvYBtvcdl/hgXXGExbvDdV2d7PEgfGccDKDB2OPSd/2RTksUaT6dx7u4W?=
 =?us-ascii?Q?N9pW71dNUq6nxxHud5/2OM5Ipeg8d7eJFYwmGmbFMxqoH5PnVpSIynj4KVCb?=
 =?us-ascii?Q?qkR9u0Zf6VdjGiBRnSXfa/OSbJ6/GD06f/Ay29ZRamyud1M8HRHao5XyzZDT?=
 =?us-ascii?Q?0c6SAnz7ft0O/jnx883xSpQlSvQUAhGkCD5TGoqENExFh4ac2O9c8KlVN5Bh?=
 =?us-ascii?Q?gainM4MieBswt2rEm6Irpc/17BB2WqRwrHwH/Unr92j7fK4uXE6xa3hwTqKd?=
 =?us-ascii?Q?HvM/xpfjA+qhkIegunpC8sbf7bQVL7iTOq2c10IW7/MAieVa4hrZXNIYb6Ns?=
 =?us-ascii?Q?J8sTqTk7dcqE5SkA4iXDxa153dpBBN4GGoOQSBX2g40ULLgqSAQRZKHWKoxD?=
 =?us-ascii?Q?YLUZZGaswllgwQdwY0fWs16xz/wh3O5WTbkQmqkDwjILq1z5Q8D/sC7UYOOF?=
 =?us-ascii?Q?Kz0ecX98uxArL34uNuWg31YzQtxJlj1GJlnKE2787fM4Can+csecAoJH5LYX?=
 =?us-ascii?Q?eVGhMaE+6epPsoB3fcHqvUeen+EeRpZeIv/4yjsnoGb5CZ4Qvc0SV+Q/Uuqt?=
 =?us-ascii?Q?40YoYzh+DwpAQ/NY6/lxlVEBRl5c8+iYqjNq1irTY7e8k9VvTp4lPdcSAa7l?=
 =?us-ascii?Q?FaQJtdBbQGTafv/x7yFjSsr9dhWbULRuFTgBSvWC3VwqZ2NEwsIEimUlDyvD?=
 =?us-ascii?Q?artYUyL7pSGZrT4OOkg9i/RnzFAoBSezDgo7Ska0RMyM7MeQQMli7W7HrH6P?=
 =?us-ascii?Q?pgHQ9bjt+q6FwkibsZM0cD4SjlrvW3Q4rdGr/JGm6yPhmMMLxgSevLBqnONo?=
 =?us-ascii?Q?wQJqP9ebcz1JVBQ7Me2QXiuBmhwkWGZnJ9m8MW61qW1UYLnBLldF2dvgVn7J?=
 =?us-ascii?Q?M75qgRoGvlRS1bd/3t8+ZPMauqX0WvVT8yAduVToLOyhhpa8vE2eWiytmcC5?=
 =?us-ascii?Q?nXUyyfPti6MQc+kF4UC3EDCpJXZ99vGbWhvC7RB0oJUDNFXgQitM7f/aCtyX?=
 =?us-ascii?Q?BVSX04hDx+l2QsuKDcXMoXovnUG9KiFAudTay3jR03bUywqZ5OzglGDvX4LS?=
 =?us-ascii?Q?LkTq27XDsALhdPGjSfN2ipmq7aiMURf1vqHK4kLRRHdBZrWCS06OdTWRbShx?=
 =?us-ascii?Q?tQAcTGUG48FUC5VPqq7YwlXoLV1uNVkke7MA8ePCRm1wl3oCOnpzWurMmhAN?=
 =?us-ascii?Q?6HaoMPD25DJw3pecRLOWOILYOat8s2CLwA4GM62EVDjM5lODsm3eHqWUnyJd?=
 =?us-ascii?Q?dcnG2jrtXXgZC9RKoQw+f4tTScjTC5f12DV+hYkEhSciHn+YGTk5Ij+rWmdd?=
 =?us-ascii?Q?j1azjC8vcDw2WARgLb6na9t3dB8gHYG5FiSWcknZfZp4PB5lEjWaJ93KS5Lk?=
 =?us-ascii?Q?5uw6wPjLQDjXnLY+5mS6XDSgUss+r1eajQhSBQZJ4PuEJfiIfm10n+ErmDJY?=
 =?us-ascii?Q?05LMQsN2U0sefpGSr6W+75Iem/sRrPmuUjjUHyqXraZKZ11NlPgvhF6d6zrQ?=
 =?us-ascii?Q?iuYn2TRdhawvYWwaDd4Xud66WgQYv2a/Z1dZyLtSGgWTvF96Fh7pVrc9SXdT?=
 =?us-ascii?Q?EF416NIpyhkHuAo/quqRzpODOmvnX09J4HntW7WmV+TWPbcXSbW3aS9sttg3?=
 =?us-ascii?Q?o5xV1RKdhtWM+7+DDrLPpB5HPVQ5aHA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7b89a9-5252-4762-444b-08da2a2fa34e
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 22:28:51.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tV4SNozLBIfyOEtSSLQI5oYwIST7I4yrLvAlkNRMLRsjNS1Szgknjf65lLwZbRvkHmFqmfCnF7NCOruuoxQtPXB5HCqS/Flb/l2omy0/mGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2505
X-Proofpoint-GUID: kNw5vbYHqfddUg-HdRWInlqaGg7fBg91
X-Proofpoint-ORIG-GUID: kNw5vbYHqfddUg-HdRWInlqaGg7fBg91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_10,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=438 mlxscore=0 clxscore=1011 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
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

