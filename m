Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6240820FD64
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgF3UGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:06:05 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F25DC061755;
        Tue, 30 Jun 2020 13:06:05 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id u17so16641891qtq.1;
        Tue, 30 Jun 2020 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+1DSM8azwHJj01MW8FtYt0unkoTdWhHeEcjWCfmdEpk=;
        b=dwRKJ7mZbnnTA7g/var6ni+gWqMH78P/uVzAwl2YNSoEw6TW1xzFa/PTgHNMCPQfyv
         tuzF/e5J9C0o1l0wcBdSCFliY0KIoUVyiONG7tU9vz2mF27sENPcQkSQ4T8b7rwtkeHz
         aFFLF+E0Kkl2CK/3QBCpQai7MXHX1tAHVtGePdTsJ+RkGUQuC9a3ZYDvU0sWlZwlKD3q
         cBWn8rfMa8iXHHsBNquzAKxH+iGB+FtPnCWdgSpe68TaN9i9d9gF1AmoriAH2xHTafXq
         i5BHxSH7u4FzRNgVEpzDR9QpIkUDvW9Cjscx47HeRWB4RR5dz6BDoFO/sLa8epDO6BFt
         Y2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1DSM8azwHJj01MW8FtYt0unkoTdWhHeEcjWCfmdEpk=;
        b=mYZjTFYXZNcnZhsp/vWYJbXfcPuek8fIdyb6EaO0OL/66wsA2T+OHOXsnNKEaMyEgW
         MwE2NQnZieDQcPRSotbMG3PQu//Uhd/KleBoB3arTtuHFKNmoaHA19gPs9mbA6w1O5jb
         EP05wWb7wBv+RKdu703eEUodA8F+uFh0bLuh8MlbOjb/7qPZL/aryav0PirIHtBRCGOn
         Ft/Q3+XXxM8S3DSehpvjA2EYGyr27AAoTp2X09Ofv2i0yNUCk50F6u1IFhZk6B27T9od
         V5jLtwXFU4gaLkcGnfajiCpS5eD2E278AkIb3jLlSq9EkECReM9NyuvzBGj12EjbIUkb
         SQ7w==
X-Gm-Message-State: AOAM533m13MDBlZDk8pEeMxGsTamXEC5SRWjFsheKl2zSi9HvGwvkaIV
        v9ozaxADTgB6+IV/ElLW0P8WSqgOoY9t6qLTQQM=
X-Google-Smtp-Source: ABdhPJzSYghMGX/Wb17flBdnSqYOddwWU1TIXjSxcIpq+6cyww+NjZB5v0+E2EU+5hu2TJ0N2zleMYGRuFH2zRGYQXU=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr22429101qtp.141.1593547563998;
 Tue, 30 Jun 2020 13:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-8-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 13:05:52 -0700
Message-ID: <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be
 refferenced by BTF object + offset
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
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

On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_address function that takes 2 BTF objects
> and offset as arguments and checks whether object A is nested
> in object B on given offset.
>
> This function will be used when checking the helper function
> PTR_TO_BTF_ID arguments. If the argument has an offset value,
> the btf_struct_address will check if the final address is
> the expected BTF ID.
>
> This way we can access nested BTF objects under PTR_TO_BTF_ID
> pointer type and pass them to helpers, while they still point
> to valid kernel BTF objects.
>
> Using btf_struct_access to implement new btf_struct_address
> function, because it already walks down the given BTF object.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  3 ++
>  kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++-----
>  kernel/bpf/verifier.c | 37 +++++++++++++++---------
>  3 files changed, 87 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 3d2ade703a35..c0fd1f3037dd 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1300,6 +1300,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                       const struct btf_type *t, int off, int size,
>                       enum bpf_access_type atype,
>                       u32 *next_btf_id);
> +int btf_struct_address(struct bpf_verifier_log *log,
> +                    const struct btf_type *t,
> +                    u32 off, u32 id);
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int);
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 701a2cb5dfb2..f87e5f1dc64d 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3863,10 +3863,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>         return true;
>  }
>
> -int btf_struct_access(struct bpf_verifier_log *log,
> -                     const struct btf_type *t, int off, int size,
> -                     enum bpf_access_type atype,
> -                     u32 *next_btf_id)
> +enum access_op {
> +       ACCESS_NEXT,
> +       ACCESS_EXPECT,
> +};
> +
> +struct access_data {
> +       enum access_op op;
> +       union {
> +               u32 *next_btf_id;
> +               const struct btf_type *exp_type;
> +       };
> +};
> +
> +static int struct_access(struct bpf_verifier_log *log,
> +                        const struct btf_type *t, int off, int size,
> +                        struct access_data *data)
>  {
>         u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
>         const struct btf_type *mtype, *elem_type = NULL;
> @@ -3914,8 +3926,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                         goto error;
>
>                 off = (off - moff) % elem_type->size;
> -               return btf_struct_access(log, elem_type, off, size, atype,
> -                                        next_btf_id);
> +               return struct_access(log, elem_type, off, size, data);

hm... this should probably be `goto again;` to avoid recursion. This
should have been caught in the original patch that added this
recursive call.

>
>  error:
>                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
> @@ -4043,9 +4054,21 @@ int btf_struct_access(struct bpf_verifier_log *log,
>
>                         /* adjust offset we're looking for */
>                         off -= moff;
> +
> +                       /* We are nexting into another struct,
> +                        * check if we are crossing expected ID.
> +                        */
> +                       if (data->op == ACCESS_EXPECT && !off && t == data->exp_type)

before you can do this type check, you need to btf_type_skip_modifiers() first.

> +                               return 0;
>                         goto again;
>                 }
>
> +               /* We are interested only in structs for expected ID,
> +                * bail out.
> +                */
> +               if (data->op == ACCESS_EXPECT)
> +                       return -EINVAL;
> +
>                 if (btf_type_is_ptr(mtype)) {
>                         const struct btf_type *stype;
>                         u32 id;
> @@ -4059,7 +4082,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>
>                         stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
>                         if (btf_type_is_struct(stype)) {
> -                               *next_btf_id = id;
> +                               *data->next_btf_id = id;
>                                 return PTR_TO_BTF_ID;
>                         }
>                 }
> @@ -4083,6 +4106,36 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>
> +int btf_struct_access(struct bpf_verifier_log *log,
> +                     const struct btf_type *t, int off, int size,
> +                     enum bpf_access_type atype __maybe_unused,
> +                     u32 *next_btf_id)
> +{
> +       struct access_data data = {
> +               .op = ACCESS_NEXT,
> +               .next_btf_id = next_btf_id,
> +       };
> +
> +       return struct_access(log, t, off, size, &data);
> +}
> +
> +int btf_struct_address(struct bpf_verifier_log *log,
> +                      const struct btf_type *t,
> +                      u32 off, u32 id)
> +{
> +       const struct btf_type *type;
> +       struct access_data data = {
> +               .op = ACCESS_EXPECT,
> +       };
> +
> +       type = btf_type_by_id(btf_vmlinux, id);
> +       if (!type)
> +               return -EINVAL;
> +
> +       data.exp_type = type;
> +       return struct_access(log, t, off, 1, &data);
> +}
> +
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7de98906ddf4..da7351184295 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3808,6 +3808,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>         enum bpf_reg_type expected_type, type = reg->type;
>         enum bpf_arg_type arg_type = fn->arg_type[arg];
> +       const struct btf_type *btf_type;
>         int err = 0;
>
>         if (arg_type == ARG_DONTCARE)
> @@ -3887,24 +3888,34 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
>                         goto err_type;
> -               if (!fn->check_btf_id) {
> -                       if (reg->btf_id != meta->btf_id) {
> -                               verbose(env, "Helper has type %s got %s in R%d\n",
> +               if (reg->off) {
> +                       btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +                       if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
> +                               verbose(env, "Helper has type %s got %s in R%d, off %d\n",
>                                         kernel_type_name(meta->btf_id),
> +                                       kernel_type_name(reg->btf_id), regno, reg->off);
> +                               return -EACCES;
> +                       }
> +               } else {
> +                       if (!fn->check_btf_id) {
> +                               if (reg->btf_id != meta->btf_id) {
> +                                       verbose(env, "Helper has type %s got %s in R%d\n",
> +                                               kernel_type_name(meta->btf_id),
> +                                               kernel_type_name(reg->btf_id), regno);
> +
> +                                       return -EACCES;
> +                               }
> +                       } else if (!fn->check_btf_id(reg->btf_id, arg)) {
> +                               verbose(env, "Helper does not support %s in R%d\n",
>                                         kernel_type_name(reg->btf_id), regno);
>
>                                 return -EACCES;
>                         }

Ok, I think I'm grasping this a bit more. How about we actually don't
have two different cases (btf_struct_access and btf_struct_address),
but instead make unified btf_struct_access that will return the
earliest field that register points to (so it sort of iterates deeper
and deeper with each invocation). So e.g., let's assume we have this
type:


struct A {
  struct B {
    struct C {
      int x;
    } c;
  } b;
  struct D { int y; } d;
};

Now consider the extreme case of a BPF helper that expects a pointer
to the struct C or D (so uses a custom btf_id check function to say if
a passed argument is acceptable or not), ok?

Now you write BPF program as such, r1 has pointer to struct A,
originally (so verifier knows btf_id points to struct A):

int prog(struct A *a) {
   return fancy_helper(&a->b.c);
}

Now, when verifier checks fancy_helper first time, its btf_id check
will say "nope". But before giving up, verifier calls
btf_struct_access, it goes into struct A field, finds field b with
offset 0, it matches register's offset (always zero in this scenario),
sees that that field is a struct B, so returns that register now
points to struct B. Verifier passed that updated BTF ID to
fancy_helper's check, it still says no. Again, don't give up,
btf_struct_access again, but now register assumes it starts in struct
B. It finds field c of type struct C, so returns successfully. Again,
we are checking with fancy_helper's check_btf_id() check, now it
succeeds, so we keep register's BTF_ID as struct C and carry on.

Now assume fancy_helper only accepts struct D. So once we pass struct
C, it rejects. Again, btf_struct_access() is called, this time find
field x, which is int (and thus register is SCALAR now).
check_btf_id() rejects it, we call btf_struct_access() again, but this
time we can't really go deeper into type int, so we give up at this
point and return error.

Now, when register's offset is non-zero, the process is exactly the
same, we just need to keep locally adjusted offset, so that when we
find inner struct, we start with the offset within that struct, not
origin struct A's offset.

It's quite verbose explanation, but hopefully you get the idea. I
think implementation shouldn't be too hard, we might need to extend
register's state to have this extra local offset to get to the start
of a type we believe register points to (something like inner_offset,
or something). Then btf_struct_access can take into account both
register's off and inner_off to maintain this offset to inner type.

It should nicely work in all cases, not just partially as it is right now. WDYT?


> -               } else if (!fn->check_btf_id(reg->btf_id, arg)) {
> -                       verbose(env, "Helper does not support %s in R%d\n",
> -                               kernel_type_name(reg->btf_id), regno);
> -
> -                       return -EACCES;
> -               }
> -               if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
> -                       verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
> -                               regno);
> -                       return -EACCES;
> +                       if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
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
