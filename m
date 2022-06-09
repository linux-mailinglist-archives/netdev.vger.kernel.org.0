Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D795448EF
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiFIKc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiFIKcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:32:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F120FC52;
        Thu,  9 Jun 2022 03:32:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiBKneirHNS7Au0lL84/qGxzrUECOybjpK9BMJucnIWnyDqtpqgK1Ma1OahsFqNzyuJ9Yd6VLkAj/OrKokliKW0+PZ6z6/drUOeU5Hx8ev1iZvDJpZi0XIij5DHMCPcuwpeqetZ2ml2H6IMheQ/1Xzk9bObH3yhJa/L5IIrB+GMB3thoT1tXuy/wYXUUPeiioNqdTscwxi2vrRpTqTWZp3v9HNCrr2GxuNCXY4aDZ6DfFKgQpDd+IpUQOwkzgZAmDDSzqDRjB7ptFfDQ7GKEhvFUP1EQirN46l8a1Y5DJoJQZA0+tbP0v5roLUar38xVghQWVfoKmdjn27T5acevQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gR1fyncuO0915wurrDFE2DNx7O3jC2oJp8MrtNjmWqM=;
 b=mWycnpaszNrCWRMBapzQYiJ7jx+OxIV5xd3/prDufRjS+iYnVzeCRmvNO1IM1ZmN+Uz//KptgAdCqpxZ3P99O3e3In/JJSWP9Rx9yeQZm8Zcd5+/mdO3lsRl46QaqBKgHxxk/4lZD1NAkX1iye6X48yMvyphPnwST+k95ODHqxqsHddqCKmmwcKMPnF1h0THzvpP8b+Ykx7ngUy8rILde5frtCOnN8BjkpKVmq+tSedf1sxr6ushNcdJDAg1vtnDs3mjd/xPIMXW172SS0mQ7wpPPo28OvXy7jY0eACJ71Uw/0YtwtXJ810+/eVGrEjh2iP0TQfFcvILO1fh32CZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gR1fyncuO0915wurrDFE2DNx7O3jC2oJp8MrtNjmWqM=;
 b=XJ8M3spXh7QAN4YtnmylfaqbRwqjHzYv97Czq7EhhSAaCO8JmBQnn29cghbHuVpiL3O+yT870LjScmx6dhdhhWnsNJ2as/jX633paX+rXACs8LLdM5mWqspdFf8QDGuYvaNs7CYbZgJx28p1q8qDgqthSNVh4L5RXyrbgfmFK5E=
Received: from DM5PR2001CA0022.namprd20.prod.outlook.com (2603:10b6:4:16::32)
 by BN6PR02MB2323.namprd02.prod.outlook.com (2603:10b6:404:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Thu, 9 Jun
 2022 10:32:21 +0000
Received: from DM3NAM02FT018.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::88) by DM5PR2001CA0022.outlook.office365.com
 (2603:10b6:4:16::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Thu, 9 Jun 2022 10:32:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT018.mail.protection.outlook.com (10.13.4.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Thu, 9 Jun 2022 10:32:20 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Jun 2022 03:32:18 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Jun 2022 03:32:18 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 srinivas.neeli@amd.com,
 neelisrinivas18@gmail.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 mailhol.vincent@wanadoo.fr
Received: from [10.140.6.39] (port=37944 helo=xhdsgoud40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nzFSP-000Ddu-Aw; Thu, 09 Jun 2022 03:32:05 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <srinivas.neeli@amd.com>,
        <neelisrinivas18@gmail.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH V4] can: xilinx_can: Add Transmitter delay compensation (TDC) feature support
Date:   Thu, 9 Jun 2022 16:01:57 +0530
Message-ID: <20220609103157.1425730-1-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c985ca03-56cc-4fd8-6eb8-08da4a0355c2
X-MS-TrafficTypeDiagnostic: BN6PR02MB2323:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB23236EF180F505C0B6491554AFA79@BN6PR02MB2323.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKs3fChbAIUffGe6OeMHI3omMtbB9t5GEJ+tGwi4pfmaQmS6yUz3DBBwmBU7uaiv7fX/l4kgP7j1dQqwRbtrpoDep1S2p8VjRUtGc1IBI78pxPYTFaqpA7HjMUcfO4OzxPzfSwf7Ky2c5GD6DdtxxC+Gx0pSjyGEHEMdhj4KrS0LYdWwSE/+u0T3qD2pCT2RbcUjB18gaIvH2jtCnvHTZeT1+rwHvT7bFARrG0I6dTWZ9ofUE6RdTg94Eu6VDTDmES9K/nNJcAS55oNZsgNizVXTtHtHiksWRVMdduCWf5DvcJbvtgBhpBwXnVjzlQalOLQFx1+XixXFhKxywdY/R5qBgiFnRtSE2y1i69rPIyTWB+/WJDt07mWDPXAze6c2ADX1Tj9UZjmq9gcWIQJGDpjtna4XoCuqczHNH46j5jTfwmUgwOVQOzxcRxqwM7LG/2dgyqaFme5GqHF86b4sxScYbCoHLpTUYeCKbSnQGzXNbhZmGvRKsKqlGu7E5rElBHLsPbXNPwdrEqcq40Qfe1nbeeVcDrHWW2p44RK0U5wvgIfnpFV05RLSL8U/ZM2LdFk1XWEkdBs0sd48tx6AsoX3r9OIkIC33p0pqScRVIXINL18RSg2UI5ktCiHUafVT8SpIL1dvpZruBCbzQHpDyMrpidviYqmPu7pliJ76CVA/+4gwrl5nEmDU+zqqDmtkG3uC3lG8j2sauEz7QZo9Q==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2616005)(1076003)(70586007)(70206006)(26005)(336012)(426003)(7636003)(47076005)(40460700003)(316002)(83380400001)(356005)(82310400005)(7416002)(6636002)(508600001)(44832011)(36860700001)(36756003)(54906003)(8936002)(5660300002)(186003)(9786002)(2906002)(8676002)(6666004)(4326008)(110136005)(7696005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 10:32:20.9572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c985ca03-56cc-4fd8-6eb8-08da4a0355c2
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT018.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2323
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added Transmitter delay compensation (TDC) feature support.
In the case of higher measured loop delay with higher baud rates,
observed bit stuff errors. By enabling the TDC feature in
CANFD controllers, will compensate for the measure loop delay in
the receive path.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Changes in V4:
-Reverted typo changes as mentioned in V3 series.
-Observed difference in bit field lengths for TDCO between
 CANFD 1.0 and CANFD 2.0, So updated code according to it.
Changes in V3:
-Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
-Implemented TDC feature for all Xilinx CANFD controllers.
-corrected prescalar to prescaler(typo).
Changes in V2:
-Created two patchs one for revert another for TDC support.
---
 drivers/net/can/xilinx_can.c | 68 +++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index e179d311aa28..865ecc83285b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* Xilinx CAN device driver
  *
- * Copyright (C) 2012 - 2014 Xilinx, Inc.
+ * Copyright (C) 2012 - 2022 Xilinx, Inc.
  * Copyright (C) 2009 PetaLogix. All rights reserved.
  * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
  *
@@ -9,6 +9,7 @@
  * This driver is developed for Axi CAN IP and for Zynq CANPS Controller.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -86,6 +87,8 @@ enum xcan_reg {
 #define XCAN_MSR_LBACK_MASK		0x00000002 /* Loop back mode select */
 #define XCAN_MSR_SLEEP_MASK		0x00000001 /* Sleep mode select */
 #define XCAN_BRPR_BRP_MASK		0x000000FF /* Baud rate prescaler */
+#define XCAN_BRPR_TDCO_MASK		GENMASK(12, 8)  /* TDCO */
+#define XCAN_2_BRPR_TDCO_MASK		GENMASK(13, 8)  /* TDCO for CANFD 2.0 */
 #define XCAN_BTR_SJW_MASK		0x00000180 /* Synchronous jump width */
 #define XCAN_BTR_TS2_MASK		0x00000070 /* Time segment 2 */
 #define XCAN_BTR_TS1_MASK		0x0000000F /* Time segment 1 */
@@ -99,6 +102,7 @@ enum xcan_reg {
 #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
 #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
 #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
+#define XCAN_SR_TDCV_MASK		GENMASK(22, 16) /* TDCV Value */
 #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
 #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
 #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
@@ -132,6 +136,7 @@ enum xcan_reg {
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
 /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
+#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation (TDC) Enable */
 #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
 #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
 #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
@@ -276,6 +281,26 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.brp_inc = 1,
 };
 
+/* Transmission Delay Compensation constants for CANFD 1.0 */
+static const struct can_tdc_const xcan_tdc_const_canfd = {
+	.tdcv_min = 0,
+	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_min = 0,
+	.tdco_max = 32,
+	.tdcf_min = 0, /* Filter window not supported */
+	.tdcf_max = 0,
+};
+
+/* Transmission Delay Compensation constants for CANFD 2.0 */
+static const struct can_tdc_const xcan_tdc_const_canfd2 = {
+	.tdcv_min = 0,
+	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_min = 0,
+	.tdco_max = 64,
+	.tdcf_min = 0, /* Filter window not supported */
+	.tdcf_max = 0,
+};
+
 /**
  * xcan_write_reg_le - Write a value to the device register little endian
  * @priv:	Driver private data structure
@@ -424,6 +449,16 @@ static int xcan_set_bittiming(struct net_device *ndev)
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
 		/* Setting Baud Rate prescalar value in F_BRPR Register */
 		btr0 = dbt->brp - 1;
+		if (can_tdc_is_enabled(&priv->can)) {
+			if (priv->devtype.cantype == XAXI_CANFD)
+				btr0 |=
+				FIELD_PREP(XCAN_BRPR_TDCO_MASK, priv->can.tdc.tdco) |
+				XCAN_BRPR_TDC_ENABLE;
+			else
+				btr0 |=
+				FIELD_PREP(XCAN_2_BRPR_TDCO_MASK, priv->can.tdc.tdco) |
+				XCAN_BRPR_TDC_ENABLE;
+		}
 
 		/* Setting Time Segment 1 in BTR Register */
 		btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
@@ -1483,6 +1518,22 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
 	return 0;
 }
 
+/**
+ * xcan_get_auto_tdcv - Get Transmitter Delay Compensation Value
+ * @ndev:	Pointer to net_device structure
+ * @tdcv:	Pointer to TDCV value
+ *
+ * Return: 0 on success
+ */
+static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv)
+{
+	struct xcan_priv *priv = netdev_priv(ndev);
+
+	*tdcv = FIELD_GET(XCAN_SR_TDCV_MASK, priv->read_reg(priv, XCAN_SR_OFFSET));
+
+	return 0;
+}
+
 static const struct net_device_ops xcan_netdev_ops = {
 	.ndo_open	= xcan_open,
 	.ndo_stop	= xcan_close,
@@ -1735,17 +1786,24 @@ static int xcan_probe(struct platform_device *pdev)
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_BERR_REPORTING;
 
-	if (devtype->cantype == XAXI_CANFD)
+	if (devtype->cantype == XAXI_CANFD) {
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd;
+		priv->can.tdc_const = &xcan_tdc_const_canfd;
+	}
 
-	if (devtype->cantype == XAXI_CANFD_2_0)
+	if (devtype->cantype == XAXI_CANFD_2_0) {
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd2;
+		priv->can.tdc_const = &xcan_tdc_const_canfd2;
+	}
 
 	if (devtype->cantype == XAXI_CANFD ||
-	    devtype->cantype == XAXI_CANFD_2_0)
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+	    devtype->cantype == XAXI_CANFD_2_0) {
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
+						CAN_CTRLMODE_TDC_AUTO;
+		priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
+	}
 
 	priv->reg_base = addr;
 	priv->tx_max = tx_max;
-- 
2.25.1

