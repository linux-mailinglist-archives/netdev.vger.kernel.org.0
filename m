Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCC30534
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfE3XIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:08:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43225 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfE3XIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:08:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id z24so9121412qtj.10;
        Thu, 30 May 2019 16:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5YeNHvt0zcypFW4gVIjV1wgNVF4tJqWRF5UGFIAvn4=;
        b=kvKFrp7EnHfnw8nIv5t/k3DxK8cbOL5bHDJ9jOUmfY2bO2Mr/aqYTWt+NKsVvv0bXa
         zZ4PnN25ii5l/UtWlU3wB03jXpxVbMg8v8vCGbaXr1AHVAywRyKRpKz7oagZrAaXuv1x
         yJWpFNRmq+DeHoVljMrEo16o5VMJlbr5iEdAeqGeQf9abrGLfILaYWGC7xFWP6ImzBee
         M79+eL/nneYGsmQYuuurbKE/kV+EMXBQYRvvq7+MAftmBaQQTXB7qCFZo0occwkIX9Et
         UPUAjnSStcaSeTC2ghnagA+tfZEpKbvMC13WmNojojbCD905FUVZc8EWpaXd8MGynps6
         nShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5YeNHvt0zcypFW4gVIjV1wgNVF4tJqWRF5UGFIAvn4=;
        b=L4KGwcvp8tzyXhpDyYXgdOw78c59W4nsXHV0A+8v5asvYM1OS1q8ncbe2u+3JGzCnF
         mfyGnBDYSNe7ha9xFiYwqFYyROam8wTm9V9tBKQQtkXwUKOJpXXdix1Wyk6+ebQvdI2C
         uwuLC6gVXeO0M/pRwmoOe95DHl6MxkkZPErMenxrQlMqNUSC+Ts5gg1QW5+EdHXpz5ID
         +TSdH6QCW6fWQB2HLN3dEpRsOKNpRvTsGIrBhgmUhYr9eRA1w17P/BgFnyG6Ucx3D92y
         aEKyiW67BPl41a9sX2un1Dqkd5t1n1jzmtP7QXypWPkjU8eqJ00Voh+PEzjPWS0fWoqX
         18iw==
X-Gm-Message-State: APjAAAUIKPEUI/LeqzRwRyfvzbCA5zVioDXgCO0V3TFzSU8AkPW+OX6H
        BHIQ3icvf5lWDpzy0yxwYwTEV1CQzviZMzfutdU=
X-Google-Smtp-Source: APXvYqy5EvtGXAtcjqdJE/hoBljmEVSM5SUwDsN118mX/n4a0tm5BdRhBgPAlea1wtiaGUu9m/X/X7PPUt3c0jDbo1c=
X-Received: by 2002:ac8:2af4:: with SMTP id c49mr5784353qta.83.1559257709549;
 Thu, 30 May 2019 16:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190530222922.4269-1-luke.r.nels@gmail.com>
In-Reply-To: <20190530222922.4269-1-luke.r.nels@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 16:08:18 -0700
Message-ID: <CAPhsuW4JXN65P4b_uXdJX12RZFU0HyuREZuwrm+tEQ0rq8-oRA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh
To:     Luke Nelson <luke.r.nels@gmail.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 3:30 PM Luke Nelson <luke.r.nels@gmail.com> wrote:
>
> In BPF, 32-bit ALU operations should zero-extend their results into
> the 64-bit registers.
>
> The current BPF JIT on RISC-V emits incorrect instructions that perform
> sign extension only (e.g., addw, subw) on 32-bit add, sub, lsh, rsh,
> arsh, and neg. This behavior diverges from the interpreter and JITs
> for other architectures.
>
> This patch fixes the bugs by performing zero extension on the destination
> register of 32-bit ALU operations.
>
> Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
> The original patch is
> https://lkml.org/lkml/2019/5/30/1370
>
> This version is rebased against the bpf tree.
> ---
>  arch/riscv/net/bpf_jit_comp.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index e5c8d675bd6e..426d5c33ea90 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -751,10 +751,14 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_ADD | BPF_X:
>         case BPF_ALU64 | BPF_ADD | BPF_X:
>                 emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_SUB | BPF_X:
>         case BPF_ALU64 | BPF_SUB | BPF_X:
>                 emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_AND | BPF_X:
>         case BPF_ALU64 | BPF_AND | BPF_X:
> @@ -795,14 +799,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_LSH | BPF_X:
>         case BPF_ALU64 | BPF_LSH | BPF_X:
>                 emit(is64 ? rv_sll(rd, rd, rs) : rv_sllw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_RSH | BPF_X:
>         case BPF_ALU64 | BPF_RSH | BPF_X:
>                 emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_X:
>         case BPF_ALU64 | BPF_ARSH | BPF_X:
>                 emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* dst = -dst */
> @@ -810,6 +820,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU64 | BPF_NEG:
>                 emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
>                      rv_subw(rd, RV_REG_ZERO, rd), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* dst = BSWAP##imm(dst) */
> @@ -964,14 +976,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_LSH | BPF_K:
>         case BPF_ALU64 | BPF_LSH | BPF_K:
>                 emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_RSH | BPF_K:
>         case BPF_ALU64 | BPF_RSH | BPF_K:
>                 emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_K:
>         case BPF_ALU64 | BPF_ARSH | BPF_K:
>                 emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* JUMP off */
> --
> 2.19.1
>
