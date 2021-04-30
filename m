Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5C936F8F5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 13:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhD3LL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 07:11:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50559 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhD3LL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 07:11:58 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id C43ED5C0052;
        Fri, 30 Apr 2021 07:11:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 30 Apr 2021 07:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; h=
        references:from:to:cc:subject:in-reply-to:date:message-id
        :mime-version:content-type; s=fm2; bh=DdYRdCW4vkkZaihub+NRW8O6Hr
        lVlJs1PtcUlTTj01g=; b=CIOqmmfWQ+83vPcBKKJBye7JdRbUN1XyiUNzbZcvXp
        DRfVu3pI+vzctNOKSkNcwol2AgIqufWCUIDYz4PA5/9ekExj2Zd66oEsswFdNWlz
        mSeMSFjKX5YjbfxokJ+TyRDDyXPajaO2hDNa/kunh+b9Qfrt58LEsXJCJHxR9UgK
        0uT7Qfo2cq47HzLUUh2QRREG2EvCAwnwBYecQwkGhgzkmuMRzN6SxpECopjE7C+5
        wEPMMkQsad7nw+SZUtrl5Gc5bFf8CxT9e4GqpCM2+afHGASBl2Na+fdKZGSyy0UL
        YEUKtC0wE1js9XEUHAQRk8c3wTcJgMVKuZdHjWQYoLQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DdYRdC
        W4vkkZaihub+NRW8O6HrlVlJs1PtcUlTTj01g=; b=orVbKAFvSnOOAXHkmEgs9A
        9g5XZUXj01wtCHLLOdEp9BBcR/b141vHg13RCYzehsTmDCPVmGnphhZ/+BUDzLyv
        B7IRxXgVW7Bk3rjvVIu6FcPiToW+3NaAYtkREI4XMA7Z9eTApO5HhpnfUoqwTLFL
        JrA3QfB5wMqKPJKLRkzawDQR/kjv3YeHi6F+vFPAvCqoxivP7Q4KPYk4c+DDiCeM
        5944StqtZYzzQzRFO04d8izrZAWpE9fNX7SLrpbjJdEaweOSiR+58u898wSR/cDE
        jPrjFBuCVEAeWk+oTyZiMGeTPy5OL6zt+6qki5ca1Md+O+OJBB54DUgqW5WvudBA
        ==
X-ME-Sender: <xms:zeWLYL8MA0pIXrvQgb1VJqkaPBS6CAZs66_vC-P58A5sTl9t09Svzw>
    <xme:zeWLYHsjyurpASZY__CVWo6FvOXpmYk47z-49Z2LhAsSej-8hee8Hhbgu80KWLcBU
    6I30gQpLOcAeM0eSYs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddviedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvufgjfffkgggtsehttdertddtredtnecuhfhrohhmpegglhgrugcu
    uehushhlohhvuceovhhlrggusegsuhhslhhovhdruggvvheqnecuggftrfgrthhtvghrnh
    ephfeivdffgfeffeettefhffelueekkeeifeekiefghefgvedugfegffevieefudfhnecu
    kfhppeeivddrvddthedrudefhedrudehvdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehvlhgrugessghushhlohhvrdguvghv
X-ME-Proxy: <xmx:zeWLYJD1teoYTzj0ngIyo5cRx9iLN98FBiaGefFdPEVm4zEX84oJSA>
    <xmx:zeWLYHdavO8GMQ4HOgB5ZVQsOznTtMi5GDc0lqa_r5KIDPt_hJ9iYw>
    <xmx:zeWLYAMzcSDn04Kw6CkHoGsW_pA79h5mva30whnDeeCKd_cdxRwoGA>
    <xmx:zeWLYP1xLbilax-zWWf0I7z5HoB3m6dEbFymnJOH1hReXJlqz-F__Q>
Received: from vlad-x1g6 (u5543.alfa-inet.net [62.205.135.152])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 30 Apr 2021 07:11:07 -0400 (EDT)
References: <20210429081014.28498-1-simon.horman@netronome.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Vlad Buslov <vlad@buslov.dev>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc
 action to net device
In-reply-to: <20210429081014.28498-1-simon.horman@netronome.com>
Date:   Fri, 30 Apr 2021 14:11:05 +0300
Message-ID: <87sg383u46.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 29 Apr 2021 at 11:10, Simon Horman <simon.horman@netronome.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
>
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used my multiple flows and whose lifecycle is
> independent of any flows that use them.
>
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
>  .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
>  include/linux/netdevice.h                     |  1 +
>  include/net/flow_offload.h                    | 15 ++++++++
>  include/net/pkt_cls.h                         |  6 ++++
>  include/net/tc_act/tc_police.h                |  5 +++
>  net/core/flow_offload.c                       | 26 +++++++++++++-
>  net/sched/act_api.c                           | 30 ++++++++++++++++
>  net/sched/cls_api.c                           | 34 ++++++++++++++++---
>  10 files changed, 119 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 5e4429b14b8c..edbbf7b4df77 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
>  				 void *data,
>  				 void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> -	if (!bnxt_is_netdev_indr_offload(netdev))
> +	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
>  		return -EOPNOTSUPP;
>  
>  	switch (type) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 6cdc52d50a48..c8dde4bc3961 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -490,6 +490,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
>  			    void *data,
>  			    void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
>  		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> index e95969c462e4..f6c665051173 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1839,6 +1839,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
>  			    void *data,
>  			    void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>  	if (!nfp_fl_is_netdev_to_offload(netdev))
>  		return -EOPNOTSUPP;
>  
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5cbc950b34df..2f8cb65d85d1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -923,6 +923,7 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_TBF,
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>  };
>  
>  /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index dc5c1e69cd9f..5fd8b5600b4a 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,21 @@ struct flow_cls_offload {
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
> +	struct netlink_ext_ack *extack;
> +	enum flow_act_command command;
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
> index 255e4f4b521f..5c6549ae0cc7 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (; 0; (void)(i), (void)(a), (void)(exts))
>  #endif
>  
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -538,6 +541,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>  
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts);
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -558,6 +563,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  enum tc_setup_type type, void *type_data,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions(struct tc_action *actions[]);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index 72649512dcdd..6309519bf9d4 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -53,6 +53,11 @@ static inline bool is_tcf_police(const struct tc_action *act)
>  	return false;
>  }
>  
> +static inline u32 tcf_police_index(const struct tc_action *act)
> +{
> +	return act->tcfa_index;
> +}
> +
>  static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
>  {
>  	struct tcf_police *police = to_police(act);
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 715b67f6c62f..0fa2f75cc9b3 100644
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
> @@ -476,6 +497,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
>  
>  	mutex_unlock(&flow_indr_block_lock);
>  
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	if (bo)
> +		return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	else
> +		return 0;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index f6d5755d669e..dab24688d9c7 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1059,6 +1059,34 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> +/* offload the tc command after inserted */
> +int tcf_action_offload_cmd(struct tc_action *actions[], bool add, struct netlink_ext_ack *extack)
> +{
> +	int err = 0;
> +	struct flow_offload_action *fl_act;
> +
> +	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
> +	if (!fl_act)
> +		return -ENOMEM;
> +
> +	fl_act->extack = extack;
> +	err = tc_setup_action(&fl_act->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to setup tc actions for offload\n");
> +		goto err_out;
> +	}
> +	fl_act->command = add ? FLOW_ACT_REPLACE : FLOW_ACT_DESTROY;
> +
> +	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);

So many NULL arguments to this function, which requires adding more
!=NULL checks down the stack. I would like to suggest some better
approach but couldn't come up with anything that doesn't require big
refactoring in flow_offload infra and/or drivers that rely on it :(

> +
> +	tc_cleanup_flow_action(&fl_act->action);
> +
> +err_out:
> +	kfree(fl_act);
> +	return err;
> +}
> +EXPORT_SYMBOL(tcf_action_offload_cmd);
> +
>  /* Returns numbers of initialized actions or negative error. */
>  
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1107,6 +1135,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  	 */
>  	tcf_idr_insert_many(actions);
>  
> +	tcf_action_offload_cmd(actions, true, extack);

Marking the actions as in_hw/not_in_hw would simplify debugging problems
with offloads IMO.

>  	*attr_size = tcf_action_full_attrs_size(sz);
>  	err = i - 1;
>  	goto err_mod;
> @@ -1465,6 +1494,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>  	if (event == RTM_GETACTION)
>  		ret = tcf_get_notify(net, portid, n, actions, event, extack);
>  	else { /* delete */
> +		tcf_action_offload_cmd(actions, false, extack);

I wonder how this would interact with concurrent filter creation.
Consider the following example sequence:

          +-------+                         +-------+
          |       |                         |       |
          | Task1 |                         | Task2 |
          |       |                         |       |
          +---+---+                         +---+---+
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| Init action id=1            |                 |
| refcnt=1 bindcnt=0          |                 |
|                             |                 |
+-------------+---------------+                 |
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| tcf_action_offload_cmd(id=1)|                 |
|                             |                 |
+-------------+---------------+                 |
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| Driver creates act id=1     |                 |
|                             |                 |
+-------------+---------------+                 |
              |                   +-------------v---------------+
              v                   |                             |
             ...                  | Init filter with act id=1   |
              +                   | refcnt=2 bindcnt=1          |
              |                   |                             |
+-------------v---------------+   +-------------+---------------+
|                             |                 |
| Del action id=1             |                 |
| refcnt=2 bindcnt=1          |                 |
|                             |                 |
+-------------+---------------+                 |
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| tcf_action_offload_cmd(id=1)|                 |
|                             |                 |
+-------------+---------------+                 |
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| Driver deletes act id=1     |                 |
|                             |                 |
+-------------+---------------+                 |
              |                                 |
+-------------v---------------+                 |
|                             |                 |
| tcf_action_delete()==-EPERM |                 |
| refcnt=2 bindcnt=1          |                 |
|                             |                 |
+-----------------------------+                 |
                                                |
                                  +-------------v---------------+
                                  |                             |
                                  | tc_setup_cb_add()           |
                                  |                             |
                                  +-------------+---------------+
                                                |
                                  +-------------v---------------+
                                  |                             |
                                  | Driver can't find act id=1  |
                                  | Create new one? Return err? |
                                  |                             |
                                  +-----------------------------+

I guess one could argue that users shouldn't do such "stupid" things but
I would prefer this new action offload API to be robust from the start.
Maybe it is better to only notify the driver if tcf_del_notify()
succeeded?

>  		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
>  		if (ret)
>  			goto err;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 40fbea626dfd..995024c20df6 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3551,8 +3551,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
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
> @@ -3561,11 +3561,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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
> @@ -3732,6 +3732,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	spin_unlock_bh(&act->tcfa_lock);
>  	goto err_out;
>  }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +}
>  EXPORT_SYMBOL(tc_setup_flow_action);
>  
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
> @@ -3750,6 +3760,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_num_actions);
>  
> +unsigned int tcf_act_num_actions(struct tc_action *actions[])
> +{
> +	unsigned int num_acts = 0;
> +	struct tc_action *act;
> +	int i;
> +
> +	tcf_act_for_each_action(i, act, actions) {
> +		if (is_tcf_pedit(act))
> +			num_acts += tcf_pedit_nkeys(act);
> +		else
> +			num_acts++;
> +	}
> +	return num_acts;
> +}
> +EXPORT_SYMBOL(tcf_act_num_actions);
> +
>  #ifdef CONFIG_NET_CLS_ACT
>  static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>  					u32 *p_block_index,

