Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E648351CABF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385930AbiEEUmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385145AbiEEUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:42:10 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A6D5FF35
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:38:28 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245I2BWq017805;
        Thu, 5 May 2022 16:38:08 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2176.outbound.protection.outlook.com [104.47.75.176])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv4370kt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 16:38:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZxc6FB4CSee2kX6JRX6aRolvTKKGm75av4nPKI3wARmC+/YMllwvC7zZi0tjXY2V9feCB30k0Fq3Lzefp15OuA6lAzkjqB+vlfjgVxMyGDfCYQyqFAeO17x9aUy+nFDi8nGQjVELAwrY7NP+eHMf+FNCLLTuG45pStbfYyEqDdF0hqowACGNRs0oJCcRd9qnCp4zYIhTws/ananWXL8YoHhu7FuUOS4xdCT1cH+AXOV5wKPgYY5EZPc4D/W31cWk5JXbXjXSOJGDK7io8/Ae0wfjh6Qi0FzdeGFrRvnJpPnZSXkxWtR8wX6xK7wfgkHdEPs6CAbDCkJ8mfRRBObfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yz3ypnwxhFu3wusTznMSlKVq+ngK2E4Ox1TwCK/zMUo=;
 b=lUA84dNaAu7t4xMeXrvHYW9Dq69zvmPsDLQKnaj4zAFgB/cUXbXNiybMvMteD605lkZBI2DuEZ2n+GQUwvBOQNEfO5J/OjwaWx+c8jPE0jcSIEa4FzTdjkYQ09uAFMw/qmycze86tYUIsPTEDZcdSQ9BUjwZCUxcC6it92Ej2zgMu+nyOWdKXONvPkfgPv92YWVYByBbDEW8IBiG50G8v6OHylXuUURDz/+8E5HZuNa9x9IFg2CmIVI94it3rEEGk/95esVoHmu5ToP0heeL4V+HWVaG5LjQJ3Gh4sdRdQRBhZHxSudQfooKgkPbc4YK9+pKss+g/AiLah8P1JEQqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz3ypnwxhFu3wusTznMSlKVq+ngK2E4Ox1TwCK/zMUo=;
 b=of6OpZrU7KGmswfx/dbMbbjGlpNE/7v+RQoX/s5LNCfapslBpaw697TIsGSmaHrhuyC4hrFAj9qnWlQyOLWpjDhbjsYZcN5CNoHjVukuJYO0w0DKLxkvXCRWVuGmNBfIFtlS8QYqgIkBpBcqB00FaA4ZiI1Gt2ioYbRjPySmr68=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT3PR01MB9802.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:8b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 20:38:06 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 20:38:06 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3] net: axienet: Use NAPI for TX completion path
Date:   Thu,  5 May 2022 14:37:54 -0600
Message-Id: <20220505203754.1905881-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::22) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ac03c0e-7bad-4963-aa10-08da2ed728d4
X-MS-TrafficTypeDiagnostic: YT3PR01MB9802:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB98027E1A6205AE2A3A5D6D58ECC29@YT3PR01MB9802.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nI2C7tjlTYxLw4oWT+WC71NqFab8IaVvg//7XR2OY/c5JkEEVpO0Zr41LcT9N1GBkuzIuutl70IPvvFoHr/rev07SNI+EP7pyua7woKKCAKpkLxBGxJ050iMs7S8aOMaVZp5N2/nSWjZxzBExDgcJ2228S4HWjyzCn/MU9ZsX2Z2o27VkFexRu2PtlMVyWDM11RHz+FtMvTEdgyBBLE+T64dglxbhilJL8STiZcJh283+HCvZqrs2x3uzxE9QQwjoRFsUT+AkNPjdXQ4bNmsnTOxTIv2UWZ2UhhfJZHu/VCq+Uv6DxjEwQd2F5r2S2P74IicXIXfYa+FmOGncA/pZ26o54k6JtqszXWjwt3O7xoVeCfeBgToBlWVMjjxUmpZ0eF/5hDBzg490GC/IKeyA0XYtH06QRoLV6KlB5vWdAtEGTBG8EbqbUEb9fTsY3Fx2tSj6TogCIeshMtRmjYmEdC8SJIku/h1lSz2OhNNWKLs8v5NZR9t8QB4v59qsPKaBsiK4sRuZgojNdB2ex4WfuQWguYYrQCtq67aBORqPXzoBQsi/SBJJIaQyNwedxpaXB4/0C6r9j45FgvUhmDxaJihZEbUVbATFKNiqLJ8WLjodciomu3nVVtaeD6Cr+ZBwozHiCq35JAhEQ3qyG5CvyZResEtMB/4wGdx+quw+fgNfvaSgRuVQlOOmB6Io+TxCF2MS89n2vUzabWVIBjVZVK0g/xJZuQ6y5+k0qX4cQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(52116002)(26005)(6506007)(38100700002)(6512007)(2906002)(83380400001)(1076003)(186003)(8676002)(38350700002)(5660300002)(66556008)(2616005)(107886003)(66476007)(4326008)(66946007)(6486002)(36756003)(8936002)(508600001)(86362001)(6916009)(30864003)(44832011)(316002)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IM1dwFFJ40mKBj84ugAy1hQQG5BD0NJETZwI/4p6sgccNctGQbcXeKvJ0tfN?=
 =?us-ascii?Q?F6EjD/2gyX+gjGw4OGuawN2XmO6oPPSTBkEM9GoPdK3VURs4FVxS2Bc8J0dl?=
 =?us-ascii?Q?GHdTlpHibECHrqPccbUTm00H5bL7mMfzrBwiHxNjbmI5B8PnCv0r27Cl7Ufa?=
 =?us-ascii?Q?PrZy6+MJUIGvT7tp4auOlbJUld70GLPex5HijMfUhxcRSwuAYMe11JdMC0Ey?=
 =?us-ascii?Q?5VL2LT61N9JbB63qIbYLya0T3DEpK+f6Ls3GRSuGnSPZbK4h5sRAQcmCOwM4?=
 =?us-ascii?Q?Gj/YlVWa6OVou4Av49bDj6jlc5s+hi9gYhm8gATQLFfs7IUs4aqeC1CLXldr?=
 =?us-ascii?Q?YJ9DsBZbE/6mUuXT4Bo0OdJfPv2ksENh9W1x5f5Oo4PhTtb4XyDRJ2LqUq/o?=
 =?us-ascii?Q?l1Libowe8n5rpQbsk6cZBxKv5ZiIHlwNv8w7oFvlNRJ8SPb8qYxs6KR36LeT?=
 =?us-ascii?Q?bngtkrtLK7kgs7Y6UB+3zUCJFaubIQXkKPDooEqza/EfSRvXhQgj/pApfLcK?=
 =?us-ascii?Q?77EiJ9grBSBxVutR3+9RsFSn0ZVVQKDgBHrA1t7Gr4ITV1Mfm4wqvRxRoRgL?=
 =?us-ascii?Q?JZTvdtwXBBm+K9H0tRcrwB+wHNg7Jfk0+gTFULL74t9RUrVEfoF72cqWPFqm?=
 =?us-ascii?Q?7t3hvzRgvvLW9557PbHxPoOauPgr1IuSE1FhRUtHMUNOio189O1Cgy7J88IL?=
 =?us-ascii?Q?xcYKyGrvoQYcnEfn4zhBfIZBn0nG7Z2J6OEGUFvP1y66wmp0ySpCpzTNmH+G?=
 =?us-ascii?Q?GqFGR29s/LlvgCTE28HLw1HRRdZCNhrp6T2Tb8NXrH6c/PHECw71I9MPP6oH?=
 =?us-ascii?Q?m5BgngFDYPcwVmzgw1nQwbbzmf93wWVadTgh2Oq0AomBZi5RmXMgcw3hvS3x?=
 =?us-ascii?Q?UauJykXpi6CuHw39TzftOvTqmTnoX4PqEwuhf31Ic02is+i4sugNDTC8ZVCx?=
 =?us-ascii?Q?pVZdjmEHoOvJQJIMtzTqdzHT70he+MPZ7tMdXTThOuvatas5DRCOq0Y5gykF?=
 =?us-ascii?Q?dauqKkWCINrswjiwGYL+1cQ+EgdaEuoPNgUWIJuthEsg+9E6ZgMCoaTbVjXn?=
 =?us-ascii?Q?gtALUtG29nPDXB/ZYeDo+UJm5hIV6QhQ5qY9Lz+BhlOYE8kWqXzxBEhI9Uzp?=
 =?us-ascii?Q?XwbQY+Omeidmsk5p8/pZUwr2F/f2SU2WEkocXk6ttNlUEaZDuMC2bwIhUUex?=
 =?us-ascii?Q?yWErWsdSwbEdvxqrveegQaDs7B25RAC8ezsJgsqo5mxyXzeNyRL+XkdC509q?=
 =?us-ascii?Q?9g7iNFQr7wRXZw1l7ACMYuD+mi/Wkt4x2bhfMF+eiLe75rPo3FVCbrN+LqbD?=
 =?us-ascii?Q?0LV5/6RgaJujEtv5imfiRrbbAi8JuVdsXaQNZVIYOMAHK6hiM4daewR0JrKn?=
 =?us-ascii?Q?TSD5q/GBft11pn3EWamEjhFYF2lB7OociE8huaE0M3309iB4v2RHNX1ePxwb?=
 =?us-ascii?Q?41SRWetRSaYhw40yQQs9UVSpZ4vliBHfEm0m7ehRoh6wdN/32+2gx7UvJw3c?=
 =?us-ascii?Q?0VzHKkdYaA/mQy+BEmCX0JJL09kDb1SYlwEF36smaVlhXFTyUjNbZy8/TbTH?=
 =?us-ascii?Q?c/gIENuU9oJcXgtCytw+aNO3OrFQ/sONyj0F5ejyegAH6sNDr83Ox09M3Sp7?=
 =?us-ascii?Q?2nbvoxo12q7Ne2a+gMqmsuy1XuXj8PEbBq1CVVaGw23076CTF+MFerCcfRDf?=
 =?us-ascii?Q?+2zhTaa5OHGcuHZHbJTXqKS0M5DC9l1fiSKm2YCDEg9b4x6tGHOvALmYVYZ5?=
 =?us-ascii?Q?ExHDZCtzouSw71zgwCHJgJ6S88c3eyE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac03c0e-7bad-4963-aa10-08da2ed728d4
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 20:38:06.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rE9lrg84OcZOl4MdPgvLbCs7HhfI0qey5Kyn39tKjYgaK9qB3ZlQjlxzdS6D7va2PDV57Gk/CdMHqtDo4bZH/yATjfYs28ds3slO4xBQwZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9802
X-Proofpoint-ORIG-GUID: V-G3wyizQPXutCNso2KRhQxIuUPHhE8W
X-Proofpoint-GUID: V-G3wyizQPXutCNso2KRhQxIuUPHhE8W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_09,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050133
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

Changed since v2: Use separate TX and RX NAPI poll handlers to keep
completion handling on same CPU as TX/RX IRQ. Added hard/soft IRQ
benchmark information to commit message.

Changed since v1: Added benchmark information to commit message, no
code changes.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  53 +++----
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 130 +++++++++++-------
 2 files changed, 105 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d5c1e5c4a508..76fdaac13146 100644
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
@@ -396,27 +395,30 @@ struct axidma_bd {
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
+ * @napi_rx:	NAPI RX control structure
  * @rx_dma_cr:  Nominal content of RX DMA control register
- * @dma_err_task: Work structure to process Axi DMA errors
- * @tx_irq:	Axidma TX IRQ number
- * @rx_irq:	Axidma RX IRQ number
- * @eth_irq:	Ethernet core IRQ number
- * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
- * @options:	AxiEthernet option word
- * @features:	Stores the extended features supported by the axienet hw
- * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
- * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
- * @tx_bd_num:	Size of TX buffer descriptor ring
  * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
  * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
  * @rx_bd_num:	Size of RX buffer descriptor ring
+ * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
+ *		accessed currently.
+ * @napi_tx:	NAPI TX control structure
+ * @tx_dma_cr:  Nominal content of TX DMA control register
+ * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
+ * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
+ * @tx_bd_num:	Size of TX buffer descriptor ring
  * @tx_bd_ci:	Stores the index of the Tx buffer descriptor in the ring being
  *		accessed currently. Used while alloc. BDs before a TX starts
  * @tx_bd_tail:	Stores the index of the Tx buffer descriptor in the ring being
  *		accessed currently. Used while processing BDs after the TX
  *		completed.
- * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
- *		accessed currently.
+ * @dma_err_task: Work structure to process Axi DMA errors
+ * @tx_irq:	Axidma TX IRQ number
+ * @rx_irq:	Axidma RX IRQ number
+ * @eth_irq:	Ethernet core IRQ number
+ * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
+ * @options:	AxiEthernet option word
+ * @features:	Stores the extended features supported by the axienet hw
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
 
@@ -453,7 +453,20 @@ struct axienet_local {
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
 
@@ -465,16 +478,6 @@ struct axienet_local {
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
index d6fc3f7acdf0..a68856fc881c 100644
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
@@ -755,34 +750,49 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 /**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
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
@@ -864,8 +874,8 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
-			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
-					      NULL);
+			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
+					      true, NULL, 0);
 			lp->tx_bd_tail = orig_tail_ptr;
 
 			return NETDEV_TX_OK;
@@ -899,13 +909,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
@@ -914,7 +924,7 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 	dma_addr_t tail_p = 0;
 	struct axidma_bd *cur_p;
 	struct sk_buff *skb, *new_skb;
-	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_rx);
 
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
@@ -1040,7 +1050,15 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
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
@@ -1084,7 +1102,7 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
 		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
-		napi_schedule(&lp->napi);
+		napi_schedule(&lp->napi_rx);
 	}
 
 	return IRQ_HANDLED;
@@ -1160,7 +1178,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
@@ -1187,7 +1206,8 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1211,7 +1231,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
@@ -1732,7 +1753,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
-	napi_disable(&lp->napi);
+	napi_disable(&lp->napi_tx);
+	napi_disable(&lp->napi_rx);
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
@@ -1798,7 +1820,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
-	napi_enable(&lp->napi);
+	napi_enable(&lp->napi_rx);
+	napi_enable(&lp->napi_tx);
 }
 
 /**
@@ -1847,7 +1870,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
-- 
2.31.1

