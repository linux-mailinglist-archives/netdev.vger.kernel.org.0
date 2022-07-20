Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8113857BC7D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbiGTRTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiGTRTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:19:31 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBE6D2C7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:19:30 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31e0d4ad6caso120651997b3.10
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zglQ4DpVeDuoAZIGkiohVfpRjOajDUgnZ6dO7W4kxU=;
        b=DUkS/5fiFv5RXgPSh+5e4GtadpwxwDC6C8Q+mzLbxsdyXgJHDpWSy5KsNO2K7NFZZB
         +tcHTXWJduM5XAP9aUwRGWsco6q7kcGxWPcCqMEDWizcdD1ZzZhixpz/yQSf//s3wkSf
         /QUBnfxbOvfctpCOXbkg5weUJaXXgNPBuA1vQPLSi/Cc8ciOHMIYF7Tmod0eDI19fh7y
         ebOCXNeZUkTMR1Ea8woMbxnuiwimuUivIC86qa4A9Kle6hUKPc2TmpoYf2Hz8vjmCFk3
         SiJhUniWoSw+8oijJg2//izsGXkiq42HRJUI1N8sRQZlBnfEYHUyS2uFd/4u6NCYqI66
         CPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zglQ4DpVeDuoAZIGkiohVfpRjOajDUgnZ6dO7W4kxU=;
        b=mUaz/azo9proMiBpwoQVgpBNQ9s2jELkWhxkTIOXef4rB1cYXpvloiYY+qOWRRYVg3
         znonqN+PMB5Im7gy2n3CVc0jx69heWB7pjEb8CdrOgzG+YY3/4xkPu/cG61IMgTSJ0Fu
         Qi/sMsfEwchfxlyDijPXtYlLqHzXuCRdpZh9Uc4XiT/KktuW8Oq2wMJsl+kSoJ2xE8Si
         lK0RDw/IVI0voiwjp5L5Cwz1mMLFcXPI1/WOEfwL0pANGdILCVm6Ba8X32u91Qc1IX4A
         7guKjaVVQwFleyjnvROQksXGS8Z6V7a4Xzv689A9OY0EZAI2McCPDcbNJOPpyQTuY1jw
         K4PA==
X-Gm-Message-State: AJIora/dR18LmKUUpYI++XCxUVOqcs6QYhzT7lH/xLwY0VZbywEWD7Ge
        yN3HhlPfP0iysq08DRFFa6rdsWnbJKlJuOWslmKnyQ==
X-Google-Smtp-Source: AGRyM1tXUy1k+RMRyOvYqvRequd8tbPr0uENRJ47MplYeKCD2Poy9oLSpDBjzlELPHnA3y6O0sG16HEWMutza7S1tuk=
X-Received: by 2002:a81:160d:0:b0:31c:8997:b760 with SMTP id
 13-20020a81160d000000b0031c8997b760mr42285837yww.489.1658337569770; Wed, 20
 Jul 2022 10:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220715052235.1452170-1-kuba@kernel.org> <20220715052235.1452170-2-kuba@kernel.org>
 <CANn89iLtDU+w=5bb89Om5FGx6MrQwsDBQKp8UL6=O21wS0LFqw@mail.gmail.com>
 <20220720095936.3cfa28bc@kernel.org> <CANn89iKcmSfWgvZjzNGbsrndmCch2HC_EPZ7qmGboDNaWoviNQ@mail.gmail.com>
In-Reply-To: <CANn89iKcmSfWgvZjzNGbsrndmCch2HC_EPZ7qmGboDNaWoviNQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Jul 2022 19:19:18 +0200
Message-ID: <CANn89iJU18GfsxpFJT6zx3Nqj1WyWjHX4YTStWqzsTXfFd8vYw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/11] tls: rx: allow only one reader at a time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru
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

On Wed, Jul 20, 2022 at 7:09 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jul 20, 2022 at 6:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 20 Jul 2022 10:37:02 +0200 Eric Dumazet wrote:
> > > > +               if (!timeo)
> > > > +                       return -EAGAIN;
> > >
> > > We return with socket lock held, and callers seem to not release the lock.
> > >
> > > > +               if (signal_pending(current))
> > > > +                       return sock_intr_errno(timeo);
> > >
> > > same here.
> >
> > Thanks a lot for catching these.
> >
> > > Let's wait for syzbot to catch up :)
> >
> > I'll send the fixes later today. This is just a passing comment, right?
> > There isn't a report you know is coming? Otherwise I can wait to give
> > syzbot credit, too.
>
> I now have a full syzbot report, with a repro and bisection, I am
> releasing it now.

( [syzbot] WARNING: still has locks held in tls_rx_reader_lock )

>
> >
> > I have two additional questions while I have you :)
> >
> > Is the timeo supposed to be for the entire operation? Right now TLS
> > seems to use a fresh timeo every time it goes to wait so the cumulative
> > wait can be much longer, as long as some data keeps coming in :/
>
> Good question. I am not sure how this timeout is used in applications, but
> I would think it serves as a way to make sure a stall is detected.
> So restarting the timeout every time there is progress would make sense.
>
> Application needing a different behavior can still use regular timer,
> independent of networking, ( alarm() being the most simple one)
>
> >
> > Last one - I posted a bit of a disemboweling patch for TCP, LMK if it's
> > no bueno:
> >
> > https://lore.kernel.org/all/20220719231129.1870776-6-kuba@kernel.org/

Ah sorry, I have no comments, I guess we might try to factorize all
these similar functions at some point.
