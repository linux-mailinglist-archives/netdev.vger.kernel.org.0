Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925903424E7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCSSj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhCSSjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:39:13 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D244C06174A;
        Fri, 19 Mar 2021 11:39:13 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o83so7305340ybg.1;
        Fri, 19 Mar 2021 11:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oECfPVWZh88FdDeweITHIouwjzeldtTpzGePira8Ucg=;
        b=Nva22x3T0stY9HEci3Ps9OHRXjUPdSFSDa6dEZti4/i5OCCmliQ3Ibc6zl3rUIq3KH
         o76ii4xKP8oiwa9UouR7NORfF0ySWCcvFq8MwUeORULGGWP1356i1G2BUcjU9ZUWYc9A
         psFP+0ibkNVYp+HgBG2L1N5SM5A2qnZw2RekBRaHNoxBBpfEDYlOal4/eIZK+mjLJJCv
         HLJofxZasfo23S4Z6aVW3mcx5nYX3MnF5V+G9MMgqkZdvxe70UozNi28S6k9Cbr+pHwp
         ozweqqG35mFgD+6D+1nF1Ensx3L5FDxEQsY5wVKLYHFGKPCQh+lfYG2IGUOy54RBeCDh
         Gofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oECfPVWZh88FdDeweITHIouwjzeldtTpzGePira8Ucg=;
        b=msapWhSfDzePxl0NGTSEVxXFCjC7xOMJI8l83VdznxRUxyiWnXvCch36mMGyzODUyr
         5MkGmVuDEPWomQQcJV4qi8kTv6JDKrgt1F4i6MiuP2b9crGtE6IFVeog4Q29LsOnTI3p
         UeO1NPD51Fo7hBUVmmfSuQ9TjNhp7bcQLxBVBDeFuYxKqXjcMX9Kx2Yi4V0CzOF/W2+J
         9TitsMqGK7ZUdl600/kahXeX4c+pMiHUSVruRhGs91z6wyeVQB2o+JrI9Ray1EUq6Kv1
         JU0RM0va0l1qNG6i3JYsrAfEg3KATqXahIH8uQANv1V2K1ufOlGZgG9A0OytwFKeZWre
         ejJQ==
X-Gm-Message-State: AOAM531z6V1R3B1ZGCFPjMlsJFCeJUePKP8z65WDuwqLL8+uk5OtdC9V
        JFheNrANEzQyrE8RIObMBWdritisIbxHaadWkAs=
X-Google-Smtp-Source: ABdhPJwXsTDjC6gYPn7/4fQFUECymKwZL1FjAuvwhRp/zAi+cF592gSHW2+UAbMOFw3ZqG1IF5m80r7swrCZeDQTTXg=
X-Received: by 2002:a25:74cb:: with SMTP id p194mr8386232ybc.347.1616179152532;
 Fri, 19 Mar 2021 11:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210318194036.3521577-1-andrii@kernel.org> <20210318194036.3521577-8-andrii@kernel.org>
 <YFTQExmhNhMcmNOb@krava>
In-Reply-To: <YFTQExmhNhMcmNOb@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Mar 2021 11:39:01 -0700
Message-ID: <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 9:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
> > +
> > +     return NULL;
> > +}
> > +
> > +static int linker_fixup_btf(struct src_obj *obj)
> > +{
> > +     const char *sec_name;
> > +     struct src_sec *sec;
> > +     int i, j, n, m;
> > +
> > +     n = btf__get_nr_types(obj->btf);
>
> hi,
> I'm getting bpftool crash when building tests,
>
> looks like above obj->btf can be NULL:

I lost if (!obj->btf) return 0; somewhere along the rebases. I'll send
a fix shortly. But how did you end up with selftests BPF objects built
without BTF?

>
>         (gdb) r gen object /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.linked1.o /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o
>         Starting program: /home/jolsa/linux/tools/testing/selftests/bpf/tools/sbin/bpftool gen object /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.linked1.o /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o
>
>         Program received signal SIGSEGV, Segmentation fault.
>         btf__get_nr_types (btf=0x0) at btf.c:425
>
>         425             return btf->start_id + btf->nr_types - 1;
>         Missing separate debuginfos, use: dnf debuginfo-install elfutils-libelf-0.182-1.fc33.x86_64 libcap-2.48-2.fc33.x86_64 zlib-1.2.11-23.fc33.x86_64
>         (gdb)
>         (gdb) bt
>         #0  btf__get_nr_types (btf=0x0) at btf.c:425
>         #1  0x000000000043c4ba in linker_fixup_btf (obj=obj@entry=0x7fffffffda50) at linker.c:1316
>         #2  0x000000000043caf7 in linker_load_obj_file (linker=linker@entry=0x8612a0, filename=filename@entry=0x7fffffffe0db "/home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o",
>             obj=obj@entry=0x7fffffffda50) at linker.c:653
>         #3  0x000000000043df43 in bpf_linker__add_file (linker=linker@entry=0x8612a0, filename=filename@entry=0x7fffffffe0db "/home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o") at linker.c:412
>         #4  0x000000000040d710 in do_object (argc=0, argv=0x7fffffffdce0) at gen.c:639
>         #5  0x000000000040efd7 in cmd_select (cmds=cmds@entry=0x50a600 <cmds>, argc=3, argv=0x7fffffffdcc8, help=help@entry=0x40c6f7 <do_help>) at main.c:134
>         #6  0x000000000040d7c4 in do_gen (argc=<optimized out>, argv=<optimized out>) at gen.c:686
>         #7  0x000000000040efd7 in cmd_select (cmds=cmds@entry=0x50b400 <cmds>, argc=4, argv=0x7fffffffdcc0, help=help@entry=0x40ee93 <do_help>) at main.c:134
>         #8  0x000000000040f88e in main (argc=<optimized out>, argv=<optimized out>) at main.c:469
>
> I'm on current bpf-next/master
>
>
> jirka
>
>
> > +     for (i = 1; i <= n; i++) {
> > +             struct btf_var_secinfo *vi;
> > +             struct btf_type *t;
> > +
> > +             t = btf_type_by_id(obj->btf, i);
> > +             if (btf_kind(t) != BTF_KIND_DATASEC)
> > +                     continue;
> > +
> > +             sec_name = btf__str_by_offset(obj->btf, t->name_off);
> > +             sec = find_src_sec_by_name(obj, sec_name);
> > +             if (sec) {
> > +                     /* record actual section size, unless ephemeral */
> > +                     if (sec->shdr)
> > +                             t->size = sec->shdr->sh_size;
> > +             } else {
> > +                     /* BTF can have some sections that are not represented
> > +                      * in ELF, e.g., .kconfig and .ksyms, which are used
> > +                      * for special extern variables.  Here we'll
> > +                      * pre-create "section shells" for them to be able to
> > +                      * keep track of extra per-section metadata later
> > +                      * (e.g., BTF variables).
> > +                      */
> > +                     sec = add_src_sec(obj, sec_name);
> > +                     if (!sec)
> > +                             return -ENOMEM;
> > +
> > +                     sec->ephemeral = true;
> > +                     sec->sec_idx = 0; /* will match UNDEF shndx in ELF */
> > +             }
> > +
> > +             /* remember ELF section and its BTF type ID match */
> > +             sec->sec_type_id = i;
> > +
> > +             /* fix up variable offsets */
> > +             vi = btf_var_secinfos(t);
> > +             for (j = 0, m = btf_vlen(t); j < m; j++, vi++) {
> > +                     const struct btf_type *vt = btf__type_by_id(obj->btf, vi->type);
> > +                     const char *var_name = btf__str_by_offset(obj->btf, vt->name_off);
> > +                     int var_linkage = btf_var(vt)->linkage;
> > +                     Elf64_Sym *sym;
> > +
> > +                     /* no need to patch up static or extern vars */
> > +                     if (var_linkage != BTF_VAR_GLOBAL_ALLOCATED)
> > +                             continue;
> > +
> > +                     sym = find_sym_by_name(obj, sec->sec_idx, STT_OBJECT, var_name);
> > +                     if (!sym) {
> > +                             pr_warn("failed to find symbol for variable '%s' in section '%s'\n", var_name, sec_name);
> > +                             return -ENOENT;
> > +                     }
> > +
> > +                     vi->offset = sym->st_value;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
>
> SNIP
>
