Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33A44C287
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 22:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFSUpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 16:45:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54230 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfFSUpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 16:45:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so837065wmj.3
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 13:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+cVbQuinB0gXdYIWimy8pDMGfWtqAQMswKhS2gmefNs=;
        b=qimQMr9WiUhbndQru7ZqwmUTbBW9gJTRFM9d5kEz/eez46p7AXBTh6+x6HssF7/4hW
         TNDihwMsKxGqX6MahMqgu29mANqmAOo+UW0ZZ8Oxy9Es0xfNxml84rvCZirTS4ODr7H6
         AAr2mNVbLJy0rxjfK/aB2Iugnq0WfR5zAjWDt9bb2TRLjOvvIbaXbZHebB9YFFQhOnEA
         9wyKxjerpEwpG8z7kZTGtmqGB/b5IvdwnA5M5LXvDz2nAcmZhzQ7A/3QLDmpMIbxQaBs
         Z0kQ9btfQebYuYHS0PL3qxFEszU4M7Fy77slGZ/tg+q+xxKPePF8w7LT8amycp0V055Z
         akSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=+cVbQuinB0gXdYIWimy8pDMGfWtqAQMswKhS2gmefNs=;
        b=mPVbLVlhARBqIeRbJQ1cN/crwhPE84G8ulAsV5WKD0btnMmXiOuKCGcz/CF8gdrOWE
         eHl1cyo5f70cL8MaMW5DDe0hIkxY4ce9o14TbSD3+rQkD4xSnziFfGk1OPhCkFMLPOdI
         TPLTG4fHB5wPnrR6NvgWjpAlEbz8Fo/TDsgGDEP3dyoR0tMm0yBnBgxbkYOyJR1hFjXD
         Me53Bsp6VRcyAd2EIMfk0EmOkiiPH2K2vvMAcUwPz3GsL2XYKTkoY8fodCNLLXGGD5A1
         h7erWgTNVslE/JtiYU9xWBgotcerYl3d4o2X6JAEuaRcMAngjbrdp3FFaArRClxc0Vq5
         1aTg==
X-Gm-Message-State: APjAAAUikX8b8ul+Ti+/P3XOTfgdsCX/+sDBUFZn35LS8hJXdzrZ5MVQ
        hHDH0mItYueFDpHspYVMGBVMVw==
X-Google-Smtp-Source: APXvYqy+vd6GbBZerEcvMwTL0G282UJ//9AwBhMYKMobXZqGiFj3357cHYRTSCwaOXqTpQmA2aHjUQ==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr10195899wmc.89.1560977128877;
        Wed, 19 Jun 2019 13:45:28 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id g10sm14179227wrw.60.2019.06.19.13.45.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 13:45:28 -0700 (PDT)
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com> <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com> <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com> <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com> <87ef3w5hew.fsf@netronome.com> <41dfe080-be03-3344-d279-e638a5a6168d@solarflare.com> <878su0geyt.fsf@netronome.com> <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com> <877e9kgd39.fsf@netronome.com> <f2a74aac-7350-8b35-236a-b17323bb79e6@solarflare.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
In-reply-to: <f2a74aac-7350-8b35-236a-b17323bb79e6@solarflare.com>
Date:   Wed, 19 Jun 2019 21:45:25 +0100
Message-ID: <87wohhxq1m.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Edward Cree writes:

> On 17/06/2019 21:40, Jiong Wang wrote:
>> Now if we don't split patch when patch an insn inside patch, instead, if we
>> replace the patched insn using what you suggested, then the logic looks to
>> me becomes even more complex, something like
>>
>>    for (idx = 0; idx < insn_cnt; idx++) {
>>      if (insns[idx] is not BPF_LIST_INSN) {
>>        do_insn(...)
>>      }
>>      else if (insns[idx] is BPF_LIST_INSN) {
>>        list = pool_base + insn.imm;
>>        while (list) {
>>          insn = list_head->insn;
>>          if (insn is BF_LIST_INSN) {
>>            sub_list = ...
>>            while ()
>>              do_insn()
>>            continue;
>>          }
>>          do_insn(...)
>>          list = pool_base + list->next;
>>        }
>>      }
>>    }
> Why can't do_insn() just go like:
>     if (insn is BPF_LIST_INSN)
>         for (idx = 0; idx < LIST_COUNT(insn); idx++)
>             do_insn(pool_base + LIST_START(insn) + idx);
>     else
>         rest of processing
> ?
>
> Alternatively, iterate with something more sophisticated than 'idx++'
>  (standard recursion-to-loop transformation).
> You shouldn't ever need a for() tower statically in the code...

I don't think this changes things much, the point is we still have two data
structures for insns, array + list, so I fell you anyway need some tweak on
existing traverse code while using singly linked list incurs very little
changes, for example:

  for (i = 0; i < insn_cnt; i++, insn++) {

  =>

  for (elem = list; elem; elem = elem->next) {
    insn = elem->insn;

>> So, I am thinking what Alexei and Andrii suggested make sense, just use
>> single data structure (singly linked list) to represent everything, so the
>> insn traversal etc could be simple
> But then you have to also store orig_insn_idx with each insn, so you can
>  calculate the new jump offsets when you linearise.  Having an array of
>  patched_orig_insns gives you that for free.

For pool based list, you don't need to store orig_insn_idx, those orig ones
are guaranteed at the bottom of the pool, so just use index < orig_prog_len
then you could know it is the orig insn. And for both pool and non-pool
based list, the order of orig node in the list is the same as in array, so
it quite easy to calculate the orig index as a by-product inside insn copy
traverse, for non-pool base list, each node needs at least one bit to
indicate it is orig node. I also found when patching a patched buffer which
contains jmp insn is an issue (need to double check to see if there is such
case), because then we will need to record the jump destination index of
the jmp insn when it was inserted.

And some updates on my side, did some benchmarking on both pool and
non-pool based list.

Patching time (ns) benchmarked using JIT blinding
===

                    existing    non-pool      pool

"scale test 1"      no stop    ~0x1c600000  ~0x8800000
Bench(~3.4K insns)  ~0xc50000  ~0xf1000     ~6b000

(The non-pool means kmalloc a list node for each patch snippet, pool means
vmalloc a big chunk of mem and allocate node from it, node is located using
pool_base + index)

For "scale test 1" which contains ~1M JIT blindable insns, using list based
infra for patching could reduce most of the patching time, and pool based
alloc only consumes 1/3 time of non-pool.

And for a normal program with reasonable size (~3.4K), pool based alloc
only consumes 1/30 time of exsisting infra, and 1/2.3 of non-pool.

On the other hand, non-pool based implementation is cleaner and less error
prone than pool based implementation.

And for both pool and non-pool, I got the following kernel warning when
running "scale test 11" (perhaps needs 3M * 16 ~= 48M mem)

[   92.319792] WARNING: CPU: 6 PID: 2322 at mm/page_alloc.c:4639 __alloc_pages_nodemask+0x29e/0x330

I am finishing aux adjust and code delete support.

Regards,
Jiong
