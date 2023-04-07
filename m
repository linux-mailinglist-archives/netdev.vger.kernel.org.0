Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF986DA9D5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbjDGIMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbjDGIMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:12:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8CBAF3C;
        Fri,  7 Apr 2023 01:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXEGyBmtY3OfJYfZk1He5/BD5w3SaNs9gEeRV5FPJOj7MliyAbJ3lDnWCqbrininVvLyxhQMC9bOcKUioS2A0CnIz1rhmzkBBAdXZcOlNse6RafmcrmaPXq/F/CFoJjTNY0RlLqHKGgba72P5hzErw9DgAK1anM5TbFOOGdYgsjGJaRcftJX4+9ujWNf9bqw43D+qITXAKekWQUV4p3oHSYQF3WF0n2aomT5EvLyhrUX01qrbqYzATI1vEDbEJ8VN+1kIYD0ncOAucYHJdWV5/aQSgzJhLB1GA78A/Q1FRiLDeoxeVLIRcNZgSISwjAO/Ff6DqRai+nH3GSp0UctIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6k9retQtP8nRDhPIlMBiFTznddjBRMf6XyeZDD8bI6s=;
 b=Bi3dJtpJBfkFN/rUz9wlj9rY6bcJfXT3uS7xBODmS55xxi3NnChBdGUHtcRrDP+Vo7Hl2MuvPqJL4pGInld1w1DpXgKkbjqBTDvOPou8DaeK0h+npoRK8X6zdzA9Nu0AOqWgOzJfdIbceYBuHHnNbSsrRlljHmmUYnOTfAh69LorHOdcbbTeHjAPQ/44ed800ta1t+Qrya5mv2RkdZf4xIojeLadbwzxN4MlwCEbh6WBiVK+umY58V80BzYG+P8WKW1f2BEliGYKlgNswVTxJ1pgNLwE+/dd5vgnr6M67NygKSNhBrQR1dWzY0TrTXgdqkZ06f3cvq96nzTaUCTq0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6k9retQtP8nRDhPIlMBiFTznddjBRMf6XyeZDD8bI6s=;
 b=zDHnDpvgeGDME16sKUvhASiba3TiC856x73BilGjI7jwe4uEhWpLY5Y3iYfwk7QM76+f2XPvpWwvynNn9cZ9idgkEAMRzrDxN5qeMZMuEI9yiDJ7A11IK62cTvFheoJKM3kk2uHClESHlhnSaZvanIyS0fU+9G7U08qJsmRLLqg=
Received: from BN1PR12CA0022.namprd12.prod.outlook.com (2603:10b6:408:e1::27)
 by SA3PR12MB7859.namprd12.prod.outlook.com (2603:10b6:806:305::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Fri, 7 Apr
 2023 08:11:30 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::e2) by BN1PR12CA0022.outlook.office365.com
 (2603:10b6:408:e1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34 via Frontend
 Transport; Fri, 7 Apr 2023 08:11:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Fri, 7 Apr 2023 08:11:30 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:25 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:12 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:08 -0500
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
Subject: [PATCH net-next v4 04/14] sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
Date:   Fri, 7 Apr 2023 13:40:05 +0530
Message-ID: <20230407081021.30952-5-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT011:EE_|SA3PR12MB7859:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5ce374-eec7-422c-d63a-08db373fb15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3OQkqhE7HNtq4ATG9GLvZXNkbjB+42d8ePArJ+mOorDBEg7YyFvdyPoYYCUMxitEZVrtuErsUnC23ST0Fz6ws/Xkl2VdBd+jiZQEOBPDWp8twVZHhXL6rrQgOyxuYVlEKGHGfMsev4MY5zOC9QZ4OzzJkbv9urvuDzyMIHLzHQWzH+iSxM83eer6XcSBVdH2aFvMW2ocrFhw7wU8O47GbCgLCTNFtDaNK12n1yrh4r/8Uc6QyqZP4CTIe+q4tOC0ICJOLTQXQ+Jc81/pnlulgf5bSosRt2LnzCdKdqgzoZIyVQIEVA31uY95XvkK9Xnjt5HmQ0LqmoDTwTd370FcY+SzzjgElblV77gcfkgYc9164DfnZbAW6TA4nDYu76f/OJycD5DaTbermD5g2FOE6UQ6qmJXhaKHFbwQWJu6j2dMkXuJvyKaw9zXoL8rACppJ2CYIvqbeCbLS5HvdsqGH3XHGzHP9nJKvbuMMTKP3ToG3ixyi/+7hwxIFwqXoGg92p0X4TF60ONK8r6vGRzNruJTGClRPdz2bogLf2z8hUf4IDp5z1H93ZTbHn6B/SNRSmxo2GX5OP96uMUOzFtFJMC8X+aVzjvp17GSw2WXX8t8M+mW8FKxk/7+BcA64Sl9n66nCiGDrol/MmdkdqLxcSsN/9rKHSmhd8f5/3GXdYIegV8S/cSeZveqrEzp0/PmW++UXY54g4qGkGcXHIkFHCbqC6rFedZobAKLyS0qp8Y/bMZwU55x7/eYzcBWve1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(2616005)(921005)(2906002)(8936002)(8676002)(5660300002)(40460700003)(82740400003)(356005)(81166007)(41300700001)(44832011)(36756003)(82310400005)(40480700001)(7416002)(86362001)(1076003)(54906003)(6666004)(26005)(336012)(36860700001)(83380400001)(478600001)(70206006)(186003)(47076005)(70586007)(426003)(4326008)(316002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:11:30.0707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5ce374-eec7-422c-d63a-08db373fb15c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7859
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add and update vdpa_supported field to struct efx_nic to true if
running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
required to ensure DMA isolation between MCDI command buffer and guest
buffers.
Also, split efx_ef100_init_datapath_caps() into a generic API that vDPA
can use, and the netdev (TSO) specific code is moved to a new function
efx_ef100_update_tso_features()

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++--
 drivers/net/ethernet/sfc/ef100_nic.c    | 42 ++++++++++++-------------
 drivers/net/ethernet/sfc/ef100_nic.h    |  6 ++--
 3 files changed, 48 insertions(+), 26 deletions(-)

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
index 54b2ee7a5be6..e6e67a50610f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -162,7 +162,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 	return 0;
 }
 
-int efx_ef100_init_datapath_caps(struct efx_nic *efx)
+static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -198,25 +198,21 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
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
+	/* Current EF100 hardware supports vDPA on VFs only, requires MCDI v2
+	 * and Firmware's capability to proxy MCDI commands from PF to VF
+	 */
+#ifdef CONFIG_SFC_VDPA
+		nic_data->vdpa_supported = efx->type->is_vf &&
+					   (efx->type->mcdi_max_ver > 1) &&
+				efx_ef100_has_cap(nic_data->datapath_caps3,
+						  CLIENT_CMD_VF_PROXY);
+#endif
 	return 0;
 }
 
@@ -820,14 +816,12 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
 	if (WARN_ON_ONCE(nic_data->bar_config > EF100_BAR_CONFIG_VDPA))
 		return -EINVAL;
 
-	/* Current EF100 hardware supports vDPA on VFs only */
-	if (IS_ENABLED(CONFIG_SFC_VDPA) &&
-	    new_config == EF100_BAR_CONFIG_VDPA &&
-	    !efx->type->is_vf) {
-		pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
-			efx->name);
+#ifdef CONFIG_SFC_VDPA
+	if (new_config == EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_supported) {
+		pci_err(efx->pci_dev, "vdpa not supported on %s", efx->name);
 		return -EOPNOTSUPP;
 	}
+#endif
 
 	mutex_lock(&nic_data->bar_config_lock);
 	old_config = nic_data->bar_config;
@@ -1203,6 +1197,12 @@ static int ef100_probe_main(struct efx_nic *efx)
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
index 02e5ab4e9f1f..a01e9d643ccd 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -77,6 +77,9 @@ struct ef100_nic_data {
 	u32 datapath_caps3;
 	unsigned int pf_index;
 	u16 warm_boot_count;
+#ifdef CONFIG_SFC_VDPA
+	bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
+#endif
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	enum ef100_bar_config bar_config;
@@ -96,9 +99,8 @@ struct ef100_nic_data {
 };
 
 #define efx_ef100_has_cap(caps, flag) \
-	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
+	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _LBN)))
 
-int efx_ef100_init_datapath_caps(struct efx_nic *efx);
 int ef100_phy_probe(struct efx_nic *efx);
 int ef100_filter_table_probe(struct efx_nic *efx);
 
-- 
2.30.1

