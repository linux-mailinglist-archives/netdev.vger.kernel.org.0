Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C90583263
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiG0Svd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiG0Su4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08608C5BA
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwCCzB3noO/V1FLvmRPsvhbijRMY3JMHr1YABAOUIOFLYEKB30MjnlALQJHqm/XKNeXHy3SRabMQhFkSo03luXlic23E7yFeuUw8q9wTphlZRWa3H3CLpRJgJCtFxxfkDmXcvN77D8PmyXUIcimocpEdS5T7KIRH0mjix0Uv21sWPZ1RQOXAIJFL4hjw8DW0m64pZWGLmpBj4D2b6eRYE8vn/rZ5y9fVgc3m7zRZxMORybF+rN0PSGAhOMMafaQuP1ourP65JcpIN6QN7IfJZg9ooTI40AH9tRUYj1VzYCwaI5b4PEfEia0aUdO3lCcRRgR9imdtywdvPk+8KCKxWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCuiJP1zMjOVm+gSoO6XU2QhJihf7tJgBqnDBXg03y4=;
 b=JH4RBS9gA9RKSnxuslwz3FRuTwsl3D4XNK8SCtjVSusbXa9amAHy4LLCx1f5DYsH2dmLWKnm2WNw5de8wra2GZhbEof0oSWK0rhjOBQh6e+7YjpZayNr1BQ6vD3qr7h1xIlz7AfAOqKQrfe/DbM5UFXMJ8q4kJywjLfTu1fxEZr8nkuiXSaAwJL8gwobzbDhsvvsA33irHZZKA2tERATwRIXuHjSJUR7H4uyr2lsjbjvzatdNTCVF8sAa4szeW4SOTD0Kvssp5N+/Px8Shqmj4r5S6DyjVzDS3DS33oMGcAm9yySaU8SeYqqxlaIddrWmYzprT9RYphuhsTClKcLzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCuiJP1zMjOVm+gSoO6XU2QhJihf7tJgBqnDBXg03y4=;
 b=A562nc5d9/6ok7XpkaKK+ZLbnYw9YkmR0hqRqxXqn1P9MUaWkyVDA7gsEkz2MTG1pLKSmSAIYIxb0rskxHxiVLW9ffm2TVZcu9VP1tVEjpGl2lGaS5DOe1DXpaqq3uUMVdstbmXPkPfD3Xbq7ugIRGRAOSO3Q3ATs5KgA2dRlEDjunqIdTpAv2hbxV/jamsVKlguB0OqPtSEmrgwT6bwJr0Yby9UCwUo2z374HqBvcdRJrebPiZQSk7v+13WOw5aDFx/yeGiDQ7gphUZcRkINcVNQCL8WQUu02ckUzW9T7t9j03miAiWQdUi7QkI0bqZFxdFm3OdxCnJKBKC0PnFCA==
Received: from MW3PR06CA0007.namprd06.prod.outlook.com (2603:10b6:303:2a::12)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:07 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::9d) by MW3PR06CA0007.outlook.office365.com
 (2603:10b6:303:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:07 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:05 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 10:47:05 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:04 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 11/14] sfc: fetch existing assigned MAC address from FW when creating VF rep
Date:   Wed, 27 Jul 2022 18:46:01 +0100
Message-ID: <74faecee040a5dd9c08c404f04afd4ad0d2bb6fa.1658943678.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b9affa6-f6d5-4511-3454-08da6ff80657
X-MS-TrafficTypeDiagnostic: PH8PR12MB6796:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJ7hpEv0G9OwBjT8u77355YUGRMwUZ8TjqxxMu8tnLK2jcciN4Bf2Uv4/HhGHtNGPo9jAQ3drQ0ubVfOSKYOyD7j4GJduIhchTlE0oClEqhI/NXcHsr6DwfDScmJE1rAbIf4Gl5e0CPaByjuyvZ4heZxEFD24Pnfs83jCGi6lxh2qZOJa08raHVhdUkXmpP+MZosfsi4SzXx3ncTPt/43bKxt5b2D67gXHibA4zk5mDSeuVgGtZTqQWpFv0XgrB73SwAXz0u4pz0JY2UgaZYp2tbKz8BjK/bXS3N2F56adlIQMnhtT2ypQ12SLsz1k+9UJtnx4a5j3bf7LdNNab0ibDFhRvKAp1GSO2ZHqy6Hx+11uKg97E3oEDZlUtOhil15lMN40dEWqeY3wH22SjuM2zI3KPqPxKbjy4z66cjvNOC0rRpcT0UBnozMut2/Ht4rD/jUqdzNhiYj8aEUieWhoco5hfoAfUOAlykDkAH8boPGgJZlf69WxlL4dhY36Odw3exrC8SrnDi/jp0boyOTKY9gCM4VPoR/Mtbneu+u+Ebc3R6CW1sV65emaMMUQc5DMavi5DCo2/EjAG4UBRUAfXrjnKf7gPh9VFrf+rlhvLYNrmRKIpqZHJPUM6WB0dNC9rNMJtVvygX6Q1Bo/icAnv2hr1Jkpb0Z7Z91nz/ebzCBalsbz0ko2oD+RlhNyPEJzvF+xnDLDBvLJC98poe7zxk7DV6mW/2/Oa5RGEjIdIdBwGEK0NxcFA8m2jO2Jfs99WuxcvpBloj0Ft0w1ZHKmJzJnLGN4fsySIy9Nt64Cpk6E2dvTtEAzTFJHMcTkOoOz3hLnnAyFmkMfrPIT1ndA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(81166007)(83170400001)(8936002)(356005)(82740400003)(478600001)(26005)(40480700001)(40460700003)(110136005)(2906002)(54906003)(2876002)(70586007)(4326008)(8676002)(41300700001)(42882007)(316002)(6666004)(47076005)(9686003)(5660300002)(336012)(55446002)(186003)(36756003)(82310400005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:07.3422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9affa6-f6d5-4511-3454-08da6ff80657
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
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
index f79587a2f4ab..2d244a425821 100644
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
 
@@ -1127,7 +1138,8 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
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
