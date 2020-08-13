Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8576C2441AE
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 01:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHMXV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMXV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 19:21:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00843C061757;
        Thu, 13 Aug 2020 16:21:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j187so6808745qke.11;
        Thu, 13 Aug 2020 16:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+u0MmkCtPZTVBw/Lv9wsCBJsbHO7QuG+ZcgJP6PkL6g=;
        b=p/iFoWE1neCsgtURO4UNUixxN+LxpI4pbMfkxCM3eupG4Z4wJUhTgTp3nrWlYcfLld
         vyLwOGjHvPYzhLvXcVHcufoCqhMYmUk4PjSsKKNVcEvIsy03mvDmThWNK7vVBQYShUSh
         EoukOvQpcUNSjK72JVMjS/pmULaR0CUfDNgRl+IFWbafIgO8a469NL8fwmFFE5nz4cy5
         v18JCCuToQJoUq2B9kJzz/G9JBFmY2Gwx38+9iTRd9YPIpXjhjvJ7EhgUdaaf+G/8AqZ
         JfVM2UdwclFGwKM3AlQYUADbjDPu3e3w1S388GDEUEaoJTBUPyfdTqAcbjQXbZcWEn2a
         vgug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+u0MmkCtPZTVBw/Lv9wsCBJsbHO7QuG+ZcgJP6PkL6g=;
        b=IxDNcFtNPhvlNPWHIgwy2j3i4FmyhYwsdO6Dsn/IBL8vP4UHqAVkJvLxkN1yf4deC0
         ZUEoqzFUt7dUnq+h4WXxhiUnN7Uv09fu6asXZOT+aVUMdSXr5IK33KIa0k2NMYG44fOR
         DINsy6f5q8hER+aJ5S7D4+kGVH1t5kkaUXqO/YK4OlK3iyTFcUYn+fI42JOxtsIqp6Sw
         j37xbYv00ap7GBQuCpm/pzIoeinuv9fJC5rEi+4KOYPk09oYi6INj740PTTBkCZ8VEdB
         fZ37uvFjgrQ2YbDAc1F6c58uwuA8ag0+ntUx0Fhi9gvIucWzht0/sKQlS01McvKZzpFc
         R67w==
X-Gm-Message-State: AOAM532K6QOgNHnaOE5qradlFMDSeWMESlF+95ejO9nIHnaO0PKE4hV+
        PaHoxdMKI/p81oCIv8zld93uXfkygSc=
X-Google-Smtp-Source: ABdhPJxoM5fKcglwbuj3m8EtbrrvHQu7lJx0oEYZ14bXwpCN4ABHBJbjUmQuKCobrIBgeiBewdpo8w==
X-Received: by 2002:a05:620a:1653:: with SMTP id c19mr6965009qko.501.1597360916877;
        Thu, 13 Aug 2020 16:21:56 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1557:417:a433:9b3f? ([2601:282:803:7700:1557:417:a433:9b3f])
        by smtp.googlemail.com with ESMTPSA id o47sm8780873qtk.19.2020.08.13.16.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 16:21:56 -0700 (PDT)
Subject: Re: [PATCH 3/3] ipv6/icmp: l3mdev: Perform icmp error route lookup on
 source device routing table
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
 <20200811195003.1812-4-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2adc1bd3-53aa-0f3e-d5e4-740d11098685@gmail.com>
Date:   Thu, 13 Aug 2020 17:21:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811195003.1812-4-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 1:50 PM, Mathieu Desnoyers wrote:
> As per RFC4443, the destination address field for ICMPv6 error messages
> is copied from the source address field of the invoking packet.
> 
> In configurations with Virtual Routing and Forwarding tables, looking up
> which routing table to use for sending ICMPv6 error messages is
> currently done by using the destination net_device.
> 
> If the source and destination interfaces are within separate VRFs, or
> one in the global routing table and the other in a VRF, looking up the
> source address of the invoking packet in the destination interface's
> routing table will fail if the destination interface's routing table
> contains no route to the invoking packet's source address.
> 
> One observable effect of this issue is that traceroute6 does not work in
> the following cases:
> 
> - Route leaking between global routing table and VRF
> - Route leaking between VRFs
> 
> Preferably use the source device routing table when sending ICMPv6 error
> messages. If no source device is set, fall-back on the destination
> device routing table.
> 
> Link: https://tools.ietf.org/html/rfc4443
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  net/ipv6/icmp.c       | 15 +++++++++++++--
>  net/ipv6/ip6_output.c |  2 --
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index a4e4912ad607..a971b58b0371 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -501,8 +501,19 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>  	if (__ipv6_addr_needs_scope_id(addr_type)) {
>  		iif = icmp6_iif(skb);
>  	} else {
> -		dst = skb_dst(skb);
> -		iif = l3mdev_master_ifindex(dst ? dst->dev : skb->dev);
> +		struct net_device *route_lookup_dev = NULL;
> +
> +		/*
> +		 * The device used for looking up which routing table to use is
> +		 * preferably the source whenever it is set, which should
> +		 * ensure the icmp error can be sent to the source host, else
> +		 * fallback on the destination device.
> +		 */
> +		if (skb->dev)
> +			route_lookup_dev = skb->dev;

top of icmp6_send there is a check that skb->dev is set.


> +		else if (skb_dst(skb))
> +			route_lookup_dev = skb_dst(skb)->dev;
> +		iif = l3mdev_master_ifindex(route_lookup_dev);
>  	}
>  
>  	/*
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index c78e67d7747f..cd623068de53 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -468,8 +468,6 @@ int ip6_forward(struct sk_buff *skb)
>  	 *	check and decrement ttl
>  	 */
>  	if (hdr->hop_limit <= 1) {
> -		/* Force OUTPUT device used as source address */
> -		skb->dev = dst->dev;

I *think* this ok. Not clear to me why the forward path would change the
skb->dev like that. Goes back to beginning of the git history.

>  		icmpv6_send(skb, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT, 0);
>  		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
>  
> 

