Return-Path: <netdev+bounces-6316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80752715ABC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27A21281029
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077A7171CB;
	Tue, 30 May 2023 09:52:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5B171C1
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:52:15 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7185E10E;
	Tue, 30 May 2023 02:51:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2Ok8WB+8liNzI/EZi03nJE20SK5Jw3AimeEMkPDp/W+VgjPxgHBMtMLRG2oirr/BUWo30XDSqg4NvZ+X3pq2YWaCPNJMQ1bQ9vfcXyGVSrPCda4WJebBFJmxdmWH89fW/6I78InFx1tajXy3VWqyNAKlvsvx44MeX9hyjgGk92FHDKyR4H1kMreTbdfBfzfwi1sukz7IurWRZ1BvjlreK97lLL83HZkCgBPh2t2SKzs7E9vOiD1H7HwGJgaWcB8ocSDFQvedo6pJoia8eHJTgW83xKhF0mApIKsZkIKcGUofEV6T7Uu/uDCZTMsdQjf0v6JI0Atv37imSO6/71jbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1V+lpaqJfJFGwoO20hO4ITpBohCtCyShhCMpAHJZWY=;
 b=FCe/eYx75lTg0HDvPsn5mAjPQ30eJrLIn644f/awil7kgIMofdWI+rybI8b5EvSmkC6TU60vLX0zwVo8vVHSD0Dy9EptEXIKBm4EOuEzvAZY+yesP6twkJacJkMfaIx/adnTIY/b8dNnOANRhsTwq/vvgXJu5sYlIabxBDeWgMqILqSVJmAWiaQiJEpkRxCdyzEvrkiYge/PneJ3UcIIjC+P77mOUrBmWWcyLUakyB3Iu4p/7F5eoy1fPy5s4xY50TCMoKm6K4qiL4PepNrnyYmKxEfOGgzhe8uAE8Hp6yoFUz04nDZr0Mbcqy0CG/Uib4v7tiLNG71F8i5VXF1n/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1V+lpaqJfJFGwoO20hO4ITpBohCtCyShhCMpAHJZWY=;
 b=SW4J/Y1dtFqao3I1qjz78vORkqyTJvBPQLZCyrxHDMHOL2vzBTW1IuvFRw37U48hDqN7feTlQGdA3koRPw+pyEahlauB86eBkakRO8WVY25jNqXMuwonRXUcfxWFyNCQwxZsZWZgGrGPIL6TpZgBEMkWBAXcB5NmHbU5jpFOPDw=
Received: from SJ0PR03CA0085.namprd03.prod.outlook.com (2603:10b6:a03:331::30)
 by PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Tue, 30 May
 2023 09:51:54 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:331:cafe::24) by SJ0PR03CA0085.outlook.office365.com
 (2603:10b6:a03:331::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 09:51:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.21 via Frontend Transport; Tue, 30 May 2023 09:51:53 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 04:51:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 02:51:52 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 30 May 2023 04:51:48 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH net-next v3 2/2] net: macb: Add support for partial store and forward
Date: Tue, 30 May 2023 03:51:38 -0600
Message-ID: <20230530095138.1302-3-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230530095138.1302-1-pranavi.somisetty@amd.com>
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 17da194a-b848-40f9-2a26-08db60f37fa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8U+5MHPid5Jpe/QW6TUhHDZk/ANP/4P7fuqBFgpChWkYFOf9XJsT81zj9Vv1GpawubRDAlrT7KPxQV2jXAmS4gHSe3zl2IumvPs3P6RY9vniQ981b00znuks8DN5VU8FD+rzkkbDbAqDHgT9NEB11txnOhMjxEZOZheNAlk6VtAX1dxEqs3+7/iDZhQNi5qYPSbfZwa2WvDYBo7tUha2DBymDyhppnka1HF8UuclOlOfIm2txyQJvN8aN0PcNGYL0Y1BeG3cWOx2vHSDnyXhq/WulT0HxDqB0ZY1PtRC48FrJIqNKL6d72bRPN2DUG1prjno350CB+TXCKE1AbNga8U1UnRSa7Lyo10mbiAOmZZDD6Zzo31gRLIJZtkZ8JBFVuhDFNVnat13BmYcy4QeEmhCzGWW5SwNRoZ/I9wTvaKQ0QN2qoGCvkpLRL1X7OyLtMHATtxAssL4AzHB7mCjAH610aFHnG8u1850+lCC+f5gDtUNYwl8apGEI9BN1GVf97lxZThTcbKDWxQXeJ/GVF1tSbwDOT/xI0DDUZ4UA0RjAEuqGh4ybALvsvsHccUP6MUmDXyKo5b4tJkWOROKMxcV/PLe9CF3lBXM7TfnKdTtwgmL7AdZ1S3Olvn1AHDmoS9WeZimgk2clS5ftZeKIniLJk/n+3Z2MMN6qZ2NB8NMVD9jZcC3rrYrI60rlhVXS7Ro8YYH2sVnDyKLMd/a9p3AsK6WFVFzKyTBOZCf21bNSHwgyvc31AhCGmilqEUK9CtYEIGuY13GefnI5BSa1w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(81166007)(426003)(336012)(36860700001)(2616005)(83380400001)(47076005)(110136005)(54906003)(478600001)(82310400005)(70206006)(316002)(356005)(186003)(41300700001)(70586007)(6666004)(26005)(1076003)(4326008)(5660300002)(44832011)(8936002)(40460700003)(7416002)(8676002)(36756003)(82740400003)(2906002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:51:53.7020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17da194a-b848-40f9-2a26-08db60f37fa1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maulik Jodhani <maulik.jodhani@xilinx.com>

When the receive partial store and forward mode is activated, the
receiver will only begin to forward the packet to the external AHB
or AXI slave when enough packet data is stored in the packet buffer.
The amount of packet data required to activate the forwarding process
is programmable via watermark registers which are located at the same
address as the partial store and forward enable bits. Adding support to
read this rx-watermark value from device-tree, to program the watermark
registers and enable partial store and forwarding.

Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
Changes v2:
1. Removed all the changes related to validating FCS when Rx checksum offload is disabled.
2. Instead of using a platform dependent number (0xFFF) for the reset value of rx watermark,
derive it from designcfg_debug2 register.
3. Added a check to see if partial s/f is supported, by reading the
designcfg_debug6 register.

Changes v3:
1. Followed reverse christmas tree pattern in declaring variables.
2. Return -EINVAL when an invalid watermark value is set.
3. Removed netdev_info when partial store and forward is not enabled.
4. Validating the rx-watermark value in probe itself and only write to the register
in init.
5. Writing a reset value to the pbuf_cuthru register before disabing partial store
and forward is redundant. So removing it.
6. Removed the platform caps flag.
7. Instead of reading rx-watermark from DT in macb_configure_caps,
reading it in probe.
8. Changed Signed-Off-By and author names on this patch.
---
 drivers/net/ethernet/cadence/macb.h      | 14 ++++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 29 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 14dfec4db8f9..416e6070e4ec 100644
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
+#define GEM_PBUF_CUTTHRU_OFFSET			25
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
index 41964fd02452..7a31e6673e15 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2617,6 +2617,9 @@ static void macb_reset_hw(struct macb *bp)
 	macb_writel(bp, TSR, -1);
 	macb_writel(bp, RSR, -1);
 
+	/* Disable RX partial store and forward and reset watermark value */
+	gem_writel(bp, PBUFRXCUT, 0);
+
 	/* Disable all interrupts */
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		queue_writel(queue, IDR, -1);
@@ -2770,6 +2773,10 @@ static void macb_init_hw(struct macb *bp)
 		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
 
 	macb_configure_dma(bp);
+
+	/* Enable RX partial store and forward and set watermark */
+	if (bp->rx_watermark)
+		gem_writel(bp, PBUFRXCUT, (bp->rx_watermark | GEM_BIT(ENCUTTHRU)));
 }
 
 /* The hash address register is 64 bits long and takes up two
@@ -4923,6 +4930,7 @@ static int macb_probe(struct platform_device *pdev)
 	phy_interface_t interface;
 	struct net_device *dev;
 	struct resource *regs;
+	u32 wtrmrk_rst_val;
 	void __iomem *mem;
 	struct macb *bp;
 	int err, val;
@@ -4995,6 +5003,27 @@ static int macb_probe(struct platform_device *pdev)
 
 	bp->usrio = macb_config->usrio;
 
+	/* By default we set to partial store and forward mode for zynqmp.
+	 * Disable if not set in devicetree.
+	 */
+	if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
+		err = of_property_read_u16(bp->pdev->dev.of_node,
+					   "cdns,rx-watermark",
+					   &bp->rx_watermark);
+
+		if (!err) {
+			/* Disable partial store and forward in case of error or
+			 * invalid watermark value
+			 */
+			wtrmrk_rst_val = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
+			if (bp->rx_watermark > wtrmrk_rst_val || !bp->rx_watermark) {
+				dev_info(&bp->pdev->dev, "Invalid watermark value\n");
+				bp->rx_watermark = 0;
+				return -EINVAL;
+			}
+			bp->rx_watermark &= wtrmrk_rst_val;
+		}
+	}
 	spin_lock_init(&bp->lock);
 
 	/* setup capabilities */
-- 
2.36.1


