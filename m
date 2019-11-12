Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D041BF96CC
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfKLROF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:05 -0500
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:25217
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfKLROE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mv8e4Ut9tbL28bX1xmwC6vZgeUGBeHjqu7fhyYZRt9kCxTFzaBDFQgSD1QS66xLz+AGufSUKYIRWIJl+ufhib1eAAJoPEyRQFtd3aHaI92YgUsozuTKwfAUG/dY+qfo8Jvyt1C8o7AgOVItAbfnM+rFnjUMuc2SvdNm+Jc6pWgmLCoCdR7ZVQIGWxLEyuTKsFylMMM7+B6fWV898OL9uW6x9CgmIJztT2iQfpX+VmUCeEcon+UE69TJqer679r3Zbpd2f7O27VE/1bzNK90PgnO+2tPQme14wSxFfJ/OH1q6faLtd5OLfjiqik4HBg8KvsOy1kh3CPH8onoW8tI7sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQvqq51p9LnGBH/aPYR4hOdDtZYuhiVs239fjlhUwiQ=;
 b=Fja3gmkJrZ+Ilau+LKR4n1ib2k8jAtgdIAbRQhRtXYGyuvqHWdprNH9mENycjK3kDTBBjO/SP+GMMa4GOwHuFUrTEAb5wN+256DmTVAOS4KxUQNiMztOP6TQ9MupksK2w1YE0Ov4iis5Z0hnRm5cSh0SDLZ9PEZr5LEGDroKu644JhzaQjVSuJzaptj7MJh1XZvvdIvaZ6SZXyA4bQCvg11iSzy6FhZawuG6bWw8tH9jjL/MoWwWBLmYScTXf7zE3tdwF7AC9Gu1faDorXjCer91vvdIJQ9KV+eNGfaovImqRvslADv9Sq0wf8uyKOnBZeioUE2HJ07m3ujWw+z9sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQvqq51p9LnGBH/aPYR4hOdDtZYuhiVs239fjlhUwiQ=;
 b=TsgvPhPteEfNJUb+SQv2GYElkxi68+N+E/71kBCT7t93rIaasFIA/IBv0tuPBxd+CanE3OVlu85IvwMEuZP3xQ3pGqb2WTgTKJxNmRhA6/HOrpmn2RsZzAUyoOl+0SK7M05C+tUlsjNTOGYJuzviSU/iBuA9kZESHsOPEotoNvY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5695.eurprd05.prod.outlook.com (20.178.120.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 17:13:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Thread-Topic: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Thread-Index: AQHVmXyPyqE/Va6H+0ubcUl9o7Bswg==
Date:   Tue, 12 Nov 2019 17:13:53 +0000
Message-ID: <20191112171313.7049-9-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3fe2ceab-aeef-4190-08e1-08d76793b19d
x-ms-traffictypediagnostic: VI1PR05MB5695:|VI1PR05MB5695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5695D2B2B7D39CCD2A33400DBE770@VI1PR05MB5695.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(256004)(14444005)(66556008)(64756008)(66446008)(2906002)(25786009)(66946007)(66476007)(81156014)(81166006)(8676002)(8936002)(50226002)(3846002)(6116002)(71200400001)(71190400001)(6436002)(36756003)(6486002)(6512007)(54906003)(26005)(316002)(99286004)(1076003)(102836004)(186003)(2616005)(476003)(446003)(386003)(6506007)(4326008)(486006)(11346002)(5660300002)(52116002)(76176011)(107886003)(478600001)(6916009)(66066001)(305945005)(86362001)(7736002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5695;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eiHjnIjzZJipzf/Uisr1dlNs+OYYurYaapLjterh8dFAK1A8/Bk2snOaMwtBKVl1KcykqmNJzxTftcbA3ik3wUZlZiDoxYN9i1vnCZ01VaPabmIv2rWnlnMBh8sJ68bAhtbIPe9KapWRB+wcELNnBcawr8BeBKJUjLIIJTQZ9xOqqVRJZ7LrZ7QG4J8My7oUF4Z2op4SBrpnnPmrQY41A33w3bMBCma0F52moTWamdEAGC+fSYHXB0k/8sNw85dfhGVzimvGS3jgyCGuVIdAP58XY3dSd6zEqHvM3AoNDfEJ3QmrSsIwNLf2BMMWdMOwjoi5OZE7iPOmFWdiWqGOB4naOMBfBIRNnLWBP9Fg1++8mYDez4ZtEa3NkOrz/PYPJq/sEweBqNAHIKDJT67Pvl3CdDBPO1HPc6vzOjH9BYGCeTKiI2AzwhfeZzk/RFf4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe2ceab-aeef-4190-08e1-08d76793b19d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:53.5635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkXweRtOgaMjgAd285n8qilCdvatYNzAWiu/Y9CMetXhLcf2Y5GhuDqE/QvcOpFqGfaqoxjTf0ifRSuS35HpVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5695
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Implementing vf ACL access via tc flower api to allow
admins configure the allowed vlan ids on a vf interface.

To add a vlan id to a vf's ingress/egress ACL table while
in legacy sriov mode, the implementation intercepts tc flows
created on the pf device where the flower matching keys include
the vf's mac address as the src_mac (eswitch ingress) or the
dst_mac (eswitch egress) while the action is accept.

In such cases, the mlx5 driver interpets these flows as adding
a vlan id to the vf's ingress/egress ACL table and updates
the rules in that table using eswitch ACL configuration api
that is introduced in a previous patch.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 139 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  19 +++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 +
 3 files changed, 152 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index bb970b2ebf8a..66b51a3d67c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -68,6 +68,12 @@ struct mlx5_nic_flow_attr {
 	struct mlx5_fc		*counter;
 };
=20
+struct mlx5_vf_acl_flow_attr {
+	u16 acl_vlanid;
+	u16 vport;
+	enum mlx5_acl_flow_direction dir;
+};
+
 #define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
=20
 enum {
@@ -82,6 +88,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_DUP		=3D MLX5E_TC_FLOW_BASE + 4,
 	MLX5E_TC_FLOW_FLAG_NOT_READY	=3D MLX5E_TC_FLOW_BASE + 5,
 	MLX5E_TC_FLOW_FLAG_DELETED	=3D MLX5E_TC_FLOW_BASE + 6,
+	MLX5E_TC_FLOW_FLAG_VF_ACL	=3D MLX5E_TC_FLOW_BASE + 7,
 };
=20
 #define MLX5E_TC_MAX_SPLITS 1
@@ -135,6 +142,7 @@ struct mlx5e_tc_flow {
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
+		struct mlx5_vf_acl_flow_attr acl_attr[0];
 	};
 };
=20
@@ -991,6 +999,15 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
=20
+static void mlx5e_tc_del_vf_acl_flow(struct mlx5e_priv *priv,
+				     struct mlx5e_tc_flow *flow)
+{
+	mlx5_eswitch_del_vport_trunk_vlan(priv->mdev->priv.eswitch,
+					  flow->acl_attr->vport,
+					  flow->acl_attr->acl_vlanid,
+					  flow->acl_attr->dir);
+}
+
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
@@ -1640,6 +1657,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv=
,
 	if (mlx5e_is_eswitch_flow(flow)) {
 		mlx5e_tc_del_fdb_peer_flow(flow);
 		mlx5e_tc_del_fdb_flow(priv, flow);
+	} else if (flow_flag_test(flow, VF_ACL)) {
+		mlx5e_tc_del_vf_acl_flow(priv, flow);
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
 	}
@@ -3718,6 +3737,110 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return err;
 }
=20
+static bool
+parse_vf_acl_flow(struct mlx5_eswitch *esw,
+		  struct flow_cls_offload *f,
+		  struct mlx5_vf_acl_flow_attr *attr)
+{
+	struct flow_rule *rule	 =3D flow_cls_offload_flow_rule(f);
+	struct flow_dissector *dissector =3D rule->match.dissector;
+	struct flow_action *flow_action =3D &rule->action;
+	struct flow_match_eth_addrs match_eth;
+	const struct flow_action_entry *act;
+	struct flow_match_vlan match_vlan;
+	int i;
+
+	if (!esw || esw->mode !=3D MLX5_ESWITCH_LEGACY)
+		return false;
+
+	if (dissector->used_keys ^
+	    (BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	     BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	     BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	     BIT(FLOW_DISSECTOR_KEY_VLAN)))
+		return false;
+
+	/* Allowing only ACCEPT action for acl */
+	if (!flow_action_has_entries(flow_action))
+		return false;
+	flow_action_for_each(i, act, flow_action)
+		if (act->id !=3D FLOW_ACTION_ACCEPT)
+			return false;
+
+	flow_rule_match_vlan(rule, &match_vlan);
+	if (!match_vlan.mask->vlan_id ||
+	    match_vlan.mask->vlan_priority)
+		return false;
+
+	if (match_vlan.key->vlan_tpid !=3D htons(ETH_P_8021Q))
+		return false;
+
+	attr->acl_vlanid =3D match_vlan.key->vlan_id;
+
+	flow_rule_match_eth_addrs(rule, &match_eth);
+	if (!is_zero_ether_addr(match_eth.mask->dst) &&
+	    !is_zero_ether_addr(match_eth.mask->src))
+		return false;
+
+	if (!is_zero_ether_addr(match_eth.mask->src))
+		attr->dir =3D MLX5_ACL_INGRESS;
+	else if (!is_zero_ether_addr(match_eth.mask->dst))
+		attr->dir =3D MLX5_ACL_EGRESS;
+	else
+		return false;
+
+	return true;
+}
+
+static int
+mlx5e_add_vf_acl_flow(struct mlx5e_priv *priv,
+		      struct flow_cls_offload *f,
+		      unsigned long flow_flags,
+		      struct mlx5_vf_acl_flow_attr *acl_attr,
+		      struct mlx5e_tc_flow **__flow)
+{
+	struct flow_rule *rule =3D flow_cls_offload_flow_rule(f);
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct flow_match_eth_addrs match;
+	struct mlx5e_tc_flow *flow;
+	int attr_size, vport, err;
+
+	flow_rule_match_eth_addrs(rule, &match);
+	vport =3D mlx5_get_vport_by_mac(esw, (acl_attr->dir =3D=3D MLX5_ACL_INGRE=
SS) ?
+					   match.key->src :
+					   match.key->dst);
+	if (vport <=3D 0)
+		return -ENOENT;
+
+	acl_attr->vport =3D vport;
+	flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_VF_ACL);
+
+	attr_size  =3D sizeof(struct mlx5_vf_acl_flow_attr);
+	err =3D mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
+			       &parse_attr, &flow);
+	if (err)
+		return err;
+
+	*flow->acl_attr =3D *acl_attr;
+	err =3D mlx5_eswitch_add_vport_trunk_vlan(esw, acl_attr->vport,
+						acl_attr->acl_vlanid, acl_attr->dir);
+	if (err)
+		goto err_free;
+
+	flow_flag_set(flow, OFFLOADED);
+	kvfree(parse_attr);
+	*__flow =3D flow;
+
+	return 0;
+
+err_free:
+	mlx5e_flow_put(priv, flow);
+	kvfree(parse_attr);
+
+	return err;
+}
+
 static int
 mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 		   struct flow_cls_offload *f,
@@ -3777,8 +3900,8 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 		  struct mlx5e_tc_flow **flow)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+	struct mlx5_vf_acl_flow_attr attr;
 	unsigned long flow_flags;
-	int err;
=20
 	get_flags(flags, &flow_flags);
=20
@@ -3786,13 +3909,15 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
=20
 	if (esw && esw->mode =3D=3D MLX5_ESWITCH_OFFLOADS)
-		err =3D mlx5e_add_fdb_flow(priv, f, flow_flags,
-					 filter_dev, flow);
-	else
-		err =3D mlx5e_add_nic_flow(priv, f, flow_flags,
-					 filter_dev, flow);
+		return mlx5e_add_fdb_flow(priv, f, flow_flags,
+					  filter_dev, flow);
=20
-	return err;
+	if (parse_vf_acl_flow(esw, f, &attr))
+		return mlx5e_add_vf_acl_flow(priv, f, flow_flags,
+					     &attr, flow);
+
+	return mlx5e_add_nic_flow(priv, f, flow_flags,
+				  filter_dev, flow);
 }
=20
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv=
,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 41d67ca6cce3..11436f19b566 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -66,6 +66,25 @@ struct mlx5_acl_vlan {
 static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw);
 static void esw_cleanup_vepa_rules(struct mlx5_eswitch *esw);
=20
+int mlx5_get_vport_by_mac(struct mlx5_eswitch *esw, u8 *mac)
+{
+	struct mlx5_vport *evport;
+	int vport =3D -ENOENT;
+	int i;
+
+	mutex_lock(&esw->state_lock);
+	mlx5_esw_for_all_vports(esw, i, evport) {
+		if (!ether_addr_equal(mac, evport->info.mac))
+			continue;
+
+		vport =3D i;
+		break;
+	}
+
+	mutex_unlock(&esw->state_lock);
+	return vport;
+}
+
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 5c84dbdb300f..9cfe34d8877f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -630,6 +630,7 @@ bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch=
 *esw, u16 vport_num);
=20
 void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int nu=
m_vfs);
 int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned lon=
g type, void *data);
+int mlx5_get_vport_by_mac(struct mlx5_eswitch *esw, u8 *mac);
=20
 int
 mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
--=20
2.21.0

