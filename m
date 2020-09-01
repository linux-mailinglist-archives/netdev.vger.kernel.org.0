Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38725983A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgIAQYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730928AbgIAQYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 12:24:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6E6C061244;
        Tue,  1 Sep 2020 09:24:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 31so929820pgy.13;
        Tue, 01 Sep 2020 09:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4xqZw2LOzasTWrxAyg1Lx+JL33KFksLy1Osjvbr/jw=;
        b=LJ/XuQ+cK5bEzMV4gCUE9SCWl9rVOqmhdRs5CgF1JbBoKmvR0Vs0GkXy+ia6dkCjlE
         PjvdrxDdvgtydENg4N34zUSfGV+lfNSlEDpKGHqiyLSm4Pt5Qp6g6uuWf5x75TxiLevR
         QE9l2kxFelYEJcWLLbXOpXrs+WzU0SFSSp56tuewDcU7nAH0Y4mNpryJYdl5zsev86y8
         dMUbDpTaaR7sSG5LWf2IUwJiVadb5SHvz/8CpTqoJXsFVGzLMqeE6AAtTK9CF2QubgK+
         Mvg5Y7Bn9llVSA4AJ0gfcHvMJ16F6JQ/EQ1n3ieS8BkeRvZtk+JLV56WLpd04UmveMzr
         9RsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L4xqZw2LOzasTWrxAyg1Lx+JL33KFksLy1Osjvbr/jw=;
        b=bowmX7MSRZckitUMR4LBq6OjULDke9LfvZkzKo/Loi/elZ1HTOJDcVm1lhkSdwkyRL
         SF+7Wlq33HNueO23h0ktw+aaU0QRCcTzWCgQFRtkuxUamu++TD5lw9lUuUDsmPVXn9Ew
         LQ+v3BXYfWpy5J60UQ+XSscTX97rLhf0YKyZZmrK445GiYM0oZJ3BpzOjzAWb85R1a4z
         ysHzStBu5lHI8ad0yPXbYk9n/VmDwvu5cW6GkgpYYPCE09p7fjaiKg4BY/hBgTWI3KGp
         BCCQxHPTKScoUF7qb63qfjKykyxqnHZkTp/P4qdhTEFe4HmQVEEOF/q40wZMpHiZIbx4
         Bo6Q==
X-Gm-Message-State: AOAM531HFKP6koOjPny8CZa1JUa4bEcDxcObuKGOWv1hUgQvK/hmuewe
        JjvH4Km/T2Zgc3DCKyymafw=
X-Google-Smtp-Source: ABdhPJxSh3LEJ6DRxG59gPysWvrJDVjyOLVCNVXVTKD1+CTNMX3udf5Tb4BbNau4Tv59x+6qKNE97Q==
X-Received: by 2002:a63:31d2:: with SMTP id x201mr2211909pgx.263.1598977455672;
        Tue, 01 Sep 2020 09:24:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:19aa])
        by smtp.gmail.com with ESMTPSA id x144sm2401105pfc.82.2020.09.01.09.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 09:24:14 -0700 (PDT)
Date:   Tue, 1 Sep 2020 09:24:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200901162412.w7ty2xrtknm2nl64@ast-mbp.dhcp.thefacebook.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
 <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
 <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
 <20200821173815.GA3811@ranger.igk.intel.com>
 <20200826213525.6rtjgehjptzqutag@ast-mbp.dhcp.thefacebook.com>
 <20200829231925.GB31692@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829231925.GB31692@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 01:19:25AM +0200, Maciej Fijalkowski wrote:
> On Wed, Aug 26, 2020 at 02:35:25PM -0700, Alexei Starovoitov wrote:
> > On Fri, Aug 21, 2020 at 07:38:15PM +0200, Maciej Fijalkowski wrote:
> > > On Mon, Aug 03, 2020 at 04:00:10PM +0200, Daniel Borkmann wrote:
> > > > On 8/2/20 5:07 AM, Alexei Starovoitov wrote:
> > > > > On Sat, Aug 01, 2020 at 09:13:57AM +0200, Maciej Fijalkowski wrote:
> > > > > > On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
> > > > > > > On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> > > > > > > > v5->v6:
> > > > > > > > - propagate only those poke descriptors that individual subprogram is
> > > > > > > >     actually using (Daniel)
> > > > > > > > - drop the cumbersome check if poke desc got filled in map_poke_run()
> > > > > > > > - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
> > > > > > > >     to patch 3 to provide bisectability (Daniel)
> > > > > > > 
> > > > > > > I did a basic test with Cilium on K8s with this set, spawning a few Pods
> > > > > > > and checking connectivity & whether we're not crashing since it has bit more
> > > > > > > elaborate tail call use. So far so good. I was inclined to push the series
> > > > > > > out, but there is one more issue I noticed and didn't notice earlier when
> > > > > > > reviewing, and that is overall stack size:
> > > > > > > 
> > > > > > > What happens when you create a single program that has nested BPF to BPF
> > > > > > > calls e.g. either up to the maximum nesting or one call that is using up
> > > > > > > the max stack size which is then doing another BPF to BPF call that contains
> > > > > > > the tail call. In the tail call map, you have the same program in there.
> > > > > > > This means we create a worst case stack from BPF size of max_stack_size *
> > > > > > > max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
> > > > > > > we have a stack of arch/x86/include/asm/page_64_types.h:
> > > > > > > 
> > > > > > >    #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
> > > > > > >   #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> > > > > > > 
> > > > > > > So we end up with 16k in a typical case. And this will cause kernel stack
> > > > > > > overflow; I'm at least not seeing where we handle this situation in the
> > > > > 
> > > > > Not quite. The subprog is always 32 byte stack (from safety pov).
> > > > > The real stack (when JITed) can be lower or zero.
> > > > > So the max stack is (512 - 32) * 32 = 15360.
> > > > > So there is no overflow, but may be a bit too close to comfort.
> > > > 
> > > > I did a check with adding `stack_not_used(current)` to various points which
> > > > provides some useful data under CONFIG_DEBUG_STACK_USAGE. From tc ingress side
> > > > I'm getting roughly 13k free stack space which is definitely less than 15k even
> > > > at tc layer. I also checked on sk_filter_trim_cap() on ingress and worst case I
> > > > saw is very close to 12k, so a malicious or by accident a buggy program would be
> > > > able to cause a stack overflow as-is.
> > > > 
> > > > > Imo the room is ok to land the set and the better enforcement can
> > > > > be done as a follow up later, like below idea...
> > > > > 
> > > > > > > set. Hm, need to think more, but maybe this needs tracking of max stack
> > > > > > > across tail calls to force an upper limit..
> > > > > > 
> > > > > > My knee jerk reaction would be to decrement the allowed max tail calls,
> > > > > > but not sure if it's an option and if it would help.
> > > > > 
> > > > > How about make the verifier use a lower bound for a function with a tail call ?
> > > > > Something like 64 would work.
> > > > > subprog_info[idx].stack_depth with tail_call will be >= 64.
> > > > > Then the main function will be automatically limited to 512-64 and the worst
> > > > > case stack = 14kbyte.
> > > > 
> > > > Even 14k is way too close, see above. Some archs that are supported by the kernel
> > > > run under 8k total stack size. In the long run if more archs would support tail
> > > > calls with bpf-to-bpf calls, we might need a per-arch upper cap, but I think in
> > > > this context here an upper total cap on x86 that is 4k should be reasonable, it
> > > > sounds broken to me if more is indeed needed for the vast majority of use cases.
> > > > 
> > > > > When the sub prog with tail call is not an empty body (malicious stack
> > > > > abuser) then the lower bound won't affect anything.
> > > > > A bit annoying that stack_depth will be used by JIT to actually allocate
> > > > > that much. Some of it will not be used potentially, but I think it's fine.
> > > > > It's much simpler solution than to keep two variables to track stack size.
> > > > > Or may be check_max_stack_depth() can be a bit smarter and it can detect
> > > > > that subprog is using tail_call without actually hacking stack_depth variable.
> > > > 
> > > > +1, I think that would be better, maybe we could have a different cost function
> > > > for the tail call counter itself depending in which call-depth we are, but that
> > > > also requires two vars for tracking (tail call counter, call depth counter), so
> > > > more JIT changes & emitted insns required. :/ Otoh, what if tail call counter
> > > > is limited to 4k and we subtract stack usage instead with a min cost (e.g. 128)
> > > > if progs use less than that? Though the user experience will be really bad in
> > > > this case given these semantics feel less deterministic / hard to debug from
> > > > user PoV.
> > > 
> > > Let's get this rolling again.
> > > I like this approach, but from the opposite way - instead of decrementing
> > > from 4k, let's start with 0 like we did before and add up the
> > > max(stack_size, 128) on each tailcall as you suggested.
> > > 
> > > Reason for that is no need for changes in prologue, we can keep the xor
> > > eax,eax insn which occupies 2 bytes whereas mov eax, 4096 needs 5 bytes
> > > from what I see.
> > > 
> > > cmp eax, 4096 also needs more bytes than what cmp eax, MAX_TAIL_CALL_CNT
> > > needed, but that's something we need as well as change mentioned below.
> > > 
> > > One last change is add eax, 1 becomes the add eax, max(stack_size, 128)
> > > and it is also encoded differently.
> > > 
> > > Let me know if you're fine with that and if i can post v7.
> > > Dirty patch below that I will squash onto patch 5 if it's fine.
> > > 
> > > From 01d2494eed07284ea56134f40c6a304b109090ab Mon Sep 17 00:00:00 2001
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Date: Fri, 21 Aug 2020 14:04:27 +0200
> > > Subject: [PATCH] bpf: track stack size in tailcall
> > > 
> > > WIP
> > > 
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++-----------------
> > >  include/linux/bpf.h         |  1 +
> > >  2 files changed, 21 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > index 880f283adb66..56b38536b1dd 100644
> > > --- a/arch/x86/net/bpf_jit_comp.c
> > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > @@ -393,7 +393,7 @@ static int get_pop_bytes(bool *callee_regs_used)
> > >   * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
> > >   *   if (index >= array->map.max_entries)
> > >   *     goto out;
> > > - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> > > + *   if (tail_call_stack_depth + stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
> > >   *     goto out;
> > 
> > I don't think we cannot use this approach because it's not correct. Adding the
> > stack_depth of the current function doesn't count stack space accurately.
> > The bpf_tail_call will unwind the current stack. It's the caller's stack
> > (in case of bpf2bpf) that matters from stack overflow pov.
> 
> I must admit I was puzzled when I came back to this stuff after a break,
> because as you're saying before the actual tailcall we will unwind the
> stack frame of tailcall's caller (or the current stack frame in simpler
> terms).
> 
> So, to visualize a bit and so that I'm sure I follow:
> 
> func1 -> sub rsp, 128
>   subfunc1 -> sub rsp, 256
>   tailcall1 -> add rsp, 256
>     func2 -> sub rsp, 256 (total stack size = 128 + 256 = 384)
>     subfunc2 -> sub rsp, 64
>     subfunc22 -> sub rsp, 128
>     tailcall2 -> add rsp, 128
>       func3 -> sub rsp, 256 (total stack size 128 + 256 + 64 + 256 = 704)
> 
> and so on. And this is what we have to address. If that's it, then thanks
> for making it explicit that it's about the subprog caller's stack.

Right. The above is correct. Could you add it to the code as a comment?
Please replace second and third use of 256 with a different constant to
make it easier to see that 'sub rsp, X' in func1, func2, and func3 can
be different.

> > But this callee (that does tail_call eventually) can be called from multiple
> > callsites in the caller and potentially from different callers, so
> > the callee cannot know the stack value to subtract without additional verifier help.
> > We can try to keep the maximum depth of stack (including all call frames) in
> > the verfier that leads to that callee with bpf_tail_call() and then pass it
> > into JITs to do this stack accounting. It's reasonable additional complexity in
> > the verifier, but it's painful to add the interpreter support.
> 
> Not sure if we're on the same page - we allow this set only for x64 arch.
> Why do you mention the interpreter and other JITs?

It's not 100% mandatory to make the interpreter compatible with JIT,
but we should always try to keep the parity when possible.
Like when I was working on BPF trampoline I've considered to support JITed code
only, since generation of trampoline itself requires Just-In-Time code
generation. But I took the extra effort to make sure invoke_bpf_prog() in
arch/x86/net/bpf_jit_comp.c supports interpreter as well. There could be bugs
in the interpreter or JIT. Having two ways to execute the program is useful for
many reasons.

In this case the new tail_call handling in x86 JIT will unwind the current stack,
so existing interpreter handling of tail_call won't quite work.
Take a look at bpf_patch_call_args(), JMP_CALL_ARGS:, and JMP_TAIL_CALL:.
The JMP_TAIL_CALL will sort-of unwind the current stack, but the size of the stack
will be reused for tail_call target function.
Illustrating on your example:
 func1 -> sub rsp, 128
   subfunc1 -> sub rsp, 256
   tailcall1 -> add rsp, 256
     func2 -> sub rsp, 192 (total stack size = 128 + 192 = 320)
     subfunc2 -> sub rsp, 64
     subfunc22 -> sub rsp, 128
     tailcall2 -> add rsp, 128
       func3 -> sub rsp, 224 (total stack size 128 + 192 + 64 + 224 = 608)

The interpreter will call into subfunc1 with 256 bytes of the interpreter stack
and will reuse it for tail_call into func2.
If func2 needs 192, it's going to work fine, but if it needs more than 256
there will be stack overflow.

We can disable mixing bpf2bpf calls and tail_calls when interpreter is used
for now, but it would be good to support it somehow.

> We could introduce one of your suggestions to verifier and surround it with
> proper ifdefs like patch 5/6 is doing it.

If we use the approach of changing JMP_TAIL_CALL pseudo insn to do:
-               tail_call_cnt++;
+               tail_call_stack += insn->off;
then we have to update other JITs to do the same.
Other JITs do NOT need to support bpf2bpf calls with tail_calls.
they do NOT need to do current stack unwinding, but they have to match
the new behavior of JMP_TAIL_CALL otherwise such interpreter vs JIT
discrepancy will create plenty of unhappy users.

> > We would need to hack BPF_TAIL_CALL insn. Like we can store
> > max_stack_of_all_callsites into insn->off when we do fixup_bpf_calls().
> > Then interpreter will do:
> > iff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index ed0b3578867c..9a8b54c1adb6 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1532,10 +1532,10 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6
> > 
> >                 if (unlikely(index >= array->map.max_entries))
> >                         goto out;
> > -               if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> > +               if (unlikely(tail_call_stack > MAX_TAIL_CALL_STACK /* 4096 */))
> >                         goto out;
> > 
> > -               tail_call_cnt++;
> > +               tail_call_stack += insn->off;
> > 
> > and similar thing JITs would have to do. That includes modifying all existing JITs.
> 
> Again, I don't get why we would have to address everything else besides
> x64 JIT.
> 
> > 
> > When bpf_tail_call() is called from top frame (instead of bpf-to-bpf subprog)
> > we can init 'off' with 128, so the old 32 call limit will be preserved.
> > But if we go with such massive user visible change I'd rather init 'off' with 32.
> > Then the tail call cnt limit will be 4096/32 = 128 invocations.
> > At least it will address a complain from folks that were hitting 32 limit.
> > 
> > Another approach is to use what I've suggested earlier.
> > Adjust the math in check_max_stack_depth():
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 8a097a85d01b..9c6c909a1ab9 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -2982,6 +2982,11 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
> >         int ret_prog[MAX_CALL_FRAMES];
> > 
> >  process_func:
> > +       if (idx && subprog[idx].has_tail_call && depth >= 256) {
> > +               verbose(env, "Cannot do bpf_tail_call when call stack of previous frames is %d bytes. Too large\n",
> > +                       depth);
> > +               return -EACCES;
> > +       }
> > Then the worst case stack will be 256 * 32 = 8k while tail_call_cnt of 32 will stay as-is.
> > And no need to change interpreter or JITs.
> 
> I tend to lean towards simpler solutions as this work is already complex.
> Let's hear Daniel's opinion though.

Let's go with this simpler solution. We can add fancier stack
accounting later.
