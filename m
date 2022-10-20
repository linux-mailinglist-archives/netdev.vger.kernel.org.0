Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41841605C2B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiJTKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJTKV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19351DD8AB
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9Y14AokB6wXH6YRWYcu7SPMtuojTgY6zMbEwDv2BJDqF/55muFurdhswlHZWcwHZAhNywfuB4SznlnrlCxjoF2D84OMqra4+JZqEp9Rv0UR+XlLVYIYuiyTipC0jgLdnsnMWplByjPNX+Xpk1acD7AfcmYfTPQPaXqL1VjVgIaVwCW6o7523Rn/sS7fOafSFpmfgj+m2D9O4Yu89nK98oXFoXZR8YXKHaxQLI9cbKrz4VaLSmqkkpXDaNtl5Io0IVBIty0+03IlBE4bRD94wulmR0lHlx2JhmQwDz97YJ6R6aKrr8cLBHiZTXeAoFyqEsYUpbvG1B6a0SPJaTaDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9C12ikJgiNJ7ovIBsT99Pt1saQ9o8YC5duqwiESq6k=;
 b=MDqS3NFwBJWS2FD2ZaJPjlGYRJp2Y/Z2cIMnmzv6S1VmEXf6ObCb67fybj+5i8wOE/HBdvhMMLDwMxGNupEvt1epCDKRRHtw0aXVZSbQiF5izIE/fMWo3elwFlOpa3HMZUiTdnRtwQxpcuf/0sOHzlHy1EjNiiumkfUV8BDjotASH5tct9xMwp2fL05bw1CRl7q24tvEwVrcSK2fL1BlLXRSLIJXryfgJA61Z9/6+v4uEFj37WpRVW9Wxi3ycxhjebBilLusetEJylaV5D1N69BhyczItOEvaoTS0rL8xRGeNdkXP0KfkrHuVD/5i3xJh3rh0CWmlA84EjjBPHs0wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9C12ikJgiNJ7ovIBsT99Pt1saQ9o8YC5duqwiESq6k=;
 b=pLrzjFw5A+Y8y7Ii5BwkzfbO/uj+JMY5QvatEuHIxvxxgcQMF+DNv4UvYkx4pD9dfbT7z3AjpDBnzBd1IiErLP96a1OS02aeo0W7PjZSPgZGvzP4yjuWWGitVNGBwDNvq4hJDh3VeyRTJS1cw2cCMyfObmzXZmQueQVx+NitZChqbZ9SUGIggJuKSdon8J2QPQATfuWOg7jfiDWlVSOciaZlowdtIDChTCi8Ut085/WPCm29PjJXJAveh3V/Nlds3dI9ap09gDSZOl2N533dPXJ3ZuCV59fRa7pcmnRBg82Xridf2tImJl8TPM3yKA83C5FwVXEksXTyLgkLnFQGMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:27 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:27 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 17/23] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Thu, 20 Oct 2022 13:18:32 +0300
Message-Id: <20221020101838.2712846-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f0b8953-6a89-41d0-6e7e-08dab284b572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3hfwAVU90sQbl2PX+KaAiY14CRtYcprf2QLW+pPskcFL0loVNhzNr+PUW3lnOdJgblX2H9UO4hpFRNSFsYnzKYNBgZiZgbnXz9Z5ahhf8TDOhH5EHWA1TQXslTcpmjwW6ArHjrXVprNYCJmLftWMf25WYFZY5G2pd2Kj9fjwalU3CYNtJm1jB/kiBzH8qDfkzIgKWtqPSR52K4QpwUjGVX/CetlPjJswoqGS2xDne+pNhLO2JeFFyiyeoLS5DUQg+z5WblxnvKNddv/ukjpc+VqEoObSzJkHIdeK+rxAIShH2TGuAldrrDEqkPwS6OqnIcu3tI3uSWsb8x6kFtk2/4e6qGkCjz65d147A3QrTjMFEUIJ+80Q2ejeilLEecfHiTIX+1ikNmTDA/2zrNo3V0rkP4fEITWTuYSNdPS02x93R5DKbDm7WdZWeHLIzg+mR0dUQMCNEIsJxcUyc21l2S3KtiNNOJ0yB7tzfMESwEoxyyAfCtMK/n2sAjWg5e/WvAlJw6zpIBI5yxEJmBFD0yZ3PqyLvsTC6sX8X+FkGTXhqyFJZnoqa+dcWSNuRRAMdIUAJcaNH9Dyb82omzh4HbA+uC6DDsuvQzXyLVIjaBs+tqTowZrVuHRD7RKntMzML/RaaqhGQbPD/+cTBb5J5EYYBYP2Ci2lcLUPL0ZTTEWgNtWiQeOI/kwqtVqJ2NHmifcTj9fR/bOoYnVrLiZqdzblNuYBnwGnojCMwCHPwBYKDezVEJbeQEAItoXQVNh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fA+eOH/ZUXq2/8EeZS8BtwrNHVtFg3zGlkZYWI0rTbDD5UDi4G7niPoGH4Kh?=
 =?us-ascii?Q?C1Fp8Me24w0hfe22pnNDycjVFi6R8vs69OYoYLlC6+NQo/RMgGrpQX/Lreaf?=
 =?us-ascii?Q?fD/J/qjj8VK9jzZPiV4QGxuef38NbwzxOqBR30/V2v8hGw17RFgiBMSt2uKq?=
 =?us-ascii?Q?DApy/uXlO2cfVSL5SmzARJVfjSdFO449aTQg4xNaRv7UJQ+SvmCuMIGwBH5K?=
 =?us-ascii?Q?IavUiUqd+DL7EIFTZdgKTPk5m5p+LKDyg8GtZD5j/mrtiPyqYzWr2UtdOjq1?=
 =?us-ascii?Q?bWxd1cS4vlyvafq6aORI7MsfsgHSxZp4q/wTKevTkSuAs7Ck2Zv5LRaLQA0K?=
 =?us-ascii?Q?uMBm1EvTbo9go0GAhp4ocWy6Ygr/mULCkWRXb3BTqf6ohC45xVZ9h1RRnVWJ?=
 =?us-ascii?Q?AsnyBO4e841Szc0drrmPida+RcJYeVHeUNPhqN3OoW82dMWZNw1A9tRRfqWM?=
 =?us-ascii?Q?yp2FLUSqhUK5+Yea9kuqLb6RhqZtzgptVNY6gIFONUuI8wQTdF/sbSWRKCM+?=
 =?us-ascii?Q?o4bJeWdG8vO0UKP7slKsAhVLRZnhiwuVpEIMDT735bh+iV5nW3J0/7hdAaSg?=
 =?us-ascii?Q?/VN8kj5opKa8WJI7RdrDIcB48GJmp3vXmSNBWh1rTUjn6nmoWjvLu+sAdbq8?=
 =?us-ascii?Q?5k8dwEwOhB4rHdZT5rm7ODBdTINdUGNBirfTCKMucIlbmooEt2alBWelM/gq?=
 =?us-ascii?Q?fwu51qDSU94TP+igvjgMr3BjbQoscA0mgLTu0XI2W97YbCy70qlDEv4kGKbA?=
 =?us-ascii?Q?cJ9y9nDyQh5NoZi0OsEIeZ09aHkuWz8K5jxjp6GCEEraVtoCXGWzeu2WdP6O?=
 =?us-ascii?Q?2FGvz8QN229AIXKq6In/O59poxG4ivX8vfExTUr5cTNxCKQaCPrJxSQvNPB7?=
 =?us-ascii?Q?3N2+mI3SMPrqQgGF3QR70P8tRC7PJu7X7PUQvNFB+n92t4QErnrpvQwTDONo?=
 =?us-ascii?Q?X3DH2GaQRb7R/hE6+wBQ4XiktTBI5CJVWijjYeVRI2UCnvo6/+axe42E4ukF?=
 =?us-ascii?Q?HMm1k7pyfzAQLmJSmV2YvTANruy3hCxo3nh9nS5id7Ls6pk3coDoA51ROqxK?=
 =?us-ascii?Q?dfGRoel827Ok7Qx2YJbIJKf2qBvEKBXKjGxwr3bpa/poO2MXnk3P2i7qkFvC?=
 =?us-ascii?Q?CTy0hex4TNr0mbNVJv8kjpxcyQljMi/RWc7RXLdg3n92eNuQrx48eCJX3jnT?=
 =?us-ascii?Q?8F+yM/WJq/cAnKSX6E8nBcgxG4yhMsodmG8xLaUV+HVv+2URcIkiarkSGuoy?=
 =?us-ascii?Q?A+yWxkWTg94Lm84jLQwlJW3YATTXdiObk3K3+0LM5hUmeRinNbQm8YxIXxTs?=
 =?us-ascii?Q?uU/UFCnQXQEy0RziiPOQVDH6PAiYgvPrl/CursMj3AdvqWpBfVMm0CNRPGhw?=
 =?us-ascii?Q?IBrrbt/zbK+H76v6sgQlAUxa0rpqNbjSFTYsIhIMRXtccqRi+BqzBPxFyltv?=
 =?us-ascii?Q?OSkqtUasyoOsqBqbrUf7q1fv9lE5rekkPxdI2Z6xAki1U/dtW5KEaKEXZapC?=
 =?us-ascii?Q?J8GFh8CypXaSUcditAr6s+8NR29vYsmLAol7jVqbtAS1nW7HR3VCDaBoZ3/l?=
 =?us-ascii?Q?9qNRwMx8kkl54haXYWWa9mcyKD1eIUF3Ue/oE2YS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0b8953-6a89-41d0-6e7e-08dab284b572
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:27.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBwodtWiSWAfuikeluLkRsH1BqkDUJgvpcxnvW6i131ctnB2Bq3IaYU1/Y9E85I35zlj7m1hXy5Tq7tq5662Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

Both nvme-tcp and tls acceleration require tcp flow steering.
Add reference counter to share TCP flow steering structure.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h      |  4 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c    | 12 +++++++++++-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c      |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index bf2741eb7f9b..e4a121ae548e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -77,7 +77,7 @@ enum {
 	MLX5E_INNER_TTC_FT_LEVEL,
 	MLX5E_FS_TT_UDP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_FS_TT_ANY_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
@@ -167,7 +167,7 @@ struct mlx5e_fs_any *mlx5e_fs_get_any(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_any(struct mlx5e_flow_steering *fs, struct mlx5e_fs_any *any);
 struct mlx5e_fs_udp *mlx5e_fs_get_udp(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_udp(struct mlx5e_flow_steering *fs, struct mlx5e_fs_udp *udp);
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 struct mlx5e_accel_fs_tcp *mlx5e_fs_get_accel_tcp(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_fs_tcp *accel_tcp);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 285d32d2fd08..d0d213902bc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t user_count;
 };
 
 static enum mlx5_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -360,6 +361,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	if (!accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&accel_tcp->user_count))
+		return;
+
 	accel_fs_tcp_disable(fs);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -371,12 +375,17 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 
 int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp;
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
 	int i, err;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (accel_tcp) {
+		refcount_inc(&accel_tcp->user_count);
+		return 0;
+	}
+
 	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
@@ -392,6 +401,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (err)
 		goto err_destroy_tables;
 
+	refcount_set(&accel_tcp->user_count, 1);
 	return 0;
 
 err_destroy_tables:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
index a032bff482a6..d907e352ffae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -6,7 +6,7 @@
 
 #include "en/fs.h"
 
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs);
 void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs);
 struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1892ccb889b3..de8e37ccb777 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -61,7 +61,7 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables       *arfs;
 #endif
-#ifdef CONFIG_MLX5_EN_TLS
+#if defined(CONFIG_MLX5_EN_TLS) || defined(CONFIG_MLX5_EN_NVMEOTCP)
 	struct mlx5e_accel_fs_tcp      *accel_tcp;
 #endif
 	struct mlx5e_fs_udp            *udp;
-- 
2.31.1

