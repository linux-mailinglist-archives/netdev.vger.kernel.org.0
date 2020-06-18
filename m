Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99151FEC76
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgFRHbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 03:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgFRHbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:31:04 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DEEC06174E;
        Thu, 18 Jun 2020 00:31:04 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id e2so2318117qvw.7;
        Thu, 18 Jun 2020 00:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iv88w5ib0YkWhnstW1cdAb86VAFuie3oOlOzwDfGZB0=;
        b=TehygnNhsFChn8mq/67ZPP7wXMghwUR8u8bISp3oqVGKa7/BK3JKV/a31OinhzjwcR
         j94CsXVTuVIoh2gZBThfCpFYuHK1K9LBasXIKhycw9/ScV1PrW/Dqc+cF/iOE2OoDg2w
         QjfzqEIQsrYigOFQ2AV5sbl6R5bBp2IT1847/vhSG1W+ZT8LzGnbuTkBCbRmx5cnpoap
         vkpvIz8aQLk/iyHHiOehNXXMqIjyZKFnu1cKjg7yD7VEw+2ZwL7oF+M1k0EcPg6UQlOV
         AVhmQWHrr8a0nxy/sk35QVAokktkOF/H5EqCY5GpEEcQseZNUT/yJ6V6n8MMxGbOEakj
         KC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iv88w5ib0YkWhnstW1cdAb86VAFuie3oOlOzwDfGZB0=;
        b=NRogzoBK8LWJ2BWGAsoWQpInDu1c9TNwoooLGAjdIipVq8AxsUVWiheK4b6EfnxCLO
         L0qSaHSDbM+0cURSBda+51j6uXr6iXRT8bjsK+O3t/Sl7XMr/qiFe4lskN0TZ41KKrRl
         W+Ck5DfW119tJ1U7ZxltH0tEaJIRjRCbsgdxlDOdtJtWmV2Vhh1i9BLQNnEgG34kTZzK
         X4ZfOhSDEJLZOK7ysdXGBOPd6glsQ/cCznOCxuZ1aQSQ2tzy3JKEKjOsbJtT4c9cq57Z
         2dWJwKezISMSwBzm2NZHNHaFr4NYuhtiZwlPljC4lTiwx/QL3vy/pi7T1qKs5FVjSIaN
         +Z6w==
X-Gm-Message-State: AOAM530c852Nh7ocOU/L7eEBiXUEZ6u6R9jCZ6KrOMOhLu74W2MzmVdy
        dxRl2BDmeDx3WX4/Y959CTH4y+OssDgT96+hjHQ=
X-Google-Smtp-Source: ABdhPJzvG9uLNN8e5pWO4u6OUj5G75XJS8BoVU2HRE0YtzHb0p83YIg4qUuOVZ8O9AGX0+j8TrbkAtpZGLTWgdoOPo4=
X-Received: by 2002:ad4:4572:: with SMTP id o18mr2270701qvu.228.1592465463404;
 Thu, 18 Jun 2020 00:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200617202112.2438062-1-andriin@fb.com> <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
In-Reply-To: <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 00:30:52 -0700
Message-ID: <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 11:49 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Switch most of BPF helper definitions from returning int to long. These
> > definitions are coming from comments in BPF UAPI header and are used to
> > generate bpf_helper_defs.h (under libbpf) to be later included and used from
> > BPF programs.
> >
> > In actual in-kernel implementation, all the helpers are defined as returning
> > u64, but due to some historical reasons, most of them are actually defined as
> > returning int in UAPI (usually, to return 0 on success, and negative value on
> > error).
>
> Could we change the helpers side to return correct types now? Meaning if the
> UAPI claims its an int lets actually return the int.

I'm not sure how exactly you see this being done. BPF ABI dictates
that the helper's result is passed in a full 64-bit r0 register. Are
you suggesting that in addition to RET_ANYTHING we should add
RET_ANYTHING32 and teach verifier that higher 32 bits of r0 are
guaranteed to be zero? And then make helpers actually return 32-bit
values without up-casting them to u64?

>
> >
> > This actually causes Clang to quite often generate sub-optimal code, because
> > compiler believes that return value is 32-bit, and in a lot of cases has to be
> > up-converted (usually with a pair of 32-bit bit shifts) to 64-bit values,
> > before they can be used further in BPF code.
> >
> > Besides just "polluting" the code, these 32-bit shifts quite often cause
> > problems for cases in which return value matters. This is especially the case
> > for the family of bpf_probe_read_str() functions. There are few other similar
> > helpers (e.g., bpf_read_branch_records()), in which return value is used by
> > BPF program logic to record variable-length data and process it. For such
> > cases, BPF program logic carefully manages offsets within some array or map to
> > read variable-length data. For such uses, it's crucial for BPF verifier to
> > track possible range of register values to prove that all the accesses happen
> > within given memory bounds. Those extraneous zero-extending bit shifts,
> > inserted by Clang (and quite often interleaved with other code, which makes
> > the issues even more challenging and sometimes requires employing extra
> > per-variable compiler barriers), throws off verifier logic and makes it mark
> > registers as having unknown variable offset. We'll study this pattern a bit
> > later below.
>
> With latest verifier zext with alu32 support should be implemented as a
> MOV insn.

Code generation is independent of verifier version or am I not getting
what you are saying? Also all this code was compiled with up-to-date
Clang.

>
> >
> > Another common pattern is to check return of BPF helper for non-zero state to
> > detect error conditions and attempt alternative actions in such case. Even in
> > this simple and straightforward case, this 32-bit vs BPF's native 64-bit mode
> > quite often leads to sub-optimal and unnecessary extra code. We'll look at
> > this pattern as well.
> >
> > Clang's BPF target supports two modes of code generation: ALU32, in which it
> > is capable of using lower 32-bit parts of registers, and no-ALU32, in which
> > only full 64-bit registers are being used. ALU32 mode somewhat mitigates the
> > above described problems, but not in all cases.
>
> A bit curious, do you see users running with no-ALU32 support? I have enabled
> it by default now. It seems to generate better code and with latest 32-bit
> bounds tracking I haven't hit any issues with verifier.

Yes, all Facebook apps are built with no-ALU32. And those apps have to
run on quite old kernels as well, so relying on latest bug fixes in
kernel is not an option right now.

>
> >
> > This patch switches all the cases in which BPF helpers return 0 or negative
> > error from returning int to returning long. It is shown below that such change
> > in definition leads to equivalent or better code. No-ALU32 mode benefits more,
> > but ALU32 mode doesn't degrade or still gets improved code generation.
> >
> > Another class of cases switched from int to long are bpf_probe_read_str()-like
> > helpers, which encode successful case as non-negative values, while still
> > returning negative value for errors.
> >
> > In all of such cases, correctness is preserved due to two's complement
> > encoding of negative values and the fact that all helpers return values with
> > 32-bit absolute value. Two's complement ensures that for negative values
> > higher 32 bits are all ones and when truncated, leave valid negative 32-bit
> > value with the same value. Non-negative values have upper 32 bits set to zero
> > and similarly preserve value when high 32 bits are truncated. This means that
> > just casting to int/u32 is correct and efficient (and in ALU32 mode doesn't
> > require any extra shifts).
> >
> > To minimize the chances of regressions, two code patterns were investigated,
> > as mentioned above. For both patterns, BPF assembly was analyzed in
> > ALU32/NO-ALU32 compiler modes, both with current 32-bit int return type and
> > new 64-bit long return type.
> >
> > Case 1. Variable-length data reading and concatenation. This is quite
> > ubiquitous pattern in tracing/monitoring applications, reading data like
> > process's environment variables, file path, etc. In such case, many pieces of
> > string-like variable-length data are read into a single big buffer, and at the
> > end of the process, only a part of array containing actual data is sent to
> > user-space for further processing. This case is tested in test_varlen.c
> > selftest (in the next patch). Code flow is roughly as follows:
> >
> >   void *payload = &sample->payload;
> >   u64 len;
> >
> >   len = bpf_probe_read_kernel_str(payload, MAX_SZ1, &source_data1);
> >   if (len <= MAX_SZ1) {
> >       payload += len;
> >       sample->len1 = len;
> >   }
> >   len = bpf_probe_read_kernel_str(payload, MAX_SZ2, &source_data2);
> >   if (len <= MAX_SZ2) {
> >       payload += len;
> >       sample->len2 = len;
> >   }
> >   /* and so on */
> >   sample->total_len = payload - &sample->payload;
> >   /* send over, e.g., perf buffer */
> >
> > There could be two variations with slightly different code generated: when len
> > is 64-bit integer and when it is 32-bit integer. Both variations were analysed.
> > BPF assembly instructions between two successive invocations of
> > bpf_probe_read_kernel_str() were used to check code regressions. Results are
> > below, followed by short analysis. Left side is using helpers with int return
> > type, the right one is after the switch to long.
> >
> > ALU32 + INT                                ALU32 + LONG
> > ===========                                ============
> >
> > 64-BIT (13 insns):                         64-BIT (10 insns):
> > ------------------------------------       ------------------------------------
> >   17:   call 115                             17:   call 115
> >   18:   if w0 > 256 goto +9 <LBB0_4>         18:   if r0 > 256 goto +6 <LBB0_4>
> >   19:   w1 = w0                              19:   r1 = 0 ll
> >   20:   r1 <<= 32                            21:   *(u64 *)(r1 + 0) = r0
> >   21:   r1 s>>= 32                           22:   r6 = 0 ll
>
> What version of clang is this? That is probably a zext in llvm-ir that in
> latest should be sufficient with the 'w1=w0'. I'm guessing (hoping?) you
> might not have latest?

Just double-checked, very latest Clang, built today. Still generates
the same code.

But I think this makes sense, because r1 is u64, and it gets assigned
from int, so int first has to be converted to s64, then casted to u64.
So sign extension is necessary. I've confirmed with this simple
program:

$ cat bla.c
#include <stdio.h>

int main() {
        int a = -1;
        unsigned long b = a;
        printf("%lx\n", b);
        return 0;
}
$ clang bla.c -o test && ./test
ffffffffffffffff

^^^^^^^^--- not zeroes

So I don't think it's a bug or inefficiency, C language requires that.

>
> >   22:   r2 = 0 ll                            24:   r6 += r0
> >   24:   *(u64 *)(r2 + 0) = r1              00000000000000c8 <LBB0_4>:
> >   25:   r6 = 0 ll                            25:   r1 = r6
> >   27:   r6 += r1                             26:   w2 = 256
> > 00000000000000e0 <LBB0_4>:                   27:   r3 = 0 ll
> >   28:   r1 = r6                              29:   call 115
> >   29:   w2 = 256
> >   30:   r3 = 0 ll
> >   32:   call 115
> >
> > 32-BIT (11 insns):                         32-BIT (12 insns):
> > ------------------------------------       ------------------------------------
> >   17:   call 115                             17:   call 115
> >   18:   if w0 > 256 goto +7 <LBB1_4>         18:   if w0 > 256 goto +8 <LBB1_4>
> >   19:   r1 = 0 ll                            19:   r1 = 0 ll
> >   21:   *(u32 *)(r1 + 0) = r0                21:   *(u32 *)(r1 + 0) = r0
> >   22:   w1 = w0                              22:   r0 <<= 32
> >   23:   r6 = 0 ll                            23:   r0 >>= 32
> >   25:   r6 += r1                             24:   r6 = 0 ll
> > 00000000000000d0 <LBB1_4>:                   26:   r6 += r0
> >   26:   r1 = r6                            00000000000000d8 <LBB1_4>:
> >   27:   w2 = 256                             27:   r1 = r6
> >   28:   r3 = 0 ll                            28:   w2 = 256
> >   30:   call 115                             29:   r3 = 0 ll
> >                                              31:   call 115
> >
> > In ALU32 mode, the variant using 64-bit length variable clearly wins and
> > avoids unnecessary zero-extension bit shifts. In practice, this is even more
> > important and good, because BPF code won't need to do extra checks to "prove"
> > that payload/len are within good bounds.
>
> I bet with latest clang the shifts are removed. But if not we probably
> should fix clang regardless of if helpers return longs or ints.

are we still talking about bit shifts for INT HELPER + U64 len case?
Or now about bit shifts in LONG HELPER + U32 len case?

>
> >
> > 32-bit len is one instruction longer. Clang decided to do 64-to-32 casting
> > with two bit shifts, instead of equivalent `w1 = w0` assignment. The former
> > uses extra register. The latter might potentially lose some range information,
> > but not for 32-bit value. So in this case, verifier infers that r0 is [0, 256]
> > after check at 18:, and shifting 32 bits left/right keeps that range intact.
> > We should probably look into Clang's logic and see why it chooses bitshifts
> > over sub-register assignments for this.
> >
> > NO-ALU32 + INT                             NO-ALU32 + LONG
> > ==============                             ===============
> >
> > 64-BIT (14 insns):                         64-BIT (10 insns):
> > ------------------------------------       ------------------------------------
> >   17:   call 115                             17:   call 115
> >   18:   r0 <<= 32                            18:   if r0 > 256 goto +6 <LBB0_4>
> >   19:   r1 = r0                              19:   r1 = 0 ll
> >   20:   r1 >>= 32                            21:   *(u64 *)(r1 + 0) = r0
> >   21:   if r1 > 256 goto +7 <LBB0_4>         22:   r6 = 0 ll
> >   22:   r0 s>>= 32                           24:   r6 += r0
> >   23:   r1 = 0 ll                          00000000000000c8 <LBB0_4>:
> >   25:   *(u64 *)(r1 + 0) = r0                25:   r1 = r6
> >   26:   r6 = 0 ll                            26:   r2 = 256
> >   28:   r6 += r0                             27:   r3 = 0 ll
> > 00000000000000e8 <LBB0_4>:                   29:   call 115
> >   29:   r1 = r6
> >   30:   r2 = 256
> >   31:   r3 = 0 ll
> >   33:   call 115
> >
> > 32-BIT (13 insns):                         32-BIT (13 insns):
> > ------------------------------------       ------------------------------------
> >   17:   call 115                             17:   call 115
> >   18:   r1 = r0                              18:   r1 = r0
> >   19:   r1 <<= 32                            19:   r1 <<= 32
> >   20:   r1 >>= 32                            20:   r1 >>= 32
> >   21:   if r1 > 256 goto +6 <LBB1_4>         21:   if r1 > 256 goto +6 <LBB1_4>
> >   22:   r2 = 0 ll                            22:   r2 = 0 ll
> >   24:   *(u32 *)(r2 + 0) = r0                24:   *(u32 *)(r2 + 0) = r0
> >   25:   r6 = 0 ll                            25:   r6 = 0 ll
> >   27:   r6 += r1                             27:   r6 += r1
> > 00000000000000e0 <LBB1_4>:                 00000000000000e0 <LBB1_4>:
> >   28:   r1 = r6                              28:   r1 = r6
> >   29:   r2 = 256                             29:   r2 = 256
> >   30:   r3 = 0 ll                            30:   r3 = 0 ll
> >   32:   call 115                             32:   call 115
> >
> > In NO-ALU32 mode, for the case of 64-bit len variable, Clang generates much
> > superior code, as expected, eliminating unnecessary bit shifts. For 32-bit
> > len, code is identical.
>
> Right I can't think of any way clang can avoid it here. OTOH I fix this
> by enabling alu32 ;)
>
> >
> > So overall, only ALU-32 32-bit len case is more-or-less equivalent and the
> > difference stems from internal Clang decision, rather than compiler lacking
> > enough information about types.
> >
> > Case 2. Let's look at the simpler case of checking return result of BPF helper
> > for errors. The code is very simple:
> >
> >   long bla;
> >   if (bpf_probe_read_kenerl(&bla, sizeof(bla), 0))
> >       return 1;
> >   else
> >       return 0;
> >
> > ALU32 + CHECK (9 insns)                    ALU32 + CHECK (9 insns)
> > ====================================       ====================================
> >   0:    r1 = r10                             0:    r1 = r10
> >   1:    r1 += -8                             1:    r1 += -8
> >   2:    w2 = 8                               2:    w2 = 8
> >   3:    r3 = 0                               3:    r3 = 0
> >   4:    call 113                             4:    call 113
> >   5:    w1 = w0                              5:    r1 = r0
> >   6:    w0 = 1                               6:    w0 = 1
> >   7:    if w1 != 0 goto +1 <LBB2_2>          7:    if r1 != 0 goto +1 <LBB2_2>
> >   8:    w0 = 0                               8:    w0 = 0
> > 0000000000000048 <LBB2_2>:                 0000000000000048 <LBB2_2>:
> >   9:    exit                                 9:    exit
> >
> > Almost identical code, the only difference is the use of full register
> > assignment (r1 = r0) vs half-registers (w1 = w0) in instruction #5. On 32-bit
> > architectures, new BPF assembly might be slightly less optimal, in theory. But
> > one can argue that's not a big issue, given that use of full registers is
> > still prevalent (e.g., for parameter passing).
> >
> > NO-ALU32 + CHECK (11 insns)                NO-ALU32 + CHECK (9 insns)
> > ====================================       ====================================
> >   0:    r1 = r10                             0:    r1 = r10
> >   1:    r1 += -8                             1:    r1 += -8
> >   2:    r2 = 8                               2:    r2 = 8
> >   3:    r3 = 0                               3:    r3 = 0
> >   4:    call 113                             4:    call 113
> >   5:    r1 = r0                              5:    r1 = r0
> >   6:    r1 <<= 32                            6:    r0 = 1
> >   7:    r1 >>= 32                            7:    if r1 != 0 goto +1 <LBB2_2>
> >   8:    r0 = 1                               8:    r0 = 0
> >   9:    if r1 != 0 goto +1 <LBB2_2>        0000000000000048 <LBB2_2>:
> >  10:    r0 = 0                               9:    exit
> > 0000000000000058 <LBB2_2>:
> >  11:    exit
> >
> > NO-ALU32 is a clear improvement, getting rid of unnecessary zero-extension bit
> > shifts.
>
> It seems a win for the NO-ALU32 case but for the +ALU32 case I think its
> the same with latest clang although I haven't tried yet. I was actually
> considering going the other way and avoiding always returning u64 on
> the other side. From a purely aesethetics point of view I prefer the
> int type because it seems more clear/standard C. I'm also not so interested
> in optimizing the no-alu32 case but curious if there is a use case for
> that?

My point was that this int -> long switch doesn't degrade ALU32 and
helps no-ALU32, and thus is good :)

Overall, long as a return type matches reality and BPF ABI
specification. BTW, one of the varlen programs from patch 2 doesn't
even validate successfully on latest kernel with latest Clang right
now, if helpers return int, even though it's completely correct code.
That's a real problem we have to deal with in few major BPF
applications right now, and we have to use inline assembly to enforce
Clang to do the right thing. A bunch of those problems are simply
avoided with correct return types for helpers.
