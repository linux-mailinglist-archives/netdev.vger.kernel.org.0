Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3920BD84
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgF0A6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgF0A6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:58:09 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D408C03E979;
        Fri, 26 Jun 2020 17:58:09 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e12so8874023qtr.9;
        Fri, 26 Jun 2020 17:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8UIcZXbBWH3Ma/VnUM+HcX2OKov1AW7BfAlRMWlFraw=;
        b=daVnEkK75+jswOMsCzWm2dYP9PeWP/Yu7VB3GFqzHv+9lkAUAO63WR33vyy15sArL4
         kc+Xu0yZkVSOfOyyog5ATPcbHAcroaBms82j3i/rjkRCeUWKBK/QLbbzHJYD6+q2pEaQ
         6i6jAOBvflbg4dyiZazlbYjKfXH/a+TdwTjvsfChGpCSpNU4znmxg23DM7H59imnQj+X
         Cd3lnnRxGXNMXgdxPwFnYv2RuSX75bzyZVNgbTJ99iOqft7M12xqOBF/H3uB7YFD7C+i
         ysnmJUyvWTAelVh005wogD0zh6IKUw3HpqvjNF+yU5xnZIvPc9E5dmS09WpB+osInZzW
         pKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UIcZXbBWH3Ma/VnUM+HcX2OKov1AW7BfAlRMWlFraw=;
        b=CFs73fzm+Hzv6mgyssIAo7OrGb2f2FF/Iy0VAr0QIqIXskYTNm3TAryAnsk5fqPjOw
         55nMHOEKeWvzvO6I2CKQk6viYgp+RaB0aCrjl6RFL0II8aF2Z0kYTYhFKZM4LlZ0gvmA
         zKFClA7o9wM0lEz06cnabppsU7Nq4sWJdaovAaFwyogHqzGwyC/oL3nJl8qyi1d8+K8K
         b/xb60Su62e6/B21pya1AT2tj3yZ+LL56B6e9XjQEQuUb7GkiComB0uR4uVpKpi7BB8L
         dlkmF2A1V4Fcw5OQj4Jhdy4rh2/FKF9KnXQ2QubZsNL9RXSwC1W3fMW37dzL80lzGr4F
         yAJQ==
X-Gm-Message-State: AOAM532UXmIgaJEoIRTOUez2vXD39pRV5OpD5/xscz/iVnd4anEyJyOX
        tOPAYDK0mBcfBlrqL9sjhfvpi3IrSyLCXh714UA=
X-Google-Smtp-Source: ABdhPJxSjnD3pfC+mc+cxdAnGA+R7qu0p57UoccipqZ1BArVUYVCAP34FpM3ctPny6JFXiPjhlZFKphXzvVNqhiZBvI=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr5535938qtd.59.1593219488070;
 Fri, 26 Jun 2020 17:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com> <20200626000929.217930-4-sdf@google.com>
 <CAEf4BzaeEKvw0S5oMe7N+mUOyeEzaU3bPbaMPtMXrQ1CnVHXBw@mail.gmail.com> <CAKH8qBtKOrOg5-4KgS2ZqkvWApdM19rqe-BNB4_kes_VzJtWGQ@mail.gmail.com>
In-Reply-To: <CAKH8qBtKOrOg5-4KgS2ZqkvWApdM19rqe-BNB4_kes_VzJtWGQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 17:57:57 -0700
Message-ID: <CAEf4BzYzaooN3wg7x8ju3D__EhVnCWcq09u8L3fL5W6qWg5OPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 4:52 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jun 26, 2020 at 3:06 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 25, 2020 at 5:13 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Simple test that enforces a single SOCK_DGRAM socker per cgroup.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/udp_limit.c      | 71 +++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
> > >  2 files changed, 113 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > > new file mode 100644
> > > index 000000000000..fe359a927d92
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> > > @@ -0,0 +1,71 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <test_progs.h>
> > > +#include "udp_limit.skel.h"
> > > +
> > > +#include <sys/types.h>
> > > +#include <sys/socket.h>
> > > +
> > > +void test_udp_limit(void)
> > > +{
> > > +       struct udp_limit *skel;
> > > +       int cgroup_fd;
> > > +       int fd1, fd2;
> > > +       int err;
> > > +
> > > +       cgroup_fd = test__join_cgroup("/udp_limit");
> > > +       if (CHECK_FAIL(cgroup_fd < 0))
> > > +               return;
> > > +
> > > +       skel = udp_limit__open_and_load();
> > > +       if (CHECK_FAIL(!skel))
> > > +               goto close_cgroup_fd;
> > > +
> > > +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock),
> > > +                             cgroup_fd, BPF_CGROUP_INET_SOCK_CREATE, 0);
> > > +       if (CHECK_FAIL(err))
> > > +               goto close_skeleton;
> > > +
> > > +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock_release),
> > > +                             cgroup_fd, BPF_CGROUP_INET_SOCK_RELEASE, 0);
> > > +       if (CHECK_FAIL(err))
> > > +               goto close_skeleton;
> >
> > Have you tried:
> >
> > skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock);
> >
> > and similarly for sock_release?
> Ack, I can try that, thanks!
>
> > > +       /* BPF program enforces a single UDP socket per cgroup,
> > > +        * verify that.
> > > +        */
> > > +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > > +       if (CHECK_FAIL(fd1 < 0))
> > > +               goto close_skeleton;
> > > +
> > > +       fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> > > +       if (CHECK_FAIL(fd2 != -1))
> > > +               goto close_fd1;
> > > +
> > > +       /* We can reopen again after close. */
> > > +       close(fd1);
> > > +
> > > +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> > > +       if (CHECK_FAIL(fd1 < 0))
> > > +               goto close_skeleton;
> > > +
> > > +       /* Make sure the program was invoked the expected
> > > +        * number of times:
> > > +        * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
> > > +        * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
> > > +        * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
> > > +        * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
> > > +        */
> > > +       if (CHECK_FAIL(skel->bss->invocations != 4))
> > > +               goto close_fd1;
> > > +
> > > +       /* We should still have a single socket in use */
> > > +       if (CHECK_FAIL(skel->bss->in_use != 1))
> > > +               goto close_fd1;
> >
> > Please use a non-silent CHECK() macro for everything that's a proper
> > and not a high-frequency check. That generates "a log trail" when
> > running the test in verbose mode, so it's easier to pinpoint where the
> > failure happened.
> IIRC, the problem with CHECK() is that it requires a 'duration'
> argument to be defined.
> Do you suggest defining it somewhere just to make CHECK() happy?

Yes, that's what most tests are doing. Just `static int duration;` on
top of test file, and you can forget about it.

>
> > > +
> > > +close_fd1:
> > > +       close(fd1);
> > > +close_skeleton:
> > > +       udp_limit__destroy(skel);
> > > +close_cgroup_fd:
> > > +       close(cgroup_fd);
> > > +}
> > > diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> > > new file mode 100644
> > > index 000000000000..98fe294d9c21
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/udp_limit.c
> > > @@ -0,0 +1,42 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +#include <sys/socket.h>
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +
> > > +int invocations, in_use;
> > > +
> > > +SEC("cgroup/sock")
> > > +int sock(struct bpf_sock *ctx)
> > > +{
> > > +       __u32 key;
> > > +
> > > +       if (ctx->type != SOCK_DGRAM)
> > > +               return 1;
> > > +
> > > +       __sync_fetch_and_add(&invocations, 1);
> > > +
> > > +       if (&in_use > 0) {
> >
> >
> > &in_use is supposed to return an address of a variable... this looks
> > weird and probably not what you wanted?
> Oh, good catch! I was about to ask myself "how did the test pass with
> that?", but the test fails as well :-/
> Not sure how it creeped in and how I ran my tests, sorry about that.

Yeah, I was wondering that myself :) but was too lazy to check the exact logic.
