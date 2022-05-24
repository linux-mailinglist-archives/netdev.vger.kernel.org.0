Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1236B5333EC
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 01:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242644AbiEXXaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 19:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiEXXaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 19:30:04 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39777377C8;
        Tue, 24 May 2022 16:30:02 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 2so10040738iou.5;
        Tue, 24 May 2022 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWo+xqDM08+qEGv9DZGrSSOnKr+Gp8sn94xTo1Uky0E=;
        b=Goep18DWb6PBCJrMTtE4URNqHUXeS0E+bdZB4L+k55Yqd13BdTMAz69Jn5hF/kZbkw
         4W8ghCktd4gEjzs1oq/GIPZaODjhJ6vyVvpBI81Sz07kPdxgX4tsFrL7UvnUDKVlBPSY
         bEXvH8pUhhIyIDhlTp/rnpzyltslnVmVZAT1gFr3Wd5d2cTqfGSEY0cG1HI5gGaOMOIh
         ITpuh+IixooD4xgfuo3j82JF4q4zrUJHMUANqtbiZeD3fCL+YyIEYHp/O9Zv7Va2h9YX
         XxB2Or1V/TFspr+g5+AqgAKcMypddPCVFlr1myAj21PSVhHV9qoG/FqT6Zx1LSHZ1OVz
         hLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWo+xqDM08+qEGv9DZGrSSOnKr+Gp8sn94xTo1Uky0E=;
        b=Wmwok0f1NbGPZXTIWc2kUMet1azxrSPdFtgtPGj/QcBILHWlRjZV4Y6bp9CP8B9rRo
         ANFM1bp0qEIS0byF22q4h+3IIT0GL/UBR3fy6PvPdU4XnGW78u+nKlMVpVIUWryWU5fj
         keSWd7sapja1vHFEnxpHiKXaBpMYj7B2Lh24/IhSaesUKqH/k2XTiKR48bzM+VQSC883
         p//X0aQ475qrnsSTSS8O93i9S0dZhw9oOyqi5P5vrWY6P3tOp9XKEk3oPHvjn+eifFQl
         O9oov/uhwKADrIO2XKgaVryvT7HGfVgQWj18+JJonIFDXgyGgZyGbN7Ur0eyI2QIP0QB
         Y0jA==
X-Gm-Message-State: AOAM531Pq5WvL26QxP3hc2aAEERMHZHBm0R6p/jaaMj6rQOc9ptvANhe
        /oJZa1MD07HCH9hcFc6H/jKF3m1Pqy+auaIkSog=
X-Google-Smtp-Source: ABdhPJyGKSLjdEimuoKNOtuP93bYx4DVK3ftxYDEWPHqnqZO3YIoEgjG31EFeH9P4RfA4BW+yANYN9BphrUKOUlGy6E=
X-Received: by 2002:a05:6638:3894:b0:32e:ef72:be9d with SMTP id
 b20-20020a056638389400b0032eef72be9dmr2269117jav.145.1653435001631; Tue, 24
 May 2022 16:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220524075306.32306-1-zhoufeng.zf@bytedance.com> <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 May 2022 16:29:50 -0700
Message-ID: <CAEf4BzbPrfFe-3TGf=jJxrp9DT6Z1JaEDhWCd3wTYOPsihUmkA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftest/bpf/benchs: Add bpf_map benchmark
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 12:53 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> Add benchmark for hash_map to reproduce the worst case
> that non-stop update when map's free is zero.
>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  4 +-
>  tools/testing/selftests/bpf/bench.c           |  2 +
>  .../selftests/bpf/benchs/bench_bpf_map.c      | 78 +++++++++++++++++++
>  .../selftests/bpf/benchs/run_bench_bpf_map.sh | 10 +++
>  .../selftests/bpf/progs/bpf_map_bench.c       | 27 +++++++
>  5 files changed, 120 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_map.c
>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_bench.c
>

[...]

> +static void setup(void)
> +{
> +       struct bpf_link *link;
> +       int map_fd, i, max_entries;
> +
> +       setup_libbpf();
> +
> +       ctx.skel = bpf_map_bench__open_and_load();
> +       if (!ctx.skel) {
> +               fprintf(stderr, "failed to open skeleton\n");
> +               exit(1);
> +       }
> +
> +       link = bpf_program__attach(ctx.skel->progs.benchmark);
> +       if (!link) {
> +               fprintf(stderr, "failed to attach program!\n");
> +               exit(1);
> +       }
> +
> +       //fill hash_map

don't use C++ comments

> +       map_fd = bpf_map__fd(ctx.skel->maps.hash_map_bench);
> +       max_entries = bpf_map__max_entries(ctx.skel->maps.hash_map_bench);
> +       for (i = 0; i < max_entries; i++)
> +               bpf_map_update_elem(map_fd, &i, &i, BPF_ANY);
> +}
> +
> +const struct bench bench_bpf_map = {
> +       .name = "bpf-map",

this is too generic name, it's testing one particular scenario, so
call this out in the name. bpf-hashmap-full-update or something (same
for all the relevant function and file names)


> +       .validate = validate,
> +       .setup = setup,
> +       .producer_thread = producer,
> +       .consumer_thread = consumer,
> +       .measure = measure,
> +       .report_progress = ops_report_progress,
> +       .report_final = ops_report_final,
> +};
> diff --git a/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
> new file mode 100755
> index 000000000000..d7cc969e4f85
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
> @@ -0,0 +1,10 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +source ./benchs/run_common.sh
> +
> +set -eufo pipefail
> +
> +nr_threads=`expr $(cat /proc/cpuinfo | grep "processor"| wc -l) - 1`
> +summary=$($RUN_BENCH -p $nr_threads bpf-map)
> +printf "$summary"
> diff --git a/tools/testing/selftests/bpf/progs/bpf_map_bench.c b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
> new file mode 100644
> index 000000000000..655366e6e0f4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Bytedance */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include "bpf_misc.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define MAX_ENTRIES 1000
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __type(key, u32);
> +       __type(value, u64);
> +       __uint(max_entries, MAX_ENTRIES);
> +} hash_map_bench SEC(".maps");
> +
> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
> +int benchmark(void *ctx)
> +{
> +       u32 key = bpf_get_prandom_u32();
> +       u64 init_val = 1;
> +
> +       bpf_map_update_elem(&hash_map_bench, &key, &init_val, BPF_ANY);
> +       return 0;
> +}
> --
> 2.20.1
>
