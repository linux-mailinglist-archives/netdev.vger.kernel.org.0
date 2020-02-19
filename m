Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E861163B0E
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgBSDXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:14 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbgBSDXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZT8jAwpyWuk1nJeIq/5Hl3e06KC2Rx0ul61IkbVAG99JIYbBRvnFnOXZ0HrOlZM06V+aukGuF425Cl+YQ54LEjegykt5GXgLim6xiBNBNtqOg2xQj0N0akNJ9Uq/fg+GUwrFF5HL8eV6R6eOoqbQlSlHnVwlRbTeg1A41+fINpPF5pdra41/uFzQrGVXGh88S7B5xoJ7GVjqC8BpNpx46JY4lqWxDfgpIvNzXaOB0Mov4IUjXXzsKwt76k8euljNvekj5A4em2rFz4UnYX7I3e94TCP0b0dxhK0h1DVqx0CpBH9XCJljH6kCyC9IuTEU/3p0KKZYz6iVBV/LR1OB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=ANFK/djNAoHX3ReJy7l/bDd3DZHTkfbAHMvydwgVZQ7jBvk0rDfC4zCIzA1DUPdZeUKZnsZ1/rpgvWDpNNaQ5OZrpOPCpBUMz3BS8vUIbyppgePqRv1zdLG/PVdAbyJxOK0RQsCTHdj15NW41dPVKOKJMrK+t0g3sxGBit/LW0s1vYhEa27c6fSU/zwxRUs+BoRQscFIOUOPh/r9tVoi/B3Dz2984fLmv+NEkkHVbetcIHlwxWp5CiEPXG7LviAIDPfHI8R1BZibLagKZo4uBLKutLVn0KT9zgpMX3nK9nAafiU0Sx2zmxRz6xLAuY3wwHOuhiW7krxjXv2mbzafgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=RxCJTRVMS851TcRX3rzMUR69sAbxSy+Qv1ShorAZf125GC8+amGbS/oD+e/K82Qgun+YLo8EhVm+YOIefzs3pb0fGXhVR5kYglBuiIY58CX7aNCsNz59a8cZU2Ay4ci9n4RPM1LVLCim8er7nk7MjAN0JwjpTWP2G3aEnT70w7Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:06 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 03/13] net/mlx5e: Gather reporters APIs together
Thread-Topic: [net-next V4 03/13] net/mlx5e: Gather reporters APIs together
Thread-Index: AQHV5tPmrfJP4+6LukeKtBWp9mReFg==
Date:   Wed, 19 Feb 2020 03:23:05 +0000
Message-ID: <20200219032205.15264-4-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ece87a7-98aa-499d-27ed-08d7b4eb0908
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4590068A79636CC0F8FE4D70BE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDx3jIfVtMew1Q2q1KRtNHLj94zPo27m+NypXzQ/V2cX6rjBpGLKdb4fY/kujftHigxZUwVB2/ae7LqlXiBeiAMKkyYManAlfA/yecWo2uCv3JTe312ZOSMN32HOXcsUDHDT5ORLLWmBLSrMkMAQ2KVRYWvbgNpwjtaWIujIEZh/Dhv6MwfFYv7YelDyiIgUdjTY9GhBaM7vAR/boavODSu7UaxZDJxuzuDpfKznlEmcX9wmYZNY8mfNBeMkWOANYLxqRWef4vlyBBZul+IJF53YhzYIOtxvPj+DCfMnZE9OP0gUdNxKabg6PUq6pbKa+/gdxo5XocMbtZdH8gf3QNKfqejxX+cEJiHQuJveP03UIGfVOUnfcK3gjv9G7HopakiQGo+hua0/dFuBVNELBfdPv3rxMalIpy/FqlSAfi4K1c8HoTWTcRUuhjEuKws10CumdtJBuh/olyhxL6T1/KYIPmugrgpdvfl8RA75I/DFa/TNJ1VC7zGP3n2KFiiebboCTWQrjEYrFHJaqf7iy+6+WQJuFQ4TQhQPtjIz53c=
x-ms-exchange-antispam-messagedata: V+8oydn7u6SXpj/nl9Cqf2HdYeutp2rjatIFFbv2icj42pofKolRPrMH8UuTeGQkVQivMN6mDFa7NGbsqP7XFI3lioYeQBlzTZj0Ojr6lAogUhB0xifdegTSmmUXjrV6owHJeDfT3e4ETLliyqJ+6Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ece87a7-98aa-499d-27ed-08d7b4eb0908
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:05.9467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejrLv4qCeXCyBAOUk2tfEqxuS61nkkEmh++HOavL0Xd6fL9fNBVVGumTrtauXy/iLFJ3EhAbXvnbKr4BnGtDzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Assemble all the API's to ease insertion of dump callbacks in the
following patches in the set.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 82 +++++++++----------
 .../mellanox/mlx5/core/en/reporter_tx.c       | 58 ++++++-------
 2 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6c72b592315b..cfa6941fca6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -102,19 +102,6 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(voi=
d *ctx)
 	return err;
 }
=20
-void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
-{
-	struct mlx5e_priv *priv =3D icosq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx =3D {};
-
-	err_ctx.ctx =3D icosq;
-	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 {
 	struct net_device *dev =3D rq->netdev;
@@ -171,19 +158,6 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *=
ctx)
 	return err;
 }
=20
-void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
-{
-	struct mlx5e_priv *priv =3D rq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx =3D {};
-
-	err_ctx.ctx =3D rq;
-	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5e_icosq *icosq;
@@ -201,21 +175,6 @@ static int mlx5e_rx_reporter_timeout_recover(void *ctx=
)
 	return err;
 }
=20
-void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
-{
-	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
-	struct mlx5e_priv *priv =3D rq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx =3D {};
-
-	err_ctx.ctx =3D rq;
-	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ct=
x)
 {
 	return err_ctx->recover(err_ctx->ctx);
@@ -371,6 +330,47 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
 	return err;
 }
=20
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
+{
+	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
+	struct mlx5e_priv *priv =3D rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D rq;
+	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
+	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
+		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
+{
+	struct mlx5e_priv *priv =3D rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D rq;
+	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
+	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_priv *priv =3D icosq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D icosq;
+	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
+	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops =3D {
 	.name =3D "rx",
 	.recover =3D mlx5e_rx_reporter_recover,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b468549e96ff..623c949db54c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -82,19 +82,6 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	return err;
 }
=20
-void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
-{
-	struct mlx5e_priv *priv =3D sq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx =3D {0};
-
-	err_ctx.ctx =3D sq;
-	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
-
-	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5_eq_comp *eq;
@@ -110,22 +97,6 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	return err;
 }
=20
-int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
-{
-	struct mlx5e_priv *priv =3D sq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx;
-
-	err_ctx.ctx =3D sq;
-	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
-
-	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
-}
-
 /* state lock cannot be grabbed within this function.
  * It can cause a dead lock or a read-after-free.
  */
@@ -275,6 +246,35 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
 	return err;
 }
=20
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_priv *priv =3D sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D sq;
+	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
+	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+
+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+}
+
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_priv *priv =3D sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D sq;
+	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
+	sprintf(err_str,
+		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
+		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+
+	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+}
+
 static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops =3D {
 		.name =3D "tx",
 		.recover =3D mlx5e_tx_reporter_recover,
--=20
2.24.1

