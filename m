Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978A821AB13
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGIW70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgGIW70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:59:26 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC92C08C5CE;
        Thu,  9 Jul 2020 15:59:25 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t7so1744230qvl.8;
        Thu, 09 Jul 2020 15:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D8zldaeMRzQtVvKu+IeVdJQHKskFweaij0NhK30PA3Y=;
        b=pe/6eYHwcQdrkKoLboqkDZcq+Mc5owjkFIRYDjlaX1ymMVT3uRyUGIELxGkgWzHd+e
         XCHWzr8wzLNncmREnJj36WuvJXKrZxLKqfQ0B6GNxQFDLEZtyHZ4Q7kSm+UW3k8+xiEb
         XLBglUIdS71eAWhbqTTPnmOS5/BdypcEGaUShFU3OAU+4kwF40oQLY/+3q135rx6UWuX
         jYg96gXWITyYctcGYB9EQ5d/XjKEDcL64s54g3m+/kf3fZXwHPXPcnHCFdM0vY3cRJwV
         lX33NAJj9HvT7h7I0BycBgOkHewC0zEuP4DnpSZrW6+jfreO7uuw65Sa7SRdP7AwxwUD
         v+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D8zldaeMRzQtVvKu+IeVdJQHKskFweaij0NhK30PA3Y=;
        b=qfjzYGbcYS4LMYkHO0YQQTuj5PNKWaL5jUULq9gPTMfr0pxBIgbNntBSWqsaMMuEfd
         dD4J6IvNm0sq2yMBuUyE0RgpwiDXwfvbV7EWSOeFlMe2B0LkEoOln2QYzPfAkIrXJdQV
         t4CJLHuSDzoqx4CjDGtP5Lx8b2K7W4/puDCuUY0pb2SmjT+UQNukBcojFO5lBK0Jx5am
         z5W1uszxOR3f2UleciSTY0PH1DobZZzMJYn/lkS0tMxn/4HoyAVzn0yxy00CEiSeo1V2
         7+FuvYyX4Dl1eHlFCwQoLenr4Sp6WaquS3hKZRdnGANziGFwjJv0gkT0MaVAnOOET4st
         et+g==
X-Gm-Message-State: AOAM531JCYFRBvkSSw+0xyatEyeBl7IUijWJopobTEZ9qky+tLcvpxgk
        A81oy9+yfIxKbFaK+7VOr6WiquO4vhvHkpf9TwHmWy9s
X-Google-Smtp-Source: ABdhPJzotRxxj4Og9+W7jhl6eodHTSnm1veiYlAzJDbC6uU6yyHa11Tk9bo9o0H5WyMKcjHyFPRqEeYP5yTT7yCyWc0=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr66926326qvv.163.1594335565089;
 Thu, 09 Jul 2020 15:59:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200709225723.1069937-1-andriin@fb.com>
In-Reply-To: <20200709225723.1069937-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jul 2020 15:59:13 -0700
Message-ID: <CAEf4Bzbq9KPyn7RaRfowny=uOynuEM6ki5V+BuHR-tDDN1W_ew@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Fix libbpf hashmap on (I)LP32 architectures
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Bogusz <qboosh@pld-linux.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 3:57 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> From: Jakub Bogusz <qboosh@pld-linux.org>
>
> On ILP32, 64-bit result was shifted by value calculated for 32-bit long type
> and returned value was much outside hashmap capacity.
> As advised by Andrii Nakryiko, this patch uses different hashing variant for
> architectures with size_t shorter than long long.
>
> Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

This was supposed to have my Acked-by as well, I forgot to add it, sorry.

>  tools/lib/bpf/hashmap.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index df59fd4fc95b..e0af36b0e5d8 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -11,14 +11,18 @@
>  #include <stdbool.h>
>  #include <stddef.h>
>  #include <limits.h>
> -#ifndef __WORDSIZE
> -#define __WORDSIZE (__SIZEOF_LONG__ * 8)
> -#endif
>
>  static inline size_t hash_bits(size_t h, int bits)
>  {
>         /* shuffle bits and return requested number of upper bits */
> -       return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> +#if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
> +       /* LP64 case */
> +       return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> +#elif (__SIZEOF_SIZE_T__ <= __SIZEOF_LONG__)
> +       return (h * 2654435769lu) >> (__SIZEOF_LONG__ * 8 - bits);
> +#else
> +#      error "Unsupported size_t size"
> +#endif
>  }
>
>  typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
> --
> 2.24.1
>
