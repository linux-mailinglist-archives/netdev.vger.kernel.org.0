Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B892683D7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 06:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgINE5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 00:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgINE5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 00:57:05 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B184CC061787
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 21:57:03 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u21so21279351eja.2
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 21:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evGZg+iA2HTquYUzwgwC0BxjcVLbRURc4vJR44PQwEM=;
        b=Akt6vxLkCgqM48vOMLd1Gltfm0RnwaycnqFoeNCAOQU7+ijShRIOJZOvJG/nVQ1Xt6
         shuHX/QSWB3+dgMKyDCoNRHsPEy+ob2iE6JecXi0LUMq42u8dyV4ru6Oblx8OArD6aD2
         gF63DVWiuljt3d94ilfE168QIdcDhCSSCwCOmW4nTT2dSJ7gGkGmBVtvzeKVCpFRwy9t
         koIKkFkihH29FUbOkJ65c4R7SQFny7637R1DVvRjfoe0qkGa7BWunmCueypAP9mFs64B
         gWGLCyk39i0LRC0leNtRFCp2SjB9TRT+rYj0thOv9Gzn6lEDPGcS+CPBLJY8zPGvE1Hc
         55oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evGZg+iA2HTquYUzwgwC0BxjcVLbRURc4vJR44PQwEM=;
        b=ntf5FFPE36iEEf29dg8+hsnhh/eoXcSHaaGIU3WlcNv3ZTMoRi/RsrWmFHYG4XESz4
         qHdLF87C41ENMM+lJ7Qv/HmA1CI8Yuzd0JykzJQNj/hLJzpZ8Cx1tlW9gvzmetd4LuUh
         nQqK+9LRJM5er5U1Pbe3MNo6NKvmdX2VxpNueukcJKnptuzFtUFhYywVxMYI7uoQSvwQ
         ISzB4/JG0YLYWfSmsM3EssjDTowwpTTccRkHe8hiUvXPb2KeEneXLzJg2RhG+73UwSTH
         hr5TkwtFmnJlCXihu4Av3icEh3Lg5Hy7Yp29ZlWKFu+uADwzUsUPzDWz1t7E8F92P3/9
         6BPQ==
X-Gm-Message-State: AOAM5309LPg+aWh8wp9gOr4Iago1J/JcO4X2bXBHiQ5o09xWKj8iNVK+
        BWcIz3KDb0nr7kzD8+pQsD+BMuzGvlV9UUHQqmmPeQ==
X-Google-Smtp-Source: ABdhPJyaPFLJ0KgeVWXkay2WiUoLGgw5dkqOb3dY2O62nzvA/TY8X/oDZ4zkyPulxtPeGp0i1xd2TwFCZDIfrnSbuuM=
X-Received: by 2002:a17:907:110f:: with SMTP id qu15mr13388357ejb.359.1600059422196;
 Sun, 13 Sep 2020 21:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-3-haoluo@google.com>
 <CAEf4Bzbu=Rdztx2xC6vkyeT=KGhQdy=+Dto8r1maWMLa5cGHbA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbu=Rdztx2xC6vkyeT=KGhQdy=+Dto8r1maWMLa5cGHbA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Sun, 13 Sep 2020 21:56:51 -0700
Message-ID: <CA+khW7hEuVznft8FvQoSc1b+yYACA8dV9_1rAG_kCP6dMaAWfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] bpf/libbpf: BTF support for typed ksyms
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

Will follow the libbpf logging convention. Thanks for the suggestions.

On Fri, Sep 4, 2020 at 12:34 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 3, 2020 at 3:34 PM Hao Luo <haoluo@google.com> wrote:
> >
> > If a ksym is defined with a type, libbpf will try to find the ksym's btf
> > information from kernel btf. If a valid btf entry for the ksym is found,
> > libbpf can pass in the found btf id to the verifier, which validates the
> > ksym's type and value.
> >
> > Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> > but it has the symbol's address (read from kallsyms) and its value is
> > treated as a raw pointer.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> Logic looks correct, but I have complaints about libbpf logging
> consistency, please see suggestions below.
>
> >  tools/lib/bpf/libbpf.c | 116 ++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 102 insertions(+), 14 deletions(-)
> >
>
> [...]
>
> > @@ -3119,6 +3130,8 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> >                         vt->type = int_btf_id;
> >                         vs->offset = off;
> >                         vs->size = sizeof(int);
> > +                       pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
> > +                                ext->name, vt->type, vs->size, vs->offset);
>
> debug leftover?
>

I was thinking we should leave a debug message when some entries in
BTF are modified. It's probably unnecessary, as I'm thinking of it
right now. I will remove this in v3.

> >                 }
> >                 sec->size = off;
> >         }
> > @@ -5724,8 +5737,13 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
> >                                 insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
> >                                 insn[1].imm = ext->kcfg.data_off;
> >                         } else /* EXT_KSYM */ {
> > -                               insn[0].imm = (__u32)ext->ksym.addr;
> > -                               insn[1].imm = ext->ksym.addr >> 32;
> > +                               if (ext->ksym.type_id) { /* typed ksyms */
> > +                                       insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> > +                                       insn[0].imm = ext->ksym.vmlinux_btf_id;
> > +                               } else { /* typeless ksyms */
> > +                                       insn[0].imm = (__u32)ext->ksym.addr;
> > +                                       insn[1].imm = ext->ksym.addr >> 32;
> > +                               }
> >                         }
> >                         break;
> >                 case RELO_CALL:
> > @@ -6462,10 +6480,72 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> >         return err;
> >  }
> >
> > +static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> > +{
> > +       struct extern_desc *ext;
> > +       int i, id;
> > +
> > +       if (!obj->btf_vmlinux) {
> > +               pr_warn("support of typed ksyms needs kernel btf.\n");
> > +               return -ENOENT;
> > +       }
>
> This check shouldn't be needed, you'd either successfully load
> btf_vmlinux by now or will fail earlier, because BTF is required but
> not found.
>
> > +
> > +       for (i = 0; i < obj->nr_extern; i++) {
> > +               const struct btf_type *targ_var, *targ_type;
> > +               __u32 targ_type_id, local_type_id;
> > +               int ret;
> > +
> > +               ext = &obj->externs[i];
> > +               if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> > +                       continue;
> > +
> > +               id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> > +                                           BTF_KIND_VAR);
> > +               if (id <= 0) {
> > +                       pr_warn("no btf entry for ksym '%s' in vmlinux.\n",
> > +                               ext->name);
>
> please try to stick to consistent style of comments:
>
> "extern (ksym) '%s': failed to find BTF ID in vmlinux BTF" or
> something like that
>
>
> > +                       return -ESRCH;
> > +               }
> > +
> > +               /* find target type_id */
> > +               targ_var = btf__type_by_id(obj->btf_vmlinux, id);
> > +               targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
> > +                                                  targ_var->type,
> > +                                                  &targ_type_id);
> > +
> > +               /* find local type_id */
> > +               local_type_id = ext->ksym.type_id;
> > +
> > +               ret = bpf_core_types_are_compat(obj->btf_vmlinux, targ_type_id,
> > +                                               obj->btf, local_type_id);
>
> you reversed the order, it's always local btf/id, then target btf/id.
>
> > +               if (ret <= 0) {
> > +                       const struct btf_type *local_type;
> > +                       const char *targ_name, *local_name;
> > +
> > +                       local_type = btf__type_by_id(obj->btf, local_type_id);
> > +                       targ_name = btf__name_by_offset(obj->btf_vmlinux,
> > +                                                       targ_type->name_off);
> > +                       local_name = btf__name_by_offset(obj->btf,
> > +                                                        local_type->name_off);
>
> it's a bit unfortunate that we get the name of an already resolved
> type, because if you have a typedef to anon struct, this will give you
> an empty string. I don't know how much of a problem that would be, so
> I think it's fine to leave it as is, and fix it if it's a problem in
> practice.
>
> > +
> > +                       pr_warn("ksym '%s' expects type '%s' (vmlinux_btf_id: #%d), "
> > +                               "but got '%s' (btf_id: #%d)\n", ext->name,
> > +                               targ_name, targ_type_id, local_name, local_type_id);
>
> same thing, please stay consistent in logging format. Check
> bpf_core_dump_spec() for how BTF type info is usually emitted
> throughout libbpf:
>
> "extern (ksym): incompatible types, expected [%d] %s %s, but kernel
> has [%d] %s %s\n"
>
> there is a btf_kind_str() helper to resolve kind to a string representation.
>
>
> > +                       return -EINVAL;
> > +               }
> > +
> > +               ext->is_set = true;
> > +               ext->ksym.vmlinux_btf_id = id;
> > +               pr_debug("extern (ksym) %s=vmlinux_btf_id(#%d)\n", ext->name, id);
>
> "extern (ksym) '%s': resolved to [%d] %s %s\n", similar to above
> suggestion. This "[%d]" format is very consistently used for BTF IDs
> throughout, so it will be familiar and recognizable for people that
> had to deal with this in libbpf logs.
>
> > +       }
> > +       return 0;
> > +}
> > +
> >  static int bpf_object__resolve_externs(struct bpf_object *obj,
> >                                        const char *extra_kconfig)
> >  {
> > -       bool need_config = false, need_kallsyms = false;
> > +       bool need_kallsyms = false, need_vmlinux_btf = false;
> > +       bool need_config = false;
>
> nit: doesn't make sense to change the existing source code line at
> all. Just add `bool need_vmlinux_btf = false;` on a new line? Or we
> can split all these bools into 3 separate lines, if you prefer.
>
> >         struct extern_desc *ext;
> >         void *kcfg_data = NULL;
> >         int err, i;
>
> [...]
