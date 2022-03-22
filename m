Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB84E3824
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 05:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiCVExd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 00:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbiCVExc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 00:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E96BB188D;
        Mon, 21 Mar 2022 21:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C177CB81B7D;
        Tue, 22 Mar 2022 04:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72538C340EC;
        Tue, 22 Mar 2022 04:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647924718;
        bh=eKcLWgpHdf9XPGlZN+BHHdUf5YEZfdRlI78wdT/+Xg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oUA2kdr5H79czLwPSKctVD/I+r/J0wt8ZbNJUSZPjKx2IF/9UfbirKRI+ZjTJWZla
         5GsmxvxkkHqwZtibJx3CE16a/2dUP8zDcnFZIxNJrrrAtw9N+HH3cKntzbesgez7Wm
         63O/bOiS8QaRh79TLD9lbgJYAhPXOud+bo4sLEjCOxz0hLHFFyZtSVL4Z/PAC1bkMF
         6TQ05OTRVwdaT49VLHoqkXku7T8bZTohwq4E151IhzG0YYW/GUCbrlo09FeFJtgAXc
         Li6rkKj/uQ77BgX+QOP+aaSxYQ3aDpSx4tg2uGHq+mjfogVu8tF90NAUTahOm4i/Gc
         38lfIxP+tmOiw==
Date:   Tue, 22 Mar 2022 13:51:51 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: linux-next: build warnings after merge of the tip tree
Message-Id: <20220322135151.307e7d7c478d1263e0eef43e@kernel.org>
In-Reply-To: <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
References: <20220321140327.777f9554@canb.auug.org.au>
        <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
        <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net>
        <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
        <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net>
        <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
        <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net>
        <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
        <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net>
        <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
        <20220322090541.7d06c8cb@canb.auug.org.au>
        <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
        <20220322094526.436ca4f7@elm.ozlabs.ibm.com>
        <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 15:50:17 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Mar 21, 2022 at 3:46 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi Alexei,
> >
> > On Mon, 21 Mar 2022 15:12:05 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > That makes little sense. It's not an unusual merge conflict.
> > > Peter's endbr series conflict with Masami's fprobe.
> > > Peter has a trivial patch that fixes objtool warning.
> > > The question is how to land that patch.
> > > I think the best is for Linus to apply it after bpf-next->net-next gets
> > > merged.
> >
> > Peter has other concerns, please read the thread and consider them.
> 
> Masami is an expert in kprobe. He copy pasted a bit of kprobe logic
> to make it into 'multi kprobe' (he calls it fprobe).
> I believe he knows what he's doing.
> Steven reviewed and tested that set.
> We've tested it as well and don't have any correctness or api concerns.

Sorry, that's my mistake to not Ccing to arch maintainers for the arch
dependent patches. Let me update and send v13 for this fprobe series.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
