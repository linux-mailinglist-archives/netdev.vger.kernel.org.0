Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5949F149086
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAXVz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:28 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgAXVz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKm9NdD0GOskxE63cPPiPb8wb/4kuAnjRJAovxgB/DlLmwOgD5ApAItlbP500Bdl9+2/lOSQyAkrNLne4kisP+vyVwe+ULz0nGGogkfadL4ZEJ+YXjgyxfusbJyzkI3dQjbfRAkw9CVmwAU6Hxnn9IBLdqgEpxfkS+r93fdSaSpo3kVwVAdKokVZJNo0KizT/trEb0KK125AA6uxY2yt06auzshxjMtTtNxhoYR92CqEBD0MP4El/z/ih8chWr0tZGcJ1QVsBVG0TMexjLx2yuHHAXFwnympcHxEuj2Fq7SM0CwELjJ0ZjiGmcVXdj7x9njDkddS3ElAJkxQPn+bZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=Nw+0WraM6RlYraEz5V8qfvwItcgN2L6RwkER0xpRMKVqFnPDgtjoKrEd302QlQQincS+oVTT6UiefNeQC2CTG3u9Q8OBbl6Yx/PV/xx2VoIA3XjzVbSPIBFj780l8SyphcoYKEY/tVg1LtSSpiUBMZfvtL4s1pGZjVbH8ljfN5cW1aZUEoDwbn0FF6IfPXXvJZCL4TFKrDB3Yl2NCuYaNW6nHto6v/c1DiOYIJwdoo/PQD3bFWaZNIqd2PPw374Y3AVZ9BgnW4W02nD2rhb++Sj8ajp2IZcGMltBAOYN3wLzUgjCFrVlBaPs68aHV7CFYKQFfGq8wmbInVOnXmBycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=NLlDx+lz31nWuHfMMi0Q5EPA8FCCwCLmPbtYVUx/Bru+HHitd7r7J6GdN00RC2MAC2qUfz6Km8c4UgSR00C1TjzejK5Ww1KNIuvbSrksPiXaKVI50BmbtEkFeHjq3skvvq3I1vPu8gjOli/7HI7x6wqIJxpPbZp9rVcjbI/woIE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:14 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/14] net/mlxe5: Separate between FEC and current speed
Thread-Topic: [net-next 10/14] net/mlxe5: Separate between FEC and current
 speed
Thread-Index: AQHV0wD0rexg2Fewf0ilxsJgv9WQog==
Date:   Fri, 24 Jan 2020 21:55:13 +0000
Message-ID: <20200124215431.47151-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 8e814749-4274-46a7-1871-08d7a1181748
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54564D7D382EDF1C77929CA5BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JaIhFJgEdyA3Fts4AbNIIgUsLqKlR/cFFPgUeuE0TGKtj+jyJadv8dC7ILM4hNOcNml15z3+XgNB0z1IEDPXcBb0Rtir7s1qel3v86DHG0t15e+pzpXWssP0ewWbWItYj1Gwx21g0Hw0K4aUI/DJvS9aHXwv7ENVWy76hjVX1mXRSFcs0/Kh+66FJCJuOL2B85OFOY1zl1B9dfZkCnY41rBdbiDgc8XL19oj5yKGuCHFr8/ivqIQPDTN4jrFNpX4t2YxU5nlV7R0vQSWKUHjktBThjwjSR1djzzYfFV6eyJSi7dCBa2nnxr54yxJULYP7A5dx3EsQrcNO/ttRZINgZZHZQyIftyWmyLjucfnmMbZLzR67bkAKggzxpxXaZ4PIdEjPA7AmdMgjo+9ufP7OCOYbvpSC+26Ewa8usV4xYiRC0K1tv6/lWA8J1vxLF5MRtTdh9i+C4GREYTdGb0ZBfA+4WwA5kY3FXw9WB2LRddsqa3md3mZgVLeiKPyVKC+sDvlnKzf8ppCX6rm2c2hm+EJpve4v6AHfM/w2wJ9BbY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e814749-4274-46a7-1871-08d7a1181748
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:13.9981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3RlV+rwZKbZj7Ry2lOTt+UgyU7N29dzDBTjFwvWKKfHx8e27yhlkv3WNbIbwBnhfYM4mKeprbr+SZFKhxwx6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

