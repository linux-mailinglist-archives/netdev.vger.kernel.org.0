Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3E174592
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 08:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgB2HwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 02:52:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51617 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgB2HwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 02:52:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so5874156wmi.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 23:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S7V75uGR4nBE/L50ehrejksZtuLYmw2TmQ7T4FnFGiQ=;
        b=HC10Og+yILFaO3AoSR266k1CO/A2QZ6JUhzD5o140S3xu16OVr1oM1OhmiVPDkb+O/
         OgXBKDaiyNDuVmdwnhFMKvyusLSx3W3TsZhh+H4oTdMmEDuemDteh1MQIKixuEala6sq
         /7MXaHyTAiEopSeFKZEp/KBnGSfzvh1tQvDjvnIML38x1hc3qNbm6wG5x6k8XK+ZNqz7
         fW3h/KF8vjFOY+QxlQWu3IIXirEByjtv3r6xau+HAmYqLmZL3WRsHJel50owxMiYbful
         WBUe/f2r/9bwjv83F3e/mNPQ4aJe0waBBUN+ZZj+VUwiKo0wh/8RVOpRVmj4PnkE/8KL
         UJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S7V75uGR4nBE/L50ehrejksZtuLYmw2TmQ7T4FnFGiQ=;
        b=MbGys84/IBgsH7BA2rWGATG12JKTJ+YDt0zTFHr9XWM+44WEb2Klkw4e4KkfIZD47B
         qwB7wAstGqJM5wXBaJLB3iDi4pQgT0V/Mve9nk3XSHBBQzRPXa8RnwE7LDifd3ITqyTL
         IDO9ElTcK1G0V9bZNDZjljxYTzO/ix3jR/qRnoFX/Cw8TtqmhwL45rQB9uD54aRU8V0G
         0veyW47GwJ+3fplYS5PEwUIAUehEukBJv1QOmasqQeu+qGpD/JSYShhHUFANfP6OvLCE
         8hCmeNlld6RMjhd6Rb+u0IRgZ+nfzM7IfGvvixJRgTXzfWH4rG3AH+8aZpkswgTwja1e
         pZvg==
X-Gm-Message-State: APjAAAX8J3OlhKngvAiILmKi9ddsogA1bJrtf/uwZxutNPQleFrNOVDB
        ymklSH5jNnNsh/Vh+8VDcW9bfQ==
X-Google-Smtp-Source: APXvYqzYONaxFLeOw4IDA+ISYBWSvM3DVF/B/v/pLLWwTiPf1znj+pCNIqBIhO8sTkU7W/+jcensLA==
X-Received: by 2002:a7b:c010:: with SMTP id c16mr8913540wmb.148.1582962730518;
        Fri, 28 Feb 2020 23:52:10 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id p17sm13700273wre.89.2020.02.28.23.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 23:52:09 -0800 (PST)
Date:   Sat, 29 Feb 2020 08:52:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify type
 of HW stats for a filter
Message-ID: <20200229075209.GM26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-13-jiri@resnulli.us>
 <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 28, 2020 at 08:59:23PM CET, kuba@kernel.org wrote:
>On Fri, 28 Feb 2020 18:25:05 +0100 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently, user who is adding an action expects HW to report stats,
>> however it does not have exact expectations about the stats types.
>> That is aligned with TCA_ACT_HW_STATS_TYPE_ANY.
>> 
>> Allow user to specify the type of HW stats for an action and require it.
>> 
>> Pass the information down to flow_offload layer.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> - moved the stats attr from cls_flower (filter) to any action
>> - rebased on top of cookie offload changes
>> - adjusted the patch description a bit
>
>Thanks, this looks good... I mean I wish we could just share actions
>instead but this set is less objectionable than v1 :)

You can still share actions, this patchset does not stop you from doing
that.


>
>> diff --git a/include/net/act_api.h b/include/net/act_api.h
>> index 71347a90a9d1..02b9bffa17ed 100644
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -39,6 +39,7 @@ struct tc_action {
>>  	struct gnet_stats_basic_cpu __percpu *cpu_bstats_hw;
>>  	struct gnet_stats_queue __percpu *cpu_qstats;
>>  	struct tc_cookie	__rcu *act_cookie;
>> +	enum tca_act_hw_stats_type	hw_stats_type;
>>  	struct tcf_chain	__rcu *goto_chain;
>>  	u32			tcfa_flags;
>>  };
>> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>> index 449a63971451..096ea59a090b 100644
>> --- a/include/uapi/linux/pkt_cls.h
>> +++ b/include/uapi/linux/pkt_cls.h
>> @@ -17,6 +17,7 @@ enum {
>>  	TCA_ACT_PAD,
>>  	TCA_ACT_COOKIE,
>>  	TCA_ACT_FLAGS,
>> +	TCA_ACT_HW_STATS_TYPE,
>>  	__TCA_ACT_MAX
>>  };
>>  
>> @@ -118,6 +119,31 @@ enum tca_id {
>>  
>>  #define TCA_ID_MAX __TCA_ID_MAX
>>  
>> +/* tca HW stats type */
>> +enum tca_act_hw_stats_type {
>> +	TCA_ACT_HW_STATS_TYPE_ANY, /* User does not care, it's default
>> +				    * when user does not pass the attr.
>> +				    * Instructs the driver that user does not
>> +				    * care if the HW stats are "immediate"
>> +				    * or "delayed".
>> +				    */
>> +	TCA_ACT_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
>> +					  * the current HW stats state from
>> +					  * the device queried at the dump time.
>> +					  */
>> +	TCA_ACT_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
>> +					* HW stats that might be out of date
>> +					* for some time, maybe couple of
>> +					* seconds. This is the case when driver
>> +					* polls stats updates periodically
>> +					* or when it gets async stats update
>> +					* from the device.
>> +					*/
>> +	TCA_ACT_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
>> +					 * any HW statistics.
>> +					 */
>> +};
>
>On the ABI I wonder if we can redefine it a little bit..
>
>Can we make the stat types into a bitfield?
>
>On request:
> - no attr -> any stats allowed but some stats must be provided *
> - 0       -> no stats requested / disabled
> - 0x1     -> must be stat type0
> - 0x6     -> stat type1 or stat type2 are both fine

I was thinking about this of course. On the write side, this is ok
however, this is very tricky on read side. See below.


>
>* no attr kinda doesn't work 'cause u32 offload has no stats and this
>  is action-level now, not flower-level :S What about u32 and matchall?

The fact that cls does not implement stats offloading is a lack of
feature of the particular cls.


>
>We can add a separate attribute with "active" stat types:
> - no attr -> old kernel
> - 0       -> no stats are provided / stats disabled
> - 0x1     -> only stat type0 is used by drivers
> - 0x6     -> at least one driver is using type1 and one type2

There are 2 problems:
1) There is a mismatch between write and read. User might pass different
value than it eventually gets from kernel. I guess this might be fine.
2) Much bigger problem is, that since the same action may be offloaded
by multiple drivers, the read would have to provide an array of
bitfields, each array item would represent one offloaded driver. That is
why I decided for simple value instead of bitfield which is the same on
write and read.


>
>That assumes that we may one day add another stat type which would 
>not be just based on the reporting time.
>
>If we only foresee time-based reporting would it make sense to turn 
>the attribute into max acceptable delay in ms?
>
>0        -> only immediate / blocking stats
>(0, MAX) -> given reporting delay in ms is acceptable
>MAX      -> don't care about stats at all

Interesting, is this "delayed" granularity something that has a usecase?
It might turn into a guessing game between user and driver during action
insertion :/


>
>>  struct tc_police {
>>  	__u32			index;
>>  	int			action;
>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>> index 8c466a712cda..d6468b09b932 100644
>> --- a/net/sched/act_api.c
>> +++ b/net/sched/act_api.c
>> @@ -185,6 +185,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
>>  	return  nla_total_size(0) /* action number nested */
>>  		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
>>  		+ cookie_len /* TCA_ACT_COOKIE */
>> +		+ nla_total_size(sizeof(u8)) /* TCA_ACT_HW_STATS_TYPE */
>>  		+ nla_total_size(0) /* TCA_ACT_STATS nested */
>>  		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
>>  		/* TCA_STATS_BASIC */
>> @@ -788,6 +789,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>>  	}
>>  	rcu_read_unlock();
>>  
>> +	if (nla_put_u8(skb, TCA_ACT_HW_STATS_TYPE, a->hw_stats_type))
>> +		goto nla_put_failure;
>> +
>>  	if (a->tcfa_flags) {
>>  		struct nla_bitfield32 flags = { a->tcfa_flags,
>>  						a->tcfa_flags, };
>> @@ -854,12 +858,23 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
>>  	return c;
>>  }
>>  
>> +static inline enum tca_act_hw_stats_type
>
>static inline in C source

Ah, I moved from .h and forgot. Thanks.


>
>> +tcf_action_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
>> +{
>> +	/* If the user did not pass the attr, that means he does
>> +	 * not care about the type. Return "any" in that case.
>> +	 */
>> +	return hw_stats_type_attr ? nla_get_u8(hw_stats_type_attr) :
>> +				    TCA_ACT_HW_STATS_TYPE_ANY;
>> +}
>> +
>>  static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
>>  static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
>>  	[TCA_ACT_KIND]		= { .type = NLA_STRING },
>>  	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
>>  	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
>>  				    .len = TC_COOKIE_MAX_SIZE },
>> +	[TCA_ACT_HW_STATS_TYPE]	= { .type = NLA_U8 },
>
>We can use a POLICY with MIN/MAX here, perhaps?

Ok.


>
>>  	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
>>  	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
>>  				    .validation_data = &tca_act_flags_allowed },
>> @@ -871,6 +886,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>  				    bool rtnl_held,
>>  				    struct netlink_ext_ack *extack)
>>  {
>> +	enum tca_act_hw_stats_type hw_stats_type = TCA_ACT_HW_STATS_TYPE_ANY;
>>  	struct nla_bitfield32 flags = { 0, 0 };
>>  	struct tc_action *a;
>>  	struct tc_action_ops *a_o;
>> @@ -903,6 +919,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>  				goto err_out;
>>  			}
>>  		}
>> +		hw_stats_type =
>> +			tcf_action_hw_stats_type_get(tb[TCA_ACT_HW_STATS_TYPE]);
>>  		if (tb[TCA_ACT_FLAGS])
>>  			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
>>  	} else {
>> @@ -953,6 +971,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>  	if (!name && tb[TCA_ACT_COOKIE])
>>  		tcf_set_action_cookie(&a->act_cookie, cookie);
>>  
>> +	if (!name)
>> +		a->hw_stats_type = hw_stats_type;
>> +
>>  	/* module count goes up only when brand new policy is created
>>  	 * if it exists and is only bound to in a_o->init() then
>>  	 * ACT_P_CREATED is not returned (a zero is).
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 4e766c5ab77a..21bf37242153 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3458,9 +3458,28 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
>>  #endif
>>  }
>>  
>> +static inline enum flow_action_hw_stats_type
>
>static inline in C source

Right.


>
>> +tcf_flow_action_hw_stats_type(enum tca_act_hw_stats_type hw_stats_type)
>> +{
>> +	switch (hw_stats_type) {
>> +	default:
>> +		WARN_ON(1);
>> +		/* fall-through */
>
>without the policy change this seems user-triggerable

Nope. tcf_action_hw_stats_type_get() takes care of setting 
TCA_ACT_HW_STATS_TYPE_ANY when no attr is passed.


>
>> +	case TCA_ACT_HW_STATS_TYPE_ANY:
>> +		return FLOW_ACTION_HW_STATS_TYPE_ANY;
>> +	case TCA_ACT_HW_STATS_TYPE_IMMEDIATE:
>> +		return FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE;
>> +	case TCA_ACT_HW_STATS_TYPE_DELAYED:
>> +		return FLOW_ACTION_HW_STATS_TYPE_DELAYED;
>> +	case TCA_ACT_HW_STATS_TYPE_DISABLED:
>> +		return FLOW_ACTION_HW_STATS_TYPE_DISABLED;
>> +	}
>> +}
>> +
>>  int tc_setup_flow_action(struct flow_action *flow_action,
>>  			 const struct tcf_exts *exts)
>>  {
>> +	enum flow_action_hw_stats_type uninitialized_var(last_hw_stats_type);
>>  	struct tc_action *act;
>>  	int i, j, k, err = 0;
>>  
>> @@ -3476,6 +3495,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>>  		err = tcf_act_get_cookie(entry, act);
>>  		if (err)
>>  			goto err_out_locked;
>> +
>> +		entry->hw_stats_type =
>> +			tcf_flow_action_hw_stats_type(act->hw_stats_type);
>> +		if (i && last_hw_stats_type != entry->hw_stats_type)
>> +			flow_action->mixed_hw_stats_types = true;
>> +		last_hw_stats_type = entry->hw_stats_type;
>> +
>>  		if (is_tcf_gact_ok(act)) {
>>  			entry->id = FLOW_ACTION_ACCEPT;
>>  		} else if (is_tcf_gact_shot(act)) {
>
