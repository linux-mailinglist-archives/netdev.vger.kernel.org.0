Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3565FCB
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfGKSyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:20 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:8419
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKSyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK4fxi8B5ssBjFRA6qAMj5Jjkx4MZtLH840c8d6umoFuUAQjaf9NS6cZg/5aavBgsM+mczsKGWimi+3RGMV9rhQfyKT+kbMmaF9LEi9i9BxgM+6LfDs8XOH9xJXcy+QQ9a/d8cpScZIKJueTq/Viv8rBsqYPOYixa7aSFXgDxtNeorJFJ+1bD5H+Aow1w7AMXN9wDsAUag+YR3WWLTMdSiWH9vskY5w2p6txTvq1D752EKqU86lQtLTkVl5IGPkdNhz3Oavx+cMD7ffootRFwA6BZnnMQFS++oC+1DIrmMCSKM9QTJgpXp811wFPkUfIwqdKwi8ohEXPVTXquCPe0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/V+iKEG4lHl66sqiIzonBMp5/I/knDHQBBzrd6QD8g=;
 b=jOHP4gJIKln8n5k7XKA1T3jfAqQBiSwrzic2LKPs/F5l6SzD6J5kSbQ1ZWyzwYr1hRDYozxie4ABniUQqshkAfAt4TnIGhN36ycQQmsl6U58QtYm8iJWxE24kWVVFqTLfV+HnTGWQaJ1o5xDghY3U4irY4rk+OBeQO/M2H0fQFCKWCwSJoZiVitDeMXSrkKP5FGNb3S2OrVpSoUEJdfudwGPXoRAYpfZdgs8Tq1OyTfi856HNkpM3I1CBwnGRw2lFYxs7aorgramC42Zobw2gkOAzdJjXvLYY5HuECZDTlZiJjRMUs4Bfe2HG+GwCxpXQxyKeO0B0QYed1rU7TWomg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/V+iKEG4lHl66sqiIzonBMp5/I/knDHQBBzrd6QD8g=;
 b=FSTeP8EuBB5QvJim2RzAQezPcQ2EKHJzuBdrlCSd1KLhTJgkYLNfIC9pqGY4G/36eSkqCaMyUSeSmdAM0KtsctlAr0ttvKtgtAUDQWN7TqXhgeRsoQpx725l6qV32Ytuys6Z1IvO0pANOBilUx42hf3IqoIBvgbqt4wSI4tAHWo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:16 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/6] net/mlx5e: Fix return value from timeout recover function
Thread-Topic: [net 4/6] net/mlx5e: Fix return value from timeout recover
 function
Thread-Index: AQHVOBoKzLmLOnNkeUmTm+1Ec/teEg==
Date:   Thu, 11 Jul 2019 18:54:16 +0000
Message-ID: <20190711185353.5715-5-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15387a0c-139f-4adc-99da-08d706312c6f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB27700D6C58A93E308A77C40EBEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(14444005)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JE7yYOZq3agEbnAbE0iYm1Qh9l9A5BNoKRdKpWpnDpFC4tA1/tHNQkzPPGjRy1kkwx0BNclu/ROAzbJMJHkD0OMqe8EwwM2szyZDz0uNGZ97cRSbGDQW/cK6EX/3y0x6tRpKHkwYny/Sp+/gglEN+qIcPTsVWDdcpwZ5mtHdJtEUluOyOVqHolA2YTRouvDomYG8LOcR3wvYbve2hXtAuMOMh4z79zToDvkZjFB3eEotvHRwXIDcNG/+eq1SGbiqIBX/NU07PpjRHjZ/9lTMmBuf+nvMpbtDaKpDNk/m0J8fmzChX66IscirRl0auBA3qZxeRan9x13j3Obzp5IKlRO8gR4FxCESbPj21Dp39vEp683AmLPxfA54bgso9W+gVx0qcHfPZ0CZLcBoaDlZwc+D8j/enp8f5/qVH3d/79g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15387a0c-139f-4adc-99da-08d706312c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:16.7348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Fix timeout recover function to return a meaningful return value.
When an interrupt was not sent by the FW, return IO error instead of
'true'.

Fixes: c7981bea48fb ("net/mlx5e: Fix return status of TX reporter timeout r=
ecover")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 476dd97f7f2f..a778c15e5324 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -142,22 +142,20 @@ static int mlx5e_tx_reporter_timeout_recover(struct m=
lx5e_txqsq *sq)
 {
 	struct mlx5_eq_comp *eq =3D sq->cq.mcq.eq;
 	u32 eqe_count;
-	int ret;
=20
 	netdev_err(sq->channel->netdev, "EQ 0x%x: Cons =3D 0x%x, irqn =3D 0x%x\n"=
,
 		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
=20
 	eqe_count =3D mlx5_eq_poll_irq_disabled(eq);
-	ret =3D eqe_count ? false : true;
 	if (!eqe_count) {
 		clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-		return ret;
+		return -EIO;
 	}
=20
 	netdev_err(sq->channel->netdev, "Recover %d eqes on EQ 0x%x\n",
 		   eqe_count, eq->core.eqn);
 	sq->channel->stats->eq_rearm++;
-	return ret;
+	return 0;
 }
=20
 int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq)
--=20
2.21.0

