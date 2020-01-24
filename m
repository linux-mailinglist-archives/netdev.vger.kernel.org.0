Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6528514907F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAXVzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:10 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfGQVU+1pEPFzwNnZUbQZrQ46yOKOXtvSE8WiTlmrrT72C1NZQoU092o1/yBzCubQ3qhI/ZiumTgD15VZIHdjrDskK7QQr/f4mELCjAQtEGJLavVp77+4KDFVXtzrWMSogaAGtNmniMaJ4UIf9iniv9wAJD88zluMfdDk8bXNR2oocneesU+ox1Vqbq6XSe8zzkdcmml40o7Jg872cSnVFsFaP6heTQXcdYSvI6S48BYUH5GtgQELuHRJjtFOK9rKRXXFOtYOT46XKgL4VJNF+RDNCs4F2mdmJsm0OwQUc8rRxUgosz12CDOTY3bkYbfJpytPe8WAzyl3UYa1fo0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=NU2iRO550FnJ/fAko7HAqpHah4YxMxOK3Ux/qHrFYb1aiC0on5ZEkxctWi+ifRv6CLI4/pePpRznUHLJ0PczhW/wheAZMr+sBhLhODzTzg7Wa+iyi4u3WOVrDwpw2hFnrAre+UcA2SS0tej4zqbgMisbe/lp36OWKJTUAtfUn3T2DzgAt4ZtG9yBrwgSlktGWcmFKc9IdFYlJIVtMDILLwQX0EzUOp9D1ko76Y4DmMtACqbMrbvembUl1CqykTvImaS8r6rBuPLpL77cF4Dykd5HOM4h9pU9W9T3ggl6Vrjz5T8iLhMzaergMTAsUfYEZHLF+sTH2tVSJOMTnNHECg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=M8dbBfMJwC4IX7c82n4Ce1PbcWqqVUE8vmZgQ/GssWSeoQWmVv4wQldWL+cA9CxAzJfO3OgVKM54s2wTc9xEQNUPU3DTZrZ6mgZRTXyNkAv+KBSWqsZhrZsBvz8TRuRjAVV1nsTjRTk3YTbE/ArTYFJzyCRhtutYLTuRSLIlnWs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:54:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:54:56 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:54:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/14] net/mlx5e: Gather reporters APIs together
Thread-Topic: [net-next 03/14] net/mlx5e: Gather reporters APIs together
Thread-Index: AQHV0wDqLYfhjgv+8Ue46hIwfQ04LQ==
Date:   Fri, 24 Jan 2020 21:54:55 +0000
Message-ID: <20200124215431.47151-4-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 35790897-d90f-4777-fd06-08d7a1180c69
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54567F3ECC9DF6178765DD78BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7TOCo4gJULiUfdFCemL6SOHqc0Iu5keVMiiQLVNp+ri8smtfL8EX0wShgY0CJATemUE+vIt8pDub3lBIdt42EG+kHTgwDMPZRHtABz0WOgWCodHTqfU+4yn397Tm1Ff8yo6NK3Fc4yOzqDKYhmz3Ue/rfpepX7tRbuf0TWMMnX83IC6YCLaXMJeTtBepbvlpAT7VW2OsNXmZwVJNxfonT5W9zcisFk9TlO/s5w2QRnEEPW1qMqkD1g8uaHnGS9n+HHuCYsB3ZDz7blJfWn6qKtpV2mJjrOmcq3Po/BxIpY52XlHK1l6esZIfaHsCEAE0uRR1SXJZeCq78wd/1oo2HKAJXQ3iVbEjrPHGwl0jusyyEGn+jFK4kVvQarsQH3uwUAvXNoJ7Y0hrnLPZ9ETJUec+ndj8Q5SrFbKcDIXiTbLVkfjjtj9YEebWbuVuvNifN/IqDJtEElbQy9lEIHbglMgei2XMjCIHW/kVZlYDspIqYeoXm4Yr35pAl08VNWZ6weiCB2/FCUjy/zXMshVpKv74kwZDoQSFn9dDbqTaOF8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35790897-d90f-4777-fd06-08d7a1180c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:54:55.9831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IA9AaZpkB6l+F2s6ynBNgXn4uYcVghKBySJIeUzCq4SSx0ZWIY94dcinladuAgl6X9+bcypfLCVKiAElB5pHJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

