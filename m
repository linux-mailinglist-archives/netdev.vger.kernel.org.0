Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B264646C1AD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240028AbhLGR0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:26:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240004AbhLGR0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 12:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638897802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tyZEAPx8uEp6BqLobkY95n81q55nTjqsaRONsnhv2WI=;
        b=UZxbzt7Y7MzcGWvmpfRm7b6LrUS06YK9o7x8B1CwcCSHjLX2FB3L2gI62GStnGC4KTrQvn
        jtQk5M6Tzh/eieQDu+ip+DxDkoxZSJ7wlzxjnQsmpIz094dy8bKee2BoUdWRXZQCOr/RW8
        ub7BmA6v6fT3XhMIBZCmR41nu6ySqkU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-559-dbun5ikcMySVpVzEiVMOeQ-1; Tue, 07 Dec 2021 12:23:21 -0500
X-MC-Unique: dbun5ikcMySVpVzEiVMOeQ-1
Received: by mail-wr1-f72.google.com with SMTP id o4-20020adfca04000000b0018f07ad171aso3202994wrh.20
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 09:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tyZEAPx8uEp6BqLobkY95n81q55nTjqsaRONsnhv2WI=;
        b=nPLKAAt9DVQE1Wh6V4SBRN5Ki6ZmPhDDEeI0j1VCrEyle6E0oyDj25m59UGFDbrjUI
         Xsjx5kNqx1ojy+GL/1sfDrvytLaoewoY+lcgeestMJVJO+tYnbn3M6d/hJuspN8FsCme
         g3fbR1ceC3NH+9YZ00pw/niLs4dfDWWYLPlO6CejU2J5rkHoguhMZbD8nh+Cj+45UHFf
         I0Nlw590H3jNIG7hRm7Tioj3VxEPzV7GMCrIG6xJgZikCqSg6pG1LFbV3BUxDYIum1+8
         OziTRi+cN+n7cO2qzvlOow/wpmdkAnXGb3Tht417kDmRCGMVNuedMIx99w5lbm9NaH+A
         dFAQ==
X-Gm-Message-State: AOAM5303lBObNDrEwM1KVo/iTRRGFIM3fGXkmJLFJ/9lmzzDF+I0p6Vo
        caXdKwvZS9NHxu6aH6PstRq6Wm79xi4OF1L7ZbGpvu4jgPxn8BwjJWawP8QOSRXVM9W+44jLoPy
        bRCpFHayfJxIwhOrY
X-Received: by 2002:a5d:6d0b:: with SMTP id e11mr53460656wrq.16.1638897799913;
        Tue, 07 Dec 2021 09:23:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2rWeOH7vHLSEtjqmJ7mx9kmtIWVUH9NqDQT3V9aQwFBWLJKXWEJeqFdInYPBG9EwhxYRkEQ==
X-Received: by 2002:a5d:6d0b:: with SMTP id e11mr53460630wrq.16.1638897799701;
        Tue, 07 Dec 2021 09:23:19 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b197sm199745wmb.24.2021.12.07.09.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 09:23:18 -0800 (PST)
Date:   Tue, 7 Dec 2021 18:23:12 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add get_func_[arg|ret|arg_cnt] helpers
Message-ID: <Ya+YgJta0JYBvxrB@krava>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-3-jolsa@kernel.org>
 <f1cf12b9-01f5-f980-a349-1cbcd1124409@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1cf12b9-01f5-f980-a349-1cbcd1124409@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 01:54:53PM -0800, Andrii Nakryiko wrote:
> 
> On 12/4/21 6:06 AM, Jiri Olsa wrote:
> > Adding following helpers for tracing programs:
> > 
> > Get n-th argument of the traced function:
> >    long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> > 
> > Get return value of the traced function:
> >    long bpf_get_func_ret(void *ctx, u64 *value)
> > 
> > Get arguments count of the traced funtion:
> >    long bpf_get_func_arg_cnt(void *ctx)
> > 
> > The trampoline now stores number of arguments on ctx-8
> > address, so it's easy to verify argument index and find
> > return value argument's position.
> > 
> > Moving function ip address on the trampoline stack behind
> > the number of functions arguments, so it's now stored on
> > ctx-16 address if it's needed.
> > 
> > All helpers above are inlined by verifier.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> 
> Please cc me at andrii@kernel.org email for future emails, you'll save a lot
> of trouble with replying to your emails :) Thanks!

ugh, updated


SNIP
 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c26871263f1f..d5a3791071d6 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4983,6 +4983,31 @@ union bpf_attr {
> >    *	Return
> >    *		The number of loops performed, **-EINVAL** for invalid **flags**,
> >    *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
> > + *
> > + * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> > + *	Description
> > + *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
> > + *		returned in **value**.
> > + *
> > + *	Return
> > + *		0 on success.
> > + *		**-EINVAL** if n >= arguments count of traced function.
> > + *
> > + * long bpf_get_func_ret(void *ctx, u64 *value)
> > + *	Description
> > + *		Get return value of the traced function (for tracing programs)
> > + *		in **value**.
> > + *
> > + *	Return
> > + *		0 on success.
> > + *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.
> 
> 
> -EOPNOTSUPP maybe?

ok

> 
> 
> > + *
> > + * long bpf_get_func_arg_cnt(void *ctx)
> > + *	Description
> > + *		Get number of arguments of the traced function (for tracing programs).
> > + *
> > + *	Return
> > + *		The number of arguments of the traced function.
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -5167,6 +5192,9 @@ union bpf_attr {
> >   	FN(kallsyms_lookup_name),	\
> >   	FN(find_vma),			\
> >   	FN(loop),			\
> > +	FN(get_func_arg),		\
> > +	FN(get_func_ret),		\
> > +	FN(get_func_arg_cnt),		\
> >   	/* */
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6522ffdea487..cf6853d3a8e9 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -12974,6 +12974,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
> >   static int do_misc_fixups(struct bpf_verifier_env *env)
> >   {
> >   	struct bpf_prog *prog = env->prog;
> > +	enum bpf_attach_type eatype = prog->expected_attach_type;
> >   	bool expect_blinding = bpf_jit_blinding_enabled(prog);
> >   	enum bpf_prog_type prog_type = resolve_prog_type(prog);
> >   	struct bpf_insn *insn = prog->insnsi;
> > @@ -13344,11 +13345,79 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >   			continue;
> >   		}
> > +		/* Implement bpf_get_func_arg inline. */
> > +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +		    insn->imm == BPF_FUNC_get_func_arg) {
> > +			/* Load nr_args from ctx - 8 */
> > +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
> > +			insn_buf[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
> > +			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > +			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > +			insn_buf[5] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
> > +			insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > +			insn_buf[7] = BPF_JMP_A(1);
> > +			insn_buf[8] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
> > +			cnt = 9;
> > +
> > +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> > +
> > +			delta    += cnt - 1;
> > +			env->prog = prog = new_prog;
> > +			insn      = new_prog->insnsi + i + delta;
> > +			continue;
> > +		}
> > +
> > +		/* Implement bpf_get_func_ret inline. */
> > +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +		    insn->imm == BPF_FUNC_get_func_ret) {
> > +			if (eatype == BPF_TRACE_FEXIT ||
> > +			    eatype == BPF_MODIFY_RETURN) {
> > +				/* Load nr_args from ctx - 8 */
> > +				insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +				insn_buf[1] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_0, 3);
> > +				insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1);
> > +				insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
> > +				insn_buf[4] = BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, 0);
> > +				insn_buf[5] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > +				cnt = 6;
> > +			} else {
> > +				insn_buf[0] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
> > +				cnt = 1;
> > +			}
> > +
> > +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> > +
> > +			delta    += cnt - 1;
> > +			env->prog = prog = new_prog;
> > +			insn      = new_prog->insnsi + i + delta;
> > +			continue;
> > +		}
> > +
> > +		/* Implement get_func_arg_cnt inline. */
> > +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +		    insn->imm == BPF_FUNC_get_func_arg_cnt) {
> > +			/* Load nr_args from ctx - 8 */
> > +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +
> > +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> > +
> > +			env->prog = prog = new_prog;
> > +			insn      = new_prog->insnsi + i + delta;
> > +			continue;
> > +		}
> 
> 
> To be entirely honest, I'm not even sure we need to inline them. In programs
> that care about performance they will be called at most once. In others it
> doesn't matter. But even if they weren't, is the function call really such a
> big overhead for tracing cases? I don't mind it either, I just can hardly
> follow it.

maybe just inline get_func_arg_cnt, because it's just one instruction,
the other 2 I don't skipping the inline

jirka

