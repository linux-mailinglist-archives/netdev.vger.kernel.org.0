Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A803A0BA0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 06:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhFIEo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 00:44:57 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:34719 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhFIEo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 00:44:56 -0400
Received: by mail-yb1-f177.google.com with SMTP id i6so18975225ybm.1;
        Tue, 08 Jun 2021 21:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1It3ah1+98p8ZGjPRnK/5mUdjsC9zsL06VzWcGHzOU4=;
        b=mics4lm8falO3q/2aJPi+I3lD6dZwBAiXRJGTm6B1GmODHkVcQwFCA/6VZndLKBw5Q
         xjDrltZXY6yGkp8kJhHcXXAKV8okoXdVDemf8MSV4deueYS4UP7uj0rUGgJz0AZhf//1
         G/TgEd+0n1X0bd1qPzSZsAfHgD1fPP+UiUx+UKqWWeF0suCkqMsTeT4ZUtUQrVbJcPBf
         pBhvKnaGszXV8UJbSzUGBQahSrZEMIyTIzaPeaAxXSnNFC8rEw/fQPL3CxapVIPc6FZ6
         wDk7BJ1jrEQ32/q9QVAkzwGrx3ve68Z0sqdznC96C7l4XUNNgzJrYej1GEKd+k2LYIDj
         Q7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1It3ah1+98p8ZGjPRnK/5mUdjsC9zsL06VzWcGHzOU4=;
        b=j33HxRRgSZBacFOLHRDMWii2WjnETsME5yr+DG6zJS4tP+GP1tHp88md4RLtAVSFRI
         PPVUeYpPFLD7PqiFQ9Q728hq9B78NFEQu9JNheSLHZDCSMO3u4ICWYjpQHkg8hh1GYBh
         PsHvfXwqncAvF3JyxN0PbYjqx7Fy93MKJeXfl3QKpiO227fV5x5pKjKDmUIMCQFanlG0
         n8XzJuKnJp5ISb6Pp1C1/Ac53NHYZTIzTfmnFyZ+NIZT+r6zm9G7xr+MV9EwIUpVAc7+
         PlK2FLHCUSHoKb9hg5SAb0Lz9784fxIy8GHRaIfKGB7BXROEg7FV9SfBWukABS6xhGkm
         wbqQ==
X-Gm-Message-State: AOAM531VeDfKUltwMQ82Mlq3MMzy4lV9F73OEq+DmMthn2HBPlAtarQP
        PC83XtQUVTDhdf+2nlmHeApWFMJr75NsuOPaCyw=
X-Google-Smtp-Source: ABdhPJxs687O3Nb8b09iV1obkGTop6vXrj1niFLgYKEatrY8i40OwgIZpIjMHVpRDRfn4QY0Do5FpEwhnFQX2quQLIc=
X-Received: by 2002:a25:9942:: with SMTP id n2mr36841367ybo.230.1623213709823;
 Tue, 08 Jun 2021 21:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-7-andrii@kernel.org> <20210607231146.1077-1-tstellar@redhat.com>
 <CAEf4Bzad7OQj9JS7GVmBjAXyxKcc-nd77gxPQfFB8_hy_Xo+_g@mail.gmail.com>
 <b1bdf1df-e3a8-1ce8-fc33-4ab40b39fb06@redhat.com> <84b3cb2c-2dff-4cd8-724c-a1b56316816b@redhat.com>
 <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com> <b322da84-95f3-2800-f2c8-556e9855d517@redhat.com>
In-Reply-To: <b322da84-95f3-2800-f2c8-556e9855d517@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 21:41:38 -0700
Message-ID: <CAEf4BzYeMu5qRHZU2Zh4sBTU4S5sA+8Q6UMGZ4B0KVsYZ3v5-Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/11] libbpf: add BPF static linker APIs
To:     Tom Stellard <tstellar@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 8:44 PM Tom Stellard <tstellar@redhat.com> wrote:
>
> On 6/7/21 9:08 PM, Andrii Nakryiko wrote:
> > On Mon, Jun 7, 2021 at 7:41 PM Tom Stellard <tstellar@redhat.com> wrote=
:
> >>
> >> On 6/7/21 5:25 PM, Andrii Nakryiko wrote:
> >>> On Mon, Jun 7, 2021 at 4:12 PM Tom Stellard <tstellar@redhat.com> wro=
te:
> >>>>
> >>>>
> >>>> Hi,
> >>>>
> >>>>> +                               } else {
> >>>>> +                                       pr_warn("relocation against=
 STT_SECTION in non-exec section is not supported!\n");
> >>>>> +                                       return -EINVAL;
> >>>>> +                               }
> >>>>
> >>>> Kernel build of commit 324c92e5e0ee are failing for me with this err=
or
> >>>> message:
> >>>>
> >>>> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-=
0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen =
object /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-=
0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bi=
nd_perm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/li=
nux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selft=
ests/bpf/bind_perm.o
> >>>> libbpf: relocation against STT_SECTION in non-exec section is not su=
pported!
> >>>>
> >>>> What information can I provide to help debug this failure?
> >>>
> >>> Can you please send that bind_perm.o file? Also what's your `clang
> >>> --version` output?
> >>>
> >>
> >> clang version 12.0.0 (Fedora 12.0.0-2.fc35)
> >>
> >>>> I suspect this might be due to Clang commit 6a2ea84600ba ("BPF: Add
> >>>> more relocation kinds"), but I get a different error on 324c92e5e0ee=
.
> >>>> So meanwhile you might try applying 9f0c317f6aa1 ("libbpf: Add suppo=
rt
> >>>> for new llvm bpf relocations") from bpf-next/master and check if tha=
t
> >>>> helps. But please do share bind_perm.o, just to double-check what's
> >>>> going on.
> >>>>
> >>
> >> Here is bind_perm.o: https://fedorapeople.org/~tstellar/bind_perm.o
> >>
> >
> > So somehow you end up with .eh_frame section in BPF object file, which
> > shouldn't ever happen. So there must be something that you are doing
> > differently (compiler flags or something else) that makes Clang
> > produce .eh_frame. So we need to figure out why .eh_frame gets
> > generated. Not sure how, but maybe you have some ideas of what might
> > be different about your build.
> >
>
> Thanks for the pointer.  The problem was that in the Fedora kernel builds=
,
> we enable -funwind-tables by default on all architectures, which is why t=
he
> .eh_frame section was there.  I fixed our clang builds, but I'm now getti=
ng
> a new error when I run: CC=3Dclang make -C tools/testing/selftests/bpf  V=
=3D1
>
>
> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4=
.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/tools/s=
bin/bpftool gen skeleton /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5=
e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testin=
g/selftests/bpf/bpf_cubic.linked3.o name bpf_cubic > /builddir/build/BUILD/=
kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee=
.35.fc35.x86_64/tools/testing/selftests/bpf/bpf_cubic.skel.h
> libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -=
2
>
> Here is the bpf_cubic.lined3.o object file: https://fedorapeople.org/~tst=
ellar/bpf_cubic.linked3.o
>

See README.rst in selftests/bpf:

Kernel function call test and Clang version
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Some selftests (e.g. kfunc_call and bpf_tcp_ca) require a LLVM support
to generate extern function in BTF.  It was introduced in `Clang 13`__.

Without it, the error from compiling bpf selftests looks like:

.. code-block:: console

  libbpf: failed to find BTF for extern 'tcp_slow_start' [25] section: -2

__ https://reviews.llvm.org/D93563


> -Tom
>
>
>
> >> Thanks,
> >> Tom
> >>
> >>>>
> >>>>>
> >>>>> Thanks,
> >>>>> Tom
> >>>>>
> >>>>
> >>>
> >>
> >
>
