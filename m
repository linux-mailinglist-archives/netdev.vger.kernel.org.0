Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B249572CE7
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiGMFRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiGMFRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:17:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08770D64C5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrB1LCvXC9eEDLvAY/DilZnSnqVpYQeCEFHVnCo+uDuRyMoWPjcKphaGULpLPdRn0PjJ2i+JuhjRI0aG1VXPJC/cU5NSr5ilv7jHqpsc5s4elgTh2wpbkO+H+ctlUWaWPNfdy2c47F3KJkkDHF7p1k6dTKjcFMAycHocS2bVf029UrlVPzWtzR38RBwdkjTTIjviNm15rQsWBbbNFnQM1X4c9A6xtRspUZITk+nJd4YJ2Ynker5X/UVtXHh0PA7EhWq4Xm09qPeRc1qxOjRG7JfB1XlYE0x/+VOa9uJYJnR/Jo0dBK9Z7swCTaZDht1nzATBc+qbOJJSA9Odz4jlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRu8az/M2yr8iFIuyEXTDgUhdlGXbAcE0XScuwYDecU=;
 b=nA/yqtCZplUM3s9Hx6CKqmOjubT75BgssxHm5UhNaghrJBJ8TZQMEo8b414/1URKNUFBlSQcGftl9fUMnaeDCgNAkI8KFwII+GFL9iGGaS2PH/0D8JdfELkurJqrLvD8NqiJ1LTYbgd/8NW11q2gfdU15YZicKKlWu2fAQT2WoMapMgGCwOjyCEJwNbKsoejCpE/sGOFaiUD1iH8lia3SbjX1P7gYwa9k7bqY7uELXBHaVy73Bkq9c59b7qPnGFsQUtnQTHk3IDtz3HRZ4r4GqE2w45Iji3w8ajDe9aq8YoacvMVlFuTsmVEt1u0GBlTi4nIYSvLqFqbRVhbPTcWCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRu8az/M2yr8iFIuyEXTDgUhdlGXbAcE0XScuwYDecU=;
 b=qH6H+tCfzXTmkvRJWzaOY0H+8NWv2zv1d+fFGxHy5i4KaCcxe+FCocah9ZKUtEDzVufYb9OLiLvfmUpRxUPAquPgFdKtIGhAsoOCgDCQc2/ijuSvtlGAfvN9Q5d0W1XW+utnA3GYOnVg35WyxxhUtw+7IA6Fw8dlpWKYwp9ks21bI1aTgM6T/PTQNiy0j2En8fVx9FvrqXWsXaosTWXKz81vx9QrwGKA01vA8C1SOXOEijgH3oPbQ5QMVAMO8uRyg00LKljtzT/3gOwiivDgdSz9AUTLWzuRE4ggP80M3PKmL85bpf+P0UsJWzkGmS212N/f6kHIeLyGWZRSyYa54A==
Received: from MW4PR03CA0240.namprd03.prod.outlook.com (2603:10b6:303:b9::35)
 by DM6PR12MB3627.namprd12.prod.outlook.com (2603:10b6:5:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 13 Jul
 2022 05:17:00 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::60) by MW4PR03CA0240.outlook.office365.com
 (2603:10b6:303:b9::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16 via Frontend
 Transport; Wed, 13 Jul 2022 05:17:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 05:16:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:57 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:55 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 6/6] net/mlx5e: kTLS, Dynamically re-size TX recycling pool
Date:   Wed, 13 Jul 2022 08:16:03 +0300
Message-ID: <20220713051603.14014-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220713051603.14014-1-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a26c40e5-1b64-4037-86e2-08da648ee9ce
X-MS-TrafficTypeDiagnostic: DM6PR12MB3627:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAB5kqBEKeTUK/1jHpsjBzrlI12r3tIHTwn4ay6VobFVGqC7jVvjG6T/yU6VN0LwC17qFKUA4s+Rprf7iHyRhf63afKgRiEn8TuIY60t11Mdf6WdTBNnYMCPYt5rHClaqqqUdgyGc4PbfdCvg2V1v+3uM5ocGp9LIdtPu6n+2nwBk2XkRlFIGUde2/efyM9LDJA2sRdO+kzeYj8AJgBfjRQ4cdcCEIB2W24kuPqUaKBXj4Y6AMeJZb7f7GY80H2vQLoyu9IbDE2X7LMU8RgQjGzRINZ5tUa3TNKK2AuZTk9nIL/nqouRpF1I6JFwC7vYBRDu2ohyEyEHnHtxSLAoBrhv9O/aLwpelAnO4YnVyQuKf3epk4/n2XVTA4g9+ckRaENvgMnz6kJYVnp7lNTOcNmX9xCHQ0xGlut79UfRzxcDJJCoWKeaim2KrizBD2nnXMQR+BCYNkqk0eH/LeQgdWpiLIZWwPL1SIcwkKXpA8f3opubNZLZ73xqz+tIsQtHmpUM0Fs9fJr9Ironi0bu8fUK7Xr+8bIjdo15NxLV49MLeD/DKU9e9PSlDS3ycBni0F2lgqXzJIivDvchBt2FzAWvHyEKEFZTngplZ97VEtjy+X9dbZUW7XKpW9QcLFtucmdXFotuJleh5jyI3oXCWjBq9Z+HWPcksx0qjQ63DhHmVCnttQhVMQUdXqT6YU3nyuZtiu9N4qyyMA8bMuaNhK+muMbewKfGZs4iCUqiS7rqf39CLwaJfX4krQ7jLHNreM/DFTeBuyFfpaoNuBYINRQY5bIlKJ0qkKen1O9mnT/ejbNGnBjelDHotkBe6gUsW5bUwWRyD+DQ3fqbJEpiVQt96ky0unyNdGCnvNxYAY8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39860400002)(376002)(40470700004)(36840700001)(46966006)(82740400003)(8676002)(30864003)(316002)(6666004)(47076005)(426003)(1076003)(336012)(82310400005)(4326008)(186003)(356005)(70586007)(107886003)(26005)(110136005)(7696005)(86362001)(70206006)(54906003)(2616005)(40460700003)(40480700001)(2906002)(36756003)(41300700001)(478600001)(36860700001)(83380400001)(8936002)(81166007)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:59.5543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26c40e5-1b64-4037-86e2-08da648ee9ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3627
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the TLS TX recycle pool be more flexible in size, by continuously
and dynamically allocating and releasing HW resources in response to
changes in the connections rate and load.

Allocate and release pool entries in bulks (16). Use a workqueue to
release/allocate in the background. Allocate a new bulk when the pool
size goes lower than the low threshold (1K). Symmetric operation is done
when the pool size gets greater than the upper threshold (4K).

Every idle pool entry holds: 1 TIS, 1 DEK (HW resources), in addition to
~100 bytes in host memory.

Start with an empty pool to minimize memory and HW resources waste for
non-TLS users that have the device-offload TLS enabled.

Upon a new request, in case the pool is empty, do not wait for a whole bulk
allocation to complete.  Instead, trigger an instant allocation of a single
resource to reduce latency.

Performance tests:
Before: 11,684 CPS
After:  16,556 CPS

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 315 ++++++++++++++++--
 1 file changed, 289 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 24d1288e906a..fc8860012a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -56,6 +56,36 @@ static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 	return mlx5_core_create_tis(mdev, in, tisn);
 }
 
+static int mlx5e_ktls_create_tis_cb(struct mlx5_core_dev *mdev,
+				    struct mlx5_async_ctx *async_ctx,
+				    u32 *out, int outlen,
+				    mlx5_async_cbk_t callback,
+				    struct mlx5_async_work *context)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
+
+	mlx5e_ktls_set_tisc(mdev, MLX5_ADDR_OF(create_tis_in, in, ctx));
+	MLX5_SET(create_tis_in, in, opcode, MLX5_CMD_OP_CREATE_TIS);
+
+	return mlx5_cmd_exec_cb(async_ctx, in, sizeof(in),
+				out, outlen, callback, context);
+}
+
+static int mlx5e_ktls_destroy_tis_cb(struct mlx5_core_dev *mdev, u32 tisn,
+				     struct mlx5_async_ctx *async_ctx,
+				     u32 *out, int outlen,
+				     mlx5_async_cbk_t callback,
+				     struct mlx5_async_work *context)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)] = {};
+
+	MLX5_SET(destroy_tis_in, in, opcode, MLX5_CMD_OP_DESTROY_TIS);
+	MLX5_SET(destroy_tis_in, in, tisn, tisn);
+
+	return mlx5_cmd_exec_cb(async_ctx, in, sizeof(in),
+				out, outlen, callback, context);
+}
+
 struct mlx5e_ktls_offload_context_tx {
 	/* fast path */
 	u32 expected_seq;
@@ -68,6 +98,7 @@ struct mlx5e_ktls_offload_context_tx {
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_tls_sw_stats *sw_stats;
 	u32 key_id;
+	u8 create_err : 1;
 };
 
 static void
@@ -92,8 +123,81 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 	return *ctx;
 }
 
+/* struct for callback API management */
+struct mlx5e_async_ctx {
+	struct mlx5_async_work context;
+	struct mlx5_async_ctx async_ctx;
+	struct work_struct work;
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct completion complete;
+	int err;
+	union {
+		u32 out_create[MLX5_ST_SZ_DW(create_tis_out)];
+		u32 out_destroy[MLX5_ST_SZ_DW(destroy_tis_out)];
+	};
+};
+
+static struct mlx5e_async_ctx *mlx5e_bulk_async_init(struct mlx5_core_dev *mdev, int n)
+{
+	struct mlx5e_async_ctx *bulk_async;
+	int i;
+
+	bulk_async = kvcalloc(n, sizeof(struct mlx5e_async_ctx), GFP_KERNEL);
+	if (!bulk_async)
+		return NULL;
+
+	for (i = 0; i < n; i++) {
+		struct mlx5e_async_ctx *async = &bulk_async[i];
+
+		mlx5_cmd_init_async_ctx(mdev, &async->async_ctx);
+		init_completion(&async->complete);
+	}
+
+	return bulk_async;
+}
+
+static void mlx5e_bulk_async_cleanup(struct mlx5e_async_ctx *bulk_async, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		struct mlx5e_async_ctx *async = &bulk_async[i];
+
+		mlx5_cmd_cleanup_async_ctx(&async->async_ctx);
+	}
+	kvfree(bulk_async);
+}
+
+static void create_tis_callback(int status, struct mlx5_async_work *context)
+{
+	struct mlx5e_async_ctx *async =
+		container_of(context, struct mlx5e_async_ctx, context);
+	struct mlx5e_ktls_offload_context_tx *priv_tx = async->priv_tx;
+
+	if (status) {
+		async->err = status;
+		priv_tx->create_err = 1;
+		goto out;
+	}
+
+	priv_tx->tisn = MLX5_GET(create_tis_out, async->out_create, tisn);
+out:
+	complete(&async->complete);
+}
+
+static void destroy_tis_callback(int status, struct mlx5_async_work *context)
+{
+	struct mlx5e_async_ctx *async =
+		container_of(context, struct mlx5e_async_ctx, context);
+	struct mlx5e_ktls_offload_context_tx *priv_tx = async->priv_tx;
+
+	complete(&async->complete);
+	kfree(priv_tx);
+}
+
 static struct mlx5e_ktls_offload_context_tx *
-mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw_stats)
+mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw_stats,
+		       struct mlx5e_async_ctx *async)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	int err;
@@ -105,76 +209,229 @@ mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw
 	priv_tx->mdev = mdev;
 	priv_tx->sw_stats = sw_stats;
 
-	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
-	if (err) {
-		kfree(priv_tx);
-		return ERR_PTR(err);
+	if (!async) {
+		err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
+		if (err)
+			goto err_out;
+	} else {
+		async->priv_tx = priv_tx;
+		err = mlx5e_ktls_create_tis_cb(mdev, &async->async_ctx,
+					       async->out_create, sizeof(async->out_create),
+					       create_tis_callback, &async->context);
+		if (err)
+			goto err_out;
 	}
 
 	return priv_tx;
+
+err_out:
+	kfree(priv_tx);
+	return ERR_PTR(err);
 }
 
-static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv_tx)
+static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv_tx,
+				      struct mlx5e_async_ctx *async)
 {
-	mlx5e_destroy_tis(priv_tx->mdev, priv_tx->tisn);
-	kfree(priv_tx);
+	if (priv_tx->create_err) {
+		complete(&async->complete);
+		kfree(priv_tx);
+		return;
+	}
+	async->priv_tx = priv_tx;
+	mlx5e_ktls_destroy_tis_cb(priv_tx->mdev, priv_tx->tisn,
+				  &async->async_ctx,
+				  async->out_destroy, sizeof(async->out_destroy),
+				  destroy_tis_callback, &async->context);
 }
 
-static void mlx5e_tls_priv_tx_list_cleanup(struct list_head *list)
+static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
+					   struct list_head *list, int size)
 {
 	struct mlx5e_ktls_offload_context_tx *obj;
+	struct mlx5e_async_ctx *bulk_async;
+	int i;
+
+	bulk_async = mlx5e_bulk_async_init(mdev, size);
+	if (!bulk_async)
+		return;
 
-	list_for_each_entry(obj, list, list_node)
-		mlx5e_tls_priv_tx_cleanup(obj);
+	i = 0;
+	list_for_each_entry(obj, list, list_node) {
+		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async[i]);
+		i++;
+	}
+
+	for (i = 0; i < size; i++) {
+		struct mlx5e_async_ctx *async = &bulk_async[i];
+
+		wait_for_completion(&async->complete);
+	}
+	mlx5e_bulk_async_cleanup(bulk_async, size);
 }
 
 /* Recycling pool API */
 
+#define MLX5E_TLS_TX_POOL_BULK (16)
+#define MLX5E_TLS_TX_POOL_HIGH (4 * 1024)
+#define MLX5E_TLS_TX_POOL_LOW (MLX5E_TLS_TX_POOL_HIGH / 4)
+
 struct mlx5e_tls_tx_pool {
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_tls_sw_stats *sw_stats;
 	struct mutex lock; /* Protects access to the pool */
 	struct list_head list;
-#define MLX5E_TLS_TX_POOL_MAX_SIZE (256)
 	size_t size;
+
+	struct workqueue_struct *wq;
+	struct work_struct create_work;
+	struct work_struct destroy_work;
 };
 
+static void create_work(struct work_struct *work)
+{
+	struct mlx5e_tls_tx_pool *pool =
+		container_of(work, struct mlx5e_tls_tx_pool, create_work);
+	struct mlx5e_ktls_offload_context_tx *obj;
+	struct mlx5e_async_ctx *bulk_async;
+	LIST_HEAD(local_list);
+	int i, j, err = 0;
+
+	bulk_async = mlx5e_bulk_async_init(pool->mdev, MLX5E_TLS_TX_POOL_BULK);
+	if (!bulk_async)
+		return;
+
+	for (i = 0; i < MLX5E_TLS_TX_POOL_BULK; i++) {
+		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats, &bulk_async[i]);
+		if (IS_ERR(obj)) {
+			err = PTR_ERR(obj);
+			break;
+		}
+		list_add(&obj->list_node, &local_list);
+	}
+
+	for (j = 0; j < i; j++) {
+		struct mlx5e_async_ctx *async = &bulk_async[j];
+
+		wait_for_completion(&async->complete);
+		if (!err && async->err)
+			err = async->err;
+	}
+	atomic64_add(i, &pool->sw_stats->tx_tls_pool_alloc);
+	mlx5e_bulk_async_cleanup(bulk_async, MLX5E_TLS_TX_POOL_BULK);
+	if (err)
+		goto err_out;
+
+	mutex_lock(&pool->lock);
+	if (pool->size + MLX5E_TLS_TX_POOL_BULK >= MLX5E_TLS_TX_POOL_HIGH) {
+		mutex_unlock(&pool->lock);
+		goto err_out;
+	}
+	list_splice(&local_list, &pool->list);
+	pool->size += MLX5E_TLS_TX_POOL_BULK;
+	if (pool->size <= MLX5E_TLS_TX_POOL_LOW)
+		queue_work(pool->wq, work);
+	mutex_unlock(&pool->lock);
+	return;
+
+err_out:
+	mlx5e_tls_priv_tx_list_cleanup(pool->mdev, &local_list, i);
+	atomic64_add(i, &pool->sw_stats->tx_tls_pool_free);
+}
+
+static void destroy_work(struct work_struct *work)
+{
+	struct mlx5e_tls_tx_pool *pool =
+		container_of(work, struct mlx5e_tls_tx_pool, destroy_work);
+	struct mlx5e_ktls_offload_context_tx *obj;
+	LIST_HEAD(local_list);
+	int i = 0;
+
+	mutex_lock(&pool->lock);
+	if (pool->size < MLX5E_TLS_TX_POOL_HIGH) {
+		mutex_unlock(&pool->lock);
+		return;
+	}
+
+	list_for_each_entry(obj, &pool->list, list_node)
+		if (++i == MLX5E_TLS_TX_POOL_BULK)
+			break;
+
+	list_cut_position(&local_list, &pool->list, &obj->list_node);
+	pool->size -= MLX5E_TLS_TX_POOL_BULK;
+	if (pool->size >= MLX5E_TLS_TX_POOL_HIGH)
+		queue_work(pool->wq, work);
+	mutex_unlock(&pool->lock);
+
+	mlx5e_tls_priv_tx_list_cleanup(pool->mdev, &local_list, MLX5E_TLS_TX_POOL_BULK);
+	atomic64_add(MLX5E_TLS_TX_POOL_BULK, &pool->sw_stats->tx_tls_pool_free);
+}
+
 static struct mlx5e_tls_tx_pool *mlx5e_tls_tx_pool_init(struct mlx5_core_dev *mdev,
 							struct mlx5e_tls_sw_stats *sw_stats)
 {
 	struct mlx5e_tls_tx_pool *pool;
 
+	BUILD_BUG_ON(MLX5E_TLS_TX_POOL_LOW + MLX5E_TLS_TX_POOL_BULK >= MLX5E_TLS_TX_POOL_HIGH);
+
 	pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
+	pool->wq = create_singlethread_workqueue("mlx5e_tls_tx_pool");
+	if (!pool->wq)
+		goto err_free;
+
 	INIT_LIST_HEAD(&pool->list);
 	mutex_init(&pool->lock);
 
+	INIT_WORK(&pool->create_work, create_work);
+	INIT_WORK(&pool->destroy_work, destroy_work);
+
 	pool->mdev = mdev;
 	pool->sw_stats = sw_stats;
 
 	return pool;
+
+err_free:
+	kvfree(pool);
+	return NULL;
+}
+
+static void mlx5e_tls_tx_pool_list_cleanup(struct mlx5e_tls_tx_pool *pool)
+{
+	while (pool->size > MLX5E_TLS_TX_POOL_BULK) {
+		struct mlx5e_ktls_offload_context_tx *obj;
+		LIST_HEAD(local_list);
+		int i = 0;
+
+		list_for_each_entry(obj, &pool->list, list_node)
+			if (++i == MLX5E_TLS_TX_POOL_BULK)
+				break;
+
+		list_cut_position(&local_list, &pool->list, &obj->list_node);
+		mlx5e_tls_priv_tx_list_cleanup(pool->mdev, &local_list, MLX5E_TLS_TX_POOL_BULK);
+		atomic64_add(MLX5E_TLS_TX_POOL_BULK, &pool->sw_stats->tx_tls_pool_free);
+		pool->size -= MLX5E_TLS_TX_POOL_BULK;
+	}
+	if (pool->size) {
+		mlx5e_tls_priv_tx_list_cleanup(pool->mdev, &pool->list, pool->size);
+		atomic64_add(pool->size, &pool->sw_stats->tx_tls_pool_free);
+	}
 }
 
 static void mlx5e_tls_tx_pool_cleanup(struct mlx5e_tls_tx_pool *pool)
 {
-	mlx5e_tls_priv_tx_list_cleanup(&pool->list);
-	atomic64_add(pool->size, &pool->sw_stats->tx_tls_pool_free);
+	mlx5e_tls_tx_pool_list_cleanup(pool);
+	destroy_workqueue(pool->wq);
 	kvfree(pool);
 }
 
 static void pool_push(struct mlx5e_tls_tx_pool *pool, struct mlx5e_ktls_offload_context_tx *obj)
 {
 	mutex_lock(&pool->lock);
-	if (pool->size >= MLX5E_TLS_TX_POOL_MAX_SIZE) {
-		mutex_unlock(&pool->lock);
-		mlx5e_tls_priv_tx_cleanup(obj);
-		atomic64_inc(&pool->sw_stats->tx_tls_pool_free);
-		return;
-	}
 	list_add(&obj->list_node, &pool->list);
-	pool->size++;
+	if (++pool->size == MLX5E_TLS_TX_POOL_HIGH)
+		queue_work(pool->wq, &pool->destroy_work);
 	mutex_unlock(&pool->lock);
 }
 
@@ -183,18 +440,24 @@ static struct mlx5e_ktls_offload_context_tx *pool_pop(struct mlx5e_tls_tx_pool *
 	struct mlx5e_ktls_offload_context_tx *obj;
 
 	mutex_lock(&pool->lock);
-	if (pool->size == 0) {
-		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats);
+	if (unlikely(pool->size == 0)) {
+		/* pool is empty:
+		 * - trigger the populating work, and
+		 * - serve the current context via the regular blocking api.
+		 */
+		queue_work(pool->wq, &pool->create_work);
+		mutex_unlock(&pool->lock);
+		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats, NULL);
 		if (!IS_ERR(obj))
 			atomic64_inc(&pool->sw_stats->tx_tls_pool_alloc);
-		goto out;
+		return obj;
 	}
 
 	obj = list_first_entry(&pool->list, struct mlx5e_ktls_offload_context_tx,
 			       list_node);
 	list_del(&obj->list_node);
-	pool->size--;
-out:
+	if (--pool->size == MLX5E_TLS_TX_POOL_LOW)
+		queue_work(pool->wq, &pool->create_work);
 	mutex_unlock(&pool->lock);
 	return obj;
 }
-- 
2.21.0

