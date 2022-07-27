Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36547582368
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiG0JoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiG0JoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A573FA1D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hw2JAlIOMEcyVzOjVu1C8U/ecO4yEnbqOTbTnCmkTLeMfwG3Hk8XOHfWrgE+VUgQnvSgxdS4bb7YI+wEk/UYMIg9BATcgSdMOaqnz4KkNmz0XtoiqJyl6Z+ZDWpFH2DZIg3clgxcVUEZVG/YUFSzOoAoStpomPWs5Nsjdf8E4CAFHUYIBb4VHK8BL8xq06kmj5j+OHE/K3c5OnCyC32MxnHerbAlhR2iCRJl9yRRFBaPihLwIdn4GAVFfzLmrtq2pyQ55+zhoupGzDyXpxtZHHTTnFyFwD/tWXvCFnYtxy6t0hwyhkrPUi4z4cD9wXrMoOEvKvsCvdimbLNfdaHvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XX4QrJ+IKkmo9qvqC02dC079qQqcebiEA8XWWYRrow=;
 b=HA3cBeVOSEDX/KvtQv9tBzLEvW1MY5blKMTW/b8zm0FkQUIZB0jC4y0lbpHXxAtIXEm5lsDy7STWd1dJalj3ovRDrseBpBay1c90/GPqJUTIkdC75mFx7DWx90rWcp+hDwTzDTCWPXIvG+blf8AtEq+XS9o1BfpFXdNMA94xqV7S/2+3IG3/1pzQJRxQgmfP9nrn4rEahGGG5TNz5g3M328c4cQA52bi8gDlJAp8MXmxY/wxI3VAh/yjs6QTgOO3liKxGtTM6EBsQ/sPGAHOlz4/Ybm5SIwQRPBMmW73JxHTjS13fYIV+63qThRssaoTYuIO5lOrw0ilwQQTwfyyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XX4QrJ+IKkmo9qvqC02dC079qQqcebiEA8XWWYRrow=;
 b=EFOADpYzHNU0Y4LVG+Lrvi8140651Y1oaewH32CBnNZa2sm+JVkJ+WKNrGya6bZ7sDD8ctMQa3TI0XMeyylJNvAVf39MCkpEQ3Ax9H7DRf5TvWI8oZH1PPO6w3xybfzF5IKll7gH5wPV49gZ6FOOKGui7+ozMpLiNhgkJr8ZHm2Wfyu51zJDwEF2b5jW6fEWu0oSGg77UBWgodoN/lyLsNXTo3m8jYIDG56EKJnm6vgf9NOmHSuOeWe4+sMTjvQjjU0t2FW4K9jornaYmb0IMm6KG2FYchCmZApwKC1kk4QIPWGH222BfIJEobFKXKSiWE0xEiU9rEJnjzdpYcKIVQ==
Received: from MW4PR03CA0219.namprd03.prod.outlook.com (2603:10b6:303:b9::14)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 09:44:10 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::67) by MW4PR03CA0219.outlook.office365.com
 (2603:10b6:303:b9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:08 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:06 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next V3 1/6] net/tls: Perform immediate device ctx cleanup when possible
Date:   Wed, 27 Jul 2022 12:43:41 +0300
Message-ID: <20220727094346.10540-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47d365bc-7ad5-451b-51f5-08da6fb48e92
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0U5xZxkmetiV1zBlFBuZjXgmIorLsvpJgjd3JPXF4HDU7MJyLUQp0Z/sG44mhi8OePNBF+G9vK784lakLAvpU5W3A4RFGFmpR8HHg3GfximzF1jR42CWSweNi9inm446ZvKME5u0oaH8r7pBAq7PGeVsXHtbhV3HyZ3mT9N1v8ULryteUdlM0y6UpO+cTVtyGQO6aGTD6Abt6BgE0KC7QVdJvlbSAVL2C8BHu86Ceca+E5Ec1IGExuxrVsqN+jTNBarlub2uToQXKc36hdQdQfr4LMp5U19lKsY34yU3S8TAMxLvUhei+C8yTBZcaRkS8BpLUiCMgiXDDr5tr+S1lYAzaiy9zq5gvhLCD/HHsPPO+WRe7NgvyMsbGfo9jxCdsSCQYleyMAkgiy/cgt0TamKmiJPvE4VydT6iUSN7PfjbYmYGe5xRK5EjS1uzzUJM2NOo1K47Gq6436U5RCdZ+7REzZF9+6yX6bL0a0Ye5A/zfFe6MxXMytC4KZ6MCvV/CyBXPcZ/is8RNx3Kbaf9LENOpGzIr931+qNJPl9wHhBoK6hp8MgpptTrXCts2a2XOsfQ837p1MZSX2YHXQ+CLieGXkuhpk9GNsrF9AeracW3GWzQtEl4FFFBXY2kQW7gdCKqQLvD/xiudRToBwuQk+zhdda5IQoZVCl9ofWBgVvmOil0WkN3OkiAmQzLpHMSv7mqrvBKIFMzP8YEHk4/KOIYQt66R1xvbVweTQmYKxUKKY45ShzNeVG5o9NYkJ2HyN2d7YzKi44ButIDkll0KGV12gHvvb2tyFjjKXq11bOzi6cdUsOtLzbbkg2d4h5WAHYRcvo3SwWXOe2InwlDH8Mb7tcNMy3VrxYUO2PgjQ0=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(40470700004)(46966006)(83380400001)(8936002)(1076003)(26005)(47076005)(5660300002)(82310400005)(426003)(336012)(107886003)(2616005)(6666004)(478600001)(186003)(36756003)(41300700001)(7696005)(81166007)(40460700003)(70586007)(36860700001)(82740400003)(86362001)(70206006)(40480700001)(2906002)(54906003)(4326008)(110136005)(316002)(356005)(8676002)(14773001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:10.2003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d365bc-7ad5-451b-51f5-08da6fb48e92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 net/tls/tls_device.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

v3:
To solve sync issue, rebased on top of
f08d8c1bb97c net/tls: Fix race in TLS device down flow.

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index fc513c1806a0..7861086aaf76 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -96,19 +96,29 @@ static void tls_device_gc_task(struct work_struct *work)
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
 	unsigned long flags;
+	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
-	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
-		goto unlock;
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount))) {
+		spin_unlock_irqrestore(&tls_device_lock, flags);
+		return;
+	}
 
-	list_move_tail(&ctx->list, &tls_device_gc_list);
+	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+	if (async_cleanup) {
+		list_move_tail(&ctx->list, &tls_device_gc_list);
 
-	/* schedule_work inside the spinlock
-	 * to make sure tls_device_down waits for that work.
-	 */
-	schedule_work(&tls_device_gc_work);
-unlock:
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

