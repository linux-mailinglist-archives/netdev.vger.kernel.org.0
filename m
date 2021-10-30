Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC32C4409DB
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhJ3PPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhJ3PPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 11:15:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F298C061570;
        Sat, 30 Oct 2021 08:12:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id i5so8787945pla.5;
        Sat, 30 Oct 2021 08:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tTGq8KHTwwJt1uiIn7bWEIdIOueKlVOZQsVf1i576Zg=;
        b=MeBGm+G1aD5v/IthLS62HoLdLiUgocfNH4Sa7Fs79dcuYSFTOgjbjdqB+tdwiqXyjP
         YjI13nImpBS6MqZUqAuMg1jY4LF6rgxu5/T7tccdOiPJUZHnEVSlKvXGJrN6e5l/+z4v
         fc8Sm+2dZXyw+Bp3nQMCxCMT18UExoYSizAJZtUYuEc9VTNexS9anf/nB3P3xZy2IMNP
         oF/KaOIQbI7ZUnfGqWZ1oWqxMHAYcEp7ulyUOwyWIXX9vrczRSh7Jey4Yrj/GYgZXySx
         tc/Nac0xiw9kxHqlSGObOJrLQh1zHWoBTRRpwY7eExVjwjVS49e+hdnK5BS6JxKS23Mh
         AZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tTGq8KHTwwJt1uiIn7bWEIdIOueKlVOZQsVf1i576Zg=;
        b=2x3ufzFUzKF2OP3dazD3t6e/GpqVhQSHuM7u/vPeCU/D4Cdyb0gm1n+sStNJotyo+4
         wBVpbzicuKmbibJyqsbR5Vmmn66GeZKoHw5f7dx/1vknq0LvItsMzpP1jS/z0ENoex+W
         jAoGYO9aFybHcnFZ7AMzLZN++4UxcWq5gbDViK2Ch2+HBIfp5fDJBtSzaTlNFHZssBMC
         ql9O1wZXnoTSEmgJA1coPgFyzIl4SLXsgL+Ar66HB92FQ+gC3Apql/jd7MK/OUerqWX+
         7UHqejCmm5KQnsjw2SeNUrD3CTWNunrJy8OW6L1nIsk2eOiTysDrV+YBa/QRvzzemBFz
         o81Q==
X-Gm-Message-State: AOAM533Gct45LBQmRlcydu+F/7PgXur1avKe/+Q1piojmN4Y6S+2NRRX
        eZyTDpPqlAUjZtyUf5Ny/YM=
X-Google-Smtp-Source: ABdhPJzOX7ozeg9k2RS3uxvBdhCvhQG0qwbNkHMYIzFI6zZw2XK0tApdOVruTQzmRmYprRAy5MALsQ==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr18145660pjb.49.1635606753999;
        Sat, 30 Oct 2021 08:12:33 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id 145sm2842590pfx.87.2021.10.30.08.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 08:12:33 -0700 (PDT)
Date:   Sat, 30 Oct 2021 20:42:30 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Message-ID: <20211030151230.bkp7gvuugcjw7q6g@apollo.localdomain>
References: <20211028063501.2239335-1-memxor@gmail.com>
 <20211028063501.2239335-4-memxor@gmail.com>
 <20211029002244.3m63qmwrmykarvt6@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029002244.3m63qmwrmykarvt6@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 05:52:44AM IST, Alexei Starovoitov wrote:
> On Thu, Oct 28, 2021 at 12:04:56PM +0530, Kumar Kartikeya Dwivedi wrote:
> > This extends existing ksym relocation code to also support relocating
> > weak ksyms. Care needs to be taken to zero out the src_reg (currently
> > BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data)
> > when the BTF ID lookup fails at runtime.  This is not a problem for
> > libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
> > proceeds in case of failure if ext->is_weak, leading to src_reg
> > remaining as 0 for weak unresolved ksym).
> >
> > A pattern similar to emit_relo_kfunc_btf is followed of first storing
> > the default values and then jumping over actual stores in case of an
> > error. For src_reg adjustment, we also need to perform it when copying
> > the populated instruction, so depending on if copied insn[0].imm is 0 or
> > not, we decide to jump over the adjustment.
> >
> > We cannot reach that point unless the ksym was weak and resolved and
> > zeroed out, as the emit_check_err will cause us to jump to cleanup
> > label, so we do not need to recheck whether the ksym is weak before
> > doing the adjustment after copying BTF ID and BTF FD.
> >
> > This is consistent with how libbpf relocates weak ksym. Logging
> > statements are added to show the relocation result and aid debugging.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/gen_loader.c | 35 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 32 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
> > index 11172a868180..1c404752e565 100644
> > --- a/tools/lib/bpf/gen_loader.c
> > +++ b/tools/lib/bpf/gen_loader.c
> > @@ -13,6 +13,7 @@
> >  #include "hashmap.h"
> >  #include "bpf_gen_internal.h"
> >  #include "skel_internal.h"
> > +#include <asm/byteorder.h>
> >
> >  #define MAX_USED_MAPS	64
> >  #define MAX_USED_PROGS	32
> > @@ -776,12 +777,24 @@ static void emit_relo_ksym_typeless(struct bpf_gen *gen,
> >  	emit_ksym_relo_log(gen, relo, kdesc->ref);
> >  }
> >
> > +static __u32 src_reg_mask(void)
> > +{
> > +#if defined(__LITTLE_ENDIAN_BITFIELD)
> > +	return 0x0f; /* src_reg,dst_reg,... */
> > +#elif defined(__BIG_ENDIAN_BITFIELD)
> > +	return 0xf0; /* dst_reg,src_reg,... */
> > +#else
> > +#error "Unsupported bit endianness, cannot proceed"
> > +#endif
> > +}
> > +
> >  /* Expects:
> >   * BPF_REG_8 - pointer to instruction
> >   */
> >  static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> >  {
> >  	struct ksym_desc *kdesc;
> > +	__u32 reg_mask;
> >
> >  	kdesc = get_ksym_desc(gen, relo);
> >  	if (!kdesc)
> > @@ -792,19 +805,35 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
> >  			       kdesc->insn + offsetof(struct bpf_insn, imm));
> >  		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
> >  			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
> > -		goto log;
> > +		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_8, offsetof(struct bpf_insn, imm)));
>
> Thanks a lot for working on this. I've applied the set.
>
> The above load is redundant, right? BPF_REG_0 already has that value
> and could have been used in the JNE below, right?
>

Hm, true, we could certainly avoid another load here.

> > +		/* jump over src_reg adjustment if imm is not 0 */
> > +		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_9, 0, 3));
> > +		goto clear_src_reg;
>
> Is there a test for this part of the code?
> It's only for weak && unresolved && multi referenced ksym, right?

Correct.

> Or bpf_link_fops2 test_ksyms_weak.c fits this category?
>

Yes, the result of relocation is as follows (t=0 means typed, w=1 means weak):
find_by_name_kind(bpf_link_fops2,14) r=-2
var t=0 w=1 (bpf_link_fops2:count=1): imm[0]: 0, imm[1]: 0
var t=0 w=1 (bpf_link_fops2:count=1): insn.reg r=1
// goto clear_src_reg happens for this one
var t=0 w=1 (bpf_link_fops2:count=2): imm[0]: 0, imm[1]: 0
var t=0 w=1 (bpf_link_fops2:count=2): insn.reg r=1

> >  	}
> >  	/* remember insn offset, so we can copy BTF ID and FD later */
> >  	kdesc->insn = insn;
> >  	emit_bpf_find_by_name_kind(gen, relo);
> > -	emit_check_err(gen);
> > +	if (!relo->is_weak)
> > +		emit_check_err(gen);
> > +	/* set default values as 0 */
> > +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
> > +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 0));
> > +	/* skip success case stores if ret < 0 */
> > +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
> >  	/* store btf_id into insn[insn_idx].imm */
> >  	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
> >  	/* store btf_obj_fd into insn[insn_idx + 1].imm */
> >  	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
> >  	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
> >  			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
>
> The double store (first with zeros and then with real values) doesn't look pretty.
> I think an extra jump over two stores would have been cleaner.

I will address all your (and Andrii's) points in another patch.

--
Kartikeya
