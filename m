Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC48645403F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 06:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhKQFit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 00:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKQFis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 00:38:48 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8A8C061570;
        Tue, 16 Nov 2021 21:35:50 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id s186so3826351yba.12;
        Tue, 16 Nov 2021 21:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pRbo0vRfs7BV5K7nEdz3Z555wXJjNf8b/69GOEtIJTQ=;
        b=VtfDk35iRh9cs5vSb7df7JGwC/PAJF3WI/PAQawOoNlm+uHkKPrFRwRkByjTq1QjYo
         JDyuV39B4BlY745eJho2FXmjXoFokySxDco4Sgzb1yn9d8Mrm7lgMpmsbZ3xqtSPQkkA
         G3U9Hp9dFEmbWm2Qb0i4W2uuLU62SOQbuWdgx5xfUJrkhpMveTduS7x/QCKHJ0tq2Gfq
         KpPxGxtf9ghX7B9RzyaQ9abkRhiU40ohOYDnnPPQBd6f9E9wvMg/1M7pYQUPLVG7kQyz
         oPn3DdZiMix89VBKblf/L8TfGLIfO7DaTcTkcZHU7G3rJokqgrIEXTgfkUA8vZKuNF8E
         Otbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pRbo0vRfs7BV5K7nEdz3Z555wXJjNf8b/69GOEtIJTQ=;
        b=jrOp7AYZ3u3TEvWIN0Zpp8HZwklfuQ/2V8uWLiJd067QKP3vlKoQ+phbZZU6fbQHXL
         au2O59CQkP8IrGBYsIIvNXu+1bi7YQR1ehSBAw7JmzYDDlX6fiK+QLse2BtXWPkBP1ax
         csblFkN2Ycj+9Mk0MUEK1fczFjUlPprqAOIiKkzyeLDvDwk5T4tIZox4E3Kbo+G2ccZf
         8R1LddTZtQ30UU4mLi81acWs8t3CHfs/BsOwkGm/GjhH5YzxeIS0KlCt7r/id6KF2VGx
         z6SLI+CiOXd6ZdUI2lYilayycMVVG3PFqT6doUDl+glA7Fa2BpRvr2xPnwv9SR436wpv
         m0Tw==
X-Gm-Message-State: AOAM532ncehW/Uf/UCbxYRQBrJR46pFEGvCkp2OkQGmbHND9vSuXGb7x
        gdBUgyuItQSyHS1htjGZOPqH+IEvZ4VNaBaX8T0=
X-Google-Smtp-Source: ABdhPJwYlABkGMrT3dyUFbSUnmB5nWe3Ae9DsBUDUkSoZWPRPbKUQf3AWBK0Bs28D6Nlwa34v0GHJenV1UJca+irZOY=
X-Received: by 2002:a25:d010:: with SMTP id h16mr16334473ybg.225.1637127350152;
 Tue, 16 Nov 2021 21:35:50 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-4-mauricio@kinvolk.io>
 <CAHap4zv=-YV6oXdncZW9DRaBu16b6-81HXretRX-orL2d=B4sQ@mail.gmail.com>
In-Reply-To: <CAHap4zv=-YV6oXdncZW9DRaBu16b6-81HXretRX-orL2d=B4sQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Nov 2021 21:35:39 -0800
Message-ID: <CAEf4BzZFaUESNo=kaM-UTTme8OfEiVyWRVGEe-PS00d5yasANw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Introduce 'bpf_object__prepare()'
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 11:24 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Tue, Nov 16, 2021 at 11:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.=
io> wrote:
> >
> > BTFGen[0] requires access to the result of the CO-RE relocations withou=
t
> > actually loading the bpf programs. The current libbpf API doesn't allow
> > it because all the object preparation (subprogs, relocations: co-re,
> > elf, maps) happens inside bpf_object__load().
> >
> > This commit introduces a new bpf_object__prepare() function to perform
> > all the preparation steps than an ebpf object requires, allowing users
> > to access the result of those preparation steps without having to load
> > the program. Almost all the steps that were done in bpf_object__load()
> > are now done in bpf_object__prepare(), except map creation and program
> > loading.
> >
> > Map relocations require a bit more attention as maps are only created i=
n
> > bpf_object__load(). For this reason bpf_object__prepare() relocates map=
s
> > using BPF_PSEUDO_MAP_IDX, if someone dumps the instructions before
> > loading the program they get something meaningful. Map relocations are
> > completed in bpf_object__load() once the maps are created and we have
> > their fd to use with BPF_PSEUDO_MAP_FD.
> >
> > Users won=E2=80=99t see any visible changes if they=E2=80=99re using bp=
f_object__open()
> > + bpf_object__load() because this commit keeps backwards compatibility
> > by calling bpf_object__prepare() in bpf_object_load() if it wasn=E2=80=
=99t
> > called by the user.
> >
> > bpf_object__prepare_xattr() is not implemented as their counterpart
> > bpf_object__load_xattr() will be deprecated[1]. New options will be
> > added only to bpf_object_open_opts.
> >
> > [0]: https://github.com/kinvolk/btfgen/
> > [1]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#lib=
bpfh-high-level-apis
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/lib/bpf/libbpf.c   | 130 ++++++++++++++++++++++++++++-----------
> >  tools/lib/bpf/libbpf.h   |   2 +
> >  tools/lib/bpf/libbpf.map |   1 +
> >  3 files changed, 98 insertions(+), 35 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 6ca76365c6da..f50f9428bb03 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -514,6 +514,7 @@ struct bpf_object {
> >         int nr_extern;
> >         int kconfig_map_idx;
> >
> > +       bool prepared;
> >         bool loaded;
> >         bool has_subcalls;
> >         bool has_rodata;
> > @@ -5576,34 +5577,19 @@ bpf_object__relocate_data(struct bpf_object *ob=
j, struct bpf_program *prog)
> >
> >                 switch (relo->type) {
> >                 case RELO_LD64:
> > -                       if (obj->gen_loader) {
> > -                               insn[0].src_reg =3D BPF_PSEUDO_MAP_IDX;
> > -                               insn[0].imm =3D relo->map_idx;
> > -                       } else {
> > -                               insn[0].src_reg =3D BPF_PSEUDO_MAP_FD;
> > -                               insn[0].imm =3D obj->maps[relo->map_idx=
].fd;
> > -                       }
> > +                       insn[0].src_reg =3D BPF_PSEUDO_MAP_IDX;
> > +                       insn[0].imm =3D relo->map_idx;
> >                         break;
> >                 case RELO_DATA:
> >                         insn[1].imm =3D insn[0].imm + relo->sym_off;
> > -                       if (obj->gen_loader) {
> > -                               insn[0].src_reg =3D BPF_PSEUDO_MAP_IDX_=
VALUE;
> > -                               insn[0].imm =3D relo->map_idx;
> > -                       } else {
> > -                               insn[0].src_reg =3D BPF_PSEUDO_MAP_VALU=
E;
> > -                               insn[0].imm =3D obj->maps[relo->map_idx=
].fd;
> > -                       }
> > +                       insn[0].src_reg =3D BPF_PSEUDO_MAP_IDX_VALUE;
> > +                       insn[0].imm =3D relo->map_idx;
> >                         break;
> >                 case RELO_EXTERN_VAR:
> >                         ext =3D &obj->externs[relo->sym_off];
> >                         if (ext->type =3D=3D EXT_KCFG) {
> > -                               if (obj->gen_loader) {
> > -                                       insn[0].src_reg =3D BPF_PSEUDO_=
MAP_IDX_VALUE;
> > -                                       insn[0].imm =3D obj->kconfig_ma=
p_idx;
> > -                               } else {
> > -                                       insn[0].src_reg =3D BPF_PSEUDO_=
MAP_VALUE;
> > -                                       insn[0].imm =3D obj->maps[obj->=
kconfig_map_idx].fd;
> > -                               }
> > +                               insn[0].src_reg =3D BPF_PSEUDO_MAP_IDX_=
VALUE;
> > +                               insn[0].imm =3D obj->kconfig_map_idx;
> >                                 insn[1].imm =3D ext->kcfg.data_off;
> >                         } else /* EXT_KSYM */ {
> >                                 if (ext->ksym.type_id && ext->is_set) {=
 /* typed ksyms */
> > @@ -6144,8 +6130,50 @@ bpf_object__relocate(struct bpf_object *obj, con=
st char *targ_btf_path)
> >                         return err;
> >                 }
> >         }
> > -       if (!obj->gen_loader)
> > -               bpf_object__free_relocs(obj);
> > +
> > +       return 0;
> > +}
> > +
> > +/* relocate instructions that refer to map fds */
> > +static int
> > +bpf_object__finish_relocate(struct bpf_object *obj)
> > +{
> > +       int i, j;
> > +
> > +       if (obj->gen_loader)
> > +               return 0;
> > +
> > +       for (i =3D 0; i < obj->nr_programs; i++) {
> > +               struct bpf_program *prog =3D &obj->programs[i];
> > +
> > +               if (prog_is_subprog(obj, prog))
> > +                       continue;
> > +               for (j =3D 0; j < prog->nr_reloc; j++) {
> > +                       struct reloc_desc *relo =3D &prog->reloc_desc[j=
];
> > +                       struct bpf_insn *insn =3D &prog->insns[relo->in=
sn_idx];
> > +                       struct extern_desc *ext;
> > +
> > +                       switch (relo->type) {
> > +                       case RELO_LD64:
> > +                               insn[0].src_reg =3D BPF_PSEUDO_MAP_FD;
> > +                               insn[0].imm =3D obj->maps[relo->map_idx=
].fd;
> > +                               break;
> > +                       case RELO_DATA:
> > +                               insn[0].src_reg =3D BPF_PSEUDO_MAP_VALU=
E;
> > +                               insn[0].imm =3D obj->maps[relo->map_idx=
].fd;
> > +                               break;
> > +                       case RELO_EXTERN_VAR:
> > +                               ext =3D &obj->externs[relo->sym_off];
> > +                               if (ext->type =3D=3D EXT_KCFG) {
> > +                                       insn[0].src_reg =3D BPF_PSEUDO_=
MAP_VALUE;
> > +                                       insn[0].imm =3D obj->maps[obj->=
kconfig_map_idx].fd;
> > +                               }
> > +                       default:
> > +                               break;
> > +                       }
> > +               }
> > +       }
> > +
> >         return 0;
> >  }
> >
> > @@ -6706,8 +6734,8 @@ bpf_object__load_progs(struct bpf_object *obj, in=
t log_level)
> >                 if (err)
> >                         return err;
> >         }
> > -       if (obj->gen_loader)
> > -               bpf_object__free_relocs(obj);
> > +
> > +       bpf_object__free_relocs(obj);
> >         return 0;
> >  }
> >
> > @@ -7258,6 +7286,39 @@ static int bpf_object__resolve_externs(struct bp=
f_object *obj,
> >         return 0;
> >  }
> >
> > +static int __bpf_object__prepare(struct bpf_object *obj, int log_level=
,
> > +                                const char *target_btf_path)
> > +{
> > +       int err;
> > +
> > +       if (obj->prepared) {
> > +               pr_warn("object '%s': prepare can't be attempted twice\=
n", obj->name);
> > +               return libbpf_err(-EINVAL);
> > +       }
> > +
> > +       if (obj->gen_loader)
> > +               bpf_gen__init(obj->gen_loader, log_level);
> > +
> > +       err =3D bpf_object__probe_loading(obj);
> > +       err =3D err ? : bpf_object__load_vmlinux_btf(obj, false);
> > +       err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
> > +       err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
> > +       err =3D err ? : bpf_object__sanitize_maps(obj);
> > +       err =3D err ? : bpf_object__init_kern_struct_ops_maps(obj);
> > +       err =3D err ? : bpf_object__relocate(obj, obj->btf_custom_path =
? : target_btf_path);
> > +
> > +       obj->prepared =3D true;
> > +
> > +       return err;
> > +}
> > +
> > +LIBBPF_API int bpf_object__prepare(struct bpf_object *obj)
> > +{
> > +       if (!obj)
> > +               return libbpf_err(-EINVAL);
> > +       return __bpf_object__prepare(obj, 0, NULL);
> > +}
> > +
> >  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
> >  {
> >         struct bpf_object *obj;
> > @@ -7274,17 +7335,14 @@ int bpf_object__load_xattr(struct bpf_object_lo=
ad_attr *attr)
> >                 return libbpf_err(-EINVAL);
> >         }
> >
> > -       if (obj->gen_loader)
> > -               bpf_gen__init(obj->gen_loader, attr->log_level);
> > +       if (!obj->prepared) {
> > +               err =3D __bpf_object__prepare(obj, attr->log_level, att=
r->target_btf_path);
> > +               if (err)
> > +                       return err;
> > +       }
> >
> > -       err =3D bpf_object__probe_loading(obj);
>
> After sending the patches we realized they weren't working without
> root privileges in systems with unprivileged BPF disabled. This line
> should not be moved to bpf_object__prepare indeed. We'll fix it in the
> next iteration.

It's not just probe_loading, loading BTF is also privileged. We need
to also think whether to really resolve externs and do other steps.
Non-weak externs might prevent BTFgen from working, if the intended
host kernel will have the extern, but the host on which you are
generating reduced BTF doesn't have such kernel symbol.

For BTFGen, keeping the amount of work done in preparation to a
minimum (which basically means load BTF and perform CO-RE
relocations), would probably be the simplest and also best.

Let me get back to reviewing this patch set tomorrow. It's pretty late
today, not the best time to do a thorough review.

>
>
> > -       err =3D err ? : bpf_object__load_vmlinux_btf(obj, false);
> > -       err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
> > -       err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
> > -       err =3D err ? : bpf_object__sanitize_maps(obj);
> > -       err =3D err ? : bpf_object__init_kern_struct_ops_maps(obj);
> > -       err =3D err ? : bpf_object__create_maps(obj);
> > -       err =3D err ? : bpf_object__relocate(obj, obj->btf_custom_path =
? : attr->target_btf_path);
> > +       err =3D bpf_object__create_maps(obj);
> > +       err =3D err ? : bpf_object__finish_relocate(obj);
> >         err =3D err ? : bpf_object__load_progs(obj, attr->log_level);
> >
> >         if (obj->gen_loader) {
> > @@ -7940,6 +7998,8 @@ void bpf_object__close(struct bpf_object *obj)
> >         bpf_object__elf_finish(obj);
> >         bpf_object_unload(obj);
> >         btf__free(obj->btf);
> > +       if (!obj->user_provided_btf_vmlinux)
> > +               btf__free(obj->btf_vmlinux_override);
> >         btf_ext__free(obj->btf_ext);
> >
> >         for (i =3D 0; i < obj->nr_maps; i++)
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 908ab04dc9bd..d206b4400a4d 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -148,6 +148,8 @@ LIBBPF_API int bpf_object__unpin_programs(struct bp=
f_object *obj,
> >  LIBBPF_API int bpf_object__pin(struct bpf_object *object, const char *=
path);
> >  LIBBPF_API void bpf_object__close(struct bpf_object *object);
> >
> > +LIBBPF_API int bpf_object__prepare(struct bpf_object *obj);
> > +
> >  struct bpf_object_load_attr {
> >         struct bpf_object *obj;
> >         int log_level;
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index c9555f8655af..459b41228933 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -415,4 +415,5 @@ LIBBPF_0.6.0 {
> >                 perf_buffer__new_raw;
> >                 perf_buffer__new_raw_deprecated;
> >                 btf__save_raw;
> > +               bpf_object__prepare;
> >  } LIBBPF_0.5.0;
> > --
> > 2.25.1
> >
