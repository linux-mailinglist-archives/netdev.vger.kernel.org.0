Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA76F46240
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfFNPNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:13:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40635 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNPNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:13:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so2684698wmj.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 08:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=8/UkoEae7i35+WwGcIqNoyF5fpe7RMTBxaaVX9AwVQ8=;
        b=NHsBf+N0llByJ7gXzP+jLIyOpPvVs94SOS9TniPZBF6CahVQFef/IwB6cg0BItEqQF
         acr9/bpEp14zxvrHKsXkR+/3t7njEHIxmU4GV1dx9VPqgYpZvFAxcOQ7zqwUltzUzCre
         avlXc88Nc0/fmXW4WBrh2FEjVMKCH++F6nwKm5Yys4kL1EMFAkp6s0N+clhPWuDqIO9W
         CV2HQ6Aw0Ln4GVMGjYGC0lpHGmh09xwhKKeCi0GfSW8xHGbkN+DDtBANDyc3QGeM7prb
         gqBwbS6+JXihGKv1843xLHlLTvRtMei2P8SKnzWUv7zJyjAcm/rQ6tRyxCn1JlqIDw76
         mG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=8/UkoEae7i35+WwGcIqNoyF5fpe7RMTBxaaVX9AwVQ8=;
        b=ECWcQ6lbfrZYaz97ZcWsTYhDmRaTcRwvRtPUMghH0W+ZpjM+mg4F/WO/Aru5sxzuXx
         nNB8pvzya0g9N+mn6Tcdclvwuy2/1c2M9TMi3QHam1LGU/mUrTLUBpP+ktwapDVOxZZy
         BSXgGbZo+RvBRV+SpbQOAtmWG/lNWt3ltZZO+Hp4HcgGjm40rnTMfYKBxxwV+xbChfWQ
         scINC7b2o/hd4IjF06qLhLD4+DtBcJ4g03IIehu3VAcijhlrAL80TIoOZ37r36vpf42P
         rxfLXTR1ou+07JLKvfZ6nrf6jczE+cw/Z7QB6JL7zdk377u5E7iDMFYhHDSupKqy2URC
         KmDQ==
X-Gm-Message-State: APjAAAW+it2hq/h453RyyaO8tuXyftaUvqHlv25x936f9/SW7PtS6WF9
        g6djk9Zt1Xb4TuBIEs1Q4cxUAg==
X-Google-Smtp-Source: APXvYqzO0Y1Xc0cWXQQTj1NLGVpnm0jynKsbHiTBiCKXTUMaWxMSRMd5vD+H3ZsqxxKtIrIedkn6rA==
X-Received: by 2002:a1c:3b45:: with SMTP id i66mr8746314wma.48.1560525209702;
        Fri, 14 Jun 2019 08:13:29 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id j4sm2024717wrx.57.2019.06.14.08.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Jun 2019 08:13:28 -0700 (PDT)
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com> <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com> <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com> <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
In-reply-to: <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
Date:   Fri, 14 Jun 2019 16:13:27 +0100
Message-ID: <87ef3w5hew.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexei Starovoitov writes:

> On Wed, Jun 12, 2019 at 8:25 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>>
>> Jiong Wang writes:
>>
>> > Alexei Starovoitov writes:
>> >
>> >> On Wed, Jun 12, 2019 at 4:32 AM Naveen N. Rao
>> >> <naveen.n.rao@linux.vnet.ibm.com> wrote:
>> >>>
>> >>> Currently, for constant blinding, we re-allocate the bpf program to
>> >>> account for its new size and adjust all branches to accommodate the
>> >>> same, for each BPF instruction that needs constant blinding. This is
>> >>> inefficient and can lead to soft lockup with sufficiently large
>> >>> programs, such as the new verifier scalability test (ld_dw: xor
>> >>> semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)
>> >>
>> >> Slowdown you see is due to patch_insn right?
>> >> In such case I prefer to fix the scaling issue of patch_insn instead.
>> >> This specific fix for blinding only is not addressing the core of the problem.
>> >> Jiong,
>> >> how is the progress on fixing patch_insn?
>>
>> And what I have done is I have digested your conversion with Edward, and is
>> slightly incline to the BB based approach as it also exposes the inserted
>> insn to later pass in a natural way, then was trying to find a way that
>> could create BB info in little extra code based on current verifier code,
>> for example as a side effect of check_subprogs which is doing two insn
>> traversal already. (I had some such code before in the historical
>> wip/bpf-loop-detection branch, but feel it might be still too heavy for
>> just improving insn patching)
>
> BB - basic block?
> I'm not sure that was necessary.
> The idea was that patching is adding stuff to linked list instead
> and single pass at the end to linearize it.

Just an update and keep people posted.

Working on linked list based approach, the implementation looks like the
following, mostly a combine of discussions happened and Naveen's patch,
please feel free to comment.

  - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
    BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).

  - Introduce patch pool into bpf_prog->aux to keep all patched insns.
    Pool structure looks like:

    struct {
      int num;
      int prev;
      int next;
    } head_0;
    NUM patched insns for head_0
    head_1;
    patched insns for head_1
    head_2;
    ...

  - Now when doing bpf_patch_insn_single, it doesn't change the original
    prog etc, instead, it merely update the insn at patched offset into a
    BPF_LIST_INSN, and pushed the patched insns plus a patch header into
    the patch pool. Fields of BPF_LIST_INSN is updated to setup the links:
    
      BPF_LIST_INSN.off += patched_size
      (accumulating the size attached to this list_insn, it is possible a
      later patch pass patches insn in the patch pool, this means insn
      traversal needs to be changed, when seeing BPF_LIST_INSN, should go
      through the list)
      
      BPF_LIST_INSN.imm = offset of the patch header in patch pool
      (off is 16-bit, imm is 32-bit, the patch pool is 32-bit length, so
      use imm for keeping offset, meaning a BPF_LIST_INSN can contains no
      more than 8192 insns, guess it is enough)

  - When doing linearize:
    1. a quick scan of prog->insnsi to know the final
       image size, would be simple as:

      fini_size = 0;
      for_each_insn:
        if (insn.code == (BPF_ALU | BPF_LIST_HEAD))
          fini_size += insn->off;
        else
          fini_size++;

    2. Resize prog into fini_size, and a second scan of prog->insnsi to
       copy over all insns and patched insns, at the same time generate a
       auxiliary index array which maps an old index to the new index in
       final image, like the "clone_index" in Naveen's patch.

    3. Finally, a single pass to update branch target, the same algo used
       by this patch.
       
  - The APIs for doing insning patch looks like:
      bpf_patch_insn_init:   init the generic patch pool.
      bpf_patch_insn_single: push patched insns to the pool.
                             link them to the associated BPF_LIST_INSN.
      bpf_patch_insn_fini:   linearize a bpf_prog contains BPF_LIST_INSN.
                             destroy patch pool in prog->aux.

I am trying to making the implementation working with jit blind first to make
sure basic things are ready. As JIT blinds happens after verification so no
need to both aux update etc. Then will cleanup quite a few things for
example patch a patched insn, adjust aux data, what to do with insn delete
etc.

Regards,
Jiong
