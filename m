Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB232B435
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbhCCEng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572954AbhCCEjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 23:39:35 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A87C061226;
        Tue,  2 Mar 2021 20:39:00 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id b10so23160025ybn.3;
        Tue, 02 Mar 2021 20:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SH4S7HU1hqEmrZXve0icwxIZwoSn9cxBI0arX0YS88o=;
        b=Q5DyLVhXmkALqG0K6Wu2tSi7ROGwAKzt1TWi7yxcwdbw8srAEiMvVjw1SkM83xdA70
         4rFpulZi+xQ9U0NqTeNTYmQqlZ8PQjSeAo9WOQFQLU1+VgZtpiijel6uFRVkrd9l4rUH
         YSiaf0Cx4z3NHOBSv+N/xfMs+o/fQeGGzvv3QBSaEdKIpVvg0GV0nirZd0vbaZ6fdRiJ
         5XQKwcJGj996tNX+WLNsiByvZtFikFicsByNcJwYYl3RMjTXSn799qic93GRFlguwx23
         xiU2/zi8ofxOlUyMg4w/fssGeR0RyVg6B8g02koZsG2lz/+EjEUkn2g71dcpiiTwZLj+
         5oEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SH4S7HU1hqEmrZXve0icwxIZwoSn9cxBI0arX0YS88o=;
        b=kPbuDOaWmKvIF1Paa8iEbR0ru1dM4+5z+TuQX/l9v1+515AwTi3JH1RRgjIj0qoPAL
         1yv8x0l/rXt/sy85fpNdjIabtY7y5A6+AWOj+WxvoAYkdtONTVlAE+s8XA2EgXk9VXAe
         8zlGEZFE+p0Nuc732bxI6SJN5EGhitpxNU2B9m6xDiljw8GiCzRgv1eDiK++j2d8B8Oq
         8FDZM2WBErwzQa0mCAJwCiMf1M0aLU/EPIF5WVX3zJKT1T5jcTKvUdadbcQ7zRyUc/nz
         5DcqsqjQlQD/ZXaoiXaG8MquZSCsr7Lxoe+mmzQQPPm6yTIpbRxlOrMxhuidAkwJzQ9p
         bPdg==
X-Gm-Message-State: AOAM531Al6lbwFN6XSZmR/7NI7EhDh7hEEvblOqHlbwk2M3TaUHT8kKt
        8oFhzFQ9GXf839X4aiEcrfD7nfxTK29Xmz3yPus=
X-Google-Smtp-Source: ABdhPJw1s6sxFzCoEm/GGXp754eWkxStcR3tfRS3lSYTi8U9V0exCLjfJBMrqSGOfaQuj1HOGsd9KhQC3Y7BsEmnfLc=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr34265283yba.510.1614746339959;
 Tue, 02 Mar 2021 20:38:59 -0800 (PST)
MIME-Version: 1.0
References: <20210301104318.263262-1-bjorn.topel@gmail.com> <20210301104318.263262-3-bjorn.topel@gmail.com>
In-Reply-To: <20210301104318.263262-3-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Mar 2021 20:38:49 -0800
Message-ID: <CAEf4BzZFDAcnaWU2JGL2GKmTTWQPDrcdgEn2NOM9cGFe16XheQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 2:43 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Now that the AF_XDP rings have load-acquire/store-release semantics,
> move libbpf to that as well.
>
> The library-internal libbpf_smp_{load_acquire,store_release} are only
> valid for 32-bit words on ARM64.
>
> Also, remove the barriers that are no longer in use.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++------------
>  tools/lib/bpf/xsk.h         | 17 +++------
>  2 files changed, 55 insertions(+), 34 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
> index 59c779c5790c..94a0d7bb6f3c 100644
> --- a/tools/lib/bpf/libbpf_util.h
> +++ b/tools/lib/bpf/libbpf_util.h
> @@ -5,6 +5,7 @@
>  #define __LIBBPF_LIBBPF_UTIL_H
>
>  #include <stdbool.h>
> +#include <linux/compiler.h>
>
>  #ifdef __cplusplus
>  extern "C" {
> @@ -15,29 +16,56 @@ extern "C" {
>   * application that uses libbpf.
>   */
>  #if defined(__i386__) || defined(__x86_64__)
> -# define libbpf_smp_rmb() asm volatile("" : : : "memory")
> -# define libbpf_smp_wmb() asm volatile("" : : : "memory")
> -# define libbpf_smp_mb() \
> -       asm volatile("lock; addl $0,-4(%%rsp)" : : : "memory", "cc")
> -/* Hinders stores to be observed before older loads. */
> -# define libbpf_smp_rwmb() asm volatile("" : : : "memory")

So, technically, these four are part of libbpf's API, as libbpf_util.h
is actually installed on target hosts. Seems like xsk.h is the only
one that is using them, though.

So the question is whether it's ok to remove them now?

And also, why wasn't this part of xsk.h in the first place?

> +# define libbpf_smp_store_release(p, v)                                 =
       \
> +       do {                                                            \
> +               asm volatile("" : : : "memory");                        \
> +               WRITE_ONCE(*p, v);                                      \
> +       } while (0)
> +# define libbpf_smp_load_acquire(p)                                    \
> +       ({                                                              \
> +               typeof(*p) ___p1 =3D READ_ONCE(*p);                      =
 \
> +               asm volatile("" : : : "memory");                        \
> +               ___p1;                                                  \
> +       })

[...]
