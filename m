Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6EC2F287B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbhALGqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730405AbhALGqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:46:17 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD50C061575;
        Mon, 11 Jan 2021 22:45:37 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id k4so1207194ybp.6;
        Mon, 11 Jan 2021 22:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMABv7IXzzi+2vJU2KcUrOGfO1LLdYJ0/qMijkS7ZzY=;
        b=rme9GDsZWRKvpP+GKCNH7MoIhf3jycV6a9gMceopZGqedBaXn/95uYw2gzEWwMSuFO
         UF61ixrm/FYxbUDC4a/uWfe3oE3hhWQU/QIDvV2j38HPw8/62+VTX7nxFG/Pv1dv8sxb
         yjyjv4VEq/jutlCqrRDoDIiLnH50zKQ/v16z438UIlA3zPWCP+dSg6N9e9nDzIMYoFGs
         KSr4nYHzq+09O/0QnM5a5MUy4avsvy+cydB9bmcrxTMO+6H6gLJDHOg60WZHfME6HASu
         9v4/cs7Bivfh80mF0ZDBXLfqRUcbBqiV7BDlJBwbDmP0gnfxvQjWeIlSjuC+bYx4fDhq
         OFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMABv7IXzzi+2vJU2KcUrOGfO1LLdYJ0/qMijkS7ZzY=;
        b=nqbHqOCvPWz1NX3Gmb9gMbNHwCeniOpCXMt1nDaikI2ggpxPWXKuvFSQeIGYth9A6h
         Av1kSv3MWoUrE/NoSio/+nSx2Ysqm0OhLPu5dFx5t2tcuqV4PLryT0e4NJ4kzzUL8y5P
         O6tfi2xi5cALcslFZB/TopaOmlqVEN3vx1ezYDfp0IdFJ/BhwYu2J+iQ1aOkulp5/IK0
         cFV54Yp2fcPr2h5m+4Ij4KVlQTU3l1BllFrZvYZvK4U3zvfy1HRyzzrESbTOBthIC5X9
         hLQo1WrLFXo3raGNu+FuKyudd4K1hooZiqsx47kXGHu8suSYHT9oW1aCV4tbkku0CwWn
         jwDw==
X-Gm-Message-State: AOAM531cWvzcfr+kuXmjtnSRm6wJ3agm8UJDPjKfkQu36zasqDSNA9TW
        +4ui0JVWF6kgYxb+qb5j5Rx7V8C14QvECaSYjMazrMNorXQ=
X-Google-Smtp-Source: ABdhPJxPsvrmSViraxxeiRxln3itiyMrea1VDdMYKfbLqjDA2i+6yfZCxw0QqjvzrooeGkmGtswrmgFL97yH66LaAvs=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr235859ybd.230.1610433936261;
 Mon, 11 Jan 2021 22:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-7-andrii@kernel.org>
 <dc1a06fe-f957-deb8-772c-b4c65042c3b3@fb.com> <CAEf4BzZGm9=XGWrj_1Q8ZpxZVhcogZVqb=5yCop2mNgdoTT0zA@mail.gmail.com>
 <b9e91dbb-03df-e7d2-8fd9-25bbc77c5188@fb.com>
In-Reply-To: <b9e91dbb-03df-e7d2-8fd9-25bbc77c5188@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 22:45:25 -0800
Message-ID: <CAEf4BzaSzGCjdjw6naPsdPRhwnH=fpqNVJKj7c47WF__V13R_w@mail.gmail.com>
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

On Mon, Jan 11, 2021 at 5:34 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/11/21 1:37 PM, Andrii Nakryiko wrote:
> > On Sun, Jan 10, 2021 at 8:15 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> >>> Add support for searching for ksym externs not just in vmlinux BTF, but across
> >>> all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
> >>> that expose module BTFs through sysfs are assumed to support new ldimm64
> >>> instruction extension with BTF FD provided in insn[1].imm field, so no extra
> >>> feature detection is performed.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>> ---
> >>>    tools/lib/bpf/libbpf.c | 47 +++++++++++++++++++++++++++---------------
> >>>    1 file changed, 30 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>> index 6ae748f6ea11..57559a71e4de 100644
> >>> --- a/tools/lib/bpf/libbpf.c
> >>> +++ b/tools/lib/bpf/libbpf.c
> >>> @@ -395,7 +395,8 @@ struct extern_desc {
> >>>                        unsigned long long addr;
> >>>
> >>>                        /* target btf_id of the corresponding kernel var. */
> >>> -                     int vmlinux_btf_id;
> >>> +                     int kernel_btf_obj_fd;
> >>> +                     int kernel_btf_id;
> >>>
> >>>                        /* local btf_id of the ksym extern's type. */
> >>>                        __u32 type_id;
> >>> @@ -6162,7 +6163,8 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> >>>                        } else /* EXT_KSYM */ {
> >>>                                if (ext->ksym.type_id) { /* typed ksyms */
> >>>                                        insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> >>> -                                     insn[0].imm = ext->ksym.vmlinux_btf_id;
> >>> +                                     insn[0].imm = ext->ksym.kernel_btf_id;
> >>> +                                     insn[1].imm = ext->ksym.kernel_btf_obj_fd;
> >>>                                } else { /* typeless ksyms */
> >>>                                        insn[0].imm = (__u32)ext->ksym.addr;
> >>>                                        insn[1].imm = ext->ksym.addr >> 32;
> >>> @@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> >>>    static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >>>    {
> >>>        struct extern_desc *ext;
> >>> -     int i, id;
> >>> +     struct btf *btf;
> >>> +     int i, j, id, btf_fd, err;
> >>>
> >>>        for (i = 0; i < obj->nr_extern; i++) {
> >>>                const struct btf_type *targ_var, *targ_type;
> >>> @@ -7331,8 +7334,22 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >>>                if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> >>>                        continue;
> >>>
> >>> -             id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> >>> -                                         BTF_KIND_VAR);
> >>> +             btf = obj->btf_vmlinux;
> >>> +             btf_fd = 0;
> >>> +             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> >>> +             if (id == -ENOENT) {
> >>> +                     err = load_module_btfs(obj);
> >>> +                     if (err)
> >>> +                             return err;
> >>> +
> >>> +                     for (j = 0; j < obj->btf_module_cnt; j++) {
> >>> +                             btf = obj->btf_modules[j].btf;
> >>> +                             btf_fd = obj->btf_modules[j].fd;
> >>
> >> Do we have possibility btf_fd == 0 here?
> >
> > Extremely unlikely. But if we are really worried about 0 fd, we should
> > handle that in a centralized fashion in libbpf. I.e., for any
> > operation that can return FD, check if that FD is 0, and if yes, dup()
> > it. And then make everything call that helper. So in the context of
> > this patch I'm just ignoring such possibility.
> Maybe at least add some comments here to document such a possibility?

sure, will add

>
> >
> >>
> >>> +                             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> >>> +                             if (id != -ENOENT)
> >>> +                                     break;
> >>> +                     }
> >>> +             }
> >>>                if (id <= 0) {
> >>>                        pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
> >>>                                ext->name);
> >>> @@ -7343,24 +7360,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >>>                local_type_id = ext->ksym.type_id;
> >>>
> >>>                /* find target type_id */
> >>> -             targ_var = btf__type_by_id(obj->btf_vmlinux, id);
> >>> -             targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
> >>> -                                                 targ_var->name_off);
> >>> -             targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
> >>> -                                                targ_var->type,
> >>> -                                                &targ_type_id);
> >>> +             targ_var = btf__type_by_id(btf, id);
> >>> +             targ_var_name = btf__name_by_offset(btf, targ_var->name_off);
> >>> +             targ_type = skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id);
> >>>
> >>>                ret = bpf_core_types_are_compat(obj->btf, local_type_id,
> >>> -                                             obj->btf_vmlinux, targ_type_id);
> >>> +                                             btf, targ_type_id);
> >>>                if (ret <= 0) {
> >>>                        const struct btf_type *local_type;
> >>>                        const char *targ_name, *local_name;
> >>>
> >>>                        local_type = btf__type_by_id(obj->btf, local_type_id);
> >>> -                     local_name = btf__name_by_offset(obj->btf,
> >>> -                                                      local_type->name_off);
> >>> -                     targ_name = btf__name_by_offset(obj->btf_vmlinux,
> >>> -                                                     targ_type->name_off);
> >>> +                     local_name = btf__name_by_offset(obj->btf, local_type->name_off);
> >>> +                     targ_name = btf__name_by_offset(btf, targ_type->name_off);
> >>>
> >>>                        pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
> >>>                                ext->name, local_type_id,
> >>> @@ -7370,7 +7382,8 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >>>                }
> >>>
> >>>                ext->is_set = true;
> >>> -             ext->ksym.vmlinux_btf_id = id;
> >>> +             ext->ksym.kernel_btf_obj_fd = btf_fd;
> >>> +             ext->ksym.kernel_btf_id = id;
> >>>                pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
> >>>                         ext->name, id, btf_kind_str(targ_var), targ_var_name);
> >>>        }
> >>>
