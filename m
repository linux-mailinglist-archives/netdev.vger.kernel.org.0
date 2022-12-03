Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370DA64178B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLCPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 10:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCPhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 10:37:11 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9490F1F9CF;
        Sat,  3 Dec 2022 07:37:08 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 25FCEC01E; Sat,  3 Dec 2022 16:37:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670081836; bh=8+/C65NBDY0v0RW89Yk+KvRuOiE5ckvyFprjWMjz5YY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CW1cjt68c+e+aLbFm/Hd+zg5T723ITNKM4oL9pXH7tX/3qJy8/xBn7qsoseb3vUDz
         8vmAipTmn1kUqid6cLwGoeMRWWJZKpNx2v2j5auUttm6EmEkdkCCx3St2+6znHjPXI
         Yvu5CW2sZN1CvsLtrM+XGocyMiiHMDW5ABbyz5dI00XMxBGmVo3/AEvpHtmdz1wbcI
         yFy9clMPgVdFHJhYV4YoJ830ZLIe0Wiat3a1mKxxrsaijutklJ2Bc3opxH4NSw+F+w
         0V6l7K5Vo7KX6pz2qZntjYKtRJdYnT0zeLBDHaZKTUwJNdGny2PfCuxFQOjx5TWB+J
         0idfhT4O1u4Lw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2E939C009;
        Sat,  3 Dec 2022 16:37:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670081834; bh=8+/C65NBDY0v0RW89Yk+KvRuOiE5ckvyFprjWMjz5YY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=unUT9ds9jwb7N2eFG2l0ezPdfPT81KpA2/D1yP7SF/l5CMRgazxYY1QeentuSRybK
         SF5eh9B/w19EvVvhhfSNJtX4uE6BriBMdHqwjKZ9ehVhbBNrobwmaQ8staVrder6Ir
         13SGtmObM2ALaBCcPtWP9eK6kQFjEpcelWiEUTQbvvG9PINb2KLmvwOedOjHGMqQ4j
         w5C0ltVpOO5yH60WwwtSTq+x7R+ZssmBrnqYm/2f9Yb8yQJd7QMTZSwUkk4mOSsjRe
         t3sKZm5ISTokpMT4ttdsDNKUytQK2SeQnh7wLBvJQCtnS8lKC3MbHV+0/ilbBIRMuO
         GNpo4kKouoS6A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 2ef2e6a7;
        Sat, 3 Dec 2022 15:36:58 +0000 (UTC)
Date:   Sun, 4 Dec 2022 00:36:43 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Marco Elver <elver@google.com>, rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb /
 p9_client_rpc
Message-ID: <Y4ttC/qESg7Np9mR@codewreck.org>
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
 <Y4e3WC4UYtszfFBe@codewreck.org>
 <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(reply out of order)

Naresh Kamboju wrote on Thu, Dec 01, 2022 at 01:13:25PM +0530:
> > (You might need to build with at least CONFIG_DEBUG_INFO_REDUCED (or not
> > reduced), but that is on by default for aarch64)
> 
> Thanks for the suggestions.
> The Kconfig is enabled now.
> CONFIG_DEBUG_INFO_REDUCED=y

It looks enabled in your the config file you linked at, I don't
understand this remark?
Did you produce the trace the other day without it and rebuild the
kernel with it?
In this case you also have CONFIG_DEBUG_INFO_SPLIT set, so the vmlinux
file does not contain enough informations to retrieve line numbers or
types, and in particular addr2line cannot be used on the files you
provided.
I've never used split debug infos before, but digging old threads I'm
not too hopeful unless that changed:
https://lkml.iu.edu/hypermail/linux/kernel/1711.1/03393.html
https://sourceware.org/bugzilla/show_bug.cgi?id=22434

(...a test build later, it's still mostly useless...
normal build
$ ./scripts/faddr2line vmlinux __schedule+0x314
__schedule+0x314/0x6c0:
perf_fetch_caller_regs at include/linux/perf_event.h:1286
(inlined by) __perf_sw_event_sched at include/linux/perf_event.h:1307
(inlined by) perf_event_task_sched_out at include/linux/perf_event.h:1347
(inlined by) prepare_task_switch at kernel/sched/core.c:5053
(inlined by) context_switch at kernel/sched/core.c:5195
(inlined by) __schedule at kernel/sched/core.c:6561

split dwarf build
$ ./scripts/faddr2line vmlinux __schedule+0x314
aarch64-linux-gnu-addr2line: DWARF error: could not find abbrev number 860923
__schedule+0x314/0x780:
aarch64-linux-gnu-addr2line: DWARF error: could not find abbrev number 860923
__schedule at core.c:?

I'd tend to agree build time/space savings aren't worth the developer
time.
)

Anyway, address sanitizer used to have a kasan_symbolize.py script but
it looks like it got removed as no longer maintained, and I'm not sure
what's a good tool to just run these logs through nowadays, might want
to ask other test projects folks what they use...

> > If you still have the vmlinux binary from that build (or if you can
> > rebuild with the same options), running this text through addr2line
> > should not take you too long.
> 
> Please find build artifacts in this link,
>  - config
>  - vmlinux
>  - System.map
> https://people.linaro.org/~anders.roxell/next-20221130-allmodconfig-arm64-tuxmake-build/

So from the disassembly...

 - p9_client_cb+0x84 is right before the wake_up and after the wmb(), so
I assume we're on writing req->status line 441:

---
p9_client_cb(...)
{
...
        smp_wmb();
        req->status = status;

        wake_up(&req->wq);
---

report is about a write from 2 to 3, this makes sense we're going from
REQ_STATUS_SENT (2) to REQ_STATUS_RCVD (3).


 - p9_client_rpc+0x1d0 isn't as simple to pin down as I'm having a hard
time making sense of the kcsan instrumentations...
The report is talking about a READ of 4 bytes at the same address, so
I'd expect to see an ccess to req->status (and we're likely spot on
wait_event_killable which checks req->status), but this doesn't seem to
match up with the assembly: here's the excerpt from disass around 0x1d0
= 464 (why doesn't gdb provide hex offsets..)
---
   0xffff80000a46e9b8 <+440>:	cmn	w28, #0x200
   0xffff80000a46e9bc <+444>:	ccmn	w28, #0xe, #0x4, ne  // ne = any
   0xffff80000a46e9c0 <+448>:	b.eq	0xffff80000a46ecfc <p9_client_rpc+1276>  // b.none
   0xffff80000a46e9c4 <+452>:	mov	x0, x25
   0xffff80000a46e9c8 <+456>:	bl	0xffff800008543640 <__tsan_write4>
   0xffff80000a46e9cc <+460>:	mov	w0, #0x2                   	// #2
   0xffff80000a46e9d0 <+464>:	str	w0, [x21, #88]
   0xffff80000a46e9d4 <+468>:	b	0xffff80000a46ecfc <p9_client_rpc+1276>
   0xffff80000a46e9d8 <+472>:	mov	w27, #0x1                   	// #1
   0xffff80000a46e9dc <+476>:	mov	x0, x23
   0xffff80000a46e9e0 <+480>:	mov	w1, #0x2bc                 	// #700
   0xffff80000a46e9e4 <+484>:	bl	0xffff800008192d80 <__might_sleep>
---

+464 is a write to x21 (client 'c', from looking at how it is passed
into x0 for other function calls) at offset 88 (status field according
to dwarf infos from a rebuild with your config/same sources)

So, err, I'm a bit lost on this side.
But I can't really find a problem with what KCSAN complains about --
we are indeed accessing status from two threads without any locks.
Instead of a lock, we're using a barrier so that:
 - recv thread/cb: writes to req stuff || write to req status
 - p9_client_rpc: reads req status || reads other fields from req

Which has been working well enough (at least, without the barrier things
blow up quite fast).

So can I'll just consider this a false positive, but if someone knows
how much one can read into this that'd be appreciated.


Thanks,
--
Dominique

 
