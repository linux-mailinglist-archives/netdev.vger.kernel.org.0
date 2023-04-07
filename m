Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D6F6DA9CF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbjDGILo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjDGILl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:11:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC924A5F8;
        Fri,  7 Apr 2023 01:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROAu2EpglJWrYkEKrFVA+sOnOw99qVrm5sSAzh2YKtDSqzA9X6e5VKARByFaTsUKjy3uWmrGH1Tw3DM9nNIKscYrAUzoFHdXNNbjmsUWdKe/Bruxo8/7rDpk4c1vPwKe7SkOcQVmWFvgUmujaK/JbIMAtkdS13nq7nlP1LY/IrH97GIsNQDy5ACmchPF2uxHkticrsBkCBKpqSFl/8d/j2sFpu6MgiWZJynYujYszU9o9vr3e+Va5TrtQF82nsonj5xe8cb2weCRmnE9BkLPCOVfCDb4aa9+yD9YL+UpkEScvpsp4zyQhMF+Clfw5hFJNf3aAD9VRqhTDK53xmgJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06PFvbF77ZDl1X3J+AOI3AqWKo5zqsBgjSQSY/Di4I0=;
 b=YHA3ZtgNny15sik59sSkIKyKICBYuAS9BtmW0jdC5pXYNDbE0GLuONp/ld9nL2ZqtFELTAWQn72+fhX05OShWV3MwdCQWUnCacF2oEwOIsNdYGRWkv5nFeanIWUeUIFuG6ClArPKZcsnlS76tFgJW46LzEa19u4NKUV0pK8pLJ0AiPAUHFO2t3Vq8x4rXxz0xSeHZHU2Q1BNFJOYJPvA7XwdaI8VNzRW5rXN9p40sUUFcQSTRVbftsMbc6wMwe1Tdy8QQMF1X7bZx0jBOFngAOEK7wyDWCUSaXOC0H8Z+IyzfP/OshWagPmkCYoObow+hDT/BmIuMpYNmwQnO+eSWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06PFvbF77ZDl1X3J+AOI3AqWKo5zqsBgjSQSY/Di4I0=;
 b=liti01Ahbl221muzNBjCkkxu7D4RkUVoZcfsHLvzelAfPXup2g8btFRUTwbayXkMplAQTEmZbDjMfMecs0IwrV+KPm0wWibAfQgT60UaEiIoCB3sgRHKfA/qAOSD09GxwtbV8mrb+LE20yK1mtUe9pqpvlyzuL87vbpTToqxzbQ=
Received: from MW3PR06CA0002.namprd06.prod.outlook.com (2603:10b6:303:2a::7)
 by CY8PR12MB7169.namprd12.prod.outlook.com (2603:10b6:930:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Fri, 7 Apr
 2023 08:11:06 +0000
Received: from CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::5a) by MW3PR06CA0002.outlook.office365.com
 (2603:10b6:303:2a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT085.mail.protection.outlook.com (10.13.174.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 08:11:05 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:04 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 01:11:02 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:10:58 -0500
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v4 03/14] sfc: update MCDI headers for CLIENT_CMD_VF_PROXY capability bit
Date:   Fri, 7 Apr 2023 13:40:04 +0530
Message-ID: <20230407081021.30952-4-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT085:EE_|CY8PR12MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f0faf2-c232-4b4f-6f94-08db373fa2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcPaotGtTGqyMPHfOlemEZElG71CUFjjQzW7NkXlBXNi8cqQxqEyMjgO1mRUqKaO+b3ZO/C1VtCu/ojVdc7PhsUPiHRSjrTvVp/TNgvynNecrrjyi/qDhX1AWlxDnyNpNeimf68YIkUtZbDKw4VWXjz8asYnblmokVEU7mxRIGJnR6WuZaVk0uc7XeDO6AMlnUrkYP94XvyXS/5h4+dR55qhYEXxOqoujolLdqjTg2S0dv6szSF6FnEzJtBo6sUZsbKourde2GHtvWgbDu6/7fQdqoczA+n2vI61pw2cjU3+AKsj/AO2c19g2SIrZjlNWFkCSGWTQ2j1/m47OZ5VBUBheV+hiYkdl2lge45c9mAmTnrz/WTu2Na+xDnjbCd9SYZbKcWy60rESHKOXGO7Gnj2a1RtPxCoaj0udCF6zPjQbou+F0Chv0h4E6aIFmwh/P+r4PU4V7hnbP9/TJs0S9mIWKsOm1f4mmW4UrOc8iFgsLXS3XrplnAEFyrENzcv6dMXEHq72bOBTRpg/aDOGq+QnCJJgjnzp8lCUe+MxpDlwk87fFeIzCothjCo05f5DT3F75X5LfGGcVk6zj60WCR1dd9OKfgapt0eb634egUY1SM8XhTRElGr+EA9U+XFX1JxAylWrqwTbj+VTgwt2tWzNUMCzuMMa5Cu4VypU3DibwgthEG1fvLCoir6r82X5qHa115Y1tFAjsvx58m5frj58PCUVpy7uetYUp9XFaor9IDSJzyXvm9fqicOYSs8r4uDqDMYqXrSg+wmyS8iKzocAhOb24BqGFp2Tb9VJKA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(66899021)(6666004)(82310400005)(4326008)(41300700001)(36756003)(44832011)(7416002)(15650500001)(5660300002)(40480700001)(70586007)(30864003)(81166007)(86362001)(82740400003)(70206006)(40460700003)(8676002)(8936002)(356005)(921005)(336012)(110136005)(2906002)(186003)(83380400001)(36860700001)(66574015)(426003)(26005)(2616005)(47076005)(1076003)(478600001)(54906003)(316002)(966005)(461764006)(21314003)(36900700001)(559001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:05.5596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f0faf2-c232-4b4f-6f94-08db373fa2d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7169
X-Spam-Status: No, score=1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA requires the ability to proxy MCDI commands from a PF to a VF
there by using PF's IOMMU domain for executing vDPA VF's MCDI commands
ensuring isolation from the DMA domain used by guest buffers.
A new capability bit CLIENT_CMD_VF_PROXY has been added to Firmware,
which when exposed, suggests that Firmware supports MC_CMD_CLIENT_CMD
to VFs and hence supports vDPA requirement.
mcdi_pcol.h is a tool generated file and hence may not be free from
all checks and/or warnings when tested with checkpatch.pl script.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/mcdi_pcol.h | 4391 +++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_vdpa.c |   10 +-
 2 files changed, 4289 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index cd297e19cddc..9c17dec0bdf0 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -2,10 +2,10 @@
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
  * Copyright 2009-2018 Solarflare Communications Inc.
- * Copyright 2019-2020 Xilinx Inc.
+ * Copyright 2019-2022 Xilinx Inc.
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  */
 
-
 #ifndef MCDI_PCOL_H
 #define MCDI_PCOL_H
 
@@ -72,19 +72,19 @@
  *               |                      \------- Error
  *               \------------------------------ Resync (always set)
  *
- * The client writes it's request into MC shared memory, and rings the
- * doorbell. Each request is completed by either by the MC writing
+ * The client writes its request into MC shared memory, and rings the
+ * doorbell. Each request is completed either by the MC writing
  * back into shared memory, or by writing out an event.
  *
  * All MCDI commands support completion by shared memory response. Each
  * request may also contain additional data (accounted for by HEADER.LEN),
- * and some response's may also contain additional data (again, accounted
+ * and some responses may also contain additional data (again, accounted
  * for by HEADER.LEN).
  *
  * Some MCDI commands support completion by event, in which any associated
  * response data is included in the event.
  *
- * The protocol requires one response to be delivered for every request, a
+ * The protocol requires one response to be delivered for every request; a
  * request should not be sent unless the response for the previous request
  * has been received (either by polling shared memory, or by receiving
  * an event).
@@ -121,7 +121,6 @@
 
 #define MCDI_CTL_SDU_LEN_MAX MCDI_CTL_SDU_LEN_MAX_V2
 
-
 /* The MC can generate events for two reasons:
  *   - To advance a shared memory request if XFLAGS_EVREQ was set
  *   - As a notification (link state, i2c event), controlled
@@ -165,6 +164,7 @@
 #define FSE_AZ_EV_CODE_MCDI_EVRESPONSE 0xc
 
 
+
 #define MC_CMD_ERR_CODE_OFST 0
 #define MC_CMD_ERR_PROXY_PENDING_HANDLE_OFST 4
 
@@ -228,7 +228,6 @@
  */
 #define EVB_STACK_ID(n)  (((n) & 0xff) << 16)
 
-
 /* Version 2 adds an optional argument to error returns: the errno value
  * may be followed by the (0-based) number of the first argument that
  * could not be processed.
@@ -321,7 +320,7 @@
 /* enum: The requesting client is not a function */
 #define          MC_CMD_ERR_CLIENT_NOT_FN 0x100c
 /* enum: The requested operation might require the command to be passed between
- * MCs, and thetransport doesn't support that. Should only ever been seen over
+ * MCs, and the transport doesn't support that. Should only ever been seen over
  * the UART.
  */
 #define          MC_CMD_ERR_TRANSPORT_NOPROXY 0x100d
@@ -358,7 +357,7 @@
  * sub-variant switching.
  */
 #define          MC_CMD_ERR_FILTERS_PRESENT 0x1014
-/* enum: The clock whose frequency you've attempted to set set doesn't exist on
+/* enum: The clock whose frequency you've attempted to set doesn't exist on
  * this NIC
  */
 #define          MC_CMD_ERR_NO_CLOCK 0x1015
@@ -640,7 +639,11 @@
  * be allocated by different counter blocks, so e.g. AR counter 42 is different
  * from CT counter 42. Generation counts are also type-specific. This value is
  * also present in the header of streaming counter packets, in the IDENTIFIER
- * field (see packetiser packet format definitions).
+ * field (see packetiser packet format definitions). Also note that LACP
+ * counter IDs are not allocated individually, instead the counter IDs are
+ * directly tied to the LACP balance table indices. These in turn are allocated
+ * in large contiguous blocks as a LAG config. Calling MAE_COUNTER_ALLOC/FREE
+ * with an LACP counter type will return EPERM.
  */
 /* enum: Action Rule counters - can be referenced in AR response. */
 #define          MAE_COUNTER_TYPE_AR 0x0
@@ -648,6 +651,14 @@
 #define          MAE_COUNTER_TYPE_CT 0x1
 /* enum: Outer Rule counters - can be referenced in OR response. */
 #define          MAE_COUNTER_TYPE_OR 0x2
+/* enum: LACP counters - linked to LACP balance table entries. */
+#define          MAE_COUNTER_TYPE_LACP 0x3
+
+/* MAE_COUNTER_ID enum: ID of allocated counter or counter list. */
+/* enum: A counter ID that is guaranteed never to represent a real counter or
+ * counter list.
+ */
+#define          MAE_COUNTER_ID_NULL 0xffffffff
 
 /* TABLE_ID enum: Unique IDs for tables. The 32-bit ID values have been
  * structured with bits [31:24] reserved (0), [23:16] indicating which major
@@ -656,7 +667,9 @@
  * variations of the same table. (All of the tables currently defined within
  * the streaming engines are listed here, but this does not imply that they are
  * all supported - MC_CMD_TABLE_LIST returns the list of actually supported
- * tables.)
+ * tables.) The DPU offload engines' enumerators follow a deliberate pattern:
+ * 0x01010000 + is_dpu_net * 0x10000 + is_wr_or_tx * 0x8000 + is_lite_pipe *
+ * 0x1000 + oe_engine_type * 0x100 + oe_instance_within_pipe * 0x10
  */
 /* enum: Outer_Rule_Table in the MAE - refer to SF-123102-TC. */
 #define          TABLE_ID_OUTER_RULE_TABLE 0x10000
@@ -694,6 +707,70 @@
 #define          TABLE_ID_RSS_CONTEXT_TABLE 0x20200
 /* enum: Indirection_Table in VNIC Rx - refer to SF-123102-TC. */
 #define          TABLE_ID_INDIRECTION_TABLE 0x20300
+/* enum: DPU.host read pipe first CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_HOST_RD_CRC0_OE_PROFILE 0x1010000
+/* enum: DPU.host read pipe second CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_HOST_RD_CRC1_OE_PROFILE 0x1010010
+/* enum: DPU.host write pipe first CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_HOST_WR_CRC0_OE_PROFILE 0x1018000
+/* enum: DPU.host write pipe second CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_HOST_WR_CRC1_OE_PROFILE 0x1018010
+/* enum: DPU.net 'full' receive pipe CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RX_CRC0_OE_PROFILE 0x1020000
+/* enum: DPU.net 'full' receive pipe first checksum offload engine profiles -
+ * refer to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RX_CSUM0_OE_PROFILE 0x1020100
+/* enum: DPU.net 'full' receive pipe second checksum offload engine profiles -
+ * refer to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RX_CSUM1_OE_PROFILE 0x1020110
+/* enum: DPU.net 'full' receive pipe AES-GCM offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RX_AES_GCM0_OE_PROFILE 0x1020200
+/* enum: DPU.net 'lite' receive pipe CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RXLITE_CRC0_OE_PROFILE 0x1021000
+/* enum: DPU.net 'lite' receive pipe checksum offload engine profiles - refer
+ * to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_RXLITE_CSUM0_OE_PROFILE 0x1021100
+/* enum: DPU.net 'full' transmit pipe CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TX_CRC0_OE_PROFILE 0x1028000
+/* enum: DPU.net 'full' transmit pipe first checksum offload engine profiles -
+ * refer to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TX_CSUM0_OE_PROFILE 0x1028100
+/* enum: DPU.net 'full' transmit pipe second checksum offload engine profiles -
+ * refer to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TX_CSUM1_OE_PROFILE 0x1028110
+/* enum: DPU.net 'full' transmit pipe AES-GCM offload engine profiles - refer
+ * to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TX_AES_GCM0_OE_PROFILE 0x1028200
+/* enum: DPU.net 'lite' transmit pipe CRC offload engine profiles - refer to
+ * XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TXLITE_CRC0_OE_PROFILE 0x1029000
+/* enum: DPU.net 'lite' transmit pipe checksum offload engine profiles - refer
+ * to XN-200147-AN.
+ */
+#define          TABLE_ID_DPU_NET_TXLITE_CSUM0_OE_PROFILE 0x1029100
 
 /* TABLE_COMPRESSED_VLAN enum: Compressed VLAN TPID as used by some field
  * types; can be calculated by (((ether_type_msb >> 2) & 0x4) ^ 0x4) |
@@ -734,6 +811,42 @@
 /* enum: RSS uses even spreading calculation. */
 #define          TABLE_RSS_SPREAD_MODE_EVEN 0x1
 
+/* CRC_VARIANT enum: Operation for the DPU CRC engine to perform. */
+/* enum: Calculate a 32-bit CRC. */
+#define          CRC_VARIANT_CRC32 0x1
+/* enum: Calculate a 64-bit CRC. */
+#define          CRC_VARIANT_CRC64 0x2
+
+/* DPU_CSUM_OP enum: Operation for the DPU checksum engine to perform. */
+/* enum: Calculate the checksum for a TCP payload, output result on OPR bus. */
+#define          DPU_CSUM_OP_CALC_TCP 0x0
+/* enum: Calculate the checksum for a UDP payload, output result on OPR bus. */
+#define          DPU_CSUM_OP_CALC_UDP 0x1
+/* enum: Calculate the checksum for a TCP payload, output match/not match value
+ * on OPR bus.
+ */
+#define          DPU_CSUM_OP_VALIDATE_TCP 0x2
+/* enum: Calculate the checksum for a UDP payload, output match/not match value
+ * on OPR bus.
+ */
+#define          DPU_CSUM_OP_VALIDATE_UDP 0x3
+
+/* GCM_OP_CODE enum: Operation for the DPU AES-GCM engine to perform. */
+/* enum: Encrypt/decrypt a stream of data. */
+#define          GCM_OP_CODE_BULK_CRYPT 0x0
+/* enum: Calculate the authentication tag for a stream of data. */
+#define          GCM_OP_CODE_BULK_AUTH 0x1
+/* enum: Encrypt/decrypt an IPsec packet. */
+#define          GCM_OP_CODE_IPSEC_CRYPT 0x2
+/* enum: Calculate the authentication tag of an IPsec packet. */
+#define          GCM_OP_CODE_IPSEC_AUTH 0x3
+
+/* AES_KEY_LEN enum: Key size for AES crypto operations */
+/* enum: 128 bit key size. */
+#define          AES_KEY_LEN_AES_KEY_128 0x0
+/* enum: 256 bit key size. */
+#define          AES_KEY_LEN_AES_KEY_256 0x1
+
 /* TABLE_FIELD_ID enum: Unique IDs for fields. Related concepts have been
  * loosely grouped together into blocks with gaps for expansion, but the values
  * are arbitrary. Field IDs are not specific to particular tables, and in some
@@ -1026,6 +1139,16 @@
 #define          TABLE_FIELD_ID_BAL_TBL_BASE_DIV64 0xde
 /* enum: Length of balance table region: 0=>64, 1=>128, 2=>256. */
 #define          TABLE_FIELD_ID_BAL_TBL_LEN_ID 0xdf
+/* enum: LACP LAG ID (i.e. the low 3 bits of LACP LAG mport ID), indexing
+ * LACP_LAG_Config_Table. Refer to SF-123102-TC.
+ */
+#define          TABLE_FIELD_ID_LACP_LAG_ID 0xe0
+/* enum: Address in LACP_Balance_Table. The balance table is partitioned
+ * between LAGs according to the settings in LACP_LAG_Config_Table and then
+ * indexed by the LACP hash, providing the mapping to destination mports. Refer
+ * to SF-123102-TC.
+ */
+#define          TABLE_FIELD_ID_BAL_TBL_ADDR 0xe1
 /* enum: UDP port to match for UDP-based encapsulations; required to be 0 for
  * other encapsulation types.
  */
@@ -1082,6 +1205,58 @@
 #define          TABLE_FIELD_ID_INDIR_TBL_LEN_ID 0x105
 /* enum: An offset to be applied to the base destination queue ID. */
 #define          TABLE_FIELD_ID_INDIR_OFFSET 0x106
+/* enum: DPU offload engine profile ID to address. */
+#define          TABLE_FIELD_ID_OE_PROFILE 0x3e8
+/* enum: Width of the CRC to calculate - see CRC_VARIANT enum. */
+#define          TABLE_FIELD_ID_CRC_VARIANT 0x3f2
+/* enum: If set, reflect the bits of each input byte, bit 7 is LSB, bit 0 is
+ * MSB. If clear, bit 7 is MSB, bit 0 is LSB.
+ */
+#define          TABLE_FIELD_ID_CRC_REFIN 0x3f3
+/* enum: If set, reflect the bits of each output byte, bit 7 is LSB, bit 0 is
+ * MSB. If clear, bit 7 is MSB, bit 0 is LSB.
+ */
+#define          TABLE_FIELD_ID_CRC_REFOUT 0x3f4
+/* enum: If set, invert every bit of the output value. */
+#define          TABLE_FIELD_ID_CRC_INVOUT 0x3f5
+/* enum: The CRC polynomial to use for checksumming, in normal form. See
+ * https://en.wikipedia.org/wiki/Cyclic_redundancy_check#Specification for a
+ * description of normal form.
+ */
+#define          TABLE_FIELD_ID_CRC_POLY 0x3f6
+/* enum: Operation for the checksum engine to perform - see DPU_CSUM_OP enum.
+ */
+#define          TABLE_FIELD_ID_CSUM_OP 0x410
+/* enum: Byte offset of checksum relative to region_start (for VALIDATE_*
+ * operations only).
+ */
+#define          TABLE_FIELD_ID_CSUM_OFFSET 0x411
+/* enum: Indicates there is additional data on OPR bus that needs to be
+ * incorporated into the payload checksum.
+ */
+#define          TABLE_FIELD_ID_CSUM_OPR_ADDITIONAL_DATA 0x412
+/* enum: Log2 data size of additional data on OPR bus. */
+#define          TABLE_FIELD_ID_CSUM_OPR_DATA_SIZE_LOG2 0x413
+/* enum: 4 byte offset of where to find the additional data on the OPR bus. */
+#define          TABLE_FIELD_ID_CSUM_OPR_4B_OFF 0x414
+/* enum: Operation type for the AES-GCM core - see GCM_OP_CODE enum. */
+#define          TABLE_FIELD_ID_GCM_OP_CODE 0x41a
+/* enum: Key length - AES_KEY_LEN enum. */
+#define          TABLE_FIELD_ID_GCM_KEY_LEN 0x41b
+/* enum: OPR 4 byte offset for ICV or GHASH output (only in BULK_* mode) or
+ * IPSEC descrypt output.
+ */
+#define          TABLE_FIELD_ID_GCM_OPR_4B_OFFSET 0x41c
+/* enum: If OP_CODE is BULK_*, indicates Emit GHASH (Fragment mode). Else,
+ * indicates IPSEC-ESN mode.
+ */
+#define          TABLE_FIELD_ID_GCM_EMIT_GHASH_ISESN 0x41d
+/* enum: Replay Protection Enable. */
+#define          TABLE_FIELD_ID_GCM_REPLAY_PROTECT_EN 0x41e
+/* enum: IPSEC Encrypt ESP trailer NEXT_HEADER byte. */
+#define          TABLE_FIELD_ID_GCM_NEXT_HDR 0x41f
+/* enum: Replay Window Size. */
+#define          TABLE_FIELD_ID_GCM_REPLAY_WIN_SIZE 0x420
 
 /* MCDI_EVENT structuredef: The structure of an MCDI_EVENT on Siena/EF10/EF100
  * platforms
@@ -1237,7 +1412,7 @@
 #define          MCDI_EVENT_AOE_FPGA_LOAD_FAILED 0xe
 /* enum: Notify that invalid flash type detected */
 #define          MCDI_EVENT_AOE_INVALID_FPGA_FLASH_TYPE 0xf
-/* enum: Notify that the attempt to run FPGA Controller firmware timedout */
+/* enum: Notify that the attempt to run FPGA Controller firmware timed out */
 #define          MCDI_EVENT_AOE_FC_RUN_TIMEDOUT 0x10
 /* enum: Failure to probe one or more FPGA boot flash chips */
 #define          MCDI_EVENT_AOE_FPGA_BOOT_FLASH_INVALID 0x11
@@ -1255,7 +1430,7 @@
 #define        MCDI_EVENT_AOE_ERR_FC_ASSERT_INFO_WIDTH 8
 /* enum: FC Assert happened, but the register information is not available */
 #define          MCDI_EVENT_AOE_ERR_FC_ASSERT_SEEN 0x0
-/* enum: The register information for FC Assert is ready for readinng by driver
+/* enum: The register information for FC Assert is ready for reading by driver
  */
 #define          MCDI_EVENT_AOE_ERR_FC_ASSERT_DATA_READY 0x1
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_HEADER_VERIFY_FAILED_OFST 0
@@ -1364,6 +1539,12 @@
 #define        MCDI_EVENT_MODULECHANGE_SEQ_OFST 0
 #define        MCDI_EVENT_MODULECHANGE_SEQ_LBN 30
 #define        MCDI_EVENT_MODULECHANGE_SEQ_WIDTH 2
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_VI_ID_OFST 0
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_VI_ID_LBN 0
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_VI_ID_WIDTH 16
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_ID_OFST 0
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_ID_LBN 16
+#define        MCDI_EVENT_DESC_PROXY_VIRTQ_ID_WIDTH 16
 #define       MCDI_EVENT_DATA_LBN 0
 #define       MCDI_EVENT_DATA_WIDTH 32
 /* Alias for PTP_DATA. */
@@ -1500,6 +1681,12 @@
  * change to the journal.
  */
 #define          MCDI_EVENT_CODE_MPORT_JOURNAL_CHANGE 0x27
+/* enum: Notification that a source queue is enabled and attached to its proxy
+ * sink queue. SRC field contains the handle of the affected descriptor proxy
+ * function. DATA field contains the relative source queue number and absolute
+ * VI ID.
+ */
+#define          MCDI_EVENT_CODE_DESC_PROXY_FUNC_QUEUE_START 0x28
 /* enum: Artificial event generated by host and posted via MC for test
  * purposes.
  */
@@ -1977,7 +2164,7 @@
 #define MC_CMD_COPYCODE 0x3
 #undef MC_CMD_0x3_PRIVILEGE_CTG
 
-#define MC_CMD_0x3_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x3_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_COPYCODE_IN msgrequest */
 #define    MC_CMD_COPYCODE_IN_LEN 16
@@ -3943,11 +4130,15 @@
 /***********************************/
 /* MC_CMD_CSR_READ32
  * Read 32bit words from the indirect memory map.
+ *
+ * Note - this command originally belonged to INSECURE category. But access is
+ * required to specific registers for customer diagnostics. The command handler
+ * has additional checks to reject insecure calls.
  */
 #define MC_CMD_CSR_READ32 0xc
 #undef MC_CMD_0xc_PRIVILEGE_CTG
 
-#define MC_CMD_0xc_PRIVILEGE_CTG SRIOV_CTG_INSECURE
+#define MC_CMD_0xc_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_CSR_READ32_IN msgrequest */
 #define    MC_CMD_CSR_READ32_IN_LEN 12
@@ -4013,7 +4204,7 @@
 #define MC_CMD_HP 0x54
 #undef MC_CMD_0x54_PRIVILEGE_CTG
 
-#define MC_CMD_0x54_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x54_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_HP_IN msgrequest */
 #define    MC_CMD_HP_IN_LEN 16
@@ -4931,6 +5122,53 @@
 /* MC_CMD_GET_PHY_CFG_IN msgrequest */
 #define    MC_CMD_GET_PHY_CFG_IN_LEN 0
 
+/* MC_CMD_GET_PHY_CFG_IN_V2 msgrequest */
+#define    MC_CMD_GET_PHY_CFG_IN_V2_LEN 8
+/* Target port to request PHY state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details
+ */
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LEN 8
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LO_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LO_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LO_LBN 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_HI_OFST 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_HI_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_HI_LBN 32
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_HI_WIDTH 32
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FLAT_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_TYPE_OFST 3
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 20
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 16
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 2
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LINK_END_OFST 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_LINK_END_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_LEN 8
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_LO_OFST 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_LO_LBN 0
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_HI_OFST 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_HI_LBN 32
+#define       MC_CMD_GET_PHY_CFG_IN_V2_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_GET_PHY_CFG_OUT msgresponse */
 #define    MC_CMD_GET_PHY_CFG_OUT_LEN 72
 /* flags */
@@ -5026,6 +5264,9 @@
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_OFST 8
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN 21
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_WIDTH 1
+#define        MC_CMD_PHY_CAP_200000FDX_OFST 8
+#define        MC_CMD_PHY_CAP_200000FDX_LBN 22
+#define        MC_CMD_PHY_CAP_200000FDX_WIDTH 1
 /* ?? */
 #define       MC_CMD_GET_PHY_CFG_OUT_CHANNEL_OFST 12
 #define       MC_CMD_GET_PHY_CFG_OUT_CHANNEL_LEN 4
@@ -5084,7 +5325,7 @@
 #define MC_CMD_START_BIST 0x25
 #undef MC_CMD_0x25_PRIVILEGE_CTG
 
-#define MC_CMD_0x25_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x25_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_START_BIST_IN msgrequest */
 #define    MC_CMD_START_BIST_IN_LEN 4
@@ -5124,7 +5365,7 @@
 #define MC_CMD_POLL_BIST 0x26
 #undef MC_CMD_0x26_PRIVILEGE_CTG
 
-#define MC_CMD_0x26_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x26_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_POLL_BIST_IN msgrequest */
 #define    MC_CMD_POLL_BIST_IN_LEN 0
@@ -5320,6 +5561,53 @@
 /* MC_CMD_GET_LOOPBACK_MODES_IN msgrequest */
 #define    MC_CMD_GET_LOOPBACK_MODES_IN_LEN 0
 
+/* MC_CMD_GET_LOOPBACK_MODES_IN_V2 msgrequest */
+#define    MC_CMD_GET_LOOPBACK_MODES_IN_V2_LEN 8
+/* Target port to request loopback modes for. Uses MAE_LINK_ENDPOINT_SELECTOR
+ * which identifies a real or virtual network port by MAE port and link end.
+ * See the structure definition for more details
+ */
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LO_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LO_LBN 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_HI_OFST 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_HI_LBN 32
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_HI_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FLAT_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_TYPE_OFST 3
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 20
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 16
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 2
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LINK_END_OFST 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_LINK_END_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_LO_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_LO_LBN 0
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_HI_OFST 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_HI_LBN 32
+#define       MC_CMD_GET_LOOPBACK_MODES_IN_V2_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_GET_LOOPBACK_MODES_OUT msgresponse */
 #define    MC_CMD_GET_LOOPBACK_MODES_OUT_LEN 40
 /* Supported loopbacks. */
@@ -5649,6 +5937,204 @@
 /*            Enum values, see field(s): */
 /*               100M */
 
+/* MC_CMD_GET_LOOPBACK_MODES_OUT_V3 msgresponse: Supported loopback modes for
+ * newer NICs with 200G support
+ */
+#define    MC_CMD_GET_LOOPBACK_MODES_OUT_V3_LEN 72
+/* Supported loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_LO_OFST 0
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_LO_LBN 0
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_HI_OFST 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_HI_LBN 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100M_HI_WIDTH 32
+/* enum: None. */
+/*               MC_CMD_LOOPBACK_NONE 0x0 */
+/* enum: Data. */
+/*               MC_CMD_LOOPBACK_DATA 0x1 */
+/* enum: GMAC. */
+/*               MC_CMD_LOOPBACK_GMAC 0x2 */
+/* enum: XGMII. */
+/*               MC_CMD_LOOPBACK_XGMII 0x3 */
+/* enum: XGXS. */
+/*               MC_CMD_LOOPBACK_XGXS 0x4 */
+/* enum: XAUI. */
+/*               MC_CMD_LOOPBACK_XAUI 0x5 */
+/* enum: GMII. */
+/*               MC_CMD_LOOPBACK_GMII 0x6 */
+/* enum: SGMII. */
+/*               MC_CMD_LOOPBACK_SGMII 0x7 */
+/* enum: XGBR. */
+/*               MC_CMD_LOOPBACK_XGBR 0x8 */
+/* enum: XFI. */
+/*               MC_CMD_LOOPBACK_XFI 0x9 */
+/* enum: XAUI Far. */
+/*               MC_CMD_LOOPBACK_XAUI_FAR 0xa */
+/* enum: GMII Far. */
+/*               MC_CMD_LOOPBACK_GMII_FAR 0xb */
+/* enum: SGMII Far. */
+/*               MC_CMD_LOOPBACK_SGMII_FAR 0xc */
+/* enum: XFI Far. */
+/*               MC_CMD_LOOPBACK_XFI_FAR 0xd */
+/* enum: GPhy. */
+/*               MC_CMD_LOOPBACK_GPHY 0xe */
+/* enum: PhyXS. */
+/*               MC_CMD_LOOPBACK_PHYXS 0xf */
+/* enum: PCS. */
+/*               MC_CMD_LOOPBACK_PCS 0x10 */
+/* enum: PMA-PMD. */
+/*               MC_CMD_LOOPBACK_PMAPMD 0x11 */
+/* enum: Cross-Port. */
+/*               MC_CMD_LOOPBACK_XPORT 0x12 */
+/* enum: XGMII-Wireside. */
+/*               MC_CMD_LOOPBACK_XGMII_WS 0x13 */
+/* enum: XAUI Wireside. */
+/*               MC_CMD_LOOPBACK_XAUI_WS 0x14 */
+/* enum: XAUI Wireside Far. */
+/*               MC_CMD_LOOPBACK_XAUI_WS_FAR 0x15 */
+/* enum: XAUI Wireside near. */
+/*               MC_CMD_LOOPBACK_XAUI_WS_NEAR 0x16 */
+/* enum: GMII Wireside. */
+/*               MC_CMD_LOOPBACK_GMII_WS 0x17 */
+/* enum: XFI Wireside. */
+/*               MC_CMD_LOOPBACK_XFI_WS 0x18 */
+/* enum: XFI Wireside Far. */
+/*               MC_CMD_LOOPBACK_XFI_WS_FAR 0x19 */
+/* enum: PhyXS Wireside. */
+/*               MC_CMD_LOOPBACK_PHYXS_WS 0x1a */
+/* enum: PMA lanes MAC-Serdes. */
+/*               MC_CMD_LOOPBACK_PMA_INT 0x1b */
+/* enum: KR Serdes Parallel (Encoder). */
+/*               MC_CMD_LOOPBACK_SD_NEAR 0x1c */
+/* enum: KR Serdes Serial. */
+/*               MC_CMD_LOOPBACK_SD_FAR 0x1d */
+/* enum: PMA lanes MAC-Serdes Wireside. */
+/*               MC_CMD_LOOPBACK_PMA_INT_WS 0x1e */
+/* enum: KR Serdes Parallel Wireside (Full PCS). */
+/*               MC_CMD_LOOPBACK_SD_FEP2_WS 0x1f */
+/* enum: KR Serdes Parallel Wireside (Sym Aligner to TX). */
+/*               MC_CMD_LOOPBACK_SD_FEP1_5_WS 0x20 */
+/* enum: KR Serdes Parallel Wireside (Deserializer to Serializer). */
+/*               MC_CMD_LOOPBACK_SD_FEP_WS 0x21 */
+/* enum: KR Serdes Serial Wireside. */
+/*               MC_CMD_LOOPBACK_SD_FES_WS 0x22 */
+/* enum: Near side of AOE Siena side port */
+/*               MC_CMD_LOOPBACK_AOE_INT_NEAR 0x23 */
+/* enum: Medford Wireside datapath loopback */
+/*               MC_CMD_LOOPBACK_DATA_WS 0x24 */
+/* enum: Force link up without setting up any physical loopback (snapper use
+ * only)
+ */
+/*               MC_CMD_LOOPBACK_FORCE_EXT_LINK 0x25 */
+/* Supported loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_OFST 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_LO_OFST 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_LO_LBN 64
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_HI_OFST 12
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_HI_LBN 96
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_1G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_OFST 16
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_LO_OFST 16
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_LO_LBN 128
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_HI_OFST 20
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_HI_LBN 160
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_10G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_OFST 24
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_LO_OFST 24
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_LO_LBN 192
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_HI_OFST 28
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_HI_LBN 224
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_SUGGESTED_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_OFST 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_LO_OFST 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_LO_LBN 256
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_HI_OFST 36
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_HI_LBN 288
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_40G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported 25G loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_OFST 40
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_LO_OFST 40
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_LO_LBN 320
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_HI_OFST 44
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_HI_LBN 352
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_25G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported 50 loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_OFST 48
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_LO_OFST 48
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_LO_LBN 384
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_HI_OFST 52
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_HI_LBN 416
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_50G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported 100G loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_OFST 56
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_LO_OFST 56
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_LO_LBN 448
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_HI_OFST 60
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_HI_LBN 480
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_100G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+/* Supported 200G loopbacks. */
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_OFST 64
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_LEN 8
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_LO_OFST 64
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_LO_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_LO_LBN 512
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_LO_WIDTH 32
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_HI_OFST 68
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_HI_LEN 4
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_HI_LBN 544
+#define       MC_CMD_GET_LOOPBACK_MODES_OUT_V3_200G_HI_WIDTH 32
+/*            Enum values, see field(s): */
+/*               100M */
+
 /* AN_TYPE structuredef: Auto-negotiation types defined in IEEE802.3 */
 #define    AN_TYPE_LEN 4
 #define       AN_TYPE_TYPE_OFST 0
@@ -5694,6 +6180,53 @@
 /* MC_CMD_GET_LINK_IN msgrequest */
 #define    MC_CMD_GET_LINK_IN_LEN 0
 
+/* MC_CMD_GET_LINK_IN_V2 msgrequest */
+#define    MC_CMD_GET_LINK_IN_V2_LEN 8
+/* Target port to request link state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details.
+ */
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LEN 8
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LO_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LO_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LO_LBN 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LO_WIDTH 32
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_HI_OFST 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_HI_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_HI_LBN 32
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_HI_WIDTH 32
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FLAT_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_TYPE_OFST 3
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 20
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 16
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 2
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LINK_END_OFST 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_LINK_END_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_LEN 8
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_LO_OFST 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_LO_LBN 0
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_HI_OFST 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_HI_LBN 32
+#define       MC_CMD_GET_LINK_IN_V2_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_GET_LINK_OUT msgresponse */
 #define    MC_CMD_GET_LINK_OUT_LEN 28
 /* Near-side advertised capabilities. Refer to
@@ -5969,6 +6502,94 @@
 #define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_LBN 7
 #define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_WIDTH 1
 
+/* MC_CMD_SET_LINK_IN_V3 msgrequest */
+#define    MC_CMD_SET_LINK_IN_V3_LEN 28
+/* Near-side advertised capabilities. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define       MC_CMD_SET_LINK_IN_V3_CAP_OFST 0
+#define       MC_CMD_SET_LINK_IN_V3_CAP_LEN 4
+/* Flags */
+#define       MC_CMD_SET_LINK_IN_V3_FLAGS_OFST 4
+#define       MC_CMD_SET_LINK_IN_V3_FLAGS_LEN 4
+#define        MC_CMD_SET_LINK_IN_V3_LOWPOWER_OFST 4
+#define        MC_CMD_SET_LINK_IN_V3_LOWPOWER_LBN 0
+#define        MC_CMD_SET_LINK_IN_V3_LOWPOWER_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V3_POWEROFF_OFST 4
+#define        MC_CMD_SET_LINK_IN_V3_POWEROFF_LBN 1
+#define        MC_CMD_SET_LINK_IN_V3_POWEROFF_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V3_TXDIS_OFST 4
+#define        MC_CMD_SET_LINK_IN_V3_TXDIS_LBN 2
+#define        MC_CMD_SET_LINK_IN_V3_TXDIS_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V3_LINKDOWN_OFST 4
+#define        MC_CMD_SET_LINK_IN_V3_LINKDOWN_LBN 3
+#define        MC_CMD_SET_LINK_IN_V3_LINKDOWN_WIDTH 1
+/* Loopback mode. */
+#define       MC_CMD_SET_LINK_IN_V3_LOOPBACK_MODE_OFST 8
+#define       MC_CMD_SET_LINK_IN_V3_LOOPBACK_MODE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
+/* A loopback speed of "0" is supported, and means (choose any available
+ * speed).
+ */
+#define       MC_CMD_SET_LINK_IN_V3_LOOPBACK_SPEED_OFST 12
+#define       MC_CMD_SET_LINK_IN_V3_LOOPBACK_SPEED_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_OFST 16
+#define       MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_LEN 1
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_NUMBER_OFST 16
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_NUMBER_LBN 0
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_NUMBER_WIDTH 7
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_IGNORE_OFST 16
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_IGNORE_LBN 7
+#define        MC_CMD_SET_LINK_IN_V3_MODULE_SEQ_IGNORE_WIDTH 1
+/* Padding */
+#define       MC_CMD_SET_LINK_IN_V3_RESERVED_OFST 17
+#define       MC_CMD_SET_LINK_IN_V3_RESERVED_LEN 3
+/* Target port to set link state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details
+ */
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LEN 8
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LO_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LO_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LO_LBN 160
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LO_WIDTH 32
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_HI_OFST 24
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_HI_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_HI_LBN 192
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_HI_WIDTH 32
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FLAT_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_TYPE_OFST 23
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 160
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 180
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 176
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 22
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LINK_END_OFST 24
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_LINK_END_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_LEN 8
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_LO_OFST 20
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_LO_LBN 160
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_HI_OFST 24
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_HI_LBN 192
+#define       MC_CMD_SET_LINK_IN_V3_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_SET_LINK_OUT msgresponse */
 #define    MC_CMD_SET_LINK_OUT_LEN 0
 
@@ -6188,19 +6809,9 @@
 #define        MC_CMD_SET_MAC_V3_IN_CFG_FCS_OFST 28
 #define        MC_CMD_SET_MAC_V3_IN_CFG_FCS_LBN 4
 #define        MC_CMD_SET_MAC_V3_IN_CFG_FCS_WIDTH 1
-/* Identifies the MAC to update by the specifying the end of a logical MAE
- * link. Setting TARGET to MAE_LINK_ENDPOINT_COMPAT is equivalent to using the
- * previous version of the command (MC_CMD_SET_MAC_EXT). Not all possible
- * combinations of MPORT_END and MPORT_SELECTOR in TARGET will work in all
- * circumstances. 1. Some will always work (e.g. a VF can always address its
- * logical MAC using MPORT_SELECTOR=ASSIGNED,LINK_END=VNIC), 2. Some are not
- * meaningful and will always fail with EINVAL (e.g. attempting to address the
- * VNIC end of a link to a physical port), 3. Some are meaningful but require
- * the MCDI client to have the required permission and fail with EPERM
- * otherwise (e.g. trying to set the MAC on a VF the caller cannot administer),
- * and 4. Some could be implementation-specific and fail with ENOTSUP if not
- * available (no examples exist right now). See SF-123581-TC section 4.3 for
- * more details.
+/* Target port to set mac state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details
  */
 #define       MC_CMD_SET_MAC_V3_IN_TARGET_OFST 32
 #define       MC_CMD_SET_MAC_V3_IN_TARGET_LEN 8
@@ -6405,6 +7016,97 @@
 #define       MC_CMD_MAC_STATS_IN_PORT_ID_OFST 16
 #define       MC_CMD_MAC_STATS_IN_PORT_ID_LEN 4
 
+/* MC_CMD_MAC_STATS_V2_IN msgrequest */
+#define    MC_CMD_MAC_STATS_V2_IN_LEN 28
+/* ??? */
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_OFST 0
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_LEN 8
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_LO_OFST 0
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_LO_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_LO_LBN 0
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_LO_WIDTH 32
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_HI_OFST 4
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_HI_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_HI_LBN 32
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_ADDR_HI_WIDTH 32
+#define       MC_CMD_MAC_STATS_V2_IN_CMD_OFST 8
+#define       MC_CMD_MAC_STATS_V2_IN_CMD_LEN 4
+#define        MC_CMD_MAC_STATS_V2_IN_DMA_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_DMA_LBN 0
+#define        MC_CMD_MAC_STATS_V2_IN_DMA_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_CLEAR_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_CLEAR_LBN 1
+#define        MC_CMD_MAC_STATS_V2_IN_CLEAR_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CHANGE_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CHANGE_LBN 2
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CHANGE_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_ENABLE_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_ENABLE_LBN 3
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_ENABLE_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CLEAR_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CLEAR_LBN 4
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_CLEAR_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_NOEVENT_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_NOEVENT_LBN 5
+#define        MC_CMD_MAC_STATS_V2_IN_PERIODIC_NOEVENT_WIDTH 1
+#define        MC_CMD_MAC_STATS_V2_IN_PERIOD_MS_OFST 8
+#define        MC_CMD_MAC_STATS_V2_IN_PERIOD_MS_LBN 16
+#define        MC_CMD_MAC_STATS_V2_IN_PERIOD_MS_WIDTH 16
+/* DMA length. Should be set to MAC_STATS_NUM_STATS * sizeof(uint64_t), as
+ * returned by MC_CMD_GET_CAPABILITIES_V4_OUT. For legacy firmware not
+ * supporting MC_CMD_GET_CAPABILITIES_V4_OUT, DMA_LEN should be set to
+ * MC_CMD_MAC_NSTATS * sizeof(uint64_t)
+ */
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_LEN_OFST 12
+#define       MC_CMD_MAC_STATS_V2_IN_DMA_LEN_LEN 4
+/* port id so vadapter stats can be provided */
+#define       MC_CMD_MAC_STATS_V2_IN_PORT_ID_OFST 16
+#define       MC_CMD_MAC_STATS_V2_IN_PORT_ID_LEN 4
+/* Target port to request statistics for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details
+ */
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LEN 8
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LO_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LO_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LO_LBN 160
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LO_WIDTH 32
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_HI_OFST 24
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_HI_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_HI_LBN 192
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_HI_WIDTH 32
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FLAT_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_TYPE_OFST 23
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 160
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 180
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 176
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 22
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LINK_END_OFST 24
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_LINK_END_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_LEN 8
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_LO_OFST 20
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_LO_LBN 160
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_HI_OFST 24
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_HI_LBN 192
+#define       MC_CMD_MAC_STATS_V2_IN_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_MAC_STATS_OUT_DMA msgresponse */
 #define    MC_CMD_MAC_STATS_OUT_DMA_LEN 0
 
@@ -7522,7 +8224,7 @@
 #define MC_CMD_REBOOT 0x3d
 #undef MC_CMD_0x3d_PRIVILEGE_CTG
 
-#define MC_CMD_0x3d_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x3d_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_REBOOT_IN msgrequest */
 #define    MC_CMD_REBOOT_IN_LEN 4
@@ -8061,6 +8763,53 @@
 /* MC_CMD_GET_PHY_STATE_IN msgrequest */
 #define    MC_CMD_GET_PHY_STATE_IN_LEN 0
 
+/* MC_CMD_GET_PHY_STATE_IN_V2 msgrequest */
+#define    MC_CMD_GET_PHY_STATE_IN_V2_LEN 8
+/* Target port to request PHY state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details.
+ */
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LEN 8
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LO_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LO_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LO_LBN 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_HI_OFST 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_HI_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_HI_LBN 32
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_HI_WIDTH 32
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FLAT_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_TYPE_OFST 3
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 20
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 16
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 2
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LINK_END_OFST 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_LINK_END_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_LEN 8
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_LO_OFST 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_LO_LBN 0
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_HI_OFST 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_HI_LBN 32
+#define       MC_CMD_GET_PHY_STATE_IN_V2_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_GET_PHY_STATE_OUT msgresponse */
 #define    MC_CMD_GET_PHY_STATE_OUT_LEN 4
 #define       MC_CMD_GET_PHY_STATE_OUT_STATE_OFST 0
@@ -8200,7 +8949,7 @@
 #define MC_CMD_TESTASSERT 0x49
 #undef MC_CMD_0x49_PRIVILEGE_CTG
 
-#define MC_CMD_0x49_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x49_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_TESTASSERT_IN msgrequest */
 #define    MC_CMD_TESTASSERT_IN_LEN 0
@@ -8324,6 +9073,61 @@
 #define        MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_BANK_LBN 16
 #define        MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_BANK_WIDTH 16
 
+/* MC_CMD_GET_PHY_MEDIA_INFO_IN_V2 msgrequest */
+#define    MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_LEN 12
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_PAGE_OFST 0
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_PAGE_LEN 4
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_PAGE_OFST 0
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_PAGE_LBN 0
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_PAGE_WIDTH 16
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_BANK_OFST 0
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_BANK_LBN 16
+#define        MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_DSFP_BANK_WIDTH 16
+/* Target port to request PHY state for. Uses MAE_LINK_ENDPOINT_SELECTOR which
+ * identifies a real or virtual network port by MAE port and link end. See the
+ * structure definition for more details
+ */
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LEN 8
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LO_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LO_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LO_LBN 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_HI_OFST 8
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_HI_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_HI_LBN 64
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_HI_WIDTH 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FLAT_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_TYPE_OFST 7
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 52
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 48
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 6
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LINK_END_OFST 8
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_LINK_END_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_LEN 8
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_LO_OFST 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_LO_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_LO_LBN 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_LO_WIDTH 32
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_HI_OFST 8
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_HI_LEN 4
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_HI_LBN 64
+#define       MC_CMD_GET_PHY_MEDIA_INFO_IN_V2_TARGET_FLAT_HI_WIDTH 32
+
 /* MC_CMD_GET_PHY_MEDIA_INFO_OUT msgresponse */
 #define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMIN 5
 #define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX 252
@@ -8348,7 +9152,7 @@
 #define MC_CMD_NVRAM_TEST 0x4c
 #undef MC_CMD_0x4c_PRIVILEGE_CTG
 
-#define MC_CMD_0x4c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x4c_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_NVRAM_TEST_IN msgrequest */
 #define    MC_CMD_NVRAM_TEST_IN_LEN 4
@@ -8593,7 +9397,7 @@
 #define MC_CMD_CLP 0x56
 #undef MC_CMD_0x56_PRIVILEGE_CTG
 
-#define MC_CMD_0x56_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x56_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_CLP_IN msgrequest */
 #define    MC_CMD_CLP_IN_LEN 4
@@ -9500,27 +10304,22 @@
  * and a generation count for this version of the sensor table. On systems
  * advertising the DYNAMIC_SENSORS capability bit, this replaces the
  * MC_CMD_READ_SENSORS command. On multi-MC systems this may include sensors
- * added by the NMC.
- *
- * Sensor handles are persistent for the lifetime of the sensor and are used to
- * identify sensors in MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS and
- * MC_CMD_DYNAMIC_SENSORS_GET_VALUES.
- *
- * The generation count is maintained by the MC, is persistent across reboots
- * and will be incremented each time the sensor table is modified. When the
- * table is modified, a CODE_DYNAMIC_SENSORS_CHANGE event will be generated
- * containing the new generation count. The driver should compare this against
- * the current generation count, and if it is different, call
- * MC_CMD_DYNAMIC_SENSORS_LIST again to update it's copy of the sensor table.
- *
- * The sensor count is provided to allow a future path to supporting more than
+ * added by the NMC. Sensor handles are persistent for the lifetime of the
+ * sensor and are used to identify sensors in
+ * MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS and
+ * MC_CMD_DYNAMIC_SENSORS_GET_VALUES. The generation count is maintained by the
+ * MC, is persistent across reboots and will be incremented each time the
+ * sensor table is modified. When the table is modified, a
+ * CODE_DYNAMIC_SENSORS_CHANGE event will be generated containing the new
+ * generation count. The driver should compare this against the current
+ * generation count, and if it is different, call MC_CMD_DYNAMIC_SENSORS_LIST
+ * again to update it's copy of the sensor table. The sensor count is provided
+ * to allow a future path to supporting more than
  * MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM_MCDI2 sensors, i.e.
  * the maximum number that will fit in a single response. As this is a fairly
  * large number (253) it is not anticipated that this will be needed in the
- * near future, so can currently be ignored.
- *
- * On Riverhead this command is implemented as a wrapper for `list` in the
- * sensor_query SPHINX service.
+ * near future, so can currently be ignored. On Riverhead this command is
+ * implemented as a wrapper for `list` in the sensor_query SPHINX service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_LIST 0x66
 #undef MC_CMD_0x66_PRIVILEGE_CTG
@@ -9557,15 +10356,13 @@
 /***********************************/
 /* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS
  * Get descriptions for a set of sensors, specified as an array of sensor
- * handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST
- *
- * Any handles which do not correspond to a sensor currently managed by the MC
- * will be dropped from from the response. This may happen when a sensor table
- * update is in progress, and effectively means the set of usable sensors is
- * the intersection between the sets of sensors known to the driver and the MC.
- *
- * On Riverhead this command is implemented as a wrapper for
- * `get_descriptions` in the sensor_query SPHINX service.
+ * handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST. Any handles which do not
+ * correspond to a sensor currently managed by the MC will be dropped from from
+ * the response. This may happen when a sensor table update is in progress, and
+ * effectively means the set of usable sensors is the intersection between the
+ * sets of sensors known to the driver and the MC. On Riverhead this command is
+ * implemented as a wrapper for `get_descriptions` in the sensor_query SPHINX
+ * service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS 0x67
 #undef MC_CMD_0x67_PRIVILEGE_CTG
@@ -9602,19 +10399,15 @@
 /***********************************/
 /* MC_CMD_DYNAMIC_SENSORS_GET_READINGS
  * Read the state and value for a set of sensors, specified as an array of
- * sensor handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST.
- *
- * In the case of a broken sensor, then the state of the response's
- * MC_CMD_DYNAMIC_SENSORS_VALUE entry will be set to BROKEN, and any value
- * provided should be treated as erroneous.
- *
- * Any handles which do not correspond to a sensor currently managed by the MC
- * will be dropped from from the response. This may happen when a sensor table
- * update is in progress, and effectively means the set of usable sensors is
- * the intersection between the sets of sensors known to the driver and the MC.
- *
- * On Riverhead this command is implemented as a wrapper for `get_readings`
- * in the sensor_query SPHINX service.
+ * sensor handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST. In the case of a
+ * broken sensor, then the state of the response's MC_CMD_DYNAMIC_SENSORS_VALUE
+ * entry will be set to BROKEN, and any value provided should be treated as
+ * erroneous. Any handles which do not correspond to a sensor currently managed
+ * by the MC will be dropped from from the response. This may happen when a
+ * sensor table update is in progress, and effectively means the set of usable
+ * sensors is the intersection between the sets of sensors known to the driver
+ * and the MC. On Riverhead this command is implemented as a wrapper for
+ * `get_readings` in the sensor_query SPHINX service.
  */
 #define MC_CMD_DYNAMIC_SENSORS_GET_READINGS 0x68
 #undef MC_CMD_0x68_PRIVILEGE_CTG
@@ -10212,6 +11005,42 @@
 #define       CTPIO_STATS_MAP_BUCKET_LBN 16
 #define       CTPIO_STATS_MAP_BUCKET_WIDTH 16
 
+/* MESSAGE_TYPE structuredef: When present this defines the meaning of a
+ * message, and is used to protect against chosen message attacks in signed
+ * messages, regardless their origin. The message type also defines the
+ * signature cryptographic algorithm, encoding, and message fields included in
+ * the signature. The values are used in different commands but must be unique
+ * across all commands, e.g. MC_CMD_TSA_BIND_IN_SECURE_UNBIND uses different
+ * message type than MC_CMD_SECURE_NIC_INFO_IN_STATUS.
+ */
+#define    MESSAGE_TYPE_LEN 4
+#define       MESSAGE_TYPE_MESSAGE_TYPE_OFST 0
+#define       MESSAGE_TYPE_MESSAGE_TYPE_LEN 4
+#define          MESSAGE_TYPE_UNUSED 0x0 /* enum */
+/* enum: Message type value for the response to a
+ * MC_CMD_TSA_BIND_IN_SECURE_UNBIND message. TSA_SECURE_UNBIND messages are
+ * ECDSA SECP384R1 signed using SHA384 message digest algorithm over fields
+ * MESSAGE_TYPE, TSANID, TSAID, and UNBINDTOKEN, and encoded as suggested by
+ * RFC6979 (section 2.4).
+ */
+#define          MESSAGE_TYPE_TSA_SECURE_UNBIND 0x1
+/* enum: Message type value for the response to a
+ * MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION message. TSA_SECURE_DECOMMISSION
+ * messages are ECDSA SECP384R1 signed using SHA384 message digest algorithm
+ * over fields MESSAGE_TYPE, TSAID, USER, and REASON, and encoded as suggested
+ * by RFC6979 (section 2.4).
+ */
+#define          MESSAGE_TYPE_TSA_SECURE_DECOMMISSION 0x2
+/* enum: Message type value for the response to a
+ * MC_CMD_SECURE_NIC_INFO_IN_STATUS message. This enum value is not sequential
+ * to other message types for backwards compatibility as the message type for
+ * MC_CMD_SECURE_NIC_INFO_IN_STATUS was defined before the existence of this
+ * global enum.
+ */
+#define          MESSAGE_TYPE_SECURE_NIC_INFO_STATUS 0xdb4
+#define       MESSAGE_TYPE_MESSAGE_TYPE_LBN 0
+#define       MESSAGE_TYPE_MESSAGE_TYPE_WIDTH 32
+
 
 /***********************************/
 /* MC_CMD_READ_REGS
@@ -12860,6 +13689,48 @@
 #define        MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_DST_IP_MCAST_ONLY_LBN 0
 #define        MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_DST_IP_MCAST_ONLY_WIDTH 1
 
+/* MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT msgresponse:
+ * GET_PARSER_DISP_INFO response format for OP_GET_SECURITY_RULE_INFO.
+ * (Medford-only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define    MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_LEN 36
+/* identifies the type of operation requested */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_OP_OFST 0
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_OP_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_PARSER_DISP_INFO_IN/OP */
+/* a version number representing the set of rule lookups that are implemented
+ * by the currently running firmware
+ */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_RULES_VERSION_OFST 4
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_RULES_VERSION_LEN 4
+/* enum: implements lookup sequences described in SF-114946-SW draft C */
+#define          MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_RULES_VERSION_SF_114946_SW_C 0x0
+/* the number of nodes in the subnet map */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_MAP_NUM_NODES_OFST 8
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_MAP_NUM_NODES_LEN 4
+/* the number of entries in one subnet map node */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_MAP_NUM_ENTRIES_PER_NODE_OFST 12
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_MAP_NUM_ENTRIES_PER_NODE_LEN 4
+/* minimum valid value for a subnet ID in a subnet map leaf */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_ID_MIN_OFST 16
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_ID_MIN_LEN 4
+/* maximum valid value for a subnet ID in a subnet map leaf */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_ID_MAX_OFST 20
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_SUBNET_ID_MAX_LEN 4
+/* the number of entries in the local and remote port range maps */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_TREE_NUM_ENTRIES_OFST 24
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_TREE_NUM_ENTRIES_LEN 4
+/* minimum valid value for a portrange ID in a port range map leaf */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_ID_MIN_OFST 28
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_ID_MIN_LEN 4
+/* maximum valid value for a portrange ID in a port range map leaf */
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_ID_MAX_OFST 32
+#define       MC_CMD_GET_PARSER_DISP_SECURITY_RULE_INFO_OUT_PORTRANGE_ID_MAX_LEN 4
+
 /* MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT msgresponse: This response is
  * returned if a MC_CMD_GET_PARSER_DISP_INFO_IN request is sent with OP value
  * OP_GET_SUPPORTED_VNIC_ENCAP_MATCHES. It contains information about the
@@ -13716,7 +14587,7 @@
 #define MC_CMD_SATELLITE_DOWNLOAD 0x91
 #undef MC_CMD_0x91_PRIVILEGE_CTG
 
-#define MC_CMD_0x91_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x91_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_SATELLITE_DOWNLOAD_IN msgrequest: The reset requirements for the CPUs
  * are subtle, and so downloads must proceed in a number of phases.
@@ -13835,10 +14706,9 @@
 
 /***********************************/
 /* MC_CMD_GET_CAPABILITIES
- * Get device capabilities.
- *
- * This is supplementary to the MC_CMD_GET_BOARD_CFG command, and intended to
- * reference inherent device capabilities as opposed to current NVRAM config.
+ * Get device capabilities. This is supplementary to the MC_CMD_GET_BOARD_CFG
+ * command, and intended to reference inherent device capabilities as opposed
+ * to current NVRAM config.
  */
 #define MC_CMD_GET_CAPABILITIES 0xbe
 #undef MC_CMD_0xbe_PRIVILEGE_CTG
@@ -16796,9 +17666,15 @@
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_STEER_ON_OUTER_SUPPORTED_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_STEER_ON_OUTER_SUPPORTED_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_STEER_ON_OUTER_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_WIDTH 1
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_MPORT_JOURNAL_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_MPORT_JOURNAL_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_MPORT_JOURNAL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CLIENT_CMD_VF_PROXY_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CLIENT_CMD_VF_PROXY_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CLIENT_CMD_VF_PROXY_WIDTH 1
 
 /* MC_CMD_GET_CAPABILITIES_V8_OUT msgresponse */
 #define    MC_CMD_GET_CAPABILITIES_V8_OUT_LEN 160
@@ -17300,9 +18176,15 @@
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_STEER_ON_OUTER_SUPPORTED_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_STEER_ON_OUTER_SUPPORTED_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_STEER_ON_OUTER_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_WIDTH 1
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_MPORT_JOURNAL_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_MPORT_JOURNAL_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_MPORT_JOURNAL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CLIENT_CMD_VF_PROXY_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CLIENT_CMD_VF_PROXY_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CLIENT_CMD_VF_PROXY_WIDTH 1
 /* These bits are reserved for communicating test-specific capabilities to
  * host-side test software. All production drivers should treat this field as
  * opaque.
@@ -17818,9 +18700,15 @@
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_STEER_ON_OUTER_SUPPORTED_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_STEER_ON_OUTER_SUPPORTED_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_STEER_ON_OUTER_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_WIDTH 1
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_MPORT_JOURNAL_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_MPORT_JOURNAL_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_MPORT_JOURNAL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CLIENT_CMD_VF_PROXY_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CLIENT_CMD_VF_PROXY_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CLIENT_CMD_VF_PROXY_WIDTH 1
 /* These bits are reserved for communicating test-specific capabilities to
  * host-side test software. All production drivers should treat this field as
  * opaque.
@@ -18371,9 +19259,15 @@
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V3_SUPPORTED_WIDTH 1
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_OFST 148
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_CLIENT_CMD_VF_PROXY_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_CLIENT_CMD_VF_PROXY_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V10_OUT_CLIENT_CMD_VF_PROXY_WIDTH 1
 /* These bits are reserved for communicating test-specific capabilities to
  * host-side test software. All production drivers should treat this field as
  * opaque.
@@ -18468,6 +19362,13 @@
  * are not defined.
  */
 #define          MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_TSA 0x1
+/* enum: MCDI command used for platform management. Typically, these commands
+ * are used for low-level operations directed at the platform as a whole (e.g.
+ * MMIO device enumeration) rather than individual functions and use a
+ * dedicated comms channel (e.g. RPmsg/IPI). May be handled by the same or
+ * different CPU as MCDI_MESSAGE_TYPE_MC.
+ */
+#define          MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_PLATFORM 0x2
 
 
 /***********************************/
@@ -20179,7 +21080,7 @@
 #define MC_CMD_SHMBOOT_OP 0xe6
 #undef MC_CMD_0xe6_PRIVILEGE_CTG
 
-#define MC_CMD_0xe6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0xe6_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_SHMBOOT_OP_IN msgrequest */
 #define    MC_CMD_SHMBOOT_OP_IN_LEN 4
@@ -20448,7 +21349,7 @@
 #define MC_CMD_ENABLE_OFFLINE_BIST 0xed
 #undef MC_CMD_0xed_PRIVILEGE_CTG
 
-#define MC_CMD_0xed_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0xed_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_ENABLE_OFFLINE_BIST_IN msgrequest */
 #define    MC_CMD_ENABLE_OFFLINE_BIST_IN_LEN 0
@@ -20588,7 +21489,7 @@
 #define MC_CMD_KR_TUNE 0xf1
 #undef MC_CMD_0xf1_PRIVILEGE_CTG
 
-#define MC_CMD_0xf1_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0xf1_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_KR_TUNE_IN msgrequest */
 #define    MC_CMD_KR_TUNE_IN_LENMIN 4
@@ -21144,7 +22045,7 @@
 #define MC_CMD_PCIE_TUNE 0xf2
 #undef MC_CMD_0xf2_PRIVILEGE_CTG
 
-#define MC_CMD_0xf2_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0xf2_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_PCIE_TUNE_IN msgrequest */
 #define    MC_CMD_PCIE_TUNE_IN_LENMIN 4
@@ -21877,7 +22778,7 @@
 #define MC_CMD_LICENSING_V3_TEMPORARY 0xd6
 #undef MC_CMD_0xd6_PRIVILEGE_CTG
 
-#define MC_CMD_0xd6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0xd6_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_LICENSING_V3_TEMPORARY_IN msgrequest */
 #define    MC_CMD_LICENSING_V3_TEMPORARY_IN_LEN 4
@@ -22305,8 +23206,8 @@
  * TLV_PORT_MODE_*). A superset of MC_CMD_GET_PORT_MODES_OUT/MODES that
  * contains all modes implemented in firmware for a particular board. Modes
  * listed in MODES are considered production modes and should be exposed in
- * userland tools. Modes listed in ENGINEERING_MODES, but not in MODES
- * should be considered hidden (not to be exposed in userland tools) and for
+ * userland tools. Modes listed in ENGINEERING_MODES, but not in MODES should
+ * be considered hidden (not to be exposed in userland tools) and for
  * engineering use only. There are no other semantic differences and any mode
  * listed in either MODES or ENGINEERING_MODES can be set on the board.
  */
@@ -22937,7 +23838,7 @@
 #define MC_CMD_EXEC_SIGNED 0x10c
 #undef MC_CMD_0x10c_PRIVILEGE_CTG
 
-#define MC_CMD_0x10c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x10c_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_EXEC_SIGNED_IN msgrequest */
 #define    MC_CMD_EXEC_SIGNED_IN_LEN 28
@@ -22967,7 +23868,7 @@
 #define MC_CMD_PREPARE_SIGNED 0x10d
 #undef MC_CMD_0x10d_PRIVILEGE_CTG
 
-#define MC_CMD_0x10d_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x10d_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_PREPARE_SIGNED_IN msgrequest */
 #define    MC_CMD_PREPARE_SIGNED_IN_LEN 4
@@ -22979,6 +23880,445 @@
 #define    MC_CMD_PREPARE_SIGNED_OUT_LEN 0
 
 
+/***********************************/
+/* MC_CMD_SET_SECURITY_RULE
+ * Set blacklist and/or whitelist action for a particular match criteria.
+ * (Medford-only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define MC_CMD_SET_SECURITY_RULE 0x10f
+#undef MC_CMD_0x10f_PRIVILEGE_CTG
+
+#define MC_CMD_0x10f_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SET_SECURITY_RULE_IN msgrequest */
+#define    MC_CMD_SET_SECURITY_RULE_IN_LEN 92
+/* fields to include in match criteria */
+#define       MC_CMD_SET_SECURITY_RULE_IN_MATCH_FIELDS_OFST 0
+#define       MC_CMD_SET_SECURITY_RULE_IN_MATCH_FIELDS_LEN 4
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_IP_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_IP_LBN 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_IP_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_IP_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_IP_LBN 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_IP_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_MAC_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_MAC_LBN 2
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_MAC_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORT_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORT_LBN 3
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORT_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_MAC_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_MAC_LBN 4
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_MAC_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORT_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORT_LBN 5
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORT_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_ETHER_TYPE_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_ETHER_TYPE_LBN 6
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_INNER_VLAN_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_INNER_VLAN_LBN 7
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_INNER_VLAN_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_OUTER_VLAN_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_OUTER_VLAN_LBN 8
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_IP_PROTO_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_IP_PROTO_LBN 9
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_IP_PROTO_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_PHYSICAL_PORT_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_PHYSICAL_PORT_LBN 10
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_PHYSICAL_PORT_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_RESERVED_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_RESERVED_LBN 11
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_RESERVED_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_SUBNET_ID_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_SUBNET_ID_LBN 12
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_SUBNET_ID_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORTRANGE_ID_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORTRANGE_ID_LBN 13
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_REMOTE_PORTRANGE_ID_WIDTH 1
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORTRANGE_ID_OFST 0
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORTRANGE_ID_LBN 14
+#define        MC_CMD_SET_SECURITY_RULE_IN_MATCH_LOCAL_PORTRANGE_ID_WIDTH 1
+/* remote MAC address to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_MAC_OFST 4
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_MAC_LEN 6
+/* remote port to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_PORT_OFST 10
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_PORT_LEN 2
+/* local MAC address to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_MAC_OFST 12
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_MAC_LEN 6
+/* local port to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_PORT_OFST 18
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_PORT_LEN 2
+/* Ethernet type to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_ETHER_TYPE_OFST 20
+#define       MC_CMD_SET_SECURITY_RULE_IN_ETHER_TYPE_LEN 2
+/* Inner VLAN tag to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_INNER_VLAN_OFST 22
+#define       MC_CMD_SET_SECURITY_RULE_IN_INNER_VLAN_LEN 2
+/* Outer VLAN tag to match (as bytes in network order) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_OUTER_VLAN_OFST 24
+#define       MC_CMD_SET_SECURITY_RULE_IN_OUTER_VLAN_LEN 2
+/* IP protocol to match (in low byte; set high byte to 0) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_IP_PROTO_OFST 26
+#define       MC_CMD_SET_SECURITY_RULE_IN_IP_PROTO_LEN 2
+/* Physical port to match (as little-endian 32-bit value) */
+#define       MC_CMD_SET_SECURITY_RULE_IN_PHYSICAL_PORT_OFST 28
+#define       MC_CMD_SET_SECURITY_RULE_IN_PHYSICAL_PORT_LEN 4
+/* Reserved; set to 0 */
+#define       MC_CMD_SET_SECURITY_RULE_IN_RESERVED_OFST 32
+#define       MC_CMD_SET_SECURITY_RULE_IN_RESERVED_LEN 4
+/* remote IP address to match (as bytes in network order; set last 12 bytes to
+ * 0 for IPv4 address)
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_IP_OFST 36
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_IP_LEN 16
+/* local IP address to match (as bytes in network order; set last 12 bytes to 0
+ * for IPv4 address)
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_IP_OFST 52
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_IP_LEN 16
+/* remote subnet ID to match (as little-endian 32-bit value); note that remote
+ * subnets are matched by mapping the remote IP address to a "subnet ID" via a
+ * data structure which must already have been configured using
+ * MC_CMD_SUBNET_MAP_SET_NODE appropriately
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_SUBNET_ID_OFST 68
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_SUBNET_ID_LEN 4
+/* remote portrange ID to match (as little-endian 32-bit value); note that
+ * remote port ranges are matched by mapping the remote port to a "portrange
+ * ID" via a data structure which must already have been configured using
+ * MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_PORTRANGE_ID_OFST 72
+#define       MC_CMD_SET_SECURITY_RULE_IN_REMOTE_PORTRANGE_ID_LEN 4
+/* local portrange ID to match (as little-endian 32-bit value); note that local
+ * port ranges are matched by mapping the local port to a "portrange ID" via a
+ * data structure which must already have been configured using
+ * MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_PORTRANGE_ID_OFST 76
+#define       MC_CMD_SET_SECURITY_RULE_IN_LOCAL_PORTRANGE_ID_LEN 4
+/* set the action for transmitted packets matching this rule */
+#define       MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_OFST 80
+#define       MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_LEN 4
+/* enum: make no decision */
+#define          MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_NONE 0x0
+/* enum: decide to accept the packet */
+#define          MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_WHITELIST 0x1
+/* enum: decide to drop the packet */
+#define          MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_BLACKLIST 0x2
+/* enum: inform the TSA controller about some sample of packets matching this
+ * rule (via MC_CMD_TSA_INFO_IN_PKT_SAMPLE messages); may be bitwise-ORed with
+ * either the WHITELIST or BLACKLIST action
+ */
+#define          MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_SAMPLE 0x4
+/* enum: do not change the current TX action */
+#define          MC_CMD_SET_SECURITY_RULE_IN_TX_ACTION_UNCHANGED 0xffffffff
+/* set the action for received packets matching this rule */
+#define       MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_OFST 84
+#define       MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_LEN 4
+/* enum: make no decision */
+#define          MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_NONE 0x0
+/* enum: decide to accept the packet */
+#define          MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_WHITELIST 0x1
+/* enum: decide to drop the packet */
+#define          MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_BLACKLIST 0x2
+/* enum: inform the TSA controller about some sample of packets matching this
+ * rule (via MC_CMD_TSA_INFO_IN_PKT_SAMPLE messages); may be bitwise-ORed with
+ * either the WHITELIST or BLACKLIST action
+ */
+#define          MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_SAMPLE 0x4
+/* enum: do not change the current RX action */
+#define          MC_CMD_SET_SECURITY_RULE_IN_RX_ACTION_UNCHANGED 0xffffffff
+/* counter ID to associate with this rule; IDs are allocated using
+ * MC_CMD_SECURITY_RULE_COUNTER_ALLOC
+ */
+#define       MC_CMD_SET_SECURITY_RULE_IN_COUNTER_ID_OFST 88
+#define       MC_CMD_SET_SECURITY_RULE_IN_COUNTER_ID_LEN 4
+/* enum: special value for the null counter ID */
+#define          MC_CMD_SET_SECURITY_RULE_IN_COUNTER_ID_NONE 0x0
+/* enum: special value to tell the MC to allocate an available counter */
+#define          MC_CMD_SET_SECURITY_RULE_IN_COUNTER_ID_SW_AUTO 0xeeeeeeee
+/* enum: special value to request use of hardware counter (Medford2 only) */
+#define          MC_CMD_SET_SECURITY_RULE_IN_COUNTER_ID_HW 0xffffffff
+
+/* MC_CMD_SET_SECURITY_RULE_OUT msgresponse */
+#define    MC_CMD_SET_SECURITY_RULE_OUT_LEN 32
+/* new reference count for uses of counter ID */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_COUNTER_REFCNT_OFST 0
+#define       MC_CMD_SET_SECURITY_RULE_OUT_COUNTER_REFCNT_LEN 4
+/* constructed match bits for this rule (as a tracing aid only) */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_MATCH_BITS_OFST 4
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_MATCH_BITS_LEN 12
+/* constructed discriminator bits for this rule (as a tracing aid only) */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_DISCRIMINATOR_OFST 16
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_DISCRIMINATOR_LEN 4
+/* base location for probes for this rule (as a tracing aid only) */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_PROBE_BASE_OFST 20
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_PROBE_BASE_LEN 4
+/* step for probes for this rule (as a tracing aid only) */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_PROBE_STEP_OFST 24
+#define       MC_CMD_SET_SECURITY_RULE_OUT_LUE_PROBE_STEP_LEN 4
+/* ID for reading back the counter */
+#define       MC_CMD_SET_SECURITY_RULE_OUT_COUNTER_ID_OFST 28
+#define       MC_CMD_SET_SECURITY_RULE_OUT_COUNTER_ID_LEN 4
+
+
+/***********************************/
+/* MC_CMD_RESET_SECURITY_RULES
+ * Reset all blacklist and whitelist actions for a particular physical port, or
+ * all ports. (Medford-only; for use by SolarSecure apps, not directly by
+ * drivers. See SF-114946-SW.) NOTE - this message definition is provisional.
+ * It has not yet been used in any released code and may change during
+ * development. This note will be removed once it is regarded as stable.
+ */
+#define MC_CMD_RESET_SECURITY_RULES 0x110
+#undef MC_CMD_0x110_PRIVILEGE_CTG
+
+#define MC_CMD_0x110_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_RESET_SECURITY_RULES_IN msgrequest */
+#define    MC_CMD_RESET_SECURITY_RULES_IN_LEN 4
+/* index of physical port to reset (or ALL_PHYSICAL_PORTS to reset all) */
+#define       MC_CMD_RESET_SECURITY_RULES_IN_PHYSICAL_PORT_OFST 0
+#define       MC_CMD_RESET_SECURITY_RULES_IN_PHYSICAL_PORT_LEN 4
+/* enum: special value to reset all physical ports */
+#define          MC_CMD_RESET_SECURITY_RULES_IN_ALL_PHYSICAL_PORTS 0xffffffff
+
+/* MC_CMD_RESET_SECURITY_RULES_OUT msgresponse */
+#define    MC_CMD_RESET_SECURITY_RULES_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_SECURITY_RULESET_VERSION
+ * Return a large hash value representing a "version" of the complete set of
+ * currently active blacklist / whitelist rules and associated data structures.
+ * (Medford-only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define MC_CMD_GET_SECURITY_RULESET_VERSION 0x111
+#undef MC_CMD_0x111_PRIVILEGE_CTG
+
+#define MC_CMD_0x111_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_GET_SECURITY_RULESET_VERSION_IN msgrequest */
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_IN_LEN 0
+
+/* MC_CMD_GET_SECURITY_RULESET_VERSION_OUT msgresponse */
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_LENMIN 1
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_LENMAX 252
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_LEN(num) (0+1*(num))
+#define    MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_NUM(len) (((len)-0)/1)
+/* Opaque hash value; length may vary depending on the hash scheme used */
+#define       MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_OFST 0
+#define       MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_LEN 1
+#define       MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_MINNUM 1
+#define       MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_MAXNUM 252
+#define       MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION_MAXNUM_MCDI2 1020
+
+
+/***********************************/
+/* MC_CMD_SECURITY_RULE_COUNTER_ALLOC
+ * Allocate counters for use with blacklist / whitelist rules. (Medford-only;
+ * for use by SolarSecure apps, not directly by drivers. See SF-114946-SW.)
+ * NOTE - this message definition is provisional. It has not yet been used in
+ * any released code and may change during development. This note will be
+ * removed once it is regarded as stable.
+ */
+#define MC_CMD_SECURITY_RULE_COUNTER_ALLOC 0x112
+#undef MC_CMD_0x112_PRIVILEGE_CTG
+
+#define MC_CMD_0x112_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SECURITY_RULE_COUNTER_ALLOC_IN msgrequest */
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_IN_LEN 4
+/* the number of new counter IDs to request */
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_IN_NUM_COUNTERS_OFST 0
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_IN_NUM_COUNTERS_LEN 4
+
+/* MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT msgresponse */
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_LENMIN 4
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_LENMAX 252
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_LEN(num) (4+4*(num))
+#define    MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_NUM(len) (((len)-4)/4)
+/* the number of new counter IDs allocated (may be less than the number
+ * requested if resources are unavailable)
+ */
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_NUM_COUNTERS_OFST 0
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_NUM_COUNTERS_LEN 4
+/* new counter ID(s) */
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_OFST 4
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_LEN 4
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_MINNUM 0
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_MAXNUM 62
+#define       MC_CMD_SECURITY_RULE_COUNTER_ALLOC_OUT_COUNTER_ID_MAXNUM_MCDI2 254
+
+
+/***********************************/
+/* MC_CMD_SECURITY_RULE_COUNTER_FREE
+ * Allocate counters for use with blacklist / whitelist rules. (Medford-only;
+ * for use by SolarSecure apps, not directly by drivers. See SF-114946-SW.)
+ * NOTE - this message definition is provisional. It has not yet been used in
+ * any released code and may change during development. This note will be
+ * removed once it is regarded as stable.
+ */
+#define MC_CMD_SECURITY_RULE_COUNTER_FREE 0x113
+#undef MC_CMD_0x113_PRIVILEGE_CTG
+
+#define MC_CMD_0x113_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SECURITY_RULE_COUNTER_FREE_IN msgrequest */
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_LENMIN 4
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_LENMAX 252
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_NUM(len) (((len)-4)/4)
+/* the number of counter IDs to free */
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_NUM_COUNTERS_OFST 0
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_NUM_COUNTERS_LEN 4
+/* the counter ID(s) to free */
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_OFST 4
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_LEN 4
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_MINNUM 0
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_MAXNUM 62
+#define       MC_CMD_SECURITY_RULE_COUNTER_FREE_IN_COUNTER_ID_MAXNUM_MCDI2 254
+
+/* MC_CMD_SECURITY_RULE_COUNTER_FREE_OUT msgresponse */
+#define    MC_CMD_SECURITY_RULE_COUNTER_FREE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_SUBNET_MAP_SET_NODE
+ * Atomically update a trie node in the map of subnets to subnet IDs. The
+ * constants in the descriptions of the fields of this message may be retrieved
+ * by the GET_SECURITY_RULE_INFO op of MC_CMD_GET_PARSER_DISP_INFO. (Medford-
+ * only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define MC_CMD_SUBNET_MAP_SET_NODE 0x114
+#undef MC_CMD_0x114_PRIVILEGE_CTG
+
+#define MC_CMD_0x114_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SUBNET_MAP_SET_NODE_IN msgrequest */
+#define    MC_CMD_SUBNET_MAP_SET_NODE_IN_LENMIN 6
+#define    MC_CMD_SUBNET_MAP_SET_NODE_IN_LENMAX 252
+#define    MC_CMD_SUBNET_MAP_SET_NODE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_SUBNET_MAP_SET_NODE_IN_LEN(num) (4+2*(num))
+#define    MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_NUM(len) (((len)-4)/2)
+/* node to update in the range 0 .. SUBNET_MAP_NUM_NODES-1 */
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_NODE_ID_OFST 0
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_NODE_ID_LEN 4
+/* SUBNET_MAP_NUM_ENTRIES_PER_NODE new entries; each entry is either a pointer
+ * to the next node, expressed as an offset in the trie memory (i.e. node ID
+ * multiplied by SUBNET_MAP_NUM_ENTRIES_PER_NODE), or a leaf value in the range
+ * SUBNET_ID_MIN .. SUBNET_ID_MAX
+ */
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_OFST 4
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_LEN 2
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_MINNUM 1
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_MAXNUM 124
+#define       MC_CMD_SUBNET_MAP_SET_NODE_IN_ENTRY_MAXNUM_MCDI2 508
+
+/* MC_CMD_SUBNET_MAP_SET_NODE_OUT msgresponse */
+#define    MC_CMD_SUBNET_MAP_SET_NODE_OUT_LEN 0
+
+/* PORTRANGE_TREE_ENTRY structuredef */
+#define    PORTRANGE_TREE_ENTRY_LEN 4
+/* key for branch nodes (<= key takes left branch, > key takes right branch),
+ * or magic value for leaf nodes
+ */
+#define       PORTRANGE_TREE_ENTRY_BRANCH_KEY_OFST 0
+#define       PORTRANGE_TREE_ENTRY_BRANCH_KEY_LEN 2
+#define          PORTRANGE_TREE_ENTRY_LEAF_NODE_KEY 0xffff /* enum */
+#define       PORTRANGE_TREE_ENTRY_BRANCH_KEY_LBN 0
+#define       PORTRANGE_TREE_ENTRY_BRANCH_KEY_WIDTH 16
+/* final portrange ID for leaf nodes (don't care for branch nodes) */
+#define       PORTRANGE_TREE_ENTRY_LEAF_PORTRANGE_ID_OFST 2
+#define       PORTRANGE_TREE_ENTRY_LEAF_PORTRANGE_ID_LEN 2
+#define       PORTRANGE_TREE_ENTRY_LEAF_PORTRANGE_ID_LBN 16
+#define       PORTRANGE_TREE_ENTRY_LEAF_PORTRANGE_ID_WIDTH 16
+
+
+/***********************************/
+/* MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE
+ * Atomically update the entire tree mapping remote port ranges to portrange
+ * IDs. The constants in the descriptions of the fields of this message may be
+ * retrieved by the GET_SECURITY_RULE_INFO op of MC_CMD_GET_PARSER_DISP_INFO.
+ * (Medford-only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE 0x115
+#undef MC_CMD_0x115_PRIVILEGE_CTG
+
+#define MC_CMD_0x115_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN msgrequest */
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_LENMIN 4
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_LENMAX 252
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_NUM(len) (((len)-0)/4)
+/* PORTRANGE_TREE_NUM_ENTRIES new entries, each laid out as a
+ * PORTRANGE_TREE_ENTRY
+ */
+#define       MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_OFST 0
+#define       MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_LEN 4
+#define       MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MINNUM 1
+#define       MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MAXNUM 63
+#define       MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MAXNUM_MCDI2 255
+
+/* MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_OUT msgresponse */
+#define    MC_CMD_REMOTE_PORTRANGE_MAP_SET_TREE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE
+ * Atomically update the entire tree mapping remote port ranges to portrange
+ * IDs. The constants in the descriptions of the fields of this message may be
+ * retrieved by the GET_SECURITY_RULE_INFO op of MC_CMD_GET_PARSER_DISP_INFO.
+ * (Medford-only; for use by SolarSecure apps, not directly by drivers. See
+ * SF-114946-SW.) NOTE - this message definition is provisional. It has not yet
+ * been used in any released code and may change during development. This note
+ * will be removed once it is regarded as stable.
+ */
+#define MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE 0x116
+#undef MC_CMD_0x116_PRIVILEGE_CTG
+
+#define MC_CMD_0x116_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN msgrequest */
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_LENMIN 4
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_LENMAX 252
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_NUM(len) (((len)-0)/4)
+/* PORTRANGE_TREE_NUM_ENTRIES new entries, each laid out as a
+ * PORTRANGE_TREE_ENTRY
+ */
+#define       MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_OFST 0
+#define       MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_LEN 4
+#define       MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MINNUM 1
+#define       MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MAXNUM 63
+#define       MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_IN_ENTRIES_MAXNUM_MCDI2 255
+
+/* MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_OUT msgresponse */
+#define    MC_CMD_LOCAL_PORTRANGE_MAP_SET_TREE_OUT_LEN 0
+
 /* TUNNEL_ENCAP_UDP_PORT_ENTRY structuredef */
 #define    TUNNEL_ENCAP_UDP_PORT_ENTRY_LEN 4
 /* UDP port (the standard ports are named below but any port may be used) */
@@ -23058,7 +24398,7 @@
 #define MC_CMD_RX_BALANCING 0x118
 #undef MC_CMD_0x118_PRIVILEGE_CTG
 
-#define MC_CMD_0x118_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x118_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_RX_BALANCING_IN msgrequest */
 #define    MC_CMD_RX_BALANCING_IN_LEN 16
@@ -23079,6 +24419,627 @@
 #define    MC_CMD_RX_BALANCING_OUT_LEN 0
 
 
+/***********************************/
+/* MC_CMD_TSA_BIND
+ * TSAN - TSAC binding communication protocol. Refer to SF-115479-TC for more
+ * info in respect to the binding protocol.
+ */
+#define MC_CMD_TSA_BIND 0x119
+#undef MC_CMD_0x119_PRIVILEGE_CTG
+
+#define MC_CMD_0x119_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_TSA_BIND_IN msgrequest: Protocol operation code */
+#define    MC_CMD_TSA_BIND_IN_LEN 4
+#define       MC_CMD_TSA_BIND_IN_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_OP_LEN 4
+/* enum: Obsolete. Use MC_CMD_SECURE_NIC_INFO_IN_STATUS. */
+#define          MC_CMD_TSA_BIND_OP_GET_ID 0x1
+/* enum: Get a binding ticket from the TSAN. The binding ticket is used as part
+ * of the binding procedure to authorize the binding of an adapter to a TSAID.
+ * Refer to SF-114946-SW for more information. This sub-command is only
+ * available over a TLS secure connection between the TSAN and TSAC.
+ */
+#define          MC_CMD_TSA_BIND_OP_GET_TICKET 0x2
+/* enum: Opcode associated with the propagation of a private key that TSAN uses
+ * as part of post-binding authentication procedure. More specifically, TSAN
+ * uses this key for a signing operation. TSAC uses the counterpart public key
+ * to verify the signature. Note - The post-binding authentication occurs when
+ * the TSAN-TSAC connection terminates and TSAN tries to reconnect. Refer to
+ * SF-114946-SW for more information. This sub-command is only available over a
+ * TLS secure connection between the TSAN and TSAC.
+ */
+#define          MC_CMD_TSA_BIND_OP_SET_KEY 0x3
+/* enum: Request an insecure unbinding operation. This sub-command is available
+ * for any privileged client.
+ */
+#define          MC_CMD_TSA_BIND_OP_UNBIND 0x4
+/* enum: Obsolete. Use MC_CMD_TSA_BIND_OP_SECURE_UNBIND. */
+#define          MC_CMD_TSA_BIND_OP_UNBIND_EXT 0x5
+/* enum: Opcode associated with the propagation of the unbinding secret token.
+ * TSAN persists the unbinding secret token. Refer to SF-115479-TC for more
+ * information. This sub-command is only available over a TLS secure connection
+ * between the TSAN and TSAC.
+ */
+#define          MC_CMD_TSA_BIND_OP_SET_UNBINDTOKEN 0x6
+/* enum: Obsolete. Use MC_CMD_TSA_BIND_OP_SECURE_DECOMMISSION. */
+#define          MC_CMD_TSA_BIND_OP_DECOMMISSION 0x7
+/* enum: Obsolete. Use MC_CMD_GET_CERTIFICATE. */
+#define          MC_CMD_TSA_BIND_OP_GET_CERTIFICATE 0x8
+/* enum: Request a secure unbinding operation using unbinding token. This sub-
+ * command is available for any privileged client.
+ */
+#define          MC_CMD_TSA_BIND_OP_SECURE_UNBIND 0x9
+/* enum: Request a secure decommissioning operation. This sub-command is
+ * available for any privileged client.
+ */
+#define          MC_CMD_TSA_BIND_OP_SECURE_DECOMMISSION 0xa
+/* enum: Test facility that allows an adapter to be configured to behave as if
+ * Bound to a TSA controller with restricted MCDI administrator operations.
+ * This operation is primarily intended to aid host driver development.
+ */
+#define          MC_CMD_TSA_BIND_OP_TEST_MCDI 0xb
+
+/* MC_CMD_TSA_BIND_IN_GET_ID msgrequest: Obsolete. Use
+ * MC_CMD_SECURE_NIC_INFO_IN_STATUS.
+ */
+#define    MC_CMD_TSA_BIND_IN_GET_ID_LEN 20
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_GET_ID_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_GET_ID_OP_LEN 4
+/* Cryptographic nonce that TSAC generates and sends to TSAN. TSAC generates
+ * the nonce every time as part of the TSAN post-binding authentication
+ * procedure when the TSAN-TSAC connection terminates and TSAN does need to re-
+ * connect to the TSAC. Refer to SF-114946-SW for more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_GET_ID_NONCE_OFST 4
+#define       MC_CMD_TSA_BIND_IN_GET_ID_NONCE_LEN 16
+
+/* MC_CMD_TSA_BIND_IN_GET_TICKET msgrequest */
+#define    MC_CMD_TSA_BIND_IN_GET_TICKET_LEN 4
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_GET_TICKET_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_GET_TICKET_OP_LEN 4
+
+/* MC_CMD_TSA_BIND_IN_SET_KEY msgrequest */
+#define    MC_CMD_TSA_BIND_IN_SET_KEY_LENMIN 5
+#define    MC_CMD_TSA_BIND_IN_SET_KEY_LENMAX 252
+#define    MC_CMD_TSA_BIND_IN_SET_KEY_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_IN_SET_KEY_LEN(num) (4+1*(num))
+#define    MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_NUM(len) (((len)-4)/1)
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_OP_LEN 4
+/* This data blob contains the private key generated by the TSAC. TSAN uses
+ * this key for a signing operation. Note- This private key is used in
+ * conjunction with the post-binding TSAN authentication procedure that occurs
+ * when the TSAN-TSAC connection terminates and TSAN tries to reconnect. Refer
+ * to SF-114946-SW for more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_OFST 4
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_MINNUM 1
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_MAXNUM 248
+#define       MC_CMD_TSA_BIND_IN_SET_KEY_DATKEY_MAXNUM_MCDI2 1016
+
+/* MC_CMD_TSA_BIND_IN_UNBIND msgrequest: Request an insecure unbinding
+ * operation.
+ */
+#define    MC_CMD_TSA_BIND_IN_UNBIND_LEN 10
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_UNBIND_OP_LEN 4
+/* TSAN unique identifier for the network adapter */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_TSANID_OFST 4
+#define       MC_CMD_TSA_BIND_IN_UNBIND_TSANID_LEN 6
+
+/* MC_CMD_TSA_BIND_IN_UNBIND_EXT msgrequest: Obsolete. Use
+ * MC_CMD_TSA_BIND_IN_SECURE_UNBIND.
+ */
+#define    MC_CMD_TSA_BIND_IN_UNBIND_EXT_LENMIN 93
+#define    MC_CMD_TSA_BIND_IN_UNBIND_EXT_LENMAX 252
+#define    MC_CMD_TSA_BIND_IN_UNBIND_EXT_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_IN_UNBIND_EXT_LEN(num) (92+1*(num))
+#define    MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_NUM(len) (((len)-92)/1)
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_OP_LEN 4
+/* TSAN unique identifier for the network adapter */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSANID_OFST 4
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSANID_LEN 6
+/* Align the arguments to 32 bits */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSANID_RSVD_OFST 10
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSANID_RSVD_LEN 2
+/* This attribute identifies the TSA infrastructure domain. The length of the
+ * TSAID attribute is limited to 64 bytes. This is how TSA SDK defines the max
+ * length. Note- The TSAID is the Organizational Unit Name filed as part of the
+ * root and server certificates.
+ */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSAID_OFST 12
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSAID_LEN 1
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_TSAID_NUM 64
+/* Unbinding secret token. The adapter validates this unbinding token by
+ * comparing it against the one stored on the adapter as part of the
+ * MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN msgrequest. Refer to SF-115479-TC for
+ * more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_UNBINDTOKEN_OFST 76
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_UNBINDTOKEN_LEN 16
+/* This is the signature of the above mentioned fields- TSANID, TSAID and
+ * UNBINDTOKEN. As per current requirements, the SIG opaque data blob contains
+ * ECDSA ECC-384 based signature. The ECC curve is secp384r1. The signature is
+ * also ASN-1 encoded. Note- The signature is verified based on the public key
+ * stored into the root certificate that is provisioned on the adapter side.
+ * This key is known as the PUKtsaid. Refer to SF-115479-TC for more
+ * information.
+ */
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_OFST 92
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_LEN 1
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_MINNUM 1
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_MAXNUM 160
+#define       MC_CMD_TSA_BIND_IN_UNBIND_EXT_SIG_MAXNUM_MCDI2 928
+
+/* MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN msgrequest */
+#define    MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_LEN 20
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_OP_LEN 4
+/* Unbinding secret token. TSAN persists the unbinding secret token. Refer to
+ * SF-115479-TC for more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_UNBINDTOKEN_OFST 4
+#define       MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_UNBINDTOKEN_LEN 16
+/* enum: There are situations when the binding process does not complete
+ * successfully due to key, other attributes corruption at the database level
+ * (Controller). Adapter can't connect to the controller anymore. To recover,
+ * make usage of the decommission command that forces the adapter into
+ * unbinding state.
+ */
+#define          MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN_ADAPTER_BINDING_FAILURE 0x1
+
+/* MC_CMD_TSA_BIND_IN_DECOMMISSION msgrequest: Obsolete. Use
+ * MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION.
+ */
+#define    MC_CMD_TSA_BIND_IN_DECOMMISSION_LENMIN 109
+#define    MC_CMD_TSA_BIND_IN_DECOMMISSION_LENMAX 252
+#define    MC_CMD_TSA_BIND_IN_DECOMMISSION_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_IN_DECOMMISSION_LEN(num) (108+1*(num))
+#define    MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_NUM(len) (((len)-108)/1)
+/* This is the signature of the above mentioned fields- TSAID, USER and REASON.
+ * As per current requirements, the SIG opaque data blob contains ECDSA ECC-384
+ * based signature. The ECC curve is secp384r1. The signature is also ASN-1
+ * encoded . Note- The signature is verified based on the public key stored
+ * into the root certificate that is provisioned on the adapter side. This key
+ * is known as the PUKtsaid. Refer to SF-115479-TC for more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_OFST 108
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_LEN 1
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_MINNUM 1
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_MAXNUM 144
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_SIG_MAXNUM_MCDI2 912
+/* The operation requested. */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_OP_LEN 4
+/* This attribute identifies the TSA infrastructure domain. The length of the
+ * TSAID attribute is limited to 64 bytes. This is how TSA SDK defines the max
+ * length. Note- The TSAID is the Organizational Unit Name filed as part of the
+ * root and server certificates.
+ */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_TSAID_OFST 4
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_TSAID_LEN 1
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_TSAID_NUM 64
+/* User ID that comes, as an example, from the Controller. Note- The 33 byte
+ * length of this attribute is max length of the linux user name plus null
+ * character.
+ */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_USER_OFST 68
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_USER_LEN 1
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_USER_NUM 33
+/* Align the arguments to 32 bits */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_USER_RSVD_OFST 101
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_USER_RSVD_LEN 3
+/* Reason of why decommissioning happens Note- The list of reasons, defined as
+ * part of the enumeration below, can be extended.
+ */
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_REASON_OFST 104
+#define       MC_CMD_TSA_BIND_IN_DECOMMISSION_REASON_LEN 4
+
+/* MC_CMD_TSA_BIND_IN_GET_CERTIFICATE msgrequest: Obsolete. Use
+ * MC_CMD_GET_CERTIFICATE.
+ */
+#define    MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_LEN 8
+/* The operation requested, must be MC_CMD_TSA_BIND_OP_GET_CERTIFICATE. */
+#define       MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_OP_LEN 4
+/* Type of the certificate to be retrieved. */
+#define       MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_TYPE_OFST 4
+#define       MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_TYPE_LEN 4
+#define          MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_UNUSED 0x0 /* enum */
+/* enum: Adapter Authentication Certificate (AAC). The AAC is used by the
+ * controller to verify the authenticity of the adapter.
+ */
+#define          MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_AAC 0x1
+/* enum: Adapter Authentication Signing Certificate (AASC). The AASC is used by
+ * the controller to verify the validity of AAC.
+ */
+#define          MC_CMD_TSA_BIND_IN_GET_CERTIFICATE_AASC 0x2
+
+/* MC_CMD_TSA_BIND_IN_SECURE_UNBIND msgrequest: Request a secure unbinding
+ * operation using unbinding token.
+ */
+#define    MC_CMD_TSA_BIND_IN_SECURE_UNBIND_LENMIN 97
+#define    MC_CMD_TSA_BIND_IN_SECURE_UNBIND_LENMAX 200
+#define    MC_CMD_TSA_BIND_IN_SECURE_UNBIND_LENMAX_MCDI2 200
+#define    MC_CMD_TSA_BIND_IN_SECURE_UNBIND_LEN(num) (96+1*(num))
+#define    MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_NUM(len) (((len)-96)/1)
+/* The operation requested, must be MC_CMD_TSA_BIND_OP_SECURE_UNBIND. */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_OP_LEN 4
+/* Type of the message. (MESSAGE_TYPE_xxx) Must be
+ * MESSAGE_TYPE_TSA_SECURE_UNBIND.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_MESSAGE_TYPE_OFST 4
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_MESSAGE_TYPE_LEN 4
+/* TSAN unique identifier for the network adapter */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSANID_OFST 8
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSANID_LEN 6
+/* Align the arguments to 32 bits */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSANID_RSVD_OFST 14
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSANID_RSVD_LEN 2
+/* A NUL padded US-ASCII string identifying the TSA infrastructure domain. This
+ * field is for information only, and not used by the firmware. Note- The TSAID
+ * is the Organizational Unit Name field as part of the root and server
+ * certificates.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSAID_OFST 16
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSAID_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_TSAID_NUM 64
+/* Unbinding secret token. The adapter validates this unbinding token by
+ * comparing it against the one stored on the adapter as part of the
+ * MC_CMD_TSA_BIND_IN_SET_UNBINDTOKEN msgrequest. Refer to SF-115479-TC for
+ * more information.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_UNBINDTOKEN_OFST 80
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_UNBINDTOKEN_LEN 16
+/* The signature computed and encoded as specified by MESSAGE_TYPE. */
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_OFST 96
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_MINNUM 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_MAXNUM 104
+#define       MC_CMD_TSA_BIND_IN_SECURE_UNBIND_SIG_MAXNUM_MCDI2 104
+
+/* MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION msgrequest: Request a secure
+ * decommissioning operation.
+ */
+#define    MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_LENMIN 113
+#define    MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_LENMAX 216
+#define    MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_LENMAX_MCDI2 216
+#define    MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_LEN(num) (112+1*(num))
+#define    MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_NUM(len) (((len)-112)/1)
+/* The operation requested, must be MC_CMD_TSA_BIND_OP_SECURE_DECOMMISSION. */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_OP_LEN 4
+/* Type of the message. (MESSAGE_TYPE_xxx) Must be
+ * MESSAGE_TYPE_SECURE_DECOMMISSION.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_MESSAGE_TYPE_OFST 4
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_MESSAGE_TYPE_LEN 4
+/* A NUL padded US-ASCII string identifying the TSA infrastructure domain. This
+ * field is for information only, and not used by the firmware. Note- The TSAID
+ * is the Organizational Unit Name field as part of the root and server
+ * certificates.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_TSAID_OFST 8
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_TSAID_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_TSAID_NUM 64
+/* A NUL padded US-ASCII string containing user name of the creator of the
+ * decommissioning ticket. This field is for information only, and not used by
+ * the firmware.
+ */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_USER_OFST 72
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_USER_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_USER_NUM 36
+/* Reason of why decommissioning happens */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_REASON_OFST 108
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_REASON_LEN 4
+/* enum: There are situations when the binding process does not complete
+ * successfully due to key, other attributes corruption at the database level
+ * (Controller). Adapter can't connect to the controller anymore. To recover,
+ * use the decommission command to force the adapter into unbound state.
+ */
+#define          MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_ADAPTER_BINDING_FAILURE 0x1
+/* The signature computed and encoded as specified by MESSAGE_TYPE. */
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_OFST 112
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_LEN 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_MINNUM 1
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_MAXNUM 104
+#define       MC_CMD_TSA_BIND_IN_SECURE_DECOMMISSION_SIG_MAXNUM_MCDI2 104
+
+/* MC_CMD_TSA_BIND_IN_TEST_MCDI msgrequest: Test mode that emulates MCDI
+ * interface restrictions of a bound adapter. This operation is intended for
+ * test use on adapters that are not deployed and bound to a TSA Controller.
+ * Using it on a Bound adapter will succeed but will not alter the MCDI
+ * privileges as MCDI operations will already be restricted.
+ */
+#define    MC_CMD_TSA_BIND_IN_TEST_MCDI_LEN 8
+/* The operation requested must be MC_CMD_TSA_BIND_OP_TEST_MCDI. */
+#define       MC_CMD_TSA_BIND_IN_TEST_MCDI_OP_OFST 0
+#define       MC_CMD_TSA_BIND_IN_TEST_MCDI_OP_LEN 4
+/* Enable or disable emulation of bound adapter */
+#define       MC_CMD_TSA_BIND_IN_TEST_MCDI_CTRL_OFST 4
+#define       MC_CMD_TSA_BIND_IN_TEST_MCDI_CTRL_LEN 4
+#define          MC_CMD_TSA_BIND_IN_TEST_MCDI_DISABLE 0x0 /* enum */
+#define          MC_CMD_TSA_BIND_IN_TEST_MCDI_ENABLE 0x1 /* enum */
+
+/* MC_CMD_TSA_BIND_OUT_GET_ID msgresponse: Obsolete. Use
+ * MC_CMD_SECURE_NIC_INFO_OUT_STATUS.
+ */
+#define    MC_CMD_TSA_BIND_OUT_GET_ID_LENMIN 15
+#define    MC_CMD_TSA_BIND_OUT_GET_ID_LENMAX 252
+#define    MC_CMD_TSA_BIND_OUT_GET_ID_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_OUT_GET_ID_LEN(num) (14+1*(num))
+#define    MC_CMD_TSA_BIND_OUT_GET_ID_SIG_NUM(len) (((len)-14)/1)
+/* The protocol operation code MC_CMD_TSA_BIND_OP_GET_ID that is sent back to
+ * the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_OP_LEN 4
+/* Rules engine type. Note- The rules engine type allows TSAC to further
+ * identify the connected endpoint (e.g. TSAN, NIC Emulator) type and take the
+ * proper action accordingly. As an example, TSAC uses the rules engine type to
+ * select the SF key that differs in the case of TSAN vs. NIC Emulator.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_RULE_ENGINE_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_RULE_ENGINE_LEN 4
+/* enum: Hardware rules engine. */
+#define          MC_CMD_TSA_BIND_OUT_GET_ID_RULE_ENGINE_TSAN 0x1
+/* enum: Nic emulator rules engine. */
+#define          MC_CMD_TSA_BIND_OUT_GET_ID_RULE_ENGINE_NEMU 0x2
+/* enum: SSFE. */
+#define          MC_CMD_TSA_BIND_OUT_GET_ID_RULE_ENGINE_SSFE 0x3
+/* TSAN unique identifier for the network adapter */
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_TSANID_OFST 8
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_TSANID_LEN 6
+/* The signature data blob. The signature is computed against the message
+ * formed by TSAN ID concatenated with the NONCE value. Refer to SF-115479-TC
+ * for more information also in respect to the private keys that are used to
+ * sign the message based on TSAN pre/post-binding authentication procedure.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_SIG_OFST 14
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_SIG_LEN 1
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_SIG_MINNUM 1
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_SIG_MAXNUM 238
+#define       MC_CMD_TSA_BIND_OUT_GET_ID_SIG_MAXNUM_MCDI2 1006
+
+/* MC_CMD_TSA_BIND_OUT_GET_TICKET msgresponse */
+#define    MC_CMD_TSA_BIND_OUT_GET_TICKET_LENMIN 5
+#define    MC_CMD_TSA_BIND_OUT_GET_TICKET_LENMAX 252
+#define    MC_CMD_TSA_BIND_OUT_GET_TICKET_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_OUT_GET_TICKET_LEN(num) (4+1*(num))
+#define    MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_NUM(len) (((len)-4)/1)
+/* The protocol operation code MC_CMD_TSA_BIND_OP_GET_TICKET that is sent back
+ * to the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_OP_LEN 4
+/* The ticket represents the data blob construct that TSAN sends to TSAC as
+ * part of the binding protocol. From the TSAN perspective the ticket is an
+ * opaque construct. For more info refer to SF-115479-TC.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_LEN 1
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_MINNUM 1
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_MAXNUM 248
+#define       MC_CMD_TSA_BIND_OUT_GET_TICKET_TICKET_MAXNUM_MCDI2 1016
+
+/* MC_CMD_TSA_BIND_OUT_SET_KEY msgresponse */
+#define    MC_CMD_TSA_BIND_OUT_SET_KEY_LEN 4
+/* The protocol operation code MC_CMD_TSA_BIND_OP_SET_KEY that is sent back to
+ * the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_SET_KEY_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_SET_KEY_OP_LEN 4
+
+/* MC_CMD_TSA_BIND_OUT_UNBIND msgresponse: Response to insecure unbind request.
+ */
+#define    MC_CMD_TSA_BIND_OUT_UNBIND_LEN 8
+/* Same as MC_CMD_ERR field, but included as 0 in success cases */
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_RESULT_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_RESULT_LEN 4
+/* Extra status information */
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_INFO_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_INFO_LEN 4
+/* enum: Unbind successful. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_OK_UNBOUND 0x0
+/* enum: TSANID mismatch */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_ERR_BAD_TSANID 0x1
+/* enum: Unable to remove the binding ticket from persistent storage. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_ERR_REMOVE_TICKET 0x2
+/* enum: TSAN is not bound to a binding ticket. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_ERR_NOT_BOUND 0x3
+
+/* MC_CMD_TSA_BIND_OUT_UNBIND_EXT msgresponse: Obsolete. Use
+ * MC_CMD_TSA_BIND_OUT_SECURE_UNBIND.
+ */
+#define    MC_CMD_TSA_BIND_OUT_UNBIND_EXT_LEN 8
+/* Same as MC_CMD_ERR field, but included as 0 in success cases */
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_EXT_RESULT_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_EXT_RESULT_LEN 4
+/* Extra status information */
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_EXT_INFO_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_UNBIND_EXT_INFO_LEN 4
+/* enum: Unbind successful. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_OK_UNBOUND 0x0
+/* enum: TSANID mismatch */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_ERR_BAD_TSANID 0x1
+/* enum: Unable to remove the binding ticket from persistent storage. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_ERR_REMOVE_TICKET 0x2
+/* enum: TSAN is not bound to a binding ticket. */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_ERR_NOT_BOUND 0x3
+/* enum: Invalid unbind token */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_ERR_BAD_TOKEN 0x4
+/* enum: Invalid signature */
+#define          MC_CMD_TSA_BIND_OUT_UNBIND_EXT_ERR_BAD_SIGNATURE 0x5
+
+/* MC_CMD_TSA_BIND_OUT_SET_UNBINDTOKEN msgresponse */
+#define    MC_CMD_TSA_BIND_OUT_SET_UNBINDTOKEN_LEN 4
+/* The protocol operation code MC_CMD_TSA_BIND_OP_SET_UNBINDTOKEN that is sent
+ * back to the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_SET_UNBINDTOKEN_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_SET_UNBINDTOKEN_OP_LEN 4
+
+/* MC_CMD_TSA_BIND_OUT_DECOMMISSION msgresponse: Obsolete. Use
+ * MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION.
+ */
+#define    MC_CMD_TSA_BIND_OUT_DECOMMISSION_LEN 4
+/* The protocol operation code MC_CMD_TSA_BIND_OP_DECOMMISSION that is sent
+ * back to the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_DECOMMISSION_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_DECOMMISSION_OP_LEN 4
+
+/* MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE msgresponse */
+#define    MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_LENMIN 9
+#define    MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_LENMAX 252
+#define    MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_LEN(num) (8+1*(num))
+#define    MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_NUM(len) (((len)-8)/1)
+/* The protocol operation code MC_CMD_TSA_BIND_OP_GET_CERTIFICATE that is sent
+ * back to the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_OP_LEN 4
+/* Type of the certificate. */
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_TYPE_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_TYPE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_TSA_BIND_IN_GET_CERTIFICATE/TYPE */
+/* The certificate data. */
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_OFST 8
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_LEN 1
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_MINNUM 1
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_MAXNUM 244
+#define       MC_CMD_TSA_BIND_OUT_GET_CERTIFICATE_DATA_MAXNUM_MCDI2 1012
+
+/* MC_CMD_TSA_BIND_OUT_SECURE_UNBIND msgresponse: Response to secure unbind
+ * request.
+ */
+#define    MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_LEN 8
+/* The protocol operation code that is sent back to the caller. */
+#define       MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_OP_LEN 4
+#define       MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_RESULT_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_RESULT_LEN 4
+/* enum: Unbind successful. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_OK_UNBOUND 0x0
+/* enum: TSANID mismatch */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_ERR_BAD_TSANID 0x1
+/* enum: Unable to remove the binding ticket from persistent storage. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_ERR_REMOVE_TICKET 0x2
+/* enum: TSAN is not bound to a domain. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_ERR_NOT_BOUND 0x3
+/* enum: Invalid unbind token */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_ERR_BAD_TOKEN 0x4
+/* enum: Invalid signature */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_UNBIND_ERR_BAD_SIGNATURE 0x5
+
+/* MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION msgresponse: Response to secure
+ * decommission request.
+ */
+#define    MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_LEN 8
+/* The protocol operation code that is sent back to the caller. */
+#define       MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_OP_LEN 4
+#define       MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_RESULT_OFST 4
+#define       MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_RESULT_LEN 4
+/* enum: Unbind successful. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_OK_UNBOUND 0x0
+/* enum: TSANID mismatch */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_ERR_BAD_TSANID 0x1
+/* enum: Unable to remove the binding ticket from persistent storage. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_ERR_REMOVE_TICKET 0x2
+/* enum: TSAN is not bound to a domain. */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_ERR_NOT_BOUND 0x3
+/* enum: Invalid unbind token */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_ERR_BAD_TOKEN 0x4
+/* enum: Invalid signature */
+#define          MC_CMD_TSA_BIND_OUT_SECURE_DECOMMISSION_ERR_BAD_SIGNATURE 0x5
+
+/* MC_CMD_TSA_BIND_OUT_TEST_MCDI msgrequest */
+#define    MC_CMD_TSA_BIND_OUT_TEST_MCDI_LEN 4
+/* The protocol operation code MC_CMD_TSA_BIND_OP_TEST_MCDI that is sent back
+ * to the caller.
+ */
+#define       MC_CMD_TSA_BIND_OUT_TEST_MCDI_OP_OFST 0
+#define       MC_CMD_TSA_BIND_OUT_TEST_MCDI_OP_LEN 4
+
+
+/***********************************/
+/* MC_CMD_MANAGE_SECURITY_RULESET_CACHE
+ * Manage the persistent NVRAM cache of security rules created with
+ * MC_CMD_SET_SECURITY_RULE. Note that the cache is not automatically updated
+ * as rules are added or removed; the active ruleset must be explicitly
+ * committed to the cache. The cache may also be explicitly invalidated,
+ * without affecting the currently active ruleset. When the cache is valid, it
+ * will be loaded at power on or MC reboot, instead of the default ruleset.
+ * Rollback of the currently active ruleset to the cached version (when it is
+ * valid) is also supported. (Medford-only; for use by SolarSecure apps, not
+ * directly by drivers. See SF-114946-SW.) NOTE - The only sub-operation
+ * allowed in an adapter bound to a TSA controller from the local host is
+ * OP_GET_CACHED_VERSION. All other sub-operations are prohibited.
+ */
+#define MC_CMD_MANAGE_SECURITY_RULESET_CACHE 0x11a
+#undef MC_CMD_0x11a_PRIVILEGE_CTG
+
+#define MC_CMD_0x11a_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN msgrequest */
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_LEN 4
+/* the operation to perform */
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_OFST 0
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_LEN 4
+/* enum: reports the ruleset version that is cached in persistent storage but
+ * performs no other action
+ */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_GET_CACHED_VERSION 0x0
+/* enum: rolls back the active state to the cached version. (May fail with
+ * ENOENT if there is no valid cached version.)
+ */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_ROLLBACK 0x1
+/* enum: commits the active state to the persistent cache */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_COMMIT 0x2
+/* enum: invalidates the persistent cache without affecting the active state */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_IN_OP_INVALIDATE 0x3
+
+/* MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT msgresponse */
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_LENMIN 5
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_LENMAX 252
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_LEN(num) (4+1*(num))
+#define    MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_NUM(len) (((len)-4)/1)
+/* indicates whether the persistent cache is valid (after completion of the
+ * requested operation in the case of rollback, commit, or invalidate)
+ */
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_STATE_OFST 0
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_STATE_LEN 4
+/* enum: persistent cache is invalid (the VERSION field will be empty in this
+ * case)
+ */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_STATE_INVALID 0x0
+/* enum: persistent cache is valid */
+#define          MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_STATE_VALID 0x1
+/* cached ruleset version (after completion of the requested operation, in the
+ * case of rollback, commit, or invalidate) as an opaque hash value in the same
+ * form as MC_CMD_GET_SECURITY_RULESET_VERSION_OUT_VERSION
+ */
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_OFST 4
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_LEN 1
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_MINNUM 1
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_MAXNUM 248
+#define       MC_CMD_MANAGE_SECURITY_RULESET_CACHE_OUT_VERSION_MAXNUM_MCDI2 1016
+
+
 /***********************************/
 /* MC_CMD_NVRAM_PRIVATE_APPEND
  * Append a single TLV to the MC_USAGE_TLV partition. Returns MC_CMD_ERR_EEXIST
@@ -23087,7 +25048,7 @@
 #define MC_CMD_NVRAM_PRIVATE_APPEND 0x11c
 #undef MC_CMD_0x11c_PRIVILEGE_CTG
 
-#define MC_CMD_0x11c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+#define MC_CMD_0x11c_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
 
 /* MC_CMD_NVRAM_PRIVATE_APPEND_IN msgrequest */
 #define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_LENMIN 9
@@ -23409,6 +25370,38 @@
 #define    MC_CMD_DEALLOCATE_TX_VFIFO_CP_OUT_LEN 0
 
 
+/***********************************/
+/* MC_CMD_REKEY
+ * This request causes the NIC to generate a new per-NIC key and program it
+ * into the write-once memory. During the process all flash partitions that are
+ * protected with a CMAC are verified with the old per-NIC key and then signed
+ * with the new per-NIC key. If the NIC has already reached its rekey limit the
+ * REKEY op will return MC_CMD_ERR_ERANGE. The REKEY op may block until
+ * completion or it may return 0 and continue processing, therefore the caller
+ * must poll at least once to confirm that the rekeying has completed. The POLL
+ * operation returns MC_CMD_ERR_EBUSY if the rekey process is still running
+ * otherwise it will return the result of the last completed rekey operation,
+ * or 0 if there has not been a previous rekey.
+ */
+#define MC_CMD_REKEY 0x123
+#undef MC_CMD_0x123_PRIVILEGE_CTG
+
+#define MC_CMD_0x123_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_REKEY_IN msgrequest */
+#define    MC_CMD_REKEY_IN_LEN 4
+/* the type of operation requested */
+#define       MC_CMD_REKEY_IN_OP_OFST 0
+#define       MC_CMD_REKEY_IN_OP_LEN 4
+/* enum: Start the rekeying operation */
+#define          MC_CMD_REKEY_IN_OP_REKEY 0x0
+/* enum: Poll for completion of the rekeying operation */
+#define          MC_CMD_REKEY_IN_OP_POLL 0x1
+
+/* MC_CMD_REKEY_OUT msgresponse */
+#define    MC_CMD_REKEY_OUT_LEN 0
+
+
 /***********************************/
 /* MC_CMD_SWITCH_GET_UNASSIGNED_BUFFERS
  * This interface allows the host to find out how many common pool buffers are
@@ -23432,6 +25425,945 @@
 #define       MC_CMD_SWITCH_GET_UNASSIGNED_BUFFERS_OUT_ENG_LEN 4
 
 
+/***********************************/
+/* MC_CMD_SET_SECURITY_FUSES
+ * Change the security level of the adapter by setting bits in the write-once
+ * memory. The firmware maps each flag in the message to a set of one or more
+ * hardware-defined or software-defined bits and sets these bits in the write-
+ * once memory. For Medford the hardware-defined bits are defined in
+ * SF-112079-PS 5.3, the software-defined bits are defined in xpm.h. Returns 0
+ * if all of the required bits were set and returns MC_CMD_ERR_EIO if any of
+ * the required bits were not set.
+ */
+#define MC_CMD_SET_SECURITY_FUSES 0x126
+#undef MC_CMD_0x126_PRIVILEGE_CTG
+
+#define MC_CMD_0x126_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SET_SECURITY_FUSES_IN msgrequest */
+#define    MC_CMD_SET_SECURITY_FUSES_IN_LEN 4
+/* Flags specifying what type of security features are being set */
+#define       MC_CMD_SET_SECURITY_FUSES_IN_FLAGS_OFST 0
+#define       MC_CMD_SET_SECURITY_FUSES_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SECURE_BOOT_OFST 0
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SECURE_BOOT_LBN 0
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SECURE_BOOT_WIDTH 1
+#define        MC_CMD_SET_SECURITY_FUSES_IN_REJECT_TEST_SIGNED_OFST 0
+#define        MC_CMD_SET_SECURITY_FUSES_IN_REJECT_TEST_SIGNED_LBN 1
+#define        MC_CMD_SET_SECURITY_FUSES_IN_REJECT_TEST_SIGNED_WIDTH 1
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SOFT_CONFIG_OFST 0
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SOFT_CONFIG_LBN 31
+#define        MC_CMD_SET_SECURITY_FUSES_IN_SOFT_CONFIG_WIDTH 1
+
+/* MC_CMD_SET_SECURITY_FUSES_OUT msgresponse */
+#define    MC_CMD_SET_SECURITY_FUSES_OUT_LEN 0
+
+/* MC_CMD_SET_SECURITY_FUSES_V2_OUT msgresponse */
+#define    MC_CMD_SET_SECURITY_FUSES_V2_OUT_LEN 4
+/* Flags specifying which security features are enforced on the NIC after the
+ * flags in the request have been applied. See
+ * MC_CMD_SET_SECURITY_FUSES_IN/FLAGS for flag definitions.
+ */
+#define       MC_CMD_SET_SECURITY_FUSES_V2_OUT_FLAGS_OFST 0
+#define       MC_CMD_SET_SECURITY_FUSES_V2_OUT_FLAGS_LEN 4
+
+
+/***********************************/
+/* MC_CMD_TSA_INFO
+ * Messages sent from TSA adapter to TSA controller. This command is only valid
+ * when the MCDI header has MESSAGE_TYPE set to MCDI_MESSAGE_TYPE_TSA. This
+ * command is not sent by the driver to the MC; it is sent from the MC to a TSA
+ * controller, being treated more like an alert message rather than a command;
+ * hence the MC does not expect a response in return. Doxbox reference
+ * SF-117371-SW
+ */
+#define MC_CMD_TSA_INFO 0x127
+#undef MC_CMD_0x127_PRIVILEGE_CTG
+
+#define MC_CMD_0x127_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSA_INFO_IN msgrequest */
+#define    MC_CMD_TSA_INFO_IN_LEN 4
+#define       MC_CMD_TSA_INFO_IN_OP_HDR_OFST 0
+#define       MC_CMD_TSA_INFO_IN_OP_HDR_LEN 4
+#define        MC_CMD_TSA_INFO_IN_OP_OFST 0
+#define        MC_CMD_TSA_INFO_IN_OP_LBN 0
+#define        MC_CMD_TSA_INFO_IN_OP_WIDTH 16
+/* enum: Information about recently discovered local IP address of the adapter
+ */
+#define          MC_CMD_TSA_INFO_OP_LOCAL_IP 0x1
+/* enum: Information about a sampled packet that either - did not match any
+ * black/white-list filters and was allowed by the default filter or - did not
+ * match any black/white-list filters and was denied by the default filter
+ */
+#define          MC_CMD_TSA_INFO_OP_PKT_SAMPLE 0x2
+/* enum: Information about an unbind or decommission attempt. */
+#define          MC_CMD_TSA_INFO_OP_UNBIND 0x3
+
+/* MC_CMD_TSA_INFO_IN_LOCAL_IP msgrequest:
+ *
+ * The TSA controller maintains a list of IP addresses valid for each port of a
+ * TSA adapter. The TSA controller requires information from the adapter
+ * inorder to learn new IP addresses assigned to a physical port and to
+ * identify those that are no longer assigned to the physical port. For this
+ * purpose, the TSA adapter snoops ARP replys, gratuitous ARP requests and ARP
+ * probe packets seen on each physical port. This definition describes the
+ * format of the notification message sent from a TSA adapter to a TSA
+ * controller related to any information related to a change in IP address
+ * assignment for a port. Doxbox reference SF-117371.
+ *
+ * There may be a possibility of combining multiple notifications in a single
+ * message in future. When that happens, a new flag can be defined using the
+ * reserved bits to describe the extended format of this notification.
+ */
+#define    MC_CMD_TSA_INFO_IN_LOCAL_IP_LEN 18
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_OP_HDR_OFST 0
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_OP_HDR_LEN 4
+/* Additional metadata describing the IP address information such as source of
+ * information retrieval, type of IP address, physical port number.
+ */
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_META_OFST 4
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_META_LEN 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_PORT_INDEX_OFST 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_PORT_INDEX_LBN 0
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_PORT_INDEX_WIDTH 8
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED_OFST 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED_LBN 8
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED_WIDTH 8
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_REASON_OFST 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_REASON_LBN 16
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_REASON_WIDTH 8
+/* enum: ARP reply sent out of the physical port */
+#define          MC_CMD_TSA_INFO_IP_REASON_TX_ARP 0x0
+/* enum: ARP probe packet received on the physical port */
+#define          MC_CMD_TSA_INFO_IP_REASON_RX_ARP_PROBE 0x1
+/* enum: Gratuitous ARP packet received on the physical port */
+#define          MC_CMD_TSA_INFO_IP_REASON_RX_GRATUITOUS_ARP 0x2
+/* enum: DHCP ACK packet received on the physical port */
+#define          MC_CMD_TSA_INFO_IP_REASON_RX_DHCP_ACK 0x3
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_IPV4_OFST 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_IPV4_LBN 24
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_META_IPV4_WIDTH 1
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED1_OFST 4
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED1_LBN 25
+#define        MC_CMD_TSA_INFO_IN_LOCAL_IP_RESERVED1_WIDTH 7
+/* IPV4 address retrieved from the sampled packets. This field is relevant only
+ * when META_IPV4 is set to 1.
+ */
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_IPV4_ADDR_OFST 8
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_IPV4_ADDR_LEN 4
+/* Target MAC address retrieved from the sampled packet. */
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_MAC_ADDR_OFST 12
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_MAC_ADDR_LEN 1
+#define       MC_CMD_TSA_INFO_IN_LOCAL_IP_MAC_ADDR_NUM 6
+
+/* MC_CMD_TSA_INFO_IN_PKT_SAMPLE msgrequest:
+ *
+ * It is desireable for the TSA controller to learn the traffic pattern of
+ * packets seen at the network port being monitored. In order to learn about
+ * the traffic pattern, the TSA controller may want to sample packets seen at
+ * the network port. Based on the packet samples that the TSA controller
+ * receives from the adapter, the controller may choose to configure additional
+ * black-list or white-list rules to allow or block packets as required.
+ *
+ * Although the entire sampled packet as seen on the network port is available
+ * to the MC the length of sampled packet sent to controller is restricted by
+ * MCDI payload size. Besides, the TSA controller does not require the entire
+ * packet to make decisions about filter updates. Hence the packet sample being
+ * passed to the controller is truncated to 128 bytes. This length is large
+ * enough to hold the ethernet header, IP header and maximum length of
+ * supported L4 protocol headers (IPv4 only, but can hold IPv6 header too, if
+ * required in future).
+ *
+ * The intention is that any future changes to this message format that are not
+ * backwards compatible will be defined with a new operation code.
+ */
+#define    MC_CMD_TSA_INFO_IN_PKT_SAMPLE_LEN 136
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_OP_HDR_OFST 0
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_OP_HDR_LEN 4
+/* Additional metadata describing the sampled packet */
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_OFST 4
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_LEN 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_PORT_INDEX_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_PORT_INDEX_LBN 0
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_PORT_INDEX_WIDTH 8
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_DIRECTION_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_DIRECTION_LBN 8
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_DIRECTION_WIDTH 1
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_RESERVED_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_RESERVED_LBN 9
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_RESERVED_WIDTH 7
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_MASK_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_MASK_LBN 16
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_MASK_WIDTH 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_ALLOW_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_ALLOW_LBN 16
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_ALLOW_WIDTH 1
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_DENY_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_DENY_LBN 17
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_DENY_WIDTH 1
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_COUNT_OFST 4
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_COUNT_LBN 18
+#define        MC_CMD_TSA_INFO_IN_PKT_SAMPLE_META_ACTION_COUNT_WIDTH 1
+/* 128-byte raw prefix of the sampled packet which includes the ethernet
+ * header, IP header and L4 protocol header (only IPv4 supported initially).
+ * This provides the controller enough information about the packet sample to
+ * report traffic patterns seen on a network port and to make decisions
+ * concerning rule-set updates.
+ */
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_PACKET_DATA_OFST 8
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_PACKET_DATA_LEN 1
+#define       MC_CMD_TSA_INFO_IN_PKT_SAMPLE_PACKET_DATA_NUM 128
+
+/* MC_CMD_TSA_INFO_IN_UNBIND msgrequest: Information about an unbind or
+ * decommission attempt. The purpose of this event is to let the controller
+ * know about unbind and decommission attempts (both successful and failed)
+ * received from the adapter host. The event is not sent if the unbind or
+ * decommission request was received from the controller.
+ */
+#define    MC_CMD_TSA_INFO_IN_UNBIND_LEN 12
+#define       MC_CMD_TSA_INFO_IN_UNBIND_OP_HDR_OFST 0
+#define       MC_CMD_TSA_INFO_IN_UNBIND_OP_HDR_LEN 4
+#define        MC_CMD_TSA_INFO_IN_UNBIND_OP_OFST 0
+#define        MC_CMD_TSA_INFO_IN_UNBIND_OP_LBN 0
+#define        MC_CMD_TSA_INFO_IN_UNBIND_OP_WIDTH 16
+/* Type of the unbind attempt. */
+#define       MC_CMD_TSA_INFO_IN_UNBIND_TYPE_OFST 4
+#define       MC_CMD_TSA_INFO_IN_UNBIND_TYPE_LEN 4
+/* enum: This event is sent because MC_CMD_TSA_BIND_OP_SECURE_UNBIND was
+ * received from the adapter local host.
+ */
+#define          MC_CMD_TSA_INFO_UNBIND_TYPE_SECURE_UNBIND 0x1
+/* enum: This event is sent because MC_CMD_TSA_BIND_OP_SECURE_DECOMMISSION was
+ * received from the adapter local host.
+ */
+#define          MC_CMD_TSA_INFO_UNBIND_TYPE_SECURE_DECOMMISSION 0x2
+/* Result of the attempt. */
+#define       MC_CMD_TSA_INFO_IN_UNBIND_RESULT_OFST 8
+#define       MC_CMD_TSA_INFO_IN_UNBIND_RESULT_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_TSA_BIND/MC_CMD_TSA_BIND_OUT_SECURE_UNBIND/RESULT */
+
+/* MC_CMD_TSA_INFO_OUT msgresponse */
+#define    MC_CMD_TSA_INFO_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_HOST_INFO
+ * Commands to appply or retrieve host-related information from an adapter.
+ * Doxbox reference SF-117371-SW
+ */
+#define MC_CMD_HOST_INFO 0x128
+#undef MC_CMD_0x128_PRIVILEGE_CTG
+
+#define MC_CMD_0x128_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_HOST_INFO_IN msgrequest */
+#define    MC_CMD_HOST_INFO_IN_LEN 4
+/* sub-operation code info */
+#define       MC_CMD_HOST_INFO_IN_OP_HDR_OFST 0
+#define       MC_CMD_HOST_INFO_IN_OP_HDR_LEN 4
+#define        MC_CMD_HOST_INFO_IN_OP_OFST 0
+#define        MC_CMD_HOST_INFO_IN_OP_LBN 0
+#define        MC_CMD_HOST_INFO_IN_OP_WIDTH 16
+/* enum: Read a 16-byte unique host identifier from the adapter. This UUID
+ * helps to identify the host that an adapter is plugged into. This identifier
+ * is ideally the system UUID retrieved and set by the UEFI driver. If the UEFI
+ * driver is unable to extract the system UUID, it would still set a random
+ * 16-byte value into each supported SF adapter plugged into it. Host UUIDs may
+ * change if the system is power-cycled, however, they persist across adapter
+ * resets. If the host UUID was not set on an adapter, due to an unsupported
+ * version of UEFI driver, then this command returns an error. Doxbox reference
+ * - SF-117371-SW section 'Host UUID'.
+ */
+#define          MC_CMD_HOST_INFO_OP_GET_UUID 0x0
+/* enum: Set a 16-byte unique host identifier on the adapter to identify the
+ * host that the adapter is plugged into. See MC_CMD_HOST_INFO_OP_GET_UUID for
+ * further details.
+ */
+#define          MC_CMD_HOST_INFO_OP_SET_UUID 0x1
+
+/* MC_CMD_HOST_INFO_IN_GET_UUID msgrequest */
+#define    MC_CMD_HOST_INFO_IN_GET_UUID_LEN 4
+/* sub-operation code info */
+#define       MC_CMD_HOST_INFO_IN_GET_UUID_OP_HDR_OFST 0
+#define       MC_CMD_HOST_INFO_IN_GET_UUID_OP_HDR_LEN 4
+
+/* MC_CMD_HOST_INFO_OUT_GET_UUID msgresponse */
+#define    MC_CMD_HOST_INFO_OUT_GET_UUID_LEN 16
+/* 16-byte host UUID read out of the adapter. See MC_CMD_HOST_INFO_OP_GET_UUID
+ * for further details.
+ */
+#define       MC_CMD_HOST_INFO_OUT_GET_UUID_HOST_UUID_OFST 0
+#define       MC_CMD_HOST_INFO_OUT_GET_UUID_HOST_UUID_LEN 1
+#define       MC_CMD_HOST_INFO_OUT_GET_UUID_HOST_UUID_NUM 16
+
+/* MC_CMD_HOST_INFO_IN_SET_UUID msgrequest */
+#define    MC_CMD_HOST_INFO_IN_SET_UUID_LEN 20
+/* sub-operation code info */
+#define       MC_CMD_HOST_INFO_IN_SET_UUID_OP_HDR_OFST 0
+#define       MC_CMD_HOST_INFO_IN_SET_UUID_OP_HDR_LEN 4
+/* 16-byte host UUID set on the adapter. See MC_CMD_HOST_INFO_OP_GET_UUID for
+ * further details.
+ */
+#define       MC_CMD_HOST_INFO_IN_SET_UUID_HOST_UUID_OFST 4
+#define       MC_CMD_HOST_INFO_IN_SET_UUID_HOST_UUID_LEN 1
+#define       MC_CMD_HOST_INFO_IN_SET_UUID_HOST_UUID_NUM 16
+
+/* MC_CMD_HOST_INFO_OUT_SET_UUID msgresponse */
+#define    MC_CMD_HOST_INFO_OUT_SET_UUID_LEN 0
+
+
+/***********************************/
+/* MC_CMD_TSAN_INFO
+ * Get TSA adapter information. TSA controllers query each TSA adapter to learn
+ * some configuration parameters of each adapter. Doxbox reference SF-117371-SW
+ * section 'Adapter Information'
+ */
+#define MC_CMD_TSAN_INFO 0x129
+#undef MC_CMD_0x129_PRIVILEGE_CTG
+
+#define MC_CMD_0x129_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_TSAN_INFO_IN msgrequest */
+#define    MC_CMD_TSAN_INFO_IN_LEN 4
+/* sub-operation code info */
+#define       MC_CMD_TSAN_INFO_IN_OP_HDR_OFST 0
+#define       MC_CMD_TSAN_INFO_IN_OP_HDR_LEN 4
+#define        MC_CMD_TSAN_INFO_IN_OP_OFST 0
+#define        MC_CMD_TSAN_INFO_IN_OP_LBN 0
+#define        MC_CMD_TSAN_INFO_IN_OP_WIDTH 16
+/* enum: Read configuration parameters and IDs that uniquely identify an
+ * adapter. The parameters include - host identification, adapter
+ * identification string and number of physical ports on the adapter.
+ */
+#define          MC_CMD_TSAN_INFO_OP_GET_CFG 0x0
+
+/* MC_CMD_TSAN_INFO_IN_GET_CFG msgrequest */
+#define    MC_CMD_TSAN_INFO_IN_GET_CFG_LEN 4
+/* sub-operation code info */
+#define       MC_CMD_TSAN_INFO_IN_GET_CFG_OP_HDR_OFST 0
+#define       MC_CMD_TSAN_INFO_IN_GET_CFG_OP_HDR_LEN 4
+
+/* MC_CMD_TSAN_INFO_OUT_GET_CFG msgresponse */
+#define    MC_CMD_TSAN_INFO_OUT_GET_CFG_LEN 26
+/* Information about the configuration parameters returned in this response. */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_CONFIG_WORD_OFST 0
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_CONFIG_WORD_LEN 4
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_CAP_FLAGS_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_CAP_FLAGS_LBN 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_CAP_FLAGS_WIDTH 16
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_FLAG_HOST_UUID_VALID_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_FLAG_HOST_UUID_VALID_LBN 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_FLAG_HOST_UUID_VALID_WIDTH 1
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_NUM_PORTS_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_NUM_PORTS_LBN 16
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_NUM_PORTS_WIDTH 8
+/* 16-byte host UUID read out of the adapter. See MC_CMD_HOST_INFO_OP_GET_UUID
+ * for further details.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_HOST_UUID_OFST 4
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_HOST_UUID_LEN 1
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_HOST_UUID_NUM 16
+/* A unique identifier per adapter. The base MAC address of the card is used
+ * for this purpose.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_GUID_OFST 20
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_GUID_LEN 1
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_GUID_NUM 6
+
+/* MC_CMD_TSAN_INFO_OUT_GET_CFG_V2 msgresponse */
+#define    MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_LEN 36
+/* Information about the configuration parameters returned in this response. */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_CONFIG_WORD_OFST 0
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_CONFIG_WORD_LEN 4
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_CAP_FLAGS_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_CAP_FLAGS_LBN 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_CAP_FLAGS_WIDTH 16
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_FLAG_HOST_UUID_VALID_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_FLAG_HOST_UUID_VALID_LBN 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_FLAG_HOST_UUID_VALID_WIDTH 1
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_NUM_PORTS_OFST 0
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_NUM_PORTS_LBN 16
+#define        MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_NUM_PORTS_WIDTH 8
+/* 16-byte host UUID read out of the adapter. See MC_CMD_HOST_INFO_OP_GET_UUID
+ * for further details.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_HOST_UUID_OFST 4
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_HOST_UUID_LEN 1
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_HOST_UUID_NUM 16
+/* A unique identifier per adapter. The base MAC address of the card is used
+ * for this purpose.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_GUID_OFST 20
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_GUID_LEN 1
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_GUID_NUM 6
+/* Unused bytes, defined for 32-bit alignment of new fields. */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_UNUSED_OFST 26
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_UNUSED_LEN 2
+/* Maximum number of TSA statistics counters in each direction of dataflow
+ * supported on the card. Note that the statistics counters are always
+ * allocated in pairs, i.e. a counter ID is associated with one Tx and one Rx
+ * counter.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_MAX_STATS_OFST 28
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_MAX_STATS_LEN 4
+/* Width of each statistics counter (represented in bits). This gives an
+ * indication of wrap point to the user.
+ */
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_STATS_WIDTH_OFST 32
+#define       MC_CMD_TSAN_INFO_OUT_GET_CFG_V2_STATS_WIDTH_LEN 4
+
+
+/***********************************/
+/* MC_CMD_TSA_STATISTICS
+ * TSA adapter statistics operations.
+ */
+#define MC_CMD_TSA_STATISTICS 0x130
+#undef MC_CMD_0x130_PRIVILEGE_CTG
+
+#define MC_CMD_0x130_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSA_STATISTICS_IN msgrequest */
+#define    MC_CMD_TSA_STATISTICS_IN_LEN 4
+/* TSA statistics sub-operation code */
+#define       MC_CMD_TSA_STATISTICS_IN_OP_CODE_OFST 0
+#define       MC_CMD_TSA_STATISTICS_IN_OP_CODE_LEN 4
+/* enum: Get the configuration parameters that describe the TSA statistics
+ * layout on the adapter.
+ */
+#define          MC_CMD_TSA_STATISTICS_OP_GET_CONFIG 0x0
+/* enum: Read and/or clear TSA statistics counters. */
+#define          MC_CMD_TSA_STATISTICS_OP_READ_CLEAR 0x1
+
+/* MC_CMD_TSA_STATISTICS_IN_GET_CONFIG msgrequest */
+#define    MC_CMD_TSA_STATISTICS_IN_GET_CONFIG_LEN 4
+/* TSA statistics sub-operation code */
+#define       MC_CMD_TSA_STATISTICS_IN_GET_CONFIG_OP_CODE_OFST 0
+#define       MC_CMD_TSA_STATISTICS_IN_GET_CONFIG_OP_CODE_LEN 4
+
+/* MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG msgresponse */
+#define    MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG_LEN 8
+/* Maximum number of TSA statistics counters in each direction of dataflow
+ * supported on the card. Note that the statistics counters are always
+ * allocated in pairs, i.e. a counter ID is associated with one Tx and one Rx
+ * counter.
+ */
+#define       MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG_MAX_STATS_OFST 0
+#define       MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG_MAX_STATS_LEN 4
+/* Width of each statistics counter (represented in bits). This gives an
+ * indication of wrap point to the user.
+ */
+#define       MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG_STATS_WIDTH_OFST 4
+#define       MC_CMD_TSA_STATISTICS_OUT_GET_CONFIG_STATS_WIDTH_LEN 4
+
+/* MC_CMD_TSA_STATISTICS_IN_READ_CLEAR msgrequest */
+#define    MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_LENMIN 20
+#define    MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_LENMAX 252
+#define    MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_LEN(num) (16+4*(num))
+#define    MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_NUM(len) (((len)-16)/4)
+/* TSA statistics sub-operation code */
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_OP_CODE_OFST 0
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_OP_CODE_LEN 4
+/* Parameters describing the statistics operation */
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_FLAGS_OFST 4
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_FLAGS_LEN 4
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_READ_OFST 4
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_READ_LBN 0
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_READ_WIDTH 1
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_CLEAR_OFST 4
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_CLEAR_LBN 1
+#define        MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_CLEAR_WIDTH 1
+/* Counter ID list specification type */
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_MODE_OFST 8
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_MODE_LEN 4
+/* enum: The statistics counters are specified as an unordered list of
+ * individual counter ID.
+ */
+#define          MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_LIST 0x0
+/* enum: The statistics counters are specified as a range of consecutive
+ * counter IDs.
+ */
+#define          MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_RANGE 0x1
+/* Number of statistics counters */
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_NUM_STATS_OFST 12
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_NUM_STATS_LEN 4
+/* Counter IDs to be read/cleared. When mode is set to LIST, this entry holds a
+ * list of counter IDs to be operated on. When mode is set to RANGE, this entry
+ * holds a single counter ID representing the start of the range of counter IDs
+ * to be operated on.
+ */
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_OFST 16
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_LEN 4
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_MINNUM 1
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_MAXNUM 59
+#define       MC_CMD_TSA_STATISTICS_IN_READ_CLEAR_COUNTER_ID_MAXNUM_MCDI2 251
+
+/* MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR msgresponse */
+#define    MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_LENMIN 24
+#define    MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_LENMAX 248
+#define    MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_LENMAX_MCDI2 1016
+#define    MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_LEN(num) (8+16*(num))
+#define    MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_NUM(len) (((len)-8)/16)
+/* Number of statistics counters returned in this response */
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_NUM_STATS_OFST 0
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_NUM_STATS_LEN 4
+/* MC_TSA_STATISTICS_ENTRY Note that this field is expected to start at a
+ * 64-bit aligned offset
+ */
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_OFST 8
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_LEN 16
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_MINNUM 1
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_MAXNUM 15
+#define       MC_CMD_TSA_STATISTICS_OUT_READ_CLEAR_STATS_COUNTERS_MAXNUM_MCDI2 63
+
+/* MC_TSA_STATISTICS_ENTRY structuredef */
+#define    MC_TSA_STATISTICS_ENTRY_LEN 16
+/* Tx statistics counter */
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_OFST 0
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LEN 8
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LO_OFST 0
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LO_LEN 4
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LO_LBN 0
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LO_WIDTH 32
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_HI_OFST 4
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_HI_LEN 4
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_HI_LBN 32
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_HI_WIDTH 32
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_LBN 0
+#define       MC_TSA_STATISTICS_ENTRY_TX_STAT_WIDTH 64
+/* Rx statistics counter */
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_OFST 8
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LEN 8
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LO_OFST 8
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LO_LEN 4
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LO_LBN 64
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LO_WIDTH 32
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_HI_OFST 12
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_HI_LEN 4
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_HI_LBN 96
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_HI_WIDTH 32
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_LBN 64
+#define       MC_TSA_STATISTICS_ENTRY_RX_STAT_WIDTH 64
+
+
+/***********************************/
+/* MC_CMD_ERASE_INITIAL_NIC_SECRET
+ * This request causes the NIC to find the initial NIC secret (programmed
+ * during ATE) in XPM memory and if and only if the NIC has already been
+ * rekeyed with MC_CMD_REKEY, erase it. This is used by manftest after
+ * installing TSA binding certificates. See SF-117631-TC.
+ */
+#define MC_CMD_ERASE_INITIAL_NIC_SECRET 0x131
+#undef MC_CMD_0x131_PRIVILEGE_CTG
+
+#define MC_CMD_0x131_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_ERASE_INITIAL_NIC_SECRET_IN msgrequest */
+#define    MC_CMD_ERASE_INITIAL_NIC_SECRET_IN_LEN 0
+
+/* MC_CMD_ERASE_INITIAL_NIC_SECRET_OUT msgresponse */
+#define    MC_CMD_ERASE_INITIAL_NIC_SECRET_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_TSA_CONFIG
+ * TSA adapter configuration operations. This command is used to prepare the
+ * NIC for TSA binding.
+ */
+#define MC_CMD_TSA_CONFIG 0x64
+#undef MC_CMD_0x64_PRIVILEGE_CTG
+
+#define MC_CMD_0x64_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_TSA_CONFIG_IN msgrequest */
+#define    MC_CMD_TSA_CONFIG_IN_LEN 4
+/* TSA configuration sub-operation code */
+#define       MC_CMD_TSA_CONFIG_IN_OP_OFST 0
+#define       MC_CMD_TSA_CONFIG_IN_OP_LEN 4
+/* enum: Append a single item to the tsa_config partition. Items will be
+ * encrypted unless they are declared as non-sensitive. Returns
+ * MC_CMD_ERR_EEXIST if the tag is already present.
+ */
+#define          MC_CMD_TSA_CONFIG_OP_APPEND 0x1
+/* enum: Reset the tsa_config partition to a clean state. */
+#define          MC_CMD_TSA_CONFIG_OP_RESET 0x2
+/* enum: Read back a configured item from tsa_config partition. Returns
+ * MC_CMD_ERR_ENOENT if the item doesn't exist, or MC_CMD_ERR_EPERM if the item
+ * is declared as sensitive (i.e. is encrypted).
+ */
+#define          MC_CMD_TSA_CONFIG_OP_READ 0x3
+
+/* MC_CMD_TSA_CONFIG_IN_APPEND msgrequest */
+#define    MC_CMD_TSA_CONFIG_IN_APPEND_LENMIN 12
+#define    MC_CMD_TSA_CONFIG_IN_APPEND_LENMAX 252
+#define    MC_CMD_TSA_CONFIG_IN_APPEND_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_CONFIG_IN_APPEND_LEN(num) (12+1*(num))
+#define    MC_CMD_TSA_CONFIG_IN_APPEND_DATA_NUM(len) (((len)-12)/1)
+/* TSA configuration sub-operation code. The value shall be
+ * MC_CMD_TSA_CONFIG_OP_APPEND.
+ */
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_OP_OFST 0
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_OP_LEN 4
+/* The tag to be appended */
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_TAG_OFST 4
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_TAG_LEN 4
+/* The length of the data in bytes */
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_LENGTH_OFST 8
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_LENGTH_LEN 4
+/* The item data */
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_DATA_OFST 12
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_DATA_LEN 1
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_DATA_MINNUM 0
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_DATA_MAXNUM 240
+#define       MC_CMD_TSA_CONFIG_IN_APPEND_DATA_MAXNUM_MCDI2 1008
+
+/* MC_CMD_TSA_CONFIG_OUT_APPEND msgresponse */
+#define    MC_CMD_TSA_CONFIG_OUT_APPEND_LEN 0
+
+/* MC_CMD_TSA_CONFIG_IN_RESET msgrequest */
+#define    MC_CMD_TSA_CONFIG_IN_RESET_LEN 4
+/* TSA configuration sub-operation code. The value shall be
+ * MC_CMD_TSA_CONFIG_OP_RESET.
+ */
+#define       MC_CMD_TSA_CONFIG_IN_RESET_OP_OFST 0
+#define       MC_CMD_TSA_CONFIG_IN_RESET_OP_LEN 4
+
+/* MC_CMD_TSA_CONFIG_OUT_RESET msgresponse */
+#define    MC_CMD_TSA_CONFIG_OUT_RESET_LEN 0
+
+/* MC_CMD_TSA_CONFIG_IN_READ msgrequest */
+#define    MC_CMD_TSA_CONFIG_IN_READ_LEN 8
+/* TSA configuration sub-operation code. The value shall be
+ * MC_CMD_TSA_CONFIG_OP_READ.
+ */
+#define       MC_CMD_TSA_CONFIG_IN_READ_OP_OFST 0
+#define       MC_CMD_TSA_CONFIG_IN_READ_OP_LEN 4
+/* The tag to be read */
+#define       MC_CMD_TSA_CONFIG_IN_READ_TAG_OFST 4
+#define       MC_CMD_TSA_CONFIG_IN_READ_TAG_LEN 4
+
+/* MC_CMD_TSA_CONFIG_OUT_READ msgresponse */
+#define    MC_CMD_TSA_CONFIG_OUT_READ_LENMIN 8
+#define    MC_CMD_TSA_CONFIG_OUT_READ_LENMAX 252
+#define    MC_CMD_TSA_CONFIG_OUT_READ_LENMAX_MCDI2 1020
+#define    MC_CMD_TSA_CONFIG_OUT_READ_LEN(num) (8+1*(num))
+#define    MC_CMD_TSA_CONFIG_OUT_READ_DATA_NUM(len) (((len)-8)/1)
+/* The tag that was read */
+#define       MC_CMD_TSA_CONFIG_OUT_READ_TAG_OFST 0
+#define       MC_CMD_TSA_CONFIG_OUT_READ_TAG_LEN 4
+/* The length of the data in bytes */
+#define       MC_CMD_TSA_CONFIG_OUT_READ_LENGTH_OFST 4
+#define       MC_CMD_TSA_CONFIG_OUT_READ_LENGTH_LEN 4
+/* The data of the item. */
+#define       MC_CMD_TSA_CONFIG_OUT_READ_DATA_OFST 8
+#define       MC_CMD_TSA_CONFIG_OUT_READ_DATA_LEN 1
+#define       MC_CMD_TSA_CONFIG_OUT_READ_DATA_MINNUM 0
+#define       MC_CMD_TSA_CONFIG_OUT_READ_DATA_MAXNUM 244
+#define       MC_CMD_TSA_CONFIG_OUT_READ_DATA_MAXNUM_MCDI2 1012
+
+/* MC_TSA_IPV4_ITEM structuredef */
+#define    MC_TSA_IPV4_ITEM_LEN 8
+/* Additional metadata describing the IP address information such as the
+ * physical port number the address is being used on. Unused space in this
+ * field is reserved for future expansion.
+ */
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_META_OFST 0
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_META_LEN 4
+#define        MC_TSA_IPV4_ITEM_PORT_IDX_OFST 0
+#define        MC_TSA_IPV4_ITEM_PORT_IDX_LBN 0
+#define        MC_TSA_IPV4_ITEM_PORT_IDX_WIDTH 8
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_META_LBN 0
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_META_WIDTH 32
+/* The IPv4 address in little endian byte order. */
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_OFST 4
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_LEN 4
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_LBN 32
+#define       MC_TSA_IPV4_ITEM_IPV4_ADDR_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_TSA_IPADDR
+ * TSA operations relating to the monitoring and expiry of local IP addresses
+ * discovered by the controller. These commands are sent from a TSA controller
+ * to a TSA adapter.
+ */
+#define MC_CMD_TSA_IPADDR 0x65
+#undef MC_CMD_0x65_PRIVILEGE_CTG
+
+#define MC_CMD_0x65_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSA_IPADDR_IN msgrequest */
+#define    MC_CMD_TSA_IPADDR_IN_LEN 4
+/* Header containing information to identify which sub-operation of this
+ * command to perform. The header contains a 16-bit op-code. Unused space in
+ * this field is reserved for future expansion.
+ */
+#define       MC_CMD_TSA_IPADDR_IN_OP_HDR_OFST 0
+#define       MC_CMD_TSA_IPADDR_IN_OP_HDR_LEN 4
+#define        MC_CMD_TSA_IPADDR_IN_OP_OFST 0
+#define        MC_CMD_TSA_IPADDR_IN_OP_LBN 0
+#define        MC_CMD_TSA_IPADDR_IN_OP_WIDTH 16
+/* enum: Request that the adapter verifies that the IPv4 addresses supplied are
+ * still in use by the host by sending ARP probes to the host. The MC does not
+ * wait for a response to the probes and sends an MCDI response to the
+ * controller once the probes have been sent to the host. The response to the
+ * probes (if there are any) will be forwarded to the controller using
+ * MC_CMD_TSA_INFO alerts.
+ */
+#define          MC_CMD_TSA_IPADDR_OP_VALIDATE_IPV4 0x1
+/* enum: Notify the adapter that one or more IPv4 addresses are no longer valid
+ * for the host of the adapter. The adapter should remove the IPv4 addresses
+ * from its local cache.
+ */
+#define          MC_CMD_TSA_IPADDR_OP_REMOVE_IPV4 0x2
+
+/* MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4 msgrequest */
+#define    MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_LENMIN 16
+#define    MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_LENMAX 248
+#define    MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_LENMAX_MCDI2 1016
+#define    MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_LEN(num) (8+8*(num))
+#define    MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_NUM(len) (((len)-8)/8)
+/* Header containing information to identify which sub-operation of this
+ * command to perform. The header contains a 16-bit op-code. Unused space in
+ * this field is reserved for future expansion.
+ */
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_OP_HDR_OFST 0
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_OP_HDR_LEN 4
+#define        MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_OP_OFST 0
+#define        MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_OP_LBN 0
+#define        MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_OP_WIDTH 16
+/* Number of IPv4 addresses to validate. */
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_NUM_ITEMS_OFST 4
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_NUM_ITEMS_LEN 4
+/* The IPv4 addresses to validate, in struct MC_TSA_IPV4_ITEM format. */
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_OFST 8
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_LEN 8
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_LO_OFST 8
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_LO_LEN 4
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_LO_LBN 64
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_LO_WIDTH 32
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_HI_OFST 12
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_HI_LEN 4
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_HI_LBN 96
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_HI_WIDTH 32
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_MINNUM 1
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_MAXNUM 30
+#define       MC_CMD_TSA_IPADDR_IN_VALIDATE_IPV4_IPV4_ITEM_MAXNUM_MCDI2 126
+
+/* MC_CMD_TSA_IPADDR_OUT_VALIDATE_IPV4 msgresponse */
+#define    MC_CMD_TSA_IPADDR_OUT_VALIDATE_IPV4_LEN 0
+
+/* MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4 msgrequest */
+#define    MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_LENMIN 16
+#define    MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_LENMAX 248
+#define    MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_LENMAX_MCDI2 1016
+#define    MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_LEN(num) (8+8*(num))
+#define    MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_NUM(len) (((len)-8)/8)
+/* Header containing information to identify which sub-operation of this
+ * command to perform. The header contains a 16-bit op-code. Unused space in
+ * this field is reserved for future expansion.
+ */
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_OP_HDR_OFST 0
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_OP_HDR_LEN 4
+#define        MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_OP_OFST 0
+#define        MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_OP_LBN 0
+#define        MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_OP_WIDTH 16
+/* Number of IPv4 addresses to remove. */
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_NUM_ITEMS_OFST 4
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_NUM_ITEMS_LEN 4
+/* The IPv4 addresses that have expired, in struct MC_TSA_IPV4_ITEM format. */
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_OFST 8
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_LEN 8
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_LO_OFST 8
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_LO_LEN 4
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_LO_LBN 64
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_LO_WIDTH 32
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_HI_OFST 12
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_HI_LEN 4
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_HI_LBN 96
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_HI_WIDTH 32
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_MINNUM 1
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_MAXNUM 30
+#define       MC_CMD_TSA_IPADDR_IN_REMOVE_IPV4_IPV4_ITEM_MAXNUM_MCDI2 126
+
+/* MC_CMD_TSA_IPADDR_OUT_REMOVE_IPV4 msgresponse */
+#define    MC_CMD_TSA_IPADDR_OUT_REMOVE_IPV4_LEN 0
+
+
+/***********************************/
+/* MC_CMD_SECURE_NIC_INFO
+ * Get secure NIC information. While many of the features reported by these
+ * commands are related to TSA, they must be supported in firmware where TSA is
+ * disabled.
+ */
+#define MC_CMD_SECURE_NIC_INFO 0x132
+#undef MC_CMD_0x132_PRIVILEGE_CTG
+
+#define MC_CMD_0x132_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_SECURE_NIC_INFO_IN msgrequest */
+#define    MC_CMD_SECURE_NIC_INFO_IN_LEN 4
+/* sub-operation code info */
+#define       MC_CMD_SECURE_NIC_INFO_IN_OP_HDR_OFST 0
+#define       MC_CMD_SECURE_NIC_INFO_IN_OP_HDR_LEN 4
+#define        MC_CMD_SECURE_NIC_INFO_IN_OP_OFST 0
+#define        MC_CMD_SECURE_NIC_INFO_IN_OP_LBN 0
+#define        MC_CMD_SECURE_NIC_INFO_IN_OP_WIDTH 16
+/* enum: Get the status of various security settings, all signed along with a
+ * challenge chosen by the host.
+ */
+#define          MC_CMD_SECURE_NIC_INFO_OP_STATUS 0x0
+
+/* MC_CMD_SECURE_NIC_INFO_IN_STATUS msgrequest */
+#define    MC_CMD_SECURE_NIC_INFO_IN_STATUS_LEN 24
+/* sub-operation code, must be MC_CMD_SECURE_NIC_INFO_OP_STATUS */
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_OP_HDR_OFST 0
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_OP_HDR_LEN 4
+/* Type of key to be used to sign response. */
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_KEY_TYPE_OFST 4
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_KEY_TYPE_LEN 4
+#define          MC_CMD_SECURE_NIC_INFO_IN_STATUS_UNUSED 0x0 /* enum */
+/* enum: Solarflare adapter authentication key, installed by Manftest. */
+#define          MC_CMD_SECURE_NIC_INFO_IN_STATUS_SF_ADAPTER_AUTH 0x1
+/* enum: TSA binding key, installed after adapter is bound to a TSA controller.
+ * This is not supported in firmware which does not support TSA.
+ */
+#define          MC_CMD_SECURE_NIC_INFO_IN_STATUS_TSA_BINDING 0x2
+/* enum: Customer adapter authentication key. Installed by the customer in the
+ * field, but otherwise similar to the Solarflare adapter authentication key.
+ */
+#define          MC_CMD_SECURE_NIC_INFO_IN_STATUS_CUSTOMER_ADAPTER_AUTH 0x3
+/* Random challenge generated by the host. */
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_CHALLENGE_OFST 8
+#define       MC_CMD_SECURE_NIC_INFO_IN_STATUS_CHALLENGE_LEN 16
+
+/* MC_CMD_SECURE_NIC_INFO_OUT_STATUS msgresponse */
+#define    MC_CMD_SECURE_NIC_INFO_OUT_STATUS_LEN 420
+/* Length of the signature in MSG_SIGNATURE. */
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MSG_SIGNATURE_LEN_OFST 0
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MSG_SIGNATURE_LEN_LEN 4
+/* Signature over the message, starting at MESSAGE_TYPE and continuing to the
+ * end of the MCDI response, allowing the message format to be extended. The
+ * signature uses ECDSA 384 encoding in ASN.1 format. It has variable length,
+ * with a maximum of 384 bytes.
+ */
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MSG_SIGNATURE_OFST 4
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MSG_SIGNATURE_LEN 384
+/* Enum value indicating the type of response. This protects against chosen
+ * message attacks. The enum values are random rather than sequential to make
+ * it unlikely that values will be reused should other commands in a different
+ * namespace need to create signed messages.
+ */
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MESSAGE_TYPE_OFST 388
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_MESSAGE_TYPE_LEN 4
+/* enum: Message type value for the response to a
+ * MC_CMD_SECURE_NIC_INFO_IN_STATUS message.
+ */
+#define          MC_CMD_SECURE_NIC_INFO_STATUS 0xdb4
+/* The challenge provided by the host in the MC_CMD_SECURE_NIC_INFO_IN_STATUS
+ * message
+ */
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_CHALLENGE_OFST 392
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_CHALLENGE_LEN 16
+/* The first 32 bits of XPM memory, which include security and flag bits, die
+ * ID and chip ID revision. The meaning of these bits is defined in
+ * mc/include/mc/xpm.h in the firmwaresrc repository.
+ */
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_XPM_STATUS_BITS_OFST 408
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_XPM_STATUS_BITS_LEN 4
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_A_OFST 412
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_A_LEN 2
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_B_OFST 414
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_B_LEN 2
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_C_OFST 416
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_C_LEN 2
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_D_OFST 418
+#define       MC_CMD_SECURE_NIC_INFO_OUT_STATUS_FIRMWARE_VERSION_D_LEN 2
+
+
+/***********************************/
+/* MC_CMD_TSA_TEST
+ * A simple ping-pong command just to test the adapter<>controller MCDI
+ * communication channel. This command makes not changes to the TSA adapter's
+ * internal state. It is used by the controller just to verify that the MCDI
+ * communication channel is working fine. This command takes no additonal
+ * parameters in request or response.
+ */
+#define MC_CMD_TSA_TEST 0x125
+#undef MC_CMD_0x125_PRIVILEGE_CTG
+
+#define MC_CMD_0x125_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSA_TEST_IN msgrequest */
+#define    MC_CMD_TSA_TEST_IN_LEN 0
+
+/* MC_CMD_TSA_TEST_OUT msgresponse */
+#define    MC_CMD_TSA_TEST_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_TSA_RULESET_OVERRIDE
+ * Override TSA ruleset that is currently active on the adapter. This operation
+ * does not modify the ruleset itself. This operation provides a mechanism to
+ * apply an allow-all or deny-all operation on all packets, thereby completely
+ * ignoring the rule-set configured on the adapter. The main purpose of this
+ * operation is to provide a deterministic state to the TSA firewall during
+ * rule-set transitions.
+ */
+#define MC_CMD_TSA_RULESET_OVERRIDE 0x12a
+#undef MC_CMD_0x12a_PRIVILEGE_CTG
+
+#define MC_CMD_0x12a_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSA_RULESET_OVERRIDE_IN msgrequest */
+#define    MC_CMD_TSA_RULESET_OVERRIDE_IN_LEN 4
+/* The override state to apply. */
+#define       MC_CMD_TSA_RULESET_OVERRIDE_IN_STATE_OFST 0
+#define       MC_CMD_TSA_RULESET_OVERRIDE_IN_STATE_LEN 4
+/* enum: No override in place - the existing ruleset is in operation. */
+#define          MC_CMD_TSA_RULESET_OVERRIDE_NONE 0x0
+/* enum: Block all packets seen on all datapath channel except those packets
+ * required for basic configuration of the TSA NIC such as ARPs and TSA-
+ * communication traffic. Such exceptional traffic is handled differently
+ * compared to TSA rulesets.
+ */
+#define          MC_CMD_TSA_RULESET_OVERRIDE_BLOCK 0x1
+/* enum: Allow all packets through all datapath channel. The TSA adapter
+ * behaves like a normal NIC without any firewalls.
+ */
+#define          MC_CMD_TSA_RULESET_OVERRIDE_ALLOW 0x2
+
+/* MC_CMD_TSA_RULESET_OVERRIDE_OUT msgresponse */
+#define    MC_CMD_TSA_RULESET_OVERRIDE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_TSAC_REQUEST
+ * Generic command to send requests from a TSA controller to a TSA adapter.
+ * Specific usage is determined by the TYPE field.
+ */
+#define MC_CMD_TSAC_REQUEST 0x12b
+#undef MC_CMD_0x12b_PRIVILEGE_CTG
+
+#define MC_CMD_0x12b_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_TSAC_REQUEST_IN msgrequest */
+#define    MC_CMD_TSAC_REQUEST_IN_LEN 4
+/* The type of request from the controller. */
+#define       MC_CMD_TSAC_REQUEST_IN_TYPE_OFST 0
+#define       MC_CMD_TSAC_REQUEST_IN_TYPE_LEN 4
+/* enum: Request the adapter to resend localIP information from it's cache. The
+ * command does not return any IP address information; IP addresses are sent as
+ * TSA notifications as descibed in MC_CMD_TSA_INFO_IN_LOCAL_IP.
+ */
+#define          MC_CMD_TSAC_REQUEST_LOCALIP 0x0
+
+/* MC_CMD_TSAC_REQUEST_OUT msgresponse */
+#define    MC_CMD_TSAC_REQUEST_OUT_LEN 0
+
+
 /***********************************/
 /* MC_CMD_SUC_VERSION
  * Get the version of the SUC
@@ -23477,6 +26409,580 @@
 #define       MC_CMD_SUC_BOOT_VERSION_OUT_VERSION_LEN 4
 
 
+/***********************************/
+/* MC_CMD_SUC_MANFTEST
+ * Operations to support manftest on SUC based systems.
+ */
+#define MC_CMD_SUC_MANFTEST 0x135
+#undef MC_CMD_0x135_PRIVILEGE_CTG
+
+#define MC_CMD_0x135_PRIVILEGE_CTG SRIOV_CTG_ADMIN_TSA_UNBOUND
+
+/* MC_CMD_SUC_MANFTEST_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_IN_LEN 4
+/* The manftest operation to be performed. */
+#define       MC_CMD_SUC_MANFTEST_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_IN_OP_LEN 4
+/* enum: Read serial number and use count. */
+#define          MC_CMD_SUC_MANFTEST_WEAROUT_READ 0x0
+/* enum: Update use count on wearout adapter. */
+#define          MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE 0x1
+/* enum: Start an ADC calibration. */
+#define          MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START 0x2
+/* enum: Read the status of an ADC calibration. */
+#define          MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS 0x3
+/* enum: Read the results of an ADC calibration. */
+#define          MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT 0x4
+/* enum: Read the PCIe configuration. */
+#define          MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ 0x5
+/* enum: Write the PCIe configuration. */
+#define          MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE 0x6
+/* enum: Write FRU information to SUC. The FRU information is taken from the
+ * FRU_INFORMATION partition. Attempts to write to read-only FRUs are rejected.
+ */
+#define          MC_CMD_SUC_MANFTEST_FRU_WRITE 0x7
+/* enum: Read UDID Vendor Specific ID from SUC persistent storage. */
+#define          MC_CMD_SUC_MANFTEST_SMBUS_ID_READ 0x8
+/* enum: Write UDID Vendor Specific ID to SUC persistent storage for use in
+ * SMBus ARP.
+ */
+#define          MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE 0x9
+
+/* MC_CMD_SUC_MANFTEST_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_OUT_LEN 0
+
+/* MC_CMD_SUC_MANFTEST_WEAROUT_READ_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_WEAROUT_READ_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_WEAROUT_READ.
+ */
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT_LEN 20
+/* The serial number of the wearout adapter, see SF-112717-PR for format. */
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT_SERIAL_NUMBER_OFST 0
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT_SERIAL_NUMBER_LEN 16
+/* The use count of the wearout adapter. */
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT_USE_COUNT_OFST 16
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_READ_OUT_USE_COUNT_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE.
+ */
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_WEAROUT_UPDATE_OUT_LEN 0
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START.
+ */
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_START_OUT_LEN 0
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS.
+ */
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_LEN 4
+/* The combined status of the calibration operation. */
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_FLAGS_OFST 0
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_FLAGS_LEN 4
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_CALIBRATING_OFST 0
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_CALIBRATING_LBN 0
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_CALIBRATING_WIDTH 1
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_FAILED_OFST 0
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_FAILED_LBN 1
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_FAILED_WIDTH 1
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_RESULT_OFST 0
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_RESULT_LBN 2
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_RESULT_WIDTH 4
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_INDEX_OFST 0
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_INDEX_LBN 6
+#define        MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_STATUS_OUT_INDEX_WIDTH 2
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT.
+ */
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_OUT_LEN 12
+/* The set of calibration results. */
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_OUT_VALUE_OFST 0
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_OUT_VALUE_LEN 4
+#define       MC_CMD_SUC_MANFTEST_ADC_CALIBRATE_RESULT_OUT_VALUE_NUM 3
+
+/* MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ.
+ */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT_LEN 4
+/* The PCIe vendor ID. */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT_VENDOR_ID_OFST 0
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT_VENDOR_ID_LEN 2
+/* The PCIe device ID. */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT_DEVICE_ID_OFST 2
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_READ_OUT_DEVICE_ID_LEN 2
+
+/* MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_LEN 8
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE.
+ */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_OP_LEN 4
+/* The PCIe vendor ID. */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_VENDOR_ID_OFST 4
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_VENDOR_ID_LEN 2
+/* The PCIe device ID. */
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_DEVICE_ID_OFST 6
+#define       MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_IN_DEVICE_ID_LEN 2
+
+/* MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_CONFIG_PCIE_WRITE_OUT_LEN 0
+
+/* MC_CMD_SUC_MANFTEST_FRU_WRITE_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_FRU_WRITE_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_FRU_WRITE
+ */
+#define       MC_CMD_SUC_MANFTEST_FRU_WRITE_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_FRU_WRITE_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_FRU_WRITE_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_FRU_WRITE_OUT_LEN 0
+
+/* MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_IN_LEN 4
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_SMBUS_ID_READ.
+ */
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_IN_OP_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_OUT_LEN 4
+/* The SMBus ID. */
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_OUT_SMBUS_ID_OFST 0
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_READ_OUT_SMBUS_ID_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN msgrequest */
+#define    MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN_LEN 8
+/* The manftest operation to be performed. This must be
+ * MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE.
+ */
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN_OP_OFST 0
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN_OP_LEN 4
+/* The SMBus ID. */
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN_SMBUS_ID_OFST 4
+#define       MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_IN_SMBUS_ID_LEN 4
+
+/* MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_OUT msgresponse */
+#define    MC_CMD_SUC_MANFTEST_SMBUS_ID_WRITE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_CERTIFICATE
+ * Request a certificate.
+ */
+#define MC_CMD_GET_CERTIFICATE 0x12c
+#undef MC_CMD_0x12c_PRIVILEGE_CTG
+
+#define MC_CMD_0x12c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_CERTIFICATE_IN msgrequest */
+#define    MC_CMD_GET_CERTIFICATE_IN_LEN 8
+/* Type of the certificate to be retrieved. */
+#define       MC_CMD_GET_CERTIFICATE_IN_TYPE_OFST 0
+#define       MC_CMD_GET_CERTIFICATE_IN_TYPE_LEN 4
+#define          MC_CMD_GET_CERTIFICATE_IN_UNUSED 0x0 /* enum */
+#define          MC_CMD_GET_CERTIFICATE_IN_AAC 0x1 /* enum */
+/* enum: Adapter Authentication Certificate (AAC). The AAC is unique to each
+ * adapter and is used to verify its authenticity. It is installed by Manftest.
+ */
+#define          MC_CMD_GET_CERTIFICATE_IN_ADAPTER_AUTH 0x1
+#define          MC_CMD_GET_CERTIFICATE_IN_AASC 0x2 /* enum */
+/* enum: Adapter Authentication Signing Certificate (AASC). The AASC is shared
+ * by a group of adapters (typically a purchase order) and is used to verify
+ * the validity of AAC along with the SF root certificate. It is installed by
+ * Manftest.
+ */
+#define          MC_CMD_GET_CERTIFICATE_IN_ADAPTER_AUTH_SIGNING 0x2
+#define          MC_CMD_GET_CERTIFICATE_IN_CUSTOMER_AAC 0x3 /* enum */
+/* enum: Customer Adapter Authentication Certificate. The Customer AAC is
+ * unique to each adapter and is used to verify its authenticity in cases where
+ * either the AAC is not installed or a customer desires to use their own
+ * certificate chain. It is installed by the customer.
+ */
+#define          MC_CMD_GET_CERTIFICATE_IN_CUSTOMER_ADAPTER_AUTH 0x3
+#define          MC_CMD_GET_CERTIFICATE_IN_CUSTOMER_AASC 0x4 /* enum */
+/* enum: Customer Adapter Authentication Certificate. The Customer AASC is
+ * shared by a group of adapters and is used to verify the validity of the
+ * Customer AAC along with the customers root certificate. It is installed by
+ * the customer.
+ */
+#define          MC_CMD_GET_CERTIFICATE_IN_CUSTOMER_ADAPTER_AUTH_SIGNING 0x4
+/* Offset, measured in bytes, relative to the start of the certificate data
+ * from which the certificate is to be retrieved.
+ */
+#define       MC_CMD_GET_CERTIFICATE_IN_OFFSET_OFST 4
+#define       MC_CMD_GET_CERTIFICATE_IN_OFFSET_LEN 4
+
+/* MC_CMD_GET_CERTIFICATE_OUT msgresponse */
+#define    MC_CMD_GET_CERTIFICATE_OUT_LENMIN 13
+#define    MC_CMD_GET_CERTIFICATE_OUT_LENMAX 252
+#define    MC_CMD_GET_CERTIFICATE_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_CERTIFICATE_OUT_LEN(num) (12+1*(num))
+#define    MC_CMD_GET_CERTIFICATE_OUT_DATA_NUM(len) (((len)-12)/1)
+/* Type of the certificate. */
+#define       MC_CMD_GET_CERTIFICATE_OUT_TYPE_OFST 0
+#define       MC_CMD_GET_CERTIFICATE_OUT_TYPE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_CERTIFICATE_IN/TYPE */
+/* Offset, measured in bytes, relative to the start of the certificate data
+ * from which data in this message starts.
+ */
+#define       MC_CMD_GET_CERTIFICATE_OUT_OFFSET_OFST 4
+#define       MC_CMD_GET_CERTIFICATE_OUT_OFFSET_LEN 4
+/* Total length of the certificate data. */
+#define       MC_CMD_GET_CERTIFICATE_OUT_TOTAL_LENGTH_OFST 8
+#define       MC_CMD_GET_CERTIFICATE_OUT_TOTAL_LENGTH_LEN 4
+/* The certificate data. */
+#define       MC_CMD_GET_CERTIFICATE_OUT_DATA_OFST 12
+#define       MC_CMD_GET_CERTIFICATE_OUT_DATA_LEN 1
+#define       MC_CMD_GET_CERTIFICATE_OUT_DATA_MINNUM 1
+#define       MC_CMD_GET_CERTIFICATE_OUT_DATA_MAXNUM 240
+#define       MC_CMD_GET_CERTIFICATE_OUT_DATA_MAXNUM_MCDI2 1008
+
+
+/***********************************/
+/* MC_CMD_GET_NIC_GLOBAL
+ * Get a global value which applies to all PCI functions
+ */
+#define MC_CMD_GET_NIC_GLOBAL 0x12d
+#undef MC_CMD_0x12d_PRIVILEGE_CTG
+
+#define MC_CMD_0x12d_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_NIC_GLOBAL_IN msgrequest */
+#define    MC_CMD_GET_NIC_GLOBAL_IN_LEN 4
+/* Key to request value for, see enum values in MC_CMD_SET_NIC_GLOBAL. If the
+ * given key is unknown to the current firmware, the call will fail with
+ * ENOENT.
+ */
+#define       MC_CMD_GET_NIC_GLOBAL_IN_KEY_OFST 0
+#define       MC_CMD_GET_NIC_GLOBAL_IN_KEY_LEN 4
+
+/* MC_CMD_GET_NIC_GLOBAL_OUT msgresponse */
+#define    MC_CMD_GET_NIC_GLOBAL_OUT_LEN 4
+/* Value of requested key, see key descriptions below. */
+#define       MC_CMD_GET_NIC_GLOBAL_OUT_VALUE_OFST 0
+#define       MC_CMD_GET_NIC_GLOBAL_OUT_VALUE_LEN 4
+
+
+/***********************************/
+/* MC_CMD_SET_NIC_GLOBAL
+ * Set a global value which applies to all PCI functions. Most global values
+ * can only be changed under specific conditions, and this call will return an
+ * appropriate error otherwise (see key descriptions).
+ */
+#define MC_CMD_SET_NIC_GLOBAL 0x12e
+#undef MC_CMD_0x12e_PRIVILEGE_CTG
+
+#define MC_CMD_0x12e_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_SET_NIC_GLOBAL_IN msgrequest */
+#define    MC_CMD_SET_NIC_GLOBAL_IN_LEN 8
+/* Key to change value of. Firmware will return ENOENT for keys it doesn't know
+ * about.
+ */
+#define       MC_CMD_SET_NIC_GLOBAL_IN_KEY_OFST 0
+#define       MC_CMD_SET_NIC_GLOBAL_IN_KEY_LEN 4
+/* enum: Request switching the datapath firmware sub-variant. Currently only
+ * useful when running the DPDK f/w variant. See key values below, and the DPDK
+ * section of the EF10 Driver Writers Guide. Note that any driver attaching
+ * with the SUBVARIANT_AWARE flag cleared is implicitly considered as a request
+ * to switch back to the default sub-variant, and will thus reset this value.
+ * If a sub-variant switch happens, all other PCI functions will get their
+ * resources reset (they will see an MC reboot).
+ */
+#define          MC_CMD_SET_NIC_GLOBAL_IN_FIRMWARE_SUBVARIANT 0x1
+/* New value to set, see key descriptions above. */
+#define       MC_CMD_SET_NIC_GLOBAL_IN_VALUE_OFST 4
+#define       MC_CMD_SET_NIC_GLOBAL_IN_VALUE_LEN 4
+/* enum: Only if KEY = FIRMWARE_SUBVARIANT. Default sub-variant with support
+ * for maximum features for the current f/w variant. A request from a
+ * privileged function to set this particular value will always succeed.
+ */
+#define          MC_CMD_SET_NIC_GLOBAL_IN_FW_SUBVARIANT_DEFAULT 0x0
+/* enum: Only if KEY = FIRMWARE_SUBVARIANT. Increases packet rate at the cost
+ * of not supporting any TX checksum offloads. Only supported when running some
+ * f/w variants, others will return ENOTSUP (as reported by the homonymous bit
+ * in MC_CMD_GET_CAPABILITIES_V2). Can only be set when no other drivers are
+ * attached, and the calling driver must have no resources allocated. See the
+ * DPDK section of the EF10 Driver Writers Guide for a more detailed
+ * description with possible error codes.
+ */
+#define          MC_CMD_SET_NIC_GLOBAL_IN_FW_SUBVARIANT_NO_TX_CSUM 0x1
+
+
+/***********************************/
+/* MC_CMD_LTSSM_TRACE_POLL
+ * Medford2 hardware has support for logging all LTSSM state transitions to a
+ * hardware buffer. When built with WITH_LTSSM_TRACE=1, the firmware will
+ * periodially dump the contents of this hardware buffer to an internal
+ * firmware buffer for later extraction.
+ */
+#define MC_CMD_LTSSM_TRACE_POLL 0x12f
+#undef MC_CMD_0x12f_PRIVILEGE_CTG
+
+#define MC_CMD_0x12f_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_LTSSM_TRACE_POLL_IN msgrequest: Read transitions from the firmware
+ * internal buffer.
+ */
+#define    MC_CMD_LTSSM_TRACE_POLL_IN_LEN 4
+/* The maximum number of row that the caller can accept. The format of each row
+ * is defined in MC_CMD_LTSSM_TRACE_POLL_OUT.
+ */
+#define       MC_CMD_LTSSM_TRACE_POLL_IN_MAX_ROW_COUNT_OFST 0
+#define       MC_CMD_LTSSM_TRACE_POLL_IN_MAX_ROW_COUNT_LEN 4
+
+/* MC_CMD_LTSSM_TRACE_POLL_OUT msgresponse */
+#define    MC_CMD_LTSSM_TRACE_POLL_OUT_LENMIN 16
+#define    MC_CMD_LTSSM_TRACE_POLL_OUT_LENMAX 248
+#define    MC_CMD_LTSSM_TRACE_POLL_OUT_LENMAX_MCDI2 1016
+#define    MC_CMD_LTSSM_TRACE_POLL_OUT_LEN(num) (8+8*(num))
+#define    MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_NUM(len) (((len)-8)/8)
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_FLAGS_OFST 0
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_FLAGS_LEN 4
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_HW_BUFFER_OVERFLOW_OFST 0
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_HW_BUFFER_OVERFLOW_LBN 0
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_HW_BUFFER_OVERFLOW_WIDTH 1
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_FW_BUFFER_OVERFLOW_OFST 0
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_FW_BUFFER_OVERFLOW_LBN 1
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_FW_BUFFER_OVERFLOW_WIDTH 1
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_CONTINUES_OFST 0
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_CONTINUES_LBN 31
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_CONTINUES_WIDTH 1
+/* The number of rows present in this response. */
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROW_COUNT_OFST 4
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROW_COUNT_LEN 4
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_OFST 8
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_LEN 8
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_LO_OFST 8
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_LO_LEN 4
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_LO_LBN 64
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_LO_WIDTH 32
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_HI_OFST 12
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_HI_LEN 4
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_HI_LBN 96
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_HI_WIDTH 32
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_MINNUM 0
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_MAXNUM 30
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_ROWS_MAXNUM_MCDI2 126
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_LTSSM_STATE_OFST 8
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_LTSSM_STATE_LBN 0
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_LTSSM_STATE_WIDTH 6
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_RDLH_LINK_UP_OFST 8
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_RDLH_LINK_UP_LBN 6
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_RDLH_LINK_UP_WIDTH 1
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_WAKE_N_OFST 8
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_WAKE_N_LBN 7
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_WAKE_N_WIDTH 1
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_TIMESTAMP_PS_OFST 8
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_TIMESTAMP_PS_LBN 8
+#define        MC_CMD_LTSSM_TRACE_POLL_OUT_TIMESTAMP_PS_WIDTH 24
+/* The time of the LTSSM transition. Times are reported as fractional
+ * microseconds since MC boot (wrapping at 2^32us). The fractional part is
+ * reported in picoseconds. 0 <= TIMESTAMP_PS < 1000000 timestamp in seconds =
+ * ((TIMESTAMP_US + TIMESTAMP_PS / 1000000) / 1000000)
+ */
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_TIMESTAMP_US_OFST 12
+#define       MC_CMD_LTSSM_TRACE_POLL_OUT_TIMESTAMP_US_LEN 4
+
+
+/***********************************/
+/* MC_CMD_TELEMETRY_ENABLE
+ * This command enables telemetry processing of packets, allowing a remote host
+ * to gather information and analytics passing on the card. Enabling telemetry
+ * will have a performance cost. Not supported on all hardware and datapath
+ * variants. As of writing, only supported on Medford2 running full-featured
+ * firmware variant.
+ */
+#define MC_CMD_TELEMETRY_ENABLE 0x138
+#undef MC_CMD_0x138_PRIVILEGE_CTG
+
+#define MC_CMD_0x138_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_TELEMETRY_ENABLE_IN msgrequest */
+#define    MC_CMD_TELEMETRY_ENABLE_IN_LEN 4
+#define       MC_CMD_TELEMETRY_ENABLE_IN_STATE_OFST 0
+#define       MC_CMD_TELEMETRY_ENABLE_IN_STATE_LEN 4
+/* enum: Disables telemetry functionality, returns the card to default
+ * behaviour of the configured datapath variant.
+ */
+#define          MC_CMD_TELEMETRY_ENABLE_IN_DISABLE 0x0
+/* enum: Enables telemetry functionality on the currently configured datapath
+ * variant if supported.
+ */
+#define          MC_CMD_TELEMETRY_ENABLE_IN_ENABLE 0x1
+
+/* MC_CMD_TELEMETRY_ENABLE_OUT msgresponse */
+#define    MC_CMD_TELEMETRY_ENABLE_OUT_LEN 0
+
+/* TELEMETRY_CONFIG structuredef */
+#define    TELEMETRY_CONFIG_LEN 36
+/* Bitfields to identify the list of config parameters included in the command.
+ * A bit-value of 1 indicates that the relevant config parameter field is
+ * valid; 0 indicates invalid and the config parameter field must be ignored by
+ * firmware. Firmware may however apply some default values for certain
+ * parameters.
+ */
+#define       TELEMETRY_CONFIG_FLAGS_OFST 0
+#define       TELEMETRY_CONFIG_FLAGS_LEN 4
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_VALID_OFST 0
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_VALID_LBN 0
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_VALID_WIDTH 1
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_VALID_OFST 0
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_VALID_LBN 1
+#define        TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_VALID_WIDTH 1
+#define        TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_VALID_OFST 0
+#define        TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_VALID_LBN 2
+#define        TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_VALID_WIDTH 1
+#define        TELEMETRY_CONFIG_MAX_METRICS_COUNT_VALID_OFST 0
+#define        TELEMETRY_CONFIG_MAX_METRICS_COUNT_VALID_LBN 3
+#define        TELEMETRY_CONFIG_MAX_METRICS_COUNT_VALID_WIDTH 1
+#define        TELEMETRY_CONFIG_RESERVED1_OFST 0
+#define        TELEMETRY_CONFIG_RESERVED1_LBN 4
+#define        TELEMETRY_CONFIG_RESERVED1_WIDTH 28
+#define       TELEMETRY_CONFIG_FLAGS_LBN 0
+#define       TELEMETRY_CONFIG_FLAGS_WIDTH 32
+/* Collector IPv4/IPv6 address to which latency measurements are forwarded from
+ * the adapter (as bytes in network order; set last 12 bytes to 0 for IPv4
+ * address).
+ */
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_OFST 4
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_LEN 16
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_LBN 32
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_IP_WIDTH 128
+/* Collector Port number to which latency measurements are forwarded from the
+ * adapter (as bytes in network order).
+ */
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_OFST 20
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_LEN 2
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_LBN 160
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_PORT_WIDTH 16
+/* Unused - set to 0. */
+#define       TELEMETRY_CONFIG_RESERVED2_OFST 22
+#define       TELEMETRY_CONFIG_RESERVED2_LEN 2
+#define       TELEMETRY_CONFIG_RESERVED2_LBN 176
+#define       TELEMETRY_CONFIG_RESERVED2_WIDTH 16
+/* MAC address of the collector (as bytes in network order). */
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_MAC_ADDR_OFST 24
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_MAC_ADDR_LEN 6
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_MAC_ADDR_LBN 192
+#define       TELEMETRY_CONFIG_METRICS_COLLECTOR_MAC_ADDR_WIDTH 48
+/* Maximum number of latency measurements to be made on a telemetry flow. */
+#define       TELEMETRY_CONFIG_MAX_METRICS_COUNT_OFST 30
+#define       TELEMETRY_CONFIG_MAX_METRICS_COUNT_LEN 2
+#define       TELEMETRY_CONFIG_MAX_METRICS_COUNT_LBN 240
+#define       TELEMETRY_CONFIG_MAX_METRICS_COUNT_WIDTH 16
+/* Maximum duration for which a telemetry flow is monitored (in millisecs). */
+#define       TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_OFST 32
+#define       TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_LEN 4
+#define       TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_LBN 256
+#define       TELEMETRY_CONFIG_MONITOR_TIMEOUT_MS_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_TELEMETRY_CONFIG
+ * This top-level command includes various sub-opcodes that are used to apply
+ * (and read-back) telemetry related configuration parameters on the NIC.
+ * Reference - SF-120569-SW Telemetry Firmware Design.
+ */
+#define MC_CMD_TELEMETRY_CONFIG 0x139
+#undef MC_CMD_0x139_PRIVILEGE_CTG
+
+#define MC_CMD_0x139_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_TELEMETRY_CONFIG_IN msgrequest */
+#define    MC_CMD_TELEMETRY_CONFIG_IN_LEN 4
+/* Telemetry configuration sub-operation code */
+#define       MC_CMD_TELEMETRY_CONFIG_IN_OP_OFST 0
+#define       MC_CMD_TELEMETRY_CONFIG_IN_OP_LEN 4
+/* enum: Configure parameters for telemetry measurements. */
+#define          MC_CMD_TELEMETRY_CONFIG_OP_SET 0x1
+/* enum: Read current values of parameters for telemetry measurements. */
+#define          MC_CMD_TELEMETRY_CONFIG_OP_GET 0x2
+
+/* MC_CMD_TELEMETRY_CONFIG_IN_SET msgrequest: This command configures the
+ * parameters necessary for tcp-latency measurements. The adapter adds a filter
+ * for every new tcp flow seen in both tx and rx directions and tracks the
+ * telemetry measurements related to the flow in a tracking table. Entries in
+ * the tracking table live as long as N measurements are made on the flow or
+ * the flow has been in the tracking table for the maximum configured duration.
+ * Telemetry measurements in this command refer to tcp-latency measurements for
+ * data-to-ack latency as well as data-to-data latency. All telemetry
+ * measurements are bundled into a UDP packet and forwarded to a collector
+ * whose IP address is configured using this command.
+ */
+#define    MC_CMD_TELEMETRY_CONFIG_IN_SET_LEN 40
+/* Telemetry configuration sub-operation code. Must be set to
+ * MC_CMD_TELEMETRY_CONFIG_OP_SET.
+ */
+#define       MC_CMD_TELEMETRY_CONFIG_IN_SET_OP_OFST 0
+#define       MC_CMD_TELEMETRY_CONFIG_IN_SET_OP_LEN 4
+/* struct of type TELEMETRY_CONFIG. */
+#define       MC_CMD_TELEMETRY_CONFIG_IN_SET_PARAMETERS_OFST 4
+#define       MC_CMD_TELEMETRY_CONFIG_IN_SET_PARAMETERS_LEN 36
+
+/* MC_CMD_TELEMETRY_CONFIG_OUT_SET msgresponse */
+#define    MC_CMD_TELEMETRY_CONFIG_OUT_SET_LEN 0
+
+/* MC_CMD_TELEMETRY_CONFIG_IN_GET msgrequest: This command reads out the
+ * current values of config parameters necessary for tcp-latency measurements.
+ * See MC_CMD_TELEMETRY_SET_CONFIG for more information about the configuration
+ * parameters.
+ */
+#define    MC_CMD_TELEMETRY_CONFIG_IN_GET_LEN 4
+/* Telemetry configuration sub-operation code. Must be set to
+ * MC_CMD_TELEMETRY_CONFIG_OP_GET.
+ */
+#define       MC_CMD_TELEMETRY_CONFIG_IN_GET_OP_OFST 0
+#define       MC_CMD_TELEMETRY_CONFIG_IN_GET_OP_LEN 4
+
+/* MC_CMD_TELEMETRY_CONFIG_OUT_GET msgresponse */
+#define    MC_CMD_TELEMETRY_CONFIG_OUT_GET_LEN 36
+/* struct of type TELEMETRY_CONFIG. */
+#define       MC_CMD_TELEMETRY_CONFIG_OUT_GET_PARAMETERS_OFST 0
+#define       MC_CMD_TELEMETRY_CONFIG_OUT_GET_PARAMETERS_LEN 36
+
+
 /***********************************/
 /* MC_CMD_GET_RX_PREFIX_ID
  * This command is part of the mechanism for configuring the format of the RX
@@ -23832,6 +27338,427 @@
 #define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_AENS_SENT_OFST 24
 #define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_AENS_SENT_LEN 4
 
+
+/***********************************/
+/* MC_CMD_FIRMWARE_SET_LOCKDOWN
+ * System lockdown, when enabled firmware updates are blocked.
+ */
+#define MC_CMD_FIRMWARE_SET_LOCKDOWN 0x16f
+#undef MC_CMD_0x16f_PRIVILEGE_CTG
+
+#define MC_CMD_0x16f_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_FIRMWARE_SET_LOCKDOWN_IN msgrequest: This MCDI command is to enable
+ * only because lockdown can only be disabled by a PMCI command or a cold reset
+ * of the system.
+ */
+#define    MC_CMD_FIRMWARE_SET_LOCKDOWN_IN_LEN 0
+
+/* MC_CMD_FIRMWARE_SET_LOCKDOWN_OUT msgresponse */
+#define    MC_CMD_FIRMWARE_SET_LOCKDOWN_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_TEST_FEATURES
+ * This command returns device details knowledge of which may be required by
+ * test infrastructure. Although safe, it is not intended to be used by
+ * production drivers, and the structure returned intentionally has no public
+ * documentation.
+ */
+#define MC_CMD_GET_TEST_FEATURES 0x1ac
+#undef MC_CMD_0x1ac_PRIVILEGE_CTG
+
+#define MC_CMD_0x1ac_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_TEST_FEATURES_IN msgrequest: Request test features. */
+#define    MC_CMD_GET_TEST_FEATURES_IN_LEN 0
+
+/* MC_CMD_GET_TEST_FEATURE_OUT msgresponse */
+#define    MC_CMD_GET_TEST_FEATURE_OUT_LENMIN 4
+#define    MC_CMD_GET_TEST_FEATURE_OUT_LENMAX 252
+#define    MC_CMD_GET_TEST_FEATURE_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_TEST_FEATURE_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_NUM(len) (((len)-0)/4)
+/* Test-specific NIC information. Production drivers must treat this as opaque.
+ * The layout is defined in the private TEST_FEATURES_LAYOUT structure.
+ */
+#define       MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_OFST 0
+#define       MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_LEN 4
+#define       MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_MINNUM 1
+#define       MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_MAXNUM 63
+#define       MC_CMD_GET_TEST_FEATURE_OUT_TEST_FEATURES_MAXNUM_MCDI2 255
+
+
+/***********************************/
+/* MC_CMD_FPGA
+ * A command to perform various fpga-related operations on platforms that
+ * include FPGAs. Note that some platforms may only support a subset of these
+ * operations.
+ */
+#define MC_CMD_FPGA 0x1bf
+#undef MC_CMD_0x1bf_PRIVILEGE_CTG
+
+#define MC_CMD_0x1bf_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_FPGA_IN msgrequest */
+#define    MC_CMD_FPGA_IN_LEN 4
+/* Sub-command code */
+#define       MC_CMD_FPGA_IN_OP_OFST 0
+#define       MC_CMD_FPGA_IN_OP_LEN 4
+/* enum: Get the FPGA version string. */
+#define          MC_CMD_FPGA_IN_OP_GET_VERSION 0x0
+/* enum: Read bitmask of features supported in the FPGA image. */
+#define          MC_CMD_FPGA_IN_OP_GET_CAPABILITIES 0x1
+/* enum: Perform a FPGA reset. */
+#define          MC_CMD_FPGA_IN_OP_RESET 0x2
+/* enum: Set active flash device. */
+#define          MC_CMD_FPGA_IN_OP_SELECT_FLASH 0x3
+/* enum: Get active flash device. */
+#define          MC_CMD_FPGA_IN_OP_GET_ACTIVE_FLASH 0x4
+/* enum: Configure internal link i.e. the FPGA port facing the ASIC. */
+#define          MC_CMD_FPGA_IN_OP_SET_INTERNAL_LINK 0x5
+/* enum: Read internal link configuration. */
+#define          MC_CMD_FPGA_IN_OP_GET_INTERNAL_LINK 0x6
+/* enum: Get MAC statistics of FPGA external port. */
+#define          MC_CMD_FPGA_IN_OP_GET_MAC_STATS 0x7
+/* enum: Set configuration on internal FPGA MAC. */
+#define          MC_CMD_FPGA_IN_OP_SET_INTERNAL_MAC 0x8
+
+/* MC_CMD_FPGA_OP_GET_VERSION_IN msgrequest: Get the FPGA version string. A
+ * free-format string is returned in response to this command. Any checks on
+ * supported FPGA operations are based on the response to
+ * MC_CMD_FPGA_OP_GET_CAPABILITIES.
+ */
+#define    MC_CMD_FPGA_OP_GET_VERSION_IN_LEN 4
+/* Sub-command code. Must be OP_GET_VERSION */
+#define       MC_CMD_FPGA_OP_GET_VERSION_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_GET_VERSION_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_VERSION_OUT msgresponse: Returns the version string. */
+#define    MC_CMD_FPGA_OP_GET_VERSION_OUT_LENMIN 0
+#define    MC_CMD_FPGA_OP_GET_VERSION_OUT_LENMAX 252
+#define    MC_CMD_FPGA_OP_GET_VERSION_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_FPGA_OP_GET_VERSION_OUT_LEN(num) (0+1*(num))
+#define    MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_NUM(len) (((len)-0)/1)
+/* Null-terminated string containing version information. */
+#define       MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_OFST 0
+#define       MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_LEN 1
+#define       MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_MINNUM 0
+#define       MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_MAXNUM 252
+#define       MC_CMD_FPGA_OP_GET_VERSION_OUT_VERSION_MAXNUM_MCDI2 1020
+
+/* MC_CMD_FPGA_OP_GET_CAPABILITIES_IN msgrequest: Read bitmask of features
+ * supported in the FPGA image.
+ */
+#define    MC_CMD_FPGA_OP_GET_CAPABILITIES_IN_LEN 4
+/* Sub-command code. Must be OP_GET_CAPABILITIES */
+#define       MC_CMD_FPGA_OP_GET_CAPABILITIES_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_GET_CAPABILITIES_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT msgresponse: Returns the version string.
+ */
+#define    MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_LEN 4
+/* Bit-mask of supported features. */
+#define       MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_CAPABILITIES_OFST 0
+#define       MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_CAPABILITIES_LEN 4
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAC_OFST 0
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAC_LBN 0
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAC_WIDTH 1
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAE_OFST 0
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAE_LBN 1
+#define        MC_CMD_FPGA_OP_GET_CAPABILITIES_OUT_MAE_WIDTH 1
+
+/* MC_CMD_FPGA_OP_RESET_IN msgrequest: Perform a FPGA reset operation where
+ * supported.
+ */
+#define    MC_CMD_FPGA_OP_RESET_IN_LEN 4
+/* Sub-command code. Must be OP_RESET */
+#define       MC_CMD_FPGA_OP_RESET_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_RESET_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_RESET_OUT msgresponse */
+#define    MC_CMD_FPGA_OP_RESET_OUT_LEN 0
+
+/* MC_CMD_FPGA_OP_SELECT_FLASH_IN msgrequest: Set active FPGA flash device.
+ * Returns EINVAL if selected flash index does not exist on the platform under
+ * test.
+ */
+#define    MC_CMD_FPGA_OP_SELECT_FLASH_IN_LEN 8
+/* Sub-command code. Must be OP_SELECT_FLASH */
+#define       MC_CMD_FPGA_OP_SELECT_FLASH_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_SELECT_FLASH_IN_OP_LEN 4
+/* Flash device identifier. */
+#define       MC_CMD_FPGA_OP_SELECT_FLASH_IN_FLASH_ID_OFST 4
+#define       MC_CMD_FPGA_OP_SELECT_FLASH_IN_FLASH_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_FPGA_FLASH_INDEX */
+
+/* MC_CMD_FPGA_OP_SELECT_FLASH_OUT msgresponse */
+#define    MC_CMD_FPGA_OP_SELECT_FLASH_OUT_LEN 0
+
+/* MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_IN msgrequest: Get active FPGA flash device.
+ */
+#define    MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_IN_LEN 4
+/* Sub-command code. Must be OP_GET_ACTIVE_FLASH */
+#define       MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_OUT msgresponse: Returns flash identifier
+ * for current active flash.
+ */
+#define    MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_OUT_LEN 4
+/* Flash device identifier. */
+#define       MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_OUT_FLASH_ID_OFST 0
+#define       MC_CMD_FPGA_OP_GET_ACTIVE_FLASH_OUT_FLASH_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_FPGA_FLASH_INDEX */
+
+/* MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN msgrequest: Configure FPGA internal
+ * port, facing the ASIC
+ */
+#define    MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_LEN 12
+/* Sub-command code. Must be OP_SET_INTERNAL_LINK */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_OP_LEN 4
+/* Flags */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_FLAGS_OFST 4
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_FLAGS_LEN 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_LINK_STATE_OFST 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_LINK_STATE_LBN 0
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_LINK_STATE_WIDTH 2
+/* enum: Unmodified, same as last state set by firmware */
+#define          MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_AUTO 0x0
+/* enum: Configure link-up */
+#define          MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_UP 0x1
+/* enum: Configure link-down */
+#define          MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_DOWN 0x2
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_FLUSH_OFST 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_FLUSH_LBN 2
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_FLUSH_WIDTH 1
+/* Link speed to be applied on FPGA internal port MAC. */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_SPEED_OFST 8
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN_SPEED_LEN 4
+
+/* MC_CMD_FPGA_OP_SET_INTERNAL_LINK_OUT msgresponse */
+#define    MC_CMD_FPGA_OP_SET_INTERNAL_LINK_OUT_LEN 0
+
+/* MC_CMD_FPGA_OP_GET_INTERNAL_LINK_IN msgrequest: Read FPGA internal port
+ * configuration and status
+ */
+#define    MC_CMD_FPGA_OP_GET_INTERNAL_LINK_IN_LEN 4
+/* Sub-command code. Must be OP_GET_INTERNAL_LINK */
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT msgresponse: Response format for read
+ * FPGA internal port configuration and status
+ */
+#define    MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_LEN 8
+/* Flags */
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_FLAGS_OFST 0
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_FLAGS_LEN 4
+#define        MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_LINK_STATE_OFST 0
+#define        MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_LINK_STATE_LBN 0
+#define        MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_LINK_STATE_WIDTH 2
+/*             Enum values, see field(s): */
+/*                MC_CMD_FPGA_OP_SET_INTERNAL_LINK_IN/FLAGS */
+/* Link speed set on FPGA internal port MAC. */
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_SPEED_OFST 4
+#define       MC_CMD_FPGA_OP_GET_INTERNAL_LINK_OUT_SPEED_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_MAC_STATS_IN msgrequest: Get FPGA external port MAC
+ * statistics.
+ */
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_IN_LEN 4
+/* Sub-command code. Must be OP_GET_MAC_STATS. */
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_IN_OP_LEN 4
+
+/* MC_CMD_FPGA_OP_GET_MAC_STATS_OUT msgresponse */
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_LENMIN 4
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_LENMAX 252
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_LEN(num) (4+8*(num))
+#define    MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_NUM(len) (((len)-4)/8)
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_NUM_STATS_OFST 0
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_NUM_STATS_LEN 4
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_OFST 4
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_LEN 8
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_LO_OFST 4
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_LO_LEN 4
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_LO_LBN 32
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_LO_WIDTH 32
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_HI_OFST 8
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_HI_LEN 4
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_HI_LBN 64
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_HI_WIDTH 32
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_MINNUM 0
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_MAXNUM 31
+#define       MC_CMD_FPGA_OP_GET_MAC_STATS_OUT_STATISTICS_MAXNUM_MCDI2 127
+#define          MC_CMD_FPGA_MAC_TX_TOTAL_PACKETS 0x0 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_TOTAL_BYTES 0x1 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_TOTAL_GOOD_PACKETS 0x2 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_TOTAL_GOOD_BYTES 0x3 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_BAD_FCS 0x4 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_PAUSE 0x5 /* enum */
+#define          MC_CMD_FPGA_MAC_TX_USER_PAUSE 0x6 /* enum */
+#define          MC_CMD_FPGA_MAC_RX_TOTAL_PACKETS 0x7 /* enum */
+#define          MC_CMD_FPGA_MAC_RX_TOTAL_BYTES 0x8 /* enum */
+#define          MC_CMD_FPGA_MAC_RX_TOTAL_GOOD_PACKETS 0x9 /* enum */
+#define          MC_CMD_FPGA_MAC_RX_TOTAL_GOOD_BYTES 0xa /* enum */
+#define          MC_CMD_FPGA_MAC_RX_BAD_FCS 0xb /* enum */
+#define          MC_CMD_FPGA_MAC_RX_PAUSE 0xc /* enum */
+#define          MC_CMD_FPGA_MAC_RX_USER_PAUSE 0xd /* enum */
+#define          MC_CMD_FPGA_MAC_RX_UNDERSIZE 0xe /* enum */
+#define          MC_CMD_FPGA_MAC_RX_OVERSIZE 0xf /* enum */
+#define          MC_CMD_FPGA_MAC_RX_FRAMING_ERR 0x10 /* enum */
+#define          MC_CMD_FPGA_MAC_FEC_UNCORRECTED_ERRORS 0x11 /* enum */
+#define          MC_CMD_FPGA_MAC_FEC_CORRECTED_ERRORS 0x12 /* enum */
+
+/* MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN msgrequest: Configures the internal port
+ * MAC on the FPGA.
+ */
+#define    MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_LEN 20
+/* Sub-command code. Must be OP_SET_INTERNAL_MAC. */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_OP_OFST 0
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_OP_LEN 4
+/* Select which parameters to configure. */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CONTROL_OFST 4
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CONTROL_LEN 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_MTU_OFST 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_MTU_LBN 0
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_MTU_WIDTH 1
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_DRAIN_OFST 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_DRAIN_LBN 1
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_DRAIN_WIDTH 1
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_FCNTL_OFST 4
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_FCNTL_LBN 2
+#define        MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_CFG_FCNTL_WIDTH 1
+/* The MTU to be programmed into the MAC. */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_MTU_OFST 8
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_MTU_LEN 4
+/* Drain Tx FIFO */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_DRAIN_OFST 12
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_DRAIN_LEN 4
+/* flow control configuration. See MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL. */
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_FCNTL_OFST 16
+#define       MC_CMD_FPGA_OP_SET_INTERNAL_MAC_IN_FCNTL_LEN 4
+
+/* MC_CMD_FPGA_OP_SET_INTERNAL_MAC_OUT msgresponse */
+#define    MC_CMD_FPGA_OP_SET_INTERNAL_MAC_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_EXTERNAL_MAE_GET_LINK_MODE
+ * This command is expected to be used on a U25 board with an MAE in the FPGA.
+ * It does not modify the operational state of the NIC. The modes are described
+ * in XN-200039-TC - U25 OVS packet formats.
+ */
+#define MC_CMD_EXTERNAL_MAE_GET_LINK_MODE 0x1c0
+#undef MC_CMD_0x1c0_PRIVILEGE_CTG
+
+#define MC_CMD_0x1c0_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_IN msgrequest */
+#define    MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_IN_LEN 0
+
+/* MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_OUT msgresponse */
+#define    MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_OUT_LEN 4
+/* The current link mode */
+#define       MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_OUT_MODE_OFST 0
+#define       MC_CMD_EXTERNAL_MAE_GET_LINK_MODE_OUT_MODE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_EXTERNAL_MAE_LINK_MODE */
+
+
+/***********************************/
+/* MC_CMD_EXTERNAL_MAE_SET_LINK_MODE
+ * This command is expected to be used on a U25 board with an MAE in the FPGA.
+ * The modes are described in XN-200039-TC - U25 OVS packet formats. This
+ * command will set the link between the FPGA and the X2 to the specified new
+ * mode. It will first enter bootstrap mode, make sure there are no packets in
+ * flight and then enter the requested mode. In order to make sure there are no
+ * packets in flight, it will flush the X2 TX path, the FPGA RX path from the
+ * X2, the FPGA TX path to the X2 and the X2 RX path. The driver is responsible
+ * for making sure there are no TX or RX descriptors posted on any TXQ or RXQ
+ * associated with the affected port before invoking this command. This command
+ * is run implicitly with MODE set to LEGACY when MC_CMD_DRV_ATTACH is
+ * executed.
+ */
+#define MC_CMD_EXTERNAL_MAE_SET_LINK_MODE 0x1c1
+#undef MC_CMD_0x1c1_PRIVILEGE_CTG
+
+#define MC_CMD_0x1c1_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_IN msgrequest */
+#define    MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_IN_LEN 4
+/* The new link mode. */
+#define       MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_IN_MODE_OFST 0
+#define       MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_IN_MODE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_EXTERNAL_MAE_LINK_MODE */
+
+/* MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_OUT msgresponse */
+#define    MC_CMD_EXTERNAL_MAE_SET_LINK_MODE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_BUFTBL_STATS
+ * Currently EF10 only. Read usage and limits for Buffer Table
+ */
+#define MC_CMD_GET_BUFTBL_STATS 0x6a
+#undef MC_CMD_0x6a_PRIVILEGE_CTG
+
+#define MC_CMD_0x6a_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_BUFTBL_STATS_IN msgrequest */
+#define    MC_CMD_GET_BUFTBL_STATS_IN_LEN 0
+
+/* MC_CMD_GET_BUFTBL_STATS_OUT msgresponse */
+#define    MC_CMD_GET_BUFTBL_STATS_OUT_LEN 40
+/* number of buffer table entries per set */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_ENTRIES_PER_SET_OFST 0
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_ENTRIES_PER_SET_LEN 4
+/* number of buffer table entries per cluster */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_ENTRIES_PER_CLUSTER_OFST 4
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_ENTRIES_PER_CLUSTER_LEN 4
+/* Maximum size buffer table can grow to, in clusters. On EF10, this can
+ * potentially vary depending on the size of the Descriptor Cache.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MAX_CLUSTERS_OFST 8
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MAX_CLUSTERS_LEN 4
+/* High water mark for number of buffer table clusters which have been
+ * allocated.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_HIGH_WATER_CLUSTERS_OFST 12
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_HIGH_WATER_CLUSTERS_LEN 4
+/* Number of free buffer table clusters on the free cluster list. */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_FREE_CLUSTERS_OFST 16
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_FREE_CLUSTERS_LEN 4
+/* Number of free buffer table sets on the free set list. */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_FREE_SETS_OFST 20
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_FREE_SETS_LEN 4
+/* Number of chunks of fully-used clusters allocated to the MC for EVQ, RXQ and
+ * TXQs.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MC_FULL_CLUSTERS_OFST 24
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MC_FULL_CLUSTERS_LEN 4
+/* Number of chunks in partially-used clusters allocated to the MC for EVQ, RXQ
+ * and TXQs.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MC_PART_CLUSTERS_OFST 28
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_MC_PART_CLUSTERS_LEN 4
+/* Number of buffer table sets (chunks) allocated to the host via
+ * MC_CMD_ALLOC_BUFTBL_CHUNK.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_HOST_SETS_OFST 32
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_BUFTBL_HOST_SETS_LEN 4
+/* Maximum number of VIs per NIC. On EF10 this is the current value as used to
+ * size the Descriptor Cache in hardware.
+ */
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_VI_MAX_OFST 36
+#define       MC_CMD_GET_BUFTBL_STATS_OUT_VI_MAX_LEN 4
+
 /* CLIENT_HANDLE structuredef: A client is an abstract entity that can make
  * requests of the device and that can own resources managed by the device.
  * Examples of clients include PCIe functions and dynamic clients. A client
@@ -23899,8 +27826,8 @@
 
 /* SCHED_CREDIT_CHECK_RESULT structuredef */
 #define    SCHED_CREDIT_CHECK_RESULT_LEN 16
-/* The instance of the scheduler. Refer to XN-200389-AW for the location of
- * these schedulers in the hardware.
+/* The instance of the scheduler. Refer to XN-200389-AW (snic/hnic) and
+ * XN-200425-TC (cdx) for the location of these schedulers in the hardware.
  */
 #define       SCHED_CREDIT_CHECK_RESULT_SCHED_INSTANCE_OFST 0
 #define       SCHED_CREDIT_CHECK_RESULT_SCHED_INSTANCE_LEN 1
@@ -23914,6 +27841,16 @@
 #define          SCHED_CREDIT_CHECK_RESULT_DMAC_H2C 0x7 /* enum */
 #define          SCHED_CREDIT_CHECK_RESULT_HUB_NET_B 0x8 /* enum */
 #define          SCHED_CREDIT_CHECK_RESULT_HUB_NET_REPLAY 0x9 /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_ADAPTER_C2H_C 0xa /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_A2_H2C_C 0xb /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_A3_SOFT_ADAPTOR_C 0xc /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_A4_DPU_WRITE_C 0xd /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_JRC_RRU 0xe /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_CDM_SINK 0xf /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_PCIE_SINK 0x10 /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_UPORT_SINK 0x11 /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_PSX_SINK 0x12 /* enum */
+#define          SCHED_CREDIT_CHECK_RESULT_A5_DPU_READ_C 0x13 /* enum */
 #define       SCHED_CREDIT_CHECK_RESULT_SCHED_INSTANCE_LBN 0
 #define       SCHED_CREDIT_CHECK_RESULT_SCHED_INSTANCE_WIDTH 8
 /* The type of node that this result refers to. */
@@ -23923,6 +27860,10 @@
 #define          SCHED_CREDIT_CHECK_RESULT_DEST 0x0
 /* enum: Source node */
 #define          SCHED_CREDIT_CHECK_RESULT_SOURCE 0x1
+/* enum: Destination node credit type 1 (new to the Keystone schedulers, see
+ * SF-120268-TC)
+ */
+#define          SCHED_CREDIT_CHECK_RESULT_DEST_CREDIT1 0x2
 #define       SCHED_CREDIT_CHECK_RESULT_NODE_TYPE_LBN 8
 #define       SCHED_CREDIT_CHECK_RESULT_NODE_TYPE_WIDTH 8
 /* Level of node in scheduler hierarchy (level 0 is the bottom of the
@@ -26076,6 +30017,26 @@
 #define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MINNUM 0
 #define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MAXNUM 4
 #define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MAXNUM_MCDI2 19
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_LEN 8
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_LO_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_LO_LEN 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_LO_LBN 32
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_LO_WIDTH 32
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_HI_OFST 8
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_HI_LEN 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_HI_LBN 64
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_HI_WIDTH 32
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_PF_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_PF_LEN 2
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_VF_OFST 6
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_VF_LEN 2
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_INTF_OFST 8
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_FUNC_INTF_LEN 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_PERSONALITY_OFST 12
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_PERSONALITY_LEN 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_LABEL_OFST 16
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_LABEL_LEN 40
 
 
 /***********************************/
@@ -27350,7 +31311,7 @@
 /* MAE_MPORT_SELECTOR structuredef: MPORTS are identified by an opaque unsigned
  * integer value (mport_id) that is guaranteed to be representable within
  * 32-bits or within any NIC interface field that needs store the value
- * (whichever is narrowers). This selector structure provides a stable way to
+ * (whichever is narrower). This selector structure provides a stable way to
  * refer to m-ports.
  */
 #define    MAE_MPORT_SELECTOR_LEN 4
@@ -27425,10 +31386,22 @@
 #define       MAE_MPORT_SELECTOR_FLAT_WIDTH 32
 
 /* MAE_LINK_ENDPOINT_SELECTOR structuredef: Structure that identifies a real or
- * virtual network port by MAE port and link end
+ * virtual network port by MAE port and link end. Intended to be used by
+ * network port MCDI commands. Setting FLAT to MAE_LINK_ENDPOINT_COMPAT is
+ * equivalent to using the previous version of the command. Not all possible
+ * combinations of MPORT_END and MPORT_SELECTOR in MAE_LINK_ENDPOINT_SELECTOR
+ * will work in all circumstances. 1. Some will always work (e.g. a VF can
+ * always address its logical MAC using MPORT_SELECTOR=ASSIGNED,LINK_END=VNIC),
+ * 2. Some are not meaningful and will always fail with EINVAL (e.g. attempting
+ * to address the VNIC end of a link to a physical port), 3. Some are
+ * meaningful but require the MCDI client to have the required permission and
+ * fail with EPERM otherwise (e.g. trying to set the MAC on a VF the caller
+ * cannot administer), and 4. Some could be implementation-specific and fail
+ * with ENOTSUP if not available (no examples exist right now). See
+ * SF-123581-TC section 4.3 for more details.
  */
 #define    MAE_LINK_ENDPOINT_SELECTOR_LEN 8
-/* The MAE MPORT of interest */
+/* Identifier for the MAE MPORT of interest */
 #define       MAE_LINK_ENDPOINT_SELECTOR_MPORT_SELECTOR_OFST 0
 #define       MAE_LINK_ENDPOINT_SELECTOR_MPORT_SELECTOR_LEN 4
 #define       MAE_LINK_ENDPOINT_SELECTOR_MPORT_SELECTOR_LBN 0
@@ -27829,6 +31802,8 @@
 #define       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_MAXNUM_MCDI2 253
 /* enum: A counter ID that is guaranteed never to represent a real counter */
 #define          MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL 0xffffffff
+/*            Other enum values, see field(s): */
+/*               MAE_COUNTER_ID */
 
 
 /***********************************/
@@ -28266,6 +32241,24 @@
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_SUPPRESS_SELF_DELIVERY_OFST 0
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_SUPPRESS_SELF_DELIVERY_LBN 14
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_SUPPRESS_SELF_DELIVERY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_C_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_C_PL_LBN 15
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_C_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_D_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_D_PL_LBN 16
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_D_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_LBN 17
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_SET_NET_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_SET_NET_CHAN_LBN 18
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_DO_SET_NET_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_PLUGIN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_PLUGIN_LBN 19
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_PLUGIN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_INC_L4_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_INC_L4_LBN 20
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_IN_LACP_INC_L4_WIDTH 1
 /* If VLAN_PUSH >= 1, TCI value to be inserted as outermost VLAN. */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE_OFST 4
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE_LEN 2
@@ -28291,19 +32284,23 @@
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_DELIVER_OFST 20
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_DELIVER_LEN 4
 /* Allows an action set to trigger several counter updates. Set to
- * COUNTER_LIST_ID_NULL to request no counter action.
+ * MAE_COUNTER_ID_NULL to request no counter action.
  */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID_OFST 24
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
 /* If a driver only wished to update one counter within this action set, then
  * it can supply a COUNTER_ID instead of allocating a single-element counter
  * list. The ID must have been allocated with COUNTER_TYPE=AR. This field
- * should be set to COUNTER_ID_NULL if this behaviour is not required. It is
- * not valid to supply a non-NULL value for both COUNTER_LIST_ID and
+ * should be set to MAE_COUNTER_ID_NULL if this behaviour is not required. It
+ * is not valid to supply a non-NULL value for both COUNTER_LIST_ID and
  * COUNTER_ID.
  */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_COUNTER_ID_OFST 28
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_COUNTER_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_MARK_VALUE_OFST 32
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_IN_MARK_VALUE_LEN 4
 /* Set to MAC_ID_NULL to request no source MAC replacement. */
@@ -28347,6 +32344,24 @@
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_SUPPRESS_SELF_DELIVERY_OFST 0
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_SUPPRESS_SELF_DELIVERY_LBN 14
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_SUPPRESS_SELF_DELIVERY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_C_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_C_PL_LBN 15
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_C_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_D_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_D_PL_LBN 16
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_D_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_LBN 17
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_SET_NET_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_SET_NET_CHAN_LBN 18
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DO_SET_NET_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_PLUGIN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_PLUGIN_LBN 19
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_PLUGIN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_INC_L4_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_INC_L4_LBN 20
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_LACP_INC_L4_WIDTH 1
 /* If VLAN_PUSH >= 1, TCI value to be inserted as outermost VLAN. */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_VLAN0_TCI_BE_OFST 4
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_VLAN0_TCI_BE_LEN 2
@@ -28372,19 +32387,23 @@
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DELIVER_OFST 20
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_DELIVER_LEN 4
 /* Allows an action set to trigger several counter updates. Set to
- * COUNTER_LIST_ID_NULL to request no counter action.
+ * MAE_COUNTER_ID_NULL to request no counter action.
  */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_COUNTER_LIST_ID_OFST 24
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_COUNTER_LIST_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
 /* If a driver only wished to update one counter within this action set, then
  * it can supply a COUNTER_ID instead of allocating a single-element counter
  * list. The ID must have been allocated with COUNTER_TYPE=AR. This field
- * should be set to COUNTER_ID_NULL if this behaviour is not required. It is
- * not valid to supply a non-NULL value for both COUNTER_LIST_ID and
+ * should be set to MAE_COUNTER_ID_NULL if this behaviour is not required. It
+ * is not valid to supply a non-NULL value for both COUNTER_LIST_ID and
  * COUNTER_ID.
  */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_COUNTER_ID_OFST 28
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_COUNTER_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_MARK_VALUE_OFST 32
 #define       MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_MARK_VALUE_LEN 4
 /* Set to MAC_ID_NULL to request no source MAC replacement. */
@@ -28437,6 +32456,172 @@
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_ECN_ECT_1_TO_CE_LBN 6
 #define        MC_CMD_MAE_ACTION_SET_ALLOC_V2_IN_ECN_ECT_1_TO_CE_WIDTH 1
 
+/* MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN msgrequest: Only supported if
+ * MAE_ACTION_SET_ALLOC_V3_SUPPORTED is advertised in
+ * MC_CMD_GET_CAPABILITIES_V10_OUT.
+ */
+#define    MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LEN 53
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_FLAGS_OFST 0
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_FLAGS_LEN 4
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_PUSH_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_PUSH_LBN 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_PUSH_WIDTH 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_POP_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_POP_LBN 4
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN_POP_WIDTH 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DECAP_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DECAP_LBN 8
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DECAP_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_MARK_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_MARK_LBN 9
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_MARK_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_FLAG_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_FLAG_LBN 10
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_FLAG_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_NAT_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_NAT_LBN 11
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_NAT_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DECR_IP_TTL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DECR_IP_TTL_LBN 12
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DECR_IP_TTL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_SRC_MPORT_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_SRC_MPORT_LBN 13
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_SRC_MPORT_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_SUPPRESS_SELF_DELIVERY_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_SUPPRESS_SELF_DELIVERY_LBN 14
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_SUPPRESS_SELF_DELIVERY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_C_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_C_PL_LBN 15
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_C_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_D_PL_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_D_PL_LBN 16
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_D_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_LBN 17
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_RDP_OUT_HOST_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_NET_CHAN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_NET_CHAN_LBN 18
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_SET_NET_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_PLUGIN_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_PLUGIN_LBN 19
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_PLUGIN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_INC_L4_OFST 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_INC_L4_LBN 20
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_LACP_INC_L4_WIDTH 1
+/* If VLAN_PUSH >= 1, TCI value to be inserted as outermost VLAN. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN0_TCI_BE_OFST 4
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN0_TCI_BE_LEN 2
+/* If VLAN_PUSH >= 1, TPID value to be inserted as outermost VLAN. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN0_PROTO_BE_OFST 6
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN0_PROTO_BE_LEN 2
+/* If VLAN_PUSH == 2, inner TCI value to be inserted. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN1_TCI_BE_OFST 8
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN1_TCI_BE_LEN 2
+/* If VLAN_PUSH == 2, inner TPID value to be inserted. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN1_PROTO_BE_OFST 10
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_VLAN1_PROTO_BE_LEN 2
+/* Reserved. Ignored by firmware. Should be set to zero or 0xffffffff. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RSVD_OFST 12
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RSVD_LEN 4
+/* Set to ENCAP_HEADER_ID_NULL to request no encap action */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ENCAP_HEADER_ID_OFST 16
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ENCAP_HEADER_ID_LEN 4
+/* An m-port selector identifying the m-port that the modified packet should be
+ * delivered to. Set to MPORT_SELECTOR_NULL to request no delivery of the
+ * packet.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DELIVER_OFST 20
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DELIVER_LEN 4
+/* Allows an action set to trigger several counter updates. Set to
+ * MAE_COUNTER_ID_NULL to request no counter action.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_COUNTER_LIST_ID_OFST 24
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_COUNTER_LIST_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
+/* If a driver only wished to update one counter within this action set, then
+ * it can supply a COUNTER_ID instead of allocating a single-element counter
+ * list. The ID must have been allocated with COUNTER_TYPE=AR. This field
+ * should be set to MAE_COUNTER_ID_NULL if this behaviour is not required. It
+ * is not valid to supply a non-NULL value for both COUNTER_LIST_ID and
+ * COUNTER_ID.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_COUNTER_ID_OFST 28
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_COUNTER_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MAE_COUNTER_ID */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_MARK_VALUE_OFST 32
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_MARK_VALUE_LEN 4
+/* Set to MAC_ID_NULL to request no source MAC replacement. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_SRC_MAC_ID_OFST 36
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_SRC_MAC_ID_LEN 4
+/* Set to MAC_ID_NULL to request no destination MAC replacement. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DST_MAC_ID_OFST 40
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DST_MAC_ID_LEN 4
+/* Source m-port ID to be reported for DO_SET_SRC_MPORT action. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_REPORTED_SRC_MPORT_OFST 44
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_REPORTED_SRC_MPORT_LEN 4
+/* Actions for modifying the Differentiated Services Code-Point (DSCP) bits
+ * within IPv4 and IPv6 headers.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DSCP_CONTROL_OFST 48
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DSCP_CONTROL_LEN 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_ENCAP_COPY_OFST 48
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_ENCAP_COPY_LBN 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_ENCAP_COPY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_DECAP_COPY_OFST 48
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_DECAP_COPY_LBN 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_DSCP_DECAP_COPY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_DSCP_OFST 48
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_DSCP_LBN 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_DSCP_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DSCP_VALUE_OFST 48
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DSCP_VALUE_LBN 3
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DSCP_VALUE_WIDTH 6
+/* Actions for modifying the Explicit Congestion Notification (ECN) bits within
+ * IPv4 and IPv6 headers.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_CONTROL_OFST 50
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_CONTROL_LEN 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_ENCAP_COPY_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_ENCAP_COPY_LBN 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_ENCAP_COPY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_DECAP_COPY_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_DECAP_COPY_LBN 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_ECN_DECAP_COPY_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_ECN_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_ECN_LBN 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_DO_REPLACE_ECN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_VALUE_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_VALUE_LBN 3
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_VALUE_WIDTH 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_0_TO_CE_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_0_TO_CE_LBN 5
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_0_TO_CE_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_1_TO_CE_OFST 50
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_1_TO_CE_LBN 6
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_ECN_ECT_1_TO_CE_WIDTH 1
+/* Actions for overwriting CH_ROUTE subfields. */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_OVERWRITE_OFST 51
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_OVERWRITE_LEN 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_C_PL_OFST 51
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_C_PL_LBN 0
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_C_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_D_PL_OFST 51
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_D_PL_LBN 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_D_PL_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_PL_CHAN_OFST 51
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_PL_CHAN_LBN 2
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_PL_CHAN_WIDTH 1
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_OUT_HOST_CHAN_OFST 51
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_OUT_HOST_CHAN_LBN 3
+#define        MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_RDP_OUT_HOST_CHAN_WIDTH 1
+/* Override outgoing CH_VC to network port for DO_SET_NET_CHAN action. Cannot
+ * be used in conjunction with DO_SET_SRC_MPORT action.
+ */
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_NET_CHAN_OFST 52
+#define       MC_CMD_MAE_ACTION_SET_ALLOC_V3_IN_NET_CHAN_LEN 1
+
 /* MC_CMD_MAE_ACTION_SET_ALLOC_OUT msgresponse */
 #define    MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN 4
 /* The MSB of the AS_ID is guaranteed to be clear if the ID is not
diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.c b/drivers/net/ethernet/sfc/mcdi_vdpa.c
index 02ea0ace09ab..8f035e093281 100644
--- a/drivers/net/ethernet/sfc/mcdi_vdpa.c
+++ b/drivers/net/ethernet/sfc/mcdi_vdpa.c
@@ -14,14 +14,6 @@
 #include "mcdi_vdpa.h"
 #include "mcdi_pcol.h"
 
-/* The value of target_vf in virtio MC commands like
- * virtqueue create, delete and get doorbell offset should
- * contain the VF index when the calling function is a PF
- * and VF_NULL (0xFFFF) otherwise. As the vDPA driver invokes
- * MC commands in context of the VF, it uses VF_NULL.
- */
-#define MC_CMD_VIRTIO_TARGET_VF_NULL 0xFFFF
-
 struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx,  u32 vi,
 					  enum ef100_vdpa_vq_type vring_type)
 {
@@ -47,7 +39,7 @@ struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx,  u32 vi,
 	}
 
 	vring_ctx->efx = efx;
-	vring_ctx->vf_index = MC_CMD_VIRTIO_TARGET_VF_NULL;
+	vring_ctx->vf_index = MC_CMD_VIRTIO_INIT_QUEUE_REQ_VF_NULL;
 	vring_ctx->vi_index = vi;
 	vring_ctx->mcdi_vring_type = queue_cmd;
 	return vring_ctx;
-- 
2.30.1

