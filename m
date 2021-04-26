Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57AB36BBA6
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 00:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhDZWZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 18:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhDZWZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 18:25:45 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B025AC061574;
        Mon, 26 Apr 2021 15:25:03 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id y2so64795326ybq.13;
        Mon, 26 Apr 2021 15:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4qrCTxyON94sG24s7VRyxhuMtbWE9VtOp82gPHX3fcU=;
        b=Itshoxmezn+5BXxDWHJIx4aCruZAJxOKMcjrkXeNuGPYeje4M5hel2m/10I75cC8UI
         yjp79GXZBYdtG7UgoGZFMWSZ0YL4QWMeTxDKw2DNxnf0EJ1w8RnqU8d6u+EMR1B0gB1Q
         8xF8dHxPAzUrnbDaHql5RCXZ8Bkc8B6PCpBLCMcxXdDXElxGhs7BAlFUn8HpUJWllndB
         26DX9s90Hr4gpKG3H3rxwNEkteEW1eahGnQsGgzFEzch4wReHw6DM0saAf94lRX13R3d
         Hh0nHI9t4iJ+UpiPXeZdGaEZdk6PTFyP/+BpIi07Yn/vhcANX5liJAnBV5GuN0GEtzHL
         CPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4qrCTxyON94sG24s7VRyxhuMtbWE9VtOp82gPHX3fcU=;
        b=iLZ90nj5MHJ+HKWwKvbAE/W/4tzgJMo0RijHp0CEouWZBHrfN899da82IJi0A/1rLa
         k4qph+cxsq74WvyLvN1+0ioFRw5UJBNrOhuoEMYyfapD2ScfqOXNTQPNx0oELJuPC82m
         ptxxGxTaTXWQkqt3XfCHl9rh725uHxYUVRPHoXwFTLaX/kosMRNtE3KrBEUZ6DJcQPqo
         2KHglsIjrXeYIl9fznwtkQMkOXvSACDrx2kMWOjPiUh+k4owX8nEwSjbWEM5O2iDvTzd
         R9CiGh1n1oJzcb7eq+kBRu1L1l6w/sCGIw5vFqihMT0bBPwlz5BYNw8WYpfp32XDa6dH
         /dsA==
X-Gm-Message-State: AOAM533jcCMz0B1JhxyG9ijwWmACbUUfl7aqOWlIefWxnzgwgzH7Bw+6
        9ozcqzxHvC389kDlGiK/Ji/UgTKXl4CYcyoi3fg=
X-Google-Smtp-Source: ABdhPJyznZKHgjSrfyq2feN1DWM7UdxQaOI7+hL1l3XDbWWU6D+EsnW4GhU31tbeJ3be/fA5SZQ6JX/OnEwzUt3ReJU=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr28290574ybf.425.1619475903058;
 Mon, 26 Apr 2021 15:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-5-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-5-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 15:24:52 -0700
Message-ID: <CAEf4BzbEjr8z-XWi4cYAjQMGhBr9b+spQdJvkmuweYjwkegrQg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/16] libbpf: Support for syscall program type
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Trivial support for syscall program type.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9cc2d45b0080..254a0c9aa6cf 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8899,6 +8899,7 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>         BPF_EAPROG_SEC("sk_lookup/",            BPF_PROG_TYPE_SK_LOOKUP,
>                                                 BPF_SK_LOOKUP),
> +       BPF_PROG_SEC("syscall",                 BPF_PROG_TYPE_SYSCALL),
>  };
>
>  #undef BPF_PROG_SEC_IMPL
> --
> 2.30.2
>
