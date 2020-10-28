Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3429D9A8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389918AbgJ1XAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbgJ1W70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:59:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD04C0613CF;
        Wed, 28 Oct 2020 15:59:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so733500pgb.10;
        Wed, 28 Oct 2020 15:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qnI8nWNHxXfz/36ET+4hZk5JXm++Qwhi5Ah20jjyj2o=;
        b=hV/Z2rqpW5/VZLyfKsj2Vk2Ds7oKV6R9pla5olRvc5RTDoG5/rGjkoUbNVNU7/xIbg
         ou2gfoHRB39OMjQ6D9AnuaLT3YMQWts9HEX5k8IdVlB8tWTCah1i3qHKq9YQFq60G1sj
         iDvuqiauiEIzJMKEunSgqpWxa6P1SWxNENV4OPIAiCvoFdcg9KD54hj1H6kBS8D1iPu6
         vzgTtRWRcuHgv6fcNtQgvaejsIRhCozBcwFyeFdyBerKQXTi/zKXmLf6YWGFuZDyRwgE
         5s53J9YYHAsxPhqHEYK3PhUsq7pfxMmkcb9ewrDC0cdKFGcBuJHGHfBgIA70IQq+JlmQ
         PpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qnI8nWNHxXfz/36ET+4hZk5JXm++Qwhi5Ah20jjyj2o=;
        b=AsB6knSCdSrKIJ/Zy9Gkgpt2t9Kzgab6tSIrnNexxv9m0C0J98ZQTS2T3E/AcDGXM9
         v30DoOdkT4OOAAWn8pBJinEqPnF2JDvUcGNiQ98MFpFqXUerdKfyO0TGuqMsmsD2ooES
         O4bK+c3XMYCgcgyY1RqUOeIE/lXBoW+HxB0bDgzdSsS8PCgOlvCAAR7FnKXZS27fcviZ
         0vfjsgTAX97ZVDho2CMElks3orq8KljyZhZxmwMwbbKuGQw2jk/1mUyXSeiXlHt7/479
         imYEWCEMom68Z3mhzcWYIT5FCsGQA4EYsq1dONJygO5zyrgBZTz6JvoO0k5/h9w1wVIm
         ddDw==
X-Gm-Message-State: AOAM530Qg1QEWaxZ8faGNKbNJdXT5ohVA7hp4KrOziKf4bn8LESEvf2x
        E5skC1LttojwKWUk9g41MGs=
X-Google-Smtp-Source: ABdhPJxb1pj/t22ch7rMjU86YmShVsQt9WxMBA837//MBQUyk8n9HbsoNTEppCMJr2PK4KUyuo9M1Q==
X-Received: by 2002:a63:481d:: with SMTP id v29mr1401896pga.448.1603925965757;
        Wed, 28 Oct 2020 15:59:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id nm11sm470323pjb.24.2020.10.28.15.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 15:59:25 -0700 (PDT)
Date:   Wed, 28 Oct 2020 15:59:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
Message-ID: <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
References: <20201028171506.15682-1-ardb@kernel.org>
 <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:15:04PM +0100, Ard Biesheuvel wrote:
> On Wed, 28 Oct 2020 at 22:39, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 06:15:05PM +0100, Ard Biesheuvel wrote:
> > > Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
> > > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > > GCC specific optimization that was causing trouble on x86 builds, and
> > > was not expected to have any positive effect in the first place.
> > >
> > > However, as the GCC manual documents, __attribute__((optimize))
> > > is not for production use, and results in all other optimization
> > > options to be forgotten for the function in question. This can
> > > cause all kinds of trouble, but in one particular reported case,
> > > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > > resulting in .eh_frame info to be emitted for the function.
> > >
> > > This reverts commit 3193c0836, and instead, it disables the -fgcse
> > > optimization for the entire source file, but only when building for
> > > X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> > > original commit states that CONFIG_RETPOLINE=n triggers the issue,
> > > whereas CONFIG_RETPOLINE=y performs better without the optimization,
> > > so it is kept disabled in both cases.
> > >
> > > Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  include/linux/compiler-gcc.h   | 2 --
> > >  include/linux/compiler_types.h | 4 ----
> > >  kernel/bpf/Makefile            | 6 +++++-
> > >  kernel/bpf/core.c              | 2 +-
> > >  4 files changed, 6 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > index d1e3c6896b71..5deb37024574 100644
> > > --- a/include/linux/compiler-gcc.h
> > > +++ b/include/linux/compiler-gcc.h
> > > @@ -175,5 +175,3 @@
> > >  #else
> > >  #define __diag_GCC_8(s)
> > >  #endif
> > > -
> > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> >
> > See my reply in the other thread.
> > I prefer
> > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> >
> > Potentially with -fno-asynchronous-unwind-tables.
> >
> 
> So how would that work? arm64 has the following:
> 
> KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
> 
> ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> KBUILD_CFLAGS += -ffixed-x18
> endif
> 
> and it adds -fpatchable-function-entry=2 for compilers that support
> it, but only when CONFIG_FTRACE is enabled.

I think you're assuming that GCC drops all flags when it sees __attribute__((optimize)).
That's not the case.

> Also, as Nick pointed out, -fno-gcse does not work on Clang.

yes and what's the point?
#define __no_fgcse is GCC only. clang doesn't need this workaround.

> Every architecture will have a different set of requirements here. And
> there is no way of knowing which -f options are disregarded when you
> use the function attribute.
> 
> So how on earth are you going to #define __no-fgcse correctly for
> every configuration imaginable?
> 
> > __attribute__((optimize("")) is not as broken as you're claiming to be.
> > It has quirky gcc internal logic, but it's still widely used
> > in many software projects.
> 
> So it's fine because it is only a little bit broken? I'm sorry, but
> that makes no sense whatsoever.
> 
> If you insist on sticking with this broken construct, can you please
> make it GCC/x86-only at least?

I'm totally fine with making
#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
to be gcc+x86 only.
I'd like to get rid of it, but objtool is not smart enough to understand
generated asm without it.
