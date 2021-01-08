Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E282EFAA8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbhAHVdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbhAHVdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:33:06 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB96C061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:32:25 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id h3so3982228ils.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=QqxarMQSTfrAaiAoD1fq1Z1sH3ehIDZ5hYHdxUiwpVI=;
        b=tQqzU18dsJMmJMZ8z2KRJ3TmezhVLCoxKv1+96FPHhGEwJ4lz6uSzkcRxsMW/y6v7h
         J03EsH5zERpybrYSGJRL3qD5rgqicAn3vdhBG2gMdLmSKCxU4Oh6rUk045qGYavHhz36
         eGwsl6ahI0AgZYUUDxAZs1NZA4XOtA9EusM04JUF32ZUaAZmQ/yUekdL1hFsvA7H7fdu
         rznsegShkmWH2BkgaKfcn0jogKxPqe9/8Eyj2DglN30+w4u2jyh6TFTBXKpNupqp+Mis
         qRG3oWtTmCAlpVG+jm2LTPsYqgxa4pEaTU9MATcKom5jxoaq+kvyPrWIbGQsrDkUAcvJ
         cP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=QqxarMQSTfrAaiAoD1fq1Z1sH3ehIDZ5hYHdxUiwpVI=;
        b=MiUtfYEMUmtMAmnICEOevGRW9E6lSDnTj5MIh8yg1SNLchAdoRVvsK8GCzLO2wF2EI
         oFDcdUrp3T2Mud+tbG/1lJmZyqzO98rxO0qAKO3R46ATB/acDvKTTcYQF8LmPGXrMiqa
         aj7jMiScMa40wrLR33Gnbw6z5DYRyfCJq9/53S6mpuFw0Rf5lVfw10iOi1abqoVen1Az
         LmhR1Vg8blQ096vvCGefdlvtnFSoPC/Oy8oD/QoNWxUuUiNJ81b1iXcp995+gf6Eibhc
         Ny5+dypUxqDEViWsVBzU2pg1mJV4BMLto7mzq9zSoh57nSho1HJ5Dgc57SaeIiKwnlIs
         YcdQ==
X-Gm-Message-State: AOAM530PDM2ZoPgEjrTRAF8ecjG4d78p+tBa1+bHi3sazdww276FLDNY
        x2qCGIUZ1OOyO7tLlQhM1/vGlLctfps4/yxu1AU=
X-Google-Smtp-Source: ABdhPJww1eGgMrv58g5BSTsY3uokBpYQPDIc6LqnTVxMNiZy2tL8mHcGPij3U5kA+EGyI8D0u9UYfjzLP750dcJbllI=
X-Received: by 2002:a92:c002:: with SMTP id q2mr5819926ild.186.1610141545325;
 Fri, 08 Jan 2021 13:32:25 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com> <CA+icZUW+v5ZHq4FGt7JPyGOL7y7wUrw1N9BHtiuE-EmwqQrcQw@mail.gmail.com>
 <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com>
 <CA+icZUXixAGnFYXn9NC2+QgU+gYdwVQv=pkndaBnbz8V0LBKiw@mail.gmail.com>
 <CA+icZUW5B4X-SMFCDfOdRQJ7bFsZXwL4QhDdtKQXA3iO8LjpgA@mail.gmail.com> <CANn89i+GF1KuWLwKWxxafWrfQMfFMJdtS2rb=SzgAn9pERKg0g@mail.gmail.com>
In-Reply-To: <CANn89i+GF1KuWLwKWxxafWrfQMfFMJdtS2rb=SzgAn9pERKg0g@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 8 Jan 2021 22:32:14 +0100
Message-ID: <CA+icZUWtVaV02ypJzOv2S_fn8E6RqfUeJKBxBZAVGPVzJ6yajg@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 4:41 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 2:51 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Fri, Jan 8, 2021 at 2:08 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >
> > > On Wed, Aug 12, 2020 at 6:25 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > > > Also, I tried the diff for tcp_conn_request...
> > > > > With removing the call to prandom_u32() not useful for
> > > > > prandom_u32/tracing via perf.
> > > >
> > > > I am planning to send the TCP patch once net-next is open. (probably next week)
> > >
> > > Ping.
> > >
> > > What is the status of this?
> > >
> >
> > I am attaching the updated diff against latest Linus Git.
> >
> > - Sedat -
>
> I have decided to not pursue this.
>
> skb->hash might be populated by non random data if fed from a
> problematic source/driver.
>
> Better to leave current code in place, there is no convincing argument
> to change this.

OK, Thanks for the clarification.

- Sedat -
