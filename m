Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB518F42C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbfHOTKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:18 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfHOTKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq+ScHoFBrPacMAu8Nu699YorCHa0F5WabLfankKxm5GMwkOcc2vm4UDsn8uvatWCZrK/G9EgTvW7Z22DYPuCOR2EyirDGUdXl+MFRQGGmEynf/1c8wpqx61HuwPl6CMe5FmQy6sMCDY5v6bFKDDPshwuw9jTeIv7n293uT6eMtWq7KT2CLoJMnkPMm5ttsC0C6uLozRF9Ym1/xu3xlioji+WFJVyiP5oav/llH54Fc+1lb72IMQPJqwJWN+3IMqh6yU2eRnylXS3NCSO1+3i+r2ZbNg6NOl4P+L/z9qihyVS/HzhESnHM6+AfMVj+gFY1IgnbTm/RizrXOTCIFIhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRsUy0hLrjFh/U0cJQluAr7DasaL0N+WUjnzTDyOoqw=;
 b=X58E7axwbROn34nEXttnf6jb7EDbBirZ7TeAV2FrON4nmyAk7WhSyfPlpULaE7akfTNPexv8D4pyZAsqrS/HMl/cRT4o+mHYycIca5102gfkmIg2PtJvODjiUAvoDzl6w8HzaXfCa3yEqLWIwC7Khqe8aWOScvkrrILoogCRkDNXt+i9I5vrmCt31Z2yAb1hZ2Ym79MbR1gXRNdkuXeHcxg5PdXPSG4gonxN8PGm1M7Gr9QOcclvyxlzGFBdjUUWBtb9B6BIsxHJlm7pqgSz7+k0HjpD8U2shIp2GgH4ZJXP5PeVUun/RcmyyY5HIJbn6dGiliQpTRn9/viK1APy6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRsUy0hLrjFh/U0cJQluAr7DasaL0N+WUjnzTDyOoqw=;
 b=IJZ8ICO9R4zH3Fsr3JAhBExh+xqrCujnS4vX379OWCVaZ4s4R8Joe59wC3/7Kz1S56VsvNLP3jZ5CtQEI9hFZIuTzF64m25VsWY57u47cMGgHyuqwhl4ltUfMxKWwioNareWr6DycYDuySen6Xy1j/KUE3qlhOO9Pwaac7MkMpg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:54 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/16] net/mlx5e: Extend tx diagnose function
Thread-Topic: [net-next 04/16] net/mlx5e: Extend tx diagnose function
Thread-Index: AQHVU50FhJkUscZzTUWsPeSDCGsKyQ==
Date:   Thu, 15 Aug 2019 19:09:54 +0000
Message-ID: <20190815190911.12050-5-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63db678f-4893-4cf3-653f-08d721b427fc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440F0989904E263FC2A1D14BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lNJPU4DbEN3ST/a3u/v8dTSc05mLxUnFM8u79Vm7K6tdUDMCCZL6Be95ZYCf+rmJkT3F2Os17Q0VhaFaVzDkjNHQqi8c//Ty28NoA7AgYBdMzcvYtv80KFfz2bJlDnurochJUCgQPU/bI/g2Kt5wZFuwP9Actmv6A6t/Ws9Y0T1xqCXvSDUaPvzmQY5ztp37xe3UhPTK+XfuRa+11TU6RJL3ypMgN1LReYReHR8kKx7pGbzV7JaFSzdIdbxLSarbHKNGEOoqjZ3+PMsF7OlRdRQ0R+6K+WuYoSe7LSJlZe3gtCfBczv7UfC5EvweE2i7grAcATRGfnY6GTAHvKuIi4+d/dyc98pDQRsCZz4UVbWSmUYmQ6PwE1tWqcNWuoImODvzCQz74poetxbmXUjstQoXq19BCsL1hB3DP9Q3Hcs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63db678f-4893-4cf3-653f-08d721b427fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:54.7455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hNZud0XG1G4jKVbuKjjUQ1z0c45c8xH+1vUro6a2/Ef53VZzBIXto2651cnTpm6ULBQOWblrT0B6JBHpD19HDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
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
index 5731ea3c1600..411813a457a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -138,15 +138,22 @@ static int mlx5e_tx_reporter_recover(struct devlink_h=
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
@@ -183,15 +190,8 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
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

