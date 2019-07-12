Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC34E66332
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 03:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfGLA76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:59:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33953 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGLA76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:59:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so6501567qtq.1;
        Thu, 11 Jul 2019 17:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vyRvdglp9w3WMAVwpZ8V5acwRWpsWl+iTtdEW4rvar4=;
        b=txxE7X8WbuCKhCRBQru177MjuZze+pZCDz3RdJ4rEwr3Eb96rvgOhODAT0S/Xjmp9e
         Gni8eX3BUNl8IyyKLVNknIJmMObUbzLUuNH/mDHhD6JyPrICshHweZEWKFuAaN4pXJqu
         dKSFAFdAYFPnXuC05uU0QeDj2E2cDBR920oDu4WAC2m0w63JVhMS6umkNXSJoKcIvO7E
         GtDhanc7eUXsVAQN8rpwJALT0FWxmqPXAmW7RpsJ9suJEVumWCIqt8BIIrVLFyRHY3Ax
         nsj1kcysn/Rrm7zxT6MKFnlsKE+P7PXWYbTFGdeuXzwp1L7E1R9ryUtnWXFEsMXxuoE3
         8IeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vyRvdglp9w3WMAVwpZ8V5acwRWpsWl+iTtdEW4rvar4=;
        b=SssxtIbtCDllkKez6ptjmVSp0H372ZQvY+Z63xCNV/UIF9B90kt31nH9MrcslffUPE
         S0X4ZpXwuERvmnBJl8j0lX653ByYS7JRylfffgxsh79Mmm85TunNOESS1DOpAsUnxgJG
         Gxh5mWfnRWqk3rbRAkBfSRI7dx1ezsJ3vv2i0Vtzp/5EhuXwze0yOR2u8WlfiRIwShX7
         2olgKjo4eO+RHnc878J6YSYKeV88/uoB2RA+j0d6L7hod8sIYLvRo3yrxQpOg/hdzOnl
         uaoEX20k9WCk4xyY35t/qsPOtK+OdWzXtD/NNoPinLm7KgFaEHDEGC6z2zPzWYRLP0zL
         OVrw==
X-Gm-Message-State: APjAAAWob6Jad1/6pK5Gy4+3rWWG/vdkYx04FOhr3JLkcrwfZfSsVfyD
        gAVYQEtR477eLf7Nf6VT8rUukmAg9Nfme3XjKKM=
X-Google-Smtp-Source: APXvYqx/nmtN0ibOY1gKjWppu+MVnXd5hpjXGLRUTESB0ttPXoJNPVWlFkEp6N20LfxCuAlfqEqOIkKtHWjb2rkA+5M=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr3869170qtp.93.1562893196956;
 Thu, 11 Jul 2019 17:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-3-krzesimir@kinvolk.io>
 <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com> <CAGGp+cGnEBFoPAuhTPa_JFCW6Vbjp2NN0ZPqC3qGfWEXwTyVOQ@mail.gmail.com>
In-Reply-To: <CAGGp+cGnEBFoPAuhTPa_JFCW6Vbjp2NN0ZPqC3qGfWEXwTyVOQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:59:46 -0700
Message-ID: <CAEf4Bzb-KW+p1zFcz39OSUuH0=DLFRNLa3NYT4V_-zz0Q_TJ5g@mail.gmail.com>
Subject: Re: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 5:04 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrot=
e:
>
> On Thu, Jul 11, 2019 at 1:52 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> w=
rote:
> > >
> > > Save errno right after bpf_prog_test_run returns, so we later check
> > > the error code actually set by bpf_prog_test_run, not by some libcap
> > > function.
> > >
> > > Changes since v1:
> > > - Fix the "Fixes:" tag to mention actual commit that introduced the
> > >   bug
> > >
> > > Changes since v2:
> > > - Move the declaration so it fits the reverse christmas tree style.
> > >
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in=
 test_verifier")
> > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/test=
ing/selftests/bpf/test_verifier.c
> > > index b8d065623ead..3fe126e0083b 100644
> > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > @@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool u=
npriv, uint32_t expected_val,
> > >         __u8 tmp[TEST_DATA_LEN << 2];
> > >         __u32 size_tmp =3D sizeof(tmp);
> > >         uint32_t retval;
> > > +       int saved_errno;
> > >         int err;
> > >
> > >         if (unpriv)
> > >                 set_admin(true);
> > >         err =3D bpf_prog_test_run(fd_prog, 1, data, size_data,
> > >                                 tmp, &size_tmp, &retval, NULL);
> >
> > Given err is either 0 or -1, how about instead making err useful right
> > here without extra variable?
> >
> > if (bpf_prog_test_run(...))
> >         err =3D errno;
>
> I change it later to bpf_prog_test_run_xattr, which can also return
> -EINVAL and then errno is not set. But this one probably should not be

This is wrong. bpf_prog_test_run/bpf_prog_test_run_xattr should either
always return -1 and set errno to actual error (like syscalls do), or
always use return code with proper error. Give they are pretending to
be just pure syscall, it's probably better to set errno to EINVAL and
return -1 on invalid input args?

> triggered by the test code. So not sure, probably would be better to
> keep it as is for consistency?
>
> >
> > > +       saved_errno =3D errno;
> > >         if (unpriv)
> > >                 set_admin(false);
> > >         if (err) {
> > > -               switch (errno) {
> > > +               switch (saved_errno) {
> > >                 case 524/*ENOTSUPP*/:
> >
> > ENOTSUPP is defined in include/linux/errno.h, is there any problem
> > with using this in selftests?
>
> I just used whatever there was earlier. Seems like <linux/errno.h> is
> not copied to tools include directory.

Ok, let's leave it as is, thanks!

>
> >
> > >                         printf("Did not run the program (not supporte=
d) ");
> > >                         return 0;
> > > --
> > > 2.20.1
> > >
>
>
>
> --
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago =
L=C3=B3pez Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
