Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D12F21E8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbhAKViG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731135AbhAKViG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:38:06 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD2C061786;
        Mon, 11 Jan 2021 13:37:25 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id o144so231791ybc.0;
        Mon, 11 Jan 2021 13:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2o7n1b95mhJ04iOlCeYJ4uFpu3sRTd210tm7U1KFn8s=;
        b=FOkUKWbNVq/VsjFyRb2z9vebNB+yK3s8PU4agvQkSOwoQqLID/Qdukf3rL5IFQutAg
         Pffh+CpEgCdMdnHQihci6TUiUAHPWEpDlWFjND3JCCzlEuVuRZV2KpvY2BKZpqjzCObN
         YgIeci1yF2rquaML9ZVYyTi2dQvJn5nraJOmXbA4XgjzKMW/rdzU702m1KAHZJtvzrCN
         Zx0J4fU9oVV+8B168Hk2ZBNmn1Yd9lLU4/5aVf/6vKOC33/nWL/BJSsgPQ8UkSV4o6bM
         cAMNEbJnAaXPIsaGLtrZw/1f+S5QrH4gBcpLDZVh6IzqA7rNwiDgW2dGi7qUbB95VxoX
         dxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2o7n1b95mhJ04iOlCeYJ4uFpu3sRTd210tm7U1KFn8s=;
        b=XGzK31ds2pWqFz75ivLYw9XvuubTIXFx2zgdzCl3V+doiLSIapA5ezsMJFWyyutP1w
         +oIeUk02jzzJ2P8I0NyNWT5v+zTCxfKPnnaepmYVEJx+RaaN+/bo4tfIgnp4zFy/jfK9
         hMTzJFvviXpQzydmrSSgqcgVmFTZAHENe28oAdm/yw7J/hqUV+J/rCYMF2uPS97OPDia
         AVcbCkih7SF7XVogcvGtM6zh5wSGmXh8LeZ0qzygsuX0cgdgX1H/RUI8tDBmdnpEDKs7
         Umc2dKrUtlRhTSRyMVWV6a5nBQBdWp8ChrGSzVl9zwUkwZhLEwcgpaFssffBsEUiUUax
         1Arg==
X-Gm-Message-State: AOAM5318xaelRTXcrhNufOqkLpL4esed4QolsEQyIDQWMWKVlfhUSts+
        Yt946UkGjsz1iKVAto9hoBvID3KthaOdi4Rr3Fs=
X-Google-Smtp-Source: ABdhPJwTzax1frKKZDoH4VDCnA39+cVDW5sP6lJIFIDPayuinJukQlBMaYCOy3PNJgLWR22d04DgYlamRVvI+92zjEg=
X-Received: by 2002:a25:d44:: with SMTP id 65mr2588765ybn.260.1610401045101;
 Mon, 11 Jan 2021 13:37:25 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-7-andrii@kernel.org>
 <dc1a06fe-f957-deb8-772c-b4c65042c3b3@fb.com>
In-Reply-To: <dc1a06fe-f957-deb8-772c-b4c65042c3b3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:37:14 -0800
Message-ID: <CAEf4BzZGm9=XGWrj_1Q8ZpxZVhcogZVqb=5yCop2mNgdoTT0zA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/7] libbpf: support kernel module ksym externs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 8:15 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> > Add support for searching for ksym externs not just in vmlinux BTF, but across
> > all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
> > that expose module BTFs through sysfs are assumed to support new ldimm64
> > instruction extension with BTF FD provided in insn[1].imm field, so no extra
> > feature detection is performed.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/libbpf.c | 47 +++++++++++++++++++++++++++---------------
> >   1 file changed, 30 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 6ae748f6ea11..57559a71e4de 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -395,7 +395,8 @@ struct extern_desc {
> >                       unsigned long long addr;
> >
> >                       /* target btf_id of the corresponding kernel var. */
> > -                     int vmlinux_btf_id;
> > +                     int kernel_btf_obj_fd;
> > +                     int kernel_btf_id;
> >
> >                       /* local btf_id of the ksym extern's type. */
> >                       __u32 type_id;
> > @@ -6162,7 +6163,8 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> >                       } else /* EXT_KSYM */ {
> >                               if (ext->ksym.type_id) { /* typed ksyms */
> >                                       insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> > -                                     insn[0].imm = ext->ksym.vmlinux_btf_id;
> > +                                     insn[0].imm = ext->ksym.kernel_btf_id;
> > +                                     insn[1].imm = ext->ksym.kernel_btf_obj_fd;
> >                               } else { /* typeless ksyms */
> >                                       insn[0].imm = (__u32)ext->ksym.addr;
> >                                       insn[1].imm = ext->ksym.addr >> 32;
> > @@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> >   static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >   {
> >       struct extern_desc *ext;
> > -     int i, id;
> > +     struct btf *btf;
> > +     int i, j, id, btf_fd, err;
> >
> >       for (i = 0; i < obj->nr_extern; i++) {
> >               const struct btf_type *targ_var, *targ_type;
> > @@ -7331,8 +7334,22 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >               if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> >                       continue;
> >
> > -             id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> > -                                         BTF_KIND_VAR);
> > +             btf = obj->btf_vmlinux;
> > +             btf_fd = 0;
> > +             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> > +             if (id == -ENOENT) {
> > +                     err = load_module_btfs(obj);
> > +                     if (err)
> > +                             return err;
> > +
> > +                     for (j = 0; j < obj->btf_module_cnt; j++) {
> > +                             btf = obj->btf_modules[j].btf;
> > +                             btf_fd = obj->btf_modules[j].fd;
>
> Do we have possibility btf_fd == 0 here?

Extremely unlikely. But if we are really worried about 0 fd, we should
handle that in a centralized fashion in libbpf. I.e., for any
operation that can return FD, check if that FD is 0, and if yes, dup()
it. And then make everything call that helper. So in the context of
this patch I'm just ignoring such possibility.

>
> > +                             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> > +                             if (id != -ENOENT)
> > +                                     break;
> > +                     }
> > +             }
> >               if (id <= 0) {
> >                       pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
> >                               ext->name);
> > @@ -7343,24 +7360,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >               local_type_id = ext->ksym.type_id;
> >
> >               /* find target type_id */
> > -             targ_var = btf__type_by_id(obj->btf_vmlinux, id);
> > -             targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
> > -                                                 targ_var->name_off);
> > -             targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
> > -                                                targ_var->type,
> > -                                                &targ_type_id);
> > +             targ_var = btf__type_by_id(btf, id);
> > +             targ_var_name = btf__name_by_offset(btf, targ_var->name_off);
> > +             targ_type = skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id);
> >
> >               ret = bpf_core_types_are_compat(obj->btf, local_type_id,
> > -                                             obj->btf_vmlinux, targ_type_id);
> > +                                             btf, targ_type_id);
> >               if (ret <= 0) {
> >                       const struct btf_type *local_type;
> >                       const char *targ_name, *local_name;
> >
> >                       local_type = btf__type_by_id(obj->btf, local_type_id);
> > -                     local_name = btf__name_by_offset(obj->btf,
> > -                                                      local_type->name_off);
> > -                     targ_name = btf__name_by_offset(obj->btf_vmlinux,
> > -                                                     targ_type->name_off);
> > +                     local_name = btf__name_by_offset(obj->btf, local_type->name_off);
> > +                     targ_name = btf__name_by_offset(btf, targ_type->name_off);
> >
> >                       pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
> >                               ext->name, local_type_id,
> > @@ -7370,7 +7382,8 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >               }
> >
> >               ext->is_set = true;
> > -             ext->ksym.vmlinux_btf_id = id;
> > +             ext->ksym.kernel_btf_obj_fd = btf_fd;
> > +             ext->ksym.kernel_btf_id = id;
> >               pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
> >                        ext->name, id, btf_kind_str(targ_var), targ_var_name);
> >       }
> >
