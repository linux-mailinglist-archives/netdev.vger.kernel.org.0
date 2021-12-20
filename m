Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6947A637
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhLTIsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhLTIsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:48:15 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEADAC061574;
        Mon, 20 Dec 2021 00:48:14 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r17so18179132wrc.3;
        Mon, 20 Dec 2021 00:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sqBz3rXiTAfGOzTCaILFljzYUMfiSCtG7ou831kT3yw=;
        b=FeuUsAaGwbcwpADm+hM/+63f8+RB2XFckU5NY+/Sw4DHazc2fGWvLNv4+gwp2843J7
         Tiy88P43A5XHAw/70p3y9cNnBgN79CWkRMntLI4ky8aFgLtH3I+3SbH3BuIMFTBZSCq4
         l//fPSnL1sLVM0PdOn9ov0PgiGppC/zxgxHM1w7SwcPHayhTkSEK2L4VX1piH8d9+AoU
         CwK6C6jGEpFScgWdMR4gqAsX1vb/YIQc+e4d1UxxnX0WriZyekg6DDo64Vv8QdqaeEJH
         90bLTNTEjX/DPMI6rPMx0IFrIY7hppXCzqzD8xbryzVDqfIO7puIeVBNsOsCEC0sSgqj
         vzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sqBz3rXiTAfGOzTCaILFljzYUMfiSCtG7ou831kT3yw=;
        b=z86rJn/bkALKMxYRMMAiQe2qSxmdXEe7O6cv+9lnNzZ3S6WddqOuVL6CpxkaJKE4aM
         dpuwbtSM1tz76kYCJ6CzwNuM+X8UqhgoEFQBjLc8VJjYdkkEsvvR7GC4IMtCeScCR33h
         hVQNR5BYxUQtygZCennIIP9EZwHdXuj4Spq5d8Z+3oFuFn/9SWiOH8yLsQhtkOwnqtzQ
         meiBsVHnj6GopzavnZfUNytfwOgl9+bsVOALOdmP4tkxjeGasL0dVZS6rzUi2RRgcAWR
         KGm2kmPd+qNoZulKeyTicA1ADut0hN8kvmMfLZ3ZkeiQDRuaNEKjNC7PWdr1yh1qEpLg
         Tq2w==
X-Gm-Message-State: AOAM530WO3vlg8IB67bvywTmI2wSdDc4sX6yIE/Gdd69IncfcEEsK5Xp
        yuAafvpHq+fYER91mLSGdw4=
X-Google-Smtp-Source: ABdhPJxaupM1dEfrWDLiL+H6HU2mE+OYBvvKY6NKN8P61O/MnbGZOVExTzVeNaGkuX1d1Via6+tvqA==
X-Received: by 2002:adf:f085:: with SMTP id n5mr12107335wro.418.1639990092162;
        Mon, 20 Dec 2021 00:48:12 -0800 (PST)
Received: from [10.0.0.4] ([37.165.56.90])
        by smtp.gmail.com with ESMTPSA id c9sm1459474wml.12.2021.12.20.00.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 00:48:11 -0800 (PST)
Subject: Re: [PATCH v8 net-next 06/13] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
References: <20211217181629.28081-1-simon.horman@corigine.com>
 <20211217181629.28081-7-simon.horman@corigine.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3d678d71-cc44-1824-7b9b-c12482078be6@gmail.com>
Date:   Mon, 20 Dec 2021 00:48:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211217181629.28081-7-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/17/21 10:16 AM, Simon Horman wrote:
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


Hi there.


I think this is causing the following syzbot splat, please take a look, 
thanks !


WARNING: suspicious RCU usage
5.16.0-rc5-syzkaller #0 Not tainted
-----------------------------
include/net/tc_act/tc_tunnel_key.h:33 suspicious 
rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor393/3602:
  #0: ffffffff8d313968 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock 
net/core/rtnetlink.c:72 [inline]
  #0: ffffffff8d313968 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock 
net/core/rtnetlink.c:72 [inline] net/core/rtnetlink.c:5567
  #0: ffffffff8d313968 (rtnl_mutex){+.+.}-{3:3}, at: 
rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5567 
net/core/rtnetlink.c:5567

stack backtrace:
CPU: 1 PID: 3602 Comm: syz-executor393 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
Google 01/01/2011
Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  __dump_stack lib/dump_stack.c:88 [inline] lib/dump_stack.c:106
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106 lib/dump_stack.c:106
  is_tcf_tunnel_set include/net/tc_act/tc_tunnel_key.h:33 [inline]
  is_tcf_tunnel_set include/net/tc_act/tc_tunnel_key.h:33 [inline] 
net/sched/act_tunnel_key.c:832
  tcf_tunnel_key_offload_act_setup+0x4f2/0xa20 
net/sched/act_tunnel_key.c:832 net/sched/act_tunnel_key.c:832
  offload_action_init net/sched/act_api.c:194 [inline]
  offload_action_init net/sched/act_api.c:194 [inline] 
net/sched/act_api.c:263
  tcf_action_offload_add_ex+0x279/0x550 net/sched/act_api.c:263 
net/sched/act_api.c:263
  tcf_action_offload_add net/sched/act_api.c:294 [inline]
  tcf_action_offload_add net/sched/act_api.c:294 [inline] 
net/sched/act_api.c:1439
  tcf_action_init+0x601/0x860 net/sched/act_api.c:1439 
net/sched/act_api.c:1439
  tcf_action_add+0xf9/0x480 net/sched/act_api.c:1940 
net/sched/act_api.c:1940
  tc_ctl_action+0x346/0x470 net/sched/act_api.c:1999 
net/sched/act_api.c:1999
  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5570 
net/core/rtnetlink.c:5570
  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492 
net/netlink/af_netlink.c:2492
  netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
  netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline] 
net/netlink/af_netlink.c:1341
  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341 
net/netlink/af_netlink.c:1341
  netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917 
net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:704 [inline]
  sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:724
  sock_sendmsg+0xcf/0x120 net/socket.c:724 net/socket.c:724
  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409 net/socket.c:2409
  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463 net/socket.c:2463
  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492 net/socket.c:2492
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_x64 arch/x86/entry/common.c:50 [inline] 
arch/x86/entry/common.c:80
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80 
arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f896932b2a9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeff6cc4d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f896932b2a9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003



>   include/linux/netdevice.h  |  1 +
>   include/net/flow_offload.h | 17 +++++++
>   include/net/pkt_cls.h      |  5 ++
>   net/core/flow_offload.c    | 42 +++++++++++++----
>   net/sched/act_api.c        | 93 ++++++++++++++++++++++++++++++++++++++
>   net/sched/act_csum.c       |  4 +-
>   net/sched/act_ct.c         |  4 +-
>   net/sched/act_gact.c       | 13 +++++-
>   net/sched/act_gate.c       |  4 +-
>   net/sched/act_mirred.c     | 13 +++++-
>   net/sched/act_mpls.c       | 16 ++++++-
>   net/sched/act_police.c     |  4 +-
>   net/sched/act_sample.c     |  4 +-
>   net/sched/act_skbedit.c    | 11 ++++-
>   net/sched/act_tunnel_key.c |  9 +++-
>   net/sched/act_vlan.c       | 16 ++++++-
>   net/sched/cls_api.c        | 21 +++++++--
>   17 files changed, 254 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a419718612c6..8b0bdeb4734e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -920,6 +920,7 @@ enum tc_setup_type {
>   	TC_SETUP_QDISC_TBF,
>   	TC_SETUP_QDISC_FIFO,
>   	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>   };
>   
>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 2271da5aa8ee..5b8c54eb7a6b 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,23 @@ struct flow_cls_offload {
>   	u32 classid;
>   };
>   
> +enum offload_act_command  {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +
> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
> +	enum offload_act_command  command;
> +	enum flow_action_id id;
> +	u32 index;
> +	struct flow_stats stats;
> +	struct flow_action action;
> +};
> +
> +struct flow_offload_action *offload_action_alloc(unsigned int num_actions);
> +
>   static inline struct flow_rule *
>   flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>   {
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 5d4ff76d37e2..1bfb616ea759 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -262,6 +262,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>   	for (; 0; (void)(i), (void)(a), (void)(exts))
>   #endif
>   
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>   static inline void
>   tcf_exts_stats_update(const struct tcf_exts *exts,
>   		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -539,6 +542,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>   int tc_setup_offload_action(struct flow_action *flow_action,
>   			    const struct tcf_exts *exts);
>   void tc_cleanup_offload_action(struct flow_action *flow_action);
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>   
>   int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>   		     void *type_data, bool err_stop, bool rtnl_held);
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6beaea13564a..022c945817fa 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -27,6 +27,26 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>   }
>   EXPORT_SYMBOL(flow_rule_alloc);
>   
> +struct flow_offload_action *offload_action_alloc(unsigned int num_actions)
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
> +
>   #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
>   	const struct flow_match *__m = &(__rule)->match;			\
>   	struct flow_dissector *__d = (__m)->dissector;				\
> @@ -549,19 +569,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>   				void (*cleanup)(struct flow_block_cb *block_cb))
>   {
>   	struct flow_indr_dev *this;
> +	u32 count = 0;
> +	int err;
>   
>   	mutex_lock(&flow_indr_block_lock);
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
>   	mutex_unlock(&flow_indr_block_lock);
>   
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
>   }
>   EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 3258da3d5bed..5c21401b0555 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -19,8 +19,10 @@
>   #include <net/sock.h>
>   #include <net/sch_generic.h>
>   #include <net/pkt_cls.h>
> +#include <net/tc_act/tc_pedit.h>
>   #include <net/act_api.h>
>   #include <net/netlink.h>
> +#include <net/flow_offload.h>
>   
>   #ifdef CONFIG_INET
>   DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
> @@ -129,8 +131,92 @@ static void free_tcf(struct tc_action *p)
>   	kfree(p);
>   }
>   
> +static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
> +{
> +	if (is_tcf_pedit(act))
> +		return tcf_pedit_nkeys(act);
> +	else
> +		return 1;
> +}
> +
> +static int offload_action_init(struct flow_offload_action *fl_action,
> +			       struct tc_action *act,
> +			       enum offload_act_command  cmd,
> +			       struct netlink_ext_ack *extack)
> +{
> +	fl_action->extack = extack;
> +	fl_action->command = cmd;
> +	fl_action->index = act->tcfa_index;
> +
> +	if (act->ops->offload_act_setup)
> +		return act->ops->offload_act_setup(act, fl_action, NULL, false);
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
> +					  fl_act, NULL, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/* offload the tc action after it is inserted */
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> +		[0] = action,
> +	};
> +	struct flow_offload_action *fl_action;
> +	int num, err = 0;
> +
> +	num = tcf_offload_act_num_actions_single(action);
> +	fl_action = offload_action_alloc(num);
> +	if (!fl_action)
> +		return -ENOMEM;
> +
> +	err = offload_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
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
> +	tc_cleanup_offload_action(&fl_action->action);
> +
> +fl_err:
> +	kfree(fl_action);
> +
> +	return err;
> +}
> +
> +static int tcf_action_offload_del(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act = {};
> +	int err = 0;
> +
> +	err = offload_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd(&fl_act, NULL);
> +}
> +
>   static void tcf_action_cleanup(struct tc_action *p)
>   {
> +	tcf_action_offload_del(p);
>   	if (p->ops->cleanup)
>   		p->ops->cleanup(p);
>   
> @@ -1061,6 +1147,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>   	return ERR_PTR(err);
>   }
>   
> +static bool tc_act_bind(u32 flags)
> +{
> +	return !!(flags & TCA_ACT_FLAGS_BIND);
> +}
> +
>   /* Returns numbers of initialized actions or negative error. */
>   
>   int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1103,6 +1194,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>   		sz += tcf_action_fill_size(act);
>   		/* Start from index 0 */
>   		actions[i - 1] = act;
> +		if (!tc_act_bind(flags))
> +			tcf_action_offload_add(act, extack);
>   	}
>   
>   	/* We have to commit them all together, because if any error happened in
> diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
> index 4428852a03d7..e0f515b774ca 100644
> --- a/net/sched/act_csum.c
> +++ b/net/sched/act_csum.c
> @@ -705,7 +705,9 @@ static int tcf_csum_offload_act_setup(struct tc_action *act, void *entry_data,
>   		entry->csum_flags = tcf_csum_update_flags(act);
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		fl_action->id = FLOW_ACTION_CSUM;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index dc64f31e5191..1c537913a189 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1505,7 +1505,9 @@ static int tcf_ct_offload_act_setup(struct tc_action *act, void *entry_data,
>   		entry->ct.flow_table = tcf_ct_ft(act);
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		fl_action->id = FLOW_ACTION_CT;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
> index f77be22069f4..bde6a6c01e64 100644
> --- a/net/sched/act_gact.c
> +++ b/net/sched/act_gact.c
> @@ -272,7 +272,18 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		if (is_tcf_gact_ok(act))
> +			fl_action->id = FLOW_ACTION_ACCEPT;
> +		else if (is_tcf_gact_shot(act))
> +			fl_action->id = FLOW_ACTION_DROP;
> +		else if (is_tcf_gact_trap(act))
> +			fl_action->id = FLOW_ACTION_TRAP;
> +		else if (is_tcf_gact_goto_chain(act))
> +			fl_action->id = FLOW_ACTION_GOTO;
> +		else
> +			return -EOPNOTSUPP;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 1d8297497692..d56e73843a4b 100644
> --- a/net/sched/act_gate.c
> +++ b/net/sched/act_gate.c
> @@ -637,7 +637,9 @@ static int tcf_gate_offload_act_setup(struct tc_action *act, void *entry_data,
>   			return err;
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		fl_action->id = FLOW_ACTION_GATE;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 8eecf55be0a2..39acd1d18609 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -482,7 +482,18 @@ static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		if (is_tcf_mirred_egress_redirect(act))
> +			fl_action->id = FLOW_ACTION_REDIRECT;
> +		else if (is_tcf_mirred_egress_mirror(act))
> +			fl_action->id = FLOW_ACTION_MIRRED;
> +		else if (is_tcf_mirred_ingress_redirect(act))
> +			fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
> +		else if (is_tcf_mirred_ingress_mirror(act))
> +			fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
> +		else
> +			return -EOPNOTSUPP;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index a4615e1331e0..b9ff3459fdab 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -415,7 +415,21 @@ static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
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
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> index abb6d16a20b2..0923aa2b8f8a 100644
> --- a/net/sched/act_police.c
> +++ b/net/sched/act_police.c
> @@ -421,7 +421,9 @@ static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
>   		entry->police.mtu = tcf_police_tcfp_mtu(act);
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		fl_action->id = FLOW_ACTION_POLICE;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
> index 07e56903211e..9a22cdda6bbd 100644
> --- a/net/sched/act_sample.c
> +++ b/net/sched/act_sample.c
> @@ -303,7 +303,9 @@ static int tcf_sample_offload_act_setup(struct tc_action *act, void *entry_data,
>   		tcf_offload_sample_get_group(entry, act);
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		fl_action->id = FLOW_ACTION_SAMPLE;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index c380f9e6cc95..ceba11b198bb 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -347,7 +347,16 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		if (is_tcf_skbedit_mark(act))
> +			fl_action->id = FLOW_ACTION_MARK;
> +		else if (is_tcf_skbedit_ptype(act))
> +			fl_action->id = FLOW_ACTION_PTYPE;
> +		else if (is_tcf_skbedit_priority(act))
> +			fl_action->id = FLOW_ACTION_PRIORITY;
> +		else
> +			return -EOPNOTSUPP;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
> index e96a65a5323e..23aba03d26a8 100644
> --- a/net/sched/act_tunnel_key.c
> +++ b/net/sched/act_tunnel_key.c
> @@ -827,7 +827,14 @@ static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
> +		if (is_tcf_tunnel_set(act))
> +			fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
> +		else if (is_tcf_tunnel_release(act))
> +			fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
> +		else
> +			return -EOPNOTSUPP;
>   	}
>   
>   	return 0;
> diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
> index 0300792084f0..756e2dcde1cd 100644
> --- a/net/sched/act_vlan.c
> +++ b/net/sched/act_vlan.c
> @@ -395,7 +395,21 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
>   		}
>   		*index_inc = 1;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +
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
>   	}
>   
>   	return 0;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 53f263c9a725..353e1eed48be 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3488,8 +3488,8 @@ static int tc_setup_offload_act(struct tc_action *act,
>   #endif
>   }
>   
> -int tc_setup_offload_action(struct flow_action *flow_action,
> -			    const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>   {
>   	int i, j, index, err = 0;
>   	struct tc_action *act;
> @@ -3498,11 +3498,11 @@ int tc_setup_offload_action(struct flow_action *flow_action,
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>   
> -	if (!exts)
> +	if (!actions)
>   		return 0;
>   
>   	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>   		struct flow_action_entry *entry;
>   
>   		entry = &flow_action->entries[j];
> @@ -3531,6 +3531,19 @@ int tc_setup_offload_action(struct flow_action *flow_action,
>   	spin_unlock_bh(&act->tcfa_lock);
>   	goto err_out;
>   }
> +
> +int tc_setup_offload_action(struct flow_action *flow_action,
> +			    const struct tcf_exts *exts)
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
>   EXPORT_SYMBOL(tc_setup_offload_action);
>   
>   unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
