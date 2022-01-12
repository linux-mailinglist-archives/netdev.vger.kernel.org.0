Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E20C48C7CB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354919AbiALQBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:01:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349597AbiALQBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642003278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=61jkuwvVXvuFtimMSu8IeQNNLzj0gYj5g/G0tQLun4o=;
        b=RaZhHO9cvRnhfVHq79pEbMkvOUp9Hi3Xh8b34xMIXIEYR/cgJ532K1HFur99PGu2ect2aJ
        aZrC6fQ37j6xcq2+CJKmbCQbiQGAsvbL9sLTCP23MzFGpmorii/yVeduScK6oTaNZF64gb
        7TQFoIS09bpmLs891mVl59UI82QeBas=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-oEjT0oknOyqNE8XivZ0nCQ-1; Wed, 12 Jan 2022 11:01:17 -0500
X-MC-Unique: oEjT0oknOyqNE8XivZ0nCQ-1
Received: by mail-ed1-f69.google.com with SMTP id j10-20020a05640211ca00b003ff0e234fdfso2716807edw.0
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 08:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=61jkuwvVXvuFtimMSu8IeQNNLzj0gYj5g/G0tQLun4o=;
        b=f3D7JmPi2/Y11tlL37PLktH5q30DM/5oSN0I0F9h0avqr9htfFBCbfjbU2XV+uCQBN
         wZVJhG0P0K6MXp4YajyWn51jfAYpVBid11wJ4UHCDgy1QOR2zGE5ery+QYRZAA3ybYA3
         NtusekMRgQtXPGdx47NArAgM/ROjAFoKvuOgKte1UnE1db3eG7/JHmDrRqD47UdxSMcp
         RvQnRlPSc7sJ+uB/NEWjdTO9tm0ylj4SxH+Uv1TbIic8nRUiuKeSywiCnZlkGREh9vc8
         GKWeJgOLQv7daehXc5KYP7Kxt/+VRo9OTBrYuIMECx/EtciotHrkEiOTlYN73FjVNR1K
         N1sg==
X-Gm-Message-State: AOAM5327Dc8vXYeAQ7Vjcj/GDlZIRaHHACP8RZ0uBA6TOOXsQPXJuBOU
        TgyoAF4sPAF9BcjvtlC3bX10ikrhdi7dz37y9/L3/f2z4oX1CwgZ5uFO4Fbz1YYK5JR0moEu4e3
        a4mgxkLo9fkBsvAUb
X-Received: by 2002:a17:907:8a14:: with SMTP id sc20mr302783ejc.312.1642003275945;
        Wed, 12 Jan 2022 08:01:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxGt6hG1hH0dOVq6f/p2z8HN7LPcMPdtYQjVG0H4X9gj95ZjcBiN/8cWzbbMtxEHAc87CxqQ==
X-Received: by 2002:a17:907:8a14:: with SMTP id sc20mr302756ejc.312.1642003275652;
        Wed, 12 Jan 2022 08:01:15 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id p3sm40988ejo.61.2022.01.12.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 08:01:15 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:01:13 +0100
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
Message-ID: <Yd77SYWgtrkhFIYz@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164199616622.1247129.783024987490980883.stgit@devnote2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> Hi Jiri and Alexei,
> 
> Here is the 2nd version of fprobe. This version uses the
> ftrace_set_filter_ips() for reducing the registering overhead.
> Note that this also drops per-probe point private data, which
> is not used anyway.
> 
> This introduces the fprobe, the function entry/exit probe with
> multiple probe point support. This also introduces the rethook
> for hooking function return as same as kretprobe does. This

nice, I was going through the multi-user-graph support 
and was wondering that this might be a better way

> abstraction will help us to generalize the fgraph tracer,
> because we can just switch it from rethook in fprobe, depending
> on the kernel configuration.
> 
> The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> patches will not be affected by this change.

I'll try the bpf selftests on top of this

> 
> [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> 
> I also added an out-of-tree (just for testing) patch at the
> end of this series ([8/8]) for adding a wildcard support to
> the sample program. With that patch, it shows how long the
> registration will take;
> 
> # time insmod fprobe_example.ko symbol='btrfs_*'
> [   36.130947] fprobe_init: 1028 symbols found
> [   36.177901] fprobe_init: Planted fprobe at btrfs_*
> real    0m 0.08s
> user    0m 0.00s
> sys     0m 0.07s

I'll run my bpftrace tests on top of that

thanks,
jirka

> 
> Thank you,
> 
> ---
> 
> Jiri Olsa (2):
>       ftrace: Add ftrace_set_filter_ips function
>       bpf: Add kprobe link for attaching raw kprobes
> 
> Masami Hiramatsu (6):
>       fprobe: Add ftrace based probe APIs
>       rethook: Add a generic return hook
>       rethook: x86: Add rethook x86 implementation
>       fprobe: Add exit_handler support
>       fprobe: Add sample program for fprobe
>       [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample
> 
> 
>  arch/x86/Kconfig                |    1 
>  arch/x86/kernel/Makefile        |    1 
>  arch/x86/kernel/rethook.c       |  115 ++++++++++++++++++++
>  include/linux/bpf_types.h       |    1 
>  include/linux/fprobe.h          |   57 ++++++++++
>  include/linux/ftrace.h          |    3 +
>  include/linux/rethook.h         |   74 +++++++++++++
>  include/linux/sched.h           |    3 +
>  include/uapi/linux/bpf.h        |   12 ++
>  kernel/bpf/syscall.c            |  195 +++++++++++++++++++++++++++++++++-
>  kernel/exit.c                   |    2 
>  kernel/fork.c                   |    3 +
>  kernel/kallsyms.c               |    1 
>  kernel/trace/Kconfig            |   22 ++++
>  kernel/trace/Makefile           |    2 
>  kernel/trace/fprobe.c           |  168 +++++++++++++++++++++++++++++
>  kernel/trace/ftrace.c           |   54 ++++++++-
>  kernel/trace/rethook.c          |  226 +++++++++++++++++++++++++++++++++++++++
>  samples/Kconfig                 |    7 +
>  samples/Makefile                |    1 
>  samples/fprobe/Makefile         |    3 +
>  samples/fprobe/fprobe_example.c |  154 +++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h  |   12 ++
>  23 files changed, 1103 insertions(+), 14 deletions(-)
>  create mode 100644 arch/x86/kernel/rethook.c
>  create mode 100644 include/linux/fprobe.h
>  create mode 100644 include/linux/rethook.h
>  create mode 100644 kernel/trace/fprobe.c
>  create mode 100644 kernel/trace/rethook.c
>  create mode 100644 samples/fprobe/Makefile
>  create mode 100644 samples/fprobe/fprobe_example.c
> 
> --
> Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
> 

