Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123884E33FB
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiCUXAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiCUW7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:59:10 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25753324D64;
        Mon, 21 Mar 2022 15:46:45 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 185so7675664vsq.8;
        Mon, 21 Mar 2022 15:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLkiceh7FVS00nQi94x7eJVMtBdQbeaIibQoKaWYl8E=;
        b=caRSOC3C4scd0H//UxWuKxVs05sAzJncJTZaouCVpdJz+RlMT9Bojz47Vi7CFlKp0c
         YEmy2SUy4tN5dH1vQtLhDdUvhc3CsI3Drb/1Qox1DGJ8jqPflIjXCvxnmOkL/j6bCys6
         gNCluTsTCCW5mJYv+T5aLL40BsUU+u+1poIvyIxsBhZsmLVih7y54uDx9ltEvBFA5W/M
         MhYLnO/73VpP8lJgWUd2lfg1oSUpVOKFYaOpyv2wEHf7VA3ZRF4zgDJSoN4NLQsD/VRF
         l6Lj6QBXLj5SKxzIrZXdDGn3aYTlnBfgzSGjUKgzI8vgTPAsoleHBHFbgD69BkDcHRXR
         WUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLkiceh7FVS00nQi94x7eJVMtBdQbeaIibQoKaWYl8E=;
        b=H1LvL5Xh0JvEJuCPx7t+4QA2XfYDGcuhDugYHGLQOD0NBkG4zPTUNTjYWx54A0J8BD
         zPGDNY4LEty9Dl9Qed+uTzneFDbKCCureBiWPIiJpW13/25OzvgyyUjK7xtHhZ0fF8Uh
         x43tyAGJUmAFfr03jsjoPL9ynGOkOzl6PZKG7ZZ4Z++F7FxVD3axBLUb4bWCOBV6UQMo
         W47DxdL8/a/RH8RLPZkOkQRXJBMLUSXDoTcT7xKRfXPJk+zNk8gUt3Usj0xoxe7Dtovm
         BtzeGq38+YueULF5dadtT5oImHBigIPlvpQekwkty+WEWCsuOV5efVCgrGcJMlMDxY+r
         5cZQ==
X-Gm-Message-State: AOAM530hGKUr79LnRSkX5hUsS+XWLDPTgjn7GJZ4A/rvpFDYGmhkZiqH
        8HGlBTlJdHiE8vhZe8gmC+Wlgb3qzi7sRCJM6mag/T04
X-Google-Smtp-Source: ABdhPJxCsMaQmrzfv8GKYMyK9qiHMXFUsezbm2wUfdUgXGXQmuYRJDRyumiEJQNikiKCEm0N2orr+DETmegYhv9f6aw=
X-Received: by 2002:a17:903:32c7:b0:154:4156:f384 with SMTP id
 i7-20020a17090332c700b001544156f384mr11038638plr.34.1647900736459; Mon, 21
 Mar 2022 15:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220321140327.777f9554@canb.auug.org.au> <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
 <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net> <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
 <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net> <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
 <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net> <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
 <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net> <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
 <20220322090541.7d06c8cb@canb.auug.org.au>
In-Reply-To: <20220322090541.7d06c8cb@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 15:12:05 -0700
Message-ID: <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the tip tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        linux-toolchains <linux-toolchains@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
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

On Mon, Mar 21, 2022 at 3:05 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> On Mon, 21 Mar 2022 09:52:58 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > On Mon, Mar 21, 2022 at 9:45 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > It's presumably not in any of the pull requests I already have
> > > > pending, but it would be nice if I saw some details of _what_ you are
> > > > complaining about, and not just the complaint itself ;)
> > >
> > > Duh, right. It's this series:
> > >
> > >   https://lore.kernel.org/bpf/164757541675.26179.17727138330733641017.git-patchwork-notify@kernel.org/
> > >
> > > That went into bpf-next last Friday. I just checked but haven't found a
> > > pull for it yet.
> >
> > Thanks. I can confirm it's not in any of the pull requests I have
> > pending, so I'll just start doing my normal work and try to remember
> > to look out for this issue later.
>
> The normal path for bpf-next code is via the net-next tree.  But the
> above series has not yet been merged into the net-next tree so is only
> in the bpf-next tree.
>
> So, what am I to do?  Drop the bpf-next tree from linux-next until this
> is resolved?  Some input from the BPF people would be useful.
>
> Dave, Jakub, please do not merge the bpf-bext tree into the net-next
> tree for now.

That makes little sense. It's not an unusual merge conflict.
Peter's endbr series conflict with Masami's fprobe.
Peter has a trivial patch that fixes objtool warning.
The question is how to land that patch.
I think the best is for Linus to apply it after bpf-next->net-next gets
merged.

We're preparing bpf-next PR right now.
