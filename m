Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4064400D7
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhJ2RCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:02:04 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:1175
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229732AbhJ2RCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:02:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGPokIj/3INjnTGOOKNH7QVsXSdR6GBiS8kU/f7aypPWJyUCNjWzebE07R31lO3Heu1kyCbIPx9+S1VV4+nb4eqhnvdiKHmsTbHJkUEb+gp472/rlLPI3czaJT3tUS9GcoUS+vP7eiRiL7kn7sDpsQlXPcBNyQC5UJk00HAJsOdyS64D8YwAYj1u6h/Gd8pGfgknq6sRqfgv1Vjp1TAyFzuzbF9x5hVNjmmfAF0cLbtCAOhFiEb2ZH6FQLNCbM5Nq8IlE3es2rJPv2s30QqNpqry7lSDcOL3DSpSfWxuoH1bDnb8v7FVkRHJXMAN19bZvX8MHcJCU7vMoi9lwGMAvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DOHMptEEw+GkMJqT9by/eJoD7+5lspBZ8pbMGOA8bg=;
 b=d3JP81XVlkgQOwXFYUiwAW/QX80tayFWAWWNELJFrfGYnPCG1IBzCUhcd1kIJk5yojAKeT7jKxCZ9gUTnHW0gCf/aQ5xnqX0+32usWYxmGRq7IGK4zgMJj8Ve13Ylo7Z4jMrTw4pMcjEFFMIMY1pWmUq+vn1eIb4hmvt0KJfIY11qGJeC/BjH6oUbVbO9N0cQeHsebFfwOzpc6P3CbGZmcQTZ8UN8GmxGbnRTrphhgm90yUzkuQl1ZpW+0SnSzn0bXM1kYXTjU495ATj35fg0cxNNq56w/mRdejOl+JHO0AKu22X1W64UowThg+8pHP1Tso31bxu6IpfNkpnhg9hkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DOHMptEEw+GkMJqT9by/eJoD7+5lspBZ8pbMGOA8bg=;
 b=say1HbdmTL8jDtjuUsVPQV3HeffS8cbFGbG2u1QyXz7uEGrziLBoc+GJrGCHjlU6oqdDovSrRURR++oqlEhAEN8NPiXDRL6Fr20lcELojG35BWtfFioPey0DVAldh6f4/6L6x5RnKbHRq01FcD41NETaTDkRCQ9RFGqObV5MaHo50m7lNVwBT+sY9EsdSzs2SFRnIdg9KHcOrPMaWPZI0dWfXhotzIncHvbIJVlg0jEZ3Q03QCtg9JYv1BUswxRbBiPNZE7n/dnyitnZP+NMbwnqBiV0sCJlRAyvfSeMVVGUP94ruVuXWV20dzQHPEA75csmu1ap/AfKEnarjcxeSQ==
Received: from MW4PR03CA0048.namprd03.prod.outlook.com (2603:10b6:303:8e::23)
 by MWHPR1201MB0237.namprd12.prod.outlook.com (2603:10b6:301:56::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Fri, 29 Oct
 2021 16:59:30 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::c7) by MW4PR03CA0048.outlook.office365.com
 (2603:10b6:303:8e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Fri, 29 Oct 2021 16:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 16:59:30 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 29 Oct 2021 16:59:08 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-4-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
In-Reply-To: <20211028110646.13791-4-simon.horman@corigine.com>
Date:   Fri, 29 Oct 2021 19:59:06 +0300
Message-ID: <ygnhr1c3aht1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29fa417c-ceda-444a-c254-08d99afd7998
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0237:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0237A1A00A0CBD62F228B377A0879@MWHPR1201MB0237.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLkgZzAzFlCQ8rfeCLDlggyfkiFnxQiRMvDmtiZSvEMnUtQFjAZlIunhXkdlqH3edM3b31H0LXmjuBz255G/lGazVFpdRT2CnTZlSnUk0JJlC7Nt7yGVbjIpBLjDvZ4/9QcWH9XJR+FKc2a/20G64bH+iQgAybPvDqxtwWg320awBwLUO/zMHlPkzLkVLmsliIDD8bhxIsFBdWY761GtYqF5jJlcGIgBc8dHv7e7koL02eN6oPp7iKo4SImGrGBUdZwpEZGA4YrQlF/N74Pvj7swTwSY1mkklVe5QAxqjGJa0JIA6rSAOUrn+Fbko1WAsxizh15nzuP1fI+wnFwPaVjWv+W3qwwrWbxAMtGh7Y6YxA9I6Z3ue8BqqKu3HJ8S3MQaKoriwej9OSmCXHhRigH82jnnLTJPHi8AgwhtZo9aZj7bgmaCFSF8b8B0/42Q6ANGAjEzT7sosWlc9/l9CvGRuxTyRN/ZBtuWPZT05mzwgF2Ymxz2TYmrSvdyDxXHcs40h90zz5NvgWK10IEHvuGrVstfY9aeQ5FUqBfdSbPa2+IVy4uqjG1nAqEIwgepcNWdKbt6FCwuPs3NOcuvnwEyRSG10MsccjZvAjNp9lssxXfBCECesls3Q5xbCBg447hrqCkZwjj10VPq+AYN8pc9zEjYe0rTHxJCP5iWh4crH4gX3ENVTKbDqcrjRVYRZj1LZP24bwVjB35uOIjIRg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(36906005)(2906002)(186003)(54906003)(508600001)(83380400001)(7636003)(336012)(7696005)(2616005)(356005)(8676002)(8936002)(47076005)(5660300002)(30864003)(70586007)(36756003)(16526019)(70206006)(316002)(26005)(36860700001)(4326008)(86362001)(6916009)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 16:59:30.5504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fa417c-ceda-444a-c254-08d99afd7998
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0237
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> offload tc action.
>
> We need to call tc_cleanup_flow_action to clean up tc action entry since
> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> action.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/linux/netdevice.h  |   1 +
>  include/net/act_api.h      |   2 +-
>  include/net/flow_offload.h |  17 ++++
>  include/net/pkt_cls.h      |  15 ++++
>  net/core/flow_offload.c    |  43 ++++++++--
>  net/sched/act_api.c        | 166 +++++++++++++++++++++++++++++++++++++
>  net/sched/cls_api.c        |  29 ++++++-
>  7 files changed, 260 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3ec42495a43a..9815c3a058e9 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -916,6 +916,7 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_TBF,
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>  };
>  
>  /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index b5b624c7e488..9eb19188603c 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -239,7 +239,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
>  void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  			     u64 drops, bool hw);
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
> -
> +int tcf_action_offload_del(struct tc_action *action);

This doesn't seem to be used anywhere outside of act_api in this series,
so why is it exported?

>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
>  			     struct netlink_ext_ack *newchain);
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3961461d9c8b..aa28592fccc0 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -552,6 +552,23 @@ struct flow_cls_offload {
>  	u32 classid;
>  };
>  
> +enum flow_act_command {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +
> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
> +	enum flow_act_command command;
> +	enum flow_action_id id;
> +	u32 index;
> +	struct flow_stats stats;
> +	struct flow_action action;
> +};
> +
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
> +
>  static inline struct flow_rule *
>  flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>  {
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 193f88ebf629..922775407257 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (; 0; (void)(i), (void)(a), (void)(exts))
>  #endif
>  
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -532,8 +535,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>  	return ifindex == skb->skb_iif;
>  }
>  
> +#ifdef CONFIG_NET_CLS_ACT
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts);

Why does existing cls_api function tc_setup_flow_action() now depend on
CONFIG_NET_CLS_ACT?

> +#else
> +static inline int tc_setup_flow_action(struct flow_action *flow_action,
> +				       const struct tcf_exts *exts)
> +{
> +	return 0;
> +}
> +#endif
> +
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -554,6 +568,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  enum tc_setup_type type, void *type_data,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions_single(struct tc_action *act);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6beaea13564a..6676431733ef 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>  }
>  EXPORT_SYMBOL(flow_rule_alloc);
>  
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
> +{
> +	struct flow_offload_action *fl_action;
> +	int i;
> +
> +	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
> +			    GFP_KERNEL);
> +	if (!fl_action)
> +		return NULL;
> +
> +	fl_action->action.num_entries = num_actions;
> +	/* Pre-fill each action hw_stats with DONT_CARE.
> +	 * Caller can override this if it wants stats for a given action.
> +	 */
> +	for (i = 0; i < num_actions; i++)
> +		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
> +
> +	return fl_action;
> +}
> +EXPORT_SYMBOL(flow_action_alloc);
> +
>  #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
>  	const struct flow_match *__m = &(__rule)->match;			\
>  	struct flow_dissector *__d = (__m)->dissector;				\
> @@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>  				void (*cleanup)(struct flow_block_cb *block_cb))
>  {
>  	struct flow_indr_dev *this;
> +	u32 count = 0;
> +	int err;
>  
>  	mutex_lock(&flow_indr_block_lock);
> +	if (bo) {
> +		if (bo->command == FLOW_BLOCK_BIND)
> +			indir_dev_add(data, dev, sch, type, cleanup, bo);
> +		else if (bo->command == FLOW_BLOCK_UNBIND)
> +			indir_dev_remove(data);
> +	}
>  
> -	if (bo->command == FLOW_BLOCK_BIND)
> -		indir_dev_add(data, dev, sch, type, cleanup, bo);
> -	else if (bo->command == FLOW_BLOCK_UNBIND)
> -		indir_dev_remove(data);
> -
> -	list_for_each_entry(this, &flow_block_indr_dev_list, list)
> -		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
> +		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +		if (!err)
> +			count++;
> +	}
>  
>  	mutex_unlock(&flow_indr_block_lock);
>  
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 3258da3d5bed..33f2ff885b4b 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -21,6 +21,19 @@
>  #include <net/pkt_cls.h>
>  #include <net/act_api.h>
>  #include <net/netlink.h>
> +#include <net/tc_act/tc_pedit.h>
> +#include <net/tc_act/tc_mirred.h>
> +#include <net/tc_act/tc_vlan.h>
> +#include <net/tc_act/tc_tunnel_key.h>
> +#include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_gact.h>
> +#include <net/tc_act/tc_police.h>
> +#include <net/tc_act/tc_sample.h>
> +#include <net/tc_act/tc_skbedit.h>
> +#include <net/tc_act/tc_ct.h>
> +#include <net/tc_act/tc_mpls.h>
> +#include <net/tc_act/tc_gate.h>
> +#include <net/flow_offload.h>
>  
>  #ifdef CONFIG_INET
>  DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
> @@ -148,6 +161,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
>  		idr_remove(&idrinfo->action_idr, p->tcfa_index);
>  		mutex_unlock(&idrinfo->lock);
>  
> +		tcf_action_offload_del(p);
>  		tcf_action_cleanup(p);
>  		return 1;
>  	}
> @@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
>  		return -EPERM;
>  
>  	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
> +		tcf_action_offload_del(p);
>  		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
>  		tcf_action_cleanup(p);
>  		return ACT_P_DELETED;
> @@ -452,6 +467,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
>  						p->tcfa_index));
>  			mutex_unlock(&idrinfo->lock);
>  
> +			tcf_action_offload_del(p);

tcf_action_offload_del() and tcf_action_cleanup() seem to be always
called together. Consider moving the call to tcf_action_offload_del()
into tcf_action_cleanup().

>  			tcf_action_cleanup(p);
>  			module_put(owner);
>  			return 0;
> @@ -1061,6 +1077,154 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> +static int flow_action_init(struct flow_offload_action *fl_action,
> +			    struct tc_action *act,
> +			    enum flow_act_command cmd,
> +			    struct netlink_ext_ack *extack)
> +{
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	fl_action->extack = extack;
> +	fl_action->command = cmd;
> +	fl_action->index = act->tcfa_index;
> +
> +	if (is_tcf_gact_ok(act)) {
> +		fl_action->id = FLOW_ACTION_ACCEPT;
> +	} else if (is_tcf_gact_shot(act)) {
> +		fl_action->id = FLOW_ACTION_DROP;
> +	} else if (is_tcf_gact_trap(act)) {
> +		fl_action->id = FLOW_ACTION_TRAP;
> +	} else if (is_tcf_gact_goto_chain(act)) {
> +		fl_action->id = FLOW_ACTION_GOTO;
> +	} else if (is_tcf_mirred_egress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT;
> +	} else if (is_tcf_mirred_egress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED;
> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
> +	} else if (is_tcf_vlan(act)) {
> +		switch (tcf_vlan_action(act)) {
> +		case TCA_VLAN_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
> +			break;
> +		case TCA_VLAN_ACT_POP:
> +			fl_action->id = FLOW_ACTION_VLAN_POP;
> +			break;
> +		case TCA_VLAN_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_tunnel_set(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
> +	} else if (is_tcf_tunnel_release(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
> +	} else if (is_tcf_csum(act)) {
> +		fl_action->id = FLOW_ACTION_CSUM;
> +	} else if (is_tcf_skbedit_mark(act)) {
> +		fl_action->id = FLOW_ACTION_MARK;
> +	} else if (is_tcf_sample(act)) {
> +		fl_action->id = FLOW_ACTION_SAMPLE;
> +	} else if (is_tcf_police(act)) {
> +		fl_action->id = FLOW_ACTION_POLICE;
> +	} else if (is_tcf_ct(act)) {
> +		fl_action->id = FLOW_ACTION_CT;
> +	} else if (is_tcf_mpls(act)) {
> +		switch (tcf_mpls_action(act)) {
> +		case TCA_MPLS_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
> +			break;
> +		case TCA_MPLS_ACT_POP:
> +			fl_action->id = FLOW_ACTION_MPLS_POP;
> +			break;
> +		case TCA_MPLS_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_skbedit_ptype(act)) {
> +		fl_action->id = FLOW_ACTION_PTYPE;
> +	} else if (is_tcf_skbedit_priority(act)) {
> +		fl_action->id = FLOW_ACTION_PRIORITY;
> +	} else if (is_tcf_gate(act)) {
> +		fl_action->id = FLOW_ACTION_GATE;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
> +
> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
> +					  fl_act, NULL, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/* offload the tc command after inserted */
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> +		[0] = action,
> +	};
> +	struct flow_offload_action *fl_action;
> +	int err = 0;
> +
> +	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
> +	if (!fl_action)
> +		return -EINVAL;

Failed alloc-like functions usually result -ENOMEM.

> +
> +	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
> +	if (err)
> +		goto fl_err;
> +
> +	err = tc_setup_action(&fl_action->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to setup tc actions for offload\n");
> +		goto fl_err;
> +	}
> +
> +	err = tcf_action_offload_cmd(fl_action, extack);
> +	tc_cleanup_flow_action(&fl_action->action);
> +
> +fl_err:
> +	kfree(fl_action);
> +
> +	return err;
> +}
> +
> +int tcf_action_offload_del(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act;
> +	int err = 0;
> +
> +	if (!action)
> +		return -EINVAL;
> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd(&fl_act, NULL);
> +}
> +
>  /* Returns numbers of initialized actions or negative error. */
>  
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1103,6 +1267,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  		sz += tcf_action_fill_size(act);
>  		/* Start from index 0 */
>  		actions[i - 1] = act;
> +		if (!(flags & TCA_ACT_FLAGS_BIND))
> +			tcf_action_offload_add(act, extack);
>  	}
>  
>  	/* We have to commit them all together, because if any error happened in
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2ef8f5a6205a..351d93988b8b 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
>  	return hw_stats;
>  }
>  
> -int tc_setup_flow_action(struct flow_action *flow_action,
> -			 const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>  {
>  	struct tc_action *act;
>  	int i, j, k, err = 0;
> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>  
> -	if (!exts)
> +	if (!actions)
>  		return 0;
>  
>  	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>  		struct flow_action_entry *entry;
>  
>  		entry = &flow_action->entries[j];
> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	spin_unlock_bh(&act->tcfa_lock);
>  	goto err_out;
>  }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +#ifdef CONFIG_NET_CLS_ACT

Maybe just move tc_setup_action() to act_api and ifdef its definition in
pkt_cls.h instead of existing tc_setup_flow_action()?

> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +}
>  EXPORT_SYMBOL(tc_setup_flow_action);
> +#endif
>  
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  {
> @@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_num_actions);
>  
> +unsigned int tcf_act_num_actions_single(struct tc_action *act)
> +{
> +	if (is_tcf_pedit(act))
> +		return tcf_pedit_nkeys(act);
> +	else
> +		return 1;
> +}
> +EXPORT_SYMBOL(tcf_act_num_actions_single);
> +
>  #ifdef CONFIG_NET_CLS_ACT
>  static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>  					u32 *p_block_index,

