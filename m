Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFAF662735
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbjAINeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbjAINdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:36 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF23A32182
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/WLJJVYgEdZUBhz1S2cxHpsQL9jZs3Uiil4LuGpwNnzrnT0HeTtLc89IQg3/TVz08LHf94k4bHyY5LEbzzuvBEaXIM7VyisREi8kEY9uSECZ6rFHi9iJdw7wdq7SBTH4nQuHO/7xmwPKaWCPRJYseQwrZdC9z336sqgn1TyCJOlU7XfCW8q83+TBhrkMb4J28eZaJKAyQZS/wjONsGDneEPy6DyHTj4QI+Urvm4Cr7K/pCKzY2+1H+IfFUnxHpJJ03XvZxo+8MrdOOA734PezoqcVaOrqbhU1SB3Qk7etIWln5vZMDnBxcQ4Rv3lXIvpI2CFtxgM9Z4HRXtQv58Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53R1CJMzRYqQ48Ra3u3SNvEhtJ1JMhpweQfCG2hq3OE=;
 b=FYFWaGwwjeX6oZb+cydqqBusLBnNMsZJdIK69H94cLj0P17dRfkCKDCESLyXfFzZDiqwI47akx1TOnaYIh0uZmFqCuxsJze5NzcKwcr2vT4RXJK0mdfe1i/Wa3q5w3dp00j6G78dHFigcK8mOy8f6idG+6PULVLVIkRgNb5hfd5tla2SuaTyJ1q4DYJevpUilah7+Td1Ds7VHtKivBZN/YZNxHa2klCvGZCzBpZ2XdeinGbMreDmEKaR0k5cK8+ZX14SeO1DU8GbBZ+tfX7OZNTBj8labge9E6BE/jWvSOORPwCCg/achjNBlylIv21MuYLyYzlKpIV30MCT9wNhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53R1CJMzRYqQ48Ra3u3SNvEhtJ1JMhpweQfCG2hq3OE=;
 b=fDxju9j5f5nq9gSr6W8ajFXP6kgyfezllUYFmSQUR4NpxrogNqo0dK5qTjAhTUhiyymPq8VwZNQqJFX6Ct2Gw4Q9mCSN30sWi1BM5GmF5V+uFAacN4uQhP7VcmyLYn4xud7bLnbO0ytxAHCsUtP/b0ieFIdYc+CnW1og519K4SiiPzJfJwhgTh45vNsnsT7i1zoY7idDEoMZTZ0v86XVOi2DxYL6wJdYPGJ2I8OyGsCcKgcay8jMiu6qbav14zq5k50vWoHl/oBJ3XdgzjfVDXs8KAcNLjIjMwNH/6vAgE8d+WToHeoocM5FHRrAbgKRmtw2NYlOsUnaRLz7naas0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:31 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:31 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 20/25] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Mon,  9 Jan 2023 15:31:11 +0200
Message-Id: <20230109133116.20801-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0108.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e4f839-7247-479f-4c8c-08daf2461975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdmvmqdhJSdvZ+lvXzPyi8ZYqvy6OSK8nJUH1LippEVRCmBURXVcFTVx1yoF88TzM8ZPG3KsDNEuTZKi6MUMRdcpZjkMIAGE4IcBZlEWUppN4dtwxfiNTY5t6/cuYxq38FeSfLQ/zbuOXBc39r/Wq53Np9Wb4Z50U7BWYg2gmSX0VhxrbP3UL6l2o/ZZEbcHdv7Bolw0OkNmWLzHTgkP0AwdBI/US+gJ30D9Pa/djHNniIPlXOpghagSfKGl7CFflwFNjksoEHCU9gcMyflWY5SOzhl07HYVctToqcph762aZsEuItm+JO8GG36YqHT190wF+5hCWWIDnIX2PaPJuGqbtReUrFnOQ/Nrpp5g1qDKb7/5DZqNTirpyvxgcVOfm4kO27WzFI6lUX8sCltPLDZxSuqM4WzDk/TQq8YpeSsjuvX05cTQkT85z4xHKbiibQeIxuXg10AuQyLR/XKhBKPGG42SnevPQ7tPlmVHfi/UCOn0Rp7J/OMFHeadZ3uzHxF8jB0jcjsHwhgeMtgrakS+EvqgpHDc2VaNNwdw91GN4hFzw0tY7TW+oCoL+zN/umCGZ+O3IQfquEIq8spQlgt5MKZuLV8YZVxlGFjlTv1NGlqfAn+xJhmiQUfRpQQAhSDadp6UWAiF02XY/VWgoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(7416002)(66476007)(66556008)(4326008)(8676002)(316002)(66946007)(54906003)(186003)(26005)(6512007)(2616005)(1076003)(38100700002)(83380400001)(86362001)(36756003)(107886003)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EjP1p9RFfGtSYfGs+gyPNrPSaWQMfq95JzP5eO/nbSIIjSffL1JztZ9NTZPY?=
 =?us-ascii?Q?zTI6QvA/VKgw695GHpqJMVal0hEe2vYRpQ09J+dMUJbZnpbX1P+I6s9bOk9e?=
 =?us-ascii?Q?Ao0i3+7GX9qrQ3oG4A0MO9tbjwkVSCaqVP6R0z9BaKqmjTeTN1pHouqo/DuR?=
 =?us-ascii?Q?ow98YnRN+/hrX2fxtfYhYKJ9w29C+ZTeYThCWXkMP80GrV8/44qe/kO1t4Ff?=
 =?us-ascii?Q?YLXV5hlB51h6htodGEb9Gye07KM71+hH563HWs37/NFssA8pPdgwJcQGEueQ?=
 =?us-ascii?Q?GZZQttYb8jioxD33w/YWu0LpBQKN4+PmHXmvBzkRPLTJqX3rvGG0IuNesae6?=
 =?us-ascii?Q?6L4Nuthkhj8LjGJgcyuuZnJY2hEyBT6OZAKFfb1ltRug6sKacc7A1hXx+Z93?=
 =?us-ascii?Q?8scs0RpxrvJ0qktQ3t9MIrHzEnjGn2/d61OvEyqCMM8zExPKqf9j/w393k/5?=
 =?us-ascii?Q?UnyCEbjQxVSxLhvTMHZyuE+GoCgTk3ak2KaXVLq4jW30WQPGtDD765wsS9aK?=
 =?us-ascii?Q?m3NZ2EnbYiIh1L3ftzpAq4onARezqtbqbt2W4ROFVUmDmZ1VbONPBUgo11k3?=
 =?us-ascii?Q?hJ3Z91N2/svUL3MOT1HUKIUHpufs3OnbkCy6RGxjuSJi7g8jkd7Opmhx34NQ?=
 =?us-ascii?Q?Rbcke1P0S25ODii1tEY1FOz5IZFcHtMtNtyuNgbT2KHc2DxRTVQf2SAWZVhK?=
 =?us-ascii?Q?e6mVpQbWgVcNiyJaw1tph3UFylNi5gDLYiMZMmjzrn/jkm1x2xIWhEbPlUVL?=
 =?us-ascii?Q?NqXOQRTCsmP8r1K9sWvvE8Vtlr8RsmjswQugnZC/MWjSjphnT6wX9Le0f325?=
 =?us-ascii?Q?JdddXZSXG9BcwvjB7Rwii+XZwiR03j64mgx9gwynpZeOMVIyxPTdLgoKuBjC?=
 =?us-ascii?Q?w0Neal4/jeTVgIJda+rtAFyhTr0aIdoxUWoobFAZcPEFRWcOd42BWKC2wx5X?=
 =?us-ascii?Q?XvNtlbvEu+SeJ0M3SfYaskr0vQrFral2L+nYxX9pemLhViC1IL2F9ShywLbq?=
 =?us-ascii?Q?vWTQb3k14LGTbMuahODZmSTifQiDTpOpgIzcVvTxglnrgXnSxvTGyJARohwP?=
 =?us-ascii?Q?o7gW6rRSmCccwuXxDy2F1vYm6149E64Zs49d4Q6LPRqjz8ze5AmlrL01qK3w?=
 =?us-ascii?Q?T+T7q4Nk5NAP0/mmcHFXaOGzg5E1SrZEwa4nbfN5GQ11mN9dD4k5KBHEOHcI?=
 =?us-ascii?Q?5kZSwk2af7radITc1ozmb34CBl6YygFZMGrb1O1TFeGiPeH1cAQLU6dp/zL1?=
 =?us-ascii?Q?SVKWJVJi6O9i902ULzY9lsP/P9zLKrZ12OVlDuzi2Pfv/gBYv7stpRsPiebu?=
 =?us-ascii?Q?PjmCNpSKUZewyHdZAXM4KGLNfh3enqy5kOwSFcUvwM8yTkG3WbKCCXqQIuNL?=
 =?us-ascii?Q?fA4ZRTO7FWeb0f76A6SHsiZOADp7b4DxaYnf4XcU18KSjDervQxDoBIWmQty?=
 =?us-ascii?Q?tHenlxujexnnnjy21PHpjfKmG2LUuT9OitDFz7+0O4R4oz+Ujh/mZdVKikuU?=
 =?us-ascii?Q?xBxnIy21FwsaYYqXFAMjaw4MuGGuIp4WRw6KKSUf4bxn3mEXT4slK+8d0h1z?=
 =?us-ascii?Q?PWtlkKvWa61Qq07GHVbIUJuI+Z3E5hLR+6pNPLCe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e4f839-7247-479f-4c8c-08daf2461975
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:31.6481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTHGINwWvDIn4LfOAj3CP1nNSTJX4HPsBeilFmIIAmRlyJyzvIPinpaLih/UZ+5cOq3NTY9JmTkeMTIggsfHew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 125 +++++++++++++++++-
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  25 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +
 4 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index a690a90a4c9c..2781d9eaf4b5 100644
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
index a1d143ea93cc..5611e18c4246 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,9 +20,123 @@ static const struct rhashtable_params rhash_queues = {
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
-			      struct ulp_ddp_limits *ulp_limits)
+			      struct ulp_ddp_limits *limits)
 {
 	return 0;
 }
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
index 7bf69e35af18..edfe60e641ae 100644
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

