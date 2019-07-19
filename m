Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539156EB70
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 22:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbfGSUEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 16:04:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38664 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGSUEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 16:04:44 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so24161378qkk.5;
        Fri, 19 Jul 2019 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgzbnyihRsw5YwTm7SdiFF/zXhcaOpif95Kf3MqJxBY=;
        b=P0+v4hJrU8jqZSNngmeP7/FXPteQB0Dx84Z0ggbNG42+cxT84wlm6NRuIGK3mkqLxG
         ofS9GFmbUExt7b5uNYvs+83qh/XXFlQz/1MA9VQQ3Ocu9tNpZ5r4pWlX5WnLHlQV7toQ
         jNW1KaP0GQ4azRxarWFymz2vu+mldivdMuouHnGRq8xsuQGNxtI6GBQWmeN/9JMZ+nkc
         JG2W8Nd3qj4ew5YX1rakVmCuZKjOxl/+keUVxgwPIMo7VTjPcJvfYH3wwigx00M/F0PL
         mWwjKfUPHhLSC44oLDrlRqBx8b9SCIntDdqbyt7YBPzNHiMbw2oZ9Tnm0+6UQGXZM7BG
         BvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgzbnyihRsw5YwTm7SdiFF/zXhcaOpif95Kf3MqJxBY=;
        b=sefcYwPVvg0KI/rt5qL61h3yLlU9QH5HD7EDcYLA65RR6r9I4ZTg593veZGcixiMnw
         7AfV1ZSox+3dazqFFCGxVDYrCzkRnMKZcM4TSVPs1JD21gr4RDernfr5us6w/onz4a5Z
         3WQM9XaQU/7at8md+5L08QXn6hjfk1D8gZqMpvdR6Z0yWK9dMB6BIODkKvbhDhXP5+0N
         ZzIbpx1AIBxTxOIGuXUrOrtfucc5L1bkCPFoNpcRvclPWF1N/55HUnhumPKitGX6MMTJ
         xjZdQG0HyPYIyzw9iyHAisNK1pmChE+X36nN8wfPBt9/yYpZQq9uOrea5J9m+qcLogbq
         Rx3w==
X-Gm-Message-State: APjAAAW3T+qIwcyya0wIc9OdFm1l6Qz5skOxJIBMn9o+XqScwFhVFHWV
        wNSO3CxtGwthCEkgs6jn9PpsTYF3BOKXIiaFSdQucO3S
X-Google-Smtp-Source: APXvYqzeRSpz2YxRkp57icEpaASDSR1b/c8uGpQ5DxBVTEvjIKmj+n5EoFQT33OMXuUkApGXQEmNTekrxUxC3fPkLec=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr38532135qke.449.1563566683627;
 Fri, 19 Jul 2019 13:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com> <20190718175533.GG2093@redhat.com>
 <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org> <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org> <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
 <20190719181423.GO3624@kernel.org> <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
 <20190719183417.GQ3624@kernel.org>
In-Reply-To: <20190719183417.GQ3624@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jul 2019 13:04:32 -0700
Message-ID: <CAEf4Bzb6Dfup+aRuWLyTj3=-Nyq3wWGsLXRSX7s=aMVs8WBiWQ@mail.gmail.com>
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

On Fri, Jul 19, 2019 at 11:34 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, Jul 19, 2019 at 11:26:50AM -0700, Andrii Nakryiko escreveu:
> > On Fri, Jul 19, 2019 at 11:14 AM Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> > > Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> > > > Ok, did some more googling. This warning (turned error in your setup)
> > > > is emitted when -Wshadow option is enabled for GCC/clang. It appears
> > > > to be disabled by default, so it must be enabled somewhere for perf
> > > > build or something.
>
> > > Right, I came to the exact same conclusion, doing tests here:
>
> > > [perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
> > > shadow_global_decl.c: In function 'main':
> > > shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
> > > shadow_global_decl.c:4: warning: shadowed declaration is here
> > > [perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
> > > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> > > [perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
> > > [perfbuilder@3a58896a648d tmp]$
>
> > > So I'm going to remove this warning from the places where it causes
> > > problems.
>
> > > > Would it be possible to disable it at least for libbpf when building
> > > > from perf either everywhere or for those systems where you see this
> > > > warning? I don't think this warning is useful, to be honest, just
> > > > random name conflict between any local and global variables will cause
> > > > this.
>
> > > Yeah, I might end up having this applied.
>
> > Thanks!
>
> So, I'm ending up with the patch below, there is some value after all in
> Wshadow, that is, from gcc 4.8 onwards :-)

I agree with the intent, but see below.

>
> - Arnaldo
>
> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index 495066bafbe3..ded7a950dc40 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
>  EXTRA_WARNINGS += -Wold-style-definition
>  EXTRA_WARNINGS += -Wpacked
>  EXTRA_WARNINGS += -Wredundant-decls
> -EXTRA_WARNINGS += -Wshadow
>  EXTRA_WARNINGS += -Wstrict-prototypes
>  EXTRA_WARNINGS += -Wswitch-default
>  EXTRA_WARNINGS += -Wswitch-enum
> @@ -69,8 +68,16 @@ endif
>  # will do for now and keep the above -Wstrict-aliasing=3 in place
>  # in newer systems.
>  # Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
> +#
> +# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
> +# that takes into account Linus's comments (search for Wshadow) for the reasoning about
> +# -Wshadow not being interesting before gcc 4.8.
> +
>  ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3

This is checking make version, not GCC version. So code comment and
configurations are not in sync?

>  EXTRA_WARNINGS += -fno-strict-aliasing
> +EXTRA_WARNINGS += -Wno-shadow
> +else
> +EXTRA_WARNINGS += -Wshadow
>  endif
>
>  ifneq ($(findstring $(MAKEFLAGS), w),w)
