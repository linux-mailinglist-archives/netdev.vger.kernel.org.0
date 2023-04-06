Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206446D8FF5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbjDFHCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbjDFHBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:01:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C9CAD2F;
        Thu,  6 Apr 2023 00:01:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHGUaeo8INYnlQYGKRkGu5fjYJrwU5I1UldYDAPBAOcXTmx9cKZxz3sV4/S0oV1Tp4YG5676EfR0BFzY8FkwiCE7k8ADw1bFVFDN25gHdhBSgw/6Eb90OtKDCmTSQD6sn/EUZiCbiKueGaEQ5871lRo+asKWcs3NnjMgrSgcw4/kN1M9TzKhBEbALCGmxyvIFwVUIpsB7ibFGS1ufzZRHZ6c5oAjb55Ii9rzqHJktlA0uN92RDeE1E1T/vzFCmbXxg1po6u5BFh1evOv1lk2Ivkb/bTVuuLBLIwix9YaevfRo+3gIV0sz8bEs36+VA3cxUogCGpLxANZa5UsTuZfcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xyeixxY4ckFXb34CCEnXdbgeCLraOLBG95DjKix6Yo=;
 b=Jrq3nVyQ2pxO0iCFflrv3p5JRNbl63Wi1Wo4YtA74RYUWuJiEPc4pik1ifhBq7VyTaXYDTrxy4mQBDdKoaLmUrBP7LoJAQslW8AEULrBbhnUMHnf4aVIJJG/ROZSpFfl4bKdP7VZseRdjeEe7SrW4yPWYdRFPM/7DclRNbh/YbdqZJtJAByLhorYIQzqnb7/qlZmMAcqvnQakv57EBxaOpndd8kvkqfykFf9QpQEnQNmmu3Ta/1FRDthsK8MA5/b/bRBExgarXOAsUMzvMYKGRiUDoWYwC4F/8Qft0wu+fHEsbYniU/uR6t9f5govgCQRkRHf5W9YsSLNmosCLydNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xyeixxY4ckFXb34CCEnXdbgeCLraOLBG95DjKix6Yo=;
 b=vWYfyCpGbYSGQY8i1Sv9sz4/Nd14MsLc7r3W9DsIMuw3m1QSZm3kUQb0t85Q6ul+ohBNZOEXAS7b0iJ4otpoKgYbeRH9Z/KeuI4r34Fot99TxVQeHgBQ+KDb66RCj0BPdpqUHPMDKGtSzg9wwDrJOvu+XeHLebUIMb9qllSjSto=
Received: from DM6PR11CA0054.namprd11.prod.outlook.com (2603:10b6:5:14c::31)
 by IA1PR12MB6260.namprd12.prod.outlook.com (2603:10b6:208:3e4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:01:00 +0000
Received: from CY4PEPF0000C965.namprd02.prod.outlook.com
 (2603:10b6:5:14c:cafe::2a) by DM6PR11CA0054.outlook.office365.com
 (2603:10b6:5:14c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 6 Apr 2023 07:00:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C965.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 6 Apr 2023 07:00:59 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:00:58 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:00:57 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:00:53 -0500
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
Subject: [PATCH net-next v3 05/14] sfc: implement init and fini functions for vDPA personality
Date:   Thu, 6 Apr 2023 12:26:50 +0530
Message-ID: <20230406065706.59664-6-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C965:EE_|IA1PR12MB6260:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e1f286-fd9c-4b7d-d5fa-08db366cad85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c83qgMtnBWtS9g6VGyHrZhTqUgt3Bb5PkMdwYwqCwOcAgsLOMQ+4Aqy3wBgYznHrbY88RbKNQdm+pwxaSwks+S99GOQt+7TEK3L0+JC11a2tS1M3R7jvXGVGpZkrs9N+yIZpWYTUVNOCE/2IcrXI8fnlMz+yZ6QuC9NXf0ZJH78JL5YLVS1LieWp4xX4KmDSylxkEFQl5h5vw7MFbGg+CQbSSMlK6Y0FqCbNy1BnIxDYE0jnbaCiPnaPYuyOpRdR7df/dQ5XWf/Kor7/XKxgX2c7BSB6pMWNGAHDCaynT9+ZJ0rS+yqPVJsbnpAbu3vDryW+D5QXBsjzqZAfi6O9NPSuJ9fInzxBZfGXVCMF9VenEvn5C5dcB6wE4+rCuHt5POucc/3v+ML5Cvh9LnZ2Wb3WR9ZqNfw03osmWuarrv5h6Cj1T6DAiJuyNgQpi4M0mnowczXmwQVb0hLWOLQnoYMNoaDwYn314FvDWIFLYCbHXNCWQUbfUnSY/Pb33rCyLvnWRprRS3eMaa05xA5KkhgsM0aaycPAxhuLE/ZXG5wuBgZFwsqBrN/LE6F15fEcLX49fIVTBZvOpcoPNquIDGHHIt1NJL8DwWI8Sge3NVzno8ZOWWXTNoclLtmtxy5dWy+nzCDryAC/oxJrBwQZzujJIrmg0ugZkvGzkPg2N5Z8exzto8OVLdaALmNwqdoPTON/BOjFEmo2fvqNJQicBUhJyFhtbMnpkU7PT3hfJ0p/ddzZNEkBQ7/6B3AqMt7tzIRDJi8ozNh9fb/Fn9G+Wg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(86362001)(36756003)(2906002)(82310400005)(40480700001)(336012)(2616005)(83380400001)(186003)(47076005)(426003)(26005)(1076003)(4326008)(8676002)(921005)(70586007)(36860700001)(70206006)(40460700003)(478600001)(54906003)(356005)(5660300002)(7416002)(82740400003)(81166007)(110136005)(41300700001)(316002)(44832011)(8936002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:00:59.7560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e1f286-fd9c-4b7d-d5fa-08db366cad85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C965.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6260
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 498b398175d7..e139cd634ff9 100644
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
@@ -787,8 +790,8 @@ static const struct ef100_bar_config_ops bar_config_ops[] = {
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

