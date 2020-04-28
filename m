Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FCF1BCD9B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgD1Ul7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD1Ul6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:41:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DACC03C1AB;
        Tue, 28 Apr 2020 13:41:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hi11so12220pjb.3;
        Tue, 28 Apr 2020 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/A1mmPhk95F1kK7eIrAAOKxyq4i9bhj5CZTB/ZoKa8=;
        b=nDvbOLXijjakYJ7RS6ftgxXw9lzE5/tsAFdYjbIu/MZVVgaPhveMLo2Lp/+mMCmDYr
         CqVxJIdHC7dJwvPxuHdqSnJeTpDDA3CRmnHdUx5q72jqcxhX2VVYNdpad8+QtGGMHIto
         rlMBfaGQzpPGL4VGCC9oZiXrRVMGY7SvYKx2+0Bgp4F1cULn/UEnWnB194+/ULbIcVoB
         MCgRWc8rd95kJksZ5kfYdHyo2RsRziDetyUMYwTwKaOYTuFfSEaOQmPvTaVtFWYAwrZl
         AoWYaiOsBR7z3+5RuewgTxv2CV+wmnwQ6ivL3cmhwXVZMXI4bJb8fBFyD1/YCwVh1r7A
         t0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/A1mmPhk95F1kK7eIrAAOKxyq4i9bhj5CZTB/ZoKa8=;
        b=iVQhAeLwPrXAMdSutGwgG4cdJyhW9NAoyk+7ss7wVWN/tNcSBjNTqPez6UHvo8kr7c
         1KwIO6z8uCr0bsN/VENLSVMrqHc1J4zc7hryvL+3PM/aXHKB0Nuy3IyFw5LSX+ZNtSRo
         Hr+87sjDgsszRGKcxS5K39Qi8VZu/DH5GE8rwIS7+85qxrpD5y1apJ0kTqU7WCyiD4AH
         McuEV1zEAxsADSA6Q6vzHRUx4ISGEtSPOB36mBlOMD+s2pZv//BiCWNdfI/MGjpxiPpO
         CgeAlibpVzDlIssQ5wvQwsovphoEpkDDQZueHi7FvLnOaqZyn7xVl3zH0ZjOIAT13KM3
         QppQ==
X-Gm-Message-State: AGi0PubhxHydHb9IrPGLaL5EO6Xz2dGms17VnFGhKPWTnefGtc2Az4XA
        8RJjHCObIm67pstGOCDTlbs=
X-Google-Smtp-Source: APiQypIRgcqv7de1n5hPOoGENwmBOrRRRKv0tksAqxv72odPC6LImjGn3ZYfiKgQICv2P2pXel0lIg==
X-Received: by 2002:a17:902:d70f:: with SMTP id w15mr12029473ply.55.1588106517951;
        Tue, 28 Apr 2020 13:41:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id 199sm4265921pgc.39.2020.04.28.13.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 13:41:57 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:41:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Julia Kartseva <hex@fb.com>
Subject: Re: [PATCH bpf-next 2/6] selftests/bpf: add test_progs-asan flavor
 with AddressSantizer
Message-ID: <20200428204155.ycancp6xg2yfisnh@ast-mbp.dhcp.thefacebook.com>
References: <20200428044628.3772114-1-andriin@fb.com>
 <20200428044628.3772114-3-andriin@fb.com>
 <20200428164426.xkznwzd3blub2rol@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza7mK8FH0S9S6Jqi37JQFdLjdbeU6u6QiAosoOiVdEMTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza7mK8FH0S9S6Jqi37JQFdLjdbeU6u6QiAosoOiVdEMTA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:35:15AM -0700, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 9:44 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 27, 2020 at 09:46:24PM -0700, Andrii Nakryiko wrote:
> > > Add another flavor of test_progs that is compiled and run with
> > > AddressSanitizer and LeakSanitizer. This allows to find potential memory
> > > correction bugs and memory leaks. Due to sometimes not trivial requirements on
> > > the environment, this is (for now) done as a separate flavor, not by default.
> > > Eventually I hope to enable it by default.
> > >
> > > To run ./test_progs-asan successfully, you need to have libasan installed in
> > > the system, where version of the package depends on GCC version you have.
> > > E.g., GCC8 needs libasan5, while GCC7 uses libasan4.
> > >
> > > For CentOS 7, to build everything successfully one would need to:
> > >   $ sudo yum install devtoolset-8-gcc devtoolset-libasan-devel
> > >
> > > For Arch Linux to run selftests, one would need to install gcc-libs package to
> > > get libasan.so.5:
> > >   $ sudo pacman -S gcc-libs
> > >
> > > Cc: Julia Kartseva <hex@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > It needs a feature check.
> > selftest shouldn't be forcing asan on everyone.
> > Even after I did:
> > sudo yum install devtoolset-8-libasan-devel
> > it still failed to build:
> >   BINARY   test_progs-asan
> > /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find libasan_preinit.o: No such file or directory
> > /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find -lasan
> >
> 
> Yeah, it worked for me initially because it still used GCC7 locally
> and older version of libasan.
> 
> On CentOS you have to run the following command to set up environment
> (for current session only, though):
> 
> $ scl enable devtoolset-8 bash
> 
> What it does:
> - adds /opt/rh/devtoolset-8/root/usr/bin to $PATH
> - sets $LD_LIBRARY_PATH to
> /opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib:/opt/rh/devtoolset-8/root/usr/lib64/dyninst:/opt/rh/devtoolset-8/root/usr/lib/dyninst:/opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib

I don't want to do this, since I prefer gcc9 for my builds since it has better warnings.
But yum cannot find devtoolset-9-libasan-devel it seems.

> I'm going to add this to patch to ease some pain later. But yeah, I
> think I have a better plan for ASAN builds. I'll add EXTRA_CFLAGS to
> selftests Makefile, defaulted to nothing. Then for Travis CI (or
> locally) one would do:
> 
> $ make EXTRA_CFLAGS='-fsanitize-address'
> 
> to build ASAN versions of all the same test runners (including
> test_verifier, test_maps, etc).
> 
> I think this will be better overall.
> 
> > Also I really don't like that skeletons are now built three times for now good reason
> >   GEN-SKEL [test_progs-asan] test_stack_map.skel.h
> >   GEN-SKEL [test_progs-asan] test_core_reloc_nesting.skel.h
> > default vs no_alu32 makes sense. They are different bpf.o files and different skeletons,
> > but for asan there is no such need.
> 
> I agree, luckily I don't really have to change anything with the above approach.
> 
> >
> > Please resubmit the rest of the patches, since asan isn't a prerequisite.
> 
> I'll update this patch to just add EXTRA_CFLAGS, if you are ok with
> this (and will leave instructions on installing libasan).

yeah. EXTRA_CFLAGS approach should work.
That will build both test_progs and test_progs-no_alu32 with libasan ?
That would be ideal.
