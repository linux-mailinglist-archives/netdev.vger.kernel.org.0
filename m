Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3736A28F693
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbgJOQ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388357AbgJOQ1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 12:27:16 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44378C061755;
        Thu, 15 Oct 2020 09:27:16 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t18so4865325ilo.12;
        Thu, 15 Oct 2020 09:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EZrB5m8bl5QVLVCvmg4jAcVTnduJtXRVFyRvpTwJT+c=;
        b=YP7xpmUsvQvu0Orj3hBKmrChJkAzl4do9csgkbzJ92h+sfiKnJuq0kKcQhRiHoCLmh
         dn4ZZzGt4awK7YurXZSropUgXmI+YddASCCdwJe0UNNGmxAI8CVJpsQkw8Q5dlVC3j1F
         f/KdpfW3BTD+/DyVx9pRHHvTEJuMa9t+7ypTxqegKl4+/+cPv7cPnUr07tGitX0ytCWh
         Bs7HD9K9Jn15LtQJRLT41dUEkfbjr07UONwNrQy7L/7B5+SA+7lGJvHQo3g5JP5l+hbH
         qv8RAHRxZ/O/XGJcixFRxKkVh3Wj1rdMf1B/5MGzOix808ZdIZjHzj9ZTyFA/oMMDlt5
         +Q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZrB5m8bl5QVLVCvmg4jAcVTnduJtXRVFyRvpTwJT+c=;
        b=rI8CwBd6N4NQL9DMSqStaMdaDSlbSr8CAkrQJtJ65EVwQk84H8zMLlNK4Rarmja7mo
         hv/2HUUVQI6+Ge2k1n3re+rddi1t1C97bIm9n7nWNzFNYxyVZNKsBbCOYPZbXny9kV3J
         9HJSI1k+Xg1/Bzeqg89QzmFas3DY6Ai1Bt9aPBqeYU071CcOsiLHuIGVo7b3LS6AWyUh
         pIETg74sP+fua/0i+1VdQ30jC6oD2NNDiDk2ZcEstQOdRgQpMs+Nfal7L35FStc541nB
         fE086+kK5KHpBjlHZHA8ld+51ptETqKm05+HBJxkHjmemfVYRUankcTx+QFNvzWKUYBW
         i3Ag==
X-Gm-Message-State: AOAM530RRv9shUmxSflWB7zd7OwPA0mwCKibRV8KYgYO3+ldAJ3V5BP7
        XLk1u14N6opFNhqEFIRnmH2WY/YPu5s=
X-Google-Smtp-Source: ABdhPJyzrblq0zv602ujTRYOwnmwF8pruLLMjQTCkT8sgfzM0udi/KzpZ1N559aczHfDwh8X2hqMjg==
X-Received: by 2002:a92:980d:: with SMTP id l13mr3621482ili.244.1602779235189;
        Thu, 15 Oct 2020 09:27:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:255f:25d3:4b48:11f7])
        by smtp.googlemail.com with ESMTPSA id z15sm3093066ioj.22.2020.10.15.09.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 09:27:13 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d5c14618-089d-5f29-7f10-11d11b0d59ab@gmail.com>
Date:   Thu, 15 Oct 2020 10:27:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160277680864.157904.8719768977907736015.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 9:46 AM, Toke Høiland-Jørgensen wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index bf5a99d803e4..980cc1363be8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3677,15 +3677,19 @@ union bpf_attr {
>   * 	Return
>   * 		The id is returned or 0 in case the id could not be retrieved.
>   *
> - * long bpf_redirect_neigh(u32 ifindex, u64 flags)
> + * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *params, int plen, u64 flags)

why not fold ifindex into params? with params and plen this should be
extensible later if needed.

A couple of nits below that caught me eye.


>   * 	Description
>   * 		Redirect the packet to another net device of index *ifindex*
>   * 		and fill in L2 addresses from neighboring subsystem. This helper
>   * 		is somewhat similar to **bpf_redirect**\ (), except that it
>   * 		populates L2 addresses as well, meaning, internally, the helper
> - * 		performs a FIB lookup based on the skb's networking header to
> - * 		get the address of the next hop and then relies on the neighbor
> - * 		lookup for the L2 address of the nexthop.
> + * 		relies on the neighbor lookup for the L2 address of the nexthop.
> + *
> + * 		The helper will perform a FIB lookup based on the skb's
> + * 		networking header to get the address of the next hop, unless
> + * 		this is supplied by the caller in the *params* argument. The
> + * 		*plen* argument indicates the len of *params* and should be set
> + * 		to 0 if *params* is NULL.
>   *
>   * 		The *flags* argument is reserved and must be 0. The helper is
>   * 		currently only supported for tc BPF program types, and enabled
> @@ -4906,6 +4910,17 @@ struct bpf_fib_lookup {
>  	__u8	dmac[6];     /* ETH_ALEN */
>  };
>  
> +struct bpf_redir_neigh {
> +	/* network family for lookup (AF_INET, AF_INET6)
> +	 */

second line for the comment is not needed.

> +	__u8	nh_family;
> +	/* network address of nexthop; skips fib lookup to find gateway */
> +	union {
> +		__be32		ipv4_nh;
> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
> +	};
> +};
> +
>  enum bpf_task_fd_type {
>  	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>  	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c5e2a1c5fd8d..d073031a3a61 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2165,12 +2165,11 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>  }
>  
>  #if IS_ENABLED(CONFIG_IPV6)
> -static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
> +static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
> +			    struct net_device *dev, const struct in6_addr *nexthop)
>  {
> -	struct dst_entry *dst = skb_dst(skb);
> -	struct net_device *dev = dst->dev;
>  	u32 hh_len = LL_RESERVED_SPACE(dev);
> -	const struct in6_addr *nexthop;
> +	struct dst_entry *dst = NULL;
>  	struct neighbour *neigh;
>  
>  	if (dev_xmit_recursion()) {
> @@ -2196,8 +2195,11 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
>  	}
>  
>  	rcu_read_lock_bh();
> -	nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
> -			      &ipv6_hdr(skb)->daddr);
> +	if (!nexthop) {
> +		dst = skb_dst(skb);
> +		nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
> +				      &ipv6_hdr(skb)->daddr);
> +	}
>  	neigh = ip_neigh_gw6(dev, nexthop);
>  	if (likely(!IS_ERR(neigh))) {
>  		int ret;
> @@ -2210,36 +2212,46 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
>  		return ret;
>  	}
>  	rcu_read_unlock_bh();
> -	IP6_INC_STATS(dev_net(dst->dev),
> -		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
> +	if (dst)
> +		IP6_INC_STATS(dev_net(dst->dev),
> +			      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
>  out_drop:
>  	kfree_skb(skb);
>  	return -ENETDOWN;
>  }
>  
> -static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
> +static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
> +				   struct bpf_nh_params *nh)
>  {
>  	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	struct in6_addr *nexthop = NULL;
>  	struct net *net = dev_net(dev);
>  	int err, ret = NET_XMIT_DROP;
> -	struct dst_entry *dst;
> -	struct flowi6 fl6 = {
> -		.flowi6_flags	= FLOWI_FLAG_ANYSRC,
> -		.flowi6_mark	= skb->mark,
> -		.flowlabel	= ip6_flowinfo(ip6h),
> -		.flowi6_oif	= dev->ifindex,
> -		.flowi6_proto	= ip6h->nexthdr,
> -		.daddr		= ip6h->daddr,
> -		.saddr		= ip6h->saddr,
> -	};
>  
> -	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
> -	if (IS_ERR(dst))
> -		goto out_drop;
> +	if (!nh->nh_family) {
> +		struct dst_entry *dst;

reverse xmas tree ordering

> +		struct flowi6 fl6 = {
> +			.flowi6_flags = FLOWI_FLAG_ANYSRC,
> +			.flowi6_mark = skb->mark,
> +			.flowlabel = ip6_flowinfo(ip6h),
> +			.flowi6_oif = dev->ifindex,
> +			.flowi6_proto = ip6h->nexthdr,
> +			.daddr = ip6h->daddr,
> +			.saddr = ip6h->saddr,
> +		};
> +
> +		dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
> +		if (IS_ERR(dst))
> +			goto out_drop;
>  
> -	skb_dst_set(skb, dst);
> +		skb_dst_set(skb, dst);
> +	} else if (nh->nh_family == AF_INET6) {
> +		nexthop = &nh->ipv6_nh;
> +	} else {
> +		goto out_drop;
> +	}
>  
> -	err = bpf_out_neigh_v6(net, skb);
> +	err = bpf_out_neigh_v6(net, skb, dev, nexthop);
>  	if (unlikely(net_xmit_eval(err)))
>  		dev->stats.tx_errors++;
>  	else


