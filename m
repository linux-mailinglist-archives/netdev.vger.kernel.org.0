Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B758D20495D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgFWFzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgFWFzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 01:55:47 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FEBC061573;
        Mon, 22 Jun 2020 22:55:45 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f18so17841901qkh.1;
        Mon, 22 Jun 2020 22:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Chr9DxTgyC1O01lU8vGmKQECBfgvN4hwBinx6d+lMdU=;
        b=Q/oGQUVV/TVr3D3b3rBY2cKjjh2x2VYuYMsi6gTuzeZ2zAfK7Xvkw3kdSjUzKblqcF
         ouk/pnl+H7pKVXkusvUN4val9yVuBq7VGPp9+wE4c4/oS/Xs95vqkFN6Uzd8KGnENHSo
         jvbbibNCzA0EZegw8wlgbAlMGoRaxfJTBzbpDUcHPXgS5oo6x0iIT+vyofaHXhOow7kR
         jmkmDAZ94nOVFj6nvgxsekmHyCdl9ls+gKz9OdN1OEpcXL5A37x4xf/OzJzjS3zPRzO0
         LMVAQBI5Ovbr0jNSodYHdyLPRUM5HOE2xFjc+2AHAOijtZNYiAUj+slpjAmdLVcXaexP
         nbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Chr9DxTgyC1O01lU8vGmKQECBfgvN4hwBinx6d+lMdU=;
        b=sgqDgEP5NXHFtZOOOwFXHvKJoBvZnq/QyhogcPWJMNdLgD/Mgv5aZxSa5Z0WHe/l+h
         nHrVsvXqZQcP0Ahr0A/dyiF5OwF4oiBB2+ptf654yRpxNpRm3eJjAUbn0LvBonwKZrUc
         9i9ygAvyVrzU6aoR/KNq1tp7CY6wFJc4WJsB38YOdV7sTX0AWX8GwbHMDqLOwb/fWvvm
         TuSGjVbsLHq9IcqfaMbs+iZo+yahbqfHcwGYFvEMJ5JCHjKaeTjgvmpep2FDkeyi28B2
         I3IF2NByOWxFCYSYPCo6+2SQEF5zK85tlDxNidz3IZOeVSJehRQIYofLtqgxqiMAKaCq
         R9ww==
X-Gm-Message-State: AOAM533w3jqGB4rLLiOOSFSrgHu4V2INnVQ6yoN2MZFkayv747GbDhAg
        nSSTCoBsQJ8ARPg4TSXmqlmK55JElLfmOCAx8eExuhzH
X-Google-Smtp-Source: ABdhPJxVqWlUAfGdEORsLr2PmbdYNz0H34jF8xEmoK7/FhUoH76MEf8K/xHx3fJQOxjOhaqrWX/1Q5RdMYjP3AvjlyQ=
X-Received: by 2002:a37:a89:: with SMTP id 131mr18626718qkk.92.1592891744951;
 Mon, 22 Jun 2020 22:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592606391.git.lorenzo@kernel.org> <ebad39bb3d961a65733c33ed530b9d1ade916afa.1592606391.git.lorenzo@kernel.org>
In-Reply-To: <ebad39bb3d961a65733c33ed530b9d1ade916afa.1592606391.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 22:55:34 -0700
Message-ID: <CAEf4BzbroU6o8yp=ca0JQqSS6WEZ9VQRcufq+T0vkCOoQsjB2w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 8/8] selftest: add tests for XDP programs in
 CPUMAP entries
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 9:55 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Similar to what have been done for DEVMAP, introduce tests to verify
> ability to add a XDP program to an entry in a CPUMAP.
> Verify CPUMAP programs can not be attached to devices as a normal
> XDP program, and only programs with BPF_XDP_CPUMAP attach type can
> be loaded in a CPUMAP.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../bpf/prog_tests/xdp_cpumap_attach.c        | 70 +++++++++++++++++++
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  | 38 ++++++++++
>  2 files changed, 108 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> new file mode 100644
> index 000000000000..2baa41689f40
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <uapi/linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <test_progs.h>
> +
> +#include "test_xdp_with_cpumap_helpers.skel.h"
> +
> +#define IFINDEX_LO     1
> +
> +void test_xdp_with_cpumap_helpers(void)
> +{
> +       struct test_xdp_with_cpumap_helpers *skel;
> +       struct bpf_prog_info info = {};
> +       struct bpf_cpumap_val val = {
> +               .qsize = 192,
> +       };
> +       __u32 duration = 0, idx = 0;
> +       __u32 len = sizeof(info);
> +       int err, prog_fd, map_fd;
> +
> +       skel = test_xdp_with_cpumap_helpers__open_and_load();
> +       if (CHECK_FAIL(!skel)) {
> +               perror("test_xdp_with_cpumap_helpers__open_and_load");
> +               return;
> +       }
> +
> +       /* can not attach program with cpumaps that allow programs
> +        * as xdp generic
> +        */
> +       prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
> +       err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
> +       CHECK(err == 0, "Generic attach of program with 8-byte CPUMAP",
> +             "should have failed\n");
> +
> +       prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
> +       map_fd = bpf_map__fd(skel->maps.cpu_map);
> +       err = bpf_obj_get_info_by_fd(prog_fd, &info, &len);
> +       if (CHECK_FAIL(err))
> +               goto out_close;
> +
> +       val.bpf_prog.fd = prog_fd;
> +       err = bpf_map_update_elem(map_fd, &idx, &val, 0);
> +       CHECK(err, "Add program to cpumap entry", "err %d errno %d\n",
> +             err, errno);
> +
> +       err = bpf_map_lookup_elem(map_fd, &idx, &val);
> +       CHECK(err, "Read cpumap entry", "err %d errno %d\n", err, errno);
> +       CHECK(info.id != val.bpf_prog.id, "Expected program id in cpumap entry",
> +             "expected %u read %u\n", info.id, val.bpf_prog.id);
> +
> +       /* can not attach BPF_XDP_CPUMAP program to a device */
> +       err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
> +       CHECK(err == 0, "Attach of BPF_XDP_CPUMAP program",
> +             "should have failed\n");
> +
> +       val.qsize = 192;
> +       val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
> +       err = bpf_map_update_elem(map_fd, &idx, &val, 0);
> +       CHECK(err == 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry",
> +             "should have failed\n");
> +
> +out_close:
> +       test_xdp_with_cpumap_helpers__destroy(skel);
> +}
> +
> +void test_xdp_cpumap_attach(void)
> +{
> +       if (test__start_subtest("CPUMAP with programs in entries"))

These subtest names are supposed to be short and follow test names
(i.e., being more or less valid C identifiers). It makes it easier to
select or blacklist them (with -t and -b params). So something like
cpumap_with_progs or similar would be better in that regard and would
make it easier for me to maintain a blacklist of tests/subtests for
Travis CI, for instance.

I think there is similarly verbose DEVMAP subtest name, I'd love it to
be "simplified" as well... But can't get my hands on everything,
unfortunately.

> +               test_xdp_with_cpumap_helpers();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
> new file mode 100644
> index 000000000000..acbbc62efa55
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_CPUMAP);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(struct bpf_cpumap_val));
> +       __uint(max_entries, 4);
> +} cpu_map SEC(".maps");
> +
> +SEC("xdp_redir")
> +int xdp_redir_prog(struct xdp_md *ctx)
> +{
> +       return bpf_redirect_map(&cpu_map, 1, 0);
> +}
> +
> +SEC("xdp_dummy")
> +int xdp_dummy_prog(struct xdp_md *ctx)
> +{
> +       return XDP_PASS;
> +}
> +
> +SEC("xdp_cpumap")
> +int xdp_dummy_cm(struct xdp_md *ctx)
> +{
> +       char fmt[] = "devmap redirect: dev %u len %u\n";
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       unsigned int len = data_end - data;
> +
> +       bpf_trace_printk(fmt, sizeof(fmt), ctx->ingress_ifindex, len);

Is there any reason to use bpf_trace_printk as opposed to saving
ctx->ingress_ifindex into a global variable? bpf_trace_printk isn't
really testing anything, just pollutes trace_pipe.

> +
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.26.2
>
