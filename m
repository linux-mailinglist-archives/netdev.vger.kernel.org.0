Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64628524F15
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354866AbiELN7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354659AbiELN7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:59:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C41ED5AC;
        Thu, 12 May 2022 06:59:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jlnz7NFdZy2lHsRt2Vmr/bztH+58N2skj1mzpqAHbvx4kGFdy/5em+k8wpfwI11W7EbJ1mNyPwU+Fo5+AFKOxX/dTlw7U3xiQkcwJ3loVG37/XL73xKMBTgIjeoP2J4ZOCmVvk8fxVFSAKAG9Iq5aOg/G7aS+d5jeK9HnnIzlxXO5YRuBm8gZeEndO5j92PNRZfdiwYqE1UfPhPJwL8XmHZlmuaRTfau6wDo3cufke7J1WWQH7/bfpytK0n0H2e0kK8dmwJQ+sJABXLRtYT13ASnx8kb4gVUF5ynCiMb/oEOUrzYQAjXeQmZ7UWvqLS6/ahox/aEsIb323PicNiU0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FgqguSY/mxh23UYLPvFkaPEAtyfteDGvHGcGhiT00w=;
 b=Bf7jwJ/K6kv+b5CtmSxYdVjCqFbVLR0+sg1E8yse6xInf13UnuYTFo/nDe5Fe/Np65wq939X22/ixokd6j9cDEU3oQ+pc6/Qp3waaaZZh0DknG4F7vyNYFQGVUx8/GhGBvwhYNf0Psv9/hh3FrwLfLnVGIn1/yxMWQmhvFu1j4J8fWMKovZkhfz9GI7CFFlN+UzJaS0d9c7ewarlaxKMXgK8qEFD/FgNeWqJT99YbRiz5iYpBCjuQ/kl5OPX62U38lv+UXMb9MVL7brSzV12U6ANAWk3ov54Q2+oFrsvzeQmA6y90LAYMWQ/1SqMnpIVifCSUhEGoM1/RwoYQ2JICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FgqguSY/mxh23UYLPvFkaPEAtyfteDGvHGcGhiT00w=;
 b=WcPlo1Tpx9yvmpLXQvFPn+RDTXo/blPHpLXtfo4zzDJ4naVjWhYPuUDzHq4a+hYPJnYhnq6BGqYqVkNneqjOjrBngsqINEtYu/nC6JZmUcpxAwnUJ+7ULSLqgHCCPsiyy/PiS70GEEttTU9F3byz3Q/Cm/kQ+VXBpI6jl0HKp/4=
Received: from DM6PR21CA0012.namprd21.prod.outlook.com (2603:10b6:5:174::22)
 by BN6PR02MB2738.namprd02.prod.outlook.com (2603:10b6:404:fc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 13:59:30 +0000
Received: from DM3NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::3b) by DM6PR21CA0012.outlook.office365.com
 (2603:10b6:5:174::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6 via Frontend
 Transport; Thu, 12 May 2022 13:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT010.mail.protection.outlook.com (10.13.5.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 13:59:30 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 12 May 2022 06:59:21 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 12 May 2022 06:59:20 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.39] (port=41180 helo=xhdsgoud40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1np9Lc-000BAQ-Az; Thu, 12 May 2022 06:59:20 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH] can: xilinx_can: Add Transmitter delay compensation (TDC) feature support
Date:   Thu, 12 May 2022 19:29:01 +0530
Message-ID: <20220512135901.1377087-1-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d60e14ac-7576-41bb-3c99-08da341fa2a5
X-MS-TrafficTypeDiagnostic: BN6PR02MB2738:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB2738FC07E17F0655148F944EAFCB9@BN6PR02MB2738.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ob/TGesKIcimf9m0MgbgABIgPYDQseGLfbWdV9cGD+e0RZdx4zxk2MYc/SoEn8NTmkMjYsHJvg5fmRBDwJvItCx/ALEZGmDIcwu/UXL9jWnlUTOhKUqnGaN43D7SjBQxAyIam5/IkCJFiuEk+uYzdaodUOUndpaN8/M2CA9YThBQkg2Q2MVX5OYZZittvdp5RZQW5+qNLwyVjZFgcZaTjRhP8UyNZd3zSp6XIAQxsszcNMpYp+b7lZW5W5lL6QDAYcNQIUP2+xbv/EX5Cbn47d0at/llQL/70Z8g34GR8nNTbS8G22yohH2z2rPgkKy2Oltnav5EC8KMKeJISSfZQL23aIDgZTUn7MjcVyMo/68Vn6Fo3Stk0FArO+zJ5U32zzTINK7sqwFYxOlCiOdpXw7aismMtVEhfxC445T6zUUHnlW7NqgLD0/g4uSnge66s4hLaACeAQk7mUI5d1dg6WkduwBNNLQZh6Y0vK3tGaowPCMuujFkfre7eBjaJkLwJwTEKd6z1uKm2OhLoHfj4muWv78jcDwt2f8ti7HQ98DIfmdHhgQAKKBU8ELcp4wH5CHcV+5UhfowjySrq5xzhLb1GS9xkw5iEmUGbbENpQM3T3yKtCNMoGpwYZrkCKPHxf5I9OOt1MTcx1tcSAkLCWWWqnI889Yo82f17/XwWfR8jYdYTW/hJ70oR5IDnrQM8o2lllYWd825G4NxAlK3LQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(1076003)(6636002)(5660300002)(508600001)(316002)(8936002)(7416002)(9786002)(54906003)(426003)(107886003)(47076005)(336012)(110136005)(7636003)(186003)(36756003)(70206006)(70586007)(82310400005)(40460700003)(26005)(36860700001)(2616005)(4326008)(8676002)(6666004)(2906002)(83380400001)(356005)(44832011)(7696005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 13:59:30.2777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d60e14ac-7576-41bb-3c99-08da341fa2a5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT010.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2738
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added Transmitter delay compensation (TDC) feature support.
In the case of higher measured loop delay with higher baud rates, observed
bit stuff errors.
By enabling the TDC feature in a controller, will compensate for
the measure loop delay in the receive path.
TDC feature requires BRP values can be 1 or 2.
The current CAN framework does not limit the brp so while using TDC,
have to restrict BRP values.
Ex:
ip link set can0 type can tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20
sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd on
loopback on tdco 12 tdc-mode auto

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index e2b15d29d15e..7af518fbed02 100644
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
@@ -133,6 +133,8 @@ enum xcan_reg {
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
 /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
+#define XCAN_BRPR_TDCO_SHIFT_CANFD	8  /* Transmitter Delay Compensation Offset */
+#define XCAN_BRPR_TDCE_SHIFT_CANFD	16 /* Transmitter Delay Compensation (TDC) Enable */
 #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
 #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
 #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
@@ -259,7 +261,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -272,11 +274,21 @@ static struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
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
@@ -425,6 +437,11 @@ static int xcan_set_bittiming(struct net_device *ndev)
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
 		/* Setting Baud Rate prescalar value in F_BRPR Register */
 		btr0 = dbt->brp - 1;
+		if (can_tdc_is_enabled(&priv->can)) {
+			btr0 = btr0 |
+			(priv->can.tdc.tdco) << XCAN_BRPR_TDCO_SHIFT_CANFD |
+			1 << XCAN_BRPR_TDCE_SHIFT_CANFD;
+		}
 
 		/* Setting Time Segment 1 in BTR Register */
 		btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
@@ -1747,13 +1764,16 @@ static int xcan_probe(struct platform_device *pdev)
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd;
 
-	if (devtype->cantype == XAXI_CANFD_2_0)
+	if (devtype->cantype == XAXI_CANFD_2_0) {
 		priv->can.data_bittiming_const =
 			&xcan_data_bittiming_const_canfd2;
+		priv->can.tdc_const = &xcan_tdc_const;
+	}
 
 	if (devtype->cantype == XAXI_CANFD ||
 	    devtype->cantype == XAXI_CANFD_2_0)
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
+						CAN_CTRLMODE_TDC_AUTO;
 
 	priv->reg_base = addr;
 	priv->tx_max = tx_max;
-- 
2.25.1

