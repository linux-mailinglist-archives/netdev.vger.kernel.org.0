Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AA7357076
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbhDGPgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:36:55 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:24416
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243477AbhDGPgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgfI3gyCkDGJPwtyrhFs7O0JlU1i3fEti2W3urCsAn/BNpZB0bYszxZo9iQbOxsnxI7hzp0WizYBxg2Tb0VrgAPXXVmQZw1gkEnXWPby1rX9lzjcMUbT3lwfGLurAta7SY4HfB7Gccbwf+fsg9ISnbrZtaxdBg4qvXdeHso6MCGRCHSX+DMXnNf92CUdYjOi1egUNcS4XX2XZYKLnpQntM7Fm3db1QxLWRdWSzw9k/nb6qLMXeFWFTTvcstMI4wbgWHD6JUWJ7/mQPl9MFSp1ak5jc7ep+xtZ6edj1hY4J6g43JzyRF0jgUiPN5PsR7um2HKzTAFHQFQk3hrCOHRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFtD6PelGs6ZOv1/fr0spxAitCUdXzE1snHVILoZxeo=;
 b=VuTbpLCbidYjWCJsZVW7q1o2H0Nn6Fmx4rZwaqxEooWR4nw3vPWJtWXXFribD8PYE1dZ9BkExaS75MHWFJ1kyXwI5ZBUoGof0i3AUpS7w9+mcXJI287IiIH0mUvu/WWOk45VTkZXkNYfrYbwcyaZWiQCw+Is9aki8Bh9kPH+kBrGUSFCxxbVOpEaV++EkvvjUvq7fnJ3vw4Uve0tqFe7wfBcYLq6SFu1wGM5igCVuUh7/l2Pht7CrrSjUAVeJeE5Zi1hfeo3c76HHGdqHY3bD0Iw4GjgWGFSdqmILhf+3w94w8gLpU2JdGXgHU1muvB56OxLrA9vESz62Y/ACSeCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFtD6PelGs6ZOv1/fr0spxAitCUdXzE1snHVILoZxeo=;
 b=d35tMH8+P3dhJ7QkPcVwAIKBqzx+W/mfpQyGgfSy3LRoSNwVkWbVSQzQ6DgRIJcRc9Fp0h3F/yCdwvFFIZczs4mjSdPUvKVRjwfCTZH/JpPdpyooDhl0uI6UKI8VvJEhkD1i7dKQ1PrJ/oSzr1K4dc29C44exm+lLXrjkkIp9wlTPJVhEM3edATVihrX5U97TjFGiEkL9zAFp0mOLMpzn8SyykdtNTBIt7dRCfYOWLYfyuXpW3QMrI+SfbR4GgeH+Zkfm8AEf/G53ovTOMdi7egPRubteRqBReUpEsMEuOsxz5mrAVPtiL47wI4BhRCatcM5FERSFB036s66MZYZfQ==
Received: from DM5PR07CA0043.namprd07.prod.outlook.com (2603:10b6:3:16::29) by
 BN6PR1201MB0049.namprd12.prod.outlook.com (2603:10b6:405:57::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 15:36:41 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::d3) by DM5PR07CA0043.outlook.office365.com
 (2603:10b6:3:16::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:36:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:36:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:36:40 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:38 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 2/3] net: sched: fix action overwrite reference counting
Date:   Wed, 7 Apr 2021 18:36:03 +0300
Message-ID: <20210407153604.1680079-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407153604.1680079-1-vladbu@nvidia.com>
References: <20210407153604.1680079-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4bfec1a-2249-43d8-6ad7-08d8f9daf0ef
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0049:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0049444A13D1BEFEEBFCF02FA0759@BN6PR1201MB0049.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNT/n8zMeqiFDGKCb4r3Fq8e2rdKZ99uhlq6FuM64dFE2X/XXoA8WV1tSG6QpxA6ask5YnBaLw8bsIckQm5eoyBnM3hm0EBeZkG0woK9165lpqQUwg8OtZMe7uUSeXD8uhxLSD5YQploAS9DP1jIbcb4PIglAym8HpRkSjoHkgGFXcFnJU143WuxRgrU6lxRpa1adhQTxaajh/0T8+skfDOYdxhaAMVmejZUmvtpMXJ8CEe7zw/aSvZihUecNA0opRNTRyeS12iRKSh1fudwRY1l1PvhUZKvfWn/G+lXkxgfDeEh6cNV/+HGFy+NVzY4ldRzfhWL3G7qFZCDO4tIXzfYcoyBzssKRInECGwMQiNN5Nq2wwpqB5AOARqAovehWxtdOOdqbzx/i8uAJRq/TcjbXCKlD1EfrxcHwojy5K5WQSsC/Nc73RvYwJ7kEYRaoLf6zPGWvNzYbKpo0eDWaCwbZcfVgcPTsRduR55qyiX2cOf2h/TeVbG71cSO3qpZ/XCBpzfvXq0+Zm0uWYHbSFJO4LXwZmu2CbwBn88F0viQ/MASSgiGW8cWmWScv1kDJ8mA2dBRgnwLk76O6xBDmamCfvXwVPwo1wsarDcnTI+BwCHtgQtWhzWOKgZFUoPt07Dr2VzGYRp1lcqy3IJe3Q==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(46966006)(5660300002)(36860700001)(336012)(82310400003)(4326008)(6666004)(426003)(26005)(186003)(8936002)(2616005)(356005)(7416002)(36756003)(47076005)(107886003)(2906002)(1076003)(36906005)(83380400001)(7636003)(6916009)(316002)(478600001)(70586007)(70206006)(82740400003)(86362001)(7696005)(8676002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:36:41.2184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bfec1a-2249-43d8-6ad7-08d8f9daf0ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0049
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

Reproduction:

$ sudo tc actions ls action gact
$ sudo tc actions change action gact drop index 1
$ sudo tc actions ls action gact

Extend tcf_action_init() to accept 'init_res' array and initialize it with
action->ops->init() result. In tcf_action_add() remove pointers to created
actions from actions array before passing it to tcf_action_put_many().

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V1 -> V2:
    
    - Extend commit message with reproduction and fix details.
    
    - Don't extend tcf_action_put_many() with action filtering. Filter actions
    array in caller instead.

 include/net/act_api.h |  5 +++--
 net/sched/act_api.c   | 22 +++++++++++++++-------
 net/sched/cls_api.c   |  9 +++++----
 3 files changed, 23 insertions(+), 13 deletions(-)

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
index b919826939e0..50854cfbfcdb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -992,7 +992,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
 	struct nla_bitfield32 flags = { 0, 0 };
@@ -1028,6 +1029,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	}
 	if (err < 0)
 		goto err_out;
+	*init_res = err;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1056,7 +1058,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1084,7 +1086,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					ops[i - 1], rtnl_held, extack);
+					ops[i - 1], &init_res[i - 1], rtnl_held,
+					extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1497,12 +1500,13 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 			  struct netlink_ext_ack *extack)
 {
 	size_t attr_size = 0;
-	int loop, ret;
+	int loop, ret, i;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
+	int init_res[TCA_ACT_MAX_PRIO] = {};
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0,
-				      actions, &attr_size, true, extack);
+				      actions, init_res, &attr_size, true, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -1510,8 +1514,12 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	if (ret < 0)
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
-	if (ovr)
-		tcf_action_put_many(actions);
+
+	/* only put existing actions */
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
+		if (init_res[i] == ACT_P_CREATED)
+			actions[i] = NULL;
+	tcf_action_put_many(actions);
 
 	return ret;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9332ec6863e8..9ecb91ebf094 100644
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

