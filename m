Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596FF57E420
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiGVQHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiGVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D4E743FE
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXOifoynCW2AxKPV6dWd8BCmjIOFQaPmuVLi7EehYZTXXWuhDb3bD/dni85HOGsstvXEm79nq0ggJOSp/mpL6uEfp8LGG1UqQLf//rvdSfMVYiT8fX4hemnFF0gCDSHAd7EjdHxP9f/bWldHjjRCGpsGs5pMGQIUGwNGSBWFC0/rNkv9RwIrGGdXV57TvfvAPn+5wa1xJP57e5LAr1Jddr4Oao+Y4fxrRPSAHRyrS/wevZ4VEQTRqGofor/tltc++hxrMjm3PRbOgEiZa+ZOdUA8oVtfEB3OyGF/+fjZl7o+7cTuXGGRn8SH7NQbLrJBTlc+7/Bse4op93xxoZTgJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmDo2iDLAUXYmPVBWYckcdzusRIMc1BTALtYgaAuezo=;
 b=li+OlIner9zq+pw//EALrOj/h1GOOwcDpbyFSBISLI3/nvyY3ee7lUmQFKYVvA0itFwFXn31W6mnAsA68ZGbaw3nBQLCqXNryfx3Jrr0u9H6cLvO1wfN8yruW2k+dZt7gOsgUrzL/dmD+a58ey7YyaNdFxmd9f6IVeIrympWu5niJwhSSlWmj/6oSHk4bOHRUFCinuaukwE2gpuiBZMPpQ+UxvsiFdt4C5g2d0YoJosJ0PyFM/Zusa1RSdi+8HwNmXfiPecvoNGuMCFZPe0cnLhL1Ayyfo8caLsWF5OoERg0xppUivhGMGo05jl8AkyZ9GWNwtJuRX65nXpcl7dhdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmDo2iDLAUXYmPVBWYckcdzusRIMc1BTALtYgaAuezo=;
 b=gjmAwK4pTLVzxT11CG49yrbxmxBYccdOAeW4A0tMcKJhPY7puhWKKah7Gr13J+P82JQDgifoKrSSrPL+akl4SzyLVAsb803n9E+5k95a2s0fHNnd8zSle7hno7h+sw9iXpYirHkVWfxe2EQJUB42CqYVcGzBeDEr3DiiCZiHe9jhB3uKJoJnyripkkGePCqwKie7l+fn9apkeCK8gykx2otsSXANGQTgypVDYsv6xVhR8uCiVXAVRTaePGpBzrGE0LPl8gbJ/VmNGMsw73yrfxOgjMfgpW6RVkgIpaGQd4D3XqmEZ6t+CtJQtEL8a7dxpym4+DktegEkRCq5/tvrOg==
Received: from DM6PR01CA0004.prod.exchangelabs.com (2603:10b6:5:296::9) by
 DM6PR12MB4498.namprd12.prod.outlook.com (2603:10b6:5:2a2::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Fri, 22 Jul 2022 16:06:35 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::af) by DM6PR01CA0004.outlook.office365.com
 (2603:10b6:5:296::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:34 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:30 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 09:06:29 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:28 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 11/14] sfc: fetch existing assigned MAC address from FW when creating VF rep
Date:   Fri, 22 Jul 2022 17:04:20 +0100
Message-ID: <4d69d6afd36bdd07c6e15a4210a9e3133a382bf9.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 595c84e0-9cf8-4005-761d-08da6bfc268a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4498:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oDL5i+zP6sOtbZRK3LIuIsugPMtkHWAxRv2zubzqrs2h1cYLpP7SNt1gZWnjmIgEpMovsyBrzTkpDs8sfqAOkv5OZs7NhNlaWckH+Sqr5kuyUgmKqhjZtsxSgKg09ZBpdrYTH/N7lG55yoUcokik7dYMFAJoiey3it3hULbs6wfNWADU60sfdT/4LsahGGI2PrjXeG3G6tGvTA2VGEyLL61FvVhoOdp27KlDbGGMha8j2LpIpoUeb5wpEhTve8osuoj+eRYvmvZCWKpALn9L9rDlIIh6vucJQxEImth+qIm8t7TF9WDSryCIMLwsYlB66t2yKBIYBI3QpOR/ivSOjvwaxH1Koaym8O2rta4va2JUsLMItISlZCCkLo9dltqc8BDTobZLVGcO/yIYPUSC4Lm5BZCJwLiqFj5TXk/m+vFOvPqUDU6mLbyliq4WYUwieD1MDY5zLQ8jOJWdlZUsEFYc57LcvlYAqLzg7JdV1KA9SCe3axtfx01mpvwt1jOPq4B0YidemiRnyZ4hxQg4WvArJULdZIp8mRaEXyxuNHnbPNymMi4V3CLlvwLVMVouohSWtRijBcKyp+TI/svbQAZ8Z98LYah5tR3Fjc6SXaeThn7abptmdAON/Mc2ZHX/ohgcapInHAuCSZHZAyUk0bvuOt6jueLIEFo4IDMLdSpKm/P+SnIdIMmhPUTnTZ4eEo8NunwtH7QZdZxw0VxmrnsxsJ1B7D8kEy1FTgi79xsnyKVydH+/pkgmlAj2GkjALp441jh3QqfEG1k8YN0IUj6qljfPeiFGRe4J6nyh6SnM0EVu5xsktqU3vaw9exRyP3nwwrXWC1WdtYQuT2Pzg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(396003)(136003)(40470700004)(46966006)(36840700001)(26005)(2906002)(36860700001)(47076005)(336012)(6666004)(70586007)(9686003)(40480700001)(82310400005)(8676002)(40460700003)(70206006)(81166007)(5660300002)(356005)(8936002)(36756003)(4326008)(2876002)(83380400001)(316002)(82740400003)(55446002)(186003)(478600001)(110136005)(83170400001)(41300700001)(42882007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:34.7791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 595c84e0-9cf8-4005-761d-08da6bfc268a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4498
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

For the sake of code commonality, this changes the PF probe path to also
 use MC_CMD_GET_CLIENT_MAC_ADDRESSES instead of the old
 MC_CMD_GET_MAC_ADDRESSES.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 32 +++++++++++++++++++---------
 drivers/net/ethernet/sfc/ef100_nic.h |  2 ++
 drivers/net/ethernet/sfc/ef100_rep.c |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 7ca4e9769455..92908640a0a6 100644
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
 
-	BUILD_BUG_ON(MC_CMD_GET_MAC_ADDRESSES_IN_LEN != 0);
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
+				MCDI_PTR(outbuf,
+					 GET_CLIENT_MAC_ADDRESSES_OUT_MAC_ADDRS));
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
 
@@ -1121,7 +1132,8 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
 
-	rc = ef100_get_mac_address(efx, net_dev->perm_addr);
+	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
+				   false);
 	if (rc)
 		goto fail;
 	/* Assign MAC address */
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index cf78a5a2b7d6..5241fc1d928e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -17,6 +17,8 @@
 extern const struct efx_nic_type ef100_pf_nic_type;
 extern const struct efx_nic_type ef100_vf_nic_type;
 
+int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
+			  int client_handle, bool empty_ok);
 int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
 int ef100_probe_netdev_pf(struct efx_nic *efx);
 int ef100_probe_vf(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 3c5f22a6c3b5..ebab4579e63b 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -199,6 +199,7 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 
 static int efx_ef100_configure_rep(struct efx_rep *efv)
 {
+	struct net_device *net_dev = efv->net_dev;
 	struct efx_nic *efx = efv->parent;
 	efx_qword_t pciefn;
 	u32 selector;
@@ -229,6 +230,11 @@ static int efx_ef100_configure_rep(struct efx_rep *efv)
 	} else {
 		pci_dbg(efx->pci_dev, "VF %u client ID %#x\n",
 			efv->idx, efv->clid);
+
+		/* Get the assigned MAC address */
+		(void)ef100_get_mac_address(efx, net_dev->perm_addr, efv->clid,
+					    true);
+		eth_hw_addr_set(net_dev, net_dev->perm_addr);
 	}
 
 	return efx_tc_configure_default_rule_rep(efv);
