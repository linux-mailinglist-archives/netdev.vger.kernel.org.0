Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9791C226E
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 05:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgEBDG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 23:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgEBDG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 23:06:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F8AC061A0C;
        Fri,  1 May 2020 20:06:27 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b6so1066257plz.13;
        Fri, 01 May 2020 20:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rcS4SXJymg0omkgwuj5pE9mFl3v8Rk4xC5SV4SXTbU0=;
        b=FMAsEtV5IC6Ybl5Ntwwx86lb1DzFrAMQ2gtpD8nyX8PCtc3I/FUR85pC2zXHLb66J3
         J20hi2yunHAsctwl/0p/iKytjxq5++8rUzzWVCFXS424OVFqLsz7l/nU/WUfzbSbkLhE
         mxz4nj7FgxIhPratVYkRp3v1siGSmjIa/fft136HCC6qOKsy5jQtGOVezmftwwCioAL4
         vCBPzDGrlBDcRkJcxWAzpvXyWNlE9tKNyDu76bH2TMTN3HD62QTmpbf2x2N3hWtvZ3jr
         jr4dNLGZNDUU56dmOj4Iqz70xQ3z0U+wYKe0JgPxSzJ/SnE44C2uS8gid9XKSDi9W6x3
         1ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rcS4SXJymg0omkgwuj5pE9mFl3v8Rk4xC5SV4SXTbU0=;
        b=txaYyKwcEROKp6gJTYkLPSBt5YJnd1e3m3vjDM5z/dzBrEb8p5vwtEpozqQs7vPGC7
         fO/2bHwG0yQbYSPCr2ZxY74+uNGL2PwgXIsE/fVbEA3ysophlajhDrvud23lskymuQII
         7l0BngFaj9+90EGb3BLa0NyU658SdFx3OBdLY78A5BoQ4nLqJ/VxUUA8sXujnMQJYp53
         PibcZ40txYJ/5ymwUQqsRez0d/WEVU+Dj/lXCudHXo0uIpBUZjTAZVR7qwv6zE6uC+BU
         SNJpjYzJgdSE4cFHpLiSUcKUi/TurkTsEXgR56FPL/FDASdqlNJQD4hTAJvQV0320sPp
         a20g==
X-Gm-Message-State: AGi0PuZ0Tmo0uL9VFHIy3HMGINrH8huXFEjU+SWN4b9wNEekNl7UVJL2
        XQiHK8bgTRs2/LOxF7QVTgAs9n67
X-Google-Smtp-Source: APiQypJwSi7uyKe7pfSh23iLnlJVy8UfrL8U1ha0uzoV2a2qUI6uw4LeDDm1wK3FfaHtSscbIsKJAg==
X-Received: by 2002:a17:90a:3509:: with SMTP id q9mr3152343pjb.121.1588388786336;
        Fri, 01 May 2020 20:06:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e9ae])
        by smtp.gmail.com with ESMTPSA id a26sm3041659pgd.68.2020.05.01.20.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 20:06:25 -0700 (PDT)
Date:   Fri, 1 May 2020 20:06:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501195617.czrnfqqcxfnliz3k@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 02:56:17PM -0500, Josh Poimboeuf wrote:
> On Fri, May 01, 2020 at 12:40:53PM -0700, Alexei Starovoitov wrote:
> > On Fri, May 01, 2020 at 02:22:04PM -0500, Josh Poimboeuf wrote:
> > > On Fri, May 01, 2020 at 12:09:30PM -0700, Alexei Starovoitov wrote:
> > > > On Thu, Apr 30, 2020 at 02:07:43PM -0500, Josh Poimboeuf wrote:
> > > > > Objtool decodes instructions and follows all potential code branches
> > > > > within a function.  But it's not an emulator, so it doesn't track
> > > > > register values.  For that reason, it usually can't follow
> > > > > intra-function indirect branches, unless they're using a jump table
> > > > > which follows a certain format (e.g., GCC switch statement jump tables).
> > > > > 
> > > > > In most cases, the generated code for the BPF jump table looks a lot
> > > > > like a GCC jump table, so objtool can follow it.  However, with
> > > > > RETPOLINE=n, GCC keeps the jump table address in a register, and then
> > > > > does 160+ indirect jumps with it.  When objtool encounters the indirect
> > > > > jumps, it can't tell which jump table is being used (or even whether
> > > > > they might be sibling calls instead).
> > > > > 
> > > > > This was fixed before by disabling an optimization in ___bpf_prog_run(),
> > > > > using the "optimize" function attribute.  However, that attribute is bad
> > > > > news.  It doesn't append options to the command-line arguments.  Instead
> > > > > it starts from a blank slate.  And according to recent GCC documentation
> > > > > it's not recommended for production use.  So revert the previous fix:
> > > > > 
> > > > >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > > > 
> > > > > With that reverted, solve the original problem in a different way by
> > > > > getting rid of the "goto select_insn" indirection, and instead just goto
> > > > > the jump table directly.  This simplifies the code a bit and helps GCC
> > > > > generate saner code for the jump table branches, at least in the
> > > > > RETPOLINE=n case.
> > > > > 
> > > > > But, in the RETPOLINE=y case, this simpler code actually causes GCC to
> > > > > generate far worse code, ballooning the function text size by +40%.  So
> > > > > leave that code the way it was.  In fact Alexei prefers to leave *all*
> > > > > the code the way it was, except where needed by objtool.  So even
> > > > > non-x86 RETPOLINE=n code will continue to have "goto select_insn".
> > > > > 
> > > > > This stuff is crazy voodoo, and far from ideal.  But it works for now.
> > > > > Eventually, there's a plan to create a compiler plugin for annotating
> > > > > jump tables.  That will make this a lot less fragile.
> > > > 
> > > > I don't like this commit log.
> > > > Here you're saying that the code recognized by objtool is sane and good
> > > > whereas well optimized gcc code is somehow voodoo and bad.
> > > > That is just wrong.
> > > 
> > > I have no idea what you're talking about.
> > > 
> > > Are you saying that ballooning the function text size by 40% is well
> > > optimized GCC code?  It seems like a bug to me.  That's the only place I
> > > said anything bad about GCC code.
> > 
> > It could be a bug, but did you benchmark the speed of interpreter ?
> > Is it faster or slower with 40% more code ?
> > Did you benchmark it on other archs ?
> 
> I thought we were in agreement that 40% text growth is bad.  Isn't that
> why you wanted to keep 'goto select_insn' for the retpoline case?

Let me see whether I got this right.
In first the sentence above you're claiming that I've agreed that 
'goto select_insn' is bad for retpoline case and in the second sentence
you're saying that I wanted to keep it because it's bad?
In other words you're saying I wanted bad code for retpoline case for
some mischievous purpose?
Do you really think so or just trolling?

Let's look at the facts.
I've applied your patch and the kernel crashed on the very first test in
selftests/bpf which makes me believe that you only compile tested it.
Taking the question "is 40% text growth is bad?" out of context... Ohh yes.
but if 40% extra code gives 10% speedup to interpreter it's suddenly good, right?
Since you didn't run basic tests I don't think you've tested performance either.
So this direct->indirect patch might cause performance degradation to
architectures that don't have JIT.
On x86-64 JIT=y is the default, so I'm fine taking that performance risk
only for the case where that risk has to be taken. In other words to help
objtool understand the code and only for the case where objtool cannot do
it with existing code.
The 40% potential text decrease after direct->indirect transiton is
irrelevant here. It must be a separate patch after corresponding
performance benchmarking is done.
Just claiming in commit log that current code is obviously bad
is misleading to folks who will be reading it later.

Also as I explained earlier direct->indirect in C is not a contract
for the compiler. Currently there is single C line:
goto *jumptable[insn->code];
but gcc/clang may generate arbitrary number of indirect jumps
for this function.
Changing the macro from "goto select_insn" to "goto *jumptable"
messes with compiler optimizations and there is no guarantee
that the code is going to be better or worse.
Why do you think there are two identical macros there?
#define CONT     ({ insn++; goto select_insn; })
#define CONT_JMP ({ insn++; goto select_insn; })
Why not one?
The answer is in old patch from 2014:
https://patchwork.ozlabs.org/project/netdev/patch/1393910304-4004-2-git-send-email-ast@plumgrid.com/
+#define CONT ({insn++; LOAD_IMM; goto select_insn; })
+#define CONT_JMP ({insn++; LOAD_IMM; goto select_insn; })
+/* some compilers may need help:
+ * #define CONT_JMP ({insn++; LOAD_IMM; goto *jumptable[insn->code]; })
+ */

That was the patch after dozens of performance experiments
with different gcc versions on different cpus.
Six years ago the interpreter performance could be improved
if _one_ of these macros replaced direct with indirect
for certain versions of gcc. But not both macros.

To be honest I don't think you're interested in doing performance
analysis here. You just want to shut up that objtool warning and
move on, right? So please do so without making misleading statements
about goodness or badness of generated code.

Thanks
