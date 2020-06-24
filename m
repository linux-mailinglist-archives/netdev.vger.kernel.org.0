Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB78B206BF9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 07:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbgFXFv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 01:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388280AbgFXFvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 01:51:55 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76EC061573;
        Tue, 23 Jun 2020 22:51:54 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id a14so537634qvq.6;
        Tue, 23 Jun 2020 22:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znsCs9AkRtDHKjWzlFSHckvTuV2gM8GBqH6ZDDQgJqM=;
        b=nzmbA73IgLtpH9FDwIm136CArsdbhoy7eWaVHbPS2eJ7UlhH7TsBxC1qz4U19NRSI3
         3im4FUXPf5sdD7UONiQhQucuAB+U7Lxb6ZY2TX40IZewcKdqCaWsSgSIZxrOcnJRUtz1
         44Brfw2ZWrhOxlB+3fn9rgWDLSRJ5Z1CHMEPwKrUCfeZQfZTDEvFUk85gYwFmQepqTGw
         J5+guLfQBiDNSiM2eyn1AotxH76mnXo/EHSJ3rl/BYvrXphL/YMqNrvM2T+16k8+hcIW
         /JdtA6I5wwurLBf87Y5qSpDUYic2aS519GQM2CPzxm8h8MuRaRQAMAeILcM6WQ2FVooa
         ajew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znsCs9AkRtDHKjWzlFSHckvTuV2gM8GBqH6ZDDQgJqM=;
        b=eqkQK4JIe33+D4YHMiKQUzkeBQGX6B6zDRYC9WdfXColHC//glRP7rXUSRG8ZZQdyl
         mMscXr6g48HLK9P7YZB/bz8xQeqsGXKK/RHhDHUrUgGVE2RE1FNmRtjGcYG3HNWlnhGR
         xWTdB0POsaSGkZWpy57Blb2FEzR+i1a5NctAitjgjhM0aaEgd7gT0PulXEVfVfa4J7uj
         pPoSrBatYeN4YqnI5M3SXSI1xF+I1+k3UftrYsQ3BhrMU3r+9csOHU8PEuBXm0/z5rsd
         rwOoXYaiQhH2u6uCxfSQ/UsxwKMD8pVo7zfaarFZ5TZ0vjDBmgYKDShIGArMPJRqd+xZ
         d3OA==
X-Gm-Message-State: AOAM531R+X5mjZJ8cZqYE4S/xx6onyuKm6cmErw4ttlth9+yJ1hPWdHJ
        wgVqUVDp2VrcWm1sqzLlyx8VqT7j8yQUedoOjWs=
X-Google-Smtp-Source: ABdhPJz1hkUbpCj9i63m/ymQDbIXP6C0UyO97kiZY9OWtQ5V/YKh5DplXtMa2W/lEV9FtxG0p555whYJJ96di5LOC74=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr29755466qvb.196.1592977913300;
 Tue, 23 Jun 2020 22:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592947694.git.lorenzo@kernel.org> <81ff56ab7ba1f0e48cba821563d311fa8f7e2e28.1592947694.git.lorenzo@kernel.org>
In-Reply-To: <81ff56ab7ba1f0e48cba821563d311fa8f7e2e28.1592947694.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 22:51:42 -0700
Message-ID: <CAEf4BzZUfxv_zbuefAYM6gxQ2pdxYjQLjZTb=9qGJhoVztuZ3Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 9/9] selftest: add tests for XDP programs in
 CPUMAP entries
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Tue, Jun 23, 2020 at 2:40 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
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
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  | 40 +++++++++++
>  2 files changed, 110 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> new file mode 100644
> index 000000000000..0176573fe4e7
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
> +       if (test__start_subtest("cpumap_with_progs"))
> +               test_xdp_with_cpumap_helpers();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
> new file mode 100644
> index 000000000000..861848d0c353
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +static __u32 ingress_ifindex;
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
> +SEC("xdp_cpumap/dummy_cm")
> +int xdp_dummy_cm(struct xdp_md *ctx)
> +{
> +       char fmt[] = "devmap redirect: dev %u len %u\n";
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       unsigned int len = data_end - data;
> +
> +       ingress_ifindex = ctx->ingress_ifindex;

Have you checked the generated BPF assembly to verify
ctx->ingress_ifindex is actually read? ingress_ifindex variable is
declared static, so I'm guessing Clang just optimized it away. If you
want to be sure this actually gets executed, make ingress_ifindex
global var.

> +
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.26.2
>
