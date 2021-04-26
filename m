Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7E36BBBA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 00:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhDZWgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 18:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhDZWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 18:36:09 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C1EC061574;
        Mon, 26 Apr 2021 15:35:27 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p126so13277391yba.1;
        Mon, 26 Apr 2021 15:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWagQn/COuoShM8WrVf9LFg9xKNV28jcvx8Exyu8PzY=;
        b=klRwomMCJt74+Pv/6iWw2/9qf48Bl8BXE4majBF8aBC6OjC2lTsD4QEEHx/VVCYIzX
         /9k76QhqQDDLFHgs5BK7xujejrQAegD221soV9yAGowd9wEHQxeXK9sDPFt03VrRqdQl
         S7PBU0cDS59CnnWpOA86ClebOrLuQy6NZ/T0CEiN42GCsu2bGFZPGzcJHeC/HsKcnNwL
         G61NabOZIW4jSzCJ/29kaTfIilodpev0s3ZX3umSfjU7m9r8r5Xceu71jayjmuhPMd3S
         Wivrule9lhspYUh8iJ/h3oPBugiccGNb/i+PfAnT9AFyUQFT/xO1FPpLe2qyD2YlOE/t
         tWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWagQn/COuoShM8WrVf9LFg9xKNV28jcvx8Exyu8PzY=;
        b=O3hhboAcg6VjWolrDdIqem3Zde6epbTlTxXdnfzUn9N5nFlyJ2Qyn9bT1b9j9YcmuK
         ZPnmxpItqFpgpk9xoxuqYEcLN1ScbSXzcLz2ietDWwWRxu8i1ULgK/m4MQh6s4vivWM8
         SA1r3vjnvgl8E+8Fr69PDAkvuaw1iwfyh3TOVvPdKBSnfA+Z5+y0im9LeV+Fmmav/OXO
         9+syOqhr5UKYfCzI7J1yQXu0Z1l8LnS5lrLFJlCn6iHQSO71qx1LcOEtfvdPpQvOZEwB
         h+hQ2iErcSdxpVAtsBD76DfyNji2r+2bzU6VvzXScBZwSmq4CgbyNv/ZA/U8nlGqMrdX
         rBmQ==
X-Gm-Message-State: AOAM531rBjr1MtmQNsZ97B79sUnR8oMoRatqU5WvILWfaKDn1xiJLhlf
        Syappgaf/dI8vswj44f0NpTu3wNmOzbnrTpEAKZtUthx
X-Google-Smtp-Source: ABdhPJyuKNgESmfzztTsrf7XiitRAHRoAnts2qv5j+uUHituKxkGmSC+gItgMpGTm1z9x4LMnl0G+O9kw+LJV60GORU=
X-Received: by 2002:a25:2441:: with SMTP id k62mr27373194ybk.347.1619476526857;
 Mon, 26 Apr 2021 15:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-16-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-16-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 15:35:16 -0700
Message-ID: <CAEf4BzbY2qM7OfmjfJVO1LhSYyk-NTCEo=UykH+XxKcKcPuC7w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/16] bpftool: Use syscall/loader program in
 "prog load" and "gen skeleton" command.
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
> Add -L flag to bpftool to use libbpf gen_trace facility and syscall/loader program
> for skeleton generation and program loading.
>
> "bpftool gen skeleton -L" command will generate a "light skeleton" or "loader skeleton"
> that is similar to existing skeleton, but has one major difference:
> $ bpftool gen skeleton lsm.o > lsm.skel.h
> $ bpftool gen skeleton -L lsm.o > lsm.lskel.h
> $ diff lsm.skel.h lsm.lskel.h
> @@ -5,34 +4,34 @@
>  #define __LSM_SKEL_H__
>
>  #include <stdlib.h>
> -#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
>
> The light skeleton does not use majority of libbpf infrastructure.
> It doesn't need libelf. It doesn't parse .o file.
> It only needs few sys_bpf wrappers. All of them are in bpf/bpf.h file.
> In future libbpf/bpf.c can be inlined into bpf.h, so not even libbpf.a would be
> needed to work with light skeleton.
>
> "bpftool prog load -L file.o" command is introduced for debugging of syscall/loader
> program generation. Just like the same command without -L it will try to load
> the programs from file.o into the kernel. It won't even try to pin them.
>
> "bpftool prog load -L -d file.o" command will provide additional debug messages
> on how syscall/loader program was generated.
> Also the execution of syscall/loader program will use bpf_trace_printk() for
> each step of loading BTF, creating maps, and loading programs.
> The user can do "cat /.../trace_pipe" for further debug.
>
> An example of fexit_sleep.lskel.h generated from progs/fexit_sleep.c:
> struct fexit_sleep {
>         struct bpf_loader_ctx ctx;
>         struct {
>                 struct bpf_map_desc bss;
>         } maps;
>         struct {
>                 struct bpf_prog_desc nanosleep_fentry;
>                 struct bpf_prog_desc nanosleep_fexit;
>         } progs;
>         struct {
>                 int nanosleep_fentry_fd;
>                 int nanosleep_fexit_fd;
>         } links;
>         struct fexit_sleep__bss {
>                 int pid;
>                 int fentry_cnt;
>                 int fexit_cnt;
>         } *bss;
> };
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/bpf/bpftool/Makefile        |   2 +-
>  tools/bpf/bpftool/gen.c           | 313 +++++++++++++++++++++++++++---
>  tools/bpf/bpftool/main.c          |   7 +-
>  tools/bpf/bpftool/main.h          |   1 +
>  tools/bpf/bpftool/prog.c          |  80 ++++++++
>  tools/bpf/bpftool/xlated_dumper.c |   3 +
>  6 files changed, 382 insertions(+), 24 deletions(-)
>

[...]

> @@ -268,6 +269,254 @@ static void codegen(const char *template, ...)
>         free(s);
>  }
>
> +static void print_hex(const char *obj_data, int file_sz)
> +{
> +       int i, len;
> +
> +       /* embed contents of BPF object file */

nit: this comment should have stayed at the original place

> +       for (i = 0, len = 0; i < file_sz; i++) {
> +               int w = obj_data[i] ? 4 : 2;
> +

[...]

> +       bpf_object__for_each_map(map, obj) {
> +               const char * ident;
> +
> +               ident = get_map_ident(map);
> +               if (!ident)
> +                       continue;
> +
> +               if (!bpf_map__is_internal(map) ||
> +                   !(bpf_map__def(map)->map_flags & BPF_F_MMAPABLE))
> +                       continue;
> +
> +               printf("\tskel->%1$s =\n"
> +                      "\t\tmmap(NULL, %2$zd, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,\n"
> +                      "\t\t\tskel->maps.%1$s.map_fd, 0);\n",
> +                      ident, bpf_map_mmap_sz(map));

use codegen()?

> +       }
> +       codegen("\
> +               \n\
> +                       return 0;                                           \n\
> +               }                                                           \n\
> +                                                                           \n\
> +               static inline struct %1$s *                                 \n\

[...]

>  static int do_skeleton(int argc, char **argv)
>  {
>         char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
> @@ -277,7 +526,7 @@ static int do_skeleton(int argc, char **argv)
>         struct bpf_object *obj = NULL;
>         const char *file, *ident;
>         struct bpf_program *prog;
> -       int fd, len, err = -1;
> +       int fd, err = -1;
>         struct bpf_map *map;
>         struct btf *btf;
>         struct stat st;
> @@ -359,7 +608,25 @@ static int do_skeleton(int argc, char **argv)
>         }
>
>         get_header_guard(header_guard, obj_name);
> -       codegen("\
> +       if (use_loader)

please use {} for such a long if/else, even if it's, technically, a
single-statement if

> +               codegen("\
> +               \n\
> +               /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
> +               /* THIS FILE IS AUTOGENERATED! */                           \n\
> +               #ifndef %2$s                                                \n\
> +               #define %2$s                                                \n\
> +                                                                           \n\
> +               #include <stdlib.h>                                         \n\
> +               #include <bpf/bpf.h>                                        \n\
> +               #include <bpf/skel_internal.h>                              \n\
> +                                                                           \n\
> +               struct %1$s {                                               \n\
> +                       struct bpf_loader_ctx ctx;                          \n\
> +               ",
> +               obj_name, header_guard
> +               );
> +       else
> +               codegen("\
>                 \n\
>                 /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
>                                                                             \n\

[...]
