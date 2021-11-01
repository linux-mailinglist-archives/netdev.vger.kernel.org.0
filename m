Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FEA441AF8
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKAMIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:08:15 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:9344
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231485AbhKAMIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 08:08:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGA0veUBzq4FxZY/J0bcWoYT9AAGLAYyw7z/fKLU7P0KRaU3GUWf7ghi7+FRYEGEgZzbhy6JlmbioZKtN2FIN/VTLSjHMxa1q3HsRc3AfzZ6EOa9Te7zjqQrE08Fp6ubcXu3uJUvPTpEgaiyJuONtLp+qLnTUb60fp1Y8vW6umqto1HmrJzorR6mNSiUwID0aMOzNS1uhq3kSh8dlxISsV4fHwAkr0qIUf9voEf+9V4WpnLcRMOtCcnaFO6YLpB3fJrO8hDDlSFByJSGGJMOskSPwW+wXZu6CiwV1+TTjmMg2MPqay4XEtAjKK3tGZ+Xaiyt3AB0siqZfzgqAx/QuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHhUkwtyqn6npj3Z9DcbG4KLuiAlBBNmDAAvQvt3TME=;
 b=RpvQD61wz47Z+3rqIujuADdIvAUXnO9TvJf1OV8MZwMlUBfvHmLPXtiRI9oTNf5ragECAKD077FAHrDwFAFutEUzpDTEPELuu8YobzJBR3P8osxoX8iAz+HNmmoqYN370TGVtIp28+fawXPFYg2zhL1HHxj4ieeVA7FDp1jwxIEEd78Xi8X7eNApb1L/74/9n3J0GhEXX6NsjODZq6FzjaH+9hVXvJ7pj4PXxLX+jz0iKduGjdm8o9B9Ug/AHpkU/kAOGC5CCNtu5GbszYHZUKEXpAiXEM2uwsPTVEVTWnwL7myXGsffHVGAT6eRgx0sZHliBPl9HfcTBl4KNgFTnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHhUkwtyqn6npj3Z9DcbG4KLuiAlBBNmDAAvQvt3TME=;
 b=EPagNi0uJtDsJLqA4YGz0+DpI5y1gExoQvyqFZPLBISM4SjOk0hgNUFjDnMH2rHqutMlV0Amq5YYNuT45Dj+CrLvJdraEmiM7ejiImCKhpS8i3Ja98T7LU/TZE2sVhutEwKqZYvJwuXglg2huPaz0sYS6750fqAHxVaBuZZXid4SNmTgN7LzubYJ+28lvjV7BnqJhZ6uhSe4LlrJnH8oxw7Ws4HkNPWW35AqaX4qNgA4/uUewOqM9DQruWV12dLUf1eyePfKAR/ss6/quX1NspKhANSnYnaR/9fi8gQ4jy95awBoZ2jNa3Q9Pzsd9WVJyjbdt7lI/2abBr69+GVA/A==
Received: from DM5PR12CA0058.namprd12.prod.outlook.com (2603:10b6:3:103::20)
 by MN2PR12MB3326.namprd12.prod.outlook.com (2603:10b6:208:cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 12:05:39 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::5a) by DM5PR12CA0058.outlook.office365.com
 (2603:10b6:3:103::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 12:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 12:05:37 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 1 Nov 2021 12:05:32 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-4-simon.horman@corigine.com>
 <ygnhr1c3aht1.fsf@nvidia.com>
 <DM5PR1301MB2172A5961718F4D57EDDAD82E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
In-Reply-To: <DM5PR1301MB2172A5961718F4D57EDDAD82E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Date:   Mon, 1 Nov 2021 14:05:30 +0200
Message-ID: <ygnh7dds9j3p.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcf507f0-c390-44e2-f8c1-08d99d2febb5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3326:
X-Microsoft-Antispam-PRVS: <MN2PR12MB33263276EF81A7D0EB742D5FA08A9@MN2PR12MB3326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGiReUFN1EjuBVsNbw4uwwUuOp1waFQfp05zL+f52urvPvJ5vfjkEKwnVQXiIyNEbRcN+trFjpjDR99EMOXve9e5MSkc2gO4ep9fgxEgBfukh/oomQ/9LBksNAJCmAa3ZlpiA8bxains2M3vTOxhBSUVZKA7ZU5t0sLzWKd9XltkICtND8Jhqz4SmXu5a9KbClD5l3sPfCLj+4b4eyk8zWkfBuvb6L30V/k5wreqyKmpzi9xqp90nG/VXA6KHJVVqxG+Bgbg6+mtE03xM3P3xSvWCEqPvhpC8PjcOljj21vKdnm+zabsh0tLE1C784z5kyiQly7UWjWqJe5xFKXXgehicOaUOcupglUswhZTXzbJKhri4WH0Jg6CJN0pZTrK8LAGtgVWkOWa8LeNpjz330nMBKH46KRGQ8L8aJjqfmd12DQD+XLyn3wiFCeN0dbH0wEwQXYB3Gt+fzleR9Mc6/0UhPzs/tWk/ABZSSCjzkFD8rdf9+HWLMA76f7arbOxy87HqupZrueMjOCmPIJnvu0HAfMUuMnCnT1l6DDIeJa5tWcKfW3SRthIKJ7hgkm1jVi49sM2xXw88zkZrqEM7HC7uqw473M31ckoHPZcBhViUIEwOVzzpz1zEbJrjHcMn21y7FOVp9sExKUqxnQ/hK2E7Pf4tFJJpinDnMNhg6FqYyWKB+p7ZYNow8t+2Oq2rOFzlJoB1OzHB1u9ClIwZw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(26005)(36756003)(2616005)(7696005)(356005)(70586007)(508600001)(2906002)(5660300002)(30864003)(83380400001)(426003)(36860700001)(47076005)(316002)(86362001)(36906005)(70206006)(8676002)(4326008)(8936002)(82310400003)(186003)(6916009)(54906003)(336012)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 12:05:37.9729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf507f0-c390-44e2-f8c1-08d99d2febb5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 01 Nov 2021 at 11:44, Baowen Zheng <baowen.zheng@corigine.com> wrote:
> Thanks for your review and sorry for delay in responding.
>
> On October 30, 2021 12:59 AM, Vlad Buslov <vladbu@nvidia.com> wrote:
>>On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com>
>>wrote:
>>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>>
>>> Use flow_indr_dev_register/flow_indr_dev_setup_offload to offload tc
>>> action.
>>>
>>> We need to call tc_cleanup_flow_action to clean up tc action entry
>>> since in tc_setup_action, some actions may hold dev refcnt, especially
>>> the mirror action.
>>>
>>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>> ---
>>>  include/linux/netdevice.h  |   1 +
>>>  include/net/act_api.h      |   2 +-
>>>  include/net/flow_offload.h |  17 ++++
>>>  include/net/pkt_cls.h      |  15 ++++
>>>  net/core/flow_offload.c    |  43 ++++++++--
>>>  net/sched/act_api.c        | 166
>>+++++++++++++++++++++++++++++++++++++
>>>  net/sched/cls_api.c        |  29 ++++++-
>>>  7 files changed, 260 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 3ec42495a43a..9815c3a058e9 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -916,6 +916,7 @@ enum tc_setup_type {
>>>  	TC_SETUP_QDISC_TBF,
>>>  	TC_SETUP_QDISC_FIFO,
>>>  	TC_SETUP_QDISC_HTB,
>>> +	TC_SETUP_ACT,
>>>  };
>>>
>>>  /* These structures hold the attributes of bpf state that are being
>>> passed diff --git a/include/net/act_api.h b/include/net/act_api.h
>>> index b5b624c7e488..9eb19188603c 100644
>>> --- a/include/net/act_api.h
>>> +++ b/include/net/act_api.h
>>> @@ -239,7 +239,7 @@ static inline void
>>> tcf_action_inc_overlimit_qstats(struct tc_action *a)  void
>>tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>>>  			     u64 drops, bool hw);
>>>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
>>> -
>>> +int tcf_action_offload_del(struct tc_action *action);
>>
>>This doesn't seem to be used anywhere outside of act_api in this series, so
>>why is it exported?
> Thanks for bring this to us, we will fix this by moving the block of implement in act_api.c.
>>>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>>>  			     struct tcf_chain **handle,
>>>  			     struct netlink_ext_ack *newchain); diff --git
>>> a/include/net/flow_offload.h b/include/net/flow_offload.h index
>>> 3961461d9c8b..aa28592fccc0 100644
>>> --- a/include/net/flow_offload.h
>>> +++ b/include/net/flow_offload.h
>>> @@ -552,6 +552,23 @@ struct flow_cls_offload {
>>>  	u32 classid;
>>>  };
>>>
>>> +enum flow_act_command {
>>> +	FLOW_ACT_REPLACE,
>>> +	FLOW_ACT_DESTROY,
>>> +	FLOW_ACT_STATS,
>>> +};
>>> +
>>> +struct flow_offload_action {
>>> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS
>>process*/
>>> +	enum flow_act_command command;
>>> +	enum flow_action_id id;
>>> +	u32 index;
>>> +	struct flow_stats stats;
>>> +	struct flow_action action;
>>> +};
>>> +
>>> +struct flow_offload_action *flow_action_alloc(unsigned int
>>> +num_actions);
>>> +
>>>  static inline struct flow_rule *
>>>  flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)  { diff
>>> --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h index
>>> 193f88ebf629..922775407257 100644
>>> --- a/include/net/pkt_cls.h
>>> +++ b/include/net/pkt_cls.h
>>> @@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts
>>*exts)
>>>  	for (; 0; (void)(i), (void)(a), (void)(exts))  #endif
>>>
>>> +#define tcf_act_for_each_action(i, a, actions) \
>>> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
>>> +
>>>  static inline void
>>>  tcf_exts_stats_update(const struct tcf_exts *exts,
>>>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse, @@ -532,8
>>> +535,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>>>  	return ifindex == skb->skb_iif;
>>>  }
>>>
>>> +#ifdef CONFIG_NET_CLS_ACT
>>>  int tc_setup_flow_action(struct flow_action *flow_action,
>>>  			 const struct tcf_exts *exts);
>>
>>Why does existing cls_api function tc_setup_flow_action() now depend on
>>CONFIG_NET_CLS_ACT?
> Originally the function tc_setup_flow_action deal with the dependence of CONFIG_NET_CLS_ACT
> By calling the macro tcf_exts_for_each_action, now we change to call the function tc_setup_action
> Then tc_setup_flow_action will refer to exts->actions, so it will depend on CONFIG_NET_CLS_ACT explicitly.
> To fix this, we have to have the ifdef in tc_setup_flow_action declaration or in the implement in cls_api.c.
> Do you think if it makes sense?

Since we already have multiple of such ifdefs in cls_api I don't think
having more is an issue, but I also don't think we need to ifdef this
function in both pkt_cls.h and cls_api.c. Unless I'm missing something
you can either:

- Make tc_setup_flow_action() inline in pkt_cls.h and remove its
definition from cls_api.c since tc_setup_action() is also exported.

- Move ifdef check inside function definition in cls_api.c (return 0, if
config is not defined), which will allows you to remove ifdef from
pkt_cls.h.

WDYT?

>>> +#else
>>> +static inline int tc_setup_flow_action(struct flow_action *flow_action,
>>> +				       const struct tcf_exts *exts) {
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>> +int tc_setup_action(struct flow_action *flow_action,
>>> +		    struct tc_action *actions[]);
>>>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>>>
> ...
>>>  #ifdef CONFIG_INET
>>>  DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
>>> @@ -148,6 +161,7 @@ static int __tcf_action_put(struct tc_action *p, bool
>>bind)
>>>  		idr_remove(&idrinfo->action_idr, p->tcfa_index);
>>>  		mutex_unlock(&idrinfo->lock);
>>>
>>> +		tcf_action_offload_del(p);
>>>  		tcf_action_cleanup(p);
>>>  		return 1;
>>>  	}
>>> @@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
>>>  		return -EPERM;
>>>
>>>  	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
>>> +		tcf_action_offload_del(p);
>>>  		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
>>>  		tcf_action_cleanup(p);
>>>  		return ACT_P_DELETED;
>>> @@ -452,6 +467,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo
>>*idrinfo, u32 index)
>>>  						p->tcfa_index));
>>>  			mutex_unlock(&idrinfo->lock);
>>>
>>> +			tcf_action_offload_del(p);
>>
>>tcf_action_offload_del() and tcf_action_cleanup() seem to be always called
>>together. Consider moving the call to tcf_action_offload_del() into
>>tcf_action_cleanup().
>>
> Thanks, we will consider to move tcf_action_offload_del() inside of tcf_action_cleanup.
>>>  			tcf_action_cleanup(p);
>>>  			module_put(owner);
>>>  			return 0;
>>> @@ -1061,6 +1077,154 @@ struct tc_action *tcf_action_init_1(struct net
>>*net, struct tcf_proto *tp,
>>>  	return ERR_PTR(err);
>>>  }
>>>
> ...
>>> +/* offload the tc command after inserted */ static int
>>> +tcf_action_offload_add(struct tc_action *action,
>>> +				  struct netlink_ext_ack *extack) {
>>> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
>>> +		[0] = action,
>>> +	};
>>> +	struct flow_offload_action *fl_action;
>>> +	int err = 0;
>>> +
>>> +	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
>>> +	if (!fl_action)
>>> +		return -EINVAL;
>>
>>Failed alloc-like functions usually result -ENOMEM.
>>
> Thanks, we will fix this in V4 patch.
>>> +
>>> +	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
>>> +	if (err)
>>> +		goto fl_err;
>>> +
>>> +	err = tc_setup_action(&fl_action->action, actions);
>>> +	if (err) {
>>> +		NL_SET_ERR_MSG_MOD(extack,
>>> +				   "Failed to setup tc actions for offload\n");
>>> +		goto fl_err;
>>> +	}
>>> +
>>> +	err = tcf_action_offload_cmd(fl_action, extack);
>>> +	tc_cleanup_flow_action(&fl_action->action);
>>> +
>>> +fl_err:
>>> +	kfree(fl_action);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +int tcf_action_offload_del(struct tc_action *action) {
>>> +	struct flow_offload_action fl_act;
>>> +	int err = 0;
>>> +
>>> +	if (!action)
>>> +		return -EINVAL;
>>> +
>>> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	return tcf_action_offload_cmd(&fl_act, NULL); }
>>> +
>>>  /* Returns numbers of initialized actions or negative error. */
>>>
>>>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct
>>> nlattr *nla, @@ -1103,6 +1267,8 @@ int tcf_action_init(struct net *net,
>>struct tcf_proto *tp, struct nlattr *nla,
>>>  		sz += tcf_action_fill_size(act);
>>>  		/* Start from index 0 */
>>>  		actions[i - 1] = act;
>>> +		if (!(flags & TCA_ACT_FLAGS_BIND))
>>> +			tcf_action_offload_add(act, extack);
>>>  	}
>>>
>>>  	/* We have to commit them all together, because if any error
>>> happened in diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index 2ef8f5a6205a..351d93988b8b 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats
>>tc_act_hw_stats(u8 hw_stats)
>>>  	return hw_stats;
>>>  }
>>>
>>> -int tc_setup_flow_action(struct flow_action *flow_action,
>>> -			 const struct tcf_exts *exts)
>>> +int tc_setup_action(struct flow_action *flow_action,
>>> +		    struct tc_action *actions[])
>>>  {
>>>  	struct tc_action *act;
>>>  	int i, j, k, err = 0;
>>> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action
>>*flow_action,
>>>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE !=
>>FLOW_ACTION_HW_STATS_IMMEDIATE);
>>>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED !=
>>> FLOW_ACTION_HW_STATS_DELAYED);
>>>
>>> -	if (!exts)
>>> +	if (!actions)
>>>  		return 0;
>>>
>>>  	j = 0;
>>> -	tcf_exts_for_each_action(i, act, exts) {
>>> +	tcf_act_for_each_action(i, act, actions) {
>>>  		struct flow_action_entry *entry;
>>>
>>>  		entry = &flow_action->entries[j];
>>> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action
>>*flow_action,
>>>  	spin_unlock_bh(&act->tcfa_lock);
>>>  	goto err_out;
>>>  }
>>> +EXPORT_SYMBOL(tc_setup_action);
>>> +
>>> +#ifdef CONFIG_NET_CLS_ACT
>>
>>Maybe just move tc_setup_action() to act_api and ifdef its definition in
>>pkt_cls.h instead of existing tc_setup_flow_action()?
> As explanation above, after the change, tc_setup_flow_action will call function of 
> tc_setup_action and refer to exts->actions, so just move tc_setup_action can not
> fix this problem.

Got it.

>>> +int tc_setup_flow_action(struct flow_action *flow_action,
>>> +			 const struct tcf_exts *exts)
>>> +{
>>> +	if (!exts)
>>> +		return 0;
>>> +
>>> +	return tc_setup_action(flow_action, exts->actions); }
>>>  EXPORT_SYMBOL(tc_setup_flow_action);
>>> +#endif
>>>
>>>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)  { @@
>>> -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts
>>> *exts)  }  EXPORT_SYMBOL(tcf_exts_num_actions);
>>>
>>> +unsigned int tcf_act_num_actions_single(struct tc_action *act) {
>>> +	if (is_tcf_pedit(act))
>>> +		return tcf_pedit_nkeys(act);
>>> +	else
>>> +		return 1;
>>> +}
>>> +EXPORT_SYMBOL(tcf_act_num_actions_single);
>>> +
>>>  #ifdef CONFIG_NET_CLS_ACT
>>>  static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>>>  					u32 *p_block_index,

