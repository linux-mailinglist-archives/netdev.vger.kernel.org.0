Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B912456B4A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhKSIJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhKSIJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 03:09:05 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A7C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 00:06:03 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t30so16575992wra.10
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 00:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nTW4DEVcaBdKTxgnqcpXWJ/Rty+MRupTGBokWA2j3BE=;
        b=hpVMNiBa6Erx8sHOVqqpdaZ6aTlJWOUzn2zWdP9c8RP1yREMUCWsAvv8l7Oga7HvB3
         NpQPGhRLJYma1uGgADoUZKxqamtusmUFAAXtmL8SPfLWAyyqhU3jdA5h0Jbtm9lorbu7
         7M3ztljjdGoAQQeuLPzcSLM37PiqkEbbXoOiiX1L9Rhmf0YVuZ7ryd+W31DTtLk50nOv
         KkhdHLnlpb7uQa7A/Yy1myHwLXEByWUrXDP1mrCiRvAWdy5Y7ErVX4aWH4GyKaFyMubG
         UwhXw0j0a/6034buE97gmaZ45cva05dSL7Fq6sZijRFe5ARSqBo6EltaMStzoTnSQbg0
         y16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nTW4DEVcaBdKTxgnqcpXWJ/Rty+MRupTGBokWA2j3BE=;
        b=avU+0Y38NcbzfBh0iwiRqvSu9Jmqm5Kiz4ighC7WwFhuclWHPLG7M7J9YzPG1hJix4
         sde+jKKWrObmZXmmu+CQGI9FOZVqu3UeINZ9MN1V8/sYeB+t+iQ1xnCzWuLEckam4IVh
         aaG+5yasnrG5ouJCWmTVJyO3Y0ZzXvGm0O7++mHAVNvaCksHBqNrIxwjxTe0ozV10YPr
         lUGjbOcMvxenXBp+2OXFZlLLw4fyQ3sJ2jOjSZggIOd8E3rtJ4RyDZj/Fmz+8FjPz2nm
         h+NQDrRvft+d0CvY6uM+D4XC7lrCwsCj4cajd0lLtgspQeCCPzAGBGyyfWNxVOvLUYyG
         TTbA==
X-Gm-Message-State: AOAM530atn2b78zin2RvuaWqOGzqI9xpKeald9rW3FYZHswWF8ABs62j
        y/CGz2P74aoYWwwINrfMAD/gp4t6FM4pNw==
X-Google-Smtp-Source: ABdhPJwzUj+oLAihGA8P1qVOFNhkydE0fKdKDtZ/Ky2yBqm1zj4Q3kMIdR5k68ZUhTSXeJdNUJzLCQ==
X-Received: by 2002:a5d:400e:: with SMTP id n14mr4811141wrp.368.1637309161981;
        Fri, 19 Nov 2021 00:06:01 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:28cf:7e86:cefd:55f9? ([2a01:e0a:b41:c160:28cf:7e86:cefd:55f9])
        by smtp.gmail.com with ESMTPSA id j17sm2837496wmq.41.2021.11.19.00.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 00:06:01 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] xfrm: rework default policy structure
To:     Leon Romanovsky <leon@kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        antony.antony@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20211118142937.5425-1-nicolas.dichtel@6wind.com>
 <YZak297hPRh3Etun@unreal>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e724c80c-8b4f-4399-e716-1866d992a4f2@6wind.com>
Date:   Fri, 19 Nov 2021 09:06:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZak297hPRh3Etun@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/11/2021 à 20:09, Leon Romanovsky a écrit :
> On Thu, Nov 18, 2021 at 03:29:37PM +0100, Nicolas Dichtel wrote:
>> This is a follow up of commit f8d858e607b2 ("xfrm: make user policy API
>> complete"). The goal is to align userland API to the internal structures.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>
>> This patch targets ipsec-next, but because ipsec-next has not yet been
>> rebased on top of net-next, I based the patch on top of net-next.
>>
>>  include/net/netns/xfrm.h |  6 +-----
>>  include/net/xfrm.h       | 38 ++++++++---------------------------
>>  net/xfrm/xfrm_policy.c   | 10 +++++++---
>>  net/xfrm/xfrm_user.c     | 43 +++++++++++++++++-----------------------
>>  4 files changed, 34 insertions(+), 63 deletions(-)
>>
>> diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
>> index 947733a639a6..bd7c3be4af5d 100644
>> --- a/include/net/netns/xfrm.h
>> +++ b/include/net/netns/xfrm.h
>> @@ -66,11 +66,7 @@ struct netns_xfrm {
>>  	int			sysctl_larval_drop;
>>  	u32			sysctl_acq_expires;
>>  
>> -	u8			policy_default;
>> -#define XFRM_POL_DEFAULT_IN	1
>> -#define XFRM_POL_DEFAULT_OUT	2
>> -#define XFRM_POL_DEFAULT_FWD	4
>> -#define XFRM_POL_DEFAULT_MASK	7
>> +	u8			policy_default[XFRM_POLICY_MAX];
>>  
>>  #ifdef CONFIG_SYSCTL
>>  	struct ctl_table_header	*sysctl_hdr;
>> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
>> index 2308210793a0..3fd1e052927e 100644
>> --- a/include/net/xfrm.h
>> +++ b/include/net/xfrm.h
>> @@ -1075,22 +1075,6 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
>>  }
>>  
>>  #ifdef CONFIG_XFRM
>> -static inline bool
>> -xfrm_default_allow(struct net *net, int dir)
>> -{
>> -	u8 def = net->xfrm.policy_default;
>> -
>> -	switch (dir) {
>> -	case XFRM_POLICY_IN:
>> -		return def & XFRM_POL_DEFAULT_IN ? false : true;
>> -	case XFRM_POLICY_OUT:
>> -		return def & XFRM_POL_DEFAULT_OUT ? false : true;
>> -	case XFRM_POLICY_FWD:
>> -		return def & XFRM_POL_DEFAULT_FWD ? false : true;
>> -	}
>> -	return false;
>> -}
>> -
>>  int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
>>  			unsigned short family);
>>  
>> @@ -1104,13 +1088,10 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
>>  	if (sk && sk->sk_policy[XFRM_POLICY_IN])
>>  		return __xfrm_policy_check(sk, ndir, skb, family);
>>  
>> -	if (xfrm_default_allow(net, dir))
>> -		return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
>> -		       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
>> -		       __xfrm_policy_check(sk, ndir, skb, family);
>> -	else
>> -		return (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
>> -		       __xfrm_policy_check(sk, ndir, skb, family);
>> +	return (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT &&
>> +		(!net->xfrm.policy_count[dir] && !secpath_exists(skb))) ||
>> +	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
>> +	       __xfrm_policy_check(sk, ndir, skb, family);
>>  }
> 
> This is completely unreadable. What is the advantage of writing like this?
Yeah, I was hesitating. I was hoping that indentation could help.
At the opposite, I could also arg that having two times the "nearly" same test
is also unreadable.
I choose to drop xfrm_default_allow() to remove the negation in
xfrm_lookup_with_ifid():

-           !xfrm_default_allow(net, dir)) {
+           net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {


What about:

static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
                                         int dir)
{
        if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
                return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;

        return false;
}

...
static inline int __xfrm_policy_check2(struct sock *sk, int dir,
...
        return __xfrm_check_nopolicy(net, skb, dir) ||
               (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
               __xfrm_policy_check(sk, ndir, skb, family);

> 
>>  
>>  static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb, unsigned short family)
>> @@ -1162,13 +1143,10 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
>>  {
>>  	struct net *net = dev_net(skb->dev);
>>  
>> -	if (xfrm_default_allow(net, XFRM_POLICY_FWD))
>> -		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
>> -			(skb_dst(skb)->flags & DST_NOXFRM) ||
>> -			__xfrm_route_forward(skb, family);
>> -	else
>> -		return (skb_dst(skb)->flags & DST_NOXFRM) ||
>> -			__xfrm_route_forward(skb, family);
>> +	return (net->xfrm.policy_default[XFRM_POLICY_FWD] == XFRM_USERPOLICY_ACCEPT &&
>> +		!net->xfrm.policy_count[XFRM_POLICY_OUT]) ||
>> +	       (skb_dst(skb)->flags & DST_NOXFRM) ||
>> +	       __xfrm_route_forward(skb, family);
> 
> Ditto.
> 
> Thanks
> 
