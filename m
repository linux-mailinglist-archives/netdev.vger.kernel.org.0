Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0A6D9004
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbjDFHCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbjDFHCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:02:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF171AF20;
        Thu,  6 Apr 2023 00:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlZvGeEDej40bhcUMtlOE9Rqb2zblC2He+PctfErvYJiwic4N2aDeGOFNz2FakvkTnFqmI1teiVy/4fkfwRW8fhuksUzcLwOfn1aH1O7lqkylKFzArsuVRWPPGPb0nPRHdvfxwcuqwhwZOdtIeRZJyUfibneK8Q49t0qRMNZi3tu3CkguU1UrbvWmE860BH/5HXWImrCzqS2B6+2DoB+mKLWwQI5IynBMv2N85utZrZ0XEbUsRQr5/vK5UJ/fWGVNNqtOWmnQFCKL2PNcMmvGXerFzrnxQzBycYhX0x7G1gGekQK8mWdaO2GyqLMVYMysSqRhrxGk6K3SvDDLRSZtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=jq10+36StT6igfR7gtvTZfGn2lsd6jD5kCjP79hW6bTRaxOE8TikVqM3JbJ6oFQIllXfS9W/Exn9Oeo+/xzFhZ76iOhj4jk1c/d6qIY8DcMFGp8WxaUikiQuf9uZxt2Kep3LowowcOORTW8CDwDt2/NiV/9SS9BwVvoYxHhs4VYgeD20czT52T9m7qItAJPuPJYwHovACCLvkEaXwhcmHSqfgcZNXNcw4N99+NILerL18M5Ct/pXv29izoUrGS9qCkW4L3zgvRB0R54S/HMJsHxDwpOOWFHrQMnrA+TP+XF7d4S2/huCQanQnhXP4UWPc6TAjMmQzWfOH6A3pOxgLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTHrJcWyKW0JsVIbpowMS5Q9dKG/2L4BT1frpWgaHA8=;
 b=xZa3gkaviIdKqv7zHZyEZZAUjc8DILGVoEPjbZ1f8xKRDfMRST92WP48qPdhKPFLTHOIQt1Yx29D39lodeGksKA0zKGlaYzVAatz+QI5syN3sSOKgxAVMGGDtzIvgSh9uhcrnpjHAEzFfhFILFD2Ug+FVn7RyrvdDaky13zCKAc=
Received: from MW4PR04CA0235.namprd04.prod.outlook.com (2603:10b6:303:87::30)
 by DS7PR12MB5864.namprd12.prod.outlook.com (2603:10b6:8:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 07:01:24 +0000
Received: from CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::f9) by MW4PR04CA0235.outlook.office365.com
 (2603:10b6:303:87::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30 via Frontend
 Transport; Thu, 6 Apr 2023 07:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT109.mail.protection.outlook.com (10.13.174.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.30 via Frontend Transport; Thu, 6 Apr 2023 07:01:23 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:01:22 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:01:15 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:01:11 -0500
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
Subject: [PATCH net-next v3 07/14] sfc: implement vdpa device config operations
Date:   Thu, 6 Apr 2023 12:26:52 +0530
Message-ID: <20230406065706.59664-8-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT109:EE_|DS7PR12MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: ffdc3ca6-68b7-4dfa-59b1-08db366cbbfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+0egS3GG85mN+Msxxj2Ja1xxoxIBvGT/OIZiWvpJQ8wDBZUrazY70v+s4wzxiNSdcMjax9dbhBLCakQLxsWX5bJUTRfuBF7w2z1X/XlupMOuddGH2887YnaFo8MfznXQnBcXYAEdnwH2KNXShOSbJY4TiXzQJmHmaZs4o4iL8SXhcvontD/wSFe4ADMspLCcjq6LnJ49A8iU4OHK9eYIzGbe0E1daKqDiPY0CEZq5vbs6dyGyzZALom4P3iMDGxHfAp1Tpbson/X95DRiPEV+2y8vmmoynj72/YNXcfa2gl76VkGYVp3QFaK+3SKnKH57MzkrYhQb7hY4Rt2kMY1PFENTTp6of+M+fr4LToc2ydOz46nkfz8WMA/kqnJvNXFPR8VUmP10Zpcrch+TP552vfiWXuqcSvOUtRuk4+fHrdYTHPAE2e2KcjwPsponsnOOzryXcGzg+DX30D1ep+d6Vl3GmQfSag055r9ytmdrMDAg/qheQJn983Resa8bu++KW2bBe3FUfTVr1XLqOuDKiMZxJOEVc04BbcwEGUnbMpxQZZ0RKUEnRad1/cLNwxmm7rBwPt0gEjTVvLT9Q8ScZCzS64yYlhVEF3Z8UPYbncr51bOv/DxMpmSvRk+/HOKROWF/jG6YOjb6ij0vIjlcLN21DrUaSTcNmzuYFuCX0Y5VuEZ2OHAAN2uHq8m6l6s1tzho/3WDR6c2PHnZdqdlUTmWoD4kbElbJxEN8KkKnVtYHSJTcRY2mVZyrMIsj7
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(356005)(41300700001)(70586007)(70206006)(921005)(5660300002)(316002)(110136005)(44832011)(7416002)(81166007)(8936002)(8676002)(4326008)(54906003)(82740400003)(36860700001)(426003)(186003)(47076005)(336012)(6666004)(478600001)(1076003)(40460700003)(26005)(2616005)(86362001)(36756003)(82310400005)(2906002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:01:23.9961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffdc3ca6-68b7-4dfa-59b1-08db366cbbfd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5864
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

