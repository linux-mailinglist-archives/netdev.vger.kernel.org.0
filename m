Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1C324AD01
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHTC2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 22:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgHTC2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 22:28:06 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7DCC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 19:28:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m34so422037pgl.11
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 19:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mkuNUSpCXTz0USifEvkWtGVwwthb17DUhyOsL4nK7yY=;
        b=nMaZM/wnD85dyxcuw46HrKWj4s1O2Jkc51m4r7KR+oCMtUfJabPEEDvU7TzieUVPf6
         SMwLFaGsnwWrkzEty786x1riKGpf9ig/rYQNgs5UBbnL1hv53BV4tcNzs3hHMX5NeJyP
         CTPdGAfLDNiIeJJutFSp/ELzBuS7ahk4PMPqH+/HnDa/qQOdvQXBONdxPth7IX+TxEwp
         icrb9bQg30aKNUwTBoeE1ThYAVV39H1mIvaPK9JIr3ekirWnOGbfOQuO8IO+vIRIHrUA
         kUAt/ZBrhMM8B8+l1ijoluEjCQPCSUk6OA8vcVO6hg/d1G6OmuXcf7P8/UNL0urelric
         m6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mkuNUSpCXTz0USifEvkWtGVwwthb17DUhyOsL4nK7yY=;
        b=ruAdzA2M0R2MgHTj/M7nBqnr9ERDYRwsqw9DMstN6jUPqRbWLNy8kW+KLngmw8SNT6
         bep/Pe0Ouq6KQgoZkksg9y/hIIyo1anarc+s0mAhXqlnQGD4Vfx9SGPC//wEe6xbl7lm
         NK2QB8MNsvxhvYEOXnSJ08UeiVNYt/oGrELf2YLnlU9V9m8sHKKFNjK5I3tmVRoGzWQu
         /OSwFe5aqJUlZ0pjEBEVsKqZ3edno6dRY0QU1YGVZQyfoW6hkEfvu5Uqy7vtLdTnWRrI
         ZoSRZpHz/Bljm/Sgm5bWSjuTqkKsvyvGUvlSaGfEZ8Dk74ZlEDqEdpQ0R8ARe219H8xf
         GZ7g==
X-Gm-Message-State: AOAM530KEjKTViq3NBRz2NYhCx+EkaatJ5pIY5S2nIIlnZ9nuRtbtoNu
        bYZZO9Chjbc/poYw4lWPR3zqm7F8+2QzxAEWFwPQoQ==
X-Google-Smtp-Source: ABdhPJzR+BpKPM8t0iRkChXEkY8gpmynj3cuLqYc01CufyzCHZwE0DfK1P0KTFEvDvjVIK8VP6b76D8jQS+2LUEAjlg=
X-Received: by 2002:aa7:9552:: with SMTP id w18mr644205pfq.150.1597890486025;
 Wed, 19 Aug 2020 19:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092342.259004-1-jolsa@kernel.org> <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
 <20200819173618.GH177896@krava> <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
 <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
In-Reply-To: <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
From:   =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
Date:   Wed, 19 Aug 2020 19:27:54 -0700
Message-ID: <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong alignment
To:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mark Wielaard <mjw@redhat.com>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >    section(36) .comment, size 44, link 0, flags 30, type=3D1
> > >    section(37) .debug_aranges, size 45684, link 0, flags 800, type=3D=
1
> > >     - fixing wrong alignment sh_addralign 16, expected 8
> > >    section(38) .debug_info, size 129104957, link 0, flags 800, type=
=3D1
> > >     - fixing wrong alignment sh_addralign 1, expected 8
> > >    section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=
=3D1
> > >     - fixing wrong alignment sh_addralign 1, expected 8
> > >    section(40) .debug_line, size 7374522, link 0, flags 800, type=3D1
> > >     - fixing wrong alignment sh_addralign 1, expected 8
> > >    section(41) .debug_frame, size 702463, link 0, flags 800, type=3D1
> > >    section(42) .debug_str, size 1017571, link 0, flags 830, type=3D1
> > >     - fixing wrong alignment sh_addralign 1, expected 8
> > >    section(43) .debug_loc, size 3019453, link 0, flags 800, type=3D1
> > >     - fixing wrong alignment sh_addralign 1, expected 8
> > >    section(44) .debug_ranges, size 1744583, link 0, flags 800, type=
=3D1
> > >     - fixing wrong alignment sh_addralign 16, expected 8
> > >    section(45) .symtab, size 2955888, link 46, flags 0, type=3D2
> > >    section(46) .strtab, size 2613072, link 0, flags 0, type=3D3

I think this is resolve_btfids's bug. GNU ld and LLD are innocent.
These .debug_* sections work fine if their sh_addralign is 1.
When the section flag SHF_COMPRESSED is set, the meaningful alignment
is Elf64_Chdr::ch_addralign, after the header is uncompressed.

On Wed, Aug 19, 2020 at 2:30 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/19/20 11:16 AM, Nick Desaulniers wrote:
> > On Wed, Aug 19, 2020 at 10:36 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >>
> >> On Wed, Aug 19, 2020 at 08:31:51AM -0700, Yonghong Song wrote:
> >>>
> >>>
> >>> On 8/19/20 2:23 AM, Jiri Olsa wrote:
> >>>> The data of compressed section should be aligned to 4
> >>>> (for 32bit) or 8 (for 64 bit) bytes.
> >>>>
> >>>> The binutils ld sets sh_addralign to 1, which makes libelf
> >>>> fail with misaligned section error during the update as
> >>>> reported by Jesper:
> >>>>
> >>>>      FAILED elf_update(WRITE): invalid section alignment
> >>>>
> >>>> While waiting for ld fix, we can fix compressed sections
> >>>> sh_addralign value manually.
> >
> > Is there a bug filed against GNU ld? Link?
> >
> >>>>
> >>>> Adding warning in -vv mode when the fix is triggered:
> >>>>
> >>>>     $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
> >>>>     ...
> >>>>     section(36) .comment, size 44, link 0, flags 30, type=3D1
> >>>>     section(37) .debug_aranges, size 45684, link 0, flags 800, type=
=3D1
> >>>>      - fixing wrong alignment sh_addralign 16, expected 8
> >>>>     section(38) .debug_info, size 129104957, link 0, flags 800, type=
=3D1
> >>>>      - fixing wrong alignment sh_addralign 1, expected 8
> >>>>     section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=
=3D1
> >>>>      - fixing wrong alignment sh_addralign 1, expected 8
> >>>>     section(40) .debug_line, size 7374522, link 0, flags 800, type=
=3D1
> >>>>      - fixing wrong alignment sh_addralign 1, expected 8
> >>>>     section(41) .debug_frame, size 702463, link 0, flags 800, type=
=3D1
> >>>>     section(42) .debug_str, size 1017571, link 0, flags 830, type=3D=
1
> >>>>      - fixing wrong alignment sh_addralign 1, expected 8
> >>>>     section(43) .debug_loc, size 3019453, link 0, flags 800, type=3D=
1
> >>>>      - fixing wrong alignment sh_addralign 1, expected 8
> >>>>     section(44) .debug_ranges, size 1744583, link 0, flags 800, type=
=3D1
> >>>>      - fixing wrong alignment sh_addralign 16, expected 8
> >>>>     section(45) .symtab, size 2955888, link 46, flags 0, type=3D2
> >>>>     section(46) .strtab, size 2613072, link 0, flags 0, type=3D3
> >>>>     ...
> >>>>     update ok for vmlinux
> >>>>
> >>>> Another workaround is to disable compressed debug info data
> >>>> CONFIG_DEBUG_INFO_COMPRESSED kernel option.
> >>>
> >>> So CONFIG_DEBUG_INFO_COMPRESSED is required to reproduce the bug, rig=
ht?
> >>
> >> correct
> >>
> >>>
> >>> I turned on CONFIG_DEBUG_INFO_COMPRESSED in my config and got a bunch=
 of
> >>> build failures.
> >>>
> >>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> >>> decompress status for section .debug_info
> >>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> >>> decompress status for section .debug_info
> >>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> >>> decompress status for section .debug_info
> >>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
> >>> decompress status for section .debug_info
> >>> drivers/crypto/virtio/virtio_crypto_algs.o: file not recognized: File=
 format
> >>> not recognized
> >>>
> >>> ld: net/llc/llc_core.o: unable to initialize decompress status for se=
ction
> >>> .debug_info
> >>> ld: net/llc/llc_core.o: unable to initialize decompress status for se=
ction
> >>> .debug_info
> >>> ld: net/llc/llc_core.o: unable to initialize decompress status for se=
ction
> >>> .debug_info
> >>> ld: net/llc/llc_core.o: unable to initialize decompress status for se=
ction
> >>> .debug_info
> >>> net/llc/llc_core.o: file not recognized: File format not recognized
> >>>
> >>> ...
> >>>
> >>> The 'ld' in my system:
> >>>
> >>> $ ld -V
> >>> GNU ld version 2.30-74.el8
> >>>    Supported emulations:
> >>>     elf_x86_64
> >>>     elf32_x86_64
> >>>     elf_i386
> >>>     elf_iamcu
> >>>     i386linux
> >>>     elf_l1om
> >>>     elf_k1om
> >>>     i386pep
> >>>     i386pe
> >
> > According to Documentation/process/changes.rst, the minimum supported
> > version of GNU binutils for the kernels is 2.23.  Can you upgrade to
> > that and confirm that you still observe the issue?  I don't want to
> > spend time chasing bugs in old, unsupported versions of GNU binutils,
> > especially as Jiri notes, 2.26 is required for
> > CONFIG_DEBUG_INFO_COMPRESSED.  We can always strengthen the Kconfig
> > check for it.  Otherwise, I'm not familiar with the observed error
> > message.
>
> I built a "ld" with latest binutils-gdb repo and I can reproduced
> the issue. Indeed applying the patch here fixed the issue. So
> I think there is no need to investigate since upstream exhibits
> the exact issue described here.
>
> >
> >>> $
> >>>
> >>> Do you know what is the issue here?
> >>
> >> mine's: GNU ld version 2.32-31.fc31
> >>
> >> there's version info in commit:
> >>    10e68b02c861 Makefile: support compressed debug info
> >>
> >>    Compress the debug information using zlib.  Requires GCC 5.0+ or Cl=
ang
> >>    5.0+, binutils 2.26+, and zlib.
> >>
> >> cc-ing Nick Desaulniers, author of that patch.. any idea about the err=
or above?
> >>
> >> thanks,
> >> jirka
> >>
> >
> >



--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
