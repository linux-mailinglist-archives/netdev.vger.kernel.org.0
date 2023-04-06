Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8932C6D8FE8
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbjDFHAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbjDFHAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:00:43 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84247131;
        Thu,  6 Apr 2023 00:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPOzUmuFXmdBM01wJoRYZjd5tjVNNy8VplPkf09mNKddW+UKVV18ooqnCu2IlIrkU8IQINXHhyH6Nu6llG8Hoe6TJy2Lbi9ubmWUkFUenwmyfh34rr0XP54VxWTy2KkrQ4J3nkSZz5dF5jOm47lgijhSt5NtUg0j9EEh5qK/QZ3FeN5obub06KUVM2rSAd2hxTG0EHmQgj/i/DpxurvUZ65spOiWagZNutrL3GyfKqF6MvxcMBw+iwuPU7mKCra8KueAMmIY0BtcZsesMSg/bx98kBPhd+TjpeMKt/2xRWg4TxavA9Wkifctnuu2lMmjsC1xbHh0OdGKquas0j+Rjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNIGZUiJSd9jdLcRZ6CFzSHpmmkM2uQOLYgVvFmOo24=;
 b=kkcrH1f5Ahn3p9BzeKsGxI9B0Tcx1f734eTXkW0NgTE2brj8dfFZ3MdFm/l2vDWEvWRTIV5GIqv6ej284LgVdjzcOyTpcFL773Rn71qJLjD6b4R+6v4nFstDzrG5MCA1nGYbLO2pZhe73cmo2rK9E49sONuQ+RTfM0//MybGc3NEShImrhsHbJW/t7b9ZpUyw+zq8VChxuFwj7uKBseVWD3NRaf2Y1cqKQBH9JjEmaboBRb4X5B95zfqEi8BLNn4wLK90EzJg0nIBV9XE6FKfHEJNswxTfRXn8t2poF8iP+tD83BSRB19+8x2Khzei7sFFgT2ar3kMDZAmp1c8OkvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNIGZUiJSd9jdLcRZ6CFzSHpmmkM2uQOLYgVvFmOo24=;
 b=kBtesgFajsJ6OQY3N2GY5PdMGzTdqUZqEvM61KNu5FXKfBsWDWOEqtcJNMMS5fWKqp8/PMxmAeKNZx2DXwxNC5Dk19Ga6wSx7vGOI0jYTlhUCBJSTU6U88I0tF77WwzMqz4/OveQGYrJurx45D1K95ggkQAQGUDTS0lknpueNQ0=
Received: from MW4PR04CA0168.namprd04.prod.outlook.com (2603:10b6:303:85::23)
 by BL1PR12MB5900.namprd12.prod.outlook.com (2603:10b6:208:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Thu, 6 Apr
 2023 07:00:32 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::e5) by MW4PR04CA0168.outlook.office365.com
 (2603:10b6:303:85::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 07:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 07:00:31 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:00:28 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 00:00:28 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:00:24 -0500
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
Subject: [PATCH net-next v3 02/14] sfc: implement MCDI interface for vDPA operations
Date:   Thu, 6 Apr 2023 12:26:47 +0530
Message-ID: <20230406065706.59664-3-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|BL1PR12MB5900:EE_
X-MS-Office365-Filtering-Correlation-Id: 6766bbdb-f7c6-4de6-b4d8-08db366c9cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pesvT5uMycGGZi0paxFufzMourgOJ7w9Cu+TFwbUSBeUxulDLwkOn/9iIyoP9GC9BK+2tqvkI60ulOk7CFTsSjxldH9Vst1CMUyH5702Exmo6JlDwcL+GpnD2fu6fp9RIpm3vJTQV6LWBb9yswUqPdHzq1172FuAlBAuvoQAB3Q4a5ZnIwn2cVUlch0Dhzro0gNyH9NW1bKrweRtQ1CwnLTvtMmIvsj4pZGURutqNV4zqJNXu9yrfqDCqQY5Ni23vg89mbMCwGukaJUP2Lr3Tr1DAfWn0WVbR5wH+C7gQ4QsV+Rt+Y83tgOBoRK6WnAFry2MZqp9xUBgNowVNMW9WAYRXFEEmgfY7a6ka+C7y/KVsEyLruRErh9luDi8CzwTWovD3KoQZdJ3U+2NNq9GBPAV5FiRKbik0g1/uktWHK6KC6ePIWe7Q39Km2r38ffd9BrDIpkI1poSpfbF5oXx9i2l9Z5hfWkAmCi3iyT7nD60n5ShS5Pj+Lpo/uXWIigAr5Sn3DeKc8Vuj03xGUT+22eZgiGXgUiOn4+0ADUQdGdYq0eZoYB9VC2zzj1CFR8v3H5cUogWwiWs3q+7HosccYvCXhYvopBIm8RYgGA6DnIyfLkTdb7Xk4z4QZ+eF10gnzFifig07RoCUD/cmFGNRczloWo6foNNiGAzuMKgejaZm6z1H7nmu7PVEByJ6+ni+DiiWnJBuxZ5uc/FDgZ5bHn8CZv0j7VGkrOu8kf7T+XHWZg+CPl/JZPhN7/DzkSc1fo/aBQFU+wnRMNnrFi7NQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(4326008)(8676002)(70586007)(70206006)(316002)(81166007)(41300700001)(110136005)(478600001)(54906003)(8936002)(30864003)(44832011)(7416002)(5660300002)(356005)(82740400003)(921005)(36860700001)(47076005)(83380400001)(426003)(6666004)(186003)(2616005)(336012)(1076003)(26005)(86362001)(82310400005)(36756003)(2906002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:00:31.9538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6766bbdb-f7c6-4de6-b4d8-08db366c9cfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5900
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement functions to perform vDPA operations like creating and
removing virtqueues, getting doorbell register offset etc. using
the MCDI interface with FW.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/Kconfig      |   8 +
 drivers/net/ethernet/sfc/Makefile     |   1 +
 drivers/net/ethernet/sfc/ef100_vdpa.h |  31 +++
 drivers/net/ethernet/sfc/mcdi.h       |   8 +-
 drivers/net/ethernet/sfc/mcdi_vdpa.c  | 259 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_vdpa.h  |  83 +++++++++
 6 files changed, 389 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 4af36ba8906b..0b5091e26cd1 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -64,6 +64,14 @@ config SFC_MCDI_LOGGING
 	  Driver-Interface) commands and responses, allowing debugging of
 	  driver/firmware interaction.  The tracing is actually enabled by
 	  a sysfs file 'mcdi_logging' under the PCI device.
+config SFC_VDPA
+	bool "Solarflare EF100-family VDPA support"
+	depends on SFC && VDPA && SFC_SRIOV
+	default y
+	help
+	  This enables support for the virtio data path acceleration (vDPA).
+	  vDPA device's datapath complies with the virtio specification,
+	  but control path is vendor specific.
 
 source "drivers/net/ethernet/sfc/falcon/Kconfig"
 source "drivers/net/ethernet/sfc/siena/Kconfig"
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 55b9c73cd8ef..fb94fe3a9dfc 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -12,6 +12,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
new file mode 100644
index 000000000000..90062fd8a25d
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef __EF100_VDPA_H__
+#define __EF100_VDPA_H__
+
+#include <linux/vdpa.h>
+#include <uapi/linux/virtio_net.h>
+#include "net_driver.h"
+#include "ef100_nic.h"
+
+#if defined(CONFIG_SFC_VDPA)
+
+enum ef100_vdpa_device_type {
+	EF100_VDPA_DEVICE_TYPE_NET,
+};
+
+enum ef100_vdpa_vq_type {
+	EF100_VDPA_VQ_TYPE_NET_RXQ,
+	EF100_VDPA_VQ_TYPE_NET_TXQ,
+	EF100_VDPA_VQ_NTYPES
+};
+
+#endif /* CONFIG_SFC_VDPA */
+#endif /* __EF100_VDPA_H__ */
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 454e9d51a4c2..303c4fe0bd64 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -1,7 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
- * Copyright 2008-2013 Solarflare Communications Inc.
+ * Copyright 2008-2018 Solarflare Communications Inc.
+ * Copyright 2019-2022 Xilinx Inc.
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  */
 
 #ifndef EFX_MCDI_H
@@ -214,6 +216,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define _MCDI_STRUCT_DWORD(_buf, _field)				\
 	((_buf) + (_MCDI_CHECK_ALIGN(_field ## _OFST, 4) >> 2))
 
+#define MCDI_SET_BYTE(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 1);			\
+	*(u8 *)MCDI_PTR(_buf, _field) = _value;				\
+	} while (0)
 #define MCDI_STRUCT_SET_BYTE(_buf, _field, _value) do {			\
 	BUILD_BUG_ON(_field ## _LEN != 1);				\
 	*(u8 *)MCDI_STRUCT_PTR(_buf, _field) = _value;			\
diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.c b/drivers/net/ethernet/sfc/mcdi_vdpa.c
new file mode 100644
index 000000000000..02ea0ace09ab
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_vdpa.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include <linux/vdpa.h>
+#include "ef100_vdpa.h"
+#include "efx.h"
+#include "nic.h"
+#include "mcdi_vdpa.h"
+#include "mcdi_pcol.h"
+
+/* The value of target_vf in virtio MC commands like
+ * virtqueue create, delete and get doorbell offset should
+ * contain the VF index when the calling function is a PF
+ * and VF_NULL (0xFFFF) otherwise. As the vDPA driver invokes
+ * MC commands in context of the VF, it uses VF_NULL.
+ */
+#define MC_CMD_VIRTIO_TARGET_VF_NULL 0xFFFF
+
+struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx,  u32 vi,
+					  enum ef100_vdpa_vq_type vring_type)
+{
+	struct efx_vring_ctx *vring_ctx;
+	u32 queue_cmd;
+
+	vring_ctx = kzalloc(sizeof(*vring_ctx), GFP_KERNEL);
+	if (!vring_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	switch (vring_type) {
+	case EF100_VDPA_VQ_TYPE_NET_RXQ:
+		queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ;
+		break;
+	case EF100_VDPA_VQ_TYPE_NET_TXQ:
+		queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ;
+		break;
+	default:
+		pci_err(efx->pci_dev,
+			"%s: Invalid Queue type %u\n", __func__, vring_type);
+		kfree(vring_ctx);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	vring_ctx->efx = efx;
+	vring_ctx->vf_index = MC_CMD_VIRTIO_TARGET_VF_NULL;
+	vring_ctx->vi_index = vi;
+	vring_ctx->mcdi_vring_type = queue_cmd;
+	return vring_ctx;
+}
+
+void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx)
+{
+	kfree(vring_ctx);
+}
+
+int efx_vdpa_get_features(struct efx_nic *efx,
+			  enum ef100_vdpa_device_type type,
+			  u64 *features)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_FEATURES_IN_LEN);
+	u32 high_val, low_val;
+	ssize_t outlen;
+	int rc;
+
+	if (!efx) {
+		pci_err(efx->pci_dev, "%s: Invalid NIC pointer\n", __func__);
+		return -EINVAL;
+	}
+	if (type != EF100_VDPA_DEVICE_TYPE_NET) {
+		pci_err(efx->pci_dev,
+			"%s: Device type %d not supported\n", __func__, type);
+		return -EINVAL;
+	}
+	MCDI_SET_DWORD(inbuf, VIRTIO_GET_FEATURES_IN_DEVICE_ID,
+		       MC_CMD_VIRTIO_GET_FEATURES_IN_NET);
+	rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_FEATURES, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN)
+		return -EIO;
+	low_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_LO);
+	high_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_HI);
+	*features = ((u64)high_val << 32) | low_val;
+	return 0;
+}
+
+int efx_vdpa_verify_features(struct efx_nic *efx,
+			     enum ef100_vdpa_device_type type, u64 features)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_TEST_FEATURES_IN_LEN);
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_VIRTIO_TEST_FEATURES_OUT_LEN != 0);
+	if (type != EF100_VDPA_DEVICE_TYPE_NET) {
+		pci_err(efx->pci_dev,
+			"%s: Device type %d not supported\n", __func__, type);
+		return -EINVAL;
+	}
+	MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_DEVICE_ID,
+		       MC_CMD_VIRTIO_GET_FEATURES_IN_NET);
+	MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_LO, features);
+	MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_HI,
+		       features >> 32);
+	rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_TEST_FEATURES, inbuf,
+			  sizeof(inbuf), NULL, 0, NULL);
+	return rc;
+}
+
+int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
+			  struct efx_vring_cfg *vring_cfg,
+			  struct efx_vring_dyn_cfg *vring_dyn_cfg)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_INIT_QUEUE_REQ_LEN);
+	struct efx_nic *efx = vring_ctx->efx;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_VIRTIO_INIT_QUEUE_RESP_LEN != 0);
+
+	MCDI_SET_BYTE(inbuf, VIRTIO_INIT_QUEUE_REQ_QUEUE_TYPE,
+		      vring_ctx->mcdi_vring_type);
+	MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
+		      vring_ctx->vf_index);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
+		       vring_ctx->vi_index);
+
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_SIZE, vring_cfg->size);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_LO,
+		       vring_cfg->desc);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_HI,
+		       vring_cfg->desc >> 32);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_LO,
+		       vring_cfg->avail);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_HI,
+		       vring_cfg->avail >> 32);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_LO,
+		       vring_cfg->used);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_HI,
+		       vring_cfg->used >> 32);
+	MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MSIX_VECTOR,
+		      vring_cfg->msix_vector);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_LO,
+		       vring_cfg->features);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_HI,
+		       vring_cfg->features >> 32);
+
+	if (vring_dyn_cfg) {
+		MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_PIDX,
+			       vring_dyn_cfg->avail_idx);
+		MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_CIDX,
+			       vring_dyn_cfg->used_idx);
+	}
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MPORT_SELECTOR,
+		       MAE_MPORT_SELECTOR_ASSIGNED);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_INIT_QUEUE, inbuf, sizeof(inbuf),
+			  NULL, 0, NULL);
+	return rc;
+}
+
+int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
+			   struct efx_vring_dyn_cfg *vring_dyn_cfg)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_FINI_QUEUE_REQ_LEN);
+	struct efx_nic *efx = vring_ctx->efx;
+	ssize_t outlen;
+	int rc;
+
+	MCDI_SET_BYTE(inbuf, VIRTIO_FINI_QUEUE_REQ_QUEUE_TYPE,
+		      vring_ctx->mcdi_vring_type);
+	MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
+		      vring_ctx->vf_index);
+	MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
+		       vring_ctx->vi_index);
+	rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_FINI_QUEUE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN)
+		return -EIO;
+
+	if (vring_dyn_cfg) {
+		vring_dyn_cfg->avail_idx = MCDI_DWORD(outbuf,
+						      VIRTIO_FINI_QUEUE_RESP_FINAL_PIDX);
+		vring_dyn_cfg->used_idx = MCDI_DWORD(outbuf,
+						     VIRTIO_FINI_QUEUE_RESP_FINAL_CIDX);
+	}
+
+	return 0;
+}
+
+int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
+				 u32 *offset)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_LEN);
+	struct efx_nic *efx = vring_ctx->efx;
+	ssize_t outlen;
+	int rc;
+
+	if (vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ &&
+	    vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ) {
+		pci_err(efx->pci_dev,
+			"%s: Invalid Queue type %u\n",
+			__func__, vring_ctx->mcdi_vring_type);
+		return -EINVAL;
+	}
+
+	MCDI_SET_BYTE(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_DEVICE_ID,
+		      MC_CMD_VIRTIO_GET_FEATURES_IN_NET);
+	MCDI_SET_WORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_TARGET_VF,
+		      vring_ctx->vf_index);
+	MCDI_SET_DWORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_INSTANCE,
+		       vring_ctx->vi_index);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN)
+		return -EIO;
+	if (vring_ctx->mcdi_vring_type == MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ)
+		*offset = MCDI_DWORD(outbuf,
+				     VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_RX_DBL_OFFSET);
+	else
+		*offset = MCDI_DWORD(outbuf,
+				     VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_TX_DBL_OFFSET);
+
+	return 0;
+}
+
+int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_SET_MAC_V2_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MAC_EXT_IN_LEN);
+	ssize_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, SET_MAC_EXT_IN_CONTROL, 0);
+	rc =  efx_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_SET_MAC_V2_OUT_LEN)
+		return -EIO;
+
+	*mtu = MCDI_DWORD(outbuf, SET_MAC_V2_OUT_MTU);
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.h b/drivers/net/ethernet/sfc/mcdi_vdpa.h
new file mode 100644
index 000000000000..d2bb0152d9c3
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_vdpa.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_MCDI_VDPA_H
+#define EFX_MCDI_VDPA_H
+
+#if defined(CONFIG_SFC_VDPA)
+#include "mcdi.h"
+
+/**
+ * struct efx_vring_ctx: The vring context
+ *
+ * @efx: pointer of the VF's efx_nic object
+ * @vf_index: VF index of the vDPA VF
+ * @vi_index: vi index to be used for queue creation
+ * @mcdi_vring_type: corresponding MCDI vring type
+ */
+struct efx_vring_ctx {
+	struct efx_nic *efx;
+	u32 vf_index;
+	u32 vi_index;
+	u32 mcdi_vring_type;
+};
+
+/**
+ * struct efx_vring_cfg: Configuration for vring creation
+ *
+ * @desc: Descriptor area address of the vring
+ * @avail: Available area address of the vring
+ * @used: Device area address of the vring
+ * @size: Queue size, in entries. Must be a power of two
+ * @msix_vector: msix vector address for the queue
+ * @features: negotiated feature bits
+ */
+struct efx_vring_cfg {
+	u64 desc;
+	u64 avail;
+	u64 used;
+	u32 size;
+	u16 msix_vector;
+	u64 features;
+};
+
+/**
+ * struct efx_vring_dyn_cfg - dynamic vring configuration
+ *
+ * @avail_idx: last available index of the vring
+ * @used_idx: last used index of the vring
+ */
+struct efx_vring_dyn_cfg {
+	u32 avail_idx;
+	u32 used_idx;
+};
+
+int efx_vdpa_get_features(struct efx_nic *efx, enum ef100_vdpa_device_type type,
+			  u64 *featuresp);
+
+int efx_vdpa_verify_features(struct efx_nic *efx,
+			     enum ef100_vdpa_device_type type, u64 features);
+
+struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx, u32 vi,
+					  enum ef100_vdpa_vq_type vring_type);
+
+void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx);
+
+int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
+			  struct efx_vring_cfg *vring_cfg,
+			  struct efx_vring_dyn_cfg *vring_dyn_cfg);
+
+int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
+			   struct efx_vring_dyn_cfg *vring_dyn_cfg);
+
+int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
+				 u32 *offsetp);
+int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu);
+#endif
+#endif
-- 
2.30.1

