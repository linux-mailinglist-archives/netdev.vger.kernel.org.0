Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2151E1CB
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392542AbiEFW3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444734AbiEFW32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:29:28 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7092186FA
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:25:43 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2f16645872fso95656887b3.4
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 15:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bn9ohfbuWM94CvSDm1P8NTHtynHtad/rYydlD+/Yb3o=;
        b=pxXG/C3rJmSdiutx8YuOkvhuCsCqLj9iI7c/zSC0QXN1iwZoOK92hLVHweoyKlLoad
         FT58VmdfNEcPxftNq07UGjWl+Hn5bhGLLoeiu1CxUnlUyVXULYyRJ7LWZMHGbJvXaAim
         TYTAhPAmT8jd2sIrfGck6Npsbx0kyjaFK3rBJkMcs+yPo5x6mgSKMTnPxd/pNGncH9xT
         Y2VdT1PU3Wmhtt5r/dZJJHg3Qk2Nauy9DiKQvA/s5AOuARJj815bh1I3mmUdtiACJ79i
         CEVPTjNRlNhUqOsEYjE/Pe7a0I5HH65+8cXb42d+0AbCRIH7jpL8xTYZRrs1mqVZ0GfU
         zQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bn9ohfbuWM94CvSDm1P8NTHtynHtad/rYydlD+/Yb3o=;
        b=ARprJlp9DLo3kp8h84fR10iXT87kIkcaxC9GARmofy37XElX1/HFfSvXgltSK16EUB
         NpphyvqsItYpOcWjNb04nFFWfbGSGKDMyBjTk+z58CgzOoUwukTEx8KPPWEQLVhJYqk8
         SXEEeRv9UksEKbw8Q+PEl2pX6s63SWbdVIUtk5N70bSwrx7VxUd4mfggLLgFQqVbnqPH
         KvJbTozn/WduOvXhFpwffuFAVdRzkUXWs9NQH53CIj0JnMQ1k7QjcPpLPhPNKl61CWxL
         GRuItJryNamou+dtqCAdjfP8QbeidyE49JTJsOFLzEcHeUTxzpcDUseLTlQf56O2ypBV
         RTHw==
X-Gm-Message-State: AOAM533OcEJRAY0r8pnxahbE9412kih1smMI5qDb1KgPOO1fUew2JLkw
        4FTmhowbDIiceeyyO0atOQrTPtECu1BOzA6pYtFo5w==
X-Google-Smtp-Source: ABdhPJwRWJ7O4gnNqvKiAQRtlII7JL5ITCzBYzzLfqDhC/734jd5DOaJJxg0Rm1nbWX5OY7gQqEO+X7S1T9j19YtLbQ=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr4376367ywb.255.1651875942642; Fri, 06
 May 2022 15:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
 <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
 <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
 <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com> <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com>
In-Reply-To: <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 15:25:31 -0700
Message-ID: <CANn89iJ5CqL2Q-xwLbZrZXM+tP_3hH4j-TR9eVtrKGeuqztkwg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 3:16 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, May 6, 2022 at 2:50 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, May 6, 2022 at 2:37 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, May 6, 2022 at 2:20 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, May 6, 2022 at 1:48 PM Alexander H Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > > > > From: Coco Li <lixiaoyan@google.com>
> > > > > >
> > > > > > This enables ipv6/TCP stacks to build TSO packets bigger than
> > > > > > 64KB if the driver is LSOv2 compatible.
> > > > > >
> > > > > > This patch introduces new variable gso_ipv6_max_size
> > > > > > that is modifiable through ip link.
> > > > > >
> > > > > > ip link set dev eth0 gso_ipv6_max_size 185000
> > > > > >
> > > > > > User input is capped by driver limit (tso_max_size)
> > > > > >
> > > > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > >
> > > > > So I am still not a fan of adding all this extra tooling to make an
> > > > > attribute that is just being applied to one protocol. Why not just
> > > > > allow gso_max_size to extend beyond 64K and only limit it by
> > > > > tso_max_size?
> > > >
> > > > Answer is easy, and documented in our paper. Please read it.
> > >
> > > I have read it.
> > >
> > > > We do not want to enable BIG TCP for IPv4, this breaks user space badly.
> > > >
> > > > I do not want to break tcpdump just because some people think TCP just works.
> > >
> > > The changes I suggested don't enable it for IPv4. What your current
> > > code is doing now is using dev->gso_max_size and if it is the correct
> > > IPv6 type you are using dev->gso_ipv6_max_size. What I am saying is
> > > that instead of adding yet another netdev control you should just make
> > > it so that we retain existing behavior when gso_max_size is less than
> > > GSO_MAX_SIZE, and when it exceeds it all non-ipv6 types max out at
> > > GSO_MAX_SIZE and only the ipv6 type packets use gso_max_size when you
> > > exceed GSO_MAX_SIZE.
> >
> > gso_max_size can not exceed GSO_MAX_SIZE.
> > This will break many drivers.
> > I do not want to change hundreds of them.
>
> Most drivers will not be impacted because they cannot exceed
> tso_max_size. The tso_max_size is the limit, not GSO_MAX_SIZE. Last I
> knew this patch set is overwriting that value to increase it beyond
> the legacy limits.
>
> Right now the check is:
> if (max_size > GSO_MAX_SIZE || || max_size > dev->tso_max_size)
>

This is Jakub patch, already merged. Nothing to do with BIG TCP ?


> What I am suggesting is that tso_max_size be used as the only limit,
> which is already defaulted to cap out at TSO_LEGACY_MAX_SIZE. So just
> remove the "max_size > GSO_MAX_SIZE ||" portion of the call. Then when
> you call netif_set_tso_max_size in the driver to enable jumbograms you
> are good to set gso_max_size to something larger than the standard
> 65536.

Again, this was Jakub patch, right ?

>
> > Look, we chose this implementation so that chances of breaking things
> > are very small.
> > I understand this is frustrating, but I suggest you take the
> > responsibility of breaking things,
> > and not add this on us.
>
> What I have been trying to point out is your patch set will break things.
>

Can you give a concrete example ?

> For all those cases out there where people are using gso_max_size to
> limit things you just poked a hole in that for IPv6 cases. What I am
> suggesting is that we don't do that as it will be likely to trigger a
> number of problems for people.

No, because legacy drivers won't  use BIG TCP.

dev->tso_max_size will be <= 65536 for them.

Look at netif_set_gso_ipv6_max_size() logic.

>
> The primary reason gso_max_size was added was because there are cases
> out there where doing too big of a TSO was breaking things. For
> devices that are being used for LSOv2 I highly doubt they need to
> worry about cases less than 65536. As such they can just max out at
> 65536 for all non-IPv6 traffic and instead use gso_max_size as the
> limit for the IPv6/TSO case.

I think we disagree completely.
