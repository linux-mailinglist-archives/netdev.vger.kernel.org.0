Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9954D1EBD1F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFBNby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBNby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:31:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE398C061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 06:31:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k26so3140146wmi.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XYAFwrDiJjiKUlGIkL1HzZfkmr9eGPPliJK1ckQQgGU=;
        b=Yk3SPsVSRtjX/GMjwNtGNAdHPDaSLTaUZT02YE121BB0ps74yRK/TQ1Ng/xiFzz5eE
         AvEhYQ9lvTlTiEzleOkD+UrEMqZgL3lgwGLXAFxKddl4IuvRI1rMnFyxSSQsTugsOUc1
         ntcKBWM3BwdFkbq/HkaWsUKggz1ucDx3HKxiUjLuXRPyfMiVlYIETk9FQezFAsQgfm7f
         oloUGMyuLNk+Wfv6+6qkCqQz0IOOrd3zp2fyyStnr3FGBNk23hAgd1nAFXCSdnJiMaox
         upIwHJLFJABKKXv9BCxmuS/SVR8Z7XaQW1FvnDrd0BzaJZaH+uEimNDxaAseEz8kXTOM
         jsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XYAFwrDiJjiKUlGIkL1HzZfkmr9eGPPliJK1ckQQgGU=;
        b=Q2Zg6TQQfM4AtAbG3228XsJhLPx6fFF5mj6tz8Nva+wHKZ552+TkhwR1QQoN2a/WmJ
         Dj/uYpd3G2wBU1bSrqTqbVYkmz8fy9QZuYRVeRqhpboO/CTeiq5ReEI2sWfZnuWHQ+Bm
         4E+drXrIi46uhA7WIJ9ysPHUn0LY2fQBSAPc6ZOBQZ5sQfM6eiTRrNb9JDvDzNJZa/eG
         dUi6wyFTI6nK8Vr/d5AZwoE2CRXyJyISL3H0ATO6Bfrfxyyqi6zQFunMyVKXRQgP0fxW
         guV+FDWzSp2mj/PQeS9UXA3LeLw3Sjkl6eNm5gPeVfyHxx4WMo5jpg7UH3/gCrmzA+wD
         iRvg==
X-Gm-Message-State: AOAM530W95TPaHPg84ZKEdlUWyANEgHqVIIpAV5jaVDEH7XCwbk3fVSX
        9PH/JNMGo3jmj+NuYxZ5O5YJQUkZIEw6Mjw6Rl6BNA==
X-Google-Smtp-Source: ABdhPJyYkbGt125L9ygtZLCx7wguguRD6v1e+Ng2k3FktU92D/XPE5D/Dja9sBA9CQybUB8xMq3C8p3rCBlubtPfu7w=
X-Received: by 2002:a1c:ba0a:: with SMTP id k10mr4043054wmf.81.1591104712288;
 Tue, 02 Jun 2020 06:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com> <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
 <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com>
In-Reply-To: <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 2 Jun 2020 15:31:40 +0200
Message-ID: <CAG_fn=XR_dRG4vpo-jDS1L-LFD8pkuL8yWaTWbJAAQ679C3big@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 11:55 AM Edward Cree <ecree@solarflare.com> wrote:
>
> If it's an alias of BPF_XOR r,r, then the interpreter will surely still
>  interpret it with the XOR code.  Unless you make the interpreter
>  special-case this, in which case you've added an extra branch to every
>  XOR the interpreter handles :(

You are right, the interpreter can be probably fixed in a different
way that doesn't introduce extra branches.

> > Given the increased popularity of Clang in the kernel these days, I
> > don't think it's a good idea for a single compiler to further diverge
> > from the standard.The standard in question isn't C89, but "--std=3Dgnu8=
9", which is
>  whatever GCC says it is :grin:
> So if GCC declares that some class of optimisations are not legal under
>  --std=3Dgnu89, then they're not legal and Clang has to adapt to that.

Hm, I never thought of such an approach to standards. This sounds like
a legitimate solution, which will however result in:
 - GCC developers saying "no, we won't do this", or
 - Clang developers saying "no, we won't do this"
, unless we present them with good reasons to do so.

Because the use-case is quite narrow, and prohibiting this
optimization may break other optimizations (at least in Clang), I
won't expect anyone spending time on making Clang compliant with
--std=3Dgnu89 in this particular case.

> > I wouldn't call this particular use case "extremely annoying".
> To be clear, what's "annoying" is the double-bind we're in as a result
>  of trying to optimise the prologue for both JITs (whose semantics are
>  whatever we define eBPF to be) and the interpreter (which has to be
>  implemented with reasonable efficiency as C code).

> > If I understand correctly, these two instructions are only executed
> > once per program.
> > Are they really expected to impact performance that much?
> If you have a very short program that's bound to a very frequent event,
>  then they might.  But I don't have, and haven't seen, any numbers...

So we're back to the question how much people care about the
interpreter performance.

> > I don't have evidence that such a transformation is currently possible
> > for the BPF code in question, but all the building blocks are there,
> > so it's probably just a matter of time.
> I'm not so sure.  Consider the following sequence of BPF instructions:
>     xor r0, r0
>     ld r0, 42
>     xor r0, r0
>     exit
> I hope you'll agree that at entry to the second XOR, the value of r0 is
>  not indeterminate.  So any optimisation the compiler does for the first
>  XOR ("oh, we don't need to fill the existing regs[] values, we can just
>  use whatever's already in whichever register we allocate") will need to
>  be predicated on something that makes it only happen for the first XOR.
> But the place it's doing this optimisation is in the interpreter, which
>  is a big fetch-execute loop.  I don't think even Clang is smart enough
>  to figure out "BPF programs always start with a prologue, I'll stick in
>  something that knows which prologue the prog uses and branches to a
>  statically compiled, optimised version thereof".
> (If Clang *is* that smart, then it's too clever by half...)

I don't think Clang does this at the moment, but I can certainly
imagine it unrolling the first two iterations of the interpretation
loop (since the prologue instructions are known at compile time) and
replacing them with explicit XOR instructions.

I however suggest we get to the practical question of how to deal with
this issue in the long run.
Currently these error reports prevent us from testing BPF with syzbot,
so we're using https://github.com/google/kmsan/commit/69b987d53462a7f3b5a41=
c62eb731340b53165f8
to work around them.
This seems to be the easiest fix that doesn't affect JIT performance
and removes the UB.

Once KMSAN makes it to the mainline, we'll need to either come up with
a similar fix, or disable fuzzing BPF, which isn't what we want.

--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
