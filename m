Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71578CAFD6
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfJCURI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:17:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36361 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfJCURI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:17:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id o12so5460870qtf.3;
        Thu, 03 Oct 2019 13:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQXWm+CW/e26X+83G5FIiEX/xxtGNP5evOqZ6FnL61c=;
        b=cbpWbGapoHMwwbXCKFfAP0LecNpQMsvXR9XLnRlNv3Q/WdVFwrrhScwsSihHG7VPDK
         xEW54o8LkEgLG5xPhzTi1Vm9uPk1PmuYte1O1Flk6V3jXESeDEruAJ0pWOMNrgAKjjFS
         l4M/SZyyZCdbmDncJs8FM2hmf7KhxfGcVvUuoBcNOzo3Mh/UMHLNlof7SCIT+17NgADd
         30GaegeTEdii2YTRXgzrhQlz2NWH5zZ4l4/2S1CtsNfIU0Oer1kHO8yf4AdIubBtktNL
         BMu3f5l6QQ0Qvu5PSnhZ8K3F223QmyL2Anru1SNkki7gm6hSo+fla2/n6PNvq3T9isEd
         dVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQXWm+CW/e26X+83G5FIiEX/xxtGNP5evOqZ6FnL61c=;
        b=KjsVanloMFGA5zjLlcWFS9p8Bg+H381qK1WbZ2pRMz5hIxQJygrSUr1GWGPFrhekYK
         zwi5Po0CAiwbNQBxouxI3W0dexEhQ99BUJObKwI9MDaBRYUHFTmf1MUSOW0zE1RQnDn8
         jzwHIaa39BspG1c+HC2BohbGNAWj5BGIkC86wzQkcWMS3M3/SZmzY7fm3TREbkPwK241
         JqdRoq9Vh68UH1PFRZYef0oAeGoHEddtxB50UUQ6ypynRPJRrge9ceMjZTrwCsWj8rFK
         K1RgPq3tCcsqp1zquj1/iBw/FsTlOsnJartpITIbEzybZ1SqZ7xph0DMYIq859mog5/t
         AsZw==
X-Gm-Message-State: APjAAAXGLAY8hwf9TTdjJaWzWTE+yGXgJ3nap6EhPYxog803EFiKoBwX
        HfKN2nZqJ3RZM3eJjLTjVgYrgsNheTyN3J7leEc=
X-Google-Smtp-Source: APXvYqw3sVir7rgjRxwyVZ1OQoBOe7n5jPlqEuKguBO33yhYjN4NLylZvEcqSSNUvHosKVuuKj9SKN/zgFsd7/koAEc=
X-Received: by 2002:ac8:37cb:: with SMTP id e11mr12323937qtc.22.1570133825617;
 Thu, 03 Oct 2019 13:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-4-andriin@fb.com>
In-Reply-To: <20191002215041.1083058-4-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:16:54 -0700
Message-ID: <CAPhsuW7CHQAq-N9-OE=jRqgYhq71ZhzEYexNcHCP=docrhNptg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] selftests/bpf: adjust CO-RE reloc tests
 for new bpf_core_read() macro
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> To allow adding a variadic BPF_CORE_READ macro with slightly different
> syntax and semantics, define CORE_READ in CO-RE reloc tests, which is
> a thin wrapper around low-level bpf_core_read() macro, which in turn is
> just a wrapper around bpf_probe_read().
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/bpf_helpers.h      |  8 ++++----
>  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
>  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
>  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
>  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
>  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
>  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
>  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
>  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
>  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
>  10 files changed, 58 insertions(+), 40 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 7b75c38238e4..5210cc7d7c5c 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -483,7 +483,7 @@ struct pt_regs;
>  #endif
>
>  /*
> - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> + * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
>   * relocation for source address using __builtin_preserve_access_index()
>   * built-in, provided by Clang.
>   *
> @@ -498,8 +498,8 @@ struct pt_regs;
>   * actual field offset, based on target kernel BTF type that matches original
>   * (local) BTF, used to record relocation.
>   */
> -#define BPF_CORE_READ(dst, src)                                                \
> -       bpf_probe_read((dst), sizeof(*(src)),                           \
> -                      __builtin_preserve_access_index(src))
> +#define bpf_core_read(dst, sz, src)                                        \
> +       bpf_probe_read(dst, sz,                                             \
> +                      (const void *)__builtin_preserve_access_index(src))
>
>  #endif
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> index bf67f0fdf743..58efe4944594 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> @@ -31,6 +31,8 @@ struct core_reloc_arrays {
>         struct core_reloc_arrays_substruct d[1][2];
>  };
>
> +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)

We are using sizeof(*dst) now, but I guess sizeof(*src) is better?
And it should be sizeof(*(src)).

> +
>  SEC("raw_tracepoint/sys_enter")
>  int test_core_arrays(void *ctx)
>  {
> @@ -38,16 +40,16 @@ int test_core_arrays(void *ctx)
>         struct core_reloc_arrays_output *out = (void *)&data.out;
>
>         /* in->a[2] */
> -       if (BPF_CORE_READ(&out->a2, &in->a[2]))
> +       if (CORE_READ(&out->a2, &in->a[2]))
>                 return 1;
>         /* in->b[1][2][3] */
> -       if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
> +       if (CORE_READ(&out->b123, &in->b[1][2][3]))
>                 return 1;
>         /* in->c[1].c */
> -       if (BPF_CORE_READ(&out->c1c, &in->c[1].c))
> +       if (CORE_READ(&out->c1c, &in->c[1].c))
>                 return 1;
>         /* in->d[0][0].d */
> -       if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
> +       if (CORE_READ(&out->d00d, &in->d[0][0].d))
>                 return 1;
>
>         return 0;
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> index 9fda73e87972..3348acc7e50b 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> @@ -39,6 +39,8 @@ struct core_reloc_flavors___weird {
>         };
>  };
>
> +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
> +
>  SEC("raw_tracepoint/sys_enter")
>  int test_core_flavors(void *ctx)
>  {
> @@ -48,13 +50,13 @@ int test_core_flavors(void *ctx)
>         struct core_reloc_flavors *out = (void *)&data.out;
>
>         /* read a using weird layout */
> -       if (BPF_CORE_READ(&out->a, &in_weird->a))
> +       if (CORE_READ(&out->a, &in_weird->a))
>                 return 1;
>         /* read b using reversed layout */
> -       if (BPF_CORE_READ(&out->b, &in_rev->b))
> +       if (CORE_READ(&out->b, &in_rev->b))
>                 return 1;
>         /* read c using original layout */
> -       if (BPF_CORE_READ(&out->c, &in_orig->c))
> +       if (CORE_READ(&out->c, &in_orig->c))
>                 return 1;
>
>         return 0;
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> index d99233c8008a..cfe16ede48dd 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> @@ -23,20 +23,22 @@ struct core_reloc_ints {
>         int64_t         s64_field;
>  };
>
> +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)

ditto.

> +
>  SEC("raw_tracepoint/sys_enter")
>  int test_core_ints(void *ctx)
>  {
>         struct core_reloc_ints *in = (void *)&data.in;
>         struct core_reloc_ints *out = (void *)&data.out;
>
> -       if (BPF_CORE_READ(&out->u8_field, &in->u8_field) ||
> -           BPF_CORE_READ(&out->s8_field, &in->s8_field) ||
> -           BPF_CORE_READ(&out->u16_field, &in->u16_field) ||
> -           BPF_CORE_READ(&out->s16_field, &in->s16_field) ||
> -           BPF_CORE_READ(&out->u32_field, &in->u32_field) ||
> -           BPF_CORE_READ(&out->s32_field, &in->s32_field) ||
> -           BPF_CORE_READ(&out->u64_field, &in->u64_field) ||
> -           BPF_CORE_READ(&out->s64_field, &in->s64_field))
> +       if (CORE_READ(&out->u8_field, &in->u8_field) ||
> +           CORE_READ(&out->s8_field, &in->s8_field) ||
> +           CORE_READ(&out->u16_field, &in->u16_field) ||
> +           CORE_READ(&out->s16_field, &in->s16_field) ||
> +           CORE_READ(&out->u32_field, &in->u32_field) ||
> +           CORE_READ(&out->s32_field, &in->s32_field) ||
> +           CORE_READ(&out->u64_field, &in->u64_field) ||
> +           CORE_READ(&out->s64_field, &in->s64_field))
>                 return 1;
>
>         return 0;
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> index 37e02aa3f0c8..e5308026cfda 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> @@ -17,6 +17,8 @@ struct task_struct {
>         int tgid;
>  };
>
> +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
ditto again, and more below.

Thanks,
Song
