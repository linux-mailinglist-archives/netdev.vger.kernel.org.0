Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911FD31588D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhBIVWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhBIVAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 16:00:44 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D2AC06178B;
        Tue,  9 Feb 2021 13:00:03 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id b187so19538679ybg.9;
        Tue, 09 Feb 2021 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/nK6Bh3Eef8RPr+9XuUSMYt3dJ038OuBkzE/gPK78U=;
        b=HJkOE3Ysk6FDIuZuz7K7os/rZOjHlRfWgDE7FhoM/aEiF62DXMT7xuFG/3TR7vlM8H
         Sf95vNCXFi0p2Jmru65y7TKdOVXEe7Oo6Y3Lck959OltJv8F8X0UixN1lahWRo64sEPS
         TrSSKcNFvNJ4uWtW2fAcAovkIlJQIMi3FH14EJegZ+vjN684JE9GQ69liVe26VMg2I4a
         HsklBF+LQsCBAkKfCvJKbwQlvGh3lKRLxV4uLrndiG8ipNIQudp3vLI4dZPR6jYoZLrh
         YA95uRIGofv26NPZGkDe2PEYOG6qPzY8PaLAaoUTxzY/Df530eg0QlMrdTd9KDoRPIou
         dW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/nK6Bh3Eef8RPr+9XuUSMYt3dJ038OuBkzE/gPK78U=;
        b=XgLnQZF/xtga+k2p62/5kGBB5H3BRugacDcoknUd+Yrme45GLxJrcud1MaEw7+Qhop
         kw6Jyn5O8yoZe+euivC9xG/XTrgBABMkA/h5iixF/hkPLHz7tcrzTSxag5aQ8NqsBPSH
         WlSpysRd1/hJa4+YPJivU0Xgz2AAWCRM9lRsvsIsuz0mWlqwPOWZ4Zf+GnHVzqY0uOVa
         jzwQALIwGWhTlrHDU7G4fZ48JsX4fodrgrXNAHCqwFU2tMhjqb3Ci4xMocWxro/fXTzy
         fvJ94BB9jjAlUWXaCVFRoN9vLqWm4lqWHTlXyorHmDrNovQV+tY3+93w2DONNba0tIz7
         X2IA==
X-Gm-Message-State: AOAM533SWBVvpIQp2lxBPO8cnMFDnFHjepf6WQ9QDTNO/A72yuqmYeAj
        /CtuVkBAFFJADtD1dkvF3COImp5lGMOVaBxjFh8=
X-Google-Smtp-Source: ABdhPJxXC7+3oK3KBiDn2qiUfx4TVGJfQWE4XV10BstaSDg4jCajwQ7kn0Q75dO/r6U52t7JxRXTdgiESotOgSlSSOg=
X-Received: by 2002:a25:c905:: with SMTP id z5mr35833755ybf.260.1612904402472;
 Tue, 09 Feb 2021 13:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava> <YCKlrLkTQXc4Cyx7@krava>
In-Reply-To: <YCKlrLkTQXc4Cyx7@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Feb 2021 12:59:51 -0800
Message-ID: <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 7:09 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 01:36:41PM +0100, Jiri Olsa wrote:
> > On Tue, Feb 09, 2021 at 12:49:04AM -0700, Nathan Chancellor wrote:
> > > On Mon, Feb 08, 2021 at 10:56:36PM -0800, Andrii Nakryiko wrote:
> > > > On Mon, Feb 8, 2021 at 10:13 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Mon, Feb 8, 2021 at 10:09 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Feb 8, 2021 at 9:23 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon, Feb 08, 2021 at 08:45:43PM -0800, Andrii Nakryiko wrote:
> > > > > > > > On Mon, Feb 8, 2021 at 7:44 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > Hi all,
> > > > > > > > >
> > > > > > > > > Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
> > > > > > > > > https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ
> > > > > > > > >
> > > > > > > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > > > > > > >                       LLVM=1 O=build/aarch64 defconfig
> > > > > > > > >
> > > > > > > > > $ scripts/config \
> > > > > > > > >     --file build/aarch64/.config \
> > > > > > > > >     -e BPF_SYSCALL \
> > > > > > > > >     -e DEBUG_INFO_BTF \
> > > > > > > > >     -e FTRACE \
> > > > > > > > >     -e FUNCTION_TRACER
> > > > > > > > >
> > > > > > > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > > > > > > >                       LLVM=1 O=build/aarch64 olddefconfig all
> > > > > > > > > ...
> > > > > > > > > FAILED unresolved symbol vfs_truncate
> > > > > > > > > ...
> > > > > > > > >
> > > > > > > > > My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
> > > > > > > > > although that seems obvious given that is what introduced
> > > > > > > > > BTF_ID(func, vfs_truncate).
> > > > > > > > >
> > > > > > > > > I am using the latest pahole v1.20 and LLVM is at
> > > > > > > > > https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
> > > > > > > > > although I can reproduce back to LLVM 10.0.1, which is the earliest
> > > > > > > > > version that the kernel supports. I am very unfamiliar with BPF so I
> > > > > > > > > have no idea what is going wrong here. Is this a known issue?
> > > > > > > > >
> > > > > > > >
> > > > > > > > I'll skip the reproduction games this time and will just request the
> > > > > > > > vmlinux image. Please upload somewhere so that we can look at DWARF
> > > > > > > > and see what's going on. Thanks.
> > > > > > > >
> > > > > > >
> > > > > > > Sure thing, let me know if this works. I uploaded in two places to make
> > > > > > > it easier to grab:
> > > > > > >
> > > > > > > zstd compressed:
> > > > > > > https://github.com/nathanchance/bug-files/blob/3b2873751e29311e084ae2c71604a1963f5e1a48/btf-aarch64/vmlinux.zst
> > > > > > >
> > > > > >
> > > > > > Thanks. I clearly see at least one instance of seemingly well-formed
> > > > > > vfs_truncate DWARF declaration. Also there is a proper ELF symbol for
> > > > > > it. Which means it should have been generated in BTF, but it doesn't
> > > > > > appear to be, so it does seem like a pahole bug. I (or someone else
> > > > > > before me) will continue tomorrow.
> > > > > >
> > > > > > $ llvm-dwarfdump vmlinux
> > > > > > ...
> > > > > >
> > > > > > 0x00052e6f:   DW_TAG_subprogram
> > > > > >                 DW_AT_name      ("vfs_truncate")
> > > > > >                 DW_AT_decl_file
> > > > > > ("/home/nathan/cbl/src/linux/include/linux/fs.h")
> > > > > >                 DW_AT_decl_line (2520)
> > > > > >                 DW_AT_prototyped        (true)
> > > > > >                 DW_AT_type      (0x000452cb "long int")
> > > > > >                 DW_AT_declaration       (true)
> > > > > >                 DW_AT_external  (true)
> > > > > >
> > > > > > 0x00052e7b:     DW_TAG_formal_parameter
> > > > > >                   DW_AT_type    (0x00045fc6 "const path*")
> > > > > >
> > > > > > 0x00052e80:     DW_TAG_formal_parameter
> > > > > >                   DW_AT_type    (0x00045213 "long long int")
> > > > > >
> > > > > > ...
> > > > > >
> > > > >
> > > > > ... and here's the *only* other one (not marked as declaration, but I
> > > > > thought we already handle that, Jiri?):
> > > > >
> > > > > 0x01d0da35:   DW_TAG_subprogram
> > > > >                 DW_AT_low_pc    (0xffff80001031f430)
> > > > >                 DW_AT_high_pc   (0xffff80001031f598)
> > > > >                 DW_AT_frame_base        (DW_OP_reg29)
> > > > >                 DW_AT_GNU_all_call_sites        (true)
> > > > >                 DW_AT_name      ("vfs_truncate")
> > > > >                 DW_AT_decl_file ("/home/nathan/cbl/src/linux/fs/open.c")
> > > > >                 DW_AT_decl_line (69)
> > > > >                 DW_AT_prototyped        (true)
> > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > >                 DW_AT_external  (true)
> > > > >
> > > >
> > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > pahole ignores it. I don't know why this happens and it's quite
> > > > strange, given vfs_truncate is just a normal global function.
> >
> > right, I can't see it in mcount adresses.. but it begins with instructions
> > that appears to be nops, which would suggest it's traceable
> >
> >       ffff80001031f430 <vfs_truncate>:
> >       ffff80001031f430: 5f 24 03 d5   hint    #34
> >       ffff80001031f434: 1f 20 03 d5   nop
> >       ffff80001031f438: 1f 20 03 d5   nop
> >       ffff80001031f43c: 3f 23 03 d5   hint    #25
> >
> > > >
> > > > I'd like to understand this issue before we try to fix it, but there
> > > > is at least one improvement we can make: pahole should check ftrace
> > > > addresses only for static functions, not the global ones (global ones
> > > > should be always attachable, unless they are special, e.g., notrace
> > > > and stuff). We can easily check that by looking at the corresponding
> > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
>
> I'm still trying to build the kernel.. however ;-)
>
> patch below adds the ftrace check only for static functions
> and lets the externa go through.. but as you said, in this
> case we'll need to figure out the 'notrace' and other checks
> ftrace is doing
>
> jirka
>
>
> ---
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..4d147406cfa5 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -734,7 +734,7 @@ int cu__encode_btf(struct cu *cu, int verbose, bool force,
>                         continue;
>                 if (!has_arg_names(cu, &fn->proto))
>                         continue;
> -               if (functions_cnt) {
> +               if (!fn->external && functions_cnt) {

I wouldn't trust DWARF, honestly. Wouldn't checking GLOBAL vs LOCAL
FUNC ELF symbol be more reliable?

>                         struct elf_function *func;
>                         const char *name;
>
> @@ -746,9 +746,6 @@ int cu__encode_btf(struct cu *cu, int verbose, bool force,
>                         if (!func || func->generated)
>                                 continue;
>                         func->generated = true;
> -               } else {
> -                       if (!fn->external)
> -                               continue;
>                 }
>
>                 btf_fnproto_id = btf_elf__add_func_proto(btfe, cu, &fn->proto, type_id_off);
>
