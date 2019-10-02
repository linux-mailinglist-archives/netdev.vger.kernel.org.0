Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF872C4638
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfJBDg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:36:29 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40826 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfJBDg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:36:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id f7so24567326qtq.7;
        Tue, 01 Oct 2019 20:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wr1dz0ND0YRnSIIhDRLhPmk69qxu+wirQlUy2V+tg60=;
        b=M8wJtm1ekWSm7OExh4G69T54jd7HjwaELYaghFsNj8lJSNQm/QVnJku++8YNmjgoj8
         PgkfJEoeFBvhXp6zm4W6CpYTzyD1HJ+W+Z2t6ws7j835nsvX++LrhcyDTda743YItSiC
         hHm4S6LjHSDJUp/SAGbUR3arznx9OzghV+wCOIkGZ6iNRZo55Fy+kF+lz3pIHEaTLWWi
         8HMu9Y4F3kLwxKbBHz/j4w6zycUkIna/aO4OHT/fiZBie+XR4AzGkNGEQgNRDoI3DBV7
         jBok2vsRW9bcZ1ZfIEg1qXb4qf3plqzPHE616CHUsgUFLyAiNTXAx9QjStc53FOZmTKi
         TBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wr1dz0ND0YRnSIIhDRLhPmk69qxu+wirQlUy2V+tg60=;
        b=UnVAhG2ukPGIWVita2mb21WcSHtsDInLKMzkmlAJayfboiGTVCqTM8YABbtqcCruHd
         wyUcLrn6yIJDxF3PKx8gcUJF/WezYFKPL0qiDGdUfh1J6zYBVn7Lk1ayY4sLFoAy6Eiy
         cYK7LXq/PaYqeK/0Ptkke7U62ng2aLRVQ/EozbJ/0zzoOD0/apCz64+ItsSXjZnc/xb+
         4wlgXp+gFLSzKxavpgskIDGeppdH59ZsZTDqS3HpAvJ6L9kswFoMmWu7pi3kG7KbdSvM
         oniXtF0zYL7pKJPJ35U0cjBXZTu38pbRZxB7VoKE9MQwTPj9cZ5mVySFMiiz9XlR3hfv
         8qgg==
X-Gm-Message-State: APjAAAXdOc//xBPeFY+h0nJP5dzLMXV0CCUkDbWybzGWC3BeAaMeLNAX
        Ut2AF7SZtBKy77HVO3RkQUaeU2H3pJBOcMJrKgQ=
X-Google-Smtp-Source: APXvYqx4GjP+i+7xxCEfshhXXfXUOfGyJOapXWCUhr4T4zxceYFO/K3Lacou06ZzgBtCzyzM3wwr4glbvH5zejsOs24=
X-Received: by 2002:aed:2726:: with SMTP id n35mr1868224qtd.171.1569987387751;
 Tue, 01 Oct 2019 20:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com> <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
 <7D24AAB3-32DF-4806-808A-B84E461F6BCD@fb.com> <CAEf4BzYodrr1u14XQM04TU57SH3ViSbqh76Lh2d3QtksvS24hA@mail.gmail.com>
 <7B064E41-189A-427A-82A7-C8BD5B5421A3@fb.com>
In-Reply-To: <7B064E41-189A-427A-82A7-C8BD5B5421A3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 20:36:16 -0700
Message-ID: <CAEf4BzbKjSapFmffvsPfX4toaTA=_J4q9WfFtfy_xOHSthTWLQ@mail.gmail.com>
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

On Tue, Oct 1, 2019 at 4:44 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 1, 2019, at 3:42 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 1, 2019 at 2:46 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Oct 1, 2019, at 2:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>>>
> >>>>> Add few macros simplifying BCC-like multi-level probe reads, while also
> >>>>> emitting CO-RE relocations for each read.
> >>>>>
> >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>>>> ---
> >>>>> tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++-
> >>>>> 1 file changed, 147 insertions(+), 4 deletions(-)
> >>>>>
> >>>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >>>>> index a1d9b97b8e15..51e7b11d53e8 100644
> >>>>> --- a/tools/lib/bpf/bpf_helpers.h
> >>>>> +++ b/tools/lib/bpf/bpf_helpers.h
> >>>>> @@ -19,6 +19,10 @@
> >>>>> */
> >>>>> #define SEC(NAME) __attribute__((section(NAME), used))
> >>>>>
> >>>>> +#ifndef __always_inline
> >>>>> +#define __always_inline __attribute__((always_inline))
> >>>>> +#endif
> >>>>> +
> >>>>> /* helper functions called from eBPF programs written in C */
> >>>>> static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> >>>>>     (void *) BPF_FUNC_map_lookup_elem;
> >>>>> @@ -505,7 +509,7 @@ struct pt_regs;
> >>>>> #endif
> >>>>>
> >>>>> /*
> >>>>> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> >>>>> + * bpf_core_read() abstracts away bpf_probe_read() call and captures field
> >>>>> * relocation for source address using __builtin_preserve_access_index()
> >>>>> * built-in, provided by Clang.
> >>>>> *
> >>>>> @@ -520,8 +524,147 @@ struct pt_regs;
> >>>>> * actual field offset, based on target kernel BTF type that matches original
> >>>>> * (local) BTF, used to record relocation.
> >>>>> */
> >>>>> -#define BPF_CORE_READ(dst, src)                                              \
> >>>>> -     bpf_probe_read((dst), sizeof(*(src)),                           \
> >>>>> -                    __builtin_preserve_access_index(src))
> >>>>> +#define bpf_core_read(dst, sz, src)                                      \
> >>>>> +     bpf_probe_read(dst, sz,                                             \
> >>>>> +                    (const void *)__builtin_preserve_access_index(src))
> >>>>> +
> >>>>> +/*
> >>>>> + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
> >>>>> + * additionally emitting BPF CO-RE field relocation for specified source
> >>>>> + * argument.
> >>>>> + */
> >>>>> +#define bpf_core_read_str(dst, sz, src)                                          \
> >>>>> +     bpf_probe_read_str(dst, sz,                                         \
> >>>>> +                        (const void *)__builtin_preserve_access_index(src))
> >>>>> +
> >>>>> +#define ___concat(a, b) a ## b
> >>>>> +#define ___apply(fn, n) ___concat(fn, n)
> >>>>> +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...) N
> >>>>
> >>>> We are adding many marcos with simple names: ___apply(), ___nth. So I worry
> >>>> they may conflict with macro definitions from other libraries. Shall we hide
> >>>> them in .c files or prefix/postfix them with _libbpf or something?
> >>>
> >>> Keep in mind, this is the header that's included from BPF code.
> >>>
> >>> They are prefixed with three underscores, I was hoping it's good
> >>> enough to avoid accidental conflicts. It's unlikely someone will have
> >>> macros with the same names **in BPF-side code**.
> >>
> >> BPF side code would include kernel headers. So there are many headers
> >> to conflict with. And we won't know until somebody want to trace certain
> >> kernel structure.
> >
> > We have all the kernel sources at our disposal, there's no need to
> > guess :) There is no instance of ___apply, ___concat, ___nth,
> > ___arrow, ___last, ___nolast, or ___type, not even speaking about
> > other more specific names. There are currently two instances of
> > "____last_____" used in a string. And I'm certainly not afraid that
> > user code can use triple-underscored identifier with exact those names
> > and complain about bpf_helpers.h :)
>
> I worry more about _future_ conflicts, that someone may add ___apply to

You can say the same about pretty much any name that user might use,
that's just the fact of life with C language without namespaces. I
don't think that justifies usage of obscure names.

Look at SEC macro, for instance. It's also an enum value in
drivers/sbus/char/oradax.c, but it might some day end up in one of
driver's headers. This is probably not a reason to rename it, though.

> some kernel header file and break some BPF programs. Since these BPF
> programs are not in-tree, it is very difficult to test them properly.
> We have had name conflicts from other libraries, so I hope we don't create
> more ourselves.

Let's agree to come back to this problem when and if we ever encounter
it. All those ___xxx macro are internal and users shouldn't rely on
them, which means if we ever get a real conflict, we'll be able to
rename them to avoid the conflict.

>
> Thanks,
> Song
