Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3202A0A62
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgJ3Put (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgJ3Pus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:50:48 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B603FC0613CF;
        Fri, 30 Oct 2020 08:50:48 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u62so7971656iod.8;
        Fri, 30 Oct 2020 08:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HxnSxsE+M9fmWZ2rJEKUv08v/eoEDXQx96qUIuOYyS0=;
        b=qVFlWNc/vbn9Ku+VY4QkXb77T4NlUAGQIti4I7K/Ime3KZbaDt9yul/qM8r/71iwSE
         LIvkw8uzTeaFfvzKamMC8Vuka/JvoavsqRlOS79eCjGCxjUTrELegQPu3BlDoFoROtd2
         l2RkGqiQb3MjPuKz4tLt7HSk9NWpAWt5oRBi8HwABk+CMzKE1sAYIX//5rYoRsVFQXc2
         VGE4X1fGubdSmybPE38zbuHPCvCcpu4LGKlersTyXBxreYNd1skHSzCTR91pop72OzMm
         uplS0jomiOvd4AzIGAau3pm62/UdfIOeO+J2rKTffaooBYRYt7ZWaZ9wLgeLBWiG0HIv
         VHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HxnSxsE+M9fmWZ2rJEKUv08v/eoEDXQx96qUIuOYyS0=;
        b=fLthT5pqgqx++weBfN2ROQPsBp6hrbYzkh2BahmBTS3XO9Ps8aaKRxFJPJmtrWibtZ
         YGSdUTW6GV0p7UHoSbQ2ZuAF2PVvKSnEnhKj2hP/MJ+SDyE1vIje6aYkpJkjCB53IChK
         LavJw1hJDHbHgeRxtiW8lCGJcAMPcPwtiBEGP7XrkHGli3BGy8/PjYysxxOH0oPW26uT
         g0s3TIaHtsj63KUF8Qz+hWh/v7AqQZX11llcIndHExhiIFHipDdmAa/8Iaen6VzdzbVk
         COPOAqMqlSLDe52GtwWNOwWuPEoCAhGyUnOeDhfIR2siP/pBT1b5Az2DJCDyK5p4trdQ
         9A/Q==
X-Gm-Message-State: AOAM533v1fdeKrf1l/+2UR7VoLUqFDPP7t+n6Ur7Z7Vrg2hJ84qAzUwp
        ChzNtF8iz934wJD/2L6CKM12KeqaxXQJ/kjA+Gs=
X-Google-Smtp-Source: ABdhPJx92+zYQgqCO6HMYmwyoylayJzqYs5CQtqk+zu86pd1I1sTXQZcfQ6PgmxeAuwewe2P6Z2V9OpcwLcTUcTSzXY=
X-Received: by 2002:a02:c80a:: with SMTP id p10mr2412474jao.114.1604073047953;
 Fri, 30 Oct 2020 08:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384964803.698509.11020605670605638967.stgit@localhost.localdomain>
 <CAEf4BzaELDiuHLbSdWdZZcjw5eNCJELBeHUc2CRiursUcUj_kg@mail.gmail.com>
 <CAKgT0UcQzJ06ayURwpU78ybW+WYRUbbEH++6O9nPUxSSHnU89Q@mail.gmail.com> <CAEf4BzY73uiNE8V_zyhRuMpX8+e6JyR+BkfHqPfztOpm9Orjng@mail.gmail.com>
In-Reply-To: <CAEf4BzY73uiNE8V_zyhRuMpX8+e6JyR+BkfHqPfztOpm9Orjng@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 30 Oct 2020 08:50:37 -0700
Message-ID: <CAKgT0UcRh50K9UvZ61MD3U2PzqKsYaJRWOh_s-p-6YFZgR2YVw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 4/4] selftests/bpf: Migrate tcpbpf_user.c to use
 BPF skeleton
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, Oct 29, 2020 at 7:30 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 5:42 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 4:20 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Oct 29, 2020 at 12:57 AM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > From: Alexander Duyck <alexanderduyck@fb.com>
> > > >
> > > > Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> > > > simplify test_tcpbpf_user and reduce the overhead involved in setting up
> > > > the test.
> > > >
> > > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > ---
> > >
> > > Few suggestions below, but overall looks good:
> > >
> > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > >
> > > >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 +++++++++-----------
> > > >  1 file changed, 21 insertions(+), 27 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > index 4e1190894e1e..7e92c37976ac 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > > @@ -5,6 +5,7 @@
> > > >
> > > >  #include "test_tcpbpf.h"
> > > >  #include "cgroup_helpers.h"
> > > > +#include "test_tcpbpf_kern.skel.h"
> > > >
> > > >  #define LO_ADDR6 "::1"
> > > >  #define CG_NAME "/tcpbpf-user-test"
> > > > @@ -162,39 +163,32 @@ static void run_test(int map_fd, int sock_map_fd)
> > > >
> > > >  void test_tcpbpf_user(void)
> > > >  {
> > > > -       const char *file = "test_tcpbpf_kern.o";
> > > > -       int prog_fd, map_fd, sock_map_fd;
> > > > -       struct bpf_object *obj;
> > > > +       struct test_tcpbpf_kern *skel;
> > > > +       int map_fd, sock_map_fd;
> > > > +       struct bpf_link *link;
> > > >         int cg_fd = -1;
> > > > -       int rv;
> > > > -
> > > > -       cg_fd = cgroup_setup_and_join(CG_NAME);
> > > > -       if (CHECK_FAIL(cg_fd < 0))
> > > > -               goto err;
> > > >
> > > > -       if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
> > > > -               fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> > > > -               goto err;
> > > > -       }
> > > > +       skel = test_tcpbpf_kern__open_and_load();
> > > > +       if (CHECK(!skel, "open and load skel", "failed"))
> > > > +               return;
> > > >
> > > > -       rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> > > > -       if (CHECK_FAIL(rv)) {
> > > > -               fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> > > > -                      errno, strerror(errno));
> > > > -               goto err;
> > > > -       }
> > > > +       cg_fd = test__join_cgroup(CG_NAME);
> > > > +       if (CHECK_FAIL(cg_fd < 0))
> > >
> > > please use either CHECK() or one of the newer ASSERT_xxx() macro (also
> > > defined in test_progs.h), CHECK_FAIL should be avoided in general.
> >
> > So the plan I had was to actually move over to the following:
> >         cg_fd = test__join_cgroup(CG_NAME);
> >         if (CHECK_FAIL(cg_fd < 0))
> >                 goto cleanup_skel;
> >
> > It still makes use of CHECK_FAIL but it looks like test__join_cgroup
> > already takes care of error messaging so using CHECK_FAIL in this case
> > makes more sense.
>
> CHECK (and ASSERT) leave a paper-trail in verbose test log, so it
> makes it easier to debug tests, if something fails. CHECK_FAIL is
> invisible, unless if fails. So CHECK_FAIL should be used only for
> things that are happening on the order of hundreds of instances per
> test, or more.

Okay, well in that case I will go through and replace the CHECK_FAIL
calls with a CHECK.

> >
> > > > +               goto cleanup_skel;
> > > >
> > > > -       map_fd = bpf_find_map(__func__, obj, "global_map");
> > > > -       if (CHECK_FAIL(map_fd < 0))
> > > > -               goto err;
> > > > +       map_fd = bpf_map__fd(skel->maps.global_map);
> > > > +       sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
> > > >
> > > > -       sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> > > > -       if (CHECK_FAIL(sock_map_fd < 0))
> > > > -               goto err;
> > > > +       link = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
> > >
> > > you can do skel->links.bpf_testcb = bpf_program__attach_cgroup() and
> > > skeleton's __destroy() call will take care of destroying the link
> >
> > Okay, I can look into using that. Actually this has me wondering if
> > there wouldn't be some way to make use of test_tcpbpf_kern__attach to
> > achieve this in some standard way. I'll get that sorted before I
> > submit v2.
>
> cgroup BPF programs can't be auto-attached, because they expect cgroup
> FD, which you can't provide at compilation time (declaratively) in BPF
> code. So it has to be manually attached. skeleton's attach() will just
> ignore such programs.

Yeah, I figured that out after reviewing the code further.

Thanks.

- Alex
