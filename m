Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86659621A7E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiKHR0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiKHR0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4428C140AA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZB2Z0t26BH/LX/gUu+9iyHpBp5Jmdn4c1F9Dn5UNcbHCZ6QtqX1zCBQ6o+vbIayF/Va3aQTuPMzJmBa911cj+TCyWK5bOfRReJboMxawl3zmPFgkaVlCKl/hvVpaLGIejmRUbVj2lgq8GLjtvd6HAZAW7LdjbRJUVZznOduDevaeBMazVJZ8J8F4oFoeUY2e+yENRSAG6zWhNbs6792mFRi/xHoOZOZ4ZF1Ax8yhFwWsOk422bP86+Z57b3Q7pLaHvUDRlR2gKA1UwrSDTU8CA9Fa3ZwsaQ4ktxEJjwZ2cc7cxxfWD0HHYlFvgVqzA1Zb1WtppqTXlCIYcX9EFG+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=604SiAMOnOU5pHLBflQy2q7gT2iPW4aRoqOIFwmVxlQ=;
 b=SgVdICubYCbjUGwJwhikrGSeh/z2StNPyAbczK16Uvlyfbf4+kccmtUrsjew5eFf1e55BcqSR7EpkL8RsfGtljFZ1usYYFizCIabxcZBbNH6yt7YiFtLR79MwGDSIiJMpg740ew2b8y4Go1r0ntJBK6I96A3lhm6bt7grokMJPzYw7S43nn3ZMMLeyvkAL9eZvzhpMa2TFQQUphs/A34mzm2bo1cgklGYlGWOsagdyjZXp8FU68vMfhvg06uCKtdqltetueigJkDy/0nlf9lWTdvllLhgbdwukRCxdFGHAtQFNX2cYjZCgHL9HS0WOa92b1cabUXN2cmrO+QULjB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=604SiAMOnOU5pHLBflQy2q7gT2iPW4aRoqOIFwmVxlQ=;
 b=nQs+rD19rmQ5rZ5Es7wcJhTcu0/hz/+oMqqj8qjzkUB3F9q62AnLxwxRpHurggOSasbTKF2Va6qNrHGsAJycARmtf09TZP3oPMjL0NsAABFgRE6ScdHqJ3ARJuK9rkP6rEZR+f1YyFiCB1jO3lTLDpOwNcS9WYP3IkQqV1r3qEg=
Received: from MW4PR02CA0016.namprd02.prod.outlook.com (2603:10b6:303:16d::22)
 by DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Tue, 8 Nov
 2022 17:26:19 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::90) by MW4PR02CA0016.outlook.office365.com
 (2603:10b6:303:16d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:19 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:17 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:16 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 05/11] sfc: add extra RX channel to receive MAE counter updates on ef100
Date:   Tue, 8 Nov 2022 17:24:46 +0000
Message-ID: <10275fd9ce0c26866f8e69f00fb1c785ffa0c8ea.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|DS7PR12MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: c9748bcf-6806-4eca-b435-08dac1ae594f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GufKVlUeRQglm4AbEeU53AmZxOpqDAXZQ/O7l0tVFOAEuKwDV4y/0RRtxfU6ktTk4hNLrfNapPXeTlm9UwhfXQsxGKhUFwoGsw3k0msiSxhKY3n1hNW5sSnIq6/KcQ5gkVBCwtSRi5W3qCsmKQVoRVrbyGwcdQelMKTVNCipqVWLKewsF+hFGMVfUR4ykAeKnJyWW0DB0EW3q7urOwgsvdPY9uZGRJj6EAmzgPHmO0kp+WBo38AGQ898akQ1e7XaMkzO6sIxMJGFYfAi5z2bChRVWJV4MMppc9qI93ONH0kVDGXWZOjAwsE2WNy//+HHS6NYJhbyPstjT1Z6TkO6gjWoWt6ckZRfGihuLM01Lcob3ccsRNWb+2vogcC6jGuMZ4qB3sjD74JshOTJL3qDVBKfIyMSVdyNkMX9iosnYcvV7VTrhRO/EibKsXXzdahVSom6W+UvbQCkByVzhXhQZ0nAKdV3GTrjXY7wvDTueVWVCEOTHsa5f7VhNh2H2sT7WCxckE1U1jVolwOMkPY4SQjLEx2KfB5PZIE8kS9Flsl59s+e31SVogMjPNK1naOVSI47cV6CoiVlf20rEeorl7ibUC8MXBHB0h3V3zvutVlufg5yhLKYrFmrB6RbnWColkEG8/I+Xz7sgaqLgMgqp8aeg6JRY1gqMCy9RLVKLhZxzRe7lj/XoAHhNisRL8A/KkRLYwMxgp8UGB2AW8T/fYzpS24kUor+lFg8xgJ5RHwXMd4tgN+2MbH0xEoRTgqMO4zxGaxXJqgjjGl9qspeqDLz3sxIHfcD1Pdz8eJpmmqJR40KUhijWa6T+EkwzbGpeY1848My/HP5wGbrg9MiNA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(36860700001)(47076005)(55446002)(8936002)(86362001)(356005)(81166007)(6636002)(5660300002)(41300700001)(316002)(82740400003)(70586007)(186003)(70206006)(4326008)(8676002)(110136005)(478600001)(54906003)(2876002)(40460700003)(6666004)(426003)(15650500001)(30864003)(9686003)(26005)(83380400001)(2906002)(40480700001)(336012)(36756003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:19.1806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9748bcf-6806-4eca-b435-08dac1ae594f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Currently there is no counter-allocating machinery to connect the
 resulting counter update values to; that will be added in a
 subsequent patch.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile             |   2 +-
 drivers/net/ethernet/sfc/mae_counter_format.h |  73 +++++
 drivers/net/ethernet/sfc/net_driver.h         |   3 +-
 drivers/net/ethernet/sfc/tc.c                 |   1 +
 drivers/net/ethernet/sfc/tc.h                 |   9 +-
 drivers/net/ethernet/sfc/tc_counters.c        | 269 ++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h        |  26 ++
 7 files changed, 373 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mae_counter_format.h
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.c
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index b5e45fc6337e..712a48d00069 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -9,7 +9,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
-                           mae.o tc.o tc_bindings.o
+                           mae.o tc.o tc_bindings.o tc_counters.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/mae_counter_format.h b/drivers/net/ethernet/sfc/mae_counter_format.h
new file mode 100644
index 000000000000..7e252e393fbe
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mae_counter_format.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2020 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+/* Format of counter packets (version 2) from the ef100 Match-Action Engine */
+
+#ifndef EFX_MAE_COUNTER_FORMAT_H
+#define EFX_MAE_COUNTER_FORMAT_H
+
+
+/*------------------------------------------------------------*/
+/*
+ * ER_RX_SL_PACKETISER_HEADER_WORD(160bit):
+ * 
+ */
+#define ER_RX_SL_PACKETISER_HEADER_WORD_SIZE 20
+#define ER_RX_SL_PACKETISER_HEADER_WORD_WIDTH 160
+
+#define ERF_SC_PACKETISER_HEADER_VERSION_LBN 0
+#define ERF_SC_PACKETISER_HEADER_VERSION_WIDTH 8
+#define ERF_SC_PACKETISER_HEADER_VERSION_VALUE 2
+#define ERF_SC_PACKETISER_HEADER_IDENTIFIER_LBN 8
+#define ERF_SC_PACKETISER_HEADER_IDENTIFIER_WIDTH 8
+#define ERF_SC_PACKETISER_HEADER_IDENTIFIER_AR 0
+#define ERF_SC_PACKETISER_HEADER_IDENTIFIER_CT 1
+#define ERF_SC_PACKETISER_HEADER_IDENTIFIER_OR 2
+#define ERF_SC_PACKETISER_HEADER_HEADER_OFFSET_LBN 16
+#define ERF_SC_PACKETISER_HEADER_HEADER_OFFSET_WIDTH 8
+#define ERF_SC_PACKETISER_HEADER_HEADER_OFFSET_DEFAULT 0x4
+#define ERF_SC_PACKETISER_HEADER_PAYLOAD_OFFSET_LBN 24
+#define ERF_SC_PACKETISER_HEADER_PAYLOAD_OFFSET_WIDTH 8
+#define ERF_SC_PACKETISER_HEADER_PAYLOAD_OFFSET_DEFAULT 0x14
+#define ERF_SC_PACKETISER_HEADER_INDEX_LBN 32
+#define ERF_SC_PACKETISER_HEADER_INDEX_WIDTH 16
+#define ERF_SC_PACKETISER_HEADER_COUNT_LBN 48
+#define ERF_SC_PACKETISER_HEADER_COUNT_WIDTH 16
+#define ERF_SC_PACKETISER_HEADER_RESERVED_0_LBN 64
+#define ERF_SC_PACKETISER_HEADER_RESERVED_0_WIDTH 32
+#define ERF_SC_PACKETISER_HEADER_RESERVED_1_LBN 96
+#define ERF_SC_PACKETISER_HEADER_RESERVED_1_WIDTH 32
+#define ERF_SC_PACKETISER_HEADER_RESERVED_2_LBN 128
+#define ERF_SC_PACKETISER_HEADER_RESERVED_2_WIDTH 32
+
+
+/*------------------------------------------------------------*/
+/*
+ * ER_RX_SL_PACKETISER_PAYLOAD_WORD(128bit):
+ * 
+ */
+#define ER_RX_SL_PACKETISER_PAYLOAD_WORD_SIZE 16
+#define ER_RX_SL_PACKETISER_PAYLOAD_WORD_WIDTH 128
+
+#define ERF_SC_PACKETISER_PAYLOAD_COUNTER_INDEX_LBN 0
+#define ERF_SC_PACKETISER_PAYLOAD_COUNTER_INDEX_WIDTH 24
+#define ERF_SC_PACKETISER_PAYLOAD_RESERVED_LBN 24
+#define ERF_SC_PACKETISER_PAYLOAD_RESERVED_WIDTH 8
+#define ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_OFST 4
+#define ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_SIZE 6
+#define ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_LBN 32
+#define ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_WIDTH 48
+#define ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_OFST 10
+#define ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_SIZE 6
+#define ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_LBN 80
+#define ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_WIDTH 48
+
+
+#endif /* EFX_MAE_COUNTER_FORMAT_H */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 1e42f3447b24..3b49e216768b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -56,7 +56,8 @@
 #define EFX_MAX_RX_QUEUES EFX_MAX_CHANNELS
 #define EFX_EXTRA_CHANNEL_IOV	0
 #define EFX_EXTRA_CHANNEL_PTP	1
-#define EFX_MAX_EXTRA_CHANNELS	2U
+#define EFX_EXTRA_CHANNEL_TC	2
+#define EFX_MAX_EXTRA_CHANNELS	3U
 
 /* Checksum generation is a per-queue option in hardware, so each
  * queue visible to the networking core is backed by two hardware TX
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 894f578b3296..37d56a1ba958 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -761,6 +761,7 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->tc->dflt.pf.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
 	efx->tc->dflt.wire.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
 	mutex_destroy(&efx->tc->mutex);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 464fc92e2d37..97dc06f2e694 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -14,14 +14,7 @@
 #include <net/flow_offload.h>
 #include <linux/rhashtable.h>
 #include "net_driver.h"
-#include "mcdi_pcol.h" /* for MAE_COUNTER_TYPE_* */
-
-enum efx_tc_counter_type {
-	EFX_TC_COUNTER_TYPE_AR = MAE_COUNTER_TYPE_AR,
-	EFX_TC_COUNTER_TYPE_CT = MAE_COUNTER_TYPE_CT,
-	EFX_TC_COUNTER_TYPE_OR = MAE_COUNTER_TYPE_OR,
-	EFX_TC_COUNTER_TYPE_MAX
-};
+#include "tc_counters.h"
 
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
new file mode 100644
index 000000000000..4a310cd7f17f
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2022 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "tc_counters.h"
+#include "mae_counter_format.h"
+#include "mae.h"
+#include "rx_common.h"
+
+/* TC Channel.  Counter updates are delivered on this channel's RXQ. */
+
+static void efx_tc_handle_no_channel(struct efx_nic *efx)
+{
+	netif_warn(efx, drv, efx->net_dev,
+		   "MAE counters require MSI-X and 1 additional interrupt vector.\n");
+}
+
+static int efx_tc_probe_channel(struct efx_channel *channel)
+{
+	struct efx_rx_queue *rx_queue = &channel->rx_queue;
+
+	channel->irq_moderation_us = 0;
+	rx_queue->core_index = 0;
+
+	INIT_WORK(&rx_queue->grant_work, efx_mae_counters_grant_credits);
+
+	return 0;
+}
+
+static int efx_tc_start_channel(struct efx_channel *channel)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	struct efx_nic *efx = channel->efx;
+
+	return efx_mae_start_counters(efx, rx_queue);
+}
+
+static void efx_tc_stop_channel(struct efx_channel *channel)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	struct efx_nic *efx = channel->efx;
+	int rc;
+
+	rc = efx_mae_stop_counters(efx, rx_queue);
+	if (rc)
+		netif_warn(efx, drv, efx->net_dev,
+			   "Failed to stop MAE counters streaming, rc=%d.\n",
+			   rc);
+	rx_queue->grant_credits = false;
+	flush_work(&rx_queue->grant_work);
+}
+
+static void efx_tc_remove_channel(struct efx_channel *channel)
+{
+}
+
+static void efx_tc_get_channel_name(struct efx_channel *channel,
+				    char *buf, size_t len)
+{
+	snprintf(buf, len, "%s-mae", channel->efx->name);
+}
+
+static void efx_tc_counter_update(struct efx_nic *efx,
+				  enum efx_tc_counter_type counter_type,
+				  u32 counter_idx, u64 packets, u64 bytes,
+				  u32 mark)
+{
+	/* Software counter objects do not exist yet, for now we ignore this */
+}
+
+static void efx_tc_rx_version_1(struct efx_nic *efx, const u8 *data, u32 mark)
+{
+	u16 n_counters, i;
+
+	/* Header format:
+	 * + |   0    |   1    |   2    |   3    |
+	 * 0 |version |         reserved         |
+	 * 4 |    seq_index    |   n_counters    |
+	 */
+
+	n_counters = le16_to_cpu(*(const __le16 *)(data + 6));
+
+	/* Counter update entry format:
+	 * | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | a | b | c | d | e | f |
+	 * |  counter_idx  |     packet_count      |      byte_count       |
+	 */
+	for (i = 0; i < n_counters; i++) {
+		const void *entry = data + 8 + 16 * i;
+		u64 packet_count, byte_count;
+		u32 counter_idx;
+
+		counter_idx = le32_to_cpu(*(const __le32 *)entry);
+		packet_count = le32_to_cpu(*(const __le32 *)(entry + 4)) |
+			       ((u64)le16_to_cpu(*(const __le16 *)(entry + 8)) << 32);
+		byte_count = le16_to_cpu(*(const __le16 *)(entry + 10)) |
+			     ((u64)le32_to_cpu(*(const __le32 *)(entry + 12)) << 16);
+		efx_tc_counter_update(efx, EFX_TC_COUNTER_TYPE_AR, counter_idx,
+				      packet_count, byte_count, mark);
+	}
+}
+
+#define TCV2_HDR_PTR(pkt, field)						\
+	((void)BUILD_BUG_ON_ZERO(ERF_SC_PACKETISER_HEADER_##field##_LBN & 7),	\
+	 (pkt) + ERF_SC_PACKETISER_HEADER_##field##_LBN / 8)
+#define TCV2_HDR_BYTE(pkt, field)						\
+	((void)BUILD_BUG_ON_ZERO(ERF_SC_PACKETISER_HEADER_##field##_WIDTH != 8),\
+	 *TCV2_HDR_PTR(pkt, field))
+#define TCV2_HDR_WORD(pkt, field)						\
+	((void)BUILD_BUG_ON_ZERO(ERF_SC_PACKETISER_HEADER_##field##_WIDTH != 16),\
+	 (void)BUILD_BUG_ON_ZERO(ERF_SC_PACKETISER_HEADER_##field##_LBN & 15),	\
+	 *(__force const __le16 *)TCV2_HDR_PTR(pkt, field))
+#define TCV2_PKT_PTR(pkt, poff, i, field)					\
+	((void)BUILD_BUG_ON_ZERO(ERF_SC_PACKETISER_PAYLOAD_##field##_LBN & 7),	\
+	 (pkt) + ERF_SC_PACKETISER_PAYLOAD_##field##_LBN/8 + poff +		\
+	 i * ER_RX_SL_PACKETISER_PAYLOAD_WORD_SIZE)
+
+/* Read a little-endian 48-bit field with 16-bit alignment */
+static u64 efx_tc_read48(const __le16 *field)
+{
+	u64 out = 0;
+	int i;
+
+	for (i = 0; i < 3; i++)
+		out |= (u64)le16_to_cpu(field[i]) << (i * 16);
+	return out;
+}
+
+static enum efx_tc_counter_type efx_tc_rx_version_2(struct efx_nic *efx,
+						    const u8 *data, u32 mark)
+{
+	u8 payload_offset, header_offset, ident;
+	enum efx_tc_counter_type type;
+	u16 n_counters, i;
+
+	ident = TCV2_HDR_BYTE(data, IDENTIFIER);
+	switch (ident) {
+	case ERF_SC_PACKETISER_HEADER_IDENTIFIER_AR:
+		type = EFX_TC_COUNTER_TYPE_AR;
+		break;
+	case ERF_SC_PACKETISER_HEADER_IDENTIFIER_CT:
+		type = EFX_TC_COUNTER_TYPE_CT;
+		break;
+	case ERF_SC_PACKETISER_HEADER_IDENTIFIER_OR:
+		type = EFX_TC_COUNTER_TYPE_OR;
+		break;
+	default:
+		if (net_ratelimit())
+			netif_err(efx, drv, efx->net_dev,
+				  "ignored v2 MAE counter packet (bad identifier %u"
+				  "), counters may be inaccurate\n", ident);
+		return EFX_TC_COUNTER_TYPE_MAX;
+	}
+	header_offset = TCV2_HDR_BYTE(data, HEADER_OFFSET);
+	/* mae_counter_format.h implies that this offset is fixed, since it
+	 * carries on with SOP-based LBNs for the fields in this header
+	 */
+	if (header_offset != ERF_SC_PACKETISER_HEADER_HEADER_OFFSET_DEFAULT) {
+		if (net_ratelimit())
+			netif_err(efx, drv, efx->net_dev,
+				  "choked on v2 MAE counter packet (bad header_offset %u"
+				  "), counters may be inaccurate\n", header_offset);
+		return EFX_TC_COUNTER_TYPE_MAX;
+	}
+	payload_offset = TCV2_HDR_BYTE(data, PAYLOAD_OFFSET);
+	n_counters = le16_to_cpu(TCV2_HDR_WORD(data, COUNT));
+
+	for (i = 0; i < n_counters; i++) {
+		const void *counter_idx_p, *packet_count_p, *byte_count_p;
+		u64 packet_count, byte_count;
+		u32 counter_idx;
+
+		/* 24-bit field with 32-bit alignment */
+		counter_idx_p = TCV2_PKT_PTR(data, payload_offset, i, COUNTER_INDEX);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_COUNTER_INDEX_WIDTH != 24);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_COUNTER_INDEX_LBN & 31);
+		counter_idx = le32_to_cpu(*(const __le32 *)counter_idx_p) & 0xffffff;
+		/* 48-bit field with 16-bit alignment */
+		packet_count_p = TCV2_PKT_PTR(data, payload_offset, i, PACKET_COUNT);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_WIDTH != 48);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_PACKET_COUNT_LBN & 15);
+		packet_count = efx_tc_read48((const __le16 *)packet_count_p);
+		/* 48-bit field with 16-bit alignment */
+		byte_count_p = TCV2_PKT_PTR(data, payload_offset, i, BYTE_COUNT);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_WIDTH != 48);
+		BUILD_BUG_ON(ERF_SC_PACKETISER_PAYLOAD_BYTE_COUNT_LBN & 15);
+		byte_count = efx_tc_read48((const __le16 *)byte_count_p);
+
+		if (type == EFX_TC_COUNTER_TYPE_CT) {
+			/* CT counters are 1-bit saturating counters to update
+			 * the lastuse time in CT stats. A received CT counter
+			 * should have packet counter to 0 and only LSB bit on
+			 * in byte counter.
+			 */
+			if (packet_count || byte_count != 1)
+				netdev_warn_once(efx->net_dev,
+						 "CT counter with inconsistent state (%llu, %llu)\n",
+						 packet_count, byte_count);
+			/* Do not increment the driver's byte counter */
+			byte_count = 0;
+		}
+
+		efx_tc_counter_update(efx, type, counter_idx, packet_count,
+				      byte_count, mark);
+	}
+	return type;
+}
+
+/* We always swallow the packet, whether successful or not, since it's not
+ * a network packet and shouldn't ever be forwarded to the stack.
+ * @mark is the generation count for counter allocations.
+ */
+static bool efx_tc_rx(struct efx_rx_queue *rx_queue, u32 mark)
+{
+	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
+	struct efx_rx_buffer *rx_buf = efx_rx_buffer(rx_queue,
+						     channel->rx_pkt_index);
+	const u8 *data = efx_rx_buf_va(rx_buf);
+	struct efx_nic *efx = rx_queue->efx;
+	enum efx_tc_counter_type type;
+	u8 version;
+
+	/* version is always first byte of packet */
+	version = *data;
+	switch (version) {
+	case 1:
+		type = EFX_TC_COUNTER_TYPE_AR;
+		efx_tc_rx_version_1(efx, data, mark);
+		break;
+	case ERF_SC_PACKETISER_HEADER_VERSION_VALUE: // 2
+		type = efx_tc_rx_version_2(efx, data, mark);
+		break;
+	default:
+		if (net_ratelimit())
+			netif_err(efx, drv, efx->net_dev,
+				  "choked on MAE counter packet (bad version %u"
+				  "); counters may be inaccurate\n",
+				  version);
+		goto out;
+	}
+
+	/* Update seen_gen unconditionally, to avoid a missed wakeup if
+	 * we race with efx_mae_stop_counters().
+	 */
+	efx->tc->seen_gen[type] = mark;
+	if (efx->tc->flush_counters &&
+	    (s32)(efx->tc->flush_gen[type] - mark) <= 0)
+		wake_up(&efx->tc->flush_wq);
+out:
+	efx_free_rx_buffers(rx_queue, rx_buf, 1);
+	channel->rx_pkt_n_frags = 0;
+	return true;
+}
+
+const struct efx_channel_type efx_tc_channel_type = {
+	.handle_no_channel	= efx_tc_handle_no_channel,
+	.pre_probe		= efx_tc_probe_channel,
+	.start			= efx_tc_start_channel,
+	.stop			= efx_tc_stop_channel,
+	.post_remove		= efx_tc_remove_channel,
+	.get_name		= efx_tc_get_channel_name,
+	.receive_raw		= efx_tc_rx,
+	.keep_eventq		= true,
+};
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
new file mode 100644
index 000000000000..400a39b00f01
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2022 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_TC_COUNTERS_H
+#define EFX_TC_COUNTERS_H
+#include "net_driver.h"
+
+#include "mcdi_pcol.h" /* for MAE_COUNTER_TYPE_* */
+
+enum efx_tc_counter_type {
+	EFX_TC_COUNTER_TYPE_AR = MAE_COUNTER_TYPE_AR,
+	EFX_TC_COUNTER_TYPE_CT = MAE_COUNTER_TYPE_CT,
+	EFX_TC_COUNTER_TYPE_OR = MAE_COUNTER_TYPE_OR,
+	EFX_TC_COUNTER_TYPE_MAX
+};
+
+extern const struct efx_channel_type efx_tc_channel_type;
+
+#endif /* EFX_TC_COUNTERS_H */
