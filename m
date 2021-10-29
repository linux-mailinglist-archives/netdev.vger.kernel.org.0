Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EC843F3DA
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhJ2AZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 20:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhJ2AZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 20:25:15 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955DAC061570;
        Thu, 28 Oct 2021 17:22:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m14so7544708pfc.9;
        Thu, 28 Oct 2021 17:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xrAbEfQZL5emh7FPXsdLj1L8TslvYif5/OdTBKtYpDQ=;
        b=UzKDFitQdPoAyyDyl6qodM7qh/ebfTMTzqc5S3rT1RkvKDa5IheN9fG49weBgowIl3
         JRzjFB3XhaZdaG239vLxH7t51Y53eIXszkzhvxrS6Abg4AUaaFc/xT6qohjK/G/vUMB9
         nrFQFUXW5ik0UlxoN6SO0+tKU6Eebujk4J2eoXpoC+QuknIQiu7b9rz928nQTC+Ts2jz
         nJyfgv/eTMi6r9XrsYztt/c2C9x7dFhoCWyyMr9gTYvQSzveMigAN84a/pMByCqJxpri
         RRW6zLPatRodwehDEkThXZ5QwRlJ2y2hFjy8z+c/cNLxf2i0N3Yr2Qh7akbmkS96xv5g
         fmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xrAbEfQZL5emh7FPXsdLj1L8TslvYif5/OdTBKtYpDQ=;
        b=zmLdzZdpA/lhEMY1fQBAUiSVjTXebgSMfWaoIsYYbdw9uxgXB3+2lOw6zyOdJKCTnr
         BlG5CXbv2u6YJ0mUY1j/ic9BiwWU/XP35RQ23dWl7fPj51MLzyLEO9kj6gLxk6kG8rLd
         xMRsHbGh2XQWBpG3qPpra8GEBLIvYORZ0F7s8Zt4LKVh4wb213qvno/cJy+HKJZzOJkR
         V2Gvco1/vy0R9F6l0vQ+1iSPuC4xL794PipoKCsDyQqWE2BO20UwRym+BROhwB7UstxO
         +fueAG2qv2MI0NAkTSeal89TnorrlGh1BwGYhAkW6Lk2eICK3OTifclVtvui4/poW2Za
         FfMw==
X-Gm-Message-State: AOAM530bzdTXwBed7EJohEeeh1lyC9xy3pAypGYoy6URUMcBkjFtwycM
        YE1dpO76GJ38FvCarY93Jsk=
X-Google-Smtp-Source: ABdhPJxJ5cMWm94QHhc4CQUf0nNGf14AD7zcF+jed+Qp+aK2fBiVIf7LbfOK2k5F+LjnR1R4JvDqoA==
X-Received: by 2002:a63:735e:: with SMTP id d30mr5814209pgn.448.1635466966969;
        Thu, 28 Oct 2021 17:22:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:a8c6])
        by smtp.gmail.com with ESMTPSA id x26sm4528705pff.25.2021.10.28.17.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 17:22:46 -0700 (PDT)
Date:   Thu, 28 Oct 2021 17:22:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 3/8] libbpf: Add weak ksym support to
 gen_loader
Message-ID: <20211029002244.3m63qmwrmykarvt6@ast-mbp.dhcp.thefacebook.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
 <20211028063501.2239335-4-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028063501.2239335-4-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 12:04:56PM +0530, Kumar Kartikeya Dwivedi wrote:
> This extends existing ksym relocation code to also support relocating
> weak ksyms. Care needs to be taken to zero out the src_reg (currently
> BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data)
> when the BTF ID lookup fails at runtime.  This is not a problem for
> libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
> proceeds in case of failure if ext->is_weak, leading to src_reg
> remaining as 0 for weak unresolved ksym).
> 
> A pattern similar to emit_relo_kfunc_btf is followed of first storing
> the default values and then jumping over actual stores in case of an
> error. For src_reg adjustment, we also need to perform it when copying
> the populated instruction, so depending on if copied insn[0].imm is 0 or
> not, we decide to jump over the adjustment.
> 
> We cannot reach that point unless the ksym was weak and resolved and
> zeroed out, as the emit_check_err will cause us to jump to cleanup
> label, so we do not need to recheck whether the ksym is weak before
> doing the adjustment after copying BTF ID and BTF FD.
> 
> This is consistent with how libbpf relocates weak ksym. Logging
> statements are added to show the relocation result and aid debugging.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/gen_loader.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
> index 11172a868180..1c404752e565 100644
> --- a/tools/lib/bpf/gen_loader.c
> +++ b/tools/lib/bpf/gen_loader.c
> @@ -13,6 +13,7 @@
>  #include "hashmap.h"
>  #include "bpf_gen_internal.h"
>  #include "skel_internal.h"
> +#include <asm/byteorder.h>
>  
>  #define MAX_USED_MAPS	64
>  #define MAX_USED_PROGS	32
> @@ -776,12 +777,24 @@ static void emit_relo_ksym_typeless(struct bpf_gen *gen,
>  	emit_ksym_relo_log(gen, relo, kdesc->ref);
>  }
>  
> +static __u32 src_reg_mask(void)
> +{
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	return 0x0f; /* src_reg,dst_reg,... */
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	return 0xf0; /* dst_reg,src_reg,... */
> +#else
> +#error "Unsupported bit endianness, cannot proceed"
> +#endif
> +}
> +
>  /* Expects:
>   * BPF_REG_8 - pointer to instruction
>   */
>  static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
>  {
>  	struct ksym_desc *kdesc;
> +	__u32 reg_mask;
>  
>  	kdesc = get_ksym_desc(gen, relo);
>  	if (!kdesc)
> @@ -792,19 +805,35 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
>  			       kdesc->insn + offsetof(struct bpf_insn, imm));
>  		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
>  			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
> -		goto log;
> +		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_8, offsetof(struct bpf_insn, imm)));

Thanks a lot for working on this. I've applied the set.

The above load is redundant, right? BPF_REG_0 already has that value
and could have been used in the JNE below, right?

> +		/* jump over src_reg adjustment if imm is not 0 */
> +		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_9, 0, 3));
> +		goto clear_src_reg;

Is there a test for this part of the code?
It's only for weak && unresolved && multi referenced ksym, right?
Or bpf_link_fops2 test_ksyms_weak.c fits this category?

>  	}
>  	/* remember insn offset, so we can copy BTF ID and FD later */
>  	kdesc->insn = insn;
>  	emit_bpf_find_by_name_kind(gen, relo);
> -	emit_check_err(gen);
> +	if (!relo->is_weak)
> +		emit_check_err(gen);
> +	/* set default values as 0 */
> +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
> +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 0));
> +	/* skip success case stores if ret < 0 */
> +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
>  	/* store btf_id into insn[insn_idx].imm */
>  	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
>  	/* store btf_obj_fd into insn[insn_idx + 1].imm */
>  	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
>  	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
>  			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));

The double store (first with zeros and then with real values) doesn't look pretty.
I think an extra jump over two stores would have been cleaner.
