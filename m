Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886A4524378
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344349AbiELDeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344338AbiELDee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:34:34 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEA66FD11;
        Wed, 11 May 2022 20:34:32 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e194so4033750iof.11;
        Wed, 11 May 2022 20:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynf0e/virvZjVizU2QRUFjeoIWjt7fbHUUoT414b2mI=;
        b=o71rtoZS1hWQgY+blTY49Fz1ge2cFxrR3Q3Djr44ei+5uqxh787BoRPdLH3/pXMqaf
         Bueuci8imJrDQOZXlZU5OWsX3P9NDq51ZSz0awKmdBS6j9JXdhQucobr8HOrKdz3fdGV
         rkm0YWlx4p+bRCEa7y8/v6VGdFMY3tfjCknHVZRxcSaX0QCh0eYJqPrpxInjT5NVyV96
         jl7N9q30zbFwL4HXGrBEHXu8H51OAh2dk57hSkuMxuyOiY8tnIlXtq7YGurdLKfKFAeK
         VigX23GFtenA9s2iaKO+yr25hUT7+eBcXU+TQnNsNm/hHkH2ZuQY7lWrGeRdJ3ELXmRA
         zbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynf0e/virvZjVizU2QRUFjeoIWjt7fbHUUoT414b2mI=;
        b=Mojp6YOmsdrTbiF4+XfW8YlYJ65ad7cANWiZdyIoG55rZ5gFRveC9rsrRmxHuUNjIF
         r/FqiLBy4gNJymXaSkHj656Q/NYpSnSyML3beP7RWT3G4Xj7SApJEEeWETFUGMZAJZan
         +hHk6GTTtW692jHWj0JFl+L3qMWNTpGYuvt3l8ncVn87ioUWp/lJhk5fu/Ga8zWi6uJr
         jXvBdv7Iu1OOdVuEdFmxpjZ1wLbpDIqlbc/xnvSjLt7P5wfd9W+8C4wuYKT1XqisljFV
         HQ/5+Wz79uAyrf+vkjFZRaupznUaxWcVgSqIZ0NRq+VmmrJJAu2Ypq8eCKQIZ6fDucgS
         5f1g==
X-Gm-Message-State: AOAM531u7xTxNbZ4t3RIu3fiNVEvUOr/txm8ioFNM8sZ48TTFDcschVo
        efKo86AQJRZcr7D09KTxMxJzrW45vwVsu30yMfk=
X-Google-Smtp-Source: ABdhPJzPS/Yxm2YPeTS2PeeqfhhQTHUAj3jGf6URPk3RyfnRK130vQGyej2FRiAWmsMZmM1iniVU8XciAzjUeHzzdH0=
X-Received: by 2002:a5e:8e42:0:b0:657:bc82:64e5 with SMTP id
 r2-20020a5e8e42000000b00657bc8264e5mr11982398ioo.112.1652326471691; Wed, 11
 May 2022 20:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com> <20220511093854.411-3-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220511093854.411-3-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 May 2022 20:34:20 -0700
Message-ID: <CAEf4BzZL85C7KUwKv9i5cdLSDzM175cLjiW4EDjOqNfcxbLO+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: add test case for bpf_map_lookup_percpu_elem
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, yosryahmed@google.com
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

On Wed, May 11, 2022 at 2:39 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> test_progs:
> Tests new ebpf helpers bpf_map_lookup_percpu_elem.
>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  .../bpf/prog_tests/map_lookup_percpu_elem.c   | 46 ++++++++++++++++
>  .../bpf/progs/test_map_lookup_percpu_elem.c   | 54 +++++++++++++++++++
>  2 files changed, 100 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> new file mode 100644
> index 000000000000..58b24c2112b0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2022 Bytedance

/* */ instead of //

> +
> +#include <test_progs.h>
> +
> +#include "test_map_lookup_percpu_elem.skel.h"
> +
> +#define TEST_VALUE  1
> +
> +void test_map_lookup_percpu_elem(void)
> +{
> +       struct test_map_lookup_percpu_elem *skel;
> +       int key = 0, ret;
> +       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);

I think this is actually wrong and will break selftests on systems
with offline CPUs. Please use libbpf_num_possible_cpus() instead.

> +       int *buf;
> +
> +       buf = (int *)malloc(nr_cpus*sizeof(int));
> +       if (!ASSERT_OK_PTR(buf, "malloc"))
> +               return;
> +       memset(buf, 0, nr_cpus*sizeof(int));

this is wrong, kernel expects to have roundup(sz, 8) per each CPU,
while you have just 4 bytes per each element

please also have spaces around multiplication operator here and above

> +       buf[0] = TEST_VALUE;
> +
> +       skel = test_map_lookup_percpu_elem__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
> +               return;

buf leaking here

> +       ret = test_map_lookup_percpu_elem__attach(skel);
> +       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
> +
> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
> +       ASSERT_OK(ret, "percpu_array_map update");
> +
> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_hash_map), &key, buf, 0);
> +       ASSERT_OK(ret, "percpu_hash_map update");
> +
> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_lru_hash_map), &key, buf, 0);
> +       ASSERT_OK(ret, "percpu_lru_hash_map update");
> +
> +       syscall(__NR_getuid);
> +
> +       ret = skel->bss->percpu_array_elem_val == TEST_VALUE &&
> +             skel->bss->percpu_hash_elem_val == TEST_VALUE &&
> +             skel->bss->percpu_lru_hash_elem_val == TEST_VALUE;
> +       ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");

this would be better done as three separate ASSERT_EQ(), combining
into opaque true/false isn't helpful if something breaks

> +
> +       test_map_lookup_percpu_elem__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
> new file mode 100644
> index 000000000000..5d4ef86cbf48
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2022 Bytedance

/* */ instead of //

> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +int percpu_array_elem_val = 0;
> +int percpu_hash_elem_val = 0;
> +int percpu_lru_hash_elem_val = 0;
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} percpu_array_map SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_HASH);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} percpu_hash_map SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_LRU_PERCPU_HASH);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} percpu_lru_hash_map SEC(".maps");
> +
> +SEC("tp/syscalls/sys_enter_getuid")
> +int sysenter_getuid(const void *ctx)
> +{
> +       __u32 key = 0;
> +       __u32 cpu = 0;
> +       __u32 *value;
> +
> +       value = bpf_map_lookup_percpu_elem(&percpu_array_map, &key, cpu);
> +       if (value)
> +               percpu_array_elem_val = *value;
> +
> +       value = bpf_map_lookup_percpu_elem(&percpu_hash_map, &key, cpu);
> +       if (value)
> +               percpu_hash_elem_val = *value;
> +
> +       value = bpf_map_lookup_percpu_elem(&percpu_lru_hash_map, &key, cpu);
> +       if (value)
> +               percpu_lru_hash_elem_val = *value;
> +

if the test happens to run on CPU 0 then the test doesn't really test
much. It would be more interesting to have a bpf_loop() iteration that
would fetch values on each possible CPU instead and do something with
it.

> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.20.1
>
