Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C394A1079F2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKVV1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:27:03 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfKVV1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:27:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQs/vvRv8oSW617s1PgtIcYrxkENrin34CxVOX/G0lQF+Tkz4TLQUYNhCp2yBrXQ6LZdia2yoLNe/TQ0DwkjOAugyCCP3aY9Pa3l5bP3uJJd8mTp+JTTT85w4wtaXABP6hD85iiy00PU7j6YneJRMrmYFU3S2NQ+rHVv2J03tYcv58cHCosggb0mKdYd50e5lOBHi9T6XRPRZMzXvWYAikwUoe9suGkEtCrwyF2MouTAZUP8nHmdVvQLd4VIx9EiIj2WUZgN/dXbEkhtG0uD3visEr8dRlHNKzr+kwue9RCsb5BrwsOYhYlZuoyJrGSWJCzaFUxXRO+wzlNuu1VcXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tF1P+IXYUNCNZRpGuNXOTIon8HlnTfzVCak7MthK8vE=;
 b=HBgi5lqkSmIhAanRcsKssVDXyB6M5rWwP9xD2g2gIda1u47E5dznTZvRrGV7Dk1fhLy0v7goaEpB4Id/7H8xMI8Z+KOwgU/MSD6Y+3HSukabLCL3D2uM0uq1qhemS0YVvGFlRRZhR6Qg/Bfh6SexHfKQKjljGZeDi6zCDJ/6pNZa0Bw97R63FhXWshEsB9q6MxhGoJBjRSbPhOQVzUUmNMANfuzTPGZqU1RTzY342CNBrXvLNmOKRddS+i2mQdarY2MYKdMN66cTSlNZvBbTBFGQSucZyqXBbC4NVFn9axpTHxqcpRlZIN1B4g8BGaNY0lYqu8B2sb6Cx3Z75T0+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tF1P+IXYUNCNZRpGuNXOTIon8HlnTfzVCak7MthK8vE=;
 b=d0Yj6XA4uZTcwYckRlD3qp4beWIVagixOnFis6hRhNU4iGA/8KZ2MTrLOLhVrIB6TZwhv19POuhD0I6H8EWhwZ0I2ufm/VaN2/H+8IDtRqHCCm6NclAfamXGrqpm7oYNfdeJhbJVHLXDqvNeyDiZzKScg/KjOGaGwXYdnMmbaqM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/6] net/mlx5: DR, Add support for Geneve packets SW
 steering
Thread-Topic: [net-next 4/6] net/mlx5: DR, Add support for Geneve packets SW
 steering
Thread-Index: AQHVoXuPytUcNHz+fE6CIRcd06PsDQ==
Date:   Fri, 22 Nov 2019 21:26:53 +0000
Message-ID: <20191122212541.17715-5-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21e2160c-e5c2-4048-2950-08d76f92b194
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4350F8A2B0CEBCD35A0CFF7DBE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ed+klQVWTHzbywm3mexaISBMuWt4RhdXlA+rpXIwFZSxOqpm6xRcmpfG22hpFhZGKsTzPEcP92Su7JVgopeZzqHB9AsPG8NMn6OAbTIVppd/MXAbWKRDfasAdXF4rJEmAf8D2cealeFUakZZGgMKl01v9S8Sm+Y7WIb1DkrxDYug4wbeD0oTX02T+DDj4LqNGjDBHWy4trAQuCkDMmurG7hk1VKpxY7dUG4BtNgENk4cinlYYJg24PP6T2FkM97b14kJEU/bc+ZfL2231W3i68TYUgKmWehp/zLdQCiamERrgM9mplaoYITMHQtRWAxMdeEliu9+TWsXsbMqBfsUBZCxvlczkQjy+7N4bE5WdJ0CnwivLoRuxQugR7N9kgRpzDSknqI0IvFRdyc9s3mX+XVcKuGwVCeBdGqFTwrwqCJWaolDLE6J5fFozhbJcy8L
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e2160c-e5c2-4048-2950-08d76f92b194
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:53.4158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O4yQt1hUgvXPx8HkpotqwP/oVqOOOKTo4H2lei8lv1V+bHH0++YzODaDe8qrxDaGr19btWtAqc/aLFweJHGhng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

Add support for SW steering matching on Geneve header fields:
 - VNI
 - OAM
 - protocol type
 - options length

Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 27 ++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.c      | 53 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  3 ++
 3 files changed, 83 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index f177c468b740..c6dbd856df94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -125,6 +125,29 @@ dr_mask_is_flex_parser_tnl_vxlan_gpe_set(struct mlx5dr=
_match_param *mask,
 	       dr_matcher_supp_flex_parser_vxlan_gpe(&dmn->info.caps);
 }
=20
+static bool dr_mask_is_misc_geneve_set(struct mlx5dr_match_misc *misc)
+{
+	return misc->geneve_vni ||
+	       misc->geneve_oam ||
+	       misc->geneve_protocol_type ||
+	       misc->geneve_opt_len;
+}
+
+static bool
+dr_matcher_supp_flex_parser_geneve(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols &
+	       MLX5_FLEX_PARSER_GENEVE_ENABLED;
+}
+
+static bool
+dr_mask_is_flex_parser_tnl_geneve_set(struct mlx5dr_match_param *mask,
+				      struct mlx5dr_domain *dmn)
+{
+	return dr_mask_is_misc_geneve_set(&mask->misc) &&
+	       dr_matcher_supp_flex_parser_geneve(&dmn->info.caps);
+}
+
 static bool dr_mask_is_flex_parser_icmpv6_set(struct mlx5dr_match_misc3 *m=
isc3)
 {
 	return (misc3->icmpv6_type || misc3->icmpv6_code ||
@@ -275,6 +298,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_m=
atcher *matcher,
 			mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(&sb[idx++],
 								   &mask,
 								   inner, rx);
+		else if (dr_mask_is_flex_parser_tnl_geneve_set(&mask, dmn))
+			mlx5dr_ste_build_flex_parser_tnl_geneve(&sb[idx++],
+								&mask,
+								inner, rx);
=20
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 7a906938ceb9..53068d508b21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2156,6 +2156,59 @@ void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(stru=
ct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_tnl_vxlan_gpe_tag;
 }
=20
+static void
+dr_ste_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask =3D &value->misc;
+
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_protocol_type,
+			  misc_mask, geneve_protocol_type);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_oam,
+			  misc_mask, geneve_oam);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_opt_len,
+			  misc_mask, geneve_opt_len);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_vni,
+			  misc_mask, geneve_vni);
+}
+
+static int
+dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
+					struct mlx5dr_ste_build *sb,
+					u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc *misc =3D &value->misc;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_protocol_type, misc, geneve_protocol_type);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_oam, misc, geneve_oam);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_opt_len, misc, geneve_opt_len);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_vni, misc, geneve_vni);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     bool inner, bool rx)
+{
+	dr_ste_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_tnl_geneve_tag;
+}
+
 static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *va=
lue,
 					     u8 *bit_mask)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a64af56b825f..290fe61c33d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -328,6 +328,9 @@ int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_bu=
ild *sb,
 void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *s=
b,
 						struct mlx5dr_match_param *mask,
 						bool inner, bool rx);
+void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
--=20
2.21.0

