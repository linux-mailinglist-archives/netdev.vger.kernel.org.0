Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4869E645CFF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiLGO4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiLGO4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C484F1A5;
        Wed,  7 Dec 2022 06:56:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ai7d4qkbtQnbrxbvNvFf7nK4yq2H6kfRa0RvfTVZUb900V6+kyimBTB4mcHPMyxAyY6bdZT9ti4shzH5TrFaH+iK6J7DC/qJMkDsl2tbndpqXXCVjM3EB+mrGpRoKFY2lp/KZwj/odzp5TkD3eniUcavhdH0kZ5UlvPvtKYnmZrwwDfF9KZMS6Z5+pFeq5P5akLfgvDRldsCoqxaz/YjSYILjBXISrkvtlnqL/+ULAgCV3I5a9SRb9CNRTqEJsviHJAZkaVgs2oPiMKRkPc8Q77qMEo5fzXtQ12Q6HN/Ihm2ehr8DQqPuh0NjmMA99FCcdRfKx3X4l5u02cRlcvZTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1jVTA2cP2nV730jZbiPBofg3pDjjrz3eaasFFGmpLk=;
 b=N5UmqEcEl6LGVIs74PsEN/lSwyrcg0P1OOWmeje0aKPb2X304rTQ/illo1YvH35qhOh+5zOSUcvJVnMVCLTLeXaLOhCFFa90ey8PSqCxNwCtwDpFfks7bYnPoZ154LBRJrEOSia8e2LkiikrGBZHLQlOX4PKkAIiymJpv/6TCegQ1CXoDejrOBqVuboR6+BAkRWX6c5+zdfJP5PFOOnhzKNyPxvcdE7Md75exqDDJKfAr/rrxQSlZk12feXZyvZbd+n5BFLrSx2ooiP1YgaMt5E2JhIE0zQeA9ZIwh+5sFMNSCyDbSUXEX6eXxb5L3Zl158+7VC8dxWbGcp4F/9NzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1jVTA2cP2nV730jZbiPBofg3pDjjrz3eaasFFGmpLk=;
 b=kHR/eUTXE3vxk40ACCPjAddwdPH/4CCs0mMaMgxWJLAim6Cc4vkG0WSadsLXc48b8ddwGvU8jV+1umNyxhM9rN9Mw5ZBmfO3LvuH5csoYm6AhW3vz+/B40wO4jId9o5XbeRqcdWU2hcxF+0dlo5C91a9Iv6EEKhIA4MVy8NIDv0=
Received: from DM6PR02CA0088.namprd02.prod.outlook.com (2603:10b6:5:1f4::29)
 by CH2PR12MB4087.namprd12.prod.outlook.com (2603:10b6:610:7f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:56:32 +0000
Received: from DS1PEPF0000E64F.namprd02.prod.outlook.com
 (2603:10b6:5:1f4:cafe::57) by DM6PR02CA0088.outlook.office365.com
 (2603:10b6:5:1f4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E64F.mail.protection.outlook.com (10.167.18.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:31 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:31 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:27 -0600
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
Subject: [PATCH net-next 04/11] sfc: implement vDPA management device operations
Date:   Wed, 7 Dec 2022 20:24:20 +0530
Message-ID: <20221207145428.31544-5-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64F:EE_|CH2PR12MB4087:EE_
X-MS-Office365-Filtering-Correlation-Id: 5afc5ff3-2e96-4ec8-b1f5-08dad8633a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LoPefXGhOKZaIcUQR5H3XhiDHlb6ZnzVJ5xal7eY/pWSD9IXWjmKOv73RlxkU1V/tOSNWzJTWbCXaM4hQgXMPdM2oD9qenGzchCGtSbGhZp5MepUume3ByAf4lVBiJxzHsCeNtTLE8S7xr83uaAM0JyKy7BpM3SxyIzkCCo8wY3mCU5bdKHuoZMZ4KGz318Vjjo+gpzwjD2Sg56MkA3j/UciZlCQcrXx7u0ZHOisxE3pXSRwNCeY0MtTWb83AVQMi7T7KEqVZEIqOZaJIfmgugeMgVjDgUN8edVImqNojsv3Jwu4dzgXmYkOvHDpR+RBI65hoYu+SgaHl/AmeuH8iICf1LAcPUmCnWkey8ICFjn8IT3Hlu1uBAukbDqkze35Roxguqq+Xpzs3vG2LDNqyQWveLq3RuIq3CPK8MFEvrfI0nSaWgt1xZihHtNwMmMSiPllomdpwmAMsKL5ZSNtAVWnzCjKZ0t9PQI0Gr9lltYhyuD7pRNgTKp4H3PEfVFxBrNygqyqTm8Ya4jK8LHTAEOLCuQBHvFOR7PWkZHCobY5p5yu8X+/RAxU7dcXryLcX1ksEsKxDnVFEUzy8Ul3RI0S+X8mByRgUUO6PLVxlBG0MeZrrRHGs64Lompul5etrazO4NxR6rhjz4ZGzkKC0KUvQ29N/LZC0SdHYA0y99Sa76/fnZbfFhJKyZ8Iv1+i3y+4xOtgd6h60E/xB+wg5f3pzIqNMEnzjdX0ao89HSViXagpjmTLtVWHbvz3dxXM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(40480700001)(4326008)(110136005)(54906003)(86362001)(316002)(8676002)(70206006)(26005)(70586007)(36860700001)(82740400003)(186003)(356005)(1076003)(81166007)(2906002)(41300700001)(336012)(2616005)(44832011)(47076005)(7416002)(8936002)(478600001)(426003)(6666004)(82310400005)(30864003)(5660300002)(83380400001)(36756003)(40460700003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:31.8867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afc5ff3-2e96-4ec8-b1f5-08dad8633a68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4087
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow vDPA device creation and deletion, add a vDPA management
device per function. Currently, the vDPA devices can be created
only on a VF. Also, for now only network class of vDPA devices
are supported.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/Makefile         |   2 +-
 drivers/net/ethernet/sfc/ef10.c           |   2 +-
 drivers/net/ethernet/sfc/ef100_nic.c      |  24 ++-
 drivers/net/ethernet/sfc/ef100_nic.h      |  11 +
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 232 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  84 ++++++++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  28 +++
 drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
 drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
 drivers/net/ethernet/sfc/net_driver.h     |   6 +
 10 files changed, 394 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 84c9f0590368..a10eac91ab23 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -11,7 +11,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
-sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 7022fb2005a2..366ecd3c80b1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -589,7 +589,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	if (rc)
 		goto fail4;
 
-	rc = efx_get_pf_index(efx, &nic_data->pf_index);
+	rc = efx_get_fn_info(efx, &nic_data->pf_index, NULL);
 	if (rc)
 		goto fail5;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 41175eb00326..41811c519275 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1160,7 +1160,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_get_pf_index(efx, &nic_data->pf_index);
+	rc = efx_get_fn_info(efx, &nic_data->pf_index, &nic_data->vf_index);
 	if (rc)
 		goto fail;
 
@@ -1247,13 +1247,33 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 
 int ef100_probe_vf(struct efx_nic *efx)
 {
-	return ef100_probe_main(efx);
+#if defined(CONFIG_SFC_VDPA)
+	int err;
+#endif
+	int rc;
+
+	rc = ef100_probe_main(efx);
+	if (rc)
+		return rc;
+
+#if defined(CONFIG_SFC_VDPA)
+	err = ef100_vdpa_register_mgmtdev(efx);
+	if (err)
+		pci_warn(efx->pci_dev,
+			 "vdpa_register_mgmtdev failed, err: %d\n", err);
+#endif
+	return 0;
 }
 
 void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+#if defined(CONFIG_SFC_VDPA)
+	if (efx_vdpa_supported(efx))
+		ef100_vdpa_unregister_mgmtdev(efx);
+#endif
+
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
 	if (nic_data) {
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 5ed693fbe79f..730c8bb932b0 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -68,6 +68,13 @@ enum ef100_bar_config {
 	EF100_BAR_CONFIG_VDPA,
 };
 
+#ifdef CONFIG_SFC_VDPA
+enum ef100_vdpa_class {
+	EF100_VDPA_CLASS_NONE,
+	EF100_VDPA_CLASS_NET,
+};
+#endif
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -75,7 +82,11 @@ struct ef100_nic_data {
 	u32 datapath_caps2;
 	u32 datapath_caps3;
 	unsigned int pf_index;
+	unsigned int vf_index;
 	u16 warm_boot_count;
+#ifdef CONFIG_SFC_VDPA
+	enum ef100_vdpa_class vdpa_class;
+#endif
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	enum ef100_bar_config bar_config;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 5e215cee585a..ff4bb61e598e 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -11,11 +11,17 @@
 #include <linux/err.h>
 #include <linux/vdpa.h>
 #include <linux/virtio_net.h>
+#include <uapi/linux/vdpa.h>
 #include "ef100_vdpa.h"
 #include "mcdi_vdpa.h"
 #include "mcdi_filters.h"
 #include "ef100_netdev.h"
 
+static struct virtio_device_id ef100_vdpa_id_table[] = {
+	{ .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
+	{ 0 },
+};
+
 int ef100_vdpa_init(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
@@ -42,17 +48,243 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
 	return rc;
 }
 
+static void ef100_vdpa_delete(struct efx_nic *efx)
+{
+	if (efx->vdpa_nic) {
+		/* replace with _vdpa_unregister_device later */
+		put_device(&efx->vdpa_nic->vdpa_dev.dev);
+		efx->vdpa_nic = NULL;
+	}
+}
+
 void ef100_vdpa_fini(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
+	struct ef100_nic_data *nic_data;
 
 	if (efx->state != STATE_VDPA && efx->state != STATE_DISABLED) {
 		pci_err(efx->pci_dev, "Invalid efx state %u", efx->state);
 		return;
 	}
 
+	/* Handle vdpa device deletion, if not done explicitly */
+	ef100_vdpa_delete(efx);
+	nic_data = efx->nic_data;
+	nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
 	efx->state = STATE_PROBED;
 	down_write(&efx->filter_sem);
 	efx_mcdi_filter_table_remove(efx);
 	up_write(&efx->filter_sem);
 }
+
+static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct efx_nic *efx = vdpa_nic->efx;
+	u16 mtu;
+	int rc;
+
+	vdpa_nic->net_config.max_virtqueue_pairs =
+		cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
+
+	rc = efx_vdpa_get_mtu(efx, &mtu);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: Get MTU for vf:%u failed:%d\n", __func__,
+			vdpa_nic->vf_index, rc);
+		return rc;
+	}
+	vdpa_nic->net_config.mtu = cpu_to_efx_vdpa16(vdpa_nic, mtu);
+	vdpa_nic->net_config.status = cpu_to_efx_vdpa16(vdpa_nic,
+							VIRTIO_NET_S_LINK_UP);
+	return 0;
+}
+
+static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
+						const char *dev_name,
+						enum ef100_vdpa_class dev_type,
+						const u8 *mac)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct ef100_vdpa_nic *vdpa_nic;
+	struct device *dev;
+	int rc;
+
+	nic_data->vdpa_class = dev_type;
+	vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
+				     vdpa_dev, &efx->pci_dev->dev,
+				     &ef100_vdpa_config_ops,
+				     1, 1,
+				     dev_name, false);
+	if (!vdpa_nic) {
+		pci_err(efx->pci_dev,
+			"vDPA device allocation failed for vf: %u\n",
+			nic_data->vf_index);
+		nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mutex_init(&vdpa_nic->lock);
+	dev = &vdpa_nic->vdpa_dev.dev;
+	efx->vdpa_nic = vdpa_nic;
+	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
+	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
+	vdpa_nic->efx = efx;
+	vdpa_nic->pf_index = nic_data->pf_index;
+	vdpa_nic->vf_index = nic_data->vf_index;
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
+	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
+	ether_addr_copy(vdpa_nic->mac_address, mac);
+	vdpa_nic->mac_configured = true;
+
+	rc = get_net_config(vdpa_nic);
+	if (rc)
+		goto err_put_device;
+
+	/* _vdpa_register_device when its ready */
+
+	return vdpa_nic;
+
+err_put_device:
+	/* put_device invokes ef100_vdpa_free */
+	put_device(&vdpa_nic->vdpa_dev.dev);
+	return ERR_PTR(rc);
+}
+
+static void ef100_vdpa_net_dev_del(struct vdpa_mgmt_dev *mgmt_dev,
+				   struct vdpa_device *vdev)
+{
+	struct ef100_nic_data *nic_data;
+	struct efx_nic *efx;
+	int rc;
+
+	efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
+	nic_data = efx->nic_data;
+
+	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
+	if (rc)
+		pci_err(efx->pci_dev,
+			"set_bar_config EF100 failed, err: %d\n", rc);
+	else
+		pci_dbg(efx->pci_dev,
+			"vdpa net device deleted, vf: %u\n",
+			nic_data->vf_index);
+}
+
+static int ef100_vdpa_net_dev_add(struct vdpa_mgmt_dev *mgmt_dev,
+				  const char *name,
+				  const struct vdpa_dev_set_config *config)
+{
+	struct ef100_vdpa_nic *vdpa_nic;
+	struct ef100_nic_data *nic_data;
+	struct efx_nic *efx;
+	int rc, err;
+
+	efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
+	if (efx->vdpa_nic) {
+		pci_warn(efx->pci_dev,
+			 "vDPA device already exists on this VF\n");
+		return -EEXIST;
+	}
+
+	if (config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
+		if (!is_valid_ether_addr(config->net.mac)) {
+			pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
+				config->net.mac);
+			return -EINVAL;
+		}
+	} else {
+		pci_err(efx->pci_dev, "MAC address parameter missing\n");
+		return -EIO;
+	}
+
+	nic_data = efx->nic_data;
+
+	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_VDPA);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"set_bar_config vDPA failed, err: %d\n", rc);
+		goto err_set_bar_config;
+	}
+
+	vdpa_nic = ef100_vdpa_create(efx, name, EF100_VDPA_CLASS_NET,
+				     (const u8 *)config->net.mac);
+	if (IS_ERR(vdpa_nic)) {
+		pci_err(efx->pci_dev,
+			"vDPA device creation failed, vf: %u, err: %ld\n",
+			nic_data->vf_index, PTR_ERR(vdpa_nic));
+		rc = PTR_ERR(vdpa_nic);
+		goto err_set_bar_config;
+	} else {
+		pci_dbg(efx->pci_dev,
+			"vdpa net device created, vf: %u\n",
+			nic_data->vf_index);
+		pci_warn(efx->pci_dev,
+			 "Use QEMU versions 6.1.0 and later with vhost-vdpa\n");
+	}
+
+	return 0;
+
+err_set_bar_config:
+	err = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
+	if (err)
+		pci_err(efx->pci_dev,
+			"set_bar_config EF100 failed, err: %d\n", err);
+
+	return rc;
+}
+
+static const struct vdpa_mgmtdev_ops ef100_vdpa_net_mgmtdev_ops = {
+	.dev_add = ef100_vdpa_net_dev_add,
+	.dev_del = ef100_vdpa_net_dev_del
+};
+
+int ef100_vdpa_register_mgmtdev(struct efx_nic *efx)
+{
+	struct vdpa_mgmt_dev *mgmt_dev;
+	u64 features;
+	int rc;
+
+	mgmt_dev = kzalloc(sizeof(*mgmt_dev), GFP_KERNEL);
+	if (!mgmt_dev)
+		return -ENOMEM;
+
+	rc = efx_vdpa_get_features(efx, EF100_VDPA_DEVICE_TYPE_NET, &features);
+	if (rc) {
+		pci_err(efx->pci_dev, "%s: MCDI get features error:%d\n",
+			__func__, rc);
+		goto err_get_features;
+	}
+
+	efx->mgmt_dev = mgmt_dev;
+	mgmt_dev->device = &efx->pci_dev->dev;
+	mgmt_dev->id_table = ef100_vdpa_id_table;
+	mgmt_dev->ops = &ef100_vdpa_net_mgmtdev_ops;
+	mgmt_dev->supported_features = features;
+	mgmt_dev->max_supported_vqs = EF100_VDPA_MAX_QUEUES_PAIRS * 2;
+	mgmt_dev->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
+
+	rc = vdpa_mgmtdev_register(mgmt_dev);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"vdpa_mgmtdev_register failed, err: %d\n", rc);
+		goto err_mgmtdev_register;
+	}
+
+	return 0;
+
+err_mgmtdev_register:
+err_get_features:
+	kfree(mgmt_dev);
+	efx->mgmt_dev = NULL;
+
+	return rc;
+}
+
+void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx)
+{
+	if (efx->mgmt_dev) {
+		vdpa_mgmtdev_unregister(efx->mgmt_dev);
+		kfree(efx->mgmt_dev);
+		efx->mgmt_dev = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 6b51a05becd8..83f6d819f6a5 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -18,6 +18,24 @@
 
 #if defined(CONFIG_SFC_VDPA)
 
+/* Max queue pairs currently supported */
+#define EF100_VDPA_MAX_QUEUES_PAIRS 1
+
+/**
+ * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
+ *
+ * @EF100_VDPA_STATE_INITIALIZED: State after vDPA NIC created
+ * @EF100_VDPA_STATE_NEGOTIATED: State after feature negotiation
+ * @EF100_VDPA_STATE_STARTED: State after driver ok
+ * @EF100_VDPA_STATE_NSTATES: Number of VDPA states
+ */
+enum ef100_vdpa_nic_state {
+	EF100_VDPA_STATE_INITIALIZED,
+	EF100_VDPA_STATE_NEGOTIATED,
+	EF100_VDPA_STATE_STARTED,
+	EF100_VDPA_STATE_NSTATES
+};
+
 enum ef100_vdpa_device_type {
 	EF100_VDPA_DEVICE_TYPE_NET,
 };
@@ -28,7 +46,73 @@ enum ef100_vdpa_vq_type {
 	EF100_VDPA_VQ_NTYPES
 };
 
+/**
+ *  struct ef100_vdpa_nic - vDPA NIC data structure
+ *
+ * @vdpa_dev: vdpa_device object which registers on the vDPA bus.
+ * @vdpa_state: NIC state machine governed by ef100_vdpa_nic_state
+ * @efx: pointer to the VF's efx_nic object
+ * @lock: Managing access to vdpa config operations
+ * @pf_index: PF index of the vDPA VF
+ * @vf_index: VF index of the vDPA VF
+ * @status: device status as per VIRTIO spec
+ * @features: negotiated feature bits
+ * @max_queue_pairs: maximum number of queue pairs supported
+ * @net_config: virtio_net_config data
+ * @mac_address: mac address of interface associated with this vdpa device
+ * @mac_configured: true after MAC address is configured
+ */
+struct ef100_vdpa_nic {
+	struct vdpa_device vdpa_dev;
+	enum ef100_vdpa_nic_state vdpa_state;
+	struct efx_nic *efx;
+	/* for synchronizing access to vdpa config operations */
+	struct mutex lock;
+	u32 pf_index;
+	u32 vf_index;
+	u8 status;
+	u64 features;
+	u32 max_queue_pairs;
+	struct virtio_net_config net_config;
+	u8 *mac_address;
+	bool mac_configured;
+};
+
 int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
+int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
+void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
+
+static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
+{
+	return virtio_legacy_is_little_endian() ||
+		(vdpa_nic->features & (1ULL << VIRTIO_F_VERSION_1));
+}
+
+static inline u16 efx_vdpa16_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
+				    __virtio16 val)
+{
+	return __virtio16_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
+}
+
+static inline __virtio16 cpu_to_efx_vdpa16(struct ef100_vdpa_nic *vdpa_nic,
+					   u16 val)
+{
+	return __cpu_to_virtio16(efx_vdpa_is_little_endian(vdpa_nic), val);
+}
+
+static inline u32 efx_vdpa32_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
+				    __virtio32 val)
+{
+	return __virtio32_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
+}
+
+static inline __virtio32 cpu_to_efx_vdpa32(struct ef100_vdpa_nic *vdpa_nic,
+					   u32 val)
+{
+	return __cpu_to_virtio32(efx_vdpa_is_little_endian(vdpa_nic), val);
+}
+
+extern const struct vdpa_config_ops ef100_vdpa_config_ops;
 #endif /* CONFIG_SFC_VDPA */
 #endif /* __EF100_VDPA_H__ */
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
new file mode 100644
index 000000000000..31952931c198
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -0,0 +1,28 @@
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
+#include <linux/vdpa.h>
+#include "ef100_vdpa.h"
+
+static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
+{
+	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
+}
+
+static void ef100_vdpa_free(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	mutex_destroy(&vdpa_nic->lock);
+}
+
+const struct vdpa_config_ops ef100_vdpa_config_ops = {
+	.free	             = ef100_vdpa_free,
+};
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index d3e6d8239f5c..4415f19cf68f 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -413,7 +413,8 @@ int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
 	return 0;
 }
 
-int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
+int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
+		    unsigned int *vf_index)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
 	size_t outlen;
@@ -426,6 +427,10 @@ int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
 	if (outlen < sizeof(outbuf))
 		return -EIO;
 
-	*pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
+	if (pf_index)
+		*pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
+
+	if (efx->type->is_vf && vf_index)
+		*vf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_VF);
 	return 0;
 }
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index b0e2f53a0d9b..76dc0a13463e 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -28,6 +28,7 @@ void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
 int efx_fini_dmaq(struct efx_nic *efx);
 int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
-int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index);
+int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
+		    unsigned int *vf_index);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ffda80a95221..79356d614109 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1182,6 +1182,12 @@ struct efx_nic {
 
 	unsigned int mem_bar;
 	u32 reg_base;
+#ifdef CONFIG_SFC_VDPA
+	/** @mgmt_dev: vDPA Management device */
+	struct vdpa_mgmt_dev *mgmt_dev;
+	/** @vdpa_nic: vDPA device structure (EF100) */
+	struct ef100_vdpa_nic *vdpa_nic;
+#endif
 
 	/* The following fields may be written more often */
 
-- 
2.30.1

