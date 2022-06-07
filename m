Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC6853F8E9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbiFGI5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbiFGI5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:57:36 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B55F43;
        Tue,  7 Jun 2022 01:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z670w8+Q5Qte9yeybPIp/ZzQmE6lMXdm508v8EK/S+F8B57PZFR8CONONpkmXCBDWlzDliR4xXxLyjySHP6KIyiGWJ4LXK9y8C37yPzk8JfrdeIAtdsJI7QAqlEW7WKV8S4uIUhuw3e9JvWb4xuzkAgGv9o6h0s2fbg97KIN///sjAeV8sWZ3U55ihIY3EBNkCfXc0bMbVvbTizDT3cBb/DKJrdKhMnC3oNeGu+F8KMxhgw+d7/Ep/jQqvuHziW/xMYdpsY1E6Iox66Mh/c+Z3O1sRVSWlXQBQvr0jDYbrzOd17QU4PjNmoP4hP50ZvjjVyedGAb4UztbynpUzNe9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwrZU2H7piI9HzV2d2mJ+CrAfvbtwbJC76nDk60BwsQ=;
 b=KfCLifhTZciaWGzlPv7ORs/bx9WITy45+o4Q8o54xqzkAZJgBiq/tDXpVRt6wR/Y0NZwyjx1bejpl3SBAOuIl8XeIVCUUrvifo0tNmsBDgfQ+euXkqnbkVw4DsBBsR82CZBcG/qj8a0Bw/TDJnbcv5XwSv5+JjMAxt3iZWye1yt5iUpNe9mu4AL9AUvcIkVpvnNxJFSCV2v6oBdJ+T/lYZPznPOEEk1tdAtGAu6nYG0pF8DlFaCZzrY+uyhfwcm0B4dxcU1InVYRWNO4J8s1HHRuEGfTR9Smt00030zcWuBgvvWxqBQTXO5NmYtFeLkqo0KPEja6uPHuSyyjNdxSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwrZU2H7piI9HzV2d2mJ+CrAfvbtwbJC76nDk60BwsQ=;
 b=OGi1ATBO3XfCeaViNmoMAp+lXhMQfW3/JPyW44h1yl8iLJrnqV3HY/076oFHNLsMYGDM760DNZWycZ6xrZyiSCjkIhTusRc6usNFJs5Q59hotdeXHQikFsPDGt7mTqKKRHL/dqzTHe0aJs1w+EOI8pHSctXjLP3wSAl4gIp7WsQ=
Received: from SA9P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::34)
 by BN8PR02MB5828.namprd02.prod.outlook.com (2603:10b6:408:b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Tue, 7 Jun
 2022 08:57:22 +0000
Received: from SN1NAM02FT0014.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:26:cafe::29) by SA9P223CA0029.outlook.office365.com
 (2603:10b6:806:26::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Tue, 7 Jun 2022 08:57:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0014.mail.protection.outlook.com (10.97.4.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Tue, 7 Jun 2022 08:57:22 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Jun 2022 01:57:08 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 7 Jun 2022 01:57:08 -0700
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
Received: from [10.140.6.18] (port=44264 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nyV1P-0007h1-So; Tue, 07 Jun 2022 01:57:08 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V2 2/2] can: xilinx_can: Add Transmitter delay compensation (TDC) feature support
Date:   Tue, 7 Jun 2022 14:26:54 +0530
Message-ID: <20220607085654.4178-3-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
References: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31660921-76f3-4e0d-058c-08da4863bc38
X-MS-TrafficTypeDiagnostic: BN8PR02MB5828:EE_
X-Microsoft-Antispam-PRVS: <BN8PR02MB58281918C6F5A1F1945E63C8AFA59@BN8PR02MB5828.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNPcU+kia27G3FAVIkGhmBs/sW946qau6CzNOoyxSUMG8yiG6qVSsVwuQhyA+8mOUoGwRCcE2Us5MAkp+TY8FqsMc1ivZnlswtxlsy786j65IWsBVklFFtPzLpgRuma2YLubQZHv8ZHBXCZZTdGdF+5CN3eRpJ2AwGmo++FSdRKEjhXMT4JgS3CciOJjJEFeGB7wGxxL7XNsMToOfQwXRgfL9CwYX3scu1fGF4MkTpIxuNnn2T62DjfVumaBILPHOlcvS+nShRp526Ff8hAikOY/yQ+3Y4MclfFqXyUMOKw1ndwPSyqJvpxblVFuj5ugZr86RLNIZDO/K9SP92VSeeulk9F2bpwrbhUVnK7Q5juKKhAGcoEMjqs7wKUFWXZ1bPcGrsJEgCjySmpo1VV6MHBF+S1aM8NEi7YJ0L360L1DMlyY1BHfh+1Wzjb6kCXRjIh6VuSyZHTECbKnhz9wk2nz1J9y55HA+DHjkvJ3WMuBeFiYS1H7dompC3yWe6xBZjVeJBK2SdxktwXY1a3Nv7rE1uNho9CyYHPi7xfHABlGYaj+OzJSg6/wGqDQQRtH8XOus4UgzUR7LkLMwOGtiFHQ4aoG9brfb5C+QpaFBZATAXcpAYX/Q8DnOnbMKZCOt3cMBFhU/5eQXSFRh22paClxpvPlJph1LDkbHymvNCNORysCDX0L4DG7KAmd/ZVosa9QWMf2K5dqMZQo9wKFbQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(82310400005)(83380400001)(7636003)(70586007)(7696005)(4326008)(44832011)(1076003)(508600001)(186003)(2616005)(40460700003)(6666004)(8676002)(2906002)(110136005)(6636002)(426003)(47076005)(107886003)(36756003)(336012)(9786002)(7416002)(54906003)(70206006)(8936002)(26005)(356005)(316002)(5660300002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 08:57:22.2315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31660921-76f3-4e0d-058c-08da4863bc38
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0014.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR02MB5828
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
observed bit stuff errors. By enabling the TDC feature in a controller,
will compensate for the measure loop delay in the receive path.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 46 +++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index e179d311aa28..d0edd1bca33c 100644
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
@@ -99,6 +99,7 @@ enum xcan_reg {
 #define XCAN_ESR_STER_MASK		0x00000004 /* Stuff error */
 #define XCAN_ESR_FMER_MASK		0x00000002 /* Form error */
 #define XCAN_ESR_CRCER_MASK		0x00000001 /* CRC error */
+#define XCAN_SR_TDCV_MASK		0x007F0000 /* TDCV Value */
 #define XCAN_SR_TXFLL_MASK		0x00000400 /* TX FIFO is full */
 #define XCAN_SR_ESTAT_MASK		0x00000180 /* Error status */
 #define XCAN_SR_ERRWRN_MASK		0x00000040 /* Error warning */
@@ -132,6 +133,8 @@ enum xcan_reg {
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
 /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
+#define XCAN_BRPR_TDCO_SHIFT		8  /* Transmitter Delay Compensation Offset */
+#define XCAN_BRPR_TDC_ENABLE		BIT(16) /* Transmitter Delay Compensation (TDC) Enable */
 #define XCAN_BTR_SJW_SHIFT		7  /* Synchronous jump width */
 #define XCAN_BTR_TS2_SHIFT		4  /* Time segment 2 */
 #define XCAN_BTR_SJW_SHIFT_CANFD	16 /* Synchronous jump width */
@@ -140,6 +143,7 @@ enum xcan_reg {
 #define XCAN_IDR_ID2_SHIFT		1  /* Extended Message Identifier */
 #define XCAN_DLCR_DLC_SHIFT		28 /* Data length code */
 #define XCAN_ESR_REC_SHIFT		8  /* Rx Error Count */
+#define XCAN_SR_TDCV_SHIFT		16 /* TDCV Value */
 
 /* CAN frame length constants */
 #define XCAN_FRAME_MAX_DATA_LEN		8
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
@@ -424,6 +438,11 @@ static int xcan_set_bittiming(struct net_device *ndev)
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
 		/* Setting Baud Rate prescalar value in F_BRPR Register */
 		btr0 = dbt->brp - 1;
+		if (can_tdc_is_enabled(&priv->can)) {
+			btr0 = btr0 |
+			priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
+			XCAN_BRPR_TDC_ENABLE;
+		}
 
 		/* Setting Time Segment 1 in BTR Register */
 		btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
@@ -1483,6 +1502,23 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
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
+	*tdcv = (priv->read_reg(priv, XCAN_SR_OFFSET) & XCAN_SR_TDCV_MASK) >>
+		 XCAN_SR_TDCV_SHIFT;
+
+	return 0;
+}
+
 static const struct net_device_ops xcan_netdev_ops = {
 	.ndo_open	= xcan_open,
 	.ndo_stop	= xcan_close,
@@ -1734,18 +1770,22 @@ static int xcan_probe(struct platform_device *pdev)
 	priv->can.do_get_berr_counter = xcan_get_berr_counter;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_BERR_REPORTING;
+	priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
 
 	if (devtype->cantype == XAXI_CANFD)
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

