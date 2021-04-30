Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266B3370166
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhD3Tms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3Tmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:42:47 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F3EC06174A;
        Fri, 30 Apr 2021 12:41:58 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id b131so9078448ybg.5;
        Fri, 30 Apr 2021 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wSELs6NBgvMIddhFoNrSxwcWgSk/FcA26NAMH1K7Hx4=;
        b=EB6JvCzUN2/PKBHP9LZUIx2KF5A4+2k9wH1IjMcg3+TH8Zz5PTTD3Ifp5TmiORfNch
         r7wPB2mRZHwfcPiqDlzDDf9IyI0YVY+7116DLsmA9vBdIhnoMhzT0lnACBlWKmruhhpC
         BGu//znfBSO8J/MHZz+n2p6oeRXwp//ZjyTDh543jT6iXxjhWxaQwofme/sZvDENxSCC
         w5j7Y6ThehBrSuVN/FkUTOuaBKsF7/5dzdBYD/0d7ULjd2d/3ymy2xe6UcXt6L8aibBH
         hIKAABOzsCURWH0/I3UjLYe/qG5GW+khivcRwQbW59aOZE0VIr1kHtvSXz5k8qrfR0IA
         gLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wSELs6NBgvMIddhFoNrSxwcWgSk/FcA26NAMH1K7Hx4=;
        b=jY4bffBm5RwZW5QAWAB/oC37mZrt99mSDkinVNcSIxJLHhXlVOf+RJ+iTALKWOCfnR
         V/lLcEjReDa4vs/Rdl8cv8AjFE5mOBlKmSVFXWmMpAU9uLwO+WX0HJuiYvyfkUgFYMFm
         QA1g999x0a+XvKAGMhmdvJHYuK1Dk+HWJj531RQU+R/PVsKAzorH0DGTOEov7VLHeX4U
         BaRY1PDa7j5NH9wwRLRLkG0vf/vebdeMwZ7M8Q/9QNOs0VDSR1omQk+Bt4XDMgT9tIVk
         OFy4i0RgFpBksiVL1tS7+GmjpAmlpa3Gq+pYrItxL8Xz1l+8hgv7coMIykxj1I/YCZR2
         hG/w==
X-Gm-Message-State: AOAM530ZB56shz5+qGBa6q4fIwwyv2uPheUHzL9AA7jU4VoqfXi950Qp
        LSpW/pkLQ10Q4yUrUiKBpBczP1lekFXWEsOqFxU=
X-Google-Smtp-Source: ABdhPJzfR0TtXO1ds2g8fSb2y6SlvFoFeumdCmFDdmyZgJ/S1jirzJFnZzREOTRtv54lBb7cmkMy9Ui0De/Or9hBDko=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr9313109ybu.510.1619811718095;
 Fri, 30 Apr 2021 12:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210428162553.719588-1-memxor@gmail.com> <20210428162553.719588-4-memxor@gmail.com>
In-Reply-To: <20210428162553.719588-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Apr 2021 12:41:47 -0700
Message-ID: <CAEf4BzYp1uN4E_=0N7DpwkEQOxntP0riz__yUzz3xu=k4yJ4sw@mail.gmail.com>
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

On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds some basic tests for the low level bpf_tc_* API.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 467 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
>  2 files changed, 479 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/test=
ing/selftests/bpf/prog_tests/tc_bpf.c
> new file mode 100644
> index 000000000000..40441f4e23e2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> @@ -0,0 +1,467 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <linux/pkt_cls.h>
> +
> +#include "test_tc_bpf.skel.h"
> +
> +#define LO_IFINDEX 1
> +
> +static int test_tc_internal(const struct bpf_tc_hook *hook, int fd)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 1,
> +                           .prog_fd =3D fd);

we have 100 characters, if needed, use it to keep it on the single line

> +       struct bpf_prog_info info =3D {};
> +       int ret;
> +
> +       ret =3D bpf_obj_get_info_by_fd(fd, &info, &(__u32){sizeof(info)})=
;

as in previous patch, don't do this

> +       if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
> +               return ret;
> +
> +       ret =3D bpf_tc_attach(hook, &opts, 0);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach"))
> +               return ret;
> +
> +       if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
> +           !ASSERT_EQ(opts.priority, 1, "priority set") ||
> +           !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
> +               goto end;
> +
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .prog_fd =3D fd);

this is not C89, please move variable declarations to the top

> +       ret =3D bpf_tc_query(hook, &info_opts);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, .prog_id =3D info.id=
);

and here

> +       ret =3D bpf_tc_query(hook, &info_opts2);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
> +           !ASSERT_EQ(opts.priority, 1, "priority set") ||
> +           !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
> +               goto end;
> +
> +       opts.prog_id =3D 0;
> +       ret =3D bpf_tc_attach(hook, &opts, BPF_TC_F_REPLACE);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach replace mode"))
> +               return ret;

goto end?

> +
> +end:
> +       opts.prog_fd =3D opts.prog_id =3D 0;
> +       ret =3D bpf_tc_detach(hook, &opts);
> +       ASSERT_OK(ret, "bpf_tc_detach");
> +       return ret;
> +}
> +

[...]

> +
> +       /* attach */
> +       ret =3D bpf_tc_attach(NULL, &attach_opts, 0);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook =3D NULL=
"))
> +               return -EINVAL;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 42);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid flags"))
> +               return -EINVAL;
> +       attach_opts.prog_fd =3D 0;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_fd unset=
"))
> +               return -EINVAL;
> +       attach_opts.prog_fd =3D fd;
> +       attach_opts.prog_id =3D 42;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id set")=
)
> +               return -EINVAL;
> +       attach_opts.prog_id =3D 0;
> +       attach_opts.handle =3D 0;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach valid handle unset"))
> +               return -EINVAL;
> +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");

this code is quite hard to follow, maybe sprinkle empty lines between
logical groups of statements (i.e., prepare inputs + call bpf_tc_xxx +
assert is one group that goes together)

> +       attach_opts.prog_fd =3D fd;
> +       attach_opts.handle =3D 1;
> +       attach_opts.priority =3D 0;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach valid priority unset"))
> +               return -EINVAL;
> +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
> +       attach_opts.prog_fd =3D fd;
> +       attach_opts.priority =3D UINT16_MAX + 1;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid priority > UI=
NT16_MAX"))
> +               return -EINVAL;
> +       attach_opts.priority =3D 0;
> +       attach_opts.handle =3D attach_opts.priority =3D 0;
> +       ret =3D bpf_tc_attach(hook, &attach_opts, 0);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach valid both handle and priority=
 unset"))
> +               return -EINVAL;
> +       attach_opts.prog_fd =3D attach_opts.prog_id =3D 0;
> +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
> +       ret =3D bpf_tc_attach(hook, NULL, 0);
> +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts =3D NULL=
"))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static int test_tc_query(const struct bpf_tc_hook *hook, int fd)
> +{
> +       struct test_tc_bpf *skel =3D NULL;
> +       int new_fd, ret, i =3D 0;
> +
> +       skel =3D test_tc_bpf__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
> +               return -EINVAL;
> +
> +       new_fd =3D bpf_program__fd(skel->progs.cls);
> +
> +       /* make sure no other filters are attached */
> +       ret =3D bpf_tc_query(hook, NULL);
> +       if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query =3D=3D -ENOENT"))
> +               goto end_destroy;
> +
> +       for (i =3D 0; i < 5; i++) {
> +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd =3D fd);

empty line after variable declaration

> +               ret =3D bpf_tc_attach(hook, &opts, 0);
> +               if (!ASSERT_OK(ret, "bpf_tc_attach"))
> +                       goto end;
> +       }
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 1,
> +                           .prog_fd =3D new_fd);
> +       ret =3D bpf_tc_attach(hook, &opts, 0);
> +       if (!ASSERT_OK(ret, "bpf_tc_attach"))
> +               goto end;
> +       i++;
> +
> +       ASSERT_EQ(opts.handle, 1, "handle match");
> +       ASSERT_EQ(opts.priority, 1, "priority match");
> +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> +
> +       opts.prog_fd =3D 0;
> +       /* search with handle, priority, prog_id */
> +       ret =3D bpf_tc_query(hook, &opts);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       ASSERT_EQ(opts.handle, 1, "handle match");
> +       ASSERT_EQ(opts.priority, 1, "priority match");
> +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> +
> +       opts.priority =3D opts.prog_fd =3D 0;
> +       /* search with handle, prog_id */
> +       ret =3D bpf_tc_query(hook, &opts);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       ASSERT_EQ(opts.handle, 1, "handle match");
> +       ASSERT_EQ(opts.priority, 1, "priority match");
> +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> +
> +       opts.handle =3D opts.prog_fd =3D 0;
> +       /* search with priority, prog_id */
> +       ret =3D bpf_tc_query(hook, &opts);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       ASSERT_EQ(opts.handle, 1, "handle match");
> +       ASSERT_EQ(opts.priority, 1, "priority match");
> +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> +
> +       opts.handle =3D opts.priority =3D opts.prog_fd =3D 0;
> +       /* search with prog_id */
> +       ret =3D bpf_tc_query(hook, &opts);
> +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> +               goto end;
> +
> +       ASSERT_EQ(opts.handle, 1, "handle match");
> +       ASSERT_EQ(opts.priority, 1, "priority match");
> +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> +
> +       while (i !=3D 1) {
> +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, .prog_fd =3D f=
d);

empty line here

> +               ret =3D bpf_tc_query(hook, &del_opts);
> +               if (!ASSERT_OK(ret, "bpf_tc_query"))
> +                       goto end;
> +               ASSERT_NEQ(del_opts.prog_id, opts.prog_id, "prog_id shoul=
d not be same");
> +               ASSERT_NEQ(del_opts.priority, 1, "priority should not be =
1");
> +               del_opts.prog_fd =3D del_opts.prog_id =3D 0;
> +               ret =3D bpf_tc_detach(hook, &del_opts);
> +               if (!ASSERT_OK(ret, "bpf_tc_detach"))
> +                       goto end;
> +               i--;
> +       }
> +
> +       opts.handle =3D opts.priority =3D opts.prog_id =3D 0;
> +       opts.prog_fd =3D fd;
> +       ret =3D bpf_tc_query(hook, &opts);
> +       ASSERT_EQ(ret, -ENOENT, "bpf_tc_query =3D=3D -ENOENT");
> +
> +end:
> +       while (i--) {
> +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, 0);

you get the idea by now

> +               ret =3D bpf_tc_query(hook, &del_opts);
> +               if (!ASSERT_OK(ret, "bpf_tc_query"))
> +                       break;
> +               del_opts.prog_id =3D 0;
> +               ret =3D bpf_tc_detach(hook, &del_opts);
> +               if (!ASSERT_OK(ret, "bpf_tc_detach"))
> +                       break;
> +       }
> +       ASSERT_EQ(bpf_tc_query(hook, NULL), -ENOENT, "bpf_tc_query =3D=3D=
 -ENOENT");
> +end_destroy:
> +       test_tc_bpf__destroy(skel);
> +       return ret;
> +}
> +

[...]
