Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9441DC60A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 06:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgEUEF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 00:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgEUEF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 00:05:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3168C061A0E;
        Wed, 20 May 2020 21:05:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e11so1696389pfn.3;
        Wed, 20 May 2020 21:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C0L3nj0EzYCDg/wtKkPDNRen0kT++NzdM7/MeO9IYE8=;
        b=UTPKJPYBbe+59FcdtfWuUbhgjy9eseTfDstaL1FtZq9i7r1MNu9jrKJwSpSj3LrbdO
         OUZcWB1Eazo3eYXa31EGd4lxQjBzZJUaafMFDCiRj3RRjzq8+E7MX9T0RirUhrNctbdc
         wL2jeIdknG0Jzc/qpdSLl0XuAIlxiPriZkeg/2qbftzFmHQuhgtrXahiv+K5g8JdVjrO
         9DJjUgEJYxipKDufZtY1IglqFeKyD81Td3mBKtGacH2oWYfhY8o0lrP06Fw3X5cy64vt
         JRiGzXTnBTiUr9vTuv8aI1rv2VYoSFZnv6IpV/D3sIDF9xMsYHeJFiEc8BXgNgOvMl5x
         GBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C0L3nj0EzYCDg/wtKkPDNRen0kT++NzdM7/MeO9IYE8=;
        b=l+XOdl/MCvzC220Unzy5b2uPgUQgTHKTrr6yF7a6Q1cQN+p23PAe5O9OSP9kNtPS4R
         x79epR3aJ2I07eCvRY3t9piZeiszoB4sdpnSdXOKUrX2j/yACqM4iRgvD1KE5RtHKlT3
         +8JNDCsQMZSm9lXHNhAApmib2vkAOKLjxlzb+26TQ5AmgYZB/pDVteItJqKQwKmsnCGf
         iCwsNjIf3hbfx6aYCrEmJQcySjmjiSnVERXRXgMXFi9W2ZjrzUV+xBc53jB5+eCyP3fO
         YNswVFD+jDSJmXEyjABwKyLsfsWAA9esR/pc8lJsJwOzIis5HjtL5k+0cs8SYpsa1MtY
         2+sQ==
X-Gm-Message-State: AOAM533js0HHfiKLp9xaBV2//xP+pRVCqKoHCIB+hccJGwUCNlWkTTzJ
        F75mXZCXlMSGkH2E4x/6MXw=
X-Google-Smtp-Source: ABdhPJwxeb19LqKLRLuy2iARDwwMd6jH/0Jca83S2ZT13LOtKrn2e0YlsYOxNbPL1xtw/FcIXC01pw==
X-Received: by 2002:aa7:9f4c:: with SMTP id h12mr7799569pfr.68.1590033955101;
        Wed, 20 May 2020 21:05:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id i10sm3289702pfa.166.2020.05.20.21.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 21:05:53 -0700 (PDT)
Date:   Wed, 20 May 2020 21:05:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: Re: getting bpf_tail_call to work with bpf function calls. Was: [RFC
 PATCH bpf-next 0/1] bpf, x64: optimize JIT prologue/epilogue generation
Message-ID: <20200521040551.lnfaan6uszg2qjoh@ast-mbp.dhcp.thefacebook.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
 <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
 <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
 <20200513115855.GA3574@ranger.igk.intel.com>
 <20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com>
 <20200518184458.GC6472@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518184458.GC6472@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 08:44:58PM +0200, Maciej Fijalkowski wrote:
> On Sat, May 16, 2020 at 09:32:27PM -0700, Alexei Starovoitov wrote:
> > On Wed, May 13, 2020 at 01:58:55PM +0200, Maciej Fijalkowski wrote:
> > > 
> > > So to me, if we would like to get rid of maxing out stack space, then we
> > > would have to do some dancing for preserving the tail call counter - keep
> > > it in some unused register? Or epilogue would pop it from stack to some
> > > register and target program's prologue would push it to stack from that
> > > register (I am making this up probably). And rbp/rsp would need to be
> > > created/destroyed during the program-to-program transition that happens
> > > via tailcall. That would mean also more instructions.
> > 
> > How about the following:
> > The prologue will look like:
> > nop5
> > xor eax,eax  // two new bytes if bpf_tail_call() is used in this function
> > push rbp
> > mov rbp, rsp
> > sub rsp, rounded_stack_depth
> > push rax // zero init tail_call counter
> > variable number of push rbx,r13,r14,r15
> > 
> > Then bpf_tail_call will pop variable number rbx,..
> > and final 'pop rax'
> > Then 'add rsp, size_of_current_stack_frame'
> > jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov rbp, rsp'
> > 
> > This way new function will set its own stack size and will init tail call
> > counter with whatever value the parent had.
> > 
> > If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
> > Instead it would need to have 'nop2' in there.
> > That's the only downside I see.
> > Any other ideas?
> 
> Not really - had a thought with Bjorn about using one callee-saved
> register that is yet unused by x64 JIT (%r12) and i was also thinking

people keep trying to use r12 for all sorts of things, but I'd like
to keep it reserved. I hope we can add R11 to bpf ISA one day.

> about some freaky usage of SSE register as a general purpose one. However,
> your idea is pretty neat - I gave it already a shot and with a single
> tweak I managed to got it working, e.g. selftests are fine as well as two
> samples that utilize tail calls. Note also that I got rid of the stack
> clamp being done in fixup_bpf_calls.
> 
> About a tweak:
> - RETPOLINE_RAX_BPF_JIT used for indirect tail calls needed to become a
>   RETPOLINE_RCX_BPF_JIT, so that we preserve the content of %rax across
>   jumping between programs via tail calls. I looked up GCC commit that
>   Daniel quoted on a patch that implements RETPOLINE_RAX_BPF_JIT and it
>   said that for register that is holding the address of function that we
>   will be jumping onto, we are free to use most of GP registers. I picked
>   %rcx.

Good catch. Indeed. We have to use rcx for retpoline.
rdi/rsi/rdx are used to pass args and bpf_tail_call() doesn't have
4th argument.
r8 could have been used, but it will take more bytes to encode.
so imo rcx is the only choice.

> I was also thinking about a minor optimization where we would replace the
> add/sub %rsp, $off32 with a nop7 if stack depth is 0.

why leaf functions are special?
I've been thinking about it as well, but trampoline fentry/fexit can
be attached to bpf progs too and it would unnecessary complicate
calling original.
So I've discared nop7 idea.

Instead I was thinking to add useless two byte prefix to
either 'push rbp' or 'mov rbp, rsp'.
Like 0x66, so from cpu uops point of view it will stay single uop
to execute in the ooo pipeline, whereas nop2 is a separate uop.
But it's not clear whether decoder performance will be better
for separate nop2 or 0x66 will add unnecssary stress on it.
Like pushing it into 'complex' opcode that can be done by only one exclusive
decoder vs 'simple' opcode that multiple decoders process in parallel.
Some microbenchmarking is needed. Though I'm not sure that the time spent
in such micro performance analysis is worth it :)
So imo nop2 is good enough.

> About a way forward - I reached out to Bjorn to co-operate on providing
> the benchmark for measuring the impact of new tail call handling as well
> as providing a proof in a form of selftests that bpf2bpf is working
> together with tail calls.
> 
> About a benchmark, we think that having tests for best and worst cases
> would tell us what is going on. So:
> - have a main program that is not using any of callee registers that will
>   be tailcalling onto another program that is also not using any of R6-R9.

I don't think such micro benchmark will be realistic. You can probably
craft one in assembler, but when there is a function call and 'ctx' is
passed into that function the llvm will use R6 at least.

> - have the same flow but both programs will be using R6, R7, R8, R9; main
>   program needs to use them because we will be popping these registers
>   before the tail call and target program will be doing pushes.

I would create a benchmark out of progs/tailcall[1-5].c and progs/bpf_flow.c
I think it will be good enough to assess performance before/after.

> Daniel, John, is there some Cilium benchmark that we could incorporate? I
> don't think we be able to come up with a program that would mimic what you
> have previously described, e.g. 6 static jumps where every program would
> be utilizing every callee-saved register. Any help/pointers on how should
> we approach it would be very appreciated.

progs/bpf_flow.c is pretty much such example or I missing something?
Every jump of tail_call is using r6 and r7 at least there.
But bodies of the functions are not empty, so more registers being used
the more work the function is doing and less noticeable the overhead
of new tail_call will be.
