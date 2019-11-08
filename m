Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAFF5B9E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKHXF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:05:29 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33892 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHXF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:05:29 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so5850861pff.1;
        Fri, 08 Nov 2019 15:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uVow6JqXxpLA3BRONlweqDMZCyRX7TOJPSQCFGOONeU=;
        b=hqVgdy2+VedAre5Kgqg/3lJ9f1oo25OZO51ytlRJyam+89fuZQEM45SWZ1wUu5lz9T
         pBlOCK4C3pVgodxRilCNrb/1l0WEGeg/RV0j74pDj1iN+uOoiSEdjHjA8QILKJTWAmPD
         Ph5B4/BUfvH/oXxbbFubY5qQ4dFkLfq/orQ/oHzlXOA9ntEL92SYl6mUseBa77b9Fvzr
         QHVg+ACnnnnpXL+ZHA/zMGO9w8Is0L8yT7pJwTrWYvG1V5h9CU2gDC0SD5Y4YDbzZirS
         yM4QukG01pvzt+giPB1WhLMDe1QVkogxXyPm6tqehQkijmv2pq1GQPVufpcie9Nx5a3v
         GXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uVow6JqXxpLA3BRONlweqDMZCyRX7TOJPSQCFGOONeU=;
        b=Cpq0C6/ZBE7PfOube/HJ0ItUG9MDMbQRXSr29BwkGaY6CzCAfmXOqMPVITQf8vbxwE
         PG4mzstz0+N2vS2qFVkFxTD53B1IZo4FZn63D8gKkPlYCbzerUJGZup6XPGkA3xN5Mak
         omneF7l7J0Td3V/Ktwhmj7ZhmEfbFoMg8AR0oplBzpG2yWaYFAx5ObheKUbpdaIBHWeD
         5g2zYlCAQ5087+2CnJ0m5gWnXI4tXGpZYMIEeMAyLA4e7vnE+KIGerl13E5dQ4U7khbj
         IiX9PFyvWLPzGV/paaKZ2VltILt9AN3zlcF8nJRbCIRwQuM95Ca8Pv97Qy/2jJ5jyl80
         kx7w==
X-Gm-Message-State: APjAAAWF6p6kXZZyfMl6urmkg10S9VG+65ncbt4BhMNywS0sIZdOcG7L
        LH7yCXgSY6Elmf/jH2h7Suw=
X-Google-Smtp-Source: APXvYqyGVkzEFjMJi45DCayB1/aa6gPTSWdRLqKw7uMSpgOyYpNcuhvAxD8XBSBuKlgbbARhfaE3RQ==
X-Received: by 2002:a62:7f93:: with SMTP id a141mr14890368pfd.107.1573254328054;
        Fri, 08 Nov 2019 15:05:28 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:f248])
        by smtp.gmail.com with ESMTPSA id o1sm6348523pgm.1.2019.11.08.15.05.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:05:27 -0800 (PST)
Date:   Fri, 8 Nov 2019 15:05:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191108230524.4j5jui2izyexxhkx@ast-mbp.dhcp.thefacebook.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
 <20191108091156.GG4114@hirez.programming.kicks-ass.net>
 <20191108093607.GO5671@hirez.programming.kicks-ass.net>
 <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
 <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
 <20191108213624.GM3079@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108213624.GM3079@worktop.programming.kicks-ass.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 10:36:24PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 08, 2019 at 11:32:41AM -0800, Alexei Starovoitov wrote:
> > On Fri, Nov 8, 2019 at 5:42 AM Alexei Starovoitov <ast@fb.com> wrote:
> > >
> > > On 11/8/19 1:36 AM, Peter Zijlstra wrote:
> > > > On Fri, Nov 08, 2019 at 10:11:56AM +0100, Peter Zijlstra wrote:
> > > >> On Thu, Nov 07, 2019 at 10:40:23PM -0800, Alexei Starovoitov wrote:
> > > >>> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> > > >>> nops/calls in kernel text into calls into BPF trampoline and to patch
> > > >>> calls/nops inside BPF programs too.
> > > >>
> > > >> This thing assumes the text is unused, right? That isn't spelled out
> > > >> anywhere. The implementation is very much unsafe vs concurrent execution
> > > >> of the text.
> > > >
> > > > Also, what NOP/CALL instructions will you be hijacking? If you're
> > > > planning on using the fentry nops, then what ensures this and ftrace
> > > > don't trample on one another? Similar for kprobes.
> > > >
> > > > In general, what ensures every instruction only has a single modifier?
> > >
> > > Looks like you didn't bother reading cover letter and missed a month
> 
> I did indeed not. A Changelog should be self sufficient and this one is
> sorely lacking. The cover leter is not preserved and should therefore
> not contain anything of value that is not also covered in the
> Changelogs.
> 
> > > of discussions between my and Steven regarding exactly this topic
> > > though you were directly cc-ed in all threads :(
> 
> I read some of it; it is a sad fact that I cannot read all email in my
> inbox, esp. not if, like in the last week or so, I'm busy hunting a
> regression.
> 
> And what I did remember of the emails I saw left me with the questions
> that were not answered by the changelog.
> 
> > > tldr for kernel fentry nops it will be converted to use
> > > register_ftrace_direct() whenever it's available.
> 
> So why the rush and not wait for that work to complete? It appears to me
> that without due coordination between bpf and ftrace badness could
> happen.
> 
> > > For all other nops, calls, jumps that are inside BPF programs BPF infra
> > > will continue modifying them through this helper.
> > > Daniel's upcoming bpf_tail_call() optimization will use text_poke as well.
> 
> This is probably off topic, but isn't tail-call optimization something
> done at JIT time and therefore not in need ot text_poke()?

Not quite. bpf_tail_call() are done via prog_array which is indirect jmp and
it suffers from retpoline. The verifier can see that in a lot of cases the
prog_array is used with constant index into array instead of a variable. In
such case indirect jmps can be optimized with direct jmps. That is
essentially what Daniel's patches are doing that are building on top of
bpf_arch_text_poke() and trampoline that I'm introducing in this set.

Another set is being prepared by Bjorn that also builds on top of
bpf_arch_text_poke() and trampoline. It's serving the purpose of getting rid of
indirect call when driver calls into BPF program for the first time. We've
looked at your static_call and concluded that it doesn't quite cut for this use
case.

The third framework is worked on by Martin. Who is using BPF trampoline for
BPF-based TCP extensions. This bit is not related to indirect call/jmp
optimization, but needs trampoline.

> > I was thinking more about this.
> > Peter,
> > do you mind we apply your first patch:
> > https://lore.kernel.org/lkml/20191007081944.88332264.2@infradead.org/
> > to both tip and bpf-next trees?
> 
> That would indeed be a much better solution. I'll repost much of that on
> Monday, and then we'll work on getting at the very least that one patch
> in a tip/branch we can share.

Awesome! I can certainly wait till next week. I just don't want to miss the
merge window for the work that it is ready. More below.

> > Then I can use text_poke_bp() as-is without any additional ugliness
> > on my side that would need to be removed in few weeks.
> 
> This I do _NOT_ understand. Why are you willing to merge a known broken
> patch? What is the rush, why can't you wait for all the prerequisites to
> land?

People have deadlines and here I'm not talking about fb deadlines. If it was
only up to me I could have waited until yours and Steven's patches land in
Linus's tree. Then Dave would pick them up after the merge window into net-next
and bpf things would be ready for the next release. Which is in 1.5 + 2 + 8
weeks (assuming 1.5 weeks until merge window, 2 weeks merge window, and 8
weeks next release cycle).
But most of bpf things are ready. I have one more follow up to do for another
feature. The first 4-5 patches of my set will enable Bjorn, Daniel, and
Martin's work. So I'm mainly looking for a way to converge three trees during
the merge window with no conflicts.

Just saw that Steven posted his set. That is great. If you land your first part
of text_poke_pb() next week into tip it will enable us to cherry-pick the first
few patches from tip and continue with bpf trampoline in net-next. Then during
the merge window tip, Steven's and net-next land into Linus's tree. Then I'll
send small follow up to switch to Steven's register_ftrace_direct() in places
that can use it and the other bits of bpf will keep using yours text_poke_bp()
because it's for the code inside generated bpf progs, various generated
trampolines and such. The conversion of some of bpf bits to
register_ftrace_direct() can be delayed by a release if really necessary. Since
text_poke_bp() approach will work fine, just not as nice if there is a full
integration via ftrace.
imo it's the best path for 3 trees to converge without delaying things for bpf
folks by a full release. At the end the deadlines are met and a bunch of people
are unblocked and happy. I hope that explains the rush.

