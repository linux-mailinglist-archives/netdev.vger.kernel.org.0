Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8F87B99
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406562AbfHINot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:44:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42058 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfHINos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:44:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so46078998pff.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cuW7kmnkjezQ8aMd9rmD4VTFMgZO6FdDUXYwitNe1k8=;
        b=vMdeXKEh7eFUUwZXTeO1KB3t0VYqnDsqK+Pe6NqWE1OkpDl66QSxelZSz3WvzqpJTI
         lzI9NW3hFpD7FCKLKeyZSp9vveeBagM1OsgpVPuDMEwu+qf7X9NR6Zu/m2BBRrx90BgV
         gcJk85qtmVkAmJUMHUn7lbeDAwl1oOmxx9IMsftUQ/XkpMYOML7igDGAPwGzVGMTC9FR
         TqIUJ6F7sk0mluIAfi3FrW58zIj8vfEKrKBOuw/y12LIOcV3S55PWuu5vpu9m45xbuNV
         oHhaGa7gGvU46H1K2qfUTbLHqJSJxoHwH2DcglgeZFx7FtT4NU5OSZLJKXfqlPTS77gu
         a7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cuW7kmnkjezQ8aMd9rmD4VTFMgZO6FdDUXYwitNe1k8=;
        b=Zq82kfeRtFVhcKQfA3K4avqcFH25pzZHWjliDdg66nOYfqzcfxxf5UoW8VnTuxdxtl
         hdynOUOkfkD1QtSRd566NblwPe1VtIHAPM6cHGct8KzR0/P0aR+pcnTZIZREmVHOThR5
         txqrWzdy6keePy/yiXgPy5UBRX2TXaKyK5UifpjHHEwogZFBrFZRmymsvEJyJ29uMiM9
         YxOTUI28QKa7OemLHs/XVvZjDlJHROony31FDl7yqjQpZlxe42lFk7sC/aQMqWXrcK0s
         8pWj00JcFHSq6OkqzHfLwTr6jmIkj9DJ80j+TosozE6MAlOJ02uOOCqQOCNR34BixaTC
         a+5Q==
X-Gm-Message-State: APjAAAVnJbs00dTdUMhg2+7Y4OruTkvhTNJTmZXqu9vAdrbx2oE8xTLc
        anbX48h0vW47z+1adZTprNcSJg==
X-Google-Smtp-Source: APXvYqzboj5qLeiqBXB007VpMJk0G9XY5d2C5KIpSxTqDgmDKjPfcxEEvfgm3VGFPm/6SzPcQqfycQ==
X-Received: by 2002:a17:90a:8a15:: with SMTP id w21mr9575094pjn.134.1565358287738;
        Fri, 09 Aug 2019 06:44:47 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id y128sm119018995pgy.41.2019.08.09.06.44.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 06:44:46 -0700 (PDT)
Date:   Fri, 9 Aug 2019 21:44:31 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf trace: Fix segmentation fault when access syscall
 info
Message-ID: <20190809134431.GE8313@leoy-ThinkPad-X240s>
References: <20190809104752.27338-1-leo.yan@linaro.org>
 <20190809132522.GB20899@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809132522.GB20899@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 10:25:22AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 09, 2019 at 06:47:52PM +0800, Leo Yan escreveu:
> > 'perf trace' reports the segmentation fault as below on Arm64:
> > 
> >   # perf trace -e string -e augmented_raw_syscalls.c
> >   LLVM: dumping tools/perf/examples/bpf/augmented_raw_syscalls.o
> >   perf: Segmentation fault
> >   Obtained 12 stack frames.
> >   perf(sighandler_dump_stack+0x47) [0xaaaaac96ac87]
> >   linux-vdso.so.1(+0x5b7) [0xffffadbeb5b7]
> >   /lib/aarch64-linux-gnu/libc.so.6(strlen+0x10) [0xfffface7d5d0]
> >   /lib/aarch64-linux-gnu/libc.so.6(_IO_vfprintf+0x1ac7) [0xfffface49f97]
> >   /lib/aarch64-linux-gnu/libc.so.6(__vsnprintf_chk+0xc7) [0xffffacedfbe7]
> >   perf(scnprintf+0x97) [0xaaaaac9ca3ff]
> >   perf(+0x997bb) [0xaaaaac8e37bb]
> >   perf(cmd_trace+0x28e7) [0xaaaaac8ec09f]
> >   perf(+0xd4a13) [0xaaaaac91ea13]
> >   perf(main+0x62f) [0xaaaaac8a147f]
> >   /lib/aarch64-linux-gnu/libc.so.6(__libc_start_main+0xe3) [0xfffface22d23]
> >   perf(+0x57723) [0xaaaaac8a1723]
> >   Segmentation fault
> > 
> > This issue is introduced by commit 30a910d7d3e0 ("perf trace:
> > Preallocate the syscall table"), it allocates trace->syscalls.table[]
> > array and the element count is 'trace->sctbl->syscalls.nr_entries';
> > but on Arm64, the system call number is not continuously used; e.g. the
> > syscall maximum id is 436 but the real entries is only 281.  So the
> > table is allocated with 'nr_entries' as the element count, but it
> > accesses the table with the syscall id, which might be out of the bound
> > of the array and cause the segmentation fault.
> > 
> > This patch allocates trace->syscalls.table[] with the element count is
> > 'trace->sctbl->syscalls.max_id + 1', this allows any id to access the
> > table without out of the bound.
> 
> Thanks a lot!

You are welcome, Arnaldo.

> My bad, that is why we have that max_id there, I forgot
> about it and since I tested so far only on x86_64... applied to
> perf/core, since it is only on:
> 
> [acme@quaco perf]$ git tag --contains 30a910d7d3e0
> perf-core-for-mingo-5.4-20190729
> [acme@quaco perf]$

Thanks!  Yes, I am working on perf/core branch and hit this issue.

Just in case Ingo has not merged your PR, if could save your efforts
it's quite fine for me to merge this change in your original patch.

Thanks,
Leo Yan

> 
> - Arnaldo
>  
> > Fixes: 30a910d7d3e0 ("perf trace: Preallocate the syscall table")
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  tools/perf/builtin-trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> > index 75eb3811e942..d553d06a9aeb 100644
> > --- a/tools/perf/builtin-trace.c
> > +++ b/tools/perf/builtin-trace.c
> > @@ -1492,7 +1492,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
> >  	const char *name = syscalltbl__name(trace->sctbl, id);
> >  
> >  	if (trace->syscalls.table == NULL) {
> > -		trace->syscalls.table = calloc(trace->sctbl->syscalls.nr_entries, sizeof(*sc));
> > +		trace->syscalls.table = calloc(trace->sctbl->syscalls.max_id + 1, sizeof(*sc));
> >  		if (trace->syscalls.table == NULL)
> >  			return -ENOMEM;
> >  	}
> > -- 
> > 2.17.1
> 
> -- 
> 
> - Arnaldo
