Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7955B4AD481
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353419AbiBHJQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353386AbiBHJQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:16:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF28DC03FEC1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 01:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644311762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vWTeTtK7QuygKDGNGhC3/zMgZotQ2ldpExYYNODBF4o=;
        b=b94Sp2Z/E0Xad1ljkRP/QqNV+1LtPfL2d1dnDv2e1916CThXJx2oR5FnRZzjq2PGXbVRCY
        epthq7zgtD8OWVej90JiunIAvNJvWAN/Bd4cCrUBYOqDgWDgUOncx1ea00qQ7vhhwOaLtC
        c4bsOPFChdJCteo4JIcSIxmAhxVeEbY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-Uy2aZQZTOOylxQNT3d0Uqw-1; Tue, 08 Feb 2022 04:16:00 -0500
X-MC-Unique: Uy2aZQZTOOylxQNT3d0Uqw-1
Received: by mail-ej1-f72.google.com with SMTP id o4-20020a170906768400b006a981625756so5479448ejm.0
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 01:15:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vWTeTtK7QuygKDGNGhC3/zMgZotQ2ldpExYYNODBF4o=;
        b=ewlSe8Bo/6O0KafCW7wF4Jmzm1as01LlzqxKhKT6rZHFt0EHOUiCVeAFMEbVLvsUVd
         MF8h9S3ne+uk2KqEgWXYkkwonV0mYPkqrHY6b0Wc6EhQTDocpQCir/6NyGRY1fK6onpx
         jZ85KVaYu6NwKC8XdTf3bUruQB/C42F0fPnTCaTrXdLVAaeuKTbbdLNuVmEtoeeMI9D5
         VRCMSb3lGp0IG8J6fRXoYU+EfNsw7xBSSrg5Av5ljjnm5nCKDPj0qzBBxEFC0QtkO4nF
         SlpMZnmd3Kw5iMzcsMlw6aeWScYUYtA7Gg+Ohv0JC/nxHJSCONjdMKHI0+gXL727me8t
         qgRA==
X-Gm-Message-State: AOAM530/mW2xQ11UdLNz7ZDlMnfbAmYNEXwrM4EfX9qLkAD8QjGoxDnA
        FEvZXe29a9+1xiOteI5scQHTOufACeGtgJ04c/MK5Ba3pWljYKX+XkoY1SP7LdXQXhloI2c4Gge
        PiN5t7sbzqVHZ+YNz
X-Received: by 2002:aa7:cb87:: with SMTP id r7mr3496503edt.284.1644311758859;
        Tue, 08 Feb 2022 01:15:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7Lki8J0+DYZKgA0Sje1wqEXoOop45PfSQdqu2TcaABmDndUbGA3rwRkTpJzzLLbClyqFLTw==
X-Received: by 2002:aa7:cb87:: with SMTP id r7mr3496479edt.284.1644311758630;
        Tue, 08 Feb 2022 01:15:58 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id r6sm4025782ejd.100.2022.02.08.01.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 01:15:58 -0800 (PST)
Date:   Tue, 8 Feb 2022 10:15:56 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH 8/8] selftest/bpf: Add fprobe test for bpf_cookie values
Message-ID: <YgI0zJDJ3jrb3q49@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <20220202135333.190761-9-jolsa@kernel.org>
 <CAEf4Bzbi3t_zZL2=8NyBeJ9q95ODH7pXF+EybtgBQp7LTyfr6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbi3t_zZL2=8NyBeJ9q95ODH7pXF+EybtgBQp7LTyfr6Q@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:59:32AM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding bpf_cookie test for kprobe attached by fprobe link.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_cookie.c     | 73 +++++++++++++++++++
> >  .../selftests/bpf/progs/fprobe_bpf_cookie.c   | 62 ++++++++++++++++
> >  2 files changed, 135 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > index cd10df6cd0fc..bf70d859c598 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > @@ -7,6 +7,7 @@
> >  #include <unistd.h>
> >  #include <test_progs.h>
> >  #include "test_bpf_cookie.skel.h"
> > +#include "fprobe_bpf_cookie.skel.h"
> >
> >  /* uprobe attach point */
> >  static void trigger_func(void)
> > @@ -63,6 +64,76 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
> >         bpf_link__destroy(retlink2);
> >  }
> >
> > +static void fprobe_subtest(void)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > +       int err, prog_fd, link1_fd = -1, link2_fd = -1;
> > +       struct fprobe_bpf_cookie *skel = NULL;
> > +       __u32 duration = 0, retval;
> > +       __u64 addrs[8], cookies[8];
> > +
> > +       skel = fprobe_bpf_cookie__open_and_load();
> > +       if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
> > +               goto cleanup;
> > +
> > +       kallsyms_find("bpf_fentry_test1", &addrs[0]);
> > +       kallsyms_find("bpf_fentry_test2", &addrs[1]);
> > +       kallsyms_find("bpf_fentry_test3", &addrs[2]);
> > +       kallsyms_find("bpf_fentry_test4", &addrs[3]);
> > +       kallsyms_find("bpf_fentry_test5", &addrs[4]);
> > +       kallsyms_find("bpf_fentry_test6", &addrs[5]);
> > +       kallsyms_find("bpf_fentry_test7", &addrs[6]);
> > +       kallsyms_find("bpf_fentry_test8", &addrs[7]);
> > +
> > +       cookies[0] = 1;
> > +       cookies[1] = 2;
> > +       cookies[2] = 3;
> > +       cookies[3] = 4;
> > +       cookies[4] = 5;
> > +       cookies[5] = 6;
> > +       cookies[6] = 7;
> > +       cookies[7] = 8;
> > +
> > +       opts.fprobe.addrs = (__u64) &addrs;
> 
> we should have ptr_to_u64() for test_progs, but if not, let's either
> add it or it should be (__u64)(uintptr_t)&addrs. Otherwise we'll be
> getting compilation warnings on some architectures.

there's one in btf.c, bpf.c and libbpf.c ;-) so I guess it could go to bpf.h

> 
> > +       opts.fprobe.cnt = 8;
> > +       opts.fprobe.bpf_cookies = (__u64) &cookies;
> > +       prog_fd = bpf_program__fd(skel->progs.test2);
> > +
> > +       link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> > +       if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
> > +               return;
> > +
> > +       cookies[0] = 8;
> > +       cookies[1] = 7;
> > +       cookies[2] = 6;
> > +       cookies[3] = 5;
> > +       cookies[4] = 4;
> > +       cookies[5] = 3;
> > +       cookies[6] = 2;
> > +       cookies[7] = 1;
> > +
> > +       opts.flags = BPF_F_FPROBE_RETURN;
> > +       prog_fd = bpf_program__fd(skel->progs.test3);
> > +
> > +       link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> > +       if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
> > +               goto cleanup;
> > +
> > +       prog_fd = bpf_program__fd(skel->progs.test1);
> > +       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > +                               NULL, NULL, &retval, &duration);
> > +       ASSERT_OK(err, "test_run");
> > +       ASSERT_EQ(retval, 0, "test_run");
> > +
> > +       ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
> > +       ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
> > +
> > +cleanup:
> > +       close(link1_fd);
> > +       close(link2_fd);
> > +       fprobe_bpf_cookie__destroy(skel);
> > +}
> > +
> >  static void uprobe_subtest(struct test_bpf_cookie *skel)
> >  {
> >         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > @@ -249,6 +320,8 @@ void test_bpf_cookie(void)
> >
> >         if (test__start_subtest("kprobe"))
> >                 kprobe_subtest(skel);
> > +       if (test__start_subtest("rawkprobe"))
> 
> kprobe.multi?

yes

thanks,
jirka

