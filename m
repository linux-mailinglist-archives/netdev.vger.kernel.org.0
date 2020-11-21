Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2282BBDDF
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 08:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgKUHlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 02:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgKUHlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 02:41:22 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3402C0613CF;
        Fri, 20 Nov 2020 23:41:22 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id g15so10832457ybq.6;
        Fri, 20 Nov 2020 23:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDqv5+Tpr3FjAa+NDsoyI1zIWHGb/nwESPI3fQQNXik=;
        b=txZHbw07aDxDJRwfLqtjJ/YhoWHtW7dg7l4uVBYhi88qrq2/ZJs2MKpEAmA8sVLsnn
         7wNy5g55vy2Yo/G5nMpoCc9SJrQOnyDfEWY/MoMx03quCB3YrCpDGURP2B2UTcgxZHgH
         XO/A1mSeeZ5i20LZX6OU97wml0nILJPW0f9ma+TKXsNQL10r1bmsRmXpzhuMpdwlaJsJ
         L1AzlP245rKLz/RoKbH7cB9aB5BRbNmvWlbx71FZn2tzEziiB2nzZ0htZXFP4j1mzz+e
         LkMeiUBgtwU8WRPNl7eaWkbmS+OZRn6BJPXVKw72uCdnhWaBnYUZy2yFdzXXMmPX2EGB
         qhZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDqv5+Tpr3FjAa+NDsoyI1zIWHGb/nwESPI3fQQNXik=;
        b=bEc44taWH4RwVDnZSwc39dGRjzstv3UQcQc2Vy1XGoFuy2oaadT5SeYcxZ5nKyTDCY
         ujgfYvphadjExCKksDLStMyNM+92WQVvveOj55RTPLqdAXaK4Y8aEjA21wcFEU43Vhs3
         YyBLH/AdhJG9YK8aKWK31WpDuiY/kS8ToV7KJGQAzZ9CE49tporT8we2m43PZEqAM2gf
         lqA5BFcIcLMpW4pCpMJtpLinBwHyNSbKnzYkCa+be7KM9aBWYvE6Y7UmKp3h/oT8rgat
         EWk6sqDIz3a5/HcAuce275lsS96s4wXBs/kbKKKHTGfvG3ET1zrFVkd68LfkcC/uSW5w
         hYfw==
X-Gm-Message-State: AOAM5301XlMpnBMhxXz2lEjljOkaeVOuNeaJhIBqGnQoJq6tUU4mgNXu
        vLF4azXGH39m7kbE31A6+cTK+KybmQnWdhTsN18=
X-Google-Smtp-Source: ABdhPJz4UfOM1lUEZlmJBLmFEj5ubY2YwYKmRP+s9MU4x5EznXPClvwUW01x3EeYHqKC+ycfptnrxTJp/QY+G+oo/oo=
X-Received: by 2002:a25:2845:: with SMTP id o66mr32528179ybo.260.1605944481979;
 Fri, 20 Nov 2020 23:41:21 -0800 (PST)
MIME-Version: 1.0
References: <160588903254.2817268.4861837335793475314.stgit@firesoul> <160588912738.2817268.9380466634324530673.stgit@firesoul>
In-Reply-To: <160588912738.2817268.9380466634324530673.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Nov 2020 23:41:11 -0800
Message-ID: <CAEf4BzbfqvCiHDaZk3yQCPfzwpGJ-35XBw3qaGuPNYkfBHR2Kw@mail.gmail.com>
Subject: Re: [PATCH bpf-next V7 8/8] bpf/selftests: activating bpf_check_mtu BPF-helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 8:21 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |   37 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |   33 ++++++++++++++++++
>  2 files changed, 70 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> new file mode 100644
> index 000000000000..09b8f986a17b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Red Hat */
> +#include <uapi/linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <test_progs.h>
> +
> +#include "test_check_mtu.skel.h"
> +#define IFINDEX_LO 1
> +
> +void test_check_mtu_xdp(struct test_check_mtu *skel)

this should be static func, otherwise it's treated as an independent selftest.

> +{
> +       int err = 0;
> +       int fd;
> +
> +       fd = bpf_program__fd(skel->progs.xdp_use_helper);
> +       err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
> +       if (CHECK_FAIL(err))

please use CHECK() or one of ASSERT_xxx() helpers. CHECK_FAIL() should
be used for high-volume unlikely to fail test (i.e., very rarely).

> +               return;
> +
> +       bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
> +}
> +
> +void test_check_mtu(void)
> +{
> +       struct test_check_mtu *skel;
> +
> +       skel = test_check_mtu__open_and_load();
> +       if (CHECK_FAIL(!skel)) {
> +               perror("test_check_mtu__open_and_load");
> +               return;
> +       }
> +
> +       if (test__start_subtest("bpf_check_mtu XDP-attach"))
> +               test_check_mtu_xdp(skel);
> +
> +       test_check_mtu__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> new file mode 100644
> index 000000000000..ab97ec925a32
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Red Hat */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#include <stddef.h>
> +#include <stdint.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("xdp")
> +int xdp_use_helper(struct xdp_md *ctx)
> +{
> +       uint32_t mtu_len = 0;
> +       int delta = 20;
> +
> +       if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
> +               return XDP_ABORTED;
> +       }

nit: unnecessary {} for single-line if; same below

> +       return XDP_PASS;
> +}
> +
> +SEC("classifier")
> +int tc_use_helper(struct __sk_buff *ctx)
> +{
> +       uint32_t mtu_len = 0;
> +       int delta = -20;
> +
> +       if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
> +               return BPF_DROP;
> +       }
> +       return BPF_OK;
> +}
>
>
