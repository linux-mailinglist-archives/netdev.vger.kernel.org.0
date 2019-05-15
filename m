Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594711F985
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfEORps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:45:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35891 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEORpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:45:46 -0400
Received: by mail-io1-f66.google.com with SMTP id e19so291080iob.3
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6J1ELvk6RCiACcAhAbpzwZwTeblznADhX/W51PlmQh0=;
        b=S8YeOkR29KRPvYqAN1lrTBfM+81gB7WgAwjRLobDZ2b+ha22qt5G/l/nkM339QndBO
         +EE/RTn0ejivDkP16OaZ184ZWMa79R0fEHi5fHrGy5+09tvjPtGzk4t9UurXcRihlEzm
         jcCSpEfWngahhdXRJGH8NXHddgDEnHddr9hcxwAWSeXtZm5Ue1jrTP3KMlEiZJY757Q5
         gW3fVqBlLF04H58oiF3H5CKbI5x4p6NIXlL4daYOBfoqwYlU9dSQR9HGimf6b/Ir070G
         d1c2d5lmUEG+z2KQJZfvA1ODcIS7HkuVAtOPZVd/IdkJgv4i0jLx4Lda36fN8fUIQrvF
         CHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6J1ELvk6RCiACcAhAbpzwZwTeblznADhX/W51PlmQh0=;
        b=oqOudIghgiag673v+CTFuw6uN6mBoKle/qP+NWbSbJX+hnBe/xDc0HhdDJj0M2eYlk
         k84/upwA/hD39IgnovJEt6k+ygnFzbYaCk/8Qc5J1sz5RoZZxpM3BVCMlJdM7V1kcnzE
         C4axIMLkI+gmCBZIzFdm4Yz7N59BVIZSybE8WEVPkqm+W8Bc5XHlSGdlMcSIWtYXUWsy
         6tBlDsUrDhQp7Po/su9W89PexN+T/nLxdjOxOU/ziYWwZjdy6LYroumLwMPCzgBCIB2d
         1k5wfBXEAJyTtJ0sPBKtF0nrGafD16eYy/bf45vB4pEMCMJjyaXip11K9WZtwRN2UxuW
         CagQ==
X-Gm-Message-State: APjAAAUfWWzFhBNyLHa0It9PfMCc3VriX2FXNGiHMzEXH9SwqIHuSioF
        e6pLwLcfzIOcjS5yRaAL/uziWb+Pc6yGkYX2MpN9WSfWBJMHFA==
X-Google-Smtp-Source: APXvYqyZrtVDknhaFhwDWCy3ekqG2eJ6C6ywNQd1PctpO+UrRAKiaLveFrgq6vfOJApHCpXnXHa9+bOiCkaEgF8FHUo=
X-Received: by 2002:a6b:d81a:: with SMTP id y26mr27913968iob.122.1557942345307;
 Wed, 15 May 2019 10:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190515004610.102519-1-tracywwnj@gmail.com> <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
 <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com> <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
 <CAEA6p_D0-dT4a-wqz7DMq8dSNbESRkj40ESTTxdnbPar-0N90g@mail.gmail.com> <a1fa84e7-e474-9488-ddc5-e139ab1f2e05@gmail.com>
In-Reply-To: <a1fa84e7-e474-9488-ddc5-e139ab1f2e05@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 10:45:34 -0700
Message-ID: <CAEA6p_ATUB_tXY12FFFnw0HFAdJzo0VVsdBzN_AL4KGVc9gVVw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Wed, May 15, 2019 at 10:33 AM
To: Wei Wang
Cc: Wei Wang, David Miller, Linux Kernel Network Developers, Martin
KaFai Lau, Mikael Magnusson, Eric Dumazet

> On 5/15/19 11:28 AM, Wei Wang wrote:
> > From: Wei Wang <weiwan@google.com>
> > Date: Wed, May 15, 2019 at 10:25 AM
> > To: David Ahern
> > Cc: Wei Wang, David Miller, Linux Kernel Network Developers, Martin
> > KaFai Lau, Mikael Magnusson, Eric Dumazet
> >
> >>>
> >>> What about rt6_remove_exception_rt?
> >>>
> >>> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> >>> and verify that it works. I seem to have misplaced my patch to do it.
> >> I don't think rt6_remove_exception_rt() needs any change.
> >> It is because it gets the route cache rt6_info as the input parameter,
> >> not specific saddr or daddr from a flow or a packet.
> >> It is guaranteed that the hash used in the exception table is
> >> generated from rt6_info->rt6i_dst and rt6_info->rt6i_src.
> >>
> >> For the case where user tries to delete a cache route, ip6_route_del()
> >> calls rt6_find_cached_rt() to find the cached route first. And
> >> rt6_find_cached_rt() is taken care of to find the cached route
> >> according to both passed in src addr and f6i->fib6_src.
> >> So I think we are good here.
> >>
> >> From: David Ahern <dsahern@gmail.com>
> >> Date: Wed, May 15, 2019 at 9:38 AM
> >> To: Wei Wang, David Miller, <netdev@vger.kernel.org>
> >> Cc: Martin KaFai Lau, Wei Wang, Mikael Magnusson, Eric Dumazet
> >>
> >>> On 5/15/19 9:56 AM, David Ahern wrote:
> >>>> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
> >>>> and verify that it works. I seem to have misplaced my patch to do it.
> >>>
> >>> found it.
> >
> > Thanks. I patched it to iproute2 and tried it.
> > The route cache is removed by doing:
> > ip netns exec a ./ip -6 route del fd01::c from fd00::a cache
> >
>
> you have to pass in a device. The first line in ip6_del_cached_rt:
>
> if (cfg->fc_ifindex && rt->dst.dev->ifindex != cfg->fc_ifindex)
>                 goto out;
>
> 'ip route get' is one way to check if it has been deleted. We really
> need to add support for dumping exception routes.

Without passing in dev, fc_ifindex = 0. So it won't goto out. Isn't it?
The way I checked if the route cache is being removed is by doing:
ip netns exec a cat /proc/net/rt6_stats
The 5th counter is the number of cached routes right now in the system.

The output I get after I run the reproducer:
# ip netns exec a cat /proc/net/rt6_stats
000b 0006 000e 0006 0001 0005 0000
# ip netns exec a ./ip -6 route del fd01::c from fd00::/64 cache
# ip netns exec a cat /proc/net/rt6_stats
000b 0006 0012 0006 0000 0004 0000

The same behavior if I pass in dev:
# ip netns exec a cat /proc/net/rt6_stats
000b 0006 000c 0006 0001 0004 0000
# ip netns exec a ./ip -6 route del fd01::c from fd00::/64 dev vethab cache
# ip netns exec a cat /proc/net/rt6_stats
000b 0006 0013 0006 0000 0003 0000
