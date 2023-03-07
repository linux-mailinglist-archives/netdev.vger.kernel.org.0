Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A486ADDB5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjCGLl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCGLkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:40:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89AB7C94C;
        Tue,  7 Mar 2023 03:38:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1k1OFMLqBMTmBJpbwpscbzDOQjmsJPD593FzdRx/vvZRNOFB5jQz/whd4EgscB7mc7Odo9r9Rtd9q6dowV4NxQ9k5ezPkEZUEyeMBFve5/AqUymcDOGv9ZuIuJsypwRt9qLQ1xTY4gjJbM9QjM8UO7UHO/2c0bvRLqm9gMyUmPffHh91dJ1XRV/i+Y5inBqIGmcV4dAI9d4sHuKmpsT1W91T7jDfMpKkXnNcSEoylZ22jG6PyW2aghNsWdLyNENnqgPPQ+NY8jU0ophu08lFfje5tKk28UdfeujT8ibjPLibhmbPXy3fXBksHR1Gv64KrcGpL1h+qRTFilTO5EmJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIRfWTzSPupYUB9+vixLaaLRNyYlTsniXxo6YIV04fk=;
 b=YkegaL+F5I1nQFYSP0r8L2y/OaYGUoFTrcKaCbrV6JiMRNXJx93tvywmNijIVh8vGLzhAMNbLhjA4z2l817d7siyd6WktLoF7IFfTNFHGZnkE0oBOzHP+t9RPx8NNSm5//QJDC1EAgWluYmnMhE6OAnjFVOFbVycVT+gjrEk496jHaPDaKPlhGZKrTTYDL9vgDNUSR8FMfq35d+rKthu54lsQh+QTBqnW0e4nptIRsPnbowhz3zHiLsF1N09iz95Kc7GiPK1Z9uHs4wUhE0YUI/q3r8D22uZVpUg0D+wcw2UHr1jDI199pmfV9q6tlV2Im0pjTy0JsapDWBDE/fgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIRfWTzSPupYUB9+vixLaaLRNyYlTsniXxo6YIV04fk=;
 b=XZiaeKes2VNHv7NKVc2sSTp7MemoIxohihiWeS6y19oHOXo/kHXGd2qhjTK6tcQEosnku8kqWpr5KV+uuE7XKpA7Vz1Gdb3DkzPIEwh+CMB7rsB5jvHrq5qlK7PQrRmIUqrZQnYldBx2JJT7EUYkJFw5gQiVEAuY4jbzKk889/0=
Received: from DM6PR18CA0031.namprd18.prod.outlook.com (2603:10b6:5:15b::44)
 by DS0PR12MB8318.namprd12.prod.outlook.com (2603:10b6:8:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 11:38:26 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:15b:cafe::d6) by DM6PR18CA0031.outlook.office365.com
 (2603:10b6:5:15b::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:38:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 7 Mar 2023 11:38:26 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:38:19 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:38:15 -0600
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
Subject: [PATCH net-next v2 12/14] sfc: unmap VF's MCDI buffer when switching to vDPA mode
Date:   Tue, 7 Mar 2023 17:06:14 +0530
Message-ID: <20230307113621.64153-13-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|DS0PR12MB8318:EE_
X-MS-Office365-Filtering-Correlation-Id: 123b92a9-c2dd-4d56-c26c-08db1f00778c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UkC1PVpVRMLgDknrRkze2VVT87mRdKv/jOWbzx0vrIBZHa+TwKH+INQxMImCywCVBNXhs/rLbq1GztT//dzJ5zWLyHGa6ilJykA5Q4+Nrm7+4lIdsM7AekpdlMOYNfL5I5AXoswxFkpk6YR8YGKVHrfOWc7Kitn4iBJ2bKIlY2rEWDR4kgxXlRMTo9Eid2YhLaX+qbHSMtavcZBDIACbJZ0yT0oVlJpaiH1edf7tGEWvfrtgPUskrsOCxwneZkhHJFQ+eTVeKXKyDWsEFCn+8CAB8dUWpFXLqaVwiCoOJCP7O2+3DrtNB9TYRfzmEgrx3biBoejsrvf8K4Ex79jMtacbbxhDvvUM8VaXWOnY7MDmtWVYLTPLtKawUnwzMiKSSi9wkN4IDFTxJb3lZ5efkQqD4ZrLm3fQb2ApJ8ZwKhAPIA4Un7gxDGO+6kYykd52Hx9pbme2TuiPUt0xNtQf5pXgHDa+GctrabhNdlUJSmYCS3JA5qIGjGJklGblozSp9krPXxZhuxye6JFKVp3a6K7+yB+InOuTR6EleYMhEQb74fO0DiC8MlZptaM1AdkVBaNHyN8bGooBn6VlBa6JQU4FvMK2c5iZZ2hkQCZUzMhgsTJnKug0hGXBMSdO8nMmYupMMy2vY7/amdu4lRbRxexMybJHAeUEz5SaSi8cadYqL7EP8pLJ84n7jEqRjo8WPkqJ8UjJ3KRJVmJKVuWqkZ21L853rmdx99wP+PuRmhyZhRIPJCLQuBGOpoJu+5Vd
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(2906002)(44832011)(7416002)(5660300002)(41300700001)(83380400001)(4326008)(70206006)(8676002)(70586007)(54906003)(110136005)(47076005)(40460700003)(2616005)(1076003)(478600001)(426003)(336012)(40480700001)(86362001)(316002)(82310400005)(186003)(81166007)(36756003)(82740400003)(26005)(356005)(921005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:38:26.7981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 123b92a9-c2dd-4d56-c26c-08db1f00778c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8318
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index cd9f724a9e64..1bffc1994ed8 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -33,7 +33,6 @@
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
-#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 5c9f29f881a6..30ca4ab00175 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -223,10 +223,19 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
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
@@ -276,6 +285,21 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
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
@@ -342,6 +366,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
 		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
 
+	unmap_mcdi_buffer(efx);
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 49fb6be04eb3..0913ac2519cb 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -147,6 +147,7 @@ struct ef100_vdpa_filter {
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
+ * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
  * @net_config: virtio_net_config data
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
@@ -166,6 +167,7 @@ struct ef100_vdpa_nic {
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
+	enum efx_mcdi_mode mcdi_mode;
 	struct virtio_net_config net_config;
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
@@ -185,6 +187,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
+int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index db86c2693950..c6c9458f0e6f 100644
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
index 2c526d2edeb6..bc4de3b4e6f3 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -6,6 +6,9 @@
 
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

