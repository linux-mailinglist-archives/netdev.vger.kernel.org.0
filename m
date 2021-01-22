Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8F2FF96B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 01:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAVAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 19:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhAVAZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 19:25:17 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896FBC06174A;
        Thu, 21 Jan 2021 16:24:37 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id f6so3813439ybq.13;
        Thu, 21 Jan 2021 16:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0YT6DkGrqfNzRDHinbGmMwd+UI+97FY2H6+yORyunA=;
        b=LROqX8HRVfvUy9IoPwyCCKbS5vhipGSkhVxgDlceLZmbnuGdJakH2pTkvTUwt94d0J
         07L4Q6qfl/tD09amM4HSewHQgAtjPxUGk6B4cZwwEIzyKlrjTfq50kwIv6Yg9DP/7EcD
         HbQP1N4JOeMcuEt22x/BTRGm783E2GjaDnKNFQRJZXLKSUKmev0GCsb3neeqT1UvIV/V
         QwGAiK5T6AKqr/cKdsPWjLTci5jp6k++0HqJ7GWfBO+Zk2bHSI2TJUhTGf6nZAO3zFGY
         Ls5dfqYq4ZW8x8bOCwwqfgoj/Fz3kDW+MnBQzVIzS/l+cLXzYHA/PoBI2Q/ERKeauxws
         4g5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0YT6DkGrqfNzRDHinbGmMwd+UI+97FY2H6+yORyunA=;
        b=ogczGqa9wq1tGF6jhdl5og94VSUO5kwYr+zPnAHiLZ4YW+/n3snIelEAg7z2ZQT/YK
         9dPUkyt4n73+1d10nnUJfhqBohguSwP47KM0xj4hzoVVD3889LlP+Fvh1mTjT++RkRIn
         Pz3Ssr8nQeEe0QIsbL/XfuCjXvbfk6dvUga2dUAN74w2+85v7U5uuhrpx0If/93MaZga
         bGgitvkJ7FgfEpmpG2qJCMCDnHc7iNDUcHk3IBlz+GRrm11uVva1k3/6iGGx67szRNqg
         IO9ZwO+Bfa+rTFgmrZa/yPBKW+NYHvjrWr8MmDyXt3pC1JQzZFefvT+8gAhHLhKX6AH/
         PWVQ==
X-Gm-Message-State: AOAM5333O5pq0B5Gy1aOCHX32Ji1qlQycsi70WXyq1pEaKBOyLTQGXxW
        8E0x18GTxmyUjiZC+VfGvxJne/QL5R+2fBoEAcw=
X-Google-Smtp-Source: ABdhPJwn8vIsjq+qYvYLlxxYQdTA5iInBbf/JOay3aeVpQtXP2+hk1pULbNg7ue4VnMEWTJhVcM2dtaZ0ukGLbmZe20=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr2773922yba.260.1611275076764;
 Thu, 21 Jan 2021 16:24:36 -0800 (PST)
MIME-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com> <20210121012241.2109147-2-sdf@google.com>
 <CAEf4BzaOjBN=C=zjmhP-nLJbtm-FKBdpQbJmxtavn6r9VC3eiA@mail.gmail.com> <YAoXy0xcjhW8BftF@google.com>
In-Reply-To: <YAoXy0xcjhW8BftF@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 16:24:25 -0800
Message-ID: <CAEf4Bza6OeNMy9DH2Du8obSNfVFhg7wS1j9KgvR2ihOukEpNmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to port
 < 1024 from BPF works
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 4:09 PM <sdf@google.com> wrote:
>
> On 01/21, Andrii Nakryiko wrote:
> > On Wed, Jan 20, 2021 at 7:16 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > BPF rewrites from 111 to 111, but it still should mark the port as
> > > "changed".
> > > We also verify that if port isn't touched by BPF, it's still prohibited.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> > >  2 files changed, 124 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > new file mode 100644
> > > index 000000000000..840a04ac9042
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > @@ -0,0 +1,88 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <test_progs.h>
> > > +#include "bind_perm.skel.h"
> > > +
> > > +#include <sys/types.h>
> > > +#include <sys/socket.h>
> > > +#include <sys/capability.h>
> > > +
> > > +static int duration;
> > > +
> > > +void try_bind(int port, int expected_errno)
> > > +{
> > > +       struct sockaddr_in sin = {};
> > > +       int fd = -1;
> > > +
> > > +       fd = socket(AF_INET, SOCK_STREAM, 0);
> > > +       if (CHECK(fd < 0, "fd", "errno %d", errno))
> > > +               goto close_socket;
> > > +
> > > +       sin.sin_family = AF_INET;
> > > +       sin.sin_port = htons(port);
> > > +
> > > +       errno = 0;
> > > +       bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > > +       CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> > > +             errno, expected_errno);
>
> > ASSERT_NEQ() is nicer
> Nice, didn't know these existed. Now we need ASSERT_GT/LE/GE/LE to also
> get rid of those other CHECKs :-)

When I was adding the initial set of ASSERT_XXX() I didn't think we'll
need all those variants, but it turns out they come up pretty
frequently. So while you might be joking, I think it's a good idea to
add them and start using them consistently.

>
> > > +
> > > +close_socket:
> > > +       if (fd >= 0)
> > > +               close(fd);
> > > +}
> > > +
> > > +void cap_net_bind_service(cap_flag_value_t flag)
> > > +{
> > > +       const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > > +       cap_t caps;
> > > +
> > > +       caps = cap_get_proc();
> > > +       if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > > +               goto free_caps;
> > > +
> > > +       if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > &cap_net_bind_service,
> > > +                              CAP_CLEAR),
> > > +                 "cap_set_flag", "errno %d", errno))
> > > +               goto free_caps;
> > > +
> > > +       if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > &cap_net_bind_service,
> > > +                              CAP_CLEAR),
> > > +                 "cap_set_flag", "errno %d", errno))
> > > +               goto free_caps;
> > > +
> > > +       if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d",
> > errno))
> > > +               goto free_caps;
> > > +
> > > +free_caps:
> > > +       if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > > +               goto free_caps;
> > > +}
> > > +
> > > +void test_bind_perm(void)
> > > +{
> > > +       struct bind_perm *skel;
> > > +       int cgroup_fd;
> > > +
> > > +       cgroup_fd = test__join_cgroup("/bind_perm");
> > > +       if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > > +               return;
> > > +
> > > +       skel = bind_perm__open_and_load();
> > > +       if (CHECK(!skel, "skel-load", "errno %d", errno))
> > > +               goto close_cgroup_fd;
>
> > errno is irrelevant; also use ASSERT_PTR_OK() instead
> Ack, it might be worth unconditionally printing it in your ASSERT_XXX
> macros. Worst case - it's not used, but in general case avoids
> all this "errno %d" boilerplate.

Don't know about that, having unrelated errno everywhere is annoying
and misleading. I'd rather move away from relying on errno so much :)

>
> > > +
> > > +       skel->links.bind_v4_prog =
> > bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > > +       if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > > +                 "cg-attach", "bind4 %ld",
> > > +                 PTR_ERR(skel->links.bind_v4_prog)))
>
> > try using ASSERT_PTR_OK instead
> Sure, thanks!
