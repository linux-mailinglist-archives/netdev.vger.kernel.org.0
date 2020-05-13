Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014671D1D24
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389942AbgEMSOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732488AbgEMSOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:14:08 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A8BC061A0C;
        Wed, 13 May 2020 11:14:06 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t8so370223qvw.5;
        Wed, 13 May 2020 11:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l267tr7eO0qLbDbPqwtlIKwZw3nHkvgyMXly11Gs4Vw=;
        b=RPvEq1geOoQ0o1Z1Pqn6Dd1miGQgyKWpA80zg66xgv5TZm4kApgdJHZYcRn8OGvccM
         q4XzO/g22y6QNeSywUp5YNGxVRcrbft+mbc7OV5OQzraBpPcurWwhcxlvnqJ3JW6PVP2
         T/IazVhHlivbOBd9Td9eBTMC8EvasfbosZA8pH37AIx4gj63MLu6h+KLPhAJ+sLrF2pA
         Z3S1HlAF8Tn7RLdxiRl7OYQFAW81ELrUbWBO9BzFnvrTRujzkIlAWJvh2HJHzTwx3/et
         IB9LpXrLjzFS0GGiLfdAbSJhaCiiDgkzLaL7C7drBYMtM09IoR6rQlNUElNT1Yd03uIa
         BUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l267tr7eO0qLbDbPqwtlIKwZw3nHkvgyMXly11Gs4Vw=;
        b=m604ijiN1qYZiHEbRhv+wE6qe3xM3vhS1iFF0hZy+YAByTxRPzbucwLe6/7RxKozp0
         LgBZsES3/vsLDTCFv/3wzqxr5xNY8B3I879up+12utpXwgIkEBUXbNL1uogKH/HYP0i2
         RWXb7u/9kI6C1f8WGbwpHe7fChc+FYY2uG48RPpSOt/CxktP5jXLqH4VVMwQvXZgh+US
         Zp8GszzBO+jzFqbYvV/ggesqPIj9Qabk5rgxvpJrs1BmfgNRRMn1BzWLa9pBDT0wcR1O
         p/Z+3gO6yZdoeMAGqIx8+mDi+oNiWrGMTsgEexG0jeSwSYAepABpvIkT9P2fc1ilbBXD
         CjWQ==
X-Gm-Message-State: AOAM5303do1yKNXiEfocT2Kfxm0M6lICXEBeBNiq4qd7h1IgpQ5zleNt
        wA75W/P5GY8jA/Bb0T96xrVu/K+3BmeVDlIspsc=
X-Google-Smtp-Source: ABdhPJxYgGOoEBj+0w74muEFXF6Ee4kZQcmFWrEXakKGTeAmUGyNec2kUH8Ta7hL9hbX0wyvZZraHTtSzATBZ0vOpEY=
X-Received: by 2002:a0c:e4d4:: with SMTP id g20mr873679qvm.228.1589393646017;
 Wed, 13 May 2020 11:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200513154414.29972-1-sumanthk@linux.ibm.com>
In-Reply-To: <20200513154414.29972-1-sumanthk@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 May 2020 11:13:53 -0700
Message-ID: <CAEf4BzZdAc6D0DRc+63_a=8PP6SbGn6GrHMQ8D9VmopyCT+-6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix register naming in PT_REGS s390 macros
To:     Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>, jwi@linux.ibm.com,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 8:45 AM Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
>
> Fix register naming in PT_REGS s390 macros
>
> Fixes: b8ebce86ffe6 ("libbpf: Provide CO-RE variants of PT_REGS macros")
> Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---

Great, thanks for catching this!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_tracing.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> index f3f3c3fb98cb..48a9c7c69ef1 100644
> --- a/tools/lib/bpf/bpf_tracing.h
> +++ b/tools/lib/bpf/bpf_tracing.h
> @@ -148,11 +148,11 @@ struct pt_regs;
>  #define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[4])
>  #define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[5])
>  #define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[6])
> -#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), grps[14])
> +#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[14])
>  #define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[11])
>  #define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[2])
>  #define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[15])
> -#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), pdw.addr)
> +#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), psw.addr)
>
>  #elif defined(bpf_target_arm)
>
> --
> 2.17.1
>
