Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21235578672
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiGRPdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiGRPc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:32:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48612667
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRx2VLkXyZcvxniILht8LZNHz5Phy9jQjGu6BQzbnSBWg7OrczYzA5112cq7uycMHAyaZdcyVGkmN7aaEE278If788mWuDYYzW9v0EOzW6+i6oA6B8Bdw5y1q8nkmnRkh+owkmD9bwnjNJIekFT2VYFBJi7MKkTtU5Vy71izQoV6MIW1bGZZrZsnKkPR1KEjr9fTF0V3Z2yQTGKCEE5FZYwJRthUsu3/Q/GxOVrqpyErhoyJtVOVkD9+sA643nl8Roj+6qPT03VMPYmr8iqRy/qCTHYPqeVcGFVvjr9Fu4Dj8W4a3Q/LEVjLf/H/1/Q+8qoTcWbTtblizPoLFEt0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0NAmz/Q8Du0IHDC+BeK9+dh+znfxRA5WQTiVuPlAFU=;
 b=PKdQLMUHp6w+hmio2jGk+0paH7KdptAV4bxGBEW3RanDawiZr6YuPOCViRTQc/6X8RyghzVm6BWmO99HuA7qHPG8f+GrRrVXGn7GlqkXZr22mY0PVfQfs07qwLA5V4i5ya5Ug4GPkPGlntn4j6vvxwoJ0SxUK7f78TssZpkgn9NqaWDeUqvgG2UNfVVfBs/tzGN7e86kXEsLVbG5ipTVbNSu9zBWR1HGoeHcacWj3L/cLMVBaidYKbk4ajuroYB0IgBroxwXY+a9acS0rm5MP8NzQio8PqyCySUiV2wal8GTK1x+TyBEAf6kEj2oIUAEWIh7Jgs2rAAGn+tWLfxh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0NAmz/Q8Du0IHDC+BeK9+dh+znfxRA5WQTiVuPlAFU=;
 b=sUzAcvLisKf0DvPDHsS/SR4nSfWqa+PIj7LRXmipYI8jWLcMk3UNRssl1cv//gvcje79NlpfZe3SOBQ/njuPw4+Ks3ZKlPvtYLNe/UAc4sASFt5dMpt8ezXS0cebsqsi0WXIhGuDyH2lwnK35kvSyOm+C5IY1Fo24cmO5fCBzgrfXyGJnS2nsqFVbCVDWirAtbry7fSM0NgzJXK5xHQh8TbUiFBfXvckpcHzOjBuNj+SUXDAQ4QIyIPvCsW3hFKo4bBiv6vVVG7EriqKSR2Oq+SKtum/qv+Oj9Dn5BIZOWxDhQHOmo60KOZ1pIb+u/ZUZu8evwawSG2S25BMp0zexw==
Received: from BN9PR03CA0217.namprd03.prod.outlook.com (2603:10b6:408:f8::12)
 by CY4PR12MB1495.namprd12.prod.outlook.com (2603:10b6:910:e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Mon, 18 Jul
 2022 15:32:53 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::df) by BN9PR03CA0217.outlook.office365.com
 (2603:10b6:408:f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:53 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:51 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:50 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 07/10] sfc: determine representee m-port for EF100 representors
Date:   Mon, 18 Jul 2022 16:30:13 +0100
Message-ID: <6d6b838b10653c7cd6583532c647f7e6d1c10715.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a21e615c-3578-45ea-f5e0-08da68d2c800
X-MS-TrafficTypeDiagnostic: CY4PR12MB1495:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x9ZPgorzbXNIqOLCK4oF92wkPrdjoaxUiLD3Tz/d3FBRtBNTFntNfDn6+Wyow1pp4HQFb5AGTH+uPyjdeq7ROFF7rDh/08ccBAbb+0VyyQFZe2cDzA6U+wad7EaQFsbKfd9Rbl4BMc85YmX+bMQyYMdCw6pLd6WNEO+XKaZxouymnRJJomIwLK317kyh2kOzBG9AUtVDVg4R/h9n8nSojQXYk7Cc8/MGgZMq2NWXoTz1AfX6h4bieQobkFC/MIDt+bjU+O5+5lAIxUyrbt1V4UkJDW//1ybkvTIZHWU0XQDpYqpcKoUQbltkYNsVWBz11Q3iZots3p9PsRZG3/t4L5yzZpAwiHKriE418nL0wZOeoCLmm+mK3eFuOOdyWhFze1Bd0DkQutrMWbieARoPypjVtKwyN1ITmQuX07r5xszPLB4qXvNxAMg1M8zq5OH5s4H+qcVO92NP5TkfFGKmRRszCvICMYZTun0V4pEqdvkngu3Qg+0E0N5pDXgwbnUc051QVDCuKkjcMvtv9mJqLb1aam70siEUpepeTkzrp6iwyXaebbWty+YS6TkFPkKEKaIaakYeXqOKM/hG68YL5nllmOXtmKLHABiEqKqJG7Yuo7FRoTOopQ8nZYLeEYGc0oxV/nYjVjSJ32O7/Vp3at0j4TfPSa4yHV+QzQwIs35W6W1vj31hsdTXLWhuZ1aUXM70GOK12tBQOwaxSVBbrWcB31WSapIMpFZKxNnW3ztmVWU5tX1Vn4C4b0Yt9egtiXTUNJXn6B047A0OTKiOYSBu/Xgi07eXkP2iLWkTnjMXYsMx/6wJjK2axljVuPTlCuBo982D3bnaSvzrzwgG1OrN5cYwtlwgcxYoL9+Mx/igfaBHkSgbEJUAT06uE2jr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(40470700004)(46966006)(356005)(40480700001)(47076005)(81166007)(8676002)(4326008)(82740400003)(5660300002)(70206006)(55446002)(83170400001)(336012)(8936002)(42882007)(83380400001)(478600001)(186003)(70586007)(54906003)(2876002)(6666004)(41300700001)(82310400005)(110136005)(9686003)(316002)(36860700001)(40460700003)(26005)(36756003)(2906002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:53.3492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a21e615c-3578-45ea-f5e0-08da68d2c800
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1495
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

An MAE port, or m-port, is a port (source/destination for traffic) on
 the Match-Action Engine (the internal switch on EF100).
Representors will use their representee's m-port for two purposes: as
 a destination override on TX from the representor, and as a source
 match in 'default rules' to steer representee traffic (when not
 matched by e.g. a TC flower rule) to representor RX via the parent
 PF's receive queue.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile    |  2 +-
 drivers/net/ethernet/sfc/ef100_rep.c | 27 +++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h |  2 ++
 drivers/net/ethernet/sfc/mae.c       | 44 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h       | 22 ++++++++++++++
 5 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/sfc/mae.c
 create mode 100644 drivers/net/ethernet/sfc/mae.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 7a6772bfde06..4c759488fc77 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -8,7 +8,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o
+sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o mae.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 0b4f7d536ae6..cf0eac920592 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -11,6 +11,7 @@
 
 #include "ef100_rep.h"
 #include "ef100_nic.h"
+#include "mae.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
@@ -124,6 +125,25 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 	return ERR_PTR(rc);
 }
 
+static int efx_ef100_configure_rep(struct efx_rep *efv)
+{
+	struct efx_nic *efx = efv->parent;
+	u32 selector;
+	int rc;
+
+	/* Construct mport selector for corresponding VF */
+	efx_mae_mport_vf(efx, efv->idx, &selector);
+	/* Look up actual mport ID */
+	rc = efx_mae_lookup_mport(efx, selector, &efv->mport);
+	if (rc)
+		return rc;
+	pci_dbg(efx->pci_dev, "VF %u has mport ID %#x\n", efv->idx, efv->mport);
+	/* mport label should fit in 16 bits */
+	WARN_ON(efv->mport >> 16);
+
+	return 0;
+}
+
 static void efx_ef100_rep_destroy_netdev(struct efx_rep *efv)
 {
 	struct efx_nic *efx = efv->parent;
@@ -147,6 +167,13 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 			rc);
 		return rc;
 	}
+	rc = efx_ef100_configure_rep(efv);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"Failed to configure representor for VF %d, rc %d\n",
+			i, rc);
+		goto fail;
+	}
 	rc = register_netdev(efv->net_dev);
 	if (rc) {
 		pci_err(efx->pci_dev,
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 235565869619..1d17aaf6cd5c 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -21,6 +21,7 @@
  * @parent: the efx PF which manages this representor
  * @net_dev: representor netdevice
  * @msg_enable: log message enable flags
+ * @mport: m-port ID of corresponding VF
  * @idx: VF index
  * @list: entry on efx->vf_reps
  */
@@ -28,6 +29,7 @@ struct efx_rep {
 	struct efx_nic *parent;
 	struct net_device *net_dev;
 	u32 msg_enable;
+	u32 mport;
 	unsigned int idx;
 	struct list_head list;
 };
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
new file mode 100644
index 000000000000..011ebd46ada5
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "mae.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+
+void efx_mae_mport_vf(struct efx_nic *efx __always_unused, u32 vf_id, u32 *out)
+{
+	efx_dword_t mport;
+
+	EFX_POPULATE_DWORD_3(mport,
+			     MAE_MPORT_SELECTOR_TYPE, MAE_MPORT_SELECTOR_TYPE_FUNC,
+			     MAE_MPORT_SELECTOR_FUNC_PF_ID, MAE_MPORT_SELECTOR_FUNC_PF_ID_CALLER,
+			     MAE_MPORT_SELECTOR_FUNC_VF_ID, vf_id);
+	*out = EFX_DWORD_VAL(mport);
+}
+
+/* id is really only 24 bits wide */
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_MPORT_LOOKUP_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_LOOKUP_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_MPORT_LOOKUP_IN_MPORT_SELECTOR, selector);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_LOOKUP, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, MAE_MPORT_LOOKUP_OUT_MPORT_ID);
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
new file mode 100644
index 000000000000..27e69e8a54b6
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EF100_MAE_H
+#define EF100_MAE_H
+/* MCDI interface for the ef100 Match-Action Engine */
+
+#include "net_driver.h"
+
+void efx_mae_mport_vf(struct efx_nic *efx, u32 vf_id, u32 *out);
+
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
+
+#endif /* EF100_MAE_H */
