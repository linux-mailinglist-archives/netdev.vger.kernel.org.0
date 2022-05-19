Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E399A52C87B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiESARx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiESARv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:17:51 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54515A75D;
        Wed, 18 May 2022 17:17:50 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o190so4156060iof.10;
        Wed, 18 May 2022 17:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rsodxv1uujAoBr5rf41kHtNtg4fZ2kPnNV1adJVqSYw=;
        b=CET+1EbI5AcAiJaQ/OrsHIhR/yc8Y2tPT7vLYi/VH3d14Ja+x5Uafk3sjBs4VOtyKd
         CjHAMjFUqQdBykKa157xXTvWvSOGzmZTKGAtSKzbrjj6EBDudEmVV9vFeCgYH+VX2UC/
         ORx0SKMdFcD5Hs56pnJ6AmZZhHzlVk8oEjQ4NSAlYVGTinVcHC7qpNY3WO7D+/WGK2Cg
         Mv9POFNOcsHiECJVGvDebe/LxtTfphAbUVcijnFrJoV6PRiW1Zspbu4nEN0qSlWDLRq8
         B2b3tJKIBtkvtKpD7elQvYX/3u3ehMqux3cntZHi8ucs688Nkf/wyMOab9V4DE80MnOe
         SxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rsodxv1uujAoBr5rf41kHtNtg4fZ2kPnNV1adJVqSYw=;
        b=YTJLUG6hY9gUoZQETFlnCd1WyK8i3XFSLMdwQTxaBly/1fqQ4O5VRIQPbiFUk2YMzy
         230vVRIdMJygNnkCzFp8B95Opc43DYo5q4QfkaQbkL+nnv2K7ev4FUrWHX2VSVn9JBwi
         2IuO15s8PuegssyGDsJzp8UBaF/+4rVzPWwjIVkVSdDjSgqISZL1vn/exNNOxJO3DJSr
         XJDc8S+vuqskfAgGhV6psUf6Kpz3FsjapcqMx8XgEMSVIV8jYfS5Somec6NvKUyp3xay
         5GWYtAYSuT/PmPrZMt+GeT2hYfLDMpJuyauyr3zwnGjnk7p5BKpABHNEbCC4XGDXF1Xa
         b+Lg==
X-Gm-Message-State: AOAM533A9IMrmiKouQ862soD+cRAm1cWa//MacvyAorLsaGDoLHGBbNs
        PruRV9X+QS5It/fmB22eyJknC1mSWhHFo5oFRE4=
X-Google-Smtp-Source: ABdhPJyT38Rf56OZvapKSjQ6bbloRA8ZIz2svND/grgwY8nwsfLMoB6vGx85gTKcxZvN3RkryRDF1Lc4S/BHME3INSo=
X-Received: by 2002:a05:6602:248f:b0:65a:fb17:7a6b with SMTP id
 g15-20020a056602248f00b0065afb177a6bmr1073752ioe.79.1652919470125; Wed, 18
 May 2022 17:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 17:17:39 -0700
Message-ID: <CAEf4BzZ0eRh4ufQnc69B=6WQt_Oy3DNPL-TM-rsUW1KX--SBvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
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
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
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

On Sun, May 15, 2022 at 7:25 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> comments from Andrii Nakryiko, details in here:
> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
>
> use /* */ instead of //
> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> use 8 bytes for value size
> fix memory leak
> use ASSERT_EQ instead of ASSERT_OK
> add bpf_loop to fetch values on each possible CPU
>
> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
>  .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-------
>  2 files changed, 70 insertions(+), 40 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> index 58b24c2112b0..89ca170f1c25 100644
> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> @@ -1,30 +1,39 @@
> -// SPDX-License-Identifier: GPL-2.0
> -// Copyright (c) 2022 Bytedance
> +/* SPDX-License-Identifier: GPL-2.0 */

heh, so for SPDX license comment the rule is to use // in .c files :)
so keep SPDX as // and all others as /* */

> +/* Copyright (c) 2022 Bytedance */
>
>  #include <test_progs.h>
>
>  #include "test_map_lookup_percpu_elem.skel.h"
>
> -#define TEST_VALUE  1
> -
>  void test_map_lookup_percpu_elem(void)
>  {
>         struct test_map_lookup_percpu_elem *skel;
> -       int key = 0, ret;
> -       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> -       int *buf;
> +       __u64 key = 0, sum;
> +       int ret, i;
> +       int nr_cpus = libbpf_num_possible_cpus();
> +       __u64 *buf;
>
> -       buf = (int *)malloc(nr_cpus*sizeof(int));
> +       buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));

no need for casting

>         if (!ASSERT_OK_PTR(buf, "malloc"))
>                 return;
> -       memset(buf, 0, nr_cpus*sizeof(int));
> -       buf[0] = TEST_VALUE;
>
> -       skel = test_map_lookup_percpu_elem__open_and_load();
> -       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
> -               return;
> +       for (i=0; i<nr_cpus; i++)

spaces between operators

> +               buf[i] = i;
> +       sum = (nr_cpus-1)*nr_cpus/2;

same, please follow kernel code style

> +
> +       skel = test_map_lookup_percpu_elem__open();
> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
> +               goto exit;
> +

nit: keep it simple, init skel to NULL and use single cleanup goto
label that will destroy skel unconditionally (it deals with NULL just
fine)

> +       skel->rodata->nr_cpus = nr_cpus;
> +
> +       ret = test_map_lookup_percpu_elem__load(skel);
> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
> +               goto cleanup;
> +
>         ret = test_map_lookup_percpu_elem__attach(skel);
> -       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
> +               goto cleanup;
>
>         ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
>         ASSERT_OK(ret, "percpu_array_map update");

[...]
