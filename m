Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686A01D5C8C
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEOWt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:59 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3Z/iuBH3t1wz3W54NzNTGvSwi1pWcvr1nBwFD1IsY56h2rjj+PEoLIvEwUNiVhy2bgkfWBENnTT8BPApNoZVXL95Ab57QKvS1hyS5/Oh70C7FsnDDcRb6qN7eaZW+X2srIo/v6S95ehriWS1eZb9yFAMJxAa+srOjjxy/UTV1vtShmVM9r3nFw+vS+Ff1h/Dhc2obymRuVVIGc/5cBTsoAQlhg7ozWZKJf+Lm7qdyAzRrAegtIY5PeTTTAgsnq+5u9ubz7UYeiaSHKoNiheh/xpK6D3YP3TZaF9WR8eiqugvAJyc0sX+SJW5mtYP+fQ3/4LteOhbLqmoyh4QcmlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USRFHEVYKM9EdI/LN1YjpiV3aTJx2iwCaVVubum5hp0=;
 b=E3NYqPH8tRHKW6BZ7kGRMdW13LSREr/E7iLU5vY+rhjzaIG9Hi13v3MfUuuvKIPWE7uc/Jvy/bM0uni+odyi6L26+9bfdNLQdfuJOU0P3BkHwUeS8IyDEWFqnnoTOp2gBjqHgfLaFjYGiMddqZqFd3M0TCqBAGYdAnLgpnyi66SLJoR/FZVZQQ8AqnHrxfcQc5FbvK2XPlAZqz1mAHrSLytXi9OBfbvk97jjTyAeTvvtdC/pVwv1nXZ7CXHjwI8sk2/FtUNcYRGxodgOU7I6Oc26d2rVQDhzWUN+S5imoT1rjSvnMk8xNq+JWy6bMiXxAfvFiCyYRy1m5swN0Cztiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USRFHEVYKM9EdI/LN1YjpiV3aTJx2iwCaVVubum5hp0=;
 b=sU8LaPa4hwIIQVoCGg3dcmhpKFjNMycW5KjO3SNkjT9zSEimXudpYiUGwjgaVzS92NASUuKuFryHxL/PfGubzQwqkkQL89q2DuEYb+OO5i1lLfRW0hKvhQm5bJENWdVeYpu72CmaRx8G5NJVBBl+X3vY3UCtJst9saghzn5rsWM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/11] net/mlx5e: Take DCBNL-related definitions into dedicated files
Date:   Fri, 15 May 2020 15:48:54 -0700
Message-Id: <20200515224854.20390-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:40 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 86a4538c-7433-4582-3890-08d7f92241c3
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200694E3834ADD7CFE7ECDFBEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjmPNplvb7t2yFvwsXhLtAnw/FbF4RGB8FlQzDX3BhIxZzjQScvKgSrBrKgiiYYJLn8ntkMu1Gxr1MI+/uTJ5AyGLbLnuwnCGOPSqg9zwZni5w8uFVXOC7prkIcL1r3zYtO6xuX5qxICtQwLqqMSMZ7CHYkqc1srWl/VeOowI0DKFFU5cbIF2LWnnPCicv75qI7OqBmMeLYw7PtKaa4zlubaMyVod+1th0/w5rjJ+X1bGdT1hbWAsKU++EcPHxfFjrHBZu3NQQyP5y58Mws26iF+/Q8sw5W+0cOydJT2p/sDzXNxxZj5643lO9E7od6XVywJHIjd+X51PvpqhtLtMPsRzhUJHpHiwG5U6Th5dL5sy0rhjM6d6XVewN0Un2OEbd1PfVuLmcvSrC1T88HSxANApQ9JF5A2H1MDQ95Fr8H2/mEZbViJmaFMYR/d3JzVVLxppNatkPLjVl6LQ+ik1a5oLpUVU25srxEY4Cih937aFBmcv/Oj1Z4QGB1Kmq/K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(30864003)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3T82G1FVmPtgBblL+hPRHuVAwmIro1Ij1uvndCuXklyWLLTLpxelA1ZqVeR6wu5ldsmru0N0UY/WKZMLbPIyl9+5ew8P2DuBXuGjDZ0Z+MIciRDSb/BON/AXU6B8idwV/kXWnmTvuetA7jc4e4GvgRbvrYb5gfXHtAHyIxN+UK1cAVqvfvbLSYXP4aK64j5iNTw6RBXSIp5q9/21W20B0zZslpQpB59ya8rXV0qIBwLzNAI09WybFA+u4tnXwbeLPc+NXepg624zWjg+CYfzyxg2UNNla/zA/eZMgUyh6jfud1rJynwLyy0gzcCYPMK9ca706DxDz+euxcyj+nVHVjlJnysTtwjgBqo+GnPFYB6H3EnJ2PVSCWv9nUhawGMYsGzsF1z+W3X1exxcqefTazgAFnSzRBmQ8bNR+2I7mygT5yoPPq4wgCkTIl0Kp+dmTHmVOlNE2RC80/Ybkpjng9sMSzbGWKwDGj8AlVPhq90=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a4538c-7433-4582-3890-08d7f92241c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:42.6910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvAX6XSu4zTlCXiOWPQOg8J3LOUmcf5d4TxapYqxLBLiv+gaSlgT/d7ryvxh/mQgz2HIIBeaILc0Xb/8UEG/fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Take DCBNL-related definitions out of the common en.h header,
Use a dedicated header file for exposing them.
Some need not to be exposed, use them locally in the .c file.
Use stubs to eliminate use of CONFIG_MLX5_CORE_EN_DCB in the
generic control flows.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 50 +----------------
 .../ethernet/mellanox/mlx5/core/en/dcbnl.h    | 54 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 28 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 16 +-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 +---
 5 files changed, 84 insertions(+), 73 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ac385ac93fe5..81fd53569463 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -52,6 +52,7 @@
 #include "wq.h"
 #include "mlx5_core.h"
 #include "en_stats.h"
+#include "en/dcbnl.h"
 #include "en/fs.h"
 #include "lib/hv_vhca.h"
 
@@ -68,8 +69,6 @@ struct page_pool;
 #define MLX5E_HW2SW_MTU(params, hwmtu) ((hwmtu) - ((params)->hard_mtu))
 #define MLX5E_SW2HW_MTU(params, swmtu) ((swmtu) + ((params)->hard_mtu))
 
-#define MLX5E_MAX_PRIORITY      8
-#define MLX5E_MAX_DSCP          64
 #define MLX5E_MAX_NUM_TC	8
 
 #define MLX5_RX_HEADROOM NET_SKB_PAD
@@ -242,10 +241,6 @@ enum mlx5e_priv_flag {
 
 #define MLX5E_GET_PFLAG(params, pflag) (!!((params)->pflags & (BIT(pflag))))
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-#define MLX5E_MAX_BW_ALLOC 100 /* Max percentage of BW allocation */
-#endif
-
 struct mlx5e_params {
 	u8  log_sq_size;
 	u8  rq_wq_type;
@@ -270,42 +265,6 @@ struct mlx5e_params {
 	int hard_mtu;
 };
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-struct mlx5e_cee_config {
-	/* bw pct for priority group */
-	u8                         pg_bw_pct[CEE_DCBX_MAX_PGS];
-	u8                         prio_to_pg_map[CEE_DCBX_MAX_PRIO];
-	bool                       pfc_setting[CEE_DCBX_MAX_PRIO];
-	bool                       pfc_enable;
-};
-
-enum {
-	MLX5_DCB_CHG_RESET,
-	MLX5_DCB_NO_CHG,
-	MLX5_DCB_CHG_NO_RESET,
-};
-
-struct mlx5e_dcbx {
-	enum mlx5_dcbx_oper_mode   mode;
-	struct mlx5e_cee_config    cee_cfg; /* pending configuration */
-	u8                         dscp_app_cnt;
-
-	/* The only setting that cannot be read from FW */
-	u8                         tc_tsa[IEEE_8021QAZ_MAX_TCS];
-	u8                         cap;
-
-	/* Buffer configuration */
-	bool                       manual_buffer;
-	u32                        cable_len;
-	u32                        xoff;
-};
-
-struct mlx5e_dcbx_dp {
-	u8                         dscp2prio[MLX5E_MAX_DSCP];
-	u8                         trust_state;
-};
-#endif
-
 enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_RECOVERING,
@@ -1068,13 +1027,6 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 }
 
 extern const struct ethtool_ops mlx5e_ethtool_ops;
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-extern const struct dcbnl_rtnl_ops mlx5e_dcbnl_ops;
-int mlx5e_dcbnl_ieee_setets_core(struct mlx5e_priv *priv, struct ieee_ets *ets);
-void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv);
-void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv);
-void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv);
-#endif
 
 int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir,
 		     u32 *in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
new file mode 100644
index 000000000000..7be6b2d36b60
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __MLX5E_DCBNL_H__
+#define __MLX5E_DCBNL_H__
+
+#ifdef CONFIG_MLX5_CORE_EN_DCB
+
+#define MLX5E_MAX_PRIORITY (8)
+
+struct mlx5e_cee_config {
+	/* bw pct for priority group */
+	u8                         pg_bw_pct[CEE_DCBX_MAX_PGS];
+	u8                         prio_to_pg_map[CEE_DCBX_MAX_PRIO];
+	bool                       pfc_setting[CEE_DCBX_MAX_PRIO];
+	bool                       pfc_enable;
+};
+
+struct mlx5e_dcbx {
+	enum mlx5_dcbx_oper_mode   mode;
+	struct mlx5e_cee_config    cee_cfg; /* pending configuration */
+	u8                         dscp_app_cnt;
+
+	/* The only setting that cannot be read from FW */
+	u8                         tc_tsa[IEEE_8021QAZ_MAX_TCS];
+	u8                         cap;
+
+	/* Buffer configuration */
+	bool                       manual_buffer;
+	u32                        cable_len;
+	u32                        xoff;
+};
+
+#define MLX5E_MAX_DSCP (64)
+
+struct mlx5e_dcbx_dp {
+	u8                         dscp2prio[MLX5E_MAX_DSCP];
+	u8                         trust_state;
+};
+
+void mlx5e_dcbnl_build_netdev(struct net_device *netdev);
+void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev);
+void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv);
+void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv);
+void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv);
+#else
+static inline void mlx5e_dcbnl_build_netdev(struct net_device *netdev) {}
+static inline void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev) {}
+static inline void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv) {}
+static inline void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv) {}
+static inline void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv) {}
+#endif
+
+#endif /* __MLX5E_DCBNL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 47874d34156b..ec7b332d74c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -35,6 +35,8 @@
 #include "en/port.h"
 #include "en/port_buffer.h"
 
+#define MLX5E_MAX_BW_ALLOC 100 /* Max percentage of BW allocation */
+
 #define MLX5E_100MB (100000)
 #define MLX5E_1GB   (1000000)
 
@@ -49,6 +51,12 @@ enum {
 	MLX5E_LOWEST_PRIO_GROUP   = 0,
 };
 
+enum {
+	MLX5_DCB_CHG_RESET,
+	MLX5_DCB_NO_CHG,
+	MLX5_DCB_CHG_NO_RESET,
+};
+
 #define MLX5_DSCP_SUPPORTED(mdev) (MLX5_CAP_GEN(mdev, qcam_reg)  && \
 				   MLX5_CAP_QCAM_REG(mdev, qpts) && \
 				   MLX5_CAP_QCAM_REG(mdev, qpdpm))
@@ -238,7 +246,7 @@ static void mlx5e_build_tc_tx_bw(struct ieee_ets *ets, u8 *tc_tx_bw,
  *   Report both group #0 and #1 as ETS type.
  *     All the tcs in group #0 will be reported with 0% BW.
  */
-int mlx5e_dcbnl_ieee_setets_core(struct mlx5e_priv *priv, struct ieee_ets *ets)
+static int mlx5e_dcbnl_ieee_setets_core(struct mlx5e_priv *priv, struct ieee_ets *ets)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 tc_tx_bw[IEEE_8021QAZ_MAX_TCS];
@@ -1009,6 +1017,24 @@ const struct dcbnl_rtnl_ops mlx5e_dcbnl_ops = {
 	.setpfcstate    = mlx5e_dcbnl_setpfcstate,
 };
 
+void mlx5e_dcbnl_build_netdev(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (MLX5_CAP_GEN(mdev, vport_group_manager) && MLX5_CAP_GEN(mdev, qos))
+		netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
+}
+
+void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (MLX5_CAP_GEN(mdev, qos))
+		netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
+}
+
 static void mlx5e_dcbnl_query_dcbx_mode(struct mlx5e_priv *priv,
 					enum mlx5_dcbx_oper_mode *mode)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 75f178a43822..07823abe5557 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -66,7 +66,6 @@
 #include "en/devlink.h"
 #include "lib/mlx5.h"
 
-
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
 	bool striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) &&
@@ -4927,10 +4926,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->netdev_ops = &mlx5e_netdev_ops;
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-	if (MLX5_CAP_GEN(mdev, vport_group_manager) && MLX5_CAP_GEN(mdev, qos))
-		netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
-#endif
+	mlx5e_dcbnl_build_netdev(netdev);
 
 	netdev->watchdog_timeo    = 15 * HZ;
 
@@ -5218,9 +5214,7 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
-#endif
 	return 0;
 }
 
@@ -5247,9 +5241,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	mlx5e_hv_vhca_stats_create(priv);
 	if (netdev->reg_state != NETREG_REGISTERED)
 		return;
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_init_app(priv);
-#endif
 
 	queue_work(priv->wq, &priv->set_rx_mode_work);
 
@@ -5264,10 +5256,8 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	if (priv->netdev->reg_state == NETREG_REGISTERED)
 		mlx5e_dcbnl_delete_app(priv);
-#endif
 
 	rtnl_lock();
 	if (netif_running(priv->netdev))
@@ -5564,9 +5554,7 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 
 	mlx5e_devlink_port_type_eth_set(priv);
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_init_app(priv);
-#endif
 	return priv;
 
 err_devlink_port_unregister:
@@ -5589,9 +5577,7 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 	}
 #endif
 	priv = vpriv;
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_delete_app(priv);
-#endif
 	unregister_netdev(priv->netdev);
 	mlx5e_devlink_port_unregister(priv);
 	mlx5e_detach(mdev, vpriv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1eac7a53d56f..52351c105627 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1544,10 +1544,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
 		netdev->ethtool_ops = &mlx5e_uplink_rep_ethtool_ops;
-#ifdef CONFIG_MLX5_CORE_EN_DCB
-		if (MLX5_CAP_GEN(mdev, qos))
-			netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
-#endif
+		mlx5e_dcbnl_build_rep_netdev(netdev);
 	} else {
 		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
 		eth_hw_addr_random(netdev);
@@ -1929,10 +1926,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
 	mlx5e_dcbnl_init_app(priv);
-#endif
 }
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
@@ -1940,9 +1935,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
-#ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_delete_app(priv);
-#endif
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
 	mlx5_lag_remove(mdev);
-- 
2.25.4

