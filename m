Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52A5EFAE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGCXjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:39:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36309 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfGCXjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:39:51 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so9039359ioh.3;
        Wed, 03 Jul 2019 16:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sC1hWLWPHtDF7lICnZ0xHZ7zLIO7+HLBlu2ZrIyAjDY=;
        b=Ro7acgfcoM6HFmkSr2x43kSg1YzhjWscPdw2+opYOGkjySPv6eB6CM4x0OGJsVM9F8
         MB15FBOqXmr+U0kP657Okfl1ufm5ZxS3JmGaX3MRJcZ8CnmBBPsnybAYjbC2SEa019Xr
         wc+9F3GFQK2Dqs3rKPfqHBVlhVA+Et5vWjKtaJ3QNlQRl+Ed6iKLU0N7cyrXy1C7XwTt
         GunmxgML0piOrWfzyvrwjGxH3XKDCUKNWo2ReD53PHKwFO3V6HUHGLMvrjiM/S0BlhIx
         nUQsUIu0LuPJJk8CMeE4iUtg3pIufYhPvjRGg3PIrmGY+D3zsKGlFc1FCdlgIHduLINJ
         4FQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sC1hWLWPHtDF7lICnZ0xHZ7zLIO7+HLBlu2ZrIyAjDY=;
        b=F/mIcCtuASOioOVlK/sh91XeaBZYb7MjNzgmCukX+6FWS42ioUCxOSlhioSTsiLmsP
         MYZn1MfumwMP0pS9Mj6+bycL4RiUMAgMybkTi4UV/8NMxvp2Fm8PMrZyH12OxPRoUJpd
         hgyfkURO5r4aHcYoY2wj9VDsUqxnUQbCdKxKUbZxNBSdAoz+gxUcuOnaRp+beCQWz04e
         4YK4XCUd7iNDBgIOdbXHmNhX19UqY5ohTl4hfOKKfSclcvZDMBu5snMP+V2yPc8rsUsa
         ePNDZdDKk/CLi8Y3NIxgZVefTJPY7tdgSRwgE/hP5dvuA1lfJ2LWXLLsIIpTd7QEUBIS
         5a8A==
X-Gm-Message-State: APjAAAXzTILhoutfIb3bPmSgm7GG71FOuQE4vLQALkJkQ0mGCOzNy/Z3
        9dXaXNKrW4xaoG2XhSv96nLUq88Iwx4mhRK6F90=
X-Google-Smtp-Source: APXvYqworXYV7mXzgAu6WEW5Gt7vDxcAgOdG/buODsHxK+ENH/51Bx5vgNiAQxLaq38KUGaStYHPBZfaT9Kb2hMJaL4=
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr7790287iof.181.1562197190332;
 Wed, 03 Jul 2019 16:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190703205100.142904-1-sdf@google.com>
In-Reply-To: <20190703205100.142904-1-sdf@google.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 3 Jul 2019 16:39:14 -0700
Message-ID: <CAH3MdRWePmAZNRfGNcBdjKAJ+D33=4Vgg1STYC3khNps8AmaHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make verifier loop tests arch independent
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 1:51 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Take the first x bytes of pt_regs for scalability tests, there is
> no real reason we need x86 specific rax.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/progs/loop1.c | 3 ++-
>  tools/testing/selftests/bpf/progs/loop2.c | 3 ++-
>  tools/testing/selftests/bpf/progs/loop3.c | 3 ++-
>  3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> index dea395af9ea9..d530c61d2517 100644
> --- a/tools/testing/selftests/bpf/progs/loop1.c
> +++ b/tools/testing/selftests/bpf/progs/loop1.c
> @@ -14,11 +14,12 @@ SEC("raw_tracepoint/kfree_skb")
>  int nested_loops(volatile struct pt_regs* ctx)
>  {
>         int i, j, sum = 0, m;
> +       volatile int *any_reg = (volatile int *)ctx;
>
>         for (j = 0; j < 300; j++)
>                 for (i = 0; i < j; i++) {
>                         if (j & 1)
> -                               m = ctx->rax;
> +                               m = *any_reg;

I agree. ctx->rax here is only to generate some operations, which
cannot be optimized away by the compiler. dereferencing a volatile
pointee may just serve that purpose.

Comparing the byte code generated with ctx->rax and *any_reg, they are
slightly different. Using *any_reg is slighly worse, but this should
be still okay for the test.

>                         else
>                                 m = j;
>                         sum += i * m;
> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> index 0637bd8e8bcf..91bb89d901e3 100644
> --- a/tools/testing/selftests/bpf/progs/loop2.c
> +++ b/tools/testing/selftests/bpf/progs/loop2.c
> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
>  int while_true(volatile struct pt_regs* ctx)
>  {
>         int i = 0;
> +       volatile int *any_reg = (volatile int *)ctx;
>
>         while (true) {
> -               if (ctx->rax & 1)
> +               if (*any_reg & 1)
>                         i += 3;
>                 else
>                         i += 7;
> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> index 30a0f6cba080..3a7f12d7186c 100644
> --- a/tools/testing/selftests/bpf/progs/loop3.c
> +++ b/tools/testing/selftests/bpf/progs/loop3.c
> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
>  int while_true(volatile struct pt_regs* ctx)
>  {
>         __u64 i = 0, sum = 0;
> +       volatile __u64 *any_reg = (volatile __u64 *)ctx;
>         do {
>                 i++;
> -               sum += ctx->rax;
> +               sum += *any_reg;
>         } while (i < 0x100000000ULL);
>         return sum;
>  }
> --
> 2.22.0.410.gd8fdbe21b5-goog

Ilya Leoshkevich (iii@linux.ibm.com, cc'ed) has another patch set
trying to solve this problem by introducing s360 arch register access
macros. I guess for now that patch set is not needed any more?
