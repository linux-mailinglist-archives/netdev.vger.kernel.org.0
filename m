Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B0268E47F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBGXkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBGXka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:40:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4321A4A6
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 15:40:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btlbs4r30C6ZL2BVaF+Nf7JTFBLT2TPp3YzgiMJ5gJBCj+KuazdpJgf7KPk3ViU0D1BTQ0kC3kPbdUq1g3QRRXL8ekpFeiXS6tkQQ2RAg0HfTYWjok6Iir23njl9BCbNjhx4JkpkReW8C9bT1ESwUDillt8UkotBzRwQ7xHT+hk9sLzDxvZYoRTFTlH/j9EOEBVmUqTKhCUoBpeHyq6m7bkoKUXBUfmnXJU5NLWordheo4PgNPGTajwXqc1WNmnERU9ysyuVaMJK2vVNmaF3aG6/WbbelOcp77X8fmhtzdtBlEwtidMYszdekde9bIFPQ/vrnygQyvMcwhFDHUSYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=eV0OLHkYVmsH2x8FIiSqoCRUIf0nswXU6B52jnQ7g03PqA/6A+DS3UcT31ZRqCDIVfD/pHbf22Yi7pPyioWQg8lkneIQO/c8DMDHO4s06myqt+VVoquuwYcyYaErvSDFFswaLFlc6brP1hrMKHuK+Fv5KwVNRLHk0ePnTbE9HSNTMTU4bTPaIZcHpMQG0wfmJwNDe1mWws8qozpisZFvQN2fBL3AIjdrH8Q/gS3oTLBBCAoZQnk+yDqgxYUcQ5PgoAkIzHlXz1WF1KVa+6hxI95BCmTecVxQTxFIZb2urKMyTLElB2a/gP31wkw59kMGMEo6lFaBWN91h7HxCxIr0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=kaIXTShwSpREp5Qdj7abp/m0/ERPCQ6H1WEezd0iqi5OYZoHl+hDDKaLKeJWcwHuHvZqVEYn5bv4+dk0f/6K6pemdG7n141PpKyLou/15EmlT/h9EI9S0nlxKe/SmkmNO5QJXv0tYCO3vIj9X3b9wlbS98cbUpPn/bUXku/aVP0=
Received: from CY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:930::15) by
 CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25; Tue, 7 Feb 2023 23:40:25 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:0:cafe::66) by CY5PR13CA0027.outlook.office365.com
 (2603:10b6:930::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16 via Frontend
 Transport; Tue, 7 Feb 2023 23:40:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 23:40:24 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 17:40:23 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 2/3] ionic: remove unnecessary void casts
Date:   Tue, 7 Feb 2023 15:40:05 -0800
Message-ID: <20230207234006.29643-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230207234006.29643-1-shannon.nelson@amd.com>
References: <20230207234006.29643-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|CH0PR12MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: 422ce12d-796d-4c9b-04af-08db0964af9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qyqMy5AdoNnKsfumzaRKU9ZxVN5A6C6Pj1yFVUlnWvteNtQUBeGrjdlFv8+xx2aIvZ9Gqnwuuq55YycLva8Gc2ZEn5pIDfDN8YaW5bKVN5rb2s62KhV2Ml70F799G48gh0W8ymLuCJ13eKKRmKqC4tCuDQqLOMm3twGPY+vEtB7X28OFxO60UFONyTOtnk3/U8V1P+H/JGQAt8Q/nRkpHSzpnVRD4h7MvBZaF2/VDRdmfcE/q509OeNhkY5LV5Po3+1MqDoUAGoxAjq0Mkp+auvKQ7on50kFTeT19jGSUfJpGacrXPMjFAqlcpMGxdwxqqXsMm2fphAuV6h6MguL0zAjcnulCIBXFDp8hN+oTOLSMLjexImaAKblUEt9u6U1/WzITuMHzKxYTn1e2utly6PRI5fuolfanvSCdBh9d8UUiYUiwSJRwp5FBkkcb1U+lYUWGzNsyll1KLEjoQKQx36H8D/0E3u4DYtl5AIQ+BWWkNtlH+qvhZSqwIlSI2dPNaXjNXismgkP+kEam5OVvUNYRNIQPbE8qZwy3cUqMlzK783tFwDZq5+wHVTQlxZbStsGPR2i+FEYmj7V//VDnBRT26ugUZ+1sfAGs4g++S423HNBeuVkkiSK+ApcDyH5/VhypcuQ4u22w6HLqL2L6vDcZMQa82TtoPA6RS9mwYVpR4pZetP71B/6cnlE1lLJ6zZUOJAKjTZtUxY8Irmx28ZgYavQe4mQcZ/2CAi8UM0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(40470700004)(46966006)(36840700001)(41300700001)(1076003)(40460700003)(336012)(16526019)(186003)(8676002)(2906002)(4326008)(81166007)(316002)(110136005)(5660300002)(54906003)(356005)(82740400003)(70206006)(36860700001)(36756003)(70586007)(83380400001)(40480700001)(426003)(8936002)(47076005)(6666004)(86362001)(44832011)(478600001)(26005)(82310400005)(66899018)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 23:40:24.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422ce12d-796d-4c9b-04af-08db0964af9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

