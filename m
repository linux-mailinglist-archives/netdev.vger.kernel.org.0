Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097F3FD052
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhIAAgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhIAAgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:36:14 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3CC061575;
        Tue, 31 Aug 2021 17:35:18 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id c206so1794987ybb.12;
        Tue, 31 Aug 2021 17:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ySCqoRoWaqHTFuRNuFn2ouo7KNCaKC1FBNl++vWTZ8=;
        b=ABlx7KNBjeho6Uo90FQMTrTOy74sl7EifFBx72z/cpDpWOFtfwpEkkWP5dQU/9+JwL
         sw8dSXMpwiavgrNeEsgrSW5GzwF+t87DNiCIl4gltygxiLolWXd64kskHtgnYQOdmezI
         Ke4J6FRh6KSD6d2DQspmqvVTCnLDS8qfc9yViY3rWBRHGJCq71QdgRXPIPn14Utn5yu/
         tEJ8LerQgZMz+Y3uGMSFg+mxbvm28zmT4Y+j9Yeg3e7EVWmsumzpyM7LSsJ/LK0E5hof
         mUAXg4/kkMfj3VMRqf1NSw7H+X1dHrLnRVk17zNlm6thEc5nRs6AC4dNQo1cCO2+h394
         HoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ySCqoRoWaqHTFuRNuFn2ouo7KNCaKC1FBNl++vWTZ8=;
        b=mjAXl0QXJ9fTxPaGvOXZzgXh3CdsJE5GTU4W6oUypKR6I4TbOujNkkpJj2pENfP8Kv
         xCj3zTPkX5nCYWRrbo5eU1NHvXa+94gA96HFI/CGVii4s5OLNgWurhcR1Ki/V0R+eX6s
         xU4sYw0tSnArJowxBvmEF9/W8PkcwQyO3TFxA+wvfhrN9HTqAM1zViOFUTe5VZXSbVe3
         Cfg1SGF5V2EG4q22sKMnVv/QzVEI+aLQcZGMhfsgr1q3mCgE0C/5aYquqc0ZQ9nKRvyn
         7LIubO1j8Fe7xNl+HkkbNJGc7qxVMNS8jFrZeYZeEjFLPkCb3OW+m/6Ds/9TyRSX5agI
         CrTQ==
X-Gm-Message-State: AOAM531c7HQUaXbrEBX8Qy9EQvVJA5KYQIjhrX7MghNow+7D/5z6e5q+
        TA1x5rngObdMtop2FPO7TTu2bYkkknYwnRkwH08=
X-Google-Smtp-Source: ABdhPJzIBq7k9UykvHaZJme8ruS3ldO7UCH976dlKDRzs6riSQfZTAR7N3smMqu3wVXEY6D3AVkprwgp0SzVna7cn/A=
X-Received: by 2002:a25:1e03:: with SMTP id e3mr32556584ybe.459.1630456516365;
 Tue, 31 Aug 2021 17:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210830173424.1385796-1-memxor@gmail.com> <20210830173424.1385796-5-memxor@gmail.com>
In-Reply-To: <20210830173424.1385796-5-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 17:35:05 -0700
Message-ID: <CAEf4BzYuXnVZMH3roZw68yMeUC4eapybXKdZ0Cvrw4+d+sZ5vQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v1 4/8] libbpf: Resolve invalid kfunc calls
 with imm = 0, off = 0
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:34 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Preserve these calls as it allows verifier to succeed in loading the
> program if they are determined to be unreachable after dead code
> elimination during program load. If not, the verifier will fail at
> runtime.
>

This should be controlled by whether extern for func is weak or not,
just like we do for variables (see
bpf_object__resolve_ksym_var_btf_id()).

> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c4677ef97caa..9df90098f111 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6736,9 +6736,14 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
>         kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
>                                     &kern_btf, &kern_btf_fd);
>         if (kfunc_id < 0) {
> -               pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
> +               pr_warn("extern (func ksym) '%s': not found in kernel BTF, encoding btf_id as 0\n",
>                         ext->name);
> -               return kfunc_id;
> +               /* keep invalid kfuncs, so that verifier can load the program if
> +                * they get removed during DCE pass in the verifier.
> +                * The encoding must be insn->imm = 0, insn->off = 0.
> +                */
> +               kfunc_id = kern_btf_fd = 0;
> +               goto resolve;
>         }
>
>         if (kern_btf != obj->btf_vmlinux) {
> @@ -6798,11 +6803,18 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
>                 return -EINVAL;
>         }
>
> +resolve:
>         ext->is_set = true;
>         ext->ksym.kernel_btf_obj_fd = kern_btf_fd;
>         ext->ksym.kernel_btf_id = kfunc_id;
> -       pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
> -                ext->name, kfunc_id);
> +       if (kfunc_id) {
> +               pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
> +                        ext->name, kfunc_id);
> +       } else {
> +               ext->ksym.offset = 0;
> +               pr_debug("extern (func ksym) '%s': added special invalid kfunc with imm = 0\n",
> +                        ext->name);
> +       }
>
>         return 0;
>  }
> --
> 2.33.0
>
