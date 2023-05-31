Return-Path: <netdev+bounces-6714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F417A717964
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82AD81C20E16
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BBDBA30;
	Wed, 31 May 2023 08:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E33A945;
	Wed, 31 May 2023 08:01:26 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F37194;
	Wed, 31 May 2023 01:01:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-514ab6cb529so1360348a12.1;
        Wed, 31 May 2023 01:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685520078; x=1688112078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QoGrXchoY8XOnGrrhPZA4vW5zYjaz8QUvrvECY59y2w=;
        b=d2t/BHHMn748TSi0ZrEVG8fLq6L6+lbT55ghRJvH8CJn1+HCoGy25y5PlyHSlxGX6C
         mxJzIvrZ276yAtVz6ko5mq778Az2rjn4T+mvxS2U+frvncDOXD7nTM5imm8ir9X6x0hD
         cRc49fZt7blAsmu/TuM3HFfPCEvYr2DHqqYulct713IJTYDHMW2DCw1IKmyqIoN0nOaW
         +cUQP0YDL2L6oDeXIYYeZGwLHhn+kNLdsm9lUTxeJfj/7t2NaIpDZTKog/vFduZoLfIl
         7OHq7YvrSp6fx5hWefY+KPYv1jrs4TH+ADNzmiHQD9RnNovWz4vcsM+PdrVYyVC+t/BB
         Ygsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685520078; x=1688112078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoGrXchoY8XOnGrrhPZA4vW5zYjaz8QUvrvECY59y2w=;
        b=amcSXJuP0N91ReUit74Z+dDlxllwbMQi2fKeUm8VB3xSCkeUhoBalK1xxju4aSfbSz
         QSNX6pCXyW/IJoc89lH89faVfwHyCNjomb9bGnxGIN1Lix/8IZGtHzM1kZfcCqGWgypl
         t/rJiIyybOnLYD1sy/fJcl6AixjRyqki+mDqlfY5ylM5gjN49B/cLtvm44D4lAXUHfWH
         av+jZ6hEgMBqTNH4NIzf/ZiJ0wmEllKX3JE8+GVSlFiTupYqWpr8g+6v15Wci+TBAipE
         JrwkRnYVBJVxdAoE9NiTSNrsKqKMciHNQO9SPCP8slL1IrSsVJSa62cwIF6cYsoldcF+
         1T0w==
X-Gm-Message-State: AC+VfDxjxNGrYsq8x8GZt6wLRWRHOYCyjxFyOkn+hNcw0e/pfGFWp7iS
	sNVr1GHAJjFSxMMhl8cHpDw=
X-Google-Smtp-Source: ACHHUZ79tLEH7D9OQoXeO80UuCQ+fHCqagqVQE+FbGkzmGB1Zi+AViDxkHIJdQCqsmGAT/SQ3WL4qg==
X-Received: by 2002:a17:907:36ce:b0:95f:64d8:f795 with SMTP id bj14-20020a17090736ce00b0095f64d8f795mr4942216ejc.27.1685520078210;
        Wed, 31 May 2023 01:01:18 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id bg9-20020a170906a04900b0094f124a37c4sm8671251ejb.18.2023.05.31.01.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 01:01:17 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Wed, 31 May 2023 10:01:14 +0200
To: menglong8.dong@gmail.com
Cc: dsahern@kernel.org, andrii@kernel.org, davem@davemloft.net,
	ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH] bpf, x86: allow function arguments up to 12 for TRACING
Message-ID: <ZHb+ypjE4Ybg3O18@krava>
References: <20230530044423.3897681-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530044423.3897681-1-imagedong@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 12:44:23PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> on the kernel functions whose arguments count less than 6. This is not
> friendly at all, as too many functions have arguments count more than 6.
> 
> Therefore, let's enhance it by increasing the function arguments count
> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> 
> For the case that we don't need to call origin function, which means
> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> that stored in the frame of the caller to current frame. The arguments
> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> "$rbp - regs_off + (6 * 8)".
> 
> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> in stack before call origin function, which means we need alloc extra
> "8 * (arg_count - 6)" memory in the top of the stack. Note, there should
> not be any data be pushed to the stack before call the origin function.
> Then, we have to store rbx with 'mov' instead of 'push'.
> 
> It works well for the FENTRY and FEXIT, I'm not sure if there are other
> complicated cases.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 88 ++++++++++++++++++++++++++++++++-----

please add selftests for this.. I had to add one to be able to check
the generated trampoline

jirka


>  1 file changed, 77 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 1056bbf55b17..a3bc7e86ca19 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1868,7 +1868,7 @@ static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>  	 * mov QWORD PTR [rbp-0x10],rdi
>  	 * mov QWORD PTR [rbp-0x8],rsi
>  	 */
> -	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
> +	for (i = 0, j = 0; i < min(nr_regs, 12); i++) {
>  		/* The arg_size is at most 16 bytes, enforced by the verifier. */
>  		arg_size = m->arg_size[j];
>  		if (arg_size > 8) {
> @@ -1876,10 +1876,22 @@ static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>  			next_same_struct = !next_same_struct;
>  		}
>  
> -		emit_stx(prog, bytes_to_bpf_size(arg_size),
> -			 BPF_REG_FP,
> -			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
> -			 -(stack_size - i * 8));
> +		if (i <= 5) {
> +			/* store function arguments in regs */
> +			emit_stx(prog, bytes_to_bpf_size(arg_size),
> +				 BPF_REG_FP,
> +				 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
> +				 -(stack_size - i * 8));
> +		} else {
> +			/* store function arguments in stack */
> +			emit_ldx(prog, bytes_to_bpf_size(arg_size),
> +				 BPF_REG_0, BPF_REG_FP,
> +				 (i - 6) * 8 + 0x18);
> +			emit_stx(prog, bytes_to_bpf_size(arg_size),
> +				 BPF_REG_FP,
> +				 BPF_REG_0,
> +				 -(stack_size - i * 8));
> +		}
>  
>  		j = next_same_struct ? j : j + 1;
>  	}
> @@ -1913,6 +1925,41 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>  	}
>  }
>  
> +static void prepare_origin_stack(const struct btf_func_model *m, u8 **prog,
> +				 int nr_regs, int stack_size)
> +{
> +	int i, j, arg_size;
> +	bool next_same_struct = false;
> +
> +	if (nr_regs <= 6)
> +		return;
> +
> +	/* Prepare the function arguments in stack before call origin
> +	 * function. These arguments must be stored in the top of the
> +	 * stack.
> +	 */
> +	for (i = 0, j = 0; i < min(nr_regs, 12); i++) {
> +		/* The arg_size is at most 16 bytes, enforced by the verifier. */
> +		arg_size = m->arg_size[j];
> +		if (arg_size > 8) {
> +			arg_size = 8;
> +			next_same_struct = !next_same_struct;
> +		}
> +
> +		if (i > 5) {
> +			emit_ldx(prog, bytes_to_bpf_size(arg_size),
> +				 BPF_REG_0, BPF_REG_FP,
> +				 (i - 6) * 8 + 0x18);
> +			emit_stx(prog, bytes_to_bpf_size(arg_size),
> +				 BPF_REG_FP,
> +				 BPF_REG_0,
> +				 -(stack_size - (i - 6) * 8));
> +		}
> +
> +		j = next_same_struct ? j : j + 1;
> +	}
> +}
> +
>  static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>  			   struct bpf_tramp_link *l, int stack_size,
>  			   int run_ctx_off, bool save_ret)
> @@ -2136,7 +2183,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  				void *func_addr)
>  {
>  	int i, ret, nr_regs = m->nr_args, stack_size = 0;
> -	int regs_off, nregs_off, ip_off, run_ctx_off;
> +	int regs_off, nregs_off, ip_off, run_ctx_off, arg_stack_off, rbx_off;
>  	struct bpf_tramp_links *fentry = &tlinks[BPF_TRAMP_FENTRY];
>  	struct bpf_tramp_links *fexit = &tlinks[BPF_TRAMP_FEXIT];
>  	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
> @@ -2150,8 +2197,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
>  			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
>  
> -	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
> -	if (nr_regs > 6)
> +	/* x86-64 supports up to 12 arguments. 1-6 are passed through
> +	 * regs, the remains are through stack.
> +	 */
> +	if (nr_regs > 12)
>  		return -ENOTSUPP;
>  
>  	/* Generated trampoline stack layout:
> @@ -2170,7 +2219,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	 *
>  	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
>  	 *
> +	 * RBP - rbx_off   [ rbx value       ]  always
> +	 *
>  	 * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
> +	 *
> +	 *                     [ stack_argN ]  BPF_TRAMP_F_CALL_ORIG
> +	 *                     [ ...        ]
> +	 *                     [ stack_arg2 ]
> +	 * RBP - arg_stack_off [ stack_arg1 ]
>  	 */
>  
>  	/* room for return value of orig_call or fentry prog */
> @@ -2190,9 +2246,17 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  
>  	ip_off = stack_size;
>  
> +	stack_size += 8;
> +	rbx_off = stack_size;
> +
>  	stack_size += (sizeof(struct bpf_tramp_run_ctx) + 7) & ~0x7;
>  	run_ctx_off = stack_size;
>  
> +	if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG))
> +		stack_size += (nr_regs - 6) * 8;
> +
> +	arg_stack_off = stack_size;
> +
>  	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
>  		/* skip patched call instruction and point orig_call to actual
>  		 * body of the kernel function.
> @@ -2212,8 +2276,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	x86_call_depth_emit_accounting(&prog, NULL);
>  	EMIT1(0x55);		 /* push rbp */
>  	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> -	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> -	EMIT1(0x53);		 /* push rbx */
> +	EMIT3_off32(0x48, 0x81, 0xEC, stack_size); /* sub rsp, stack_size */
> +	/* mov QWORD PTR [rbp - rbx_off], rbx */
> +	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_6, -rbx_off);
>  
>  	/* Store number of argument registers of the traced function:
>  	 *   mov rax, nr_regs
> @@ -2262,6 +2327,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  
>  	if (flags & BPF_TRAMP_F_CALL_ORIG) {
>  		restore_regs(m, &prog, nr_regs, regs_off);
> +		prepare_origin_stack(m, &prog, nr_regs, arg_stack_off);
>  
>  		if (flags & BPF_TRAMP_F_ORIG_STACK) {
>  			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> @@ -2321,7 +2387,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  	if (save_ret)
>  		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
>  
> -	EMIT1(0x5B); /* pop rbx */
> +	emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
>  	EMIT1(0xC9); /* leave */
>  	if (flags & BPF_TRAMP_F_SKIP_FRAME)
>  		/* skip our return address and return to parent */
> -- 
> 2.40.1
> 

