Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57D45725E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhKSQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhKSQJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:09:11 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CC1C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 08:06:10 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id i9so10647039qki.3
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 08:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HFhcjl14oj6JKPH6G2Vmu003nCz3g5LyuBNRdC5X630=;
        b=4neyC06bXSazYMm8nXkFYvvWMrpH3uJUlR8hcXm1yWruiXZBaCqNUTMo70SJSa4JBl
         OvspU6Ls1poiQ6AXK58wWMM8S8TZcDD4UqV5FxTwjjanep5Qf0sNFfD+M0T4eWEkmNKD
         p2cV0ZYmwQiMbYU4QBg4j6qoqjwk4KIDAQ38k7AXAskxaBLFcYTHMSu5jnC9KUMJcEMa
         6t6YOIPZTLvCOcANUAD9ABCoJUKjUUIeaWH21mV5ym476dOkC0JYS4fPT0PwO9BeKmHY
         DMtUzPdEUxy6SFZp3K9JzrDdpoS4vhfnZ+Hknx1M0o8I6L8CS2chQ8I8k491epmPixGH
         T6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HFhcjl14oj6JKPH6G2Vmu003nCz3g5LyuBNRdC5X630=;
        b=bqW4+9RX84O8z//l18KqssinpvsI2TLuZktXVx5KuvHhYfGPBseO5N8Kp22gEZ3VmS
         enuhc1kaWC42RejZ6kewfVx2SFR0uD0E+vKhYM7kiDcLIUa7g5mqod0BOWSOL9G/ePRT
         Ve/ddl4vB7DcBvMbxr3R+mb/KAy8gHmVaK08IGDlbheGs/Dzn1aqLquzk6Q5RqAPBBeB
         0o6MQYds0pDFi0qTUzItscbryeY4/9ZAZ2c7kKZwoWiXVdtDeHc0LfGkvTeGglVdQ3S1
         rVKCno1rOK8D65RMJstl0ryUZuimqH/WzOfgq8SZ7bkAIaI+djyfjPdcarZFD3Stp9Fr
         xcqw==
X-Gm-Message-State: AOAM530CI9QRsqewMYmqx+efWvAVadGHUWJp7xj9Z8P5b3t2gTTjrjvW
        MHGae+57lYsDhMgFZmnMEWOQHQ==
X-Google-Smtp-Source: ABdhPJxKn2M9OnoZ13kpE/W37MCL5q5vgZsQvImymmI/TT90mia4a2sIIS4KzCQxeTCXqgSOCA0zlQ==
X-Received: by 2002:a37:44e:: with SMTP id 75mr28567014qke.417.1637337969203;
        Fri, 19 Nov 2021 08:06:09 -0800 (PST)
Received: from localhost (cpe-98-15-154-102.hvc.res.rr.com. [98.15.154.102])
        by smtp.gmail.com with ESMTPSA id j22sm68726qko.68.2021.11.19.08.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:06:08 -0800 (PST)
Date:   Fri, 19 Nov 2021 11:06:07 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Song Liu <songliubraving@fb.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Message-ID: <YZfLb/AEoA5UBAnY@cmpxchg.org>
References: <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
 <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
 <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
 <20211118185854.GL174703@worktop.programming.kicks-ass.net>
 <7DFF8615-6DEF-4CE6-8353-0AF48C204A84@fb.com>
 <YZdv/NLUU9qLHP2g@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZdv/NLUU9qLHP2g@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 10:35:56AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 19, 2021 at 04:14:46AM +0000, Song Liu wrote:
> > 
> > 
> > > On Nov 18, 2021, at 10:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > On Thu, Nov 18, 2021 at 06:39:49PM +0000, Song Liu wrote:
> > > 
> > >>> You're going to have to do that anyway if you're going to write to the
> > >>> directmap while executing from the alias.
> > >> 
> > >> Not really. If you look at current version 7/7, the logic is mostly 
> > >> straightforward. We just make all the writes to the directmap, while 
> > >> calculate offset from the alias. 
> > > 
> > > Then you can do the exact same thing but do the writes to a temp buffer,
> > > no different.
> > 
> > There will be some extra work, but I guess I will give it a try. 
> > 
> > > 
> > >>>> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
> > >>>> instructions (BPF instructions). So it could easily go beyond a few 
> > >>>> pages. Mapping the 2MB page all together should make the logic simpler. 
> > >>> 
> > >>> Then copy it in smaller chunks I suppose.
> > >> 
> > >> How fast/slow is the __text_poke routine? I guess we cannot do it thousands
> > >> of times per BPF program (in chunks of a few bytes)? 
> > > 
> > > You can copy in at least 4k chunks since any 4k will at most use 2
> > > pages, which is what it does. If that's not fast enough we can look at
> > > doing bigger chunks.
> > 
> > If we do JIT in a buffer first, 4kB chunks should be fast enough. 
> > 
> > Another side of this issue is the split of linear mapping (1GB => 
> > many 4kB). If we only split to PMD, but not PTE, we can probably 
> > recover most of the regression. I will check this with Johannes. 
> 
> __text_poke() shouldn't affect the fragmentation of the kernel
> mapping, it's a user-space alias into the same physical memory. For all
> it cares we're poking into GB pages.

Right, __text_poke won't, it's the initial set_memory_ro/x against the
vmap space that does it, since the linear mapping is updated as an
alias with the same granularity.

However, my guess would also be that once we stop doing that with 4k
pages for every single bpf program, and batch into shared 2M pages
instead, the problem will be much smaller. Maybe negligible.*

So ro linear mapping + __text_poke() sounds like a good idea to me.

[ If not, we could consider putting the linear mapping updates behind
  a hardening option similar to RETPOLINE, PAGE_TABLE_ISOLATION,
  STRICT_MODULE_RWX. The __text_poke() method would mean independence
  from the linear mapping and we can do with that what we want
  then. Many machines aren't exposed enough to necessarily care about
  W^X if the price is too high - and the impact of losing the GB
  mappings is actually significant on central workloads right now.

  But yeah, hopefully we won't have to go there. ]
