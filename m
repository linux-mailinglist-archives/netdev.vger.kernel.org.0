Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3796A64
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbfHTUYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:31 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730929AbfHTUYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXkfw7IupsPLF/nMTzViY3Uzj9655Mm01GEDw+/eb+xequUH0ewJrcr+oPxX8/iV5oPQsMJ+KJ0A7B/XhSchEucBceRqYv5aFlQOoyOBas3XjVApyBnmnUGuc59c4pAajKzflwGebdtLNX6ADuvc6ZIeL4pZSEp4beJ8u+ytPKdutLo9TNOcNL95EfUp4CezDCtWPsYg0F8PhPMondGbZ5a3aOb+RovWcULS8i14v8eDYIEbyEf87BKdDfgeCm2Yf1v2wa9T6SHyI/jM4QszbwWxGyAm2KrmENfNefWRM06cJj3ABkuqi0wQ6B+bS/oqdY1xVxXouYcV89fjQnIZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmA6tVZghz8JnuFwl7HjItUSkfenYJZwC0JQZoxfBmg=;
 b=g2l5/IkRJbr/mlXr85aVoSgLEhINfNONGhj+fJYYMne1w7fkwcLbcfC1l0eHxJhKKENx50OPiBzRM4avQjJmYeex20gk4PbPnODKugrEfTj3LyjaoBJxZ83fn0wwQ4dRgkBrBgY6GguKs8lP0CSzYujnuj40p6f7gVQzxfTg9po5BzfjufTGRzamXS7m66ZixE/OhNfJSpiQNlZx2EDJsXvTQ1gnopfmBQGlp64kMA1NseC+WGi8F3UXjLbMH+tvIcbMCg0OFHXdVkkRbhZamoH2//BB69m5zjUCY1I92DAK+hdiFbWJLF0cE6VtjX7PVRWvW/2HBl3YeQUbPM7Yrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmA6tVZghz8JnuFwl7HjItUSkfenYJZwC0JQZoxfBmg=;
 b=j3DLgkfgHrkI5PFEtXUDET2M1IBA1tlvhKOq1A3TL15Dr7p4AwcZkkkqbS5Hp+osdrH6Jj9n4O/F9jWcUmJHujDw31ESrvm9Z44nq8V8C/RZTs5DTh4CuicqoRPJ6MLwjJzxKT30eTrNAmEGnkAuUt2DQD82R0d1bXRq1hgU0VE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:18 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 04/16] net/mlx5e: Extend tx diagnose function
Thread-Topic: [net-next v2 04/16] net/mlx5e: Extend tx diagnose function
Thread-Index: AQHVV5U+qRLCkIts0ES+sOZei5Du8w==
Date:   Tue, 20 Aug 2019 20:24:18 +0000
Message-ID: <20190820202352.2995-5-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faf87fb8-4433-4c4b-9692-08d725ac60b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680C1E046CA0B10D6D9F4C4BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DLa27qByr2CEUj3kre7t5FewM2FNVOucpl7lgS9lyvK7Qs3OJPZcTUTU3zNfagxb0UiitP8Du9nesT6V1KWfygOkwwTqfqKZTpqhh4ZtNuUv4MWqcOnvRbHpqui6FtsmLWvvCc3JIWahzVAcc/HCwzQmBPebtP08BXHwLfucC6aHuMhkfL5PS/klU0ysPckWxwfkPrfbpgSkMo9uegdU4XfYjjxeQWehnrHLzHUsnXd35QsfJq0snAE+tWRphunJzfiyiZunfcBana1uRXNtCw7R0MAT4oPAvXtRxukWU6q2HpPVkbkUOOu4UVRkeU09MuF/gWKgnFW3DEaZV3uyECiB55FeNpq04+BS6PKqFfX6zdkcFs8z0ITYaCEICtY6ImhHXaw+vmx4yisy0x4rf3hthHYxgsPo9owB13ZNPEI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf87fb8-4433-4c4b-9692-08d725ac60b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:18.5060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDySRPxTTyYJ6AuSkasaKOj/pK6DlS5zajgKSfdbXKwzTlieQsDjmH29jh/JZnYa+VMMa7iUhnZXovalmxx9cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

The following patches in the set enhance the diagnostics info of tx
reporter. Therefore, it is better to pass a pointer to the SQ for
further data extraction.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_tx.c       | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 6f9f42ab3005..b9429ff8d9c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -146,15 +146,22 @@ static int mlx5e_tx_reporter_recover(struct devlink_h=
ealth_reporter *reporter,
=20
 static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
-					u32 sqn, u8 state, bool stopped)
+					struct mlx5e_txqsq *sq)
 {
+	struct mlx5e_priv *priv =3D sq->channel->priv;
+	bool stopped =3D netif_xmit_stopped(sq->txq);
+	u8 state;
 	int err;
=20
+	err =3D mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
+	if (err)
+		return err;
+
 	err =3D devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
 		return err;
=20
-	err =3D devlink_fmsg_u32_pair_put(fmsg, "sqn", sqn);
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "sqn", sq->sqn);
 	if (err)
 		return err;
=20
@@ -191,15 +198,8 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
 	for (i =3D 0; i < priv->channels.num * priv->channels.params.num_tc;
 	     i++) {
 		struct mlx5e_txqsq *sq =3D priv->txq2sq[i];
-		u8 state;
-
-		err =3D mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
-		if (err)
-			goto unlock;
=20
-		err =3D mlx5e_tx_reporter_build_diagnose_output(fmsg, sq->sqn,
-							      state,
-							      netif_xmit_stopped(sq->txq));
+		err =3D mlx5e_tx_reporter_build_diagnose_output(fmsg, sq);
 		if (err)
 			goto unlock;
 	}
--=20
2.21.0

