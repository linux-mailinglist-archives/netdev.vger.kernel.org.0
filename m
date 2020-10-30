Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3369429F9E3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgJ3Amh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgJ3Amh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:42:37 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96886C0613D2;
        Thu, 29 Oct 2020 17:42:12 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id v18so5065455ilg.1;
        Thu, 29 Oct 2020 17:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zdjwskAZxaDq1AQ/INCnCALren2+iPDgMzroCJaVaM=;
        b=kdtXU1L+EsNbpGLg75EaQfG65+ABDB3vO15uCx94bEMoZNXfyAvBosSM/edgKtzkLG
         YkJqi0YRCv1P13JOSDX0q+pk+3BKV10Zk/VJa7VR1az2j5h7zEhFS9MYpMygXQeX51cw
         QWK5yUuMLKL+UnfF/Hmjj4LYGUKeyC7zxaarDrq6PMKqRKbGlAAOBO3Womr7QVar162Y
         tAUgTnWxBxyIaWJ4kjkLOui5Dja41EgTXIL+ZY6ZOrJ2F7TowvCz6yHtpztKhv2lsyP4
         D3OpQAuuhIBsJKf+4G1ge5IHSPUbeZ837Vpemo8tKogeIi02gcjIACMRHg3TVoMY43js
         fiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zdjwskAZxaDq1AQ/INCnCALren2+iPDgMzroCJaVaM=;
        b=Wfx+5V+7c2L5lyjSM6ZJ7+cwsv9vSQzZcJDllT0WATebDA+ysLp7nYvi1OqSe5SFX+
         5qeI/no/uZRGFjgZxVOLrnV20MSFU1uxVYNaGCBg9fE91M/vUf1wfqESjwWo5i9YZmC7
         FJI8L1SIH4sqCrwnOf/GG8nVrNSmzyUa6W7O8xqO3N8S3mm/N/rpqdcfMODouqvb8NUO
         kQgc16wVLn3tGPkaNxMB0WEUUMVhXOmBY13EY5+eMxxOU2nzgWNfn3GyYbf7u6M2O1hA
         v4wCqcEfvObCtaQlFVwZHkLwhBDjkTT5qMxB4cFD9ca17XcGVsz8jF0FaPABM+VwWkaX
         W66A==
X-Gm-Message-State: AOAM533tWjIglfKsJqbgBmowQaaGlbUIloqXM0/NofF5hMLAtKOGLoHy
        aS0gUHQQ3ZTnyeZtrvYNHu9qUVJKDa9vrpg4wRN5pPN93a8=
X-Google-Smtp-Source: ABdhPJzdTXzJ+MZwSorbev9v2JoJgsEbZW9bhBhVgpqXVw7boyu+ksnUYYynKz7ih//eyvP8GnQDhB7x3UelC49aNuw=
X-Received: by 2002:a05:6e02:1305:: with SMTP id g5mr41446ilr.237.1604018531894;
 Thu, 29 Oct 2020 17:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384964803.698509.11020605670605638967.stgit@localhost.localdomain> <CAEf4BzaELDiuHLbSdWdZZcjw5eNCJELBeHUc2CRiursUcUj_kg@mail.gmail.com>
In-Reply-To: <CAEf4BzaELDiuHLbSdWdZZcjw5eNCJELBeHUc2CRiursUcUj_kg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 29 Oct 2020 17:42:00 -0700
Message-ID: <CAKgT0UcQzJ06ayURwpU78ybW+WYRUbbEH++6O9nPUxSSHnU89Q@mail.gmail.com>
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

On Thu, Oct 29, 2020 at 4:20 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 12:57 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> > simplify test_tcpbpf_user and reduce the overhead involved in setting up
> > the test.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
>
> Few suggestions below, but overall looks good:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 +++++++++-----------
> >  1 file changed, 21 insertions(+), 27 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index 4e1190894e1e..7e92c37976ac 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -5,6 +5,7 @@
> >
> >  #include "test_tcpbpf.h"
> >  #include "cgroup_helpers.h"
> > +#include "test_tcpbpf_kern.skel.h"
> >
> >  #define LO_ADDR6 "::1"
> >  #define CG_NAME "/tcpbpf-user-test"
> > @@ -162,39 +163,32 @@ static void run_test(int map_fd, int sock_map_fd)
> >
> >  void test_tcpbpf_user(void)
> >  {
> > -       const char *file = "test_tcpbpf_kern.o";
> > -       int prog_fd, map_fd, sock_map_fd;
> > -       struct bpf_object *obj;
> > +       struct test_tcpbpf_kern *skel;
> > +       int map_fd, sock_map_fd;
> > +       struct bpf_link *link;
> >         int cg_fd = -1;
> > -       int rv;
> > -
> > -       cg_fd = cgroup_setup_and_join(CG_NAME);
> > -       if (CHECK_FAIL(cg_fd < 0))
> > -               goto err;
> >
> > -       if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
> > -               fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> > -               goto err;
> > -       }
> > +       skel = test_tcpbpf_kern__open_and_load();
> > +       if (CHECK(!skel, "open and load skel", "failed"))
> > +               return;
> >
> > -       rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> > -       if (CHECK_FAIL(rv)) {
> > -               fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> > -                      errno, strerror(errno));
> > -               goto err;
> > -       }
> > +       cg_fd = test__join_cgroup(CG_NAME);
> > +       if (CHECK_FAIL(cg_fd < 0))
>
> please use either CHECK() or one of the newer ASSERT_xxx() macro (also
> defined in test_progs.h), CHECK_FAIL should be avoided in general.

So the plan I had was to actually move over to the following:
        cg_fd = test__join_cgroup(CG_NAME);
        if (CHECK_FAIL(cg_fd < 0))
                goto cleanup_skel;

It still makes use of CHECK_FAIL but it looks like test__join_cgroup
already takes care of error messaging so using CHECK_FAIL in this case
makes more sense.

In addition I was looking at simplifying the first patch which should
just be the move with minimal changes to allow the functionality to
build as a part of the test_progs framework. The end result should be
the same it just helps to make the fact that the first patch should
just be a move a little more clear.

> > +               goto cleanup_skel;
> >
> > -       map_fd = bpf_find_map(__func__, obj, "global_map");
> > -       if (CHECK_FAIL(map_fd < 0))
> > -               goto err;
> > +       map_fd = bpf_map__fd(skel->maps.global_map);
> > +       sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
> >
> > -       sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> > -       if (CHECK_FAIL(sock_map_fd < 0))
> > -               goto err;
> > +       link = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
>
> you can do skel->links.bpf_testcb = bpf_program__attach_cgroup() and
> skeleton's __destroy() call will take care of destroying the link

Okay, I can look into using that. Actually this has me wondering if
there wouldn't be some way to make use of test_tcpbpf_kern__attach to
achieve this in some standard way. I'll get that sorted before I
submit v2.

> > +       if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
> > +                 PTR_ERR(link)))
>
> there is a convenient ASSERT_OK_PTR() specifically for pointers like
> this (and NULL ones as well, of course); saves a lot of typing and
> encapsulates error extraction internally.

I'll update the code to address that.
