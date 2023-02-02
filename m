Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8135687BEF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjBBLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjBBLOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:51 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B3087D29;
        Thu,  2 Feb 2023 03:14:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbtvnWFtW5g3paM4bqtUhkFvAtAyaiXcYL2kA3VI7/XuasF0IQCL70nAmoAfxNgFVY5g4K9sRh+xBL4EU8I1JOmFCGAE7keOSBWQJpBjz5+8vP/oQPaNKFA8TWFDzOX8CUB1ssm8a55wB1WPHvDYIyBHUmEOQlmJLZtpBqT932BGasCyPDQ5f9m1v4CIP47XPapC8NPZtK0VhD8fgPhlSgRtuGj3h8HvfyjRT9VwJ2pwcH1TZla4c8WhuSjBx1Nm1JFnU/+oZQqrzFfJy9ecEgf2aVaFIjXJDokQJnfKUljHvZQaNHyMeV7auT8bQjxGEqI4QspRRmppcdjC8Cn0+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJNaaMeQ4Fleg3Rcs/7B3dRJFQtejCgHC6DGQD1XmAk=;
 b=losUKFOSK8QTZprWuwkDKEjwRANpecS4KGu4RlABy7MMBr1OE2rMSUYYU8iIFx7gT4adq+Imm4eul9Awhe4wKFzzrkyl8qchlXtJtu3NRXc+pb3ZsAqN/m4TBmzG7QACK1DfmrstYwRLyt7a0Luw4a9WP7p1NRPpUUJpj+JlqSUp+LpFSjK2Q0FMmHSqOnApICkjtnSaQxDSkIOIrXkKpGPt90Cd4PEAN510j5OlqVSeHIgfzuasOgk9aCTuAFp8YmLM/zlsO6H7q9axltghRRJv6166Is2PvLIwGeugKrQXTjfRXxLx0iRg9CCaVOx904m7PN6XBB7yCgM6eTnVVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJNaaMeQ4Fleg3Rcs/7B3dRJFQtejCgHC6DGQD1XmAk=;
 b=4ZrdVz8zFQqSmkcUGpIjF8rOo2fV3066I4AWPDIf4p6KNQJQVNC4aoIOgzxuGecRO+Ig7XdtgoON9+haNoqVxKnCqGrOlKwcR/3axEc5aCqGiTg7mlZdwRbnniSCIqeh+dWn5QtwICSPhb8av6AYZVDiqAkvE+oDC4YqoaBs2rA=
Received: from MW4PR04CA0276.namprd04.prod.outlook.com (2603:10b6:303:89::11)
 by DS0PR12MB7534.namprd12.prod.outlook.com (2603:10b6:8:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 11:14:48 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::61) by MW4PR04CA0276.outlook.office365.com
 (2603:10b6:303:89::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 11:14:47 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:47 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:45 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 4/8] sfc: add mport lookup based on driver's mport data
Date:   Thu, 2 Feb 2023 11:14:19 +0000
Message-ID: <20230202111423.56831-5-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|DS0PR12MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: a15612b1-4b23-49de-374c-08db050eb235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 65frOFm9/BCrYcc57L+EKi+Bx+PkvJE3R8H9lGDH+mt7nxO9cIcqg2mgOQOxTHYQkZvWH+lYL2g8Jc46Mamh7UDWSnMl1GPgqEXWdFDqvha6/4G+s5M0lXklzgvNimKvZ7SA0fRTEBB15+6g9VRyBZ0faYEHHD/3/9jk4jkkOCNJMisjsN+05Pq8EpH0PFOFe2r/PRbqgUC+XVuq3fK14/sGeWUrxkaqxXc4ePaAp23jjJs5CC45jads5u7XE5y89nMnBTJChLJztEEWU8vUpl1pSohroqRKgJ5CL77f/cDglUGffwatz1XgfecpeMI2HwvepFYD7DiYpFWqIUai2buMhI5DhlBk/PyKzUVmO2thMrwNuGJHkvhvurD/Cz/pXqK2uNfwZiKximqNB32E9zJPm/Ku3at/atO0lh6HW6kDg5mw9O51rSMbdrTfC6u/UJTFsz4OjQsKYbAHU5Y1j/OTzKBe+go9xZYnlejEInzqraU973hDctSF0eK2aPvELidVXLmqcH9A/9KIY4TzerlFeY1UQ/Jm3FTY/ZGCBgZFY6avG/xWEqXRMi1xrmwpQOLw+OHywnHF4R/RdAeRZNadTPD+Z367/0c1FjBnpnU/00xnIz0lxXV0Hk5ShJ0f4OPsj+NPsSyNXOK1i1dQClw9Z/tx5wDU3JJyJcJVUugQ9sMAUfWOn0IlWguXfiDevHL1kYx2qIMxHzXbWscdDKYGm77damk1JhoaSpjcWK8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(2876002)(36756003)(2906002)(82310400005)(336012)(426003)(47076005)(54906003)(110136005)(316002)(83380400001)(6636002)(2616005)(6666004)(186003)(26005)(478600001)(40460700003)(70586007)(70206006)(1076003)(8676002)(4326008)(356005)(8936002)(5660300002)(82740400003)(7416002)(86362001)(41300700001)(81166007)(36860700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:47.8851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a15612b1-4b23-49de-374c-08db050eb235
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7534
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

