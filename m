Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A79149370
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYFLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:41 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727166AbgAYFLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsolRWef528NnfO7IFmYkcIyne4V5vVz8zQVB0o+P1qG7Tw9YWKrVJXjKz1FpId7K880RVCh0j/GKq6M1hgyDzKR0sd6L7ow1UPeQLmGSitB15/glF/1GygPPbaX5/U8JAJqjlI6Q3pwQ+rC6Ou2SNpo4JTljItZX/ZdZxBl9fiIhVgDIXKfBa0AWuNrgfZ0N4LwbI+6Uz9LAoh50M1ItPPNQhubyxqI8z0znKNMd2JBjRq8Dp2mHTEoBqZK9nGPrZqNpI0XtyZnvKJrpnHZKwx+h28rinmcRm/H4sAJBFUz2JIFs7QQlv0u2Q29nbq/00FTrMvnUYPTDroQwBCJsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Lr1wBce73mKpULZgJ61NEpBs4TTds3qCF26sbgUGM=;
 b=OSkzN+692KjhFBb7FwXjyLJvdpKqjfOphFBnSqj6mkXKOAZz5yUFIXNu7Zt5alUXkrapWqDyH6VzXG0BX7Ni3Gy5rVjsbA9wGcghjZkYFXTRcXe1f7aja/ChmXSjwGoXMF9GCXKrt/8Q0gg6/V1LPFnBJtN/Rtrx1vQ0bv7pvYomouccql41ORU5dC+1QeD5tWgBvtLOSJbsimDbDE1Db4FrrjJgScc53fmJaB/Kzr+3h6xYarU3ZUTbyYttOU5JcRkAVzh3gwUJ5bMtee4ilDNBq6kf/h9Gd1xJB0nOrcv9pidCazA9gS9v6K64xz4OwgOdSE8hA50N4JZyy1vq3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Lr1wBce73mKpULZgJ61NEpBs4TTds3qCF26sbgUGM=;
 b=b9UGlQ0tWPfiuDdztH6dkqPyucl7s2orMQOodyi/Ck5ZI+ESsTq2ItsOzFu/USiYpP8h2Mr6/bm/qid9HWGpTpICgqhs14Z58N2I6FrStGPkALkD/M0OiuNJnUJ9f/0bG3P0Bjpa8D4a4Ssx/cXo39dT17nf6o0KJfafKazfOFw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:25 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [net-next V2 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHV0z3jGv4V0Aw1bk231Hw4bCyJ7w==
Date:   Sat, 25 Jan 2020 05:11:24 +0000
Message-ID: <20200125051039.59165-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a1ac7bb0-e853-406e-0c62-08d7a15503ea
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03944B2122A66D70EAD9CB3FBE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MOtD3v53GW6G50N9jaLA/+rfb3KEbeb8xarjSdAxZ04MrwLNbCNiJV2PUvuHPGrYCNmKV0CrIxss0k3dvarKQuXpGC1cfAu36701xX6vamseLHS/keOkeHSRkbuuq3wO7XOBjg+FVPtPQ/xBoZHxdPL2CSYKOI9yJtJSyD8O41AJMSBHB4hQNP56OH7tBHFU1+yeYbLJQJsvcpy3Fw5USovolNFfnhA7QPhnzG6wqeV7QSuDNioanWRWO87zGkkiEQ+07lVv4ppgsSRQMBgB9D1UuAmRS4tj2XbOdYVlfK1PCTG9/A11dLy5wmC7WRh3EgcKs++RdWmEfRB0Ish1lDNqIDT17xCIRUpql320z+ZoBrPqZ66nt88wemC+DrPf7uKY4Z5JiSWyfddl2yW0Jf8Q+tu8Su1DspvWPKMOI1xHSkaVqzsZtZnNJ/WNIZi/ZeTtTd/35lIYiAn2683Bv4wAW07GbqxLKs7laiPKW2IAaE3TfzoXe8JtMfnSe7XLbWCBphpLhDvaVUVXgSVMevJ68EFRSCGVgeRcHoJdvs=
x-ms-exchange-antispam-messagedata: qcbkAWbKtKrL6cTkE9DBZxRx3xJeSaFErprtHrBmnlsa3eaCLXjXKFbVkBgmRG+iwkJZiiXiI721Lr1K4lQkAG28IXtZIlrAVLI8R83EJdwst/q0PrGZkkPUozSZt4VW0RPsvOrukWhp9dUR/JhAWA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ac7bb0-e853-406e-0c62-08d7a15503ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:24.8352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MBOSUfhi/l/rOxCdWPWr83CdGFK8WtBVthVHtnBDVBLLRelBJ/lF0UAts18GY4H95I1R0jwY628C4usOsAPb+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
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
index 9599fdd620a8..ce2b41c61090 100644
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
+		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
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
index 1772c9ce3938..2028ce9b151f 100644
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
%x, usecs since last trans: %u",
+		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
=20
 	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
--=20
2.24.1

