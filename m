Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B0057BDCD
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiGTSbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240919AbiGTSbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A124BD08
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LthrQqeYUc1Y/b3DvNnK08vWNk6TcNrLu5VK1VUSxp242TT1SPuJrSAldLTseZNKqXQKvG/3ZlmOYDsQLUuwf2LNt6DCBsf/R9apuAcpxJKog7Xgg7+WJ4LtElvyVG8qaIhsdtpoICKecefMJOpRgBvUN/pdfV4k0c8ejXPfZgqAo/phTog/WFFVdsk6UEwllg2pSyLE2CcoxuJmrPJXpE9wf5BXhh6fEIl/7YdMwzyJGJTTcr5ohrnEF67vJ5UNb/ZAPz3a147Gu5yE7lJ4DGjxDIZqFJ668aW5hOjPJD3yyBCv8afA0Vq+Be8s/ac66EF1TcIvZpRKgdCrnxAkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0NAmz/Q8Du0IHDC+BeK9+dh+znfxRA5WQTiVuPlAFU=;
 b=L1u319QS0T4jaQRdirqjP0XccSAlWmPsb9A3nxQo3ppOHVHC2cN6rAiacCTzYx4GoTqEYhTf0ETOU7XcYJ2GClotBXC3cHD3JmcXNJWUW6OswrKLeFaG69FfwlSU2DGDQVhM709Wgggklw9KsNklIOJcpczEww/vIRcjlhCN3fPX3PNrQ7HkXAOPiQh3vJkhRGx4AtGXwUDsaLbQ+o2KhurXiiVCXSctTP93/WDiPyqqa3Kf4mVMH2+MYq4DH5ANF5edLvJBoJi08ssMqdiS8VO7Ho8I961yHXmRLDfC6L30eQ5vnZsT/scXc5EWf22XlnGJ1G90D50VIrx8dUVuFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0NAmz/Q8Du0IHDC+BeK9+dh+znfxRA5WQTiVuPlAFU=;
 b=xhH51JrTqjtwGr7XKxo68mgfgQeN9PtiqIgQhFoSITcXsP2IsJ7Wxsnbqdz8ThL34+Ij9uV7Z8117qTQoQc5gULrEfKXLSWKBnO+fxSlPNHlTo8PSmMu5Y2YMSqRKcUQKYBu+li3Dqq9IAcZ97IRWftI/hWNXnm/O2W2wJEZopT34/P46+UzR0crbWY3P/D2kOk+tonuQErVSasHEfSdicMUxMVYJUDjrp38j8cYDmn6MOVHf3h7i3hnSc4K4XMWzxx/SPeaMSy/eNtt1B9wm2sZPk0adIXuy4P04MZIt/CnBqou+BnjyNewDS7xmQ2aL7ccG3ZiqjGl4593+T+3Gg==
Received: from DM6PR03CA0051.namprd03.prod.outlook.com (2603:10b6:5:100::28)
 by DM6PR12MB2907.namprd12.prod.outlook.com (2603:10b6:5:183::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 18:31:04 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::c8) by DM6PR03CA0051.outlook.office365.com
 (2603:10b6:5:100::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:04 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:31:03 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:31:02 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:31:01 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 6/9] sfc: determine representee m-port for EF100 representors
Date:   Wed, 20 Jul 2022 19:29:34 +0100
Message-ID: <7c76889271f6e73bbbdd239cc8615a46cd46adad.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75ef219e-f3bc-412a-7407-08da6a7e0154
X-MS-TrafficTypeDiagnostic: DM6PR12MB2907:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V0uZbLG7RXfOqhFgmb7Kyr3T0qD3h6+nttPbbgpojJFn0RK0/Niax8um3+aXTWmskwleleTkqDS837lWLIO7ThJ6wmlaRbV7MsF7N8rfnpYJNOQVQmSIzkYL1uREV9iByvxJQh5w02OMAfvVqJqVp/3nnVB725mUo1877t8RCe4OmHexVQoPjG7leEH7d/WPclEZQnusKey2Oq7+3jxwBqVKg5bZywkBjbJFesBXOE1Su2V9Kbui1mjWQFB0FufQAJSgaFKQqXM0GJDqok9me3phrM2+U/ht7XoqHmV5WiLrW3xwQ2Ixno7ogbJPh3TQDQAG8qfjGtB0280tY5/AY80djQ8YfgihM/MsxzblgKb2xSUMi9Fyi+69MFkdzI7IuXsf+0rzeh9uuzBVRXkts7RhWCdSdhN8WtvUxIJIeox5pUbDbQwEEguPlu2k2UtxQdAawSwZGO8hFjUdMN0+r8j88oONr0eCAtRMS7QDslbhrJdORC/8vSIWygZzt3guHmaD+gzHi25bGZzeNI3djRo9BkeQ5TvJI/IprN43qjTNg/4j7Lty2N/xPctzs2vxs1Xr+96vxPvZUkS18jdYF8c2IME64ZXi/LgvB0x/+JKgEhtR66O5LkzXoQ9jMDVvPWrZWPOuuPNwBayhrq5f1OwOh0ZwVVu5lYfEY8AotxtvZXHMalivCtvCBGb6SvcferH/9nDIXnWZM+RPLTNfotW5+4dnKRtB8L6b59dr7HrRapNZr0TQbItUH/O+/LTQBZ0DmUYNhdXnEidsfwgPUUAvZX33+9kdTcECrNYF2ReTf6AVG4F3o/LIs7fInC5hCvV0H39rwVF8ph1cGBZatJjuqnzUjb2wnLq6bpdHPUM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(40470700004)(46966006)(70586007)(82740400003)(356005)(36756003)(83380400001)(83170400001)(36860700001)(40460700003)(55446002)(81166007)(186003)(42882007)(47076005)(8936002)(336012)(478600001)(110136005)(6666004)(70206006)(54906003)(2906002)(41300700001)(26005)(316002)(4326008)(9686003)(40480700001)(82310400005)(2876002)(5660300002)(8676002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:04.5519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ef219e-f3bc-412a-7407-08da6a7e0154
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2907
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
