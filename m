Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01204720A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfFOU0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:26:54 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42162 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOU0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:26:54 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so6534100qtk.9;
        Sat, 15 Jun 2019 13:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YGr51ar+nFM0sHRf+pNLuySIpupvWiH2vffpCg+UTPc=;
        b=rBTpPSzPN3xLEgHdwQeTOQ0cE2If0HojLt0UwHnLfu7JApLhsIpMw5B/8B33Pw8Yl4
         l85b6rI1mtkwdObTR2iPdTZSe1nKoKEqfYKylYl0I27nM9hzPm78YF7KuM0GcYKNvOTA
         icSD9wKp084LYAzzkI4ffT3n7Vw0BAlj+4joAwzC8X9/ky7Gzs1h0b6zpnIBGUsiFS98
         z6CovGJF0V7V020FMJaoQqDcq/ZLsiBy1hLHQ5yPnh8FPbTrTKFchlSWIBBkYYYCLyfG
         z6USLGvOmTiP3Fn/oxvKKyeYe78VaPJhI6chEElXcUZU+/Pq383mADgp4fQqVsmC3tBv
         95fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YGr51ar+nFM0sHRf+pNLuySIpupvWiH2vffpCg+UTPc=;
        b=CSKM7OGb8/5D0AMeYK5ceHSI9u8OYCu3L8XrhBihJzyb07Ab6epPImTL8Jm/SzRtMa
         8BUe341axjrvPKZ9C10iUbqf2IePjQMFiQ+46TrVwO3tBPQytE9+4v4dK4ORtvm7bTPJ
         36yazHzNzgNHFlB1jvSew9w05LG92zGAKUPCX+61Dzuc/IhhQCEABYAUgkVx3CjL8Zou
         2fC27sDeG6jG+hYlP1kdFF/z8+wOud1T1tGdWSARIGY8ySHiemMotvzkAwbzz8omT9dB
         xOtJp9qmEHIbKddVhReNLGMcksOG78uTy/15cOsfrC6lCb9Mv0KB4uRZvKhXzvLAxPSw
         pbQA==
X-Gm-Message-State: APjAAAWw0QBpG45g/IMH9WmCWK0Jg2snWb1oK7jUAcoWirxYnw2S9gkp
        6cE/2Op3eI/b4x3uKieVPDf/eqx7k6dU5XOyQIs=
X-Google-Smtp-Source: APXvYqwOLGZ2JJxAAOqXB5JLVA8e1kaAuYoilLk41J1Ywu/jdGHnX8gOsJmnSl2T1JwLqF+ACluJcqanP30V/WZ06IM=
X-Received: by 2002:ac8:152:: with SMTP id f18mr83092387qtg.84.1560630413236;
 Sat, 15 Jun 2019 13:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-2-andriin@fb.com>
In-Reply-To: <20190611044747.44839-2-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 13:26:42 -0700
Message-ID: <CAPhsuW5JdUqTUDtcYbrQTBd_skKvtpCNQwdXMpYmO_toTe6Y3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/8] libbpf: add common min/max macro to libbpf_internal.h
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Multiple files in libbpf redefine their own definitions for min/max.
> Let's define them in libbpf_internal.h and use those everywhere.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  tools/lib/bpf/bpf.c             | 7 ++-----
>  tools/lib/bpf/bpf_prog_linfo.c  | 5 +----
>  tools/lib/bpf/btf.c             | 3 ---
>  tools/lib/bpf/btf_dump.c        | 3 ---
>  tools/lib/bpf/libbpf_internal.h | 7 +++++++
>  5 files changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 0d4b4fe10a84..c7d7993c44bb 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -26,10 +26,11 @@
>  #include <memory.h>
>  #include <unistd.h>
>  #include <asm/unistd.h>
> +#include <errno.h>
>  #include <linux/bpf.h>
>  #include "bpf.h"
>  #include "libbpf.h"
> -#include <errno.h>
> +#include "libbpf_internal.h"
>
>  /*
>   * When building perf, unistd.h is overridden. __NR_bpf is
> @@ -53,10 +54,6 @@
>  # endif
>  #endif
>
> -#ifndef min
> -#define min(x, y) ((x) < (y) ? (x) : (y))
> -#endif
> -
>  static inline __u64 ptr_to_u64(const void *ptr)
>  {
>         return (__u64) (unsigned long) ptr;
> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
> index 6978314ea7f6..8c67561c93b0 100644
> --- a/tools/lib/bpf/bpf_prog_linfo.c
> +++ b/tools/lib/bpf/bpf_prog_linfo.c
> @@ -6,10 +6,7 @@
>  #include <linux/err.h>
>  #include <linux/bpf.h>
>  #include "libbpf.h"
> -
> -#ifndef min
> -#define min(x, y) ((x) < (y) ? (x) : (y))
> -#endif
> +#include "libbpf_internal.h"
>
>  struct bpf_prog_linfo {
>         void *raw_linfo;
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index b2478e98c367..467224feb43b 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -16,9 +16,6 @@
>  #include "libbpf_internal.h"
>  #include "hashmap.h"
>
> -#define max(a, b) ((a) > (b) ? (a) : (b))
> -#define min(a, b) ((a) < (b) ? (a) : (b))
> -
>  #define BTF_MAX_NR_TYPES 0x7fffffff
>  #define BTF_MAX_STR_OFFSET 0x7fffffff
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 4b22db77e2cc..7065bb5b2752 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -18,9 +18,6 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
>
> -#define min(x, y) ((x) < (y) ? (x) : (y))
> -#define max(x, y) ((x) < (y) ? (y) : (x))
> -
>  static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
>  static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
>
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 850f7bdec5cb..554a7856dc2d 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -23,6 +23,13 @@
>  #define BTF_PARAM_ENC(name, type) (name), (type)
>  #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
>
> +#ifndef min
> +# define min(x, y) ((x) < (y) ? (x) : (y))
> +#endif
> +#ifndef max
> +# define max(x, y) ((x) < (y) ? (y) : (x))
> +#endif
> +
>  extern void libbpf_print(enum libbpf_print_level level,
>                          const char *format, ...)
>         __attribute__((format(printf, 2, 3)));
> --
> 2.17.1
>
