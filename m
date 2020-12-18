Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383B12DEA07
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbgLRUOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgLRUOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:14:37 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68BFC0617A7;
        Fri, 18 Dec 2020 12:13:56 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id a16so3025563ybh.5;
        Fri, 18 Dec 2020 12:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhPOI3RSL/Me8q5ZKaUmaGiiPfOru1ej3QAdbJ76iaw=;
        b=sbg8ni2O6oEMIjvwiTa16ooNV1sJSkC9DcSy7OujiTKP9l0SgookngOSGx4gChapY1
         5bXqyYgg2atSc6jwzRGjURWXZgzYaWFsiZI5nxZDxnm9bv3oqq0faWi62zgL1ppEXveD
         W4AAzKaMFIN5yWoX2lSwXpM/oSxSz3oT5YGJQcIMrIiwcggMQbqJs9VnYdnv3FoLCZw5
         DUG5o5vaZDzkp92zQfq+xk8ANGKdVLp7DtcCu9Ffcad3glJcyEwDw50bHD2UduwMGXzZ
         ksQfgCjWr0ljrhokfM4S+TYJUnspW1V5lgJv11e2gZM2QOniGTNLiWOx5E7P9zAPt9mu
         dBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhPOI3RSL/Me8q5ZKaUmaGiiPfOru1ej3QAdbJ76iaw=;
        b=sMho2tdGJ/cnUcs63cCj9dvBIb4U3NYLCMgvoh8C/VLC4gY3L+UvbQh1aqdp3t9Exl
         bS7Vnp2+Yz2rlvGV0wDPnBrfAnDSNDtdxN4DrJzXYKSRwbUgZGrN6RB5oGAURRdmAm96
         u3cd+pfnT8lp3qk/zHeV2pwivHiK3+NO8ycfIlpmgz8XnKwKCJ5KiQILzDgott/j8pZV
         9Kt9bo8z4B3z2sNpOLlPNeu3ZCYZLP/YF2O3AfN3R/3ljciwu6bz0QLKmX4eUFIrQROW
         yTnxMv0ACc+pEd87O41Jod+LzDbYapPRBk+BB1QbAg+YJ7AES6AcC9b5g3y695tsdoh+
         U5ow==
X-Gm-Message-State: AOAM533ldIZ83f5ss12oEwnTS61OxC78Dl5uU3LwX3fBmS7nayNxoqNy
        m2LSHjTf7JglCgZfg/YyuY4HruN0aJy9mJoJNSM=
X-Google-Smtp-Source: ABdhPJwXqy/T12Sf1WPbuhjB9Dbwevq/yrphHHK4H/R55uj2E6uWfa+z3g3Ty4CX9sFX5GVAdFdAYGOTdOLR2PLGcqU=
X-Received: by 2002:a25:818e:: with SMTP id p14mr8062412ybk.425.1608322435860;
 Fri, 18 Dec 2020 12:13:55 -0800 (PST)
MIME-Version: 1.0
References: <160822594178.3481451.1208057539613401103.stgit@firesoul> <160822601093.3481451.9135115478358953965.stgit@firesoul>
In-Reply-To: <160822601093.3481451.9135115478358953965.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 12:13:45 -0800
Message-ID: <CAEf4Bzbud5EWAo9E=95VzGeCZGLA9_MdQUrAc8unh3izXcd3AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V9 7/7] bpf/selftests: tests using bpf_check_mtu BPF-helper
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

On Thu, Dec 17, 2020 at 9:30 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |  204 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |  196 +++++++++++++++++++
>  2 files changed, 400 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> new file mode 100644
> index 000000000000..b5d0c3a9abe8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Jesper Dangaard Brouer */
> +
> +#include <linux/if_link.h> /* before test_progs.h, avoid bpf_util.h redefines */
> +
> +#include <test_progs.h>
> +#include "test_check_mtu.skel.h"
> +#include <network_helpers.h>
> +
> +#include <stdlib.h>
> +#include <inttypes.h>
> +
> +#define IFINDEX_LO 1
> +
> +static __u32 duration; /* Hint: needed for CHECK macro */
> +
> +static int read_mtu_device_lo(void)
> +{
> +       const char *filename = "/sys/devices/virtual/net/lo/mtu";
> +       char buf[11] = {};
> +       int value;
> +       int fd;
> +
> +       fd = open(filename, 0, O_RDONLY);
> +       if (fd == -1)
> +               return -1;
> +
> +       if (read(fd, buf, sizeof(buf)) == -1)

close fd missing here?

> +               return -2;
> +       close(fd);
> +
> +       value = strtoimax(buf, NULL, 10);
> +       if (errno == ERANGE)
> +               return -3;
> +
> +       return value;
> +}
> +
> +static void test_check_mtu_xdp_attach(struct bpf_program *prog)
> +{
> +       int err = 0;
> +       int fd;
> +
> +       fd = bpf_program__fd(prog);
> +       err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
> +       if (CHECK(err, "XDP-attach", "failed"))
> +               return;
> +
> +       bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);

can you please use bpf_link-based bpf_program__attach_xdp() which will
provide auto-cleanup in case of crash?

also check that it succeeded?

> +}
> +
> +static void test_check_mtu_run_xdp(struct test_check_mtu *skel,
> +                                  struct bpf_program *prog,
> +                                  __u32 mtu_expect)
> +{
> +       const char *prog_name = bpf_program__name(prog);
> +       int retval_expect = XDP_PASS;
> +       __u32 mtu_result = 0;
> +       char buf[256];
> +       int err;
> +
> +       struct bpf_prog_test_run_attr tattr = {
> +               .repeat = 1,
> +               .data_in = &pkt_v4,
> +               .data_size_in = sizeof(pkt_v4),
> +               .data_out = buf,
> +               .data_size_out = sizeof(buf),
> +               .prog_fd = bpf_program__fd(prog),
> +       };

nit: it's a variable declaration, so keep it all in one block. There
is also opts-based variant, which might be good to use here instead.

> +
> +       memset(buf, 0, sizeof(buf));

char buf[256] = {}; would make this unnecessary


> +
> +       err = bpf_prog_test_run_xattr(&tattr);
> +       CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
> +                  "prog_name:%s (err %d errno %d retval %d)\n",
> +                  prog_name, err, errno, tattr.retval);
> +
> +        CHECK(tattr.retval != retval_expect, "retval",

whitespaces are off?

> +             "progname:%s unexpected retval=%d expected=%d\n",
> +             prog_name, tattr.retval, retval_expect);
> +
> +       /* Extract MTU that BPF-prog got */
> +       mtu_result = skel->bss->global_bpf_mtu_xdp;
> +       CHECK(mtu_result != mtu_expect, "MTU-compare-user",
> +             "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);

There is nicer ASSERT_EQ() macro for such cases:

ASSERT_EQ(mtu_result, mtu_expect, "MTU-compare-user"); it will format
sensible error message automatically

> +}
> +

[...]

> +       char buf[256];
> +       int err;
> +
> +       struct bpf_prog_test_run_attr tattr = {
> +               .repeat = 1,
> +               .data_in = &pkt_v4,
> +               .data_size_in = sizeof(pkt_v4),
> +               .data_out = buf,
> +               .data_size_out = sizeof(buf),
> +               .prog_fd = bpf_program__fd(prog),
> +       };
> +
> +       memset(buf, 0, sizeof(buf));
> +

same as above

> +       err = bpf_prog_test_run_xattr(&tattr);
> +       CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
> +                  "prog_name:%s (err %d errno %d retval %d)\n",
> +                  prog_name, err, errno, tattr.retval);
> +
> +        CHECK(tattr.retval != retval_expect, "retval",

same :)

> +             "progname:%s unexpected retval=%d expected=%d\n",
> +             prog_name, tattr.retval, retval_expect);
> +
> +       /* Extract MTU that BPF-prog got */
> +       mtu_result = skel->bss->global_bpf_mtu_tc;
> +       CHECK(mtu_result != mtu_expect, "MTU-compare-user",
> +             "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);
> +}
> +
> +

[...]

> +
> +void test_check_mtu(void)
> +{
> +       struct test_check_mtu *skel;
> +       __u32 mtu_lo;
> +
> +       skel = test_check_mtu__open_and_load();
> +       if (CHECK(!skel, "open and load skel", "failed"))
> +               return; /* Exit if e.g. helper unknown to kernel */
> +
> +       if (test__start_subtest("bpf_check_mtu XDP-attach"))
> +               test_check_mtu_xdp_attach(skel->progs.xdp_use_helper_basic);
> +
> +       test_check_mtu__destroy(skel);

here it's not clear why you instantiate skeleton outside of
test_check_mtu_xdp_attach() subtest. Can you please move it in? It
will keep this failure local to that specific subtest, not the entire
test. And is just cleaner, of course.

> +
> +       mtu_lo = read_mtu_device_lo();
> +       if (CHECK(mtu_lo < 0, "reading MTU value", "failed (err:%d)", mtu_lo))

ASSERT_OK() could be used here

> +               return;
> +
> +       if (test__start_subtest("bpf_check_mtu XDP-run"))
> +               test_check_mtu_xdp(mtu_lo, 0);
> +
> +       if (test__start_subtest("bpf_check_mtu XDP-run ifindex-lookup"))
> +               test_check_mtu_xdp(mtu_lo, IFINDEX_LO);
> +
> +       if (test__start_subtest("bpf_check_mtu TC-run"))
> +               test_check_mtu_tc(mtu_lo, 0);
> +
> +       if (test__start_subtest("bpf_check_mtu TC-run ifindex-lookup"))
> +               test_check_mtu_tc(mtu_lo, IFINDEX_LO);
> +}

[...]

> +
> +       global_bpf_mtu_tc = mtu_len;
> +       return retval;
> +}
> +
> +SEC("classifier")

nice use of the same SEC()'tion BPF programs!


> +int tc_minus_delta(struct __sk_buff *ctx)
> +{
> +       int retval = BPF_OK; /* Expected retval on successful test */
> +       __u32 ifindex = GLOBAL_USER_IFINDEX;
> +       __u32 skb_len = ctx->len;
> +       __u32 mtu_len = 0;
> +       int delta;
> +
> +       /* Boarderline test case: Minus delta exceeding packet length allowed */
> +       delta = -((skb_len - ETH_HLEN) + 1);
> +
> +       /* Minus length (adjusted via delta) still pass MTU check, other helpers
> +        * are responsible for catching this, when doing actual size adjust
> +        */
> +       if (bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))
> +               retval = BPF_DROP;
> +
> +       global_bpf_mtu_xdp = mtu_len;
> +       return retval;
> +}
>
>
