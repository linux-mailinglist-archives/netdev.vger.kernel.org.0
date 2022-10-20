Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B29605C22
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJTKVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiJTKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:20:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6717A106A7C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZzGLsrRFV9gyrrdRFp4fXY+CW+8NtlOtLFCs+jRQzx/5GIetSczX/GTmkjPeaBGVb+7jRsYoaVwRoQjoPvdEGU0MyHRPevt+sUc4/PCGkvKb8R481ZkTeUnJg5ULn9JvbNC6bDb34xmGaDCIAc+MbbxiisI1Q8LA8gI1GVnCUhy2a3Ovs4pjLy7E4Vtipae/dgQc36sNwetxD+zvf1Tfr2VVeWVGZB+4xc1P5/dsTNaAdCYwZLv55gTNYsxrnGP60NGkWDCNNGV2d+uBV3i/7SFSoXThGAorP8YyL5jT+uZpRP+/qr3P567lSNq2FcLDukncOPy9d3evOSbnt4EZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+t3EbTTgywhBS037TC1HdbE4L5OhFYwIbf6yGRBFx2U=;
 b=lMQX1W0h6c9epL/hsOiPWFOWd78VHSXa0h9BAiLL+oVt0r3HzY0EVEDMQC/+SoCb13pcJTJdVpuJ+EroAyZppPkanPzUdvf4FmsNlT4Ibnf6d51nVgrSPTRXHSQo4rE4fB1AUmguemf/B9CNr/ioz+qIzL4fkcvyjiYw/4POGTzQt/K9DTe8ersO6xH980mpK0M+z7Tyz1h6G+11dRE99q8fSD5i/OV2qyncfbjFP4nZpCzwdoiU1JQ2OE6i4Cs0Nf/29sPjS4r7FLIMXNvPSXjz9bxXdtXVKvSOQlAXFfGsOHuvIVvRLzpJFisxS4WhSLmtHJ6JynmvK63+6dtt3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+t3EbTTgywhBS037TC1HdbE4L5OhFYwIbf6yGRBFx2U=;
 b=iXY0xBxsfo35eBmt3Ly64gxqDkscnh30B3ti/jqaqq7T4NxzdphKUldqnw1YSqugURjC1J2NjUEjkcZHzDnxMPXLSA5k8VJWbdU8nvJgwitMbJ5NBuAJxqcrzYfR/ZnRTu5mLKr9fEsa8Rqx3SCJI/3nBEUyGgYI7Z7rXEiloPm2iDFte1FQB2dizbFaUVjM0MohRoxlhrhHxtXrZ2n/qzteRiBVAFzTZ2Bpu8bMdhCTbtz2ghEhBeYJBtHT6gtuYrzyzIQLJWT0W9SwO4WnPx3MpB2GQGVEGPwPK09XB8/AD+8mWJydkoavbKxosbkr3VN4UngQmsdzWHmoTkQNYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:50 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:50 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 11/23] net/mlx5e: Rename from tls to transport static params
Date:   Thu, 20 Oct 2022 13:18:26 +0300
Message-Id: <20221020101838.2712846-12-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0469.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a6183e-4c88-41b3-eea9-08dab2849ee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwrenb1H4AjmRs6j/fz4kjp2B2DMqA0CAG0mi6PggcwvueD/IVdB1HntJIwGiEsj8fwrY6OR+3h83ZSq7VXh/OF0bLQxWQxko9qE6LkrLzt7U9SH36Sxj4gQ2hSIGgwp838k432nWvFD4ts258CJ5BH9WH2d8wOggFU3zRgsYFYgNZZ7PRNHXFK/2C3eORJsX85Nsd2dUft+O0ESUJynpOxwfuZAY0bMz1BJceBRJ84Hf9p2vdcjyQXW8uNln6ntdZ2neWFYevEmmn4skjDk7kVl5c9TO0CQifgnvB2JXAURUhTk/W5Va3UcABDATIssYxSWF21rHLLepKP0cRjHjv3GllGOpGk4d7b/mz10Xnzxo7nUGX/qHxrvtzcGoeF+3l4a1sytGl9uFrqeJza+41VlKNDVwvC0lraxsKAlhDfJ/TVn0YcF8uA8gk6jwr49aAF+Ck0uzBABh6y4fRZKAAwUPuWkUspTKfY0mkiXH2u2PX7dbHV+PZ+hXEN7IpN50iHgl1C/qqYIhup1rnVvy7V/VUY+KKy/G2soEZEnXYy1JxzZvLrI+hklopCoODl+pBTu3HhRUE/0BAb4bctPWbrSd2hyvG5/pJiV6wBcNOYWgUHe4vqShxkwzja92AmhHH1UgPl30egYKNVu/Jjh6rtDo85oAvShxtHr8MT9rkfK/HVLHeRym9abSbyGvbBY51EqPEC9bnnsqB1ugM3SeI1D8aaGxCrPgPzHHN8pX+nZNjNmHYwwCiHlrFtN+ysO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(30864003)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xMFGx/u9FeUXL+2tUTnlIphbawJ/SFufVZaMaLA+5zwhklzq+keurw3z8YF3?=
 =?us-ascii?Q?LWCQlwfgl2Zuw4+ZUAkYk6yND7Ihj2JQqVGbMlxEivMnt7OEznWO4NusbBV1?=
 =?us-ascii?Q?Y5+5HV1HtT57Nur0yqnE8pXnteFynZ/CkRsBESeKvlucTLjEoBkoIkmnxAZm?=
 =?us-ascii?Q?fVLHoEEjhbap2KLBGvcB0aVhkRGahR1802ah/7p4pUE8EgGezCo2ehypDrLL?=
 =?us-ascii?Q?UiPO0fGWWcb9bkDjpiQM8Z/DP9lF0zehVatnWFm0nKzeHh4S/vDZYt8oSOq1?=
 =?us-ascii?Q?wgvkd9VaeF82I00iHKF7PmqhJ28VUC5fOJNtuioRimeKPnE9sbP2Ql3bETDn?=
 =?us-ascii?Q?wOvQ1RNejiU0xPM2TdkYtzSvNMNLKRbWKkwTAlO3zHQ/ywYjRmDeQ1k27IVL?=
 =?us-ascii?Q?91LPnOpQNb1KMYZqZy8MbX9EwqpkiZEq3C9sF20iBmoZbkrGYU5ruWzYuJYH?=
 =?us-ascii?Q?m8oAEGyZdVdQM72Z8r6VdeqmtfcD00IfN2YXTHMHy7ljHRlcAmhVgYfvPbdB?=
 =?us-ascii?Q?dmmQcfs/9Q0lhOgGFWZu/X4ZYSYCeSWfk8k+Xc4BDxfACh/RvtxMeB1jFeSR?=
 =?us-ascii?Q?ZgZNinhHcTSowafAldaDNf4tPhehhwYxh8TeY2BqM4IKhuERv6SECSwGHY9c?=
 =?us-ascii?Q?eHyTAqViZC80mlmeZjF4vEQe2gOQiaNhNPHNeWijwd9nQdUNaq8d98RaKOrb?=
 =?us-ascii?Q?ssTK3+xAc7LkyEYLjXiAxl/6z/ALyKbGfySSWOLkOj88I/SwcFMHm/Z1JlaM?=
 =?us-ascii?Q?ukpkGhw78QvEODdvnuZGxnlM8J26xgsGh9CC21dYPWVC4I06QsDzxFVhFH1Y?=
 =?us-ascii?Q?wn45qQbtRhPRM599N+2ycSNf54CMHEsniTV5uK8AyUBs5uhXvTAaVVHKq7zG?=
 =?us-ascii?Q?OYm/eEgToXfk8I7/t3gm2NFjTjo3wRfgRC8hDzI/0QJ7O9qFJdzeGtjhX5AH?=
 =?us-ascii?Q?+XZD+eG/I3QMJW7CARovraEZVG0hb3mRrJ9d4uW5JDv0fS1Lynz1/hVUnirq?=
 =?us-ascii?Q?o0anZ5pAyL9W69fcEjnhodpt5fvAt73d257CDKa5gCLeP/gkG+pmxKbIpxK2?=
 =?us-ascii?Q?C9Un72eiFgrKAtjZXJ2iSCSBulpUrYXHrXS2KljHES02RtpHw87ZX7Roc9Ch?=
 =?us-ascii?Q?6sKHgqJsE2QLMFWYX3KznKQGYrEUOTmV4+iuaO0GGJPXBrz8pBsAP3Wm8hGT?=
 =?us-ascii?Q?wU6qprtyQLRF9ytZEuMje70b/0EiJG421MgB/Ekpb6hpFGsxbnN/8H3/OR8P?=
 =?us-ascii?Q?FV7el8WU/thsu3WpIt4zFnHG2BI1ZY/33ejECwXH9RsMHtN+pQdgGcRzw2J0?=
 =?us-ascii?Q?tYjaopV3oyzOM2dc+62zhP1JCBxsnSCah55hWZQ6SnKe4zlL2sfFgZ7vnMLl?=
 =?us-ascii?Q?nM4ScuPTZvy8IA4WZDMlyeRMgqeI33VtIQrmFLLFwSjoxD7yEtL9zMSywxwB?=
 =?us-ascii?Q?Pnz7r+KuuUWUfWJIfEJ//0gPyhrJw0vouhWyU9ly6KXyTynhCnJ3qpEWvCKE?=
 =?us-ascii?Q?ZRqBE4Lgw9Jdx8YbQxYW6mlEMMg5IeR+uphIUjNUTTqg+2Sg7/7DQgkRtH+0?=
 =?us-ascii?Q?fBJXrMh/FbvzTl5nrlyNFOSGqPjKO9vU1RiB7XUO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a6183e-4c88-41b3-eea9-08dab2849ee8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:49.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: If2OQNSxKnT9E9IKXUxXJgjbqQ4BOiRJcnc8z6241tCTkpDC5xfHTErldEZqly95E4WTMMuXWJLij9tj6Ogibg==
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

The static params structure is used in TLS but also in other
transports we're offloading like nvmeotcp:

- Rename the relevant structures/fields
- Create common file for appropriate transports
- Apply changes in the TLS code

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mlx5/core/en_accel/common_utils.h         | 32 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls.c        |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  6 ++--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  8 ++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   | 36 ++++++++-----------
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  | 17 ++-------
 include/linux/mlx5/device.h                   |  8 ++---
 include/linux/mlx5/mlx5_ifc.h                 |  8 +++--
 8 files changed, 67 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
new file mode 100644
index 000000000000..0353389a0b60
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_COMMON_UTILS_H__
+#define __MLX5E_COMMON_UTILS_H__
+
+#include "en.h"
+
+struct mlx5e_set_transport_static_params_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_umr_ctrl_seg uctrl;
+	struct mlx5_mkey_seg mkc;
+	struct mlx5_wqe_transport_static_params_seg params;
+};
+
+/* macros for transport_static_params handling */
+#define MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_set_transport_static_params_wqe), MLX5_SEND_WQE_BB))
+
+#define MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_transport_static_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_transport_static_params_wqe)))
+
+#define MLX5E_TRANSPORT_STATIC_PARAMS_WQE_SZ \
+	(sizeof(struct mlx5e_set_transport_static_params_wqe))
+
+#define MLX5E_TRANSPORT_STATIC_PARAMS_DS_CNT \
+	(DIV_ROUND_UP(MLX5E_TRANSPORT_STATIC_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS))
+
+#define MLX5E_TRANSPORT_STATIC_PARAMS_OCTWORD_SIZE \
+	(MLX5_ST_SZ_BYTES(transport_static_params) / MLX5_SEND_WQE_DS)
+
+#endif /* __MLX5E_COMMON_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index da2184c94203..26695e74a475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -100,7 +100,7 @@ bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
 		return false;
 
 	/* Check the possibility to post the required ICOSQ WQEs. */
-	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS))
+	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS))
 		return false;
 	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS))
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 3e54834747ce..8551ddd500b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -136,16 +136,16 @@ static struct mlx5_wqe_ctrl_seg *
 post_static_params(struct mlx5e_icosq *sq,
 		   struct mlx5e_ktls_offload_context_rx *priv_rx)
 {
-	struct mlx5e_set_tls_static_params_wqe *wqe;
+	struct mlx5e_set_transport_static_params_wqe *wqe;
 	struct mlx5e_icosq_wqe_info wi;
 	u16 pi, num_wqebbs;
 
-	num_wqebbs = MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS;
+	num_wqebbs = MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS;
 	if (unlikely(!mlx5e_icosq_can_post_wqe(sq, num_wqebbs)))
 		return ERR_PTR(-ENOSPC);
 
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
-	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
+	wqe = MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
 				       mlx5e_tir_get_tirn(&priv_rx->tir),
 				       priv_rx->key_id, priv_rx->resync.seq, false,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 2e0335246967..a319e52636b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -32,7 +32,7 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 
 	num_dumps = mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
 
-	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS);
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
 	stop_room += num_dumps * mlx5e_stop_room_for_wqe(mdev, MLX5E_KTLS_DUMP_WQEBBS);
 	stop_room += 1; /* fence nop */
@@ -556,12 +556,12 @@ post_static_params(struct mlx5e_txqsq *sq,
 		   struct mlx5e_ktls_offload_context_tx *priv_tx,
 		   bool fence)
 {
-	struct mlx5e_set_tls_static_params_wqe *wqe;
+	struct mlx5e_set_transport_static_params_wqe *wqe;
 	u16 pi, num_wqebbs;
 
-	num_wqebbs = MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS;
+	num_wqebbs = MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS;
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
+	wqe = MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_tx->crypto_info,
 				       priv_tx->tisn, priv_tx->key_id, 0, fence,
 				       TLS_OFFLOAD_CTX_DIR_TX);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
index 570a912dd6fa..8abea6fe6cd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.c
@@ -8,10 +8,6 @@ enum {
 	MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2 = 0x2,
 };
 
-enum {
-	MLX5E_ENCRYPTION_STANDARD_TLS = 0x1,
-};
-
 #define EXTRACT_INFO_FIELDS do { \
 	salt    = info->salt;    \
 	rec_seq = info->rec_seq; \
@@ -20,7 +16,7 @@ enum {
 } while (0)
 
 static void
-fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
+fill_static_params(struct mlx5_wqe_transport_static_params_seg *params,
 		   union mlx5e_crypto_info *crypto_info,
 		   u32 key_id, u32 resync_tcp_sn)
 {
@@ -53,25 +49,25 @@ fill_static_params(struct mlx5_wqe_tls_static_params_seg *params,
 		return;
 	}
 
-	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
-	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
+	gcm_iv      = MLX5_ADDR_OF(transport_static_params, ctx, gcm_iv);
+	initial_rn  = MLX5_ADDR_OF(transport_static_params, ctx, initial_record_number);
 
 	memcpy(gcm_iv,      salt,    salt_sz);
 	memcpy(initial_rn,  rec_seq, rec_seq_sz);
 
 	tls_version = MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2;
 
-	MLX5_SET(tls_static_params, ctx, tls_version, tls_version);
-	MLX5_SET(tls_static_params, ctx, const_1, 1);
-	MLX5_SET(tls_static_params, ctx, const_2, 2);
-	MLX5_SET(tls_static_params, ctx, encryption_standard,
-		 MLX5E_ENCRYPTION_STANDARD_TLS);
-	MLX5_SET(tls_static_params, ctx, resync_tcp_sn, resync_tcp_sn);
-	MLX5_SET(tls_static_params, ctx, dek_index, key_id);
+	MLX5_SET(transport_static_params, ctx, tls_version, tls_version);
+	MLX5_SET(transport_static_params, ctx, const_1, 1);
+	MLX5_SET(transport_static_params, ctx, const_2, 2);
+	MLX5_SET(transport_static_params, ctx, acc_type,
+		 MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS);
+	MLX5_SET(transport_static_params, ctx, resync_tcp_sn, resync_tcp_sn);
+	MLX5_SET(transport_static_params, ctx, dek_index, key_id);
 }
 
 void
-mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
+mlx5e_ktls_build_static_params(struct mlx5e_set_transport_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
 			       union mlx5e_crypto_info *crypto_info,
 			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
@@ -80,19 +76,17 @@ mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
 	struct mlx5_wqe_ctrl_seg     *cseg  = &wqe->ctrl;
 	u8 opmod = direction == TLS_OFFLOAD_CTX_DIR_TX ?
-		MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS :
-		MLX5_OPC_MOD_TLS_TIR_STATIC_PARAMS;
-
-#define STATIC_PARAMS_DS_CNT DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS)
+		MLX5_OPC_MOD_TRANSPORT_TIS_STATIC_PARAMS :
+		MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
 
 	cseg->opmod_idx_opcode = cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR | (opmod << 24));
 	cseg->qpn_ds           = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
-					     STATIC_PARAMS_DS_CNT);
+					     MLX5E_TRANSPORT_STATIC_PARAMS_DS_CNT);
 	cseg->fm_ce_se         = fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 	cseg->tis_tir_num      = cpu_to_be32(tis_tir_num << 8);
 
 	ucseg->flags = MLX5_UMR_INLINE;
-	ucseg->bsf_octowords = cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) / 16);
+	ucseg->bsf_octowords = cpu_to_be16(MLX5E_TRANSPORT_STATIC_PARAMS_OCTWORD_SIZE);
 
 	fill_static_params(&wqe->params, crypto_info, key_id, resync_tcp_sn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
index 3d79cd379890..5e2d186778aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_utils.h
@@ -6,6 +6,7 @@
 
 #include <net/tls.h>
 #include "en.h"
+#include "en_accel/common_utils.h"
 
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     = 0,
@@ -33,13 +34,6 @@ union mlx5e_crypto_info {
 	struct tls12_crypto_info_aes_gcm_256 crypto_info_256;
 };
 
-struct mlx5e_set_tls_static_params_wqe {
-	struct mlx5_wqe_ctrl_seg ctrl;
-	struct mlx5_wqe_umr_ctrl_seg uctrl;
-	struct mlx5_mkey_seg mkc;
-	struct mlx5_wqe_tls_static_params_seg params;
-};
-
 struct mlx5e_set_tls_progress_params_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_tls_progress_params_seg params;
@@ -50,19 +44,12 @@ struct mlx5e_get_tls_progress_params_wqe {
 	struct mlx5_seg_get_psv  psv;
 };
 
-#define MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS \
-	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_static_params_wqe), MLX5_SEND_WQE_BB))
-
 #define MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS \
 	(DIV_ROUND_UP(sizeof(struct mlx5e_set_tls_progress_params_wqe), MLX5_SEND_WQE_BB))
 
 #define MLX5E_KTLS_GET_PROGRESS_WQEBBS \
 	(DIV_ROUND_UP(sizeof(struct mlx5e_get_tls_progress_params_wqe), MLX5_SEND_WQE_BB))
 
-#define MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi) \
-	((struct mlx5e_set_tls_static_params_wqe *)\
-	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_static_params_wqe)))
-
 #define MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi) \
 	((struct mlx5e_set_tls_progress_params_wqe *)\
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_tls_progress_params_wqe)))
@@ -76,7 +63,7 @@ struct mlx5e_get_tls_progress_params_wqe {
 	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_dump_wqe)))
 
 void
-mlx5e_ktls_build_static_params(struct mlx5e_set_tls_static_params_wqe *wqe,
+mlx5e_ktls_build_static_params(struct mlx5e_set_transport_static_params_wqe *wqe,
 			       u16 pc, u32 sqn,
 			       union mlx5e_crypto_info *crypto_info,
 			       u32 tis_tir_num, u32 key_id, u32 resync_tcp_sn,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1ff91cb79ded..9daf024fdd0c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -445,8 +445,8 @@ enum {
 };
 
 enum {
-	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS = 0x1,
-	MLX5_OPC_MOD_TLS_TIR_STATIC_PARAMS = 0x2,
+	MLX5_OPC_MOD_TRANSPORT_TIS_STATIC_PARAMS = 0x1,
+	MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS = 0x2,
 };
 
 enum {
@@ -454,8 +454,8 @@ enum {
 	MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS = 0x2,
 };
 
-struct mlx5_wqe_tls_static_params_seg {
-	u8     ctx[MLX5_ST_SZ_BYTES(tls_static_params)];
+struct mlx5_wqe_transport_static_params_seg {
+	u8     ctx[MLX5_ST_SZ_BYTES(transport_static_params)];
 };
 
 struct mlx5_wqe_tls_progress_params_seg {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..283a4e5c283b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11817,12 +11817,16 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC = 0x4,
 };
 
-struct mlx5_ifc_tls_static_params_bits {
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               = 0x1,
+};
+
+struct mlx5_ifc_transport_static_params_bits {
 	u8         const_2[0x2];
 	u8         tls_version[0x4];
 	u8         const_1[0x2];
 	u8         reserved_at_8[0x14];
-	u8         encryption_standard[0x4];
+	u8         acc_type[0x4];
 
 	u8         reserved_at_20[0x20];
 
-- 
2.31.1

