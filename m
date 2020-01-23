Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D48914620E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAWGkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:04 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbgAWGkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARp3zicvj7GL4xcUsJ3ebR2vLyTR5BFlnAVPj02mMN2wRKPqPyqO+5h86vlnwDy1LMM42VxB+wrP+0FxzoAU01K/JGZ3G2zwDGLE8dimw+FjChISMQfQVSk6iufN3v5vFzuB+eLdoEZP0mHDsyOQVKHOaP/Uf9mhyqBg/g2cHVDY1UstRr+X0bj48TmhW2IgR9nLMxGB7Ya6U0VwCDkyLYS2KrY3AoE+IxaK5RUXqjv4hjm049kd8I5q9r07tFXq4GaOLALWG3y80OmZwWc1MnquBlgBKD7h/kfeMqSqk/n4ojgcVfszMG5nRJJfJD/BXv+iEA4wKLGiR991sqbYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/ckpulaK3Dix+G2h2AJXFe0eAV1l2Kyw4Z7q1my7bo=;
 b=CLEIdmCveLZBUgM+k2QRr5f5WIRoqgwnHLApshXghcjWpC2bfU+rSoOkA1IFRcEqB2GHoVua5vWrWtoJ5hrM28YV2KIv5VfN0lhcpd/Mc/7WHAEIiotresxPSVaYtN4f5YTjVNcI2JMrwWgpR70gh4PD9AeOTmgKRhGdkAOAkJG5f1XbaD/xFfRKsBw8keuK32zipWAt7hlWm1XJ6TWSj6UEDiZO8S6Q6O7bzZ/WrDK+0xAzSB5vXw0HoBdutkHI+aPfNmPk4nMu+N0VElHVoQv8ZdrnBR9gVu3RaiZXyHBOEOkQPXJ5Sx5WLR1KhpSFlLUJsaDVHp1zyHQ79/BagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/ckpulaK3Dix+G2h2AJXFe0eAV1l2Kyw4Z7q1my7bo=;
 b=l2jN006z7tx7MY9ojE0HEa6y9/WR4vz2qhGlwHiExX+o+CfUTSZE/kOUXVepROUG1Iuhex4rks0AwgKmkgEmSWwc43SuJS80cCUzHM9K2YpXBNFCUIo8UeBjbJaN375FroHSRfZ6XnViaAUfoQJN5WJXmYy9h7p+doZmyN2LryE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:53 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 09/15] net/mlx5e: Profile specific stats groups
Thread-Topic: [net-next 09/15] net/mlx5e: Profile specific stats groups
Thread-Index: AQHV0bfrEZiqyApYLkmQC5/yBvZ5bA==
Date:   Thu, 23 Jan 2020 06:39:53 +0000
Message-ID: <20200123063827.685230-10-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 459e3c16-25a9-4ba6-2fe5-08d79fcf0d6b
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941CABCD9F7A1B471D9186CBE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(30864003)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /cep3O5v/oYQuq9cHrSf/kwpigjAlsokGYI91GvVlYsSWNUhw7UKqSe2X3kgFKJxw40Pkq4buexZant3uheM1fZU0QebIrQeZKx5MzlLm4PoNzlztobKbWZnZjHky0Sa25psjW5OdA6762J+2p5AawfTQ6k9wvjv3xD6l9vwImy78YHhRPyu+2AVaeMte/md6eVcMjPkmT524iWeG/QmpfMdw3pfNFm12BEQPYg/rkTxnL0kBohYqwF1nvM2HlWc8hxue/9bdXivCLDKH5QmspNZqM3z3n8cxajt+oAs1ITVSJ0dN45Ak6Mj75wIOplM1+omg+crs3wHYSrmakGm2V1SUeBTdBtGBZbxaBert8XRJM53ND0rFNOqn8NgCRy34NHNfIFzH8kPiQmg30MuAG365RJTasJP9H8EeK4z9wJgKW9ptu/9uIsWkAgHDCZ36hUe4tC7QXG5NBfTrxdoLEQ6mb/ICvrBM+FzhHodACNjCn1i99mmLnsqfh1zAvNHGPMwsEDGRsA7bYFrcZ2yXtOxlqPqOt4ZrdobHauE4OU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459e3c16-25a9-4ba6-2fe5-08d79fcf0d6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:53.2827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3dxSfChhcdNnDn9vjz2x4RhCRribbpj7mkJnmUauJ0a5xILdXEfjwIsUNflh0Y+Ia5XdCv3jkhb2pwamFw8XTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attach stats groups array to the profiles and make the stats utility
functions (get_num, update, fill, fill_strings) generic and use the
profile->stats_grps rather the hardcoded NIC stats groups.

This will allow future extension to have per profile stats groups.

In this patch mlx5e NIC and IPoIB will still share the same stats
groups.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 23 ++------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 17 ++----
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 59 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 37 +++++++-----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +
 6 files changed, 93 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index fc80b59db9a8..f85d99d601a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -892,6 +892,8 @@ struct mlx5e_profile {
 	int	(*update_rx)(struct mlx5e_priv *priv);
 	void	(*update_stats)(struct mlx5e_priv *priv);
 	void	(*update_carrier)(struct mlx5e_priv *priv);
+	unsigned int (*stats_grps_num)(struct mlx5e_priv *priv);
+	const struct mlx5e_stats_grp *stats_grps;
 	struct {
 		mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 		mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
@@ -964,7 +966,6 @@ struct sk_buff *
 mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt);
=20
-void mlx5e_update_stats(struct mlx5e_priv *priv);
 void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *sta=
ts);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats=
64 *s);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c6776f308d5e..d674cb679895 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -218,13 +218,9 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_=
NUM_PFLAGS];
=20
 int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 {
-	int i, num_stats =3D 0;
-
 	switch (sset) {
 	case ETH_SS_STATS:
-		for (i =3D 0; i < mlx5e_num_stats_grps; i++)
-			num_stats +=3D mlx5e_stats_grps[i].get_num_stats(priv);
-		return num_stats;
+		return mlx5e_stats_total_num(priv);
 	case ETH_SS_PRIV_FLAGS:
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
@@ -242,14 +238,6 @@ static int mlx5e_get_sset_count(struct net_device *dev=
, int sset)
 	return mlx5e_ethtool_get_sset_count(priv, sset);
 }
=20
-static void mlx5e_fill_stats_strings(struct mlx5e_priv *priv, u8 *data)
-{
-	int i, idx =3D 0;
-
-	for (i =3D 0; i < mlx5e_num_stats_grps; i++)
-		idx =3D mlx5e_stats_grps[i].fill_strings(priv, data, idx);
-}
-
 void mlx5e_ethtool_get_strings(struct mlx5e_priv *priv, u32 stringset, u8 =
*data)
 {
 	int i;
@@ -268,7 +256,7 @@ void mlx5e_ethtool_get_strings(struct mlx5e_priv *priv,=
 u32 stringset, u8 *data)
 		break;
=20
 	case ETH_SS_STATS:
-		mlx5e_fill_stats_strings(priv, data);
+		mlx5e_stats_fill_strings(priv, data);
 		break;
 	}
 }
@@ -283,14 +271,13 @@ static void mlx5e_get_strings(struct net_device *dev,=
 u32 stringset, u8 *data)
 void mlx5e_ethtool_get_ethtool_stats(struct mlx5e_priv *priv,
 				     struct ethtool_stats *stats, u64 *data)
 {
-	int i, idx =3D 0;
+	int idx =3D 0;
=20
 	mutex_lock(&priv->state_lock);
-	mlx5e_update_stats(priv);
+	mlx5e_stats_update(priv);
 	mutex_unlock(&priv->state_lock);
=20
-	for (i =3D 0; i < mlx5e_num_stats_grps; i++)
-		idx =3D mlx5e_stats_grps[i].fill_stats(priv, data, idx);
+	mlx5e_stats_fill(priv, data, idx);
 }
=20
 static void mlx5e_get_ethtool_stats(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 87267c18ff8c..a1bb9eb8e3b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -159,23 +159,14 @@ static void mlx5e_update_carrier_work(struct work_str=
uct *work)
 	mutex_unlock(&priv->state_lock);
 }
=20
-void mlx5e_update_stats(struct mlx5e_priv *priv)
-{
-	int i;
-
-	for (i =3D mlx5e_num_stats_grps - 1; i >=3D 0; i--)
-		if (mlx5e_stats_grps[i].update_stats)
-			mlx5e_stats_grps[i].update_stats(priv);
-}
-
 void mlx5e_update_ndo_stats(struct mlx5e_priv *priv)
 {
 	int i;
=20
-	for (i =3D mlx5e_num_stats_grps - 1; i >=3D 0; i--)
-		if (mlx5e_stats_grps[i].update_stats_mask &
+	for (i =3D mlx5e_nic_stats_grps_num(priv) - 1; i >=3D 0; i--)
+		if (mlx5e_nic_stats_grps[i].update_stats_mask &
 		    MLX5E_NDO_UPDATE_STATS)
-			mlx5e_stats_grps[i].update_stats(priv);
+			mlx5e_nic_stats_grps[i].update_stats(priv);
 }
=20
 static void mlx5e_update_stats_work(struct work_struct *work)
@@ -5197,6 +5188,8 @@ static const struct mlx5e_profile mlx5e_nic_profile =
=3D {
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc		   =3D MLX5E_MAX_NUM_TC,
 	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(XSK),
+	.stats_grps	   =3D mlx5e_nic_stats_grps,
+	.stats_grps_num	   =3D mlx5e_nic_stats_grps_num,
 };
=20
 /* mlx5e generic netdev management API (move to en_common.c) */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 4291db78efc9..a8baa6298d95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -35,6 +35,58 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/tls.h"
=20
+static unsigned int stats_grps_num(struct mlx5e_priv *priv)
+{
+	return !priv->profile->stats_grps_num ? 0 :
+		priv->profile->stats_grps_num(priv);
+}
+
+unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv)
+{
+	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	const unsigned int num_stats_grps =3D stats_grps_num(priv);
+	unsigned int total =3D 0;
+	int i;
+
+	for (i =3D 0; i < num_stats_grps; i++)
+		total +=3D stats_grps[i].get_num_stats(priv);
+
+	return total;
+}
+
+void mlx5e_stats_update(struct mlx5e_priv *priv)
+{
+	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	const unsigned int num_stats_grps =3D stats_grps_num(priv);
+	int i;
+
+	for (i =3D num_stats_grps - 1; i >=3D 0; i--)
+		if (stats_grps[i].update_stats)
+			stats_grps[i].update_stats(priv);
+}
+
+void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx)
+{
+	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	const unsigned int num_stats_grps =3D stats_grps_num(priv);
+	int i;
+
+	for (i =3D 0; i < num_stats_grps; i++)
+		idx =3D stats_grps[i].fill_stats(priv, data, idx);
+}
+
+void mlx5e_stats_fill_strings(struct mlx5e_priv *priv, u8 *data)
+{
+	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	const unsigned int num_stats_grps =3D stats_grps_num(priv);
+	int i, idx =3D 0;
+
+	for (i =3D 0; i < num_stats_grps; i++)
+		idx =3D stats_grps[i].fill_strings(priv, data, idx);
+}
+
+/* Concrete NIC Stats */
+
 static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_bytes) },
@@ -1669,7 +1721,7 @@ static int mlx5e_grp_channels_fill_stats(struct mlx5e=
_priv *priv, u64 *data,
 }
=20
 /* The stats groups order is opposite to the update_stats() order calls */
-const struct mlx5e_stats_grp mlx5e_stats_grps[] =3D {
+const struct mlx5e_stats_grp mlx5e_nic_stats_grps[] =3D {
 	{
 		.get_num_stats =3D mlx5e_grp_sw_get_num_stats,
 		.fill_strings =3D mlx5e_grp_sw_fill_strings,
@@ -1768,4 +1820,7 @@ const struct mlx5e_stats_grp mlx5e_stats_grps[] =3D {
 	},
 };
=20
-const int mlx5e_num_stats_grps =3D ARRAY_SIZE(mlx5e_stats_grps);
+unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
+{
+	return ARRAY_SIZE(mlx5e_nic_stats_grps);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 869f3502f631..06eeedaacb88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -55,6 +55,26 @@ struct counter_desc {
 	size_t		offset; /* Byte offset */
 };
=20
+enum {
+	MLX5E_NDO_UPDATE_STATS =3D BIT(0x1),
+};
+
+struct mlx5e_priv;
+struct mlx5e_stats_grp {
+	u16 update_stats_mask;
+	int (*get_num_stats)(struct mlx5e_priv *priv);
+	int (*fill_strings)(struct mlx5e_priv *priv, u8 *data, int idx);
+	int (*fill_stats)(struct mlx5e_priv *priv, u64 *data, int idx);
+	void (*update_stats)(struct mlx5e_priv *priv);
+};
+
+unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv);
+void mlx5e_stats_update(struct mlx5e_priv *priv);
+void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx);
+void mlx5e_stats_fill_strings(struct mlx5e_priv *priv, u8 *data);
+
+/* Concrete NIC Stats */
+
 struct mlx5e_sw_stats {
 	u64 rx_packets;
 	u64 rx_bytes;
@@ -322,21 +342,8 @@ struct mlx5e_stats {
 	struct mlx5e_pcie_stats pcie;
 };
=20
-enum {
-	MLX5E_NDO_UPDATE_STATS =3D BIT(0x1),
-};
-
-struct mlx5e_priv;
-struct mlx5e_stats_grp {
-	u16 update_stats_mask;
-	int (*get_num_stats)(struct mlx5e_priv *priv);
-	int (*fill_strings)(struct mlx5e_priv *priv, u8 *data, int idx);
-	int (*fill_stats)(struct mlx5e_priv *priv, u64 *data, int idx);
-	void (*update_stats)(struct mlx5e_priv *priv);
-};
-
-extern const struct mlx5e_stats_grp mlx5e_stats_grps[];
-extern const int mlx5e_num_stats_grps;
+extern const struct mlx5e_stats_grp mlx5e_nic_stats_grps[];
+unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv);
=20
 void mlx5e_grp_802_3_update_stats(struct mlx5e_priv *priv);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 7c87f523e370..bd870ffeb1be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -435,6 +435,8 @@ static const struct mlx5e_profile mlx5i_nic_profile =3D=
 {
 	.rx_handlers.handle_rx_cqe_mpwqe =3D NULL, /* Not supported */
 	.max_tc		   =3D MLX5I_MAX_NUM_TC,
 	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(REGULAR),
+	.stats_grps        =3D mlx5e_nic_stats_grps,
+	.stats_grps_num    =3D mlx5e_nic_stats_grps_num,
 };
=20
 /* mlx5i netdev NDos */
--=20
2.24.1

