Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4436460CE4E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiJYOFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiJYOET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:04:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC519B66A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A77DJKfcwI1zPoLhm3KyZF1ZlbcYKu3ETij5BSomeLpT/WY8LlCsfEm7eiemv/6t5Wh/jrpMR7vB8Y9OT2of6aTa5o8y60EJ+rGhvW9xXmLFZO8g7J/+0vMhUta/BuClczgmvIcmlk2tJrN/CfyaZiud8fMfMdpcVq0td8bpeAv53+KHgqZeobgKAUasxtjQTlsKbEJaelrLaXO+bIqvnEBW931uYLs2jhMFYTLLcF+xONm+JEBmT+89jmpXqiOdGJBOJ3ZWRkVveczYTgKIjiFe5g6EP1vtwDCxQHy2vIRh8IalzD15u/pV8sXyXhoml1NiS/ltvPMBAYlNXNSTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Yledg3t9ZadQCE/UuO4/TrC6S5PlXithGiIUeKYE0Q=;
 b=WUTNI3lSnBmq5NkKL7VFFofMGBb0nGNf2GjHGwxIVa3sCLXAXreeHO0ZYXW8XanpcTGUGV7udaWnau7a7xz3pnHu2P8nsJnmIsp7oJ1aAa9lVhQeGn6doaetRJVDRVCFxTZMNSsewhhP5xiDS505Ug8XI8DwwUXAMNe92B8ynHmn3e7kxZG5KqvM/KXBcsudxKcJIib7f4UP5U3cly0P8sWTnMjxOxleRfaMB2d/rX5Nm4HcyDL0Ry+cREfuGtwESbrTt70ydXQab9F2w40wjPa0sSNj/AuSboWPW+CWkqUbX4ONzhbvfgJWw4TPLJwYJWtcO0N5G9w1JZdnvOzjqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Yledg3t9ZadQCE/UuO4/TrC6S5PlXithGiIUeKYE0Q=;
 b=n1bB+WPbTXNtnjv0G6CxzxPb0gaFns9utH04LdsOn48nFuMWLZR1ilMc/1Bz1YaNonhJB2aEcHcqdIFDD+K5ahnuAxufjveMrogW7mtdc3QdokSCPPbHCGJ6h8OzPEaX0gj2pE87Cz/beeQcehkWakLQHOsV/mit6vKzquPOeYjY59FuoSgE4a81hMegHHuO/c3ObdPhBk5GsVS9PFcDCAi9yPkz8V07P58ednQrXEB8xa7oxaVelbmGkDLlScWoDLpVtKR2zEhClkKVGPzmsFFWErUCQIBerPiKqhYoE6TAS4i5b59pO5o8MX3BSniRtPCcTDpvnVak8MjjvIqQbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:01:22 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:22 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 13/23] net/mlx5e: Have mdev pointer directly on the icosq structure
Date:   Tue, 25 Oct 2022 16:59:48 +0300
Message-Id: <20221025135958.6242-14-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0081.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::9) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: a30c1c07-ff7b-4c3c-fe0e-08dab69165ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pq6RWTer6mZnhi/VvdqfgQSED0/FAlWBWEtsZDL7gKShP/F08JBWfoUxFa2mxdTRM+Ev5e0VWxccYSalRM+DGDXvVLmqCN0tOYZLv0fUluk8xVXFbadey1W02gInZBdoXF6t4k2rTPguCMVxpgknVqpiOmY907ZeEDp0PQaalB7/zu3jigzO2pWQU3X6ns2wtCDzvx8zS/a5FhfrY0NUWs1jvCv1DcuqYywQ0ePKytZOSenajqxXXRCphNasTOmK8V/9hIQNCPiUIYErouXhBun2ZlOqcYWYR9E0zAS29unOoQJAOhIbD525tMNIViegUJHWB9tgxM2e8ePyZDOTeM80Tjl7+aDykk4RaKaz2dAKgCYj0J0CbwZXo8OeT+heh/x8m0FnNgekbIodUpNESPr4YB7lnBbGZQxcbHNXDwYcSZFmlfH1EpcEAqroCCbbO5tgCBXIR7yKjBoXZRIREAagXBMOFbZ1BykuYBP7oiOR9YgidmiQNBETkAm/iCFNjQOWobrEuV1pan6f50qnIzm8f8EhKNlZBifOOc4sPsVVWKmYQhI9Gsz6HFr698UTdf2RmKgmAGzmhA29yVecTAnz1H+c5n9tHJfxxFdGFOGOcS7d+9PRjUmjuR9ojcsGmycZ6k3zQ77BAo+lHW4NtF6gCnCtZobQ1IsCnJIINaHQeSiV7NtHD1zN+ZC3wHjiqXGu2y+O+Yy5ZWb4ze23iHe62V7nM4tc0JRdAOyNp1QsP5Etimnom8mSaiZGFeFY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(6666004)(316002)(6486002)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T5KF1MVX7At+XBLE/o94q2LlDvcV9csvKwi7XH3aQfVrMRvQQwd9d6Mv+ME6?=
 =?us-ascii?Q?dcHqfkoO0xn/I5coDBLuf4oxD40PS7i7gGMusMoqAdq8JSTcshb4bZlj0uVC?=
 =?us-ascii?Q?lkzKPjg7jem6WU+Ktd6SdQFv81vSO7m2eboB5xcc8RlYbuD6h/S+XvxN/3FO?=
 =?us-ascii?Q?KW6iVV0wSntJpYuRl17M5hpni9OYVMUwqIEITyGjrlfMLoyKYxQ0paXbpKph?=
 =?us-ascii?Q?h50FvojgjvSSgpc5IGg5DMXGRKVrO4wVW6GgzuKLLdZNmhTHO4uXoHHZmjJ3?=
 =?us-ascii?Q?58vIDaWjqWwOWDIb6c4nksS8f6A7HVg0dGtvmHIKyBnty0MWRLIQSHIhhqEG?=
 =?us-ascii?Q?Uy5Lr9MVQc9WA83w90LRnONOa+vqufq4ftu92HKIGxRUvsVCv26aPY3+A1vQ?=
 =?us-ascii?Q?NrPUiZvIZsoGpAVpK/lzNupjpEQIpjGXxzvg8LyIYP5VPa7SMvJ0QFDJwFAr?=
 =?us-ascii?Q?xGsYgwZxH0pG3+gXo7I9Em+buzUWQMxRe4noLByVp6WZqJKFIrK9epSVp1Ah?=
 =?us-ascii?Q?UYdVN2qjYp1lOmPcT+Ym+UIn3kaMfvAod/WJCu8QQjsnF/EFPfQurUXwK7pz?=
 =?us-ascii?Q?rFPd2c9z+a0MQe5cIp3kbi0VkXEfupy/ZYthz9qyY1PYJTrC+SbsFdGvmB1z?=
 =?us-ascii?Q?H0umrh12479d+2XcDDVl/Wmv7eZmzXrfjY0Lqf/jGt8tlssazIYZQeY9Oqf8?=
 =?us-ascii?Q?nxvWOdsPZZQA4tYXRdW02zQpUnwr6i2lgvf4u+zGYUDORTN221Rxc6uLDSe+?=
 =?us-ascii?Q?BwOqJW3knTiuvXrs9EE+L9Qc7L9hZaOI6hEljebdyC+Jd8iPbUUdQEOSkC9H?=
 =?us-ascii?Q?xgiPVQugNB+BEh2lhuueCbWO25RhsEH4uk/tCs/K7Uj/YX3C43fpXlArE0dX?=
 =?us-ascii?Q?sAxvnIXlgLo1+HcbCyjCICnvYDDRdITgNxCHJ0uuPYdAGhT3cnziGEGBe+bH?=
 =?us-ascii?Q?7GKIbIFkiIsJ7XUq8V6THVd3wC3OiJF+UtYIwOlmh8Tw8DhmXqZU6S5zzJE8?=
 =?us-ascii?Q?leiP5OnFTjlJmCNbgIPzbQNIZQxq5RUfdvm9RaFNISGFX4nyO6/D5bL3ig2s?=
 =?us-ascii?Q?iKiC7mmmK7Ca8XgvCMHQW1upLxg+PO58bKDbbeC+o5yUbR86+6fxPx1FaXb0?=
 =?us-ascii?Q?atNFENJblOFzbbU15LfeQqzJfXlhK1MJXDuTH/rwgZ5eG5o2hfXYISuScSoB?=
 =?us-ascii?Q?owe1wP561FSuTvFry4BidDuqfSVgJoT6rKwF5N4iXxND3gM5fOB9B3PJgWe+?=
 =?us-ascii?Q?TfexuU2zhrWaQ0YL3mgb8G+raFM5oywtIDUpqUvAdkPcr8SyHUVjNuZynvIn?=
 =?us-ascii?Q?dyFekKEk6q7VYYK4U6kM8L7PHbLTaIdWKtQn75JGcZiGu3pfNAes9qU8guNw?=
 =?us-ascii?Q?LMJ+5pO6JUpW97bxrw8LqZfl/rpXxJRfyEu7uNYallObE9LQORq4GXegsoAm?=
 =?us-ascii?Q?K9kxjV9h2ASl3BL0zqVuoFTAULvovRV+yhspQYsNzWGeYh1KbATnWvcJJszQ?=
 =?us-ascii?Q?Q6zMAU4i2LIZtallGXivoPr0W+O3+SIcSZ0ezj2ZcJIx+FNNoYBueB1cJjbw?=
 =?us-ascii?Q?hE+30WXFdnlwGDrAa1pWbwPPNgNBRTIyIqLWtpyU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30c1c07-ff7b-4c3c-fe0e-08dab69165ef
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:22.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLO4TUSMegeOzkR6MQjQGmaETwS3CEgXQkksWcadiWR64Vo0uR+lV7CgYBGKvs0xq0D8BEAAqAcsX2ywH0RsFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

