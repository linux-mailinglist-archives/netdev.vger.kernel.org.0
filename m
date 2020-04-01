Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24619B69A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgDATy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:54:57 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39256 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDATy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:54:57 -0400
Received: by mail-pj1-f66.google.com with SMTP id z3so519228pjr.4
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ug9xvso2ibAozuMtdH282Ae+5uQpIAI7JbIiApWivYY=;
        b=ZGY1Lrw15EmGLMr9MBH/js6pVH4l6VCDnlhGqVA62hkZItw1g5GZOUYg1HNTAE8t/E
         GOBfiE0Aa3DsGUFZBk1kUv4UZCqVeeLuRSaTSPyVnRzvDqdGdtxPVK/uhTRZMOumjCGp
         TyiTnWP1ss/XBV/Ozmuzvc97naoA0cWrOjBzHUVXl8Pk4totnKmOjKbAwPelHW4gqrdK
         z+RyV3fDkXnTNW8LeC2cSdSVutNe7UJdyFSmjAiMNUxwz+vsAHBJeUzVlLRjX+yk3kN2
         UXehzLotn9PgGxbU3ar+jky4WPV8bjykAKwQ73S+oLmEvfsVyFdPP/nnojEb9ER7p2Ma
         ulsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ug9xvso2ibAozuMtdH282Ae+5uQpIAI7JbIiApWivYY=;
        b=P2j7AhZsCMCn2f8AWfqjDuMswmplIzDLnLtKSpYPyixwnXWgltRjrBhwx+967yEPfG
         r/YJMOTWNWZdZeSiQ4Oi6/tWMAUFsa122ddHS6kSZx+FLomNVG6r5Yk6wtWXFNlOca0h
         q9LoA/JvYQ0IOA42f5YfqlW9qH57bsWmgTCb9t0qFNBjoWjFNk6NL3zm4OiB3W9Lysb8
         fyJjaZ2nuEsfwcTwSdJCf+PU/r9PrX8wGOVeJigEDHOIEjnbaNyHDsUmGq+KCMh4BxkJ
         Xpq/YCtogN9kiAzdr4Y5i2M7Zhp2BMsagcGjE4/k2vH1ac4zCZBEpUcgb/G3vvwnbrpn
         J08g==
X-Gm-Message-State: AGi0Pub8qgTyEooqxZ/AorfWCQ63ArJl0f7/iIhL5huAY6QmnuiYMnDG
        Sb3FoLSU76gJjg5l4cDvotnc6kryfzKRE8YmbWXmKQ==
X-Google-Smtp-Source: APiQypJf4+2YJ/aF3pSAGQFATdNBl3ECkQ8IRop38d8YG546Uof7o3BD6iliDJzeXh9MoP1xMdNtFcsxeCorxtqdU4A=
X-Received: by 2002:a17:90b:230d:: with SMTP id mt13mr6803649pjb.164.1585770895190;
 Wed, 01 Apr 2020 12:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200311024240.26834-1-elder@linaro.org> <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org> <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
 <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org>
In-Reply-To: <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 1 Apr 2020 12:54:43 -0700
Message-ID: <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Alex Elder <elder@linaro.org>
Cc:     Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 1, 2020 at 12:44 PM Alex Elder <elder@linaro.org> wrote:
>
> On 4/1/20 2:13 PM, Nick Desaulniers wrote:
> > On Wed, Apr 1, 2020 at 11:24 AM Alex Elder <elder@linaro.org> wrote:
> >>
> >> On 4/1/20 12:35 PM, Nick Desaulniers wrote:
> >>>> Define FIELD_MAX(), which supplies the maximum value that can be
> >>>> represented by a field value.  Define field_max() as well, to go
> >>>> along with the lower-case forms of the field mask functions.
> >>>>
> >>>> Signed-off-by: Alex Elder <elder@linaro.org>
> >>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
> >>>> ---
> >>>> v3: Rebased on latest netdev-next/master.
> >>>>
> >>>> David, please take this into net-next as soon as possible.  When the
> >>>> IPA code was merged the other day this prerequisite patch was not
> >>>> included, and as a result the IPA driver fails to build.  Thank you.
> >>>>
> >>>>   See: https://lkml.org/lkml/2020/3/10/1839
> >>>>
> >>>>                                      -Alex
> >>>
> >>> In particular, this seems to now have regressed into mainline for the 5.7
> >>> merge window as reported by Linaro's ToolChain Working Group's CI.
> >>> Link: https://github.com/ClangBuiltLinux/linux/issues/963
> >>
> >> Is the problem you're referring to the result of a build done
> >> in the midst of a bisect?
> >>
> >> The fix for this build error is currently present in the
> >> torvalds/linux.git master branch:
> >>     6fcd42242ebc soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
> >
> > Is that right? That patch is in mainline, but looks unrelated to what
> > I'm referring to.
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6fcd42242ebcc98ebf1a9a03f5e8cb646277fd78
> > From my github link above, the issue I'm referring to is a
> > -Wimplicit-function-declaration warning related to field_max.
> > 6fcd42242ebc doesn't look related.
>
> I'm very sorry, I pointed you at the wrong commit.  This one is
> also present in torvalds/linux.git master:
>
>   e31a50162feb bitfield.h: add FIELD_MAX() and field_max()
>
> It defines field_max() as a macro in <linux/bitfield.h>, and
> "gsi.c" includes that header file.
>
> This was another commit that got added late, after the initial
> IPA code was accepted.

Yep, that looks better.

>
> >> I may be mistaken, but I believe this is the same problem I discussed
> >> with Maxim Kuvyrkov this morning.  A different build problem led to
> >> an automated bisect, which conluded this was the cause because it
> >> landed somewhere between the initial pull of the IPA code and the fix
> >> I reference above.
> >
> > Yes, Maxim runs Linaro's ToolChain Working Group (IIUC, but you work
> > there, so you probably know better than I do), that's the CI I was
> > referring to.
> >
> > I'm more concerned when I see reports of regressions *in mainline*.
> > The whole point of -next is that warnings reported there get fixed
> > BEFORE the merge window opens, so that we don't regress mainline.  Or
> > we drop the patches in -next.
>
> Can you tell me where I can find the commit id of the kernel
> that is being built when this error is reported?  I would
> like to examine things and build it myself so I can fix it.
> But so far haven't found what I need to check out.

From the report: https://groups.google.com/g/clang-built-linux/c/pX-kr_t5l_A
Configuration details:
rr[llvm_url]="https://github.com/llvm/llvm-project.git"
rr[linux_url]="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
rr[linux_branch]="7111951b8d4973bda27ff663f2cf18b663d15b48"

the linux_branch looks like a SHA of what the latest ToT of mainline
was when the CI ran.

I was suspecting that maybe there was a small window between the
regression, and the fix, and when the bot happened to sync.  But it
seems that: e31a50162feb352147d3fc87b9e036703c8f2636 landed before
7111951b8d4973bda27ff663f2cf18b663d15b48 IIUC.

So I think the bot had your change when it ran, so still seeing a
failure is curious.  Unless I've misunderstood something.
-- 
Thanks,
~Nick Desaulniers
