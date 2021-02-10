Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0177931701E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhBJT1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhBJT1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:27:20 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61874C061574;
        Wed, 10 Feb 2021 11:26:40 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id k4so3158906ybp.6;
        Wed, 10 Feb 2021 11:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VzO1bqpMJImT5RV7mr89RUBHcVHZ35uVed+4sC5IZ4=;
        b=aQcijUs+fTXzrXWQa4JWSb+1a1Ms0K4LCKg+xsXXpFww6vDv6mPLRMuuDBTd6zGW26
         QAL4rncqbvjSWqbgjCFtW8vu4ve7X2vzRC7Jow0LqgyY3/L0b/LLlN/Jh9AYdlqmuL3X
         Bj3W0eELRxOaUV/RlE+9+OVP6V3geu6Q3rP8QpAYiFBzV5VNIG/WkFcVh/zXCt/V/mGk
         xBg2ikBz6O2ylLZWIYsx/L8fnYbNkvTL4AlbdA+UicnH+GbRR7s03kff9pGKTyvjH00p
         OulRtgucxGzYwo+uPHIAY4uIoHNQmrxlH8TAL59tjPSlBLrpmDIVQ8o7I/7K/fvD1u8V
         +YUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VzO1bqpMJImT5RV7mr89RUBHcVHZ35uVed+4sC5IZ4=;
        b=WNLYlsI5Y/LQCcHGaz6BaozahinQBEz7Ckan64i5kpzXS9jiHIvVqSqdfKPsVuU48C
         sOnQ7lvwMgodzTN9zw79EIDVIpQBmINd8VSZ6zrKtUqsw41Zb8NLo7dNy4bPKZvzqm1i
         49+xucVw13j6ShsW94RRh5Wh9A0Ns6jlJIjzlkqQfb/NPxAbvjzmxagXmwW+rlGqkHi4
         LTZSoTgZm4Q6519gAw2ZA5W+VcUwBlaOR+6MnptMriYESFXO4Ycavv2T6CdEvZhF0IPk
         Aa9pZd2brOQCedxNlT2KI6s7mzqYZe0YxySdizXNOB6MR36zhU8rJKQ+GKXa44wsG/wd
         HIMg==
X-Gm-Message-State: AOAM5332ySih/tOnvwrShc3T0aMNB1AncSFs8rkWGv4Yh/vLJE2bGeMx
        jUd1QbDG6A1XlUKTWR/YssEs2gPAHqx6tqi5mQ4=
X-Google-Smtp-Source: ABdhPJyrF+s2ZhWmNsgbn5N3OGtEFd/y5SUnTrGjDxHYjiKoYBbidC5C3JxmWqLCVoecf4/ute1bLV2QtQWYDoCA5es=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr6127943yba.403.1612985199531;
 Wed, 10 Feb 2021 11:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86> <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86> <YCQmCwBSQuj+bi4q@krava>
In-Reply-To: <YCQmCwBSQuj+bi4q@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 11:26:28 -0800
Message-ID: <CAEf4BzbwwtqerxRrNZ75WLd2aHLdnr7wUrKahfT7_6bjBgJ0xQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:29 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 10, 2021 at 11:02:15AM -0700, Nathan Chancellor wrote:
> > On Wed, Feb 10, 2021 at 09:52:42AM -0800, Andrii Nakryiko wrote:
> > > On Wed, Feb 10, 2021 at 9:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
> > > >
> > > > On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> > > > > The resolve_btfids tool is used during the kernel build,
> > > > > so we should clean it on kernel's make clean.
> > > > >
> > > > > Invoking the the resolve_btfids clean as part of root
> > > > > 'make clean'.
> > > > >
> > > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >  Makefile | 7 ++++++-
> > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Makefile b/Makefile
> > > > > index b0e4767735dc..159d9592b587 100644
> > > > > --- a/Makefile
> > > > > +++ b/Makefile
> > > > > @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
> > > > >    endif
> > > > >  endif
> > > > >
> > > > > +PHONY += resolve_btfids_clean
> > > > > +
> > > > > +resolve_btfids_clean:
> > > > > +     $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > > > > +
> > > > >  ifdef CONFIG_BPF
> > > > >  ifdef CONFIG_DEBUG_INFO_BTF
> > > > >    ifeq ($(has_libelf),1)
> > > > > @@ -1495,7 +1500,7 @@ vmlinuxclean:
> > > > >       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > > > >       $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > > > >
> > > > > -clean: archclean vmlinuxclean
> > > > > +clean: archclean vmlinuxclean resolve_btfids_clean
> > > > >
> > > > >  # mrproper - Delete all generated files, including .config
> > > > >  #
> > > > > --
> > > > > 2.26.2
> > > > >
> > > >
> > > > This breaks running distclean on a clean tree (my script just
> > > > unconditionally runs distclean regardless of the tree state):
> > > >
> > > > $ make -s O=build distclean
> > > > ../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > > >
> > >
> > > Can't reproduce it. It works in all kinds of variants (relative and
> > > absolute O=, clean and not clean trees, etc). Jiri, please check as
> > > well.
> > >
> >
> > Odd, this reproduces for me on a completely clean checkout of bpf-next:
> >
> > $ git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> >
> > $ cd bpf-next
> >
> > $ make -s O=build distclean
> > ../../scripts/Makefile.include:4: *** O=/tmp/bpf-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> >
> > I do not really see how this could be environment related. It seems like
> > this comes from tools/scripts/Makefile.include, where there is no
> > guarantee that $(O) is created before being used like in the main
> > Makefile?
>
> right, we need to handle the case where tools/bpf/resolve_btfids
> does not exist, patch below fixes it for me
>
> jirka
>

Looks good to me, please send it as a proper patch to bpf-next.

But I'm curious, why is objtool not doing something like that? Is it
not doing clean at all? Or does it do it in some different way?

>
> ---
> diff --git a/Makefile b/Makefile
> index 159d9592b587..ce9685961abe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1088,8 +1088,14 @@ endif
>
>  PHONY += resolve_btfids_clean
>
> +resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
> +
> +# tools/bpf/resolve_btfids directory might not exist
> +# in output directory, skip its clean in that case
>  resolve_btfids_clean:
> -       $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> +ifneq (,$(wildcard $(resolve_btfids_O)))

nit: kind of backwards, usually it's in a `ifneq($var,)` form

> +       $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
> +endif
>
>  ifdef CONFIG_BPF
>  ifdef CONFIG_DEBUG_INFO_BTF
>
