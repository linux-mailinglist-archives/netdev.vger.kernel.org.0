Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7CA1E5832
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgE1HIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE1HIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:08:46 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10B2C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:08:45 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c185so2180394qke.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiQCbB9xTuo5IxRvTTIeoCsSk6AYTx/5HGdnfj+sk7w=;
        b=Q07gELwG/MAacvJ4x1xnfX1QW78IQRucQX3eRnGsBIWuo2yDllKhlUMxfiws0zIRxc
         BAdKI0iTZWuZxL75ucRem7pdcn6MVhOCj4pZsPbi8sTeZarWbFsFbejHWUDm4tZcTmxy
         wvyMHz6ygfbd9w4yDLZIX6Z211pfUEWDlVmuB3X71fR7AfipmTb0Pn7od3pnDubXVmIE
         6wOa8iC2tsVG2Z4Z71jra6g8a7fJFHS/P+gimzcULW3EQdCoihC/3nxbo19M8MncXmU3
         k6ISOGnDAaYo3xDw1HFk+VwGcIM9j9V960ts0n9/08S3czZ92CMDukYYCnjQZbo48G9g
         eJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiQCbB9xTuo5IxRvTTIeoCsSk6AYTx/5HGdnfj+sk7w=;
        b=m+P6DNLlYzSwetfqVwuLSyPb8rmmaTwv530TKyUguMmwXOTFBxHpd3doIVU9nUzbPZ
         o5osIQvn5Zvt3yv6C/heT83EP3lKC81C5XwyVm6hW68lbFzTmk4nuQwgp66+zLihJjhy
         nxfXL0c95BWoQ2YPu9tAnRyLBJXxvqeStyH9nyN90aDyAAcnudabCvaABAq64mVmzFBq
         Jgqnd1FAUK6ghjJB9bKLiQjKKyvivrOYsuMxNiFyfBVyW8dYN5nTfEU6WVYOOfpJoNJn
         ZBHTb7UEKDGx2eQJtdQw/BSRHboU/m207W/XYRafdvqHDgB0mdXg7nMooI+8mIiPsjpB
         duYQ==
X-Gm-Message-State: AOAM533CepgEn54g1/fj8dSnVGfUV8xNgTLhwIgiTElHsvKIgso1eNlc
        TeVRCs87PVyQPWtPNE5f2X2zcFrjeOBjb3mQLKw=
X-Google-Smtp-Source: ABdhPJyll9XgAfPYhD5BybKkkh0R3b145xWB6xOAQb3CyWdCh2ImA4bIpkwm4Y5Cm4akb5L/WJuS62pigrrJrmupMU8=
X-Received: by 2002:a37:4595:: with SMTP id s143mr1564760qka.449.1590649725095;
 Thu, 28 May 2020 00:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-6-dsahern@kernel.org>
In-Reply-To: <20200528001423.58575-6-dsahern@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 00:08:34 -0700
Message-ID: <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/5] selftest: Add tests for XDP programs in
 devmap entries
To:     David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:15 PM David Ahern <dsahern@kernel.org> wrote:
>
> Add tests to verify ability to add an XDP program to a
> entry in a DEVMAP.
>
> Add negative tests to show DEVMAP programs can not be
> attached to devices as a normal XDP program, and accesses
> to egress_ifindex require BPF_XDP_DEVMAP attach type.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  .../bpf/prog_tests/xdp_devmap_attach.c        | 94 +++++++++++++++++++
>  .../selftests/bpf/progs/test_xdp_devmap.c     | 19 ++++
>  .../selftests/bpf/progs/test_xdp_devmap2.c    | 19 ++++
>  .../bpf/progs/test_xdp_with_devmap.c          | 17 ++++
>  4 files changed, 149 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> new file mode 100644
> index 000000000000..d81b2b366f39
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> @@ -0,0 +1,94 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <uapi/linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <test_progs.h>
> +
> +#define IFINDEX_LO 1
> +
> +void test_xdp_devmap_attach(void)
> +{
> +       struct bpf_prog_load_attr attr = {
> +               .prog_type = BPF_PROG_TYPE_XDP,
> +       };
> +       struct bpf_object *obj, *dm_obj = NULL;
> +       int err, dm_fd = -1, fd = -1, map_fd;
> +       struct bpf_prog_info info = {};
> +       struct devmap_val val = {
> +               .ifindex = IFINDEX_LO,
> +       };
> +       __u32 id, len = sizeof(info);
> +       __u32 duration = 0, idx = 0;
> +
> +       attr.file = "./test_xdp_with_devmap.o",
> +       err = bpf_prog_load_xattr(&attr, &obj, &fd);

please use skeletons instead of loading .o files.

> +       if (CHECK(err, "load of xdp program with 8-byte devmap",
> +                 "err %d errno %d\n", err, errno))
> +               return;
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap.c
> new file mode 100644
> index 000000000000..64fc2c3cae01
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* program inserted into devmap entry */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("xdp_devmap_log")
> +int xdpdm_devlog(struct xdp_md *ctx)
> +{
> +       char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       unsigned int len = data_end - data;
> +
> +       bpf_trace_printk(fmt, sizeof(fmt), ctx->ingress_ifindex, ctx->egress_ifindex, len);
> +
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
> new file mode 100644
> index 000000000000..64fc2c3cae01
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* program inserted into devmap entry */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("xdp_devmap_log")
> +int xdpdm_devlog(struct xdp_md *ctx)
> +{
> +       char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       unsigned int len = data_end - data;
> +
> +       bpf_trace_printk(fmt, sizeof(fmt), ctx->ingress_ifindex, ctx->egress_ifindex, len);

instead of just printing ifindexes, why not return them through global
variable and validate in a test?

> +
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
> new file mode 100644
> index 000000000000..815cd59b4866
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct bpf_map_def SEC("maps") dm_ports = {
> +       .type = BPF_MAP_TYPE_DEVMAP,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(struct devmap_val),
> +       .max_entries = 4,
> +};
> +

This is an old syntax for maps, all the selftests were converted to
BTF-defined maps. Please update.

> +SEC("xdp_devmap")
> +int xdp_with_devmap(struct xdp_md *ctx)
> +{
> +       return bpf_redirect_map(&dm_ports, 1, 0);
> +}
> --
> 2.21.1 (Apple Git-122.3)
>
