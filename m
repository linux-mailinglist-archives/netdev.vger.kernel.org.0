Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F42A149082
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgAXVzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:22 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727493AbgAXVzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky1zNzbO8dujZpsR2DQgUasdQbGs3T+TYpv8Zhim5y5LBozrI4FBFxJiQUvXPm3bO+ZfWDUqGSaHYd1f+ldocbUZZekO9EjiV+xoi/eOxk4/dvpLKf/2CGT/PdKkr9Y2vYMpDXaZdO0LUNTReQbq1/exCNKf5xKYMGGOIunyuIHagBORoGtKiqTNpUBHFB4KFk8Jf0yEVdBddr0VlRuuENpTMBagsUtaWjdi+Aytx+B4pZAI5VeXG/Cw4aCUwddjpOjR3Qe8fIy5al7OLgC6cBKNM+T0yKzX/IlIEIc4Y/t1yYEcXXmljI2DFdNENJVixFK4IRUaCVHXhGbVkMWdUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fw6oBkGZZlmb0CuVuHR9ygEr3nwOisOnd+l8lJ1RlA=;
 b=SxVvY3xp90cXxIvCjuypWUynfPjVqZoKLOgg9az9SVRgfMQYNWV7UcureT+3wp+B+O/vb3gTYXBD0ELL7vIp9ze0vluOi7d4sqdXJweLg9578FaHpZVIe4s7zio3PQuzOWstvhZSlrie/XRj783+eYIYDGMPdlee7NUaxD6UqAYpk/Ks/EPUPVbcAt1pGKblx0o0pPJYmQoIf0S9xUfXIUQSMhJeQmK0osJa4bWAbVMxj2Kk6V8vG/x0m7dVmJakZq2xCkSHIVvUIo6dGlEcln/8dOUd2IRuyWswRJfenA9Muvgh78ckcV29tB5F8A4qpcPi2hqCF0R4v62PyJ1qLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fw6oBkGZZlmb0CuVuHR9ygEr3nwOisOnd+l8lJ1RlA=;
 b=kDl96Cq9l/YxOfV24KCoWXbsdC5QkWXs56986TDzk92ENLaL4dAAiugvmRpXbHBRc1wkF5g/Qs69Y35ckEq8svzpnoU9+UPCV6eDuaBs3Pvyom+PEUczXcoi039uJ1A3spwbA+GmzTIzA6ycslCb1HzU/5tGT9I/Pt9/9CRdBrg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:08 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHV0wDwhVlKH3k3QUuFraNLfeJazA==
Date:   Fri, 24 Jan 2020 21:55:07 +0000
Message-ID: <20200124215431.47151-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d94cbc5b-78ca-4b47-d06b-08d7a118131b
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5456A84A43E629FAEB5E1083BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B2DGanPAAxFEndt4JE+d15QZt2iwN9SQL5PPqvt5QFEBbMPwRvhlYFY6Czp2F5H47OzZozdIG7OQzsQQvvopLCeJw2xu9U/pXRprtWtobUfmipUvFN3BWXgmtyex9hP+Oy/LowHsdTe+hWzDKDx/4GbufMdIig9V2pP2owJIgGJk99WLbV6onSUpA6hIYB0yDzb8sxkXlMU79ASlY+5NsIdY6s5jgZ08Jas8Pa3toKcgV5c65BreHmO2X9TL8TkMCB/tiiVGGeJjyR6J5EJIIzGyi0IKI4p43GKLEqGQyAIzmKvMweLy57pRI7ZsPL99hc8oTE++UFG6k9/WMe8HSdO49fwilzPuqKaRxVRarxb3oU5cQulRFavZV3AZMLIH9Gwl7y96V2AR9JIjuFcrYsLaseXZ3GLZLgHVbTDGtFBYs6oJ/b/ajy6L1oMN2YRGgiD9wm8nK/YIvFZL/FX5SFNsS9HBEqM0UCqgf1/kvoBo4c7CcMdeq7garI2DWIMTmVyIVvH0en4WgiMJFfz4yRHsVSEdKw2UgvgSu8SEOng=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94cbc5b-78ca-4b47-d06b-08d7a118131b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:07.1239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53eTN2Qc/LTNpGmw+nxc9JfeqP3GpQLs3nVWV/IOikCHKUgRW6wItJZBFOUaMR+YoM1QGZw1PE+SAR5kn2UR5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>

netdev_err should use newline termination but mlx5_health_report
is used in a trace output function devlink_health_report where
no newline should be used.

Remove the newlines from a couple formats and add a format string
of "%s\n" to the netdev_err call to not directly output the
logging string.

Also use snprintf to avoid any possible output string overrun.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  9 +++++----
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 7178f421d2cb..68d019b27642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -198,7 +198,7 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx)
 {
-	netdev_err(priv->netdev, err_str);
+	netdev_err(priv->netdev, "%s\n", err_str);
=20
 	if (!reporter)
 		return err_ctx->recover(&err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 9599fdd620a8..fdd81f76cd1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -519,8 +519,9 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+	snprintf(err_str, sizeof(err_str),
+		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
+		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -534,7 +535,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on RQ: 0x%x", rq->rqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -548,7 +549,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *i=
cosq)
 	err_ctx.ctx =3D icosq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_icosq;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 1772c9ce3938..90a24eda70d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -375,7 +375,7 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
 	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on SQ: 0x%x", sq->sqn);
=20
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
@@ -389,10 +389,10 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
 	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+	snprintf(err_str, sizeof(err_str),
+		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x=
%x, usecs since last trans: %u\n",
+		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
=20
 	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
--=20
2.24.1

