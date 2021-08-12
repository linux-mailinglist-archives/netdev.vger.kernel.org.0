Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A193EA89A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhHLQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHLQh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:37:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302D9C061756;
        Thu, 12 Aug 2021 09:37:04 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k29so9152661wrd.7;
        Thu, 12 Aug 2021 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TKWm9xh90AzQlT9X7jlWHDz/V8Ewppr08sBjAVjTj8=;
        b=C2dEUMvL9SPTQ+WHyYzmijzglqXxDNIQnW8yFERVg2OanY6YQ6zUrCKGNq4beGT5ti
         wAOgO0RQb2K4cX7wWgD5mDpbtkIXHU20HTow6tRw4GTgEDqSqcC6fv82gPQIHDrx0k8J
         Nxd1mSTA0i8sOqJOuGDx0U6JYL9oe/1i7AzagDSCS8TnipxBCEC/NV1xv9UeyWAN2sKa
         xHQWQ3xjHDMX0+ZFnPvBvAe/9R3z+sLiapSsIdQdnOy8KM0UxWqeT12zb2HVjJQguUG9
         8NWc9xa6tSrFgfdGOq3BuYyMXGwyKscCjAn2i1jUShcPE7wdW6fOqNOlWrwKACrxTl19
         Grmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TKWm9xh90AzQlT9X7jlWHDz/V8Ewppr08sBjAVjTj8=;
        b=NLUoMQwquPlnROQXDoOuoaPYSyChfdoq11I5ztX0PbF7utMJ+zmkNKAm8efrJu8+hP
         mgaoOcsF6xs22T6xBwgYGdaH3UggpYVWM5BLx1pjx1+G3gHHmjDXUw45Y/OL+xesnWoM
         /k6pwjcf9zEVsmvNVilSn4o1gchuIlRkeMVFpvN7nzzY8NngbDmSVgZCXDQBW9Q5fT6V
         docwnVY5oMljy578aqVvrdhzesngiWBqMt+k5aZR5TF/R03vn75nGjjBRarMLonA2DU5
         ShDT+JvJ/pHvIdY7c8YJy8BHT+afdzrTTpJkujbN71T4J3tEjEadjbJVDnaLQe1N+jc1
         DFlg==
X-Gm-Message-State: AOAM5334cf6ZJsNDZt2c+43krkgds/8rRl/QfHP3xEBQxVPs84e+VLap
        OvFl4o/38yjPBvjMulJ2Q/E=
X-Google-Smtp-Source: ABdhPJxTgpLnBy1mWqZxrbn47qM2bzuRlk2RMzcqWY8AoqXzjIXpj27V/J/vdwjx9i4WO890CyXTew==
X-Received: by 2002:a05:6000:1241:: with SMTP id j1mr5180104wrx.338.1628786222740;
        Thu, 12 Aug 2021 09:37:02 -0700 (PDT)
Received: from Mem (2a01cb088160fc0085ca848d27f70819.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:85ca:848d:27f7:819])
        by smtp.gmail.com with ESMTPSA id e3sm3720765wrv.65.2021.08.12.09.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 09:37:02 -0700 (PDT)
Date:   Thu, 12 Aug 2021 18:36:59 +0200
From:   Paul Chaignon <paul.chaignon@gmail.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, andrii@kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, john.fastabend@gmail.com,
        kpsingh@kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, Paul Burton <paulburton@kernel.org>,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        luke.r.nels@gmail.com, bjorn@kernel.org, iii@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        "David S. Miller" <davem@davemloft.net>, udknight@gmail.com
Subject: Re: [PATCH bpf-next 0/7] Fix MAX_TAIL_CALL_CNT handling in eBPF JITs
Message-ID: <CAO5pjwTWrC0_dzTbTHFPSqDwA56aVH+4KFGVqdq8=ASs0MqZGQ@mail.gmail.com>
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 11:34:30AM +0200, Johan Almbladh wrote:
> A new test of tail call count limiting revealed that the interpreter
> did in fact allow up to MAX_TAIL_CALL_CNT + 1 tail calls, whereas the
> x86 JITs stopped at the intended MAX_TAIL_CALL_CNT. The interpreter was
> fixed in commit b61a28cf11d61f512172e673b8f8c4a6c789b425 ("bpf: Fix
> off-by-one in tail call count limiting"). This patch set fixes all
> arch-specific JITs except for RISC-V.

I'm a bit surprised by this because I had previously tested the tail
call limit of several JIT compilers and found it to be 33 (i.e.,
allowing chains of up to 34 programs). I've just extended a test program
I had to validate this again on the x86-64 JIT and found a limit of 33
tail calls again [1].

Also note we had previously changed the RISC-V and MIPS JITs to allow up
to 33 tail calls [2, 3], for consistency with other JITs and with the
interpreter. We had decided to increase these two to 33 rather than
decrease the other JITs to 32 for backward compatibility, though that
probably doesn't matter much as I'd expect few people to actually use 33
tail calls :-)

1 - https://github.com/pchaigno/tail-call-bench/commit/ae7887482985b4b1745c9b2ef7ff9ae506c82886
2 - 96bc4432 ("bpf, riscv: Limit to 33 tail calls")
3 - e49e6f6d ("bpf, mips: Limit to 33 tail calls")

>
> For each of the affected JITs, the incorrect behaviour was verified
> by running the test_bpf test suite in QEMU. After the fixes, the JITs
> pass the tail call count limiting test.

If you are referring to test_tailcall_3 and its associated BPF program
tailcall3, then as far as I can tell, it checks that 33 tail calls are
allowed. The counter is incremented before each tail call except the
first one. The last tail call is rejected because we reach the limit, so
a counter value of 33 (as checked in the test code) means we've
successfully executed 33 tail calls.

--
Paul

>
> I have not been able to test the RISC-V JITs due to the lack of a
> working toolchain and QEMU setup. It is likely that the RISC-V JITs
> have the off-by-one behaviour too. I have not verfied any of the NIC JITs.
>
> Link: https://lore.kernel.org/bpf/20210728164741.350370-1-johan.almbladh@anyfinetworks.com/
>
> Johan Almbladh (7):
>   arm: bpf: Fix off-by-one in tail call count limiting
>   arm64: bpf: Fix off-by-one in tail call count limiting
>   powerpc: bpf: Fix off-by-one in tail call count limiting
>   s390: bpf: Fix off-by-one in tail call count limiting
>   sparc: bpf: Fix off-by-one in tail call count limiting
>   mips: bpf: Fix off-by-one in tail call count limiting
>   x86: bpf: Fix comments on tail call count limiting
>
>  arch/arm/net/bpf_jit_32.c         | 6 +++---
>  arch/arm64/net/bpf_jit_comp.c     | 4 ++--
>  arch/mips/net/ebpf_jit.c          | 4 ++--
>  arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
>  arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
>  arch/s390/net/bpf_jit_comp.c      | 6 +++---
>  arch/sparc/net/bpf_jit_comp_64.c  | 2 +-
>  arch/x86/net/bpf_jit_comp32.c     | 6 +++---
>  8 files changed, 18 insertions(+), 18 deletions(-)
>
> --
> 2.25.1
>
