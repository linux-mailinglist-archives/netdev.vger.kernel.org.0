Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C71B14936D
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgAYFLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:16 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:6185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgAYFLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mce+CkzhbL2JfmqevC9zfJ9QXhFGDyqvOvylBn/xO5TdD9wRUd0QclgqCAErRONeu/D7Y+grxG5r3+SKz3DF3FjlBBbOCKD/85tAP+DL7s1Xa/kdRb7FsIi0NvoPcQvTavGWqTTvCJcSeNVVoolRq5dd99uKWysBabGuOAUAdID8qgF4HeDmwmydEgG2B3clrx1IPmLvX+50aAGRbi26INWvGPej3WROtomWVsd7cc+PtkFFujJdOM4u5PXVNZC5RvGIBATPHbnSc6tEioAkWOpJ+T/jJesavt591CtkFl8YlkUEzbgjoBYMtGefO1yquoBCMWKbCgd2EVyEwsngtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=ElNv78a24Fwq9EqwwGUjey9wCPnu4TgK8CDLgFumDMO6PcFf8xYtnCJYB4I3mi+HONBD3yA/1LfyGm8trHcHojuFImnRnQ7qwrblZXGwNRWin1tIJuH9Et7fEj9G+Q8HZQMR+QaWdlfpvWayWdVSwWPetPKK47wYWxSqNA1EiV9irAFnuWG30jxhcYHXTJAmhnFQR71mBwhDAYNedWzZqgO6i64bz5ly8rikCxswVhCE7mNbiqD9AOu7BbjCfVXQOD+OSXl7zdvewmN4e7/9h85U3ditfZKi5k69EejAw/iV2BHxZHC3hfo8fV9Gt/4bNhdCEEoWOw0VmP6dYne8tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcj+HKT7FXz+9Kn2T/sg2fMF/yXzhgzMYHIm/7qp/pU=;
 b=SEKRwxOv246ZuLtBu2r86Ayt1uSY4gtOFFm040CwDIxtkTfIn84NUQWCrwv57rvDT79Se21dcAu3UHllQfbcPVGQQ4Gr/KPWNeoj0Gbbjyk7QF19NHG7pC0Y+Z2WRCnnUTVjO21T3frNhssHe5k+OrM3CprB+77emUmMS1iEVZo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:11 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 03/14] net/mlx5e: Gather reporters APIs together
Thread-Topic: [net-next V2 03/14] net/mlx5e: Gather reporters APIs together
Thread-Index: AQHV0z3b8mJcDCChVUSv7mTJsEPzRA==
Date:   Sat, 25 Jan 2020 05:11:11 +0000
Message-ID: <20200125051039.59165-4-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3661bde-e119-4eb0-6357-08d7a154fd90
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394B74604D55BAF213BAC18BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kUq50CloUNWGC78Do4dhPkUdlOP1CRB1sZQVVezPpYTHH9lwLTngJGliNr3ctzcOgDG1P6Vkx1HRNPIYbb2+gOVqB8zbo/E3FUjO3tC/YdKkbekstUzEuvRuzt9uv7t7ST8etDbFtSylINAMylrmlx4H0IQOOSS2tN6tKuXjjBORoC9wXBDyuPhu1qPrbfIxPOLJAaf5Wc3HLQ3U9XU97IxQ8iIR8esh4zp+jXGOzJ5UC9drAgK11rRtVqoWKfZs75Eiz7RO8g84dA2fDj0qTDOZSn8krGbz8K+IHNQy82E0skUMUPuIswHjulw3995hcovqsXPPqtGf/U39p9iSZcE59Zb3n6Xech8f+kQude2oSD9IBAGKhrOyS1eoKjc9XLj7RFP+w/aAfzzLA5fISUdq6R8yNskCMZFtuXjU1kyQ/sc/3g4G91Z5M4DtwHgmTUfR/VIPcw7vsWt05XzkGQG7rIBHwEHtD4BXRf0NWdaqHy3cOKS3PAM8LNI826Lz7c0klZMliYTj7b11YWLLkfLy9mDnGgQLdBJRgy6Pz6I=
x-ms-exchange-antispam-messagedata: OcDIT+GKMpYdxZ0vDN3FTDFZcbBgnUSBS+CIG9jp4rWLENaH1ZTu6MIQsQuYvjP7cG76GdA896qSl3sWMxX48IAzvn1KUf01Yvf0v0/PJNoL8tA8d3I0JjBoITeIyrfkMMMGytyJTG1bUpnXlDVE1g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3661bde-e119-4eb0-6357-08d7a154fd90
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:11.4958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eoapAT4x3ZcjLYrHPhj+vEo4GSGIfU/HRwwNyRkJjiW724LUjIswMh3BmlDqvpxdnytg1/3ov0jTFwPcAwMLUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
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

