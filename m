Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6042026AE0E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgIOTuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgIORKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:10:50 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABBAC061353
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 09:36:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so4737483iof.11
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTYtDNRWZ3IQd17IVwiFvjdPJC2m5bl5cpimFc01bsE=;
        b=dd8bL7ebVaZyzMDfsYKo20tvtiuZtcDmrHxwpMH6xunQdc01MjGuk18V+0XPn8WHrl
         Fis6Uo8ZkZSeYMw/H78zlSzVvrGy4lwsCvjqkxiT5CkoD8OYqyA+IbeH5o+YrirpA6r0
         K8iLbnom0h1MLtbmdJo3GIQKZLGp8PT7JlepSGsUyzIZ6zgUM0WQ7PA3XVS8h2Jhq2pJ
         kzHaBtpJJTkGGvgCKfbE1evnoBXp1Dad1Boq4Vl9c9ekuQvXK4qX4JS1c1w7QWEIZ0q7
         lhbLIxyyUMt0OvM1lYg8LZlT0B+Pe0m3kwJXdmKVS7TF7Hciljn7WW/NJvTrGqu6jynF
         Td1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTYtDNRWZ3IQd17IVwiFvjdPJC2m5bl5cpimFc01bsE=;
        b=GLbaN/pB3hFdtR4xZEIUtxbEINobF3MW4rAMby2OdyrOpMjET2I8pwhwGZjWInfjzK
         dXkkYPkPX0avSjKFvWtHro9U54m0v78owbu36IvzORFbvGivcb2+KvMuNsKGFJddMlvW
         TymAd+RxScmebws0zR4BIl9oFGJrVTKlCUg8apQsfySWudNaNOJ5/J6m0/KyGDlMRtui
         SsAcfKV+X71UX7kV3R/FFT+92EENkxQLWy2om9ia8aB7ozQtTTPhEe44nVJ+UO96z4iX
         Nt9uw+esOOU+ddVpExA7x3gg7EIY1tWQP2YsxXhTvayY5wlhw/qyTai7cKdO6d7Thdip
         JgFA==
X-Gm-Message-State: AOAM533S1YUF+OR4+A9oILyCmMF/1NsV2Q1DChtnmss2Pay4xBEaIGG6
        xoYq4naclMYil/fDzO9OykqCVmW0/4gXH98aME/xSw==
X-Google-Smtp-Source: ABdhPJxfSpUADTY11rW/0vm2ayF8vH2q7+GTpuu5qgBeHOpVJABcAhpG1Zc/csWA4GJs7zkMIHdIbQ5efNp5B3lCemM=
X-Received: by 2002:a05:6638:1643:: with SMTP id a3mr18483174jat.4.1600187770959;
 Tue, 15 Sep 2020 09:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
 <20200911143022.414783-4-nicolas.rybowski@tessares.net> <CAPhsuW5Gbx2pWgM1XcSYqVsN6L=q+0u3QFNxG7A+Qez=Tziu2A@mail.gmail.com>
In-Reply-To: <CAPhsuW5Gbx2pWgM1XcSYqVsN6L=q+0u3QFNxG7A+Qez=Tziu2A@mail.gmail.com>
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
Date:   Tue, 15 Sep 2020 18:35:59 +0200
Message-ID: <CACXrtpRzZuCyZnduYcV+1d2Z3qTK2b7Mcj2gQvcRbnv7+k0VRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: selftests: add MPTCP test base
To:     Song Liu <song@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

Thanks for the feedback !

On Mon, Sep 14, 2020 at 8:07 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Sep 11, 2020 at 8:02 AM Nicolas Rybowski
> <nicolas.rybowski@tessares.net> wrote:
> >
> > This patch adds a base for MPTCP specific tests.
> >
> > It is currently limited to the is_mptcp field in case of plain TCP
> > connection because for the moment there is no easy way to get the subflow
> > sk from a msk in userspace. This implies that we cannot lookup the
> > sk_storage attached to the subflow sk in the sockops program.
> >
> > Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With some nitpicks below.
>
> > ---
> >
> > Notes:
> >     v1 -> v2:
> >     - new patch: mandatory selftests (Alexei)
> >
> [...]
> >                      int timeout_ms);
> > diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> > new file mode 100644
> > index 000000000000..0e65d64868e9
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> > @@ -0,0 +1,119 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "cgroup_helpers.h"
> > +#include "network_helpers.h"
> > +
> > +struct mptcp_storage {
> > +       __u32 invoked;
> > +       __u32 is_mptcp;
> > +};
> > +
> > +static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
> > +{
> > +       int err = 0, cfd = client_fd;
> > +       struct mptcp_storage val;
> > +
> > +       /* Currently there is no easy way to get back the subflow sk from the MPTCP
> > +        * sk, thus we cannot access here the sk_storage associated to the subflow
> > +        * sk. Also, there is no sk_storage associated with the MPTCP sk since it
> > +        * does not trigger sockops events.
> > +        * We silently pass this situation at the moment.
> > +        */
> > +       if (is_mptcp == 1)
> > +               return 0;
> > +
> > +       if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
> > +               perror("Failed to read socket storage");
>
> Maybe simplify this with CHECK(), which contains a customized error message?
> Same for some other calls.
>

The whole logic here is strongly inspired from prog_tests/tcp_rtt.c
where CHECK_FAIL is used.
Also the CHECK macro will print a PASS message on successful map
lookup, which is not expected at this point of the tests.
I think it would be more interesting to leave it as it is to keep a
cohesion between TCP and MPTCP selftests. What do you think?

If there are no objections, I will send a v3 with the other requested
changes and a rebase on the latest bpf-next.

> > +               return -1;
> > +       }
> > +
> > +       if (val.invoked != 1) {
> > +               log_err("%s: unexpected invoked count %d != %d",
> > +                       msg, val.invoked, 1);
> > +               err++;
> > +       }
> > +
> > +       if (val.is_mptcp != is_mptcp) {
> > +               log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != %d",
> > +                       msg, val.is_mptcp, is_mptcp);
> > +               err++;
> > +       }
> > +
> > +       return err;
> > +}
> > +
> > +static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
> [...]
>
> > +
> > +       client_fd = is_mptcp ? connect_to_mptcp_fd(server_fd, 0) :
> > +                              connect_to_fd(server_fd, 0);
> > +       if (client_fd < 0) {
> > +               err = -1;
> > +               goto close_client_fd;
>
> This should be "goto close_bpf_object;", and we don't really need the label
> close_client_fd.
>
> > +       }
> > +
> > +       err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
>
> It doesn't really change the logic, but I guess we only need "err = xxx"?
>
> > +                         verify_sk(map_fd, client_fd, "plain TCP socket", 0);
> > +
> > +close_client_fd:
> > +       close(client_fd);
> > +
> > +close_bpf_object:
> > +       bpf_object__close(obj);
> > +       return err;
> > +}
> > +
