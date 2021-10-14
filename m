Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E2742E08F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhJNRzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhJNRzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 13:55:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8F0C061570;
        Thu, 14 Oct 2021 10:53:45 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y4so4723663plb.0;
        Thu, 14 Oct 2021 10:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=81GpCKLCWpbf3M+gsswoRRIpPZEb5Emb7g2uodb7ed8=;
        b=OfUY7PmqAYlld2ccD+6ukE6SfLNrKYXMm+lh+EPpTOxW/YckqgWsf5zYoyTVr0MQXK
         jwm2gfoocbPOceHpvVRvScJVGKT8Q07PY6jugsAVJBKoMR10/9XoPBRAqxuEo8PZmExd
         5mGZIq7oeX5pp8woSq0lWYPQA/YgrTEzHnanvXgy3sDwJ2VLm9Ew/MPDJVs/K47Frfyp
         vVU/cQWCukai9NmBDnK6c9x25UiG3t9ohsigTG6bS8bWiZODA9+SnZOE6nL+aUIU4qqz
         KGPQSW3N6ZNG4k5KGXcVvi3IZ5etnhKyKRnH/W+vjU4wfT/geC9okZHpG9GgUJ6P/MRG
         PFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=81GpCKLCWpbf3M+gsswoRRIpPZEb5Emb7g2uodb7ed8=;
        b=Sq4Fyeiy6ysZgOEPch0UDlSX2NBGnNNsP0bXuiCAhKjswOB24slCFI1nLguJAHaYJY
         ODPXx6NjQv3eXSUFukCRN9y5goEpTOSDP5y/cIJV4XlLZekc4IGNBYzh/b++4y9Ght3h
         x9PgXKsDscRV6oDnj816ey/rZL/2kxdlDHAxV85eKMOZ/JeiJ6MxQ/GwxgPs6ss9wabL
         JAH9VKdWkmI30sFI7uWjsxzixzKP7bprh4tRdTzt/T121y/6jqgy7JXH4Mq/JX/o0/Pv
         e1anfqQAt8ysTYoT/QKjJdUfiJXL8XgYm6BqtGX8Mm5MLmbv3OvuTUnw3g+32jtFvRdb
         a+uw==
X-Gm-Message-State: AOAM532avzYytNs9yN+FfxqWGhqcXYkW+3V+653vd5P9bGhyA4Df21H9
        bVxluOFnBGUNmxs5ZZGLFso=
X-Google-Smtp-Source: ABdhPJySKo0gBFXz1j7VN3suxiLf6meGnOc3OFgMdQK8uIIgc5NnV3SVe0qNk5tnUy+wrKjqMWccrg==
X-Received: by 2002:a17:90b:3ecd:: with SMTP id rm13mr7720613pjb.189.1634234024632;
        Thu, 14 Oct 2021 10:53:44 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id i124sm3173472pfc.153.2021.10.14.10.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 10:53:44 -0700 (PDT)
Date:   Thu, 14 Oct 2021 23:23:41 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to
 gen_loader
Message-ID: <20211014175341.eitbn6ujf4zjkrs7@apollo.localdomain>
References: <20211013073348.1611155-1-memxor@gmail.com>
 <20211013073348.1611155-3-memxor@gmail.com>
 <F745CD84-E520-4DCB-B9F1-0C4F0014CBFF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F745CD84-E520-4DCB-B9F1-0C4F0014CBFF@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 10:09:43PM IST, Song Liu wrote:
>
>
> > On Oct 13, 2021, at 12:33 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > This uses the bpf_kallsyms_lookup_name helper added in previous patches
> > to relocate typeless ksyms. The return value ENOENT can be ignored, and
> > the value written to 'res' can be directly stored to the insn, as it is
> > overwritten to 0 on lookup failure. For repeating symbols, we can simply
> > copy the previously populated bpf_insn.
> >
> > Also, we need to take care to not close fds for typeless ksym_desc, so
> > reuse the 'off' member's space to add a marker for typeless ksym and use
> > that to skip them in cleanup_relos.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> [...]
> > }
> >
> > +/* Expects:
> > + * BPF_REG_8 - pointer to instruction
> > + */
> > +static void emit_relo_ksym_typeless(struct bpf_gen *gen,
> > +				    struct ksym_relo_desc *relo, int insn)
>
> This function has quite some duplicated logic as emit_relo_ksym_btf().
> I guess we can somehow reuse the code here. Say, we pull changes from
> 3/8 first to handle weak type. Then we extend the function to handle
> typeless. Would this work?
>

Ok, will put both into the same function in the next version. Though the part
between:

> > +{
> > +	struct ksym_desc *kdesc;
> > +
> > +	kdesc = get_ksym_desc(gen, relo);
> > +	if (!kdesc)
> > +		return;
> > +	/* try to copy from existing ldimm64 insn */
> > +	if (kdesc->ref > 1) {
> > +		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
> > +			       kdesc->insn + offsetof(struct bpf_insn, imm));
> > +		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
> > +			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));

this and ...

> > +		goto log;
> > +	}
> > +	/* remember insn offset, so we can copy ksym addr later */
> > +	kdesc->insn = insn;
> > +	/* skip typeless ksym_desc in fd closing loop in cleanup_relos */
> > +	kdesc->typeless = true;
> > +	emit_bpf_kallsyms_lookup_name(gen, relo);
> > +	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, -ENOENT, 1));
> > +	emit_check_err(gen);
> > +	/* store lower half of addr into insn[insn_idx].imm */
> > +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9, offsetof(struct bpf_insn, imm)));
> > +	/* store upper half of addr into insn[insn_idx + 1].imm */
> > +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
> > +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9,
> > +		      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));

... this won't overlap (so it will have to jump into the else branch to clear_src_reg).

e.g. it looks something like this:

if (kdesc->ref > 1) {
	move...
	if (!relo->is_typeless)
		...
		goto clear_src_reg;
}
kdesc->insn = insn;
...
if (relo->is_typeless) {
	...
} else {
	...
clear_src_reg:
	...
}

so it looked better to split into separate functions (maybe we can just move the
logging part to common helper? the rest is just duplicating the inital get and
move_blob2blob).

> > +log:
> > +	if (!gen->log_level)
> > +		return;
> > +	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
> > +			      offsetof(struct bpf_insn, imm)));
> > +	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
> > +			      offsetof(struct bpf_insn, imm)));
> > +	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=0 w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
> > +		   relo->is_weak, relo->name, kdesc->ref);
> > +	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
> > +	debug_regs(gen, BPF_REG_9, -1, " var t=0 w=%d (%s:count=%d): insn.reg",
> > +		   relo->is_weak, relo->name, kdesc->ref);
> >
> [...]
>
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6355,17 +6355,14 @@ static int bpf_program__record_externs(struct bpf_program *prog)
> > 		case RELO_EXTERN_VAR:
> > 			if (ext->type != EXT_KSYM)
> > 				continue;
> > -			if (!ext->ksym.type_id) {
> > -				pr_warn("typeless ksym %s is not supported yet\n",
> > -					ext->name);
> > -				return -ENOTSUP;
> > -			}
> > -			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
> > +			bpf_gen__record_extern(obj->gen_loader, ext->name,
> > +					       ext->is_weak, !ext->ksym.type_id,
> > 					       BTF_KIND_VAR, relo->insn_idx);
> > 			break;
> > 		case RELO_EXTERN_FUNC:
> > -			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
> > -					       BTF_KIND_FUNC, relo->insn_idx);
> > +			bpf_gen__record_extern(obj->gen_loader, ext->name,
> > +					       ext->is_weak, 0, BTF_KIND_FUNC,
>
> nit: Prefer use "false" for bool arguments.
>
> > +					       relo->insn_idx);
> > 			break;
> > 		default:
> > 			continue;
> > --
> > 2.33.0
> >
>

--
Kartikeya
