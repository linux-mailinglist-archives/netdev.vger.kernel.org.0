Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC5F605C23
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJTKVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJTKU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:20:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2F31814BC
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrJYS/LsxDsRb58CGQJD0Trp2fr2uJYl9lP3RExN7uviGpvHzPF8KHWUS4+mTCGqfBiB/+TU1V+6PwJ/keenwrQjM2r6WXCI0vRiLs7B/CzNoyqfVE9BCELkWHa1p5hDGcJ/e7ezg3ChPu3STyspyOTfIjpa8TIPAdM9Gu1t+Oju5KkURntgpRIUypZAPYhFi/ntISWYW2CXXuPaNdPqopoMDwkfFcYnldEHJOHpUuxeYBozEqSVQT8sTmPQlvbYQGKlIGco8pJpEVbWDAzcb1FjdxW0RhChvKx/7wfMNyshZ8KbNG0W0xHcPO5NsV55exfeUM5eEJnzCMt1odUuoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Yledg3t9ZadQCE/UuO4/TrC6S5PlXithGiIUeKYE0Q=;
 b=bvYM9peOV8KHhLrFYiG7LSd6/XFKAHEqIobob//aoc0X6Zm0cWmHaC+sGEllibVrAmhpqyaTKmzQP6ND4dHRWwugAf4bh+isAoLghWJ94jz5cLAsSjQyCso5Gc1zzmifdLLrmB8X27uZrhThVfNwUeIzSvbQQRXvvqsCAj7VqJgovZYpjm1IV+CgeEv5LH2PoAOW0El/ChcLBH3guSrsyXHMhxqWRw8mZyE+j1XFXfOgs9f1GIh7mXHg2xRNBoEZNNIU0ZHQa9MSpxFG87gAEHe/fr9VD19Gi/Fql+BV5h0TBupnnIR7e1kQP8NfTPmRviXTk57mKKivDr6oYWDeaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Yledg3t9ZadQCE/UuO4/TrC6S5PlXithGiIUeKYE0Q=;
 b=WlsUPRQkB1um9GD4Mpa/F1jVmtuUl/eiITyp167Iiypkt81dN5NUXl/57uR7LGwBSE8b/zqsgtrgkSmpQQZB7Sc4xpY6n8/Dh018PoZKi03dDe7vu9AAEojeAd04zA5QujkyA/mgwtqV1OaF3Dacqivfg0Xo+a2gPkTY7KsRcM+hgvsAZQMvg/NMi/dzYuPqPqnLVAyGv/zJzI+L+9fMGoYDHqOG8m2pfVdDqNaxSRFczzfqLmPMfiNL40pjvOd1iENgbsh6WvCR+FzC/9Vbbm34c5oyk270VrtQ4He6oAonaDUnGDG/F6o/k8eGo9RYc/QpKlZ/IbDt4Fayp9jUTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:01 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:01 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 13/23] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Thu, 20 Oct 2022 13:18:28 +0300
Message-Id: <20221020101838.2712846-14-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0031.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::19)
 To SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 50f72762-4a2e-470a-276f-08dab284a5af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfsKu2g4yXh1L74NpHqsujLnjLcVywGuwKv9aLIM1NKCQa5oM7apAHhIGQxiDItWaXyrt9xIenLkCcEKOZ5YUwiMMDERCcODZW2+HXK2QCFRkiYejiAglMw5yu23Z2dLjkj1HvYImqFKIX4Mb4GXAFk9wuxyByBdNH85GKsvcq1zwjEsS9XTrZKtgGMBC54YrB66rE9INirQAHC45iNHSREPTS1vsQpLhOKW90kWRQF5wZqFK5EmOUIWARwXfnRT5Dt3UDTFSit669cOowsoXguUykJdmEqLRwZ7EFQiiAcUyvitoNTaRrFDewEPFsMVFgVDVcfsUyRQkUOIFU5hLSN8gzTOUFnNvW2Ty6STz5rkA9Bxrf6/GogdPeCDt7j+WcsyqrkmDsHqJ/zhhc0Dj4CmDG/KEP0VSkuQLid/sa19RZ6SJu6Hvs5iKdTOafy76dIYVv440yzMLPF3RfXHP25Ejs5oDbz+5T23zGoDxS9cMyeU44upd1OsO1EWNmuiwh2zh7H5TJjI/o6y4vdDb/CKyCWbSk3ff+TP/v18s83sXUlbD5TZ57kJ4FePkH7Wq0kWLjWWstv0jN3lMj4SZDOgJHSX56XwzmWt9lyMqO0hN3kcenDB/SX+WzvD9HHsKIDxIwu/0CLB6iTlE+XUN4HcHpOeDd8yzenGlP5xSEKH0FOGLc3qHkfx4gqYtpHjtnwHa724g2VaG1B0CgmPBNmc9uJ4qKBKoOrDTIuJHcdnU5VRyQrbmhYwKXvvZBkl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKXrqytN16PVTBaxFFpGv2lI4TF74ahhQED4VLYI++7GFp88zoioesgkmS/A?=
 =?us-ascii?Q?9DjBGNjfTzHslEfPwoaNVYMV9vJOZ+OcwdPblbxQYyY/EGJjgQoFWbD6vb0Y?=
 =?us-ascii?Q?clPSEHLnkxBrUZv0k2zqOt1ApPMtzzr2YOSYauOn/SpmnqDvO6k5SPYDZWKr?=
 =?us-ascii?Q?c6Ubv2oUR3F7ppb5JcQwpBj7Efw/UhMmF7bt41wXMZ5g91e5lyMlWxpilbai?=
 =?us-ascii?Q?tm6HPf1OAMRS/SDTY+8O/89Oh3qNWDllfrqSWYEfCN5pomU3Ry++LGUULfwI?=
 =?us-ascii?Q?uEFnJBAILiDOrTJ2X1fgPFeg3P9oiOlBi9+2tp5+M/5R960bOthZDYIv87x/?=
 =?us-ascii?Q?XsWTvAb6Ymu+fyPpleW/mAJ0DXSSt+u4ORRPLs1dMcf68kJFl9U7HeNofcOZ?=
 =?us-ascii?Q?t+JQd7bgsKEhYcFRR6C4s4nTcTo6V1nXHII9i0rif8anaBF020qqjweTvYPI?=
 =?us-ascii?Q?WXygq8AXcVa4Y1eUOmXxZl/W+7dsXIx82kfTpX6CgdmJiGuYkuiQUEtud22U?=
 =?us-ascii?Q?GlvNJSDuUTtFE0NY50PaHD1KJz+Rgpen/IIErctR1N2w6edVetaB3kCxGuEU?=
 =?us-ascii?Q?4qxNlFe0I3JinvfWPMDxiE4i78KQRtp8SVJwix5SJ1hSzPDoi9KAZdsJ38Q6?=
 =?us-ascii?Q?kl3L61s0c1zQLcT9RiCQIwQ8nWQy6vSYdzTLlXYlVWqEJH2CspEgUGtIZbik?=
 =?us-ascii?Q?fehNqUsiqJ45XSOe5/Q/hIKP0EhcJ6cOGmzEpsufCUJa8WWK2lZFxH5u5WAs?=
 =?us-ascii?Q?Pdl7waHjC1DUuwYPPakCCEQ1nuZr/GWm3PQ9BcyML4+vb6nwoEpWvzWatfd6?=
 =?us-ascii?Q?YXEyV9ZcuM1eB30prSqCeXM9rNYjD7E+cxKmO9lmgoQvsSrd08WwnaJdixrd?=
 =?us-ascii?Q?DbITV7pSZpdYZDPpIvb4Wyz7hU9fZwvLSP+LwgyFmWzK3ltWkbqoHbSfuysv?=
 =?us-ascii?Q?dnCQEFCwYDr1Zo5GHKAJF20UGzpybI2Koz2S3n4f7D0ed3taHf79c3m60UbC?=
 =?us-ascii?Q?XHdRAmUNBcwpfjBdkRy5uugFgxqmq5no7MQttZRwrP2e3TReBsMDBSI8t09b?=
 =?us-ascii?Q?+JjUOWGMoIB/C43d4YF4w7luHoWLTJXCyyK/X5tnB3o1YNlfmk1JX0TRT8tu?=
 =?us-ascii?Q?jvM2dGWa1SRZySn0yknJOgDsnajA8MjsvVMOiCb+dEL7LV+IjG41FBiZJohq?=
 =?us-ascii?Q?WyEXamVP1MaFQQ3fTTt/cTOPC+7exsycFJNbS81Vjn8F4PoP1hXbPhHmd9t0?=
 =?us-ascii?Q?tXmV+49jEcCOFx6LMs8PpNE1kG1+WthztH+ab2oJI+0x4wQj4R/alY20BAmH?=
 =?us-ascii?Q?oAfAzY4TjOJ5z0lE5YUZz3DV+2u2HvOdR6NiHBtr2VHzQZv+xFzI94+VIlhq?=
 =?us-ascii?Q?0tLl9c6ylLpWZSeeIqaDvPzndsU0xrg0MWiiayX1AuexMohArhEeHfjyXFlJ?=
 =?us-ascii?Q?EB7IGtAiElY+VuBo57rOYySdDWH7D/+FYfLMXJKXzCNJtvufLaGmfhfk9Dtu?=
 =?us-ascii?Q?+myJSRdbouSAWSjMbniuz3CVCrgxdm/XybHist4obOa5CRjOrFBOkhDEDgKN?=
 =?us-ascii?Q?InEBZLW7h3Q/Pqq59/OqEbgOnlYvCq24Zf/vryrI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f72762-4a2e-470a-276f-08dab284a5af
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:01.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbxHzC06KPfChCoknWLtYUq5Ah3LhkB9jNWesIml4RP9P0fa4zext3fYWdlhK0ka0rRL7jPWZ/POtPD1DKVK/A==
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
index 26a23047f1f3..cf6bb00e735c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -590,6 +590,7 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+	struct mlx5_core_dev      *mdev;
 
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 5f6f95ad6888..5204c1d3f4f4 100644
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
index 8551ddd500b2..fe9e04068b0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -266,7 +266,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 		goto err_out;
 	}
 
-	pdev = mlx5_core_dma_dev(sq->channel->priv->mdev);
+	pdev = mlx5_core_dma_dev(sq->mdev);
 	buf->dma_addr = dma_map_single(pdev, &buf->progress,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 364f04309149..ad7bdb1e94a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1380,6 +1380,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	int err;
 
 	sq->channel   = c;
+	sq->mdev      = mdev;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
 
@@ -1777,11 +1778,9 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 
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

