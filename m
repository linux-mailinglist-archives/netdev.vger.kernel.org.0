Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812C14DA324
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351290AbiCOTPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiCOTPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:15:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C676450;
        Tue, 15 Mar 2022 12:14:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hw13so41605710ejc.9;
        Tue, 15 Mar 2022 12:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EFbNP0w17xl4ckdv5kSOTgg6lZ5fIOgNdcD9IrB7lZg=;
        b=nEWTjh3R0qw2MipkYfZuI0wD5nIYhk9jDbUZJkU5yx/6WkTNzqOlh1+crJ1GxgbOpD
         aFNTBS8E/wbdwQutDEHcHc/JiSLCaSYpAME4NbTiUyjUstDWJTTHeaH9ouA2jv4e96I7
         6p84LWCSgC9SiVrA5FV1SX99MslJ/FDBERDu84cXu7NgDto6gFEBqoYjHWb8xFu5p16Q
         lNBIJ+svxwtN57DVr2rLD7LprJxsvnJRw6Zacp8E0sauEPaoO1Pq0zWCroJjHoS8hP9+
         atylVOW2c49WzA+9qdN07181oobuGKAxwi/1ESVnxYMcQSVHFy2/kz37UsNI2poGn3Ge
         PDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EFbNP0w17xl4ckdv5kSOTgg6lZ5fIOgNdcD9IrB7lZg=;
        b=XtcOCnrc/sRcSC+noMgQnpTLMnDEGI/eidkQGNH1cAFli6zlr90dTTc4GZTYr0a4sq
         DMIllINFiilcD0mtnzxkHCHjSctUZ5HymlYuzmjDa+QzRbiwkVbF21wJBaF0bNehfujP
         KwNCHDOwEULAuhrckASAlyT1bBGRJymi3jbuzXip2GABeqTgvPEdqSmjjyYG35djE/Wj
         qgtVZfx1QPeEEtkfLW7ViunWcB6q+sfUWxZL2mHFAfFFc7nTlnu9CKyxQvekvtztZZwM
         6qfU+em6Jh/d46tU9m6ND6PMXvMFZoS4SIOzllKJAml/UDHzp4VPgj7YHsrxZkiu0IzO
         9LlA==
X-Gm-Message-State: AOAM530ULk8Jc+ruLrhOPrq31C5aFQZ1+CJkFodHUc1ZeotUlybBltRS
        9paDVwcZwcrZ35m+fedL2fM=
X-Google-Smtp-Source: ABdhPJyqnW/s/xxkoxZyQK1hpu8pU8gNgK4myEyJyvcj0jAlA6+BetXmfPBcIbP6vXrwUlJczymR1w==
X-Received: by 2002:a17:906:a0ce:b0:6d1:cb30:3b3b with SMTP id bh14-20020a170906a0ce00b006d1cb303b3bmr23968745ejb.582.1647371641484;
        Tue, 15 Mar 2022 12:14:01 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm8408270ejj.74.2022.03.15.12.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 12:14:00 -0700 (PDT)
Date:   Tue, 15 Mar 2022 21:13:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, andrew@lunn.ch,
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
Message-ID: <20220315191358.taujzi2kwxlp6iuf@skbuf>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224102908.5255-2-jianbol@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jianbo,

On Thu, Feb 24, 2022 at 10:29:07AM +0000, Jianbo Liu wrote:
> The current police offload action entry is missing exceed/notexceed
> actions and parameters that can be configured by tc police action.
> Add the missing parameters as a pre-step for offloading police actions
> to hardware.
> 
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/flow_offload.h     |  9 +++++++
>  include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
>  net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 5b8c54eb7a6b..74f44d44abe3 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -148,6 +148,8 @@ enum flow_action_id {
>  	FLOW_ACTION_MPLS_MANGLE,
>  	FLOW_ACTION_GATE,
>  	FLOW_ACTION_PPPOE_PUSH,
> +	FLOW_ACTION_JUMP,
> +	FLOW_ACTION_PIPE,
>  	NUM_FLOW_ACTIONS,
>  };
>  
> @@ -235,9 +237,16 @@ struct flow_action_entry {
>  		struct {				/* FLOW_ACTION_POLICE */
>  			u32			burst;
>  			u64			rate_bytes_ps;
> +			u64			peakrate_bytes_ps;
> +			u32			avrate;
> +			u16			overhead;
>  			u64			burst_pkt;
>  			u64			rate_pkt_ps;
>  			u32			mtu;
> +			struct {
> +				enum flow_action_id	act_id;
> +				u32			extval;
> +			} exceed, notexceed;
>  		} police;
>  		struct {				/* FLOW_ACTION_CT */
>  			int action;
> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index 72649512dcdd..283bde711a42 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -159,4 +159,34 @@ static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
>  	return params->tcfp_mtu;
>  }
>  
> +static inline u64 tcf_police_peakrate_bytes_ps(const struct tc_action *act)
> +{
> +	struct tcf_police *police = to_police(act);
> +	struct tcf_police_params *params;
> +
> +	params = rcu_dereference_protected(police->params,
> +					   lockdep_is_held(&police->tcf_lock));
> +	return params->peak.rate_bytes_ps;
> +}
> +
> +static inline u32 tcf_police_tcfp_ewma_rate(const struct tc_action *act)
> +{
> +	struct tcf_police *police = to_police(act);
> +	struct tcf_police_params *params;
> +
> +	params = rcu_dereference_protected(police->params,
> +					   lockdep_is_held(&police->tcf_lock));
> +	return params->tcfp_ewma_rate;
> +}
> +
> +static inline u16 tcf_police_rate_overhead(const struct tc_action *act)
> +{
> +	struct tcf_police *police = to_police(act);
> +	struct tcf_police_params *params;
> +
> +	params = rcu_dereference_protected(police->params,
> +					   lockdep_is_held(&police->tcf_lock));
> +	return params->rate.overhead;
> +}
> +
>  #endif /* __NET_TC_POLICE_H */
> diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> index 0923aa2b8f8a..a2275eef6877 100644
> --- a/net/sched/act_police.c
> +++ b/net/sched/act_police.c
> @@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
>  	return tcf_idr_search(tn, a, index);
>  }
>  
> +static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
> +{
> +	int act_id = -EOPNOTSUPP;
> +
> +	if (!TC_ACT_EXT_OPCODE(tc_act)) {
> +		if (tc_act == TC_ACT_OK)
> +			act_id = FLOW_ACTION_ACCEPT;
> +		else if (tc_act ==  TC_ACT_SHOT)
> +			act_id = FLOW_ACTION_DROP;
> +		else if (tc_act == TC_ACT_PIPE)
> +			act_id = FLOW_ACTION_PIPE;
> +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
> +		act_id = FLOW_ACTION_GOTO;
> +		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
> +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
> +		act_id = FLOW_ACTION_JUMP;
> +		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
> +	}
> +
> +	return act_id;
> +}
> +
>  static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
>  					u32 *index_inc, bool bind)
>  {
>  	if (bind) {
>  		struct flow_action_entry *entry = entry_data;
> +		struct tcf_police *police = to_police(act);
> +		struct tcf_police_params *p;
> +		int act_id;
> +
> +		p = rcu_dereference_protected(police->params,
> +					      lockdep_is_held(&police->tcf_lock));
>  
>  		entry->id = FLOW_ACTION_POLICE;
>  		entry->police.burst = tcf_police_burst(act);
>  		entry->police.rate_bytes_ps =
>  			tcf_police_rate_bytes_ps(act);
> +		entry->police.peakrate_bytes_ps = tcf_police_peakrate_bytes_ps(act);
> +		entry->police.avrate = tcf_police_tcfp_ewma_rate(act);
> +		entry->police.overhead = tcf_police_rate_overhead(act);
>  		entry->police.burst_pkt = tcf_police_burst_pkt(act);
>  		entry->police.rate_pkt_ps =
>  			tcf_police_rate_pkt_ps(act);
>  		entry->police.mtu = tcf_police_tcfp_mtu(act);
> +
> +		act_id = tcf_police_act_to_flow_act(police->tcf_action,
> +						    &entry->police.exceed.extval);

I don't know why just now, but I observed an apparent regression here
with these commands:

root@debian:~# tc qdisc add dev swp3 clsact
root@debian:~# tc filter add dev swp3 ingress protocol ip flower skip_sw ip_proto icmp action police rate 100Mbit burst 10000
[   45.767900] tcf_police_act_to_flow_act: 434: tc_act 1
[   45.773100] tcf_police_offload_act_setup: 475, act_id -95
Error: cls_flower: Failed to setup flow action.
We have an error talking to the kernel, -1

The reason why I'm not sure is because I don't know if this should have
worked as intended or not. I am remarking just now in "man tc-police"
that the default conform-exceed action is "reclassify".

So if I specify "conform-exceed drop", things are as expected, but with
the default (implicitly "conform-exceed reclassify") things fail with
-EOPNOTSUPP because tcf_police_act_to_flow_act() doesn't handle a
police->tcf_action of TC_ACT_RECLASSIFY.

Should it?

> +		if (act_id < 0)
> +			return act_id;
> +
> +		entry->police.exceed.act_id = act_id;
> +
> +		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
> +						    &entry->police.notexceed.extval);
> +		if (act_id < 0)
> +			return act_id;
> +
> +		entry->police.notexceed.act_id = act_id;
> +
>  		*index_inc = 1;
>  	} else {
>  		struct flow_offload_action *fl_action = entry_data;
> -- 
> 2.26.2
> 
