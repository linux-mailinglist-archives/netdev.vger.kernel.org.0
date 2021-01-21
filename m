Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC462FE349
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbhAUG6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbhAUG5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:57:32 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31A2C061575;
        Wed, 20 Jan 2021 22:56:43 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id e67so1052714ybc.12;
        Wed, 20 Jan 2021 22:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZetfQU2TBAhrx+cVkn0fAIFRZboQ5J2X070fmvz+A0Q=;
        b=A8y5rGZiBw66SXiPWBUjdgzvbAnBDGA2nxGLMn8NFUO8R2jvYfUrNK0cOLqfxelvsU
         66/vr5QZw8F5tb8FO5l6ycJMtbgt74oOd37DsizSFM2PMAqlcmyxGgVfC3v3XZgjpxRW
         Go0fTHA44d86Q9fNp4meILkauXMiQUFbRIT9aJoh/ihyJly0HMs47gC/tAHpv0SWA10P
         ke8JAvth4AfvX+cvWZo8+SXDnggYId8F/Sf9dCjcK5zkZRjaRqO0lJQk8fpidQNoc6Yu
         K/hGwzjGbYbXN1ci84vSDoKcpaWO7nhjrKiYMu/RMhcTsOW4LCv2+EsQcBsu37Q4ofQw
         M4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZetfQU2TBAhrx+cVkn0fAIFRZboQ5J2X070fmvz+A0Q=;
        b=X2Im1afFER5lByDVglqQxd0QN6pmQT+COKkP2qDm9JAjCBUvN/9cUqKS/OnPHbC4J8
         GMgFvSjeNt4VJhZw8DbIItKDf3tT4OPZN9VXMwggIQb+3EyLGFGefCBM392OoBECjMxG
         VTrIq2c9DX0e0gE6W8e7/vrtmXiU6xo7mhlqFpFrb77M6wYYEnyU34vzlOW5m9LJzXYA
         TzyPTjaT8fzwo4FIBE18T02PoAkM0AHBZiTeBsJhWU9w2d0RxtDqKn6tlGl3l4Nc5u2s
         BYeHt4PicxxPfW00+nSvzFlJmzg2mNr/BxVOfs/4+L6GX9fJPxBa57AQceSO6jUk9/Lf
         fCsA==
X-Gm-Message-State: AOAM532Rg8lkHHfTNKztnsrO7hi1/nHzCBUptURkdQdrfOqWsTa3CYuE
        0TiCHPO+A86dFuiKbYYvEzCR0sAhfPhRFQKolAI=
X-Google-Smtp-Source: ABdhPJyR+dH+JxN7NHDl42Zz4AhhX+vKZ8kT1K26tQU1Z3kp5+RiG8QYPSEkm98E0mZiT1OCpG7MNC1BLzGmXwDP4Gc=
X-Received: by 2002:a25:9882:: with SMTP id l2mr17720018ybo.425.1611212202366;
 Wed, 20 Jan 2021 22:56:42 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com> <1610921764-7526-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1610921764-7526-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Jan 2021 22:56:31 -0800
Message-ID: <CAEf4BzZ6bYenSTUmwu7jXqQOyD=AG75oLsLE5B=9ycPjm1jOkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 2:22 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Add a BTF dumper for typed data, so that the user can dump a typed
> version of the data provided.
>
> The API is
>
> int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
>                              const struct btf_dump_emit_type_data_opts *opts,
>                              void *data);
>
> ...where the id is the BTF id of the data pointed to by the "void *"
> argument; for example the BTF id of "struct sk_buff" for a
> "struct skb *" data pointer.  Options supported are
>
>  - a starting indent level (indent_lvl)
>  - a set of boolean options to control dump display, similar to those
>    used for BPF helper bpf_snprintf_btf().  Options are
>         - compact : omit newlines and other indentation
>         - noname: omit member names
>         - zero: show zero-value members
>
> Default output format is identical to that dumped by bpf_snprintf_btf(),
> for example a "struct sk_buff" representation would look like this:
>
> struct sk_buff){
>  (union){
>   (struct){

Curious, these explicit anonymous (union) and (struct), is that
preferred way for explicitness, or is it just because it makes
implementation simpler and thus was chosen? I.e., if the goal was to
mimic C-style data initialization, you'd just have plain .next = ...,
.prev = ..., .dev = ..., .dev_scratch = ..., all on the same level. So
just checking for myself.

>    .next = (struct sk_buff *)0xffffffffffffffff,
>    .prev = (struct sk_buff *)0xffffffffffffffff,
>    (union){
>     .dev = (struct net_device *)0xffffffffffffffff,
>     .dev_scratch = (long unsigned int)18446744073709551615,
>    },
>   },
> ...
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

So just keep in mind that I went through this from bottom to the top,
some comments would read more naturally that way, probably :)

>  tools/lib/bpf/btf.h      |  17 +
>  tools/lib/bpf/btf_dump.c | 974 +++++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map |   5 +
>  3 files changed, 996 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 0c48f2e..7937124 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -180,6 +180,23 @@ struct btf_dump_emit_type_decl_opts {
>  btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
>                          const struct btf_dump_emit_type_decl_opts *opts);
>
> +
> +struct btf_dump_emit_type_data_opts {
> +       /* size of this struct, for forward/backward compatibility */
> +       size_t sz;
> +       int indent_level;

probably would be good to mention that it's in number of spaces and
that amount of spaces will be added to each output line (or each
except the first, I haven't payed attention in the code, sorry).

> +       /* below match "show" flags for bpf_show_snprintf() */
> +       bool compact;
> +       bool noname;
> +       bool zero;

zero -> emit_zeroes?
noname -> skip_names? is it field names only? then maybe skip_field_names?


> +};
> +#define btf_dump_emit_type_data_opts__last_field zero
> +
> +LIBBPF_API int
> +btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
> +                        const struct btf_dump_emit_type_data_opts *opts,
> +                        void *data);
> +
>  /*
>   * A set of helpers for easier BTF types handling
>   */
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 2f9d685..04d604f 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -10,6 +10,8 @@
>  #include <stddef.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <ctype.h>
> +#include <endian.h>
>  #include <errno.h>
>  #include <linux/err.h>
>  #include <linux/btf.h>
> @@ -19,14 +21,31 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
>
> +#define BITS_PER_BYTE                  8
> +#define BITS_PER_U128                  (sizeof(__u64) * BITS_PER_BYTE * 2)

I'm sorry, but why?.. is it ever going to change? isn't 64 or 8 or 128
completely obvious within the context where it's used?

> +#define BITS_PER_BYTE_MASK             (BITS_PER_BYTE - 1)
> +#define BITS_PER_BYTE_MASKED(bits)     ((bits) & BITS_PER_BYTE_MASK)
> +#define BITS_ROUNDDOWN_BYTES(bits)     ((bits) >> 3)

aka, bits / 8

> +#define BITS_ROUNDUP_BYTES(bits) \
> +       (BITS_ROUNDDOWN_BYTES(bits) + !!BITS_PER_BYTE_MASKED(bits))

aka, roundup(bits, 8)?

> +
>  static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
>  static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
>
> +
>  static const char *pfx(int lvl)
>  {
>         return lvl >= PREFIX_CNT ? PREFIXES : &PREFIXES[PREFIX_CNT - lvl];
>  }
>
> +static const char SPREFIXES[] = "                         ";
> +static const size_t SPREFIX_CNT = sizeof(SPREFIXES) - 1;
> +
> +static const char *spfx(int lvl)
> +{
> +       return lvl >= SPREFIX_CNT ? SPREFIXES : &SPREFIXES[SPREFIX_CNT - lvl];
> +}

would using tabs for indentation be too horrible?

> +
>  enum btf_dump_type_order_state {
>         NOT_ORDERED,
>         ORDERING,
> @@ -53,6 +72,49 @@ struct btf_dump_type_aux_state {
>         __u8 referenced: 1;
>  };
>
> +#define BTF_DUMP_DATA_MAX_NAME_LEN     256
> +
> +/*
> + * Common internal data for BTF type data dump operations.
> + *
> + * The implementation here is similar to that in kernel/bpf/btf.c
> + * that supports the bpf_snprintf_btf() helper, so any bugs in
> + * type data dumping here are likely in that code also.
> + *
> + * One challenge with showing nested data is we want to skip 0-valued
> + * data, but in order to figure out whether a nested object is all zeros
> + * we need to walk through it.  As a result, we need to make two passes
> + * when handling structs, unions and arrays; the first path simply looks
> + * for nonzero data, while the second actually does the display.  The first
> + * pass is signalled by state.depth_check being set, and if we
> + * encounter a non-zero value we set state.depth_to_show to the depth
> + * at which we encountered it.  When we have completed the first pass,
> + * we will know if anything needs to be displayed if
> + * state.depth_to_show > state.depth.  See btf_dump_emit_[struct,array]_data()
> + * for the implementation of this.

So this approach is quite convoluted, IMO. You are trying to reuse
printing "infrastructure" to determine if anything is going to be
printed. It works, I suppose, but make code more convoluted, has this
additional depth_to_show-related state, etc... Let's think about
alternative ways to check whether data has some non-zero members.

Naively, you could just say that you need to check if entire memory
region taken up by the type has a single non-zero byte. You didn't do
it probably due to non-zero padding bytes, which are sort of not
important and we want to ignore them, is that right?

So if we do want to ignore non-zero padding bytes, then I think it's
still much better to write a much simpler recursive traversal function
that will go over all members of array/struct/datasec and check if
they are zero (using byte comparison, nothing fancy). Even bitfields
are not hard to handle in such case.

Surely, you'll implement traversal once for zero checking and once for
actual printing, but traversal is trivial for the former and will be
simpler than what you have currently for the latter. Instead all the
checks with depth and so on, you will effectively have:

if (btf_dump_is_all_zero(...))
    return;

btf_dump_data_for_real(...)

> + *
> + */
> +struct btf_dump_data {
> +       bool compact;
> +       bool noname;
> +       bool zero;
> +       __u8 indent_lvl;        /* base indent level */
> +       /* below are used during iteration */
> +       struct {
> +               __u8 depth;
> +               __u8 depth_to_show;
> +               __u8 depth_check;
> +               __u8 array_member:1,
> +                    array_terminated:1;
> +               __u16 array_encoding;
> +               __u32 type_id;
> +               const struct btf_type *type;
> +               const struct btf_member *member;
> +               char name[BTF_DUMP_DATA_MAX_NAME_LEN];

unlike kernel, here in user-space we have unresticted recursive
functions, it's quite hard to justify this state machine approach with
set_member/unset_member and so on. You have a function that emits
member, so pass that member as an input argument. Please see if you
can simplify all that further. I believe after some iteration on
implementation we'll end up with less and simpler code overall.

> +               int err;
> +       } state;
> +};
> +
>  struct btf_dump {
>         const struct btf *btf;
>         const struct btf_ext *btf_ext;
> @@ -89,6 +151,10 @@ struct btf_dump {
>          * name occurrences
>          */
>         struct hashmap *ident_names;
> +       /*
> +        * data for typed display.
> +        */
> +       struct btf_dump_data data;
>  };
>
>  static size_t str_hash_fn(const void *key, void *ctx)
> @@ -1438,3 +1504,911 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
>  {
>         return btf_dump_resolve_name(d, id, d->ident_names);
>  }
> +
> +static void __btf_dump_emit_type_data(struct btf_dump *d,
> +                                     const struct btf_type *t,
> +                                     __u32 id,
> +                                     void *data,
> +                                     __u8 bits_offset);
> +
> +static const struct btf_type *skip_mods(const struct btf *btf,
> +                                       __u32 id, __u32 *res_id)
> +{
> +       const struct btf_type *t = btf__type_by_id(btf, id);
> +
> +       while (btf_is_mod(t)) {
> +               id = t->type;
> +               t = btf__type_by_id(btf, t->type);
> +       }
> +
> +       if (res_id)
> +               *res_id = id;
> +
> +       return t;
> +}
> +
> +#define BTF_MAX_ITER           10
> +#define BTF_KIND_BIT(kind)     (1ULL << kind)
> +
> +/*
> + * Populate dump->data.state.name with type name information.
> + * Format of type name is
> + *
> + *     [.member_name = ] (type_name)
> + */
> +static const char *btf_dump_data_name(struct btf_dump *d)
> +{

this whole function almost entirely can be handled by
btf_dump__emit_type_decl() to emit (struct whatever) part. It has no
artificial limits to nestedness (so void
****************************** doesn't scare it), and it doesn't need
artificially limited intermediate buffer. Please try to utilize it
here and cut on unnecessary code we'll need to maintain here. Note the
skip_mods option, which you probably want to use here.

> +       /* BTF_MAX_ITER array suffixes "[]" */
> +       const char *array_suffixes = "[][][][][][][][][][]";
> +       const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
> +       /* BTF_MAX_ITER pointer suffixes "*" */
> +       const char *ptr_suffixes = "**********";
> +       const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
> +       const char *name = NULL, *prefix = "", *parens = "";
> +       const struct btf_member *m = d->data.state.member;
> +       const struct btf_type *t = d->data.state.type;
> +       const struct btf_array *array;
> +       __u32 id = d->data.state.type_id;
> +       const char *member = NULL;
> +       bool show_member = false;
> +       __u64 kinds = 0;
> +       int i;
> +
> +       d->data.state.name[0] = '\0';
> +
> +       /*
> +        * Don't show type name if we're showing an array member;
> +        * in that case we show the array type so don't need to repeat
> +        * ourselves for each member.
> +        */
> +       if (d->data.state.array_member)
> +               return "";
> +
> +       /* Retrieve member name, if any. */
> +       if (m) {
> +               member = btf_name_of(d, m->name_off);
> +               show_member = strlen(member) > 0;
> +               id = m->type;
> +       }
> +
> +       /*
> +        * Start with type_id, as we have resolved the struct btf_type *
> +        * via btf_dump_emit_modifier_data() past the parent typedef to the
> +        * child struct, int etc it is defined as.  In such cases, the type_id
> +        * still represents the starting type while the struct btf_type *
> +        * in our d->data.state points at the resolved type of the typedef.
> +        */
> +       t = btf__type_by_id(d->btf, id);
> +       if (!t)
> +               return "";
> +
> +       /*
> +       * The goal here is to build up the right number of pointer and
> +       * array suffixes while ensuring the type name for a typedef
> +       * is represented.  Along the way we accumulate a list of
> +       * BTF kinds we have encountered, since these will inform later
> +       * display; for example, pointer types will not require an
> +       * opening "{" for struct, we will just display the pointer value.
> +       *
> +       * We also want to accumulate the right number of pointer or array
> +       * indices in the format string while iterating until we get to
> +       * the typedef/pointee/array member target type.
> +       *
> +       * We start by pointing at the end of pointer and array suffix
> +       * strings; as we accumulate pointers and arrays we move the pointer
> +       * or array string backwards so it will show the expected number of
> +       * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
> +       * and/or arrays and typedefs are supported as a precaution.
> +       *
> +       * We also want to get typedef name while proceeding to resolve
> +       * type it points to so that we can add parentheses if it is a
> +       * "typedef struct" etc.
> +       *
> +       * Qualifiers ("const", "volatile", "restrict") are simply skipped
> +       * as they complicate simple type name display without adding much
> +       * in the case of displaying a cast in front of the data to be
> +       * displayed.
> +       */
> +       for (i = 0; i < BTF_MAX_ITER; i++) {
> +
> +               switch (BTF_INFO_KIND(t->info)) {
> +               case BTF_KIND_TYPEDEF:
> +                       if (!name)
> +                               name = btf_name_of(d, t->name_off);
> +                       kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
> +                       id = t->type;
> +                       break;
> +               case BTF_KIND_ARRAY:
> +                       kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
> +                       parens = "[";
> +                       if (!t)
> +                               return "";
> +                       array = btf_array(t);
> +                       if (array_suffix > array_suffixes)
> +                               array_suffix -= 2;
> +                       id = array->type;
> +                       break;
> +               case BTF_KIND_PTR:
> +                       kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
> +                       if (ptr_suffix > ptr_suffixes)
> +                               ptr_suffix -= 1;
> +                       id = t->type;
> +                       break;
> +               default:
> +                       id = 0;
> +                       break;
> +               }
> +               if (!id)
> +                       break;
> +               t = skip_mods(d->btf, id, NULL);
> +       }
> +       /* We may not be able to represent this type; bail to be safe */
> +       if (i == BTF_MAX_ITER) {
> +               pr_warn("iters %d exceeded %d when displaying type name:[%u]\n",
> +                       i, BTF_MAX_ITER, id);
> +               return "";
> +       }
> +
> +       if (!name)
> +               name = btf_name_of(d, t->name_off);
> +
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +               prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
> +                                                  "struct" : "union";
> +               /* if it's an array of struct/union, parens is already set */
> +               if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
> +                       parens = "{";
> +               break;
> +       case BTF_KIND_ENUM:
> +               prefix = "enum";
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       /* pointer does not require parens */
> +       if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
> +               parens = "";
> +       /* typedef does not require struct/union/enum prefix */
> +       if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
> +               prefix = "";
> +
> +       if (!name)
> +               name = "";
> +
> +       /* Even if we don't want type name info, we want parentheses etc */
> +       if (d->data.noname)
> +               snprintf(d->data.state.name, sizeof(d->data.state.name), "%s",
> +                        parens);
> +       else
> +               snprintf(d->data.state.name, sizeof(d->data.state.name),
> +                        "%s%s%s(%s%s%s%s%s%s)%s",
> +                        /* first 3 strings comprise ".member = " */
> +                        show_member ? "." : "",
> +                        show_member ? member : "",
> +                        show_member ? " = " : "",
> +                        /* ...next is our prefix (struct, enum, etc) */
> +                        prefix,
> +                        strlen(prefix) > 0 && strlen(name) > 0 ? " " : "",
> +                        /* ...this is the type name itself */
> +                        name,
> +                        /* ...suffixed by the appropriate '*', '[]' suffixes */
> +                        strlen(name) > 0 && strlen(ptr_suffix) > 0 ? " " : "",
> +                        ptr_suffix,
> +                        array_suffix, parens);
> +
> +       return d->data.state.name;
> +}
> +
> +static const char *btf_dump_data_indent(struct btf_dump *d)
> +{
> +       if (d->data.compact)
> +               return "";
> +       return spfx(d->data.indent_lvl + d->data.state.depth);
> +}
> +
> +static const char *btf_dump_data_newline(struct btf_dump *d)
> +{
> +       return d->data.compact ? "" : "\n";
> +}
> +
> +static const char *btf_dump_data_delim(struct btf_dump *d)
> +{
> +       if (d->data.state.depth == 0)
> +               return "";
> +
> +       if (d->data.compact &&
> +           d->data.state.type &&
> +           BTF_INFO_KIND(d->data.state.type->info) == BTF_KIND_UNION)
> +               return "|";

this is unexpected distinction... why such decision was made?

> +
> +       return ",";
> +}
> +
> +static void btf_dump_data_printf(struct btf_dump *d,
> +                                const char *fmt, ...)
> +{
> +       va_list args;
> +
> +       /*
> +        * Just checking if there is non-zero data to display at this depth,
> +        * so nothing is displayed.
> +        */
> +       if (d->data.state.depth_check)
> +               return;

really-really don't like this approach, see above for more thoughts

> +       va_start(args, fmt);
> +       d->printf_fn(d->opts.ctx, fmt, args);
> +       va_end(args);
> +}
> +
> +/* Macros are used here as btf_type_value[s]() prepends and appends
> + * format specifiers to the format specifier passed in; these do the work of
> + * adding indentation, delimiters etc while the caller simply has to specify
> + * the type value(s) in the format specifier + value(s).
> + */
> +#define btf_dump_emit_type_value(d, fmt, value)                                     \
> +       do {                                                                 \
> +               if ((value) != 0 || d->data.zero ||                          \
> +                   d->data.state.depth == 0) {                              \
> +                       btf_dump_data_printf(d, "%s%s" fmt "%s%s",           \
> +                                            btf_dump_data_indent(d),        \
> +                                            btf_dump_data_name(d),          \
> +                                            value,                          \
> +                                            btf_dump_data_delim(d),         \
> +                                            btf_dump_data_newline(d));      \
> +                       if (d->data.state.depth >                            \
> +                           d->data.state.depth_to_show)                     \
> +                               d->data.state.depth_to_show =                \
> +                                       d->data.state.depth;                 \
> +               }                                                            \
> +       } while (0)
> +
> +#define btf_dump_emit_type_values(d, fmt, ...)                         \
> +       do {                                                            \
> +               btf_dump_data_printf(d, "%s%s" fmt "%s%s",              \
> +                                    btf_dump_data_indent(d),           \
> +                                    btf_dump_data_name(d),             \
> +                                    __VA_ARGS__,                       \
> +                                    btf_dump_data_delim(d),            \
> +                                    btf_dump_data_newline(d));         \
> +               if (d->data.state.depth >                               \
> +                   d->data.state.depth_to_show)                        \
> +                       d->data.state.depth_to_show =                   \
> +                               d->data.state.depth;                    \
> +       } while (0)
> +

these macro can be easily written as functions by calling
btf_dump_data_printf three times, why macro?..

> +/* Set the type we are starting to show. */
> +static void btf_dump_start_type(struct btf_dump *d,
> +                               const struct btf_type *t,
> +                               __u32 type_id)
> +{
> +       d->data.state.type = t;
> +       d->data.state.type_id = type_id;
> +       d->data.state.name[0] = '\0';
> +}
> +
> +static void btf_dump_end_type(struct btf_dump *d)
> +{
> +       d->data.state.type = NULL;
> +       d->data.state.type_id = 0;
> +       d->data.state.name[0] = '\0';
> +}
> +
> +static void btf_dump_start_aggr_type(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    __u32 type_id)
> +{
> +       btf_dump_start_type(d, t, type_id);
> +
> +       btf_dump_data_printf(d, "%s%s%s",
> +                            btf_dump_data_indent(d),
> +                            btf_dump_data_name(d),
> +                            btf_dump_data_newline(d));
> +       d->data.state.depth++;
> +}
> +
> +static void btf_dump_end_aggr_type(struct btf_dump *d,
> +                                  const char *suffix)
> +{
> +       d->data.state.depth--;
> +       btf_dump_data_printf(d, "%s%s%s%s",
> +                            btf_dump_data_indent(d),
> +                            suffix,
> +                            btf_dump_data_delim(d),
> +                            btf_dump_data_newline(d));
> +       btf_dump_end_type(d);
> +}
> +
> +static void btf_dump_start_member(struct btf_dump *d,
> +                                 const struct btf_member *m)
> +{
> +       d->data.state.member = m;
> +}
> +
> +static void btf_dump_start_array_member(struct btf_dump *d)
> +{
> +       d->data.state.array_member = 1;
> +       btf_dump_start_member(d, NULL);
> +}
> +
> +static void btf_dump_end_member(struct btf_dump *d)
> +{
> +       d->data.state.member = NULL;
> +}
> +
> +static void btf_dump_end_array_member(struct btf_dump *d)
> +{
> +       d->data.state.array_member = 0;
> +       btf_dump_end_member(d);
> +}
> +
> +static void btf_dump_start_array_type(struct btf_dump *d,
> +                                     const struct btf_type *t,
> +                                     __u32 type_id,
> +                                     __u16 array_encoding)
> +{
> +       d->data.state.array_encoding = array_encoding;
> +       d->data.state.array_terminated = 0;
> +       btf_dump_start_aggr_type(d, t, type_id);
> +}
> +
> +static void btf_dump_end_array_type(struct btf_dump *d)
> +{
> +       d->data.state.array_encoding = 0;
> +       d->data.state.array_terminated = 0;
> +       btf_dump_end_aggr_type(d, "]");
> +}
> +
> +static void btf_dump_start_struct_type(struct btf_dump *d,
> +                                      const struct btf_type *t,
> +                                      __u32 type_id)
> +{
> +       btf_dump_start_aggr_type(d, t, type_id);
> +}
> +
> +static void btf_dump_end_struct_type(struct btf_dump *d)
> +{
> +       btf_dump_end_aggr_type(d, "}");
> +}
> +
> +static void btf_dump_emit_df_data(struct btf_dump *d,
> +                                 const struct btf_type *t,
> +                                 __u32 id,
> +                                 void *data,
> +                                 __u8 bits_offset)
> +{
> +       btf_dump_data_printf(d, "<unsupported kind:%u>",
> +                            BTF_INFO_KIND(t->info));
> +}
> +
> +static void btf_dump_emit_int128(struct btf_dump *d, void *data)
> +{
> +       /* data points to a __int128 number.
> +        * Suppose
> +        *      int128_num = *(__int128 *)data;
> +        * The below formulas shows what upper_num and lower_num represents:
> +        *     upper_num = int128_num >> 64;
> +        *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
> +        */
> +       __u64 upper_num, lower_num;
> +
> +#ifdef __BIG_ENDIAN_BITFIELD
> +       upper_num = *(__u64 *)data;
> +       lower_num = *(__u64 *)(data + 8);
> +#else
> +       upper_num = *(__u64 *)(data + 8);
> +       lower_num = *(__u64 *)data;
> +#endif
> +       if (upper_num == 0)
> +               btf_dump_emit_type_value(d, "0x%llx", lower_num);
> +       else
> +               btf_dump_emit_type_values(d, "0x%llx%016llx", upper_num,
> +                                         lower_num);

see below, %llx or %lx, depending on the platform. So what libbpf is
doing in situations like this is explicitly casting to undecorated
"long long".

> +}
> +
> +static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
> +                            __u16 right_shift_bits)
> +{
> +       __u64 upper_num, lower_num;
> +
> +#ifdef __BIG_ENDIAN_BITFIELD
> +       upper_num = print_num[0];
> +       lower_num = print_num[1];
> +#else
> +       upper_num = print_num[1];
> +       lower_num = print_num[0];
> +#endif
> +
> +       /* shake out un-needed bits by shift/or operations */
> +       if (left_shift_bits >= 64) {
> +               upper_num = lower_num << (left_shift_bits - 64);

surprised we don't have BITS_PER_U64 for this ;)

> +               lower_num = 0;
> +       } else {
> +               upper_num = (upper_num << left_shift_bits) |
> +                           (lower_num >> (64 - left_shift_bits));
> +               lower_num = lower_num << left_shift_bits;
> +       }
> +
> +       if (right_shift_bits >= 64) {
> +               lower_num = upper_num >> (right_shift_bits - 64);
> +               upper_num = 0;
> +       } else {
> +               lower_num = (lower_num >> right_shift_bits) |
> +                           (upper_num << (64 - right_shift_bits));
> +               upper_num = upper_num >> right_shift_bits;
> +       }
> +
> +#ifdef __BIG_ENDIAN_BITFIELD
> +       print_num[0] = upper_num;
> +       print_num[1] = lower_num;
> +#else
> +       print_num[0] = lower_num;
> +       print_num[1] = upper_num;
> +#endif
> +}
> +
> +static void btf_dump_emit_bitfield_data(struct btf_dump *d,
> +                                       void *data,
> +                                       __u8 bits_offset,
> +                                       __u8 nr_bits)
> +{
> +       __u16 left_shift_bits, right_shift_bits;
> +       __u8 nr_copy_bytes;
> +       __u8 nr_copy_bits;
> +       __u64 print_num[2] = {};
> +
> +       nr_copy_bits = nr_bits + bits_offset;
> +       nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
> +
> +       memcpy(print_num, data, nr_copy_bytes);
> +
> +#ifdef __BIG_ENDIAN_BITFIELD
> +       left_shift_bits = bits_offset;
> +#else
> +       left_shift_bits = BITS_PER_U128 - nr_copy_bits;
> +#endif
> +       right_shift_bits = BITS_PER_U128 - nr_bits;
> +
> +       btf_int128_shift(print_num, left_shift_bits, right_shift_bits);

I suspect the whole shifting of 128-bit numbers can be less elaborate,
but I'll postpone digging into details for now. I'm also wondering how
realistic it is to have 128-bit bitfields...

> +       btf_dump_emit_int128(d, print_num);
> +}
> +
> +static void btf_dump_emit_int_bits(struct btf_dump *d,
> +                                  const struct btf_type *t,
> +                                  void *data,
> +                                  __u8 bits_offset)
> +{
> +       __u32 int_data = btf_int(t);
> +       __u8 nr_bits = BTF_INT_BITS(int_data);
> +       __u8 total_bits_offset;
> +
> +       /*
> +        * bits_offset is at most 7.
> +        * BTF_INT_OFFSET() cannot exceed 128 bits.
> +        */
> +       total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
> +       data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
> +       bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
> +       btf_dump_emit_bitfield_data(d, data, bits_offset, nr_bits);
> +}
> +
> +static void btf_dump_emit_int_data(struct btf_dump *d,
> +                                  const struct btf_type *t,
> +                                  __u32 type_id,
> +                                  void *data,
> +                                  __u8 bits_offset)
> +{
> +       __u32 int_data = btf_int(t);
> +       __u8 encoding = BTF_INT_ENCODING(int_data);
> +       bool sign = encoding & BTF_INT_SIGNED;
> +       __u8 nr_bits = BTF_INT_BITS(int_data);
> +
> +       btf_dump_start_type(d, t, type_id);
> +
> +       if (bits_offset || BTF_INT_OFFSET(int_data) ||
> +           BITS_PER_BYTE_MASKED(nr_bits)) {
> +               btf_dump_emit_int_bits(d, t, data, bits_offset);
> +               goto out;
> +       }
> +
> +       switch (nr_bits) {
> +       case 128:
> +               btf_dump_emit_int128(d, data);
> +               break;
> +       case 64:
> +               if (sign)
> +                       btf_dump_emit_type_value(d, "%lld", *(__s64 *)data);
> +               else
> +                       btf_dump_emit_type_value(d, "%llu", *(__u64 *)data);

if I remember correctly, the only bulletproof way to not get warning
about %lld vs %ld on any platform is to cast to (long long), not any
of the typedefs (int64_t, __s64, etc).

> +               break;
> +       case 32:
> +               if (sign)
> +                       btf_dump_emit_type_value(d, "%d", *(__s32 *)data);
> +               else
> +                       btf_dump_emit_type_value(d, "%u", *(__u32 *)data);
> +               break;
> +       case 16:
> +               if (sign)
> +                       btf_dump_emit_type_value(d, "%d", *(__s16 *)data);
> +               else
> +                       btf_dump_emit_type_value(d, "%u", *(__u16 *)data);
> +               break;
> +       case 8:
> +               if (d->data.state.array_encoding == BTF_INT_CHAR) {
> +                       /* check for null terminator */
> +                       if (d->data.state.array_terminated)
> +                               break;
> +                       if (*(char *)data == '\0') {
> +                               d->data.state.array_terminated = 1;
> +                               break;
> +                       }
> +                       if (isprint(*(char *)data)) {
> +                               btf_dump_emit_type_value(d, "'%c'",
> +                                                        *(char *)data);
> +                               break;
> +                       }
> +               }
> +               if (sign)
> +                       btf_dump_emit_type_value(d, "%d", *(__s8 *)data);
> +               else
> +                       btf_dump_emit_type_value(d, "%u", *(__u8 *)data);

Nitpicking here. Isn't it more natural to emit char array that
actually represents printable characters as "abracadabra", not { 'a',
'b', 'r', 'a', 'c', 'a', ... }?

> +               break;
> +       default:
> +               btf_dump_emit_int_bits(d, t, data, bits_offset);
> +               break;
> +       }
> +out:
> +       btf_dump_end_type(d);
> +}
> +
> +static void btf_dump_emit_modifier_data(struct btf_dump *d,
> +                                       const struct btf_type *t,
> +                                       __u32 id,
> +                                       void *data,
> +                                       __u8 bits_offset)
> +{
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       __btf_dump_emit_type_data(d, t, id, data, bits_offset);
> +}
> +
> +static void btf_dump_emit_var_data(struct btf_dump *d,
> +                                  const struct btf_type *t,
> +                                  __u32 id,
> +                                  void *data,
> +                                  __u8 bits_offset)
> +{
> +       __u32 linkage = btf_var(t)->linkage;

linkage is an enum btf_func_linkage, please use proper enumerator constants

> +
> +       btf_dump_data_printf(d, "%s%s =",
> +                            linkage ? "" : "static ",
> +                            btf_name_of(d, t->name_off));
> +       t = btf__type_by_id(d->btf, t->type);
> +       __btf_dump_emit_type_data(d, t, t->type, data, bits_offset);
> +}
> +
> +static void __btf_dump_emit_array_data(struct btf_dump *d,
> +                                      const struct btf_type *t,
> +                                      __u32 id,
> +                                      void *data,
> +                                      __u8 bits_offset)
> +{
> +       const struct btf_array *array = btf_array(t);
> +       const struct btf_type *elem_type;
> +       __u32 i, elem_size = 0, elem_type_id;
> +       __u16 encoding = 0;
> +
> +       elem_type_id = array->type;
> +       elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
> +       if (elem_type && btf_has_size(elem_type))

if (!elem_type) means corrupted BTF, bail out, don't ignore such problems?..

But the bigger problem is btf_has_size() use. What if you have an
array of array (can you add a test for that, btw)? Inner array does
have size, just not immediately available. That's what I meant when I
said btf_has_size() is misleading and you do mis-use it, it seems.

> +               elem_size = elem_type->size;
> +
> +       if (elem_type && btf_is_int(elem_type)) {
> +               __u32 int_type = btf_int(elem_type);
> +
> +               encoding = BTF_INT_ENCODING(int_type);

encoding = btf_int_encoding(elem_type);

> +
> +               /*
> +                * BTF_INT_CHAR encoding never seems to be set for
> +                * char arrays, so if size is 1 and element is
> +                * printable as a char, we'll do that.
> +                */
> +               if (elem_size == 1)
> +                       encoding = BTF_INT_CHAR;
> +       }
> +
> +       btf_dump_start_array_type(d, t, id, encoding);
> +
> +       if (!elem_type)
> +               goto out;
> +
> +       for (i = 0; i < array->nelems; i++) {
> +
> +               btf_dump_start_array_member(d);
> +
> +               __btf_dump_emit_type_data(d, elem_type, elem_type_id,
> +                                         data, bits_offset);
> +               data += elem_size;
> +
> +               btf_dump_end_array_member(d);
> +
> +               if (d->data.state.array_terminated)
> +                       break;
> +       }
> +out:
> +       btf_dump_end_array_type(d);
> +}
> +
> +static void btf_dump_emit_array_data(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    __u32 id,
> +                                    void *data,
> +                                    __u8 bits_offset)
> +{
> +       const struct btf_member *m = d->data.state.member;
> +
> +       /*
> +        * First check if any members would be shown (are non-zero).
> +        * See comments above "struct btf_dump_data" definition for more
> +        * details on how this works at a high-level.
> +        */
> +       if (d->data.state.depth > 0 && !d->data.zero) {
> +               if (!d->data.state.depth_check) {
> +                       d->data.state.depth_check = d->data.state.depth + 1;
> +                       d->data.state.depth_to_show = 0;
> +               }
> +               __btf_dump_emit_array_data(d, t, id, data, bits_offset);
> +               d->data.state.member = m;
> +
> +               if (d->data.state.depth_check != d->data.state.depth + 1)
> +                       return;
> +               d->data.state.depth_check = 0;
> +
> +               if (d->data.state.depth_to_show <= d->data.state.depth)
> +                       return;
> +               /*
> +                * Reaching here indicates we have recursed and found
> +                * non-zero array member(s).
> +                */
> +       }
> +       __btf_dump_emit_array_data(d, t, id, data, bits_offset);

here and in many other places, if at this point bits_offset is not
zero, we are in big trouble. Why passing this through everywhere? It
has to be zero for everything but terminal bitfield.

> +}
> +
> +#define for_each_member(i, struct_type, member)                        \
> +       for (i = 0, member = btf_members(struct_type);          \
> +            i < btf_vlen(struct_type);                         \
> +            i++, member++)


same as below about unnecessary macro, more code, harder to follow, no benefit

> +
> +static void __btf_dump_emit_struct_data(struct btf_dump *d,
> +                                       const struct btf_type *t,
> +                                       __u32 id,
> +                                       void *data,
> +                                       __u8 bits_offset)
> +{
> +       const struct btf_member *member;
> +       __u32 i;
> +
> +       btf_dump_start_struct_type(d, t, id);
> +
> +       for_each_member(i, t, member) {
> +               const struct btf_type *member_type;
> +               __u32 member_offset, bitfield_size;
> +               __u32 bytes_offset;
> +               __u8 bits8_offset;
> +
> +               member_type = btf__type_by_id(d->btf, member->type);
> +               btf_dump_start_member(d, member);
> +
> +               member_offset = btf_member_bit_offset(t, i);
> +               bitfield_size = btf_member_bitfield_size(t, i);
> +               bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
> +               bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
> +               if (bitfield_size) {
> +                       btf_dump_start_type(d, member_type, member->type);
> +                       btf_dump_emit_bitfield_data(d,
> +                                                   data + bytes_offset,
> +                                                   bits8_offset,
> +                                                   bitfield_size);
> +                       btf_dump_end_type(d);
> +               } else {
> +                       __btf_dump_emit_type_data(d, member_type, member->type,
> +                                            data + bytes_offset, bits8_offset);
> +               }
> +               btf_dump_end_member(d);
> +       }
> +       btf_dump_end_struct_type(d);
> +}
> +
> +static void btf_dump_emit_struct_data(struct btf_dump *d,
> +                                     const struct btf_type *t,
> +                                     __u32 id,
> +                                     void *data,
> +                                     __u8 bits_offset)
> +{
> +       const struct btf_member *m = d->data.state.member;
> +
> +       /*
> +        * First check if any members would be shown (are non-zero).
> +        * See comments above "struct btf_dump_data" definition for more
> +        * details on how this works at a high-level.
> +        */
> +       if (d->data.state.depth > 0 && !d->data.zero) {
> +               if (!d->data.state.depth_check) {
> +                       d->data.state.depth_check = d->data.state.depth + 1;
> +                       d->data.state.depth_to_show = 0;
> +               }
> +               __btf_dump_emit_struct_data(d, t, id, data, bits_offset);
> +               /* Restore saved member data here */
> +               d->data.state.member = m;
> +               if (d->data.state.depth_check != d->data.state.depth + 1)
> +                       return;
> +               d->data.state.depth_check = 0;
> +
> +               if (d->data.state.depth_to_show <= d->data.state.depth)
> +                       return;
> +               /*
> +                * Reaching here indicates we have recursed and found
> +                * non-zero child values.
> +                */
> +       }
> +
> +       __btf_dump_emit_struct_data(d, t, id, data, bits_offset);
> +}
> +
> +static void btf_dump_emit_ptr_data(struct btf_dump *d,
> +                                  const struct btf_type *t,
> +                                  __u32 id,
> +                                  void *data,
> +                                  __u8 bits_offset)
> +{
> +       btf_dump_start_type(d, t, id);
> +
> +       btf_dump_emit_type_value(d, "%p", *(void **)data);

so, technically, BTF could have different sizeof(void *) from the host
platform. See btf__pointer_size(). Not entirely sure we should care,
but just keep this in mind.

> +       btf_dump_end_type(d);
> +}
> +
> +static void btf_dump_emit_enum_data(struct btf_dump *d,
> +                                   const struct btf_type *t,
> +                                   __u32 id,
> +                                   void *data,
> +                                   __u8 bits_offset)
> +{
> +       const struct btf_enum *enums = btf_enum(t);
> +       __s64 value;
> +       __u16 i;

stick to full sized int, no need to use __u16

also probably better to cache vlen here

> +
> +       btf_dump_start_type(d, t, id);
> +
> +       switch (t->size) {
> +       case 8:
> +               value = *(__s64 *)data;
> +               break;
> +       case 4:
> +               value = *(__s32 *)data;
> +               break;
> +       case 2:
> +               value = *(__s16 *)data;
> +               break;
> +       case 1:
> +               value = *(__s8 *)data;
> +               break;
> +       default:
> +               pr_warn("unexpected size %d for enum, id:[%u]\n", t->size,
> +                       id);
> +               d->data.state.err = -EINVAL;
> +               return;
> +       }
> +
> +       for (i = 0; i < btf_vlen(t); i++) {

for consistency with other iteration loops, enums++ (or rather e++) here?

> +               if (value == enums[i].val) {

if you invert condition here and continue on !=, then you will reduce
nestedness below and won't need to wrap btf_name_of() invocation

> +                       btf_dump_emit_type_value(d, "%s",
> +                                                btf_name_of(d,
> +                                                            enums[i].name_off));
> +                       btf_dump_end_type(d);
> +                       return;
> +               }
> +       }
> +
> +       btf_dump_emit_type_value(d, "%d", value);
> +       btf_dump_end_type(d);
> +}
> +
> +#define for_each_vsi(i, struct_type, member)                   \
> +       for (i = 0, member = btf_var_secinfos(struct_type);     \
> +            i < btf_vlen(struct_type);                         \
> +            i++, member++)
typo: struct_type -> datasec?

but I'd say just drop this macro and write a plain for loop. You are
using more lines of code and harm readability:

const struct btf_var_secinfo *vsi = btf_var_secinfos(t);
__u32 i, vlen = btf_vlen(t);

for (i = 0; i < vlen; i++, vsi++) {
    ...
}

4 lines of code less and I don't have to jump around to match i, t and
vsi inside the for_each_vsi() macro.

And it's good idea to "cache" vlen, makes for loop less wide (and
probably has some miniscule perf benefits, who knows).


> +
> +static void btf_dump_emit_datasec_data(struct btf_dump *d,
> +                                      const struct btf_type *t,
> +                                      __u32 id,
> +                                      void *data,
> +                                      __u8 bits_offset)
> +{
> +       const struct btf_var_secinfo *vsi;
> +       const struct btf_type *var;
> +       __u32 i;
> +
> +       btf_dump_start_type(d, t, id);
> +
> +       btf_dump_emit_type_value(d, "section (\"%s\") = {",
> +                                btf_name_of(d, t->name_off));
> +       for_each_vsi(i, t, vsi) {
> +               var = btf__type_by_id(d->btf, vsi->type);
> +               if (i)
> +                       btf_dump_data_printf(d, ",");
> +               __btf_dump_emit_type_data(d, var, vsi->type,
> +                                         data + vsi->offset,
> +                                         bits_offset);
> +       }
> +       btf_dump_end_type(d);
> +}
> +
> +typedef void (*btf_dump_emit_kind_data)(struct btf_dump *d,
> +                                       const struct btf_type *t,
> +                                       __u32 id,
> +                                       void *data,
> +                                       __u8 bits_offset);
> +
> +static btf_dump_emit_kind_data dump_emit_kind_data[NR_BTF_KINDS] = {
> +       &btf_dump_emit_df_data,
> +       &btf_dump_emit_int_data,
> +       &btf_dump_emit_ptr_data,
> +       &btf_dump_emit_array_data,
> +       &btf_dump_emit_struct_data,
> +       &btf_dump_emit_struct_data,
> +       &btf_dump_emit_enum_data,
> +       &btf_dump_emit_df_data,
> +       &btf_dump_emit_modifier_data,
> +       &btf_dump_emit_modifier_data,
> +       &btf_dump_emit_modifier_data,
> +       &btf_dump_emit_modifier_data,
> +       &btf_dump_emit_df_data,
> +       &btf_dump_emit_df_data,
> +       &btf_dump_emit_var_data,
> +       &btf_dump_emit_datasec_data,

You don't seem to have any tests for DATASEC and VAR... so we don't
really know if everything really works for them

> +};
> +
> +static void __btf_dump_emit_type_data(struct btf_dump *d,
> +                                     const struct btf_type *t,
> +                                     __u32 id,
> +                                     void *data,
> +                                     __u8 bits_offset)
> +{
> +       dump_emit_kind_data[BTF_INFO_KIND(t->info)](d, t, id, data,
> +                                                   bits_offset);

I really don't like this array lookup approach to handle different BTF
kinds. I know the kernel uses this approach internally, but I think it
just complicates everything unnecessarily. I've written a lot of BTF
handling code and I'm still convinced that explicit switch over
btf_kind(t) (please use that instead of BTF_INFO_KIND(t->info), btw)
is significantly more readable and maintainable.

Besides ability to read and follow the logic, you are not checking for
bad kind whatsoever, while with switch it would be easy and natural to
check and handle that. Some corrupted BTF data would lead to cryptic
failures here.

> +}
> +
> +static void btf_dump_emit_type_data(struct btf_dump *d, __u32 id, void *data)
> +{

It's unclear why you need three functions doing pieces of the same
operation, and that operation is pretty linear in its control flow, so
multiple functions buy you nothing. Why __btf_dump_emit_type_data and
btf_dump_emit_type_data logic are not inlined in
btf_dump__emit_type_data()?

> +       const struct btf_type *t = btf__type_by_id(d->btf, id);
> +
> +       memset(&d->data.state, 0, sizeof(d->data.state));
> +
> +       if (!t) {

you can do this check before all the fussing with the state, right
after OPTS_VALID check below. btf_dump__dump_type() does just that and
it works fine.


> +               pr_warn("no type info, id [%u]\n", id);

I'd drop this warning, btf_dump__dump_type() doesn't do it.

> +               d->data.state.err = -EINVAL;
> +               return;
> +       }
> +
> +       __btf_dump_emit_type_data(d, t, id, data, 0);
> +}
> +
> +int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
> +                            const struct btf_dump_emit_type_data_opts *opts,
> +                            void *data)

How about we call it in line with btf_dump__dump_type() as
btf_dump__dump_type_data()? Also, please move opts to be the last
argument.


> +{
> +       int err;
> +
> +       if (!OPTS_VALID(opts, btf_dump_emit_type_data_opts))
> +               return -EINVAL;
> +
> +       d->data.indent_lvl = OPTS_GET(opts, indent_level, 0);
> +       d->data.compact = OPTS_GET(opts, compact, false);
> +       d->data.noname = OPTS_GET(opts, noname, false);
> +       d->data.zero = OPTS_GET(opts, zero, false);
> +       btf_dump_emit_type_data(d, id, data);
> +       err = d->data.state.err;
> +       memset(&d->data, 0, sizeof(d->data));
> +       return err;
> +}
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 1c0fd2d..b81c069 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -350,3 +350,8 @@ LIBBPF_0.3.0 {
>                 xsk_setup_xdp_prog;
>                 xsk_socket__update_xskmap;
>  } LIBBPF_0.2.0;
> +
> +LIBBPF_0.4.0 {
> +       global:
> +               btf_dump__emit_type_data;
> +} LIBBPF_0.3.0;
> --
> 1.8.3.1
>
