Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CCF149373
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgAYFLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:53 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbgAYFLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llxavaMLQmSxxvVzpuMKSuQ0gkf1kQfiARz7nbP3BDEcgdhAv56wech2k8nhUUD9tCmdrS7/LhLqewvL36f9zlOxYGZolTs5tSiLdcSeB35mFLiEBWbjIz68tPWi5oltxEliBqADViatGQy3Gqn+52Es/nEnXby+tFAF1ZZmv1ax/zdhpJjPl/iDCnXxDWBAQq92mHDviPnjNNuMfCY6Y5fM6cMjerKWOVd0GZD6A2McHIFucJRXblQHeiHp6VWqiBQrnZLuewmUtOwtGhUAtz6HHtfDodGTvsPwuvM1usEqjBtCRzgKMePDpHFJby5klE8FpMozA4Wapfp2x0P75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=Rb8THS+yJskgO11jcyVXrK2zXOWy+sQNkRUawWTBJ7Y0EBHzc2hID+YUKSAVIXqlQyZrbYIRvYrWV02Vivyv66UoNp7RxJfHlFmVBuSv+jZh7PLxaqnGTFdctpUdMQv+UW4tsYeW+tV2NZG1h+5LY6vuW+z3pwtSxXf4+07qmHkMHJJ4+tBd1l37DKahlO/Jg1KUJZ0arOQm+LHfM3miHX4oqIQlWDqwpLIXoCd2K4uC7oBrn9pd7goEavY8qcok5qkl34OH78Pun6u6hWg2yf6Bzv2uVvAjGTJq5Bx1rDDgZkEbWnR0i5Q5Rh4HYqF8if4FNc/AS2px3hNIUSYIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=mnq/gKeCU/EKTX/uZCGvCqIyFtF83FhWmOW3sAVyxsw4UmCcOSZ93eu6PosSyy0WHweRTNVKKck9Mzdtzp4YPEUAylkyXGc2Pnctz26clONXv8UV4tnVHKMaiDwm/icTKUcFO7q2sUCXFmVHrip50JI+H9JqWftIHAVo5CVyV+g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:43 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 09/14] net/mlx5e: Advertise globaly supported FEC modes
Thread-Topic: [net-next V2 09/14] net/mlx5e: Advertise globaly supported FEC
 modes
Thread-Index: AQHV0z3u9a+xopU+NUuDDVqQoXXWAg==
Date:   Sat, 25 Jan 2020 05:11:42 +0000
Message-ID: <20200125051039.59165-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f0e12c90-bd92-4811-f438-08d7a1550f06
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03948E12F465088D5FBAA260BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4H7wcdLJL2PhHW8pkpsLMH/ALypW0OBrVeQzwoJ8glCVg75MOTIGMLZK4puL9ylXaogiyVxSrXRtNa9GCZ4dVpFm5xzBU1B4A+PKVK2RFnTplMqtqrgk3Sd62nZzf70WaHPk5SIpkReBjnp/kJPuxlaOnrBc76HnfTrsEsc0DKsGydbX/U6ILw+rJOIxHHafPnIrvD0cjZc1387vzE0HpR8NlfpceWwIo2wYsbTfxmvh96r9GcnH+EunRMcqhAfBFS+ouh/0UOTdSiDjBFEisChDGrJ6TSiYacreW9Nj+7aVLQqqu8C6E50aXkhVkVzJ3NAcoglKJLo7ITf/6vvtR7iuHNa+FKgdPKbZ/VLrYC+qgDJRj73PSM5ysZOeaIQv5Yl7Au5VQnVoTb/X0Jw6ius3K332hydVtoJjBv8E9CYkgH9FoE35aRDIm0Z9I4kf0jOk309HV1zFdeOz67LDb/ZcJijta+K8QCJVhw7c3QrUOJ/Ia06DkOw5uvkuR/ZT6KaFLPka40TmA6vZ2mKHkR3ryyuEaRqREc3+4J14rwE=
x-ms-exchange-antispam-messagedata: yi0JYY5GSrKQ1e5wcPromBTd7/2IYvSs45k6hiAe/84ZQaE8mgofVqWtjd1UCc4xvVO/jRlduFWHh2ogfs/Iy0buC9puw4yjdG8kMFoW5/huJmkI7y0jf2vG+1Fkszd9IsahVHPQbSZfOCR1EjxJ7A==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e12c90-bd92-4811-f438-08d7a1550f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:42.7320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9sbmuhYFigAhD8Bs6ZUS4bdXrzYxlRZ9MqMJP0/CX5jTvJ5xJgMSoMuYVjFkRH8QtwFxPHGOWmtjkVrzEQ4Rcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool advertise supported link modes on an interface. Per each FEC
mode, query if there is a link type which supports it. If so, add this
FEC mode to the supported FEC modes list. Prior to this patch, ethtool
advertised only the supported FEC modes on the current link type.
Add an explicit mapping between internal FEC modes and ethtool link mode
bits. With this change, adding new FEC modes in the downstream patch
would be easier.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 17 +++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 55 +++++++++----------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index f0dc0ca3ddc4..26c7849eeb7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -441,13 +441,13 @@ static int mlx5e_get_fec_cap_field(u32 *pplm,
 	return 0;
 }
=20
-int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 *fec_caps)
+bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 {
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
-	u32 current_fec_speed;
 	int err;
+	int i;
=20
 	if (!MLX5_CAP_GEN(dev, pcam_reg))
 		return -EOPNOTSUPP;
@@ -458,13 +458,16 @@ int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 =
*fec_caps)
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err =3D  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
-		return err;
+		return false;
=20
-	err =3D mlx5e_port_linkspeed(dev, &current_fec_speed);
-	if (err)
-		return err;
+	for (i =3D 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
+		u8 fec_caps;
=20
-	return mlx5e_get_fec_cap_field(out, fec_caps, current_fec_speed);
+		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+		if (fec_caps & fec_policy)
+			return true;
+	}
+	return false;
 }
=20
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.h
index 4a7f4497692b..025d86577567 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -60,7 +60,7 @@ int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void =
*in);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffe=
r);
 int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer)=
;
=20
-int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 *fec_caps);
+bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy);
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 		       u8 *fec_configured_mode);
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d1664ff1772b..6624e0a82cd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -650,45 +650,44 @@ static u32 pplm2ethtool_fec(u_long fec_mode, unsigned=
 long size)
 	return 0;
 }
=20
-/* we use ETHTOOL_FEC_* offset and apply it to ETHTOOL_LINK_MODE_FEC_*_BIT=
 */
-static u32 ethtool_fec2ethtool_caps(u_long ethtool_fec_code)
-{
-	u32 offset;
-
-	offset =3D find_first_bit(&ethtool_fec_code, sizeof(u32));
-	offset -=3D ETHTOOL_FEC_OFF_BIT;
-	offset +=3D ETHTOOL_LINK_MODE_FEC_NONE_BIT;
-
-	return offset;
-}
+#define MLX5E_ADVERTISE_SUPPORTED_FEC(mlx5_fec, ethtool_fec)		\
+	do {								\
+		if (mlx5e_fec_in_caps(dev, 1 << (mlx5_fec)))		\
+			__set_bit(ethtool_fec,				\
+				  link_ksettings->link_modes.supported);\
+	} while (0)
+
+static const u32 pplm_fec_2_ethtool_linkmodes[] =3D {
+	[MLX5E_FEC_NOFEC] =3D ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+	[MLX5E_FEC_FIRECODE] =3D ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+	[MLX5E_FEC_RS_528_514] =3D ETHTOOL_LINK_MODE_FEC_RS_BIT,
+};
=20
 static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 					struct ethtool_link_ksettings *link_ksettings)
 {
-	u_long fec_caps =3D 0;
-	u32 active_fec =3D 0;
-	u32 offset;
+	u_long active_fec =3D 0;
 	u32 bitn;
 	int err;
=20
-	err =3D mlx5e_get_fec_caps(dev, (u8 *)&fec_caps);
+	err =3D mlx5e_get_fec_mode(dev, (u32 *)&active_fec, NULL);
 	if (err)
 		return (err =3D=3D -EOPNOTSUPP) ? 0 : err;
=20
-	err =3D mlx5e_get_fec_mode(dev, &active_fec, NULL);
-	if (err)
-		return err;
-
-	for_each_set_bit(bitn, &fec_caps, ARRAY_SIZE(pplm_fec_2_ethtool)) {
-		u_long ethtool_bitmask =3D pplm_fec_2_ethtool[bitn];
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_NOFEC,
+				      ETHTOOL_LINK_MODE_FEC_NONE_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_FIRECODE,
+				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
+				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
=20
-		offset =3D ethtool_fec2ethtool_caps(ethtool_bitmask);
-		__set_bit(offset, link_ksettings->link_modes.supported);
-	}
-
-	active_fec =3D pplm2ethtool_fec(active_fec, sizeof(u32) * BITS_PER_BYTE);
-	offset =3D ethtool_fec2ethtool_caps(active_fec);
-	__set_bit(offset, link_ksettings->link_modes.advertising);
+	/* active fec is a bit set, find out which bit is set and
+	 * advertise the corresponding ethtool bit
+	 */
+	bitn =3D find_first_bit(&active_fec, sizeof(u32) * BITS_PER_BYTE);
+	if (bitn < ARRAY_SIZE(pplm_fec_2_ethtool_linkmodes))
+		__set_bit(pplm_fec_2_ethtool_linkmodes[bitn],
+			  link_ksettings->link_modes.advertising);
=20
 	return 0;
 }
--=20
2.24.1

