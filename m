Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F129303059
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbhAYXjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732242AbhAYXij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:38:39 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCDFC061793
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 15:37:45 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id h21so7068475qvb.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 15:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQCUN625VAgpGUPUXKsLzb9sl6V+DmdN8TP1oPnRPiM=;
        b=QuIOe7Uty7UBgeM3KwR6M0kBnNb168EYXOal4GAsZu5s+o6XWG3KM2umTQR50IKoFx
         VFEVeTkbcbL779I57zZbr+swDovwha3emwdbIhRfEByIEqDGggGcnYTcpdcFh82V3sq9
         KE9jRJTedaLl0HGBp1D1L9GSqOm060FojWjkJevtjFRJXHI3CE354Q1B4oBSyxzVSuwC
         JOaq3UNdKcJMK4W8sECH1G1jL8t1EOLjggDnDySB7F1muQ1zbVXN91B77JbV7LsWohSp
         bhN3CxlhzhGjklJyjFDnnJrw8h+5KadfVGFs6brfVjzjbfqObv7FFCtwcvFBCmiHPk7y
         DPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQCUN625VAgpGUPUXKsLzb9sl6V+DmdN8TP1oPnRPiM=;
        b=GaBgiQn3abtqabtYSrWs96jJDEjFGZUmPSN6YBDCjLjD6k7fsA35xf4t1ynFEqdQrE
         t0pnsNX1bh3u/fC9fv1NeELZRaXuKeuKFEsBkBIkkMFLnd9wlHYAuMQcHmmIE0IQPN53
         ZPEiL+mT9N0hUKVZukwWa4THcw7jbR7YUto4nmQPqN+q7Pi+KK0ZJQPLUzUYsCnTzh2B
         uQHtqfZmJXSCWV1eP/iX8F/kzACd15Oxt/tpp0jSpLyzD2/xn4/YbWcDqt9dFgkW/+4s
         9WBdEb6lZvIyLBoy9a16f7oNdOpe0ZzhWNn8GPlRsHBMljMybq0bzmwQfL0Y0dogYR7g
         IMtQ==
X-Gm-Message-State: AOAM532kWl/XXKz17FtUJLzKSzuAmDOjE+BSdHjOOFQThHRT01Q9WVH3
        3rqTcucG59KOdsnaMQO280PGKbsllNLocPESuAD/iw==
X-Google-Smtp-Source: ABdhPJxcyBLLRSQVFwQ2Vionp60H5PIjYkov5j44oew/iGDuiGR6Ix0Q7Bi/M6YJIK3D4ZOm6ipXqNMvdVC0u0MeOvs=
X-Received: by 2002:ad4:486e:: with SMTP id u14mr3178530qvy.21.1611617864845;
 Mon, 25 Jan 2021 15:37:44 -0800 (PST)
MIME-Version: 1.0
References: <20210125172641.3008234-1-sdf@google.com> <20210125172641.3008234-2-sdf@google.com>
 <20210125232949.46r26lcc3wyieoaj@kafai-mbp>
In-Reply-To: <20210125232949.46r26lcc3wyieoaj@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 25 Jan 2021 15:37:34 -0800
Message-ID: <CAKH8qBuQ8icMgxiozme=HgXcE5Tm937PwNMjFAn0tSAUcMDaYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 3:30 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Jan 25, 2021 at 09:26:41AM -0800, Stanislav Fomichev wrote:
> > BPF rewrites from 111 to 111, but it still should mark the port as
> > "changed".
> > We also verify that if port isn't touched by BPF, it's still prohibited.
> The description requires an update.
Good point, will update this one and the comment!

> >
> > Cc: Andrey Ignatov <rdna@fb.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/bind_perm.c      | 85 +++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> >  2 files changed, 121 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > new file mode 100644
> > index 000000000000..61307d4494bf
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > @@ -0,0 +1,85 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "bind_perm.skel.h"
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <sys/capability.h>
> > +
> > +static int duration;
> > +
> > +void try_bind(int port, int expected_errno)
> > +{
> > +     struct sockaddr_in sin = {};
> > +     int fd = -1;
> > +
> > +     fd = socket(AF_INET, SOCK_STREAM, 0);
> > +     if (CHECK(fd < 0, "fd", "errno %d", errno))
> > +             goto close_socket;
> > +
> > +     sin.sin_family = AF_INET;
> > +     sin.sin_port = htons(port);
> > +
> > +     errno = 0;
> > +     bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > +     ASSERT_EQ(errno, expected_errno, "bind");
> > +
> > +close_socket:
> > +     if (fd >= 0)
> > +             close(fd);
> > +}
> > +
> > +void cap_net_bind_service(cap_flag_value_t flag)
> > +{
> > +     const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > +     cap_t caps;
> > +
> > +     caps = cap_get_proc();
> > +     if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +     if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > +                            CAP_CLEAR),
> > +               "cap_set_flag", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +     if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > +                            CAP_CLEAR),
> > +               "cap_set_flag", "errno %d", errno))
> These two back-to-back cap_set_flag() looks incorrect.
> Also, the "cap_flag_value_t flag" is unused.
Ah, true, I never reset back CAP_NET_BIND_SERVICE, will fix, thanks!

> > +             goto free_caps;
> > +
> > +     if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> > +             goto free_caps;
> > +
> > +free_caps:
> > +     if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > +             goto free_caps;
> There is a loop.
>
> > +}
> > +
> > +void test_bind_perm(void)
> > +{
> > +     struct bind_perm *skel;
> > +     int cgroup_fd;
> > +
> > +     cgroup_fd = test__join_cgroup("/bind_perm");
> > +     if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > +             return;
> > +
> > +     skel = bind_perm__open_and_load();
> > +     if (!ASSERT_OK_PTR(skel, "skel"))
> > +             goto close_cgroup_fd;
> > +
> > +     skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(skel, "bind_v4_prog"))
> > +             goto close_skeleton;
> > +
> > +     cap_net_bind_service(CAP_CLEAR);
> > +     try_bind(110, EACCES);
> > +     try_bind(111, 0);
> > +     cap_net_bind_service(CAP_SET);
> > +
> > +close_skeleton:
> > +     bind_perm__destroy(skel);
> > +close_cgroup_fd:
> > +     close(cgroup_fd);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c b/tools/testing/selftests/bpf/progs/bind_perm.c
> > new file mode 100644
> > index 000000000000..31ae8d599796
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > @@ -0,0 +1,36 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/stddef.h>
> > +#include <linux/bpf.h>
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +
> > +SEC("cgroup/bind4")
> > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > +{
> > +     struct bpf_sock *sk;
> > +     __u32 user_ip4;
> > +     __u16 user_port;
> > +
> > +     sk = ctx->sk;
> > +     if (!sk)
> > +             return 0;
> > +
> > +     if (sk->family != AF_INET)
> > +             return 0;
> > +
> > +     if (ctx->type != SOCK_STREAM)
> > +             return 0;
> > +
> > +     /* Rewriting to the same value should still cause
> > +      * permission check to be bypassed.
> > +      */
> This comment is out dated also.
>
> > +     if (ctx->user_port == bpf_htons(111))
> > +             return 3;
> > +
> > +     return 1;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > --
> > 2.30.0.280.ga3ce27912f-goog
> >
