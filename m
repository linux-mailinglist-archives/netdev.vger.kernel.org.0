Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACF1148F3F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404219AbgAXUVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:04 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387568AbgAXUVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWPeT27j1nfDjugterJQON7DMysl8ThI7N02uH+xmN1BhFIjKJRR8d9txruJHAO+ug8U5EzI+FKmxL9Y3oA2REnjoOoO+EYkDzCiognc/4Xug2L6j40W2dzAiX2BCq1pJTFWys3ERTGw1Qr/1N9ZB+oYKqAxxyi5C+vmXVQZIcPeOob4fsWgJ83t/2lLf6OsU83Uggx5KFLIHZ0y5mWbzF1/vE+x8qJxKpx9V30E71nLeiCdB1L4Y+/87xlOoBmugXtMoe9N1kkic39D5tWbSXnL9NSMOpltOb5GxCau+t6i3YY7EOE1RQ3r3bRaRnY4AHKvmAu4fTykUD9CWtl+Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/H44KJ+XG0w8FeGPGUC6IHZ8cbbJnDaPvyGTMo5joI=;
 b=VkdwXR5Bu9mrIX7OVQfz8iClQvHFuM6s66c9hCiY6+Fi6YuTQMqocx0cb1gXr0gFGnwDwl/N596daWVDoxblw/h7f6mJQ7ReD3whbLiHlbw7tYMhcP4woddECHwKJL4RDP2GrOjSYdjkVjUthFPbPzg3sG/2X/IfBZtvCwZa9Yz+UhQ9EnLzjvJWg1BPzcOjxS8eA7KmSqD44VtPK/IfPocDhxRbnPOhnlJU6m1e90A7taAipZJaPLDzOjfXoOr+xq5tsjOYBe4xQUm3DJR6c4/thlLYLULNsxtif2wpujlNHFZRUMx0pBt1vccZqzrFJ8bu/ZiZCzJI+gicAo6ubA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/H44KJ+XG0w8FeGPGUC6IHZ8cbbJnDaPvyGTMo5joI=;
 b=ohp+YqT1zjm9nSuN1JAU1YcCzaPFLT50crlC9x/hVgbEYXhIjyFhu9qGSfXSZa4P5pUPLcE7I5xUJBOpcOsKDG0YAubrW1Z+rqX3X3YboHw/zORyzhhUsnpw+d8DCxEsUeDWlFJaHzqheT8a/7njAVBdmmjs26CbgOjfxl4lD6o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:55 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/9] net/mlx5: DR, Enable counter on non-fwd-dest objects
Thread-Topic: [net 3/9] net/mlx5: DR, Enable counter on non-fwd-dest objects
Thread-Index: AQHV0vPIZLR3BlL2R0+f5Me5ZrY82w==
Date:   Fri, 24 Jan 2020 20:20:55 +0000
Message-ID: <20200124202033.13421-4-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70759ec8-43d7-417e-96f6-08d7a10aeaa3
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB55523CF2ACA3D995A1382825BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7aJJ4fppm3TIWCZoi8LxX/Y3z5j4Cf6oB5ukUGVAtqZF9pVfuO5SySC1bTV5YwqbMyDP1xMh6i3KqrZFyVxZ176+NFkV+XMcnTZHgvO9H48sUQ7veqb/yKgL7R9/qM7udsKwdLvTWlVy3elpRB2Mhs9Jr1rjIM7XnfSkkY7bMbL+URwXzKfljObHpOP2yi1xss6vpFacBo1hjG6e5GzmfEdW4a8g7Iog+M1C+t2GijrXGUISW590rn6rOgZY1Lxk+EqUumtRfXdS1f74McGXfkFD/1S0o2i65eYw2TvF23iZYafgKnoDR+uoPQo7fSFbXBlj8kjXVpjisKYNJ0KA9ZtSJNAODzKgx10tXSAAv+0APGHN66/2z1XAeb4AVM4bJls7cKcCcy3ilKlhTNhB1I/K6vLd7DqM3vmbY3oGAMylMTCUBPjgp0XNQVwrxB2gUP0aG2F+oooHCptqF2dJFm1nPmE7OsFejXKd+CQWGFL2VRCz7YpwsljTDuAl92bycsznnc2kOYVC/UQADT4yBlei71H62LsqqtSxjYg0aQE=
x-ms-exchange-antispam-messagedata: zy5pMdHQKckAPKrVOXV0YJfJQNpNqfvmqA5p5D5m+5LoIcp1gGhd2bFOqxnYK4Z3dm464wN73ZXhGtUCe+DbkqW10VkSjPEHPoNSp/3oZxOd+5Wn1HnIEKUA14lsExLcasPUo3XB5DBV2bDWlUAaXw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70759ec8-43d7-417e-96f6-08d7a10aeaa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:55.6667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5cofGc0HiGv8P7Hq9OhdZcMlaAp0MwJYQzGVdBxMlRCbwXBiZ3xZ3UkK7a9xnvDCcyWeSl2Ssj6D48V5+1XMuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

The current code handles only counters that attached to dest, we still
have the cases where we have counter on non-dest, like over drop etc.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 42 +++++++++++++------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 3d587d0bdbbe..1e32e2443f73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -352,26 +352,16 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_ro=
ot_namespace *ns,
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		list_for_each_entry(dst, &fte->node.children, node.list) {
 			enum mlx5_flow_destination_type type =3D dst->dest_attr.type;
-			u32 id;
=20
 			if (num_actions =3D=3D MLX5_FLOW_CONTEXT_ACTION_MAX) {
 				err =3D -ENOSPC;
 				goto free_actions;
 			}
=20
-			switch (type) {
-			case MLX5_FLOW_DESTINATION_TYPE_COUNTER:
-				id =3D dst->dest_attr.counter_id;
+			if (type =3D=3D MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
=20
-				tmp_action =3D
-					mlx5dr_action_create_flow_counter(id);
-				if (!tmp_action) {
-					err =3D -ENOMEM;
-					goto free_actions;
-				}
-				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
-				actions[num_actions++] =3D tmp_action;
-				break;
+			switch (type) {
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				tmp_action =3D create_ft_action(dev, dst);
 				if (!tmp_action) {
@@ -397,6 +387,32 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_roo=
t_namespace *ns,
 		}
 	}
=20
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		list_for_each_entry(dst, &fte->node.children, node.list) {
+			u32 id;
+
+			if (dst->dest_attr.type !=3D
+			    MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
+
+			if (num_actions =3D=3D MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err =3D -ENOSPC;
+				goto free_actions;
+			}
+
+			id =3D dst->dest_attr.counter_id;
+			tmp_action =3D
+				mlx5dr_action_create_flow_counter(id);
+			if (!tmp_action) {
+				err =3D -ENOMEM;
+				goto free_actions;
+			}
+
+			fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+			actions[num_actions++] =3D tmp_action;
+		}
+	}
+
 	params.match_sz =3D match_sz;
 	params.match_buf =3D (u64 *)fte->val;
=20
--=20
2.24.1

