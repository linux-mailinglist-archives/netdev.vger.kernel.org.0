Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC1B1D4116
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgENWcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728525AbgENWcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:32:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45197C061A0C;
        Thu, 14 May 2020 15:32:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id m11so627001qka.4;
        Thu, 14 May 2020 15:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TnsN39S9nBKKo+TkxtLGn4BfNS0a8Er3VZTnddGXoMk=;
        b=qlK/i0A5Sw1AoI/gLAFuoRLkqAqsN71HkWsEyMowOcgMQiB35hUS2JkKF0BHggsfEK
         eVOesLMbBV3C9o/7twYoEBq+qDkKYDuqGRNL0sIcggUsK6Z/S4jgg16zkmG+pni8J4Iz
         MDasgrBTB7yGZAViIFLc6fP1tr9JmzrL/y50wALQ7s7Z09T4hFBKG9xAjAfbQWXl2FkH
         6wcU9ppczL2fCobXgeU/bO/F7jgCTb+s/Er4NaaEYiX4T2+NH8QEBTP+84OFjN2e+UQv
         QkWPRr/9qZ8LspcqfbjkL26d/WqXkNwBHlrmhaOsySl588OLYLYzWKSecH9YyGrAC/Fw
         y+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TnsN39S9nBKKo+TkxtLGn4BfNS0a8Er3VZTnddGXoMk=;
        b=WUo1IwdqQaKWoCxp4dYtC2nPcEQuvjNyvLDm0RV4ZLkirC/wwlfN1s4I/W1KEV+FHG
         yE8f7EVmqh6yQClH1Wbz6nliM2OBs7zWongqypW3DbrPkgNTID6lg6Y5faVUhK+/hW/Y
         ZV88120ioqlZMJW11cuj4v+rcqwXDvGUXi6qAOHQXz4LDpXYCbYPV+QzlWUQ9ulrEYxa
         zOz5RDZG4/96HdRUYfT8szMNLeEM2/xpI5moEyYrMB3TA78t/MRPtspaaSD4+wegGmWO
         oLLdWuUTGA8foj3GvBXI8/Yx66ZiaNZtzlmQJevk1oEraqsd1Zgg9TnXuCY2mmVjLDn5
         kKdw==
X-Gm-Message-State: AOAM530kTp2mlrzO1WxmFuUzShpcamyoWZ1lwbTOYSvGfaE4LTeHtHT5
        DR9c7eeAZFwqKEEBS4b/JITCK9ytW9zZGhQvafk=
X-Google-Smtp-Source: ABdhPJyGchlbdOiFTzH44nrWBosZbe0MBJchGDNjknpRH/WrJkohWjcxt195BK2oHyrbVJJFEt6cxNLSeCU+12W8Aro=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr656739qkj.92.1589495560390;
 Thu, 14 May 2020 15:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-5-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:32:29 -0700
Message-ID: <CAEf4BzZXyCjjaofaOROTKCRr5fqHkdZkBHZmfiqqQiKTyOYv1Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] bpf: Allow nested BTF object to be refferenced by BTF
 object + offset
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:31 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_address function that takes 2 BTF objects
> and offset as arguments and checks wether object A is nested
> in object B on given offset.
>
> This function is be used when checking the helper function
> PTR_TO_BTF_ID arguments. If the argument has an offset value,
> the btf_struct_address will check if the final address is
> the expected BTF ID.
>
> This way we can access nested BTF objects under PTR_TO_BTF_ID
> pointer type and pass them to helpers, while they still point
> to valid kernel BTF objects.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  3 ++
>  kernel/bpf/btf.c      | 69 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 32 +++++++++++++-------
>  3 files changed, 94 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 1262ec460ab3..bc589cdd8c34 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1213,6 +1213,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                       const struct btf_type *t, int off, int size,
>                       enum bpf_access_type atype,
>                       u32 *next_btf_id);
> +int btf_struct_address(struct bpf_verifier_log *log,
> +                    const struct btf_type *t,
> +                    u32 off, u32 exp_id);
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int);
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index a2cfba89a8e1..07f22469acab 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4004,6 +4004,75 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>
> +int btf_struct_address(struct bpf_verifier_log *log,
> +                      const struct btf_type *t,
> +                      u32 off, u32 exp_id)

The logic in this function is quite tricky and overlaps heavily with
btf_struct_access. You are already missing flexible array support that
Yonghong added recently. Let's see if it's possible to extract all
this "find field in a struct by offset" logic into reusable function?

> +{
> +       u32 i, moff, mtrue_end, msize = 0;
> +       const struct btf_member *member;
> +       const struct btf_type *mtype;
> +       const char *tname, *mname;
> +
> +again:
> +       tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> +       if (!btf_type_is_struct(t)) {
> +               bpf_log(log, "Type '%s' is not a struct\n", tname);
> +               return -EINVAL;
> +       }
> +
> +       if (off > t->size) {

>=, actually?

> +               bpf_log(log, "address beyond struct %s at off %u size %u\n",
> +                       tname, off, t->size);
> +               return -EACCES;
> +       }
> +

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 70ad009577f8..b988df5ada20 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3665,6 +3665,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>  {
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>         enum bpf_reg_type expected_type, type = reg->type;
> +       const struct btf_type *btf_type;
>         int err = 0;
>
>         if (arg_type == ARG_DONTCARE)
> @@ -3743,17 +3744,28 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
>                         goto err_type;
> -               if (reg->btf_id != meta->btf_id) {
> -                       verbose(env, "Helper has type %s got %s in R%d\n",
> -                               kernel_type_name(meta->btf_id),
> -                               kernel_type_name(reg->btf_id), regno);
> +               if (reg->off) {

well, off==0 can still point to (arbitrarily) nested structs that are
first member of outer struct... So I guess it would be better to
search for inner struct if btf_id is unexpected regardless of off
value?

> +                       btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +                       if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
> +                               verbose(env, "Helper has type %s got %s in R%d, off %d\n",
> +                                       kernel_type_name(meta->btf_id),
> +                                       kernel_type_name(reg->btf_id), regno, reg->off);
>
> -                       return -EACCES;
> -               }
> -               if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
> -                       verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
> -                               regno);
> -                       return -EACCES;
> +                               return -EACCES;
> +                       }
> +               } else {
> +                       if (reg->btf_id != meta->btf_id) {
> +                               verbose(env, "Helper has type %s got %s in R%d\n",
> +                                       kernel_type_name(meta->btf_id),
> +                                       kernel_type_name(reg->btf_id), regno);
> +
> +                               return -EACCES;
> +                       }
> +                       if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
> +                               verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
> +                                       regno);
> +                               return -EACCES;
> +                       }
>                 }
>         } else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
>                 if (meta->func_id == BPF_FUNC_spin_lock) {
> --
> 2.25.4
>
