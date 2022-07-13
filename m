Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86CB572CE8
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiGMFQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiGMFQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:16:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DC4D4BE2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsQ2W8tePG3jCzrGmbWSwvbY673K9wOWGvTE5C9R59Brd9qAA9fT973u4+ZuQe12mGXGaNyYRpobzibE8XVYOHgG+ibcOloX+snH7C02qX0rvnSrIRpnSwpQapvOyinlwlk/TUE35kklAW9AHqWl1qbfE6oVKg1FTOOIjqBs7hAlguHpOfOQHs2UBLgAs+ro4pVCF4IjKWaYDlKaw8VddIOrIVZM3GoLnwSHIJt6KccuqiPn/b3ezGz3LfW3N5iAQXgZSJ2CH8/CqwfRw+YxIkCWUAN30G4WMJ8gLmuhNra5LJ+OUpRqX93XJNGG4nwRC07tk0iCJb7sNB7rELkO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RyyPFcs1zcWhX/Ju4FOYO0yjTHX4wy7oQRhZjpKQ3o=;
 b=NiNqQLUChqklXR3+93vHVJL2r2jSTBogQlM82shPPHM5ZOb+a+7PzryjO09Rc1UmgZ9pYilwi5wc7WcldGHk07Cw+invLDYP/GgW5wjFbd+p6NkWlzas6rVFmkLOgDLXXvbk3kAGeVqFbbXEweliNOCeTeOUgHaOOHFEc3wTewrTIQwCCJedpr4qIRbI88CHh/3d6QzlbRsgH2f0PsNWkqEiJsK1BYYpyQHyjCjcvRkhGnz/hIE8qaENP3C5Q9ksd3WIoLsbop8zX8Esctfbk2rR6u7lDnc32a7zKehqRfJRwMmd7U2WWo+K3THdT8tpLuyEKNQxNwQ1SL6bpaS1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RyyPFcs1zcWhX/Ju4FOYO0yjTHX4wy7oQRhZjpKQ3o=;
 b=hoDigWgnHzHcwNkdb9CdmurVXBfF66nCpkLqUVA8/CldLOF3WZL8X1lsmrSQjGctqxz0oNYG0zgBgECBmuWUZ5tK877oLpcrnwh/5J9bvUhP6jJMcXj2Hs2O/v9SzXgDmYszDxVV8G6LBGHGLhdaNtU/PpyDz+QqYJ22mP7WpUMt7BPbDjw47CZ3ksGmfm6lQQXcPhYb74pmnUZkjktVw6atvEV2gb04hjRrU2Tw+b18dH/5rsTCncalq1A5PXsQTj0Gpf6lBL6bcfSXNzx04yCv7yOS/edfaWh5sTY6RH09aoJ5CkjsQAs61GrYtVC1+shW8+TeuWrcLCLNe+2OZg==
Received: from MW4PR04CA0083.namprd04.prod.outlook.com (2603:10b6:303:6b::28)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 05:16:43 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::88) by MW4PR04CA0083.outlook.office365.com
 (2603:10b6:303:6b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Wed, 13 Jul 2022 05:16:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 05:16:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:40 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:38 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next V2 1/6] net/tls: Perform immediate device ctx cleanup when possible
Date:   Wed, 13 Jul 2022 08:15:58 +0300
Message-ID: <20220713051603.14014-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220713051603.14014-1-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1653d14a-6c6c-40da-e973-08da648edffa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9xyoECgmV9BMl5XMKZ+zA0ZNOLKKJf7ULc+sRLwiYjE0bFyssFO0aVsFoNH+iizJs9PTO0An/9XVlyLrT7i/FTtnA2ohALxS6ikKlq2WLmOPwogitdczNpYP8z0Y9NcTnQrEybDrDEtsqF5vXglZITuAwQH7qvsXdFUa6xErJ5bc6Cig+yDZypKzMTf1f9RBK7lvt331P/JzIOQQ2lqOyVFcEIJUo32hAuHKiof8XVQGa+h93IzjESF9IQNZXxVNfPYizIiFOS4Cm8DnKXwNERlToGeGCXZwJHM/58kH3pj2Wkql50LzcfKuB9M035wVFJMotnWOq06ev3n3i9HlydQ7tnEac81qzbrvuh+LYGJCnQHr98LZY+5VLL2ssOJCawS+5eHkgFnu0wtf27Z51apAu2J5MWJ5f9I0RqXE3o8JC6/ch4KQBySCq+KgROt9LJJJv7eryhjthtC6JQQ4hqbOhx0DdSZOphXbUOMVcV+In8WNdgMDImmAoUe9pYHp+Es1tLJvC7+AykieVWSN7K3oCy95WXsu2uEBQQ+JPhVcM3lhcQp9ttjs+8YNycA9DbGY0GaeMa5vJusIaMAMMcUXsiAusoMuBkhxRveO3dF3SumwzDVDSdmOSjOLCQVCNTtoqqgxnzpwiPklRUwZ1j+BXJNFmiy4Bb2yviHqP2F8ZJPROk8lAboTykxiA84MqCGVm/YjW2jB9U3zEx4fR527GSyCJMel/eCqpz3ku6gMTnQrcegYYYstsMSFm6WmNytKTEwCpAMvEjjTQjdfMkY2mK5qCcRuTTZ0CMY6bOjQADKEgLk00nUv0YMjGaL0kj1H1yLcWunOZHiA5ACm8sJ/SamhkI9Blc9HwmjKyk//71KC0KtePZJ3yxbV1Po1
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(136003)(39860400002)(36840700001)(40470700004)(46966006)(478600001)(7696005)(8676002)(6666004)(41300700001)(4326008)(26005)(70206006)(70586007)(8936002)(5660300002)(2906002)(110136005)(54906003)(316002)(82740400003)(81166007)(356005)(40460700003)(36756003)(86362001)(40480700001)(82310400005)(83380400001)(186003)(1076003)(107886003)(2616005)(47076005)(426003)(336012)(36860700001)(14773001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:43.0836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1653d14a-6c6c-40da-e973-08da648edffa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS context destructor can be run in atomic context. Cleanup operations
for device-offloaded contexts could require access and interaction with
the device callbacks, which might sleep. Hence, the cleanup of such
contexts must be deferred and completed inside an async work.

For all others, this is not necessary, as cleanup is atomic. Invoke
cleanup immediately for them, avoiding queueing redundant gc work.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 net/tls/tls_device.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 227b92a3064a..fdb7b7a4b05c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -96,16 +96,24 @@ static void tls_device_gc_task(struct work_struct *work)
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
 	unsigned long flags;
+	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
-	list_move_tail(&ctx->list, &tls_device_gc_list);
-
-	/* schedule_work inside the spinlock
-	 * to make sure tls_device_down waits for that work.
-	 */
-	schedule_work(&tls_device_gc_work);
+	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+	if (async_cleanup) {
+		list_move_tail(&ctx->list, &tls_device_gc_list);
 
+		/* schedule_work inside the spinlock
+		 * to make sure tls_device_down waits for that work.
+		 */
+		schedule_work(&tls_device_gc_work);
+	} else {
+		list_del(&ctx->list);
+	}
 	spin_unlock_irqrestore(&tls_device_lock, flags);
+
+	if (!async_cleanup)
+		tls_device_free_ctx(ctx);
 }
 
 /* We assume that the socket is already connected */
-- 
2.21.0

