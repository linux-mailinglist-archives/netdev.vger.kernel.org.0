Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB3E645CF9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLGO4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLGO41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38604EC07;
        Wed,  7 Dec 2022 06:56:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlidqjaSyxSF1typPv8jWBqwZ+Z3aB/zebQ3Ody3kN+Xh7HnUaJZVuRFc4dG7cOxYLM8J8udlrVEwZrG0U1lcZpPzvVSSIm/FCzdjSredSlubltRHJyrlwN6g0mTNalggwMkuMnqz56P8Hru7Ed2MWNgIEEMWOuhZ3vd8EUd3DUZxXCrz6cyxb72A1BKKVN1G08Y0SKrq8jUQEI/dx33PZfXMlloAfQHMCF80k6lpU15kptQyIJTKn84RcwXI9CwOYy5fPYCeo6ziRcnBpnlULwd/Nt4YsoPinZHmOMAHqrbhHMtLUVVIR2gXshlyJ9JpvUjPaHSi9Vc4PrFk2vwIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOwLPd+tFDdjCuwgWdqCxhhxoquBZBiYqWk+L4xVZLk=;
 b=Z374D/wFivFjUPKaWOXkKFrF4KjXuuc/iEm+ohSmv9PJ3WE35Kx5b2Q1MnTy5FzxGss0JDxQ7AiE9mlswy8x7lYjoraGebHx2NqS8iHdEsXaeMaqXXGoWFwSq+WhkO8vOuaZ/ktLNqyZtwlHJxxgJv/zJpKEpcev/4oN/UO+4uAKrsiWuuqii8w25voBRkOjHPlY2ZVt2a09sQBqNtiOzWALDkh/8zaObHnGUSdZl9Imv6Hz3yOdlWhdmFHvPOcOfGkq4heGRl93hHhnE8p/O6AT/7fOWFtOKgDCS/aP1LF4NFUrYY0rBjle2LQzf+0kk7asN/3G3TUHZloDnd7aww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOwLPd+tFDdjCuwgWdqCxhhxoquBZBiYqWk+L4xVZLk=;
 b=yYHNs4pPvv/oNuM9eCPtIhMAh9hBwZBoy+ke5zW6xT1RGr1V8M+Y2Mea3gNI5bOsicbTmFxfO9sG2KrskFLB6XDJWWGjzp2tiB1JEQJuHHc/RYc6pOd+BlIg/+8FhVrI1W/qIYpI6GKQU8FnZyTsVwdOPY5WQR1iTOKRZdsZk+4=
Received: from DM6PR08CA0011.namprd08.prod.outlook.com (2603:10b6:5:80::24) by
 IA1PR12MB6385.namprd12.prod.outlook.com (2603:10b6:208:38b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 14:56:23 +0000
Received: from DS1PEPF0000E655.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::97) by DM6PR08CA0011.outlook.office365.com
 (2603:10b6:5:80::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E655.mail.protection.outlook.com (10.167.18.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:22 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:18 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:17 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:14 -0600
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
Subject: [PATCH net-next 02/11] sfc: implement MCDI interface for vDPA operations
Date:   Wed, 7 Dec 2022 20:24:18 +0530
Message-ID: <20221207145428.31544-3-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E655:EE_|IA1PR12MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: c98b2e81-f70d-4753-e8a4-08dad863350f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nO23ARL8flD963piRJncYHbvTchYomWNDfeHXX9zYhXEWbiqBCLjbuyF2DRf23Uy6Pcc5uq0+o6AuK64wBUdOGl8ztY2n2VJAxSu7wrB0xKmK5ia7OFX70qwVLlP+DWtWWRccwOsUPGjIGz+lAzwGnBGfillbBfM0cKrq2G3Z+ZDUZ+3BDkAoq03HF3e4eNZMrB1fM4U0qoqkKZuE/RBswmQ3oTm1VNIvURemJSVKNcaBxqbal4pknykgkCv1SuzcSrVfF3TddeFtLhRrnXTQEoaHKpXsZ1a6xbfn11u6RU4mv9FzYzqKLUcX5d9vgK8knX9mVrTUv/ZnpHS9ykOUYozF9IiatGg8zH2jir4tGjdpSi6v12sKVG+QfgMMPpuLyY8NEBlH0C4PSIm8YeROuOIGtJqKbYf4ZcozmMCYbQegmjHULtZsQ+gBqWWOpr0VduCIkgYEXcsqa2xQv1AIdEYMR8cz93yvQeOAXdldsasjPnC6iaaO86vlwFG4ZPh+F519wgPAvGJOJMSYzZ71IJOU3MhRsD08NWrwARMLs+Lgt3yrc7mx/4HDFUhFlLrQht8xkckMpD1Z3ja/KGBQ+jjrpGjP9IVno6aRoANolVmqFXY3LQ853lB8GapHRZcwA5pF3ONwPP38Fc7ueAPPOCSV9UL5gwc5IL5oOo8n/qXP/2dS3m20w8vm6s8/5AwNT4l4Nmjeak3fgVRPnsGAAluf/Ai5Evhum0AEUeDCnrghkdmsSy4DdtwLfKjoNm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(7416002)(82740400003)(86362001)(81166007)(356005)(5660300002)(8936002)(8676002)(4326008)(2906002)(40460700003)(44832011)(83380400001)(36860700001)(30864003)(478600001)(70206006)(70586007)(316002)(2616005)(110136005)(54906003)(40480700001)(82310400005)(41300700001)(1076003)(336012)(47076005)(426003)(26005)(186003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:22.9162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c98b2e81-f70d-4753-e8a4-08dad863350f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E655.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
 drivers/net/ethernet/sfc/ef100_vdpa.h |  32 +++
 drivers/net/ethernet/sfc/mcdi.h       |   4 +
 drivers/net/ethernet/sfc/mcdi_vdpa.c  | 268 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_vdpa.h  |  84 ++++++++
 6 files changed, 397 insertions(+)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 0950e6b0508f..1fa626c87d36 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -63,6 +63,14 @@ config SFC_MCDI_LOGGING
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
index 712a48d00069..059a0944e89a 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -11,6 +11,7 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
new file mode 100644
index 000000000000..f6564448d0c7
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for Xilinx network controllers and boards
+ * Copyright (C) 2020-2022, Xilinx, Inc.
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
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
index 7e35fec9da35..db4ca4975ada 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -214,6 +214,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
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
index 000000000000..35f822170049
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_vdpa.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for Xilinx network controllers and boards
+ * Copyright (C) 2020-2022, Xilinx, Inc.
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
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
+	u32 dev_type;
+	int rc;
+
+	if (!efx) {
+		pci_err(efx->pci_dev, "%s: Invalid NIC pointer\n", __func__);
+		return -EINVAL;
+	}
+	switch (type) {
+	case EF100_VDPA_DEVICE_TYPE_NET:
+		dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
+		break;
+	default:
+		pci_err(efx->pci_dev,
+			"%s: Device type %d not supported\n", __func__, type);
+		return -EINVAL;
+	}
+	MCDI_SET_DWORD(inbuf, VIRTIO_GET_FEATURES_IN_DEVICE_ID, dev_type);
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
+	u32 dev_type;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_VIRTIO_TEST_FEATURES_OUT_LEN != 0);
+	switch (type) {
+	case EF100_VDPA_DEVICE_TYPE_NET:
+		dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
+		break;
+	default:
+		pci_err(efx->pci_dev,
+			"%s: Device type %d not supported\n", __func__, type);
+		return -EINVAL;
+	}
+	MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_DEVICE_ID, dev_type);
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
index 000000000000..2a0f7c647c44
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_vdpa.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for Xilinx network controllers and boards
+ * Copyright (C) 2020-2022, Xilinx, Inc.
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
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

