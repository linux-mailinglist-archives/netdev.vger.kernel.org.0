Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072293D7F7F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhG0Utr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0Utq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:49:46 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EABC061757;
        Tue, 27 Jul 2021 13:49:46 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id s19so199550ybc.6;
        Tue, 27 Jul 2021 13:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bas5UVt2W1vU/voQ8R2arXrfi794+5825d/MjT9oGMU=;
        b=SzJnxA8uPLDM9y/lsjQu6zhSpPdKOt4k9U+G0Mqwi2xJ2ITJWj16hd3eRbRnqAp73G
         Orj/9r7eIRcRUXad4KSfEeoQtFRwJzukm2f15XMMAevyX7FvkmaRMMSybhxJMEPx8kZ+
         vaNytNMKTN8tjqVE05PWX0bQ1HXum55aSltR0sr99xYQuABfdu6xXOaapBJwTYVu7YGG
         t/w8XTmRoW2WtSidKLl1JnmmS3hhSQ3kmSZS8Alq5/128d948xXJ+AdAPwgPoNaXAvsH
         Se8c9KSDC/gTz5nCFQb8m5wC6EyxvGPaxaoueIX8T+Os/1BFTCEgzRfsMSNCaIdmlFbd
         GrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bas5UVt2W1vU/voQ8R2arXrfi794+5825d/MjT9oGMU=;
        b=rRU6HCkQ/6oKi1gZPU6I/T9QgAVRqTgzJCBJDfjoAbmApohKS+E2454gWYHt5Z10qk
         cNVGnXPoxDIi+n97U3mDoUwj8EJTMMtrjz7p5A1acQDmnCfD4nC5llHMTxsqb1yOPDkv
         u/inj/BJXn1L7tpcYNh4egv7f5/gPl0kdTWfUjCHuuJM4PB0wqGpzhiPhUzTNT+K0wm3
         VSr6SSAtKcX4CNp/oFibr+dq9E/BSsQDoQKVoHzPUdxqsvWLqze9EpI8q2VtF6+WeOdO
         bZ7xhWoclRDtSi6w7HNT0UCmIu1aVn9JrAQNcQa5G16sjHRqZ17hoB7U3OvZUH1F+tsS
         72EA==
X-Gm-Message-State: AOAM532yFo+ZeSdp5FPc3eoSpEk8fIb0E1gju0QLtK1Jf/0ZPfdkwGRJ
        MFHRSH+2NqhjSgSYTiZr83N5XUX/qfqrF3y416Y=
X-Google-Smtp-Source: ABdhPJwsVwCDwEkWiiktTxYYhAGcIBD1izumUyFEArPPnSOetxCYDx2HINmj79U6jrB12QPnEVvLl8LK2hja2ZWqDnE=
X-Received: by 2002:a25:a045:: with SMTP id x63mr22905255ybh.27.1627418985491;
 Tue, 27 Jul 2021 13:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
 <CAEf4BzZZXx28w1y_6xfsue91c_7whvHzMhKvbSnsQRU4yA+RwA@mail.gmail.com>
 <82e61e60-e2e9-f42d-8e49-bbe416b7513d@isovalent.com> <CAEf4BzYpCr=Vdfc3moaapQqBxYV3SKfD72s0F=FAh_zLzSqxqA@mail.gmail.com>
 <bb0d3640-c6da-a802-4794-50cd033119ac@isovalent.com>
In-Reply-To: <bb0d3640-c6da-a802-4794-50cd033119ac@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 13:49:34 -0700
Message-ID: <CAEf4BzZ8wXhpRwPkBmH3i94oVea2BucC56PCK-0j4N_3gk29Ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 4:39 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-23 08:51 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Fri, Jul 23, 2021 at 2:58 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2021-07-22 19:45 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >>> On Thu, Jul 22, 2021 at 5:58 PM Andrii Nakryiko
> >>> <andrii.nakryiko@gmail.com> wrote:
> >>>>
> >>>> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>>
> >>>>> As part of the effort to move towards a v1.0 for libbpf [0], this set
> >>>>> improves some confusing function names related to BTF loading from and to
> >>>>> the kernel:
> >>>>>
> >>>>> - btf__load() becomes btf__load_into_kernel().
> >>>>> - btf__get_from_id becomes btf__load_from_kernel_by_id().
> >>>>> - A new version btf__load_from_kernel_by_id_split() extends the former to
> >>>>>   add support for split BTF.
> >>>>>
> >>>>> The old functions are not removed or marked as deprecated yet, there
> >>>>> should be in a future libbpf version.
> >>>>
> >>>> Oh, and I was thinking about this whole deprecation having to be done
> >>>> in two steps. It's super annoying to keep track of that. Ideally, we'd
> >>>> have some macro that can mark API deprecated "in the future", when
> >>>> actual libbpf version is >= to defined version. So something like
> >>>> this:
> >>>>
> >>>> LIBBPF_DEPRECATED_AFTER(V(0,5), "API that will be marked deprecated in v0.6")
> >>>
> >>> Better:
> >>>
> >>> LIBBPF_DEPRECATED_SINCE(0, 6, "API that will be marked deprecated in v0.6")
>
> So I've been looking into this, and it's not _that_ simple to do. Unless
> I missed something about preprocessing macros, I cannot bake a "#if" in
> a "#define", to have the attribute printed if and only if the current
> version is >= 0.6 in this example.
>
> I've come up with something, but it is not optimal because I have to
> write a check and macros for each version number used with the
> LIBBPF_DEPRECATED_SINCE macro. If we really wanted to automate that part
> I guess we could generate a header with those macros from the Makefile
> and include it in libbpf_common.h, but that does not really look much
> cleaner to me.

Yeah, let's not add unnecessary code generation. It sucks, of course,
that we can't do #ifdef inside a macro :(

So it's either do something like what you did with defining
version-specific macros, which is actually not too bad, because it's
not like we have tons of those versions anyways.

LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")
LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);

Alternatively, we can go with:

#if LIBBPF_AT_OR_NEWER(0, 6)
LIBBPF_DEPRECATED("use btf__load_from_kernel_by_id instead")
#endif
LIBBPF API int btf__get_from_id(__u32 id, struct btf **btf);

I don't really dislike the second variant too much either, but
LIBBPF_DEPRECATED_SINCE() reads nicer. Let's go with that. See some
comments below about implementation.

>
> Here's my current code, below - does it correspond to what you had in
> mind? Or did you think of something else?
>
> ------
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index ec14aa725bb0..095d5dc30d50 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -8,6 +8,7 @@ LIBBPF_VERSION := $(shell \
>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
>         sort -rV | head -n1 | cut -d'_' -f2)
>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
> +LIBBPF_MINOR_VERSION := $(firstword $(subst ., ,$(subst $(LIBBPF_MAJOR_VERSION)., ,$(LIBBPF_VERSION))))

Given all this is for internal use, I'd instead define something like
__LIBBPF_CURVER as an integer that is easy to compare against:

#define __LIBBPF_CURVER (LIBBPF_MAJOR_VERSION * 100 +
LIBBPF_MINOR_VERSION) * 100 + LIBBPF_PATCH_VERSION

That will simplify some stuff below and is generally easier to use in
code, if we will need this somewhere to use explicitly.

>
>  MAKEFLAGS += --no-print-directory
>
> @@ -86,6 +87,8 @@ override CFLAGS += -Werror -Wall
>  override CFLAGS += $(INCLUDES)
>  override CFLAGS += -fvisibility=hidden
>  override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> +override CFLAGS += -DLIBBPF_MAJOR_VERSION=$(LIBBPF_MAJOR_VERSION)
> +override CFLAGS += -DLIBBPF_MINOR_VERSION=$(LIBBPF_MINOR_VERSION)
>
>  # flags specific for shared library
>  SHLIB_FLAGS := -DSHARED -fPIC
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index cf8490f95641..8b6b5442dbd8 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -45,7 +45,8 @@ LIBBPF_API struct btf *btf__parse_raw(const char *path);
>  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
>  LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
>  LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id, struct btf *base_btf);
> -LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> +LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")

nit: given how long those deprecations will be, let's keep them at a
separate (first) line and keep LIBBPF_API near the function
declaration itself

> +int btf__get_from_id(__u32 id, struct btf **btf);
>
>  LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
>  LIBBPF_API int btf__load(struct btf *btf);
> diff --git a/tools/lib/bpf/libbpf_common.h b/tools/lib/bpf/libbpf_common.h
> index 947d8bd8a7bb..9ba9f8135dc8 100644
> --- a/tools/lib/bpf/libbpf_common.h
> +++ b/tools/lib/bpf/libbpf_common.h
> @@ -17,6 +17,28 @@
>
>  #define LIBBPF_DEPRECATED(msg) __attribute__((deprecated(msg)))
>
> +#ifndef LIBBPF_DEPRECATED_SINCE

why #ifndef conditional?

> +#define __LIBBPF_VERSION_CHECK(major, minor) \
> +       LIBBPF_MAJOR_VERSION > major || \
> +               (LIBBPF_MAJOR_VERSION == major && LIBBPF_MINOR_VERSION >= minor)

so we don't need this if we do __LIBBPF_CURVER

> +
> +/* Add checks for other versions below when planning deprecation of API symbols
> + * with the LIBBPF_DEPRECATED_SINCE macro.
> + */
> +#if __LIBBPF_VERSION_CHECK(0, 6)
> +#define __LIBBPF_MARK_DEPRECATED_0_6(X) X
> +#else
> +#define __LIBBPF_MARK_DEPRECATED_0_6(X)
> +#endif
> +
> +#define __LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
> +       __LIBBPF_MARK_DEPRECATED_ ## major ## _ ## minor (LIBBPF_DEPRECATED("v" # major "." # minor "+, " msg))
> +
> +/* Mark a symbol as deprecated when libbpf version is >= {major}.{minor} */
> +#define LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
> +       __LIBBPF_DEPRECATED_SINCE(major, minor, msg)

Is it needed for some macro value concatenation magic to have this
nested __LIBBPF_DEPRECATED_SINCE?

> +#endif /* LIBBPF_DEPRECATED_SINCE */
> +
>  /* Helper macro to declare and initialize libbpf options struct
>   *
>   * This dance with uninitialized declaration, followed by memset to zero,
