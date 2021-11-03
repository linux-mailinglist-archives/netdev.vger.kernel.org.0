Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8422144486C
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 19:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhKCSmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 14:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhKCSmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 14:42:07 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA50C061205;
        Wed,  3 Nov 2021 11:39:31 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e136so5391564ybc.4;
        Wed, 03 Nov 2021 11:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtBQxj50FdO8v/Q0TtDRDnyywac0YLAeKVXvSpTYK3c=;
        b=LL605NzBTkON5uknJc51rqMFlx4Y8vz3C4BE2xzvtJDfpw3vyd548KQy+HbDxdDKz2
         vXp9y5DpfBhrR0lh5LGKdPGhYvZj6Af4RI7FmDfKBWzBKWFo6k+/ND0xy2cQFRmgLjli
         HDn2tsH2FdKgClk/GPq/Pv4uW6kq6cuUPHMaM/TfdadweJzb9wZAmTL9nb77tUJVUicd
         3PXSYhLFe868XIUB1z90HvmN8UKKPST0F4zbIsHcilbNWlnYcrzKb7jT/V+5ZmvUFLFv
         Pj8xKzWxzh5jDXh+iW5MJ6al+iRPDZF0zbkVwmTXArF841Ack042zhtafnzgxp4WxOYj
         ckzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtBQxj50FdO8v/Q0TtDRDnyywac0YLAeKVXvSpTYK3c=;
        b=4Onkmiw9SghMo/rdKonaD4Mryy9QRi/nQXO4xyCPgpMa35ZAcXrlaStiyxTdi/FbYH
         sAV5524iW5TyAFO61QxbygjYN6iYHap7NBUnU2IZE5927v41ERzLKrFrl3rfJn0ZyAg8
         hoVRyGANyLL4YKRkyv9kZOrAa8lL7l1iWmKt1p03cvCzm3NMHoEd85IhRFe4KWGPW/bU
         0lV8ISnsYv7JxJaXaQoUuHfnkvMID+cicOiyIGGPfxPi+XXbcSCENvlQtMCCs++IYQaI
         G3PXHynh2z2QoaYyarJDuqmCCz6p0Kwfd1aLen4MWT551PjY/Kjva34bgnkRltWYKf7/
         +eYQ==
X-Gm-Message-State: AOAM531MHHwdPp+p+WTOREHrwCnv2KGtYgmuW/XdZoR9vwwg+K37RZrM
        gOMuzzANSewxHsAb9snbNAOxzw+H9u1wiH09TRU=
X-Google-Smtp-Source: ABdhPJzSrwTXuz/ZzMyarM+TFStSvxihSXmdU7/3x+bcss5lKvytkFLhQShChGWSF89WKLzsGHCcZDJFlypu7QIftps=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr46347135ybj.433.1635964770161;
 Wed, 03 Nov 2021 11:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com> <1635932969-13149-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1635932969-13149-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Nov 2021 11:39:18 -0700
Message-ID: <CAEf4BzadDy006mGCZac4kySX_re7eFe6VY0cHgkpY3fQNRuASg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add exception handling
 selftests for tp_bpf program
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ardb@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, Mark Rutland <mark.rutland@arm.com>,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        Tian Tao <tiantao6@hisilicon.com>, pcc@google.com,
        Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org,
        Jisheng.Zhang@synaptics.com, liu.hailong6@zte.com.cn,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 2:50 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Exception handling is triggered in BPF tracing programs when
> a NULL pointer is dereferenced; the exception handler zeroes the
> target register and execution of the BPF program progresses.
>
> To test exception handling then, we need to trigger a NULL pointer
> dereference for a field which should never be zero; if it is, the
> only explanation is the exception handler ran.  The skb->sk is
> the NULL pointer chosen (for a ping received for 127.0.0.1 there
> is no associated socket), and the sk_sndbuf size is chosen as the
> "should never be 0" field.  Test verifies sk is NULL and sk_sndbuf
> is zero.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/exhandler.c | 45 ++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/exhandler_kern.c | 35 +++++++++++++++++
>  2 files changed, 80 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
>  create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/exhandler.c b/tools/testing/selftests/bpf/prog_tests/exhandler.c
> new file mode 100644
> index 0000000..5999498
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/exhandler.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021, Oracle and/or its affiliates. */
> +
> +#include <test_progs.h>
> +
> +/* Test that verifies exception handling is working; ping to localhost
> + * will result in a receive with a NULL skb->sk; our BPF program
> + * then dereferences the an sk field which shouldn't be 0, and if we
> + * see 0 we can conclude the exception handler ran when we attempted to
> + * dereference the NULL sk and zeroed the destination register.
> + */
> +#include "exhandler_kern.skel.h"
> +
> +#define SYSTEM(...)    \
> +       (env.verbosity >= VERBOSE_VERY ?        \
> +        system(__VA_ARGS__) : system(__VA_ARGS__ " >/dev/null 2>&1"))
> +
> +void test_exhandler(void)
> +{
> +       struct exhandler_kern *skel;
> +       struct exhandler_kern__bss *bss;
> +       int err = 0, duration = 0;
> +
> +       skel = exhandler_kern__open_and_load();
> +       if (CHECK(!skel, "skel_load", "skeleton failed: %d\n", err))
> +               goto cleanup;
> +
> +       bss = skel->bss;

nit: you don't need to have a separate variable for that,
skel->bss->exception_triggered in below check would be just as
readable

> +
> +       err = exhandler_kern__attach(skel);
> +       if (CHECK(err, "attach", "attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       if (CHECK(SYSTEM("ping -c 1 127.0.0.1"),

Is there some other tracepoint or kernel function that could be used
for testing and triggered without shelling out to ping binary? This
hurts test isolation and will make it or some other ping-using
selftests spuriously fail when running in parallel test mode (i.e.,
sudo ./test_progs -j).

> +                 "ping localhost",
> +                 "ping localhost failed\n"))
> +               goto cleanup;
> +
> +       if (CHECK(bss->exception_triggered == 0,

please use ASSERT_EQ() instead, CHECK()s are kind of deprecated for new tests


> +                 "verify exceptions were triggered",
> +                 "no exceptions were triggered\n"))
> +               goto cleanup;
> +cleanup:
> +       exhandler_kern__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/exhandler_kern.c b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> new file mode 100644
> index 0000000..4049450
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021, Oracle and/or its affiliates. */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_core_read.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +unsigned int exception_triggered;
> +
> +/* TRACE_EVENT(netif_rx,
> + *         TP_PROTO(struct sk_buff *skb),
> + */
> +SEC("tp_btf/netif_rx")
> +int BPF_PROG(trace_netif_rx, struct sk_buff *skb)
> +{
> +       struct sock *sk;
> +       int sndbuf;
> +
> +       /* To verify we hit an exception we dereference skb->sk->sk_sndbuf;
> +        * sndbuf size should never be zero, so if it is we know the exception
> +        * handler triggered and zeroed the destination register.
> +        */
> +       __builtin_preserve_access_index(({
> +               sk = skb->sk;
> +               sndbuf = sk->sk_sndbuf;
> +       }));

you don't need __builtin_preserve_access_index(({ }) region, because
vmlinux.h already annotates all the types with preserve_access_index
attribute

> +
> +       if (!sk && !sndbuf)
> +               exception_triggered++;
> +       return 0;
> +}
> --
> 1.8.3.1
>
