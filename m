Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF36ADDA4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCGLkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjCGLi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:38:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C0493EF;
        Tue,  7 Mar 2023 03:37:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZztZIsndmyybWUJV3m6W58sGw7fJPXJTEwTEteVh/drQEJEJEDdVHonKm9A4Q7WKjAG9zmAoGdESIte4PgTX+M/+kultgnvDV/kM7obpyHgsDzOsF4A6jHlq6p7HBY8tMheKwb1zw81ziA1etDos/Aanq5dzOwyevI7emcamHnHM4g+LOX3a/HR6HR5Z1MT2uOCkTHDkuGNs+RiE74s0d0Ag2dTw25UxDDoNsyLfj4kD+m5rF3/D5Fp0/R8iXK0Z1+ozm/Oypxn+W4ZQvavGLpU9tQUkg0vSdRxowo1BmKMGm07lU9hMdyzNDmPLzClQ1GZvfLvVMjos5pYam7USA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=aARdG6AT7ilHSy/WxbzMG93/SVSDJ4d6uEqeAhCF39ra1sQvTx7OtMBoUTAmZWIUEFJoifAd0GCKCVvW7tZVYUWaoh/SAHWWPUV7u9SD+K0QwetMPmUDX+B+4aa1jJ6c91xZxouf/+Jtk5cWQ01zcYP759Ft+XaTCIS916ordKAImgqbfl43uFKNj6fzda0R8Q9x+ZuvgxPn6NnFFvQrf9pHYmNUhr7lQbElWsC3kXyJRjlVesrjNsU1vYbGEzyqvolNhkMrvWzWDPSjwrv0zpGaP8juyB1CTKkAzJGyixim8QJMgxFuJvZ7qntkDDqPiruKmEutgduihtsbLdWfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=H3pclU8moczg/VDEkGxrRWP65Nbk0Pgz3LsVElURBCk+G/bN1D8m5IGgOxGSdS+zSYwg938PHgx5qdVRrPU/SgAmf4kpkddcmrSa9HikJYe+PAYvSCmEmFWymQe7QLFtY3GErYmL8cQx//NpmH62KGSDy5v9HGtQcU5fZ2lip7I=
Received: from DM6PR18CA0011.namprd18.prod.outlook.com (2603:10b6:5:15b::24)
 by PH7PR12MB6417.namprd12.prod.outlook.com (2603:10b6:510:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 11:37:36 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:15b:cafe::af) by DM6PR18CA0011.outlook.office365.com
 (2603:10b6:5:15b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:37:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 7 Mar 2023 11:37:36 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:35 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:37:31 -0600
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
Subject: [PATCH net-next v2 07/14] sfc: implement vdpa device config operations
Date:   Tue, 7 Mar 2023 17:06:09 +0530
Message-ID: <20230307113621.64153-8-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|PH7PR12MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c2d170a-4a0e-4d97-d254-08db1f005977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61u6SSrVjHVqh5OsiO/pMOZdiv9Le8jfh+/wuUazEM4LkUS2EYiI9P/udrZVL6cHqFrqfqJLk53/pv49tdV6m2NWK/kpY4Vu3DXPKxlmebU7rKO/s2zwQ9keG47BbvpWuyRGbxvULNuB9I7kAdDxBOOqY7/BQCFqi87fohqDlwACk6YwMOCIg9Y79+9UD3vsVRNvOtVdU30fFZJOa8gbSfvKZC1S5V0JTjgLzIzufwHQUJx2rhe02/xiIsyooEIrOjiYUxFZzm3qoa0obhuh0YiuTLgnmHenfuAXg7ua0gFn/CEnNXqXCNJhXzTRAkaHjZ6wOly8ehsQxF35U8/g2USh8JY6xCrwu7DsSilVnMjMhOP8M6axrCVKRtsrG0TY/WNAfduKlJhBgaoRdOkgnpEGGc7lvQ5KIhzGH3XUBrxmqmGRXwF1xvz3Ihi7Ss2D2fa6/rk/9DPoynEx2ghxlLVtFjyk85CMoNoCVYZ5FvxZb+hpbRKEZBLI8LLn0ytWDXqTBdykU6bf72WiTxYU+FdUKEk7RoeUBGwOlLyv2FUhIKUa13542wzB9zyXS1qUgAsdSqV3bD07ayYvsWJHquxHYdZWLfciuzs1SCjXQUOXtcHI1eSAGskB9RJFguc6sI7FMNquEiSDQbxazwiCPAgmcdvlq4AXuAWgxaEkmdu6h+S1mFSLlEJXazyeYEjwuOyuc6LRSgceFcCj1eaCj5qj/qBxVnRk6sOxI31LX4PsXqJYFSY8K8m1Awh74W9n
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(81166007)(921005)(356005)(86362001)(5660300002)(36756003)(7416002)(44832011)(2906002)(82740400003)(4326008)(40480700001)(8676002)(41300700001)(8936002)(70586007)(70206006)(82310400005)(2616005)(40460700003)(336012)(186003)(83380400001)(426003)(47076005)(316002)(110136005)(478600001)(54906003)(6666004)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:37:36.3761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2d170a-4a0e-4d97-d254-08db1f005977
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6417
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA config operations can be broadly categorized in to either
virtqueue operations, device operations or DMA operations.
This patch implements most of the device level config operations.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  14 +++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 131 ++++++++++++++++++++++
 2 files changed, 145 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 1101b30f56e7..dcf4a8156415 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -20,6 +20,18 @@
 /* Max queue pairs currently supported */
 #define EF100_VDPA_MAX_QUEUES_PAIRS 1
 
+/* Device ID of a virtio net device */
+#define EF100_VDPA_VIRTIO_NET_DEVICE_ID VIRTIO_ID_NET
+
+/* Vendor ID of Xilinx vDPA NIC */
+#define EF100_VDPA_VENDOR_ID  PCI_VENDOR_ID_XILINX
+
+/* Max number of Buffers supported in the virtqueue */
+#define EF100_VDPA_VQ_NUM_MAX_SIZE 512
+
+/* Alignment requirement of the Virtqueue */
+#define EF100_VDPA_VQ_ALIGN 4096
+
 /**
  * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
  *
@@ -60,6 +72,7 @@ enum ef100_vdpa_vq_type {
  * @net_config: virtio_net_config data
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
+ * @cfg_cb: callback for config change
  */
 struct ef100_vdpa_nic {
 	struct vdpa_device vdpa_dev;
@@ -75,6 +88,7 @@ struct ef100_vdpa_nic {
 	struct virtio_net_config net_config;
 	u8 *mac_address;
 	bool mac_configured;
+	struct vdpa_callback cfg_cb;
 };
 
 int ef100_vdpa_init(struct efx_probe_data *probe_data);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index f1ce011adc43..a2364ef9f492 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -9,12 +9,131 @@
 
 #include <linux/vdpa.h>
 #include "ef100_vdpa.h"
+#include "mcdi_vdpa.h"
 
 static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
 {
 	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
 }
 
+static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
+{
+	return EF100_VDPA_VQ_ALIGN;
+}
+
+static u64 ef100_vdpa_get_device_features(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u64 features;
+	int rc;
+
+	rc = efx_vdpa_get_features(vdpa_nic->efx,
+				   EF100_VDPA_DEVICE_TYPE_NET, &features);
+	if (rc) {
+		dev_err(&vdev->dev, "%s: MCDI get features error:%d\n",
+			__func__, rc);
+		/* Returning 0 as value of features will lead to failure
+		 * of feature negotiation.
+		 */
+		return 0;
+	}
+
+	features |= BIT_ULL(VIRTIO_NET_F_MAC);
+	return features;
+}
+
+static int ef100_vdpa_set_driver_features(struct vdpa_device *vdev,
+					  u64 features)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u64 verify_features;
+	int rc;
+
+	mutex_lock(&vdpa_nic->lock);
+	verify_features = features & ~BIT_ULL(VIRTIO_NET_F_MAC);
+	rc = efx_vdpa_verify_features(vdpa_nic->efx,
+				      EF100_VDPA_DEVICE_TYPE_NET,
+				      verify_features);
+	if (rc) {
+		dev_err(&vdev->dev, "%s: MCDI verify features error:%d\n",
+			__func__, rc);
+		goto err;
+	}
+
+	vdpa_nic->features = features;
+err:
+	mutex_unlock(&vdpa_nic->lock);
+	return rc;
+}
+
+static u64 ef100_vdpa_get_driver_features(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	return vdpa_nic->features;
+}
+
+static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
+				     struct vdpa_callback *cb)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	if (cb)
+		vdpa_nic->cfg_cb = *cb;
+}
+
+static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
+{
+	return EF100_VDPA_VQ_NUM_MAX_SIZE;
+}
+
+static u32 ef100_vdpa_get_device_id(struct vdpa_device *vdev)
+{
+	return EF100_VDPA_VIRTIO_NET_DEVICE_ID;
+}
+
+static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
+{
+	return EF100_VDPA_VENDOR_ID;
+}
+
+static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
+static void ef100_vdpa_get_config(struct vdpa_device *vdev,
+				  unsigned int offset,
+				  void *buf, unsigned int len)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	/* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
+	if (WARN_ON(((u64)offset + len) > sizeof(struct virtio_net_config))) {
+		dev_err(&vdev->dev,
+			"%s: Offset + len exceeds config size\n", __func__);
+		return;
+	}
+	memcpy(buf, (u8 *)&vdpa_nic->net_config + offset, len);
+}
+
+static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
+				  const void *buf, unsigned int len)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	/* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
+	if (WARN_ON(((u64)offset + len) > sizeof(vdpa_nic->net_config))) {
+		dev_err(&vdev->dev,
+			"%s: Offset + len exceeds config size\n", __func__);
+		return;
+	}
+
+	memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
+	if (is_valid_ether_addr(vdpa_nic->mac_address))
+		vdpa_nic->mac_configured = true;
+}
+
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
@@ -26,5 +145,17 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
 }
 
 const struct vdpa_config_ops ef100_vdpa_config_ops = {
+	.get_vq_align	     = ef100_vdpa_get_vq_align,
+	.get_device_features = ef100_vdpa_get_device_features,
+	.set_driver_features = ef100_vdpa_set_driver_features,
+	.get_driver_features = ef100_vdpa_get_driver_features,
+	.set_config_cb	     = ef100_vdpa_set_config_cb,
+	.get_vq_num_max      = ef100_vdpa_get_vq_num_max,
+	.get_device_id	     = ef100_vdpa_get_device_id,
+	.get_vendor_id	     = ef100_vdpa_get_vendor_id,
+	.get_config_size     = ef100_vdpa_get_config_size,
+	.get_config	     = ef100_vdpa_get_config,
+	.set_config	     = ef100_vdpa_set_config,
+	.get_generation      = NULL,
 	.free	             = ef100_vdpa_free,
 };
-- 
2.30.1

