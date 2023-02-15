Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01016698719
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBOVLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBOVKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011504C27
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJzKVjoJNRRGkC4wgyH7eAxXVokBB80/hXqfbnybTi22nDpsOogkmFrOE9Lkz3SIKbvyRKxfTtcxgMDt0ZLHLHVX0LbZrwzQA3oJJwpdLE3n9RxC7bqhVcwrGGWsC/PWZT/t3vowIg7x99gm4hEgmYPLuVGmNdgGTZ8pL5RS16k4a7xi3/C4DncM9Pb+LKN4nQ3e3+Zr/zrfQ/szL5JYXFEXw5TdSQ73+Rk9uiBft3UgjvBxLE1ko3B755FQyfGjNYPeNyG3EntDucpK/5kAXyVHXVepU5Sxkt/f5p05l1Co8lXGa7fi870z0g54h5uqAonzj3E2hn0irPXfKcB9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YO6XV5RrsXs9mLrUyEQU7CyAyEdYGI5kmeKDLUkhK+Q=;
 b=YRJJzfMJPRnNnbq7TTIp7hwoE8I3wuO4aMrPMZhRCeoqLEZ9r9fNwWMd2sz4vcVetqAnrTfgnchTx/PbSvNZGer/e2J1qzLIKMNer9Zm58p6Q32fk3CqReW2VKA3vwW2O2sQCSq83Vx4a3cZYJikEWKe6ZAgnnORe0peL0e7BjAhDTyE2lkGpn9IViHQjCJOBr5LKOIZb592bPMGb3kbMNfBtzsP/OhWMBW4HZIjNMGXHovfwEGuE0fcR6MoE2L10Y4Zz4G061MKcFDFWm6nuHcj1FO7m8vhCeoS1TxLRuwumCboGY/yOt8sTYfxC2En9sjZ/IH6h6dv4tntEhaY+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO6XV5RrsXs9mLrUyEQU7CyAyEdYGI5kmeKDLUkhK+Q=;
 b=hndl9k56CR32IeTJOw3S+o1axdSvxyRvY243I9rgJxfVGHK+pjPyHBLRfVSmdDM3xEL8LSeznB9AAwGpNEU4BIVGOp9XjrnOC84wARKCK/OACFpTIep3pT78xhAT5k6J2ONoytRQW6l2IeeTLWm/jyDvl18FVEr4tct8Bnj8DbBHOFca1Je5FYZj3+aECSF/wpmmoJc2xQ6P6NDVhyjvySxIImx9RtJRrNrrAkqgZqJPrYZkfowwYhCkdFoP/9NTZ4IGt02upPy9kbfYAzfPyONBWfBtBLJ6xdNmK/T8UbQQ7NYQIgvJuS1R/5NTUJGYcP0Bj6UTA4bDQTnu51Z9cA==
Received: from BN9PR03CA0108.namprd03.prod.outlook.com (2603:10b6:408:fd::23)
 by DM4PR12MB6278.namprd12.prod.outlook.com (2603:10b6:8:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 21:10:40 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::fc) by BN9PR03CA0108.outlook.office365.com
 (2603:10b6:408:fd::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:24 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:24 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:21 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v12 1/8] net/sched: Rename user cookie and act cookie
Date:   Wed, 15 Feb 2023 23:10:07 +0200
Message-ID: <20230215211014.6485-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230215211014.6485-1-paulb@nvidia.com>
References: <20230215211014.6485-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT030:EE_|DM4PR12MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c3f446-87b3-4399-3f61-08db0f99173f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqoUPu5/I/45vS1YPbIhFOvO1WlEE7/CFulOMjOthfgqrMPHtDHseo/1dQPqHhbAnLP3n3527uV3JNN3ms/mgsHgWeaH2FYiP1w+6EFvSg2Vg9TQlajK2OJb/6FAf0+Lw2Z847arkiA8FH3FuvZhO2sQ32d7QrFgAlrQu9IyJMbGs8oK2TJkSJpRdx1X8IntIGhr+lVD1BTekLGSLElKicCS2YuTsKw2WrZy6v/ogLyC/e+1nUgUlm4dMNiaAdXP5S0R6yk7bOJatIMs4I/zWSQa972BGIHnZih9IyA+Sdjw/oaF/rBEGmpM0IOjsFVtOCibp9r6T+wvjyGRzNQ2VgynwTeviDdmpEb3xXLRy0iQ8EZ7v+aJ1nbSVCisXcVWNk1qqWhWt2z8qoZeEW8eBAjbilJ3eK7D6JsaG449q4EJLvrcZSMrDFGHGIi3H6rOHjP1vUsPetfrdk5cRLgZI86RXzYeaNzMVEdDL+87PKB5rN+cAI0q00k+omPmhIkYTaE5ygUeMe5S7vPYfEfhbVMpZ/VGpNv0fg+wVobFdIIxIJXYozKWtk1sdERrxm6nsa3tZgQj5KFNwsqegVmwvmXarX558S46qoEP3ND/+bEBZCNFmCwoTPTaIrWCasl4H4ggNswT3AJF/zFuROP6wxrdy4T+BJrCGRayXugVOqn/BDjIw3fIbff7kHNZ/H/PeGJ7aTeyuBTQRfCAxccnb6wZcW6jtk4upz+Nz+HDlrs=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(6666004)(54906003)(110136005)(83380400001)(316002)(40480700001)(40460700003)(186003)(1076003)(26005)(2616005)(2906002)(36860700001)(5660300002)(8936002)(426003)(7636003)(107886003)(336012)(478600001)(82740400003)(47076005)(356005)(921005)(8676002)(41300700001)(70586007)(4326008)(70206006)(82310400005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:39.5147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c3f446-87b3-4399-3f61-08db0f99173f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6278
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct tc_action->act_cookie is a user defined cookie,
and the related struct flow_action_entry->act_cookie is
used as an handle similar to struct flow_cls_offload->cookie.

Rename tc_action->act_cookie to user_cookie, and
flow_action_entry->act_cookie to cookie so their names
would better fit their usage.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 include/net/act_api.h                         |  2 +-
 include/net/flow_offload.h                    |  4 +--
 net/sched/act_api.c                           | 26 ++++++++---------
 net/sched/cls_api.c                           | 28 +++++++++----------
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2d06b4412762..208809a8eb0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4180,7 +4180,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 		parse_state->actions |= attr->action;
 		if (!tc_act->stats_action)
-			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2a6f443f0ef6..4ae0580b63ca 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -39,7 +39,7 @@ struct tc_action {
 	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	struct gnet_stats_basic_sync __percpu *cpu_bstats_hw;
 	struct gnet_stats_queue __percpu *cpu_qstats;
-	struct tc_cookie	__rcu *act_cookie;
+	struct tc_cookie	__rcu *user_cookie;
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
 	u8			hw_stats;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 8c05455b1e34..9c5cb12f8a90 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,7 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
-	unsigned long			act_cookie;
+	unsigned long			cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -321,7 +321,7 @@ struct flow_action_entry {
 			u16		sid;
 		} pppoe;
 	};
-	struct flow_action_cookie *cookie; /* user defined action cookie */
+	struct flow_action_cookie *user_cookie; /* user defined action cookie */
 };
 
 struct flow_action {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index eda58b78da13..e67ebc939901 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -125,7 +125,7 @@ static void free_tcf(struct tc_action *p)
 	free_percpu(p->cpu_bstats_hw);
 	free_percpu(p->cpu_qstats);
 
-	tcf_set_action_cookie(&p->act_cookie, NULL);
+	tcf_set_action_cookie(&p->user_cookie, NULL);
 	if (chain)
 		tcf_chain_put_by_act(chain);
 
@@ -431,14 +431,14 @@ EXPORT_SYMBOL(tcf_idr_release);
 
 static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 {
-	struct tc_cookie *act_cookie;
+	struct tc_cookie *user_cookie;
 	u32 cookie_len = 0;
 
 	rcu_read_lock();
-	act_cookie = rcu_dereference(act->act_cookie);
+	user_cookie = rcu_dereference(act->user_cookie);
 
-	if (act_cookie)
-		cookie_len = nla_total_size(act_cookie->len);
+	if (user_cookie)
+		cookie_len = nla_total_size(user_cookie->len);
 	rcu_read_unlock();
 
 	return  nla_total_size(0) /* action number nested */
@@ -488,7 +488,7 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
 		goto nla_put_failure;
 
 	rcu_read_lock();
-	cookie = rcu_dereference(a->act_cookie);
+	cookie = rcu_dereference(a->user_cookie);
 	if (cookie) {
 		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
 			rcu_read_unlock();
@@ -1362,9 +1362,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 {
 	bool police = flags & TCA_ACT_FLAGS_POLICE;
 	struct nla_bitfield32 userflags = { 0, 0 };
+	struct tc_cookie *user_cookie = NULL;
 	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
 	struct nlattr *tb[TCA_ACT_MAX + 1];
-	struct tc_cookie *cookie = NULL;
 	struct tc_action *a;
 	int err;
 
@@ -1375,8 +1375,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		if (err < 0)
 			return ERR_PTR(err);
 		if (tb[TCA_ACT_COOKIE]) {
-			cookie = nla_memdup_cookie(tb);
-			if (!cookie) {
+			user_cookie = nla_memdup_cookie(tb);
+			if (!user_cookie) {
 				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
 				err = -ENOMEM;
 				goto err_out;
@@ -1402,7 +1402,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	*init_res = err;
 
 	if (!police && tb[TCA_ACT_COOKIE])
-		tcf_set_action_cookie(&a->act_cookie, cookie);
+		tcf_set_action_cookie(&a->user_cookie, user_cookie);
 
 	if (!police)
 		a->hw_stats = hw_stats;
@@ -1410,9 +1410,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return a;
 
 err_out:
-	if (cookie) {
-		kfree(cookie->data);
-		kfree(cookie);
+	if (user_cookie) {
+		kfree(user_cookie->data);
+		kfree(user_cookie);
 	}
 	return ERR_PTR(err);
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bfabc9c95fa9..656049ead8bb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3490,28 +3490,28 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tc_setup_cb_reoffload);
 
-static int tcf_act_get_cookie(struct flow_action_entry *entry,
-			      const struct tc_action *act)
+static int tcf_act_get_user_cookie(struct flow_action_entry *entry,
+				   const struct tc_action *act)
 {
-	struct tc_cookie *cookie;
+	struct tc_cookie *user_cookie;
 	int err = 0;
 
 	rcu_read_lock();
-	cookie = rcu_dereference(act->act_cookie);
-	if (cookie) {
-		entry->cookie = flow_action_cookie_create(cookie->data,
-							  cookie->len,
-							  GFP_ATOMIC);
-		if (!entry->cookie)
+	user_cookie = rcu_dereference(act->user_cookie);
+	if (user_cookie) {
+		entry->user_cookie = flow_action_cookie_create(user_cookie->data,
+							       user_cookie->len,
+							       GFP_ATOMIC);
+		if (!entry->user_cookie)
 			err = -ENOMEM;
 	}
 	rcu_read_unlock();
 	return err;
 }
 
-static void tcf_act_put_cookie(struct flow_action_entry *entry)
+static void tcf_act_put_user_cookie(struct flow_action_entry *entry)
 {
-	flow_action_cookie_destroy(entry->cookie);
+	flow_action_cookie_destroy(entry->user_cookie);
 }
 
 void tc_cleanup_offload_action(struct flow_action *flow_action)
@@ -3520,7 +3520,7 @@ void tc_cleanup_offload_action(struct flow_action *flow_action)
 	int i;
 
 	flow_action_for_each(i, entry, flow_action) {
-		tcf_act_put_cookie(entry);
+		tcf_act_put_user_cookie(entry);
 		if (entry->destructor)
 			entry->destructor(entry->destructor_priv);
 	}
@@ -3565,7 +3565,7 @@ int tc_setup_action(struct flow_action *flow_action,
 
 		entry = &flow_action->entries[j];
 		spin_lock_bh(&act->tcfa_lock);
-		err = tcf_act_get_cookie(entry, act);
+		err = tcf_act_get_user_cookie(entry, act);
 		if (err)
 			goto err_out_locked;
 
@@ -3577,7 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
-			entry[k].act_cookie = (unsigned long)act;
+			entry[k].cookie = (unsigned long)act;
 		}
 
 		j += index;
-- 
2.30.1

