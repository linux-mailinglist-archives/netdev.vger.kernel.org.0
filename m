Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6204163AC6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgBSDGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:34 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:65095
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbgBSDGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxoVR/rmpOyuEaOtSTimXmRBl4Z4E1jVsQDBMxYMHIyc6IfHUOAr5ZBpwOMOCDu7ReGBsU9CS70KxyynlX4vN+w1824p9wv6/OEDarUPSoGGHVzBxA20rNgzDdeSegAQPX96C04QeYqlaUMB1tzlq49nXCs6pzG7i43G/aIW/cdMZu5QFkdhdqJ0VKgWhIRG62ruVuBEOhG/laKQpvY/VM1ab63c0vLlTPVaRGXE7IInwyNRhl6QuaC50tMgUqg25oD99g1pW2dOB1Cw79v/Bg6nEH7cWuWeCF70BYd0581bfYJVCcCnCZNrEGgp3ew7BfpD3QpdCtvelTgi+iVAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUcpw3kIMmdEekSTRHcOG6GNp03tY98BGpdlGjUz7n8=;
 b=Fl4tVRhXmSM6L95tN3nw2T5OyXsalJVX/JCjydY5gVic3qsQO3Av+EfUYlWq7k1vRNJozGwN0vdXQ3mawFP2d3lEn+UYl86OTOkbXgYd5oFUe4/7OlxvzbbY6sYCW3sRSCAD1QhihtH0G1HH1t2VixRnNV460WVKpaVWN8/48n3ntRWheY0xoKmyboroHoFAHC+poM+EJ1JUq7/oHqZRJEXI9RuQUhphY0REFYuWnZVhWT8u71d/6p8QFIlSf7RJ0rQxCMAodh3sXgXTwNoi5hVdZvsWrCDLWJ9f7U64Tp6z2+q5D7CK0rbbMRAdV8xxkHogBpcnXDmEDNY3p1wpkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUcpw3kIMmdEekSTRHcOG6GNp03tY98BGpdlGjUz7n8=;
 b=kXBf7A7UkjN2iGcqyoV8PwQ+ftIa2JJ8dwA5kuywTqoCsjzs4WIn3AT1FicqN4j4FLzmpW7zCM2o+o5yBCWW7kTKKmiW6vtPcUy+O9528/Y8g59mi5gD4iilJE4/nDjrrrlSUVLR1LZyI/D7WuncZ0yEr/BGcJuZf3RwgyrDp+Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:30 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/7] net/mlx5e: Fix crash in recovery flow without devlink
 reporter
Thread-Topic: [net 3/7] net/mlx5e: Fix crash in recovery flow without devlink
 reporter
Thread-Index: AQHV5tGVhDOvzkjvAku4EvEjOrliaQ==
Date:   Wed, 19 Feb 2020 03:06:30 +0000
Message-ID: <20200219030548.13215-4-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8948193a-0a7f-47f3-0784-08d7b4e8b71f
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5853586024B0AE5F410B1FD7BE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(6666004)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rs2Tm1gA1QPso3HDfFIsm49Z9ZZ1Wdl4uW+E1sKRKaN4LUxcLd+n6ri/OB2D3ZttQ37ux9y3BIcHSHt/c1p0S4mc/rNFD41VFpluP8CgM6PYxkR4sCRi7favM8AFbyG+nGjHYhoKSnNbx9w2G7/Gb4neUzFsSnJ5rxe8ECU7irROEgoVpw3/zbJ6ojIY+hxVzwYo5puT+sQIJ2TVfzgGH8TnoOLwUkdwsSDe5S0WPurttr5S+FhqGYAPjGOMdMUu0tGCPgZQ6BKCkvFCpmm26hw8rfFJex+pA6QxtuXUsr8t2f0LJom1xQBWWHm+JkY+IpfYxQjAN7BN4NfNTG4MdWDE5yInhlD6tO3SNfv/qBxolyK83pi7omOzTgSScm7z7JXqpTSQtsNsU/rz/MvYFKaDq79Fs86EDjPWswpNC8kBbodZ7wJB6VE4/WgSgyutKEA1Kd/2amwywDg75uAVEJ2tWK38d2IH8X4WXipjaa9vZsLI2iQUw5938Ri/sIyO+GI2fJ5dqFKKWhvxdDmSQOVlnQyLCW4YZbYEehbmIvQ=
x-ms-exchange-antispam-messagedata: 4W7fSqd7fdWNXWeokPGft2YSENfP2Z4tEd2lFiunpugK+JAanrUQaBP7MffJl+JAMUTw1emBrV1xihECoAs0q9IRUH4vyi4LZqV7Phgn73/5HfYWrRjPwJDnG2WOcMG4v7kzyEm4ENR+Cq+QzcGOug==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8948193a-0a7f-47f3-0784-08d7b4e8b71f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:30.7283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEM9wAbb0FN+P1tLSCl3/2eC0ny2nHu9KuePA/yUNquxLHlyx2b7H6iABu/GfJNEfCqz0YS8Hl4kikrcxUIIag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When health reporters are not supported, recovery function is invoked
directly, not via devlink health reporters.

In this direct flow, the recover function input parameter was passed
incorrectly and is causing a kernel oops. This patch is fixing the input
parameter.

Following call trace is observed on rx error health reporting.

Internal error: Oops: 96000007 [#1] PREEMPT SMP
Process kworker/u16:4 (pid: 4584, stack limit =3D 0x00000000c9e45703)
Call trace:
mlx5e_rx_reporter_err_rq_cqe_recover+0x30/0x164 [mlx5_core]
mlx5e_health_report+0x60/0x6c [mlx5_core]
mlx5e_reporter_rq_cqe_err+0x6c/0x90 [mlx5_core]
mlx5e_rq_err_cqe_work+0x20/0x2c [mlx5_core]
process_one_work+0x168/0x3d0
worker_thread+0x58/0x3d0
kthread+0x108/0x134

Fixes: c50de4af1d63 ("net/mlx5e: Generalize tx reporter's functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 3a975641f902..20b907dc1e29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -200,7 +200,7 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 	netdev_err(priv->netdev, err_str);
=20
 	if (!reporter)
-		return err_ctx->recover(&err_ctx->ctx);
+		return err_ctx->recover(err_ctx->ctx);
=20
 	return devlink_health_report(reporter, err_str, err_ctx);
 }
--=20
2.24.1

