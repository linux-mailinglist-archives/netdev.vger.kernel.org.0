Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D4829DA59
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbgJ1XU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgJ1XUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:20:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60C5C0613CF;
        Wed, 28 Oct 2020 16:20:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so718520pfp.13;
        Wed, 28 Oct 2020 16:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QpR8TC1oMS/pyz+0lkIsbuGK0UvTAps68WiPoj0vOkk=;
        b=CmyBrQOhx5K9RZRU8QdkydCNb90kVH2wAJ4cGpJW/jLxYvwxepACFkf0/yG9+1xdhh
         WXRH4eVAVEAE03U3AFTOQ1zz5qRihal2i5eCpJI1RlqycaRhohiRpcolkziMfDbT4W2b
         SXHJ9egryYky8g6t7w8+uXML+Y9x0YyLp2a6pkwdFy5p4MQwhE/uWK7qEo1bHkugIiBr
         3vuvMqbWY9r3CQ+gvI2GBt2BWcy0URSCjmw3J97MRC3K/ZSAbR+EdY8g5svCYUbXu2a5
         2CCqdmXb/vUlKBUZuedByF0RFaTTYg/KEGMUO4pmn4XM3PhZyZXY+xwn+K+cF96qK/oe
         QrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QpR8TC1oMS/pyz+0lkIsbuGK0UvTAps68WiPoj0vOkk=;
        b=UxlLPMml7hpp0NXdW6DA+9ydfjtS84muAVrPaSb6NZiDBqNoUwWd7Fgd3Z7w5Ae5ye
         mzirb9BcOM5cTEtd4at852AceF20RR/54ziTESxziXFoYCIghvRcRXzLFHk5WzXueGBa
         X9TgXiCTz2lLK+BIhzXkwrzdQp2xc/NI0m96zuz4ULIVsE0auKVwyMB/B4P9B4M9ex9/
         QdJ4MHRMx4+JC35DH3NpwNyrYIInz+u5NpeP+aSUTZxhQYR+23rCkeIvofjrZshPmczP
         n9ONVOnko73ZKdtxebuINRSU7TLvD3O6QdjMqDRYJmVWtPgGedTL65gNp5HW5yQAuZUb
         BSYw==
X-Gm-Message-State: AOAM530+Kqb8FlNDUxHONm5Oph0xFxKypRAEE+f1M0MK9bS9ILPk8w9V
        Q58O6cf0uYp9e6WwWgHAhTo=
X-Google-Smtp-Source: ABdhPJzdbwYGvpax5ZHTsqKT+DkN7U38pm+keRWCcL1dfxhaILbRn0/0WdEqd9EtvIyLNfitkPiOig==
X-Received: by 2002:a62:8c81:0:b029:164:3789:5478 with SMTP id m123-20020a628c810000b029016437895478mr1302967pfd.44.1603927205364;
        Wed, 28 Oct 2020 16:20:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id 3sm675785pfv.92.2020.10.28.16.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 16:20:04 -0700 (PDT)
Date:   Wed, 28 Oct 2020 16:20:01 -0700
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
Message-ID: <20201028232001.pp7erdwft7oyt2xm@ast-mbp.dhcp.thefacebook.com>
References: <20201028171506.15682-1-ardb@kernel.org>
 <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
 <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 12:10:52AM +0100, Ard Biesheuvel wrote:
> On Wed, 28 Oct 2020 at 23:59, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 11:15:04PM +0100, Ard Biesheuvel wrote:
> > > On Wed, 28 Oct 2020 at 22:39, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 28, 2020 at 06:15:05PM +0100, Ard Biesheuvel wrote:
> > > > > Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
> > > > > ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> > > > > function scope __attribute__((optimize("-fno-gcse"))), to disable a
> > > > > GCC specific optimization that was causing trouble on x86 builds, and
> > > > > was not expected to have any positive effect in the first place.
> > > > >
> > > > > However, as the GCC manual documents, __attribute__((optimize))
> > > > > is not for production use, and results in all other optimization
> > > > > options to be forgotten for the function in question. This can
> > > > > cause all kinds of trouble, but in one particular reported case,
> > > > > it causes -fno-asynchronous-unwind-tables to be disregarded,
> > > > > resulting in .eh_frame info to be emitted for the function.
> > > > >
> > > > > This reverts commit 3193c0836, and instead, it disables the -fgcse
> > > > > optimization for the entire source file, but only when building for
> > > > > X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> > > > > original commit states that CONFIG_RETPOLINE=n triggers the issue,
> > > > > whereas CONFIG_RETPOLINE=y performs better without the optimization,
> > > > > so it is kept disabled in both cases.
> > > > >
> > > > > Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > > > Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > ---
> > > > >  include/linux/compiler-gcc.h   | 2 --
> > > > >  include/linux/compiler_types.h | 4 ----
> > > > >  kernel/bpf/Makefile            | 6 +++++-
> > > > >  kernel/bpf/core.c              | 2 +-
> > > > >  4 files changed, 6 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > > > index d1e3c6896b71..5deb37024574 100644
> > > > > --- a/include/linux/compiler-gcc.h
> > > > > +++ b/include/linux/compiler-gcc.h
> > > > > @@ -175,5 +175,3 @@
> > > > >  #else
> > > > >  #define __diag_GCC_8(s)
> > > > >  #endif
> > > > > -
> > > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > >
> > > > See my reply in the other thread.
> > > > I prefer
> > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > > >
> > > > Potentially with -fno-asynchronous-unwind-tables.
> > > >
> > >
> > > So how would that work? arm64 has the following:
> > >
> > > KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
> > >
> > > ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
> > > KBUILD_CFLAGS += -ffixed-x18
> > > endif
> > >
> > > and it adds -fpatchable-function-entry=2 for compilers that support
> > > it, but only when CONFIG_FTRACE is enabled.
> >
> > I think you're assuming that GCC drops all flags when it sees __attribute__((optimize)).
> > That's not the case.
> >
> 
> So which flags does it drop, and which doesn't it drop? Is that
> documented somewhere? Is that the same for all versions of GCC?
> 
> > > Also, as Nick pointed out, -fno-gcse does not work on Clang.
> >
> > yes and what's the point?
> > #define __no_fgcse is GCC only. clang doesn't need this workaround.
> >
> 
> Ah ok, that's at least something.
> 
> > > Every architecture will have a different set of requirements here. And
> > > there is no way of knowing which -f options are disregarded when you
> > > use the function attribute.
> > >
> > > So how on earth are you going to #define __no-fgcse correctly for
> > > every configuration imaginable?
> > >
> > > > __attribute__((optimize("")) is not as broken as you're claiming to be.
> > > > It has quirky gcc internal logic, but it's still widely used
> > > > in many software projects.
> > >
> > > So it's fine because it is only a little bit broken? I'm sorry, but
> > > that makes no sense whatsoever.
> > >
> > > If you insist on sticking with this broken construct, can you please
> > > make it GCC/x86-only at least?
> >
> > I'm totally fine with making
> > #define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > to be gcc+x86 only.
> > I'd like to get rid of it, but objtool is not smart enough to understand
> > generated asm without it.
> 
> I'll defer to the x86 folks to make the final call here, but I would
> be perfectly happy doing
> 
> index d1e3c6896b71..68ddb91fbcc6 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -176,4 +176,6 @@
>  #define __diag_GCC_8(s)
>  #endif
> 
> +#ifdef CONFIG_X86
>  #define __no_fgcse __attribute__((optimize("-fno-gcse")))
> +#endif

If you're going to submit this patch could you please add
,-fno-omit-frame-pointer
to the above as well?

> and end the conversation here, because I honestly cannot wrap my head
> around the fact that you are willing to work around an x86 specific
> objtool shortcoming by arbitrarily disabling some GCC optimization for
> all architectures, using a construct that may or may not affect other
> compiler settings in unpredictable ways, where the compiler is being
> used to compile a BPF language runtime for executing BPF programs
> inside the kernel.
> 
> What on earth could go wrong?

Frankly I'm move worried that -Os will generate incorrect code.
All compilers have bugs. Kernel has bugs. What can go wrong?
