Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F636B690
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhDZQQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbhDZQQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:16:01 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFC6C061756;
        Mon, 26 Apr 2021 09:15:19 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id y2so63452097ybq.13;
        Mon, 26 Apr 2021 09:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W65HWO1I953FJT0oew5Q6Epp76YslztrF5/Kg4s+QXs=;
        b=IwnBJ6EfAm6CaKDcSVDAyYtaC2RTVaE3dg84Z+dRajs42JT0Cvae71/M+Goes8Jze9
         Fga1dTUD+oxGru+4K78VEgKVS5E2A5mi5n66G+GnrhZpIFapD4ioyRJfg9MS0L7tFvHO
         4Ikag1Cncg9jg3vIwRpGiIYSEJKqZKO9FZUFW5QiQ8tBdrHcDPHaXw8INJr+UJRXdZEh
         RyF7gaNMLfAS9VxpsRxPX1pI0v5a7jluTKWS80fZHwXtMHAh513SfTYu1fLi5hBYuxes
         2E4+5rzCYTQ1mC7qnlf/lVqPgSA9YTwI+R9KbWYAECd8vVdbfiDfK6JtQxSEdFlvepqx
         pzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W65HWO1I953FJT0oew5Q6Epp76YslztrF5/Kg4s+QXs=;
        b=Hjs7jkaWIcQUM8MlP4w9BUtVCoVvA+hZiUMDbbiq06kHRYMl/D01NIApZBjxbVtuZt
         sbU6W+nOswAcvnmvgUfvfTp5I8an1UgYX2EIOmuFlBFnOG1VeVAlIDrL3g9UYlAt0IzD
         Ob7hocBH58s6CEzXdvzp9Ajsnqswc7pXfiJD77z4BekWox54ahV8CmZGLoAbZh/9f/WE
         yvs6Z6Jwo/1uVz8Iqj4tuIraHyjm+eghx3nnHvqdudti4eLdwwsapfQ0kFBvhsR0l0S5
         1n1OwZVMDPLhE3KikGb6FiAtd00UXisXZtuyz60LkgTSKT2h2cs0QWdWyCNZ4/O2ap0L
         0kKQ==
X-Gm-Message-State: AOAM533P+IhwMGf3J/en4HH/uOcndJChj5Q7HcOGgVKywyu1t7HHpVom
        dn87/tO46wtbywhofsues8nvxZrOqa6zWqou8pY=
X-Google-Smtp-Source: ABdhPJxjPN8kmRNvhkkFsU2SbTAaxd++0qaqqsTTwByHj5HYGpTFFh+fM6egisdTw4+a9HRK5s42xhC4Eom5elOtjR4=
X-Received: by 2002:a25:2441:: with SMTP id k62mr25266843ybk.347.1619453718576;
 Mon, 26 Apr 2021 09:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-2-andrii@kernel.org>
 <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
 <CAEf4BzYQZCYZ7aXeSW2xJKLeQTvObiO5eabA5XvX34wF1NTBhw@mail.gmail.com> <875z09ca0p.fsf@toke.dk>
In-Reply-To: <875z09ca0p.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 09:15:07 -0700
Message-ID: <CAEf4BzYixzoqzE_c+sd7QoQDg8dGaKf_UBf06AqTmCdUagoJvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx() variants
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 8:59 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Apr 26, 2021 at 1:06 AM Lorenz Bauer <lmb@cloudflare.com> wrote=
:
> >>
> >> On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrot=
e:
> >> >
> >> > Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom l=
ogic to
> >> > true/false. Also add remaining arithmetical assertions:
> >> >   - ASSERT_LE -- less than or equal;
> >> >   - ASSERT_GT -- greater than;
> >> >   - ASSERT_GE -- greater than or equal.
> >> > This should cover most scenarios where people fall back to error-pro=
ne
> >> > CHECK()s.
> >> >
> >> > Also extend ASSERT_ERR() to print out errno, in addition to direct e=
rror.
> >> >
> >> > Also convert few CHECK() instances to ensure new ASSERT_xxx() varian=
ts work as
> >> > expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE mo=
re
> >> > extensively.
> >> >
> >> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >> > ---
> >> >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
> >> >  .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
> >> >  .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
> >> >  .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
> >> >  .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
> >> >  .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
> >> >  tools/testing/selftests/bpf/test_progs.h      | 50 ++++++++++++++++=
++-
> >> >  7 files changed, 56 insertions(+), 15 deletions(-)
> >> >
> >> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/too=
ls/testing/selftests/bpf/prog_tests/btf_dump.c
> >> > index c60091ee8a21..5e129dc2073c 100644
> >> > --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> >> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> >> > @@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_du=
mp_test_case *t)
> >> >
> >> >         snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX"=
, t->file);
> >> >         fd =3D mkstemp(out_file);
> >> > -       if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n=
", fd)) {
> >> > +       if (!ASSERT_GE(fd, 0, "create_tmp")) {
> >>
> >> Nit: I would find ASSERT_LE easier to read here. Inverting boolean
> >> conditions is easy to get wrong.
> >
> > You mean if (ASSERT_LE(fd, -1, "create_tmp")) { err =3D fd; goto done; =
} ?
> >
> > That will mark the test failing if fd >=3D 0, which is exactly opposite
> > to what we wan't. It's confusing because CHECK() checks invalid
> > conditions and returns "true" if it holds. But ASSERT_xxx() checks
> > *valid* condition and returns whether valid condition holds. So the
> > pattern is always
>
> There's already an ASSERT_OK_PTR(), so maybe a corresponding
> ASSERT_OK_FD() would be handy?

I honestly don't see the point. OK_PTR is special, it checks NULL and
the special ERR_PTR() variants, which is a lot of hassle to check
manually. While for FD doing ASSERT_GE(fd, 0) seems to be fine and
just mostly natural. Also for some APIs valid FD is > 0 and for other
cases valid FD is plain >=3D 0, so that just adds to the confusion.

>
> -Toke
>
