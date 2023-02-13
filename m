Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DC694F77
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBMSfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjBMSf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:27 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B625F729D;
        Mon, 13 Feb 2023 10:35:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfDJ6lRJXkfvO1qEQYJvDAc+Se9fYIvyLKKp/pCAk7fV3GlCxTUQ4hbqGbexXxP4wgr/YapstdDwyi7Nbv7CwEYdioppFhuVAI7iV4rqfAUy0L4EBZ7RHBDl1Ubc66WGSwIk9WAM+9k8UcXu5KmiVCteQcAEeaxsSgAtMyLcEYbDHUJhEiFFK700wNDloyKDtxmnfG4s/fWgvopFV40QMSS7+6acI8brUIam78Yj/Y6My+rugmflcB13hzJtQx35xN/WkFF0hznMJ3/V2qU+U5XELzr45Y5Qf6mWzuknm+yiPMliNs6LSqfSY3XwupTXxkhw5wUHp8vQs9rN/EZmSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xuBCdsjc2QZR+XxlFfbuZKXfsXAD7KDjo2zdqfbj7g=;
 b=iZ0hm0d+K/Oid1C6rGdY4no5o+6QNGqNBjJk3PThdRyGwFuJbmX1vLFeJcxvLGGVXEq3yaEd9CusRZcix4+5Dx3xrD1HjebQuSJGLIHqD3knt/MMvZeH6InmEqKwAL3gUZ2mhQZJTn+GhAZsLorkI82+WDYuyeCJPtYgXxefWKLz/ELL6h4+E917CW8Dy+b7tL9UKgBIH5fKYYGkmAyhz5fqNBcM4MwXG4APhORabRRl1QkfrRmRRRuXOWlm6y/ZbTh8h8GSpbWUUAFtqJEncVNt0DY4QIBqsa/mcHF5QRLP+KV8r5SpEF1SsigutZ5iFdzwvO0aAMf42uWf1q7pmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xuBCdsjc2QZR+XxlFfbuZKXfsXAD7KDjo2zdqfbj7g=;
 b=NnJSQ8PWArDE/Yq53LTLFxM9+Vz1nHDQfutEuo7r1cvdME8vieeSUgSM/E8NCSi3n462DNeDPrANlQZwtpDnJ+Ty4MBqs5uYJ7XU0s4tyft+YhPlQlzsnkL6NvfosTI0Z1qU1bTLhLOd5xjRYc+dkbCjOmcXJi1HN0S6f3BWHGs=
Received: from BN9PR03CA0457.namprd03.prod.outlook.com (2603:10b6:408:139::12)
 by MW3PR12MB4571.namprd12.prod.outlook.com (2603:10b6:303:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 18:35:18 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::fd) by BN9PR03CA0457.outlook.office365.com
 (2603:10b6:408:139::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:18 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:18 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:16 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 4/8] sfc: add mport lookup based on driver's mport data
Date:   Mon, 13 Feb 2023 18:34:24 +0000
Message-ID: <20230213183428.10734-5-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|MW3PR12MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: e351ad93-d590-4c23-4479-08db0df10e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hIEtKyOLllCoEhmZxZrpAOfbljkAG8TT4Y/PoOo6SigEMoffcLperL1UJZeAzwhNm1FYlswsEB8DrCxf3NTZpr2/Qm5CmrPUdcy128s1FPS+rh6m7MfEEFBIeRRSvArjdy16qRAxexIST71Z4hp/89v1J3xBS9QWILq4pduNmTzHV1UO4SRLL+l5mDallK4DrTQLnszi4Okxj9CNcGfjCLF98K+rKOYu85ZZZeEfLhuk6DQyVAwsTZ9JVyxqaCKzaEKBmtsHnhxMV5jVROsgHOD7F/HBbeH9gFDAWlu1kBb0ttJSOIJ7NZU0ZyJiNICpqrVACUVRjABaO2T4p+5w5Aplmuh+TaAv9x9vucEhYqEABaWw5pHZrKjK6Hm6TIFapAjPIZD3Z67hJiYuOfXjyQMUcYc7E6/ubiC6QtF1yre8xNJCNFu2DMDLWjQypjYscBu4xI3Wc1C+VWFKq7IEb4RmM/k53x0339Ci+pHC+fanJoBj/hVkO9/y40l7i6Cga4dv++Go8JfK/uFfWk4XqyqjWv0JWG2rq2PmJqiIBGo6TaDKpOKXeHyrvDGX3eWIvlQzOzg0UcvPOW46vzlYJpcSwGSQf34cOj0QqJjxAIyCB7FJy3aJMCg2emoj3xaZ7Ph2ZEv3chPAwpCFSbWqpJFkwBowFAhgdi3NMgNlEnq5nTge2PVFif9UpiFGgmocN5kTMeFPRYIa8ECKPQCETWpWwRsCPDvZMBkCCaun8I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(86362001)(36860700001)(81166007)(82740400003)(82310400005)(40460700003)(4326008)(36756003)(41300700001)(8676002)(70206006)(70586007)(6636002)(110136005)(54906003)(316002)(356005)(7416002)(8936002)(2906002)(2876002)(2616005)(5660300002)(83380400001)(426003)(478600001)(47076005)(336012)(6666004)(26005)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:18.6342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e351ad93-d590-4c23-4479-08db0df10e9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4571
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

Obtaining mport id is based on asking the firmware about it. This is
still needed for mport initialization itself, but once the mport data is
now kept by the driver, further mport id request can be satisfied
internally without firmware interaction.

Previous function is just modified in name making clear the firmware
interaction. The new function uses the old name and looks for the data
in the mport data structure.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  4 ++--
 drivers/net/ethernet/sfc/ef100_rep.c |  5 +----
 drivers/net/ethernet/sfc/mae.c       | 27 ++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h       |  2 ++
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 07e7dca0e4f2..aa11f0925e27 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -736,7 +736,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	/* Construct mport selector for "physical network port" */
 	efx_mae_mport_wire(efx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &id);
+	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
 	if (rc)
 		return rc;
 	/* The ID should always fit in 16 bits, because that's how wide the
@@ -751,7 +751,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	/* Construct mport selector for "calling PF" */
 	efx_mae_mport_uplink(efx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &id);
+	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
 	if (rc)
 		return rc;
 	if (id >> 16)
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index ebe7b1275713..9cd1a3ac67e0 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -243,14 +243,11 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 static int efx_ef100_configure_rep(struct efx_rep *efv)
 {
 	struct efx_nic *efx = efv->parent;
-	u32 selector;
 	int rc;
 
 	efv->rx_pring_size = EFX_REP_DEFAULT_PSEUDO_RING_SIZE;
-	/* Construct mport selector for corresponding VF */
-	efx_mae_mport_vf(efx, efv->idx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &efv->mport);
+	rc = efx_mae_lookup_mport(efx, efv->idx, &efv->mport);
 	if (rc)
 		return rc;
 	pci_dbg(efx->pci_dev, "VF %u has mport ID %#x\n", efv->idx, efv->mport);
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 725a3ab31087..6321fd393fc3 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -97,7 +97,7 @@ void efx_mae_mport_mport(struct efx_nic *efx __always_unused, u32 mport_id, u32
 }
 
 /* id is really only 24 bits wide */
-int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
+int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_MPORT_LOOKUP_OUT_LEN);
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_LOOKUP_IN_LEN);
@@ -488,6 +488,31 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 	return 0;
 }
 
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mae *mae = efx->mae;
+	struct rhashtable_iter walk;
+	struct mae_mport_desc *m;
+	int rc = -ENOENT;
+
+	rhashtable_walk_enter(&mae->mports_ht, &walk);
+	rhashtable_walk_start(&walk);
+	while ((m = rhashtable_walk_next(&walk)) != NULL) {
+		if (m->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
+		    m->interface_idx == nic_data->local_mae_intf &&
+		    m->pf_idx == 0 &&
+		    m->vf_idx == vf_idx) {
+			*id = m->mport_id;
+			rc = 0;
+			break;
+		}
+	}
+	rhashtable_walk_stop(&walk);
+	rhashtable_walk_exit(&walk);
+	return rc;
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index daa29d2cde96..b9bf86c47cda 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -96,4 +96,6 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 int efx_init_mae(struct efx_nic *efx);
 void efx_fini_mae(struct efx_nic *efx);
 void efx_mae_remove_mport(void *desc, void *arg);
+int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf, u32 *id);
 #endif /* EF100_MAE_H */
-- 
2.17.1

