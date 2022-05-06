Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED451CDD8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 02:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387573AbiEFAdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 20:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352286AbiEFAdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 20:33:44 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E5313D72
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 17:30:01 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2460AQYv025953;
        Thu, 5 May 2022 20:29:43 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2176.outbound.protection.outlook.com [104.47.75.176])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv4370qj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 20:29:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzj3Zm3s9+Jva8gDV8voFFHqsfYWdJkad3lUHFj9MGllDrCFDCAjK56zhKlLfHa2sjwzG1QLFz1G3flE1ejpPZlRJABc961vic96XdNC/3hkQsVjCPBTh4GnKSwGQGFBtuRD4/C/Rw8/5C3Pe+nfu0tTQaJ5FYDxl2O744Iraq64KYirjSICZCMkrn1unEzFeC5+ajFINhkgsv9I4zNme5iLumRAYtF0WvzqrUf4Io93gXFiSSvHvK3tO7f2biNno0NPikOEdiAgqD4AHXsmW4Ggqs50C7XE2uNKhZyQpP0zYftOyrQL90ckjcXFZLfGdC/nqjAZiLjefwoYEt4NFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3MZwoXGkBNu7z0st36WClqqUzct1/UW317a6uhiOvM=;
 b=IKrDIecuWj0Jayb4pAiPE3X+CYUYy1ozbU2/eIyqVIAHDBkl7c0pH7ZgdKxAFObIphfaWjw7/lWY++dTJbGKOajtYWOsQEagBgsMA2G+YV0wN32zXH3kNv+PYHMynUhFbbKdae3AgXMyEX5jJt4AAIJ3lfqRSQfRpZM3GdzjSmATzvs/qgCbQQph7mrwyksJWjA2RYFeqqt/7vBwBYs+tPvIhDt+2r3PvrzLOgTimtDLOsVnrxhuaI8+zZi7UH3pqJvR85jm/ROiJkn5LKV4O1N6b9vChARzI408HA5hAhB+UXEJ7wWsusVdfGW2SN58qx1VI3lfwENGnaT7Ocarxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3MZwoXGkBNu7z0st36WClqqUzct1/UW317a6uhiOvM=;
 b=IPhU1QBa5wRtSxKWfNHDHXBuhP8wHGXiTbuRmHCws8hSz/dX8dD0ldmakVk4xYGc0Ul3MBUmZy67dtNuede0u5wEobDef1AKT0F6yE8J1CQh7fsKhpTCY4I7tatq3rV617oKP5XMR0QwkceEbd6yKMh+PQqkHizwoQqSoZS2knw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YQBPR0101MB8479.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:56::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 6 May
 2022 00:29:41 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:29:40 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4] net: axienet: Use NAPI for TX completion path
Date:   Thu,  5 May 2022 18:29:04 -0600
Message-Id: <20220506002904.4075805-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df931f29-43d8-4c8d-0b5e-08da2ef78281
X-MS-TrafficTypeDiagnostic: YQBPR0101MB8479:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB8479AA524E41DB7BBA4F02E7ECC59@YQBPR0101MB8479.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHpkUmcPi8GFCwvqaayqOrNGFHHeHLvcuJV73w4hWGE2CCZbD+nIASJWa7TupnpjAUfQhczRC1TKJFGQXD+GwzePxawLfznoixAOZYORhlm0BFTeiSnn8u2QqENIUf/dU/RqLmSP6SUc2B3pRIDeLhIriQKqirKqOIfWng9D+E1dTNdp6WSwXEBfu5c45e3qNlx3bUS2S9Pln36tgsE1OaRGQgtj0Ny8oEvUWBM87HinBJ7M5ozl2ZwFj0qSgb0dwAWB/Fgh71d8GFaNIsOGgrdVcQI7mfg51VyPfCo970iK9aHzim7GlirCuB7rumpbG19PIH/ZBNiOXnkgA4B2/mJ06obsQ87Y4SCLecZaX5YRsYRd0qY7KHaPRottSCrcYfU62qD1iPt0liUjjfYcZnlLla7qcoCnygscrKuf/0iq9GO+9qBMhU1+LUncp2Of990m7euwLcZ+56SkY9g645pjCyGubImme3k6Auxw9gN+nqEbvm00uCFTtG9UeXmtjkO0zPDDRwL6klW0Ad5gyMqTYLcOf401CcRcE3NT/xrgtdsJYel0SxNWNvh150l5sxJewqL4Suo0TwFuz8CfCyYqeDa7AItp9pa1Zqzwin6TcQXd4YEVDUXXuZzHQtrhHpFDWTU+OgQgEzBwUBEFO9PJuBM6eNjrqu0Hbo9Ot286WsOcxHocHWOKfS8lN1RL4zVmihu5isybXVnJWIyZsBYNzgfuf9O37n5gkiU7oiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(30864003)(2906002)(38100700002)(44832011)(38350700002)(36756003)(186003)(66556008)(66946007)(1076003)(66476007)(4326008)(2616005)(8676002)(8936002)(6512007)(6486002)(6506007)(52116002)(6916009)(26005)(5660300002)(83380400001)(86362001)(6666004)(508600001)(316002)(375104004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?djzbRtXYgxBL07F7TB4EbWh5b62lBavb1vPS5i/K2NsgnGIT+RlF6l6GoYdJ?=
 =?us-ascii?Q?y+O8cZpGkqhdet643wSuq30sVFhMWpLhpf7C9+1bHEmE5qzg6CP2Yfb2feRu?=
 =?us-ascii?Q?YAf2cBBL6IUVEY/V7KcKVk6w0WQ4esw4Lq7ZDcA1V9Ngd7iS8GFTzJbsN9hM?=
 =?us-ascii?Q?p3cR9u0iOGpeSvVqP7eR3p5sC29qfMtR6j3/4YejEIXvEKVKCjYb1u+qxeyS?=
 =?us-ascii?Q?Ilq0MO+5aowjSXI08UWzfowBwTOrMOtyZ6uWkskkm4/OfCAlTbsqZPTnPwAX?=
 =?us-ascii?Q?3y7jx63RQF5U45m44KGWHjk09FAUZTN9Ini6FVdIDdY04ipVlIW/kWlE8q7L?=
 =?us-ascii?Q?gaKK6zexj+jOJHr4aXI/uohxX3IThPo1jd0TzJLURRaQWJt8IgLghPZBUvlO?=
 =?us-ascii?Q?kX0eN5ed8CDtbajP4N8KE2uXKopGwaCDE5KIkOVxMszGtSTVFtITCPfC8hCX?=
 =?us-ascii?Q?3Y0ggt/JpBt6dVu9EjFM56wQP8i17FKUMDX18CFem1D8efbFAsLACc4h9fux?=
 =?us-ascii?Q?e2GtQjezYJFAWLfChw2hy9IkLG5XusE0caNVBXWoGPT84NS+SZimy+hxrh/m?=
 =?us-ascii?Q?+XVI619keEySmdijFgjRjjiEdSFdVPjXqSAW/GC4oDVqDSNTjzb8fhAW+56p?=
 =?us-ascii?Q?NXo+zvi+QSUhgBWPbiEfdjX7muBUjU18ZBp7cTqt45ZRTzu6NGQWdlvXDt6c?=
 =?us-ascii?Q?Z0XoGbaFP+uLHZp6r3VjYgoB0TMBde52LX0sLwUYHumwpZZm7itQIwO5f8Xq?=
 =?us-ascii?Q?AROeFPpQl8Kb/kf7XHRTE43YXZCA9HMeIdABJIJ1vHJA43ZTyPTnejkn5uBG?=
 =?us-ascii?Q?eUmfnTcc7CErCrQpHwIFqrtLciJw0kdNKsdLwYf+wobM01G6o75DL+aMX7ea?=
 =?us-ascii?Q?laSJkoIjgye8Kcdx/iD0YdMbtV7QvQzrUmKV0aKlXf37mnqCUBSB1fFN2HTF?=
 =?us-ascii?Q?HUF+R/IVwlukEHw14EFYq3JR7ZWpCobw2X0UuuI7TPdP9mvLhNNE9586Osy4?=
 =?us-ascii?Q?9+cjkZ0cys8tpBjvsXV8lYuBEMJ4egYqLtcniZKeu4WVRPEFdO5tUL5c5xMs?=
 =?us-ascii?Q?izAhdkzGN1jEMZcPNqfp9MU1hYY6d5LLOM31+iHJnDnwSA4Fm92NvCqQDcdG?=
 =?us-ascii?Q?TCQ62SFgbGwrA7MD7NhcmLomactGVcYd+WGiqF3h983KWni3BqKuU6V87GBb?=
 =?us-ascii?Q?3jL9vEW7hSZatiwDO6uPfxqzjjAbTaI91xGsu8rzjvkB1WzLNM/wPMn1X/xK?=
 =?us-ascii?Q?lQTxIkwgsxYMP0VHAlga4dTgBH3J7p1/x2cFdLhobZ5qFs8ZG27nx6dVglNM?=
 =?us-ascii?Q?bnvrUFBOneMKMWdul9mrp3hZ9td0MJDRbTGVap/44uTR/F3Na/MdBwsPjHYl?=
 =?us-ascii?Q?O2fAYoqoCmkXiO0bM4IWCbcUu6JMAFGQGmQtfjIqEPK2u+7x0bYEhY9geJ+b?=
 =?us-ascii?Q?q9gXMQj1RrZN9MxgeGAUfLlvDchrcNJGbVODNfcZf/5ce2TOHayESTbXE1vg?=
 =?us-ascii?Q?1Dk2oz01H6zG3FHaCRulZekJE4yr1GHsV+UP2l5kDTH4mREzyXmaBSAHMv6H?=
 =?us-ascii?Q?PCVFIAKyiQ/175gEVp0ACRVGwyfUuGjvl9z9RD/vDEB/ITtvh0wGrJmJdW0B?=
 =?us-ascii?Q?5LQIlP6udK80aqj4jyIYVL1sUZiCqf0hOFwdLZYnv81rpnOoEW4leNzPB2bH?=
 =?us-ascii?Q?sOT++9eXNxziW/aRKnnTrw9llQxSpdydmjqjhLwYsxpHt/pI1Gzr86oWliQl?=
 =?us-ascii?Q?mVdU97ID7mtNKtwbhYxqgOx7zPf65jM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df931f29-43d8-4c8d-0b5e-08da2ef78281
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:29:40.9046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxyXFZm8UMCKxwDz47FXyj7FuDRE0h3YahvVXhNP+GUwcnUiCxe1IFwradoTu4O71nXpEI12XOVqY8xQBVqpbcONBABINh3ZgebEyqF91SY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB8479
X-Proofpoint-ORIG-GUID: 7dlT5t85jIsHddDm4JhGldWwpkykKfR5
X-Proofpoint-GUID: 7dlT5t85jIsHddDm4JhGldWwpkykKfR5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_10,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060000
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

Changed since v3: Fixed references to renamed function in comments

Changed since v2: Use separate TX and RX NAPI poll handlers to keep
completion handling on same CPU as TX/RX IRQ. Added hard/soft IRQ
benchmark information to commit message.

Changed since v1: Added benchmark information to commit message, no
code changes.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  53 +++----
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 138 ++++++++++--------
 2 files changed, 109 insertions(+), 82 deletions(-)

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
index d6fc3f7acdf0..88821f73fb9f 100644
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
@@ -887,7 +897,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
 		netif_stop_queue(ndev);
 
-		/* Matches barrier in axienet_start_xmit_done */
+		/* Matches barrier in axienet_tx_poll */
 		smp_mb();
 
 		/* Space might have just been freed - check again */
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
 
@@ -1017,8 +1027,8 @@ static int axienet_poll(struct napi_struct *napi, int budget)
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

