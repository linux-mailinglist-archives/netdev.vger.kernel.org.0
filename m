Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D46736EF
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjASLdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjASLca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:30 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8571B7494C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxdU9FtfA4gsVsiS/RY4yPOrHOFFfhcyd7hd47LGNNgz3qKoVApSMwKQAJXwaU4lIIcW8iqrH9fYtyFPc/1lh9tKZP7OXDP+qcSNp0G6EPWGbpLiBcIZtszQrVIahMef5MzE4N2uIVuzXaLgumucXG59qpt1iou8tza4YWuQGYNqaDd0FRWzf5HZVrePYD5BKWYFcz049hktFAiCBuk/H+hiDazwRb2orylfBjCQtCne2IumZGyYT9FbLBlyeQKmRfCPBZ6hEm7pSx5EL2H33QSSXmmC2vi6a1Ok7M8vMg1raDjVblF4ooIQq84Ap0Ygm46GRRblylVR2XCDTa7tIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vvoHTD3Fj96Dutl17jKamv1Oo+qDFnp9Y5qjkERSVc=;
 b=WUs2S/iQhLHU3tynP1PW7Jmxn1PC6l+iNHQXUbI+Euio6UXpTYL845PazlvzcOknVeATZhK+dzlE/2NxfMyzdX846wuOM6UGr7Ya8lhTLxFbtRgoiSaf0A8a9TKhPOCi3mik1YSmyomChlKPNWoj2jxIOZaDGorAsymNWe/bXV7UCdFPXloShOEhETMtKaa1U22/mVEKVxQ8GW9uwvq57dXUo0NcJVFdWpict/xcZXRaowFZFPZU0ZBG+lh+dFvBUGthhfcmwzeC1nRQ1uE6z0ogznudY0lR+I+7V3zgq/0NZfUhH0LieaUBAQthnKZDMFPeZeT7a9DQzHZUgnEQ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vvoHTD3Fj96Dutl17jKamv1Oo+qDFnp9Y5qjkERSVc=;
 b=uA+ly8E/8aSh25B46x1pBOCojo5ZlT827WtwWTSwEHaLXyLSMWwwEbsbE91gTkwK8RHf+LDsC8A0m7PJDGMuzQSlEQNmMAvzxKnhYkz/UrFkTPNuQ7v6SBT4NSFgdJJe95QCcrCuMJbLkMqztc4Log3GkhHOCJ4uTwJ1GyqcwU0=
Received: from MW4PR03CA0269.namprd03.prod.outlook.com (2603:10b6:303:b4::34)
 by PH7PR12MB7209.namprd12.prod.outlook.com (2603:10b6:510:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 19 Jan
 2023 11:32:10 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::17) by MW4PR03CA0269.outlook.office365.com
 (2603:10b6:303:b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 11:32:10 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:09 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:09 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:07 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 3/7] sfc: add mport lookup based on driver's mport data
Date:   Thu, 19 Jan 2023 11:31:36 +0000
Message-ID: <20230119113140.20208-4-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|PH7PR12MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f413958-9fea-4a65-3fae-08dafa10cdad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLx7X7cEvxseBgXTPXUkoTNqWnlMAABwsejIPv5YPA9vd8GuTofaxZGmixgSxOhE1fguG9e58BvrBJqggj9q9HKIzOIi07tDsWSoJneJQtrm3WnmcvNCerYOGIrsJVye4otn8gAtCLn4LjwovL0ZSuC3jvI6s5/q00bnT2rLfW5rfMQa7xQ7qBs4YB0o/jmirlI+4tMFe0KaJn4eD4Uf7GYaq9UiCUTv5gOogMCcGCo2fkEfMQD7fDdcEh97a8dipd8XEdUY2rPafWEbF4UsEbRcKyAVB7HS+AbKDxW3wpS+/xDZKiCIp6sVzeZcw8ZolOYcISLu1bCs/35BvUtxP9g1zeov+Ao1Gj6IyhPPOv+gsuAJK8436zkapVTqjF3WPYy9f5cvCp1Uo8rPduVrrjnHsSuufFITnIhZgztLiwYXJ5qEY/49t4UbXo0gs4YNXiYLjfI7P1GtALc7dsuwZDgKXr0lKdEcStgplwtRdcjQcT2luqmxXACiwW71MdjiCcIAHnWryH62AQM9BHts0c88iZOtePrvmNItzHjRwS5P47BpCBYQJzt0dn2mJ9tUF2zl4gdLeaFN9h0RI5NtasPFwlR/ZeXrUCA3tWeX6WjSyRdkO6U2PZQfzqrdCDWSEW1vYILz8ti4Z6s+Axa1WjyxKDVfBtQ0fLqAE2s32eJ6zEV7rjdp82vBGDoSAKaOajpQfkCJ7HF4g5P44cTRu16kUMI7t1HoIJhzlT7qYR4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(36860700001)(8936002)(82310400005)(478600001)(8676002)(83380400001)(70206006)(4326008)(2616005)(5660300002)(1076003)(356005)(82740400003)(40480700001)(336012)(41300700001)(47076005)(70586007)(6636002)(2876002)(26005)(81166007)(54906003)(6666004)(110136005)(186003)(40460700003)(426003)(2906002)(86362001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:10.1888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f413958-9fea-4a65-3fae-08dafa10cdad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7209
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

Obtaining mport id is based on asking the firmware about it. This is
still needed for mport initialization itself, but once the mport data is
now kept by the driver, further mport id request can be satisfied
internally without firmware interaction.

Previous function is just modified in name making clear the firmware
interaction. The new function uses the old name and looks for the data
in the mport data structure.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  4 ++--
 drivers/net/ethernet/sfc/ef100_rep.c |  5 +----
 drivers/net/ethernet/sfc/mae.c       | 27 ++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h       |  2 ++
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index ee260b508377..38c809eb7828 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -737,7 +737,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	/* Construct mport selector for "physical network port" */
 	efx_mae_mport_wire(efx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &id);
+	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
 	if (rc)
 		return rc;
 	/* The ID should always fit in 16 bits, because that's how wide the
@@ -752,7 +752,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
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
index bf039862ee14..6a5ab3a037db 100644
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
index e1f057f01f08..d9adeafc0654 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -97,4 +97,6 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 int efx_init_mae(struct efx_nic *efx);
 void efx_fini_mae(struct efx_nic *efx);
 void efx_mae_remove_mport(void *desc, void *arg);
+int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf, u32 *id);
 #endif /* EF100_MAE_H */
-- 
2.17.1

