Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C003E300FD4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbhAVWTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730699AbhAVT5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:57:20 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC24C061786
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 11:56:40 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id z9so5050509qtv.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 11:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4oodxvb/hMLNJzxf41cPddDUWt6mW9u6xY7s/Ue4snk=;
        b=MTSgiakwX/Anmz2LEjSHqiVfrwIkKhsC9ZXOU+lIN+PlcVNRYADptSQeNUkBRE2iev
         IA6pRwFHDn2eSeNajGWoL7t7CaBVsX+VoClgzv+lUj7I5phZLx1FLcJXMn3mW8KF0zwG
         82nuCZbCniWLWjmDNtiZClAxvOrP6ppH12dg6dE1dZaWVP1mYaDhvlyH2So35e1BW832
         SuRPmzoTcJg6kdZUDUVwnL+0jYqPPYeRDxnqm5GWUwkRwghXFEZsq9ehn9r+K+Y/3gm8
         XD6OVtqTV/7DNUZB/Gvp/mxCE3qg3SOXOrU89CRnukEgapU0z+MEwiytRYngnOcWWDjA
         /okQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4oodxvb/hMLNJzxf41cPddDUWt6mW9u6xY7s/Ue4snk=;
        b=pknYhHaAs1vbbpwJiXTyTuciZBmz1JBOHI6MZ54r9Pf0SOnc7b/QfSrZJ6ACiA35Pg
         LN0avvQFtHEO+C6E8tskfr1DzkqZmFzYmpECfTnesBohtA3S3Nf/JYKAjfKNHzKyxe7N
         d9h1tLV6Df8goornPDtzCuRsmMOiEdg2i2oWfglg/eVu2UEqtkmCjiJttKnGyGaM3ZDj
         /pCuarQjFVG4+MQ8U7RBD/2XV1FoUF8A3axb9plWDySU/3Pn8KV2+7bXKYA/cxXDD8mj
         JSCIrbDrQFq5r3c0WGq8mPuj/ZnBdPJUnxGljMoHnnMGUGh74FoMKwNZSQJPPwRJnhmM
         9mxQ==
X-Gm-Message-State: AOAM533bboYa2KNFFVZjBy1QvVanpcDv3x9n/WE5rQcShlMrtupJ+zv3
        /XsFuFWvPlMzuIWumU//8+Py1GEv56vDUBUxY1nl6auyPp4=
X-Google-Smtp-Source: ABdhPJwyznaQkeRwWODoNVLLjr00rsZAv4QcLjsYcsWTWEzNYIXowaby03GkQlZZXNpDUm7lW32nUb3nofKu7uck2CM=
X-Received: by 2002:ac8:7a82:: with SMTP id x2mr5973906qtr.20.1611345399602;
 Fri, 22 Jan 2021 11:56:39 -0800 (PST)
MIME-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com> <20210121012241.2109147-2-sdf@google.com>
 <20210121223330.pyk4ljtjirm2zlay@kafai-mbp> <YAoG6K37QtRZGJGy@google.com>
 <20210121235007.vmq24fjyesrvjkqm@kafai-mbp> <YAockJDIOt3jTqd2@google.com>
 <20210122012751.ur4oxeprccefbbyl@kafai-mbp> <YAr6aFwYXgbtFcO6@google.com> <20210122193804.i2a73pgmkyjqwp3x@kafai-mbp>
In-Reply-To: <20210122193804.i2a73pgmkyjqwp3x@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 22 Jan 2021 11:56:28 -0800
Message-ID: <CAKH8qBsxTcyOPGtZozPbeN9gdZLZGxi6UnBvR4BD1qncojKqwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to port
 < 1024 from BPF works
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 11:38 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jan 22, 2021 at 08:16:40AM -0800, sdf@google.com wrote:
> > On 01/21, Martin KaFai Lau wrote:
> > > On Thu, Jan 21, 2021 at 04:30:08PM -0800, sdf@google.com wrote:
> > > > On 01/21, Martin KaFai Lau wrote:
> > > > > On Thu, Jan 21, 2021 at 02:57:44PM -0800, sdf@google.com wrote:
> > > > > > On 01/21, Martin KaFai Lau wrote:
> > > > > > > On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev
> > > wrote:
> > > > > > > > BPF rewrites from 111 to 111, but it still should mark the
> > > port as
> > > > > > > > "changed".
> > > > > > > > We also verify that if port isn't touched by BPF, it's still
> > > > > prohibited.
> > > > > > > >
> > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > ---
> > > > > > > >  .../selftests/bpf/prog_tests/bind_perm.c      | 88
> > > > > +++++++++++++++++++
> > > > > > > >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> > > > > > > >  2 files changed, 124 insertions(+)
> > > > > > > >  create mode 100644
> > > > > tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > >  create mode 100644
> > > tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > >
> > > > > > > > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > > new file mode 100644
> > > > > > > > index 000000000000..840a04ac9042
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > > > > > > > @@ -0,0 +1,88 @@
> > > > > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > > > > +#include <test_progs.h>
> > > > > > > > +#include "bind_perm.skel.h"
> > > > > > > > +
> > > > > > > > +#include <sys/types.h>
> > > > > > > > +#include <sys/socket.h>
> > > > > > > > +#include <sys/capability.h>
> > > > > > > > +
> > > > > > > > +static int duration;
> > > > > > > > +
> > > > > > > > +void try_bind(int port, int expected_errno)
> > > > > > > > +{
> > > > > > > > + struct sockaddr_in sin = {};
> > > > > > > > + int fd = -1;
> > > > > > > > +
> > > > > > > > + fd = socket(AF_INET, SOCK_STREAM, 0);
> > > > > > > > + if (CHECK(fd < 0, "fd", "errno %d", errno))
> > > > > > > > +         goto close_socket;
> > > > > > > > +
> > > > > > > > + sin.sin_family = AF_INET;
> > > > > > > > + sin.sin_port = htons(port);
> > > > > > > > +
> > > > > > > > + errno = 0;
> > > > > > > > + bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > > > > > > > + CHECK(errno != expected_errno, "bind", "errno %d, expected
> > > %d",
> > > > > > > > +       errno, expected_errno);
> > > > > > > > +
> > > > > > > > +close_socket:
> > > > > > > > + if (fd >= 0)
> > > > > > > > +         close(fd);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +void cap_net_bind_service(cap_flag_value_t flag)
> > > > > > > > +{
> > > > > > > > + const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > > > > > > > + cap_t caps;
> > > > > > > > +
> > > > > > > > + caps = cap_get_proc();
> > > > > > > > + if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > > > > > > > +         goto free_caps;
> > > > > > > > +
> > > > > > > > + if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > > > > &cap_net_bind_service,
> > > > > > > > +                        CAP_CLEAR),
> > > > > > > > +           "cap_set_flag", "errno %d", errno))
> > > > > > > > +         goto free_caps;
> > > > > > > > +
> > > > > > > > + if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1,
> > > > > &cap_net_bind_service,
> > > > > > > > +                        CAP_CLEAR),
> > > > > > > > +           "cap_set_flag", "errno %d", errno))
> > > > > > > > +         goto free_caps;
> > > > > > > > +
> > > > > > > > + if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d",
> > > errno))
> > > > > > > > +         goto free_caps;
> > > > > > > > +
> > > > > > > > +free_caps:
> > > > > > > > + if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > > > > > > > +         goto free_caps;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +void test_bind_perm(void)
> > > > > > > > +{
> > > > > > > > + struct bind_perm *skel;
> > > > > > > > + int cgroup_fd;
> > > > > > > > +
> > > > > > > > + cgroup_fd = test__join_cgroup("/bind_perm");
> > > > > > > > + if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > > > > > > > +         return;
> > > > > > > > +
> > > > > > > > + skel = bind_perm__open_and_load();
> > > > > > > > + if (CHECK(!skel, "skel-load", "errno %d", errno))
> > > > > > > > +         goto close_cgroup_fd;
> > > > > > > > +
> > > > > > > > + skel->links.bind_v4_prog =
> > > > > > > bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > > > > > > > + if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > > > > > > > +           "cg-attach", "bind4 %ld",
> > > > > > > > +           PTR_ERR(skel->links.bind_v4_prog)))
> > > > > > > > +         goto close_skeleton;
> > > > > > > > +
> > > > > > > > + cap_net_bind_service(CAP_CLEAR);
> > > > > > > > + try_bind(110, EACCES);
> > > > > > > > + try_bind(111, 0);
> > > > > > > > + cap_net_bind_service(CAP_SET);
> > > > > > > > +
> > > > > > > > +close_skeleton:
> > > > > > > > + bind_perm__destroy(skel);
> > > > > > > > +close_cgroup_fd:
> > > > > > > > + close(cgroup_fd);
> > > > > > > > +}
> > > > > > > > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > > new file mode 100644
> > > > > > > > index 000000000000..2194587ec806
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > > > > > > > @@ -0,0 +1,36 @@
> > > > > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > > > > +
> > > > > > > > +#include <linux/stddef.h>
> > > > > > > > +#include <linux/bpf.h>
> > > > > > > > +#include <sys/types.h>
> > > > > > > > +#include <sys/socket.h>
> > > > > > > > +#include <bpf/bpf_helpers.h>
> > > > > > > > +#include <bpf/bpf_endian.h>
> > > > > > > > +
> > > > > > > > +SEC("cgroup/bind4")
> > > > > > > > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > > > > > > > +{
> > > > > > > > + struct bpf_sock *sk;
> > > > > > > > + __u32 user_ip4;
> > > > > > > > + __u16 user_port;
> > > > > > > > +
> > > > > > > > + sk = ctx->sk;
> > > > > > > > + if (!sk)
> > > > > > > > +         return 0;
> > > > > > > > +
> > > > > > > > + if (sk->family != AF_INET)
> > > > > > > > +         return 0;
> > > > > > > > +
> > > > > > > > + if (ctx->type != SOCK_STREAM)
> > > > > > > > +         return 0;
> > > > > > > > +
> > > > > > > > + /* Rewriting to the same value should still cause
> > > > > > > > +  * permission check to be bypassed.
> > > > > > > > +  */
> > > > > > > > + if (ctx->user_port == bpf_htons(111))
> > > > > > > > +         ctx->user_port = bpf_htons(111);
> > > > > > > iiuc, this overwrite is essentially the way to ensure the bind
> > > > > > > will succeed (override CAP_NET_BIND_SERVICE in this particular
> > > case?).
> > > > > > Correct. The alternative might be to export ignore_perm_check
> > > > > > via bpf_sock_addr and make it explicit.
> > > > > An explicit field is one option.
> > > >
> > > > > or a different return value (e.g.
> > > BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY).
> > > >
> > > > > Not sure which one (including the one in the current patch) is better
> > > > > at this point.
> > > > Same. My reasoning was: if the BPF program rewrites the port, it knows
> > > > what it's doing, so it doesn't seem like adding another explicit
> > > > signal makes sense. So I decided to go without external api change.
> > > >
> > > > > Also, from patch 1, if one cgrp bpf prog says no-perm-check,
> > > > > it does not matter what the latter cgrp bpf progs have to say?
> > > > Right, it doesn't matter. But I think it's fine: if the latter
> > > > one rewrites the (previously rewritten) address to something
> > > > new, it still wants that address to be bound to, right?
> > > >
> > > > If some program returns EPERM, it also doesn't matter.
> > > >
> > > > > > > It seems to be okay if we consider most of the use cases is
> > > rewriting
> > > > > > > to a different port.
> > > > > >
> > > > > > > However, it is quite un-intuitive to the bpf prog to overwrite
> > > with
> > > > > > > the same user_port just to ensure this port can be binded
> > > successfully
> > > > > > > later.
> > > > > > I'm testing a corner case here when the address is rewritten to
> > > the same
> > > > > > value, but the intention is to rewrite X to Y < 1024.
> > > > > It is a legit corner case though.
> > > >
> > > > > Also, is it possible that the compiler may optimize this
> > > > > same-value-assignment out?
> > > > Yeah, it's a legit case, that's why I tested it. Good point on
> > > > optimizing (can be "healed" with volatile?),
> > > hmm... It is too fragile.
> >
> > > > but it should only matter if
> > > > the program is installed to bypass the permission checks for some ports
> > > > (as it does in this selftest). As you mention below, it's not clear
> > > what's
> > > > the 'default' use-case is. Is it rewriting to a different port or just
> > > > bypassing the cap_net_bind_service for some ports? Feels like rewriting
> > > > to a different address/port was the reason the hooks were added,
> > > > so I was targeting this one.
> > > It sounds like having a bpf to bypass permission only without changing
> > > the port is not the target but more like a by-product of this change.
> > Right, we might have a use-case for that as well, but it's not
> > strictly required. We can convert it to be something like
> > 'rewrite this magic addr+port to this real addr+port'.
> >
> > > How about only bypass cap_net_bind_service when bpf did change the
> > > address/port.  Will it become too slow for bind?
> > But this is what I'm doing already, isn't it? There is just a by-product
> > of triggering it for the same port = port address.
> My concern is the way to trigger this legit by-product is too fragile (and
> unintuitive) to be usable.  Either avoid this by-product completely or
> have a better way to specify the need of bypass.
>
> Lets say we do the latter.  After more thoughts, I think doing it in the
> return value is more natural since it is already saying the port/addr
> should be EPERM or not.  It makes sense to add BYPASS or not to the
> return value.  When one bpf prog says bypass, then it will bypass.
> The second bit of the return value can be used to do that.
> Thoughts?
This sounds like a workable solution as well. It's more explicit, but
it's more clear for the 'bypass' case, I agree.
Let me try to implement it and see whether I hit some problem.

> > Tracking the real change will require extra space to keep the original
> > address and then memcmp to figure out if the change was made.
> > Assuming the majority of rewrites don't happen for <1024 ports
> > this seems like a bunch of wasted work (vs setting that ctx->port_changed).
> Right, so the earlier question about if other fields will need
> similar bypass.  If it is only port, it is pretty cheap to do.
> However, it seems other fields will eventually need this in the
> future if not now.
At least user_ip4/user_ip6 should trigger that as well, I agree.

> The check "if (old != new)" itself may be doable within
> convert_ctx_access() itself which at least helping on the space side.
> However, I think the return value is an easier and cleaner way.
