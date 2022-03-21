Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1194E3528
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiCVACa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiCVAC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:02:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7FF200944
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:59:52 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w27so27160188lfa.5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FsaOnWeCk13QKDyhf3nL2sin+v7saq6qTmMyDRnRO0s=;
        b=PA4K5DpJZJPyZoq08+2m1Ta5kU++fe9CSmd7d03tsb0o+XzW6Nc6afVNH7zUGDSLvQ
         RjETIhnTo1kVtc/aN309Xg7bLDtEJsUEGehitZxyuNZ28YbiUKR750wPmFFIYk/95/oj
         mbH7WMqIptneasA/oXnP2Fwi6u5YybjqGQS5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FsaOnWeCk13QKDyhf3nL2sin+v7saq6qTmMyDRnRO0s=;
        b=uIUYHGDTyM6qHH8bqGtijPrEvYREjODPTyOamTev2I9d4Gjbc7YLXDaKggun4sm3NE
         6FWKN5VqzpLq8fQFMl9mFClTuPTnrnb8zzhXYolABZOiU1S5PVRwS7XdfSRjt41PqjwX
         QmmZlXNfLdZXY/pqnUAmpbKZrUcHJJyr1j/iTz+pKj1Nu1RSo0RG/W77WNCzJMCRxtjc
         GL1cPK+5SCiJI2G6x4UeiYxuu86mxguZ2FZI1WT/48AokD132su7dtjWZ9sMr+ETnQA/
         mVYUdhF6IEjfeeTKRp3Dyj6FcK5fj54gNRNFB1ggFYu95/1cPlAkJlI26aUK63BESxcJ
         KCJg==
X-Gm-Message-State: AOAM532ZhdFRHsRpqBLAV4IAy99iUZLLY4ROfQ7hS+3uhaYVw+mMjcOX
        Oyub7Vv9x7ZG/kgbldMb5wc144EmFDUNN17uj48=
X-Google-Smtp-Source: ABdhPJy9h2zTi1WOmfxCYR58OCV+Kg1ZePXX9LC7NxK/GjsHuXPvpv2hFbE1pDX0AmksJfL3zwsTtg==
X-Received: by 2002:a05:6512:4017:b0:44a:26d1:c729 with SMTP id br23-20020a056512401700b0044a26d1c729mr6433988lfb.552.1647907188066;
        Mon, 21 Mar 2022 16:59:48 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id i2-20020a196d02000000b004488dae6d45sm1958572lfc.52.2022.03.21.16.59.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:59:45 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id w7so27157753lfd.6
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:59:45 -0700 (PDT)
X-Received: by 2002:a05:6512:b13:b0:448:90c6:dc49 with SMTP id
 w19-20020a0565120b1300b0044890c6dc49mr16827759lfu.542.1647907185334; Mon, 21
 Mar 2022 16:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
 <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com> <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
In-Reply-To: <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Mar 2022 16:59:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
Message-ID: <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
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

On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Did you look at the code?
> In particular:
> https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
>
> it's a copy paste of arch/x86/kernel/kprobes/core.c
>
> How is it "bad architecture code" ?

It's "bad architecture code" because the architecture maintainers have
made changes to check ENDBR in the meantime.

So it used to be perfectly fine. It's not any longer - and the
architecture maintainers were clearly never actually cc'd on the
changes, so they didn't find out until much too late.

Think of it this way: what if somebody started messing with your BPF
code, never told you, and then merged the BPF changes on the basis of
"hey, I used old BPF code as a base for it". In the meantime, you'd
changed the calling convention for BPF, so that code - that used to be
ok - now no longer actually works properly.

Would you think it's ok to bypass you as a maintainer on the basis
that it was based on a copy of code you maintained, and never even cc
you on the changes?

Or would you be unhappy?

             Linus
