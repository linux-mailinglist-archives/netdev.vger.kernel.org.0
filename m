Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C4173D91
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgB1Qus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:50:48 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45886 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgB1Qus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:50:48 -0500
Received: by mail-io1-f68.google.com with SMTP id w9so4063228iob.12
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s1rSiHirhSqVf7V/F+chR2/xeTbz4ClkU+rCnEj8pEs=;
        b=MQIaG57q1uvWpVI6r0I1QkMj3DX5JfgbwN+f8118XUfmLbaT6NUeEpF8A31lEpPHGY
         WjucGnT3q2MPWppg2El+CW/vwa7+3rREzUIJt0wt/gXHxd8VEQbxLJvriN6k6WUZUDXo
         dVLLyBdGpfH6oD4vw9NDkrDtTwZSOgZLgU+Jo4SsbT3O7lB74iwaaPg+IRjCK7Zfw3Oq
         A2x6dUD/EcdNow3V3PszV9uxiXE8YPqhaEzBkFkf8QvM8bac08Pj7jOcryeJeuR45q4X
         TKa+IPhf9MU7Hp2upAGoPme5o1PeTwxLLQo5loaG5UXvKKQKELxdkUlzVs063VdK0kYv
         IAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1rSiHirhSqVf7V/F+chR2/xeTbz4ClkU+rCnEj8pEs=;
        b=i4eLkzww7oF9v58p1ZouHF661ILEiKbfRxO+LWU+Cgb9XKbsmd0yZutJC67cqM2vef
         SfLWNEh3XDqwDfRrHsP3eihWVrWrYgJ4fdupeQPNcu1gEfGd8tnHjzRJbgRC/aKIJwMH
         9qNvk9pcP00PdvZ1FGi9B7yP2u4Z1wCZBbclQndPn6r3zVYXNT6oXc9dJisZNGkbSR+k
         IJkNJkAxjZPMPqIGfhCUyWy3FN/1s8FkxGtQRXiEytJNth3mA0fIcb3IVoKTwmR3ZN6D
         Kmj71yrxP1ywVjr1vQMLxhOPGzTFD/iC43gRpsfKWINiUvniEoIDw/Wki0E06+4scgYh
         I42A==
X-Gm-Message-State: APjAAAUHX+BgsFw2mnYjG5RY3AYdk/iN9DzoiU3roUaE0Xz3vYXvNmv+
        iNoauvMObcUz/K6dHFRkgL9xfsA2
X-Google-Smtp-Source: APXvYqw4Jl6v23Fx4NUY6b6e3QHXDMgsLGIlhkXDS5hmDpC1pyKdqorvuWVbn3vGNT9t9w0m6AdIdw==
X-Received: by 2002:a02:a48e:: with SMTP id d14mr4107131jam.30.1582908647697;
        Fri, 28 Feb 2020 08:50:47 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29b4:b20:7e73:23f9? ([2601:282:803:7700:29b4:b20:7e73:23f9])
        by smtp.googlemail.com with ESMTPSA id j4sm1041347ilf.21.2020.02.28.08.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 08:50:46 -0800 (PST)
Subject: Re: [PATCH net] net/ipv6: use configured matric when add peer route
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jianlin Shi <jishi@redhat.com>, David Miller <davem@davemloft.net>
References: <20200228091858.19729-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ad3ee1d-32d2-c84d-ea8a-f4daf44b4fa1@gmail.com>
Date:   Fri, 28 Feb 2020 09:50:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228091858.19729-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/20 2:18 AM, Hangbin Liu wrote:
> When we add peer address with metric configured, IPv4 could set the dest
> metric correctly, but IPv6 do not. e.g.
> 
> ]# ip addr add 192.0.2.1 peer 192.0.2.2/32 dev eth1 metric 20
> ]# ip route show dev eth1
> 192.0.2.2 proto kernel scope link src 192.0.2.1 metric 20
> ]# ip addr add 2001:db8::1 peer 2001:db8::2/128 dev eth1 metric 20
> ]# ip -6 route show dev eth1
> 2001:db8::1 proto kernel metric 20 pref medium
> 2001:db8::2 proto kernel metric 256 pref medium
> 
> Fix this by using configured matric instead of default one.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/addrconf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index cb493e15959c..164c71c54b5c 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -5983,9 +5983,9 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
>  		if (ifp->idev->cnf.forwarding)
>  			addrconf_join_anycast(ifp);
>  		if (!ipv6_addr_any(&ifp->peer_addr))
> -			addrconf_prefix_route(&ifp->peer_addr, 128, 0,
> -					      ifp->idev->dev, 0, 0,
> -					      GFP_ATOMIC);
> +			addrconf_prefix_route(&ifp->peer_addr, 128,
> +					      ifp->rt_priority, ifp->idev->dev,
> +					      0, 0, GFP_ATOMIC);
>  		break;tools/testing/selftests/net
>  	case RTM_DELADDR:
>  		if (ifp->idev->cnf.forwarding)
> 

ugh, missed that one. Thanks for the patch. Please add the tests in the
commit message to tools/testing/selftests/net/fib_tests.sh,
ipv{4,6}_addr_metric_test sections.

Reviewed-by: David Ahern <dsahern@gmail.com>

(and s/matric/metric/ in a couple of places as noted by roopa)
