Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3792E8041
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgLaNuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 08:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLaNt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 08:49:59 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF8FC061573
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 05:49:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id e2so10032303plt.12
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 05:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gJeJCtATGL1TuOiC82vqYOkR9alPKtAgnkpr48hBbNs=;
        b=WEf7YNbUu410A7BDbjZUwGrgi4Qyp5K7w+r27hvendjK/679BpezHusB7t2d4dq5ZL
         myMoHbg/Qy+J9zwbUx7JeggPLkCxMQREeXizFJ8ikMT1y0ae3JxU1TSA0GiQeQ8ojmCc
         r46sVfr5M8ycQhgCWtMwF+DPTN/bANpO0rx8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gJeJCtATGL1TuOiC82vqYOkR9alPKtAgnkpr48hBbNs=;
        b=EZyk7+PwpZKuR2SGBAVIGTqUz8QS8KvfnACIIlUUQkrpwMDsCQ1PnTzpK2zTG4j/u8
         KWdYoODpbvAuHLzREZFQvnfYa4KpKuwqFhmUpxeN5ZgBW57d1203zsAC5kS319Rv2N8w
         AgDzKUp5QvhrS7ickX/nN3V5cVp+tr/bnbBJCZMxPB4krag+JDwyrAd9GlkR4/YEbdkq
         wFYIsqXF6HEo9LTeD0jqYNkQ9S8tCCfnq50M1Sz9d3WeqP9Oddh/RcC3mJ2S4T8T6Nb2
         Qrttfz6F6NKJCt+IybWJdQxZPeQ5SMiN6lKoO2dIMqfC/5SxUfKWqlQVzUeFpjdwlLEN
         JKeA==
X-Gm-Message-State: AOAM533wKedgj5OX9ko06v4xrmRsWBDmPSL2STM/CEC6mkwFKD0Cm7L/
        82pVZZvLsRDk6QFrKFsJUVVzUUuyCs/zSA==
X-Google-Smtp-Source: ABdhPJyO7KOaulmCKFC0usC8/eBm2VsXr6ZSrD9HdEIx6P2vrHQI7wDEQFD1czwD674EuDy3X+Dluw==
X-Received: by 2002:a17:90b:1a90:: with SMTP id ng16mr13385811pjb.58.1609422559011;
        Thu, 31 Dec 2020 05:49:19 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-c087-3969-64de-57a6.static.ipv6.internode.on.net. [2001:44b8:1113:6700:c087:3969:64de:57a6])
        by smtp.gmail.com with ESMTPSA id c205sm45287086pfc.160.2020.12.31.05.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 05:49:18 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Aya Levin <ayal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: Re: [PATCH net] net: ipv6: Validate GSO SKB before finish IPv6 processing
In-Reply-To: <1609331028-2566-1-git-send-email-ayal@nvidia.com>
References: <1609331028-2566-1-git-send-email-ayal@nvidia.com>
Date:   Fri, 01 Jan 2021 00:49:15 +1100
Message-ID: <87czyq13xg.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aya,

> Daniel Axtens, does this solve the issue referred in your commit?
> 8914a595110a bnx2x: disable GSO where gso_size is too big for hardware

No, because:
> Note: These cases are handled in the same manner in IPv4 output finish.
> This patch aligns the behavior of IPv6 and IPv4.
and the issue my patch addresses was hit on IPv4, not IPv6.

In my case, the issue was that a packet came in on a ibmveth interface,
GSO but with a gso_size that's very very large. Open vSwitch then
transferred it to the bnx2x interface, where the firmware promptly
paniced.

There's a nice long description at
https://patchwork.ozlabs.org/project/netdev/patch/20180111235905.10110-1-dja@axtens.net/
however the description wasn't included in the commit message.

Kind regards,
Daniel

>
> Thanks,
> Aya
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 749ad72386b2..36466f2211bd 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -125,8 +125,43 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>  	return -EINVAL;
>  }
>  
> +static int
> +ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
> +				    struct sk_buff *skb, unsigned int mtu)
> +{
> +	struct sk_buff *segs, *nskb;
> +	netdev_features_t features;
> +	int ret;
> +
> +	/* Please see corresponding comment in ip_finish_output_gso
> +	 * describing the cases where GSO segment length exceeds the
> +	 * egress MTU.
> +	 */
> +	features = netif_skb_features(skb);
> +	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
> +	if (IS_ERR_OR_NULL(segs)) {
> +		kfree_skb(skb);
> +		return -ENOMEM;
> +	}
> +
> +	consume_skb(skb);
> +
> +	skb_list_walk_safe(segs, segs, nskb) {
> +		int err;
> +
> +		skb_mark_not_on_list(segs);
> +		err = ip6_fragment(net, sk, segs, ip6_finish_output2);
> +		if (err && ret == 0)
> +			ret = err;
> +	}
> +
> +	return ret;
> +}
> +
>  static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> +	unsigned int mtu;
> +
>  #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
>  	/* Policy lookup after SNAT yielded a new policy */
>  	if (skb_dst(skb)->xfrm) {
> @@ -135,7 +170,11 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
>  	}
>  #endif
>  
> -	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
> +	mtu = ip6_skb_dst_mtu(skb);
> +	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
> +		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
> +
> +	if ((skb->len > mtu && !skb_is_gso(skb)) ||
>  	    dst_allfrag(skb_dst(skb)) ||
>  	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
>  		return ip6_fragment(net, sk, skb, ip6_finish_output2);
> -- 
> 2.14.1
