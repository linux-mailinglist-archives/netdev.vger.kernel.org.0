Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF25C269D7F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgIOEje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgIOEj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:39:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F45C06174A;
        Mon, 14 Sep 2020 21:39:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d19so679179pld.0;
        Mon, 14 Sep 2020 21:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CT2DA0L5QIO62rgxbmqHh76vJTvwmF0J8tLl4pCaoPU=;
        b=H3WuFfyQl7gN7NTFSuSLBGZMnKpQDmOLnppo2sLWCsw/TMCoAQp7b21VoZCe/La3WE
         /tdNg9MqgaNJ+VFtlLzz3uiO+jwJPoDji2XKqueDfPrAx2wdqJopWKcDUUPdr+7YGMgv
         dqY+U/RJWFNaka8+YZg9cKD4MoKOh0znW8VgccuHUg0jzRh2X0XbSfkQkgtm0+Y+2yuI
         xkbitLLSfM7A6aE4CdBK8P+d042UMzCAh/D2bNUHZeHEVORyvuRYjCNcUA3IlwXPjF6B
         +MOCTXwtNR0Wr6azkW1qjYGcbN6gW5mV+AFxf9YgEFTr4GhkvEJSAyB/W2OzX2O64cLv
         KmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CT2DA0L5QIO62rgxbmqHh76vJTvwmF0J8tLl4pCaoPU=;
        b=QQhIjYSUDPh6rmLPyOBaD0yovHQCSHry2I3GPsAIcCXJhxA2qvum3rQ3OTZ4M00xnd
         DgfsIqs3tvpC73W6XnCf/ATF+Ds8wsQjkrYXnBoHPdtUa/9zT/tE2rnfat91pzK/CQ6U
         4oznMd9m8yYM6Os5tBbI3G6Qs6Eo1b604UGMHIhzN5nAFGA/WoVs111nOdNCVhOYtjFP
         ANw7zQG9u2ZwqvJyorSXA+GqRA76FfvKfYSpFlxwzCBX1HfkjFLsJG6O2G+2DcvAwXRP
         gzr572Z1ckq4FM5DNPJFNfw7Sl7bH6PxWo/CiIXAiTAsoXRD1WpGNdtGh/aOSRC78jBn
         Wf/Q==
X-Gm-Message-State: AOAM532NsWe+cWI+56UPftcTrOsI0MLvsk2VOpzRWp9j6bFzKhTnR7OT
        rh0g/DNcyUk4dnzU9FYAcXY=
X-Google-Smtp-Source: ABdhPJwZHAKlQOXAnEqw3dhH6mnfmh+6Hld2uq34IpPp04u7KmTna++QOj7sZMOxQGeWmwxKj5Vw+A==
X-Received: by 2002:a17:90a:f686:: with SMTP id cl6mr2385547pjb.43.1600144767687;
        Mon, 14 Sep 2020 21:39:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f16b])
        by smtp.gmail.com with ESMTPSA id e125sm11823659pfe.154.2020.09.14.21.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 21:39:26 -0700 (PDT)
Date:   Mon, 14 Sep 2020 21:39:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v7 bpf-next 7/7] selftests: bpf: add dummy prog for
 bpf2bpf with tailcall
Message-ID: <20200915043924.uicfgbhuszccycbq@ast-mbp.dhcp.thefacebook.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
 <20200902200815.3924-8-maciej.fijalkowski@intel.com>
 <20200903195114.ccfzmgcl4ngz2mqv@ast-mbp.dhcp.thefacebook.com>
 <20200911185927.GA2543@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911185927.GA2543@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 08:59:27PM +0200, Maciej Fijalkowski wrote:
> On Thu, Sep 03, 2020 at 12:51:14PM -0700, Alexei Starovoitov wrote:
> > On Wed, Sep 02, 2020 at 10:08:15PM +0200, Maciej Fijalkowski wrote:
> > > diff --git a/tools/testing/selftests/bpf/progs/tailcall6.c b/tools/testing/selftests/bpf/progs/tailcall6.c
> > > new file mode 100644
> > > index 000000000000..e72ca5869b58
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/tailcall6.c
> > > @@ -0,0 +1,38 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +
> > > +struct {
> > > +	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> > > +	__uint(max_entries, 2);
> > > +	__uint(key_size, sizeof(__u32));
> > > +	__uint(value_size, sizeof(__u32));
> > > +} jmp_table SEC(".maps");
> > > +
> > > +#define TAIL_FUNC(x) 				\
> > > +	SEC("classifier/" #x)			\
> > > +	int bpf_func_##x(struct __sk_buff *skb)	\
> > > +	{					\
> > > +		return x;			\
> > > +	}
> > > +TAIL_FUNC(0)
> > > +TAIL_FUNC(1)
> > > +
> > > +static __attribute__ ((noinline))
> > > +int subprog_tail(struct __sk_buff *skb)
> > > +{
> > > +	bpf_tail_call(skb, &jmp_table, 0);
> > > +
> > > +	return skb->len * 2;
> > > +}
> > > +
> > > +SEC("classifier")
> > > +int entry(struct __sk_buff *skb)
> > > +{
> > > +	bpf_tail_call(skb, &jmp_table, 1);
> > > +
> > > +	return subprog_tail(skb);
> > > +}
> > 
> > Could you add few more tests to exercise the new feature more thoroughly?
> > Something like tailcall3.c that checks 32 limit, but doing tail_call from subprog.
> > And another test that consume non-trival amount of stack in each function.
> > Adding 'volatile char arr[128] = {};' would do the trick.
> 
> Yet another prolonged silence from my side, but not without a reason -
> this request opened up a Pandora's box.

Great catch and thanks to our development practices! As a community we should
remember this lesson and request selftests more often than not.

> First thing that came out when I added the global variable to act as a
> counter in the tailcall3-like subprog-based test was the fact that when
> the patching happen, we need to update the index of tailcall insn that we
> store within the poke descriptor. Due to patching and insn not being
> adjusted, the poke descriptor was not propagated to subprogram and JIT
> started to fail.
> 
> It's rather obvious change so I won't post it here to decrease the chaos
> in this response, but I simply teached bpf_patch_insn_data() to go over
> poke descriptors and update the insn_idx by given len. Will include in
> next revision.

+1

> Now onto serious stuff that I would like to discuss. Turns out that for
> tailcall3-like selftest:
> 
> // SPDX-License-Identifier: GPL-2.0
> #include <linux/bpf.h>
> #include <bpf/bpf_helpers.h>
> 
> struct {
> 	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> 	__uint(max_entries, 1);
> 	__uint(key_size, sizeof(__u32));
> 	__uint(value_size, sizeof(__u32));
> } jmp_table SEC(".maps");
> 
> static __attribute__ ((noinline))
> int subprog_tail(struct __sk_buff *skb)
> {
> 	bpf_tail_call(skb, &jmp_table, 0);
> 	return 1;
> }
> 
> SEC("classifier/0")
> int bpf_func_0(struct __sk_buff *skb)
> {
> 	return subprog_tail(skb);
> }
> 
> SEC("classifier")
> int entry(struct __sk_buff *skb)
> {
> 	bpf_tail_call(skb, &jmp_table, 0);
> 
> 	return 0;
> }
> 
> char __license[] SEC("license") = "GPL";
> int _version SEC("version") = 1;
> 
> following asm was generated:
> 
> entry:
> ffffffffa0ca0c40 <load4+0xca0c40>:
> ffffffffa0ca0c40:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> ffffffffa0ca0c45:       31 c0                   xor    %eax,%eax
> ffffffffa0ca0c47:       55                      push   %rbp
> ffffffffa0ca0c48:       48 89 e5                mov    %rsp,%rbp
> ffffffffa0ca0c4b:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
> ffffffffa0ca0c52:       50                      push   %rax
> ffffffffa0ca0c53:       48 be 00 6c b1 c1 81    movabs $0xffff8881c1b16c00,%rsi
> ffffffffa0ca0c5a:       88 ff ff 
> ffffffffa0ca0c5d:       31 d2                   xor    %edx,%edx
> ffffffffa0ca0c5f:       8b 85 fc ff ff ff       mov    -0x4(%rbp),%eax
> ffffffffa0ca0c65:       83 f8 20                cmp    $0x20,%eax
> ffffffffa0ca0c68:       77 1b                   ja     0xffffffffa0ca0c85
> ffffffffa0ca0c6a:       83 c0 01                add    $0x1,%eax
> ffffffffa0ca0c6d:       89 85 fc ff ff ff       mov    %eax,-0x4(%rbp)
> ffffffffa0ca0c73:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> ffffffffa0ca0c78:       58                      pop    %rax
> ffffffffa0ca0c79:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> ffffffffa0ca0c80:       e9 d2 b6 ff ff          jmpq   0xffffffffa0c9c357
> ffffffffa0ca0c85:       31 c0                   xor    %eax,%eax
> ffffffffa0ca0c87:       59                      pop    %rcx
> ffffffffa0ca0c88:       c9                      leaveq 
> ffffffffa0ca0c89:       c3                      retq
> 
> func0:
> ffffffffa0c9c34c <load4+0xc9c34c>:
> ffffffffa0c9c34c:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> ffffffffa0c9c351:       66 90                   xchg   %ax,%ax
> ffffffffa0c9c353:       55                      push   %rbp
> ffffffffa0c9c354:       48 89 e5                mov    %rsp,%rbp
> ffffffffa0c9c357:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
> ffffffffa0c9c35e:       e8 b1 20 00 00          callq  0xffffffffa0c9e414
> ffffffffa0c9c363:       b8 01 00 00 00          mov    $0x1,%eax
> ffffffffa0c9c368:       c9                      leaveq 
> ffffffffa0c9c369:       c3                      retq 
> 
> subprog_tail:
> ffffffffa0c9e414:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> ffffffffa0c9e419:       31 c0                   xor    %eax,%eax
> ffffffffa0c9e41b:       55                      push   %rbp
> ffffffffa0c9e41c:       48 89 e5                mov    %rsp,%rbp
> ffffffffa0c9e41f:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
> ffffffffa0c9e426:       50                      push   %rax
> ffffffffa0c9e427:       48 be 00 6c b1 c1 81    movabs $0xffff8881c1b16c00,%rsi
> ffffffffa0c9e42e:       88 ff ff 
> ffffffffa0c9e431:       31 d2                   xor    %edx,%edx
> ffffffffa0c9e433:       8b 85 fc ff ff ff       mov    -0x4(%rbp),%eax
> ffffffffa0c9e439:       83 f8 20                cmp    $0x20,%eax
> ffffffffa0c9e43c:       77 1b                   ja     0xffffffffa0c9e459
> ffffffffa0c9e43e:       83 c0 01                add    $0x1,%eax
> ffffffffa0c9e441:       89 85 fc ff ff ff       mov    %eax,-0x4(%rbp)
> ffffffffa0c9e447:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> ffffffffa0c9e44c:       58                      pop    %rax
> ffffffffa0c9e44d:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> ffffffffa0c9e454:       e9 fe de ff ff          jmpq   0xffffffffa0c9c357
> ffffffffa0c9e459:       59                      pop    %rcx
> ffffffffa0c9e45a:       c9                      leaveq 
> ffffffffa0c9e45b:       c3                      retq 
> 
> So this flow was doing:
> entry -> set tailcall counter to 0, bump it by 1, tailcall to func0
> func0 -> call subprog_tail
> (we are NOT skipping the first 11 bytes of prologue and this subprogram
> has a tailcall, therefore we clear the counter...)
> subprog -> do the same thing as entry
> 
> and then loop forever. This shows that in our current design there's a
> missing gap of preserving the tailcall counter when bpf2bpf gets mixed
> with tailcalls.
> 
> To address this, the idea is to go through the call chain of bpf2bpf progs
> and look for a tailcall presence throughout whole chain. If we saw a
> single tail call then each node in this call chain needs to be marked as
> as a subprog that can reach the tailcall. We would later feed the JIT with
> this info and:
> - set eax to 0 only when tailcall is reachable and this is the
>   entry prog
> - if tailcall is reachable but there's no tailcall in insns of currently
>   JITed prog then push rax anyway, so that it will be possible to
>   propagate further down the call chain
> - finally if tailcall is reachable, then we need to precede the 'call'
>   insn with mov rax, [rsp]

may be 'mov rax, [rbp - 4]' for consistency with other places
with it's read/written ?

> This way jumping to subprog results in tailcall counter sitting in rax and
> we will not clear it since it is a subprog.
> 
> I think we can easily mark such progs after we reach the end of insn of
> current subprog in check_max_stack_depth().
> 
> I'd like to share a dirty diff that I currently have so that it's easier
> to review this approach rather than finding the diff between revisions.
> It also includes the concern Alexei had on 5/7 (hopefully, if i understood
> it right):
> 
> ------------------------------------------------------
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 58b848029e2f..ed03de3ba27b 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -262,7 +262,7 @@ static void pop_callee_regs(u8 **pprog, bool *callee_regs_used)
>   * while jumping to another program
>   */
>  static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
> -			  bool tail_call)
> +			  bool tail_call, bool is_subprog, bool tcr)
>  {
>  	u8 *prog = *pprog;
>  	int cnt = X86_PATCH_SIZE;
> @@ -273,7 +273,7 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
>  	memcpy(prog, ideal_nops[NOP_ATOMIC5], cnt);
>  	prog += cnt;
>  	if (!ebpf_from_cbpf) {
> -		if (tail_call)
> +		if ((tcr || tail_call) && !is_subprog)

please spell it out as 'tail_call_reachable'.
Also probably 'tail_call' argument is no longer needed.

>  			EMIT2(0x31, 0xC0); /* xor eax, eax */
>  		else
>  			EMIT2(0x66, 0x90); /* nop2 */
> @@ -282,7 +282,7 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
>  	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
>  	/* sub rsp, rounded_stack_depth */
>  	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
> -	if (!ebpf_from_cbpf && tail_call)
> +	if ((!ebpf_from_cbpf && tail_call) || tcr)

May be do 'if (tail_call_reachable)' ?
cbpf doesn't have tail_calls, so ebpf_from_cbpf is unnecessary.

>  		EMIT1(0x50);         /* push rax */
>  	*pprog = prog;
>  }
> @@ -793,7 +793,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
>  			 &tail_call_seen);
>  
>  	emit_prologue(&prog, bpf_prog->aux->stack_depth,
> -		      bpf_prog_was_classic(bpf_prog), tail_call_seen);
> +		      bpf_prog_was_classic(bpf_prog), tail_call_seen,
> +		      bpf_prog->aux->is_subprog,
> +		      bpf_prog->aux->tail_call_reachable);
>  	push_callee_regs(&prog, callee_regs_used);
>  	addrs[0] = prog - temp;
>  
> @@ -1232,8 +1234,14 @@ xadd:			if (is_imm8(insn->off))
>  			/* call */
>  		case BPF_JMP | BPF_CALL:
>  			func = (u8 *) __bpf_call_base + imm32;
> -			if (!imm32 || emit_call(&prog, func, image + addrs[i - 1]))
> -				return -EINVAL;
> +			if (bpf_prog->aux->tail_call_reachable) {
> +				EMIT4(0x48, 0x8B, 0x04, 0x24); // mov rax, [rsp]

[rbp-4] ?

> +				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1] + 4))
> +					return -EINVAL;
> +			} else {
> +				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1]))
> +					return -EINVAL;
> +			}
>  			break;
>  
>  		case BPF_JMP | BPF_TAIL_CALL:
> @@ -1429,7 +1437,9 @@ xadd:			if (is_imm8(insn->off))
>  			/* Update cleanup_addr */
>  			ctx->cleanup_addr = proglen;
>  			pop_callee_regs(&prog, callee_regs_used);
> -			if (!bpf_prog_was_classic(bpf_prog) && tail_call_seen)
> +			if ((!bpf_prog_was_classic(bpf_prog) && tail_call_seen) ||
> +			    bpf_prog->aux->tail_call_reachable)

bpf_prog_was_classic() check is redundant?
Just 'if (bpf_prog->aux->tail_call_reachable)' should be enough?

> +
>  				EMIT1(0x59); /* pop rcx, get rid of tail_call_cnt */
>  			EMIT1(0xC9);         /* leave */
>  			EMIT1(0xC3);         /* ret */
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 7910b87e4ea2..d41e08fbb85f 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -740,6 +740,8 @@ struct bpf_prog_aux {
>  	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
>  	bool func_proto_unreliable;
>  	bool sleepable;
> +	bool is_subprog;

why?
aux->func_idx != 0 would do the same.

> +	bool tail_call_reachable;
>  	enum bpf_tramp_prog_type trampoline_prog_type;
>  	struct bpf_trampoline *trampoline;
>  	struct hlist_node tramp_hlist;
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 5026b75db972..fbc964526ba3 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -359,6 +359,7 @@ struct bpf_subprog_info {
>  	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
>  	u16 stack_depth; /* max. stack depth used by this function */
>  	bool has_tail_call;
> +	bool tail_call_reachable;
>  };
>  
>  /* single container for all structs
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index deb6bf3d9f5d..3a7ebcdf076e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1490,12 +1490,13 @@ static int check_subprogs(struct bpf_verifier_env *env)
>  	for (i = 0; i < insn_cnt; i++) {
>  		u8 code = insn[i].code;
>  
> -		if (insn[i].imm == BPF_FUNC_tail_call)
> -			subprog[cur_subprog].has_tail_call = true;
>  		if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
>  			goto next;
>  		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
>  			goto next;
> +		if ((code == (BPF_JMP | BPF_CALL)) &&
> +			insn[i].imm == BPF_FUNC_tail_call)

&& insn->src_reg != BPF_PSEUDO_CALL is still missing.

> +			subprog[cur_subprog].has_tail_call = true;

>  		off = i + insn[i].off + 1;
>  		if (off < subprog_start || off >= subprog_end) {
>  			verbose(env, "jump out of range from insn %d to %d\n", i, off);
> @@ -2983,6 +2984,8 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
>  	struct bpf_insn *insn = env->prog->insnsi;
>  	int ret_insn[MAX_CALL_FRAMES];
>  	int ret_prog[MAX_CALL_FRAMES];
> +	bool tcr;

how does it work?
Shouldn't it be inited to = false; ?

> +	int j;
>  
>  process_func:
>  #if defined(CONFIG_X86_64) && defined(CONFIG_BPF_JIT_ALWAYS_ON)
> @@ -3039,6 +3042,10 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
>  				  i);
>  			return -EFAULT;
>  		}
> +
> +		if (!tcr && subprog[idx].has_tail_call)
> +			tcr = true;
> +
>  		frame++;
>  		if (frame >= MAX_CALL_FRAMES) {
>  			verbose(env, "the call stack of %d frames is too deep !\n",
> @@ -3047,11 +3054,24 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
>  		}
>  		goto process_func;
>  	}
> +	/* this means we are at the end of the call chain; if throughout this

In my mind 'end of the call chain' means 'leaf function',
so the comment reads a bit misleading to me.
Here we're at the end of subprog.
It's not necessarily the leaf function.

> +	 * whole call chain tailcall has been detected, then each of the
> +	 * subprogs (or their frames) that are currently present on stack need
> +	 * to be marked as tail call reachable subprogs;
> +	 * this info will be utilized by JIT so that we will be preserving the
> +	 * tail call counter throughout bpf2bpf calls combined with tailcalls
> +	 */
> +	if (!tcr)
> +		goto skip;
> +	for (j = 0; j < frame; j++)
> +		subprog[ret_prog[j]].tail_call_reachable = true;
> +skip:

please avoid goto. Just extra indent isn't that bad:
	if (tail_call_reachable)
        	for (j = 0; j < frame; j++)
	        	subprog[ret_prog[j]].tail_call_reachable = true;

>  	/* end of for() loop means the last insn of the 'subprog'
>  	 * was reached. Doesn't matter whether it was JA or EXIT
>  	 */
>  	if (frame == 0)
>  		return 0;
> +

no need.

>  	depth -= round_up(max_t(u32, subprog[idx].stack_depth, 1), 32);
>  	frame--;
>  	i = ret_insn[frame];
> 
> ------------------------------------------------------
> 
> Having this in place preserves the tailcall counter when we mix bpf2bpf
> and tailcalls. I will attach the selftest that has a following call chain:
> 
> entry -> entry_subprog -> tailcall0 -> bpf_func0 -> subprog0 ->
> -> tailcall1 -> bpf_func1 -> subprog1 -> tailcall2 -> bpf_func2 ->
> subprog2 [here bump global counter] --------^
> 
> We go through first two tailcalls and start counting from the subprog2
> where the loop begins. At the end of the test i see that global counter
> gets the value of 31 which is correct.

sounds great.

> For the test that uses lot of stack across subprogs - i suppose we should
> use up to 256 in total, right? otherwise we wouldn't even load the prog so
> test won't even run.

yep. makes sense to me.

> Kudos to Bjorn for brainstorming on this!

Indeed. It's pretty cool problem and I think you've came up with
a good solution.

Since this tail_call_cnt will now be passed from subprog to subrpog via
"interesting" rax calling convention we can eventually retrofit it to count
used-stack-so-far. That would be for the case we discussed earlier (counting
stack vs counting calls). For now the approach you're proposing is good.
