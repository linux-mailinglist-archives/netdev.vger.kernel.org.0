Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA8D87ED7
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436977AbfHIQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:03:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46710 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfHIQDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:03:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id j15so2687272qtl.13;
        Fri, 09 Aug 2019 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xel7PXRC4R/rnhsYvj8GQ1rwIBZrbD1zkzhd5zm878Y=;
        b=dQfJKfziUd5BIIhnmKWm5QryRbkd42Q1/Tnqs9KXosa0Fy7PZbBE7fjT4MT0IdoewE
         UWPZefpflc19oP5b3wSZasXpuBSi889ihXkxtmx/oNloLrWbnuRMATgEkXwbcTawsmDS
         5O0GCy94BjW2+OPefPjl9CeNMvGl3y6oegu6wKs25sqieb4mDwP5b1fsIaqPriPruhfu
         UAwOGrpIYKD1CiegfYKNBi38c3TJuvYaChrK5PPGLQJCYkEC6FIe5HeroupWFGt8khYP
         NkYiIrhKl8/a9sgqqbi/vIxkzLEkmYWbXbI7jPub80bLRxj0HAGdhtMlXR1fgfghfOQI
         oF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xel7PXRC4R/rnhsYvj8GQ1rwIBZrbD1zkzhd5zm878Y=;
        b=gdvfjhpyDYGWiTfTM7yuy38oW+wz2y5u5X0pEpEJP2/YmKFUEHeZ1VkoqPnYo5SIds
         VwGZzZziwjeiPLs7KEA/7SikQOXOvf0Vcmzd2Gbn6Fwze6iPbcnyjavSM1i9c+xycXnX
         MX8CFn949htokeOPs1HIUZQP6fiULKtrF6Q8Uemgav/z8YJMQWulZFYR0nGf8ygJ8o8g
         3GoDRvQf5JzkQ/cBslhhrv8N8bJ3CFiPQc+BYsyVNwo0mEGv/qlaSFWWar1ODGWixgkL
         RWMcx4lBR/slN5R2PZjo56+bsvH81jyp0EL8rcPpqspYhheqtPLJNz09C7JY7qD8XHFd
         bYnQ==
X-Gm-Message-State: APjAAAWouFa9t0MA5I1BJcevM9Os2HjNXoGfdMpJ4B9Y4rw/1dwvADTr
        zvlJSgCDh57lA4vJMwpi0uQ=
X-Google-Smtp-Source: APXvYqweXIEM9Qd18EZsE0BquWOtFBkkGxNWe1jzmCExse3IwwVkL7mR3t+QJkHssIVPoNGPHEMYcQ==
X-Received: by 2002:a0c:b59c:: with SMTP id g28mr18922345qve.244.1565366596692;
        Fri, 09 Aug 2019 09:03:16 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id o50sm14727107qtj.17.2019.08.09.09.03.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 09:03:13 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4EAED40340; Fri,  9 Aug 2019 13:03:11 -0300 (-03)
Date:   Fri, 9 Aug 2019 13:03:11 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf trace: Fix segmentation fault when access syscall
 info
Message-ID: <20190809160311.GA9280@kernel.org>
References: <20190809104752.27338-1-leo.yan@linaro.org>
 <20190809132522.GB20899@kernel.org>
 <20190809134431.GE8313@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809134431.GE8313@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Aug 09, 2019 at 09:44:31PM +0800, Leo Yan escreveu:
> On Fri, Aug 09, 2019 at 10:25:22AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Aug 09, 2019 at 06:47:52PM +0800, Leo Yan escreveu:
> > > 'perf trace' reports the segmentation fault as below on Arm64:
> > > 
> > >   # perf trace -e string -e augmented_raw_syscalls.c
> > >   LLVM: dumping tools/perf/examples/bpf/augmented_raw_syscalls.o
> > >   perf: Segmentation fault
> > >   Obtained 12 stack frames.
> > >   perf(sighandler_dump_stack+0x47) [0xaaaaac96ac87]
> > >   linux-vdso.so.1(+0x5b7) [0xffffadbeb5b7]
> > >   /lib/aarch64-linux-gnu/libc.so.6(strlen+0x10) [0xfffface7d5d0]
> > >   /lib/aarch64-linux-gnu/libc.so.6(_IO_vfprintf+0x1ac7) [0xfffface49f97]
> > >   /lib/aarch64-linux-gnu/libc.so.6(__vsnprintf_chk+0xc7) [0xffffacedfbe7]
> > >   perf(scnprintf+0x97) [0xaaaaac9ca3ff]
> > >   perf(+0x997bb) [0xaaaaac8e37bb]
> > >   perf(cmd_trace+0x28e7) [0xaaaaac8ec09f]
> > >   perf(+0xd4a13) [0xaaaaac91ea13]
> > >   perf(main+0x62f) [0xaaaaac8a147f]
> > >   /lib/aarch64-linux-gnu/libc.so.6(__libc_start_main+0xe3) [0xfffface22d23]
> > >   perf(+0x57723) [0xaaaaac8a1723]
> > >   Segmentation fault
> > > 
> > > This issue is introduced by commit 30a910d7d3e0 ("perf trace:
> > > Preallocate the syscall table"), it allocates trace->syscalls.table[]
> > > array and the element count is 'trace->sctbl->syscalls.nr_entries';
> > > but on Arm64, the system call number is not continuously used; e.g. the
> > > syscall maximum id is 436 but the real entries is only 281.  So the
> > > table is allocated with 'nr_entries' as the element count, but it
> > > accesses the table with the syscall id, which might be out of the bound
> > > of the array and cause the segmentation fault.
> > > 
> > > This patch allocates trace->syscalls.table[] with the element count is
> > > 'trace->sctbl->syscalls.max_id + 1', this allows any id to access the
> > > table without out of the bound.
> > 
> > Thanks a lot!
> 
> You are welcome, Arnaldo.
> 
> > My bad, that is why we have that max_id there, I forgot
> > about it and since I tested so far only on x86_64... applied to
> > perf/core, since it is only on:
> > 
> > [acme@quaco perf]$ git tag --contains 30a910d7d3e0
> > perf-core-for-mingo-5.4-20190729
> > [acme@quaco perf]$
> 
> Thanks!  Yes, I am working on perf/core branch and hit this issue.
> 
> Just in case Ingo has not merged your PR, if could save your efforts
> it's quite fine for me to merge this change in your original patch.

This got already merged into tip/perf/core, so no way to combine both by
now, unfortunately, would be good for bisection purposes on ARM64,
agreed, but not possible.

Thanks again,

- Arnaldo
 
> Thanks,
> Leo Yan
> 
> > 
> > - Arnaldo
> >  
> > > Fixes: 30a910d7d3e0 ("perf trace: Preallocate the syscall table")
> > > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > > ---
> > >  tools/perf/builtin-trace.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > > index 75eb3811e942..d553d06a9aeb 100644
> > > --- a/tools/perf/builtin-trace.c
> > > +++ b/tools/perf/builtin-trace.c
> > > @@ -1492,7 +1492,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
> > >  	const char *name = syscalltbl__name(trace->sctbl, id);
> > >  
> > >  	if (trace->syscalls.table == NULL) {
> > > -		trace->syscalls.table = calloc(trace->sctbl->syscalls.nr_entries, sizeof(*sc));
> > > +		trace->syscalls.table = calloc(trace->sctbl->syscalls.max_id + 1, sizeof(*sc));
> > >  		if (trace->syscalls.table == NULL)
> > >  			return -ENOMEM;
> > >  	}
> > > -- 
> > > 2.17.1
> > 
> > -- 
> > 
> > - Arnaldo

-- 

- Arnaldo
