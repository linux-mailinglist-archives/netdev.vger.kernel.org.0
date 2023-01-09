Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06DB66272B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbjAINdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbjAINdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E414026
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHUS4PAn5R4VXQ/oAVKzmgdCW2et2MtCYYumgtCx8jfpP2Yk6OZBvauyhPoHUepEZFL0w4463QMWfqYgvGMHbG5ITMEJMD1T9lT2EG8UaRI5mntVP+R1mj4fggBH3kVRNcJAHDvnH37BTyfRSTF7uiYf51Aydzqn2CdjHtI/wS/hrqeI+hfmaUVdbylhwqkGhG03d5rDvdUa8svLs6nhO13jkHxh9/w/ePASVKJEctR1ot5pvq74dIOdfYdX6rLx0aghj21Lm+hw4CTajZxSDOAUflXrTeDiIleHamdmuRGLxlNmcat0YWfKf22E71wZGhszoT0yNV+69N43QUHgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4xzkgv4I/LOhTXpNfs+v2n3207C0uyvTDw2RnBX/98=;
 b=QbUxsff3olIdsK6mt7VRK8LXfLUgbsRzHLFJs93sopORYBEornM/mRySx+QMOXg2QZCnhp/fRiHtDJ+0zryKk7Q6sDn8pDM/7ocRAR0mB+pqhhAd5toS1WetGKVLre37aZwmOKki1yQV5bH/TATOvXbE46+/sHV+d8Dfbo6ObL7qeySQMSggfn5FE0sW97O0eqYLW7WGdimmuKfSZ33gCq/+Ctcz31bv6ErQ95CBKhuXemfXHfTJVoGPxZjRbxlaJ215qA3LisH5T1fLNG6+QjhFvgeme/2NiYFNQSEh75T/ZYoLFNjwuQEofDKyuzdLtLd9qaZ5PowPK77cs3oPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4xzkgv4I/LOhTXpNfs+v2n3207C0uyvTDw2RnBX/98=;
 b=r3dXdIaFhygnHnBptKI+P2W0EdVuxwEkh05w6JXFVCPvmMquDHPHR4b49XOJlCND7YBZbB6LDxBx8WPH4UCDE6k+a6kur+MYTlzwLRg2ZCyx6m8EL5gVq6kjVhmcVqiYISpFQHIeI45za3dZ/CIlaSlIHNkwWKAtpUnzPj6THHTs5Yo3G5MFJec2WbERS5+I4PqGg9IsKcppUd/VbjO63TKbSgf+T373n8iCZKboVSWpykxTH//TbP1f1cuCE2CDoXTX/HT8DckacIFa/LaLn4ds5o7MqK24jD50FYtg5Q9BndyD66bBKCpvkn5/A5RJeDBql+RUzST5MDUD6tUyxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:01 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:01 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v8 15/25] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Mon,  9 Jan 2023 15:31:06 +0200
Message-Id: <20230109133116.20801-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc9fc20-9542-40ec-6aa6-08daf2460734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prOALxfED+cQDPr3bEM2jVpRtXMe4+t8g1CD3ipAPC44JpuXEyufFgjxz9DArA46aO33SMyZfFwi5gtmNKf371ko0tU3OP1IthZskOhCZ+EjMwPTUQA8VDy/Hz8uoMJUL/RjaaMkcTkHoG0lsfNXsQr8DpMJfn2NWzPVGfOu4bDQ/tVbLrT8yKSYlb/EOxaH079f/3O2mJUwhc3ktUBUDKZg2F8D9ySfd+p84DArPVSKOassJxrDrxdf4zGoTB8CUY37XcHa3YWcQip798Gd0WaYePgE2JVPkl5Zdwnys6JSyWDwz1wCleA81AYIlPurqxTyz4vTNkaeOC1KWk7PQ5zNg2ksZGNCaeSuvv7NAvX+06TAZyENPMuFAzr3YW0c0r5VEqWtgp9mfOqGrMIlet/N14xswwVWV3LsOKX2q/+lWISnC3u/40tn/zPU9Z6Y8x8+hzKU0gBFkGJRcP1A64xCvBzWRct/lDhyQQ/zjcotWK7qScSax4WgN/FwV+67KwFdqkZWSIbQvYYfH3vWd2vWF9yjCPKWq+p0uLWMgF+sWllf91cU+8voazP4i+Nc3Cok/dlresWo/czFCAuD5mZTJF27h4EjmrCbSGw+zgic4PA6YA7I09aThhdtYJM+fVEYn0mPzYGUkG+DO0i6wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NM2Ghm/ZCL39YrBdnGbY+ZSuOwXEXqew8dbgj0Dn71eJXoeRmVhUj8jmNsft?=
 =?us-ascii?Q?bg8SH0WaWIvSkJW4dvaPOjTS8SvHbcy0Z/xzgiSXxxPdLdIMju09axKf7q26?=
 =?us-ascii?Q?qF0JOSzYyofJ2QQISNEyfCh4v6BYFkZXnEOASE+tRrqd+CRXRMk5hewAECLT?=
 =?us-ascii?Q?rQ08pip2zD+8Cnp9K3z4DeMa4cAcAZlcL45MRCyb5iVdAu8RN+rGQ5CVQOvP?=
 =?us-ascii?Q?ny6r9Zqws0jxlGN/3zxn/swxgkbsmVnzYniihHmLBLXBGInkRXW2YWrWKPBi?=
 =?us-ascii?Q?H0E6FKmS3RhyaSF+nDlmvBrceJoLZofz8lJCkHS1Ya9Gsfnc4NihCZb17mYZ?=
 =?us-ascii?Q?npk/jxbCce1LjpXRFF3I0dLNz9BzrsRmH9T0zGeuvN4Us0tKTfs7XRJWvguN?=
 =?us-ascii?Q?10Sltz+bS31y3LYcYGogRlx3APqCUXaOgF11u0Jim/dZOOwnQArJ5agRvE2T?=
 =?us-ascii?Q?81RNxousKODxt+Z4F47nqz8XloKGTEwrz4D7vOG4440t7rUqlIteJ10ino3S?=
 =?us-ascii?Q?we9nNL/Pa7h2OcmbaVUmQZ+Ivrgu5sUCzMc5/+oodpGE1gLVDCouB7G8v0tc?=
 =?us-ascii?Q?VGVaoaejqW/oAiGjZ9L8rLiadF+lF/5U6oKXI3AwhW5mmGnAjjqnhBb2n3ZN?=
 =?us-ascii?Q?az6gtggZmzKxjXrvpKopXl/9Hb4VCpSkjP39ebJX+4VyoICTBpmxia2FhS8q?=
 =?us-ascii?Q?HWAQB0g1LO4ta60j9JX4ikK7ELQLSVA52YYLUausDmz3BgCsv5s2kLXKQhV4?=
 =?us-ascii?Q?1Ab8fdOsHyvu4QdP3B1qRD5kz4/zjiZIgP+Oe0yCCj1oU9EmQJ3ujMFpkqOF?=
 =?us-ascii?Q?4V+w9YcYUCLfy/+WEckrUtE2euw0CPAKRQPPzmYxds2mR4JXj21vpQERXKtQ?=
 =?us-ascii?Q?XF4BUdwzeGzcx5HlERSWCg8xNK/6PmYr0l89XXGQSKRHr+6PUK9CW5IAajp/?=
 =?us-ascii?Q?CDo/kUkiB0iKeiGJGn6mH8dPPQ6eGQWCLhM0cDFqK7lrN36d7udmME8m6G5a?=
 =?us-ascii?Q?nF/MTCr0SgEUKeQw+0d1mz57f58hXPQU6eQ2f/tjqwko2nI2+Cn3Z2kYx6BA?=
 =?us-ascii?Q?uRA4U19AqTw7fIxHcdBYSMKOmdzbCRQzO+VZJnU2DsOfQImGIcblBtBMjniM?=
 =?us-ascii?Q?rVjLZvplO269mkSXBvjPSRy3jcpSNxiiw7PbVvAqe85tdYqzwjG7YCfdCV9G?=
 =?us-ascii?Q?kPBn8k2B37emFWXqeglDhCZ3ADdX9KCr5qeFQfXgXykJVfNzTGJ3u76GIdAT?=
 =?us-ascii?Q?FL/zNZkoBra/ac8xgj+ixbNmQdZ0fZjqwMP9OVyED0RFFm8NuNg9GDk8KqCP?=
 =?us-ascii?Q?TBH1cu3idlnEC35PR/rcGSBtPDmhU8NOCt01waA+VsR95BjyU6sbhQF1bg0b?=
 =?us-ascii?Q?Uf0l94AA4gM7KFieDKwaO1kRGaH1Vdv3vgt2MLrVpBo2jicDVzwoG5dYLm5s?=
 =?us-ascii?Q?r146DRJOpBcQblxywge0em66rqINRSywjA4YMVpUflY6J8h1thnvmUAITgMf?=
 =?us-ascii?Q?BMy4fTUXfWR2uztiEOew00ayRgjwP8aiffg4lQRULV5BXQ+d9RJpi2mB/5GC?=
 =?us-ascii?Q?dkiN/zpH58R5tbfsVOmlwDKuXwenkIgiRnewRW1w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc9fc20-9542-40ec-6aa6-08daf2460734
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:00.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12OGbxrtr6kKdqZMrSrW9TYn7Ho1xSrmuioOPa/7tFnB189Uwws2PCAFvU1mK5sjNxyq16zOXZCIwOVILbirmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
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
index 2d77fb8a8a01..f0ceb182ac43 100644
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
index cff5f2e29e1e..01418af45dc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1388,6 +1388,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	int err;
 
 	sq->channel   = c;
+	sq->mdev      = mdev;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
 
@@ -1785,11 +1786,9 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 
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

