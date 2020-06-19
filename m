Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F21FFF58
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgFSAiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFSAiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:38:15 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14268C06174E;
        Thu, 18 Jun 2020 17:38:15 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z2so3947666qts.5;
        Thu, 18 Jun 2020 17:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vq7YZUGL3UgJlc23GsBR0YbDgVteioCcBwv7ePq3cxc=;
        b=hxjrnUyntbNf9f5LOe6WXs5qvLXBK1V7wRbf/ZV7gH8NSWwsPn2+WKyEW/VoOTC4k1
         PwjJllJQa+DdQL7/3gnkoSUg+hQCrq2LoX21JhRqQw09u6nKEk2+sarsstHl7IJLtd6v
         Q95CI/E0d2FrqZVS51Rg7ITFNr0I0cCupbbLdDqN+Z+tB1D7x7bIEYbNHKJOU+CAAt9j
         lvF8ASsJzxfqIFbgaO44c6uzG2EN77RBLwUaJatvLSG4stJpj0J+ftJvbLh0/slcI5G9
         Vwp5P73MPuHRT5Myr1MRxX9pdpSCh2nqSnScUYxeVOyXBXu60VWlyZGrAQAinGSjXu8E
         0Ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vq7YZUGL3UgJlc23GsBR0YbDgVteioCcBwv7ePq3cxc=;
        b=pT3Ewk8sUmNUmPe2KHpiHYoN5SV4jr21h8TZDkHf6EOQP5wvyaNaqEVuAjBUVZ61Fj
         1TCczRaoaiwNur82ANMAHyBRlreveMfCXvu5n05/3OLVzVgb7EkOsx8x3DwzHZx1H1do
         tRMCQ6SyoeJ4Z7/yhppooxneIoO6slh5uqv/0OHC/+H+2crUMGASaQNSYdJW7Cgv3IbW
         IOIcgYq+9FfVuLtqzrTc5VzprYzuq7JhtnSlv/LOHJiITsIu8rriZzLuLEWc3aRJjh0v
         +YZiAiwXJgF2+ctwEA+mc6x7vhh81QjxTpKqJf17PoIwMiDm8laoON2NQEVpEJCdObss
         smsA==
X-Gm-Message-State: AOAM531Ldgyye8F2TNSdR8sYeJ9hSEf8qfux93bNrKM8APk0zVnFsdqz
        elJESy72cFd6JllQqAuOBsoxdZGxviLZxNGa7es=
X-Google-Smtp-Source: ABdhPJz6S5R7JzyHBaokhEIkkyqA8QyNFs4Dzvaa4oGwyQlQhz66HyzQU/rtxdY9uXuwrmk1Imh9iqJgcqZXROO6l9g=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr966468qtm.117.1592527094111;
 Thu, 18 Jun 2020 17:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-2-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 17:38:03 -0700
Message-ID: <CAEf4BzbB0ZMfWHrhiPhv79sMVZ9L0gMj54uXKn_-+mTawPiBqw@mail.gmail.com>
Subject: Re: [PATCH 01/11] bpf: Add btfid tool to resolve BTF IDs in ELF object
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

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The btfid tool scans Elf object for .BTF_ids section and
> resolves its symbols with BTF IDs.

naming is hard and subjective, I know. But given this actively
modifies ELF file it probably should indicate this in the name. So
something like patch_btfids or resolve_btfids would be a bit more
accurate and for people not in the know will still trigger the
"warning, tool can modify something" flag, if there are any problems.

>
> It will be used to during linking time to resolve arrays
> of BTF IDs used in verifier, so these IDs do not need to
> be resolved in runtime.
>
> The expected layout of .BTF_ids section is described
> in btfid.c header. Related kernel changes are coming in
> following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/btfid/Build    |  26 ++
>  tools/bpf/btfid/Makefile |  71 +++++
>  tools/bpf/btfid/btfid.c  | 627 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 724 insertions(+)
>  create mode 100644 tools/bpf/btfid/Build
>  create mode 100644 tools/bpf/btfid/Makefile
>  create mode 100644 tools/bpf/btfid/btfid.c
>

[...]

> diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
> new file mode 100644
> index 000000000000..7cdf39bfb150
> --- /dev/null
> +++ b/tools/bpf/btfid/btfid.c
> @@ -0,0 +1,627 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +#define  _GNU_SOURCE
> +
> +/*
> + * btfid scans Elf object for .BTF_ids section and resolves
> + * its symbols with BTF IDs.
> + *
> + * Each symbol points to 4 bytes data and is expected to have
> + * following name syntax:
> + *
> + * __BTF_ID__<type>__<symbol>[__<id>]

This ___<id> thingy is just disambiguation between multiple places in
the code that could have BTF_ID macro, right? Or it has extra meaning?

> + *
> + * type is:
> + *
> + *   func   - lookup BTF_KIND_FUNC symbol with <symbol> name
> + *            and put its ID into its data
> + *
> + *             __BTF_ID__func__vfs_close__1:
> + *             .zero 4
> + *
> + *   struct - lookup BTF_KIND_STRUCT symbol with <symbol> name
> + *            and put its ID into its data
> + *
> + *             __BTF_ID__struct__sk_buff__1:
> + *             .zero 4
> + *
> + *   sort   - put symbol size into data area and sort following

Oh, I finally got what "put symbol size" means :) It's quite unclear,
to be honest. Also, is this size in bytes or number of IDs? Clarifying
would be helpful (I'll probably get this from reading further down the
code, but still..)

> + *            ID list
> + *
> + *             __BTF_ID__sort__list:
> + *             list_cnt:
> + *             .zero 4
> + *             list:
> + *             __BTF_ID__func__vfs_getattr__3:
> + *             .zero 4
> + *             __BTF_ID__func__vfs_fallocate__4:
> + *             .zero 4
> + */
> +

[...]

> +
> +static int symbols_collect(struct object *obj)
> +{
> +       Elf_Scn *scn = NULL;
> +       int n, i, err = 0;
> +       GElf_Shdr sh;
> +       char *name;
> +
> +       scn = elf_getscn(obj->efile.elf, obj->efile.symbols_shndx);
> +       if (!scn)
> +               return -1;
> +
> +       if (gelf_getshdr(scn, &sh) != &sh)
> +               return -1;
> +
> +       n = sh.sh_size / sh.sh_entsize;
> +
> +       /*
> +        * Scan symbols and look for the ones starting with
> +        * __BTF_ID__* over .BTF_ids section.
> +        */
> +       for (i = 0; !err && i < n; i++) {
> +               char *tmp, *prefix;
> +               struct btf_id *id;
> +               GElf_Sym sym;
> +               int err = -1;
> +
> +               if (!gelf_getsym(obj->efile.symbols, i, &sym))
> +                       return -1;
> +
> +               if (sym.st_shndx != obj->efile.idlist_shndx)
> +                       continue;
> +
> +               name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
> +                                 sym.st_name);
> +
> +               if (!is_btf_id(name))
> +                       continue;
> +
> +               /*
> +                * __BTF_ID__TYPE__vfs_truncate__0
> +                * prefix =  ^
> +                */
> +               prefix = name + sizeof(BTF_ID) - 1;
> +
> +               if (!strncmp(prefix, BTF_STRUCT, sizeof(BTF_STRUCT) - 1)) {
> +                       id = add_struct(obj, prefix);
> +               } else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
> +                       id = add_func(obj, prefix);
> +               } else if (!strncmp(prefix, BTF_SORT, sizeof(BTF_SORT) - 1)) {
> +                       id = add_sort(obj, prefix);
> +
> +                       /*
> +                        * SORT objects store list's count, which is encoded
> +                        * in symbol's size.
> +                        */
> +                       if (id)
> +                               id->cnt = sym.st_size / sizeof(int);

doesn't sym.st_size also include extra 4 bytes for length prefix?

> +               } else {
> +                       pr_err("FAILED unsupported prefix %s\n", prefix);
> +                       return -1;
> +               }
> +
> +               if (!id)
> +                       return -ENOMEM;
> +
> +               if (id->addr_cnt >= ADDR_CNT) {
> +                       pr_err("FAILED symbol %s crossed the number of allowed lists",
> +                               id->name);
> +                       return -1;
> +               }
> +               id->addr[id->addr_cnt++] = sym.st_value;
> +       }
> +
> +       return 0;
> +}
> +
> +static int symbols_resolve(struct object *obj)
> +{
> +       int nr_structs = obj->nr_structs;
> +       int nr_funcs   = obj->nr_funcs;
> +       struct btf *btf;
> +       int err, type_id;
> +       __u32 nr;
> +
> +       btf = btf__parse_elf(obj->path, NULL);
> +       err = libbpf_get_error(btf);
> +       if (err) {
> +               pr_err("FAILED: load BTF from %s: %s",
> +                       obj->path, strerror(err));
> +               return -1;
> +       }
> +
> +       nr = btf__get_nr_types(btf);
> +
> +       /*
> +        * Iterate all the BTF types and search for collected symbol IDs.
> +        */
> +       for (type_id = 0; type_id < nr; type_id++) {

common gotcha: type_id <= nr, you can also skip type_id == 0 (always VOID)

> +               const struct btf_type *type;
> +               struct rb_root *root = NULL;
> +               struct btf_id *id;
> +               const char *str;
> +               int *nr;
> +
> +               type = btf__type_by_id(btf, type_id);
> +               if (!type)
> +                       continue;

This ought to be an error...

> +
> +               /* We support func/struct types. */
> +               if (BTF_INFO_KIND(type->info) == BTF_KIND_FUNC && nr_funcs) {

see libbpf's btf.h: btf_is_func(type)

> +                       root = &obj->funcs;
> +                       nr = &nr_funcs;
> +               } else if (BTF_INFO_KIND(type->info) == BTF_KIND_STRUCT && nr_structs) {

same as above: btf_is_struct

But I think you also need to support unions?

Also what about typedefs? A lot of types are typedefs to struct/func_proto/etc.

> +                       root = &obj->structs;
> +                       nr = &nr_structs;
> +               } else {
> +                       continue;
> +               }
> +
> +               str = btf__name_by_offset(btf, type->name_off);
> +               if (!str)
> +                       continue;

error, shouldn't happen

> +
> +               id = btf_id__find(root, str);
> +               if (id) {

isn't it an error, if not found?

> +                       id->id = type_id;
> +                       (*nr)--;
> +               }
> +       }
> +
> +       return 0;
> +}
> +

[...]

> +
> +       /*
> +        * We do proper cleanup and file close
> +        * intentionally only on success.
> +        */
> +       if (elf_collect(&obj))
> +               return -1;
> +
> +       if (symbols_collect(&obj))
> +               return -1;
> +
> +       if (symbols_resolve(&obj))
> +               return -1;
> +
> +       if (symbols_patch(&obj))
> +               return -1;

nit: should these elf_end/close properly on error?


> +
> +       elf_end(obj.efile.elf);
> +       close(obj.efile.fd);
> +       return 0;
> +}
> --
> 2.25.4
>
