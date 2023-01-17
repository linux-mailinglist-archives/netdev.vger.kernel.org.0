Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFD66E270
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjAQPjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjAQPi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:38:28 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1878743440
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzkVkIWCInyH/rD1NwtApThF5MVVZoEtn4hCdJAR/rzuxom5tJpCdcZlkk9XjCfNzZoLTHDPChus3j7GCpJWYw73WG8BcW+5y14uAyysl1OQWONOC/xG0xNEgbUDo34pQIQWqn4fi9GQiUR2RLmnQyQJSs5O2UrFsFx1EPg6ihgPoSu57wW3dnOG1OWrn6D61byvPBzLQ4VZBGKLrDeJmcuFSbb7yVyOjBFJ8a1F7VK34+wlQFiYXv3aErN/qIjIeHP8zg8P4D90JZArmztQFoK2guXJZyKmd5lkBdCZ5gR/I3VQdmxyi9uPd8STV6sXm1BFLfMaJNyl7svnd+/52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHQoTNgFqLdeOoVIMm1kSqaqYQhnW/hPlDD4JJW7xtQ=;
 b=e46kDet46uErq2NEMImokdBV8O5U/9I26zbvrrd5xGLn3emqxQxrE2pNAicUAoJKpehtwvDZpXTiNyuj9HnjtxztZG26ajbgFcyYnggb0drp9eDnJqFZANeWuIUhL+QIeVL2GZ0es6BPUbEY5t64El4/sX2VH6mpwwP2JhwBBkmhbpMju0o4yKpKOYH5Q1PbgUTdPHb8dDVr3db7Qn+x/Z55Bx2nBjMAI9jQOLKktFCRmKAFrQ2C+zDFmc4n4CumD+whNCDroYbQUlw8kznvEycborfD7l2+KrlE7Z8ZoqtHEMMiMmaBG21/Msyt+v24VqSh4N7vo7UdUlcIT+eTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHQoTNgFqLdeOoVIMm1kSqaqYQhnW/hPlDD4JJW7xtQ=;
 b=shBkeenVBjOZjrtPygvxjgUFItM7piyVZTl1PdAZ1/kAQvwi3B8DqwXsqWkBJD/Gk2UIw2cpw5b9O4txID2mV0IFEORErj6KSfMHGmSIdNRc6PcN7yw7Azg0Znj7+N+Sz2Fp49LQ8Lr0gW472SnyovYx4uVE4xaz3QgY8Yl8+iQNZM6Nd4CyeN1nez2eJREiYby9CaoykeKmThLg+tp62f+kG7MTqVTW30i7uIDIpJjLsKrnPkFMR3BMvwro43sf6PCZyrFbU9/qv2GwwYN8E5Z3/AAAz2vI/8sdJSsZNhIEvWxmCd838hLzLGBjpJR3mC2pkP8XZLQc3mD5EfHQzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Tue, 17 Jan
 2023 15:37:35 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:35 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v9 15/25] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Tue, 17 Jan 2023 17:35:25 +0200
Message-Id: <20230117153535.1945554-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c16fdd-17f8-4682-e714-08daf8a0c154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hywCMF8MnYaCeKhhsPaVKcLlwaFvk15FvQzmyuwFhaLtNZadhd5UUYlsnDUWALdSmH4X7Nmn127HbjwSeoOSXCsso65qpZWzJO9M2oYWqb6cxeKjOTxLkylA53bwdNIn0rswvm8maJaJD+1qhtHJJMP08YL1xEDPR2THSFRwP08mckk4tM/3t6DVi5Pi7NjLfMLaS5wcn+tjCTFmJ6FEHmLIe52KA7ucATEkfVbsfqgB3lTel8okWCrgBqhKDTL7y7jzB2GrYvDMTBJ42mm2z4VdXHEVY5RETIfSs95gy09VQgcwHN2OTGSAT6m6UEJ6NiXNrtGe4svbEQizhKxJBEVhoynqOO5hLPhDkT5x/bVLwN6xy9f5teF40F3jAoJMnFSSJKoGC/Si76dP+rzEbqhmVg4gz6vXsMophBbwTo5O4jxYSf6yQunaAd51Te2Wil56DQzjidPf5y9gEBWdEZu68MzfXdOaarKLKybxcePOYVRRNWwsmm5WfEFxcM5eZfURiHBSMQ4mN0UeKur4EmPXGYm+txT1Dx3STpbadl8OggqHmseRGeMv7KGKgLDQbYG443KVOvHXllPJ+mk7o5pKpGHl1NcpNk2dkPsm7RxPIREwb/Qnr2FFuE/B5MKVYx1R08zhp95VaVSBdGkM9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(83380400001)(2906002)(38100700002)(5660300002)(6506007)(7416002)(8936002)(36756003)(1076003)(2616005)(4326008)(66946007)(41300700001)(8676002)(66476007)(66556008)(478600001)(6486002)(107886003)(86362001)(186003)(26005)(6512007)(6666004)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLkuyoBkCnrJT+ShRi3AUxxQCo3AmakEjuUcZZj69UyKGuRd1IYb+jyDvGp/?=
 =?us-ascii?Q?CvC0tczzf39dffhah9wsGxu80Lj4A7NNfhCDgbXbj0spIjG3+ieq2ayM6SGP?=
 =?us-ascii?Q?75ldlIV3U3rsDzaTdhEoOVLrDgPsW3ZOsCvXMjYd6vdQpaermk2wbh8JAaAQ?=
 =?us-ascii?Q?zxc1WbWPLsXbRPZ6RPMk8NJXMIjRWDCgF0uXVAmrBwe11ZkbC8iMUvrJ0Op6?=
 =?us-ascii?Q?HJLpNTKq9zvgY5HpJHL+WX0tpK60RNyyP0MrnOp42at5WC15SJXXrWb3p/wW?=
 =?us-ascii?Q?e4VqUDYbh4hL/iuC+dIqDMLHbhlSCy/aX8oGAysfN9EQAeWXbx3d6XfAe8uL?=
 =?us-ascii?Q?XiiBcn25n/OIGx+wlXEL5HgAX+gz6neyefQIp439uD+px34xyF6QoxSc4JDm?=
 =?us-ascii?Q?xgzeq0zAY10xHOWuqWXbwM+lmwtXNRnA9rZLo/y50XVNYRB0TNyiYAlT9p1w?=
 =?us-ascii?Q?qNQ7GuS9t+qUNLDlx+f5HE3OWJCEpr0OxDt1x9w15Ea/Wnm3/6SNeIC9PhTX?=
 =?us-ascii?Q?T02EUGrHud9y28pgl1JnW+euH9ZhXjGsWEzo3AOhBlRKaMRjUcrDnjG/aymd?=
 =?us-ascii?Q?DJZzLi1WXjKHxrR85bYvzdi0nEYs8CCG/OyGtSbWqxDmCByedLKkgUvgN+4T?=
 =?us-ascii?Q?b6azxLMkqvSl5XXM0Gu8Apbl02xtf6vI527tWPAdmPex1mKSdRA5uTo/mBHN?=
 =?us-ascii?Q?TCZdLeZ5w+l35ynOkHeW5/wnqu7kArYb0TVc6ltwyxQSnxAci1sgZNkvzXQG?=
 =?us-ascii?Q?G19hnmcy2+0Ezs/sF2wDKZhALixprnSFCSEr85OkegGwUyGob1yRERtreX+B?=
 =?us-ascii?Q?31EkLmNsV2XsT0q+bCQYmBoeYfBaHLOyoe+qs88d2eAi1XFmYkszfvNuY0mG?=
 =?us-ascii?Q?fK7bSiatk9TS+Fa2TKhDxZ9F7LgL/+k9JvrXuM+V+Ha+XXgryoXVnraA9DGC?=
 =?us-ascii?Q?EWDqWhPFfo5EP3nZzAiqpnGwLfHr945/bg0xhYyRMnlQ98yMcg8KgWuXR1Y1?=
 =?us-ascii?Q?0DIgV9NCIp4G6hpaQGlsxg2CsAWEExbIb1NmXyAsFLDq1mwicNTHAfj0Xg/I?=
 =?us-ascii?Q?pPB9iqJmeLs76moPdVnta9t1jRmoLqip7C04PGRvoePy+YLaGB1hBdM3lazv?=
 =?us-ascii?Q?y0aEqoLIDXXcoFtIZ3Ufl36PSpm5GsFULHIAjuzF+aM+X8XnufSEV94o2UyY?=
 =?us-ascii?Q?Wehciakt8rgtet3Wl6Rm4zNYAbe8vlMPZVLCcsgBOVadOBlKrJ3J7xjk4AXu?=
 =?us-ascii?Q?Lf0ThAxpgp5zv78nkDkRki0fuf1GhlYCAvRq5X2IncmPdpkh8pLWC6N/frGM?=
 =?us-ascii?Q?L9yMpL/0ZpScjktNL3khfS+foBaVKqrjKKW//nwrw++N574sqg5B12xfB5Xl?=
 =?us-ascii?Q?rC78P+ss5VWKIo2QbydJ+pHxiF1l01Gzn6RnByRLTIL9C3ay1y6RmcQUEqUx?=
 =?us-ascii?Q?fTSOsPvrSpauiBnqdPMh0qCdmWaIJgxN1E9eL5WZ5uPa7waLsWGzcvNAT7gy?=
 =?us-ascii?Q?6Y1IH8tqOsMvpIiReQwPZHzFta+1B6qqE2q7zHmp2s73FZhqcWqyDzbw/8sl?=
 =?us-ascii?Q?KhtXsagzAo+4RKce0w+kuu8TIWsYsQ6iXmYH5dyt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c16fdd-17f8-4682-e714-08daf8a0c154
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:34.9931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyoebKFC+spPSQwptkDqj6i4a5AxZFahhQrP46lubXvfP8Ipg7h5MN+gzgO72sAsbG0wqVW3fVgCed6TKc8L+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930
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
index 82573ac722d1..17ccad42555c 100644
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
index 1ae15b8536a8..12bdc4c04e70 100644
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
index 6bb0fdaa5efa..61a6b52d011f 100644
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

