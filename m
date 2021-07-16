Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BE43CB273
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 08:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhGPG1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 02:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhGPG1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 02:27:34 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B537DC06175F;
        Thu, 15 Jul 2021 23:24:39 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v189so13167306ybg.3;
        Thu, 15 Jul 2021 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGS4dF7m9YDt22ikGrh6m9rzlAwRnBZR1vnLjkEPK5w=;
        b=KX3ZskpEwK74b6eW1Nr1uOMVv5scaWrcAXpmj0bAlZfBShdgKwY6GCiiYOMcr1WMva
         ep2yBxtiDq+aEUjxWTHM+Fnf6PCV8ZdCFEQOUN+W++qlvEBrjORFRhqywuXwgcJcHr3Y
         ooxn+RR3G34Ruuq3YoGAFImvwwhay3/Gk6myxBnOdEFSY/8DBj/f6nv2QjiaWjohPXy9
         B71SAI3pTjk488qN9RUgGZlqYUIW4e6baRhE+Mjv4HcPxpMLkHT2m+tth3GVomck4F5B
         Z0vLqjRTCiyCbcwbYIvmOTrAceAKeZar0xEv6RSVkCUEJ/bxX6RNYtQmK5oUbvfCZ3yy
         m6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGS4dF7m9YDt22ikGrh6m9rzlAwRnBZR1vnLjkEPK5w=;
        b=mYvLOZBEQAn53ZJsvw33cyIXYbEnEM3uNYr9V5Lu4BeR07fTN7dBCk+IfDr/qdmT0I
         veALkdW4QRnl2xAYMFDRnfDcvMSdLjlEcakgyDjU8O8XaTyeHf0nGeDgA6kGNNmbzSeK
         QzsRwos4qI6mRStIaPSxQJv2+PAAUMFNOmylE2ewB83xhw/9YL6hQMcCpuQXseUbGifv
         zRKdFs02Lrg4xctk1aSZojQuGKCg0UJbvRSWxDcjgtmbIlhuPRmD0QzHf+gHdo8UEsv8
         e9FsIrHlkPpNAkG8+gyOk0w67T6WCLDHNUTPDi3U5xRC/XtU8+vSgxEiZ7SKhKb75ODy
         m3hA==
X-Gm-Message-State: AOAM530QtbjN3DfzbJwYeQIdTu4s0ptVFMGIyLEuVU//qUqAbKMhYJwV
        LGjxrwUyOoywfL8CqBvM3W/ekM7udwPcFtA5c/Q=
X-Google-Smtp-Source: ABdhPJx1G/sRQ4KcwuM+gpkEptlm7rdty7QUL51M1yvjQNDSupnDjXlRDm1m0cuQe3+Rm1D+uWEep6PtALfs+H5nsa4=
X-Received: by 2002:a25:bd09:: with SMTP id f9mr10634302ybk.27.1626416678914;
 Thu, 15 Jul 2021 23:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com> <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 23:24:27 -0700
Message-ID: <CAEf4Bza6B_ekadS5-1G1TEWMQTZTvDUBX0Pbvq5hhzN2Duz1dw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 1/3] libbpf: BTF dumper support for typed data
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

On Thu, Jul 15, 2021 at 8:15 AM Alan Maguire <alan.maguire@oracle.com> wrote:
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

Ok, this looks great. I think I found a few residual problems, so
please see comments below and address them. But I'm inclined to land
this patch set as is because it's in a good shape already, and it is
pretty, so it's hard and time-consuming to weed through minor (at this
point) changes between versions. So please send follow-up patch(es)
with fixes. Hopefully soon enough before the libbpf release. Thanks a
lot for working on this and persevering, this is a great API!

I'll apply a patch set to bpf-next when it will open up for new patches. Thanks.

>  tools/lib/bpf/btf.h      |  19 ++
>  tools/lib/bpf/btf_dump.c | 819 ++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map |   1 +
>  3 files changed, 834 insertions(+), 5 deletions(-)

I also wanted to call out this ^^ versus:

a) initial kernel-sharing version:

  >  18 files changed, 3236 insertions(+), 1319 deletions(-)

b) initial libbpf-only version:

  >  6 files changed, 1251 insertions(+), 3 deletions(-)

And the API actually gained in supported features and correctness.

>

[...]

> +
> +union float_data {
> +       long double ld;
> +       double d;
> +       float f;
> +};

clever

> +
> +static int btf_dump_float_data(struct btf_dump *d,
> +                              const struct btf_type *t,
> +                              __u32 type_id,
> +                              const void *data)
> +{
> +       const union float_data *flp = data;
> +       union float_data fl;
> +       int sz = t->size;
> +
> +       /* handle unaligned data; copy to local union */
> +       if (((uintptr_t)data) % sz) {
> +               memcpy(&fl, data, sz);
> +               flp = &fl;
> +       }
> +
> +       switch (sz) {
> +       case 16:
> +               btf_dump_type_values(d, "%Lf", flp->ld);
> +               break;
> +       case 8:
> +               btf_dump_type_values(d, "%lf", flp->d);
> +               break;
> +       case 4:
> +               btf_dump_type_values(d, "%f", flp->f);
> +               break;
> +       default:
> +               pr_warn("unexpected size %d for id [%u]\n", sz, type_id);
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +

[...]

> +
> +static int btf_dump_array_data(struct btf_dump *d,
> +                              const struct btf_type *t,
> +                              __u32 id,
> +                              const void *data)
> +{
> +       const struct btf_array *array = btf_array(t);
> +       const struct btf_type *elem_type;
> +       __u32 i, elem_size = 0, elem_type_id;
> +       bool is_array_member;
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
> +                       d->typed_dump->is_array_char = true;
> +       }
> +
> +       /* note that we increment depth before calling btf_dump_print() below;
> +        * this is intentional.  btf_dump_data_newline() will not print a
> +        * newline for depth 0 (since this leaves us with trailing newlines
> +        * at the end of typed display), so depth is incremented first.
> +        * For similar reasons, we decrement depth before showing the closing
> +        * parenthesis.
> +        */
> +       d->typed_dump->depth++;
> +       btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
> +
> +       /* may be a multidimensional array, so store current "is array member"
> +        * status so we can restore it correctly later.
> +        */
> +       is_array_member = d->typed_dump->is_array_member;
> +       d->typed_dump->is_array_member = true;
> +       for (i = 0; i < array->nelems; i++, data += elem_size) {
> +               if (d->typed_dump->is_array_terminated)
> +                       break;

I suspect this logic breaks for multi-dimensional char arrays. Please
check and add follow-up tests and fixes, no need to address that in
this patch set, you've suffered enough.


> +               btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id, data, 0, 0);
> +       }
> +       d->typed_dump->is_array_member = is_array_member;
> +       d->typed_dump->depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_type_values(d, "]");
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
> +       /* note that we increment depth before calling btf_dump_print() below;
> +        * this is intentional.  btf_dump_data_newline() will not print a
> +        * newline for depth 0 (since this leaves us with trailing newlines
> +        * at the end of typed display), so depth is incremented first.
> +        * For similar reasons, we decrement depth before showing the closing
> +        * parenthesis.
> +        */

ah, ok, I see. I sort of randomly stumbled on this from a purely
aesthetic reasons, but I'm happy we clarified this because it's
completely non-obvious

> +       d->typed_dump->depth++;
> +       btf_dump_printf(d, "{%s", btf_dump_data_newline(d));
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
> +       d->typed_dump->depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_type_values(d, "}");
> +       return err;
> +}
> +
> +static int btf_dump_ptr_data(struct btf_dump *d,
> +                             const struct btf_type *t,
> +                             __u32 id,
> +                             const void *data)
> +{
> +       btf_dump_type_values(d, "%p", *(void **)data);

Wait, you fixed pointer zero checking logic and misaligned reads for
ints/floats, but none of that for actually printing pointers?...
Please send a follow-up fix.

> +       return 0;
> +}
> +
> +static int btf_dump_get_enum_value(struct btf_dump *d,
> +                                  const struct btf_type *t,
> +                                  const void *data,
> +                                  __u32 id,
> +                                  __s64 *value)
> +{
> +       int sz = t->size;
> +
> +       /* handle unaligned enum value */
> +       if (((uintptr_t)data) % sz) {

nit: probably worth a small helper with obvious name to avoid extra
comments and all those ((()))

> +               *value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
> +               return 0;
> +       }

[...]

> +               elem_type_id = array->type;
> +               elem_size = btf__resolve_size(d->btf, elem_type_id);
> +               elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
> +
> +               ischar = btf_is_int(elem_type) && elem_size == 1;
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

same here, this might be too aggressive for something like char a[2][10] ?

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
> +               if (btf_dump_get_enum_value(d, t, data, id, &value))
> +                       return 0;

why not propagating error here?

> +               if (value == 0)
> +                       return -ENODATA;
> +               return 0;
> +       default:
> +               return 0;
> +       }
> +}
> +

[...]

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
> +                       print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
> +                       enum_val = (__s64)print_num;
> +                       err = btf_dump_enum_data(d, t, id, &enum_val);

this is broken on big-endian, no? Basically almost always it will be
printing either 0, -1 or 0xffffffff?..

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

just realized this doesn't have to be calloc()'ed, it can be on the
stack zero-initialized variable; feel free to switch in the follow up
as well

> +       if (!d->typed_dump)
> +               return libbpf_err(-ENOMEM);

then we won't need to handle this at all

> +
> +       d->typed_dump->data_end = data + data_sz;
> +       d->typed_dump->indent_lvl = OPTS_GET(opts, indent_level, 0);
> +       /* default indent string is a tab */
> +       if (!opts->indent_str)
> +               d->typed_dump->indent_str[0] = '\t';

[...]
