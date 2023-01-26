Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B595667D145
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjAZQYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjAZQYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:24:11 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817F55256
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:23:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3KsT2Lhl8gFStJEEecaZL9DUr2W26HjeWDCiiHsIHv5q3t8nIKXmyyTQ1bt57exvqYlMwg02X+TlpViVmpq5+t24f58d/t2I14WCtJ1vzIxR9XDqKMHH/oHxEtWzqYcsmCKE5Bk63/G9Wz5fFLm4FHN+rSL9fhbEErd7AWdIrSnbzugkSkbDHNea7Uv2iF/OXlYrpuVR8qdM7m1dgtYy7R7kXYX8CJHAoBuKIny0xbGo6vIkljtQe+BENkdZ6ORMDqsJLVIDvuxfN/Eo5kT+pSevfPYAz6XVjT8GWTFzW+ybYTDrdv4mpq+ejEhUAzKK0OfeA4oz05Guvs4b0Rd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5uj1eog/VGxv+CjUJw73AGI/7MLIJ8p4sZXAPqueIs=;
 b=JZ6zPxFm/mRV2ppp2gFslOsa0Z8+2bjJZ0dW3ISVEtR/oaN9vIVe9RbTm0ZeNGEhKgespZNeou1TL2o9592IfDwpv5IjCjEannm2Eo211Duv0UUW/5Fuz0lvj0b3rcUV4+YVOxMUMyOKvEc3NlD/i3LV77Y/fWAE8N+npyx/06CjWrhTb2AyuMhXNcw5e31AR0CDKFP+hmu7i7kyQz0EGI53sWT1BHtVMVk9FeMvDcwm4SoR/hfISoMzvYuTpvnF0u+TIk+lF4lII3Ng6idKSBseKSx5e0UVqivntYuRbeLiAH1m8pdyN/kpXKAYKHPu0zNPrWPK8NabMxRo8HgwFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5uj1eog/VGxv+CjUJw73AGI/7MLIJ8p4sZXAPqueIs=;
 b=VnxyXpnrVquA77/R2y4zWNGLYkoK5DFUycILiJhs39RPWXK8TmUc1p6ACXzjI8OMc8J5blSjkZWcz5wt3ulE1A3O2xACs7aeTxmuuNzMwP1/+Krp6OJf7l2ObRUtpanya564x0Pc4K0VT7cKlgjlJxEOtlTPWtvDdH7ln53tHEFtR2l1+TsiaQ2/igTKbOKf7uqXe0nxVD6kR1Vb3EOAYyHxb0c4VtyAwjji1BSlFdbZEeS1pZDPZ3UsWoOgedI1C6kcRdHxSR1QKDweWHuE2qHQGUObz4drkMC9nDXJx5tW9s+UXFA0RCFbGwmMTq55Xr5cshmaAYk/z+BXGF5XFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:23:09 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:09 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 13/25] net/mlx5e: Rename from tls to transport static params
Date:   Thu, 26 Jan 2023 18:21:24 +0200
Message-Id: <20230126162136.13003-14-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::20) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 4def9b95-55db-42c5-59d0-08daffb99ca5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lB6DzwsrSmsJgKZ3tny0fgEI1XghqrHpSqW4QTFJk/Zxg8woGZJoIm46k6R/EUafkc5omA+8Anbp+y/nnVmqRfrCgGD+nH10MEiS0jkyTneunQ9FlfAHPJsNkFF8LbcEGMIEL0n7YpLNsjkZA75vMBs0lYvZo/tU78sLLEht5JyoVmjWxCqsBtuplcPqfDfQzLYHWM/O3VpwoE1x8R9byzZpsiITxiJlpVvzW0ZJIVpAcpGyxLmo2GYDYPR0AyrXwiNBsl6tPsm9x3Xxnhr8eK27Ff+DBrIef6uv1kaqS2tUPl6me1pJ4RvYKiMkxcfXvRINdKvjMKimc/O1mM/9PzjHFdr5AHoI+NSSY16vsHIRjP6Hd6+UpK2xf3M9DZ1YrndZuM4aEDVoXKYgKEHJJ2csF0QbFfvr9igEYzGdECA2EK9+PVJIa1hP2MpQs19HO6IEKeUiUojMjI6pO3U1Qn2EJSTEZBVVEfPoJcFaGEiLld4p/J8DVPx5SLNV6+m8p2W4xsNYRfV2mupdZ0ya0SplqEkxNO1aQHQTtqZ/5Qm2U0jnyb9pXsJ5MyMZF9crgV4JbaeOtgdfa3y2zEIMBI2Ux0jOJ8L5ypSSz13CtW7MeBhu0tI/dLrNfh28Z/uomlIk5IyeTSSwwJ7IwW0VyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(36756003)(8676002)(316002)(478600001)(6666004)(107886003)(1076003)(6506007)(6486002)(5660300002)(30864003)(7416002)(66946007)(2906002)(4326008)(66556008)(66476007)(8936002)(41300700001)(38100700002)(6512007)(26005)(2616005)(83380400001)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UxLusY2h5ORjUazWvTvGX5nzh6pYHNK6MWVnGASQQUyXIz7OG73es18ZxrO0?=
 =?us-ascii?Q?oIsvtmL4gSnMnyYgMVEe5xiPvs71NNKkU/jGh94o9ynm+ci2reiHXo4ZUSLE?=
 =?us-ascii?Q?RdCXpJT3swHTmTKvCc9WGeFn6qM+zWLKxBIPgPN7SgnDsdtJ0vCj4U0NvyAd?=
 =?us-ascii?Q?SyoBesB6j/UJ5/kk4jX55u719p+S/0kpdYY1c+QfUnfFFECAkICSJzik2iT6?=
 =?us-ascii?Q?8xGm1H9BfJ/Ve+dcYMM4EEXbt5vDqZtsA/uryraVCtaAGi7k8wC2q67g/lbC?=
 =?us-ascii?Q?2Ujxp3rfqYUqY1d1B2WuxzmIM2L5i7+OaalQaup9Y8EN5bQt47HyDODJf8Bl?=
 =?us-ascii?Q?/aI9eoxJlFOPwKPht0F35j85+5tg9vcoALMnMGc3DE2QSPEFN6ksWBs4w8xn?=
 =?us-ascii?Q?6lLG36n/Y2B12vcEDSaMm2Bq0VRnPX3GWLmm/S5bqZt7CfAXj5f3BJkGijp8?=
 =?us-ascii?Q?II7ZotBFBhrUatJvihfavZEJc1c+5dgvISvBkyqm0zZOtkfdXk4NE0lBCojB?=
 =?us-ascii?Q?S83SRJZGEjhs7JaYt8A7zgOQyTvjiO/WzMta3atTkSRUm1cnnQj9h4DyZydf?=
 =?us-ascii?Q?LRCJ6ss9CWZGpirrwnTUdHWn4qftez7TW7++lD5LmmqvRuWHYkPupO1QUE7l?=
 =?us-ascii?Q?bLidnz+wCmj6nhfLZ2narGPpKWbZDejH3Dyebz2NMiKBt0PLFcoqBPy5k8Ba?=
 =?us-ascii?Q?RRWKHqxn2VkcRAuhhHwe6PHGf99d9e9rAG0O+MS1AahC3h4SR3ZinglHWELu?=
 =?us-ascii?Q?HCMcblpSTKrZUsfFaJeErxkYHPrmpc0zHrGrYQeSZOVDnfVxLPtmRa7jLX4g?=
 =?us-ascii?Q?dNqBU4eL+zQJg09qbQVTtE7X1OAa776XlQry3Ay108WjU3RXs7qTt10UxZ6V?=
 =?us-ascii?Q?8DCPl6t7AI4ioJtm0fN6N3LXgzTj7er6vmPniyYJoU5je3H9bxDOnnwJRJFQ?=
 =?us-ascii?Q?xO1MA2IJDwwqQShu+fOhZDV0IHBr2pla8GWldJJkDnj+Rq82O1KUL7YtH30m?=
 =?us-ascii?Q?eP4xeqETrWE8TdOZmWEoh9mXwJcqSSpGjWILyJ6uCuPRCSZfD8VmV65jnizK?=
 =?us-ascii?Q?CEFY719RIABHsbsQ4MCWzN1X0ojEKWmyFVsIVtPtyfDx1z0fjTTvfMK3FHoa?=
 =?us-ascii?Q?ymWM2ACQyVqbBCNGSF+GHuCY11OnlMg9vSmWB7IjooSTg3oH0XLkDM6h4Xta?=
 =?us-ascii?Q?dFuRObXoWMuqH9IC2pNGHfR9jRNhTq4hqaJ/6CC3oerofC+8uANaW3JpI50y?=
 =?us-ascii?Q?hZkFoKD6lOv1caPhHiBy4goLCDFymTgABOUPlZTj2xHlcGXhUdU1Vjvd6vNg?=
 =?us-ascii?Q?12Il+TFqkk8hnryhsdBw3jT7t1lIPBSoNMjQbZbqEPtPv0Qr35HyLraP9ssm?=
 =?us-ascii?Q?ujVVpStQEZO/7+cyvw6nmh0zxlW9+h4pdGRYNQ5u9bh7EVtxG9SNnpIoHQyq?=
 =?us-ascii?Q?CmxP0MDGYL+kXwV0GUFy1mlc+6YLehdJRSXLO7iGqgqKENsemlI8G/dhPqMO?=
 =?us-ascii?Q?kBUE+iRSIEbh1c7gMdR4Eami7eAvt7RNklANJCw+cbCj+lXlbs336Pnz2trN?=
 =?us-ascii?Q?AnYwT4l2g2hc6RM9RtRO/++v++xVBTciRkzbpCjG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4def9b95-55db-42c5-59d0-08daffb99ca5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:09.1429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71O6RNer7yoY4uK6Xje9ijp/n4m2WA9g1Aaca1FOTayH31oEI9/cvTKO3lxFkcIMTjM5GxmPvDmeDdYxEITpGg==
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
index 000000000000..efdf48125848
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. */
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
index eb5b09f81dec..f64523f0932f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -101,7 +101,7 @@ bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
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
index 6db27062b765..e127f53e19ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -33,7 +33,7 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 
 	num_dumps = mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
 
-	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS);
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
 	stop_room += num_dumps * mlx5e_stop_room_for_wqe(mdev, MLX5E_KTLS_DUMP_WQEBBS);
 	stop_room += 1; /* fence nop */
@@ -544,12 +544,12 @@ post_static_params(struct mlx5e_txqsq *sq,
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
index 29d4b201c7b2..b50b15dbf3c1 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -444,8 +444,8 @@ enum {
 };
 
 enum {
-	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS = 0x1,
-	MLX5_OPC_MOD_TLS_TIR_STATIC_PARAMS = 0x2,
+	MLX5_OPC_MOD_TRANSPORT_TIS_STATIC_PARAMS = 0x1,
+	MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS = 0x2,
 };
 
 enum {
@@ -453,8 +453,8 @@ enum {
 	MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS = 0x2,
 };
 
-struct mlx5_wqe_tls_static_params_seg {
-	u8     ctx[MLX5_ST_SZ_BYTES(tls_static_params)];
+struct mlx5_wqe_transport_static_params_seg {
+	u8     ctx[MLX5_ST_SZ_BYTES(transport_static_params)];
 };
 
 struct mlx5_wqe_tls_progress_params_seg {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0b102c651fe2..33e09dcb2b1a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12001,12 +12001,16 @@ enum {
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

