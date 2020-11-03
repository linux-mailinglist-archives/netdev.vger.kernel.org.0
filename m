Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665DD2A4A38
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgKCPov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgKCPov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:44:51 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5885C0613D1;
        Tue,  3 Nov 2020 07:44:50 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id j12so4269417iow.0;
        Tue, 03 Nov 2020 07:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KrZAsJ+84f6f17H2kWvL1rr4BgKZ82QM8UyFCgrCSjY=;
        b=LTHE7k7LtIvcchE6ZHPiOk4V+Z2pDr0rl08VSiCIMdHtemzIvXX10N9gervkDOpgrw
         HmX0G0MUC2RkrvVwVUW+MxWOWtyBGlQQed7VMTjWg1+lzWmPxXdzaxa1PWx8oczRpbUC
         lwi23OL+XARPwDtSMFr6yJZhRahMyyJDXpUR89aBiqKFUHZRycXKD8WQfaMYSNKw+W/S
         NLdYdurYp8vGpqJ+xFRXt5lRdSgbh5wtW5tc2w1vgXGvoYGKdsQigJxOXJLWiIUNlrpk
         ylxic3lr9ig8uLviJ4vLozfgaHQbs0xY0A1GWV/JRZbP1/5ShyxtuVJBtKrgFsitxba6
         qrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KrZAsJ+84f6f17H2kWvL1rr4BgKZ82QM8UyFCgrCSjY=;
        b=rrmK4w6/Av1tBJ07JDh5QoGstBFoTbBmYcvjhETuLrzNQDows96nVAthNJgohaZ8jk
         izik49qC805WGk+/wZ67H/tyazi6/dRVF3CBzFjpTZv4XARbcCcB9VZwnf9eNpajt2ge
         qKvxMhC5b9ivbHFprK5wq6Qh0VQvryhCmR5bz7gXPq5pcOhz2B4rWJomg7G31+vUzzId
         8wleCIEFFAEZQWzFu2Xzg7uVOekpX9W+ZkePgI85iTUG+9iFhxsQGE4GX/jbi2kr+A63
         Giv+W6kTzydrcp1mywkOk9v3BaeaI1cI02qlt197CtXvKwCg3BhA0UmsS5rdiNKw7pVD
         5frA==
X-Gm-Message-State: AOAM531hTAC6r9HmKeLm5ouIlDBEe3IxHVd4cBMzP07D8GALeSLviHXF
        wMEqFVbw+mguINWqOzGNQlVmeYSSLSSpWSuB/qY=
X-Google-Smtp-Source: ABdhPJxiDa7bDkPP9H/vTqWiBLfCyaOSfPJgX+QT8Io+t03Q5jNPsTxykPN8E3XkbS9CD1+cFvk3n/O/5IwOVvY4Rgs=
X-Received: by 2002:a6b:b2c4:: with SMTP id b187mr14612595iof.187.1604418290238;
 Tue, 03 Nov 2020 07:44:50 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035105.2823.2453428685023319711.stgit@localhost.localdomain> <20201103005547.buhyl6tsi5shm374@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103005547.buhyl6tsi5shm374@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 3 Nov 2020 07:44:38 -0800
Message-ID: <CAKgT0UeV4OKC8dhMgA-RvRfa4kr6NsqF=CCdW-Oe2mx+E4MPEg@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 4/5] selftests/bpf: Migrate tcpbpf_user.c to
 use BPF skeleton
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 4:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Oct 31, 2020 at 11:52:31AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> > simplify test_tcpbpf_user and reduce the overhead involved in setting up
> > the test.
> >
> > In addition we can clean up the remaining bits such as the one remaining
> > CHECK_FAIL at the end of test_tcpbpf_user so that the function only makes
> > use of CHECK as needed.
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> > ---
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 ++++++++------------
> >  1 file changed, 18 insertions(+), 30 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index d96f4084d2f5..c7a61b0d616a 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -4,6 +4,7 @@
> >  #include <network_helpers.h>
> >
> >  #include "test_tcpbpf.h"
> > +#include "test_tcpbpf_kern.skel.h"
> >
> >  #define LO_ADDR6 "::1"
> >  #define CG_NAME "/tcpbpf-user-test"
> > @@ -133,44 +134,31 @@ static void run_test(int map_fd, int sock_map_fd)
> >
> >  void test_tcpbpf_user(void)
> >  {
> > -     const char *file = "test_tcpbpf_kern.o";
> > -     int prog_fd, map_fd, sock_map_fd;
> > -     int error = EXIT_FAILURE;
> > -     struct bpf_object *obj;
> > +     struct test_tcpbpf_kern *skel;
> > +     int map_fd, sock_map_fd;
> >       int cg_fd = -1;
> > -     int rv;
> > -
> > -     cg_fd = test__join_cgroup(CG_NAME);
> > -     if (cg_fd < 0)
> > -             goto err;
> >
> > -     if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
> > -             fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> > -             goto err;
> > -     }
> > +     skel = test_tcpbpf_kern__open_and_load();
> > +     if (CHECK(!skel, "open and load skel", "failed"))
> > +             return;
> >
> > -     rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> > -     if (rv) {
> > -             fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> > -                    errno, strerror(errno));
> > -             goto err;
> > -     }
> > +     cg_fd = test__join_cgroup(CG_NAME);
> > +     if (CHECK(cg_fd < 0, "test__join_cgroup(" CG_NAME ")",
> > +               "cg_fd:%d errno:%d", cg_fd, errno))
> > +             goto cleanup_skel;
> >
> > -     map_fd = bpf_find_map(__func__, obj, "global_map");
> > -     if (map_fd < 0)
> > -             goto err;
> > +     map_fd = bpf_map__fd(skel->maps.global_map);
> > +     sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
> >
> > -     sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> > -     if (sock_map_fd < 0)
> > -             goto err;
> > +     skel->links.bpf_testcb = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
> > +     if (ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
> > +             goto cleanup_namespace;
> >
> >       run_test(map_fd, sock_map_fd);
> >
> > -     error = 0;
> > -err:
> > -     bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
> > +cleanup_namespace:
> nit.
>
> may be "cleanup_cgroup" instead?
>
> or only have one jump label to handle failure since "cg_fd != -1" has been
> tested already.

Good point. I can go through and just drop the second label and
simplify this. Will fix for v3.
