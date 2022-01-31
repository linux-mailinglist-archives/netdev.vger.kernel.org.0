Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235F34A45DB
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351701AbiAaLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:47:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380481AbiAaLpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643629533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hoFYGfluPusdpIx0z7ulqarblavPkRMbOpbOY+hsnMc=;
        b=MV737yRD1x/d8P8JQ1cDvzQJ6y0CKGxZMuhHOQwDKfvhfWoNTa+1KdU0p8czjKWh7kkLuq
        mXFURA07tN6Qzrnumv7/QY2qQLx9/NxBMRogFPUQ+yJ9NPPpQ4GAlxgd4Yuq+YFtUsTwN/
        Bkk4GsMl4wpGEFXdzyt7+djx4kb8cI0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-uvOWxrwtMKqKrF8jZHBaDA-1; Mon, 31 Jan 2022 06:45:32 -0500
X-MC-Unique: uvOWxrwtMKqKrF8jZHBaDA-1
Received: by mail-ed1-f70.google.com with SMTP id c23-20020a056402159700b00406aa42973eso6826649edv.2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:45:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hoFYGfluPusdpIx0z7ulqarblavPkRMbOpbOY+hsnMc=;
        b=05/7k/BZGXZU5et1ZGQWjE7UGGBo87OZV9L+UqFvHQTMPZUNhWh+zGMS6P235ZtPS/
         /4p7WZm1I/NlXGf0VSQw83AJPKrKSkDSVgVfL7CC0GleDTBt48UIjS4dFIACCeU7ZvTc
         XrWO/jrSw/NHoOEpKYrQAZsBc+iGNgl0ZH3+OaV8afBZ4JRv2ZlsJ6OWhbs/wN8jzszi
         tAdwfSlsSX+OUaFglSKgEyyJZQyYYTmXf2r5lC3m8zFH/5n0LXYbONrnrdORQLdCirwi
         MflvsVOCVhxPB+uuHtOU4Tr5Bo0JygHV7ppZa2fIXLAKmhRAf+qPEg7xBWgq6CO0HD0T
         Xycw==
X-Gm-Message-State: AOAM531SojVrK5p+QBSmLIyq+XwfSLGlDpruLUaepCE9Z6WpVtYlelKY
        T0mZC83mXOufML50YFCYM3U+pobyLy/u7cfpldV4eHkLU4dWuRdahyKfz5i8cKE59kU6Kc7c30H
        NnrbjxQQtfqSLuwFL
X-Received: by 2002:a17:907:3da8:: with SMTP id he40mr16485030ejc.146.1643629530797;
        Mon, 31 Jan 2022 03:45:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCPhmof2SHR2F4XPyoMObAr+XVZm4kbJ1j/8/xs2Yhwh/IbSeGoCugGupte2SySXNP0UDA1w==
X-Received: by 2002:a17:907:3da8:: with SMTP id he40mr16485014ejc.146.1643629530591;
        Mon, 31 Jan 2022 03:45:30 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id y23sm13375678ejp.116.2022.01.31.03.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 03:45:30 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:45:28 +0100
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
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YffL2G7XCAhB2cC1@krava>
References: <164360522462.65877.1891020292202285106.stgit@devnote2>
 <20220131183642.aba575006314b3988110a7e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131183642.aba575006314b3988110a7e5@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 06:36:42PM +0900, Masami Hiramatsu wrote:
> Hi Jiri,
> 
> On Mon, 31 Jan 2022 14:00:24 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > Hi,
> > 
> > Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> > ensures that exit_handler is not called after returning from the
> > unregister_fprobe(), and fixes some comments and documents.
> > 
> > The previous version is here[1];
> > 
> > [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> > 
> > This series introduces the fprobe, the function entry/exit probe
> > with multiple probe point support. This also introduces the rethook
> > for hooking function return as same as the kretprobe does. This
> > abstraction will help us to generalize the fgraph tracer,
> > because we can just switch to it from the rethook in fprobe,
> > depending on the kernel configuration.
> > 
> > The patch [1/10] is from Jiri's series[2].
> > 
> > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > 
> > And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> > if user wants to share the same code (or share a same resource) on the
> > fprobe and the kprobes.
> 
> If you want to work on this series, I pushed my working branch on here;
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mhiramat/linux.git/ kprobes/fprobe

great, I was going to ask for that ;-) thanks

jirka

> 
> Thank you,
> 
> > 
> > Thank you,
> > 
> > ---
> > 
> > Jiri Olsa (1):
> >       ftrace: Add ftrace_set_filter_ips function
> > 
> > Masami Hiramatsu (9):
> >       fprobe: Add ftrace based probe APIs
> >       rethook: Add a generic return hook
> >       rethook: x86: Add rethook x86 implementation
> >       ARM: rethook: Add rethook arm implementation
> >       arm64: rethook: Add arm64 rethook implementation
> >       fprobe: Add exit_handler support
> >       fprobe: Add sample program for fprobe
> >       fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
> >       docs: fprobe: Add fprobe description to ftrace-use.rst
> > 
> > 
> >  Documentation/trace/fprobe.rst                |  171 +++++++++++++
> >  Documentation/trace/index.rst                 |    1 
> >  arch/arm/Kconfig                              |    1 
> >  arch/arm/include/asm/stacktrace.h             |    4 
> >  arch/arm/kernel/stacktrace.c                  |    6 
> >  arch/arm/probes/Makefile                      |    1 
> >  arch/arm/probes/rethook.c                     |   71 +++++
> >  arch/arm64/Kconfig                            |    1 
> >  arch/arm64/include/asm/stacktrace.h           |    2 
> >  arch/arm64/kernel/probes/Makefile             |    1 
> >  arch/arm64/kernel/probes/rethook.c            |   25 ++
> >  arch/arm64/kernel/probes/rethook_trampoline.S |   87 ++++++
> >  arch/arm64/kernel/stacktrace.c                |    7 -
> >  arch/x86/Kconfig                              |    1 
> >  arch/x86/include/asm/unwind.h                 |    8 +
> >  arch/x86/kernel/Makefile                      |    1 
> >  arch/x86/kernel/kprobes/common.h              |    1 
> >  arch/x86/kernel/rethook.c                     |  115 ++++++++
> >  include/linux/fprobe.h                        |   97 +++++++
> >  include/linux/ftrace.h                        |    3 
> >  include/linux/kprobes.h                       |    3 
> >  include/linux/rethook.h                       |  100 +++++++
> >  include/linux/sched.h                         |    3 
> >  kernel/exit.c                                 |    2 
> >  kernel/fork.c                                 |    3 
> >  kernel/trace/Kconfig                          |   26 ++
> >  kernel/trace/Makefile                         |    2 
> >  kernel/trace/fprobe.c                         |  341 +++++++++++++++++++++++++
> >  kernel/trace/ftrace.c                         |   58 ++++
> >  kernel/trace/rethook.c                        |  313 +++++++++++++++++++++++
> >  samples/Kconfig                               |    7 +
> >  samples/Makefile                              |    1 
> >  samples/fprobe/Makefile                       |    3 
> >  samples/fprobe/fprobe_example.c               |  120 +++++++++
> >  34 files changed, 1572 insertions(+), 14 deletions(-)
> >  create mode 100644 Documentation/trace/fprobe.rst
> >  create mode 100644 arch/arm/probes/rethook.c
> >  create mode 100644 arch/arm64/kernel/probes/rethook.c
> >  create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S
> >  create mode 100644 arch/x86/kernel/rethook.c
> >  create mode 100644 include/linux/fprobe.h
> >  create mode 100644 include/linux/rethook.h
> >  create mode 100644 kernel/trace/fprobe.c
> >  create mode 100644 kernel/trace/rethook.c
> >  create mode 100644 samples/fprobe/Makefile
> >  create mode 100644 samples/fprobe/fprobe_example.c
> > 
> > --
> > Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 

