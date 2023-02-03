Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04EF6899CA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjBCNbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjBCNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:31:30 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BBC457F3
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:31:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXbLd3FcbBGCotp4LcustFtJiAfDQNV6gQSyR8rvz2Uobf+qiZLRnIfTladxRd+anXlLcg7+OZivW3cqmSU0a//ARhG+IuFcdc6wZAwsL9yaJv6e9/2XkuRZI8e6wNVJbTT2Hnxgd89UFLb2rl5Hu2yni0ZU9Bpei2kvKXRVz1SMNubarQ/cgIPPQg39gofMzcd25NqB6e3wBPX0fW4jQFn0mV11FRxMJNpBPLLgEygUwos0v1f14VQemhrmFe3z/R/avIV8n+hW9quRf1wKSb+YWNVAq77kDLc1aF+l8iESSZ6gI8yvrJ6r880fm+07B8Ao+tqArdCbqh2lxU1HRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=HhwAhREZLTxO+EasWxGFx2yWb+l/usbOu4ZYP//2aim7W74zHJ4pdOu4yvxvNqYSw2NTWxRoz+n6d3nCuyxH5MszxwcAlaMJpqlelW0rmhPvOsJ68KWQcXXlS3j5E8uHMp+QtOtJC078G51vQvy+lRn1lD8koyK3f9i05j3f1aFAObSTqLZLd6fXh9szt3Fvlw/L+oojacizxbsBcnXCAebTi4qbetqcBqcyW5g6uSnvOVJM+XB0GIcZzrFybPYhVcqGTxqh5ZTGLrBDPwhAu1Tam3L9pjAlpQoDjf+gaxoAqk/8/kTf6SWHigsWG4ltPyENBEMeZkZWfpfrfFNIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=ow2IpamHVqbkgzvz0eg8yHNy5bCgJ3lFlgea7eW6fg8XizL2oIEJLCoaC4JzQwdrw9/WB4elEhHEFEL8+MpmBAZDcsgFBrnlaSxa+yagKkMI5xxWPvSV1CZBeIfKGvL6+DvXk4u/okkH1bEE9EzmXTE6fom3+NNS9aNlMNzi67c/ULU4G+TzODCf2bfrVKTmf1L1z/cvJWCB9UvE45JkRpeNOYL6CYfrxuviGnTFvF6xoisQxRFkzXXf9X5j1c0fGGyZCXWJzbFdzTU42KZ7SMcLCFL/CFydcE3X62cgai7qNudJpjrwHCPNqiXVmUe7A1TIELH2dQN34ynyMame2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:29:27 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:27 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 19/25] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Fri,  3 Feb 2023 15:26:59 +0200
Message-Id: <20230203132705.627232-20-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 585adfb0-f142-4302-a29e-08db05eaac19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1kCtDt0uDn0dvHqzOGPiD3b6HMO4SXI2vg9EQAnH6htFXyksqQfZQm9F5HcSVzFvQJQhjH45M9I3qVAfxwfPsidIp6y7f89ii/9Fy9l+mnAlTZG7MhQ/sxU1pVuOfqRXwcLVElt4Wn+GJc27zYFgXqVS6UhSBVFtlmlyYQkrPJQtQcG3kEiHrLGIEsUUo807i5QoiwFfvl3M4ZKksFYRXORFOSb/qLKo62+tKXLvS7BdiKBis0QEmpJKCbsL6K17bpbo338svlSWYOI+FwKsEb/wwBmV7bFouARDw4lEzKnaOykU8kSztQJT30IkdDkGPRXry6otuFfhCgm41tntlZGz273f+L9ApZ5OFsWIE6OsGBEeSfaRppNrNZrsi1hTrEMZEeAc8FWdGMBAtSv+xI1+yNB1ARow9sS6AVJ3u0ZJEMDzVpEHHmQfyyMDs6jPYdZpURO1x+24SoAinsGGdij6Xvl8a1yCjY/3cdhR9XwQctx/Opp/Cje4T6BUsCTcy1FsA/Fur//YpQoqve6YGZWDKKr8yLkaE/aJeYNOmM69lM6DWWIpqDCG7NWNN9HP3RoFxI1qlgWmkJA/WWFEZ34me4zJYUG4cv4ZT3QpjRjvZsHWuYwU+rdUjOfkEsas/Ft2my41lgiLnzlV0BsMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mKLUxBEYfQqM+SGoZCVqTqIk474CqWIyms8RnWH4GbL/t/vCNOWOX4SkK7d8?=
 =?us-ascii?Q?HtCcbTS3yUGJzGoYmwrKkHGUlMpeeiZlVlGHIQNtdfFf4P3uKvoXvYuWZsAM?=
 =?us-ascii?Q?aQEvNU0MONndHS25Ih4pg/Y3daHHxR2N8FceIxKL0WaWyLOeDCrZwzvhMoos?=
 =?us-ascii?Q?jYbdDz4MEPbA6gh5N2U7cAE0+AywCrxOIsCrUs+r+P/KksxR1y3CE1JL2YHY?=
 =?us-ascii?Q?il5eXC7k/oVNeCaIMNxE21i/RbmSHi3z05X+J73SoPvCMdBGQqt3ABZOvwES?=
 =?us-ascii?Q?FoQ/IILVg1RPwDlI1hfGT8Qhrt6N/VD+NXOdd+CdIg4YifKjac7zp6j/dQzj?=
 =?us-ascii?Q?2x7zvrrrRnGPqAgu76ohQTveuBFREJ9pXPcYtJkmj85oq5NXmFS37jroXI1A?=
 =?us-ascii?Q?SJujwDyrXzhuxpUVm7bAAL7lSkrJ0dNnh1/6Y9mfpsN4fAMkdrx0l9hmqgNY?=
 =?us-ascii?Q?c9QQCjCK19SVHfmmtds1Pp+GJkMNn60GSs2B8JjKy+rNztK6O+IhfY1s4GWD?=
 =?us-ascii?Q?45nPUmeNcu30soBEpxhCCXd6dynr4gxh/bC/olhcwgHFlKqgQNKiux49EvWx?=
 =?us-ascii?Q?rnA2DVVkYG4/GfV9geVX5KZoHCXH8wuRq0RaiBvwbaflDA+5myUj5u4trzqq?=
 =?us-ascii?Q?QJXKKL9LNzB9JTbqu2H/UHtDfKRwazOTxSN+Hn9GNur7+x11GOcSDndGNI9L?=
 =?us-ascii?Q?/ceZe5dttf/jqu18G2xzsNtc3VVzgqdnFwApYNdS8SSHAcEQ9Hx9rZFGmm5J?=
 =?us-ascii?Q?SPyDYxwSkKsclsgkOuWeSZ4pi5CHjPrZsF4lvWrN2x+bbfbxoMDyEkZNOe2p?=
 =?us-ascii?Q?0wmEc9+ytagbN+gREHIm7wDf9oCPXcY/+SWOUnqvb9CjGp0F1SE4qU4F2Cal?=
 =?us-ascii?Q?DTK2AukIjWr67gKUPZaUNxkaGbd2bQgEHGzPfQEP3k8pYgJ4O44cPijheuiL?=
 =?us-ascii?Q?M4vXXdnkBJiX1ZBwyr757Ds3gxQod/BAM5leswFBnEO6jSvHyoeMi6QgMiiJ?=
 =?us-ascii?Q?exE7Yr1tsg+dR0c+UBlebziiAh3WZ3S0K2TMG2c/NkDy/WxoA5knBr5vDGLp?=
 =?us-ascii?Q?rU+tC1EzmkmwEVWDi/Eo1MK6oA2fuWDXXpU5ofAi22+BFkdxarTAtfATWlNv?=
 =?us-ascii?Q?Mjmkqvz5pCvEwGg+LSTSIy9wz4HWOlSC1g5aFiFRbUFpJJbNdhrmW38z/Udc?=
 =?us-ascii?Q?WhxzETmp0zc9GGI5RVs4vnMglVkCZYH63In+pm/ghnVQJDOsEXWRTCVprVNZ?=
 =?us-ascii?Q?W4d9gTMuXVV/hiPc4U/eM6JxPVLse7l9R8k2k91xubChJiP1/Ffk517QaRBY?=
 =?us-ascii?Q?azmYV70Ao5Ar+cL57mGV5Vk8SSH9eX1Le95zKi319jMwa/pdzgjQbQptHH9+?=
 =?us-ascii?Q?LK0X8Qg+CokINzCNeZm9dTT8raj/zjvvMTtyJdVJQTvz97xG8aIRDtTI9oYJ?=
 =?us-ascii?Q?0d8VwkjKd0mbYlUIU/EXupAQAHKAtO1ZlqcAJBjJZM1ZiGfWpE2xApXqgeDQ?=
 =?us-ascii?Q?yW4bty2XtHev7v4Cv08E5n2juq3i9qzY27MArcYUZQ4ndrdOoB2x/Vp5+ii3?=
 =?us-ascii?Q?EeLQevaDm6HOLiv6UJtvvC5XWjEHA/b7GO2At49+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585adfb0-f142-4302-a29e-08db05eaac19
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:27.1997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgipnLIWwwIed52uE3DO7TKYH9czzZkVPViuMNWupO/4CIMnPwLp9oywmQwNLoZ+32A0jyUlIAV8exD9jPRAGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 88a5aed9d678..29152d6e80d2 100644
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
 	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
@@ -392,6 +401,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (err)
 		goto err_destroy_tables;
 
+	refcount_set(&accel_tcp->user_count, 1);
 	return 0;
 
 err_destroy_tables:
-- 
2.31.1

