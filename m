Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB154459A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiFIIZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiFIIZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:25:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3594934B93;
        Thu,  9 Jun 2022 01:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5mJmMcdkiRDGPhYJ4ikd5nNXflkpnRCXxnd7YktzSk9WbGufFCAoSqphUPwZniA09HKTNVShU37rdD0Iv3XeXHHcEi/8OE8X6EBnezrfoasySkjPLZOazR0NjUVk8R2wEAVl7PYLa471aH28szTqNmyy1IWJFTRs7Weflsjc7YFNZH8BcDQUTo1D4pdwYOV63+WOJiLxV3lI1LOOuf4i1j0aGBdZNK0bkU1EPMHX/2lm6PPEwV6iuHSJQ3x3jwG6voE1Et6uZH29gy4YAPMVLs4jxMEWO+WYX3tJFGtBNu41Z73ybdUCRIzg5Mt6aUQ+B3K+i+qFbKdI/P4lzk+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqeNgwDZ5YJK0RRs9CzSmlMXfA0nThnVdu1LM31LnLc=;
 b=ZQdjt/BctQrEM7HaFT/e1EPSx4dHhJRcCdNQVokKh8FwPk84Yc8r1Jxgmh+qPm33CgeoYOYhqeXgLIpsCejZnAA2pTO/Rqsz2JwMx5B1URokiEYRQ+1d9HvLQyhmSVzSMjCu61wjrIqRQkHDixv+OXRBd1C9wcLI0wdoNApnmfGFm/w3Dn3GxntLJ9Lp2l3Pnk+lb5agfuvtrpcbRxyO8c1cyXrXEg5fMOsoJcpG4U2cr7bLIxzI/a00FvIJ+Z/kaxA9Dntp9UFfTVikemn1SXpE9WubylvBm6OyrkB6dxC+8/EAn7BgO36HTSV6eXKrRbbqnlP55JrrlyAgKYHPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqeNgwDZ5YJK0RRs9CzSmlMXfA0nThnVdu1LM31LnLc=;
 b=TP9yOQ1nPEMAOQCX1hLVTnawpBsjod8V08jVWq5xMCdDVKXQs80kCJ/0i3OwEed4NxCM8AIjG/lC1pZiFyr9RQzX+tzUiRsCP+GPYFKJVJtMlGVU7T2DRawtnF0vNNc2lpd0HhWDc4svEhQJCFSx8/tEy10n+s1fyQUqVGXcU7o=
Received: from DM5PR10CA0004.namprd10.prod.outlook.com (2603:10b6:4:2::14) by
 BL0PR02MB3683.namprd02.prod.outlook.com (2603:10b6:207:48::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.12; Thu, 9 Jun 2022 08:25:28 +0000
Received: from DM3NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::88) by DM5PR10CA0004.outlook.office365.com
 (2603:10b6:4:2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Thu, 9 Jun 2022 08:25:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT052.mail.protection.outlook.com (10.13.5.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Thu, 9 Jun 2022 08:25:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Jun 2022 01:25:07 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Jun 2022 01:25:07 -0700
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
 linux-kernel@vger.kernel.org
Received: from [10.140.6.39] (port=37838 helo=xhdsgoud40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nzDTS-0008BE-Sb; Thu, 09 Jun 2022 01:25:03 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <srinivas.neeli@amd.com>,
        <neelisrinivas18@gmail.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V3 2/2] can: xilinx_can: Add Transmitter delay compensation (TDC) feature support
Date:   Thu, 9 Jun 2022 13:54:33 +0530
Message-ID: <20220609082433.1191060-3-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
References: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db85e4a7-157f-4909-cea7-08da49f19bdd
X-MS-TrafficTypeDiagnostic: BL0PR02MB3683:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB3683BA4AB66BF5A5604F3E4EAFA79@BL0PR02MB3683.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48z1uq6WfDX6t5dpIOZpwO7FK8597J7fmTCH/zeqPvIpRIdTX6pEXfSO+bN9mmGzDZ/bTVdZbZeAUFjp6/LLlpTSDiPgwaRuV0ZkCpk7NL1uJExW0Z4yDqlpMA95ld13+H4wnE4sQVYIdkRZ9Zu1Lm5Z+fW7g9N70s0BvqXeLLjbf6fbIHZhkV9xOhD5HpJJa0KWE7JFReAxIXm5UGujOBq0O/Nm2bZ67ehY6oCRy4PZVxbBBDjMRROZjCLAB0ZvVez/tfF/Tr7H1K3dmvK//fQwwuMir76NPMV6c8OA6fwBURPzVWznxhJlYewmHnJCX6JDq3i9D1SZnncXXRF3ywmKZWEr0J4+NEAytr7TjqKcePhG4BF3VzNFE3P5Y+5nnJD59oa5EpA1iPS+adnjjC/L7Qmd0gtIrBLqNBtCia3QXUsb6AkyUfH61ie+8NR+LrARY9U81zEz1aSlvglBGWDsy1D8k1Nu5iloCzqGiRZlDXoqp1BWmsVf4djegS98fQYOG8d/iMaf6snYvqokH0p9qe+zrbIQw2ylVfQ0Hy3jdQr1Fb1FFA9NEsweHthwVf+0xmP8l67qWHxa1uleY35p9QDVAMgL1We7CF9QrEnpeUiOr6eU+AWvY6gCihug6W0wQ/sA6rWIAQcNGx6nDtf4pQlrp0cLDRuqGKQgni5SbULHh0XzCCZwdDdad1ssb2Erda71V4SyyHypuJOYDQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400005)(7636003)(110136005)(316002)(8676002)(4326008)(40460700003)(70206006)(70586007)(54906003)(6636002)(44832011)(36756003)(1076003)(186003)(2616005)(107886003)(356005)(83380400001)(7416002)(47076005)(426003)(336012)(7696005)(6666004)(2906002)(26005)(508600001)(36860700001)(9786002)(8936002)(5660300002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 08:25:27.6359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db85e4a7-157f-4909-cea7-08da49f19bdd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT052.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3683
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
---
Changes in V3:
-Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
-Implemented TDC feature for all Xilinx CANFD controllers.
-corrected prescalar to prescaler(typo).
Changes in V2:
-Created two patchs one for revert another for TDC support.
---
 drivers/net/can/xilinx_can.c | 48 ++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index e179d311aa28..288be69c0aed 100644
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
@@ -99,6 +100,7 @@ enum xcan_reg {
 #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
 #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
 #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
+#define XCAN_SR_TDCV_MASK		GENMASK(22, 16) /* TDCV Value */
 #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
 #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
 #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
@@ -132,6 +134,8 @@ enum xcan_reg {
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
 /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
+#define XCAN_BRPR_TDCO_SHIFT		GENMASK(13, 8)  /* Transmitter Delay Compensation Offset */
+#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation (TDC) Enable */
 #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
 #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
 #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
@@ -276,6 +280,16 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.brp_inc = 1,
 };
 
+/* Transmission Delay Compensation constants for CANFD2.0 and Versal  */
+static const struct can_tdc_const xcan_tdc_const = {
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
@@ -405,7 +419,7 @@ static int xcan_set_bittiming(struct net_device *ndev)
 		return -EPERM;
 	}
 
-	/* Setting Baud Rate prescalar value in BRPR Register */
+	/* Setting Baud Rate prescaler value in BRPR Register */
 	btr0 = (bt->brp - 1);
 
 	/* Setting Time Segment 1 in BTR Register */
@@ -422,8 +436,12 @@ static int xcan_set_bittiming(struct net_device *ndev)
 
 	if (priv->devtype.cantype == XAXI_CANFD ||
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
-		/* Setting Baud Rate prescalar value in F_BRPR Register */
+		/* Setting Baud Rate prescaler value in F_BRPR Register */
 		btr0 = dbt->brp - 1;
+		if (can_tdc_is_enabled(&priv->can))
+			btr0 |=
+			FIELD_PREP(XCAN_BRPR_TDCO_SHIFT, priv->can.tdc.tdco) |
+			XCAN_BRPR_TDC_ENABLE;
 
 		/* Setting Time Segment 1 in BTR Register */
 		btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
@@ -1483,6 +1501,22 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
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
@@ -1744,8 +1778,12 @@ static int xcan_probe(struct platform_device *pdev)
 			&xcan_data_bittiming_const_canfd2;
 
 	if (devtype->cantype == XAXI_CANFD ||
-	    devtype->cantype == XAXI_CANFD_2_0)
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+	    devtype->cantype == XAXI_CANFD_2_0) {
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
+						CAN_CTRLMODE_TDC_AUTO;
+		priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
+		priv->can.tdc_const = &xcan_tdc_const;
+	}
 
 	priv->reg_base = addr;
 	priv->tx_max = tx_max;
-- 
2.25.1

