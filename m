Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E0B1245E8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLRLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:37:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39815 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLRLhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:37:43 -0500
Received: by mail-qk1-f196.google.com with SMTP id c16so1259070qko.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+M8i39/jB6Cqau0xv7tzu7ie7N03vkjz45ADcmxSd0=;
        b=aRf4sMeWzpadW5YJrmob5NdYi06W4xs5sug9fKJBjCXVsXaWQTyeKCMHdYNRW4gUir
         o2k89xJ7NsawicDftFZF0m4Ydmc7VvW+wymYJJFcE2SA+28K7kUDG+s8NjIwJv8cA0PV
         RA3WKgbFfPQGjv62mEKfn16vDFaNdFOjC5VzPQh82/dIAsYQSupfL/Z437nK6PumzOPF
         +h+x6ROL/EONo82GvI6fAxLNWsZb0cEEmfUi3Kg1+v5RoNJbszmIjfgQUTQBMvmPpRU5
         mZ1Opk9FCvaWvglpbvXKaK4Qh6GF5guLxxq3DCKPIsFn5/BA0HwFiBtolnHtqM0xEge4
         h2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+M8i39/jB6Cqau0xv7tzu7ie7N03vkjz45ADcmxSd0=;
        b=bBQK52dGvSROnsZFsLPfc/vOKNQIWy3whlcfLGep6SWU+I+ySIXNCtB7qaQU+ofD9a
         1nH2PNzRIHLFCEzalKGiykTaAIAbQRKIXdd0A+LDohljKMLIm12BRWOWcm93sMax0OuI
         MDwjsARJhbjt0ntQozO7SaeSDQcw1kSfnWCGuY6Tr/82avgmcZkZjsv3dCHQ9w5GhaTS
         8U/TtstBO6nDN8Ff86Qz2+DDw1QV6UXW6AF3fpUjNUzdIn7otoZ3lIjjyTMdfcLRhfmL
         gp9YHcEHF/Nkq6zItReu/XfePZ/KWbQRSNnESEtWGR1zeQiypMuM9RABPveLu3tfwfWy
         8vCQ==
X-Gm-Message-State: APjAAAXl9ZmzMkldtDdJIu3KDEANhVt/D00RWBv6/92Tgas6ARzDDNMM
        cX9yr2wBjoM9vWk29p3MLOzG8LDziwfR1oTbTB4mKA==
X-Google-Smtp-Source: APXvYqyKK+FDzDrpsx/z+doLr55we/uUU5vCPbMr4o16ebJXWlTeSoCgL+oyXSSiJUasHPhtkAICWMChBnTXKRzBoGQ=
X-Received: by 2002:a05:620a:1136:: with SMTP id p22mr1987714qkk.8.1576669062422;
 Wed, 18 Dec 2019 03:37:42 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
In-Reply-To: <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 18 Dec 2019 12:37:30 +0100
Message-ID: <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
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

On Wed, Dec 18, 2019 at 11:57 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Wed, Dec 18, 2019 at 11:13 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Does it really do "verbose debug log"? I only see it is used for
> > self-tests and debug checks:
>
> Yes, it does, via net_dbg and co. People with the Linux "dynamic
> debugging" feature turned also get the log by twiddling with some file
> at runtime.
>
> > In different contexts one may enable different sets of these.
> > In particular in fuzzing context one absolutely wants additional debug
> > checks, but not self tests and definitely no verbose logging. CI and
> > various manual scenarios will require different sets as well.
> > If this does verbose logging, we won't get debug checks as well during
> > fuzzing, which is unfortunate.
> > Can make sense splitting CONFIG_WIREGUARD_DEBUG into 2 or 3 separate
> > configs (that's what I see frequently). Unfortunately there is no
> > standard conventions for anything of this, so CIs will never find your
> > boot tests and fuzzing won't find the additional checks...
>
> I agree that it might make sense to split this up at some point, but
> for now I think it might be a bit overkill. Both the self-tests and
> debug tests are *very* light at the moment. Down the road if these
> become heavier, I think it'd probably be a good idea, but for the time
> being it'd mostly be more complexity for nothing.
>
> Another more interesting point, though, you wrote
> > and definitely no verbose logging.
>
> Actually with WireGuard, I think that's not the case. The WireGuard
> logging has been written with DoS in mind. You /should/ be able to
> safely run it on a production system exposed to the wild Internet, and
> while there will be some additional things in your dmesg, an attacker
> isn't supposed to be able to totally flood it without ratelimiting or
> inject malicious strings into it (such as ANSI escape sequence). In
> other words, I consider the logging to be fair game attack surface. If
> your fuzzer manages to craft some nasty sequence of packets that
> tricks some rate limiting logic and lets you litter all over dmesg
> totally unbounded, I'd consider that a real security bug worth
> stressing out about. So from the perspective of letting your fuzzers
> loose on WireGuard, I'd actually like to see this option kept on.

This is the case even with CONFIG_WIREGUARD_DEBUG turned on, right? Or without?

Well, it may be able to trigger unbounded printing, but that won't be
detected as a bug and won't be reported. To be reported it needs to
fall into a set of predefined bug cases (e.g. "BUG:" or "WARNING:" on
console). Unless of course it triggers total stall/hang. But I'm
afraid it will just dirty dmesg, make reading crashes harder and slow
down everything without benefit. O(1) output per test is generally not
OK in heavy stressing scenario, even if it's overall bounded and rate
limited.
