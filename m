Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD49136727D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbhDUSZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhDUSZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:25:04 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EF8C06174A;
        Wed, 21 Apr 2021 11:24:29 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 65so48304878ybc.4;
        Wed, 21 Apr 2021 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AzMlWrvxOHBcG9VE8VGKjvy0XKDo5TiPyzXMmG46dJA=;
        b=OeHHclwDAg72g49ZJ2kOzh5+ZCUpWkKtErRexESGiBqudme91F6vO8UZJu4wDmgZJS
         n+2kJSj0bqZEL8/uH59nTcoNv6UNVVINh9ZOM6wLA2i+8YbvGmStb7cWKP3bLDzPuXTm
         MdIcCOlp2ipBOa7sa5S+X+sQwmFvVd3x/ykJR8eA2irMWESvCt8OWJd9GGAoxEXsF6KL
         ze2+qA4rLZISSYYzrvnQfzr+SBnRHIsGG35cHnR7umLQ3beZn6G20EVhJA80/AWFt7V9
         EookeIss7MDofy3Nb/2t2vwmsGWWm2SnFh2/W0xJKclII+a5AGxPcwt8BJOzp/3Mei5i
         dRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AzMlWrvxOHBcG9VE8VGKjvy0XKDo5TiPyzXMmG46dJA=;
        b=bhacq71xBm3RqEJrJpWjr63aseZY8gCdHAv8JtexFhxXnBk0muOLnHaMXnCry3wCae
         VFHhPPLZ7hhNyd3z1t5HDAODNk7115Dan4GhRdgqEvTmDLLo91j92elbDL+jsvzfGj8Z
         mYzrn441caPlCs1unTk0WrmnITPqJGZPNkJ+U6X9pnCdHLWG7jC879aGsBPM8SuabWQ0
         WBUvvZqw29SAtpcmbNHIOyVaSyvcoPc7pO/rUmTDJzpDUlZW8NKJkIMC5gwVBHIMf0AY
         Qk7My8kH5MT+Ky98h/f3uzQypw0apzfUUrHpXbNzIvUWEnOB/jI91swdRgNwkdpfPU7Y
         WCJg==
X-Gm-Message-State: AOAM533xRyEJdyISZZ13FS7zdPBqWWbdfhtWbwls4n7rXX7FrKB8/Xbj
        BwqqwlD64uB3HGbJgdW7F/vYvRDDCCbg4QFpEQg=
X-Google-Smtp-Source: ABdhPJwwNX4bb2UwUJwYmjVKMr5Whi2nJctvjqpFahuhCDUKSqVikCW0GMXq0h4/xUuEowBHNCYsEKjXxajNpBNvjhw=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr25331904ybg.459.1619029468784;
 Wed, 21 Apr 2021 11:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210420193740.124285-1-memxor@gmail.com> <20210420193740.124285-4-memxor@gmail.com>
In-Reply-To: <20210420193740.124285-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 11:24:18 -0700
Message-ID: <CAEf4BzbQjWkVM-dy+ebSKzgO89_W9vMGz_ZYicXCfp5XD_d_1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
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
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds some basic tests for the low level bpf_tc_* API.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
>  .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
>  2 files changed, 181 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c

we normally don't call prog_test's files with "test_" prefix, it can
be just tc_bpf.c (or just tc.c)

>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

we also don't typically call BPF source code files with _kern suffix,
just test_tc_bpf.c would be more in line with most common case

>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools=
/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> new file mode 100644
> index 000000000000..563a3944553c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> @@ -0,0 +1,169 @@
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
> +static int test_tc_internal(int fd, __u32 parent_id)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 10,
> +                           .class_id =3D TC_H_MAKE(1UL << 16, 1));
> +       struct bpf_tc_attach_id id =3D {};
> +       struct bpf_tc_info info =3D {};
> +       int ret;
> +
> +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> +               return ret;
> +
> +       ret =3D bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> +               goto end;
> +
> +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
> +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"=
) ||
> +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
> +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
> +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
> +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
> +                      "class_id incorrect") ||
> +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
> +               goto end;
> +
> +       opts.replace =3D true;
> +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach in replace mode"))
> +               return ret;
> +
> +       /* Demonstrate changing attributes */
> +       opts.class_id =3D TC_H_MAKE(1UL << 16, 2);
> +
> +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc attach in replace mode"))
> +               goto end;
> +
> +       ret =3D bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> +               goto end;
> +
> +       if (!ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 2),
> +                      "class_id incorrect after replace"))
> +               goto end;
> +       if (!ASSERT_EQ(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT, 1,
> +                      "direct action mode not set"))
> +               goto end;
> +
> +end:
> +       ret =3D bpf_tc_detach(LO_IFINDEX, parent_id, &id);
> +       ASSERT_EQ(ret, 0, "detach failed");
> +       return ret;
> +}
> +
> +int test_tc_info(int fd)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 10,
> +                           .class_id =3D TC_H_MAKE(1UL << 16, 1));
> +       struct bpf_tc_attach_id id =3D {}, old;
> +       struct bpf_tc_info info =3D {};
> +       int ret;
> +
> +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opt=
s, &id);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> +               return ret;
> +       old =3D id;
> +
> +       ret =3D bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &=
info);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> +               goto end_old;
> +
> +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
> +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"=
) ||
> +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
> +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
> +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
> +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
> +                      "class_id incorrect") ||
> +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
> +               goto end_old;
> +
> +       /* choose a priority */
> +       opts.priority =3D 0;
> +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opt=
s, &id);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> +               goto end_old;
> +
> +       ret =3D bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &=
info);
> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> +               goto end;
> +
> +       if (!ASSERT_NEQ(id.priority, old.priority, "filter priority misma=
tch"))
> +               goto end;
> +       if (!ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"=
))
> +               goto end;
> +
> +end:
> +       ret =3D bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id);
> +       ASSERT_EQ(ret, 0, "detach failed");
> +end_old:
> +       ret =3D bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &old);
> +       ASSERT_EQ(ret, 0, "detach failed");
> +       return ret;
> +}
> +
> +void test_test_tc_bpf(void)

test_test_ tautology, drop one test?

> +{
> +       const char *file =3D "./test_tc_bpf_kern.o";

please use BPF skeleton instead, see lots of other selftests doing
that already. You won't even need find_program_by_{name,title}, among
other things.

> +       struct bpf_program *clsp;
> +       struct bpf_object *obj;
> +       int cls_fd, ret;
> +
> +       obj =3D bpf_object__open(file);
> +       if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
> +               return;
> +
> +       clsp =3D bpf_object__find_program_by_title(obj, "classifier");
> +       if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
> +               goto end;
> +
> +       ret =3D bpf_object__load(obj);
> +       if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
> +               goto end;
> +
> +       cls_fd =3D bpf_program__fd(clsp);
> +
> +       system("tc qdisc del dev lo clsact");

can this fail? also why is this necessary? it's still not possible to
do anything with only libbpf APIs?

> +
> +       ret =3D test_tc_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_internal INGRESS"))
> +               goto end;
> +
> +       if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +                      "clsact qdisc delete failed"))
> +               goto end;
> +
> +       ret =3D test_tc_info(cls_fd);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_info"))
> +               goto end;
> +
> +       if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +                      "clsact qdisc delete failed"))
> +               goto end;
> +
> +       ret =3D test_tc_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_internal EGRESS"))
> +               goto end;
> +
> +       ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> +                 "clsact qdisc delete failed");
> +
> +end:
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools=
/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> new file mode 100644
> index 000000000000..18a3a7ed924a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +/* Dummy prog to test TC-BPF API */
> +
> +SEC("classifier")
> +int cls(struct __sk_buff *skb)
> +{
> +       return 0;
> +}
> --
> 2.30.2
>
