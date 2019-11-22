Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5851079F0
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKVV05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:26:57 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726920AbfKVV0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:26:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMzp68RuKlu7ORuucJqNHhL6QlqtqLxr229+7PyWlB246GXKc4lVf57EXy0MneaPxUjqngCnnPNEeycvCNiu0wiMbCliBoSW3JHxXhcll8f7FFCl5iXwBA9e885wn9lIuXdlNKmvvdxy1BAPR8PwNkPvSapVxg/+B/R/gV5YDNO4gH9NIZpgQB3v3jhq7h8T0Y1mOG7ESsbD5PVjN0QCvftF6+tPKTUGoKT1qxzCZpNNMpyr46OfLy4GojRnEJbUiYR6lU9XuTGVmrp3Yx7Iwaz2XqRwp2odE7mhwAu4DgE/k51KZsyCWZOOJBLV7MGs1LzCXvT3I5DZvm8g19Sf0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+PdGztrxml2IKOZqjyOkONvYrbnKwyZ71zNhqzWL5s=;
 b=nP35l/XYjNRZMOOR+SjMgNrb8YfEQK2QVPs+fxcxCUQDZWFifO+NJ+dAQHGCiMCGoJ5euwFTeh8pN8kJhFnpU3G8T0spshSYwHcN1iH6I52hl6YFKA4cmrV/L5IEhhbZJO8ocv0A0zuOFxTOD/5iGDwX1pjIi5XQz1/UeBxiHOerxUFkYK4T0ardmvwN5zl4UAir2R0nUjVlmdh6uEPxMsDSgBKOzEgIPkYhy8IY5HlhBnFnTAfQmPLpkmUfuWMDa6BxbxcT2NnR++asbmW8DMqNkIMU4ypxbS6sSoEcRr+q3SzzCDSNjP4FoZX2SPv3+OgIRloseQfs5ed4BpCluw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+PdGztrxml2IKOZqjyOkONvYrbnKwyZ71zNhqzWL5s=;
 b=YHHejInhFTV5WgKMsRl/tXYMVE6FyT5FPHRbsNqhZ5wg6vY0KDcS9QDoMuO1NH2iq2UPoP03HUFUgaIApS7nr6XICiQBhV3ihvNAq9arGDm/+Rf5WoPkJNDFvTKcRmeGWzZd68iOyoHHf5OGNH20n4rlU1kETfpszmWl4tXIFcU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/6] net/mlx5: DR, Refactor VXLAN GPE flex parser tunnel
 code for SW steering
Thread-Topic: [net-next 2/6] net/mlx5: DR, Refactor VXLAN GPE flex parser
 tunnel code for SW steering
Thread-Index: AQHVoXuNgEXvQUvI3UWdENACNUhdUA==
Date:   Fri, 22 Nov 2019 21:26:50 +0000
Message-ID: <20191122212541.17715-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d0308156-704a-4102-f524-08d76f92afb1
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43500101BA3E415B1CFF01A2BE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gopaa9BTlTFVNTnPlT2wKuscRyLBZ93gDm7ijPpiD3MsTfJItVeaj50KL9/ndGg03USKP3h/fiFfcPBELsLD8VTNPdHwFvPbAJlVli9HDDsaEzOXPG8XmYnA/B59Jdxrh+Tsi8jO1a9Mwi2uk5HSsdxtt8igC3mxgRJXIQdCVBz8HBSJjpyJK5LJvQ/g5YNXrO1UvwP32yopkVFcI1KdyChOsfUpYGWI/oxIZ+HgpMR8Fr4wHVwVmpel3DC7ITd6w3Ueacor0OADumLw420lQb8X6ipSpaeSIqvraVwvfJNx/+dptqQL752TUifGjvPaYXJPj8SOZgLlnML+pd8jaZUDGhTag+Vg7nW4R0D5LeJqE/lMPNouppGDypFmL2KZqVogkBOKoerf0s/RCYWwOpAYfZHIMdoms9aQG7S5AhvcqVP8nkSO8JmeEL4C3jqB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0308156-704a-4102-f524-08d76f92afb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:50.1027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSkpuI01KJgCFXLTpVMbPFanSMxWaVe+KE5lvRNTLiNGCMDIjiUU8DjJx+b7TiTKQwluozsnLzD3wWGjVVdBQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

Refactor flex parser tunnel code:
 - Add definition for flex parser tunneling header for VXLAN-GPE
 - Use macros for VXLAN-GPE SW steering when building STE
 - Refactor the code to reflect that this is a VXLAN GPE
   only code and not a general flex parser code.
   This also significantly simplifies addition of more
   flex parser protocols, such as Geneve.

Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 33 ++++++---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 73 ++++++++-----------
 .../mellanox/mlx5/core/steering/dr_types.h    |  6 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h | 11 +++
 4 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index c6548980daf0..f177c468b740 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -102,13 +102,29 @@ static bool dr_mask_is_gre_set(struct mlx5dr_match_mi=
sc *misc)
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), gre) || \
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
=20
-static bool dr_mask_is_flex_parser_tnl_set(struct mlx5dr_match_misc3 *misc=
3)
+static bool
+dr_mask_is_misc3_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
 {
 	return (misc3->outer_vxlan_gpe_vni ||
 		misc3->outer_vxlan_gpe_next_protocol ||
 		misc3->outer_vxlan_gpe_flags);
 }
=20
+static bool
+dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols &
+	       MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
+}
+
+static bool
+dr_mask_is_flex_parser_tnl_vxlan_gpe_set(struct mlx5dr_match_param *mask,
+					 struct mlx5dr_domain *dmn)
+{
+	return dr_mask_is_misc3_vxlan_gpe_set(&mask->misc3) &&
+	       dr_matcher_supp_flex_parser_vxlan_gpe(&dmn->info.caps);
+}
+
 static bool dr_mask_is_flex_parser_icmpv6_set(struct mlx5dr_match_misc3 *m=
isc3)
 {
 	return (misc3->icmpv6_type || misc3->icmpv6_code ||
@@ -137,13 +153,6 @@ static bool dr_mask_is_gvmi_or_qpn_set(struct mlx5dr_m=
atch_misc *misc)
 	return (misc->source_sqn || misc->source_port);
 }
=20
-static bool
-dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_domain *dmn)
-{
-	return dmn->info.caps.flex_protocols &
-	       MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
-}
-
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
@@ -262,10 +271,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_=
matcher *matcher,
 								  inner, rx);
 		}
=20
-		if (dr_mask_is_flex_parser_tnl_set(&mask.misc3) &&
-		    dr_matcher_supp_flex_parser_vxlan_gpe(dmn))
-			mlx5dr_ste_build_flex_parser_tnl(&sb[idx++], &mask,
-							 inner, rx);
+		if (dr_mask_is_flex_parser_tnl_vxlan_gpe_set(&mask, dmn))
+			mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(&sb[idx++],
+								   &mask,
+								   inner, rx);
=20
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 7e9d6cfc356f..7a906938ceb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2103,68 +2103,57 @@ void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste=
_build *sb,
 	sb->ste_build_tag_func =3D &dr_ste_build_eth_l4_misc_tag;
 }
=20
-static void dr_ste_build_flex_parser_tnl_bit_mask(struct mlx5dr_match_para=
m *value,
-						  bool inner, u8 *bit_mask)
+static void
+dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param =
*value,
+						bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc3 *misc_3_mask =3D &value->misc3;
=20
-	if (misc_3_mask->outer_vxlan_gpe_flags ||
-	    misc_3_mask->outer_vxlan_gpe_next_protocol) {
-		MLX5_SET(ste_flex_parser_tnl, bit_mask,
-			 flex_parser_tunneling_header_63_32,
-			 (misc_3_mask->outer_vxlan_gpe_flags << 24) |
-			 (misc_3_mask->outer_vxlan_gpe_next_protocol));
-		misc_3_mask->outer_vxlan_gpe_flags =3D 0;
-		misc_3_mask->outer_vxlan_gpe_next_protocol =3D 0;
-	}
-
-	if (misc_3_mask->outer_vxlan_gpe_vni) {
-		MLX5_SET(ste_flex_parser_tnl, bit_mask,
-			 flex_parser_tunneling_header_31_0,
-			 misc_3_mask->outer_vxlan_gpe_vni << 8);
-		misc_3_mask->outer_vxlan_gpe_vni =3D 0;
-	}
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_flags,
+			  misc_3_mask, outer_vxlan_gpe_flags);
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_next_protocol,
+			  misc_3_mask, outer_vxlan_gpe_next_protocol);
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_vni,
+			  misc_3_mask, outer_vxlan_gpe_vni);
 }
=20
-static int dr_ste_build_flex_parser_tnl_tag(struct mlx5dr_match_param *val=
ue,
-					    struct mlx5dr_ste_build *sb,
-					    u8 *hw_ste_p)
+static int
+dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *valu=
e,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *hw_ste_p)
 {
 	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc3 *misc3 =3D &value->misc3;
 	u8 *tag =3D hw_ste->tag;
=20
-	if (misc3->outer_vxlan_gpe_flags ||
-	    misc3->outer_vxlan_gpe_next_protocol) {
-		MLX5_SET(ste_flex_parser_tnl, tag,
-			 flex_parser_tunneling_header_63_32,
-			 (misc3->outer_vxlan_gpe_flags << 24) |
-			 (misc3->outer_vxlan_gpe_next_protocol));
-		misc3->outer_vxlan_gpe_flags =3D 0;
-		misc3->outer_vxlan_gpe_next_protocol =3D 0;
-	}
-
-	if (misc3->outer_vxlan_gpe_vni) {
-		MLX5_SET(ste_flex_parser_tnl, tag,
-			 flex_parser_tunneling_header_31_0,
-			 misc3->outer_vxlan_gpe_vni << 8);
-		misc3->outer_vxlan_gpe_vni =3D 0;
-	}
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_flags, misc3,
+		       outer_vxlan_gpe_flags);
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_next_protocol, misc3,
+		       outer_vxlan_gpe_next_protocol);
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_vni, misc3,
+		       outer_vxlan_gpe_vni);
=20
 	return 0;
 }
=20
-void mlx5dr_ste_build_flex_parser_tnl(struct mlx5dr_ste_build *sb,
-				      struct mlx5dr_match_param *mask,
-				      bool inner, bool rx)
+void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *s=
b,
+						struct mlx5dr_match_param *mask,
+						bool inner, bool rx)
 {
-	dr_ste_build_flex_parser_tnl_bit_mask(mask, inner, sb->bit_mask);
+	dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, inner,
+							sb->bit_mask);
=20
 	sb->rx =3D rx;
 	sb->inner =3D inner;
 	sb->lu_type =3D MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
 	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_tnl_tag;
+	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_tnl_vxlan_gpe_tag;
 }
=20
 static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *va=
lue,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index c1f45a60ee6b..a64af56b825f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -325,9 +325,9 @@ int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_bu=
ild *sb,
 				   struct mlx5dr_match_param *mask,
 				   struct mlx5dr_cmd_caps *caps,
 				   bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_tnl(struct mlx5dr_ste_build *sb,
-				      struct mlx5dr_match_param *mask,
-				      bool inner, bool rx);
+void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *s=
b,
+						struct mlx5dr_match_param *mask,
+						bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 596c927220d9..6d78b027fe56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -548,6 +548,17 @@ struct mlx5_ifc_ste_flex_parser_tnl_bits {
 	u8         reserved_at_40[0x40];
 };
=20
+struct mlx5_ifc_ste_flex_parser_tnl_vxlan_gpe_bits {
+	u8         outer_vxlan_gpe_flags[0x8];
+	u8         reserved_at_8[0x10];
+	u8         outer_vxlan_gpe_next_protocol[0x8];
+
+	u8         outer_vxlan_gpe_vni[0x18];
+	u8         reserved_at_38[0x8];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_ste_general_purpose_bits {
 	u8         general_purpose_lookup_field[0x20];
=20
--=20
2.21.0

