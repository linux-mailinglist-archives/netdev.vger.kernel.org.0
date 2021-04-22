Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A499D3688E7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhDVWMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhDVWMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 18:12:54 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198B7C06174A;
        Thu, 22 Apr 2021 15:12:17 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v72so32637626ybe.11;
        Thu, 22 Apr 2021 15:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0gJOIIUqyj2j6DCZxUZYaCkVUbZvvOZa4Xbk3GqIdM=;
        b=i/biptvUWOzOi7afnZfzuOpwfjXP+sGeDjdVgljOtlBwm1IuqX336G64k5pMtWflwv
         qVB007yg+Qb0xrpXeDIQm8vrBnuV/QEZL0MoPkLCSAT3rquJdpHYLolOtQq7vRT9Q10g
         knndhVB1gqERzLkjisrgp1+facnWL4sgVW6xVx36WeFZ4exdYyKzvSkisA+TcQjCXwjK
         t7RRKS45ag3DuVRZulAvevocIC3rDWS6E+JwKgu4g2p0AUr3T9leUm8tMWo7CAzyqAk1
         d29ZyPRkyigd5gmIwHW8uuOryTvosojVoDa7i76qV2avJdL6u9AKEVPqaRTfG+m2A4Ur
         LyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0gJOIIUqyj2j6DCZxUZYaCkVUbZvvOZa4Xbk3GqIdM=;
        b=EWhK/J44HrJLPcTLLIWv5OiiAe62HhrovxW7jlRGf7mwEDyFaBMwZeXH6ki9FEG8SR
         hJnpuNpeduh/0Gt8LO2S6gEtbrkFxKZgffsR5Ht6GrHrHtdTwJILJl1NUkNUDc4KhuD5
         nbjPUmnCx7aPx/Fg5vDmwv1AfnPLTW/sTvOg/ux+Z3SOUn2BYLLYVwfGWGhSkyLhCxFq
         mI2iM0G4fUVXjK0zsA23m+trGlkWTIfDght+cUiaetBPvoCF/dUa433rXuvB6DTU6mkC
         GRqIVE5BSFGGb1Y6+v4295cdGxWKTB28jP4cOdqWPLgd3TZ0ilwxxtGvYWW6qZm0c7/1
         QyTw==
X-Gm-Message-State: AOAM530wOgYshJ3zdPJtcf3LTB7WPaPJrcvcfCH/d7bj4neOuigUUHEy
        IrvCpN+0t/szbcG8SGiJq+MV86b2vclov+zx1cM=
X-Google-Smtp-Source: ABdhPJwm5YhzuIdMZPeHHAKHqIH/eIeZ+XSXD9BwBYQKT5gY0LM+7tnpbmyG7UP4MlDZDuhx5aLeXuKYF7xgHXX7XCU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr1280452ybo.230.1619129536025;
 Thu, 22 Apr 2021 15:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-12-andrii@kernel.org>
 <d6297a28-855f-4c46-7754-b0c0b1f11d6b@fb.com>
In-Reply-To: <d6297a28-855f-4c46-7754-b0c0b1f11d6b@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 15:12:04 -0700
Message-ID: <CAEf4BzYzML_5O-+6=bW6U=jCc9aG86GBJH6fwrsU5gSacbjL7w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution
 support for functions and global variables
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 2:27 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Add BPF static linker logic to resolve extern variables and functions across
> > multiple linked together BPF object files.
> >
> > For that, linker maintains a separate list of struct glob_sym structures,
> > which keeps track of few pieces of metadata (is it extern or resolved global,
> > is it a weak symbol, which ELF section it belongs to, etc) and ties together
> > BTF type info and ELF symbol information and keeps them in sync.
> >
> > With adding support for extern variables/funcs, it's now possible for some
> > sections to contain both extern and non-extern definitions. This means that
> > some sections may start out as ephemeral (if only externs are present and thus
> > there is not corresponding ELF section), but will be "upgraded" to actual ELF
> > section as symbols are resolved or new non-extern definitions are appended.
> >
> > Additional care is taken to not duplicate extern entries in sections like
> > .kconfig and .ksyms.
> >
> > Given libbpf requires BTF type to always be present for .kconfig/.ksym
> > externs, linker extends this requirement to all the externs, even those that
> > are supposed to be resolved during static linking and which won't be visible
> > to libbpf. With BTF information always present, static linker will check not
> > just ELF symbol matches, but entire BTF type signature match as well. That
> > logic is stricter that BPF CO-RE checks. It probably should be re-used by
> > .ksym resolution logic in libbpf as well, but that's left for follow up
> > patches.
> >
> > To make it unnecessary to rewrite ELF symbols and minimize BTF type
> > rewriting/removal, ELF symbols that correspond to externs initially will be
> > updated in place once they are resolved. Similarly for BTF type info, VAR/FUNC
> > and var_secinfo's (sec_vars in struct bpf_linker) are staying stable, but
> > types they point to might get replaced when extern is resolved. This might
> > leave some left-over types (even though we try to minimize this for common
> > cases of having extern funcs with not argument names vs concrete function with
> > names properly specified). That can be addresses later with a generic BTF
> > garbage collection. That's left for a follow up as well.
> >
> > Given BTF type appending phase is separate from ELF symbol
> > appending/resolution, special struct glob_sym->underlying_btf_id variable is
> > used to communicate resolution and rewrite decisions. 0 means
> > underlying_btf_id needs to be appended (it's not yet in final linker->btf), <0
> > values are used for temporary storage of source BTF type ID (not yet
> > rewritten), so -glob_sym->underlying_btf_id is BTF type id in obj-btf. But by
> > the end of linker_append_btf() phase, that underlying_btf_id will be remapped
> > and will always be > 0. This is the uglies part of the whole process, but
> > keeps the other parts much simpler due to stability of sec_var and VAR/FUNC
> > types, as well as ELF symbol, so please keep that in mind while reviewing.
>
> This is indeed complicated. I has some comments below. Please check
> whether my understanding is correct or not.
>
> >
> > BTF-defined maps require some extra custom logic and is addressed separate in
> > the next patch, so that to keep this one smaller and easier to review.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/linker.c | 844 ++++++++++++++++++++++++++++++++++++++---
> >   1 file changed, 785 insertions(+), 59 deletions(-)
> >
> > diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> > index d5dc1d401f57..67d2d06e3cb6 100644
> > --- a/tools/lib/bpf/linker.c
> > +++ b/tools/lib/bpf/linker.c
> > @@ -22,6 +22,8 @@
> >   #include "libbpf_internal.h"
> >   #include "strset.h"
> >
> > +#define BTF_EXTERN_SEC ".extern"
> > +
> >   struct src_sec {
> >       const char *sec_name;
> >       /* positional (not necessarily ELF) index in an array of sections */
> > @@ -74,11 +76,36 @@ struct btf_ext_sec_data {
> >       void *recs;
> >   };
> >
> > +struct glob_sym {
> > +     /* ELF symbol index */
> > +     int sym_idx;
> > +     /* associated section id for .ksyms, .kconfig, etc, but not .extern */
> > +     int sec_id;
> > +     /* extern name offset in STRTAB */
> > +     int name_off;
> > +     /* optional associated BTF type ID */
> > +     int btf_id;
> > +     /* BTF type ID to which VAR/FUNC type is pointing to; used for
> > +      * rewriting types when extern VAR/FUNC is resolved to a concrete
> > +      * definition
> > +      */
> > +     int underlying_btf_id;
> > +     /* sec_var index in the corresponding dst_sec, if exists */
> > +     int var_idx;
> > +
> > +     /* extern or resolved/global symbol */
> > +     bool is_extern;
> > +     /* weak or strong symbol, never goes back from strong to weak */
> > +     bool is_weak;
> > +};
> > +
> >   struct dst_sec {
> >       char *sec_name;
> >       /* positional (not necessarily ELF) index in an array of sections */
> >       int id;
> >
> > +     bool ephemeral;
> > +
> >       /* ELF info */
> >       size_t sec_idx;
> >       Elf_Scn *scn;
> > @@ -120,6 +147,10 @@ struct bpf_linker {
> >
> >       struct btf *btf;
> >       struct btf_ext *btf_ext;
> > +
> > +     /* global (including extern) ELF symbols */
> > +     int glob_sym_cnt;
> > +     struct glob_sym *glob_syms;
> >   };
> >
> [...]
> > +
> > +static bool glob_sym_btf_matches(const char *sym_name, bool exact,
> > +                              const struct btf *btf1, __u32 id1,
> > +                              const struct btf *btf2, __u32 id2)
> > +{
> > +     const struct btf_type *t1, *t2;
> > +     bool is_static1, is_static2;
> > +     const char *n1, *n2;
> > +     int i, n;
> > +
> > +recur:
> > +     n1 = n2 = NULL;
> > +     t1 = skip_mods_and_typedefs(btf1, id1, &id1);
> > +     t2 = skip_mods_and_typedefs(btf2, id2, &id2);
> > +
> > +     /* check if only one side is FWD, otherwise handle with common logic */
> > +     if (!exact && btf_is_fwd(t1) != btf_is_fwd(t2)) {
> > +             n1 = btf__str_by_offset(btf1, t1->name_off);
> > +             n2 = btf__str_by_offset(btf2, t2->name_off);
> > +             if (strcmp(n1, n2) != 0) {
> > +                     pr_warn("global '%s': incompatible forward declaration names '%s' and '%s'\n",
> > +                             sym_name, n1, n2);
> > +                     return false;
> > +             }
> > +             /* validate if FWD kind matches concrete kind */
> > +             if (btf_is_fwd(t1)) {
> > +                     if (btf_kflag(t1) && btf_is_union(t2))
> > +                             return true;
> > +                     if (!btf_kflag(t1) && btf_is_struct(t2))
> > +                             return true;
> > +                     pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
> > +                             sym_name, btf_kflag(t1) ? "union" : "struct", btf_kind_str(t2));
> > +             } else {
> > +                     if (btf_kflag(t2) && btf_is_union(t1))
> > +                             return true;
> > +                     if (!btf_kflag(t2) && btf_is_struct(t1))
> > +                             return true;
> > +                     pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
> > +                             sym_name, btf_kflag(t2) ? "union" : "struct", btf_kind_str(t1));
> > +             }
> > +             return false;
> > +     }
> > +
> > +     if (btf_kind(t1) != btf_kind(t2)) {
> > +             pr_warn("global '%s': incompatible BTF kinds %s and %s\n",
> > +                     sym_name, btf_kind_str(t1), btf_kind_str(t2));
> > +             return false;
> > +     }
> > +
> > +     switch (btf_kind(t1)) {
> > +     case BTF_KIND_STRUCT:
> > +     case BTF_KIND_UNION:
> > +     case BTF_KIND_ENUM:
> > +     case BTF_KIND_FWD:
> > +     case BTF_KIND_FUNC:
> > +     case BTF_KIND_VAR:
> > +             n1 = btf__str_by_offset(btf1, t1->name_off);
> > +             n2 = btf__str_by_offset(btf2, t2->name_off);
> > +             if (strcmp(n1, n2) != 0) {
> > +                     pr_warn("global '%s': incompatible %s names '%s' and '%s'\n",
> > +                             sym_name, btf_kind_str(t1), n1, n2);
> > +                     return false;
> > +             }
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +
> > +     switch (btf_kind(t1)) {
> > +     case BTF_KIND_UNKN: /* void */
> > +     case BTF_KIND_FWD:
> > +             return true;
> > +     case BTF_KIND_INT:
> > +     case BTF_KIND_FLOAT:
> > +     case BTF_KIND_ENUM:
> > +             /* ignore encoding for int and enum values for enum */
> > +             if (t1->size != t2->size) {
> > +                     pr_warn("global '%s': incompatible %s '%s' size %u and %u\n",
> > +                             sym_name, btf_kind_str(t1), n1, t1->size, t2->size);
> > +                     return false;
> > +             }
> > +             return true;
> > +     case BTF_KIND_PTR:
> > +             /* just validate overall shape of the referenced type, so no
> > +              * contents comparison for struct/union, and allowd fwd vs
> > +              * struct/union
> > +              */
> > +             exact = false;
> > +             id1 = t1->type;
> > +             id2 = t2->type;
> > +             goto recur;
> > +     case BTF_KIND_ARRAY:
> > +             /* ignore index type and array size */
> > +             id1 = btf_array(t1)->type;
> > +             id2 = btf_array(t2)->type;
> > +             goto recur;
> > +     case BTF_KIND_FUNC:
> > +             /* extern and global linkages are compatible */
> > +             is_static1 = btf_func_linkage(t1) == BTF_FUNC_STATIC;
> > +             is_static2 = btf_func_linkage(t2) == BTF_FUNC_STATIC;
> > +             if (is_static1 != is_static2) {
> > +                     pr_warn("global '%s': incompatible func '%s' linkage\n", sym_name, n1);
> > +                     return false;
> > +             }
> > +
> > +             id1 = t1->type;
> > +             id2 = t2->type;
> > +             goto recur;
> > +     case BTF_KIND_VAR:
> > +             /* extern and global linkages are compatible */
> > +             is_static1 = btf_var(t1)->linkage == BTF_VAR_STATIC;
> > +             is_static2 = btf_var(t2)->linkage == BTF_VAR_STATIC;
> > +             if (is_static1 != is_static2) {
> > +                     pr_warn("global '%s': incompatible var '%s' linkage\n", sym_name, n1);
> > +                     return false;
> > +             }
> > +
> > +             id1 = t1->type;
> > +             id2 = t2->type;
> > +             goto recur;
> > +     case BTF_KIND_STRUCT:
> > +     case BTF_KIND_UNION: {
> > +             const struct btf_member *m1, *m2;
> > +
> > +             if (!exact)
> > +                     return true;
> > +
> > +             if (btf_vlen(t1) != btf_vlen(t2)) {
> > +                     pr_warn("global '%s': incompatible number of %s fields %u and %u\n",
> > +                             sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
> > +                     return false;
> > +             }
> > +
> > +             n = btf_vlen(t1);
> > +             m1 = btf_members(t1);
> > +             m2 = btf_members(t2);
> > +             for (i = 0; i < n; i++, m1++, m2++) {
> > +                     n1 = btf__str_by_offset(btf1, m1->name_off);
> > +                     n2 = btf__str_by_offset(btf2, m2->name_off);
> > +                     if (strcmp(n1, n2) != 0) {
> > +                             pr_warn("global '%s': incompatible field #%d names '%s' and '%s'\n",
> > +                                     sym_name, i, n1, n2);
> > +                             return false;
> > +                     }
> > +                     if (m1->offset != m2->offset) {
> > +                             pr_warn("global '%s': incompatible field #%d ('%s') offsets\n",
> > +                                     sym_name, i, n1);
> > +                             return false;
> > +                     }
> > +                     if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
> > +                             return false;
> > +             }
> > +
> > +             return true;
> > +     }
> > +     case BTF_KIND_FUNC_PROTO: {
> > +             const struct btf_param *m1, *m2;
> > +
> > +             if (btf_vlen(t1) != btf_vlen(t2)) {
> > +                     pr_warn("global '%s': incompatible number of %s params %u and %u\n",
> > +                             sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
> > +                     return false;
> > +             }
> > +
> > +             n = btf_vlen(t1);
> > +             m1 = btf_params(t1);
> > +             m2 = btf_params(t2);
> > +             for (i = 0; i < n; i++, m1++, m2++) {
> > +                     /* ignore func arg names */
> > +                     if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
> > +                             return false;
> > +             }
> > +
> > +             /* now check return type as well */
> > +             id1 = t1->type;
> > +             id2 = t2->type;
> > +             goto recur;
> > +     }
> > +
> > +     case BTF_KIND_TYPEDEF:
> > +     case BTF_KIND_VOLATILE:
> > +     case BTF_KIND_CONST:
> > +     case BTF_KIND_RESTRICT:
>
> We already did skip_mods_and_typedefs() before. Unless something serious
> wrong, we should not hit the above four types. So I think we can skip
> them here.

This is the way of documenting explicitly that I'm aware of those
kinds and they shouldn't be encountered. Otherwise one might wonder if
we just forgot to handle them.

>
> > +     case BTF_KIND_DATASEC:
> > +     default:
> > +             pr_warn("global '%s': unsupported BTF kind %s\n",
> > +                     sym_name, btf_kind_str(t1));
> > +             return false;
> > +     }
> > +}
> > +
> > +static bool glob_syms_match(const char *sym_name,
> > +                         struct bpf_linker *linker, struct glob_sym *glob_sym,
> > +                         struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
> > +{
> > +     const struct btf_type *src_t;
> > +
> > +     /* if we are dealing with externs, BTF types describing both global
> > +      * and extern VARs/FUNCs should be completely present in all files
> > +      */
> > +     if (!glob_sym->btf_id || !btf_id) {
> > +             pr_warn("BTF info is missing for global symbol '%s'\n", sym_name);
> > +             return false;
> > +     }
> > +
> > +     src_t = btf__type_by_id(obj->btf, btf_id);
> > +     if (!btf_is_var(src_t) && !btf_is_func(src_t)) {
> > +             pr_warn("only extern variables and functions are supported, but got '%s' for '%s'\n",
> > +                     btf_kind_str(src_t), sym_name);
> > +             return false;
> > +     }
> > +
> > +     if (!glob_sym_btf_matches(sym_name, true /*exact*/,
> > +                               linker->btf, glob_sym->btf_id, obj->btf, btf_id))
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> [...]
> > +
> > +static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
> > +{
> > +     /* libelf doesn't provide setters for ST_VISIBILITY,
> > +      * but it is stored in the lower 2 bits of st_other
> > +      */
> > +     sym->st_other &= 0x03;
> > +     sym->st_other |= sym_vis;
> > +}
> > +
> > +static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
> > +                              Elf64_Sym *sym, const char *sym_name, int src_sym_idx)
> > +{
> > +     struct src_sec *src_sec = NULL;
> > +     struct dst_sec *dst_sec = NULL;
> > +     struct glob_sym *glob_sym = NULL;
> > +     int name_off, sym_type, sym_bind, sym_vis, err;
> > +     int btf_sec_id = 0, btf_id = 0;
> > +     size_t dst_sym_idx;
> > +     Elf64_Sym *dst_sym;
> > +     bool sym_is_extern;
> > +
> > +     sym_type = ELF64_ST_TYPE(sym->st_info);
> > +     sym_bind = ELF64_ST_BIND(sym->st_info);
> > +     sym_vis = ELF64_ST_VISIBILITY(sym->st_other);
> > +     sym_is_extern = sym->st_shndx == SHN_UNDEF;
> > +
> > +     if (sym_is_extern) {
> > +             if (!obj->btf) {
> > +                     pr_warn("externs without BTF info are not supported\n");
> > +                     return -ENOTSUP;
> > +             }
> > +     } else if (sym->st_shndx < SHN_LORESERVE) {
>
> So what happens if sym->st_shndx >= SHN_LORESERVE. Maybe return failures
> here? In general, bpf program shouldn't hit sym->st_shndx >= SHN_LORESERVE.

There is at least SHN_ABS (0xfff1), which is an informational STT_FILE
symbol. libbpf doesn't error out on such special symbols, and linker
will just pass-through them and append to the final object file.

>
> > +             src_sec = &obj->secs[sym->st_shndx];
> > +             if (src_sec->skipped)
> > +                     return 0;
> > +             dst_sec = &linker->secs[src_sec->dst_id];
> > +
> > +             /* allow only one STT_SECTION symbol per section */
> > +             if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
> > +                     obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
> > +                     return 0;
> > +             }
> > +     }
> > +
> > +     if (sym_bind == STB_LOCAL)
> > +             goto add_sym;
> > +
> > +     /* find matching BTF info */
> > +     err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id, &btf_id);
> > +     if (err)
> > +             return err;
> > +
> > +     if (sym_is_extern && btf_sec_id) {
> > +             const char *sec_name = NULL;
> > +             const struct btf_type *t;
> > +
> > +             t = btf__type_by_id(obj->btf, btf_sec_id);
> > +             sec_name = btf__str_by_offset(obj->btf, t->name_off);
> > +
> > +             /* Clang puts unannotated extern vars into
> > +              * '.extern' BTF DATASEC. Treat them the same
> > +              * as unannotated extern funcs (which are
> > +              * currently not put into any DATASECs).
> > +              * Those don't have associated src_sec/dst_sec.
> > +              */
> > +             if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
> > +                     src_sec = find_src_sec_by_name(obj, sec_name);
> > +                     if (!src_sec) {
> > +                             pr_warn("failed to find matching ELF sec '%s'\n", sec_name);
> > +                             return -ENOENT;
> > +                     }
> > +                     dst_sec = &linker->secs[src_sec->dst_id];
> > +             }
> > +     }
> > +
> > +     glob_sym = find_glob_sym(linker, sym_name);
> > +     if (glob_sym) {
> > +             /* Preventively resolve to existing symbol. This is
> > +              * needed for further relocation symbol remapping in
> > +              * the next step of linking.
> > +              */
> > +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
> > +
> > +             /* If both symbols are non-externs, at least one of
> > +              * them has to be STB_WEAK, otherwise they are in
> > +              * a conflict with each other.
> > +              */
> > +             if (!sym_is_extern && !glob_sym->is_extern
> > +                 && !glob_sym->is_weak && sym_bind != STB_WEAK) {
> > +                     pr_warn("conflicting non-weak symbol #%d (%s) definition in '%s'\n",
> > +                             src_sym_idx, sym_name, obj->filename);
> > +                     return -EINVAL;
> >               }
> >
> > +             if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
> > +                     return -EINVAL;
> > +
> > +             dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
> > +
> > +             /* If new symbol is strong, then force dst_sym to be strong as
> > +              * well; this way a mix of weak and non-weak extern
> > +              * definitions will end up being strong.
> > +              */
> > +             if (sym_bind == STB_GLOBAL) {
> > +                     /* We still need to preserve type (NOTYPE or
> > +                      * OBJECT/FUNC, depending on whether the symbol is
> > +                      * extern or not)
> > +                      */
> > +                     sym_update_bind(dst_sym, STB_GLOBAL);
> > +                     glob_sym->is_weak = false;
> > +             }
> > +
> > +             /* Non-default visibility is "contaminating", with stricter
> > +              * visibility overwriting more permissive ones, even if more
> > +              * permissive visibility comes from just an extern definition
> > +              */
> > +             if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
> > +                     sym_update_visibility(dst_sym, sym_vis);
>
> For visibility, maybe we can just handle DEFAULT and HIDDEN, and others
> are not supported? DEFAULT + DEFAULT/HIDDEN => DEFAULT, HIDDEN + HIDDEN
> => HIDDEN?
>

Sure, we can restrict this to STV_DEFAULT and STV_HIDDEN for now.

> > +
> > +             /* If the new symbol is extern, then regardless if
> > +              * existing symbol is extern or resolved global, just
> > +              * keep the existing one untouched.
> > +              */
> > +             if (sym_is_extern)
> > +                     return 0;
> > +
> > +             /* If existing symbol is a strong resolved symbol, bail out,
> > +              * because we lost resolution battle have nothing to
> > +              * contribute. We already checked abover that there is no
> > +              * strong-strong conflict. We also already tightened binding
> > +              * and visibility, so nothing else to contribute at that point.
> > +              */
> > +             if (!glob_sym->is_extern && sym_bind == STB_WEAK)
> > +                     return 0;
> > +
> > +             /* At this point, new symbol is strong non-extern,
> > +              * so overwrite glob_sym with new symbol information.
> > +              * Preserve binding and visibility.
> > +              */
> > +             sym_update_type(dst_sym, sym_type);
> > +             dst_sym->st_shndx = dst_sec->sec_idx;
> > +             dst_sym->st_value = src_sec->dst_off + sym->st_value;
> > +             dst_sym->st_size = sym->st_size;
> > +
> > +             /* see comment below about dst_sec->id vs dst_sec->sec_idx */
> > +             glob_sym->sec_id = dst_sec->id;
> > +             glob_sym->is_extern = false;
> > +             /* never relax strong to weak binding */
> > +             if (sym_bind == STB_GLOBAL)
> > +                     glob_sym->is_weak = false;
>
> In the above, we already set glob_sym->is_weak to false if STB_GLOBAL.

yep, you are right, this is unnecessary, I'll remove

>
> > +
> > +             if (complete_extern_btf_info(linker->btf, glob_sym->btf_id,
> > +                                          obj->btf, btf_id))
> > +                     return -EINVAL;
> > +
> > +             /* request updating VAR's/FUNC's underlying BTF type when appending BTF type */
> > +             glob_sym->underlying_btf_id = 0;
> > +
> > +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
> > +             return 0;
> > +     }
> > +
> > +add_sym:
> > +     name_off = strset__add_str(linker->strtab_strs, sym_name);
> > +     if (name_off < 0)
> > +             return name_off;
> > +
> > +     dst_sym = add_new_sym(linker, &dst_sym_idx);
> > +     if (!dst_sym)
> > +             return -ENOMEM;
> > +
> > +     dst_sym->st_name = name_off;
> > +     dst_sym->st_info = sym->st_info;
> > +     dst_sym->st_other = sym->st_other;
> > +     dst_sym->st_shndx = dst_sec ? dst_sec->sec_idx : sym->st_shndx;
> > +     dst_sym->st_value = (src_sec ? src_sec->dst_off : 0) + sym->st_value;
> > +     dst_sym->st_size = sym->st_size;
> > +
> > +     obj->sym_map[src_sym_idx] = dst_sym_idx;
> > +
> > +     if (sym_type == STT_SECTION && dst_sym) {
> > +             dst_sec->sec_sym_idx = dst_sym_idx;
> > +             dst_sym->st_value = 0;
> > +     }
> > +
> > +     if (sym_bind != STB_LOCAL) {
> > +             glob_sym = add_glob_sym(linker);
> > +             if (!glob_sym)
> > +                     return -ENOMEM;
> > +
> > +             glob_sym->sym_idx = dst_sym_idx;
> > +             /* we use dst_sec->id (and not dst_sec->sec_idx), because
> > +              * ephemeral sections (.kconfig, .ksyms, etc) don't have
> > +              * sec_idx (as they don't have corresponding ELF section), but
> > +              * still have id. .extern doesn't have even ephemeral section
> > +              * associated with it, so dst_sec->id == dst_sec->sec_idx == 0.
> > +              */
> > +             glob_sym->sec_id = dst_sec ? dst_sec->id : 0;
> > +             glob_sym->name_off = name_off;
> > +             /* we will fill btf_id in during BTF merging step */
> > +             glob_sym->btf_id = 0;
> > +             glob_sym->is_extern = sym_is_extern;
> > +             glob_sym->is_weak = sym_bind == STB_WEAK;
> >       }
> >
> >       return 0;
> > @@ -1256,7 +1887,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
> >               dst_sec->shdr->sh_info = dst_linked_sec->sec_idx;
> >
> >               src_sec->dst_id = dst_sec->id;
> > -             err = extend_sec(dst_sec, src_sec);
> > +             err = extend_sec(linker, dst_sec, src_sec);
> >               if (err)
> >                       return err;
> >
> > @@ -1309,21 +1940,6 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
> >       return 0;
> >   }
> >
> [...]
> > @@ -1442,6 +2078,7 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >   {
> >       const struct btf_type *t;
> >       int i, j, n, start_id, id;
> > +     const char *name;
> >
> >       if (!obj->btf)
> >               return 0;
> > @@ -1454,12 +2091,40 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >               return -ENOMEM;
> >
> >       for (i = 1; i <= n; i++) {
> > +             struct glob_sym *glob_sym = NULL;
> > +
> >               t = btf__type_by_id(obj->btf, i);
> >
> >               /* DATASECs are handled specially below */
> >               if (btf_kind(t) == BTF_KIND_DATASEC)
> >                       continue;
> >
> > +             if (btf_is_non_static(t)) {
> > +                     /* there should be glob_sym already */
> > +                     name = btf__str_by_offset(obj->btf, t->name_off);
> > +                     glob_sym = find_glob_sym(linker, name);
> > +
> > +                     /* VARs without corresponding glob_sym are those that
> > +                      * belong to skipped/deduplicated sections (i.e.,
> > +                      * license and version), so just skip them
> > +                      */
> > +                     if (!glob_sym)
> > +                             continue;
> > +
> > +                     if (glob_sym->underlying_btf_id == 0)
> > +                             glob_sym->underlying_btf_id = -t->type;
>
> Is this needed? If glob_sym->btf_id is not NULL, then
> glob_sym->underlying_btf_id has been set by the previous object.
> If it is NULL, it will set probably after this
> if (btf_is_non_static(t)) { ...}, is this right?

I think it's still needed. Here's the scenario.

1. Obj file A contains extern symbol X. We create corresponding
glob_sym (with is_extern=true), and store btf_id to point to
BTF_KIND_VAR, and btf_underlying_id to point to the type that
BTF_KIND_VAR points to.

2. Obj file B contains non-extern symbol X. At this point
linker_append_elf_sym() will update glob_sym to is_extern = false, it
will keep btf_id to re-use already appended BTF_KIND_VAR, but it will
zero-out underlying_btf_id, because for externs type could be
incomplete (e.g. for functions it won't contain function argument
names, for maps it could differ even more drastically later). So then
we get here, we see that glob_sym->underlying_btf_id is zero, so needs
updating. We store it as -Y, because Y is BTF type ID in obj->btf, not
in linker->btf (yet). Then the if (glob_sym->btf_id) below sees that
glob_sym->btf_id is already set, so we just keep using already
appended BTF_KIND_VAR (we already set its linkage to
BTF_VAR_GLOBAL_ALLOCATED in complete_extern_btf_info(), called from
linker_append_elf_sym(). So we'll skip appending another BTF_KIND_VAR.
But we do want to point existing BTF_KIND_VAR to a new type that
corresponds to ID -Y.

>
> > +
> > +                     /* globals from previous object files that match our
> > +                      * VAR/FUNC already have a corresponding associated
> > +                      * BTF type, so just make sure to use it
> > +                      */
> > +                     if (glob_sym->btf_id) {
> > +                             /* reuse existing BTF type for global var/func */
> > +                             obj->btf_type_map[i] = glob_sym->btf_id;
> > +                             continue;
> > +                     }
> > +             }
> > +
> >               id = btf__add_type(linker->btf, obj->btf, t);
> >               if (id < 0) {
> >                       pr_warn("failed to append BTF type #%d from file '%s'\n", i, obj->filename);
> > @@ -1467,6 +2132,12 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >               }
> >
> >               obj->btf_type_map[i] = id;
> > +
> > +             /* record just appended BTF type for var/func */
> > +             if (glob_sym) {
> > +                     glob_sym->btf_id = id;
> > +                     glob_sym->underlying_btf_id = -t->type;
> > +             }
> >       }
> >
> >       /* remap all the types except DATASECs */
> > @@ -1478,6 +2149,22 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >                       return -EINVAL;
> >       }
> >
> > +     /* Rewrite VAR/FUNC underlying types (i.e., FUNC's FUNC_PROTO and VAR's
> > +      * actual type), if necessary
> > +      */
> > +     for (i = 0; i < linker->glob_sym_cnt; i++) {
> > +             struct glob_sym *glob_sym = &linker->glob_syms[i];
> > +             struct btf_type *glob_t;
> > +
> > +             if (glob_sym->underlying_btf_id >= 0)
> > +                     continue;
> > +
> > +             glob_sym->underlying_btf_id = obj->btf_type_map[-glob_sym->underlying_btf_id];
>
> After this point, any new *extern* variables will hit the below in the
> previous code:

Right, but we want to hit this for existing glob_syms that went from
extern to non-extern or from weak to non-weak. See

    /* request updating VAR's/FUNC's underlying BTF type when
appending BTF type */
    glob_sym->underlying_btf_id = 0;

in linker_append_elf_sym().

And we'll use that even more extensively when extending __weak and
extern map definitions later.

>  > +                    if (glob_sym->btf_id) {
>  > +                            /* reuse existing BTF type for global var/func */
>  > +                            obj->btf_type_map[i] = glob_sym->btf_id;
>  > +                            continue;
>  > +                    }
>
> > +
> > +             glob_t = btf_type_by_id(linker->btf, glob_sym->btf_id);
> > +             glob_t->type = glob_sym->underlying_btf_id;
> > +     }
> > +
> >       /* append DATASEC info */
> >       for (i = 1; i < obj->sec_cnt; i++) {
> >               struct src_sec *src_sec;
> > @@ -1505,6 +2192,42 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> [...]
