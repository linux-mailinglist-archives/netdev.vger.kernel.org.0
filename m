Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C883627BBD2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 06:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgI2ENE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 00:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI2END (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 00:13:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875B1C061755;
        Mon, 28 Sep 2020 21:13:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j19so809236pjl.4;
        Mon, 28 Sep 2020 21:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kzHV7kRs624uoUHo9YKEdvr1ljcLOGG/mpwSJhaxV2Y=;
        b=gktB7qtclfq93ixS190QNbfre1O3ogaFaw2zpFHbgDi9Oh/QWyncivzjfQ3fx8NaeB
         Nh+CvCn3dj94XGm5UQCeXt5qVbvXpwbzJjqWVDfNXOl/GunDCOSSPem33YjVOTDcS1kz
         yfscqK/SoK/VysYdCYVXuFA69VQwb+AF1Tu9enV2a1wGM0j91boGMv7jCfqs9/qsNhH1
         r7+Cayi9sA1a1hzmEVf/tAq3ds6oO+h6SpF5qKr4ec1Z+cPUyEgHYGxSfbp6lcwx1hfI
         gVpxvE62PgGe4vjXEwDpA/HzN3EQWGEeJQcN12v8D6UKksmlLn/BRIyhva5Ah6tXtKfS
         2OeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kzHV7kRs624uoUHo9YKEdvr1ljcLOGG/mpwSJhaxV2Y=;
        b=ClGdLMG5y7j/yCYcsinUZRzaGYs1MiofrF2nRTIm4dChttazldBX+GKXoNhHwRipUj
         I7+JuoYd6YZmVR8GfFjNK1iVxWa7X06iL+3VmQR2zomFECopGyYdcpHnnrcc6t95L07t
         RA9wz7DzpAKczgIQItoT3ddp8iNna+z4/nB+s3xijgicOfsC9TFCG1OR1vBb6u3qnSup
         rPqsRLkT92p+mZ2opT5ixOJa2bmwJGtOQzA7pAdHhDICENYW+J2U6fK5XbkDoHgBdacR
         Z4Z5LO1cY9JgFd15z/rXIpC1kMgfWBrTz8ZiNwlQ81KfZYs0OQGhhTr3qYctC7oD324w
         zzWw==
X-Gm-Message-State: AOAM530rDQkFKAZ9J7DM9x9m7mWc2pLtCdv71yCE+Y+STqYaJqZIzwRM
        r+Y2ysjgLa/QvuFiRy5vAZQ=
X-Google-Smtp-Source: ABdhPJxtiU2Pqwx2Hbj7UITZPDgH040o5avTpp21JULJ6lIMFltyLHG9hCIdkyeXZu32dM8Ujh4Idw==
X-Received: by 2002:a17:90a:c20f:: with SMTP id e15mr2048547pjt.163.1601352782880;
        Mon, 28 Sep 2020 21:13:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id l13sm3102368pgq.33.2020.09.28.21.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 21:13:02 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 3/6] bpf: add redirect_neigh helper as
 redirect drop-in
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Ahern <dsahern@kernel.org>
References: <cover.1601303057.git.daniel@iogearbox.net>
 <f4dec1d6d0fd9d79cf23bc4b54092f089e59f6b7.1601303057.git.daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e7eb6be7-2c03-0377-0712-90a3bb289594@gmail.com>
Date:   Mon, 28 Sep 2020 21:13:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f4dec1d6d0fd9d79cf23bc4b54092f089e59f6b7.1601303057.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 7:38 AM, Daniel Borkmann wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a0776e48dcc9..64c6e5ec97d7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> +static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
> +{
> +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	struct net *net = dev_net(dev);
> +	int err, ret = NET_XMIT_DROP;
> +	struct flowi6 fl6 = {
> +		.flowi6_flags	= FLOWI_FLAG_ANYSRC,
> +		.flowi6_mark	= skb->mark,
> +		.flowlabel	= ip6_flowinfo(ip6h),
> +		.flowi6_proto	= ip6h->nexthdr,
> +		.flowi6_oif	= dev->ifindex,
> +		.daddr		= ip6h->daddr,
> +		.saddr		= ip6h->saddr,
> +	};
> +	struct dst_entry *dst;
> +
> +	skb->dev = dev;

this is not needed here. You set dev in bpf_out_neigh_v6 to the dst dev.
Everything else is an error path where the skb is dropped.


> +	skb->tstamp = 0;
> +
> +	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
> +	if (IS_ERR(dst))
> +		goto out_drop;
> +
> +	skb_dst_set(skb, dst);
> +
> +	err = bpf_out_neigh_v6(net, skb);
> +	if (unlikely(net_xmit_eval(err)))
> +		dev->stats.tx_errors++;
> +	else
> +		ret = NET_XMIT_SUCCESS;
> +	goto out_xmit;
> +out_drop:
> +	dev->stats.tx_errors++;
> +	kfree_skb(skb);
> +out_xmit:
> +	return ret;
> +}
> +#else
> +static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
> +{
> +	kfree_skb(skb);
> +	return NET_XMIT_DROP;
> +}
> +#endif /* CONFIG_IPV6 */
> +
> +#if IS_ENABLED(CONFIG_INET)
> +static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct rtable *rt = container_of(dst, struct rtable, dst);
> +	struct net_device *dev = dst->dev;
> +	u32 hh_len = LL_RESERVED_SPACE(dev);
> +	struct neighbour *neigh;
> +	bool is_v6gw = false;
> +
> +	if (dev_xmit_recursion())
> +		goto out_rec;
> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {

Why is this check needed for v4 but not v6?

> +		struct sk_buff *skb2;
> +
> +		skb2 = skb_realloc_headroom(skb, hh_len);
> +		if (!skb2) {
> +			kfree_skb(skb);
> +			return -ENOMEM;
> +		}
> +		if (skb->sk)
> +			skb_set_owner_w(skb2, skb->sk);
> +		consume_skb(skb);
> +		skb = skb2;
> +	}
> +	rcu_read_lock_bh();
> +	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
> +	if (likely(!IS_ERR(neigh))) {
> +		int ret;
> +
> +		sock_confirm_neigh(skb, neigh);
> +		dev_xmit_recursion_inc();
> +		ret = neigh_output(neigh, skb, is_v6gw);
> +		dev_xmit_recursion_dec();
> +		rcu_read_unlock_bh();
> +		return ret;
> +	}
> +	rcu_read_unlock_bh();
> +out_drop:
> +	kfree_skb(skb);
> +	return -EINVAL;
> +out_rec:
> +	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
> +	goto out_drop;
> +}
> +
> +static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
> +{
> +	const struct iphdr *ip4h = ip_hdr(skb);
> +	struct net *net = dev_net(dev);
> +	int err, ret = NET_XMIT_DROP;
> +	struct flowi4 fl4 = {
> +		.flowi4_flags	= FLOWI_FLAG_ANYSRC,
> +		.flowi4_mark	= skb->mark,
> +		.flowi4_tos	= RT_TOS(ip4h->tos),

set flowi4_proto here.

> +		.flowi4_oif	= dev->ifindex,
> +		.daddr		= ip4h->daddr,
> +		.saddr		= ip4h->saddr,
> +	};
> +	struct rtable *rt;
> +
> +	skb->dev = dev;
> +	skb->tstamp = 0;
> +
> +	rt = ip_route_output_flow(net, &fl4, NULL);
> +	if (IS_ERR(rt))
> +		goto out_drop;
> +	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
> +		ip_rt_put(rt);
> +		goto out_drop;
> +	}
> +
> +	skb_dst_set(skb, &rt->dst);
> +
> +	err = bpf_out_neigh_v4(net, skb);
> +	if (unlikely(net_xmit_eval(err)))
> +		dev->stats.tx_errors++;
> +	else
> +		ret = NET_XMIT_SUCCESS;
> +	goto out_xmit;
> +out_drop:
> +	dev->stats.tx_errors++;
> +	kfree_skb(skb);
> +out_xmit:
> +	return ret;
> +}
