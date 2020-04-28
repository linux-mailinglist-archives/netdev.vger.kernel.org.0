Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA21BCF87
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD1WNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1WNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:13:12 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E1C03C1AC;
        Tue, 28 Apr 2020 15:13:12 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id w18so190905qvs.3;
        Tue, 28 Apr 2020 15:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oMtA4/Uzs7qD0WVMKCq8uAwCnGJPL6aPI451Jog1qpQ=;
        b=SwG6mcpON7MeeRO8+45F72AsRJfBik1eWu7xlZm64wFKtaSksMN01d93PiN/B2LYgE
         dl+JFOVhOZTfiWUaR73s7iwhS/EL0n9fTcFGvH3/WMiT/AQ1z5PMYL4pdDvjCF+0CbyG
         yzKnaJLBe3OFipvbW5MfX8QXVqrDIOJjrDpbG/QKMd0izYw1s0Ep8FBVrFDeqQnhAfdp
         oMWjbwGV4Gx3yf5ENq2sDBW0P6t/4Vcer51DCKOqaI0ze4v1ieZe7EKhd4JGMxElEiUX
         y6ULMUoXbvhXWQ1Hn8Ya0yI0kGWsjSgW4vy4FfO+Gl0rf98jZTVVsm48Kck0z7hoZC+Q
         RLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oMtA4/Uzs7qD0WVMKCq8uAwCnGJPL6aPI451Jog1qpQ=;
        b=Qi59uDoGfdsgoiU5JVEDc5/1FKTcloxDZW7qJ26VtIOPYt4mNUc54QbPS8/PkJ/b0h
         vz/HqqHmPamtKahvwKru6IgNdfgwjIITEmaF1N3Y6vmwXbmtLS7kecRZH3rM/AgRhI3t
         g5NK+W6kOKOmtXrmVodHYQUbPgLbRzDEiVMbrfmdjirbGpP2bhGu0LwgRPuPJ6RiudBv
         5izrOl5rMu9QYgWdpPwkbCHBSeY2Uew9uC1LH1w69Xs3voOybzDCnK3sBGxcup8vk3vh
         2iQWbh6bB1lo7vXGrTLblAT5WnBuQH+u0I4sUDk9zLAARMkHAosIpOC6wuSmgE9Dwnzu
         7Zgg==
X-Gm-Message-State: AGi0PuY9Nc1BH2wq1u0cXRcK1aet/U7BlUF+FSwePmBfXv2bM7q/DOE/
        hh2uc9vaeY/hUOf3yfcCYAi/TAx6Ce84+0RJS6A=
X-Google-Smtp-Source: APiQypJGMwe5CSMoJ/B0HKwGb1Tv62IwPlwzlSGISa6EGc8EPBjykJHKPHlnBA/u+2LULHQTJwKQzq4rfDL5BJd+620=
X-Received: by 2002:ad4:42c9:: with SMTP id f9mr28680412qvr.228.1588111991461;
 Tue, 28 Apr 2020 15:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200428044628.3772114-1-andriin@fb.com> <20200428044628.3772114-3-andriin@fb.com>
 <20200428164426.xkznwzd3blub2rol@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza7mK8FH0S9S6Jqi37JQFdLjdbeU6u6QiAosoOiVdEMTA@mail.gmail.com> <20200428204155.ycancp6xg2yfisnh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428204155.ycancp6xg2yfisnh@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 15:13:00 -0700
Message-ID: <CAEf4BzbTAm2BWE6zXxr4sjd3E-TSAMMdH_pU+06f4kvMUBdknA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] selftests/bpf: add test_progs-asan flavor
 with AddressSantizer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Julia Kartseva <hex@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 1:41 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 11:35:15AM -0700, Andrii Nakryiko wrote:
> > On Tue, Apr 28, 2020 at 9:44 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Apr 27, 2020 at 09:46:24PM -0700, Andrii Nakryiko wrote:
> > > > Add another flavor of test_progs that is compiled and run with
> > > > AddressSanitizer and LeakSanitizer. This allows to find potential memory
> > > > correction bugs and memory leaks. Due to sometimes not trivial requirements on
> > > > the environment, this is (for now) done as a separate flavor, not by default.
> > > > Eventually I hope to enable it by default.
> > > >
> > > > To run ./test_progs-asan successfully, you need to have libasan installed in
> > > > the system, where version of the package depends on GCC version you have.
> > > > E.g., GCC8 needs libasan5, while GCC7 uses libasan4.
> > > >
> > > > For CentOS 7, to build everything successfully one would need to:
> > > >   $ sudo yum install devtoolset-8-gcc devtoolset-libasan-devel
> > > >
> > > > For Arch Linux to run selftests, one would need to install gcc-libs package to
> > > > get libasan.so.5:
> > > >   $ sudo pacman -S gcc-libs
> > > >
> > > > Cc: Julia Kartseva <hex@fb.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > It needs a feature check.
> > > selftest shouldn't be forcing asan on everyone.
> > > Even after I did:
> > > sudo yum install devtoolset-8-libasan-devel
> > > it still failed to build:
> > >   BINARY   test_progs-asan
> > > /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find libasan_preinit.o: No such file or directory
> > > /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find -lasan
> > >
> >
> > Yeah, it worked for me initially because it still used GCC7 locally
> > and older version of libasan.
> >
> > On CentOS you have to run the following command to set up environment
> > (for current session only, though):
> >
> > $ scl enable devtoolset-8 bash
> >
> > What it does:
> > - adds /opt/rh/devtoolset-8/root/usr/bin to $PATH
> > - sets $LD_LIBRARY_PATH to
> > /opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib:/opt/rh/devtoolset-8/root/usr/lib64/dyninst:/opt/rh/devtoolset-8/root/usr/lib/dyninst:/opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib
>
> I don't want to do this, since I prefer gcc9 for my builds since it has better warnings.
> But yum cannot find devtoolset-9-libasan-devel it seems.

Hmm, strange, there should be devtoolset-9-libasan-devel according to
[0]. No idea.

  [0] https://cbs.centos.org/koji/buildinfo?buildID=27149

>
> > I'm going to add this to patch to ease some pain later. But yeah, I
> > think I have a better plan for ASAN builds. I'll add EXTRA_CFLAGS to
> > selftests Makefile, defaulted to nothing. Then for Travis CI (or
> > locally) one would do:
> >
> > $ make EXTRA_CFLAGS='-fsanitize-address'
> >
> > to build ASAN versions of all the same test runners (including
> > test_verifier, test_maps, etc).
> >
> > I think this will be better overall.
> >
> > > Also I really don't like that skeletons are now built three times for now good reason
> > >   GEN-SKEL [test_progs-asan] test_stack_map.skel.h
> > >   GEN-SKEL [test_progs-asan] test_core_reloc_nesting.skel.h
> > > default vs no_alu32 makes sense. They are different bpf.o files and different skeletons,
> > > but for asan there is no such need.
> >
> > I agree, luckily I don't really have to change anything with the above approach.
> >
> > >
> > > Please resubmit the rest of the patches, since asan isn't a prerequisite.
> >
> > I'll update this patch to just add EXTRA_CFLAGS, if you are ok with
> > this (and will leave instructions on installing libasan).
>
> yeah. EXTRA_CFLAGS approach should work.
> That will build both test_progs and test_progs-no_alu32 with libasan ?
> That would be ideal.

Yep, then everything should be built with ASAN. Ok, will do that then.
