Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E746D9008
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjDFHDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbjDFHCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:02:12 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6D2B444;
        Thu,  6 Apr 2023 00:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Duimnr+GFgvRF5ehnjLRw941iycVLvIaXwmMEdTa0B1bM3JBoxmLeB6fGRXNkzpfVfwhg1MkpWcxdNQTMu3jJcUn+cUqSH32+yFibUcVcJJniF094jZpWv8qj8TRe0LAbSgKyzPLHDHGHpwnhsW1zK7H4GUwoWeiHnoNFPe7JmC3X/kUdy3HYr/tXodBeWDiaYHth9BcY2gKyQ9C8zR9pP4yFyL2MGi9FU6SQpJIupM97LMIGLTVFBkxTOwFlL8vWQ8hxKBHH3t1rRY/QTd3HTFbgALdCqhDwYyenRqnW3AqA+WBKHBqq/wwGJ1Nt1XHE8w5DKjVbcd6eLT1gYsz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHQA2l66Rk4ZLFDa3fyOn38U0q9TGs5SQfIkqWLvE40=;
 b=eMvFPNXHgEMN2hdzIcO4H5o+s5JLt9dcCDoP2bUnZaZTwnQBYnTS6AMDYo08QTzT3sGJRt3hsX4yjO8mGmSYTS9rgJlB+4kLk65mfgDcbSOZbG0AlUa5EFAEwS3Dv+rA2vhJMRDgAzREJoFgrpgMMC4jE9JT5QiYy8+IDbpMxOJKi2tOkdt2KZfgQqDZSPBBUYbgZDLf2silQ9i4OvVXa9ro2EXThoCgipZ9kGyDvGKusVjC2pEA81SlZ+B1L9fWGFYgiIfl1JPXTsDGRTCfg+TFMIytaaoxtQiHjFR/a0XTV9aFA9uYI2WASA5mN4PNQg/oZtMLjq5zc3OYptGj8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHQA2l66Rk4ZLFDa3fyOn38U0q9TGs5SQfIkqWLvE40=;
 b=0phYTNJmgRYbwBwxb+4/x6SVwfhjZMBJFFMqyAOi3Oo3zPsEbGgfybXxiOh3oCY/PROzDrbSg5N+wJ2iGZgG/zUru4749G9KfBCHSnCBg/KpOQgcFpg1nBC5rnc8DcLD3qy5rT4Ip2JLXBq2YyYB422Op1tn+un5+hAwqc+/BHo=
Received: from MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::26)
 by MW4PR12MB5644.namprd12.prod.outlook.com (2603:10b6:303:189::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 07:01:32 +0000
Received: from CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::4a) by MW4P221CA0021.outlook.office365.com
 (2603:10b6:303:8b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 07:01:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT091.mail.protection.outlook.com (10.13.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 07:01:32 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:01:31 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:01:30 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:01:26 -0500
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
Subject: [PATCH net-next v3 08/14] sfc: implement vdpa vring config operations
Date:   Thu, 6 Apr 2023 12:26:53 +0530
Message-ID: <20230406065706.59664-9-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT091:EE_|MW4PR12MB5644:EE_
X-MS-Office365-Filtering-Correlation-Id: ae12cf64-86a8-4fb9-303a-08db366cc0e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0hQi7Nbo+uGNukqfu5UeXtyHUZ9w+1X2urQtLWOfKIbfbT+cnwsaxBktffdnCTqbjHNTXF+T47PJjIVi1UAGKnzWJNd5Rs50QNP5u16bu8yues/+44rZ1Dp+hxJXnxYBYlu9nM6Z/yFJUsO6J0oB1ZYdHcyOV6ioAJ4KxtbPcflsPBS3X+j6CsHUq6LNGw0AcsunncS4Cr2c9fOlx2CLo8Ssu7/1lPAo1JUcvJeO+tHFC2BCrhPbAaYdN7M90yiIsRzAEz1ljl63b1bEiK33VgwhGUe3Bfn31cUcSm1COeSx4c467u35BPm46fNs4bQGYEjZxGjNIqR3moOQ0eE0cOpfOXDBOjg5XycGLNRbKQ3uJXwfcNiOmjVIvx2sqDHGOBQNCQWWPj2CnY50zKjFigZvjr3CayT1mwCK5Vuopk9x8uMiX/wriSI0/53dSjycbvkR6I6bUTQl/wNxVuLlg3oY4xH4rvMNsQO5fPCYxsFtjp5bukX2PSjntmM+ZUTXY4pzRNMl5KEpsI40uUPtD5MlTWoU4BTk6FNw2vSYNl8Oo7pV+j9uz5FbbFnZz/JbP+RAV5i/bVVAEH3Ix4Zz0gH3u6q4szFKq8V0PwvCBx+OBnLdKJeRxOlCWdr+8t05F7ycD5iy0GvAYi/Y3xboc+Z1zObt29amhJMVXp734YlZSo4TQJvYmJC+eKXUZ7veJW1DBTZ9ASDb92G4BEF6dX82P04TVsgDLK4iNuQBNw4BITweMnD3LBoSraMn7r7
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(4326008)(70206006)(70586007)(478600001)(36860700001)(54906003)(316002)(110136005)(8676002)(8936002)(44832011)(7416002)(356005)(921005)(5660300002)(41300700001)(82740400003)(81166007)(336012)(186003)(47076005)(83380400001)(426003)(2616005)(6666004)(1076003)(26005)(36756003)(86362001)(82310400005)(30864003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:01:32.1846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae12cf64-86a8-4fb9-303a-08db366cc0e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5644
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  56 ++++-
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 ++++++++++++++++++++++
 3 files changed, 375 insertions(+), 2 deletions(-)

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
index dcf4a8156415..fbdd108c0e7f 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -32,6 +32,21 @@
 /* Alignment requirement of the Virtqueue */
 #define EF100_VDPA_VQ_ALIGN 4096
 
+/* Vring configuration definitions */
+#define EF100_VRING_ADDRESS_CONFIGURED 0x1
+#define EF100_VRING_SIZE_CONFIGURED 0x2
+#define EF100_VRING_READY_CONFIGURED 0x4
+#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
+				EF100_VRING_SIZE_CONFIGURED | \
+				EF100_VRING_READY_CONFIGURED)
+#define EF100_VRING_CREATED 0x8
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
@@ -57,11 +72,46 @@ enum ef100_vdpa_vq_type {
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
  * @vdpa_dev: vdpa_device object which registers on the vDPA bus.
- * @vdpa_state: NIC state machine governed by ef100_vdpa_nic_state
+ * @vdpa_state: ensures correct device status transitions via set_status cb
  * @efx: pointer to the VF's efx_nic object
  * @lock: Managing access to vdpa config operations
  * @pf_index: PF index of the vDPA VF
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
index a2364ef9f492..b390d5eee301 100644
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
+	/* SN1022 supports split vq which requires vq size to be power of 2 */
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
+		return notify_area;
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

