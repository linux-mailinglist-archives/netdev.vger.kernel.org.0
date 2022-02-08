Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB04AE566
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 00:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiBHXYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 18:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiBHXYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 18:24:21 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B83C061576;
        Tue,  8 Feb 2022 15:24:19 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id b5so291358ile.11;
        Tue, 08 Feb 2022 15:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icW1CmJt7V7nnYt5AEHzW1LfQUR9u0/06jxrbW0ydIE=;
        b=jWTvazfUXIGZM4J993OHGxm2ZT3pV/4rQPbUpZfltxws6BXlwBQBM2zYTSjY4Rm/Jt
         pmCf2lp0vaijmggY0iiIvc0is4diW9zh72iCOlZHinv7lbxSSZU962g9QzsHC55DN7t/
         6Ov6Op+kTCxBjT94pLbDXuyQ71l7it10AJouojfJCWSDGCeBLdHSGFLdrmAYVN1LXAgf
         NTgdRwvZendUKApqUXOKwNFdEN1AseLeyEHkBHAbrAUGgiWSbSKwOK2W40bPf08L5kq5
         sAbq7euYFesaYWWTcr5jmpyMk+xTcwyRDHWb+IkpT4CUbkuVSiy0BMjFawXX3HAdTAOu
         wwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icW1CmJt7V7nnYt5AEHzW1LfQUR9u0/06jxrbW0ydIE=;
        b=JprkbFj/ZYZocFmqI0GwfA+8R5RPw8oNl46UospMctLu3ki+q09Luk/11zh9TJYh7q
         XWpqYf6QXTza07EaIfTcnENxNmK2ty3zZUnpnjL3WAc4/cAS0CofgpGDwSg/88as/Puq
         Ppsntdq/vL0KB3bK0NM+wtqIaEF4topYU5ptTuLf/CsgDGwJvk6RY9mic8rJBo5fSSNf
         UFi0+0VkJAcgbvCj2d/3ZDl/0ni1MIyuEVn21yKFG5mgVY2ngDbbzRuCUzQDFQWGhnUP
         vzqU1JBK3EkdyEu0iq75o6SGiNqh+RAlOc3cOR4jiU3XJTXnqoY2qg4chIjEXDz/6238
         eJnA==
X-Gm-Message-State: AOAM531x1dok55d1nnrOf1O2EpWl7L2y/ZelcBVZZlc9XsJbjfoArQlZ
        hNX+Y0hZCKEy2gMPELMzUTUvQJKdetd9uGWtqrA=
X-Google-Smtp-Source: ABdhPJwNnNt82Ke50ji96jl+FazzkYyliOjKQ0J1l3/mxC7Bq/ioquSrgo/Vj0t9xSSu5YUxI/clxSsg1CoqZiW/JLw=
X-Received: by 2002:a05:6e02:1bcd:: with SMTP id x13mr3347247ilv.98.1644362658855;
 Tue, 08 Feb 2022 15:24:18 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-9-jolsa@kernel.org>
 <CAEf4Bzbi3t_zZL2=8NyBeJ9q95ODH7pXF+EybtgBQp7LTyfr6Q@mail.gmail.com> <YgI0zJDJ3jrb3q49@krava>
In-Reply-To: <YgI0zJDJ3jrb3q49@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Feb 2022 15:24:07 -0800
Message-ID: <CAEf4BzaJc6uE52JL8Ac=nam0KOS_+haWh3pBVOSMsDM2jv_AXQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] selftest/bpf: Add fprobe test for bpf_cookie values
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 1:16 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Feb 07, 2022 at 10:59:32AM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding bpf_cookie test for kprobe attached by fprobe link.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  .../selftests/bpf/prog_tests/bpf_cookie.c     | 73 +++++++++++++++++++
> > >  .../selftests/bpf/progs/fprobe_bpf_cookie.c   | 62 ++++++++++++++++
> > >  2 files changed, 135 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > index cd10df6cd0fc..bf70d859c598 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > @@ -7,6 +7,7 @@
> > >  #include <unistd.h>
> > >  #include <test_progs.h>
> > >  #include "test_bpf_cookie.skel.h"
> > > +#include "fprobe_bpf_cookie.skel.h"
> > >
> > >  /* uprobe attach point */
> > >  static void trigger_func(void)
> > > @@ -63,6 +64,76 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
> > >         bpf_link__destroy(retlink2);
> > >  }
> > >
> > > +static void fprobe_subtest(void)
> > > +{
> > > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > > +       int err, prog_fd, link1_fd = -1, link2_fd = -1;
> > > +       struct fprobe_bpf_cookie *skel = NULL;
> > > +       __u32 duration = 0, retval;
> > > +       __u64 addrs[8], cookies[8];
> > > +
> > > +       skel = fprobe_bpf_cookie__open_and_load();
> > > +       if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
> > > +               goto cleanup;
> > > +
> > > +       kallsyms_find("bpf_fentry_test1", &addrs[0]);
> > > +       kallsyms_find("bpf_fentry_test2", &addrs[1]);
> > > +       kallsyms_find("bpf_fentry_test3", &addrs[2]);
> > > +       kallsyms_find("bpf_fentry_test4", &addrs[3]);
> > > +       kallsyms_find("bpf_fentry_test5", &addrs[4]);
> > > +       kallsyms_find("bpf_fentry_test6", &addrs[5]);
> > > +       kallsyms_find("bpf_fentry_test7", &addrs[6]);
> > > +       kallsyms_find("bpf_fentry_test8", &addrs[7]);
> > > +
> > > +       cookies[0] = 1;
> > > +       cookies[1] = 2;
> > > +       cookies[2] = 3;
> > > +       cookies[3] = 4;
> > > +       cookies[4] = 5;
> > > +       cookies[5] = 6;
> > > +       cookies[6] = 7;
> > > +       cookies[7] = 8;
> > > +
> > > +       opts.fprobe.addrs = (__u64) &addrs;
> >
> > we should have ptr_to_u64() for test_progs, but if not, let's either
> > add it or it should be (__u64)(uintptr_t)&addrs. Otherwise we'll be
> > getting compilation warnings on some architectures.
>
> there's one in btf.c, bpf.c and libbpf.c ;-) so I guess it could go to bpf.h

No, it shouldn't, bpf.h is a public API header. Let's keep internal
helpers internal. Just copy/paste.

>
> >
> > > +       opts.fprobe.cnt = 8;
> > > +       opts.fprobe.bpf_cookies = (__u64) &cookies;
> > > +       prog_fd = bpf_program__fd(skel->progs.test2);
> > > +
> > > +       link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> > > +       if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
> > > +               return;
> > > +
> > > +       cookies[0] = 8;
> > > +       cookies[1] = 7;
> > > +       cookies[2] = 6;
> > > +       cookies[3] = 5;
> > > +       cookies[4] = 4;
> > > +       cookies[5] = 3;
> > > +       cookies[6] = 2;
> > > +       cookies[7] = 1;
> > > +
> > > +       opts.flags = BPF_F_FPROBE_RETURN;
> > > +       prog_fd = bpf_program__fd(skel->progs.test3);
> > > +
> > > +       link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> > > +       if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
> > > +               goto cleanup;
> > > +
> > > +       prog_fd = bpf_program__fd(skel->progs.test1);
> > > +       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > > +                               NULL, NULL, &retval, &duration);
> > > +       ASSERT_OK(err, "test_run");
> > > +       ASSERT_EQ(retval, 0, "test_run");
> > > +
> > > +       ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
> > > +       ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
> > > +
> > > +cleanup:
> > > +       close(link1_fd);
> > > +       close(link2_fd);
> > > +       fprobe_bpf_cookie__destroy(skel);
> > > +}
> > > +
> > >  static void uprobe_subtest(struct test_bpf_cookie *skel)
> > >  {
> > >         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > > @@ -249,6 +320,8 @@ void test_bpf_cookie(void)
> > >
> > >         if (test__start_subtest("kprobe"))
> > >                 kprobe_subtest(skel);
> > > +       if (test__start_subtest("rawkprobe"))
> >
> > kprobe.multi?
>
> yes
>
> thanks,
> jirka
>
