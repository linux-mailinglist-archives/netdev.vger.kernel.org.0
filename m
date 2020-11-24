Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520992C29BB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbgKXOdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:33:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388514AbgKXOdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606228397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ESyS+WMCSEdJqVArdghIaq910vepY8FdPGVN96WIOo=;
        b=N77iu83EvQP+Z91lnff7yNM7s/JxkLVEZ0/2mSjMCjm/Zm73ULDnzjoO4QP5SkWffL+8d5
        mMGmE4tmFP47b8ADS+rYbU1KxIuY+g26XBb0kGYA6mLbLe0MwK3dwo6y8VV+Bg3wN9tC9I
        6u0yxnVaqSyRHaMei9ts9PHKlABdnb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-zi4tAsyWOpmdWdk5wacgAA-1; Tue, 24 Nov 2020 09:33:12 -0500
X-MC-Unique: zi4tAsyWOpmdWdk5wacgAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F48A805BF4;
        Tue, 24 Nov 2020 14:33:09 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C473660C43;
        Tue, 24 Nov 2020 14:33:02 +0000 (UTC)
Date:   Tue, 24 Nov 2020 15:33:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V7 8/8] bpf/selftests: activating bpf_check_mtu
 BPF-helper
Message-ID: <20201124153301.47abc09c@carbon>
In-Reply-To: <CAEf4BzbfqvCiHDaZk3yQCPfzwpGJ-35XBw3qaGuPNYkfBHR2Kw@mail.gmail.com>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
        <160588912738.2817268.9380466634324530673.stgit@firesoul>
        <CAEf4BzbfqvCiHDaZk3yQCPfzwpGJ-35XBw3qaGuPNYkfBHR2Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 23:41:11 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Fri, Nov 20, 2020 at 8:21 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> > it can be used from both XDP and TC.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/check_mtu.c |   37 ++++++++++++=
++++++++
> >  tools/testing/selftests/bpf/progs/test_check_mtu.c |   33 ++++++++++++=
++++++
> >  2 files changed, 70 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools=
/testing/selftests/bpf/prog_tests/check_mtu.c
> > new file mode 100644
> > index 000000000000..09b8f986a17b
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> > @@ -0,0 +1,37 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Red Hat */
> > +#include <uapi/linux/bpf.h>
> > +#include <linux/if_link.h>
> > +#include <test_progs.h>
> > +
> > +#include "test_check_mtu.skel.h"
> > +#define IFINDEX_LO 1
> > +
> > +void test_check_mtu_xdp(struct test_check_mtu *skel) =20
>=20
> this should be static func, otherwise it's treated as an independent self=
test.

Ok, fixed.

> > +{
> > +       int err =3D 0;
> > +       int fd;
> > +
> > +       fd =3D bpf_program__fd(skel->progs.xdp_use_helper);
> > +       err =3D bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
> > +       if (CHECK_FAIL(err)) =20
>=20
> please use CHECK() or one of ASSERT_xxx() helpers. CHECK_FAIL() should
> be used for high-volume unlikely to fail test (i.e., very rarely).

I could not get CHECK() macro working.  I now realize that this is
because I've not defined a global static variable named 'duration'.

 static __u32 duration;

I wonder, are there any best-practice documentation or blogpost on
howto write these bpf-selftests?


Below signature is the compile error for others to Google for, and
solution above.
-=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


$ make
  TEST-OBJ [test_progs] check_mtu.test.o
In file included from /home/jbrouer/git/kernel/bpf-next/tools/testing/selft=
ests/bpf/prog_tests/check_mtu.c:6:
/home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/ch=
eck_mtu.c: In function =E2=80=98test_check_mtu=E2=80=99:
./test_progs.h:129:25: error: =E2=80=98duration=E2=80=99 undeclared (first =
use in this function)
  129 |  _CHECK(condition, tag, duration, format)
      |                         ^~~~~~~~
./test_progs.h:111:25: note: in definition of macro =E2=80=98_CHECK=E2=80=99
  111 |          __func__, tag, duration);   \
      |                         ^~~~~~~~
/home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/ch=
eck_mtu.c:33:6: note: in expansion of macro =E2=80=98CHECK=E2=80=99
   33 |  if (CHECK(!skel, "open and load skel", "failed"))
      |      ^~~~~
./test_progs.h:129:25: note: each undeclared identifier is reported only on=
ce for each function it appears in
  129 |  _CHECK(condition, tag, duration, format)
      |                         ^~~~~~~~
./test_progs.h:111:25: note: in definition of macro =E2=80=98_CHECK=E2=80=99
  111 |          __func__, tag, duration);   \
      |                         ^~~~~~~~
/home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/prog_tests/ch=
eck_mtu.c:33:6: note: in expansion of macro =E2=80=98CHECK=E2=80=99
   33 |  if (CHECK(!skel, "open and load skel", "failed"))
      |      ^~~~~
make: *** [Makefile:396: /home/jbrouer/git/kernel/bpf-next/tools/testing/se=
lftests/bpf/check_mtu.test.o] Error 1

