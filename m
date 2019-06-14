Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6E146B6B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfFNU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:58:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46451 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfFNU6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 16:58:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so2102224pfy.13;
        Fri, 14 Jun 2019 13:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xq4ZMKmqaYESp+y/yJJJP8yO0vJ9LIM89P2olkrziRk=;
        b=t+C/+5N1BeFF0+8rA+KyhTRzSjhvhsOZcJrTvQXMr5WlSBGoIt/6KaEULswU39rYbL
         jN6F1y5z7P0gOqPXmMrC0z5Fd+mFOPHkpOABh/6vWy10SoS9cpgo3nvRx6S6l3IYC7FZ
         Fwe+c2wfbO0ppAsuwkfV6/N9L85bqc/PlhBFEirifKfo07LrOjvTI5U06tYykJeZKR2T
         fTAV3dpF3nRcPGi9IK2cr5htjIWYV+nbOTYMzvTkN9I0aKSlr7JWFLiNogysBtpcTVXJ
         hmBLwzHOYPNKDw0zCIkJYwku/Gcdtqf7lYBSmuDcP9XV45MFiMUWLlTXd9+CWrJcUb7Q
         lX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xq4ZMKmqaYESp+y/yJJJP8yO0vJ9LIM89P2olkrziRk=;
        b=aRpMT8P1ptBFKjEGBdtx6kGezUPLuvBqXmpWn3DRqklDzDYTlloimQPc7eMXWNDh1O
         x/WkKbmxMY0ayG+9Yah36pXUGXepkiX0WNS0xDBpPo6k1QfbuJO5+rxvvzMqCFtdcXZZ
         DgiilVLHgIVdQCRI/hrRRtBOV1cY79mp6UquglpcMai0IMUCcP8gSs8QTGv3Ej+6mhmP
         Q90nZgjCQJON3MVeQcrc+sgC/o3s5dEJPnXVCmVoSSdObw/MnQ8U0zLkNqgiZIN2/rkU
         ktktPQO/LZsPRwVuj9BBnO5Z0BOXxLQnqY8DEWut+lK37l35fM9isXKLB18R6yEyYPRt
         LsKw==
X-Gm-Message-State: APjAAAXgxLRUknPmdnKugvKzAfQp23D/IjGB++6dEKhsyqbR3E27+etr
        FRsMqB40JY2HvRqW+PZREJ4=
X-Google-Smtp-Source: APXvYqyfietE6hYnW8A2nm9Oi7jLNJHkHCuwiYicck1X2QlqdRn7NU8fr62322sbEDeDmYSqFm8jqQ==
X-Received: by 2002:a63:6142:: with SMTP id v63mr38145069pgb.309.1560545924079;
        Fri, 14 Jun 2019 13:58:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:6345])
        by smtp.gmail.com with ESMTPSA id l2sm3340105pgs.33.2019.06.14.13.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 13:58:43 -0700 (PDT)
Date:   Fri, 14 Jun 2019 13:58:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Message-ID: <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:56:41PM -0500, Josh Poimboeuf wrote:
> Objtool currently ignores ___bpf_prog_run() because it doesn't
> understand the jump table.  This results in the ORC unwinder not being
> able to unwind through non-JIT BPF code.
> 
> Luckily, the BPF jump table resembles a GCC switch jump table, which
> objtool already knows how to read.
> 
> Add generic support for reading any static local jump table array named
> "jump_table", and rename the BPF variable accordingly, so objtool can
> generate ORC data for ___bpf_prog_run().
> 
> Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> Reported-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/bpf/core.c     |  5 ++---
>  tools/objtool/check.c | 16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 7c473f208a10..aa546ef7dbdc 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  {
>  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
>  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> -	static const void *jumptable[256] = {
> +	static const void *jump_table[256] = {
>  		[0 ... 255] = &&default_label,
>  		/* Now overwrite non-defaults ... */
>  		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
> @@ -1315,7 +1315,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  #define CONT_JMP ({ insn++; goto select_insn; })
>  
>  select_insn:
> -	goto *jumptable[insn->code];
> +	goto *jump_table[insn->code];
>  
>  	/* ALU */
>  #define ALU(OPCODE, OP)			\
> @@ -1558,7 +1558,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  		BUG_ON(1);
>  		return 0;
>  }
> -STACK_FRAME_NON_STANDARD(___bpf_prog_run); /* jump table */
>  
>  #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
>  #define DEFINE_BPF_PROG_RUN(stack_size) \
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 172f99195726..8341c2fff14f 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -18,6 +18,8 @@
>  
>  #define FAKE_JUMP_OFFSET -1
>  
> +#define JUMP_TABLE_SYM_PREFIX "jump_table."

since external tool will be looking at it should it be named 
"bpf_jump_table." to avoid potential name conflicts?
Or even more unique name?
Like "bpf_interpreter_jump_table." ?

