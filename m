Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A056D5278
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjDCU3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjDCU3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:29:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB64640D8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:28:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z10so18313581pgr.8
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 13:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680553676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWJlI4H4XokLtIJhlpi2UYBbO1EJFdpntQ3Q6vlWr4c=;
        b=EXTOUy2f0nbSMOCqefk/g0Gubg5EydqvYNM4kwhRH4qLwM+3ZBCx3c0BHvQfiKcUM8
         ln/YHEOffFoklmyjZKyQOOU+jZZgUBgsR7hJdYYhH/QTVC6dwmLQqJXMmrsBGrMe82eh
         KUvFDC0YSwg4+5uH4D3Z+WHoJOdmXyAw3Mtu96J1OD8aEFZr+EtEwLaCTCtVztWQ9OoF
         V3RNwxaTyM8scF6ctjIoFh3mGmxNloo+s3KJyvVWKFoI8m8c5DQ1Y2/fXf3qDVCfckZR
         F9TKbmNZR0CIGNHgqpI6Q1StaT2kNjdPXmctJCwkKBenTpTe39xbd2I/ZdSZlLaC1rXc
         m0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWJlI4H4XokLtIJhlpi2UYBbO1EJFdpntQ3Q6vlWr4c=;
        b=c91t0SGXxR+c6Z0ws4FrFOsyxECjRtkkz9soCEKYR5nhT4aKOdXFIjTs7ahlfNAQSR
         BWg65nzmmuXupP+WaX0VJNAUbPPBjKFoRbZjpq0tYvmGtLU3v216gWp91ODHk4C3fejS
         9T2tU4GFaIOC0AVCPPjp04tp5CMkvmjTWiF4AQ3nJA4QjCbEm3Uo5H1MhBiZ7qnZcMXe
         K1LBc22yLYDu5N/8Bsq26s9ezo0KGcOJqxfcMGZsV9kIMPG26lr4MJpK7UfbgUZubXrk
         SFsRPxzVI9m5voang7ztpwgc5Cow9qN8mVsUc5gWKA02rjfam6cgMjo+hUiTwkjAxt7n
         jLmw==
X-Gm-Message-State: AAQBX9cizIpzfIIKh2t58fPYJlHbKkxyYVHdaKQTnivKlKWkMP0+7Hxs
        Zp8BcVR1M+9+7kOlqU2mm4HZlfAVdGbFFvBA/YA=
X-Google-Smtp-Source: AKy350alr6/B0fbZpn2Yk74nlJnwP45N6OuH7dHAYOO8dIgE8H2MfLeizYVtL0DFjRLn8a4e0MN2QQakXC1gzd1zm2U=
X-Received: by 2002:a05:6a00:1783:b0:62b:e52e:1bb with SMTP id
 s3-20020a056a00178300b0062be52e01bbmr9648pfg.0.1680553675666; Mon, 03 Apr
 2023 13:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230401051221.3160913-1-kuba@kernel.org> <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com> <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
 <20230403085601.44f04cd2@kernel.org> <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
In-Reply-To: <20230403120345.0c02232c@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Apr 2023 13:27:44 -0700
Message-ID: <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 12:03=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 3 Apr 2023 11:11:35 -0700 Alexander Duyck wrote:
> > On Mon, Apr 3, 2023 at 8:56=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> > > I don't think in terms of flushes. Let me add line numbers to the
> > > producer and the consumer.
> > >
> > >  c1. WRITE cons
> > >  c2. mb()  # A
> > >  c3. READ stopped
> > >  c4. rmb() # C
> > >  c5. READ prod, cons
> > >
> > >  p1. WRITE prod
> > >  p2. READ prod, cons
> > >  p3. mb()  # B
> > >  p4. WRITE stopped
> > >  p5. READ prod, cons
> > >
> > > The way I think the mb() orders c1 and c3 vs p2 and p4. The rmb()
> > > orders c3 and c5 vs p1 and p4. Let me impenitently add Paul..
> >
> > So which function is supposed to be consumer vs producer here?
>
> producer is xmit consumer is NAPI
>
> > I think your write stopped is on the wrong side of the memory barrier.
> > It should be writing prod and stopped both before the barrier.
>
> Indeed, Paul pointed out over chat that we need two barriers there
> to be correct :( Should be fine in practice, first one is BQL,
> second one is on the slow path.
>
> > The maybe/try stop should essentially be:
> > 1. write tail
> > 2. read prod/cons
> > 3. if unused >=3D 1x packet
> > 3.a return
> >
> > 4. set stop
> > 5. mb()
> > 6. Re-read prod/cons
> > 7. if unused >=3D 1x packet
> > 7.a. test_and_clear stop
> >
> > The maybe/try wake would be:
> > 1. write head
> > 2. read prod/cons
> > 3. if consumed =3D=3D 0 || unused < 2x packet
> > 3.a. return
> >
> > 4. mb()
> > 5. test_and_clear stop
> >
> > > > One other thing to keep in mind is that the wake gives itself a pre=
tty
> > > > good runway. We are talking about enough to transmit at least 2
> > > > frames. So if another consumer is stopping it we aren't waking it
> > > > unless there is enough space for yet another frame after the curren=
t
> > > > consumer.
> > >
> > > Ack, the race is very unlikely, basically the completing CPU would ha=
ve
> > > to take an expensive IRQ between checking the descriptor count and
> > > checking if stopped -- to let the sending CPU queue multiple frames.
> > >
> > > But in theory the race is there, right?
> >
> > I don't think this is so much a race as a skid. Specifically when we
> > wake the queue it will only run for one more packet in such a
> > scenario. I think it is being run more like a flow control threshold
> > rather than some sort of lock.
> >
> > I think I see what you are getting at though. Basically if the xmit
> > function were to cycle several times between steps 3.a and 4 in the
> > maybe/try wake it could fill the queue and then trigger the wake even
> > though the queue is full and the unused space was already consumed.
>
> Yup, exactly. So we either need to sprinkle a couple more barriers
> and tests in, or document that the code is only 99.999999% safe
> against false positive restarts and drivers need to check for ring
> full at the beginning of xmit.
>
> I'm quite tempted to add the barriers, because on the NAPI/consumer
> side we could use this as an opportunity to start piggy backing on
> the BQL barrier.

The thing is the more barriers we add the more it will hurt
performance. I'd be tempted to just increase the runway we have as we
could afford a 1 packet skid if we had a 2 packet runway for the
start/stop thresholds.

I suspect that is probably why we haven't seen any issues as the
DESC_NEEDED is pretty generous since it is assuming worst case
scenarios.
