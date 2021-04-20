Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3AC36518E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhDTEgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhDTEft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 00:35:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D12C06174A;
        Mon, 19 Apr 2021 21:35:17 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 65so41481865ybc.4;
        Mon, 19 Apr 2021 21:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0r16BooCpXI0OcS9w6cnAMsct+lg08FmW3QWyViKSQk=;
        b=X5+0tlIWiyhDTAUWiGXItZjWAL7xvDeJ4NG5fIxtZiL6jAu2OYANJ8lnv6x9kgtvgH
         kiAOZrlmG7r3tnQtGYwCRfPrdNI0r2R3ussQOzl9epN0A3A2xF8URAZS7lvjBhwLfujN
         HqON7bYoo5dM1WDLAM5YL3lUILVnJvODIFCBpISwgHGz6lpZJGrPxEkXPZ+tVkoTjvfg
         8GX7RksbKzN7M1kTQlYO1oCysmMRMBTXhlHvNkz7QTursDn9BM2FF1uFyUfn2TgSIdJo
         D7t8H2i+zBwWRjPhsmyIziYpVhSZyb2DQrmoY0mWI0VaoBLCbQx89hR3sxv3JtKevcUF
         zz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0r16BooCpXI0OcS9w6cnAMsct+lg08FmW3QWyViKSQk=;
        b=UFtmWhUTnuebFOYzMYUFUrA5qbs5sgnr+19kjXI7IZQyx5txENaeePA0F2wRJcI+yo
         Pq3bNK9SiGl5g8SqsCC9RzFo0W9cJumT/21kTZJWvPuIcwY4hHfNHLWHj928RMXYpFZ0
         HJUpK6RGLm+S6cHVG+BaWO/777tPwjyNz0O4J9KzXlMcTsqdyN88XqUZ6hMdyn0DxC2x
         jKfnDVU0qegqlQYhanXx8fY78WlUT/Wx1XIlgCQZuyppvnN1Lz8C+Hy5GrnXe0G1wZWN
         Tcn26bJNv71Zx/jONLsX8rLhj3ZMZFU1SB3Fg3EfDVmU0cSw+ZE1h7gloFdwVvVeLh0c
         Sbow==
X-Gm-Message-State: AOAM533HbIJMwZscjB/K7fAI0boauGPfIJbjuY7FBqde9AleRG0CaMLI
        6HQtxaYgFb9tFDgg4MhAtw3lVG2dcyH2L8C0fAo=
X-Google-Smtp-Source: ABdhPJz7KTZm5BSvzN+r3/f2jOquX75Lj6og9mD80aAtZpjcfUVlv9zrnKFb6f3P6NytANbFWmNrCfbttcJNO7QEmRU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr22571317ybo.230.1618893317102;
 Mon, 19 Apr 2021 21:35:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210419121811.117400-1-memxor@gmail.com> <20210419121811.117400-5-memxor@gmail.com>
In-Reply-To: <20210419121811.117400-5-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 19 Apr 2021 21:35:06 -0700
Message-ID: <CAEf4BzYs-YqD04rNfTELxVRH1tOai1HeWD4h0DNaJQtAZW5oHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: add selftests for TC-BPF API
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 5:18 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds some basic tests for the low level bpf_tc_cls_* API.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/test_tc_bpf.c    | 112 ++++++++++++++++++
>  .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
>  2 files changed, 124 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools=
/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> new file mode 100644
> index 000000000000..945f3a1a72f8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <linux/err.h>
> +#include <linux/limits.h>
> +#include <bpf/libbpf.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <test_progs.h>
> +#include <linux/if_ether.h>
> +
> +#define LO_IFINDEX 1
> +
> +static int test_tc_cls_internal(int fd, __u32 parent_id)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, .handle =3D 1, .priori=
ty =3D 10,
> +                           .class_id =3D TC_H_MAKE(1UL << 16, 1),
> +                           .chain_index =3D 5);
> +       struct bpf_tc_cls_attach_id id =3D {};
> +       struct bpf_tc_cls_info info =3D {};
> +       int ret;
> +
> +       ret =3D bpf_tc_cls_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> +       if (CHECK_FAIL(ret < 0))
> +               return ret;
> +
> +       ret =3D bpf_tc_cls_get_info(fd, LO_IFINDEX, parent_id, NULL, &inf=
o);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       ret =3D -1;
> +
> +       if (CHECK_FAIL(info.id.handle !=3D id.handle) ||
> +           CHECK_FAIL(info.id.chain_index !=3D id.chain_index) ||
> +           CHECK_FAIL(info.id.priority !=3D id.priority) ||
> +           CHECK_FAIL(info.id.handle !=3D 1) ||
> +           CHECK_FAIL(info.id.priority !=3D 10) ||
> +           CHECK_FAIL(info.class_id !=3D TC_H_MAKE(1UL << 16, 1)) ||
> +           CHECK_FAIL(info.id.chain_index !=3D 5))
> +               goto end;
> +
> +       ret =3D bpf_tc_cls_replace(fd, LO_IFINDEX, parent_id, &opts, &id)=
;
> +       if (CHECK_FAIL(ret < 0))
> +               return ret;
> +
> +       if (CHECK_FAIL(info.id.handle !=3D 1) ||
> +           CHECK_FAIL(info.id.priority !=3D 10) ||
> +           CHECK_FAIL(info.class_id !=3D TC_H_MAKE(1UL << 16, 1)))
> +               goto end;
> +
> +       /* Demonstrate changing attributes */
> +       opts.class_id =3D TC_H_MAKE(1UL << 16, 2);
> +
> +       ret =3D bpf_tc_cls_change(fd, LO_IFINDEX, parent_id, &opts, &info=
.id);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       ret =3D bpf_tc_cls_get_info(fd, LO_IFINDEX, parent_id, NULL, &inf=
o);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       if (CHECK_FAIL(info.class_id !=3D TC_H_MAKE(1UL << 16, 2)))
> +               goto end;
> +       if (CHECK_FAIL((info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT) !=3D 1)=
)
> +               goto end;
> +
> +end:
> +       ret =3D bpf_tc_cls_detach(LO_IFINDEX, parent_id, &id);
> +       CHECK_FAIL(ret < 0);
> +       return ret;
> +}
> +
> +void test_test_tc_bpf(void)
> +{
> +       const char *file =3D "./test_tc_bpf_kern.o";
> +       struct bpf_program *clsp;
> +       struct bpf_object *obj;
> +       int cls_fd, ret;
> +
> +       obj =3D bpf_object__open(file);
> +       if (CHECK_FAIL(IS_ERR_OR_NULL(obj)))
> +               return;
> +
> +       clsp =3D bpf_object__find_program_by_title(obj, "classifier");
> +       if (CHECK_FAIL(IS_ERR_OR_NULL(clsp)))
> +               goto end;
> +
> +       ret =3D bpf_object__load(obj);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       cls_fd =3D bpf_program__fd(clsp);
> +
> +       system("tc qdisc del dev lo clsact");
> +
> +       ret =3D test_tc_cls_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       if (CHECK_FAIL(system("tc qdisc del dev lo clsact")))
> +               goto end;
> +
> +       ret =3D test_tc_cls_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
> +       if (CHECK_FAIL(ret < 0))
> +               goto end;
> +
> +       CHECK_FAIL(system("tc qdisc del dev lo clsact"));

please don't use CHECK_FAIL. And prefer ASSERT_xxx over CHECK().

> +
> +end:
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools=
/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> new file mode 100644
> index 000000000000..3dd40e21af8e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +// Dummy prog to test TC-BPF API

no C++-style comments, please (except for SPDX header, of course)
> +
> +SEC("classifier")
> +int cls(struct __sk_buff *skb)
> +{
> +       return 0;
> +}
> --
> 2.30.2
>
