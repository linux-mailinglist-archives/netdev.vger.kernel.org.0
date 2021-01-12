Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B103E2F2929
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392089AbhALHsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbhALHsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:48:52 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA0EC061575;
        Mon, 11 Jan 2021 23:48:12 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id b64so1322832ybg.7;
        Mon, 11 Jan 2021 23:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YcLfCnFkCFGWqNG7C1xlG4SRRFGPLO1ziBvhVEIBzU4=;
        b=hMerZohPneocubjf+TqYY1Ezu1NtCvumlGeHu/ONDPH7Y57juXIpY8cpaOQWGwx4Wk
         QvNdSD/gGgBYG5qDURO3w9rJSFgS/gSVArSJMg4xRbXjsTt9jOOxV2ONapyjT2NY/fQn
         PX512UwaYU28JUgD9sAj59rrsB959QgNMUFXIMQYah4oJzsFOuXEVev0N8OJ5Mw5uHGf
         L/eg5V56AoFyq9I8yiC1LXwfgNdg0K2/kb04t7T1daSfQpI3Ro4zwNN0Hry1OUJXY2k3
         JYME2wavpD/+NLFxd1j/USfPrDeCP1j6F5VcDqMPZTJJmD0XdvEbssLnf1ceLhqhD5/o
         QHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YcLfCnFkCFGWqNG7C1xlG4SRRFGPLO1ziBvhVEIBzU4=;
        b=JT2MNZ/h1ljNoIrrYTcA01szkDpt4rNXOH2NThTf94NE689oNxJmtzi0OAyKjKBbVV
         X0KBWCvnUSlUrdt3s+7xUW/qHhnS4PttjwGZ92A+QjX241fNrnmsqIan9cf10Yt+1VYn
         d1WrSsQEQDNQJpGBQNeHhAPxK2ePbrQYrRZ/R8M1/B8VXdgM0LCTVtkpx5NjMZNUqENN
         Ss12OxHFsENReU+hxFrj5rHnEP964T61edIsomVb4NmLCItGOcNROZwPi/0DqlQ1ucz0
         nKa7QuC6A+rcvJw7zhEOoqtWtHqucpgrWq36b8fKdj9bpvDYqsbdSkNgVVRO0MoeuR+8
         ybMg==
X-Gm-Message-State: AOAM530+WTXaGnKmHDsSaDBgpBnb+E/KHW0Tmb6N2395vWdI6ar3ijLV
        ilcVgI9bJ95lVZo1uAVc/ZlrnaIPxeSs2Lqytg0=
X-Google-Smtp-Source: ABdhPJyP7TvhZ4e5e3kRWjc3P9+lJ57rocRUhiooJpgsyAauH/+NJOoy36HZA0AtKVeD7mGopc9wn/dvxsPbY3+PkqM=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr488245ybd.230.1610437691269;
 Mon, 11 Jan 2021 23:48:11 -0800 (PST)
MIME-Version: 1.0
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com> <1610386373-24162-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1610386373-24162-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 23:48:00 -0800
Message-ID: <CAEf4BzZu2MuNYs8rpObLo5Z4gkodY4H+8sbraAGYXJwVZC9mfg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: share BTF "show" implementation
 between kernel and libbpf
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 9:34 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> libbpf already supports a "dumper" API for dumping type information,
> but there is currently no support for dumping typed _data_ via libbpf.
> However this functionality does exist in the kernel, in part to
> facilitate the bpf_snprintf_btf() helper which dumps a string
> representation of the pointer passed in utilizing the BTF type id
> of the data pointed to.  For example, the pair of a pointer to
> a "struct sk_buff" and the BTF type id of "struct sk_buff" can be
> used.
>
> Here the kernel code is generalized into btf_show_common.c.  For the
> most part, code is identical for userspace and kernel, beyond a few API
> differences and missing functions.  The only significant differences are
>
>  - the "safe copy" logic used by the kernel to ensure we do not induce a
>    crash during BPF operation; and
>  - the BTF seq file support that is kernel-only.
>
> The mechanics are to maintain identical btf_show_common.c files in
> kernel/bpf and tools/lib/bpf , and a common header btf_common.h in
> include/linux/ and tools/lib/bpf/.  This file duplication seems to
> be the common practice with duplication between kernel and tools/
> so it's the approach taken here.
>
> The common code approach could likely be explored further, but here
> the minimum common code required to support BTF show functionality is
> used.
>

I don't think this approach will work. libbpf and kernel have
considerably different restrictions and styles, I don't think it's
appropriate to take kernel code and try to fit it into libbpf almost
as is, with a bunch of #defines. It would be much cleaner, simpler,
and more maintainable to just re-implement core logic for libbpf, IMO.

> Currently the only "show" function for userspace is to write the
> representation of the typed data to a string via
>
> LIBBPF_API int
> btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
>               __u64 flags);
>
> ...but other approaches could be pursued including printf()-based
> show, or even a callback mechanism could be supported to allow
> user-defined show functions.
>

It's strange that you saw btf_dump APIs, and yet decided to go with
this API instead. snprintf() is not a natural "method" of struct btf.
Using char buffer as an output is overly restrictive and inconvenient.
It's appropriate for kernel and BPF program due to their restrictions,
but there is no need to cripple libbpf APIs for that. I think it
should follow btf_dump APIs with custom callback so that it's easy to
just printf() everything, but also user can create whatever elaborate
mechanism they need and that fits their use case.

Code reuse is not the ultimate goal, it should facilitate
maintainability, not harm it. There are times where sharing code
introduces unnecessary coupling and maintainability issues. And I
think this one is a very obvious case of that.

See below a few comments as well. But overall it's really hard to
review such a humongous patch, of course. So I so far just skimmed
through it.

> Here's an example usage, storing a string representation of
> struct sk_buff *skb in buf:
>
>         struct btf *btf = libbpf_find_kernel_btf();
>         char buf[8192];
>         __s32 skb_id;
>
>         skb_id = btf__find_by_name_kind(btf, "sk_buff", BTF_KIND_STRUCT);
>         if (skb_id < 0)
>                 fprintf(stderr, "no skbuff, err %d\n", skb_id);
>         else
>                 btf__snprintf(btf, buf, sizeof(buf), skb_id, skb, 0);
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  include/linux/btf.h             |  121 +---
>  include/linux/btf_common.h      |  286 +++++++++
>  kernel/bpf/Makefile             |    2 +-
>  kernel/bpf/arraymap.c           |    1 +
>  kernel/bpf/bpf_struct_ops.c     |    1 +
>  kernel/bpf/btf.c                | 1215 +-------------------------------------
>  kernel/bpf/btf_show_common.c    | 1218 +++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/core.c               |    1 +
>  kernel/bpf/hashtab.c            |    1 +
>  kernel/bpf/local_storage.c      |    1 +
>  kernel/bpf/verifier.c           |    1 +
>  kernel/trace/bpf_trace.c        |    1 +
>  tools/lib/bpf/Build             |    2 +-
>  tools/lib/bpf/btf.h             |    7 +
>  tools/lib/bpf/btf_common.h      |  286 +++++++++
>  tools/lib/bpf/btf_show_common.c | 1218 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map        |    1 +
>  17 files changed, 3044 insertions(+), 1319 deletions(-)
>  create mode 100644 include/linux/btf_common.h
>  create mode 100644 kernel/bpf/btf_show_common.c
>  create mode 100644 tools/lib/bpf/btf_common.h
>  create mode 100644 tools/lib/bpf/btf_show_common.c
>

[...]

> +/* For kernel u64 is long long unsigned int... */
> +#define FMT64          "ll"
> +
> +#else
> +/* ...while for userspace it is long unsigned int.  These definitions avoid
> + * format specifier warnings.
> + */

that's not true, it depends on the architecture

> +#define FMT64          "l"
> +
> +/* libbpf names differ slightly to in-kernel function names. */
> +#define btf_type_by_id         btf__type_by_id
> +#define btf_name_by_offset     btf__name_by_offset
> +#define btf_str_by_offset      btf__str_by_offset
> +#define btf_resolve_size       btf__resolve_size

ugh... good luck navigating the code in libbpf....

> +
> +#endif /* __KERNEL__ */
> +/*
> + * Options to control show behaviour.
> + *     - BTF_SHOW_COMPACT: no formatting around type information
> + *     - BTF_SHOW_NONAME: no struct/union member names/types
> + *     - BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
> + *       equivalent to %px.
> + *     - BTF_SHOW_ZERO: show zero-valued struct/union members; they
> + *       are not displayed by default
> + *     - BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
> + *       data before displaying it.
> + */
> +#define BTF_SHOW_COMPACT       BTF_F_COMPACT
> +#define BTF_SHOW_NONAME                BTF_F_NONAME
> +#define BTF_SHOW_PTR_RAW       BTF_F_PTR_RAW
> +#define BTF_SHOW_ZERO          BTF_F_ZERO
> +#define BTF_SHOW_UNSAFE                (1ULL << 4)

this (or some subset of them) should be done as opts struct's bool
fields for libbpf

> +
> +/*
> + * Copy len bytes of string representation of obj of BTF type_id into buf.
> + *
> + * @btf: struct btf object
> + * @type_id: type id of type obj points to
> + * @obj: pointer to typed data
> + * @buf: buffer to write to
> + * @len: maximum length to write to buf
> + * @flags: show options (see above)
> + *
> + * Return: length that would have been/was copied as per snprintf, or
> + *        negative error.
> + */
> +int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
> +                          char *buf, int len, u64 flags);
> +
> +#define for_each_member(i, struct_type, member)                        \
> +       for (i = 0, member = btf_type_member(struct_type);      \
> +            i < btf_type_vlen(struct_type);                    \
> +            i++, member++)
> +
> +#define for_each_vsi(i, datasec_type, member)                  \
> +       for (i = 0, member = btf_type_var_secinfo(datasec_type);        \
> +            i < btf_type_vlen(datasec_type);                   \
> +            i++, member++)
> +
> +static inline bool btf_type_is_ptr(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
> +}
> +
> +static inline bool btf_type_is_int(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
> +}
> +
> +static inline bool btf_type_is_small_int(const struct btf_type *t)
> +{
> +       return btf_type_is_int(t) && t->size <= sizeof(u64);
> +}
> +
> +static inline bool btf_type_is_enum(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
> +}
> +
> +static inline bool btf_type_is_typedef(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
> +}
> +
> +static inline bool btf_type_is_func(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
> +}
> +
> +static inline bool btf_type_is_func_proto(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
> +}
> +
> +static inline bool btf_type_is_var(const struct btf_type *t)
> +{
> +       return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
> +}
> +
> +/* union is only a special case of struct:
> + * all its offsetof(member) == 0
> + */
> +static inline bool btf_type_is_struct(const struct btf_type *t)
> +{
> +       u8 kind = BTF_INFO_KIND(t->info);
> +
> +       return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> +}
> +
> +static inline bool btf_type_is_modifier(const struct btf_type *t)
> +{
> +       /* Some of them is not strictly a C modifier
> +        * but they are grouped into the same bucket
> +        * for BTF concern:
> +        *   A type (t) that refers to another
> +        *   type through t->type AND its size cannot
> +        *   be determined without following the t->type.
> +        *
> +        * ptr does not fall into this bucket
> +        * because its size is always sizeof(void *).
> +        */
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_TYPEDEF:
> +       case BTF_KIND_VOLATILE:
> +       case BTF_KIND_CONST:
> +       case BTF_KIND_RESTRICT:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +static inline
> +const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
> +                                              u32 id, u32 *res_id)
> +{
> +       const struct btf_type *t = btf_type_by_id(btf, id);
> +
> +       while (btf_type_is_modifier(t)) {
> +               id = t->type;
> +               t = btf_type_by_id(btf, t->type);
> +       }
> +
> +       if (res_id)
> +               *res_id = id;
> +
> +       return t;
> +}
> +
> +static inline u32 btf_type_int(const struct btf_type *t)
> +{
> +       return *(u32 *)(t + 1);
> +}
> +
> +static inline const struct btf_array *btf_type_array(const struct btf_type *t)
> +{
> +       return (const struct btf_array *)(t + 1);
> +}
> +
> +static inline const struct btf_enum *btf_type_enum(const struct btf_type *t)
> +{
> +       return (const struct btf_enum *)(t + 1);
> +}
> +
> +static inline const struct btf_var *btf_type_var(const struct btf_type *t)
> +{
> +       return (const struct btf_var *)(t + 1);
> +}
> +
> +static inline u16 btf_type_vlen(const struct btf_type *t)
> +{
> +       return BTF_INFO_VLEN(t->info);
> +}
> +
> +static inline u16 btf_func_linkage(const struct btf_type *t)
> +{
> +       return BTF_INFO_VLEN(t->info);
> +}
> +
> +/* size can be used */
> +static inline bool btf_type_has_size(const struct btf_type *t)
> +{
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_INT:
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +       case BTF_KIND_ENUM:
> +       case BTF_KIND_DATASEC:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +static inline const struct btf_member *btf_type_member(const struct btf_type *t)
> +{
> +       return (const struct btf_member *)(t + 1);
> +}
> +
> +static inline const struct btf_var_secinfo *btf_type_var_secinfo(
> +               const struct btf_type *t)
> +{
> +       return (const struct btf_var_secinfo *)(t + 1);
> +}
> +
> +static inline const char *__btf_name_by_offset(const struct btf *btf,
> +                                              u32 offset)
> +{
> +       const char *name;
> +
> +       if (!offset)
> +               return "(anon)";
> +
> +       name = btf_str_by_offset(btf, offset);
> +       return name ?: "(invalid-name-offset)";
> +}
> +

(almost?) all of the above helpers are already defined in libbpf's
btf.h, no need to add all this duplication

> +/* functions shared between btf.c and btf_show_common.c */
> +void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
> +                      __u32 type_id, void *obj, u8 bits_offset,
> +                      struct btf_show *show);

[...]

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 1c0fd2d..35bd9dc 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -346,6 +346,7 @@ LIBBPF_0.3.0 {
>                 btf__parse_split;
>                 btf__new_empty_split;
>                 btf__new_split;
> +               btf__snprintf;

It's LIBBPF_0.4.0 already, I or someone else should send a patch
adding a new section in .map file.

>                 ring_buffer__epoll_fd;
>                 xsk_setup_xdp_prog;
>                 xsk_socket__update_xskmap;

> --
> 1.8.3.1
>
