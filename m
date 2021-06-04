Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8C39C416
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFDXvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:51:53 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:38675 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFDXvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 19:51:52 -0400
Received: by mail-yb1-f176.google.com with SMTP id m9so9506220ybo.5;
        Fri, 04 Jun 2021 16:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VGiDEY1a10o4UTrTUSqSgmAtDoufJ3sz8GmLSFCG7RA=;
        b=OCMrl6sleUtolFv3M93MlzvkGyfjDIw3sAo9aFAJyIg8OcLAhq9r2uaIyUm+wewyAL
         0y2R97Sc/3Dt18XriB4ycOGD0QS3xmgHkc4rUpQdGz2X2fU+erkwQ6mJ0s79g55K0ekc
         zwqVEML5IQ7tAuI/pChyT/mpME8E4BORQRItDbBKDMl2X/I2VLcEVvllpflSOMAltEfe
         IKFyghEyOYmWNk3Ec6rF0k6ohzgRkR+I0Bni8m9AHyC3xxSA8zb6mxrZDPhvdznmjL35
         Tfbm9GtcrGIQ1erJHpGYMYPJT0VwhX1gW5yy3t2CJKBblWdbtsuyKTwT4IfdMY9Sw/Lm
         0ekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VGiDEY1a10o4UTrTUSqSgmAtDoufJ3sz8GmLSFCG7RA=;
        b=e7Q4yIZN050TkLzY/f0wYV5GtaKgff0YgVLMA17sQ0wBplGHrAZDp/nLlSxtD4k9kd
         /6FR9OQbV4AdIgHRrd/MQCvLJc/Ob4YfS715Ifwdr+yJ+5/NtrCxbm1GjoYY2NJyxjCn
         7y6jtyk/115u6r2hfbMrWr4+C7Lm63BVCMYwZEODV04QecnxjE3hyHKrbjP7HdR1Nt0V
         hMwO+FXLNn0ZrVqDBb9Lu6ryUNrSV/wWRnXO3JSQevGw/ifCjTMgNPVZey3AU8fIKnbg
         UYLWr31U+fAB1BCONW5W+TvLmbcjOmw2qT08OSivY4R40vOwZQxlO4yofrp8MS3RxmRX
         yrkQ==
X-Gm-Message-State: AOAM533CAXFUZ13lgf6BMJcDEOfxC+dVbMe9rggov5dZZQFAmC2rOU+M
        KpISNIhtHJ29SuoBBD95A4N5zVIH9pc/WPqe3pE=
X-Google-Smtp-Source: ABdhPJxBChoRfZ6ernpcuwPUqq3ZdfgRmvZPI5DdN4DytbhYg+SZn8BVBd8JQ7fWDXmuKywPEitGolsJEp3lQj27HNk=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr8522518ybr.425.1622850532472;
 Fri, 04 Jun 2021 16:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com> <1622558220-2849-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1622558220-2849-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Jun 2021 16:48:41 -0700
Message-ID: <CAEf4BzYtbnphCkhz0epMKE4zWfvSOiMpu+-SXp9hadsrRApuZw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/2] libbpf: BTF dumper support for typed data
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

On Tue, Jun 1, 2021 at 7:37 AM Alan Maguire <alan.maguire@oracle.com> wrote:
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
>    indent level; by default tab is chosen but any string <= 4 chars
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
>  tools/lib/bpf/btf.h      |   22 +
>  tools/lib/bpf/btf_dump.c | 1008 +++++++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 1029 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index b54f1c3..10470e0 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -184,6 +184,28 @@ struct btf_dump_emit_type_decl_opts {
>  btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
>                          const struct btf_dump_emit_type_decl_opts *opts);
>
> +
> +/* indent string length; one indent string is added for each indent level */
> +#define BTF_DATA_INDENT_STR_LEN                        4

Why 4? And why this is part of libbpf public API? I think it's fine to
limit this internally to avoid unnecessary memory allocations, but
let's not expose that into an API, given we don't really expect anyone
to do something too crazy here. But internally let's make it a 16 or
32 at least.

> +
> +struct btf_dump_type_data_opts {
> +       /* size of this struct, for forward/backward compatibility */
> +       size_t sz;
> +       int indent_level;
> +       char indent_str[BTF_DATA_INDENT_STR_LEN + 1];

please make this `const char *` and copy into internal fixed-length array

> +       /* below match "show" flags for bpf_show_snprintf() */
> +       bool compact;           /* no newlines/tabs */
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
> index 5dc6b517..b1b356a 100644
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
> @@ -19,6 +21,12 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
>
> +#define BITS_PER_U128                  128

I thought I can live with this, but no, I can't, sorry. You use this
in exactly 2 lines, one after another. Just hard-code 128, there is no
way that uint128_t will have a different number of bits. Ever.

> +#define BITS_PER_BYTE_MASK             (8 - 1)

not even used in a code, just in BITS_PER_BYTE_MASKED below

> +#define BITS_PER_BYTE_MASKED(bits)     ((bits) & BITS_PER_BYTE_MASK)

& 7

> +#define BITS_ROUNDDOWN_BYTES(bits)     ((bits) / 8)

just do x / 8 where necessary, it's not a complicated and non-obvious math

> +#define BITS_ROUNDUP_BYTES(bits)       (roundup(bits, 8))

same, just roundup(bits, 8), please

> +
>  static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
>  static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
>
> @@ -53,6 +61,26 @@ struct btf_dump_type_aux_state {
>         __u8 referenced: 1;
>  };
>
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

so here it's fine to use fixed array, just let's make it a bit bigger,
4 seems a very limited (what if I want 8 characters, just not tab but
spaces?)

> +       /* below are used during iteration */
> +       struct {
> +               __u8 depth;
> +               __u8 array_member:1,
> +                    array_terminated:1,
> +                    array_ischar:1;
> +               __u32 bitfield_size;
> +       } state;
> +};
> +
>  struct btf_dump {
>         const struct btf *btf;
>         const struct btf_ext *btf_ext;
> @@ -89,6 +117,10 @@ struct btf_dump {
>          * name occurrences
>          */
>         struct hashmap *ident_names;
> +       /*
> +        * data for typed display; allocated if needed.
> +        */
> +       struct btf_dump_data *data;

"data" is quite generic (and you can confuse it with the actual bytes
you are dumping). Don't have a perfect suggestion, but it's a typed
data dumper, so something like "typed_dump" would be still better,
probably

>  };
>
>  static size_t str_hash_fn(const void *key, void *ctx)
> @@ -765,11 +797,11 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
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
> @@ -1392,6 +1424,112 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
>         btf_dump_emit_name(d, fname, last_was_ptr);
>  }
>
> +/* show type name as (type_name) */
> +static void btf_dump_emit_type_name(struct btf_dump *d, __u32 id,
> +                                   int lvl, bool toplevel)
> +{

So I still don't like that we have so much logic here that duplicates
what btf_dump_emit_type_decl does. Not just because it's more code
than necessary that needs to be maintained, but also because it's too
easy to arbitrarily and unnecessarily deviate. You can see that with
the handling of arrays (you don't emit the size, which is essential
part of the type and I think you should) and func_proto (whitespacing
differences). So I've played a little bit with this to see how bad it
really would be. I don't think it's bad, honestly. I needed to add a
special modifier for emitting anonymous struct/union/enum as just
"struct"/"union"/"enum", which is a tiny modification, so doesn't seem
like a big problem. See improperly formatted (due to gmail) patch
below

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index b1b356af75f6..919ad016d1e2 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -88,6 +88,7 @@ struct btf_dump {
     struct btf_dump_opts opts;
     int ptr_sz;
     bool strip_mods;
+    bool skip_anon_defs;
     int last_id;

     /* per-type auxiliary state */
@@ -884,8 +885,9 @@ static void btf_dump_emit_bit_padding(const struct
btf_dump *d,
 static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
                      const struct btf_type *t)
 {
-    btf_dump_printf(d, "%s %s",
+    btf_dump_printf(d, "%s%s%s",
             btf_is_struct(t) ? "struct" : "union",
+            t->name_off ? " " : "",
             btf_dump_type_name(d, id));
 }

@@ -1291,7 +1293,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
         case BTF_KIND_UNION:
             btf_dump_emit_mods(d, decls);
             /* inline anonymous struct/union */
-            if (t->name_off == 0)
+            if (t->name_off == 0 && !d->skip_anon_defs)
                 btf_dump_emit_struct_def(d, id, t, lvl);
             else
                 btf_dump_emit_struct_fwd(d, id, t);
@@ -1299,7 +1301,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
         case BTF_KIND_ENUM:
             btf_dump_emit_mods(d, decls);
             /* inline anonymous enum */
-            if (t->name_off == 0)
+            if (t->name_off == 0 && !d->skip_anon_defs)
                 btf_dump_emit_enum_def(d, id, t, lvl);
             else
                 btf_dump_emit_enum_fwd(d, id, t);
@@ -1425,108 +1427,34 @@ static void btf_dump_emit_type_chain(struct
btf_dump *d,
 }

 /* show type name as (type_name) */
-static void btf_dump_emit_type_name(struct btf_dump *d, __u32 id,
-                    int lvl, bool toplevel)
+static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
bool top_level)
 {
-
-    const struct btf_type *t, *child;
-    const char *name;
-    __u16 kind;
+    const struct btf_type *t;

     /* for array members, we don't bother emitting type name for each
      * member to avoid the redundancy of
-     * .name = (char[])[(char)'f',(char)'o',(char)'o',]
+     * .name = (char[4])[(char)'f',(char)'o',(char)'o',]
      */
     if (d->data->state.array_member)
         return;

-    t = btf__type_by_id(d->btf, id);
-    kind = btf_kind(t);
-
     /* avoid type name specification for variable/section; it will be done
      * for the associated variable value(s).
      */
-    switch (kind) {
-    case BTF_KIND_VAR:
-    case BTF_KIND_DATASEC:
+    t = btf__type_by_id(d->btf, id);
+    if (btf_is_var(t) || btf_is_datasec(t))
         return;
-    default:
-        break;
-    }

-    if (toplevel)
+    if (top_level)
         btf_dump_printf(d, "(");

-    if (id == 0) {
-        btf_dump_printf(d, "void");
-        goto done;
-    }
-
-    switch (kind) {
-    case BTF_KIND_INT:
-    case BTF_KIND_FLOAT:
-        name = btf_name_of(d, t->name_off);
-        btf_dump_printf(d, "%s", name);
-        break;
-    case BTF_KIND_STRUCT:
-    case BTF_KIND_UNION:
-        name = btf_dump_type_name(d, id);
-        btf_dump_printf(d, "%s%s%s",
-                btf_is_struct(t) ? "struct" : "union",
-                strlen(name) > 0 ? " " : "",
-                name);
-        break;
-    case BTF_KIND_ENUM:
-        btf_dump_emit_enum_fwd(d, id, t);
-        break;
-    case BTF_KIND_TYPEDEF:
-        btf_dump_printf(d, "%s", btf_dump_ident_name(d, id));
-        break;
-    case BTF_KIND_VOLATILE:
-    case BTF_KIND_CONST:
-    case BTF_KIND_RESTRICT:
-        /* modifiers are omitted from the cast to save space */
-        btf_dump_emit_type_name(d, t->type, lvl, false);
-        break;
-    case BTF_KIND_PTR:
-        btf_dump_emit_type_name(d, t->type, lvl, false);
-        child = btf__type_by_id(d->btf, t->type);
-        /* no need for '*' suffix for function prototype */
-        if (btf_kind(child) == BTF_KIND_FUNC_PROTO)
-            break;
-        btf_dump_printf(d,
-                btf_kind(child) == BTF_KIND_PTR ? "*" : " *");
-        break;
-    case BTF_KIND_ARRAY: {
-        const struct btf_array *a = btf_array(t);
-
-        btf_dump_emit_type_name(d, a->type, lvl, false);
-        btf_dump_printf(d, "[]");
-        break;
-    }
-    case BTF_KIND_FUNC_PROTO: {
-        const struct btf_param *p = btf_params(t);
-        __u16 n = btf_vlen(t);
-        int i;
-
-        btf_dump_emit_type_name(d, t->type, 0, false);
-        btf_dump_printf(d, "(*)(");
+    d->skip_anon_defs = true;
+    d->strip_mods = true;
+    btf_dump_emit_type_decl(d, id, "", 0);
+    d->strip_mods = false;
+    d->skip_anon_defs = false;

-        for (i = 0; i < n; i++, p++) {
-            if (i > 0)
-                btf_dump_printf(d, ", ");
-            btf_dump_emit_type_name(d, p->type, 0, false);
-        }
-        btf_dump_printf(d, ")");
-        break;
-    }
-    default:
-        pr_warn("unexpected type when emitting type name, kind %u, id:[%u]\n",
-            kind, id);
-        break;
-    }
-done:
-    if (toplevel)
+    if (top_level)
         btf_dump_printf(d, ")");
 }

@@ -1924,7 +1852,7 @@ static int btf_dump_var_data(struct btf_dump *d,
 {
     enum btf_func_linkage linkage = btf_var(v)->linkage;
     const struct btf_type *t;
-    const char *l = "";
+    const char *l;
     __u32 type_id;

     switch (linkage) {
@@ -1936,6 +1864,7 @@ static int btf_dump_var_data(struct btf_dump *d,
         break;
     case BTF_FUNC_GLOBAL:
     default:
+        l = "";
         break;
     }

@@ -1945,10 +1874,9 @@ static int btf_dump_var_data(struct btf_dump *d,
     btf_dump_printf(d, "%s", l);
     type_id = v->type;
     t = btf__type_by_id(d->btf, type_id);
-    btf_dump_emit_type_name(d, type_id, 0, false);
+    btf_dump_emit_type_cast(d, type_id, false);
     btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
-    return btf_dump_dump_type_data(d, NULL,
-                       t, type_id, data, 0);
+    return btf_dump_dump_type_data(d, NULL, t, type_id, data, 0);
 }

 static int btf_dump_array_data(struct btf_dump *d,
@@ -2323,10 +2251,11 @@ static int btf_dump_dump_type_data(struct btf_dump *d,
         return err;
     }
     btf_dump_data_pfx(d);
+
     if (!d->data->skip_names) {
         if (fname && strlen(fname) > 0)
             btf_dump_printf(d, ".%s = ", fname);
-        btf_dump_emit_type_name(d, id, 0, true);
+        btf_dump_emit_type_cast(d, id, true);
     }

     t = skip_mods_and_typedefs(d->btf, id, NULL);
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index b78c3085144a..9923b12a255f 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -628,7 +628,7 @@ int test_btf_dump_struct_data(struct btf *btf,
struct btf_dump *d, char *str)
           str, ret))
         return -EINVAL;

-    cmpstr = "(struct file_operations){\n\t.owner = (struct module
*)0xffffffffffffffff,\n\t.llseek = (loff_t(*)(struct file *, loff_t,
int))0xffffffffffffffff,";
+    cmpstr = "(struct file_operations){\n\t.owner = (struct module
*)0xffffffffffffffff,\n\t.llseek = (loff_t (*)(struct file *, loff_t,
int))0xffffffffffffffff,";
     cmp = strncmp(str, cmpstr, strlen(cmpstr));
     if (CHECK(cmp != 0, "check file_operations dump",
           "file_operations '%s' did not match expected\n",
@@ -637,14 +637,14 @@ int test_btf_dump_struct_data(struct btf *btf,
struct btf_dump *d, char *str)

     /* struct with char array */
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
-               "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+               "(struct bpf_prog_info){.name = (char[16])['f','o','o',],}",
                { .name = "foo",});
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info,
                BTF_F_COMPACT | BTF_F_NONAME,
                "{['f','o','o',],}",
                {.name = "foo",});
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
-               "(struct bpf_prog_info){\n\t.name =
(char[])[\n\t\t'f',\n\t\t\'o',\n\t\t'o',\n\t],\n}\n",
+               "(struct bpf_prog_info){\n\t.name =
(char[16])[\n\t\t'f',\n\t\t\'o',\n\t\t'o',\n\t],\n}\n",
                {.name = "foo",});
     /* leading null char means do not display string */
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
@@ -652,26 +652,26 @@ int test_btf_dump_struct_data(struct btf *btf,
struct btf_dump *d, char *str)
                {.name = {'\0', 'f', 'o', 'o'}});
     /* handle non-printable characters */
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
-               "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+               "(struct bpf_prog_info){.name = (char[16])[1,2,3,],}",
                { .name = {1, 2, 3, 0}});

     /* struct with non-char array */
     TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
-               "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+               "(struct __sk_buff){.cb = (__u32[5])[1,2,3,4,5,],}",
                { .cb = {1, 2, 3, 4, 5,},});
     TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff,
                BTF_F_COMPACT | BTF_F_NONAME,
                "{[1,2,3,4,5,],}",
                { .cb = { 1, 2, 3, 4, 5},});
     TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
-               "(struct __sk_buff){\n\t.cb =
(__u32[])[\n\t\t1,\n\t\t2,\n\t\t3,\n\t\t4,\n\t\t5,\n\t],\n}\n",
+               "(struct __sk_buff){\n\t.cb =
(__u32[5])[\n\t\t1,\n\t\t2,\n\t\t3,\n\t\t4,\n\t\t5,\n\t],\n}\n",
                { .cb = { 1, 2, 3, 4, 5},});
     /* For non-char, arrays, show non-zero values only */
     TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
-               "(struct __sk_buff){.cb = (__u32[])[0,0,1,0,0,],}",
+               "(struct __sk_buff){.cb = (__u32[5])[0,0,1,0,0,],}",
                { .cb = { 0, 0, 1, 0, 0},});
     TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
-               "(struct __sk_buff){\n\t.cb =
(__u32[])[\n\t\t0,\n\t\t0,\n\t\t1,\n\t\t0,\n\t\t0,\n\t],\n}\n",
+               "(struct __sk_buff){\n\t.cb =
(__u32[5])[\n\t\t0,\n\t\t0,\n\t\t1,\n\t\t0,\n\t\t0,\n\t],\n}\n",
                { .cb = { 0, 0, 1, 0, 0},});

     /* struct with bitfields */
@@ -714,7 +714,7 @@ int test_btf_dump_struct_data(struct btf *btf,
struct btf_dump *d, char *str)

     /* struct with nested anon union */
     TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_sock_ops, BTF_F_COMPACT,
-               "(struct bpf_sock_ops){.op = (__u32)1,(union){.args =
(__u32[])[1,2,3,4,],.reply = (__u32)1,.replylong =
(__u32[])[1,2,3,4,],},}",
+               "(struct bpf_sock_ops){.op = (__u32)1,(union){.args =
(__u32[4])[1,2,3,4,],.reply = (__u32)1,.replylong =
(__u32[4])[1,2,3,4,],},}",
                { .op = 1, .args = { 1, 2, 3, 4}});

     /* union with nested struct */
@@ -822,7 +822,7 @@ int test_btf_dump_datasec_data(char *str)
         return -ENOENT;

     if (test_btf_datasec(btf, d, str, "license",
-                 "SEC(\"license\") char[] _license = (char[])['G','P','L',];",
+                 "SEC(\"license\") char[4] _license =
(char[4])['G','P','L',];",
                  license, sizeof(license)))
         return -EINVAL;

> +
> +       const struct btf_type *t, *child;
> +       const char *name;
> +       __u16 kind;
> +
> +       /* for array members, we don't bother emitting type name for each
> +        * member to avoid the redundancy of
> +        * .name = (char[])[(char)'f',(char)'o',(char)'o',]
> +        */
> +       if (d->data->state.array_member)
> +               return;
> +
> +       t = btf__type_by_id(d->btf, id);
> +       kind = btf_kind(t);
> +
> +       /* avoid type name specification for variable/section; it will be done
> +        * for the associated variable value(s).
> +        */
> +       switch (kind) {
> +       case BTF_KIND_VAR:
> +       case BTF_KIND_DATASEC:
> +               return;
> +       default:
> +               break;
> +       }
> +
> +       if (toplevel)
> +               btf_dump_printf(d, "(");
> +
> +       if (id == 0) {
> +               btf_dump_printf(d, "void");
> +               goto done;
> +       }
> +
> +       switch (kind) {
> +       case BTF_KIND_INT:
> +       case BTF_KIND_FLOAT:
> +               name = btf_name_of(d, t->name_off);
> +               btf_dump_printf(d, "%s", name);
> +               break;
> +       case BTF_KIND_STRUCT:
> +       case BTF_KIND_UNION:
> +               name = btf_dump_type_name(d, id);
> +               btf_dump_printf(d, "%s%s%s",
> +                               btf_is_struct(t) ? "struct" : "union",
> +                               strlen(name) > 0 ? " " : "",
> +                               name);
> +               break;
> +       case BTF_KIND_ENUM:
> +               btf_dump_emit_enum_fwd(d, id, t);
> +               break;
> +       case BTF_KIND_TYPEDEF:
> +               btf_dump_printf(d, "%s", btf_dump_ident_name(d, id));
> +               break;
> +       case BTF_KIND_VOLATILE:
> +       case BTF_KIND_CONST:
> +       case BTF_KIND_RESTRICT:
> +               /* modifiers are omitted from the cast to save space */
> +               btf_dump_emit_type_name(d, t->type, lvl, false);
> +               break;
> +       case BTF_KIND_PTR:
> +               btf_dump_emit_type_name(d, t->type, lvl, false);
> +               child = btf__type_by_id(d->btf, t->type);
> +               /* no need for '*' suffix for function prototype */
> +               if (btf_kind(child) == BTF_KIND_FUNC_PROTO)
> +                       break;
> +               btf_dump_printf(d,
> +                               btf_kind(child) == BTF_KIND_PTR ? "*" : " *");
> +               break;
> +       case BTF_KIND_ARRAY: {
> +               const struct btf_array *a = btf_array(t);
> +
> +               btf_dump_emit_type_name(d, a->type, lvl, false);
> +               btf_dump_printf(d, "[]");
> +               break;
> +       }
> +       case BTF_KIND_FUNC_PROTO: {
> +               const struct btf_param *p = btf_params(t);
> +               __u16 n = btf_vlen(t);
> +               int i;
> +
> +               btf_dump_emit_type_name(d, t->type, 0, false);
> +               btf_dump_printf(d, "(*)(");
> +
> +               for (i = 0; i < n; i++, p++) {
> +                       if (i > 0)
> +                               btf_dump_printf(d, ", ");
> +                       btf_dump_emit_type_name(d, p->type, 0, false);
> +               }
> +               btf_dump_printf(d, ")");
> +               break;
> +       }
> +       default:
> +               pr_warn("unexpected type when emitting type name, kind %u, id:[%u]\n",
> +                       kind, id);
> +               break;
> +       }
> +done:
> +       if (toplevel)
> +               btf_dump_printf(d, ")");
> +}
> +
>  /* return number of duplicates (occurrences) of a given name */
>  static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
>                                  const char *orig_name)
> @@ -1442,3 +1580,869 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
>  {
>         return btf_dump_resolve_name(d, id, d->ident_names);
>  }
> +
> +static int btf_dump_dump_type_data(struct btf_dump *d,
> +                                  const char *fname,
> +                                  const struct btf_type *t,
> +                                  __u32 id,
> +                                  const void *data,
> +                                  __u8 bits_offset);
> +
> +static const char *btf_dump_data_newline(struct btf_dump *d)
> +{
> +       return d->data->compact ? "" : "\n";
> +}
> +
> +static const char *btf_dump_data_delim(struct btf_dump *d)
> +{
> +       return d->data->state.depth == 0 ? "" : ",";
> +}
> +
> +static void btf_dump_data_pfx(struct btf_dump *d)
> +{
> +       int i, lvl = d->data->indent_lvl + d->data->state.depth;
> +
> +       if (d->data->compact)
> +               lvl = 0;

just return?

> +
> +       for (i = 0; i < lvl; i++)
> +               btf_dump_printf(d, "%s", d->data->indent_str);
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
> +                       btf_dump_data_delim(d),                         \
> +                       btf_dump_data_newline(d))

This can totally be implemented as a function if we add
btf_dump_vprintf() variant, but it's not horrible, so I'm fine with
it.

> +
> +static int btf_dump_unsupported_data(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    __u32 id,
> +                                    const void *data)
> +{
> +       btf_dump_printf(d, "<unsupported kind:%u>",
> +                       BTF_INFO_KIND(t->info));

please use btf_kind(t); you don't use data, drop it?

> +       return -ENOTSUP;
> +}
> +
> +static void btf_dump_int128(struct btf_dump *d,
> +                           const struct btf_type *t,
> +                           const void *data)
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
> +               btf_dump_type_values(d, "0x%llx", (long long)lower_num);
> +       else
> +               btf_dump_type_values(d, "0x%llx%016llx", (long long)upper_num,
> +                                    (long long)lower_num);
> +}
> +
> +static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
> +                            __u16 right_shift_bits)
> +{
> +       __u64 upper_num, lower_num;
> +
> +#ifdef __BIG_ENDIAN_BITFIELD

we use __BYTE_ORDER, __BIG_ENDIAN and __LITTLE_ENDIAN in other parts
of libbpf, can you please use them for consistency? And they are
defined by the compiler.

But actually, we already rely on copiler support for __int128_t, why
don't you use it directly here instead of implementing this semi-long
bit shifts?.. This would turn into a simple ((x << left_shift) >>
right_shift), right?

Printf above would be endianness-agnostic with upper_num = x >> 64 and
lower_num = (__u64)x;

Or am I missing some intricacy?

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
> +static int btf_dump_bitfield_get_data(struct btf_dump *d,
> +                                     const void *data,
> +                                     __u8 bits_offset,
> +                                     __u8 nr_bits,
> +                                     __u64 *print_num)
> +{
> +       __u16 left_shift_bits, right_shift_bits;
> +       __u8 nr_copy_bytes;
> +       __u8 nr_copy_bits;
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
> +
> +       return 0;
> +}
> +
> +static int btf_dump_bitfield_data(struct btf_dump *d,
> +                                 const struct btf_type *t,
> +                                 const void *data,
> +                                 __u8 bits_offset,
> +                                 __u8 nr_bits)
> +{
> +       __u64 print_num[2];
> +
> +       btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits, print_num);
> +       btf_dump_int128(d, t, print_num);
> +
> +       return 0;
> +}
> +
> +static int btf_dump_int_bits(struct btf_dump *d,
> +                            const struct btf_type *t,
> +                            const void *data,
> +                            __u8 bits_offset)
> +{
> +       __u8 nr_bits = d->data->state.bitfield_size ?: btf_int_bits(t);
> +
> +       data += BITS_ROUNDDOWN_BYTES(bits_offset);
> +       return btf_dump_bitfield_data(d, t, data, bits_offset, nr_bits);
> +}
> +
> +static int btf_dump_int_bits_check_zero(struct btf_dump *d,
> +                                       const struct btf_type *t,
> +                                       const void *data,
> +                                       __u8 bits_offset)
> +{
> +       __u64 print_num[2], zero[2] = { };
> +       __u8 nr_bits = d->data->state.bitfield_size ?: btf_int_bits(t);
> +
> +       data += BITS_ROUNDDOWN_BYTES(bits_offset);
> +       btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits,
> +                                  (__u64 *)&print_num);
> +       if (memcmp(print_num, zero, sizeof(zero)) == 0)

I bet __int128_t comparison is faster than memcmp call :) and nicer in
code. I'd say, just standardize on __int128 instead of using memory
comparisons and manipulations (where possible, of course).

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
> +       bool zero = false;
> +
> +       if (bits_offset || BITS_PER_BYTE_MASKED(nr_bits))

hmm.. I thought we agreed to not support INT types with non-standard
bit sizes?..

> +               return btf_dump_int_bits_check_zero(d, t, data, bits_offset);
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

Do we support dumping something bigger than 128 bits? If not, error
should be returned here.

> +               break;
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
> +       if (bits_offset || BITS_PER_BYTE_MASKED(nr_bits))

same, just don't support ((nr_bits & 7) != 0)

> +               return btf_dump_int_bits(d, t, data, bits_offset);
> +
> +       switch (nr_bits) {
> +       case 128:
> +               btf_dump_int128(d, t, data);
> +               break;
> +       case 64:
> +               if (sign)
> +                       btf_dump_type_values(d, "%lld", *(long long *)data);
> +               else
> +                       btf_dump_type_values(d, "%llu",
> +                                            *(unsigned long long *)data);
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
> +               if (d->data->state.array_ischar) {
> +                       /* check for null terminator */
> +                       if (d->data->state.array_terminated)
> +                               break;
> +                       if (*(char *)data == '\0') {
> +                               d->data->state.array_terminated = 1;
> +                               break;
> +                       }
> +                       if (isprint(*(char *)data)) {
> +                               btf_dump_type_values(d, "'%c'",
> +                                                    *(char *)data);
> +                               break;
> +                       }
> +               }
> +               if (sign)
> +                       btf_dump_type_values(d, "%d", *(__s8 *)data);
> +               else
> +                       btf_dump_type_values(d, "%u", *(__u8 *)data);
> +               break;
> +       default:
> +               pr_warn("unexpected nr_bits %d for id [%u]\n",
> +                       nr_bits, type_id);
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int btf_dump_float_check_zero(struct btf_dump *d,
> +                                    const struct btf_type *t,
> +                                    const void *data)
> +{
> +       __u8 bytecmp[16] = { 0 };

nit: static? and just = {}, please

> +       int nr_bytes = t->size;
> +
> +       if (nr_bytes > 16 || nr_bytes < 2) {
> +               pr_warn("unexpected size %d for float\n", nr_bytes);
> +               return -EINVAL;
> +       }
> +       if (memcmp(data,  bytecmp, nr_bytes) == 0)
> +               return -ENOMSG;
> +
> +       return 0;
> +}
> +
> +static int btf_dump_float_data(struct btf_dump *d,
> +                              const struct btf_type *t,
> +                              __u32 type_id,
> +                              const void *data,
> +                              __u8 bits_offset)
> +{
> +       int nr_bytes = t->size;
> +
> +       fprintf(stderr, "printing float size %d\n", nr_bytes);

debug leftovers?

> +       switch (nr_bytes) {
> +       case 16:
> +               btf_dump_type_values(d, "%Lf", *(long double *)data);
> +               break;
> +       case 8:
> +               btf_dump_type_values(d, "%f", *(double *)data);
> +               break;
> +       case 4:
> +               btf_dump_type_values(d, "%f", *(float *)data);
> +               break;
> +       case 12:
> +       case 2:

just default: here  instead of duplicating pr_warn

> +               /* although 2 and 12 are valid BTF_KIND_FLOAT sizes,
> +                * display is not supported yet.
> +                */
> +               pr_warn("unsupported size %d for id [%u]\n",
> +                       nr_bytes, type_id);
> +               return -ENOTSUP;
> +       default:
> +               pr_warn("unexpected size %d for id [%u]\n",
> +                       nr_bytes, type_id);
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
> +       const char *l = "";
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
> +               break;
> +       }
> +
> +       /* format of output here is [linkage] [type] [varname] = (type)value,
> +        * for example "static int cpu_profile_flip = (int)1"
> +        */
> +       btf_dump_printf(d, "%s", l);
> +       type_id = v->type;
> +       t = btf__type_by_id(d->btf, type_id);
> +       btf_dump_emit_type_name(d, type_id, 0, false);
> +       btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
> +       return btf_dump_dump_type_data(d, NULL,
> +                                      t, type_id, data, 0);

nit: keep on single line

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
> +               pr_warn("unexpected elem size %d for array type [%u]\n",
> +                       elem_size, id);
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
> +                       d->data->state.array_ischar = true;
> +       }
> +
> +       btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
> +       d->data->state.depth++;
> +
> +       /* may be a multidimensional array, so store current "is array member"
> +        * status so we can restore it correctly later.
> +        */
> +       array_member = d->data->state.array_member;
> +       d->data->state.array_member = 1;
> +       for (i = 0; i < array->nelems && !d->data->state.array_terminated; i++) {
> +

unnecessary empty line?

> +               btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id,
> +                                         data, 0);

single line, we can go up to 100

> +               data += elem_size;
> +       }
> +       d->data->state.array_member = array_member;
> +       d->data->state.depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_printf(d, "]%s%s",
> +                       btf_dump_data_delim(d),
> +                       btf_dump_data_newline(d));

same, try to keep single lines where possible

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
> +       btf_dump_printf(d, "{%s",
> +                       btf_dump_data_newline(d));

and here; what am I missing, why you prefer to wrap such short lines?

> +       d->data->state.depth++;
> +       for (i = 0; i < n; i++, m++) {
> +               const struct btf_type *mtype;
> +               __u32 bytes_offset, moffset;
> +               const char *mname;
> +               __u8 bits8_offset;
> +
> +               mtype = btf__type_by_id(d->btf, m->type);
> +               mname = btf_name_of(d, m->name_off);
> +               moffset = btf_member_bit_offset(t, i);
> +               bytes_offset = BITS_ROUNDDOWN_BYTES(moffset);
> +               bits8_offset = BITS_PER_BYTE_MASKED(moffset);
> +
> +               /* btf_int_bits() does not store member bitfield size;
> +                * bitfield size needs to be stored here so int display
> +                * of member can retrieve it.
> +                */
> +               d->data->state.bitfield_size =
> +                       btf_member_bitfield_size(t, i);

...

> +               err = btf_dump_dump_type_data(d,
> +                                             mname,
> +                                             mtype,
> +                                             m->type,
> +                                             data + bytes_offset,
> +                                             bits8_offset);

What I've been complaining above, just do:

data + `moffset / 8` and `moffset % 8`


> +               d->data->state.bitfield_size = 0;

please see if it's possible to pass bit_sz explicitly similar to
bits_offset, we really don't want extra mutable state

> +               if (err < 0)
> +                       return err;
> +       }
> +       d->data->state.depth--;
> +       btf_dump_data_pfx(d);
> +       btf_dump_printf(d, "}%s%s",
> +                       btf_dump_data_delim(d),
> +                       btf_dump_data_newline(d));
> +       return err;
> +}
> +
> +static int btf_dump_ptr_data(struct btf_dump *d,
> +                             const struct btf_type *t,
> +                             __u32 id,
> +                             const void *data)
> +{
> +       btf_dump_type_values(d, "%p", *(void **)data);
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
> +               pr_warn("unexpected size %d for enum, id:[%u]\n",
> +                       t->size, id);
> +               return -EINVAL;
> +       }
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
> +               btf_dump_type_values(d, "%s",
> +                                    btf_name_of(d, e->name_off));
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
> +       for (i = 0, vsi = btf_var_secinfos(t);
> +            i < btf_vlen(t);
> +            i++, vsi++) {

please use the same pattern to keep for() single line and simple

> +               var = btf__type_by_id(d->btf, vsi->type);
> +               err = btf_dump_dump_type_data(d, NULL, var,
> +                                             vsi->type,
> +                                             data + vsi->offset,
> +                                             0);

fits single line

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
> +       case BTF_KIND_INT:
> +       case BTF_KIND_PTR:
> +       case BTF_KIND_ENUM:
> +               if (data + (bits_offset/8) + size > d->data->data_end)

bits_offset / 8 and no (), there is no operator precedence
ambiguity/surprise. And I appreciate the use of / 8 without those
#defines ;)

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
> +                                        __u8 bits_offset)
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
> +       if (d->data->emit_zeroes || d->data->state.depth == 0 ||
> +           (d->data->state.array_member && !d->data->state.array_ischar))
> +               return 0;
> +
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       if (!t) {
> +               pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_INT:
> +               if (d->data->state.bitfield_size)
> +                       return btf_dump_int_bits_check_zero(d, t, data,
> +                                                           bits_offset);
> +               return btf_dump_int_check_zero(d, t, data, bits_offset);
> +       case BTF_KIND_FLOAT:
> +               return btf_dump_float_check_zero(d, t, data);
> +       case BTF_KIND_PTR:
> +               if (*((void **)data) == NULL)
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

btw, you don't have to use "btf_dump_" prefix for internal static
helper functions, so feel free to shorten them a bit, like
type_data_check_zero() is totally descriptive still

> +                                                           elem_type_id,
> +                                                           data +
> +                                                           (i * elem_size),
> +                                                           bits_offset);
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
> +                       __u32 bytes_offset, moffset;
> +                       __u8 bits8_offset;
> +
> +                       mtype = btf__type_by_id(d->btf, m->type);
> +                       moffset = btf_member_bit_offset(t, i);
> +                       bytes_offset = BITS_ROUNDDOWN_BYTES(moffset);
> +                       bits8_offset = BITS_PER_BYTE_MASKED(moffset);
> +
> +                       /* btf_int_bits() does not store member bitfield size;
> +                        * bitfield size needs to be stored here so int display
> +                        * of member can retrieve it.
> +                        */
> +                       d->data->state.bitfield_size =
> +                               btf_member_bitfield_size(t, i);
> +
> +                       err = btf_dump_type_data_check_zero(d, mtype,
> +                                                           m->type,
> +                                                           data + bytes_offset,
> +                                                           bits8_offset);
> +                       d->data->state.bitfield_size = 0;

same feedback

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
> +                                  __u8 bits_offset)
> +{
> +       int size, err;
> +
> +       size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
> +       if (size < 0)
> +               return size;
> +       err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset);
> +       if (err) {
> +               /* zeroed data is expected and not an error, so simply skip
> +                * dumping such data.  Record other errors however.
> +                */
> +               if (err == -ENODATA)
> +                       return size;
> +               return err;
> +       }
> +       btf_dump_data_pfx(d);
> +       if (!d->data->skip_names) {
> +               if (fname && strlen(fname) > 0)
> +                       btf_dump_printf(d, ".%s = ", fname);
> +               btf_dump_emit_type_name(d, id, 0, true);
> +       }
> +
> +       t = skip_mods_and_typedefs(d->btf, id, NULL);
> +       if (!t) {
> +               pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
> +                       id);
> +               return -EINVAL;
> +       }
> +
> +       switch (BTF_INFO_KIND(t->info)) {
> +       case BTF_KIND_UNKN:
> +       case BTF_KIND_FWD:
> +       case BTF_KIND_FUNC:
> +       case BTF_KIND_FUNC_PROTO:
> +               err = btf_dump_unsupported_data(d, t, id, data);
> +               break;
> +       case BTF_KIND_INT:
> +               if (d->data->state.bitfield_size)
> +                       err = btf_dump_bitfield_data(d, t, data,
> +                                                    bits_offset,
> +                                                    d->data->state.bitfield_size);
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
> +               if (d->data->state.bitfield_size) {
> +                       __u64 print_num[2], upper_num;
> +                       __s64 enum_val;
> +
> +                       err = btf_dump_bitfield_get_data(d, data, bits_offset,
> +                                                        d->data->state.bitfield_size,
> +                                                        print_num);
> +                       if (err)
> +                               break;
> +#ifdef __BIG_ENDIAN_BITFIELD
> +                       upper_num = print_num[0];
> +                       enum_val = (__s64)print_num[1];
> +#else
> +                       upper_num = print_num[1];
> +                       enum_val = (__s64)print_num[0];
> +#endif
> +                       if (upper_num != 0) {
> +                               pr_warn("enum value too big for id [%u]\n", id);
> +                               err = -EINVAL;
> +                               break;
> +                       }
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
> +       d->data = calloc(1, sizeof(struct btf_dump_data));
> +       if (!d->data)
> +               return libbpf_err(-ENOMEM);
> +
> +       d->data->data_end = data + data_sz;
> +       d->data->indent_lvl = OPTS_GET(opts, indent_level, 0);
> +       /* default indent string is a tab */
> +       if (strlen(opts->indent_str) == 0)
> +               d->data->indent_str[0] = '\t';
> +       else
> +               strncpy(d->data->indent_str, opts->indent_str,
> +                       sizeof(d->data->indent_str));

strncpy doesn't zero-terminate

> +
> +       d->data->compact = OPTS_GET(opts, compact, false);
> +       d->data->skip_names = OPTS_GET(opts, skip_names, false);
> +       d->data->emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
> +
> +       ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0);
> +
> +       free(d->data);
> +
> +       if (ret < 0)
> +               return libbpf_err(ret);
> +       return ret;

return libbpf_err(ret); it handles ret >= 0 just fine


> +}
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index bbe99b1..dfdf51e0 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -374,4 +374,5 @@ LIBBPF_0.4.0 {
>  LIBBPF_0.5.0 {
>         global:
>                 libbpf_set_strict_mode;
> +               btf_dump__dump_type_data;
>  } LIBBPF_0.4.0;
> --
> 1.8.3.1
>
