Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D33504D5
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhCaQl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:41:29 -0400
Received: from mail-eopbgr760052.outbound.protection.outlook.com ([40.107.76.52]:3627
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233822AbhCaQlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:41:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wy6P/DYYe1MzmR4j+GVAT3g0tn6GsqmKCR5XbSiE9FZA/FAbM3MKbTkEoxe8+NzvIILFXBh4u6mrqJ6wl+K3qSXQ7gqC5glEd+VSmtsMQBXeQNu4PaEBk4zXypY2XAHDLHY2gVtaBm6O+yDUabfARNpIwU+JLpJ37q1jETHLbPDqGtKRhkHmwBB260CmSnIq1VxvxiNbE4pYq+Omb7EpfvbXF7IMt3xUXWnhBXYIQAgFQhOw1ZVEwQ7JaqK3h/Qln69Opf5u+joNtVJ8536INuSRmcSnLj3dOJQYhKtIk1SldlXFEXXwr/6FSTRsXHnfdGj93/yqwfPKyF1MFIm4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/uIBygNGFAoGfw2KmCBPfi5/dI2RAzeqZw7YXkpt+s=;
 b=Yl900e1bwOfm5c0nX2oOlMvGF1ASRPjPg+6tto/VO5vCNeJDd0GmwrAs3EHDmDrtLCjPe32ePKpbHFlEy1cY6Xa60hc0POpOUYjWlTSiSx+70rIlihpkVs19qW+baAfW97SjdbEQ/vtbahQbF+sE2lbWSW95HsTodB+NpHS8g7G5AcwTet8o2tC+HNiDDArrBFh2hFoIkT4QFwbrBGK19EgTy7rUMOZKQIr1qM0yCMOCpJoWDyqqmNw/GxOYGc6Ia4ls31utf9pYUiFsc4xBohDJvXp9/qCjwzd8pHAfqDUsQyZwQEcl3DmqPTnjl+7S8mK0JsVkRpz5qx0n8WLWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/uIBygNGFAoGfw2KmCBPfi5/dI2RAzeqZw7YXkpt+s=;
 b=bp+YK71lqptwxndQGn1hu2dW8W3Zw8LUc95QPForiKpWRLJRleclkC6099Vg5v373+21LphBEB4gy9I1j8YYvLYsPfgnuvTCAP9ylUsSMw3elGi73TMbXKEmPbu6+yoXBul1i8DXU9+7tnh0C9NlgOyBLIER5b2saRmvjiB2Q1U9MKJGQUelCN62OVHRDXkP5GjKj23E2zwF9ppCA6rtgo7LtqMdKhTAxG/XLIairqzbnfTTe7GXofRvI2dwroYWgKVFE5wFjbuO81Fa8+2pMlv7yr6TLecWCgw9CdRM/eeLMjlq8HeKvSsWMvLg16PGIpYWF0MyuLzNI+L7xDuN7A==
Received: from BN6PR13CA0043.namprd13.prod.outlook.com (2603:10b6:404:13e::29)
 by DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 16:41:00 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::e2) by BN6PR13CA0043.outlook.office365.com
 (2603:10b6:404:13e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend
 Transport; Wed, 31 Mar 2021 16:41:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 16:40:57 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 16:40:56 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 16:40:54 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH RFC 1/4] net: sched: fix action overwrite reference counting
Date:   Wed, 31 Mar 2021 19:40:09 +0300
Message-ID: <20210331164012.28653-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210331164012.28653-1-vladbu@nvidia.com>
References: <20210331164012.28653-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf2be039-2f93-4de8-f14a-08d8f463c26a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4170A461084C686A19A771AEA07C9@DM6PR12MB4170.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WayCXWdGjAjaAlszN1qX0w6D6PQye647NqFwApf/dIeyDeO6kpmK/Wjd4g/B72iIfpaN66bHnI7WvRahRkwdTUtd/r4PcbxNPDLvsweDCTEdpC+nyE1jyzCmeYA5Uifi4VWi77ljpLVg6YzvZFW3UYW0ntX6Wi9g3ew3gI1N/rwff2JvjiND8zDKrXcdTNSOkcYOP6lDrD2vosofCPaNj53JhNzptJBGKXKil+hrscuCjlo/k4AutkK9tvj2tc+NqdZOpqpNQyXYc2j/ThqeGDJWkGJgUQ3sLbDY1fjaBnCaQpiHpIQnlYe2aNnlyrcNt0M+jL3TdZzSi/vSLHnD0fGRMvlVQ1pnsGAK68nDwq/wzLsyZEXkFiwUCT8OS8oO+tkluu3zrN9T4DgvmTZ14P+EFDtWs7MnbEPRBpevInK1I44qw1CinVrAChMOifbd8s1IgvjwRvM0fNV0clJJkRQM7bY3bJeQSXUjMbpA0xceUIToz8zUWWw7ag8PeQVtcU60+U7vHUPjkPAvLKuxVXgoJUPO00RCq91CNGvgoRq5PLNN3BSzdqMi/25rlAHXHQYUCL0RZpPteOHKFNrH2twyFODQ+DQU0/9RRoSfBvG1KwxwyvfYNPseT8lkkSq/VGaxeTFDQa4G5aYm7WwkbD9bKsLMO36DnlciwY1Siec=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(107886003)(7636003)(82740400003)(70586007)(356005)(70206006)(6916009)(7696005)(8676002)(2906002)(8936002)(54906003)(83380400001)(186003)(316002)(36756003)(82310400003)(426003)(478600001)(4326008)(6666004)(26005)(36906005)(1076003)(2616005)(5660300002)(86362001)(336012)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:40:57.1974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2be039-2f93-4de8-f14a-08d8f463c26a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Action init code increments reference counter when it changes an action.
This is the desired behavior for cls API which needs to obtain action
reference for every classifier that points to action. However, act API just
needs to change the action and releases the reference before returning.
This sequence breaks when the requested action doesn't exist, which causes
act API init code to create new action with specified index, but action is
still released before returning and is deleted (unless it was referenced
concurrently by cls API).

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/act_api.h |  5 +++--
 net/sched/act_api.c   | 27 +++++++++++++++++----------
 net/sched/cls_api.c   |  9 +++++----
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2bf3092ae7ec..312f0f6554a0 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -185,7 +185,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 					 bool rtnl_held,
@@ -193,7 +193,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *ops, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..eb20a75796d5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -777,8 +777,11 @@ static int tcf_action_put(struct tc_action *p)
 	return __tcf_action_put(p, false);
 }
 
-/* Put all actions in this array, skip those NULL's. */
-static void tcf_action_put_many(struct tc_action *actions[])
+/* Put all actions in this array, skip those NULL's. If cond array is provided
+ * by caller, then only put actions that match.
+ */
+static void tcf_action_put_many(struct tc_action *actions[], int *cond,
+				int match)
 {
 	int i;
 
@@ -786,7 +789,7 @@ static void tcf_action_put_many(struct tc_action *actions[])
 		struct tc_action *a = actions[i];
 		const struct tc_action_ops *ops;
 
-		if (!a)
+		if (!a || (cond && cond[i] != match))
 			continue;
 		ops = a->ops;
 		if (tcf_action_put(a))
@@ -992,7 +995,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
 	struct nla_bitfield32 flags = { 0, 0 };
@@ -1028,6 +1032,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	}
 	if (err < 0)
 		goto err_out;
+	*init_res = err;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1056,7 +1061,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1084,7 +1089,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					ops[i - 1], rtnl_held, extack);
+					ops[i - 1], &init_res[i - 1], rtnl_held,
+					extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1462,7 +1468,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 		return 0;
 	}
 err:
-	tcf_action_put_many(actions);
+	tcf_action_put_many(actions, NULL, 0);
 	return ret;
 }
 
@@ -1499,10 +1505,11 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	size_t attr_size = 0;
 	int loop, ret;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
+	int init_res[TCA_ACT_MAX_PRIO] = {};
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0,
-				      actions, &attr_size, true, extack);
+				      actions, init_res, &attr_size, true, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -1510,8 +1517,8 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	if (ret < 0)
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
-	if (ovr)
-		tcf_action_put_many(actions);
+	/* Only put existing actions that were changed by init (res==0). */
+	tcf_action_put_many(actions, init_res, 0);
 
 	return ret;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3db70865d66..f7425bb9fc3d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3040,6 +3040,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
+		int init_res[TCA_ACT_MAX_PRIO] = {};
 		struct tc_action *act;
 		size_t attr_size = 0;
 
@@ -3051,8 +3052,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 				return PTR_ERR(a_o);
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, a_o, rtnl_held,
-						extack);
+						TCA_ACT_BIND, a_o, init_res,
+						rtnl_held, extack);
 			if (IS_ERR(act)) {
 				module_put(a_o->owner);
 				return PTR_ERR(act);
@@ -3067,8 +3068,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, NULL, ovr, TCA_ACT_BIND,
-					      exts->actions, &attr_size,
-					      rtnl_held, extack);
+					      exts->actions, init_res,
+					      &attr_size, rtnl_held, extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;
-- 
2.29.2

