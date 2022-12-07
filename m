Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F74D645D09
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiLGO5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiLGO4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2E060359;
        Wed,  7 Dec 2022 06:56:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pilh7EWcCoxzVkIn7/81qf2Ues75EArNLy0wXuedTdoNNDvnCOqnqFD9gLzm1pCOam/SAcwT+F8aLGRIwFjOxWJt+0Nmuj54FKss8dU4hcKEtete+aJCTB7YWszW9XAzGhdmQg6QInBX/gZKPrrIwEGUYXVbBsCtHyotnXfYdtUyjffjIZB34/yMAA6ZOKPkEvfQwgLMUIG1Dcn/AK+XMsZe7rWL3P4jo1DbwXVX5xFrn3i5jcmWiG28ds3yMIEzB8M2dLuCAsyG7Hcwmvu1VN36ATvaZ86mc63zG1I3qFuFefbbaQBAsklSOrS+hBK0bzyXfNkAvQ6hCIk9Y5Sw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptQNG+kRb2mcK9TcZk4sB6PxbZ/cpAZHKDPZf7ZuDjA=;
 b=b+6m2rCXt1VauaVQmbQvnPhYvC+tHLcvh28tea1NU6m1Thp8iiuVo9l7S9XwgH0wRssH3vMub4QdXLoCuB0GQO1Nfnjl5wxH8BYQ6b1UV7U5vJE0pOeg49enbhi0BHLJjEnDEUlbviVfyJP12iiGyek+NKme6oHfqfPGVDD5C/SEGaoGPdBIQXAxBSJWdnAr/O05r1nAnb+3XC13vvAh5AgA8ohu0Tk3KsGhTCywVo8b1bIyKYcUfXGuGlpKflod/5MmZL6dZW3qjjL7442DKlGMsQMF5Lu3nlj5uDJ+RM93kb9hC9IATM7p5ZM7DoGezs3Qsm68nQ3cmJoaVMW8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptQNG+kRb2mcK9TcZk4sB6PxbZ/cpAZHKDPZf7ZuDjA=;
 b=kGUc84/YLGji5UvX38PFROhALOXXsYxCfTtLxxmY3kZciHNgE4ji3wWU5L9B9LSoyDp5SKcfroj5nZ1FaByMfgKCqT5jy/6+oHPO2q4F0YlCf4xmM3ODMpbNYhSp2R5Vd7kZ/ojIQlxBrhDIBuiN0Mci5C5XFZfzgz3AWs8SgxA=
Received: from DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23) by
 SJ1PR12MB6314.namprd12.prod.outlook.com (2603:10b6:a03:457::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 14:56:37 +0000
Received: from DS1PEPF0000E64E.namprd02.prod.outlook.com
 (2603:10b6:5:296:cafe::ad) by DM6PR01CA0018.outlook.office365.com
 (2603:10b6:5:296::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E64E.mail.protection.outlook.com (10.167.18.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:36 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:36 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:32 -0600
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
Subject: [PATCH net-next 05/11] sfc: implement vdpa device config operations
Date:   Wed, 7 Dec 2022 20:24:21 +0530
Message-ID: <20221207145428.31544-6-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64E:EE_|SJ1PR12MB6314:EE_
X-MS-Office365-Filtering-Correlation-Id: 15fbb702-9e90-4b80-1a4f-08dad8633d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxOWiJjoG73UDnJr4+ipYjmRQz4+PcLBNKxjte0tTqTiUXkV5N/mx0MacqQgxZarS7cAdLxMWsxJiDY2qr47o+CB3LPhjrvTyHQmYih5wtk5yMwi7HDO5wVoSjEDd5taqnMqyz4/euqTTUI/kMdFBYCP8W8/uZmkZj8tnRjwoEMd0N885CxcK8fbyPFi+38eLRdpw2s4XYIOgxnpkDbPr/SS5hPD6OCtLyDpBw50X0wW2oN6gra67xIJKZ5b/4izzfmuJheuFEm+fE86sVaXGFucZMCYwjxrPNXArNFZu+9tattjfxbJIfIxMNz82EIx03J5YmDAl7zzQv4qNzuBt2Y+nYgMzkloPvLQa+6u9jIzKukLi0JyXFX6/F3fXRlcQFtAC4NwaYrCoxR37h415UzHUKYUyXeYOVJY5OEb7uiR0nv4ULczJN28dZsFg1jyGZ9pQZlELBIGAoaYMHupU5eNk9Syr2c3deh7Y5SIqAdN9d7m18ygBPvsexRDIoixGH9e5fLXM+JxqOtHvjCsPFe4IBzheiTIJjoteVnohAytibh22pCnpEBuGBYnp62pvSBT1XvahBZ7OVX3SMeN8qHH4EQsQavibJpO58LWUSCvxR2crL7ruvkHrZzH5ZIENBiKqjNBvnq5BVBjXY1N5CeLz/YDUf/zc0lGz9pgoliPE8fRv/X2oe0MdDrea1fE+iw1jTWF09wvuGfgHNg9ytQO1Xl8pL4Rsfc0/OrsNO/Cf/+CVf1EGFdBQIpBgmiu5FB9ypzZhcUmdI4BBEgKZQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(110136005)(316002)(54906003)(26005)(186003)(40460700003)(36756003)(44832011)(81166007)(356005)(83380400001)(82740400003)(7416002)(36860700001)(2906002)(5660300002)(8676002)(4326008)(86362001)(70206006)(70586007)(82310400005)(336012)(47076005)(8936002)(426003)(2616005)(41300700001)(1076003)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:36.9527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fbb702-9e90-4b80-1a4f-08dad8633d70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6314
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA config operations can be broadly categorized in to either
virtqueue operations, device operations or DMA operations.
This patch implements most of the device level config operations.

SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
virtio driver but not the kernel virtio driver. Due to a bug in
QEMU (https://gitlab.com/qemu-project/qemu/-/issues/331#), with
vhost-vdpa, this feature bit is returned with guest kernel virtio
driver in set_features config operation. The fix for this bug
(qemu_commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
version required for testing with the vhost-vdpa driver.

With older QEMU releases, VIRTIO_F_IN_ORDER is negotiated but
not honored causing Firmware exception.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  14 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 148 ++++++++++++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 83f6d819f6a5..be7650c3166a 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -21,6 +21,18 @@
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
@@ -61,6 +73,7 @@ enum ef100_vdpa_vq_type {
  * @net_config: virtio_net_config data
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
+ * @cfg_cb: callback for config change
  */
 struct ef100_vdpa_nic {
 	struct vdpa_device vdpa_dev;
@@ -76,6 +89,7 @@ struct ef100_vdpa_nic {
 	struct virtio_net_config net_config;
 	u8 *mac_address;
 	bool mac_configured;
+	struct vdpa_callback cfg_cb;
 };
 
 int ef100_vdpa_init(struct efx_probe_data *probe_data);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 31952931c198..87899baa1c52 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -10,12 +10,148 @@
 
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
+	/* SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
+	 * virtio driver but not the kernel virtio driver. Due to a bug in
+	 * QEMU (https://gitlab.com/qemu-project/qemu/-/issues/331#), with
+	 * vhost-vdpa, this feature bit is returned with guest kernel virtio
+	 * driver in set_features config operation. The fix for this bug
+	 * (commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
+	 * in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
+	 * version required for testing with the vhost-vdpa driver.
+	 */
+	features |= BIT_ULL(VIRTIO_NET_F_MAC);
+
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
+	if (vdpa_nic->vdpa_state != EF100_VDPA_STATE_INITIALIZED) {
+		dev_err(&vdev->dev, "%s: Invalid state %u\n",
+			__func__, vdpa_nic->vdpa_state);
+		rc = -EINVAL;
+		goto err;
+	}
+	verify_features = features & ~BIT_ULL(VIRTIO_NET_F_MAC);
+	rc = efx_vdpa_verify_features(vdpa_nic->efx,
+				      EF100_VDPA_DEVICE_TYPE_NET,
+				      verify_features);
+
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
@@ -24,5 +160,17 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
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

