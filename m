Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC15068C58A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjBFSQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBFSQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:16:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E06234FF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:16:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkieikAMxG06A059v6TyBZxazxJ4AM03EvuoMnSs1WR2FtsUEjTlivheXRgiCC2rCXHHNtfR/CDasJ2UWVYir8P3wgRedae2tPlXzE6bFbirJx7jVLFy8wpYBJyQzpWvXIyzaIoMEx2EloAh9TMzoaSqxLgGOSYaQxsfvurz5ddigTSIM8AI7CgKSNFjcGei/LSKLFPUi7zARh9L3KEaL7GvTY7DSW6Lo6BZVG4F6ufBaVaZloIWQvydCjFc2FsAkjdOj/9tqy7IVbKaJnhA9PhTv/MbYNgJ3s40pYgoiwC4E70VtSTRnMO9VYYtAwC0uDP4WEH/3bdD9Q3LaNuCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=mDcgTtY+xkO9R4I2gp7vYdxTET7ZVGoI+2IXO8vEZa+Jujqc6X0SGvnY1RqZehfveE6NfmuUcKXbLJOPOxkA6GmwgwwoJ/Y3j6qZLqjUDeLzp1Pom7PyVhk9hUB1PNPC8GvM29D3+1E17hUag3KkjFiVg6vSVbd1BeWc1Oj9RhW7u5mStmn+zsnpTyKWA+nB467Q9jmU7I3OZHuEzPtlen8Z8HnpD9klosq+vnNKd83AGTiFRkB2hgcH7B0cydfbIS3ajN5JA45PNG8tbou5o0AA5ZReLOyb125qqtgkdyyBGYVnjWfPvnYC3Cwn1qI/vmkhq8MaP8LTaZQgjRlO/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=lgyYZOMWwOPsXySure3EZXI8pvzr1uJ+/KenutiFNrhFZQz5bfifN+l+nf/JbkARDAol8OQ7e5iu12k957L+lhbpgpsVNrduhAUng+1mDVkyOdkToHWQy6aJ5sJ8VzHOhgXdZRnCZ078nXgIR/2Tbl+D8ECN+bECWPGDw0cO1k4=
Received: from MW4PR03CA0088.namprd03.prod.outlook.com (2603:10b6:303:b6::33)
 by CH0PR12MB5044.namprd12.prod.outlook.com (2603:10b6:610:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 18:16:46 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::64) by MW4PR03CA0088.outlook.office365.com
 (2603:10b6:303:b6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 18:16:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 18:16:46 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 12:16:44 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 2/3] ionic: remove unnecessary void casts
Date:   Mon, 6 Feb 2023 10:16:27 -0800
Message-ID: <20230206181628.73302-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230206181628.73302-1-shannon.nelson@amd.com>
References: <20230206181628.73302-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|CH0PR12MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f5e54a-f26b-4c60-f37c-08db086e4e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OkbHK/OPpyEGjXeFkpotPfoadgczZau8A+84Id1tJ5SwEZBQ95gNwpPs1OAFEV8efmmX8iT1qhgumEINCzqclrQoLzqT0FwwWLTxl+/F0WzSDBx9//e8C6bbL9JAwtYGFc2lq4sQ8AoyXbjWCKtxVChapNuawBGZ6B8GD0BmTIYcLv3trOTJth1MB9IkIgew2s2NlI2a0/4n9DKgTrUhfihphdXH6OpqBLVjEYQnro0qYB84mI0Kpdge7TnoBDD3idxZmUhUBDekg8zieYqyGSa61bOw0FIsxDNZwLwGmfojdcCLy1CbI7bh5XxPFdQuBAG3M8yasqWyZQY5iAh16Yee+fxXmbip+hMDdHznncZt9ZIiDDrLVBhgSGtaqU/B3InR1grlTDzUj5h6y35c+p0zUuHpLGOhUlPajWxTvY/zi/Y3ZY+E/6nU8imfreaZEHlKv9dXwf09Z50s09QB4u0WEk0mTOQgPsze1jK1Xv8x8lLPuIjpYOLFM6Qm6ECmZJGjDQMFsgo/VINsv25ZRPYCIDJfA46QYSG7V8L83y4bfeaa6SZt8rDHwlzVeBMcUbLXEb5MVYzLEkTpqGwXd3Gunk0CKOZveqtLG6C1ES+m3tK3/TOMKrt4kqlRwnwaQldenNwwb+fxUZ3VRQvACtSiuZarQVXYELAkUzcGAiqKHwQE5TakoQ7Aciy7OHUGdFIPNoNfGsQyOHz4Quw5Nk7tCg3NNKWBCAxqzlunSDc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(40470700004)(36840700001)(46966006)(478600001)(316002)(54906003)(110136005)(1076003)(2616005)(16526019)(44832011)(26005)(82310400005)(186003)(36756003)(5660300002)(86362001)(6666004)(40460700003)(82740400003)(66899018)(426003)(40480700001)(83380400001)(336012)(47076005)(70206006)(4326008)(70586007)(8676002)(2906002)(81166007)(356005)(8936002)(41300700001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 18:16:46.0024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f5e54a-f26b-4c60-f37c-08db086e4e9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5044
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

