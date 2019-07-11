Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65464F8E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 02:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfGKA3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 20:29:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43226 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfGKA3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 20:29:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so4510935qto.10;
        Wed, 10 Jul 2019 17:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdFy1oYuF+2988TflbgaAqBXBgAWd2V809ovyhykIzE=;
        b=pFYq36uZcLxE6ARZQu9x86GdDJYBKtiaWXG93LxhzSlTkQFsunZDUAF7oHDvRYEHbK
         XQ2GBlLrObWtPjV+fjYfaK4PhICZoO85fOrMMq2DCpkCIwZ2xUmXlDeGxD00lPJ54KNY
         B/KnmSAQp+hFzCW44S0bbRmHP4/hS+U2x0R33J4as2xUsmldRIGkJJzT+qL4iUFw5v9U
         9j4j0VZHthdlBi/lmkH/BDagQtTPDrTSDd0deCAys4uVO+2X1c8r2v9lhpZucLCwORo6
         OjPNdwGNe5usntXPuemGHQraw3bLpcP0dsMc3dVQ3KXv+W74i3o6sq92Qk2xAqjFBUZ3
         rFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdFy1oYuF+2988TflbgaAqBXBgAWd2V809ovyhykIzE=;
        b=SycUW6xYX+tNXecscg6WsV/Vtg5h5L/9Qr4mL/7WYxbnvtZ8LXdNPIfNqzUmKjTP2Q
         1Mdm6P5rE20TqP0JUvrdwg3hwmZUR8/qSY8VBduuCBv17lW2MtQHVHDm/oXXbBetQgQh
         Mo5hGHAU2XRsKkFwTn4IK7ZDS3xwnzBFgQQfIlT3+oUQcg4jIRagkfdqQ6BxOgy2ggfo
         moWAKsRwi1km08CIvY5NI76JfrWI/jEmR4NyG61txuvk6Z3Ezf/vP4TOadv+HHqO7g/M
         XefZjt3AZIpsJ3CyYJ9xjnsgdS8biVdgmh3DvD3pM8JIqSOM8xwXb7RSWkw5o4w7uaWw
         1nqg==
X-Gm-Message-State: APjAAAWKvOjYuqEtr/EiZ25aJ1gGS2ncjSKBNBhJrSTNEOYYo2WQG2gU
        eWJuj7kG9kclt/YaXBy57LAOb9D0djR6ywagU7s=
X-Google-Smtp-Source: APXvYqxuk7skt4KIjrDXOLI4T1Lcl7pJBdTa7ad746v+GO2dJ4+htkboTME3vmTKOPsQWfH21zttkyOPuO/XtXSGkWA=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr668035qty.141.1562804975058;
 Wed, 10 Jul 2019 17:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190710080840.2613160-1-andriin@fb.com> <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
In-Reply-To: <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 17:29:24 -0700
Message-ID: <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix BTF verifier size resolution logic
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/19 1:08 AM, Andrii Nakryiko wrote:
> > BTF verifier has Different logic depending on whether we are following
> > a PTR or STRUCT/ARRAY (or something else). This is an optimization to
> > stop early in DFS traversal while resolving BTF types. But it also
> > results in a size resolution bug, when there is a chain, e.g., of PTR ->
> > TYPEDEF -> ARRAY, in which case due to being in pointer context ARRAY
> > size won't be resolved, as it is considered to be a sink for pointer,
> > leading to TYPEDEF being in RESOLVED state with zero size, which is
> > completely wrong.
> >
> > Optimization is doubtful, though, as btf_check_all_types() will iterate
> > over all BTF types anyways, so the only saving is a potentially slightly
> > shorter stack. But correctness is more important that tiny savings.
> >
> > This bug manifests itself in rejecting BTF-defined maps that use array
> > typedef as a value type:
> >
> > typedef int array_t[16];
> >
> > struct {
> >       __uint(type, BPF_MAP_TYPE_ARRAY);
> >       __type(value, array_t); /* i.e., array_t *value; */
> > } test_map SEC(".maps");
> >
> > Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> The change seems okay to me. Currently, looks like intermediate
> modifier type will carry size = 0 (in the internal data structure).

Yes, which is totally wrong, especially that we use that size in some
cases to reject map with specified BTF.

>
> If we remove RESOLVE logic, we probably want to double check
> whether we handle circular types correctly or not. Maybe we will
> be okay if all self tests pass.

I checked, it does. We'll attempt to add referenced type unless it's a
"resolve sink" (where size is immediately known) or is already
resolved (it's state is RESOLVED). In other cases, we'll attempt to
env_stack_push(), which check that the state of that type is
NOT_VISITED. If it's RESOLVED or VISITED, it returns -EEXISTS. When
type is added into the stack, it's resolve state goes from NOT_VISITED
to VISITED.

So, if there is a loop, then we'll detect it as soon as we'll attempt
to add the same type onto the stack second time.

>
> I may still be worthwhile to qualify the RESOLVE optimization benefit
> before removing it.

I don't think there is any, because every type will be visited exactly
once, due to DFS nature of algorithm. The only difference is that if
we have a long chain of modifiers, we can technically reach the max
limit and fail. But at 32 I think it's pretty unrealistic to have such
a long chain of PTR/TYPEDEF/CONST/VOLATILE/RESTRICTs :)

>
> Another possible change is, for external usage, removing
> modifiers, before checking the size, something like below.
> Note that I am not strongly advocating my below patch as
> it has the same shortcoming that maintained modifier type
> size may not be correct.

I don't think your patch helps, it can actually confuse things even
more. It skips modifiers until underlying type is found, but you still
don't guarantee that at that time that underlying type will have its
size resolved.

>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 546ebee39e2a..6f927c3e0a89 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -620,6 +620,54 @@ static bool btf_type_int_is_regular(const struct
> btf_type *t)
>          return true;
>   }
>
> +static const struct btf_type *__btf_type_id_size(const struct btf *btf,
> +                                                u32 *type_id, u32
> *ret_size,
> +                                                bool skip_modifier)
> +{
> +       const struct btf_type *size_type;
> +       u32 size_type_id = *type_id;
> +       u32 size = 0;
> +
> +       size_type = btf_type_by_id(btf, size_type_id);
> +       if (size_type && skip_modifier) {
> +               while (btf_type_is_modifier(size_type))
> +                       size_type = btf_type_by_id(btf, size_type->type);
> +       }
> +
> +       if (btf_type_nosize_or_null(size_type))
> +               return NULL;
> +
> +       if (btf_type_has_size(size_type)) {
> +               size = size_type->size;
> +       } else if (btf_type_is_array(size_type)) {
> +               size = btf->resolved_sizes[size_type_id];
> +       } else if (btf_type_is_ptr(size_type)) {
> +               size = sizeof(void *);
> +       } else {
> +               if (WARN_ON_ONCE(!btf_type_is_modifier(size_type) &&
> +                                !btf_type_is_var(size_type)))
> +                       return NULL;
> +
> +               size = btf->resolved_sizes[size_type_id];
> +               size_type_id = btf->resolved_ids[size_type_id];
> +               size_type = btf_type_by_id(btf, size_type_id);
> +               if (btf_type_nosize_or_null(size_type))
> +                       return NULL;
> +       }
> +
> +       *type_id = size_type_id;
> +       if (ret_size)
> +               *ret_size = size;
> +
> +       return size_type;
> +}
> +
> +const struct btf_type *btf_type_id_size(const struct btf *btf,
> +                                       u32 *type_id, u32 *ret_size)
> +{
> +       return __btf_type_id_size(btf, type_id, ret_size, true);
> +}
> +
>   /*
>    * Check that given struct member is a regular int with expected
>    * offset and size.
> @@ -633,7 +681,7 @@ bool btf_member_is_reg_int(const struct btf *btf,
> const struct btf_type *s,
>          u8 nr_bits;
>
>          id = m->type;
> -       t = btf_type_id_size(btf, &id, NULL);
> +       t = __btf_type_id_size(btf, &id, NULL, false);
>          if (!t || !btf_type_is_int(t))
>                  return false;
>
> @@ -1051,42 +1099,6 @@ static const struct btf_type
> *btf_type_id_resolve(const struct btf *btf,
>          return btf_type_by_id(btf, *type_id);
>   }
>
> -const struct btf_type *btf_type_id_size(const struct btf *btf,
> -                                       u32 *type_id, u32 *ret_size)
> -{
> -       const struct btf_type *size_type;
> -       u32 size_type_id = *type_id;
> -       u32 size = 0;
> -
> -       size_type = btf_type_by_id(btf, size_type_id);
> -       if (btf_type_nosize_or_null(size_type))
> -               return NULL;
> -
> -       if (btf_type_has_size(size_type)) {
> -               size = size_type->size;
> -       } else if (btf_type_is_array(size_type)) {
> -               size = btf->resolved_sizes[size_type_id];
> -       } else if (btf_type_is_ptr(size_type)) {
> -               size = sizeof(void *);
> -       } else {
> -               if (WARN_ON_ONCE(!btf_type_is_modifier(size_type) &&
> -                                !btf_type_is_var(size_type)))
> -                       return NULL;
> -
> -               size = btf->resolved_sizes[size_type_id];
> -               size_type_id = btf->resolved_ids[size_type_id];
> -               size_type = btf_type_by_id(btf, size_type_id);
> -               if (btf_type_nosize_or_null(size_type))
> -                       return NULL;
> -       }
> -
> -       *type_id = size_type_id;
> -       if (ret_size)
> -               *ret_size = size;
> -
> -       return size_type;
> -}
> -
>   static int btf_df_check_member(struct btf_verifier_env *env,
>                                 const struct btf_type *struct_type,
>                                 const struct btf_member *member,
> @@ -1489,7 +1501,7 @@ static int btf_modifier_check_member(struct
> btf_verifier_env *env,
>          struct btf_member resolved_member;
>          struct btf *btf = env->btf;
>
> -       resolved_type = btf_type_id_size(btf, &resolved_type_id, NULL);
> +       resolved_type = __btf_type_id_size(btf, &resolved_type_id, NULL,
> false);
>          if (!resolved_type) {
>                  btf_verifier_log_member(env, struct_type, member,
>                                          "Invalid member");
> @@ -1514,7 +1526,7 @@ static int btf_modifier_check_kflag_member(struct
> btf_verifier_env *env,
>          struct btf_member resolved_member;
>          struct btf *btf = env->btf;
>
> -       resolved_type = btf_type_id_size(btf, &resolved_type_id, NULL);
> +       resolved_type = __btf_type_id_size(btf, &resolved_type_id, NULL,
> false);
>          if (!resolved_type) {
>                  btf_verifier_log_member(env, struct_type, member,
>                                          "Invalid member");
> @@ -1620,7 +1632,7 @@ static int btf_modifier_resolve(struct
> btf_verifier_env *env,
>           * save us a few type-following when we use it later (e.g. in
>           * pretty print).
>           */
> -       if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
> +       if (!__btf_type_id_size(btf, &next_type_id, &next_type_size,
> false)) {
>                  if (env_type_is_resolved(env, next_type_id))
>                          next_type = btf_type_id_resolve(btf,
> &next_type_id);
>
> @@ -1675,7 +1687,7 @@ static int btf_var_resolve(struct btf_verifier_env
> *env,
>           * forward types or similar that would resolve to size of
>           * zero is allowed.
>           */
> -       if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
> +       if (!__btf_type_id_size(btf, &next_type_id, &next_type_size,
> false)) {
>                  btf_verifier_log_type(env, v->t, "Invalid type_id");
>                  return -EINVAL;
>          }
> @@ -1725,7 +1737,7 @@ static int btf_ptr_resolve(struct btf_verifier_env
> *env,
>                                                resolved_type_id);
>          }
>
> -       if (!btf_type_id_size(btf, &next_type_id, NULL)) {
> +       if (!__btf_type_id_size(btf, &next_type_id, NULL, false)) {
>                  if (env_type_is_resolved(env, next_type_id))
>                          next_type = btf_type_id_resolve(btf,
> &next_type_id);
>
> @@ -1851,7 +1863,7 @@ static int btf_array_check_member(struct
> btf_verifier_env *env,
>          }
>
>          array_type_id = member->type;
> -       btf_type_id_size(btf, &array_type_id, &array_size);
> +       __btf_type_id_size(btf, &array_type_id, &array_size, false);
>          struct_size = struct_type->size;
>          bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
>          if (struct_size - bytes_offset < array_size) {
> @@ -1938,7 +1950,7 @@ static int btf_array_resolve(struct
> btf_verifier_env *env,
>              !env_type_is_resolved(env, index_type_id))
>                  return env_stack_push(env, index_type, index_type_id);
>
> -       index_type = btf_type_id_size(btf, &index_type_id, NULL);
> +       index_type = __btf_type_id_size(btf, &index_type_id, NULL, false);
>          if (!index_type || !btf_type_is_int(index_type) ||
>              !btf_type_int_is_regular(index_type)) {
>                  btf_verifier_log_type(env, v->t, "Invalid index");
> @@ -1959,7 +1971,7 @@ static int btf_array_resolve(struct
> btf_verifier_env *env,
>              !env_type_is_resolved(env, elem_type_id))
>                  return env_stack_push(env, elem_type, elem_type_id);
>
> -       elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
> +       elem_type = __btf_type_id_size(btf, &elem_type_id, &elem_size,
> false);
>          if (!elem_type) {
>                  btf_verifier_log_type(env, v->t, "Invalid elem");
>                  return -EINVAL;
> @@ -2000,7 +2012,7 @@ static void btf_array_seq_show(const struct btf
> *btf, const struct btf_type *t,
>          u32 i, elem_size, elem_type_id;
>
>          elem_type_id = array->type;
> -       elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
> +       elem_type = __btf_type_id_size(btf, &elem_type_id, &elem_size,
> false);
>          elem_ops = btf_type_ops(elem_type);
>          seq_puts(m, "[");
>          for (i = 0; i < array->nelems; i++) {
> @@ -2732,7 +2744,7 @@ static int btf_datasec_resolve(struct
> btf_verifier_env *env,
>                  }
>
>                  type_id = var_type->type;
> -               if (!btf_type_id_size(btf, &type_id, &type_size)) {
> +               if (!__btf_type_id_size(btf, &type_id, &type_size, false)) {
>                          btf_verifier_log_vsi(env, v->t, vsi, "Invalid
> type");
>                          return -EINVAL;
>                  }
> @@ -2813,7 +2825,7 @@ static int btf_func_proto_check(struct
> btf_verifier_env *env,
>                  }
>
>                  /* Ensure the return type is a type that has a size */
> -               if (!btf_type_id_size(btf, &ret_type_id, NULL)) {
> +               if (!__btf_type_id_size(btf, &ret_type_id, NULL, false)) {
>                          btf_verifier_log_type(env, t, "Invalid return
> type");
>                          return -EINVAL;
>                  }
> @@ -2861,7 +2873,7 @@ static int btf_func_proto_check(struct
> btf_verifier_env *env,
>                                  break;
>                  }
>
> -               if (!btf_type_id_size(btf, &arg_type_id, NULL)) {
> +               if (!__btf_type_id_size(btf, &arg_type_id, NULL, false)) {
>                          btf_verifier_log_type(env, t, "Invalid arg#%u",
> i + 1);
>                          err = -EINVAL;
>                          break;
> @@ -3014,7 +3026,7 @@ static bool btf_resolve_valid(struct
> btf_verifier_env *env,
>                  u32 elem_type_id = array->type;
>                  u32 elem_size;
>
> -               elem_type = btf_type_id_size(btf, &elem_type_id,
> &elem_size);
> +               elem_type = __btf_type_id_size(btf, &elem_type_id,
> &elem_size, false);
>                  return elem_type && !btf_type_is_modifier(elem_type) &&
>                          (array->nelems * elem_size ==
>                           btf->resolved_sizes[type_id]);
>
>
> > ---
> >   kernel/bpf/btf.c | 42 +++---------------------------------------
> >   1 file changed, 3 insertions(+), 39 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index cad09858a5f2..c68c7e73b0d1 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -231,14 +231,6 @@ enum visit_state {
> >       RESOLVED,
> >   };
> >
> > -enum resolve_mode {
> > -     RESOLVE_TBD,    /* To Be Determined */
> > -     RESOLVE_PTR,    /* Resolving for Pointer */
> > -     RESOLVE_STRUCT_OR_ARRAY,        /* Resolving for struct/union
> > -                                      * or array
> > -                                      */
> > -};
> > -
> >   #define MAX_RESOLVE_DEPTH 32
> >
> >   struct btf_sec_info {
> > @@ -254,7 +246,6 @@ struct btf_verifier_env {
> >       u32 log_type_id;
> >       u32 top_stack;
> >       enum verifier_phase phase;
> > -     enum resolve_mode resolve_mode;
> >   };
> >
> >   static const char * const btf_kind_str[NR_BTF_KINDS] = {
> > @@ -964,26 +955,7 @@ static void btf_verifier_env_free(struct btf_verifier_env *env)
> >   static bool env_type_is_resolve_sink(const struct btf_verifier_env *env,
> >                                    const struct btf_type *next_type)
> >   {
> > -     switch (env->resolve_mode) {
> > -     case RESOLVE_TBD:
> > -             /* int, enum or void is a sink */
> > -             return !btf_type_needs_resolve(next_type);
> > -     case RESOLVE_PTR:
> > -             /* int, enum, void, struct, array, func or func_proto is a sink
> > -              * for ptr
> > -              */
> > -             return !btf_type_is_modifier(next_type) &&
> > -                     !btf_type_is_ptr(next_type);
> > -     case RESOLVE_STRUCT_OR_ARRAY:
> > -             /* int, enum, void, ptr, func or func_proto is a sink
> > -              * for struct and array
> > -              */
> > -             return !btf_type_is_modifier(next_type) &&
> > -                     !btf_type_is_array(next_type) &&
> > -                     !btf_type_is_struct(next_type);
> > -     default:
> > -             BUG();
> > -     }
> > +     return !btf_type_needs_resolve(next_type);
> >   }
> >
> >   static bool env_type_is_resolved(const struct btf_verifier_env *env,
> > @@ -1010,13 +982,6 @@ static int env_stack_push(struct btf_verifier_env *env,
> >       v->type_id = type_id;
> >       v->next_member = 0;
> >
> > -     if (env->resolve_mode == RESOLVE_TBD) {
> > -             if (btf_type_is_ptr(t))
> > -                     env->resolve_mode = RESOLVE_PTR;
> > -             else if (btf_type_is_struct(t) || btf_type_is_array(t))
> > -                     env->resolve_mode = RESOLVE_STRUCT_OR_ARRAY;
> > -     }
> > -
> >       return 0;
> >   }
> >
> > @@ -1038,7 +1003,7 @@ static void env_stack_pop_resolved(struct btf_verifier_env *env,
> >       env->visit_states[type_id] = RESOLVED;
> >   }
> >
> > -static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
> > +static const struct resolve_vertex *env_stack_peek(struct btf_verifier_env *env)
> >   {
> >       return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
> >   }
> > @@ -3030,9 +2995,8 @@ static int btf_resolve(struct btf_verifier_env *env,
> >       const struct resolve_vertex *v;
> >       int err = 0;
> >
> > -     env->resolve_mode = RESOLVE_TBD;
> >       env_stack_push(env, t, type_id);
> > -     while (!err && (v = env_stack_peak(env))) {
> > +     while (!err && (v = env_stack_peek(env))) {
> >               env->log_type_id = v->type_id;
> >               err = btf_type_ops(v->t)->resolve(env, v);
> >       }
> >
