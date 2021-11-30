Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C95463ADA
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243244AbhK3QEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243070AbhK3QEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:04:53 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975F3C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:01:33 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so30803019otv.9
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VlTLtH4niv/6nWTR4PKPPeVcjW0qeRR4xNqpzMOVBfQ=;
        b=HehAJaCx3Kl2ppAtOZqirHKKBr9xwbJnRS2Dzw0G4axqt+2CRF429QO7p3wrps8xyM
         VM3k9nlWqMsIrvv7H4YzaeHNoijgnyIkBZqSGDDOvfGuwDearmbdSOWKzrEkLPivTn1q
         xjPet5PGeCNp7nEjuFWA7iuTTIrzRSXHDaHW7qWfx/mW+NG0aHh6uaP1WsWScGAxM/ua
         4vhVz+RlDxkSw1N+9zw+AjpYZjFPw5BUYLImWEQUc2ohylWSYmLK2YpTLMXaXXOYkiuO
         XGkh3UWR0ProBD1wbZppmzhdCz7OcP8l0ODrEV9UzWpk8ZGIv5/ElsUA0UKZz7KMC4iY
         Mbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VlTLtH4niv/6nWTR4PKPPeVcjW0qeRR4xNqpzMOVBfQ=;
        b=2Pe5R+yrhVFL/CpOKmgetPJBFsms8HWkzqX38w7zpVMk6T8CQeH2E8It3NGOaYSWGF
         mO427lnT9HByXyhSWlFP1aG6LaOy9TjvWj/SkGCbeSM7SJ1zvOZFamQ0+/M20tNGPPbf
         el3/tH1Cx56+Bmtw54PwOhMpqH2X1atvWLx50gqm44nAU5pT0VV/5lg1wa/pu8SeqpTu
         U7veneVNTvkTrp96KyaeAb3chCoMrKv7PUGteyhqWGUSCxmZG4HskQfpmPlicuDb2z+T
         8PbmKRtxvdp2s+yg4knG6N5N/5LvDSwAjEJRdSbCpgFWyiv0eWTOLDxAIqSdp8+PIG64
         USAg==
X-Gm-Message-State: AOAM531Y5eN66e5/+uKEn9b+Y/4ckCMYEMmYzJ98Ez1Zn1JHkRd0Mjfb
        E2y2Zs1RiuHswQ0FVzGe+Hk=
X-Google-Smtp-Source: ABdhPJxRUtHG8QBWZBVF8kqGG3g/78S5+Tk4ek1quanhXfM47tHJZj4lsKBmK1V0nmanLx4wEoyq9A==
X-Received: by 2002:a9d:19c1:: with SMTP id k59mr123520otk.348.1638288092849;
        Tue, 30 Nov 2021 08:01:32 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x17sm2830574oot.30.2021.11.30.08.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 08:01:32 -0800 (PST)
Message-ID: <0243bb47-4b5f-a1d7-ff63-adcb6504df8a@gmail.com>
Date:   Tue, 30 Nov 2021 09:01:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean after
 itself on error
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20211129141151.490533-1-razor@blackwall.org>
 <YaYbusXHbVQUXpmB@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YaYbusXHbVQUXpmB@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 5:40 AM, Ido Schimmel wrote:
> On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index 5dbd4b5505eb..a7debafe8b90 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>  	/* sets nh_dev if successful */
>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>  				      extack);
>> -	if (err) {
>> -		/* IPv6 is not enabled, don't call fib6_nh_release */
>> -		if (err == -EAFNOSUPPORT)
>> -			goto out;
>> -		ipv6_stub->fib6_nh_release(fib6_nh);
>> -	} else {
>> +	if (!err)
>>  		nh->nh_flags = fib6_nh->fib_nh_flags;
>> -	}
>>  out:
>>  	return err;
>>  }
> 
> This hunk looks good

agreed, but it should be a no-op now so this should be a net-next
cleanup patch.

> 
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index 42d60c76d30a..2107b13cc9ab 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>>  		in6_dev_put(idev);
>>  
>>  	if (err) {
>> -		lwtstate_put(fib6_nh->fib_nh_lws);
>> +		/* check if we failed after fib_nh_common_init() was called */
>> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
>> +			fib_nh_common_release(&fib6_nh->nh_common);
>>  		fib6_nh->fib_nh_lws = NULL;
>>  		dev_put(dev);
>>  	}
> 
> Likewise

this is a leak in the current code and should go through -net as a
separate patch.

> 
>> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  	} else {
>>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>>  		if (err)
>> -			goto out;
>> +			goto out_free;
>>  
>>  		fib6_nh = rt->fib6_nh;
>>  
>> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>>  			err = -EINVAL;
>> -			goto out;
>> +			goto out_free;
>>  		}
>>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>>  		rt->fib6_prefsrc.plen = 128;
>> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>>  		rt->fib6_prefsrc.plen = 0;
>>  
>>  	return rt;
>> -out:
>> -	fib6_info_release(rt);
>> -	return ERR_PTR(err);
>> +
>>  out_free:
>>  	ip_fib_metrics_put(rt->fib6_metrics);
>> +	if (rt->nh)
>> +		nexthop_put(rt->nh);
> 
> Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
> called after ip_fib_metrics_init() ?
> 
> Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
> and we failed later?

similarly I think this cleanup is a separate patch.


> 
>>  	kfree(rt);
>> +out:
>>  	return ERR_PTR(err);
>>  }
>>  
>> -- 
>> 2.31.1
>>

