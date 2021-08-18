Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5386A3F0A79
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhHRRtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhHRRtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528AD610FE;
        Wed, 18 Aug 2021 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629308908;
        bh=zqcSN8ZGJ3s8loJMchk4AR8wKBbnZFyztg2k5c0/Osc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IhovrD4wgmaF314dMXzAmi4/DSDqlvgZsE+nVDMNaDI4NXPM3ekZnEikDfp1co8Ax
         IfDD3gNGVAA15MVXBV1yGI60iVTVq6FHppmk7IFFB8mXBnOw/RfBqLw1S3ncijhJet
         JemOhyM3h1i8/k4qF/RkCXU7VHSrs4B5Gl++CmB1f9c5CaEtxahow6ytyiTcr4rV0v
         FqTTFSrkQuGFkrLxPSna+duobnOXf5L47QbgtvezFLxV//vykyGZsTLt4xYQFvF+YP
         GcpZQTV0g6a+SOsw1VdLCLuezuubBE5KB98A5+S+i7MFp5WRK97PsNe78jZTaMyrbV
         tJLvYLp6E5r3A==
Received: by mail-lf1-f42.google.com with SMTP id t9so6341838lfc.6;
        Wed, 18 Aug 2021 10:48:28 -0700 (PDT)
X-Gm-Message-State: AOAM531lFnSTnFjh1qAmY2IWvnVl2DfLfmmonick8cRlLk/MIZ6lhqCn
        9wqoGATQw3rS+AOwI+UuhHWF6O3rBCuC7VtHwHo=
X-Google-Smtp-Source: ABdhPJzJ5z9zjxwGjwH8G46iwqR2FJHrzZt9Iwx23Ux3DbKP6t/DL6ge2Jjw2vnOIw+SKyMuVgaNMF+WcH+gjg8MxJ8=
X-Received: by 2002:ac2:44c3:: with SMTP id d3mr7198748lfm.281.1629308906675;
 Wed, 18 Aug 2021 10:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210818105820.91894-1-liuxu623@gmail.com> <20210818105820.91894-3-liuxu623@gmail.com>
In-Reply-To: <20210818105820.91894-3-liuxu623@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 18 Aug 2021 10:48:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7KmO0ErC3_KySMzag1bnbJAEAmXgOQS9jd8-scFai=tg@mail.gmail.com>
Message-ID: <CAPhsuW7KmO0ErC3_KySMzag1bnbJAEAmXgOQS9jd8-scFai=tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Test for get_netns_cookie
To:     Xu Liu <liuxu623@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 4:00 AM Xu Liu <liuxu623@gmail.com> wrote:
>
> Add test to use get_netns_cookie() from BPF_PROG_TYPE_SOCK_OPS.
>
> Signed-off-by: Xu Liu <liuxu623@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../selftests/bpf/prog_tests/netns_cookie.c   | 61 +++++++++++++++++++
>  .../selftests/bpf/progs/netns_cookie_prog.c   | 39 ++++++++++++
>  2 files changed, 100 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
>  create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/netns_cookie.c b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
> new file mode 100644
> index 000000000000..6f3cd472fb65
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include "netns_cookie_prog.skel.h"
> +#include "network_helpers.h"
> +
> +#ifndef SO_NETNS_COOKIE
> +#define SO_NETNS_COOKIE 71
> +#endif
> +
> +static int duration;
> +
> +void test_netns_cookie(void)
> +{
> +       int server_fd = 0, client_fd = 0, cgroup_fd = 0, err = 0, val = 0;
> +       struct netns_cookie_prog *skel;
> +       uint64_t cookie_expected_value;
> +       socklen_t vallen = sizeof(cookie_expected_value);
> +
> +       skel = netns_cookie_prog__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel_open"))
> +               return;
> +
> +       cgroup_fd = test__join_cgroup("/netns_cookie");
> +       if (CHECK(cgroup_fd < 0, "join_cgroup", "cgroup creation failed\n"))
> +               goto out;
> +
> +       skel->links.get_netns_cookie_sockops = bpf_program__attach_cgroup(
> +               skel->progs.get_netns_cookie_sockops, cgroup_fd);
> +       if (!ASSERT_OK_PTR(skel->links.get_netns_cookie_sockops, "prog_attach"))
> +               goto close_cgroup_fd;
> +
> +       server_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
> +       if (CHECK(server_fd < 0, "start_server", "errno %d\n", errno))
> +               goto close_cgroup_fd;
> +
> +       client_fd = connect_to_fd(server_fd, 0);
> +       if (CHECK(client_fd < 0, "connect_to_fd", "errno %d\n", errno))
> +               goto close_server_fd;
> +
> +       err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.netns_cookies),
> +                               &client_fd, &val);
> +       if (!ASSERT_OK(err, "map_lookup(socket_cookies)"))
> +               goto close_client_fd;
> +
> +       err = getsockopt(client_fd, SOL_SOCKET, SO_NETNS_COOKIE,
> +                               &cookie_expected_value, &vallen);
> +       if (!ASSERT_OK(err, "getsockopt)"))
> +               goto close_client_fd;
> +
> +       ASSERT_EQ(val, cookie_expected_value, "cookie_value");
> +
> +close_client_fd:
> +       close(client_fd);
> +close_server_fd:
> +       close(server_fd);
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +out:
> +       netns_cookie_prog__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/netns_cookie_prog.c b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
> new file mode 100644
> index 000000000000..4ed8d75aa299
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +
> +#define AF_INET6 10
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_SK_STORAGE);
> +       __uint(map_flags, BPF_F_NO_PREALLOC);
> +       __type(key, int);
> +       __type(value, int);
> +} netns_cookies SEC(".maps");
> +
> +SEC("sockops")
> +int get_netns_cookie_sockops(struct bpf_sock_ops *ctx)
> +{
> +       struct bpf_sock *sk = ctx->sk;
> +       int *cookie;
> +
> +       if (ctx->family != AF_INET6)
> +               return 1;
> +
> +       if (ctx->op != BPF_SOCK_OPS_TCP_CONNECT_CB)
> +               return 1;
> +
> +       if (!sk)
> +               return 1;
> +
> +       cookie = bpf_sk_storage_get(&netns_cookies, sk, 0,
> +                               BPF_SK_STORAGE_GET_F_CREATE);
> +       if (!cookie)
> +               return 1;
> +
> +       *cookie = bpf_get_netns_cookie(ctx);
> +
> +       return 1;
> +}
> --
> 2.28.0
>
