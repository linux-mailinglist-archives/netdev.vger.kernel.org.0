Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A430D165
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhBCCUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhBCCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 21:19:59 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AA9C06174A;
        Tue,  2 Feb 2021 18:19:18 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b145so8868388pfb.4;
        Tue, 02 Feb 2021 18:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z3Gq/DqN0Vvqsz8JRRmoNbqX1OW4VlHaJGFmuJ08sf4=;
        b=dZoYNVKDCyVwbu/XNfKVUch4SvgWFdCNo1fQ9gwnKQM2z8KMKxzJfV9Z/AcQh3QiZp
         j11Wotu1ZvYfdgZl6gW/5lB5pI4EDUf/Jd5Qe8+ZPLKNhKy495Ti9SmkbCWdSATpQonh
         MC+yGGY52PAvj2zilG8d/HcdMOqeLjXjPcjnp1piNREhmD9jIT1P5HDE8TtCWSl2B/B3
         AeRoykeNECoxzwdIXbGv+/0GX1xl5BRefHrRFiNnly2HwuDpxiCKkyWyFEfhbwp+4/zo
         EzskFGptQtpEarEJbgXRTdIVwf5KfzCHqrvkHW33GI4d8S4NbmyWpD6KwHdsmTDmDxWV
         mtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z3Gq/DqN0Vvqsz8JRRmoNbqX1OW4VlHaJGFmuJ08sf4=;
        b=N2TGoiqx0BBad+zMwN05Au8wf7FmocnuR7LDXGdPdvWSd4s6atc0W9yNAYOIk5cdtN
         GeYeGVwl1tHL4OnEISbKbFyRSusRyKgmhhxd81y/RIu4dT6UkMxtHC9+BomIaQu/f1NA
         3Ism4PwC61gt7QbDbHPnf07JSX8n/SSR5YzvPExhM8bcFv2DLwEfPI0P9lSmq1Wan9PQ
         KtRCnINUWyph6W00abetG5uYaPHyfvptMUj/Pha395km0AUDTt8+BENCM1g9wFSiQe4n
         d1wuEkFQpvPvmUwyvBDHYtte6kri78WcSx1h8+euqi5sapBly0fQmkEUyQtu1ddwoorO
         n78g==
X-Gm-Message-State: AOAM533/s6Vw3xJJxICGrcs/rN5+qjI3NPYew/NhFlSLNYC5mM05nhSJ
        Sw51dfsWiEpw3TPjmu8M3lBfwGe4r38=
X-Google-Smtp-Source: ABdhPJwC63nyKsk0YPC2Tw2v8LLtwdf+c4gESHaRdKbV4E9/LMejxMSNd5GyGEri+8krpjR14pKkKQ==
X-Received: by 2002:a62:5344:0:b029:1c7:eeea:8bad with SMTP id h65-20020a6253440000b02901c7eeea8badmr919462pfb.1.1612318758446;
        Tue, 02 Feb 2021 18:19:18 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5502])
        by smtp.gmail.com with ESMTPSA id u3sm285809pfm.144.2021.02.02.18.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 18:19:17 -0800 (PST)
Date:   Tue, 2 Feb 2021 18:19:15 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for
 PROBE_LDX instructions.
Message-ID: <20210203021915.5cfdrt3wwmskopuw@ast-mbp.dhcp.thefacebook.com>
References: <20210202053837.95909-1-alexei.starovoitov@gmail.com>
 <A746402C-245A-4FF1-AB54-585537EEBA9B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A746402C-245A-4FF1-AB54-585537EEBA9B@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 12:56:39AM +0000, Song Liu wrote:
> 
> 
> > On Feb 1, 2021, at 9:38 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > PTR_TO_BTF_ID registers contain either kernel pointer or NULL.
> > Emit the NULL check explicitly by JIT instead of going into
> > do_user_addr_fault() on NULL deference.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > arch/x86/net/bpf_jit_comp.c | 19 +++++++++++++++++++
> > 1 file changed, 19 insertions(+)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index b7a2911bda77..a3dc3bd154ac 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -930,6 +930,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> > 		u32 dst_reg = insn->dst_reg;
> > 		u32 src_reg = insn->src_reg;
> > 		u8 b2 = 0, b3 = 0;
> > +		u8 *start_of_ldx;
> > 		s64 jmp_offset;
> > 		u8 jmp_cond;
> > 		u8 *func;
> > @@ -1278,12 +1279,30 @@ st:			if (is_imm8(insn->off))
> > 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
> > 		case BPF_LDX | BPF_MEM | BPF_DW:
> > 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
> > +			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
> > +				/* test src_reg, src_reg */
> > +				maybe_emit_mod(&prog, src_reg, src_reg, true); /* always 1 byte */
> > +				EMIT2(0x85, add_2reg(0xC0, src_reg, src_reg));
> > +				/* jne start_of_ldx */
> > +				EMIT2(X86_JNE, 0);
> > +				/* xor dst_reg, dst_reg */
> > +				emit_mov_imm32(&prog, false, dst_reg, 0);
> > +				/* jmp byte_after_ldx */
> > +				EMIT2(0xEB, 0);
> > +
> > +				/* populate jmp_offset for JNE above */
> > +				temp[4] = prog - temp - 5 /* sizeof(test + jne) */;
> 
> IIUC, this case only happens for i == 1 in the loop? If so, can we use temp[5(?)] 
> instead of start_of_ldx?

I don't understand the question, but let me try anyway :)
temp is a buffer for single instruction.
prog=temp; for every loop iteration (not only i == 1)
temp[4] is second byte in JNE instruction as the comment says.
temp[5] is a byte after JNE. It's a first byte of XOR.
That XOR is variable length instruction. 
Hence while emitting JNE we don't know the target offset in JNE and just use 0.
So temp[4] assignment populates with actual offset, since now we know the size
of XOR.
