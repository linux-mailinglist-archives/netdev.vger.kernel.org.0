Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1804C1C1DA7
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgEATJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729766AbgEATJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:09:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5F8C061A0C;
        Fri,  1 May 2020 12:09:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so1950000pfb.10;
        Fri, 01 May 2020 12:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3jiAPaFiQIwup5Rl6bkdApLMWC+g3p/Kt1dCChwBGvU=;
        b=HYqlOnF6xR6P3tL0oO/ZOqArCr8YiLqKR4ycbsI5PMe3b5gDjQkRgVRsbYe3Kv3H3+
         dXtnOI8X8c2MGLulvZM72mVH6ibte2GRWWFNyciyYoXoXh+rXm6wqWvV5rNCJCPUopdm
         ISIf/vnLr2f7BzTpAy+c+79V1cciunTnlLDKhmrvAu/OwhpyrS5UPfBvaO/czF8EPEWq
         DdfSq4C4qjpR9VjB/lk0qizsNTNH9H8Wq9OFsc3UPtg08wDYJHCXqikvNZ5wr05PJApm
         FiT9QFCi8o7XGYx/LTjCTltXKCM/KFbNS2nPDp4Cd1vES1hnsfUtx/mf79t5c7ckVfnT
         ItvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3jiAPaFiQIwup5Rl6bkdApLMWC+g3p/Kt1dCChwBGvU=;
        b=ix4Q/15qdRUxKFiCNYvT2bTADGj5pvYSXddROrbkvS5Q+aWTVFla8w2pRjqshPR9kJ
         FNcK624y/iyu9xkIvcrVneWGLTjqkaJnqFw+ju23P8xcuDRycYpCSP4Js+x8ifAOB5gz
         7FGCKf+1IFyXdExqc43pOIsUyPDXvEvmcp5VuHIKpXUPV+9XDO0kp/o5ahR644NT+ELX
         cKwbw/4zp0mU7OOmDSJC9wvL1SOvCVm89yZ44LgwjVQqYiHkVJ53uEBBzN8/Vm+BETEh
         L1Mp3BYGSVm+GbRECPQKSaynRs+Uku5x9L6JNlXAQzFMpuCCQ1gJbLDlhCI7xMuriCYH
         eGFQ==
X-Gm-Message-State: AGi0PubceWZrYORAp0cXltrI1yrLV7n5PzorYlryL/bhphQyv9qLLC5d
        1qbnRmtYWFZvKjwbGP9v4EM=
X-Google-Smtp-Source: APiQypIBl1/RFUI1dVmI7MYjTIw4oUr1NcTWvPch+Z2udtILKSBl834zc6fvAKWhOD4ilquX0Pj6eg==
X-Received: by 2002:a62:e803:: with SMTP id c3mr5338940pfi.228.1588360173626;
        Fri, 01 May 2020 12:09:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8cd4])
        by smtp.gmail.com with ESMTPSA id r4sm2609313pgi.6.2020.05.01.12.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 12:09:32 -0700 (PDT)
Date:   Fri, 1 May 2020 12:09:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 02:07:43PM -0500, Josh Poimboeuf wrote:
> Objtool decodes instructions and follows all potential code branches
> within a function.  But it's not an emulator, so it doesn't track
> register values.  For that reason, it usually can't follow
> intra-function indirect branches, unless they're using a jump table
> which follows a certain format (e.g., GCC switch statement jump tables).
> 
> In most cases, the generated code for the BPF jump table looks a lot
> like a GCC jump table, so objtool can follow it.  However, with
> RETPOLINE=n, GCC keeps the jump table address in a register, and then
> does 160+ indirect jumps with it.  When objtool encounters the indirect
> jumps, it can't tell which jump table is being used (or even whether
> they might be sibling calls instead).
> 
> This was fixed before by disabling an optimization in ___bpf_prog_run(),
> using the "optimize" function attribute.  However, that attribute is bad
> news.  It doesn't append options to the command-line arguments.  Instead
> it starts from a blank slate.  And according to recent GCC documentation
> it's not recommended for production use.  So revert the previous fix:
> 
>   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> 
> With that reverted, solve the original problem in a different way by
> getting rid of the "goto select_insn" indirection, and instead just goto
> the jump table directly.  This simplifies the code a bit and helps GCC
> generate saner code for the jump table branches, at least in the
> RETPOLINE=n case.
> 
> But, in the RETPOLINE=y case, this simpler code actually causes GCC to
> generate far worse code, ballooning the function text size by +40%.  So
> leave that code the way it was.  In fact Alexei prefers to leave *all*
> the code the way it was, except where needed by objtool.  So even
> non-x86 RETPOLINE=n code will continue to have "goto select_insn".
> 
> This stuff is crazy voodoo, and far from ideal.  But it works for now.
> Eventually, there's a plan to create a compiler plugin for annotating
> jump tables.  That will make this a lot less fragile.

I don't like this commit log.
Here you're saying that the code recognized by objtool is sane and good
whereas well optimized gcc code is somehow voodoo and bad.
That is just wrong.
goto select_insn; vs goto *jumptable[insn->code]; is not a contract that
compiler has to follow. The compiler is free to convert direct goto
into indirect and the other way around.
For all practical purposes this patch is a band aid for objtool that will fall
apart in the future. Just like the previous patch that survived less than a year.
It's not clear whether old one worked for clang.
It's not clear whether new one will work for clang.
retpoline=y causing code bloat is a different issue that can be investigated
separately. gcc/clang have different modes of generating retpoline thunks.
May be one of those flags can help.

In other words I'm ok with the patch, but commit log needs to be reworded.

> Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  include/linux/compiler-gcc.h   |  2 --
>  include/linux/compiler_types.h |  4 ----
>  kernel/bpf/core.c              | 10 +++++++---
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index cf294faec2f8..2c8583eb5de8 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -176,5 +176,3 @@
>  #else
>  #define __diag_GCC_8(s)
>  #endif
> -
> -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index e970f97a7fcb..58105f1deb79 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -203,10 +203,6 @@ struct ftrace_likely_data {
>  #define asm_inline asm
>  #endif
>  
> -#ifndef __no_fgcse
> -# define __no_fgcse
> -#endif
> -
>  /* Are two types/vars the same type (ignoring qualifiers)? */
>  #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
>  
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 916f5132a984..eec470c598ad 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1364,7 +1364,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
>   *
>   * Decode and execute eBPF instructions.
>   */
> -static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> +static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  {
>  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
>  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> @@ -1384,11 +1384,15 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6
>  #undef BPF_INSN_2_LBL
>  	u32 tail_call_cnt = 0;
>  
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_RETPOLINE)
> +#define CONT	 ({ insn++; goto *jumptable[insn->code]; })
> +#define CONT_JMP ({ insn++; goto *jumptable[insn->code]; })
> +#else
>  #define CONT	 ({ insn++; goto select_insn; })
>  #define CONT_JMP ({ insn++; goto select_insn; })
> -
>  select_insn:
>  	goto *jumptable[insn->code];
> +#endif
>  
>  	/* ALU */
>  #define ALU(OPCODE, OP)			\
> @@ -1547,7 +1551,7 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6
>  		 * where arg1_type is ARG_PTR_TO_CTX.
>  		 */
>  		insn = prog->insnsi;
> -		goto select_insn;
> +		CONT;

This is broken. I don't think you've run basic tests with this patch.
