Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF4683007
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjAaO7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAaO6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C285526BB;
        Tue, 31 Jan 2023 06:58:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnmpWkv7y9sfVnH6LPSc6NZyCl51TYtXCcogFZfqoT8yV799FhQactUemTKeAcs6l1DndVQY1Mf9lulTbbsPs7c5qWioo46rW41rGRtOiItTNhFbbZpSNp7hJeJeD/k4oATES3g/57h/mNpA9zLqi9Za3OdGDCCSAG/JOXzt80h8M7epmyc8PFKSNDsYCIpB/HNYkwbGmPdJc1V0XNiOU7u3JgyUFdfEWgckmF4rdfgW5dquWw/OpEsdGwFILPfG9eyU1wL8IG3dYFCUZgluQav/xd+V6HZ6nZfWdzVYvcIdAY9rWmhRbM33dPSNoMkn3SFgcLeaDABSvxEW4z+zqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDMhZFOyzmtTJTTvWlpKjfCTaQ3KE0ptNvOmsmEV0Hk=;
 b=VbIl8ekDus3G1qqjwltmL+2VHHcCuFXlL29Ahm8551MSHspvxW5kdE0PAOsQYaV6ruiKqzAzyhQ9WyM8RueI6g7GHBDRXTb6Q6FnPlNol0BAd4cMCZu1XblbaBcVAAm2Eneof6sXfjYfwLQmMj4VkDyyouEyg0fWmluO8LXG+nXdr0zeNQrGlBfkng9m2Rm97ViYQarA77X7jRL4gfYqLXLS/i9BNLTiCPxJJcfGnB+ZqQKXr2ao+zje5Br6Uthv6ikZIfzPaby0/ouv4absIGoWyNSMGk2UUgbBHSVYN9Ttk17Z8SlBU0gnLZpHAB/+xzkMoIy3FrZP3tKqruh4Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDMhZFOyzmtTJTTvWlpKjfCTaQ3KE0ptNvOmsmEV0Hk=;
 b=MPpTkoGKPpJd3ALoPsx6Tcm+fmGqQAzgOkH2n7byD8ttdKFDZ9ZxjeoLDXEW2OFC0gDYMj0wvYCZytRyiZnRk95bh2zw+C8uQvjcQ2zEZ4vKLsXsdPDASE/sOM8kKJpU9mY4G5XzOuNdC2BuULe2BlxzCP7emMRNjSywU5ThW6E=
Received: from BN8PR12CA0027.namprd12.prod.outlook.com (2603:10b6:408:60::40)
 by DM6PR12MB4187.namprd12.prod.outlook.com (2603:10b6:5:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:58:49 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::b2) by BN8PR12CA0027.outlook.office365.com
 (2603:10b6:408:60::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Tue, 31 Jan 2023 14:58:49 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:48 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 06:58:48 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:46 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 6/8] sfc: obtain device mac address based on firmware handle for ef100
Date:   Tue, 31 Jan 2023 14:58:20 +0000
Message-ID: <20230131145822.36208-7-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT038:EE_|DM6PR12MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e22431-3d8d-49c9-f572-08db039ba8db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: su2geluOPNPQgG09l//vaPffTavcuxTWhhv2hEFNgClC3D7lhMWMpwm44g8sdRUPpu0/g0kSld078uJjS+gVoek2X3F3YDls/7sB2HZvseEFwjlHA5u/nnPXlf+SkkNiZNICIyChrZLQtNs+Lxb72e1NEuUQHrGgJNcCjYmXb1O+GURu92+PXqUcvWGn3ikRobTDlImoEvbbJsgU3tddXFLF6Wl/Hdq1fTw6WFi3+CeiKGopjwn+yHELucIqwLaJaEcwhVkiBYw5U8/2ApEEQivgWZexpiR6dstIyovWwnt3VKAfjr4Q7bzgCwnYkJgIJ+jAD9FK8eMTB13CZ35znNhn/34unTDefh+/x7rpFHcBlVVY8YqiSrBvtjWdYoWQVEeBUijxS5EZdzp4nm38bN0lHGhFuQGt5xGl7XU0FZIale0iWdPFnvAGxaXAV74rEpgbMOTFS4IlfqQ/hpeorJ11DDXWq5Rs1Sbp9ka+dLjH1IwNBpCHDvRY0flmVVJgXo9iHzz8lIB/m4dSrUuG3YX/uZ03lZXL05xHgykl4iOuh2Ci4SIz+ZRic6vIWhQ19vv5sriTxmbStwde+NKKXOxWq7b5/0gJlwjSzeeU6qLsJyObBR8EJmfnfWmnPoToRiV6T2GgIi8TkplZRJFhLdsfHR4wuaITLFrCgyi4K2nHXU6i4DMH2Gz097LZQNvbH3RPI8pfuDWyKrjcNtL/0ZfMAZupSNmEnjwNSVv1gME=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(316002)(6636002)(54906003)(110136005)(426003)(36756003)(47076005)(36860700001)(82740400003)(5660300002)(2906002)(2876002)(8936002)(40480700001)(7416002)(356005)(81166007)(86362001)(82310400005)(8676002)(4326008)(70206006)(70586007)(83380400001)(41300700001)(40460700003)(2616005)(6666004)(186003)(26005)(478600001)(336012)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:49.0390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e22431-3d8d-49c9-f572-08db039ba8db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4187
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/ef100_nic.c    | 37 +++++++++++++------------
 drivers/net/ethernet/sfc/ef100_nic.h    |  2 ++
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 36774b55d413..d591ad150972 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -362,6 +362,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -413,6 +414,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
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
 	/* devlink creation, registration and lock */
 	if (efx_probe_devlink(efx))
 		pci_info(efx->pci_dev, "devlink registration failed");
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 04774f33b493..bcf937fb3d95 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -130,23 +130,34 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
 
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
 
@@ -1116,13 +1127,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
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
 
@@ -1161,9 +1165,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
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

