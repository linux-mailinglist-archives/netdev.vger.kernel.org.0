Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBF29FB4A
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgJ3CaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgJ3CaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:14 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246E0C0613CF;
        Thu, 29 Oct 2020 19:30:14 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id m188so3918607ybf.2;
        Thu, 29 Oct 2020 19:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vvl2Aj70JHcuisMyuGqmA/6GQcFkENCvf6qacD/mdf0=;
        b=XUj14oblLc+IpVD3w5vnuYsjvruJH+s8EdMu5driesQrFy92qPXutr22tNsklwurOf
         7rFdpH1Fk8rM2cffzzSPv95Y1I5PmwwhLnNdm8rem/YqYVOTPsPW+wh6Z8kfst2JffQS
         9X+jhrjdAjJ7Eiz8Yvl/qkGsYfu8LcGvWcWNkr1yLkVLDpz4TTsL/GRnmnpFzcjWaltI
         muDdiZC1b3XbD/aZ33YmB8rhTRu8Y6tmZ27fhUVz875ntG7jS5ze3CMvWOoB7iPzdC6Z
         arOULIBNxb4S5iohbJJjjFvCiWg28c5L7pzJOy8krK60/DAqIdGoMdg4+jHiDCFjv6Q9
         K0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vvl2Aj70JHcuisMyuGqmA/6GQcFkENCvf6qacD/mdf0=;
        b=TY0fZhGkz/eircAW/ff3CHetupTUe4rvNvVMTlKYMlabNk7/p2bXJanV6+PM5efL4v
         evaBCngQl5suRIpVFZWfow9EqrXhX1iYRHy5KyS1ZUd3MbV9zALiXLgzEMEX4G7ZzTyq
         TVFghVhi4ZlYRNCSUPFMLxbCdORd2UpTJeK9OePHXVE6RZdNSlweh/c3KAXunc+xflNQ
         BckmqjM8JDH1NuBt4a+pUel6SjelFAsjyC6B7pSHIl7g9x4p07deQxJsvg6FMSqGTI3U
         noxxtXnSpQjjT1cXE4MPqFFE74b13bb1z3YtjB4t/5RbJeRPIueq1IXyJ29KmUZXNQkj
         L9uQ==
X-Gm-Message-State: AOAM5314h1mRAuo4olek/oORaT8pPc/WOxgEWT2/MLKBxIB+Wu3dJ9mK
        wBd8qdSVmqRDXd8f4buUnN0RHFMkQ4+d29H6MGg=
X-Google-Smtp-Source: ABdhPJz311JMlAJ/SsfdDTzlXFrPq1w30bqJLu3Z2n1N3I7T+vHiInTYwm3Ww7B9udohH9Ibj2C8BvHAJePr28BReY0=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr536604ybg.459.1604025013398;
 Thu, 29 Oct 2020 19:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384964803.698509.11020605670605638967.stgit@localhost.localdomain>
 <CAEf4BzaELDiuHLbSdWdZZcjw5eNCJELBeHUc2CRiursUcUj_kg@mail.gmail.com> <CAKgT0UcQzJ06ayURwpU78ybW+WYRUbbEH++6O9nPUxSSHnU89Q@mail.gmail.com>
In-Reply-To: <CAKgT0UcQzJ06ayURwpU78ybW+WYRUbbEH++6O9nPUxSSHnU89Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 19:30:02 -0700
Message-ID: <CAEf4BzY73uiNE8V_zyhRuMpX8+e6JyR+BkfHqPfztOpm9Orjng@mail.gmail.com>
Subject: Re: [bpf-next PATCH 4/4] selftests/bpf: Migrate tcpbpf_user.c to use
 BPF skeleton
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 5:42 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 4:20 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 12:57 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > From: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> > > simplify test_tcpbpf_user and reduce the overhead involved in setting up
> > > the test.
> > >
> > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > ---
> >
> > Few suggestions below, but overall looks good:
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 +++++++++-----------
> > >  1 file changed, 21 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > index 4e1190894e1e..7e92c37976ac 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > @@ -5,6 +5,7 @@
> > >
> > >  #include "test_tcpbpf.h"
> > >  #include "cgroup_helpers.h"
> > > +#include "test_tcpbpf_kern.skel.h"
> > >
> > >  #define LO_ADDR6 "::1"
> > >  #define CG_NAME "/tcpbpf-user-test"
> > > @@ -162,39 +163,32 @@ static void run_test(int map_fd, int sock_map_fd)
> > >
> > >  void test_tcpbpf_user(void)
> > >  {
> > > -       const char *file = "test_tcpbpf_kern.o";
> > > -       int prog_fd, map_fd, sock_map_fd;
> > > -       struct bpf_object *obj;
> > > +       struct test_tcpbpf_kern *skel;
> > > +       int map_fd, sock_map_fd;
> > > +       struct bpf_link *link;
> > >         int cg_fd = -1;
> > > -       int rv;
> > > -
> > > -       cg_fd = cgroup_setup_and_join(CG_NAME);
> > > -       if (CHECK_FAIL(cg_fd < 0))
> > > -               goto err;
> > >
> > > -       if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
> > > -               fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> > > -               goto err;
> > > -       }
> > > +       skel = test_tcpbpf_kern__open_and_load();
> > > +       if (CHECK(!skel, "open and load skel", "failed"))
> > > +               return;
> > >
> > > -       rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> > > -       if (CHECK_FAIL(rv)) {
> > > -               fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> > > -                      errno, strerror(errno));
> > > -               goto err;
> > > -       }
> > > +       cg_fd = test__join_cgroup(CG_NAME);
> > > +       if (CHECK_FAIL(cg_fd < 0))
> >
> > please use either CHECK() or one of the newer ASSERT_xxx() macro (also
> > defined in test_progs.h), CHECK_FAIL should be avoided in general.
>
> So the plan I had was to actually move over to the following:
>         cg_fd = test__join_cgroup(CG_NAME);
>         if (CHECK_FAIL(cg_fd < 0))
>                 goto cleanup_skel;
>
> It still makes use of CHECK_FAIL but it looks like test__join_cgroup
> already takes care of error messaging so using CHECK_FAIL in this case
> makes more sense.

CHECK (and ASSERT) leave a paper-trail in verbose test log, so it
makes it easier to debug tests, if something fails. CHECK_FAIL is
invisible, unless if fails. So CHECK_FAIL should be used only for
things that are happening on the order of hundreds of instances per
test, or more.

>
> In addition I was looking at simplifying the first patch which should
> just be the move with minimal changes to allow the functionality to
> build as a part of the test_progs framework. The end result should be
> the same it just helps to make the fact that the first patch should
> just be a move a little more clear.

sure


>
> > > +               goto cleanup_skel;
> > >
> > > -       map_fd = bpf_find_map(__func__, obj, "global_map");
> > > -       if (CHECK_FAIL(map_fd < 0))
> > > -               goto err;
> > > +       map_fd = bpf_map__fd(skel->maps.global_map);
> > > +       sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
> > >
> > > -       sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> > > -       if (CHECK_FAIL(sock_map_fd < 0))
> > > -               goto err;
> > > +       link = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
> >
> > you can do skel->links.bpf_testcb = bpf_program__attach_cgroup() and
> > skeleton's __destroy() call will take care of destroying the link
>
> Okay, I can look into using that. Actually this has me wondering if
> there wouldn't be some way to make use of test_tcpbpf_kern__attach to
> achieve this in some standard way. I'll get that sorted before I
> submit v2.

cgroup BPF programs can't be auto-attached, because they expect cgroup
FD, which you can't provide at compilation time (declaratively) in BPF
code. So it has to be manually attached. skeleton's attach() will just
ignore such programs.

>
> > > +       if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
> > > +                 PTR_ERR(link)))
> >
> > there is a convenient ASSERT_OK_PTR() specifically for pointers like
> > this (and NULL ones as well, of course); saves a lot of typing and
> > encapsulates error extraction internally.
>
> I'll update the code to address that.
