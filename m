Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95823CB1B8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhGPEyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhGPEyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:54:45 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D27FC06175F;
        Thu, 15 Jul 2021 21:51:50 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id g5so12810795ybu.10;
        Thu, 15 Jul 2021 21:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZOKpKFYgjHW50PMmYKSx4ZCJG/+r41CwlwkRApL2oo=;
        b=Pdpt1XTD7FI9phIjoTD8KQA1HKCoUQcOqXw9wesHD5Ov9rlqEC4jBLJCAH7mzPV1d+
         L3DYVhebtRw7aLMHa/J9HyVzxPxuPCnOPugAmM+6Dd408gr0lwiKeIbaJBJBap1ki5wz
         2+dThjnWu0ac8ydA8gnL98v7c8PdbtTm+ZBsDRCvDatHvJ4sCkvwEWFe7klgbtsNxrdA
         S/k5YRT8wXf/ilraAYurpChCwySWXJ5E0npfvu+fABycIwVlsK7Z9A3r5PSWZLhIe3oy
         48HQ+uDxOaQF9qz6OOAHExeRNqgEcpzexbpGvp7nfYSQ+KlsLn1TgDKCs9UxcY/XGhKe
         u/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZOKpKFYgjHW50PMmYKSx4ZCJG/+r41CwlwkRApL2oo=;
        b=kKPKWQYnJC8Iy4PTPH625sJwqBLnjtl4H8021+QuwwRqe4vFgomhMd85cBGNy26xNR
         vRN7FVzFcFTr1zzJsinw42uaFg6ldAwmRNNlouKA//iKQv68Td1qXhL0L8AuIUGRloNO
         BcmgoCw7Zq3sNgKrAdqwiDOMR2+KovsbH0OiG92CbKKxFJON6S7CxUCY+Gxf3FtQq5X+
         kY54159O2LjUwWrmas5nWnVHLRrp58sFCSYfNjQXsh3uw0L20ckeGqzKqfxLgBlB1L6f
         zByFGlrhKS5UlC4wI2S6Cb/WSPQrGz3yCjs6YCAfnFLMdfkUE0MuraeNJKnwHT3vya4R
         YY7A==
X-Gm-Message-State: AOAM531i8JajTmm3MCYSqno0FQrtOMB7ehvvJ9cD8FNqMcqdTTAhXbGc
        IgzwuKdF+VAb4hRdqM/aNBff1VJ/+8fnsHleSyE=
X-Google-Smtp-Source: ABdhPJzMaHu7LBAJDa59YJsK/roYpfbE+HY4wTwJchpa109Yw0nvemiIGyNpgY03YDJmB90qRkvOA8q1u9CyLGOYfps=
X-Received: by 2002:a25:d349:: with SMTP id e70mr10203729ybf.510.1626411109339;
 Thu, 15 Jul 2021 21:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com> <1626180159-112996-2-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1626180159-112996-2-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:51:38 -0700
Message-ID: <CAEf4BzawyyJ0hhvmSM8ba817VffOV2O3qG49fqh+VFseiixigA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
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

On Tue, Jul 13, 2021 at 5:43 AM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
> btf_custom_path allows developers to load custom BTF, and subsequent
> CO-RE will use custom BTF for relocation.
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
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>  tools/lib/bpf/libbpf.c | 36 ++++++++++++++++++++++++++++++------
>  tools/lib/bpf/libbpf.h |  9 ++++++++-
>  2 files changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce7..6e11a7b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -498,6 +498,13 @@ struct bpf_object {
>          * it at load time.
>          */
>         struct btf *btf_vmlinux;
> +       /* Path to the custom BTF to be used for BPF CO-RE relocations.
> +        * This custom BTF completely replaces the use of vmlinux BTF
> +        * for the purpose of CO-RE relocations.
> +        * NOTE: any other BPF feature (e.g., fentry/fexit programs,
> +        * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
> +        */

this comment completely duplicates the one from bpf_object_open_opts,
I'll remove or shorten it

> +       char *btf_custom_path;
>         /* vmlinux BTF override for CO-RE relocations */
>         struct btf *btf_vmlinux_override;
>         /* Lazily initialized kernel module BTFs */
> @@ -2645,10 +2652,6 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
>         struct bpf_program *prog;
>         int i;
>
> -       /* CO-RE relocations need kernel BTF */
> -       if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
> -               return true;
> -
>         /* Support for typed ksyms needs kernel BTF */
>         for (i = 0; i < obj->nr_extern; i++) {
>                 const struct extern_desc *ext;
> @@ -2665,6 +2668,13 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
>                         return true;
>         }
>
> +       /* CO-RE relocations need kernel BTF, only when btf_custom_path
> +        * is not specified
> +        */
> +       if (obj->btf_ext && obj->btf_ext->core_relo_info.len
> +               && !obj->btf_custom_path)
> +               return true;

not sure why you moved it, I'll move it back to minimize code churn

> +
>         return false;
>  }
>

[...]
