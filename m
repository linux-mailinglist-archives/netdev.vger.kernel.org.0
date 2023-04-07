Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AECF6DA9D7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjDGIMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbjDGIMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:12:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FD0B472;
        Fri,  7 Apr 2023 01:12:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN3b8Z/Zpjyw3tknBP6zqPHgM0W7PE80dVXbZjksyGbHiEYnFihHolP0J2l7QfAJyNdlDwZGNNAjeAGcSkIgdT3jkfSYoFGtf3gHxNVSXWOCxjdqnQGYY0lAd1sjS3+H9i2pFwNFsXliOW6ZMIdmIM1Ozd+m4+JrZVTNr0Ue9uYQ+8j0yLfkBj4nizloP/A2KtR8i7bZofPvy46k2uCglaGxES/XkC/0f0pA+fnOST3aSwjYrjxbVCzHsnwxLggudyXYDCA870vHjTXlCZecK2nLVZxs1lv+0B+KXo8YzAQDBR6IuKcZreY+zqrE1FHDyN7OxsqB1xRq/oyVnGWF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGZZ9tsqNMPx745r7H142nmzFc5x33OmUMSpk0WsWfs=;
 b=DOk6uIRv5iqkUyMDIvnOB5KiI1UMSjtYqOPT8O+Kxec8SNoziS1fO0w9teEagq187fV8oJAvuuULalM1u2jAR9r0KG1jjEwEFDTGR7nhNvQXPvGAn6kjDOQsvTcF6oK52ad4gKt+LhJiKv3BsRV0/+tANBCPp8QAfhn8Oyqtyoxg48KSqii1YV+lNbzcm43fpQyoHxG0pR0GpxGxczpnjmSXCRY7snv5O/UiPzNiE8FaxFSffCRH07xEnb56Bt/xG9jBO0dCsh81Q1I8GaT2BDZMbMUlp1CvSxTqTyhUnQtf0htmn1S+khdFy2vi2+kHPEAwnsrt+Be5FNENN42umg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGZZ9tsqNMPx745r7H142nmzFc5x33OmUMSpk0WsWfs=;
 b=AWQ0sms1pufR38KEzsaLxzBLMdS1N2DfKONXJQoHxM02ZCbplk0PJ8HWtoHkc0mamVf8MEauh14NVOdmnIgNyJGWkc7MTWrwC6CQ2LxdtWjQ0oLN+NBQjgd9DOSyi2+36ppBSzR2xHa6+/X6oxG7HPoTIBgTe01B8PaXdAMoaYo=
Received: from MW4PR03CA0188.namprd03.prod.outlook.com (2603:10b6:303:b8::13)
 by CY5PR12MB6480.namprd12.prod.outlook.com (2603:10b6:930:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 7 Apr
 2023 08:11:35 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::15) by MW4PR03CA0188.outlook.office365.com
 (2603:10b6:303:b8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.33 via Frontend Transport; Fri, 7 Apr 2023 08:11:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:32 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:28 -0500
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
Subject: [PATCH net-next v4 06/14] sfc: implement vDPA management device operations
Date:   Fri, 7 Apr 2023 13:40:07 +0530
Message-ID: <20230407081021.30952-7-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|CY5PR12MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdd7965-6540-402c-ab06-08db373fb3a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(40470700004)(36840700001)(46966006)(54906003)(2616005)(82310400005)(4326008)(36756003)(40460700003)(44832011)(7416002)(5660300002)(356005)(30864003)(40480700001)(70206006)(83380400001)(8936002)(8676002)(70586007)(41300700001)(82740400003)(86362001)(921005)(2906002)(6666004)(426003)(26005)(81166007)(36860700001)(47076005)(110136005)(1076003)(186003)(336012)(478600001)(316002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:33.7966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdd7965-6540-402c-ab06-08db373fb3a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6480
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
 drivers/net/ethernet/sfc/ef100_nic.c      |  26 ++-
 drivers/net/ethernet/sfc/ef100_nic.h      |   9 +
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 228 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  84 ++++++++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  30 +++
 drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
 drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
 drivers/net/ethernet/sfc/net_driver.h     |   6 +
 10 files changed, 392 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 3a2bb98d1c3f..bd8ba588b968 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -12,7 +12,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
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
index bc010b504b4a..e42be65334a5 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1170,7 +1170,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_get_pf_index(efx, &nic_data->pf_index);
+	rc = efx_get_fn_info(efx, &nic_data->pf_index, &nic_data->vf_index);
 	if (rc)
 		goto fail;
 
@@ -1286,13 +1286,35 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 
 int ef100_probe_vf(struct efx_nic *efx)
 {
-	return ef100_probe_main(efx);
+	struct ef100_nic_data *nic_data __maybe_unused;
+	int rc;
+
+	rc = ef100_probe_main(efx);
+	if (rc)
+		return rc;
+
+#ifdef CONFIG_SFC_VDPA
+	nic_data = efx->nic_data;
+	if (nic_data->vdpa_supported) {
+		rc = ef100_vdpa_register_mgmtdev(efx);
+		if (rc)
+			pci_warn(efx->pci_dev,
+				 "register_mgmtdev failed, rc: %d\n", rc);
+	}
+#endif
+
+	return 0;
 }
 
 void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+#ifdef CONFIG_SFC_VDPA
+	if (nic_data->vdpa_supported)
+		ef100_vdpa_unregister_mgmtdev(efx);
+#endif
+
 	if (IS_ENABLED(CONFIG_SFC_SRIOV) && efx->mae) {
 		efx_ef100_fini_reps(efx);
 		efx_fini_mae(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index a01e9d643ccd..e63ea555116c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -69,6 +69,13 @@ enum ef100_bar_config {
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
@@ -76,9 +83,11 @@ struct ef100_nic_data {
 	u32 datapath_caps2;
 	u32 datapath_caps3;
 	unsigned int pf_index;
+	unsigned int vf_index;
 	u16 warm_boot_count;
 #ifdef CONFIG_SFC_VDPA
 	bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
+	enum ef100_vdpa_class vdpa_class;
 #endif
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 268c973f7376..1ba34e4e0a87 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -10,11 +10,17 @@
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
@@ -41,17 +47,239 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
 	return rc;
 }
 
+static void ef100_vdpa_delete(struct efx_nic *efx)
+{
+	if (efx->vdpa_nic) {
+		/* replace with _vdpa_unregister_device later */
+		put_device(&efx->vdpa_nic->vdpa_dev.dev);
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
+	efx->vdpa_nic = vdpa_nic;
+	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
+	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
+	vdpa_nic->efx = efx;
+	vdpa_nic->pf_index = nic_data->pf_index;
+	vdpa_nic->vf_index = nic_data->vf_index;
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
+	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
+
+	rc = get_net_config(vdpa_nic);
+	if (rc)
+		goto err_put_device;
+
+	if (mac) {
+		ether_addr_copy(vdpa_nic->mac_address, mac);
+		vdpa_nic->mac_configured = true;
+	}
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
+	const u8 *mac = NULL;
+	struct efx_nic *efx;
+	int rc, err;
+
+	efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
+	if (config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
+		if (!is_valid_ether_addr(config->net.mac)) {
+			pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
+				config->net.mac);
+			return -EINVAL;
+		}
+		mac = (const u8 *)config->net.mac;
+	}
+
+	if (efx->vdpa_nic) {
+		pci_warn(efx->pci_dev,
+			 "vDPA device already exists on this VF\n");
+		return -EEXIST;
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
+	vdpa_nic = ef100_vdpa_create(efx, name, EF100_VDPA_CLASS_NET, mac);
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
index ccc5eb0a2a84..1101b30f56e7 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -17,6 +17,24 @@
 
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
@@ -27,7 +45,73 @@ enum ef100_vdpa_vq_type {
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
index 000000000000..f1ce011adc43
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for AMD network controllers and boards
+ * Copyright(C) 2023, Advanced Micro Devices, Inc.
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
+	if (vdpa_nic) {
+		mutex_destroy(&vdpa_nic->lock);
+		vdpa_nic->efx->vdpa_nic = NULL;
+	}
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
index 3dc9eae5a81d..1da71deac71c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1090,6 +1090,12 @@ struct efx_nic {
 	int rx_packet_len_offset;
 	int rx_packet_ts_offset;
 	bool rx_scatter;
+#ifdef CONFIG_SFC_VDPA
+	/** @mgmt_dev: vDPA Management device */
+	struct vdpa_mgmt_dev *mgmt_dev;
+	/** @vdpa_nic: vDPA device structure (EF100) */
+	struct ef100_vdpa_nic *vdpa_nic;
+#endif
 	struct efx_rss_context rss_context;
 	struct mutex rss_lock;
 	u32 vport_id;
-- 
2.30.1

