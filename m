Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9AB6899C2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjBCNak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjBCNa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:30:28 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2581CA0027
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhBPhCRE+HzBE8CAmHjFlDLtDTcIPuol3/Qdz+8fG8rpqb6Ecc9YA+L1CmBYghDRWUM+G42OtQTDD32lsHppYrEGpbFlPAHyE46LjH9fs/tVV8PKDVFOpsY69EbrojNS5GDHKv4ryg3JaMWhYU1t/i9q02TtYUpd7qEGRHVXLMb5hvfJa/e3ZVEcjWeUt96ggjp7PEBvjHT3u+DOdez2F4mgRju7kU5sfmdEK9rKeJYylXq+WqAI5OZxm88djYjLyaeyENnqTkkdjPAyWB2nXVn/OcWRMmSZEB6qJRVr/iyzgM6pKoX1yxM93MRZBK6yIHloa0ic1El2UN0IyOFJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zm1GT7vnY8VyrNlHCQs82xJh4AYZtbgYa5ZJ1W7jA8k=;
 b=VX6yRllw0Xv1uss2H6FqEyUSxPAD3bdj2D6unwli7+ACjmSusg6fbIZ3pIWly8dVc/0RZ5wFyYlqaZmCZqmGb7jHYPjCV2tux0fe5bWZKQwiX5aAPgjSPdB3w1X6lddQos9WNo/Rf/03K935lci7OJhWzIKw1Li5qYVM3a+l7LyigaYUCZzvLVA6FCcGRCNYDYPDIGC9PpABsO7NE0AYb02IEQny422L9lZaZ3DOdM+2+5SIVqoJauvoDCMvevvo0t7c3R1yeXlkBbOhfTb9dV7oXSwD49mc9+5tQi680bv1UwudFP+DyYa3sgR1DJWOLWqg/dVnxnzZir0EoSaa8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zm1GT7vnY8VyrNlHCQs82xJh4AYZtbgYa5ZJ1W7jA8k=;
 b=Jo2pCwOTlkJF8B/0CaLSsgQ+b5HFZDbqWtQi8hmWrEx90WK0qWNlk4OevDWulu9imPrJNoDU2D8V2ei2ANlzL8gCpZNoOOrBraxJ6bZkzqJ0YkS7x1XAYb+keGVeXnh1e49X1OzUR3IzH/28gt3nBVeZr57Y+OxqHby5fdPWvAV3NgNftcuj93ab7YiLF9IFNpPzVeojpeN9+zR3ykVo+g5i6Y1ECm8NwPB4JijG0dOJpUhkmuxv1ODQY3qiUfZ0vhTxXqZGhBVe+u+1cpuSBYTxuqJHdk5+HiPAFCLn31qG8bJqDBo6vHNhyGpgPiqNl1W6PuywzVCLLhDMcwBHyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:29:03 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:03 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 15/25] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Fri,  3 Feb 2023 15:26:55 +0200
Message-Id: <20230203132705.627232-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0017.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::30) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dbe3e30-ddae-4978-b721-08db05ea9dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/2nM2Pl/fBdecXLpm9L6nxRv6ssdmPy5uF8zPHrHmy6dq9/h0qG4usnPKf2Rm2SToraJCwjMV104WPCobLreGblcMXbK0qwpU+FMF8OErNR8zWOoLqyuW27EmPIsvqm1Y4N6RDu+sNUjOvqGLp0/jsF8fQBAKHQPK7evR+HwosTNR8CwE9D7noTV+ja/E1ZPel6rp2k29GqUsLHVpOle3RXXKOSVk0tN0WEwKd7Ob8M4zJ+U8MD93Z2wssAKZ7yfXFz+TpBrvnj1wHxy5Sp1r2iD+tePoJkcQsgLBXxLfTdbXoNzrsEsiVENtXAqcYjCrSL9kjUeuOYPOC6YIG9vDMgZfPGdBM1ZN6K4NfFd1SwJJBgKiEQM1m0wUJ66XEXB9qDK15lwdtp90AlIO4HbRMA5Ykmyn2SK5xVeApcu9C3xktG0M4WDM1lttH1g1WlFO02WpuQkmAgti1hZjFhymRiRFLltuozoOjptb4xUHc1FrtVPFbf6+FBM5UWGpwj8Z3nAF7u+xHI0hfbS8YtrZ4PrfZy+cddrKQ6qhBS2DzfK+1ry5LcTtZXxAM3yB/h4kuuanZXr0q8CkAcQbnEMyqVDiaq/PcYPJFrGFZfPEZt4pJe/wJ6dvn/RWXKJpnVAS6gxyqvGqjQ1dDlPn4M0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+5CuGw/OtiRsbRBWDwZyvcYDPsojT0sFVwmuUd02I3raINYsjndMT6jsFLCj?=
 =?us-ascii?Q?Zfv7QncAI1wd4Tc0hvMm/WPOD2/d1HhBxmdyiY/CE2kf4ukvw9iMjvWGggAw?=
 =?us-ascii?Q?IRh1HYu7lpWVi1E0IUBxau6F/nGPczrv3KiaSzDrja9/IDJjISrkAAqPY6Cq?=
 =?us-ascii?Q?gnVfaFUr7diZaJQ8mCTSJhKj9GVmIf0FWjD9oKVixq8oHjzfGCchpaMEri/r?=
 =?us-ascii?Q?uVXtEYBwGzlgwwrsFnsW09oYrD13yLRpDzY5EfbtF665rHGaaegSJ+Jx7u4Z?=
 =?us-ascii?Q?cmJabWeYrxpJfvuTghv/0HPesxlzjTYiUDBe4X94jA0Ffm6dd3kbdtJOwrv0?=
 =?us-ascii?Q?2Ph1v4NujIxrVMtCsCURAskM1ejJ03eKu67c11HatOkVXAH5srTJRJbKul1K?=
 =?us-ascii?Q?gmEeS1Tkr4iLLORsXTGhkCgTke80+GlIRuWPbKKa6WBWlIdmUN7kSm49+WYx?=
 =?us-ascii?Q?8mbXMGX0LlG2zUf8WEbyLKXEnswfYR7UPZoeMX+uzwsa90Fi1jhG28kCNown?=
 =?us-ascii?Q?XJ9/2pd3PJDNUUOaJRel2p3eR4+6s4D9inTceVIWEPG6EKPSkf98Si3to8iU?=
 =?us-ascii?Q?WUX01OLXxqV7WNj+aGDWfqKpkpe/hdpRiuKKc8MACVSFPO4vmvrvBItQ1tQt?=
 =?us-ascii?Q?ZfiVQd/6YHCUGbc7lpeYRyjJYrUM6NHigH62QpMWvBGJcCQYkfLA5pEP5FEZ?=
 =?us-ascii?Q?uQJXGVqIENUqYgYWDZtawSXiWG/3EJZMM+OHdFnB/4+Ya7UPl7QUkc8z5c2Q?=
 =?us-ascii?Q?VvjDGd6fAiUgl/593E3OzkbgvLBMlX9IoFLYl4U/Gh55XWWHgutfUHRh1nKh?=
 =?us-ascii?Q?3YdgHvI5jVEkNDViz+9B79kAh8bZneyhSE9AmjEZtB4vkiBje/KiExyDYy9b?=
 =?us-ascii?Q?SsCwlqLr0doikoEE9AhYVyfvA/wTXnmHC9ZcH9zAioNpFzVFn/CD4isRrKNd?=
 =?us-ascii?Q?SnHX3RRo5C6uAJSG8d+akxaPjh8Y2HbIIpFNRJn3PVpHQgm6AR5P/3hNSw3y?=
 =?us-ascii?Q?620WIk8Xm8r2s38/COIanHQQijhIxW0K8UpKa9sLatvYvpHnuZgqHULBZVZF?=
 =?us-ascii?Q?wLTBI7UNI/s+85cNvFcJdgOW2bXDyesmMuxOxxGeUBa0id5HJTIBAc2mjsW9?=
 =?us-ascii?Q?XAbHVNVLGLdKSDcuyu2McfFGcBiSYEUdYwNQswy+gdR5eFuTmsrxzhzGKI2l?=
 =?us-ascii?Q?a1GkebvP5smq7h9GLbqefE35uf1Mjg8mD9buiIfSksqdLakk+LUuGp0q8buD?=
 =?us-ascii?Q?LDd9n1qbXtqM70iVl+VvRmwC4NKBahLvQ/RjrN8z+FrtEUiWyQjkvXn+ag6l?=
 =?us-ascii?Q?6jgM3viI74Akvj9cJ1Epf8NwFcqxDxhDJRFn3mBA+5aF9sL/BWsNBc/MfVfk?=
 =?us-ascii?Q?EGG17oLeYvSVAbwzAB6p/oz9omNCpnSwLAj0a4H//iCmBoe/Yk14CqrQiuN+?=
 =?us-ascii?Q?otAhAyUxpg2Ci735JTfPas4ECIS04jyrUqN1tZuRu30lszA7rgm2b9B7UnBj?=
 =?us-ascii?Q?RPoEvz8XGUKYQjwRKLjQakbNLt93FFaMejnvhyhwbalumtHBti6GY93xcwew?=
 =?us-ascii?Q?3963GvOP/pxVTkkju/eWVl+5mHZckG3VrHr+YEq1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbe3e30-ddae-4978-b721-08db05ea9dc7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:03.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /97C/DKlqamThYUnJqjikVx9AHaYkze93XDp0YR/awYEYPP0m8kNw2n3Z3a4YxGEPJiMLZfgZ+uXgdpnVr0ZZg==
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

From: Or Gerlitz <ogerlitz@nvidia.com>

This provides better separation between channels to ICO SQs for use-cases
where they are not tightly coupled (such as the upcoming nvmeotcp code).

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h               | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 5 ++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6f8723cc6874..dd68f373516b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -592,6 +592,7 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+	struct mlx5_core_dev      *mdev;
 
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 95edab4a1732..bfac3f09f964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -33,7 +33,7 @@ static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 
 static int mlx5e_wait_for_icosq_flush(struct mlx5e_icosq *icosq)
 {
-	struct mlx5_core_dev *dev = icosq->channel->mdev;
+	struct mlx5_core_dev *dev = icosq->mdev;
 	unsigned long exp_time;
 
 	exp_time = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, FLUSH_ON_ERROR));
@@ -78,7 +78,7 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	rq = &icosq->channel->rq;
 	if (test_bit(MLX5E_RQ_STATE_ENABLED, &icosq->channel->xskrq.state))
 		xskrq = &icosq->channel->xskrq;
-	mdev = icosq->channel->mdev;
+	mdev = icosq->mdev;
 	dev = icosq->channel->netdev;
 	err = mlx5_core_query_sq_state(mdev, icosq->sqn, &state);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index f4c8f71cbcaa..e7866e88c599 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -267,7 +267,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 		goto err_out;
 	}
 
-	pdev = mlx5_core_dma_dev(sq->channel->priv->mdev);
+	pdev = mlx5_core_dma_dev(sq->mdev);
 	buf->dma_addr = dma_map_single(pdev, &buf->progress,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e87432ec6f1..43a3ff2d2d90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1389,6 +1389,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	int err;
 
 	sq->channel   = c;
+	sq->mdev      = mdev;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
 
@@ -1786,11 +1787,9 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 
 static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
-
 	if (sq->ktls_resync)
 		mlx5e_ktls_rx_resync_destroy_resp_list(sq->ktls_resync);
-	mlx5e_destroy_sq(c->mdev, sq->sqn);
+	mlx5e_destroy_sq(sq->mdev, sq->sqn);
 	mlx5e_free_icosq_descs(sq);
 	mlx5e_free_icosq(sq);
 }
-- 
2.31.1

