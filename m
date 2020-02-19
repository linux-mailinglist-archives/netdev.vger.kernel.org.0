Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B655163B15
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBSDXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:31 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726776AbgBSDX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXxf4u6k6Ag6DdXT3ouvJq8Hm7KQ8VdZRxZ8+MOSFQd2ZkFkoQmpkb4hlz6dSrBtlEsEEBVEgjt33nGyzvJMDL9Ou0sR4eu8TlCDKRV29UzyEpYtkxXDd79W8Qejd0FTmE1LHxVRl5R4IbOP4swfAweSg3TblEV0Lm7By427J+H+11ehpu9IL1+ylkaP1rL2aeYq9+BHKP6NNMOO/qFYG5fStg8g5rzWBxB9G7N53mYJyEdkZei7ljxMOx4WKf7xPHcPFvj4a32D/ggH6WFv6kZ4foW6PYbyovgyzpRNHITDgKZ973Z+ntj6PVmWotPi1R1tqSGpnzh3xwZfh20uNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=JPlUlkjQphm8diqeYFQrTwghz2alpnLL/PYaDdzGO1l+E50/M7JB0kTcxjxaQ7zpdOR0agNKZBmIYUflZW8fenJxBocwsRzUzYO35qZCSNzyZw4pGds5WBo5x0Ao2bivnpdewZUtCjB2e/jKawI/1+2C4kxDjMA+xKbWKYtBtTKCbXrrw+uIyNxcJD3vEkfUzSwJDzZPUIGdDwxs2vN+25RedzKsYC9vTeGk/Il+9brSvWLPR+0sPIwasZKmT2iW2uXOQbKN4tr08wFDMTrDk5yB8SGJc2u9kBSONYfhuIgOvkZsXeFzH6wbFFwwTsK4Ou9B7rjh0wQwSnAkNAeHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=Pt5dDoLjMosO2gNU8ZOfMPK0eGTzHXRCEfu9V6i18sT6xXKlQr6en5ihsbsnvU8V5d+3GYV2EUXUbazh+FDWh3xmrFQLrtEGe1PULr1lfZbMbDTBEA1Z5SKrqrV5+yDATLQW/QT05ccXWcSPXgQHpLOFeu5XTjr2w5lGaTdvjlU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:18 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 09/13] net/mlx5e: Advertise globaly supported FEC modes
Thread-Topic: [net-next V4 09/13] net/mlx5e: Advertise globaly supported FEC
 modes
Thread-Index: AQHV5tPuh+O+A8ubYEiq8fH9eJ37/A==
Date:   Wed, 19 Feb 2020 03:23:18 +0000
Message-ID: <20200219032205.15264-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 72738b78-873f-4c1e-791c-08d7b4eb109f
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB459094F647BE2106CFF32A06BE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4DoMiaKaDfH8ddWdU6Poaj1aB/YRJpvzRKLV8JN9DKMH7YgU4Gilm86Rw0ykeZeOVlVl29vuk7EiEalf7cIxeTGFS7rX4t4ez+G6IKznYu2LoxjqwtxkymDOOpLKI6NPzfiUZaY5gAe89XYMyxW9/c70p59pSiuqDMqBOA4rZDCA/Kgb7QXAcCXdJqZY/g85iXaGnC4EbLSXyGT0fGHLLhjhUqL5EbhsgZNRO8KnAcwm128hHzL9/vQjgKIM/yrFxZZz/x1UmUIccPBT92kxEH/ccHWRDkJYF3Cr49JHA/goFAmsEXJSgVZ/o8eBcDk0/xwSc2Ys1pbjmY0VFhKTzfBtyOfryYL/w/9OU5Xsf2SMxAZ9TGWSLffe/zCAUEtrTub97lzKSAL/FBLfr7wT7qq5J4hmZYwYuIqyC0J6SlGx4PdAQ39g/Jn3JnnIFOFss74+jtDybfUmu32I+1F82LmIszuq5QufDrJkfe4ugG/h7TVHnW8LEmjItzkOHrvkMpKYPnqXncYrJgD41J5HjeVIIAN2Jm6txCgBAKdvtA=
x-ms-exchange-antispam-messagedata: LijQxcmz3SXtd/GgfxoKa30SYy8YeIv4npV+ppOSTeDuCBvZ217EkYOm3VDa2VJFAlnoSgnfPH1qy0R2eWDy1/xYi2babv+Mng7U+bjOJBBBcYDht3W4qcKebOG3BAYpUX1vqRfx0aIu3Q5sUmgFjA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72738b78-873f-4c1e-791c-08d7b4eb109f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:18.6654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtiaLiBJliagDyI9gY9D+o6nmFcNMMnVMMShPei9NaXuYddz7FYDYF2A3E3F5AwFesa8KvASZNSQKtffU//DBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
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

