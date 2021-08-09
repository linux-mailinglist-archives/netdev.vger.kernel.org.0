Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B87A3E4EDA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhHIV7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhHIV7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:59:34 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3129FC061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 14:59:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so1046935wmi.1
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 14:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jb7NVtlidV/xvyeXGU9MbRDN5ZvrS047oYVuaxnSFiw=;
        b=Sd0JKjgYx40VbeVskfVvC7o2Hk2MKcrmjG5TFerTI5hLmaN10m2OBzLV2lLHroe/pg
         HJZv5OSvJsbOMhanMVs9ZZeFwKro6h+nPuJ5WSyePovBPT5/viXF92oPJtHPmLsu696h
         db33m0lDstEalti4lKE5Pq5t9z6zJhQhaaz6BtfLwLY6e2Pl3NGZPCHd9/S86loFb8Us
         Djl7mqQkjIXCJoI7QD2WEtWjU3BtaTr+BAWKNbRKuCJ3JrX1DKIczXf2n6UkRUsKJcT8
         9+pzqpXuXcaZtFA1ECiGHexB4MdbrL7YDVy5XzLQI7tzMW6WsinTWFjK2JEWqoP13AA2
         1fxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jb7NVtlidV/xvyeXGU9MbRDN5ZvrS047oYVuaxnSFiw=;
        b=Wj5GMb5PXlRRvAIyaPNpzUo9NwEhq6b9aueW2/hGhs8C2i6J6TT7bKKZyueTkmbv31
         47fcZ/inMhmnC1marnj6Wz9s23p8Gfx2Q6x2uQNPRUzWQdvXPZHA0KIdH3hKtpIJtkOF
         8BQ2kEyJb5zch5Gh2VROBsa48TsS21UXuyFPhhKp7LuIV3hnXixtUWlu9ouKptlZzdWy
         og3t9qjOJfNNiuxLTOlHlf2HV5+M5+M107Ny96gGRYWc4ezzubb/O3LEeqXsQ2i7Au8F
         KhBWnW9/nQM9gjVgzkFIVWrhMiOVZkP7Ozjyg4UpF+Uspo/h2Xnyo8E+uRZnZArxEskj
         o++w==
X-Gm-Message-State: AOAM530msOHw0szcURXUwxXbXMGBE1ZT+H+MrxAAX7PTKboPBfk1DwFy
        2/PBPXzuJhJhUalFvPKJD6Wo9PD+z9PCuoPRH9mccQ5x
X-Google-Smtp-Source: ABdhPJzQvTdNaZ/6IYOW7glgwBE0pQlCqvtQaNR9GJ0Wac5d3M5xttvQ5U0nCxPIK67ErQN2mHb2GcpGyMN77WCgxuA=
X-Received: by 2002:a05:600c:2241:: with SMTP id a1mr1176835wmm.171.1628546351668;
 Mon, 09 Aug 2021 14:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210809185314.38187-1-tom@herbertland.com> <CAK6E8=eV9KgcvXRGH1E6eK2NQGRUfpKLH4xmkyj-CjydVZfKXQ@mail.gmail.com>
In-Reply-To: <CAK6E8=eV9KgcvXRGH1E6eK2NQGRUfpKLH4xmkyj-CjydVZfKXQ@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 9 Aug 2021 14:58:34 -0700
Message-ID: <CAK6E8=eZuXbP_9Zcu81TNWmkYCBdGYHTj7gr7k7PDZg8naL9Vg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] txhash: Make hash rethink configurable
 and change the default
To:     Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        eric.dumazet@gmail.com, a.e.azimov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 2:56 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Mon, Aug 9, 2021 at 11:53 AM Tom Herbert <tom@herbertland.com> wrote:
> >
> > Alexander Azimov performed some nice analysis of the feature in Linux
> > stack where the IPv6 flow label is changed when the stack detects a
> > connection is failing. The idea of the algorithm is to try to find a
> > better path. His reults are quite impressive, and show that this form
> > of source routing can work effectively.
> >
> > Alex raised an issue in that if the server endpoint is an IP anycast
> > address, the connection might break if the flow label changes routing
> > of packets on the connection. Anycast is known to be susceptible to
> > route changes, not just those caused be flow label. The concern is that
> > flow label modulation might increases the chances that anycast
> > connections might break, especially if the rethink occurs after just
> > one RTO which is the current behavior.
> >
> > This patch set makes the rethink behavior granular and configurable.
> > It allows control of when to do the hash rethink: upon negative advice,
> > at RTO in SYN state, at RTO when not in SYN state. The behavior can
> > be configured by sysctl and by a socket option.
> >
> > This patch set the defautl rethink behavior to be to do a rethink only
> > on negative advice. This is reverts back to the original behavior of
> > the hash rethink mechanism. This less aggressive with the intent of
> Thanks for offering knobs to the txhash mechanism.
>
> Any reason why reverting the default behavior (that was changed in
> 2013) is necessary? systems now rely on this RTO tx-rehash to work
> around link failures will now have to manually re-enable it. Some
> users may have to learn from higher connection failures to eventually
> identify this kernel change.
Just to be clear: I agree we should offer knobs to change the txhash
behavior so the first parts of this set looks good to me. I am only
concerned about the default behavior reversal.

>
> > mitigating potentail breakages when anycast addresses are present.> For those users that are benefitting from changing the hash at the
> > first RTO, they would retain that behavior by setting the sysctl.
> > *** BLURB HERE ***
> >
> > Tom Herbert (3):
> >   txhash: Make rethinking txhash behavior configurable via sysctl
> >   txhash: Add socket option to control TX hash rethink behavior
> >   txhash: Change default rethink behavior to be less aggressive
> >
> >  arch/alpha/include/uapi/asm/socket.h  |  2 ++
> >  arch/mips/include/uapi/asm/socket.h   |  2 ++
> >  arch/parisc/include/uapi/asm/socket.h |  2 ++
> >  arch/sparc/include/uapi/asm/socket.h  |  3 ++-
> >  include/net/netns/core.h              |  2 ++
> >  include/net/sock.h                    | 32 +++++++++++++++++++--------
> >  include/uapi/asm-generic/socket.h     |  2 ++
> >  include/uapi/linux/socket.h           | 13 +++++++++++
> >  net/core/net_namespace.c              |  4 ++++
> >  net/core/sock.c                       | 16 ++++++++++++++
> >  net/core/sysctl_net_core.c            |  7 ++++++
> >  net/ipv4/tcp_input.c                  |  2 +-
> >  net/ipv4/tcp_timer.c                  |  5 ++++-
> >  13 files changed, 80 insertions(+), 12 deletions(-)
> >
> > --
> > 2.25.1
> >
