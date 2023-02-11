Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52CD692C43
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBKAuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBKAuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:50:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F199765D7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:50:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtuP0HJhZ23CM5k2BxEBtL2zYJs/dltYK7bCkEycLNb5UZpzsZfoxHiP6KqeEFQuTdUpEiFsoVc5YH3E3xuqtRfDPlNbUz0VqoXFed/tjXaul1kYCTW0kdxQ4pnIjYu4lYfxvw07ZBL4IFQWYDpCxPFf7cHDhq4ZdgdZGc069XksUpQiJ+bwcs6KkBYvffsd2I9Ikuz9X3StaDoPKhCR3uWztY11lwtktp2t46OFfqRoNIBvhDoKLnn+cFx43JdLrhD8JVVz4UJwRLrNaGmhmLMAlwgupE9FZdZcsdUmJgF6Tyu9i6UBsBQ1xeHlnSJMP72pvttiLgWGEUEw1UjSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=SbOdjqw2aQBH13s74XutHVFzZBHqTTV64U3Ew8PWXZiwtPtsTCRn6wkt7r3uSUINUH4hnEtmMj0R9K+sCiB77VKV3s3s4mSuxxDylY7eFuxqYKN+BXEVSyMnljbNOn9LLMrPPDwqp4YlbkEu5Uw0i8sqtU9M0/9swE+96CG7u2/crw4GkMTwvf6ebZwsZZ4/9PgUYZBJ2krniDOrwRJKac04d3+pKJPprIMV+5ErkW5xxj04j/BwlneDEU2JUvHOx8rPbpQ9IeSB/8mKBLq/Gq/TkXy8phRFWeASgbdrEEj1oR5s5iH+xkxj18BGyUS2sEl7GsSUZS+YmzGjvsWicg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=DZIw8lai6lKJXSJoVJ7zVXXend6DA8wZHTlIC8B4KEgLTRFYfFiBtr+VGQt5QtzH7YAvZsBAda7utIM5nW+rx1TnQbvQFztKzHU0quJPtWFGbye851BCscmyzWNFAU8zTxn5UfMayjhPWgCJtwoAOjlf/AGxREnm0My2t4/Fpxk=
Received: from CY5PR19CA0061.namprd19.prod.outlook.com (2603:10b6:930:69::7)
 by CY5PR12MB6297.namprd12.prod.outlook.com (2603:10b6:930:22::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sat, 11 Feb
 2023 00:50:34 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:69:cafe::40) by CY5PR19CA0061.outlook.office365.com
 (2603:10b6:930:69::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Sat, 11 Feb 2023 00:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Sat, 11 Feb 2023 00:50:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 18:50:33 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v4 net-next 1/4] ionic: remove unnecessary indirection
Date:   Fri, 10 Feb 2023 16:50:14 -0800
Message-ID: <20230211005017.48134-2-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|CY5PR12MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ebb727-485a-47ae-dde3-08db0bc9fbeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xb/SH9uPYoJe5DSaN5VtTKAJtwwWlIp78ty59HFcOj9S+HzRaNVbhXSz6L0tC8bOeKKTIM0Gz2NPxMhVYRQesrclj0GjA1SLR15sHl2Oj3jl7rog5uUH2Bn2F15dmigUULgNheN2n7Sexfe/wiCijcUd26Sr3+TVw5CtUQtRP+jLPMG3xK7ipwRrI//4jHNULt/spiVzoQbKoxh+OR8R0oyVEv9A+EvKGl53SHw5y0fkwMJgBN1+Q0WHRVH6FpU8be4DEaoDQ3HrSrKgQeXHOro5UN//Ynn8by0pxxtzPofjMo10gizYYCYeYAj6u5m/C4mFB8ptOISkliwq4+lJOiUXoQ0zVOQ5MxA/fXCHoXHjrJhO22t/UF3guUn52J7XWs3QWYa28HL1Rhjfu2Ce5YRDII+dn5mvElO9LC1G1flGtc6pvULk3xsZ6XrZqNg/3G/SNgKkv/ZtxzJ0sh1sa+igH++k9aw2ZcfYBtTsuJeSOmTg9jlCx9sSppAZ7vvna0HbqgC6QXvVOBL5R7m26oEe+wbnvXklGGhlRr9kjeM5zYVs8/chj8FNYsuoPW3QDsOtVxQ87U3mmKpPCgatxSOflgCSIJVfP0PF0DrubGK3fYKbGfJXg8SdJrxVZH+eAN/6DhverG5cp5mVZGSGSjloM2cHflGc7cH1ZGfR0bdrHMTcZ6gXnm1GSw/rf+i/hc+NOczdrgGm7ojqRuFMny7bTvh9m1RaZNcdiOrzEyo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199018)(46966006)(40470700004)(36840700001)(8676002)(110136005)(316002)(5660300002)(4326008)(54906003)(70206006)(70586007)(41300700001)(82740400003)(356005)(81166007)(86362001)(36756003)(8936002)(6666004)(186003)(2616005)(16526019)(1076003)(2906002)(40460700003)(40480700001)(26005)(44832011)(82310400005)(478600001)(426003)(47076005)(83380400001)(36860700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 00:50:34.4835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ebb727-485a-47ae-dde3-08db0bc9fbeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6297
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

