Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA546146209
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgAWGjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:51 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgAWGju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHvDihTIRkMA2q5RrFSVs21z4CWDXYwfdrZU8OiY6Cv+N4v9gmd2yQHYtyzxgiMv+eV6dpxE56Qwsc2qs7UkQUrcfRi6bx/Qn3qe9F92ufUxJZStPw8acE5kLUdNpwnWRMAIdyoX3k9j2UNV7tblyrXzcqtbu9NdO8fHVOq6Zjx888xLb4IaZ+e3xE+2bwUWd9lsAo/Ka5p/BZUSMtg3pJ0T4ULlH0Ao7/hzyFNKo8gddBhX6SCbnTwpvaC0q+ZR4gGRLb9EhTzk/YNW3XJ8HqD7eN0OUVeFl86Q49cGw3gcxBXpHkfCLJPDIvfXzAp7qnlw8sMBvpz9kqgZH4G4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju/xmlCSoV/8l0WJuFGv/oFU6XmW4UDtspoonseRx0A=;
 b=Nj/P8tkL5uYkf1chxEkM22Bwn60VggJDcR8DPJOyQ1oFR29pqWKj9sA8htnGlRTwDl1Crb7ox5mxoRum2NewRe+IrzMJ8ZO0VH9LDVOK5A9LCHiIv1mIMKE5XPS1mBKI/UBEbws9YF2VxshWZ+0s4UAJ6PRrAM22TAr1WxpV2oHxz/7ZZ3eWR9eiQff0pjX8HIdBdO6+9/NAslFp7M4D5nMibpbhnvU5FcEqzYpvUHiXHrk5VLT/s8Vd8qC5jwMlLMxLBnO/BJPnroBlO13tE3wBmVnpGBZ73Vrx2YEL4MkDWz8w81bCOKqI97K98VuydqfDP30O1RLoPfzBbEbrDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju/xmlCSoV/8l0WJuFGv/oFU6XmW4UDtspoonseRx0A=;
 b=mx0AVmMcgkXcDmgCuz8btP4fqFDInoONW+vV/uTAwZQtIuHaxWOx+m7f8DhdyWLoba/0kFZ5SBzGrJiLQzJlWm/Lc0ejiMDMLtLnCrD7NB9QQzFv/7t5sZqKJ6eKUXSKGYIWGj9ouyoOUB5GSHNZ5GfYf/boOnnht+81iOwiemI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:43 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5e: Add mlx5e_flower_parse_meta support
Thread-Topic: [net-next 04/15] net/mlx5e: Add mlx5e_flower_parse_meta support
Thread-Index: AQHV0bflNS2WspMU2E2e7DBEJV8oRQ==
Date:   Thu, 23 Jan 2020 06:39:43 +0000
Message-ID: <20200123063827.685230-5-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d35e4128-8110-4e22-4230-08d79fcf0787
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941393DDBA6B20B35F13196BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFXlePUPhHbXihvuiONZDxIQcPmdpzve97ucvtGTLAR5mpsL9BNYAPjme3oY4DvqYxAAih4/Pr8wEVdgrWPhplHRZgzSecONd6TWqIblJlBoOe6Q3u6Yo1iWqVfHGKBmT2+mtFZXgznN/Ze3sUAIaK50W5C8T4e6hpvKXpw6gm5KuMedlsawh5qqA0/mKBuBJ97O4Jw8x/BCOGhxOYzz0Ts7niIaD7aPwG9GSzKeLRrrSmWTsBbEgtXZtsO/KsPmuzohOakixd5ibY1T0BTweCqvbi2wMvtQCg5eqeYpP47rj0fvBYoD1O9V3ky62phjM22O5fjXgPVkDGAw/4UbX+A7UoW7eEUDM/3+nikO0XOZybOrJwPoXL6+FSMyNFzs9syPQ6J6mXZw3rCj+UsTW+ePFNGMV1ezlXtV9VQqLtNBLcp4AMyYcXzGg25sd3T4fK/Bxf7z3ujwojHa8M1pheKjmzhgEFSuzj2yYxFe/CjEKG7SEctwlYjzI0TEVF3mcHnhVAiHUTSEb2cAp0K1rGsqkkn6jIwV0HPU7fXwKmY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35e4128-8110-4e22-4230-08d79fcf0787
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:43.2524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8gzaMXdS34UU2LRvRpUKy11ws6od3sVGiSB5EDrJQJ1yJY0ZUT/xIibh8JIWsAhxrFmbeegHS1a8NNfX5DO5IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the flowtables offload all the devices in the flowtables
share the same flow_block. An offload rule will be installed on
all the devices. This scenario is not correct.

It is no problem if there are only two devices in the flowtable,
The rule with ingress and egress on the same device can be reject
by driver.

But more than two devices in the flowtable will install the wrong
rules on hardware.

For example:
Three devices in a offload flowtables: dev_a, dev_b, dev_c

A rule ingress from dev_a and egress to dev_b:
The rule will install on device dev_a.
The rule will try to install on dev_b but failed for ingress
and egress on the same device.
The rule will install on dev_c. This is not correct.

The flowtables offload avoid this case through restricting the ingress dev
with FLOW_DISSECTOR_KEY_META.

So the mlx5e driver also should support the FLOW_DISSECTOR_KEY_META parse.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Acked-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 26f559b453dc..4f184c770a45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1810,6 +1810,40 @@ static void *get_match_headers_value(u32 flags,
 			     outer_headers);
 }
=20
+static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
+				   struct flow_cls_offload *f)
+{
+	struct flow_rule *rule =3D flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack =3D f->common.extack;
+	struct net_device *ingress_dev;
+	struct flow_match_meta match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
+		return 0;
+
+	flow_rule_match_meta(rule, &match);
+	if (match.mask->ingress_ifindex !=3D 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
+		return -EINVAL;
+	}
+
+	ingress_dev =3D __dev_get_by_index(dev_net(filter_dev),
+					 match.key->ingress_ifindex);
+	if (!ingress_dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't find the ingress port to match on");
+		return -EINVAL;
+	}
+
+	if (ingress_dev !=3D filter_dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't match on the ingress filter port");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __parse_cls_flower(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
 			      struct flow_cls_offload *f,
@@ -1830,6 +1864,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv=
,
 	u16 addr_type =3D 0;
 	u8 ip_proto =3D 0;
 	u8 *match_level;
+	int err;
=20
 	match_level =3D outer_match_level;
=20
@@ -1873,6 +1908,10 @@ static int __parse_cls_flower(struct mlx5e_priv *pri=
v,
 						    spec);
 	}
=20
+	err =3D mlx5e_flower_parse_meta(filter_dev, f);
+	if (err)
+		return err;
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
=20
--=20
2.24.1

