Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1466F41EC01
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353945AbhJALfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:35:04 -0400
Received: from mail-bn7nam10on2122.outbound.protection.outlook.com ([40.107.92.122]:44000
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353961AbhJALfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:35:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDXuPMLB/QUbzBLDrPvYSKQ6M5uZvmyyd7aQ0BVS+LWK85O3reqnhuNut6/M1CGbKOwWntAY7hPnlcVtg3w5/OREyWiZbVLM2ICbb6UrI74ZAEgn9uQXKxQYFeAuA6OCPQQRwxB7Iwh6u9L8AA1d9wLGLel6B04EkDoi35JKdbJx8qdpGoCt0Otw9Pna4xzWBk3anL3ShAyuH4UMsd7wA9STcMkH2r9dT0Lt5b0tIHKSIdh/jtfJb6ivNJc9ybkM5RIaLCODvf9QxYTBXAeD66ozKeUGt4HU2mP9MjEUmsAmTWeVuCDvl0Is+AgLlshdatVa0bOx7dj6SwUrjwxlwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BCxRFOUNyJp1jBnaudP75DOn+U7vMhQxZdHkdAqoHo=;
 b=mG8OXJg+8sMMtP8w5JY1FcHskN9RkKSQsfQMELAlXhvaAv5jllTgbcDGmmoUpsKxU8KX7ny6BxH5q7lF8OdKMlTrobkJLBJ6f9NednIPXlJuDYOwANdkZR+p+Unyx5PEdslSbbiHSKdgMAxDrI5tw8xhvL535xog2bjMNbw1veVKLM8I2twVtgBb2tLCEyJ9Hn3j7vYZS1nIAoTosJgNu7PzpxCLlpqAMdDBc4f89v5Ku4OyNT1jl2QIEMfx0qPQRpvcY7os0nsCxobDHC3tl3CcxT3Nyx9OPJlUBazTn8Vf6TE2fR31GJ2r4qrby/5OQzyrbiUTwdctO69vkP1u2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BCxRFOUNyJp1jBnaudP75DOn+U7vMhQxZdHkdAqoHo=;
 b=HfmsAMKACPWwNXFgTN9xoDTvWmG/s3IXEplJrzGpAMvNVQpXa0Zah25q9808pPVGg70/0GC1caWB+46ngu6FCwgI3wW/b/3GQYE8R5wAymuekNpFx/2r5SRqVyTBp7ChwbcGCacCsBc5RQzOIW7qg9MATa7+1Wohjeqtr2NO7as=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY5PR13MB3362.namprd13.prod.outlook.com (2603:10b6:a03:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9; Fri, 1 Oct
 2021 11:33:13 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:13 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v2 4/5] flow_offload: add reoffload process to update hw_count
Date:   Fri,  1 Oct 2021 13:32:36 +0200
Message-Id: <20211001113237.14449-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211001113237.14449-1-simon.horman@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20f8b0fd-88c3-4b08-fb51-08d984cf40e8
X-MS-TrafficTypeDiagnostic: BY5PR13MB3362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR13MB336206BBA7FDDCA006A941CAE8AB9@BY5PR13MB3362.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eU43flo8249aUuu9Sy37HI/KY72SXwt/kgol9WJQOGQ6/vpETouF9wk9ii9Nj5DmvwqMgaX2dOcstwpo44Bt6zmJMEXRhTAkfpoTgfWzdkinyD737Wjv3NmI6bnCE6sv7KKzwhcvSgbordrn/qEKHTHnuGE0USzwDwShONXljrmnxNr8HlaErxKp5/J6oisVLzNTg2OWkXo3y6rMEmtgumj96FnydCKagxMv8rFvl264CiXhl0DWl1EvP0p6QnUV6oIhzfaMDO40dONTv9Gww8E4GeSZjsofMBSAPRNSL6SYBnAxKF8H1WdfVXsoCs7y3GpupiptuVmJmjDBL+hKJOTT65IBrDo9ncIeumyYaI6FjLS5lQpeUgJTedWwa6YUWGco2x5Sti+aXZiA1ZEDpFQuufzaFKENVYCQ78q1Sqp/9beWINsrHIMUDKbEGyTiqik2ITnl8k46N1ix/CsxNRLKoljuAFOmBkLks7XAwcp6glVSP/MdZPyLLOk7qK5SWkn+ewnI66TIEciTtmpAD0m9H54mVvBkAL5F5RiQtGe3CDfkzX0CdM7MSD7j7B7Vm+BCcIq3lUCSzVlgdRDU7vEFjs3J+yfUuKHl3OFVpyIt9w7Q8sX0LFcc4zI4zEjD56EozWhvZsnhAZ8FqS9GDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(346002)(366004)(396003)(6486002)(66556008)(66946007)(186003)(6666004)(5660300002)(6512007)(86362001)(66476007)(2616005)(30864003)(1076003)(6506007)(8936002)(15650500001)(38100700002)(2906002)(6916009)(83380400001)(44832011)(508600001)(52116002)(8676002)(107886003)(316002)(36756003)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VzycvsNje338b1TCSznPr5HbEQ70+tcoCdHqSvFdoSNFHYvcba9TiB3puePQ?=
 =?us-ascii?Q?Itm2TeBpUfrYRSSXUwbL8Xb4JMffYU5H4XrdplXQJiQblCV5KdYtZBn/BwDj?=
 =?us-ascii?Q?8wGIXNGLvcoeTaqm/2YARiQlL3I7qyfaayqXpFiP+vcYo+xPmu7av+d8vsei?=
 =?us-ascii?Q?rOSl9dF4usbCenaXOV9yOpwKff0L30dUzIre/dec0zjrbozRlDZ53auh9Swz?=
 =?us-ascii?Q?kSwxkBbGWFeh6HFoteml7grYEWwfWX1IxgLTEDoZKWibnchOoOFMcT5ZPvWy?=
 =?us-ascii?Q?QYwp37FwxhoFBz+JzhaxgEqEMSIrdj0bU7nYq2aLAkjWJ7nr62E3qhagTHOM?=
 =?us-ascii?Q?QibDOUEOSUE3mDFFiV1GogiRn885ZNB0pfn85sXNFWu5xKKI7GrnqSsI+qIq?=
 =?us-ascii?Q?6BcxByuFRilqBYLQS/IHGmhXsXWpftaFl56M/nw1S25lL4n7WoVqZdoNp1jq?=
 =?us-ascii?Q?GpW/avlJvjdXH6HMh52jDIs/cB1PtdzvE+T6Zv3yavwU+4v/Cup4v/n6zrnA?=
 =?us-ascii?Q?0W1WwDn+DCRMLXlSQuQu9gbzRh7XS7dcvEF1RV882DiVewmPOc/LiyQUWt55?=
 =?us-ascii?Q?0rc1PtIkg/26ZqMn0GPnAspIPvD3ZE8NUU8NQcUjnYKH5Xn3xMuUU7V4+bAd?=
 =?us-ascii?Q?ZKJvQe1slWYYxvGXAju8o7vAewt6yuNjsfurSpiIjasMeCW8K3V491tYnV8p?=
 =?us-ascii?Q?4+8IifoBbyQLubo7GTnc3IY+/2z2rKhxCwPYBdfajN48DxSxBjFVIucDT2ki?=
 =?us-ascii?Q?OLz181YktKOXL9ZKHTWBErzLjcTLknASLzFi9PbiInTLQFYuHL0aMMpFKfOi?=
 =?us-ascii?Q?9AZwGLEVOq/TJ1wGxgzUvI0CX4h53zH5vVZNcglQuoo6eDvkSy9TY8UE+PA8?=
 =?us-ascii?Q?vU4E+Wxv7zbpugj39I5zfoh4TiBsAVt2m7uAHlBGffgcq5Cx3TiFH49OtI8+?=
 =?us-ascii?Q?Dk4EEjoXzmife84XOzlQoHaq5+MgnlecxsidnSPsza8/3PfUrTh8cQHi6Ny8?=
 =?us-ascii?Q?mheKDS8KCOOQR1F1gxVYn6omiz9WmiX8QNg03ehCHYrHIyRG//w4T+6Gs4dy?=
 =?us-ascii?Q?Fhrg34Lr/3NZ0O1AjhW8dH4f0kgotuElwnnvCLDMX+YBh0BsLwQRxcXpprrl?=
 =?us-ascii?Q?pnfgPqnWzOZWMQlB4Kt2+ZQ/MU9wW+mrgTbp6BGBGIvwz9904Cg4MPL4uPLf?=
 =?us-ascii?Q?x/qLhhFGjkbqKX20AcLzRoOoAoG700MofEV1K9nkpJnFxwcSdCfDkew+y/mM?=
 =?us-ascii?Q?4ACfWvMBnJwG36nw2/MqDvZi+1oLDHvi5IFykb5pDAyCs0q+dxV3qPukZxer?=
 =?us-ascii?Q?xJJ6WF97XtALDjue+31Ub0PAcAq7lliBgGYewanBmgumbSXNQQXUdDy2c/sw?=
 =?us-ascii?Q?5Zxpmyn4aTcmdbSYCHKNfPmKim0c?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f8b0fd-88c3-4b08-fb51-08d984cf40e8
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:13.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwRQK+jYPUlTDBkKsCUQ92jNtg7S4f9LW45Aw7F5Ao9ZA2Or+Ndkt7t5fxh8iI8uAMcTJMjjlAnTX1k6P3NNx/jfndN3qEk7koSmE9QZ9zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add reoffload process to update hw_count when driver
is inserted or removed.

When reoffloading actions, we still offload the actions
that are added independent of filters.

Change the lock usage to fix sleeping in invalid context.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h   |  14 +++
 net/core/flow_offload.c |   5 +
 net/sched/act_api.c     | 215 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 214 insertions(+), 20 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 1209444ac369..df64489d1013 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -7,6 +7,7 @@
 */
 
 #include <linux/refcount.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -44,6 +45,9 @@ struct tc_action {
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
+	bool                    add_separate; /* indicate if the action is created
+					       * independent of any flow
+					       */
 	u32 in_hw_count;
 };
 #define tcf_index	common.tcfa_index
@@ -242,6 +246,8 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 int tcf_action_offload_del(struct tc_action *action);
 int tcf_action_update_hw_stats(struct tc_action *action);
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
@@ -253,6 +259,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
 #endif
 
 int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+
+#else /* !CONFIG_NET_CLS_ACT */
+
+static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+					  void *cb_priv, bool add) {
+	return 0;
+}
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6676431733ef..d591204af6e0 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/act_api.h>
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
@@ -418,6 +419,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
@@ -472,6 +475,8 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 
 	flow_block_indr_notify(&cleanup_list);
 	kfree(indr_dev);
+
+	tcf_action_reoffload_cb(cb, cb_priv, false);
 }
 EXPORT_SYMBOL(flow_indr_dev_unregister);
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c98048832c80..7bb84d5001b6 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -512,6 +512,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
 	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->add_separate = !bind;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -636,6 +637,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
 static LIST_HEAD(act_base);
 static DEFINE_RWLOCK(act_mod_lock);
+/* since act ops id is stored in pernet subsystem list,
+ * then there is no way to walk through only all the action
+ * subsystem, so we keep tc action pernet ops id for
+ * reoffload to walk through.
+ */
+static LIST_HEAD(act_pernet_id_list);
+static DEFINE_MUTEX(act_id_mutex);
+struct tc_act_pernet_id {
+	struct list_head list;
+	unsigned int id;
+};
+
+static int tcf_pernet_add_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+	int ret = 0;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			ret = -EEXIST;
+			goto err_out;
+		}
+	}
+
+	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
+	if (!id_ptr) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	id_ptr->id = id;
+
+	list_add_tail(&id_ptr->list, &act_pernet_id_list);
+
+err_out:
+	mutex_unlock(&act_id_mutex);
+	return ret;
+}
+
+static void tcf_pernet_del_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			list_del(&id_ptr->list);
+			kfree(id_ptr);
+			break;
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+}
 
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
@@ -654,18 +708,30 @@ int tcf_register_action(struct tc_action_ops *act,
 	if (ret)
 		return ret;
 
+	if (ops->id) {
+		ret = tcf_pernet_add_id_list(*ops->id);
+		if (ret)
+			goto id_err;
+	}
+
 	write_lock(&act_mod_lock);
 	list_for_each_entry(a, &act_base, head) {
 		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
-			write_unlock(&act_mod_lock);
-			unregister_pernet_subsys(ops);
-			return -EEXIST;
+			ret = -EEXIST;
+			goto err_out;
 		}
 	}
 	list_add_tail(&act->head, &act_base);
 	write_unlock(&act_mod_lock);
 
 	return 0;
+
+err_out:
+	write_unlock(&act_mod_lock);
+	tcf_pernet_del_id_list(*ops->id);
+id_err:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -684,8 +750,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
 		}
 	}
 	write_unlock(&act_mod_lock);
-	if (!err)
+	if (!err) {
 		unregister_pernet_subsys(ops);
+		if (ops->id)
+			tcf_pernet_del_id_list(*ops->id);
+	}
 	return err;
 }
 EXPORT_SYMBOL(tcf_unregister_action);
@@ -1210,29 +1279,57 @@ static void flow_action_update_hw(struct tc_action *act,
 	}
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
-	if (IS_ERR(fl_act))
-		return PTR_ERR(fl_act);
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
+					  fl_act, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	if (hw_count)
+		*hw_count = err;
 
-	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
+	return 0;
+}
+
+static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
+					u32 *hw_count,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv)
+{
+	int err;
 
+	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
 	if (err < 0)
 		return err;
 
 	if (hw_count)
-		*hw_count = err;
+		*hw_count = 1;
 
 	return 0;
 }
 
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
+				  flow_indr_block_bind_cb_t *cb,
+				  void *cb_priv)
+{
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
+
+	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
+						 cb, cb_priv) :
+		    tcf_action_offload_cmd_ex(fl_act, hw_count);
+}
+
 /* offload the tc command after inserted */
-static int tcf_action_offload_add(struct tc_action *action,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_add_ex(struct tc_action *action,
+				     struct netlink_ext_ack *extack,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
@@ -1260,9 +1357,10 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
 	if (!err)
-		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_ADD);
+		flow_action_update_hw(action, in_hw_count,
+				      cb ? FLOW_ACT_HW_UPDATE : FLOW_ACT_HW_ADD);
 
 	if (skip_sw && !tc_act_in_hw(action->tcfa_flags))
 		err = -EINVAL;
@@ -1275,6 +1373,12 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
+}
+
 int tcf_action_update_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -1287,7 +1391,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		goto err_out;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 
 	if (!err && fl_act.stats.lastused) {
 		preempt_disable();
@@ -1309,7 +1413,8 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-int tcf_action_offload_del(struct tc_action *action)
+int tcf_action_offload_del_ex(struct tc_action *action,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_offload_action fl_act;
 	u32 in_hw_count = 0;
@@ -1325,13 +1430,83 @@ int tcf_action_offload_del(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
-	if (err)
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
+	if (err < 0)
 		return err;
 
-	if (action->in_hw_count != in_hw_count)
+	/* do not need to update hw state when deleting action */
+	if (cb && in_hw_count)
+		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_DEL);
+
+	if (!cb && action->in_hw_count != in_hw_count)
+		return -EINVAL;
+
+	return 0;
+}
+
+int tcf_action_offload_del(struct tc_action *action)
+{
+	return tcf_action_offload_del_ex(action, NULL, NULL);
+}
+
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add)
+{
+	struct tc_act_pernet_id *id_ptr;
+	struct tcf_idrinfo *idrinfo;
+	struct tc_action_net *tn;
+	struct tc_action *p;
+	unsigned int act_id;
+	unsigned long tmp;
+	unsigned long id;
+	struct idr *idr;
+	struct net *net;
+	int ret;
+
+	if (!cb)
 		return -EINVAL;
 
+	down_read(&net_rwsem);
+	mutex_lock(&act_id_mutex);
+
+	for_each_net(net) {
+		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+			act_id = id_ptr->id;
+			tn = net_generic(net, act_id);
+			if (!tn)
+				continue;
+			idrinfo = tn->idrinfo;
+			if (!idrinfo)
+				continue;
+
+			mutex_lock(&idrinfo->lock);
+			idr = &idrinfo->action_idr;
+			idr_for_each_entry_ul(idr, p, tmp, id) {
+				if (IS_ERR(p) || !p->add_separate)
+					continue;
+				if (add) {
+					tcf_action_offload_add_ex(p, NULL, cb,
+								  cb_priv);
+					continue;
+				}
+
+				/* cb unregister to update hw count */
+				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
+				if (ret < 0)
+					continue;
+				if (tc_act_skip_sw(p->tcfa_flags) &&
+				    !tc_act_in_hw(p->tcfa_flags)) {
+					ret = tcf_idr_release_unsafe(p);
+					if (ret == ACT_P_DELETED)
+						module_put(p->ops->owner);
+				}
+			}
+			mutex_unlock(&idrinfo->lock);
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+	up_read(&net_rwsem);
+
 	return 0;
 }
 
-- 
2.20.1

