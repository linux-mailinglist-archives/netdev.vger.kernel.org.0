Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019E4576DF
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhKSTI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 14:08:56 -0500
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:8032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235836AbhKSTIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 14:08:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q++vPMRuDFju/BJ1D7NxpKO+P3hSI12prxbmBYUHL98Bs0+VKcSx6LaYNSqMNk7/wVUymwG7Z70w+Nn7iGjMU8xWaZyoVDYxYQohkQ4/Un0QHWVkQJVz8ZPTxKeAgWb0/ZsS3eCgahCtaV4IBzINgXb6EHpCOyPossEBp71/LxlEAZS4eidbstFdLnfZY0ynkLJSZA4u4/+iNf8sdytAvPLdi/ssYY5Nn5J4UWjOiVWtOrt/EGGGTrkHPSbdCDpjHaNA1uAZnyC6ei8YKc9zIQAQNgBwHv4AMUlFnAwwj6YcL6di3FC3UKCEK1Qu6W1uUKNgmGeMGlCF5croNEyO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpEtSUFqjlBWUDh2HMe5QN5KN0iyjjIUbCwmRYDPL7A=;
 b=Wp+A4AbtxlYPvoKGgguUsnPswJigwe01XNmd58cGj/ckkMzDmbd/XlqAf+KcCOUBmRat8sqyd8013wdlbdgjAjLlgZeePBJp/Z3Qxbh7Eo0g56GVTk55qyeKvpAw8HjSCa1nfMLY0/uS+JKDNNc3zeZm7NElTvw3M8hWnlcT+yYBR9bpZAhjPtb3JQkaVMFjRX3mlMydCv6G61uhfTFt7diRLmPp6LrLfqtyHjtkTujJiQuXQ21drLLWcng1CjPSsGQ0JG+JaA2RN720azXOKrX6dgNpjmnLTB0SZbs61YAFP5KbxwnV5MBmDflBIS8LGDWuwJFHFSoyVJFDJYvBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpEtSUFqjlBWUDh2HMe5QN5KN0iyjjIUbCwmRYDPL7A=;
 b=H6ZpockXfuT2uo+Opfj5c3Rzw37PbRhBpoFdw90B0v3Cey7BQJ6vWnAV+8yNtGwkG+tDvRevrTpc0IfGjj1/AlnVjURYAr12BE8POTtROI1XqD4kC4Std4HnwvFCO8vf1MVYkU2WtMacWM6Kwa904cGOgsdOZndDkrzqPuVN1NntWvTmHq4en2couyCCbTqV0mCBi1tvgleXSzlUh3QHYalPEcrgE9sK4CxjotrdnerV8ypM4NQV+a4cE9aNBb2nmxssAkPlm+dX8hXwG4VQxliDjOH8B/umIW3KifSb0B6YrIxFYBXux9YSZcQS4G8JO06ONZHaj5EWyMFKYKiXrA==
Received: from CO2PR18CA0058.namprd18.prod.outlook.com (2603:10b6:104:2::26)
 by MWHPR1201MB2494.namprd12.prod.outlook.com (2603:10b6:300:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 19 Nov
 2021 19:05:51 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::ba) by CO2PR18CA0058.outlook.office365.com
 (2603:10b6:104:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Fri, 19 Nov 2021 19:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Fri, 19 Nov 2021 19:05:50 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 19 Nov 2021 19:05:47 +0000
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Jiri Pirko" <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action
 to net device
In-Reply-To: <20211118130805.23897-5-simon.horman@corigine.com>
Date:   Fri, 19 Nov 2021 21:05:44 +0200
Message-ID: <ygnhk0h47ypj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5ab8522-4381-43f4-b9e3-08d9ab8f9a76
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2494:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB24940D97A503C4725AED7782A09C9@MWHPR1201MB2494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRWjjRO2L9BbB8H/ilfekAYuYhHx0rlCCmiwKsn+x+296Kz/UNPUFmKQX+u7m7kw8ZSQFWqCC8EoqNPvvEexyiB9YdLjpE2xuvGiS/pfIqO4HQJvuC7f6xKVNB3XcZ5VYwA1pVKrR9pqqtAUeiKb/46K9Z+hOh5yoY7LfGAMHgJOKhl5EDp+HnrhPb47IAWEmLRhWcvAH4D7Mtz/b5w3Ghs3Omjh/O7iySiVI8EC9Al03LVGIPvjF7DZjfsBQREUPmFRs4NNldeCKwBbr7TqtBnlr3llWrZr4pxilxNGBs2HRXobosBfyc2HtMdRiiLI0gl68YGZ5qs8tPAk/yLPky+5LnIM6EEZ5JCVEVQ+frzc2DyJKY9tJIF1a/zKwkyiuJ4K6N7oYO3DMC1bWh+yDT9mpLVS9j7nFOPN54VGTFWevrabQcy/S3NJ/pfLQrHtRiNMaqn38kdXw6iSQwMyQC4i5uc30WEplj6HFXKJWpa55iI9ntHmsCQ6D0dY/aFRSkF29n4F3mLemj7CW+OJve16tMrl3RLe5cmkaTOCKtMiTS6g/6E9F9E9oGSduGhZyx9uUyQ3PVXpbxrxjlwBQcP+Un7KmTdv2CKjushJkr3riXzODSPs4NVjmb4gh6rsbQ3RkpBcLCYaAt3Qk8DNA9VfIr7KiMppgiyxlqQ36QE0+SNbXk/3PwZsw+5FtdrtqBiQZjN/g3MegWiTx778Sw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(426003)(316002)(30864003)(36756003)(36860700001)(4326008)(356005)(70586007)(2906002)(70206006)(83380400001)(6666004)(7636003)(86362001)(54906003)(26005)(82310400003)(508600001)(7696005)(5660300002)(16526019)(336012)(6916009)(47076005)(186003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 19:05:50.7742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ab8522-4381-43f4-b9e3-08d9ab8f9a76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 18 Nov 2021 at 15:07, Simon Horman <simon.horman@corigine.com> wrote:
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
>  include/net/flow_offload.h |  17 ++++
>  include/net/pkt_cls.h      |  12 +++
>  net/core/flow_offload.c    |  43 ++++++++--
>  net/sched/act_api.c        | 164 +++++++++++++++++++++++++++++++++++++
>  net/sched/cls_api.c        |  31 ++++++-
>  6 files changed, 256 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 4f4a299e92de..ae189fcff3c6 100644
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
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index f6970213497a..15662cad5bca 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,23 @@ struct flow_cls_offload {
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
> index 193f88ebf629..14d098a887d0 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -258,6 +258,14 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (; 0; (void)(i), (void)(a), (void)(exts))
>  #endif
>  
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
> +static inline bool tc_act_bind(u32 flags)
> +{
> +	return !!(flags & TCA_ACT_FLAGS_BIND);
> +}
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -534,6 +542,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>  
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts);
> +
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -554,6 +565,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
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
> index 3258da3d5bed..c3d08b710661 100644
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
> @@ -129,8 +142,157 @@ static void free_tcf(struct tc_action *p)
>  	kfree(p);
>  }
>  
> +static int flow_action_init(struct flow_offload_action *fl_action,
> +			    struct tc_action *act,
> +			    enum flow_act_command cmd,
> +			    struct netlink_ext_ack *extack)
> +{
> +	if (!fl_action)
> +		return -EINVAL;

Multiple functions in this patch verify action argument that seemingly
can't be NULL neither in this change nor in the following ones in
series. Any particular motivation for this?

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

Ditto.

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
> +		return -ENOMEM;
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
> +static int tcf_action_offload_del(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act;

This is the only usage of uninitialized flow_offload_action instance.
Since there is no reference driver implementation, it is not clear to me
whether this is intentional because flow_action_init() is guaranteed to
initialize all data that is necessary for delete, or just an omission.

> +	int err = 0;
> +
> +	if (!action)
> +		return -EINVAL;

Seemingly redundant check again.

> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd(&fl_act, NULL);
> +}
> +
>  static void tcf_action_cleanup(struct tc_action *p)
>  {
> +	tcf_action_offload_del(p);
>  	if (p->ops->cleanup)
>  		p->ops->cleanup(p);
>  
> @@ -1103,6 +1265,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  		sz += tcf_action_fill_size(act);
>  		/* Start from index 0 */
>  		actions[i - 1] = act;
> +		if (!tc_act_bind(flags))
> +			tcf_action_offload_add(act, extack);
>  	}
>  
>  	/* We have to commit them all together, because if any error happened in
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d9d6ff0bf361..55fa48999d43 100644
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
> @@ -3724,6 +3724,20 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	spin_unlock_bh(&act->tcfa_lock);
>  	goto err_out;
>  }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +#ifdef CONFIG_NET_CLS_ACT
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +#else
> +	return 0;
> +#endif
> +}
>  EXPORT_SYMBOL(tc_setup_flow_action);
>  
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
> @@ -3742,6 +3756,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
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

