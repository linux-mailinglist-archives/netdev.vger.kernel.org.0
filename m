Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF823199B6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 10:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfEJIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 04:30:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52330 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfEJIae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 04:30:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id g26so4583312wmh.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 01:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=F/Td0eaPxnoNbOJZCgHxw/HETg5Y69oytcbCTXlZk6c=;
        b=irB2mahgIGo5kC78hREMdMIFF9prezeGby843hv3d0Le4YOBq/Z03SeHabmdSwjJGt
         yIiRspIg+1w6eyv32tvWsrCYj37ERS6uodECfMNlxxaDZJJXJUF3LVZyzEM7WsNsedJE
         FoAVlBQdzDNrayLnJh+FqDBFVIz0OC5Y4dR5/1+J+FLB5vVJk6ZWY7wC8u1m1bo1kN/F
         hRef2oXkH1xXQsXybxF24e66zSJzjm4WhbjY27VcPkRfUEp36cEvFFs+hfx/AEff42RO
         /VBQTbw6iHXorT9h3oqI4NczGUWh8dEnk1xd70VxIKm67DrLyZdTrepZA+inhe5b/mNc
         lYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=F/Td0eaPxnoNbOJZCgHxw/HETg5Y69oytcbCTXlZk6c=;
        b=N6AZTNtCs6WtAlAfD5kNl9ybQPd84cLLMakhkZCLFuHSLzjwxCoKCh7j90u1ntndbP
         owCJgrUyppk55Jd86Wj+MRmDt6fPhZ0Emn7yXXyujzZpwnDr56nWEMC1K1ErsqIy2b4p
         1aJwRc4gWjkhWSK7sdCUM3FKnv4K2Tu/QkyuiAmlOdljV4PpG4euRFBiviEYgwus3vR0
         sjX1FDVeAKLbVOyRp4VrblX4f05AxfN5Bam8PuUrb4fs61/tOe+bE21IPYkTcNEpRqAS
         ax8ScSiPsIRPumvv6hz+4vhhVieZItXIBCytg0QAgHqv12lvqv5uMAfQGL8VOPn6zwNx
         XGYA==
X-Gm-Message-State: APjAAAVd9vFzzuVge3OrQ4bmqRHKpSSL7n7amcQyOCBKKsAvqpkmyI1C
        4f3njetZgWP6Vit2JvG+zpJLwQ==
X-Google-Smtp-Source: APXvYqyn5vK8d1moEggp5eYhIUDKJAPB5lYOXwzQ5Rebexk4x9l+zyF0nIEK30U7xtlZGnenHEHxsg==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr5929468wmc.137.1557477032305;
        Fri, 10 May 2019 01:30:32 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id 17sm5446355wrk.91.2019.05.10.01.30.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 01:30:31 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-2-git-send-email-jiong.wang@netronome.com> <20190506155041.ofxsvozqza6xrjep@ast-mbp> <87mujx6m4n.fsf@netronome.com> <20190508175111.hcbufw22mbksbpca@ast-mbp> <87ef5795b5.fsf@netronome.com> <20190510015352.6w6fghcthtjj74pl@ast-mbp>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
In-reply-to: <20190510015352.6w6fghcthtjj74pl@ast-mbp>
Date:   Fri, 10 May 2019 09:30:28 +0100
Message-ID: <87sgtmk8yj.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Thu, May 09, 2019 at 01:32:30PM +0100, Jiong Wang wrote:
>> 
>> Alexei Starovoitov writes:
>> 
>> > On Wed, May 08, 2019 at 03:45:12PM +0100, Jiong Wang wrote:
>> >> 
>> >> I might be misunderstanding your points, please just shout if I am wrong.
>> >> 
>> >> Suppose the following BPF code:
>> >> 
>> >>   unsigned helper(unsigned long long, unsigned long long);
>> >>   unsigned long long test(unsigned *a, unsigned int c)
>> >>   {
>> >>     unsigned int b = *a;
>> >>     c += 10;
>> >>     return helper(b, c);
>> >>   }
>> >> 
>> >> We get the following instruction sequence by latest llvm
>> >> (-O2 -mattr=+alu32 -mcpu=v3)
>> >> 
>> >>   test:
>> >>     1: w1 = *(u32 *)(r1 + 0)
>> >>     2: w2 += 10
>> >>     3: call helper
>> >>     4: exit
>> >> 
>> >> Argument Types
>> >> ===
>> >> Now instruction 1 and 2 are sub-register defines, and instruction 3, the
>> >> call, use them implicitly.
>> >> 
>> >> Without the introduction of the new ARG_CONST_SIZE32 and
>> >> ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
>> >> w2, zero-extend them should be fine for all cases, but could resulting in a
>> >> few unnecessary zero-extension inserted.
>> >
>> > I don't think we're on the same page.
>> > The argument type is _const_.
>> > In the example above they are not _const_.
>> 
>> Right, have read check_func_arg + check_helper_mem_access again.
>> 
>> Looks like ARG_CONST_SIZE* are designed for describing memory access size
>> for things like bounds checking. It must be a constant for stack access,
>> otherwise prog will be rejected, but it looks to me variables are allowed
>> for pkt/map access.
>> 
>> But pkt/map has extra range info. So, indeed, ARG_CONST_SIZE32* are
>> unnecessary, the width could be figured out through the range.
>> 
>> Will just drop this patch in next version.
>> 
>> And sorry for repeating it again, I am still concerned on the issue
>> described at https://www.spinics.net/lists/netdev/msg568678.html.
>> 
>> To be simple, zext insertion is based on eBPF ISA and assumes all
>> sub-register defines from alu32 or narrow loads need it if the underlying
>
> It's not an assumption. It's a requirement. If JIT is not zeroing
> upper 32-bits after 32-bit alu or narrow load it's a bug.
>
>> hardware arches don't do it. However, some arches support hardware zext
>> partially. For example, PowerPC, SPARC etc are 64-bit arches, while they
>> don't do hardware zext on alu32, they do it for narrow loads. And RISCV is
>> even more special, some alu32 has hardware zext, some don't.
>> 
>> At the moment we have single backend hook "bpf_jit_hardware_zext", once a
>> backend enable it, verifier just insert zero extension for all identified
>> alu32 and narrow loads.
>> 
>> Given verifier analysis info is not pushed down to JIT back-ends, verifier
>> needs more back-end info pushed up from back-ends. Do you think make sense
>> to introduce another hook "bpf_jit_hardware_zext_narrow_load" to at least
>> prevent unnecessary zext inserted for narrowed loads for arches like
>> PowerPC, SPARC?
>> 
>> The hooks to control verifier zext insertion then becomes two:
>> 
>>   bpf_jit_hardware_zext_alu32
>>   bpf_jit_hardware_zext_narrow_load
>
> and what to do with other combinations?
> Like in some cases narrow load on particular arch will be zero extended
> by hw and if it's misaligned or some other condition then it will not be? 
> It doesn't feel that we can enumerate all such combinations.

Yes, and above narrow_load is just an example. As mentioned, behaviour on
alu32 also diverse on some arches.

> It feels 'bpf_jit_hardware_zext' backend hook isn't quite working.

It is still useful for x86_64 and aarch64 to disable verifier insertion
pass completely. But then perhaps should be renamed into
"bpf_jit_verifier_zext". Returning false means verifier should disable the
insertion completely.

> It optimizes out some zext, but may be adding unnecessary extra zexts.

This is exactly my concern.

> May be it should be a global flag from the verifier unidirectional to JITs
> that will say "the verifier inserted MOV32 where necessary. JIT doesn't
> need to do zext manually".
> And then JITs will remove MOV32 when hw does it automatically.
> Removal should be easy, since such insn will be right after corresponding
> alu32 or narrow load.

OK, so you mean do a simple peephole to combine insns. JIT looks forward
the next insn, if it is mov32 with dst_src == src_reg, then skip it. And
only do this when jitting a sub-register write eBPF insn and there is
hardware zext support.

I guess such special mov32 won't be generated by compiler that it won't be
jump destination hence skip it is safe.

For zero extension insertion part of this set, I am going to do the
following changes in next version:

  1. verifier inserts special "mov32" (dst_reg == src_reg) as "zext".
     JIT could still save zext for the other "mov32", but should always do
     zext for this special "mov32".
  2. rename 'bpf_jit_hardware_zext' to 'bpf_jit_verifier_zext' which
     returns false at default to disable zext insertion.
  3. JITs want verifier zext override bpf_jit_verifier_zext to return
     true and should skip unnecessary mov32 as described above.

Looks good?

Regards,
Jiong


