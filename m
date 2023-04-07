Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7476DA9D3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbjDGIMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbjDGIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:12:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5058A5F8;
        Fri,  7 Apr 2023 01:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3AAWvcM078Tw1Tr1GX1ArU6dEnGXc9pnknTzzM4I3IoXupNc9y0MhKytUrr3SsGDvEVwA41m7Coj4BejXMvb5w4vM0ah6Sio4b1clVNwg9Rw1XsDCP+3MpugjfO8LgyGd8NpkcVgqBuB05kOdu7+UehBr8nNkUiZSFYaHDkwfk4WhLdqv28OPbYhOJ5uVBdiyNJkwX6lLW+aEPNUKED7k0MD6nwrtGbO5Vt1Tz9zadJcOJCY9lct9YWof6bDueQ23YyPDn0yrfgobZDapkxfSZRn8tlc1AtlwJlR89mn9sf1efG27chy6fmv/CWliXW72MqnfouDlJfI48msCLSUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEXY6eHqgWuKasJ74o/mh2ka5l0kCwfNCY/r1Cb7IYo=;
 b=J2J56+89s3UF5iYEkxzp1t8gU6dfF54roWTbJF5hETXP8ey/c3qyFAJzTSZ6BOYSEDNyRmRuctKaEzyytbHfWDz817phYrk+wGZlppkJsY8X6hLST5HoWhumTTOJykmAWt8IPgt2F9l7ZwQqs6lBPPOmqw4C6SNseUL6pPeG1D9PYhVpQhXujdRnrsmyYRNGkP16NDhuXXecnmXA12S1tTmOn+QN3RdPCQ3K1ol7WLsYDS2TAsUOjLd6dxatajdG/qXzL05fWJd5vZVAXtkva03TCp2m27AON5BxO2Jze1UZo+fO3MDieVQkBjqkPDNqAWA7AdOnxx/SanfS+VsFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEXY6eHqgWuKasJ74o/mh2ka5l0kCwfNCY/r1Cb7IYo=;
 b=cEEvyV0uzheJXx0gub4c524Pl/novgt3DGXsz4LMigfxDa7S1kP65PdJJTccINzYcwyHJnBA0MKI6ROAf6aVTu42tu7xD3WolDFp1a5qxvZxb4yNVrA6UTN9wmoPoaxDN7lNVK777JbPCl1hQgcXP0a78V+o/4biJEdl5/7qlLQ=
Received: from MW4PR03CA0084.namprd03.prod.outlook.com (2603:10b6:303:b6::29)
 by CY5PR12MB6648.namprd12.prod.outlook.com (2603:10b6:930:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 08:11:23 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::18) by MW4PR03CA0084.outlook.office365.com
 (2603:10b6:303:b6::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Fri, 7 Apr 2023 08:11:23 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:21 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:17 -0500
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
Subject: [PATCH net-next v4 05/14] sfc: implement init and fini functions for vDPA personality
Date:   Fri, 7 Apr 2023 13:40:06 +0530
Message-ID: <20230407081021.30952-6-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|CY5PR12MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: 5479cc3d-8fbc-4c55-9641-08db373fad56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saB0xRE4gKV2+y1eEBykvOK96WzyDX5l8HAOVqnJ90RaodVJ2f0FVLkkkrO4dVAgYEY45zPfPw71md0zOLfM9W5YvDVbktJTBJ+PGLMyEtyHLU39PHW+bFw4yOJY1ImkO2V5Arc5JkauBiXN1gOsF2cIoJ4wU/k+Bwoobfwt+mTajrjrLMhll9u0x4CPGcY42nKshth03raYjxTlGxtLqs5kLTsi/v3/MrRJc5tP1NFrkfnKXMv03fDtXVvuS+iBwKVHShIOxAtC+ScdfuVRFcvHNrouCTL1AJFs0gnVxgRrc8rihA9tn4cHB2GHjGoJgmPIgrW0x6GPntcvgZ1iB3XdfF6YWYNW15Q7dLwhjK3YtC4Jg2cN5U3eNtG+t5wCfEJ7cuaMJZl2bFdwIDxMrJ52t6/xq2DMhxbkzcfRt4Nj68qekglKnPeCLE7OCLsIaNoeqdBwQxM+hiWIK4fIM6zbhxzVLq0Wb2/YaqOaGZKRWo3bVo1xYMUTsDAoWkUybfA2em0CKQ/IwkjvAn5m5tFHx35r8USNir4XwSdYIc+G/VXYLaFRBMDRLraSJ5FYUTD9R0nkzspEUYQvMquR1XpIFKcevqohhcvnUnrvgmhjH/hgf04DXikn8gHMnTJIx986W5OCX4cy8HTg12itEu6S+9iqNoJ+FLyxd1Cobi8N6xWrGCubgssd2xRAhlM9dLlwvZXB0a6pyXW5UqYoQdTyNgAQ0dFq9UNuHPNwpNLmKnrHK5IpwS33TmCxLaH+Ovwfl9hVYmJQwjTztfZp9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(36860700001)(478600001)(82310400005)(1076003)(26005)(82740400003)(6666004)(921005)(81166007)(36756003)(356005)(41300700001)(186003)(54906003)(4326008)(110136005)(70586007)(70206006)(316002)(86362001)(8936002)(8676002)(40480700001)(2616005)(83380400001)(336012)(426003)(5660300002)(44832011)(7416002)(47076005)(2906002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:23.2095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5479cc3d-8fbc-4c55-9641-08db373fad56
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6648
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bar_config for a PCIe function is changed from
EF100 to vDPA or vice-versa, corresponding EF100/vDPA fini/init
functions are invoked.
Also, because of the fact that a vDPA device doesn't have an
associated net device i.e. efx->net_dev is NULL, the code in
efx_mcdi_filter_table_probe() has been re-structured to have
the common code for both EF100 and vDPA personalities first
and then return early for vDPA case (before efx->net_dev is
accessed for EF100 personality).

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/Makefile       |  2 +-
 drivers/net/ethernet/sfc/ef100_nic.c    |  7 ++-
 drivers/net/ethernet/sfc/ef100_vdpa.c   | 57 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h   |  2 +
 drivers/net/ethernet/sfc/mcdi_filters.c | 51 ++++++++++++----------
 drivers/net/ethernet/sfc/net_driver.h   |  1 +
 6 files changed, 95 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index fb94fe3a9dfc..3a2bb98d1c3f 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -12,7 +12,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
-sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index e6e67a50610f..bc010b504b4a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -28,6 +28,9 @@
 #include "tc.h"
 #include "mae.h"
 #include "rx_common.h"
+#ifdef CONFIG_SFC_VDPA
+#include "ef100_vdpa.h"
+#endif
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
@@ -786,8 +789,8 @@ static const struct ef100_bar_config_ops bar_config_ops[] = {
 	},
 #ifdef CONFIG_SFC_VDPA
 	[EF100_BAR_CONFIG_VDPA] = {
-		.init = NULL,
-		.fini = NULL
+		.init = ef100_vdpa_init,
+		.fini = ef100_vdpa_fini
 	},
 #endif
 	[EF100_BAR_CONFIG_NONE] = {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
new file mode 100644
index 000000000000..268c973f7376
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for AMD network controllers and boards
+ * Copyright(C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include <linux/err.h>
+#include <linux/vdpa.h>
+#include <linux/virtio_net.h>
+#include "ef100_vdpa.h"
+#include "mcdi_vdpa.h"
+#include "mcdi_filters.h"
+#include "ef100_netdev.h"
+
+int ef100_vdpa_init(struct efx_probe_data *probe_data)
+{
+	struct efx_nic *efx = &probe_data->efx;
+	int rc;
+
+	if (efx->state != STATE_PROBED) {
+		pci_err(efx->pci_dev, "Invalid efx state %u", efx->state);
+		return -EBUSY;
+	}
+
+	efx->state = STATE_VDPA;
+	down_write(&efx->filter_sem);
+	rc = ef100_filter_table_probe(efx);
+	up_write(&efx->filter_sem);
+	if (rc) {
+		pci_err(efx->pci_dev, "filter probe failed, err: %d\n", rc);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	efx->state = STATE_PROBED;
+	return rc;
+}
+
+void ef100_vdpa_fini(struct efx_probe_data *probe_data)
+{
+	struct efx_nic *efx = &probe_data->efx;
+
+	if (efx->state != STATE_VDPA && efx->state != STATE_DISABLED) {
+		pci_err(efx->pci_dev, "Invalid efx state %u", efx->state);
+		return;
+	}
+
+	efx->state = STATE_PROBED;
+	down_write(&efx->filter_sem);
+	efx_mcdi_filter_table_remove(efx);
+	up_write(&efx->filter_sem);
+}
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 90062fd8a25d..ccc5eb0a2a84 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -27,5 +27,7 @@ enum ef100_vdpa_vq_type {
 	EF100_VDPA_VQ_NTYPES
 };
 
+int ef100_vdpa_init(struct efx_probe_data *probe_data);
+void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 #endif /* CONFIG_SFC_VDPA */
 #endif /* __EF100_VDPA_H__ */
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 4ff6586116ee..fde2b5b50ade 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1282,14 +1282,14 @@ efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
 				pd_match_pri);
 		rc = efx_mcdi_filter_match_flags_from_mcdi(encap, mcdi_flags);
 		if (rc < 0) {
-			netif_dbg(efx, probe, efx->net_dev,
-				  "%s: fw flags %#x pri %u not supported in driver\n",
-				  __func__, mcdi_flags, pd_match_pri);
+			pci_dbg(efx->pci_dev,
+				"%s: fw flags %#x pri %u not supported in driver\n",
+				__func__, mcdi_flags, pd_match_pri);
 		} else {
-			netif_dbg(efx, probe, efx->net_dev,
-				  "%s: fw flags %#x pri %u supported as driver flags %#x pri %u\n",
-				  __func__, mcdi_flags, pd_match_pri,
-				  rc, table->rx_match_count);
+			pci_dbg(efx->pci_dev,
+				"%s: fw flags %#x pri %u supported as driver flags %#x pri %u\n",
+				__func__, mcdi_flags, pd_match_pri,
+				rc, table->rx_match_count);
 			table->rx_match_mcdi_flags[table->rx_match_count] = mcdi_flags;
 			table->rx_match_count++;
 		}
@@ -1318,11 +1318,26 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 	table->rx_match_count = 0;
 	rc = efx_mcdi_filter_table_probe_matches(efx, table, false);
 	if (rc)
-		goto fail;
+		goto fail1;
+	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
+					  sizeof(*table->entry)));
+	if (!table->entry) {
+		rc = -ENOMEM;
+		goto fail1;
+	}
+
+	table->mc_promisc_last = false;
+	INIT_LIST_HEAD(&table->vlan_list);
+	init_rwsem(&table->lock);
+
+	efx->filter_state = table;
+	if (efx->state == STATE_VDPA)
+		return 0;
+
 	if (efx_has_cap(efx, VXLAN_NVGRE))
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
-		goto fail;
+		goto fail2;
 	if ((efx_supported_features(efx) & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
@@ -1335,24 +1350,16 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 	}
 
-	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
-					  sizeof(*table->entry)));
-	if (!table->entry) {
-		rc = -ENOMEM;
-		goto fail;
-	}
-
-	table->mc_promisc_last = false;
 	table->vlan_filter =
 		!!(efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
-	INIT_LIST_HEAD(&table->vlan_list);
-	init_rwsem(&table->lock);
-
-	efx->filter_state = table;
 
 	return 0;
-fail:
+
+fail2:
+	vfree(table->entry);
+fail1:
 	kfree(table);
+	efx->filter_state = NULL;
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index fcd51d3992fa..3dc9eae5a81d 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -646,6 +646,7 @@ enum nic_state {
 	STATE_NET_DOWN,		/* netdev registered */
 	STATE_NET_UP,		/* ready for traffic */
 	STATE_DISABLED,		/* device disabled due to hardware errors */
+	STATE_VDPA,		/* device bar_config changed to vDPA */
 
 	STATE_RECOVERY = 0x100,/* recovering from PCI error */
 	STATE_FROZEN = 0x200,	/* frozen by power management */
-- 
2.30.1

