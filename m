Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C176736F1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjASLdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjASLcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A0874957
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhMS6RIG3e9EoyRc0AnMc2PUMImW7rWNeYCwLo0nAfIvggNZ03afQaQyox42FRQ/2NpEtJaRhFKSWm1gJmShJUMisHruQMThDUW2UA52VWLv7iEvUUcDmImRTxsuLuRZDm0FZ4b1ZNU4tlWfdO9UyVKk8Mn2zrFk+cWfzf5e/vtDhfBdMk4TJJlAC8Jm+AcjSf1HjEudvrrp2U5VrA+3D52rNssMeS4ZK6Ixw908xQBGu1UWL/Yap+dRSE1uUSnEEAfPMUUvPPwBlj01sAnXKyN9xs+cluh1W9SCR6lC8n61YjKPOG9Lxg2fd3CNnMH71PnXnE25jtT/v+SADFaInQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSH6VsKK067fwBbTlPdsk30SITGI8+bNJHkyU6UgGCE=;
 b=fNRwBHRwDYq8aHePJgFVFfyBc48UCpVp8swRQtFjsja8ThB1ynk8Vv8x5ff8kRHengTkS6d6gPtUNOAA9ocBkocft/dILGkLuXTWJfmCppanTZyduAu28/b/mMsDnztFW/hHJRIFiqMsFAO/A0qG/runkLujzoRFuP51HsyEHP6l1tUeJnnHCQ+fjDdi/7iHgJogycLbsvl/0k65YpwRvTtzeLP64599YS/TKfM9vVfzqK99d5Zbk0+YF17VOOJ2bNRsRMDTwYcKZt/tv1+8NlNVQqmtxBU8bAw2uU+uTq6XHMGywZgb0ENcKOHS5tmcCLH0BNNZ42M9wrlg1X/WLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSH6VsKK067fwBbTlPdsk30SITGI8+bNJHkyU6UgGCE=;
 b=AkS30SRfDtf9GgFrtTkg2pD4WGevvRii/0PAES/Me9LW9BTzWKOJbfL7+7fSV1916hIqGGZfM0FjX4hLMJw5PpxfGF3GjEk91dEkCY5w7OfmUHW0Bxs8VH0dPnuJz/wRKrYWJ8XTqFq2/JMq0Ue8FRKA9URB/wkg7Jm7cIIEY1s=
Received: from MW4PR03CA0328.namprd03.prod.outlook.com (2603:10b6:303:dd::33)
 by IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 11:32:26 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::c9) by MW4PR03CA0328.outlook.office365.com
 (2603:10b6:303:dd::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 11:32:25 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:24 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:23 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 5/7] sfc: obtain device mac address based on firmware handle for ef100
Date:   Thu, 19 Jan 2023 11:31:38 +0000
Message-ID: <20230119113140.20208-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ef6136-8ec9-44ac-7858-08dafa10d6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hiAnfHwHfW1n9SiSfXD9FHBKwxSvLzw07Hmq/k7enG1bsldxAnCFe+OppA3BpACgQFT4GtjKecGfCsgCy02zjpz5cdUoaas0MCXyzKq8TDt5fc84Fz1yrJq8NAGfct1Vgs7ekHJc4TelokSj7fvQmQkkaY4Qjho5iNbhYxZ8JJQJAKpmtnvBBO4wRsxbMkVX2Aiyr4qLEcO5HOs3a6t3PH9QbfcJUxO+fP3ogXlTbsxJTxHlji2aHTt6iiuBIBmHOx9NvQ8ywP1rNGxwwQ443Z71+AzGvwnJ91J3XDUJ4pSRewmaWI6njeidut1ikYqnHRT2j/D7dmJD0sR/m8eepwab9/qIiGeF1Ox1JI6+imE2XbJDy+iKPY14C3uVQD9U9bEez0NsO3GhVVotN11KSqPxgv/CeeZAPpt/lAcpf7ykIhwPhBn9YyRnOhmZVGQsIq93mrSEnDodvUJG4ND5yIgryNAzdVdsHH3qeuy2pIuyL7dL7m4wOs03Scw16ZpiqgZOZzKOehTuv4Lk3GsF/siUFyaJBJHEeYfkwWuEw6vg5S+K8DNK3dHwM96qzFlBidXNraqBoY5vLo4s01Z4Sa5J7m9RFP1cW6p4YCwUfnC+WJECwcvjgniMmAPB9rdUQxPBrh6Hp+DWDiZwIFMvXPN2yUf2uK6N1+C3QdxGc/DQQxwPl+kdyrxs6QL2Kipg6d7wWUuPIigEtuErjyXL8utkxGtkr22evAR6grJn3wk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(81166007)(6636002)(110136005)(54906003)(316002)(2616005)(82740400003)(4326008)(5660300002)(1076003)(8936002)(426003)(41300700001)(186003)(8676002)(36756003)(26005)(83380400001)(47076005)(70206006)(70586007)(40460700003)(40480700001)(6666004)(82310400005)(356005)(336012)(86362001)(2906002)(36860700001)(478600001)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:25.1954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ef6136-8ec9-44ac-7858-08dafa10d6a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Getting device mac address is currently based on a specific MCDI command
only available for the PF. This patch changes the MCDI command to a
generic one for PFs and VFs based on a client handle. This allows both
PFs and VFs to ask for their mac address during initialization using the
CLIENT_HANDLE_SELF.

Moreover, the patch allows other client handles which will be used by
the PF to ask for mac addresses linked to VFs. This is necessary for
suporting the port_function_hw_addr_get devlink function in further
patches.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 +++++++
 drivers/net/ethernet/sfc/ef100_nic.c    | 38 ++++++++++++-------------
 drivers/net/ethernet/sfc/ef100_nic.h    |  2 ++
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 4a5d028f757e..1a1842bd6e12 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -360,6 +360,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -411,6 +412,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
+	nic_data = efx->nic_data;
+	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
+				   efx->type->is_vf);
+	if (rc)
+		return rc;
+	/* Assign MAC address */
+	eth_hw_addr_set(net_dev, net_dev->perm_addr);
+	ether_addr_copy(nic_data->port_id, net_dev->perm_addr);
+
 	if (!efx->type->is_vf) {
 		rc = ef100_probe_netdev_pf(efx);
 		if (rc)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 38c809eb7828..f4e913593f2b 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -131,23 +131,33 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
 
 /*	MCDI calls
  */
-static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
+int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
+			  int client_handle, bool empty_ok)
 {
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_MAC_ADDRESSES_OUT_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_MAC_ADDRESSES_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_MAC_ADDRESSES_IN_LEN);
 	size_t outlen;
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_MAC_ADDRESSES_IN_LEN != 0);
+	MCDI_SET_DWORD(inbuf, GET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
+		       client_handle);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_MAC_ADDRESSES, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_MAC_ADDRESSES, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
-	if (outlen < MC_CMD_GET_MAC_ADDRESSES_OUT_LEN)
-		return -EIO;
-
-	ether_addr_copy(mac_address,
-			MCDI_PTR(outbuf, GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE));
+	if (outlen >= MC_CMD_GET_CLIENT_MAC_ADDRESSES_OUT_LEN(1)) {
+		ether_addr_copy(mac_address,
+				MCDI_PTR(outbuf, GET_CLIENT_MAC_ADDRESSES_OUT_MAC_ADDRS));
+	} else if (empty_ok) {
+		pci_warn(efx->pci_dev,
+			 "No MAC address provisioned for client ID %#x.\n",
+			 client_handle);
+		eth_zero_addr(mac_address);
+	} else {
+		return -ENOENT;
+	}
 	return 0;
 }
 
@@ -1117,13 +1127,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
 
-	rc = ef100_get_mac_address(efx, net_dev->perm_addr);
-	if (rc)
-		goto fail;
-	/* Assign MAC address */
-	eth_hw_addr_set(net_dev, net_dev->perm_addr);
-	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
-
 	if (!nic_data->grp_mae)
 		return 0;
 
@@ -1166,9 +1169,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		efx->fixed_features |= NETIF_F_HW_TC;
 	}
 #endif
-	return 0;
-
-fail:
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 496aea43c60f..e59044072333 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -92,4 +92,6 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx);
 int ef100_phy_probe(struct efx_nic *efx);
 int ef100_filter_table_probe(struct efx_nic *efx);
 
+int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
+			  int client_handle, bool empty_ok);
 #endif	/* EFX_EF100_NIC_H */
-- 
2.17.1

