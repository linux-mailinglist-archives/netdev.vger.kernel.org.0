Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D3B48EC54
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiANPKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:10:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235727AbiANPKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642173053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWNup3WEK+Z5PYvEX6Ms7ECgpaqQd6Nt47Sgqvp9kdY=;
        b=HJENiktQDRINq4WIJIhHT8eubGYyefKyH3l73YH39q3TuWOH5PIfPE+xqzeM/ERsll45T6
        I7OZWsBgJLooM0zRZPwpW1Q/OQhx6yZV1hlH8bdvKVScWbQuHqBAp/xbk9sOnAl6iEfgfU
        LguumwOl9tWY5IvVUw/SQhcIDdzQx94=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-I7eD-tH2OJ2jUKeI2cE77g-1; Fri, 14 Jan 2022 10:10:52 -0500
X-MC-Unique: I7eD-tH2OJ2jUKeI2cE77g-1
Received: by mail-wr1-f71.google.com with SMTP id r10-20020adfa14a000000b001a375e65e60so1877561wrr.2
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oWNup3WEK+Z5PYvEX6Ms7ECgpaqQd6Nt47Sgqvp9kdY=;
        b=TWYLC8wlcE35T4Y8g2W7H9K4fQnGK8Rejw6lnI8HB8qFLTQ26lGrm5rdHlTQg26HvZ
         Ut3pgov4HojYCgr+zhMN71buODCslcX/STvWU+oVXymxaTZ9LFfuvFgRRvV0uyIx+kMc
         czA1Sahgf5D+hzc2++HEo2Zxg9AQFR/gs0G2W+T2rHPMkGkyWlEuWv24JWW4djWUPBJF
         pq4LeBgt1K84cWCk/WGn3K4zQSzbZ+B2scvUD24Pgo/Slz+Ps7Qjx8WMTfAdmze21BZv
         IHkjyPIPDpkTY9Q5t+ii6qs8eLVtylIEDiW6B/XlwZmwVVMiLN8B4Yf65KczuHShweTw
         WPJQ==
X-Gm-Message-State: AOAM5320EfdLk7MsHmS2aBJl/txo3m7x5KPGRSQzY8d4rk/REEsdGxN4
        fRddKgGfzbnbTzM276aNTSK/3wevP3DyhJ2V3cZnmSpmzPFyDAN4XcZk97nvhqVgUXlIfayidKj
        ZzKntLjX/pyGpjBQZ
X-Received: by 2002:a05:6000:1b89:: with SMTP id r9mr8674441wru.21.1642173050399;
        Fri, 14 Jan 2022 07:10:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIxW0LiuEHZAvE09eBmv2dyUKtwMR7glNZj7KgwqRqhx1HI+o0ZcrknrMO+E1oJUHtv91AhQ==
X-Received: by 2002:a05:6000:1b89:: with SMTP id r9mr8674412wru.21.1642173050166;
        Fri, 14 Jan 2022 07:10:50 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id p18sm5136909wma.40.2022.01.14.07.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 07:10:49 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:10:48 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YeGSeGVnBnEHXTtj@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
 <Yd77SYWgtrkhFIYz@krava>
 <YeAatqQTKsrxmUkS@krava>
 <20220114234704.41f28e8b5e63368c655d848e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114234704.41f28e8b5e63368c655d848e@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 11:47:04PM +0900, Masami Hiramatsu wrote:
> Hi Jiri and Alexei,
> 
> On Thu, 13 Jan 2022 13:27:34 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > > Hi Jiri and Alexei,
> > > > 
> > > > Here is the 2nd version of fprobe. This version uses the
> > > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > > Note that this also drops per-probe point private data, which
> > > > is not used anyway.
> > > > 
> > > > This introduces the fprobe, the function entry/exit probe with
> > > > multiple probe point support. This also introduces the rethook
> > > > for hooking function return as same as kretprobe does. This
> > > 
> > > nice, I was going through the multi-user-graph support 
> > > and was wondering that this might be a better way
> > > 
> > > > abstraction will help us to generalize the fgraph tracer,
> > > > because we can just switch it from rethook in fprobe, depending
> > > > on the kernel configuration.
> > > > 
> > > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > > patches will not be affected by this change.
> > > 
> > > I'll try the bpf selftests on top of this
> > 
> > I'm getting crash and stall when running bpf selftests,
> > the fprobe sample module works fine, I'll check on that
> 
> I've tried to build tools/testing/selftests/bpf on my machine,
> but I got below errors. Would you know how I can setup to build
> the bpf selftests correctly? (I tried "make M=samples/bpf", but same result)

what's your clang version? your distro might be behind,
I'm using clang 14 compiled from sources:

	$ /opt/clang/bin/clang --version
	clang version 14.0.0 (https://github.com/llvm/llvm-project.git 9f8ffaaa0bddcefeec15a3df9858fd50b05fcbae)
	Target: x86_64-unknown-linux-gnu
	Thread model: posix
	InstalledDir: /opt/clang/bin

and compiling bpf selftests with:

	$ CLANG=/opt/clang/bin/clang make

jirka


> 
> ~/ksrc/linux/tools/testing/selftests/bpf$ make 
> [...]
>   CLANG   /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.bpf.o
> skeleton/pid_iter.bpf.c:35:10: error: incomplete definition of type 'struct bpf_link'
>                 return BPF_CORE_READ((struct bpf_link *)ent, id);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:403:2: note: expanded from macro 'BPF_CORE_READ'
>         ___type((src), a, ##__VA_ARGS__) __r;                               \
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:274:29: note: expanded from macro '___type'
> #define ___type(...) typeof(___arrow(__VA_ARGS__))
>                             ^~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:272:23: note: expanded from macro '___arrow'
> #define ___arrow(...) ___apply(___arrow, ___narg(__VA_ARGS__))(__VA_ARGS__)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:223:25: note: expanded from macro '___concat'
> #define ___concat(a, b) a ## b
>                         ^
> <scratch space>:16:1: note: expanded from here
> ___arrow2
> ^
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:263:26: note: expanded from macro '___arrow2'
> #define ___arrow2(a, b) a->b
>                         ~^
> skeleton/pid_iter.bpf.c:35:32: note: forward declaration of 'struct bpf_link'
>                 return BPF_CORE_READ((struct bpf_link *)ent, id);
>                                              ^
> skeleton/pid_iter.bpf.c:35:10: error: incomplete definition of type 'struct bpf_link'
>                 return BPF_CORE_READ((struct bpf_link *)ent, id);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:404:2: note: expanded from macro 'BPF_CORE_READ'
>         BPF_CORE_READ_INTO(&__r, (src), a, ##__VA_ARGS__);                  \
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:311:2: note: expanded from macro 'BPF_CORE_READ_INTO'
>         ___core_read(bpf_core_read, bpf_core_read,                          \
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:302:2: note: expanded from macro '___core_read'
>         ___apply(___core_read, ___empty(__VA_ARGS__))(fn, fn_ptr, dst,      \
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:296:2: note: expanded from macro '___core_read0'
>         ___read(fn, dst, ___type(src), src, a);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:277:59: note: expanded from macro '___read'
>         read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:206:79: note: expanded from macro 'bpf_core_read'
>         bpf_probe_read_kernel(dst, sz, (const void *)__builtin_preserve_access_index(src))
>                                                                                      ^~~
> skeleton/pid_iter.bpf.c:35:32: note: forward declaration of 'struct bpf_link'
>                 return BPF_CORE_READ((struct bpf_link *)ent, id);
>                                              ^
> skeleton/pid_iter.bpf.c:35:10: error: returning 'void' from a function with incompatible result type '__u32' (aka 'unsigned int')
>                 return BPF_CORE_READ((struct bpf_link *)ent, id);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:402:36: note: expanded from macro 'BPF_CORE_READ'
> #define BPF_CORE_READ(src, a, ...) ({                                       \
>                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> skeleton/pid_iter.bpf.c:42:17: warning: declaration of 'struct bpf_iter__task_file' will not be visible outside of this function [-Wvisibility]
> int iter(struct bpf_iter__task_file *ctx)
>                 ^
> skeleton/pid_iter.bpf.c:44:25: error: incomplete definition of type 'struct bpf_iter__task_file'
>         struct file *file = ctx->file;
>                             ~~~^
> skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
> int iter(struct bpf_iter__task_file *ctx)
>                 ^
> skeleton/pid_iter.bpf.c:45:32: error: incomplete definition of type 'struct bpf_iter__task_file'
>         struct task_struct *task = ctx->task;
>                                    ~~~^
> skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
> int iter(struct bpf_iter__task_file *ctx)
>                 ^
> skeleton/pid_iter.bpf.c:76:19: error: incomplete definition of type 'struct bpf_iter__task_file'
>         bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
>                       ~~~^
> skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
> int iter(struct bpf_iter__task_file *ctx)
>                 ^
> 1 warning and 6 errors generated.
> make[1]: *** [Makefile:188: /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.bpf.o] Error 1
> make: *** [Makefile:219: /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/sbin/bpftool] Error 2
> 
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 

