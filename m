Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA39149376
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAYFMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:12:12 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728236AbgAYFMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:12:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwlU8Lc3thOKBx3fpwhhDwW4arnmJaaNr3v/sGW1hTRHT4100FDrO1ZxhShMyt6ldLZDPzhfCs4dK2XDlV/q5f6NcNPpX3vzg7eT9hm4z5hgkHIEkm21Tq7IiIfVG2PgnMRHYy6xJ4L2+N4NnkrKz9A2qkCwQ4ghPIrdk1PPbjJrEBqzE/TGUsM3iLnr0y00QYWPZOXtvF5Jmhu3BssJz+zy4RKvcP9H+GwRsVA201VfnZRIyEZ21BafQeBlbPVyKLJuHXZrbOjPAi2/KjbqZg7nFhxgjc++pDcgSG7E2xu2YaRCA1KynFz0rkgtycI8RETalw/aytXQfQjBh3ByEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=bnIlR6IC6U2ja0PJRFifoDLz6cfpyEu1aZLW1qfNABtID1bJvSaartWIIlNAB2vw5Rsh9q+bmA97FqPsCe/KmfL4s2NbhtkK6mtqUL6VTntfjDKKM4fybNjK8Burg2RgBcXzmHd4NfuNIgvHvJNxMORYMV3qLyInwQfdrRonxSyB95x8neVeL6mTgDCVHJTeRjonk+PxpCJWmhzyg0G7/rDqKElgunqKItjvAb+VyHhJbqzgOtMfHIEMLYlb8GWoGZO4oxlMkPCXdECy7SJ5GfKSC4LgU1ugXB1wfwcmmdOnV5ONiU3G2Z5ccw/BKwnLA8SCTmb08+CaRNbZ4PWfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFBP7Y0KLaAwFH3FpoZchG6jfgDZw7aBoYXKwk1ISdo=;
 b=in1thX8pN5/ACEQRQ5Gq288vCq/o5kiO8a5XpxELrTi2mmniMnfE3b7ZHhG6pYPwVljQbS8JAWAX3VTzS3unaanJPO+pg21ZvjZE1wJLepSqSJISo4seFw2dAsyBxIt3j+vegLV9NfrI00w1OS5tErBEwR7ZSit+m1OZ2e57OT0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:50 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 10/14] net/mlxe5: Separate between FEC and current speed
Thread-Topic: [net-next V2 10/14] net/mlxe5: Separate between FEC and current
 speed
Thread-Index: AQHV0z3ymolXrgGzjk6ng38wVsHe6A==
Date:   Sat, 25 Jan 2020 05:11:50 +0000
Message-ID: <20200125051039.59165-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 71a3508e-bc0a-4b6c-c992-08d7a15512a4
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394D2C78E41FF9EB75B431BBE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +yS+7LU5sDFjKk6rNwGCyG0PxzEWPTlNByDsRRlI7T+TUjN/FORlcWAqKcWoh7d0Sab7WjbrzlyrveqEvYV8UnuHCQiA5adf3cEb8F0HPnOjMua42jbkyOemXwgeiZZmPdu/RuNls6ufk1Wq4Ec8tm/ZgApvshArLtNIURQXKSrIqv9vRlzIENR1QH76dXNFAscB/jnA3f+Svf86UnQP+0Y29oUezKI5W0nQ/GjuUI+dGW+U5m/Vplh5gZExq7Td83KhTkbb1HMBg9oi8BFqW6qopwqgw1WSGMneKx9/SQRH/iBBkVGt8nW93xnMKoUptQ/a/kP98C6qs/YhM6wJkaMajqHA7AuxBFtxIRShkaxLewZE7P+CwrqG6w7wONE+s2F131sCVZeLYC5bc7choCaERO9XzzPT4IqzXyBdJlliMNatZvaGuUAQfN8iuzGtsS1eKH/BrUe9NXBHtxI+u4IzCOFuulQGL6Mm5Xy0OfP3jQ5kkd773yWOHtpEXN5z8iC65KLNMxAYhPJL+PNNYF//icJe2PEClMsvpA8qqgU=
x-ms-exchange-antispam-messagedata: KEvBFXDfynWcWQcDGBbUJEdCbW3us8q+/hJmc0f0vCtlmMMZGZnceeBNtgq0ss0qH7L5f1eemDbuEKK5OHTPLN1FdNQTujkOJyLNmMSgU8cuWt0MquP/3C1BRXnDrG21t6aFFt6z7FD4w7BVPk8xHw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a3508e-bc0a-4b6c-c992-08d7a15512a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:50.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tcGiZW+HCPmKjkS/3fevb8yY9RDFJ1eLtand/rE2ygNwk8UeTzYiFJIoZBBmN4xaGuFj/ESg9jftaV89sFzjXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
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

