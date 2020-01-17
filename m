Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE183140093
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388108AbgAQAHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:43 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729213AbgAQAHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMlNZnjkplS8UHNS0NFr+GOr3wvWI+NPlXX2rHXIi1hquKfkcCMlNNK+nhnHv4AJCDLl9um9LQSbIWIHECZ1EcuUU3b7o5XsyjvpYTuBsb4kFrg0rt8I0S84RcL34T+RbDP7SPKiy4xGdRPOmFaZ7nq7qReXeaeRwyWnhf9Ph42muc9D12HjsEQLf9ehz64D3iIkOZ01w7u/USGSac6yE6bVtdNe86SJzLuenlznfYNdY99CAyIzQwcLqClPYXCzyzYeKdY5Ihon2NNybNipO/JJ3d8DWeHj5rVDzNNBqA4MUjXr/J3cEXmVdJTyxg7WGOnhofzmc6MtVNRVX52K/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waTzeoWja40P/YwRq2YA13R4lHQKjIy7iGS+nGNUiVI=;
 b=hbsh9q8TEmFD+p/Ih//ScqfhJmTYJbrufm2coYKILG2rsbqqTCy27ZFfpZ0u0YrdgpfVwlaBg3vIzNcX5cmPJZRlSP3nd0j5o9f4vcUMjOw6a4/ac1YLKLSvrS0oKO2MRc4Pk2UpArkh+Zg0uoArbsTY5YO8aslJCxxkT/7BeHilRJ7idVYT70bJuji370gpF70suHCjv3hryiRlyXEt6enQAlCSL/U4tCIC5e7NK8/c56M/oAQFWmuKNwcqSFulGWo84f5wmxrSVDKFZQ6DZYt86G2VxbQRtCKR3OWOno7CgkZkyBDRDsiXgJas06RFfUGi5/fkqVT9vc05tRJ2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waTzeoWja40P/YwRq2YA13R4lHQKjIy7iGS+nGNUiVI=;
 b=sgFfVxYvJoVtjxsT64X1Vo8o9nhabDWyc38AIGS5hgiGie/ccY2tnIQFv3D+gucu5cwWlwuFlxAZ1s0nNmGT2O9YLewcpFuCjKZ09gKXpw9HOWyZRR2CVB32ARqB3IULTZt1gwKvJFep+nULzMJzogaIWKd9bKqNG1cKReELImE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:28 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/16] net/mlx5: E-Switch, Increase number of chains and
 priorities
Thread-Topic: [net-next 16/16] net/mlx5: E-Switch, Increase number of chains
 and priorities
Thread-Index: AQHVzMoajYb7rwCdg0K+1Qqq8uqT7A==
Date:   Fri, 17 Jan 2020 00:07:28 +0000
Message-ID: <20200117000619.696775-17-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa261103-b759-4c0d-a0b8-08d79ae13d37
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49903B29FF3488C07242BA3DBE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(30864003)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 99aILtReoO2d+XsjuoUFWw8IyHydHdn1HBTelgwR/rL+WtA4NQhKinGSmSuAMlCvf3P0/JiZ1P6LeTtpAPsyWgRZ75BHrsrwclYN44uWRDyQedCJxvnfY8WxdD0MwvqfMiVe5W6y8rx2bGPAHoDVUc2RQVKgTei2QoP4gNAUqW/nlAni+Wz2RGGbEmqc0O4PRPRa8uVdBM5xRlqSeMSzpgBukhZ7evUjLg+b8+UHbdIY8Kokp98TRQAZ+KSGfG1P3Xwt001QdHJbSk4oQzPH7P9X0ccXtXf2cOxcKshr9qd6yw47OittezHn7Obo3Bj+PbW6KWxtpmkRMlWjqH8uMm2WVF0cpO5ckmbSq5p9u5b9Ffjfdcb1BHP953gbjUMac0A/Iqj/Y/r8lXRPPepZnwCE0R8SBgb14S0t6vY3X9IABw358TdZ9OS3ykE9msfmMo3NSZI1VVr0+3rxe/6Mz0fP3f+qaEyXUlDWml94r9Oh4O9RPlIB4btkYt5T5Rf6cNJtJSSBNqEGE1tfrUWgzoRSAoEKoIigApHj6fSlG8I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa261103-b759-4c0d-a0b8-08d79ae13d37
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:28.3688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1SMtr4Y0GGmBXFWtVzkbWKFIzGgDJzNVuN9/7TF3n+DjQMN84izJbN9cDoE8oa/7+GBTdSR43jxzEZx1VaTZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Increase the number of chains and priorities to support
the whole range available in tc.

We use unmanaged tables and ignore flow level to create more
tables than what we declared to fs_core steering, and we manage
the connections between the tables themselves.

To support that we need FW with ignore_flow_level capability.
Otherwise the old behaviour will be used, where we are limited
by the number of levels we declared (4 chains, 16 prios).

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     |   3 +-
 .../mlx5/core/eswitch_offloads_chains.c       | 238 +++++++++++++++++-
 .../mlx5/core/eswitch_offloads_chains.h       |   3 +
 3 files changed, 232 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 47f8729197e0..a6d0b62ef234 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -151,7 +151,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *es=
w,
 		if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 			flow_act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
 			dest[i].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[i].ft =3D esw->fdb_table.offloads.slow_fdb;
+			dest[i].ft =3D mlx5_esw_chains_get_tc_end_ft(esw);
 			i++;
 		} else if (attr->dest_chain) {
 			flow_act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
@@ -275,6 +275,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	if (attr->outer_match_level !=3D MLX5_MATCH_NONE)
 		spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
=20
+	flow_act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
 	rule =3D mlx5_add_flow_rules(fast_fdb, spec, &flow_act, dest, i);
=20
 	if (IS_ERR(rule))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index a694cc52d94c..3a60eb5360bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -16,6 +16,10 @@
 #define esw_chains_ht(esw) (esw_chains_priv(esw)->chains_ht)
 #define esw_prios_ht(esw) (esw_chains_priv(esw)->prios_ht)
 #define fdb_pool_left(esw) (esw_chains_priv(esw)->fdb_left)
+#define tc_slow_fdb(esw) ((esw)->fdb_table.offloads.slow_fdb)
+#define tc_end_fdb(esw) (esw_chains_priv(esw)->tc_end_fdb)
+#define fdb_ignore_flow_level_supported(esw) \
+	(MLX5_CAP_ESW_FLOWTABLE_FDB((esw)->dev, ignore_flow_level))
=20
 #define ESW_OFFLOADS_NUM_GROUPS  4
=20
@@ -39,6 +43,8 @@ struct mlx5_esw_chains_priv {
 	/* Protects above chains_ht and prios_ht */
 	struct mutex lock;
=20
+	struct mlx5_flow_table *tc_end_fdb;
+
 	int fdb_left[ARRAY_SIZE(ESW_POOLS)];
 };
=20
@@ -50,6 +56,7 @@ struct fdb_chain {
 	int ref;
=20
 	struct mlx5_eswitch *esw;
+	struct list_head prios_list;
 };
=20
 struct fdb_prio_key {
@@ -60,6 +67,7 @@ struct fdb_prio_key {
=20
 struct fdb_prio {
 	struct rhash_head node;
+	struct list_head list;
=20
 	struct fdb_prio_key key;
=20
@@ -67,6 +75,9 @@ struct fdb_prio {
=20
 	struct fdb_chain *fdb_chain;
 	struct mlx5_flow_table *fdb;
+	struct mlx5_flow_table *next_fdb;
+	struct mlx5_flow_group *miss_group;
+	struct mlx5_flow_handle *miss_rule;
 };
=20
 static const struct rhashtable_params chain_params =3D {
@@ -93,6 +104,9 @@ u32 mlx5_esw_chains_get_chain_range(struct mlx5_eswitch =
*esw)
 	if (!mlx5_esw_chains_prios_supported(esw))
 		return 1;
=20
+	if (fdb_ignore_flow_level_supported(esw))
+		return UINT_MAX - 1;
+
 	return FDB_TC_MAX_CHAIN;
 }
=20
@@ -106,11 +120,17 @@ u32 mlx5_esw_chains_get_prio_range(struct mlx5_eswitc=
h *esw)
 	if (!mlx5_esw_chains_prios_supported(esw))
 		return 1;
=20
+	if (fdb_ignore_flow_level_supported(esw))
+		return UINT_MAX;
+
 	return FDB_TC_MAX_PRIO;
 }
=20
 static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *e=
sw)
 {
+	if (fdb_ignore_flow_level_supported(esw))
+		return UINT_MAX;
+
 	return FDB_TC_LEVELS_PER_PRIO;
 }
=20
@@ -181,13 +201,40 @@ mlx5_esw_chains_create_fdb_table(struct mlx5_eswitch =
*esw,
 	sz =3D mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
 	if (!sz)
 		return ERR_PTR(-ENOSPC);
-
 	ft_attr.max_fte =3D sz;
-	ft_attr.level =3D level;
-	ft_attr.prio =3D prio - 1;
-	ft_attr.autogroup.max_num_groups =3D ESW_OFFLOADS_NUM_GROUPS;
-	ns =3D mlx5_get_fdb_sub_ns(esw->dev, chain);
=20
+	/* We use tc_slow_fdb(esw) as the table's next_ft till
+	 * ignore_flow_level is allowed on FT creation and not just for FTEs.
+	 * Instead caller should add an explicit miss rule if needed.
+	 */
+	ft_attr.next_ft =3D tc_slow_fdb(esw);
+
+	/* The root table(chain 0, prio 1, level 0) is required to be
+	 * connected to the previous prio (FDB_BYPASS_PATH if exists).
+	 * We always create it, as a managed table, in order to align with
+	 * fs_core logic.
+	 */
+	if (!fdb_ignore_flow_level_supported(esw) ||
+	    (chain =3D=3D 0 && prio =3D=3D 1 && level =3D=3D 0)) {
+		ft_attr.level =3D level;
+		ft_attr.prio =3D prio - 1;
+		ns =3D mlx5_get_fdb_sub_ns(esw->dev, chain);
+	} else {
+		ft_attr.flags |=3D MLX5_FLOW_TABLE_UNMANAGED;
+		ft_attr.prio =3D FDB_TC_OFFLOAD;
+		/* Firmware doesn't allow us to create another level 0 table,
+		 * so we create all unmanaged tables as level 1.
+		 *
+		 * To connect them, we use explicit miss rules with
+		 * ignore_flow_level. Caller is responsible to create
+		 * these rules (if needed).
+		 */
+		ft_attr.level =3D 1;
+		ns =3D mlx5_get_flow_namespace(esw->dev, MLX5_FLOW_NAMESPACE_FDB);
+	}
+
+	ft_attr.autogroup.num_reserved_entries =3D 2;
+	ft_attr.autogroup.max_num_groups =3D ESW_OFFLOADS_NUM_GROUPS;
 	fdb =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(fdb)) {
 		esw_warn(esw->dev,
@@ -220,6 +267,7 @@ mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *e=
sw, u32 chain)
=20
 	fdb_chain->esw =3D esw;
 	fdb_chain->chain =3D chain;
+	INIT_LIST_HEAD(&fdb_chain->prios_list);
=20
 	err =3D rhashtable_insert_fast(&esw_chains_ht(esw), &fdb_chain->node,
 				     chain_params);
@@ -261,6 +309,79 @@ mlx5_esw_chains_get_fdb_chain(struct mlx5_eswitch *esw=
, u32 chain)
 	return fdb_chain;
 }
=20
+static struct mlx5_flow_handle *
+mlx5_esw_chains_add_miss_rule(struct mlx5_flow_table *fdb,
+			      struct mlx5_flow_table *next_fdb)
+{
+	static const struct mlx5_flow_spec spec =3D {};
+	struct mlx5_flow_destination dest =3D {};
+	struct mlx5_flow_act act =3D {};
+
+	act.flags  =3D FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	act.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dest.type  =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft =3D next_fdb;
+
+	return mlx5_add_flow_rules(fdb, &spec, &act, &dest, 1);
+}
+
+static int
+mlx5_esw_chains_update_prio_prevs(struct fdb_prio *fdb_prio,
+				  struct mlx5_flow_table *next_fdb)
+{
+	struct mlx5_flow_handle *miss_rules[FDB_TC_LEVELS_PER_PRIO + 1] =3D {};
+	struct fdb_chain *fdb_chain =3D fdb_prio->fdb_chain;
+	struct fdb_prio *pos;
+	int n =3D 0, err;
+
+	if (fdb_prio->key.level)
+		return 0;
+
+	/* Iterate in reverse order until reaching the level 0 rule of
+	 * the previous priority, adding all the miss rules first, so we can
+	 * revert them if any of them fails.
+	 */
+	pos =3D fdb_prio;
+	list_for_each_entry_continue_reverse(pos,
+					     &fdb_chain->prios_list,
+					     list) {
+		miss_rules[n] =3D mlx5_esw_chains_add_miss_rule(pos->fdb,
+							      next_fdb);
+		if (IS_ERR(miss_rules[n])) {
+			err =3D PTR_ERR(miss_rules[n]);
+			goto err_prev_rule;
+		}
+
+		n++;
+		if (!pos->key.level)
+			break;
+	}
+
+	/* Success, delete old miss rules, and update the pointers. */
+	n =3D 0;
+	pos =3D fdb_prio;
+	list_for_each_entry_continue_reverse(pos,
+					     &fdb_chain->prios_list,
+					     list) {
+		mlx5_del_flow_rules(pos->miss_rule);
+
+		pos->miss_rule =3D miss_rules[n];
+		pos->next_fdb =3D next_fdb;
+
+		n++;
+		if (!pos->key.level)
+			break;
+	}
+
+	return 0;
+
+err_prev_rule:
+	while (--n >=3D 0)
+		mlx5_del_flow_rules(miss_rules[n]);
+
+	return err;
+}
+
 static void
 mlx5_esw_chains_put_fdb_chain(struct fdb_chain *fdb_chain)
 {
@@ -272,9 +393,15 @@ static struct fdb_prio *
 mlx5_esw_chains_create_fdb_prio(struct mlx5_eswitch *esw,
 				u32 chain, u32 prio, u32 level)
 {
+	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_handle *miss_rule =3D NULL;
+	struct mlx5_flow_group *miss_group;
 	struct fdb_prio *fdb_prio =3D NULL;
+	struct mlx5_flow_table *next_fdb;
 	struct fdb_chain *fdb_chain;
 	struct mlx5_flow_table *fdb;
+	struct list_head *pos;
+	u32 *flow_group_in;
 	int err;
=20
 	fdb_chain =3D mlx5_esw_chains_get_fdb_chain(esw, chain);
@@ -282,18 +409,65 @@ mlx5_esw_chains_create_fdb_prio(struct mlx5_eswitch *=
esw,
 		return ERR_CAST(fdb_chain);
=20
 	fdb_prio =3D kvzalloc(sizeof(*fdb_prio), GFP_KERNEL);
-	if (!fdb_prio) {
+	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!fdb_prio || !flow_group_in) {
 		err =3D -ENOMEM;
 		goto err_alloc;
 	}
=20
-	fdb =3D mlx5_esw_chains_create_fdb_table(esw, fdb_chain->chain, prio,
-					       level);
+	/* Chain's prio list is sorted by prio and level.
+	 * And all levels of some prio point to the next prio's level 0.
+	 * Example list (prio, level):
+	 * (3,0)->(3,1)->(5,0)->(5,1)->(6,1)->(7,0)
+	 * In hardware, we will we have the following pointers:
+	 * (3,0) -> (5,0) -> (7,0) -> Slow path
+	 * (3,1) -> (5,0)
+	 * (5,1) -> (7,0)
+	 * (6,1) -> (7,0)
+	 */
+
+	/* Default miss for each chain: */
+	next_fdb =3D (chain =3D=3D mlx5_esw_chains_get_ft_chain(esw)) ?
+		    tc_slow_fdb(esw) :
+		    tc_end_fdb(esw);
+	list_for_each(pos, &fdb_chain->prios_list) {
+		struct fdb_prio *p =3D list_entry(pos, struct fdb_prio, list);
+
+		/* exit on first pos that is larger */
+		if (prio < p->key.prio || (prio =3D=3D p->key.prio &&
+					   level < p->key.level)) {
+			/* Get next level 0 table */
+			next_fdb =3D p->key.level =3D=3D 0 ? p->fdb : p->next_fdb;
+			break;
+		}
+	}
+
+	fdb =3D mlx5_esw_chains_create_fdb_table(esw, chain, prio, level);
 	if (IS_ERR(fdb)) {
 		err =3D PTR_ERR(fdb);
 		goto err_create;
 	}
=20
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index,
+		 fdb->max_fte - 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 fdb->max_fte - 1);
+	miss_group =3D mlx5_create_flow_group(fdb, flow_group_in);
+	if (IS_ERR(miss_group)) {
+		err =3D PTR_ERR(miss_group);
+		goto err_group;
+	}
+
+	/* Add miss rule to next_fdb */
+	miss_rule =3D mlx5_esw_chains_add_miss_rule(fdb, next_fdb);
+	if (IS_ERR(miss_rule)) {
+		err =3D PTR_ERR(miss_rule);
+		goto err_miss_rule;
+	}
+
+	fdb_prio->miss_group =3D miss_group;
+	fdb_prio->miss_rule =3D miss_rule;
+	fdb_prio->next_fdb =3D next_fdb;
 	fdb_prio->fdb_chain =3D fdb_chain;
 	fdb_prio->key.chain =3D chain;
 	fdb_prio->key.prio =3D prio;
@@ -305,13 +479,30 @@ mlx5_esw_chains_create_fdb_prio(struct mlx5_eswitch *=
esw,
 	if (err)
 		goto err_insert;
=20
+	list_add(&fdb_prio->list, pos->prev);
+
+	/* Table is ready, connect it */
+	err =3D mlx5_esw_chains_update_prio_prevs(fdb_prio, fdb);
+	if (err)
+		goto err_update;
+
+	kvfree(flow_group_in);
 	return fdb_prio;
=20
+err_update:
+	list_del(&fdb_prio->list);
+	rhashtable_remove_fast(&esw_prios_ht(esw), &fdb_prio->node,
+			       prio_params);
 err_insert:
+	mlx5_del_flow_rules(miss_rule);
+err_miss_rule:
+	mlx5_destroy_flow_group(miss_group);
+err_group:
 	mlx5_esw_chains_destroy_fdb_table(esw, fdb);
 err_create:
-	kvfree(fdb_prio);
 err_alloc:
+	kvfree(fdb_prio);
+	kvfree(flow_group_in);
 	mlx5_esw_chains_put_fdb_chain(fdb_chain);
 	return ERR_PTR(err);
 }
@@ -322,8 +513,14 @@ mlx5_esw_chains_destroy_fdb_prio(struct mlx5_eswitch *=
esw,
 {
 	struct fdb_chain *fdb_chain =3D fdb_prio->fdb_chain;
=20
+	WARN_ON(mlx5_esw_chains_update_prio_prevs(fdb_prio,
+						  fdb_prio->next_fdb));
+
+	list_del(&fdb_prio->list);
 	rhashtable_remove_fast(&esw_prios_ht(esw), &fdb_prio->node,
 			       prio_params);
+	mlx5_del_flow_rules(fdb_prio->miss_rule);
+	mlx5_destroy_flow_group(fdb_prio->miss_group);
 	mlx5_esw_chains_destroy_fdb_table(esw, fdb_prio->fdb);
 	mlx5_esw_chains_put_fdb_chain(fdb_chain);
 	kvfree(fdb_prio);
@@ -415,6 +612,12 @@ mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u3=
2 chain, u32 prio,
 		  chain, prio, level);
 }
=20
+struct mlx5_flow_table *
+mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw)
+{
+	return tc_end_fdb(esw);
+}
+
 static int
 mlx5_esw_chains_init(struct mlx5_eswitch *esw)
 {
@@ -484,11 +687,21 @@ mlx5_esw_chains_open(struct mlx5_eswitch *esw)
 	struct mlx5_flow_table *ft;
 	int err;
=20
-	/* Always open the root for fast path */
-	ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 0);
+	/* Create tc_end_fdb(esw) which is the always created ft chain */
+	ft =3D mlx5_esw_chains_get_table(esw, mlx5_esw_chains_get_ft_chain(esw),
+				       1, 0);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
=20
+	tc_end_fdb(esw) =3D ft;
+
+	/* Always open the root for fast path */
+	ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 0);
+	if (IS_ERR(ft)) {
+		err =3D PTR_ERR(ft);
+		goto level_0_err;
+	}
+
 	/* Open level 1 for split rules now if prios isn't supported  */
 	if (!mlx5_esw_chains_prios_supported(esw)) {
 		ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 1);
@@ -503,6 +716,8 @@ mlx5_esw_chains_open(struct mlx5_eswitch *esw)
=20
 level_1_err:
 	mlx5_esw_chains_put_table(esw, 0, 1, 0);
+level_0_err:
+	mlx5_esw_chains_put_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1, 0);
 	return err;
 }
=20
@@ -512,6 +727,7 @@ mlx5_esw_chains_close(struct mlx5_eswitch *esw)
 	if (!mlx5_esw_chains_prios_supported(esw))
 		mlx5_esw_chains_put_table(esw, 0, 1, 1);
 	mlx5_esw_chains_put_table(esw, 0, 1, 0);
+	mlx5_esw_chains_put_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1, 0);
 }
=20
 int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
index 52fadacab84d..2e13097fe348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -20,6 +20,9 @@ void
 mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
 			  u32 level);
=20
+struct mlx5_flow_table *
+mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw);
+
 int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
 void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
=20
--=20
2.24.1

