Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B485E79D16
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfG2Xwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:52:31 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729910AbfG2Xwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:52:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vwrp/xwVM511vnkxGJ95hqSt+i1T3FvHjrHeAF8yA98k09vixR9hlCY2kp7f6MWTtKtmrYYkxvvsskhIqC4cL8jNO6nTKsM/4Mh+f7xLpTeRruJstvCTNes8FysZ9qt7s/IQRXxEhyS0Q6L37R+jSdEQlX9yCC/Lx+9rfO+1HhFYgLsaQIe6xAuE5G2hawjC8nnJq+N8KKTWOgkVTieOE9WvvT+oLnMOhts7dO/FIjZqs+Ubf24xO18YCelOGunpS99VSNtcyzHILw9XFDCLBPHG5KhZ7fLgY6VFOIzeK5QqMjnFspPchYOM1YOxdCVSOL375CeL2t03tlnOc6+eUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxamdalA7vNpncs2vsLV0/dRGX1rEqk+WZqd4dXlyjs=;
 b=AtodiQiEyRGcUHsQp88h5tJj1ZXc68CMabEtyERmb4bitJ2+iddhA4lPMiJcdf2vkuReoLSyuPtZBJF3DR0HhoI3LDXaZB2Mll3jiMsu2FzMrQzep/8HlMJz1s1MJiniAXLl5vp8RohQQmiVRHbqrd0LYGUactaE/bPpBfEo4p0wGOxiaYTQxaa0y0ykg8n5dAeCDpPF+43+OMyg8Rwz1RKkR8eAf0ZSwXq0pxtqU0eE2NWuNAFI4ov8gyhHh6RzFlRFRQjsSOF7AGsq/IF2bxMrTOwU9KGXc9gGk6FcqCHvp2cnWj/xUr6OwloLvmNEPQGwWgBOT021P7D8glGwjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxamdalA7vNpncs2vsLV0/dRGX1rEqk+WZqd4dXlyjs=;
 b=Bi2Cqu81nhPcmpb1hAMTy2i1odeh44cArc5hVvB9+1LO+yr4lACP0Bcs/1vfYB3cWWF6NGajogdlUz2u9wXwbqJZfgcL7W9iexzQJqAjUBdqtK5ciIcbAdN+EV/HEtCmXpqAYC/0f9/pqjuFXsWzFlJB6HEX7AkyPBG2xpZYQCE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:26 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/13] net/mlx5e: Change flow flags type to unsigned long
Thread-Topic: [net-next 07/13] net/mlx5e: Change flow flags type to unsigned
 long
Thread-Index: AQHVRmhk8lLwZBGSA0GRDClj4+OPBw==
Date:   Mon, 29 Jul 2019 23:50:26 +0000
Message-ID: <20190729234934.23595-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 608ddf17-cf13-4ec1-274c-08d7147f8742
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB234332A3DED58D9CDF6CA567BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(5024004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(30864003)(53946003)(50226002)(6116002)(3846002)(4326008)(2906002)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t8Fxdc8ZBkZOvRtRfYp7QDHv21jssRhMn92OVrrFySCOKx+NLWRlmvfknJy5YEv7VY90pBKMra1NYjqaPRkoJizuHM+o2Csue+tKn9hbsLPw0zVsjLxhJ74g7S5GmPQ3rxb7xvrQO/o20I5yDB75TrvEZ5eLHi8Yb6rdk1erYPH3Er5usIiEujfuT/UHWh3KJqGUsTI99Daj/noHMjCrKwD0GHRFBu0AixqOT4u1azPE6r8UAIIy8O++cXBXQTL6Tw1G3yIbe385r4kZlqCv2N8+s3RBpRQiypx22iRCc4xyF3SgvUUsPtgwhvE4ADEstXGKoH9BsHHpOLv30FXAzlaS584lOybHUFVb76w7Gc+GuW1yG6kjRq6homS3mV1M8rNYeYkkV4nOqIb4lPB35Yc6apmVk5d+QtNiVHf1OBY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608ddf17-cf13-4ec1-274c-08d7147f8742
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:26.2714
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

To remove dependency on rtnl lock and allow concurrent modification of
'flags' field of tc flow structure, change flow flag type to unsigned long
and use atomic bit ops for reading and changing the flags. Implement
auxiliary functions for setting, resetting and getting specific flag, and
for checking most often used flag values.

Always set flags with smp_mb__before_atomic() to ensure that all
mlx5e_tc_flow are updated before concurrent readers can read new flags
value. Rearrange all code paths to actually set flow->rule[] pointers
before setting the OFFLOADED flag. On read side, use smp_mb__after_atomic()
when accessing flags to ensure that offload-related flow fields are only
read after the flags.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 206 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  26 ++-
 4 files changed, 149 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 266783295124..b2618dd6dd10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3429,7 +3429,7 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *p=
riv,
 #ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
 				     struct flow_cls_offload *cls_flower,
-				     int flags)
+				     unsigned long flags)
 {
 	switch (cls_flower->command) {
 	case FLOW_CLS_REPLACE:
@@ -3449,12 +3449,12 @@ static int mlx5e_setup_tc_cls_flower(struct mlx5e_p=
riv *priv,
 static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_dat=
a,
 				   void *cb_priv)
 {
+	unsigned long flags =3D MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(NIC_OFFLOAD)=
;
 	struct mlx5e_priv *priv =3D cb_priv;
=20
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_setup_tc_cls_flower(priv, type_data, MLX5E_TC_INGRESS |
-						 MLX5E_TC_NIC_OFFLOAD);
+		return mlx5e_setup_tc_cls_flower(priv, type_data, flags);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3647,7 +3647,7 @@ static int set_feature_tc_num_filters(struct net_devi=
ce *netdev, bool enable)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
=20
-	if (!enable && mlx5e_tc_num_filters(priv, MLX5E_TC_NIC_OFFLOAD)) {
+	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
 		netdev_err(netdev,
 			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 496d3034e278..69f7ac8fc9be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -659,8 +659,8 @@ mlx5e_rep_indr_offload(struct net_device *netdev,
 		       struct flow_cls_offload *flower,
 		       struct mlx5e_rep_indr_block_priv *indr_priv)
 {
+	unsigned long flags =3D MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_priv *priv =3D netdev_priv(indr_priv->rpriv->netdev);
-	int flags =3D MLX5E_TC_EGRESS | MLX5E_TC_ESW_OFFLOAD;
 	int err =3D 0;
=20
 	switch (flower->command) {
@@ -1159,12 +1159,12 @@ mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *pr=
iv,
 static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 				 void *cb_priv)
 {
+	unsigned long flags =3D MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD)=
;
 	struct mlx5e_priv *priv =3D cb_priv;
=20
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, MLX5E_TC_INGRESS |
-						     MLX5E_TC_ESW_OFFLOAD);
+		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, flags);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index e2b87f723819..241157b699df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -66,19 +66,19 @@ struct mlx5_nic_flow_attr {
 	struct mlx5_fc		*counter;
 };
=20
-#define MLX5E_TC_FLOW_BASE (MLX5E_TC_LAST_EXPORTED_BIT + 1)
+#define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
=20
 enum {
-	MLX5E_TC_FLOW_INGRESS	=3D MLX5E_TC_INGRESS,
-	MLX5E_TC_FLOW_EGRESS	=3D MLX5E_TC_EGRESS,
-	MLX5E_TC_FLOW_ESWITCH	=3D MLX5E_TC_ESW_OFFLOAD,
-	MLX5E_TC_FLOW_NIC	=3D MLX5E_TC_NIC_OFFLOAD,
-	MLX5E_TC_FLOW_OFFLOADED	=3D BIT(MLX5E_TC_FLOW_BASE),
-	MLX5E_TC_FLOW_HAIRPIN	=3D BIT(MLX5E_TC_FLOW_BASE + 1),
-	MLX5E_TC_FLOW_HAIRPIN_RSS =3D BIT(MLX5E_TC_FLOW_BASE + 2),
-	MLX5E_TC_FLOW_SLOW	  =3D BIT(MLX5E_TC_FLOW_BASE + 3),
-	MLX5E_TC_FLOW_DUP         =3D BIT(MLX5E_TC_FLOW_BASE + 4),
-	MLX5E_TC_FLOW_NOT_READY   =3D BIT(MLX5E_TC_FLOW_BASE + 5),
+	MLX5E_TC_FLOW_FLAG_INGRESS	=3D MLX5E_TC_FLAG_INGRESS_BIT,
+	MLX5E_TC_FLOW_FLAG_EGRESS	=3D MLX5E_TC_FLAG_EGRESS_BIT,
+	MLX5E_TC_FLOW_FLAG_ESWITCH	=3D MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_NIC		=3D MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_OFFLOADED	=3D MLX5E_TC_FLOW_BASE,
+	MLX5E_TC_FLOW_FLAG_HAIRPIN	=3D MLX5E_TC_FLOW_BASE + 1,
+	MLX5E_TC_FLOW_FLAG_HAIRPIN_RSS	=3D MLX5E_TC_FLOW_BASE + 2,
+	MLX5E_TC_FLOW_FLAG_SLOW		=3D MLX5E_TC_FLOW_BASE + 3,
+	MLX5E_TC_FLOW_FLAG_DUP		=3D MLX5E_TC_FLOW_BASE + 4,
+	MLX5E_TC_FLOW_FLAG_NOT_READY	=3D MLX5E_TC_FLOW_BASE + 5,
 };
=20
 #define MLX5E_TC_MAX_SPLITS 1
@@ -109,7 +109,7 @@ struct mlx5e_tc_flow {
 	struct rhash_head	node;
 	struct mlx5e_priv	*priv;
 	u64			cookie;
-	u16			flags;
+	unsigned long		flags;
 	struct mlx5_flow_handle *rule[MLX5E_TC_MAX_SPLITS + 1];
 	/* Flow can be associated with multiple encap IDs.
 	 * The number of encaps is bounded by the number of supported
@@ -205,6 +205,47 @@ static void mlx5e_flow_put(struct mlx5e_priv *priv,
 	}
 }
=20
+static void __flow_flag_set(struct mlx5e_tc_flow *flow, unsigned long flag=
)
+{
+	/* Complete all memory stores before setting bit. */
+	smp_mb__before_atomic();
+	set_bit(flag, &flow->flags);
+}
+
+#define flow_flag_set(flow, flag) __flow_flag_set(flow, MLX5E_TC_FLOW_FLAG=
_##flag)
+
+static void __flow_flag_clear(struct mlx5e_tc_flow *flow, unsigned long fl=
ag)
+{
+	/* Complete all memory stores before clearing bit. */
+	smp_mb__before_atomic();
+	clear_bit(flag, &flow->flags);
+}
+
+#define flow_flag_clear(flow, flag) __flow_flag_clear(flow, \
+						      MLX5E_TC_FLOW_FLAG_##flag)
+
+static bool __flow_flag_test(struct mlx5e_tc_flow *flow, unsigned long fla=
g)
+{
+	bool ret =3D test_bit(flag, &flow->flags);
+
+	/* Read fields of flow structure only after checking flags. */
+	smp_mb__after_atomic();
+	return ret;
+}
+
+#define flow_flag_test(flow, flag) __flow_flag_test(flow, \
+						    MLX5E_TC_FLOW_FLAG_##flag)
+
+static bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow)
+{
+	return flow_flag_test(flow, ESWITCH);
+}
+
+static bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
+{
+	return flow_flag_test(flow, OFFLOADED);
+}
+
 static inline u32 hash_mod_hdr_info(struct mod_hdr_key *key)
 {
 	return jhash(key->actions,
@@ -226,9 +267,9 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	int num_actions, actions_size, namespace, err;
+	bool found =3D false, is_eswitch_flow;
 	struct mlx5e_mod_hdr_entry *mh;
 	struct mod_hdr_key key;
-	bool found =3D false;
 	u32 hash_key;
=20
 	num_actions  =3D parse_attr->num_mod_hdr_actions;
@@ -239,7 +280,8 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
=20
 	hash_key =3D hash_mod_hdr_info(&key);
=20
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
+	is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
+	if (is_eswitch_flow) {
 		namespace =3D MLX5_FLOW_NAMESPACE_FDB;
 		hash_for_each_possible(esw->offloads.mod_hdr_tbl, mh,
 				       mod_hdr_hlist, hash_key) {
@@ -278,14 +320,14 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 	if (err)
 		goto out_err;
=20
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH)
+	if (is_eswitch_flow)
 		hash_add(esw->offloads.mod_hdr_tbl, &mh->mod_hdr_hlist, hash_key);
 	else
 		hash_add(priv->fs.tc.mod_hdr_tbl, &mh->mod_hdr_hlist, hash_key);
=20
 attach_flow:
 	list_add(&flow->mod_hdr, &mh->flows);
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH)
+	if (is_eswitch_flow)
 		flow->esw_attr->mod_hdr_id =3D mh->mod_hdr_id;
 	else
 		flow->nic_attr->mod_hdr_id =3D mh->mod_hdr_id;
@@ -700,7 +742,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
=20
 attach_flow:
 	if (hpe->hp->num_channels > 1) {
-		flow->flags |=3D MLX5E_TC_FLOW_HAIRPIN_RSS;
+		flow_flag_set(flow, HAIRPIN_RSS);
 		flow->nic_attr->hairpin_ft =3D hpe->hp->ttc.ft.t;
 	} else {
 		flow->nic_attr->hairpin_tirn =3D hpe->hp->tirn;
@@ -761,12 +803,12 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	flow_context->flags |=3D FLOW_CONTEXT_HAS_TAG;
 	flow_context->flow_tag =3D attr->flow_tag;
=20
-	if (flow->flags & MLX5E_TC_FLOW_HAIRPIN) {
+	if (flow_flag_test(flow, HAIRPIN)) {
 		err =3D mlx5e_hairpin_flow_add(priv, flow, parse_attr, extack);
 		if (err)
 			return err;
=20
-		if (flow->flags & MLX5E_TC_FLOW_HAIRPIN_RSS) {
+		if (flow_flag_test(flow, HAIRPIN_RSS)) {
 			dest[dest_ix].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 			dest[dest_ix].ft =3D attr->hairpin_ft;
 		} else {
@@ -849,7 +891,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *pr=
iv,
 		mlx5_del_flow_rules(flow->rule[0]);
 	mlx5_fc_destroy(priv->mdev, counter);
=20
-	if (!mlx5e_tc_num_filters(priv, MLX5E_TC_NIC_OFFLOAD)  && priv->fs.tc.t) =
{
+	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) && priv->fs.tc=
.t) {
 		mlx5_destroy_flow_table(priv->fs.tc.t);
 		priv->fs.tc.t =3D NULL;
 	}
@@ -857,7 +899,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *pr=
iv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
=20
-	if (flow->flags & MLX5E_TC_FLOW_HAIRPIN)
+	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
 }
=20
@@ -892,7 +934,6 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 		}
 	}
=20
-	flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED;
 	return rule;
 }
=20
@@ -901,7 +942,7 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 			     struct mlx5e_tc_flow *flow,
 			   struct mlx5_esw_flow_attr *attr)
 {
-	flow->flags &=3D ~MLX5E_TC_FLOW_OFFLOADED;
+	flow_flag_clear(flow, OFFLOADED);
=20
 	if (attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
@@ -924,7 +965,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
=20
 	rule =3D mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
 	if (!IS_ERR(rule))
-		flow->flags |=3D MLX5E_TC_FLOW_SLOW;
+		flow_flag_set(flow, SLOW);
=20
 	return rule;
 }
@@ -939,7 +980,7 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *=
esw,
 	slow_attr->split_count =3D 0;
 	slow_attr->dest_chain =3D FDB_SLOW_PATH_CHAIN;
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
-	flow->flags &=3D ~MLX5E_TC_FLOW_SLOW;
+	flow_flag_clear(flow, SLOW);
 }
=20
 static void add_unready_flow(struct mlx5e_tc_flow *flow)
@@ -952,14 +993,14 @@ static void add_unready_flow(struct mlx5e_tc_flow *fl=
ow)
 	rpriv =3D mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 	uplink_priv =3D &rpriv->uplink_priv;
=20
-	flow->flags |=3D MLX5E_TC_FLOW_NOT_READY;
+	flow_flag_set(flow, NOT_READY);
 	list_add_tail(&flow->unready, &uplink_priv->unready_flows);
 }
=20
 static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	list_del(&flow->unready);
-	flow->flags &=3D ~MLX5E_TC_FLOW_NOT_READY;
+	flow_flag_clear(flow, NOT_READY);
 }
=20
 static int
@@ -1049,6 +1090,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
=20
 	if (IS_ERR(flow->rule[0]))
 		return PTR_ERR(flow->rule[0]);
+	else
+		flow_flag_set(flow, OFFLOADED);
=20
 	return 0;
 }
@@ -1074,14 +1117,14 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv=
 *priv,
 	struct mlx5_esw_flow_attr slow_attr;
 	int out_index;
=20
-	if (flow->flags & MLX5E_TC_FLOW_NOT_READY) {
+	if (flow_flag_test(flow, NOT_READY)) {
 		remove_unready_flow(flow);
 		kvfree(attr->parse_attr);
 		return;
 	}
=20
-	if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
-		if (flow->flags & MLX5E_TC_FLOW_SLOW)
+	if (mlx5e_is_offloaded_flow(flow)) {
+		if (flow_flag_test(flow, SLOW))
 			mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
 		else
 			mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
@@ -1166,8 +1209,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv=
,
 		}
=20
 		mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
-		flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED; /* was unset when slow path ru=
le removed */
 		flow->rule[0] =3D rule;
+		/* was unset when slow path rule removed */
+		flow_flag_set(flow, OFFLOADED);
=20
 loop_cont:
 		mlx5e_flow_put(priv, flow);
@@ -1205,8 +1249,9 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv=
,
 		}
=20
 		mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->esw_attr);
-		flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED; /* was unset when fast path ru=
le removed */
 		flow->rule[0] =3D rule;
+		/* was unset when fast path rule removed */
+		flow_flag_set(flow, OFFLOADED);
=20
 loop_cont:
 		mlx5e_flow_put(priv, flow);
@@ -1219,7 +1264,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv=
,
=20
 static struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
 {
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH)
+	if (mlx5e_is_eswitch_flow(flow))
 		return flow->esw_attr->counter;
 	else
 		return flow->nic_attr->counter;
@@ -1255,7 +1300,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_ne=
igh_hash_entry *nhe)
 			if (IS_ERR(mlx5e_flow_get(flow)))
 				continue;
=20
-			if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
+			if (mlx5e_is_offloaded_flow(flow)) {
 				counter =3D mlx5e_tc_get_counter(flow);
 				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
@@ -1315,15 +1360,15 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx=
5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw =3D flow->priv->mdev->priv.eswitch;
=20
-	if (!(flow->flags & MLX5E_TC_FLOW_ESWITCH) ||
-	    !(flow->flags & MLX5E_TC_FLOW_DUP))
+	if (!flow_flag_test(flow, ESWITCH) ||
+	    !flow_flag_test(flow, DUP))
 		return;
=20
 	mutex_lock(&esw->offloads.peer_mutex);
 	list_del(&flow->peer);
 	mutex_unlock(&esw->offloads.peer_mutex);
=20
-	flow->flags &=3D ~MLX5E_TC_FLOW_DUP;
+	flow_flag_clear(flow, DUP);
=20
 	mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
 	kvfree(flow->peer_flow);
@@ -1347,7 +1392,7 @@ static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_t=
c_flow *flow)
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
+	if (mlx5e_is_eswitch_flow(flow)) {
 		mlx5e_tc_del_fdb_peer_flow(flow);
 		mlx5e_tc_del_fdb_flow(priv, flow);
 	} else {
@@ -1845,11 +1890,13 @@ static int parse_cls_flower(struct mlx5e_priv *priv=
,
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	u8 match_level, tunnel_match_level =3D MLX5_MATCH_NONE;
 	struct mlx5_eswitch_rep *rep;
+	bool is_eswitch_flow;
 	int err;
=20
 	err =3D __parse_cls_flower(priv, spec, f, filter_dev, &match_level, &tunn=
el_match_level);
=20
-	if (!err && (flow->flags & MLX5E_TC_FLOW_ESWITCH)) {
+	is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
+	if (!err && is_eswitch_flow) {
 		rep =3D rpriv->rep;
 		if (rep->vport !=3D MLX5_VPORT_UPLINK &&
 		    (esw->offloads.inline_mode !=3D MLX5_INLINE_MODE_NONE &&
@@ -1863,7 +1910,7 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 		}
 	}
=20
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
+	if (is_eswitch_flow) {
 		flow->esw_attr->match_level =3D match_level;
 		flow->esw_attr->tunnel_match_level =3D tunnel_match_level;
 	} else {
@@ -2384,12 +2431,12 @@ static bool actions_match_supported(struct mlx5e_pr=
iv *priv,
 {
 	u32 actions;
=20
-	if (flow->flags & MLX5E_TC_FLOW_ESWITCH)
+	if (mlx5e_is_eswitch_flow(flow))
 		actions =3D flow->esw_attr->action;
 	else
 		actions =3D flow->nic_attr->action;
=20
-	if (flow->flags & MLX5E_TC_FLOW_EGRESS &&
+	if (flow_flag_test(flow, EGRESS) &&
 	    !((actions & MLX5_FLOW_CONTEXT_ACTION_DECAP) ||
 	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)))
 		return false;
@@ -2541,7 +2588,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *pr=
iv,
 			if (priv->netdev->netdev_ops =3D=3D peer_dev->netdev_ops &&
 			    same_hw_devs(priv, netdev_priv(peer_dev))) {
 				parse_attr->mirred_ifindex[0] =3D peer_dev->ifindex;
-				flow->flags |=3D MLX5E_TC_FLOW_HAIRPIN;
+				flow_flag_set(flow, HAIRPIN);
 				action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 					  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			} else {
@@ -3065,19 +3112,19 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *=
priv,
 	return 0;
 }
=20
-static void get_flags(int flags, u16 *flow_flags)
+static void get_flags(int flags, unsigned long *flow_flags)
 {
-	u16 __flow_flags =3D 0;
+	unsigned long __flow_flags =3D 0;
=20
-	if (flags & MLX5E_TC_INGRESS)
-		__flow_flags |=3D MLX5E_TC_FLOW_INGRESS;
-	if (flags & MLX5E_TC_EGRESS)
-		__flow_flags |=3D MLX5E_TC_FLOW_EGRESS;
+	if (flags & MLX5_TC_FLAG(INGRESS))
+		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_INGRESS);
+	if (flags & MLX5_TC_FLAG(EGRESS))
+		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_EGRESS);
=20
-	if (flags & MLX5E_TC_ESW_OFFLOAD)
-		__flow_flags |=3D MLX5E_TC_FLOW_ESWITCH;
-	if (flags & MLX5E_TC_NIC_OFFLOAD)
-		__flow_flags |=3D MLX5E_TC_FLOW_NIC;
+	if (flags & MLX5_TC_FLAG(ESW_OFFLOAD))
+		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
+	if (flags & MLX5_TC_FLAG(NIC_OFFLOAD))
+		__flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_NIC);
=20
 	*flow_flags =3D __flow_flags;
 }
@@ -3089,12 +3136,13 @@ static const struct rhashtable_params tc_ht_params =
=3D {
 	.automatic_shrinking =3D true,
 };
=20
-static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv, int flags)
+static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv,
+				    unsigned long flags)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *uplink_rpriv;
=20
-	if (flags & MLX5E_TC_ESW_OFFLOAD) {
+	if (flags & MLX5_TC_FLAG(ESW_OFFLOAD)) {
 		uplink_rpriv =3D mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		return &uplink_rpriv->uplink_priv.tc_ht;
 	} else /* NIC offload */
@@ -3105,7 +3153,7 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow =
*flow)
 {
 	struct mlx5_esw_flow_attr *attr =3D flow->esw_attr;
 	bool is_rep_ingress =3D attr->in_rep->vport !=3D MLX5_VPORT_UPLINK &&
-			      flow->flags & MLX5E_TC_FLOW_INGRESS;
+		flow_flag_test(flow, INGRESS);
 	bool act_is_encap =3D !!(attr->action &
 			       MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT);
 	bool esw_paired =3D mlx5_devcom_is_paired(attr->in_mdev->priv.devcom,
@@ -3124,7 +3172,7 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow =
*flow)
=20
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
-		 struct flow_cls_offload *f, u16 flow_flags,
+		 struct flow_cls_offload *f, unsigned long flow_flags,
 		 struct mlx5e_tc_flow_parse_attr **__parse_attr,
 		 struct mlx5e_tc_flow **__flow)
 {
@@ -3186,7 +3234,7 @@ mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *e=
sw_attr,
 static struct mlx5e_tc_flow *
 __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		     struct flow_cls_offload *f,
-		     u16 flow_flags,
+		     unsigned long flow_flags,
 		     struct net_device *filter_dev,
 		     struct mlx5_eswitch_rep *in_rep,
 		     struct mlx5_core_dev *in_mdev)
@@ -3197,7 +3245,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int attr_size, err;
=20
-	flow_flags |=3D MLX5E_TC_FLOW_ESWITCH;
+	flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
 	attr_size  =3D sizeof(struct mlx5_esw_flow_attr);
 	err =3D mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
 			       &parse_attr, &flow);
@@ -3236,7 +3284,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
=20
 static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 				      struct mlx5e_tc_flow *flow,
-				      u16 flow_flags)
+				      unsigned long flow_flags)
 {
 	struct mlx5e_priv *priv =3D flow->priv, *peer_priv;
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch, *peer_esw;
@@ -3274,7 +3322,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls=
_offload *f,
 	}
=20
 	flow->peer_flow =3D peer_flow;
-	flow->flags |=3D MLX5E_TC_FLOW_DUP;
+	flow_flag_set(flow, DUP);
 	mutex_lock(&esw->offloads.peer_mutex);
 	list_add_tail(&flow->peer, &esw->offloads.peer_flows);
 	mutex_unlock(&esw->offloads.peer_mutex);
@@ -3287,7 +3335,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls=
_offload *f,
 static int
 mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		   struct flow_cls_offload *f,
-		   u16 flow_flags,
+		   unsigned long flow_flags,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
 {
@@ -3321,7 +3369,7 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 static int
 mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 		   struct flow_cls_offload *f,
-		   u16 flow_flags,
+		   unsigned long flow_flags,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
 {
@@ -3335,7 +3383,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (!tc_cls_can_offload_and_chain0(priv->netdev, &f->common))
 		return -EOPNOTSUPP;
=20
-	flow_flags |=3D MLX5E_TC_FLOW_NIC;
+	flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_NIC);
 	attr_size  =3D sizeof(struct mlx5_nic_flow_attr);
 	err =3D mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
 			       &parse_attr, &flow);
@@ -3356,7 +3404,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
=20
-	flow->flags |=3D MLX5E_TC_FLOW_OFFLOADED;
+	flow_flag_set(flow, OFFLOADED);
 	kvfree(parse_attr);
 	*__flow =3D flow;
=20
@@ -3372,12 +3420,12 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 static int
 mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 		  struct flow_cls_offload *f,
-		  int flags,
+		  unsigned long flags,
 		  struct net_device *filter_dev,
 		  struct mlx5e_tc_flow **flow)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
-	u16 flow_flags;
+	unsigned long flow_flags;
 	int err;
=20
 	get_flags(flags, &flow_flags);
@@ -3396,7 +3444,7 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 }
=20
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv=
,
-			   struct flow_cls_offload *f, int flags)
+			   struct flow_cls_offload *f, unsigned long flags)
 {
 	struct netlink_ext_ack *extack =3D f->common.extack;
 	struct rhashtable *tc_ht =3D get_tc_ht(priv, flags);
@@ -3430,19 +3478,17 @@ int mlx5e_configure_flower(struct net_device *dev, =
struct mlx5e_priv *priv,
 	return err;
 }
=20
-#define DIRECTION_MASK (MLX5E_TC_INGRESS | MLX5E_TC_EGRESS)
-#define FLOW_DIRECTION_MASK (MLX5E_TC_FLOW_INGRESS | MLX5E_TC_FLOW_EGRESS)
-
 static bool same_flow_direction(struct mlx5e_tc_flow *flow, int flags)
 {
-	if ((flow->flags & FLOW_DIRECTION_MASK) =3D=3D (flags & DIRECTION_MASK))
-		return true;
+	bool dir_ingress =3D !!(flags & MLX5_TC_FLAG(INGRESS));
+	bool dir_egress =3D !!(flags & MLX5_TC_FLAG(EGRESS));
=20
-	return false;
+	return flow_flag_test(flow, INGRESS) =3D=3D dir_ingress &&
+		flow_flag_test(flow, EGRESS) =3D=3D dir_egress;
 }
=20
 int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			struct flow_cls_offload *f, int flags)
+			struct flow_cls_offload *f, unsigned long flags)
 {
 	struct rhashtable *tc_ht =3D get_tc_ht(priv, flags);
 	struct mlx5e_tc_flow *flow;
@@ -3459,7 +3505,7 @@ int mlx5e_delete_flower(struct net_device *dev, struc=
t mlx5e_priv *priv,
 }
=20
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
-		       struct flow_cls_offload *f, int flags)
+		       struct flow_cls_offload *f, unsigned long flags)
 {
 	struct mlx5_devcom *devcom =3D priv->mdev->priv.devcom;
 	struct rhashtable *tc_ht =3D get_tc_ht(priv, flags);
@@ -3481,7 +3527,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct=
 mlx5e_priv *priv,
 		goto errout;
 	}
=20
-	if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
+	if (mlx5e_is_offloaded_flow(flow)) {
 		counter =3D mlx5e_tc_get_counter(flow);
 		if (!counter)
 			goto errout;
@@ -3496,8 +3542,8 @@ int mlx5e_stats_flower(struct net_device *dev, struct=
 mlx5e_priv *priv,
 	if (!peer_esw)
 		goto out;
=20
-	if ((flow->flags & MLX5E_TC_FLOW_DUP) &&
-	    (flow->peer_flow->flags & MLX5E_TC_FLOW_OFFLOADED)) {
+	if (flow_flag_test(flow, DUP) &&
+	    flow_flag_test(flow->peer_flow, OFFLOADED)) {
 		u64 bytes2;
 		u64 packets2;
 		u64 lastuse2;
@@ -3622,7 +3668,7 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
 }
=20
-int mlx5e_tc_num_filters(struct mlx5e_priv *priv, int flags)
+int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
 {
 	struct rhashtable *tc_ht =3D get_tc_ht(priv, flags);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index 3ab39275ca7d..1cb66bf76997 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -40,13 +40,15 @@
 #ifdef CONFIG_MLX5_ESWITCH
=20
 enum {
-	MLX5E_TC_INGRESS =3D BIT(0),
-	MLX5E_TC_EGRESS  =3D BIT(1),
-	MLX5E_TC_NIC_OFFLOAD =3D BIT(2),
-	MLX5E_TC_ESW_OFFLOAD =3D BIT(3),
-	MLX5E_TC_LAST_EXPORTED_BIT =3D 3,
+	MLX5E_TC_FLAG_INGRESS_BIT,
+	MLX5E_TC_FLAG_EGRESS_BIT,
+	MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_LAST_EXPORTED_BIT =3D MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
 };
=20
+#define MLX5_TC_FLAG(flag) BIT(MLX5E_TC_FLAG_##flag##_BIT)
+
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
=20
@@ -54,12 +56,12 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht);
 void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht);
=20
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv=
,
-			   struct flow_cls_offload *f, int flags);
+			   struct flow_cls_offload *f, unsigned long flags);
 int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			struct flow_cls_offload *f, int flags);
+			struct flow_cls_offload *f, unsigned long flags);
=20
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
-		       struct flow_cls_offload *f, int flags);
+		       struct flow_cls_offload *f, unsigned long flags);
=20
 struct mlx5e_encap_entry;
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
@@ -70,7 +72,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
=20
-int mlx5e_tc_num_filters(struct mlx5e_priv *priv, int flags);
+int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
=20
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
=20
@@ -80,7 +82,11 @@ bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *p=
riv,
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; =
}
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
-static inline int  mlx5e_tc_num_filters(struct mlx5e_priv *priv, int flags=
) { return 0; }
+static inline int  mlx5e_tc_num_filters(struct mlx5e_priv *priv,
+					unsigned long flags)
+{
+	return 0;
+}
 #endif
=20
 #endif /* __MLX5_EN_TC_H__ */
--=20
2.21.0

