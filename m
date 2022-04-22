Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3410B50C4CA
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiDVXUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiDVXTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:19:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15581C94DA
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:55:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x17so16689550lfa.10
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SqUgaXhKrYSJokIccghlRxz2hY6gdbfkmjfPghr8CTs=;
        b=RySxhF5eVfKjasXSOzWuSAeXolsbPL91Kv8XHp0P6YGcSXuh8kyoF+6pEw7KHS62Wn
         whRDy5wVpgJ5stbwk+eY3w5oM/6S/+BwqxAYpGaw4eN3YGIH8Svd8OV/YIwvsgA6j2FH
         Mx8cmSB7qxVpZNU4NFXgcbsMKr7hbwg++f5cmGUTtwVCEM3e/jA0TZ+RTXKuMITDcWC4
         sOvWwLjNWq+zsefiUH1q5YK5eYhzbDePWMGE/x34qJyKYNZ/svmnnLuX2wmI6ixyNCfJ
         g6sKCUBRTzRsrVQNH6YiPe94j0Vw5NL1l8f5y7KayCshCwzswL7QCC+RWrs53NcUFsEd
         RNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SqUgaXhKrYSJokIccghlRxz2hY6gdbfkmjfPghr8CTs=;
        b=glrYIPlEFw8g3KlXcbxM1XhAVtuqyoRyBHZAKX3j5Ua+M/RrHjtzKo+frEljXfAovW
         HMxXP6Is+tKWqxS2wubW3ylaqn3oL0G6WXHRSjD/D9ESh4FLSKXnZMMIIJXjuCaI5Cb2
         UdZ4Fi5MYsthEMVVHNEIvt8xFg+ZR4+zQFQQhB7EAFjBuRaN6C9a7wsr59f9v3zt74Wh
         hMZESS7jRdMqc9mPxv9DMhiDRa+wCXv5jsp0M1otImHrVJxuk3AJtI0zUz7oQi8hJ5Cg
         oD3r7Np9ozkh8XVfqc3ezquL64ZIa463VaCX/k/fk4QgJgtL8SrtFZDCc5aeUCAkQeXK
         hirw==
X-Gm-Message-State: AOAM530vGGhC4sRn9cEQ9U2oQbWTgFZueHkgPPM8WqWeuAGfOrp6dpxN
        J/o2pUBoE1FWNK2dC1xviiGuoA2zjRptCnuUiDk=
X-Google-Smtp-Source: ABdhPJxEGxg51ZfSSbe2Dmpb/IJzTJY4Zi/zG1m9GSxivP7e5PKbAenBPTyy2jKAGSGYCC7IbbP3ca5m1VliKORGXGA=
X-Received: by 2002:ac2:420a:0:b0:448:2625:d707 with SMTP id
 y10-20020ac2420a000000b004482625d707mr4647541lfh.617.1650668123580; Fri, 22
 Apr 2022 15:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220421221449.1817041-1-joannelkoong@gmail.com>
 <CANn89iLw835MMj5DXw+KyX0fscb7Jw3e0nF5TW54hwqMtsekfA@mail.gmail.com>
 <CAJnrk1az3efAkZz9uY7U99xnWGU89Qxv4XPv0RJzWrQkB3_4_w@mail.gmail.com> <CANn89iKOkHHJ-papcMXJvq_8xSE2zXvqTfNSfGhq=Y1y_oKy6A@mail.gmail.com>
In-Reply-To: <CANn89iKOkHHJ-papcMXJvq_8xSE2zXvqTfNSfGhq=Y1y_oKy6A@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 22 Apr 2022 15:55:12 -0700
Message-ID: <CAJnrk1btHhosTt_PwW77NK1frmZ2Q8j4DYEB9+7H_VP5iocqcg@mail.gmail.com>
Subject: Re: [net-next v1] net: Add a second bind table hashed by port and address
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 2:25 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Apr 22, 2022 at 2:07 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Thu, Apr 21, 2022 at 3:50 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Thu, Apr 21, 2022 at 3:16 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > We currently have one tcp bind table (bhash) which hashes by port
> > > > number only. In the socket bind path, we check for bind conflicts by
> > > > traversing the specified port's inet_bind2_bucket while holding the
> > > > bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
> > > >
> > > > In instances where there are tons of sockets hashed to the same port
> > > > at different addresses, checking for a bind conflict is time-intensive
> > > > and can cause softirq cpu lockups, as well as stops new tcp connections
> > > > since __inet_inherit_port() also contests for the spinlock.
> > > >
> > > > This patch proposes adding a second bind table, bhash2, that hashes by
> > > > port and ip address. Searching the bhash2 table leads to significantly
> > > > faster conflict resolution and less time holding the spinlock.
> > > > When experimentally testing this on a local server, the results for how
> > > > long a bind request takes were as follows:
> > > >
> > > > when there are ~24k sockets already bound to the port -
> > > >
> > > > ipv4:
> > > > before - 0.002317 seconds
> > > > with bhash2 - 0.000018 seconds
> > > >
> > > > ipv6:
> > > > before - 0.002431 seconds
> > > > with bhash2 - 0.000021 seconds
> > >
> > >
> > > Hi Joanne
> > >
> > > Do you have a test for this ? Are you using 24k IPv6 addresses on the host ?
> > >
> > > I fear we add some extra code and cost for quite an unusual configuration.
> > >
> > > Thanks.
> > >
> > Hi Eric,
> >
> > I have a test on my local server that populates the bhash table entry
> > with 24k sockets for a given port and address, and then times how long
> > a bind request on that port takes.
>
> OK, but why 24k ? Why not 24 M then ?
>
> In this case, will a 64K hash table be big enough ?
24k was one test case scenario, another one was ~12M; these were used
to get a sense of how the bhash2 table performs in situations where
the bhash table entry for the port is saturated.
>
>  When populating the table entry, I
> > use the same IPv6 address on the host (with SO_REUSEADDR set). At
> > Facebook, there are some internal teams that submit bind requests for
> > 400 vips on the same port on concurrent threads that run into softirq
> > lockup issues due to the bhash table entry spinlock contention, which
> > is the main motivation behind this patch.
>
> I am pretty sure the IPv6 stack does not scale well if we have
> thousands of IPv6 addresses on one netdev.
> Some O(N) behavior will also trigger latency violations.
>
> Can you share the test, in a form that can be added in linux tree ?
I will include it somewhere under testing/selftests/net - does that sound okay?
>
> I mean, before today nobody was trying to have 24k listeners on a host,
> so it would be nice to have a regression test for future changes in the stack.
>
> If the goal is to deal with 400 vips, why using 24k in your changelog ?
> I would rather stick to the reality, and not pretend TCP stack should
> scale to 24k listeners.
I chose 24k to test on because one of the internal team's usages is
binding from 80 workers for ~300 vips in parallel for the same port.
>
> I have not looked at the patch yet, I choked on the changelog for
> being exaggerated.
