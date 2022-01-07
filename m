Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95073487E44
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiAGVaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiAGVaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:30:13 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25103C061574;
        Fri,  7 Jan 2022 13:30:13 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 19so8736183ioz.4;
        Fri, 07 Jan 2022 13:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6HN4dTXPcZ8eKGhT5FJ+Y5CkYFpTLx4O2n6/0dOuA1o=;
        b=GbvUTfZt3m7T0+djugBR3kaKWeLimoBcDcEhEzdaWwlH1XTKwkEPGT1m5dTmYeevza
         NVgpM1VagPSGAaLQGSJMTmTJl3iHROVef6yDpjKS2gA4GmKHGzeRrKi5C3jPgS67dyxX
         UruFOTq9rRmdyStc00fHjqcj5PV2qiTr3DDJ/sZGuFONbJ4qrnkVSDFaIjQ1m1mBj2Wa
         2V5IE/XS6DcNA7dhYL7ujYybb9/ZdQ9oMtaTmc2rBLsG1DpxTLLoTuVFbqIuYfSi3DjE
         6smrGnRV98XXLQgquLTdy+KX8qIxH80aYvcLEEg9nwMACNP0rfEWMxLOpVInB0VD8iIf
         S1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6HN4dTXPcZ8eKGhT5FJ+Y5CkYFpTLx4O2n6/0dOuA1o=;
        b=DzUkAszl7w8kRuubXDZ7McZ4t/7J2oNdLdVbU/FfPwzech08lz6nEpzR3y4C2XHQer
         cyo2ivGmdRAu9t8TnCSl8NZKLGVVYHFfoH6/Ql2rgQZsn3genUt8BivJRyjUiQIpFj0q
         mCDPmDOIRmXXQS69Z2r72g6sQkEa1sLZ+t6HqlvIi+GoaLCJIAYBz4epKYRpifNBWhrC
         8W7hPj1Z6bm1NDV4B8Nvxc2qT7FuiuqcLeQ4g6V38utO+Q9kqmWGLsNbn/DthGZvuHhL
         gIurLvUdGyrkajfh/ElWe/PrVZp52dfiWv3q/5OO4041nxB2tF5Z/lfd1VUrCpjKEhTF
         pVYA==
X-Gm-Message-State: AOAM533WrotyYD8BvkXmSth/SlOSGFR/SAEGGZY4qBEVj2HOSm7rqYTa
        UXcbbBn7aZoTdwuHPjmh/zMksOyJuRLerKI+CBo=
X-Google-Smtp-Source: ABdhPJz7z+8WsDi96aSjkDk3o2eNLz4gaxG2ENN0+Dced6+NEhL5imD8VFBmBhW0kiKlkI8Tel/bUOiH/Va0AzxyGqw=
X-Received: by 2002:a02:ce8f:: with SMTP id y15mr26091179jaq.234.1641591012484;
 Fri, 07 Jan 2022 13:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20220107183049.311134-1-toke@redhat.com> <20220107183049.311134-2-toke@redhat.com>
 <CAEf4BzadXK+DiiVEgkZNuDA8=QdVZGSqPsAia7g39GTnQqSpQg@mail.gmail.com> <87v8yv8cl9.fsf@toke.dk>
In-Reply-To: <87v8yv8cl9.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Jan 2022 13:30:01 -0800
Message-ID: <CAEf4BzaqLAX6gwU=zY=gWeBFiTE6fWmuzFoP4yOnMqC+tjafGg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf/selftests: Add check for updating XDP
 bpf_link with wrong program type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 1:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Jan 7, 2022 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Add a check to the xdp_link selftest that the kernel rejects replacing=
 an
> >> XDP program with a different program type on link update. Convert the
> >> selftest to use the preferred ASSERT_* macros while we're at it.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  .../selftests/bpf/prog_tests/xdp_link.c       | 62 +++++++++---------=
-
> >>  .../selftests/bpf/progs/test_xdp_link.c       |  6 ++
> >>  2 files changed, 37 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_link.c
> >> index 983ab0b47d30..8660e68383ea 100644
> >> --- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
> >> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
> >> @@ -8,46 +8,47 @@
> >>
> >>  void serial_test_xdp_link(void)
> >>  {
> >> -       __u32 duration =3D 0, id1, id2, id0 =3D 0, prog_fd1, prog_fd2,=
 err;
> >>         DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd =3D -=
1);
> >>         struct test_xdp_link *skel1 =3D NULL, *skel2 =3D NULL;
> >> +       __u32 id1, id2, id0 =3D 0, prog_fd1, prog_fd2;
> >>         struct bpf_link_info link_info;
> >>         struct bpf_prog_info prog_info;
> >>         struct bpf_link *link;
> >> +       int err;
> >>         __u32 link_info_len =3D sizeof(link_info);
> >>         __u32 prog_info_len =3D sizeof(prog_info);
> >>
> >>         skel1 =3D test_xdp_link__open_and_load();
> >> -       if (CHECK(!skel1, "skel_load", "skeleton open and load failed\=
n"))
> >> +       if (!ASSERT_OK_PTR(skel1, "skel_load"))
> >>                 goto cleanup;
> >>         prog_fd1 =3D bpf_program__fd(skel1->progs.xdp_handler);
> >>
> >>         skel2 =3D test_xdp_link__open_and_load();
> >> -       if (CHECK(!skel2, "skel_load", "skeleton open and load failed\=
n"))
> >> +       if (!ASSERT_OK_PTR(skel2, "skel_load"))
> >>                 goto cleanup;
> >>         prog_fd2 =3D bpf_program__fd(skel2->progs.xdp_handler);
> >>
> >>         memset(&prog_info, 0, sizeof(prog_info));
> >>         err =3D bpf_obj_get_info_by_fd(prog_fd1, &prog_info, &prog_inf=
o_len);
> >> -       if (CHECK(err, "fd_info1", "failed %d\n", -errno))
> >> +       if (!ASSERT_OK(err, "fd_info1"))
> >>                 goto cleanup;
> >>         id1 =3D prog_info.id;
> >>
> >>         memset(&prog_info, 0, sizeof(prog_info));
> >>         err =3D bpf_obj_get_info_by_fd(prog_fd2, &prog_info, &prog_inf=
o_len);
> >> -       if (CHECK(err, "fd_info2", "failed %d\n", -errno))
> >> +       if (!ASSERT_OK(err, "fd_info2"))
> >>                 goto cleanup;
> >>         id2 =3D prog_info.id;
> >>
> >>         /* set initial prog attachment */
> >>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLA=
GS_REPLACE, &opts);
> >> -       if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n"=
, err))
> >> +       if (!ASSERT_OK(err, "fd_attach"))
> >>                 goto cleanup;
> >>
> >>         /* validate prog ID */
> >>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> >> -       CHECK(err || id0 !=3D id1, "id1_check",
> >> -             "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err);
> >> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "=
id1_check_val"))
> >> +               goto cleanup;
> >>
> >>         /* BPF link is not allowed to replace prog attachment */
> >>         link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFI=
NDEX_LO);
> >> @@ -62,7 +63,7 @@ void serial_test_xdp_link(void)
> >>         /* detach BPF program */
> >>         opts.old_fd =3D prog_fd1;
> >>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REP=
LACE, &opts);
> >> -       if (CHECK(err, "prog_detach", "failed %d\n", err))
> >> +       if (!ASSERT_OK(err, "prog_detach"))
> >>                 goto cleanup;
> >>
> >>         /* now BPF link should attach successfully */
> >> @@ -73,24 +74,23 @@ void serial_test_xdp_link(void)
> >>
> >>         /* validate prog ID */
> >>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> >> -       if (CHECK(err || id0 !=3D id1, "id1_check",
> >> -                 "loaded prog id %u !=3D id1 %u, err %d", id0, id1, e=
rr))
> >> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "=
id1_check_val"))
> >>                 goto cleanup;
> >>
> >>         /* BPF prog attach is not allowed to replace BPF link */
> >>         opts.old_fd =3D prog_fd1;
> >>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLA=
GS_REPLACE, &opts);
> >> -       if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
> >> +       if (!ASSERT_ERR(err, "prog_attach_fail"))
> >>                 goto cleanup;
> >>
> >>         /* Can't force-update when BPF link is active */
> >>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
> >> -       if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
> >> +       if (!ASSERT_ERR(err, "prog_update_fail"))
> >>                 goto cleanup;
> >>
> >>         /* Can't force-detach when BPF link is active */
> >>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
> >> -       if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
> >> +       if (!ASSERT_ERR(err, "prog_detach_fail"))
> >>                 goto cleanup;
> >>
> >>         /* BPF link is not allowed to replace another BPF link */
> >> @@ -110,40 +110,40 @@ void serial_test_xdp_link(void)
> >>         skel2->links.xdp_handler =3D link;
> >>
> >>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> >> -       if (CHECK(err || id0 !=3D id2, "id2_check",
> >> -                 "loaded prog id %u !=3D id2 %u, err %d", id0, id1, e=
rr))
> >> +       if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "=
id2_check_val"))
> >>                 goto cleanup;
> >>
> >>         /* updating program under active BPF link works as expected */
> >>         err =3D bpf_link__update_program(link, skel1->progs.xdp_handle=
r);
> >> -       if (CHECK(err, "link_upd", "failed: %d\n", err))
> >> +       if (!ASSERT_OK(err, "link_upd"))
> >>                 goto cleanup;
> >>
> >>         memset(&link_info, 0, sizeof(link_info));
> >>         err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info,=
 &link_info_len);
> >> -       if (CHECK(err, "link_info", "failed: %d\n", err))
> >> +       if (!ASSERT_OK(err, "link_info"))
> >> +               goto cleanup;
> >> +
> >> +       if (!ASSERT_EQ(link_info.type, BPF_LINK_TYPE_XDP, "link_type")=
 ||
> >> +           !ASSERT_EQ(link_info.prog_id, id1, "link_prog_id") ||
> >> +           !ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifinde=
x"))
> >>                 goto cleanup;
> >>
> >> -       CHECK(link_info.type !=3D BPF_LINK_TYPE_XDP, "link_type",
> >> -             "got %u !=3D exp %u\n", link_info.type, BPF_LINK_TYPE_XD=
P);
> >> -       CHECK(link_info.prog_id !=3D id1, "link_prog_id",
> >> -             "got %u !=3D exp %u\n", link_info.prog_id, id1);
> >> -       CHECK(link_info.xdp.ifindex !=3D IFINDEX_LO, "link_ifindex",
> >> -             "got %u !=3D exp %u\n", link_info.xdp.ifindex, IFINDEX_L=
O);
> >
> > these checks were done unconditionally (and all of them), even if one
> > of the fails. Why did you do goto cleanup for those. Similarly below.
> > It's much cleaner to just have three ASSERT_EQ() statements one after
> > the other with no if() goto cleanup;
>
> Because I figured the absence of a 'goto cleanup' was an oversight :)

Nope, completely intentional. There are cases when we need to goto
(e.g., we got invalid pointer or something, so it will crash if we
continue testing). But for cases when we have a bunch of different
properties to validate, I think it's cleaner to validate all of them
unconditionally with no ifs. If any of them is wrong, the test will be
marked failed anyways. But we'll also see all invalid values, not just
the first one, which helps with testing. It's also easier to follow
sequential code. We do this in multiple tests, it's not a coincidence.

>
> Not sure why you think it's cleaner, but I don't have any strong opinion
> about it either way, so I can respin get rid of the containing ifs if
> you prefer...

Yes, please do. It would be also nice if you could split selftest
change into two: one adding new test step (checking that invalid
update fails) and another that converts CHECKs to ASSERTs. Thanks!


>
> -Toke
>
