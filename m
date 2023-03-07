Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8F6ADDA6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCGLkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCGLi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:38:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED410F1;
        Tue,  7 Mar 2023 03:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJ5znMKRDpfeO9cNDYAoN+9WGMoBnjFByBG957c422EEpbViJyxfO2uhYcexPZTZWpSN4f+05trKMM2IIuE34KKaiMafLGJbPw4bXTWo3QswiOpp4/pasS9thVG5sDKawQjeziXqyeXy+wWRj7kBX6XU8/IXW3njazUDgyJKOsk5HxKXa4qSOZ8GEe8/DQwvsL58IC9pIbiM6NQvRFukxtRwP+zIiWvNhGQrRd7CRwSDK1XKt8QtslvX5JSHAERkgRi56nfEF0Pu3SNZTe5TBsTJVnqdaBE3vGDIgqViVikJ0QI/KueVGUBhOxiKNhKEkHw4gUZhi2+IUcwYWGla7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/VWEl7629KAeb6wb/8BHlBiofIvCYa6iqvuuKKn7wI=;
 b=eikWw/VTh1t9tl8/ywgEwxzILxrYATsXKdckUKnBHXTlYVM4njHWGDEnbTl6JA2+/38zPAslvOrmI77A+ZQrd6MaKcv22N8ZlOBJ8X7G5pQ7joRLhUZebs69mokXwsZ3ikeT2w/McFZNeNlDqyRwXA4UIiYTmTUG0QK/X6zPtFhAMHDuDlFpJpDFVkBGaITUQhWe1q5ijZ+6TiYFWqnlk2+/lEiUNmfVYOTagqjosgffhKfNH8o43T1ucVdCLaBpnqbUM9eFNLuuiG3HM0YHAUftrXB0cvcs8qXdFv2kDVWW1gntvSqIohemUUE2atxsloKqSXIO7SXSJk1K0rYrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/VWEl7629KAeb6wb/8BHlBiofIvCYa6iqvuuKKn7wI=;
 b=2FJbsII+/Q5Bs7wmsgRFM3Zr9T+yslMA94SqyyGKqTSWCZsf7H+1H09Q0IxIvlAL7emE6IroZugjeNyx0fUMU2ZHHrYT/3y0KpHC7WHemc8Ruxq74nHmkDYWPN9z47W98e/MR5tGHGRcUzL0TwYFbRy9to263jPwbJI4tpXIWZ8=
Received: from BN9P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::16)
 by DM4PR12MB8450.namprd12.prod.outlook.com (2603:10b6:8:188::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 11:37:19 +0000
Received: from BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::d) by BN9P220CA0011.outlook.office365.com
 (2603:10b6:408:13e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT093.mail.protection.outlook.com (10.13.177.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:37:18 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:17 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:16 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:37:12 -0600
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
Subject: [PATCH net-next v2 05/14] sfc: implement init and fini functions for vDPA personality
Date:   Tue, 7 Mar 2023 17:06:07 +0530
Message-ID: <20230307113621.64153-6-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT093:EE_|DM4PR12MB8450:EE_
X-MS-Office365-Filtering-Correlation-Id: a68a56d8-d995-497a-8ace-08db1f004ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXYIk2MmcuLDSHLWd1btZnJKx9giT0MmYfIjDO2vU6vc3iPWq0xT5RdUBBFcOSpeuChKBVIvHU3LmTVEBRnDwh4hdI5xmkZ4eIxVwIXvNAYNWbye7QelxAba+t2ccLjh15buUcSYdl6FbmMS8+qfXMe4JTAxDjedwxftYDOLcTjI0/+MOdmcLZhyBttj+72xANc2w5tidBPZslKhAXCkiSGriO793renpBQWs2JD0pNdt+wgEinSGDl1ZjRfxXbc0NVCNpdolBCrajtdO0kCx7O8hjVW+7cYcvAl/7xOUz2FUrmnGRgCxR4kqn9crmqLwkAO6jnK2eCc/9pKGiBQsDkw1SbUTHJ2g0N20bMjMIDdNOAafzo3UcVOu+xG9Zedr1rA4J6Eu1e66Oewii7r0RvqhD8XNPFq9ay+I+yaaY+SQGS9xeQKGaewf9cmlRNbzZ/MABbfzGKrc1XfTLRwW5ioMjjRo7TtU/qBZANO++sIjTiBKV4jzeVzZGG2vCx3ay2zYpypJ6sd1OaQbb9DIJlOW8q4zlyvJvZW+kVh6yvzF8kHsHB7hTcPa8lHYIyeVda/L4raSQLSRSNPI3AbefjAwDvmAj/RjLEbXoKXnlP/miIB2lMCJwNTpB0gDn+O5EgzHH9kOAh2m4m0fEtyZH/73TLq8RPoZavhDmk+5/e5CEo6K99ndPSLWwhk90AmYk6iN9/dbXdEIs4/cStbgdzoqGdeoiHyBgzsDFgNPf33RHydhCeQdzJVT8mHibheBDebjh/ORO2X/9fHr7TAjw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(356005)(36756003)(4326008)(70586007)(70206006)(44832011)(41300700001)(8936002)(5660300002)(7416002)(2906002)(921005)(6666004)(81166007)(86362001)(36860700001)(82740400003)(40480700001)(8676002)(26005)(1076003)(54906003)(316002)(110136005)(478600001)(82310400005)(83380400001)(47076005)(426003)(2616005)(336012)(186003)(40460700003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:37:18.7698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a68a56d8-d995-497a-8ace-08db1f004ef4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8450
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index ef6e295efcf7..8a9fff239d07 100644
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
@@ -779,8 +782,8 @@ static const struct ef100_bar_config_ops bar_config_ops[] = {
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

