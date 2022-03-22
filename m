Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87354E381C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 05:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiCVEys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 00:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbiCVEyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 00:54:45 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C160063BFE;
        Mon, 21 Mar 2022 21:53:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p5so11128083pfo.5;
        Mon, 21 Mar 2022 21:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NU3GqLlAGLc0QjFPgT0IOCrUrueHHYZaOqNSb+zuhs=;
        b=RKWUzhyAONGHhIWGCsVNw+tdJkDN36RpXe4lQTAhNcQFv+/EKb7VUtKML51iP8lhJe
         6Qn8JJOLc0btxMu3TftCvV11jfi1CAwXev6HpP6yosR9/wsqh+H7XmDBHrLvmI0Fi3aU
         GWB+ar1xjl1fWSYmw0hTkC3HICQCSQx3T2/SaGjGtnMUUzBTGLSLL7CS8BsNRlw2XURN
         Peu2/vEPFQ+YRLtm63baxnMvGw1nQWWom5uq/tTWPImu1VM4C/aGE0Ufva8F7jgja2EX
         RP1pXF7oD2aSBXRHpHjPweqL23SYk5/kdYAlFcRFSVvbp9K7mjTKGquB5Im3xhuqrUr0
         X6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NU3GqLlAGLc0QjFPgT0IOCrUrueHHYZaOqNSb+zuhs=;
        b=phFiEtYsWlIa4S4Xh69ItKjVYs5Q5tsad3CHWpFfCATNTm4ir+M3dFtQTjRwvw6fYc
         CWMOLQoBveUxBzxi5dRACeZJbnGFoZ4UFx+Cgh6J07XD/sTZH/D/MakZg2Ovi5NclA7I
         0k+otfuu5SfJDdKB4HJbG9ImZgivSIvRKlNtkKqA81pyCHNMvYgV0F6kV8gnu8mmtERJ
         YT6jK47j3f4kNuP6uFvnDqvKurHu00tiaY80oEfvSrsw9rOj0/NUVd6dNFVvJzp1UgBZ
         ib8aSzkphT0QSmdV5jfneu8ONDVX3o7GHqSlqsuVrWZQA4fjmk1jXEDZkdJOr2Ie/DD2
         e51g==
X-Gm-Message-State: AOAM532pbsdQFz521Cg2aifhz9BvpOrhgVDC9j7Hs4fNcOsASrrN+nds
        iychnW0xn+ieMFhLcr1Lk4f/qJt0MYvH3ORxvRQ=
X-Google-Smtp-Source: ABdhPJyR85gBV6di2ju34PP2/0tT8ktmj+xBOUTFFhUvKHpGPwINfifgoJ6W6f7UB1TrDg77VBgsewdY5TIh3xh/SPw=
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id
 b6-20020a056a00114600b004c9ede0725amr27436217pfm.35.1647924795318; Mon, 21
 Mar 2022 21:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220321140327.777f9554@canb.auug.org.au> <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
 <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net> <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
 <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net> <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
 <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net> <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
 <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net> <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
 <20220322090541.7d06c8cb@canb.auug.org.au> <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
 <20220322094526.436ca4f7@elm.ozlabs.ibm.com> <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
 <20220322135151.307e7d7c478d1263e0eef43e@kernel.org>
In-Reply-To: <20220322135151.307e7d7c478d1263e0eef43e@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 21:53:04 -0700
Message-ID: <CAADnVQLqbC7=igoKd4ySneMaKh2Htq=2puWd19KQ698Z-zvJ2A@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the tip tree
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
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

On Mon, Mar 21, 2022 at 9:51 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Mon, 21 Mar 2022 15:50:17 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Mon, Mar 21, 2022 at 3:46 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi Alexei,
> > >
> > > On Mon, 21 Mar 2022 15:12:05 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > That makes little sense. It's not an unusual merge conflict.
> > > > Peter's endbr series conflict with Masami's fprobe.
> > > > Peter has a trivial patch that fixes objtool warning.
> > > > The question is how to land that patch.
> > > > I think the best is for Linus to apply it after bpf-next->net-next gets
> > > > merged.
> > >
> > > Peter has other concerns, please read the thread and consider them.
> >
> > Masami is an expert in kprobe. He copy pasted a bit of kprobe logic
> > to make it into 'multi kprobe' (he calls it fprobe).
> > I believe he knows what he's doing.
> > Steven reviewed and tested that set.
> > We've tested it as well and don't have any correctness or api concerns.
>
> Sorry, that's my mistake to not Ccing to arch maintainers for the arch
> dependent patches. Let me update and send v13 for this fprobe series.

No. Please read what I've said earlier.
