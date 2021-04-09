Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB97635A582
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhDISPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:15:01 -0400
Received: from mail-eopbgr680060.outbound.protection.outlook.com ([40.107.68.60]:15104
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234490AbhDISO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:14:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/JFTHw3X3iDW1TV8XhrJOXLUbn6nkHg2EILyVfpCeQTuibQ7M1yKN5j0KRir7C2sOTxZHwVmyh/FlOW8N7zyBHMwyzPE5dDoglqVzqhb1Cchz6+iqO1ocbdfNDu50mxrxWIVM/lp/L1+9kKka9Yivth0zrn7M0r4XG82Rr78+/vVvO6nvguqurj+zg3aOx4kLAeycBY+7oVjR6cwwn8ycqhciisqBDxcS3dhk9CLQ/nEtMIOHbefHVwbnB+HmJfJvo5JAZYAAU3bGac1DHItjNktWGvn87FCXLUHXLj472lzcGMQ1bPWvmstDhn49/Fqba0y/7jIKHVK7hhZjm6/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wWpmp7xNB9LNWxAwety4I4p01FrThYayvRYW0FH/74=;
 b=lF2OkcSOT0b8318bMjhTsmDYD6nvLzrTgL4o/UqkvkNeGSsafR3rZQnl7r7gFycEOQPCkjbtq70Wb4T+9vij/eilVNXjuv3vI3/84lZ4Xmb/ed4qbfw23OB2+23JufG4evUowyT15zaoNh6LsvRSSKRAMNgORtK0/MFCF8cqGP+6JIoWmJ1NT/ZjHjnSzN4cOZoF88X7Z35Jscxa78AqNaW99KEYDPs/Cmbkk0lP7KmzKc/bWAsI0h/WAIQsn1ngAAj7LKSkbh9I57wZo8ds+2xgZbiXrVfoq6/wKHZrGx1lMj/szbdeKl4fnlSUi6fKpK47nFMbJSjFT3uXQitRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wWpmp7xNB9LNWxAwety4I4p01FrThYayvRYW0FH/74=;
 b=Qr3JgtZY9VsTCF1OwI4aWi4dm6HGPxd5qMLYTlZrhzeKT0BtwtZLHxOW7dbbtTcVSIXkjkLV6DhgUUc4i/Z7r1oZWJ99E4MCkERnM+mqC0c3jHJvRoewoQu/BoaFa6X3fdXVvfuZmINfx/0PT3cFBspVn5jZp1nt1+jUoICNjcE=
Received: from BL1PR13CA0259.namprd13.prod.outlook.com (2603:10b6:208:2ba::24)
 by BYAPR02MB5685.namprd02.prod.outlook.com (2603:10b6:a03:9f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Fri, 9 Apr
 2021 18:14:38 +0000
Received: from BL2NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:2ba:cafe::7f) by BL1PR13CA0259.outlook.office365.com
 (2603:10b6:208:2ba::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend
 Transport; Fri, 9 Apr 2021 18:14:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT016.mail.protection.outlook.com (10.152.77.171) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 18:14:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:14:11 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2106.2 via Frontend Transport; Fri, 9 Apr 2021 11:14:11 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 vkoul@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=33570 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1lUvdx-0003FA-KG; Fri, 09 Apr 2021 11:14:10 -0700
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 2B83F121724; Fri,  9 Apr 2021 23:43:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <vkoul@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [RFC PATCH 3/3] net: axienet: Introduce dmaengine support
Date:   Fri, 9 Apr 2021 23:43:22 +0530
Message-ID: <1617992002-38028-4-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac49bc25-7a52-41e9-daaf-08d8fb835675
X-MS-TrafficTypeDiagnostic: BYAPR02MB5685:
X-Microsoft-Antispam-PRVS: <BYAPR02MB5685C8C48355203D89D5E55EC7739@BYAPR02MB5685.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gp9iIgxqMWzgqeIkbUxL0QXHr37wkTmzOgzKo+9LU6GvAl6HMZSWExSpt6e+EGmPBZhiF92YInSs94b1vZTUDsDyeaqESqrie/alqukFAZ//2slrCsJiR0iwJyYN6BF4OOFQ9wK9/H1i9zQU+aXPXdWbim3/9szGG6NuFVxXHPPupVV6L16rlHAnuFxTARONqUcVNGdJGaR9VTWGrVelWa5XyHyS5Um8uz+GbUhd0P9iZvEhkv2fT4esNNBaxwL+wvUVKF2bJJdTevGL0Prp7wxq5/0rjLxCadE0ECIRiadloZ/YhQxCOuWwaz7skmNPYd9syiU5RcjtE419SFnAlUvRFu272O0I32Xr+DseECLKkywOH8Tv07LRZcuvqrHbVRsa5Wm5ElMsMgaz4upLiMJe29ML9IGZqTU+Y4YNoSyDz56jKOwF4DLcF40TWIUs1eoeTweZPFUe0UTtjYyvEDreAyKZHH2sG9y4GiDFhVvhI70tC/SDPhjmNECanokUrlSOxGSI/9UcgoLUOQQFvPw3Y7teXG6fK0+rS7hvQXT/NiKlr6Z7P524LfY7Jgdo5BlW9V2p3v5zJ4/D754QEGbjo3MnyWwCEQeqjM9dVu2/oM8oOxE2GeiJzCC2RJ6xPjGbyqh8YfIyRwhiMFJgnkx3aYT7ZfmiL9jXv4LmOE1ecoFyfVvwiBTB1QsViy9Ov00bvwIVw4RGQRH6L7/k7KQwlwdD8DhPYIrbAB5ngNYBg9rzDUxDL9+gnjlsrGE4uwvb25TGkAKQxJy+umPWE6olrYxuuJc1FYKGZpyZknY=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(346002)(376002)(36840700001)(46966006)(2616005)(6666004)(4326008)(107886003)(186003)(478600001)(336012)(36860700001)(2906002)(6266002)(70206006)(36756003)(426003)(82310400003)(70586007)(47076005)(356005)(316002)(82740400003)(26005)(110136005)(8676002)(966005)(5660300002)(42186006)(30864003)(54906003)(8936002)(36906005)(83380400001)(7636003)(102446001)(375104004)(559001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 18:14:38.1377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac49bc25-7a52-41e9-daaf-08d8fb835675
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT016.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axiethernet driver have in-built dma programming. The aim is to remove
axiethernet axidma programming and instead use the dmaengine framework to
communicate with existing xilinx DMAengine controller(xilinx_dma) driver.

This initial version is a proof of concept and validated with ping test.
There is an anticipated performance impact due to adoption of dmaengine
framework. The plan is to revisit it once all required functional
features are implemented.

The dmaengine framework was extended for metadata API support during the
axidma RFC[1] discussion. However it still need further enhancements to
make it well suited for ethernet usecases. The ethernet features i.e
ethtool set/get of DMA IP properties, ndo_poll_controller, trigger
reset of DMA IP from ethernet are not supported (mentioned in TODO)
and it requires follow-up discussion and dma framework enhancement.

[1]: https://lore.kernel.org/lkml/1522665546-10035-1-git-send-email-radheys@xilinx.com
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  141 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1050 ++++-----------------
 2 files changed, 185 insertions(+), 1006 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1e966a39967e..1baa75d07f94 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -70,76 +70,10 @@
 				 XAE_OPTION_RXEN)
 
 /* Axi DMA Register definitions */
-
-#define XAXIDMA_TX_CR_OFFSET	0x00000000 /* Channel control */
-#define XAXIDMA_TX_SR_OFFSET	0x00000004 /* Status */
-#define XAXIDMA_TX_CDESC_OFFSET	0x00000008 /* Current descriptor pointer */
-#define XAXIDMA_TX_TDESC_OFFSET	0x00000010 /* Tail descriptor pointer */
-
-#define XAXIDMA_RX_CR_OFFSET	0x00000030 /* Channel control */
-#define XAXIDMA_RX_SR_OFFSET	0x00000034 /* Status */
-#define XAXIDMA_RX_CDESC_OFFSET	0x00000038 /* Current descriptor pointer */
-#define XAXIDMA_RX_TDESC_OFFSET	0x00000040 /* Tail descriptor pointer */
-
-#define XAXIDMA_CR_RUNSTOP_MASK	0x00000001 /* Start/stop DMA channel */
-#define XAXIDMA_CR_RESET_MASK	0x00000004 /* Reset DMA engine */
-
-#define XAXIDMA_SR_HALT_MASK	0x00000001 /* Indicates DMA channel halted */
-
-#define XAXIDMA_BD_NDESC_OFFSET		0x00 /* Next descriptor pointer */
-#define XAXIDMA_BD_BUFA_OFFSET		0x08 /* Buffer address */
-#define XAXIDMA_BD_CTRL_LEN_OFFSET	0x18 /* Control/buffer length */
-#define XAXIDMA_BD_STS_OFFSET		0x1C /* Status */
-#define XAXIDMA_BD_USR0_OFFSET		0x20 /* User IP specific word0 */
-#define XAXIDMA_BD_USR1_OFFSET		0x24 /* User IP specific word1 */
-#define XAXIDMA_BD_USR2_OFFSET		0x28 /* User IP specific word2 */
-#define XAXIDMA_BD_USR3_OFFSET		0x2C /* User IP specific word3 */
-#define XAXIDMA_BD_USR4_OFFSET		0x30 /* User IP specific word4 */
-#define XAXIDMA_BD_ID_OFFSET		0x34 /* Sw ID */
-#define XAXIDMA_BD_HAS_STSCNTRL_OFFSET	0x38 /* Whether has stscntrl strm */
-#define XAXIDMA_BD_HAS_DRE_OFFSET	0x3C /* Whether has DRE */
-
-#define XAXIDMA_BD_HAS_DRE_SHIFT	8 /* Whether has DRE shift */
-#define XAXIDMA_BD_HAS_DRE_MASK		0xF00 /* Whether has DRE mask */
-#define XAXIDMA_BD_WORDLEN_MASK		0xFF /* Whether has DRE mask */
-
-#define XAXIDMA_BD_CTRL_LENGTH_MASK	0x007FFFFF /* Requested len */
-#define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
-#define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
-#define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
-
-#define XAXIDMA_DELAY_MASK		0xFF000000 /* Delay timeout counter */
-#define XAXIDMA_COALESCE_MASK		0x00FF0000 /* Coalesce counter */
-
-#define XAXIDMA_DELAY_SHIFT		24
-#define XAXIDMA_COALESCE_SHIFT		16
-
-#define XAXIDMA_IRQ_IOC_MASK		0x00001000 /* Completion intr */
-#define XAXIDMA_IRQ_DELAY_MASK		0x00002000 /* Delay interrupt */
-#define XAXIDMA_IRQ_ERROR_MASK		0x00004000 /* Error interrupt */
-#define XAXIDMA_IRQ_ALL_MASK		0x00007000 /* All interrupts */
-
-/* Default TX/RX Threshold and waitbound values for SGDMA mode */
-#define XAXIDMA_DFT_TX_THRESHOLD	24
-#define XAXIDMA_DFT_TX_WAITBOUND	254
-#define XAXIDMA_DFT_RX_THRESHOLD	24
-#define XAXIDMA_DFT_RX_WAITBOUND	254
-
-#define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
-#define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
-#define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
-
-#define XAXIDMA_BD_STS_ACTUAL_LEN_MASK	0x007FFFFF /* Actual len */
-#define XAXIDMA_BD_STS_COMPLETE_MASK	0x80000000 /* Completed */
-#define XAXIDMA_BD_STS_DEC_ERR_MASK	0x40000000 /* Decode error */
-#define XAXIDMA_BD_STS_SLV_ERR_MASK	0x20000000 /* Slave error */
-#define XAXIDMA_BD_STS_INT_ERR_MASK	0x10000000 /* Internal err */
-#define XAXIDMA_BD_STS_ALL_ERR_MASK	0x70000000 /* All errors */
-#define XAXIDMA_BD_STS_RXSOF_MASK	0x08000000 /* First rx pkt */
-#define XAXIDMA_BD_STS_RXEOF_MASK	0x04000000 /* Last rx pkt */
-#define XAXIDMA_BD_STS_ALL_MASK		0xFC000000 /* All status bits */
-
-#define XAXIDMA_BD_MINIMUM_ALIGNMENT	0x40
+#define XAXIDMA_DFT_TX_THRESHOLD        24
+#define XAXIDMA_DFT_TX_WAITBOUND        254
+#define XAXIDMA_DFT_RX_THRESHOLD        24
+#define XAXIDMA_DFT_RX_WAITBOUND        254
 
 /* Axi Ethernet registers definition */
 #define XAE_RAF_OFFSET		0x00000000 /* Reset and Address filter */
@@ -344,39 +278,6 @@
 #define XLNX_MII_STD_SELECT_SGMII	BIT(0)
 
 /**
- * struct axidma_bd - Axi Dma buffer descriptor layout
- * @next:         MM2S/S2MM Next Descriptor Pointer
- * @next_msb:     MM2S/S2MM Next Descriptor Pointer (high 32 bits)
- * @phys:         MM2S/S2MM Buffer Address
- * @phys_msb:     MM2S/S2MM Buffer Address (high 32 bits)
- * @reserved3:    Reserved and not used
- * @reserved4:    Reserved and not used
- * @cntrl:        MM2S/S2MM Control value
- * @status:       MM2S/S2MM Status value
- * @app0:         MM2S/S2MM User Application Field 0.
- * @app1:         MM2S/S2MM User Application Field 1.
- * @app2:         MM2S/S2MM User Application Field 2.
- * @app3:         MM2S/S2MM User Application Field 3.
- * @app4:         MM2S/S2MM User Application Field 4.
- */
-struct axidma_bd {
-	u32 next;	/* Physical address of next buffer descriptor */
-	u32 next_msb;	/* high 32 bits for IP >= v7.1, reserved on older IP */
-	u32 phys;
-	u32 phys_msb;	/* for IP >= v7.1, reserved for older IP */
-	u32 reserved3;
-	u32 reserved4;
-	u32 cntrl;
-	u32 status;
-	u32 app0;
-	u32 app1;	/* TX start << 16 | insert */
-	u32 app2;	/* TX csum seed */
-	u32 app3;
-	u32 app4;   /* Last field used by HW */
-	struct sk_buff *skb;
-} __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);
-
-/**
  * struct axienet_local - axienet private per device data
  * @ndev:	Pointer for net_device to which it will be attached.
  * @dev:	Pointer to device structure
@@ -390,27 +291,12 @@ struct axidma_bd {
  * @mii_clk_div: MII bus clock divider value
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
- * @dma_regs:	Base address for the axidma device address space
- * @dma_err_task: Work structure to process Axi DMA errors
- * @tx_irq:	Axidma TX IRQ number
- * @rx_irq:	Axidma RX IRQ number
  * @eth_irq:	Ethernet core IRQ number
  * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
  * @options:	AxiEthernet option word
  * @features:	Stores the extended features supported by the axienet hw
- * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
- * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
  * @tx_bd_num:	Size of TX buffer descriptor ring
- * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
- * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
  * @rx_bd_num:	Size of RX buffer descriptor ring
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
@@ -420,6 +306,9 @@ struct axidma_bd {
  * @csum_offload_on_rx_path:	Stores the checksum selection on RX side.
  * @coalesce_count_rx:	Store the irq coalesce on RX side.
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
+ * @tx_chan: TX DMA channel.
+ * @rx_chan: RX DMA channel.
+ * @skb_cache: Custom skb slab allocator.
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -441,27 +330,15 @@ struct axienet_local {
 
 	resource_size_t regs_start;
 	void __iomem *regs;
-	void __iomem *dma_regs;
-
-	struct work_struct dma_err_task;
 
-	int tx_irq;
-	int rx_irq;
 	int eth_irq;
 	phy_interface_t phy_mode;
 
 	u32 options;
 	u32 features;
 
-	struct axidma_bd *tx_bd_v;
-	dma_addr_t tx_bd_p;
 	u32 tx_bd_num;
-	struct axidma_bd *rx_bd_v;
-	dma_addr_t rx_bd_p;
 	u32 rx_bd_num;
-	u32 tx_bd_ci;
-	u32 tx_bd_tail;
-	u32 rx_bd_ci;
 
 	u32 max_frm_size;
 	u32 rxmem;
@@ -471,6 +348,10 @@ struct axienet_local {
 
 	u32 coalesce_count_rx;
 	u32 coalesce_count_tx;
+
+	struct dma_chan *tx_chan;
+	struct dma_chan *rx_chan;
+	struct kmem_cache *skb_cache;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3a8775e0ca55..2f166b87d038 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -15,7 +15,6 @@
  *
  * TODO:
  *  - Add Axi Fifo support.
- *  - Factor out Axi DMA code into separate driver.
  *  - Test and fix basic multicast filtering.
  *  - Add support for extended multicast filtering.
  *  - Test basic VLAN support.
@@ -37,14 +36,17 @@
 #include <linux/phy.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 
 #include "xilinx_axienet.h"
 
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
-#define RX_BD_NUM_DEFAULT		1024
+#define RX_BD_NUM_DEFAULT		128
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
+#define DMA_NUM_APP_WORDS		5
 
 /* Must be shorter than length of ethtool_drvinfo.driver field to fit */
 #define DRIVER_NAME		"xaxienet"
@@ -118,232 +120,131 @@ static struct axienet_option axienet_options[] = {
 	{}
 };
 
-/**
- * axienet_dma_in32 - Memory mapped Axi DMA register read
- * @lp:		Pointer to axienet local structure
- * @reg:	Address offset from the base address of the Axi DMA core
- *
- * Return: The contents of the Axi DMA register
- *
- * This function returns the contents of the corresponding Axi DMA register.
- */
-static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
+struct axi_skbuff {
+	struct sk_buff *skb;
+	struct scatterlist sgl[MAX_SKB_FRAGS + 1];
+	dma_addr_t dma_address;
+	int sg_len;
+	struct dma_async_tx_descriptor *desc;
+} __packed;
+
+static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result);
+static int axienet_rx_submit_desc(struct net_device *ndev)
 {
-	return ioread32(lp->dma_regs + reg);
-}
+	struct axienet_local *lp = netdev_priv(ndev);
+	struct dma_async_tx_descriptor *dma_rx_desc = NULL;
+	struct axi_skbuff *axi_skb;
+	struct sk_buff *skb;
+	dma_addr_t addr;
+	int ret;
 
-/**
- * axienet_dma_out32 - Memory mapped Axi DMA register write.
- * @lp:		Pointer to axienet local structure
- * @reg:	Address offset from the base address of the Axi DMA core
- * @value:	Value to be written into the Axi DMA register
- *
- * This function writes the desired value into the corresponding Axi DMA
- * register.
- */
-static inline void axienet_dma_out32(struct axienet_local *lp,
-				     off_t reg, u32 value)
-{
-	iowrite32(value, lp->dma_regs + reg);
-}
+	axi_skb = kmem_cache_alloc(lp->skb_cache, GFP_KERNEL);
+	if (!axi_skb)
+		return -ENOMEM;
 
-static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
-				 dma_addr_t addr)
-{
-	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+	skb = netdev_alloc_skb(ndev, lp->max_frm_size);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto rx_bd_init_skb;
+	}
 
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
-}
+	sg_init_table(axi_skb->sgl, 1);
+	addr = dma_map_single(lp->dev, skb->data, lp->max_frm_size, DMA_FROM_DEVICE);
+	sg_dma_address(axi_skb->sgl) = addr;
+	sg_dma_len(axi_skb->sgl) = lp->max_frm_size;
 
-static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
-			       struct axidma_bd *desc)
-{
-	desc->phys = lower_32_bits(addr);
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		desc->phys_msb = upper_32_bits(addr);
-}
+	dma_rx_desc = dmaengine_prep_slave_sg(lp->rx_chan, axi_skb->sgl,
+					      1, DMA_DEV_TO_MEM,
+					      DMA_PREP_INTERRUPT);
+	if (!dma_rx_desc) {
+		ret = -EINVAL;
+		goto rx_bd_init_prep_sg;
+	}
 
-static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
-				     struct axidma_bd *desc)
-{
-	dma_addr_t ret = desc->phys;
+	axi_skb->skb = skb;
+	axi_skb->dma_address = sg_dma_address(axi_skb->sgl);
+	axi_skb->desc = dma_rx_desc;
+	dma_rx_desc->callback_param =  axi_skb;
+	dma_rx_desc->callback_result = axienet_dma_rx_cb;
+	dmaengine_submit(dma_rx_desc);
 
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		ret |= ((dma_addr_t)desc->phys_msb << 16) << 16;
+	return 0;
 
+rx_bd_init_prep_sg:
+	dma_unmap_single(lp->dev, addr, lp->max_frm_size, DMA_FROM_DEVICE);
+	dev_kfree_skb(skb);
+rx_bd_init_skb:
+	kmem_cache_free(lp->skb_cache, axi_skb);
 	return ret;
-}
-
-/**
- * axienet_dma_bd_release - Release buffer descriptor rings
- * @ndev:	Pointer to the net_device structure
- *
- * This function is used to release the descriptors allocated in
- * axienet_dma_bd_init. axienet_dma_bd_release is called when Axi Ethernet
- * driver stop api is called.
- */
-static void axienet_dma_bd_release(struct net_device *ndev)
-{
-	int i;
-	struct axienet_local *lp = netdev_priv(ndev);
-
-	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(ndev->dev.parent,
-			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
-			  lp->tx_bd_v,
-			  lp->tx_bd_p);
-
-	if (!lp->rx_bd_v)
-		return;
-
-	for (i = 0; i < lp->rx_bd_num; i++) {
-		dma_addr_t phys;
-
-		/* A NULL skb means this descriptor has not been initialised
-		 * at all.
-		 */
-		if (!lp->rx_bd_v[i].skb)
-			break;
 
-		dev_kfree_skb(lp->rx_bd_v[i].skb);
-
-		/* For each descriptor, we programmed cntrl with the (non-zero)
-		 * descriptor size, after it had been successfully allocated.
-		 * So a non-zero value in there means we need to unmap it.
-		 */
-		if (lp->rx_bd_v[i].cntrl) {
-			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(ndev->dev.parent, phys,
-					 lp->max_frm_size, DMA_FROM_DEVICE);
-		}
-	}
+};
 
-	dma_free_coherent(ndev->dev.parent,
-			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-			  lp->rx_bd_v,
-			  lp->rx_bd_p);
+static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
+{
+	struct axi_skbuff *axi_skb = data;
+	struct sk_buff *skb = axi_skb->skb;
+	struct net_device *netdev = skb->dev;
+	struct axienet_local *lp = netdev_priv(netdev);
+	u32 *app;
+	size_t meta_len, meta_max_len, rx_len;
+
+	app  = dmaengine_desc_get_metadata_ptr(axi_skb->desc, &meta_len, &meta_max_len);
+	dma_unmap_single(lp->dev, axi_skb->dma_address, lp->max_frm_size,
+			 DMA_FROM_DEVICE);
+	/* TODO: Derive app word index programmatically */
+	rx_len = (app[4] & 0xFFFF);
+	skb_put(skb, rx_len);
+	skb->protocol = eth_type_trans(skb, netdev);
+	skb->ip_summed = CHECKSUM_NONE;
+
+	netif_rx(skb);
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	netdev->stats.rx_packets++;
+	netdev->stats.rx_bytes += rx_len;
+	axienet_rx_submit_desc(netdev);
+	dma_async_issue_pending(lp->rx_chan);
 }
 
-/**
- * axienet_dma_bd_init - Setup buffer descriptor rings for Axi DMA
- * @ndev:	Pointer to the net_device structure
- *
- * Return: 0, on success -ENOMEM, on failure
- *
- * This function is called to initialize the Rx and Tx DMA descriptor
- * rings. This initializes the descriptors with required default values
- * and is called when Axi Ethernet driver reset is called.
- */
-static int axienet_dma_bd_init(struct net_device *ndev)
+static int axienet_setup_dma_chan(struct net_device *ndev)
 {
-	u32 cr;
-	int i;
-	struct sk_buff *skb;
 	struct axienet_local *lp = netdev_priv(ndev);
+	int i, ret;
 
-	/* Reset the indexes which are used for accessing the BDs */
-	lp->tx_bd_ci = 0;
-	lp->tx_bd_tail = 0;
-	lp->rx_bd_ci = 0;
-
-	/* Allocate the Tx and Rx buffer descriptors. */
-	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
-					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
-					 &lp->tx_bd_p, GFP_KERNEL);
-	if (!lp->tx_bd_v)
-		return -ENOMEM;
-
-	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
-					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-					 &lp->rx_bd_p, GFP_KERNEL);
-	if (!lp->rx_bd_v)
-		goto out;
-
-	for (i = 0; i < lp->tx_bd_num; i++) {
-		dma_addr_t addr = lp->tx_bd_p +
-				  sizeof(*lp->tx_bd_v) *
-				  ((i + 1) % lp->tx_bd_num);
-
-		lp->tx_bd_v[i].next = lower_32_bits(addr);
-		if (lp->features & XAE_FEATURE_DMA_64BIT)
-			lp->tx_bd_v[i].next_msb = upper_32_bits(addr);
+	lp->tx_chan = dma_request_chan(lp->dev, "tx_chan0");
+	if (IS_ERR(lp->tx_chan)) {
+		ret = PTR_ERR(lp->tx_chan);
+		if (ret != -EPROBE_DEFER)
+			netdev_err(ndev, "No Ethernet DMA (TX) channel found\n");
+		return ret;
 	}
 
-	for (i = 0; i < lp->rx_bd_num; i++) {
-		dma_addr_t addr;
-
-		addr = lp->rx_bd_p + sizeof(*lp->rx_bd_v) *
-			((i + 1) % lp->rx_bd_num);
-		lp->rx_bd_v[i].next = lower_32_bits(addr);
-		if (lp->features & XAE_FEATURE_DMA_64BIT)
-			lp->rx_bd_v[i].next_msb = upper_32_bits(addr);
-
-		skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
-		if (!skb)
-			goto out;
-
-		lp->rx_bd_v[i].skb = skb;
-		addr = dma_map_single(ndev->dev.parent, skb->data,
-				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, addr)) {
-			netdev_err(ndev, "DMA mapping error\n");
-			goto out;
-		}
-		desc_set_phys_addr(lp, addr, &lp->rx_bd_v[i]);
+	lp->rx_chan = dma_request_chan(lp->dev, "rx_chan0");
+	if (IS_ERR(lp->rx_chan)) {
+		ret = PTR_ERR(lp->rx_chan);
+		if (ret != -EPROBE_DEFER)
+			netdev_err(ndev, "No Ethernet DMA (RX) channel found\n");
+		goto err_dma_request_rx;
+	}
 
-		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
+	lp->skb_cache = kmem_cache_create("ethernet", sizeof(struct axi_skbuff),
+					  0, 0, NULL);
+	if (!lp->skb_cache) {
+		ret =  -ENOMEM;
+		goto err_kmem;
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
+	/* TODO: Instead of BD_NUM_DEFAULT use runtime support*/
+	for (i = 0; i < RX_BD_NUM_DEFAULT; i++)
+		axienet_rx_submit_desc(ndev);
+	dma_async_issue_pending(lp->rx_chan);
 
 	return 0;
-out:
-	axienet_dma_bd_release(ndev);
-	return -ENOMEM;
+
+err_kmem:
+	dma_release_channel(lp->rx_chan);
+err_dma_request_rx:
+	dma_release_channel(lp->tx_chan);
+	return ret;
 }
 
 /**
@@ -494,32 +395,6 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 	lp->options |= options;
 }
 
-static int __axienet_device_reset(struct axienet_local *lp)
-{
-	u32 timeout;
-
-	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
-	 * process of Axi DMA takes a while to complete as all pending
-	 * commands/transfers will be flushed or completed during this
-	 * reset process.
-	 * Note that even though both TX and RX have their own reset register,
-	 * they both reset the entire DMA core, so only one needs to be used.
-	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
-				XAXIDMA_CR_RESET_MASK) {
-		udelay(1);
-		if (--timeout == 0) {
-			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
-				   __func__);
-			return -ETIMEDOUT;
-		}
-	}
-
-	return 0;
-}
-
 /**
  * axienet_device_reset - Reset and initialize the Axi Ethernet hardware.
  * @ndev:	Pointer to the net_device structure
@@ -536,11 +411,8 @@ static int axienet_device_reset(struct net_device *ndev)
 {
 	u32 axienet_status;
 	struct axienet_local *lp = netdev_priv(ndev);
-	int ret;
 
-	ret = __axienet_device_reset(lp);
-	if (ret)
-		return ret;
+	/* TODO: Request DMA RESET */
 
 	lp->max_frm_size = XAE_MAX_VLAN_FRAME_SIZE;
 	lp->options |= XAE_OPTION_VLAN;
@@ -555,13 +427,7 @@ static int axienet_device_reset(struct net_device *ndev)
 			lp->options |= XAE_OPTION_JUMBO;
 	}
 
-	ret = axienet_dma_bd_init(ndev);
-	if (ret) {
-		netdev_err(ndev, "%s: descriptor allocation failed\n",
-			   __func__);
-		return ret;
-	}
-
+	/* TODO: BD initialization */
 	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
 	axienet_status &= ~XAE_RCW1_RX_MASK;
 	axienet_iow(lp, XAE_RCW1_OFFSET, axienet_status);
@@ -589,116 +455,28 @@ static int axienet_device_reset(struct net_device *ndev)
 }
 
 /**
- * axienet_free_tx_chain - Clean up a series of linked TX descriptors.
- * @ndev:	Pointer to the net_device structure
- * @first_bd:	Index of first descriptor to clean up
- * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
- * @sizep:	Pointer to a u32 filled with the total sum of all bytes
- * 		in all cleaned-up descriptors. Ignored if NULL.
- *
- * Would either be called after a successful transmit operation, or after
- * there was an error when setting up the chain.
- * Returns the number of descriptors handled.
+ * axienet_dma_tx_cb - DMA engine callback for TX channel.
+ * @data:       Pointer to the net_device structure
+ * @result:     error reporting through dmaengine_result.
+ * This function is called by dmaengine driver for TX channel to notify
+ * that the transmit is done.
  */
-static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
-				 int nr_bds, u32 *sizep)
-{
-	struct axienet_local *lp = netdev_priv(ndev);
-	struct axidma_bd *cur_p;
-	int max_bds = nr_bds;
-	unsigned int status;
-	dma_addr_t phys;
-	int i;
-
-	if (max_bds == -1)
-		max_bds = lp->tx_bd_num;
-
-	for (i = 0; i < max_bds; i++) {
-		cur_p = &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
-		status = cur_p->status;
-
-		/* If no number is given, clean up *all* descriptors that have
-		 * been completed by the MAC.
-		 */
-		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			break;
-
-		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys,
-				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
-				 DMA_TO_DEVICE);
-
-		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			dev_consume_skb_irq(cur_p->skb);
-
-		cur_p->cntrl = 0;
-		cur_p->app0 = 0;
-		cur_p->app1 = 0;
-		cur_p->app2 = 0;
-		cur_p->app4 = 0;
-		cur_p->status = 0;
-		cur_p->skb = NULL;
-
-		if (sizep)
-			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
-	}
-
-	return i;
-}
 
-/**
- * axienet_start_xmit_done - Invoked once a transmit is completed by the
- * Axi DMA Tx channel.
- * @ndev:	Pointer to the net_device structure
- *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
- * of transmit operation. It clears fields in the corresponding Tx BDs and
- * unmaps the corresponding buffer so that CPU can regain ownership of the
- * buffer. It finally invokes "netif_wake_queue" to restart transmission if
- * required.
- */
-static void axienet_start_xmit_done(struct net_device *ndev)
+static void axienet_dma_tx_cb(void *data, const struct dmaengine_result *result)
 {
-	struct axienet_local *lp = netdev_priv(ndev);
-	u32 packets = 0;
-	u32 size = 0;
-
-	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
+	struct axi_skbuff *axi_skb = data;
+	struct sk_buff *skb = axi_skb->skb;
 
-	lp->tx_bd_ci += packets;
-	if (lp->tx_bd_ci >= lp->tx_bd_num)
-		lp->tx_bd_ci -= lp->tx_bd_num;
+	struct net_device *netdev = skb->dev;
+	struct axienet_local *lp = netdev_priv(netdev);
 
-	ndev->stats.tx_packets += packets;
-	ndev->stats.tx_bytes += size;
+	dma_unmap_sg(lp->dev, axi_skb->sgl, axi_skb->sg_len, DMA_MEM_TO_DEV);
+	dev_kfree_skb_any(skb);
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	netdev->stats.tx_packets++;
 
-	/* Matches barrier in axienet_start_xmit */
-	smp_mb();
-
-	netif_wake_queue(ndev);
-}
-
-/**
- * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
- * @lp:		Pointer to the axienet_local structure
- * @num_frag:	The number of BDs to check for
- *
- * Return: 0, on success
- *	    NETDEV_TX_BUSY, if any of the descriptors are not free
- *
- * This function is invoked before BDs are allocated and transmission starts.
- * This function returns 0 if a BD or group of BDs can be allocated for
- * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
- */
-static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
-					    int num_frag)
-{
-	struct axidma_bd *cur_p;
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
-		return NETDEV_TX_BUSY;
-	return 0;
+	if (netif_queue_stopped(netdev))
+		netif_wake_queue(netdev);
 }
 
 /**
@@ -717,285 +495,65 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 static netdev_tx_t
 axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	u32 ii;
-	u32 num_frag;
 	u32 csum_start_off;
 	u32 csum_index_off;
-	skb_frag_t *frag;
-	dma_addr_t tail_p, phys;
+	int sg_len;
 	struct axienet_local *lp = netdev_priv(ndev);
-	struct axidma_bd *cur_p;
-	u32 orig_tail_ptr = lp->tx_bd_tail;
-
-	num_frag = skb_shinfo(skb)->nr_frags;
-	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
-
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
-		if (netif_queue_stopped(ndev))
-			return NETDEV_TX_BUSY;
-
-		netif_stop_queue(ndev);
+	struct dma_async_tx_descriptor *dma_tx_desc = NULL;
+	struct axi_skbuff *axi_skb;
+	u32 app[DMA_NUM_APP_WORDS] = {0};
+	int ret;
 
-		/* Matches barrier in axienet_start_xmit_done */
-		smp_mb();
+	sg_len = skb_shinfo(skb)->nr_frags + 1;
+	axi_skb = kmem_cache_zalloc(lp->skb_cache, GFP_KERNEL);
+	if (!axi_skb)
+		return NETDEV_TX_BUSY;
 
-		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
-			return NETDEV_TX_BUSY;
+	sg_init_table(axi_skb->sgl, sg_len);
+	ret = skb_to_sgvec(skb, axi_skb->sgl, 0, skb->len);
+	if (unlikely(ret < 0))
+		goto xmit_error_skb_sgvec;
 
-		netif_wake_queue(ndev);
-	}
+	dma_map_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
 
+	/*Fill up app fields for checksum */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		if (lp->features & XAE_FEATURE_FULL_TX_CSUM) {
 			/* Tx Full Checksum Offload Enabled */
-			cur_p->app0 |= 2;
+			app[0] |= 2;
 		} else if (lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) {
 			csum_start_off = skb_transport_offset(skb);
 			csum_index_off = csum_start_off + skb->csum_offset;
 			/* Tx Partial Checksum Offload Enabled */
-			cur_p->app0 |= 1;
-			cur_p->app1 = (csum_start_off << 16) | csum_index_off;
+			app[0] |= 1;
+			app[1] = (csum_start_off << 16) | csum_index_off;
 		}
 	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
-		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
+		app[0] |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	phys = dma_map_single(ndev->dev.parent, skb->data,
-			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
-		if (net_ratelimit())
-			netdev_err(ndev, "TX DMA mapping error\n");
-		ndev->stats.tx_dropped++;
-		return NETDEV_TX_OK;
-	}
-	desc_set_phys_addr(lp, phys, cur_p);
-	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
-
-	for (ii = 0; ii < num_frag; ii++) {
-		if (++lp->tx_bd_tail >= lp->tx_bd_num)
-			lp->tx_bd_tail = 0;
-		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
-		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(ndev->dev.parent,
-				      skb_frag_address(frag),
-				      skb_frag_size(frag),
-				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
-			if (net_ratelimit())
-				netdev_err(ndev, "TX DMA mapping error\n");
-			ndev->stats.tx_dropped++;
-			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
-					      NULL);
-			lp->tx_bd_tail = orig_tail_ptr;
-
-			return NETDEV_TX_OK;
-		}
-		desc_set_phys_addr(lp, phys, cur_p);
-		cur_p->cntrl = skb_frag_size(frag);
-	}
+	dma_tx_desc = lp->tx_chan->device->device_prep_slave_sg(lp->tx_chan, axi_skb->sgl,
+								sg_len, DMA_MEM_TO_DEV,
+								DMA_PREP_INTERRUPT, (void *)app);
 
-	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
-	cur_p->skb = skb;
+	if (!dma_tx_desc)
+		goto xmit_error_prep;
 
-	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
-	/* Start the transfer */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
-	if (++lp->tx_bd_tail >= lp->tx_bd_num)
-		lp->tx_bd_tail = 0;
+	axi_skb->skb = skb;
+	axi_skb->sg_len = sg_len;
+	dma_tx_desc->callback_param =  axi_skb;
+	dma_tx_desc->callback_result = axienet_dma_tx_cb;
+	dmaengine_submit(dma_tx_desc);
+	dma_async_issue_pending(lp->tx_chan);
+	ndev->stats.tx_bytes += skb->len;
 
 	return NETDEV_TX_OK;
-}
 
-/**
- * axienet_recv - Is called from Axi DMA Rx Isr to complete the received
- *		  BD processing.
- * @ndev:	Pointer to net_device structure.
- *
- * This function is invoked from the Axi DMA Rx isr to process the Rx BDs. It
- * does minimal processing and invokes "netif_rx" to complete further
- * processing.
- */
-static void axienet_recv(struct net_device *ndev)
-{
-	u32 length;
-	u32 csumstatus;
-	u32 size = 0;
-	u32 packets = 0;
-	dma_addr_t tail_p = 0;
-	struct axienet_local *lp = netdev_priv(ndev);
-	struct sk_buff *skb, *new_skb;
-	struct axidma_bd *cur_p;
-
-	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-
-	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
-		dma_addr_t phys;
-
-		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-
-		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
-				 DMA_FROM_DEVICE);
-
-		skb = cur_p->skb;
-		cur_p->skb = NULL;
-		length = cur_p->app4 & 0x0000FFFF;
-
-		skb_put(skb, length);
-		skb->protocol = eth_type_trans(skb, ndev);
-		/*skb_checksum_none_assert(skb);*/
-		skb->ip_summed = CHECKSUM_NONE;
-
-		/* if we're doing Rx csum offload, set it up */
-		if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
-			csumstatus = (cur_p->app2 &
-				      XAE_FULL_CSUM_STATUS_MASK) >> 3;
-			if ((csumstatus == XAE_IP_TCP_CSUM_VALIDATED) ||
-			    (csumstatus == XAE_IP_UDP_CSUM_VALIDATED)) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-			}
-		} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
-			   skb->protocol == htons(ETH_P_IP) &&
-			   skb->len > 64) {
-			skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
-			skb->ip_summed = CHECKSUM_COMPLETE;
-		}
-
-		netif_rx(skb);
-
-		size += length;
-		packets++;
-
-		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
-		if (!new_skb)
-			return;
-
-		phys = dma_map_single(ndev->dev.parent, new_skb->data,
-				      lp->max_frm_size,
-				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
-			if (net_ratelimit())
-				netdev_err(ndev, "RX DMA mapping error\n");
-			dev_kfree_skb(new_skb);
-			return;
-		}
-		desc_set_phys_addr(lp, phys, cur_p);
-
-		cur_p->cntrl = lp->max_frm_size;
-		cur_p->status = 0;
-		cur_p->skb = new_skb;
-
-		if (++lp->rx_bd_ci >= lp->rx_bd_num)
-			lp->rx_bd_ci = 0;
-		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-	}
-
-	ndev->stats.rx_packets += packets;
-	ndev->stats.rx_bytes += size;
-
-	if (tail_p)
-		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
-}
-
-/**
- * axienet_tx_irq - Tx Done Isr.
- * @irq:	irq number
- * @_ndev:	net_device pointer
- *
- * Return: IRQ_HANDLED if device generated a TX interrupt, IRQ_NONE otherwise.
- *
- * This is the Axi DMA Tx done Isr. It invokes "axienet_start_xmit_done"
- * to complete the BD processing.
- */
-static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
-{
-	u32 cr;
-	unsigned int status;
-	struct net_device *ndev = _ndev;
-	struct axienet_local *lp = netdev_priv(ndev);
-
-	status = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
-		axienet_start_xmit_done(lp->ndev);
-		goto out;
-	}
-	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		return IRQ_NONE;
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
-
-		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
-	}
-out:
-	return IRQ_HANDLED;
-}
-
-/**
- * axienet_rx_irq - Rx Isr.
- * @irq:	irq number
- * @_ndev:	net_device pointer
- *
- * Return: IRQ_HANDLED if device generated a RX interrupt, IRQ_NONE otherwise.
- *
- * This is the Axi DMA Rx Isr. It invokes "axienet_recv" to complete the BD
- * processing.
- */
-static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
-{
-	u32 cr;
-	unsigned int status;
-	struct net_device *ndev = _ndev;
-	struct axienet_local *lp = netdev_priv(ndev);
-
-	status = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
-		axienet_recv(lp->ndev);
-		goto out;
-	}
-	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		return IRQ_NONE;
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
-
-		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
-	}
-out:
-	return IRQ_HANDLED;
+xmit_error_prep:
+	dma_unmap_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
+xmit_error_skb_sgvec:
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	return NETDEV_TX_BUSY;
 }
 
 /**
@@ -1027,8 +585,6 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void axienet_dma_err_handler(struct work_struct *work);
-
 /**
  * axienet_open - Driver open routine.
  * @ndev:	Pointer to net_device structure
@@ -1065,19 +621,6 @@ static int axienet_open(struct net_device *ndev)
 
 	phylink_start(lp->phylink);
 
-	/* Enable worker thread for Axi DMA error handling */
-	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
-
-	/* Enable interrupts for Axi DMA Tx */
-	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
-			  ndev->name, ndev);
-	if (ret)
-		goto err_tx_irq;
-	/* Enable interrupts for Axi DMA Rx */
-	ret = request_irq(lp->rx_irq, axienet_rx_irq, IRQF_SHARED,
-			  ndev->name, ndev);
-	if (ret)
-		goto err_rx_irq;
 	/* Enable interrupts for Axi Ethernet core (if defined) */
 	if (lp->eth_irq > 0) {
 		ret = request_irq(lp->eth_irq, axienet_eth_irq, IRQF_SHARED,
@@ -1086,16 +629,18 @@ static int axienet_open(struct net_device *ndev)
 			goto err_eth_irq;
 	}
 
+	 /* Setup dma channel */
+	ret = axienet_setup_dma_chan(ndev);
+	if (ret < 0)
+		goto err_dma_setup;
+
 	return 0;
 
+err_dma_setup:
+	free_irq(lp->eth_irq, ndev);
 err_eth_irq:
-	free_irq(lp->rx_irq, ndev);
-err_rx_irq:
-	free_irq(lp->tx_irq, ndev);
-err_tx_irq:
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
-	cancel_work_sync(&lp->dma_err_task);
 	dev_err(lp->dev, "request_irq() failed\n");
 	return ret;
 }
@@ -1112,8 +657,6 @@ static int axienet_open(struct net_device *ndev)
  */
 static int axienet_stop(struct net_device *ndev)
 {
-	u32 cr, sr;
-	int count;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
@@ -1124,42 +667,14 @@ static int axienet_stop(struct net_device *ndev)
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
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
-	mutex_lock(&lp->mii_bus->mdio_lock);
-	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
-
-	cancel_work_sync(&lp->dma_err_task);
+	dma_release_channel(lp->rx_chan);
+	dma_release_channel(lp->tx_chan);
 
 	if (lp->eth_irq > 0)
 		free_irq(lp->eth_irq, ndev);
-	free_irq(lp->tx_irq, ndev);
-	free_irq(lp->rx_irq, ndev);
 
-	axienet_dma_bd_release(ndev);
 	return 0;
 }
 
@@ -1201,12 +716,7 @@ static int axienet_change_mtu(struct net_device *ndev, int new_mtu)
 static void axienet_poll_controller(struct net_device *ndev)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
-	disable_irq(lp->tx_irq);
-	disable_irq(lp->rx_irq);
-	axienet_rx_irq(lp->tx_irq, ndev);
-	axienet_tx_irq(lp->rx_irq, ndev);
-	enable_irq(lp->tx_irq);
-	enable_irq(lp->rx_irq);
+	/* TODO: Placeholder to implement poll mechanism */
 }
 #endif
 
@@ -1313,14 +823,8 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[29] = axienet_ior(lp, XAE_FMI_OFFSET);
 	data[30] = axienet_ior(lp, XAE_AF0_OFFSET);
 	data[31] = axienet_ior(lp, XAE_AF1_OFFSET);
-	data[32] = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	data[33] = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	data[34] = axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
-	data[35] = axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
-	data[36] = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	data[37] = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	data[38] = axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
-	data[39] = axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
+
+	/*TODO : explore how to dump DMA registers here?*/
 }
 
 static void axienet_ethtools_get_ringparam(struct net_device *ndev,
@@ -1410,14 +914,8 @@ axienet_ethtools_set_pauseparam(struct net_device *ndev,
 static int axienet_ethtools_get_coalesce(struct net_device *ndev,
 					 struct ethtool_coalesce *ecoalesce)
 {
-	u32 regval = 0;
-	struct axienet_local *lp = netdev_priv(ndev);
-	regval = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	ecoalesce->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
-	regval = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	ecoalesce->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
+	/* TODO: Request and populate DMA engine TX and RX coalesc params */
+
 	return 0;
 }
 
@@ -1688,136 +1186,6 @@ static const struct phylink_mac_ops axienet_phylink_ops = {
 };
 
 /**
- * axienet_dma_err_handler - Work queue task for Axi DMA Error
- * @work:	pointer to work_struct
- *
- * Resets the Axi DMA and Axi Ethernet devices, and reconfigures the
- * Tx/Rx BDs.
- */
-static void axienet_dma_err_handler(struct work_struct *work)
-{
-	u32 axienet_status;
-	u32 cr, i;
-	struct axienet_local *lp = container_of(work, struct axienet_local,
-						dma_err_task);
-	struct net_device *ndev = lp->ndev;
-	struct axidma_bd *cur_p;
-
-	axienet_setoptions(ndev, lp->options &
-			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	/* When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting.
-	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
-	 */
-	mutex_lock(&lp->mii_bus->mdio_lock);
-	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
-
-	for (i = 0; i < lp->tx_bd_num; i++) {
-		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->cntrl) {
-			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
-
-			dma_unmap_single(ndev->dev.parent, addr,
-					 (cur_p->cntrl &
-					  XAXIDMA_BD_CTRL_LENGTH_MASK),
-					 DMA_TO_DEVICE);
-		}
-		if (cur_p->skb)
-			dev_kfree_skb_irq(cur_p->skb);
-		cur_p->phys = 0;
-		cur_p->phys_msb = 0;
-		cur_p->cntrl = 0;
-		cur_p->status = 0;
-		cur_p->app0 = 0;
-		cur_p->app1 = 0;
-		cur_p->app2 = 0;
-		cur_p->app3 = 0;
-		cur_p->app4 = 0;
-		cur_p->skb = NULL;
-	}
-
-	for (i = 0; i < lp->rx_bd_num; i++) {
-		cur_p = &lp->rx_bd_v[i];
-		cur_p->status = 0;
-		cur_p->app0 = 0;
-		cur_p->app1 = 0;
-		cur_p->app2 = 0;
-		cur_p->app3 = 0;
-		cur_p->app4 = 0;
-	}
-
-	lp->tx_bd_ci = 0;
-	lp->tx_bd_tail = 0;
-	lp->rx_bd_ci = 0;
-
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
-
-	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
-	axienet_status &= ~XAE_RCW1_RX_MASK;
-	axienet_iow(lp, XAE_RCW1_OFFSET, axienet_status);
-
-	axienet_status = axienet_ior(lp, XAE_IP_OFFSET);
-	if (axienet_status & XAE_INT_RXRJECT_MASK)
-		axienet_iow(lp, XAE_IS_OFFSET, XAE_INT_RXRJECT_MASK);
-	axienet_iow(lp, XAE_IE_OFFSET, lp->eth_irq > 0 ?
-		    XAE_INT_RECV_ERROR_MASK : 0);
-	axienet_iow(lp, XAE_FCC_OFFSET, XAE_FCC_FCRX_MASK);
-
-	/* Sync default options with HW but leave receiver and
-	 * transmitter disabled.
-	 */
-	axienet_setoptions(ndev, lp->options &
-			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	axienet_set_mac_address(ndev, NULL);
-	axienet_set_multicast_list(ndev);
-	axienet_setoptions(ndev, lp->options);
-}
-
-/**
  * axienet_probe - Axi Ethernet probe function.
  * @pdev:	Pointer to platform device structure.
  *
@@ -1832,12 +1200,10 @@ static void axienet_dma_err_handler(struct work_struct *work)
 static int axienet_probe(struct platform_device *pdev)
 {
 	int ret;
-	struct device_node *np;
 	struct axienet_local *lp;
 	struct net_device *ndev;
 	const void *mac_addr;
 	struct resource *ethres;
-	int addr_width = 32;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1972,74 +1338,6 @@ static int axienet_probe(struct platform_device *pdev)
 		goto free_netdev;
 	}
 
-	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
-	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
-	if (np) {
-		struct resource dmares;
-
-		ret = of_address_to_resource(np, 0, &dmares);
-		if (ret) {
-			dev_err(&pdev->dev,
-				"unable to get DMA resource\n");
-			of_node_put(np);
-			goto free_netdev;
-		}
-		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
-						     &dmares);
-		lp->rx_irq = irq_of_parse_and_map(np, 1);
-		lp->tx_irq = irq_of_parse_and_map(np, 0);
-		of_node_put(np);
-		lp->eth_irq = platform_get_irq_optional(pdev, 0);
-	} else {
-		/* Check for these resources directly on the Ethernet node. */
-		struct resource *res = platform_get_resource(pdev,
-							     IORESOURCE_MEM, 1);
-		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
-		lp->rx_irq = platform_get_irq(pdev, 1);
-		lp->tx_irq = platform_get_irq(pdev, 0);
-		lp->eth_irq = platform_get_irq_optional(pdev, 2);
-	}
-	if (IS_ERR(lp->dma_regs)) {
-		dev_err(&pdev->dev, "could not map DMA regs\n");
-		ret = PTR_ERR(lp->dma_regs);
-		goto free_netdev;
-	}
-	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
-		dev_err(&pdev->dev, "could not determine irqs\n");
-		ret = -ENOMEM;
-		goto free_netdev;
-	}
-
-	/* Autodetect the need for 64-bit DMA pointers.
-	 * When the IP is configured for a bus width bigger than 32 bits,
-	 * writing the MSB registers is mandatory, even if they are all 0.
-	 * We can detect this case by writing all 1's to one such register
-	 * and see if that sticks: when the IP is configured for 32 bits
-	 * only, those registers are RES0.
-	 * Those MSB registers were introduced in IP v7.1, which we check first.
-	 */
-	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
-		void __iomem *desc = lp->dma_regs + XAXIDMA_TX_CDESC_OFFSET + 4;
-
-		iowrite32(0x0, desc);
-		if (ioread32(desc) == 0) {	/* sanity check */
-			iowrite32(0xffffffff, desc);
-			if (ioread32(desc) > 0) {
-				lp->features |= XAE_FEATURE_DMA_64BIT;
-				addr_width = 64;
-				dev_info(&pdev->dev,
-					 "autodetected 64-bit DMA range\n");
-			}
-			iowrite32(0x0, desc);
-		}
-	}
-
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
-	if (ret) {
-		dev_err(&pdev->dev, "No suitable DMA available\n");
-		goto free_netdev;
-	}
-
 	/* Check for Ethernet core IRQ (optional) */
 	if (lp->eth_irq <= 0)
 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
-- 
2.7.4

