Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3B67D15B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjAZQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbjAZQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:25:35 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0F02712
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFPfvC/Y2qc8k1vAye6/UvnKhFimL5WYWOaz5nMafkbNZg9Dxc+81CKObDEbetcxmc9Bw6ke+9IIWMjkyyHSh/tnRwRfegIjLbZrg4nT4a2bNG9is5EHVlxDQqQmVDmeIk1YS/6AiG8f1/RIawc1StGDsjRDs3uFqe55Pt8OTEg6ZFmMcZQOVzHZNpb9ls6VsMXV0RIEMtp4xDKLQzMnLrmFIAwdJZXe96YhqciQ5pEROO/A/+m86N+9Yeght+1/cJWbdvjJzessMmASG8tje6JLmw+WBpyAw3m2YgJo5UT7YLwf95F1Sj1C7u255fA4gq3RTPLZfDzQt1WRtybbyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GM/ExRu5RNF69PiiUUK+b1R8bbIuRKJ/vxBT72HSD9Y=;
 b=A7yLG2cncD03d3rPr5yAa1cP+N7ouOC4cepoM3thLBzGaSkNyuwNfCgepzSwYGdTnIfKJKfo1KgmYPykTMJHXLmqCwYh+PCHgevEgDeU4XmNmlV9Rw4DStnE4f9JhyjSIWt8tA7h14zzHFO3+XUVoK8G8TK1HvGXtQy6h+y71+CSWSaiwEJv9vtIgBb3qW2FfgfQg7wVnCjybblh5PuJIlC+q+y0sIXbDf0wVee3tmr2QvZYEaXll2jlJuvB5ri7S8nSHcSgGX2NnKpxSgVyoLyi+EM1dLgvx83xbDoJvYmooG4JHgSRyXotMmoX/scudDvhHEh1ADv6DjRlJQmqkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM/ExRu5RNF69PiiUUK+b1R8bbIuRKJ/vxBT72HSD9Y=;
 b=DI7ZmPujKGpbSGIgZLyOSoIcfYbIImeYC7DOeUzlPIkScNa9aU520E7aTEZNNBvBOxljedXHvZhHNKENW0d0DYGEYCBBc8bG+SPqaDC+lZ6Gw6KrEmCvdcd++3TSOpe/c+MB2BZWulzswT2rVKp2pEwz2+Ouq0GQBFjDbWNPfrl5KKGnCEzMghx7bw6N7sjTNkcxhTsHuvby1OywZg/eMRXOXdRq+Ysf+PKi3La/Po1r+RvoJUHFfX5XcHPE5X5ZjogFYSxQ55J3AsZqi4F25A7AQhf3ntgl2gNuWpG3OGx79OlhkziXDhEES88JdaGQDqPZIUe8e4DiWZ0YhnNktA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:23:50 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:50 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 20/25] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Thu, 26 Jan 2023 18:21:31 +0200
Message-Id: <20230126162136.13003-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 45fc0eac-62eb-4569-4566-08daffb9b51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJSYNe5m0ySHBoTGT/v2ct9yLgTGLsVchwOqOHDI0XauIFil/BmLVOSRLGl9s8skZ/QvXBqJoiuDcOr+qlapCVfYsfl+dzufOldiymAraatezsspcdKg0gMWLfAU1mnCsFtDw7jacpat9DkXSvFNLI6iGw8nBZN8d6ttNj2pyCAtE+VeqhjMwccBwI/8sOFtzejaewOg4kkJ9rGwouav+FF2s69Rq4kNhNmQvUvY95DDOXMKEOJqu2MAh2WXOrs8J93eigi88DiQWKoUrsNOaV/dt9PiEKt1vhJbEhqir2332kJS1Z5rUbR5xD26euu7peEQx4sYOO36RhA7IBiTHgTkEcdcMhnjL/OzGIbZLEuQrs5DCl2esDyD/RxNUp17TveuAZdJTy3ek1rAWNvrEMZxkLVF1q87AHqwjs9zEbtTrOZPMUFkrIlOI5KZKrI6rJhPPyj5vpwg5YzU2Qc9GE1/s1p3MgFuFJPhg2lq31kMsvqm0yMocpl9BvM2yAuRaeuxr6qhpuF4mi3REs7LwSer+CshzYVUXb8v8E+s4vGE8rivbk5HmnevhKYDHHOqCWqizWSJ4ifYJOxQ0vETEhXnkxr6PglsK8aLitnRvwj2zIy3ch4Jr/QDtZ8dg+BeHBYgmBmXCo5whKH4KnXEyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(36756003)(8676002)(316002)(478600001)(6666004)(107886003)(1076003)(6506007)(6486002)(5660300002)(7416002)(66946007)(2906002)(4326008)(66556008)(66476007)(8936002)(41300700001)(38100700002)(6512007)(26005)(2616005)(83380400001)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cm98MBonsKPRF6IPfNPST1uH0B5RCGOxA1LrHmBOirbZ11QNyYS9CuS5BYG+?=
 =?us-ascii?Q?cjRe7mW/I5YkwN6gcBbVCOOU5CODs6GmG0xKAlm7dsloBVJZHhs7/MNaJEB5?=
 =?us-ascii?Q?NBIINn7/mlNNojFG3KlaBPTfoUDxRhJ23k2+44iJUuRSCSia2JDu55bkKOQy?=
 =?us-ascii?Q?J+rPJFRlnxMxkCigSUC6zw8V/QdKLIhxxOXx8M9ia1iArtpbL/z38MDBWQ1j?=
 =?us-ascii?Q?MoPsjSZLEnWE2IGac7UpMx94yFbtaauw4DeIY8J2KK7k13eePorV+l5Ss0O5?=
 =?us-ascii?Q?0SgFnIZQATW0gx7xmfJuzrRL0gDbetQydwS+hsEDzDCHh2QhsDGbcGBQPkHU?=
 =?us-ascii?Q?PipNMYwoqdw+nhMG3sDOYsICIYbZWOn0r29CECH/EtQ4lout5wlQwDkbQGBU?=
 =?us-ascii?Q?3BZ+iNRyfBJe7BsTx1I2Z8hojdHyaw5E2K8HG0Fk61sGOhcflVq2+xkzVgI9?=
 =?us-ascii?Q?yaNXp/jD9Gm9qbxjV7kVMBVuokIbGgJj+xb+cCW4+jOJeiiNO6MFDFhhmgna?=
 =?us-ascii?Q?kkFj0cVVaGihZITHh3JpSH8N/J+teUucHY2vbrZn34cQrU+GRtrcMEnqrmaL?=
 =?us-ascii?Q?mAYpblWdfTW54MDZ7BN49ChtJWCE9pKKObl+Q+51KA0JYFOJEilZqqKsNF1K?=
 =?us-ascii?Q?ZDG+H5M3uQR1CFW5K/WJGISJMi/BoRu35pvzG8Prepkfh8/eQ/eankrWBXof?=
 =?us-ascii?Q?blWWGPt4HnFsQbdE/HfZDqzX8TtC1dzX2May9C0MPrX0UA7HRwMJVSFA1G/Z?=
 =?us-ascii?Q?i3DxJv0eoE3ZLwv43v6cvLw3IsuUvlDerkDcQ5xGH/5HSN5mGjyGpw6rjHU2?=
 =?us-ascii?Q?7CqiepZyS/0DA9hcYB/NAKv5b9uIRcxN6j3yjUzRYmyVQM1yHcvdmHyCuQnA?=
 =?us-ascii?Q?sZDBcn8JK5PnMTsSFrXewOz2ynpk14wx0G9CryYyEnS5IiHRaDT9LVcKOtU5?=
 =?us-ascii?Q?mCdtJMca8Zr58401GG4ts6Dx6PZycNva/6TOnye6AT/M9CR+5AlI3QIm2+oM?=
 =?us-ascii?Q?iC6J+ZuBA+h+RZkVqaalT2IfgVmO6JWXDWKVJ0mMZwyxW2cf4VX2Vsrn3A6Z?=
 =?us-ascii?Q?y4l17yyo8T2GpoBFxb8US8M6SjZZhCfRx2rVi/KpfKPy2YCSxMbuHyBXWA00?=
 =?us-ascii?Q?kU0A2o3GTlOg0VaVpijjYpLsQnuipsCMH0DEGBvzHfjOG5VVNVnbYdlGH3hf?=
 =?us-ascii?Q?aWLzMNV0OifM0wz18U0wJ6DSoXXGCGc6wnLDm8wsFw0lsALvkkoFrTICtNv6?=
 =?us-ascii?Q?T+0vL7Olbc+X8qCkMheKgqitEVYKfvaEP1t6NF+H2GBbnciE/DqEqBcjRRA7?=
 =?us-ascii?Q?WY4vs0e7AoyhLBcxP8VUYFivV6ugR9wayFdbk3dTTXc90sqJAHgr4dlUEWAW?=
 =?us-ascii?Q?vTrtS9OzsOevSzcCCwvU3m997nXwVAXL4tWe0HCk4JewMD676O5E37Xdq6oC?=
 =?us-ascii?Q?PAI2BfCPuh+dQwwT8lQsWk9R8NNFLzXpDXtgtEZxE+wtllgFNqXr73ml0ltr?=
 =?us-ascii?Q?xqr+Z+YRUtM34zOYsF09C/tpfqxEvvnskKHTEj2svlnLy3X9y/yA6bRLXZ3q?=
 =?us-ascii?Q?3opsRazgpQ/zaATIV+vmv6NQGS679pcsmWOaRHT/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fc0eac-62eb-4569-4566-08daffb9b51c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:50.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHFQ0CJ0O5gnBY2fPr0LiHk3/fsh/wzWc98DGMZeWVx7ThxCxqxxls/GIB82jjAUb3/V0YFHMZRR+neQ9IcJIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for ddp operation.
Every request comprises from SG list that might consist from elements
with multiple combination sizes, thus the appropriate way to perform
buffer registration is with KLM UMRs.

UMR stands for user-mode memory registration, it is a mechanism to alter
address translation properties of MKEY by posting WorkQueueElement
aka WQE on send queue.

MKEY stands for memory key, MKEY are used to describe a region in memory
that can be later used by HW.

KLM stands for {Key, Length, MemVa}, KLM_MKEY is indirect MKEY that
enables to map multiple memory spaces with different sizes in unified MKEY.
KLM UMR is a UMR that use to update a KLM_MKEY.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 123 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  25 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +
 4 files changed, 155 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 3c1782d58feb..76080411456f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -50,6 +50,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 6d705e8aa4de..e5b310653118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,6 +20,120 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NUM_NVMEOTCP_QUEUES,
 };
 
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe, u16 ccid,
+		      u32 klm_entries, u16 klm_offset)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
+	lkey = queue->priv->mdev->mlx5e_res.hw_objs.mkey;
+	for (i = 0; i < klm_entries; i++) {
+		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+		wqe->inline_klms[i].bcount = cpu_to_be32(sg_dma_len(sgl_mkey));
+		wqe->inline_klms[i].key = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va = cpu_to_be64(sgl_mkey->dma_address);
+	}
+
+	for (; i < ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT); i++) {
+		wqe->inline_klms[i].bcount = 0;
+		wqe->inline_klms[i].key = 0;
+		wqe->inline_klms[i].va = 0;
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe,
+		       u16 ccid, int klm_entries, u32 klm_offset, u32 len,
+		       enum wqe_type klm_type)
+{
+	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey :
+		 (mlx5e_tir_get_tirn(&queue->tir) << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
+		MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
+	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg *mkc = &wqe->mkc;
+	u32 sqn = queue->sq.sqn;
+	u16 pc = queue->sq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) | ds_cnt);
+	cseg->general_id = cpu_to_be32(id);
+
+	if (klm_type == KLM_UMR && !klm_offset) {
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
+					       MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_icosq *sq, u32 wqebbs, u16 pi)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	memset(wi, 0, sizeof(*wi));
+
+	wi->num_wqebbs = wqebbs;
+	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
+}
+
+static u32
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     enum wqe_type wqe_type,
+	     u16 ccid,
+	     u32 klm_length,
+	     u32 klm_offset)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 wqebbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe, klm_length - klm_offset);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
+	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(sq, wqebbs, pi);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
+			       klm_length, wqe_type);
+	sq->pc += wqebbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+	return cur_klm_entries;
+}
+
+static void
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wqe_type,
+			    u16 ccid, u32 klm_length)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 klm_offset = 0, wqes, i;
+
+	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+
+	spin_lock_bh(&queue->sq_lock);
+
+	for (i = 0; i < wqes; i++)
+		klm_offset += post_klm_wqe(queue, wqe_type, ccid, klm_length, klm_offset);
+
+	if (wqe_type == KLM_UMR) /* not asking for completion on ddp_setup UMRs */
+		__mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg, 0);
+	else
+		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+
+	spin_unlock_bh(&queue->sq_lock);
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct ulp_ddp_limits *limits)
@@ -45,6 +160,14 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(ulp_ddp_get_ctx(sk),
+			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	/* Placeholder - map_sg and initializing the count */
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..6ef92679c5d0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS 0x4
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+
+enum wqe_type {
+	KLM_UMR,
+	BSF_KLM_UMR,
+	SET_PSV_UMR,
+	BSF_UMR,
+	KLM_INV_UMR,
+};
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 51167f000383..02aa16f5eb57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -984,6 +984,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP:
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.31.1

