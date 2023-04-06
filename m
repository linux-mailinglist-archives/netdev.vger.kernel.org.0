Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C986D9011
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbjDFHFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbjDFHEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:04:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7752AAD26;
        Thu,  6 Apr 2023 00:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Poh/1qunGKQz7pJi/RkWi4JSSAxYWWWjLI2OYtTiEn6cGWqq5bUCK71EJqgyVvvd1XyPZ7gOLpj3nAkaMn2LKgwdi2pK0Na02e0p42RLPKJ6zCbx/iqKqhIw6uSVigeI04nld9ma+bu25Wa2ju77a+XLMcRngj4gMQsXgZXCtnWPqkpOwR3sBc36ZSUxWg+QwjGQKHkmOzuqlIdJle+ag+ZbNEnObqrpqq2+7Fd5lNLsmkJCnTpjPORrSCu9Jm34O7ap7YqltFNZKNIwOdcyH/WMR/HUjCg9pjfnmEOghmy0w4Vf/gfcgTYxbi9x7UWsnYINKeo0CKBmBxWhkw6dMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+UEyvlAXUI+Z6c+1nBIk6WgBsOdzcAvJ1TZjeri670=;
 b=HOA55/tXwQOymDkp89sWr4mGvk9zDyqZqed0SV+JGt5VYpw2u+NXPTOVkX5tQPEbQ/y6Zoa7LOlTMM6DH4GxtntVHWvDhu6hPU5yqwgXPDtc6PjUIS0TSRs0ROR/KNruVD9PsQrEFeKi4UOJJiI+RaF+Gez9gFnNrxzEjXQbgC5wAfQiCQFwR37tGt7r24Kt2AaDRbrR1tQOKeZR2gbSMDyDOMb11wscA7EoSveGz7jbdFT/JlsP88Ng2LZz5cvIXZVLS09DvvnS/gjGTrRQ9mjvbHR9v5HOkromrrvX8/l1sw4XaC01uuQCMphzBwmXXcLNfPMP4PQhkqAviITsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+UEyvlAXUI+Z6c+1nBIk6WgBsOdzcAvJ1TZjeri670=;
 b=LGT2uGtGBaDHei77MsPO9VOHZ04v/lYAFr1SoKb3VgpWcakc00i9jNbp+wl3xYlL6RpxwjEW/C78AVqs/0H98giHNgZ7WYGP+2i4Bd03qkUgBRIZakgmPclJ9nfvre0HvSMCMN55rs4CtaB0Zby7T+2d+rLcLK55ZPHSvQ6778U=
Received: from MW4PR04CA0045.namprd04.prod.outlook.com (2603:10b6:303:6a::20)
 by SJ2PR12MB8718.namprd12.prod.outlook.com (2603:10b6:a03:540::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:02:44 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::9d) by MW4PR04CA0045.outlook.office365.com
 (2603:10b6:303:6a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 07:02:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 07:02:44 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:02:41 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:02:36 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:02:32 -0500
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
Subject: [PATCH net-next v3 12/14] sfc: unmap VF's MCDI buffer when switching to vDPA mode
Date:   Thu, 6 Apr 2023 12:26:57 +0530
Message-ID: <20230406065706.59664-13-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|SJ2PR12MB8718:EE_
X-MS-Office365-Filtering-Correlation-Id: a96f15f1-c3ea-45db-3ead-08db366cebf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGa+CK84HkFiHjJjwk/mTxc6Yfee3ymPUIWgv9qoHuc4MHO2YML4G81Z5n821emy/2sSVaXjZtgw/daZbAy3LBhf+4cBGSlWVAXpMtQu4yFKUcx7h474OpqvWymD0JDPpglhxTv9h7EQeg/IXyTUMZLZIVK0aaMQ/AP8U9g+425YKePXG4hjzFLx0/1z6yi2KdM2x94WH821e0GmcBhNvHLxH8Ee9JWRUy0lUD7eGcFSbBeeOeujm1u+AjsjCO3lRoWy79PmTmrzzDGWqGCtSH35PXolBd9U6nnoM567YabyFfRxs/Xl+JiQY26/jBCGfPIwfqHLA14X17oP+hjX5liP9taS6d+pETeKq3VvjgYxZ4AZU6YQYt1lBTlb8SPMOOFNW4XhF1woXy5WK80xP4iwJx6la47FkfG+MSxv4UtOABrncIHU2hbVIYR+8rzR/N+kQ9DPZmbRQK/tFPH0LF5ukXKeyYjj+TlYEy8xC6p3iQaZMRv9ceJy2Dl+hw5hZ1Q4lLc2PqjEeOCdVY7wrt1zf/XhrLKOqnrwWE8NaFxCjv9KiO9n+GjWH1cwXRfJhl2opI2mEVR5YWjVFhSDrX5iU74aDk9TjAJTupXxvcHIateJRMF1wGWqS5iAEBhRBCapjgQUS5b3C1Zx+szobtPkF+HoEcrWd2YktFVXYSWacg9KnYu1auhxeSuToui+rJFlBqZChN987JC07CK/yStX0GFosOKkz3MeWaezE+rMX7Nk4Mx/zYv3i1RhnLak
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199021)(36840700001)(40470700004)(46966006)(921005)(81166007)(356005)(82740400003)(1076003)(47076005)(26005)(2616005)(83380400001)(426003)(336012)(7416002)(36860700001)(2906002)(36756003)(6666004)(5660300002)(44832011)(40460700003)(86362001)(316002)(110136005)(54906003)(186003)(8936002)(40480700001)(41300700001)(478600001)(8676002)(70206006)(82310400005)(70586007)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:02:44.4515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a96f15f1-c3ea-45db-3ead-08db366cebf4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8718
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid clash of IOVA range of VF's MCDI DMA buffer with the guest
buffer IOVAs, unmap the MCDI buffer when switching to vDPA mode
and use PF's IOMMU domain for running VF's MCDI commands.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c      |  1 -
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 25 ++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  3 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 35 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h           |  3 ++
 drivers/net/ethernet/sfc/net_driver.h     | 12 ++++++++
 6 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 7fffd184afc1..6f1d11f3a9c1 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -34,7 +34,6 @@
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
-#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 24c384832177..15c00e898f64 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -228,10 +228,19 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
 static void ef100_vdpa_delete(struct efx_nic *efx)
 {
 	struct vdpa_device *vdpa_dev;
+	int rc;
 
 	if (efx->vdpa_nic) {
 		vdpa_dev = &efx->vdpa_nic->vdpa_dev;
 		ef100_vdpa_reset(vdpa_dev);
+		if (efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
+			rc = ef100_vdpa_map_mcdi_buffer(efx);
+			if (rc) {
+				pci_err(efx->pci_dev,
+					"map_mcdi_buffer failed, err: %d\n",
+					rc);
+			}
+		}
 
 		/* replace with _vdpa_unregister_device later */
 		put_device(&vdpa_dev->dev);
@@ -281,6 +290,21 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
 	return 0;
 }
 
+static void unmap_mcdi_buffer(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_iface *mcdi;
+
+	mcdi = efx_mcdi(efx);
+	spin_lock_bh(&mcdi->iface_lock);
+	/* Save current MCDI mode to be restored later */
+	efx->vdpa_nic->mcdi_mode = mcdi->mode;
+	efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
+	mcdi->mode = MCDI_MODE_FAIL;
+	spin_unlock_bh(&mcdi->iface_lock);
+	efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+}
+
 static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 						const char *dev_name,
 						enum ef100_vdpa_class dev_type,
@@ -347,6 +371,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
 		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
 
+	unmap_mcdi_buffer(efx);
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index cf86e1dde2a2..087fcd1c6e69 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -148,6 +148,7 @@ struct ef100_vdpa_filter {
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
+ * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
  * @net_config: virtio_net_config data
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
@@ -167,6 +168,7 @@ struct ef100_vdpa_nic {
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
+	enum efx_mcdi_mode mcdi_mode;
 	struct virtio_net_config net_config;
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
@@ -186,6 +188,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
+int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index b3b3ae42541c..59d433ec42d3 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -711,12 +711,47 @@ static int ef100_vdpa_suspend(struct vdpa_device *vdev)
 	mutex_unlock(&vdpa_nic->lock);
 	return rc;
 }
+
+int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_iface *mcdi;
+	int rc;
+
+	/* Update VF's MCDI buffer when switching out of vdpa mode */
+	rc = efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf,
+				  MCDI_BUF_LEN, GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	mcdi = efx_mcdi(efx);
+	spin_lock_bh(&mcdi->iface_lock);
+	mcdi->mode = efx->vdpa_nic->mcdi_mode;
+	efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	return 0;
+}
+
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int rc;
 	int i;
 
 	if (vdpa_nic) {
+		if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
+			/* This will only be called via call to put_device()
+			 * on vdpa device creation failure
+			 */
+			rc = ef100_vdpa_map_mcdi_buffer(vdpa_nic->efx);
+			if (rc) {
+				dev_err(&vdev->dev,
+					"map_mcdi_buffer failed, err: %d\n",
+					rc);
+			}
+		}
+
 		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
 			reset_vring(vdpa_nic, i);
 			if (vdpa_nic->vring[i].vring_ctx)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 2badf08aa247..cfa78fc04354 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -8,6 +8,9 @@
 
 #ifndef EFX_MCDI_H
 #define EFX_MCDI_H
+#include "mcdi_pcol.h"
+
+#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 /**
  * enum efx_mcdi_state - MCDI request handling state
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 948c7a06403a..9cdfeb6ad05a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -848,6 +848,16 @@ enum efx_xdp_tx_queues_mode {
 
 struct efx_mae;
 
+/**
+ * enum efx_buf_alloc_mode - buffer allocation mode
+ * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
+ * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
+ */
+enum efx_buf_alloc_mode {
+	EFX_BUF_MODE_EF100,
+	EFX_BUF_MODE_VDPA
+};
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -877,6 +887,7 @@ struct efx_mae;
  * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
  * @irq_rx_moderation_us: IRQ moderation time for RX event queues
  * @msg_enable: Log message enable flags
+ * @mcdi_buf_mode: mcdi buffer allocation mode
  * @state: Device state number (%STATE_*). Serialised by the rtnl_lock.
  * @reset_pending: Bitmask for pending resets
  * @tx_queue: TX DMA queues
@@ -1045,6 +1056,7 @@ struct efx_nic {
 	u32 msg_enable;
 
 	enum nic_state state;
+	enum efx_buf_alloc_mode mcdi_buf_mode;
 	unsigned long reset_pending;
 
 	struct efx_channel *channel[EFX_MAX_CHANNELS];
-- 
2.30.1

