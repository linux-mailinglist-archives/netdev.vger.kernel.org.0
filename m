Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703194E37FA
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 05:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiCVEhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 00:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiCVEhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 00:37:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858AE205C7;
        Mon, 21 Mar 2022 21:36:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so1116387pjq.2;
        Mon, 21 Mar 2022 21:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uo/1OUaIznEFGmobWpbSlJ+BL/SSeNvkm1s2vVWafZU=;
        b=VxGwARXiHft1JHO4SAJ6G/DRxNMioJC6K7RIZxbTrXyiIFXwfbF77MKTRdTwyKMU7G
         tTgE4GF0A3yJfuxyQ7BpF1dUWaV40mT5ZN0rBS8t6VTwYu2cJdZJbNSuPHLYbcd8rn4c
         X4bFG9I/V/9NsaU0gfg1Um8LujbGbBMzgIjBf8DrsZruloGr98miTvbhKC2f1BXdMQ77
         akglctU4K+6xK/rL65YVVWTKrlNRkKc3vUL9LoBPdc1cTdKlaYgqdtVlRVybSng5l0HJ
         sHB9/6vFcw1EjcJNZdHhGwFZPGxWNT+ZEKJAN9e0a/KE5EHhxQ0w6s+lC9JUIdvY7dn4
         psaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uo/1OUaIznEFGmobWpbSlJ+BL/SSeNvkm1s2vVWafZU=;
        b=JcI9pe15Okgtm7dZ2SzKCNJRYmTsab8/nJuud0prfx+9Pv/wgbdzGaF5VfvsVW/xxD
         yGsZ5z1QTsIr1diZwL4lJnBEze9rBEC7MCrgsPIV1BpAFM1gV7o7uvWovZ3wGpJPFcTe
         l0n8setiVXSH0Z5ita0LVjEjJn0RJ27ndEVf3LKiYBuSzHoCChWAi/sKSYqEGOxNkhML
         /SMJgJD6auMasUCY4pqwHgEq/dMLCmiNmyYd8qBUZGYz0Kf1mcp54PvyqEtQI/MIwOaw
         VSc97QCEbg04v0CMHFo60M3VW/DguXAPzmvcr7nYjPlu1rwWz0JDHROC6jy9LrNnpS/S
         PbQA==
X-Gm-Message-State: AOAM5314zyAMcc5iZywCkNkXHrIDzlk5/2LUw2AnpDuGLMWNYt/BKxlJ
        TyD2Y1eA9UkC7L4UWiMbNtbdpGvSg8y/JGVj6KnV13CY1o8=
X-Google-Smtp-Source: ABdhPJxOA+BRHz2sLBDJXgEVfv5tAqA/pffZbkqJacB3s0IXsENfHi7cQMTW6xX1PHHj9v+YLYeUpyvMIpC1OJCJVlo=
X-Received: by 2002:a17:90b:4f43:b0:1c7:552b:7553 with SMTP id
 pj3-20020a17090b4f4300b001c7552b7553mr2613710pjb.117.1647923766902; Mon, 21
 Mar 2022 21:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
 <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
 <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
 <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
 <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com> <20220322113641.763885257f741ac5c0cb2c06@kernel.org>
In-Reply-To: <20220322113641.763885257f741ac5c0cb2c06@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 21:35:55 -0700
Message-ID: <CAADnVQ+HEeBXm0qXdnxn1of-dPr7THcVZxb9Adud0t9epVsWKQ@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 7:36 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hi Linus and Alexei,
>
> At first, sorry about this issue. I missed to Cc'ed to arch maintainers.
>
> On Mon, 21 Mar 2022 17:31:28 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Mon, Mar 21, 2022 at 4:59 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > Did you look at the code?
> > > > In particular:
> > > > https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
> > > >
> > > > it's a copy paste of arch/x86/kernel/kprobes/core.c
> > > >
> > > > How is it "bad architecture code" ?
> > >
> > > It's "bad architecture code" because the architecture maintainers have
> > > made changes to check ENDBR in the meantime.
> > >
> > > So it used to be perfectly fine. It's not any longer - and the
> > > architecture maintainers were clearly never actually cc'd on the
> > > changes, so they didn't find out until much too late.
>
> Let me retry porting fprobe on top of ENDBR things and confirm with
> arch maintainers.

Just look at linux-next.
objtool warning is the only issue.

> >
> > Not denying that missing cc was an issue.
> >
> > We can drop just arch patches:
> >       rethook: x86: Add rethook x86 implementation
> >       arm64: rethook: Add arm64 rethook implementation
> >       powerpc: Add rethook support
> >       ARM: rethook: Add rethook arm implementation
> >
> > or everything including Jiri's work on top of it.
> > Which would be a massive 27 patches.
> >
> > We'd prefer the former, of course.
> > Later during the merge window we can add a single
> > 'rethook: x86' patch that takes endbr into account,
> > so that multi-kprobe feature will work on x86.
> > For the next merge window we can add other archs.
> > Would that work?
>
> BTW, As far as I can see the ENDBR things, the major issue on fprobe
> is that the ftrace'ed ip address will be different from the symbol
> address (even) on x86. That must be ensured to work before merge.
> Let me check it on Linus's tree at first.

That's not an issue. Peter tweaked ftrace logic and fprobe plugs
into that.
The fprobe/multi-kprobe works fine in linux-next.

bpf selftest for multi kprobe needs this hack:
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c
b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index af27d2c6fce8..530a64e2996a 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -45,7 +45,7 @@ static void kprobe_multi_check(void *ctx, bool is_return)
        __u64 addr = bpf_get_func_ip(ctx);

 #define SET(__var, __addr, __cookie) ({                        \
-       if (((const void *) addr == __addr) &&          \
+       if (((const void *) addr == __addr + 4) &&              \
             (!test_cookie || (cookie == __cookie)))    \

to pass when both CONFIG_FPROBE=y and CONFIG_X86_KERNEL_IBT=y.
The test is too strict. It didn't account for the possibility of endbr.

So I'm inclined to drop only 4 arch patches instead of the whole thing.
