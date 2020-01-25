Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3231149379
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgAYFMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:12:17 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728236AbgAYFMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:12:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPPpRgteeFiudelXecpjMkp99c8yOHglp+ipQXVd6MBVVbFfuZPXI6CLfV3n7ssfYybrUoEeM9CvQN02Fkp0qzN9km9JtiWrVWI5F1DYBTNxjrW6MHVfSM/prIh4+jxQOA57Kpr2IXauQvLFJ9YL02BVVB4gDIQuJO9IcynEEwKGvgiBZGTn61NGb7lcGS72cvjUzgYflIJaPfq8szMImlO/1BfU7NaV0e9gx+tyGoz+5otLjq2C+fGJZOq0UYzIOmD33tCt7VoZcCsf6/jqDiD51KxFxqibzlHtSvLTvk+GOlZmnFW0WObwvLOB+VUJoL9Hr/ZIr0sPpND+JfB4oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8WNmBoEAlLecLRlLAYDScxh1DE/lcdah7CtrEyAtlU=;
 b=Ls5UcJZI3/vIRuO6pRCJ2onLXqstApOUnsBDU7Yexfa4WrcNKprffib72imRxAB/IvthyNoy8HMpeDjoRBhQNwML5jbIXg28Vy+wixT3NsPD+2r1Y8YwhbCHWo0SyKoIdd0AEXWDyAo+egldd4/l87F8XRZaHbePOmWVh1QrRuABDAXUCNeV4o6vwl97pf0PX6guKzqV7XwyMMzd6ikOD3eb2My8znDGclaksJYeeJdXhH+WgAriTb39gj1iWU1e2pOT2xK2bSNjPN4NYvg6Jhg1YW1DhJuA5kUkxS9X8acvVbqw031Dep1C5f1Vk9qpC0v5t5q3HpJ9gGWzhHngBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8WNmBoEAlLecLRlLAYDScxh1DE/lcdah7CtrEyAtlU=;
 b=WtJTbCS1s8UzW6HUYYkIbntR9iijZGjgomm8rYWD6luJgKtbkcunBP8/0oIfAxOAU63fr/dSaknKQiCqAz3K7iD14R+pSfR0p6haTtSYi4lCV5Lo+U178HZSdO9PIKy97UZkhB8HBOJL9rEvdeKtHzYfPHzMu+r1xX2SlYoKLDk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:54 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 12/14] net/mlx5e: Add support for FEC modes based on 50G
 per lane links
Thread-Topic: [net-next V2 12/14] net/mlx5e: Add support for FEC modes based
 on 50G per lane links
Thread-Index: AQHV0z31k4NA5YwGdEKVlutw1ibBVg==
Date:   Sat, 25 Jan 2020 05:11:54 +0000
Message-ID: <20200125051039.59165-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 730da68c-8e6f-4728-0232-08d7a15517ff
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394BD6540414844C9111080BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(30864003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XyJ+iMUEPIttATBNpJO4Vq/ick1iYMSNlaRkzf8jSImjCKwCUfBS0djNyVWn+mDeySpIBbagl7aP98pUB1iRj6KFQ+/QQmYkyyTPRRtTnqkZP84GRPBdlJ0Mo5bKJysIqb5v+/VrOedieVOT3jyrtq+EuKXJ+htNAHPWQ5skqp2CGVlTVsof1yPa1sOcG+YaRY+q4y1Nnleimt6g3AadTMb7ZVn4Ca2oxOV56+uDQbCV8wFayCFaX8qcx0NEfe1h6/ojjIxqliRySHTuZArxZLof25KsJKnQPQ2Bzh9uPStsM62E773US42hc+YsvNRumtcbNN5aSYsoLO31shmX8MZJd705RI0GSTXJGYPrJVswnNZNTGUcdkwVSHOxjo6z6MFVtw5ssxHWvV6q3rGXppsXS3L9/1+0/72bDZgbAcrQSz7pusa/p1XBbbi5nSR+C/15FWrnT2rsZgCO9Bn8sLgxtWeCj/ZgnjNvHsfMUO92wOf57m7Oivb886gTaJKKNEM5Cf595qat6D7TJu3L8eZvz0VX6lmzT4Sj0F5jNU8=
x-ms-exchange-antispam-messagedata: /AQh+FU+J5+0yb2Uuvo2JDx5Jcxv/cMhp9Er6FCXAh5+mUa0jHcCcSzLZSjg6a7KnQiWhvuopqSSrTRuS6ZRi7Hh5dFEFu5ItWhOy8VEI2iWnsqkEIyu7Z56bkEA8yy2QgrMRP1adaG6CyAZv+Ip+w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 730da68c-8e6f-4728-0232-08d7a15517ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:54.6213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3N0ceOBVjj5ZoMNCdqCnTyv7uJIm1/Cch+PWqtHL/8EgQFumUbgDhrmupPB5cVpKH5QA/BbMUno8XN4wGBS1SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
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

