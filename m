Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8930064B4F0
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 13:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiLMMQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 07:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbiLMMOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 07:14:42 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9296E1FF8B;
        Tue, 13 Dec 2022 04:12:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQbArla+Ax3MaRiKl2UEitB/OiGNxY74wVORsc6hhXf65W0QR6KZQqWdBQZjMdsSwwh8OtWV6NLIRFi4Gumq8FHNmMTTDjXwsWZbtQMv3sNHkK/2w7o0qgrIHsyOMnU6LsOmV809FIqbtUKIVe7iDjUNFugsUHM6UYkIwCQvhos1U1ckIj9MRf2Kfq4u7AJ3jsTFX7bUsBRhx0whmJQr40n4DyWC8Gn8RQ91Fgd9IcCVbP+wGBNjVlOKO0cgS6dSavyIjYVWs9aRTLyXhW27lHmoWZBsiiqUl2qzdWnuVPAmuBTHa8uqEKY2tTLQq37KBBlfe2zrACvRN2mzjMttdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66NvGgHDT60D0+F82bviaimtWmMdBk0herBPn5X+ZbU=;
 b=E/t+lIlHOxh3C5FnF77j0HfysW7hEOnZDIX+2qgxegicy0UZiIXKfZxqz7XW1wtA52Mi+TeEg9PwOFq+nqDoYlaxlfPI0ijEn/E3kTN7tvRKREM8cDvyus2ZAUx6uDny2FL8CN5bLiCoEUwx/IxDWZNcP0Fvun+hJSBOrMnZG/34uY8xSPt/yI4KGy2+QdArb6McYTxfHph3YvaEi0WDPUgOrcaMxdJcZMom63cC1+RPGyu1yMvF61y0uY89TQ+ifZXvXAIo79Q9JloIeUheGgAKow7wd5heoeFc4nGh3IXpWe9mko6IQXhuAw3l454+MN0k0gywoDnSipcfefeUvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66NvGgHDT60D0+F82bviaimtWmMdBk0herBPn5X+ZbU=;
 b=QPD02LUmgKrCP2Jf4ZlE1bk0WAg7l7WW3ewICcnRldkpa+EygZBRQFGkQtNfUMuROlYW3DLgUnS2kpk+bLUiSRXO8Md/8Dl1jg09foXQwrGxyenkyup6T8XxQlt3oBOQrOE8TRia5OXSncSgll0rknbmDIqiSil5Fi5tQCztXQc=
Received: from DS7PR03CA0105.namprd03.prod.outlook.com (2603:10b6:5:3b7::20)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 12:12:57 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::cd) by DS7PR03CA0105.outlook.office365.com
 (2603:10b6:5:3b7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Tue, 13 Dec 2022 12:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.21 via Frontend Transport; Tue, 13 Dec 2022 12:12:56 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 06:12:54 -0600
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 13 Dec 2022 06:12:51 -0600
From:   Pranavi Somisetty <pranavi.somisetty@amd.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <git@amd.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <pranavi.somisetty@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: [LINUX RFC PATCH] net: macb: Add support for partial store and forward
Date:   Tue, 13 Dec 2022 05:12:45 -0700
Message-ID: <20221213121245.13981-1-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT095:EE_|BL1PR12MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: e7033285-f053-4836-b172-08dadd035e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CTlb2e/X6K3q/ueD/iUz1K0OuZfz2rTeH9ibKob5yOTlWFbYr/xqo3N2dM0HArCl63NguhsAJW1z8q0Z7q+L5ztqwO6O5oRbZUnnjgzyqmIrmDcUad7motrMpplNLpknXCkDzjYlrv8MzuPetg+0NLvAhy4m6jhh0aRGE/FmG7+q8SM2o/SeLc6EhFlNsD9FLlgQk39DNUhQ9SpzOY27Tmr9cUQZOsmXFOZ0vF4MSvvrUIwbKJbqvAAHkUipBdw8awI1FVgKf23H+JZSa+L+VCg369tb9YXKse2hhrTovQprG0XKxAUPuFSV8FUHn/T5ZCiAakLeEF0xPlEWzfecU1eoPYsduuhvv8dF0T91ljQXP7JlUNbJAJZeVtES7/ZNj3afTFIilwRgZMBNOePKNJF6nfqYcMWNSRhnzPwdvAMB/d4+E9uOWxDNqB6vQeN7Qcn+cl7RU1yn9QU2NH3EafHhCluRKPs4k3yKklUFayuVlRX2R1jHw/Y57/xln9zPpQgSwe75iLFAkrcgHAMX+TOhrBh5aJLSpgvKoDTdpQuWq44e/m/U6X9cvYxjystSSZX6VhnTKEiRcQ5Icjd4cpFNw5qrbw5UcN5IvpdJ+R1Kv4Z0BNTUwMbD8+A6P+bVaii4xhSD5sOdCVgogvlZ0fow2M+RD0h5ugo3U1EUQPMQ9K1/H3bLemicmgK3XqEmy12CFH504Rl5Pyxen3Q+sK2l0E2XfO6JO1MKFR81SE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(36756003)(40460700003)(356005)(82740400003)(83380400001)(81166007)(316002)(110136005)(70206006)(70586007)(8676002)(54906003)(36860700001)(86362001)(40480700001)(6666004)(1076003)(5660300002)(44832011)(2906002)(336012)(478600001)(4326008)(82310400005)(186003)(426003)(41300700001)(47076005)(26005)(2616005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 12:12:56.3429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7033285-f053-4836-b172-08dadd035e5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maulik Jodhani <maulik.jodhani@xilinx.com>

- Validate FCS in receive interrupt handler if Rx checksum offloading
  is disabled
- Get rx-watermark value from DT

Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
 drivers/net/ethernet/cadence/macb.h      | 10 +++
 drivers/net/ethernet/cadence/macb_main.c | 79 +++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9c410f93a103..e4eebe8c8c46 100644
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
@@ -342,6 +343,11 @@
 #define GEM_ADDR64_OFFSET	30 /* Address bus width - 64b or 32b */
 #define GEM_ADDR64_SIZE		1
 
+/* Bitfields in PBUFRXCUT */
+#define GEM_WTRMRK_OFFSET	0 /* Watermark value offset */
+#define GEM_WTRMRK_SIZE		12
+#define GEM_ENCUTTHRU_OFFSET	31 /* Enable RX partial store and forward */
+#define GEM_ENCUTTHRU_SIZE	1
 
 /* Bitfields in NSR */
 #define MACB_NSR_LINK_OFFSET	0 /* pcs_link_state */
@@ -720,6 +726,7 @@
 #define MACB_CAPS_NEED_TSUCLK			0x00000400
 #define MACB_CAPS_PCS				0x01000000
 #define MACB_CAPS_HIGH_SPEED			0x02000000
+#define MACB_CAPS_PARTIAL_STORE_FORWARD		0x00000800
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
 #define MACB_CAPS_MACB_IS_EMAC			0x08000000
 #define MACB_CAPS_FIFO_MODE			0x10000000
@@ -1296,6 +1303,9 @@ struct macb {
 
 	u32			wol;
 
+	/* holds value of rx watermark value for pbuf_rxcutthru register */
+	u16			rx_watermark;
+
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
 
 	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..1f09fe1eec76 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -39,6 +39,7 @@
 #include <linux/ptp_classify.h>
 #include <linux/reset.h>
 #include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/crc32.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -1314,6 +1315,15 @@ static void discard_partial_frame(struct macb_queue *queue, unsigned int begin,
 	 */
 }
 
+static int macb_validate_hw_csum(struct sk_buff *skb)
+{
+	u32 pkt_csum = *((u32 *)&skb->data[skb->len - ETH_FCS_LEN]);
+	u32 csum  = ~crc32_le(~0, skb_mac_header(skb),
+			skb->len + ETH_HLEN - ETH_FCS_LEN);
+
+	return (pkt_csum != csum);
+}
+
 static int gem_rx(struct macb_queue *queue, struct napi_struct *napi,
 		  int budget)
 {
@@ -1375,6 +1385,16 @@ static int gem_rx(struct macb_queue *queue, struct napi_struct *napi,
 				 bp->rx_buffer_size, DMA_FROM_DEVICE);
 
 		skb->protocol = eth_type_trans(skb, bp->dev);
+
+		/* Validate MAC fcs if RX checsum offload disabled */
+		if (!(bp->dev->features & NETIF_F_RXCSUM)) {
+			if (macb_validate_hw_csum(skb)) {
+				netdev_err(bp->dev, "incorrect FCS\n");
+				bp->dev->stats.rx_dropped++;
+				break;
+			}
+		}
+
 		skb_checksum_none_assert(skb);
 		if (bp->dev->features & NETIF_F_RXCSUM &&
 		    !(bp->dev->flags & IFF_PROMISC) &&
@@ -1472,6 +1492,19 @@ static int macb_rx_frame(struct macb_queue *queue, struct napi_struct *napi,
 			break;
 	}
 
+	/* Validate MAC fcs if RX checsum offload disabled */
+	if (!(bp->dev->features & NETIF_F_RXCSUM)) {
+		if (macb_validate_hw_csum(skb)) {
+			netdev_err(bp->dev, "incorrect FCS\n");
+			bp->dev->stats.rx_dropped++;
+
+			/* Make descriptor updates visible to hardware */
+			wmb();
+
+			return 1;
+		}
+	}
+
 	/* Make descriptor updates visible to hardware */
 	wmb();
 
@@ -2567,6 +2600,10 @@ static void macb_reset_hw(struct macb *bp)
 	macb_writel(bp, TSR, -1);
 	macb_writel(bp, RSR, -1);
 
+	/* Disable RX partial store and forward and reset watermark value */
+	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD)
+		gem_writel(bp, PBUFRXCUT, 0xFFF);
+
 	/* Disable all interrupts */
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		queue_writel(queue, IDR, -1);
@@ -2700,7 +2737,11 @@ static void macb_init_hw(struct macb *bp)
 
 	config = macb_mdc_clk_div(bp);
 	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
-	config |= MACB_BIT(DRFCS);		/* Discard Rx FCS */
+
+	/* Do not discard Rx FCS if RX checsum offload disabled */
+	if (bp->dev->features & NETIF_F_RXCSUM)
+		config |= MACB_BIT(DRFCS);		/* Discard Rx FCS */
+
 	if (bp->caps & MACB_CAPS_JUMBO)
 		config |= MACB_BIT(JFRAME);	/* Enable jumbo frames */
 	else
@@ -2720,6 +2761,15 @@ static void macb_init_hw(struct macb *bp)
 		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
 
 	macb_configure_dma(bp);
+
+	/* Enable RX partial store and forward and set watermark */
+	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
+		gem_writel(bp, PBUFRXCUT,
+			   (gem_readl(bp, PBUFRXCUT) &
+			   GEM_BF(WTRMRK, bp->rx_watermark)) |
+			   GEM_BIT(ENCUTTHRU));
+	}
+
 }
 
 /* The hash address register is 64 bits long and takes up two
@@ -3812,10 +3862,29 @@ static void macb_configure_caps(struct macb *bp,
 				const struct macb_config *dt_conf)
 {
 	u32 dcfg;
+	int retval;
 
 	if (dt_conf)
 		bp->caps = dt_conf->caps;
 
+	/* By default we set to partial store and forward mode for zynqmp.
+	 * Disable if not set in devicetree.
+	 */
+	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
+		retval = of_property_read_u16(bp->pdev->dev.of_node,
+					      "rx-watermark",
+					      &bp->rx_watermark);
+
+		/* Disable partial store and forward in case of error or
+		 * invalid watermark value
+		 */
+		if (retval || bp->rx_watermark > 0xFFF) {
+			dev_info(&bp->pdev->dev,
+				 "Not enabling partial store and forward\n");
+			bp->caps &= ~MACB_CAPS_PARTIAL_STORE_FORWARD;
+		}
+	}
+
 	if (hw_is_gem(bp->regs, bp->native_io)) {
 		bp->caps |= MACB_CAPS_MACB_IS_GEM;
 
@@ -4072,6 +4141,8 @@ static int macb_init(struct platform_device *pdev)
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
 		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD)
+		dev->hw_features &= ~NETIF_F_RXCSUM;
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
 		dev->hw_features &= ~NETIF_F_SG;
 	dev->features = dev->hw_features;
@@ -4763,7 +4834,8 @@ static const struct macb_config np4_config = {
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
-		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH |
+		MACB_CAPS_PARTIAL_STORE_FORWARD,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = init_reset_optional,
@@ -4811,7 +4883,8 @@ static const struct macb_config sama7g5_emac_config = {
 
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

