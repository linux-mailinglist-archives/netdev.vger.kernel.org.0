Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA57645D0B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLGO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiLGO45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:57 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF46150D;
        Wed,  7 Dec 2022 06:56:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpR4T495MIYMzyPqkaC4EChCD5yMEzFhvbLjC9XwmR2FJW0nHKgYJmJ5lLtzkivIOXWsIofy0Y8T5L4p/K3L1g2JP92FLrv78pU2Q3wYERT9R0cUa533jm9f/iyu0/PtTdD0gf3coFKbrWUWWffv23jcW19rjBpntUZvonnLeyOwM9XLetgPx2s7ACzRbnsgFf3d07YgYPZSuOb6tdOlr6rHh2OMzmbG4rg/0y1MhJoT75BLBl7IWzSODo/6Lvw+LEcMx85VAGN+JSxUWWgHvPg5gt0tPQOQXkzRiDaIONT/Yogmb83t75LF6mLXNzSxeYjXTNdetOdxZagMG50v2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSXOwyGhioi9rIw6XzCWswo7Bg6HUujNaj3TOcrr9vk=;
 b=nqT71QdpjJd2xNbnUu3iGlxD0Yn07ujzYx86v8XmRzwnsz1+qx9fwVX7EBGP16ajDelpJwT54cbORs3OJ3D7LXC3kwwpsAsu1DleZllrj7koMWOBapl1P8rBIfERJiHVq82L+icXapV/2+x9aPKWePZwmsO4gcTypblvuMUjRgF7dhievT232cuT09wBOUuIavg2f5DDhOGK6USTYL6OyE2Q3uMjaYLyJanyQ6R/omCVozj06S+PIBfBWU9k3P1veYYq/roWkGfhfQmZ/CBHK/SmaMmsVRz35R3Vk6OnuKb2kIOdcFEYqq6v5js3YpD7V5TTr1yMAehYEQLumXHSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSXOwyGhioi9rIw6XzCWswo7Bg6HUujNaj3TOcrr9vk=;
 b=o26fnRIFP/CQM5gsNSoux7KH3Ix5xTY62kjt5tcxdHIOMmZcsF+aNgOeAHOyqE02P4qNrSH/sKgYdiEqVQtREoPKAsEUPTvs3ahydRVQapPy/FuidIbK5ptyu6MZz1pULJNdfqIEI36GlZy3PHhDAp+xv6DefAvaMkaPImgI/wg=
Received: from DM5PR08CA0032.namprd08.prod.outlook.com (2603:10b6:4:60::21) by
 SJ2PR12MB7865.namprd12.prod.outlook.com (2603:10b6:a03:4cc::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 14:56:44 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:4:60:cafe::6d) by DM5PR08CA0032.outlook.office365.com
 (2603:10b6:4:60::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:44 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:42 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:42 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:38 -0600
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
Subject: [PATCH net-next 06/11] sfc: implement vdpa vring config operations
Date:   Wed, 7 Dec 2022 20:24:22 +0530
Message-ID: <20221207145428.31544-7-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|SJ2PR12MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: d05ff206-6b06-459c-4b3c-08dad86341b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c1ThylNiC2zSf/JHfO9xytRlvTKGeSzwoGw1ahCE85hq8dj3AaCGSDAmhOAvazA+p8IA3ahMPJy9EDiwUuFYMSTb7XCdu+zVOM5sW8z1/yalPsO7LgRjtfHO4eUPmIggvzPB+e0wFUhCyqD73ffId5L5T07pg69zQMjsDWMX7ERh0LP+OIja6VPCM1ZPKAx6YNrMoOveNuQWL1e4PKha3GTJoCTVmc3ilPp6Scb5QJT5q0O82qNRCiA6+zqwbMPuNyA48edbkw2rXIsL47e2B+dH7/Ycku3pWJ0/moowLsJumYT/7L+ihru1fUlG6kVim/s2fBRAdjJD8HMQLcEdJSA9M57cXhQ/KpGI4xNwvN5NVpfMofzTNRxKcOOcxx8V/tc0skIV3/BGU6mvlGQtsxM2VcdgHfkTW+UxFSfKgJRweU9dXrlJw5hqZnu7eAg7Zk+LQJCXnHiveQm4wyRclzyHUMTzIQ3acRWkI4T/Pvk/h9t1rmv/6za5u/KPqdGwzmqQE9urg5CbWVNLFiBv3fsnQKJgUGAAIjSqXcMGc+ERoqyhZx0kE6r5n4FZekvHj++LVd/x9C3r0a8RopDT/4/hE2Kkk+xfT8aFFmM3yrn7JXE8VTqCvwrS1ffsOlhlu/QfABLG+ISirxft8GIYd0SYposrGBtnZb8yD0I+esBytNqwQnIE96HE2kwAyRjQUxdekyD8zp+GZ87aYca+LG52bD5rnGjqxAZuSvFcYIM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(2906002)(83380400001)(36860700001)(41300700001)(1076003)(336012)(70586007)(186003)(36756003)(70206006)(2616005)(40460700003)(82310400005)(86362001)(40480700001)(81166007)(356005)(54906003)(110136005)(26005)(426003)(82740400003)(47076005)(7416002)(30864003)(44832011)(8936002)(8676002)(478600001)(4326008)(316002)(5660300002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:44.1458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d05ff206-6b06-459c-4b3c-08dad86341b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7865
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the vDPA config operations related to
virtqueues or vrings. These include setting vring address,
getting vq state, operations to enable/disable a vq etc.
The resources required for vring operations eg. VI, interrupts etc.
are also allocated.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  58 ++-
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  55 +++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 449 +++++++++++++++++++++-
 3 files changed, 560 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index ff4bb61e598e..41eb7aef6798 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -15,6 +15,7 @@
 #include "ef100_vdpa.h"
 #include "mcdi_vdpa.h"
 #include "mcdi_filters.h"
+#include "mcdi_functions.h"
 #include "ef100_netdev.h"
 
 static struct virtio_device_id ef100_vdpa_id_table[] = {
@@ -48,6 +49,24 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
 	return rc;
 }
 
+static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
+{
+	/* The first VI is reserved for MCDI
+	 * 1 VI each for rx + tx ring
+	 */
+	unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
+	unsigned int min_vis = 1 + 1;
+	int rc;
+
+	rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
+				NULL, allocated_vis);
+	if (!rc)
+		return rc;
+	if (*allocated_vis < min_vis)
+		return -ENOSPC;
+	return 0;
+}
+
 static void ef100_vdpa_delete(struct efx_nic *efx)
 {
 	if (efx->vdpa_nic) {
@@ -55,6 +74,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
 		put_device(&efx->vdpa_nic->vdpa_dev.dev);
 		efx->vdpa_nic = NULL;
 	}
+	efx_mcdi_free_vis(efx);
 }
 
 void ef100_vdpa_fini(struct efx_probe_data *probe_data)
@@ -106,10 +126,20 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 	struct ef100_vdpa_nic *vdpa_nic;
+	unsigned int allocated_vis;
 	struct device *dev;
 	int rc;
+	u8 i;
 
 	nic_data->vdpa_class = dev_type;
+	rc = vdpa_allocate_vis(efx, &allocated_vis);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"%s Alloc VIs failed for vf:%u error:%d\n",
+			 __func__, nic_data->vf_index, rc);
+		return ERR_PTR(rc);
+	}
+
 	vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
 				     vdpa_dev, &efx->pci_dev->dev,
 				     &ef100_vdpa_config_ops,
@@ -120,7 +150,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 			"vDPA device allocation failed for vf: %u\n",
 			nic_data->vf_index);
 		nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
-		return ERR_PTR(-ENOMEM);
+		rc = -ENOMEM;
+		goto err_alloc_vis_free;
 	}
 
 	mutex_init(&vdpa_nic->lock);
@@ -129,6 +160,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
 	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
 	vdpa_nic->efx = efx;
+	vdpa_nic->max_queue_pairs = allocated_vis - 1;
 	vdpa_nic->pf_index = nic_data->pf_index;
 	vdpa_nic->vf_index = nic_data->vf_index;
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
@@ -136,6 +168,27 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	ether_addr_copy(vdpa_nic->mac_address, mac);
 	vdpa_nic->mac_configured = true;
 
+	for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++)
+		vdpa_nic->vring[i].irq = -EINVAL;
+
+	rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
+					  vdpa_nic->max_queue_pairs * 2);
+	if (rc < 0) {
+		pci_err(efx->pci_dev,
+			"vDPA IRQ alloc failed for vf: %u err:%d\n",
+			nic_data->vf_index, rc);
+		goto err_put_device;
+	}
+
+	rc = devm_add_action_or_reset(&efx->pci_dev->dev,
+				      ef100_vdpa_irq_vectors_free,
+				      efx->pci_dev);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"Failed adding devres for freeing irq vectors\n");
+		goto err_put_device;
+	}
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
@@ -147,6 +200,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 err_put_device:
 	/* put_device invokes ef100_vdpa_free */
 	put_device(&vdpa_nic->vdpa_dev.dev);
+
+err_alloc_vis_free:
+	efx_mcdi_free_vis(efx);
 	return ERR_PTR(rc);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index be7650c3166a..3cc33daa0431 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -33,6 +33,20 @@
 /* Alignment requirement of the Virtqueue */
 #define EF100_VDPA_VQ_ALIGN 4096
 
+/* Vring configuration definitions */
+#define EF100_VRING_ADDRESS_CONFIGURED 0x1
+#define EF100_VRING_SIZE_CONFIGURED 0x10
+#define EF100_VRING_READY_CONFIGURED 0x100
+#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
+				EF100_VRING_SIZE_CONFIGURED | \
+				EF100_VRING_READY_CONFIGURED)
+
+/* Maximum size of msix name */
+#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
+
+/* Default high IOVA for MCDI buffer */
+#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
+
 /**
  * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
  *
@@ -58,6 +72,43 @@ enum ef100_vdpa_vq_type {
 	EF100_VDPA_VQ_NTYPES
 };
 
+/**
+ * struct ef100_vdpa_vring_info - vDPA vring data structure
+ *
+ * @desc: Descriptor area address of the vring
+ * @avail: Available area address of the vring
+ * @used: Device area address of the vring
+ * @size: Number of entries in the vring
+ * @vring_state: bit map to track vring configuration
+ * @vring_created: set to true when vring is created.
+ * @last_avail_idx: last available index of the vring
+ * @last_used_idx: last used index of the vring
+ * @doorbell_offset: doorbell offset
+ * @doorbell_offset_valid: true if @doorbell_offset is updated
+ * @vring_type: type of vring created
+ * @vring_ctx: vring context information
+ * @msix_name: device name for vring irq handler
+ * @irq: irq number for vring irq handler
+ * @cb: callback for vring interrupts
+ */
+struct ef100_vdpa_vring_info {
+	dma_addr_t desc;
+	dma_addr_t avail;
+	dma_addr_t used;
+	u32 size;
+	u16 vring_state;
+	bool vring_created;
+	u32 last_avail_idx;
+	u32 last_used_idx;
+	u32 doorbell_offset;
+	bool doorbell_offset_valid;
+	enum ef100_vdpa_vq_type vring_type;
+	struct efx_vring_ctx *vring_ctx;
+	char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
+	u32 irq;
+	struct vdpa_callback cb;
+};
+
 /**
  *  struct ef100_vdpa_nic - vDPA NIC data structure
  *
@@ -71,6 +122,7 @@ enum ef100_vdpa_vq_type {
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
  * @net_config: virtio_net_config data
+ * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
  * @cfg_cb: callback for config change
@@ -87,6 +139,7 @@ struct ef100_vdpa_nic {
 	u64 features;
 	u32 max_queue_pairs;
 	struct virtio_net_config net_config;
+	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
 	bool mac_configured;
 	struct vdpa_callback cfg_cb;
@@ -96,6 +149,8 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
+int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
+void ef100_vdpa_irq_vectors_free(void *data);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 87899baa1c52..b7efd3e0c901 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -10,13 +10,441 @@
 
 #include <linux/vdpa.h>
 #include "ef100_vdpa.h"
+#include "io.h"
 #include "mcdi_vdpa.h"
 
+/* Get the queue's function-local index of the associated VI
+ * virtqueue number queue 0 is reserved for MCDI
+ */
+#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
+
 static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
 {
 	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
 }
 
+static irqreturn_t vring_intr_handler(int irq, void *arg)
+{
+	struct ef100_vdpa_vring_info *vring = arg;
+
+	if (vring->cb.callback)
+		return vring->cb.callback(vring->cb.private);
+
+	return IRQ_NONE;
+}
+
+int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs)
+{
+	int rc;
+
+	rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
+	if (rc < 0)
+		pci_err(pci_dev,
+			"Failed to alloc %d IRQ vectors, err:%d\n", nvqs, rc);
+	return rc;
+}
+
+void ef100_vdpa_irq_vectors_free(void *data)
+{
+	pci_free_irq_vectors(data);
+}
+
+static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
+	struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
+	int irq;
+	int rc;
+
+	snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
+		 pci_name(pci_dev), idx);
+	irq = pci_irq_vector(pci_dev, idx);
+	rc = devm_request_irq(&pci_dev->dev, irq, vring_intr_handler, 0,
+			      vring->msix_name, vring);
+	if (rc)
+		pci_err(pci_dev,
+			"devm_request_irq failed for vring %d, rc %d\n",
+			idx, rc);
+	else
+		vring->irq = irq;
+
+	return rc;
+}
+
+static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
+	struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
+
+	devm_free_irq(&pci_dev->dev, vring->irq, vring);
+	vring->irq = -EINVAL;
+}
+
+static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	if (vdpa_nic->vring[idx].vring_state == EF100_VRING_CONFIGURED &&
+	    vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
+	    !vdpa_nic->vring[idx].vring_created)
+		return true;
+
+	return false;
+}
+
+static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct efx_vring_ctx *vring_ctx;
+	u32 vi_index;
+
+	if (idx % 2) /* Even VQ for RX and odd for TX */
+		vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_TXQ;
+	else
+		vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_RXQ;
+	vi_index = EFX_GET_VI_INDEX(idx);
+	vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
+					vdpa_nic->vring[idx].vring_type);
+	if (IS_ERR(vring_ctx))
+		return PTR_ERR(vring_ctx);
+
+	vdpa_nic->vring[idx].vring_ctx = vring_ctx;
+	return 0;
+}
+
+static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
+	vdpa_nic->vring[idx].vring_ctx = NULL;
+}
+
+static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct efx_vring_dyn_cfg vring_dyn_cfg;
+	int rc;
+
+	rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
+				    &vring_dyn_cfg);
+	if (rc)
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: delete vring failed index:%u, err:%d\n",
+			__func__, idx, rc);
+	vdpa_nic->vring[idx].last_avail_idx = vring_dyn_cfg.avail_idx;
+	vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
+	vdpa_nic->vring[idx].vring_created = false;
+
+	irq_vring_fini(vdpa_nic, idx);
+
+	if (vdpa_nic->vring[idx].vring_ctx)
+		delete_vring_ctx(vdpa_nic, idx);
+
+	return rc;
+}
+
+static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct efx_vring_dyn_cfg vring_dyn_cfg;
+	struct efx_vring_ctx *vring_ctx;
+	struct efx_vring_cfg vring_cfg;
+	u32 offset;
+	int rc;
+
+	if (!vdpa_nic->vring[idx].vring_ctx) {
+		rc = create_vring_ctx(vdpa_nic, idx);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: create_vring_ctx failed idx:%u, err:%d\n",
+				__func__, idx, rc);
+			return rc;
+		}
+	}
+	vring_ctx = vdpa_nic->vring[idx].vring_ctx;
+
+	rc = irq_vring_init(vdpa_nic, idx);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: irq_vring_init failed. index:%u, err:%d\n",
+			__func__, idx, rc);
+		goto err_irq_vring_init;
+	}
+	vring_cfg.desc = vdpa_nic->vring[idx].desc;
+	vring_cfg.avail = vdpa_nic->vring[idx].avail;
+	vring_cfg.used = vdpa_nic->vring[idx].used;
+	vring_cfg.size = vdpa_nic->vring[idx].size;
+	vring_cfg.features = vdpa_nic->features;
+	vring_cfg.msix_vector = idx;
+	vring_dyn_cfg.avail_idx = vdpa_nic->vring[idx].last_avail_idx;
+	vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
+
+	rc = efx_vdpa_vring_create(vring_ctx, &vring_cfg, &vring_dyn_cfg);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: vring_create failed index:%u, err:%d\n",
+			__func__, idx, rc);
+		goto err_vring_create;
+	}
+	vdpa_nic->vring[idx].vring_created = true;
+	if (!vdpa_nic->vring[idx].doorbell_offset_valid) {
+		rc = efx_vdpa_get_doorbell_offset(vring_ctx, &offset);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: get offset failed, index:%u err:%d\n",
+				__func__, idx, rc);
+			goto err_get_doorbell_offset;
+		}
+		vdpa_nic->vring[idx].doorbell_offset = offset;
+		vdpa_nic->vring[idx].doorbell_offset_valid = true;
+	}
+
+	return 0;
+
+err_get_doorbell_offset:
+	efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
+			       &vring_dyn_cfg);
+	vdpa_nic->vring[idx].vring_created = false;
+err_vring_create:
+	irq_vring_fini(vdpa_nic, idx);
+err_irq_vring_init:
+	delete_vring_ctx(vdpa_nic, idx);
+
+	return rc;
+}
+
+static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	if (vdpa_nic->vring[idx].vring_created)
+		delete_vring(vdpa_nic, idx);
+
+	memset((void *)&vdpa_nic->vring[idx], 0,
+	       sizeof(vdpa_nic->vring[idx]));
+	vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
+}
+
+static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
+			   const char *caller)
+{
+	if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: Invalid qid %u\n", caller, idx);
+		return true;
+	}
+	return false;
+}
+
+static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
+				     u16 idx, u64 desc_area, u64 driver_area,
+				     u64 device_area)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return -EINVAL;
+
+	mutex_lock(&vdpa_nic->lock);
+	vdpa_nic->vring[idx].desc = desc_area;
+	vdpa_nic->vring[idx].avail = driver_area;
+	vdpa_nic->vring[idx].used = device_area;
+	vdpa_nic->vring[idx].vring_state |= EF100_VRING_ADDRESS_CONFIGURED;
+	mutex_unlock(&vdpa_nic->lock);
+	return 0;
+}
+
+static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return;
+
+	if (!is_power_of_2(num)) {
+		dev_err(&vdev->dev, "%s: Index:%u size:%u not power of 2\n",
+			__func__, idx, num);
+		return;
+	}
+	if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
+		dev_err(&vdev->dev, "%s: Index:%u size:%u more than max:%u\n",
+			__func__, idx, num, EF100_VDPA_VQ_NUM_MAX_SIZE);
+		return;
+	}
+	mutex_lock(&vdpa_nic->lock);
+	vdpa_nic->vring[idx].size  = num;
+	vdpa_nic->vring[idx].vring_state |= EF100_VRING_SIZE_CONFIGURED;
+	mutex_unlock(&vdpa_nic->lock);
+}
+
+static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u32 idx_val;
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return;
+
+	if (!vdpa_nic->vring[idx].vring_created) {
+		dev_err(&vdev->dev, "%s: Invalid vring%u\n", __func__, idx);
+		return;
+	}
+
+	idx_val = idx;
+	_efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
+		    vdpa_nic->vring[idx].doorbell_offset);
+}
+
+static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
+				 struct vdpa_callback *cb)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return;
+
+	if (cb)
+		vdpa_nic->vring[idx].cb = *cb;
+}
+
+static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
+				    bool ready)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return;
+
+	mutex_lock(&vdpa_nic->lock);
+	if (ready) {
+		vdpa_nic->vring[idx].vring_state |=
+					EF100_VRING_READY_CONFIGURED;
+		if (vdpa_nic->vdpa_state == EF100_VDPA_STATE_STARTED &&
+		    can_create_vring(vdpa_nic, idx)) {
+			if (create_vring(vdpa_nic, idx))
+				/* Rollback ready configuration
+				 * So that the above layer driver
+				 * can make another attempt to set ready
+				 */
+				vdpa_nic->vring[idx].vring_state &=
+					~EF100_VRING_READY_CONFIGURED;
+		}
+	} else {
+		vdpa_nic->vring[idx].vring_state &=
+					~EF100_VRING_READY_CONFIGURED;
+		if (vdpa_nic->vring[idx].vring_created)
+			delete_vring(vdpa_nic, idx);
+	}
+	mutex_unlock(&vdpa_nic->lock);
+}
+
+static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	bool ready;
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return false;
+
+	mutex_lock(&vdpa_nic->lock);
+	ready = vdpa_nic->vring[idx].vring_state & EF100_VRING_READY_CONFIGURED;
+	mutex_unlock(&vdpa_nic->lock);
+	return ready;
+}
+
+static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
+				   const struct vdpa_vq_state *state)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return -EINVAL;
+
+	mutex_lock(&vdpa_nic->lock);
+	vdpa_nic->vring[idx].last_avail_idx = state->split.avail_index;
+	mutex_unlock(&vdpa_nic->lock);
+	return 0;
+}
+
+static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
+				   u16 idx, struct vdpa_vq_state *state)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return -EINVAL;
+
+	mutex_lock(&vdpa_nic->lock);
+	state->split.avail_index = (u16)vdpa_nic->vring[idx].last_avail_idx;
+	mutex_unlock(&vdpa_nic->lock);
+
+	return 0;
+}
+
+static struct vdpa_notification_area
+		ef100_vdpa_get_vq_notification(struct vdpa_device *vdev,
+					       u16 idx)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	struct vdpa_notification_area notify_area = {0, 0};
+	struct efx_vring_ctx *vring_ctx;
+	struct efx_nic *efx;
+	u32 offset;
+	int rc;
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		goto end;
+
+	mutex_lock(&vdpa_nic->lock);
+	vring_ctx = vdpa_nic->vring[idx].vring_ctx;
+	if (!vring_ctx) {
+		rc = create_vring_ctx(vdpa_nic, idx);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: vring ctx failed index:%u, err:%d\n",
+				__func__, idx, rc);
+			goto err_create_vring_ctx;
+		}
+		vring_ctx = vdpa_nic->vring[idx].vring_ctx;
+	}
+	if (!vdpa_nic->vring[idx].doorbell_offset_valid) {
+		rc = efx_vdpa_get_doorbell_offset(vring_ctx, &offset);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: get_doorbell failed idx:%u, err:%d\n",
+				__func__, idx, rc);
+			goto err_get_doorbell_off;
+		}
+		vdpa_nic->vring[idx].doorbell_offset = offset;
+		vdpa_nic->vring[idx].doorbell_offset_valid = true;
+	}
+
+	efx = vdpa_nic->efx;
+	notify_area.addr = (uintptr_t)(efx->membase_phys +
+				vdpa_nic->vring[idx].doorbell_offset);
+	/* VDPA doorbells are at a stride of VI/2
+	 * One VI stride is shared by both rx & tx doorbells
+	 */
+	notify_area.size = efx->vi_stride / 2;
+
+	mutex_unlock(&vdpa_nic->lock);
+	return notify_area;
+
+err_get_doorbell_off:
+	delete_vring_ctx(vdpa_nic, idx);
+err_create_vring_ctx:
+	mutex_unlock(&vdpa_nic->lock);
+end:
+	return notify_area;
+}
+
+static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u32 irq;
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return -EINVAL;
+
+	mutex_lock(&vdpa_nic->lock);
+	irq = vdpa_nic->vring[idx].irq;
+	mutex_unlock(&vdpa_nic->lock);
+
+	return irq;
+}
+
 static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
 {
 	return EF100_VDPA_VQ_ALIGN;
@@ -98,6 +526,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
 
 	if (cb)
 		vdpa_nic->cfg_cb = *cb;
+	else
+		memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
 }
 
 static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
@@ -155,11 +585,28 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int i;
 
-	mutex_destroy(&vdpa_nic->lock);
+	if (vdpa_nic) {
+		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
+			reset_vring(vdpa_nic, i);
+		ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
+		mutex_destroy(&vdpa_nic->lock);
+		vdpa_nic->efx->vdpa_nic = NULL;
+	}
 }
 
 const struct vdpa_config_ops ef100_vdpa_config_ops = {
+	.set_vq_address	     = ef100_vdpa_set_vq_address,
+	.set_vq_num	     = ef100_vdpa_set_vq_num,
+	.kick_vq	     = ef100_vdpa_kick_vq,
+	.set_vq_cb	     = ef100_vdpa_set_vq_cb,
+	.set_vq_ready	     = ef100_vdpa_set_vq_ready,
+	.get_vq_ready	     = ef100_vdpa_get_vq_ready,
+	.set_vq_state	     = ef100_vdpa_set_vq_state,
+	.get_vq_state	     = ef100_vdpa_get_vq_state,
+	.get_vq_notification = ef100_vdpa_get_vq_notification,
+	.get_vq_irq          = ef100_get_vq_irq,
 	.get_vq_align	     = ef100_vdpa_get_vq_align,
 	.get_device_features = ef100_vdpa_get_device_features,
 	.set_driver_features = ef100_vdpa_set_driver_features,
-- 
2.30.1

