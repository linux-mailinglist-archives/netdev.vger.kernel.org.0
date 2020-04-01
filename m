Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE819B85F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 00:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733008AbgDAW1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 18:27:08 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40690 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDAW1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 18:27:07 -0400
Received: by mail-pj1-f68.google.com with SMTP id kx8so673933pjb.5
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/5I5n44oluC7i5iMGc1kCApSIMH8aU+TEHJYNftWu74=;
        b=PSwVlgPtuIY/hJbpB3m2prpdGLQvhpH1sfXsOEzX7CzUuAZ1h/SMVcUjR75F0HJb33
         F626YuNjcRK4M1QEgz/Ng7ZDyADmtbfWc3sTyqpSM9ZPyRWssvVUAoF2aRXSVlLEpAHU
         C00grz1kxYmJOgxOpIqsvDI5AVVRLjvNmz121Q96uUIG4WucrydsJsyqD795OU+A1M0C
         4PxbUycDLk2pWZK5osYG1a14Nj3S3qwp57uxvaueuyLA+1+7GtxBxh3Wukisq5wCDtjo
         ecL5yRbgh1Le8MvvKJ85oOmDFlXclOrCTjs9BnjOLhtFmNhH8OcPQTH3Z4lSTgKMRwbb
         eM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5I5n44oluC7i5iMGc1kCApSIMH8aU+TEHJYNftWu74=;
        b=dv2ZHq3fu2+/XnHL6an7oV5P+4VE747JfOD16Ms32GuNalkUDtqmntm0wWOfJYgnQw
         ZP8TKY0ZYrnK5RR3EIW3behM5OhscwkakP1plIdbI8rg0lUOPzrkcfZ6c3q9gDQPkKcS
         8VAmVTzJD8BEh/hS2LDJksPT6UYvL6SWLP7cfucNLNFNzvIWZuyqxIE7EeMP0OpViUta
         SFDPSVuAieH47KFzSKfRAVUAExUz1E6jqh5rZmcgwXUW/HSHZtyop5GDNUroZPu8n9T8
         O9TCWQS7Me/ayCsG4dwSbsUdOo8a772EMcOSDBFhgI52irnXKr75NkShLqww8hsZDA79
         SsRQ==
X-Gm-Message-State: AGi0PuYWHzMf9Rvc1Yiw3+U2E1NwS48p91d5yS6sBE/eQTbCRKYrCRsC
        VG7ETrHtpDrH5am7+Qlh+bgvAt85tIR2y/UVdq9Plw==
X-Google-Smtp-Source: APiQypKFmS9i5vrVXurU9AIyS4H2bg7yQQ8XLjc9cH4MSta9jqwsJx028ulHFt+NlUrYgc4aJURFgE1cqiSLrH6cnRs=
X-Received: by 2002:a17:90b:230d:: with SMTP id mt13mr247965pjb.164.1585780024565;
 Wed, 01 Apr 2020 15:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200311024240.26834-1-elder@linaro.org> <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org> <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
 <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org> <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
 <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org>
In-Reply-To: <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 1 Apr 2020 15:26:53 -0700
Message-ID: <CAKwvOdnZ9KL1Esmdjvk-BTP2a+C24bOWguNVaU3RSXKi1Ouh+w@mail.gmail.com>
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

On Wed, Apr 1, 2020 at 1:21 PM Alex Elder <elder@linaro.org> wrote:
>
> On 4/1/20 2:54 PM, Nick Desaulniers wrote:
> > On Wed, Apr 1, 2020 at 12:44 PM Alex Elder <elder@linaro.org> wrote:
> >>
> >> Can you tell me where I can find the commit id of the kernel
> >> that is being built when this error is reported?  I would
> >> like to examine things and build it myself so I can fix it.
> >> But so far haven't found what I need to check out.
> >
> > From the report: https://groups.google.com/g/clang-built-linux/c/pX-kr_t5l_A
>
> That link doesn't work for me.

Sigh, second internal bug filed against google groups this
week...settings look correct but I too see a 404 when in private
browsing mode.

>
> > Configuration details:
> > rr[llvm_url]="https://github.com/llvm/llvm-project.git"
> > rr[linux_url]="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
> > rr[linux_branch]="7111951b8d4973bda27ff663f2cf18b663d15b48"
>
> That commit is just the one in which Linux v5.6 is tagged.
> It doesn't include any of this code (but it's the last
> tagged release that current linus/master is built on).
>
> It doesn't answer my question about what commit id was
> used for this build, unfortunately.

7111951b8d4973bda27ff663f2cf18b663d15b48 *is* the commit id that was
used for the build.  It sync'd the mainline tree at that commit.

> > the linux_branch looks like a SHA of what the latest ToT of mainline
> > was when the CI ran.
> >
> > I was suspecting that maybe there was a small window between the
> > regression, and the fix, and when the bot happened to sync.  But it
> > seems that: e31a50162feb352147d3fc87b9e036703c8f2636 landed before
> > 7111951b8d4973bda27ff663f2cf18b663d15b48 IIUC.
>
> Yes, this:
>   e31a50162feb bitfield.h: add FIELD_MAX() and field_max()
> landed about 200 commits after the code that needed it.
>
> So there's a chance the kernel that got built was somewhere
> between those two, and I believe the problem you point out
> would happen in that case.  This is why I started by asking
> whether it was something built during a bisect.
>
> It's still not clear to me what happened here.  I can explain
> how this *could* happen, but I don't believe problem exists
> in the latest upstream kernel commit.
>
> Is there something else you think I should do?

mainline is hosed for aarch64 due to some dtc failures.  I'm not sure
how TCWG's CI chooses the bisection starting point, but if mainline
was broken, and it jumped back say 300 commits, then the automated
bisection may have converged on your first patch, but not the second.

I just checked out mainline @ 7111951b8d4973bda27ff663f2cf18b663d15b48
and couldn't reproduce, so I assume the above is what happened.  So
sorry for the noise, I'll go investigate the dtc failure.  Not sure
how that skipped -next coverage.
-- 
Thanks,
~Nick Desaulniers
