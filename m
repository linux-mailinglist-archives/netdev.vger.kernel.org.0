Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC64F0BC
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFUWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:22:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44704 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUWV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:21:59 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so377513iob.11
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o3xNIiVFqoC5vA5k7IgEBua4kJAok6hMhe9JcbUCvuw=;
        b=Cx8ESbmxGNhcKI2RUgNKXQXglcYGI1VsASNr0eUXXbfB14hr4STx9UZc77ljnwyT5z
         ECsfWVAg5NT6RnN0z/UHbegEAZ/UZ0UYJtaBMbHUWt+T96qIWy8rFPxY3p2zscj65fwS
         9w18dGiOVgl0+g1e8y04xsoutXmCJWyiy20kWTKlEUWg9F58VQLfExp+aPBYxmNBXukj
         nuZm45PQJfQvMA748PnJPtbjuQzIyDY3FO9fqYl+UzgtCDD8QkOp7afrfIXpyjlx15OP
         yzF9HyBm0qV+fJzMXKSm6GR6jc5qje9mmPWbag2qMyelckeRQZMtQKxMSpLRKrmznqUl
         n5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o3xNIiVFqoC5vA5k7IgEBua4kJAok6hMhe9JcbUCvuw=;
        b=a9w2gxPRVcHQKw7qvbE4VDadjx4vZ7QI35C4bpHnx0Bd31UftpcJvdZHSTROAMlIhU
         Q0/ZlZXePMc6ATt4rwUmhrsENOLBbuHZKYOpP0wsaH1iYsMz8Clc3KX9HZnJZuWpIwSY
         84r5nfdBK4tfWYTdasVp6m3795LI2U0GseSqch2rZobKUTpdcCZo8r3oPYvlY8lIYied
         2oj3t+eSKypi2zNSckrTexoGYjHkhtQz8hfhID9layuzvKkbFduDhYGmLCpmveFngTN1
         zhn6miRUkHXzro0EtLwlEHPfDxDyckG4FF4CKz+Me90LZ5RF1AtQTTFKdhr9Pl6U9uxz
         IJIQ==
X-Gm-Message-State: APjAAAXavUBH3wHlhNjFQHlHeMtvP0yDNpnRkwcMqdSkCk/3//EJ30rV
        Y/AXj2qYNVs3qxhFxwYYejyDhm0F
X-Google-Smtp-Source: APXvYqxjYdZ+vXVLvAF203J6gOpNiQ3Y1bmLxrQoQ5jW2nEhkI/EaCRWlZXuxLkIqZOzVmYnds8DIg==
X-Received: by 2002:a6b:ba07:: with SMTP id k7mr95207933iof.98.1561155718789;
        Fri, 21 Jun 2019 15:21:58 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id r139sm7427772iod.61.2019.06.21.15.21.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:21:57 -0700 (PDT)
Subject: Re: [PATCH net-next v7 08/11] ipv6: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1561131177.git.sbrivio@redhat.com>
 <4af136ad187cdd167bac5effcf7e7b2932db87b9.1561131177.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ccff4f14-2ac6-50ae-f78d-5361cb4a5f34@gmail.com>
Date:   Fri, 21 Jun 2019 16:21:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <4af136ad187cdd167bac5effcf7e7b2932db87b9.1561131177.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/19 9:45 AM, Stefano Brivio wrote:
> Since commit 2b760fcf5cfb ("ipv6: hook up exception table to store dst
> cache"), route exceptions reside in a separate hash table, and won't be
> found by walking the FIB, so they won't be dumped to userspace on a
> RTM_GETROUTE message.
> 
> This causes 'ip -6 route list cache' and 'ip -6 route flush cache' to
> have no function anymore:
> 
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 539sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 536sec mtu 1500 pref medium
>  # ip -6 route list cache
>  # ip -6 route flush cache
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 520sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 519sec mtu 1500 pref medium
> 
> because iproute2 lists cached routes using RTM_GETROUTE, and flushes them
> by listing all the routes, and deleting them with RTM_DELROUTE one by one.
> 
> If cached routes are requested using the RTM_F_CLONED flag together with
> strict checking, or if no strict checking is requested (and hence we can't
> consistently apply filters), look up exceptions in the hash table
> associated with the current fib6_info in rt6_dump_route(), and, if present
> and not expired, add them to the dump.
> 
> We might be unable to dump all the entries for a given node in a single
> message, so keep track of how many entries were handled for the current
> node in fib6_walker, and skip that amount in case we start from the same
> partially dumped node.
> 
> When a partial dump restarts, as the starting node might change when
> 'sernum' changes, we have no guarantee that we need to skip the same
> amount of in-node entries. Therefore, we need two counters, and we need to
> zero the in-node counter if the node from which the dump is resumed
> differs.
> 
> Note that, with the current version of iproute2, this only fixes the
> 'ip -6 route list cache': on a flush command, iproute2 doesn't pass
> RTM_F_CLONED and, due to this inconsistency, 'ip -6 route flush cache' is
> still unable to fetch the routes to be flushed. This will be addressed in
> a patch for iproute2.
> 
> To flush cached routes, a procfs entry could be introduced instead: that's
> how it works for IPv4. We already have a rt6_flush_exception() function
> ready to be wired to it. However, this would not solve the issue for
> listing.
> 

...

> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  include/net/ip6_fib.h   |   1 +
>  include/net/ip6_route.h |   2 +-
>  net/ipv6/ip6_fib.c      |  12 ++++-
>  net/ipv6/route.c        | 114 ++++++++++++++++++++++++++++++++++++----
>  4 files changed, 116 insertions(+), 13 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


