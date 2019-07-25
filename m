Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427A7758F1
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfGYUgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:50 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbfGYUgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kye8+EILNzF/1bMTE610Qr9p/4ByrD8l3BDa98tPQoHunGe2lLO2EoVzRLg4kvjaQgW4DmUPhh0+GuYwyMH+iUfXnELGAkPsRFhtFTaZfx1u5PCv8l1U91tSq81WlBDls1lRry58j5noMqSDpsMP53LGES58yDLtAJQnxXvce0avx19CM5VtdGgeHresbx8gD8unZzk9c895UtnKD7wHr3cKMhEFFXWCrXdOP6PDpfQMVZnuXBq7eQwU5Qnu9sODDtK7lXgyS5aGyaG1dj1dcCoEX1LrWl1riEhBE03QMPwMyM3qIZ2+4VdR+MV/CMNAMdI5tsawLr37wNUogy3cmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lsFcNaAuabt/6eMK+1G8lnfp6rTfYZdpG0jSrbXjEo=;
 b=RtHWcg6L8COLoCPuZaM7wDbkNNZP3v7Qmivi9HAVsTrAvxhtRqsf3xmCh3gq5ffi1gQQkT0YtIgB6ebID6TrFug8E/Wl8n0sOSyrXFNE+XvTswcL0y8F2ucLkCkq0TldMMC4z/YKElh1ywklB800Q0d8gurNOAVIVI5BtqFu0UdjrV1aoOdIGfLgTm2cGmSzvZkFO64MeL14VK5MlP6oMGjQE61wmajrFa3UQQcV0SFE/ktv8/qWlzRqt8Fw7Wf+0dik6OE2tGSMMyAysoB8E6yvt6im7RYt3hM4OlEfE2WKj/cd/3x11APbSlgsrBxyoKw0N941qXxi7xmjnLeq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lsFcNaAuabt/6eMK+1G8lnfp6rTfYZdpG0jSrbXjEo=;
 b=T2zIzUYh76dv3tjyi/7ZIddqZJqNMZCF6QvFsr2dqrIQe4YBken28EgJ+iwZeXzHLaoqA3MNxNx3o4btl+Pb76q5yjcCNvJNE2oQFq5ptS7blNIvPxXt10vuV7Tl/T7Ijpt4e8q0ZTfeCq+WfpT+B3w0Ij6u+7EBz3m/bUieH7o=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:42 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/9] net/mlx5e: Fix wrong max num channels indication
Thread-Topic: [net 4/9] net/mlx5e: Fix wrong max num channels indication
Thread-Index: AQHVQyiq8Zh9cdQbjkaNvyyKcEEwDQ==
Date:   Thu, 25 Jul 2019 20:36:42 +0000
Message-ID: <20190725203618.11011-5-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7b83d23-3a74-4a57-838a-08d7113fcd5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504D5F87F7289893FB83EEABEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:158;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(53946003)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(30864003)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2mIofr+HhFGAIGkT9It714B4zbwJolIEjoIyqbqjAPlTQPG5PLeEzcjl7lGY8KNi/BGczQ4az/urWHTtE9/ziBo5jUwK9GdzCMFHxA4IEsuHzN3O9aFuc7jLEqLWdLm+C/kP+8pxgn9FuhApmA2/2+KRM0QaqaG558GpCba28po9zMvv1yziwEwAcCQvA3eJfrGlvATbfsfQVvyddIGQqfcnRLvtf4MkO/qBMaWfF6KdOJmiPsvpT5Y1yvxqmQ6GNQmcTIom5tRRCghxDv18C65ufW8sO3kH9z2SvxKvrPw5YNDnXehKoMCLSNM7gwICkEoH4VAx7LA9aPNOkNKIF37NWGgYtDIqLJ3fgxPNZKPJrBa/10BIlZAzNBt8CaIwiz8cdFTxfMuAvL8Zo1/KemkG2eOWGfUlCUl+oEhziYU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b83d23-3a74-4a57-838a-08d7113fcd5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:42.3603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

No XSK support in the enhanced IPoIB driver and representors.
Add a profile property to specify this, and enhance the logic
that calculates the max number of channels to take it into
account.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 12 ++-----
 .../ethernet/mellanox/mlx5/core/en/params.h   |  5 +--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 ++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  7 ++--
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  1 +
 9 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 79d93d6c7d7a..ce1be2a84231 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -159,7 +159,7 @@ do {                                                   =
         \
 enum mlx5e_rq_group {
 	MLX5E_RQ_GROUP_REGULAR,
 	MLX5E_RQ_GROUP_XSK,
-	MLX5E_NUM_RQ_GROUPS /* Keep last. */
+#define MLX5E_NUM_RQ_GROUPS(g) (1 + MLX5E_RQ_GROUP_##g)
 };
=20
 static inline u16 mlx5_min_rx_wqes(int wq_type, u32 wq_size)
@@ -182,14 +182,6 @@ static inline int mlx5e_get_max_num_channels(struct ml=
x5_core_dev *mdev)
 		min_t(int, mlx5_comp_vectors_count(mdev), MLX5E_MAX_NUM_CHANNELS);
 }
=20
-/* Use this function to get max num channels after netdev was created */
-static inline int mlx5e_get_netdev_max_channels(struct net_device *netdev)
-{
-	return min_t(unsigned int,
-		     netdev->num_rx_queues / MLX5E_NUM_RQ_GROUPS,
-		     netdev->num_tx_queues);
-}
-
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
@@ -830,6 +822,7 @@ struct mlx5e_priv {
 	struct net_device         *netdev;
 	struct mlx5e_stats         stats;
 	struct mlx5e_channel_stats channel_stats[MLX5E_MAX_NUM_CHANNELS];
+	u16                        max_nch;
 	u8                         max_opened_tc;
 	struct hwtstamp_config     tstamp;
 	u16                        q_counter;
@@ -871,6 +864,7 @@ struct mlx5e_profile {
 		mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
 	} rx_handlers;
 	int	max_tc;
+	u8	rq_groups;
 };
=20
 void mlx5e_build_ptys2ethtool_map(void);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.h
index bd882b5ee9a7..3a615d663d84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -66,9 +66,10 @@ static inline void mlx5e_qid_get_ch_and_group(struct mlx=
5e_params *params,
 	*group =3D qid / nch;
 }
=20
-static inline bool mlx5e_qid_validate(struct mlx5e_params *params, u64 qid=
)
+static inline bool mlx5e_qid_validate(const struct mlx5e_profile *profile,
+				      struct mlx5e_params *params, u64 qid)
 {
-	return qid < params->num_channels * MLX5E_NUM_RQ_GROUPS;
+	return qid < params->num_channels * profile->rq_groups;
 }
=20
 /* Parameter calculations */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 126ec4181286..ed25757ac5bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -391,7 +391,7 @@ void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv=
,
 {
 	mutex_lock(&priv->state_lock);
=20
-	ch->max_combined   =3D mlx5e_get_netdev_max_channels(priv->netdev);
+	ch->max_combined   =3D priv->max_nch;
 	ch->combined_count =3D priv->channels.params.num_channels;
 	if (priv->xsk.refcnt) {
 		/* The upper half are XSK queues. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index ea3a490b569a..94304abc49e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -611,7 +611,8 @@ static int validate_flow(struct mlx5e_priv *priv,
 		return -ENOSPC;
=20
 	if (fs->ring_cookie !=3D RX_CLS_FLOW_DISC)
-		if (!mlx5e_qid_validate(&priv->channels.params, fs->ring_cookie))
+		if (!mlx5e_qid_validate(priv->profile, &priv->channels.params,
+					fs->ring_cookie))
 			return -EINVAL;
=20
 	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 47eea6b3a1c3..570c42b7eeea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1677,10 +1677,10 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 			  struct mlx5e_channel_param *cparam)
 {
 	struct mlx5e_priv *priv =3D c->priv;
-	int err, tc, max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
+	int err, tc;
=20
 	for (tc =3D 0; tc < params->num_tc; tc++) {
-		int txq_ix =3D c->ix + tc * max_nch;
+		int txq_ix =3D c->ix + tc * priv->max_nch;
=20
 		err =3D mlx5e_open_txqsq(c, c->priv->tisn[tc], txq_ix,
 				       params, &cparam->sq, &c->sq[tc], tc);
@@ -2438,11 +2438,10 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *pr=
iv)
=20
 int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *ti=
rs)
 {
-	const int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	int err;
 	int ix;
=20
-	for (ix =3D 0; ix < max_nch; ix++) {
+	for (ix =3D 0; ix < priv->max_nch; ix++) {
 		err =3D mlx5e_create_rqt(priv, 1 /*size */, &tirs[ix].rqt);
 		if (unlikely(err))
 			goto err_destroy_rqts;
@@ -2460,10 +2459,9 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv=
, struct mlx5e_tir *tirs)
=20
 void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *=
tirs)
 {
-	const int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	int i;
=20
-	for (i =3D 0; i < max_nch; i++)
+	for (i =3D 0; i < priv->max_nch; i++)
 		mlx5e_destroy_rqt(priv, &tirs[i].rqt);
 }
=20
@@ -2557,7 +2555,7 @@ static void mlx5e_redirect_rqts(struct mlx5e_priv *pr=
iv,
 		mlx5e_redirect_rqt(priv, rqtn, MLX5E_INDIR_RQT_SIZE, rrp);
 	}
=20
-	for (ix =3D 0; ix < mlx5e_get_netdev_max_channels(priv->netdev); ix++) {
+	for (ix =3D 0; ix < priv->max_nch; ix++) {
 		struct mlx5e_redirect_rqt_param direct_rrp =3D {
 			.is_rss =3D false,
 			{
@@ -2758,7 +2756,7 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *p=
riv)
 			goto free_in;
 	}
=20
-	for (ix =3D 0; ix < mlx5e_get_netdev_max_channels(priv->netdev); ix++) {
+	for (ix =3D 0; ix < priv->max_nch; ix++) {
 		err =3D mlx5_core_modify_tir(mdev, priv->direct_tir[ix].tirn,
 					   in, inlen);
 		if (err)
@@ -2858,12 +2856,11 @@ static void mlx5e_netdev_set_tcs(struct net_device =
*netdev)
=20
 static void mlx5e_build_tc2txq_maps(struct mlx5e_priv *priv)
 {
-	int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	int i, tc;
=20
-	for (i =3D 0; i < max_nch; i++)
+	for (i =3D 0; i < priv->max_nch; i++)
 		for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-			priv->channel_tc2txq[i][tc] =3D i + tc * max_nch;
+			priv->channel_tc2txq[i][tc] =3D i + tc * priv->max_nch;
 }
=20
 static void mlx5e_build_tx2sq_maps(struct mlx5e_priv *priv)
@@ -2884,7 +2881,7 @@ static void mlx5e_build_tx2sq_maps(struct mlx5e_priv =
*priv)
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
 	int num_txqs =3D priv->channels.num * priv->channels.params.num_tc;
-	int num_rxqs =3D priv->channels.num * MLX5E_NUM_RQ_GROUPS;
+	int num_rxqs =3D priv->channels.num * priv->profile->rq_groups;
 	struct net_device *netdev =3D priv->netdev;
=20
 	mlx5e_netdev_set_tcs(netdev);
@@ -3306,7 +3303,6 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *pri=
v, bool inner_ttc)
=20
 int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *ti=
rs)
 {
-	const int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	struct mlx5e_tir *tir;
 	void *tirc;
 	int inlen;
@@ -3319,7 +3315,7 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv,=
 struct mlx5e_tir *tirs)
 	if (!in)
 		return -ENOMEM;
=20
-	for (ix =3D 0; ix < max_nch; ix++) {
+	for (ix =3D 0; ix < priv->max_nch; ix++) {
 		memset(in, 0, inlen);
 		tir =3D &tirs[ix];
 		tirc =3D MLX5_ADDR_OF(create_tir_in, in, ctx);
@@ -3358,10 +3354,9 @@ void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *=
priv, bool inner_ttc)
=20
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *=
tirs)
 {
-	const int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	int i;
=20
-	for (i =3D 0; i < max_nch; i++)
+	for (i =3D 0; i < priv->max_nch; i++)
 		mlx5e_destroy_tir(priv->mdev, &tirs[i]);
 }
=20
@@ -3487,7 +3482,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, s=
truct rtnl_link_stats64 *s)
 {
 	int i;
=20
-	for (i =3D 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++) {
+	for (i =3D 0; i < priv->max_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =3D &priv->channel_stats[i];
 		struct mlx5e_rq_stats *xskrq_stats =3D &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats =3D &channel_stats->rq;
@@ -4960,8 +4955,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 		return err;
=20
 	mlx5e_build_nic_params(mdev, &priv->xsk, rss, &priv->channels.params,
-			       mlx5e_get_netdev_max_channels(netdev),
-			       netdev->mtu);
+			       priv->max_nch, netdev->mtu);
=20
 	mlx5e_timestamp_init(priv);
=20
@@ -5164,6 +5158,7 @@ static const struct mlx5e_profile mlx5e_nic_profile =
=3D {
 	.rx_handlers.handle_rx_cqe       =3D mlx5e_handle_rx_cqe,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc		   =3D MLX5E_MAX_NUM_TC,
+	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(XSK),
 };
=20
 /* mlx5e generic netdev management API (move to en_common.c) */
@@ -5181,6 +5176,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	priv->profile     =3D profile;
 	priv->ppriv       =3D ppriv;
 	priv->msglevel    =3D MLX5E_MSG_LEVEL;
+	priv->max_nch     =3D netdev->num_rx_queues / max_t(u8, profile->rq_group=
s, 1);
 	priv->max_opened_tc =3D 1;
=20
 	mutex_init(&priv->state_lock);
@@ -5218,7 +5214,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_co=
re_dev *mdev,
=20
 	netdev =3D alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
 				    nch * profile->max_tc,
-				    nch * MLX5E_NUM_RQ_GROUPS);
+				    nch * profile->rq_groups);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
 		return NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 7245d287633d..731819a26a0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1702,6 +1702,7 @@ static const struct mlx5e_profile mlx5e_rep_profile =
=3D {
 	.rx_handlers.handle_rx_cqe       =3D mlx5e_handle_rx_cqe_rep,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc			=3D 1,
+	.rq_groups		=3D MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
=20
 static const struct mlx5e_profile mlx5e_uplink_rep_profile =3D {
@@ -1719,6 +1720,7 @@ static const struct mlx5e_profile mlx5e_uplink_rep_pr=
ofile =3D {
 	.rx_handlers.handle_rx_cqe       =3D mlx5e_handle_rx_cqe_rep,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D mlx5e_handle_rx_cqe_mpwrq,
 	.max_tc			=3D MLX5E_MAX_NUM_TC,
+	.rq_groups		=3D MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
=20
 static bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 539b4d3656da..57f9f346d213 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -172,7 +172,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv=
 *priv)
=20
 	memset(s, 0, sizeof(*s));
=20
-	for (i =3D 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++) {
+	for (i =3D 0; i < priv->max_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =3D
 			&priv->channel_stats[i];
 		struct mlx5e_xdpsq_stats *xdpsq_red_stats =3D &channel_stats->xdpsq;
@@ -1395,7 +1395,7 @@ static const struct counter_desc ch_stats_desc[] =3D =
{
=20
 static int mlx5e_grp_channels_get_num_stats(struct mlx5e_priv *priv)
 {
-	int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
+	int max_nch =3D priv->max_nch;
=20
 	return (NUM_RQ_STATS * max_nch) +
 	       (NUM_CH_STATS * max_nch) +
@@ -1409,8 +1409,8 @@ static int mlx5e_grp_channels_get_num_stats(struct ml=
x5e_priv *priv)
 static int mlx5e_grp_channels_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
 					   int idx)
 {
-	int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	bool is_xsk =3D priv->xsk.ever_used;
+	int max_nch =3D priv->max_nch;
 	int i, j, tc;
=20
 	for (i =3D 0; i < max_nch; i++)
@@ -1452,8 +1452,8 @@ static int mlx5e_grp_channels_fill_strings(struct mlx=
5e_priv *priv, u8 *data,
 static int mlx5e_grp_channels_fill_stats(struct mlx5e_priv *priv, u64 *dat=
a,
 					 int idx)
 {
-	int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	bool is_xsk =3D priv->xsk.ever_used;
+	int max_nch =3D priv->max_nch;
 	int i, j, tc;
=20
 	for (i =3D 0; i < max_nch; i++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 6bfaaab362dc..1a2560e3bf7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -88,8 +88,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev,
 	netdev->mtu =3D netdev->max_mtu;
=20
 	mlx5e_build_nic_params(mdev, NULL, &priv->rss_params, &priv->channels.par=
ams,
-			       mlx5e_get_netdev_max_channels(netdev),
-			       netdev->mtu);
+			       priv->max_nch, netdev->mtu);
 	mlx5i_build_nic_params(mdev, &priv->channels.params);
=20
 	mlx5e_timestamp_init(priv);
@@ -118,11 +117,10 @@ void mlx5i_cleanup(struct mlx5e_priv *priv)
=20
 static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 {
-	int max_nch =3D mlx5e_get_netdev_max_channels(priv->netdev);
 	struct mlx5e_sw_stats s =3D { 0 };
 	int i, j;
=20
-	for (i =3D 0; i < max_nch; i++) {
+	for (i =3D 0; i < priv->max_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats;
 		struct mlx5e_rq_stats *rq_stats;
=20
@@ -436,6 +434,7 @@ static const struct mlx5e_profile mlx5i_nic_profile =3D=
 {
 	.rx_handlers.handle_rx_cqe       =3D mlx5i_handle_rx_cqe,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D NULL, /* Not supported */
 	.max_tc		   =3D MLX5I_MAX_NUM_TC,
+	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
=20
 /* mlx5i netdev NDos */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 6e56fa769d2e..c5a491e22e55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -355,6 +355,7 @@ static const struct mlx5e_profile mlx5i_pkey_nic_profil=
e =3D {
 	.rx_handlers.handle_rx_cqe       =3D mlx5i_handle_rx_cqe,
 	.rx_handlers.handle_rx_cqe_mpwqe =3D NULL, /* Not supported */
 	.max_tc		   =3D MLX5I_MAX_NUM_TC,
+	.rq_groups	   =3D MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
=20
 const struct mlx5e_profile *mlx5i_pkey_get_profile(void)
--=20
2.21.0

