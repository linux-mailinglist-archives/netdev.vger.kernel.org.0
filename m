Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5C1372348
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhECW4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhECW4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:56:45 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA92C061574;
        Mon,  3 May 2021 15:55:50 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i4so9738096ybe.2;
        Mon, 03 May 2021 15:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wyY0OfQXGahpoa5vil7fICAmZECAfuR7jBxXJCJUZKU=;
        b=qIibAh+RTZMO/AU/olHKk9REU2NXDiP2UwOA98vzIs9hTl3a9JoP2vsnhKuriBY2Qe
         FEK2lNgFhVW+0DoEXtWTD/Rzf7WFINOPL1g5o2zuwOPJVWrelGQVy9ryMPC0ixdOcGuV
         yHSi1RPrVH+rSuDESRa2WOW5eZ4l5WzcPqd5T4X+3qMYb9Svs/z4jhmeCkJ49nBN9T5d
         UR52rJKilGGu2DTEu1c1xIBV5j9enRlST7PjjpUkj8lbYCFthSoNqPKmWcPkOh13wluX
         3fb3G6pNDl8XkSN41HtwsMYWmnZ2QEk5JWPmm9bYmvC+vR6f5K6EsHOwoZ66tZZGR7tl
         kH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wyY0OfQXGahpoa5vil7fICAmZECAfuR7jBxXJCJUZKU=;
        b=Ak0d+n9Hn28wSJURZAb+I6Kxq7dtNpYqWJw0wllJ08GZcQHvRyST4X/fiWHK/4QXXk
         4v5Uqb/rQEaOV6cloNWZH/2nLUISsmJjzJfyjTl8ZpYk8+tXMa12Ah9LzP0iaYFtZQ3Q
         Wkl57XJj7fadpLVkeVKUyDh/YtlUt6/GrXQMuuRsrh10AkvTpbZRhteFnB5G+FWx01je
         PcLzsHVGzP0XZa4/ctUGQCMYpvVMbi3+eQ1K4xUxxVAH8IlaPefCjgzqluNqeXS2B7JF
         /Ozr9uBV6yVegLFXhijy80p5Vzmy93KNWjKp8jLgY1YdkjYN5ksc5CY6eoSENRc5Qx3W
         KzjQ==
X-Gm-Message-State: AOAM533mg8yQ3an5qr+S1QjRLI5sbZAFZuPBANjkPajQygp3gToVbwNQ
        tNjItFS43KD8wD/dpf7fHgq5esiwMO0yISk8B00=
X-Google-Smtp-Source: ABdhPJwmF/CN/jZYQPRG95IAWBJy/X6VruB5qpnmta9yGbBuYIcPIUZxLqkLiMoZJYv+Epeus+DVB22l1V+s24cU3/M=
X-Received: by 2002:a25:7507:: with SMTP id q7mr30445068ybc.27.1620082550094;
 Mon, 03 May 2021 15:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210428162553.719588-1-memxor@gmail.com> <20210428162553.719588-4-memxor@gmail.com>
 <CAEf4BzYp1uN4E_=0N7DpwkEQOxntP0riz__yUzz3xu=k4yJ4sw@mail.gmail.com> <20210501063436.fcts6od3ua2mxojl@apollo>
In-Reply-To: <20210501063436.fcts6od3ua2mxojl@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 May 2021 15:55:39 -0700
Message-ID: <CAEf4BzaZLEHF-Sg3H7Q5ERxPhw++ok0samjj9C4ET2ttXqztGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/3] libbpf: add selftests for TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:34 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, May 01, 2021 at 01:11:47AM IST, Andrii Nakryiko wrote:
> > On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This adds some basic tests for the low level bpf_tc_* API.
> > >
> > > Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 467 ++++++++++++++++=
++
> > >  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
> > >  2 files changed, 479 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
> > >

[...]

> >
> > > +
> > > +       /* attach */
> > > +       ret =3D bpf_tc_attach(NULL, &attach_opts, 0);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook =3D =
NULL"))
> > > +               return -EINVAL;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 42);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid flags"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_fd =3D 0;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_fd u=
nset"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_fd =3D fd;
> > > +       attach_opts.prog_id =3D 42;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id s=
et"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_id =3D 0;
> > > +       attach_opts.handle =3D 0;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid handle unset"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> > > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach")=
;
> >
> > this code is quite hard to follow, maybe sprinkle empty lines between
> > logical groups of statements (i.e., prepare inputs + call bpf_tc_xxx +
> > assert is one group that goes together)
> >
>
> I agree it looks bad. I can also just make a new opts for each combinatio=
n, and
> name it that way. Maybe that will look much better.

It probably would be just more code to read. Try to space it out with
empty lines into logical groups, that should be enough.

>
> > > +       attach_opts.prog_fd =3D fd;
> > > +       attach_opts.handle =3D 1;
> > > +       attach_opts.priority =3D 0;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid priority unset"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> > > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach")=
;
> > > +       attach_opts.prog_fd =3D fd;
> > > +       attach_opts.priority =3D UINT16_MAX + 1;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid priority =
> UINT16_MAX"))
> > > +               return -EINVAL;
> > > +       attach_opts.priority =3D 0;
> > > +       attach_opts.handle =3D attach_opts.priority =3D 0;
> > > +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> > > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid both handle and prio=
rity unset"))
> > > +               return -EINVAL;
> > > +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> > > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach")=
;
> > > +       ret =3D bpf_tc_attach(hook, NULL, 0);
> > > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts =3D =
NULL"))
> > > +               return -EINVAL;
> > > +
> > > +       return 0;
> > > +}
> > > +

[...]
