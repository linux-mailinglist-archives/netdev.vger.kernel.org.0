Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09873BF3E2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 04:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhGHCOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 22:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhGHCOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 22:14:08 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CEEC061574;
        Wed,  7 Jul 2021 19:11:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q10so4030013pfj.12;
        Wed, 07 Jul 2021 19:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=316L5rfChZHhgSmIsa/mv70DJZD3Iupb/gjN06zoayI=;
        b=CxL2vIKyB+heXsV3W+GzKGxtZG9oWQJ2esT6mMWs7TjKAe6Iun6crYP2cbm3Vpfp1n
         8uky0MfjSGNI4hh8cBteEsPC47McDA3FUdDaA9D4O99axPqM+41R2GnsnlpfEE2eZysQ
         4PbFxInS7pU9HpO8sio8jtFjMYkOwDmwX2+xn6RypDoPw+TypQZ7tOwRIxVkIEP5apDD
         qQVT59ci0G73mgQ7s94OfCSv1pMnGqIw9l60XuxoAW4rFNn580urMI7048qJrEj99uhb
         6SiGxGkfqmVtxtq8rcuRqyDNYpZ0onVxR69cwXot1mm8UNVpQorfgOIj52Od4LULixZN
         LVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=316L5rfChZHhgSmIsa/mv70DJZD3Iupb/gjN06zoayI=;
        b=jeA9qNy0qvU/7PdqZ5CUd9+MrcCDXn8JMPPOKodZf+CTufvJCkfLiGxf2SU1/vtlH5
         cQ2W+Y+auB7DaBNeP4/X29uZSElKq9sHBY20XKsd9lAY5p3YicB9VMybYBuRG7g7DaBQ
         dLS1vbG2UGH4b7hu15MsAJ1A2H6CC565OJWMovP7c8uIgqgMeV3UIOP4cXbA7x5u4qeQ
         DJSOaMZXbtGXGP6d2yOXS80FTUzo5g3qnyhq9Dmm1kWwzEJBu/vx/wrfVLmOKnUMtpWt
         7i+dhO/8qvtKLFoopYi/8GXKmWC9QiXHRXFhMorUUF6mY427SOhaH637+VWvi2vbkKSq
         otTw==
X-Gm-Message-State: AOAM533a7POHpRDjY3LYSZR/NxX6jaWLtt7v8eMkS/Ze23KLKZ8NAPdE
        a9Je3d4NIe8UQowI7X4fco4=
X-Google-Smtp-Source: ABdhPJzcBxviwBOUhyWGhl7CoXwV1ndXf2osWEb4ceQH79KTYwfxQlrB5yKfq3sl/Lrrab5qCkNCiQ==
X-Received: by 2002:a62:cd44:0:b029:316:643c:1ee3 with SMTP id o65-20020a62cd440000b0290316643c1ee3mr28744366pfg.5.1625710287335;
        Wed, 07 Jul 2021 19:11:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id u23sm636960pgk.38.2021.07.07.19.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 19:11:26 -0700 (PDT)
Date:   Wed, 7 Jul 2021 19:11:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 3/7] bpf: Add bpf_get_func_ip helper for
 tracing programs
Message-ID: <20210708021123.w4smo42jml57iowl@ast-mbp.dhcp.thefacebook.com>
References: <20210707214751.159713-1-jolsa@kernel.org>
 <20210707214751.159713-4-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707214751.159713-4-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 11:47:47PM +0200, Jiri Olsa wrote:
>  
> +static bool allow_get_func_ip_tracing(struct bpf_verifier_env *env)
> +{
> +	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);

Why does it have to be gated by 'jited && x86_64' ?
It's gated by bpf trampoline and it's only implemented on x86_64 so far.
The trampoline has plenty of features. I would expect bpf trampoline
for arm64 to implement all of them. If not the func_ip would be just
one of the trampoline features that couldn't be implemented and at that
time we'd need a flag mask of a sort, but I'd rather push of feature
equivalence between trampoline implementations.

Then jited part also doesn't seem to be necessary.
The trampoline passed pointer to a stack in R1.
Interpreter should deal with BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8) insn
the same way and it should work, since trampoline prepared it.
What did I miss?

> +static int has_get_func_ip(struct bpf_verifier_env *env)
> +{
> +	enum bpf_attach_type eatype = env->prog->expected_attach_type;
> +	enum bpf_prog_type type = resolve_prog_type(env->prog);
> +	int func_id = BPF_FUNC_get_func_ip;
> +
> +	if (type == BPF_PROG_TYPE_TRACING) {
> +		if (eatype != BPF_TRACE_FENTRY && eatype != BPF_TRACE_FEXIT &&
> +		    eatype != BPF_MODIFY_RETURN) {
> +			verbose(env, "func %s#%d supported only for fentry/fexit/fmod_ret programs\n",
> +				func_id_name(func_id), func_id);
> +			return -ENOTSUPP;
> +		}
> +		if (!allow_get_func_ip_tracing(env)) {
> +			verbose(env, "func %s#%d for tracing programs supported only for JITed x86_64\n",
> +				func_id_name(func_id), func_id);
> +			return -ENOTSUPP;
> +		}
> +		return 0;
> +	}
> +
> +	verbose(env, "func %s#%d not supported for program type %d\n",
> +		func_id_name(func_id), func_id, type);
> +	return -ENOTSUPP;
> +}
> +
>  static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  			     int *insn_idx_p)
>  {
> @@ -6225,6 +6256,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  	if (func_id == BPF_FUNC_get_stackid || func_id == BPF_FUNC_get_stack)
>  		env->prog->call_get_stack = true;
>  
> +	if (func_id == BPF_FUNC_get_func_ip) {
> +		if (has_get_func_ip(env))
> +			return -ENOTSUPP;
> +		env->prog->call_get_func_ip = true;
> +	}
> +
>  	if (changes_data)
>  		clear_all_pkt_pointers(env);
>  	return 0;
> @@ -12369,6 +12406,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>  {
>  	struct bpf_prog *prog = env->prog;
>  	bool expect_blinding = bpf_jit_blinding_enabled(prog);
> +	enum bpf_prog_type prog_type = resolve_prog_type(prog);
>  	struct bpf_insn *insn = prog->insnsi;
>  	const struct bpf_func_proto *fn;
>  	const int insn_cnt = prog->len;
> @@ -12702,6 +12740,21 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>  			continue;
>  		}
>  
> +		/* Implement bpf_get_func_ip inline. */
> +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> +		    insn->imm == BPF_FUNC_get_func_ip) {
> +			/* Load IP address from ctx - 8 */
> +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			continue;
> +		}
> +
>  patch_call_imm:
>  		fn = env->ops->get_func_proto(insn->imm, env->prog);
>  		/* all functions that have prototype and verifier allowed
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 64bd2d84367f..9edd3b1a00ad 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -948,6 +948,19 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
>  	.arg5_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
> +{
> +	/* Stub, the helper call is inlined in the program. */
> +	return 0;
> +}

may be add a WARN in here that it should never be executed ?
Or may be add an actual implementation:
 return ((u64 *)ctx)[-1];
and check that it works without inlining by the verifier?
