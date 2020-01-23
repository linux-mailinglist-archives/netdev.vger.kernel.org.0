Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB1146212
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAWGkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:12 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:42992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbgAWGkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx8G8dYb/TDnk/ItjThNjTIn4LfOG4yfx2hQ6zzD1s+rffDItWjVaGOQiO7vy50jKmrCdt349lH7QMBFijQuIs9zsYZPF0+eX4tpGMaUFjqVrIiegMyGNRcKUI375E6gk84MqoqcxCALQuvptku2sqVLtiaVgBq7T8WGNeILiqY6Zzg7D6xPoRTu1/dVK5BjgUPb1UpC6zyE9ifHhELNPJ9tRrlDMPyEhzJQ21c2bMe6RrwclwqUOelkq4G8uDe+0wxuo1+dy7nBvzjuS9vHIYBhfoSAAImgHELYfaSejQ8N2su4E1qQv/ABl9apj2BdSZO5CvIDooPTiat8mnPVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFxEqw1tlbUc2GeLt13Juj/yqgWdHx6HbCmGnIpp9RE=;
 b=DRBSwV5nQYNAfIV8Zd/V+CaZST1Hw0G22sr6fOHb0VD6+epXR7O15x4cNpUdL0Yz5c9koufTX3IvHJ9FjesN+UZlUh7dK1X5G7JCrtS8yHsHoifXiv1wQHoxdFqBkal1M2CQTeXqyRCt2sroo922EAP50cAfmiY8YtJPoEdTAY4RlnjFX5oeEBzgsoEypxTJ/9Pr5ZC24jCS28Tp6fhs9X1v9B8q8uc/BtBWBXFG1bd0WjTcmJ5fCb2bq53sfze0MobDA2C/rVAewjmnxkotcPoN8IUFFAOClrIxOO/OpEg9BrzUJdyYg0oGeFcqWQzqwJpkBSxFt8HdwW6RUINv/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFxEqw1tlbUc2GeLt13Juj/yqgWdHx6HbCmGnIpp9RE=;
 b=pRjn9okAN7lwCuMBjrH8GIcuRIxFTA5MwTgBcRXiirtfe7XGsbPWqHljL1Z/g6RM72kDtZOmGJBelEECVazcwn5MdhhQHspmKGtmlVHLHijt8b8cB5FeoER9T0xtvOgbC6MqHcv82USlRZmvcjKdC9Yb/mNP9/3m0FFddKNN2W8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:55 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 10/15] net/mlx5e: Declare stats groups via macro
Thread-Topic: [net-next 10/15] net/mlx5e: Declare stats groups via macro
Thread-Index: AQHV0bfsiFZxSqEwyEWC3ejiDy+5WQ==
Date:   Thu, 23 Jan 2020 06:39:55 +0000
Message-ID: <20200123063827.685230-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 8ff36a12-dd07-4c36-2764-08d79fcf0ea0
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49414DF372F70B638D749474BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(30864003)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IUmmH/O/i0RzUVEyacnFWWAyyCp8Ne1pFlROPe+QNNon2IIZi8Nk2PLGvsOVQyWbum5Jwz2alOrX7qu/8CjpUEFRLmLGfE+X7j5thnKFUca0xSH+4+tJyb2alNuS6QhoBQocwSeDLAgcNjLglrbcf3sF9m5ubX5ScTnt4adKvEB8QvzoldWgInUesScV7uVKR25pgVRFiOBrdPkUbRCuNU0BIt2/lgnR/GEyB5C11m9YqxFG+O9Qdv7tKXNulXn3EKfPlZuDMdpGPR1eWOyNvw4/SIPbkciXZNiSIuQd1slflyG4k9u5upDPqEoaiX888pzjUaCfleDkW8iCo+YPubIjYD5hY6omMDAd8L5vC1YWdyYcLgSl+ShdmAMe7j3vjnRHA7+PMKeoNFGy1G0pdz7GNFEulH1MegUqJmlrmvcWtcCgN0aNRuMrb5o13pXgDhHgpKZgV0lIB4a3SHcFbCTJrcPSMdmQF+40FhGkg1lgjvbev9oIJH6nU0Zssw7+UCo77Jra9eFIVPnE+2T+AGHphjjVVG7zmOves7fmkik=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff36a12-dd07-4c36-2764-08d79fcf0ea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:55.2166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSwbvIpus4uvpVPXxDs8Y9d9MjMpJvXq+6giSHLw/wydvJsv6x7gtjdo6GfJEsqkDXdeF3bcrkNT81tGqh1BRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new macros to declare stats callbacks and groups, for better
code reuse and for individual groups selection per profile which will be
introduced in next patches.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 266 ++++++------------
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  25 +-
 3 files changed, 108 insertions(+), 185 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 60c79123824b..f00e17f78ec9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -162,7 +162,7 @@ static void mlx5e_uplink_rep_update_hw_counters(struct =
mlx5e_priv *priv)
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct rtnl_link_stats64 *vport_stats;
=20
-	mlx5e_grp_802_3_update_stats(priv);
+	MLX5E_STATS_GRP_OP(802_3, update_stats)(priv);
=20
 	vport_stats =3D &priv->stats.vf_vport;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index a8baa6298d95..e903a15e7289 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -198,12 +198,12 @@ static const struct counter_desc sw_stats_desc[] =3D =
{
=20
 #define NUM_SW_COUNTERS			ARRAY_SIZE(sw_stats_desc)
=20
-static int mlx5e_grp_sw_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(sw)
 {
 	return NUM_SW_COUNTERS;
 }
=20
-static int mlx5e_grp_sw_fill_strings(struct mlx5e_priv *priv, u8 *data, in=
t idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(sw)
 {
 	int i;
=20
@@ -212,7 +212,7 @@ static int mlx5e_grp_sw_fill_strings(struct mlx5e_priv =
*priv, u8 *data, int idx)
 	return idx;
 }
=20
-static int mlx5e_grp_sw_fill_stats(struct mlx5e_priv *priv, u64 *data, int=
 idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(sw)
 {
 	int i;
=20
@@ -221,7 +221,7 @@ static int mlx5e_grp_sw_fill_stats(struct mlx5e_priv *p=
riv, u64 *data, int idx)
 	return idx;
 }
=20
-static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s =3D &priv->stats.sw;
 	int i;
@@ -367,7 +367,7 @@ static const struct counter_desc drop_rq_stats_desc[] =
=3D {
 #define NUM_Q_COUNTERS			ARRAY_SIZE(q_stats_desc)
 #define NUM_DROP_RQ_COUNTERS		ARRAY_SIZE(drop_rq_stats_desc)
=20
-static int mlx5e_grp_q_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(qcnt)
 {
 	int num_stats =3D 0;
=20
@@ -380,7 +380,7 @@ static int mlx5e_grp_q_get_num_stats(struct mlx5e_priv =
*priv)
 	return num_stats;
 }
=20
-static int mlx5e_grp_q_fill_strings(struct mlx5e_priv *priv, u8 *data, int=
 idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(qcnt)
 {
 	int i;
=20
@@ -395,7 +395,7 @@ static int mlx5e_grp_q_fill_strings(struct mlx5e_priv *=
priv, u8 *data, int idx)
 	return idx;
 }
=20
-static int mlx5e_grp_q_fill_stats(struct mlx5e_priv *priv, u64 *data, int =
idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(qcnt)
 {
 	int i;
=20
@@ -408,7 +408,7 @@ static int mlx5e_grp_q_fill_stats(struct mlx5e_priv *pr=
iv, u64 *data, int idx)
 	return idx;
 }
=20
-static void mlx5e_grp_q_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(qcnt)
 {
 	struct mlx5e_qcounter_stats *qcnt =3D &priv->stats.qcnt;
 	u32 out[MLX5_ST_SZ_DW(query_q_counter_out)];
@@ -443,14 +443,13 @@ static const struct counter_desc vnic_env_stats_dev_o=
ob_desc[] =3D {
 	(MLX5_CAP_GEN(dev, vnic_env_int_rq_oob) ? \
 	 ARRAY_SIZE(vnic_env_stats_dev_oob_desc) : 0)
=20
-static int mlx5e_grp_vnic_env_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vnic_env)
 {
 	return NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev) +
 		NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev);
 }
=20
-static int mlx5e_grp_vnic_env_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
-					   int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
 {
 	int i;
=20
@@ -464,8 +463,7 @@ static int mlx5e_grp_vnic_env_fill_strings(struct mlx5e=
_priv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_vnic_env_fill_stats(struct mlx5e_priv *priv, u64 *dat=
a,
-					 int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vnic_env)
 {
 	int i;
=20
@@ -479,7 +477,7 @@ static int mlx5e_grp_vnic_env_fill_stats(struct mlx5e_p=
riv *priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_vnic_env_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vnic_env)
 {
 	u32 *out =3D (u32 *)priv->stats.vnic.query_vnic_env_out;
 	int outlen =3D MLX5_ST_SZ_BYTES(query_vnic_env_out);
@@ -542,13 +540,12 @@ static const struct counter_desc vport_stats_desc[] =
=3D {
=20
 #define NUM_VPORT_COUNTERS		ARRAY_SIZE(vport_stats_desc)
=20
-static int mlx5e_grp_vport_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vport)
 {
 	return NUM_VPORT_COUNTERS;
 }
=20
-static int mlx5e_grp_vport_fill_strings(struct mlx5e_priv *priv, u8 *data,
-					int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vport)
 {
 	int i;
=20
@@ -557,8 +554,7 @@ static int mlx5e_grp_vport_fill_strings(struct mlx5e_pr=
iv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_vport_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport)
 {
 	int i;
=20
@@ -568,7 +564,7 @@ static int mlx5e_grp_vport_fill_stats(struct mlx5e_priv=
 *priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_vport_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport)
 {
 	int outlen =3D MLX5_ST_SZ_BYTES(query_vport_counter_out);
 	u32 *out =3D (u32 *)priv->stats.vport.query_vport_out;
@@ -607,13 +603,12 @@ static const struct counter_desc pport_802_3_stats_de=
sc[] =3D {
=20
 #define NUM_PPORT_802_3_COUNTERS	ARRAY_SIZE(pport_802_3_stats_desc)
=20
-static int mlx5e_grp_802_3_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(802_3)
 {
 	return NUM_PPORT_802_3_COUNTERS;
 }
=20
-static int mlx5e_grp_802_3_fill_strings(struct mlx5e_priv *priv, u8 *data,
-					int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(802_3)
 {
 	int i;
=20
@@ -622,8 +617,7 @@ static int mlx5e_grp_802_3_fill_strings(struct mlx5e_pr=
iv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_802_3_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(802_3)
 {
 	int i;
=20
@@ -636,7 +630,7 @@ static int mlx5e_grp_802_3_fill_stats(struct mlx5e_priv=
 *priv, u64 *data,
 #define MLX5_BASIC_PPCNT_SUPPORTED(mdev) \
 	(MLX5_CAP_GEN(mdev, pcam_reg) ? MLX5_CAP_PCAM_REG(mdev, ppcnt) : 1)
=20
-void mlx5e_grp_802_3_update_stats(struct mlx5e_priv *priv)
+MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -664,13 +658,12 @@ static const struct counter_desc pport_2863_stats_des=
c[] =3D {
=20
 #define NUM_PPORT_2863_COUNTERS		ARRAY_SIZE(pport_2863_stats_desc)
=20
-static int mlx5e_grp_2863_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(2863)
 {
 	return NUM_PPORT_2863_COUNTERS;
 }
=20
-static int mlx5e_grp_2863_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				       int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(2863)
 {
 	int i;
=20
@@ -679,8 +672,7 @@ static int mlx5e_grp_2863_fill_strings(struct mlx5e_pri=
v *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_2863_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				     int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(2863)
 {
 	int i;
=20
@@ -690,7 +682,7 @@ static int mlx5e_grp_2863_fill_stats(struct mlx5e_priv =
*priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_2863_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(2863)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -725,13 +717,12 @@ static const struct counter_desc pport_2819_stats_des=
c[] =3D {
=20
 #define NUM_PPORT_2819_COUNTERS		ARRAY_SIZE(pport_2819_stats_desc)
=20
-static int mlx5e_grp_2819_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(2819)
 {
 	return NUM_PPORT_2819_COUNTERS;
 }
=20
-static int mlx5e_grp_2819_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				       int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(2819)
 {
 	int i;
=20
@@ -740,8 +731,7 @@ static int mlx5e_grp_2819_fill_strings(struct mlx5e_pri=
v *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_2819_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				     int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(2819)
 {
 	int i;
=20
@@ -751,7 +741,7 @@ static int mlx5e_grp_2819_fill_stats(struct mlx5e_priv =
*priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_2819_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(2819)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -789,7 +779,7 @@ pport_phy_statistical_err_lanes_stats_desc[] =3D {
 #define NUM_PPORT_PHY_STATISTICAL_PER_LANE_COUNTERS \
 	ARRAY_SIZE(pport_phy_statistical_err_lanes_stats_desc)
=20
-static int mlx5e_grp_phy_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(phy)
 {
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int num_stats;
@@ -806,8 +796,7 @@ static int mlx5e_grp_phy_get_num_stats(struct mlx5e_pri=
v *priv)
 	return num_stats;
 }
=20
-static int mlx5e_grp_phy_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(phy)
 {
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int i;
@@ -829,7 +818,7 @@ static int mlx5e_grp_phy_fill_strings(struct mlx5e_priv=
 *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_phy_fill_stats(struct mlx5e_priv *priv, u64 *data, in=
t idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(phy)
 {
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int i;
@@ -855,7 +844,7 @@ static int mlx5e_grp_phy_fill_stats(struct mlx5e_priv *=
priv, u64 *data, int idx)
 	return idx;
 }
=20
-static void mlx5e_grp_phy_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -885,7 +874,7 @@ static const struct counter_desc pport_eth_ext_stats_de=
sc[] =3D {
=20
 #define NUM_PPORT_ETH_EXT_COUNTERS	ARRAY_SIZE(pport_eth_ext_stats_desc)
=20
-static int mlx5e_grp_eth_ext_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(eth_ext)
 {
 	if (MLX5_CAP_PCAM_FEATURE((priv)->mdev, rx_buffer_fullness_counters))
 		return NUM_PPORT_ETH_EXT_COUNTERS;
@@ -893,8 +882,7 @@ static int mlx5e_grp_eth_ext_get_num_stats(struct mlx5e=
_priv *priv)
 	return 0;
 }
=20
-static int mlx5e_grp_eth_ext_fill_strings(struct mlx5e_priv *priv, u8 *dat=
a,
-					  int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(eth_ext)
 {
 	int i;
=20
@@ -905,8 +893,7 @@ static int mlx5e_grp_eth_ext_fill_strings(struct mlx5e_=
priv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_eth_ext_fill_stats(struct mlx5e_priv *priv, u64 *data=
,
-					int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(eth_ext)
 {
 	int i;
=20
@@ -918,7 +905,7 @@ static int mlx5e_grp_eth_ext_fill_stats(struct mlx5e_pr=
iv *priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_eth_ext_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(eth_ext)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -959,7 +946,7 @@ static const struct counter_desc pcie_perf_stall_stats_=
desc[] =3D {
 #define NUM_PCIE_PERF_COUNTERS64	ARRAY_SIZE(pcie_perf_stats_desc64)
 #define NUM_PCIE_PERF_STALL_COUNTERS	ARRAY_SIZE(pcie_perf_stall_stats_desc=
)
=20
-static int mlx5e_grp_pcie_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(pcie)
 {
 	int num_stats =3D 0;
=20
@@ -975,8 +962,7 @@ static int mlx5e_grp_pcie_get_num_stats(struct mlx5e_pr=
iv *priv)
 	return num_stats;
 }
=20
-static int mlx5e_grp_pcie_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				       int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(pcie)
 {
 	int i;
=20
@@ -997,8 +983,7 @@ static int mlx5e_grp_pcie_fill_strings(struct mlx5e_pri=
v *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_pcie_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				     int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(pcie)
 {
 	int i;
=20
@@ -1022,7 +1007,7 @@ static int mlx5e_grp_pcie_fill_stats(struct mlx5e_pri=
v *priv, u64 *data,
 	return idx;
 }
=20
-static void mlx5e_grp_pcie_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(pcie)
 {
 	struct mlx5e_pcie_stats *pcie_stats =3D &priv->stats.pcie;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -1070,8 +1055,7 @@ static int mlx5e_grp_per_tc_prio_get_num_stats(struct=
 mlx5e_priv *priv)
 	return NUM_PPORT_PER_TC_PRIO_COUNTERS * NUM_PPORT_PRIO;
 }
=20
-static int mlx5e_grp_per_port_buffer_congest_fill_strings(struct mlx5e_pri=
v *priv,
-							  u8 *data, int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(per_port_buff_congest)
 {
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	int i, prio;
@@ -1091,8 +1075,7 @@ static int mlx5e_grp_per_port_buffer_congest_fill_str=
ings(struct mlx5e_priv *pri
 	return idx;
 }
=20
-static int mlx5e_grp_per_port_buffer_congest_fill_stats(struct mlx5e_priv =
*priv,
-							u64 *data, int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(per_port_buff_congest)
 {
 	struct mlx5e_pport_stats *pport =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -1167,13 +1150,13 @@ static void mlx5e_grp_per_tc_congest_prio_update_st=
ats(struct mlx5e_priv *priv)
 	}
 }
=20
-static int mlx5e_grp_per_port_buffer_congest_get_num_stats(struct mlx5e_pr=
iv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(per_port_buff_congest)
 {
 	return mlx5e_grp_per_tc_prio_get_num_stats(priv) +
 		mlx5e_grp_per_tc_congest_prio_get_num_stats(priv);
 }
=20
-static void mlx5e_grp_per_port_buffer_congest_update_stats(struct mlx5e_pr=
iv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(per_port_buff_congest)
 {
 	mlx5e_grp_per_tc_prio_update_stats(priv);
 	mlx5e_grp_per_tc_congest_prio_update_stats(priv);
@@ -1348,29 +1331,27 @@ static int mlx5e_grp_per_prio_pfc_fill_stats(struct=
 mlx5e_priv *priv,
 	return idx;
 }
=20
-static int mlx5e_grp_per_prio_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(per_prio)
 {
 	return mlx5e_grp_per_prio_traffic_get_num_stats() +
 		mlx5e_grp_per_prio_pfc_get_num_stats(priv);
 }
=20
-static int mlx5e_grp_per_prio_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
-					   int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(per_prio)
 {
 	idx =3D mlx5e_grp_per_prio_traffic_fill_strings(priv, data, idx);
 	idx =3D mlx5e_grp_per_prio_pfc_fill_strings(priv, data, idx);
 	return idx;
 }
=20
-static int mlx5e_grp_per_prio_fill_stats(struct mlx5e_priv *priv, u64 *dat=
a,
-					 int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(per_prio)
 {
 	idx =3D mlx5e_grp_per_prio_traffic_fill_stats(priv, data, idx);
 	idx =3D mlx5e_grp_per_prio_pfc_fill_stats(priv, data, idx);
 	return idx;
 }
=20
-static void mlx5e_grp_per_prio_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(per_prio)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -1405,13 +1386,12 @@ static const struct counter_desc mlx5e_pme_error_de=
sc[] =3D {
 #define NUM_PME_STATUS_STATS		ARRAY_SIZE(mlx5e_pme_status_desc)
 #define NUM_PME_ERR_STATS		ARRAY_SIZE(mlx5e_pme_error_desc)
=20
-static int mlx5e_grp_pme_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(pme)
 {
 	return NUM_PME_STATUS_STATS + NUM_PME_ERR_STATS;
 }
=20
-static int mlx5e_grp_pme_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(pme)
 {
 	int i;
=20
@@ -1424,8 +1404,7 @@ static int mlx5e_grp_pme_fill_strings(struct mlx5e_pr=
iv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_pme_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				    int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(pme)
 {
 	struct mlx5_pme_stats pme_stats;
 	int i;
@@ -1443,45 +1422,46 @@ static int mlx5e_grp_pme_fill_stats(struct mlx5e_pr=
iv *priv, u64 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_ipsec_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(pme) { return; }
+
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec)
 {
 	return mlx5e_ipsec_get_count(priv);
 }
=20
-static int mlx5e_grp_ipsec_fill_strings(struct mlx5e_priv *priv, u8 *data,
-					int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec)
 {
 	return idx + mlx5e_ipsec_get_strings(priv,
 					     data + idx * ETH_GSTRING_LEN);
 }
=20
-static int mlx5e_grp_ipsec_fill_stats(struct mlx5e_priv *priv, u64 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec)
 {
 	return idx + mlx5e_ipsec_get_stats(priv, data + idx);
 }
=20
-static void mlx5e_grp_ipsec_update_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec)
 {
 	mlx5e_ipsec_update_stats(priv);
 }
=20
-static int mlx5e_grp_tls_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(tls)
 {
 	return mlx5e_tls_get_count(priv);
 }
=20
-static int mlx5e_grp_tls_fill_strings(struct mlx5e_priv *priv, u8 *data,
-				      int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(tls)
 {
 	return idx + mlx5e_tls_get_strings(priv, data + idx * ETH_GSTRING_LEN);
 }
=20
-static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, in=
t idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(tls)
 {
 	return idx + mlx5e_tls_get_stats(priv, data + idx);
 }
=20
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(tls) { return; }
+
 static const struct counter_desc rq_stats_desc[] =3D {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, bytes) },
@@ -1615,7 +1595,7 @@ static const struct counter_desc ch_stats_desc[] =3D =
{
 #define NUM_XSKSQ_STATS			ARRAY_SIZE(xsksq_stats_desc)
 #define NUM_CH_STATS			ARRAY_SIZE(ch_stats_desc)
=20
-static int mlx5e_grp_channels_get_num_stats(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 {
 	int max_nch =3D priv->max_nch;
=20
@@ -1628,8 +1608,7 @@ static int mlx5e_grp_channels_get_num_stats(struct ml=
x5e_priv *priv)
 	       (NUM_XSKSQ_STATS * max_nch * priv->xsk.ever_used);
 }
=20
-static int mlx5e_grp_channels_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
-					   int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(channels)
 {
 	bool is_xsk =3D priv->xsk.ever_used;
 	int max_nch =3D priv->max_nch;
@@ -1671,8 +1650,7 @@ static int mlx5e_grp_channels_fill_strings(struct mlx=
5e_priv *priv, u8 *data,
 	return idx;
 }
=20
-static int mlx5e_grp_channels_fill_stats(struct mlx5e_priv *priv, u64 *dat=
a,
-					 int idx)
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channels)
 {
 	bool is_xsk =3D priv->xsk.ever_used;
 	int max_nch =3D priv->max_nch;
@@ -1720,104 +1698,26 @@ static int mlx5e_grp_channels_fill_stats(struct ml=
x5e_priv *priv, u64 *data,
 	return idx;
 }
=20
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(channels) { return; }
+
 /* The stats groups order is opposite to the update_stats() order calls */
 const struct mlx5e_stats_grp mlx5e_nic_stats_grps[] =3D {
-	{
-		.get_num_stats =3D mlx5e_grp_sw_get_num_stats,
-		.fill_strings =3D mlx5e_grp_sw_fill_strings,
-		.fill_stats =3D mlx5e_grp_sw_fill_stats,
-		.update_stats =3D mlx5e_grp_sw_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_q_get_num_stats,
-		.fill_strings =3D mlx5e_grp_q_fill_strings,
-		.fill_stats =3D mlx5e_grp_q_fill_stats,
-		.update_stats_mask =3D MLX5E_NDO_UPDATE_STATS,
-		.update_stats =3D mlx5e_grp_q_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_vnic_env_get_num_stats,
-		.fill_strings =3D mlx5e_grp_vnic_env_fill_strings,
-		.fill_stats =3D mlx5e_grp_vnic_env_fill_stats,
-		.update_stats =3D mlx5e_grp_vnic_env_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_vport_get_num_stats,
-		.fill_strings =3D mlx5e_grp_vport_fill_strings,
-		.fill_stats =3D mlx5e_grp_vport_fill_stats,
-		.update_stats_mask =3D MLX5E_NDO_UPDATE_STATS,
-		.update_stats =3D mlx5e_grp_vport_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_802_3_get_num_stats,
-		.fill_strings =3D mlx5e_grp_802_3_fill_strings,
-		.fill_stats =3D mlx5e_grp_802_3_fill_stats,
-		.update_stats_mask =3D MLX5E_NDO_UPDATE_STATS,
-		.update_stats =3D mlx5e_grp_802_3_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_2863_get_num_stats,
-		.fill_strings =3D mlx5e_grp_2863_fill_strings,
-		.fill_stats =3D mlx5e_grp_2863_fill_stats,
-		.update_stats =3D mlx5e_grp_2863_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_2819_get_num_stats,
-		.fill_strings =3D mlx5e_grp_2819_fill_strings,
-		.fill_stats =3D mlx5e_grp_2819_fill_stats,
-		.update_stats =3D mlx5e_grp_2819_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_phy_get_num_stats,
-		.fill_strings =3D mlx5e_grp_phy_fill_strings,
-		.fill_stats =3D mlx5e_grp_phy_fill_stats,
-		.update_stats =3D mlx5e_grp_phy_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_eth_ext_get_num_stats,
-		.fill_strings =3D mlx5e_grp_eth_ext_fill_strings,
-		.fill_stats =3D mlx5e_grp_eth_ext_fill_stats,
-		.update_stats =3D mlx5e_grp_eth_ext_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_pcie_get_num_stats,
-		.fill_strings =3D mlx5e_grp_pcie_fill_strings,
-		.fill_stats =3D mlx5e_grp_pcie_fill_stats,
-		.update_stats =3D mlx5e_grp_pcie_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_per_prio_get_num_stats,
-		.fill_strings =3D mlx5e_grp_per_prio_fill_strings,
-		.fill_stats =3D mlx5e_grp_per_prio_fill_stats,
-		.update_stats =3D mlx5e_grp_per_prio_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_pme_get_num_stats,
-		.fill_strings =3D mlx5e_grp_pme_fill_strings,
-		.fill_stats =3D mlx5e_grp_pme_fill_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_ipsec_get_num_stats,
-		.fill_strings =3D mlx5e_grp_ipsec_fill_strings,
-		.fill_stats =3D mlx5e_grp_ipsec_fill_stats,
-		.update_stats =3D mlx5e_grp_ipsec_update_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_tls_get_num_stats,
-		.fill_strings =3D mlx5e_grp_tls_fill_strings,
-		.fill_stats =3D mlx5e_grp_tls_fill_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_channels_get_num_stats,
-		.fill_strings =3D mlx5e_grp_channels_fill_strings,
-		.fill_stats =3D mlx5e_grp_channels_fill_stats,
-	},
-	{
-		.get_num_stats =3D mlx5e_grp_per_port_buffer_congest_get_num_stats,
-		.fill_strings =3D mlx5e_grp_per_port_buffer_congest_fill_strings,
-		.fill_stats =3D mlx5e_grp_per_port_buffer_congest_fill_stats,
-		.update_stats =3D mlx5e_grp_per_port_buffer_congest_update_stats,
-	},
+	MLX5E_DEFINE_STATS_GRP(sw, 0),
+	MLX5E_DEFINE_STATS_GRP(qcnt, MLX5E_NDO_UPDATE_STATS),
+	MLX5E_DEFINE_STATS_GRP(vnic_env, 0),
+	MLX5E_DEFINE_STATS_GRP(vport, MLX5E_NDO_UPDATE_STATS),
+	MLX5E_DEFINE_STATS_GRP(802_3, MLX5E_NDO_UPDATE_STATS),
+	MLX5E_DEFINE_STATS_GRP(2863, 0),
+	MLX5E_DEFINE_STATS_GRP(2819, 0),
+	MLX5E_DEFINE_STATS_GRP(phy, 0),
+	MLX5E_DEFINE_STATS_GRP(eth_ext, 0),
+	MLX5E_DEFINE_STATS_GRP(pcie, 0),
+	MLX5E_DEFINE_STATS_GRP(per_prio, 0),
+	MLX5E_DEFINE_STATS_GRP(pme, 0),
+	MLX5E_DEFINE_STATS_GRP(ipsec, 0),
+	MLX5E_DEFINE_STATS_GRP(tls, 0),
+	MLX5E_DEFINE_STATS_GRP(channels, 0),
+	MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0),
 };
=20
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 06eeedaacb88..bc97964cd721 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+
 #ifndef __MLX5_EN_STATS_H__
 #define __MLX5_EN_STATS_H__
=20
@@ -68,6 +69,28 @@ struct mlx5e_stats_grp {
 	void (*update_stats)(struct mlx5e_priv *priv);
 };
=20
+#define MLX5E_STATS_GRP_OP(grp, name) mlx5e_stats_grp_ ## grp ## _ ## name
+
+#define MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(grp) \
+	int MLX5E_STATS_GRP_OP(grp, num_stats)(struct mlx5e_priv *priv)
+
+#define MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(grp) \
+	void MLX5E_STATS_GRP_OP(grp, update_stats)(struct mlx5e_priv *priv)
+
+#define MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(grp) \
+	int MLX5E_STATS_GRP_OP(grp, fill_strings)(struct mlx5e_priv *priv, u8 *da=
ta, int idx)
+
+#define MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(grp) \
+	int MLX5E_STATS_GRP_OP(grp, fill_stats)(struct mlx5e_priv *priv, u64 *dat=
a, int idx)
+
+#define MLX5E_DEFINE_STATS_GRP(grp, mask) { \
+	.get_num_stats =3D MLX5E_STATS_GRP_OP(grp, num_stats), \
+	.fill_stats    =3D MLX5E_STATS_GRP_OP(grp, fill_stats), \
+	.fill_strings  =3D MLX5E_STATS_GRP_OP(grp, fill_strings), \
+	.update_stats  =3D MLX5E_STATS_GRP_OP(grp, update_stats), \
+	.update_stats_mask =3D mask, \
+}
+
 unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv);
 void mlx5e_stats_update(struct mlx5e_priv *priv);
 void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx);
@@ -345,6 +368,6 @@ struct mlx5e_stats {
 extern const struct mlx5e_stats_grp mlx5e_nic_stats_grps[];
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv);
=20
-void mlx5e_grp_802_3_update_stats(struct mlx5e_priv *priv);
+MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3);
=20
 #endif /* __MLX5_EN_STATS_H__ */
--=20
2.24.1

