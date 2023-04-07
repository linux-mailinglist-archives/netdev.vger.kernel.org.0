Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F2F6DA9DB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbjDGIN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbjDGIMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:12:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC3CBB88;
        Fri,  7 Apr 2023 01:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/Irwgvu/IAiHCQEDBtqQgxYAnsS5jgr4WeoQN/IqsLVwuPVWNUoubHJLCRvHfehe8sAD7hDHtOJG+w5WlcopWYgM281XxbrrJeOPuEKRTtZnq70hmBmMEtii9Sc0Wm23ciCwZJfBy1sbSTzwSw+SjvVtnOeauHOAsx1kq3SLIhdHguz0FJj/ND0yP23XAfbyMSJ0XxCpuqRWGRYQMBLmRU675r1Gssa96s8Goy4f6KTAkpgWILt5qWNtTu+2KwomeaWy4/V+AQLfx9ml3p65hTCSOnc4b8Cjr6U1aHbM/lRHXWuJAmVreo9k9Eyl5LAN+SEPIf8Tje4GwV187bjVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtXFSlvTAnsHmxkGwZXTi/oy7S0knYTtOqE3PP0M9Z0=;
 b=Cm+qs0sYTjVjLIS1sqylTh7zQjWcGScz2duKzPsO3mdpoVILXi5FlDENumRPYXm6llP0tJS2N+86uqda2lp0XNgZeVw4rV+WReCGOOmwzds7jeofeUfz4UP3GK496L0EnL9mOpuABcupkoPtmOqowrJ2cWdKVxdCX0N8mKjAYmRwACPuyS2CHl60KeJMIQU9IlHb+aZwwwkQ/qnbWUongB0vOxtrGlZYWMspzlj8egHPPZDJOQxqxX/hRcJSfQS4u+/Xybn5GtpBaYQSlYjMPlSlXIFfJsZLZuqCYmcc7DY2XSjI8jBqztDuSqIh4uwEb6YZzLHdsQFrPmlKq7KSwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtXFSlvTAnsHmxkGwZXTi/oy7S0knYTtOqE3PP0M9Z0=;
 b=g3FLbQmbIDj1r2k2m2NLn/ZmHC1dhUZb/qsx2QgiJi+TuXJqhcqwGAlYdE6u5NN7WExG6yFkL1BBWsD3ci4wT0PoRwxNiksbHBkWfHgMSt+Fpa1990SPiIeasjT2F5JZo0YnrOpbTy+L+OvTo0qhHotwoXvabrLEJsd15aHkMyc=
Received: from MW4PR03CA0095.namprd03.prod.outlook.com (2603:10b6:303:b7::10)
 by SA1PR12MB7040.namprd12.prod.outlook.com (2603:10b6:806:24f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 08:11:51 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::4e) by MW4PR03CA0095.outlook.office365.com
 (2603:10b6:303:b7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Fri, 7 Apr 2023 08:11:51 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:50 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 01:11:50 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:46 -0500
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
Subject: [PATCH net-next v4 08/14] sfc: implement vdpa vring config operations
Date:   Fri, 7 Apr 2023 13:40:09 +0530
Message-ID: <20230407081021.30952-9-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|SA1PR12MB7040:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a713829-6697-456a-35c3-08db373fbe2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9QdxKmDi6sD87+vzhXA30EaGNRfVIFCxRiX9QEWu4YU++Mt5CW36sYxPTNnlU7pCTv2qqx7/AmOFTKZde5PR5ANoh8q6pD3N6BoYrGP3EubxjE9b+RqPbb6evBfK6Ka3+P/tm5s1VffW20plRaN0H9rAsfseyu6HudbdWXHoi4K5ltBhtWMNekTm2MF4dwDsShDRe7CdjvvLp7G1laIwKkFA4HAkEbLur7VPbyvVmUSVKdbwe1aD42kqOnjjMX1gN8qOmjvoRvbd830EgdYSTU++wbwRdtc/BTxImbbzAiFt6nM6Kq9NqDh/05PuvKSs3pH8MWVNLGwOyaD5nFI3s3dOIKpVv5gvecsdMfbPoc8gef6XlsuD2ueIkt9T3c0v2o+xf0t5AAuVYur9KUHYurJh8TOLg4IdV3Ngl7Ptc5hu/u9pAnJW6uJb+faL81kQ2JR1bK4zLeAVEXaUA2b0HWL/2w/Wwu+mualV14V1UrdGQIjyAXjo4lj4uAkCGq67UsUFDVyW+1wPE6a+7RFyBneTIZVYlIzDsh7SUbDROVI7daTaQ8z0uWCwYMspoeARvIykfrxmIBPRYO0eiDO/dISvjM61i59TuXjkVBcyRhwVJUbulh0JKzNL3OSxxuiU1A3TdUrEHm/QwYTxDG0Uciw26k7oTptjq+KIqPNg2FdACr8QtKh5JIodJV5tL0FbuQWuWFCF6dI7rPaTeCtdawFInq7oPuDE2fU2ESNUsm4TvkpEeln5wF7yVzJR7E7e
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(40480700001)(82310400005)(186003)(5660300002)(8936002)(36860700001)(86362001)(30864003)(7416002)(426003)(2616005)(44832011)(478600001)(26005)(110136005)(1076003)(2906002)(4326008)(70206006)(70586007)(8676002)(41300700001)(54906003)(336012)(316002)(36756003)(921005)(47076005)(83380400001)(356005)(40460700003)(6666004)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:51.4596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a713829-6697-456a-35c3-08db373fbe2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7040
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
index 1ba34e4e0a87..fb4d15caa320 100644
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

