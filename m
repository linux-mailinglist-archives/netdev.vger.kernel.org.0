Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06013572CEC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiGMFQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiGMFQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:16:58 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC2D5158
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX14fQq8OFUyoK23aiOvzymNKCZaS2SXYg34HLYsAgYCL33F1AXYKQBhx3HfgNG8M4u59f7ElF0/UNv3phGYlwD6GNa5rXpT3uib+h51Ei3t6cOgxA6+THJmEkdP2DPIr8s+mUrqHYaL23zoHgIQdo5JJSdVA0Xw3Hg9zTXyY6jzRxZz5w5+zIegDoTtWlPE5QnbC+Yo4xvrl5HO+ySM7mNc7p7dJwP92QeGmVs8eEvHnAlS/+amyaj46BLeUzCcDhsms4WN8L63PeB1Momj4rz9e5cfywfDtEypxhLX+4Hqb3NcIcBbd1TXi4dwVrtn9n0ge9n/wuHKCw0xml16RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IVCPAmko9kX74MgfWr08eWJsGoNSZT8Tb0fmyM4CZ8=;
 b=Bq9/+1oMeFu6B+acxitMqLpLEqP7mwtGKI/ORQelg6XcDF6FNsIEH3XWQNgGmGL2oguOAhcTJQHT2WgzGH/jUPSD0ZiRvzCKcpgQJ6mE3jAXWtsJyCnbP8LLuOGSq0fkB0TrM5ETz6fVa4ZG9ovzdpWjVv6z/hk5bgp1dyb7g8w9PrthWayEWG94d8DEF6xZqjv3DiUkbkI21ChCF9+dP4rxFmBTvvOjRim1twsFOw5LG3Ko3He25dsvth0zcgwHh/+YhgHuzCYJbvH/nW2dOO6IuVLjRTqkvETvUFmtSEj9jmUSYGI53EVIZh78nNlegGNrG40dkqr8wykz+hVEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IVCPAmko9kX74MgfWr08eWJsGoNSZT8Tb0fmyM4CZ8=;
 b=IORE0FpdMcxwmtOiyZHUhNoy0lBjCD5GO406I67rdQD+D/Bk7bYcLAf0yUXRS3KXf74DpJWMzkQk82chjDGQmc0qE9jpwTQQO5DitJyBnC59Ab7sydIHD7Y41iKBa/8bW3v2R4lvvZ4dWruPCbqj9uRwOu5gg2U6kb4kS9/AK1eAom2qCfbNieMlxahAFZDHiEd/487arF0czGVyljzok05LAiMnkIlQp2ZiZVRaOA/flUqPy2H+uWfoOul58gn+f3l7GDrBkeBlB9GVPPqCfvf6mBKJLQaHferDSYBSSmDabuDLAKB1UD2dDT0Ld3r3r+kbxJDkOM3GOMJk72DFdg==
Received: from BN9PR03CA0412.namprd03.prod.outlook.com (2603:10b6:408:111::27)
 by DM6PR12MB3708.namprd12.prod.outlook.com (2603:10b6:5:1c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 05:16:55 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::a4) by BN9PR03CA0412.outlook.office365.com
 (2603:10b6:408:111::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Wed, 13 Jul 2022 05:16:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 05:16:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:50 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:48 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next V2 4/6] net/mlx5e: kTLS, Take stats out of OOO handler
Date:   Wed, 13 Jul 2022 08:16:01 +0300
Message-ID: <20220713051603.14014-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220713051603.14014-1-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 413cf7e6-93ef-4ded-21ba-08da648ee6a6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3708:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDsXdZPUmHL1aHe6H6Q6R7PoUGl+18UZhKd3ORt0ukQByWlHeu7Xeia88LDCCVrGDPddt+Y1SAoedtKqMTt5boE9H2lmYRUGmO8Fyg6vbF4HK512sXkgOZU7JxODANrUtNk7h++HtwHIgdt/tL5SKTRwHLx4mAgrxhBAbpW7IArOHNNi4FzwAmrWoHhbake+XKOvvTZvzGRVZFZwnj6Xc+SvFYzHw6v15sqQtYb6oU6Fv7Q6E76Zl2EwOf7DSK138M+22R5+WM/VhabFSweg2IkkB+0IJQ9l8QjBJSeZVz6ht51q45glmSFL5M4aNgMn1SuGUx0kK24rmfWDWW6B7rVPEACHn8zBVCEbFxN+oObwVwWyXgltv8LpelpFUx193s3C4ncLzhTO5peFyNcl1P7LV6CCGCk0vNbh9vxMyZZjfD34HI6PSplLd0/TezlQoR43jHuK/mC+d3DkW4czg5T3FbbhBSVYbq89YBwE553uhkuI5NdM5jXfsdvXOEdrRpIUquLv0NX3r4vLX8NkDWWCJGyznT/NT9+aO3ulE/UoVG0RL7ctu+RuU/9wzi4UtKSAMqC8TkZW7H411wou53P8KlRa7maujdq8pJIyIXsm3v78Qo9xUIgizrohA0V4ROKJ2DBxTXCpAXreYFYnw+8yrPJ7wYqlrm1/QNsSuL0WacD0Zzt3y0B38gu9gwKio8xlkwp3HK923iBlefZIjWHRqrzEXo44NjGvMTd+cHk1iW8AhiqDDAoE3Juh3EXgPifOabQ/iCqqhvOnZ8NRSOsLLJz/GxTQBgaB7te3buqufUvlhBzmyJi5f8EFeBFy9a6oyTb54TEc4B8+PfBb8Z8kvd8TXC2kb/fAlLJtk/w=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(40480700001)(83380400001)(356005)(81166007)(86362001)(82740400003)(40460700003)(36860700001)(82310400005)(8936002)(5660300002)(478600001)(6666004)(41300700001)(36756003)(2906002)(54906003)(316002)(110136005)(4326008)(70586007)(70206006)(8676002)(186003)(2616005)(107886003)(26005)(426003)(336012)(1076003)(7696005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:54.2565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 413cf7e6-93ef-4ded-21ba-08da648ee6a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3708
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the caller of mlx5e_ktls_tx_handle_ooo() take care of updating the
stats, according to the returned value.  As the switch/case blocks are
already there, this change saves unnecessary branches in the handler.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 2cd0437666d2..99e1cd015083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -382,26 +382,17 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 int datalen,
 			 u32 seq)
 {
-	struct mlx5e_sq_stats *stats = sq->stats;
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
-	int i = 0;
+	int i;
 
 	ret = tx_sync_info_get(priv_tx, seq, datalen, &info);
-	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE)) {
-		if (ret == MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
-			stats->tls_skip_no_sync_data++;
-			return MLX5E_KTLS_SYNC_SKIP_NO_DATA;
-		}
-		/* We might get here if a retransmission reaches the driver
-		 * after the relevant record is acked.
+	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE))
+		/* We might get here with ret == FAIL if a retransmission
+		 * reaches the driver after the relevant record is acked.
 		 * It should be safe to drop the packet in this case
 		 */
-		stats->tls_drop_no_sync_data++;
-		goto err_out;
-	}
-
-	stats->tls_ooo++;
+		return ret;
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
 
@@ -413,7 +404,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		return MLX5E_KTLS_SYNC_DONE;
 	}
 
-	for (; i < info.nr_frags; i++) {
+	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
 
@@ -483,15 +474,19 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		enum mlx5e_ktls_sync_retval ret =
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
 
+		stats->tls_ooo++;
+
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
+			stats->tls_skip_no_sync_data++;
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
-			fallthrough;
+			goto err_out;
 		case MLX5E_KTLS_SYNC_FAIL:
+			stats->tls_drop_no_sync_data++;
 			goto err_out;
 		}
 	}
-- 
2.21.0

