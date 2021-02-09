Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664E0314883
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBIGOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBIGOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:14:02 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6779EC061786;
        Mon,  8 Feb 2021 22:13:22 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id w204so17110954ybg.2;
        Mon, 08 Feb 2021 22:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wlmna3DEiIiZVjhHWOjRL7VmzEe2uosGs1W7iJ27zug=;
        b=WtqTXmstXwWpe8EGSKw1DXiDtUH73zhvhwLNV4pxXAPxy/mPXl/tRWvMt7IBgImld8
         Pe+gQMscHrC55LZj0WvM0xC6idf2Pilh55DJEOCm58FxEGhSDUv+WGZMcOH84u6S+v+h
         qxp55nAwuEToUgGt/yXCuQx+ii3ai9BLQ+7gp+oYRPrm5oLGlvHWeP6U1Zd7CwH8wkcw
         iAqKMrWSzWD4ON2jvL8Q/y/sGhhkTJav2AP1p/Xd96rmB8hUKoFEv20Fab/hdexDlWFf
         AdEQPl4VHqDopQ7DCwChRWrkIcPFvI6AG5On5j3duuth7/Iorm9uaq9aXhS1VIKE8VJ/
         84bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wlmna3DEiIiZVjhHWOjRL7VmzEe2uosGs1W7iJ27zug=;
        b=eolLXvgMYwjvrNUtZnF/LUYLrlm1mxu6vpVBdhp02BxRmPpQ8YNWLLaZs64i9nacQm
         +jgsDb4FYJDVvcAtt+avxADnmH4xA224NPpMsiIBrTv9YBqVITk6Kkld/ZNGOD/mdTGZ
         FiDJJuawjBBiJhZDS0agIMmr0VIMvna7Ga0cwVENVdY/1EchokELcFtcJsjpiBDGGbV2
         Q4bJIgO5l+s0kbMjncF6DpBIsa6wQDJdlBZGocKfh47qEJdYIa3g/KcmDp5+XxJNUpQe
         2prdT72pc7StxXHD2tV8rzrwn0NnC5NR8QflQlXh62JSZOe1jFwhkT4ohJmn9VwU0JwH
         wFww==
X-Gm-Message-State: AOAM5323U7lF5DhzxtfAUEJ1my46lxobS2uWLZ6e2ddI4RU6XoED9Y1O
        c+64vK4LP1NFGtn6CH7EFc52xJCyxaGYUgjZTj0=
X-Google-Smtp-Source: ABdhPJysH0ePXABLSOGQUYqfrIMImTf+faXzGCK7WpQuJzH4vwelkRfloHxrMVv3fMmP9tU7Yu6XgG+ZJcVXcB0T5LA=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr30188961yba.403.1612851201745;
 Mon, 08 Feb 2021 22:13:21 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
In-Reply-To: <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 22:13:10 -0800
Message-ID: <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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

On Mon, Feb 8, 2021 at 10:09 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Feb 8, 2021 at 9:23 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Mon, Feb 08, 2021 at 08:45:43PM -0800, Andrii Nakryiko wrote:
> > > On Mon, Feb 8, 2021 at 7:44 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
> > > > https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ
> > > >
> > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > >                       LLVM=1 O=build/aarch64 defconfig
> > > >
> > > > $ scripts/config \
> > > >     --file build/aarch64/.config \
> > > >     -e BPF_SYSCALL \
> > > >     -e DEBUG_INFO_BTF \
> > > >     -e FTRACE \
> > > >     -e FUNCTION_TRACER
> > > >
> > > > $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
> > > >                       LLVM=1 O=build/aarch64 olddefconfig all
> > > > ...
> > > > FAILED unresolved symbol vfs_truncate
> > > > ...
> > > >
> > > > My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
> > > > although that seems obvious given that is what introduced
> > > > BTF_ID(func, vfs_truncate).
> > > >
> > > > I am using the latest pahole v1.20 and LLVM is at
> > > > https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
> > > > although I can reproduce back to LLVM 10.0.1, which is the earliest
> > > > version that the kernel supports. I am very unfamiliar with BPF so I
> > > > have no idea what is going wrong here. Is this a known issue?
> > > >
> > >
> > > I'll skip the reproduction games this time and will just request the
> > > vmlinux image. Please upload somewhere so that we can look at DWARF
> > > and see what's going on. Thanks.
> > >
> >
> > Sure thing, let me know if this works. I uploaded in two places to make
> > it easier to grab:
> >
> > zstd compressed:
> > https://github.com/nathanchance/bug-files/blob/3b2873751e29311e084ae2c71604a1963f5e1a48/btf-aarch64/vmlinux.zst
> >
>
> Thanks. I clearly see at least one instance of seemingly well-formed
> vfs_truncate DWARF declaration. Also there is a proper ELF symbol for
> it. Which means it should have been generated in BTF, but it doesn't
> appear to be, so it does seem like a pahole bug. I (or someone else
> before me) will continue tomorrow.
>
> $ llvm-dwarfdump vmlinux
> ...
>
> 0x00052e6f:   DW_TAG_subprogram
>                 DW_AT_name      ("vfs_truncate")
>                 DW_AT_decl_file
> ("/home/nathan/cbl/src/linux/include/linux/fs.h")
>                 DW_AT_decl_line (2520)
>                 DW_AT_prototyped        (true)
>                 DW_AT_type      (0x000452cb "long int")
>                 DW_AT_declaration       (true)
>                 DW_AT_external  (true)
>
> 0x00052e7b:     DW_TAG_formal_parameter
>                   DW_AT_type    (0x00045fc6 "const path*")
>
> 0x00052e80:     DW_TAG_formal_parameter
>                   DW_AT_type    (0x00045213 "long long int")
>
> ...
>

... and here's the *only* other one (not marked as declaration, but I
thought we already handle that, Jiri?):

0x01d0da35:   DW_TAG_subprogram
                DW_AT_low_pc    (0xffff80001031f430)
                DW_AT_high_pc   (0xffff80001031f598)
                DW_AT_frame_base        (DW_OP_reg29)
                DW_AT_GNU_all_call_sites        (true)
                DW_AT_name      ("vfs_truncate")
                DW_AT_decl_file ("/home/nathan/cbl/src/linux/fs/open.c")
                DW_AT_decl_line (69)
                DW_AT_prototyped        (true)
                DW_AT_type      (0x01cfdfe4 "long int")
                DW_AT_external  (true)


> $ llvm-readelf -s vmlinux | rg vfs_truncate
>  15013: ffff800011c22418     4 OBJECT  LOCAL  DEFAULT    24
> __BTF_ID__func__vfs_truncate__609
>  22531: ffff80001189fe0d     0 NOTYPE  LOCAL  DEFAULT    17
> __kstrtab_vfs_truncate
>  22532: ffff8000118a985b     0 NOTYPE  LOCAL  DEFAULT    17
> __kstrtabns_vfs_truncate
>  22534: ffff800011873b7c     0 NOTYPE  LOCAL  DEFAULT     8
> __ksymtab_vfs_truncate
> 176099: ffff80001031f430   360 FUNC    GLOBAL DEFAULT     2 vfs_truncate
>
> $ bpftool btf dump file vmlinux | rg vfs_truncate
> <nothing>
>
> > uncompressed:
> > https://1drv.ms/u/s!AsQNYeB-IEbqjQiUOspbEdXx49o7?e=ipA9Hv
> >
> > Cheers,
> > Nathan
