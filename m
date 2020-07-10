Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB121BF6D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGJV4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:56:51 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgGJV4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXHEEA7wERvXeClAReuIhCVNoiBPLhKrCjYUKAgFS41y3OWrGh4CWMcWu8A/ewaz19hG6Gnz5MiefZUknk+r+yNe8llxxnekW/lC6o9m1KSstvJRt9lQjkebAGqCcWXH3ZEksSYcOVbTiWfNfS1QlphHpRaZuwVGuDjNttL0YYf0IgfIJOWsaFbvJrRLAxO6OQH3TZupwRjk52p8O6Gye95mYcAHJ3nZru+LoScyxJWqfXQUf35+DlYg4Av7tG1aOylHLfbsejo/wmTIWiATMg/7wV4MhXc58rFFKDltmYq27y7BixrxbunA+gqfk/l/qq69miKNJ5FPNgf0OJL2gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg35bqT5bseg3EgvTVAjXmngIrauo2aG+DSDLFQ2IMo=;
 b=DYNjUaZmCOaeaMgv/rjEoCXJgeVr7vZst7Sr2SJ1H/9TKo5zZ4PlZ7baeIiNXT6+QT+Z/xeXLHPq6c7uYa2PESzD9F2kjK9uEhNW36hw1YXsGlw1sOC0jwsWI0exgx28W6hOAAOsiL+Sq9ILcklTEuP+45CzaZg5axB26icBZCDI8yNYwUMSwDW0cbyjIEFODENZJUTeF0F4PHHMssVJz5ejAwtxIyBlRkxTpzq+QZt3rD2MtQ8f2r9//yA7kxawIXJA4QNLkZZVy0r43WKYivUcD1HheD0GcyIQrYqXZ6cCqhsl73aFaFv0ztph/c8513meKhnfjTmRndkKuFaHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg35bqT5bseg3EgvTVAjXmngIrauo2aG+DSDLFQ2IMo=;
 b=eF4Nq3/kVuXHDvEG1dxsG8I8gmdRz3DWlYxmSpQhZUq5S4QEEWCTWWz/zK46/ztbIqzKi2xWDW17YNNOWWRgjhN/RFCSkqgZrDKPmcbNytLXIMFkvHjRt0zj0JqeuSrXjaGSxwMavgf5JXtOSToCsQV1ZFoxDhsgl+AEJfwHCiA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:42 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
Date:   Sat, 11 Jul 2020 00:55:03 +0300
Message-Id: <a5a3ccf7bf3a097c6400d64f617ee7ee9fc6156c.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:39 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f348b7b0-ea6a-4b7d-2e25-08d8251c211e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33548DEA3661F1C710AE6146DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgnWM73tU0jmEKBYzs6MgJobaTfF4cJCtORd42j83NHz0me3tJ+q3LW3wCm7FM0nyL4VCnvJ1We3Ow59RekJqcyk8zfIPNoG9A+F4sHS81/2f/vZKFfsM/wLuc87hLyxUMmnApVMBOPuTT5X978b40xRhMgsWkAQbQnt6enpkJcCraZXgnFaLCKLQsVvMh3c80Yxc3lVaExb5ihLSZJu7erxbgSHeWy9fEwFI2fM3gNPYBNAcD7GGyi7B/BI5pI/fl+d7nE1BNghW5omH1rDGz4Uazc7xPqNlHGJjX7xAF0W2YmKfoVoJcw3Jt0ojY06
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(30864003)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zgBX5Sx+g1Dh0MUCRm4yFNgZ6eNI0hbKG3tcKuLwC6yAGfn9jSxfFOhoF5n8U60nkDwAZe55CuKJEJuUExbjR2MYYOPBIzUmroqJf411EnuDoI76CWn0SZVWbhQQduhoGx6RVG5E+9ZRK6hcOcGRPPBZzSHKSG8NKh4RH3xFINy0UbgLG5cmKw57WJyCiU2xl/RMbJ1ljWyNjj3CD3XTheYfgtkZ3JpaiUlLFfwwGrVKgjw/2wnRKca0bYKFhx67+VhGYsXgzjpbUs3ybNUiBhGEedzDRmyuXOsjIHr4wiQ+0O+Y8Bnk6XnPRlraHjje47aKChfWtbpL4rWRJ0Tuvuh6scRRMAnBMkvOKahQ0OkFA7IANsEbmYyA2AE2Kv8a86VjPLHnRjKs9k/+ngYSlOXMZ/8A48vUkfiVOXxiBPAxFrRq+KGYdS8b+hBgy9G7lqvBqwh8ZC8/+HGg9VEjmZxVbCY8DlfZpzTBpnLuv9hzrBq1ZPGhr3R5bY3fQkRP
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f348b7b0-ea6a-4b7d-2e25-08d8251c211e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:42.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0Y4QaURUq8QFYvo8HXzSYfACtYc2tis+nuXncpA/NDh93yP7JdJzA6EXxz3ANwrT9dtqJUW+CJYZ776WlY/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, shared blocks were only relevant for the pseudo-qdiscs ingress
and clsact. Recently, a qevent facility was introduced, which allows to
bind blocks to well-defined slots of a qdisc instance. RED in particular
got two qevents: early_drop and mark. Drivers that wish to offload these
blocks will be sent the usual notification, and need to know which qdisc it
is related to.

To that end, extend flow_block_offload with a "sch" pointer, and initialize
as appropriate. This prompts changes in the indirect block facility, which
now tracks the scheduler in addition to the netdevice. Update signatures of
several functions similarly.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - In struct flow_block_indr, track both sch and dev.

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c     |  9 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c  | 10 +++++-----
 drivers/net/ethernet/netronome/nfp/flower/main.h |  2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c  |  8 ++++----
 include/net/flow_offload.h                       |  9 ++++++---
 net/core/flow_offload.c                          | 12 +++++++-----
 net/netfilter/nf_flow_table_offload.c            |  2 +-
 net/netfilter/nf_tables_offload.c                |  2 +-
 net/sched/cls_api.c                              | 16 +++++++++-------
 9 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0a9a4467d7c7..e82e5cf64d61 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1888,7 +1888,7 @@ static void bnxt_tc_setup_indr_rel(void *cb_priv)
 	kfree(priv);
 }
 
-static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
+static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct Qdisc *sch, struct bnxt *bp,
 				    struct flow_block_offload *f, void *data,
 				    void (*cleanup)(struct flow_block_cb *block_cb))
 {
@@ -1911,7 +1911,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    bnxt_tc_setup_indr_rel, f,
-						    netdev, data, bp, cleanup);
+						    netdev, sch, data, bp, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1946,7 +1946,7 @@ static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
 	return netif_is_vxlan(netdev);
 }
 
-static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
+static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 				 enum tc_setup_type type, void *type_data,
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
@@ -1956,8 +1956,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data, data,
-						cleanup);
+		return bnxt_tc_setup_indr_block(netdev, sch, cb_priv, type_data, data, cleanup);
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index eefeb1cdc2ee..067e120510fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int
-mlx5e_rep_indr_setup_block(struct net_device *netdev,
+mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 			   struct mlx5e_rep_priv *rpriv,
 			   struct flow_block_offload *f,
 			   flow_setup_cb_t *setup_cb,
@@ -442,7 +442,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 
 		block_cb = flow_indr_block_cb_alloc(setup_cb, indr_priv, indr_priv,
 						    mlx5e_rep_indr_block_unbind,
-						    f, netdev, data, rpriv,
+						    f, netdev, sch, data, rpriv,
 						    cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
@@ -472,18 +472,18 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 }
 
 static
-int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
+int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_tc_cb,
 						  data, cleanup);
 	case TC_SETUP_FT:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_ft_cb,
 						  data, cleanup);
 	default:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7f54a620acad..3bf9c1afa45e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -458,7 +458,7 @@ void nfp_flower_qos_cleanup(struct nfp_app *app);
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow);
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
-int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
+int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 				enum tc_setup_type type, void *type_data,
 				void *data,
 				void (*cleanup)(struct flow_block_cb *block_cb));
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 3af27bb5f4b0..4651fe417b7f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1646,7 +1646,7 @@ void nfp_flower_setup_indr_tc_release(void *cb_priv)
 }
 
 static int
-nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
+nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct Qdisc *sch, struct nfp_app *app,
 			       struct flow_block_offload *f, void *data,
 			       void (*cleanup)(struct flow_block_cb *block_cb))
 {
@@ -1680,7 +1680,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		block_cb = flow_indr_block_cb_alloc(nfp_flower_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    nfp_flower_setup_indr_tc_release,
-						    f, netdev, data, app, cleanup);
+						    f, netdev, sch, data, app, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1711,7 +1711,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 }
 
 int
-nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
+nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
@@ -1721,7 +1721,7 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_flower_setup_indr_tc_block(netdev, cb_priv,
+		return nfp_flower_setup_indr_tc_block(netdev, sch, cb_priv,
 						      type_data, data, cleanup);
 	default:
 		return -EOPNOTSUPP;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index de395498440d..9f88a7b730a8 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -444,6 +444,7 @@ struct flow_block_offload {
 	struct list_head cb_list;
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
+	struct Qdisc *sch;
 };
 
 enum tc_setup_type;
@@ -455,6 +456,7 @@ struct flow_block_cb;
 struct flow_block_indr {
 	struct list_head		list;
 	struct net_device		*dev;
+	struct Qdisc			*sch;
 	enum flow_block_binder_type	binder_type;
 	void				*data;
 	void				*cb_priv;
@@ -479,7 +481,8 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void *cb_ident, void *cb_priv,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
-					       struct net_device *dev, void *data,
+					       struct net_device *dev,
+					       struct Qdisc *sch, void *data,
 					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
@@ -553,7 +556,7 @@ static inline void flow_block_init(struct flow_block *flow_block)
 	INIT_LIST_HEAD(&flow_block->cb_list);
 }
 
-typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
+typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
 				      enum tc_setup_type type, void *type_data,
 				      void *data,
 				      void (*cleanup)(struct flow_block_cb *block_cb));
@@ -561,7 +564,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 			      void (*release)(void *cb_priv));
-int flow_indr_dev_setup_offload(struct net_device *dev,
+int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index b739cfab796e..b8cf6ff5f961 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -429,7 +429,7 @@ EXPORT_SYMBOL(flow_indr_dev_unregister);
 
 static void flow_block_indr_init(struct flow_block_cb *flow_block,
 				 struct flow_block_offload *bo,
-				 struct net_device *dev, void *data,
+				 struct net_device *dev, struct Qdisc *sch, void *data,
 				 void *cb_priv,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
@@ -437,6 +437,7 @@ static void flow_block_indr_init(struct flow_block_cb *flow_block,
 	flow_block->indr.data = data;
 	flow_block->indr.cb_priv = cb_priv;
 	flow_block->indr.dev = dev;
+	flow_block->indr.sch = sch;
 	flow_block->indr.cleanup = cleanup;
 }
 
@@ -444,7 +445,8 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void *cb_ident, void *cb_priv,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
-					       struct net_device *dev, void *data,
+					       struct net_device *dev,
+					       struct Qdisc *sch, void *data,
 					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb))
 {
@@ -454,7 +456,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 	if (IS_ERR(block_cb))
 		goto out;
 
-	flow_block_indr_init(block_cb, bo, dev, data, indr_cb_priv, cleanup);
+	flow_block_indr_init(block_cb, bo, dev, sch, data, indr_cb_priv, cleanup);
 	list_add(&block_cb->indr.list, &flow_block_indr_list);
 
 out:
@@ -462,7 +464,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-int flow_indr_dev_setup_offload(struct net_device *dev,
+int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb))
@@ -471,7 +473,7 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 
 	mutex_lock(&flow_indr_block_lock);
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, this->cb_priv, type, bo, data, cleanup);
+		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
 
 	mutex_unlock(&flow_indr_block_lock);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 5fff1e040168..2a6993fa40d7 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -964,7 +964,7 @@ static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 
-	return flow_indr_dev_setup_offload(dev, TC_SETUP_FT, flowtable, bo,
+	return flow_indr_dev_setup_offload(dev, NULL, TC_SETUP_FT, flowtable, bo,
 					   nf_flow_table_indr_cleanup);
 }
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index c7cf1cde46de..9ef37c1b7b3b 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -312,7 +312,7 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, basechain, &extack);
 
-	err = flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, basechain, &bo,
+	err = flow_indr_dev_setup_offload(dev, NULL, TC_SETUP_BLOCK, basechain, &bo,
 					  nft_indr_block_cleanup);
 	if (err < 0)
 		return err;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e9e119ea6813..790882097431 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -622,7 +622,7 @@ static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
 static void tcf_block_offload_init(struct flow_block_offload *bo,
-				   struct net_device *dev,
+				   struct net_device *dev, struct Qdisc *sch,
 				   enum flow_block_command command,
 				   enum flow_block_binder_type binder_type,
 				   struct flow_block *flow_block,
@@ -634,6 +634,7 @@ static void tcf_block_offload_init(struct flow_block_offload *bo,
 	bo->block = flow_block;
 	bo->block_shared = shared;
 	bo->extack = extack;
+	bo->sch = sch;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
@@ -644,10 +645,11 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 {
 	struct tcf_block *block = block_cb->indr.data;
 	struct net_device *dev = block_cb->indr.dev;
+	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
 	struct flow_block_offload bo;
 
-	tcf_block_offload_init(&bo, dev, FLOW_BLOCK_UNBIND,
+	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
 			       block_cb->indr.binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
@@ -666,14 +668,14 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 }
 
 static int tcf_block_offload_cmd(struct tcf_block *block,
-				 struct net_device *dev,
+				 struct net_device *dev, struct Qdisc *sch,
 				 struct tcf_block_ext_info *ei,
 				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
 	struct flow_block_offload bo = {};
 
-	tcf_block_offload_init(&bo, dev, command, ei->binder_type,
+	tcf_block_offload_init(&bo, dev, sch, command, ei->binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       extack);
 
@@ -690,7 +692,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 		return tcf_block_setup(block, &bo);
 	}
 
-	flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, block, &bo,
+	flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
 				    tc_block_indr_cleanup);
 	tcf_block_setup(block, &bo);
 
@@ -717,7 +719,7 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 		goto err_unlock;
 	}
 
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_BIND, extack);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
@@ -744,7 +746,7 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	int err;
 
 	down_write(&block->cb_lock);
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
+	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_UNBIND, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
 	up_write(&block->cb_lock);
-- 
2.20.1

