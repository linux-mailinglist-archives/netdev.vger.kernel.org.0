Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C64314620F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAWGkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:07 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727093AbgAWGkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB8eHW4sEpaIXaLWf/+JuVO4TZeYTSP1e5jnPJRC0IZRyf/Ukq3wHIZmgxpVu1Tc1N8Kdf+9k3SwoCxxH4aIiHeidkt+0GayDrvYwrmktmgaxkk9rgBUSHpruPXW26OHVe98W5fc7t+CXPe8sPDni056NFpxoxdDfDLakAnlpD1u2z562QZ44yvCUeYkw4Ozmx+JCnmWOmD0BNVdvvXOg7fKLrsnLlCsgWEbwoACnjlmnAzD3eoTzN7bCvNi48QZMPPyVMcCK1vV+DT5BQcM0sBHinVD53iEWq0hL6+UxTy2j94w3lFlH+EdkdoNvbos5YSNwd7YEL/glc2T8PzIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Amvt2B1ALHA/1Y5f5PIT7nnm9TBxlYdjWswJebfZZY=;
 b=dOVM/9I9daL2JMLtgttfiMj/gg8ckGUhTd/2r9bpKfVtXdEnjla2Mcjsg0dJua3Cqy63zXHRB7bzZW8iIs4xXcKav94//R+mSpCWXHIuEuT8HI1ZZUOTf7JHQg/KayxkdX/dT/rjbtFuR4MxsxMDBLDIzrCQMLcCTsl015ayFbciXSCO+6wLrAPCh+PeJ5FqSYJ96aR1sNxi8HGo7jEIzrGIYaePHtjOshKwcb40vTxK5U+ZsEjxm/KxKQSxe8SC4xvE7o5ZX5xNM/civfcJxXJqbbQeWSm3NkmudpHP8zwXYAgEYC+57Rko4guhr4cnJRMPc/pB57yuWAY1NJtJ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Amvt2B1ALHA/1Y5f5PIT7nnm9TBxlYdjWswJebfZZY=;
 b=Y47Ak27RbzUZfdWbmzClI6kJWkqCAiAdX7OyJyzFJelyVpAp4NcuD7ahB3yVmWKsF57cmLDsmsd6rE5m6DMoG4YE5gIe4yAmq4ZBUSHVIqTl1Nc02HS2A8idLGtY2cYUgj6fc7bYC5lIQj4QOnHim5ObrhHO8dHqvSgmQras86A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:57 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: Convert stats groups array to array of
 group pointers
Thread-Topic: [net-next 11/15] net/mlx5e: Convert stats groups array to array
 of group pointers
Thread-Index: AQHV0bftIjaANtspBEOpmWZtOSWRjA==
Date:   Thu, 23 Jan 2020 06:39:56 +0000
Message-ID: <20200123063827.685230-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cc77aae9-7274-4497-13f3-08d79fcf0fb7
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941A106E5092815058E5BA3BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /aUbShTFmWGVfUgPvvrpcdf4CG3qLKiGdgKCEsNyupVUsul95HBqBlKDh1XOa4X5+9LPChqkpFYhf2eztOi5bCcRVNiLrs8OT1C9kRKJs0KSWcDBMJnGEtf9KSrJMS5pBUIG2kBxCnPA1Sv84JbFBUlaHCJrDVlheZhlneyW3d3yPkFBVW79gTcruXBjqCF9o3gLZ69yTCwXva+yYk7+Pi3t6tA4yBpE/THy8MTDtkLdAyouO5hm+oZb8afB01DxLUV6MkkfKsyRARHSmbZhjvAr5ZMb2ZrTBfXmVdv85b6kIo3ezu3VQUub3GVbfUJB6A5z+SnpOZLY8vB1JvNeDPjNzqnSAUaTiG/8iIM9b9BOgWN8MZq6aChMr+7v/0qmP1KMl3m2WgMRSlKGUgpwlqrSXm9smM9cAAJ3fBooblimxSrykT28QILvDM8aQFOI33eg7NXr0z8zmjqHWRU67qApPYfcNvgW2+2+3/FK0Exj1U+jrGA2jrh/vJocfZlmOiF8q1FyGkIkU1Vg0lKgitlUpkgRDDE7VKcViR6iuqs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc77aae9-7274-4497-13f3-08d79fcf0fb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:56.8926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKmxjR3TpaekLrpypITXVMqtJBfL0+/AFtaRqcB6Zf8Vu3mAiJIndl7dpdK+EVoaAM1W+/+r/1wYzFYYHGjsCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stats groups array to array of "stats group" pointers to allow
sharing and individual selection of groups per profile as illustrated in
the next patches.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 69 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 12 +++-
 4 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index f85d99d601a6..220ef9f06f84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -893,7 +893,7 @@ struct mlx5e_profile {
 	void	(*update_stats)(struct mlx5e_priv *priv);
 	void	(*update_carrier)(struct mlx5e_priv *priv);
 	unsigned int (*stats_grps_num)(struct mlx5e_priv *priv);
-	const struct mlx5e_stats_grp *stats_grps;
+	mlx5e_stats_grp_t *stats_grps;
 	struct {
 		mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 		mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index a1bb9eb8e3b5..f3600ae4b0a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -164,9 +164,9 @@ void mlx5e_update_ndo_stats(struct mlx5e_priv *priv)
 	int i;
=20
 	for (i =3D mlx5e_nic_stats_grps_num(priv) - 1; i >=3D 0; i--)
-		if (mlx5e_nic_stats_grps[i].update_stats_mask &
+		if (mlx5e_nic_stats_grps[i]->update_stats_mask &
 		    MLX5E_NDO_UPDATE_STATS)
-			mlx5e_nic_stats_grps[i].update_stats(priv);
+			mlx5e_nic_stats_grps[i]->update_stats(priv);
 }
=20
 static void mlx5e_update_stats_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index e903a15e7289..85730a8899c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -43,46 +43,46 @@ static unsigned int stats_grps_num(struct mlx5e_priv *p=
riv)
=20
 unsigned int mlx5e_stats_total_num(struct mlx5e_priv *priv)
 {
-	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	mlx5e_stats_grp_t *stats_grps =3D priv->profile->stats_grps;
 	const unsigned int num_stats_grps =3D stats_grps_num(priv);
 	unsigned int total =3D 0;
 	int i;
=20
 	for (i =3D 0; i < num_stats_grps; i++)
-		total +=3D stats_grps[i].get_num_stats(priv);
+		total +=3D stats_grps[i]->get_num_stats(priv);
=20
 	return total;
 }
=20
 void mlx5e_stats_update(struct mlx5e_priv *priv)
 {
-	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	mlx5e_stats_grp_t *stats_grps =3D priv->profile->stats_grps;
 	const unsigned int num_stats_grps =3D stats_grps_num(priv);
 	int i;
=20
 	for (i =3D num_stats_grps - 1; i >=3D 0; i--)
-		if (stats_grps[i].update_stats)
-			stats_grps[i].update_stats(priv);
+		if (stats_grps[i]->update_stats)
+			stats_grps[i]->update_stats(priv);
 }
=20
 void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx)
 {
-	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	mlx5e_stats_grp_t *stats_grps =3D priv->profile->stats_grps;
 	const unsigned int num_stats_grps =3D stats_grps_num(priv);
 	int i;
=20
 	for (i =3D 0; i < num_stats_grps; i++)
-		idx =3D stats_grps[i].fill_stats(priv, data, idx);
+		idx =3D stats_grps[i]->fill_stats(priv, data, idx);
 }
=20
 void mlx5e_stats_fill_strings(struct mlx5e_priv *priv, u8 *data)
 {
-	const struct mlx5e_stats_grp *stats_grps =3D priv->profile->stats_grps;
+	mlx5e_stats_grp_t *stats_grps =3D priv->profile->stats_grps;
 	const unsigned int num_stats_grps =3D stats_grps_num(priv);
 	int i, idx =3D 0;
=20
 	for (i =3D 0; i < num_stats_grps; i++)
-		idx =3D stats_grps[i].fill_strings(priv, data, idx);
+		idx =3D stats_grps[i]->fill_strings(priv, data, idx);
 }
=20
 /* Concrete NIC Stats */
@@ -1700,24 +1700,41 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channe=
ls)
=20
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(channels) { return; }
=20
+static MLX5E_DEFINE_STATS_GRP(sw, 0);
+static MLX5E_DEFINE_STATS_GRP(qcnt, MLX5E_NDO_UPDATE_STATS);
+static MLX5E_DEFINE_STATS_GRP(vnic_env, 0);
+static MLX5E_DEFINE_STATS_GRP(vport, MLX5E_NDO_UPDATE_STATS);
+static MLX5E_DEFINE_STATS_GRP(802_3, MLX5E_NDO_UPDATE_STATS);
+static MLX5E_DEFINE_STATS_GRP(2863, 0);
+static MLX5E_DEFINE_STATS_GRP(2819, 0);
+static MLX5E_DEFINE_STATS_GRP(phy, 0);
+static MLX5E_DEFINE_STATS_GRP(pcie, 0);
+static MLX5E_DEFINE_STATS_GRP(per_prio, 0);
+static MLX5E_DEFINE_STATS_GRP(pme, 0);
+static MLX5E_DEFINE_STATS_GRP(channels, 0);
+static MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
+static MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
+static MLX5E_DEFINE_STATS_GRP(ipsec, 0);
+static MLX5E_DEFINE_STATS_GRP(tls, 0);
+
 /* The stats groups order is opposite to the update_stats() order calls */
-const struct mlx5e_stats_grp mlx5e_nic_stats_grps[] =3D {
-	MLX5E_DEFINE_STATS_GRP(sw, 0),
-	MLX5E_DEFINE_STATS_GRP(qcnt, MLX5E_NDO_UPDATE_STATS),
-	MLX5E_DEFINE_STATS_GRP(vnic_env, 0),
-	MLX5E_DEFINE_STATS_GRP(vport, MLX5E_NDO_UPDATE_STATS),
-	MLX5E_DEFINE_STATS_GRP(802_3, MLX5E_NDO_UPDATE_STATS),
-	MLX5E_DEFINE_STATS_GRP(2863, 0),
-	MLX5E_DEFINE_STATS_GRP(2819, 0),
-	MLX5E_DEFINE_STATS_GRP(phy, 0),
-	MLX5E_DEFINE_STATS_GRP(eth_ext, 0),
-	MLX5E_DEFINE_STATS_GRP(pcie, 0),
-	MLX5E_DEFINE_STATS_GRP(per_prio, 0),
-	MLX5E_DEFINE_STATS_GRP(pme, 0),
-	MLX5E_DEFINE_STATS_GRP(ipsec, 0),
-	MLX5E_DEFINE_STATS_GRP(tls, 0),
-	MLX5E_DEFINE_STATS_GRP(channels, 0),
-	MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0),
+mlx5e_stats_grp_t mlx5e_nic_stats_grps[] =3D {
+	&MLX5E_STATS_GRP(sw),
+	&MLX5E_STATS_GRP(qcnt),
+	&MLX5E_STATS_GRP(vnic_env),
+	&MLX5E_STATS_GRP(vport),
+	&MLX5E_STATS_GRP(802_3),
+	&MLX5E_STATS_GRP(2863),
+	&MLX5E_STATS_GRP(2819),
+	&MLX5E_STATS_GRP(phy),
+	&MLX5E_STATS_GRP(eth_ext),
+	&MLX5E_STATS_GRP(pcie),
+	&MLX5E_STATS_GRP(per_prio),
+	&MLX5E_STATS_GRP(pme),
+	&MLX5E_STATS_GRP(ipsec),
+	&MLX5E_STATS_GRP(tls),
+	&MLX5E_STATS_GRP(channels),
+	&MLX5E_STATS_GRP(per_port_buff_congest),
 };
=20
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index bc97964cd721..29ad89f66bf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -69,6 +69,8 @@ struct mlx5e_stats_grp {
 	void (*update_stats)(struct mlx5e_priv *priv);
 };
=20
+typedef const struct mlx5e_stats_grp *const mlx5e_stats_grp_t;
+
 #define MLX5E_STATS_GRP_OP(grp, name) mlx5e_stats_grp_ ## grp ## _ ## name
=20
 #define MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(grp) \
@@ -83,7 +85,13 @@ struct mlx5e_stats_grp {
 #define MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(grp) \
 	int MLX5E_STATS_GRP_OP(grp, fill_stats)(struct mlx5e_priv *priv, u64 *dat=
a, int idx)
=20
-#define MLX5E_DEFINE_STATS_GRP(grp, mask) { \
+#define MLX5E_STATS_GRP(grp) mlx5e_stats_grp_ ## grp
+
+#define MLX5E_DECLARE_STATS_GRP(grp) \
+	const struct mlx5e_stats_grp MLX5E_STATS_GRP(grp)
+
+#define MLX5E_DEFINE_STATS_GRP(grp, mask) \
+MLX5E_DECLARE_STATS_GRP(grp) =3D { \
 	.get_num_stats =3D MLX5E_STATS_GRP_OP(grp, num_stats), \
 	.fill_stats    =3D MLX5E_STATS_GRP_OP(grp, fill_stats), \
 	.fill_strings  =3D MLX5E_STATS_GRP_OP(grp, fill_strings), \
@@ -365,7 +373,7 @@ struct mlx5e_stats {
 	struct mlx5e_pcie_stats pcie;
 };
=20
-extern const struct mlx5e_stats_grp mlx5e_nic_stats_grps[];
+extern mlx5e_stats_grp_t mlx5e_nic_stats_grps[];
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv);
=20
 MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3);
--=20
2.24.1

