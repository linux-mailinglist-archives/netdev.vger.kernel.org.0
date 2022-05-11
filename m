Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80F5523CCB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiEKSpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 14:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiEKSpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 14:45:20 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C39E7314
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 11:45:17 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BBKUFG030957;
        Wed, 11 May 2022 14:44:56 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02p2rnjq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 14:44:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Guju4xY2tPgHzCi6TGYg+8ZcvfaBlmrTEasQSCEsG0H1p5pUHANG7lVc7qClViqjEBqEmYdtmwjOKUSiIsECrsc+FjtbcQMF+ukq5sSg2wj8WQ/SEOn3mefklEekGANK3Nt53Go597Xh0WH59GmpaOrHXEHZof2/4G9496TWk9uYWd8yiSNs5kLxkFfPR4YV2IB5YyxqtR2ZLikqaAJL3seFZQWJHpeoSNbK29GQgBsbfc7viKgWRaCv+DaGHdzN95wunrehHQedv8Lpphy2YzgpI92ftEeVixExnthcEqV3skmEUSsWGcRUS2BzGBvNuUrNF6jSeqCicG7TYy5KmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khbi++mW6QCXcTY2yY/KFCbFq+da0xLbs01s4zM6qmU=;
 b=NeCYalHbPPnSlSsEI0wICBUsFa7GvEhZAtnO4qcXCGDGX76ic9OrbRo8ptk/Ke8kOB2fLAmhH6BLQJyXrqie/RozigL0Wi/YspkM4biW0tVbuUucTgWsmCObAGZjvUXF3KN+MopdTeWa4tTEKeQhCMpVwk0RdEexVTzbRGO+2aZQ968+IuKyWgxMXtKlg9kCDatk+4fReoDG/SFWPwjtvyA+jN9KCjxiV57MSh87qIbT+WvSIcsWUpBHLIKAF8o5hUkDJFk7BmNbaUQQoKmVN0mjwsNswKnkgFsizDjVdLBwcC9ppqb/G+UvazrFY/dmol8mAZYbrCVNq3SFI726sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khbi++mW6QCXcTY2yY/KFCbFq+da0xLbs01s4zM6qmU=;
 b=3GANdwjZch73xRGkpV/DugIKQeqBLaMxx44bfD1kFb3phQRs5jIVo8wgUZZaB++OXIkhcAQ32SANwWNG3lYrvAz7BeqJ5F6JcqdUy9ShnVZ5FORXy7kHSWcCj/TzfQyquQvwW+0T7cT5+gNE1JAip3bh26INGUr8aYLWNcNb0RE=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:52::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 18:44:54 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:44:54 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v6 2/2] net: axienet: Use NAPI for TX completion path
Date:   Wed, 11 May 2022 12:44:32 -0600
Message-Id: <20220511184432.1131256-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220511184432.1131256-1-robert.hancock@calian.com>
References: <20220511184432.1131256-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::18) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b395704-9653-4f9a-bc50-08da337e56f3
X-MS-TrafficTypeDiagnostic: YT2PR01MB5427:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB54277D26811B53DE765D1684ECC89@YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvgeatsaRNskiA7aXL3wyxRrtotWVIj9vyG7Ntq6yckJt9TiKIS02T8UN1AfZn2NE4d2D7tGRhA5KqIvtc1+6Xa4/KafRS34E9UuZBvC1b8ffjXQTec9e8mcbZnfVoT+SLobaDY50bWzpv2khS0YAtelZE2lsvqXOy9bgddnO6brz3+8CT9Y9zRndbT5rrfzJNeENkR+jiLQIA0SGdp0HEAfHh2CEBH7cc9gjChTFwSiTKL3Z9iM3bb4TSFZXykO8ha3RZ8U3va94cloxOUh5ELo9oHyhUTrTr8xVibXj0vuu9nWU0MoufmAvOyj8MG8Cq7Z7HjQSOltdCFAYebbDWyX5M55cG6ToUlZnRIgAc8trCX1MpOnQKjXB8RbYPwuoCnoqhVbwtJLcHQstIOTL0/v5HyO1x5Gcg9qtxGzAwGFzbpjRwkWp/v3FIRhMcL/lV+4WuWyyxp3SFf4mZNmOfC1Rn4J2NDFsBgXvdhE+8vzHn1nmG9g7piANOM5PchTzWa9Sw+/wQPcBIcvL5CQA3mGpEPtc9OgpILxXdKFzLO5K8BKe3cd0vwaH6r1FZm16c3sNu7QH3mIMD+uofprFQBN0cGtl6dfulueZhdil8YqJePyQvGVD8hUDHiWo9z9UFlbwXHCNIGdfvUf1jIJ+yBxKg7fyFN2wnhr9Ql/KdKpZTnebL/56OLZAbymCuUePsIgdLyQlFJhwjztzWZJ9mWj8TDsjRAT7b0cgILs0NM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(44832011)(36756003)(8936002)(2616005)(66476007)(6916009)(8676002)(66946007)(4326008)(66556008)(38350700002)(38100700002)(26005)(107886003)(6512007)(6486002)(30864003)(316002)(508600001)(2906002)(5660300002)(186003)(6666004)(52116002)(1076003)(6506007)(86362001)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwabnIXBK3ZYcAvh6wONPiAp+HGKxz5hzLNnrrCGrXj4M27HwEgO6dCqpAp6?=
 =?us-ascii?Q?iY/rvWZhdyIJEuImpRhJKMVfBgyDRNrLWiYxjictaWoQSSTxZUNJjFiWHXC6?=
 =?us-ascii?Q?TqPnIE/CCHTkfIIvOz5pOmg3jmSi1EKz8SPCcet208oxOPxsuUgoJYaMHCp8?=
 =?us-ascii?Q?9EckfrBtctZ2X7F3L2jCgv8CWGu1htTlaZi0lyMpgSgmTVqTb6ww7EjasOhb?=
 =?us-ascii?Q?nzXMk1RGdgZQS4tQu5GzvW6jXmqAs9AWcYQnPMRuk3GEp2v8KNYrUwS3w8Ij?=
 =?us-ascii?Q?jlifhcQZLO7ItbOf3jUCHdovvyp6uve9l7gMCJllzeNv/jvr7IAkjHAcW5ol?=
 =?us-ascii?Q?blq8q2VgTiOQjlW4DgV4/y+jH1paBaWTy8nXIZD2icksdez23iFSsQsfqhlA?=
 =?us-ascii?Q?JF3rNTeWG0InE2FXbQ6zeDo6/d3/sOW4IbpsmRKylwphYBtg9UFHfUp/lMXj?=
 =?us-ascii?Q?29vTQEAuz3GmG9GNXI+Jm1xBa9PjMprgZkryGvDkwTPf561kVtavhq9KuhN8?=
 =?us-ascii?Q?lSKLnNOlOY2PeGQMFHhzHOLU2er2O5OkjiQ0rFCR4C9xoS84oF51K3LuGGDe?=
 =?us-ascii?Q?B6gU88Uwp5uLnxm6hcRjPfsNxFq5HNDYiHDP9tYsuEnMR4JmB3ya3wfiQ+5Z?=
 =?us-ascii?Q?9ZKEqcqGwtmOTCVLcWskEYC0pVF7P6UnJLQDr24oerFkcGKoIA16eXYPZNA8?=
 =?us-ascii?Q?PltMlwzatyM2xCVlhKXGJW7CNBSMCeRd1Z08J6LnAQkcAoN1RTMEUYHqqY0B?=
 =?us-ascii?Q?kIVqvK4+61DdAVFKpSsH3VJRnjrT3HWkNX8DJByFe1AdsuXa8TaPrXq3EVkz?=
 =?us-ascii?Q?O5deXncee5r8WYJ841gNCDbR9aFkJM/olAOn71oPjM3Cu6TMOom7KKlv0/yp?=
 =?us-ascii?Q?7TWM593rv90WZLKW6dvtTjTKi7h/6hFBYfXQ2fwZAkeNEPV9tUwxtKMDy9NV?=
 =?us-ascii?Q?d72Kozr7hDRpZjpQkwljk5gD1t53Dz9mBeRs6aweFMZw/Acp/LUPYG7VNb+9?=
 =?us-ascii?Q?i9KqZ1wunYyrazubqjqHHdbQPd+OyFvEjwTZpOCuJaX0uDho0c/kNOvZqlka?=
 =?us-ascii?Q?+JlOseLoIWCKtm+gVn+7acZj9aX58i2W5XngqqAFTTgCLu/wTtk3kNouo+bq?=
 =?us-ascii?Q?z5YTr1bCLy92kWylxGcA14Me3ZaNYhYFfuTPWrrjAiTSy+/JSW0z6xphVwVq?=
 =?us-ascii?Q?bSqF/URhKRHel5RaNkW5DDCZ6FNFYtM6v/q7ASd+QrCVkIeAXBEx6GZR2nuX?=
 =?us-ascii?Q?P/5Lacw6yXMpmHFDYpUP/K7NBEjtbGDsLcz3H+JssVUT4XaRs49zBlqNZQSw?=
 =?us-ascii?Q?kfgJgawbb2g8hqLX7TbaYZ9AzsRaioukVgtvBn7mBrxjXZLh/YnLHfW0E7lR?=
 =?us-ascii?Q?+pXD3OK5O8hqXSVfxUsT+B3x36cX9inh+4T3tLgOy2m6v+30qKwMH27jFi+4?=
 =?us-ascii?Q?anYrpMomDcgrksdT0K6fjXxsvWvafHAD26vSGRAtVh13vtA80n5BSmJoIDYo?=
 =?us-ascii?Q?a3fwdPvkY0yHGhstUDwmKn07XJ+g/ik3lqB4e7OjRtjhw69ktc5ABuXO8I//?=
 =?us-ascii?Q?cCJlWcf2wPBOdPkUtqdBwiYtacgKp2dHtsXRnhGXCySc/cb9YZk6JNxt4pTx?=
 =?us-ascii?Q?8h5z9qVlRlKOuNJyFlHpm3EbOFilZzNsKs7oTcwFKONTd9inbOR4vFMpVzee?=
 =?us-ascii?Q?Jn/j8p+Slf4JWt+a7sxm8C0KifU30hGKuZ6Ds47+O69/CuiFUQtM+Ew6MsSe?=
 =?us-ascii?Q?DXEJkHzWIe43dizAUt17O+MfMTT7Tgs=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b395704-9653-4f9a-bc50-08da337e56f3
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:44:54.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90ClYVUviZZwp5wn7X4kNVW7+9AJ41Z1jsjUw3V/kIYz8DNE7/rGxCJzOHioF6xseypZJKQEIO+fwC7OTjcEr2+UAZEe9OTielLfK8nL6jA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5427
X-Proofpoint-ORIG-GUID: g2G_gsCZ_8c-Hr_TOi1Jj3uvSQcgA_MW
X-Proofpoint-GUID: g2G_gsCZ_8c-Hr_TOi1Jj3uvSQcgA_MW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  54 +++----
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 142 ++++++++++--------
 2 files changed, 111 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d5c1e5c4a508..4225efbeda3d 100644
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
@@ -396,7 +395,22 @@ struct axidma_bd {
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
+ * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
+ *              to be populated.
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -404,19 +418,6 @@ struct axidma_bd {
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
@@ -436,8 +437,6 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
-	struct napi_struct napi;
-
 	struct mdio_device *pcs_phy;
 	struct phylink_pcs pcs;
 
@@ -453,7 +452,20 @@ struct axienet_local {
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
+	u32 tx_bd_tail;
 
 	struct work_struct dma_err_task;
 
@@ -465,16 +477,6 @@ struct axienet_local {
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
index 2f39eb4de249..1094ffbb92ec 100644
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
@@ -737,14 +732,14 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
  * This function is invoked before BDs are allocated and transmission starts.
  * This function returns 0 if a BD or group of BDs can be allocated for
  * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
+ * returns a busy status.
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
@@ -753,36 +748,51 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 }
 
 /**
- * axienet_start_xmit_done - Invoked once a transmit is completed by the
+ * axienet_tx_poll - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
- * @ndev:	Pointer to the net_device structure
+ * @napi:	Pointer to NAPI structure.
+ * @budget:	Max number of TX packets to process.
+ *
+ * Return: Number of TX packets processed.
  *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
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
+		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
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
@@ -867,8 +877,8 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
-			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
-					      NULL);
+			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
+					      true, NULL, 0);
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
@@ -890,7 +900,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
 		netif_stop_queue(ndev);
 
-		/* Matches barrier in axienet_start_xmit_done */
+		/* Matches barrier in axienet_tx_poll */
 		smp_mb();
 
 		/* Space might have just been freed - check again */
@@ -902,13 +912,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
@@ -917,7 +927,7 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 	dma_addr_t tail_p = 0;
 	struct axidma_bd *cur_p;
 	struct sk_buff *skb, *new_skb;
-	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_rx);
 
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
@@ -1020,8 +1030,8 @@ static int axienet_poll(struct napi_struct *napi, int budget)
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
@@ -1043,7 +1053,15 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
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
@@ -1087,7 +1105,7 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
 		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
-		napi_schedule(&lp->napi);
+		napi_schedule(&lp->napi_rx);
 	}
 
 	return IRQ_HANDLED;
@@ -1163,7 +1181,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
@@ -1190,7 +1209,8 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1214,7 +1234,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
@@ -1735,7 +1756,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
@@ -1801,7 +1823,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 }
 
 /**
@@ -1850,7 +1873,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
-- 
2.31.1

