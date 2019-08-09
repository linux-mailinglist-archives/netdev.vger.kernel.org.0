Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72AC87B18
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407072AbfHINZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:25:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40408 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406273AbfHINZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:25:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id s145so71595691qke.7;
        Fri, 09 Aug 2019 06:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2ZrY/b4WntgdLGp44kkX12ktRp+3EYn+/QxZioshkhU=;
        b=Cf5fmB7mzINWWtrGpKp//JYl/uShFrRYFRezo/n+I+yOCKP6rkv6U92vt0YdSYbgSo
         0BhJVMNKmLB+Gs4wXSgvOj+yXSLtGc1lg5dzWXvSCXyOzMpG3CDDUkrieA0maDrwwWY5
         fWvyhyNA88Ohw/5spZ+0mSk51Mlnn/vXYgsedRAN219VgyMt0gcD1xKOAYd3rQWcP8N9
         1+6tStmEY6eLumRqFIcvMMPSXVpywmgg5emaN9h/TqI+sCJu+MLhkeP0lUy1LMd/44pt
         0EArm9PRrnH6wdGOlUrqqg09ViTBXGWEIt/pwRfVbtrGWCkDorcBu6qePEDjmcXb/E0r
         Betg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2ZrY/b4WntgdLGp44kkX12ktRp+3EYn+/QxZioshkhU=;
        b=SQOfEPs5p0680gDlJzvZyRsTs2yLZliarEY4D2dCk1EnDMU6JUX3smVwbFN6l9cTby
         DCVkeYWnZlZv8hgetM+b3tJzgQN+f5Pg+JxNz4et55mdkJDcVpZAVLc7x64MXzNRiQr4
         cYOwgpQExKK/vwU53Nblj2P3izetXqN15ycrQw/cWG6PqJBbltuOCzrUh2ndDA7Pkeab
         o6aa/OBe7FFer5+83KogClgRcBFkkMn33KzOYe4yXV5RbqQ0vrMqfgyNxl3OthORGUP7
         dxrjQzj5ugo8kg8PgD+ohm0lLpQJTnzfThP6pi+7UJBTr2++qtmdIMJzG46mdBD2yKTq
         ZV6A==
X-Gm-Message-State: APjAAAU3NdAOrH4OMwaSxBS/NR5hHOznR2jIwMRbxLNZbzkzEq7Q0SnA
        FWcAR/JeEVV+aXia5ObVKGM=
X-Google-Smtp-Source: APXvYqwFMz2xOQB1F9Th3KiEIo21jHYwJ4apOW05gm1IGEUJFXLHHHJDAkaGMO/oVYNrOB9QG70F7Q==
X-Received: by 2002:a37:c87:: with SMTP id 129mr16707779qkm.240.1565357129652;
        Fri, 09 Aug 2019 06:25:29 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id z18sm39964608qki.110.2019.08.09.06.25.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:25:29 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8885440340; Fri,  9 Aug 2019 10:25:22 -0300 (-03)
Date:   Fri, 9 Aug 2019 10:25:22 -0300
To:     Leo Yan <leo.yan@linaro.org>
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
Message-ID: <20190809132522.GB20899@kernel.org>
References: <20190809104752.27338-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809104752.27338-1-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Aug 09, 2019 at 06:47:52PM +0800, Leo Yan escreveu:
> 'perf trace' reports the segmentation fault as below on Arm64:
> 
>   # perf trace -e string -e augmented_raw_syscalls.c
>   LLVM: dumping tools/perf/examples/bpf/augmented_raw_syscalls.o
>   perf: Segmentation fault
>   Obtained 12 stack frames.
>   perf(sighandler_dump_stack+0x47) [0xaaaaac96ac87]
>   linux-vdso.so.1(+0x5b7) [0xffffadbeb5b7]
>   /lib/aarch64-linux-gnu/libc.so.6(strlen+0x10) [0xfffface7d5d0]
>   /lib/aarch64-linux-gnu/libc.so.6(_IO_vfprintf+0x1ac7) [0xfffface49f97]
>   /lib/aarch64-linux-gnu/libc.so.6(__vsnprintf_chk+0xc7) [0xffffacedfbe7]
>   perf(scnprintf+0x97) [0xaaaaac9ca3ff]
>   perf(+0x997bb) [0xaaaaac8e37bb]
>   perf(cmd_trace+0x28e7) [0xaaaaac8ec09f]
>   perf(+0xd4a13) [0xaaaaac91ea13]
>   perf(main+0x62f) [0xaaaaac8a147f]
>   /lib/aarch64-linux-gnu/libc.so.6(__libc_start_main+0xe3) [0xfffface22d23]
>   perf(+0x57723) [0xaaaaac8a1723]
>   Segmentation fault
> 
> This issue is introduced by commit 30a910d7d3e0 ("perf trace:
> Preallocate the syscall table"), it allocates trace->syscalls.table[]
> array and the element count is 'trace->sctbl->syscalls.nr_entries';
> but on Arm64, the system call number is not continuously used; e.g. the
> syscall maximum id is 436 but the real entries is only 281.  So the
> table is allocated with 'nr_entries' as the element count, but it
> accesses the table with the syscall id, which might be out of the bound
> of the array and cause the segmentation fault.
> 
> This patch allocates trace->syscalls.table[] with the element count is
> 'trace->sctbl->syscalls.max_id + 1', this allows any id to access the
> table without out of the bound.

Thanks a lot! My bad, that is why we have that max_id there, I forgot
about it and since I tested so far only on x86_64... applied to
perf/core, since it is only on:

[acme@quaco perf]$ git tag --contains 30a910d7d3e0
perf-core-for-mingo-5.4-20190729
[acme@quaco perf]$

- Arnaldo
 
> Fixes: 30a910d7d3e0 ("perf trace: Preallocate the syscall table")
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/builtin-trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 75eb3811e942..d553d06a9aeb 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1492,7 +1492,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
>  	const char *name = syscalltbl__name(trace->sctbl, id);
>  
>  	if (trace->syscalls.table == NULL) {
> -		trace->syscalls.table = calloc(trace->sctbl->syscalls.nr_entries, sizeof(*sc));
> +		trace->syscalls.table = calloc(trace->sctbl->syscalls.max_id + 1, sizeof(*sc));
>  		if (trace->syscalls.table == NULL)
>  			return -ENOMEM;
>  	}
> -- 
> 2.17.1

-- 

- Arnaldo
