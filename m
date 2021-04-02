Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB713525FB
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 06:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhDBELR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 00:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBELP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 00:11:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B744C06178A
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 21:11:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x16so3674458wrn.4
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 21:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCaXwDV10dhKrn8kJuleYfg1EWrPXQo+wqW+nmg1Iys=;
        b=lp64j9zqOiwLGu7j1wSqsGR/RAb8Ee1i3et6xgUDAbzdA+QpDFE0aLgHsL9jsHgzcU
         RZlOp4S9wDe4lNplN9yjW/sJ3fH1ObNF0VQ9S7YdFL5xGOdwCOkKoPt0FbkQn+K5Pz0d
         dTlVZQgwFq5tjZparLLk1GmvROKpce86nGGep+MENfReUfxSIsFtKgvP8klfixq25v25
         TVfI2VNfMnZgfXqwkiYjEzb1aa4/Yhdx0p5tpqzqLqfgBEivsYLdeTE2J7SnDmxgF03w
         OQWv38q8F3dGnyreCxXt5+tDHlOeK9bvUI8trp7iVFdlaTfWUpJn7QEoEaQU+g92xU1m
         +32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCaXwDV10dhKrn8kJuleYfg1EWrPXQo+wqW+nmg1Iys=;
        b=gs9kioZGhG8NtXPI6tmGRWg3FNNBdJoUAwOFYE7MmbV2gcRHHzfCNCeT8P7BH1Q+Sh
         miLwwCgRUecfqCVAQoGTU1wTHiWxLpe2Ydb1bWe+SNWdqCxXU9hppHaaSwbV7NrluR9h
         aEAEdFrfyW5XAryRwP1JjwXtoTb3ACcKOBehTQhYudB+P8M2ehYBH6lxRQ/4lqXFqd4u
         u7nqg4lCVHc4zZ1+k1h1D0hH41cvDlre90YJ2jUJInEyNIi6Kg+azOQb7B3M9uUIMOa1
         1386qzFIiODE1FDtWB7OxTaaU5kieU4B2RbkoD/u6DHS01IjneP7lyvyw+rNGS2XBKW+
         1McA==
X-Gm-Message-State: AOAM531nF2Qq8jfj3ev6RDV5xaLHL7YwezuEzVHMnPZN5hjfCpXTjUbS
        I9eLZKYdm639efSErQpU0J9rN3kHXtW88eu6DfydOw==
X-Google-Smtp-Source: ABdhPJzYA4Ar4sFBPoRR7zZ5FTywncmiqYFdtbksFa6kQzbDtCwCH1G/RDQn8/MwpunRwtnjKys7ykkkxpBe/8z3mns=
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr13166768wrx.356.1617336672119;
 Thu, 01 Apr 2021 21:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210401002442.2fe56b88@xhacker> <20210401002621.409624ee@xhacker>
In-Reply-To: <20210401002621.409624ee@xhacker>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 2 Apr 2021 09:41:00 +0530
Message-ID: <CAAhSdy3-n7ASkPXN=UsQW72gY5JH-J3Rf7W6kfUxXV6Zdb5hDg@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] riscv: Constify sys_call_table
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:01 PM Jisheng Zhang
<jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> Constify the sys_call_table so that it will be placed in the .rodata
> section. This will cause attempts to modify the table to fail when
> strict page permissions are in place.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/syscall.h  | 2 +-
>  arch/riscv/kernel/syscall_table.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/syscall.h b/arch/riscv/include/asm/syscall.h
> index 49350c8bd7b0..b933b1583c9f 100644
> --- a/arch/riscv/include/asm/syscall.h
> +++ b/arch/riscv/include/asm/syscall.h
> @@ -15,7 +15,7 @@
>  #include <linux/err.h>
>
>  /* The array of function pointers for syscalls. */
> -extern void *sys_call_table[];
> +extern void * const sys_call_table[];
>
>  /*
>   * Only the low 32 bits of orig_r0 are meaningful, so we return int.
> diff --git a/arch/riscv/kernel/syscall_table.c b/arch/riscv/kernel/syscall_table.c
> index f1ead9df96ca..a63c667c27b3 100644
> --- a/arch/riscv/kernel/syscall_table.c
> +++ b/arch/riscv/kernel/syscall_table.c
> @@ -13,7 +13,7 @@
>  #undef __SYSCALL
>  #define __SYSCALL(nr, call)    [nr] = (call),
>
> -void *sys_call_table[__NR_syscalls] = {
> +void * const sys_call_table[__NR_syscalls] = {
>         [0 ... __NR_syscalls - 1] = sys_ni_syscall,
>  #include <asm/unistd.h>
>  };
> --
> 2.31.0
>
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
