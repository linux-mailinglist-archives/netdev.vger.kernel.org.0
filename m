Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74743A8BFC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 00:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFOWrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 18:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOWrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 18:47:00 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87437C061574;
        Tue, 15 Jun 2021 15:44:54 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a11so298332wrt.13;
        Tue, 15 Jun 2021 15:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:message-id:in-reply-to:references:date:subject;
        bh=yAsKDxu4OsJzll8QC5S0Yfmf14kqjw1ys0j1yn9M9SA=;
        b=HS0GT+xpHXhIKqjwQv9QddnB8DnaaY421+5pdBr2Y0YekywQ+WjECT1LtO5VxGjLkU
         FXXVSEnPu2QAu2ACeEoiFOFFkXTmjPkWkhzQjGoBjHxi3h+F+uoLhWigpA2J2Dp0ph24
         JqSADk1f8oJaQcVtxqRuXmybcTSfflC/NRZVxuVMrEe6y3TTGIYHCZo+0GCtmF7SXzMx
         o4IEvD5W1C1WONjEUEJLXUm9joNBBb1/0xlKRk4GdCacQPQ+dcNz/5bCsel3BkPzXe1u
         +MoM0Fum5vjnBFjXNsxQ8pNiOKnRNK2TpMz6fU89cEiJQ31nvqVaeK4ovKedFbTgjnpK
         NDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:to:from:message-id:in-reply-to:references
         :date:subject;
        bh=yAsKDxu4OsJzll8QC5S0Yfmf14kqjw1ys0j1yn9M9SA=;
        b=h20UyP8YqGBMvl5s9JdTCsvPoTYfw+HSQFc6n9FtA/WKJxB5h5TAPJBVqZdRW+Ez4k
         UBKqB4/yzbAwBZWnxlTDPUsKO7jKwefhAXg7glCd55a95zallcy3m+RdqzguWnHimiZd
         oOF+4zeCSGxWQqUEbN/MV5ZDIaR+K0uvFkGuS6SseQJwrhoQLZ0AeTUAjcsCbnJUBPgZ
         aKnUhA4IyoNwX1z+8jXarWWWzb1agVKX3PmSBA80SZdLt/u8Kw4DU9KpzoCq1ZpalmHo
         QE+MhjYheu997Xj7mFV2n86obSZTat/crUHDQorw1MYotPfjL1ttQFdS95gAnrbHDLd2
         LROg==
X-Gm-Message-State: AOAM532QoW7QMGxZmthKiEwg/yZkJ4BZsXIxov4FnjHk/W9vz/sFFOXf
        I6viAvCzIwH8TFlcGdNfd7A=
X-Google-Smtp-Source: ABdhPJw/LSBqzOKIGod9rqRZwOqq4UUUOiHo8kr0tNW8SdyA1B5cSD8VfYghOxDTxcnfghCL1uiXaQ==
X-Received: by 2002:a5d:5585:: with SMTP id i5mr1483433wrv.371.1623797093202;
        Tue, 15 Jun 2021 15:44:53 -0700 (PDT)
Received: from localhost ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id t82sm139726wmf.22.2021.06.15.15.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 15:44:52 -0700 (PDT)
Cc:     ecree.xilinx@gmail.com,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        nathan@kernel.org, ndesaulniers@google.com,
        clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
To:     ebiggers@kernel.org, daniel@iogearbox.net
From:   "Kurt Manucredo" <fuzzybritches0@gmail.com>
Message-ID: <31138-26823-curtm@phaethon>
In-Reply-To: <YMkkr5G6E8lcFymG@gmail.com>
References: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
 <YMkAbNQiIBbhD7+P@gmail.com>
 <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
 <YMkcYn4dyZBY/ze+@gmail.com>
 <YMkdx1VB0i+fhjAY@gmail.com>
 <4713f6e9-2cfb-e2a6-c42d-b2a62f035bf2@iogearbox.net>
 <YMkkr5G6E8lcFymG@gmail.com>
Date:   Wed, 16 Jun 2021 00:31:49 +0200
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 15:07:43 -0700, Eric Biggers <ebiggers@kernel.org> wrote:
> 
> On Tue, Jun 15, 2021 at 11:54:41PM +0200, Daniel Borkmann wrote:
> > On 6/15/21 11:38 PM, Eric Biggers wrote:
> > > On Tue, Jun 15, 2021 at 02:32:18PM -0700, Eric Biggers wrote:
> > > > On Tue, Jun 15, 2021 at 11:08:18PM +0200, Daniel Borkmann wrote:
> > > > > On 6/15/21 9:33 PM, Eric Biggers wrote:
> > > > > > On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
> > > > > > > 
> > > > > > > As I understand it, the UBSAN report is coming from the eBPF interpreter,
> > > > > > >    which is the *slow path* and indeed on many production systems is
> > > > > > >    compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
> > > > > > > Perhaps a better approach to the fix would be to change the interpreter
> > > > > > >    to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
> > > > > > >    bitnesses), thus matching the behaviour of most chips' shift opcodes.
> > > > > > > This would shut up UBSAN, without affecting JIT code generation.
> > > > > > 
> > > > > > Yes, I suggested that last week
> > > > > > (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
> > > > > > get optimized out when compiling for most CPUs.
> > > > > 
> > > > > Did you check if the generated interpreter code for e.g. x86 is the same
> > > > > before/after with that?
> > > > 
> > > > Yes, on x86_64 with gcc 10.2.1, the disassembly of ___bpf_prog_run() is the same
> > > > both before and after (with UBSAN disabled).  Here is the patch I used:
> > > > 
> > > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > > index 5e31ee9f7512..996db8a1bbfb 100644
> > > > --- a/kernel/bpf/core.c
> > > > +++ b/kernel/bpf/core.c
> > > > @@ -1407,12 +1407,30 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
> > > >   		DST = (u32) DST OP (u32) IMM;	> > >   		CONT;
> > > > +	/*
> > > > +	 * Explicitly mask the shift amounts with 63 or 31 to avoid undefined
> > > > +	 * behavior.  Normally this won't affect the generated code.
> > 
> > The last one should probably be more specific in terms of 'normally', e.g. that
> > it is expected that the compiler is optimizing this away for archs like x86. Is
> > arm64 also covered by this ... do you happen to know on which archs this won't
> > be the case?
> > 
> > Additionally, I think such comment should probably be more clear in that it also
> > needs to give proper guidance to JIT authors that look at the interpreter code to
> > see what they need to implement, in other words, that they don't end up copying
> > an explicit AND instruction emission if not needed there.
> 
> Same result on arm64 with gcc 10.2.0.
> 
> On arm32 it is different, probably because the 64-bit shifts aren't native in
> that case.  I don't know about other architectures.  But there aren't many ways
> to implement shifts, and using just the low bits of the shift amount is the most
> logical way.
> 
> Please feel free to send out a patch with whatever comment you want.  The diff I
> gave was just an example and I am not an expert in BPF.
> 
> > 
> > > > +	 */
> > > > +#define ALU_SHIFT(OPCODE, OP)		> > > +	ALU64_##OPCODE##_X:		> > > +		DST = DST OP (SRC & 63);> > > +		CONT;			> > > +	ALU_##OPCODE##_X:		> > > +		DST = (u32) DST OP ((u32)SRC & 31);	> > > +		CONT;			> > > +	ALU64_##OPCODE##_K:		> > > +		DST = DST OP (IMM & 63);	> > > +		CONT;			> > > +	ALU_##OPCODE##_K:		> > > +		DST = (u32) DST OP ((u32)IMM & 31);	> > > +		CONT;
> > 
> > For the *_K cases these are explicitly rejected by the verifier already. Is this
> > required here nevertheless to suppress UBSAN false positive?
> > 
> 
> No, I just didn't know that these constants are never out of range.  Please feel
> free to send out a patch that does this properly.
> 
The shift-out-of-bounds on syzbot happens in ALU_##OPCODE##_X only. To
pass the syzbot test, only ALU_##OPCODE##_X needs to be guarded.

This old patch I tested on syzbot puts a check in all four.
https://syzkaller.appspot.com/text?tag=Patch&x=11f8cacbd00000

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

thanks,

kind regards

Kurt Manucredo
