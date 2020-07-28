Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A31231634
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgG1X1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbgG1X1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:27:33 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EDBC061794;
        Tue, 28 Jul 2020 16:27:33 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id b25so16298696qto.2;
        Tue, 28 Jul 2020 16:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xIYlyM8/86mLWyFe3YhLa/A97OeY2j7nPQjLGoA1kk=;
        b=DP/y+up5onnu/MFa4Rmw9IQiNaQ3OmfLKpWZJ1J4AfryhMzwm6qP22DKD+dUHi6pfe
         INQ7xuD1aBIrQPA9TbQ2uxXqXh17c/BFJ/7Y92w1U90ipYMmt42G/DIvvD+HR7/oMGaF
         DWzaos+jTFQ4DtULeCWHGqSuL5SnD6IPmeD15mwwaKfOGnFR3HuE9sjtxdGDxQ3h5p1z
         ox7M6TKqwI9husFui/kR/SXIWAnYqRrJxWIErEvCgpEq+Cf4naJAQKFF6cWTw/wvjdo1
         b/pmRxcX+PJzOgGkrgHb+zw29BjYIfC4+JQuQ2DsLG/umcJN0nLtWHnlAdj6nJNqzUEK
         0DCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xIYlyM8/86mLWyFe3YhLa/A97OeY2j7nPQjLGoA1kk=;
        b=QKIejPmkaRC7bV88c48YiRrNDYfg6mntP2YRnfVRvTKaf33+sIZcbFBKeadv+SZ38Z
         WXxNq7RwTW7ujR+j5POXP+zkrAd1EvS5hwZDA9N2JUlFvqwgg0N56fx3f3Ndezpp8Hw1
         lyMfhbnEmD09hd7NvA+wnKbt2Mvm0jxq5EwKt/MIUFRyoxlZJWqVPHQJo5WofYsAyQA0
         J4wEDm/QxP/RijeDlpdf45dziIMnY5LXhQFUJcah9qdJMrWpeB3u0dH+hzDEVutMxhmU
         Gkv4r8bg4Nx4V5hCldvzNEpTlOGMLDLMTS8pxOOCgOX/5nbuwi2MSzAeqWl4vC3/jpk4
         bfkw==
X-Gm-Message-State: AOAM533HeAOzuWUwKiFSSOIUB3t/BREu45tDAXQpyF0Xp1gGXlgRB2yH
        sDDITSNRII3DakZXPTaGvTPjr9dpr2Av4Bck4nWEvoN/
X-Google-Smtp-Source: ABdhPJw+L8OdZ1SVHLd9LQsVcEWQFTXyCjjFIU3tA0fy29fn9tvotlLGgfNy6ZaXHvAOZhz5MvR1Es2c7C+Uc0FeyWA=
X-Received: by 2002:ac8:777a:: with SMTP id h26mr28882070qtu.141.1595978852533;
 Tue, 28 Jul 2020 16:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-7-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 16:27:21 -0700
Message-ID: <CAEf4BzbS_JFW70Z_68hDtN4VTkLfohkR0PV0d9jCJRjZEhc01Q@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 06/13] bpf: Factor btf_struct_access function
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

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_walk function that walks through the
> struct type + given offset and returns following values:
>
>   enum walk_return {
>        /* < 0 error */
>        walk_scalar = 0,
>        walk_ptr,
>        walk_struct,
>   };
>
> walk_scalar - when SCALAR_VALUE is found
> walk_ptr    - when pointer value is found, its ID is stored
>               in 'rid' output param
> walk_struct - when nested struct object is found, its ID is stored
>               in 'rid' output param
>
> It will be used in following patches to get all nested
> struct objects for given type and offset.
>
> The btf_struct_access now calls btf_struct_walk function,
> as long as it gets nested structs as return value.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

It actually worked out to a pretty minimal changes to
btf_struct_access, I'm pleasantly surprised :))

Logic seems correct, just have few nits about naming and a bit more
safe handling in btf_struct_access, see below.


>  kernel/bpf/btf.c | 73 +++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 60 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 841be6c49f11..1ab5fd5bf992 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3873,16 +3873,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>         return true;
>  }
>
> -int btf_struct_access(struct bpf_verifier_log *log,
> -                     const struct btf_type *t, int off, int size,
> -                     enum bpf_access_type atype,
> -                     u32 *next_btf_id)
> +enum walk_return {
> +       /* < 0 error */
> +       walk_scalar = 0,
> +       walk_ptr,
> +       walk_struct,
> +};

let's keep enum values in ALL_CAPS? walk_return is also a bit generic,
maybe something like bpf_struct_walk_result?

> +
> +static int btf_struct_walk(struct bpf_verifier_log *log,
> +                          const struct btf_type *t, int off, int size,
> +                          u32 *rid)
>  {
>         u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
>         const struct btf_type *mtype, *elem_type = NULL;
>         const struct btf_member *member;
>         const char *tname, *mname;
> -       u32 vlen;
> +       u32 vlen, elem_id, mid;
>
>  again:
>         tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> @@ -3924,8 +3930,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                         goto error;
>
>                 off = (off - moff) % elem_type->size;
> -               return btf_struct_access(log, elem_type, off, size, atype,
> -                                        next_btf_id);
> +               return btf_struct_walk(log, elem_type, off, size, rid);

oh, btw, this is a recursion in the kernel, let's fix that? I think it
could easily be just `goto again` here?
>
>  error:
>                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
> @@ -3954,7 +3959,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                          */
>                         if (off <= moff &&
>                             BITS_ROUNDUP_BYTES(end_bit) <= off + size)
> -                               return SCALAR_VALUE;
> +                               return walk_scalar;
>
>                         /* off may be accessing a following member
>                          *

[...]

> @@ -4066,11 +4080,10 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                                         mname, moff, tname, off, size);
>                                 return -EACCES;
>                         }
> -
>                         stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
>                         if (btf_type_is_struct(stype)) {
> -                               *next_btf_id = id;
> -                               return PTR_TO_BTF_ID;
> +                               *rid = id;

nit: rid is a very opaque name, I find next_btf_id more appropriate
(even if it's meaning changes depending on walk_ptr vs walk_struct.

> +                               return walk_ptr;
>                         }
>                 }
>
> @@ -4087,12 +4100,46 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                         return -EACCES;
>                 }
>
> -               return SCALAR_VALUE;
> +               return walk_scalar;
>         }
>         bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
>         return -EINVAL;
>  }
>
> +int btf_struct_access(struct bpf_verifier_log *log,
> +                     const struct btf_type *t, int off, int size,
> +                     enum bpf_access_type atype __maybe_unused,
> +                     u32 *next_btf_id)
> +{
> +       int err;
> +       u32 id;
> +
> +       do {
> +               err = btf_struct_walk(log, t, off, size, &id);
> +               if (err < 0)
> +                       return err;
> +
> +               /* We found the pointer or scalar on t+off,
> +                * we're done.
> +                */
> +               if (err == walk_ptr) {
> +                       *next_btf_id = id;
> +                       return PTR_TO_BTF_ID;
> +               }
> +               if (err == walk_scalar)
> +                       return SCALAR_VALUE;
> +
> +               /* We found nested struct, so continue the search
> +                * by diving in it. At this point the offset is
> +                * aligned with the new type, so set it to 0.
> +                */
> +               t = btf_type_by_id(btf_vmlinux, id);
> +               off = 0;

It's very easy to miss that this case corresponds to walk_struct here.
If someone in the future adds a 4th special value, it will be too easy
to forget to update this piece of logic. So when dealing with enums, I
generally prefer this approach:

switch (err) {
case walk_ptr:
    ...
case walk_scalar:
    ...
case walk_struct:
    ...
default: /* complain loudly here */
}

WDYT?

> +       } while (t);
> +
> +       return -EINVAL;
> +}
> +
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {
> --
> 2.25.4
>
