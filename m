Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E92804BA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgJARLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732213AbgJARLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4AC0613D0;
        Thu,  1 Oct 2020 10:11:37 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u4so5288619ljd.10;
        Thu, 01 Oct 2020 10:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OQfLRcAOWIw59NGfi9I7ckeREQIiyms4IQUXnhx6Cus=;
        b=rlOFvsv5FwPcqIxobQWQ1xGP+0tJz/39SJOrkdvVSsV2wDiuwU5KtbGGXd8gIbfp7G
         Fz6lUfVfTVmWLBGLtXoNYw5eQVGBSPylBSM3LLMgoQm4rNGuGouXPYPxnh5b13Tm6Xi/
         9jPJPlx3TXKfi033zJMImDtn2B5KDHOfFKLm8ZfRLsh+Y0sx58PzJsqcJJEKBqrvyZL9
         Jr47hoX3ChaN1NL8tf5GQ3cxM6fo30suy5NHN4V+pORPKwttTDAZCMYDKrnEEXCAZcNd
         UveDzaVg6YnTHEkgTsI9lAszviyJ9DZloRmnuFfD3pgbdjAZWcP20KqEgSuwfQYx84YY
         1N2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OQfLRcAOWIw59NGfi9I7ckeREQIiyms4IQUXnhx6Cus=;
        b=DEQUbGVKQeVaeRSUrEcGh6QNbfNb0vvgf1VrenOMNb2cvlchPFXne3X8ZZRgz25MfK
         9rcEXbUi2+3wvvXeOKzgpfFqjIwiljbl4NjbJy3/BDoEXlTWo8EtiscfTgew8hVAfvbo
         B73cXXyC5ZP7+2PavLnPjmebJ52hOj1F/eMHh/+LBiquIA93e+/n8i1k6W6tuZmEUutQ
         396CB3ZCwddo1Mx1Ydkw34WJxBaJYaDP9eE++O11kS5bebdx/R9aWfUmvimtYdpdlk1L
         boul2CWqAqoByr4lTMATJZOTgquPbzOseNdLUxmJ8ZRamV8pirLrLYC5lvf9pWOehKv+
         R7xA==
X-Gm-Message-State: AOAM531biNBTMijuF9DOIiSr7byuXBq+trL9Ce7FZhhwBjVbLFDlwZhs
        7E02hF43mVKkQvuSpRCxdI92idifpt/PLBzMGKA=
X-Google-Smtp-Source: ABdhPJxbusDTVfGWazhL3Hy3TeKApmIaH1qJcr83UTbUoH5BawhRrulOUmnUjCsEXKnbJ0c6OAv7vgNv5W0mkEGmYro=
X-Received: by 2002:a2e:7014:: with SMTP id l20mr2810578ljc.91.1601572295556;
 Thu, 01 Oct 2020 10:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200928090805.23343-1-lmb@cloudflare.com> <20200928090805.23343-3-lmb@cloudflare.com>
 <20200929055851.n7fa3os7iu7grni3@kafai-mbp> <CAADnVQLwpWMea1rbFAwvR_k+GzOphaOW-kUGORf90PJ-Ezxm4w@mail.gmail.com>
 <CACAyw98WzZGcFnnr7ELvbCziz2axJA_7x2mcoQTf2DYWDYJ=KA@mail.gmail.com>
 <20201001072348.hxhpuoqmeln6twxw@ast-mbp.dhcp.thefacebook.com> <CAEf4Bzbjzj3wwxX84bLi-PLy=9+Bpe1bTDt=t0qR5t=xEkNjwQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzbjzj3wwxX84bLi-PLy=9+Bpe1bTDt=t0qR5t=xEkNjwQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Oct 2020 10:11:23 -0700
Message-ID: <CAADnVQJQeiyrN2JzOwV+zHDU5xg4TtpT0w9MgG6nujCK5z+GNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare
 socket cookies
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 10:09 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 1, 2020 at 12:25 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Sep 30, 2020 at 10:28:33AM +0100, Lorenz Bauer wrote:
> > > On Tue, 29 Sep 2020 at 16:48, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > ...
> > >
> > > > There was a warning. I noticed it while applying and fixed it up.
> > > > Lorenz, please upgrade your compiler. This is not the first time su=
ch
> > > > warning has been missed.
> > >
> > > I tried reproducing this on latest bpf-next (b0efc216f577997) with gc=
c
> > > 9.3.0 by removing the initialization of duration:
> > >
> > > make: Entering directory '/home/lorenz/dev/bpf-next/tools/testing/sel=
ftests/bpf'
> > >   TEST-OBJ [test_progs] sockmap_basic.test.o
> > >   TEST-HDR [test_progs] tests.h
> > >   EXT-OBJ  [test_progs] test_progs.o
> > >   EXT-OBJ  [test_progs] cgroup_helpers.o
> > >   EXT-OBJ  [test_progs] trace_helpers.o
> > >   EXT-OBJ  [test_progs] network_helpers.o
> > >   EXT-OBJ  [test_progs] testing_helpers.o
> > >   BINARY   test_progs
> > > make: Leaving directory '/home/lorenz/dev/bpf-next/tools/testing/self=
tests/bpf'
> > >
> > > So, gcc doesn't issue a warning. Jakub did the following little exper=
iment:
> > >
> > > jkbs@toad ~/tmp $ cat warning.c
> > > #include <stdio.h>
> > >
> > > int main(void)
> > > {
> > >         int duration;
> > >
> > >         fprintf(stdout, "%d", duration);
> > >
> > >         return 0;
> > > }
> > > jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> > > warning.c: In function =E2=80=98main=E2=80=99:
> > > warning.c:7:2: warning: =E2=80=98duration=E2=80=99 is used uninitiali=
zed in this
> > > function [-Wuninitialized]
> > >     7 |  fprintf(stdout, "%d", duration);
> > >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > >
> > > The simple case seems to work. However, adding the macro breaks thing=
s:
> > >
> > > jkbs@toad ~/tmp $ cat warning.c
> > > #include <stdio.h>
> > >
> > > #define _CHECK(duration) \
> > >         ({                                                      \
> > >                 fprintf(stdout, "%d", duration);                \
> > >         })
> > > #define CHECK() _CHECK(duration)
> > >
> > > int main(void)
> > > {
> > >         int duration;
> > >
> > >         CHECK();
> > >
> > >         return 0;
> > > }
> > > jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> > > jkbs@toad ~/tmp $
> >
> > That's very interesting. Thanks for the pointers.
> > I'm using gcc version 9.1.1 20190605 (Red Hat 9.1.1-2)
> > and I saw this warning while compiling selftests,
> > but I don't see it with above warning.c example.
> > clang warns correctly in both cases.
>
> I think this might be the same problem I fixed for libbpf with [0].
> Turns out, GCC explicitly calls out (somewhere in their docs) that
> uninitialized variable warnings work only when compiled in optimized
> mode, because some internal data structures used to detect this are
> only maintained in optimized mode build.
>
> Laurenz, can you try compiling your example with -O2?

All of my experiments I did with -O2.

>   [0] https://patchwork.ozlabs.org/project/netdev/patch/20200929220604.83=
3631-2-andriin@fb.com/
>
> >
> > > Maybe this is https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D18501 ? =
The
> > > problem is still there on gcc 10. Compiling test_progs with clang doe=
s
> > > issue a warning FWIW, but it seems like other things break when doing
> > > that.
> >
> > That gcc bug has been opened since transition to ssa. That was a huge
> > transition for gcc. But I think the bug number is not correct. It point=
s to a
> > different issue. I've checked -fdump-tree-uninit-all dump with and with=
out
> > macro. They're identical. The tree-ssa-uninit pass suppose to warn, but=
 it
> > doesn't. I wish I had more time to dig into it. A bit of debugging in
> > gcc/tree-ssa-uninit.c can probably uncover the root cause.
