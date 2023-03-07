Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B184A6ADDA1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCGLjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjCGLiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:38:18 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C50769F2;
        Tue,  7 Mar 2023 03:37:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5TjZjWmEi1TQJ8Iqwmns2v4G7y3xJ9vA2cibinPmcwvgSlCimFerdZegkotHjm1y8QqjgjGagqdXw7NmYYr9MzhSaoY808HGKrTaATOOd3/HS4WVohWwmxggQSe+qwFOvhBnBA48lcVmmBkWmt2J2jPz06wgg305RuA5UHvj3aQlsoZNJbOZuvBH3M3Tr3jBZuieAKxA/CEgybHqznN0B+LUb8FmDuGR4uFY9JAl110MnEklG4YxDcJ+2RIVP4SCYVEh+nbRvEO3ihQa4XE05EsKcHn8ZvxVHPHjzehLAF0ebh+HHfo3eZHjwhlnco4Pb9R3Ld0AoATDUyoRbPdJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYjd3vwxWHRuUkPBqz15PMKRBW7dyMKsiiueubKkDMo=;
 b=IsfshMig2OddaW9bUNn2uMiWwXiZpowWK8g30rKEc5yf+WYBYLmgWf/tPAEB7lfuSTXYefY8iG0ziDyySzVKJUwvHo/J8h7/BYGtQUNubYV4TpkeGfsYJ4MkLJU6Ia6x5j01uKd15vRzx9zfpp/0I/Q+3KvzUPV5juVasYS/BlWxa8jWdv+O5qVmNq18X8FHxpRUiCxfpBoRokvYyjJPuWQzF11GU8cEIJjYxq1MBtNWZr2zWRYs610gTlv66u36m6mGFr4gqL5Y5ls6tDRT23yjWnVYBzDXCvlIjeXpEbqTlSH1HJ9upxZZaZpHbCn5GsMDiIXJPd2/p2/68a3KVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYjd3vwxWHRuUkPBqz15PMKRBW7dyMKsiiueubKkDMo=;
 b=YAndEJvMz7koLMGjTNfk2sIKuWV2FjH4iLUtAgshu6DDJTsEH2Rxz4LQSBmgPm7EXxmcCFq4KUS0w6kYs13ibqC0shj3dlsC0tX6DSifHBmd4v73EB4S2POtIJVD9Un/TviQWYAeE1cXUZ93584QvRi/EoB/pcoYCwTe56STnw4=
Received: from BN9PR03CA0244.namprd03.prod.outlook.com (2603:10b6:408:ff::9)
 by PH8PR12MB6961.namprd12.prod.outlook.com (2603:10b6:510:1bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Tue, 7 Mar
 2023 11:37:13 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::1d) by BN9PR03CA0244.outlook.office365.com
 (2603:10b6:408:ff::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Tue, 7 Mar 2023 11:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:37:13 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:08 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:37:08 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:37:03 -0600
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
Subject: [PATCH net-next v2 04/14] sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
Date:   Tue, 7 Mar 2023 17:06:06 +0530
Message-ID: <20230307113621.64153-5-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT062:EE_|PH8PR12MB6961:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc81418-7313-477f-7453-08db1f004bb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUkKaoyDgiHdOXbS6pp9kCgrilubpZEiSnXPJv4wuxHVJ51bNpLXuP8A4odcsalocjTRnf1AEBUnNH8y8iSNAT754IsP51X1PEB85+8WEa3r/pEwjlT70it14FrSPxcozprsQbzwzWTrlGwrrZrF8dRAZgw++NK1eQAv3M9nldDVGmcHOczrudhj6DyTakHZcGIycSxRee1kgGPiO/7QG6jEBLP6T7CZK0ilzxlowpkeEWxi6FGSvIFi32NK3OMTe/+nHRH2MT0J+zNXIJCBo/koo9tUB0KSw4b8oYUSpkSeAeFID2/UHL8PlUkENYmPokJk9O8hvtopX+JTqMe7+QGKIAXa6EQA4fr0fFin2GWO1KgajREs3QFJvA840ARJENZO4ZxCa63IIPa33louQybeD94YP/aXgF8HOB/wcPeacMp/uUFwJCCUR0l+whVjqybqNI9oKLJMvpRI2H6xxn4uqwnjQ1T/b/BJdHgux9qg09sEUix5kJtIJ3C/b+5ZijpX0HFERbAOidI/UVZNW8HIL0jNJC7LR5wXUTvpmrMg8Smdmn1S3g83hXpolU+sWcDX8zIVb/fJAKoo+E/S3FZ5p0EmgUmuNEMpb1uQke3e/qLNNcQlOr2yP34QUBLpOwWJSvPxT5VlajkE6ke6U5ApWmMNsodYD/JslUCsbxIDoLNlxIHr4077Yu24TvQImpYyRASjYNO/so7ITg561nCLUvQL8dkb8ngxYrLysbD/WyyOPMr8LWTQEmT3APJm5A7xnzrjfETX6LgQHc/UUw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199018)(36840700001)(46966006)(40470700004)(8936002)(7416002)(5660300002)(70206006)(70586007)(44832011)(2906002)(8676002)(4326008)(110136005)(316002)(54906003)(478600001)(36756003)(47076005)(426003)(36860700001)(1076003)(26005)(2616005)(41300700001)(40480700001)(86362001)(82740400003)(82310400005)(83380400001)(40460700003)(356005)(81166007)(921005)(186003)(336012)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:37:13.3035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc81418-7313-477f-7453-08db1f004bb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6961
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add and update vdpa_supported field to struct efx_nic to true if
running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
required to ensure DMA isolation between MCDI command buffer and guest
buffers.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++++---
 drivers/net/ethernet/sfc/ef100_nic.c    | 35 +++++++++----------------
 drivers/net/ethernet/sfc/ef100_nic.h    |  6 +++--
 drivers/net/ethernet/sfc/ef100_vdpa.h   |  5 ++--
 4 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index d916877b5a9a..5d93e870d9b7 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -355,6 +355,28 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	efx->state = STATE_PROBED;
 }
 
+static void efx_ef100_update_tso_features(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct net_device *net_dev = efx->net_dev;
+	netdev_features_t tso;
+
+	if (!efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
+		return;
+
+	tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
+	      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
+	      NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
+
+	net_dev->features |= tso;
+	net_dev->hw_features |= tso;
+	net_dev->hw_enc_features |= tso;
+	/* EF100 HW can only offload outer checksums if they are UDP,
+	 * so for GRE_CSUM we have to use GSO_PARTIAL.
+	 */
+	net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+}
+
 int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
@@ -387,9 +409,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
 	efx->mdio.dev = net_dev;
 
-	rc = efx_ef100_init_datapath_caps(efx);
-	if (rc < 0)
-		goto fail;
+	efx_ef100_update_tso_features(efx);
 
 	rc = ef100_phy_probe(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8cbe5e0f4bdf..ef6e295efcf7 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -161,7 +161,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 	return 0;
 }
 
-int efx_ef100_init_datapath_caps(struct efx_nic *efx)
+static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -197,25 +197,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 	if (rc)
 		return rc;
 
-	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
-		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
-
-		net_dev->features |= tso;
-		net_dev->hw_features |= tso;
-		net_dev->hw_enc_features |= tso;
-		/* EF100 HW can only offload outer checksums if they are UDP,
-		 * so for GRE_CSUM we have to use GSO_PARTIAL.
-		 */
-		net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
-	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
 	netif_dbg(efx, probe, efx->net_dev,
 		  "firmware reports num_mac_stats = %u\n",
 		  efx->num_mac_stats);
+
+	nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
+						     CLIENT_CMD_VF_PROXY) &&
+				   efx->type->is_vf;
 	return 0;
 }
 
@@ -806,13 +796,6 @@ static char *bar_config_name[] = {
 	[EF100_BAR_CONFIG_VDPA] = "vDPA",
 };
 
-#ifdef CONFIG_SFC_VDPA
-static bool efx_vdpa_supported(struct efx_nic *efx)
-{
-	return efx->type->is_vf;
-}
-#endif
-
 int efx_ef100_set_bar_config(struct efx_nic *efx,
 			     enum ef100_bar_config new_config)
 {
@@ -828,7 +811,7 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
 
 #ifdef CONFIG_SFC_VDPA
 	/* Current EF100 hardware supports vDPA on VFs only */
-	if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
+	if (new_config == EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_supported) {
 		pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
 			efx->name);
 		return -EOPNOTSUPP;
@@ -1208,6 +1191,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	}
 
+	rc = efx_ef100_init_datapath_caps(efx);
+	if (rc) {
+		pci_info(efx->pci_dev, "Unable to initialize datapath caps\n");
+		goto fail;
+	}
+
 	return 0;
 fail:
 	return rc;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 4562982f2965..117a73d0795c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -76,6 +76,9 @@ struct ef100_nic_data {
 	u32 datapath_caps3;
 	unsigned int pf_index;
 	u16 warm_boot_count;
+#ifdef CONFIG_SFC_VDPA
+	bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
+#endif
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	enum ef100_bar_config bar_config;
@@ -95,9 +98,8 @@ struct ef100_nic_data {
 };
 
 #define efx_ef100_has_cap(caps, flag) \
-	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
+	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _LBN)))
 
-int efx_ef100_init_datapath_caps(struct efx_nic *efx);
 int ef100_phy_probe(struct efx_nic *efx);
 int ef100_filter_table_probe(struct efx_nic *efx);
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index f6564448d0c7..90062fd8a25d 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Driver for Xilinx network controllers and boards
- * Copyright (C) 2020-2022, Xilinx, Inc.
- * Copyright (C) 2022, Advanced Micro Devices, Inc.
+/* Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
-- 
2.30.1

