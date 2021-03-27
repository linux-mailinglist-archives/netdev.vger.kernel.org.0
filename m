Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C7F34B6E1
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 12:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhC0Lvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 07:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhC0Lvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 07:51:33 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CBFC0613B1;
        Sat, 27 Mar 2021 04:51:32 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id z9so7288626ilb.4;
        Sat, 27 Mar 2021 04:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=/vGWWqK1/Olw4o2ExeQgX6UQxN4NCuhW5Q/AlSkWG+s=;
        b=hFDpvqG+oPctLMM9QhB2UtjGqHpIOKomedazA5d1WNB0tI1pIQ7ibhQSAQDsg49rMd
         x2WzQcP3pDj/zJcO1aRvo7aZ4sJSXKlxx1z6zmzqEQCm0QZhg7N04vhcIB3ImNEWQHpg
         +R17I7ey/6YLo3oQ10OV5KuEAdgsplZBTD7yKX5qkLvMzbMFiQbR70lhhP6bMhfkqpET
         wea8j/6KijJXM16lrL9wjZDK7JGG2cXrQ0Ru+KXOhFHJVYd3fI8WO0mb+Y95DeQf5+Pl
         BpGBlT/ok2blT/i+6LkRDb8LNlWQNi1w4viuNSyb49gTB7nJ8+puV71w6J40sgiuJ/Ny
         h6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=/vGWWqK1/Olw4o2ExeQgX6UQxN4NCuhW5Q/AlSkWG+s=;
        b=Uwoof5WnEI0hq7XAOev6MrnI22pRpzBss91cp5X26w2XfdrzmBTdMT9dVSzuwZLW+y
         FUCAg/TOo2QNvSJxXU9QuLcNIaa08pXVc/dF9JLd8Xr9/6W1cIHwVAoBOeHDEgDGQpzr
         o8cGWKyrlwaLAia6xc8fu+vK1Cxg7IqbVAzcII3KWkW39AjmgcmXFbLbOL8eZsXmElCw
         6bwSms4GhbIAuXWIkl8Au3LDlcYZ6wGZQnjVv4cmir4eWAjhwjMwIGs1a3Q3Gw7DRMXb
         AnX+B4b4KUabmwrKitYPXChEYv+W//wvpm5PdfNiwPT5yMXSu/AjE2XHK09zT8Pe1v0a
         s0Tw==
X-Gm-Message-State: AOAM530aQFOewgk6WK/cHw+ScBS5immVwzGqyVZQGmGko08zxvZLbH1c
        RdmaozIkW/QYMPLrRZGCW3Nfg8jYmnAut8xY1hoYbb3ZiUl1BA==
X-Google-Smtp-Source: ABdhPJwQ9iTxiPMa7n7QoOhCN3oct3cVVdCKkNqEuVuM98xrZ+ZkHqAar33WAktTuU6Z09kKod6OHyPnA9VmZg7DKi4=
X-Received: by 2002:a92:c545:: with SMTP id a5mr13139278ilj.209.1616845891800;
 Sat, 27 Mar 2021 04:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210322143714.494603ed@canb.auug.org.au> <20210322090036.GB10031@zn.tnic>
 <CA+icZUVkE73_31m0UCo-2mHOHY5i1E54_zMb7yp18UQmgN5x+A@mail.gmail.com> <20210326131101.GA27507@zn.tnic>
In-Reply-To: <20210326131101.GA27507@zn.tnic>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 27 Mar 2021 12:50:55 +0100
Message-ID: <CA+icZUVGvo7jVxMHoCYdU6Y1x=q3n6hVW4EoU_AsGvzozQLG5w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
To:     Borislav Petkov <bp@suse.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 2:11 PM Borislav Petkov <bp@suse.de> wrote:
>
> On Fri, Mar 26, 2021 at 09:57:43AM +0100, Sedat Dilek wrote:
> > The commit b90829704780 "bpf: Use NOP_ATOMIC5 instead of
> > emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG" is now in Linus Git
> > (see [1]).
> >
> > Where will Stephen's fixup-patch be carried?
> > Linux-next?
> > net-next?
> > <tip.git#x86/cpu>?
>
> I guess we'll resolve it on our end and pick up sfr's patch, most
> likely.
>
> Thanks for letting me know.
>

Sounds good to me.

So you need:

$ grep CONFIG_BPF_JIT= .config
1795:CONFIG_BPF_JIT=y

$ git grep CONFIG_BPF_JIT arch/x86/net/Makefile
arch/x86/net/Makefile:        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
arch/x86/net/Makefile:        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o

I wonder why Stephen's fixup-patch was not carried in recent
Linux-next releases.
Wild speculation - no random-config with x86(-64) plus CONFIG_BPF_JIT=y?

Anyway, I integrated Stephen's fixup-patch into my custom patchset.

$ git log --oneline --author="Stephen Rothwell" v5.12-rc4..
600417efac59 (for-5.12/x86-cpu-20210315-net-bpf-sfr) x86: fix up for
"bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for
BPF_TRAMP_F_CALL_ORIG"

Feel free to add my:

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang v12.0.0-rc3 (x86-64)

- Sedat -
