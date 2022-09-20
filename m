Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482B75BDCC5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiITF6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiITF6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:58:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6B1275F7;
        Mon, 19 Sep 2022 22:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfiSoQuGm5nmwoE6r2HXNMRL9Ee8vBOe2WZEFTTu1RdXtbbs/CjeeXr54rteNvXlkwk7Ec6SYStYKZ+dXDN0FwCapWdJZWVN0M4KsIIlLm640Li/E4mXd8oa0rHcZk4uq5gP8wu+VGF1JNPzAjS8Ipzn3y64hSErpbQsXKeUiHmc6sSe7omLanCJqDS2LXO7q7hAjOQVtX+heDcX+UaPApKBnIXLkc3neUCK8dahrKqQGRcvhJwk6tE7dV9LitWrszQunCMyXl+BkLlhgirzrA6HKtCMMxCSKp+m0iTJ0UunZlIaa89zOWLAeYRiXRKdaXAHOgXBG+ATJGBCilpCBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PoEGOrUWmjQCfoU4lIxgGfTRf3Iq/fLheQv1W5buoY=;
 b=di8+Z/wNM+laSQU1GU0YlOfE/hAGFbaXbTOdrjgAslnklWNvXTOjWhC4OnIPXQPrNjLulPcNo91eB5Ux/iwMgfZRCAtpAfdFiDlaHGiucqCRlEntfvMvsDKrK2KG/KLvA9lWrW2RTowJCbts2Q8vqGnYuQShADoJ2G1UNBbAt9DoTQtRVNIK/JUiN8fpU83TCJhPNjryWMR5UUDMpXMR1Wr2TQB+muiVRTs/C7m0xJAAB3mlya8oZHHsRDuPj8g9/9b6ObfGsxxBDcdtJapezfmthhZtS7+ssKSem9ikqGJGAa1xVXU9ZYWf/j4zyg4NfIzQahtRRtDI8WUOvt2cSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PoEGOrUWmjQCfoU4lIxgGfTRf3Iq/fLheQv1W5buoY=;
 b=fva70NG60K2ThRirfTdSP7YdEXU27KDXaobJS9iFvy9FE5JAe8ME6JU90VJSUuKqS6VgyVMfvZfpsaC15cOWLp07bkz8yYlLHUcgBX9Qx8pn9hu9+l5A2+MTtBrTbIX1pSctuBw+XjuaOktjh6cGo+D2RwxvyN9MdBFqluag1ps=
Received: from BN1PR10CA0011.namprd10.prod.outlook.com (2603:10b6:408:e0::16)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Tue, 20 Sep
 2022 05:57:31 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::dc) by BN1PR10CA0011.outlook.office365.com
 (2603:10b6:408:e0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14 via Frontend
 Transport; Tue, 20 Sep 2022 05:57:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 05:57:30 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 20 Sep
 2022 00:57:30 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 22:57:28 -0700
Received: from xhdswatia40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 20 Sep 2022 00:57:23 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <radhey.shyam.pandey@amd.com>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>,
        <git@xilinx.com>, <git@amd.com>
Subject: [RFC V2 PATCH 3/3] net: axienet: Introduce dmaengine support
Date:   Tue, 20 Sep 2022 11:27:03 +0530
Message-ID: <20220920055703.13246-4-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT088:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: b6709d49-b374-4c5c-da65-08da9acd0165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /w/9+oPk/XMk0K04+t3V0PVqvAPXBcNyXQEBLa/ETdgbzECLubMTQpej3bSJDbFcZwFRW9kcVqpepXUSY0EmZjYR3k61yX23tR+krPInYTjWDkD52hQfKLa8xW407iq2QKGYKaVTrNt81Srd1oWDilq5wipXjBbomH1ZQy4fEOQQkBqX0fsBg2pAvD+P5SoF2GxOXQsUrWnG/yUu6svzaLXYBuhCL6fRGYaG00CDKL9DqHrKS1K2/5OmKpXnSLPcPpYaMjXaR3X2FvJEp53SZw3v0bz3CUThsBTOGsotFwymyEJuDE5wkOUQUnhR0QN7DHLQX8BaqkjTKziCg8MVlVv2fPbecRqY2TCYshMCG2Ci22T7YhVf1hZ7BmIHKC7JDvr5W510+jD7zof/OIgTxuekpKRIfftPe6B1qlb+nN53DQRgGvulwKrg81UWw6rOD8y+G76FEQ2Ch3RCTsZl8lThF0BdNLzCfxllF66448MfU6v2KH1jxVvmzi+FX6TN888Qp7uLhYP85jMxKD6UyXmm1p0oMXAVdjCyWpSd65q2leHfNEeJQbi17M1ibydehBtc/+WYxADavZd8l8wEThmi4xXpIc6xRO6HVhXs89QzcV7ihuu/2s0XVC6Ib/+3DRWLEfpivq4gT9xzFKe+Stay5F0zKBunrvV7AGOgXwFpR3Pdt9XrL3Er0mD47iIUNMeThb0NAjgwBc4BxnjC1WjkjdKpxGaqnyt+WGwTr/3fuTwlCsb3+KnBwt9Ft53rU3gtkVQcqU6adytmd0OrzDriRZZL2bTye65qbkngc6BVHoBzY4clTO52Ul/0NXAZ3tRl41XJHPSbjfXTVH9MLJ41umMAyxT5toYYvzl9s8E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(103116003)(478600001)(82740400003)(966005)(82310400005)(41300700001)(6666004)(40460700003)(8936002)(110136005)(7416002)(54906003)(81166007)(5660300002)(2906002)(70206006)(36756003)(40480700001)(356005)(316002)(30864003)(70586007)(86362001)(8676002)(4326008)(47076005)(83380400001)(2616005)(26005)(186003)(36860700001)(1076003)(426003)(336012)(375104004)(36900700001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 05:57:30.7990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6709d49-b374-4c5c-da65-08da9acd0165
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

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

[1]: https://lore.kernel.org/lkml/1522665546-10035-1-git-send-email-
radheys@xilinx.com.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>

Performance numbers(Mbps):
	-------------
	| TCP | UDP |
	-------------
     Tx	| 910 | 680 |
	-------------
     Rx	| 670 | 950 |
        -------------

Changes in V2:
1) Add dma reset and interrupt coalesce setting support.
2) Add performance numbers.
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  169 +---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1165 ++++-----------------
 2 files changed, 238 insertions(+), 1096 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 8ff4333..82bcce3 100644
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
-/* Default TX/RX Threshold and delay timer values for SGDMA mode */
-#define XAXIDMA_DFT_TX_THRESHOLD	24
-#define XAXIDMA_DFT_TX_USEC		50
-#define XAXIDMA_DFT_RX_THRESHOLD	1
-#define XAXIDMA_DFT_RX_USEC		50
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
@@ -343,38 +277,6 @@
 #define XLNX_MII_STD_SELECT_REG		0x11
 #define XLNX_MII_STD_SELECT_SGMII	BIT(0)
 
-/**
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
 
 #define XAE_NUM_MISC_CLOCKS 3
 
@@ -395,35 +297,12 @@ struct axidma_bd {
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
- * @napi_rx:	NAPI RX control structure
- * @rx_dma_cr:  Nominal content of RX DMA control register
- * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
- * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
- * @rx_bd_num:	Size of RX buffer descriptor ring
- * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
- *		accessed currently.
- * @rx_packets: RX packet count for statistics
- * @rx_bytes:	RX byte count for statistics
- * @rx_stat_sync: Synchronization object for RX stats
- * @napi_tx:	NAPI TX control structure
- * @tx_dma_cr:  Nominal content of TX DMA control register
- * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
- * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
- * @tx_bd_num:	Size of TX buffer descriptor ring
- * @tx_bd_ci:	Stores the next Tx buffer descriptor in the ring that may be
- *		complete. Only updated at runtime by TX NAPI poll.
- * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
- *              to be populated.
- * @tx_packets: TX packet count for statistics
- * @tx_bytes:	TX byte count for statistics
- * @tx_stat_sync: Synchronization object for TX stats
- * @dma_err_task: Work structure to process Axi DMA errors
- * @tx_irq:	Axidma TX IRQ number
- * @rx_irq:	Axidma RX IRQ number
  * @eth_irq:	Ethernet core IRQ number
  * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
  * @options:	AxiEthernet option word
  * @features:	Stores the extended features supported by the axienet hw
+ * @tx_bd_num:	Size of TX buffer descriptor ring
+ * @rx_bd_num:	Size of RX buffer descriptor ring
  * @max_frm_size: Stores the maximum size of the frame that can be that
  *		  Txed/Rxed in the existing hardware. If jumbo option is
  *		  supported, the maximum frame size would be 9k. Else it is
@@ -435,6 +314,9 @@ struct axidma_bd {
  * @coalesce_usec_rx:	IRQ coalesce delay for RX
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
  * @coalesce_usec_tx:	IRQ coalesce delay for TX
+ * @tx_chan: TX DMA channel.
+ * @rx_chan: RX DMA channel.
+ * @skb_cache: Custom skb slab allocator.
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -457,38 +339,15 @@ struct axienet_local {
 	resource_size_t regs_start;
 	void __iomem *regs;
 	void __iomem *dma_regs;
-
-	struct napi_struct napi_rx;
-	u32 rx_dma_cr;
-	struct axidma_bd *rx_bd_v;
-	dma_addr_t rx_bd_p;
-	u32 rx_bd_num;
-	u32 rx_bd_ci;
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	struct u64_stats_sync rx_stat_sync;
-
-	struct napi_struct napi_tx;
-	u32 tx_dma_cr;
-	struct axidma_bd *tx_bd_v;
-	dma_addr_t tx_bd_p;
-	u32 tx_bd_num;
-	u32 tx_bd_ci;
-	u32 tx_bd_tail;
-	u64_stats_t tx_packets;
-	u64_stats_t tx_bytes;
-	struct u64_stats_sync tx_stat_sync;
-
-	struct work_struct dma_err_task;
-
-	int tx_irq;
-	int rx_irq;
 	int eth_irq;
 	phy_interface_t phy_mode;
 
 	u32 options;
 	u32 features;
 
+	u32 tx_bd_num;
+	u32 rx_bd_num;
+
 	u32 max_frm_size;
 	u32 rxmem;
 
@@ -499,6 +358,10 @@ struct axienet_local {
 	u32 coalesce_usec_rx;
 	u32 coalesce_count_tx;
 	u32 coalesce_usec_tx;
+
+	struct dma_chan *tx_chan;
+	struct dma_chan *rx_chan;
+	struct kmem_cache *skb_cache;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9fde594..4e218a7 100644
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
@@ -37,15 +36,19 @@
 #include <linux/phy.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma/xilinx_dma.h>
 
 #include "xilinx_axienet.h"
 
 /* Descriptors defines for Tx and Rx DMA */
-#define TX_BD_NUM_DEFAULT		128
-#define RX_BD_NUM_DEFAULT		1024
 #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
+#define TX_BD_NUM_DEFAULT		64
+#define RX_BD_NUM_DEFAULT		128
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
+#define DMA_NUM_APP_WORDS		5
 
 /* Must be shorter than length of ethtool_drvinfo.driver field to fit */
 #define DRIVER_NAME		"xaxienet"
@@ -119,234 +122,130 @@
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
-{
-	return ioread32(lp->dma_regs + reg);
-}
-
-static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
-			       struct axidma_bd *desc)
-{
-	desc->phys = lower_32_bits(addr);
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		desc->phys_msb = upper_32_bits(addr);
-}
-
-static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
-				     struct axidma_bd *desc)
-{
-	dma_addr_t ret = desc->phys;
-
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		ret |= ((dma_addr_t)desc->phys_msb << 16) << 16;
-
-	return ret;
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
-	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
+	struct dma_async_tx_descriptor *dma_rx_desc = NULL;
+	struct axi_skbuff *axi_skb;
+	struct sk_buff *skb;
+	dma_addr_t addr;
+	int ret;
 
-	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(lp->dev,
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
-
-		dev_kfree_skb(lp->rx_bd_v[i].skb);
+	axi_skb = kmem_cache_alloc(lp->skb_cache, GFP_KERNEL);
+	if (!axi_skb)
+		return -ENOMEM;
 
-		/* For each descriptor, we programmed cntrl with the (non-zero)
-		 * descriptor size, after it had been successfully allocated.
-		 * So a non-zero value in there means we need to unmap it.
-		 */
-		if (lp->rx_bd_v[i].cntrl) {
-			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(lp->dev, phys,
-					 lp->max_frm_size, DMA_FROM_DEVICE);
-		}
+	skb = netdev_alloc_skb(ndev, lp->max_frm_size);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto rx_bd_init_skb;
 	}
 
-	dma_free_coherent(lp->dev,
-			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-			  lp->rx_bd_v,
-			  lp->rx_bd_p);
-}
+	sg_init_table(axi_skb->sgl, 1);
+	addr = dma_map_single(lp->dev, skb->data, lp->max_frm_size, DMA_FROM_DEVICE);
+	sg_dma_address(axi_skb->sgl) = addr;
+	sg_dma_len(axi_skb->sgl) = lp->max_frm_size;
 
-/**
- * axienet_usec_to_timer - Calculate IRQ delay timer value
- * @lp:		Pointer to the axienet_local structure
- * @coalesce_usec: Microseconds to convert into timer value
- */
-static u32 axienet_usec_to_timer(struct axienet_local *lp, u32 coalesce_usec)
-{
-	u32 result;
-	u64 clk_rate = 125000000; /* arbitrary guess if no clock rate set */
+	dma_rx_desc = dmaengine_prep_slave_sg(lp->rx_chan, axi_skb->sgl,
+					      1, DMA_DEV_TO_MEM,
+					      DMA_PREP_INTERRUPT);
+	if (!dma_rx_desc) {
+		ret = -EINVAL;
+		goto rx_bd_init_prep_sg;
+	}
 
-	if (lp->axi_clk)
-		clk_rate = clk_get_rate(lp->axi_clk);
+	axi_skb->skb = skb;
+	axi_skb->dma_address = sg_dma_address(axi_skb->sgl);
+	axi_skb->desc = dma_rx_desc;
+	dma_rx_desc->callback_param =  axi_skb;
+	dma_rx_desc->callback_result = axienet_dma_rx_cb;
+	dmaengine_submit(dma_rx_desc);
 
-	/* 1 Timeout Interval = 125 * (clock period of SG clock) */
-	result = DIV64_U64_ROUND_CLOSEST((u64)coalesce_usec * clk_rate,
-					 (u64)125000000);
-	if (result > 255)
-		result = 255;
+	return 0;
 
-	return result;
-}
+rx_bd_init_prep_sg:
+	dma_unmap_single(lp->dev, addr, lp->max_frm_size, DMA_FROM_DEVICE);
+	dev_kfree_skb(skb);
+rx_bd_init_skb:
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	return ret;
+};
 
-/**
- * axienet_dma_start - Set up DMA registers and start DMA operation
- * @lp:		Pointer to the axienet_local structure
- */
-static void axienet_dma_start(struct axienet_local *lp)
+static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 {
-	/* Start updating the Rx channel control register */
-	lp->rx_dma_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
-			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
-	/* Only set interrupt delay timer if not generating an interrupt on
-	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
-	 */
-	if (lp->coalesce_count_rx > 1)
-		lp->rx_dma_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_rx)
-					<< XAXIDMA_DELAY_SHIFT) |
-				 XAXIDMA_IRQ_DELAY_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
-
-	/* Start updating the Tx channel control register */
-	lp->tx_dma_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
-			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
-	/* Only set interrupt delay timer if not generating an interrupt on
-	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
-	 */
-	if (lp->coalesce_count_tx > 1)
-		lp->tx_dma_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
-					<< XAXIDMA_DELAY_SHIFT) |
-				 XAXIDMA_IRQ_DELAY_MASK;
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
-
-	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-	 * halted state. This will make the Rx side ready for reception.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	lp->rx_dma_cr |= XAXIDMA_CR_RUNSTOP_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
-	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
-
-	/* Write to the RS (Run-stop) bit in the Tx channel control register.
-	 * Tx channel is now ready to run. But only after we write to the
-	 * tail pointer register that the Tx channel will start transmitting.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	lp->tx_dma_cr |= XAXIDMA_CR_RUNSTOP_MASK;
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
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
-	lp->tx_bd_v = dma_alloc_coherent(lp->dev,
-					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
-					 &lp->tx_bd_p, GFP_KERNEL);
-	if (!lp->tx_bd_v)
-		return -ENOMEM;
-
-	lp->rx_bd_v = dma_alloc_coherent(lp->dev,
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
-		addr = dma_map_single(lp->dev, skb->data,
-				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(lp->dev, addr)) {
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
 
-	axienet_dma_start(lp);
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
@@ -497,78 +396,6 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 	lp->options |= options;
 }
 
-static int __axienet_device_reset(struct axienet_local *lp)
-{
-	u32 value;
-	int ret;
-
-	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
-	 * process of Axi DMA takes a while to complete as all pending
-	 * commands/transfers will be flushed or completed during this
-	 * reset process.
-	 * Note that even though both TX and RX have their own reset register,
-	 * they both reset the entire DMA core, so only one needs to be used.
-	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	ret = read_poll_timeout(axienet_dma_in32, value,
-				!(value & XAXIDMA_CR_RESET_MASK),
-				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
-				XAXIDMA_TX_CR_OFFSET);
-	if (ret) {
-		dev_err(lp->dev, "%s: DMA reset timeout!\n", __func__);
-		return ret;
-	}
-
-	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
-	ret = read_poll_timeout(axienet_ior, value,
-				value & XAE_INT_PHYRSTCMPLT_MASK,
-				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
-				XAE_IS_OFFSET);
-	if (ret) {
-		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
-		return ret;
-	}
-
-	return 0;
-}
-
-/**
- * axienet_dma_stop - Stop DMA operation
- * @lp:		Pointer to the axienet_local structure
- */
-static void axienet_dma_stop(struct axienet_local *lp)
-{
-	int count;
-	u32 cr, sr;
-
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-	synchronize_irq(lp->rx_irq);
-
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-	synchronize_irq(lp->tx_irq);
-
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
-}
 
 /**
  * axienet_device_reset - Reset and initialize the Axi Ethernet hardware.
@@ -586,11 +413,8 @@ static int axienet_device_reset(struct net_device *ndev)
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
@@ -605,13 +429,7 @@ static int axienet_device_reset(struct net_device *ndev)
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
@@ -639,139 +457,28 @@ static int axienet_device_reset(struct net_device *ndev)
 }
 
 /**
- * axienet_free_tx_chain - Clean up a series of linked TX descriptors.
- * @lp:		Pointer to the axienet_local structure
- * @first_bd:	Index of first descriptor to clean up
- * @nr_bds:	Max number of descriptors to clean up
- * @force:	Whether to clean descriptors even if not complete
- * @sizep:	Pointer to a u32 filled with the total sum of all bytes
- * 		in all cleaned-up descriptors. Ignored if NULL.
- * @budget:	NAPI budget (use 0 when not called from NAPI poll)
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
-static int axienet_free_tx_chain(struct axienet_local *lp, u32 first_bd,
-				 int nr_bds, bool force, u32 *sizep, int budget)
-{
-	struct axidma_bd *cur_p;
-	unsigned int status;
-	dma_addr_t phys;
-	int i;
-
-	for (i = 0; i < nr_bds; i++) {
-		cur_p = &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
-		status = cur_p->status;
-
-		/* If force is not specified, clean up only descriptors
-		 * that have been completed by the MAC.
-		 */
-		if (!force && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			break;
-
-		/* Ensure we see complete descriptor update */
-		dma_rmb();
-		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(lp->dev, phys,
-				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
-				 DMA_TO_DEVICE);
-
-		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
-			napi_consume_skb(cur_p->skb, budget);
-
-		cur_p->app0 = 0;
-		cur_p->app1 = 0;
-		cur_p->app2 = 0;
-		cur_p->app4 = 0;
-		cur_p->skb = NULL;
-		/* ensure our transmit path and device don't prematurely see status cleared */
-		wmb();
-		cur_p->cntrl = 0;
-		cur_p->status = 0;
-
-		if (sizep)
-			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
-	}
 
-	return i;
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
- * returns a busy status.
- */
-static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
-					    int num_frag)
+static void axienet_dma_tx_cb(void *data, const struct dmaengine_result *result)
 {
-	struct axidma_bd *cur_p;
+	struct axi_skbuff *axi_skb = data;
+	struct sk_buff *skb = axi_skb->skb;
 
-	/* Ensure we see all descriptor updates from device or TX polling */
-	rmb();
-	cur_p = &lp->tx_bd_v[(READ_ONCE(lp->tx_bd_tail) + num_frag) %
-			     lp->tx_bd_num];
-	if (cur_p->cntrl)
-		return NETDEV_TX_BUSY;
-	return 0;
-}
-
-/**
- * axienet_tx_poll - Invoked once a transmit is completed by the
- * Axi DMA Tx channel.
- * @napi:	Pointer to NAPI structure.
- * @budget:	Max number of TX packets to process.
- *
- * Return: Number of TX packets processed.
- *
- * This function is invoked from the NAPI processing to notify the completion
- * of transmit operation. It clears fields in the corresponding Tx BDs and
- * unmaps the corresponding buffer so that CPU can regain ownership of the
- * buffer. It finally invokes "netif_wake_queue" to restart transmission if
- * required.
- */
-static int axienet_tx_poll(struct napi_struct *napi, int budget)
-{
-	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_tx);
-	struct net_device *ndev = lp->ndev;
-	u32 size = 0;
-	int packets;
-
-	packets = axienet_free_tx_chain(lp, lp->tx_bd_ci, budget, false, &size, budget);
-
-	if (packets) {
-		lp->tx_bd_ci += packets;
-		if (lp->tx_bd_ci >= lp->tx_bd_num)
-			lp->tx_bd_ci %= lp->tx_bd_num;
-
-		u64_stats_update_begin(&lp->tx_stat_sync);
-		u64_stats_add(&lp->tx_packets, packets);
-		u64_stats_add(&lp->tx_bytes, size);
-		u64_stats_update_end(&lp->tx_stat_sync);
+	struct net_device *netdev = skb->dev;
+	struct axienet_local *lp = netdev_priv(netdev);
 
-		/* Matches barrier in axienet_start_xmit */
-		smp_mb();
+	dma_unmap_sg(lp->dev, axi_skb->sgl, axi_skb->sg_len, DMA_MEM_TO_DEV);
+	dev_kfree_skb_any(skb);
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	netdev->stats.tx_packets++;
 
-		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
-			netif_wake_queue(ndev);
-	}
-
-	if (packets < budget && napi_complete_done(napi, packets)) {
-		/* Re-enable TX completion interrupts. This should
-		 * cause an immediate interrupt if any TX packets are
-		 * already pending.
-		 */
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
-	}
-	return packets;
+	if (netif_queue_stopped(netdev))
+		netif_wake_queue(netdev);
 }
 
 /**
@@ -790,306 +497,65 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 static netdev_tx_t
 axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	u32 ii;
-	u32 num_frag;
 	u32 csum_start_off;
 	u32 csum_index_off;
-	skb_frag_t *frag;
-	dma_addr_t tail_p, phys;
-	u32 orig_tail_ptr, new_tail_ptr;
+	int sg_len;
 	struct axienet_local *lp = netdev_priv(ndev);
-	struct axidma_bd *cur_p;
+	struct dma_async_tx_descriptor *dma_tx_desc = NULL;
+	struct axi_skbuff *axi_skb;
+	u32 app[DMA_NUM_APP_WORDS] = {0};
+	int ret;
 
-	orig_tail_ptr = lp->tx_bd_tail;
-	new_tail_ptr = orig_tail_ptr;
+	sg_len = skb_shinfo(skb)->nr_frags + 1;
+	axi_skb = kmem_cache_zalloc(lp->skb_cache, GFP_KERNEL);
+	if (!axi_skb)
+		return NETDEV_TX_BUSY;
 
-	num_frag = skb_shinfo(skb)->nr_frags;
-	cur_p = &lp->tx_bd_v[orig_tail_ptr];
+	sg_init_table(axi_skb->sgl, sg_len);
+	ret = skb_to_sgvec(skb, axi_skb->sgl, 0, skb->len);
+	if (unlikely(ret < 0))
+		goto xmit_error_skb_sgvec;
 
-	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
-		/* Should not happen as last start_xmit call should have
-		 * checked for sufficient space and queue should only be
-		 * woken when sufficient space is available.
-		 */
-		netif_stop_queue(ndev);
-		if (net_ratelimit())
-			netdev_warn(ndev, "TX ring unexpectedly full\n");
-		return NETDEV_TX_BUSY;
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
 
-	phys = dma_map_single(lp->dev, skb->data,
-			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(lp->dev, phys))) {
-		if (net_ratelimit())
-			netdev_err(ndev, "TX DMA mapping error\n");
-		ndev->stats.tx_dropped++;
-		return NETDEV_TX_OK;
-	}
-	desc_set_phys_addr(lp, phys, cur_p);
-	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
-
-	for (ii = 0; ii < num_frag; ii++) {
-		if (++new_tail_ptr >= lp->tx_bd_num)
-			new_tail_ptr = 0;
-		cur_p = &lp->tx_bd_v[new_tail_ptr];
-		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(lp->dev,
-				      skb_frag_address(frag),
-				      skb_frag_size(frag),
-				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(lp->dev, phys))) {
-			if (net_ratelimit())
-				netdev_err(ndev, "TX DMA mapping error\n");
-			ndev->stats.tx_dropped++;
-			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
-					      true, NULL, 0);
-			return NETDEV_TX_OK;
-		}
-		desc_set_phys_addr(lp, phys, cur_p);
-		cur_p->cntrl = skb_frag_size(frag);
-	}
-
-	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
-	cur_p->skb = skb;
-
-	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * new_tail_ptr;
-	if (++new_tail_ptr >= lp->tx_bd_num)
-		new_tail_ptr = 0;
-	WRITE_ONCE(lp->tx_bd_tail, new_tail_ptr);
-
-	/* Start the transfer */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
+	dma_tx_desc = lp->tx_chan->device->device_prep_slave_sg(lp->tx_chan, axi_skb->sgl,
+								sg_len, DMA_MEM_TO_DEV,
+								DMA_PREP_INTERRUPT, (void *)app);
 
-	/* Stop queue if next transmit may not have space */
-	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netif_stop_queue(ndev);
+	if (!dma_tx_desc)
+		goto xmit_error_prep;
 
-		/* Matches barrier in axienet_tx_poll */
-		smp_mb();
-
-		/* Space might have just been freed - check again */
-		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
-			netif_wake_queue(ndev);
-	}
+	axi_skb->skb = skb;
+	axi_skb->sg_len = sg_len;
+	dma_tx_desc->callback_param =  axi_skb;
+	dma_tx_desc->callback_result = axienet_dma_tx_cb;
+	dmaengine_submit(dma_tx_desc);
+	dma_async_issue_pending(lp->tx_chan);
+	ndev->stats.tx_bytes += skb->len;
 
 	return NETDEV_TX_OK;
-}
-
-/**
- * axienet_rx_poll - Triggered by RX ISR to complete the BD processing.
- * @napi:	Pointer to NAPI structure.
- * @budget:	Max number of RX packets to process.
- *
- * Return: Number of RX packets processed.
- */
-static int axienet_rx_poll(struct napi_struct *napi, int budget)
-{
-	u32 length;
-	u32 csumstatus;
-	u32 size = 0;
-	int packets = 0;
-	dma_addr_t tail_p = 0;
-	struct axidma_bd *cur_p;
-	struct sk_buff *skb, *new_skb;
-	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_rx);
-
-	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-
-	while (packets < budget && (cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
-		dma_addr_t phys;
-
-		/* Ensure we see complete descriptor update */
-		dma_rmb();
-
-		skb = cur_p->skb;
-		cur_p->skb = NULL;
-
-		/* skb could be NULL if a previous pass already received the
-		 * packet for this slot in the ring, but failed to refill it
-		 * with a newly allocated buffer. In this case, don't try to
-		 * receive it again.
-		 */
-		if (likely(skb)) {
-			length = cur_p->app4 & 0x0000FFFF;
-
-			phys = desc_get_phys_addr(lp, cur_p);
-			dma_unmap_single(lp->dev, phys, lp->max_frm_size,
-					 DMA_FROM_DEVICE);
-
-			skb_put(skb, length);
-			skb->protocol = eth_type_trans(skb, lp->ndev);
-			/*skb_checksum_none_assert(skb);*/
-			skb->ip_summed = CHECKSUM_NONE;
-
-			/* if we're doing Rx csum offload, set it up */
-			if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
-				csumstatus = (cur_p->app2 &
-					      XAE_FULL_CSUM_STATUS_MASK) >> 3;
-				if (csumstatus == XAE_IP_TCP_CSUM_VALIDATED ||
-				    csumstatus == XAE_IP_UDP_CSUM_VALIDATED) {
-					skb->ip_summed = CHECKSUM_UNNECESSARY;
-				}
-			} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
-				   skb->protocol == htons(ETH_P_IP) &&
-				   skb->len > 64) {
-				skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
-				skb->ip_summed = CHECKSUM_COMPLETE;
-			}
-
-			napi_gro_receive(napi, skb);
-
-			size += length;
-			packets++;
-		}
-
-		new_skb = napi_alloc_skb(napi, lp->max_frm_size);
-		if (!new_skb)
-			break;
-
-		phys = dma_map_single(lp->dev, new_skb->data,
-				      lp->max_frm_size,
-				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(lp->dev, phys))) {
-			if (net_ratelimit())
-				netdev_err(lp->ndev, "RX DMA mapping error\n");
-			dev_kfree_skb(new_skb);
-			break;
-		}
-		desc_set_phys_addr(lp, phys, cur_p);
-
-		cur_p->cntrl = lp->max_frm_size;
-		cur_p->status = 0;
-		cur_p->skb = new_skb;
-
-		/* Only update tail_p to mark this slot as usable after it has
-		 * been successfully refilled.
-		 */
-		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-
-		if (++lp->rx_bd_ci >= lp->rx_bd_num)
-			lp->rx_bd_ci = 0;
-		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-	}
-
-	u64_stats_update_begin(&lp->rx_stat_sync);
-	u64_stats_add(&lp->rx_packets, packets);
-	u64_stats_add(&lp->rx_bytes, size);
-	u64_stats_update_end(&lp->rx_stat_sync);
-
-	if (tail_p)
-		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
-
-	if (packets < budget && napi_complete_done(napi, packets)) {
-		/* Re-enable RX completion interrupts. This should
-		 * cause an immediate interrupt if any RX packets are
-		 * already pending.
-		 */
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
-	}
-	return packets;
-}
-
-/**
- * axienet_tx_irq - Tx Done Isr.
- * @irq:	irq number
- * @_ndev:	net_device pointer
- *
- * Return: IRQ_HANDLED if device generated a TX interrupt, IRQ_NONE otherwise.
- *
- * This is the Axi DMA Tx done Isr. It invokes NAPI polling to complete the
- * TX BD processing.
- */
-static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
-{
-	unsigned int status;
-	struct net_device *ndev = _ndev;
-	struct axienet_local *lp = netdev_priv(ndev);
-
-	status = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-
-	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		return IRQ_NONE;
-
-	axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
-
-	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
-		netdev_err(ndev, "DMA Tx error 0x%x\n", status);
-		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
-			   (lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
-			   (lp->tx_bd_v[lp->tx_bd_ci]).phys);
-		schedule_work(&lp->dma_err_task);
-	} else {
-		/* Disable further TX completion interrupts and schedule
-		 * NAPI to handle the completions.
-		 */
-		u32 cr = lp->tx_dma_cr;
-
-		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
 
-		napi_schedule(&lp->napi_tx);
-	}
-
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
- * This is the Axi DMA Rx Isr. It invokes NAPI polling to complete the RX BD
- * processing.
- */
-static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
-{
-	unsigned int status;
-	struct net_device *ndev = _ndev;
-	struct axienet_local *lp = netdev_priv(ndev);
-
-	status = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-
-	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		return IRQ_NONE;
-
-	axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
-
-	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
-		netdev_err(ndev, "DMA Rx error 0x%x\n", status);
-		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
-			   (lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
-			   (lp->rx_bd_v[lp->rx_bd_ci]).phys);
-		schedule_work(&lp->dma_err_task);
-	} else {
-		/* Disable further RX completion interrupts and schedule
-		 * NAPI receive.
-		 */
-		u32 cr = lp->rx_dma_cr;
-
-		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_rx);
-	}
-
-	return IRQ_HANDLED;
+xmit_error_prep:
+	dma_unmap_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
+xmit_error_skb_sgvec:
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	return NETDEV_TX_BUSY;
 }
 
 /**
@@ -1121,8 +587,6 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void axienet_dma_err_handler(struct work_struct *work);
-
 /**
  * axienet_open - Driver open routine.
  * @ndev:	Pointer to net_device structure
@@ -1159,22 +623,6 @@ static int axienet_open(struct net_device *ndev)
 
 	phylink_start(lp->phylink);
 
-	/* Enable worker thread for Axi DMA error handling */
-	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
-
-	napi_enable(&lp->napi_rx);
-	napi_enable(&lp->napi_tx);
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
@@ -1183,18 +631,18 @@ static int axienet_open(struct net_device *ndev)
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
-	napi_disable(&lp->napi_tx);
-	napi_disable(&lp->napi_rx);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
-	cancel_work_sync(&lp->dma_err_task);
 	dev_err(lp->dev, "request_irq() failed\n");
 	return ret;
 }
@@ -1215,27 +663,23 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	napi_disable(&lp->napi_tx);
-	napi_disable(&lp->napi_rx);
-
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
-	axienet_dma_stop(lp);
-
 	axienet_iow(lp, XAE_IE_OFFSET, 0);
 
-	cancel_work_sync(&lp->dma_err_task);
+	dmaengine_terminate_all(lp->tx_chan);
+	dmaengine_terminate_all(lp->rx_chan);
+
+	dma_release_channel(lp->rx_chan);
+	dma_release_channel(lp->tx_chan);
 
 	if (lp->eth_irq > 0)
 		free_irq(lp->eth_irq, ndev);
-	free_irq(lp->tx_irq, ndev);
-	free_irq(lp->rx_irq, ndev);
 
-	axienet_dma_bd_release(ndev);
 	return 0;
 }
 
@@ -1277,12 +721,7 @@ static int axienet_change_mtu(struct net_device *ndev, int new_mtu)
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
 
@@ -1296,32 +735,10 @@ static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
-static void
-axienet_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
-{
-	struct axienet_local *lp = netdev_priv(dev);
-	unsigned int start;
-
-	netdev_stats_to_stats64(stats, &dev->stats);
-
-	do {
-		start = u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
-		stats->rx_packets = u64_stats_read(&lp->rx_packets);
-		stats->rx_bytes = u64_stats_read(&lp->rx_bytes);
-	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
-
-	do {
-		start = u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
-		stats->tx_packets = u64_stats_read(&lp->tx_packets);
-		stats->tx_bytes = u64_stats_read(&lp->tx_bytes);
-	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
-}
-
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
 	.ndo_start_xmit = axienet_start_xmit,
-	.ndo_get_stats64 = axienet_get_stats64,
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
@@ -1411,14 +828,8 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
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
 
 static void
@@ -1521,12 +932,30 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 			      struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
+	struct xilinx_peri_config eth_config;
+	struct dma_slave_config config;
+	u32 data, retval = 0;
+
+	eth_config.cmd = XILINX_DMA_GET_COALESCE;
+	eth_config.data = &data;
+
+	config.peripheral_config = &eth_config;
+	config.peripheral_size = sizeof(eth_config);
+
+	retval = dmaengine_slave_config(lp->tx_chan, &config);
+	if (retval)
+		netdev_err(ndev, "get coalesce failed for Tx path\n");
+	else
+		ecoalesce->tx_max_coalesced_frames += data;
+
+	retval = dmaengine_slave_config(lp->rx_chan, &config);
+	if (retval)
+		netdev_err(ndev, "get coalesce failed for Rx path\n");
+	else
+		ecoalesce->rx_max_coalesced_frames += data;
+
+	return retval;
 
-	ecoalesce->rx_max_coalesced_frames = lp->coalesce_count_rx;
-	ecoalesce->rx_coalesce_usecs = lp->coalesce_usec_rx;
-	ecoalesce->tx_max_coalesced_frames = lp->coalesce_count_tx;
-	ecoalesce->tx_coalesce_usecs = lp->coalesce_usec_tx;
-	return 0;
 }
 
 /**
@@ -1549,6 +978,15 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 			      struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
+	struct xilinx_peri_config eth_config;
+	struct dma_slave_config config;
+	u32 data, retval = 0;
+
+	eth_config.cmd = XILINX_DMA_SET_COALESCE;
+	eth_config.data = &data;
+
+	config.peripheral_config = &eth_config;
+	config.peripheral_size = sizeof(eth_config);
 
 	if (netif_running(ndev)) {
 		netdev_err(ndev,
@@ -1556,16 +994,28 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 		return -EFAULT;
 	}
 
-	if (ecoalesce->rx_max_coalesced_frames)
+	if (ecoalesce->rx_max_coalesced_frames) {
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
+		data = lp->coalesce_count_rx;
+		retval = dmaengine_slave_config(lp->rx_chan, &config);
+		if (retval)
+			netdev_err(ndev, "set coalesce failed for Rx path\n");
+	}
+
 	if (ecoalesce->rx_coalesce_usecs)
 		lp->coalesce_usec_rx = ecoalesce->rx_coalesce_usecs;
-	if (ecoalesce->tx_max_coalesced_frames)
+	if (ecoalesce->tx_max_coalesced_frames) {
 		lp->coalesce_count_tx = ecoalesce->tx_max_coalesced_frames;
+		data = lp->coalesce_count_tx;
+		retval = dmaengine_slave_config(lp->tx_chan, &config);
+		if (retval)
+			netdev_err(ndev, "set coalesce failed for Tx path\n");
+	}
+
 	if (ecoalesce->tx_coalesce_usecs)
 		lp->coalesce_usec_tx = ecoalesce->tx_coalesce_usecs;
 
-	return 0;
+	return retval;
 }
 
 static int
@@ -1744,93 +1194,6 @@ static void axienet_mac_link_up(struct phylink_config *config,
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
-	u32 i;
-	u32 axienet_status;
-	struct axidma_bd *cur_p;
-	struct axienet_local *lp = container_of(work, struct axienet_local,
-						dma_err_task);
-	struct net_device *ndev = lp->ndev;
-
-	napi_disable(&lp->napi_tx);
-	napi_disable(&lp->napi_rx);
-
-	axienet_setoptions(ndev, lp->options &
-			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-
-	axienet_dma_stop(lp);
-
-	for (i = 0; i < lp->tx_bd_num; i++) {
-		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->cntrl) {
-			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
-
-			dma_unmap_single(lp->dev, addr,
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
-	axienet_dma_start(lp);
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
-	napi_enable(&lp->napi_rx);
-	napi_enable(&lp->napi_tx);
-}
-
-/**
  * axienet_probe - Axi Ethernet probe function.
  * @pdev:	Pointer to platform device structure.
  *
@@ -1850,7 +1213,6 @@ static int axienet_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	struct resource *ethres;
 	u8 mac_addr[ETH_ALEN];
-	int addr_width = 32;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1876,12 +1238,6 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	u64_stats_init(&lp->rx_stat_sync);
-	u64_stats_init(&lp->tx_stat_sync);
-
-	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
-	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
-
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
 		/* For backward compatibility, if named AXI clock is not present,
@@ -2007,77 +1363,6 @@ static int axienet_probe(struct platform_device *pdev)
 		goto cleanup_clk;
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
-			goto cleanup_clk;
-		}
-		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
-						     &dmares);
-		lp->rx_irq = irq_of_parse_and_map(np, 1);
-		lp->tx_irq = irq_of_parse_and_map(np, 0);
-		of_node_put(np);
-		lp->eth_irq = platform_get_irq_optional(pdev, 0);
-	} else {
-		/* Check for these resources directly on the Ethernet node. */
-		lp->dma_regs = devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
-		lp->rx_irq = platform_get_irq(pdev, 1);
-		lp->tx_irq = platform_get_irq(pdev, 0);
-		lp->eth_irq = platform_get_irq_optional(pdev, 2);
-	}
-	if (IS_ERR(lp->dma_regs)) {
-		dev_err(&pdev->dev, "could not map DMA regs\n");
-		ret = PTR_ERR(lp->dma_regs);
-		goto cleanup_clk;
-	}
-	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
-		dev_err(&pdev->dev, "could not determine irqs\n");
-		ret = -ENOMEM;
-		goto cleanup_clk;
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
-	if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
-		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
-		ret = -EINVAL;
-		goto cleanup_clk;
-	}
-
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
-	if (ret) {
-		dev_err(&pdev->dev, "No suitable DMA available\n");
-		goto cleanup_clk;
-	}
-
 	/* Check for Ethernet core IRQ (optional) */
 	if (lp->eth_irq <= 0)
 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
@@ -2093,14 +1378,8 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
-	lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
-	lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
 
-	/* Reset core now that clocks are enabled, prior to accessing MDIO */
-	ret = __axienet_device_reset(lp);
-	if (ret)
-		goto cleanup_clk;
 
 	ret = axienet_mdio_setup(lp);
 	if (ret)
-- 
1.7.1

