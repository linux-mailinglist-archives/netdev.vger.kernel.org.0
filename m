Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6F4DC775
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiCQNYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiCQNYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:24:12 -0400
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A6B1D66FF;
        Thu, 17 Mar 2022 06:22:50 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 472E358016A;
        Thu, 17 Mar 2022 09:22:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 17 Mar 2022 09:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eIlSa6kmb49A6jcxW
        6cwLD9pgSEo9IJnzEj0YDWlu10=; b=b+KhIddF8J0sNT4bfCDjgMmQrtgAWfXGl
        EAGO/qPzgdZ58oetHJnYWEDtgsC8NYFKFZklKUEGKvmjmroPe4lDzixrk/hjDUuY
        KeT8U4Ja4eMn8+Y2aNW+Pc14r7W5QCbiGe4vt/pVCU8sPkJrWywfWCf+tseiOHaW
        dezo3n2Aire65l6nI/mDxZzlJCYUNOA6P4WFWB4ULobbkr7H344QzQ7T0zkzC3xA
        EHX//ljz+jIiZRqJpgpIjTgMCXwLqTQXC4YVagPPh91vAFwa4TLYRfPSU8lNBa31
        zCBrCESN5LsrQfFZKF0h1YEA5k0bitCpb6ISNatHxAvfB3kIRD3Vw==
X-ME-Sender: <xms:JzYzYny07R5NXiO5tesyU_Pl_9chN6YYNMiM8nTJkjiCH6_Mg7axvg>
    <xme:JzYzYvRco-3JekkUPGyfZKYyg-FCmWat3Enc7Jg1iVoS-GLIK9kdyytmO5jPt42Sl
    1r15FyTPL9XcYs>
X-ME-Received: <xmr:JzYzYhUkYjTmY3V3JfCqyKXRkwcA3Of5LxoWLmu1zOwf4UKO_DOfvlXUiDigtBTThsY75_zTPfWXc4NoPgRmgr_FRfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JzYzYhinczglwNOn4Eo3EHcmCutmDrAiv7cm-nwzeGpoQdW5dLUptA>
    <xmx:JzYzYpB5wQdieAYe1J7I7B1FLTplQ278ypxnsGmzRFFkWH05d8lPhg>
    <xmx:JzYzYqK-PpLSNovypGnRPira-b8nGFrT15f39AXq4L2jvqOW8n3eFw>
    <xmx:KDYzYqvxTfJn2T9op5AQG23zXoXuC1Vli2PVUP1cjlITl13-stHwLw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 09:22:46 -0400 (EDT)
Date:   Thu, 17 Mar 2022 15:22:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jianbo Liu <jianbol@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v3 1/2] net: flow_offload: add tc police action
 parameters
Message-ID: <YjM2IhX4k5XHnya0@shredder>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
 <20220315191358.taujzi2kwxlp6iuf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315191358.taujzi2kwxlp6iuf@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 09:13:58PM +0200, Vladimir Oltean wrote:
> Hello Jianbo,
> 
> On Thu, Feb 24, 2022 at 10:29:07AM +0000, Jianbo Liu wrote:
> > The current police offload action entry is missing exceed/notexceed
> > actions and parameters that can be configured by tc police action.
> > Add the missing parameters as a pre-step for offloading police actions
> > to hardware.
> > 
> > Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> > Signed-off-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  include/net/flow_offload.h     |  9 +++++++
> >  include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
> >  net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 85 insertions(+)
> > 
> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index 5b8c54eb7a6b..74f44d44abe3 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -148,6 +148,8 @@ enum flow_action_id {
> >  	FLOW_ACTION_MPLS_MANGLE,
> >  	FLOW_ACTION_GATE,
> >  	FLOW_ACTION_PPPOE_PUSH,
> > +	FLOW_ACTION_JUMP,
> > +	FLOW_ACTION_PIPE,
> >  	NUM_FLOW_ACTIONS,
> >  };
> >  
> > @@ -235,9 +237,16 @@ struct flow_action_entry {
> >  		struct {				/* FLOW_ACTION_POLICE */
> >  			u32			burst;
> >  			u64			rate_bytes_ps;
> > +			u64			peakrate_bytes_ps;
> > +			u32			avrate;
> > +			u16			overhead;
> >  			u64			burst_pkt;
> >  			u64			rate_pkt_ps;
> >  			u32			mtu;
> > +			struct {
> > +				enum flow_action_id	act_id;
> > +				u32			extval;
> > +			} exceed, notexceed;
> >  		} police;
> >  		struct {				/* FLOW_ACTION_CT */
> >  			int action;
> > diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> > index 72649512dcdd..283bde711a42 100644
> > --- a/include/net/tc_act/tc_police.h
> > +++ b/include/net/tc_act/tc_police.h
> > @@ -159,4 +159,34 @@ static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
> >  	return params->tcfp_mtu;
> >  }
> >  
> > +static inline u64 tcf_police_peakrate_bytes_ps(const struct tc_action *act)
> > +{
> > +	struct tcf_police *police = to_police(act);
> > +	struct tcf_police_params *params;
> > +
> > +	params = rcu_dereference_protected(police->params,
> > +					   lockdep_is_held(&police->tcf_lock));
> > +	return params->peak.rate_bytes_ps;
> > +}
> > +
> > +static inline u32 tcf_police_tcfp_ewma_rate(const struct tc_action *act)
> > +{
> > +	struct tcf_police *police = to_police(act);
> > +	struct tcf_police_params *params;
> > +
> > +	params = rcu_dereference_protected(police->params,
> > +					   lockdep_is_held(&police->tcf_lock));
> > +	return params->tcfp_ewma_rate;
> > +}
> > +
> > +static inline u16 tcf_police_rate_overhead(const struct tc_action *act)
> > +{
> > +	struct tcf_police *police = to_police(act);
> > +	struct tcf_police_params *params;
> > +
> > +	params = rcu_dereference_protected(police->params,
> > +					   lockdep_is_held(&police->tcf_lock));
> > +	return params->rate.overhead;
> > +}
> > +
> >  #endif /* __NET_TC_POLICE_H */
> > diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> > index 0923aa2b8f8a..a2275eef6877 100644
> > --- a/net/sched/act_police.c
> > +++ b/net/sched/act_police.c
> > @@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
> >  	return tcf_idr_search(tn, a, index);
> >  }
> >  
> > +static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
> > +{
> > +	int act_id = -EOPNOTSUPP;
> > +
> > +	if (!TC_ACT_EXT_OPCODE(tc_act)) {
> > +		if (tc_act == TC_ACT_OK)
> > +			act_id = FLOW_ACTION_ACCEPT;
> > +		else if (tc_act ==  TC_ACT_SHOT)
> > +			act_id = FLOW_ACTION_DROP;
> > +		else if (tc_act == TC_ACT_PIPE)
> > +			act_id = FLOW_ACTION_PIPE;
> > +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
> > +		act_id = FLOW_ACTION_GOTO;
> > +		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
> > +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
> > +		act_id = FLOW_ACTION_JUMP;
> > +		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
> > +	}
> > +
> > +	return act_id;
> > +}
> > +
> >  static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
> >  					u32 *index_inc, bool bind)
> >  {
> >  	if (bind) {
> >  		struct flow_action_entry *entry = entry_data;
> > +		struct tcf_police *police = to_police(act);
> > +		struct tcf_police_params *p;
> > +		int act_id;
> > +
> > +		p = rcu_dereference_protected(police->params,
> > +					      lockdep_is_held(&police->tcf_lock));
> >  
> >  		entry->id = FLOW_ACTION_POLICE;
> >  		entry->police.burst = tcf_police_burst(act);
> >  		entry->police.rate_bytes_ps =
> >  			tcf_police_rate_bytes_ps(act);
> > +		entry->police.peakrate_bytes_ps = tcf_police_peakrate_bytes_ps(act);
> > +		entry->police.avrate = tcf_police_tcfp_ewma_rate(act);
> > +		entry->police.overhead = tcf_police_rate_overhead(act);
> >  		entry->police.burst_pkt = tcf_police_burst_pkt(act);
> >  		entry->police.rate_pkt_ps =
> >  			tcf_police_rate_pkt_ps(act);
> >  		entry->police.mtu = tcf_police_tcfp_mtu(act);
> > +
> > +		act_id = tcf_police_act_to_flow_act(police->tcf_action,
> > +						    &entry->police.exceed.extval);
> 
> I don't know why just now, but I observed an apparent regression here
> with these commands:
> 
> root@debian:~# tc qdisc add dev swp3 clsact
> root@debian:~# tc filter add dev swp3 ingress protocol ip flower skip_sw ip_proto icmp action police rate 100Mbit burst 10000
> [   45.767900] tcf_police_act_to_flow_act: 434: tc_act 1
> [   45.773100] tcf_police_offload_act_setup: 475, act_id -95
> Error: cls_flower: Failed to setup flow action.
> We have an error talking to the kernel, -1
> 
> The reason why I'm not sure is because I don't know if this should have
> worked as intended or not. I am remarking just now in "man tc-police"
> that the default conform-exceed action is "reclassify".
> 
> So if I specify "conform-exceed drop", things are as expected, but with
> the default (implicitly "conform-exceed reclassify") things fail with
> -EOPNOTSUPP because tcf_police_act_to_flow_act() doesn't handle a
> police->tcf_action of TC_ACT_RECLASSIFY.
> 
> Should it?

Even if tcf_police_act_to_flow_act() handled "reclassify", the
configuration would have been rejected later on by the relevant device
driver since they all support "drop" for exceed action and nothing else.

I don't know why iproute2 defaults to "reclassify", but the
configuration in the example does something different in the SW and HW
data paths. One ugly suggestion to keep this case working it to have
tcf_police_act_to_flow_act() default to "drop" and emit a warning via
extack so that user space is at least aware of this misconfiguration.

> 
> > +		if (act_id < 0)
> > +			return act_id;
> > +
> > +		entry->police.exceed.act_id = act_id;
> > +
> > +		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
> > +						    &entry->police.notexceed.extval);
> > +		if (act_id < 0)
> > +			return act_id;
> > +
> > +		entry->police.notexceed.act_id = act_id;
> > +
> >  		*index_inc = 1;
> >  	} else {
> >  		struct flow_offload_action *fl_action = entry_data;
> > -- 
> > 2.26.2
> > 
