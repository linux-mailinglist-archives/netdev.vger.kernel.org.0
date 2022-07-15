Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C385C5761D0
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiGOMge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiGOMgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:22 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C074348
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Idj3nQAUSdm7wQzBgh8Ej5F/CnsFzGOKpa1U8kuA6ND7Bjo+bHs+esXCESHLeWUAYdpkVpgCB4bsq76FL/mBXc9e2PVbm75p1V1snrArmNZGmPjm2/LctESRNGImMdmp6FFzXmyOGeRlRE5WVJ4XfY2UHlZHKXZ1zyaa+gLULdZHEY9/Eu6pghn+JsGNFeJ6LtM1fr8vTtLwQuEN0ExpEzQiVfPT8UBZx7HfWLL3Bm4Y6Nwx0t2YRZ5CRimeXUB3lGsV8mAdEPe+I383Gvsm376T6bkspx/aYmtatOCetsIadRAjHsGnCciCQewxlr8GF9M7h0moQcoHzkmRvdRjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlMEyl6o+mA4TG0B+xkYRwFAcBs2wedqd89OR9kdwk8=;
 b=LAAAWtAWC2SHUB+vhFsfGeE+zC8S9Lv61vwfgeWVFxNnxGEnQUcavliMoNge5HichO73wuwg0jHz/XsFb/3VEgYuFrXCWNcVtUIPah4lbwQs2sYqdhzT5qHTz2dG7M1iPmPh+VpnFrBlbd0hHWd5o22NJeC2ywnQ2g7ZxLpLim+xpLpz4w4c4OHvzyPvAh81mKon/bnj1lEI/PgXT2thBUatY0jCeRMwtF+rwS9BaVIChAlE6L7jBC0JIJ11Pua7B3/Xs8R2phNqBCZSV8jHZaBUoRAVp+97Xvy4zq25c+Ku7uVIZy9W7X0XJMLybi+RzRIQBxNB2YzhbnAWnPc1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlMEyl6o+mA4TG0B+xkYRwFAcBs2wedqd89OR9kdwk8=;
 b=Ghe8FAXAgdsgoYv6I4eVvXTVUziXkL9xg7K1r09CO5vK/yAb4Y68005P4lebG3JtSnV1kzTHkVfJoPVar9beBPdRpcgjEpfg3hGU1zzyr3MukcbvsHG5UdmmMj3VRjFEa0GR6/Jv+d/sP5MbY5poPJKRfLcxjnvrFAU9/ezrFsxbXr44DnpQqDepUOe59tJi69RhlokxoRmw3lwLpEb8SKGUjXNALVeDfRwGHdYM6SuAjOdCmXLgxCIOqGUuO/9m3cQr3DJocJc1u0XpWI9YgQ+/fnatf6EWgOwhFOcs4JLRdSGPKyzaUII84E3WuKH4+kSoBbYPLN4vFj1AAsX1JQ==
Received: from MW4PR03CA0260.namprd03.prod.outlook.com (2603:10b6:303:b4::25)
 by DM6PR12MB4809.namprd12.prod.outlook.com (2603:10b6:5:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Fri, 15 Jul
 2022 12:36:18 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::5d) by MW4PR03CA0260.outlook.office365.com
 (2603:10b6:303:b4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:17 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:17 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:16 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:15 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 07/10] sfc: determine representee m-port for EF100 representors
Date:   Fri, 15 Jul 2022 13:33:29 +0100
Message-ID: <b2e4c5f36ab34d9b3585dadb28e2865c528b0df7.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6cc14d2-d230-4173-19ad-08da665e9d7a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4809:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1vJSeeNqOcTQcz4kZhr10/onWFWFoJp0kEyjPegz4lqpv4PcjrJh2qiWJ/lwVJ5DvdWmsDKm28Y3mQIn4BK9Wpcgcm2s8j5Xzq9pxhwYW/VwQiUEgP1E7da113zfU7goifCaYnJxM9CzMzqmEv6sWvYD2RURp4p9LcSv8Orr4ECD5udPARFAvzJfBhcvFGQOZz+Po0WroEZfKyN2hf/4PmPvEmBnrqLkm6HTVdM1vgyWYBhkkaB+8awg6zc18vGMLszX29pYiAYlJtNEdkajbF2y/nCYe7cA+gA7aRqlUEjlju6PF8TzrLQ9aScxrB9kNa5hNobPmwwKgo8dZR295P1Tl9j1VWPzGvHyE0kBsEWJKO+dIoza7eyNp8KjmYMFq7dViIj78Zd3b3dkywFYUj6MRkrRnCkLn4UIBpPv2bB0W3gnRhl3PhlInrPgWzVMuburQEQt0236pcGVnKwYwqg2YNcYmIezdB2WaZprsseM0t2JdJdWI2TEhAvGcJnCVPTO/oTZvfQU3yrImja4weqOYemhHwTTVOJcXtJWca+ABioQ/nO3u8OdB+7BzXEer7LevH3VBc4n8kdOii099ymOZ5X7cp2oGJ4Kknjjx+HGT9Jxfi4pF189sM+dVoRChVHP69TUI/CJr6NvF+mGv5tSwvztUkO4+40r5d/L1jJw2swdFYGvCwuQ9ARvMaz7TSPnDYxqABY79t5TWWN/4KAhKLgKC8ezoMJL93+ZZTXtBJc1nZlcEeZ2zbhxtxc9d+IBWTtu2/vtMmILqffyQGBRPu+nfI66MMECjp5a+Lbjb3lBOtKtpOmNJHKaa403nv/ubBe+cLw95BpJgLW88+BhpcCOlERT7l3YxosZpQlKv17RQqBjFxMLk+MHGCC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(40470700004)(54906003)(55446002)(41300700001)(82310400005)(478600001)(6666004)(40460700003)(2876002)(9686003)(26005)(5660300002)(2906002)(8936002)(36756003)(47076005)(40480700001)(4326008)(83170400001)(83380400001)(70206006)(110136005)(336012)(70586007)(42882007)(8676002)(316002)(81166007)(82740400003)(356005)(186003)(36860700001)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:17.9455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cc14d2-d230-4173-19ad-08da665e9d7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4809
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
 drivers/net/ethernet/sfc/ef100_rep.h |  1 +
 drivers/net/ethernet/sfc/mae.c       | 44 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h       | 22 ++++++++++++++
 5 files changed, 95 insertions(+), 1 deletion(-)
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
index 7bd12aa5d980..a2f16bd59771 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -20,6 +20,7 @@ struct efx_rep {
 	struct efx_nic *parent;
 	struct net_device *net_dev;
 	u32 msg_enable;
+	u32 mport; /* m-port ID of corresponding VF */
 	unsigned int idx; /* VF index  */
 	struct list_head list; /* entry on efx->vf_reps */
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
