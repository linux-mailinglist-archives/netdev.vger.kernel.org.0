Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8254546E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfFNGAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:00:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35349 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfFNGAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 02:00:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so552961plo.2;
        Thu, 13 Jun 2019 23:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PNllyiNPePpmts4Pc87kGwpa1biWOwXKxqA4hiAUYe8=;
        b=XdHhVgbGsLKbKl2SIQMZ/w8qFREHTIoXfwJhoYk2mPe+/rIgmH7KPorNo8eVgTrv4+
         6hJjriKgFKjA2/Xk3WW32mqxqlpyHG0m8tIwtVQsUUQJp/lTVq9IpKNd4ilyR7Uy6mdC
         QoHz69LyEQv8vUKjwpHNUAJQRm9WjDpCqZHIkrrzJFAlR54DNQJmeJvQkhxzFwH91lbL
         LMcnkLPt+lawuJEC/mmqMMHmxQLcxY/Eo6iMOv6E88BVLKwAAA+X3nr1P12ceGQhVFBR
         xpl1MypOSmTIKFBZVkVOo+PEC6thRC+LlCrHO8r1Thyg3TWcUHXHIh4cFMWLhI5jyzj7
         Mnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PNllyiNPePpmts4Pc87kGwpa1biWOwXKxqA4hiAUYe8=;
        b=C7jygnuJpORWuaskYe8TZNPE4ShFRi8+tHhs5zxwDFsz+RUWXCwPfvAWak5k04kRFF
         MryE4vqzE5/cXG7xXrNvyrHSwAS3z+biUaU5P6ouwRFclIcAfhI/Ec0DGKFxcsBPyHBj
         al+uJgJZS8pgA/tv5LpYrFpAX2naAV+RXQXUOvEiobWYIrRXRqFDzmqpm+n/DrihLBwx
         gGpOOC69aPCSSU3pJwdixnj9yPpaNp1jQ3Lo2XjL3lG5yFiEHy8K4R+FneyDXGg2jkAy
         /05liYtu4ePgBplrm2mcn53BucIBo9GsCkEyLfkoMGFaDOwYvY8XNp0KuOkHBetPbUqD
         QeFw==
X-Gm-Message-State: APjAAAWvRTTroLFUIWhOOnf+jKEPVN/R7bdtr+j6zU2e2Y45CJAi3Ai5
        UUN91v+Qsp+V9s1cPcyFhhw7cdCG
X-Google-Smtp-Source: APXvYqxa10BHBNCSX6ZXiNOtwPtmlhios3JctohSb964IPax1aOEtPcqtzkwU4Z3mKXf3fCfLjIZ/Q==
X-Received: by 2002:a17:902:9897:: with SMTP id s23mr24422200plp.47.1560492012441;
        Thu, 13 Jun 2019 23:00:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1:f6f1])
        by smtp.gmail.com with ESMTPSA id j7sm1605660pfa.184.2019.06.13.23.00.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 23:00:11 -0700 (PDT)
Date:   Thu, 13 Jun 2019 23:00:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614045037.zinbi2sivthcfrtg@treble>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 11:50:37PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 09:28:48PM -0500, Josh Poimboeuf wrote:
> > On Thu, Jun 13, 2019 at 08:58:48PM -0500, Josh Poimboeuf wrote:
> > > On Thu, Jun 13, 2019 at 06:42:45PM -0700, Alexei Starovoitov wrote:
> > > > On Thu, Jun 13, 2019 at 08:30:51PM -0500, Josh Poimboeuf wrote:
> > > > > On Thu, Jun 13, 2019 at 03:00:55PM -0700, Alexei Starovoitov wrote:
> > > > > > > @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
> > > > > > >  	 * calls and calls to noreturn functions.
> > > > > > >  	 */
> > > > > > >  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> > > > > > > -	if (!orc)
> > > > > > > -		goto err;
> > > > > > > +	if (!orc) {
> > > > > > > +		/*
> > > > > > > +		 * As a fallback, try to assume this code uses a frame pointer.
> > > > > > > +		 * This is useful for generated code, like BPF, which ORC
> > > > > > > +		 * doesn't know about.  This is just a guess, so the rest of
> > > > > > > +		 * the unwind is no longer considered reliable.
> > > > > > > +		 */
> > > > > > > +		orc = &orc_fp_entry;
> > > > > > > +		state->error = true;
> > > > > > 
> > > > > > That seems fragile.
> > > > > 
> > > > > I don't think so.  The unwinder has sanity checks to make sure it
> > > > > doesn't go off the rails.  And it works just fine.  The beauty is that
> > > > > it should work for all generated code (not just BPF).
> > > > > 
> > > > > > Can't we populate orc_unwind tables after JIT ?
> > > > > 
> > > > > As I mentioned it would introduce a lot more complexity.  For each JIT
> > > > > function, BPF would have to tell ORC the following:
> > > > > 
> > > > > - where the BPF function lives
> > > > > - how big the stack frame is
> > > > > - where RBP and other callee-saved regs are on the stack
> > > > 
> > > > that sounds like straightforward addition that ORC should have anyway.
> > > > right now we're not using rbp in the jit-ed code,
> > > > but one day we definitely will.
> > > > Same goes for r12. It's reserved right now for 'strategic use'.
> > > > We've been thinking to add another register to bpf isa.
> > > > It will map to r12 on x86. arm64 and others have plenty of regs to use.
> > > > The programs are getting bigger and register spill/fill starting to
> > > > become a performance concern. Extra register will give us more room.
> > > 
> > > With CONFIG_FRAME_POINTER, RBP isn't available.  If you look at all the
> > > code in the entire kernel you'll notice that BPF JIT is pretty much the
> > > only one still clobbering it.
> > 
> > Hm.  If you wanted to eventually use R12 for other purposes, there might
> > be a way to abstract BPF_REG_FP such that it doesn't actually need a
> > dedicated register.  The BPF program's frame pointer will always be a
> > certain constant offset away from RBP (real frame pointer), so accesses
> > to BPF_REG_FP could still be based on RBP, but with an offset added to
> > it.
> 
> How about something like this (based on top of patch 4)?  This fixes
> frame pointers without using R12, by making BPF_REG_FP equivalent to
> RBP, minus a constant offset (callee-save area + tail_call_cnt = 40).
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 485692d4b163..2f313622c741 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -104,6 +104,9 @@ static int bpf_size_to_x86_bytes(int bpf_size)
>   * register in load/store instructions, it always needs an
>   * extra byte of encoding and is callee saved.
>   *
> + * BPF_REG_FP corresponds to x86-64 register RBP, but 40 bytes must be
> + * subtracted from it to get the BPF_REG_FP value.
> + *
>   * Also x86-64 register R9 is unused. x86-64 register R10 is
>   * used for blinding (if enabled).
>   */
> @@ -118,11 +121,18 @@ static const int reg2hex[] = {
>  	[BPF_REG_7] = 5,  /* R13 callee saved */
>  	[BPF_REG_8] = 6,  /* R14 callee saved */
>  	[BPF_REG_9] = 7,  /* R15 callee saved */
> -	[BPF_REG_FP] = 5, /* RBP readonly */
> +	[BPF_REG_FP] = 5, /* (RBP - 40 bytes) readonly */
>  	[BPF_REG_AX] = 2, /* R10 temp register */
>  	[AUX_REG] = 3,    /* R11 temp register */
>  };
>  
> +static s16 offset(struct bpf_insn *insn)
> +{
> +	if (insn->src_reg == BPF_REG_FP || insn->dst_reg == BPF_REG_FP)
> +		return insn->off - 40;
> +	return insn->off;
> +}
> +
>  /*
>   * is_ereg() == true if BPF register 'reg' maps to x86-64 r8..r15
>   * which need extra byte of encoding.
> @@ -197,14 +207,18 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
>  	u8 *prog = *pprog;
>  	int cnt = 0;
>  
> +	/* push rbp */
> +	EMIT1(0x55);
> +
> +	/* mov rbp,rsp */
> +	EMIT3(0x48, 0x89, 0xE5);
> +
>  	/* push r15 */
>  	EMIT2(0x41, 0x57);
>  	/* push r14 */
>  	EMIT2(0x41, 0x56);
>  	/* push r13 */
>  	EMIT2(0x41, 0x55);
> -	/* push rbp */
> -	EMIT1(0x55);
>  	/* push rbx */
>  	EMIT1(0x53);
>  
> @@ -216,14 +230,6 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
>  	 */
>  	EMIT2(0x6a, 0x00);
>  
> -	/*
> -	 * RBP is used for the BPF program's FP register.  It points to the end
> -	 * of the program's stack area.
> -	 *
> -	 * mov rbp, rsp
> -	 */
> -	EMIT3(0x48, 0x89, 0xE5);
> -
>  	/* sub rsp, rounded_stack_depth */
>  	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
>  
> @@ -237,19 +243,19 @@ static void emit_epilogue(u8 **pprog)
>  	u8 *prog = *pprog;
>  	int cnt = 0;
>  
> -	/* lea rsp, [rbp+0x8] */
> -	EMIT4(0x48, 0x8D, 0x65, 0x08);
> +	/* lea rsp, [rbp-0x20] */
> +	EMIT4(0x48, 0x8D, 0x65, 0xE0);
>  
>  	/* pop rbx */
>  	EMIT1(0x5B);
> -	/* pop rbp */
> -	EMIT1(0x5D);
>  	/* pop r13 */
>  	EMIT2(0x41, 0x5D);
>  	/* pop r14 */
>  	EMIT2(0x41, 0x5E);
>  	/* pop r15 */
>  	EMIT2(0x41, 0x5F);
> +	/* pop rbp */
> +	EMIT1(0x5D);
>  
>  	/* ret */
>  	EMIT1(0xC3);
> @@ -298,13 +304,13 @@ static void emit_bpf_tail_call(u8 **pprog)
>  	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
>  	 *	goto out;
>  	 */
> -	EMIT3(0x8B, 0x45, 0x04);                  /* mov eax, dword ptr [rbp + 4] */
> +	EMIT3(0x8B, 0x45, 0xDC);                  /* mov eax, dword ptr [rbp - 36] */
>  	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
>  #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
>  	EMIT2(X86_JA, OFFSET2);                   /* ja out */
>  	label2 = cnt;
>  	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
> -	EMIT3(0x89, 0x45, 0x04);                  /* mov dword ptr [rbp + 4], eax */
> +	EMIT3(0x89, 0x45, 0xDC);                  /* mov dword ptr [rbp - 36], eax */
>  
>  	/* prog = array->ptrs[index]; */
>  	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
> @@ -418,6 +424,17 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
>  		EMIT2(0x89, add_2reg(0xC0, dst_reg, src_reg));
>  	}
>  
> +	if (src_reg == BPF_REG_FP) {
> +		/*
> +		 * If the value was copied from RBP (real frame pointer),
> +		 * adjust it to the BPF program's frame pointer value.
> +		 *
> +		 * add dst, -40
> +		 */
> +		EMIT4(add_1mod(0x48, dst_reg), 0x83, add_1reg(0xC0, dst_reg),
> +		      0xD8);
> +	}
> +

That won't work. Any register can point to a stack.
The register can point to a stack of a different JITed function as well.

There is something wrong with
commit d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")

If I simply revert it and have CONFIG_UNWINDER_FRAME_POINTER=y
JITed stacks work just fine, because
bpf_get_stackid()->get_perf_callchain()
need to start unwinding before any bpf stuff.
After that commit it needs to go through which is a bug on its own.
imo patch 1 doesn't really fix that issue.

As far as mangled rbp can we partially undo old
commit 177366bf7ceb ("bpf: change x86 JITed program stack layout")
that introduced that rbp adjustment.
Going through bpf code is only interesting in case of panics somewhere
in bpf helpers. Back then we didn't even have ksym of jited code.

Anyhow I agree that we need to make the jited frame proper,
but unwinding need to start before any bpf stuff.
That's a bigger issue.

