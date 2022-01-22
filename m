Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BF9496CF9
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 17:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiAVQzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 11:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAVQzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 11:55:23 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E0C06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 08:55:23 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id z19so14537525ioj.1
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 08:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8VBJxVfJsQ71WEPZ6sAN5kY18ARx5JzfNuMeJR8MBq4=;
        b=GI1H5yG3mFC8ctiHuBg6Lbs4lSjs9XW2Roh1VFUKGpGedAEJO5zwCQ5JQxmDwt5O8i
         HY2pjxdvDeLoIbp5AesWnL/lfhfcXRtchEigGv9cKUiQ7OPCkTc9wO7a4v4/NDAx6jUE
         jCwC/cGoRfB85lRduunVmI79oBUON5h8xnUo/3Lbz649lvYqyNTKpKCtzZcRPpBzw0YI
         wuJwbbjZZ5ZYxiQh70zkOvW0q4mzh76Uyf3B+dF6J063mGIySSogJXWbm0bNbhfluqBJ
         U4zjlA5c/dOcCTimDPSqcF8VBn/OtLzehnPYW4yW9OZd4zmKS/bnb+xqeOxjiAOTFz9G
         hsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8VBJxVfJsQ71WEPZ6sAN5kY18ARx5JzfNuMeJR8MBq4=;
        b=Ax2APB3ThfzjhFQeVf6Df7ob/ZsCEU5nHROUej1jW1vuDaD1Ol70Lu2G2i99LUv4+u
         je7YB4gfGBD0aVoYHImP7k11KelbxSLAvB2WkFYCfrNjlIIzQ6V7aoHJZTwfRGSpgVo/
         Uu43zVEPls/bm+GoZYKgG11DNob13812abEDHmC/YWzjmoB1C/8fGzA2hBrFOJfmtWIN
         8pqptvC60OL1BIBKou8BuRKa2JLY6+9EPc35XIEMVA6dIXgpteuR7GBUuEOvEw0h5Nx8
         wlbccCWa17+d3Ta84hg4H+/W1sq8/9KPHJjB+fTb7r1jZuNxkUBAWG1R4Hd1LcCwEC8e
         hEuw==
X-Gm-Message-State: AOAM533cfziBGhZPJ59GWB4a9TCad/D9vGC3h7CwVQ2hestb9JxRy34y
        PCwFNb+L/nED0qS6ov86Axk=
X-Google-Smtp-Source: ABdhPJxwTkl4vsxUyTOB419uwrex8hbpxcon+R9E2Hr48dOZZcwfQ/FzfTiNswVVHrX/Yfg8Y4Bhig==
X-Received: by 2002:a02:c856:: with SMTP id r22mr3702663jao.139.1642870522667;
        Sat, 22 Jan 2022 08:55:22 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:6034:5196:68ee:6be? ([2601:282:800:dc80:6034:5196:68ee:6be])
        by smtp.googlemail.com with ESMTPSA id u2sm4779346ilv.1.2022.01.22.08.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 08:55:21 -0800 (PST)
Message-ID: <ee82bed1-7033-406d-4738-cab6d0ec8fb6@gmail.com>
Date:   Sat, 22 Jan 2022 09:55:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH] ipv4: fix fnhe dump record multiplication
Content-Language: en-US
To:     Tomas Hlavacek <tmshlvck@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20220120235028.9040-1-tmshlvck@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220120235028.9040-1-tmshlvck@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Stefano and Ido ]

On 1/20/22 4:50 PM, Tomas Hlavacek wrote:
> Fix the multiplication of the FNHE records during dump: Check in
> fnhe_dump_bucket() that the dumped record destination address falls
> within the key (prefix, prefixlen) of the FIB leaf that is being dumped.
> 
> FNHE table records can be dumped multiple times to netlink on RTM_GETROUTE
> command with NLM_F_DUMP flag - either to "ip route show cache" or to any
> routing daemon. The multiplication is substantial under specific
> conditions - it can produce over 120M netlink messages in one dump.
> It happens if there is one shared struct fib_nh linked through
> struct fib_info (->fib_nh) from many leafs in FIB over struct fib_alias.
> 
> This situation can be triggered by importing a full BGP table over GRE
> tunnel. In this case there are ~800k routes that translates to ~120k leafs
> in FIB that all ulimately links the same next-hop (the other end of
> the GRE tunnel). The GRE tunnel creates one FNHE record for each
> destination IP that is routed to the tunnel because of PMTU. In my case
> I had around 1000 PMTU records after a few minutes in a lab connected to
> the public internet so the FNHE dump produced 120M records that easily
> stalled BIRD routing daemon as described here:
> http://trubka.network.cz/pipermail/bird-users/2022-January/015897.html
> (There is a work-around already committed to BIRD that removes unnecessary
> dumps of FNHE.)
> 
> Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
> ---
>  include/net/route.h |  3 ++-
>  net/ipv4/fib_trie.c |  3 ++-
>  net/ipv4/route.c    | 25 ++++++++++++++++++++++---
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/route.h b/include/net/route.h
> index 2e6c0e153e3a..066eab9c5d99 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -244,7 +244,8 @@ void rt_del_uncached_list(struct rtable *rt);
>  
>  int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
>  		       u32 table_id, struct fib_info *fi,
> -		       int *fa_index, int fa_start, unsigned int flags);
> +		       int *fa_index, int fa_start, unsigned int flags,
> +		       __be32 prefix, unsigned char prefixlen);
>  
>  static inline void ip_rt_put(struct rtable *rt)
>  {
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 8060524f4256..7a42db70f46d 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -2313,7 +2313,8 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
>  
>  		if (filter->dump_exceptions) {
>  			err = fib_dump_info_fnhe(skb, cb, tb->tb_id, fi,
> -						 &i_fa, s_fa, flags);
> +						 &i_fa, s_fa, flags, xkey,
> +						 (KEYLENGTH - fa->fa_slen));
>  			if (err < 0)
>  				goto stop;
>  		}
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 0b4103b1e622..bc882c85228d 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -3049,10 +3049,25 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  	return -EMSGSIZE;
>  }
>  
> +static int fnhe_daddr_check(__be32 daddr, struct net *net, u32 table_id,
> +			    __be32 prefix, unsigned char prefixlen)
> +{
> +	struct flowi4 fl4 = { .daddr = daddr };
> +	struct fib_table *tb = fib_get_table(net, table_id);
> +	struct fib_result res;
> +	int err = fib_table_lookup(tb, &fl4, &res, FIB_LOOKUP_NOREF);

I get the fundamental problem you want to solve. I think a fib lookup on
each nexthop exception for each leaf is a heavyweight solution this is
going to add up to significant overhead.

The fundamental problem you are trying to solve is to not walk the
exceptions for a fib_info more than once. A fib_info can be used with
many fib_entries so perhaps the solution is to walk the fib_info structs
that exist in fib_info_hash outside of the trie walk.


> +
> +	if (!err && res.prefix == prefix && res.prefixlen == prefixlen)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
>  			    struct netlink_callback *cb, u32 table_id,
>  			    struct fnhe_hash_bucket *bucket, int genid,
> -			    int *fa_index, int fa_start, unsigned int flags)
> +			    int *fa_index, int fa_start, unsigned int flags,
> +			    __be32 prefix, unsigned char prefixlen)
>  {
>  	int i;
>  
> @@ -3067,6 +3082,9 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
>  			if (*fa_index < fa_start)
>  				goto next;
>  
> +			if (!fnhe_daddr_check(fnhe->fnhe_daddr, net, table_id, prefix, prefixlen))
> +				goto next;
> +
>  			if (fnhe->fnhe_genid != genid)
>  				goto next;
>  
> @@ -3096,7 +3114,8 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
>  
>  int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
>  		       u32 table_id, struct fib_info *fi,
> -		       int *fa_index, int fa_start, unsigned int flags)
> +		       int *fa_index, int fa_start, unsigned int flags,
> +		       __be32 prefix, unsigned char prefixlen)
>  {
>  	struct net *net = sock_net(cb->skb->sk);
>  	int nhsel, genid = fnhe_genid(net);
> @@ -3115,7 +3134,7 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
>  		if (bucket)
>  			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
>  					       genid, fa_index, fa_start,
> -					       flags);
> +					       flags, prefix, prefixlen);
>  		rcu_read_unlock();
>  		if (err)
>  			return err;

