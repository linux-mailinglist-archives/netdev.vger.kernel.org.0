Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FF42539DA
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHZVfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 17:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZVf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 17:35:29 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CC0C061574;
        Wed, 26 Aug 2020 14:35:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nv17so1512566pjb.3;
        Wed, 26 Aug 2020 14:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UDQ3bcCs85zgiVhK4mPOVMVcHrhtg1POCLzZHCDPyJE=;
        b=kjShn8LqOZUPa4pCPXnHGcb8w2dQACSI+rtf/FfeHIQw/JlN4oyPUNjbvnvsIlDrjR
         wJZVOLxXHqwOZOLTKMFGXCeMwQSvzwXMu2fQ25CYUJ8jETCOrtjT9pxgGSqWfQr/q9JU
         BoYLyXeq+dJ8RuucHw0+FIRleooX8Tl4UOyYfxnTidc24ZSkz7WMSx8Cu86BtLdGVJ3h
         hMaSQM6SlzOZqGqpFunGjZoRM4eWH8KRPwY3vc/EHG8EdIpwVWaiSB0erxyX7s4L3Emo
         YfIy/1X9OEHdWAoD6eLtXpHZjLuUTEGc4aXWieS6M3ktdQ42TXWt4VQnqrxwlDGAkG3K
         ZyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UDQ3bcCs85zgiVhK4mPOVMVcHrhtg1POCLzZHCDPyJE=;
        b=f7Lhp1csV3NJO1oz/IdfK9piAEKTiUHtKQ6UuJUrHXjWKkDQvUv0YFR7J+OqFMyLAG
         elFdD4S8OGmjkyK666xniOocUyc39D5cZQNKcsKKW8wKarGltRJ/hYGc/DkV9gzdyZM5
         uFfySz7cp441t0OkdB/NrTKLZz/71KKlWBVxDKAZjob4ob/0178YVU5p9mu7WLVQ9NEU
         P4g2hpdMTE3Jcn9gZ1vs/8e1x/vhi2sDyH/F1sr0V9SPSq9/q5/CA00nWlAi+Elo9Mbm
         IrhgsUUQFX24SapV0+kcXab79S47/qSB3bWJRNEk7yDOccvv2LaxeavBDLgX+DSEgt1d
         73NA==
X-Gm-Message-State: AOAM533/IyGgULBYwCrYNboZcNN6HzHMHlGhO6abg9LQe8uF80LOuG3U
        kygYQOtB/JHhKVukyfRjhsY=
X-Google-Smtp-Source: ABdhPJykaEGzWPcVHw3zjG9UCcWYS4scb4sZ8wLf1DhcKy6YryHkDafBexwYd2npB8D5Iki9b0knZA==
X-Received: by 2002:a17:90a:4f0e:: with SMTP id p14mr8060222pjh.31.1598477728544;
        Wed, 26 Aug 2020 14:35:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e18])
        by smtp.gmail.com with ESMTPSA id n12sm132163pfj.99.2020.08.26.14.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 14:35:27 -0700 (PDT)
Date:   Wed, 26 Aug 2020 14:35:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200826213525.6rtjgehjptzqutag@ast-mbp.dhcp.thefacebook.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
 <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
 <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
 <20200821173815.GA3811@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821173815.GA3811@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 07:38:15PM +0200, Maciej Fijalkowski wrote:
> On Mon, Aug 03, 2020 at 04:00:10PM +0200, Daniel Borkmann wrote:
> > On 8/2/20 5:07 AM, Alexei Starovoitov wrote:
> > > On Sat, Aug 01, 2020 at 09:13:57AM +0200, Maciej Fijalkowski wrote:
> > > > On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
> > > > > On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> > > > > > v5->v6:
> > > > > > - propagate only those poke descriptors that individual subprogram is
> > > > > >     actually using (Daniel)
> > > > > > - drop the cumbersome check if poke desc got filled in map_poke_run()
> > > > > > - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
> > > > > >     to patch 3 to provide bisectability (Daniel)
> > > > > 
> > > > > I did a basic test with Cilium on K8s with this set, spawning a few Pods
> > > > > and checking connectivity & whether we're not crashing since it has bit more
> > > > > elaborate tail call use. So far so good. I was inclined to push the series
> > > > > out, but there is one more issue I noticed and didn't notice earlier when
> > > > > reviewing, and that is overall stack size:
> > > > > 
> > > > > What happens when you create a single program that has nested BPF to BPF
> > > > > calls e.g. either up to the maximum nesting or one call that is using up
> > > > > the max stack size which is then doing another BPF to BPF call that contains
> > > > > the tail call. In the tail call map, you have the same program in there.
> > > > > This means we create a worst case stack from BPF size of max_stack_size *
> > > > > max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
> > > > > we have a stack of arch/x86/include/asm/page_64_types.h:
> > > > > 
> > > > >    #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
> > > > >   #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> > > > > 
> > > > > So we end up with 16k in a typical case. And this will cause kernel stack
> > > > > overflow; I'm at least not seeing where we handle this situation in the
> > > 
> > > Not quite. The subprog is always 32 byte stack (from safety pov).
> > > The real stack (when JITed) can be lower or zero.
> > > So the max stack is (512 - 32) * 32 = 15360.
> > > So there is no overflow, but may be a bit too close to comfort.
> > 
> > I did a check with adding `stack_not_used(current)` to various points which
> > provides some useful data under CONFIG_DEBUG_STACK_USAGE. From tc ingress side
> > I'm getting roughly 13k free stack space which is definitely less than 15k even
> > at tc layer. I also checked on sk_filter_trim_cap() on ingress and worst case I
> > saw is very close to 12k, so a malicious or by accident a buggy program would be
> > able to cause a stack overflow as-is.
> > 
> > > Imo the room is ok to land the set and the better enforcement can
> > > be done as a follow up later, like below idea...
> > > 
> > > > > set. Hm, need to think more, but maybe this needs tracking of max stack
> > > > > across tail calls to force an upper limit..
> > > > 
> > > > My knee jerk reaction would be to decrement the allowed max tail calls,
> > > > but not sure if it's an option and if it would help.
> > > 
> > > How about make the verifier use a lower bound for a function with a tail call ?
> > > Something like 64 would work.
> > > subprog_info[idx].stack_depth with tail_call will be >= 64.
> > > Then the main function will be automatically limited to 512-64 and the worst
> > > case stack = 14kbyte.
> > 
> > Even 14k is way too close, see above. Some archs that are supported by the kernel
> > run under 8k total stack size. In the long run if more archs would support tail
> > calls with bpf-to-bpf calls, we might need a per-arch upper cap, but I think in
> > this context here an upper total cap on x86 that is 4k should be reasonable, it
> > sounds broken to me if more is indeed needed for the vast majority of use cases.
> > 
> > > When the sub prog with tail call is not an empty body (malicious stack
> > > abuser) then the lower bound won't affect anything.
> > > A bit annoying that stack_depth will be used by JIT to actually allocate
> > > that much. Some of it will not be used potentially, but I think it's fine.
> > > It's much simpler solution than to keep two variables to track stack size.
> > > Or may be check_max_stack_depth() can be a bit smarter and it can detect
> > > that subprog is using tail_call without actually hacking stack_depth variable.
> > 
> > +1, I think that would be better, maybe we could have a different cost function
> > for the tail call counter itself depending in which call-depth we are, but that
> > also requires two vars for tracking (tail call counter, call depth counter), so
> > more JIT changes & emitted insns required. :/ Otoh, what if tail call counter
> > is limited to 4k and we subtract stack usage instead with a min cost (e.g. 128)
> > if progs use less than that? Though the user experience will be really bad in
> > this case given these semantics feel less deterministic / hard to debug from
> > user PoV.
> 
> Let's get this rolling again.
> I like this approach, but from the opposite way - instead of decrementing
> from 4k, let's start with 0 like we did before and add up the
> max(stack_size, 128) on each tailcall as you suggested.
> 
> Reason for that is no need for changes in prologue, we can keep the xor
> eax,eax insn which occupies 2 bytes whereas mov eax, 4096 needs 5 bytes
> from what I see.
> 
> cmp eax, 4096 also needs more bytes than what cmp eax, MAX_TAIL_CALL_CNT
> needed, but that's something we need as well as change mentioned below.
> 
> One last change is add eax, 1 becomes the add eax, max(stack_size, 128)
> and it is also encoded differently.
> 
> Let me know if you're fine with that and if i can post v7.
> Dirty patch below that I will squash onto patch 5 if it's fine.
> 
> From 01d2494eed07284ea56134f40c6a304b109090ab Mon Sep 17 00:00:00 2001
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Fri, 21 Aug 2020 14:04:27 +0200
> Subject: [PATCH] bpf: track stack size in tailcall
> 
> WIP
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++-----------------
>  include/linux/bpf.h         |  1 +
>  2 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 880f283adb66..56b38536b1dd 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -393,7 +393,7 @@ static int get_pop_bytes(bool *callee_regs_used)
>   * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
>   *   if (index >= array->map.max_entries)
>   *     goto out;
> - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> + *   if (tail_call_stack_depth + stack_depth > MAX_TAIL_CALL_STACK_DEPTH)
>   *     goto out;

I don't think we cannot use this approach because it's not correct. Adding the
stack_depth of the current function doesn't count stack space accurately.
The bpf_tail_call will unwind the current stack. It's the caller's stack
(in case of bpf2bpf) that matters from stack overflow pov.
But this callee (that does tail_call eventually) can be called from multiple
callsites in the caller and potentially from different callers, so
the callee cannot know the stack value to subtract without additional verifier help.
We can try to keep the maximum depth of stack (including all call frames) in
the verfier that leads to that callee with bpf_tail_call() and then pass it
into JITs to do this stack accounting. It's reasonable additional complexity in
the verifier, but it's painful to add the interpreter support.
We would need to hack BPF_TAIL_CALL insn. Like we can store
max_stack_of_all_callsites into insn->off when we do fixup_bpf_calls().
Then interpreter will do:
iff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..9a8b54c1adb6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1532,10 +1532,10 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u6

                if (unlikely(index >= array->map.max_entries))
                        goto out;
-               if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+               if (unlikely(tail_call_stack > MAX_TAIL_CALL_STACK /* 4096 */))
                        goto out;

-               tail_call_cnt++;
+               tail_call_stack += insn->off;

and similar thing JITs would have to do. That includes modifying all existing JITs.

When bpf_tail_call() is called from top frame (instead of bpf-to-bpf subprog)
we can init 'off' with 128, so the old 32 call limit will be preserved.
But if we go with such massive user visible change I'd rather init 'off' with 32.
Then the tail call cnt limit will be 4096/32 = 128 invocations.
At least it will address a complain from folks that were hitting 32 limit.

Another approach is to use what I've suggested earlier.
Adjust the math in check_max_stack_depth():
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8a097a85d01b..9c6c909a1ab9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2982,6 +2982,11 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
        int ret_prog[MAX_CALL_FRAMES];

 process_func:
+       if (idx && subprog[idx].has_tail_call && depth >= 256) {
+               verbose(env, "Cannot do bpf_tail_call when call stack of previous frames is %d bytes. Too large\n",
+                       depth);
+               return -EACCES;
+       }
Then the worst case stack will be 256 * 32 = 8k while tail_call_cnt of 32 will stay as-is.
And no need to change interpreter or JITs.

I'm still thinking which way is better long term.
Thoughts?
