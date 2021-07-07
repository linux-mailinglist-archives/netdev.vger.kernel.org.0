Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714D23BE0B5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 03:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGGCBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 22:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGCBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 22:01:30 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F66C061574;
        Tue,  6 Jul 2021 18:58:50 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k184so644064ybf.12;
        Tue, 06 Jul 2021 18:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWJox0MmJ0fdwiYP4BVPxSrQ2ZqxfaQ9Xy4s85aBqKg=;
        b=PGBASdS/Y/8OZPvhcROfKwDEzyhuMgz4S/WARAAm72j7vtH/D1DAdvARhNGFefkFHk
         JWecw7qKr0oh2r/DEKsGQ5kr7ndggPkYtfSub+2OBtzBmfUBDD16l/8HX3iBiAxvyVGj
         FGqUzZCGDyPFukkYI3PvtwILR4Wbgsue37zZz9uMy+uFTwCd8s6IvY2QRGZjkeXzU+K3
         Yg6nvFR/cdyms77nshOAS5BgLSkxbiyjwVN07XSQeQtmy1yPL9ATpWlqX3nvJHRwsbTV
         dc5pXjbgvuZPTbPFPWS+dePuWIEDG/AjzlsdOV0yvoDhCd2QcSjU9maO6l7sralFmN44
         UXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWJox0MmJ0fdwiYP4BVPxSrQ2ZqxfaQ9Xy4s85aBqKg=;
        b=VcufGsIAW71ESaElPJp6tc31WgPvdiCO5YCbH3/0u6f84CU2sGxVyqxUdvVmk7QDXn
         cFqj0n7UmSL8BhY6fkuZgWubItKpHS4Fmdnj6qNtDrODo6sAR89VNsA6RxkpMVnuww9/
         UvMdPXLi0Z46SIu+6WdsBpJJQV2WiHWRB9X/AjDdMfRRWoI2ViF5+8IERREtr0k9fEVK
         hTGIRjz4k3K8hKrj/PINTea3au+bNrcoLRFlqNIlcWrzStFve9omBcWSKWZIM4pEPzIi
         CEjCqgXvbuydmJnqh417OvnhHottZs0lbAcc6jOD4ruCiCXzrbigp68TannVGX5vKMQk
         YC8g==
X-Gm-Message-State: AOAM530MaQiM8gEXbvOb+v1afzEHbTc/cj2j3NbpDpQPFcmlclSTPfiw
        wk/fo7j0Ydq9HnPlbOgQUDs+L5zuZyTNwSxGXUs=
X-Google-Smtp-Source: ABdhPJwUf/rosQEgRy97A1129n4nONc9wDHKhKw3qa5X/WsCkiSZzl6xaa5KkvkP5Z5f/yRJGPCQT4YZEToZPjDcRwE=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr28253284ybe.425.1625623129729;
 Tue, 06 Jul 2021 18:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com> <1624092968-5598-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1624092968-5598-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 18:58:38 -0700
Message-ID: <CAEf4BzYU30S2ZVDMucALV8R8FfQ=rBgpQ--foD5V5dkFvtnBGQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/3] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 1:56 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Add a BTF dumper for typed data, so that the user can dump a typed
> version of the data provided.
>
> The API is
>
> int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>                              void *data, size_t data_sz,
>                              const struct btf_dump_type_data_opts *opts);
>
> ...where the id is the BTF id of the data pointed to by the "void *"
> argument; for example the BTF id of "struct sk_buff" for a
> "struct skb *" data pointer.  Options supported are
>
>  - a starting indent level (indent_lvl)
>  - a user-specified indent string which will be printed once per
>    indent level; if NULL, tab is chosen but any string <= 32 chars
>    can be provided.
>  - a set of boolean options to control dump display, similar to those
>    used for BPF helper bpf_snprintf_btf().  Options are
>         - compact : omit newlines and other indentation
>         - skip_names: omit member names
>         - emit_zeroes: show zero-value members
>
> Default output format is identical to that dumped by bpf_snprintf_btf(),
> for example a "struct sk_buff" representation would look like this:
>
> struct sk_buff){
>         (union){
>                 (struct){
>                         .next = (struct sk_buff *)0xffffffffffffffff,
>                         .prev = (struct sk_buff *)0xffffffffffffffff,
>                 (union){
>                         .dev = (struct net_device *)0xffffffffffffffff,
>                         .dev_scratch = (long unsigned int)18446744073709551615,
>                 },
>         },
> ...
>
> If the data structure is larger than the *data_sz*
> number of bytes that are available in *data*, as much
> of the data as possible will be dumped and -E2BIG will
> be returned.  This is useful as tracers will sometimes
> not be able to capture all of the data associated with
> a type; for example a "struct task_struct" is ~16k.
> Being able to specify that only a subset is available is
> important for such cases.  On success, the amount of data
> dumped is returned.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Sorry for the long delay, I was out on vacation. It starts to look
really well and pretty straightforward (after a few reading passes :)
).

I think I still spotted a bunch of problems (and made a bunch of nits,
of course :), so we probably need another iteration, but I like where
it's headed, thanks for sticking with this. It will be a useful and
powerful API.

Also, seems like there are some compilation warnings reported, please
fix those as well.

>  tools/lib/bpf/btf.h      |  19 ++
>  tools/lib/bpf/btf_dump.c | 833 ++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map |   1 +
>  3 files changed, 848 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index b54f1c3..5240973 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -184,6 +184,25 @@ struct btf_dump_emit_type_decl_opts {
>  btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
>                          const struct btf_dump_emit_type_decl_opts *opts);
>
> +
> +struct btf_dump_type_data_opts {
> +       /* size of this struct, for forward/backward compatibility */
> +       size_t sz;
> +       int indent_level;
> +       const char *indent_str;

let's swap indent_str and indent_level to avoid unnecessary padding

> +       /* below match "show" flags for bpf_show_snprintf() */
> +       bool compact;           /* no newlines/tabs */

s/tabs/indentation/ ?

> +       bool skip_names;        /* skip member/type names */
> +       bool emit_zeroes;       /* show 0-valued fields */
> +       size_t :0;
> +};
> +#define btf_dump_type_data_opts__last_field emit_zeroes
> +
> +LIBBPF_API int
> +btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
> +                        const void *data, size_t data_sz,
> +                        const struct btf_dump_type_data_opts *opts);
> +
>  /*
>   * A set of helpers for easier BTF types handling
>   */
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 5dc6b517..c59fa07 100644
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
> @@ -53,6 +55,28 @@ struct btf_dump_type_aux_state {
>         __u8 referenced: 1;
>  };
>
> +/* indent string length; one indent string is added for each indent level */
> +#define BTF_DATA_INDENT_STR_LEN                        32
> +
> +/*
> + * Common internal data for BTF type data dump operations.
> + */
> +struct btf_dump_data {
> +       const void *data_end;           /* end of valid data to show */
> +       bool compact;
> +       bool skip_names;
> +       bool emit_zeroes;
> +       __u8 indent_lvl;        /* base indent level */
> +       char indent_str[BTF_DATA_INDENT_STR_LEN + 1];

nit: this is 33-byte array, which is weirdly unsatisfying :) let's make it 32

> +       /* below are used during iteration */
> +       struct {
> +               __u8 depth;
> +               __u8 array_member:1,
> +                    array_terminated:1,
> +                    array_ischar:1;
> +       } state;

nit: use of bifields here is questionable, it doesn't actually save
any space, and even if it used few extra bytes it's totally fine given
btf_dump_data is allocated on demand. Also, given the state struct is
pretty simple, I don't see a problem of just inlining all its members
into btf_dump_data as is (except is_array_member is imo more readable
than state.array_member). So basically, don't try to save a few bytes
here. For depth, just use int instead of __u8. I'd also make array_xxx
as a bool fields (which they totally are) and call them is_array_xxx.

> +};
> +
>  struct btf_dump {
>         const struct btf *btf;
>         const struct btf_ext *btf_ext;
> @@ -60,6 +84,7 @@ struct btf_dump {
>         struct btf_dump_opts opts;
>         int ptr_sz;
>         bool strip_mods;
> +       bool skip_anon_defs;
>         int last_id;
>
>         /* per-type auxiliary state */
> @@ -89,6 +114,10 @@ struct btf_dump {
>          * name occurrences
>          */
>         struct hashmap *ident_names;
> +       /*
> +        * data for typed display; allocated if needed.
> +        */
> +       struct btf_dump_data *typed_dump;
>  };
>
>  static size_t str_hash_fn(const void *key, void *ctx)
> @@ -765,11 +794,11 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
>                 break;
>         case BTF_KIND_FUNC_PROTO: {
>                 const struct btf_param *p = btf_params(t);
> -               __u16 vlen = btf_vlen(t);
> +               __u16 n = btf_vlen(t);
>                 int i;
>
>                 btf_dump_emit_type(d, t->type, cont_id);
> -               for (i = 0; i < vlen; i++, p++)
> +               for (i = 0; i < n; i++, p++)
>                         btf_dump_emit_type(d, p->type, cont_id);
>
>                 break;
> @@ -852,8 +881,9 @@ static void btf_dump_emit_bit_padding(const struct btf_dump *d,
>  static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
>                                      const struct btf_type *t)
>  {
> -       btf_dump_printf(d, "%s %s",
> +       btf_dump_printf(d, "%s%s%s",
>                         btf_is_struct(t) ? "struct" : "union",
> +                       t->name_off ? " " : "",
>                         btf_dump_type_name(d, id));
>  }
>
> @@ -1259,7 +1289,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
>                 case BTF_KIND_UNION:
>                         btf_dump_emit_mods(d, decls);
>                         /* inline anonymous struct/union */
> -                       if (t->name_off == 0)
> +                       if (t->name_off == 0 && !d->skip_anon_defs)
>                                 btf_dump_emit_struct_def(d, id, t, lvl);
>                         else
>                                 btf_dump_emit_struct_fwd(d, id, t);
> @@ -1267,7 +1297,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
>                 case BTF_KIND_ENUM:
>                         btf_dump_emit_mods(d, decls);
>                         /* inline anonymous enum */
> -                       if (t->name_off == 0)
> +                       if (t->name_off == 0 && !d->skip_anon_defs)
>                                 btf_dump_emit_enum_def(d, id, t, lvl);
>                         else
>                                 btf_dump_emit_enum_fwd(d, id, t);
> @@ -1392,6 +1422,39 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
>         btf_dump_emit_name(d, fname, last_was_ptr);
>  }
>
> +/* show type name as (type_name) */
> +static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
> +                                   bool top_level)
> +{
> +       const struct btf_type *t;
> +
> +       /* for array members, we don't bother emitting type name for each
> +        * member to avoid the redundancy of
> +        * .name = (char[4])[(char)'f',(char)'o',(char)'o',]
> +        */
> +       if (d->typed_dump->state.array_member)
> +               return;
> +
> +       /* avoid type name specification for variable/section; it will be done
> +        * for the associated variable value(s).
> +        */
> +       t = btf__type_by_id(d->btf, id);
> +       if (btf_is_var(t) || btf_is_datasec(t))
> +               return;
> +
> +       if (top_level)
> +               btf_dump_printf(d, "(");
> +
> +       d->skip_anon_defs = true;
> +       d->strip_mods = true;
> +       btf_dump_emit_type_decl(d, id, "", 0);
> +       d->strip_mods = false;
> +       d->skip_anon_defs = false;
> +
> +       if (top_level)
> +               btf_dump_printf(d, ")");
> +}
> +
>  /* return number of duplicates (occurrences) of a given name */
>  static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
>                                  const char *orig_name)
> @@ -1442,3 +1505,763 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
>  {
>         return btf_dump_resolve_name(d, id, d->ident_names);
>  }
> +
> +static int btf_dump_dump_type_data(struct btf_dump *d,
> +                                  const char *fname,
> +                                  const struct btf_type *t,
> +                                  __u32 id,
> +                                  const void *data,
> +                                  __u8 bits_offset,
> +                                  __u8 bit_sz);
> +
> +static const char *btf_dump_data_newline(struct btf_dump *d)
> +{
> +       return (d->typed_dump->compact || d->typed_dump->state.depth == 0) ?
> +              "" : "\n";

nit: unnecessary () and keep it on single line, it's ok to use all 100
characters in a single line

> +}
> +
> +static const char *btf_dump_data_delim(struct btf_dump *d)
> +{
> +       return d->typed_dump->state.depth == 0 ? "" : ",";
> +}
> +
> +static void btf_dump_data_pfx(struct btf_dump *d)
> +{
> +       int i, lvl = d->typed_dump->indent_lvl + d->typed_dump->state.depth;
> +
> +       if (d->typed_dump->compact)
> +               return;
> +
> +       for (i = 0; i < lvl; i++)
> +               btf_dump_printf(d, "%s", d->typed_dump->indent_str);
> +}
> +
> +/* A macro is used here as btf_type_value[s]() appends format specifiers
> + * to the format specifier passed in; these do the work of appending
> + * delimiters etc while the caller simply has to specify the type values
> + * in the format specifier + value(s).
> + */
> +#define btf_dump_type_values(d, fmt, ...)                              \
> +       btf_dump_printf(d, fmt "%s%s",                                  \
> +                       __VA_ARGS__,                                    \

use ##__VA_ARGS__ to handle the case of empty __VA_ARGS___

> +                       btf_dump_data_delim(d),                         \
> +                       btf_dump_data_newline(d))
> +
> +static int btf_dump_unsupported_data(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    __u32 id)
> +{
> +       btf_dump_printf(d, "<unsupported kind:%u>", btf_kind(t));
> +       return -ENOTSUP;
> +}
> +
> +static void btf_dump_int128(struct btf_dump *d,
> +                           const struct btf_type *t,
> +                           const void *data)
> +{
> +       __int128 num = *(__int128 *)data;
> +
> +       if ((num >> 64) == 0)
> +               btf_dump_type_values(d, "0x%llx", (long long)num);
> +       else
> +               btf_dump_type_values(d, "0x%llx%016llx", (long long)num >> 32,
> +                                    (long long)num);
> +}
> +
> +static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
> +                                                   const void *data,
> +                                                   __u8 bits_offset,
> +                                                   __u8 bit_sz)
> +{
> +       __u16 left_shift_bits, right_shift_bits;
> +       __u8 nr_copy_bits, nr_copy_bytes, i;
> +       unsigned __int128 num = 0, ret;
> +       const __u8 *bytes = data;
> +
> +       /* Bitfield value retrieval is done in two steps; first relevant bytes are
> +        * stored in num, then we left/right shift num to eliminate irrelevant bits.
> +        */
> +       nr_copy_bits = bit_sz + bits_offset;
> +       nr_copy_bytes = roundup(nr_copy_bits, 8) / 8;
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> +       for (i = 0; i < nr_copy_bytes; i++)
> +               num += bytes[i] << (8 * i);

don't you need (unsigned __int128)bytes[i] cast before the bit shifting?

But I'd recommend to rewrite this logic  for little endian as

for (i = nr_copy_bytes - 1; i >= 0; i--)
    num = num * 256 + bytes[i];

and for big endian as

for (i = 0; i < nr_copy_bytes; i++)
    num = num * 256 + bytes[i];

> +#elif __BYTE_ORDER == __BIG_ENDIAN
> +       for (i = nr_copy_bytes - 1; i >= 0; i--)
> +               num += bytes[i] << (8 * i);
> +#else
> +# error "Unrecognized __BYTE_ORDER__"
> +#endif
> +       left_shift_bits = 128 - nr_copy_bits;
> +       right_shift_bits = 128 - bit_sz;
> +
> +       ret = (num << left_shift_bits) >> right_shift_bits;
> +
> +       return ret;
> +}
> +
> +static int btf_dump_bitfield_data(struct btf_dump *d,
> +                                 const struct btf_type *t,
> +                                 const void *data,
> +                                 __u8 bits_offset,
> +                                 __u8 bit_sz)
> +{
> +       unsigned __int128 print_num;
> +
> +       print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);
> +       btf_dump_int128(d, t, &print_num);
> +
> +       return 0;
> +}
> +
> +static int btf_dump_int_bits(struct btf_dump *d,
> +                            const struct btf_type *t,
> +                            const void *data,
> +                            __u8 bits_offset,
> +                            __u8 bit_sz)
> +{
> +       data += bits_offset / 8;

this is very confusing... you are adjusting data offset by the full
amount of bytes in bits_offset but then pass unmodified bits_offset
below. I'd expect that either btf_dump_bitfield_data handles this data
adjustment internally and transparently and thus callers pass data
pointer as is, or each caller would need to make sure that bits_offset
< 8, otherwise btf_dump_bitfield_get_data (thought
btf_dump_bitfield_data) would be doing something weird. I think the
former (btf_dump_bitfield_get_data handles all the cases nicely) is
preferrable.

Or am I missing something?

> +       return btf_dump_bitfield_data(d, t, data, bits_offset, bit_sz);
> +}
> +
> +static int btf_dump_int_bits_check_zero(struct btf_dump *d,
> +                                       const struct btf_type *t,
> +                                       const void *data,
> +                                       __u8 bits_offset,
> +                                       __u8 bit_sz)
> +{
> +       __int128 print_num;
> +
> +       data += bits_offset / 8;
> +       print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);

same confusion as above

> +       if (print_num == 0)
> +               return -ENODATA;
> +       return 0;
> +}
> +
> +static int btf_dump_int_check_zero(struct btf_dump *d,
> +                               const struct btf_type *t,
> +                               const void *data,
> +                               __u8 bits_offset)
> +{
> +       __u8 nr_bits = btf_int_bits(t);

see below about the problem with BTF_KIND_PTR zero check. If you use
t->size here instead, then all the logic will work for BTF_KIND_PTR as
well and will handle both 32-bit and 64-bit cases.

> +       bool zero = false;
> +
> +       if (bits_offset)

see below about bits_offset always being zero. For this case, though,
I'd do the same memcmp() check and keep it nice, short, and agnostic
to alignment. WDYT?

> +               return btf_dump_int_bits_check_zero(d, t, data, bits_offset, 0);
> +
> +       switch (nr_bits) {
> +       case 128:
> +               zero = *(__int128 *)data == 0;
> +               break;
> +       case 64:
> +               zero = *(__s64 *)data == 0;
> +               break;
> +       case 32:
> +               zero = *(__s32 *)data == 0;
> +               break;
> +       case 16:
> +               zero = *(__s16 *)data == 0;
> +               break;
> +       case 8:
> +               zero = *(__s8 *)data == 0;
> +               break;
> +       default:
> +               pr_warn("unexpected nr_bits %d for int\n", nr_bits);
> +               return -EINVAL;
> +       }
> +       if (zero)
> +               return -ENODATA;
> +       return 0;
> +}
> +
> +static int btf_dump_int_data(struct btf_dump *d,
> +                            const struct btf_type *t,
> +                            __u32 type_id,
> +                            const void *data,
> +                            __u8 bits_offset)
> +{
> +       __u8 encoding = btf_int_encoding(t);
> +       bool sign = encoding & BTF_INT_SIGNED;
> +       __u8 nr_bits = btf_int_bits(t);
> +
> +       if (bits_offset)
> +               return btf_dump_int_bits(d, t, data, bits_offset, 0);

This is always non-bitfield case, right? This means bits_offset is
always a multiple of 8, but I'd argue that it should always be zero
instead and data has to be adjusted by the called (which is the case
except what I pointed out above).

But struct might be packed and on some architectures accessed below
might be problematic. So instead this should be check for whether data
is naturally aligned for the desired int type. Isn't that right? So
it's something like below

int sz = t->size;

if (sz == 0) return -EINVAL;

if (((uintptr_t)data) % sz)
   return btf_dump_int_bits(d, t, data, 0, 0);

switch (sz) { ... }

> +
> +       switch (nr_bits) {
> +       case 128:
> +               btf_dump_int128(d, t, data);
> +               break;
> +       case 64:
> +               if (sign)
> +                       btf_dump_type_values(d, "%lld", *(long long *)data);
> +               else
> +                       btf_dump_type_values(d, "%llu", *(unsigned long long *)data);
> +               break;
> +       case 32:
> +               if (sign)
> +                       btf_dump_type_values(d, "%d", *(__s32 *)data);
> +               else
> +                       btf_dump_type_values(d, "%u", *(__u32 *)data);
> +               break;
> +       case 16:
> +               if (sign)
> +                       btf_dump_type_values(d, "%d", *(__s16 *)data);
> +               else
> +                       btf_dump_type_values(d, "%u", *(__u16 *)data);
> +               break;
> +       case 8:
> +               if (d->typed_dump->state.array_ischar) {
> +                       /* check for null terminator */
> +                       if (d->typed_dump->state.array_terminated)
> +                               break;
> +                       if (*(char *)data == '\0') {
> +                               d->typed_dump->state.array_terminated = 1;
> +                               break;
> +                       }
> +                       if (isprint(*(char *)data)) {
> +                               btf_dump_type_values(d, "'%c'", *(char *)data);
> +                               break;
> +                       }
> +               }
> +               if (sign)
> +                       btf_dump_type_values(d, "%d", *(__s8 *)data);
> +               else
> +                       btf_dump_type_values(d, "%u", *(__u8 *)data);
> +               break;
> +       default:
> +               pr_warn("unexpected nr_bits %d for id [%u]\n", nr_bits, type_id);
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int btf_dump_float_check_zero(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    const void *data)
> +{
> +       static __u8 bytecmp[16] = {};
> +       int nr_bytes = t->size;
> +
> +       if (nr_bytes > 16 || nr_bytes < 2) {
> +               pr_warn("unexpected size %d for float\n", nr_bytes);
> +               return -EINVAL;
> +       }
> +       if (memcmp(data,  bytecmp, nr_bytes) == 0)

extra space before bytecmp

> +               return -ENOMSG;

I think you used -ENODATA in other places?...

> +
> +       return 0;
> +}
> +
> +static int btf_dump_float_data(struct btf_dump *d,
> +                              const struct btf_type *t,
> +                              __u32 type_id,
> +                              const void *data,
> +                              __u8 bits_offset)

bits_offset is not used and it can't be non-zero, right?

> +{
> +       int nr_bytes = t->size;
> +
> +       switch (nr_bytes) {
> +       case 16:
> +               btf_dump_type_values(d, "%Lf", *(long double *)data);
> +               break;
> +       case 8:
> +               btf_dump_type_values(d, "%f", *(double *)data);

%lf?

> +               break;
> +       case 4:
> +               btf_dump_type_values(d, "%f", *(float *)data);
> +               break;
> +       default:
> +               pr_warn("unexpected size %d for id [%u]\n", nr_bytes, type_id);
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int btf_dump_var_data(struct btf_dump *d,
> +                            const struct btf_type *v,
> +                            __u32 id,
> +                            const void *data)
> +{
> +       enum btf_func_linkage linkage = btf_var(v)->linkage;
> +       const struct btf_type *t;
> +       const char *l;
> +       __u32 type_id;
> +
> +       switch (linkage) {
> +       case BTF_FUNC_STATIC:
> +               l = "static ";
> +               break;
> +       case BTF_FUNC_EXTERN:
> +               l = "extern ";
> +               break;
> +       case BTF_FUNC_GLOBAL:
> +       default:
> +               l = "";
> +               break;
> +       }
> +
> +       /* format of output here is [linkage] [type] [varname] = (type)value,
> +        * for example "static int cpu_profile_flip = (int)1"
> +        */
> +       btf_dump_printf(d, "%s", l);
> +       type_id = v->type;
> +       t = btf__type_by_id(d->btf, type_id);
> +       btf_dump_emit_type_cast(d, type_id, false);
> +       btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
> +       return btf_dump_dump_type_data(d, NULL, t, type_id, data, 0, 0);
> +}
> +
> +static int btf_dump_array_data(struct btf_dump *d,
> +                              const struct btf_type *t,
> +                              __u32 id,
> +                              const void *data)
> +{
> +       const struct btf_array *array = btf_array(t);
> +       const struct btf_type *elem_type;
> +       __u32 i, elem_size = 0, elem_type_id;
> +       int array_member;
> +
> +       elem_type_id = array->type;
> +       elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
> +       elem_size = btf__resolve_size(d->btf, elem_type_id);
> +       if (elem_size <= 0) {
> +               pr_warn("unexpected elem size %d for array type [%u]\n", elem_size, id);
> +               return -EINVAL;
> +       }
> +
> +       if (btf_is_int(elem_type)) {
> +               /*
> +                * BTF_INT_CHAR encoding never seems to be set for
> +                * char arrays, so if size is 1 and element is
> +                * printable as a char, we'll do that.
> +                */
> +               if (elem_size == 1)
> +                       d->typed_dump->state.array_ischar = true;
> +       }
> +
> +       d->typed_dump->state.depth++;
> +       btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
> +
> +       /* may be a multidimensional array, so store current "is array member"
> +        * status so we can restore it correctly later.
> +        */
> +       array_member = d->typed_dump->state.array_member;
> +       d->typed_dump->state.array_member = 1;
> +       for (i = 0;
> +            i < array->nelems && !d->typed_dump->state.array_terminated;
> +            i++) {

stylistic nit: this multi-line for is quite complicated, let's do a separate

if (d->typed_dump->state.array_terminated)
    break;

inside the loop and keep the for loop itself short and straightforward

> +               btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id, data, 0, 0);
> +               data += elem_size;

data += elem_size actually might go into the for along the i++

> +       }
> +       d->typed_dump->state.array_member = array_member;
> +       d->typed_dump->state.depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_printf(d, "]%s%s", btf_dump_data_delim(d), btf_dump_data_newline(d));

with ## suggestion above, this should be just

btf_dump_type_values(d, "]")

right?

> +
> +       return 0;
> +}
> +
> +static int btf_dump_struct_data(struct btf_dump *d,
> +                               const struct btf_type *t,
> +                               __u32 id,
> +                               const void *data)
> +{
> +       const struct btf_member *m = btf_members(t);
> +       __u16 n = btf_vlen(t);
> +       int i, err;
> +
> +       d->typed_dump->state.depth++;
> +       btf_dump_printf(d, "{%s", btf_dump_data_newline(d));

subjective nit, but logically you open { and then depth increases, so
I'd swap these two lines

> +
> +       for (i = 0; i < n; i++, m++) {
> +               const struct btf_type *mtype;
> +               const char *mname;
> +               __u32 moffset;
> +               __u8 bit_sz;
> +
> +               mtype = btf__type_by_id(d->btf, m->type);
> +               mname = btf_name_of(d, m->name_off);
> +               moffset = btf_member_bit_offset(t, i);
> +
> +               bit_sz = btf_member_bitfield_size(t, i);
> +               err = btf_dump_dump_type_data(d, mname, mtype, m->type, data + moffset / 8,
> +                                             moffset % 8, bit_sz);
> +               if (err < 0)
> +                       return err;
> +       }
> +       d->typed_dump->state.depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_printf(d, "}%s%s", btf_dump_data_delim(d), btf_dump_data_newline(d));

same as above, could be btf_dump_type_values(), if I'm not mistaken

btw, as opposed to above here the sequence makes sense, depth is
decreased first, then we emit closing }

> +       return err;
> +}
> +
> +static int btf_dump_ptr_data(struct btf_dump *d,
> +                             const struct btf_type *t,
> +                             __u32 id,
> +                             const void *data)
> +{
> +       btf_dump_type_values(d, "%p", *(void **)data);

see below about making assumptions about pointer size, in general case
this is wrong

> +       return 0;
> +}
> +
> +static int btf_dump_get_enum_value(const struct btf_type *t,
> +                                  const void *data,
> +                                  __u32 id,
> +                                  __s64 *value)
> +{
> +       switch (t->size) {
> +       case 8:
> +               *value = *(__s64 *)data;
> +               return 0;
> +       case 4:
> +               *value = *(__s32 *)data;
> +               return 0;
> +       case 2:
> +               *value = *(__s16 *)data;
> +               return 0;
> +       case 1:
> +               *value = *(__s8 *)data;
> +       default:
> +               pr_warn("unexpected size %d for enum, id:[%u]\n", t->size, id);
> +               return -EINVAL;
> +       }

similar to handling floats and ints, we need to account for packed
unaligned data

> +}
> +
> +static int btf_dump_enum_data(struct btf_dump *d,
> +                             const struct btf_type *t,
> +                             __u32 id,
> +                             const void *data)
> +{
> +       const struct btf_enum *e;
> +       __s64 value;
> +       int i, err;
> +
> +       err = btf_dump_get_enum_value(t, data, id, &value);
> +       if (err)
> +               return err;
> +
> +       for (i = 0, e = btf_enum(t); i < btf_vlen(t); i++, e++) {
> +               if (value != e->val)
> +                       continue;
> +               btf_dump_type_values(d, "%s", btf_name_of(d, e->name_off));
> +               return 0;
> +       }
> +
> +       btf_dump_type_values(d, "%d", value);
> +       return 0;
> +}
> +
> +static int btf_dump_datasec_data(struct btf_dump *d,
> +                                const struct btf_type *t,
> +                                __u32 id,
> +                                const void *data)
> +{
> +       const struct btf_var_secinfo *vsi;
> +       const struct btf_type *var;
> +       __u32 i;
> +       int err;
> +
> +       btf_dump_type_values(d, "SEC(\"%s\") ",
> +                            btf_name_of(d, t->name_off));

nit: single line

> +       for (i = 0, vsi = btf_var_secinfos(t); i < btf_vlen(t); i++, vsi++) {
> +               var = btf__type_by_id(d->btf, vsi->type);
> +               err = btf_dump_dump_type_data(d, NULL, var, vsi->type, data + vsi->offset, 0, 0);
> +               if (err < 0)
> +                       return err;
> +               btf_dump_printf(d, ";");
> +       }
> +       return 0;
> +}
> +
> +/* return size of type, or if base type overflows, return -E2BIG. */
> +static int btf_dump_type_data_check_overflow(struct btf_dump *d,
> +                                            const struct btf_type *t,
> +                                            __u32 id,
> +                                            const void *data,
> +                                            __u8 bits_offset)
> +{
> +       __s64 size = btf__resolve_size(d->btf, id);
> +
> +       if (size < 0 || size >= INT_MAX) {
> +               pr_warn("unexpected size [%lld] for id [%u]\n",
> +                       size, id);
> +               return -EINVAL;
> +       }
> +
> +       /* Only do overflow checking for base types; we do not want to
> +        * avoid showing part of a struct, union or array, even if we
> +        * do not have enough data to show the full object.  By
> +        * restricting overflow checking to base types we can ensure
> +        * that partial display succeeds, while avoiding overflowing
> +        * and using bogus data for display.
> +        */
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       if (!t) {
> +               pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +       switch (BTF_INFO_KIND(t->info)) {

btf_kind(t)

> +       case BTF_KIND_INT:
> +       case BTF_KIND_PTR:
> +       case BTF_KIND_ENUM:

BTF_KIND_FLOAT as well, right?

> +               if (data + bits_offset / 8 + size > d->typed_dump->data_end)
> +                       return -E2BIG;
> +               break;
> +       default:
> +               break;
> +       }
> +       return (int)size;
> +}
> +
> +static int btf_dump_type_data_check_zero(struct btf_dump *d,
> +                                        const struct btf_type *t,
> +                                        __u32 id,
> +                                        const void *data,
> +                                        __u8 bits_offset,
> +                                        __u8 bit_sz)
> +{
> +       __s64 value;
> +       int i, err;
> +
> +       /* toplevel exceptions; we show zero values if
> +        * - we ask for them (emit_zeros)
> +        * - if we are at top-level so we see "struct empty { }"
> +        * - or if we are an array member and the array is non-empty and
> +        *   not a char array; we don't want to be in a situation where we
> +        *   have an integer array 0, 1, 0, 1 and only show non-zero values.
> +        *   If the array contains zeroes only, or is a char array starting
> +        *   with a '\0', the array-level check_zero() will prevent showing it;
> +        *   we are concerned with determining zero value at the array member
> +        *   level here.
> +        */
> +       if (d->typed_dump->emit_zeroes || d->typed_dump->state.depth == 0 ||
> +           (d->typed_dump->state.array_member &&
> +            !d->typed_dump->state.array_ischar))
> +               return 0;
> +
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       if (!t) {

see below, btf_dump_type_data_check_overflow already validated
everything, no need to re-check this, let's keep the code clean and
succinct

> +               pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +
> +       switch (BTF_INFO_KIND(t->info)) {

btf_kind(t)

> +       case BTF_KIND_INT:
> +               if (bit_sz)
> +                       return btf_dump_int_bits_check_zero(d, t, data,
> +                                                           bits_offset, bit_sz);

single line is ok here

> +               return btf_dump_int_check_zero(d, t, data, bits_offset);
> +       case BTF_KIND_FLOAT:
> +               return btf_dump_float_check_zero(d, t, data);
> +       case BTF_KIND_PTR:
> +               if (*((void **)data) == NULL)

so this is wrong when BTF's pointer size differs from host pointer
size (e.g., 64-bit BTF vs 32-bit host and vice versa). It's better to
do byte-by-byte comparison based on ptr type's size

> +                       return -ENODATA;
> +               return 0;
> +       case BTF_KIND_ARRAY: {
> +               const struct btf_array *array = btf_array(t);
> +               const struct btf_type *elem_type;
> +               __u32 elem_type_id, elem_size;
> +               bool ischar;
> +
> +               elem_type_id = array->type;
> +               elem_size = btf__resolve_size(d->btf, elem_type_id);
> +               elem_type =  btf__type_by_id(d->btf, elem_type_id);
> +
> +               ischar = btf_is_int(elem_type) && elem_size == 1;

this won't work if element type is const int or is a typedef. So need
to skip_mods_and_typedefs before checking this.

> +
> +               /* check all elements; if _any_ element is nonzero, all
> +                * of array is displayed.  We make an exception however
> +                * for char arrays where the first element is 0; these
> +                * are considered zeroed also, even if later elements are
> +                * non-zero because the string is terminated.
> +                */
> +               for (i = 0; i < array->nelems; i++) {
> +                       if (i == 0 && ischar && *(char *)data == 0)
> +                               return -ENODATA;
> +                       err = btf_dump_type_data_check_zero(d, elem_type,
> +                                                           elem_type_id,
> +                                                           data +
> +                                                           (i * elem_size),
> +                                                           bits_offset, 0);
> +                       if (err != -ENODATA)
> +                               return err;
> +               }
> +               return -ENODATA;
> +       }
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION: {
> +               const struct btf_member *m = btf_members(t);
> +               __u16 n = btf_vlen(t);
> +
> +               /* if any struct/union member is non-zero, the struct/union
> +                * is considered non-zero and dumped.
> +                */
> +               for (i = 0; i < n; i++, m++) {
> +                       const struct btf_type *mtype;
> +                       __u32 moffset;
> +                       __u8 bit_sz;
> +
> +                       mtype = btf__type_by_id(d->btf, m->type);
> +                       moffset = btf_member_bit_offset(t, i);
> +
> +                       /* btf_int_bits() does not store member bitfield size;
> +                        * bitfield size needs to be stored here so int display
> +                        * of member can retrieve it.
> +                        */
> +                       bit_sz = btf_member_bitfield_size(t, i);
> +                       err = btf_dump_type_data_check_zero(d, mtype, m->type, data + moffset / 8,
> +                                                           moffset % 8, bit_sz);
> +                       if (err != ENODATA)
> +                               return err;
> +               }
> +               return -ENODATA;
> +       }
> +       case BTF_KIND_ENUM:
> +               if (btf_dump_get_enum_value(t, data, id, &value))
> +                       return 0;
> +               if (value == 0)
> +                       return -ENODATA;
> +               return 0;
> +       default:
> +               return 0;
> +       }
> +}
> +
> +/* returns size of data dumped, or error. */
> +static int btf_dump_dump_type_data(struct btf_dump *d,
> +                                  const char *fname,
> +                                  const struct btf_type *t,
> +                                  __u32 id,
> +                                  const void *data,
> +                                  __u8 bits_offset,
> +                                  __u8 bit_sz)
> +{
> +       int size, err;
> +
> +       size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
> +       if (size < 0)
> +               return size;
> +       err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset, bit_sz);
> +       if (err) {
> +               /* zeroed data is expected and not an error, so simply skip
> +                * dumping such data.  Record other errors however.
> +                */
> +               if (err == -ENODATA)
> +                       return size;
> +               return err;
> +       }
> +       btf_dump_data_pfx(d);
> +
> +       if (!d->typed_dump->skip_names) {
> +               if (fname && strlen(fname) > 0)
> +                       btf_dump_printf(d, ".%s = ", fname);
> +               btf_dump_emit_type_cast(d, id, true);
> +       }
> +
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       if (!t) {

btf_dump_type_data_check_overflow already ensured this can't happen,
let's drop unnecessary check

> +               pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +       switch (BTF_INFO_KIND(t->info)) {

btf_kind(t)

> +       case BTF_KIND_UNKN:
> +       case BTF_KIND_FWD:
> +       case BTF_KIND_FUNC:
> +       case BTF_KIND_FUNC_PROTO:
> +               err = btf_dump_unsupported_data(d, t, id);
> +               break;
> +       case BTF_KIND_INT:
> +               if (bit_sz)
> +                       err = btf_dump_bitfield_data(d, t, data, bits_offset, bit_sz);
> +               else
> +                       err = btf_dump_int_data(d, t, id, data, bits_offset);
> +               break;
> +       case BTF_KIND_FLOAT:
> +               err = btf_dump_float_data(d, t, id, data, bits_offset);
> +               break;
> +       case BTF_KIND_PTR:
> +               err = btf_dump_ptr_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_ARRAY:
> +               err = btf_dump_array_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +               err = btf_dump_struct_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_ENUM:
> +               /* handle bitfield and int enum values */
> +               if (bit_sz) {
> +                       unsigned __int128 print_num;
> +                       __s64 enum_val;
> +
> +                       print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);
> +                       enum_val = (__s64)print_num;
> +                       err = btf_dump_enum_data(d, t, id, &enum_val);
> +               } else
> +                       err = btf_dump_enum_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_VAR:
> +               err = btf_dump_var_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_DATASEC:
> +               err = btf_dump_datasec_data(d, t, id, data);
> +               break;
> +       default:
> +               pr_warn("unexpected kind [%u] for id [%u]\n",
> +                       BTF_INFO_KIND(t->info), id);
> +               return -EINVAL;
> +       }
> +       if (err < 0)
> +               return err;
> +       return size;
> +}
> +
> +int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
> +                            const void *data, size_t data_sz,
> +                            const struct btf_dump_type_data_opts *opts)
> +{
> +       const struct btf_type *t;
> +       int ret;
> +
> +       if (!OPTS_VALID(opts, btf_dump_type_data_opts))
> +               return libbpf_err(-EINVAL);
> +
> +       t = btf__type_by_id(d->btf, id);
> +       if (!t)
> +               return libbpf_err(-ENOENT);
> +
> +       d->typed_dump = calloc(1, sizeof(struct btf_dump_data));
> +       if (!d->typed_dump)
> +               return libbpf_err(-ENOMEM);
> +
> +       d->typed_dump->data_end = data + data_sz;
> +       d->typed_dump->indent_lvl = OPTS_GET(opts, indent_level, 0);
> +       /* default indent string is a tab */
> +       if (!opts->indent_str)
> +               d->typed_dump->indent_str[0] = '\t';

both sides of if have to have have {} or not, but not mixed

> +       else {
> +               if (strlen(opts->indent_str) >
> +                   sizeof(d->typed_dump->indent_str) - 1)
> +                       return libbpf_err(-EINVAL);

gotta free d->typed_dump here, so goto cleanup of some kind is needed
here. I'd probably just silently truncate the provided string, though.

> +               strncpy(d->typed_dump->indent_str, opts->indent_str,
> +                       sizeof(d->typed_dump->indent_str) - 1);

GCC will probably complain about potentially non-zero terminated
indent_str. Let's simplify all this with s/strncpy/strncat/ and
dropping the strlen check above. It will silently truncate and ensure
zero termination.

> +       }
> +
> +       d->typed_dump->compact = OPTS_GET(opts, compact, false);
> +       d->typed_dump->skip_names = OPTS_GET(opts, skip_names, false);
> +       d->typed_dump->emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
> +
> +       ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0, 0);
> +
> +       free(d->typed_dump);
> +
> +       return libbpf_err(ret);
> +}
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 944c99d..5bfc107 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -373,5 +373,6 @@ LIBBPF_0.5.0 {
>                 bpf_map__initial_value;
>                 bpf_map_lookup_and_delete_elem_flags;
>                 bpf_object__gen_loader;
> +               btf_dump__dump_type_data;
>                 libbpf_set_strict_mode;
>  } LIBBPF_0.4.0;
> --
> 1.8.3.1
>
