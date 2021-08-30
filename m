Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6283FBE60
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhH3Vge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbhH3Vgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:36:33 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6730C061575;
        Mon, 30 Aug 2021 14:35:39 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z5so30997569ybj.2;
        Mon, 30 Aug 2021 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gf34JnV1lSM1Cbi+GL89F2UQCzx/0cv4oSjkGUIGpRE=;
        b=rIfwrzYvLmYLOQXE7nQ7h33IQEgQKgY+u1I6bSTi2vnfz/NzZSF82oh0NRpncwjBmd
         BIOXs8UhtPJNMz/ygXJf+GvS3hH1Zig2IIo+qVjBBYHWggMw7mEPQqOYeehFP/vR0tLr
         FYD+N0Yrn4WSlvgB6Qu63t2BnWRzt++VW/+c+1GUxajZgfn8KVA2MJb5pDIZDOSVc3wF
         3GwtY2rEhRLzYo+PQxJTRvt1TjJ7eCz8QXArqHMKN3RWlR9qvh3bSF63g/gw2lmXaWsX
         sDZQc9dHbjBgQEpr3p4EhmCQxAbej4d4HNXTDgypXFmJIvea1uxsvB4Bnhbf9Erwq1d7
         mHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gf34JnV1lSM1Cbi+GL89F2UQCzx/0cv4oSjkGUIGpRE=;
        b=Onu05vF0DS4HxQ3jnv7OPohBQkSkXrTEnG9Q1uKzeKICbZvhztjOnmBMyhzuHw6HIg
         BPYNNjKOSV045C6sLNXd5id8ZxlSWeJODhRdU2DX8oJvjoDgQcjUT7ZRIS30eTvD/pya
         O3a5vUdmymJ4IUtfnmZ4w0qjpxX4sJi+mgtlmcVZJWg1X6WUZ7RhKoZ/Z7MqlFjIiVaw
         Abd8eQEM6fA/X3dB0gs4mkesP5BwEBybUf870eHNdYVjtxJxAeiZ4AMGFipW3ctQhZMz
         aGjVjH6I0+TOXxxv+tERixOXblqL9hEYxjzhwzSXTg0cYB6WrPHvA345bNoXjotLIxmp
         V4Pw==
X-Gm-Message-State: AOAM533ET3j1qKemykxTsGimm8N1rcz2Gm7DLtNvuzhYQc0XWt3ukY9V
        d9m0OHUIxOMeTazgP5oCL6VsYRweh2WzFZecvC0=
X-Google-Smtp-Source: ABdhPJw3up6v1OrLUwUjBJPy5FhqtSclWkUuy0H89JieOlpg+lHkihbS7AN112XNlWcEjmrB7nh0Ms8bUCSeOBOON0I=
X-Received: by 2002:a25:4941:: with SMTP id w62mr26204913yba.230.1630359338981;
 Mon, 30 Aug 2021 14:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210827072539.3399-1-msuchanek@suse.de>
In-Reply-To: <20210827072539.3399-1-msuchanek@suse.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 14:35:28 -0700
Message-ID: <CAEf4BzbwX792higEDr_O+mqdqkZDoD67GuGvE7gEr1tO=U46Og@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix build with latest gcc/binutils with LTO
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     bpf <bpf@vger.kernel.org>,
        Patrick McCarty <patrick.mccarty@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 12:25 AM Michal Suchanek <msuchanek@suse.de> wrote:
>
> From: Patrick McCarty <patrick.mccarty@intel.com>
>
> After updating to binutils 2.35, the build began to fail with an
> assembler error. A bug was opened on the Red Hat Bugzilla a few days
> later for the same issue.
>
> Work around the problem by using the new `symver` attribute (introduced
> in GCC 10) as needed, instead of the `COMPAT_VERSION` and
> `DEFAULT_VERSION` macros, which expand to assembler directives.
>
> Fixes: https://github.com/libbpf/libbpf/issues/338

This is not a proper tag. We used the following form before:

  [0] Closes: https://github.com/libbpf/libbpf/issues/280

So it's a reference. And then mention in commit message that this was
initiated by the issue on Github ([0]), or something along those
lines.


> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1863059
> Fixes: https://bugzilla.opensuse.org/show_bug.cgi?id=1188749

These are also not proper Fixes: tags for kernel. It's fine if you
mention that this change fixes those bugs, but maybe use the reference
([1], [2]) style for that?

> Signed-off-by: Patrick McCarty <patrick.mccarty@intel.com>
> Make the change conditional on GCC version

This is not a tag, maybe remove this or make it part of the commit
message properly?

> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++------
>  tools/lib/bpf/xsk.c             |  4 ++--
>  2 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 016ca7cb4f8a..af0f3fb102c0 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -86,20 +86,31 @@
>         (offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
>  #endif
>
> +#ifdef __GNUC__
> +# if __GNUC__ >= 10
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
> +__attribute__((__symver__(#api_name "@@" #version)))
> +#  define COMPAT_VERSION(internal_name, api_name, version) \
> +__attribute__((__symver__(#api_name "@" #version)))
> +# endif
> +#endif
> +
> +#if !defined(COMPAT_VERSION) || !defined(DEFAULT_VERSION)

This seems wrong. If __GNUC__ && __GNUC__ >= 10 we'll define
DEFAULT_VERSION and COMPAT_VERSION as if we are linking in shared
library mode. This will be wrong on new GCC *and* static linking mode.
I think the above declarations should be inside #ifdef SHARED section.

Also, can you please write it out as #if defined(__GNUC__) && __GNUC__
>= 10, instead of doubly nested #if/#ifdef condition?


>  /* Symbol versioning is different between static and shared library.
>   * Properly versioned symbols are needed for shared library, but
>   * only the symbol of the new version is needed for static library.
>   */
> -#ifdef SHARED
> -# define COMPAT_VERSION(internal_name, api_name, version) \
> +# ifdef SHARED
> +#  define COMPAT_VERSION(internal_name, api_name, version) \
>         asm(".symver " #internal_name "," #api_name "@" #version);
> -# define DEFAULT_VERSION(internal_name, api_name, version) \
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
>         asm(".symver " #internal_name "," #api_name "@@" #version);
> -#else
> -# define COMPAT_VERSION(internal_name, api_name, version)
> -# define DEFAULT_VERSION(internal_name, api_name, version) \
> +# else
> +#  define COMPAT_VERSION(internal_name, api_name, version)
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
>         extern typeof(internal_name) api_name \
>         __attribute__((alias(#internal_name)));
> +# endif
>  #endif
>
>  extern void libbpf_print(enum libbpf_print_level level,
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e9b619aa0cdf..a2111696ba91 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -281,6 +281,7 @@ static int xsk_create_umem_rings(struct xsk_umem *umem, int fd,
>         return err;
>  }
>
> +DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>  int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>                             __u64 size, struct xsk_ring_prod *fill,
>                             struct xsk_ring_cons *comp,
> @@ -345,6 +346,7 @@ struct xsk_umem_config_v1 {
>         __u32 frame_headroom;
>  };
>
> +COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
>  int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>                             __u64 size, struct xsk_ring_prod *fill,
>                             struct xsk_ring_cons *comp,
> @@ -358,8 +360,6 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>         return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
>                                         &config);
>  }
> -COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
> -DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>
>  static enum xsk_prog get_xsk_prog(void)
>  {
> --
> 2.31.1
>
