Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AA63FBFA1
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhH3X4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhH3X4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:56:15 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04768C061575;
        Mon, 30 Aug 2021 16:55:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z18so31489176ybg.8;
        Mon, 30 Aug 2021 16:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=osaHZsvC6GXD6W3Yy9wZgX7DMF08yB4vlQ7sjrfCqUk=;
        b=naQViWRWvuh/C+pCLh3fUahwLOVxtJ1O3NePHN0ih0WhxOiKetMUXEguFhh3SUMEGY
         pNVqIXEdKwfoaK+vL30Z1n+8i0wNamVpjJ1B6XgSc4V0Rhoxldm10/uTctrkzidQUFqo
         wDTX7lgRd3n63H4YxlNNOcIWR4wpQImsgok5FyjBYTvf5U2+DKMsGaY08dyGOJ/1jWoC
         E5rrIIV4oMd0CCfZc0q3xHwYjVX7pqZ1gF9/mbdwP4lLPhBYGmip27cjCYj61Zqm9fJC
         KHDAERCDFthNFSmqXvGsZsfWjUAY4Z5bprpRrGbktrnydpYDsCYYfqo5COCmYRhU9CD3
         zPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osaHZsvC6GXD6W3Yy9wZgX7DMF08yB4vlQ7sjrfCqUk=;
        b=A+5NFyoxRMrk6GfURXdmbwYJl0Lssuv8VENQuuuiYpbPhK7FgR4m8Z0BBhvHDVe2Ns
         6FbO7y0O2QEULf9+U5O3UXB2f1si/UK199iq8HCmVNWK1FHEqbUVGNlF0aU4AtdY386x
         Fh4hjFTdnP/UEakNO5cuFgiyfLRPOtucQ1t0s7tQZGvAFAi95Y31j5zqbSRhcXnKVWc+
         1s6SjlOkTIuW0RNYwiLkEzk0sPuKST2HI8kQoqNgkRot9Tx0ejj7c9l7p9Gf2tf/uvOm
         8jvkDqhcKDZ/XdAOBJuAWzimIklwC4LJq38CyBq+xtPkVF6i64XtK0KOgPGa9sihk+nl
         VtOw==
X-Gm-Message-State: AOAM531D3/wfWKAqBcwvHo9olipff+tYoaZrGP3uPZs8TTz0mTAI/0Pc
        z4pSiRYeI8KPpijT4TourLAi5ShX5emUHudOzdI=
X-Google-Smtp-Source: ABdhPJyzq2UjMhGJJUlz4e9HhnH0du8C8/unmhgvND6mtwtk64xDXG8ep8cy9SlIlluC6H3m2C/HPn8iTA9lYSB3v1I=
X-Received: by 2002:a25:16c6:: with SMTP id 189mr26785803ybw.27.1630367720120;
 Mon, 30 Aug 2021 16:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210825195823.381016-1-davemarchevsky@fb.com> <20210825195823.381016-4-davemarchevsky@fb.com>
In-Reply-To: <20210825195823.381016-4-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 16:55:09 -0700
Message-ID: <CAEf4BzaNH1vRQr5jZO_m3haUaV5rXKiH5AJLFrM5iwbkEja=VQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose
 helper based on arg count
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 12:58 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Instead of being a thin wrapper which calls into bpf_trace_printk,
> libbpf's bpf_printk convenience macro now chooses between
> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
> format string) is >3, use bpf_trace_vprintk, otherwise use the older
> helper.
>
> The motivation behind this added complexity - instead of migrating
> entirely to bpf_trace_vprintk - is to maintain good developer experience
> for users compiling against new libbpf but running on older kernels.
> Users who are passing <=3 args to bpf_printk will see no change in their
> bytecode.
>
> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> without manual conversion of varargs to u64 array. Previous
> implementation of bpf_printk macro is moved to __bpf_printk for use by
> the new implementation.
>
> This does change behavior of bpf_printk calls with >3 args in the "new
> libbpf, old kernels" scenario. On my system, using a clang built from
> recent upstream sources (14.0.0 https://github.com/llvm/llvm-project.git
> 50b62731452cb83979bbf3c06e828d26a4698dca), attempting to use 4 args to
> __bpf_printk (old impl) results in a compile-time error:
>
>   progs/trace_printk.c:21:21: error: too many args to 0x6cdf4b8: i64 = Constant<6>
>         trace_printk_ret = __bpf_printk("testing,testing %d %d %d %d\n",
>
> I was able to replicate this behavior with an older clang as well. When
> the format string has >3 format specifiers, there is no output to the
> trace_pipe in either case.
>
> After this patch, using bpf_printk with 4 args would result in a
> trace_vprintk helper call being emitted and a load-time failure on older
> kernels.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index b9987c3efa3c..5f087306cdfe 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -14,14 +14,6 @@
>  #define __type(name, val) typeof(val) *name
>  #define __array(name, val) typeof(val) *name[]
>
> -/* Helper macro to print out debug messages */
> -#define bpf_printk(fmt, ...)                           \
> -({                                                     \
> -       char ____fmt[] = fmt;                           \
> -       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> -                        ##__VA_ARGS__);                \
> -})
> -
>  /*
>   * Helper macro to place programs, maps, license in
>   * different sections in elf_bpf file. Section names
> @@ -224,4 +216,41 @@ enum libbpf_tristate {
>                      ___param, sizeof(___param));               \
>  })
>
> +/* Helper macro to print out debug messages */
> +#define __bpf_printk(fmt, ...)                         \
> +({                                                     \
> +       char ____fmt[] = fmt;                           \
> +       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> +                        ##__VA_ARGS__);                \
> +})
> +
> +/*
> + * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
> + * instead of an array of u64.
> + */
> +#define __bpf_vprintk(fmt, args...)                            \
> +({                                                             \
> +       static const char ___fmt[] = fmt;                       \
> +       unsigned long long ___param[___bpf_narg(args)];         \
> +                                                               \
> +       _Pragma("GCC diagnostic push")                          \
> +       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       ___bpf_fill(___param, args);                            \
> +       _Pragma("GCC diagnostic pop")                           \
> +                                                               \
> +       bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> +                    ___param, sizeof(___param));               \

nit: is this really misaligned or it's just Gmail's rendering?

> +})
> +
> +#define ___bpf_pick_printk(...) \
> +       ___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,       \
> +               __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,             \
> +               __bpf_vprintk, __bpf_vprintk, __bpf_printk, __bpf_printk,               \
> +               __bpf_printk, __bpf_printk)

There is no best solution with macros, but I think this one is
extremely error prone because __bpf_nth invocation is very long and
it's hard to even see where printk turns into vprintk.

How about doing it similarly to ___empty in bpf_core_read.h? It will
be something like this (untested and not even compiled, just a demo)

#define __bpf_printk_kind(...) ___bpf_nth(_, ##__VA_ARGS__, new, new,
new, new, new, <however many>, new, old /*3*/, old /*2*/, old /*1*/,
old /*0*/)

#define bpf_printk(fmt, args...) ___bpf_apply(___bpf_printk_,
___bpf_narg(args))(fmt, args)


And you'll have s/__bpf_printk/__bpf_printk_old/ (using
bpf_trace_printk) and s/__bpf_printk_new/__bpf_vprintk/ (using
bpf_trace_vprintk).

This new/old distinction makes it a bit clearer to me. I find
__bpf_nth so counterintuitive that I try not to use it directly
anywhere at all.


> +
> +#define bpf_printk(fmt, args...)               \
> +({                                             \
> +       ___bpf_pick_printk(args)(fmt, args);    \
> +})

not sure ({ }) buys you anything?...

> +
>  #endif
> --
> 2.30.2
>
