Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B23427EB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhCSVjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhCSVjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 17:39:00 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5830C06175F;
        Fri, 19 Mar 2021 14:38:59 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id h82so7674985ybc.13;
        Fri, 19 Mar 2021 14:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKWr1Bn9ZjhfXIAth1sONrXqvmC3ifJfteNe9tuoAFg=;
        b=vhBF5KWv0pv9gPAv64kZ6eJBlXpmoKEcTOEzzEBu1rR6VhKkVuchmv3QpA2DBb4MZU
         t9pyit0hTSkvRvGCdN8ifN5Aj0MYTd4vUwpBLHQF+OzxK6Dnqq468d6TyAt1D1lQF+xY
         G+lvDJSTXEmKLjrbZKwqNLhy34mSv28izJPe555I86rWHly6viUFn9klQUGz9bl26dgC
         078YEV38d2po8NvYkk22+NvnzdxizJ514ZDlTjsRRFyK8Wjt5Fbuz7mjTvYdueUvCHBq
         Yz8gHaX4+lla4TwKtBI2R+zc6kiDhSB6yRidR1wNxREY6g9W+03Yjva+fBa0wMmDZVSJ
         pUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKWr1Bn9ZjhfXIAth1sONrXqvmC3ifJfteNe9tuoAFg=;
        b=OSZzoVQhP1tR81BoxMXIZSnZudeit+z3Ver5AI3XHGuFFMkR0WWfuMYdbB1+wMWYBz
         4RzQdpRzpciUxgTACkKDYcqteUV0EuwcGylY1qtQZQTCnlq8BIWyuIC7ScNsewCVWozs
         DtGIuQXFhYnIkGZIZZ9lLeBlMNQcaoCRLgcx9tfcOdA/AFXlY8o28y56ct+xoQfUSdr5
         t17+aBJBvHPrheH6EnK+yzzhv1W8kAPW/JOmoEADZ3nRJweVwvIQM4iVnL5i757aoprT
         fe5LuhXU3d0UXCHzR1635AIF3GaNLk2aPKQhF0svD8TLsJjmzIFasjsRuSaK6O4LlmoE
         Z/Hw==
X-Gm-Message-State: AOAM530xKQnj6ozuoVDx1IHTFUhVAvKZXYhoAHSCDZJGgb3MWyZLKYJ+
        pMtZoHS65w+Xhrr43Cx0HZLbtFWzOUn0mlj9dIA=
X-Google-Smtp-Source: ABdhPJze326/hGRn3PBZvSYubiC97y+fKBdhLeHII9AVqbarlSX0gfxBj/d574PaZPHqQOAjwurptPEj3oW1drHZhug=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr8881658yba.510.1616189938898;
 Fri, 19 Mar 2021 14:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011451.4180026-1-kafai@fb.com>
 <CAEf4BzZVROg4Ygas2q-FFmc4o=yk+oHtx6KV_b=93OZbsjK0Bw@mail.gmail.com> <20210319050649.ytoy4kpw6pvap4ky@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210319050649.ytoy4kpw6pvap4ky@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Mar 2021 14:38:48 -0700
Message-ID: <CAEf4BzYrT227tkZC6WXBdnvwxZx1XixOdBN_OXFPjTtUg7Ow1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/15] libbpf: Support extern kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 10:06 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 18, 2021 at 09:11:39PM -0700, Andrii Nakryiko wrote:
> > On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch is to make libbpf able to handle the following extern
> > > kernel function declaration and do the needed relocations before
> > > loading the bpf program to the kernel.
> > >
> > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > >
> > > In the collect extern phase, needed changes is made to
> > > bpf_object__collect_externs() and find_extern_btf_id() to collect
> > > function.
> > >
> > > In the collect relo phase, it will record the kernel function
> > > call as RELO_EXTERN_FUNC.
> > >
> > > bpf_object__resolve_ksym_func_btf_id() is added to find the func
> > > btf_id of the running kernel.
> > >
> > > During actual relocation, it will patch the BPF_CALL instruction with
> > > src_reg = BPF_PSEUDO_FUNC_CALL and insn->imm set to the running
> > > kernel func's btf_id.
> > >
> > > btf_fixup_datasec() is changed also because a datasec may
> > > only have func and its size will be 0.  The "!size" test
> > > is postponed till it is confirmed there are vars.
> > > It also takes this chance to remove the
> > > "if (... || (t->size && t->size != size)) { return -ENOENT; }" test
> > > because t->size is zero at the point.
> > >
> > > The required LLVM patch: https://reviews.llvm.org/D93563
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/lib/bpf/btf.c    |  32 ++++++++----
> > >  tools/lib/bpf/btf.h    |   5 ++
> > >  tools/lib/bpf/libbpf.c | 113 +++++++++++++++++++++++++++++++++++++----
> > >  3 files changed, 129 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > > index 3aa58f2ac183..bb09b577c154 100644
> > > --- a/tools/lib/bpf/btf.c
> > > +++ b/tools/lib/bpf/btf.c
> > > @@ -1108,7 +1108,7 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> > >         const struct btf_type *t_var;
> > >         struct btf_var_secinfo *vsi;
> > >         const struct btf_var *var;
> > > -       int ret;
> > > +       int ret, nr_vars = 0;
> > >
> > >         if (!name) {
> > >                 pr_debug("No name found in string section for DATASEC kind.\n");
> > > @@ -1117,27 +1117,27 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> > >
> > >         /* .extern datasec size and var offsets were set correctly during
> > >          * extern collection step, so just skip straight to sorting variables
> > > +        * One exception is the datasec may only have extern funcs,
> > > +        * t->size is 0 in this case.  This will be handled
> > > +        * with !nr_vars later.
> > >          */
> > >         if (t->size)
> > >                 goto sort_vars;
> > >
> > > -       ret = bpf_object__section_size(obj, name, &size);
> > > -       if (ret || !size || (t->size && t->size != size)) {
> > > -               pr_debug("Invalid size for section %s: %u bytes\n", name, size);
> > > -               return -ENOENT;
> > > -       }
> > > -
> > > -       t->size = size;
> > > +       bpf_object__section_size(obj, name, &size);
> >
> > So it's not great that we just ignore any errors here. ".ksyms" is a
> > special section, so it should be fine to just ignore it by name and
> > leave the rest of error handling intact.
> The ret < 0 case? In that case, size is 0.
>
> or there are cases that a section has no vars but the size should not be 0?

ret < 0 is an error, which will no longer be propagated. Silently
consuming an error is what I'm worried about.

>
> >
> > >
> > >         for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
> > >                 t_var = btf__type_by_id(btf, vsi->type);
> > > -               var = btf_var(t_var);
> > >
> > > -               if (!btf_is_var(t_var)) {
> > > -                       pr_debug("Non-VAR type seen in section %s\n", name);
> > > +               if (btf_is_func(t_var)) {
> > > +                       continue;
> >
> > just
> >
> > if (btf_is_func(t_var))
> >     continue;
> >
> > no need for "else if" below
> >
> > > +               } else if (!btf_is_var(t_var)) {
> > > +                       pr_debug("Non-VAR and Non-FUNC type seen in section %s\n", name);
> >
> > nit: Non-FUNC -> non-FUNC
> >
> > >                         return -EINVAL;
> > >                 }
> > >
> > > +               nr_vars++;
> > > +               var = btf_var(t_var);
> > >                 if (var->linkage == BTF_VAR_STATIC)
> > >                         continue;
> > >
> > > @@ -1157,6 +1157,16 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> > >                 vsi->offset = off;
> > >         }
> > >
> > > +       if (!nr_vars)
> > > +               return 0;
> > > +
> > > +       if (!size) {
> > > +               pr_debug("Invalid size for section %s: %u bytes\n", name, size);
> > > +               return -ENOENT;
> > > +       }
> > > +
> > > +       t->size = size;
> > > +
> > >  sort_vars:
> > >         qsort(btf_var_secinfos(t), vars, sizeof(*vsi), compare_vsi_off);
> > >         return 0;
> > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > index 029a9cfc8c2d..07d508b70497 100644
> > > --- a/tools/lib/bpf/btf.h
> > > +++ b/tools/lib/bpf/btf.h
> > > @@ -368,6 +368,11 @@ btf_var_secinfos(const struct btf_type *t)
> > >         return (struct btf_var_secinfo *)(t + 1);
> > >  }
> > >
> > > +static inline enum btf_func_linkage btf_func_linkage(const struct btf_type *t)
> > > +{
> > > +       return (enum btf_func_linkage)BTF_INFO_VLEN(t->info);
> > > +}
> >
> > exposing `enum btf_func_linkage` in libbpf API headers will cause
> > compilation errors for users on older systems. We went through a bunch
> > of pain with `enum bpf_stats_type` (and it is still causing pain for
> > C++), I'd rather avoid some more here. Can you please move it into
> > libbpf.c for now. It doesn't seem like a very popular function that
> > needs to be exposed to users.
> will do.
>
> >
> > > +
> > >  #ifdef __cplusplus
> > >  } /* extern "C" */
> > >  #endif
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 0a60fcb2fba2..49bda179bd93 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -190,6 +190,7 @@ enum reloc_type {
> > >         RELO_CALL,
> > >         RELO_DATA,
> > >         RELO_EXTERN_VAR,
> > > +       RELO_EXTERN_FUNC,
> > >         RELO_SUBPROG_ADDR,
> > >  };
> > >
> > > @@ -384,6 +385,7 @@ struct extern_desc {
> > >         int btf_id;
> > >         int sec_btf_id;
> > >         const char *name;
> > > +       const struct btf_type *btf_type;
> > >         bool is_set;
> > >         bool is_weak;
> > >         union {
> > > @@ -3022,7 +3024,7 @@ static bool sym_is_subprog(const GElf_Sym *sym, int text_shndx)
> > >  static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
> > >  {
> > >         const struct btf_type *t;
> > > -       const char *var_name;
> > > +       const char *tname;
> > >         int i, n;
> > >
> > >         if (!btf)
> > > @@ -3032,14 +3034,18 @@ static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
> > >         for (i = 1; i <= n; i++) {
> > >                 t = btf__type_by_id(btf, i);
> > >
> > > -               if (!btf_is_var(t))
> > > +               if (!btf_is_var(t) && !btf_is_func(t))
> > >                         continue;
> > >
> > > -               var_name = btf__name_by_offset(btf, t->name_off);
> > > -               if (strcmp(var_name, ext_name))
> > > +               tname = btf__name_by_offset(btf, t->name_off);
> > > +               if (strcmp(tname, ext_name))
> > >                         continue;
> > >
> > > -               if (btf_var(t)->linkage != BTF_VAR_GLOBAL_EXTERN)
> > > +               if (btf_is_var(t) &&
> > > +                   btf_var(t)->linkage != BTF_VAR_GLOBAL_EXTERN)
> > > +                       return -EINVAL;
> > > +
> > > +               if (btf_is_func(t) && btf_func_linkage(t) != BTF_FUNC_EXTERN)
> > >                         return -EINVAL;
> > >
> > >                 return i;
> > > @@ -3199,10 +3205,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >                         return ext->btf_id;
> > >                 }
> > >                 t = btf__type_by_id(obj->btf, ext->btf_id);
> > > +               ext->btf_type = t;
> >
> > ext->btf_type is derived from ext->btf_id and obj->btf (always), so
> > there is no need for it
> It is for easier btf_is_var() check later instead of going through
> another btf__type_by_id().
>
> yeah, I will make a few btf__type_by_id() calls in v2.
>
> >
> > >                 ext->name = btf__name_by_offset(obj->btf, t->name_off);
> > >                 ext->sym_idx = i;
> > >                 ext->is_weak = GELF_ST_BIND(sym.st_info) == STB_WEAK;
> > > -
> > >                 ext->sec_btf_id = find_extern_sec_btf_id(obj->btf, ext->btf_id);
> > >                 if (ext->sec_btf_id <= 0) {
> > >                         pr_warn("failed to find BTF for extern '%s' [%d] section: %d\n",
> > > @@ -3212,6 +3218,34 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >                 sec = (void *)btf__type_by_id(obj->btf, ext->sec_btf_id);
> > >                 sec_name = btf__name_by_offset(obj->btf, sec->name_off);
> > >
> > > +               if (btf_is_func(t)) {
> >
> > there is a KSYMS_SEC handling logic below, let's keep both func and
> > variables handling together there?
> It is to keep the indentation manageable
> and also most of the things doing here is not
> sharable with variables.
>
> Sure. I can move it there.

Yes, please. KCONFIG_SEC has a similar level of indentation, it's been
manageable so far.

>
> >
> > > +                       const struct btf_type *func_proto;
> > > +
> > > +                       func_proto = btf__type_by_id(obj->btf, t->type);
> > > +                       if (!func_proto || !btf_is_func_proto(func_proto)) {
> >
> > this is implied by BTF format itself, seems a bit redundant
> It has already been checked?

libbpf doesn't validate BTF for complete correctness, but if it will,
it's better to do it in one place, instead of multiple partial checks
spread out everywhere. Good thing is that the kernel will always
strictly validate everything in the end.

>
> >
> > > +                               pr_warn("extern function %s does not have a valid func_proto\n",
> > > +                                       ext->name);
> > > +                               return -EINVAL;
> > > +                       }
> > > +
> > > +                       if (ext->is_weak) {
> > > +                               pr_warn("extern weak function %s is unsupported\n",
> > > +                                       ext->name);
> > > +                               return -ENOTSUP;
> > > +                       }
> > > +
> > > +                       if (strcmp(sec_name, KSYMS_SEC)) {
> > > +                               pr_warn("extern function %s is only supported under %s section\n",
> > > +                                       ext->name, KSYMS_SEC);
> > > +                               return -ENOTSUP;
> > > +                       }
> > > +
> > > +                       ksym_sec = sec;
> > > +                       ext->type = EXT_KSYM;
> > > +                       ext->ksym.type_id = ext->btf_id;
> >
> > there is skip_mods_and_typedefs in KSYMS_SEC section below, but it
> > won't have any effect on FUNC_PROTO, so existing logic can be used
> > as-is
> func id is used here to keep what ksyms.type_id means:
> /* local btf_id of the ksym extern's type. */
>
> The kernel extern type here should be func instead of func_proto.
> func_proto cannot be extern.

Ah, I see. Ok, then you'll need to skip the skip_mods_and_typedef for
funcs (you'll have a special weak check just for funcs anyway). But I
still prefer to keep all the logic for KSYMS_SEC in one place. Thanks.

>
> >
> > > +                       continue;
> > > +               }
> > > +
> > >                 if (strcmp(sec_name, KCONFIG_SEC) == 0) {
> > >                         kcfg_sec = sec;
> > >                         ext->type = EXT_KCFG;
> >
> > [...]
> >
> > > +static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
> > > +                                               struct extern_desc *ext)
> > > +{
> > > +       int local_func_proto_id, kern_func_proto_id, kern_func_id;
> > > +       const struct btf_type *kern_func;
> > > +       struct btf *kern_btf = NULL;
> > > +       int ret, kern_btf_fd = 0;
> > > +
> > > +       local_func_proto_id = ext->btf_type->type;
> >
> > yeah, so this ext->btf_type can be retrieved with
> > btf__type_by_id(obj->btf, ext->btf_id) here, no need to pollute
> > extern_desc with extra field
> >
> > > +
> > > +       kern_func_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
> > > +                                       &kern_btf, &kern_btf_fd);
> > > +       if (kern_func_id < 0) {
> > > +               pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
> > > +                       ext->name);
> > > +               return kern_func_id;
> > > +       }
> > > +
> > > +       if (kern_btf != obj->btf_vmlinux) {
> > > +               pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
> > > +                       ext->name);
> > > +               return -ENOTSUP;
> > > +       }
> > > +
> >
> > [...]
