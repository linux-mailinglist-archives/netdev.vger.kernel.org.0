Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA1E60CE5F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiJYOHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiJYOGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:06:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4CA5FAC4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:02:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU7fu7K7KOWXzA60JuVEUZwmwvfXfcbB7Y3grwut5yOHb9NsVmu657TcvqjWUvi1e0mQE1WDQ5o5NZA9rWHqrVFFaljMTnAEFb9SFq0Vc5q+BL/jmXLLs6ziLk0uNX5I+9ci912cUheh1S/xt6J2fv5ua0adRwIZVfg4KUGeQQkEf+OnZ6Kbs9zyVrKwsc0xshEs8GJUAhxKK8PN6LVwlc8b/dl3RzbzGTLwHbRvGzi/E5FlC8bBf7gvdZebnH5Kq0MxiADHe1q4XkXlIbI+mZkY2rf4OVVAWF4iQhsP6oN/Hk6vnIXTMmL80cC7H0eIM9iTuy1k9R2i9UGWW6y4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PSelR8bHT8PMK1ZVZTTeDNj9QUuFfBo73GrIzcayUw=;
 b=eSPaKR751RTR1tqBTJ+03uvWQMTs3Wz9wjUI9wAevNkC41qhmWqvBmsVZ7/9krv+QgOu1r7tSDJnNn1JPddDWgigJq1J2tNkMUn/7Ii5bOTYMtd/poCv/fe0tsz6hKD4qGUp7mnHeKh8+As34qFJ71zn5Z7xTrd0On+6E51gZBxqFgUdgLsAk6Mdb4yQ8zFdtFKmccmQZfp6a1RaQj4VkNRNIuNP92Momlxt2azrPKCJlA3TIFgvaiN13+P71sLnzLOVALLK87Xu4TA385RObpcZ8x5I9WM8rTe/nU4PFQsARAZEQehhxlR7Uj/nVYpsT18pphV16ko7PXZcKPUaiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PSelR8bHT8PMK1ZVZTTeDNj9QUuFfBo73GrIzcayUw=;
 b=oRQKHO1pLZHZNCEOGfqMsVB0pXHEq5fhKq+TfwrzF7+iiC61MdEyAgLOJNmuVqFCZ0lnZg6LP7L01pTMvS4nIGlMEG4PEbOJnXLoHUIkHP0Y8xxmVNsahEEjfEXA+Tv4XQibogjsFRC3YNiomXbtfvhN5ptru4kwBedYYhgessNTdQ8QBtpKEmeUMN3nPm2Ve/rSyiLBQYA2pmJewaMqFpr4l+dX5BL18/aJKBIK3yps2zW2LH7yZYPCnXVEG6vJb0EuIpzFQbT0vBcxx50+8x2X3jN8DU0SkJ1IuFR6il4NqmUEtDhtVTL1v24yOj6ACfMpN5ez5E4ufMmtyPKSdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:02:23 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:02:23 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 23/23] net/mlx5e: NVMEoTCP, statistics
Date:   Tue, 25 Oct 2022 16:59:58 +0300
Message-Id: <20221025135958.6242-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::19) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: a73536a4-4fff-4d57-eafa-08dab6918a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgMCpMTDouXFYDVGIgXE9ljlIqQHbF7ePgNrGJIkyM9BkpEZ17mQz34BHRPUhlMWsY8QEfCqVSLZghhIo0tPc4G0CS5h1aOBeK7xmuTeRUcqa7eBqGhvZBlCr9EZsIHvCnwR92ZHX2ebEqtqWUptPYq2be7CWJ74tqW0w9JLNdNAGZxFLo9G55mLveXMzL70vQBjhXyafvlE+HsXjj+WvIfItW1vF5orYyE/1QXzOThcQYcOBwacu5XkSFV11lQc2IdI7O70LSsHkgpKDxdSJ9nt0mP3yrMAqnMRu4zrWsrZO389GlZEDq1LMDoSgsg+IMNltBNnrwvxXe39+jmHTwJZNWokGIcqaW97L2pZ5G9LyhXugr3i8B/49jIgSCDK587P+GcwKsQX+NuXL6Bb5oB84cIV8mBJgx7Ne+FrM9/nZ3JgzXNR5eXOpIquf82UiU3K6B2bYow6PoeZWZJ1mvuX6gNnNOwYJHr/LkBFFsh+BeYDZ5moGtjTGD/LBqkTcLW3FjSuN3KUNwx8CYptfdTXGuZ8yeKbSrG2F4uiRXmJSfrHUIkcWRKRL8fIjgEoqE86FL5+Sq1IZdViB897C8dl0Ltn7r5OrpA23l3dnZOSXQ5PiRbdtG6CGRju7UPh7DBMpuOG8qDtcQhFWeh6V3KfApu3QXGZnJdtP7tlSjzWopHgZovXJdg1aKMKIrTkLSZeEHjgAGOtK1Q7b65yxRmX7yxy6+w7Vx5KbskGEHcvt3a1IpqqJ1JAbdIKyJiE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(6666004)(316002)(6486002)(30864003)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nB5mlDAMyykwrACZ9pICXSP6gQfXbbLORq1Gf1VlxzgX7WrBGzyOu1sJQtJ+?=
 =?us-ascii?Q?WFNifIyCU83CU9UeyUFAk/MbXPA8jN864tSMhPWH5XiIl4hnzHt5JuK50rZU?=
 =?us-ascii?Q?0ax/Bpk2LJn9AyPwrKnKd42urC6dOAhyjVWCvz5cF+WwfEM/LizttH9voHFC?=
 =?us-ascii?Q?bgfW39sxm64She7vgz06LWfpeWaNomFKUFxWuOg0DSryCjqhQjsBe0RxFBmP?=
 =?us-ascii?Q?1FfjT2wTe29WvmTL01r0I0seIMxe6DpXdRC17jGnt5EHRaG4xxcn9pL7D8o6?=
 =?us-ascii?Q?aHOZGF1G/d+Fx/RTqPTizu2b7aHer9H4AK2/s4q2Nl4DQ0d2izvDev2Kbpzd?=
 =?us-ascii?Q?OZlIZ3bTsRyVfdm1FpYe79mLIMu7DwenP3mLtIil0Zw6AR0Us2dK2LJ978j3?=
 =?us-ascii?Q?wxwXhVnvr8sCkTWmE2SK/TDMldWdTGFt/rerXxHHYGVTY9dr3rTsmL7+f7KA?=
 =?us-ascii?Q?rdRw72UKRZN+kOkHHajBTqVUllWNh3TrB3JUJrHYfE5ovpZaLZ0XQFlikMGW?=
 =?us-ascii?Q?zPAplkR/odSqJCTbqw33eHk+VA7N3fEI8uZKn1LJPgmqJNPcloxzqhylkbgI?=
 =?us-ascii?Q?H+IKC3/bjMwIRPuzZL+xJflXw8Ol97OOeaNeEmFtUHHgqSrsoy4DF2u9ARkm?=
 =?us-ascii?Q?Lh7YaD0fvCwca+vJVGO2VUsQyzOVTSdC0EqIyMA6aODLWhf0FUihDJ8P46jp?=
 =?us-ascii?Q?hgTROIzEDTIshSf4mol277+YsbWBb3mhHiMk68hGaAXcqrCoAKCQZpvwZtVD?=
 =?us-ascii?Q?Mw4tfYXsvNgd8i77MDk5IQNbTtiHcpJ/WJYzHBfb++KOo8enkbJhrWj9iBzV?=
 =?us-ascii?Q?G5lz9g0tKvBXGVKnl1OWlbQrCb/OGQTctZONnHYCBxq642uZY+xM/NYyGqEf?=
 =?us-ascii?Q?ceb7o6QjH7iXX2EO/gz6l/NpeC7xzIKN/9T5yTWtFK2QmlFNhT4ZGK7JQS83?=
 =?us-ascii?Q?ldsbui1yqjLlUILe6X8jk+SabUwrgftSSzb9FUKbXtGdmt1e+ikOWE9e4sO9?=
 =?us-ascii?Q?CpAr+/iaeA+Ya7UpYWecipnmnlMIxppejhFMMHjTXszXrAZCDCY8FNHEXqa0?=
 =?us-ascii?Q?lVBaJkw0HNcvuTLUk/L5cRxHlBoKWeki/lKNtL0N6jqx6UA2AB2Zfhcsp4uU?=
 =?us-ascii?Q?gqRosQ1kGuV4z1iqXzuhwPrOErcGbxMVKZV17GoYewRf85z+aBRaM95rIngZ?=
 =?us-ascii?Q?kSZX2p7gyHphBsgQVLsouC6NEXpA9WA9N33GGFwY7jDKTvsR7YkvNKawR2KU?=
 =?us-ascii?Q?UzPQS5S1awi14i7APEUaS08wJ5oZV41Lj6wQSkjSCRhF2L1wAnF0nKZtzf8C?=
 =?us-ascii?Q?gapyPFdwEDWwilCuImRdNMvWRmgtb70XJmwJcGIKLVy25kdweo/sRi8idCs3?=
 =?us-ascii?Q?Q19iIUhsZIR3+XhATbMpUiuqFW5qleMk4Tv4IBr/5nCYl6v8ys/KsDivbIb/?=
 =?us-ascii?Q?LfxAbBrr7xVTXtVed53gqK/2p4gkQcov5+MSO6NTNDiwVBdjdcU9OSaR2gRW?=
 =?us-ascii?Q?fZJGyXWT0Mz46In/iESrnT9Y4TVEVvZRRfl/pLqacUXboYSUVhvCInjKrNt+?=
 =?us-ascii?Q?2PE/N4ywmKZuPBZcszshR17G4kIXggI7PNGecyDA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73536a4-4fff-4d57-eafa-08dab6918a0d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:02:23.0121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pkdxs8CMYSSfJPosaKFUZeRO8D3mKGZRLPEZF0tYF523GQYSUi7QZH4r+qYJaiaLFP+3zrgBFonNxK5/harc1g==
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

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload statistics include both control and data path
statistic: counters for the netdev ddp ops, offloaded packets/bytes
and dropped packets.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 44 ++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 19 ++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 11 +++-
 .../mlx5/core/en_accel/nvmeotcp_stats.c       | 61 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 38 ++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 12 ++++
 7 files changed, 176 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b61f23f24883..18aa3e378a2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -103,7 +103,8 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
 				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o \
+					en_accel/nvmeotcp_rxtx.o en_accel/nvmeotcp_stats.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index ba3913ebeabe..594f53b29b7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -617,9 +617,15 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 {
 	struct nvme_tcp_ddp_config *config = (struct nvme_tcp_ddp_config *)tconfig;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
 	int queue_id, err;
+	u32 channel_ix;
+
+	channel_ix = mlx5e_get_channel_ix_from_io_cpu(&priv->channels.params,
+						      config->io_cpu);
+	sw_stats = &priv->nvmeotcp->sw_stats;
 
 	if (tconfig->type != ULP_DDP_NVME) {
 		err = -EOPNOTSUPP;
@@ -646,11 +652,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	queue->id = queue_id;
 	queue->dgst = config->dgst;
 	queue->pda = config->cpda;
-	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(&priv->channels.params,
-							     config->io_cpu);
+	queue->channel_ix = channel_ix;
 	queue->size = config->queue_size;
 	queue->max_klms_per_wqe = MLX5E_MAX_KLM_PER_WQE(mdev);
 	queue->priv = priv;
+	queue->sw_stats = sw_stats;
 	init_completion(&queue->static_params_done);
 
 	err = mlx5e_nvmeotcp_queue_rx_init(queue, config, netdev);
@@ -662,6 +668,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add);
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -675,6 +682,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	atomic64_inc(&sw_stats->rx_nvmeotcp_sk_add_fail);
 	return err;
 }
 
@@ -688,6 +696,8 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_sk_del);
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
 
@@ -819,25 +829,35 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct ulp_ddp_io *ddp)
 {
 	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	struct mlx5e_nvmeotcp_queue_entry *nvqt;
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5_core_dev *mdev;
 	int i, size = 0, count = 0;
+	int ret = 0;
 
 	queue = container_of(ulp_ddp_get_ctx(sk),
 			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	sw_stats = queue->sw_stats;
 	mdev = queue->priv->mdev;
 	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
 			   DMA_FROM_DEVICE);
 
-	if (count <= 0)
-		return -EINVAL;
+	if (count <= 0) {
+		ret = -EINVAL;
+		goto ddp_setup_fail;
+	}
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup);
 
-	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
-		return -ENOSPC;
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev))) {
+		ret = -ENOSPC;
+		goto ddp_setup_fail;
+	}
 
-	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu)))
-		return -EOPNOTSUPP;
+	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu))) {
+		ret = -EOPNOTSUPP;
+		goto ddp_setup_fail;
+	}
 
 	for (i = 0; i < count; i++)
 		size += sg_dma_len(&sg[i]);
@@ -849,8 +869,12 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	nvqt->ccid_gen++;
 	nvqt->sgl_length = count;
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
-
 	return 0;
+
+ddp_setup_fail:
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl, count, DMA_FROM_DEVICE);
+	atomic64_inc(&sw_stats->rx_nvmeotcp_ddp_setup_fail);
+	return ret;
 }
 
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
@@ -897,7 +921,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
-
+	atomic64_inc(&queue->sw_stats->rx_nvmeotcp_ddp_teardown);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index a4d83640f9d9..b7e90e5b9093 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -9,6 +9,15 @@
 #include "en.h"
 #include "en/params.h"
 
+struct mlx5e_nvmeotcp_sw_stats {
+	atomic64_t rx_nvmeotcp_sk_add;
+	atomic64_t rx_nvmeotcp_sk_add_fail;
+	atomic64_t rx_nvmeotcp_sk_del;
+	atomic64_t rx_nvmeotcp_ddp_setup;
+	atomic64_t rx_nvmeotcp_ddp_setup_fail;
+	atomic64_t rx_nvmeotcp_ddp_teardown;
+};
+
 struct mlx5e_nvmeotcp_queue_entry {
 	struct mlx5e_nvmeotcp_queue *queue;
 	u32 sgl_length;
@@ -52,6 +61,7 @@ struct mlx5e_nvmeotcp_queue_handler {
  *	@sk: The socket used by the NVMe-TCP queue
  *	@crc_rx: CRC Rx offload indication for this queue
  *	@priv: mlx5e netdev priv
+ *	@sw_stats: Global software statistics for nvmeotcp offload
  *	@static_params_done: Async completion structure for the initial umr mapping
  *	synchronization
  *	@sq_lock: Spin lock for the icosq
@@ -88,6 +98,7 @@ struct mlx5e_nvmeotcp_queue {
 	u8 crc_rx:1;
 	/* for ddp invalidate flow */
 	struct mlx5e_priv *priv;
+	struct mlx5e_nvmeotcp_sw_stats *sw_stats;
 	/* end of data-path section */
 
 	struct completion static_params_done;
@@ -97,6 +108,7 @@ struct mlx5e_nvmeotcp_queue {
 };
 
 struct mlx5e_nvmeotcp {
+	struct mlx5e_nvmeotcp_sw_stats sw_stats;
 	struct ida queue_ids;
 	struct rhashtable queue_hash;
 	bool enabled;
@@ -113,6 +125,9 @@ void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv);
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data);
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data);
 #else
 
 static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) {}
@@ -121,5 +136,9 @@ static inline void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv) {}
 static inline int set_feature_nvme_tcp(struct net_device *netdev, bool enable) { return 0; }
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 static inline void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv) {}
+static inline int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv) { return 0; }
+static inline int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{ return 0; }
+static inline int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
 #endif
 #endif /* __MLX5E_NVMEOTCP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 3228d308d7bc..138e15396c7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -111,6 +111,7 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
 	struct net_device *netdev = rq->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_nvmeotcp_queue_entry *nqe;
 	skb_frag_t org_frags[MAX_SKB_FRAGS];
 	struct mlx5e_nvmeotcp_queue *queue;
@@ -122,12 +123,14 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
 	if (unlikely(!queue)) {
 		dev_kfree_skb_any(skb);
+		stats->nvmeotcp_drop++;
 		return false;
 	}
 
 	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
 	if (cqe_is_nvmeotcp_resync(cqe)) {
 		nvmeotcp_update_resync(queue, cqe128);
+		stats->nvmeotcp_resync++;
 		mlx5e_nvmeotcp_put_queue(queue);
 		return true;
 	}
@@ -201,7 +204,8 @@ mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb
 						 org_nr_frags,
 						 frag_index);
 	}
-
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
@@ -217,17 +221,20 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_cqe128 *cqe128;
 	u32 queue_id;
+	struct mlx5e_rq_stats *stats = rq->stats;
 
 	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
 	if (unlikely(!queue)) {
 		dev_kfree_skb_any(skb);
+		stats->nvmeotcp_drop++;
 		return false;
 	}
 
 	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
 	if (cqe_is_nvmeotcp_resync(cqe)) {
 		nvmeotcp_update_resync(queue, cqe128);
+		stats->nvmeotcp_resync++;
 		mlx5e_nvmeotcp_put_queue(queue);
 		return true;
 	}
@@ -301,6 +308,8 @@ mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
 				       hlen + cclen, remaining);
 	}
 
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
new file mode 100644
index 000000000000..4078317e5e25
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES.
+
+#include "en_accel/nvmeotcp.h"
+
+static const struct counter_desc mlx5e_nvmeotcp_sw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_add_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_sk_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_nvmeotcp_sw_stats, rx_nvmeotcp_ddp_teardown) },
+};
+
+#define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
+	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
+
+static const struct counter_desc *get_nvmeotcp_atomic_stats(struct mlx5e_priv *priv)
+{
+	if (!priv->nvmeotcp)
+		return NULL;
+	return mlx5e_nvmeotcp_sw_stats_desc;
+}
+
+int mlx5e_nvmeotcp_get_count(struct mlx5e_priv *priv)
+{
+	if (!priv->nvmeotcp)
+		return 0;
+	return ARRAY_SIZE(mlx5e_nvmeotcp_sw_stats_desc);
+}
+
+int mlx5e_nvmeotcp_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
+
+	stats_desc = get_nvmeotcp_atomic_stats(priv);
+	n = mlx5e_nvmeotcp_get_count(priv);
+
+	for (i = 0; i < n; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       stats_desc[i].format);
+
+	return n;
+}
+
+int mlx5e_nvmeotcp_get_stats(struct mlx5e_priv *priv, u64 *data)
+{
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
+
+	stats_desc = get_nvmeotcp_atomic_stats(priv);
+	n = mlx5e_nvmeotcp_get_count(priv);
+
+	for (i = 0; i < n; i++)
+		data[idx++] =
+		    MLX5E_READ_CTR_ATOMIC64(&priv->nvmeotcp->sw_stats,
+					    stats_desc, i);
+
+	return n;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 03c1841970f1..5ae81381ff48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -36,6 +36,7 @@
 #include "en_accel/en_accel.h"
 #include "en/ptp.h"
 #include "en/port.h"
+#include "en_accel/nvmeotcp.h"
 
 #ifdef CONFIG_PAGE_POOL_STATS
 #include <net/page_pool.h>
@@ -211,6 +212,12 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_retry) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_resync) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_bytes) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -391,6 +398,12 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
 	s->rx_tls_err                 += rq_stats->tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	s->rx_nvmeotcp_drop		+= rq_stats->nvmeotcp_drop;
+	s->rx_nvmeotcp_resync		+= rq_stats->nvmeotcp_resync;
+	s->rx_nvmeotcp_offload_packets	+= rq_stats->nvmeotcp_offload_packets;
+	s->rx_nvmeotcp_offload_bytes	+= rq_stats->nvmeotcp_offload_bytes;
+#endif
 }
 
 static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats *s,
@@ -1934,6 +1947,23 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(tls)
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(tls) { return; }
 
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(nvmeotcp)
+{
+	return mlx5e_nvmeotcp_get_count(priv);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(nvmeotcp)
+{
+	return idx + mlx5e_nvmeotcp_get_strings(priv, data + idx * ETH_GSTRING_LEN);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(nvmeotcp)
+{
+	return idx + mlx5e_nvmeotcp_get_stats(priv, data + idx);
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(nvmeotcp) { return; }
+
 static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, bytes) },
@@ -1994,6 +2024,12 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
@@ -2445,6 +2481,7 @@ MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
+static MLX5E_DEFINE_STATS_GRP(nvmeotcp, 0);
 MLX5E_DEFINE_STATS_GRP(ptp, 0);
 static MLX5E_DEFINE_STATS_GRP(qos, 0);
 
@@ -2466,6 +2503,7 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(ipsec_sw),
 #endif
 	&MLX5E_STATS_GRP(tls),
+	&MLX5E_STATS_GRP(nvmeotcp),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
 	&MLX5E_STATS_GRP(ptp),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9f781085be47..4e3567bfbd65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -199,6 +199,12 @@ struct mlx5e_sw_stats {
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_offload_packets;
+	u64 rx_nvmeotcp_offload_bytes;
+#endif
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -393,6 +399,12 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_offload_packets;
+	u64 nvmeotcp_offload_bytes;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.31.1

