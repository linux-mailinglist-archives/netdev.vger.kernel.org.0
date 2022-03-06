Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDEC4CEC84
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiCFRac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCFRab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:30:31 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532093F30B;
        Sun,  6 Mar 2022 09:29:38 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i66so7867803wma.5;
        Sun, 06 Mar 2022 09:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EVoER95T2o/GpvU6idrc7FMQDCSGYEbQ4IrkJTPWTQs=;
        b=WCMPNKVsSqp9sr3yDiBz3Dx050tobhtNg66N2JIkmI+vAM41yIPTKzzHTHwV719uAA
         WS7uWguRklJCqX8X2zGz28b7tpSL0ylh86cr617XVpMHdLAwU439wgHwivujeA5HUiLY
         aqfZ3RXm1gog/PMCcOeUhpdk/FuFPCWpJzFc/dFTt0zINhDMwbPhZJYOkhKG2yeaHywN
         XDDxzf1EFQki8S9NCBsF3MJ0SLLaS2JeEcZG9eqIVaAV8pCCIyBfZTiMsZFhieqHG7t3
         R53ilTC1t6hNHfGYvluxzOn9xkWapIuqVo6WaMzMEog6kyUIVGQrXmvEikTnJ0Jw8St2
         uj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EVoER95T2o/GpvU6idrc7FMQDCSGYEbQ4IrkJTPWTQs=;
        b=USKoD2SLLlLV5NrgCQv7Qcw7HLTmVqH9n5P6lYscl4EcuBElTG+gufCLZvmbHXswOK
         doimKF9ZM4ALxXU5WwON9ZNDqTnwdhlFbcCzVRZ4DKBd7PKcZd0xmaG8Cad2n9mV+rKV
         Ehy/YRgPsQCL+wzzWa4a7N2XbYJKciAlmL426mdtAtO6RZyU+ciarO6n+/HjfGKWEb0a
         uxPyiJPVKEYmHSpICfb2YELCQwDpq3VY7D49y1IpVZy6euAw9l02jBOX5hxrWXQmh1GU
         26ReR8GXYBPeu2xFKBsH0q/72Uo9GOqNfznBuW6yCpbhBl+tLzVXcxk/skpgknShF8Uu
         yEvQ==
X-Gm-Message-State: AOAM5302MrTIwz/vqI1/6nEUQhwsCo0NPFBo87n1WZabbkA8MO3taU0d
        4qSVMHmUwtrZh/A0p7tuvjw=
X-Google-Smtp-Source: ABdhPJxgWAVfrmhzONlUDAbefwK0uM/S6gRYexSJtMl1Asoia8izqGtwo2fncamguBIuMifbfK0UWg==
X-Received: by 2002:a7b:ca54:0:b0:388:a579:d0ea with SMTP id m20-20020a7bca54000000b00388a579d0eamr13209621wml.192.1646587776775;
        Sun, 06 Mar 2022 09:29:36 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c351100b00381807bd920sm11777262wmq.28.2022.03.06.09.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:29:36 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:29:34 +0100
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
Subject: Re: [PATCH 09/10] selftest/bpf: Add kprobe_multi attach test
Message-ID: <YiTvfh3HLVMGA59z@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-10-jolsa@kernel.org>
 <CAEf4BzZ+6SN4BRFKEBePqyjB2-Xw49tKa3rpmxt8-qDwONXC8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ+6SN4BRFKEBePqyjB2-Xw49tKa3rpmxt8-qDwONXC8w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:23PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 9:08 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding kprobe_multi attach test that uses new fprobe interface to
> > attach kprobe program to multiple functions.
> >
> > The test is attaching programs to bpf_fentry_test* functions and
> > uses single trampoline program bpf_prog_test_run to trigger
> > bpf_fentry_test* functions.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> subj typo: selftest -> selftests

ok

> 
> >  .../bpf/prog_tests/kprobe_multi_test.c        | 115 ++++++++++++++++++
> >  .../selftests/bpf/progs/kprobe_multi.c        |  58 +++++++++
> >  2 files changed, 173 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
> >
> 
> [...]
> 
> > +
> > +static void test_link_api_addrs(void)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > +       __u64 addrs[8];
> > +
> > +       kallsyms_find("bpf_fentry_test1", &addrs[0]);
> > +       kallsyms_find("bpf_fentry_test2", &addrs[1]);
> > +       kallsyms_find("bpf_fentry_test3", &addrs[2]);
> > +       kallsyms_find("bpf_fentry_test4", &addrs[3]);
> > +       kallsyms_find("bpf_fentry_test5", &addrs[4]);
> > +       kallsyms_find("bpf_fentry_test6",  &addrs[5]);
> > +       kallsyms_find("bpf_fentry_test7", &addrs[6]);
> > +       kallsyms_find("bpf_fentry_test8", &addrs[7]);
> 
> ASSERT_OK() that symbols are found? It also sucks that we re-parse
> kallsyms so much...

ok

> 
> maybe use load_kallsyms() to pre-cache? We should also teach
> load_kallsyms() to not reload kallsyms more than once

true, it saved many cycles in bpftrace ;-) will check


> 
> > +
> > +       opts.kprobe_multi.addrs = (__u64) addrs;
> > +       opts.kprobe_multi.cnt = 8;
> 
> ARRAY_SIZE()?

ok

> 
> > +       test_link_api(&opts);
> > +}
> > +
> > +static void test_link_api_syms(void)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> 
> nit: just LIBBPF_OPTS

ok

> 
> > +       const char *syms[8] = {
> > +               "bpf_fentry_test1",
> > +               "bpf_fentry_test2",
> > +               "bpf_fentry_test3",
> > +               "bpf_fentry_test4",
> > +               "bpf_fentry_test5",
> > +               "bpf_fentry_test6",
> > +               "bpf_fentry_test7",
> > +               "bpf_fentry_test8",
> > +       };
> > +
> > +       opts.kprobe_multi.syms = (__u64) syms;
> > +       opts.kprobe_multi.cnt = 8;
> 
> ARRAY_SIZE() ?

ok

> 
> > +       test_link_api(&opts);
> > +}
> > +
> > +void test_kprobe_multi_test(void)
> > +{
> > +       test_skel_api();
> > +       test_link_api_syms();
> > +       test_link_api_addrs();
> 
> model as subtests?

ok

thanks,
jirka
