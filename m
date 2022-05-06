Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D951E255
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444707AbiEFWUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391110AbiEFWUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:20:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98000515A6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:16:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l18so16822312ejc.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 15:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DZ80q0Udx8ffuF017hgx/19QiysSWu6qpKuVk4+OX04=;
        b=WILhT6XV0nuCY3gJH86cKx1mzYHCOUhE/qnDJGSOqsK+FoXPGGMz4otYjsbNCpg4tx
         kVLNWj17CyAkTVVf6KKqT520Mr7a6HmaOMzotcAYm65HzE7yojSg7eibvKCmeo4dYpAy
         JsiWBx02FJOJAvASfPOW9g9gnOOFVoVNu06xeYLtJ+IN8EbPAi79QMfL9SUk8N8IPbUL
         r/tVPg28/O2bq8Dwav3XcTkacCyqvHxZuFdm/ClQNxLnnN2M8vgnridYsCOZykqv2HNT
         NQdfQa1oNPLxsQW6pi3BWe5KHujhBDNlZDVgEps9RUR/ZcveHV6+HeYjEIUJ0ilOMGMc
         hNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DZ80q0Udx8ffuF017hgx/19QiysSWu6qpKuVk4+OX04=;
        b=W3YSr++dmjuP7LfMTbKOnFKkTBzrjruh21zBBjx3+mROtvZH5FmIiybRVdmHtniL2A
         YqwYE9QpNdVCujCKcoCGq35SevdQPBKQiI7iPDw60T9dwm6koxw0e1Ce77SvL+FRU1DV
         1TY3AM/+qKMmRlj2H2k6tVn3EefTroeYlvMkBCiU20DuNkk4V8pzb7qOyOpapF2iMAqR
         B/Hb3toxsd+sjZkRpMD2y6kmixjoD6ruPJSJvJGQ3fHK5mvWTue/Jf01tw/Uw1+6u3Kf
         9mr4ZYcCRXqsYdh3HbNwk4xka46xewtWti/ki82QRx4uhZFHqDwufIPpN+UilVNGcXqF
         K2lA==
X-Gm-Message-State: AOAM531bCBcSL9agOJEnuifl9SlBktRXUdrz/IuV+nSPV8bIK+YBxmWn
        iIb9yxNGKduqE39dpfL7YD87TuFQ8EcBNaOVkCc=
X-Google-Smtp-Source: ABdhPJwGDiL85gbkr96zRk5no/FMtjZZVrQGuuKK4Wq1/06UbxBx7TklPQqU1yM9RZ0jU2Ud9nBhAOAVnAta73NgE2o=
X-Received: by 2002:a17:907:3f16:b0:6f4:c54:2700 with SMTP id
 hq22-20020a1709073f1600b006f40c542700mr4995362ejc.615.1651875392854; Fri, 06
 May 2022 15:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
 <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
 <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com> <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com>
In-Reply-To: <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 May 2022 15:16:21 -0700
Message-ID: <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 2:50 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 6, 2022 at 2:37 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, May 6, 2022 at 2:20 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, May 6, 2022 at 1:48 PM Alexander H Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > > > From: Coco Li <lixiaoyan@google.com>
> > > > >
> > > > > This enables ipv6/TCP stacks to build TSO packets bigger than
> > > > > 64KB if the driver is LSOv2 compatible.
> > > > >
> > > > > This patch introduces new variable gso_ipv6_max_size
> > > > > that is modifiable through ip link.
> > > > >
> > > > > ip link set dev eth0 gso_ipv6_max_size 185000
> > > > >
> > > > > User input is capped by driver limit (tso_max_size)
> > > > >
> > > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > >
> > > > So I am still not a fan of adding all this extra tooling to make an
> > > > attribute that is just being applied to one protocol. Why not just
> > > > allow gso_max_size to extend beyond 64K and only limit it by
> > > > tso_max_size?
> > >
> > > Answer is easy, and documented in our paper. Please read it.
> >
> > I have read it.
> >
> > > We do not want to enable BIG TCP for IPv4, this breaks user space badly.
> > >
> > > I do not want to break tcpdump just because some people think TCP just works.
> >
> > The changes I suggested don't enable it for IPv4. What your current
> > code is doing now is using dev->gso_max_size and if it is the correct
> > IPv6 type you are using dev->gso_ipv6_max_size. What I am saying is
> > that instead of adding yet another netdev control you should just make
> > it so that we retain existing behavior when gso_max_size is less than
> > GSO_MAX_SIZE, and when it exceeds it all non-ipv6 types max out at
> > GSO_MAX_SIZE and only the ipv6 type packets use gso_max_size when you
> > exceed GSO_MAX_SIZE.
>
> gso_max_size can not exceed GSO_MAX_SIZE.
> This will break many drivers.
> I do not want to change hundreds of them.

Most drivers will not be impacted because they cannot exceed
tso_max_size. The tso_max_size is the limit, not GSO_MAX_SIZE. Last I
knew this patch set is overwriting that value to increase it beyond
the legacy limits.

Right now the check is:
if (max_size > GSO_MAX_SIZE || || max_size > dev->tso_max_size)

What I am suggesting is that tso_max_size be used as the only limit,
which is already defaulted to cap out at TSO_LEGACY_MAX_SIZE. So just
remove the "max_size > GSO_MAX_SIZE ||" portion of the call. Then when
you call netif_set_tso_max_size in the driver to enable jumbograms you
are good to set gso_max_size to something larger than the standard
65536.

> Look, we chose this implementation so that chances of breaking things
> are very small.
> I understand this is frustrating, but I suggest you take the
> responsibility of breaking things,
> and not add this on us.

What I have been trying to point out is your patch set will break things.

For all those cases out there where people are using gso_max_size to
limit things you just poked a hole in that for IPv6 cases. What I am
suggesting is that we don't do that as it will be likely to trigger a
number of problems for people.

The primary reason gso_max_size was added was because there are cases
out there where doing too big of a TSO was breaking things. For
devices that are being used for LSOv2 I highly doubt they need to
worry about cases less than 65536. As such they can just max out at
65536 for all non-IPv6 traffic and instead use gso_max_size as the
limit for the IPv6/TSO case.
