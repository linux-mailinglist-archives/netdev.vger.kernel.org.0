Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DCF6DA9D9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbjDGINB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjDGIMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:12:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F745B757;
        Fri,  7 Apr 2023 01:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jow/Xb1l5x2lVIdQ36o6vPxRk4RvJfW5/nqrLT/3vOOOmbmzBUhu5mrpTpc0GPSq/AaplQCBwQT+2/tofEIsOo8jnXKo8PJJKu7n6fbysb8BWL5w2Vam/RunZo37ok0lTclqn8uJs3wmaw3d4WDxtsND7wbISku4SZkd3kPXwwPCaTboCBJN9syfL/xxblhwmttkUKvvY5uanxoarjAICPJ1c2hrmf6qB8dHybc0qKwcBV8T3KyNXgEdA5V2oxQ34zubeZBb1XeefRDT2Dad4wjiv+l/UZCCiJ9WLkZvtPNNK/f8Pr9tkBfk99o0W8798BLsX8IL/bD+GHe1VSsQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=XGWycx8xma7Esu/bu49LiXEpIDBcw/pPl1k0tRmZ/NFezMTd0mc3YaPqBcjK6Jx5JcD696V0Ghi9Ux/hFw7U0gxR766pvO0nd0ENrVHLcfKxPc/uFhFDO6AD5gM+19JDH0LPbTtyuMdW/Tf/DgS8Pt0f+fZedghl3knk2Dweu4WYSamrXUzTl5OKYP3+YubUA3JjtTOdCCvC51cMLE/lsxSXyoW+fV5tdsvct/NAffFZ/Jdada7hmc1xSTn5CtEPc5UfB0h7mBi+9a3Te6/bj/L+ykk4UwKB0fT4d3vPBScgWlbh79FM01Vh1xv+O+4+ylKnMwQ924c9xJOJZLX/7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=ziPxI1nN2OTx14snmv12PzXZekbHmJyZcALcWZ4k42U9ElRZdtqRXsDfR8rlKZfRLy3Ehr1c/Q9mV05E6pLc67OcNFhQaYAm5LmFOXrU1bOVA1bE8ePNyremz3jGzzGGSn3wWhfg82QOJJVKZKz/5yDfHwbD/iDTO/AvYyRiMQ0=
Received: from MW4PR03CA0355.namprd03.prod.outlook.com (2603:10b6:303:dc::30)
 by PH7PR12MB6720.namprd12.prod.outlook.com (2603:10b6:510:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Fri, 7 Apr
 2023 08:11:43 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::f7) by MW4PR03CA0355.outlook.office365.com
 (2603:10b6:303:dc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Fri, 7 Apr 2023 08:11:42 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:41 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 01:11:41 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:37 -0500
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
Subject: [PATCH net-next v4 07/14] sfc: implement vdpa device config operations
Date:   Fri, 7 Apr 2023 13:40:08 +0530
Message-ID: <20230407081021.30952-8-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|PH7PR12MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: cb304d88-80e6-46a6-71e9-08db373fb8d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyYLGbIx3ASFaue3dv69BBAuLRUk42aDz/4F7Ar2rc2oRy0RLJMf1QdoqePu14N0MRVaPu8F3TeGV9+D80y06mryDrzA2Ts2P2/6WvU8YJI+B2kdp7wtAgLKUvZAqeh6pg0qjx4zn0CYaloSiZtnqQ9vv0f1eeApF7gXJH+94mX3vJH9ZK1uXS36U/qxSl6gaJuIYXtssktGs37nFVakvSnFeGVVLriWSPeaOXWDwgZrHT45ZNj87FxkzAxhjJl7Eva0NbsQPt+C149QpVJ2666bh6USQTYu6IV0T+E/eLadQsrfMaXCgwiQHuBXc46KlumzaMcbkZkc4oyUo5sgm8476kdXZWB3L0omuyTycFG/4SawrH2/wEbOwyBn0wS0B3hIo54sItLLFQ9JZYPl9ss3riQzQzYtnDVRyV9XV/wTUdS2T2e55RC/UI6tZNWMLaHpyuHTuqD4eV0mdV8luQztPxX16gX2K0kUMzrBB6LWlnYAXXCTYljVGxzcVm9fr5DufdESgKnWoCcijTzSxx5D920x1GZqSYWOMGZ94oZEpTW3xGm0F/Gt0w1j2P9K9dJb9eV1FPPFIJSBiyv8l+u6HJd1Fc3L3bKxxVteIm6TK1XBovcN4qHhO07Expniz4TLat2s2fzlejxjTJ4EQf5J+yND7wQhrh+03iBjUQ4bLyA7bFdZlYM8ezFYOk8QzRa4XNbyQjP7AjEZBiuXv0HMBtg9qJOS57fxnIByb6rTyD0IPpEQsSgX7db7ykCZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(2906002)(44832011)(86362001)(7416002)(426003)(336012)(5660300002)(41300700001)(36756003)(8936002)(6666004)(4326008)(316002)(110136005)(40460700003)(40480700001)(70586007)(70206006)(478600001)(26005)(8676002)(2616005)(186003)(81166007)(1076003)(356005)(54906003)(82310400005)(47076005)(83380400001)(921005)(36860700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:42.5048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb304d88-80e6-46a6-71e9-08db373fb8d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6720
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

