Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7F463CA5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbhK3RWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244730AbhK3RWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:22:15 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4EBC061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:18:56 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so6904079ooj.5
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3D35X6yq1eDx7eB2cDDH7dMtHdSFBeWr5TrxZynNAhQ=;
        b=MdF6X+kY/kk2jllDobGXUwbDLkVq/2p9aBPfuDdbIq3FB5AO1KhT3dVfIvSJkkUjw4
         UNR8x7aHE/SXLFt9zm1N426/yDaMB0D6iJSKopyT12WNgLldTZXWr1yn2+MlNlK0JsKK
         Yu3cg+uacvOAt/LFwtTjHfDuA7PHstlf66zAXVF65B1cqkttSXwsCA5XTY+hxvNKBeEL
         ylDuGR3Hl7siq3oNYeh0neWALOsZmQb1AICX/VfT+zCzug/egZW6OM8eP0sb0llGJYAv
         EIv711lcfhl9oEnPr957LcnhQZYazpSiCKdaUgbxgEZj4E7IahvDuOR8ldGl+R3jDyr/
         D2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3D35X6yq1eDx7eB2cDDH7dMtHdSFBeWr5TrxZynNAhQ=;
        b=PihKTws0Hy5jdHDDnfB7ElkfmoMwKatwvZEJ8AmMCNnf1oMGZ7cImpeC/mHqgBRCZA
         8pAazhX8cDRElya4TG1YR0Vi/LMrDqjUJ58EQ9IwKXwQwKnfIwv3RgNxte95FeRwttlI
         lzOgXzZwtRg0VqZLJHA5EmRh3SrVfz0iX+/n77oReQH1eEWZNh8q/lTYer6r61VVor6B
         Qd8eOoKgxD2Z6SAFCk/AV+5x3+5MG36fW+vC4SEq92/dC6borGQAjsOHY75wOcN4rB5F
         nD3wzdkRYlbNYJ2EgSknVRYsknDEGTpEB44EvS1tTRUU0SRQQLhn6crW3lNPn4tje7If
         +nag==
X-Gm-Message-State: AOAM5335g7MS0o4G+LnxdbHt0js/b2bS1grIwydah+97ECqLB9cGfVMm
        6SvAJnZhNFXqOZiOmKzUz9c=
X-Google-Smtp-Source: ABdhPJw/dzkmDv5PoS08dtVg3ZGpnPPc0ZJhDtyEKOywDLATa17Otq5pGRT8/QMQe809kvlhRmUOeg==
X-Received: by 2002:a4a:c890:: with SMTP id t16mr313381ooq.95.1638292734515;
        Tue, 30 Nov 2021 09:18:54 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o6sm2873189oou.41.2021.11.30.09.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:18:54 -0800 (PST)
Message-ID: <55c48e77-439c-9f0c-f51e-7e944e9b5c1e@gmail.com>
Date:   Tue, 30 Nov 2021 10:18:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean after
 itself on error
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20211129141151.490533-1-razor@blackwall.org>
 <YaYbusXHbVQUXpmB@shredder> <0243bb47-4b5f-a1d7-ff63-adcb6504df8a@gmail.com>
 <3af9d2b1-4c18-1e11-aecd-9625be186bb1@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <3af9d2b1-4c18-1e11-aecd-9625be186bb1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 9:45 AM, Nikolay Aleksandrov wrote:
> On 30/11/2021 18:01, David Ahern wrote:
>> On 11/30/21 5:40 AM, Ido Schimmel wrote:
>>> On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
>>>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>>>> index 5dbd4b5505eb..a7debafe8b90 100644
>>>> --- a/net/ipv4/nexthop.c
>>>> +++ b/net/ipv4/nexthop.c
>>>> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>>>  	/* sets nh_dev if successful */
>>>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>>>  				      extack);
>>>> -	if (err) {
>>>> -		/* IPv6 is not enabled, don't call fib6_nh_release */
>>>> -		if (err == -EAFNOSUPPORT)
>>>> -			goto out;
>>>> -		ipv6_stub->fib6_nh_release(fib6_nh);
>>>> -	} else {
>>>> +	if (!err)
>>>>  		nh->nh_flags = fib6_nh->fib_nh_flags;
>>>> -	}
>>>>  out:
>>>>  	return err;
>>>>  }
>>>
>>> This hunk looks good
>>
>> agreed, but it should be a no-op now so this should be a net-next
>> cleanup patch.
>>
> 
> Actually it is needed, it's not a cleanup or noop. If fib6_nh_init fails after fib_nh_common_init
> in the per-cpu allocation then fib6_nh->nh_common's pointers will still be there but
> freed, so it will lead to double free. We have to NULL them when freeing if we want to avoid that.

fib6_nh_init should do proper cleanup if it hits an error. Your bug fix
to get nhc_pcpu_rth_output freed should complete that. It can also set
the value to NULL to avoid double free on any code path.


> 
>>>
>>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>>> index 42d60c76d30a..2107b13cc9ab 100644
>>>> --- a/net/ipv6/route.c
>>>> +++ b/net/ipv6/route.c
>>>> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>>>>  		in6_dev_put(idev);
>>>>  
>>>>  	if (err) {
>>>> -		lwtstate_put(fib6_nh->fib_nh_lws);
>>>> +		/* check if we failed after fib_nh_common_init() was called */
>>>> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
>>>> +			fib_nh_common_release(&fib6_nh->nh_common);
>>>>  		fib6_nh->fib_nh_lws = NULL;
>>>>  		dev_put(dev);
>>>>  	}
>>>
>>> Likewise
>>
>> this is a leak in the current code and should go through -net as a
>> separate patch.
>>
> 
> Yep, this is the point of this patch. :)
> 
>>>
>>>> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>  	} else {
>>>>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>>>>  		if (err)
>>>> -			goto out;
>>>> +			goto out_free;
>>>>  
>>>>  		fib6_nh = rt->fib6_nh;
>>>>  
>>>> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>>>>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>>>>  			err = -EINVAL;
>>>> -			goto out;
>>>> +			goto out_free;
>>>>  		}
>>>>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>>>>  		rt->fib6_prefsrc.plen = 128;
>>>> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>>>  		rt->fib6_prefsrc.plen = 0;
>>>>  
>>>>  	return rt;
>>>> -out:
>>>> -	fib6_info_release(rt);
>>>> -	return ERR_PTR(err);
>>>> +
>>>>  out_free:
>>>>  	ip_fib_metrics_put(rt->fib6_metrics);
>>>> +	if (rt->nh)
>>>> +		nexthop_put(rt->nh);
>>>
>>> Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
>>> called after ip_fib_metrics_init() ?
>>>
>>> Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
>>> and we failed later?
>>
>> similarly I think this cleanup is a separate patch.
>>
> 
> Same thing, fib6_info_destroy_rcu -> fib6_nh_release would double-free the nh_common parts
> if fib6_nh_init fails in the per-cpu allocation after fib_nh_common_init.
> It is not a cleanup, but a result of the fix. If we want to keep it, we'll have to NULL
> the nh_common parts when freeing them in fib_nh_common_release().

exactly. set it to NULL and make the -net patch as simple as possible

