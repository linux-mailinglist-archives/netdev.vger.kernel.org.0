Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7774B645CFC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiLGO4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiLGO4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:34 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34D461502;
        Wed,  7 Dec 2022 06:56:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY1qR8CiFTy/6knkBZrfMWzG2sO5+wrHwcBg544jiJlysurYE1a7cZA3PIyziOjalRxxUUAtpAvfmgQIQv2M0QsWEBV4XgPoYrKqZ+9XZE1aCjCUicpnvOOCWJ4OfRp/xvy89hPOBijNfTlDF8n3lnOaCByuBaQQcwcCep1ZJsy2NLxvlbNiUEppktfWruKFlcmZloIh/8U/HOWpiduovKGGBLuj9ePf/RbtkhbjMW9hov1C1cXFwUJgVYHwQBvSwgmX4/e56A6+xsCJzYjAv95vUWNKBXMnsspBadZAeSMP4bcg8j2/c/hHoNKFEMWO1RGJ+J9tB5z0WgLx70VNAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PANQeQJX8qMH7dnXLPQEwFAodYlsrRUf3qLVS/p6ZBA=;
 b=G7X2MXY3/au24B9pTfvIa1Ful0+t6L8p/sgpvGLTwmE3bqRXtWHyFTr6f/ggVdYMQfaSXF6L7ts/Ep9eNgdR8lIp0WsJvBeeJ0Efsgv67sz8QauV8UIqw44CoOFR1l5yohzlNhJKqW9bmKR7JuSfjHSIqckM4EZBmfCwXSPMmEyNWqBkpcr2tPCi/WGTmDN8w0k7swWPvu2rXA8NM4Vi05C2V1U2jGljVMwn2SGy891Ncy8oflYbgV0wxFLAzBTe9rv/4b3C9o6V/iEbqJv+t4ozDVgbPgEJWFfUBIHHEM2mCt1uGxX6TXl7n6nX1gQdLDlXIBe/Itrq8pXtPaQIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PANQeQJX8qMH7dnXLPQEwFAodYlsrRUf3qLVS/p6ZBA=;
 b=yJw8CqROk8FavdUoVnhHs6mlBANBveLj8+EGB/wI8JGMpcVy1O41WLwYFhiyJ6mozj+TfKC//wB75nnXvCqOjNPwjSU8mDr+lJxCkzaxR3c9N6pbf4yg7artCsl/siT6Pqb2GxTFXCMXPF3AoXlItma8xoVYSTLxTdZ5fVvvdTE=
Received: from DM6PR02CA0053.namprd02.prod.outlook.com (2603:10b6:5:177::30)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 14:56:28 +0000
Received: from DS1PEPF0000E634.namprd02.prod.outlook.com
 (2603:10b6:5:177:cafe::ca) by DM6PR02CA0053.outlook.office365.com
 (2603:10b6:5:177::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E634.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:28 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:25 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:24 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:20 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 03/11] sfc: implement init and fini functions for vDPA personality
Date:   Wed, 7 Dec 2022 20:24:19 +0530
Message-ID: <20221207145428.31544-4-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E634:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a065168-b0be-4c8a-8e76-08dad8633894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 38dxOVqMBayVZdLcmjfxvGZd6a4rFQtKcPkHZTuTvqL/o/1gD9CDYiRUIC9bgcUE0wx076pxiCq0CwYe5KXlnXqnuY2ThVhUyNKULLDoDNo5Pb7MlkI5O/CRu24jAjIBI8Cnsh0U71s8/Nr57ohjrDOvF76IYMGDKx71FzLF2DUzV7X1d3TY24b5W1YaUMOoL1aULqWVXLHM3QwNuT2eZt7pTVcKg45DeB6N3rPmbsSHazbtgSP4GqN8oJXQH3h++7RYZ7ADHJ3yYo+dms2h7Op78fKm04NmaLi8Ok3LJ5KhTBYqkvOllsv65Q1diIZWVOOLC0+3e8l9k8RXSy3pP4bpfsNKT4eaWWnKh0BLBIBDSQck2bOOxRGx6y0UfRt3QN/Jb7HY9IOOKu5ue7XhKIXxp6xbJ4ybXgi6cpkH1uzzIW/CXJfdUFj1FptGBCjYLHlIOmuu99L/uiDCRM7CJ8B88nzqeJ+pPbjVHespBWASevIgIel1APb6j+HXIBHRrBFvmUhYMF7bzwbvjH+P0y128HA4bxr2HeLGq95KK4yqBlCPYaoStrOD6Eg/8ZfXQrR9k2t/RiJnHxpYLEOpwuJ2eWpzQA3ezgN3Ds/RhSAXX9m30clBXwaM8r8Ks8DrfqnTQXIwIciqPvgBzaRDNFpOSTiIlkANlJlS9JYQecLc2pOgMlk6EKsSf8yVKMYZ+4KJ9tB22YpLlxR/47GXU0jqJvp3Y4fYscgeg/65NBIqdqATCAevT3hGCo0DQNaG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(426003)(356005)(86362001)(81166007)(26005)(478600001)(82310400005)(82740400003)(36860700001)(70206006)(36756003)(83380400001)(1076003)(41300700001)(54906003)(70586007)(4326008)(8676002)(2906002)(44832011)(40460700003)(40480700001)(7416002)(8936002)(47076005)(2616005)(5660300002)(110136005)(336012)(316002)(186003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:28.8187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a065168-b0be-4c8a-8e76-08dad8633894
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E634.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
 drivers/net/ethernet/sfc/ef100_vdpa.c   | 58 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h   |  2 +
 drivers/net/ethernet/sfc/mcdi_filters.c | 51 ++++++++++++----------
 drivers/net/ethernet/sfc/net_driver.h   |  1 +
 6 files changed, 96 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 059a0944e89a..84c9f0590368 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -11,7 +11,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
-sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a57ec6d5b781..41175eb00326 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -27,6 +27,9 @@
 #include "tc.h"
 #include "mae.h"
 #include "rx_common.h"
+#ifdef CONFIG_SFC_VDPA
+#include "ef100_vdpa.h"
+#endif
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
@@ -768,8 +771,8 @@ static const struct ef100_bar_config_ops bar_config_ops[] = {
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
index 000000000000..5e215cee585a
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for Xilinx network controllers and boards
+ * Copyright(C) 2020-2022 Xilinx, Inc.
+ * Copyright(C) 2022 Advanced Micro Devices, Inc.
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
index f6564448d0c7..6b51a05becd8 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -28,5 +28,7 @@ enum ef100_vdpa_vq_type {
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
index 3b49e216768b..ffda80a95221 100644
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

