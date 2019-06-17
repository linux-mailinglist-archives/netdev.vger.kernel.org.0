Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9F4918D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfFQUkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:40:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39759 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFQUkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:40:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so11464817wrt.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 13:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qJNOR205RRS/cpQqB2DVQekqXUcpwR647q7Hv5JeF88=;
        b=i8dDfSO2Hnnu+gqFq0hXcLDe18Y5Nubwhadkdf1GaxExf/C2tJ3FxbakJxKML/0PAa
         DKTpEKblqal3HJS7ctu3jyet5OJOPAzhAcVfvrCEW9uRPHZacQeZG4AbAes9WyKYGrG7
         wD+Arw4TrcCWV4D8YTy+qE7xBHen0FeuB6pCsJyTDF2IZFkuwnx7WOHRzalbxFsLjtwW
         uUNZgPA06adawv33GMIkUYmRZw2RpO4unUzy8GuhllUH5+36nRqy3pfZc1ukqKVwtLmY
         IuntzFidOGy7bCJ2N0QoMMALFJ8Odt+B+c34PVHJpbBRJgrc2xI6tW0OT/X9OCSljoOW
         IISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=qJNOR205RRS/cpQqB2DVQekqXUcpwR647q7Hv5JeF88=;
        b=jsru0eZIZWhtuOiu5LZcqFWp0aFGFwt1CVNhsBrbB6wAVGq0C+4KIx8Rw0cvi8ehrI
         sy7gJqxsD0e9sE2RktbJj19VCZWTFGB2jKnTeWNO75hMBBwd+5SxMX2nmmEGUuEGxeFF
         3gdGzxTdk/rkCJ0k6TU5EMCaCoB28LmhfEJoq4gncJdpTlmOPVJa6k5hczbKwhvICyp8
         d6cl9aKP0xA3a0d+itg8AnlmTfQGHzNCPyRv6wdFAwbW8q4b4VDJpk7c7w/fMmbHbmMY
         0gnIXWvsJp3V0nHzb33LBuJ1khoGPU+JuB8cwuVgHGOYiFrLPZUmBrpd+Xi1j8UqBj+Y
         c38w==
X-Gm-Message-State: APjAAAUldDuErPRJY+Ubp2m90Pwzli917b9Xk8hUbPyl+vQAEYGQdaqB
        Wnakv65Uo34C+c9XhTSGZlCdwA==
X-Google-Smtp-Source: APXvYqxdUeO14TqWL8bysVaLeeQM9hs9Dikoq2vDyhK9XBADrMx55LbEtXUzyRCMip9Dp1UuASK2xg==
X-Received: by 2002:adf:fb81:: with SMTP id a1mr5748605wrr.329.1560804028234;
        Mon, 17 Jun 2019 13:40:28 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id f1sm244407wml.28.2019.06.17.13.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 13:40:27 -0700 (PDT)
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com> <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com> <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com> <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com> <87ef3w5hew.fsf@netronome.com> <41dfe080-be03-3344-d279-e638a5a6168d@solarflare.com> <878su0geyt.fsf@netronome.com> <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
In-reply-to: <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com>
Date:   Mon, 17 Jun 2019 21:40:26 +0100
Message-ID: <877e9kgd39.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Edward Cree writes:

> On 17/06/2019 20:59, Jiong Wang wrote:
>> Edward Cree writes:
>>
>>> On 14/06/2019 16:13, Jiong Wang wrote:
>>>> Just an update and keep people posted.
>>>>
>>>> Working on linked list based approach, the implementation looks like the
>>>> following, mostly a combine of discussions happened and Naveen's patch,
>>>> please feel free to comment.
>>>>
>>>>   - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
>>>>     BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).
>>>>
>>>>   - Introduce patch pool into bpf_prog->aux to keep all patched insns.
>>> It's not clear to me what the point of the patch pool is, rather than just
>>>  doing the patch straight away. 
>> I used pool because I was thinking insn to be patched could be high
>> percentage, so doing lots of alloc call is going to be less efficient? so
>> allocate a big pool, and each time when creating new patch node, allocate
>> it from the pool directly. Node is addressed using pool_base + offset, each
>> node only need to keep offset.
> Good idea; but in that case it doesn't need to be a pool of patches (storing
>  their prev and next), just a pool of insns.  I.e. struct bpf_insn pool[many];
>  then in orig prog when patching an insn replace it with BPF_LIST_INSN.  If
>  we later decide to patch an insn within a patch, we can replace it (i.e. the
>  entry in bpf_insn_pool) with another BPF_LIST_INSN pointing to some later bit
>  of the pool, then we just have a little bit of recursion at linearise time.
> Does that work?

I feel it is not going to work well. What I have proposed initially is
something similar, except when we are patching an insn within a patch (do
exist, for example zext insertion will apply to some patched alu insn
inserted in ctx convert pass), then we split the patch, this then makes the
data structures used in two shapes,

1. original prog->insnsi is still maintained as array.
2. if one insn is BPF_LIST_INSN, then it is a list, and could traverse it
using pool_base + insn.imm = list head.

But then there is data structure inconsistent, so now when doing insn
traversal we need something like:
   for (idx = 0; idx < insn_cnt; idx++) {
     if (insns[idx] is not BPF_LIST_INSN) {
       do_insn(...)
     }
     else if (insns[idx] is BPF_LIST_INSN) {
       list = pool_base + insn.imm;
       while (list) {
         insn = list_head->insn;
         do_insn(...)
         list = pool_base + list->next;
       }
     }
   }

Code logic inside convert_ctx_accesses/fixup_bpf_call etc needs to be
re-factored out into a separate function do_NNN so it could be called
in above logic.

Now if we don't split patch when patch an insn inside patch, instead, if we
replace the patched insn using what you suggested, then the logic looks to
me becomes even more complex, something like

   for (idx = 0; idx < insn_cnt; idx++) {
     if (insns[idx] is not BPF_LIST_INSN) {
       do_insn(...)
     }
     else if (insns[idx] is BPF_LIST_INSN) {
       list = pool_base + insn.imm;
       while (list) {
         insn = list_head->insn;
         if (insn is BF_LIST_INSN) {
           sub_list = ...
           while ()
             do_insn()
           continue;
         }
         do_insn(...)
         list = pool_base + list->next;
       }
     }
   }

So, I am thinking what Alexei and Andrii suggested make sense, just use
single data structure (singly linked list) to represent everything, so the
insn traversal etc could be simple, but I am considering it is better to
still base the list on top of the pool infrastructure mentioned?

I have somethingn like the following:

+struct bpf_list_insn {
+       struct bpf_insn insn;
+       u32 next;
+};

struct bpf_prog_aux {:

+       struct {
+               struct bpf_list_insn *pool;
+               u32 size;
+               u32 used;
+       };

Whenever you want to do intensive patching work you could call
bpf_patch_init to setup the pool, the setup including:
  1. convert the original prog->insnsi into a list of bpf_list_insn.
     next is index into the pool, so for those initial insnsi, they are
     1, 2, 3, 4, 5, ...

Then when doing patching, just allocate new slot from the pool, and link
them into the list.

When patching finished call bpf_patch_fini to do lineraize, could use the
same algo in Navee's patch.

After digest Alexei and Andrii's reply, I still don't see the need to turn
branch target into list, and I am not sure whether pool based list sound
good? it saves size, resize pool doesn't invalid allocated node (the offset
doesn't change) but requires one extra addition to calculate the pointer.

>
> -Ed

