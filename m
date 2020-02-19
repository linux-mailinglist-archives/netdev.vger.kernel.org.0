Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D573163B16
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgBSDXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:32 -0500
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:43238
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726786AbgBSDXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqHcOZyiQkbzdernlkMnnd56LXpChVL6Tt6wb8/WLwrSs1WZdiMVP8zX4Z88mrcl26oYj2ksOseE8NFQNxG0FO41eaus4L5S8tRAuErnF19p4dmH8+Xk8v9LfvqBe2Q8PswYNGIDP4Nmjx8DDPuYcjd1XKlXJPP+tGF5adalLXYtqxtvsdJx8NncMMWncQll25zvSTpFTeF0EPW+OtLBBRUrexc3/reKqKs2lQ72AEtEOh8yJt6UdP4MBceIgHPFOcWa8Jb22EGbXOAehPBhafygo5BcQpyuoiQKNp6q8pCvL1/S2+l6/jWAW44V9gruyR/Vfjgfl074RThIh6uSSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8WNmBoEAlLecLRlLAYDScxh1DE/lcdah7CtrEyAtlU=;
 b=EPOJ0H0hlQYyIcTltGfzjbdUjJc+4ZZM4vpFKrV368O9if6FBFdj0vawpMltWBbvEvZZYouD4rUGTVRVtAvG0PQi3uo9U84v4rgRiYeIIgCAZisoipFdm7jaljHet9UOX9ldutj27ObvekSAftwz8pzyE/KnFrSzk7r2Wni+e9n82YfzhpyWg+A8ueFDLdwlrpESnO43Bw/sVca4u+/pE5on2FJ27OMLr7/qIM4ibdOCX5hpRBHCpLwUdTq/mNuf5XVbFoA81ThTWwHa2s5slRbqYAgbEOYhU5zoFsHfMZg8KgLCsgcWPRY6UQHV9/8Zszva+TO9BeAnhZbqdnea9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8WNmBoEAlLecLRlLAYDScxh1DE/lcdah7CtrEyAtlU=;
 b=ERQggkot4qe5aX5YPnIqW+mLlImtH/RI5OzNp0kyziVybCubBiJ8njghURmYR+VNXFVtqMyUNQjSA8RAhUAqKcWn3ZHJTowyoMx1VeUk7598KIp58lRf72qQcLzTEld3PuiQG58norVihoPCQc/dODsUGQHJTbozPHMKoboMhiA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5791.eurprd05.prod.outlook.com (20.178.122.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 03:23:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:25 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 12/13] net/mlx5e: Add support for FEC modes based on 50G
 per lane links
Thread-Topic: [net-next V4 12/13] net/mlx5e: Add support for FEC modes based
 on 50G per lane links
Thread-Index: AQHV5tPxCfu+5N8kzEuNt5UIP74b0Q==
Date:   Wed, 19 Feb 2020 03:23:24 +0000
Message-ID: <20200219032205.15264-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d72037c0-44de-425e-5a51-08d7b4eb1449
x-ms-traffictypediagnostic: VI1PR05MB5791:|VI1PR05MB5791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5791ABD3AB6C7CDC53F9B9E1BE100@VI1PR05MB5791.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(110136005)(54906003)(1076003)(186003)(8676002)(16526019)(316002)(66946007)(52116002)(6506007)(5660300002)(30864003)(36756003)(66446008)(64756008)(66556008)(66476007)(81166006)(8936002)(86362001)(81156014)(71200400001)(4326008)(2906002)(26005)(107886003)(6486002)(478600001)(6512007)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5791;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hSSKDglLLi0Dzf6TVvWvlr3ebiJis3CVGR7KsFI3zjqUDQp9ipg/KTnCjEJN1IwDCIU5lgKHf1bN/I++aNc5J8sXDyx9jK4j3VAYPdiPapftt57bu1OkvRq+gg0udZJewDynOf9cECihJ6v+6yLscR4SCGvkMWMmz3MtTozaTUO6y/aFNT+FHLg68Me/3o82xf+b/hz+eiQa174upF7PT+XBl8DPL9FLd2r3r1ZG3IcaBxxtkihE8GrDZHbefoFujfB2ZnQMnRRDqAxvEf3iCgVvuSm6bse10GuhtvV9EcjuVb7YvSaRLz2U1e5KifnUOHMshSnw5KYuKOnizC/X1y4yPVnl9Q0OzTYg8Huptqe6gtlh4RQK8LGELFgchOVfcNAlKWBuxnjncIkc/CXCzZ4LcJLl71gYcIAx6fc95bPtJqlHEBxfps8aJ9+MTpwrESaOvnYic38CwCjC//W3UfD33s+ig8ZpTek9zsRlhWDRSlkKwUQDhIL+z47nlarZr5ZWn+Vveg7cN4hLy99V6UcD11F1MFeUbDDPKwlFIq0=
x-ms-exchange-antispam-messagedata: 8y0qKB/ViMITVeS/xjG3bjQmq+G6eh0Gc1VnExEMBiv2F8A7X18cfPMJvDLMxS/KLiPeeZ8sDnQxVLOt2CVsEv3iAQaY1v233sRi9cWH6au+Mh1hFEYMqgY7P8rOoFWN4KCWJEisJwGdv2Pxm7USuQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72037c0-44de-425e-5a51-08d7b4eb1449
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:25.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xVVU3Ck1hO0EIqWGXTcDsiYo27WWG71SG8RPNM7rdiajbK/DP1NRB6QVxlYQQW+27Fl5bD0GETyvPAhwphKm/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce new FEC modes:
- RS-FEC-(544,514)
- LL_RS-FEC-(272,257+1)
Add support in ethtool for set and get callbacks for the new modes
above. While RS-FEC-(544,514) is mapped to exsiting RS FEC mode,
LL_RS-FEC-(272,257+1) is mapped to a new ethtool link mode: LL-RS.

Add support for FEC on 50G per lane link modes up to 400G. The new link
modes uses a u16 fields instead of u8 fields for the legacy link modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 90 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 14 ++-
 3 files changed, 94 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index 16c94950d206..2c4a670c8ffd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -349,12 +349,18 @@ enum mlx5e_fec_supported_link_mode {
 	MLX5E_FEC_SUPPORTED_LINK_MODES_50G,
 	MLX5E_FEC_SUPPORTED_LINK_MODES_56G,
 	MLX5E_FEC_SUPPORTED_LINK_MODES_100G,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X,
 	MLX5E_MAX_FEC_SUPPORTED_LINK_MODE,
 };
=20
+#define MLX5E_FEC_FIRST_50G_PER_LANE_MODE MLX5E_FEC_SUPPORTED_LINK_MODE_50=
G_1X
+
 #define MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, policy, write, link)			\
 	do {										\
-		u8 *_policy =3D &(policy);						\
+		u16 *_policy =3D &(policy);						\
 		u32 *_buf =3D buf;							\
 											\
 		if (write)								\
@@ -363,8 +369,21 @@ enum mlx5e_fec_supported_link_mode {
 			*_policy =3D MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
 	} while (0)
=20
+#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)		\
+	do {									\
+		u16 *__policy =3D &(policy);					\
+		bool _write =3D (write);						\
+										\
+		if (_write && *__policy)					\
+			*__policy =3D find_first_bit((u_long *)__policy,		\
+						   sizeof(u16) * BITS_PER_BYTE);\
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);	\
+		if (!_write && *__policy)					\
+			*__policy =3D 1 << *__policy;				\
+	} while (0)
+
 /* get/set FEC admin field for a given speed */
-static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
+static int mlx5e_fec_admin_field(u32 *pplm, u16 *fec_policy, bool write,
 				 enum mlx5e_fec_supported_link_mode link_mode)
 {
 	switch (link_mode) {
@@ -383,6 +402,18 @@ static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_po=
licy, bool write,
 	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
 		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 50g_1x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 100g_2x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 200g_4x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 400g_8x);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -393,7 +424,7 @@ static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_pol=
icy, bool write,
 	MLX5_GET(pplm_reg, buf, fec_override_cap_##link)
=20
 /* returns FEC capabilities for a given speed */
-static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
+static int mlx5e_get_fec_cap_field(u32 *pplm, u16 *fec_cap,
 				   enum mlx5e_fec_supported_link_mode link_mode)
 {
 	switch (link_mode) {
@@ -412,6 +443,18 @@ static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_=
cap,
 	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
 		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g);
 		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 50g_1x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g_2x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 200g_4x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
+		*fec_cap =3D MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 400g_8x);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -420,6 +463,7 @@ static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_c=
ap,
=20
 bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 {
+	bool fec_50g_per_lane =3D MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_=
pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
@@ -438,7 +482,10 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int =
fec_policy)
 		return false;
=20
 	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
-		u8 fec_caps;
+		u16 fec_caps;
+
+		if (i >=3D MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
=20
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		if (fec_caps & fec_policy)
@@ -448,8 +495,9 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int f=
ec_policy)
 }
=20
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
-		       u8 *fec_configured_mode)
+		       u16 *fec_configured_mode)
 {
+	bool fec_50g_per_lane =3D MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_=
pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
@@ -474,6 +522,9 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *=
fec_mode_active,
=20
 	*fec_configured_mode =3D 0;
 	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		if (i >=3D MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
+
 		mlx5e_fec_admin_field(out, fec_configured_mode, 0, i);
 		if (*fec_configured_mode !=3D 0)
 			goto out;
@@ -482,13 +533,13 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32=
 *fec_mode_active,
 	return 0;
 }
=20
-int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
+int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 {
+	bool fec_50g_per_lane =3D MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_=
pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
-	u8 fec_policy_auto =3D 0;
-	u8 fec_caps =3D 0;
+	u16 fec_policy_auto =3D 0;
 	int err;
 	int i;
=20
@@ -498,6 +549,9 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fe=
c_policy)
 	if (!MLX5_CAP_PCAM_REG(dev, pplm))
 		return -EOPNOTSUPP;
=20
+	if (fec_policy >=3D (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
+		return -EOPNOTSUPP;
+
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err =3D mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
@@ -506,10 +560,26 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 =
fec_policy)
 	MLX5_SET(pplm_reg, out, local_port, 1);
=20
 	for (i =3D 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		u16 conf_fec =3D fec_policy;
+		u16 fec_caps =3D 0;
+
+		if (i >=3D MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
+
+		/* RS fec in ethtool is mapped to MLX5E_FEC_RS_528_514
+		 * to link modes up to 25G per lane and to
+		 * MLX5E_FEC_RS_544_514 in the new link modes based on
+		 * 50 G per lane
+		 */
+		if (conf_fec =3D=3D (1 << MLX5E_FEC_RS_528_514) &&
+		    i >=3D MLX5E_FEC_FIRST_50G_PER_LANE_MODE)
+			conf_fec =3D (1 << MLX5E_FEC_RS_544_514);
+
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
+
 		/* policy supported for link speed */
-		if (fec_caps & fec_policy)
-			mlx5e_fec_admin_field(out, &fec_policy, 1, i);
+		if (fec_caps & conf_fec)
+			mlx5e_fec_admin_field(out, &conf_fec, 1, i);
 		else
 			/* set FEC to auto*/
 			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.h
index 025d86577567..a2ddd446dd59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -62,13 +62,15 @@ int mlx5e_port_set_priority2buffer(struct mlx5_core_dev=
 *mdev, u8 *buffer);
=20
 bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy);
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
-		       u8 *fec_configured_mode);
-int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy);
+		       u16 *fec_configured_mode);
+int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy);
=20
 enum {
 	MLX5E_FEC_NOFEC,
 	MLX5E_FEC_FIRECODE,
 	MLX5E_FEC_RS_528_514,
+	MLX5E_FEC_RS_544_514 =3D 7,
+	MLX5E_FEC_LLRS_272_257_1 =3D 9,
 };
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6624e0a82cd9..68b520df07e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -633,6 +633,8 @@ static const u32 pplm_fec_2_ethtool[] =3D {
 	[MLX5E_FEC_NOFEC] =3D ETHTOOL_FEC_OFF,
 	[MLX5E_FEC_FIRECODE] =3D ETHTOOL_FEC_BASER,
 	[MLX5E_FEC_RS_528_514] =3D ETHTOOL_FEC_RS,
+	[MLX5E_FEC_RS_544_514] =3D ETHTOOL_FEC_RS,
+	[MLX5E_FEC_LLRS_272_257_1] =3D ETHTOOL_FEC_LLRS,
 };
=20
 static u32 pplm2ethtool_fec(u_long fec_mode, unsigned long size)
@@ -661,6 +663,8 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] =3D {
 	[MLX5E_FEC_NOFEC] =3D ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 	[MLX5E_FEC_FIRECODE] =3D ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 	[MLX5E_FEC_RS_528_514] =3D ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_RS_544_514] =3D ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_LLRS_272_257_1] =3D ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 };
=20
 static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
@@ -680,6 +684,8 @@ static int get_fec_supported_advertised(struct mlx5_cor=
e_dev *dev,
 				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
 	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
 				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_LLRS_272_257_1,
+				      ETHTOOL_LINK_MODE_FEC_LLRS_BIT);
=20
 	/* active fec is a bit set, find out which bit is set and
 	 * advertise the corresponding ethtool bit
@@ -1510,7 +1516,7 @@ static int mlx5e_get_fecparam(struct net_device *netd=
ev,
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
 	struct mlx5_core_dev *mdev =3D priv->mdev;
-	u8 fec_configured =3D 0;
+	u16 fec_configured =3D 0;
 	u32 fec_active =3D 0;
 	int err;
=20
@@ -1526,7 +1532,7 @@ static int mlx5e_get_fecparam(struct net_device *netd=
ev,
 		return -EOPNOTSUPP;
=20
 	fecparam->fec =3D pplm2ethtool_fec((u_long)fec_configured,
-					 sizeof(u8) * BITS_PER_BYTE);
+					 sizeof(u16) * BITS_PER_BYTE);
=20
 	return 0;
 }
@@ -1536,12 +1542,12 @@ static int mlx5e_set_fecparam(struct net_device *ne=
tdev,
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
 	struct mlx5_core_dev *mdev =3D priv->mdev;
-	u8 fec_policy =3D 0;
+	u16 fec_policy =3D 0;
 	int mode;
 	int err;
=20
 	if (bitmap_weight((unsigned long *)&fecparam->fec,
-			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
 		return -EOPNOTSUPP;
=20
 	for (mode =3D 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
--=20
2.24.1

