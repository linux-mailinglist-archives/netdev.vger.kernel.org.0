Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49760107
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfGEGbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:31:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43440 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfGEGbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:31:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so6998722qto.10;
        Thu, 04 Jul 2019 23:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PZ7J1xjsbzm1U/of1KhsZpOdk4BLy/jqSSNr0GyJ1Og=;
        b=kTYoIrLiHNVlf8mJdGVchtMrXO9vACuma/1M3y8WcbkCkzbhmbYnkZl8hU4MqPhxq0
         hzQffvUAThjMmmzI5zAEXXgjNVoZgmKvm3ihA9NSyjGYlJwKXUFfforoHouQkgDJLXEq
         wbVWB2nsiaAAvRpjGjoGburer6g8LpVI/kqtqvtKZufX1lzDwZasK4EteXjgWs50RVEA
         +Sd4UvQM9A5makPgQEWm4jcafa3xbYhd4rvMqUe8fsP3iRokKTOs8MDq40DSw0fxPcHz
         fwGAptLf7RHmQPOLX/Q9abKKO+yNhJnxiqzgTDce+xU/KqZeUGUSR/LDS3vvqIJBDGlu
         ArGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PZ7J1xjsbzm1U/of1KhsZpOdk4BLy/jqSSNr0GyJ1Og=;
        b=NGfEYhiTeXBIHIYR8Pei05UM1/oJlwJEoz1J+za2uID+aIflyQWocC8wBH+vebSfBf
         drCvDREqPhdJkU/1efELaZk0VHibuyiLN04ezRbfXC1xk43GkZp75eZzOGgXdvBVaBl7
         D/2kwYrz9Kb8bQfgJ0emULNcB8V6xe5RsZz+BHc1JgV9VSoKI0UNVtlKSmqyYeMESDtm
         1AjIw49EPkgwM4kIMhh9uJyjgmr+RuaXFHiH7cH5tgYrrbXHced6nY1Td+4YcVw9s1gW
         8KCDN8Z98AD8ByHCeh6Oj4I6AO3emotIlL0zC+8F303WlzUxsCYG+mtI0QLEPPy2ZJg8
         pgew==
X-Gm-Message-State: APjAAAUFOQV+mG6oaT6BYJPsU6hQs0l43a7VBiioGZWZqBDsTZpMqGea
        3ETwgMF2nCTJ/6NskHZm1eGrEaPcMI7Pxeny5Ww=
X-Google-Smtp-Source: APXvYqw3vejO55KsDt2ror9eB4zeFm4nWnhBt43Suis0p/V+EMnZEYIJGlrfJDBKGxdHEF9s4pqQwSDDwOwxjLlIWis=
X-Received: by 2002:a0c:ac98:: with SMTP id m24mr1873564qvc.9.1562308282034;
 Thu, 04 Jul 2019 23:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190705001803.30094-1-luke.r.nels@gmail.com>
In-Reply-To: <20190705001803.30094-1-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 5 Jul 2019 08:31:10 +0200
Message-ID: <CAJ+HfNi0Svv6w6_Xx-YPqBaOJnjGtxim_u0YdZacHynmfQaJTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] Enable zext optimization for more RV64G ALU ops
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 at 02:18, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> commit 66d0d5a854a6 ("riscv: bpf: eliminate zero extension code-gen")
> added the new zero-extension optimization for some BPF ALU operations.
>
> Since then, bugs in the JIT that have been fixed in the bpf tree require
> this optimization to be added to other operations: commit 1e692f09e091
> ("bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh"),
> and commit fe121ee531d1 ("bpf, riscv: clear target register high 32-bits
> for and/or/xor on ALU32")
>
> Now that these have been merged to bpf-next, the zext optimization can
> be enabled for the fixed operations.
>

Thanks for the patch, Luke!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

> Cc: Song Liu <liu.song.a23@gmail.com>
> Cc: Jiong Wang <jiong.wang@netronome.com>
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.=
c
> index 876cb9c705ce..5451ef3845f2 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -757,31 +757,31 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>         case BPF_ALU | BPF_ADD | BPF_X:
>         case BPF_ALU64 | BPF_ADD | BPF_X:
>                 emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_SUB | BPF_X:
>         case BPF_ALU64 | BPF_SUB | BPF_X:
>                 emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_AND | BPF_X:
>         case BPF_ALU64 | BPF_AND | BPF_X:
>                 emit(rv_and(rd, rd, rs), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_OR | BPF_X:
>         case BPF_ALU64 | BPF_OR | BPF_X:
>                 emit(rv_or(rd, rd, rs), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_XOR | BPF_X:
>         case BPF_ALU64 | BPF_XOR | BPF_X:
>                 emit(rv_xor(rd, rd, rs), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_MUL | BPF_X:
> @@ -811,13 +811,13 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>         case BPF_ALU | BPF_RSH | BPF_X:
>         case BPF_ALU64 | BPF_RSH | BPF_X:
>                 emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_X:
>         case BPF_ALU64 | BPF_ARSH | BPF_X:
>                 emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>
> @@ -826,7 +826,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>         case BPF_ALU64 | BPF_NEG:
>                 emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
>                      rv_subw(rd, RV_REG_ZERO, rd), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>
> --
> 2.20.1
>
