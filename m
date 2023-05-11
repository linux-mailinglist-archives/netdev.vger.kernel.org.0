Return-Path: <netdev+bounces-1677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3E16FEC71
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812B81C20EC1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EAB27731;
	Thu, 11 May 2023 07:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BDD2772A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:12:37 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F0261B3;
	Thu, 11 May 2023 00:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpKGx01CEyzYZXjd/PCGoG2mRba3C6Fbh8yQJdTIfIjx8SYdBz9KWhThacJvuLNqQUftZUd9bSR3Ld/vkceBI2pCuGA0DL3VZX3sm5xlr7nR/ngb2WVKCRczvsEIVV7pNlPsmnzGjoGi3SFAWSFLoQPKgUUzxaf1PY7AavbOKAVLDRZZFWtx977Y6rIISMx9CTA5qrkwrfampXR6FaBtUO4CKy15NFyFOUljaalZx0d9qQ7z19JA0gFzDEU3kTUYeDr+s53WG8s1htbJVffhQfgp2b+DPqqJz4C9NgQayXpyG/ooFSJoQcy9QDypWH+HewYqi5+IMsFU0GBfNkcRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BpMtxYY9uOHsE9v0E5qoijwNs+/nAC8tEbbVEz5G38=;
 b=GPKU1BLWmjbGgLCxTsK4J0Q1Ata8s+4NVNv5CbSlINn6LkjYK6cD07uOSGhTbgsDl+aKwPj9WCUtxs8gB3609SReGYdXlbEVuwGS1YWCjsBr+6dizzvDyD2Z5vtdVatiHnwOQAzO45HsK/YHVppQ9sWM+Hy2j9u4RRk3Z6jAtmVvETu+pUQWrAGLoHBKmb+mmEdI0NxeT67edOWKTLfUUsPX2QHJUoTCwgaYceWRLjFuW5x/u7uMHgq7VOVlWwpEzsqBTGPWswoC8ULh/pjXTJyxnHsVRErYs1TOeYBSJOS+kK02bBCUkguSliZzWlB8VnLY4LaacWpAh0flFZEGJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BpMtxYY9uOHsE9v0E5qoijwNs+/nAC8tEbbVEz5G38=;
 b=z6irzo6IMiWJqH182YRV07f57NbTeuKr/smvZ9PdMZFf6cN5k5/XVUdYt3MEYU67I/D1ROEdMTY6h1+o2/jClTQguT1qmp25qCIquElsATtKw6PzFaBkxZhEUXtSouRrFRP4fLrwdgov57Z8Udx1LbKhfM/F6KTRM30pXYQF7Sw=
Received: from DS7PR03CA0176.namprd03.prod.outlook.com (2603:10b6:5:3b2::31)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 07:12:30 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::a) by DS7PR03CA0176.outlook.office365.com
 (2603:10b6:5:3b2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20 via Frontend
 Transport; Thu, 11 May 2023 07:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.19 via Frontend Transport; Thu, 11 May 2023 07:12:29 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 02:12:29 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 00:12:29 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 02:12:24 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
	<palmer@dabbelt.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
Subject: [PATCH net-next v2 2/2] net: macb: Add support for partial store and forward
Date: Thu, 11 May 2023 01:12:14 -0600
Message-ID: <20230511071214.18611-3-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230511071214.18611-1-pranavi.somisetty@amd.com>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT006:EE_|MW6PR12MB8959:EE_
X-MS-Office365-Filtering-Correlation-Id: 191b4262-eacc-43db-4eba-08db51ef154e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rj3V7ZXaHbb3yDjimzMIQriISBDtN3Yy5G7Y8ndtnVLcuArFtts7iLRfMREApsFXzPOop2PdUtkbgIdBRIB8zc6Bx5kauB2tgM5WzYEL/yux8j9N54JUK1sVrQnecU2I4wAvZgIM1D2LDf0YN9y4o8i449BRHT0xSCZxO8rzuMo9s6t6KYZLmPR52ng4cMdiirR6ALCjzoFJ0xyFXH56Nxz8+NexZOJ68330niOyrNop6SSB0EjLEuIZYt6rVXZj9kMCKHiilN5qte0F+OdNwrc6Tfcvj65bUr2P13E5aaKe95Yk1lu2fH5PeKVhnmcvq5RZ1P++IoxB89/bSGu/d2yqV5dODlcXtyXF0EzQYtDCjyRM0+XE3sJ5wCHMjx5FAI4tHmwb46qoMO6b3i9X+nBEcozC9uKVherJQKlW1+aLiFzTzFxhV1VImIq5LaWBod9xJr3+/lH/mPIOLuElDxZiVH87J2ZidRe1V1/j23gv470wh1WtbcZViPfc8UqGWaXJtxPzqHRhpvCZEw+sWlTOJroXYgF2YayLZe8FxI2nW0eNjcaMzOw8jJXMkhO+jFwt7XhoUOh6qhhBcblLfNDGCgqsIGTBoIRzostGt4Oobl3sPItMWoHTMNhFQzNJPDkWEkvU4arfU6qbMM+Muw3/yBTiR5WyqELgxewliDN5+SmlQPtuKiw/V6G/CdDGCNrXo9oUz3302MM1F/sxAfja1WqsGdFWniSYl7R8VwtNIqw/ZieCBJK66nHAf8aw3DRK0fJokb1bRMno2YXEiQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(4326008)(40460700003)(54906003)(70586007)(70206006)(478600001)(110136005)(8676002)(5660300002)(2906002)(44832011)(8936002)(7416002)(316002)(336012)(426003)(41300700001)(40480700001)(356005)(82740400003)(26005)(1076003)(82310400005)(186003)(81166007)(36860700001)(83380400001)(2616005)(47076005)(36756003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 07:12:29.8763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 191b4262-eacc-43db-4eba-08db51ef154e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the receive partial store and forward mode is activated, the
receiver will only begin to forward the packet to the external AHB
or AXI slave when enough packet data is stored in the packet buffer.
The amount of packet data required to activate the forwarding process
is programmable via watermark registers which are located at the same
address as the partial store and forward enable bits. Adding support to
read this rx-watermark value from device-tree, to program the watermark
registers and enable partial store and forwarding.

Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
Changes v2:

1. Removed all the changes related to validating FCS when Rx checksum offload is disabled.
2. Instead of using a platform dependent number (0xFFF) for the reset value of rx watermark,
derive it from designcfg_debug2 register.
3. Added a check to see if partial s/f is supported, by reading the
designcfg_debug6 register.
---
 drivers/net/ethernet/cadence/macb.h      | 14 +++++++
 drivers/net/ethernet/cadence/macb_main.c | 49 +++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 14dfec4db8f9..46833662094d 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -82,6 +82,7 @@
 #define GEM_NCFGR		0x0004 /* Network Config */
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
+#define GEM_PBUFRXCUT		0x0044 /* RX Partial Store and Forward */
 #define GEM_JML			0x0048 /* Jumbo Max Length */
 #define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
 #define GEM_HRB			0x0080 /* Hash Bottom */
@@ -343,6 +344,11 @@
 #define GEM_ADDR64_SIZE		1
 
 
+/* Bitfields in PBUFRXCUT */
+#define GEM_WTRMRK_OFFSET	0 /* Watermark value offset */
+#define GEM_ENCUTTHRU_OFFSET	31 /* Enable RX partial store and forward */
+#define GEM_ENCUTTHRU_SIZE	1
+
 /* Bitfields in NSR */
 #define MACB_NSR_LINK_OFFSET	0 /* pcs_link_state */
 #define MACB_NSR_LINK_SIZE	1
@@ -509,6 +515,8 @@
 #define GEM_TX_PKT_BUFF_OFFSET			21
 #define GEM_TX_PKT_BUFF_SIZE			1
 
+#define GEM_RX_PBUF_ADDR_OFFSET			22
+#define GEM_RX_PBUF_ADDR_SIZE			4
 
 /* Bitfields in DCFG5. */
 #define GEM_TSU_OFFSET				8
@@ -517,6 +525,8 @@
 /* Bitfields in DCFG6. */
 #define GEM_PBUF_LSO_OFFSET			27
 #define GEM_PBUF_LSO_SIZE			1
+#define GEM_PBUF_CUTTHRU_OFFSET			26
+#define GEM_PBUF_CUTTHRU_SIZE			1
 #define GEM_DAW64_OFFSET			23
 #define GEM_DAW64_SIZE				1
 
@@ -718,6 +728,7 @@
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
 #define MACB_CAPS_MIIONRGMII			0x00000200
 #define MACB_CAPS_NEED_TSUCLK			0x00000400
+#define MACB_CAPS_PARTIAL_STORE_FORWARD		0x00000800
 #define MACB_CAPS_PCS				0x01000000
 #define MACB_CAPS_HIGH_SPEED			0x02000000
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
@@ -1283,6 +1294,9 @@ struct macb {
 
 	u32			wol;
 
+	/* holds value of rx watermark value for pbuf_rxcutthru register */
+	u16			rx_watermark;
+
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
 
 	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 41964fd02452..07b9964e7aa3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2600,6 +2600,7 @@ static void macb_init_rings(struct macb *bp)
 static void macb_reset_hw(struct macb *bp)
 {
 	struct macb_queue *queue;
+	u16 watermark_reset_value;
 	unsigned int q;
 	u32 ctrl = macb_readl(bp, NCR);
 
@@ -2617,6 +2618,12 @@ static void macb_reset_hw(struct macb *bp)
 	macb_writel(bp, TSR, -1);
 	macb_writel(bp, RSR, -1);
 
+	/* Disable RX partial store and forward and reset watermark value */
+	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
+		watermark_reset_value = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
+		gem_writel(bp, PBUFRXCUT, watermark_reset_value);
+	}
+
 	/* Disable all interrupts */
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		queue_writel(queue, IDR, -1);
@@ -2743,6 +2750,8 @@ static void macb_configure_dma(struct macb *bp)
 
 static void macb_init_hw(struct macb *bp)
 {
+	u16 watermark_reset_value;
+	u16 watermark_value;
 	u32 config;
 
 	macb_reset_hw(bp);
@@ -2770,6 +2779,14 @@ static void macb_init_hw(struct macb *bp)
 		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
 
 	macb_configure_dma(bp);
+
+	/* Enable RX partial store and forward and set watermark */
+	if ((bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) && bp->rx_watermark) {
+		watermark_reset_value = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
+		watermark_value = bp->rx_watermark & watermark_reset_value;
+		gem_writel(bp, PBUFRXCUT,
+			   (watermark_value | GEM_BIT(ENCUTTHRU)));
+	}
 }
 
 /* The hash address register is 64 bits long and takes up two
@@ -3861,11 +3878,37 @@ static const struct net_device_ops macb_netdev_ops = {
 static void macb_configure_caps(struct macb *bp,
 				const struct macb_config *dt_conf)
 {
+	u32 wtrmrk_rst_val;
+	int retval;
 	u32 dcfg;
 
 	if (dt_conf)
 		bp->caps = dt_conf->caps;
 
+	/* By default we set to partial store and forward mode for zynqmp.
+	 * Disable if not set in devicetree.
+	 */
+	if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
+		if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
+			retval = of_property_read_u16(bp->pdev->dev.of_node,
+						      "rx-watermark",
+						      &bp->rx_watermark);
+
+			/* Disable partial store and forward in case of error or
+			 * invalid watermark value
+			 */
+			wtrmrk_rst_val = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
+			if (retval || bp->rx_watermark > wtrmrk_rst_val || !bp->rx_watermark) {
+				if (bp->rx_watermark > wtrmrk_rst_val) {
+					dev_info(&bp->pdev->dev, "Invalid watermark value\n");
+					bp->rx_watermark = 0;
+				}
+				dev_info(&bp->pdev->dev, "Not enabling partial store and forward\n");
+				bp->caps &= ~MACB_CAPS_PARTIAL_STORE_FORWARD;
+			}
+		}
+	}
+
 	if (hw_is_gem(bp->regs, bp->native_io)) {
 		bp->caps |= MACB_CAPS_MACB_IS_GEM;
 
@@ -4813,7 +4856,8 @@ static const struct macb_config np4_config = {
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
-		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH |
+		MACB_CAPS_PARTIAL_STORE_FORWARD,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = init_reset_optional,
@@ -4861,7 +4905,8 @@ static const struct macb_config sama7g5_emac_config = {
 
 static const struct macb_config versal_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
-		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH | MACB_CAPS_NEED_TSUCLK,
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH |
+		MACB_CAPS_NEED_TSUCLK | MACB_CAPS_PARTIAL_STORE_FORWARD,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = init_reset_optional,
-- 
2.36.1


