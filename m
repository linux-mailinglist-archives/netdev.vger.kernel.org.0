Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE01F802
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfEOP4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:56:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42537 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOP4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 11:56:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id 145so1576570pgg.9
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4XXvHY/cRix8hT+gYCmCL3CrDs1ZkP++zMlkSzEZB8U=;
        b=b/QqSa/1PTvkDwLrUZfRbYiPYyhoEizEv1squTmA2A544g97TbsjUKASyzy226aE2T
         Lok6OIrD2Izx2uIO5/Oh2+MjjLvPH9uLKSWqVuSFy0BaRc/jnOiiQ04m3zwXid7vtcok
         NWYatK8ivuxzhiMAlZ4WShLIwPOVnvw9wcPNzgXSEfz3+3UzmEJtZPXv2vStmG4ewCID
         Of7TRhQzR0tm9nMS2OGl2PB2H8H81Ojo5jaJfqPPrl2Ww5d885qqahdhy1naC0GldQrb
         9NZF8ecQfMSJweIyKBBzHqeyeLTNYrZ2d2oT6nfdbOUf8G3G2l/H0R++mEjfyC8BN1fN
         P9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XXvHY/cRix8hT+gYCmCL3CrDs1ZkP++zMlkSzEZB8U=;
        b=eF1rsH/S3o35yi+xliVQNUn0Os6zd9Qzmeh853rA1uf7l46XoC0FPRCvbVdQqhel7h
         68BRsRn8P4Y5LBHgSJTrqWdGpVNXH86z9/rForVOZ1Z3iHfqDcTxdXHNdGyycFSRUSJs
         2pim5KOAilqkTwPD106Ayz0ozAMvkFg4CCnb2ifNaKjFtMMYQcgZ4DCs2BgejPUGzbat
         WozvO3tmi/pjZg7y5zyI7RHpBB2w9wLlldF4t6qX18V5Ta3l5f1k+ByTJuA9uidwJdpr
         tXnlbY1do8jJ4u2cqVo4YxmQjZZl8PX9EoUqDHPokOgIKArDgbFjSJYmzWHJ9gDPEbRx
         CpwA==
X-Gm-Message-State: APjAAAUkbeEmaNfhFGnpM1pfxXKebcQyPNjOgZcKIWti2Sa4e2k3ZsfF
        ehlKe9WTpq/STuuF5/BguP0=
X-Google-Smtp-Source: APXvYqzYEU4wnxXv/lQTmYNGuSV73FZIpXZLamA0x4wqE57bo5zDAsJrz91KGUkrub/fjx556z9lqQ==
X-Received: by 2002:a65:60c7:: with SMTP id r7mr43212667pgv.22.1557935772833;
        Wed, 15 May 2019 08:56:12 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id i194sm6070481pfe.59.2019.05.15.08.56.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 08:56:11 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
Date:   Wed, 15 May 2019 09:56:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190515004610.102519-1-tracywwnj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/19 6:46 PM, Wei Wang wrote:
> From: Wei Wang <weiwan@google.com>
> 
> When inserting route cache into the exception table, the key is
> generated with both src_addr and dest_addr with src addr routing.
> However, current logic always assumes the src_addr used to generate the
> key is a /128 host address. This is not true in the following scenarios:
> 1. When the route is a gateway route or does not have next hop.
>    (rt6_is_gw_or_nonexthop() == false)
> 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> This means, when looking for a route cache in the exception table, we
> have to do the lookup twice: first time with the passed in /128 host
> address, second time with the src_addr stored in fib6_info.
> 
> This solves the pmtu discovery issue reported by Mikael Magnusson where
> a route cache with a lower mtu info is created for a gateway route with
> src addr. However, the lookup code is not able to find this route cache.
> 
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> Bisected-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/route.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 23a20d62daac..c36900a07a78 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1574,23 +1574,36 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
>  	struct rt6_exception *rt6_ex;
>  	struct rt6_info *ret = NULL;
>  
> -	bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
> -
>  #ifdef CONFIG_IPV6_SUBTREES
>  	/* fib6i_src.plen != 0 indicates f6i is in subtree
>  	 * and exception table is indexed by a hash of
>  	 * both fib6_dst and fib6_src.
> -	 * Otherwise, the exception table is indexed by
> -	 * a hash of only fib6_dst.
> +	 * However, the src addr used to create the hash
> +	 * might not be exactly the passed in saddr which
> +	 * is a /128 addr from the flow.
> +	 * So we need to use f6i->fib6_src to redo lookup
> +	 * if the passed in saddr does not find anything.
> +	 * (See the logic in ip6_rt_cache_alloc() on how
> +	 * rt->rt6i_src is updated.)
>  	 */
>  	if (res->f6i->fib6_src.plen)
>  		src_key = saddr;
> +find_ex:
>  #endif
> +	bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
>  	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
>  
>  	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
>  		ret = rt6_ex->rt6i;
>  
> +#ifdef CONFIG_IPV6_SUBTREES
> +	/* Use fib6_src as src_key and redo lookup */
> +	if (!ret && src_key == saddr) {
> +		src_key = &res->f6i->fib6_src.addr;
> +		goto find_ex;
> +	}
> +#endif
> +
>  	return ret;
>  }
>  
> @@ -2683,12 +2696,22 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
>  #ifdef CONFIG_IPV6_SUBTREES
>  	if (f6i->fib6_src.plen)
>  		src_key = saddr;
> +find_ex:
>  #endif
> -
>  	bucket = rcu_dereference(f6i->rt6i_exception_bucket);
>  	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
>  	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
>  		mtu = dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
> +#ifdef CONFIG_IPV6_SUBTREES
> +	/* Similar logic as in rt6_find_cached_rt().
> +	 * We need to use f6i->fib6_src to redo lookup in exception
> +	 * table if saddr did not yield any result.
> +	 */
> +	else if (src_key == saddr) {
> +		src_key = &f6i->fib6_src.addr;
> +		goto find_ex;
> +	}
> +#endif
>  
>  	if (likely(!mtu)) {
>  		struct net_device *dev = nh->fib_nh_dev;
> 

What about rt6_remove_exception_rt?

You can add a 'cache' hook to ip/iproute.c to delete the cached routes
and verify that it works. I seem to have misplaced my patch to do it.
