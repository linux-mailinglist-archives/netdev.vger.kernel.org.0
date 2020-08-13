Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC3224357E
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHMHxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgHMHxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:53:24 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D505C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:53:24 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id n128so440409oif.0
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=7XL9xzqB2lA1FmmwvnJahfx0Ip1DiqMHjux8TJko19k=;
        b=et92XJ9L/2kS35ZVIWh/fBOUZQIx80u+08LEDByVQAKCZ7Ku/JQZMzjvsdoy5q10WV
         miYEh5XGpkCHJWysxrLn3SBK7X6AU8s1RVE7EKJEgPun0UXblibkl2hLjRI5JZDbO+82
         I7VbEW6wMEV0K7eKTIqPEfHBIe71qSVFAeDrWgo1suCQ0SsvK61SKf3iC3kI2/jW77Bn
         Qs3trskdMGg8wXkLHZSnVb5f6JWKtGZ9a4zbfbezwMMxeMoJr/7SqGGdGtcaMCO4PSxj
         a2mcEHuIeUy7dTNbE9Ig7EssRN+SejdxI0V3ufhUVp3maPtHSzxTT2wH41QvF8U2ulbb
         FeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=7XL9xzqB2lA1FmmwvnJahfx0Ip1DiqMHjux8TJko19k=;
        b=YQ7CS8jvG23uEm+MqnVXCNRJ7gog9+5Z27+Zyjg/3c2redNnDovbJig01jPk+gZ/hx
         6gDeDFpzrk8E41dKxzNmiN5u9Kymn3DJ9ZjIlxrQOErV4MB4h8Z+0PV2LZNWMSb4JgUR
         a7DXutvGTuVGjUPWIarjTfq+BTrUlJMrY88m7VPeO+76Esrs0Z1Z0VmN7H1emeWlwcbK
         q8fd8abCZvQJ5yRgCJwc10lCMGryFgnQu+NjKpCojcr1nJM6W7VJHmltZZn1SENjc9I8
         2Y0HuiIrN9GggRhuj/gEtNPa0ig2kCdUN7fEUK3SubYH0J++lQLyYXGiTtwZ3XXiaa8L
         +lKA==
X-Gm-Message-State: AOAM532HPmkN1uFHfG4V8HnOu3asAr+iW8J7RtBcuxzKF7Bu8RZJDgtB
        geLgPoqjuQ7DkM+YFSOxLq25yqUI51i1Ty7ILHQ=
X-Google-Smtp-Source: ABdhPJy43Re/SaM8wbAgnLQKBKPojmM8AgZ+wwUWXxfxi2JSuZ8MxSYj4+huh2CCCDJJEy4sMUh+dy+JOVMwdpPi0os=
X-Received: by 2002:aca:724f:: with SMTP id p76mr2371974oic.35.1597305203750;
 Thu, 13 Aug 2020 00:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com> <20200812032139.GA10119@1wt.eu>
In-Reply-To: <20200812032139.GA10119@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 13 Aug 2020 09:53:11 +0200
Message-ID: <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
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

On Wed, Aug 12, 2020 at 5:21 AM Willy Tarreau <w@1wt.eu> wrote:
>
> On Tue, Aug 11, 2020 at 12:51:43PM +0200, Sedat Dilek wrote:
> > Can you share this "rebased to mainline" version of George's patch?
>
> You can pick it from there if that helps, but keep in mind that
> it's just experimental code that we use to explain our ideas and
> that we really don't care a single second what kernel it's applied
> to:
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/cleanups.git/log/?h=20200811-prandom-1
>

Thanks Willy.

I disagree: the base for testing should be clear(ly communicated).

There are two diffs from Eric to #1: add a trace event for
prandom_u32() and #2: a removal of prandom_u32() call in
tcp_conn_request().
In case you have not seen.
The first was helpful for playing with linux-perf.
I have tested both together with [2].

- Sedat -

[1] https://marc.info/?l=linux-netdev&m=159716173516111&w=2
[2] https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=random/fast

Note2myself: Enable some useful random/random32 Kconfigs

RANDOM32_SELFTEST n -> y
WARN_ALL_UNSEEDED_RANDOM n -> y

- EOT -
