Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACAD217ACF
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgGGV6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbgGGV6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:58:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB98C061755;
        Tue,  7 Jul 2020 14:58:32 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b4so39643145qkn.11;
        Tue, 07 Jul 2020 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRl2g7a2YbbpymqHGFR0TKGIinBWou5sIwQBTXYNhZQ=;
        b=cgaAnoCv17bwa9CIAyoY2pMXRf0AmK8OcJdztI3Nh3Z1e81FUOk+z6/x2zKNIfA4GL
         jT2QmvmVfaGCowZX+B9KjsmuVwcekGunsKiP47RTWi9Z9TC/9DK8U8b2F216uVHYsTGB
         p/oPuAbvAuYHMxAvzvKnAvrlGMou9zJFLWSAg6XOAUtLar9HE2PSOqyZyrBKLsL2Q1tp
         XO6O1Km/+CaWyDlqcIiL+XOgL59Mo8YEP3OyJPeoragHSExY8Nt0jRaYAHlEBzrQEky+
         bKnRg4+0xV5Bbvekty7/KgLCvR2yxBWS9D1GrOrohSdDJCJlQ0RCh30K2CF8s2X31TcL
         tuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRl2g7a2YbbpymqHGFR0TKGIinBWou5sIwQBTXYNhZQ=;
        b=Qe4y+FU1O8D/iKhF5ChBdICCeiFaYA8AgM4Lu3/mdOHTZy1kjjU/nLnbsNvn8vhiDI
         oV4b6glIJ2M4EdNHJ6QRlpIVEN2/+O5LYKzT2C21LHDvriSPe15W25bEoUoT+c9Oc5mD
         7hjn7AQK6UwEKe0k1Ppt1i+McVNYOCd9w/jp1P3J8RCsMYUWTFlKyIxglotU4IEYgPoO
         uz/eJ5nFNLiXaH7umHPTwrPJHMFd8rU17MWBQGi+wua+ZqTX3wqhGw3nodZflr9c3JDq
         CXRtcmGO0ADbcHXklFXCJqVx8v6dkzIzd6wytHDnS5tVE81fgHXaxRivDFUBKAG0c2rK
         KiKg==
X-Gm-Message-State: AOAM533IyrV7uhIhkul+pnf+ubsVxGXhLQuAGRRhRCsEV/XQfxmAEBgo
        ZzOtjn3prOH49u4KL5JUqUbW7ojt3WvouE4/jgM=
X-Google-Smtp-Source: ABdhPJwP+fRBt7x8g1bmhda5bnRf++sR6lOGVWE4speDn3m1Ju4k9NQc5Mo5YMbF4ahh66HajvB3+Q8GyjEibi9X5YI=
X-Received: by 2002:a37:7683:: with SMTP id r125mr51549294qkc.39.1594159111707;
 Tue, 07 Jul 2020 14:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com> <20200706230128.4073544-5-sdf@google.com>
 <294755e5-58e7-5512-a2f5-2dc37f200acf@iogearbox.net>
In-Reply-To: <294755e5-58e7-5512-a2f5-2dc37f200acf@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 14:58:20 -0700
Message-ID: <CAEf4BzYbEzbEsPKYOt8d+431yhNHXBf4oEP4W9M_07crC8x7rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 2:45 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/7/20 1:01 AM, Stanislav Fomichev wrote:
> > Simple test that enforces a single SOCK_DGRAM socker per cgroup.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   .../selftests/bpf/prog_tests/udp_limit.c      | 75 +++++++++++++++++++
> >   tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
> >   2 files changed, 117 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > new file mode 100644
> > index 000000000000..2aba09d4d01b
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > @@ -0,0 +1,75 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "udp_limit.skel.h"
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +
> > +static int duration;
> > +
> > +void test_udp_limit(void)
> > +{
> > +     struct udp_limit *skel;
> > +     int fd1 = -1, fd2 = -1;
> > +     int cgroup_fd;
> > +
> > +     cgroup_fd = test__join_cgroup("/udp_limit");
> > +     if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > +             return;
> > +
> > +     skel = udp_limit__open_and_load();
> > +     if (CHECK(!skel, "skel-load", "errno %d", errno))
> > +             goto close_cgroup_fd;
> > +
> > +     skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock, cgroup_fd);
> > +     skel->links.sock_release = bpf_program__attach_cgroup(skel->progs.sock_release, cgroup_fd);
> > +     if (CHECK(IS_ERR(skel->links.sock) || IS_ERR(skel->links.sock_release),
> > +               "cg-attach", "sock %ld sock_release %ld",
> > +               PTR_ERR(skel->links.sock),
> > +               PTR_ERR(skel->links.sock_release)))
> > +             goto close_skeleton;
> > +
> > +     /* BPF program enforces a single UDP socket per cgroup,
> > +      * verify that.
> > +      */
> > +     fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > +     if (CHECK(fd1 < 0, "fd1", "errno %d", errno))
> > +             goto close_skeleton;
> > +
> > +     fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> > +     if (CHECK(fd2 >= 0, "fd2", "errno %d", errno))
> > +             goto close_skeleton;
> > +
> > +     /* We can reopen again after close. */
> > +     close(fd1);
> > +     fd1 = -1;
> > +
> > +     fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > +     if (CHECK(fd1 < 0, "fd1-again", "errno %d", errno))
> > +             goto close_skeleton;
> > +
> > +     /* Make sure the program was invoked the expected
> > +      * number of times:
> > +      * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
> > +      * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
> > +      * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
> > +      * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
> > +      */
> > +     if (CHECK(skel->bss->invocations != 4, "bss-invocations",
> > +               "invocations=%d", skel->bss->invocations))
> > +             goto close_skeleton;
> > +
> > +     /* We should still have a single socket in use */
> > +     if (CHECK(skel->bss->in_use != 1, "bss-in_use",
> > +               "in_use=%d", skel->bss->in_use))
> > +             goto close_skeleton;
> > +
> > +close_skeleton:
> > +     if (fd1 >= 0)
> > +             close(fd1);
> > +     if (fd2 >= 0)
> > +             close(fd2);
> > +     udp_limit__destroy(skel);
> > +close_cgroup_fd:
> > +     close(cgroup_fd);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> > new file mode 100644
> > index 000000000000..edbb30a27e63
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/udp_limit.c
> > @@ -0,0 +1,42 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <sys/socket.h>
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +int invocations = 0, in_use = 0;
> > +
> > +SEC("cgroup/sock")
>
> nit: Doesn't matter overly much, but given you've added `cgroup/sock_create`
> earlier in patch 2/4 intention was probably to use it as well. But either is
> fine as it resolved to the same.

heh, had the same thought, but didn't want to be too nitpicky :)


>
> > +int sock(struct bpf_sock *ctx)
> > +{
> > +     __u32 key;
> > +
> > +     if (ctx->type != SOCK_DGRAM)
> > +             return 1;
> > +
> > +     __sync_fetch_and_add(&invocations, 1);
> > +
> > +     if (in_use > 0) {
> > +             /* BPF_CGROUP_INET_SOCK_RELEASE is _not_ called
> > +              * when we return an error from the BPF
> > +              * program!
> > +              */
> > +             return 0;
> > +     }
> > +
> > +     __sync_fetch_and_add(&in_use, 1);
> > +     return 1;
> > +}
> > +
> > +SEC("cgroup/sock_release")
> > +int sock_release(struct bpf_sock *ctx)
> > +{
> > +     __u32 key;
> > +
> > +     if (ctx->type != SOCK_DGRAM)
> > +             return 1;
> > +
> > +     __sync_fetch_and_add(&invocations, 1);
> > +     __sync_fetch_and_add(&in_use, -1);
> > +     return 1;
> > +}
> >
>
