Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C913D20BD
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhGVIjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:39:22 -0400
Received: from mail-mw2nam10on2126.outbound.protection.outlook.com ([40.107.94.126]:12705
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231421AbhGVIjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:39:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVrO/Q5YXFkNDoq37jglLGKkijI1uHY52svR6FkT0VVqU51CC0lEKZQQG2fDrDvxWPOBO6mgE8YG8W3QZGMobsTVMKXprf8kC60WmfS3uTXBTzcHjbNYF5GJvj4Xad8pYUZ4iv32fX1kd4aqOb1ZcFFVYsIT1bKHiWvYq4mogBFu4Rf37hKktSuHNDINVK4JcEqjxQInbD3hy7X9Vmdmrt669o+OV1ySMd+uc2V4H985dzLgcIPe62qJeLOqoD2nJwqlXqk9dE+JjNjyeTw5EpOhNazw4F0BR5NEHV/ubsL+9xdtmUrUd+h+6bYU2Rlz8f2vaDTMV8LFDGY1tMAmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBClcTPo2YiHUEHQ+/1LalfBn411jXgnDu/PohhgmjM=;
 b=EvUlTcsD7fOnjqXdKZy4vnJBa+xB2yrZdNl1EOzAjHJJVpnBdURmZO2P7ypSf++y+CwK6NTu1cD3GBAwjItBDryrToa493I2hMDyfT1NrrnYg7b0Vvc8dgOeaAMmFWWTKpO3WaY/0lI2KD1vBa9Bwlbai5iqdgSHg21+MNa/YJkbxU3K4/sAXY9JzkTs+QDn6/3h9EM8+upYOly3WvIYBuEPlyzYc2s2kZg2Qvl1FaJjvUsu9VzBKH98qIz069EfsrQLEvjEmUsgcKyUZr6DHiVv17qh0klyd4eUAJPVUGjIxPBiG5g4M2J0TNk06JPN/5UI9XHUk7n2fIbXgVGHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBClcTPo2YiHUEHQ+/1LalfBn411jXgnDu/PohhgmjM=;
 b=IHKJ9X1JwypsNdlxlYPwsv5WHnZRaHx6qToRW2Jypgwdhl/w0W9ghFU3oidxSOt2EJRbnac7ySLBHFwW98Ns60Ehk6L2dDn76SmxG4OCNym+Vo9r602iebD9n9MkH/tpDtMf0prc8w7O/oZBt9hgRQe6q+LEYpQLz5h6WYIg4HQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 09:19:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 09:19:55 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/3] flow_offload: add process to delete offloaded actions from net device
Date:   Thu, 22 Jul 2021 11:19:37 +0200
Message-Id: <20210722091938.12956-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722091938.12956-1-simon.horman@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 09:19:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5644d2-8be2-403a-faca-08d94cf1de9d
X-MS-TrafficTypeDiagnostic: PH0PR13MB4841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB484192A3601D4B63BFD075CBE8E49@PH0PR13MB4841.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFM/aw8od7ciTWqSdYjf2OT3E75+XJXo9DxsT5EYuenHXm7CtDjnlQi20WVob3G4l/elT7NliV32euqRbmg0PNn1d18zu7jyGKK/F6/56dx9OIz7ZZb54mBo1QzFtTx62f8WlRpP0wpN6iuwmkmhTnTXFMq2Eqihm42jKDxPaAso02swnAvOVnKn8hXmjCgiFuXataa1U6J3D9jvfEPpiYgCqjbyd9AjoNIqaamkYu5Hal56jGGIxy+igZLSnOgvsNQWGbmPQnx4fv6nTYd7emDQO1t+dtPb6hw+5WjhH8NKzuvveYGBRt+aTOwO9/pMF0u7BcTiGH4Bkrm+PfUA1saDjSmPYfGBsOi4rDAvW5sCBt7MZgx7OG93+MQvQ0Thao60JGhUZC70BSoAIbIly1hUDounUI+jA98J8bSIFsK0gjTRL2atXFmVvegJFEBKYtPz/HrhTjgdWxXqlX/36clVx3BLK0q+0DpiJABoZ0jFMlB96OEto9/k0x+RqN9kJ7ZT2FOv0Abii9Qm6NeOjtXOCNvAG60jjmjwu4KiSgvVx3zAKcgWVZhswhJUaPC+DJ6z9yZmX0rfF74iYaifj71HfwCPrU1ipQUUb4216oMv2DIIrHeEiR3Rgqj9/e9+aWyMMxbiRuVD+dEZduMh2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(6486002)(86362001)(8676002)(6666004)(2616005)(6512007)(2906002)(54906003)(83380400001)(36756003)(66476007)(66556008)(8936002)(1076003)(107886003)(66946007)(110136005)(4326008)(186003)(44832011)(38100700002)(508600001)(316002)(52116002)(5660300002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GxbPXmIEycdvkcwANvtDffY1T67pPVYk9ClNuJvYix6KJCojb1QO6U1XI2Ik?=
 =?us-ascii?Q?w+L/y10SIza5OGvI71sD5Bwe4AeApqK/kGvbtXgf2gBKnkystwhmDR/aFOfz?=
 =?us-ascii?Q?qCy0rTEXqZidcTjELVN8Et1rlOzzz/do877VVnTJzr0J8iQfz6rVoYb2SKef?=
 =?us-ascii?Q?zOX/6YYu4G6HhAxcuGoWh6wYyibwmk/lwF6LTh8VHbvbbLgy4Un2sG5ovmk+?=
 =?us-ascii?Q?4Zc31QrOU2tI1y4Sa7rfEj2frspyOTdMRYYqxBWa94HMByxw7LxbA80RCNPH?=
 =?us-ascii?Q?vw8YL3AIy73irBCQwcNauGrF/+eBgb9VqMoOwMZl7j+XqXtfT3Gc10JDcZaj?=
 =?us-ascii?Q?wUkmI4h1sQXXbwjcPGji0VlbOqq1eLUXfJ+gJfUc4tyhBSpZX+1fq/akq5hQ?=
 =?us-ascii?Q?8tdXcpJvy8RK3GUldbgTQOAA59hwi+nG5J+gxxLGi/PrkqGzYR+ppkiUnQfH?=
 =?us-ascii?Q?aZG+lgKzHI8MV0kKfslQ7PcRFqHmnDqsjCkkiEUGD/tj5TVOPfsYeS1iph92?=
 =?us-ascii?Q?EL02lIaPaD7xeE6TX2MKMIwzb3LDgOmBvoZgpTGsi7xj6IMM55q9noxgotwz?=
 =?us-ascii?Q?tAHhbDaurSmS64nK+7mFWAxRWtC/AApM1QHkdo+712bBjGDvCva3zmksTZqw?=
 =?us-ascii?Q?AkheUNlthuZX23vh60CROCb2tRU6BzNHVGWkNhJKA8owcy/MNSoFVfJrpwDs?=
 =?us-ascii?Q?PpSXd/RNmklme3Bj9TI6pd3n08a5xkpA47k9TpT7ojBy61qlGiXHFaNMGIQv?=
 =?us-ascii?Q?isH7P8XQXAAuC1oReWQ5D14jE4Uln/roLXlSDK7GGs3PAjk8qF+g5Px/dkPg?=
 =?us-ascii?Q?UCWBkSkeooiIbMsQSDe8NrQ1Ip0ISfBZUIm/bSTpO9RpmgkQ3VjrZvM+RbWF?=
 =?us-ascii?Q?bjoTQZWS3svJPrcbBWj/rB+OWngGZ8z4xSwO+VJ+SOy+XZFLcS6DFE8fYIwM?=
 =?us-ascii?Q?S+fgC2UQtSID0XSoh2sFK5fMHRBJ35FuzxwQH5nIDNaFIoVD9e5unr+ZKso4?=
 =?us-ascii?Q?SyMvss/CXu12qcSS06TX1rzRf4SeT32c2Uz8haVUEwOGov1HfY+8M4t0QoEC?=
 =?us-ascii?Q?EEe4klCp7yyZDJjlzatTvXkZdzaFkgUC7N6RFjgP3w6CqGUeoZKJ7XPsET+m?=
 =?us-ascii?Q?AXzmszDMF4vlYG6/9q+XyuP/DN0VbWrPLsuJLfo3ONN1DQ5lAUQq9ZFhULKk?=
 =?us-ascii?Q?vkdJCTZm3HfnGwvundyZEykjzmcOqtj+fFqAYUQyDF8rScWdCG8v537nYusK?=
 =?us-ascii?Q?HjIr3LlY69pwgph9JmPZgntzsJKrexlqcpW9Cb/FyZZhvd7bnb4SU41zM/x1?=
 =?us-ascii?Q?ke8HC2yV/7s8Xba+xesLKvvjqKPTAxgOsw0g1c8yGcSfwXONLGgpqTem3MVx?=
 =?us-ascii?Q?4bAcehuzVgfG0/lwTMJ5qNjETp01?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5644d2-8be2-403a-faca-08d94cf1de9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:19:55.6734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjnZ6HIIWmSuBtmSjL6uiqT9Y5n1eWrqpLxY3CO8tOYExjrbzkiuMT8hiQOHpRqjoucC1P1Q0uNMDU2Db0bhGJF6i16S5PfmVO4SIVNDZno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add a basic process to delete offloaded actions from net device.

Should not remove the offloaded action entries if the action
fails to delete in tcf_del_notify.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/pkt_cls.h |   1 +
 net/sched/act_api.c   | 112 +++++++++++++++++++++++++++++++++++-------
 net/sched/cls_api.c   |  14 ++++--
 3 files changed, 106 insertions(+), 21 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index cd4cf6b10f5d..03dae225d64f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -573,6 +573,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 unsigned int tcf_act_num_actions(struct tc_action *actions[]);
+unsigned int tcf_act_num_actions_single(struct tc_action *act);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 185f17ea60d5..23a4538916af 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1060,36 +1060,109 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
-/* offload the tc command after inserted */
-int tcf_action_offload_cmd(struct tc_action *actions[],
-			   struct netlink_ext_ack *extack)
+int tcf_action_offload_cmd_pre(struct tc_action *actions[],
+			       enum flow_act_command cmd,
+			       struct netlink_ext_ack *extack,
+			       struct flow_offload_action **fl_act)
 {
-	struct flow_offload_action *fl_act;
+	struct flow_offload_action *fl_act_p;
 	int err = 0;
 
-	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
-	if (!fl_act)
+	fl_act_p = flow_action_alloc(tcf_act_num_actions(actions));
+	if (!fl_act_p)
 		return -ENOMEM;
 
-	fl_act->extack = extack;
-	err = tc_setup_action(&fl_act->action, actions);
+	fl_act_p->extack = extack;
+	fl_act_p->command = cmd;
+	err = tc_setup_action(&fl_act_p->action, actions);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to setup tc actions for offload\n");
 		goto err_out;
 	}
-	fl_act->command = FLOW_ACT_REPLACE;
+	*fl_act = fl_act_p;
+	return 0;
+err_out:
+	kfree(fl_act_p);
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_offload_cmd_pre);
+
+int tcf_action_offload_cmd_post(struct flow_offload_action *fl_act,
+				struct netlink_ext_ack *extack)
+{
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
 
 	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
 
 	tc_cleanup_flow_action(&fl_act->action);
-
-err_out:
 	kfree(fl_act);
-	return err;
+	return 0;
+}
+
+/* offload the tc command after inserted */
+int tcf_action_offload_cmd(struct tc_action *actions[],
+			   struct netlink_ext_ack *extack)
+{
+	struct flow_offload_action *fl_act;
+	int err = 0;
+
+	err = tcf_action_offload_cmd_pre(actions,
+					 FLOW_ACT_REPLACE,
+					 extack,
+					 &fl_act);
+	if (err)
+		return err;
+
+	return tcf_action_offload_cmd_post(fl_act, extack);
 }
 EXPORT_SYMBOL(tcf_action_offload_cmd);
 
+/* offload the tc command after deleted */
+int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
+				struct tc_action *actions[],
+				struct netlink_ext_ack *extack,
+				int fallback_num)
+{
+	int fallback_entries = 0;
+	struct tc_action *act;
+	int total_entries = 0;
+	int i;
+
+	if (!fl_act)
+		return -EINVAL;
+
+	if (fallback_num) {
+		/* for each the actions to fallback the action entries remain in the actions */
+		for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+			act = actions[i];
+			if (!act)
+				continue;
+
+			fallback_entries += tcf_act_num_actions_single(act);
+		}
+		fallback_entries += fallback_num;
+	}
+	total_entries = fl_act->action.num_entries;
+	if (total_entries > fallback_entries) {
+		/* just offload the actions that is not fallback and start with the actions */
+		fl_act->action.num_entries -= fallback_entries;
+		flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
+
+		/* recovery num_entries for cleanup */
+		fl_act->action.num_entries = total_entries;
+	} else {
+		NL_SET_ERR_MSG(extack, "no entries to offload when deleting the tc actions");
+	}
+
+	tc_cleanup_flow_action(&fl_act->action);
+
+	kfree(fl_act);
+	return 0;
+}
+EXPORT_SYMBOL(tcf_action_offload_del_post);
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1393,7 +1466,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static int tcf_action_delete(struct net *net, struct tc_action *actions[])
+static int tcf_action_delete(struct net *net, struct tc_action *actions[], int *fallbacknum)
 {
 	int i;
 
@@ -1407,6 +1480,7 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 		u32 act_index = a->tcfa_index;
 
 		actions[i] = NULL;
+		*fallbacknum = tcf_act_num_actions_single(a);
 		if (tcf_action_put(a)) {
 			/* last reference, action was deleted concurrently */
 			module_put(ops->owner);
@@ -1419,12 +1493,13 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 				return ret;
 		}
 	}
+	*fallbacknum = 0;
 	return 0;
 }
 
 static int
 tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
-	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
+	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack, int *fallbacknum)
 {
 	int ret;
 	struct sk_buff *skb;
@@ -1442,7 +1517,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	}
 
 	/* now do the delete */
-	ret = tcf_action_delete(net, actions);
+	ret = tcf_action_delete(net, actions, fallbacknum);
 	if (ret < 0) {
 		NL_SET_ERR_MSG(extack, "Failed to delete TC action");
 		kfree_skb(skb);
@@ -1458,11 +1533,12 @@ static int
 tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	      u32 portid, int event, struct netlink_ext_ack *extack)
 {
-	int i, ret;
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t attr_size = 0;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
+	struct flow_offload_action *fl_act;
+	int i, ret, fallback_num;
 
 	ret = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
 					  extack);
@@ -1492,7 +1568,9 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	if (event == RTM_GETACTION)
 		ret = tcf_get_notify(net, portid, n, actions, event, extack);
 	else { /* delete */
-		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
+		tcf_action_offload_cmd_pre(actions, FLOW_ACT_DESTROY, extack, &fl_act);
+		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack, &fallback_num);
+		tcf_action_offload_del_post(fl_act, actions, extack, fallback_num);
 		if (ret)
 			goto err;
 		return 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9b9770dab5e8..23ce021f07f8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3755,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+EXPORT_SYMBOL(tcf_act_num_actions_single);
+
 unsigned int tcf_act_num_actions(struct tc_action *actions[])
 {
 	unsigned int num_acts = 0;
@@ -3762,10 +3771,7 @@ unsigned int tcf_act_num_actions(struct tc_action *actions[])
 	int i;
 
 	tcf_act_for_each_action(i, act, actions) {
-		if (is_tcf_pedit(act))
-			num_acts += tcf_pedit_nkeys(act);
-		else
-			num_acts++;
+		num_acts += tcf_act_num_actions_single(act);
 	}
 	return num_acts;
 }
-- 
2.20.1

