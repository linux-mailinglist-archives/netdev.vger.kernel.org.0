Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD09A353
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405348AbfHVWyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:54:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35579 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405344AbfHVWyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:54:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so6698711qke.2
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iqP3X+4XR8CzttbXBs8rWsEeJmqwWmoY0vFvEC0dy8E=;
        b=FWA937E27rQe0G0b8g2bY4Zwc9JN5s1xS2XZUn/t6g9mfOuy8JcMeKN6E18Y7V3j1W
         WTL+/DIA6gBF/H523i7vLsQ02zwSsUDk24NLSEwEcYZrMQF44cxtkbos30p07gNRZRQT
         vBmYPXIVsw6/Z6EYvK8MI10XDAMSMDq7DNbfYwEFh5OiKwugm5pqsI8TvaxFGZGDFKrL
         y7cgJ6xCtRYpuz6kMVB4fWBwU3dXpqXDMDX9RBD8lng7bqGmSmnMmpv+T9BkSvPsWi+1
         MMAbwaf3tZ+0RhauwnDxlHDmeO27CUQzh/NUNpHyaf5F7V2w2s8yyMX9HkQ8p2q54NRD
         LNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iqP3X+4XR8CzttbXBs8rWsEeJmqwWmoY0vFvEC0dy8E=;
        b=BAoU5ZGfEynZNCCcDf2tQYfA6H5wxAAn+0WVE+jy1T9BlvgkT+xHgBXHpCn8begInv
         LLooScCag0+IF6o16ogWNf1txLuIRb9CdEaXVfYypVKI+uQnZ3nvSq/gYArFV5OhIzDW
         WOHQiTu6go7mkgpoLei7ABSdFNgXaNGceNYY2rflEkfR0ykGlCptC1AVvKGNLgUlnuGE
         bbmrMh0l5w9wugRY/56fV4DeUbf66V96VJ4oUPIjmpYjc197JH0FOHTcA4b9cnL+mNr8
         FywChvtJkutMPqm04t8n3yqjOo2KglXTw2FOZSQhVpAaBRkyIyUpQlll44D+i2o09aQx
         05nw==
X-Gm-Message-State: APjAAAWDtijC4CbntO/q3DjFSwHvUXNs8NFXh3+o3zFQGr2/T8wo5Ca1
        ZyNjbN8gqqaQwQb1EZ/8/JLgEw==
X-Google-Smtp-Source: APXvYqzQii0E51hM5xeIkOk99hlvn3tkjRMC+rT35WuI1FuOq/p67IC9rP36OQ0i7yIA2/0vVE1/JQ==
X-Received: by 2002:ae9:f10d:: with SMTP id k13mr1508555qkg.68.1566514446351;
        Thu, 22 Aug 2019 15:54:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 67sm562185qkh.108.2019.08.22.15.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 15:54:06 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:53:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 03/10] net: sched: refactor block offloads
 counter usage
Message-ID: <20190822155358.0171852c@cakuba.netronome.com>
In-Reply-To: <20190822124353.16902-4-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
        <20190822124353.16902-4-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 15:43:46 +0300, Vlad Buslov wrote:
> Without rtnl lock protection filters can no longer safely manage block
> offloads counter themselves. Refactor cls API to protect block offloadcnt
> with tcf_block->cb_lock that is already used to protect driver callback
> list and nooffloaddevcnt counter. The counter can be modified by concurrent
> tasks by new functions that execute block callbacks (which is safe with
> previous patch that changed its type to atomic_t), however, block
> bind/unbind code that checks the counter value takes cb_lock in write mode
> to exclude any concurrent modifications. This approach prevents race
> conditions between bind/unbind and callback execution code but allows for
> concurrency for tc rule update path.
> 
> Move block offload counter, filter in hardware counter and filter flags
> management from classifiers into cls hardware offloads API. Make functions
> tcf_block_offload_inc() and tcf_block_offload_dec() to be cls API private.
> Implement following new cls API to be used instead:
> 
>   tc_setup_cb_add() - non-destructive filter add. If filter that wasn't
>   already in hardware is successfully offloaded, increment block offloads
>   counter, set filter in hardware counter and flag. On failure, previously
>   offloaded filter is considered to be intact and offloads counter is not
>   decremented.
> 
>   tc_setup_cb_replace() - destructive filter replace. Release existing
>   filter block offload counter and reset its in hardware counter and flag.
>   Set new filter in hardware counter and flag. On failure, previously
>   offloaded filter is considered to be destroyed and offload counter is
>   decremented.
> 
>   tc_setup_cb_destroy() - filter destroy. Unconditionally decrement block
>   offloads counter.
> 
> Refactor all offload-capable classifiers to atomically offload filters to
> hardware, change block offload counter, and set filter in hardware counter
> and flag by means of the new cls API functions.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Looks good, minor nits

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 8502bd006b37..4215c849f4a3 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3000,13 +3000,97 @@ int tcf_exts_dump_stats(struct sk_buff *skb, struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_dump_stats);
>  
> -int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> -		     void *type_data, bool err_stop)
> +static void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
> +{
> +	if (*flags & TCA_CLS_FLAGS_IN_HW)
> +		return;
> +	*flags |= TCA_CLS_FLAGS_IN_HW;
> +	atomic_inc(&block->offloadcnt);
> +}
> +
> +static void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
> +{
> +	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
> +		return;
> +	*flags &= ~TCA_CLS_FLAGS_IN_HW;
> +	atomic_dec(&block->offloadcnt);
> +}
> +
> +void tc_cls_offload_cnt_update(struct tcf_block *block, struct tcf_proto *tp,
> +			       u32 *cnt, u32 *flags, u32 diff, bool add)
> +{
> +	lockdep_assert_held(&block->cb_lock);
> +
> +	spin_lock(&tp->lock);
> +	if (add) {
> +		if (!*cnt)
> +			tcf_block_offload_inc(block, flags);
> +		(*cnt) += diff;

brackets unnecessary

> +	} else {
> +		(*cnt) -= diff;
> +		if (!*cnt)
> +			tcf_block_offload_dec(block, flags);
> +	}
> +	spin_unlock(&tp->lock);
> +}
> +EXPORT_SYMBOL(tc_cls_offload_cnt_update);
> +
> +static void
> +tc_cls_offload_cnt_reset(struct tcf_block *block, struct tcf_proto *tp,
> +			 u32 *cnt, u32 *flags)
> +{
> +	lockdep_assert_held(&block->cb_lock);
> +
> +	spin_lock(&tp->lock);
> +	tcf_block_offload_dec(block, flags);
> +	(*cnt) = 0;

ditto

> +	spin_unlock(&tp->lock);
> +}
> +
> +static int
> +__tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> +		   void *type_data, bool err_stop)
>  {
>  	struct flow_block_cb *block_cb;
>  	int ok_count = 0;
>  	int err;
>  
> +	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
> +		err = block_cb->cb(type, type_data, block_cb->cb_priv);
> +		if (err) {
> +			if (err_stop)
> +				return err;
> +		} else {
> +			ok_count++;
> +		}
> +	}
> +	return ok_count;
> +}
> +
> +int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> +		     void *type_data, bool err_stop, bool rtnl_held)
> +{
> +	int ok_count;
> +
> +	down_read(&block->cb_lock);
> +	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> +	up_read(&block->cb_lock);
> +	return ok_count;
> +}
> +EXPORT_SYMBOL(tc_setup_cb_call);
> +
> +/* Non-destructive filter add. If filter that wasn't already in hardware is
> + * successfully offloaded, increment block offloads counter. On failure,
> + * previously offloaded filter is considered to be intact and offloads counter
> + * is not decremented.
> + */
> +

Spurious new line here?

> +int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
> +		    enum tc_setup_type type, void *type_data, bool err_stop,
> +		    u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
> +{
> +	int ok_count;
> +
>  	down_read(&block->cb_lock);
>  	/* Make sure all netdevs sharing this block are offload-capable. */
>  	if (block->nooffloaddevcnt && err_stop) {
> @@ -3014,22 +3098,67 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>  		goto errout;
>  	}
>  
> -	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
> -		err = block_cb->cb(type, type_data, block_cb->cb_priv);
> -		if (err) {
> -			if (err_stop) {
> -				ok_count = err;
> -				goto errout;
> -			}
> -		} else {
> -			ok_count++;
> -		}
> +	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> +	if (ok_count > 0)
> +		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
> +					  ok_count, true);
> +errout:

and the labels again

> +	up_read(&block->cb_lock);
> +	return ok_count;
> +}
> +EXPORT_SYMBOL(tc_setup_cb_add);
> +
> +/* Destructive filter replace. If filter that wasn't already in hardware is
> + * successfully offloaded, increment block offload counter. On failure,
> + * previously offloaded filter is considered to be destroyed and offload counter
> + * is decremented.
> + */
> +

spurious new line?

> +int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
> +			enum tc_setup_type type, void *type_data, bool err_stop,
> +			u32 *old_flags, unsigned int *old_in_hw_count,
> +			u32 *new_flags, unsigned int *new_in_hw_count,
> +			bool rtnl_held)
> +{
> +	int ok_count;
> +
> +	down_read(&block->cb_lock);
> +	/* Make sure all netdevs sharing this block are offload-capable. */
> +	if (block->nooffloaddevcnt && err_stop) {
> +		ok_count = -EOPNOTSUPP;
> +		goto errout;
>  	}
> +
> +	tc_cls_offload_cnt_reset(block, tp, old_in_hw_count, old_flags);
> +
> +	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> +	if (ok_count > 0)
> +		tc_cls_offload_cnt_update(block, tp, new_in_hw_count, new_flags,
> +					  ok_count, true);
>  errout:
>  	up_read(&block->cb_lock);
>  	return ok_count;
>  }
> -EXPORT_SYMBOL(tc_setup_cb_call);
> +EXPORT_SYMBOL(tc_setup_cb_replace);
> +
> +/* Destroy filter and decrement block offload counter, if filter was previously
> + * offloaded.
> + */
> +

hm.. is this gap between comment and function it pertains to
intentional?

> +int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
> +			enum tc_setup_type type, void *type_data, bool err_stop,
> +			u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
> +{
> +	int ok_count;
> +
> +	down_read(&block->cb_lock);
> +	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> +
> +	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
> +	up_read(&block->cb_lock);
> +	return ok_count;
> +}
> +EXPORT_SYMBOL(tc_setup_cb_destroy);
>  
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts)
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index 3f7a9c02b70c..7f304db7e697 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -162,17 +162,21 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
>  	cls_bpf.name = obj->bpf_name;
>  	cls_bpf.exts_integrated = obj->exts_integrated;
>  
> -	if (oldprog)
> -		tcf_block_offload_dec(block, &oldprog->gen_flags);
> +	if (cls_bpf.oldprog)

why the change from oldprog to cls_bpf.oldprog?

> +		err = tc_setup_cb_replace(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
> +					  skip_sw, &oldprog->gen_flags,
> +					  &oldprog->in_hw_count,
> +					  &prog->gen_flags, &prog->in_hw_count,
> +					  true);
> +	else
> +		err = tc_setup_cb_add(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
> +				      skip_sw, &prog->gen_flags,
> +				      &prog->in_hw_count, true);
>  
> -	err = tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, skip_sw);
>  	if (prog) {
>  		if (err < 0) {
>  			cls_bpf_offload_cmd(tp, oldprog, prog, extack);
>  			return err;
> -		} else if (err > 0) {
> -			prog->in_hw_count = err;
> -			tcf_block_offload_inc(block, &prog->gen_flags);
>  		}
>  	}
>  
> @@ -230,7 +234,7 @@ static void cls_bpf_offload_update_stats(struct tcf_proto *tp,
>  	cls_bpf.name = prog->bpf_name;
>  	cls_bpf.exts_integrated = prog->exts_integrated;
>  
> -	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false);
> +	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false, true);
>  }
>  
>  static int cls_bpf_init(struct tcf_proto *tp)
> @@ -680,8 +684,8 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb
>  			continue;
>  		}
>  
> -		tc_cls_offload_cnt_update(block, &prog->in_hw_count,
> -					  &prog->gen_flags, add);
> +		tc_cls_offload_cnt_update(block, tp, &prog->in_hw_count,
> +					  &prog->gen_flags, 1, add);

Since we're adding those higher level add/replace/destroy helpers,
would it also be possible to have a helper which takes care of
reoffload? tc_cls_offload_cnt_update() is kind of low level now, it'd
be cool to also hide it in the core.

>  	}
>  
>  	return 0;
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 054123742e32..0001a933d48b 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -419,10 +419,10 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
>  	cls_flower.command = FLOW_CLS_DESTROY;
>  	cls_flower.cookie = (unsigned long) f;
>  
> -	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
> +	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
> +			    &f->flags, &f->in_hw_count, true);
>  	spin_lock(&tp->lock);
>  	list_del_init(&f->hw_list);
> -	tcf_block_offload_dec(block, &f->flags);
>  	spin_unlock(&tp->lock);
>  
>  	if (!rtnl_held)
> @@ -466,18 +466,15 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>  		goto errout;
>  	}
>  
> -	err = tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, skip_sw);
> +	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
> +			      skip_sw, &f->flags, &f->in_hw_count, true);
>  	kfree(cls_flower.rule);
>  
>  	if (err < 0) {
>  		fl_hw_destroy_filter(tp, f, true, NULL);
>  		goto errout;
>  	} else if (err > 0) {
> -		f->in_hw_count = err;
>  		err = 0;

Why does the tc_setup_cb* API still return the positive values, the
callers should no longer care, right?

> -		spin_lock(&tp->lock);
> -		tcf_block_offload_inc(block, &f->flags);
> -		spin_unlock(&tp->lock);
>  	}
>  
>  	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW)) {
