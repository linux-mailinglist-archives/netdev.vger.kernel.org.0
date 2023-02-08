Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF668F0BF
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjBHO0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjBHOZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773DE11E8A;
        Wed,  8 Feb 2023 06:25:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duNz7941zAAaLgHsMy5cLEONOFJhfgGorIHpWaNd1+/xeTf4JPH/iexkhqCuOtcJ43zh4H9NKJoG75HTkLrkHzw0xzsek+pWHxoTZ/D0lI3Hw0Y2Cm6M1x9MF5ULR9yoXAj/vIXQ9FWNgN0KMByb9IpzmXClNBrO4XBx5OFmsNR62HFyvwPJGp/43A3NipZ5LkvmyFIDd1H59QSWrTkvaPZ02nMkQ8g3/maefpXnunzaazLxieFQL3gF5hkmvGUxrpNPs3t/1VyzZzOpSXBa2bNHf3enrooQpuhRZIvhUYsJrf86edRAxe0OSwz9IEzV/rkWS78NVR5zLpaxrQvOdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BbxAfk2GpdmWqxFeecB2ACon4mezrRu5oD+nuUG2AM=;
 b=IMaZA3hAU+8YNZc2/c//fNDpaU1gT9wzT8yxw5Q1AR/H4oJ2iDYPhdokU4SIxlznb+4gB7wvZBIPZibw2u67IhyD/heQniUqWktcwDDtpmZ3avQvjmO+iEbJtozTY17Bn15mpMoiSqr4axkuZ6QfpejPuhfg8ED2R6l5QlkWAPK6dN9sxMWJQw5lL/SSkDYB7yjwjqF5JNJjaz+rXRpd70eTTt/VkvDx85YGnY5jfP8AJmQvBZ+26iX3d/MXoYlf/oVREeOE05I3wEkx1iidcMX+61IMus17XIjhelyhjTrL9Yg9w8u6wpo70TUI1lfeJIDU2xOfl6aHt6EnoyrXvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BbxAfk2GpdmWqxFeecB2ACon4mezrRu5oD+nuUG2AM=;
 b=ZMmMyagMm/IG068b1aVfIA2eb5yzGpKdMsYzMPOKzpncRRUyAT9X71PCXWZ19GF1/1Cz7LPzywVYDlMz1l9Ko3LEeyXIFXWBl8OaKyRxBfvRh45wQFhF1SwBrOSrCSQA3jRS1Id0uZnQUGNkSJOLOsOlS+83uPEbsv6RPVNSp7o=
Received: from MW4PR03CA0311.namprd03.prod.outlook.com (2603:10b6:303:dd::16)
 by SJ0PR12MB8089.namprd12.prod.outlook.com (2603:10b6:a03:4eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 14:25:49 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::5) by MW4PR03CA0311.outlook.office365.com
 (2603:10b6:303:dd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 14:25:48 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:47 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:46 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 6/8] sfc: obtain device mac address based on firmware handle for ef100
Date:   Wed, 8 Feb 2023 14:25:17 +0000
Message-ID: <20230208142519.31192-7-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT004:EE_|SJ0PR12MB8089:EE_
X-MS-Office365-Filtering-Correlation-Id: 6930938e-6021-47f4-1a52-08db09e05ff9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QdRPzfbsKSYWRDC8G3+bqV7JUe2LMsOEvYj3whpjpQBliiXPRaxFJOvqDg57snxDb4GbPRM/1+uqkYFARkvt7vQMFtIEKGQHSH3AYCAkWnqqkPRODrWfDopYf2i+xH0UmWBcu0a8kI8Nb2w1+NaxTAnbC4u1vwYxlBTab6ebzod7zbXBIZsALkEROvi5tIWlnkHEfPwW60US3hb64zGKeGsKc4MGzVrBcS2is3wP4Afz5pFsVJyJSsUq+1m99hWPdDK3ZVAa3a3AqRMKdlUhTqvL9ff1k2yAJPetklzy1bSJ7Kl3qJR/rbGJRwXzmDwzWDhqMIgt2g5C9OVNGHII2aRACE/7wjO9qZ/2/zYIwM7xSfawKJDome4J7GuK9k6Ev/ARNJhX9gnClqtn49N/aY1TQucnAPgkImfnkwC8a0pZOQblOmDBLbmm4EgdtLYh3wXRTyW8Xic1YDxUw9nqz9krfLVkPj2nmK88IhU8pxyN7Bnw48lm896FTS6PUwtzv4tKPp/z9wR0DM1+Y16iy0CC07rv9cxuoLHtPrNY9DU4J7oHXxeiZlRg/7tZEMX6T1Z5ki+uhUJvVeC/cry99m0mcZd82jdtMK7qbXfS3fNchOcB3VGHqC6LzXx7CO4zarfcWzDpRCex8YZLtfrtYWiXIQLCTL1HUUYF9F0UOVgdoNnJZradUE/PUTi/RnBhA77Mgf+7Di1c7T+OFqURj0B5IiUlU4dEXiYVCdgLgXk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(83380400001)(70206006)(70586007)(316002)(54906003)(6636002)(8676002)(5660300002)(8936002)(7416002)(41300700001)(4326008)(478600001)(6666004)(1076003)(26005)(186003)(336012)(110136005)(47076005)(2616005)(426003)(356005)(40480700001)(36756003)(82310400005)(86362001)(2876002)(2906002)(36860700001)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:48.8042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6930938e-6021-47f4-1a52-08db09e05ff9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8089
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
index 368147359299..d916877b5a9a 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -359,6 +359,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -410,6 +411,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
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
 	rc = efx_probe_devlink_and_lock(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index aa11f0925e27..aa48c79a2149 100644
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
 
@@ -1117,13 +1128,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
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
 
@@ -1163,9 +1167,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
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

