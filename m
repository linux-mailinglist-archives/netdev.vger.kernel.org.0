Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63D0146211
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAWGkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:12 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727847AbgAWGkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJpAJ2IkTxAit3Pk7IMSLMeqzVVKIAYjB6qKaCeeman+0AwB31vDJgXnunljvRs41xMD0Hp9CmtxDlXugVFzGGvRVl9tYI0pRs0cSHRbCNKxtwxJTxDj+GroNfNYCA4Yuxw8rZbtJUI7Ix7xlE7Tj/Zaw336Btw0+h+s9ex4D84XXnJNXL6GQz1fL5Eo0BXSNxf3DDasSMjrveWa1CGq8ut+QFHqIiQ7sPdunjZIL1jw7MfXmBc+SaLtZztyK4oCOb5HONzl0PSGc029yVBbqG4V1hM2D7QcKpv2H4Vz0EjpHZQqduAXhbf2EBUs9Y1ueNJFuF1FlDQULqsguCsjWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkhO5+cj1gSTQx0+70WgjaZEMnYc8sSoQBkRW0OKMxM=;
 b=Q8WT+uyni8cN1gYGQ5FdKm3noG9oLdD2o1/BnYYzH4OvlBag3EKxIRuttChnw6nPkzO5SELba/OY5hDs+0kGmT/ec74MAb7DF8YcmHvupSBsZvuW7Iuo3rrtazlqNByJlLUKW+o0iuqGCvOnYeBq2F+qyZKCRAzc5YTUYF7i2V7RfhbhXjrcmVL4kzDrrpVngDLDpzkpnrkF1ORtNkEbPP4vGiuVzVQkOVH0TJNLLU7AjsEtaONA6uSYQXy2OkQQu8TDsRB/Ph0PkNy/af8s03yJG+BfEQFLDd+pl3pV6hm3YeKtl9EG/o/0N0BYTjhyMj2V035k3TaNZ/Z4QGrhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkhO5+cj1gSTQx0+70WgjaZEMnYc8sSoQBkRW0OKMxM=;
 b=bINpkFGksy04Nmc7ciGnN4crY8Yr5S0jMZ4wDVsBIzd8ws7yLK8NuuPTrVdMJ33n6co6k+MyK1HwwFzr+233m0dG9LehPjobdn5iJBqLplmSgtmfznxQkmmivWpKegkcIKIt3E2Q27wmiQQ9Imj9LycMtRpMQx/G3F0gbOc9hXY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:40:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:40:01 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: Convert rep stats to
 mlx5e_stats_grp-based infra
Thread-Topic: [net-next 13/15] net/mlx5e: Convert rep stats to
 mlx5e_stats_grp-based infra
Thread-Index: AQHV0bfvlXRGgGCD/ECW01xT4hjNYA==
Date:   Thu, 23 Jan 2020 06:40:00 +0000
Message-ID: <20200123063827.685230-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: aefc2669-9dc9-497e-bef2-08d79fcf11cd
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB494126588B7ACF2B915DB96CBE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:289;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(6666004)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKcbaWUu3Qh/7qq1VlHG80AhvRbtO0b/DmM5HFgDOuEqITFyVyvra7HA6jb1HWh6myj/veLR5sRHR6/QlpjVzI1+jKh+8XTE12oAbwNrZ7JWXOJjM+sLc8rJDiGRwS4LtjU3KLHlsdX0R1BWc1WH63mQ2fKFW28ktT9AMWdk4Xq/hCHIe89m4pAy4TMLhbdQ5EnLMJw5m+46+gmU25XM0D4O83HNQG9FJNknlR/hKdFcTFq7+klI1A3ZVBzrh6x+yps6AYs/G9wKmrNsHqb8hcfQevwSIyqeqbLZ2HRUoNWW5nUoRv2DEGH5fB7wnUoiaYOL8TdnteuhdP8O+W7iRmgZJnw8uXfW805TkoyUeKqU90y6jtnZA0DhovlV5gC2pc/lwc7ahJL7mBg9XVnDBjI8gWd+CS5/0TwTbrxtMp0kHrv0GAsh0/0UH1P510w7LvvRMaUYU6BMr1eR5wvyI5koaNcxH1ytrAVnz7ovKJBJAeLX1EZLw1/iDZiWvN3+P5mtVm/4lFY8Qe4pQEYDxXziyI2FECtzv//FsCbuTO0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aefc2669-9dc9-497e-bef2-08d79fcf11cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:40:00.3426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4lpR4RqofUXi2m//0AQtv9jmaszijqhWf0HBjva/ej11DtcIwTsWtpdFaccuxPCO6B7+0LtcdrAgBXzuIfTbow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to support all of the supported stats that are available in legacy
mode for switchdev uplink representors, convert rep stats infrastructure to
reuse struct mlx5e_stats_grp that is already used when device is in legacy
mode. Refactor rep code to use array of mlx5e_stats_grp
structures (constructed using macros provided by stats infra) to
fill/update stats, instead of fixed hardcoded set of values. This approach
allows to easily extend representors with new stats types.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 157 +++++++++++++-----
 1 file changed, 114 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index f00e17f78ec9..01745941a11f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -117,24 +117,71 @@ static const struct counter_desc vport_rep_stats_desc=
[] =3D {
 #define NUM_VPORT_REP_SW_COUNTERS ARRAY_SIZE(sw_rep_stats_desc)
 #define NUM_VPORT_REP_HW_COUNTERS ARRAY_SIZE(vport_rep_stats_desc)
=20
-static void mlx5e_rep_get_strings(struct net_device *dev,
-				  u32 stringset, uint8_t *data)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(sw_rep)
 {
-	int i, j;
+	return NUM_VPORT_REP_SW_COUNTERS;
+}
=20
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i =3D 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
-			strcpy(data + (i * ETH_GSTRING_LEN),
-			       sw_rep_stats_desc[i].format);
-		for (j =3D 0; j < NUM_VPORT_REP_HW_COUNTERS; j++, i++)
-			strcpy(data + (i * ETH_GSTRING_LEN),
-			       vport_rep_stats_desc[j].format);
-		break;
-	}
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(sw_rep)
+{
+	int i;
+
+	for (i =3D 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       sw_rep_stats_desc[i].format);
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(sw_rep)
+{
+	int i;
+
+	for (i =3D 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
+		data[idx++] =3D MLX5E_READ_CTR64_CPU(&priv->stats.sw,
+						   sw_rep_stats_desc, i);
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw_rep)
+{
+	struct mlx5e_sw_stats *s =3D &priv->stats.sw;
+	struct rtnl_link_stats64 stats64 =3D {};
+
+	memset(s, 0, sizeof(*s));
+	mlx5e_fold_sw_stats64(priv, &stats64);
+
+	s->rx_packets =3D stats64.rx_packets;
+	s->rx_bytes   =3D stats64.rx_bytes;
+	s->tx_packets =3D stats64.tx_packets;
+	s->tx_bytes   =3D stats64.tx_bytes;
+	s->tx_queue_dropped =3D stats64.tx_dropped;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vport_rep)
+{
+	return NUM_VPORT_REP_HW_COUNTERS;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vport_rep)
+{
+	int i;
+
+	for (i =3D 0; i < NUM_VPORT_REP_HW_COUNTERS; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN, vport_rep_stats_desc[i].format)=
;
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport_rep)
+{
+	int i;
+
+	for (i =3D 0; i < NUM_VPORT_REP_HW_COUNTERS; i++)
+		data[idx++] =3D MLX5E_READ_CTR64_CPU(&priv->stats.vf_vport,
+						   vport_rep_stats_desc, i);
+	return idx;
 }
=20
-static void mlx5e_rep_update_hw_counters(struct mlx5e_priv *priv)
+static void mlx5e_vf_rep_update_hw_counters(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
@@ -172,49 +219,44 @@ static void mlx5e_uplink_rep_update_hw_counters(struc=
t mlx5e_priv *priv)
 	vport_stats->tx_bytes   =3D PPORT_802_3_GET(pstats, a_octets_transmitted_=
ok);
 }
=20
-static void mlx5e_rep_update_sw_counters(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 {
-	struct mlx5e_sw_stats *s =3D &priv->stats.sw;
-	struct rtnl_link_stats64 stats64 =3D {};
+	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
+	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
=20
-	memset(s, 0, sizeof(*s));
-	mlx5e_fold_sw_stats64(priv, &stats64);
+	if (rep->vport =3D=3D MLX5_VPORT_UPLINK)
+		mlx5e_uplink_rep_update_hw_counters(priv);
+	else
+		mlx5e_vf_rep_update_hw_counters(priv);
+}
=20
-	s->rx_packets =3D stats64.rx_packets;
-	s->rx_bytes   =3D stats64.rx_bytes;
-	s->tx_packets =3D stats64.tx_packets;
-	s->tx_bytes   =3D stats64.tx_bytes;
-	s->tx_queue_dropped =3D stats64.tx_dropped;
+static void mlx5e_rep_get_strings(struct net_device *dev,
+				  u32 stringset, uint8_t *data)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		mlx5e_stats_fill_strings(priv, data);
+		break;
+	}
 }
=20
 static void mlx5e_rep_get_ethtool_stats(struct net_device *dev,
 					struct ethtool_stats *stats, u64 *data)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
-	int i, j;
-
-	if (!data)
-		return;
-
-	mutex_lock(&priv->state_lock);
-	mlx5e_rep_update_sw_counters(priv);
-	priv->profile->update_stats(priv);
-	mutex_unlock(&priv->state_lock);
=20
-	for (i =3D 0; i < NUM_VPORT_REP_SW_COUNTERS; i++)
-		data[i] =3D MLX5E_READ_CTR64_CPU(&priv->stats.sw,
-					       sw_rep_stats_desc, i);
-
-	for (j =3D 0; j < NUM_VPORT_REP_HW_COUNTERS; j++, i++)
-		data[i] =3D MLX5E_READ_CTR64_CPU(&priv->stats.vf_vport,
-					       vport_rep_stats_desc, j);
+	mlx5e_ethtool_get_ethtool_stats(priv, stats, data);
 }
=20
 static int mlx5e_rep_get_sset_count(struct net_device *dev, int sset)
 {
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return NUM_VPORT_REP_SW_COUNTERS + NUM_VPORT_REP_HW_COUNTERS;
+		return mlx5e_stats_total_num(priv);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1833,6 +1875,31 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_pr=
iv *priv)
 	mlx5_lag_remove(mdev);
 }
=20
+static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
+static MLX5E_DEFINE_STATS_GRP(vport_rep, MLX5E_NDO_UPDATE_STATS);
+
+/* The stats groups order is opposite to the update_stats() order calls */
+static mlx5e_stats_grp_t mlx5e_rep_stats_grps[] =3D {
+	&MLX5E_STATS_GRP(sw_rep),
+	&MLX5E_STATS_GRP(vport_rep),
+};
+
+static unsigned int mlx5e_rep_stats_grps_num(struct mlx5e_priv *priv)
+{
+	return ARRAY_SIZE(mlx5e_rep_stats_grps);
+}
+
+/* The stats groups order is opposite to the update_stats() order calls */
+static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] =3D {
+	&MLX5E_STATS_GRP(sw_rep),
+	&MLX5E_STATS_GRP(vport_rep),
+};
+
+static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
+{
+	return ARRAY_SIZE(mlx5e_ul_rep_stats_grps);
+}
+
 static const struct mlx5e_profile mlx5e_rep_profile =3D {
 	.init			=3D mlx5e_init_rep,
 	.cleanup		=3D mlx5e_cleanup_rep,
@@ -1842,11 +1909,13 @@ static const struct mlx5e_profile mlx5e_rep_profile=
 =3D {
 	.cleanup_tx		=3D mlx5e_cleanup_rep_tx,
 	.enable		        =3D mlx5e_rep_enable,
 	.update_rx		=3D mlx5e_update_rep_rx,
-	.update_stats           =3D mlx5e_rep_update_hw_counters,
+	.update_stats           =3D mlx5e_update_ndo_stats,
 	.rx_handlers.handle_rx_cqe       =3D mlx5e_handle_rx_cqe_rep,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc			=3D 1,
 	.rq_groups		=3D MLX5E_NUM_RQ_GROUPS(REGULAR),
+	.stats_grps		=3D mlx5e_rep_stats_grps,
+	.stats_grps_num		=3D mlx5e_rep_stats_grps_num,
 };
=20
 static const struct mlx5e_profile mlx5e_uplink_rep_profile =3D {
@@ -1859,12 +1928,14 @@ static const struct mlx5e_profile mlx5e_uplink_rep_=
profile =3D {
 	.enable		        =3D mlx5e_uplink_rep_enable,
 	.disable	        =3D mlx5e_uplink_rep_disable,
 	.update_rx		=3D mlx5e_update_rep_rx,
-	.update_stats           =3D mlx5e_uplink_rep_update_hw_counters,
+	.update_stats           =3D mlx5e_update_ndo_stats,
 	.update_carrier	        =3D mlx5e_update_carrier,
 	.rx_handlers.handle_rx_cqe       =3D mlx5e_handle_rx_cqe_rep,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc			=3D MLX5E_MAX_NUM_TC,
 	.rq_groups		=3D MLX5E_NUM_RQ_GROUPS(REGULAR),
+	.stats_grps		=3D mlx5e_ul_rep_stats_grps,
+	.stats_grps_num		=3D mlx5e_ul_rep_stats_grps_num,
 };
=20
 static bool
--=20
2.24.1

