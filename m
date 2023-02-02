Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00A4687BF6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjBBLPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjBBLO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD88899A;
        Thu,  2 Feb 2023 03:14:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHOxAWXqfGOW2WUbexsx6+CCQWDUkHZk5aqxKnpxWLSPP92jiZTKQvBumM6BSWuprQoi3VV+ZUjsduRcze6+D9c5mwIhBbtQtrkyMhnXixPVPX/tsY8iOhEi9q7n1JjK1wxlILZpQoT/Fsm0rHmSX1QE1Xxhorw4hdYFMMi5rEAcwdSNVikXr9zWnZeAOGY65qrWRS6anZh46syyjpSA9u97VLztwcnmLfsYtVczpx3jh23C65biJmJWg8j7j3vyzvtK+7cf/13PO2K7iOXej6WEY09AGIHTywoqjwZqf4QbvHZ6imacBYYLrhsErfK24Hh9oY/YGtb1ybCsTDc8Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfNdlfdb7iTPGKNeluv1GPIbMKaRcZseN1psY/sl4Ws=;
 b=DR8rLDCfOE+5BLvt58UiJ38FmGwxY4EYlSIk75hEHZ/LiRDd9oE1s355qlZXIehC8IJaoVXzAG4LdvSLmtTlGHfhz8+d1T10hij7+sUhdh0SUDK7cR85mOCtUufFetl3KENMFsLCY+qZkP2/nUHQ0NXmNvkIwJRRIW4SvvUYC7Ezvd1HXcJjUrKaV3QXSjaJmDYmCKOZR0NzJgV5V323zWysEa0M9Q/NpeIZwCb0NU0VK388nczSEWCCHbJh1zEintvTddTbdMIcQCnddTCtbX0FCDMbMR0gcYgp08PsIFZRzk8iiZgAAKg70t/YcBxIJB1wQgskd4dudFJnGJ/lRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfNdlfdb7iTPGKNeluv1GPIbMKaRcZseN1psY/sl4Ws=;
 b=Z+3wJPabjTMC7v3pmuidkRv2XgQSCA3XHVkz30EyuvAOTjHhXsHzkVE8aKPCwuHzVm1KRr3WlVM2rtQiDxuNiCpkVuM+qeVAwZJd2jFIi1j0c7x4SztTkX6fKzBN4co/CqnEpXLKGAImQQO9Zx6vMa8ofAgqF7V2GpP2eAtaCmE=
Received: from MW4PR03CA0160.namprd03.prod.outlook.com (2603:10b6:303:8d::15)
 by DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 11:14:56 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::51) by MW4PR03CA0160.outlook.office365.com
 (2603:10b6:303:8d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 11:14:55 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:54 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:53 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 6/8] sfc: obtain device mac address based on firmware handle for ef100
Date:   Thu, 2 Feb 2023 11:14:21 +0000
Message-ID: <20230202111423.56831-7-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT050:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 2307953f-b127-418e-811c-08db050eb6f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWGhcrKHARl3ZRtaZIME9NyD9Z2dVrzQIqRk7q3/llrFq2JWPhKEQA8SgjyXFD3WCRU8aAJ3pJN6UvcuRzZEA8jt/d5JW/2iPuQx5b3amIH9EorB2gQOLM8e8qjlgZcnDaqKksbJvEajb3kOvqpLRale8Y4umz+piwk+beKneHAn4j3v1SBg5cwAXV325H025C2Zayi/kmtrKo6V4WZJcC74486P/sf6j2WpoKxUMjCuIFhK+PM2mFwnYGl4y9UUwUeNV+ZvNyDaCsTT1u2Qn3EbaaBna1uPBnfiACEpbKDf6RUCgTo3ewWwLsvCpQdIZmWCS2NP3pwWdUKlRQTB9FOk5/0hjOi4UZNcYxkxyy38yXDjqV2+CzA4klWbj0hdUcMXbPCQaaKlyXaFzGzt5GfRLUElTO6hlM1FzpwE4JPZTYRwmYDBKEqXGtL0UnpO88W2F2Qf+2Pm1USngqlaTVHQoRcTN8Oeu8cupjvExic4ASdKnODpD/xAW+q6I8MHKVGTro16hzCa6XBBIDAxDqoOscNWYgYZysRWbbgbl2V3xdmLZxgwWMBxi+OryWm2UNRRmtFZavEjL9ONYRCgp8T8utb4snmNqfdYEyIz1jUpkBvI6/1/fsWF6uuuUYY3G5XcFp61LhghPEu0lc5eVRxUELFEtaW+TkGH8nMJJPsRjw2WgXPio1Q9BfurjZhwf0Nk9K3QrvDRuFih7nvyCnt1nQ5NGgYF2EN6BUQDoBA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(2616005)(6666004)(54906003)(6636002)(8936002)(41300700001)(70586007)(110136005)(70206006)(8676002)(316002)(4326008)(1076003)(186003)(356005)(83380400001)(47076005)(426003)(478600001)(86362001)(82310400005)(26005)(336012)(36860700001)(36756003)(7416002)(2906002)(82740400003)(5660300002)(81166007)(2876002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:55.8431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2307953f-b127-418e-811c-08db050eb6f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322
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
index 36a5a514b717..3dee75169b3a 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -361,6 +361,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -412,6 +413,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
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

