Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B020BD3F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgFZXwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgFZXwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:52:13 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FBCC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:52:13 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id k18so10419819qke.4
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gI03mDImNBjEvrjz4ihjz08of12xK1LbiEBN3LhkTuc=;
        b=TDWoBAwCvhF3QKWqqNeSjsGLjWoTGKyyNED5gz8iAfOa4c1jXV0qWr7PkxegKN0WfJ
         UFYghHjLNtB6nZc3qCh6dmdzlTOkNdsIgzJubfh4ot/j87oIiZGUJ8JKhQbsZYxzJTOx
         bFunFWEUOYabDZ6iE26t+5oopMQAz2+5+MXzHrnVVf4/GJaNf9yV5u3cfG1IU38wphg+
         Q0P7Px11gh+T3F7Ck4BXeEyNBDcBE5yA7GnMQP75Iwzq+BzfS8u5TQkzX890ri4aX0fT
         WWQF+c7uNI0L/PF3ahfXckFkhFj40cjMaNmNKuuV+qpCuwAAHKeGiBgjWmTOkXUS6tD0
         4+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gI03mDImNBjEvrjz4ihjz08of12xK1LbiEBN3LhkTuc=;
        b=kdjynDm46laUEf4bjFBCA0/IxOYJtkEvFqrmSBVlC/95qTOWLLRnacECNjAIxBJdxU
         6vghRMsNswaSJGCW6DM0T2DSaU3MtBEYt61zJt95kvyVH0eGDTYlsXv78AegXi88hYKD
         cWHiOSvCRu+vfnxbUARaMXpXZGX24FD/LuIdwJxJdGuezsQEXStAOINpFnudqaCK/MRE
         3aOKBvdtQkVU3B6qP17xJZxiq+iCrttYiTXriZY8hTm2zzqyxhtSd7jh9AVNGK8Sb8+R
         uM7u7d/nFzCQjFI7Muej0E3HYjZoIipz/UjFH1If3Y6tJxc+7hZorXabL6VhusZEB4pi
         1EOw==
X-Gm-Message-State: AOAM531FYm8yRuRJt/H6IjFc0ZV77ZYjyzYC6g9Zpmhv99LRlpw4oVnS
        0mBldaRDidrsRdEgHlKWidjISDuvLZJfK9CshJh9oA==
X-Google-Smtp-Source: ABdhPJz2QSZgOImwEWZGzK57Prf23BJe3zqKaKL/J6t8RwBpAZEi93bkKr3wgkIMIy2vDl52mwhBzItIl5FC8Uc2z74=
X-Received: by 2002:ae9:ed8c:: with SMTP id c134mr5077516qkg.485.1593215532407;
 Fri, 26 Jun 2020 16:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com> <20200626000929.217930-4-sdf@google.com>
 <CAEf4BzaeEKvw0S5oMe7N+mUOyeEzaU3bPbaMPtMXrQ1CnVHXBw@mail.gmail.com>
In-Reply-To: <CAEf4BzaeEKvw0S5oMe7N+mUOyeEzaU3bPbaMPtMXrQ1CnVHXBw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 26 Jun 2020 16:52:01 -0700
Message-ID: <CAKH8qBtKOrOg5-4KgS2ZqkvWApdM19rqe-BNB4_kes_VzJtWGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:06 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 25, 2020 at 5:13 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Simple test that enforces a single SOCK_DGRAM socker per cgroup.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/udp_limit.c      | 71 +++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
> >  2 files changed, 113 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > new file mode 100644
> > index 000000000000..fe359a927d92
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > @@ -0,0 +1,71 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "udp_limit.skel.h"
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +
> > +void test_udp_limit(void)
> > +{
> > +       struct udp_limit *skel;
> > +       int cgroup_fd;
> > +       int fd1, fd2;
> > +       int err;
> > +
> > +       cgroup_fd = test__join_cgroup("/udp_limit");
> > +       if (CHECK_FAIL(cgroup_fd < 0))
> > +               return;
> > +
> > +       skel = udp_limit__open_and_load();
> > +       if (CHECK_FAIL(!skel))
> > +               goto close_cgroup_fd;
> > +
> > +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock),
> > +                             cgroup_fd, BPF_CGROUP_INET_SOCK_CREATE, 0);
> > +       if (CHECK_FAIL(err))
> > +               goto close_skeleton;
> > +
> > +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock_release),
> > +                             cgroup_fd, BPF_CGROUP_INET_SOCK_RELEASE, 0);
> > +       if (CHECK_FAIL(err))
> > +               goto close_skeleton;
>
> Have you tried:
>
> skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock);
>
> and similarly for sock_release?
Ack, I can try that, thanks!

> > +       /* BPF program enforces a single UDP socket per cgroup,
> > +        * verify that.
> > +        */
> > +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > +       if (CHECK_FAIL(fd1 < 0))
> > +               goto close_skeleton;
> > +
> > +       fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> > +       if (CHECK_FAIL(fd2 != -1))
> > +               goto close_fd1;
> > +
> > +       /* We can reopen again after close. */
> > +       close(fd1);
> > +
> > +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > +       if (CHECK_FAIL(fd1 < 0))
> > +               goto close_skeleton;
> > +
> > +       /* Make sure the program was invoked the expected
> > +        * number of times:
> > +        * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
> > +        * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
> > +        * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
> > +        * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
> > +        */
> > +       if (CHECK_FAIL(skel->bss->invocations != 4))
> > +               goto close_fd1;
> > +
> > +       /* We should still have a single socket in use */
> > +       if (CHECK_FAIL(skel->bss->in_use != 1))
> > +               goto close_fd1;
>
> Please use a non-silent CHECK() macro for everything that's a proper
> and not a high-frequency check. That generates "a log trail" when
> running the test in verbose mode, so it's easier to pinpoint where the
> failure happened.
IIRC, the problem with CHECK() is that it requires a 'duration'
argument to be defined.
Do you suggest defining it somewhere just to make CHECK() happy?

> > +
> > +close_fd1:
> > +       close(fd1);
> > +close_skeleton:
> > +       udp_limit__destroy(skel);
> > +close_cgroup_fd:
> > +       close(cgroup_fd);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> > new file mode 100644
> > index 000000000000..98fe294d9c21
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/udp_limit.c
> > @@ -0,0 +1,42 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <sys/socket.h>
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +int invocations, in_use;
> > +
> > +SEC("cgroup/sock")
> > +int sock(struct bpf_sock *ctx)
> > +{
> > +       __u32 key;
> > +
> > +       if (ctx->type != SOCK_DGRAM)
> > +               return 1;
> > +
> > +       __sync_fetch_and_add(&invocations, 1);
> > +
> > +       if (&in_use > 0) {
>
>
> &in_use is supposed to return an address of a variable... this looks
> weird and probably not what you wanted?
Oh, good catch! I was about to ask myself "how did the test pass with
that?", but the test fails as well :-/
Not sure how it creeped in and how I ran my tests, sorry about that.
