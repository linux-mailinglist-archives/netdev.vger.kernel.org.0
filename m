Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634C76D8FF7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbjDFHCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbjDFHB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:01:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F96AF0D;
        Thu,  6 Apr 2023 00:01:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK1r9/DgVidUM5wwdccABp/xy9hKFCVfB1S4EWesfCW1HGLv4VU8G0RfbFnL6XSJlz7Mo7AAdppzbMHVBk0ihj9fQmu2Ga9R9aqOQ+OWcJb0a8nZ8G3UV2TOcJ3CI5tcwSuu6zrizXFiGz+N2yTrLVLPgIU/HZDeX+6Mk0Bg1JTXWtURCLOgiDHCCaQ2L6fHhEX81AtD9a8z1WI86hbBXIG+z6XV003HKFB0/7ba6njslPAGMAHiSBNblyuWVxDxO4vrQjG2/E4/GZKWtISJThusOOta8rcrF0hLvkzZdmxiBmN3GuZO50delswXGOSmk6nZt6ZneRDMwaG8ZDSWcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0wsHbyM9i2Wu17Eq0UmsJbvwIwIAgLoyVFwq9gTsGs=;
 b=kyugV8M+0SobUi8oqL36lgbl17xnvwf8kXDQEt/e5H9Y1OB+w5+rTN2BlKGjW+BHByVGUs9+THGYUo7ub6sDC3s+NShC1zbhoDEKmM27AGiZmQCGPoGnllJtb4PJPqlz+gWR5NinOFqL6J81A7OF4h+Peqitx/PD8jS4RpUJ/sDeGUJWx998kCjuiYBF+i/8Th3G+H2tj1+fntNfGhW3pdykMjyLFH+1/ONmINB7sZCnTXsOgBzEGgxIpXXpInDlaRsviEIhPOVEOHnybA1f7EIbjhx+ICm2ZfHCuL9/84Ed6F63jOGAxvSb7zNlLRuB8LP+GNtt7OcNaLFD64do7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0wsHbyM9i2Wu17Eq0UmsJbvwIwIAgLoyVFwq9gTsGs=;
 b=d9BFrzP1Xjo+/0GkNzJLiE+pVcmSbyvrscPcY5yyPqXILwnb2z0Z06LwVRuTU9dPbsEWtjbi3SPJD2TR299UvHahsiQyk2bahMX0ZyPmLMr3asNk9pxqkCdTxthmR7MPqQneD9PpJ9bZMVMu+/Wz+SAfRSv//R+Ygo0GNWdzPdE=
Received: from MW4PR03CA0023.namprd03.prod.outlook.com (2603:10b6:303:8f::28)
 by DS7PR12MB6239.namprd12.prod.outlook.com (2603:10b6:8:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:01:05 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::d4) by MW4PR03CA0023.outlook.office365.com
 (2603:10b6:303:8f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30 via Frontend
 Transport; Thu, 6 Apr 2023 07:01:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.30 via Frontend Transport; Thu, 6 Apr 2023 07:01:04 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:01:02 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 00:00:48 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:00:44 -0500
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
Subject: [PATCH net-next v3 04/14] sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
Date:   Thu, 6 Apr 2023 12:26:49 +0530
Message-ID: <20230406065706.59664-5-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT009:EE_|DS7PR12MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 687600d7-dda4-4785-d640-08db366cb05a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPU4i7QgwW6uWR3HregUKgf4Qh6DRgX5AI4moZBD3FpXahTAF++Xwgy4jheTrZYXqSTwH0dRbhkeVsHyk7Ds6BqMPoQPY2x7RVkTQXc47kXaD2mw1WznOaLYkdkEQFnPiclexcMReCh3eg24u7foJzzxHMJD6Q7B/2c9tF13jowmzKKACNntvRseS2tKAURZFk+JUVRhS0VnK+FoOvxBtsy4bLGv4OwRNkOaNWb007Pg6nmMocaji+kIBw6QFDQAwipzDHji0fPSgqG/kbo1m5QKDXIi4QswEsUda0cxxmLi3eoBuOTJemksOyGtKB/cH1kPQC+wyq0qjrw7V8aD9ImxqSNMBLVFjlt4d+67gnVJJR0/i0ey6Yz7K4HPgkCNXa3ae9qZw83W6ZIKj/GNkiUs1CFWVhTrQ/IGtEq60h8ElK3/RcTBr/Im/i/UOOyL7DgofwekHQBqNhHTMTMh3j49MRKKQcDvV6Duqu5dXtZm6vQpIigQ/BABWyNzl2jHcY1DOza1ODGQ2OKlcsos7tXjw18/nRQzkZfjBOKCwT4rEqgmj090cLnCgnTgv2lILQCZdzN3jQkf0w+oL5rPL7uVz3B44pQ33Vk/gGYaGVv5pdBtp4iZI/faG1AXby0LJmcOjtTdhF80UeFjSzjcrXC6ewjfd4Nnffd175bcyvhlw68iYPY+UjA5gT61orExbmMdF41Ng1GpG+aGDwp0NZeNP8FrafNUOpA5QelVqB6izk7RBVjkDy4efiHLyqfr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(46966006)(40470700004)(36840700001)(44832011)(186003)(40460700003)(1076003)(26005)(5660300002)(83380400001)(47076005)(336012)(426003)(8936002)(7416002)(41300700001)(2616005)(70206006)(70586007)(316002)(2906002)(54906003)(110136005)(4326008)(36756003)(40480700001)(8676002)(478600001)(356005)(82740400003)(36860700001)(81166007)(86362001)(82310400005)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:01:04.4761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 687600d7-dda4-4785-d640-08db366cb05a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6239
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
 drivers/net/ethernet/sfc/ef100_nic.c    | 43 +++++++++++++------------
 drivers/net/ethernet/sfc/ef100_nic.h    |  6 ++--
 3 files changed, 49 insertions(+), 26 deletions(-)

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
index 54b2ee7a5be6..498b398175d7 100644
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
@@ -198,25 +198,22 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
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
+	if (IS_ENABLED(CONFIG_SFC_VDPA)) {
+		nic_data->vdpa_supported = efx->type->is_vf &&
+					   (efx->type->mcdi_max_ver > 1) &&
+				efx_ef100_has_cap(nic_data->datapath_caps3,
+						  CLIENT_CMD_VF_PROXY);
+	}
+
 	return 0;
 }
 
@@ -820,14 +817,12 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
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
@@ -1203,6 +1198,12 @@ static int ef100_probe_main(struct efx_nic *efx)
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

