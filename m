Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE873525892
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359587AbiELXni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359584AbiELXng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:43:36 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FADA289BCA
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:43:34 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2ebf4b91212so74000427b3.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N+MpLUlaVpHkuuiUc6lyGjVUiffHSHmuxB6NPv5ECyw=;
        b=AAjsICelOCN6C8Ie6MZZxEzH/C5JKJPXQlS1LQ0jKkjgg3Vsvl15ahTuEBNuLn5Nxn
         ab+wWatKgnTKxYqqaLYGrGrctF/hKc0adsJZAp4kjARYCbmYbw52gDKXhnMYegj+9lEO
         SPIAZLywPhby5tO6eE4dB+RfIR4saw7mHbqqaw522A4RGuwiQONsZI2ZmGBGpO/SO6PN
         rX9ShC6U6MokvWDOU1VQsPhAkrLnuRnqFiYrMOA0PKjD5HjqFzG5yKoG+KrIVQyg403e
         jojpBJ331bmvL2k9vLvJ2Nlyod9tic6Y7xKDnY6mDqi9JTGjeT3M79ZI4UKkDHl0mvO0
         Pdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+MpLUlaVpHkuuiUc6lyGjVUiffHSHmuxB6NPv5ECyw=;
        b=ZiHkcK/GHMfbqPKhxGG27B5iW8nm8mCan2aSCfWdhTWFXnR/U4N5Cip5sDtiXk2kWE
         BxkTf5mPdrUhtk3qau0ZKqdXq+l+O47FUhErvPUTezJUk972BwxtcvdEoXIYniXSRtbb
         SkFf/wy7c2Ugj4nbr6KCR7PTpV80jMXZKe+4IOPXvYEFdowETt6b8+eqpwmM5cheyuXk
         40f3OQGvOaZYBvIZEDa4rd5aQi+QeymMrQAu22Z6MEk1rGXuN3h5etqEIr/AAjtRm12S
         8TjCPde1kv7QSPEo0hBrDwSMUzfdu7lvbtmWe0+ctiWhOnKQOSzHEfM+/uwv6fR31NhV
         bfWw==
X-Gm-Message-State: AOAM533FKEiV/i7syTLPEWXTXxxOWJtc5r0/5oZoHDZ0DF3HePNcv3/a
        D5uZ18ZsgHTcZD5N6UnHt9NGX5omwt2yS7TtTXF9Xg==
X-Google-Smtp-Source: ABdhPJzjbu/RnzqVTRYp0k727mM1ACmM32pBiQjimcGPlHUXFIkkbnwgoBjXIOjciFpNfJnHmMa8QuYN7FVHJ7Rb4wE=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr2742677ywj.47.1652399011564; Thu, 12
 May 2022 16:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220512103322.380405-1-liujian56@huawei.com> <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
 <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
 <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com> <20220512231031.GT1790663@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20220512231031.GT1790663@paulmck-ThinkPad-P17-Gen-1>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 16:43:20 -0700
Message-ID: <CANn89iKiTiGwMvV6K+Zbr_9+knaR-x1N3tOeMX+2No2=4zn6pA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Marco Elver <elver@google.com>, Liu Jian <liujian56@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 4:10 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Thu, May 12, 2022 at 02:31:48PM -0700, Eric Dumazet wrote:
> > On Thu, May 12, 2022 at 2:18 PM Marco Elver <elver@google.com> wrote:
> >
> > >
> > > I guess the question is, is it the norm that per_cpu() retrieves data
> > > that can legally be modified concurrently, or not. If not, and in most
> > > cases it's a bug, the annotations should be here.
> > >
> > > Paul, was there any guidance/documentation on this, but I fail to find
> > > it right now? (access-marking.txt doesn't say much about per-CPU
> > > data.)
> >
> > Normally, whenever we add a READ_ONCE(), we are supposed to add a comment.
>
> I am starting to think that comments are even more necessary for unmarked
> accesses to shared variables, with the comments setting out why the
> compiler cannot mess things up.  ;-)
>
> > We could make an exception for per_cpu_once(), because the comment
> > would be centralized
> > at per_cpu_once() definition.
>
> This makes a lot of sense to me.
>
> > We will be stuck with READ_ONCE() in places we are using
> > per_cpu_ptr(), for example
> > in dev_fetch_sw_netstats()
>
> If this is strictly statistics, data_race() is another possibility.
> But it does not constrain the compiler at all.

Statistics are supposed to be monotonically increasing ;)

Some SNMP agents would be very confused if they could observe 'garbage' there.

I sense that we are going to add thousands of READ_ONCE() soon :/
