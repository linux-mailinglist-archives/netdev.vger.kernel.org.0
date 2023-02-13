Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68EE694F97
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjBMSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjBMSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:44:00 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0CA1CF5A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:43:58 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id l4so2044114qvh.11
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+s4UUPvayw/D3+sLnvcS9n7obwwd/pClKHazzENDD0=;
        b=gsX9Qay+0GPhi5QwHCWxlzFTaJ7XmmvADw9AXBP4oJ1V4j91R6WEmz70/GGNcGiUXW
         aaTYSXpnR9JkkIVQg+bUbIvXwFUtU75DaJnfgFR79hR2xTtseINkdc8M1+ARI12a49or
         XUaIO58xvhZQfXE7lP5yq0lPNGww0SECPeRdPUwXQT5MKLCdv/RVVl1iw8k7b2JF9cKA
         3mtH1hI+hLsuqF2OPKZE6b6k5Ok2DdO/50lapGQKwQXrEGmwIXIy6ZROMU8JO8WMOcM1
         AwJsmwTdp+cuZB+UOlFpz/FYgNPb6ysjgpUpFT7VsEyEFuUeikZGFnny51NjmmuKSogC
         k5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+s4UUPvayw/D3+sLnvcS9n7obwwd/pClKHazzENDD0=;
        b=UCzXl7Y2mHqSfgDUUdX2RL6uTRM8wf3Ko/YNJ8jkdgzjgykB5ijGD1IpMAyQtO58fw
         HemczJCz3c54KMrWyQiBf0S+196FfvMCLgWEc53y8hAmp/E/BlaA7+aYxRpjlcqJHfHR
         YvvMYG+UcRdalfoYRK8brfHx5WuDChZYGrSJvBc3bso4pqKw4S2XrucqHnRc+/I3F8a6
         +O9SYvMeBUgOqhUB6LdQSk5TzHyM0jDfGmMvjzCsLhmKWSeNcKumwRVBaHMZAEkEVsd/
         et+UWZzTBkppPHrWG0XL0ODquXXev/ldDrSCQxtcrIcMRsAli/HLs3gTpovpkFOTSg+w
         UzlQ==
X-Gm-Message-State: AO0yUKWvCs0zlybByDHq243Ba1Xefg53Zfic/ee6yAn317ZBxnzOwiQl
        4gciUpwzyQkKsU4falpZZQE=
X-Google-Smtp-Source: AK7set/kIvG4C3vAINPSBspxXWN4EEqJ+P9JtlLbXa42e2+Xyx/4gtZ5Z7thuTLWVMji8ufXhaB7+Q==
X-Received: by 2002:ad4:5ecf:0:b0:56e:a96b:a3a1 with SMTP id jm15-20020ad45ecf000000b0056ea96ba3a1mr12047238qvb.7.1676313837074;
        Mon, 13 Feb 2023 10:43:57 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id d64-20020a37b443000000b0071f0d0aaef7sm10055584qkf.80.2023.02.13.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 10:43:56 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 5E5B04C22A0; Mon, 13 Feb 2023 10:43:55 -0800 (PST)
Date:   Mon, 13 Feb 2023 10:43:55 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+qE66i7R01QnvNk@t14s.localdomain>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 06:13:34PM +0200, Paul Blakey wrote:
> 
> 
> On 10/02/2023 04:21, Marcelo Ricardo Leitner wrote:
> > On Mon, Feb 06, 2023 at 07:43:57PM +0200, Paul Blakey wrote:
> > > For drivers to support partial offload of a filter's action list,
> > > add support for action miss to specify an action instance to
> > > continue from in sw.
> > > 
> > > CT action in particular can't be fully offloaded, as new connections
> > > need to be handled in software. This imposes other limitations on
> > > the actions that can be offloaded together with the CT action, such
> > > as packet modifications.
> > > 
> > > Assign each action on a filter's action list a unique miss_cookie
> > > which drivers can then use to fill action_miss part of the tc skb
> > > extension. On getting back this miss_cookie, find the action
> > > instance with relevant cookie and continue classifying from there.
> > > 
> > > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > ---
> > >   include/linux/skbuff.h     |   6 +-
> > >   include/net/flow_offload.h |   1 +
> > >   include/net/pkt_cls.h      |  34 +++---
> > >   include/net/sch_generic.h  |   2 +
> > >   net/openvswitch/flow.c     |   3 +-
> > >   net/sched/act_api.c        |   2 +-
> > >   net/sched/cls_api.c        | 213 +++++++++++++++++++++++++++++++++++--
> > >   7 files changed, 234 insertions(+), 27 deletions(-)
> > > 
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index 1fa95b916342..9b9aa854068f 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -311,12 +311,16 @@ struct nf_bridge_info {
> > >    * and read by ovs to recirc_id.
> > >    */
> > >   struct tc_skb_ext {
> > > -	__u32 chain;
> > > +	union {
> > > +		u64 act_miss_cookie;
> > > +		__u32 chain;
> > > +	};
> > >   	__u16 mru;
> > >   	__u16 zone;
> > >   	u8 post_ct:1;
> > >   	u8 post_ct_snat:1;
> > >   	u8 post_ct_dnat:1;
> > > +	u8 act_miss:1; /* Set if act_miss_cookie is used */
> > >   };
> > >   #endif
> > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > index 0400a0ac8a29..88db7346eb7a 100644
> > > --- a/include/net/flow_offload.h
> > > +++ b/include/net/flow_offload.h
> > > @@ -228,6 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
> > >   struct flow_action_entry {
> > >   	enum flow_action_id		id;
> > >   	u32				hw_index;
> > > +	u64				miss_cookie;
> > 
> > The per-action stats patchset is adding a cookie for the actions as
> > well, and exactly on this struct:
> > 
> > @@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
> >   struct flow_action_entry {
> >          enum flow_action_id             id;
> >          u32                             hw_index;
> > +       unsigned long                   act_cookie;
> >          enum flow_action_hw_stats       hw_stats;
> >          action_destr                    destructor;
> >          void                            *destructor_priv;
> > 
> > There, it is a simple value: the act pointer itself. Here, it is already more
> > complex. Can them be merged into only one maybe?
> > If not, perhaps act_cookie should be renamed to stats_cookie then.
> 
> I don't think it can be shared, actions can be shared between multiple
> filters, while the miss cookie would be different for each used instance
> (takes the filter in to account).

Good point. So it would at best be a masked value that part A works
for the miss here and part B for the stats, which is pretty much what
the two cookies are giving, just without having to do bit gymnasics,
yes.

> 
> So I'll rename it.
> 
> > 
> > >   	enum flow_action_hw_stats	hw_stats;
> > >   	action_destr			destructor;
> > >   	void				*destructor_priv;
> > > diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> > > index cd410a87517b..e395f2a84ed2 100644
> > > --- a/include/net/pkt_cls.h
> > > +++ b/include/net/pkt_cls.h
> > > @@ -59,6 +59,8 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
> > >   void tcf_block_put(struct tcf_block *block);
> > >   void tcf_block_put_ext(struct tcf_block *block, struct Qdisc *q,
> > >   		       struct tcf_block_ext_info *ei);
> > > +int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
> > > +		     int police, struct tcf_proto *tp, u32 handle, bool used_action_miss);
> > >   static inline bool tcf_block_shared(struct tcf_block *block)
> > >   {
> > > @@ -229,6 +231,7 @@ struct tcf_exts {
> > >   	struct tc_action **actions;
> > >   	struct net	*net;
> > >   	netns_tracker	ns_tracker;
> > > +	struct tcf_exts_miss_cookie_node *miss_cookie_node;
> > >   #endif
> > >   	/* Map to export classifier specific extension TLV types to the
> > >   	 * generic extensions API. Unsupported extensions must be set to 0.
> > > @@ -240,21 +243,11 @@ struct tcf_exts {
> > >   static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
> > >   				int action, int police)
> > >   {
> > > -#ifdef CONFIG_NET_CLS_ACT
> > > -	exts->type = 0;
> > > -	exts->nr_actions = 0;
> > > -	/* Note: we do not own yet a reference on net.
> > > -	 * This reference might be taken later from tcf_exts_get_net().
> > > -	 */
> > > -	exts->net = net;
> > > -	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
> > > -				GFP_KERNEL);
> > > -	if (!exts->actions)
> > > -		return -ENOMEM;
> > > +#ifdef CONFIG_NET_CLS
> > > +	return tcf_exts_init_ex(exts, net, action, police, NULL, 0, false);
> > > +#else
> > > +	return -EOPNOTSUPP;
> > >   #endif
> > > -	exts->action = action;
> > > -	exts->police = police;
> > > -	return 0;
> > >   }
> > >   /* Return false if the netns is being destroyed in cleanup_net(). Callers
> > > @@ -353,6 +346,18 @@ tcf_exts_exec(struct sk_buff *skb, struct tcf_exts *exts,
> > >   	return TC_ACT_OK;
> > >   }
> > > +static inline int
> > > +tcf_exts_exec_ex(struct sk_buff *skb, struct tcf_exts *exts, int act_index,
> > > +		 struct tcf_result *res)
> > > +{
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +	return tcf_action_exec(skb, exts->actions + act_index,
> > > +			       exts->nr_actions - act_index, res);
> > > +#else
> > > +	return TC_ACT_OK;
> > > +#endif
> > > +}
> > > +
> > >   int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
> > >   		      struct nlattr **tb, struct nlattr *rate_tlv,
> > >   		      struct tcf_exts *exts, u32 flags,
> > > @@ -577,6 +582,7 @@ int tc_setup_offload_action(struct flow_action *flow_action,
> > >   void tc_cleanup_offload_action(struct flow_action *flow_action);
> > >   int tc_setup_action(struct flow_action *flow_action,
> > >   		    struct tc_action *actions[],
> > > +		    u32 miss_cookie_base,
> > >   		    struct netlink_ext_ack *extack);
> > >   int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> > > diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> > > index af4aa66aaa4e..fab5ba3e61b7 100644
> > > --- a/include/net/sch_generic.h
> > > +++ b/include/net/sch_generic.h
> > > @@ -369,6 +369,8 @@ struct tcf_proto_ops {
> > >   						struct nlattr **tca,
> > >   						struct netlink_ext_ack *extack);
> > >   	void			(*tmplt_destroy)(void *tmplt_priv);
> > > +	struct tcf_exts *	(*get_exts)(const struct tcf_proto *tp,
> > > +					    u32 handle);
> > >   	/* rtnetlink specific */
> > >   	int			(*dump)(struct net*, struct tcf_proto*, void *,
> > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > index e20d1a973417..69f91460a55c 100644
> > > --- a/net/openvswitch/flow.c
> > > +++ b/net/openvswitch/flow.c
> > > @@ -1038,7 +1038,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
> > >   #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> > >   	if (tc_skb_ext_tc_enabled()) {
> > >   		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
> > > -		key->recirc_id = tc_ext ? tc_ext->chain : 0;
> > > +		key->recirc_id = tc_ext && !tc_ext->act_miss ?
> > > +				 tc_ext->chain : 0;
> > >   		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
> > >   		post_ct = tc_ext ? tc_ext->post_ct : false;
> > >   		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
> > > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > > index cd09ef49df22..16fd3d30eb12 100644
> > > --- a/net/sched/act_api.c
> > > +++ b/net/sched/act_api.c
> > > @@ -272,7 +272,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
> > >   	if (err)
> > >   		goto fl_err;
> > > -	err = tc_setup_action(&fl_action->action, actions, extack);
> > > +	err = tc_setup_action(&fl_action->action, actions, 0, extack);
> > >   	if (err) {
> > >   		NL_SET_ERR_MSG_MOD(extack,
> > >   				   "Failed to setup tc actions for offload");
> > > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > > index 5b4a95e8a1ee..8ff9530fef68 100644
> > > --- a/net/sched/cls_api.c
> > > +++ b/net/sched/cls_api.c
> > > @@ -22,6 +22,7 @@
> > >   #include <linux/idr.h>
> > >   #include <linux/jhash.h>
> > >   #include <linux/rculist.h>
> > > +#include <linux/rhashtable.h>
> > >   #include <net/net_namespace.h>
> > >   #include <net/sock.h>
> > >   #include <net/netlink.h>
> > > @@ -50,6 +51,109 @@ static LIST_HEAD(tcf_proto_base);
> > >   /* Protects list of registered TC modules. It is pure SMP lock. */
> > >   static DEFINE_RWLOCK(cls_mod_lock);
> > > +static struct xarray tcf_exts_miss_cookies_xa;
> > > +struct tcf_exts_miss_cookie_node {
> > > +	const struct tcf_chain *chain;
> > > +	const struct tcf_proto *tp;
> > > +	const struct tcf_exts *exts;
> > > +	u32 chain_index;
> > > +	u32 tp_prio;
> > > +	u32 handle;
> > > +	u32 miss_cookie_base;
> > > +	struct rcu_head rcu;
> > > +};
> > > +
> > > +/* Each tc action entry cookie will be comprised of 32bit miss_cookie_base +
> > > + * action index in the exts tc actions array.
> > > + */
> > > +union tcf_exts_miss_cookie {
> > > +	struct {
> > > +		u32 miss_cookie_base;
> > > +		u32 act_index;
> > > +	};
> > > +	u64 miss_cookie;
> > > +};
> > > +
> > > +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> > > +static int
> > > +tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
> > > +				u32 handle)
> > > +{
> > > +	struct tcf_exts_miss_cookie_node *n;
> > > +	static u32 next;
> > 
> > What protects this static variable from concurrent access?
> 
> 
> Nothing, but it acts as a suggestion for xa_alloc, so I don't
> think syncronzation is needed here.
> 
> 
> > 
> > > +	int err;
> > > +
> > > +	if (WARN_ON(!handle || !tp->ops->get_exts))
> > > +		return -EINVAL;
> > > +
> > > +	n = kzalloc(sizeof(*n), GFP_KERNEL);
> > > +	if (!n)
> > > +		return -ENOMEM;
> > > +
> > > +	n->chain_index = tp->chain->index;
> > > +	n->chain = tp->chain;
> > > +	n->tp_prio = tp->prio;
> > > +	n->tp = tp;
> > > +	n->exts = exts;
> > > +	n->handle = handle;
> > > +
> > > +	err = xa_alloc_cyclic(&tcf_exts_miss_cookies_xa, &n->miss_cookie_base,
> > > +			      n, xa_limit_32b, &next, GFP_KERNEL);
> > > +	if (err)
> > > +		goto err_xa_alloc;
> > > +
> > > +	exts->miss_cookie_node = n;
> > > +	return 0;
> > > +
> > > +err_xa_alloc:
> > > +	kfree(n);
> > > +	return err;
> > > +}
> > > +
> > > +static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
> > > +{
> > > +	struct tcf_exts_miss_cookie_node *n;
> > > +
> > > +	if (!exts->miss_cookie_node)
> > > +		return;
> > > +
> > > +	n = exts->miss_cookie_node;
> > > +	xa_erase(&tcf_exts_miss_cookies_xa, n->miss_cookie_base);
> > > +	kfree_rcu(n, rcu);
> > > +}
> > > +
> > > +static struct tcf_exts_miss_cookie_node *
> > > +tcf_exts_miss_cookie_lookup(u64 miss_cookie, int *act_index)
> > > +{
> > > +	union tcf_exts_miss_cookie mc = { .miss_cookie = miss_cookie, };
> > > +
> > > +	*act_index = mc.act_index;
> > > +	return xa_load(&tcf_exts_miss_cookies_xa, mc.miss_cookie_base);
> > > +}
> > > +#else /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
> > > +static int
> > > +tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
> > > +				u32 handle)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
> > > +{
> > > +}
> > > +#endif /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
> > > +
> > > +static u64 tcf_exts_miss_cookie_get(u32 miss_cookie_base, int act_index)
> > > +{
> > > +	union tcf_exts_miss_cookie mc = { .act_index = act_index, };
> > > +
> > > +	if (!miss_cookie_base)
> > > +		return 0;
> > > +
> > > +	mc.miss_cookie_base = miss_cookie_base;
> > > +	return mc.miss_cookie;
> > > +}
> > > +
> > >   #ifdef CONFIG_NET_CLS_ACT
> > >   DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc);
> > >   EXPORT_SYMBOL(tc_skb_ext_tc);
> > > @@ -1549,6 +1653,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
> > >   				 const struct tcf_proto *orig_tp,
> > >   				 struct tcf_result *res,
> > >   				 bool compat_mode,
> > > +				 struct tcf_exts_miss_cookie_node *n,
> > > +				 int act_index,
> > >   				 u32 *last_executed_chain)
> > >   {
> > >   #ifdef CONFIG_NET_CLS_ACT
> > > @@ -1560,13 +1666,36 @@ static inline int __tcf_classify(struct sk_buff *skb,
> > >   #endif
> > >   	for (; tp; tp = rcu_dereference_bh(tp->next)) {
> > >   		__be16 protocol = skb_protocol(skb, false);
> > > -		int err;
> > > +		int err = 0;
> > > -		if (tp->protocol != protocol &&
> > > -		    tp->protocol != htons(ETH_P_ALL))
> > > -			continue;
> > > +		if (n) {
> > > +			struct tcf_exts *exts;
> > > +
> > > +			if (n->tp_prio != tp->prio)
> > > +				continue;
> > > +
> > > +			/* We re-lookup the tp and chain based on index instead
> > > +			 * of having hard refs and locks to them, so do a sanity
> > > +			 * check if any of tp,chain,exts was replaced by the
> > > +			 * time we got here with a cookie from hardware.
> > > +			 */
> > > +			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
> > > +				     !tp->ops->get_exts))
> > > +				return TC_ACT_SHOT;
> > > +
> > > +			exts = tp->ops->get_exts(tp, n->handle);
> > > +			if (unlikely(!exts || n->exts != exts))
> > > +				return TC_ACT_SHOT;
> > > -		err = tc_classify(skb, tp, res);
> > > +			n = NULL;
> > > +			err = tcf_exts_exec_ex(skb, exts, act_index, res);
> > > +		} else {
> > > +			if (tp->protocol != protocol &&
> > > +			    tp->protocol != htons(ETH_P_ALL))
> > > +				continue;
> > > +
> > > +			err = tc_classify(skb, tp, res);
> > > +		}
> > >   #ifdef CONFIG_NET_CLS_ACT
> > >   		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
> > >   			first_tp = orig_tp;
> > > @@ -1582,6 +1711,9 @@ static inline int __tcf_classify(struct sk_buff *skb,
> > >   			return err;
> > >   	}
> > > +	if (unlikely(n))
> > > +		return TC_ACT_SHOT;
> > > +
> > >   	return TC_ACT_UNSPEC; /* signal: continue lookup */
> > >   #ifdef CONFIG_NET_CLS_ACT
> > >   reset:
> > > @@ -1606,21 +1738,33 @@ int tcf_classify(struct sk_buff *skb,
> > >   #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> > >   	u32 last_executed_chain = 0;
> > > -	return __tcf_classify(skb, tp, tp, res, compat_mode,
> > > +	return __tcf_classify(skb, tp, tp, res, compat_mode, NULL, 0,
> > >   			      &last_executed_chain);
> > >   #else
> > >   	u32 last_executed_chain = tp ? tp->chain->index : 0;
> > > +	struct tcf_exts_miss_cookie_node *n = NULL;
> > >   	const struct tcf_proto *orig_tp = tp;
> > >   	struct tc_skb_ext *ext;
> > > +	int act_index = 0;
> > >   	int ret;
> > >   	if (block) {
> > >   		ext = skb_ext_find(skb, TC_SKB_EXT);
> > > -		if (ext && ext->chain) {
> > > +		if (ext && (ext->chain || ext->act_miss)) {
> > >   			struct tcf_chain *fchain;
> > > +			u32 chain = ext->chain;
> > 
> > IMHO it would be nice to avoid this assignment here, because there is
> > nothing above saying that the union value can be read as a chain. For
> > C, yes, it is okay. The worry is about ensuring that whatever is
> > reading it, is reading what it is expecting it to be.
> > Perhaps just declare it here, and then:
> 
> Right, not nice, will fix.
> 
> > 
> > > -			fchain = tcf_chain_lookup_rcu(block, ext->chain);
> > > +			if (ext->act_miss) {
> > > +				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
> > > +								&act_index);
> > > +				if (!n)
> > > +					return TC_ACT_SHOT;
> > > +
> > > +				chain = n->chain_index;
> > > +			}
> > 
> > 			else {
> > 				chain = ext->chain;
> > 			}
> > 
> > > +
> > > +			fchain = tcf_chain_lookup_rcu(block, chain);
> > >   			if (!fchain)
> > >   				return TC_ACT_SHOT;
> > > @@ -1632,7 +1776,7 @@ int tcf_classify(struct sk_buff *skb,
> > >   		}
> > >   	}
> > > -	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
> > > +	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode, n, act_index,
> > >   			     &last_executed_chain);
> > >   	if (tc_skb_ext_tc_enabled()) {
> > > @@ -3056,9 +3200,48 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> > >   	return skb->len;
> > >   }
> > > +int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
> > > +		     int police, struct tcf_proto *tp, u32 handle,
> > > +		     bool use_action_miss)
> > > +{
> > > +	int err = 0;
> > > +
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +	exts->type = 0;
> > > +	exts->nr_actions = 0;
> > > +	/* Note: we do not own yet a reference on net.
> > > +	 * This reference might be taken later from tcf_exts_get_net().
> > > +	 */
> > > +	exts->net = net;
> > > +	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
> > > +				GFP_KERNEL);
> > > +	if (!exts->actions)
> > > +		return -ENOMEM;
> > > +#endif
> > > +
> > > +	exts->action = action;
> > > +	exts->police = police;
> > > +
> > > +	if (!use_action_miss)
> > > +		return 0;
> > > +
> > > +	err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
> > > +	if (err)
> > > +		goto err_miss_alloc;
> > > +
> > > +	return 0;
> > > +
> > > +err_miss_alloc:
> > > +	tcf_exts_destroy(exts);
> > > +	return err;
> > > +}
> > > +EXPORT_SYMBOL(tcf_exts_init_ex);
> > > +
> > >   void tcf_exts_destroy(struct tcf_exts *exts)
> > >   {
> > >   #ifdef CONFIG_NET_CLS_ACT
> > > +	tcf_exts_miss_cookie_base_destroy(exts);
> > > +
> > >   	if (exts->actions) {
> > >   		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
> > >   		kfree(exts->actions);
> > > @@ -3547,6 +3730,7 @@ static int tc_setup_offload_act(struct tc_action *act,
> > >   int tc_setup_action(struct flow_action *flow_action,
> > >   		    struct tc_action *actions[],
> > > +		    u32 miss_cookie_base,
> > >   		    struct netlink_ext_ack *extack)
> > >   {
> > >   	int i, j, k, index, err = 0;
> > > @@ -3577,6 +3761,8 @@ int tc_setup_action(struct flow_action *flow_action,
> > >   		for (k = 0; k < index ; k++) {
> > >   			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
> > >   			entry[k].hw_index = act->tcfa_index;
> > > +			entry[k].miss_cookie =
> > > +				tcf_exts_miss_cookie_get(miss_cookie_base, i);
> > >   		}
> > >   		j += index;
> > > @@ -3599,10 +3785,15 @@ int tc_setup_offload_action(struct flow_action *flow_action,
> > >   			    struct netlink_ext_ack *extack)
> > >   {
> > >   #ifdef CONFIG_NET_CLS_ACT
> > > +	u32 miss_cookie_base;
> > > +
> > >   	if (!exts)
> > >   		return 0;
> > > -	return tc_setup_action(flow_action, exts->actions, extack);
> > > +	miss_cookie_base = exts->miss_cookie_node ?
> > > +			   exts->miss_cookie_node->miss_cookie_base : 0;
> > > +	return tc_setup_action(flow_action, exts->actions, miss_cookie_base,
> > > +			       extack);
> > >   #else
> > >   	return 0;
> > >   #endif
> > > @@ -3770,6 +3961,8 @@ static int __init tc_filter_init(void)
> > >   	if (err)
> > >   		goto err_register_pernet_subsys;
> > > +	xa_init_flags(&tcf_exts_miss_cookies_xa, XA_FLAGS_ALLOC1);
> > > +
> > >   	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
> > >   		      RTNL_FLAG_DOIT_UNLOCKED);
> > >   	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
> > > -- 
> > > 2.30.1
> > > 
