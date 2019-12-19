Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8B1125DC9
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLSJfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:35:30 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36047 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfLSJfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 04:35:30 -0500
Received: by mail-qv1-f65.google.com with SMTP id m14so1970024qvl.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 01:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3kinH9BKdcFWrmC53cr2rYC6iVhtIiNy5b7BJBTamU=;
        b=RhZ4L+XeesMX8bq4b7b4SjjJMIzYqW/kFA+aLP/E/omYTcpkyqrnaTSkIjYfnrC+j3
         Yu6QyJHygnNWgDy52rLc3Eh/goTp18pB1gv9G9C4WcM+mz+/8seuKGe5dwZ0ysIXekxD
         glDiT2rNr+LAgopPqiO0qLmlJ+vQ/FWNrQ6Oc6dHGrNQmZlu83rt2/ris1BRWkMzWbuV
         SuZoS5+E+tyGeGWAcOT6JApeE3sUyo3swp0HgZCvlT5gQyXCv89Kc5kHhbWNvxg4KaeR
         UkeCd56nvBhCCmUvgqcOdGB2XnVDvU1LIPPyAfx/JkAdgn4QE+WuguxvpCmcT4rhgA+3
         OD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3kinH9BKdcFWrmC53cr2rYC6iVhtIiNy5b7BJBTamU=;
        b=DcsmpLe4MB+obqdV9UD5M7eTq8FBxc4bUPdRjSGX4UM1/SvJkHb76EBDZteMgAjny3
         RqAhvS2Ks6x2HfVD1KZflXsSUv71LOcgWHQ44sRlc6dpe6MUwepj/tVQdsUu7+AqQfFn
         0TYSiEjxT5pMF45zYDAd55X+Kl2QLQBkYq6+dTCKQX1ZQ7/dVdMEy1MNlMywpkhbVmM/
         8yYfgsw4c0AC0HSzo+dhvvpwTQatCr4yQgSl8CezXF+99dFQYFu9tD+urHoY43drcLAi
         EAzW55GrLd1BcntcI2Dzu3BWpDyq4i5OiXUb86RiFWZeulrk8L8xDdJRi6CEzOHOKg6x
         Q+0g==
X-Gm-Message-State: APjAAAWAVhjEQ2YGthdbhe7FyiZRaQIY46fzUasZ6dUf6QE9CklDhyx9
        EaOtEuHda11gQvCdELEKhco3gUb3XtDL4rkiiWa/ikugdTo=
X-Google-Smtp-Source: APXvYqy6Yj7NLDWm5gkYIu8GE7GppWwnrEdh9KUENE1GXmBiReYe5mDSw8lgNZtD5WJAiQ4gh3ZGTlod9wsiTweaUJI=
X-Received: by 2002:a0c:c351:: with SMTP id j17mr6777104qvi.80.1576748128716;
 Thu, 19 Dec 2019 01:35:28 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com> <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
In-Reply-To: <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 Dec 2019 10:35:17 +0100
Message-ID: <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:50 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Wed, Dec 18, 2019 at 12:37 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > Actually with WireGuard, I think that's not the case. The WireGuard
> > > logging has been written with DoS in mind. You /should/ be able to
> > > safely run it on a production system exposed to the wild Internet, and
> > > while there will be some additional things in your dmesg, an attacker
> > > isn't supposed to be able to totally flood it without ratelimiting or
> > > inject malicious strings into it (such as ANSI escape sequence). In
> > > other words, I consider the logging to be fair game attack surface. If
> > > your fuzzer manages to craft some nasty sequence of packets that
> > > tricks some rate limiting logic and lets you litter all over dmesg
> > > totally unbounded, I'd consider that a real security bug worth
> > > stressing out about. So from the perspective of letting your fuzzers
> > > loose on WireGuard, I'd actually like to see this option kept on.
> >
> > This is the case even with CONFIG_WIREGUARD_DEBUG turned on, right? Or without?
>
> Turned on.
>
> > Well, it may be able to trigger unbounded printing, but that won't be
> > detected as a bug and won't be reported. To be reported it needs to
> > fall into a set of predefined bug cases (e.g. "BUG:" or "WARNING:" on
> > console). Unless of course it triggers total stall/hang.
>
> Bummer. Well, at least the stall case is interesting.
>
> > But I'm
> > afraid it will just dirty dmesg, make reading crashes harder and slow
> > down everything without benefit.
>
> Actually the point of the logging is usually to make it more obvious
> why a crash has come about, to provide some trail about the sequence
> of events. This was especially helpful in fixing old race conditions
> where subtle packet timing caused WireGuard's timer-based state
> machine to go haywire. Is syzkaller able to backtrack from crashes to
> the packets and packet timing that caused them, in order to make a
> test case to replay the crash?

Sometimes. You may sort by "Repro" column here to get the ratio:
https://syzkaller.appspot.com/upstream
https://syzkaller.appspot.com/upstream/fixed

> Is this precise enough for race
> condition bugs?

It's finding lots of race conditions provoked bugs (I would say it's
the most common cause of kernel bugs).

> If so, then when debugging the crashes I could always
> replay it later with logging turned on, in which case it might make
> sense to split out the debug logging into CONFIG_WIREGUARD_VERBOSE_LOG
> or similar (unless the logging itself changes the timing constraints
> and I can't repro that way). If this isn't possible, then it seems
> like logging might be something we would benefit from having in the
> crash reports, right? Or am I missing some other detail of how the
> system works?

Well, you are missing that wireguard is not the only subsystem
syzkaller tests (in fact, it does not test it at all) and there are
3000 other subsystems :)
If we enable verbose debug logging for all of them, we will get storm
of output and the wireguard logging you are interested in may simply
be evicted from the 1MB buffer. Also, the expected case is that a
program does not crash, in that case we waste performance for
unnecessary logging (and not finding bugs because of that).

In some cases there are reproducers, in some cases a bug is trivial to
debug based on the crash report (no tracing needed).

But additional debug checks are useful in any testing.
