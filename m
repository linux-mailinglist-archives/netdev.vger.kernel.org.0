Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6063ECAAC
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKAV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:44 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbfKAV7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjTu5SG+vNzEVqSUnUjslctcTblC4sLbevSoN6l/mFa1SaxyRAxOeTNl/PBYBIVD9Xzr/ocx+/afaI32j6lZi5VoCtV/UAaKxWgvE8apVNMeWia2crIQqHTlveQq//OCUwgQNsuu5cbbioTlaAKIpyhuq3jDIzoxPx1tIPn58Et3uvdQKFi9daw+d9sR44JLoCz0vsEhXxlgdE4U+4NzxT1aUZ2pxS2PRZYEmCngI1nNK3PZZUMXrTpYng0cuC9Oaz6QfE6FIawoJ845Jj590yjuOFfyAYu2aKZhhxxCXbUHjJI1L48O49ft4T4yUwjyEj0hvlwEwb5/UaweEWmL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl5hMU1hKz2oV486NUyVt84ycBwfcIIduPrH3UjSon8=;
 b=TF6z1X7bXm49WvzgRuw8JXAm1/my2SB6trWdSw+fMBR6QVVgGnuJ6dlEcGLUozATXi7VOdtyI0l5wsgvPEvJkgc0i4nan8ltnYxG6WknrVzwtzENfMdt3nh287TterOKU211MzWkjc4D3NA1MEIi1uQuI4Jm3rvVwe7x93PgjEaSMsbo3wvLTdoF5nLE9Qp6uHmClU4Uq4gDt/JsO+0++IoefGD5KRaoAK9afx4ePDv+KPft2gHrj+JD2uNKMgfPFr8vcK6iWgE/8Lk85iMStEOodKxyEy9b3EZAYLX0QRhUZphG0O505Az5kcwfeFXRFvn2QDkre+yUgt0JJQztDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl5hMU1hKz2oV486NUyVt84ycBwfcIIduPrH3UjSon8=;
 b=RzINWEZoO6Fi0hkhTrJazcqUh2+2RKqviQDF5GAlX/NpQReFaCon8uCzz8R7oPz9JlPZ/E9PLdEdpFpQUHLyrdhPHMK0eRC6HbyBbKbfbRIj0eXZRP4g/uUnGvmNQqiiMvOYbKvToUsdQYfKppjd2KxNBGo8WbFa+3VWCy28ZtU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5: DR, Support IPv4 and IPv6 mixed matcher
Thread-Topic: [net-next 15/15] net/mlx5: DR, Support IPv4 and IPv6 mixed
 matcher
Thread-Index: AQHVkP+f5DRbWnMbbEK0yzBGk3MscA==
Date:   Fri, 1 Nov 2019 21:59:23 +0000
Message-ID: <20191101215833.23975-16-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 335f8af3-01ec-4522-2308-08d75f16c173
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB56791F6A740280DB898B0550BE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(14444005)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uq3pFFjAMzHswtpTrwTOxcBNOWW4DDZ8ucUdNK8zuG1jBmAOH0AacSds6bsbTwrIY6jX7gPFJDYCG5j8xfz5O7XiZ37DmPAYWJ/BoN7TeF4lPAapS1kQoRhW0Hlfm1KagCTJwPnYfR4457nOuzH8WdcRKcxHrPHaba+K6StJQXfzO56/cL49w27d2PMwU5T2blidf8zv7Oiw7Khb3Xc6IWMH6mwQR4nJDV9J6Qmdq7rtqMJSiUcWKrOaoxFaWO2waX+tl/fFyr6FWlKqMd56KSgZzyrP1lVex2bIhWseGQp7oz5zSw+3y03b1TQflQ5/Yx7lfG6MbXjm2FRG2aPGtSObgTB2aTCKmm+GfqOvVR8uvHtBgvyMMvg43YBNTOmnooSaXbnTbQDcyZoonEv5aRzft34jUPpsU7tUVhBLDXTe7rN+2psGm0htbgeK9cuV
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335f8af3-01ec-4522-2308-08d75f16c173
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:23.7880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: schlKJygCOM+89jJFc9ZhtgwsT+LqVAPpz4icUUU+LE0uwJTRT8dGCZdpcHRsXFax79sFZnJXSAruVua2HdnQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Until now SW steering supported matchers that are IPv4 and IPv6.
The limitation was mixed matchers in which the outer header IP version
was different from the inner header IP version.

To support the mixed matcher we create all the possible ste_builder
combinations, once we create a rule we select the correct one to
be used for rule creation.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 65 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_rule.c     | 13 ++--
 .../mellanox/mlx5/core/steering/dr_types.h    | 17 +++--
 3 files changed, 52 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 67dea7698fc9..5db947df8763 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -146,17 +146,15 @@ dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_d=
omain *dmn)
=20
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
-				   bool ipv6)
+				   enum mlx5dr_ipv outer_ipv,
+				   enum mlx5dr_ipv inner_ipv)
 {
-	if (ipv6) {
-		nic_matcher->ste_builder =3D nic_matcher->ste_builder6;
-		nic_matcher->num_of_builders =3D nic_matcher->num_of_builders6;
-	} else {
-		nic_matcher->ste_builder =3D nic_matcher->ste_builder4;
-		nic_matcher->num_of_builders =3D nic_matcher->num_of_builders4;
-	}
+	nic_matcher->ste_builder =3D
+		nic_matcher->ste_builder_arr[outer_ipv][inner_ipv];
+	nic_matcher->num_of_builders =3D
+		nic_matcher->num_of_builders_arr[outer_ipv][inner_ipv];
=20
-	if (!nic_matcher->num_of_builders) {
+	if (!nic_matcher->ste_builder) {
 		mlx5dr_dbg(matcher->tbl->dmn,
 			   "Rule not supported on this matcher due to IP related fields\n");
 		return -EINVAL;
@@ -167,26 +165,19 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matc=
her *matcher,
=20
 static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 				       struct mlx5dr_matcher_rx_tx *nic_matcher,
-				       bool ipv6)
+				       enum mlx5dr_ipv outer_ipv,
+				       enum mlx5dr_ipv inner_ipv)
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
 	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
 	struct mlx5dr_match_param mask =3D {};
 	struct mlx5dr_match_misc3 *misc3;
 	struct mlx5dr_ste_build *sb;
-	u8 *num_of_builders;
 	bool inner, rx;
 	int idx =3D 0;
 	int ret, i;
=20
-	if (ipv6) {
-		sb =3D nic_matcher->ste_builder6;
-		num_of_builders =3D &nic_matcher->num_of_builders6;
-	} else {
-		sb =3D nic_matcher->ste_builder4;
-		num_of_builders =3D &nic_matcher->num_of_builders4;
-	}
-
+	sb =3D nic_matcher->ste_builder_arr[outer_ipv][inner_ipv];
 	rx =3D nic_dmn->ste_type =3D=3D MLX5DR_STE_TYPE_RX;
=20
 	/* Create a temporary mask to track and clear used mask fields */
@@ -249,7 +240,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		if (DR_MASK_IS_L2_DST(mask.outer, mask.misc, outer))
 			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
=20
-		if (ipv6) {
+		if (outer_ipv =3D=3D DR_RULE_IPV6) {
 			if (dr_mask_is_dst_addr_set(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
 								 inner, rx);
@@ -325,7 +316,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		if (DR_MASK_IS_L2_DST(mask.inner, mask.misc, inner))
 			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
=20
-		if (ipv6) {
+		if (inner_ipv =3D=3D DR_RULE_IPV6) {
 			if (dr_mask_is_dst_addr_set(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
 								 inner, rx);
@@ -373,7 +364,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		}
 	}
=20
-	*num_of_builders =3D idx;
+	nic_matcher->ste_builder =3D sb;
+	nic_matcher->num_of_builders_arr[outer_ipv][inner_ipv] =3D idx;
=20
 	return 0;
 }
@@ -524,24 +516,33 @@ static void dr_matcher_uninit(struct mlx5dr_matcher *=
matcher)
 	}
 }
=20
-static int dr_matcher_init_nic(struct mlx5dr_matcher *matcher,
-			       struct mlx5dr_matcher_rx_tx *nic_matcher)
+static int dr_matcher_set_all_ste_builders(struct mlx5dr_matcher *matcher,
+					   struct mlx5dr_matcher_rx_tx *nic_matcher)
 {
 	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
-	int ret, ret_v4, ret_v6;
=20
-	ret_v4 =3D dr_matcher_set_ste_builders(matcher, nic_matcher, false);
-	ret_v6 =3D dr_matcher_set_ste_builders(matcher, nic_matcher, true);
+	dr_matcher_set_ste_builders(matcher, nic_matcher, DR_RULE_IPV4, DR_RULE_I=
PV4);
+	dr_matcher_set_ste_builders(matcher, nic_matcher, DR_RULE_IPV4, DR_RULE_I=
PV6);
+	dr_matcher_set_ste_builders(matcher, nic_matcher, DR_RULE_IPV6, DR_RULE_I=
PV4);
+	dr_matcher_set_ste_builders(matcher, nic_matcher, DR_RULE_IPV6, DR_RULE_I=
PV6);
=20
-	if (ret_v4 && ret_v6) {
+	if (!nic_matcher->ste_builder) {
 		mlx5dr_dbg(dmn, "Cannot generate IPv4 or IPv6 rules with given mask\n");
 		return -EINVAL;
 	}
=20
-	if (!ret_v4)
-		nic_matcher->ste_builder =3D nic_matcher->ste_builder4;
-	else
-		nic_matcher->ste_builder =3D nic_matcher->ste_builder6;
+	return 0;
+}
+
+static int dr_matcher_init_nic(struct mlx5dr_matcher *matcher,
+			       struct mlx5dr_matcher_rx_tx *nic_matcher)
+{
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	int ret;
+
+	ret =3D dr_matcher_set_all_ste_builders(matcher, nic_matcher);
+	if (ret)
+		return ret;
=20
 	nic_matcher->e_anchor =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
 						      DR_CHUNK_SIZE_1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index e8b656075c6f..90c79a133692 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -954,12 +954,12 @@ static int dr_rule_destroy_rule(struct mlx5dr_rule *r=
ule)
 	return 0;
 }
=20
-static bool dr_rule_is_ipv6(struct mlx5dr_match_param *param)
+static enum mlx5dr_ipv dr_rule_get_ipv(struct mlx5dr_match_spec *spec)
 {
-	return (param->outer.ip_version =3D=3D 6 ||
-		param->inner.ip_version =3D=3D 6 ||
-		param->outer.ethertype =3D=3D ETH_P_IPV6 ||
-		param->inner.ethertype =3D=3D ETH_P_IPV6);
+	if (spec->ip_version =3D=3D 6 || spec->ethertype =3D=3D ETH_P_IPV6)
+		return DR_RULE_IPV6;
+
+	return DR_RULE_IPV4;
 }
=20
 static bool dr_rule_skip(enum mlx5dr_domain_type domain,
@@ -1023,7 +1023,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
=20
 	ret =3D mlx5dr_matcher_select_builders(matcher,
 					     nic_matcher,
-					     dr_rule_is_ipv6(param));
+					     dr_rule_get_ipv(&param->outer),
+					     dr_rule_get_ipv(&param->inner));
 	if (ret)
 		goto out_err;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index d6d9bc5f4adf..c1f45a60ee6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -106,6 +106,12 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_MAX,
 };
=20
+enum mlx5dr_ipv {
+	DR_RULE_IPV4,
+	DR_RULE_IPV6,
+	DR_RULE_IPV_MAX,
+};
+
 struct mlx5dr_icm_pool;
 struct mlx5dr_icm_chunk;
 struct mlx5dr_icm_bucket;
@@ -679,11 +685,11 @@ struct mlx5dr_matcher_rx_tx {
 	struct mlx5dr_ste_htbl *s_htbl;
 	struct mlx5dr_ste_htbl *e_anchor;
 	struct mlx5dr_ste_build *ste_builder;
-	struct mlx5dr_ste_build ste_builder4[DR_RULE_MAX_STES];
-	struct mlx5dr_ste_build ste_builder6[DR_RULE_MAX_STES];
+	struct mlx5dr_ste_build ste_builder_arr[DR_RULE_IPV_MAX]
+					       [DR_RULE_IPV_MAX]
+					       [DR_RULE_MAX_STES];
 	u8 num_of_builders;
-	u8 num_of_builders4;
-	u8 num_of_builders6;
+	u8 num_of_builders_arr[DR_RULE_IPV_MAX][DR_RULE_IPV_MAX];
 	u64 default_icm_addr;
 	struct mlx5dr_table_rx_tx *nic_tbl;
 };
@@ -812,7 +818,8 @@ mlx5dr_matcher_supp_flex_parser_icmp_v6(struct mlx5dr_c=
md_caps *caps)
=20
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
-				   bool ipv6);
+				   enum mlx5dr_ipv outer_ipv,
+				   enum mlx5dr_ipv inner_ipv);
=20
 static inline u32
 mlx5dr_icm_pool_chunk_size_to_entries(enum mlx5dr_icm_chunk_size chunk_siz=
e)
--=20
2.21.0

