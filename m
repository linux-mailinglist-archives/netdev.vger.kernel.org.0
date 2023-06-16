Return-Path: <netdev+bounces-11460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3397332A9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50240281793
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541FC1ACD1;
	Fri, 16 Jun 2023 13:54:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AED182A7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:09 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4964735A5;
	Fri, 16 Jun 2023 06:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gw6/9g7qYz06yCJOztPgYDJWkhOveRyyUTPHz/V5DjPPb08QuTZ4W4+4qnrmZfym9KZ6UnSR2mOShKymDYkSjz8WIx/aXRLZTy9X9gf9JuTcoEi21EX4hWTW1VmUXS6qSAfCz3GoUgqJnTQNRJanOykgIKcyRtjKhdDIt/ht+xw9P4YjTK1y+dZVHo/8P550gDgBbTGdbdIddwZMs29inrcPb5nOxvdhXqSlsQmUW4C74kxi80LY+yyXtLBpZeDhC1i+X7WahAGdM+eS0j8ExRRJ1wPilgpIhittyL5An4Vig8aBb9tP9gqeP+btPHl9P/1//t69HfvXMfx1yssyUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qYu2dR0rCTXiTul/iqmScUIDVHXhOPL5VsTK3ZNF8Q=;
 b=Aq62HI+1gc+xJEVPwNwBwtbF2VboU4+HGQhy1DE3P/gvOJ0u0GguuFSwH0kvKwlF7QfpUCC4sPrURY9Q/z5dgQrV6WuCldxkL+Csy7VGk8zkr773sAJ0JfYb2vdZMhhdBBownZB57goXgFSj5uINe1Yk+eGmApLvZ6QofOTJab7QSrTrTfN8omS1mjFjRZTouUTB4PZsvZD1cd2xfeY2L2nmUafjvyddjlS7OwrNfunjn/hCH068Q91UzOT8tjZDHuXFBev8ZhspQu+9yMdiEUaV6Kd04BV7ABuSREth9hR0NzXqOSSj/YxjTztd6/Lcd49p6xT+jM0kJ9VCGDBEwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qYu2dR0rCTXiTul/iqmScUIDVHXhOPL5VsTK3ZNF8Q=;
 b=fDTBtaSEXit2nIGszr/C4scjXM3nmL/lvbNdDKjTlYJyYbruH+RXjwG9tOkmdWsnHAL1AsVJQTc+S+6xiv5b/+w5lKoDUqYoPQXkTIM543ha8jX1DRWB5cTm82WOyAZghjhE1fTOitgce3Gzh1/q50VpTRHrsMrnICG2CWhUdEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:01 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:01 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 07/14] net: phy: nxp-c45-tja11xx: add TJA1120 support
Date: Fri, 16 Jun 2023 16:53:16 +0300
Message-Id: <20230616135323.98215-8-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: b3b8420a-60f6-4b72-7184-08db6e71237e
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aWg4izRrc7gOiQCL3s/WG/Cagj0s9Los9IDnxxBPrMjj8ZVfXilnP3LK4FTm9Pah3Eqd8W9TdaXdBZt5RL+3tut69OWHCblMikC1dKWl4TBiz6Ru31Xc7aniTnVQjciI9cbqZVmHt6/IC+veMTUvLxfuUXFCWbBwt9IOQOVwuhL5SxhL013T8yK3uTN9HijBtVXl7DjyUnPioaslrP3gYdqmLGijNRNFG63ggsHnzcmb8ygftot0cxIs1xpmGU+YpfNtPuiFtxwUhRZsBARpRACzXkoVKCK1bCFV4VnzGLx/5EKyS3YdEQ/SKm+qBqeWiH4g5E3i4KVqswNxEBDlvGnoNeRU1WIN5yUywUsbuivQUWHzpXUCZ2tGnGgLACmtJdGXWK48azTg22aQbId68+4zvMim3z1XcDzV+X2QFK3VBSBPGQmw07q98iXODjhOYnWWWNFyTs5HKIWnfoUCOI5DZCUJh9Y9K8LhCI8ZDOCTXsAh56ynP/oHe6Ry0bxCpbOYjEhAB9Afa9NkHcKwc1ReNowfLK0NfIXUHcqv3qomBstlbvlvuP0vQGfcRGKYxcrHBSV3Or5LsjXLE+bgX8hSJqlANeEUr0fm1P5tNXfWjop/9DT/FHWbFdWkIHfM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(66574015)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?53AgL5Uv9sd+KEqeuH5OLMVUvEvhyQrnxesuKbtuSSqpx+YPKsDmiIa7sXV5?=
 =?us-ascii?Q?M9iuibuvlrlOcEpiNopZ8t4WEEACICGiFmumYm3tfKd5SCHDR6quUkEdIyWO?=
 =?us-ascii?Q?OJO65pkgnZ7iK4xlQoAiR+qByabb44I9TC0X890IPGaloMCM8bMwHRfzEx0T?=
 =?us-ascii?Q?a9bpDhBsioLEX/gM299m1egTOobIth4Y1wbpO7B1rHwFBvwtkjdohqE5iXft?=
 =?us-ascii?Q?hcARbvZPvi83i/sA4tSIA4m7zSYIUipWX//r+FQPY9enRdj9PiR+AWyFOyV2?=
 =?us-ascii?Q?hnKftDp8qk50yfoXvH4IQ+Gx11B6k4XnrjfJ26mTtCc++ifQzR1PhZtkfKYz?=
 =?us-ascii?Q?pP52+9RPm4teRJ8QPc0hbMNufm3HumFjlcNyk58eIdG1QWNWhZvVAWbsx6FE?=
 =?us-ascii?Q?8NM9Mb2MAgqpm0Ip6jdnJ/ULTxxFPqS4e2+rZNZ1ps28AlNjJJCeeSnP0CUn?=
 =?us-ascii?Q?Glv03aZhD/NH1WcQf6UPHYW09QkA/NkOakpaudWPbCRqtgk05+v9y7DI3TYf?=
 =?us-ascii?Q?i8YL0MVzxtdzJEvSOa5zsk7Xh5CYeZMJbMwted1oT+SoTrcGId852jUC8kg2?=
 =?us-ascii?Q?BfF+aa59rWcGrxbH4qzF3DT0ZDH7RpHVFwzj/ln6laOZlRqgjOa+q/DzhYR2?=
 =?us-ascii?Q?TauGmodFkJFxfI9pfRIY6qQwGU//qBgXawKAEJdutaFQWoJlD+qWI6bv8txe?=
 =?us-ascii?Q?s2DRsEnDHVivMtSkpvR8xYqSXioVVGij0XnFF7j48lnz+pCLVkXvg4pP0jYo?=
 =?us-ascii?Q?lbrs+/lWLmxD94NtmzRoeG5rXI39XuzUmxB8/VnwVCbVU4HThQyQlrZTTsFw?=
 =?us-ascii?Q?//NwNeh/x0EDkpkaPaPdUKlu8vWohQh0JKmiDq+U89KEKVtStGzRyk9x677H?=
 =?us-ascii?Q?OeXBV0xClLJM8ppcigJlT9xYhS37VZjpqflkUwa9APlbpvl5GeEQZ+3uBVrD?=
 =?us-ascii?Q?H0IW+WEjYgQiE9KDVtyUgEkAFtEfeRS3mVQ/5K1unBsr3IxsB+mG27fPUjXo?=
 =?us-ascii?Q?VJRYwhJ1cr0FRcoPumUZB+e6fA+xfHIX+jDVx7+kvSF+kiobd7P43zSMNSLf?=
 =?us-ascii?Q?lcP2hb3BqyH0ylHsghE6GK1mnsUNGOVAUzZHiM7r66gcwWB5rzSORA57aITg?=
 =?us-ascii?Q?Vi727KGT87DYUfsAiJDFS0YrZjTUv2B3A3F9UqbUbceBSjtAL8y1pIPrKCvd?=
 =?us-ascii?Q?AGkTdMCdGc/15vghQlitUuPDj4JlFRAa69QQ+ShXi+b3GQ4C++Im4BPQGzOt?=
 =?us-ascii?Q?S9yRu6rD3LiM58TcEdl3JeF45zrH+MlXAKySWUk9zTW07ovEYllRi/xHYIVS?=
 =?us-ascii?Q?VA228otJgXtzuwDdYM2lQrBTHuj2/IuvyHxZpzZzArKLJpsD/HFFgvBP3DCq?=
 =?us-ascii?Q?2jrLKxzo4ADWErha5YgHiPnYIdCzwHoYhOP5qJX0wWDL+mVh5YPL/1UyYghs?=
 =?us-ascii?Q?VZLckukqtQo5rT5qk5TVJ6a1kn4Jb9kvuQj6iNUUUuFZ5ND162s2jY1jR9rR?=
 =?us-ascii?Q?emfcL+mueLE+X9/TlgU8UvfQopKWXkRLLHlXqAfnlD0VKogYNJ9futqsgawV?=
 =?us-ascii?Q?G8yUCVhA8gR/ULy6Cz7ha5LxgtiN/Pp2NOqCmFuijEZLjaulA5//H86O3P28?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b8420a-60f6-4b72-7184-08db6e71237e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:01.0607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyWqS8+5QN3OGyUaOfoWDQXgG6GNYtnZ1EYBezsGiveZgaU31LKv+mzfo1QOy9c/5esEFIJPb/j5wnM98mn221OVWg9jbRaFigt7dYdPmi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add TJA1120 driver entry and its driver_data.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/Kconfig           |   2 +-
 drivers/net/phy/nxp-c45-tja11xx.c | 160 +++++++++++++++++++++++++++++-
 2 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index a40269c17597..aaed6d73f9f5 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -300,7 +300,7 @@ config NXP_C45_TJA11XX_PHY
 	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Enable support for NXP C45 TJA11XX PHYs.
-	  Currently supports only the TJA1103 PHY.
+	  Currently supports the TJA1103 and TJA1120 PHYs.
 
 config NXP_TJA11XX_PHY
 	tristate "NXP TJA11xx PHYs support"
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 2bf778bd08e3..2160b9f8940c 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -18,12 +18,17 @@
 #include <linux/net_tstamp.h>
 
 #define PHY_ID_TJA_1103			0x001BB010
+#define PHY_ID_TJA_1120			0x001BB031
 
 #define VEND1_DEVICE_CONTROL		0x0040
 #define DEVICE_CONTROL_RESET		BIT(15)
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
 #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
 
+#define VEND1_DEVICE_CONFIG		0x0048
+
+#define TJA1120_VEND1_EXT_TS_MODE	0x1012
+
 #define VEND1_PHY_IRQ_ACK		0x80A0
 #define VEND1_PHY_IRQ_EN		0x80A1
 #define VEND1_PHY_IRQ_STATUS		0x80A2
@@ -79,6 +84,14 @@
 #define MII_BASIC_CONFIG_RMII		0x5
 #define MII_BASIC_CONFIG_MII		0x4
 
+#define VEND1_SYMBOL_ERROR_CNT_XTD	0x8351
+#define EXTENDED_CNT_EN			BIT(15)
+#define VEND1_MONITOR_STATUS		0xAC80
+#define MONITOR_RESET			BIT(15)
+#define VEND1_MONITOR_CONFIG		0xAC86
+#define LOST_FRAMES_CNT_EN		BIT(9)
+#define ALL_FRAMES_CNT_EN		BIT(8)
+
 #define VEND1_SYMBOL_ERROR_COUNTER	0x8350
 #define VEND1_LINK_DROP_COUNTER		0x8352
 #define VEND1_LINK_LOSSES_AND_FAILURES	0x8353
@@ -97,11 +110,14 @@
 #define VEND1_RX_TS_INSRT_CTRL		0x114D
 #define TJA1103_RX_TS_INSRT_MODE2	0x02
 
+#define TJA1120_RX_TS_INSRT_CTRL	0x9012
+#define TJA1120_RX_TS_INSRT_EN		BIT(15)
+#define TJA1120_TS_INSRT_MODE		BIT(4)
+
 #define VEND1_EGR_RING_DATA_0		0x114E
 #define VEND1_EGR_RING_CTRL		0x1154
 
 #define RING_DATA_0_TS_VALID		BIT(15)
-
 #define RING_DONE			BIT(0)
 
 #define TS_SEC_MASK			GENMASK(1, 0)
@@ -113,6 +129,7 @@
 #define PORT_PTP_CONTROL_BYPASS		BIT(11)
 
 #define PTP_CLK_PERIOD_100BT1		15ULL
+#define PTP_CLK_PERIOD_1000BT1		8ULL
 
 #define EVENT_MSG_FILT_ALL		0x0F
 #define EVENT_MSG_FILT_NONE		0x00
@@ -930,6 +947,27 @@ static const struct nxp_c45_phy_stats tja1103_hw_stats[] = {
 		NXP_C45_REG_FIELD(0xAFD1, MDIO_MMD_VEND1, 0, 9), },
 };
 
+static const struct nxp_c45_phy_stats tja1120_hw_stats[] = {
+	{ "phy_symbol_error_cnt_ext",
+		NXP_C45_REG_FIELD(0x8351, MDIO_MMD_VEND1, 0, 14) },
+	{ "tx_frames",
+		NXP_C45_REG_FIELD(0xACA0, MDIO_MMD_VEND1, 0, 16), },
+	{ "tx_frames_xtd",
+		NXP_C45_REG_FIELD(0xACA1, MDIO_MMD_VEND1, 0, 8), },
+	{ "rx_frames",
+		NXP_C45_REG_FIELD(0xACA2, MDIO_MMD_VEND1, 0, 16), },
+	{ "rx_frames_xtd",
+		NXP_C45_REG_FIELD(0xACA3, MDIO_MMD_VEND1, 0, 8), },
+	{ "tx_lost_frames",
+		NXP_C45_REG_FIELD(0xACA4, MDIO_MMD_VEND1, 0, 16), },
+	{ "tx_lost_frames_xtd",
+		NXP_C45_REG_FIELD(0xACA5, MDIO_MMD_VEND1, 0, 8), },
+	{ "rx_lost_frames",
+		NXP_C45_REG_FIELD(0xACA6, MDIO_MMD_VEND1, 0, 16), },
+	{ "rx_lost_frames_xtd",
+		NXP_C45_REG_FIELD(0xACA7, MDIO_MMD_VEND1, 0, 8), },
+};
+
 static int nxp_c45_get_sset_count(struct phy_device *phydev)
 {
 	const struct nxp_c45_phy_data *phy_data = nxp_c45_get_data(phydev);
@@ -1518,6 +1556,101 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
 	.ptp_enable = tja1103_ptp_enable,
 };
 
+static void tja1120_counters_enable(struct phy_device *phydev)
+{
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_SYMBOL_ERROR_CNT_XTD,
+			 EXTENDED_CNT_EN);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_MONITOR_STATUS,
+			 MONITOR_RESET);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_MONITOR_CONFIG,
+			 ALL_FRAMES_CNT_EN | LOST_FRAMES_CNT_EN);
+}
+
+static void tja1120_ptp_init(struct phy_device *phydev)
+{
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, TJA1120_RX_TS_INSRT_CTRL,
+		      TJA1120_RX_TS_INSRT_EN | TJA1120_TS_INSRT_MODE);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, TJA1120_VEND1_EXT_TS_MODE,
+		      TJA1120_TS_INSRT_MODE);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONFIG,
+			 PTP_ENABLE);
+}
+
+static void tja1120_ptp_enable(struct phy_device *phydev, bool enable)
+{
+	if (enable)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 VEND1_PORT_FUNC_ENABLES,
+				 PTP_ENABLE);
+	else
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PORT_FUNC_ENABLES,
+				   PTP_ENABLE);
+}
+
+static const struct nxp_c45_regmap tja1120_regmap = {
+	.vend1_ptp_clk_period	= 0x1020,
+	.vend1_event_msg_filt	= 0x9010,
+	.pps_enable		=
+		NXP_C45_REG_FIELD(0x1006, MDIO_MMD_VEND1, 4, 1),
+	.pps_polarity		=
+		NXP_C45_REG_FIELD(0x1006, MDIO_MMD_VEND1, 5, 1),
+	.ltc_lock_ctrl		=
+		NXP_C45_REG_FIELD(0x1006, MDIO_MMD_VEND1, 2, 1),
+	.ltc_read		=
+		NXP_C45_REG_FIELD(0x1000, MDIO_MMD_VEND1, 1, 1),
+	.ltc_write		=
+		NXP_C45_REG_FIELD(0x1000, MDIO_MMD_VEND1, 2, 1),
+	.vend1_ltc_wr_nsec_0	= 0x1040,
+	.vend1_ltc_wr_nsec_1	= 0x1041,
+	.vend1_ltc_wr_sec_0	= 0x1042,
+	.vend1_ltc_wr_sec_1	= 0x1043,
+	.vend1_ltc_rd_nsec_0	= 0x1048,
+	.vend1_ltc_rd_nsec_1	= 0x1049,
+	.vend1_ltc_rd_sec_0	= 0x104A,
+	.vend1_ltc_rd_sec_1	= 0x104B,
+	.vend1_rate_adj_subns_0	= 0x1030,
+	.vend1_rate_adj_subns_1	= 0x1031,
+	.irq_egr_ts_en		=
+		NXP_C45_REG_FIELD(0x900A, MDIO_MMD_VEND1, 1, 1),
+	.irq_egr_ts_status	=
+		NXP_C45_REG_FIELD(0x900C, MDIO_MMD_VEND1, 1, 1),
+	.domain_number		=
+		NXP_C45_REG_FIELD(0x9061, MDIO_MMD_VEND1, 8, 8),
+	.msg_type		=
+		NXP_C45_REG_FIELD(0x9061, MDIO_MMD_VEND1, 4, 4),
+	.sequence_id		=
+		NXP_C45_REG_FIELD(0x9062, MDIO_MMD_VEND1, 0, 16),
+	.sec_1_0		=
+		NXP_C45_REG_FIELD(0x9065, MDIO_MMD_VEND1, 0, 2),
+	.sec_4_2		=
+		NXP_C45_REG_FIELD(0x9065, MDIO_MMD_VEND1, 2, 3),
+	.nsec_15_0		=
+		NXP_C45_REG_FIELD(0x9063, MDIO_MMD_VEND1, 0, 16),
+	.nsec_29_16		=
+		NXP_C45_REG_FIELD(0x9064, MDIO_MMD_VEND1, 0, 14),
+	.vend1_ext_trg_data_0	= 0x1071,
+	.vend1_ext_trg_data_1	= 0x1072,
+	.vend1_ext_trg_data_2	= 0x1073,
+	.vend1_ext_trg_data_3	= 0x1074,
+	.vend1_ext_trg_ctrl	= 0x1075,
+	.cable_test		= 0x8360,
+	.cable_test_valid	=
+		NXP_C45_REG_FIELD(0x8361, MDIO_MMD_VEND1, 15, 1),
+	.cable_test_result	=
+		NXP_C45_REG_FIELD(0x8361, MDIO_MMD_VEND1, 0, 3),
+};
+
+static const struct nxp_c45_phy_data tja1120_phy_data = {
+	.regmap = &tja1120_regmap,
+	.stats = tja1120_hw_stats,
+	.n_stats = ARRAY_SIZE(tja1120_hw_stats),
+	.ptp_clk_period = PTP_CLK_PERIOD_1000BT1,
+	.counters_enable = tja1120_counters_enable,
+	.ptp_init = tja1120_ptp_init,
+	.ptp_enable = tja1120_ptp_enable,
+};
+
 static struct phy_driver nxp_c45_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
@@ -1543,12 +1676,37 @@ static struct phy_driver nxp_c45_driver[] = {
 		.get_sqi_max		= nxp_c45_get_sqi_max,
 		.remove			= nxp_c45_remove,
 	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1120),
+		.name			= "NXP C45 TJA1120",
+		.features		= PHY_BASIC_T1_FEATURES,
+		.driver_data		= &tja1120_phy_data,
+		.probe			= nxp_c45_probe,
+		.soft_reset		= nxp_c45_soft_reset,
+		.config_aneg		= genphy_c45_config_aneg,
+		.config_init		= nxp_c45_config_init,
+		.config_intr		= nxp_c45_config_intr,
+		.handle_interrupt	= nxp_c45_handle_interrupt,
+		.read_status		= genphy_c45_read_status,
+		.suspend		= genphy_c45_pma_suspend,
+		.resume			= genphy_c45_pma_resume,
+		.get_sset_count		= nxp_c45_get_sset_count,
+		.get_strings		= nxp_c45_get_strings,
+		.get_stats		= nxp_c45_get_stats,
+		.cable_test_start	= nxp_c45_cable_test_start,
+		.cable_test_get_status	= nxp_c45_cable_test_get_status,
+		.set_loopback		= genphy_c45_loopback,
+		.get_sqi		= nxp_c45_get_sqi,
+		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
+	},
 };
 
 module_phy_driver(nxp_c45_driver);
 
 static struct mdio_device_id __maybe_unused nxp_c45_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA_1120) },
 	{ /*sentinel*/ },
 };
 
-- 
2.34.1


