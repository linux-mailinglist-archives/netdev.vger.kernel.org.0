Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B35692C45
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjBKAul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBKAuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:50:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7435679B28
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:50:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asMtzrz+IpSY6dEsz4gauviH1/RV9CxpzQLaFSFqinJwWlytxNLfWOM4zNWnbHRJk2vkWae8Yp7JF5VwOEYUAGkfQgr9rUGu7FFM87BdbavW8MBPpcT/b+p7S9vdxjIfKdleKx2dJJMMLLdqUr0BfrRA0KwNlmTc2199RxyQSc7mSEWEDgsDO67pJfFTBLdx9Mc7Xcuu7wdygaNEu1EWZ7CUlkjg+Yr6RfJBWpqVZH9GcuFhU9MbWGovm+/rkcovZej+WF2fEm3zLTl1z8OR4hl2ZXy2DUxe/K14QLOY1mRaAhcHnp/Sf8rwCV+T8QkqxoRY2Xvt4r9odg/S9BuZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=SKRPuxjpzA6NFbTf8dO0qdS4ftxNpQn8vyJ/BY0i475tb2GZeYCR076j2ImbnVj+PlHSExaZ7f2nPearXyeXyFIEj3XAXk2MV0QQ2klIhaJYRCNYPuPmQD/9nbUoZ76eaaL2dq4zP53rymWbBTMeKBDhjgWyuEV257uKMn+nRTpBV2vLw4Exq+Ak8ldd6AdDTUbmotxF9XyWcAwKJ+4OZsCZTgxo/MZ4Ii25lXVBFBj14cuRza6tKuRAfpd0nZkJH7fMrre2QLaODZn8u0jjOoT9bUbPyDxorab2SAykBRFz6CUTlB6lGCngL38urAR2wW5BwuDXh/HPHac5GtUbvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=hB90S6yuSub4S+/OdSxSucgegnDLUHnPADlnlJREjQF9ums/x5kD+Vb6/ZzsFOvesQ3UbhVySWrmXYdMsNOfjKjRl8I9GbJ1tKvl2zbHsIh4DxpUEi2XGTNry+RKTTqzchArnPg/D8rnKF7v7E+9gV+XPWbeS1MpZFceL4ZVJD4=
Received: from CY5PR19CA0118.namprd19.prod.outlook.com (2603:10b6:930:64::22)
 by BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Sat, 11 Feb
 2023 00:50:36 +0000
Received: from CY4PEPF0000C969.namprd02.prod.outlook.com
 (2603:10b6:930:64:cafe::f8) by CY5PR19CA0118.outlook.office365.com
 (2603:10b6:930:64::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Sat, 11 Feb 2023 00:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C969.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Sat, 11 Feb 2023 00:50:35 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 18:50:34 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v4 net-next 2/4] ionic: remove unnecessary void casts
Date:   Fri, 10 Feb 2023 16:50:15 -0800
Message-ID: <20230211005017.48134-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230211005017.48134-1-shannon.nelson@amd.com>
References: <20230211005017.48134-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C969:EE_|BN9PR12MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: d00b839a-0618-476f-9197-08db0bc9fc94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BudFerrIyyK6eUqNrY+jpRLYD//p8tTe7SfV8dB6eiCZRiJVj1Fimj/D6OJ7Yr1qWrU1Oi/XrwjvaAKMy9OzXaGwKLpaMQnQ/o4TEqmXXEVuQxkR7XpqZ4cC4ekdVjuAkCPHaj+Aw/tGRb/wGc6hU8TpJNgCQVit1AQsWEBGpw0jYfOevyMcrRY/9VCdIsdzyUF8FBzDSeGPW7TjYi8NF40xLHDzAFjtzbJjMoO9P70y5gctuohDokE/+sJ6HOb6zbjsu91FRvxxpaYAHGGLnhExlNLlYbTwFPOPXy3ySyCT1SDaaTAbnzGdhxqTB0rRkfeAUVi5w5KmWsTZZvGi20ykCxp4NkgSG909gWPfkwEP5/d8v21mw4WfcP2L0ztuQOkIozCEb4U2q03sBrPzEHwlaEIaK26vfSrULnfouMlfrr+/p/jjFaBlbND7Oe2RU0fxRkUhHEpKGxiR626vBYPxOY2Nl7IMQKNhl8CyTB4WuHLkLc3mTWWOuRJbXTiU0uv56CZgOuvFEgdknPLHL3/2VFgMNzqDhEpQ+s9BmZD1wkc+rMo0irO4T82NMkXu8xlfLHVxobUIbIygfRPUFe8XGjKWDwgdnShBsQ9o7LzRkRvbeUksp+ulFXAJXe3DcLRM1mApJdk0Jib+Aork9pIA8szAs8a37o2Ek5MpmLiI4NAnkZbr05LYaAAkgRYlT2ljU1OeuHV/zjoncZfEjHeJg4qchyH74pgNcII7miI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199018)(36840700001)(40470700004)(46966006)(81166007)(2906002)(44832011)(36860700001)(86362001)(82310400005)(66899018)(82740400003)(40460700003)(426003)(336012)(47076005)(2616005)(186003)(16526019)(26005)(36756003)(40480700001)(356005)(70586007)(70206006)(83380400001)(54906003)(316002)(110136005)(41300700001)(1076003)(6666004)(4326008)(8676002)(478600001)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 00:50:35.5889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d00b839a-0618-476f-9197-08db0bc9fc94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C969.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor Code cleanup details.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c   | 4 ++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c      | 4 ++--
 drivers/net/ethernet/pensando/ionic/ionic_phc.c       | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index ce436e97324a..0eff78fa0565 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -121,7 +121,7 @@ static void ionic_vf_dealloc_locked(struct ionic *ionic)
 
 		if (v->stats_pa) {
 			vfc.stats_pa = 0;
-			(void)ionic_set_vf_config(ionic, i, &vfc);
+			ionic_set_vf_config(ionic, i, &vfc);
 			dma_unmap_single(ionic->dev, v->stats_pa,
 					 sizeof(v->stats), DMA_FROM_DEVICE);
 			v->stats_pa = 0;
@@ -169,7 +169,7 @@ static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
 
 		/* ignore failures from older FW, we just won't get stats */
 		vfc.stats_pa = cpu_to_le64(v->stats_pa);
-		(void)ionic_set_vf_config(ionic, i, &vfc);
+		ionic_set_vf_config(ionic, i, &vfc);
 	}
 
 out:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a13530ec4dd8..79d4dfa9e07e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -359,7 +359,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 			break;
 
 		/* force a check of FW status and break out if FW reset */
-		(void)ionic_heartbeat_check(lif->ionic);
+		ionic_heartbeat_check(lif->ionic);
 		if ((test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
 		     !lif->ionic->idev.fw_status_ready) ||
 		    test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
@@ -647,7 +647,7 @@ int ionic_port_init(struct ionic *ionic)
 	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 
 	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
-	(void)ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 887046838b3b..eac2f0e3576e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -268,7 +268,7 @@ static u64 ionic_hwstamp_read(struct ionic *ionic,
 	u32 tick_high_before, tick_high, tick_low;
 
 	/* read and discard low part to defeat hw staging of high part */
-	(void)ioread32(&ionic->idev.hwstamp_regs->tick_low);
+	ioread32(&ionic->idev.hwstamp_regs->tick_low);
 
 	tick_high_before = ioread32(&ionic->idev.hwstamp_regs->tick_high);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index b7363376dfc8..1ee2f285cb42 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -604,14 +604,14 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	 * they can clear room for some new filters
 	 */
 	list_for_each_entry_safe(sync_item, spos, &sync_del_list, list) {
-		(void)ionic_lif_filter_del(lif, &sync_item->f.cmd);
+		ionic_lif_filter_del(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
 	}
 
 	list_for_each_entry_safe(sync_item, spos, &sync_add_list, list) {
-		(void)ionic_lif_filter_add(lif, &sync_item->f.cmd);
+		ionic_lif_filter_add(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
-- 
2.17.1

