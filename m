Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0531966272F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbjAINe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbjAINdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D612718E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nh8Hk8Y1x4Y64/BIrW4ebBV88n0lpLsWz7AMfSvi96Fl30zEOYP7gac7wK5iTLMYexbm6UAuidEisesKADEbUsd9uG3vs9f7rHcfORIjnJ+BEGqDi3JcB0ktoZ+hbWpxZZhltf1OJtw15okueRoizVNRv0MeaDLMJHu7Yh0pYt6H+d+JAyIL2Xmm/hdQJKkjwDmtDaGf23FdcQNmspvKkiQjCqFRypLJD/tSun5JncfX0MAo1TR8ukUxaf+ojQ1cvEoOgLHJATKZ5u4RA9KEY6gY4xUsMCkjTBeMnFZ1Pqn8ZwpCqGpYxBK0pUVNY7CrBZigwUXsqsv4/cyMmWc2ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHvJ/e3ftR78J1/ypd3/5sZy+tTImcRvBwzXcRJ5wlg=;
 b=Efv2TpncdFtEYtwCL33//UIM1K+9cYDB+qDjsliByc8/HgWFLfnRb0nfIMv5mlbZPbTVge7ICKIKUuj66Ca6r/lKuHtalLod0qvKhrokJHULi9pYRPB7nfQ8AwDMZkAb/HjSksmIVs2xykKc+t82a3OeMqk2OjQ37ppACm8Sf1B/WyFbH4aAxJBVdy5SkAZwc0qf5+XYAs0XvxdouO3mMdWDtRgqpEYlKsbe+D7vjDe07+ChQ5Gnb+7sFaKTVvlUmqCfX8Y1G+N46NAWLKjQD4cRXm0GpaSUvbtsAJvghF9QQStm9H9IOtlvsQvQlYrZ/WY1B+br3MjLVGPAKZrtsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHvJ/e3ftR78J1/ypd3/5sZy+tTImcRvBwzXcRJ5wlg=;
 b=Al/R/ji7tVHNImTtIJ5wmwJxkkV/Vkx+O6gBj/G/OF+ku/eLLELWZcxsqzamhum/Sb0uQphU+O7lpNcBsUa0+HDh6FW2vhz+7SJIqGfy+93tAepd9G90DxfKi/c0uHXuMBegFfPf6jOp5XZYCHtH9tZJJhzi3U4W9xlZTTcYRPdDfXfBm8qga6O9DIjk5BCCxwbIUSlGVdf1PZbSXU2hG0yar4E0PhytaPserZ4rCP+U1mNAERG3Tz7Hhz01OcJN6qEr2wUdDk6nDYZYztYzL9S8z4Rri+PNx6epRtyvwr9tcBnS4zfVpVEPl6RBNS0FhHhGCVj2wZpJI3QnDzNgCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:26 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:26 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v8 19/25] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Mon,  9 Jan 2023 15:31:10 +0200
Message-Id: <20230109133116.20801-20-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 19fd1a01-78f6-4013-a65f-08daf246161a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLu3tRf70kQqLanp/cOAKMLUe0I1h5Zg1Ji70axW8zilr+dQaBc2UlknVGoJjD0V/THCi7u35GiRKHrerZHa9W6+5MVZgU7YsNQJjz8dxbJz3+oIqf2QxAKzLWI35u1XcxjJdNLRk72uTRNqtSajPI3hCR+6/YwnrRUrekYQOIpSfcDkTOfEVj+iCfu+wP8mp2thbyiHBVq9HUPgqyVieAfoPhFkE4DGqcba4PE+2djPQH/tf6nYCMvRqwb7MRz9cY7ytXVc2wdSOM8EDMs3f+ZcuWvk9YExlq9KPT5Ih7f5WdfvVGvAsroRy57pZgipD/gIu50+AS+zNmTPn0PxYbxgJw0WorLBWmwXhNfBmkgYFV7Nw/XMo2M5r6NFxyAIQqjXGy3kzCsRPLa4kmuKUMw95Yuw08UDsByOt55sFKGjqU8vk3K+Fgso1BZuNolWcNAATlM2GFkKZ9U7ilvwaL5zMJHE+hEJr+dEeyMUFEwCuPo9mD+5eHx0jWgcUkGTpetm+0YnW1D5iwlN2KSR4XkwDpFtljPaTzLItxySzYzliGgUa+EwzDasCv8eseCGxurOO+utR+cX8eJMfWyIPlIc1ls9SXlUDell2xug3G7mXAYXaFkgyXNg5nU8vMM84mYpFMiBbZoo7uqw/Zq+Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(54906003)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e24Kkucy6rvPwBqE1gvPWLG9asD0OP7b8wMBNbhn60yad0xTNkdY6cbTYV17?=
 =?us-ascii?Q?sKIPWZsJJrruXNo9/DMsdacmPes8Ib67YQi2vD5Q+dElG4gwj8YZFVNEeDYq?=
 =?us-ascii?Q?oN0kiglZBgWMMRycW0rpuIKSEHo846G2B5KNRQx8LSwqN/xAb1UlSMC/iVnh?=
 =?us-ascii?Q?WfbVroYrVvg8XxPRdeg015bBrqMrz1zuwvBIoWQqyGikkPgCY3VR2LCtJsT1?=
 =?us-ascii?Q?nShaaSJvKQ99Hu1A6DxobJHz5Z6HlpRWVP4l45jVdyk8I9zOtOtUA9YbW0yS?=
 =?us-ascii?Q?8vhfOibDa9j+rhQbmvGJak+MDkMR0P+07XmE1FtZ3fNrIO5EGW+qtAHqW9+H?=
 =?us-ascii?Q?7LHH/s6/PvuLgsm+CjgCsB/bvWg+9IThdZ8MbKvAJ/oBmrCZgj2Ik7doDRR5?=
 =?us-ascii?Q?yiA+1ICM+ToVXcBMzny1bcns+osh9MdDtOAqNG0CngvBbpl/vl2obLPxCozT?=
 =?us-ascii?Q?gXcCQ7HPp86+fvT4WVXdLZjjcw2cwr4Go4H3MSEvUyamKUUunISlSPScP8np?=
 =?us-ascii?Q?Bvxkl2gnPvj5ONWNan3JbNJTQ8Hmbi43vV29QkcWiSS//i+QmYhMXuRXDVe/?=
 =?us-ascii?Q?LA41yOs+UkwG4cCbn2soKQMZZ5g/y23zDPgcAZ1dRAcU0sL8PoF/SQNekOoQ?=
 =?us-ascii?Q?8A9r7rBd3xxn/6AnovDrSM5QkIwswhckcIybYoq7gVgbfVLx/QLM5xQN7hHY?=
 =?us-ascii?Q?n8vD0Ilqwq5QPhm7b4jra9NeHzz4iFCKHFKRZotKft8oxYtb9JHbewm8b11B?=
 =?us-ascii?Q?SCS2FtIZsrGv0SQhkppWK8UAYuEeg6qVSNzeg3+Uo4Ge2MQdH3nxSO4YlOWm?=
 =?us-ascii?Q?umLDWTpfBY+rkUTW4izE4HKthvFuLTb4m8t26psb4CySC57evdNZTx5UqXbb?=
 =?us-ascii?Q?FHGod/wvzfvFnSRUqRspbAAKhPlmdm0V3So5qq+bF99FxbTMy+l/gqWO8ViQ?=
 =?us-ascii?Q?4AdC4wIQbAWEqRMQK7GkxxwxlOJiOk0vo3IqDBLHKilqMVzHqB2lYxxLXsvV?=
 =?us-ascii?Q?fpI17IWPLioqxv1yOfB0tzXeqYTr/0RnlGdtSmphTetS/DAS0tkqUOEOtIFD?=
 =?us-ascii?Q?8oaCnm+RqzyFifQiUvS3diiC7QUiGtcC6QFd1BD0eGigqIz5dh8XOqe6ZvcF?=
 =?us-ascii?Q?cTFA2N2kp4FGBQNF1LVDS9UXaBVZNHJFOeqOO6EvXAaML7NebSh5XwT3TCx+?=
 =?us-ascii?Q?OCSfC7hch+BNphfPknJDbe0D/hHwU7e/FSxNU6WLXnerdXPPCy/Eswu7ArLr?=
 =?us-ascii?Q?ecZGRYZ5VpwFwyg/27JXrTn6EMHRs+Hpig1E5zNqtllpLQDyTl0+AYMZBIr4?=
 =?us-ascii?Q?OjnfQzhaLB4wcD9LxUtTJg+IKjYcuntCUUP8FdOzUXP0hWXgKSIJpMcOKVtG?=
 =?us-ascii?Q?lWB69FX7Ylz+18hft1CHDJ1iGhWJwJJDx7mDmUX+LP5xxgzYaYKlpbRvSnvW?=
 =?us-ascii?Q?vGORO2R0Y4guK8m9wqQRLdGak4TDy5JPNjvdE+lCFf1H7f5vm532jfay9MDI?=
 =?us-ascii?Q?Axdr0DWNbpyr2RuwExq0+rIi2CXHbMLJ6xdkFM/qn1MlWAm8wksb5nWFXef4?=
 =?us-ascii?Q?gnjB/6qe7rm8CiV9HVr8L9lm65hrXFHMgLgHEort?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fd1a01-78f6-4013-a65f-08daf246161a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:25.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wpOmPUMuvXYHs+ujXVyEm8E8mnAf6tIp079q886RLmKd16uw29L/WUF6+JdAfuyrD8obH+M25iTu8xXibkrdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
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
index d7c020f72401..c30224ab6ef3 100644
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
-- 
2.31.1

