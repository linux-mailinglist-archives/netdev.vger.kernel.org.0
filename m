Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3F519723
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344790AbiEDGGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344780AbiEDGGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BC1B7B6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtYHzRNuipZCEq2FPvZZ1xaW8OHHcnahvuRRjJTx/U7ZWf/mEzJF2o1EfRBDoqAcYruOUk1BqnOZIIOAHA2zU2Xk8mH5BvfWJ2roC9P+9LO1KRAshmZ+cyvzcPU8YJkngQFExS34qcN2BGIYmc+iLf7/TTGM2SNjRW70BmNewOxwwXxBVikyoX0UR7ZqxRHOz8mngzfyZFshMigM/N5WGtXxjcUk/6pyneXykcZgOEMemT1ptH6naB5kpn5OUGQPIU8gor7jjbhSfl5s60pI9QRLbzIZOe2Zi7murzyQ2x4w7Nk+azLl3cN2eMixsfu61bwKpyMHtPkauyTr2iVbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5WyinL8LZg9ijRBumBQ6I6B40wZy/Dser0O4UpdLx0=;
 b=Q+I1RPJXGyc57O6oO3oZK85+fuDVGziMEcNbN6OTR4c8TuidIL0ZX7whq6Si7iVwbkQR9zufLF81/MbJZAVK+w7gYfwYJTE2M3Kii3OpYzbSavw4Yzwxp2L9+LpdtIHbzQl4FAcgZ1bGxH40qyuRdlw7PsyYAuGmV2A3m2z64LwJ1voniu1tJ/UbaZ9ES6batzVJ89c018l3ngvQ0AaA5QtvKU2YqLBAQCS0nuPG8ynOM3Q4Pv2SaCLtjQNWQrOrKvn0KNd8EtcMhbiNfEmcrL4y+JqoB6596J/KM4VwVvLlOxvH39qVX1Pql9QEmTb0WS/O0HiJoVS7UxZbYO4Nqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5WyinL8LZg9ijRBumBQ6I6B40wZy/Dser0O4UpdLx0=;
 b=fLw8OvNwLEZBU8gWdFVwOtKynjoSBBAd7teVRnhTFZhxce6s2Rfqzqx6pAnLJktAfzIwQTeP4bW9J3NST/reX4w74rCOX2zR+QUdGztDJ305piaOQmT2ABxjwUy2RM0aFVzAqReKGUnsPi1UMHU8jqiyJmyRigjh2Tlml4RQpWTUe8cCMNmc6EU1uOMtnSy2e6CUQCjpFLEFFb4i8fsAEf7LG4UgVlNO/OUM9VA2aVNlVVgq2NVgcF4H03BPpaaq1Bm6A0EtmPGxyCUSckN5/rend5tjror6MZMjh0BRQf5e1bCxtIVAkoxjyz+VUcwRzDOSwhA/FVhp2k3kSfdHHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:02:58 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:02:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/17] net/mlx5: Check IPsec TX flow steering namespace in advance
Date:   Tue,  3 May 2022 23:02:16 -0700
Message-Id: <20220504060231.668674-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59a931b8-609f-43ce-8a42-08da2d93bd4d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB000616558637511BD8DF5897B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFExqSEEhs7fdbjl4Z44m++gSsVOGW0Cv3ZuzKI1ExaGzaqef9wUjLRgRPPWj4/VQhYiDyCz7IK10duqPY9Vw0aqkRFI9hnuH1kIZXVVoRoKBm7TG2YdMdb/fml2+Xe8Y3jOoIGBq4kACbKXmICKLV+P1x9PkvF7bbLtfLJ4gq9mG/lHXSbFoH/qPUOlOYPyFxMBXGWWLyFj689rv6KNzUPZ8bGRpQj/0Udbuy4TVyDg0nS7eqWcEj5lZ8TigyNdj2S7mY7D4zRpriE92Ul6jaXLbCr4O+xE4V06+D/b4OOYXMI8OSdp3q4/1RRdDRGZTZSdHS0QYh8r7s5GIIAZdHMJTknUV7vHdsRWvKGz757+ciyd4KQEJOP7Dr9tRmL40ThfhYdT9HdQc1UmHio4gLdo6WOC0dLOktljP1EtLsg+HQnHtvotNTc8YDtPDoudbhq5vxEHmF+0HREQVNQZ/dW3PkNT/Q/m/wPript/mQIiUijbTkK5SD4vftNs9/Dfi+fONKed/lpX5wU4Ab2U99VcgXI8wPKuJONb/sTbMgcf0eLxOaeI02vPGdwrNFYqhfMCm3DTTmPdUpLGTt7m/AJ95PNxrhJdZA0dJAuNqKpCWzlg2nTe5S2Bl1m/PELeHwB5zCEEDmS+NxfBbbONSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FauDEgFGsZ8xwhSykCQdnlMJ2icme1Irw8a+fO0XRV8cO34A4Pwy33Yob5SG?=
 =?us-ascii?Q?kMTXgp2iGgY5qw2/TwmbMhfPhNcRr6AcYVaQT+rObekFxVKL/jGAs/ut2Jx2?=
 =?us-ascii?Q?1ivKwaWF5PdEWBhBaEs4YRZgN2YmVpNIfnSv5bmVtDZZC7ouS3/cnQWL6zI2?=
 =?us-ascii?Q?7d5BGnRhAJxtRCg/TIJg3+NZqQIa/vX7byyrcr7QRulc8ymaHSS7vo9kaLJU?=
 =?us-ascii?Q?Mt93r7T+HNpKfDtmgt2MhIx79Z+4Ck4gwURImWY4NI7fBI+BeNvRq3GIBrso?=
 =?us-ascii?Q?N+qWvHlNXlNp7Sf0Sqe9nwd4RIx1R3a154gTma6+2Nz6amL+nBSrRqxDyEpP?=
 =?us-ascii?Q?JKSL00NNYWUkKC0Hb6x+vQ40n+EnIHHEArsKpAqPXfAI4eoS58Fxql42RhIV?=
 =?us-ascii?Q?tbGaGmOd1i4r+d+b8nWsU9LL+M1HBMnIWn5EhV/zQl43crYs9byIuadz6Za6?=
 =?us-ascii?Q?PM0REmbf0ovuIW3Eh9U3dw1p9V9l9bo8yT/W+rdHQVLyOEPZJZM5FDBW81il?=
 =?us-ascii?Q?JEq9lN9m94EB4Z89UQQpqnx6ZqNPT9SPq7BNAF4T63aNvFN6+ccexkZ8SDte?=
 =?us-ascii?Q?WMleD55AsbFkNlkW/0ZBiItKdjST+eWbc69lPXLHqomYtx0MiF8rD6hiCYao?=
 =?us-ascii?Q?yhL09fODjYpXE7C1g1YUUB/Nr5KF8rH7T5oN0s+7vCWPROCjR2VLx7k1Xl4K?=
 =?us-ascii?Q?r7j5TlOgKTnUU/dMy0Ytw/EvEuySXW4gXAyMR/HRtPB379pmJA7wsO9/RrMx?=
 =?us-ascii?Q?gPE+JW53OYCdoavFRDaADpfv7TFXMdtXlqXPSqFRrgYQAJXTwWPPR7JvEnla?=
 =?us-ascii?Q?XNeCsGg5ClDE9nY9NOecmxte8byYWzAjQ+hXS24RDa+2YOIR7GRq0snNziQx?=
 =?us-ascii?Q?tWIyIF9TdGeGulEG4jWmwKINQS6t3mPyOtFS4SVBMXP7zqt8DM/ojpI9Lw5C?=
 =?us-ascii?Q?YELaCX1kuEgB6+Pl8NaPQB821yldxSYfi8BlX3tmSY69yChlNurzLsPqcUek?=
 =?us-ascii?Q?iGJJnZ40odMc+5NsnRdKztHWSnQaflWeSMh1fRHXowcRlIi2hXcAhV8jRKyJ?=
 =?us-ascii?Q?kd5zv5EJwOtKqO0ZnFL2t25H9kXf9jk41La2EDVXFbuJ8VR65GYnux2HsLQq?=
 =?us-ascii?Q?WoYXvw3rOnyTwHzxM2Rx6V2tzfDHXlwgLZQrYJNR+4e9YnyxAEnI/7EvdG8F?=
 =?us-ascii?Q?BhxhYRuu/onZAdI66gdAloPmm7/hY1nQVTBOHZBS6xzAyVzTYX1NGOGo0az6?=
 =?us-ascii?Q?ig1qrFHaKCmfTgi9eMb7xAg+G3XI2vtdWo1QmRIR6eaTuNJnpcq6abjVaIZP?=
 =?us-ascii?Q?8FN1KYBgj67rd2TbYTN/kV08vd/m8+02moEDanxk0Gx/mketdrVrzDXt3xB6?=
 =?us-ascii?Q?MXvjg8iyDZlI4c7J+bQp0m9DQiWs3q4DHAtnCq4cx8v/HB/xi6PuMDxB8n1f?=
 =?us-ascii?Q?+X9qa/fW74jBqjGTiTS/hVS8gKQAnwmAPKC0+B6oaZ8y78Tu4NrpCbaISib9?=
 =?us-ascii?Q?oOQwCf0WlibISDUsQpjbiFzA/FjzGD59v4Ax2a3SEXl+CPORwkMtr/CX1l4f?=
 =?us-ascii?Q?t0FdC6OZ1ahVy7WFMwxnmUYkqsLIaxrHfmlLHU+bnHtfLcOV8bUHvdMATmSh?=
 =?us-ascii?Q?daP4ka3JCzaKty2MdOzlOlyG8etIuRF8sG0O2opr9e9swwMupsQCXtNNON7P?=
 =?us-ascii?Q?PbNIR0POzfPSW7G+SjtREYOtzg2mPEBUX9tISxrimhO9OPhtYF38OVoy1nr+?=
 =?us-ascii?Q?Eoi7TuXD0bU1a34FZPm5XtyRYdkZnqg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a931b8-609f-43ce-8a42-08da2d93bd4d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:02:58.7169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLA7B5Hh7A8nenPGOMnFGjtUoSCW0Qg5FVUZZsoYxZhP+jJqlPscOMlZduGCusQqjYDKoOmaI3480PAbylvlQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Ensure that flow steering is usable as early as possible, to understand
if crypto IPsec is supported or not.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c |  1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c       | 16 +++++++++-------
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 678ffbb48a25..4130a871de61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -164,7 +164,6 @@ struct mlx5e_ptp_fs;
 
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
-	struct mlx5_flow_namespace      *egress_ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
 	struct mlx5e_ethtool_steering   ethtool;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b6e430d53fae..40700bf61924 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -415,6 +415,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
+	ipsec->mdev = priv->mdev;
 	ipsec->en_priv = priv;
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a0e9dade09e9..bbf48d4616f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -61,6 +61,7 @@ struct mlx5e_accel_fs_esp;
 struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec {
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 029a9a70ba0e..55fb6d4cf4ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -35,6 +35,7 @@ struct mlx5e_accel_fs_esp {
 };
 
 struct mlx5e_ipsec_tx {
+	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table *ft;
 	struct mutex mutex; /* Protect IPsec TX steering */
 	u32 refcnt;
@@ -338,15 +339,9 @@ static int tx_create(struct mlx5e_priv *priv)
 	struct mlx5_flow_table *ft;
 	int err;
 
-	priv->fs.egress_ns =
-		mlx5_get_flow_namespace(priv->mdev,
-					MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
-	if (!priv->fs.egress_ns)
-		return -EOPNOTSUPP;
-
 	ft_attr.max_fte = NUM_IPSEC_FTE;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.egress_ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx_fs->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		netdev_err(priv->netdev, "fail to create ipsec tx ft err=%d\n", err);
@@ -658,9 +653,15 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5_flow_namespace *ns;
 	enum accel_fs_esp_type i;
 	int err = -ENOMEM;
 
+	ns = mlx5_get_flow_namespace(ipsec->mdev,
+				     MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
+	if (!ns)
+		return -EOPNOTSUPP;
+
 	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
 	if (!ipsec->tx_fs)
 		return -ENOMEM;
@@ -670,6 +671,7 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 		goto err_rx;
 
 	mutex_init(&ipsec->tx_fs->mutex);
+	ipsec->tx_fs->ns = ns;
 
 	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
-- 
2.35.1

