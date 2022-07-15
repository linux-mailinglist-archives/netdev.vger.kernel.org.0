Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C83575DAE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiGOImk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOImj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:42:39 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A31E81496
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:42:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWOVlzjOROtfghfDCjrf8UIGYODyvk/bfBVPkEfaYptY9sFAumYGTVLejkn7sQFGKd0oa9BlbYWSIPbbZ7ecRP14JnaNmpkhGFx69eeTiAjNCX2K+FtdMojwUzLvwWQvWymlmQJ6FRBTnR+bQsPbrc6G5LBEk4O7RCsvSYXwaHo16iYSovb4lxdjyJp5moD5YgXQpTld1p/dc2wz7JKpyA3eXDSzZTC3159Gt8D86UxHa57pQGpdwKJHYwcPjOs+7gRDQqT9Biq2FV9oeekmHJ41FMYCZPiKBVsvnhf4YTt1Tglz267ipenYO5e5cxa+oR9ysWZlMwRqyk31iqVoOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehLYcpe2umCuMubLewj+3vcrxku/JEY6+YO1JlibqX0=;
 b=cY4bTaFuSQd4FKE2J9aCSQ3mmscmk8APfzjZDflJKDDPIjxUIErD5e/LS3cGMgQe8Q+EVxrXk8awTsmZXbriz5p8wzFpV6updFcqkF3TEGfxtbWr3wvIOrhriCjdnj8JuXhXjkg8yVihl5RmwPcQsJZAlTgiO9MSBY+nZx5w0pR5ggEwahwPXqU2yUdZNKATNYAPOKKN/BuqjRv3eBfRJQAqKuV6S2EuSXX0t+5VPu2RO46LYyoFioZWWXc5SI/XSBXOEiLux9kA6BtQMhfFSYyZA41Aq2wkKj6jMon8orD1l2oQPZtjfkbciDBOYXGCOEfQMCUXe6PiY9PmEQigWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehLYcpe2umCuMubLewj+3vcrxku/JEY6+YO1JlibqX0=;
 b=YaZFBQiaYkrDgmEvTj4dYDFgX63fDf3O7CRfHrJFJyuBWxHv7VKtEwdoSHtekDuzUMEAcesAZsWiEx4DNICeL1HmkxNbOATSr7wg2CU+tzhuSyv9IMKY4CEmEv/Dk956VqmL3ZH+3Zqbnyoi9CqdQr/oblQEIgt10tkINv3QMrw+b/9xzaXWAGjYy3U2AAeXZjZ6JeJD6VgIN0K55ZOdWBRAEZPTkULA+djGdQ0kl1d1YYtT29viMc4fwP8G8Hyu3gtBs9VeZQRxuR79dmnOynRTkZ5VoNuaEwYePcim86HY/6MhE6FK2MM3V9VX0Dxip038Gx2XatCtfEHVxGHYWg==
Received: from BN8PR07CA0029.namprd07.prod.outlook.com (2603:10b6:408:ac::42)
 by MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 08:42:36 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::36) by BN8PR07CA0029.outlook.office365.com
 (2603:10b6:408:ac::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17 via Frontend
 Transport; Fri, 15 Jul 2022 08:42:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 08:42:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 15 Jul
 2022 08:42:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 15 Jul
 2022 01:42:34 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Fri, 15 Jul
 2022 01:42:30 -0700
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
Subject: [PATCH net] net/tls: Fix race in TLS device down flow
Date:   Fri, 15 Jul 2022 11:42:16 +0300
Message-ID: <20220715084216.4778-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 821f3e30-74f0-48e0-888e-08da663df791
X-MS-TrafficTypeDiagnostic: MN2PR12MB4287:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsOK/fmyN2QyZKSwYO7UC15e47BTXI4JyZ1QIRUOabKGxoxgvWlWL0tUoBq8ZHNb4KTVLvfD4QRylFHAMn4h9vNgb1uc6GSMuttKnK1eaVp49FHzAWbWVb+jSl57ShJCKEvznnadZzfCOqyM02lC6Sb5qB6CAkLSDvbbWjZkHVfHMrnQ1OPtcBco/pYTDf9VW6R8kVjd7g7lqaca1cMjF20+CfxsnPHyBAmEwlo4eGkBSu+8CYKFLOleLuyRqmzFyGAWhlaii0etahOu+LvVkzQ2weRlyq9qdzj25rOgodd+TS/EZqf+/D0QFTv958KijE2jNBIV4gHBS5E/eyQ5xfcSvnhGtaTwASPGQWhbhHyO4/sBMeEnnM+FAsVXD7FI4HsXfXbnn3A/9ieJzXK5kiCvFqc0L+T7qylpjOFPTnapbIcYXMPAKEBylAH+vUjIrSl1E3I6DQxtYQJ5YnYQFLPLT6sYkYGO4KUBP1FXZgp7wL1/BVWfoHc628r6ijUNfJ8zaLaIKV1VPfB2vTwCqB2NuxlU9M13g1VK9+u9r82NChbY6RcknpjVpaJmWt6+mgf9QCioqSz1DcfGTN+kivowUWgbBxTi67ZR6LWRDWePM+aG4ApHlLONwXxsITm2bjoXfLgNKPylJLQ1e9JH3Vk79o24cIiGEQ3Q7loqtbP5rtAQRQHDncXACixGUZG8AeFgm+W7eKl39JjsKIhd17DhOmvVAP6baRhOxJcbhpXuE3HZCqorp5PY8yXNJQbT4sAELJdkOHMOtFvaXRFjtxIErrNViMsjmth5xYnoaYUc1Wh4gknC9XnnShyFKV9OPPw/laabz+gZSZV2XjTRDJYSr1YnRUdgzPnGyZsvDbs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966006)(40470700004)(36840700001)(54906003)(82740400003)(110136005)(356005)(83380400001)(316002)(8676002)(4326008)(81166007)(70586007)(70206006)(6666004)(36860700001)(36756003)(82310400005)(26005)(7696005)(186003)(478600001)(8936002)(5660300002)(47076005)(40480700001)(107886003)(86362001)(426003)(40460700003)(336012)(41300700001)(2906002)(2616005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 08:42:35.7176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 821f3e30-74f0-48e0-888e-08da663df791
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socket destruction flow and tls_device_down function sync against each
other using tls_device_lock and the context refcount, to guarantee the
device resources are freed via tls_dev_del() by the end of
tls_device_down.

In the following unfortunate flow, this won't happen:
- refcount is decreased to zero in tls_device_sk_destruct.
- tls_device_down starts, skips the context as refcount is zero, going
  all the way until it flushes the gc work, and returns without freeing
  the device resources.
- only then, tls_device_queue_ctx_destruction is called, queues the gc
  work and frees the context's device resources.

Solve it by decreasing the refcount in the socket's destruction flow
under the tls_device_lock, for perfect synchronization.  This does not
slow down the common likely destructor flow, in which both the refcount
is decreased and the spinlock is acquired, anyway.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ce827e79c66a..879b9024678e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -97,13 +97,16 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
+		goto unlock;
+
 	list_move_tail(&ctx->list, &tls_device_gc_list);
 
 	/* schedule_work inside the spinlock
 	 * to make sure tls_device_down waits for that work.
 	 */
 	schedule_work(&tls_device_gc_work);
-
+unlock:
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
@@ -194,8 +197,7 @@ void tls_device_sk_destruct(struct sock *sk)
 		clean_acked_data_disable(inet_csk(sk));
 	}
 
-	if (refcount_dec_and_test(&tls_ctx->refcount))
-		tls_device_queue_ctx_destruction(tls_ctx);
+	tls_device_queue_ctx_destruction(tls_ctx);
 }
 EXPORT_SYMBOL_GPL(tls_device_sk_destruct);
 
-- 
2.21.0

