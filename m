Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A454CEC88
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiCFRak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiCFRaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:30:39 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508A4B1E4;
        Sun,  6 Mar 2022 09:29:46 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q20so5546247wmq.1;
        Sun, 06 Mar 2022 09:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1zzNgf433hyjGkgzGz6Qpkm1fu9BPDmLsvmtuyA914E=;
        b=husxF0wgW3KVw8HHmc98ry3UwO3cSwMAsqHJyO4MgtxAxeufK+7y2BeH03igmgNIYy
         YGKXxafZ+HCiiOYn5iWnL45ZiK5P5qmQhfvzQUdMv8XnbxVw4NmicfE/ckFegBlVPzHP
         +HecN91dxbexme3px6k8x6X4D9Fy1+KNBeJ9HxUW8BG9ycrXWdHwVI8FpToThfKf5bA4
         iyTqnw0M9zo/Ug+iJK3B7ekNl03in/sdcd9d9kSrS/WFKXugBW8LAE3p7KEcFCG0dIDl
         pjbADMkd1pBc2co/tVujHq/UxhozjyE28LAoa3VPoHFwkNDCeV3icBhx/Zwxs3NIT3XN
         Grfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1zzNgf433hyjGkgzGz6Qpkm1fu9BPDmLsvmtuyA914E=;
        b=vgANla/2WVET3B1MrwZ3PqGs+9k8ADJWUIrpykaL2UfvweuZxE3qAGoMqlXQspyCDC
         sv/MZCKikYYHrhLc/hQZjq3dZ1blJ64BIEtdDu2+NV1KG+eLmDiSL14Z4O3XRknOSqby
         N71Fu2rsoBMPd9hzPr4kv+m2cXduz1/b8o/7Cu1XUat51biE3bAEZvWXNe7/4aV9EqL4
         ZOyoN9z6Krbw26xCZI5+pAqeevSorxnVDpkKhffyjI6ox8/lJC30YynrKGeO27nWMwqH
         rZ/jWuu5J25Z/u3S80j+QLnEdwzbPDRJazeoCOkzddBWnEUE20lJbPpaPIc+Fj3qLvyU
         FLsg==
X-Gm-Message-State: AOAM533tJwgfUEt6552uMqMWg6AoucUJP1Tfp9ePauJnI4ghYz9Dn3q1
        lPFplYM8u3OiciMlGygeZBU=
X-Google-Smtp-Source: ABdhPJxv8EhzkcCbfdntaHmwy4Jd8RoldAVIB1QgPaTElDWpOXKEwbIbY02Pd40OmJSAXoN6cfWLfQ==
X-Received: by 2002:a05:600c:4e0a:b0:37b:c548:622a with SMTP id b10-20020a05600c4e0a00b0037bc548622amr15944416wmq.55.1646587785100;
        Sun, 06 Mar 2022 09:29:45 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id v5-20020adfe4c5000000b001edc1e5053esm9332016wrm.82.2022.03.06.09.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:29:44 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:29:42 +0100
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
Subject: Re: [PATCH 10/10] selftest/bpf: Add kprobe_multi test for bpf_cookie
 values
Message-ID: <YiTvht+4yyFghc+s@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-11-jolsa@kernel.org>
 <CAEf4BzZW-W5PcNmB2PoRE-70e1FjqpE-EJKgxfj2SsvjwdBjRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZW-W5PcNmB2PoRE-70e1FjqpE-EJKgxfj2SsvjwdBjRA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:26PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 9:08 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding bpf_cookie test for programs attached by kprobe_multi links.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_cookie.c     | 72 +++++++++++++++++++
> >  .../bpf/progs/kprobe_multi_bpf_cookie.c       | 62 ++++++++++++++++
> >  2 files changed, 134 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > index cd10df6cd0fc..edfb9f8736c6 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > @@ -7,6 +7,7 @@
> >  #include <unistd.h>
> >  #include <test_progs.h>
> >  #include "test_bpf_cookie.skel.h"
> > +#include "kprobe_multi_bpf_cookie.skel.h"
> >
> >  /* uprobe attach point */
> >  static void trigger_func(void)
> > @@ -63,6 +64,75 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
> >         bpf_link__destroy(retlink2);
> >  }
> >
> > +static void kprobe_multi_subtest(void)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > +       int err, prog_fd, link1_fd = -1, link2_fd = -1;
> > +       LIBBPF_OPTS(bpf_test_run_opts, topts);
> 
> consistency ftw, LIBBPF_OPTS

ok

> 
> 
> > +       struct kprobe_multi_bpf_cookie *skel = NULL;
> > +       __u64 addrs[8], cookies[8];
> > +
> 
> [..]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
> > new file mode 100644
> > index 000000000000..d6f8454ba093
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
> > @@ -0,0 +1,62 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +extern const void bpf_fentry_test1 __ksym;
> > +extern const void bpf_fentry_test2 __ksym;
> > +extern const void bpf_fentry_test3 __ksym;
> > +extern const void bpf_fentry_test4 __ksym;
> > +extern const void bpf_fentry_test5 __ksym;
> > +extern const void bpf_fentry_test6 __ksym;
> > +extern const void bpf_fentry_test7 __ksym;
> > +extern const void bpf_fentry_test8 __ksym;
> > +
> > +/* No tests, just to trigger bpf_fentry_test* through tracing test_run */
> > +SEC("fentry/bpf_modify_return_test")
> > +int BPF_PROG(test1)
> > +{
> > +       return 0;
> > +}
> > +
> > +__u64 test2_result = 0;
> > +
> > +SEC("kprobe.multi/bpf_fentry_tes??")
> > +int test2(struct pt_regs *ctx)
> > +{
> > +       __u64 cookie = bpf_get_attach_cookie(ctx);
> > +       __u64 addr = bpf_get_func_ip(ctx);
> > +
> > +       test2_result += (const void *) addr == &bpf_fentry_test1 && cookie == 1;
> > +       test2_result += (const void *) addr == &bpf_fentry_test2 && cookie == 2;
> > +       test2_result += (const void *) addr == &bpf_fentry_test3 && cookie == 3;
> > +       test2_result += (const void *) addr == &bpf_fentry_test4 && cookie == 4;
> > +       test2_result += (const void *) addr == &bpf_fentry_test5 && cookie == 5;
> > +       test2_result += (const void *) addr == &bpf_fentry_test6 && cookie == 6;
> > +       test2_result += (const void *) addr == &bpf_fentry_test7 && cookie == 7;
> > +       test2_result += (const void *) addr == &bpf_fentry_test8 && cookie == 8;
> 
> this is not parallel mode friendly
> 
> let's filter by pid, but also it's best to do count locally and just
> assign it (so that multiple calls of the program still produce the
> same value, instead of constantly increasing global variable with each
> run)

ah I did not think of the paralel run, right, will change

thanks,
jirka
