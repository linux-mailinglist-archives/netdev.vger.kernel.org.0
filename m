Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CB2645D0F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLGO6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiLGO6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:58:25 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062314EC07;
        Wed,  7 Dec 2022 06:57:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggw8Cwa4M+o8lMdZg2qKcIAn5KVK5wBku8037Ur+MW4hnvoINfvVUVM+azlQLeMmLGqVu7FpuRZRR1lepGS+GSgJR0jTaER9FnNAchknA6oMkHQNuyABAwOgdPf3OhIo7ktx07iysYX5aFR5/2NmwD7c5wRQc80Plpi33RUPLI3m6RrZ9pznbKIxGLZP40lQAk7ZIYv6Y+1x/nHWXuZ+UA1brf2q3BUtWmxHeANfN7KvFSbOMH0DZyo+2ptpDtrN02E2VfavGzfDs//D6l80Uwu1oiAQB5hYjevNTWs7T/CfbPLVcg5rKK0dGtorXwSzLoWtWZOhRhl3yA/RHknpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wN4JvbxJUxprc40JNbIgPFAwATrQ47v54hKmeJapnNI=;
 b=ftrxIdBIEtuXDvWiMhvJg52wl3bhb4vpYOMVHMuhNXUu1Jp7EMXpXQBDP5g3RXRieuAtwbxmUkTxC2dHUv050La9PvlEAOoPiMHSjMjvaO+ETqBThEYaHiyWwZctvpHKR/TuG9cExoPuO2tWek0FQP07i+U15DHyWz87Rl46geykmC5IfiV7vehhMD1iXbX1p7Q0Lao7Lx6UO+3WL6Nv+h9UoxwmxKDo28RqpdxPFhPQE5KrI9eXboApmiLWKqgyxYsIZ/DV1pv692QVIwCJ/xykAGd9TOqMqE0/pnjAxVfe+oy//nBuXp+9TC6QGYbgIz6xypRLb2Z6pbu/LJyE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wN4JvbxJUxprc40JNbIgPFAwATrQ47v54hKmeJapnNI=;
 b=gsubCZ6mQU8pG73WYfxzdX4hAgBWqZ3T3g5riO6/FLzZcB5rs2gTka+Kh7pCAhO/fgm0kB6/4Y2kHdCpR4kTujoT3W6furkrZCf/gcDq0yFYaf4r1dOQ/Ti8ysXRscDtlZSUpyFlarEfjpUWytCmIYQS8+bhykcgekr/mcPx1KI=
Received: from DS7PR05CA0028.namprd05.prod.outlook.com (2603:10b6:5:3b9::33)
 by BN9PR12MB5383.namprd12.prod.outlook.com (2603:10b6:408:104::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:57:26 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:3b9:cafe::13) by DS7PR05CA0028.outlook.office365.com
 (2603:10b6:5:3b9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Wed, 7 Dec 2022 14:57:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:57:25 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:57:21 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 06:56:52 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:48 -0600
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
Subject: [PATCH net-next 08/11] sfc: implement device status related vdpa config operations
Date:   Wed, 7 Dec 2022 20:24:24 +0530
Message-ID: <20221207145428.31544-9-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|BN9PR12MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 051276fa-6fb3-4102-b023-08dad8635a91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9S7GfRO1F21F1Xrm+NPQQ6SBp+dLnRiv0K6rLVOAu/kGecCq4qmfPo1vpogz+vIlaahrKdTuIhtUX1S0w4/M10pLNLSjHbLlXy2K0/thtfoXeBHSdEXRvFy46bL1CKbAFznUtxuPRl5hd+4iQLlngKwGNrfuJYmhW4/ID9DQOsM24TiNMR1i4PuCGKa1wiiLd+d3DZ8/7kbxqKDvCGOYpDWvgzxzFlCwh1dAvQfBwnOm08ZtBhTPnPDKIpNZzGl7r+LOTLpyMNk2Tv6udPEbN2iJ3cYNygUuW2a6YOPU2ahLzpaJSxmhlikkqcqABzWaGcyuyroOSQEUMtClPM5lxxgtyqJOQ3SVmpcLKTw2vTNrKyCXsjYnrSGTzehwN1aA9SnD0PIIaHG2bgHEk+iSgmytRMix3e2EUAQyRZWS36L7QtF4YP1WdQkZmeS8qLg/w83FR1YXky/dx2M9oPeDm5sFPnYA1JWLymllktaHqXL0mjve6XcKiIv3D9fJl/WarEgECd8GZyeHbmTXELi8FjbCXygFtIsm+V72qHkyCBklEiIK20rqlx8yLGVnVbngWx97zGrJ7IeO3aoxJ5KXyp3sM9VmUfxzBplKAOHIJxrLfRDBzPM1bG8NEiGvfF9eRfhVJj9To/aYD8OVvaT3RQ2iqd4WdeX7wDPNSuoRHl60BXajHcewbtYALiqQN2Wbwl+1o/J+aclltuWjCGJqRkzOSynVu6Y2wB5Qj0AWls=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(81166007)(8936002)(356005)(86362001)(44832011)(40460700003)(4326008)(41300700001)(2906002)(5660300002)(7416002)(36860700001)(83380400001)(70206006)(54906003)(110136005)(316002)(70586007)(8676002)(2616005)(82740400003)(40480700001)(82310400005)(478600001)(186003)(426003)(6666004)(47076005)(26005)(336012)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:57:25.8425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 051276fa-6fb3-4102-b023-08dad8635a91
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5383
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA config opertions to handle get/set device status and device
reset have been implemented.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
 drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 04d64bfe3c93..80bca281a748 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
 
 static void ef100_vdpa_delete(struct efx_nic *efx)
 {
+	struct vdpa_device *vdpa_dev;
+
 	if (efx->vdpa_nic) {
+		vdpa_dev = &efx->vdpa_nic->vdpa_dev;
+		ef100_vdpa_reset(vdpa_dev);
+
 		/* replace with _vdpa_unregister_device later */
-		put_device(&efx->vdpa_nic->vdpa_dev.dev);
+		put_device(&vdpa_dev->dev);
 		efx->vdpa_nic = NULL;
 	}
 	efx_mcdi_free_vis(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index a33edd6dda12..1b0bbba88154 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
 			  enum ef100_vdpa_mac_filter_type type);
 int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
 void ef100_vdpa_irq_vectors_free(void *data);
+int ef100_vdpa_reset(struct vdpa_device *vdev);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 132ddb4a647b..718b67f6da90 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
 	return false;
 }
 
+static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
+{
+	int i;
+
+	WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
+
+	if (!vdpa_nic->status)
+		return;
+
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
+	vdpa_nic->status = 0;
+	vdpa_nic->features = 0;
+	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
+		reset_vring(vdpa_nic, i);
+}
+
+/* May be called under the rtnl lock */
+int ef100_vdpa_reset(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	/* vdpa device can be deleted anytime but the bar_config
+	 * could still be vdpa and hence efx->state would be STATE_VDPA.
+	 * Accordingly, ensure vdpa device exists before reset handling
+	 */
+	if (!vdpa_nic)
+		return -ENODEV;
+
+	mutex_lock(&vdpa_nic->lock);
+	ef100_reset_vdpa_device(vdpa_nic);
+	mutex_unlock(&vdpa_nic->lock);
+	return 0;
+}
+
+static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
+{
+	int rc = 0;
+	int i, j;
+
+	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
+		if (can_create_vring(vdpa_nic, i)) {
+			rc = create_vring(vdpa_nic, i);
+			if (rc)
+				goto clear_vring;
+		}
+	}
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
+	return rc;
+
+clear_vring:
+	for (j = 0; j < i; j++)
+		if (vdpa_nic->vring[j].vring_created)
+			delete_vring(vdpa_nic, j);
+	return rc;
+}
+
 static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
 				     u16 idx, u64 desc_area, u64 driver_area,
 				     u64 device_area)
@@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
 	return EF100_VDPA_VENDOR_ID;
 }
 
+static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u8 status;
+
+	mutex_lock(&vdpa_nic->lock);
+	status = vdpa_nic->status;
+	mutex_unlock(&vdpa_nic->lock);
+	return status;
+}
+
+static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u8 new_status;
+	int rc;
+
+	mutex_lock(&vdpa_nic->lock);
+	if (!status) {
+		dev_info(&vdev->dev,
+			 "%s: Status received is 0. Device reset being done\n",
+			 __func__);
+		ef100_reset_vdpa_device(vdpa_nic);
+		goto unlock_return;
+	}
+	new_status = status & ~vdpa_nic->status;
+	if (new_status == 0) {
+		dev_info(&vdev->dev,
+			 "%s: New status same as current status\n", __func__);
+		goto unlock_return;
+	}
+	if (new_status & VIRTIO_CONFIG_S_FAILED) {
+		ef100_reset_vdpa_device(vdpa_nic);
+		goto unlock_return;
+	}
+
+	if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
+	    vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
+		new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
+	}
+	if (new_status & VIRTIO_CONFIG_S_DRIVER &&
+	    vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
+		new_status &= ~VIRTIO_CONFIG_S_DRIVER;
+	}
+	if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
+	    vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
+		vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
+		new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
+	}
+	if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
+	    vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
+		rc = start_vdpa_device(vdpa_nic);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: vDPA device failed:%d\n", __func__, rc);
+			vdpa_nic->status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
+			goto unlock_return;
+		}
+		new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
+	}
+	if (new_status) {
+		dev_warn(&vdev->dev,
+			 "%s: Mismatch Status: %x & State: %u\n",
+			 __func__, new_status, vdpa_nic->vdpa_state);
+	}
+
+unlock_return:
+	mutex_unlock(&vdpa_nic->lock);
+}
+
 static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
 {
 	return sizeof(struct virtio_net_config);
@@ -640,6 +770,9 @@ const struct vdpa_config_ops ef100_vdpa_config_ops = {
 	.get_vq_num_max      = ef100_vdpa_get_vq_num_max,
 	.get_device_id	     = ef100_vdpa_get_device_id,
 	.get_vendor_id	     = ef100_vdpa_get_vendor_id,
+	.get_status	     = ef100_vdpa_get_status,
+	.set_status	     = ef100_vdpa_set_status,
+	.reset               = ef100_vdpa_reset,
 	.get_config_size     = ef100_vdpa_get_config_size,
 	.get_config	     = ef100_vdpa_get_config,
 	.set_config	     = ef100_vdpa_set_config,
-- 
2.30.1

