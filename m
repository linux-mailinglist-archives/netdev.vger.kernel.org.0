Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950E923F381
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgHGUEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGUEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:04:38 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C720C061756;
        Fri,  7 Aug 2020 13:04:38 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q16so1618442ybk.6;
        Fri, 07 Aug 2020 13:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LrvLhMssASMs+wooD3CADrbL9kN/4ex8UC2yN+vfgeY=;
        b=aZ6TU4r5XR5eG5CySDeyM8k8lhkRguODa+u2IMK8aKSEucPJnBZm4D4kVM89n7Qj6X
         WeDKIXLompGy55Ca7FmtrOCc5KnDzhGQppMnhI7AKgxZxNk0LqwYaxSAEoSaao9y7cyk
         2m2v3SvfW7zKTts+JjfrcIwVtSHCEQEWHK2EiENQAonY18KIP0oLanODk8VvX2cbTBMu
         btAQIs8X/9hDSo2kZnBIwi70RQnP6ixMXk3U87/c0N9pkeQ2/YyN+rAlyr2g263TPZV1
         Tst3aNxsEIK4osIF9xgUd9YYfUp5LO31qOTT7p6K1bUkVBRpUkkV/KmMjZMPIwi9jFND
         lXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LrvLhMssASMs+wooD3CADrbL9kN/4ex8UC2yN+vfgeY=;
        b=FZOEna5xSlL5K3KPv3CZznlD5DVNCgkzI2Df5gLh+iUeJkb9Xo7uGEpCQKo5890eWJ
         Kv3W1+sYqyFHDRMT28HCJyPGXAhZz4yfVg66E3mwYKRdJftaxPAlsNEU50kPUUNliZA9
         p+9NBklNpYKLV36ULnpwdP9kxs75jrSSBaeTbT/A8x/XASDmtO4ITIy4EXSE/7QUoABE
         sI5YQi6fQ3IBAcGd7r3O8CetctrVdP8EUWXat1x1yhiPs2p8oRTgYTejp0chvZqpBNff
         pKwOnSjBen9daLGHMDUubg/A44h7mmVAwYY7qrOuMNBezf8SPKVFNJHgJ2t3QjyQjhS1
         a8eQ==
X-Gm-Message-State: AOAM533ZWlz4+DA7n/ruHOjX671HoiVKRjGUdcXd+9DWRApu9R9irb8a
        irzJkdGCcxofNFZGDkHeVRz5pPILydbJ2d18lpw=
X-Google-Smtp-Source: ABdhPJxnnAhSu1vfEANXpPHAoPErhwfZg49kF6OHxU2h15gLHPY4Fc9GTj5oI+cQsQqgrW1K+/qzGKSuNs9QAuPV4dI=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr24086935ybg.347.1596830677695;
 Fri, 07 Aug 2020 13:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200807094559.571260-1-jolsa@kernel.org> <20200807094559.571260-9-jolsa@kernel.org>
In-Reply-To: <20200807094559.571260-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Aug 2020 13:04:26 -0700
Message-ID: <CAEf4BzY8vE8k9c5fBB+3mcEpxOWc38dWBK8ji2aRpHM79nra_Q@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 08/14] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 2:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_ids_match function to check if given address provided
> by BTF object + offset is also address of another nested BTF object.
>
> This allows to pass an argument to helper, which is defined via parent
> BTF object + offset, like for bpf_d_path (added in following changes):
>
>   SEC("fentry/filp_close")
>   int BPF_PROG(prog_close, struct file *file, void *id)
>   {
>     ...
>     ret = bpf_d_path(&file->f_path, ...
>
> The first bpf_d_path argument is hold by verifier as BTF file object
> plus offset of f_path member.
>
> The btf_struct_ids_match function will walk the struct file object and
> check if there's nested struct path object on the given offset.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      | 31 +++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 18 ++++++++++++------
>  3 files changed, 45 insertions(+), 6 deletions(-)
>

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b6ccfce3bf4c..041d151be15b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3960,16 +3960,21 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                                 goto err_type;
>                 }
>         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
> +               bool ids_match = false;
> +
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
>                         goto err_type;
>                 if (!fn->check_btf_id) {
>                         if (reg->btf_id != meta->btf_id) {
> -                               verbose(env, "Helper has type %s got %s in R%d\n",
> -                                       kernel_type_name(meta->btf_id),
> -                                       kernel_type_name(reg->btf_id), regno);
> -
> -                               return -EACCES;
> +                               ids_match = btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
> +                                                                meta->btf_id);
> +                               if (!ids_match) {
> +                                       verbose(env, "Helper has type %s got %s in R%d\n",
> +                                               kernel_type_name(meta->btf_id),
> +                                               kernel_type_name(reg->btf_id), regno);
> +                                       return -EACCES;
> +                               }
>                         }
>                 } else if (!fn->check_btf_id(reg->btf_id, arg)) {

Put this on a wishlist for now. I don't think we should expect
fb->check_btf_id() to do btf_struct_ids_match() internally, so to
support this, we'd have to call fb->check_btf_id() inside the loop
while doing WALK_STRUCT struct. But let's not change all this in this
patch set, it's involved enough already.

>                         verbose(env, "Helper does not support %s in R%d\n",
> @@ -3977,7 +3982,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>
>                         return -EACCES;
>                 }
> -               if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
> +               if (!ids_match &&
> +                   (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off)) {

Isn't this still wrong? if ids_match, but reg->var_off is non-zero,
that's still bad, right?
ids_match just "mitigates" reg->off check, so should be something like this:

if ((reg->off && !ids_match) || !tnum_is_const(reg->var_off) ||
reg->var_off.value)
 ... then bad ...

>                         verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
>                                 regno);
>                         return -EACCES;
> --
> 2.25.4
>
