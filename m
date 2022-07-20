Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0974157BDC9
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiGTSbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiGTSbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18056709A3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4rq1PyWRImwePhjGzkWpEmNxJZFGzuwlvbBVQbShz/Ae4b938MKt3cFO/hJuEMRMhnP3DTsdRy1lOpxA/8x+ge7p5fJJyMnU2gyyQ+RSouQR18atbMkf9FAgm40hH/lzAXKPuT5BY58Rh4g2xCiYaEXI6uEXLBuZbeZsEUYGttPOgyzWnCGombYkxPpS0+Xz+/1Oh/p8hAirAATPzCQTq+If6qM0f1mBXEL43TnKTE3xxvIFFdxEpu4QuRwUYOrlKM+yzNE5vl/3+cQ39RfvNX4RMUBwSx8k7nQo7boiOvVUkomevRsiaJDP3BM7Eq3QapEFjL3wqIhOg56H1nvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=kOJLmxe/a5/Uq5E6zRhnre5jPRSlXuP7NnbBAs47IBhsDp9CjaTJWCJTJccQRo3crvGNXq3bObejohgffAcJbjextpbbQbGHN7CGDH9K8LLdHtGFL+SG0/BuuOlPO1FxD7hei+tXHzcjKqiSgxqV9V9t6ETVaT5y4Sv5W6tjWQ9x0DfBoer4kpwd5d6vp/0nsrb9PLmo6ZK4CU8MGrBV2nQEBnot1Vb2udpJ7C9lTO3/B1oTzk0KdIJK4veD+28OBLZG4rTUidu6Qw3sXHSVv8mCHe9wx+we2dLQ1tqq1f/NRDLDk9qSvWtSDhSZjOiT247Z7mUaHXOdpy8nSrmxiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=em42ggTbki+E7w101J1rAoHomhlzidDDZVIsn9DQXJ1zEqv4ENHpOBdD+OYL1wX9w2CHmnaOoS0F+XTNNlqCZqYo9knRUwLrn9NOg4jHlUAqfPYLQ2hntOkIj8LrPe9VMxeL6QSkfBVANwCJjfS4Q1IPbMLmlyx9VJ1mx3ydfq3o5KmwtU/TXQ9V9Y1c/kxpr2zbJHYcosYrr+e4w2SD2i6QCYamfLy/a504de4xqQOFw44sN7tC66vM9vpC0NzRsvPZII33hqjlP8RWAws4VVE+aORAJbyletXDslTlvx7uSn6yxDl84GBLvxpa4YvYpncQc8JDMUBInderpMf4+g==
Received: from MW4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:303:8f::29)
 by PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 18:30:59 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::bc) by MW4PR03CA0024.outlook.office365.com
 (2603:10b6:303:8f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 20 Jul 2022 18:30:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:30:58 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:54 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:30:53 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:52 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 02/10] sfc: update EF100 register descriptions
Date:   Wed, 20 Jul 2022 19:29:27 +0100
Message-ID: <06cadeee90ff7a066c598e28fda5b5e0267212ac.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10626e04-900b-46ef-8c55-08da6a7dfde9
X-MS-TrafficTypeDiagnostic: PH7PR12MB6787:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GmUDyTem8sinDS6DD272sT4ignnuniutpPKoandHzELGdaH3TdNA7c2lV/R7zCs62Kv42rMs2hPSgJUcWo3sxkDlBrjMlNFXwyt2lDvMDrpNPyUkWvX1t52+EVn8K9H7J9CHyhGjQKD4ckQoUdhi08ytr+ihj7vEJTMz40GNoskyovWmJ78MPhNKtG214Q+Ur8ECUgSB+EcIpuMIDcGAUgqJl0kFEh8mUz5GcG8qwcZJ0Df7qIFFUYAgxyq7U7jwivF/jNRL7TMItubPd5JVi6zk9SY6uPN5QcZzD9YTkcPGGaFmzc7awBBylovo4H+lG6bCWNJQGzwk0Ybk4FsAMdQ7npZZr6jasld5cojPES/A0N91sr/WHRvQPyZIefEYY7qL0v1ab4u62yFZFe2Vc01KR6vyL9Xo4dYa9eMkJ94JYM14I1ryuj7IKQ7Kbkvp9goqdRtYG4MQWJIHD/eaRCJqe2IXGBanVYw/0n12My2i+59l8tcu/15xOnsnyyF/J5/NrswUHrnp+E/Cuuw75z8SHWm5tG2H7oHF65mzLoAC4TOsO+tVGg7AUCJX8vQjfarxlksUeU/jNYhjZhsXHxMrQr3nN/qveZwZqcnU1tItLHM90iLcnp7oKVNMy8Y+xhhjc+AGg/A94CbNA0V4A+L46Y/xRpmreMtpOs81VyurXuzDr6vXymQvqxr/7+7cVVQ2Xxl9p8tOxJnDtCWTS4G9A0HvByxqd5F2HaXDe+FWeDANpgtXbh2YqUlls06BVZsEjAuDR2EZ/SMuj/+cYwww60EpCurtqLM2t8VOigwBdxrOsXh3O+TQBJSSwan4MPK95Va2sb+DRiOVuKwvQYvGRPo1C+f1lY+nYT6Wn4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(8936002)(82310400005)(54906003)(36756003)(2876002)(5660300002)(81166007)(55446002)(40460700003)(70586007)(4326008)(40480700001)(110136005)(2906002)(82740400003)(8676002)(6666004)(83170400001)(336012)(316002)(26005)(9686003)(186003)(83380400001)(356005)(42882007)(47076005)(36860700001)(41300700001)(478600001)(70206006)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:30:58.7869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10626e04-900b-46ef-8c55-08da6a7dfde9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787
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
