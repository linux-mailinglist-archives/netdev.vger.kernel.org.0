Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6179D0D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfG2Xul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:41 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbfG2Xui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ji2s/9Q8x9bM3rzGz0r7DeCo0vAPKtCQbzPfJC9DTq8qHBsR4Y5pNK7ef9BzWqnou9vcbn0ALU4dJh8HpGOc/9D+c0LycCqoUDh2aJ3B9HxOEhzFydcx9CdeW40hA7EGcTGMp29HOzn4s0g4jpF+ZRyV70LbgMA0TzDayl5yBlVRKeWVY4BG1bKfwGrErMrkumhQzAZbSS1OSNQW+lSSOEoIoFfjU41VF8t2bXXMxapaiwMgmPP0CLeEBVa7lmsFBvOopnUFInHgWTPfxPHXKY00aMArW+DzU10RV9hkHqJ5Epn30lXa2mE0RMvXClEJ7nn0XiP102+crwW3ijdofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F14iMdhAuw4k+e3Mo+dH5Fz28S+FRNKdFC/J8NyEUco=;
 b=jxR8Zy+uekD4j5hjfC9JlcWFks+EdcWOlZqkkl3LVpLIC+rUHo2tdSF5R0G3y1e9X9ZcKmD+2gPGb9K9BQLd68n1HZrHm2dLQ5qA0csH5gDJT7+le9EYwKGOke1TkO5I70fzQcHK2UzI/+2RASADI+x7gYWlwC/Efj/JrJbhlt15CwWeGtiU4DxluXCmFqv5g01h/vrRYRF1k3eR1gFOB/h3FBGLgXVp1VgXylQ8CmQF47wFZOaz8wWh6wuWxTT0z+GXL2I/SBM7fF9kZ+I7MGlHYHE01oBg63ki3Zuk7y90jcZEo3MriSUrY84q4yEu8FOrHf12dZsCqmB7v8K65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F14iMdhAuw4k+e3Mo+dH5Fz28S+FRNKdFC/J8NyEUco=;
 b=j5s7rUaYZzgOaePrCiN9VfTSGP/hSekcKB+53zrC4eKN3gyVUugzAPNPVN/6cZn9D71b+VV4lphPEQeQh7G+FsAREStBbds5ptipd/o20C9fJUG97Oh3im9e/Pnrg+yT7kBF4+NKVcKNAkqJMFNmlK4K5jVcACQwcCUDpEubpW0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/13] net/mlx5e: Extend tc flow struct with reference
 counter
Thread-Topic: [net-next 06/13] net/mlx5e: Extend tc flow struct with reference
 counter
Thread-Index: AQHVRmhjX0dYHiMXLEejBvKgU3OSag==
Date:   Mon, 29 Jul 2019 23:50:24 +0000
Message-ID: <20190729234934.23595-7-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07223c92-3215-463b-0dd6-08d7147f864d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343B09994BB6758D7A822C4BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(5024004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(30864003)(53946003)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8VdeUijuteYOzi6ZNw/jYlrhwfRJ0pTvGesRsfHQMGhHLDhHyUA1i4L/WREn5+zn7tEYnKneGnkHRXTQcRqaogQ3hKLmek/MqrdK3q61UzduszadMmZY2hSxdFMmdw1Z2DMM5q0dacu9STl4/l5/7LMVeHh02TObWTLkcehBtZZTrs7n9txlwe+GeOHqSplnGtHe4Uodn+VZaXsRbKcThY/7ACneiLY+VXJ0sabE1OwbwTYE1spEKEvlHbPKOWHwzciF+S8u2MK0l8wzfIqC8FwESg8Ow1Dvyyd2VidV2az4D2R7nzed++3dp/3CNYUtc+cmSYP9GRuhWcSELM9le0JJ9Pkw//c8nVsxWHOGCRR3U74D0yCgCyBjiitfNYrG/aTDv6CjY8OZ6bfQ1qmepJa7TbJ2UIKlhe6o1njqmWg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07223c92-3215-463b-0dd6-08d7147f864d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:24.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

With new classifier type that doesn't require rtnl lock, following
invariant holds:
 - Filter with specified cookie created only once.
 - Filter with specified cookie deleted only once.
 - Stats updates can be performed in parallel to each other.

Extend tc flow with rcu and reference counter. To protect from concurrent
delete, get reference to tc flow when:
 - Reading flow stats.
 - Accessing flow in neigh update handler.
 - Accessing flow in neigh update used value handler.

Only free flow when reference counter reached zero. Modify flow cleanup to
account for flows that could be not fully initialized by checking if flow
is actually in the list of corresponding mod_hdr, hairpin and encap
entries. Don't cleanup flow directly in case of error to allow concurrent
neigh update (neigh update will be modified to always take reference to
flow when using it).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 193 ++++++++++--------
 1 file changed, 105 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index cc096f6011d9..e2b87f723819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -38,6 +38,7 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/device.h>
 #include <linux/rhashtable.h>
+#include <linux/refcount.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_tunnel_key.h>
@@ -120,6 +121,7 @@ struct mlx5e_tc_flow {
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to =
missing route) */
+	refcount_t		refcnt;
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
@@ -184,6 +186,25 @@ struct mlx5e_mod_hdr_entry {
=20
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
=20
+static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow);
+
+static struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow)
+{
+	if (!flow || !refcount_inc_not_zero(&flow->refcnt))
+		return ERR_PTR(-EINVAL);
+	return flow;
+}
+
+static void mlx5e_flow_put(struct mlx5e_priv *priv,
+			   struct mlx5e_tc_flow *flow)
+{
+	if (refcount_dec_and_test(&flow->refcnt)) {
+		mlx5e_tc_del_flow(priv, flow);
+		kfree(flow);
+	}
+}
+
 static inline u32 hash_mod_hdr_info(struct mod_hdr_key *key)
 {
 	return jhash(key->actions,
@@ -281,6 +302,10 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *pr=
iv,
 {
 	struct list_head *next =3D flow->mod_hdr.next;
=20
+	/* flow wasn't fully initialized */
+	if (list_empty(&flow->mod_hdr))
+		return;
+
 	list_del(&flow->mod_hdr);
=20
 	if (list_empty(next)) {
@@ -694,6 +719,10 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *=
priv,
 {
 	struct list_head *next =3D flow->hairpin.next;
=20
+	/* flow wasn't fully initialized */
+	if (list_empty(&flow->hairpin))
+		return;
+
 	list_del(&flow->hairpin);
=20
 	/* no more hairpin flows for us, release the hairpin pair */
@@ -727,7 +756,6 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		.flags    =3D FLOW_ACT_NO_APPEND,
 	};
 	struct mlx5_fc *counter =3D NULL;
-	bool table_created =3D false;
 	int err, dest_ix =3D 0;
=20
 	flow_context->flags |=3D FLOW_CONTEXT_HAS_TAG;
@@ -735,9 +763,9 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 	if (flow->flags & MLX5E_TC_FLOW_HAIRPIN) {
 		err =3D mlx5e_hairpin_flow_add(priv, flow, parse_attr, extack);
-		if (err) {
-			goto err_add_hairpin_flow;
-		}
+		if (err)
+			return err;
+
 		if (flow->flags & MLX5E_TC_FLOW_HAIRPIN_RSS) {
 			dest[dest_ix].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 			dest[dest_ix].ft =3D attr->hairpin_ft;
@@ -754,10 +782,9 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		counter =3D mlx5_fc_create(dev, true);
-		if (IS_ERR(counter)) {
-			err =3D PTR_ERR(counter);
-			goto err_fc_create;
-		}
+		if (IS_ERR(counter))
+			return PTR_ERR(counter);
+
 		dest[dest_ix].type =3D MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 		dest[dest_ix].counter_id =3D mlx5_fc_id(counter);
 		dest_ix++;
@@ -769,7 +796,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		flow_act.modify_id =3D attr->mod_hdr_id;
 		kfree(parse_attr->mod_hdr_actions);
 		if (err)
-			goto err_create_mod_hdr_id;
+			return err;
 	}
=20
 	if (IS_ERR_OR_NULL(priv->fs.tc.t)) {
@@ -795,11 +822,8 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 					   "Failed to create tc offload table\n");
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			err =3D PTR_ERR(priv->fs.tc.t);
-			goto err_create_ft;
+			return PTR_ERR(priv->fs.tc.t);
 		}
-
-		table_created =3D true;
 	}
=20
 	if (attr->match_level !=3D MLX5_MATCH_NONE)
@@ -808,28 +832,10 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	flow->rule[0] =3D mlx5_add_flow_rules(priv->fs.tc.t, &parse_attr->spec,
 					    &flow_act, dest, dest_ix);
=20
-	if (IS_ERR(flow->rule[0])) {
-		err =3D PTR_ERR(flow->rule[0]);
-		goto err_add_rule;
-	}
+	if (IS_ERR(flow->rule[0]))
+		return PTR_ERR(flow->rule[0]);
=20
 	return 0;
-
-err_add_rule:
-	if (table_created) {
-		mlx5_destroy_flow_table(priv->fs.tc.t);
-		priv->fs.tc.t =3D NULL;
-	}
-err_create_ft:
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		mlx5e_detach_mod_hdr(priv, flow);
-err_create_mod_hdr_id:
-	mlx5_fc_destroy(dev, counter);
-err_fc_create:
-	if (flow->flags & MLX5E_TC_FLOW_HAIRPIN)
-		mlx5e_hairpin_flow_del(priv, flow);
-err_add_hairpin_flow:
-	return err;
 }
=20
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
@@ -839,7 +845,8 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *pr=
iv,
 	struct mlx5_fc *counter =3D NULL;
=20
 	counter =3D attr->counter;
-	mlx5_del_flow_rules(flow->rule[0]);
+	if (!IS_ERR_OR_NULL(flow->rule[0]))
+		mlx5_del_flow_rules(flow->rule[0]);
 	mlx5_fc_destroy(priv->mdev, counter);
=20
 	if (!mlx5e_tc_num_filters(priv, MLX5E_TC_NIC_OFFLOAD)  && priv->fs.tc.t) =
{
@@ -980,14 +987,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
=20
 	if (attr->chain > max_chain) {
 		NL_SET_ERR_MSG(extack, "Requested chain is out of supported range");
-		err =3D -EOPNOTSUPP;
-		goto err_max_prio_chain;
+		return -EOPNOTSUPP;
 	}
=20
 	if (attr->prio > max_prio) {
 		NL_SET_ERR_MSG(extack, "Requested priority is out of supported range");
-		err =3D -EOPNOTSUPP;
-		goto err_max_prio_chain;
+		return -EOPNOTSUPP;
 	}
=20
 	for (out_index =3D 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) =
{
@@ -1002,7 +1007,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		err =3D mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
 		if (err)
-			goto err_attach_encap;
+			return err;
=20
 		out_priv =3D netdev_priv(encap_dev);
 		rpriv =3D out_priv->ppriv;
@@ -1012,21 +1017,19 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
=20
 	err =3D mlx5_eswitch_add_vlan_action(esw, attr);
 	if (err)
-		goto err_add_vlan;
+		return err;
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err =3D mlx5e_attach_mod_hdr(priv, flow, parse_attr);
 		kfree(parse_attr->mod_hdr_actions);
 		if (err)
-			goto err_mod_hdr;
+			return err;
 	}
=20
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		counter =3D mlx5_fc_create(attr->counter_dev, true);
-		if (IS_ERR(counter)) {
-			err =3D PTR_ERR(counter);
-			goto err_create_counter;
-		}
+		if (IS_ERR(counter))
+			return PTR_ERR(counter);
=20
 		attr->counter =3D counter;
 	}
@@ -1044,27 +1047,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		flow->rule[0] =3D mlx5e_tc_offload_fdb_rules(esw, flow, &parse_attr->spe=
c, attr);
 	}
=20
-	if (IS_ERR(flow->rule[0])) {
-		err =3D PTR_ERR(flow->rule[0]);
-		goto err_add_rule;
-	}
+	if (IS_ERR(flow->rule[0]))
+		return PTR_ERR(flow->rule[0]);
=20
 	return 0;
-
-err_add_rule:
-	mlx5_fc_destroy(attr->counter_dev, counter);
-err_create_counter:
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		mlx5e_detach_mod_hdr(priv, flow);
-err_mod_hdr:
-	mlx5_eswitch_del_vlan_action(esw, attr);
-err_add_vlan:
-	for (out_index =3D 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-		if (attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP)
-			mlx5e_detach_encap(priv, flow, out_index);
-err_attach_encap:
-err_max_prio_chain:
-	return err;
 }
=20
 static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
@@ -1123,9 +1109,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv=
,
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr slow_attr, *esw_attr;
+	struct encap_flow_item *efi, *tmp;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
-	struct encap_flow_item *efi;
 	struct mlx5e_tc_flow *flow;
 	int err;
=20
@@ -1142,11 +1128,14 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *pr=
iv,
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(priv);
=20
-	list_for_each_entry(efi, &e->flows, list) {
+	list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 		bool all_flow_encaps_valid =3D true;
 		int i;
=20
 		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
+		if (IS_ERR(mlx5e_flow_get(flow)))
+			continue;
+
 		esw_attr =3D flow->esw_attr;
 		spec =3D &esw_attr->parse_attr->spec;
=20
@@ -1166,19 +1155,22 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *pr=
iv,
 		}
 		/* Do not offload flows with unresolved neighbors */
 		if (!all_flow_encaps_valid)
-			continue;
+			goto loop_cont;
 		/* update from slow path rule to encap rule */
 		rule =3D mlx5e_tc_offload_fdb_rules(esw, flow, spec, esw_attr);
 		if (IS_ERR(rule)) {
 			err =3D PTR_ERR(rule);
 			mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow,=
 %d\n",
 				       err);
-			continue;
+			goto loop_cont;
 		}
=20
 		mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
 		flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED; /* was unset when slow path ru=
le removed */
 		flow->rule[0] =3D rule;
+
+loop_cont:
+		mlx5e_flow_put(priv, flow);
 	}
 }
=20
@@ -1187,14 +1179,17 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *pr=
iv,
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr slow_attr;
+	struct encap_flow_item *efi, *tmp;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
-	struct encap_flow_item *efi;
 	struct mlx5e_tc_flow *flow;
 	int err;
=20
-	list_for_each_entry(efi, &e->flows, list) {
+	list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
+		if (IS_ERR(mlx5e_flow_get(flow)))
+			continue;
+
 		spec =3D &flow->esw_attr->parse_attr->spec;
=20
 		/* update from encap rule to slow path rule */
@@ -1206,12 +1201,15 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *pr=
iv,
 			err =3D PTR_ERR(rule);
 			mlx5_core_warn(priv->mdev, "Failed to update slow path (encap) flow, %d=
\n",
 				       err);
-			continue;
+			goto loop_cont;
 		}
=20
 		mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->esw_attr);
 		flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED; /* was unset when fast path ru=
le removed */
 		flow->rule[0] =3D rule;
+
+loop_cont:
+		mlx5e_flow_put(priv, flow);
 	}
=20
 	/* we know that the encap is valid */
@@ -1248,20 +1246,26 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 		return;
=20
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
-		struct encap_flow_item *efi;
+		struct encap_flow_item *efi, *tmp;
 		if (!(e->flags & MLX5_ENCAP_ENTRY_VALID))
 			continue;
-		list_for_each_entry(efi, &e->flows, list) {
+		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 			flow =3D container_of(efi, struct mlx5e_tc_flow,
 					    encaps[efi->index]);
+			if (IS_ERR(mlx5e_flow_get(flow)))
+				continue;
+
 			if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
 				counter =3D mlx5e_tc_get_counter(flow);
 				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
+					mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 					neigh_used =3D true;
 					break;
 				}
 			}
+
+			mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 		}
 		if (neigh_used)
 			break;
@@ -1287,6 +1291,10 @@ static void mlx5e_detach_encap(struct mlx5e_priv *pr=
iv,
 {
 	struct list_head *next =3D flow->encaps[out_index].list.next;
=20
+	/* flow wasn't fully initialized */
+	if (list_empty(&flow->encaps[out_index].list))
+		return;
+
 	list_del(&flow->encaps[out_index].list);
 	if (list_empty(next)) {
 		struct mlx5e_encap_entry *e;
@@ -3122,7 +3130,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_si=
ze,
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
-	int err;
+	int out_index, err;
=20
 	flow =3D kzalloc(sizeof(*flow) + attr_size, GFP_KERNEL);
 	parse_attr =3D kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
@@ -3134,6 +3142,11 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_s=
ize,
 	flow->cookie =3D f->cookie;
 	flow->flags =3D flow_flags;
 	flow->priv =3D priv;
+	for (out_index =3D 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
+		INIT_LIST_HEAD(&flow->encaps[out_index].list);
+	INIT_LIST_HEAD(&flow->mod_hdr);
+	INIT_LIST_HEAD(&flow->hairpin);
+	refcount_set(&flow->refcnt, 1);
=20
 	*__flow =3D flow;
 	*__parse_attr =3D parse_attr;
@@ -3216,8 +3229,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return flow;
=20
 err_free:
-	kfree(flow);
-	kvfree(parse_attr);
+	mlx5e_flow_put(priv, flow);
 out:
 	return ERR_PTR(err);
 }
@@ -3351,7 +3363,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	return 0;
=20
 err_free:
-	kfree(flow);
+	mlx5e_flow_put(priv, flow);
 	kvfree(parse_attr);
 out:
 	return err;
@@ -3413,8 +3425,7 @@ int mlx5e_configure_flower(struct net_device *dev, st=
ruct mlx5e_priv *priv,
 	return 0;
=20
 err_free:
-	mlx5e_tc_del_flow(priv, flow);
-	kfree(flow);
+	mlx5e_flow_put(priv, flow);
 out:
 	return err;
 }
@@ -3442,9 +3453,7 @@ int mlx5e_delete_flower(struct net_device *dev, struc=
t mlx5e_priv *priv,
=20
 	rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
=20
-	mlx5e_tc_del_flow(priv, flow);
-
-	kfree(flow);
+	mlx5e_flow_put(priv, flow);
=20
 	return 0;
 }
@@ -3460,15 +3469,22 @@ int mlx5e_stats_flower(struct net_device *dev, stru=
ct mlx5e_priv *priv,
 	u64 lastuse =3D 0;
 	u64 packets =3D 0;
 	u64 bytes =3D 0;
+	int err =3D 0;
=20
-	flow =3D rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
-	if (!flow || !same_flow_direction(flow, flags))
-		return -EINVAL;
+	flow =3D mlx5e_flow_get(rhashtable_lookup_fast(tc_ht, &f->cookie,
+						     tc_ht_params));
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (!same_flow_direction(flow, flags)) {
+		err =3D -EINVAL;
+		goto errout;
+	}
=20
 	if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
 		counter =3D mlx5e_tc_get_counter(flow);
 		if (!counter)
-			return 0;
+			goto errout;
=20
 		mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
 	}
@@ -3500,8 +3516,9 @@ int mlx5e_stats_flower(struct net_device *dev, struct=
 mlx5e_priv *priv,
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
 	flow_stats_update(&f->stats, bytes, packets, lastuse);
-
-	return 0;
+errout:
+	mlx5e_flow_put(priv, flow);
+	return err;
 }
=20
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
--=20
2.21.0

