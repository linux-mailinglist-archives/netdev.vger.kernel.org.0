Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A2558236C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiG0Jog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiG0Jo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480A481CC
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh5iWYAMcNoKhkEvuufRN9JmQIdjDD429oytQOLkVqc0eBDRAGCpakbaSWvRXx9qpFi7AzBuGFoV5c77rGEE1+xQa+Q25UNaLld8lHWhgXDYR73I3I9n4Q17jCZ8fJDECaPO/sL2kkmWnQWUEgt4EgJTZoStjMGzc/PAenp+rfUNxwjNaHJRWjTAy3VakziHSbEu+fNesJfT4eOR6gclMBlyO7E1mNDiOP3DdmeOoppynSOr6xfwepRxC4UVfU7IibM4AbjV2zxUviNalxAG+af+VHCrwJ8sLL16zq837o93UWP2fYxUgAdYxvK8xBR9fbxZxA0g1GKbpPPrEgNyQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Mnp+f9awP6cfzNAbUBRm6TaHfs52Vkvs9HQbfZ7yj4=;
 b=nNNKQmGuD/iYzAlRktSDeoRGOKnKk6AWGK0JkZKjjdfAF/TzQl9qXQP2bRQO2t89fbw9Hu84ZOGIQaQ/Np87gwFVjS70rgK12kRqbmF6FkFdKvYkRZTIeSJeUg6bkM4h5WfBYjvnoiiEiKsbZdrhimI59Ea69MGUZWIHUjc0HKTsRUh4UzC3C+airnLZjFPJiwtYh4QD+ILtsamXZ6sgcaDmsIA9p8Ah/A0GS1trpbh2l825ePO+6Db/1D/HOgOXqL/gILLHYTZ4uMUE52X+Jmh1v60xtEGeCKc4xDj3QyPkyvCqtZ4Y2wW7RlDubD4ZwSsBo8aPehLUFb13X39Xzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Mnp+f9awP6cfzNAbUBRm6TaHfs52Vkvs9HQbfZ7yj4=;
 b=usV3qOknQARaJrhBn6LV053Blrue4E2HuE+HdhdCAsifCMP+IUIl34GeRBejMgAjf1Fym3hZ+IYpYLsAN0/1NlsTsJkBpYEksHmOzSQpLzY9KqXDLE1i08F7jFm6ta2qhy3IqqN02k2r/kZVTwmNiZiqZxRci1EReiCdiOaOZ7bko2AI73H10cyplP3dJyJVMzzsBBWYCHyPHHqcRpK2wu/JPFyrDurIDi4pLIwo2orMlnUttlneuZYB8oI35ehj4RZ4xv4tHypByjhMc4WjavXZah6UEaSDg3344tRYECpO1kRpJU/y8r3X9X8EeoVfP27KsJPA6zJlmS780I50mw==
Received: from MW4PR04CA0064.namprd04.prod.outlook.com (2603:10b6:303:6b::9)
 by PH7PR12MB5949.namprd12.prod.outlook.com (2603:10b6:510:1d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 09:44:22 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::fe) by MW4PR04CA0064.outlook.office365.com
 (2603:10b6:303:6b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:20 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:18 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 5/6] net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections
Date:   Wed, 27 Jul 2022 12:43:45 +0300
Message-ID: <20220727094346.10540-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f3cb519-7ef7-4203-737c-08da6fb49552
X-MS-TrafficTypeDiagnostic: PH7PR12MB5949:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ti4KFKjku9Prj5fc2awtea0nnAEkHSVPx9hySDRwMDWlPomxnqezKgYv4IFYd/WeMTqZbJ/uE48XEPLbdfUXmx+c31LrE9wKRBA0QzPhNuJU2eGsTDiyQ/cggX8dSKOli1+NkGXcIZnlzxhsdfZPsBuSjrIuHYP8hszNRDcJ8o8Bjc6o+Imgv2HPFA1uUu6ZK8RlLP0k0CX55RjMrCIkEXdNUxhVjwKyq+cmDaw/BK7UkmtEf4VXF3W8+5EXFOm9e3eTf9VFge1JVYQLUuyYC4sHGR089ZixxnrK6FMocCYSmez+PgXibaNNOxr7T5YXsxP+231um2RxFByxqYteNKGTsI8FnVEz7JlQJh0SWx4H5XdKZwmXxTod/QDX/YuQYS/huVmPYxBpfIqDfwCiJ0cu4wNRa1IK3FixB6p48U/ZoBqPaFFXj8HbcUFoqItbQSRwtGpTDx7dWXp8e9JtHXGfV/Ti8pn9UXdO3Sei6ZwClrzvMZuHGtmroGGu6CK3koS0PvDK3gtyiJBKcFZAV8mvD7hHeDZlWsIBlg4fNnb5lgYSmIINZUMkRQwNqzHrmTtpv4ZT2ZllSRklnUuvsiBU0dHlU/zp2Jajmy/wFtFmf7TwAJzv6qHwwTknbMLpHkNe3kM+cVnLpfnS9yaWKUCQ8xd57We5RPwTewdOFd+RDTXsB/tMoKu6j6UDHDy6Yg1p1RRmNbHhqTetW03M0iLnCT6M4VL0JoG9lGIL5jQysLeV1MSQxHO6P9WNbXKrOjjwpfNm0mAHIPIdwGH55OsEMs//KZLkoq/Zdcgk74yb+i4CpQ0IZrjqETVqCNRRMtmrUh64OPte8M08sL+KJw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(40470700004)(70586007)(2616005)(82310400005)(47076005)(426003)(8676002)(26005)(336012)(2906002)(70206006)(83380400001)(54906003)(81166007)(82740400003)(86362001)(356005)(40460700003)(40480700001)(110136005)(4326008)(186003)(1076003)(107886003)(8936002)(478600001)(36860700001)(5660300002)(36756003)(7696005)(30864003)(316002)(41300700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:21.5101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3cb519-7ef7-4203-737c-08da6fb49552
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5949
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transport interface send (TIS) object is responsible for performing
all transport related operations of the transmit side.  The ConnectX HW
uses a TIS object to save and access the TLS crypto information and state
of an offloaded TX kTLS connection.

Before this patch, we used to create a new TIS per connection and destroy
it once it’s closed. Every create and destroy of a TIS is a FW command.

Same applies for the private TLS context, where we used to dynamically
allocate and free it per connection.

Resources recycling reduce the impact of the allocation/free operations
and helps speeding up the connection rate.

In this feature we maintain a pool of TX objects and use it to recycle
the resources instead of re-creating them per connection.

A cached TIS popped from the pool is updated to serve the new connection
via the fast-path HW interface, updating the tls static and progress
params. This is a very fast operation, significantly faster than FW
commands.

On recycling, a WQE fence is required after the context params change.
This guarantees that the data is sent after the context has been
successfully updated in hardware, and that the context modification
doesn't interfere with existing traffic.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  10 +
 .../mellanox/mlx5/core/en_accel/ktls.h        |  14 ++
 .../mellanox/mlx5/core/en_accel/ktls_stats.c  |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 211 ++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 5 files changed, 199 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 04c0a5e1c89a..1839f1ab1ddd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -194,4 +194,14 @@ static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 {
 	mlx5e_ktls_cleanup_rx(priv);
 }
+
+static inline int mlx5e_accel_init_tx(struct mlx5e_priv *priv)
+{
+	return mlx5e_ktls_init_tx(priv);
+}
+
+static inline void mlx5e_accel_cleanup_tx(struct mlx5e_priv *priv)
+{
+	mlx5e_ktls_cleanup_tx(priv);
+}
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index d016624fbc9d..948400dee525 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -42,6 +42,8 @@ static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
 }
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_ktls_init_tx(struct mlx5e_priv *priv);
+void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv);
 int mlx5e_ktls_init_rx(struct mlx5e_priv *priv);
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv);
 int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable);
@@ -62,6 +64,8 @@ static inline bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
 struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_ctx;
 	atomic64_t tx_tls_del;
+	atomic64_t tx_tls_pool_alloc;
+	atomic64_t tx_tls_pool_free;
 	atomic64_t rx_tls_ctx;
 	atomic64_t rx_tls_del;
 };
@@ -69,6 +73,7 @@ struct mlx5e_tls_sw_stats {
 struct mlx5e_tls {
 	struct mlx5e_tls_sw_stats sw_stats;
 	struct workqueue_struct *rx_wq;
+	struct mlx5e_tls_tx_pool *tx_pool;
 };
 
 int mlx5e_ktls_init(struct mlx5e_priv *priv);
@@ -83,6 +88,15 @@ static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
+{
+	return 0;
+}
+
+static inline void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
+{
+}
+
 static inline int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 {
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
index 2ab46c4247ff..7c1c0eb16787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
@@ -41,6 +41,8 @@
 static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_pool_alloc) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_pool_free) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_del) },
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 82281b1d7555..b60331bc6fe9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -35,6 +35,7 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
 	stop_room += num_dumps * mlx5e_stop_room_for_wqe(mdev, MLX5E_KTLS_DUMP_WQEBBS);
+	stop_room += 1; /* fence nop */
 
 	return stop_room;
 }
@@ -56,13 +57,17 @@ static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 }
 
 struct mlx5e_ktls_offload_context_tx {
-	struct tls_offload_context_tx *tx_ctx;
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
-	struct mlx5e_tls_sw_stats *sw_stats;
+	/* fast path */
 	u32 expected_seq;
 	u32 tisn;
-	u32 key_id;
 	bool ctx_post_pending;
+	/* control / resync */
+	struct list_head list_node; /* member of the pool */
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	struct tls_offload_context_tx *tx_ctx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_sw_stats *sw_stats;
+	u32 key_id;
 };
 
 static void
@@ -86,28 +91,136 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 	return *ctx;
 }
 
+static struct mlx5e_ktls_offload_context_tx *
+mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw_stats)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	int err;
+
+	priv_tx = kzalloc(sizeof(*priv_tx), GFP_KERNEL);
+	if (!priv_tx)
+		return ERR_PTR(-ENOMEM);
+
+	priv_tx->mdev = mdev;
+	priv_tx->sw_stats = sw_stats;
+
+	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
+	if (err) {
+		kfree(priv_tx);
+		return ERR_PTR(err);
+	}
+
+	return priv_tx;
+}
+
+static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	mlx5e_destroy_tis(priv_tx->mdev, priv_tx->tisn);
+	kfree(priv_tx);
+}
+
+static void mlx5e_tls_priv_tx_list_cleanup(struct list_head *list)
+{
+	struct mlx5e_ktls_offload_context_tx *obj;
+
+	list_for_each_entry(obj, list, list_node)
+		mlx5e_tls_priv_tx_cleanup(obj);
+}
+
+/* Recycling pool API */
+
+struct mlx5e_tls_tx_pool {
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_sw_stats *sw_stats;
+	struct mutex lock; /* Protects access to the pool */
+	struct list_head list;
+#define MLX5E_TLS_TX_POOL_MAX_SIZE (256)
+	size_t size;
+};
+
+static struct mlx5e_tls_tx_pool *mlx5e_tls_tx_pool_init(struct mlx5_core_dev *mdev,
+							struct mlx5e_tls_sw_stats *sw_stats)
+{
+	struct mlx5e_tls_tx_pool *pool;
+
+	pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	INIT_LIST_HEAD(&pool->list);
+	mutex_init(&pool->lock);
+
+	pool->mdev = mdev;
+	pool->sw_stats = sw_stats;
+
+	return pool;
+}
+
+static void mlx5e_tls_tx_pool_cleanup(struct mlx5e_tls_tx_pool *pool)
+{
+	mlx5e_tls_priv_tx_list_cleanup(&pool->list);
+	atomic64_add(pool->size, &pool->sw_stats->tx_tls_pool_free);
+	kvfree(pool);
+}
+
+static void pool_push(struct mlx5e_tls_tx_pool *pool, struct mlx5e_ktls_offload_context_tx *obj)
+{
+	mutex_lock(&pool->lock);
+	if (pool->size >= MLX5E_TLS_TX_POOL_MAX_SIZE) {
+		mutex_unlock(&pool->lock);
+		mlx5e_tls_priv_tx_cleanup(obj);
+		atomic64_inc(&pool->sw_stats->tx_tls_pool_free);
+		return;
+	}
+	list_add(&obj->list_node, &pool->list);
+	pool->size++;
+	mutex_unlock(&pool->lock);
+}
+
+static struct mlx5e_ktls_offload_context_tx *pool_pop(struct mlx5e_tls_tx_pool *pool)
+{
+	struct mlx5e_ktls_offload_context_tx *obj;
+
+	mutex_lock(&pool->lock);
+	if (pool->size == 0) {
+		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats);
+		if (!IS_ERR(obj))
+			atomic64_inc(&pool->sw_stats->tx_tls_pool_alloc);
+		goto out;
+	}
+
+	obj = list_first_entry(&pool->list, struct mlx5e_ktls_offload_context_tx,
+			       list_node);
+	list_del(&obj->list_node);
+	pool->size--;
+out:
+	mutex_unlock(&pool->lock);
+	return obj;
+}
+
+/* End of pool API */
+
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct mlx5e_tls_tx_pool *pool;
 	struct tls_context *tls_ctx;
-	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int err;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
+	pool = priv->tls->tx_pool;
 
-	priv_tx = kzalloc(sizeof(*priv_tx), GFP_KERNEL);
-	if (!priv_tx)
-		return -ENOMEM;
+	priv_tx = pool_pop(pool);
+	if (IS_ERR(priv_tx))
+		return PTR_ERR(priv_tx);
 
-	err = mlx5_ktls_create_key(mdev, crypto_info, &priv_tx->key_id);
+	err = mlx5_ktls_create_key(pool->mdev, crypto_info, &priv_tx->key_id);
 	if (err)
 		goto err_create_key;
 
-	priv_tx->sw_stats = &priv->tls->sw_stats;
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
@@ -115,36 +228,29 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
 
-	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
-	if (err)
-		goto err_create_tis;
-
 	priv_tx->ctx_post_pending = true;
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
 
 	return 0;
 
-err_create_tis:
-	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
 err_create_key:
-	kfree(priv_tx);
+	pool_push(pool, priv_tx);
 	return err;
 }
 
 void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
-	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_tx_pool *pool;
 	struct mlx5e_priv *priv;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
+	pool = priv->tls->tx_pool;
 
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_del);
-	mlx5e_destroy_tis(mdev, priv_tx->tisn);
-	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
-	kfree(priv_tx);
+	mlx5_ktls_destroy_key(priv_tx->mdev, priv_tx->key_id);
+	pool_push(pool, priv_tx);
 }
 
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
@@ -205,6 +311,16 @@ post_progress_params(struct mlx5e_txqsq *sq,
 	sq->pc += num_wqebbs;
 }
 
+static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+
+	tx_fill_wi(sq, pi, 1, 0, NULL);
+
+	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
+}
+
 static void
 mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 			      struct mlx5e_ktls_offload_context_tx *priv_tx,
@@ -216,6 +332,7 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 		post_static_params(sq, priv_tx, fence_first_post);
 
 	post_progress_params(sq, priv_tx, progress_fence);
+	tx_post_fence_nop(sq);
 }
 
 struct tx_sync_info {
@@ -308,7 +425,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 }
 
 static int
-tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool first)
+tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn)
 {
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_data_seg *dseg;
@@ -330,7 +447,6 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP);
 	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 	cseg->tis_tir_num      = cpu_to_be32(tisn << 8);
-	cseg->fm_ce_se         = first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 
 	fsz = skb_frag_size(frag);
 	dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
@@ -365,16 +481,6 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	stats->tls_dump_bytes += wi->num_bytes;
 }
 
-static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
-{
-	struct mlx5_wq_cyc *wq = &sq->wq;
-	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-
-	tx_fill_wi(sq, pi, 1, 0, NULL);
-
-	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
-}
-
 static enum mlx5e_ktls_sync_retval
 mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 struct mlx5e_txqsq *sq,
@@ -395,14 +501,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
 
-	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
-	 * actual data xmit.
-	 */
-	if (!info.nr_frags) {
-		tx_post_fence_nop(sq);
-		return MLX5E_KTLS_SYNC_DONE;
-	}
-
 	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
@@ -410,13 +508,12 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		orig_fsz = skb_frag_size(f);
 
 		do {
-			bool fence = !(i || frag_offset);
 			unsigned int fsz;
 
 			n++;
 			fsz = min_t(unsigned int, sq->hw_mtu, orig_fsz - frag_offset);
 			skb_frag_size_set(f, fsz);
-			if (tx_post_resync_dump(sq, f, priv_tx->tisn, fence)) {
+			if (tx_post_resync_dump(sq, f, priv_tx->tisn)) {
 				page_ref_add(skb_frag_page(f), n - 1);
 				goto err_out;
 			}
@@ -464,9 +561,8 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
-	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
+	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx)))
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-	}
 
 	seq = ntohl(tcp_hdr(skb)->seq);
 	if (unlikely(priv_tx->expected_seq != seq)) {
@@ -504,3 +600,24 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	dev_kfree_skb_any(skb);
 	return false;
 }
+
+int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
+{
+	if (!mlx5e_is_ktls_tx(priv->mdev))
+		return 0;
+
+	priv->tls->tx_pool = mlx5e_tls_tx_pool_init(priv->mdev, &priv->tls->sw_stats);
+	if (!priv->tls->tx_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
+{
+	if (!mlx5e_is_ktls_tx(priv->mdev))
+		return;
+
+	mlx5e_tls_tx_pool_cleanup(priv->tls->tx_pool);
+	priv->tls->tx_pool = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 180b2f418339..24ddd438c066 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3144,6 +3144,7 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 		mlx5e_mqprio_rl_free(priv->mqprio_rl);
 		priv->mqprio_rl = NULL;
 	}
+	mlx5e_accel_cleanup_tx(priv);
 	mlx5e_destroy_tises(priv);
 }
 
@@ -5147,9 +5148,17 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
+	err = mlx5e_accel_init_tx(priv);
+	if (err)
+		goto err_destroy_tises;
+
 	mlx5e_set_mqprio_rl(priv);
 	mlx5e_dcbnl_initialize(priv);
 	return 0;
+
+err_destroy_tises:
+	mlx5e_destroy_tises(priv);
+	return err;
 }
 
 static void mlx5e_nic_enable(struct mlx5e_priv *priv)
-- 
2.21.0

