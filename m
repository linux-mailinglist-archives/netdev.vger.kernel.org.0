Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578F83C1B3D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGHVvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhGHVvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:51:19 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CFBC061574;
        Thu,  8 Jul 2021 14:48:36 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y38so11366243ybi.1;
        Thu, 08 Jul 2021 14:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xEakQfDPZqzMk0enyglXM4chzTEgjaOUeR/qNJuU3OA=;
        b=Ni4PDFmlIXIfT/NY37OXWkKbHh54Cd58HRzPmq9y7BGL6cXfRJLCaWDphtDzZgR47m
         KzaSLhGT4MKJ6LXvK6Vs04KWArQiMyV5e77Dg2e2wcxGVRMh5C3XUXC56BQ4wKKRp5nP
         wZtgswyjuoVsIAGaf7QgcLfG7mTpoqUA4gnuKdqMQ/GBLlkwr/qtkxw9Pdf9gRUNDyK8
         eJSZwcliKUOV16lQtEaS2yqW91+V8+RAjhZM/4Z4WJFD30+OSgYKe5RtQtXOyFTlooX/
         gB4wPavvp9MkA86S7FS2NHHRvcGPDA43MMO2eA/zRb13ze1oE4+NF5XbYvwzQPIgdVyF
         NL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xEakQfDPZqzMk0enyglXM4chzTEgjaOUeR/qNJuU3OA=;
        b=iPj0s4z4d9pLSIgiUyalm9wD/6nJ40lUEiOWyCNrCCyL+EgPNQVfWid8JCq8rHH9QQ
         gaDa8rGdx0sW+q1gqXvIVNCiFlMX7yJj3ENNrSRnz1ue33mOxCQWJU0GUyLVtPTc8fdj
         tCx8S7re/yqTMcWMVFfWUaT50C5itIiqJYf3YW2P1pDjD002Y/GMJCtEMMn0brUsLXJl
         L669l92Dik0TZD1Ou1BPeFbORWhgK1dsAzFtY/ByHaTs7jJEKQC8JZh8SeQ2S112+hry
         Vg8PFH+ov/j1c/xFDX+xoDokxt0LR88vki0j1aqkTFJl2iO4MGB28PgOBJ0zoM3EKE7g
         pVGA==
X-Gm-Message-State: AOAM532vrG+5hZpK3IjvQv6mzgB5xjbRDORHm5q7cJdf12OuEydpDpIZ
        M+1ywhCSYvz0tRi4EdNCX4+vM2oShCAJ6DH5wdWTj+H+Ku8=
X-Google-Smtp-Source: ABdhPJx3/FvoFJlzRS1+mXtR9hdwwhA3dcTK6E3Tvev6ikSKUQtVa9nqqPDR1hdAZqxTpp0knXv7g8KJpQxw/2yiHaI=
X-Received: by 2002:a25:9942:: with SMTP id n2mr42490051ybo.230.1625780915431;
 Thu, 08 Jul 2021 14:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <1625749622-119334-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1625749622-119334-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Jul 2021 14:48:24 -0700
Message-ID: <CAEf4Bza_ua+tjxdhyy4nZ8Boeo+scipWmr_1xM1pC6N5wyuhAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'.
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 6:07 AM Shuyi Cheng <chengshuyi@linux.alibaba.com> wrote:
>
> In order to enable the older kernel to use the CO-RE feature, load the
> vmlinux btf of the specified path.
>
> Learn from Andrii's comments in [0], add the btf_custom_path parameter
> to bpf_obj_open_opts, you can directly use the skeleton's
> <objname>_bpf__open_opts function to pass in the btf_custom_path
> parameter.
>
> Prior to this, there was also a developer who provided a patch with
> similar functions. It is a pity that the follow-up did not continue to
> advance. See [1].
>
>         [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
>         [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
> v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
> v1->v2:
> -- Change custom_btf_path to btf_custom_path.
> -- If the length of btf_custom_path of bpf_obj_open_opts is too long,
>    return ERR_PTR(-ENAMETOOLONG).
> -- Add `custom BTF is in addition to vmlinux BTF`
>    with btf_custom_path field.
>
>  tools/lib/bpf/libbpf.c | 27 ++++++++++++++++++++++++---
>  tools/lib/bpf/libbpf.h |  6 +++++-
>  2 files changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce7..aed156c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -494,6 +494,10 @@ struct bpf_object {
>         struct btf *btf;
>         struct btf_ext *btf_ext;
>
> +       /* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
> +        * feature in the old kernel).
> +        */
> +       char *btf_custom_path;
>         /* Parse and load BTF vmlinux if any of the programs in the object need
>          * it at load time.
>          */
> @@ -2679,8 +2683,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
>         if (!force && !obj_needs_vmlinux_btf(obj))
>                 return 0;
>
> -       obj->btf_vmlinux = libbpf_find_kernel_btf();
> -       err = libbpf_get_error(obj->btf_vmlinux);
> +       if (obj->btf_custom_path) {
> +               obj->btf_vmlinux = btf__parse(obj->btf_custom_path, NULL);

I don't think this is right. Keep in mind the general case where
vmlinux BTF might be available, but user wants to perform CO-RE using
custom BTF (like we do in our selftests in core_reloc.c). In such
cases all the other features that rely on vmlinux BTF would use real
vmlinux BTF, but CO-RE relocations would use custom BTF. See the
original patch you are referencing, it loaded btf_override separately
from obj->btf_vmlinux.

> +               err = libbpf_get_error(obj->btf_vmlinux);
> +               pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->btf_custom_path, err);
> +       } else {
> +               obj->btf_vmlinux = libbpf_find_kernel_btf();
> +               err = libbpf_get_error(obj->btf_vmlinux);
> +       }
> +
>         if (err) {
>                 pr_warn("Error loading vmlinux BTF: %d\n", err);
>                 obj->btf_vmlinux = NULL;
> @@ -7554,7 +7565,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                    const struct bpf_object_open_opts *opts)
>  {
> -       const char *obj_name, *kconfig;
> +       const char *obj_name, *kconfig, *btf_tmp_path;
>         struct bpf_program *prog;
>         struct bpf_object *obj;
>         char tmp_name[64];
> @@ -7584,6 +7595,15 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>         obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
>         if (IS_ERR(obj))
>                 return obj;
> +
> +       btf_tmp_path = OPTS_GET(opts, btf_custom_path, NULL);
> +       if (btf_tmp_path) {
> +               if (strlen(btf_tmp_path) >= PATH_MAX)
> +                       return ERR_PTR(-ENAMETOOLONG);

we are leaking obj here

> +               obj->btf_custom_path = strdup(btf_tmp_path);
> +               if (!obj->btf_custom_path)
> +                       return ERR_PTR(-ENOMEM);

and here

> +       }
>
>         kconfig = OPTS_GET(opts, kconfig, NULL);
>         if (kconfig) {

And a few lines below. You didn't introduce this bug, I just spotted
it while reviewing your patch, but it would be nice to fix it as well.

> @@ -8702,6 +8722,7 @@ void bpf_object__close(struct bpf_object *obj)
>         for (i = 0; i < obj->nr_maps; i++)
>                 bpf_map__destroy(&obj->maps[i]);
>
> +       zfree(&obj->btf_custom_path);
>         zfree(&obj->kconfig);
>         zfree(&obj->externs);
>         obj->nr_extern = 0;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6e61342..5002d1f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -94,8 +94,12 @@ struct bpf_object_open_opts {
>          * system Kconfig for CONFIG_xxx externs.
>          */
>         const char *kconfig;
> +       /* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
> +        * feature in the old kernel).
> +        */
> +       char *btf_custom_path;
>  };
> -#define bpf_object_open_opts__last_field kconfig
> +#define bpf_object_open_opts__last_field btf_custom_path
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
> --
> 1.8.3.1
>
