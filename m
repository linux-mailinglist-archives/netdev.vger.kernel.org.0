Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52541F323
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355307AbhJARcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:32:32 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:27430
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229532AbhJARcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 13:32:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaTvFa7ZDfmz8MqaFNUr9EFFzswxXOFqQk6sZxFqVw/+VBwZ5zTWdeL02T0UMmR90PCPHkMSziyA7a2dbkw32AReOKVq/ts14CFy1vJRs4+cc15NL+1AJdGdGOCtyFKLJS/zrxBd6NYZLwt49eTZkl1NOGmzzvP8WU8V7aC3GkCbj5EK6Ma0aiZVlmGjvztnWBcMPFHr/ZySHJuXczfGvuKLpzUDnYostb2YOvVIJadT/zkSqHsPfJlmSonhCkV9PRoWdrdGbVqo9xE5tBYAcnDEfhEuVtEJwZBzPyULuY02MiO3W6vdln5FN0954HaBsM4NrZARhOA4CJxz3/3erg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gQndLwaL5i54Dy4iTTrv8ybkr3RdzQZTGn7Tw17308=;
 b=SkRC8QQimw7yx9wrS09Z+6XMrc2anSd06fA56pZ6SN/iEScDz3F9FBjRIsq3pouFr2gFKVUtPIhE1tb3wr/LyO4Qqd+44OL/XdJzMHyfi1A5ilshk8qNPr0KS94UBuGeM3lNuvKq++TNUUOh7gDUF5aCQCPh6PkuFsXGfFbTQZHo0Ly+msudlKIgzmHifA6KhyB52ShivPva2OTlb0R/eHSebahq0NDmxrjcwkJjFJTgKJ5Dg0z96DpkbEdpZC4u6ZYo8d+m6Qbzj+AYJn0p3wceVmAYkTNQi+C45gAkdklYTgorkJCNi1IwSAksh0Jx8H/WZaX9LUqLi05PR55FlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gQndLwaL5i54Dy4iTTrv8ybkr3RdzQZTGn7Tw17308=;
 b=qfPPEAw6RWYVdRfb9rTcDFJGgzpGPKdrVcp/NwxHBl+9y7eBTJyLF7JqVIJLA7pdEowhWrShfM8QAMubABYtU8LLaZ1JNbX6hYfXjIc/I1mC/usiXkKKps88/XbB37JIoarTsTcfCx5ZBq26HxTTIVgnA8FKOy5ddqmMiTr8hIFMB7In9psfdxu46ytvXdSW2zlOfFR055I8J01JHcl8HRvYHVSy+KjM40RTrWjEbadgNjnjIq+Qk3rBj+Z/KM5867jPtdvzlCjhpf2WWKDd9Q1iCmjgpWyrRfswb6iBMeP1bNuEveRtHwQa/ERhj8zQWSf/XRym57M/11lJMQL5ZQ==
Received: from DM5PR06CA0035.namprd06.prod.outlook.com (2603:10b6:3:5d::21) by
 BN7PR12MB2756.namprd12.prod.outlook.com (2603:10b6:408:29::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.13; Fri, 1 Oct 2021 17:30:45 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::af) by DM5PR06CA0035.outlook.office365.com
 (2603:10b6:3:5d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Fri, 1 Oct 2021 17:30:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 17:30:44 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 1 Oct 2021 17:30:42 +0000
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-5-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 4/5] flow_offload: add reoffload process
 to update hw_count
In-Reply-To: <20211001113237.14449-5-simon.horman@corigine.com>
Date:   Fri, 1 Oct 2021 20:30:38 +0300
Message-ID: <ygnhk0iwbqkh.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1334562c-3f5a-4f82-4bbc-08d985013341
X-MS-TrafficTypeDiagnostic: BN7PR12MB2756:
X-Microsoft-Antispam-PRVS: <BN7PR12MB27565CEEA3F2794764D33ABAA0AB9@BN7PR12MB2756.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzdhG/g5XpG/bNR8DBXJoj9+qFYIUWxnci0u65RkYkuIJdjCkkjpQvacJ1OYIu1cWBbPOgvWJeyDMlr7VVxUEKSHaFANuLd/AeHxtTTqxdKhi32wo2gswEqA82xHb2+KmYc+BZTRkQhUXC+tndXtcScHw786lEytxDDZDGsR7XuEqW7uQQd2ZuCs/D6lBfuh9Wpz1XuaqTEtxiWyNibpAJtHjNaHtqEHnYlutXNn8ZkTLglmU3A14/onxT+vHRj6vlQnW362O7q6jYsUAV4e+srKtGc2Ut2h9Xvi+pegdH7AiTEhRWy9Mg2yeBrnBkYHs2rNI1+1bJK2oJnkn5jV0kLnOOLMldtkRjXIjvZsJlgM5fGJ5mQZI+60jzrQHr5Nhn3WZhng4bq0qS+VB4F0b3yr8D32/0lCHjKA5cwYDFGlyg02lDZ6YJyqaZg+1nwcwS23Ha7KBhFo/oCJREZBkOPQ0zS4alwOZhjAQUPFDkgd7LCAXW9jNSpuIRNegxXjr30M2x6dS/AkqzVPcogc2y2B68TWomM8dHQwfro2ICJHv5Z7+EKq9gSVSlHjEGlT1+ecLlvDugl7pTTgnCcYB4Fwke7Nh0BhVPlpRK5/pLOadFdWRFo/k74DFLGV9yvk2KwP0DPU/2560snhJamnqKKxj1zM6DDVL/e+948W7hUl45Rx/OLPHEoSryIlllwLWC04u/yB0D9UrVgpK+2acQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(47076005)(356005)(7636003)(30864003)(8936002)(86362001)(82310400003)(336012)(2616005)(6666004)(16526019)(7696005)(70206006)(54906003)(6916009)(508600001)(36906005)(2906002)(83380400001)(15650500001)(8676002)(70586007)(5660300002)(36860700001)(316002)(186003)(426003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 17:30:44.9472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1334562c-3f5a-4f82-4bbc-08d985013341
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2756
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Add reoffload process to update hw_count when driver
> is inserted or removed.
>
> When reoffloading actions, we still offload the actions
> that are added independent of filters.
>
> Change the lock usage to fix sleeping in invalid context.

What does this refer to? Looking at the code it is not clear to me which
lock usage is changed. Or is it just a change log from v1?

>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/act_api.h   |  14 +++
>  net/core/flow_offload.c |   5 +
>  net/sched/act_api.c     | 215 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 214 insertions(+), 20 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 1209444ac369..df64489d1013 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -7,6 +7,7 @@
>  */
>  
>  #include <linux/refcount.h>
> +#include <net/flow_offload.h>
>  #include <net/sch_generic.h>
>  #include <net/pkt_sched.h>
>  #include <net/net_namespace.h>
> @@ -44,6 +45,9 @@ struct tc_action {
>  	u8			hw_stats;
>  	u8			used_hw_stats;
>  	bool			used_hw_stats_valid;
> +	bool                    add_separate; /* indicate if the action is created
> +					       * independent of any flow
> +					       */

This looks like a duplication of flags since this value is derived from
BIND flag. I understand that you need this because currently all flags
that are not visible to the userspace are cleared after action is
created, but maybe it would be better to refactor the code to preserve
all flags and to only apply TCA_ACT_FLAGS_USER_MASK when dumping to user
space.

>  	u32 in_hw_count;
>  };
>  #define tcf_index	common.tcfa_index
> @@ -242,6 +246,8 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
>  int tcf_action_offload_del(struct tc_action *action);
>  int tcf_action_update_hw_stats(struct tc_action *action);
> +int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +			    void *cb_priv, bool add);
>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
>  			     struct netlink_ext_ack *newchain);
> @@ -253,6 +259,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
>  #endif
>  
>  int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
> +
> +#else /* !CONFIG_NET_CLS_ACT */
> +
> +static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +					  void *cb_priv, bool add) {
> +	return 0;
> +}
> +
>  #endif /* CONFIG_NET_CLS_ACT */
>  
>  static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6676431733ef..d591204af6e0 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> +#include <net/act_api.h>
>  #include <net/flow_offload.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/mutex.h>
> @@ -418,6 +419,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  	existing_qdiscs_register(cb, cb_priv);
>  	mutex_unlock(&flow_indr_block_lock);
>  
> +	tcf_action_reoffload_cb(cb, cb_priv, true);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_register);
> @@ -472,6 +475,8 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  
>  	flow_block_indr_notify(&cleanup_list);
>  	kfree(indr_dev);
> +
> +	tcf_action_reoffload_cb(cb, cb_priv, false);
>  }
>  EXPORT_SYMBOL(flow_indr_dev_unregister);
>  
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index c98048832c80..7bb84d5001b6 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -512,6 +512,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
>  	p->tcfa_tm.lastuse = jiffies;
>  	p->tcfa_tm.firstuse = 0;
>  	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
> +	p->add_separate = !bind;
>  	if (est) {
>  		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
>  					&p->tcfa_rate_est,
> @@ -636,6 +637,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
>  
>  static LIST_HEAD(act_base);
>  static DEFINE_RWLOCK(act_mod_lock);
> +/* since act ops id is stored in pernet subsystem list,
> + * then there is no way to walk through only all the action
> + * subsystem, so we keep tc action pernet ops id for
> + * reoffload to walk through.
> + */
> +static LIST_HEAD(act_pernet_id_list);
> +static DEFINE_MUTEX(act_id_mutex);
> +struct tc_act_pernet_id {
> +	struct list_head list;
> +	unsigned int id;
> +};
> +
> +static int tcf_pernet_add_id_list(unsigned int id)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +	int ret = 0;
> +
> +	mutex_lock(&act_id_mutex);
> +	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +		if (id_ptr->id == id) {
> +			ret = -EEXIST;
> +			goto err_out;
> +		}
> +	}
> +
> +	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
> +	if (!id_ptr) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +	id_ptr->id = id;
> +
> +	list_add_tail(&id_ptr->list, &act_pernet_id_list);
> +
> +err_out:
> +	mutex_unlock(&act_id_mutex);
> +	return ret;
> +}
> +
> +static void tcf_pernet_del_id_list(unsigned int id)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +
> +	mutex_lock(&act_id_mutex);
> +	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +		if (id_ptr->id == id) {
> +			list_del(&id_ptr->list);
> +			kfree(id_ptr);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&act_id_mutex);
> +}
>  
>  int tcf_register_action(struct tc_action_ops *act,
>  			struct pernet_operations *ops)
> @@ -654,18 +708,30 @@ int tcf_register_action(struct tc_action_ops *act,
>  	if (ret)
>  		return ret;
>  
> +	if (ops->id) {
> +		ret = tcf_pernet_add_id_list(*ops->id);
> +		if (ret)
> +			goto id_err;
> +	}
> +
>  	write_lock(&act_mod_lock);
>  	list_for_each_entry(a, &act_base, head) {
>  		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
> -			write_unlock(&act_mod_lock);
> -			unregister_pernet_subsys(ops);
> -			return -EEXIST;
> +			ret = -EEXIST;
> +			goto err_out;
>  		}
>  	}
>  	list_add_tail(&act->head, &act_base);
>  	write_unlock(&act_mod_lock);
>  
>  	return 0;
> +
> +err_out:
> +	write_unlock(&act_mod_lock);
> +	tcf_pernet_del_id_list(*ops->id);
> +id_err:
> +	unregister_pernet_subsys(ops);
> +	return ret;
>  }
>  EXPORT_SYMBOL(tcf_register_action);
>  
> @@ -684,8 +750,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
>  		}
>  	}
>  	write_unlock(&act_mod_lock);
> -	if (!err)
> +	if (!err) {
>  		unregister_pernet_subsys(ops);
> +		if (ops->id)
> +			tcf_pernet_del_id_list(*ops->id);
> +	}
>  	return err;
>  }
>  EXPORT_SYMBOL(tcf_unregister_action);
> @@ -1210,29 +1279,57 @@ static void flow_action_update_hw(struct tc_action *act,
>  	}
>  }
>  
> -static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> -				  u32 *hw_count,
> -				  struct netlink_ext_ack *extack)
> +static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
> +				     u32 *hw_count)
>  {
>  	int err;
>  
> -	if (IS_ERR(fl_act))
> -		return PTR_ERR(fl_act);
> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
> +					  fl_act, NULL, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (hw_count)
> +		*hw_count = err;
>  
> -	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
> +	return 0;
> +}
> +
> +static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
> +					u32 *hw_count,
> +					flow_indr_block_bind_cb_t *cb,
> +					void *cb_priv)
> +{
> +	int err;
>  
> +	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
>  	if (err < 0)
>  		return err;
>  
>  	if (hw_count)
> -		*hw_count = err;
> +		*hw_count = 1;
>  
>  	return 0;
>  }
>  
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  u32 *hw_count,
> +				  flow_indr_block_bind_cb_t *cb,
> +				  void *cb_priv)
> +{
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
> +
> +	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
> +						 cb, cb_priv) :
> +		    tcf_action_offload_cmd_ex(fl_act, hw_count);
> +}
> +
>  /* offload the tc command after inserted */
> -static int tcf_action_offload_add(struct tc_action *action,
> -				  struct netlink_ext_ack *extack)
> +static int tcf_action_offload_add_ex(struct tc_action *action,
> +				     struct netlink_ext_ack *extack,
> +				     flow_indr_block_bind_cb_t *cb,
> +				     void *cb_priv)
>  {
>  	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
>  	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> @@ -1260,9 +1357,10 @@ static int tcf_action_offload_add(struct tc_action *action,
>  		goto fl_err;
>  	}
>  
> -	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
> +	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
>  	if (!err)
> -		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_ADD);
> +		flow_action_update_hw(action, in_hw_count,
> +				      cb ? FLOW_ACT_HW_UPDATE : FLOW_ACT_HW_ADD);
>  
>  	if (skip_sw && !tc_act_in_hw(action->tcfa_flags))
>  		err = -EINVAL;
> @@ -1275,6 +1373,12 @@ static int tcf_action_offload_add(struct tc_action *action,
>  	return err;
>  }
>  
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
> +}
> +
>  int tcf_action_update_hw_stats(struct tc_action *action)
>  {
>  	struct flow_offload_action fl_act = {};
> @@ -1287,7 +1391,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  	if (err)
>  		goto err_out;
>  
> -	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
> +	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
>  
>  	if (!err && fl_act.stats.lastused) {
>  		preempt_disable();
> @@ -1309,7 +1413,8 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  }
>  EXPORT_SYMBOL(tcf_action_update_hw_stats);
>  
> -int tcf_action_offload_del(struct tc_action *action)
> +int tcf_action_offload_del_ex(struct tc_action *action,
> +			      flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  {
>  	struct flow_offload_action fl_act;
>  	u32 in_hw_count = 0;
> @@ -1325,13 +1430,83 @@ int tcf_action_offload_del(struct tc_action *action)
>  	if (err)
>  		return err;
>  
> -	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
> -	if (err)
> +	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
> +	if (err < 0)
>  		return err;
>  
> -	if (action->in_hw_count != in_hw_count)
> +	/* do not need to update hw state when deleting action */
> +	if (cb && in_hw_count)
> +		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_DEL);
> +
> +	if (!cb && action->in_hw_count != in_hw_count)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int tcf_action_offload_del(struct tc_action *action)
> +{
> +	return tcf_action_offload_del_ex(action, NULL, NULL);
> +}
> +
> +int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +			    void *cb_priv, bool add)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +	struct tcf_idrinfo *idrinfo;
> +	struct tc_action_net *tn;
> +	struct tc_action *p;
> +	unsigned int act_id;
> +	unsigned long tmp;
> +	unsigned long id;
> +	struct idr *idr;
> +	struct net *net;
> +	int ret;
> +
> +	if (!cb)
>  		return -EINVAL;
>  
> +	down_read(&net_rwsem);
> +	mutex_lock(&act_id_mutex);
> +
> +	for_each_net(net) {
> +		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +			act_id = id_ptr->id;
> +			tn = net_generic(net, act_id);
> +			if (!tn)
> +				continue;
> +			idrinfo = tn->idrinfo;
> +			if (!idrinfo)
> +				continue;
> +
> +			mutex_lock(&idrinfo->lock);
> +			idr = &idrinfo->action_idr;
> +			idr_for_each_entry_ul(idr, p, tmp, id) {
> +				if (IS_ERR(p) || !p->add_separate)
> +					continue;
> +				if (add) {
> +					tcf_action_offload_add_ex(p, NULL, cb,
> +								  cb_priv);
> +					continue;
> +				}
> +
> +				/* cb unregister to update hw count */
> +				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
> +				if (ret < 0)
> +					continue;
> +				if (tc_act_skip_sw(p->tcfa_flags) &&
> +				    !tc_act_in_hw(p->tcfa_flags)) {
> +					ret = tcf_idr_release_unsafe(p);
> +					if (ret == ACT_P_DELETED)
> +						module_put(p->ops->owner);
> +				}
> +			}
> +			mutex_unlock(&idrinfo->lock);
> +		}
> +	}
> +	mutex_unlock(&act_id_mutex);
> +	up_read(&net_rwsem);
> +
>  	return 0;
>  }

