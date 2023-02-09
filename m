Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5568FBD8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBIALO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBIALN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:11:13 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBC811EA1;
        Wed,  8 Feb 2023 16:11:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m8so624588edd.10;
        Wed, 08 Feb 2023 16:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dOTjgYcWhqkMuhNenPNI1XlMmaNHM0OOaClLZboB/Wg=;
        b=T83OX4EGnLSsuZ/1Jmo85gnC4KAwJ/j8TzibjPSwXWVdj4nwI3zeuGIoCvSxp02BTW
         RshIZyAY861CFrHXzK77FTX2kzrdkwR/vluOLyHkxzSFc8e5uPOyFK9yYRoGtWEbox4s
         A6gZ1ghgDQCpqgGLg/3FKJZyq64z4RE7lCTqPu9GS29CWM07AuPsk4/Zv94ySlXfgpx3
         ytoKJiluVr90bcEo4hD/jynwQFykTla7UkQ0+iVm/rsMMElH9Wt7trRi+atzFnDPGTI3
         gLpbBja79tGys+tPZf+E1Ew0ccBS+Bv1d4UrMtuT8Mb14xuuATLgA9DpiG/t05MSrffr
         EnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOTjgYcWhqkMuhNenPNI1XlMmaNHM0OOaClLZboB/Wg=;
        b=MX5aaqPXZmnpSFrFELVhGWe5Kheb/hnbgppsKyhG9kSm+ynxgcKCotaXVMfcgvHYK4
         we174NP0ad7dEYBvSRastqf7D1T98jAOo4rAN1wJLpOQUlD/YBDkKL0Iqg5MYD+OMOmB
         gxKHALi3omBeHUNLFXKEtkMNViuOAcWn1+54I9OBriS30UAitnAI6bfLCnhtg2xi8q50
         1cU1ZJsbtxBapKb6y9zP6Q5si1d2JPoaSEDQMKm+K2Lw8P2JGlIZMAPbZiqVn5STfEqR
         Ak7uc8yZTdRdj5akfWZ4SuSD9WGXaB3UGJ3FcGFx0nZ0UHdyuD882PwpKoNJmtptkPRG
         azTA==
X-Gm-Message-State: AO0yUKWZsVVPeGf444edRjxKaoDI83JzKC9r+DFsWC3wcg3jEPdR3uRl
        sjzanFUeHTMrpaUD4Uw8l7SaQHlfO2MlGpUUKmFMhWVrxCM=
X-Google-Smtp-Source: AK7set8WGUS985JMz7z6vFLrlEJRzZJTSTm0/SygyG7AOs5OLC2GbWPDFFSscHF6uKvNYoysgu3zyt3I2z9+U9IhvvA=
X-Received: by 2002:a50:d717:0:b0:4aa:a4e6:b323 with SMTP id
 t23-20020a50d717000000b004aaa4e6b323mr2388298edi.34.1675901470226; Wed, 08
 Feb 2023 16:11:10 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com>
In-Reply-To: <Y+QaZtz55LIirsUO@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 8 Feb 2023 16:10:59 -0800
Message-ID: <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     John Stultz <jstultz@google.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 2:01 PM John Stultz <jstultz@google.com> wrote:
>
> On Sat, Nov 20, 2021 at 11:27:38AM +0000, Yafang Shao wrote:
> > As the sched:sched_switch tracepoint args are derived from the kernel,
> > we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
> > converted to type enum, then all the BPF programs can get it through BTF.
> >
> > The BPF program which wants to use TASK_COMM_LEN should include the header
> > vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> > type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> > need to include linux/bpf.h again.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  include/linux/sched.h                                   | 9 +++++++--
> >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
> >  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
> >  3 files changed, 13 insertions(+), 8 deletions(-)
>
> Hey all,
>   I know this is a little late, but I recently got a report that
> this change was causiing older versions of perfetto to stop
> working.
>
> Apparently newer versions of perfetto has worked around this
> via the following changes:
>   https://android.googlesource.com/platform/external/perfetto/+/c717c93131b1b6e3705a11092a70ac47c78b731d%5E%21/
>   https://android.googlesource.com/platform/external/perfetto/+/160a504ad5c91a227e55f84d3e5d3fe22af7c2bb%5E%21/
>
> But for older versions of perfetto, reverting upstream commit
> 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16
> with TASK_COMM_LEN") is necessary to get it back to working.
>
> I haven't dug very far into the details, and obviously this doesn't
> break with the updated perfetto, but from a high level this does
> seem to be a breaking-userland regression.
>
> So I wanted to reach out to see if there was more context for this
> breakage? I don't want to raise a unnecessary stink if this was
> an unfortuante but forced situation.

Let me understand what you're saying...

The commit 3087c61ed2c4 did

-/* Task command name length: */
-#define TASK_COMM_LEN                  16
+/*
+ * Define the task command name length as enum, then it can be visible to
+ * BPF programs.
+ */
+enum {
+       TASK_COMM_LEN = 16,
+};


and that caused:

cat /sys/kernel/debug/tracing/events/task/task_newtask/format

to print
field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
instead of
field:char comm[16];    offset:12;    size:16;    signed:0;

so the ftrace parsing android tracing tool had to do:

-  if (Match(type_and_name.c_str(), R"(char [a-zA-Z_]+\[[0-9]+\])")) {
+  if (Match(type_and_name.c_str(),
+            R"(char [a-zA-Z_][a-zA-Z_0-9]*\[[a-zA-Z_0-9]+\])")) {

to workaround this change.
Right?

And what are you proposing?
