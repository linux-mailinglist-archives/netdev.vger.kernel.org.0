Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0285336CA79
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhD0RjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 13:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbhD0RjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 13:39:16 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD189C061574;
        Tue, 27 Apr 2021 10:38:32 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id j84so717626ybj.9;
        Tue, 27 Apr 2021 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mi3ASX57EUUORwgofsiMzfVhbo+tT5vFJSBQ/xFKHU8=;
        b=T1nlQOaNI87sRd+/1sOHA0gqLSVG520YDoFgDUi5aliaLMk7dBgJZ3r/W1PgR66wKi
         9HhnR62iLPn1Y1cxlnZv4UOKEo740l8nsYyvNSFVMuo1CPsi540nIf0xqMTFKZpCGVLh
         cdNE3vUgVCLX3MdEGs0sr76bV/06fYtAvwEc7mXxTTp8WlEo/IZzVtorqDM2nvlIOwQs
         0kaayrg5TTRQIc5DWvzajsPyDTgxyckdBtUffLydPfvdB/QZMRXHT1cFtJkVeVehTbgq
         pReTjXepVtLUH/el3jcuQPlEV2V8YP/Nu7EjK6QeHc3+3FnTl5sLMEH8PnbTpqmA2zSH
         FZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mi3ASX57EUUORwgofsiMzfVhbo+tT5vFJSBQ/xFKHU8=;
        b=GNbT945TsCcC4gppgATwR8EBVkiWgPMtczHPQlseRNqkf6Ru6OFjXrXgvpxiLFF9Sh
         RbzHOUD64w/ll8FhpUsvIDIB4G0r/F4epynKEvLNDhzkF0lwiIHqtz2Vw79BSkAM/hmR
         550YiI8DSVWumxISqYooSYu5YIvmklnq89F+k2q8FdD7M04WXC9/Kexp0aBiRd5PsCBb
         1HsApON7pG54b3d71+0hz4InIvfVnfXccemnwKO4blDJPR9cKHGIlEbRVctS71y1AJLI
         ptX0q4RTKivmC8rZcg8SzA9dX4lv/nb0Ai/DzbgRaTTVsn0PDjF63c7zpqrTHCUbyLq9
         BG6g==
X-Gm-Message-State: AOAM530nVbJB2XyzW+Ri9vlhQBAPauUIIDUW2pl+XVHfiZFTMe+64uoT
        FXmEgEfgLv4bQCnIE/u+0qO/fmuabnOEN7lwi+nYpIA3
X-Google-Smtp-Source: ABdhPJxTB9XAHJ35LLUzZ/qlnVTp1HDQdBi3cnQST6VSSx+BUd0XoiuWF5J9Eoub+o5NKy4FpXs0XHCAA3zXWsRivq4=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr33911336ybu.510.1619545112132;
 Tue, 27 Apr 2021 10:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-16-alexei.starovoitov@gmail.com> <CAEf4BzbY2qM7OfmjfJVO1LhSYyk-NTCEo=UykH+XxKcKcPuC7w@mail.gmail.com>
 <20210427032837.mtaqbbptczd3dvck@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427032837.mtaqbbptczd3dvck@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 10:38:21 -0700
Message-ID: <CAEf4BzaeG9XmJiWzRE3r5aKCD+ibiLsGLYx03Pgco1PSjn_L0A@mail.gmail.com>
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

On Mon, Apr 26, 2021 at 8:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 03:35:16PM -0700, Andrii Nakryiko wrote:
> > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Add -L flag to bpftool to use libbpf gen_trace facility and syscall/loader program
> > > for skeleton generation and program loading.
> > >
> > > "bpftool gen skeleton -L" command will generate a "light skeleton" or "loader skeleton"
> > > that is similar to existing skeleton, but has one major difference:
> > > $ bpftool gen skeleton lsm.o > lsm.skel.h
> > > $ bpftool gen skeleton -L lsm.o > lsm.lskel.h
> > > $ diff lsm.skel.h lsm.lskel.h
> > > @@ -5,34 +4,34 @@
> > >  #define __LSM_SKEL_H__
> > >
> > >  #include <stdlib.h>
> > > -#include <bpf/libbpf.h>
> > > +#include <bpf/bpf.h>
> > >
> > > The light skeleton does not use majority of libbpf infrastructure.
> > > It doesn't need libelf. It doesn't parse .o file.
> > > It only needs few sys_bpf wrappers. All of them are in bpf/bpf.h file.
> > > In future libbpf/bpf.c can be inlined into bpf.h, so not even libbpf.a would be
> > > needed to work with light skeleton.
> > >
> > > "bpftool prog load -L file.o" command is introduced for debugging of syscall/loader
> > > program generation. Just like the same command without -L it will try to load
> > > the programs from file.o into the kernel. It won't even try to pin them.
> > >
> > > "bpftool prog load -L -d file.o" command will provide additional debug messages
> > > on how syscall/loader program was generated.
> > > Also the execution of syscall/loader program will use bpf_trace_printk() for
> > > each step of loading BTF, creating maps, and loading programs.
> > > The user can do "cat /.../trace_pipe" for further debug.
> > >
> > > An example of fexit_sleep.lskel.h generated from progs/fexit_sleep.c:
> > > struct fexit_sleep {
> > >         struct bpf_loader_ctx ctx;
> > >         struct {
> > >                 struct bpf_map_desc bss;
> > >         } maps;
> > >         struct {
> > >                 struct bpf_prog_desc nanosleep_fentry;
> > >                 struct bpf_prog_desc nanosleep_fexit;
> > >         } progs;
> > >         struct {
> > >                 int nanosleep_fentry_fd;
> > >                 int nanosleep_fexit_fd;
> > >         } links;
> > >         struct fexit_sleep__bss {
> > >                 int pid;
> > >                 int fentry_cnt;
> > >                 int fexit_cnt;
> > >         } *bss;
> > > };
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  tools/bpf/bpftool/Makefile        |   2 +-
> > >  tools/bpf/bpftool/gen.c           | 313 +++++++++++++++++++++++++++---
> > >  tools/bpf/bpftool/main.c          |   7 +-
> > >  tools/bpf/bpftool/main.h          |   1 +
> > >  tools/bpf/bpftool/prog.c          |  80 ++++++++
> > >  tools/bpf/bpftool/xlated_dumper.c |   3 +
> > >  6 files changed, 382 insertions(+), 24 deletions(-)
> > >
> >
> > [...]
> >
> > > @@ -268,6 +269,254 @@ static void codegen(const char *template, ...)
> > >         free(s);
> > >  }
> > >
> > > +static void print_hex(const char *obj_data, int file_sz)
> > > +{
> > > +       int i, len;
> > > +
> > > +       /* embed contents of BPF object file */
> >
> > nit: this comment should have stayed at the original place
> >
> > > +       for (i = 0, len = 0; i < file_sz; i++) {
> > > +               int w = obj_data[i] ? 4 : 2;
> > > +
> >
> > [...]
> >
> > > +       bpf_object__for_each_map(map, obj) {
> > > +               const char * ident;
> > > +
> > > +               ident = get_map_ident(map);
> > > +               if (!ident)
> > > +                       continue;
> > > +
> > > +               if (!bpf_map__is_internal(map) ||
> > > +                   !(bpf_map__def(map)->map_flags & BPF_F_MMAPABLE))
> > > +                       continue;
> > > +
> > > +               printf("\tskel->%1$s =\n"
> > > +                      "\t\tmmap(NULL, %2$zd, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,\n"
> > > +                      "\t\t\tskel->maps.%1$s.map_fd, 0);\n",
> > > +                      ident, bpf_map_mmap_sz(map));
> >
> > use codegen()?
>
> why?
> codegen() would add extra early \n for no good reason.

for consistency, seems like the rest of the code in that function uses
codegen(). But not critical.

>
> > > +       }
> > > +       codegen("\
> > > +               \n\
> > > +                       return 0;                                           \n\
> > > +               }                                                           \n\
> > > +                                                                           \n\
> > > +               static inline struct %1$s *                                 \n\
> >
> > [...]
> >
> > >  static int do_skeleton(int argc, char **argv)
> > >  {
> > >         char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
> > > @@ -277,7 +526,7 @@ static int do_skeleton(int argc, char **argv)
> > >         struct bpf_object *obj = NULL;
> > >         const char *file, *ident;
> > >         struct bpf_program *prog;
> > > -       int fd, len, err = -1;
> > > +       int fd, err = -1;
> > >         struct bpf_map *map;
> > >         struct btf *btf;
> > >         struct stat st;
> > > @@ -359,7 +608,25 @@ static int do_skeleton(int argc, char **argv)
> > >         }
> > >
> > >         get_header_guard(header_guard, obj_name);
> > > -       codegen("\
> > > +       if (use_loader)
> >
> > please use {} for such a long if/else, even if it's, technically, a
> > single-statement if
>
> I think it reads fine as-is, but, sure, I can add {}
>
> > > +               codegen("\
> > > +               \n\
> > > +               /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
> > > +               /* THIS FILE IS AUTOGENERATED! */                           \n\
> > > +               #ifndef %2$s                                                \n\
> > > +               #define %2$s                                                \n\
> > > +                                                                           \n\
> > > +               #include <stdlib.h>                                         \n\
> > > +               #include <bpf/bpf.h>                                        \n\
> > > +               #include <bpf/skel_internal.h>                              \n\
> > > +                                                                           \n\
> > > +               struct %1$s {                                               \n\
> > > +                       struct bpf_loader_ctx ctx;                          \n\
> > > +               ",
> > > +               obj_name, header_guard
> > > +               );
> > > +       else
> > > +               codegen("\
> > >                 \n\
> > >                 /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */   \n\
> > >                                                                             \n\
> >
> > [...]
>
> --
