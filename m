Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D547C43E2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfJAWmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:42:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43155 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbfJAWmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:42:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id h126so12944052qke.10;
        Tue, 01 Oct 2019 15:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+zhlHN/fTqmnxM9L6qJyhZ0omHE+zf/8t/LKy4/Cic=;
        b=lIuD47uHbBIqiU1l0S0t2XTTIdclnUmu2uSjP/hErK3iWXzzTHTiZuI25y645Fd87Z
         AsJRwhM1T5I3VvXMeVjGkqSTMtiR4rmPHPHiWQIrqi0RfEyPjgpk/xXIsGJUWgXv/yqr
         I0Ad/EumwH2Jk2U9s4a9DkhmDR082XnDVJCLA+9UFcUb83o+BSwcS0N9j5fy1f1NFKNG
         ogDa3ZGDSCnEIXFBe3nIW1pHWxvKJtxDm1Mx0poT5rme0NzTNDIQzGC6NLQnl0CxMNwK
         AmRDncHNfN1MlIRHlD/b0dUVx6SSJ9HLThJyzA9S+N7BbkQgaUVyjz+aaxxFCwv/XfEp
         2GPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+zhlHN/fTqmnxM9L6qJyhZ0omHE+zf/8t/LKy4/Cic=;
        b=aiBoPc/fcOrwEhGN2X36CcUk99+7Pcv8SPPE7SGtOg/SxIQvKuMyDC7mhGjeeQWNuG
         +ogrwfWiN3m/7Bs2VWyQMt2SlTsT1petRL5mKSqJcusdCP3FDQuB9C2rRjwuUmp6gTKn
         yqBaNyw+UFjzExHWOD26jwgLmWnO4lnDxI9QjSNbRLcBm2M5D940+o+EXrARaaDhtHeZ
         dBt/UboGmWaGNKZZ4GfX54e8m/Q2PnPRfahLYj58MX4hAUMmnhTCbGNV6C1USBhoc1w5
         GPV6mXlQZ3XGRVUGklOccJMyrUeLZUy4N6lXtauATCw7evVi9h4JeNh/A9c/uRaH3zXr
         Rgfg==
X-Gm-Message-State: APjAAAWgME8mAxlsMehT8h44tXYwZNSA1MDd/8TRVt5sNgkY8MChb93/
        PLI/exM6N2S3TXNuGjCDxyMeRyNV0+hDp5IC1vg=
X-Google-Smtp-Source: APXvYqwJWclvXF4NfrKas2/fUmG21QWzGh8oQUIR3h0RIx7JzSj4RmzD/jrzsPcfUMYeBSplri3i7pUEGGWt/AFoyyU=
X-Received: by 2002:a37:98f:: with SMTP id 137mr577480qkj.449.1569969757198;
 Tue, 01 Oct 2019 15:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com> <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
 <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com>
In-Reply-To: <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 15:42:25 -0700
Message-ID: <CAEf4BzYodrr1u14XQM04TU57SH3ViSbqh76Lh2d3QtksvS24hA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO helpers
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 2:46 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 1, 2019, at 2:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> Add few macros simplifying BCC-like multi-level probe reads, while also
> >>> emitting CO-RE relocations for each read.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++-
> >>> 1 file changed, 147 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >>> index a1d9b97b8e15..51e7b11d53e8 100644
> >>> --- a/tools/lib/bpf/bpf_helpers.h
> >>> +++ b/tools/lib/bpf/bpf_helpers.h
> >>> @@ -19,6 +19,10 @@
> >>> */
> >>> #define SEC(NAME) __attribute__((section(NAME), used))
> >>>
> >>> +#ifndef __always_inline
> >>> +#define __always_inline __attribute__((always_inline))
> >>> +#endif
> >>> +
> >>> /* helper functions called from eBPF programs written in C */
> >>> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> >>>      (void *) BPF_FUNC_map_lookup_elem;
> >>> @@ -505,7 +509,7 @@ struct pt_regs;
> >>> #endif
> >>>
> >>> /*
> >>> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> >>> + * bpf_core_read() abstracts away bpf_probe_read() call and captures field
> >>> * relocation for source address using __builtin_preserve_access_index()
> >>> * built-in, provided by Clang.
> >>> *
> >>> @@ -520,8 +524,147 @@ struct pt_regs;
> >>> * actual field offset, based on target kernel BTF type that matches original
> >>> * (local) BTF, used to record relocation.
> >>> */
> >>> -#define BPF_CORE_READ(dst, src)                                              \
> >>> -     bpf_probe_read((dst), sizeof(*(src)),                           \
> >>> -                    __builtin_preserve_access_index(src))
> >>> +#define bpf_core_read(dst, sz, src)                                      \
> >>> +     bpf_probe_read(dst, sz,                                             \
> >>> +                    (const void *)__builtin_preserve_access_index(src))
> >>> +
> >>> +/*
> >>> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
> >>> + * additionally emitting BPF CO-RE field relocation for specified source
> >>> + * argument.
> >>> + */
> >>> +#define bpf_core_read_str(dst, sz, src)                                          \
> >>> +     bpf_probe_read_str(dst, sz,                                         \
> >>> +                        (const void *)__builtin_preserve_access_index(src))
> >>> +
> >>> +#define ___concat(a, b) a ## b
> >>> +#define ___apply(fn, n) ___concat(fn, n)
> >>> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...) N
> >>
> >> We are adding many marcos with simple names: ___apply(), ___nth. So I worry
> >> they may conflict with macro definitions from other libraries. Shall we hide
> >> them in .c files or prefix/postfix them with _libbpf or something?
> >
> > Keep in mind, this is the header that's included from BPF code.
> >
> > They are prefixed with three underscores, I was hoping it's good
> > enough to avoid accidental conflicts. It's unlikely someone will have
> > macros with the same names **in BPF-side code**.
>
> BPF side code would include kernel headers. So there are many headers
> to conflict with. And we won't know until somebody want to trace certain
> kernel structure.

We have all the kernel sources at our disposal, there's no need to
guess :) There is no instance of ___apply, ___concat, ___nth,
___arrow, ___last, ___nolast, or ___type, not even speaking about
other more specific names. There are currently two instances of
"____last_____" used in a string. And I'm certainly not afraid that
user code can use triple-underscored identifier with exact those names
and complain about bpf_helpers.h :)

>
> > Prefixing with _libbpf is an option, but it will make it super ugly
> > and hard to follow (I've spent a bunch of time to even get it to the
> > current state), so I'd like to avoid that.
>
> BPF programs will not use these marcos directly, so I feel it is OK to
> pay the pain of _libbpf prefix, as it is contained within this file.

I disagree, having more convoluted multi-line macros will eventually
lead to a stupid mistake or typo, which could have been spotted
otherwise. Plus, if user screws up (which is inevitable anyway) usage
of these macro, he will be presented with long and incomprehensible
chain of macro with more obscure names than necessary. If you think
that internal names don't matter, ask anyone who had to decipher
compilation errors involving C++ standard library templates. I'd be OK
with that if there was a real risk of name conflict, but I disagree
with the premise.

>
> Thanks,
> Song
>
>
>
