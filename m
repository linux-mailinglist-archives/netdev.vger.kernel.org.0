Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11175149084
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgAXVz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:26 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgAXVzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVQvqrXhCUPLUJwoRjuvV7oLnFwCviE5TQY4crHjjigEuEiQK44xZPUuT8/FyPVpjIxwASO0yUF0gd8jMep/UIcmh5dUDWb14NGB3gs2rRurSl4KkVFpvZ+Y2iVmrwnG3lN1GhHhm2M0zwzt0VmogvpJTfa+GJs7/k9o0tLJJwLIWCiPXvIKyiVO1IjKyRE9M23q1aP+qPbvR+VQpfdvLTID5BZKBoF11b/uNpIZehGQXLumA0KkbEZuuUGMQYTjvmB7W255Y2+ko0ywBdCQMo3/Nsr6wvDjLwatRszyCOUvBoojf7U5p/1dNaaIV7BhcWKdrvJg4fTzhvqXCKIrKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=OfQeJ5ivTeELmWLj0R1yqaYcV4T4c7HZl/Qco+2WCbQ5n10Az13BMtj32yKJzv3ggOduaH0Ev8p5fT9JFHU2XIG/xZqFhuFK0VUvZ3loVtEnzEV5PNLVloKir5nJUw8o7+Qjbf2UaaS15X+dYJqHdcNnAYj2MXWgzwqEWBlBrsKLyrDTH5zunm5OYeFBu75WGg8RIKtibbPRf48SI2HRW3JECem8czH5A16Ry45uNLB1SMzHGpkzBa2zNusNYbQ/g/kMyGgNz3/Rr2aX52qmPwOxYXVh6IdEbpuHuOhv+pMtENTf/lBGckxMot2o0zIwGz4M/7chkR7mxS726U++4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUX9ENQPpPLhGB7A9RpKuPN8D6BVN59otZlhSzUuuME=;
 b=txR1BLcfNmJYMcDGPjD6SnQPh3vp2HYO0xA+Mf+eB9oN2vUJW2EJHdhEC3eYaqb6rJNiYC2UTUufp9gtmJ1ekyRcE8nOWiVi/bmjIhdCg1b7r9Z54F8lH3xNcZOdBMzNCpQS0tBpuJ5lo2AGnxUHeqkwgG7CxF7ZcQshnoaTBT8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:12 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/14] net/mlx5e: Advertise globaly supported FEC modes
Thread-Topic: [net-next 09/14] net/mlx5e: Advertise globaly supported FEC
 modes
Thread-Index: AQHV0wD0PBDNE+OjHUW6woAkrzr/BQ==
Date:   Fri, 24 Jan 2020 21:55:12 +0000
Message-ID: <20200124215431.47151-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7a50793e-821e-4490-2bdf-08d7a1181665
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5456E9421B56B954AADD413DBE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oJ5A/v83eEkD08kX7deTOqZ1ViQA0hdAjVhch48yDHjFSFtRKITnFuvOB7kvL9CmcJ21NVahmkG7QkHYvoBlSBkDi7nZrBtu7nfNOpZs5up9IctJEiygIMguJK3aCVSveh854y4w7Gr4YxL0twJFS/4p9vD8Vibjx/SksR44avfMYqRrwucCGC4H8Uto09HNf48eMKal+kSNtlrQWAK7k4uq9nPTv2o1Qj4zssZx0qKvx8JZL9zEzVoZIqPDVchQRWFoPPV2HkRI0noj54ZeGLUkdsB+suUdPD+cSyDQZ2wSqOAoMfqBjDECgTiENLbrZzcG2099enYBCi1m7anx/BMpSXXIJcgh7Q+k1wG0XYexkVfJKY9m7DKd8aHWg0Qz7z9pSAoKCXCYBBzObxXi3aHv23kWtgFh1VzwKSjoMlskR1wbBzXra+yeF++USU+O7ZCSXjIQ0WtZAGQmMbh9HgenRHPNlmOw78GUDqetWrWi4NhwyPCH9DXimkeB1jfGYnHcVgm350qugBCQlZuZX5AAevF2NhdkOoW5cUXAfIE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a50793e-821e-4490-2bdf-08d7a1181665
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:12.5589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dth+1sJTwegYekcAMIHEIW9Gr36TeWmLj9HeXqzflbJ09HBa3yI15FmF/IfcwDnw5o9Pn+rUSomX5eSoywrUTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

