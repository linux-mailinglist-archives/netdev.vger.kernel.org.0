Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BBD58744C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiHAXRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHAXRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:17:03 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AA71571F;
        Mon,  1 Aug 2022 16:17:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id rq15so16998310ejc.10;
        Mon, 01 Aug 2022 16:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8OXsGkXzPNYuoAlENJmJBTtuEpOWte6d9Xn7bPvey3w=;
        b=VP54bwv7/eb1KQzOUK6UmmYFC+I/Brorumxmqlmtw6mRz3koO5NhD7vi2gqZuR4QCq
         xFrU+7H2/Bb3UEeLt4L8lP6Pg19Zb08aA52mTTzp6cMZm8wUUmx7PXldq8D5o0k0/bdV
         wxdkU8sgVh90z1WaVjMMGVwryy33+03UkgfS+pEEP14X4X9D/mb0l58lFrjKGBgyo7Ui
         nC/vxCmVV4LoU+bcU9reyBqTsUHBsh1RxMtE//BMs4RPuSkY6V9jUD6gtGSRMYvkgvHU
         cG5Pwqiqfx2370ePOOD8tYnvjc6yO56Qa9XM5u8rgwLUkRDNkd1FdMGKz2z6bau7r7OH
         uAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8OXsGkXzPNYuoAlENJmJBTtuEpOWte6d9Xn7bPvey3w=;
        b=hWyxiFgMGtLrBFx9aykvhZZp6NeT61ZAo3aKDcPgHL3/3X+F6nNtmgG2YQAi7GxNhN
         5ayJb30/78pF0+XiNN5qFOKJEY5yGyNcJTP+UKQi4cEx7pC+VdkMB3SLO5RYpOKPjO/F
         tGI7QASflbH0BEg2y434SXMsYizqply8mCNHX+OcTJ+yIaUMLZgUKpZQvjHJC1uBdKC6
         fa19TetjgbMNuO3qaTTYHuiGeUnjxrBOOWPC+w7PCjr/6Hjo0yLGTR/w5tCWQ4zYuNPy
         HniG9jhHItoZ5jA9RB//TrbK7r44/P/vJkQNy5kaXw72RrL3V5ZKJkmurG8dk5ezGG8C
         HJDA==
X-Gm-Message-State: AJIora9QAAkl4Y/K+IKrDt3cfCTFSBm4R7fFvByYyi4h25Rc4oZvqCm2
        FLENHZXDTNW4bdhZGJ7v7dOU+MbaTwiHenpf1Ec=
X-Google-Smtp-Source: AGRyM1vJxd/mFep8K6CGnFKBefNGT9Ceip4PPOpHGi69dZsOJKP/gF1BC9WYSnxGrjgtoeBH5OupI8E/LUswKeDGfKA=
X-Received: by 2002:a17:907:2ccc:b0:72b:6907:fce6 with SMTP id
 hg12-20020a1709072ccc00b0072b6907fce6mr14381139ejc.115.1659395819643; Mon, 01
 Aug 2022 16:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-11-laoar.shao@gmail.com>
In-Reply-To: <20220729152316.58205-11-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Aug 2022 16:16:48 -0700
Message-ID: <CAEf4BzZR41_JcQMvBfqB_7rcRZW97cJ_0WfWh7uh4Tt==A6zXw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/15] bpf: Use bpf_map_pages_alloc in ringbuf
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 8:23 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Introduce new helper bpf_map_pages_alloc() for this memory allocation.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/bpf.h  |  4 ++++
>  kernel/bpf/ringbuf.c | 27 +++++++++------------------
>  kernel/bpf/syscall.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+), 18 deletions(-)
>

[...]

>         /* Each data page is mapped twice to allow "virtual"
>          * continuous read of samples wrapping around the end of ring
> @@ -95,16 +95,10 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
>         if (!pages)
>                 return NULL;
>
> -       for (i = 0; i < nr_pages; i++) {
> -               page = alloc_pages_node(numa_node, flags, 0);
> -               if (!page) {
> -                       nr_pages = i;
> -                       goto err_free_pages;
> -               }
> -               pages[i] = page;
> -               if (i >= nr_meta_pages)
> -                       pages[nr_data_pages + i] = page;
> -       }
> +       ptr = bpf_map_pages_alloc(map, pages, nr_meta_pages, nr_data_pages,
> +                                 numa_node, flags, 0);
> +       if (!ptr)

bpf_map_pages_alloc() has some weird and confusing interface. It fills
out pages (second argument) and also returns pages as void *. Why not
just return int error (0 or -ENOMEM)? You are discarding this ptr
anyways.


But also thinking some more, bpf_map_pages_alloc() is very ringbuf
specific (which other map will have exactly the same meaning for
nr_meta_pages and nr_data_pages, where we also allocate 2 *
nr_data_pages, etc).

I don't think it makes sense to expose it as a generic internal API.
Why not keep all that inside kernel/bpf/ringbuf.c instead?

> +               goto err_free_pages;
>
>         rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
>                   VM_MAP | VM_USERMAP, PAGE_KERNEL);

[...]
