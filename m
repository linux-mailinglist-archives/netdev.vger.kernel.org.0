Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DD45E3FC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357422AbhKZB1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbhKZBZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:25:34 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6C8C06175A;
        Thu, 25 Nov 2021 17:22:22 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v138so15950732ybb.8;
        Thu, 25 Nov 2021 17:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/AuK3UsdxLLun6xgCFMS/tOh8hgjjFh2UXvJjyqMQ+4=;
        b=dNQ9V7RFgOtI5LBHlHWvWSUZJBuOOikWTaMvde/ve4l1TW5imDIyIl8Sq1BOHYylzh
         ycMvrCkfceZNsVJEsZ4Fn6y5dTwcA+HNu7radLD+nW5LgDdht9VAltzGE5DoqTRuX/Jk
         Ql36+QOatU3MFfGtJ2E2+/yTPYnrBkx5mcxRo7ItPr1jHPfPLgK1KKqVJSs0o6ZroKyl
         GG7RwHaFlrSGpsUW2UU7ylzro66IfQAVWNXeJxR2+lyKuKLSUwLU25fJzpbfAAisPDAs
         zauHc9xdhotzwyNDSH77FcC7K6b699Dc0V5QHWduq2SMvzSnn55E+AibuyW+F5ZzBgHg
         klzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/AuK3UsdxLLun6xgCFMS/tOh8hgjjFh2UXvJjyqMQ+4=;
        b=3BxN4PD1HaI4fKe45LwGHDjvVoduU284VXjKJLwkYUjp5lFt5XRV7MUtmtCinyeJTG
         0seCJVtvt5vYGnrzWu2LfoCPeIYxBNRjWbl9+Co7SY2oUlZw8Oe6lhetwp6pK3CCOphV
         8FTMcY/SX9nkodqlM4tyLL1sblOKQrAhlHQmdAHYgdKyVkquaAx9/NNRpo8Uk3EpLV/8
         YbE+mIu+oXq8EhKCXu1IhDdUpaJwelUoQCBqCnHwEwSfDi1B6Exdq0/BWbnttmd3gKt4
         qipkmfAK+N2cIeggTWLdV0Zif/fpZbfBFMPI2GHvGY4XZtatIZY85ZID8sxQDMcvyrAw
         8nNw==
X-Gm-Message-State: AOAM530RYZPYeNVsevy3D0U7eLEpM/5ZuAwDZtc9msQ7yijLL8s3JDXA
        PduSYwFGmYJO3tuXfpOFoDIquDrkPypyX6AJzaU=
X-Google-Smtp-Source: ABdhPJyK99pr86Wn5ega0gJnlezD61CL0sntzSsHRpGMfE6i6M3xUD9FpfXEvmBq1ZiYa6r7dqCPI5oWfmM35ZlJpP0=
X-Received: by 2002:a05:6902:68d:: with SMTP id i13mr11443772ybt.2.1637889741663;
 Thu, 25 Nov 2021 17:22:21 -0800 (PST)
MIME-Version: 1.0
References: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn> <0ca847a8-78a5-6ad9-ab4b-62dcda33df7c@iogearbox.net>
In-Reply-To: <0ca847a8-78a5-6ad9-ab4b-62dcda33df7c@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Nov 2021 17:22:10 -0800
Message-ID: <CAEf4BzYiEeSW=9dCnPdNhA4ORSFUL6y7ZVFOiHR5k9AcccFv+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf, mips: Fix build errors about __NR_bpf undeclared
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 3:05 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> [ +Johan ]
>
> On 11/25/21 2:36 AM, Tiezhu Yang wrote:
> > Add the __NR_bpf definitions to fix the following build errors for mips=
.
> >
> >   $ cd tools/bpf/bpftool
> >   $ make
> >   [...]
> >   bpf.c:54:4: error: #error __NR_bpf not defined. libbpf does not suppo=
rt your arch.
> >    #  error __NR_bpf not defined. libbpf does not support your arch.
> >       ^~~~~
> >   bpf.c: In function =E2=80=98sys_bpf=E2=80=99:
> >   bpf.c:66:17: error: =E2=80=98__NR_bpf=E2=80=99 undeclared (first use =
in this function); did you mean =E2=80=98__NR_brk=E2=80=99?
> >     return syscall(__NR_bpf, cmd, attr, size);
> >                    ^~~~~~~~
> >                    __NR_brk
> >   [...]
> >   In file included from gen_loader.c:15:0:
> >   skel_internal.h: In function =E2=80=98skel_sys_bpf=E2=80=99:
> >   skel_internal.h:53:17: error: =E2=80=98__NR_bpf=E2=80=99 undeclared (=
first use in this function); did you mean =E2=80=98__NR_brk=E2=80=99?
> >     return syscall(__NR_bpf, cmd, attr, size);
> >                    ^~~~~~~~
> >                    __NR_brk
> >
> > We can see the following generated definitions:
> >
> >   $ grep -r "#define __NR_bpf" arch/mips
> >   arch/mips/include/generated/uapi/asm/unistd_o32.h:#define __NR_bpf (_=
_NR_Linux + 355)
> >   arch/mips/include/generated/uapi/asm/unistd_n64.h:#define __NR_bpf (_=
_NR_Linux + 315)
> >   arch/mips/include/generated/uapi/asm/unistd_n32.h:#define __NR_bpf (_=
_NR_Linux + 319)
> >
> > The __NR_Linux is defined in arch/mips/include/uapi/asm/unistd.h:
> >
> >   $ grep -r "#define __NR_Linux" arch/mips
> >   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux      4000
> >   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux      5000
> >   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux      6000
> >
> > That is to say, __NR_bpf is
> > 4000 + 355 =3D 4355 for mips o32,
> > 6000 + 319 =3D 6319 for mips n32,
> > 5000 + 315 =3D 5315 for mips n64.
> >
> > So use the GCC pre-defined macro _ABIO32, _ABIN32 and _ABI64 [1] to def=
ine
> > the corresponding __NR_bpf.
> >
> > This patch is similar with commit bad1926dd2f6 ("bpf, s390: fix build f=
or
> > libbpf and selftest suite").
> >
> > [1] https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dblob;f=3Dgcc/config/mips/m=
ips.h#l549
> >
> > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > ---
> >
> > v2: use a final number without __NR_Linux to define __NR_bpf
> >      suggested by Andrii Nakryiko, thank you.
> >
> >   tools/build/feature/test-bpf.c |  6 ++++++
> >   tools/lib/bpf/bpf.c            |  6 ++++++
> >   tools/lib/bpf/skel_internal.h  | 10 ++++++++++
> >   3 files changed, 22 insertions(+)
> >
> > diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-=
bpf.c
> > index 82070ea..727d22e 100644
> > --- a/tools/build/feature/test-bpf.c
> > +++ b/tools/build/feature/test-bpf.c
> > @@ -14,6 +14,12 @@
> >   #  define __NR_bpf 349
> >   # elif defined(__s390__)
> >   #  define __NR_bpf 351
> > +# elif defined(__mips__) && defined(_ABIO32)
> > +#  define __NR_bpf 4355
> > +# elif defined(__mips__) && defined(_ABIN32)
> > +#  define __NR_bpf 6319
> > +# elif defined(__mips__) && defined(_ABI64)
> > +#  define __NR_bpf 5315
> >   # else
> >   #  error __NR_bpf not defined. libbpf does not support your arch.
> >   # endif
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 94560ba..17f9fe2 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -50,6 +50,12 @@
> >   #  define __NR_bpf 351
> >   # elif defined(__arc__)
> >   #  define __NR_bpf 280
> > +# elif defined(__mips__) && defined(_ABIO32)
> > +#  define __NR_bpf 4355
> > +# elif defined(__mips__) && defined(_ABIN32)
> > +#  define __NR_bpf 6319
> > +# elif defined(__mips__) && defined(_ABI64)
> > +#  define __NR_bpf 5315
> >   # else
> >   #  error __NR_bpf not defined. libbpf does not support your arch.
> >   # endif
> > diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_interna=
l.h
> > index 9cf6670..064da66 100644
> > --- a/tools/lib/bpf/skel_internal.h
> > +++ b/tools/lib/bpf/skel_internal.h
> > @@ -7,6 +7,16 @@
> >   #include <sys/syscall.h>
> >   #include <sys/mman.h>
> >
> > +#ifndef __NR_bpf
> > +# if defined(__mips__) && defined(_ABIO32)
> > +#  define __NR_bpf 4355
> > +# elif defined(__mips__) && defined(_ABIN32)
> > +#  define __NR_bpf 6319
> > +# elif defined(__mips__) && defined(_ABI64)
> > +#  define __NR_bpf 5315
> > +# endif
> > +#endif
>
> Bit unfortunate that mips is the only arch where we run into this apparen=
tly? :/
> Given we also redefine a skel_sys_bpf(), maybe libbpf should just provide=
 something
> like a `LIBBPF_API int libbpf_sys_bpf(enum bpf_cmd cmd, [...])` so we rel=
y implicitly
> only on the libbpf-internal __NR_bpf instead of duplicating again?

Unfortunately the point of skel_internal.h is to not depend on libbpf
APIs. I think for now it should be fine to have this duplication (not
that those numbers are going to change ever) and we can improve this
later.

>
> >   /* This file is a base header for auto-generated *.lskel.h files.
> >    * Its contents will change and may become part of auto-generation in=
 the future.
> >    *
> >
>
