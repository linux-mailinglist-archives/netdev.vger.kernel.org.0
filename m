Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56BF46E58F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhLIJcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:23 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236162AbhLIJcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bS66JnYVyz/tdWb6e1gD17/dFT/rgwnwkYJ/gQs9YIDwBkUKzVQGQBrIlE8KPB6kOwv+6N0EGiHm3VVu5eOVpO2uKIhV3+lAZkVzKxwmAs/NrBrtR8Qe7bhY4C8vWjzliBR4ZROcmQo7OZsGPqOhNL0Wa1ce/AOqml7GswiGdfM5loLFGYMOAbFekAFrWu/89RYZ7/1lZ/Og++59IjI5FTND/wlkDRFJWNqliPUml4uLR+abnnpYGfyV0nBTOc9S1A/mIgdySWae8H9Ct3G65l7Ol6J0r+66xNV3OcE0IdLwy4qY+g/1MGvcIS9V11Jw9yWllWbbpt+4v9CKE5Mfmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMXewAGOkvj1qMD8CUch6gyto3oBWutEq1PlEo0eix8=;
 b=gpLTxCbMWrlz1yWlNrOGapLwLRjbrfWlmycOsOlFulkjGsEM7zQq84V/PWJJ4Zgizdvld+3553F2r8i5yLx/KUeDGl8O6o/wJhRAb5eM8t9OpSXj/Ol0k1AHUoXNzTJQYj9fsqhPmqBkn4ydzt/1O1Qvfc3ZOnKT0XaGc+RVfejondYFL1RL2ETTKRCu1IOmivbY9XVI2wJscYyfl75ucSiWHCr70JaZnPdneykgKJTVrDQQUKxsU24hts8ilK0dSpqd4EVjZS/i7STCx/JgrdRbfMPzEhshA30bAsBH5ErotmNrT1+RKYph7VUHWLeagZAzOt84X+mDW2Se9sAATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMXewAGOkvj1qMD8CUch6gyto3oBWutEq1PlEo0eix8=;
 b=ZO3p4+HwBqAHGJzT8Xy/u8didH69NFxTallvDJqgw8H3D+2fbjKK6FXEic4ulPTMWZGiFsR3PStdpZmItKWhFDUeRlSdnbxuopKTw0b01LVdOZO1+eEwW/A2ujtwz4Ex7TFlwSRBvwKhT7+diJhpylbaPBvSqKkj6c5o8lbJ4lo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:42 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 06/12] flow_offload: allow user to offload tc action to net device
Date:   Thu,  9 Dec 2021 10:28:00 +0100
Message-Id: <20211209092806.12336-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29032c17-815c-42ea-20e2-08d9baf64a1b
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54948849CF7F570F653B1C2DE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBpXxAD4jt+d/Ha9zOqw+WoYKbs9xtWp0G3urOPFwaaC8LeEe1KTDsT/OpMJLWIZJCdnNG82+Pw5AyuZp80hPrKFIyGR/fyDVaRVrRXJq/wEF+/u/w8Yr47NUb5Z69KyDP5fVrCbWwnazraiqqjUZGl04/RCLMQgkLWhZkGRffvtesj7dttDEvtGjRCe6y9Fymcz10qpa+FDpQ9VcPnmMyWt4gTxMiFSrQxYFc0Vjv1JZc6qolmGu5q/YL7JKpJs3olB7iPPUSDAH86CCxhmXnlbDK8/X0OzJh2gIP7qD/fEJ9P1/5fn89VLHGcEkhmFhWBWkPHvbAKREYti897RtyvQKOrJuTP1MnO4R4P/SG/7Gq6ValG3gf3aBODGbGhqHjSdsS2A3fmIxNfbLBglF+m4uBZuRvIwiRzjuRB8TUGANK8132ZF+GRuEdGbI/pwgCUUghh0mHhKyV45DhYdTAZ6y23irXKGLExdzPOjVeAc6aiW5ZrdrqBTO9FnmeIcxPDqeU7sDvCUIciaSByMWzN4MdM0uYIhBSHb2KqR34xrZ0dxh+eRNaS9wMfg/JIW7rYXd1QEdy9IZZXdqpxY8w1ykBAlCZjcK5t8p2/Qj21WM2ESlpJ3Iciw4fr1SKv2sp9Od5WSfU29FrMuaLgOug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(30864003)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?20or4cZeS3XzVT9/qZrBoGtHZii7wXRqcZ9EEJU4BMkwECH0UwwiIu/eMq0F?=
 =?us-ascii?Q?jDF4oZw3k5SukMfqreVpd/8+gCF9zbaqB3u11s25XPhv0t5osr0G3LwLpdXv?=
 =?us-ascii?Q?7P/4ucx47awADjykHkk3X6OLmVsi2CcejSqoWmhmtglTlrudUB1ClcIrj1Y8?=
 =?us-ascii?Q?324Ykz+yloi4VqZad6RpQj8F1/KkWTg2cTSP1+gOAMANdBcuZlXcaK/qmpnV?=
 =?us-ascii?Q?+mOPZRrggHx9ibq+zNz7jqpyUn7X3uATvtFw4xo+nFA/9untVDgQVEC0wKQe?=
 =?us-ascii?Q?Jdb5yh1XIOP6/1xCFQs/Fwc74hbyhDS6Z67wL2VS3sk8JY03f8tlUULR7/HW?=
 =?us-ascii?Q?9T/KUF3w4tnY929380lTQ75KpxrdJEJBhwe4N5GCNI2YorSFbbyu2VzUe3hl?=
 =?us-ascii?Q?LrFAvaJ+6CDpeEJNi8xbdJu7MQJJyEjz/0uU3X4MbtUze3arxpXxJmFP0mFH?=
 =?us-ascii?Q?k5BfoQNawlURkpO35eBlQWILiDCEAefO1KzOmXYPZ4VWQ8gO63XfqtEcEj6v?=
 =?us-ascii?Q?3BZTrKuWUrcxWn77FyfKMgR9ihtqAMT27o8gjAPZgsVbJ1OOzYxFj9hX5PMk?=
 =?us-ascii?Q?1NrQgbPLW5XOUtmtRgSJzHDDRo2Iy61+soWJSxnxMfKg45ySc/WV1q0HXKi1?=
 =?us-ascii?Q?wJuZ4IvJce9pozD64XMue2U+qxxiiHABSVH2t+CEKOGC1F50YcNnCitZL/cy?=
 =?us-ascii?Q?rGfQxuYoiW05zoOXIgNaIx/xH5nD+388jzwp6mRz1Exreb0mtqHD2M/ytqx0?=
 =?us-ascii?Q?mlhj/EtPK6OVewg5uVML6t7iknh706fkgX6rhwGUxF4Dc6ujrDVk0wTpJHOQ?=
 =?us-ascii?Q?xIt11goFz9VRT5SuqcHwiOFFq+4Nj9gL2t+hM+UbMdhynLPqtyPMbQHrwwZ/?=
 =?us-ascii?Q?J+EIq4onHKPEbqkQDQe0q5gr6WmKcBORu7BL3dN3TNunzbns37+kq0Ae+caf?=
 =?us-ascii?Q?L0muo/IvrfjTqTC8MjTVviXX6cpc+1z1KZznwYu4SDWdVYlJ92HVYzAaxXE0?=
 =?us-ascii?Q?hJlUOzdXcQY0LD6ucG6W3QcIi6uoLeWENSnLbzRBaqMVqCGNbevLLBK841QC?=
 =?us-ascii?Q?/MY2D+rG6NaWEHhworg2RxgpZzmphfh5SzfF3ned8UEc3alsZ4uA6y5aejZJ?=
 =?us-ascii?Q?BtzSCYDiMvoG/Tr9Z5Rnkkm5Qm9/pRJ2bXirtLGDDJJl8oSWYwQqZPfCInp/?=
 =?us-ascii?Q?E3jvvI1tznywxWpjLprpFOi+MeabWa5k6min2ikuE4aY8D/3df0XBxvIAI8S?=
 =?us-ascii?Q?OXvdH2JDUbKx568WnmhYbGJkMUJTINEdg8GLXlQPF5Oqbn/hZTr2iK+BXyIs?=
 =?us-ascii?Q?AiVTkRNICzqrXyQ/ma1C3tnWPYhYHzHOQ/HqYDKubbi8YovHuLRmymbc8KK1?=
 =?us-ascii?Q?Y6aoyvtfCkpBJ6pdrWbD51qfiIzdAC/Fcern3SryifJMCuNTVNSuxGU28w61?=
 =?us-ascii?Q?TkjNVfSOh+cy3j98st9UKCIYwYNHwo8m+wQty+F6EKOyGqbn4hrlEWCL1nPX?=
 =?us-ascii?Q?r0SW8KwsGofbnVBPjp0G5opqCJVqzal7msTDuKCh0d16e3kI/MEcCC/RUCQo?=
 =?us-ascii?Q?f1s2/3rBffTH8HM+UwcGcd+2DP8gZspG/5gvVuQvofRDw+dbKx9aLNYw6RSC?=
 =?us-ascii?Q?kQ2B6HDpa7DlsEM0eys9n8nYFtZNs41CCPWhkJ7VTgPsevd/kYXyIJl3aKMa?=
 =?us-ascii?Q?KGYOQAClkaFV31t0AgjKqRe2pBkX86ixeUX9btjrIuov4SIckSe9DHTU7M3Y?=
 =?us-ascii?Q?0zfxV7dE4nQSg5HxrcgWSRxJLVPIYic=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29032c17-815c-42ea-20e2-08d9baf64a1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:42.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNwSbPrdH4mKMvBngO9yRhWq28GqC3Y1BHOAkE3bGmdePT1fSrwYkFBhjZN5CJlHAjB4e5eh1Pt4SMMEIJWP7HzvcmBZ2fw66w94Aq6cDPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/netdevice.h  |  1 +
 include/net/flow_offload.h | 17 +++++++
 include/net/pkt_cls.h      |  6 +++
 net/core/flow_offload.c    | 42 +++++++++++++----
 net/sched/act_api.c        | 92 ++++++++++++++++++++++++++++++++++++++
 net/sched/act_csum.c       |  4 +-
 net/sched/act_ct.c         |  4 +-
 net/sched/act_gact.c       | 13 +++++-
 net/sched/act_gate.c       |  4 +-
 net/sched/act_mirred.c     | 13 +++++-
 net/sched/act_mpls.c       | 16 ++++++-
 net/sched/act_police.c     |  4 +-
 net/sched/act_sample.c     |  4 +-
 net/sched/act_skbedit.c    | 11 ++++-
 net/sched/act_tunnel_key.c |  9 +++-
 net/sched/act_vlan.c       | 16 ++++++-
 net/sched/cls_api.c        | 21 +++++++--
 17 files changed, 254 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a748ee9a421..cb50574c5972 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -927,6 +927,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f6970213497a..15662cad5bca 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -551,6 +551,23 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum flow_act_command command;
+	enum flow_action_id id;
+	u32 index;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 193f88ebf629..13f0e4a3a136 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -534,6 +537,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..31273a10086e 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,26 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +569,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_indr_dev *this;
+	u32 count = 0;
+	int err;
 
 	mutex_lock(&flow_indr_block_lock);
+	if (bo) {
+		if (bo->command == FLOW_BLOCK_BIND)
+			indir_dev_add(data, dev, sch, type, cleanup, bo);
+		else if (bo->command == FLOW_BLOCK_UNBIND)
+			indir_dev_remove(data);
+	}
 
-	if (bo->command == FLOW_BLOCK_BIND)
-		indir_dev_add(data, dev, sch, type, cleanup, bo);
-	else if (bo->command == FLOW_BLOCK_UNBIND)
-		indir_dev_remove(data);
-
-	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
+		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+		if (!err)
+			count++;
+	}
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3258da3d5bed..120e72d8502c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -19,8 +19,10 @@
 #include <net/sock.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/tc_act/tc_pedit.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -129,8 +131,91 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+
+static int flow_action_init(struct flow_offload_action *fl_action,
+			    struct tc_action *act,
+			    enum flow_act_command cmd,
+			    struct netlink_ext_ack *extack)
+{
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (act->ops->flow_act_setup)
+		return act->ops->flow_act_setup(act, fl_action, NULL, false);
+
+	return -EOPNOTSUPP;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
+					  fl_act, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/* offload the tc command after inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_action;
+	int err = 0;
+
+	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
+	if (!fl_action)
+		return -ENOMEM;
+
+	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
+	if (err)
+		goto fl_err;
+
+	err = tc_setup_action(&fl_action->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto fl_err;
+	}
+
+	err = tcf_action_offload_cmd(fl_action, extack);
+	tc_cleanup_flow_action(&fl_action->action);
+
+fl_err:
+	kfree(fl_action);
+
+	return err;
+}
+
+static int tcf_action_offload_del(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err = 0;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
+	if (err)
+		return err;
+
+	return tcf_action_offload_cmd(&fl_act, NULL);
+}
+
 static void tcf_action_cleanup(struct tc_action *p)
 {
+	tcf_action_offload_del(p);
 	if (p->ops->cleanup)
 		p->ops->cleanup(p);
 
@@ -1061,6 +1146,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+static bool tc_act_bind(u32 flags)
+{
+	return !!(flags & TCA_ACT_FLAGS_BIND);
+}
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1103,6 +1193,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!tc_act_bind(flags))
+			tcf_action_offload_add(act, extack);
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index b55d687e3adc..26e9036240d9 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -705,7 +705,9 @@ static int tcf_csum_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->csum_flags = tcf_csum_update_flags(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CSUM;
 	}
 
 	return 0;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9edfed3b0f4b..485e4c7a086d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1505,7 +1505,9 @@ static int tcf_ct_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->ct.flow_table = tcf_ct_ft(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CT;
 	}
 
 	return 0;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 2342aa5d8284..7d2f0c9587c8 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -272,7 +272,18 @@ static int tcf_gact_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_gact_ok(act))
+			fl_action->id = FLOW_ACTION_ACCEPT;
+		else if (is_tcf_gact_shot(act))
+			fl_action->id = FLOW_ACTION_DROP;
+		else if (is_tcf_gact_trap(act))
+			fl_action->id = FLOW_ACTION_TRAP;
+		else if (is_tcf_gact_goto_chain(act))
+			fl_action->id = FLOW_ACTION_GOTO;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index cbdcbe4376bb..f149135c2e10 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -637,7 +637,9 @@ static int tcf_gate_flow_act_setup(struct tc_action *act, void *entry_data,
 			return err;
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_GATE;
 	}
 
 	return 0;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 3d96ee9bbfd8..8978a5f86dd6 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -482,7 +482,18 @@ static int tcf_mirred_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT;
+		else if (is_tcf_mirred_egress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED;
+		else if (is_tcf_mirred_ingress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+		else if (is_tcf_mirred_ingress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 69bc9e10ee3e..720f57ec9a48 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -415,7 +415,21 @@ static int tcf_mpls_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_MPLS_PUSH;
+			break;
+		case TCA_MPLS_ACT_POP:
+			fl_action->id = FLOW_ACTION_MPLS_POP;
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index f48e9765b70e..b8b64c72d686 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -421,7 +421,9 @@ static int tcf_police_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_POLICE;
 	}
 
 	return 0;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 1b0bb501218e..df7bfa688372 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -303,7 +303,9 @@ static int tcf_sample_flow_act_setup(struct tc_action *act, void *entry_data,
 		tcf_flow_sample_get_group(entry, act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_SAMPLE;
 	}
 
 	return 0;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b0d791560aa6..c4fd5dc21bbc 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -347,7 +347,16 @@ static int tcf_skbedit_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_skbedit_mark(act))
+			fl_action->id = FLOW_ACTION_MARK;
+		else if (is_tcf_skbedit_ptype(act))
+			fl_action->id = FLOW_ACTION_PTYPE;
+		else if (is_tcf_skbedit_priority(act))
+			fl_action->id = FLOW_ACTION_PRIORITY;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 14d8307c31a5..2ebc797c047a 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -827,7 +827,14 @@ static int tcf_tunnel_key_flow_act_setup(struct tc_action *act,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_tunnel_set(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+		else if (is_tcf_tunnel_release(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 5de24a995020..5f0ed3b5a5ac 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -395,7 +395,21 @@ static int tcf_vlan_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH;
+			break;
+		case TCA_VLAN_ACT_POP:
+			fl_action->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 33b81c867ac0..2a1cc7fe2dd9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3488,8 +3488,8 @@ static int tc_setup_flow_act(struct tc_action *act,
 #endif
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	int i, j, index, err = 0;
 	struct tc_action *act;
@@ -3498,11 +3498,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3531,6 +3531,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+#else
+	return 0;
+#endif
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
-- 
2.20.1

