Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76F557E418
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiGVQGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiGVQG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200E64E62C
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1boVV26eFuK6pqzafcQzxWQbliyBa2mPlMhRjBnVe2oOu0VEYP3t/tTZmdAjY1IvX6X/krLamlh0zrjdGSeDnT86JvJvIf6sZhSvju9dN9e8M4TGkBDMVY9fOc2eQZlWk73fn6cFlgxJd80m5JxKDLCu4vxVSsl7Z1/E9DtsaxbpjZDm4xcSfW0APG7bKZHdX6ua99A5Xu3bfz4kBeWVZZ8gEhGmUJ3lBClqbXbWjTRVdOWoKP0LCaRy1PEJNH1j3bgcRL58L5zAW9UD7zFJ/NPpaRC6kl79pWhStVvnrKcM/g7ofl483qf+mLdFCcuEh/7egTL+qtltV7hq15vIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GZhhmrwVqhgCzx9sa0bErSxzAINta3pkU4QhKGNORo=;
 b=fPenr/Kwklt+T8RMTQILAygaK9fGzKox0ljmjvRZygJT01rcnsi2NUTtjaT5Gq3oeIWXuewDwJ5p1dmpBYKZNuo9pa67f8ITr/nj1ye/JxS83syfpyXVBrky6v1X5g48IqxBlGo/l7B2hHPT6sfsvIMbUrbVMmRYPhxOhrGJzUuVR89KNdEbtEjEWS3eeycyLoE3toNeOtxsZ5TYYAEbnrlYfgH/MHmxs3UNc+wJGQUXB2CIc/HLk8UxaO6eU9V4v8RdwhOyUYnJErrWEMIGaoVKsObgH9UiRk7+DcWu3L0nI7Cds1H7R7ntTKi29uL6Xy32ToBccQ/pGEp/lXB4Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GZhhmrwVqhgCzx9sa0bErSxzAINta3pkU4QhKGNORo=;
 b=MkU58Ebs4GvGtj3F0eOWxqfpos0uV0/Rw+vSBWDfVOMC164IQZrF7E8a2P7XOiHHTGiaYoEVFnmgrP1neT2AaPJANfGXZVl8TwnKNMacEXWIw9Vj5YvLYnYrZebPxFyMhlDEsk10pGX2GqZS+5dn1yedzFKVw8WdoGFSZQcbRQRL64Cd0+JLZawAfklC3X5AuIRE9Hwa8DkQioQdUSivMvAlno7Aiaa6/wUPyBbx0T5hSnH6tGmNGUogdDplGwlPMoFIAvkacgP7cq0NtmxG4XlV7Kr3SrJkkitY9jBVTf9VTRazJsr9KQZmPoK3M1t7jxLNo1kDAaFTXTvSBJRHeQ==
Received: from DS7PR03CA0047.namprd03.prod.outlook.com (2603:10b6:5:3b5::22)
 by DM6PR12MB4620.namprd12.prod.outlook.com (2603:10b6:5:76::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Fri, 22 Jul
 2022 16:06:24 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::59) by DS7PR03CA0047.outlook.office365.com
 (2603:10b6:5:3b5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:24 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:20 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:19 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 04/14] sfc: determine wire m-port at EF100 PF probe time
Date:   Fri, 22 Jul 2022 17:04:13 +0100
Message-ID: <3d9db886be3f5dbf3da360f433ca961cb20c5b83.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bed041a7-7899-47ec-6fc1-08da6bfc2096
X-MS-TrafficTypeDiagnostic: DM6PR12MB4620:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CY+8Ghqh7JLLgpCOD38430OtuTd3AQlnv+7/YcBwLu7wcPGZEJ/6lMCZpwR1r+Ewv8hwnl9jdHbsb1DmiIwBkgk8OtAfAVTfj/KpuGNAdF0Bft42Pn9YMG4yoAEhGcGJt1glcHocVzZ1Qvm4oFOBumyXqHhayz7/RBhhtucHNocTQ9g4g3Ut6Pms+oDX+wd/ErUqxMHmfy56x4Mm0+uyWoX7lUuOqDNDHL79u+QOf8mlwxeblLP0Xpc2C4t2jOFmXhTSJRoCAQgC0eXR0TwKa9qAL0ayQSDiViHcHoulZ73Lw/l5fgJ9JuzjB2QvSv0DJQ+gXExiKSEavHfnYLZndOwCV9rjNkO3YfDyWkRFD4nMcEKqtGp7eaMYIPBKHg2g8wQ1TwAaF2vy3lxLF9YqHGOp4rKg5rOvhspjrMiYNJmI/rx8QOxgD/dQfxfaK7qwgwJQAhGppr5C4g7AeBSrL5UGE15sbjeHA4hEFyy2CcZviKRtrdghogIVvmVzqNjReksKn6lmVOXrs5RlZOVxzZ3VrQDTarP52BBeAAa1OSnm8Eh35V8ryRV1Cv3Hw1VNyyTS9CmKzFiBV7v4f0yNHpEeU9nGa8NSrLQ//2IGp5HWNVx+baFNpb0XOHy7Ugebr+pRnrTAYNhS8Ypk5l5GKjE1Hik/RwozL+pIbv/K9BnqpQvaLbrEzD2m/s29GWhcS3qiXX8svxTYhQLAELvYCzVPUBdemzkIzZ2+oQIEJDAEbkXIXw2hKgF29823Q6gWK+95cYTnA2SK99tBMaJwymMEzus86mGxFGfeAw+XlPBqTMMNNAXbbl3WYFEm47eJcf/dUurwSgU/MhkPPszpAw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(40470700004)(36840700001)(70206006)(8676002)(186003)(4326008)(5660300002)(41300700001)(478600001)(2906002)(356005)(70586007)(9686003)(2876002)(54906003)(55446002)(8936002)(40460700003)(110136005)(83170400001)(42882007)(36756003)(81166007)(40480700001)(47076005)(36860700001)(26005)(6666004)(316002)(83380400001)(82310400005)(82740400003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:24.8069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bed041a7-7899-47ec-6fc1-08da6bfc2096
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4620
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

Traffic delivered to the (MAE admin) PF could be from either the wire
 or a VF.  The INGRESS_MPORT field of the RX prefix distinguishes these;
 base_mport is the value this field will have for traffic from the wire
 (which should be delivered to the PF's netdevice, not a representor).

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 34 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |  2 ++
 drivers/net/ethernet/sfc/mae.c       | 10 ++++++++
 drivers/net/ethernet/sfc/mae.h       |  1 +
 4 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 4625d35269e6..10fc79d4720c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -24,6 +24,7 @@
 #include "ef100_tx.h"
 #include "ef100_sriov.h"
 #include "ef100_netdev.h"
+#include "mae.h"
 #include "rx_common.h"
 
 #define EF100_MAX_VIS 4096
@@ -704,6 +705,29 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
+static int efx_ef100_get_base_mport(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	u32 selector, id;
+	int rc;
+
+	/* Construct mport selector for "physical network port" */
+	efx_mae_mport_wire(efx, &selector);
+	/* Look up actual mport ID */
+	rc = efx_mae_lookup_mport(efx, selector, &id);
+	if (rc)
+		return rc;
+	/* The ID should always fit in 16 bits, because that's how wide the
+	 * corresponding fields in the RX prefix & TX override descriptor are
+	 */
+	if (id >> 16)
+		netif_warn(efx, probe, efx->net_dev, "Bad base m-port id %#x\n",
+			   id);
+	nic_data->base_mport = id;
+	nic_data->have_mport = true;
+	return 0;
+}
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1064,6 +1088,16 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	eth_hw_addr_set(net_dev, net_dev->perm_addr);
 	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
 
+	if (!nic_data->grp_mae)
+		return 0;
+
+	rc = efx_ef100_get_base_mport(efx);
+	if (rc) {
+		netif_warn(efx, probe, net_dev,
+			   "Failed to probe base mport rc %d; representors will not function\n",
+			   rc);
+	}
+
 	return 0;
 
 fail:
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 40f84a275057..0295933145fa 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -72,6 +72,8 @@ struct ef100_nic_data {
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	u64 stats[EF100_STAT_COUNT];
+	u32 base_mport;
+	bool have_mport; /* base_mport was populated successfully */
 	bool grp_mae; /* MAE Privilege */
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 011ebd46ada5..0cbcadde6677 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -13,6 +13,16 @@
 #include "mcdi.h"
 #include "mcdi_pcol.h"
 
+void efx_mae_mport_wire(struct efx_nic *efx, u32 *out)
+{
+	efx_dword_t mport;
+
+	EFX_POPULATE_DWORD_2(mport,
+			     MAE_MPORT_SELECTOR_TYPE, MAE_MPORT_SELECTOR_TYPE_PPORT,
+			     MAE_MPORT_SELECTOR_PPORT_ID, efx->port_num);
+	*out = EFX_DWORD_VAL(mport);
+}
+
 void efx_mae_mport_vf(struct efx_nic *efx __always_unused, u32 vf_id, u32 *out)
 {
 	efx_dword_t mport;
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 27e69e8a54b6..25c2fd94e158 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -15,6 +15,7 @@
 
 #include "net_driver.h"
 
+void efx_mae_mport_wire(struct efx_nic *efx, u32 *out);
 void efx_mae_mport_vf(struct efx_nic *efx, u32 vf_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
