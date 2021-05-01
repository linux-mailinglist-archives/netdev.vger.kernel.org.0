Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187053705EB
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 08:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhEAGfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 02:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhEAGfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 02:35:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0769C06174A;
        Fri, 30 Apr 2021 23:34:41 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p2so144953pgh.4;
        Fri, 30 Apr 2021 23:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OFJbib0i55ODPDsGvy9SbTWWuk7e1aLkK1mjQilP+Ag=;
        b=kaLRELDUI8+ZMbH+GrOiUtqkFKOx7G9plMZR8GxmkIrh2zt1VKCi/7Pw9JEAjT6xJa
         oi2BMOLIT86bz1S2rGETizzRrRwTtsf0wGHONpNA+u96uAXkLtuAueVspily6vZpKD7T
         A99JKUx8oggqOKlL6Ebz+2L9LezIKQcPYVoltey/pxJrdWYebEgS7SKX5St15sc726xV
         Cna1/pVWpM6MpWWH5XVbNc6t6uVmSOKeYs0g4KZOanGLxxoicIVhAGclX+MJmkATo/sz
         AtXeOLVmWtEDUY6bE1P69OJb06ROrDXlyenQsGH9Ub0h7mf4WvVsoW1MPVFC8sLN7Eqe
         Gjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OFJbib0i55ODPDsGvy9SbTWWuk7e1aLkK1mjQilP+Ag=;
        b=lJYHboNx8kkB9mzk0IAc7UHxp7MmGaFOFLQrz/+Q20uLq8Qy3ntwpkQqZbeO3oX579
         ju/j/Jg1NfpYfEqyFXndBemwHZWDNdHyV1ekXuibvFEu3QOnSz82cMWA6Lx9a9r80z+R
         iSAy8SyljLZsXiz3Cxh1qN+g6jwGotpk5fm0tnborc/w7a6x2cXQIntlWjW8gdFqolhy
         pjxKc3nltQRmovd/EwhRGW2eL5wMlzxDfGEIF/4Zv/dHYj21FL9L8JlsAiaKCOinlHx/
         B5uZoIQ49nZuzdiS1EIOHFa712Vy3//STu8zkcaoPlJ/42957P1kvu68wi34Ny6mN0+C
         AL+Q==
X-Gm-Message-State: AOAM5309RvJiSA1rXvp59KIStAPhg0KTF8VoiUvVLeQOJpW1/TEgF1/A
        hgVYRoPF2usqoqgFA4quybw=
X-Google-Smtp-Source: ABdhPJx6lNAWdjPNB/QSJuQpZb3lkHBpcvFYMyBPT53ZteQdxG6o8IphqS2Jrqa8b5J35QclFSMXNA==
X-Received: by 2002:a63:ea0b:: with SMTP id c11mr8172070pgi.120.1619850881321;
        Fri, 30 Apr 2021 23:34:41 -0700 (PDT)
Received: from localhost ([112.79.230.123])
        by smtp.gmail.com with ESMTPSA id b6sm1617712pjk.13.2021.04.30.23.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 23:34:41 -0700 (PDT)
Date:   Sat, 1 May 2021 12:04:36 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Subject: Re: [PATCH bpf-next v5 3/3] libbpf: add selftests for TC-BPF API
Message-ID: <20210501063436.fcts6od3ua2mxojl@apollo>
References: <20210428162553.719588-1-memxor@gmail.com>
 <20210428162553.719588-4-memxor@gmail.com>
 <CAEf4BzYp1uN4E_=0N7DpwkEQOxntP0riz__yUzz3xu=k4yJ4sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYp1uN4E_=0N7DpwkEQOxntP0riz__yUzz3xu=k4yJ4sw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 01, 2021 at 01:11:47AM IST, Andrii Nakryiko wrote:
> On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This adds some basic tests for the low level bpf_tc_* API.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 467 ++++++++++++++++++
> >  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
> >  2 files changed, 479 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> > new file mode 100644
> > index 000000000000..40441f4e23e2
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> > @@ -0,0 +1,467 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <test_progs.h>
> > +#include <linux/pkt_cls.h>
> > +
> > +#include "test_tc_bpf.skel.h"
> > +
> > +#define LO_IFINDEX 1
> > +
> > +static int test_tc_internal(const struct bpf_tc_hook *hook, int fd)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1,
> > +                           .prog_fd = fd);
>
> we have 100 characters, if needed, use it to keep it on the single line
>

Ok.

> > +       struct bpf_prog_info info = {};
> > +       int ret;
> > +
> > +       ret = bpf_obj_get_info_by_fd(fd, &info, &(__u32){sizeof(info)});
>
> as in previous patch, don't do this
>
> > +       if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
> > +               return ret;
> > +
> > +       ret = bpf_tc_attach(hook, &opts, 0);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach"))
> > +               return ret;
> > +
> > +       if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
> > +           !ASSERT_EQ(opts.priority, 1, "priority set") ||
> > +           !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
> > +               goto end;
> > +
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .prog_fd = fd);
>
> this is not C89, please move variable declarations to the top
>
> > +       ret = bpf_tc_query(hook, &info_opts);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, .prog_id = info.id);
>
> and here
>
> > +       ret = bpf_tc_query(hook, &info_opts2);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
> > +           !ASSERT_EQ(opts.priority, 1, "priority set") ||
> > +           !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
> > +               goto end;
> > +
> > +       opts.prog_id = 0;
> > +       ret = bpf_tc_attach(hook, &opts, BPF_TC_F_REPLACE);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach replace mode"))
> > +               return ret;
>
> goto end?
>

Yes, thanks for spotting it.

> > +
> > +end:
> > +       opts.prog_fd = opts.prog_id = 0;
> > +       ret = bpf_tc_detach(hook, &opts);
> > +       ASSERT_OK(ret, "bpf_tc_detach");
> > +       return ret;
> > +}
> > +
>
> [...]
>
> > +
> > +       /* attach */
> > +       ret = bpf_tc_attach(NULL, &attach_opts, 0);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook = NULL"))
> > +               return -EINVAL;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 42);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid flags"))
> > +               return -EINVAL;
> > +       attach_opts.prog_fd = 0;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_fd unset"))
> > +               return -EINVAL;
> > +       attach_opts.prog_fd = fd;
> > +       attach_opts.prog_id = 42;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id set"))
> > +               return -EINVAL;
> > +       attach_opts.prog_id = 0;
> > +       attach_opts.handle = 0;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid handle unset"))
> > +               return -EINVAL;
> > +       attach_opts.prog_fd = attach_opts.prog_id = 0;
> > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
>
> this code is quite hard to follow, maybe sprinkle empty lines between
> logical groups of statements (i.e., prepare inputs + call bpf_tc_xxx +
> assert is one group that goes together)
>

I agree it looks bad. I can also just make a new opts for each combination, and
name it that way. Maybe that will look much better.

> > +       attach_opts.prog_fd = fd;
> > +       attach_opts.handle = 1;
> > +       attach_opts.priority = 0;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid priority unset"))
> > +               return -EINVAL;
> > +       attach_opts.prog_fd = attach_opts.prog_id = 0;
> > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
> > +       attach_opts.prog_fd = fd;
> > +       attach_opts.priority = UINT16_MAX + 1;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid priority > UINT16_MAX"))
> > +               return -EINVAL;
> > +       attach_opts.priority = 0;
> > +       attach_opts.handle = attach_opts.priority = 0;
> > +       ret = bpf_tc_attach(hook, &attach_opts, 0);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach valid both handle and priority unset"))
> > +               return -EINVAL;
> > +       attach_opts.prog_fd = attach_opts.prog_id = 0;
> > +       ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
> > +       ret = bpf_tc_attach(hook, NULL, 0);
> > +       if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts = NULL"))
> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}
> > +
> > +static int test_tc_query(const struct bpf_tc_hook *hook, int fd)
> > +{
> > +       struct test_tc_bpf *skel = NULL;
> > +       int new_fd, ret, i = 0;
> > +
> > +       skel = test_tc_bpf__open_and_load();
> > +       if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
> > +               return -EINVAL;
> > +
> > +       new_fd = bpf_program__fd(skel->progs.cls);
> > +
> > +       /* make sure no other filters are attached */
> > +       ret = bpf_tc_query(hook, NULL);
> > +       if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query == -ENOENT"))
> > +               goto end_destroy;
> > +
> > +       for (i = 0; i < 5; i++) {
> > +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);
>
> empty line after variable declaration
>

Ok, will fix everywhere.

> > +               ret = bpf_tc_attach(hook, &opts, 0);
> > +               if (!ASSERT_OK(ret, "bpf_tc_attach"))
> > +                       goto end;
> > +       }
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1,
> > +                           .prog_fd = new_fd);
> > +       ret = bpf_tc_attach(hook, &opts, 0);
> > +       if (!ASSERT_OK(ret, "bpf_tc_attach"))
> > +               goto end;
> > +       i++;
> > +
> > +       ASSERT_EQ(opts.handle, 1, "handle match");
> > +       ASSERT_EQ(opts.priority, 1, "priority match");
> > +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> > +
> > +       opts.prog_fd = 0;
> > +       /* search with handle, priority, prog_id */
> > +       ret = bpf_tc_query(hook, &opts);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       ASSERT_EQ(opts.handle, 1, "handle match");
> > +       ASSERT_EQ(opts.priority, 1, "priority match");
> > +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> > +
> > +       opts.priority = opts.prog_fd = 0;
> > +       /* search with handle, prog_id */
> > +       ret = bpf_tc_query(hook, &opts);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       ASSERT_EQ(opts.handle, 1, "handle match");
> > +       ASSERT_EQ(opts.priority, 1, "priority match");
> > +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> > +
> > +       opts.handle = opts.prog_fd = 0;
> > +       /* search with priority, prog_id */
> > +       ret = bpf_tc_query(hook, &opts);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       ASSERT_EQ(opts.handle, 1, "handle match");
> > +       ASSERT_EQ(opts.priority, 1, "priority match");
> > +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> > +
> > +       opts.handle = opts.priority = opts.prog_fd = 0;
> > +       /* search with prog_id */
> > +       ret = bpf_tc_query(hook, &opts);
> > +       if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +               goto end;
> > +
> > +       ASSERT_EQ(opts.handle, 1, "handle match");
> > +       ASSERT_EQ(opts.priority, 1, "priority match");
> > +       ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
> > +
> > +       while (i != 1) {
> > +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, .prog_fd = fd);
>
> empty line here
>
> > +               ret = bpf_tc_query(hook, &del_opts);
> > +               if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +                       goto end;
> > +               ASSERT_NEQ(del_opts.prog_id, opts.prog_id, "prog_id should not be same");
> > +               ASSERT_NEQ(del_opts.priority, 1, "priority should not be 1");
> > +               del_opts.prog_fd = del_opts.prog_id = 0;
> > +               ret = bpf_tc_detach(hook, &del_opts);
> > +               if (!ASSERT_OK(ret, "bpf_tc_detach"))
> > +                       goto end;
> > +               i--;
> > +       }
> > +
> > +       opts.handle = opts.priority = opts.prog_id = 0;
> > +       opts.prog_fd = fd;
> > +       ret = bpf_tc_query(hook, &opts);
> > +       ASSERT_EQ(ret, -ENOENT, "bpf_tc_query == -ENOENT");
> > +
> > +end:
> > +       while (i--) {
> > +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, 0);
>
> you get the idea by now
>
> > +               ret = bpf_tc_query(hook, &del_opts);
> > +               if (!ASSERT_OK(ret, "bpf_tc_query"))
> > +                       break;
> > +               del_opts.prog_id = 0;
> > +               ret = bpf_tc_detach(hook, &del_opts);
> > +               if (!ASSERT_OK(ret, "bpf_tc_detach"))
> > +                       break;
> > +       }
> > +       ASSERT_EQ(bpf_tc_query(hook, NULL), -ENOENT, "bpf_tc_query == -ENOENT");
> > +end_destroy:
> > +       test_tc_bpf__destroy(skel);
> > +       return ret;
> > +}
> > +
>
> [...]

--
Kartikeya
