Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F5B6EC3C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbfGSVtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 17:49:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45273 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbfGSVtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 17:49:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so24383494qkj.12;
        Fri, 19 Jul 2019 14:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NEswzuVxTJS8R9/L3zo+AoBMKV3REzuHNhYJyRMu7eU=;
        b=DI8rbU6pyanTKWmhmM97d3WzQGiRGQIQ1JqgLB4kWJFhXf5tib5YvyWtfbmFNV/2HL
         xZ7NyiFTCxG6UoIngtXsrIotMfMBxXcdjiMeaXRioRDFA8R8l3I/JJ04Ck/sttt0nqoX
         UjIB2bq7HWQftwAGdY7AdS/7TJJMs46ATGXADfKPRPm4mPMEkd4/dbn7DlQki9rNiR4V
         lfIQJlHIIr4k+13IHdQ10Zb+J0jb0mpVR6WJzg2sTqOih/ykC3Dz5yGCb19CgxJv8Nbw
         uDJrOxi+Vh5rub09zJT+ivyO/ZkaBWaCmsxk2VehVXM76Vh62F6W9HGhba3MlWmuJUCq
         r11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NEswzuVxTJS8R9/L3zo+AoBMKV3REzuHNhYJyRMu7eU=;
        b=lDwBgmXQVFQgYfO/GShLcb8U/DSlgdQiitjSkC72baT+BGHTkEn46QGLCUQh/6TmTg
         xS+x6GMMns27ZHE7jhGQRld3YfIauQIFGnzv4nzryNCXneJqvydOCOtSukJJjobd8zxd
         axM1jAOL/e2NJ/zvROzFhSTTRy46izf9ITslMEKMVzNpaqclaXzuYZecYegKKUihUiIc
         TvYQNvluSugESJoFiFMW9cCY7c2BbdpkI/pyjgKHeqe4KmpwsXx7CpVo01gOM/xAJaAl
         qYRkg4KatfvGrzBAxbTXLF5PDGolryDgoRvvHziGdx8NUIv+SrY4H9wqNXkUyf2t2oSH
         pk4Q==
X-Gm-Message-State: APjAAAVWHgR+RTamdlIrKorE25+MGYnUBEzV1PkV4T65hgGq3pMSo2dh
        RKjk0zfHkSOnbKpWfZygFb12wNNBrMWDvPTZ4dM=
X-Google-Smtp-Source: APXvYqz1bts+9nZkcsOPF9cjUmY8jbAl9YlQOrpODDFi83QWSVAVUsIx5lW8Ujk+gMfWK/zgqJq2oyzCtE/5ebuDwxA=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr36821517qkj.39.1563572945464;
 Fri, 19 Jul 2019 14:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org> <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org> <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
 <20190719181423.GO3624@kernel.org> <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
 <20190719183417.GQ3624@kernel.org> <CAEf4Bzb6Dfup+aRuWLyTj3=-Nyq3wWGsLXRSX7s=aMVs8WBiWQ@mail.gmail.com>
 <20190719202703.GR3624@kernel.org>
In-Reply-To: <20190719202703.GR3624@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jul 2019 14:48:54 -0700
Message-ID: <CAEf4BzYQSmXyA0r79QfXJPLGg2vpmkhV03SncRndBEWzko6bKA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 1:27 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, Jul 19, 2019 at 01:04:32PM -0700, Andrii Nakryiko escreveu:
> > On Fri, Jul 19, 2019 at 11:34 AM Arnaldo Carvalho de Melo
> > <arnaldo.melo@gmail.com> wrote:
> > >
> > > Em Fri, Jul 19, 2019 at 11:26:50AM -0700, Andrii Nakryiko escreveu:
> > > > On Fri, Jul 19, 2019 at 11:14 AM Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> > > > > Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> > > > > > Ok, did some more googling. This warning (turned error in your setup)
> > > > > > is emitted when -Wshadow option is enabled for GCC/clang. It appears
> > > > > > to be disabled by default, so it must be enabled somewhere for perf
> > > > > > build or something.
> > >
> > > > > Right, I came to the exact same conclusion, doing tests here:
> > >
> > > > > [perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
> > > > > shadow_global_decl.c: In function 'main':
> > > > > shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
> > > > > shadow_global_decl.c:4: warning: shadowed declaration is here
> > > > > [perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
> > > > > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> > > > > [perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
> > > > > [perfbuilder@3a58896a648d tmp]$
> > >
> > > > > So I'm going to remove this warning from the places where it causes
> > > > > problems.
> > >
> > > > > > Would it be possible to disable it at least for libbpf when building
> > > > > > from perf either everywhere or for those systems where you see this
> > > > > > warning? I don't think this warning is useful, to be honest, just
> > > > > > random name conflict between any local and global variables will cause
> > > > > > this.
> > >
> > > > > Yeah, I might end up having this applied.
> > >
> > > > Thanks!
> > >
> > > So, I'm ending up with the patch below, there is some value after all in
> > > Wshadow, that is, from gcc 4.8 onwards :-)
> >
> > I agree with the intent, but see below.
> >
> > >
> > > - Arnaldo
> > >
> > > diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> > > index 495066bafbe3..ded7a950dc40 100644
> > > --- a/tools/scripts/Makefile.include
> > > +++ b/tools/scripts/Makefile.include
> > > @@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
> > >  EXTRA_WARNINGS += -Wold-style-definition
> > >  EXTRA_WARNINGS += -Wpacked
> > >  EXTRA_WARNINGS += -Wredundant-decls
> > > -EXTRA_WARNINGS += -Wshadow
> > >  EXTRA_WARNINGS += -Wstrict-prototypes
> > >  EXTRA_WARNINGS += -Wswitch-default
> > >  EXTRA_WARNINGS += -Wswitch-enum
> > > @@ -69,8 +68,16 @@ endif
> > >  # will do for now and keep the above -Wstrict-aliasing=3 in place
> > >  # in newer systems.
> > >  # Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
> > > +#
> > > +# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
> > > +# that takes into account Linus's comments (search for Wshadow) for the reasoning about
> > > +# -Wshadow not being interesting before gcc 4.8.
> > > +
> > >  ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3
> >
> > This is checking make version, not GCC version. So code comment and
> > configurations are not in sync?
>
> Ah, I should have added a few lines back:
>
> # Hack to avoid type-punned warnings on old systems such as RHEL5:
> # We should be changing CFLAGS and checking gcc version, but this
> # will do for now and keep the above -Wstrict-aliasing=3 in place
> # in newer systems.
> # Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
> #
> # See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
> # that takes into account Linus's comments (search for Wshadow) for the reasoning about
> # -Wshadow not being interesting before gcc 4.8.
>
>
> In time I'll try and get it to use the gcc version to be strict.

Oh well, if it's how it's done right now :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> - Arnaldo
