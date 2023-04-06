Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FF6D8FE4
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbjDFHA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbjDFHA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:00:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BE9559B;
        Thu,  6 Apr 2023 00:00:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrjSxGoGnlO2a9TXjhvDa5780D3B9ITH3nKaijx1Oax9Hst+TuabvL8Qv1mrgAo4/9Mg8SrlBTi9LTnq08t9PACoKFbM560JZASNSOkbah6PLev2RNPr9xe6vAxgOQXyFr5/Xh76jSpPzSz4huZb0+GhGc1K044QFHyn/7pYpswAZKOYf7vEdlTYrLM4lcddP+gJe0UsKbihcljL2xmw177Wtj31vD8aopVCZ3I7AATVU4KMAzYf038Q3TqY4Emfhj/SRyIWrNefGsPlo2dg2sGGCM/XzrTcvhLqESXd+WuoLNDZTtZpi4218JaUmEakfZFUrzwkM72R/2NpgkotPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kY+VvTYf4HzGzOy2xPxd6cAkf3E5pOrmp5q57lXz1MA=;
 b=Iy1KcsA9E1vQFeMA96T+mU+5UZR8kYrckP0mRvhrOd6CX8g+DawRi94dtpVCszpBh4p0eOuWeUpFgoMVMGC+Id/tz+6kYv2AId1lDL4hArvTOrJ0rQROL85EMydsVUV4WriyuSmOnrMhrhYyrZ2MRtYvsQ1RtAJiLtc+7x43/WIG+lYNBxv5+y7pAIUteHNnEtPfQu2GIo095310JUy0jy42DJw1PZmLRfKbfqTjdiiFMEn5lhNWTWO16LdeINI6mrR9clN+TmmScmXKsGVQQno7Iv4AbcpEQAxJWr6Uz3J56n644BbILkoJ2IrD/r8S9l7FOWG1dhM0CiLbCBIF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY+VvTYf4HzGzOy2xPxd6cAkf3E5pOrmp5q57lXz1MA=;
 b=zwfC2SLKXsCqu/2Yd+dNBQagqxv68WnEINIraK2+yG2AzFa5efe+caF1cdNmgbDulQNiIqmIr8fBwhh8xnro7Cmz1RYFy1Kidr6iDyDB0jXI8/MdMfUvzqQJG7KybDBCziTjYI2eqyKEZ4ma9Oufek5HOGuybleSlye6K959jh0=
Received: from BN9PR03CA0235.namprd03.prod.outlook.com (2603:10b6:408:f8::30)
 by IA0PR12MB9009.namprd12.prod.outlook.com (2603:10b6:208:48f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 07:00:20 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::d6) by BN9PR03CA0235.outlook.office365.com
 (2603:10b6:408:f8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.37 via Frontend
 Transport; Thu, 6 Apr 2023 07:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.30 via Frontend Transport; Thu, 6 Apr 2023 07:00:20 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:00:19 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:00:19 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:00:15 -0500
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
Subject: [PATCH net-next v3 01/14] sfc: add function personality support for EF100 devices
Date:   Thu, 6 Apr 2023 12:26:46 +0530
Message-ID: <20230406065706.59664-2-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|IA0PR12MB9009:EE_
X-MS-Office365-Filtering-Correlation-Id: ba106be6-138d-451b-9a5b-08db366c95fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLZBrbCVWM5cebYcrqLD0W6bFdylcW+CcIhVckAqiPpxg0Z/t7KVuMQM/JhvW6g0JeqR/m66iwjaJ6GqKSklDvRt+DNMATAS6mSsOdiI2Ay5Xhko3PS9zfQYwt0nQLZ7Rhl+oUD32+Qc0W2G2R5jASDPcBtizugyaQAzR64epp7o56FdOYWhHcJm35WKvK4oCFJDo2mUfqpUEEjtZY6Sffw9cImQGpqwIA0Ki/sjRzXu9qIaKpVYogdjegnCNPi+NqVFJmNfAVE3oSLSEVAUDncjdLyGQ8WkLjht7BhX9LJbGbhqTQ7H0ihWAsjUpjuaoUhZLTeCr6H9FxpwfkiArX5FJQeJ0ssXfwAN6dhi1PkfmsPfxUjQIDvtaXhRBLEj1K5m4oJYh3+TrPEog00LBYRAyTFACidJZLvpIPEY+47whF28Qnz4mvdjNX56nnsBRhLfJ/L/6R+agM+dEMOOfIsbulTgm2LYEhiifhPHmEs0zvZ+y655+d5UsWvLLn1c+c7elXdOw5qtKyd5twR6VcB74M3TZaQXZh0dYQ6objKlNbUk8AkOapt/LFcWxkAGk2XC1dDmSO7/1OXmTbXedOfeSVAGt9Liz5l4DAN9ycEyvNF9PrVOoz/JPE5u1pa5cWlpKmTk5P6rP26hLeolyHD26sHRWUIBgyzrdBncOKIUGsNHVY5xYtPDSYv04wktfEhleUp/jHOHx5xF56Ug5C8L6RYxeAMDASzkAr51GHXx9tfGShc1NgquK1GbdL1bJLRvF3/sw/7/suNc/zNu+w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(83380400001)(47076005)(82310400005)(36756003)(40480700001)(86362001)(36860700001)(81166007)(40460700003)(356005)(921005)(82740400003)(54906003)(110136005)(478600001)(316002)(41300700001)(8936002)(5660300002)(44832011)(7416002)(2906002)(8676002)(4326008)(70586007)(70206006)(186003)(426003)(336012)(2616005)(26005)(1076003)(6666004)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:00:20.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba106be6-138d-451b-9a5b-08db366c95fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9009
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function personality defines the location and semantics of
registers in the BAR. EF100 NICs allow different personalities
of a PCIe function and changing it at run-time. A total of three
function personalities are defined as of now: EF100, vDPA and
None with EF100 being the default.
For now, vDPA net devices can be created on a EF100 virtual
function and the VF personality will be changed to vDPA in the
process.

Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100.c     |  7 ++-
 drivers/net/ethernet/sfc/ef100_nic.c | 93 +++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h | 14 ++++-
 3 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 6334992b0af4..35f1b74ba890 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -3,6 +3,7 @@
  * Driver for Solarflare network controllers and boards
  * Copyright 2005-2018 Solarflare Communications Inc.
  * Copyright 2019-2022 Xilinx Inc.
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -428,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	if (!efx)
 		return;
 
-	probe_data = container_of(efx, struct efx_probe_data, efx);
-	ef100_remove_netdev(probe_data);
+	efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_struct_tc(efx);
 #endif
@@ -440,6 +440,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	pci_dbg(pci_dev, "shutdown successful\n");
 
 	pci_set_drvdata(pci_dev, NULL);
+	probe_data = container_of(efx, struct efx_probe_data, efx);
 	efx_fini_struct(efx);
 	kfree(probe_data);
 };
@@ -505,7 +506,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 		goto fail;
 
 	efx->state = STATE_PROBED;
-	rc = ef100_probe_netdev(probe_data);
+	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
 	if (rc)
 		goto fail;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 4dc643b0d2db..54b2ee7a5be6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -3,6 +3,7 @@
  * Driver for Solarflare network controllers and boards
  * Copyright 2018 Solarflare Communications Inc.
  * Copyright 2019-2022 Xilinx Inc.
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -772,6 +773,93 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	return 0;
 }
 
+/* BAR configuration.
+ * To change BAR configuration, tear down the current configuration (which
+ * leaves the hardware in the PROBED state), and then initialise the new
+ * BAR state.
+ */
+struct ef100_bar_config_ops {
+	int (*init)(struct efx_probe_data *probe_data);
+	void (*fini)(struct efx_probe_data *probe_data);
+};
+
+static const struct ef100_bar_config_ops bar_config_ops[] = {
+	[EF100_BAR_CONFIG_EF100] = {
+		.init = ef100_probe_netdev,
+		.fini = ef100_remove_netdev
+	},
+#ifdef CONFIG_SFC_VDPA
+	[EF100_BAR_CONFIG_VDPA] = {
+		.init = NULL,
+		.fini = NULL
+	},
+#endif
+	[EF100_BAR_CONFIG_NONE] = {
+		.init = NULL,
+		.fini = NULL
+	},
+};
+
+/* Keep this in sync with the definition of enum ef100_bar_config. */
+static char *bar_config_name[] = {
+	[EF100_BAR_CONFIG_NONE] = "None",
+	[EF100_BAR_CONFIG_EF100] = "EF100",
+	[EF100_BAR_CONFIG_VDPA] = "vDPA",
+};
+
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config)
+{
+	const struct ef100_bar_config_ops *old_config_ops;
+	const struct ef100_bar_config_ops *new_config_ops;
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_probe_data *probe_data;
+	enum ef100_bar_config old_config;
+	int rc;
+
+	if (WARN_ON_ONCE(nic_data->bar_config > EF100_BAR_CONFIG_VDPA))
+		return -EINVAL;
+
+	/* Current EF100 hardware supports vDPA on VFs only */
+	if (IS_ENABLED(CONFIG_SFC_VDPA) &&
+	    new_config == EF100_BAR_CONFIG_VDPA &&
+	    !efx->type->is_vf) {
+		pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
+			efx->name);
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&nic_data->bar_config_lock);
+	old_config = nic_data->bar_config;
+	if (new_config == old_config) {
+		mutex_unlock(&nic_data->bar_config_lock);
+		return 0;
+	}
+
+	old_config_ops = &bar_config_ops[old_config];
+	new_config_ops = &bar_config_ops[new_config];
+
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	if (old_config_ops->fini)
+		old_config_ops->fini(probe_data);
+	nic_data->bar_config = EF100_BAR_CONFIG_NONE;
+
+	if (new_config_ops->init) {
+		rc = new_config_ops->init(probe_data);
+		if (rc) {
+			mutex_unlock(&nic_data->bar_config_lock);
+			return rc;
+		}
+	}
+
+	nic_data->bar_config = new_config;
+	pci_dbg(efx->pci_dev, "BAR configuration changed to %s\n",
+		bar_config_name[new_config]);
+	mutex_unlock(&nic_data->bar_config_lock);
+
+	return 0;
+}
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1025,6 +1113,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
+	mutex_init(&nic_data->bar_config_lock);
 	efx->max_vis = EF100_MAX_VIS;
 
 	/* Populate design-parameter defaults */
@@ -1208,8 +1297,10 @@ void ef100_remove(struct efx_nic *efx)
 
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
-	if (nic_data)
+	if (nic_data) {
 		efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+		mutex_destroy(&nic_data->bar_config_lock);
+	}
 	kfree(nic_data);
 	efx->nic_data = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index f1ed481c1260..02e5ab4e9f1f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -2,7 +2,8 @@
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
  * Copyright 2018 Solarflare Communications Inc.
- * Copyright 2019-2020 Xilinx Inc.
+ * Copyright 2019-2022 Xilinx Inc.
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -61,6 +62,13 @@ enum {
 	EF100_STAT_COUNT
 };
 
+/* Keep this in sync with the contents of bar_config_name. */
+enum ef100_bar_config {
+	EF100_BAR_CONFIG_NONE,
+	EF100_BAR_CONFIG_EF100,
+	EF100_BAR_CONFIG_VDPA,
+};
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -71,6 +79,8 @@ struct ef100_nic_data {
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
+	enum ef100_bar_config bar_config;
+	struct mutex bar_config_lock; /* lock to control access to bar config */
 	u64 stats[EF100_STAT_COUNT];
 	u32 base_mport;
 	bool have_mport; /* base_mport was populated successfully */
@@ -95,4 +105,6 @@ int ef100_filter_table_probe(struct efx_nic *efx);
 int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 			  int client_handle, bool empty_ok);
 int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config);
 #endif	/* EFX_EF100_NIC_H */
-- 
2.30.1

