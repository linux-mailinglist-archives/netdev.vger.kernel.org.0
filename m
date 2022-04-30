Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415A515CB2
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiD3MRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiD3MRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:17:37 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08EE5DA15;
        Sat, 30 Apr 2022 05:14:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g6so19982717ejw.1;
        Sat, 30 Apr 2022 05:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/jfovHtyZZT8UGa+5lJb6NNtCHtSd4My+TA0EpMI4Fk=;
        b=GuEpnbw6PUM0fvvsV8VKpTrflzI0jE2Ah706hdy5wqmqBfJdWPFvEZ5aZ7SzNLDGNG
         bd/DqjsLcC8bxVwibuwthI0A92PxO2Q3NswE0wyKPuaXD4OK20kmvddIRkm9VnfIeZtS
         qDogt5WIGokcrT/vTb6q6R4nttbH6538QObpmQK3jE8lYCMxS9SivsRZ3yUbzZJm3J1U
         xlJDuQkZICmCHEIufP5pYnJ4L7GB3e7wB695yTfFGx15YQr9DepHyWnkK8b/ZA2Xr+Cp
         LYqfZLOY7WT7v3iuYbnxGG2mnt78blhxAX9PMphHm3Do4EWurw9aA+qvljh3NmlY5brQ
         9AhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/jfovHtyZZT8UGa+5lJb6NNtCHtSd4My+TA0EpMI4Fk=;
        b=VHfeMLQTQZBxhS22I3c/DcopSaDJe3oZ1ajACIu89u3ByRVNwGCK1Rn5XOE6+MdJ6N
         GdKbMLUigLfN5P1k9gd9709xh9s3+MDMidvV/zzXQw3iMuf+NX3bjKsFQ0y3JgUaTjal
         Ten3zkdQcpsGc3Pqp+3MJoiV3cBhKyzFI+y66iAVPTzjyxVe2AJyPFXaRGcr5XKtOE60
         dqfrEyvmUNhvJVHUBrlnKW6ZSaRst14xUojdHMQWEJp/Ehj9wgt12S41UIQcZakuSPWm
         qr4QGfiBVwvSX62Zm3ylNQI57Jn3fzkWi+yp48rYgo9Vo2QCCm6SiQwupn2U53rbZnwp
         5Wnw==
X-Gm-Message-State: AOAM532oAoQ9mMQuYqan4KFGFQQ5bjN81vpxTLNR+WNlJxItRkhNHl8d
        gqoy79Gj01MEI2D0jJqeA1U=
X-Google-Smtp-Source: ABdhPJw8j5vmadM7g0XYE5gZ7bDUENaNxNYR8LVX/NXw/Qdo7m2M1oepu76le7mR00v5ONMC1rEAQw==
X-Received: by 2002:a17:906:b006:b0:6f3:dcf0:6f6f with SMTP id v6-20020a170906b00600b006f3dcf06f6fmr3776553ejy.649.1651320854150;
        Sat, 30 Apr 2022 05:14:14 -0700 (PDT)
Received: from krava ([95.82.134.228])
        by smtp.gmail.com with ESMTPSA id zp15-20020a17090684ef00b006f3ef214e4esm1539083ejb.180.2022.04.30.05.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 05:14:13 -0700 (PDT)
Date:   Sat, 30 Apr 2022 14:14:10 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv4 bpf-next 0/5] bpf: Speed up symbol resolving in kprobe
 multi link
Message-ID: <Ym0oEo4iwr4F2jMT@krava>
References: <20220428201207.954552-1-jolsa@kernel.org>
 <CAEf4BzYtXWvBWzmadhLGqwf8_e2sruK6999th6c=b=O0WLkHOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYtXWvBWzmadhLGqwf8_e2sruK6999th6c=b=O0WLkHOA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 07:28:11AM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 28, 2022 at 1:12 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > sending additional fix for symbol resolving in kprobe multi link
> > requested by Alexei and Andrii [1].
> >
> > This speeds up bpftrace kprobe attachment, when using pure symbols
> > (3344 symbols) to attach:
> >
> > Before:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> >
> > After:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> >
> > v4 changes:
> >   - fix compile issue [kernel test robot]
> >   - added acks [Andrii]
> >
> > v3 changes:
> >   - renamed kallsyms_lookup_names to ftrace_lookup_symbols
> >     and moved it to ftrace.c [Masami]
> >   - added ack [Andrii]
> >   - couple small test fixes [Andrii]
> >
> > v2 changes (first version [2]):
> >   - removed the 2 seconds check [Alexei]
> >   - moving/forcing symbols sorting out of kallsyms_lookup_names function [Alexei]
> >   - skipping one array allocation and copy_from_user [Andrii]
> >   - several small fixes [Masami,Andrii]
> >   - build fix [kernel test robot]
> >
> > thanks,
> > jirka
> >
> >
> > [1] https://lore.kernel.org/bpf/CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com/
> > [2] https://lore.kernel.org/bpf/20220407125224.310255-1-jolsa@kernel.org/
> > ---
> > Jiri Olsa (5):
> >       kallsyms: Fully export kallsyms_on_each_symbol function
> >       ftrace: Add ftrace_lookup_symbols function
> >       fprobe: Resolve symbols with ftrace_lookup_symbols
> >       bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
> >       selftests/bpf: Add attach bench test
> >
> 
> Please check [0], it reports rcu_read_unlock() misuse
> 
>   [0] https://github.com/kernel-patches/bpf/runs/6223167405?check_suite_focus=true

hm, first I though it might be related to the bench test
attaching to 'bad' function, but the the warning showed
before that

will try to reproduce  with the CI .config

jirka


> 
> >  include/linux/ftrace.h                                     |   6 ++++++
> >  include/linux/kallsyms.h                                   |   7 ++++++-
> >  kernel/kallsyms.c                                          |   3 +--
> >  kernel/trace/bpf_trace.c                                   | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
> >  kernel/trace/fprobe.c                                      |  32 ++++++++++++--------------------
> >  kernel/trace/ftrace.c                                      |  62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/kprobe_multi_empty.c     |  12 ++++++++++++
> >  8 files changed, 298 insertions(+), 69 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
