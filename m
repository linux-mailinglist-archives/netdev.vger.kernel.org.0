Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A7E140092
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgAQAHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:40 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387998AbgAQAHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev/JxggMFq5TNz0qEQZ+8i9GZA0NHc8b0Knum9yoxMeWOQ4+w62VATLDvsXoz4z4+6HPwyk/mVQyd5GlTKPJqRYrW66csCvKuzVa1RdR/NSZh1+QvRcEth6nJHgVScpzh56ZUN7ZdtrYXBQqYG+HPZDSjzpnZ39oYc0zDIUxxWvh1BA1XBBLPLw4x86EIPlweMFh2cfvN+dSlCZYw6q4CwB4F6QLZZbfwt8/bEAF/tglKDkA9GhameUXtuxmkz0uPDSl1gfhv5oHEcbtnIrrqnBhHRqy1lGp0fd/XSU6xmqcJLPpa4j6RJU1MWW4bQjXqujz2lL60BD09OQ86lBAFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzGbV1Y+izaVhNno1rloSbDdToEa/yA7HcTMpBVtQxY=;
 b=UYjwKXsDdIDH3C5pJqvnt67q13+596pS/XkRfnsiDgHWi610dS/DG9TB0gACrDgpTKVR/Gez0X6TgC5kBwPKtidAIGzOHdV9r68Gt9GbVGX3BVH01Ahv/NV/00h5W2f6nxFQ+aMyKvWCpbV8w1S6MslqGBJdRwlsjY04z4RrFYZIgK7a9AZKjndxLEzFoYadmhT4wwgQN7rU1YG+6NDsvAFSYsbIS8F6z8qt9pnCgfsGpn3VFdYs+474YsAA4J8YHyqE8Da4weX03i58eUCSlmROdF83YdrNqTKhe5ynqmvKV3fz5q7dXLhxxin0wNCw1VgdAS4ZKKhBqND2JbqxOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzGbV1Y+izaVhNno1rloSbDdToEa/yA7HcTMpBVtQxY=;
 b=KOdrhSZ1dQqJIizpgbZme0tfHcN1dwktlKLa+U47lE81yQ/9IMiwaSzPlWUWl2AQtUqZiksC178paeSH/8vpdTg1riTn6dDVwcdp5n5DjpXB80JDes+JBPZtoSEnmLU9Hb5TAkuxZiPA1uFz280cfqwQefclvwcdrBjCBuiViOI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:26 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/16] net/mlx5: E-Switch, Refactor chains and priorities
Thread-Topic: [net-next 15/16] net/mlx5: E-Switch, Refactor chains and
 priorities
Thread-Index: AQHVzMoZV71R5ZBgz0uflxuhpunNfw==
Date:   Fri, 17 Jan 2020 00:07:25 +0000
Message-ID: <20200117000619.696775-16-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 71fdc712-2bb1-43a3-996f-08d79ae13bc4
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49907FD86EE4D2D1A2817A50BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(30864003)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jVsJ8NGhagBMKMSYEOCWCk5ogs6YgptHjv/SSHPhSIwv32Jusp0rzPv486xyNRea5cpNWgPeBAhDgRU1CJ+4te+BPqRiE5oLpoJN8qC7xE9xglw6D9rFIX61eAHBgf0YdLk5Pu1uqdabJDu4bxDyBtNt8pCltcs+7uIpAx997Fyxj1JSPxPPaUXhh5HJn5ZEsY/uYMYLQQ/Anq/ZKW+pfF8sgWmY2S/N565WnAc2D9XuzmiMLJmsoCPqU1BRT12SqwcOw8kaPwFcb6VDRf7joEaNDRMJwdhefBZIn83/q7R6hoO8icXgnYxi/Ikhzt9l5YFzt3s925uJh0g6NKhLiJMHc/bxXNe1dZ3WImYCjUE7BZ/uAnfvCHv7GeuJWUBpQ4YSPo9s6NAQhHFkjW8/q2c7GFtgzwn5fw0M2opSa8NI/nqeuQa7I8tWx/Qb1v8f5U8tRdW8sKVcKbCs+cssBab0B9o8d2gE3kLgjGSqIumg4vOVWmR7wRMWOS4jFNJg1+m4iaTBX4z5+1eBieX6y2MxBbV1hTpau9xT4cjtTDl6BgkSsyF1HMAYRdDujqQv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fdc712-2bb1-43a3-996f-08d79ae13bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:25.9352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gS0eqYkLHa2sEeE6FzGwraWRKtWRWZ8cWpkTW5iXbUoeoWkN/f2eGNZVy5n3F1B+pEz1aspNaXJ7vW62EKJ9ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

To support the entire chain and prio range (32bit + 16bit),
instead of a using a static array of chains/prios of limited size, create
them dynamically, and use a rhashtable to search for existing chains/prio
combinations.

This will be used in next patch to actually increase the number using
unamanged tables support and ignore flow level capability.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  14 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  30 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 303 ++--------
 .../mlx5/core/eswitch_offloads_chains.c       | 542 ++++++++++++++++++
 .../mlx5/core/eswitch_offloads_chains.h       |  27 +
 7 files changed, 637 insertions(+), 292 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offload=
s_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offload=
s_chains.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index a6f390fdb971..d3e06cec8317 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -42,7 +42,7 @@ mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D en/hv_vhca_=
stats.o
 # Core extra
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch_offloads.o eswit=
ch_offloads_termtbl.o \
-				      ecpf.o rdma.o
+				      ecpf.o rdma.o eswitch_offloads_chains.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 5d93c506ae8b..446eb4d6c983 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -41,6 +41,7 @@
 #include <net/ipv6_stubs.h>
=20
 #include "eswitch.h"
+#include "eswitch_offloads_chains.h"
 #include "en.h"
 #include "en_rep.h"
 #include "en_tc.h"
@@ -1262,25 +1263,25 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type=
 type, void *type_data,
 	case TC_SETUP_CLSFLOWER:
 		memcpy(&tmp, f, sizeof(*f));
=20
-		if (!mlx5_eswitch_prios_supported(esw) ||
+		if (!mlx5_esw_chains_prios_supported(esw) ||
 		    tmp.common.chain_index)
 			return -EOPNOTSUPP;
=20
 		/* Re-use tc offload path by moving the ft flow to the
 		 * reserved ft chain.
 		 *
-		 * FT offload can use prio range [0, INT_MAX], so we
-		 * normalize it to range [1, mlx5_eswitch_get_prio_range(esw)]
+		 * FT offload can use prio range [0, INT_MAX], so we normalize
+		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
 		 * as with tc, where prio 0 isn't supported.
 		 *
 		 * We only support chain 0 of FT offload.
 		 */
-		if (tmp.common.prio >=3D mlx5_eswitch_get_prio_range(esw))
+		if (tmp.common.prio >=3D mlx5_esw_chains_get_prio_range(esw))
 			return -EOPNOTSUPP;
 		if (tmp.common.chain_index !=3D 0)
 			return -EOPNOTSUPP;
=20
-		tmp.common.chain_index =3D mlx5_eswitch_get_ft_chain(esw);
+		tmp.common.chain_index =3D mlx5_esw_chains_get_ft_chain(esw);
 		tmp.common.prio++;
 		err =3D mlx5e_rep_setup_tc_cls_flower(priv, &tmp, flags);
 		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 5aafbb8d2e8e..26f559b453dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -51,6 +51,7 @@
 #include "en_rep.h"
 #include "en_tc.h"
 #include "eswitch.h"
+#include "eswitch_offloads_chains.h"
 #include "fs_core.h"
 #include "en/port.h"
 #include "en/tc_tun.h"
@@ -1083,7 +1084,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *es=
w,
 	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
 	slow_attr->action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->split_count =3D 0;
-	slow_attr->dest_chain =3D FDB_TC_SLOW_PATH_CHAIN;
+	slow_attr->flags |=3D MLX5_ESW_ATTR_FLAG_SLOW_PATH;
=20
 	rule =3D mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
 	if (!IS_ERR(rule))
@@ -1100,7 +1101,7 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch=
 *esw,
 	memcpy(slow_attr, flow->esw_attr, sizeof(*slow_attr));
 	slow_attr->action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->split_count =3D 0;
-	slow_attr->dest_chain =3D FDB_TC_SLOW_PATH_CHAIN;
+	slow_attr->flags |=3D MLX5_ESW_ATTR_FLAG_SLOW_PATH;
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
 	flow_flag_clear(flow, SLOW);
 }
@@ -1160,19 +1161,18 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
-	u32 max_chain =3D mlx5_eswitch_get_chain_range(esw);
 	struct mlx5_esw_flow_attr *attr =3D flow->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr =3D attr->parse_attr;
-	u16 max_prio =3D mlx5_eswitch_get_prio_range(esw);
 	struct net_device *out_dev, *encap_dev =3D NULL;
 	struct mlx5_fc *counter =3D NULL;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *out_priv;
 	bool encap_valid =3D true;
+	u32 max_prio, max_chain;
 	int err =3D 0;
 	int out_index;
=20
-	if (!mlx5_eswitch_prios_supported(esw) && attr->prio !=3D 1) {
+	if (!mlx5_esw_chains_prios_supported(esw) && attr->prio !=3D 1) {
 		NL_SET_ERR_MSG(extack, "E-switch priorities unsupported, upgrade FW");
 		return -EOPNOTSUPP;
 	}
@@ -1182,11 +1182,13 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 * FDB_FT_CHAIN which is outside tc range.
 	 * See mlx5e_rep_setup_ft_cb().
 	 */
+	max_chain =3D mlx5_esw_chains_get_chain_range(esw);
 	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
 		NL_SET_ERR_MSG(extack, "Requested chain is out of supported range");
 		return -EOPNOTSUPP;
 	}
=20
+	max_prio =3D mlx5_esw_chains_get_prio_range(esw);
 	if (attr->prio > max_prio) {
 		NL_SET_ERR_MSG(extack, "Requested priority is out of supported range");
 		return -EOPNOTSUPP;
@@ -3469,7 +3471,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *pr=
iv,
 			break;
 		case FLOW_ACTION_GOTO: {
 			u32 dest_chain =3D act->chain_index;
-			u32 max_chain =3D mlx5_eswitch_get_chain_range(esw);
+			u32 max_chain =3D mlx5_esw_chains_get_chain_range(esw);
=20
 			if (ft_flow) {
 				NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 69ff3031d1c0..4472710ccc9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -157,7 +157,7 @@ enum offloads_fdb_flags {
 	ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED =3D BIT(0),
 };
=20
-extern const unsigned int ESW_POOLS[4];
+struct mlx5_esw_chains_priv;
=20
 struct mlx5_eswitch_fdb {
 	union {
@@ -182,14 +182,7 @@ struct mlx5_eswitch_fdb {
 			struct mlx5_flow_handle *miss_rule_multi;
 			int vlan_push_pop_refcount;
=20
-			struct {
-				struct mlx5_flow_table *fdb;
-				u32 num_rules;
-			} fdb_prio[FDB_NUM_CHAINS][FDB_TC_MAX_PRIO + 1][FDB_TC_LEVELS_PER_PRIO]=
;
-			/* Protects fdb_prio table */
-			struct mutex fdb_prio_lock;
-
-			int fdb_left[ARRAY_SIZE(ESW_POOLS)];
+			struct mlx5_esw_chains_priv *esw_chains_priv;
 		} offloads;
 	};
 	u32 flags;
@@ -355,18 +348,6 @@ mlx5_eswitch_del_fwd_rule(struct mlx5_eswitch *esw,
 			  struct mlx5_flow_handle *rule,
 			  struct mlx5_esw_flow_attr *attr);
=20
-bool
-mlx5_eswitch_prios_supported(struct mlx5_eswitch *esw);
-
-u16
-mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw);
-
-u32
-mlx5_eswitch_get_chain_range(struct mlx5_eswitch *esw);
-
-unsigned int
-mlx5_eswitch_get_ft_chain(struct mlx5_eswitch *esw);
-
 struct mlx5_flow_handle *
 mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 				  struct mlx5_flow_destination *dest);
@@ -391,6 +372,11 @@ enum {
 	MLX5_ESW_DEST_ENCAP_VALID   =3D BIT(1),
 };
=20
+enum {
+	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  =3D BIT(0),
+	MLX5_ESW_ATTR_FLAG_SLOW_PATH     =3D BIT(1),
+};
+
 struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_core_dev	*in_mdev;
@@ -404,7 +390,6 @@ struct mlx5_esw_flow_attr {
 	u16	vlan_vid[MLX5_FS_VLAN_DEPTH];
 	u8	vlan_prio[MLX5_FS_VLAN_DEPTH];
 	u8	total_vlan;
-	bool	vlan_handled;
 	struct {
 		u32 flags;
 		struct mlx5_eswitch_rep *rep;
@@ -419,6 +404,7 @@ struct mlx5_esw_flow_attr {
 	u32	chain;
 	u16	prio;
 	u32	dest_chain;
+	u32	flags;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 81bafd4b44bb..47f8729197e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -37,6 +37,7 @@
 #include <linux/mlx5/fs.h>
 #include "mlx5_core.h"
 #include "eswitch.h"
+#include "eswitch_offloads_chains.h"
 #include "rdma.h"
 #include "en.h"
 #include "fs_core.h"
@@ -47,10 +48,6 @@
  * one for multicast.
  */
 #define MLX5_ESW_MISS_FLOWS (2)
-
-#define fdb_prio_table(esw, chain, prio, level) \
-	(esw)->fdb_table.offloads.fdb_prio[(chain)][(prio)][(level)]
-
 #define UPLINK_REP_INDEX 0
=20
 static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *=
esw,
@@ -62,37 +59,6 @@ static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(str=
uct mlx5_eswitch *esw,
 	return &esw->offloads.vport_reps[idx];
 }
=20
-static struct mlx5_flow_table *
-esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int leve=
l);
-static void
-esw_put_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int leve=
l);
-
-bool mlx5_eswitch_prios_supported(struct mlx5_eswitch *esw)
-{
-	return (!!(esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED));
-}
-
-u32 mlx5_eswitch_get_chain_range(struct mlx5_eswitch *esw)
-{
-	if (esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)
-		return FDB_TC_MAX_CHAIN;
-
-	return 0;
-}
-
-u32 mlx5_eswitch_get_ft_chain(struct mlx5_eswitch *esw)
-{
-	return mlx5_eswitch_get_chain_range(esw) + 1;
-}
-
-u16 mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw)
-{
-	if (esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)
-		return FDB_TC_MAX_PRIO;
-
-	return 1;
-}
-
 static bool
 esw_check_ingress_prio_tag_enabled(const struct mlx5_eswitch *esw,
 				   const struct mlx5_vport *vport)
@@ -180,10 +146,17 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *=
esw,
 	}
=20
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-		if (attr->dest_chain) {
-			struct mlx5_flow_table *ft;
+		struct mlx5_flow_table *ft;
=20
-			ft =3D esw_get_prio_table(esw, attr->dest_chain, 1, 0);
+		if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
+			flow_act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
+			dest[i].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+			dest[i].ft =3D esw->fdb_table.offloads.slow_fdb;
+			i++;
+		} else if (attr->dest_chain) {
+			flow_act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
+			ft =3D mlx5_esw_chains_get_table(esw, attr->dest_chain,
+						       1, 0);
 			if (IS_ERR(ft)) {
 				rule =3D ERR_CAST(ft);
 				goto err_create_goto_table;
@@ -228,7 +201,8 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *es=
w,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr =3D attr->modify_hdr;
=20
-	fdb =3D esw_get_prio_table(esw, attr->chain, attr->prio, !!split);
+	fdb =3D mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
+					!!split);
 	if (IS_ERR(fdb)) {
 		rule =3D ERR_CAST(fdb);
 		goto err_esw_get;
@@ -247,10 +221,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *=
esw,
 	return rule;
=20
 err_add_rule:
-	esw_put_prio_table(esw, attr->chain, attr->prio, !!split);
+	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, !!split);
 err_esw_get:
-	if (attr->dest_chain)
-		esw_put_prio_table(esw, attr->dest_chain, 1, 0);
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
+		mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
 err_create_goto_table:
 	return rule;
 }
@@ -267,13 +241,13 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	struct mlx5_flow_handle *rule;
 	int i;
=20
-	fast_fdb =3D esw_get_prio_table(esw, attr->chain, attr->prio, 0);
+	fast_fdb =3D mlx5_esw_chains_get_table(esw, attr->chain, attr->prio, 0);
 	if (IS_ERR(fast_fdb)) {
 		rule =3D ERR_CAST(fast_fdb);
 		goto err_get_fast;
 	}
=20
-	fwd_fdb =3D esw_get_prio_table(esw, attr->chain, attr->prio, 1);
+	fwd_fdb =3D mlx5_esw_chains_get_table(esw, attr->chain, attr->prio, 1);
 	if (IS_ERR(fwd_fdb)) {
 		rule =3D ERR_CAST(fwd_fdb);
 		goto err_get_fwd;
@@ -310,9 +284,9 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
=20
 	return rule;
 add_err:
-	esw_put_prio_table(esw, attr->chain, attr->prio, 1);
+	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 1);
 err_get_fwd:
-	esw_put_prio_table(esw, attr->chain, attr->prio, 0);
+	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 err_get_fast:
 	return rule;
 }
@@ -337,12 +311,13 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	atomic64_dec(&esw->offloads.num_flows);
=20
 	if (fwd_rule)  {
-		esw_put_prio_table(esw, attr->chain, attr->prio, 1);
-		esw_put_prio_table(esw, attr->chain, attr->prio, 0);
+		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 1);
+		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 	} else {
-		esw_put_prio_table(esw, attr->chain, attr->prio, !!split);
+		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
+					  !!split);
 		if (attr->dest_chain)
-			esw_put_prio_table(esw, attr->dest_chain, 1, 0);
+			mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
 	}
 }
=20
@@ -456,7 +431,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *e=
sw,
 	if (err)
 		goto unlock;
=20
-	attr->vlan_handled =3D false;
+	attr->flags &=3D ~MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
=20
 	vport =3D esw_vlan_action_get_vport(attr, push, pop);
=20
@@ -464,7 +439,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *e=
sw,
 		/* tracks VF --> wire rules without vlan push action */
 		if (attr->dests[0].rep->vport =3D=3D MLX5_VPORT_UPLINK) {
 			vport->vlan_refcount++;
-			attr->vlan_handled =3D true;
+			attr->flags |=3D MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
 		}
=20
 		goto unlock;
@@ -495,7 +470,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *e=
sw,
 	}
 out:
 	if (!err)
-		attr->vlan_handled =3D true;
+		attr->flags |=3D MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
 unlock:
 	mutex_unlock(&esw->state_lock);
 	return err;
@@ -513,7 +488,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *e=
sw,
 	if (mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
 		return 0;
=20
-	if (!attr->vlan_handled)
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_VLAN_HANDLED))
 		return 0;
=20
 	push =3D !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH);
@@ -587,8 +562,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch=
 *esw, u16 vport,
 	dest.vport.num =3D vport;
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
=20
-	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb, spec,
-					&flow_act, &dest, 1);
+	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule))
 		esw_warn(esw->dev, "FDB: Failed to add send to vport rule err %ld\n", PT=
R_ERR(flow_rule));
 out:
@@ -829,8 +804,8 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *e=
sw)
 	dest.vport.num =3D esw->manager_vport;
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
=20
-	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb, spec,
-					&flow_act, &dest, 1);
+	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule)) {
 		err =3D PTR_ERR(flow_rule);
 		esw_warn(esw->dev,  "FDB: Failed to add unicast miss flow rule err %d\n"=
, err);
@@ -844,8 +819,8 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *e=
sw)
 	dmac_v =3D MLX5_ADDR_OF(fte_match_param, headers_v,
 			      outer_headers.dmac_47_16);
 	dmac_v[0] =3D 0x01;
-	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb, spec,
-					&flow_act, &dest, 1);
+	flow_rule =3D mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule)) {
 		err =3D PTR_ERR(flow_rule);
 		esw_warn(esw->dev, "FDB: Failed to add multicast miss flow rule err %d\n=
", err);
@@ -860,175 +835,6 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch =
*esw)
 	return err;
 }
=20
-#define ESW_OFFLOADS_NUM_GROUPS  4
-
-/* Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
- * and a virtual memory region of 16M (ESW_SIZE), this region is duplicate=
d
- * for each flow table pool. We can allocate up to 16M of each pool,
- * and we keep track of how much we used via put/get_sz_to_pool.
- * Firmware doesn't report any of this for now.
- * ESW_POOL is expected to be sorted from large to small
- */
-#define ESW_SIZE (16 * 1024 * 1024)
-const unsigned int ESW_POOLS[4] =3D { 4 * 1024 * 1024, 1 * 1024 * 1024,
-				    64 * 1024, 4 * 1024 };
-
-static int
-get_sz_from_pool(struct mlx5_eswitch *esw)
-{
-	int sz =3D 0, i;
-
-	for (i =3D 0; i < ARRAY_SIZE(ESW_POOLS); i++) {
-		if (esw->fdb_table.offloads.fdb_left[i]) {
-			--esw->fdb_table.offloads.fdb_left[i];
-			sz =3D ESW_POOLS[i];
-			break;
-		}
-	}
-
-	return sz;
-}
-
-static void
-put_sz_to_pool(struct mlx5_eswitch *esw, int sz)
-{
-	int i;
-
-	for (i =3D 0; i < ARRAY_SIZE(ESW_POOLS); i++) {
-		if (sz >=3D ESW_POOLS[i]) {
-			++esw->fdb_table.offloads.fdb_left[i];
-			break;
-		}
-	}
-}
-
-static struct mlx5_flow_table *
-create_next_size_table(struct mlx5_eswitch *esw,
-		       struct mlx5_flow_namespace *ns,
-		       u16 table_prio,
-		       int level,
-		       u32 flags)
-{
-	struct mlx5_flow_table_attr ft_attr =3D {};
-	struct mlx5_flow_table *fdb;
-	int sz;
-
-	sz =3D get_sz_from_pool(esw);
-	if (!sz)
-		return ERR_PTR(-ENOSPC);
-
-	ft_attr.max_fte =3D sz;
-	ft_attr.prio =3D table_prio;
-	ft_attr.level =3D level;
-	ft_attr.flags =3D flags;
-	ft_attr.autogroup.max_num_groups =3D ESW_OFFLOADS_NUM_GROUPS;
-	fdb =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
-	if (IS_ERR(fdb)) {
-		esw_warn(esw->dev, "Failed to create FDB Table err %d (table prio: %d, l=
evel: %d, size: %d)\n",
-			 (int)PTR_ERR(fdb), table_prio, level, sz);
-		put_sz_to_pool(esw, sz);
-	}
-
-	return fdb;
-}
-
-static struct mlx5_flow_table *
-esw_get_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int leve=
l)
-{
-	struct mlx5_core_dev *dev =3D esw->dev;
-	struct mlx5_flow_table *fdb =3D NULL;
-	struct mlx5_flow_namespace *ns;
-	int table_prio, l =3D 0;
-	u32 flags =3D 0;
-
-	if (chain =3D=3D FDB_TC_SLOW_PATH_CHAIN)
-		return esw->fdb_table.offloads.slow_fdb;
-
-	mutex_lock(&esw->fdb_table.offloads.fdb_prio_lock);
-
-	fdb =3D fdb_prio_table(esw, chain, prio, level).fdb;
-	if (fdb) {
-		/* take ref on earlier levels as well */
-		while (level >=3D 0)
-			fdb_prio_table(esw, chain, prio, level--).num_rules++;
-		mutex_unlock(&esw->fdb_table.offloads.fdb_prio_lock);
-		return fdb;
-	}
-
-	ns =3D mlx5_get_fdb_sub_ns(dev, chain);
-	if (!ns) {
-		esw_warn(dev, "Failed to get FDB sub namespace\n");
-		mutex_unlock(&esw->fdb_table.offloads.fdb_prio_lock);
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	if (esw->offloads.encap !=3D DEVLINK_ESWITCH_ENCAP_MODE_NONE)
-		flags |=3D (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
-			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
-
-	table_prio =3D prio - 1;
-
-	/* create earlier levels for correct fs_core lookup when
-	 * connecting tables
-	 */
-	for (l =3D 0; l <=3D level; l++) {
-		if (fdb_prio_table(esw, chain, prio, l).fdb) {
-			fdb_prio_table(esw, chain, prio, l).num_rules++;
-			continue;
-		}
-
-		fdb =3D create_next_size_table(esw, ns, table_prio, l, flags);
-		if (IS_ERR(fdb)) {
-			l--;
-			goto err_create_fdb;
-		}
-
-		fdb_prio_table(esw, chain, prio, l).fdb =3D fdb;
-		fdb_prio_table(esw, chain, prio, l).num_rules =3D 1;
-	}
-
-	mutex_unlock(&esw->fdb_table.offloads.fdb_prio_lock);
-	return fdb;
-
-err_create_fdb:
-	mutex_unlock(&esw->fdb_table.offloads.fdb_prio_lock);
-	if (l >=3D 0)
-		esw_put_prio_table(esw, chain, prio, l);
-
-	return fdb;
-}
-
-static void
-esw_put_prio_table(struct mlx5_eswitch *esw, u32 chain, u16 prio, int leve=
l)
-{
-	int l;
-
-	if (chain =3D=3D FDB_TC_SLOW_PATH_CHAIN)
-		return;
-
-	mutex_lock(&esw->fdb_table.offloads.fdb_prio_lock);
-
-	for (l =3D level; l >=3D 0; l--) {
-		if (--(fdb_prio_table(esw, chain, prio, l).num_rules) > 0)
-			continue;
-
-		put_sz_to_pool(esw, fdb_prio_table(esw, chain, prio, l).fdb->max_fte);
-		mlx5_destroy_flow_table(fdb_prio_table(esw, chain, prio, l).fdb);
-		fdb_prio_table(esw, chain, prio, l).fdb =3D NULL;
-	}
-
-	mutex_unlock(&esw->fdb_table.offloads.fdb_prio_lock);
-}
-
-static void esw_destroy_offloads_fast_fdb_tables(struct mlx5_eswitch *esw)
-{
-	/* If lazy creation isn't supported, deref the fast path tables */
-	if (!(esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)) {
-		esw_put_prio_table(esw, 0, 1, 1);
-		esw_put_prio_table(esw, 0, 1, 0);
-	}
-}
-
 #define MAX_PF_SQ 256
 #define MAX_SQ_NVPORTS 32
=20
@@ -1061,16 +867,16 @@ static int esw_create_offloads_fdb_tables(struct mlx=
5_eswitch *esw, int nvports)
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_core_dev *dev =3D esw->dev;
-	u32 *flow_group_in, max_flow_counter;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *fdb =3D NULL;
-	int table_size, ix, err =3D 0, i;
+	u32 flags =3D 0, *flow_group_in;
+	int table_size, ix, err =3D 0;
 	struct mlx5_flow_group *g;
-	u32 flags =3D 0, fdb_max;
 	void *match_criteria;
 	u8 *dmac;
=20
 	esw_debug(esw->dev, "Create offloads FDB Tables\n");
+
 	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
@@ -1089,19 +895,6 @@ static int esw_create_offloads_fdb_tables(struct mlx5=
_eswitch *esw, int nvports)
 		goto ns_err;
 	}
=20
-	max_flow_counter =3D (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
-			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
-	fdb_max =3D 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
-
-	esw_debug(dev, "Create offloads FDB table, min (max esw size(2^%d), max c=
ounters(%d), groups(%d), max flow table size(%d))\n",
-		  MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size),
-		  max_flow_counter, ESW_OFFLOADS_NUM_GROUPS,
-		  fdb_max);
-
-	for (i =3D 0; i < ARRAY_SIZE(ESW_POOLS); i++)
-		esw->fdb_table.offloads.fdb_left[i] =3D
-			ESW_POOLS[i] <=3D fdb_max ? ESW_SIZE / ESW_POOLS[i] : 0;
-
 	table_size =3D nvports * MAX_SQ_NVPORTS + MAX_PF_SQ +
 		MLX5_ESW_MISS_FLOWS + esw->total_vports;
=20
@@ -1124,16 +917,10 @@ static int esw_create_offloads_fdb_tables(struct mlx=
5_eswitch *esw, int nvports)
 	}
 	esw->fdb_table.offloads.slow_fdb =3D fdb;
=20
-	/* If lazy creation isn't supported, open the fast path tables now */
-	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, multi_fdb_encap) &&
-	    esw->offloads.encap !=3D DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
-		esw->fdb_table.flags &=3D ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
-		esw_warn(dev, "Lazy creation of flow tables isn't supported, ignoring pr=
iorities\n");
-		esw_get_prio_table(esw, 0, 1, 0);
-		esw_get_prio_table(esw, 0, 1, 1);
-	} else {
-		esw_debug(dev, "Lazy creation of flow tables supported, deferring table =
opening\n");
-		esw->fdb_table.flags |=3D ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
+	err =3D mlx5_esw_chains_create(esw);
+	if (err) {
+		esw_warn(dev, "Failed to create fdb chains err(%d)\n", err);
+		goto fdb_chains_err;
 	}
=20
 	/* create send-to-vport group */
@@ -1224,7 +1011,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5=
_eswitch *esw, int nvports)
 peer_miss_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 send_vport_err:
-	esw_destroy_offloads_fast_fdb_tables(esw);
+	mlx5_esw_chains_destroy(esw);
+fdb_chains_err:
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 slow_fdb_err:
 	/* Holds true only as long as DMFS is the default */
@@ -1246,8 +1034,8 @@ static void esw_destroy_offloads_fdb_tables(struct ml=
x5_eswitch *esw)
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
=20
+	mlx5_esw_chains_destroy(esw);
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
-	esw_destroy_offloads_fast_fdb_tables(esw);
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
 				     MLX5_FLOW_STEERING_MODE_DMFS);
@@ -2117,7 +1905,6 @@ static int esw_offloads_steering_init(struct mlx5_esw=
itch *esw)
 		total_vports =3D num_vfs + MLX5_SPECIAL_VPORTS(esw->dev);
=20
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
-	mutex_init(&esw->fdb_table.offloads.fdb_prio_lock);
=20
 	err =3D esw_create_uplink_offloads_acl_tables(esw);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
new file mode 100644
index 000000000000..a694cc52d94c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -0,0 +1,542 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/fs.h>
+
+#include "eswitch_offloads_chains.h"
+#include "mlx5_core.h"
+#include "fs_core.h"
+#include "eswitch.h"
+#include "en.h"
+
+#define esw_chains_priv(esw) ((esw)->fdb_table.offloads.esw_chains_priv)
+#define esw_chains_lock(esw) (esw_chains_priv(esw)->lock)
+#define esw_chains_ht(esw) (esw_chains_priv(esw)->chains_ht)
+#define esw_prios_ht(esw) (esw_chains_priv(esw)->prios_ht)
+#define fdb_pool_left(esw) (esw_chains_priv(esw)->fdb_left)
+
+#define ESW_OFFLOADS_NUM_GROUPS  4
+
+/* Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
+ * and a virtual memory region of 16M (ESW_SIZE), this region is duplicate=
d
+ * for each flow table pool. We can allocate up to 16M of each pool,
+ * and we keep track of how much we used via get_next_avail_sz_from_pool.
+ * Firmware doesn't report any of this for now.
+ * ESW_POOL is expected to be sorted from large to small and match firmwar=
e
+ * pools.
+ */
+#define ESW_SIZE (16 * 1024 * 1024)
+const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
+				   1 * 1024 * 1024,
+				   64 * 1024,
+				   4 * 1024, };
+
+struct mlx5_esw_chains_priv {
+	struct rhashtable chains_ht;
+	struct rhashtable prios_ht;
+	/* Protects above chains_ht and prios_ht */
+	struct mutex lock;
+
+	int fdb_left[ARRAY_SIZE(ESW_POOLS)];
+};
+
+struct fdb_chain {
+	struct rhash_head node;
+
+	u32 chain;
+
+	int ref;
+
+	struct mlx5_eswitch *esw;
+};
+
+struct fdb_prio_key {
+	u32 chain;
+	u32 prio;
+	u32 level;
+};
+
+struct fdb_prio {
+	struct rhash_head node;
+
+	struct fdb_prio_key key;
+
+	int ref;
+
+	struct fdb_chain *fdb_chain;
+	struct mlx5_flow_table *fdb;
+};
+
+static const struct rhashtable_params chain_params =3D {
+	.head_offset =3D offsetof(struct fdb_chain, node),
+	.key_offset =3D offsetof(struct fdb_chain, chain),
+	.key_len =3D sizeof_field(struct fdb_chain, chain),
+	.automatic_shrinking =3D true,
+};
+
+static const struct rhashtable_params prio_params =3D {
+	.head_offset =3D offsetof(struct fdb_prio, node),
+	.key_offset =3D offsetof(struct fdb_prio, key),
+	.key_len =3D sizeof_field(struct fdb_prio, key),
+	.automatic_shrinking =3D true,
+};
+
+bool mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw)
+{
+	return esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
+}
+
+u32 mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw)
+{
+	if (!mlx5_esw_chains_prios_supported(esw))
+		return 1;
+
+	return FDB_TC_MAX_CHAIN;
+}
+
+u32 mlx5_esw_chains_get_ft_chain(struct mlx5_eswitch *esw)
+{
+	return mlx5_esw_chains_get_chain_range(esw) + 1;
+}
+
+u32 mlx5_esw_chains_get_prio_range(struct mlx5_eswitch *esw)
+{
+	if (!mlx5_esw_chains_prios_supported(esw))
+		return 1;
+
+	return FDB_TC_MAX_PRIO;
+}
+
+static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *e=
sw)
+{
+	return FDB_TC_LEVELS_PER_PRIO;
+}
+
+#define POOL_NEXT_SIZE 0
+static int
+mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw,
+				       int desired_size)
+{
+	int i, found_i =3D -1;
+
+	for (i =3D ARRAY_SIZE(ESW_POOLS) - 1; i >=3D 0; i--) {
+		if (fdb_pool_left(esw)[i] && ESW_POOLS[i] > desired_size) {
+			found_i =3D i;
+			if (desired_size !=3D POOL_NEXT_SIZE)
+				break;
+		}
+	}
+
+	if (found_i !=3D -1) {
+		--fdb_pool_left(esw)[found_i];
+		return ESW_POOLS[found_i];
+	}
+
+	return 0;
+}
+
+static void
+mlx5_esw_chains_put_sz_to_pool(struct mlx5_eswitch *esw, int sz)
+{
+	int i;
+
+	for (i =3D ARRAY_SIZE(ESW_POOLS) - 1; i >=3D 0; i--) {
+		if (sz =3D=3D ESW_POOLS[i]) {
+			++fdb_pool_left(esw)[i];
+			return;
+		}
+	}
+
+	WARN_ONCE(1, "Couldn't find size %d in fdb size pool", sz);
+}
+
+static void
+mlx5_esw_chains_init_sz_pool(struct mlx5_eswitch *esw)
+{
+	u32 fdb_max;
+	int i;
+
+	fdb_max =3D 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, log_max_ft_size);
+
+	for (i =3D ARRAY_SIZE(ESW_POOLS) - 1; i >=3D 0; i--)
+		fdb_pool_left(esw)[i] =3D
+			ESW_POOLS[i] <=3D fdb_max ? ESW_SIZE / ESW_POOLS[i] : 0;
+}
+
+static struct mlx5_flow_table *
+mlx5_esw_chains_create_fdb_table(struct mlx5_eswitch *esw,
+				 u32 chain, u32 prio, u32 level)
+{
+	struct mlx5_flow_table_attr ft_attr =3D {};
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *fdb;
+	int sz;
+
+	if (esw->offloads.encap !=3D DEVLINK_ESWITCH_ENCAP_MODE_NONE)
+		ft_attr.flags |=3D (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
+
+	sz =3D mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
+	if (!sz)
+		return ERR_PTR(-ENOSPC);
+
+	ft_attr.max_fte =3D sz;
+	ft_attr.level =3D level;
+	ft_attr.prio =3D prio - 1;
+	ft_attr.autogroup.max_num_groups =3D ESW_OFFLOADS_NUM_GROUPS;
+	ns =3D mlx5_get_fdb_sub_ns(esw->dev, chain);
+
+	fdb =3D mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(fdb)) {
+		esw_warn(esw->dev,
+			 "Failed to create FDB table err %d (chain: %d, prio: %d, level: %d, si=
ze: %d)\n",
+			 (int)PTR_ERR(fdb), chain, prio, level, sz);
+		mlx5_esw_chains_put_sz_to_pool(esw, sz);
+		return fdb;
+	}
+
+	return fdb;
+}
+
+static void
+mlx5_esw_chains_destroy_fdb_table(struct mlx5_eswitch *esw,
+				  struct mlx5_flow_table *fdb)
+{
+	mlx5_esw_chains_put_sz_to_pool(esw, fdb->max_fte);
+	mlx5_destroy_flow_table(fdb);
+}
+
+static struct fdb_chain *
+mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
+{
+	struct fdb_chain *fdb_chain =3D NULL;
+	int err;
+
+	fdb_chain =3D kvzalloc(sizeof(*fdb_chain), GFP_KERNEL);
+	if (!fdb_chain)
+		return ERR_PTR(-ENOMEM);
+
+	fdb_chain->esw =3D esw;
+	fdb_chain->chain =3D chain;
+
+	err =3D rhashtable_insert_fast(&esw_chains_ht(esw), &fdb_chain->node,
+				     chain_params);
+	if (err)
+		goto err_insert;
+
+	return fdb_chain;
+
+err_insert:
+	kvfree(fdb_chain);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_esw_chains_destroy_fdb_chain(struct fdb_chain *fdb_chain)
+{
+	struct mlx5_eswitch *esw =3D fdb_chain->esw;
+
+	rhashtable_remove_fast(&esw_chains_ht(esw), &fdb_chain->node,
+			       chain_params);
+	kvfree(fdb_chain);
+}
+
+static struct fdb_chain *
+mlx5_esw_chains_get_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
+{
+	struct fdb_chain *fdb_chain;
+
+	fdb_chain =3D rhashtable_lookup_fast(&esw_chains_ht(esw), &chain,
+					   chain_params);
+	if (!fdb_chain) {
+		fdb_chain =3D mlx5_esw_chains_create_fdb_chain(esw, chain);
+		if (IS_ERR(fdb_chain))
+			return fdb_chain;
+	}
+
+	fdb_chain->ref++;
+
+	return fdb_chain;
+}
+
+static void
+mlx5_esw_chains_put_fdb_chain(struct fdb_chain *fdb_chain)
+{
+	if (--fdb_chain->ref =3D=3D 0)
+		mlx5_esw_chains_destroy_fdb_chain(fdb_chain);
+}
+
+static struct fdb_prio *
+mlx5_esw_chains_create_fdb_prio(struct mlx5_eswitch *esw,
+				u32 chain, u32 prio, u32 level)
+{
+	struct fdb_prio *fdb_prio =3D NULL;
+	struct fdb_chain *fdb_chain;
+	struct mlx5_flow_table *fdb;
+	int err;
+
+	fdb_chain =3D mlx5_esw_chains_get_fdb_chain(esw, chain);
+	if (IS_ERR(fdb_chain))
+		return ERR_CAST(fdb_chain);
+
+	fdb_prio =3D kvzalloc(sizeof(*fdb_prio), GFP_KERNEL);
+	if (!fdb_prio) {
+		err =3D -ENOMEM;
+		goto err_alloc;
+	}
+
+	fdb =3D mlx5_esw_chains_create_fdb_table(esw, fdb_chain->chain, prio,
+					       level);
+	if (IS_ERR(fdb)) {
+		err =3D PTR_ERR(fdb);
+		goto err_create;
+	}
+
+	fdb_prio->fdb_chain =3D fdb_chain;
+	fdb_prio->key.chain =3D chain;
+	fdb_prio->key.prio =3D prio;
+	fdb_prio->key.level =3D level;
+	fdb_prio->fdb =3D fdb;
+
+	err =3D rhashtable_insert_fast(&esw_prios_ht(esw), &fdb_prio->node,
+				     prio_params);
+	if (err)
+		goto err_insert;
+
+	return fdb_prio;
+
+err_insert:
+	mlx5_esw_chains_destroy_fdb_table(esw, fdb);
+err_create:
+	kvfree(fdb_prio);
+err_alloc:
+	mlx5_esw_chains_put_fdb_chain(fdb_chain);
+	return ERR_PTR(err);
+}
+
+static void
+mlx5_esw_chains_destroy_fdb_prio(struct mlx5_eswitch *esw,
+				 struct fdb_prio *fdb_prio)
+{
+	struct fdb_chain *fdb_chain =3D fdb_prio->fdb_chain;
+
+	rhashtable_remove_fast(&esw_prios_ht(esw), &fdb_prio->node,
+			       prio_params);
+	mlx5_esw_chains_destroy_fdb_table(esw, fdb_prio->fdb);
+	mlx5_esw_chains_put_fdb_chain(fdb_chain);
+	kvfree(fdb_prio);
+}
+
+struct mlx5_flow_table *
+mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level)
+{
+	struct mlx5_flow_table *prev_fts;
+	struct fdb_prio *fdb_prio;
+	struct fdb_prio_key key;
+	int l =3D 0;
+
+	if ((chain > mlx5_esw_chains_get_chain_range(esw) &&
+	     chain !=3D mlx5_esw_chains_get_ft_chain(esw)) ||
+	    prio > mlx5_esw_chains_get_prio_range(esw) ||
+	    level > mlx5_esw_chains_get_level_range(esw))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* create earlier levels for correct fs_core lookup when
+	 * connecting tables.
+	 */
+	for (l =3D 0; l < level; l++) {
+		prev_fts =3D mlx5_esw_chains_get_table(esw, chain, prio, l);
+		if (IS_ERR(prev_fts)) {
+			fdb_prio =3D ERR_CAST(prev_fts);
+			goto err_get_prevs;
+		}
+	}
+
+	key.chain =3D chain;
+	key.prio =3D prio;
+	key.level =3D level;
+
+	mutex_lock(&esw_chains_lock(esw));
+	fdb_prio =3D rhashtable_lookup_fast(&esw_prios_ht(esw), &key,
+					  prio_params);
+	if (!fdb_prio) {
+		fdb_prio =3D mlx5_esw_chains_create_fdb_prio(esw, chain,
+							   prio, level);
+		if (IS_ERR(fdb_prio))
+			goto err_create_prio;
+	}
+
+	++fdb_prio->ref;
+	mutex_unlock(&esw_chains_lock(esw));
+
+	return fdb_prio->fdb;
+
+err_create_prio:
+	mutex_unlock(&esw_chains_lock(esw));
+err_get_prevs:
+	while (--l >=3D 0)
+		mlx5_esw_chains_put_table(esw, chain, prio, l);
+	return ERR_CAST(fdb_prio);
+}
+
+void
+mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level)
+{
+	struct fdb_prio *fdb_prio;
+	struct fdb_prio_key key;
+
+	key.chain =3D chain;
+	key.prio =3D prio;
+	key.level =3D level;
+
+	mutex_lock(&esw_chains_lock(esw));
+	fdb_prio =3D rhashtable_lookup_fast(&esw_prios_ht(esw), &key,
+					  prio_params);
+	if (!fdb_prio)
+		goto err_get_prio;
+
+	if (--fdb_prio->ref =3D=3D 0)
+		mlx5_esw_chains_destroy_fdb_prio(esw, fdb_prio);
+	mutex_unlock(&esw_chains_lock(esw));
+
+	while (level-- > 0)
+		mlx5_esw_chains_put_table(esw, chain, prio, level);
+
+	return;
+
+err_get_prio:
+	mutex_unlock(&esw_chains_lock(esw));
+	WARN_ONCE(1,
+		  "Couldn't find table: (chain: %d prio: %d level: %d)",
+		  chain, prio, level);
+}
+
+static int
+mlx5_esw_chains_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_chains_priv *chains_priv;
+	struct mlx5_core_dev *dev =3D esw->dev;
+	u32 max_flow_counter, fdb_max;
+	int err;
+
+	chains_priv =3D kzalloc(sizeof(*chains_priv), GFP_KERNEL);
+	if (!chains_priv)
+		return -ENOMEM;
+	esw_chains_priv(esw) =3D chains_priv;
+
+	max_flow_counter =3D (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
+			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
+	fdb_max =3D 1 << MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size);
+
+	esw_debug(dev,
+		  "Init esw offloads chains, max counters(%d), groups(%d), max flow tabl=
e size(%d)\n",
+		  max_flow_counter, ESW_OFFLOADS_NUM_GROUPS, fdb_max);
+
+	mlx5_esw_chains_init_sz_pool(esw);
+
+	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, multi_fdb_encap) &&
+	    esw->offloads.encap !=3D DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
+		esw->fdb_table.flags &=3D ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_warn(dev, "Tc chains and priorities offload aren't supported, update=
 firmware if needed\n");
+	} else {
+		esw->fdb_table.flags |=3D ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
+			 mlx5_esw_chains_get_chain_range(esw),
+			 mlx5_esw_chains_get_prio_range(esw));
+	}
+
+	err =3D rhashtable_init(&esw_chains_ht(esw), &chain_params);
+	if (err)
+		goto init_chains_ht_err;
+
+	err =3D rhashtable_init(&esw_prios_ht(esw), &prio_params);
+	if (err)
+		goto init_prios_ht_err;
+
+	mutex_init(&esw_chains_lock(esw));
+
+	return 0;
+
+init_prios_ht_err:
+	rhashtable_destroy(&esw_chains_ht(esw));
+init_chains_ht_err:
+	kfree(chains_priv);
+	return err;
+}
+
+static void
+mlx5_esw_chains_cleanup(struct mlx5_eswitch *esw)
+{
+	mutex_destroy(&esw_chains_lock(esw));
+	rhashtable_destroy(&esw_prios_ht(esw));
+	rhashtable_destroy(&esw_chains_ht(esw));
+
+	kfree(esw_chains_priv(esw));
+}
+
+static int
+mlx5_esw_chains_open(struct mlx5_eswitch *esw)
+{
+	struct mlx5_flow_table *ft;
+	int err;
+
+	/* Always open the root for fast path */
+	ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 0);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
+	/* Open level 1 for split rules now if prios isn't supported  */
+	if (!mlx5_esw_chains_prios_supported(esw)) {
+		ft =3D mlx5_esw_chains_get_table(esw, 0, 1, 1);
+
+		if (IS_ERR(ft)) {
+			err =3D PTR_ERR(ft);
+			goto level_1_err;
+		}
+	}
+
+	return 0;
+
+level_1_err:
+	mlx5_esw_chains_put_table(esw, 0, 1, 0);
+	return err;
+}
+
+static void
+mlx5_esw_chains_close(struct mlx5_eswitch *esw)
+{
+	if (!mlx5_esw_chains_prios_supported(esw))
+		mlx5_esw_chains_put_table(esw, 0, 1, 1);
+	mlx5_esw_chains_put_table(esw, 0, 1, 0);
+}
+
+int
+mlx5_esw_chains_create(struct mlx5_eswitch *esw)
+{
+	int err;
+
+	err =3D mlx5_esw_chains_init(esw);
+	if (err)
+		return err;
+
+	err =3D mlx5_esw_chains_open(esw);
+	if (err)
+		goto err_open;
+
+	return 0;
+
+err_open:
+	mlx5_esw_chains_cleanup(esw);
+	return err;
+}
+
+void
+mlx5_esw_chains_destroy(struct mlx5_eswitch *esw)
+{
+	mlx5_esw_chains_close(esw);
+	mlx5_esw_chains_cleanup(esw);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
new file mode 100644
index 000000000000..52fadacab84d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __ML5_ESW_CHAINS_H__
+#define __ML5_ESW_CHAINS_H__
+
+bool
+mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw);
+u32
+mlx5_esw_chains_get_prio_range(struct mlx5_eswitch *esw);
+u32
+mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw);
+u32
+mlx5_esw_chains_get_ft_chain(struct mlx5_eswitch *esw);
+
+struct mlx5_flow_table *
+mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level);
+void
+mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level);
+
+int mlx5_esw_chains_create(struct mlx5_eswitch *esw);
+void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
+
+#endif /* __ML5_ESW_CHAINS_H__ */
+
--=20
2.24.1

