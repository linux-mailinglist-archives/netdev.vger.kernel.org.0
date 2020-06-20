Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5B1201F66
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 03:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgFTBJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 21:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbgFTBJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 21:09:00 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78534C0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:08:59 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 9so10970557ilg.12
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tH/+Wlgsua3/zgz9qNBadm0jkyoBkabEqj/mrgP1L4E=;
        b=Ei8OSnRyRFumSI4ROsUUYHxbIGZkYs0jPk9ChSdOc82kcfMnHcVx4xcZj/qtbGAOhX
         nTFyGojqYq8OXCI12J4cAiilW9/u2VucPPaHQUKD2OE5ybYpksUPhTow7BNOnTeWj+1w
         i3/SuC0Adx8f8FICoq7MzvTWC/CMp2BABUR907GmmP467g4r/LXgswvDO77i8dEdyBSy
         SxSkzHqQ8fwfHcrLxjCrMwbubd7cMRJRlZUQjvkCKBwPtrCwWvB33BfIOxxZBexILr1M
         GtIaB1agMOpNmS9UEllpF/pMTpaXy59h6cVcaRPawnzRa6BSlxs8CGQEOgf3v2zur29p
         L1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tH/+Wlgsua3/zgz9qNBadm0jkyoBkabEqj/mrgP1L4E=;
        b=eRskILEYeUGU/4I7NtlkUAB1GR3ELpSCdtzh5S0ro1IcxgEXsrHbiI2w4ifbNCZwXZ
         Vi1b0oqhEhuk6ufwo+jmMEzba7FJ5TyCsGKhPd94cydMccp4sY9AqEYVGlGmkIuVmGZY
         U5AgfRDOVcFOseeMF5glclb6IX5SfF5F5Ox4avG3NjAC8GbbgcfEJEMBzVM8GvmbisAB
         5kKI/LImuDWUGvaQZKqTgBxbmLdBGxhGKHvUGlqLvPndBsmishCDB8qaN9Hc5OypWEhy
         /IIEA6qEBG3AGOdN22JhBzS8sJZec5GAW93ooERsUJQwLibmz8kZfuNsPlJTd6/5vD+U
         bH5A==
X-Gm-Message-State: AOAM5300Yw7KJZo2FxP6EIuEcjmxcr/X6H/3nHiQ9W1WiAOuuJfp0XVb
        9nt6WFY1B+MJ6y5MPkRaptUULaVDN8WJqL8xoK6lfg==
X-Google-Smtp-Source: ABdhPJwhKnwb2jv8rnqROVlgFGT0vXx8E9O+g9hyeeDdYztPCVfoORvVzZYufH5QJMErQKWnBKwtnIGRLgQYrb1x48A=
X-Received: by 2002:a05:6e02:50c:: with SMTP id d12mr6133265ils.140.1592615338168;
 Fri, 19 Jun 2020 18:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200619231703.738941-1-andriin@fb.com> <20200619231703.738941-3-andriin@fb.com>
In-Reply-To: <20200619231703.738941-3-andriin@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 19 Jun 2020 18:08:47 -0700
Message-ID: <CA+khW7gFPANqsmPOB1orhvqWEAqPM9q99++=a2+smUXhHGLKcw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: add support for extracting kernel
 symbol addresses
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Hao Luo <haoluo@google.com>


On Fri, Jun 19, 2020 at 4:19 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add support for another (in addition to existing Kconfig) special kind of
> externs in BPF code, kernel symbol externs. Such externs allow BPF code to
> "know" kernel symbol address and either use it for comparisons with kernel
> data structures (e.g., struct file's f_op pointer, to distinguish different
> kinds of file), or, with the help of bpf_probe_user_kernel(), to follow
> pointers and read data from global variables. Kernel symbol addresses are
> found through /proc/kallsyms, which should be present in the system.
>
> Currently, such kernel symbol variables are typeless: they have to be defined
> as `extern const void <symbol>` and the only operation you can do (in C code)
> with them is to take its address. Such extern should reside in a special
> section '.ksyms'. bpf_helpers.h header provides __ksym macro for this. Strong
> vs weak semantics stays the same as with Kconfig externs. If symbol is not
> found in /proc/kallsyms, this will be a failure for strong (non-weak) extern,
> but will be defaulted to 0 for weak externs.
>
> If the same symbol is defined multiple times in /proc/kallsyms, then it will
> be error if any of the associated addresses differs. In that case, address is
> ambiguous, so libbpf falls on the side of caution, rather than confusing user
> with randomly chosen address.
>
> In the future, once kernel is extended with variables BTF information, such
> ksym externs will be supported in a typed version, which will allow BPF
> program to read variable's contents directly, similarly to how it's done for
> fentry/fexit input arguments.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h |   1 +
>  tools/lib/bpf/btf.h         |   5 ++
>  tools/lib/bpf/libbpf.c      | 144 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 144 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index f67dce2af802..a510d8ed716f 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -75,5 +75,6 @@ enum libbpf_tristate {
>  };
>
>  #define __kconfig __attribute__((section(".kconfig")))
> +#define __ksym __attribute__((section(".ksyms")))
>
>  #endif
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 70c1b7ec2bd0..06cd1731c154 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -168,6 +168,11 @@ static inline bool btf_kflag(const struct btf_type *t)
>         return BTF_INFO_KFLAG(t->info);
>  }
>
> +static inline bool btf_is_void(const struct btf_type *t)
> +{
> +       return btf_kind(t) == BTF_KIND_UNKN;
> +}
> +
>  static inline bool btf_is_int(const struct btf_type *t)
>  {
>         return btf_kind(t) == BTF_KIND_INT;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4b021cb94e48..3fabc530290f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -285,6 +285,7 @@ struct bpf_struct_ops {
>  #define BSS_SEC ".bss"
>  #define RODATA_SEC ".rodata"
>  #define KCONFIG_SEC ".kconfig"
> +#define KSYMS_SEC ".ksyms"
>  #define STRUCT_OPS_SEC ".struct_ops"
>
>  enum libbpf_map_type {
> @@ -330,6 +331,7 @@ struct bpf_map {
>  enum extern_type {
>         EXT_UNKNOWN,
>         EXT_KCFG,
> +       EXT_KSYM,
>  };
>
>  enum kcfg_type {
> @@ -357,6 +359,9 @@ struct extern_desc {
>                         int data_off;
>                         bool is_signed;
>                 } kcfg;
> +               struct {
> +                       unsigned long long addr;
> +               } ksym;
>         };
>  };
>
> @@ -2812,9 +2817,25 @@ static int cmp_externs(const void *_a, const void *_b)
>         return strcmp(a->name, b->name);
>  }
>
> +static int find_int_btf_id(const struct btf *btf)
> +{
> +       const struct btf_type *t;
> +       int i, n;
> +
> +       n = btf__get_nr_types(btf);
> +       for (i = 1; i <= n; i++) {
> +               t = btf__type_by_id(btf, i);
> +
> +               if (btf_is_int(t) && btf_int_bits(t) == 32)
> +                       return i;
> +       }
> +
> +       return 0;
> +}
> +
>  static int bpf_object__collect_externs(struct bpf_object *obj)
>  {
> -       struct btf_type *sec, *kcfg_sec = NULL;
> +       struct btf_type *sec, *kcfg_sec = NULL, *ksym_sec = NULL;
>         const struct btf_type *t;
>         struct extern_desc *ext;
>         int i, n, off;
> @@ -2895,6 +2916,17 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>                                 pr_warn("extern (kcfg) '%s' type is unsupported\n", ext_name);
>                                 return -ENOTSUP;
>                         }
> +               } else if (strcmp(sec_name, KSYMS_SEC) == 0) {
> +                       const struct btf_type *vt;
> +
> +                       ksym_sec = sec;
> +                       ext->type = EXT_KSYM;
> +
> +                       vt = skip_mods_and_typedefs(obj->btf, t->type, NULL);
> +                       if (!btf_is_void(vt)) {
> +                               pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
> +                               return -ENOTSUP;
> +                       }
>                 } else {
>                         pr_warn("unrecognized extern section '%s'\n", sec_name);
>                         return -ENOTSUP;
> @@ -2908,6 +2940,46 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>         /* sort externs by type, for kcfg ones also by (align, size, name) */
>         qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
>
> +       /* for .ksyms section, we need to turn all externs into allocated
> +        * variables in BTF to pass kernel verification; we do this by
> +        * pretending that each extern is a 8-byte variable
> +        */
> +       if (ksym_sec) {
> +               /* find existing 4-byte integer type in BTF to use for fake
> +                * extern variables in DATASEC
> +                */
> +               int int_btf_id = find_int_btf_id(obj->btf);
> +
> +               for (i = 0; i < obj->nr_extern; i++) {
> +                       ext = &obj->externs[i];
> +                       if (ext->type != EXT_KSYM)
> +                               continue;
> +                       pr_debug("extern (ksym) #%d: symbol %d, name %s\n",
> +                                i, ext->sym_idx, ext->name);
> +               }
> +
> +               sec = ksym_sec;
> +               n = btf_vlen(sec);
> +               for (i = 0, off = 0; i < n; i++, off += sizeof(int)) {
> +                       struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
> +                       struct btf_type *vt;
> +
> +                       vt = (void *)btf__type_by_id(obj->btf, vs->type);
> +                       ext_name = btf__name_by_offset(obj->btf, vt->name_off);
> +                       ext = find_extern_by_name(obj, ext_name);
> +                       if (!ext) {
> +                               pr_warn("failed to find extern definition for BTF var '%s'\n",
> +                                       ext_name);
> +                               return -ESRCH;
> +                       }
> +                       btf_var(vt)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
> +                       vt->type = int_btf_id;
> +                       vs->offset = off;
> +                       vs->size = sizeof(int);
> +               }
> +               sec->size = off;
> +       }
> +
>         if (kcfg_sec) {
>                 sec = kcfg_sec;
>                 /* for kcfg externs calculate their offsets within a .kconfig map */
> @@ -2919,7 +2991,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>
>                         ext->kcfg.data_off = roundup(off, ext->kcfg.align);
>                         off = ext->kcfg.data_off + ext->kcfg.sz;
> -                       pr_debug("extern #%d (kcfg): symbol %d, off %u, name %s\n",
> +                       pr_debug("extern (kcfg) #%d: symbol %d, off %u, name %s\n",
>                                  i, ext->sym_idx, ext->kcfg.data_off, ext->name);
>                 }
>                 sec->size = off;
> @@ -5009,9 +5081,14 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
>                         break;
>                 case RELO_EXTERN:
>                         ext = &obj->externs[relo->sym_off];
> -                       insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
> -                       insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
> -                       insn[1].imm = ext->kcfg.data_off;
> +                       if (ext->type == EXT_KCFG) {
> +                               insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
> +                               insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
> +                               insn[1].imm = ext->kcfg.data_off;
> +                       } else /* EXT_KSYM */ {
> +                               insn[0].imm = (__u32)ext->ksym.addr;
> +                               insn[1].imm = ext->ksym.addr >> 32;
> +                       }
>                         break;
>                 case RELO_CALL:
>                         err = bpf_program__reloc_text(prog, obj, relo);
> @@ -5630,10 +5707,58 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
>         return 0;
>  }
>
> +static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> +{
> +       char sym_type, sym_name[500];
> +       unsigned long long sym_addr;
> +       struct extern_desc *ext;
> +       int ret, err = 0;
> +       FILE *f;
> +
> +       f = fopen("/proc/kallsyms", "r");
> +       if (!f) {
> +               err = -errno;
> +               pr_warn("failed to open /proc/kallsyms: %d\n", err);
> +               return err;
> +       }
> +
> +       while (true) {
> +               ret = fscanf(f, "%llx %c %499s%*[^\n]\n",
> +                            &sym_addr, &sym_type, sym_name);
> +               if (ret == EOF && feof(f))
> +                       break;
> +               if (ret != 3) {
> +                       pr_warn("failed to read kallasyms entry: %d\n", ret);
> +                       err = -EINVAL;
> +                       goto out;
> +               }
> +
> +               ext = find_extern_by_name(obj, sym_name);
> +               if (!ext || ext->type != EXT_KSYM)
> +                       continue;
> +
> +               if (ext->is_set && ext->ksym.addr != sym_addr) {
> +                       pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
> +                               sym_name, ext->ksym.addr, sym_addr);
> +                       err = -EINVAL;
> +                       goto out;
> +               }
> +               if (!ext->is_set) {
> +                       ext->is_set = true;
> +                       ext->ksym.addr = sym_addr;
> +                       pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
> +               }
> +       }
> +
> +out:
> +       fclose(f);
> +       return err;
> +}
> +
>  static int bpf_object__resolve_externs(struct bpf_object *obj,
>                                        const char *extra_kconfig)
>  {
> -       bool need_config = false;
> +       bool need_config = false, need_kallsyms = false;
>         struct extern_desc *ext;
>         void *kcfg_data = NULL;
>         int err, i;
> @@ -5663,6 +5788,8 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
>                 } else if (ext->type == EXT_KCFG &&
>                            strncmp(ext->name, "CONFIG_", 7) == 0) {
>                         need_config = true;
> +               } else if (ext->type == EXT_KSYM) {
> +                       need_kallsyms = true;
>                 } else {
>                         pr_warn("unrecognized extern '%s'\n", ext->name);
>                         return -EINVAL;
> @@ -5686,6 +5813,11 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
>                 if (err)
>                         return -EINVAL;
>         }
> +       if (need_kallsyms) {
> +               err = bpf_object__read_kallsyms_file(obj);
> +               if (err)
> +                       return -EINVAL;
> +       }
>         for (i = 0; i < obj->nr_extern; i++) {
>                 ext = &obj->externs[i];
>
> --
> 2.24.1
>
