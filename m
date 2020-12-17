Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375B72DCE17
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgLQJG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQJGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:06:54 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D528EC06138C
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 01:06:13 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id o13so32289492lfr.3
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 01:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vAO/2/47mbhlLw+965PNTisNKeQzGGv2Q/ZDNBlq8ho=;
        b=ug3HU0/BD5jHUI6DBI3tUcGDLe5Vi0dADf7CQjmuw/ZLMEvO78n6LoGbJVJ9/LH/oY
         02XfSpETFlVPf2/TuFtgteUxWs4gqgZd8XpPPXZqFJ+3W7fYS2Mo4+z/BVYuNpus6vtz
         pyZo35hXAxYxPKHwOWQEa28G/ws1llfu1/sO/dgTA2sCj2CHq+PjFNtbH5wP9b92HQTt
         CUhhGqnd82VO3vyy5jObExl/xwXUQsiT+DVOkAQGGLq1JmbCb+tOKMnYVsNUdxnvshLX
         AD/iJCQ8RHOTiwU9+j7lRaeJCvbkpPvketTDkElKJfk82Cv9xmcLl4GgDQXxLVZm4TIP
         EXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vAO/2/47mbhlLw+965PNTisNKeQzGGv2Q/ZDNBlq8ho=;
        b=R/5XGW4iUmm3857OE/QPP0mSvmCZj8lX40hYB1H0zZ1WTEl7yKmx/oqljt8Zq8uFV1
         PTcg5JXqsJ2kJv+mhqy6vhasE/OYpiWYq7592jO2H3zs4IxZlxx9psYnorYAfNg36Q+/
         K+R/GI19gIvaCSyeYSvnUH4RJHF/h2BTDEZ0FagdTcNqyirBB2ITCLddRrnbohG+b4lN
         E0wnKoKb3sFGi/9pyoGuJJgid7d0o+voCuOXmCooRlhq7si765XogYWSwHSYFL+e51WD
         dlnnj5KWXvTiV60onMbYMs959xGssO3egvYf06KFgMK94y6oZdJHWRO+ic+cNbM9FSPy
         4u6w==
X-Gm-Message-State: AOAM530GkH0yTWtDR31EnvJfXhdiS4N9E9OzLcv5P6MwIDnwfC9Fg4As
        vie5hhK8BZNyvgvpTaT2vU3vRQrmXyBiNJ4LJqiw9g==
X-Google-Smtp-Source: ABdhPJxsq2p+kthVsRGDbdBPYMJuYG963MsSL6IXTPPE/fUcPdixmm5ttc1CfxGFCERB7fPnA+WDEJZLkKAp9rbYRAA=
X-Received: by 2002:a05:6512:30a:: with SMTP id t10mr911692lfp.124.1608195972094;
 Thu, 17 Dec 2020 01:06:12 -0800 (PST)
MIME-Version: 1.0
References: <20201119085022.3606135-1-davidgow@google.com> <CAEf4BzY4i0fH34eO=-4WOzVpifgPmJ0ER5ipBJWB0_4Zdv0AQg@mail.gmail.com>
 <CABVgOSn10kCaD7EQCMJTgD8udNx6fOExqUL1gXHzEViemiq3LA@mail.gmail.com> <3678c6eb-3815-a360-f495-fc246513f0f5@isovalent.com>
In-Reply-To: <3678c6eb-3815-a360-f495-fc246513f0f5@isovalent.com>
From:   David Gow <davidgow@google.com>
Date:   Thu, 17 Dec 2020 17:05:59 +0800
Message-ID: <CABVgOSmRrtHQ_6n43kFk6MFYCpf+cS-E=TOiwS=__v6wGNeMNQ@mail.gmail.com>
Subject: Re: [RFC PATCH] bpf: preload: Fix build error when O= is set
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-um <linux-um@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 10:53 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-11-21 17:48 UTC+0800 ~ David Gow <davidgow@google.com>
> > On Sat, Nov 21, 2020 at 3:38 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Thu, Nov 19, 2020 at 12:51 AM David Gow <davidgow@google.com> wrote:
> >>>
> >>> If BPF_PRELOAD is enabled, and an out-of-tree build is requested with
> >>> make O=<path>, compilation seems to fail with:
> >>>
> >>> tools/scripts/Makefile.include:4: *** O=.kunit does not exist.  Stop.
> >>> make[4]: *** [../kernel/bpf/preload/Makefile:8: kernel/bpf/preload/libbpf.a] Error 2
> >>> make[3]: *** [../scripts/Makefile.build:500: kernel/bpf/preload] Error 2
> >>> make[2]: *** [../scripts/Makefile.build:500: kernel/bpf] Error 2
> >>> make[2]: *** Waiting for unfinished jobs....
> >>> make[1]: *** [.../Makefile:1799: kernel] Error 2
> >>> make[1]: *** Waiting for unfinished jobs....
> >>> make: *** [Makefile:185: __sub-make] Error 2
> >>>
> >>> By the looks of things, this is because the (relative path) O= passed on
> >>> the command line is being passed to the libbpf Makefile, which then
> >>> can't find the directory. Given OUTPUT= is being passed anyway, we can
> >>> work around this by explicitly setting an empty O=, which will be
> >>> ignored in favour of OUTPUT= in tools/scripts/Makefile.include.
> >>
> >> Strange, but I can't repro it. I use make O=<absolute path> all the
> >> time with no issues. I just tried specifically with a make O=.build,
> >> where .build is inside Linux repo, and it still worked fine. See also
> >> be40920fbf10 ("tools: Let O= makes handle a relative path with -C
> >> option") which was supposed to address such an issue. So I'm wondering
> >> what exactly is causing this problem.
> >>
> > [+ linux-um list]
> >
> > Hmm... From a quick check, I can't reproduce this on x86, so it's
> > possibly a UML-specific issue.
> >
> > The problem here seems to be that $PWD is, for whatever reason, equal
> > to the srcdir on x86, but not on UML. In general, $PWD behaves pretty
> > weirdly -- I don't fully understand it -- but if I add a tactical "PWD
> > := $(shell pwd)" or use $(CURDIR) instead, the issue shows up on x86
> > as well. I guess this is because PWD only gets updated when set by a
> > shell or something, and UML does this somewhere?
> >
> > Thoughts?
> >
> > Cheers,
> > -- David
>
> Hi David, Andrii,
>
> David, did you use a different command for building for UML and x86? I'm
> asking because I reproduce on x86, but only for some targets, in
> particular when I tried bindeb-pkg.

I just ran "make ARCH={x86,um} O=.bpftest", with defconfig + enabling
BPF_PRELOAD and its dependencies. UML fails, x86 works. (Though I can
reproduce the failure if I make bindeb-pkg on x86).

(It also shows up when building UML with the allyesconfig-based KUnit
alltests option by running "./tools/testing/kunit/kunit.py run
--alltests", though this understandably takes a long time and is less
obvious)
>
> With "make O=.build vmlinux", I have:
> - $(O) for "dummy" check in tools/scripts/Makefile.include set to
> /linux/.build
> - $(PWD) for same check set to /linux/tools
> - Since $(O) is an absolute path, the "dummy" check passes
>
> With "make O=.build bindeb-pkg", I have instead:
> - $(O) set to .build (relative path)
> - $(PWD) set to /linux/.build
> - "dummy" check changes to /linux/.build and searches for .build in it,
> which fails and aborts the build
>
> (tools/scripts/Makefile.include is included from libbpf's Makefile,
> called from kernel/bpf/preload/Makefile.)
>
> I'm not sure how exactly the bindeb-pkg target ends up passing these values.

Yeah: I haven't been able to find where uml is changing them either:
I'm assuming there's something which changes directory and/or spawns a
shell/recursive make to change $(PWD) or something.

> For what it's worth, I have been solving this (before finding this
> thread) with a fix close to yours, I pass "O=$(abspath .)" on the
> command line for building libbpf in kernel/bpf/preload/Makefile. It
> looked consistent to me with the "tools/:" target from the main
> Makefile, where "O=$(abspath $(objtree))" is passed (and $(objtree) is ".").

Given that there are several targets being broken here, it's probably
worth having a fix like this which overrides O= rather than trying to
hunt down every target which could change $(PWD). I don't particularly
mind whether we use O= or O=$(abspath .), both are working in the UML
usecase as well.

Does anyone object to basically accepting either this patch as-is, or
using O=$(abspath .)?


Cheers,
-- David
