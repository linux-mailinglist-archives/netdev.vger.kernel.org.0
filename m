Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26EE163B13
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgBSDX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:26 -0500
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:43238
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726751AbgBSDXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ejxxk8mJorpDDOa6jBQg+oa5dw6tKeoIeQGiW9tsJSooA213TeUhftIlJBADKmk9xDOsUjG3P6XNJoJPSTv4u/JxMHMamoE4t2q/btr0e1ivuEFwP7+8EsI2NsrdDf4jTo1J4KBTU3MNTX2Rhv3vqbqDNsEbx8rQcm47zlHgQOaQYWvvFaIk0ilttmrkbFnCXCRqLXL7SdaVECXb66MjwnXvX32xJFfWYoqRCxl8awiasFQncUTTjrZpkz8k3pDoxxBhnQzbZdMcat5oe/PEd3yM+Kml+2XVtelpb6Co0TredZOoBZ+sRfXSVytqWNob4ICMFs3yHWttGHs85Ta1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=fVHA0PcjA03rV5sTrbwRm27dR8lxQ7m3jPMazLKHq38HqYGFnyzCd/CLLYM9DT8BSL1RceNnJTymLGJZ3dfjC8j8UD0EUL5ukUS68U1CwjJYkgmCY62jarFB7quMXzcFn1SmpnwcsEJOm7pu+WQ6jtQti2A6p0cLoDdMlXTy4bgQUyiU0J0bWnHfaAxxhmgpfK1rFk+EO4pICEOBNnyaYcrxBfsdJ6GRQIGLtxsltvVvhxLIUUnkAeu8YfPDq9KRz+VLV4fT3jvHRPuekcANz6g333Qe9127dXb0Ia/ZT5InhaFjTRxvgVh7U+CPSiE+I0tVrG1S2QbuGZKaWfH90g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=jD045kzfmQwmDuGJGrPGttqP7gB1I/gJ8cUxCjCreR6HRNT627rca5KhQrBHT1av2qhniqZxCooCnS6K97yrb1kwvDigkAcBp8zP/exufT7tzKfbQGLfs24BQ6cFxVw6ts48NE8wD7VGrtwN1AdJcXh4d/3wR6Ct7Yp615HHaDY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5791.eurprd05.prod.outlook.com (20.178.122.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 03:23:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:20 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 10/13] net/mlxe5: Separate between FEC and current speed
Thread-Topic: [net-next V4 10/13] net/mlxe5: Separate between FEC and current
 speed
Thread-Index: AQHV5tPvMt+cbUprtkmjbB+Zo+PYmA==
Date:   Wed, 19 Feb 2020 03:23:20 +0000
Message-ID: <20200219032205.15264-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3187b5bb-5fa8-4744-6121-08d7b4eb11b8
x-ms-traffictypediagnostic: VI1PR05MB5791:|VI1PR05MB5791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5791442B4A198BAD688D9CC7BE100@VI1PR05MB5791.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(110136005)(54906003)(1076003)(186003)(8676002)(16526019)(316002)(66946007)(52116002)(6506007)(5660300002)(36756003)(66446008)(64756008)(66556008)(66476007)(81166006)(8936002)(86362001)(6666004)(81156014)(71200400001)(4326008)(2906002)(26005)(107886003)(6486002)(478600001)(6512007)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5791;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nrDkZKKdbxJl2J20lto93RBcai4IMb8Ev4QRQJBizfeVjGeU0bgmXgRlQAyztBKgDNwDNcR2vUVqZoJ+2FcoTa7Tvd8PkUCq5BoGIO3rZ2VICk5RBtvY3fz9yV5LCxELbd4qrOn6/US+8n6wiJIlnDCyOclZI45ImY7s2KQsyhyi30t2jCPCvsgjOHzlWo4G8jXfPRrqv0H/jAzofw1Td1Jry7bYIfzO158oJamUXKaJcYZp+nsvYQiQFONqn5Jg7useH260LB+2r836oCq9dXaQgfErCiTFAr7jDc+8rDsnntK0PdNd9aoe+5VdS0MbgUqSQdZfuQOYCaR4KrOyToojDx/ZXEa82fUXOGMfvvKe1lUhSoLx0QC/KyXKvRInaFLgG17DikhZ7JhK48o07Ifm+2OPECsCpC0rl9CphF+5tRz6shh6pQ3gw1h3lON1M2O0ke/864exIePUs5ktaGEdBIU2Zzp65e0y/o6fjyHeMb2mKbkP1o+SCFAmHgImSRkW6YBFmETUc/fLVt6wFPngLXCamTcWNjZvVRDum8Q=
x-ms-exchange-antispam-messagedata: qfizzqj2n71Mf/wd5XA93/6AoHpxjANCQ6ym29pRm7atLshv5EL95+xVJSt+VoVYzcpB39+oX/YfRrUTzL4RLYvBFG8ivzDfFMuwg/TV6E3kniRv2Ae3k4To+Jw+Ls6rExSycAySBYrCbh1PA15XHg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3187b5bb-5fa8-4744-6121-08d7b4eb11b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:20.5234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cN/fHgkzDxuE3BuKfyVNRG5kpRFzsQLLMgkgJk5HQFEZU+usOQNK79ei0oLHJS2GrpaB4YBJhmJc/DiRWAkOsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

FEC mode is per link type, not necessary per speed. This patch access
FEC register by link modes instead of speeds. This patch will allow
further enhacment of link modes supporting FEC with the same speed
(different lane type).

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 146 ++++++++----------
 1 file changed, 62 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index 26c7849eeb7c..16c94950d206 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -343,64 +343,45 @@ int mlx5e_port_set_priority2buffer(struct mlx5_core_d=
ev *mdev, u8 *buffer)
 	return err;
 }
=20
-static u32 fec_supported_speeds[] =3D {
-	10000,
-	40000,
-	25000,
-	50000,
-	56000,
-	100000
+enum mlx5e_fec_supported_link_mode {
+	MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_25G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_50G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_56G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_100G,
+	MLX5E_MAX_FEC_SUPPORTED_LINK_MODE,
 };
=20
-#define MLX5E_FEC_SUPPORTED_SPEEDS ARRAY_SIZE(fec_supported_speeds)
+#define MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, policy, write, link)			\
+	do {										\
+		u8 *_policy =3D &(policy);						\
+		u32 *_buf =3D buf;							\
+											\
+		if (write)								\
+			MLX5_SET(pplm_reg, _buf, fec_override_admin_##link, *_policy);	\
+		else									\
+			*_policy =3D MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
+	} while (0)
=20
 /* get/set FEC admin field for a given speed */
-static int mlx5e_fec_admin_field(u32 *pplm,
-				 u8 *fec_policy,
-				 bool write,
-				 u32 speed)
+static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
+				 enum mlx5e_fec_supported_link_mode link_mode)
 {
-	switch (speed) {
-	case 10000:
-	case 40000:
-		if (!write)
-			*fec_policy =3D MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_10g_40g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_10g_40g, *fec_policy);
+	switch (link_mode) {
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 10g_40g);
 		break;
-	case 25000:
-		if (!write)
-			*fec_policy =3D MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_25g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_25g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_25G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 25g);
 		break;
-	case 50000:
-		if (!write)
-			*fec_policy =3D MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_50g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_50g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_50G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 50g);
 		break;
-	case 56000:
-		if (!write)
-			*fec_policy =3D MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_56g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_56g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_56G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 56g);
 		break;
-	case 100000:
-		if (!write)
-			*fec_policy =3D MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_100g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_100g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
 	default:
 		return -EINVAL;
@@ -408,32 +389,28 @@ static int mlx5e_fec_admin_field(u32 *pplm,
 	return 0;
 }
=20
+#define MLX5E_GET_FEC_OVERRIDE_CAP(buf, link)  \
+	MLX5_GET(pplm_reg, buf, fec_override_cap_##link)
+
 /* returns FEC capabilities for a given speed */
-static int mlx5e_get_fec_cap_field(u32 *pplm,
-				   u8 *fec_cap,
-				   u32 speed)
+static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
+				   enum mlx5e_fec_supported_link_mode link_mode)
 {
-	switch (speed) {
-	case 10000:
-	case 40000:
-		*fec_cap =3D MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_10g_40g);
+	switch (link_mode) {
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 10g_40g);
 		break;
-	case 25000:
-		*fec_cap =3D MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_25g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_25G:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 25g);
 		break;
-	case 50000:
-		*fec_cap =3D MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_50g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_50G:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 50g);
 		break;
-	case 56000:
-		*fec_cap =3D MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_56g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_56G:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 56g);
 		break;
-	case 100000:
-		*fec_cap =3D MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_100g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g);
 		break;
 	default:
 		return -EINVAL;
@@ -460,10 +437,10 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int=
 fec_policy)
 	if (err)
 		return false;
=20
-	for (i =3D 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
+	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
 		u8 fec_caps;
=20
-		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		if (fec_caps & fec_policy)
 			return true;
 	}
@@ -476,8 +453,8 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *=
fec_mode_active,
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
-	u32 link_speed;
 	int err;
+	int i;
=20
 	if (!MLX5_CAP_GEN(dev, pcam_reg))
 		return -EOPNOTSUPP;
@@ -493,13 +470,16 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32=
 *fec_mode_active,
 	*fec_mode_active =3D MLX5_GET(pplm_reg, out, fec_mode_active);
=20
 	if (!fec_configured_mode)
-		return 0;
-
-	err =3D mlx5e_port_linkspeed(dev, &link_speed);
-	if (err)
-		return err;
+		goto out;
=20
-	return mlx5e_fec_admin_field(out, fec_configured_mode, 0, link_speed);
+	*fec_configured_mode =3D 0;
+	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		mlx5e_fec_admin_field(out, fec_configured_mode, 0, i);
+		if (*fec_configured_mode !=3D 0)
+			goto out;
+	}
+out:
+	return 0;
 }
=20
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
@@ -525,16 +505,14 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 =
fec_policy)
=20
 	MLX5_SET(pplm_reg, out, local_port, 1);
=20
-	for (i =3D 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
-		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		/* policy supported for link speed */
 		if (fec_caps & fec_policy)
-			mlx5e_fec_admin_field(out, &fec_policy, 1,
-					      fec_supported_speeds[i]);
+			mlx5e_fec_admin_field(out, &fec_policy, 1, i);
 		else
 			/* set FEC to auto*/
-			mlx5e_fec_admin_field(out, &fec_policy_auto, 1,
-					      fec_supported_speeds[i]);
+			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
 	}
=20
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
--=20
2.24.1

