Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AA3BEA06
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhGGOsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhGGOr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:47:59 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A5FC061574;
        Wed,  7 Jul 2021 07:45:18 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l17-20020a9d6a910000b029048a51f0bc3cso2411232otq.13;
        Wed, 07 Jul 2021 07:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l2yjVW2yIL2Kx9AAHbSB/+o2sG9sPzcL8FdCAxFTJ1Q=;
        b=XELMmxjy02SH5rcjbCJ/YHPg+X81KETCjyDfrsRj2m0yKtEXsH+2NauemOuxaUWmEf
         7O4jwXwy/r+3U80e1AoERDaMLAQ9DkdLZZm+OQmZ1qVTIWjGb1s8NKOZi7+5ydwUG1nh
         F4AumC07s518MzCYNGQUKfDzjvV0vf6HIY+9nOe80nJXy0tRLixxdvbEsDok3kgP37lI
         u2U3k0dQsFAq35+ad0pj/n+UXAKYLWCWec2yezlU8WfocqHIhDAIQyhanvChFPPswnkQ
         B/HtTkAA+GOGiJKInyj0AxmOyC0U2a436fdDbuUMYFpHy2dQc425oP1yQixxLmyMIpQa
         ZHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2yjVW2yIL2Kx9AAHbSB/+o2sG9sPzcL8FdCAxFTJ1Q=;
        b=qQNXkQFlzK+uSNlmAyghHhBBKNjgk4idmmaNvx6XcHIvVq8BJlZKeVhIQ0N3WzBxRH
         /SMd5o2vX0d8iuSLUtg9Qv6mF1irB61Q5rczX6MocFhkOYR8JW7ucEJvBgnDwpWAeV8B
         ml/WAF2qiB361YqZ36/b0Rcbw+K402zhwdsEXrwWExNIo3J1VhHNlrpwjnp+Pi7Vase/
         eC0C4aLhN4MLl/d4mDa0sshPhDuqtH5KbKZpTj3v3O8DGCSQtw4AG5ynBhgWe+AwNeMc
         kGx28mtSOMfz4qqAbTHI7OKceBC2RxxFGO3NtYL3LJFWh53MxAm//oRqzDjRdhAG3XjF
         TmRA==
X-Gm-Message-State: AOAM530HNQNPOU7gntaf4gHwtZVNdp8kc7keqZ6FjoFKHYTeJ5hHHx03
        i53d2Sr1+2APk9Ekot2D+AfInqkF/DYynA==
X-Google-Smtp-Source: ABdhPJzDzzfWfJhVy9egLLp+uyUHQikgUfqXIj5njEAWFihqCUHGw5rAyQNRqZGuB8sYGV3r98mufA==
X-Received: by 2002:a05:6830:1d94:: with SMTP id y20mr5016730oti.113.1625669117962;
        Wed, 07 Jul 2021 07:45:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id b20sm1508324ots.26.2021.07.07.07.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:45:17 -0700 (PDT)
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1625665132.git.vvs@virtuozzo.com>
 <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
Date:   Wed, 7 Jul 2021 08:45:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 8:04 AM, Vasily Averin wrote:
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index ff4f9eb..e5af740 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -61,9 +61,24 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>  	struct dst_entry *dst = skb_dst(skb);
>  	struct net_device *dev = dst->dev;
>  	const struct in6_addr *nexthop;
> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
>  	struct neighbour *neigh;
>  	int ret;
>  
> +	/* Be paranoid, rather than too clever. */
> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> +		struct sk_buff *skb2;
> +
> +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));

why not use hh_len here?


> +		if (!skb2) {
> +			kfree_skb(skb);
> +			return -ENOMEM;
> +		}
> +		if (skb->sk)
> +			skb_set_owner_w(skb2, skb->sk);
> +		consume_skb(skb);
> +		skb = skb2;
> +	}
>  	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
>  		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
>  
> 

