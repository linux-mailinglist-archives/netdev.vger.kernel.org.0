Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5599036B767
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhDZRDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZRDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:03:52 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261E6C061574;
        Mon, 26 Apr 2021 10:03:11 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i4so28177991ybe.2;
        Mon, 26 Apr 2021 10:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnz/euQGxswp6W51WkegySe2ZyjR6VaxNo6diO6hbGI=;
        b=t1b7Sjkd/n5n6GtEhL+mndb+6p24rBsG3KynJR22NIe1eDr3prlQAZFzkJXLGRF/lR
         nWMPiXxVxxaGNsaIqn2vWOK4J4mKNScP/q9iQTvPrgxZNWP0rYvfHdOI5TtJg/fhR0Ky
         PIB9o6soyw+eQ02s71g18brHoPKeVPHq2n6htfMltM1bUiG4gC6PLl0HYt0oKEWEdeNp
         Xh2CjdJ2WR/TGfP0oPDxRlgZI69RH/WcEtRiNI1ymWrLpKb+le2h9o2T86Ak4zcXwCFe
         euw4wJ8NLjWxxD66PSyew9q02chJddlYdO3Hdg6fcUZy/kUZFr/DJPmW86mzDu79IIi2
         QI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnz/euQGxswp6W51WkegySe2ZyjR6VaxNo6diO6hbGI=;
        b=hmGiU+uK92d80g0vLX0eiT4KjQNuINjWJ/z6L5x2e4KWe8iTp6AuuhCzU5sfsQt5eD
         mfSUZ5F2y2nM8KGXLWpOMHJLKc4jjQ9wlIH0AyHQCrfiM1PS250FCGWPHfts/QcxmNUG
         JjXLTV2fJodqiMsqEMLk2hawxoaGB26JLETlpJsKchP4/t4SPdJy1mj+DsPPIVYCjhTf
         EUx85FmRI7hE6n4N9GE9gR5bjbpOykEKOnqX4moRwtBtJLJLILWjexCxN5PXxK8UvY+d
         U9DFcYnB45fP5Q+xRMI5rtvYqpshIuhcJaXD41DaTtD0DcXWQHXXonwyrUMBwvhf6H9p
         Hr4g==
X-Gm-Message-State: AOAM531owC2jfhPXhod27PP4FvX1L/tQ6ym1fbElvf9s86LdowZQAWGi
        9Z7M0Ve+g7Z3r8RIrUffodezuVCl2lKAvS0ia2Td5IeN
X-Google-Smtp-Source: ABdhPJyUfhcDN7m2npEaon8lPRui+h0b73s0sp2Ep2xFtpfTqDJTdyrPxFNPZKK6rWC6vFkQiwVflX00d+jFGAQZwF8=
X-Received: by 2002:a25:9942:: with SMTP id n2mr26815259ybo.230.1619456590427;
 Mon, 26 Apr 2021 10:03:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-6-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-6-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 10:02:59 -0700
Message-ID: <CAEf4BzafXkmX5RJ+c+4h9ZXV6mvto=Shx3JWL1m_AkXc9pU_4g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/16] selftests/bpf: Test for syscall program type
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> bpf_prog_type_syscall is a program that creates a bpf map,
> updates it, and loads another bpf program using bpf_sys_bpf() helper.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile          |  1 +
>  .../selftests/bpf/prog_tests/syscall.c        | 53 ++++++++++++++
>  tools/testing/selftests/bpf/progs/syscall.c   | 73 +++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
>  create mode 100644 tools/testing/selftests/bpf/progs/syscall.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index c5bcdb3d4b12..9fdfdbc61857 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -278,6 +278,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>  BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
>              -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> +            -I$(TOOLSINCDIR) \

is this for filter.h? also, please align \ with the previous line


>              -I$(abspath $(OUTPUT)/../usr/include)
>
>  CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> diff --git a/tools/testing/selftests/bpf/prog_tests/syscall.c b/tools/testing/selftests/bpf/prog_tests/syscall.c
> new file mode 100644
> index 000000000000..e550e36bb5da
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/syscall.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <test_progs.h>
> +#include "syscall.skel.h"
> +
> +struct args {
> +       __u64 log_buf;
> +       __u32 log_size;
> +       int max_entries;
> +       int map_fd;
> +       int prog_fd;
> +};
> +
> +void test_syscall(void)
> +{
> +       static char verifier_log[8192];
> +       struct args ctx = {
> +               .max_entries = 1024,
> +               .log_buf = (uintptr_t) verifier_log,
> +               .log_size = sizeof(verifier_log),
> +       };
> +       struct bpf_prog_test_run_attr tattr = {
> +               .ctx_in = &ctx,
> +               .ctx_size_in = sizeof(ctx),
> +       };
> +       struct syscall *skel = NULL;
> +       __u64 key = 12, value = 0;
> +       __u32 duration = 0;
> +       int err;
> +
> +       skel = syscall__open_and_load();
> +       if (CHECK(!skel, "skel_load", "syscall skeleton failed\n"))
> +               goto cleanup;
> +
> +       tattr.prog_fd = bpf_program__fd(skel->progs.bpf_prog);
> +       err = bpf_prog_test_run_xattr(&tattr);
> +       if (CHECK(err || tattr.retval != 1, "test_run sys_bpf",
> +                 "err %d errno %d retval %d duration %d\n",
> +                 err, errno, tattr.retval, tattr.duration))
> +               goto cleanup;
> +
> +       CHECK(ctx.map_fd <= 0, "map_fd", "fd = %d\n", ctx.map_fd);
> +       CHECK(ctx.prog_fd <= 0, "prog_fd", "fd = %d\n", ctx.prog_fd);

please use ASSERT_xxx() macros everywhere. I've just added
ASSERT_GT(), so once that patch set lands you should have all the
variants you need.

> +       CHECK(memcmp(verifier_log, "processed", sizeof("processed") - 1) != 0,
> +             "verifier_log", "%s\n", verifier_log);
> +
> +       err = bpf_map_lookup_elem(ctx.map_fd, &key, &value);
> +       CHECK(err, "map_lookup", "map_lookup failed\n");
> +       CHECK(value != 34, "invalid_value",
> +             "got value %llu expected %u\n", value, 34);
> +cleanup:
> +       syscall__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
> new file mode 100644
> index 000000000000..01476f88e45f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/syscall.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <../../tools/include/linux/filter.h>

with TOOLSINCDIR shouldn't this be just <linux/fiter.h>?

> +
> +volatile const int workaround = 1;

not needed anymore?

> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct args {
> +       __u64 log_buf;
> +       __u32 log_size;
> +       int max_entries;
> +       int map_fd;
> +       int prog_fd;
> +};
> +

[...]
