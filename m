Return-Path: <netdev+bounces-10291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4EB72D970
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AA732811CC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E638A1FDF;
	Tue, 13 Jun 2023 05:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FAE3C27
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:44:02 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB99CE4E;
	Mon, 12 Jun 2023 22:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM7z80IZqRaYyQp2YI1JOHMAmvtGCZn5fMIVH+UXz3GIQWCV+dLcBbQytk/IFddq+u35ag4SvT+H9SHLujCGjJeG4Ln78LuKRF1xZoa5JgpWcgtGJCejUv8zP+30BH49M2KmtvhnWoRp9RrAL9QvGgYGfEyUrQM9jbTBPQ+p2ja8FTS3BE99JRTq2JMK0qyTPRvzqR5ZKMX3ZV74quy9i4XZsqO7/rvgOxwdVfKgQT6g929pWN/6KOgOzF9Dc9bo2adN43PayOYeHd2sW3BfH3FkNwH2VuauhXuOJy0DHHytdGs9EHDCBuz7ewfvWKiC8ZCwSgg/87M8bWocw2qw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdJwUsmiQHPxWhFrxGvSpVWxbw+DO65eVEH0CjIqn04=;
 b=C88vzFRcY2tMR35R+LssDEYiFBFitRKLnFOZM8Mt2mCXNy8J6Yojm1wK1WwDaYyBo5a+HKKyiPuBMYib6uGPzpwjnyph6Rr5B7EY48RtulX0AiQQxo1j7WMuD8o9F7LMWrwOaV6ordOLmdqSuq8K0ev35CB9S17Oxi1K9SBB/9/4ZPhAkZCuYc+zzYoLozTmXhCz67PvL7QDNkUZJfvK+3iNQ8vrUXLjpjBHJX1VFpVEQHNEJUmU3mjSGVXH35j7OO4p6GK2vV2+c7GovjA7TpFsCEeHYdlFHteetoowBPJ1ZBkm5TwnH/TeZSoZzdp/QQ5U297y/psX15Vbxrmpow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdJwUsmiQHPxWhFrxGvSpVWxbw+DO65eVEH0CjIqn04=;
 b=tH6t01RVKRP6dH7tIhlfXT8uAKyVPRd3fC2AphGHt2FCJeuHRwz7BePoOW+WPUEzV78yIkWV2TNF50Vluzj4XOjgF3TA5GAKzA2lWQp3dtJR54tXr+Q2lDQJIzwH6jWHbO6FcOuS9Wfb6pR56ihuVIf25PlZhG6759MRhsjcP6o=
Received: from MW4PR03CA0161.namprd03.prod.outlook.com (2603:10b6:303:8d::16)
 by CH0PR12MB8508.namprd12.prod.outlook.com (2603:10b6:610:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 05:43:56 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:303:8d:cafe::53) by MW4PR03CA0161.outlook.office365.com
 (2603:10b6:303:8d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.35 via Frontend
 Transport; Tue, 13 Jun 2023 05:43:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.23 via Frontend Transport; Tue, 13 Jun 2023 05:43:55 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 13 Jun
 2023 00:43:54 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.23 via Frontend
 Transport; Tue, 13 Jun 2023 00:43:50 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH net-next v4 2/2] net: macb: Add support for partial store and forward
Date: Mon, 12 Jun 2023 23:43:40 -0600
Message-ID: <20230613054340.12837-3-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230613054340.12837-1-pranavi.somisetty@amd.com>
References: <20230613054340.12837-1-pranavi.somisetty@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|CH0PR12MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: be0d22d6-7a94-4e2d-4a83-08db6bd12d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/w2vRK35tUqkFMtwns8rew5QZ035k2XnAsNI/sgX25j9/ovNaisrVLrbPcMKP7PtoUPUqfDDmZ+s7pCZihv7lVonNAEp9XxX/RMhdtWUnTJUpcp6oeR5SHqpR96gra72fE27UsvUBKyrD1pS161QEQyZm1vbKHij+RM+XDE7reeTix497dXD+kTLW2uuXYkRy57/8HJIZArP2CfTB1SC/r7gpssX44t7emF+zV8cQKW17H1/cQBJdCs8RpcgeArOj7ipjSdrVqiRLLzKjUR98oLCZYDsMnIaZfstrKj6BeLZ/0lOC1OQMN4yboxkWLMruwK4bhE+C+NKkwUZ/jadRh/R+jZFeF43SPyQYJyMXx0jGx6FbvjJAcj18HQ+q2/WTEvxLGUoI8AzulKEhBKNxhM1YSiuxGiKsRKxhtrX5LQq9JY3ENL9ZOQQvyFfskPhHovH/hebcw7eXZiBtOUxbUHIZVOA+AXXihrnVuGmaGm8bTZzuh7jvra3Wa89dgaFhHrbM8QniG6Ybvz1591WsYMK8B0wO6zGnZwM1T5JKhoSfHxb+MZF3Va1IfWJyfQpMevZCuk30vczXtU3FQgpC0x02C2MMvjH5KJerrAFm9V50Z/UxKE8duk5UeYo8LSHHHd9ciY/ocVn5F3uVG53qpcyk0iYDokQVncj7Rcaopj1nPtxTfvEVgueGx4caPnfKkyMe0PDGtE9tNKwyzULkp27CPi/2Ule3KZ9zsl/YB6mdcIsUYIoHM4u/z8ExU4+K3qArOviE6/pXWz3SpSV1w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(4326008)(44832011)(316002)(7416002)(41300700001)(70206006)(70586007)(186003)(2906002)(54906003)(110136005)(8676002)(8936002)(5660300002)(478600001)(6666004)(40460700003)(1076003)(82740400003)(81166007)(40480700001)(36860700001)(26005)(356005)(336012)(83380400001)(47076005)(426003)(36756003)(82310400005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 05:43:55.8484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be0d22d6-7a94-4e2d-4a83-08db6bd12d91
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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

Changes v4:
1. Removed redundant code and unused variables.
2. When the rx-watermark value is invalid, instead of returning EINVAL,
do not enable partial store and forward.
3. Change rx-watermark variable's size to u32 instead of u16.
---
 drivers/net/ethernet/cadence/macb.h      | 12 +++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 27 ++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 14dfec4db8f9..39d53117a8ce 100644
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
@@ -343,6 +344,10 @@
 #define GEM_ADDR64_SIZE		1
 
 
+/* Bitfields in PBUFRXCUT */
+#define GEM_ENCUTTHRU_OFFSET	31 /* Enable RX partial store and forward */
+#define GEM_ENCUTTHRU_SIZE	1
+
 /* Bitfields in NSR */
 #define MACB_NSR_LINK_OFFSET	0 /* pcs_link_state */
 #define MACB_NSR_LINK_SIZE	1
@@ -509,6 +514,8 @@
 #define GEM_TX_PKT_BUFF_OFFSET			21
 #define GEM_TX_PKT_BUFF_SIZE			1
 
+#define GEM_RX_PBUF_ADDR_OFFSET			22
+#define GEM_RX_PBUF_ADDR_SIZE			4
 
 /* Bitfields in DCFG5. */
 #define GEM_TSU_OFFSET				8
@@ -517,6 +524,8 @@
 /* Bitfields in DCFG6. */
 #define GEM_PBUF_LSO_OFFSET			27
 #define GEM_PBUF_LSO_SIZE			1
+#define GEM_PBUF_CUTTHRU_OFFSET			25
+#define GEM_PBUF_CUTTHRU_SIZE			1
 #define GEM_DAW64_OFFSET			23
 #define GEM_DAW64_SIZE				1
 
@@ -1283,6 +1292,9 @@ struct macb {
 
 	u32			wol;
 
+	/* holds value of rx watermark value for pbuf_rxcutthru register */
+	u32			rx_watermark;
+
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
 
 	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 41964fd02452..7d023b92b169 100644
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
@@ -4995,6 +5003,25 @@ static int macb_probe(struct platform_device *pdev)
 
 	bp->usrio = macb_config->usrio;
 
+	/* By default we set to partial store and forward mode for zynqmp.
+	 * Disable if not set in devicetree.
+	 */
+	if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
+		err = of_property_read_u32(bp->pdev->dev.of_node,
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
+			}
+		}
+	}
 	spin_lock_init(&bp->lock);
 
 	/* setup capabilities */
-- 
2.36.1


