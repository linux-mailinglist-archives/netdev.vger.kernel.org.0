Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA8F13B256
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 19:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgANSts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 13:49:48 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45321 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANSts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:49:48 -0500
Received: by mail-qk1-f196.google.com with SMTP id x1so13093042qkl.12;
        Tue, 14 Jan 2020 10:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+C6kT6nCOolkLnvThbupiFR+IWO00TDFVSftISDh7E8=;
        b=pMPfJeHrLJUVAa0SNJtJp/4LA/O4bp6xlczxtQFQpXII4u9QEK8JSMlncZOWe9xfDY
         CSKEjVYNdCq6V++Gy7IpNcfmFb7bjYPjL9I5686GPQTX1nw0e9IWEj/M/IfwTL00ihMl
         Gpx+HoN4XzJKqPkmntaH9hCCH1gke54pSOxDn8Ep7mz9ij1tGdOvi5ZZv4YhzXl+JmLY
         ZDGKYDFt5VJzf2Fi+A8PRlt9ie9usuG/2UO1Re79rybO7BQgUMNrHARWRHmm4Ixfs6qA
         g8wLz0rfTjTXbJIODc7r5xJj5QIgnEu7KYMl2tVEtQ/FqkT15aV1RiJMcqTTwts7u+Lw
         KFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+C6kT6nCOolkLnvThbupiFR+IWO00TDFVSftISDh7E8=;
        b=AVQkhuTaGCaJEVavhexBPAjm0gUF0PAq49KB0x4+j2Vp7nOuqSiGiObOh8uSzgnYtA
         KbHIQzNiBOgl7GPSgf5ffZe1Vjcu38fCSh+8kuzNvDXklJn8ysiTDYGF7xtmL77oek+H
         qQBu03gBQveDxJOwEcNJ43UZodvRotGx8dUq5qveEhIcFJoR1JMZOmhM2V28I0NolVLA
         TGlSLHGVVQILxPgPhZHs7/MrPCMgeuSsXKYVgpFK8a3wm0xYUCEomOhOldlSEGiJPyrD
         8Ql1IXYz0NjvsY8Zlq56v7rdyPEh6Gwyriu0yrHRiLmrfwAdq2kbdvg6zVPlQYyfv2m4
         JeUg==
X-Gm-Message-State: APjAAAVm/gBnFPKiPGx1aGhru+pgxJsG9oXb4FkjF2av44VjDgqBBdID
        yeAyqSbpAkNdojZKjZKu/EOUaTMKDTdNgls/DDE=
X-Google-Smtp-Source: APXvYqxlaCsDBb9kzHsQRABuWVIU/9xWdfoOfxBeYXGqkIpbpO0z/kGX7LwNjXs9Ozw3aGFVcQYMDiSWUkdLKZl6M4c=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr19045033qkq.437.1579027786743;
 Tue, 14 Jan 2020 10:49:46 -0800 (PST)
MIME-Version: 1.0
References: <157901745600.30872.10096561620432101095.stgit@xdp-tutorial>
In-Reply-To: <157901745600.30872.10096561620432101095.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 10:49:35 -0800
Message-ID: <CAEf4BzYmTBH5b0mNdJ1Sts1FzygSX_im+mupRhP5Eo7rgE6g-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 7:58 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Add a test that will attach a FENTRY and FEXIT program to the XDP test
> program. It will also verify data from the XDP context on FENTRY and
> verifies the return code on exit.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> ---
> v1 -> v2:
>   - Changed code to use the BPF skeleton
>   - Replace static volatile with global variable in eBPF code
>
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   69 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> new file mode 100644
> index 000000000000..e6e849df2632
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <net/if.h>
> +#include "test_xdp.skel.h"
> +#include "test_xdp_bpf2bpf.skel.h"
> +
> +void test_xdp_bpf2bpf(void)
> +{
> +

extra line

> +       struct test_xdp *pkt_skel = NULL;
> +        struct test_xdp_bpf2bpf *ftrace_skel = NULL;

something with indentation?

> +       __u64 *ftrace_res;
> +

variable declarations shouldn't be split, probably?

> +       struct vip key4 = {.protocol = 6, .family = AF_INET};
> +       struct iptnl_info value4 = {.family = AF_INET};
> +       char buf[128];
> +       struct iphdr *iph = (void *)buf + sizeof(struct ethhdr);
> +       __u32 duration = 0, retval, size;
> +       int err, pkt_fd, map_fd;
> +
> +       /* Load XDP program to introspect */
> +       pkt_skel = test_xdp__open_and_load();
> +       if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton failed\n"))
> +               return;
> +
> +       pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_tx_iptunnel);
> +
> +       map_fd = bpf_map__fd(pkt_skel->maps.vip2tnl);
> +       bpf_map_update_elem(map_fd, &key4, &value4, 0);
> +
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +                           .attach_prog_fd = pkt_fd,
> +                          );

DECLARE_LIBBPF_OPTS is a variable declaration, so should go together
with all other declarations. Compiler should complain about this, but
I guess selftests/bpf Makefile doesn't have necessary flags, that
other kernel code has. You can declare opts first and then initialize
some extra fields later:

DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);

... later in code ...

opts.attach_prog_fd = pkt_fd;


> +
> +       ftrace_skel = test_xdp_bpf2bpf__open_opts(&opts);
> +       if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
> +         goto out;
> +
> +       if (CHECK(test_xdp_bpf2bpf__load(ftrace_skel), "__load", "ftrace skeleton failed\n"))
> +         goto out;

for consistency with attach check below and for readability, move out
load call into separate statement, it's easy to miss when it is inside
CHECK()

> +
> +       err = test_xdp_bpf2bpf__attach(ftrace_skel);
> +       if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n", err))
> +               goto out;
> +
> +        /* Run test program */
> +       err = bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               buf, &size, &retval, &duration);
> +
> +       CHECK(err || retval != XDP_TX || size != 74 ||
> +             iph->protocol != IPPROTO_IPIP, "ipv4",
> +             "err %d errno %d retval %d size %d\n",
> +             err, errno, retval, size);

should it goto out here as well?

> +
> +       /* Verify test results */
> +       ftrace_res = (__u64 *)ftrace_skel->bss;
> +
> +       if (CHECK(ftrace_res[0] != if_nametoindex("lo"), "result",
> +                 "fentry failed err %llu\n", ftrace_res[0]))
> +               goto out;
> +
> +       if (CHECK(ftrace_res[1] != XDP_TX, "result",
> +                 "fexit failed err %llu\n", ftrace_res[1]))
> +               goto out;

why this casting? You can do access those variables much more
naturally with ftrace_skel->bss->test_result_fentry and
ftrace_skel->bss->test_result_fexit without making dangerous
assumptions about their offsets within data section.


> +
> +out:
> +       test_xdp__destroy(pkt_skel);
> +       test_xdp_bpf2bpf__destroy(ftrace_skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> new file mode 100644
> index 000000000000..74c78b30ae07
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +#include "bpf_trace_helpers.h"
> +
> +struct net_device {
> +       /* Structure does not need to contain all entries,
> +        * as "preserve_access_index" will use BTF to fix this...
> +        */
> +       int ifindex;
> +} __attribute__((preserve_access_index));
> +
> +struct xdp_rxq_info {
> +       /* Structure does not need to contain all entries,
> +        * as "preserve_access_index" will use BTF to fix this...
> +        */
> +       struct net_device *dev;
> +       __u32 queue_index;
> +} __attribute__((preserve_access_index));
> +
> +struct xdp_buff {
> +       void *data;
> +       void *data_end;
> +       void *data_meta;
> +       void *data_hard_start;
> +       unsigned long handle;
> +       struct xdp_rxq_info *rxq;
> +} __attribute__((preserve_access_index));
> +
> +__u64 test_result_fentry = 0;
> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
> +           struct xdp_buff *, xdp)

BPF_TRACE_x is no more, see BPF_PROG and how it's used for fentry/fexit tests:

SEC("fentry/_xdp_tx_iptunnel")
int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)

> +{
> +       test_result_fentry = xdp->rxq->dev->ifindex;
> +       return 0;
> +}
> +
> +__u64 test_result_fexit = 0;
> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
> +           struct xdp_buff*, xdp, int, ret)
> +{
> +       test_result_fexit = ret;
> +       return 0;
> +}
>
