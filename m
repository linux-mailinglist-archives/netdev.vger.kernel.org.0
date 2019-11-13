Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7793FBBCA
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKMWlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:51 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMWlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gp7974udnoy0Ayz+1WfvEWYX6eetAaWp20gQdsBgJ93mHSeK60ls1gJhw8nuxCN5YkmsyqClTA0nw1xIpVk+XJxK+HYyu5aVmWdCwqQrWpELVX98TK5ORAUNkgre7xWw+1iM6Zti3aP1enTcjKAz6uvXoaCXf8BvcWnt08RabvoQSWZ3me8Z2BW1mtgZjl/8KD/TgIKjKtUIyuSFBjYZyMkKeypofCWRG7MRtVNgKKTke9FtmQPeKFQkjyz3SMrwPWsOESGrdjSf2weuh8aFRqM5BbxoTHsIFDw987bfs2+1lYY9FzClsRCPS3OWj/R3XOyeoQ447id+RbPd2lP9Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpGtpbPSExLqnwMGGUjed/kDvWAoC+PSk30xTrP6M1Y=;
 b=N4SgQlkFSfs4TU+GFFnu2dvtn3wbpt231L3JbrO4kSEPSfPKAKcACCBvZf2jR7aP181ite3e4vCySWb5Fmi5ZP+vtzikzBckyA7oqxhakRKW5I8FJpY4ebu1Zm0TbKFsEzn3FsmTUX6SDZYrcJ0DfuTV2X8QrN7GYKFl4m+u0UdY5bJ5m8AIdIdmAWPzUWc9YAwszmsM+Whz6oH1qTh15gbvzA8IMHE8PmOgGmjQ2Xoip0LGHZTwlP8qz8lgiAG5K3SDGWp2SkKL3PILcqvyRgP8U+Cmiz3TINXK5QZCkze9JckZNKoFHz9YgKs3IUowdnHoMDO6y+Ph46HBHtN79A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpGtpbPSExLqnwMGGUjed/kDvWAoC+PSk30xTrP6M1Y=;
 b=kcyQUS0VxBs6GUgWI7sxcTxqI3JpjqaNW20QZlVoCQvtNDkDD5TEgHfiovFixBRxwTmi1VVNpMUGksU9pQ4bll95IY8LRH0ImQyK3bi3f6LSw45UwsW4Xbbt93SRi8i6INSxJHu62c6XjKHfESVzePrHH6lepdjLVnFq5tr4Wlw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 7/7] net/mlx5: TC: Offload flow table rules
Thread-Topic: [net-next V2 7/7] net/mlx5: TC: Offload flow table rules
Thread-Index: AQHVmnOGzle3hs5xrkiq6yjIc7h7nQ==
Date:   Wed, 13 Nov 2019 22:41:44 +0000
Message-ID: <20191113224059.19051-8-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64e8aa22-5e4e-48a0-5fc5-08d7688aa8e4
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135E4952614FF19A54084CCBE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(14444005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: geoWxxbrMQEtvjGzqW8/0XIChdZGnFVo2oLgjaGR8PETIPAECELmMPPWRyHSn9IsJWyUL9e4Wd2jflxcfpeEwldZk2kr48jPZTEv/F5KpHtuIS9nhGcwf8JOl6lthb8MEG7veVm3ix+RPqqWyOGASduaHaMAnoEc+hb1gdpY8OnH5/VrvWDF8F+mqFNuT+Sg2tZQLlHnzkBvutF4mv0EmCKI9ys4jr1F/EU1n3uuJ1ZZRU24jTG+6SXKd9aKpQodiD8z5D4X9dcuRHAK2iJMd4Hcxetuvs0nzBORoqR1NggaltAm7mxhH/kEhP6MVczRXOGH3oNqsYKGlLIUxvvC3c7Z4kE9Yl95U7M6tKXFf43OhpKI+QpWGk9ibOs1eHVQYhQSia3T11+DO/Roq8mIVsy2FppoNCig12Yg9KqvPHhoZQiRnhLHKcKTkUDlz+d8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e8aa22-5e4e-48a0-5fc5-08d7688aa8e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:44.8226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7HtuejdK/0OtkUcUjS3L9ybYWim2gTSYjY5JYzGdZjP6WZnl9RCH+DbsEUKv7luyIgAHzi1H4u9AJn9UNzGK/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Since both tc rules and flow table rules are of the same format,
we can re-use tc parsing for that, and move the flow table rules
to their steering domain - In this case, the next chain after
max tc chain.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 45 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 28 +++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  3 +-
 3 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index c7f98f1fd9b1..f175cb24bb67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1244,21 +1244,60 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type=
 type, void *type_data,
 	}
 }
=20
-static LIST_HEAD(mlx5e_rep_block_cb_list);
+static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
+				 void *cb_priv)
+{
+	struct flow_cls_offload *f =3D type_data;
+	struct flow_cls_offload cls_flower;
+	struct mlx5e_priv *priv =3D cb_priv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	flags =3D MLX5_TC_FLAG(INGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+	esw =3D priv->mdev->priv.eswitch;
=20
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
+			return -EOPNOTSUPP;
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 */
+		memcpy(&cls_flower, f, sizeof(*f));
+		cls_flower.common.chain_index =3D FDB_FT_CHAIN;
+		err =3D mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
+		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(mlx5e_rep_block_tc_cb_list);
+static LIST_HEAD(mlx5e_rep_block_ft_cb_list);
 static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type t=
ype,
 			      void *type_data)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
 	struct flow_block_offload *f =3D type_data;
=20
+	f->unlocked_driver_cb =3D true;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		f->unlocked_driver_cb =3D true;
 		return flow_block_cb_setup_simple(type_data,
-						  &mlx5e_rep_block_cb_list,
+						  &mlx5e_rep_block_tc_cb_list,
 						  mlx5e_rep_setup_tc_cb,
 						  priv, priv, true);
+	case TC_SETUP_FT:
+		return flow_block_cb_setup_simple(type_data,
+						  &mlx5e_rep_block_ft_cb_list,
+						  mlx5e_rep_setup_ft_cb,
+						  priv, priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 0c1022cda128..3a707d788022 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -74,6 +74,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_INGRESS	=3D MLX5E_TC_FLAG_INGRESS_BIT,
 	MLX5E_TC_FLOW_FLAG_EGRESS	=3D MLX5E_TC_FLAG_EGRESS_BIT,
 	MLX5E_TC_FLOW_FLAG_ESWITCH	=3D MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_FT		=3D MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
 	MLX5E_TC_FLOW_FLAG_NIC		=3D MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
 	MLX5E_TC_FLOW_FLAG_OFFLOADED	=3D MLX5E_TC_FLOW_BASE,
 	MLX5E_TC_FLOW_FLAG_HAIRPIN	=3D MLX5E_TC_FLOW_BASE + 1,
@@ -276,6 +277,11 @@ static bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow=
 *flow)
 	return flow_flag_test(flow, ESWITCH);
 }
=20
+static bool mlx5e_is_ft_flow(struct mlx5e_tc_flow *flow)
+{
+	return flow_flag_test(flow, FT);
+}
+
 static bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
 {
 	return flow_flag_test(flow, OFFLOADED);
@@ -1168,7 +1174,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
=20
-	if (attr->chain > max_chain) {
+	/* We check chain range only for tc flows.
+	 * For ft flows, we checked attr->chain was originally 0 and set it to
+	 * FDB_FT_CHAIN which is outside tc range.
+	 * See mlx5e_rep_setup_ft_cb().
+	 */
+	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
 		NL_SET_ERR_MSG(extack, "Requested chain is out of supported range");
 		return -EOPNOTSUPP;
 	}
@@ -3217,6 +3228,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *pr=
iv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr =3D attr->parse_attr;
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	const struct ip_tunnel_info *info =3D NULL;
+	bool ft_flow =3D mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
 	bool encap =3D false;
 	u32 action =3D 0;
@@ -3261,6 +3273,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
 				return -EINVAL;
 			}
=20
+			if (ft_flow && out_dev =3D=3D priv->netdev) {
+				/* Ignore forward to self rules generated
+				 * by adding both mlx5 devs to the flow table
+				 * block on a normal nft offload setup.
+				 */
+				return -EOPNOTSUPP;
+			}
+
 			if (attr->out_count >=3D MLX5_MAX_FLOW_FWD_VPORTS) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "can't support more output ports, can't offload forwarding");
@@ -3385,6 +3405,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
 			u32 dest_chain =3D act->chain_index;
 			u32 max_chain =3D mlx5_eswitch_get_chain_range(esw);
=20
+			if (ft_flow) {
+				NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
+				return -EOPNOTSUPP;
+			}
 			if (dest_chain <=3D attr->chain) {
 				NL_SET_ERR_MSG(extack, "Goto earlier chain isn't supported");
 				return -EOPNOTSUPP;
@@ -3475,6 +3499,8 @@ static void get_flags(int flags, unsigned long *flow_=
flags)
 		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
 	if (flags & MLX5_TC_FLAG(NIC_OFFLOAD))
 		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_NIC);
+	if (flags & MLX5_TC_FLAG(FT_OFFLOAD))
+		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_FT);
=20
 	*flow_flags =3D __flow_flags;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index 924c6ef86a14..262cdb7b69b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -44,7 +44,8 @@ enum {
 	MLX5E_TC_FLAG_EGRESS_BIT,
 	MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
 	MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
-	MLX5E_TC_FLAG_LAST_EXPORTED_BIT =3D MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_LAST_EXPORTED_BIT =3D MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
 };
=20
 #define MLX5_TC_FLAG(flag) BIT(MLX5E_TC_FLAG_##flag##_BIT)
--=20
2.21.0

