Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA942435CC
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 10:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMINz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHMINy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 04:13:54 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD7C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:13:54 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id v6so4110689ota.13
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=rYUhZ5ke194KCa6HG+WfrbWl+5C9ew/OTgW+gXSCU/s=;
        b=YmPAxS8D7RXt+F1Dmk/oH1fHS6wS9QvI3SPLWSlZ5FHJRew5vq+ZK4j7LMsfmCPf8m
         zo17aaTD8k0CJeRoTaIpX3UbPyaJ4ancI4i0IO+fC0XO+uGxda5KrCET/tiM5zZ5lyCO
         zzNiCISEVGUP3mgLWbYPyhm89qX6zvLv+fvOKZdas9C41h2vDEakhP4qHvIjXp7jtaeO
         0e/i50BLoLkze6ky0Y4EvQ1RdXxrn91LSPDAbLIEF8lJcez5Fsk9GjCOW9OkMHBaIuq8
         FUQsmumCNiUHWbwvVbT5dlzykys+vZHsKAbn1C3FkZ1A2sfEl6oCXC2sVk5dHsWTwo97
         VJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=rYUhZ5ke194KCa6HG+WfrbWl+5C9ew/OTgW+gXSCU/s=;
        b=Gi+D3YBCM8gVMh2XPVl0OIp1eIpdOAexymPxjZAWtCBIpbI0lQbJO7GLirEFCkc4Su
         WFxf0lqvf3eUKU7Jq9N9BSk4UMc5xrPPjEQgE9qpyDTPR4IYtF2LSt+0VlwzHIw5dkur
         DhmB1SyQ6ctWATImTszSeCQnSTOFX5HkzkZ8icjRQfBQsLBtQfJCdwiGCscUkpFtuO4Q
         ybrRumAeZLdcxh5Q4vGTZkkXoSxqgRK2Pp4mbxFs18W0KT5HK2oSb/ul3w/P0pluSAlM
         qLP/SGYXZdcnXmLxsxmuTQYnM26oIbmIfOTe1IAfVytql1uVk5bcZPvdv7cz7BO3+bUb
         7eRw==
X-Gm-Message-State: AOAM530bzVsxxWm0csj2x7mqX3SCpSmYrKhoOx20Ob3udKIpU2oLXXC0
        lyWckfMSrD990j4IEhgitjTY6U7/ee9kr/bFHW8=
X-Google-Smtp-Source: ABdhPJy3jhH6lJFYCYAv6tXiWsK4NpPLzrbD9WgfesT9WDzJviVXY4S6+eA/rB8KgXyYKL6ogGe9WXmfv0R+/iwg9ys=
X-Received: by 2002:a9d:8f7:: with SMTP id 110mr3048679otf.109.1597306433523;
 Thu, 13 Aug 2020 01:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu>
In-Reply-To: <20200813080646.GB10907@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 13 Aug 2020 10:13:41 +0200
Message-ID: <CA+icZUWiXyP-s+=V9xy00ZwjaSQKZ9GOG_cvkCetNTVYHNipGg@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 10:06 AM Willy Tarreau <w@1wt.eu> wrote:
>
> On Thu, Aug 13, 2020 at 09:53:11AM +0200, Sedat Dilek wrote:
> > On Wed, Aug 12, 2020 at 5:21 AM Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > On Tue, Aug 11, 2020 at 12:51:43PM +0200, Sedat Dilek wrote:
> > > > Can you share this "rebased to mainline" version of George's patch?
> > >
> > > You can pick it from there if that helps, but keep in mind that
> > > it's just experimental code that we use to explain our ideas and
> > > that we really don't care a single second what kernel it's applied
> > > to:
> > >
> > >    https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/cleanups.git/log/?h=20200811-prandom-1
> > >
> >
> > Thanks Willy.
> >
> > I disagree: the base for testing should be clear(ly communicated).
>
> It is. As you can see on the log above, this was applied on top of
> fc80c51fd4b2, there's nothing special here. In addition we're not even
> talking about testing nor calling for testers, just trying to find a
> reasonable solution. Maybe today I'll be able to re-run a few tests by
> the way.
>

I agree with publishing in your Git tree it is clear.

> > There are two diffs from Eric to #1: add a trace event for
> > prandom_u32() and #2: a removal of prandom_u32() call in
> > tcp_conn_request().
> > In case you have not seen.
>
> I've seen, just not had the time to test yet.
>

Can you describe and share your test-environment/setup?

The Linux-kernel has kunit tests (I never played with that) - you
happen to know there is a suitable one available?

Maybe the Linux Test Project has some suitable tests?

- Sedat -
