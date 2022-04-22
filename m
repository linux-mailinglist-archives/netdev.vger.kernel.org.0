Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE650C2A7
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiDVWdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDVWcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:32:13 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE952BC6BA
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:25:34 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f16645872fso98366297b3.4
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqSJXwsatBYkL9J8PckJjR5gvft6nsPUywCgVa+/O1U=;
        b=ehdmkJ1zOO7UZD23EkYHWd7tQcOqqwqb7SubhraWId/NPLrK9m6LVcLH8pGTnZAhbw
         9uZfwJyc7XfZYg9Nu9WvuyYpeIgAAFQBUmI4cvbJf+oX044HA2MbPIItuufx0JYGVlPX
         UaazbJsJpdM8U06UamVvo3DNCBwE8a0JkbTTItboCLl6cJf36vwpO0Wzlxf7r1WNUE0z
         IRVshI/x3hJvCMHUm+QS7Dvsf3SlD4n6QeTNJEnFkZbSdxWgP4KSWtqZaafEuQUKmJXR
         ESaIPTDyL7NEY7H5rt3J7SlmbDFFSJR+MWm2HASPi8GlAdi96cOBsDxCLjM65Pyy7rEa
         /WXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqSJXwsatBYkL9J8PckJjR5gvft6nsPUywCgVa+/O1U=;
        b=j/xTXrhBl3cgtFE0XkeECXYy8ub80cLsktidjovUYxg0mQaSRjMyDu0vkCRELUp0Lk
         1vzjVT5e2Cnzg1Teq2X06f5etDwEOmxshPwwlY5PlJIgQWt/8nKD3hrHOOgrq14IlCcL
         B1dADp9fazZ5hAlUdWyDzeWTrOfTB3TBw9EQMGH9QuZ0J44I7g8iRpvFevvjy8lI+Sa2
         bxn41cWE8w4jVzOO/OpGR8zN2A2ef9meveyLM1t83NXxjmuzs8KOflOCArfNr4zqEpzr
         oOfUlmbkxYwWMixIiqMPmKje7YTg1hiZF09+S4qd73mkqge0fpBp1/d8FDlz4k5ceKpd
         RFow==
X-Gm-Message-State: AOAM532XO3PJDrgTS5bttXgUZO3Q73aouqk9qu2WQS6qX+CF6BAAGgVy
        0Cf43iSPNP+J5gKI5wEwDvuBSzzq93K2yYP8CNKR9g==
X-Google-Smtp-Source: ABdhPJwVOrbgP04+S7OQjI4NnPyXIO36zUxJAaWrAp6UqbYKhRYcN3vrj1CZpdrMhwArap26lvDaP1GtTCU3QmM0mhc=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr2406973ywd.278.1650662733256; Fri, 22
 Apr 2022 14:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220421221449.1817041-1-joannelkoong@gmail.com>
 <CANn89iLw835MMj5DXw+KyX0fscb7Jw3e0nF5TW54hwqMtsekfA@mail.gmail.com> <CAJnrk1az3efAkZz9uY7U99xnWGU89Qxv4XPv0RJzWrQkB3_4_w@mail.gmail.com>
In-Reply-To: <CAJnrk1az3efAkZz9uY7U99xnWGU89Qxv4XPv0RJzWrQkB3_4_w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 14:25:22 -0700
Message-ID: <CANn89iKOkHHJ-papcMXJvq_8xSE2zXvqTfNSfGhq=Y1y_oKy6A@mail.gmail.com>
Subject: Re: [net-next v1] net: Add a second bind table hashed by port and address
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 2:07 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Thu, Apr 21, 2022 at 3:50 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Apr 21, 2022 at 3:16 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > We currently have one tcp bind table (bhash) which hashes by port
> > > number only. In the socket bind path, we check for bind conflicts by
> > > traversing the specified port's inet_bind2_bucket while holding the
> > > bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
> > >
> > > In instances where there are tons of sockets hashed to the same port
> > > at different addresses, checking for a bind conflict is time-intensive
> > > and can cause softirq cpu lockups, as well as stops new tcp connections
> > > since __inet_inherit_port() also contests for the spinlock.
> > >
> > > This patch proposes adding a second bind table, bhash2, that hashes by
> > > port and ip address. Searching the bhash2 table leads to significantly
> > > faster conflict resolution and less time holding the spinlock.
> > > When experimentally testing this on a local server, the results for how
> > > long a bind request takes were as follows:
> > >
> > > when there are ~24k sockets already bound to the port -
> > >
> > > ipv4:
> > > before - 0.002317 seconds
> > > with bhash2 - 0.000018 seconds
> > >
> > > ipv6:
> > > before - 0.002431 seconds
> > > with bhash2 - 0.000021 seconds
> >
> >
> > Hi Joanne
> >
> > Do you have a test for this ? Are you using 24k IPv6 addresses on the host ?
> >
> > I fear we add some extra code and cost for quite an unusual configuration.
> >
> > Thanks.
> >
> Hi Eric,
>
> I have a test on my local server that populates the bhash table entry
> with 24k sockets for a given port and address, and then times how long
> a bind request on that port takes.

OK, but why 24k ? Why not 24 M then ?

In this case, will a 64K hash table be big enough ?

 When populating the table entry, I
> use the same IPv6 address on the host (with SO_REUSEADDR set). At
> Facebook, there are some internal teams that submit bind requests for
> 400 vips on the same port on concurrent threads that run into softirq
> lockup issues due to the bhash table entry spinlock contention, which
> is the main motivation behind this patch.



I am pretty sure the IPv6 stack does not scale well if we have
thousands of IPv6 addresses on one netdev.
Some O(N) behavior will also trigger latency violations.

Can you share the test, in a form that can be added in linux tree ?

I mean, before today nobody was trying to have 24k listeners on a host,
so it would be nice to have a regression test for future changes in the stack.

If the goal is to deal with 400 vips, why using 24k in your changelog ?
I would rather stick to the reality, and not pretend TCP stack should
scale to 24k listeners.

I have not looked at the patch yet, I choked on the changelog for
being exaggerated.
