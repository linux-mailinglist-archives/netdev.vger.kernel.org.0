Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456D5694F7B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjBMSfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjBMSf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D8F16AE4;
        Mon, 13 Feb 2023 10:35:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsRqVIBRtvemb0ITT/dQrKH62XGZpufpBY41jAGToTjcN9++4oTLaJ1Vk/Nr8JzGV02zK+VNXO6NYb87ITrkmO6XLids0YB7NxwmaxYp2gGLAOunVNDh8QomhncV3WdUZ+Umd6h++ClRmmW0CP13rWFo7eABcuSGfIQd7JaRR5O46pwL2+2pasFFLjgflg8ANdc/Xir2J4xESd71hYoh5qMda9mHMwb/9A1mCTa6doYsQoAn5sJ30B82iQTI4wn/Lvfi/0hkm3ApJIbaZAX3VkXmLl2GwmVuyFsEC64zy/8xW6KcALNSu13dkhixjTPL/idunE0rVdG4WZGryqh33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ctdc6qyStytXEYamuhZtEVEBWQrivfURIzKu8q6KOYU=;
 b=lIPUMvTYdnx5h6zF/+QDDylexSJScrLWVACOtZmV3Ri2wFs+XVPkQacfrJV/OcGpE+OscDcWrHoFWmKd5TGv5xfJWhfJqTZHQ3l5M9u0++/AZVIiu7CMM6B583JNvQCrG4RxiPelHkIn90e8KJTS/bIAo/AmnWO5agJjvKmY3MOCuztUbD0oQOzWNkNQwEvCiiut4NDlEbj26QPYkm4PlgMRrBny7A3E1rWlMvSwGjzOs7pqh3zhOq7mTInyGBqJO1PZCvH+rlCZdQ0seM8m5v92qy7Y/B/DDyqf5zCvwDuiZqHn9CtFEagHoltTYLHITEQqiemj0zxYzixM8LZ6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctdc6qyStytXEYamuhZtEVEBWQrivfURIzKu8q6KOYU=;
 b=cwJKTdmXUrvgHeqafYdHpHRwB6J3uaMiWaVQ2vcOF4a84DVC3VZqw2IhLpgpen8+VK0KKIgjoZEBDRg1NpEF0Hv7CnztAcxAXZP91FvikRnERnuqeQ+WaqDiU68rP34g0o+gQK563k4MbSTxHfX/a4qrBYFDXi5bAxcHtNgPGgA=
Received: from BN9PR03CA0214.namprd03.prod.outlook.com (2603:10b6:408:f8::9)
 by PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:35:23 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::da) by BN9PR03CA0214.outlook.office365.com
 (2603:10b6:408:f8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:23 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:22 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:21 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 6/8] sfc: obtain device mac address based on firmware handle for ef100
Date:   Mon, 13 Feb 2023 18:34:26 +0000
Message-ID: <20230213183428.10734-7-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: a83e2c00-7ecb-4e16-7607-08db0df11155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTHSDKvjHujAQHNPoZXJPV0XdRffqmwDLkLc/OzNzWIXUhkQSCnwTTHAsqR3ZVrWlYWWqlRewtFLZGuSsDM9drWOAmHvWXMrpavawGi/Ia3UNSYJszbJ16f2sIUgtImI7GYM3o5w6+RH6s22IMSOoG4PY1MDbpi95dJgL4SzjwUlgFFlCjKy8wPS8XhTwl+9lnTE3QTSGsxXVkDMIVXZUG0R+lT60Hoel3Mz+iTy/eFlyZ+ufVbtNtP7pmmT4hldbGj/vbYXL++Vy6Nd8nwS1jUbCWGeURflSOP9Fsu+D+UuPKr4thQn2YazxoHu9s9NbAP70HHzgcsYuyJQ+/1njELrxuOCsuqi5NFVLNFvyjqr6jY08oaLpbVTXkat5OvQRAV8kp7L0Oc7U4378DObggzmRXFr6CeZ7GeDaB7ZzOSdVJ8dh2nJWpUVgybp8fgGEhNwzhENfSKqHXckETpQUXXUmCWsUpKFHrr+g8u2+h0v2leKUf4Ha2qbOf8CM9n6B4fXRjtyS9BlS6lmtjeyuDQ5Cg2RTHM4VbduDow8kDzkQahZ4ARmlOHOuAmbP8bpfxoEnNmMB8l5OmGgQNAWmtL+BgD1MoaC8btm4/XQkyLkCn9sC5hhu5vMQA8F+Ur0WM4EYtQWT6UmqOiRyAIlcBTU/NCmNZAg+suWHeezObGsqWl1BJQ6ignInAy9wg4LDA/uUNpJmbIT0HQN6UPnypk5AyqkAL3ES7ZMti3oD6M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(8676002)(4326008)(316002)(70586007)(70206006)(1076003)(41300700001)(8936002)(7416002)(5660300002)(36756003)(36860700001)(86362001)(82740400003)(356005)(81166007)(186003)(26005)(478600001)(2906002)(2876002)(6636002)(336012)(47076005)(40460700003)(82310400005)(40480700001)(54906003)(426003)(83380400001)(110136005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:23.1525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a83e2c00-7ecb-4e16-7607-08db0df11155
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284
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
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
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

