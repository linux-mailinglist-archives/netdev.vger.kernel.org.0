Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0355036BBA0
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 00:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhDZWXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 18:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhDZWXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 18:23:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13690C061574;
        Mon, 26 Apr 2021 15:22:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p3so46230003ybk.0;
        Mon, 26 Apr 2021 15:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uApJ4Az0WAc6mY6+NWHbgkgY6OV/jWjul/4lDjfRdOQ=;
        b=G+Y3gMFout9EmOJDOTvLTuo3KcDZsejLFdQVe5d/vtEEufDix/Y9aOP7tLtZZGxZHZ
         3fRvjB5wuYrAlfCBYsGySTzAWHKG1BeJTmxHBvw1yNe2VRCbQFFZ/PfChSCi+KTkSpTW
         NpiDlRUmBdzJAHiYRMUzIOJkE4jCT9pFx6s7JX9ua77Z/RRRQTbSIJPFHQeObST97ZyL
         wkivDQ9FQDaKRR+sHPRVL1Mj2GjZPZ/5asFREMHy4PsCpSIyxe3/3jIIduFLxT4ah7u/
         EKeUROI3NrD1udcjnleY5oWE3FwclpnCZCRnOQRHznT33YURql+XEgDYVeL1v8C5qVUt
         aS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uApJ4Az0WAc6mY6+NWHbgkgY6OV/jWjul/4lDjfRdOQ=;
        b=KJ+U/+KFXJA+HoyLlYS4wyDDhpLwQWuy0TYl7CJLJ2C67MtMEx9NNv8zCLysfpR847
         GtXDE57KtWSiLzJRVMq/7R0iIpJUYhKSd17YDUScb67hfgXjsxwL5XwSXpFMChtTAQ6V
         8si9kTev0vW2AmI0iE1S6PbmxwyWl8wDZqQbmMfxplA9Mq14mDpvop3iG2xPfJDz4PRR
         eNq0n3Xf9J+ObjZMuoZiqhdqi+aPuNS1p6OOU8ZFsQv9ws38l6t3tLp6x/bDnh6LgO15
         B10IyJrTsqHzmSbNWyTV+UoFRuWwgQ2zx2SJA8xUHHMRf2elvR1phc8bfncrSv6If9+l
         6pXw==
X-Gm-Message-State: AOAM531CEFgDK8X4RcyEgdTLd9p1GBETVIEM2jb7St+03F0p6rlianQs
        tKacfqqzirqdnOX/ger3hqthHmL9ilsgcUgd4pc=
X-Google-Smtp-Source: ABdhPJzNEMJqfHW/f7z1N5aVI8fbn7f+tDwt3+0hR1+W8dVwToo90OYVSlqfWA2zv4vcQDlHFVCJ8U1YWb/rib/Emo8=
X-Received: by 2002:a25:2441:: with SMTP id k62mr27317034ybk.347.1619475767184;
 Mon, 26 Apr 2021 15:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-15-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-15-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 15:22:36 -0700
Message-ID: <CAEf4BzaQb=_aOL26syfsUWA9ewi6xOC1frzP27cOWz=_5Cz1iA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 14/16] libbpf: Generate loader program out of
 BPF ELF file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The BPF program loading process performed by libbpf is quite complex
> and consists of the following steps:
> "open" phase:
> - parse elf file and remember relocations, sections
> - collect externs and ksyms including their btf_ids in prog's BTF
> - patch BTF datasec (since llvm couldn't do it)
> - init maps (old style map_def, BTF based, global data map, kconfig map)
> - collect relocations against progs and maps
> "load" phase:
> - probe kernel features
> - load vmlinux BTF
> - resolve externs (kconfig and ksym)
> - load program BTF
> - init struct_ops
> - create maps
> - apply CO-RE relocations
> - patch ld_imm64 insns with src_reg=PSEUDO_MAP, PSEUDO_MAP_VALUE, PSEUDO_BTF_ID
> - reposition subprograms and adjust call insns
> - sanitize and load progs
>
> During this process libbpf does sys_bpf() calls to load BTF, create maps,
> populate maps and finally load programs.
> Instead of actually doing the syscalls generate a trace of what libbpf
> would have done and represent it as the "loader program".
> The "loader program" consists of single map with:
> - union bpf_attr(s)
> - BTF bytes
> - map value bytes
> - insns bytes
> and single bpf program that passes bpf_attr(s) and data into bpf_sys_bpf() helper.
> Executing such "loader program" via bpf_prog_test_run() command will
> replay the sequence of syscalls that libbpf would have done which will result
> the same maps created and programs loaded as specified in the elf file.
> The "loader program" removes libelf and majority of libbpf dependency from
> program loading process.
>
> kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.
>
> The order of relocate_data and relocate_calls had to change, so that
> bpf_gen__prog_load() can see all relocations for a given program with
> correct insn_idx-es.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/Build              |   2 +-
>  tools/lib/bpf/bpf_gen_internal.h |  40 ++
>  tools/lib/bpf/gen_loader.c       | 615 +++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.c           | 204 ++++++++--
>  tools/lib/bpf/libbpf.h           |  12 +
>  tools/lib/bpf/libbpf.map         |   1 +
>  tools/lib/bpf/libbpf_internal.h  |   2 +
>  tools/lib/bpf/skel_internal.h    | 105 ++++++
>  8 files changed, 948 insertions(+), 33 deletions(-)
>  create mode 100644 tools/lib/bpf/bpf_gen_internal.h
>  create mode 100644 tools/lib/bpf/gen_loader.c
>  create mode 100644 tools/lib/bpf/skel_internal.h
>
> diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
> index 9b057cc7650a..430f6874fa41 100644
> --- a/tools/lib/bpf/Build
> +++ b/tools/lib/bpf/Build
> @@ -1,3 +1,3 @@
>  libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
>             netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
> -           btf_dump.o ringbuf.o strset.o linker.o
> +           btf_dump.o ringbuf.o strset.o linker.o gen_loader.o
> diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
> new file mode 100644
> index 000000000000..dc3e2cbf9ce3
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_gen_internal.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +/* Copyright (c) 2021 Facebook */
> +#ifndef __BPF_GEN_INTERNAL_H
> +#define __BPF_GEN_INTERNAL_H
> +
> +struct relo_desc {

there is very similarly named reloc_desc struct in libbpf.c, can you
rename it to something like gen_btf_relo_desc?

> +       const char *name;
> +       int kind;
> +       int insn_idx;
> +};
> +

[...]

> +
> +static int bpf_gen__realloc_insn_buf(struct bpf_gen *gen, __u32 size)
> +{
> +       size_t off = gen->insn_cur - gen->insn_start;
> +
> +       if (gen->error)
> +               return gen->error;
> +       if (size > INT32_MAX || off + size > INT32_MAX) {
> +               gen->error = -ERANGE;
> +               return -ERANGE;
> +       }
> +       gen->insn_start = realloc(gen->insn_start, off + size);

leaking memory here: gen->insn_start will be NULL on failure

> +       if (!gen->insn_start) {
> +               gen->error = -ENOMEM;
> +               return -ENOMEM;
> +       }
> +       gen->insn_cur = gen->insn_start + off;
> +       return 0;
> +}
> +
> +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
> +{
> +       size_t off = gen->data_cur - gen->data_start;
> +
> +       if (gen->error)
> +               return gen->error;
> +       if (size > INT32_MAX || off + size > INT32_MAX) {
> +               gen->error = -ERANGE;
> +               return -ERANGE;
> +       }
> +       gen->data_start = realloc(gen->data_start, off + size);

same as above

> +       if (!gen->data_start) {
> +               gen->error = -ENOMEM;
> +               return -ENOMEM;
> +       }
> +       gen->data_cur = gen->data_start + off;
> +       return 0;
> +}
> +

[...]

> +
> +static void bpf_gen__emit_sys_bpf(struct bpf_gen *gen, int cmd, int attr, int attr_size)
> +{
> +       bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_1, cmd));
> +       bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, attr));

is attr an offset into a blob? if yes, attr_off? or attr_base_off,
anything with _off

> +       bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_3, attr_size));
> +       bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_bpf));
> +       /* remember the result in R7 */
> +       bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
> +}
> +
> +static void bpf_gen__emit_check_err(struct bpf_gen *gen)
> +{
> +       bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 2));
> +       bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_7));
> +       bpf_gen__emit(gen, BPF_EXIT_INSN());
> +}
> +
> +static void __bpf_gen__debug(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, va_list args)

Can you please leave a comment on what reg1 and reg2 is, it's not very
clear and the code clearly assumes that it can't be reg[1-4]. It's
probably those special R7 and R9 (or -1, of course), but having a
short comment makes sense to not jump around trying to figure out
possible inputs.

Oh, reading further, it can also be R0.

> +{
> +       char buf[1024];
> +       int addr, len, ret;
> +
> +       if (!gen->log_level)
> +               return;
> +       ret = vsnprintf(buf, sizeof(buf), fmt, args);
> +       if (ret < 1024 - 7 && reg1 >= 0 && reg2 < 0)
> +               /* The special case to accommodate common bpf_gen__debug_ret():
> +                * to avoid specifying BPF_REG_7 and adding " r=%%d" to prints explicitly.
> +                */
> +               strcat(buf, " r=%d");
> +       len = strlen(buf) + 1;
> +       addr = bpf_gen__add_data(gen, buf, len);

nit: offset, not address, right?

> +
> +       bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, addr));
> +       bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
> +       if (reg1 >= 0)
> +               bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_3, reg1));
> +       if (reg2 >= 0)
> +               bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, reg2));
> +       bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));
> +}
> +

[...]

> +int bpf_gen__finish(struct bpf_gen *gen)
> +{
> +       int i;
> +
> +       bpf_gen__emit_sys_close_stack(gen, stack_off(btf_fd));
> +       for (i = 0; i < gen->nr_progs; i++)
> +               bpf_gen__move_stack2ctx(gen,
> +                                       sizeof(struct bpf_loader_ctx) +
> +                                       sizeof(struct bpf_map_desc) * gen->nr_maps +
> +                                       sizeof(struct bpf_prog_desc) * i +
> +                                       offsetof(struct bpf_prog_desc, prog_fd), 4,
> +                                       stack_off(prog_fd[i]));
> +       for (i = 0; i < gen->nr_maps; i++)
> +               bpf_gen__move_stack2ctx(gen,
> +                                       sizeof(struct bpf_loader_ctx) +
> +                                       sizeof(struct bpf_map_desc) * i +
> +                                       offsetof(struct bpf_map_desc, map_fd), 4,
> +                                       stack_off(map_fd[i]));
> +       bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
> +       bpf_gen__emit(gen, BPF_EXIT_INSN());
> +       pr_debug("bpf_gen__finish %d\n", gen->error);

maybe prefix all those pr_debug()s with "gen: " to distinguish them
from the rest of libbpf logging?

> +       if (!gen->error) {
> +               struct gen_loader_opts *opts = gen->opts;
> +
> +               opts->insns = gen->insn_start;
> +               opts->insns_sz = gen->insn_cur - gen->insn_start;
> +               opts->data = gen->data_start;
> +               opts->data_sz = gen->data_cur - gen->data_start;
> +       }
> +       return gen->error;
> +}
> +
> +void bpf_gen__free(struct bpf_gen *gen)
> +{
> +       if (!gen)
> +               return;
> +       free(gen->data_start);
> +       free(gen->insn_start);
> +       gen->data_start = NULL;
> +       gen->insn_start = NULL;

what's the point of NULL'ing them out if you don't clear gen->data_cur
and gen->insn_cur?

also should it free(gen) itself?

> +}
> +
> +void bpf_gen__load_btf(struct bpf_gen *gen, const void *btf_raw_data, __u32 btf_raw_size)
> +{
> +       union bpf_attr attr = {};

here and below: memset(0)?

> +       int attr_size = offsetofend(union bpf_attr, btf_log_level);
> +       int btf_data, btf_load_attr;
> +
> +       pr_debug("btf_load: size %d\n", btf_raw_size);
> +       btf_data = bpf_gen__add_data(gen, btf_raw_data, btf_raw_size);
> +

[...]

> +       map_create_attr = bpf_gen__add_data(gen, &attr, attr_size);
> +       if (attr.btf_value_type_id)
> +               /* populate union bpf_attr with btf_fd saved in the stack earlier */
> +               bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, btf_fd), 4,
> +                                        stack_off(btf_fd));
> +       switch (attr.map_type) {
> +       case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> +       case BPF_MAP_TYPE_HASH_OF_MAPS:
> +               bpf_gen__move_stack2blob(gen, map_create_attr + offsetof(union bpf_attr, inner_map_fd),
> +                                        4, stack_off(inner_map_fd));
> +               close_inner_map_fd = true;
> +               break;
> +       default:;

default:
    break;

> +       }
> +       /* emit MAP_CREATE command */
> +       bpf_gen__emit_sys_bpf(gen, BPF_MAP_CREATE, map_create_attr, attr_size);
> +       bpf_gen__debug_ret(gen, "map_create %s idx %d type %d value_size %d",
> +                          attr.map_name, map_idx, map_attr->map_type, attr.value_size);
> +       bpf_gen__emit_check_err(gen);

what will happen on error with inner_map_fd and all the other fds
created by now?

> +       /* remember map_fd in the stack, if successful */
> +       if (map_idx < 0) {
> +               /* This bpf_gen__map_create() function is called with map_idx >= 0 for all maps
> +                * that libbpf loading logic tracks.
> +                * It's called with -1 to create an inner map.
> +                */
> +               bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(inner_map_fd)));
> +       } else {
> +               if (map_idx != gen->nr_maps) {

why would that happen? defensive programming? and even then `if () {}
else if () {} else {}` structure is more appropriate

> +                       gen->error = -EDOM; /* internal bug */
> +                       return;
> +               }
> +               bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(map_fd[map_idx])));
> +               gen->nr_maps++;
> +       }
> +       if (close_inner_map_fd)
> +               bpf_gen__emit_sys_close_stack(gen, stack_off(inner_map_fd));
> +}
> +

[...]

> +static void bpf_gen__cleanup_relos(struct bpf_gen *gen, int insns)
> +{
> +       int i, insn;
> +
> +       for (i = 0; i < gen->relo_cnt; i++) {
> +               if (gen->relos[i].kind != BTF_KIND_VAR)
> +                       continue;
> +               /* close fd recorded in insn[insn_idx + 1].imm */
> +               insn = insns + sizeof(struct bpf_insn) * (gen->relos[i].insn_idx + 1)
> +                       + offsetof(struct bpf_insn, imm);
> +               bpf_gen__emit_sys_close_blob(gen, insn);

wouldn't this close the same FD used across multiple "relos" multiple times?

> +       }
> +       if (gen->relo_cnt) {
> +               free(gen->relos);
> +               gen->relo_cnt = 0;
> +               gen->relos = NULL;
> +       }
> +}
> +

[...]

> +       struct bpf_gen *gen_loader;
> +
>         /*
>          * Information when doing elf related work. Only valid if fd
>          * is valid.
> @@ -2651,7 +2654,15 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
>                 bpf_object__sanitize_btf(obj, kern_btf);
>         }
>
> -       err = btf__load(kern_btf);
> +       if (obj->gen_loader) {
> +               __u32 raw_size = 0;
> +               const void *raw_data = btf__get_raw_data(kern_btf, &raw_size);

this can return NULL on ENOMEM

> +
> +               bpf_gen__load_btf(obj->gen_loader, raw_data, raw_size);
> +               btf__set_fd(kern_btf, 0);

why setting fd to 0 (stdin)? does gen depend on this somewhere? The
problem is that it will eventually be closed on btf__free(), which
will close stdin, causing a big surprise. What will happen if you
leave it at -1?


> +       } else {
> +               err = btf__load(kern_btf);
> +       }
>         if (sanitize) {
>                 if (!err) {
>                         /* move fd to libbpf's BTF */
> @@ -4262,6 +4273,12 @@ static bool kernel_supports(const struct bpf_object *obj, enum kern_feature_id f
>         struct kern_feature_desc *feat = &feature_probes[feat_id];
>         int ret;
>
> +       if (obj->gen_loader)
> +               /* To generate loader program assume the latest kernel
> +                * to avoid doing extra prog_load, map_create syscalls.
> +                */
> +               return true;
> +
>         if (READ_ONCE(feat->res) == FEAT_UNKNOWN) {
>                 ret = feat->probe();
>                 if (ret > 0) {
> @@ -4344,6 +4361,13 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
>         char *cp, errmsg[STRERR_BUFSIZE];
>         int err, zero = 0;
>
> +       if (obj->gen_loader) {
> +               bpf_gen__map_update_elem(obj->gen_loader, map - obj->maps,

it would be great for bpf_gen__map_update_elem to reflect that it's
not a generic map_update_elem() call, rather special internal map
update (just use bpf_gen__populate_internal_map?) Whether to freeze or
not could be just a flag to the same call, they always go together.

> +                                        map->mmaped, map->def.value_size);
> +               if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG)
> +                       bpf_gen__map_freeze(obj->gen_loader, map - obj->maps);
> +               return 0;
> +       }
>         err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
>         if (err) {
>                 err = -errno;
> @@ -4369,7 +4393,7 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
>
>  static void bpf_map__destroy(struct bpf_map *map);
>
> -static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
> +static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, bool is_inner)
>  {
>         struct bpf_create_map_attr create_attr;
>         struct bpf_map_def *def = &map->def;
> @@ -4415,9 +4439,9 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
>
>         if (bpf_map_type__is_map_in_map(def->type)) {
>                 if (map->inner_map) {
> -                       int err;
> +                       int err = 0;

no need to initialize to zero, you are assigning it right below

>
> -                       err = bpf_object__create_map(obj, map->inner_map);
> +                       err = bpf_object__create_map(obj, map->inner_map, true);
>                         if (err) {
>                                 pr_warn("map '%s': failed to create inner map: %d\n",
>                                         map->name, err);

[...]

> @@ -4469,7 +4498,12 @@ static int init_map_slots(struct bpf_map *map)
>
>                 targ_map = map->init_slots[i];
>                 fd = bpf_map__fd(targ_map);
> -               err = bpf_map_update_elem(map->fd, &i, &fd, 0);
> +               if (obj->gen_loader) {
> +                       printf("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
> +                              map - obj->maps, i, targ_map - obj->maps);

return error for now?

> +               } else {
> +                       err = bpf_map_update_elem(map->fd, &i, &fd, 0);
> +               }
>                 if (err) {
>                         err = -errno;
>                         pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",

[...]

> @@ -6082,6 +6119,11 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
>         if (str_is_empty(spec_str))
>                 return -EINVAL;
>
> +       if (prog->obj->gen_loader) {
> +               printf("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
> +                      prog - prog->obj->programs, relo->insn_off / 8,
> +                      local_name, spec_str, relo->kind);

same, return error? Drop printf, maybe leave pr_debug()?

> +       }
>         err = bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, &local_spec);
>         if (err) {
>                 pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
> @@ -6821,6 +6863,19 @@ bpf_object__relocate_calls(struct bpf_object *obj, struct bpf_program *prog)
>
>         return 0;
>  }

empty line here

> +static void
> +bpf_object__free_relocs(struct bpf_object *obj)
> +{
> +       struct bpf_program *prog;
> +       int i;
> +
> +       /* free up relocation descriptors */
> +       for (i = 0; i < obj->nr_programs; i++) {
> +               prog = &obj->programs[i];
> +               zfree(&prog->reloc_desc);
> +               prog->nr_reloc = 0;
> +       }
> +}
>

[...]

> +static int bpf_program__record_externs(struct bpf_program *prog)
> +{
> +       struct bpf_object *obj = prog->obj;
> +       int i;
> +
> +       for (i = 0; i < prog->nr_reloc; i++) {
> +               struct reloc_desc *relo = &prog->reloc_desc[i];
> +               struct extern_desc *ext = &obj->externs[relo->sym_off];
> +
> +               switch (relo->type) {
> +               case RELO_EXTERN_VAR:
> +                       if (ext->type != EXT_KSYM)
> +                               continue;
> +                       if (!ext->ksym.type_id) /* typeless ksym */
> +                               continue;

this shouldn't be silently ignored, if it's not supported, it should
return error

> +                       bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_VAR,
> +                                              relo->insn_idx);
> +                       break;
> +               case RELO_EXTERN_FUNC:
> +                       bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_FUNC,
> +                                              relo->insn_idx);
> +                       break;
> +               default:
> +                       continue;
> +               }
> +       }
> +       return 0;
> +}
> +

[...]

> @@ -7868,6 +7970,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>         err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
>         err = err ? : bpf_object__load_progs(obj, attr->log_level);
>
> +       if (obj->gen_loader && !err)
> +               err = bpf_gen__finish(obj->gen_loader);
> +
>         /* clean up module BTFs */
>         for (i = 0; i < obj->btf_module_cnt; i++) {
>                 close(obj->btf_modules[i].fd);
> @@ -8493,6 +8598,7 @@ void bpf_object__close(struct bpf_object *obj)
>         if (obj->clear_priv)
>                 obj->clear_priv(obj, obj->priv);

bpf_object__close() will close all those FD=0 in maps/progs, that's not good

>
> +       bpf_gen__free(obj->gen_loader);
>         bpf_object__elf_finish(obj);
>         bpf_object__unload(obj);
>         btf__free(obj->btf);

[...]

> @@ -9387,7 +9521,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>         }
>
>         /* kernel/module BTF ID */
> -       err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> +       if (prog->obj->gen_loader) {
> +               bpf_gen__record_attach_target(prog->obj->gen_loader, attach_name, attach_type);
> +               *btf_obj_fd = 0;

this will leak kernel module BTF FDs

> +               *btf_type_id = 1;
> +       } else {
> +               err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> +       }
>         if (err) {
>                 pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
>                 return err;

[...]

> +out:
> +       close(map_fd);
> +       close(prog_fd);

this does close(-1), check >= 0


> +       return err;
> +}
> +
> +#endif
> --
> 2.30.2
>
