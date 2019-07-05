Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB7E60307
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 11:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfGEJY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 05:24:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40030 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfGEJY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 05:24:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so2846968wrl.7
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 02:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HHbqpLTt/UqK8u8skkn9x9YIdY8wkJ4ttRxZXF6EinY=;
        b=yp5yQJh8jtfYUPLuGlLq2DfqpPBdGGO494xChqpf9zNWBSsXLE5a0248/NAxkoBO4/
         0BsVaDdF03YgBQ/EiWOMx+7i4XiuJ0zQf7XlokIV1VYWJHiMZ3PDkE/KfYOab4VzMB+J
         f/pVJLRXx+gS9twTb1Pgz2EXRdaLuXqYybXQVVic64Dl6MDkktWQB7g1huoxjSF5Uleo
         KWEaVwh/WkLIXcfSUgaE+apFuFz8i+7Qp7PYmwtsyWVa2Ym0Ym+UO3OF2ienlhikB0yc
         b4nd6B6ytLHgVQbS9mVjQWCRJczLAl4BYGmiNDVXuTYnaPhD6JUOdm5tiGTCbXBzkVMF
         YL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HHbqpLTt/UqK8u8skkn9x9YIdY8wkJ4ttRxZXF6EinY=;
        b=WUnWj0soRxNXCG23+WCnc7PY6+1TEYD/2F+bOaDk6GcDfooNK8qVmLgnZ4ZVmzd7Lj
         bPWblqMcDVoKgQCnMGoSFAPR+a/+L2gwRxd5Ab5IIU3DTEN7B+wKd9LauVIZ5+GC+i6R
         /VOZ05NxF60+jN7vNRoVmAO9rpN9uiu7383w9EMLdEaMblZStR8s5W+mrxlRjMCBSRQJ
         MOTBk7nN/u32A4yL1s0h3dfJ9YBSPmGqANlIMrEaHn5/TWxW6bOvhwFh505N8YQZsIcN
         GapCVEMgThESo2bAcAz8RWg7rxkuhYNbGDz8xu0Mi9Uxgyd7VYliv8wuv04By06lcH5N
         sX6A==
X-Gm-Message-State: APjAAAUCglicu4s/7OWk5KWqHQbieT1N9mP/N7bkwJpUhMTL3M75iTXM
        ITWA0R1MOqWVEwlw3+4oDUT1Cw==
X-Google-Smtp-Source: APXvYqwfVWZ2uyQrHtW79irxr4cfhJhTkvjPeAqMQ25Qa5108rnUpXmlpdEPv1K0U4PAXpWDPp+JbQ==
X-Received: by 2002:adf:e50c:: with SMTP id j12mr3191191wrm.117.1562318666604;
        Fri, 05 Jul 2019 02:24:26 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id o126sm7447501wmo.1.2019.07.05.02.24.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 02:24:25 -0700 (PDT)
References: <20190705001803.30094-1-luke.r.nels@gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     linux-kernel@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] Enable zext optimization for more RV64G ALU ops
In-reply-to: <20190705001803.30094-1-luke.r.nels@gmail.com>
Date:   Fri, 05 Jul 2019 10:24:22 +0100
Message-ID: <8736jk4ywp.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Luke Nelson writes:

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

LGTM, thanks.

Acked-by: Jiong Wang <jiong.wang@netronome.com>

>
> Cc: Song Liu <liu.song.a23@gmail.com>
> Cc: Jiong Wang <jiong.wang@netronome.com>
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index 876cb9c705ce..5451ef3845f2 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -757,31 +757,31 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  	case BPF_ALU | BPF_ADD | BPF_X:
>  	case BPF_ALU64 | BPF_ADD | BPF_X:
>  		emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_SUB | BPF_X:
>  	case BPF_ALU64 | BPF_SUB | BPF_X:
>  		emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_AND | BPF_X:
>  	case BPF_ALU64 | BPF_AND | BPF_X:
>  		emit(rv_and(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_OR | BPF_X:
>  	case BPF_ALU64 | BPF_OR | BPF_X:
>  		emit(rv_or(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_XOR | BPF_X:
>  	case BPF_ALU64 | BPF_XOR | BPF_X:
>  		emit(rv_xor(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_MUL | BPF_X:
> @@ -811,13 +811,13 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  	case BPF_ALU | BPF_RSH | BPF_X:
>  	case BPF_ALU64 | BPF_RSH | BPF_X:
>  		emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  	case BPF_ALU | BPF_ARSH | BPF_X:
>  	case BPF_ALU64 | BPF_ARSH | BPF_X:
>  		emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;
>  
> @@ -826,7 +826,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  	case BPF_ALU64 | BPF_NEG:
>  		emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
>  		     rv_subw(rd, RV_REG_ZERO, rd), ctx);
> -		if (!is64)
> +		if (!is64 && !aux->verifier_zext)
>  			emit_zext_32(rd, ctx);
>  		break;

