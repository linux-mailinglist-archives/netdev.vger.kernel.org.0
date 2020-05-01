Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45731C1DFD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEATk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgEATk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:40:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BEEC061A0C;
        Fri,  1 May 2020 12:40:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so4981634pgo.3;
        Fri, 01 May 2020 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oLnnyH+czrM+8LcEZNTG0jVqN3FviRiw3C4w4cH0SOk=;
        b=mFdBBh0b6aFeXnmmYgVjWvP1fstPsKM2YVQUXP8bDONh7YeqA5IKe8FJt05AUPijQ9
         7ddYY7PRgHXy7UoznaaN/x58jB9km6ejE6R4YtXahcPzAf5PiKGWgQ+8ys5CRT1nQ8ET
         Mu0tbJFxOHuDOVP9cEN5+dfABvLDry9K/RKv0OxGNgV2ZXq1jvW7aWT55exXZmMfyQkG
         x+nTel7rpvHwPMQmdGI0kpi5yNKpuMEkA/ZWJcyNrHA9cnOhOdSCHR0+9ZQpzwlgYys2
         AbGEMwGOSkJJ8lo/9OwyM9YQqnJA5KQhM2NslVHWWlHs5j99dYTdUAFH9Z8DxYujUZkD
         NhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oLnnyH+czrM+8LcEZNTG0jVqN3FviRiw3C4w4cH0SOk=;
        b=LWmc/tusDnhnqgDelB/UvG4t9aLGwzf4ht3yjyqVZgLFlaTAgpeP/UvMQHHeTXjYRw
         ru1cGDowdQyhlEoCLN3SAE/WZus1SKBM4I9mq1xEOKJ/TVUeGQi2CGJBXrPOrncXC553
         Fs0heXcmMoo7lPFCvx8nqO2UrvflhTlHCPBCcsWHXU86XmbqXZag2moLM4/VGJvqF67M
         7+jNndrsRIew9xxuStrKgxBWtsYZe+2gLHN6iFShoJcdlt/Berh5xIWQluuNMaXGfIbg
         cHqfc4jX9c4G6kVlNLA76bA2bSkuPjiepQNb7IPkPaDL5bSGXQ3PrGjtd3mRX1seXOvu
         M//A==
X-Gm-Message-State: AGi0PuZ6+ltcIFz6yavh2gKDX95T5ptNwDuUbh0LGAKWg4Wba56nG4NX
        vHt0y6Irs+EANrqmHYGx7xU=
X-Google-Smtp-Source: APiQypLDRleIBIMm7Rv0W2x5Vs5Kn9IzTi53Q4zM75AqHHb/8I/38a54fLLuOAN9eAZVAZslnjGXjQ==
X-Received: by 2002:a62:1d48:: with SMTP id d69mr5636438pfd.102.1588362056997;
        Fri, 01 May 2020 12:40:56 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8cd4])
        by smtp.gmail.com with ESMTPSA id u14sm2558880pgh.71.2020.05.01.12.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 12:40:56 -0700 (PDT)
Date:   Fri, 1 May 2020 12:40:53 -0700
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
Message-ID: <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501192204.cepwymj3fln2ngpi@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 02:22:04PM -0500, Josh Poimboeuf wrote:
> On Fri, May 01, 2020 at 12:09:30PM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 30, 2020 at 02:07:43PM -0500, Josh Poimboeuf wrote:
> > > Objtool decodes instructions and follows all potential code branches
> > > within a function.  But it's not an emulator, so it doesn't track
> > > register values.  For that reason, it usually can't follow
> > > intra-function indirect branches, unless they're using a jump table
> > > which follows a certain format (e.g., GCC switch statement jump tables).
> > > 
> > > In most cases, the generated code for the BPF jump table looks a lot
> > > like a GCC jump table, so objtool can follow it.  However, with
> > > RETPOLINE=n, GCC keeps the jump table address in a register, and then
> > > does 160+ indirect jumps with it.  When objtool encounters the indirect
> > > jumps, it can't tell which jump table is being used (or even whether
> > > they might be sibling calls instead).
> > > 
> > > This was fixed before by disabling an optimization in ___bpf_prog_run(),
> > > using the "optimize" function attribute.  However, that attribute is bad
> > > news.  It doesn't append options to the command-line arguments.  Instead
> > > it starts from a blank slate.  And according to recent GCC documentation
> > > it's not recommended for production use.  So revert the previous fix:
> > > 
> > >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > 
> > > With that reverted, solve the original problem in a different way by
> > > getting rid of the "goto select_insn" indirection, and instead just goto
> > > the jump table directly.  This simplifies the code a bit and helps GCC
> > > generate saner code for the jump table branches, at least in the
> > > RETPOLINE=n case.
> > > 
> > > But, in the RETPOLINE=y case, this simpler code actually causes GCC to
> > > generate far worse code, ballooning the function text size by +40%.  So
> > > leave that code the way it was.  In fact Alexei prefers to leave *all*
> > > the code the way it was, except where needed by objtool.  So even
> > > non-x86 RETPOLINE=n code will continue to have "goto select_insn".
> > > 
> > > This stuff is crazy voodoo, and far from ideal.  But it works for now.
> > > Eventually, there's a plan to create a compiler plugin for annotating
> > > jump tables.  That will make this a lot less fragile.
> > 
> > I don't like this commit log.
> > Here you're saying that the code recognized by objtool is sane and good
> > whereas well optimized gcc code is somehow voodoo and bad.
> > That is just wrong.
> 
> I have no idea what you're talking about.
> 
> Are you saying that ballooning the function text size by 40% is well
> optimized GCC code?  It seems like a bug to me.  That's the only place I
> said anything bad about GCC code.

It could be a bug, but did you benchmark the speed of interpreter ?
Is it faster or slower with 40% more code ?
Did you benchmark it on other archs ?

> When I said "this stuff is crazy voodoo" I was referring to the patch
> itself.  I agree it's horrible, it's only the best approach we're able
> to come up with at the moment.

please reword it then.
