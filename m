Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE21B1854
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgDTVXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:13 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:60862
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbgDTVXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBP/mR3dZveaQM+EpUq0xFDiPa4lfYwmyM4vYyXHejwoA1BuK4BEAR28UnlhAP5L+Oxo31w4cG/ET0fwmBBRQcBs97R5sk8QU1K+zk+ZzKAwQFl/W7rSiSRvqElVkcJlMG8AWar1IxMyrJtcNZtPD5UuKI2U3ovcSFEPiYlSPYB3P5auJsW5NbB2bC0p0H9MqVXZ5Vd/YbdSjalkV4vxw+4XH7IOAd7GzroE4fvneA4tbTFPQEF7XYYzn4c0dM035gOfQtAIvCDERnMpoX4qxYlYGfgvNIvQeMzoMM1kPWr3PEa3eeLA5DKv5kx/Yjm4FPpvCeoMp6o3NGhfZRSiYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDhJa4RsDaVz9zqqIr1ncu0fXWYcK8LaUo4LO8VJnK0=;
 b=C3N6IqFBF/9TFPLOk+sLFNkzaCF/Vk3TZATQHfFd2zMGUlDqbfsKliD6IC3A/EYpRFFMF5LMTT8zoIF5IvmUZtl/wyOFMCQWcD0ildGN5mNPcby4Cc4bps3HfLQS8NNU4ZiZjxqQ6fHPfWVOWShUqbYTfovo2KCB54Zs+4F2fMIiJLz1SpVPezg1DJXayVUI8f6MJUZIRz9uCX2GD0xAEeHP1/Moqs6VBWkZEWnjiWEbqlfRa6Ec4p2JWSVRzYGwXvrH7skAJXX7Oqlg+ndll0alU2eBq7kThC3xjnILeHzdjBfwGr/fwojqZDcArcoiv1ANNLeZSX2h5ra30B2nhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDhJa4RsDaVz9zqqIr1ncu0fXWYcK8LaUo4LO8VJnK0=;
 b=Bc0LPqrsXm2MdjPnu1kAMgvi9ZOd3NcTCx/bljemMIZ9kLg98bGETGz8N/vZWRPefZtQVlUGP1r6wRI3XZa3YPzQg1Wfq2l5onPuWbV7ypBs3DjfHcidH3OFihuV30uDpONXdmQkViEPsmFN7DFxwm9shpZeL9aQneEEXLN12Rc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/10] net/mlx5e: IPSec, Expose IPsec HW stat only for supporting HW
Date:   Mon, 20 Apr 2020 14:22:17 -0700
Message-Id: <20200420212223.41574-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:03 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d407218e-8eb7-4a6c-2f2d-08d7e571039c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64789E976FEDA697867ECECCBED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Kv8ZRxiRCLhk1dw1AWV2ja9vSf30jbYTnIXbo14CGoDVYk9qNiuaRkN2vlOqoeAyTQERW2+/d89OoBowKjTZIevFedN9hgEWiTpnRZqb98KRODpUSCqSN2SQtzBCPm4P1yyNE8C3aNwiBVetq8VO0qedH+TJTPDdaLysYkI48fEFSMwthHu2mCDCZlJPQxqNTGldZj1+36EcivU/tqUvpz7mGOWVk7nHS1jo0BG+I1BBU/omDu7eXI3OsOx0+C6rTZa6KrVTIKml9InwiQ2n25Gfx/nqZajOM1u9vRbYmznAfocN1CR/Yzf90fjIvzR/xvVLDMf3aFu2LS1nsebR0T7PgvgROZiSFlQL/OMJh9y9/4TPsARhCJD5F0kGSuKlo43L+AAkjdU8C7Sh4aQFVnxUh1aL6tApaUZGJWpAZBYEGcZtdZ1dcar1jrjKOINhtexXEnKfTpsXNY6bOm3WXPys55AbSTsjebz05RKkNMl3JZsi71UK8CVa8Pgwjs+
X-MS-Exchange-AntiSpam-MessageData: JJJw6pyiBGumSldRSygl0NpvSTF4qRLG/rTDef6ao2m13MabNWwuTeeKNUc594//3f00c6NU4NTjZhepxTjnNJaqXeOlkXFRObRgL3a0/pxLBmDCsTw+9OwGDOaXITXQk75OidW+yoA4wkKHgAUQsA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d407218e-8eb7-4a6c-2f2d-08d7e571039c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:05.3365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9fMds1l+Zrx20EJ8/pLg8XjjXSFCgqC80ABv9/27WJE3t9ubjaY95/x4P8Mivoi7wH90r/khy5KirSeXsIptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The current HW counters are supported only by Innova, split the ipsec
stats group into two groups, one for HW and one for SW. And expose
the HW counters to ethtool only if Innova HW is used for IPsec offload.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 25 ------
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c | 88 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 29 ++----
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
 4 files changed, 58 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 93bf10e6508c..c85151a1e008 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -109,11 +109,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv);
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv);
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
 
-int mlx5e_ipsec_get_count(struct mlx5e_priv *priv);
-int mlx5e_ipsec_get_strings(struct mlx5e_priv *priv, uint8_t *data);
-void mlx5e_ipsec_update_stats(struct mlx5e_priv *priv);
-int mlx5e_ipsec_get_stats(struct mlx5e_priv *priv, u64 *data);
-
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 					      unsigned int handle);
 
@@ -136,26 +131,6 @@ static inline void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
-static inline int mlx5e_ipsec_get_count(struct mlx5e_priv *priv)
-{
-	return 0;
-}
-
-static inline int mlx5e_ipsec_get_strings(struct mlx5e_priv *priv,
-					  uint8_t *data)
-{
-	return 0;
-}
-
-static inline void mlx5e_ipsec_update_stats(struct mlx5e_priv *priv)
-{
-}
-
-static inline int mlx5e_ipsec_get_stats(struct mlx5e_priv *priv, u64 *data)
-{
-	return 0;
-}
-
 #endif
 
 #endif	/* __MLX5E_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 6fea59223dc4..6c5c54bcd9be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -38,6 +38,7 @@
 #include "accel/ipsec.h"
 #include "fpga/sdk.h"
 #include "en_accel/ipsec.h"
+#include "fpga/ipsec.h"
 
 static const struct counter_desc mlx5e_ipsec_hw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_stats, ipsec_dec_in_packets) },
@@ -73,61 +74,74 @@ static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 #define NUM_IPSEC_HW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_hw_stats_desc)
 #define NUM_IPSEC_SW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_sw_stats_desc)
 
-#define NUM_IPSEC_COUNTERS (NUM_IPSEC_HW_COUNTERS + NUM_IPSEC_SW_COUNTERS)
-
-int mlx5e_ipsec_get_count(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_sw)
 {
-	if (!priv->ipsec)
-		return 0;
-
-	return NUM_IPSEC_COUNTERS;
+	return NUM_IPSEC_SW_COUNTERS;
 }
 
-int mlx5e_ipsec_get_strings(struct mlx5e_priv *priv, uint8_t *data)
-{
-	unsigned int i, idx = 0;
+static inline MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_sw) {}
 
-	if (!priv->ipsec)
-		return 0;
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec_sw)
+{
+	unsigned int i;
 
-	for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
-		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       mlx5e_ipsec_hw_stats_desc[i].format);
+	if (priv->ipsec)
+		for (i = 0; i < NUM_IPSEC_SW_COUNTERS; i++)
+			strcpy(data + (idx++) * ETH_GSTRING_LEN,
+			       mlx5e_ipsec_sw_stats_desc[i].format);
+	return idx;
+}
 
-	for (i = 0; i < NUM_IPSEC_SW_COUNTERS; i++)
-		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       mlx5e_ipsec_sw_stats_desc[i].format);
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_sw)
+{
+	int i;
 
-	return NUM_IPSEC_COUNTERS;
+	if (priv->ipsec)
+		for (i = 0; i < NUM_IPSEC_SW_COUNTERS; i++)
+			data[idx++] = MLX5E_READ_CTR_ATOMIC64(&priv->ipsec->sw_stats,
+							      mlx5e_ipsec_sw_stats_desc, i);
+	return idx;
 }
 
-void mlx5e_ipsec_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_hw)
 {
-	int ret;
+	return (mlx5_fpga_ipsec_device_caps(priv->mdev)) ? NUM_IPSEC_HW_COUNTERS : 0;
+}
 
-	if (!priv->ipsec)
-		return;
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_hw)
+{
+	int ret = 0;
 
-	ret = mlx5_accel_ipsec_counters_read(priv->mdev, (u64 *)&priv->ipsec->stats,
-					     NUM_IPSEC_HW_COUNTERS);
+	if (priv->ipsec)
+		ret = mlx5_accel_ipsec_counters_read(priv->mdev, (u64 *)&priv->ipsec->stats,
+						     NUM_IPSEC_HW_COUNTERS);
 	if (ret)
 		memset(&priv->ipsec->stats, 0, sizeof(priv->ipsec->stats));
 }
 
-int mlx5e_ipsec_get_stats(struct mlx5e_priv *priv, u64 *data)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec_hw)
 {
-	int i, idx = 0;
-
-	if (!priv->ipsec)
-		return 0;
+	unsigned int i;
 
-	for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
-		data[idx++] = MLX5E_READ_CTR64_CPU(&priv->ipsec->stats,
-						   mlx5e_ipsec_hw_stats_desc, i);
+	if (priv->ipsec && mlx5_fpga_ipsec_device_caps(priv->mdev))
+		for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
+			strcpy(data + (idx++) * ETH_GSTRING_LEN,
+			       mlx5e_ipsec_hw_stats_desc[i].format);
 
-	for (i = 0; i < NUM_IPSEC_SW_COUNTERS; i++)
-		data[idx++] = MLX5E_READ_CTR_ATOMIC64(&priv->ipsec->sw_stats,
-						      mlx5e_ipsec_sw_stats_desc, i);
+	return idx;
+}
 
-	return NUM_IPSEC_COUNTERS;
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_hw)
+{
+	int i;
+
+	if (priv->ipsec && mlx5_fpga_ipsec_device_caps(priv->mdev))
+		for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
+			data[idx++] = MLX5E_READ_CTR64_CPU(&priv->ipsec->stats,
+							   mlx5e_ipsec_hw_stats_desc,
+							   i);
+	return idx;
 }
+
+MLX5E_DEFINE_STATS_GRP(ipsec_sw, 0);
+MLX5E_DEFINE_STATS_GRP(ipsec_hw, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 30b216d9284c..6eb0e8236bbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -32,8 +32,8 @@
 
 #include "lib/mlx5.h"
 #include "en.h"
-#include "en_accel/ipsec.h"
 #include "en_accel/tls.h"
+#include "en_accel/en_accel.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -1424,27 +1424,6 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(pme)
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(pme) { return; }
 
-static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec)
-{
-	return mlx5e_ipsec_get_count(priv);
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec)
-{
-	return idx + mlx5e_ipsec_get_strings(priv,
-					     data + idx * ETH_GSTRING_LEN);
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec)
-{
-	return idx + mlx5e_ipsec_get_stats(priv, data + idx);
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec)
-{
-	mlx5e_ipsec_update_stats(priv);
-}
-
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(tls)
 {
 	return mlx5e_tls_get_count(priv);
@@ -1714,7 +1693,6 @@ MLX5E_DEFINE_STATS_GRP(pme, 0);
 MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
 MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
-static MLX5E_DEFINE_STATS_GRP(ipsec, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
 
 /* The stats groups order is opposite to the update_stats() order calls */
@@ -1731,7 +1709,10 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(pcie),
 	&MLX5E_STATS_GRP(per_prio),
 	&MLX5E_STATS_GRP(pme),
-	&MLX5E_STATS_GRP(ipsec),
+#ifdef CONFIG_MLX5_EN_IPSEC
+	&MLX5E_STATS_GRP(ipsec_sw),
+	&MLX5E_STATS_GRP(ipsec_hw),
+#endif
 	&MLX5E_STATS_GRP(tls),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 092b39ffa32a..2b83ba990714 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -390,5 +390,7 @@ extern MLX5E_DECLARE_STATS_GRP(per_prio);
 extern MLX5E_DECLARE_STATS_GRP(pme);
 extern MLX5E_DECLARE_STATS_GRP(channels);
 extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
+extern MLX5E_DECLARE_STATS_GRP(ipsec_hw);
+extern MLX5E_DECLARE_STATS_GRP(ipsec_sw);
 
 #endif /* __MLX5_EN_STATS_H__ */
-- 
2.25.3

