Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C7E5761C8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiGOMgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiGOMgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1AB52E7C
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOUD2iC8HspeA+dKxEUrWXGcr5BhV0G+9QenA9X/BaK23gdm7fBlEflleFvvoJw/5pOlDbCosMP4wdV8XauGdfdkMDxdY35jpIs79TJNZ0KxxY96lR5NKyirrHWBGG2A/hmqANwYS+U4IfkDc/bHw9m4WT+raKpDZ9+AxHjfmYmMoDOj9hhDSWuo06it2p5+irAXqg7AGp/PHxaraITuegeVTGVYyOK5uUMYA9weqxxn8v35qXBh1e8zM0ICaoLY7390xSkR0k7P7PJvhKbZxwzDyidL7sjTArbuE8+VQN3BJwKIv2Z/atnpMtOp5xZr4BqRxVdjQEXrQ9s6MEbI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=PrTsOhEdMDTdHoydkSt1+ScSBsgCaEmkXEDl7GnTRw2v3wel6/dH0j93TqzVEHmJlDS4ZbdayjLYcdpiV3cH1eyHnibtmJpvmUDvBOKH11b4Jnr9RjgXevG2SUHeCPyvMJBFRO3aNU5VzEIN0QaESL0kgkNOjNf/kzcvYgeNIKl7O4krwSsIUhLHQwzdST2/2BeHYIsw4EjH3SGsAz7wDcn/zILIKGBRaBcnSC75xd0Bgol0YAOvrxrG3HmAWepYecSWv768nMQYF1RmYo64fwnOYTV5tVf4QkzvWea2zd2uakCKc+5R3/AlieDEjB7zXY8id3pIuFryI68B84Ns2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dy+zoS7b7v8jAwNPs8NVJkMgVn/vOfQYzCfg04e//lw=;
 b=x7hq8DafV6A1W8pJ+ErC4DCeAL3T30xAwp2dm+Z+7E4iXsbsZ4i+zNHPo4nuWjzi3JLxD15dIHAOKAsJXTCqk9SX5xjviGT4izzW49lBJoauTR58v9RJtjdrwTVb8nkscXYpirjAnpOYiW7e4o39NPmhEr3tRbaES8ptZIiorhO0x/p+ZakVAgXsr6TiFz7goHK8t0vKkJR1G9lRoRCbJD12U8dmUFqGyK2eIkgguAIwCTu2cBC9IkH6m82SElka5bYl5gJkv08w9bGtKSxxn7EpurQBJeQ3Ih95OsVMzpHeDYkQfAgq0lyBJsPV0uKnsmMI6Y2lhpYyqIBNHxiamQ==
Received: from BN9PR03CA0885.namprd03.prod.outlook.com (2603:10b6:408:13c::20)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 12:36:11 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::6b) by BN9PR03CA0885.outlook.office365.com
 (2603:10b6:408:13c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:11 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:10 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:10 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:09 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 02/10] sfc: update EF100 register descriptions
Date:   Fri, 15 Jul 2022 13:33:24 +0100
Message-ID: <06cadeee90ff7a066c598e28fda5b5e0267212ac.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0911bc6b-32d7-417e-42df-08da665e9951
X-MS-TrafficTypeDiagnostic: IA1PR12MB6209:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAStmfXKqKgGvzuIry0IK7lnWPvlxeQTQ4Wbg5QKg4+I7ghpEo0XQawyksiN1ZjqgshmwsyNKVjdxH60cBzfSl9PlGs4FaERLSdEISEeSodggi3kyo7CBoTIky7B35TcllbZDKMvjZL7AQ6MikuWFW3YUhifH9OHPkwS+Tb1NA1DVPMpBLUXpgeXY9xnXZrZeUr7jTESRnz+AAq++axCC3lb9ie/WH1FLhHEYo1mi0XBEpAN9qrPMkmZtElXSO8GHwFCOIaVo7zbjaesfvxMb7bFxqiGhAb5NDs50h79R0IPGRoJuMqIPUAAFm3zsmXfWezT9ir4k/LLJknYeTMXMdTu85zo20+y1U7EKIfgac74lPJib0oUOvqrkXlRTlp5U33CgTWUIvIEz4+Lep9jqOjZlyUQR6DcR0HBHD8AZ8Lw2MLP+DQZ2UrkARj1BFzTI0Su29GkxmZkywDRFoLm/gLKnZJkZX9sfkbqZxgB8xaurmicL6KSVmzQK/No6RzWCM29e3FF2TLNbpwME5L/iCptb0ODfpOeeryltUFD6GQIxRwWyh4oL3+UX7sPSjC4EqSNMJ9EPCmLeeIsJ25iUmYw0MXsUI4atTZKnagTWXtZLjLZpGu9O3U+KCcKvN2yoOIDBgo6ZOcn2CQw7VvYoaIWv+JY3WvE4dWuw5HXWCNFAG7YrGs5kdok3iEshP4BdgJ/fr/lI3YkSQuEL87x0V9iRb8UocE6aJtVzmxFSJvHi0JTOO7Ula3iEzDbMtsP/8EoegmbcaObYyygOwqVBU7FDcx0/q8QfQqUF/mRFSXrB+LjnhUuo+xhE+0RRD1Yr2rQckz6CE85Vnn1PrPcSkxedwZWN/QTvcHIAWDWG/3KpiV1mFGYZNxvTR1rgk7y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(356005)(47076005)(82740400003)(186003)(36860700001)(336012)(36756003)(42882007)(8936002)(2906002)(2876002)(5660300002)(40480700001)(26005)(110136005)(478600001)(8676002)(6666004)(81166007)(9686003)(41300700001)(316002)(70586007)(83380400001)(83170400001)(70206006)(4326008)(55446002)(82310400005)(54906003)(40460700003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:11.0763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0911bc6b-32d7-417e-42df-08da665e9951
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209
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
