Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512026ADDAA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjCGLkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCGLkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:40:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C073AC7;
        Tue,  7 Mar 2023 03:38:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkVtszuW6edHD+QcU8Qqn0TBvH6J5kSTucKJTh2IUa0ry+ySXuZ/CRDW5covbE/xweIIv9KJU5YSqGgt19lcdwqKt6r0TI/qUYqPWIkEmaHlGFiLka3qpTgV+eqSiupnqGRDATnPzdTdKdMVP9qbfFe6ieUrShdBQuiVi942jToRKAnAev+AMFtRK+PzrOJ75x0jh5wVBTKv0wcd/KGx/XjNWSJFwhKm46n/03A9Wxp+P9sEuQySING0EFHNztHT3gSqVX55d+cBCl4QaPX1ZGDeudRz+FJpRbHFKaHk/Td+BKLmj98Fal4fa/Wb0Vh1woYdbOxV6GTDdyVLF8/ePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoitq6WKwgOBW9WS79HC5Y/PJE0+2Oryz1Q0WrhhbR0=;
 b=SOFlbBWcM0me66GciuC7WCEIqCSb6gdGD05zrq0gCMlzsoHFwyJb8CH3VbIXoAXSHBB4eMjBxJ49qJetmwGvyru/3G1ITovkplM4C+HRtZRVOEEVNa3BAWIJES+GKxpRjuNF0eqHlRiJSQFOsfKHA/U7nNDpNtdOZLMpn+O783ICBXRNMrBY08SBvPjdnsbCw7V10uXmIE1DrT/rtY/X63asPHZf7+XjBIfG2WbDcmd1q6H50AFsjplIx7YhGVW/8Xb9z9lFOinku2DtaCtmxb2h1tSvn/5AXgWOtM226tCtZHLs29MCuc78Dmv36gxcT3cypNzNuYwKTAyAnx/slg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoitq6WKwgOBW9WS79HC5Y/PJE0+2Oryz1Q0WrhhbR0=;
 b=YbDRLQe/UbubA4pK/1RT/3sOG0qAkLogiRnKOgoDpv3gcbGC+CybViTCBaD5UKMFW80NZ6jjLJI0U/RRG/hzSXZhV6qAB12AEGfSUKrwXBK6mEKNJylujeMVZ141jmVVt+CNQaa50/ytmhGUZ1zYtt5LTaxD50m+LzjHoqNSOZo=
Received: from BN9PR03CA0907.namprd03.prod.outlook.com (2603:10b6:408:107::12)
 by MW4PR12MB7142.namprd12.prod.outlook.com (2603:10b6:303:220::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 7 Mar
 2023 11:37:47 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::4) by BN9PR03CA0907.outlook.office365.com
 (2603:10b6:408:107::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:37:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.19 via Frontend Transport; Tue, 7 Mar 2023 11:37:47 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:44 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:37:40 -0600
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
Subject: [PATCH net-next v2 08/14] sfc: implement vdpa vring config operations
Date:   Tue, 7 Mar 2023 17:06:10 +0530
Message-ID: <20230307113621.64153-9-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|MW4PR12MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b42e26-601a-4d05-0bc2-08db1f005fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnVGBw2KuRyC6YDY9LKJTy6sC4y6faEMEdZ5CLAeYm2D6+chNC2ZuxQE0eQL77QJe678pL0ICU+XfFvxLDIYgHVdZekrJI+nh0zco9IrUcW1AD3+9s1nWHx3url/xg8O6uiAhLca8lz0Xcw/zEtLnWxA1yhGRJZEdL11JtwSAR1jleEYGEZhAScjpuI+DpurLAPiP2VeHpcNs4dSRGzEY90F4zDdQUE9j6LH+yCKBcnhcPVIKOotuekco9BhKrMeDd7zob1qsSMnFMd+2bi6hCnKnG1MHnoPJ5RWtQB7yxOyXtOXZfVV2uUgQv3ILsaq9TV9v7q/swu35yLZkAbKzBI2w8UpqTFlVq4qi8qmcUw7+DF9RnTKX+bUAUaaYb4vQB2km39QrwaVNwHtnvB45pGah11AfNUbSvJ6+HT2ZqEad1MtgJoyO3JSa+KV3qjkz0DZ5w2p1185qCPNvrUvj5ldm+IiAj0eVn2yk7XwSEhSoMdRb+BASgBoadmmhFwb5J59Cua7y3dl8YKb/MCQHJcDExfH41LkwTAnGp7/lH0Y0FcvX5q7sTxB37cE0HEwWVUyYpGwWxc+5ksdsPB6M/jdlg4G2BpcOae0GSmkeWSMRUR0904R1PbsFYQjI07nRmyxVXX6ivToqKV/TvuoNqAN8Rso9ZXMc7CKDiTno1quTNTvav9TYktsIgYVMnMQdc7y6Lek0HodRVKxCzcfX2dWJWMMQrPox5vYFSM9RQiCmpZZKS1EUAuYKfVpuwRY
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(54906003)(110136005)(36756003)(82310400005)(40480700001)(83380400001)(316002)(86362001)(336012)(186003)(40460700003)(7416002)(30864003)(5660300002)(44832011)(478600001)(41300700001)(4326008)(8936002)(8676002)(70586007)(70206006)(2906002)(82740400003)(1076003)(2616005)(26005)(47076005)(426003)(6666004)(36860700001)(81166007)(356005)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:37:47.2248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b42e26-601a-4d05-0bc2-08db1f005fe8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 ++++++++++++++++++++++
 3 files changed, 374 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 4c5a98c9d6c3..c66e5aef69ea 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -14,6 +14,7 @@
 #include "ef100_vdpa.h"
 #include "mcdi_vdpa.h"
 #include "mcdi_filters.h"
+#include "mcdi_functions.h"
 #include "ef100_netdev.h"
 
 static struct virtio_device_id ef100_vdpa_id_table[] = {
@@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
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
 		/* replace with _vdpa_unregister_device later */
 		put_device(&efx->vdpa_nic->vdpa_dev.dev);
 	}
+	efx_mcdi_free_vis(efx);
 }
 
 void ef100_vdpa_fini(struct efx_probe_data *probe_data)
@@ -104,9 +124,19 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 	struct ef100_vdpa_nic *vdpa_nic;
+	unsigned int allocated_vis;
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
@@ -117,7 +147,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 			"vDPA device allocation failed for vf: %u\n",
 			nic_data->vf_index);
 		nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
-		return ERR_PTR(-ENOMEM);
+		rc = -ENOMEM;
+		goto err_alloc_vis_free;
 	}
 
 	mutex_init(&vdpa_nic->lock);
@@ -125,11 +156,21 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
 	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
 	vdpa_nic->efx = efx;
+	vdpa_nic->max_queue_pairs = allocated_vis - 1;
 	vdpa_nic->pf_index = nic_data->pf_index;
 	vdpa_nic->vf_index = nic_data->vf_index;
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
 	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
 
+	for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
+		rc = ef100_vdpa_init_vring(vdpa_nic, i);
+		if (rc) {
+			pci_err(efx->pci_dev,
+				"vring init idx: %u failed, rc: %d\n", i, rc);
+			goto err_put_device;
+		}
+	}
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
@@ -146,6 +187,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 err_put_device:
 	/* put_device invokes ef100_vdpa_free */
 	put_device(&vdpa_nic->vdpa_dev.dev);
+
+err_alloc_vis_free:
+	efx_mcdi_free_vis(efx);
 	return ERR_PTR(rc);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index dcf4a8156415..348ca8a7404b 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -32,6 +32,21 @@
 /* Alignment requirement of the Virtqueue */
 #define EF100_VDPA_VQ_ALIGN 4096
 
+/* Vring configuration definitions */
+#define EF100_VRING_ADDRESS_CONFIGURED 0x1
+#define EF100_VRING_SIZE_CONFIGURED 0x10
+#define EF100_VRING_READY_CONFIGURED 0x100
+#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
+				EF100_VRING_SIZE_CONFIGURED | \
+				EF100_VRING_READY_CONFIGURED)
+#define EF100_VRING_CREATED 0x1000
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
@@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
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
@@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
  * @net_config: virtio_net_config data
+ * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
  * @cfg_cb: callback for config change
@@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
 	u64 features;
 	u32 max_queue_pairs;
 	struct virtio_net_config net_config;
+	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
 	bool mac_configured;
 	struct vdpa_callback cfg_cb;
@@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
+void ef100_vdpa_irq_vectors_free(void *data);
+int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index a2364ef9f492..0051c4c0e47c 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -9,13 +9,270 @@
 
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
 
+void ef100_vdpa_irq_vectors_free(void *data)
+{
+	pci_free_irq_vectors(data);
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
+static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
+	vdpa_nic->vring[idx].vring_state = 0;
+	vdpa_nic->vring[idx].last_avail_idx = 0;
+	vdpa_nic->vring[idx].last_used_idx = 0;
+}
+
+int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	u32 offset;
+	int rc;
+
+	vdpa_nic->vring[idx].irq = -EINVAL;
+	rc = create_vring_ctx(vdpa_nic, idx);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: create_vring_ctx failed, idx:%u, err:%d\n",
+			__func__, idx, rc);
+		return rc;
+	}
+
+	rc = efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
+					  &offset);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: get_doorbell failed idx:%u, err:%d\n",
+			__func__, idx, rc);
+		goto err_get_doorbell_offset;
+	}
+	vdpa_nic->vring[idx].doorbell_offset = offset;
+	vdpa_nic->vring[idx].doorbell_offset_valid = true;
+
+	return 0;
+
+err_get_doorbell_offset:
+	delete_vring_ctx(vdpa_nic, idx);
+	return rc;
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
+	if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
+		return;
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
+	} else {
+		vdpa_nic->vring[idx].vring_state &=
+					~EF100_VRING_READY_CONFIGURED;
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
+	vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
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
+	state->split.avail_index = (u16)vdpa_nic->vring[idx].last_used_idx;
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
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		goto end;
+
+	mutex_lock(&vdpa_nic->lock);
+	notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
+				vdpa_nic->vring[idx].doorbell_offset);
+	/* VDPA doorbells are at a stride of VI/2
+	 * One VI stride is shared by both rx & tx doorbells
+	 */
+	notify_area.size = vdpa_nic->efx->vi_stride / 2;
+	mutex_unlock(&vdpa_nic->lock);
+
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
@@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
 
 	if (cb)
 		vdpa_nic->cfg_cb = *cb;
+	else
+		memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
 }
 
 static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
@@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int i;
 
 	if (vdpa_nic) {
+		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
+			reset_vring(vdpa_nic, i);
+			if (vdpa_nic->vring[i].vring_ctx)
+				delete_vring_ctx(vdpa_nic, i);
+		}
 		mutex_destroy(&vdpa_nic->lock);
 		vdpa_nic->efx->vdpa_nic = NULL;
 	}
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

