Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5BA1BCAB9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgD1Sf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730254AbgD1Sf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:35:27 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62047C03C1AB;
        Tue, 28 Apr 2020 11:35:27 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b188so21263830qkd.9;
        Tue, 28 Apr 2020 11:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P/Yy7fhBlAsiT5vsaC3F1jeDsjx2gQwP5nwUdg7CMcQ=;
        b=N/+/aw1WUYNw87C4Wh9Rnu6hcmrI2PKDe+khHwWlk4H0nFbvM1bIZ84EQa9ysh3ZaA
         /uudFwLJUYJe9TeC9LEbOcNy7HSJfKTFiFRhrTNR1BJWur/98X8zXZSKFbTJxYAOj18m
         dzwxJ/GY5P2Jd9oQfMEfPJz2UAALHxtzPhCkeg7UJhXyjOl7i1KnpVrvgKRUeNdfaJD4
         kh9vkb/zhYTbtTFSDQecoK0UXlPZeqtDWwH/dLB98rC9uq7Ixmv0wlXMKNGVWmZVVe5s
         yfMzK1OPZZKZkaYgbTAIM8lUhor++FhQ2wb+vUjMcedfBbZEm0OOFCwjElnMFGEy5trv
         S6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P/Yy7fhBlAsiT5vsaC3F1jeDsjx2gQwP5nwUdg7CMcQ=;
        b=LjuRKjcaSVDYcYI5bwj/HC8BSCiUspoTpA++GWBaLSmtZYDdScm8Zd2LbsVpqNPPGq
         yILt6Y8U2gGUVIezSlAGOREo8v4OptF8C6+pT48+UIG2qk+yyRx0bqjVUMGWjOjPlSbM
         SDDHtRRepXKhfpGcw1MiJ68dYiJSnYWr9+tqf8ypqm41CwQBl6LEBcGcloYdI9Nq1B6L
         RGmT86h+nWq1QGuy1jKmW2atiYQ0MGAV7dd+CfonA0e/+sQ7xDEdc3O3nUsQwvlrq/4H
         DHwY0s5gXY3c7bq7N3GJXpA2JGVLzpSH6MsJHQg60Gd0txrSkHS8bPMieAmn3eSofyfS
         tBEA==
X-Gm-Message-State: AGi0PuZcds4Nkkes4DWrwv+D7GPMUyBPppCnN0KNe3ctVXP9exoOdP1B
        uVuqsYBiEVsaN4Tpo65AKLetggZZSLAU7HTXEDk=
X-Google-Smtp-Source: APiQypIWKfhSHsLtlSDf6HmeEUIDwoYtZ7zWivNIl+fpyyVK+ghOs5YyhqIE3rnmhO8dCuQ5twv+doY/5wFBtXwZYGs=
X-Received: by 2002:ae9:eb8c:: with SMTP id b134mr29431920qkg.39.1588098926398;
 Tue, 28 Apr 2020 11:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200428044628.3772114-1-andriin@fb.com> <20200428044628.3772114-3-andriin@fb.com>
 <20200428164426.xkznwzd3blub2rol@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428164426.xkznwzd3blub2rol@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 11:35:15 -0700
Message-ID: <CAEf4Bza7mK8FH0S9S6Jqi37JQFdLjdbeU6u6QiAosoOiVdEMTA@mail.gmail.com>
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

On Tue, Apr 28, 2020 at 9:44 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 27, 2020 at 09:46:24PM -0700, Andrii Nakryiko wrote:
> > Add another flavor of test_progs that is compiled and run with
> > AddressSanitizer and LeakSanitizer. This allows to find potential memory
> > correction bugs and memory leaks. Due to sometimes not trivial requirements on
> > the environment, this is (for now) done as a separate flavor, not by default.
> > Eventually I hope to enable it by default.
> >
> > To run ./test_progs-asan successfully, you need to have libasan installed in
> > the system, where version of the package depends on GCC version you have.
> > E.g., GCC8 needs libasan5, while GCC7 uses libasan4.
> >
> > For CentOS 7, to build everything successfully one would need to:
> >   $ sudo yum install devtoolset-8-gcc devtoolset-libasan-devel
> >
> > For Arch Linux to run selftests, one would need to install gcc-libs package to
> > get libasan.so.5:
> >   $ sudo pacman -S gcc-libs
> >
> > Cc: Julia Kartseva <hex@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> It needs a feature check.
> selftest shouldn't be forcing asan on everyone.
> Even after I did:
> sudo yum install devtoolset-8-libasan-devel
> it still failed to build:
>   BINARY   test_progs-asan
> /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find libasan_preinit.o: No such file or directory
> /opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: cannot find -lasan
>

Yeah, it worked for me initially because it still used GCC7 locally
and older version of libasan.

On CentOS you have to run the following command to set up environment
(for current session only, though):

$ scl enable devtoolset-8 bash

What it does:
- adds /opt/rh/devtoolset-8/root/usr/bin to $PATH
- sets $LD_LIBRARY_PATH to
/opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib:/opt/rh/devtoolset-8/root/usr/lib64/dyninst:/opt/rh/devtoolset-8/root/usr/lib/dyninst:/opt/rh/devtoolset-8/root/usr/lib64:/opt/rh/devtoolset-8/root/usr/lib

I'm going to add this to patch to ease some pain later. But yeah, I
think I have a better plan for ASAN builds. I'll add EXTRA_CFLAGS to
selftests Makefile, defaulted to nothing. Then for Travis CI (or
locally) one would do:

$ make EXTRA_CFLAGS='-fsanitize-address'

to build ASAN versions of all the same test runners (including
test_verifier, test_maps, etc).

I think this will be better overall.

> Also I really don't like that skeletons are now built three times for now good reason
>   GEN-SKEL [test_progs-asan] test_stack_map.skel.h
>   GEN-SKEL [test_progs-asan] test_core_reloc_nesting.skel.h
> default vs no_alu32 makes sense. They are different bpf.o files and different skeletons,
> but for asan there is no such need.

I agree, luckily I don't really have to change anything with the above approach.

>
> Please resubmit the rest of the patches, since asan isn't a prerequisite.

I'll update this patch to just add EXTRA_CFLAGS, if you are ok with
this (and will leave instructions on installing libasan).
