Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF157B57E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbiGTLaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiGTL3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:29:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47886FA15;
        Wed, 20 Jul 2022 04:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egEQNxUS9LlTFeH+nVyh6/aJus9wjyAQv+a2SjL6NmAWJqPoc1N4BE9EqBUHWXFWHLLkOs6sgxqTD2FanFC8lyXce4r0AV9OKUcboA7euLIZCilMkX2yjCJVpn5tjih0UDragSJ1sLVvIPYey6RCdzqUCuq7V5dH5xHdmsYTYe9uC6ONkkq3QrFCGvp4Cypjfxzj2r/Rrjoh4CLCwfFPQUq9ASUOD3eKiTzCgDf6MgeK88gYH/B+b1bHG3E9ui/z0T653V0iUsXgcWd9+Kj9FUck4KYfq6sfvxtKUfAb10XTcm9jeiFOXYJxjcCZr+vaIb6/2G3E95Nu26kRcIguFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRBxWzBiN7lTSqBFjCEii9PtPGT8QfT32cC3uurOcBg=;
 b=YIXF0ziTcmVHQR4U8a7RmtPEySuyV/GXF5wMataU+10IA9Y2wMPqR5w7dACic3Z6jMBiIIIy1Kp5Q6A4yD5MXDL3oohf5eM4oHOtsusTLB7lb85tK6Ul3h957W/OwmXWESUhFdFevAMuM41OKu08gEKQLue3LS73xKuAinLyFZEHqmGg8DmCiyMEFH7QsjydjMUMJ9JUdxu/Cq3ICisssKT2RyTTLY9I4/LPOYXXwXQdSTMAFLgIGjWV0HxaEkSX4T6CqotWJzUIMUOFH2d6KJ4gEGAEr4zHHmHKTutQT1CcD6UWB4BqdNvcNXKthJRJlhzBYMqrI+RLzfXSf6POkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRBxWzBiN7lTSqBFjCEii9PtPGT8QfT32cC3uurOcBg=;
 b=foJQaAeh3kGu9vzYEgv+wrOZuUwD1J3ETPUZKSKZ4tnO2HpbYhMJQc+571sSWjdryXCLyDuDOxfbipRY+mTza8HkPCApUG7mw67GyU/leXKkTEynq2NOET5ckQg7PKoT4bQ5xHAU2YKnHdeHEv4/UMLMK3xoduULSY3boFOGH8c=
Received: from BN0PR02CA0046.namprd02.prod.outlook.com (2603:10b6:408:e5::21)
 by CH2PR02MB6725.namprd02.prod.outlook.com (2603:10b6:610:ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 11:29:38 +0000
Received: from BN1NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::3d) by BN0PR02CA0046.outlook.office365.com
 (2603:10b6:408:e5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 20 Jul 2022 11:29:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT027.mail.protection.outlook.com (10.13.2.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 11:29:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Jul 2022 04:29:37 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Jul 2022 04:29:37 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=60628 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oE7tY-0006pR-Rk; Wed, 20 Jul 2022 04:29:37 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <devicetree@vger.kernel.org>,
        <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 2/2] net: macb: Update tsu clk usage in runtime suspend/resume for Versal
Date:   Wed, 20 Jul 2022 16:59:24 +0530
Message-ID: <20220720112924.1096-3-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220720112924.1096-1-harini.katakam@xilinx.com>
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b83d1c65-cd63-4675-b9d4-08da6a432197
X-MS-TrafficTypeDiagnostic: CH2PR02MB6725:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYVhq7OkP9POsTYiWvUS2QBSSwkif09xvMyO3x4ztnQqCZ5Hsoh/pYaOtqFre0DLdADbQJHk5KpTTCHRwIDwS5jB2ouwM8DYtikLoBDZYigwUpw1aAivEx/RjFTmIpBowGvrXXSbVMaX1XGLCi2aWPEfiPZC9C7ozvKuRNeMML2EmhUFTqNavJWE8zgX+whP5z9ULerhFtWmU7MedzKEPndSEwJBlotxvv+oUcPnG1GfA2RvyYKVMoIlwwLlnWiMqAh36yAefaP5OmzdYE9G5jj4tMd9g8sva8/rW650BX2xUMyQCRAu+SiwQNyZI4zW0/uRAIwplqSmHXyG/FkZGLoYzvV4xm/Ki2lu2OoIJcYtqWxAuebmVwjBX7mUT7BvygrRPK+3/mvYtRMi9tFySFVI4jafq2oYS5G08SinO2RTGOJ3+KorzZggv9gZioTj9cmwD1l1Ct/nT7a+cbmeM9GQf4KGaFQhE9Uay7vxuANeo5fD5pTm7/2TvyAggl96Ur/GSEie95p3G2qsdAwLYZ6VgEJirCoYD6filEr5r0cSCNh1h0qOaCvBljx32Ci/ZO8pE1Yc1Tjb7TSMicb+AM5SGulndQ+bZSsPdA0EG/JxNxTCs1jefvTxfMKfgUIMVQD7wUuvE7dCG90zRGlyHO5+bPELWRbWnjdWR9H2wOaNx5Sl+zRJyZDh7R5KmQyyZneaPFgnXDiwzMZk2MLWRjOyabiTn9Du7VZM5MWyUl/bVAyZIcEFoCYoK/JzrkXZtW7CxblpxDgswXMlSLtZ9NX+BNwgNGi+vupJP6TPD+5QrMCJKcH1hk2fvlgs8rPRN2btg6bEYwWLyQUDLzNNiw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(40470700004)(46966006)(9786002)(8676002)(44832011)(5660300002)(54906003)(1076003)(40480700001)(4326008)(70586007)(107886003)(82310400005)(8936002)(70206006)(7416002)(40460700003)(36860700001)(2906002)(2616005)(6666004)(36756003)(7636003)(26005)(82740400003)(316002)(356005)(478600001)(186003)(426003)(83380400001)(7696005)(47076005)(336012)(41300700001)(110136005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 11:29:38.3885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b83d1c65-cd63-4675-b9d4-08da6a432197
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT027.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6725
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Versal TSU clock cannot be disabled irrespective of whether PTP is
used. Hence introduce a new Versal config structure with a "need tsu"
caps flag and check the same in runtime_suspend/resume before cutting
off clocks.

More information on this for future reference:
This is an IP limitation on versions 1p11 and 1p12 when Qbv is enabled
(See designcfg1, bit 3). However it is better to rely on an SoC specific
check rather than the IP version because tsu clk property itself may not
represent actual HW tsu clock on some chip designs.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 7ca077b65eaa..8bf67b44b466 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -725,6 +725,7 @@
 #define MACB_CAPS_MACB_IS_GEM			0x80000000
 #define MACB_CAPS_PCS				0x01000000
 #define MACB_CAPS_HIGH_SPEED			0x02000000
+#define MACB_CAPS_NEED_TSUCLK			0x00001000
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7eb7822cd184..8bbc46e8a9eb 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4735,6 +4735,16 @@ static const struct macb_config zynqmp_config = {
 	.usrio = &macb_default_usrio,
 };
 
+static const struct macb_config versal_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH | MACB_CAPS_NEED_TSUCLK,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = init_reset_optional,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
+};
+
 static const struct macb_config zynq_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_NO_GIGABIT_HALF |
 		MACB_CAPS_NEEDS_RSTONUBR,
@@ -4794,6 +4804,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
+	{ .compatible = "cdns,versal-gem", .data = &versal_config},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
@@ -5203,7 +5214,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 
 	if (!(device_may_wakeup(dev)))
 		macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
-	else
+	else if (!(bp->caps & MACB_CAPS_NEED_TSUCLK))
 		macb_clks_disable(NULL, NULL, NULL, NULL, bp->tsu_clk);
 
 	return 0;
@@ -5219,8 +5230,10 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 		clk_prepare_enable(bp->hclk);
 		clk_prepare_enable(bp->tx_clk);
 		clk_prepare_enable(bp->rx_clk);
+		clk_prepare_enable(bp->tsu_clk);
+	} else if (!(bp->caps & MACB_CAPS_NEED_TSUCLK)) {
+		clk_prepare_enable(bp->tsu_clk);
 	}
-	clk_prepare_enable(bp->tsu_clk);
 
 	return 0;
 }
-- 
2.17.1

