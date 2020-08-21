Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEC24E385
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHUWhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgHUWhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:37:53 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDF6C061573;
        Fri, 21 Aug 2020 15:37:53 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id p191so1858347ybg.0;
        Fri, 21 Aug 2020 15:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TYu21x+NkTkha7Rr6K3nLnIrF+tDAxFrOu5jvoEinY=;
        b=eORjt5u6WhstX2msPXGUf9NxV8iwS+0vudTQVTS2mnMmsDXf4o9LcK/NxP5qjYgQbB
         KtgHiTSbwfpZMaoPerjufcFI7Gf2GitBcTgemM13mDbmHYFPCocHlzo4Hjs8MIB5DeG8
         OyDGAoFjMBXM17XVg4Vw9mBQC1ZRre+XUMcE5tCIsYOk9ibNUrK+vsQxmCJhlkt69XwZ
         eDk0La7k8P3pxUQuMPTtUJXZ77InBELfjjk5OHepTB4aCNt2K4dCRngZwXTwwd9WLWd3
         Orub7U/r3Txk3qqbGxvLfAbY7sRg2NhjNM8fAMxpAxy7CMRpiHqHDT8ajdzO4eL1nYhC
         6JCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TYu21x+NkTkha7Rr6K3nLnIrF+tDAxFrOu5jvoEinY=;
        b=Wo9/LiqIX68X9OPBqD4+lFxITQ9mzHa5afnZwau/EvVrTmxmlo9yNFcSJ7pifkQIt0
         wenweRnDMEZ/4k9OnSsz/uWKDJy93Y+adQty3bYMTVB0AnOavlRdncGPMb8A072juKPN
         xtF+CexMlOKF7nNIjvKDHnbf7WpHQyngNOZHCQk5Q4O64X/dmfo4i0/WnvVKGVKpMWli
         3rVWNgiHcMM/xOHFZRDM/HX2J+/QHXcC7zY5eTG6wkJ9RQvhYvfywG2kDrczhQOmfLQs
         5GVekmjSJ1ww8+HRfc7K/zYFoqpcNPbtlQvuFoPYabEhUGqejQ67bhWaKAHhP17YEo+s
         vQ7w==
X-Gm-Message-State: AOAM532Qba/uaOMDFTZSBd5jLnNrBVVHWHYgZpQQ1VP0/N/QlyJIVxTi
        KYrzVNYjeNkvDfpo91fx5PNrVGwHr8DLIvQ40WI=
X-Google-Smtp-Source: ABdhPJzdkTKGzSST8OEQBjzXWggg21HSbkkVMRyYlyRqqSF9snk/1cobojkx3aVqpJxQZC2GkykBiaRDdDMdF4clfbk=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr6466125ybe.510.1598049472758;
 Fri, 21 Aug 2020 15:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-5-haoluo@google.com>
In-Reply-To: <20200819224030.1615203-5-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 15:37:41 -0700
Message-ID: <CAEf4BzYhjUwYH_BBgtHz9-Ha-54AQ_8L3_N=cXsuud=kayk5-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 4/8] bpf/libbpf: BTF support for typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
>
> If a ksym is defined with a type, libbpf will try to find the ksym's btf
> information from kernel btf. If a valid btf entry for the ksym is found,
> libbpf can pass in the found btf id to the verifier, which validates the
> ksym's type and value.
>
> Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> but it has the symbol's address (read from kallsyms) and its value is
> treated as a raw pointer.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 130 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 114 insertions(+), 16 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4a81c6b2d21b..94eff612c7c2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -357,7 +357,16 @@ struct extern_desc {
>                         bool is_signed;
>                 } kcfg;
>                 struct {
> -                       unsigned long long addr;
> +                       /*
> +                        *  1. If ksym is typeless, the field 'addr' is valid.
> +                        *  2. If ksym is typed, the field 'vmlinux_btf_id' is
> +                        *     valid.
> +                        */
> +                       bool is_typeless;
> +                       union {
> +                               unsigned long long addr;
> +                               int vmlinux_btf_id;
> +                       };

ksym is 16 bytes anyways, union doesn't help to save space. I propose
to encode all this with just two fields: vmlinux_btf_id and addr. If
btf_id == 0, then extern is typeless.

>                 } ksym;
>         };
>  };
> @@ -382,6 +391,7 @@ struct bpf_object {
>
>         bool loaded;
>         bool has_pseudo_calls;
> +       bool has_typed_ksyms;
>
>         /*
>          * Information when doing elf related work. Only valid if fd
> @@ -2521,6 +2531,10 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
>         if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
>                 need_vmlinux_btf = true;
>
> +       /* Support for typed ksyms needs kernel BTF */
> +       if (obj->has_typed_ksyms)
> +               need_vmlinux_btf = true;

On the second read, I don't think you really need `has_typed_ksyms` at
all. Just iterate over ksym externs and see if you have a typed one.
It's the only place that cares.

> +
>         bpf_object__for_each_program(prog, obj) {
>                 if (!prog->load)
>                         continue;
> @@ -2975,10 +2989,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>                         ext->type = EXT_KSYM;
>
>                         vt = skip_mods_and_typedefs(obj->btf, t->type, NULL);
> -                       if (!btf_is_void(vt)) {
> -                               pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
> -                               return -ENOTSUP;
> -                       }
> +                       ext->ksym.is_typeless = btf_is_void(vt);
> +
> +                       if (!obj->has_typed_ksyms && !ext->ksym.is_typeless)
> +                               obj->has_typed_ksyms = true;

nit: keep it simple:

if (ext->ksym.is_typeless)
  obj->has_typed_ksyms = true;

>                 } else {
>                         pr_warn("unrecognized extern section '%s'\n", sec_name);
>                         return -ENOTSUP;
> @@ -2992,9 +3006,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>         /* sort externs by type, for kcfg ones also by (align, size, name) */
>         qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
>
> -       /* for .ksyms section, we need to turn all externs into allocated
> -        * variables in BTF to pass kernel verification; we do this by
> -        * pretending that each extern is a 8-byte variable
> +       /* for .ksyms section, we need to turn all typeless externs into
> +        * allocated variables in BTF to pass kernel verification; we do
> +        * this by pretending that each typeless extern is a 8-byte variable
>          */
>         if (ksym_sec) {
>                 /* find existing 4-byte integer type in BTF to use for fake
> @@ -3012,7 +3026,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>
>                 sec = ksym_sec;
>                 n = btf_vlen(sec);
> -               for (i = 0, off = 0; i < n; i++, off += sizeof(int)) {
> +               for (i = 0, off = 0; i < n; i++) {
>                         struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
>                         struct btf_type *vt;
>
> @@ -3025,9 +3039,14 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>                                 return -ESRCH;
>                         }
>                         btf_var(vt)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
> -                       vt->type = int_btf_id;
> +                       if (ext->ksym.is_typeless) {
> +                               vt->type = int_btf_id;
> +                               vs->size = sizeof(int);
> +                       }
>                         vs->offset = off;
> -                       vs->size = sizeof(int);
> +                       off += vs->size;
> +                       pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
> +                                ext->name, vt->type, vs->size, vs->offset);

It's a bit of a waste that we still allocate memory for those typed
ksym externs, as they don't really need space. But modifying BTF is a
pain right now, so I think we'll have to do it, until we have a better
BTF API. But let's make them integers for now to take a fixed and
small amount of space.

>                 }
>                 sec->size = off;
>         }
> @@ -5300,8 +5319,13 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
>                                 insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
>                                 insn[1].imm = ext->kcfg.data_off;
>                         } else /* EXT_KSYM */ {
> -                               insn[0].imm = (__u32)ext->ksym.addr;
> -                               insn[1].imm = ext->ksym.addr >> 32;
> +                               if (ext->ksym.is_typeless) { /* typelss ksyms */

typo: typeless

> +                                       insn[0].imm = (__u32)ext->ksym.addr;
> +                                       insn[1].imm = ext->ksym.addr >> 32;
> +                               } else { /* typed ksyms */
> +                                       insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> +                                       insn[0].imm = ext->ksym.vmlinux_btf_id;
> +                               }
>                         }
>                         break;
>                 case RELO_CALL:
> @@ -6019,6 +6043,10 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>                 if (!ext || ext->type != EXT_KSYM)
>                         continue;
>
> +               /* Typed ksyms have the verifier to fill their addresses. */
> +               if (!ext->ksym.is_typeless)
> +                       continue;

It might still be a good idea to try to find the symbol in kallsyms
and emit nicer message if it's not there. Think about the user's
experience when some global variable is removed from the kernel (or
compiled out due to missing Kconfig). If libbpf can easily detect
this, we should do it and provide a good error message.

> +
>                 if (ext->is_set && ext->ksym.addr != sym_addr) {
>                         pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
>                                 sym_name, ext->ksym.addr, sym_addr);
> @@ -6037,10 +6065,72 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>         return err;
>  }
>
> +static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> +{
> +       struct extern_desc *ext;
> +       int i, id;
> +
> +       if (!obj->btf_vmlinux) {
> +               pr_warn("support of typed ksyms needs kernel btf.\n");
> +               return -ENOENT;
> +       }
> +
> +       for (i = 0; i < obj->nr_extern; i++) {
> +               const struct btf_type *v, *vx; /* VARs in object and vmlinux btf */
> +               const struct btf_type *t, *tx; /* TYPEs in btf */
> +               __u32 vt, vtx; /* btf_ids of TYPEs */

I use targ_ and local_ prefixes with CO-RE to distinguish something
that's coming from BPF object's BTF vs kernel's BTF, can you please
adopt the same, as the process is essentially the same. "vx" vs "vtx"
vs "v" are hard to distinguish and understand.

> +
> +               ext = &obj->externs[i];
> +               if (ext->type != EXT_KSYM)
> +                       continue;
> +
> +               if (ext->ksym.is_typeless)
> +                       continue;

nit: combine into a single filter condition (we need typed ksym,
that's one check)

> +
> +               if (ext->is_set) {
> +                       pr_warn("typed ksym '%s' resolved as typeless ksyms.\n",
> +                               ext->name);
> +                       return -EFAULT;

this is a bug if that happens, that should be caught by test, please
remove unnecessary check

> +               }
> +
> +               id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> +                                           BTF_KIND_VAR);
> +               if (id <= 0) {
> +                       pr_warn("no btf entry for ksym '%s' in vmlinux.\n",
> +                               ext->name);
> +                       return -ESRCH;
> +               }
> +
> +               vx = btf__type_by_id(obj->btf_vmlinux, id);
> +               tx = skip_mods_and_typedefs(obj->btf_vmlinux, vx->type, &vtx);
> +
> +               v = btf__type_by_id(obj->btf, ext->btf_id);
> +               t = skip_mods_and_typedefs(obj->btf, v->type, &vt);
> +
> +               if (!btf_ksym_type_match(obj->btf_vmlinux, vtx, obj->btf, vt)) {
> +                       const char *tname, *txname; /* names of TYPEs */
> +
> +                       txname = btf__name_by_offset(obj->btf_vmlinux, tx->name_off);
> +                       tname = btf__name_by_offset(obj->btf, t->name_off);
> +
> +                       pr_warn("ksym '%s' expects type '%s' (vmlinux_btf_id: #%d), "
> +                               "but got '%s' (btf_id: #%d)\n", ext->name,
> +                               txname, vtx, tname, vt);
> +                       return -EINVAL;
> +               }

yeah, definitely just use bpf_core_types_are_compat() here. You'll
want to skip_mods_and_typedefs first, but everything else should work
for your use case.

> +
> +               ext->is_set = true;
> +               ext->ksym.vmlinux_btf_id = id;
> +               pr_debug("extern (ksym) %s=vmlinux_btf_id(#%d)\n", ext->name, id);
> +       }
> +       return 0;
> +}
> +

[...]
