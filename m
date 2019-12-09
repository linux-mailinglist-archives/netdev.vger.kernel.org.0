Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45F9117670
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfLIT5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:57:40 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41487 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIT5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 14:57:39 -0500
Received: by mail-qk1-f195.google.com with SMTP id l124so2293101qkf.8;
        Mon, 09 Dec 2019 11:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NcB44n0iXRJVyFpixK4empk1pnmKscPpRBnS5swbmcI=;
        b=b7Fn5KWLzyCLQ5HJCVpwQc6UYQrZJaUDJRuoy8MN5DipxjybCfdNYpizUQxWkHPXwR
         m/LlDVfRnUorgrJnSS1Kg5XrYGdOg0WLLloWBnqDIXA8XkZ5Ea7Bwsa1VUGv7NH2KPKL
         yemnVVjPiD5c9VW0j96royNb4sN9fqrZ222Lo4Tk4sELcTCfiPV2d7S8q57bA0Zdb6rS
         yre3yMJrZDStkg8c1dRL+Iz/sF+xM8yRBpkPKncCnaa8uu9UDUUJsOMVybN3CdJLKgOA
         ysn+jxXaAvolex6sn6S7IiAiL8tCp5PCOm6Th0OAazOG6lKdV1EvAyRg2hAeiA7JL/JH
         KTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NcB44n0iXRJVyFpixK4empk1pnmKscPpRBnS5swbmcI=;
        b=mNkA5pyQdR3zkJ+gLUhUaLaWPbSHsY3ny+GmnqWVBG6ELENwqpn3Le3ueTpeQUleny
         21mJM//kXxcRz+s8QQsfBcgLDlzLvFbcO5NKwkoCJRYtRC7IINxpuROF9+IkeGNR/68e
         kCckkyZw80jDeHz+0E/7UuLe/1+YIi9j3c6aUIqCt3zQ67U6R6bWHMeRBE7ad1z86fgz
         OFiO/VVSNcQYqRYPPQbJrwBOaa4UaokKPs+gN5bYX2+Pj0OobLWqIWJaMuBHCbamnW4S
         AIcX1iJlu/ZFXwKq8i9RALjLCMMaupPsf7/BoDuNPXNnsy09oIRqXRVHskuZdT+WsLOH
         xUcg==
X-Gm-Message-State: APjAAAXr6avMvACmouNX///nS3Ns5i05PfTYExwbl/JFnvXEVq0XS7rj
        LHyW8ICzvSEcZV1erEie+42Jk9hPPSJ0WF8GzbQ=
X-Google-Smtp-Source: APXvYqwAlJqjuD/MqL1qjgVFkbXmT4iYKjEEkPJy9RQD9uKvk9LAmDD51ilqG6Q8iLAGCGYrPSkmTDbNo15EjqDtrk4=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr29427659qke.297.1575921458257;
 Mon, 09 Dec 2019 11:57:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575916815.git.paul.chaignon@gmail.com> <966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com>
In-Reply-To: <966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 9 Dec 2019 20:57:27 +0100
Message-ID: <CAJ+HfNgFo8viKn3KzNfbmniPNUpjOv_QM4ua_V0RFLBpWCOBYw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, riscv: limit to 33 tail calls
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     Paul Burton <paulburton@kernel.org>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 at 19:52, Paul Chaignon <paul.chaignon@orange.com> wrote=
:
>
> All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
> limit at runtime.  In addition, a test was recently added, in tailcalls2,
> to check this limit.
>
> This patch updates the tail call limit in RISC-V's JIT compiler to allow
> 33 tail calls.  I tested it using the above selftest on an emulated
> RISCV64.
>

33! ICK! ;-) Thanks for finding this!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

> Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.=
c
> index 5451ef3845f2..7fbf56aab661 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -631,14 +631,14 @@ static int emit_bpf_tail_call(int insn, struct rv_j=
it_context *ctx)
>                 return -1;
>         emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
>
> -       /* if (--TCC < 0)
> +       /* if (TCC-- < 0)
>          *     goto out;
>          */
>         emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
>         off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
>         if (is_13b_check(off, insn))
>                 return -1;
> -       emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
> +       emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
>
>         /* prog =3D array->ptrs[index];
>          * if (!prog)
> --
> 2.17.1
>
