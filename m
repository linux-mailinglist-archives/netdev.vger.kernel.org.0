Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D3929F907
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJ2XUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2XUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:20:39 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AC3C0613CF;
        Thu, 29 Oct 2020 16:20:39 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id z7so1727969ybg.10;
        Thu, 29 Oct 2020 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3/xMsT385nCHYch0bs0BEYG9Veo3bBO1CDv/W1TUSA=;
        b=EZBl678XgYFiwMXDxz/x51PqL5pxFBlETeaSDsJoI0YbHgndng3QZKA819FCxfHd7R
         2Rf067dH/cm7L5sFeta1FERSY+u7RERDFgh6b0cfVqzfc3ObwLeGwVWWdggXuRqpLEku
         RnOeUTHn8X0vI9wyvL88eVR78Sp+JYFKEilnkqb/Fdd1U4hLjhkQXTrGM69HJztwLpPn
         fPmncXEWqJXYzPQQGL/ta0oKEfrGHUHqXcVLQMC4SjSF7pHHesY3F5ZwFTtGCGKEA2xR
         7ppmbJjbEzmUgTXIApdkGG348crgKeJx749hvtccTbbrcv5wWYnlyJu4eE2PXnl578RI
         PDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M3/xMsT385nCHYch0bs0BEYG9Veo3bBO1CDv/W1TUSA=;
        b=BlqRqB3ZguoCVTiWUT1+zRqu3EMboS8+VsCzhbik9EWxiFNWIY1FcwEFvKh5kIRInl
         ZuJXYP59XMR7lqZgHd/otzHJVPbLv3s8lM7Z/GGIiVS7w/wxQ3+vgVzsfG1Rub2g9vtI
         t+QcFrWHgFC8SMFHE4jt3c1xVIv0/rQrq44t7Qu4oobrRC3f3sFk/il9fF1CQ5K++lQl
         1KAY3hmUJhfLaapr/N7XRMPiAYCoc9B8YAvJfuKHwF7wh0olC4cvg+7ljLxCF9VVaOBK
         yWPDwi7/lGVaOZKb3vRJjiZaP9ckAg9PSkuNL+TJc+bIIUAJ5Se4wS82oCs3vA1Ui4uM
         KYxg==
X-Gm-Message-State: AOAM531cQsG2+ghJHFrQNnPnmF84QhrhNRq22jhnQAZS7nzTthpkKDdw
        6FZacJbzcow9A4VgneF4Z65NPQLbTWE286lPqz0=
X-Google-Smtp-Source: ABdhPJxOYE9yGdno80O0/bLXy0TfAT4omkcmpPtfFgUyITnuy4oiWjo9bnLR9iWtQmJdi1PSn6IcxpCDyf+tpnIFdJI=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr9965376ybk.260.1604013639087;
 Thu, 29 Oct 2020 16:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384964803.698509.11020605670605638967.stgit@localhost.localdomain>
In-Reply-To: <160384964803.698509.11020605670605638967.stgit@localhost.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 16:20:28 -0700
Message-ID: <CAEf4BzaELDiuHLbSdWdZZcjw5eNCJELBeHUc2CRiursUcUj_kg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 4/4] selftests/bpf: Migrate tcpbpf_user.c to use
 BPF skeleton
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 12:57 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> simplify test_tcpbpf_user and reduce the overhead involved in setting up
> the test.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---

Few suggestions below, but overall looks good:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 +++++++++-----------
>  1 file changed, 21 insertions(+), 27 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index 4e1190894e1e..7e92c37976ac 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -5,6 +5,7 @@
>
>  #include "test_tcpbpf.h"
>  #include "cgroup_helpers.h"
> +#include "test_tcpbpf_kern.skel.h"
>
>  #define LO_ADDR6 "::1"
>  #define CG_NAME "/tcpbpf-user-test"
> @@ -162,39 +163,32 @@ static void run_test(int map_fd, int sock_map_fd)
>
>  void test_tcpbpf_user(void)
>  {
> -       const char *file = "test_tcpbpf_kern.o";
> -       int prog_fd, map_fd, sock_map_fd;
> -       struct bpf_object *obj;
> +       struct test_tcpbpf_kern *skel;
> +       int map_fd, sock_map_fd;
> +       struct bpf_link *link;
>         int cg_fd = -1;
> -       int rv;
> -
> -       cg_fd = cgroup_setup_and_join(CG_NAME);
> -       if (CHECK_FAIL(cg_fd < 0))
> -               goto err;
>
> -       if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
> -               fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> -               goto err;
> -       }
> +       skel = test_tcpbpf_kern__open_and_load();
> +       if (CHECK(!skel, "open and load skel", "failed"))
> +               return;
>
> -       rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> -       if (CHECK_FAIL(rv)) {
> -               fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> -                      errno, strerror(errno));
> -               goto err;
> -       }
> +       cg_fd = test__join_cgroup(CG_NAME);
> +       if (CHECK_FAIL(cg_fd < 0))

please use either CHECK() or one of the newer ASSERT_xxx() macro (also
defined in test_progs.h), CHECK_FAIL should be avoided in general.

> +               goto cleanup_skel;
>
> -       map_fd = bpf_find_map(__func__, obj, "global_map");
> -       if (CHECK_FAIL(map_fd < 0))
> -               goto err;
> +       map_fd = bpf_map__fd(skel->maps.global_map);
> +       sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
>
> -       sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> -       if (CHECK_FAIL(sock_map_fd < 0))
> -               goto err;
> +       link = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);

you can do skel->links.bpf_testcb = bpf_program__attach_cgroup() and
skeleton's __destroy() call will take care of destroying the link

> +       if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
> +                 PTR_ERR(link)))

there is a convenient ASSERT_OK_PTR() specifically for pointers like
this (and NULL ones as well, of course); saves a lot of typing and
encapsulates error extraction internally.

> +               goto cleanup_namespace;
>
>         run_test(map_fd, sock_map_fd);
> -err:
> -       bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
> +
> +       bpf_link__destroy(link);
> +cleanup_namespace:
>         close(cg_fd);
> -       cleanup_cgroup_environment();
> +cleanup_skel:
> +       test_tcpbpf_kern__destroy(skel);
>  }
>
>
