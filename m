Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89112FEE7
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfE3PGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:06:47 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39811 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfE3PGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:06:46 -0400
Received: by mail-lj1-f194.google.com with SMTP id a10so3169806ljf.6
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 08:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k+7snSCOtSSeA9ACv/yfkDCgsbnV2rXZkDLqWcnnQ38=;
        b=Ag4RqQnc9WIHgQusRXMzycf9zPDjnbgd1FpD8ywKyG4JFxbH8KjaubjHf7cRAb1QdK
         fW3ozSqJY0MQhX3U7joohkh9CQrr61ZYf0SP5ecfutX6yOafkj4pgoclN8zJwVyphsDL
         FxIB/wMSgMUQrnX64J1M8n0n1IYm0iEs/3AIWwj1y5RXrWS7NoI/EVdGV/y0ta1ml8RC
         g+9gs3ujWHMFqthQ8bHTwl0MHlD6NyI4aCH35ZMJ0Es+1nzypzEjfd6L/TsDJJyFHbdG
         8ecoe3M/PwlsR3xOp7JSRsnnrBOUu2RM1TySdb2S4RQyTKHft/V7MUjER0bD2aJknVd6
         wDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k+7snSCOtSSeA9ACv/yfkDCgsbnV2rXZkDLqWcnnQ38=;
        b=WnOyxTgacH5v4p1/l7WHqlkhx/NFIcrKbo9neI9bow3laUlUfhN2Rfhmahmb5ojhfO
         fx9OijxQJwV88AoSRPD+Zq03O7ZOGdYUOZBklIG66qCjolkWWR2UtkE4Nj4Vmk3ADGzJ
         DPNUmqo+bHp5Oi9nC2HVrHhTQ0580uZuftl/ZHy2fJlxiw+ZSj4D+jZU5cD0Uk7SpNcG
         i6uiR1rhiSzLLXEsV2dloB2g0l6ArSszB4DxDTgmyFDxvX8wbNRh1wXd828n9xBSsi4O
         AHKqk71/RycSu9j6LLndFk1q/jOlbOFgtvInQKi5Usb4atwYo3bf14SPzydWLTfY9VGM
         mb/A==
X-Gm-Message-State: APjAAAXbhe9xy7Q63qQPFNxyPCRGkyMPLJZ4fJzSiIR1FXky3GH84v51
        Qr9CAMt1mELaLalyq9OA4r2IDsQx7iq7P8OsR/U=
X-Google-Smtp-Source: APXvYqxHNdgvYR+rUISAXzf0TMtQQ0FptjKJ2/IOQxzTay7WjK4Ict4MnEtcphSKzwfyNJQYb8xMiqXmZqcKb3zsZ0A=
X-Received: by 2002:a2e:9d09:: with SMTP id t9mr2458786lji.151.1559228804623;
 Thu, 30 May 2019 08:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030800.1683-1-dsahern@kernel.org>
In-Reply-To: <20190530030800.1683-1-dsahern@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 May 2019 08:06:32 -0700
Message-ID: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 8:10 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> This sets adds 'struct nexthop' to fib_info and fib6_info. IPv4
> already handles multiple fib_nh entries in a single fib_info, so
> the conversion to use a nexthop struct is fairly mechanical. IPv6
> using a nexthop struct with a fib6_info impacts a lot of core logic
> which is built around the assumption of a single, builtin fib6_nh
> per fib6_info. To make this easier to review, this set adds
> nexthop to fib6_info and adds checks in most places fib6_info is
> used. The next set finishes the IPv6 conversion, walking through
> the places that need to consider all fib6_nh within a nexthop struct.
>
> Offload drivers - mlx5, mlxsw and rocker - are changed to fail FIB
> entries using nexthop objects. That limitation can be removed once
> the drivers are updated to properly support separate nexthops.
>
> This set starts by adding accessors for fib_nh and fib_nhs in a
> fib_info. This makes it easier to extract the number of nexthops
> in the fib entry and a specific fib_nh once the entry references
> a struct nexthop. Patch 2 converts more of IPv4 code to use
> fib_nh_common allowing a struct nexthop to use a fib6_nh with an
> IPv4 entry.
>
> Patches 3 and 4 add 'struct nexthop' to fib{6}_info and update
> references to both take a different path when it is set. New
> exported functions are added to the nexthop code to validate a
> nexthop struct when configured for use with a fib entry. IPv4
> is allowed to use a nexthop with either v4 or v6 entries. IPv6
> is limited to v6 entries only. In both cases list_heads track
> the fib entries using a nexthop struct for fast correlation on
> events (e.g., device events or nexthop events like delete or
> replace).
>
> The last 3 patches add hooks to drivers listening for FIB
> notificationas. All 3 of them reject the routes as unsupported,
> returning an error message to the user via extack. For mlxsw
> at least this is a stop gap measure until the driver is updated for
> proper support.
>
> David Ahern (7):
>   ipv4: Use accessors for fib_info nexthop data
>   ipv4: Prepare for fib6_nh from a nexthop object
>   ipv4: Plumb support for nexthop object in a fib_info
>   ipv6: Plumb support for nexthop object in a fib6_info
>   mlxsw: Fail attempts to use routes with nexthop objects
>   mlx5: Fail attempts to use routes with nexthop objects
>   rocker: Fail attempts to use routes with nexthop objects
>
>  drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  33 ++-
>  .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  33 ++-
>  drivers/net/ethernet/rocker/rocker_main.c          |   4 +
>  drivers/net/ethernet/rocker/rocker_ofdpa.c         |  25 +-
>  include/net/ip6_fib.h                              |  11 +-
>  include/net/ip6_route.h                            |  13 +-
>  include/net/ip_fib.h                               |  25 +-
>  include/net/nexthop.h                              | 113 +++++++++
>  net/core/filter.c                                  |   3 +-
>  net/ipv4/fib_frontend.c                            |  15 +-
>  net/ipv4/fib_lookup.h                              |   1 +
>  net/ipv4/fib_rules.c                               |   8 +-
>  net/ipv4/fib_semantics.c                           | 257 ++++++++++++++-------
>  net/ipv4/fib_trie.c                                |  38 ++-
>  net/ipv4/nexthop.c                                 | 111 ++++++++-
>  net/ipv4/route.c                                   |   5 +-
>  net/ipv6/addrconf.c                                |   5 +
>  net/ipv6/ip6_fib.c                                 |  22 +-
>  net/ipv6/ndisc.c                                   |   3 +-
>  net/ipv6/route.c                                   | 156 +++++++++++--
>  20 files changed, 706 insertions(+), 175 deletions(-)

Huge number of core changes and zero tests.
Nacked-by: Alexei Starovoitov <ast@kernel.org>
