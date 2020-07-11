Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2FD21C10A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 02:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgGKAKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 20:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgGKAKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 20:10:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FC4C08C5DC;
        Fri, 10 Jul 2020 17:10:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so3239210pfi.2;
        Fri, 10 Jul 2020 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0YCvotzE+6pJqFZeTOQOWus9L936EhJ0PteOu2HC4pw=;
        b=WGRBjQTIArkFTSTA03N8p1Y/uUJHklQAADNLoEzfhFUnKwicNRYjzOXFWwqmMWnxKz
         3pfrZTXuRl9p2UCalcrTUD2YJuM/tzqGhpNZV54SDtQC6LZ1q888lrlVNnv8r+uL8tnC
         iJQznRlVCXObuIB79+gBTsBZU109kRg1XD58AGv6aVsA7O+DGzJkoZmBPSeCYBQx66JQ
         FLlQoqwmyYrrJKdeAdlqMTPYlgK6zPu/1vFYeSg9AIqz9OLiFZEXKlNu3dKrmQC0xfky
         w7edNnd/uvQnDXPAqWrmlctloWx10t4uGkhNSZZQrWFhCNgrRYp6f2P6pWiTDRIPTSlu
         OUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0YCvotzE+6pJqFZeTOQOWus9L936EhJ0PteOu2HC4pw=;
        b=aArGsAzm03hzb5ONtSTvp9kwWAuzEbHM7P7HDvRXLbjkiH2n/u7/1Mv5hWW0fzG5FN
         mJ+CFsv44aj7qbtH5Ptif9A9mp9ywqqB7b79rKrCPmbcVUkebKclYgY+CC/RRen0gIwh
         Ow+FSW1MFdoKrO6YH3lroqYgOD6mhnLmf4fvAuDJ8YKrI8m56IX44dEfawkabbBTCAR2
         FYlIGxFCChIT1+7ayfB5lQ2qCwuQUA7hwDMVIVx+NS6H/+vpTGdB0GnGhqbrrMbNIVyR
         BqNeZi4vyyKJGSEiuFM53ogA3ty2kr9Q+w0rAv8OOZNCzCh08TSeqG5Q5ROsL/wo+AH4
         0lsQ==
X-Gm-Message-State: AOAM532u8NQRYhpFmh9WrguZV3e1KID8qLiotr56tjafk6jtxC41hGmp
        mp8OCoOQml1l3ipCW6QmqEw=
X-Google-Smtp-Source: ABdhPJwjAhM63Dt6JvH4HM2sElaJ34fgbvyKAb+bMMmxHONd7hsNIHlmrmu7ZmHGDxaIsRIIM06JfQ==
X-Received: by 2002:aa7:8391:: with SMTP id u17mr19421258pfm.156.1594426211412;
        Fri, 10 Jul 2020 17:10:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c88c])
        by smtp.gmail.com with ESMTPSA id 190sm6905042pfz.41.2020.07.10.17.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 17:10:10 -0700 (PDT)
Date:   Fri, 10 Jul 2020 17:10:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [RFC PATCH bpf-next 0/5] bpf: tailcalls in BPF subprograms
Message-ID: <20200711001008.dtklgbidwy37dsf7@ast-mbp.dhcp.thefacebook.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 03:49:25PM +0200, Maciej Fijalkowski wrote:
> Hello,
> 
> today bpf2bpf calls and tailcalls exclude each other. This set is a
> proposal to make them work together. It is still a RFC because we need
> to decide if the performance impact for BPF programs with tailcalls is
> acceptable or not. Note that I have been focused only on x86
> architecture, I am not sure if other architectures have some other
> restrictions that were stopping us to have tailcalls in BPF subprograms.
> 
> I would also like to get a feedback on prog_array_map_poke_run changes.
> 
> To give you an overview how this work started, previously I posted RFC
> that was targetted at getting rid of push/pop instructions for callee
> saved registers in x86-64 JIT that are not used by the BPF program.
> Alexei saw a potential that that work could be lifted a bit and
> tailcalls could work with BPF subprograms. More on that in [1], [2].
> 
> In [1], Alexei says:
> 
> "The prologue will look like:
> nop5
> xor eax,eax  // two new bytes if bpf_tail_call() is used in this
> function
> push rbp
> mov rbp, rsp
> sub rsp, rounded_stack_depth
> push rax // zero init tail_call counter
> variable number of push rbx,r13,r14,r15
> 
> Then bpf_tail_call will pop variable number rbx,..
> and final 'pop rax'
> Then 'add rsp, size_of_current_stack_frame'
> jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov
> rbp, rsp'
> 
> This way new function will set its own stack size and will init tail
> call counter with whatever value the parent had.
> 
> If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
> Instead it would need to have 'nop2' in there."
> 
> So basically I gave a shot at that suggestion. Patch 4 has a description
> of implementation.
> 
> Quick overview of patches:
> Patch 1 changes BPF retpoline to use %rcx instead of %rax to store
> address of BPF tailcall target program
> Patch 2 relaxes verifier's restrictions about tailcalls being used with
> BPF subprograms
> Patch 3 propagates poke descriptors from main program to each subprogram
> Patch 4 is the main dish in this set. It implements new prologue layout
> that was suggested by Alexei and reworks tailcall handling.
> Patch 5 is the new selftest that proves tailcalls can be used from
> within BPF subprogram.
> 
> -------------------------------------------------------------------
> Debatable prog_array_map_poke_run changes:
> 
> Before the tailcall and with the new prologue layout, stack need to be
> unwinded and callee saved registers need to be popped. Instructions
> responsible for that are generated, but they should not be executed if
> target program is not present. To address that, new poke target 'ip_aux'
> is introduced to poke descriptor that will be used for skipping these
> instructions. This means there are two poke targets for handling direct
> tailcalls. Simplified flow can be presented as three sections:
> 
> 1. skip call or nop (poke->ip_aux)
> 2. stack unwind
> 3. call tail or nop (poke->ip)
> 
> It would be possible that one of CPU might be in point 2 and point 3 is
> not yet updated (nop), which would lead to problems mentioned in patch 4
> commit message, IOW unwind section should not be executed if there is no
> target program.
> 
> We can define the following state matrix for that (courtesy of Bjorn):
> A nop, unwind, nop
> B nop, unwind, tail
> C skip, unwind, nop
> D skip, unwind, tail
> 
> A is forbidden (lead to incorrectness). C is the starting state. What if
> we just make sure we *never* enter than state, and never return to C?
> 
> First install tail call f: C->D->B(f)
>  * poke the tailcall, after that get rid of the skip
> Update tail call f to f': B(f)->B(f')
>  * poke the tailcall (poke->ip) and do NOT touch the poke->ip_aux
> Remove tail call: B(f')->D(f')
>  * do NOT touch poke->ip, only poke the poke->ip_aux. Note that we do
>    not get back to C(f')
> Install new tail call (f''): D(f')->D(f'')->B(f'').
>  * poke both targets, first ->ip then ->ip_aux
> 
> So, by avoiding A and never going back to C another CPU can never be
> exposed to the "unwind, tail" state.
> 
> Right now, due to 'faking' the bpf_arch_text_poke,
> prog_array_map_poke_run looks a bit messy. I dropped the 'old' argument
> usage at all and instead I do the reverse calculation that is being done
> by emit_patch, so that the result of memcmp(ip, old_insn, X86_PATCH_SIZE)
> is 0 and we do the actual poking.
> 
> Presumably this is something to be fixed/improved, but at first, I would
> like to hear opinions of others and have some decision whether it is worth
> pursuing, or not.

above state transitions break my mind.
I replied in the patch 3. I hope we don't need this extra first nop5
and ip_aux.

> 
> -------------------------------------------------------------------
> Performance impact:
> 
> As requested, I'm including the performance numbers that show an
> impact of that set, but I did not analyze it. Let's do this on list.
> Also, please let me know if these scenarios make sense and are
> sufficient.
> 
> All of this work, as stated in [2], started as a way to speed up AF-XDP
> by dropping the push/pop of unused callee saved registers in prologue
> and epilogue. Impact is positive, 15% of performance gain.
> 
> However, it is obvious that it will have a negative impact on BPF
> programs that utilize tailcalls. I was asked to provide some numbers
> that will tell us how much actually are theses cases damaged by this
> set.
> 
> Below are te numbers from 'perf stat' for two scenarios.
> First scenario is the output of command:
> 
> $ sudo perf stat -ddd -r 1024 ./test_progs -t tailcalls
> 
> tailcalls kselftest was modified in a following way:
> - only taicall1 subtest is enabled
> - each of the bpf_prog_test_run() calls got set 'repeat' argument to
>   1000000
> 
> Numbers without this set:
> 
>  Performance counter stats for './test_progs -t tailcalls' (1024 runs):
> 
>             198.73 msec task-clock                #    0.997 CPUs utilized            ( +-  0.13% )
>                  6      context-switches          #    0.030 K/sec                    ( +-  0.75% )
>                  0      cpu-migrations            #    0.000 K/sec                    ( +- 22.15% )
>                108      page-faults               #    0.546 K/sec                    ( +-  0.03% )
>        693,910,413      cycles                    #    3.492 GHz                      ( +-  0.11% )  (30.26%)
>      1,067,635,122      instructions              #    1.54  insn per cycle           ( +-  0.03% )  (38.16%)
>        165,308,809      branches                  #  831.822 M/sec                    ( +-  0.02% )  (38.46%)
>          9,940,504      branch-misses             #    6.01% of all branches          ( +-  0.02% )  (38.77%)
>        226,741,985      L1-dcache-loads           # 1140.949 M/sec                    ( +-  0.02% )  (39.07%)
>            161,936      L1-dcache-load-misses     #    0.07% of all L1-dcache hits    ( +-  0.66% )  (39.12%)
>             43,777      LLC-loads                 #    0.220 M/sec                    ( +-  0.97% )  (31.07%)
>             11,773      LLC-load-misses           #   26.89% of all LL-cache hits     ( +-  0.99% )  (30.93%)
>    <not supported>      L1-icache-loads
>             97,692      L1-icache-load-misses                                         ( +-  0.51% )  (30.77%)
>        229,069,211      dTLB-loads                # 1152.659 M/sec                    ( +-  0.02% )  (30.62%)
>              1,031      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  1.28% )  (30.46%)
>              2,236      iTLB-loads                #    0.011 M/sec                    ( +-  1.28% )  (30.30%)
>                357      iTLB-load-misses          #   15.99% of all iTLB cache hits   ( +-  2.10% )  (30.16%)
>    <not supported>      L1-dcache-prefetches
>    <not supported>      L1-dcache-prefetch-misses
> 
>           0.199307 +- 0.000250 seconds time elapsed  ( +-  0.13% )
> 
> With:
> 
>  Performance counter stats for './test_progs -t tailcalls' (1024 runs):
> 
>             202.48 msec task-clock                #    0.997 CPUs utilized            ( +-  0.09% )

I think this extra overhead is totally acceptable for such important feature.

>                  6      context-switches          #    0.032 K/sec                    ( +-  1.86% )
>                  0      cpu-migrations            #    0.000 K/sec                    ( +- 30.00% )
>                108      page-faults               #    0.535 K/sec                    ( +-  0.03% )
>        718,001,313      cycles                    #    3.546 GHz                      ( +-  0.06% )  (30.12%)
>      1,041,618,306      instructions              #    1.45  insn per cycle           ( +-  0.03% )  (37.96%)
>        226,386,119      branches                  # 1118.091 M/sec                    ( +-  0.03% )  (38.35%)
>          9,882,436      branch-misses             #    4.37% of all branches          ( +-  0.02% )  (38.59%)
>        196,832,137      L1-dcache-loads           #  972.128 M/sec                    ( +-  0.02% )  (39.15%)
>            217,794      L1-dcache-load-misses     #    0.11% of all L1-dcache hits    ( +-  0.67% )  (39.23%)
>             70,690      LLC-loads                 #    0.349 M/sec                    ( +-  0.90% )  (31.15%)
>             18,802      LLC-load-misses           #   26.60% of all LL-cache hits     ( +-  0.84% )  (31.18%)
>    <not supported>      L1-icache-loads
>            106,461      L1-icache-load-misses                                         ( +-  0.51% )  (30.83%)
>        198,887,011      dTLB-loads                #  982.277 M/sec                    ( +-  0.02% )  (30.66%)
>              1,483      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  1.28% )  (30.50%)
>              4,064      iTLB-loads                #    0.020 M/sec                    ( +- 21.43% )  (30.23%)
>                488      iTLB-load-misses          #   12.00% of all iTLB cache hits   ( +-  1.95% )  (30.03%)
>    <not supported>      L1-dcache-prefetches
>    <not supported>      L1-dcache-prefetch-misses
> 
>           0.203081 +- 0.000187 seconds time elapsed  ( +-  0.09% )
> 
> 
> Second conducted measurement was on BPF kselftest flow_dissector that is
> using the progs/bpf_flow.c with 'repeat' argument on
> bpf_prog_test_run_xattr set also to 1000000.
> 
> Without:
> 
>  Performance counter stats for './test_progs -t flow_dissector' (1024 runs):
> 
>           1,340.52 msec task-clock                #    0.987 CPUs utilized            ( +-  0.05% )
>                 25      context-switches          #    0.018 K/sec                    ( +-  0.32% )
>                  0      cpu-migrations            #    0.000 K/sec                    ( +-  8.59% )
>                122      page-faults               #    0.091 K/sec                    ( +-  0.03% )
>      4,764,381,512      cycles                    #    3.554 GHz                      ( +-  0.04% )  (30.68%)
>      7,674,803,496      instructions              #    1.61  insn per cycle           ( +-  0.01% )  (38.41%)
>      1,118,346,714      branches                  #  834.261 M/sec                    ( +-  0.00% )  (38.46%)
>         29,132,651      branch-misses             #    2.60% of all branches          ( +-  0.00% )  (38.50%)
>      1,737,552,687      L1-dcache-loads           # 1296.174 M/sec                    ( +-  0.01% )  (38.55%)
>          1,064,105      L1-dcache-load-misses     #    0.06% of all L1-dcache hits    ( +-  1.28% )  (38.57%)
>             50,356      LLC-loads                 #    0.038 M/sec                    ( +-  1.42% )  (30.82%)
>             10,825      LLC-load-misses           #   21.50% of all LL-cache hits     ( +-  1.42% )  (30.79%)
>    <not supported>      L1-icache-loads
>            568,800      L1-icache-load-misses                                         ( +-  0.66% )  (30.77%)
>      1,741,511,307      dTLB-loads                # 1299.127 M/sec                    ( +-  0.01% )  (30.75%)
>              5,112      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  2.29% )  (30.73%)
>              2,128      iTLB-loads                #    0.002 M/sec                    ( +-  2.06% )  (30.70%)
>                571      iTLB-load-misses          #   26.85% of all iTLB cache hits   ( +-  3.10% )  (30.68%)
>    <not supported>      L1-dcache-prefetches
>    <not supported>      L1-dcache-prefetch-misses
> 
>           1.358653 +- 0.000741 seconds time elapsed  ( +-  0.05% )
> 
> 
> With:
> 
>  Performance counter stats for './test_progs -t flow_dissector' (1024 runs):
> 
>           1,426.95 msec task-clock                #    0.989 CPUs utilized            ( +-  0.04% )

are you saying the patches add ~6% overhead?

>                 23      context-switches          #    0.016 K/sec                    ( +-  0.40% )
>                  0      cpu-migrations            #    0.000 K/sec                    ( +-  6.38% )
>                122      page-faults               #    0.085 K/sec                    ( +-  0.03% )
>      4,772,798,523      cycles                    #    3.345 GHz                      ( +-  0.03% )  (30.70%)
>      7,837,101,633      instructions              #    1.64  insn per cycle           ( +-  0.00% )  (38.42%)

but the overhead cannot be due to extra instructions.

>      1,118,716,987      branches                  #  783.992 M/sec                    ( +-  0.00% )  (38.46%)
>         29,147,367      branch-misses             #    2.61% of all branches          ( +-  0.00% )  (38.51%)
>      1,797,232,091      L1-dcache-loads           # 1259.492 M/sec                    ( +-  0.00% )  (38.55%)
>          1,487,769      L1-dcache-load-misses     #    0.08% of all L1-dcache hits    ( +-  0.66% )  (38.55%)
>             50,180      LLC-loads                 #    0.035 M/sec                    ( +-  1.37% )  (30.81%)
>             14,709      LLC-load-misses           #   29.31% of all LL-cache hits     ( +-  1.11% )  (30.79%)
>    <not supported>      L1-icache-loads
>            626,633      L1-icache-load-misses                                         ( +-  0.58% )  (30.77%)
>      1,800,278,668      dTLB-loads                # 1261.627 M/sec                    ( +-  0.01% )  (30.75%)
>              3,809      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  2.71% )  (30.72%)
>              1,745      iTLB-loads                #    0.001 M/sec                    ( +-  3.90% )  (30.70%)
>             12,267      iTLB-load-misses          #  703.02% of all iTLB cache hits   ( +- 96.08% )  (30.68%)

Looks like that's where the perf is suffering. The number of iTLB misses jumps.
It could be due to ip_aux. Just a guess.

Could you try unwind+nop5+push approach and compare before/after
but this time please share annotated 'perf report'.
If iTLB is still struggling 'perf report' should be able to pin point
the instruction that is causing it.
May be jmp target needs to be 16-byte aligned or something.
Or we simply got unlucky by pushing into different cache line.

Also when you do this microbenchmarking please make sure
that bpf_jit_binary_alloc() does not use get_random_int().
It can cause nasty surprises and run-to-run variations.
