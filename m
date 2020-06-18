Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F561FFD4A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgFRVRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgFRVRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:17:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408AEC06174E;
        Thu, 18 Jun 2020 14:17:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s88so3293559pjb.5;
        Thu, 18 Jun 2020 14:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pHNj4UcVkosY1weDmb/4q/zy1XVK8V4Pkn034oQkWkI=;
        b=DHwac/agWYSz1ByqSwyw8AlaXCpipGczUNXLUPbl0gbyRAfTcfqCdctFpc6TRrW17E
         HxFINyAhdsnniXc45f4ZIxxx+UEFVqjB7yhForM0CHzKWhYxO3RLOG2EXRDjd+Uu4C98
         VG8jg+94RbyUHlZd6h0m4kRP/gUfyFJOgkvsewDFjVHtSJzTP4zDgr7CgAsfIvMstdGP
         LpL9C84a34uG6EpDdikgmnKtiLlOUIZEM78W1kXLsuJKmyx0hb0OO+pVlN+nfiA1Pvei
         1sIiMbPiMw4xiOLzZv1z/eckDPu0nXkyop++gnjhC1N+P1uYPcb55rZabjyXdGg607Ps
         ShIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pHNj4UcVkosY1weDmb/4q/zy1XVK8V4Pkn034oQkWkI=;
        b=hIBbYhRLlafTrrO3jO0G3ndsFtYzvW11+rN32tHxY5cyes7AMWpwQ/acGMRGTtr6Nu
         Orc1qZugQuiudlf2VKf0uT8UuAZJH+ogQAs1mzUNbznRHSQrnpahgDs8+z2s778Svkx6
         6+wbRt9LFAJw/cEdBxJdPLTgSKfAyAAtout1eVtT8hqXc5ytNnPUUIRe/5Uw28L1aMjt
         xI8mSEHUkbz8JUV1p/GhstCmSNPSoX3GfvDCa643sNKh6BC9pjdZ47Z7tmmacDxClLpb
         /GAIdeVVr+08v02KWmRx90Pvlpzz/5Uhw5FCdNnBtc8T/ElUkiHWLbwRAVn8SDxqrgJx
         QY3w==
X-Gm-Message-State: AOAM533fhoFRPprUtrAHFPv1dwmM3A3SbZm/I0h5kdaotrs5B3zog1r4
        wlZ/0FwH94PDc5Ry6GyYKN0=
X-Google-Smtp-Source: ABdhPJzKbHdZDboo3vTT6Cbie9iC7kE5OGjuxUU003iOQM0Nm5gQUdIb+yFYDk6QX8KZrzQgWApETw==
X-Received: by 2002:a17:90a:8083:: with SMTP id c3mr277783pjn.83.1592515054784;
        Thu, 18 Jun 2020 14:17:34 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f14sm3306510pjq.36.2020.06.18.14.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 14:17:33 -0700 (PDT)
Date:   Thu, 18 Jun 2020 14:17:25 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <5eebd9e5a9509_6d292ad5e7a285b8e9@john-XPS-13-9370.notmuch>
In-Reply-To: <5eebd1486e46b_6d292ad5e7a285b817@john-XPS-13-9370.notmuch>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-3-jolsa@kernel.org>
 <5eebd1486e46b_6d292ad5e7a285b817@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Jiri Olsa wrote:
> > The btfid tool will be used during the vmlinux linking,
> > so it's necessary it's ready for it.
> > =

> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Makefile           | 22 ++++++++++++++++++----
> >  tools/Makefile     |  3 +++
> >  tools/bpf/Makefile |  5 ++++-
> >  3 files changed, 25 insertions(+), 5 deletions(-)
> =

> This breaks the build for me. I fixed it with this but then I get warni=
ngs,

Also maybe fix below is not good because now I get a segfault in btfid.

> =

> diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
> index 7cdf39bfb150..3697e8ae9efa 100644
> --- a/tools/bpf/btfid/btfid.c
> +++ b/tools/bpf/btfid/btfid.c
> @@ -48,7 +48,7 @@
>  #include <errno.h>
>  #include <linux/rbtree.h>
>  #include <linux/zalloc.h>
> -#include <btf.h>
> +#include <linux/btf.h>
>  #include <libbpf.h>
>  #include <parse-options.h>
> =

> Here is the error. Is it something about my setup? bpftool/btf.c uses
> <btf.h>. Because this in top-level Makefile we probably don't want to
> push extra setup onto folks.
> =

> In file included from btfid.c:51:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h: In function =E2=80=98btf_i=
s_var=E2=80=99:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: error: =E2=80=98BTF=
_KIND_VAR=E2=80=99 undeclared (first use in this function); did you mean =
=E2=80=98BTF_KIND_PTR=E2=80=99?
>   return btf_kind(t) =3D=3D BTF_KIND_VAR;
>                         ^~~~~~~~~~~~
>                         BTF_KIND_PTR
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: note: each undeclar=
ed identifier is reported only once for each function it appears in
> /home/john/git/bpf-next/tools/lib/bpf/btf.h: In function =E2=80=98btf_i=
s_datasec=E2=80=99:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:259:24: error: =E2=80=98BTF=
_KIND_DATASEC=E2=80=99 undeclared (first use in this function); did you m=
ean =E2=80=98BTF_KIND_PTR=E2=80=99?
>   return btf_kind(t) =3D=3D BTF_KIND_DATASEC;
>                         ^~~~~~~~~~~~~~~~
>                         BTF_KIND_PTR
> mv: cannot stat '/home/john/git/bpf-next/tools/bpf/btfid/.btfid.o.tmp':=
 No such file or directory
> make[3]: *** [/home/john/git/bpf-next/tools/build/Makefile.build:97: /h=
ome/john/git/bpf-next/tools/bpf/btfid/btfid.o] Error 1
> make[2]: *** [Makefile:59: /home/john/git/bpf-next/tools/bpf/btfid/btfi=
d-in.o] Error 2
> make[1]: *** [Makefile:71: bpf/btfid] Error 2
> make: *** [Makefile:1894: tools/bpf/btfid] Error 2


