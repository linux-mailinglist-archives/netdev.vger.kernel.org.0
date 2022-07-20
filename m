Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB4657BDC4
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiGTSag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiGTSaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:30:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D496FA02
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/8VtAq/6weDDwWQaQUt1WLCZ0tnc+mlIdRtYpAKFRVWg8Nw2ql6pvsuar20JTss/zSmgKa5xvI5to/DEveDE8JuhR7YfLHeYePyW5kKGMuDfQ26CP3y40XIbOV+XZTOoMITcP+Pgw8v62NQeaqsn1F4KwD5TWnmXKDfJrlaynOTmEGlNJvViO89J7+Pkk2zYmP+N3HlzdNGwTRodbBSxiLykAGrcXWZuTge97KRTpyfwCC6TPSHuUfYtG2tG1POURgDPjxPOQNXsBHB1IcbI6IBx+5Bauby51STAq27rMO9dh0bcgGeaU92tRfrQF+kxkcrqZNY/okgW3FjMx//DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=JUW9v53WL4evlxLgnPS7tVIs1yCtCOvWnQJbMUf1l0K0bZoNKpxSkGzw712/1G7977VqnhstCbh6bq6Z8V8TU4HwqTicaY2d92l9pMM7rxjYyncbecD8HjgqPK6WHBzAa3pfYSYusIHubbKvUKgLx6q82KpsdD3YsWnXAod0GyDEYY/WygHGpELVZ3bXZUtvf/rTQWazft3+pokbqn93XZkH4jdWXdBB7LmBfJv2rJCPVU0V5QVZFbZwwmofciqgLrq8RJTa7hwcCUaI0CkCGXx4l3IN5fIYy+ctCXtuXNum8jllFYG/iKdUT6tQ8jQ0+bxRP5QjD/xvxIe/fo6Kpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=B5KGXNsYeh5NNgiSeH6cevhgkfozNpwFzEQ+mYrOSrqPCi2uIjuLJdWyJqsw9ZQCMRqzzuwspQePyGYA/h8VAo0wHMfOU5BfIY5S86POIZjaptx60wQ/UsLJlXUKw+G8shZLku7W8Hnq1QJqVy1ZZdCK1jiF1C+LKig3km6J/jplj43ZxHeNQ6bp5yhtMxUZBBOU5NTJcWkz4IfwB18lOWtZd5mg7Wro0HPSt4Wsl9mYdpf7sq5GUpENhSeGePEMBAySrK5+mCVEDaPoOmcB2FdN5RK2pfnSvPlSz9KarfkilAV9Jq7bsY3HpKe9Pp/WMsyDVw/RpKOFX1GzqVhM0A==
Received: from MW4PR04CA0241.namprd04.prod.outlook.com (2603:10b6:303:88::6)
 by BL3PR12MB6380.namprd12.prod.outlook.com (2603:10b6:208:3b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 18:30:32 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::d1) by MW4PR04CA0241.outlook.office365.com
 (2603:10b6:303:88::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24 via Frontend
 Transport; Wed, 20 Jul 2022 18:30:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:30:31 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:30 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:30 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:29 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 1/9] sfc: update EF100 register descriptions
Date:   Wed, 20 Jul 2022 19:29:24 +0100
Message-ID: <f8d0b3c9e657e6852b2b4a671a318aa5a6375341.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75a6bc62-8f40-404c-7997-08da6a7dedac
X-MS-TrafficTypeDiagnostic: BL3PR12MB6380:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94a7IGuX92bqTr5vp8gkNLn0/ZQjwwSE/qRGTAS+cZb1rcqdR5p55ibEzCSMnf03JZ8ALc83cND4BNrKM2G/gFfqQGqU/ApzCuS2m4mS4e0sfOvxYZ4NAtqZv7+RA02rPzsQTs7BUAGXBoJY/tDfL8hXoQSn0vWawCYg05JjyIna/zByd3VXRBfhHH+OWMJSKGJHbRvRBT58Eh2a26rd6QBgFpM/zSjsCZfFTYCAjlfqbHgXSNwLdbFuAcGTZ7FBUm3FshNML9AWI8WA5IhoTAkNhVgUq4XqK0VRMIofxGHsLQtN7sPv4bHQbhtseqlyBGxHGZvv4cvydK27eYJ8g7hF/FR3ksbYBZ06gj1AMLxStYV+If+Ic1+GXgDfsBNCfl0nEwRL2db9DMFdr+bkPgotiFBJuQgK4CZOo5vKg/a8Lo9vsyr7vUcA4r5DQYF5a+F0xDLUfjFnSM7NTwXjHqfTLlkyHH1AU2RX+lZHchW0tVUBFV6OFL5mNIrEH61ZX0/Xng5rE3EO2cFNxeBpK0FzDfisAuEr734+jUHwmvFnbB7beqxAZTCsMcb6IN+1IfIIzwzSA5wsqsg66d1mXH1WyJ1BqLYJFxyc2dSrrVrX74ti2+cmPxhlKXECEKrpVNy3pusMEtC/+jSPt8RKN4/ODbuTUannvByRmUn4jexmyOqAljysiClQu7XL3pPAhUyfZexnDLCAZ/SC0NlaCdH5LzPIcwyxeju4YAMyd7N1lBYlzbmQTFpKwIbPrHt8Gxv12jn2hMMrbVOUz51uCFK7hFf+n03gBpvHuHDLgGHosIBXRs5bv1Tp1zHuF00UMfngtwEE2p9JNajcXTMfGiiEec0U45jIUhRaFajoyzQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(40470700004)(36840700001)(6666004)(8936002)(41300700001)(5660300002)(82740400003)(356005)(478600001)(81166007)(9686003)(8676002)(83170400001)(42882007)(336012)(70206006)(47076005)(83380400001)(54906003)(110136005)(40460700003)(70586007)(36860700001)(26005)(316002)(186003)(4326008)(2906002)(55446002)(36756003)(2876002)(40480700001)(82310400005)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:30:31.5431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a6bc62-8f40-404c-7997-08da6a7dedac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6380
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_regs.h | 83 +++++++++++++++++++--------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_regs.h b/drivers/net/ethernet/sfc/ef100_regs.h
index 710bbdb19885..982b6ab1eb62 100644
--- a/drivers/net/ethernet/sfc/ef100_regs.h
+++ b/drivers/net/ethernet/sfc/ef100_regs.h
@@ -2,7 +2,7 @@
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
  * Copyright 2018 Solarflare Communications Inc.
- * Copyright 2019-2020 Xilinx Inc.
+ * Copyright 2019-2022 Xilinx Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -181,12 +181,6 @@
 /* RHEAD_BASE_EVENT */
 #define	ESF_GZ_E_TYPE_LBN 60
 #define	ESF_GZ_E_TYPE_WIDTH 4
-#define	ESE_GZ_EF100_EV_DRIVER 5
-#define	ESE_GZ_EF100_EV_MCDI 4
-#define	ESE_GZ_EF100_EV_CONTROL 3
-#define	ESE_GZ_EF100_EV_TX_TIMESTAMP 2
-#define	ESE_GZ_EF100_EV_TX_COMPLETION 1
-#define	ESE_GZ_EF100_EV_RX_PKTS 0
 #define	ESF_GZ_EV_EVQ_PHASE_LBN 59
 #define	ESF_GZ_EV_EVQ_PHASE_WIDTH 1
 #define	ESE_GZ_RHEAD_BASE_EVENT_STRUCT_SIZE 64
@@ -369,14 +363,18 @@
 #define	ESF_GZ_RX_PREFIX_VLAN_STRIP_TCI_WIDTH 16
 #define	ESF_GZ_RX_PREFIX_CSUM_FRAME_LBN 144
 #define	ESF_GZ_RX_PREFIX_CSUM_FRAME_WIDTH 16
-#define	ESF_GZ_RX_PREFIX_INGRESS_VPORT_LBN 128
-#define	ESF_GZ_RX_PREFIX_INGRESS_VPORT_WIDTH 16
+#define	ESF_GZ_RX_PREFIX_INGRESS_MPORT_LBN 128
+#define	ESF_GZ_RX_PREFIX_INGRESS_MPORT_WIDTH 16
 #define	ESF_GZ_RX_PREFIX_USER_MARK_LBN 96
 #define	ESF_GZ_RX_PREFIX_USER_MARK_WIDTH 32
 #define	ESF_GZ_RX_PREFIX_RSS_HASH_LBN 64
 #define	ESF_GZ_RX_PREFIX_RSS_HASH_WIDTH 32
-#define	ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN 32
-#define	ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_WIDTH 32
+#define	ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN 34
+#define	ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_WIDTH 30
+#define	ESF_GZ_RX_PREFIX_VSWITCH_STATUS_LBN 33
+#define	ESF_GZ_RX_PREFIX_VSWITCH_STATUS_WIDTH 1
+#define	ESF_GZ_RX_PREFIX_VLAN_STRIPPED_LBN 32
+#define	ESF_GZ_RX_PREFIX_VLAN_STRIPPED_WIDTH 1
 #define	ESF_GZ_RX_PREFIX_CLASS_LBN 16
 #define	ESF_GZ_RX_PREFIX_CLASS_WIDTH 16
 #define	ESF_GZ_RX_PREFIX_USER_FLAG_LBN 15
@@ -454,12 +452,8 @@
 #define	ESF_GZ_M2M_TRANSLATE_ADDR_WIDTH 1
 #define	ESF_GZ_M2M_RSVD_LBN 120
 #define	ESF_GZ_M2M_RSVD_WIDTH 2
-#define	ESF_GZ_M2M_ADDR_SPC_LBN 108
-#define	ESF_GZ_M2M_ADDR_SPC_WIDTH 12
-#define	ESF_GZ_M2M_ADDR_SPC_PASID_LBN 86
-#define	ESF_GZ_M2M_ADDR_SPC_PASID_WIDTH 22
-#define	ESF_GZ_M2M_ADDR_SPC_MODE_LBN 84
-#define	ESF_GZ_M2M_ADDR_SPC_MODE_WIDTH 2
+#define	ESF_GZ_M2M_ADDR_SPC_ID_LBN 84
+#define	ESF_GZ_M2M_ADDR_SPC_ID_WIDTH 36
 #define	ESF_GZ_M2M_LEN_MINUS_1_LBN 64
 #define	ESF_GZ_M2M_LEN_MINUS_1_WIDTH 20
 #define	ESF_GZ_M2M_ADDR_LBN 0
@@ -492,12 +486,8 @@
 #define	ESF_GZ_TX_SEG_TRANSLATE_ADDR_WIDTH 1
 #define	ESF_GZ_TX_SEG_RSVD2_LBN 120
 #define	ESF_GZ_TX_SEG_RSVD2_WIDTH 2
-#define	ESF_GZ_TX_SEG_ADDR_SPC_LBN 108
-#define	ESF_GZ_TX_SEG_ADDR_SPC_WIDTH 12
-#define	ESF_GZ_TX_SEG_ADDR_SPC_PASID_LBN 86
-#define	ESF_GZ_TX_SEG_ADDR_SPC_PASID_WIDTH 22
-#define	ESF_GZ_TX_SEG_ADDR_SPC_MODE_LBN 84
-#define	ESF_GZ_TX_SEG_ADDR_SPC_MODE_WIDTH 2
+#define	ESF_GZ_TX_SEG_ADDR_SPC_ID_LBN 84
+#define	ESF_GZ_TX_SEG_ADDR_SPC_ID_WIDTH 36
 #define	ESF_GZ_TX_SEG_RSVD_LBN 80
 #define	ESF_GZ_TX_SEG_RSVD_WIDTH 4
 #define	ESF_GZ_TX_SEG_LEN_LBN 64
@@ -583,6 +573,12 @@
 #define	ESE_GZ_SF_TX_TSO_DSC_FMT_STRUCT_SIZE 124
 
 
+/* Enum D2VIO_MSG_OP */
+#define	ESE_GZ_QUE_JBDNE 3
+#define	ESE_GZ_QUE_EVICT 2
+#define	ESE_GZ_QUE_EMPTY 1
+#define	ESE_GZ_NOP 0
+
 /* Enum DESIGN_PARAMS */
 #define	ESE_EF100_DP_GZ_RX_MAX_RUNT 17
 #define	ESE_EF100_DP_GZ_VI_STRIDES 16
@@ -630,6 +626,19 @@
 #define	ESE_GZ_PCI_BASE_CONFIG_SPACE_SIZE 256
 #define	ESE_GZ_PCI_EXPRESS_XCAP_HDR_SIZE 4
 
+/* Enum RH_DSC_TYPE */
+#define	ESE_GZ_TX_TOMB 0xF
+#define	ESE_GZ_TX_VIO 0xE
+#define	ESE_GZ_TX_TSO_OVRRD 0x8
+#define	ESE_GZ_TX_D2CMP 0x7
+#define	ESE_GZ_TX_DATA 0x6
+#define	ESE_GZ_TX_D2M 0x5
+#define	ESE_GZ_TX_M2M 0x4
+#define	ESE_GZ_TX_SEG 0x3
+#define	ESE_GZ_TX_TSO 0x2
+#define	ESE_GZ_TX_OVRRD 0x1
+#define	ESE_GZ_TX_SEND 0x0
+
 /* Enum RH_HCLASS_L2_CLASS */
 #define	ESE_GZ_RH_HCLASS_L2_CLASS_E2_0123VLAN 1
 #define	ESE_GZ_RH_HCLASS_L2_CLASS_OTHER 0
@@ -666,6 +675,25 @@
 #define	ESE_GZ_RH_HCLASS_TUNNEL_CLASS_VXLAN 1
 #define	ESE_GZ_RH_HCLASS_TUNNEL_CLASS_NONE 0
 
+/* Enum SF_CTL_EVENT_SUBTYPE */
+#define	ESE_GZ_EF100_CTL_EV_EVQ_TIMEOUT 0x3
+#define	ESE_GZ_EF100_CTL_EV_FLUSH 0x2
+#define	ESE_GZ_EF100_CTL_EV_TIME_SYNC 0x1
+#define	ESE_GZ_EF100_CTL_EV_UNSOL_OVERFLOW 0x0
+
+/* Enum SF_EVENT_TYPE */
+#define	ESE_GZ_EF100_EV_DRIVER 0x5
+#define	ESE_GZ_EF100_EV_MCDI 0x4
+#define	ESE_GZ_EF100_EV_CONTROL 0x3
+#define	ESE_GZ_EF100_EV_TX_TIMESTAMP 0x2
+#define	ESE_GZ_EF100_EV_TX_COMPLETION 0x1
+#define	ESE_GZ_EF100_EV_RX_PKTS 0x0
+
+/* Enum SF_EW_EVENT_TYPE */
+#define	ESE_GZ_EF100_EWEV_VIRTQ_DESC 0x2
+#define	ESE_GZ_EF100_EWEV_TXQ_DESC 0x1
+#define	ESE_GZ_EF100_EWEV_64BIT 0x0
+
 /* Enum TX_DESC_CSO_PARTIAL_EN */
 #define	ESE_GZ_TX_DESC_CSO_PARTIAL_EN_TCP 2
 #define	ESE_GZ_TX_DESC_CSO_PARTIAL_EN_UDP 1
@@ -681,6 +709,15 @@
 #define	ESE_GZ_TX_DESC_IP4_ID_INC_MOD16 2
 #define	ESE_GZ_TX_DESC_IP4_ID_INC_MOD15 1
 #define	ESE_GZ_TX_DESC_IP4_ID_NO_OP 0
+
+/* Enum VIRTIO_NET_HDR_F */
+#define	ESE_GZ_NEEDS_CSUM 0x1
+
+/* Enum VIRTIO_NET_HDR_GSO */
+#define	ESE_GZ_TCPV6 0x4
+#define	ESE_GZ_UDP 0x3
+#define	ESE_GZ_TCPV4 0x1
+#define	ESE_GZ_NONE 0x0
 /**************************************************************************/
 
 #define	ESF_GZ_EV_DEBUG_EVENT_GEN_FLAGS_LBN 44
