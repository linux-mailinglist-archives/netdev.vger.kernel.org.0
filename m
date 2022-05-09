Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85939520396
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiEIRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239674AbiEIRfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:35:19 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66013193C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:31:23 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249B00xZ026003;
        Mon, 9 May 2022 13:30:56 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fwnp40te2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 13:30:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1vEtyFiSn7Blkko1mHOmW+FiFnevDJyPPT4BM+bQ7ilYhTayVP5wjuDXgV+Acw4m0WSKzQ4Mp9D0hSc0Hvrejhco3NxVwVnwASmCci0lPR96P/Oj964E5KZY3/OiFtdUeQnMYLTYH2H1g3BwI3dPQ4K0cpnvib8jZu7w6zAQsVh74GZn62GQs+xLfkgUuA36HLIB7Wl258wRfXDrgZquj9CMaYJKFT2upq6ARdN3dBYv1vjYzRaUFd8qksRKNq2QFGRGzJG+C+ryxoWodIrQW0XDFHok1cAbylW9ugwcQx8xD8tM64kMZK5tc4zeD+CMRhnlSWw30ZR6Cfaf1BnYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQpAtRIBR8xmI6vvVr1DkBlB+Me6JODrD3aIJ5ouEN4=;
 b=Ap7O2K4jQxqRW01fARW91iQmN80JAJ0N9B378jPJc5HOQFtIj3MaAPsb7im58u/FwX27H3AGLOclB4HvluJCB5/GlAgUUuoh8TT6S94AMYvcOYmB3Tb+ksyn6MkCDKvAZ6U4ON+1YKw3mz+eQMW2KhT0cBenJn4pBjxjh7M3/HZbFxc0VEznZnbVxmWS1tfN7IWyLmT34niegzcLHPAE8obHLSbPO1Wu7aiixwEYqDezs+xN5bW8/HmZBxRljh1bg/vVqGqc4xW30NOQEXJIgWkv9vz0cs3H69+nVUS7rCuJ+KJ/lZYJLkL34ygCaG9JpWg0FOc+YbKfSMJUyrVZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQpAtRIBR8xmI6vvVr1DkBlB+Me6JODrD3aIJ5ouEN4=;
 b=tRs8omOQKD+j8L+G6NteidErRPgt3eKOWqNxR3dxW4FKPuGNAXIZL3ykJ0o+pzbMvPE3qZr187VqL5UJi8nuk34L/UkE02ZEBeaaw87jijyp4Gjl2K16fOmoF5lU22npW5Ec7LTRrBcKahGf8Cb8B7Ra3WDTdGHFGw89VQ+HL+U=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB8236.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 17:30:54 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 17:30:54 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v5] net: axienet: Use NAPI for TX completion path
Date:   Mon,  9 May 2022 11:30:39 -0600
Message-Id: <20220509173039.263172-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0138.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::17) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aebef29e-7f7b-4b3b-2afe-08da31e1ab8b
X-MS-TrafficTypeDiagnostic: YT1PR01MB8236:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB82363C218CA720A041E51179ECC69@YT1PR01MB8236.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMFxy4Jwq0H525NPR95Yonimntzw83M/tv1Ec2+ml5iVnsRmYBGpP6MK6K6xQZ2DBtoXibQPpfn51D2BX23cto1qdw2wwyLaemUMH68yMORKHfvgLev3g++eg5Bt+dNknPL7ZyfBiCiJwt1ofVW29nKjt7NWvMGKilQfYmsibVtGKQPfQCWuo9uDE/1KSJ33yj2W5Z5XziHBk1WY0rfsYdKVaeYibvX8b0wcP52VVpKnjeCNMNvyHPqeUryTxIl8uozU+6+jrLhOC4x7KY7EegSTor3WDnv4McMwtllbGMBQMZLr+IpwPHYGCe1pRdbk8kndRXHfItOWUKSDWxgy86qm1WCSsY7+DsawdgPBKkF/Ny4G8xMmtOTR/ScAODU+bDJ9hrdr1R2NQEMWtPqfD/ItWd7FvCiZ2O5r+bxaJKmGyyKNz3Kh/VicfvrAaqUqGqhBdyKF6cgLWZs/vQO1qv4pBmQGARMfod90jdF72zefu/KhKaqVsFvgCNaRJ4PRDv49C63alwnEDjmJBFv2s3SoGwqlF7dH1GAA5k3pmUJm+EPW5YOO01dAL1+h47vOYAcSCFcW6/4CS2vovsC+NSlQQ3S/ouee2MwV/2g88eIIznkXvZV8UcmBhpMBoUBXGqHDV9+pBXuKFW5yYYBVEEGSlW8+vfo25iRuYBF/LXi9wInRLl8aFpbY1eOaOl0cvKxJphvuYrDUZo6O/A9MRaJfMKW3a2KbGlzdNogqEsE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(1076003)(86362001)(6512007)(186003)(30864003)(107886003)(26005)(2616005)(44832011)(38350700002)(8936002)(4326008)(66476007)(66946007)(2906002)(38100700002)(83380400001)(8676002)(66556008)(6486002)(6506007)(6916009)(52116002)(508600001)(36756003)(316002)(6666004)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B8WqTm8DkeSzBC3UfLoDy7ZdDXjXUVhdZWalHimCmUBHegWddrlyCnn7XMqq?=
 =?us-ascii?Q?QeakPBgGF2W+eb/PrNl177e+TjuwCvfQdEci1xjiJq/aERyHMFSoTDglPE1F?=
 =?us-ascii?Q?QTiRUjxwmnx1esX6c2KhZNcD5Nh8LYD5zk6X9YNLRtJGkBprR2ZEnh0SUPA8?=
 =?us-ascii?Q?PW/NVK3u4ucZ4rjWD861iFco7EkDL0Mjd+TkviMG9+ppT3EkWBnVZIhgVzN/?=
 =?us-ascii?Q?cXl0W85Qcg6rduMxfPa3LzpipaCsOBRxJUxCZxF+tRmw17rZB8ManZx2veKa?=
 =?us-ascii?Q?hfibxlkUThbcts0uGcsIhOrS+VFvl63Geh+kD+9FwYtj7SNnqaR1MyM40QLP?=
 =?us-ascii?Q?SNjr7gWDx2quW9WY9py9PHIJXZz4q+FzFgbKyFYY+Mbb4bDIJJSpzgdw0dYH?=
 =?us-ascii?Q?nNLJeGSCrzSg4WLm3IBIvjsbIAwigaDDGaC/o21HToskGeVsNw/OdK0iZ7a7?=
 =?us-ascii?Q?4Ca+IGzEZ5MVzqMQKGhm1xhKNDYRvDiPbM0aEhrsxzVdu3Uys6wEdFCpTQdx?=
 =?us-ascii?Q?0Ri8wekH4ULvVVFg0FjaVkxAzyNAmA6riPWVsyW8k5gNFkC5BCW8xNfEtWCw?=
 =?us-ascii?Q?iFO5OeXTCMxQTG/AJdm4zPopAnPYLeh7n8RvWZJRJzCNhqOYDq4f7jo5wH56?=
 =?us-ascii?Q?jlOOySsGSvOHUrxewkkDINhIXGQWY9zjgCmN07NqJsoBc7TKW/iunERIaugo?=
 =?us-ascii?Q?nvBJ0SFJDlc9HbStPtbYVMvQDmZryD6XHIRAbBqythTT5RP6oSGB+IZ9R8Lp?=
 =?us-ascii?Q?2uywucNjgZrNOd/OuNffuCu5JR5Z7yHS785HZ+5LCJdFuiB6BfYUjqmq+Rz2?=
 =?us-ascii?Q?MoVoIVn5R+dQfi8aoM4+Bb9tj+xzfkvuH1qpaGU0RpPorM/f8zrcXec9RFHN?=
 =?us-ascii?Q?JykpcpPgtG/Gc09+c+JUDtRQH+c7rP5XmKjmcUYeVg7GAN3P/ynlGy1ZXyUY?=
 =?us-ascii?Q?Ke0lCvqBENGUHz5qz5uYRZmEGiI1Q0GbxZa0fd54L4piM7xhJbs8siywNZD4?=
 =?us-ascii?Q?S8rF7e9T8sWkQxRxeZsjq03HdgLs+YaMrf0j6rxq7saLyGVoevlbp80UuZUr?=
 =?us-ascii?Q?scp1/m+8JO5PvleWO0RMv+rufOwwg4q8/keU1E0LrgpKyGsh6vVHIJD+tX1+?=
 =?us-ascii?Q?Mf3jTpofCcsHRrNrjtzC30G4LVokA88ZKP/VIHPmzUHbs9cHulc01Je5YeCE?=
 =?us-ascii?Q?TeYhhTV6QsoMsby2ngDv2BN6QW3GI6Os0oq2hl+9UmBGoFTmiL3M1XJ6SGiw?=
 =?us-ascii?Q?0qE2Rf4qlWeWwYVpJ9UJGLIOzY0lAJwFqNwp8UYrJB6RajKkiOswXJTUvPUq?=
 =?us-ascii?Q?4cmpMfdmKRgibgwSh2KpOAas8xqVpdkP8zvi75JrptdczBZqNKo8+qICgYyO?=
 =?us-ascii?Q?yQdGpltpmaVGaDWz+l9FKOXr91SlyAbjQ55RFQRIsk7AQLRAzFgzW+UsL8G9?=
 =?us-ascii?Q?TjXYlhezH8xse/NR7REw8IjZ4nZdySJJCtJcko/5HpZJsCrMwiv7wnmI9twD?=
 =?us-ascii?Q?vG0Jrh8wue9hEDcthwoqT/Y/orR1boN+vucfAQLHYco/GSqyn5yArDy/YZ8u?=
 =?us-ascii?Q?5JAleggRmMK5tDW3fKg4frE+MY6gMLBKVTUb2aMNcO2tNQPUmxZGDvPlISD2?=
 =?us-ascii?Q?Kt8gZ39+z42poIYXoj2syj86PbEqAgAnY0FyOXqXNlCWeh8LhSmSvsq9mYmf?=
 =?us-ascii?Q?DUjfWXQ9SMPMwtXJ2kp+KA9BnvDBvOfM255J7xLOKkURsy7JOrPSzCgKxfVs?=
 =?us-ascii?Q?ooWpR3xyqG2ZXSEP63/ICc4RyYy4e9E=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebef29e-7f7b-4b3b-2afe-08da31e1ab8b
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:30:54.3023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAcKZPK0D2bMqQlVT9i5X3Z8862WrH/W5gpAZ80rh7kCmDxRVVUJJBe2XNyUOnVtXO7Vut0uEZ3Z7xLv+rrZzwmlzap/fZ11UZySU8RCOGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8236
X-Proofpoint-ORIG-GUID: 8bZLZVcD8kvTc8TiH7xzIdxkqGN3OyIq
X-Proofpoint-GUID: 8bZLZVcD8kvTc8TiH7xzIdxkqGN3OyIq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090092
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

Switch to using a NAPI poll handler to perform the TX completion work
to get this out of hard IRQ context and avoid the IRQ latency impact.
A separate poll handler is used for TX and RX since they have separate
IRQs on this controller, so that the completion work for each of them
stays on the same CPU as the interrupt.

Testing on a Xilinx MPSoC ZU9EG platform using iperf3 from a Linux PC
through a switch at 1G link speed showed no significant change in TX or
RX throughput, with approximately 941 Mbps before and after. Hard IRQ
time in the TX throughput test was significantly reduced from 12% to
below 1% on the CPU handling TX interrupts, with total hard+soft IRQ CPU
usage dropping from about 56% down to 48%.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changed since v4: Added locking to protect TX ring tail pointer against
concurrent access by TX transmit and TX poll paths.

Changed since v3: Fixed references to renamed function in comments

Changed since v2: Use separate TX and RX NAPI poll handlers to keep
completion handling on same CPU as TX/RX IRQ. Added hard/soft IRQ
benchmark information to commit message.

Changed since v1: Added benchmark information to commit message, no
code changes.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  56 ++++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 158 +++++++++++-------
 2 files changed, 128 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d5c1e5c4a508..5fe3f269c931 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -385,7 +385,6 @@ struct axidma_bd {
  * @phy_node:	Pointer to device node structure
  * @phylink:	Pointer to phylink instance
  * @phylink_config: phylink configuration settings
- * @napi:	NAPI control structure
  * @pcs_phy:	Reference to PCS/PMA PHY if used
  * @pcs:	phylink pcs structure for PCS PHY
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
@@ -396,7 +395,23 @@ struct axidma_bd {
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
+ * @napi_rx:	NAPI RX control structure
  * @rx_dma_cr:  Nominal content of RX DMA control register
+ * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
+ * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
+ * @rx_bd_num:	Size of RX buffer descriptor ring
+ * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
+ *		accessed currently.
+ * @napi_tx:	NAPI TX control structure
+ * @tx_dma_cr:  Nominal content of TX DMA control register
+ * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
+ * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
+ * @tx_bd_num:	Size of TX buffer descriptor ring
+ * @tx_bd_ci:	Stores the next Tx buffer descriptor in the ring that may be
+ *		complete. Only updated at runtime by TX NAPI poll.
+ * @tx_bd_tail_lock:	Spinlock to protect TX BD tail pointer value
+ * @tx_bd_tail:	Stores the index of the last Tx buffer descriptor in the ring
+ *              to be populated. Protected by tx_bd_tail_lock.
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -404,19 +419,6 @@ struct axidma_bd {
  * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
  * @options:	AxiEthernet option word
  * @features:	Stores the extended features supported by the axienet hw
- * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
- * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
- * @tx_bd_num:	Size of TX buffer descriptor ring
- * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
- * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
- * @rx_bd_num:	Size of RX buffer descriptor ring
- * @tx_bd_ci:	Stores the index of the Tx buffer descriptor in the ring being
- *		accessed currently. Used while alloc. BDs before a TX starts
- * @tx_bd_tail:	Stores the index of the Tx buffer descriptor in the ring being
- *		accessed currently. Used while processing BDs after the TX
- *		completed.
- * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
- *		accessed currently.
  * @max_frm_size: Stores the maximum size of the frame that can be that
  *		  Txed/Rxed in the existing hardware. If jumbo option is
  *		  supported, the maximum frame size would be 9k. Else it is
@@ -436,8 +438,6 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
-	struct napi_struct napi;
-
 	struct mdio_device *pcs_phy;
 	struct phylink_pcs pcs;
 
@@ -453,7 +453,21 @@ struct axienet_local {
 	void __iomem *regs;
 	void __iomem *dma_regs;
 
+	struct napi_struct napi_rx;
 	u32 rx_dma_cr;
+	struct axidma_bd *rx_bd_v;
+	dma_addr_t rx_bd_p;
+	u32 rx_bd_num;
+	u32 rx_bd_ci;
+
+	struct napi_struct napi_tx;
+	u32 tx_dma_cr;
+	struct axidma_bd *tx_bd_v;
+	dma_addr_t tx_bd_p;
+	u32 tx_bd_num;
+	u32 tx_bd_ci;
+	spinlock_t tx_bd_tail_lock;
+	u32 tx_bd_tail;
 
 	struct work_struct dma_err_task;
 
@@ -465,16 +479,6 @@ struct axienet_local {
 	u32 options;
 	u32 features;
 
-	struct axidma_bd *tx_bd_v;
-	dma_addr_t tx_bd_p;
-	u32 tx_bd_num;
-	struct axidma_bd *rx_bd_v;
-	dma_addr_t rx_bd_p;
-	u32 rx_bd_num;
-	u32 tx_bd_ci;
-	u32 tx_bd_tail;
-	u32 rx_bd_ci;
-
 	u32 max_frm_size;
 	u32 rxmem;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d6fc3f7acdf0..a47c9096b1c0 100644
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
@@ -666,37 +664,34 @@ static int axienet_device_reset(struct net_device *ndev)
 
 /**
  * axienet_free_tx_chain - Clean up a series of linked TX descriptors.
- * @ndev:	Pointer to the net_device structure
+ * @lp:		Pointer to the axienet_local structure
  * @first_bd:	Index of first descriptor to clean up
- * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
+ * @nr_bds:	Max number of descriptors to clean up
+ * @force:	Whether to clean descriptors even if not complete
  * @sizep:	Pointer to a u32 filled with the total sum of all bytes
  * 		in all cleaned-up descriptors. Ignored if NULL.
+ * @budget:	NAPI budget (use 0 when not called from NAPI poll)
  *
  * Would either be called after a successful transmit operation, or after
  * there was an error when setting up the chain.
  * Returns the number of descriptors handled.
  */
-static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
-				 int nr_bds, u32 *sizep)
+static int axienet_free_tx_chain(struct axienet_local *lp, u32 first_bd,
+				 int nr_bds, bool force, u32 *sizep, int budget)
 {
-	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	int max_bds = nr_bds;
 	unsigned int status;
 	dma_addr_t phys;
 	int i;
 
-	if (max_bds == -1)
-		max_bds = lp->tx_bd_num;
-
-	for (i = 0; i < max_bds; i++) {
+	for (i = 0; i < nr_bds; i++) {
 		cur_p = &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
 		status = cur_p->status;
 
-		/* If no number is given, clean up *all* descriptors that have
-		 * been completed by the MAC.
+		/* If force is not specified, clean up only descriptors
+		 * that have been completed by the MAC.
 		 */
-		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
+		if (!force && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
 		/* Ensure we see complete descriptor update */
@@ -707,7 +702,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 				 DMA_TO_DEVICE);
 
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			dev_consume_skb_irq(cur_p->skb);
+			napi_consume_skb(cur_p->skb, budget);
 
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
@@ -737,14 +732,15 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
  * This function is invoked before BDs are allocated and transmission starts.
  * This function returns 0 if a BD or group of BDs can be allocated for
  * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
+ * returns a busy status.
+ * Must be called with tx_bd_tail_lock held.
  */
 static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
 
-	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	/* Ensure we see all descriptor updates from device or TX polling */
 	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->cntrl)
@@ -753,36 +749,53 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 }
 
 /**
- * axienet_start_xmit_done - Invoked once a transmit is completed by the
+ * axienet_tx_poll - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
- * @ndev:	Pointer to the net_device structure
+ * @napi:	Pointer to NAPI structure.
+ * @budget:	Max number of TX packets to process.
  *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
+ * Return: Number of TX packets processed.
+ *
+ * This function is invoked from the NAPI processing to notify the completion
  * of transmit operation. It clears fields in the corresponding Tx BDs and
  * unmaps the corresponding buffer so that CPU can regain ownership of the
  * buffer. It finally invokes "netif_wake_queue" to restart transmission if
  * required.
  */
-static void axienet_start_xmit_done(struct net_device *ndev)
+static int axienet_tx_poll(struct napi_struct *napi, int budget)
 {
-	struct axienet_local *lp = netdev_priv(ndev);
-	u32 packets = 0;
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_tx);
+	struct net_device *ndev = lp->ndev;
 	u32 size = 0;
+	int packets;
 
-	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
+	packets = axienet_free_tx_chain(lp, lp->tx_bd_ci, budget, false, &size, budget);
 
-	lp->tx_bd_ci += packets;
-	if (lp->tx_bd_ci >= lp->tx_bd_num)
-		lp->tx_bd_ci -= lp->tx_bd_num;
+	if (packets) {
+		lp->tx_bd_ci += packets;
+		if (lp->tx_bd_ci >= lp->tx_bd_num)
+			lp->tx_bd_ci %= lp->tx_bd_num;
 
-	ndev->stats.tx_packets += packets;
-	ndev->stats.tx_bytes += size;
+		ndev->stats.tx_packets += packets;
+		ndev->stats.tx_bytes += size;
 
-	/* Matches barrier in axienet_start_xmit */
-	smp_mb();
+		/* Matches barrier in axienet_start_xmit */
+		smp_mb();
 
-	if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
-		netif_wake_queue(ndev);
+		spin_lock(&lp->tx_bd_tail_lock);
+		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+		spin_unlock(&lp->tx_bd_tail_lock);
+	}
+
+	if (packets < budget && napi_complete_done(napi, packets)) {
+		/* Re-enable TX completion interrupts. This should
+		 * cause an immediate interrupt if any TX packets are
+		 * already pending.
+		 */
+		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
+	}
+	return packets;
 }
 
 /**
@@ -809,7 +822,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	dma_addr_t tail_p, phys;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	u32 orig_tail_ptr = lp->tx_bd_tail;
+	u32 orig_tail_ptr;
+
+	spin_lock_bh(&lp->tx_bd_tail_lock);
+
+	orig_tail_ptr = lp->tx_bd_tail;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -820,6 +837,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		 * woken when sufficient space is available.
 		 */
 		netif_stop_queue(ndev);
+		spin_unlock_bh(&lp->tx_bd_tail_lock);
 		if (net_ratelimit())
 			netdev_warn(ndev, "TX ring unexpectedly full\n");
 		return NETDEV_TX_BUSY;
@@ -846,6 +864,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
+		spin_unlock_bh(&lp->tx_bd_tail_lock);
 		return NETDEV_TX_OK;
 	}
 	desc_set_phys_addr(lp, phys, cur_p);
@@ -864,9 +883,10 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
-			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
-					      NULL);
+			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
+					      true, NULL, 0);
 			lp->tx_bd_tail = orig_tail_ptr;
+			spin_unlock_bh(&lp->tx_bd_tail_lock);
 
 			return NETDEV_TX_OK;
 		}
@@ -887,7 +907,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
 		netif_stop_queue(ndev);
 
-		/* Matches barrier in axienet_start_xmit_done */
+		/* Matches barrier in axienet_tx_poll */
 		smp_mb();
 
 		/* Space might have just been freed - check again */
@@ -895,17 +915,19 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			netif_wake_queue(ndev);
 	}
 
+	spin_unlock_bh(&lp->tx_bd_tail_lock);
+
 	return NETDEV_TX_OK;
 }
 
 /**
- * axienet_poll - Triggered by RX ISR to complete the received BD processing.
+ * axienet_rx_poll - Triggered by RX ISR to complete the BD processing.
  * @napi:	Pointer to NAPI structure.
- * @budget:	Max number of packets to process.
+ * @budget:	Max number of RX packets to process.
  *
  * Return: Number of RX packets processed.
  */
-static int axienet_poll(struct napi_struct *napi, int budget)
+static int axienet_rx_poll(struct napi_struct *napi, int budget)
 {
 	u32 length;
 	u32 csumstatus;
@@ -914,7 +936,7 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 	dma_addr_t tail_p = 0;
 	struct axidma_bd *cur_p;
 	struct sk_buff *skb, *new_skb;
-	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_rx);
 
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
@@ -1017,8 +1039,8 @@ static int axienet_poll(struct napi_struct *napi, int budget)
  *
  * Return: IRQ_HANDLED if device generated a TX interrupt, IRQ_NONE otherwise.
  *
- * This is the Axi DMA Tx done Isr. It invokes "axienet_start_xmit_done"
- * to complete the BD processing.
+ * This is the Axi DMA Tx done Isr. It invokes NAPI polling to complete the
+ * TX BD processing.
  */
 static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 {
@@ -1040,7 +1062,15 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
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
+		napi_schedule(&lp->napi_tx);
 	}
 
 	return IRQ_HANDLED;
@@ -1084,7 +1114,7 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
 		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
-		napi_schedule(&lp->napi);
+		napi_schedule(&lp->napi_rx);
 	}
 
 	return IRQ_HANDLED;
@@ -1160,7 +1190,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
@@ -1187,7 +1218,8 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1211,7 +1243,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
@@ -1732,7 +1765,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
@@ -1798,7 +1832,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 }
 
 /**
@@ -1847,7 +1882,10 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+	spin_lock_init(&lp->tx_bd_tail_lock);
+
+	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
-- 
2.31.1

