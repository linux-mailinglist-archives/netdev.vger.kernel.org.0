Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F320B1A3BA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfEJUK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:10:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42692 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbfEJUK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:10:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id x15so3300897pln.9;
        Fri, 10 May 2019 13:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i4h14BBQCJLlYpvpcu+Zn9tsZCRloleW70xMfOdbC2o=;
        b=NG0aIPlz/n6QjSF83hiBoWSrRbcweB8TD5rppel3lVwB4O9ZkUoT0XuCig3pPI+TrW
         6O5HlPhP2UYO6cowy5k29mLfD16Az1Idic3lpIDST1dDv0cxiVx7Lksq5INftWhVGmQS
         2NoEBWVOJRM28ZYNW2LQ8OP0YvpiXon9GLclhsrOqCv0qj+WEf7hX7JNYjSrWmbhR5kq
         +lQ+lDCE7QLhJynr9UoVOWrFylyukcuFnVZeCzuOkI2JLAijgucL7JzMBBHyU2sPUEFv
         YrpB+HDJowHkwUU6IHP8/JF4AkA1qw5niAyHY9P26f5ZBQQ3xLOISynxsWwREoL6+cI7
         reTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i4h14BBQCJLlYpvpcu+Zn9tsZCRloleW70xMfOdbC2o=;
        b=ptRPmK88+wzvpUnyqZC5O4KRUFBrbcbYeGH22/SQuuIPEPxxpti0irxnC6PUETj1kX
         gzpxr8TYrsRnyobfr0tJckNfySSr7mjHmG/TLtFkEdpRYZvx3mwhfTrV2oOiUEBbd5Zs
         kn6WLoUf0m6BjTOanyH7Ydz7w+aVPYRwKp6zUxfmXaZJFwyzH0G4RRsqORrNxb6HVVSM
         6IIU7Y9bmOQrOHYfw2mDgraGfTh5h06/twLCnR6SYZEtbvJJdSf5X14oWg/vK2Pj/hsr
         RAHZ9yJ/UcZZhQZ4mXNivrmnJxr71OaG20YIbzXaBQzdtOvmjR2kYeN7ycFYRQ+PNVAd
         5Y+g==
X-Gm-Message-State: APjAAAVtQcqILKoELNYvxArm+v7eiOeK7SwOBsUhnrTCbAa1d7gIX2Iu
        k7LPM6krwqLYbUYYzVApRaM=
X-Google-Smtp-Source: APXvYqz0TQGgDb2wh1TNnVOuQBVV6MQeCCOYp5QERcqew2gYx4cvjDHeDBK51Dehjz40xIrZdh0YPw==
X-Received: by 2002:a17:902:e091:: with SMTP id cb17mr15314972plb.222.1557519028196;
        Fri, 10 May 2019 13:10:28 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::730f])
        by smtp.gmail.com with ESMTPSA id j6sm7481513pfe.107.2019.05.10.13.10.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 13:10:27 -0700 (PDT)
Date:   Fri, 10 May 2019 13:10:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate
 helper function arg and return type
Message-ID: <20190510201022.63wqdqxljahguzk3@ast-mbp>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
 <20190506155041.ofxsvozqza6xrjep@ast-mbp>
 <87mujx6m4n.fsf@netronome.com>
 <20190508175111.hcbufw22mbksbpca@ast-mbp>
 <87ef5795b5.fsf@netronome.com>
 <20190510015352.6w6fghcthtjj74pl@ast-mbp>
 <87sgtmk8yj.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgtmk8yj.fsf@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 09:30:28AM +0100, Jiong Wang wrote:
> 
> Alexei Starovoitov writes:
> 
> > On Thu, May 09, 2019 at 01:32:30PM +0100, Jiong Wang wrote:
> >> 
> >> Alexei Starovoitov writes:
> >> 
> >> > On Wed, May 08, 2019 at 03:45:12PM +0100, Jiong Wang wrote:
> >> >> 
> >> >> I might be misunderstanding your points, please just shout if I am wrong.
> >> >> 
> >> >> Suppose the following BPF code:
> >> >> 
> >> >>   unsigned helper(unsigned long long, unsigned long long);
> >> >>   unsigned long long test(unsigned *a, unsigned int c)
> >> >>   {
> >> >>     unsigned int b = *a;
> >> >>     c += 10;
> >> >>     return helper(b, c);
> >> >>   }
> >> >> 
> >> >> We get the following instruction sequence by latest llvm
> >> >> (-O2 -mattr=+alu32 -mcpu=v3)
> >> >> 
> >> >>   test:
> >> >>     1: w1 = *(u32 *)(r1 + 0)
> >> >>     2: w2 += 10
> >> >>     3: call helper
> >> >>     4: exit
> >> >> 
> >> >> Argument Types
> >> >> ===
> >> >> Now instruction 1 and 2 are sub-register defines, and instruction 3, the
> >> >> call, use them implicitly.
> >> >> 
> >> >> Without the introduction of the new ARG_CONST_SIZE32 and
> >> >> ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
> >> >> w2, zero-extend them should be fine for all cases, but could resulting in a
> >> >> few unnecessary zero-extension inserted.
> >> >
> >> > I don't think we're on the same page.
> >> > The argument type is _const_.
> >> > In the example above they are not _const_.
> >> 
> >> Right, have read check_func_arg + check_helper_mem_access again.
> >> 
> >> Looks like ARG_CONST_SIZE* are designed for describing memory access size
> >> for things like bounds checking. It must be a constant for stack access,
> >> otherwise prog will be rejected, but it looks to me variables are allowed
> >> for pkt/map access.
> >> 
> >> But pkt/map has extra range info. So, indeed, ARG_CONST_SIZE32* are
> >> unnecessary, the width could be figured out through the range.
> >> 
> >> Will just drop this patch in next version.
> >> 
> >> And sorry for repeating it again, I am still concerned on the issue
> >> described at https://www.spinics.net/lists/netdev/msg568678.html.
> >> 
> >> To be simple, zext insertion is based on eBPF ISA and assumes all
> >> sub-register defines from alu32 or narrow loads need it if the underlying
> >
> > It's not an assumption. It's a requirement. If JIT is not zeroing
> > upper 32-bits after 32-bit alu or narrow load it's a bug.
> >
> >> hardware arches don't do it. However, some arches support hardware zext
> >> partially. For example, PowerPC, SPARC etc are 64-bit arches, while they
> >> don't do hardware zext on alu32, they do it for narrow loads. And RISCV is
> >> even more special, some alu32 has hardware zext, some don't.
> >> 
> >> At the moment we have single backend hook "bpf_jit_hardware_zext", once a
> >> backend enable it, verifier just insert zero extension for all identified
> >> alu32 and narrow loads.
> >> 
> >> Given verifier analysis info is not pushed down to JIT back-ends, verifier
> >> needs more back-end info pushed up from back-ends. Do you think make sense
> >> to introduce another hook "bpf_jit_hardware_zext_narrow_load" to at least
> >> prevent unnecessary zext inserted for narrowed loads for arches like
> >> PowerPC, SPARC?
> >> 
> >> The hooks to control verifier zext insertion then becomes two:
> >> 
> >>   bpf_jit_hardware_zext_alu32
> >>   bpf_jit_hardware_zext_narrow_load
> >
> > and what to do with other combinations?
> > Like in some cases narrow load on particular arch will be zero extended
> > by hw and if it's misaligned or some other condition then it will not be? 
> > It doesn't feel that we can enumerate all such combinations.
> 
> Yes, and above narrow_load is just an example. As mentioned, behaviour on
> alu32 also diverse on some arches.
> 
> > It feels 'bpf_jit_hardware_zext' backend hook isn't quite working.
> 
> It is still useful for x86_64 and aarch64 to disable verifier insertion
> pass completely. But then perhaps should be renamed into
> "bpf_jit_verifier_zext". Returning false means verifier should disable the
> insertion completely.

I think the name is too cryptic.
May be call it bpf_jit_needs_zext ?
x64/arm64 will set it false and the rest to true ?

> > It optimizes out some zext, but may be adding unnecessary extra zexts.
> 
> This is exactly my concern.
> 
> > May be it should be a global flag from the verifier unidirectional to JITs
> > that will say "the verifier inserted MOV32 where necessary. JIT doesn't
> > need to do zext manually".
> > And then JITs will remove MOV32 when hw does it automatically.
> > Removal should be easy, since such insn will be right after corresponding
> > alu32 or narrow load.
> 
> OK, so you mean do a simple peephole to combine insns. JIT looks forward
> the next insn, if it is mov32 with dst_src == src_reg, then skip it. And
> only do this when jitting a sub-register write eBPF insn and there is
> hardware zext support.
> 
> I guess such special mov32 won't be generated by compiler that it won't be
> jump destination hence skip it is safe.
> 
> For zero extension insertion part of this set, I am going to do the
> following changes in next version:
> 
>   1. verifier inserts special "mov32" (dst_reg == src_reg) as "zext".
>      JIT could still save zext for the other "mov32", but should always do
>      zext for this special "mov32".

May be used mov32 with imm==1 as indicator that such mov32 is special?

>   2. rename 'bpf_jit_hardware_zext' to 'bpf_jit_verifier_zext' which
>      returns false at default to disable zext insertion.
>   3. JITs want verifier zext override bpf_jit_verifier_zext to return
>      true and should skip unnecessary mov32 as described above.
> 
> Looks good?

Kinda makes sense, but when x64/arm64 are saying 'dont do zext'
what verifier suppose to do? It will still do the analysis
and liveness marks, but only mov32 won't be inserted?
I guess that's fine, since BPF_F_TEST_RND_HI32 will use
the results of the analysis?
Please double check that BPF_F_TEST_RND_HI32 poisoning works on
32-bit archs too.

