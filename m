Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687EABC510
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504350AbfIXJmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:12 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:10630
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504331AbfIXJmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjIlBqK2zq0CbrWeYlWKKz30EBSuIT4RVQiUWmwmmE4l31934zUPWk9tMw7SVJTKsD8zaJIVAx0Iqt7JF8A0uhwKLxoj9DPNZTKQBFIR98QNRleqn9T4WGVoncdfyd0k7fEsAskdOsHPTAt1pSzdKdX4NxFIK85Ukm+FmhsWbRujnURLgJsGJ+xWqW0kzYcCptVSrImPDq97t4nXY4d5gHKCRa7Ruw3H+z6PZdW26nRn7BV1kqaGumP3lFUpgtmJw3Z0HTGqpJgxvHUoGZU4JRK132gs0TsHj6oWLSmYLiYA/vL4m/8Ri70SejyWJccZ0bhsTGTD4x15KNEX6jZiyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C84nLgYvtwWljn/0KCanOKg6QoOgfY0iMYU5rGp+kOg=;
 b=SeM3fkqWcXg1epiHCLNtp1zRE5Q6B4F61bUCFqFnkom1LMi66KvvSI357UQijYvyEsU/owgW3KaSbzOIUP3LdLm4mU52cOE38WVBGAcOdK7MlOWzzqIpIkeMSe/ISo27ABCUPlCHk5c1RPX/l6xX6Rcr/eZf735Ka7zshIwOh/QrkxRMgZLJmias8Xgu9DMu8iLCit+iF2r6PLJWAGj+LaI1uDbRmp//zTOSJF1Jca6wLvYv1A3zwygeTnAWW4STzwfcyURQtpevr/VOnWq0V/yLyeNPGXCD6gEWQ5liBVYw65njMNPOGLZJtpwmtv69AL7PUozaQVDQ0EYKDZHEXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C84nLgYvtwWljn/0KCanOKg6QoOgfY0iMYU5rGp+kOg=;
 b=mmIkGbLxEVf8VqE8xTcWKIXgTc3vOSQNlPFW0Vr9+sYGLkzZ/n4He4006QsX76zOaa8NfKJxwsZp3sDIRFA0fgoAJ0Nil95mUAqXFkucVK8hXL+lKlimQS+BmFrMPU99LXB5NZK9PeBqohOumDrMMTEs/EsYSvgDfp06Uv2S3QI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:34 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alaa Hleihel <alaa@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/7] net/mlx5: DR, Allow matching on vport based on vhca_id
Thread-Topic: [net 4/7] net/mlx5: DR, Allow matching on vport based on vhca_id
Thread-Index: AQHVcrxAivoGkBXGoE+aoUiAp37UaA==
Date:   Tue, 24 Sep 2019 09:41:34 +0000
Message-ID: <20190924094047.15915-5-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 576a7abb-cda7-4695-c01d-08d740d362ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2671D8E02A2F4A9D670CF1F8BE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kM/zKwdQptIOL2dnv3nnNM2M4v74f87dxwX9/yQolTxqxaHwMHf3lAmLlEOY3ZAr7WF4iTn2HE2korZAb9oV4EuOV2oKTw5+4I66crCYCWtZArYceLvtOIxElOS1jKGWkeWDj98083Cg/XcR7dNmfZKWg2ZBCHOj193qhtg5G5Whsu5AigFmMjo325QASCRxU8ORHseHZrujigF5QiUsFuECVUIynCLbulhN/Pkgj5GePqzWBaetuc7UUx+KmkA85c4Ta1n2MY8CieKy5Srt8JNQSmbfWIbPe2yD0d5pMmxhuyaoQnnqA0PNgQgxG8jQI8573iypzfbPRKUFdhXPeHTB+WEcIBx+8WaSJfA6JC6mHc8Afsuwrr2pCNHkaKFnXTobYy6tWJsTGrPh00khOxPH9RicNwsFOi5N3t+vihY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576a7abb-cda7-4695-c01d-08d740d362ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:34.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 366FAm9WQaQsxucE54GRL94dC94lAB5D89AbL6hE0ByJAeNg1KiAZxUL+BxsddolNJpSPGXxiy+xWbKbFrx3/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

In case source_eswitch_owner_vhca_id is given as a match,
the source_vport (vhca_id) will be set in case vhca_id_valid.

This will allow matching on peer vports, vports that belong
to the other pf.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  3 +-
 .../mellanox/mlx5/core/steering/dr_ste.c      | 36 ++++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_types.h    |  6 ++--
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 9c2c25356dd0..67dea7698fc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -230,8 +230,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_ma=
tcher *matcher,
 		    (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
 		     dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX)) {
 			ret =3D mlx5dr_ste_build_src_gvmi_qpn(&sb[idx++], &mask,
-							    &dmn->info.caps,
-							    inner, rx);
+							    dmn, inner, rx);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 95b7221f5730..4efe1b0be4a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -837,6 +837,8 @@ static void dr_ste_copy_mask_misc(char *mask, struct ml=
x5dr_match_misc *spec)
 	spec->source_sqn =3D MLX5_GET(fte_match_set_misc, mask, source_sqn);
=20
 	spec->source_port =3D MLX5_GET(fte_match_set_misc, mask, source_port);
+	spec->source_eswitch_owner_vhca_id =3D MLX5_GET(fte_match_set_misc, mask,
+						      source_eswitch_owner_vhca_id);
=20
 	spec->outer_second_prio =3D MLX5_GET(fte_match_set_misc, mask, outer_seco=
nd_prio);
 	spec->outer_second_cfi =3D MLX5_GET(fte_match_set_misc, mask, outer_secon=
d_cfi);
@@ -2250,11 +2252,18 @@ static int dr_ste_build_src_gvmi_qpn_bit_mask(struc=
t mlx5dr_match_param *value,
 {
 	struct mlx5dr_match_misc *misc_mask =3D &value->misc;
=20
-	if (misc_mask->source_port !=3D 0xffff)
+	/* Partial misc source_port is not supported */
+	if (misc_mask->source_port && misc_mask->source_port !=3D 0xffff)
+		return -EINVAL;
+
+	/* Partial misc source_eswitch_owner_vhca_id is not supported */
+	if (misc_mask->source_eswitch_owner_vhca_id &&
+	    misc_mask->source_eswitch_owner_vhca_id !=3D 0xffff)
 		return -EINVAL;
=20
 	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_por=
t);
 	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
+	misc_mask->source_eswitch_owner_vhca_id =3D 0;
=20
 	return 0;
 }
@@ -2266,17 +2275,33 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx=
5dr_match_param *value,
 	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
 	struct mlx5dr_match_misc *misc =3D &value->misc;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
+	struct mlx5dr_domain *dmn =3D sb->dmn;
+	struct mlx5dr_cmd_caps *caps;
 	u8 *tag =3D hw_ste->tag;
=20
 	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
=20
-	vport_cap =3D mlx5dr_get_vport_cap(sb->caps, misc->source_port);
+	if (sb->vhca_id_valid) {
+		/* Find port GVMI based on the eswitch_owner_vhca_id */
+		if (misc->source_eswitch_owner_vhca_id =3D=3D dmn->info.caps.gvmi)
+			caps =3D &dmn->info.caps;
+		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id =3D=3D
+					   dmn->peer_dmn->info.caps.gvmi))
+			caps =3D &dmn->peer_dmn->info.caps;
+		else
+			return -EINVAL;
+	} else {
+		caps =3D &dmn->info.caps;
+	}
+
+	vport_cap =3D mlx5dr_get_vport_cap(caps, misc->source_port);
 	if (!vport_cap)
 		return -EINVAL;
=20
 	if (vport_cap->vport_gvmi)
 		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
=20
+	misc->source_eswitch_owner_vhca_id =3D 0;
 	misc->source_port =3D 0;
=20
 	return 0;
@@ -2284,17 +2309,20 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx=
5dr_match_param *value,
=20
 int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
-				  struct mlx5dr_cmd_caps *caps,
+				  struct mlx5dr_domain *dmn,
 				  bool inner, bool rx)
 {
 	int ret;
=20
+	/* Set vhca_id_valid before we reset source_eswitch_owner_vhca_id */
+	sb->vhca_id_valid =3D mask->misc.source_eswitch_owner_vhca_id;
+
 	ret =3D dr_ste_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
 	if (ret)
 		return ret;
=20
 	sb->rx =3D rx;
-	sb->caps =3D caps;
+	sb->dmn =3D dmn;
 	sb->inner =3D inner;
 	sb->lu_type =3D MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
 	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 78f899fb3305..1cb3769d4e3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -180,6 +180,8 @@ void mlx5dr_send_fill_and_append_ste_send_info(struct m=
lx5dr_ste *ste, u16 size,
 struct mlx5dr_ste_build {
 	u8 inner:1;
 	u8 rx:1;
+	u8 vhca_id_valid:1;
+	struct mlx5dr_domain *dmn;
 	struct mlx5dr_cmd_caps *caps;
 	u8 lu_type;
 	u16 byte_mask;
@@ -331,7 +333,7 @@ void mlx5dr_ste_build_register_1(struct mlx5dr_ste_buil=
d *sb,
 				 bool inner, bool rx);
 int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
-				  struct mlx5dr_cmd_caps *caps,
+				  struct mlx5dr_domain *dmn,
 				  bool inner, bool rx);
 void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool r=
x);
=20
@@ -453,7 +455,7 @@ struct mlx5dr_match_misc {
 	u32 gre_c_present:1;
 	/* Source port.;0xffff determines wire port */
 	u32 source_port:16;
-	u32 reserved_auto2:16;
+	u32 source_eswitch_owner_vhca_id:16;
 	/* VLAN ID of first VLAN tag the inner header of the incoming packet.
 	 * Valid only when inner_second_cvlan_tag =3D=3D1 or inner_second_svlan_t=
ag =3D=3D1
 	 */
--=20
2.21.0

