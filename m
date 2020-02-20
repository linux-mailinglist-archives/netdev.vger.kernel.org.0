Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFCF165505
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBTC0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:26:04 -0500
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:56485
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTC0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:26:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lanrg4Nr3F88VURpRkJrjA5msGR3ojK1g0UvKAqWuKDrgT6q4hBAd/6AcMNXGBqJXIEtL4k1RtnpQr9T8zUtdjz5RKR8193itfJO60h8SlRyEXus3s/JRQslSuciKZbJmtmI4IOSLVdu6CbD2ZoCh2Wilp5EXXCG6KzC8kWfcwrrwr/wtaty7/q4Y9B61NR08/D+Or8T3c2CA/Zmyh0oNm5o+OsUQprapyDNkv8vxqC44q6CPrAN59kTH93gCxwciE9D5Jppeb6UmwV88HmbJOiVWBqpwqcObfryxJBWyFE6S+TkTLftdYQovAsV/YpnqWPUtjrI7lPZLgqsv5O9ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMSmFJ1Lrh+pH/eHA8X5ffyROg8/SwkhRV2VAduC/4=;
 b=MQNFPp2wooO0awpmcNMk1ClT9nl99VsgPzj26orDJ0QbOkTLPlSjY1P4gNOO2bc/obCwkjL7ErpD839TCTF4bt5dg0LbPByJGWfrLtQrjqmq/56FIAD2qt46mycIAHjbgwPdqso9V8xM+0fABAiqL7FMqASNgkhSDid+iZCwHpT3ChiR7RUN021Ex+hhey2UXADLPz5k+1GeRrxusFYk1mik5AzkB1Aw4uSTEL4TBczLlJ6Zi/9VJN7kX9FrrsBknD4/z9PkWcNXIxzh6ViB+ySMynXIT6P0q/UGXgu8x0u1MjTG3hQF4er6LO5/bOab4syzSL3LyWYjG0IvrX6LBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMSmFJ1Lrh+pH/eHA8X5ffyROg8/SwkhRV2VAduC/4=;
 b=oL8hO34LlqlwL8t0VyVWC/xGHJ/aZiPvFAFXQiCkBP0CTIwU0MFtSFeLUxghfk1ft9OklLNXc/wYvy2Bmcl9NMKrSZRRtHJzUwUz/h4T9HHrzsSclbdwRhH3rZds1nYkvygIGR9gFN4e2WHritQSiI5IfxYwEkIOz7z7GrX4rkI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5038.eurprd05.prod.outlook.com (20.177.52.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 20 Feb 2020 02:25:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:58 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 7/7] net/mlx5: Add fsm_reactivate callback support
Thread-Topic: [PATCH net-next 7/7] net/mlx5: Add fsm_reactivate callback
 support
Thread-Index: AQHV55UVitPgbr9FrUOKslPK+wxHLw==
Date:   Thu, 20 Feb 2020 02:25:58 +0000
Message-ID: <20200220022502.38262-8-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
In-Reply-To: <20200220022502.38262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 743ae51f-bc84-4e38-9fdf-08d7b5ac3831
x-ms-traffictypediagnostic: VI1PR05MB5038:|VI1PR05MB5038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB503888002A1E59D4E67F8BFABE130@VI1PR05MB5038.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(199004)(189003)(66476007)(66556008)(64756008)(66446008)(5660300002)(6512007)(8936002)(66946007)(6486002)(2906002)(36756003)(81166006)(8676002)(81156014)(956004)(2616005)(54906003)(1076003)(4326008)(107886003)(186003)(6506007)(478600001)(26005)(16526019)(316002)(71200400001)(86362001)(52116002)(110136005)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n9VyfUzIUaWDwJUUbaNVHzBSlP0H/TITmb/NSwuwWZ0zUgSId1Z0fOvk+h1NG2219l9/7VZaFKrLpFnRmb+vL9DozsPevb8arb+wFgp8fOrZsAM+n+frDt6tCGZy7CxV3yEd5/Vv3uPRiWigd8ZxumaMorNn2b+Kntq2Eq4O2/hwLUImClusde/5Qvka24/+yI2wpimodNZxHp21RYnANgbxib8batwaD0hsibGOHl7bAuZgpERLCGrFYPknSmsOjEatOIdC2qhFoGMf94xf0KsS4lXNYhT7GysuBnaTNp3haf6OCGzIA9XZOduWGCZwt1EAx9xXjNyA+WZWw2wkBRCxpc8vEEB5f9Belgmz2H5JmiFnR7KT8DuuCUhkAV2DRjPkbQL3TMviBwaaBWBU3iiEJMAut/jFUR5T3QvvWmJ1feu+Cx29lVJ4lAn38kdOtyYn7lJJMmroFBpWjw+YzkvPJxcxBBLBMtBim0RYi9gBDscyAWKMzXuxth/hVoEi0QZyg8pxbHlCNecKF3HdF8msm8iQQJ1dssgIHfhp4cw=
x-ms-exchange-antispam-messagedata: WIqfbwj9D1We34tfbzlhXHCkXISsEnBACuxIlMDIn626rTzUm5Nclv8OaHq/VN1aeMv2Bl9Chq6PD5boxOWn4I5dUQxilcxHHFQ1I8p1PhXh5ID686PwrwZcZsHr/ADuV0ywG3hv8x3Dj3NOukW4xA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743ae51f-bc84-4e38-9fdf-08d7b5ac3831
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:58.4319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rual3bRCYqIy7/UdlFkSsEIKAAYB7M2MZ4xODe6eYhig/hqCp5ziDPl/8ezo9MLyteR8qa1erkSYWBS2j+aNwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add support for fsm reactivate via MIRC (Management Image Re-activation
Control) set and query commands.
For re-activation flow, driver shall first run MIRC set, and then wait
until FW is done (via querying MIRC status).

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 39 ++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index 4250fd6de6d7..90e3d0233101 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -613,6 +613,44 @@ static void mlx5_fsm_release(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle)
 			 fwhandle, 0);
 }
=20
+#define MLX5_FSM_REACTIVATE_TOUT 5000 /* msecs */
+static int mlx5_fsm_reactivate(struct mlxfw_dev *mlxfw_dev, u8 *status)
+{
+	unsigned long exp_time =3D jiffies + msecs_to_jiffies(MLX5_FSM_REACTIVATE=
_TOUT);
+	struct mlx5_mlxfw_dev *mlx5_mlxfw_dev =3D
+		container_of(mlxfw_dev, struct mlx5_mlxfw_dev, mlxfw_dev);
+	struct mlx5_core_dev *dev =3D mlx5_mlxfw_dev->mlx5_core_dev;
+	u32 out[MLX5_ST_SZ_DW(mirc_reg)];
+	u32 in[MLX5_ST_SZ_DW(mirc_reg)];
+	int err;
+
+	if (!MLX5_CAP_MCAM_REG2(dev, mirc))
+		return -EOPNOTSUPP;
+
+	memset(in, 0, sizeof(in));
+
+	err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MIRC, 0, 1);
+	if (err)
+		return err;
+
+	do {
+		memset(out, 0, sizeof(out));
+		err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
+					   sizeof(out), MLX5_REG_MIRC, 0, 0);
+		if (err)
+			return err;
+
+		*status =3D MLX5_GET(mirc_reg, out, status_code);
+		if (*status !=3D MLXFW_FSM_REACTIVATE_STATUS_BUSY)
+			return 0;
+
+		msleep(20);
+	} while (time_before(jiffies, exp_time));
+
+	return 0;
+}
+
 static const struct mlxfw_dev_ops mlx5_mlxfw_dev_ops =3D {
 	.component_query	=3D mlx5_component_query,
 	.fsm_lock		=3D mlx5_fsm_lock,
@@ -620,6 +658,7 @@ static const struct mlxfw_dev_ops mlx5_mlxfw_dev_ops =
=3D {
 	.fsm_block_download	=3D mlx5_fsm_block_download,
 	.fsm_component_verify	=3D mlx5_fsm_component_verify,
 	.fsm_activate		=3D mlx5_fsm_activate,
+	.fsm_reactivate		=3D mlx5_fsm_reactivate,
 	.fsm_query_state	=3D mlx5_fsm_query_state,
 	.fsm_cancel		=3D mlx5_fsm_cancel,
 	.fsm_release		=3D mlx5_fsm_release
--=20
2.24.1

