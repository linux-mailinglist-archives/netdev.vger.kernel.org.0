Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9896DBA4D
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjDHK6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDHK6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CAAC7
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:58:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYF9b2xq4IQOlGbc0VHuQOq0dyowhCksfDyAbJPFo1JIYJAgMHkga7hNmr6xZtJYmqHrFpWW+IGzLUBJV52Nv3/Jvqk4tupIlsugoy4fY+aW/urrTVbIqJM17Hex0LPRhWaZRuWhCfMUD9b67EHQjKdEIMgntupP0ADINnzRr0IYBWxPH2EU2TA3oEN+HhBCjUm/OYIZ0L4hA+Sedi97C4dD4fBrhe7p7n3T4e/fuzCW7C/SoN8iL9oTBJbJtoaa6CnxP5yOiifLP/6MMGRMTDwgtbv+go/oNZEoK7cC5YArBoDustHGGxL4uZwPmzdC6fIB8p3HNk+mf+ayKWBmxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD5LJvESE0ywvUQrTdihmnl6iVGTLoKGjjm8XwEa8cI=;
 b=CcbrhyCxu5f5hTznEv0e+HI0cNfUe5uK4qOQRKOkfEVD2MPdPG7JmyiNeEUw2r6skiog6Y6zAhMidOmLPhkVB+eYPRDRQLldaKu2ifVmM1I1+t8yE1DnA3vONxHJcQSSs5tDfaes61C020Ntx/i9uheuxIl0EYG2kGLQ2uHNzxQ4gUqau2TW9CCn6sIjsyxXriqStp3+3rbwBgZi7M3Yu5vrDM+kfg8s+nR5dPpw4eqHdLwOPqmacn/kHQ0bJgfu5eytsh84n+y4/rpxNgrDgjpPCKb2znmISysn+D+xBDz2ONtD0rJIppQmO9XRQs/4add49i9b0g0ODtOhXVxSQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD5LJvESE0ywvUQrTdihmnl6iVGTLoKGjjm8XwEa8cI=;
 b=lvzJ/Vq6RKKPEdcjXWfAVOO0SKTqkUH0P/KRDh4uZ7nDtIunzEga4B1JYJbt8X12Gs/ASTqbTy1Zzo6Dunw+NC630jdByOX/3R0TOdCA+KdD74/9k1Jq1GupI4HAmh5r2rPC5f351d3CeRGsdo+Jsvi0k5/SZkYdDv5A4QJxxFiFvqd47blz/5hlSGZ/sGigjlFdQQrDjVdoOtQ0idcVj8G3KAadgWwBJj3mEuBg/gT2SeR2zyHtsviJppuxOeWg2lh7wfKnisaHRSAWUKrBKpXqU0DhIFCfDyy6wxr48+xsw/k+H5Isp67PPkdBTP6rM2gKrGclmEKV99Yp36Mm4w==
Received: from DM6PR02CA0162.namprd02.prod.outlook.com (2603:10b6:5:332::29)
 by MW4PR12MB6923.namprd12.prod.outlook.com (2603:10b6:303:208::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 10:58:00 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::26) by DM6PR02CA0162.outlook.office365.com
 (2603:10b6:5:332::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35 via Frontend
 Transport; Sat, 8 Apr 2023 10:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.21 via Frontend Transport; Sat, 8 Apr 2023 10:57:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:48 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:48 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:46 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 3/5] net/mlx5: Support MACsec over VLAN
Date:   Sat, 8 Apr 2023 13:57:33 +0300
Message-ID: <20230408105735.22935-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230408105735.22935-1-ehakim@nvidia.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|MW4PR12MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d24118a-42e1-4042-cde2-08db38201e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qKTa37kp7TzNU9f4U5H8hGUsDR4udBPoAm5aK2T3ryTj6iJ/wOOaHNmglvlaW8QbB/9Lno+tEAERy8Svtc/LMYMVdEGbUxr0eWINpjgZtOLF4C/XnLrZvCyZOcZAdVO/ln1BJIJ42gxOVPt6dTu9ZXlKMID+pktRwMBumEVm92OTdzZ/c+d54N4xScmo2e9UTVo10l9n8urx7amRG5+Z8/IZEY1RHO3+nTBDibA2PngqLYXSa4UUVWQPS7akW8guzZ49c3yhVFtKq7YGUO/5z0GNUH2hneSRVrp9OXKe4UD0niOHKLd6asQETh/go7jwZaG49shxbufydo9MMfvidfdDpFbkXfThRXWfZyF0rZSL2/WWNzHrrLm7r1U5GgKJ4e2z+lhNC3Q1u292fUWWA9Brq0WUD4YXUsNe7Pz669T/0J4iozqZJHd+PrLyadtu83xO5aj9Q3vPI22JEsFehYy32+1p0qY994y4S+xreNbgQvxbGv+keaPXYHyOfVYrUpiFrGpOZ0ZoAN7w1l54EjNoHsB4lQQ08VFJQ7M8fU/79TX86fTnQ734277KgCps/QH9NE9jByO+ETC8zOHdhjlZwHJOcJe2ZZa30QV4cYc6RsKRBWAUAile+U5U1YNTl5DkTTH0edGdd8NnKeLMcW4SNcLd+w2sjlyIzyIXjafbfm9UErPMFt8rLM+m5gNsqb1gkDNeuMFu+ockcfnH8VHXYMXV7117NhqZqqLVPUVJ+z5kEEz9AE5t3TwwweOh
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199021)(46966006)(36840700001)(40470700004)(7696005)(478600001)(86362001)(40480700001)(47076005)(83380400001)(36756003)(40460700003)(82740400003)(7636003)(356005)(2616005)(36860700001)(426003)(336012)(107886003)(6666004)(2906002)(54906003)(110136005)(316002)(186003)(1076003)(26005)(8676002)(41300700001)(8936002)(5660300002)(82310400005)(4326008)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:57:59.5809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d24118a-42e1-4042-cde2-08db38201e08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6923
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

