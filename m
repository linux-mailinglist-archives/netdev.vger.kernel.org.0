Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9B119F49
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfLJXWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:22:20 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46854 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJXWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 18:22:20 -0500
Received: by mail-pl1-f194.google.com with SMTP id k20so516894pll.13;
        Tue, 10 Dec 2019 15:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KjIM6hB/c2j0i3WJaMzqN6qFiaP2KRG0tXM3pdq5P/U=;
        b=V/FBigx6erG32Z5dX1sGADv6IGTrhaRBR+zaoFjU5e9bvjpbQ+qVplqzUa8rO2PLmd
         ZM8ba1myg+KSdb9wfgR9uVRPAPoVSf5ugklFGj8U2brtFIa3Pj2toWaD1u5S+2JbHhmi
         GFz6W4U1N1Hi8jyqcjk3Iw3/MpXxgowBAVPIxl16jGU+K8o4H6W/5Y7ZkRrj9VuxzS0f
         aHuqVdj3TjCGrqtbvM8/8obq2ALBvSGkB7o6d4ggk90WqG6HpQC0aHOqKKN8Pxp3DpF9
         TbkAy42CYbfqEdAqVfXoutfZNa4tBXlGrZubyFAgyoiZJbt4eRqNgc38MUNSKEMdTgcP
         wxrA==
X-Gm-Message-State: APjAAAUX+cKPLwxvklxwsN69HCduVUF/CecLJGkYtHYpDMDO7pJyvBBj
        JT4aX1vwfk8QVxmihEbiSl0=
X-Google-Smtp-Source: APXvYqwMOarl7R1fafx3MMgYscUfTP2XbVTZo+8UCKQkA4Zgu4TKK07ECYdRD5htD6FzRikQ5ohJCg==
X-Received: by 2002:a17:90a:1c5:: with SMTP id 5mr35636pjd.88.1576020139440;
        Tue, 10 Dec 2019 15:22:19 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id 129sm120844pfw.71.2019.12.10.15.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 15:22:18 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:23:16 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 2/2] bpf, mips: limit to 33 tail calls
Message-ID: <20191210232316.aastpgbirqp4yaoi@lantea.localdomain>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
 <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Mon, Dec 09, 2019 at 07:52:52PM +0100, Paul Chaignon wrote:
> All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
> limit at runtime.  In addition, a test was recently added, in tailcalls2,
> to check this limit.
> 
> This patch updates the tail call limit in MIPS' JIT compiler to allow
> 33 tail calls.
> 
> Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
> Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>

I'd be happy to take this through mips-fixes, but equally happy for it
to go through the BPF/net trees in which case:

  Acked-by: Paul Burton <paulburton@kernel.org>

Thanks,
    Paul

> ---
>  arch/mips/net/ebpf_jit.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
> index 46b76751f3a5..3ec69d9cbe88 100644
> --- a/arch/mips/net/ebpf_jit.c
> +++ b/arch/mips/net/ebpf_jit.c
> @@ -604,6 +604,7 @@ static void emit_const_to_reg(struct jit_ctx *ctx, int dst, u64 value)
>  static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
>  {
>  	int off, b_off;
> +	int tcc_reg;
>  
>  	ctx->flags |= EBPF_SEEN_TC;
>  	/*
> @@ -616,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
>  	b_off = b_imm(this_idx + 1, ctx);
>  	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
>  	/*
> -	 * if (--TCC < 0)
> +	 * if (TCC-- < 0)
>  	 *     goto out;
>  	 */
>  	/* Delay slot */
> -	emit_instr(ctx, daddiu, MIPS_R_T5,
> -		   (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4, -1);
> +	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
> +	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
>  	b_off = b_imm(this_idx + 1, ctx);
> -	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
> +	emit_instr(ctx, bltz, tcc_reg, b_off);
>  	/*
>  	 * prog = array->ptrs[index];
>  	 * if (prog == NULL)
> -- 
> 2.17.1
> 
