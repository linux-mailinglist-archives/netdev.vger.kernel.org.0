Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7B4369D8E
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhDWXt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhDWXtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:49:24 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE660C061574;
        Fri, 23 Apr 2021 16:48:46 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j4so40402988lfp.0;
        Fri, 23 Apr 2021 16:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fpzvVXRbI+u20074xQkgdiaHG+ICSMEtOJduAuWa8Q=;
        b=sH3ToGG04aDqpxI01EsuPm+7POHfESa64EjYir1K3/t2jIwAPA3zxTY+q0Jk5NOZMd
         OUa2DL/c00omqt7+dkhKkZevSqER5AsWT4DnCD3lVvFcA/+PZAuCfZKqPQm6kejNtgzz
         eg39Dp14cktQyXuzTNIHUZK7f66E8x/YI02fucdISCgHDWl2izdfzHJv1dHpMiAegAJA
         D7CeWWm40wYszxEr5CLphf0Q7frwsjCQ/toqOU4eRQ1iKa3DQMxX1NmxzlV7UPbkhVAS
         x8UzqBzy3T70eT9t8wTlECl86Rdn03BXuRRmFrBxwW6Nd5LP/p5zs8qn1T3vHyDDrrm4
         F3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+fpzvVXRbI+u20074xQkgdiaHG+ICSMEtOJduAuWa8Q=;
        b=TjjdLsQcKX6vipfaXr2oKn1+e3fqPqjrE8/Cv5bJ22qSIBcMg+Wh+q35x6a3pSL9N1
         R732050qO4Oea1H5gbRqqhcjbAzSJoh/h0uNiRF47Gyqd+lilGXjLLitASP2c9+xDcUB
         IYpdeRRSVuhO/lVmE7kRfEEjZM5FCxLbgCtFmrIfQbAiMGCAzhjo83iyuGE31U3Xw7Xf
         1WZ/Lb45cCy3+kur0EpH1ZGYgk62EQn88pE9amRdlz9ibw0w8mxr7Y0/J6ZOaQIwDQK+
         Chz7clOZmkyUaDNuSIck4eeUmYRN4Rm1Y5UH7+P2Vgm0HI8GLAeJrEWU+ql8vrDJFPGu
         ll0g==
X-Gm-Message-State: AOAM530koCsDbu4HSvE8BGAIEm9aARUaE/p+BcvJXXMOjIxkaXfvTH50
        2SXilsmHNZ04b8uqZdoYlgLhSQyh+MwY3d6x/h4=
X-Google-Smtp-Source: ABdhPJy1vqMPfbW4YLEzsTYPa1gDiuAmClSaGLuOgniswDYDWMKS1oh0pJOG6GVtwwb8ZbJBS+wAKzA4zrRdi/pbgAM=
X-Received: by 2002:ac2:491a:: with SMTP id n26mr4615031lfi.539.1619221725119;
 Fri, 23 Apr 2021 16:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
In-Reply-To: <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 16:48:34 -0700
Message-ID: <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:35 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> > > >>>
> > > >>> -static volatile const __u32 print_len;
> > > >>> -static volatile const __u32 ret1;
> > > >>> +volatile const __u32 print_len = 0;
> > > >>> +volatile const __u32 ret1 = 0;
> > > >>
> > > >> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> > > >> this is not in a static link test, right? The same for a few tests below.
> > > >
> > > > All the selftests are passed through a static linker, so it will
> > > > append obj_name to each static variable. So I just minimized use of
> > > > static variables to avoid too much code churn. If this variable was
> > > > static, it would have to be accessed as
> > > > skel->rodata->bpf_iter_test_kern4__print_len, for example.
> > >
> > > Okay this should be fine. selftests/bpf specific. I just feel that
> > > some people may get confused if they write/see a single program in
> > > selftest and they have to use obj_varname format and thinking this
> > > is a new standard, but actually it is due to static linking buried
> > > in Makefile. Maybe add a note in selftests/README.rst so we
> > > can point to people if there is confusion.
> >
> > I'm not sure I understand.
> > Are you saying that
> > bpftool gen object out_file.o in_file.o
> > is no longer equivalent to llvm-strip ?
> > Since during that step static vars will get their names mangled?
>
> Yes. Static vars and static maps. We don't allow (yet?) static
> entry-point BPF programs, so those don't change.
>
> > So a good chunk of code that uses skeleton right now should either
> > 1. don't do the linking step
> > or
> > 2. adjust their code to use global vars
> > or
> > 3. adjust the usage of skel.h in their corresponding user code
> >   to accommodate mangled static names?
> > Did it get it right?
>
> Yes, you are right. But so far most cases outside of selftest that
> I've seen don't use static variables (partially because they need
> pesky volatile to be visible from user-space at all), global vars are
> much nicer in that regard.

Right.
but wait...
why linker is mangling them at all and why they appear in the skeleton?
static vars without volatile should not be in a skeleton, since changing
them from user space might have no meaning on the bpf program.
The behavior of the bpf prog is unpredictable.
Only volatile static can theoretically be in the skeleton, but as you said
probably no one is using them yet, so we can omit them from skeleton too.
