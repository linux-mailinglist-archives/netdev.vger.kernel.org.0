Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B68F687302
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBBBa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBBBaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D99F6ACAF
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqxYtcuZaQkW1k5ZXGTQ/4EjdW/2y1Ftv89GC2M3uMAxEjNOg4G8ZcG9hz0s9aG5mV+8iW9tNs2plN/vdToSEgbnvP6iY3M19SLxVDzqGseUYKI2zQhqH8+7BDrJKo7wKzIdh/wt344Jffxt0eK8uxFJSGEODKn0f7kt6oWyWazkRUVP363p3itEU95y5G+TZ39Gj8sIdiunupTVk/HKIgcEv6xlPFHnwcknI0BpK3xLDhdo9ZGeoTqD3XE2kPdBe4t4FnIBKSg1sAONGs+RjzV8J190+4wUVmzvkL8gkdY7OHMrTbmjT+WXFu8aeEH0hVzloLfdHnZ79R6jzEmn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+mo/ckDnjpynCqXPL9Rg/ZfnfY2+raX25HxATYMQjU=;
 b=lY6Ht4HNxbIQVKRZBrSFiCJng+/oZ7T+hSZq7McKz9bStEK5h7KByw1uFEEpbrzk6HurnrTTJdDQRWUBEV/Y/ct9fTMdYXOT7MqNXcq2T+nJ/rIVwal0qnIJ73vkNTxTztCFVzFgeNnPpjh0fjZyflWc7VjJjMpXyS9T9oe6MGYoD2uQEwAU5UIeG91a8RlKaFOXQk22AhvQa7A2Ig66/OzfaEJ6ESmC1jnX5SMWTu0faMTMS2V6d5w9GPyyxtuzZmlJ2bS6jU4QLLwIqRmPQeoPqdxFCGXZnumUU85k7GAhZE42XQx2FjmL6iIesKc2qMyeC9wFmMDN/dHDHCPvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+mo/ckDnjpynCqXPL9Rg/ZfnfY2+raX25HxATYMQjU=;
 b=xKkkAtPDmIujqyM1nO88gkpC2I1BDIa3yhdFAB8CyABHIrd5ZDCThn2d7R6g6XZ6DxkqyVXchiy0KTElM5aWQUBObNjKy6IYFzD96+yD5L32hl/jk/aSnTdkMHu3UXkLLIcCnjYezI04jQpjXPXsr2JhKKgFFcX07mjzH4lL5iQ=
Received: from CY5PR15CA0101.namprd15.prod.outlook.com (2603:10b6:930:7::22)
 by CH0PR12MB8577.namprd12.prod.outlook.com (2603:10b6:610:18b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 01:30:22 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::f0) by CY5PR15CA0101.outlook.office365.com
 (2603:10b6:930:7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 01:30:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:20 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 2/6] ionic: remove unnecessary void casts
Date:   Wed, 1 Feb 2023 17:29:58 -0800
Message-ID: <20230202013002.34358-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202013002.34358-1-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|CH0PR12MB8577:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f89d71d-0067-45b1-7f3f-08db04bd0d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlUalsHutN/vovNHwkTGmWPri9BlG4D7YBwHovc5IWg8k0W9MVjwiQ3SZFWJaUWGX+lBFob7MEmLSChzGWA6QhRifWWBG3dCV1GUMVFbKiqexEt13JBdB22amw7xVyWgpx6UDIgcdBv7SsPOqgRBClDSYKnCQFUzIKHbyA46XzuL6MvFS/itz9ahM5wclBxzSVY02AB8UsCqI4fa6mSLDKC4YDGHDq3yMvCOqeFSkcfi3Ew2NwTCZXWnLQJrkeeU5OlIwLJ6GY+wVT/lJfXCn3I85g6z2AW9ZMgolyJ322DhbGOPkhtGVAXMdZDdu7DSggCcEsicridEezl0xicSQyy1kf8uzF3k8g0ySBz9a+8EFftwpYoQCuFqPzI5Eg95qTuGsmNr/VAHn++JxP1LYHF8uUSlpZN+U1DkxEjF0SUmhHYTE3SRs15RrJtmH4GHnZJLNJ2lbtA4PTPCShLfzGZsh0LcqfcbwSibnE3ch6P+9O2spOR6E9hecwKNGO47T9hg5Umx5DpO0Mzmk35sDV34+3LDOHfSIcUJ6AfAaArQH8BSTDi3/3uoZKeSvxkdmngS7V5eeVaIR3gHDes8osOlj0QQYmv3Vq9Bjc4/z3ymVS7U+dbEA8kDVm48NA5WJjRfkndvYfsXd35dhY1DL7Ff66r67yByFMB7zFsmoLWv+Pvws3dzjbrGel1l12DNj86Uh0F1J7u1zY9p4jvP0UReuOfZPx3DwKYkHIMtrG8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(41300700001)(86362001)(2616005)(40480700001)(82310400005)(356005)(426003)(47076005)(336012)(81166007)(36860700001)(82740400003)(316002)(4326008)(54906003)(110136005)(40460700003)(6666004)(478600001)(8676002)(70206006)(36756003)(186003)(16526019)(26005)(70586007)(44832011)(66899018)(1076003)(8936002)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:22.1418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f89d71d-0067-45b1-7f3f-08db04bd0d59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8577
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

