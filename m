Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CA967E063
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjA0Jh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjA0JhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:37:25 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A861CF48
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 01:37:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY+VyBXYD5rPXUNblRwynfycMIL2FCBCIwo/9g7sirV02ArXEI/531fzwA2eSBZUseFlsyTFX7yn88VZEiN54+QUwRPqK20wAAv8qdEvJnLkQE1Us1dw1hdeSVpXydT6GTN64PIHo7QZF/mZB8O0AATq99eqvyDhaqg6RezmaMGEpdiBTLj+gW0mawSJ/U4HIrs3T93aWFmPZ8UPrBjXTHRtO0YXQjbdLQfJId9cMi0Cn1FDH+l6Ra4uYfEFvtw95JvOJM8+YPpW8XyJ9wpc3gnqJ6yEjut1GMni8Lpex2AUyRvBw2YPgizgcO8H4tQpOH+C7EaSsyxSwPcHJfcxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PT9vGe9K91fu7mj2f9y5+TgaW04AXIJU1aYRYXPdsrg=;
 b=FAKpTWJ4eNWM33whQTgK6/w1fjZ6+aq5m8jor6B4CKOKpXXRnr4ESr2kfGoHqbJawUDnkY4scAnIIPnV9XgZmdgMFL3ao6hUlpPj+PMhU/qB0zyjg8K4/ZVSpK6rwMcmhPhxZYMJaGX+L4NRc6WXuAnBSo2CnXBx8o7g/yzUuRyBiFWbmqxKORyqfj1L5fABAXyadDG4o670gHLN76H6w6V/9yOvaO9goLx4oCwZKbJTFOl+f6k607n9RHb6CvG1poNtK+4R18P1eifQOyk5sgiORRiEvlivVg1HMpCfHn98CmN5UayacRTu09lIUb02H6d3993KX5W4iuQptvC5tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PT9vGe9K91fu7mj2f9y5+TgaW04AXIJU1aYRYXPdsrg=;
 b=KqjpygFJSyMRVNG1Y3fw33h9mo/gtwVSpA31FcroHObsyWypX6ZkEBMsfqvWFljrbay5+RK2qqctMJJI7vUI6qTInNtyWxM9hzmOLFyAW+Q6xQxvigD4HwnuvTCl/iZcRiiUILagAZz7/vXfFeq6IqwA70IVPHCDIRZYmzE0nRY=
Received: from DM6PR02CA0091.namprd02.prod.outlook.com (2603:10b6:5:1f4::32)
 by DM4PR12MB6541.namprd12.prod.outlook.com (2603:10b6:8:88::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 09:37:19 +0000
Received: from DS1PEPF0000E64F.namprd02.prod.outlook.com
 (2603:10b6:5:1f4:cafe::75) by DM6PR02CA0091.outlook.office365.com
 (2603:10b6:5:1f4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 09:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E64F.mail.protection.outlook.com (10.167.18.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.10 via Frontend Transport; Fri, 27 Jan 2023 09:37:18 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 03:37:16 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 27 Jan
 2023 03:37:16 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 27 Jan 2023 03:37:15 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v3 net-next 4/8] sfc: add mport lookup based on driver's mport data
Date:   Fri, 27 Jan 2023 09:36:47 +0000
Message-ID: <20230127093651.54035-5-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64F:EE_|DM4PR12MB6541:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ab3e3f-a174-4aaf-23ff-08db004a156b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYqx1FfcJFELTqr2ySFMY6Xx/Gd/ZOPY4Q/aGTb7rwc2gV3CIyy5qlDwu/Bw/DDHjPqOcr1ulTSzSCnuSDe/MH+Ny4MHR56xrAlX6fm/DM0VgKumyKY3iCFp1kXFZcSbpXNNui3j2z8PIubwxEuZULD0JzDixVzwp94o5+eCKvKq/qNVt8Lt0qimHMXPWx356u7oFHww1qAeF37p7xtE1Obh5x2QYskHi7a7tMCl2j22vCa+u+VHVdpGEzT4uqB7C7mRjyI02ANOtMgEAmaIgCWytuGUAj41zL/sqeW3Wp1lm2wrrxLN6qgwRgUAQ36aZScfqMLwdFx81MjsbbRTiESJ9ytjq/f8RByCGVBhqfBICNXuDOApOMkcQh+TZ3gqa8+UkIzdNXC9To1YG7TWQR7KCFZchTN7ojq3bDXMU7NcKLt5QzujMh34jzpV5L2o2uBlBOLLj4y5yfQAGKLbJdKSz6gfWPXcHpdrJ9VnC7VTxBlvX1LqIF3QBuUdPAe5SCHXCipjsLY4E/oi0gcG47BG012scCI2Q2qCbNx+WrELJ67poKphGSUsEbk4E/BO1t0Ay9vyPAlOuAjOqtZV1lv4gK96sZQ2HvcczgjopeBv6lj1CSWft6IYWsgCfx1W2IaMDGCRgUTEzeisKI+ZiW/U8UmPmrrGoUAK1jINsJw/yHLaLgjQa2O44FFiKxThAqUNYIiRqAiwNh3KPZ5XqDHd+snvGKv9JGF5Lq5hJZs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(47076005)(54906003)(8676002)(426003)(36756003)(40460700003)(356005)(6636002)(83380400001)(81166007)(36860700001)(2616005)(336012)(186003)(26005)(86362001)(82310400005)(6666004)(5660300002)(478600001)(110136005)(316002)(40480700001)(1076003)(2906002)(70586007)(82740400003)(41300700001)(8936002)(2876002)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 09:37:18.9198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ab3e3f-a174-4aaf-23ff-08db004a156b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6541
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 767edb1d922c..04774f33b493 100644
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

