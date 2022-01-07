Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590A5487DFF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiAGVIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiAGVIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:08:12 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF28C061574;
        Fri,  7 Jan 2022 13:08:12 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id 9so5564594ill.9;
        Fri, 07 Jan 2022 13:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LJirhlem26RddY5c3WJEkpQ7KclARQdVjBraFWctd8U=;
        b=JaLl4QRMtZ9kw1L7sQnO8Ys0EEgJEysTX4SfhRs6enoNqFYgBw/nV/CErurJ4S0fm5
         jw25p3alyYGTGfoBWFglDRaQdODDgQmr4+c3hDsPvdIbkBXTcK5e19swWSoMuQ40kFCl
         WxQWzeRzv9yLGTRL8GdZgsdq1ndgiEapWIrpvtp/c7NLHwhaFqmDqaDrV9eMW72NkE+/
         WEAQHWSfPcqB7uivy+JSpQzDgZ1+pRiCnsVZbDv0pXoIeWycHXzq+J3tw9JCOQGuoPkC
         q7bADDtbpKPTyCYR96sDh/LkARSPiq65n144L9sQBfAQt2cmowhGc0NhQoa7crbyQFhB
         5nsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LJirhlem26RddY5c3WJEkpQ7KclARQdVjBraFWctd8U=;
        b=u8PaQ89Fcwf5p1uEeuGEohC4ACp6UrgRJBJZEEsSi1bYgS9FJqrS7kscf0XmpS2Pvi
         COeBZTwSdunfQSjHjxh79NIi47whoJJW3mpqYldgwakN3ePF9Fn/iE/ygn45TSJZxUk2
         /L+h360nEQpQXdJb1Jlf+58aizhVLPChszkU/g13bkdzUxbiGB0nTGynsIgk4auT2gUq
         QsXd5NhFL9vGwyu7xnyzxAJhocXj8eKXDNa5RGHfadtK5Z2g3PrUr4dLFcStN6iZQyMO
         yAA3wvN4FQgGiCxNKiVk0RTVUAeT3Ez4dmibOBqjlfZOoa9o3uorPS3kaIZ0Bml87GfK
         wxRA==
X-Gm-Message-State: AOAM531ICygrGf3kbUEK8Q64G21BaEeOwUbP5fbaZ+qJyTMyqmFT8+oe
        rTQp7zCsNG1BJAII/wWa6VCH3trrYa9l0llpCbw=
X-Google-Smtp-Source: ABdhPJyAE91p9MaUCXyHnSqIROXhpgAMuAVgBaYXyGwqWAMNDuasO65x6vF9xYqjKBahR+Lnx01hzRX4QPQHq/YbXhQ=
X-Received: by 2002:a05:6e02:1c06:: with SMTP id l6mr663385ilh.239.1641589691858;
 Fri, 07 Jan 2022 13:08:11 -0800 (PST)
MIME-Version: 1.0
References: <20220107183049.311134-1-toke@redhat.com> <20220107183049.311134-2-toke@redhat.com>
In-Reply-To: <20220107183049.311134-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Jan 2022 13:08:00 -0800
Message-ID: <CAEf4BzadXK+DiiVEgkZNuDA8=QdVZGSqPsAia7g39GTnQqSpQg@mail.gmail.com>
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

On Fri, Jan 7, 2022 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Add a check to the xdp_link selftest that the kernel rejects replacing an
> XDP program with a different program type on link update. Convert the
> selftest to use the preferred ASSERT_* macros while we're at it.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_link.c       | 62 +++++++++----------
>  .../selftests/bpf/progs/test_xdp_link.c       |  6 ++
>  2 files changed, 37 insertions(+), 31 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/te=
sting/selftests/bpf/prog_tests/xdp_link.c
> index 983ab0b47d30..8660e68383ea 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
> @@ -8,46 +8,47 @@
>
>  void serial_test_xdp_link(void)
>  {
> -       __u32 duration =3D 0, id1, id2, id0 =3D 0, prog_fd1, prog_fd2, er=
r;
>         DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd =3D -1);
>         struct test_xdp_link *skel1 =3D NULL, *skel2 =3D NULL;
> +       __u32 id1, id2, id0 =3D 0, prog_fd1, prog_fd2;
>         struct bpf_link_info link_info;
>         struct bpf_prog_info prog_info;
>         struct bpf_link *link;
> +       int err;
>         __u32 link_info_len =3D sizeof(link_info);
>         __u32 prog_info_len =3D sizeof(prog_info);
>
>         skel1 =3D test_xdp_link__open_and_load();
> -       if (CHECK(!skel1, "skel_load", "skeleton open and load failed\n")=
)
> +       if (!ASSERT_OK_PTR(skel1, "skel_load"))
>                 goto cleanup;
>         prog_fd1 =3D bpf_program__fd(skel1->progs.xdp_handler);
>
>         skel2 =3D test_xdp_link__open_and_load();
> -       if (CHECK(!skel2, "skel_load", "skeleton open and load failed\n")=
)
> +       if (!ASSERT_OK_PTR(skel2, "skel_load"))
>                 goto cleanup;
>         prog_fd2 =3D bpf_program__fd(skel2->progs.xdp_handler);
>
>         memset(&prog_info, 0, sizeof(prog_info));
>         err =3D bpf_obj_get_info_by_fd(prog_fd1, &prog_info, &prog_info_l=
en);
> -       if (CHECK(err, "fd_info1", "failed %d\n", -errno))
> +       if (!ASSERT_OK(err, "fd_info1"))
>                 goto cleanup;
>         id1 =3D prog_info.id;
>
>         memset(&prog_info, 0, sizeof(prog_info));
>         err =3D bpf_obj_get_info_by_fd(prog_fd2, &prog_info, &prog_info_l=
en);
> -       if (CHECK(err, "fd_info2", "failed %d\n", -errno))
> +       if (!ASSERT_OK(err, "fd_info2"))
>                 goto cleanup;
>         id2 =3D prog_info.id;
>
>         /* set initial prog attachment */
>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLAGS_=
REPLACE, &opts);
> -       if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n", e=
rr))
> +       if (!ASSERT_OK(err, "fd_attach"))
>                 goto cleanup;
>
>         /* validate prog ID */
>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> -       CHECK(err || id0 !=3D id1, "id1_check",
> -             "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err);
> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1=
_check_val"))
> +               goto cleanup;
>
>         /* BPF link is not allowed to replace prog attachment */
>         link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDE=
X_LO);
> @@ -62,7 +63,7 @@ void serial_test_xdp_link(void)
>         /* detach BPF program */
>         opts.old_fd =3D prog_fd1;
>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLAC=
E, &opts);
> -       if (CHECK(err, "prog_detach", "failed %d\n", err))
> +       if (!ASSERT_OK(err, "prog_detach"))
>                 goto cleanup;
>
>         /* now BPF link should attach successfully */
> @@ -73,24 +74,23 @@ void serial_test_xdp_link(void)
>
>         /* validate prog ID */
>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> -       if (CHECK(err || id0 !=3D id1, "id1_check",
> -                 "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err)=
)
> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1=
_check_val"))
>                 goto cleanup;
>
>         /* BPF prog attach is not allowed to replace BPF link */
>         opts.old_fd =3D prog_fd1;
>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLAGS_=
REPLACE, &opts);
> -       if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
> +       if (!ASSERT_ERR(err, "prog_attach_fail"))
>                 goto cleanup;
>
>         /* Can't force-update when BPF link is active */
>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
> -       if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
> +       if (!ASSERT_ERR(err, "prog_update_fail"))
>                 goto cleanup;
>
>         /* Can't force-detach when BPF link is active */
>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
> -       if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
> +       if (!ASSERT_ERR(err, "prog_detach_fail"))
>                 goto cleanup;
>
>         /* BPF link is not allowed to replace another BPF link */
> @@ -110,40 +110,40 @@ void serial_test_xdp_link(void)
>         skel2->links.xdp_handler =3D link;
>
>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
> -       if (CHECK(err || id0 !=3D id2, "id2_check",
> -                 "loaded prog id %u !=3D id2 %u, err %d", id0, id1, err)=
)
> +       if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "id2=
_check_val"))
>                 goto cleanup;
>
>         /* updating program under active BPF link works as expected */
>         err =3D bpf_link__update_program(link, skel1->progs.xdp_handler);
> -       if (CHECK(err, "link_upd", "failed: %d\n", err))
> +       if (!ASSERT_OK(err, "link_upd"))
>                 goto cleanup;
>
>         memset(&link_info, 0, sizeof(link_info));
>         err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &l=
ink_info_len);
> -       if (CHECK(err, "link_info", "failed: %d\n", err))
> +       if (!ASSERT_OK(err, "link_info"))
> +               goto cleanup;
> +
> +       if (!ASSERT_EQ(link_info.type, BPF_LINK_TYPE_XDP, "link_type") ||
> +           !ASSERT_EQ(link_info.prog_id, id1, "link_prog_id") ||
> +           !ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifindex")=
)
>                 goto cleanup;
>
> -       CHECK(link_info.type !=3D BPF_LINK_TYPE_XDP, "link_type",
> -             "got %u !=3D exp %u\n", link_info.type, BPF_LINK_TYPE_XDP);
> -       CHECK(link_info.prog_id !=3D id1, "link_prog_id",
> -             "got %u !=3D exp %u\n", link_info.prog_id, id1);
> -       CHECK(link_info.xdp.ifindex !=3D IFINDEX_LO, "link_ifindex",
> -             "got %u !=3D exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);

these checks were done unconditionally (and all of them), even if one
of the fails. Why did you do goto cleanup for those. Similarly below.
It's much cleaner to just have three ASSERT_EQ() statements one after
the other with no if() goto cleanup;

> +       /* updating program under active BPF link with different type fai=
ls */
> +       err =3D bpf_link__update_program(link, skel1->progs.tc_handler);
> +       if (!ASSERT_ERR(err, "link_upd_invalid"))
> +               goto cleanup;
>
>         err =3D bpf_link__detach(link);
> -       if (CHECK(err, "link_detach", "failed %d\n", err))
> +       if (!ASSERT_OK(err, "link_detach"))
>                 goto cleanup;
>
>         memset(&link_info, 0, sizeof(link_info));
>         err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &l=
ink_info_len);
> -       if (CHECK(err, "link_info", "failed: %d\n", err))
> +       if (!ASSERT_OK(err, "link_info") ||
> +           !ASSERT_EQ(link_info.prog_id, id1, "link_prog_id") ||
> +           /* ifindex should be zeroed out */
> +           !ASSERT_EQ(link_info.xdp.ifindex, 0, "link_ifindex"))
>                 goto cleanup;
> -       CHECK(link_info.prog_id !=3D id1, "link_prog_id",
> -             "got %u !=3D exp %u\n", link_info.prog_id, id1);
> -       /* ifindex should be zeroed out */
> -       CHECK(link_info.xdp.ifindex !=3D 0, "link_ifindex",
> -             "got %u !=3D exp %u\n", link_info.xdp.ifindex, 0);

same here, CHECK() with no if is just ASSERT_xxx() with no if

>
>  cleanup:
>         test_xdp_link__destroy(skel1);
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_link.c b/tools/te=
sting/selftests/bpf/progs/test_xdp_link.c
> index ee7d6ac0f615..64ff32eaae92 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_link.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_link.c
> @@ -10,3 +10,9 @@ int xdp_handler(struct xdp_md *xdp)
>  {
>         return 0;
>  }
> +
> +SEC("tc")
> +int tc_handler(struct __sk_buff *skb)
> +{
> +       return 0;
> +}
> --
> 2.34.1
>
