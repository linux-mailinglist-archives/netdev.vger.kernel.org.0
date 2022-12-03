Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A656417DB
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 17:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiLCQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 11:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLCQrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 11:47:25 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5355F1EECA
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 08:47:24 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3704852322fso78092117b3.8
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 08:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qn9rzwOPoUgx3KNCikSZW0olrpEdB8fhdwL7QqLBi74=;
        b=tNkAN9J6KJRs6JVVZwcksPUEVCiO60efNXFxBYRqvKS4tVHjd0wAYlSEwSorC6o7n+
         7L9EQNVMskLyTBy5KNrObNcqAGuYSxJP9VQt0yF7Cm9/AEjGyQrIgZpTdeTA7uVBqjQA
         ck+L9Uy6s8zCFhcFogr92F7g0YlBA1gEli2UVUWYNlh53FEp3irKbhk5//ObHtm6y6LO
         3cgCTLgLL8C+g9gpzZFQp3UyHk31Gh+1mXBeCAZoUv9gSqQJdS3Gsg5muIdh6VChiYwX
         zXGSO0a64MCLd9rVdfvPeNJtey43uP8g5Do42mQkZrDqfzDd+OXgn7czSqaF+RAdFHJr
         glvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qn9rzwOPoUgx3KNCikSZW0olrpEdB8fhdwL7QqLBi74=;
        b=a3Gr02LSmAcXWo87XvJFuOBTSL6IvtG3q1Er+9qN1wJYAeaSQfKTFdA8d7vbWPXIlr
         zMTA9nU8DfHs6mzB5IpmblHfx1iXqScaPkoYP5cUcZbDRTuyhj8H9dET6UF9FI/LehRf
         +90AchQEXIOZ7YAYsMnuvj/8Qnz3nBVVvYeArn88pejETpaieJO6Hl0WipLDV/9qbJDF
         DWEbjK1Brm5zfQ3yLlXqHYwta76of4ewOJU7jThrH6E/fls5mCn9ty09os329yTFDjpX
         ORP8z7AFj/vLMsyZ/3jFL3Z+AHZmi4/AZEVYWZZoAMRPAfZ23gUXvlXH20xSwEBAe0sh
         NX1Q==
X-Gm-Message-State: ANoB5pkLxGx6NtvA+m+3JSEK8KJhObZFxvpfMcfeVNlEAoYpjLFrIxlW
        cFt9/zn3mB5Ko7zCXc6F+oMmCe3Z0h+KGnilzW3IZw==
X-Google-Smtp-Source: AA0mqf5aaE6vGdGJee0oGXLrp9VMzbyBqL1+zxvA4YghkB4vnJHFUGUXBa2c67yMxgrGQ2aKPGkQyJUXbQ8zqFU0Ix0=
X-Received: by 2002:a05:690c:884:b0:37b:4a21:f86a with SMTP id
 cd4-20020a05690c088400b0037b4a21f86amr58483902ywb.465.1670086043315; Sat, 03
 Dec 2022 08:47:23 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
 <Y4e3WC4UYtszfFBe@codewreck.org> <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
 <Y4ttC/qESg7Np9mR@codewreck.org>
In-Reply-To: <Y4ttC/qESg7Np9mR@codewreck.org>
From:   Marco Elver <elver@google.com>
Date:   Sat, 3 Dec 2022 17:46:46 +0100
Message-ID: <CANpmjNNcY0LQYDuMS2pG2R3EJ+ed1t7BeWbLK2MNxnzPcD=wZw@mail.gmail.com>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb / p9_client_rpc
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Dec 2022 at 16:37, Dominique Martinet <asmadeus@codewreck.org> wrote:
>
> (reply out of order)
>
> Naresh Kamboju wrote on Thu, Dec 01, 2022 at 01:13:25PM +0530:
> > > (You might need to build with at least CONFIG_DEBUG_INFO_REDUCED (or not
> > > reduced), but that is on by default for aarch64)
> >
> > Thanks for the suggestions.
> > The Kconfig is enabled now.
> > CONFIG_DEBUG_INFO_REDUCED=y
>
> It looks enabled in your the config file you linked at, I don't
> understand this remark?
> Did you produce the trace the other day without it and rebuild the
> kernel with it?
> In this case you also have CONFIG_DEBUG_INFO_SPLIT set, so the vmlinux
> file does not contain enough informations to retrieve line numbers or
> types, and in particular addr2line cannot be used on the files you
> provided.
> I've never used split debug infos before, but digging old threads I'm
> not too hopeful unless that changed:
> https://lkml.iu.edu/hypermail/linux/kernel/1711.1/03393.html
> https://sourceware.org/bugzilla/show_bug.cgi?id=22434
>
> (...a test build later, it's still mostly useless...
> normal build
> $ ./scripts/faddr2line vmlinux __schedule+0x314
> __schedule+0x314/0x6c0:
> perf_fetch_caller_regs at include/linux/perf_event.h:1286
> (inlined by) __perf_sw_event_sched at include/linux/perf_event.h:1307
> (inlined by) perf_event_task_sched_out at include/linux/perf_event.h:1347
> (inlined by) prepare_task_switch at kernel/sched/core.c:5053
> (inlined by) context_switch at kernel/sched/core.c:5195
> (inlined by) __schedule at kernel/sched/core.c:6561
>
> split dwarf build
> $ ./scripts/faddr2line vmlinux __schedule+0x314
> aarch64-linux-gnu-addr2line: DWARF error: could not find abbrev number 860923
> __schedule+0x314/0x780:
> aarch64-linux-gnu-addr2line: DWARF error: could not find abbrev number 860923
> __schedule at core.c:?
>
> I'd tend to agree build time/space savings aren't worth the developer
> time.
> )
>
> Anyway, address sanitizer used to have a kasan_symbolize.py script but
> it looks like it got removed as no longer maintained, and I'm not sure
> what's a good tool to just run these logs through nowadays, might want
> to ask other test projects folks what they use...
>
> > > If you still have the vmlinux binary from that build (or if you can
> > > rebuild with the same options), running this text through addr2line
> > > should not take you too long.
> >
> > Please find build artifacts in this link,
> >  - config
> >  - vmlinux
> >  - System.map
> > https://people.linaro.org/~anders.roxell/next-20221130-allmodconfig-arm64-tuxmake-build/
>
> So from the disassembly...
>
>  - p9_client_cb+0x84 is right before the wake_up and after the wmb(), so
> I assume we're on writing req->status line 441:
>
> ---
> p9_client_cb(...)
> {
> ...
>         smp_wmb();
>         req->status = status;
>
>         wake_up(&req->wq);
> ---
>
> report is about a write from 2 to 3, this makes sense we're going from
> REQ_STATUS_SENT (2) to REQ_STATUS_RCVD (3).
>
>
>  - p9_client_rpc+0x1d0 isn't as simple to pin down as I'm having a hard
> time making sense of the kcsan instrumentations...
> The report is talking about a READ of 4 bytes at the same address, so
> I'd expect to see an ccess to req->status (and we're likely spot on
> wait_event_killable which checks req->status), but this doesn't seem to
> match up with the assembly: here's the excerpt from disass around 0x1d0
> = 464 (why doesn't gdb provide hex offsets..)
> ---
>    0xffff80000a46e9b8 <+440>:   cmn     w28, #0x200
>    0xffff80000a46e9bc <+444>:   ccmn    w28, #0xe, #0x4, ne  // ne = any
>    0xffff80000a46e9c0 <+448>:   b.eq    0xffff80000a46ecfc <p9_client_rpc+1276>  // b.none
>    0xffff80000a46e9c4 <+452>:   mov     x0, x25
>    0xffff80000a46e9c8 <+456>:   bl      0xffff800008543640 <__tsan_write4>
>    0xffff80000a46e9cc <+460>:   mov     w0, #0x2                        // #2
>    0xffff80000a46e9d0 <+464>:   str     w0, [x21, #88]
>    0xffff80000a46e9d4 <+468>:   b       0xffff80000a46ecfc <p9_client_rpc+1276>
>    0xffff80000a46e9d8 <+472>:   mov     w27, #0x1                       // #1
>    0xffff80000a46e9dc <+476>:   mov     x0, x23
>    0xffff80000a46e9e0 <+480>:   mov     w1, #0x2bc                      // #700
>    0xffff80000a46e9e4 <+484>:   bl      0xffff800008192d80 <__might_sleep>
> ---
>
> +464 is a write to x21 (client 'c', from looking at how it is passed
> into x0 for other function calls) at offset 88 (status field according
> to dwarf infos from a rebuild with your config/same sources)
>
> So, err, I'm a bit lost on this side.
> But I can't really find a problem with what KCSAN complains about --
> we are indeed accessing status from two threads without any locks.
> Instead of a lock, we're using a barrier so that:
>  - recv thread/cb: writes to req stuff || write to req status
>  - p9_client_rpc: reads req status || reads other fields from req
>
> Which has been working well enough (at least, without the barrier things
> blow up quite fast).
>
> So can I'll just consider this a false positive, but if someone knows
> how much one can read into this that'd be appreciated.

The barriers only ensure ordering, but not atomicity of the accesses
themselves (for one, the compiler is well in its right to transform
plain accesses in ways that the concurrent algorithm wasn't designed
for). In this case it looks like it's just missing
READ_ONCE()/WRITE_ONCE().

A (relatively) quick primer on the kernel's memory model and
where/what/how we need to "mark" accesses:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt

Thanks,
-- Marco
