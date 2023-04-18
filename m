Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F5F6E5C0F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjDRIb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjDRIbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:31:47 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A84F7690
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYgR7QSap0PMthfB88d84/okukzxpBLhk6fh0ZC/QY8Kc31gMB+K+AJKTeVg2Bjk5+Fjol+nm7KqIUkAdbNqNz+0yQZiPqV1BV+P9hgf8EtmSBpNb4ihbsdnrRYTGHg7z+3Ld9+yoMKSdBHsUHEHZgT3LYH78fnE7rXzB7fLWXrcNq/tZCbvrcm5sPxOroB6ZmwtNwdAS3qEmVmvpTGPPWUIZN8jRjcblCMai5OFk15MpLhx+oi/BkMRkOUMSqGBdCrvyWyIin4BIrFa/O+BsSh/fJoHMYVUA3wh/pYApWZijJeOXkQlL/DdwmDadTOfi3JsTxn6k2apDiYMKUViPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD5LJvESE0ywvUQrTdihmnl6iVGTLoKGjjm8XwEa8cI=;
 b=B2kZ67WMkomnV9EApSS6SzqvcYaISzR+o/hh7pL0AsE/yKrEYxmt5qchCuWxAbJG8CtoRk9FeLmWhhzvePlgLIDsw6cQCEPbKYCrHIJ9I3rDgTU1IjPKbPk5JnwWbs5Toqz8zkk/yXXMR7Ix7BRnP3OlPgOBQ+yK2Tw66+ljbGTEyBwH+oj5DFTQ1pnb3v2EoSpmsbYihkhVXPlQBK5CqvI5RqlTCKf3h8DjQo62sSNxMjPxQk6RafURDC+ViMcjA9er39O/cYZuwjn8Nm+yHG4jBoSYSgD7YA8PPTW/7HIxy7b5QJXDGKXqTqC9pltuZbeB6KglCcN9ZG/dnHF7eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD5LJvESE0ywvUQrTdihmnl6iVGTLoKGjjm8XwEa8cI=;
 b=Kai8Vt6YeNL8MiXlE30Qy17N9Yvh7wZP2cbbc4F1e+I8lWB57dqVD6Mc+N6lhABVRg8vnD0aeaZd8RqimWy/CyP7s4W97RIjFnTiEb0P9q7WI03jyMw6tULbd2kb/+Q7wZMKT3yjVKuk4rJ7eHjhjIkCdbraJsxVE7cfq7p9CgF1QfoM3F3KjSqzto52P9GpUWIZ6lG7GXL9Cg/EVe5pdBAMzuxw8vf6ZaJY9d/bygtZx6xqwKAJJgmHc7YIhxfbcFRNpyTQSL6cWob1TxyY3hVfVZO7R7coK5Fy/gvz1nTF/mhU5UUHWJnadBhsjt/KvQkaAq0Dn+gtKf8LSuAiFQ==
Received: from MW4PR03CA0126.namprd03.prod.outlook.com (2603:10b6:303:8c::11)
 by CY5PR12MB6155.namprd12.prod.outlook.com (2603:10b6:930:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:31:28 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::eb) by MW4PR03CA0126.outlook.office365.com
 (2603:10b6:303:8c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:16 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:14 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 3/5] net/mlx5: Support MACsec over VLAN
Date:   Tue, 18 Apr 2023 11:31:00 +0300
Message-ID: <20230418083102.14326-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230418083102.14326-1-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|CY5PR12MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: 39684033-d4f5-4d10-6cbe-08db3fe74dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VnY+K+5yTrdv8T153c4Q/cyAPYuBG1/Z7z25PGlOQ5PY89gDAu71s1xWwEOf0NGeculVSd9qJ8DBLS9jywUL2s1tHufGS1aNVQFqAyWZFdcFJoJo9pIvKtxvcoCcT9v0CQ53Pu50qVuLKAw2iYkFihOVYMJUI6Qzsd8sIlK3pvkLuNo1ypqS80zfGfDWtMJX6SXkrUV/Jwkk8xoHJOv6nDCvkZidZUq6TI8JFbatElA4Jk0LQBZPU7JBTy7zoHMCRiU4Le7GSzgzVzf0fMyD7vOLlstG6HIaE6NyFNfIS6lutBG9Nce7+rr6zQPpJRM+OO6hMI+enLAezoHgEip9KrbVi/Npkfh1S5GevuFCflBZ0lXNLLv4AiwuX6Cly/vXUPlln085szzqINLk6BrPsMR9XWXwOc73Z8hpM7J6T+cnIdmlEjv7EfJedZRA2kLdnnu2gDN2okLR+mifIYnFdqRRe/U8AhqlChHFKFaLU7TXJmhH4Y/FZin8sQf+syUSYThZKiN1+cqLWVzD4XFtsTnvZiLeKhZQNclQ16H4Yf+mI0kbC/uXZJ2OPMgLLjwDePgFsQ7HpAKNYLppY6y1NwLQd10WdLQCcPqTZeK4uLipI2xzXE0B440D18pX08xbC/H1+qeZUrDHIPvg213Hp+cmvT/rWgBnZ+mIzPWM0QVWxLpw1z86n1s3rWMDwZ2botpuSE9fAV8oQpWkJRLOc0r5pCWu1UJwT8gRIAu8FdZjhVI7T5P7Hi3f2V4WkpIiJ2xLjBVH4NqLGIM/m9Tfrw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(36756003)(4326008)(110136005)(54906003)(316002)(70586007)(70206006)(7696005)(478600001)(6666004)(41300700001)(5660300002)(82310400005)(8676002)(8936002)(40480700001)(2906002)(34020700004)(82740400003)(86362001)(356005)(426003)(2616005)(336012)(107886003)(40460700003)(1076003)(26005)(186003)(36860700001)(47076005)(83380400001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:27.6415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39684033-d4f5-4d10-6cbe-08db3fe74dc0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6155
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MACsec device may have a VLAN device on top of it.
Detect MACsec state correctly under this condition,
and return the correct net device accordingly.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 33b3620ea45c..79b523ded87b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -4,6 +4,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/xarray.h>
+#include <linux/if_vlan.h>
 
 #include "en.h"
 #include "lib/aso.h"
@@ -348,12 +349,21 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
 	sa->macsec_rule = NULL;
 }
 
+static inline struct mlx5e_priv *macsec_netdev_priv(const struct net_device *dev)
+{
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+	if (is_vlan_dev(dev))
+		return netdev_priv(vlan_dev_priv(dev)->real_dev);
+#endif
+	return netdev_priv(dev);
+}
+
 static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 				struct mlx5e_macsec_sa *sa,
 				bool encrypt,
 				bool is_tx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
 	struct mlx5_macsec_rule_attrs rule_attrs;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -427,7 +437,7 @@ static int macsec_rx_sa_active_update(struct macsec_context *ctx,
 				      struct mlx5e_macsec_sa *rx_sa,
 				      bool active)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec *macsec = priv->macsec;
 	int err = 0;
 
@@ -508,9 +518,9 @@ static void update_macsec_epn(struct mlx5e_macsec_sa *sa, const struct macsec_ke
 
 static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct macsec_secy *secy = ctx->secy;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -583,9 +593,9 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -645,7 +655,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -696,7 +706,7 @@ static u32 mlx5e_macsec_get_sa_from_hashtable(struct rhashtable *sci_hash, sci_t
 static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 {
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -776,7 +786,7 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sc *ctx_rx_sc = ctx->rx_sc;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -854,7 +864,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
 
 static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec *macsec;
@@ -890,8 +900,8 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 
 static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 assoc_num = ctx->sa.assoc_num;
@@ -976,8 +986,8 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_rx_sa *ctx_rx_sa = ctx->sa.rx_sa;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	u8 assoc_num = ctx->sa.assoc_num;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -1033,7 +1043,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	sci_t sci = ctx->sa.rx_sa->sc->sci;
 	struct mlx5e_macsec_rx_sc *rx_sc;
@@ -1085,7 +1095,7 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 
 static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	const struct net_device *netdev = ctx->netdev;
 	struct mlx5e_macsec_device *macsec_device;
@@ -1137,7 +1147,7 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
 				      struct mlx5e_macsec_device *macsec_device)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	struct mlx5e_macsec *macsec = priv->macsec;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
@@ -1184,8 +1194,8 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
  */
 static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 {
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
 	const struct net_device *dev = ctx->secy->netdev;
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -1240,7 +1250,7 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 
 static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 {
-	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5e_macsec_device *macsec_device;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
 	struct mlx5e_macsec_sa *tx_sa;
@@ -1741,7 +1751,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 {
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
 	u32 macsec_meta_data = be32_to_cpu(cqe->ft_metadata);
-	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_priv *priv = macsec_netdev_priv(netdev);
 	struct mlx5e_macsec_rx_sc *rx_sc;
 	struct mlx5e_macsec *macsec;
 	u32  fs_id;
-- 
2.21.3

