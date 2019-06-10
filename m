Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AE3AE8D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 07:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387540AbfFJFLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 01:11:47 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52144 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfFJFLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 01:11:46 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so11371888itl.1
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 22:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOXqAC3OUxQ2X7D2zGpHzwW9XLrAPZ38Ojg+xT6Jspk=;
        b=uRvxZhERim+F4sAdv+NPTnWQvL3cFvgw/fvB0XQdg6/UJM29CQHiB0ecxEv4RsxsSE
         cuhEHqvkIerQiUjqINGyXGNnW9EM3xdkxJqqPIgAFYPePwGntLDE2TMAOLjg8qGC7eKe
         s1tN95O7cK9+/VEFpMuMRiL3R8BZHpZE0tByedobkDQiuxAt7UvQA2dXWj2BJ2Ge3Jev
         B5iV0JgJ+Nu/Z/F5vWSmPHpHQDQpUXOG0JbNVFMsLKtBF3BsTCGKTfQyVHYFRDaf7ko2
         VWU2GjuJ2Mnc0fnDkqoOiVZR6jV8CWSPDHaaGV4f5is58KRpiWyzKga9HvrBWRUJJT1g
         BSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOXqAC3OUxQ2X7D2zGpHzwW9XLrAPZ38Ojg+xT6Jspk=;
        b=nInhD2OHURHUB9Tka3k48DULIGw7uagYVBx5ygObrwwQ4f7aQPQmy6qQjFHX/8kBSx
         xhPHIBIHkNgUdRjuJynMmKF9sBA/Z+fHnGvvelTkiAYxv/kyvacAqOyP2C+lZJyZKWcC
         HINCe7IqvCt9roBOI7mq9j5agRg3MgO/K+PMjEjsOjCl/mJpKc/iY+i9WCpkc92Z+z2m
         ibiGyASN5BXGC0VbKGFGAF/StFEaOZIl7Q2W2/6HKiRwUs+DFspnr6QDJwL0Jca9RO9g
         efiniwHqvROsB+crF14JyWXtmYuO9XWMdfvSNHC9N7WoQWM8p20S6ZNJQ4EVu4N3GTnE
         lY4w==
X-Gm-Message-State: APjAAAVaqCbiUWaV0x3fhCPsoTkk5naYtHYRK1qqrryTSD0ORpy8Sym2
        ekDjC4c4G4Nkz/rQGy50jg2pS91GNWv41Jq4lshvTQ==
X-Google-Smtp-Source: APXvYqyOLfG/zeq2xqNTB+jy4nkF90U2FGSlCtAGKlxtxrdLALH/DX/E8c/xf5rNWwQfCVYiegFUXfM/Wi1Oa3DRCq0=
X-Received: by 2002:a02:c918:: with SMTP id t24mr45359929jao.111.1560143505418;
 Sun, 09 Jun 2019 22:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190608215341.26592-1-dsahern@kernel.org>
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Sun, 9 Jun 2019 22:11:33 -0700
Message-ID: <CAEA6p_DgAX1sk0CM7gJ2n9hN=iUyoNqOAzMOt=_EGjF80A6sog@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/20] net: Enable nexthop objects with IPv4
 and IPv6 routes
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, Martin KaFai Lau <kafai@fb.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 8, 2019 at 2:53 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> This is the final set of the initial nexthop object work. When I
> started this idea almost 2 years ago, it took 18 seconds to inject
> 700k+ IPv4 routes with 1 hop and about 28 seconds for 4-paths. Some
> of that time was due to inefficiencies in 'ip', but most of it was
> kernel side with excessive synchronize_rcu calls in ipv4, and redundant
> processing validating a nexthop spec (device, gateway, encap). Worse,
> the time increased dramatically as the number of legs in the routes
> increased; for example, taking over 72 seconds for 16-path routes.
>
> After this set, with increased dirty memory limits (fib_sync_mem sysctl),
> an improved ip and nexthop objects a full internet fib (743,799 routes
> based on a pull in January 2019) can be pushed to the kernel in 4.3
> seconds. Even better, the time to insert is "almost" constant with
> increasing number of paths. The 'almost constant' time is due to
> expanding the nexthop definitions when generating notifications. A
> follow on patch will be sent adding a sysctl that allows an admin to
> avoid the nexthop expansion and truly get constant route insert time
> regardless of the number of paths in a route! (Useful once all programs
> used for a deployment that care about routes understand nexthop objects).
>
> To be clear, 'ip' is used for benchmarking for no other reason than
> 'ip -batch' is a trivial to use for the tests. FRR, for example, better
> manages nexthops and route changes and the way those are pushed to the
> kernel and thus will have less userspace processing times than 'ip -batch'.
>
> Patches 1-10 iterate over fib6_nh with a nexthop invoke a processing
> function per fib6_nh. Prior to nexthop objects, a fib6_info referenced
> a single fib6_nh. Multipath routes were added as separate fib6_info for
> each leg of the route and linked as siblings:
>
>     f6i -> sibling -> sibling ... -> sibling
>      |                                   |
>      +--------- multipath route ---------+
>
> With nexthop objects a single fib6_info references an external
> nexthop which may have a series of fib6_nh:
>
>      f6i ---> nexthop ---> fib6_nh
>                            ...
>                            fib6_nh
>
> making IPv6 routes similar to IPv4. The side effect is that a single
> fib6_info now indirectly references a series of fib6_nh so the code
> needs to walk each entry and call the local, per-fib6_nh processing
> function.
>
> Patches 11 and 13 wire up use of nexthops with fib entries for IPv4
> and IPv6. With these commits you can actually use nexthops with routes.
>
> Patch 12 is an optimization for IPv4 when using nexthops in the most
> predominant use case (no metrics).
>
> Patches 14 handles replace of a nexthop config.
>
> Patches 15-18 add update pmtu and redirect tests to use both old and
> new routing.
>
> Patches 19 and 20 add new tests for the nexthop infrastructure. The first
> is single nexthop is used by multiple prefixes to communicate with remote
> hosts. This is on top of the functional tests already committed. The
> second verifies multipath selection.
>
> v4
> - changed return to 'goto out' in patch 9 since the rcu_read_lock is
>   held (noticed by Wei)
>
> v3
> - removed found arg in patch 7 and changed rt6_nh_remove_exception_rt
>   to return 1 when a match is found for an exception
>
> v2
> - changed ++i to i++ in patches 1 and 14 as noticed by DaveM
> - improved commit message for patch 14 (nexthop replace)
> - removed the skip_fib argument to remove_nexthop; vestige of an
>   older design
>
> David Ahern (20):
>   nexthops: Add ipv6 helper to walk all fib6_nh in a nexthop struct
>   ipv6: Handle all fib6_nh in a nexthop in fib6_drop_pcpu_from
>   ipv6: Handle all fib6_nh in a nexthop in rt6_device_match
>   ipv6: Handle all fib6_nh in a nexthop in __find_rr_leaf
>   ipv6: Handle all fib6_nh in a nexthop in rt6_nlmsg_size
>   ipv6: Handle all fib6_nh in a nexthop in fib6_info_uses_dev
>   ipv6: Handle all fib6_nh in a nexthop in exception handling
>   ipv6: Handle all fib6_nh in a nexthop in __ip6_route_redirect
>   ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
>   ipv6: Handle all fib6_nh in a nexthop in mtu updates
>   ipv4: Allow routes to use nexthop objects
>   ipv4: Optimization for fib_info lookup with nexthops
>   ipv6: Allow routes to use nexthop objects
>   nexthops: add support for replace
>   selftests: pmtu: Move running of test into a new function
>   selftests: pmtu: Move route installs to a new function
>   selftests: pmtu: Add support for routing via nexthop objects
>   selftests: icmp_redirect: Add support for routing via nexthop objects
>   selftests: Add test with multiple prefixes using single nexthop
>   selftests: Add version of router_multipath.sh using nexthop objects
>
>  include/net/ip6_fib.h                              |   1 +
>  include/net/ip_fib.h                               |   1 +
>  include/net/nexthop.h                              |   4 +
>  net/ipv4/fib_frontend.c                            |  19 +
>  net/ipv4/fib_semantics.c                           |  86 +++-
>  net/ipv4/nexthop.c                                 | 250 ++++++++++-
>  net/ipv6/ip6_fib.c                                 |  31 +-
>  net/ipv6/route.c                                   | 458 +++++++++++++++++++--
>  .../selftests/net/fib_nexthop_multiprefix.sh       | 290 +++++++++++++
>  .../selftests/net/forwarding/router_mpath_nh.sh    | 359 ++++++++++++++++
>  tools/testing/selftests/net/icmp_redirect.sh       |  49 +++
>  tools/testing/selftests/net/pmtu.sh                | 237 ++++++++---
>  12 files changed, 1672 insertions(+), 113 deletions(-)
>  create mode 100755 tools/testing/selftests/net/fib_nexthop_multiprefix.sh
>  create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh.sh
>
> --
> 2.11.0
>

For all ipv6 patches:
Reviewed-By: Wei Wang <weiwan@google.com>
