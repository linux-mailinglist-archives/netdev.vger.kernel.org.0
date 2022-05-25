Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFDD53342E
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 02:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiEYAOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 20:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiEYAOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 20:14:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D50644C8;
        Tue, 24 May 2022 17:14:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jx22so25056435ejb.12;
        Tue, 24 May 2022 17:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LlvSs3obt5oULDHmS1XNERwmxsxhjqQkfPX3nHVQPYU=;
        b=LBhJPNe1HvZjQWzshs1kzM4Wi0BuHBA9dkpiWn/bfHtFpNscBaKsRhXGNEeNzyHZQB
         sIM6VNx8ZGhVRig+9p41P8jobz4zz6q2+3/85mlFX0WzfQ9EbDUGAWXriPJBFvE3o/0k
         IdeIB31f/zgIk8Zv6Fqc19cUh6O45w/OXUPHuZIZC1GRHmpk35JCUtGq1gGWMsoJCGwy
         +S3F0CjQXmlo9EvrdW4Cj+grFFlW98vjw2ghtyeZpja5/91L6yF8+7PWQ9W9gUIiGNje
         EehS6Em/rBL6RD6exJApLLq2KUPdxv8M6crek+aVg8dqygPey3u1ozVNb++jIcg7x+f1
         hIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LlvSs3obt5oULDHmS1XNERwmxsxhjqQkfPX3nHVQPYU=;
        b=QItfmaftj5DyiYvFXIBruILe5HGDs1MjICHDh3ytDXV/xw3fXE3Uq9uKm2EnFO29vx
         Jb6MW0FESB1db/7cq9SfCNhAPW+NQIV/nwFBmkIARiCbXlBrJn4KT87g7l+pHGHdHWQx
         s9tiaAvVvTtURx28Ma3RDFC4PJuqO3KkXYti4bE9AXIVtgo6Htiiwu9naS0VbrMHmCgu
         puw6/1lQb6lBTr3eRlgV9JKSZCPznd6Ym3Sf9A/tDE413lRlqS8xDtbJo4ratYEh8QLJ
         JxWhmfoU06nqAm+JdgPC6cGcfSM5JUoKZbJPjRZZ336m5jflM/xAruDeFie9VqHgtREf
         Q2BQ==
X-Gm-Message-State: AOAM532ZLEOQsUtVHITHAUQzGKV2TbH7ZQFGHFWWHJuS/mt53naNni6Q
        DC1v6hVK/69OLe4k5DpnYcVsGLVuc2J05KHOSvY=
X-Google-Smtp-Source: ABdhPJz/Wc1v3DMnWrLIeeKw/Z+TPUeHNRniVWCCCc9Js0AJxp+TOOf0HH19Jgj8KxHpjgqoh29PLsuY4vJTOoEB2JU=
X-Received: by 2002:a17:907:c26:b0:6fe:bd5e:2bb6 with SMTP id
 ga38-20020a1709070c2600b006febd5e2bb6mr16447123ejc.708.1653437644996; Tue, 24
 May 2022 17:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220524075306.32306-1-zhoufeng.zf@bytedance.com> <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 May 2022 17:13:52 -0700
Message-ID: <CAADnVQL-RQqGcfqn9kTsH=UWAG4ZKduG+zNaptiqwjECTqR37Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftest/bpf/benchs: Add bpf_map benchmark
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
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
> +       map_fd = bpf_map__fd(ctx.skel->maps.hash_map_bench);
> +       max_entries = bpf_map__max_entries(ctx.skel->maps.hash_map_bench);
> +       for (i = 0; i < max_entries; i++)
> +               bpf_map_update_elem(map_fd, &i, &i, BPF_ANY);
> +}
...
 +SEC("fentry/" SYS_PREFIX "sys_getpgid")
> +int benchmark(void *ctx)
> +{
> +       u32 key = bpf_get_prandom_u32();
> +       u64 init_val = 1;
> +
> +       bpf_map_update_elem(&hash_map_bench, &key, &init_val, BPF_ANY);
> +       return 0;
> +}

This benchmark is artificial at its extreme.
First it populates the map till max_entries and then
constantly bounces off the max_entries limit in a bpf prog.
Sometimes random_u32 will be less than max_entries
and map_update_elem will hit a fast path,
but most of the time it will fail to alloc_htab_elem()
and will fail to map_update_elem.

It does demonstrate that percpu_free_list is inefficient
when it's empty, but there is no way such a microbenchmark
justifies optimizing this corner case.

If there is a production use case please code it up in
a benchmark.

Also there is a lot of other overhead: syscall and atomic-s.
To stress map_update_elem please use a for() loop inside bpf prog.
