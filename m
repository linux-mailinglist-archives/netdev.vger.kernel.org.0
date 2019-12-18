Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C968F124620
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLRLue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:50:34 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:57757 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfLRLud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 06:50:33 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e37716a2;
        Wed, 18 Dec 2019 10:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=dF+343L+TdlkZkv3XYQxJv3zHkU=; b=TjcPQ6
        hXxWKK2YLj+bHj6e8MKS1+2/s45ZVpmfXnTRAP1x36bgHNVA6rckobNs6oHmicFd
        XiP/F98tGiMcdphyibDkPyNM3ucsuyyYPPAraTVtOwcvz84uSrcyf8PJSQIT6k51
        yd9h0ujCeDpb2ttx5JyV6jDI/7J/HsGmHTft5s6NGqpsJ9zsoQhMjM5jKDOVVC4F
        w7wz4KmEIYLotJ2iSrq/ZriiJaQpvN8u2Zem9eoNk6F8EcDVYoc7AyUYdzSOWJSk
        hbbMFOpNMsQEpqrG4q0zsJV0dvE3rGRIRxflVEYNsoHn0eC30/kquA8HHym3jGdA
        v0d1ajk3Jv+IHiFg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9bcc9931 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 18 Dec 2019 10:53:58 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id p8so2172391oth.10;
        Wed, 18 Dec 2019 03:50:31 -0800 (PST)
X-Gm-Message-State: APjAAAXvqXk7MkqOYS2B2sTTrImQkkRen5kmslxVvgR5gWWHsBJIlpoh
        c2DJwSBgJ5iT6z/ZalZuY0ZpH5xXCngdJsS8y3I=
X-Google-Smtp-Source: APXvYqzhY12iR5m2kOBPfSFcgyM7ph/qjcMRfYbool+Jo+GJ1pt8ESvldAOSFjtQuspfXp9ad3F2iB9gc7l+lqvEedc=
X-Received: by 2002:a9d:4f0f:: with SMTP id d15mr2218022otl.179.1576669831047;
 Wed, 18 Dec 2019 03:50:31 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com> <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
In-Reply-To: <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 18 Dec 2019 12:50:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
Message-ID: <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
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

Hi Dmitry,

On Wed, Dec 18, 2019 at 12:37 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Actually with WireGuard, I think that's not the case. The WireGuard
> > logging has been written with DoS in mind. You /should/ be able to
> > safely run it on a production system exposed to the wild Internet, and
> > while there will be some additional things in your dmesg, an attacker
> > isn't supposed to be able to totally flood it without ratelimiting or
> > inject malicious strings into it (such as ANSI escape sequence). In
> > other words, I consider the logging to be fair game attack surface. If
> > your fuzzer manages to craft some nasty sequence of packets that
> > tricks some rate limiting logic and lets you litter all over dmesg
> > totally unbounded, I'd consider that a real security bug worth
> > stressing out about. So from the perspective of letting your fuzzers
> > loose on WireGuard, I'd actually like to see this option kept on.
>
> This is the case even with CONFIG_WIREGUARD_DEBUG turned on, right? Or without?

Turned on.

> Well, it may be able to trigger unbounded printing, but that won't be
> detected as a bug and won't be reported. To be reported it needs to
> fall into a set of predefined bug cases (e.g. "BUG:" or "WARNING:" on
> console). Unless of course it triggers total stall/hang.

Bummer. Well, at least the stall case is interesting.

> But I'm
> afraid it will just dirty dmesg, make reading crashes harder and slow
> down everything without benefit.

Actually the point of the logging is usually to make it more obvious
why a crash has come about, to provide some trail about the sequence
of events. This was especially helpful in fixing old race conditions
where subtle packet timing caused WireGuard's timer-based state
machine to go haywire. Is syzkaller able to backtrack from crashes to
the packets and packet timing that caused them, in order to make a
test case to replay the crash? Is this precise enough for race
condition bugs? If so, then when debugging the crashes I could always
replay it later with logging turned on, in which case it might make
sense to split out the debug logging into CONFIG_WIREGUARD_VERBOSE_LOG
or similar (unless the logging itself changes the timing constraints
and I can't repro that way). If this isn't possible, then it seems
like logging might be something we would benefit from having in the
crash reports, right? Or am I missing some other detail of how the
system works?

Jason
