Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECDF68C587
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjBFSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBFSQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:16:50 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8330922A37
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:16:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrCLZF7k4iSMpz+GCX9nugu/upAI2Ea9cGnAqZsPZtvDST4ZchtPR/Eji300EKpPYCA8ytaKpReSQEvMzXtuCgfPeGwtlxOEI1gZ3c1n4KZZGyYjfLd1w/aH6xeJW2wLkASbryQsu5CyEA1UtJ+VYD8+o6wbhAjjQ3e4aEd0YWwzHSrRWbutRlO/jUVTrqb/9nCrrHjRUape/XudPkK3jsnkwSMBORJ2PWo+qbfaO9SNn6vev21CoeMrjjhO/xoyqWeNtzpp4chauBXAu4+W6TMEFA2KBCck+3CHmxjzANC1Ih9oqm3a56CFgvq5HsZ2nSJYh7/iZjCTHH0twMZkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=cS/dZx2/HPUH+DCxt5SKhPz0XBxzyA+7uGGamsJPCN543GMGGh8G+cN/BwZ4xywjj5YGYAyEFke4bOyMFLkXA3TBjxfJgp3Z9tb+FER8pdG9gW/PaaZr4KBNDr4LAVZM9xzKWEUGf4CXNf2VhPFXqQx8FRFxbfLBLgCe/xesmxnzFVdBdU0hbkl4ET4qMXRSFHyt7wbvQNa4OwstuJULJKSPSm22PT0HdHylNzYF3HN3IByg7Ck9b4kOOaigvbdCy/9L30tJViWUJXACPR82vDl191bNIx5txJyPCDfXcyl62q+wrm7y6eFJS0sjh5msgyalD/kynuanDcFZcB1nGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=h/0oR6D0eTTaNSS5A2tiDsfI6X1Eq738I3LTxNYX+VfLEJk+Z7KnT7UCFUbL1H8P1LukVXhDvFT/Zl6hTFcTHNUlx4otYkaXm1C+WXrzmcuvgL+U5IEx2CFVJSzR63DuvBWGOYKMNfQ7C+KD//b1Z7x+YoFHbuuFT5hM0NmUr2I=
Received: from MW4PR03CA0082.namprd03.prod.outlook.com (2603:10b6:303:b6::27)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 18:16:45 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::8e) by MW4PR03CA0082.outlook.office365.com
 (2603:10b6:303:b6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 18:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 18:16:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 12:16:43 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 1/3] ionic: remove unnecessary indirection
Date:   Mon, 6 Feb 2023 10:16:26 -0800
Message-ID: <20230206181628.73302-2-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: fc24e589-0641-4f3a-2090-08db086e4e4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDJ1h/MPEASDvyJlc8YfOsU/sei+pdoB1ZcqESjNncd/Ennh/qfbnYLRw9kOmqI5oWFvN1Mw2OUG8FysGy+Ef0Zls142BcB93Wg44DPzGWlEnDu1C3nNmqm9Qb7DDU1twwxgNFQSX07waOWaRuE/VuNKABPdTd7W10F4JcoiVKKotHaeOSGnPA7fxCX/+UaytZq31usyNi2p5t90OEY/ySpsWz7BcXiGvtWRVUNh9nHqUMpRU/DGzVRrKBXyWsdFzKl8bJC66pG3YTV+a4P4eObiiPuWABaz5y2uRBKddmYTaMCaDzPGRfcmfRjBlWEOttTJMCRfddFdjHWsTvLczLv/F+hVXYGJPd/k2YW3cKmiJvF5Txmw0Ir7VRznX9MuUHjUThnB7x6zw9MtNJqL2lkOOUh0I19Lzw8eN8QPl/SiJe0w7ZF0FiAbFkg3e9FpKToInE47iHxb49aZ52SSiqjTNnvO6bBZyBJRIMl+2Go93/qO0Qh3jZ2YmRY50RB7EMAfj/JTPRKHSvdqoMIaEyVX6+OH+CPslXJmMzGRKby5zHCtLk6NJwHcpLjET68UQM/4PsktUaoZUx/LCwOlYZNUXOs8YsBJb56xu/YMC0Hb9GWxFRDH1bCVYcGhE2DA//9ugpzSSBJUWvAjMDJcXnTgrs09Qx3fiAdgzkI8V1WYb1GYZ7T0L3tgLomeTx4n73T9HkR5TwjXH4sxt4gPDNY2wPcDaGw1UpkmIFoyBt8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(46966006)(40470700004)(36840700001)(2906002)(5660300002)(44832011)(36860700001)(426003)(47076005)(1076003)(8936002)(41300700001)(36756003)(6666004)(478600001)(2616005)(16526019)(26005)(186003)(336012)(356005)(40480700001)(81166007)(82740400003)(40460700003)(83380400001)(70206006)(316002)(8676002)(70586007)(4326008)(86362001)(54906003)(82310400005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 18:16:45.4556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc24e589-0641-4f3a-2090-08db086e4e4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the pointer already, don't need to go through the
lif struct for it.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4dd16c487f2b..8499165b1563 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -148,7 +148,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			mutex_lock(&lif->queue_lock);
 			err = ionic_start_queues(lif);
 			if (err && err != -EBUSY) {
-				netdev_err(lif->netdev,
+				netdev_err(netdev,
 					   "Failed to start queues: %d\n", err);
 				set_bit(IONIC_LIF_F_BROKEN, lif->state);
 				netif_carrier_off(lif->netdev);
@@ -2463,7 +2463,7 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 
 		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
-			lif->ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
+			ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
 	}
 
 	up_write(&ionic->vf_op_lock);
-- 
2.17.1

