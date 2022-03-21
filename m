Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE834E341E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiCUXU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiCUXUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:20:44 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DEB3620E2;
        Mon, 21 Mar 2022 16:11:30 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p5so10654053pfo.5;
        Mon, 21 Mar 2022 16:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZewwJE5XfIuup8vPS+K4oqWDNd0mldqHSrelxp9/gx4=;
        b=Xceux2tV0MfkN84VgB0qF1jKRpocH8y+vit0oOlRe33Jbi+HIQ7K3GmPrR7s/xmK2V
         hQ/XIjIYYykhF5aLyqm0qIIE58d4k0W10CbVkcPbIHedCLXcsE5G4qq1O9AcZ4oWHd9E
         Jul2ckEYElDhkZ+H95GPJ79kGc1+G4wTVamSJdCW9claiodoAw8gxTdfDv8MUY+/ViYo
         5bQdrVDdOQA+BYm51yEXwl8ryD0O42U4CNlvH3yiAfibYpCSxG5QDKrqWgxkmXtXguM0
         zbXHkXx4GlqVFvQ8f9G0OF9eEh7F9Zfn6YJAFlJId59kFT1dQCrHBFl9QfC4TgPJixbs
         JZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZewwJE5XfIuup8vPS+K4oqWDNd0mldqHSrelxp9/gx4=;
        b=z8Qy9z3AY230SrDxskJTROxePPW1ETXj13OiIt0QzdzO6xla0Ns/iUVxbk9T6U6H6v
         0Hsc/sNEsMJBe3qpwCFPIYnSWpA1ZwT6Qct4tVuLEKS6RPVKy5E64vYt3VRItiCG26Bt
         9K0SU9Gixq/+Q0vhLny2B3gTUzr3gTZKMRnBESLKunPzkK624XIhPctuPajrDaz72V9o
         72nIq3H8cSkU/lV6o3k/Vi9/eHQ3QHBSe0BvuFzC1/4Le4BesKN6Nq5ru/DtPLvipNie
         vJiKjeDVdTOWrsPZYZS8fLSq3SN7Qb8T2AQDE+5/4Dp/2f/Av9f0stOzr01xQwOVQc57
         +Slg==
X-Gm-Message-State: AOAM530eCefFuNvW0OLEdM/vNin+viznUdXEpvbMFp3MezUp9rLuZ1tD
        3IPtuYYQJGuzjXUkndam0FjdH620E9TXN4Qy9RI=
X-Google-Smtp-Source: ABdhPJyOwkUCfaJbCb2f/rGtBuwRCI5/X4xzDNoML42aYW8uAv84DeSqGV479u36yBAqmJ7AMz6GYeKHBP54n3+9l2w=
X-Received: by 2002:a62:bd0e:0:b0:4f6:e07f:d4ee with SMTP id
 a14-20020a62bd0e000000b004f6e07fd4eemr26529286pff.46.1647904290106; Mon, 21
 Mar 2022 16:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com> <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
In-Reply-To: <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 16:11:19 -0700
Message-ID: <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
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

On Mon, Mar 21, 2022 at 4:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Mar 21, 2022 at 3:46 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > The following pull-request contains BPF updates for your *net-next* tree.
>
> No
>
> This is the tree that contains bad architecture code that was NAK'ed
> by both x86 and arm64 people respectively.

I missed the nacks.

Did you look at the code?
In particular:
https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/

it's a copy paste of arch/x86/kernel/kprobes/core.c

How is it "bad architecture code" ?

> In particular, I think it's this part:
>
> > Masami Hiramatsu (11):
> >       fprobe: Add ftrace based probe APIs
> >       rethook: Add a generic return hook
> >       rethook: x86: Add rethook x86 implementation
> >       arm64: rethook: Add arm64 rethook implementation
> >       powerpc: Add rethook support
> >       ARM: rethook: Add rethook arm implementation
> >       fprobe: Add exit_handler support
> >       fprobe: Add sample program for fprobe
> >       fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
> >       docs: fprobe: Add fprobe description to ftrace-use.rst
> >       fprobe: Add a selftest for fprobe
>
> That was added very late to the linux-next tree, and that causes build
> warnings because of interactions with other changes.

To be fair Masami's set got to v12 revision and was ready
before Peter's endbr set.
If I didn't miss any email the only known issue
is missing endbr annotation.
