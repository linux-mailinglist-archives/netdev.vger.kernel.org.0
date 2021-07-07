Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1014A3BF112
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhGGUzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhGGUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 16:55:25 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C80C061574;
        Wed,  7 Jul 2021 13:52:44 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id b13so5331915ybk.4;
        Wed, 07 Jul 2021 13:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sk8sHu6LCd2EXAfBmiWFJrRWB8lEE1Gj41aKiaDQM8M=;
        b=IeNuCJJp9EceruFg/UtNe/J+C+vGnrAAXxtxF0a29KPcNHcffU3owIxVBqcArpI7vc
         T/SGJA1iooGK46dgHVKnAiN42fEB1ZnJNw2+qb5MDYVoMQxKlc2BeLs5S7NEM21rz+OW
         58waRJ+T8wLhKzooBNsq33aWZ9/yEKDTpOsSMAII27J/c7zCDNSNavLw2642J6TrtNPM
         2giOI0BCwIBoCs+zxlYn5tt0lYuRklOnseWEM8/hDf27zo7nHIN6CGkvBMUhRUp3eAng
         1Fufm/SjQAdQzeo/ZB9QZbvfJuhHIk9ek27MtHLt/tSa/VGatsaMkQ2c2Yr2Q1PeIy2D
         ynbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sk8sHu6LCd2EXAfBmiWFJrRWB8lEE1Gj41aKiaDQM8M=;
        b=foOoBqoJ4C7Uvb6B94+6ZF26ptGWIWgd9hYADOtrJ90jBWLbucatv5kwMVrPmoyMMa
         CS3SrYHnaasBQW2a4hswF0opxBlOMimyxY59Xhz494eYzNdNg502rZDLA1VvATnrmqRO
         IFCul7oECshMv+XRXO8O/aFJPR8jdkYHTiJj/jyvNukYztsarDfotGFSGufp4FTD8AhK
         cGkh2LfYZNWo/xBUZwX7x13rAMLzezm4OZgFv2sTnq6y5rCKny4bgqB22E9o+/1BqcRZ
         j4/OrAcHTExW4OnYaaZkdfZlnJb82IeNfzg+pM8Dpsa/psZyU7GZMQzPX5uQfYwYarPw
         qKJw==
X-Gm-Message-State: AOAM530v7jn3HJbR3r2Kv0rvtSCut5OtYdZ4nO6NNLfpyQKO5IlRD+pG
        oDOvN34u4UWzn4TxnefRZMeWjpv0Zo3IfVud+rA=
X-Google-Smtp-Source: ABdhPJyBSIXwel6YwRDisY/XdfX9ohxrKOhqrd6iG8lRYS3BKYhBicfPBRmYGXQKj+RWQMulNGJCA+iWIo+8VdNDOD0=
X-Received: by 2002:a25:9942:: with SMTP id n2mr34854535ybo.230.1625691163601;
 Wed, 07 Jul 2021 13:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 13:52:32 -0700
Message-ID: <CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Introduce 'custom_btf_path' to 'bpf_obj_open_opts'.
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

On Wed, Jun 23, 2021 at 9:04 PM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
> In order to enable the older kernel to use the CO-RE feature, load the
> vmlinux btf of the specified path.
>
> Learn from Andrii's comments in [0], add the custom_btf_path parameter
> to bpf_obj_open_opts, you can directly use the skeleton's
> <objname>_bpf__open_opts function to pass in the custom_btf_path
> parameter.
>
> Prior to this, there was also a developer who provided a patch with
> similar functions. It is a pity that the follow-up did not continue to
> advance. See [1].
>
>         [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
>         [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>  tools/lib/bpf/libbpf.c | 23 ++++++++++++++++++++---
>  tools/lib/bpf/libbpf.h |  6 +++++-
>  2 files changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce7..518b19f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -509,6 +509,8 @@ struct bpf_object {
>         void *priv;
>         bpf_object_clear_priv_t clear_priv;
>
> +       char *custom_btf_path;
> +
>         char path[];
>  };
>  #define obj_elf_valid(o)       ((o)->efile.elf)
> @@ -2679,8 +2681,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
>         if (!force && !obj_needs_vmlinux_btf(obj))
>                 return 0;
>
> -       obj->btf_vmlinux = libbpf_find_kernel_btf();
> -       err = libbpf_get_error(obj->btf_vmlinux);
> +       if (obj->custom_btf_path) {
> +               obj->btf_vmlinux = btf__parse(obj->custom_btf_path, NULL);
> +               err = libbpf_get_error(obj->btf_vmlinux);
> +               pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->custom_btf_path, err);
> +       } else {
> +               obj->btf_vmlinux = libbpf_find_kernel_btf();
> +               err = libbpf_get_error(obj->btf_vmlinux);
> +       }


I think it will be more flexible to treat custom_btf as an vmlinux BTF
override, just like [1] did. I can see how in some situations users
might want to treat this custom BTF as either a replacement of vmlinux
BTF or as an augmentation of vmlinux BTF for the purpose of extra
custom CO-RE relocations (e.g., something along the XDP hints that
were discussed recently). For now it's probably enough to implement
"custom BTF is a replacement for vmlinux BTF" policy and, if
necessary, add "custom BTF is in addition to vmlinux BTF" later with
extra opts flag/field.

Keep in mind that this custom BTF is only useful for BPF CO-RE
relocation. Any other kernel feature relying on vmlinux BTF (e.g.,
fentry) won't work with custom BTF because it expects correct BTF type
IDs.


> +
>         if (err) {
>                 pr_warn("Error loading vmlinux BTF: %d\n", err);
>                 obj->btf_vmlinux = NULL;
> @@ -7554,7 +7563,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                    const struct bpf_object_open_opts *opts)
>  {
> -       const char *obj_name, *kconfig;
> +       const char *obj_name, *kconfig, *tmp_btf_path;
>         struct bpf_program *prog;
>         struct bpf_object *obj;
>         char tmp_name[64];
> @@ -7584,6 +7593,13 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>         obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
>         if (IS_ERR(obj))
>                 return obj;
> +
> +       tmp_btf_path = OPTS_GET(opts, custom_btf_path, NULL);
> +       if (tmp_btf_path && strlen(tmp_btf_path) < PATH_MAX) {

if strlen() is >= PATH_MAX you'll just silently ignore it? We should
either truncate silently (because PATH_MAX is totally reasonable
assumption) or error out.

> +               obj->custom_btf_path = strdup(tmp_btf_path);
> +               if (!obj->custom_btf_path)
> +                       return ERR_PTR(-ENOMEM);
> +       }
>
>         kconfig = OPTS_GET(opts, kconfig, NULL);
>         if (kconfig) {
> @@ -8702,6 +8718,7 @@ void bpf_object__close(struct bpf_object *obj)
>         for (i = 0; i < obj->nr_maps; i++)
>                 bpf_map__destroy(&obj->maps[i]);
>
> +       zfree(&obj->custom_btf_path);
>         zfree(&obj->kconfig);
>         zfree(&obj->externs);
>         obj->nr_extern = 0;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6e61342..16e0f01 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -94,8 +94,12 @@ struct bpf_object_open_opts {
>          * system Kconfig for CONFIG_xxx externs.
>          */
>         const char *kconfig;
> +       /* Specify the path of vmlinux btf to facilitate the use of CO-RE features
> +        * in the old kernel.
> +        */
> +       char *custom_btf_path;
>  };
> -#define bpf_object_open_opts__last_field kconfig
> +#define bpf_object_open_opts__last_field custom_btf_path
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
> --
> 1.8.3.1
>
