Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406084E33EC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiCUXEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiCUXEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:04:36 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF31E185946;
        Mon, 21 Mar 2022 15:50:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w4so13950601ply.13;
        Mon, 21 Mar 2022 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjDIX8FrnNGu2sjrMpbegjPBjATRwYY4jn7Ao70Kxyo=;
        b=IaV+U83i5jJzWL8L+pKxUmTUm0rPMYYOsiZUl+5853A/3WhOMJimBY37LgFdAg9+C4
         raODH5QYd1S8pEOSUHR5KU8kDwcLUZTp5htU64Lvpqruj45p1VilJKYTK503JNGKJcsW
         0soXjGYIZpy2b+1izOhgzubWaySAQ0guXKN6PifYwEtKEO3IHZSkl4mPfSlvn1cziW+X
         V2KAQXldEzaaom5rZoP2aVRv/dLfn4cBi8sM+L5IPA22AxetjrV99i0XMeWeFKGFDRXv
         XQWxPa/vvXQ2ViqzsELJRMzdQV9Pd+pKv4slWwPClhaELCZyUWB4fsRNDZDwAROHhHe5
         QSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjDIX8FrnNGu2sjrMpbegjPBjATRwYY4jn7Ao70Kxyo=;
        b=Be6LPVV+R9OXfzjFSlyWnyK4oGhj/a1acJNZiAsCDMm8KBnSZUpBwSGcviUhHWDcnV
         hlrbExmlQ1Ya7BDw45+r5XJz9p02DnZ2IiP0XOvCoJEzN2GfZ+xujlTB5T1S5cQOwKFD
         wO8sA/tPAq7mzQv5hXa3kKX0lev7I3VAvF2iD+D4Hu5F4JFGSVSb5kD+1wfYzJDUvTD8
         0gVZEeJxQxBWkOAi3qgg+B9s2953irb624W3Y3ZGMWbg6WQlDmtHeEM8Jro5N5+wZAxh
         1M97XtnJ/YLVPjiiDhtFMO9TMxN4HlhXb2VTLOqPs+T5ZCj86+gEa1mGPKkebl9Sqphg
         7CMw==
X-Gm-Message-State: AOAM530rHLW2o8IAZj4IjosCUA5+R4qAfLCccy4kweFnJFC+rJKWA4Fz
        8E0Lk+/Vj3flu6SzV+/C6xwYiiOd14AyEwDJlVY=
X-Google-Smtp-Source: ABdhPJw9lrVe9NKMoe6AyhEoPhg1LpuOlXp8HBaE8bBK/xHhap0NsTF5dieSqAx7Rc6F2gLPnSouhFRil+H7jvXDXcE=
X-Received: by 2002:a17:90b:3d03:b0:1c6:74bf:418a with SMTP id
 pt3-20020a17090b3d0300b001c674bf418amr1494432pjb.33.1647903029013; Mon, 21
 Mar 2022 15:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220321140327.777f9554@canb.auug.org.au> <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
 <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net> <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
 <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net> <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
 <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net> <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
 <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net> <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
 <20220322090541.7d06c8cb@canb.auug.org.au> <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
 <20220322094526.436ca4f7@elm.ozlabs.ibm.com>
In-Reply-To: <20220322094526.436ca4f7@elm.ozlabs.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 15:50:17 -0700
Message-ID: <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
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

On Mon, Mar 21, 2022 at 3:46 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Alexei,
>
> On Mon, 21 Mar 2022 15:12:05 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > That makes little sense. It's not an unusual merge conflict.
> > Peter's endbr series conflict with Masami's fprobe.
> > Peter has a trivial patch that fixes objtool warning.
> > The question is how to land that patch.
> > I think the best is for Linus to apply it after bpf-next->net-next gets
> > merged.
>
> Peter has other concerns, please read the thread and consider them.

Masami is an expert in kprobe. He copy pasted a bit of kprobe logic
to make it into 'multi kprobe' (he calls it fprobe).
I believe he knows what he's doing.
Steven reviewed and tested that set.
We've tested it as well and don't have any correctness or api concerns.
