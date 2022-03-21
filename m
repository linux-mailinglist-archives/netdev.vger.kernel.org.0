Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C34E3408
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiCUXOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiCUXOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:14:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F220344A0C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:02:55 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 25so21855544ljv.10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBwRJ7GvCh4HtlZQddJMPuKbvebn+hY/0aFRZGnCyYw=;
        b=RM2ROADzKcYZGbkgNThMWejZQKWAdtKsOo5GYb0Nbw9kcwMn7+aoDS82B5mu+F+MvP
         neUMee81Lurcv6z5MROmZ4/LuNOvF073FfdHZeoP0m+zA75pI0bqsqApnXq35iu/nnAA
         SwI/+2l8/2ufeXsFybX2V0dOUOj5T0tD4i3VY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBwRJ7GvCh4HtlZQddJMPuKbvebn+hY/0aFRZGnCyYw=;
        b=qiKxtq/1X0Uv78uAJXKqAELMr5/B6n2PIGyUbZLzSyIQ8oq8t3QBF3FD5CF8pxTGoB
         WneHpZtvHfpuvcZFw+8UTuAOVquH5nikVximzhnQ5603wmjUJpeDPOeZo7bGD+bebAAH
         UiQ3SQi6SVKB3eXw2805r4Dq5Boj5Cxwuyj0ZpArR8LdGEocHG56z26KnJ0IQZK0ikqK
         XB2xieLcVFsNgKBGe/nxk7k9zi9SNxcKPnzI7cJ1KiCS90TixnqNdA9sPm8mrs3TxDC2
         QwA5AN+Wn6Dh+sbzNeDKYiIMkJ+wcnVCOeKdTMCnB0vhYEGLMUMcO6xYt7DYFyv5b1JW
         Ou/A==
X-Gm-Message-State: AOAM53289pVQgTZegmllP1ZUMpWRukkp7vPNSwie3GEs44p/Ln1ijciW
        OrQUWttcOCxIznrHzf/iIxC1R3h0EToRL3iZ6Qk=
X-Google-Smtp-Source: ABdhPJxgxUBU2wwl18/BUfW42I/jMFpoye8gG36y0Nqr5PeRRn9HZ/juvCMz8d7EEeW69ZQjLf1DeQ==
X-Received: by 2002:a2e:a7ce:0:b0:249:862b:503 with SMTP id x14-20020a2ea7ce000000b00249862b0503mr4495847ljp.369.1647903722258;
        Mon, 21 Mar 2022 16:02:02 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id x28-20020a19e01c000000b0044a3aca1c39sm42565lfg.255.2022.03.21.16.02.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:02:01 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id l20so26931170lfg.12
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:02:01 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr16491603lfj.449.1647903721198; Mon, 21
 Mar 2022 16:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Mar 2022 16:01:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
Message-ID: <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 3:46 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> The following pull-request contains BPF updates for your *net-next* tree.

No

This is the tree that contains bad architecture code that was NAK'ed
by both x86 and arm64 people respectively.

In particular, I think it's this part:

> Masami Hiramatsu (11):
>       fprobe: Add ftrace based probe APIs
>       rethook: Add a generic return hook
>       rethook: x86: Add rethook x86 implementation
>       arm64: rethook: Add arm64 rethook implementation
>       powerpc: Add rethook support
>       ARM: rethook: Add rethook arm implementation
>       fprobe: Add exit_handler support
>       fprobe: Add sample program for fprobe
>       fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
>       docs: fprobe: Add fprobe description to ftrace-use.rst
>       fprobe: Add a selftest for fprobe

That was added very late to the linux-next tree, and that causes build
warnings because of interactions with other changes.

Not ok.

                   Linus
