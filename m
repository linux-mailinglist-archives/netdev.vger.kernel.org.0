Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3389F42461A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbhJFSaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbhJFSap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:30:45 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA89C061753;
        Wed,  6 Oct 2021 11:28:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r1so7519470ybo.10;
        Wed, 06 Oct 2021 11:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8nCXhQJKkKKuyaxRP+kI4tFBVY7YOkqCOtRp204xus=;
        b=PLfhj187d372xVZMxsd+VzXa750B+FwfdjFJYTFNSvcsAJTWlCuEFjuagMsb3VEVeE
         dPqzKeOb5hBn6v3jnsYJletndhzjN0lHhva9hXQ3YDE9pBUopfhaKVC5iqImYkdc/O+3
         oilT1ld9UqodsLJpDvhBMvogto9mv35U0BeZeMCkTSAfqLRpxtFuEdq53fIm0w8Ae54M
         bgozCVBYH6SGZjghGHSrBrZyiUS3pnLpGzoQOKvgEh3VOhaaqb+/IewCxlylwxe9c7P4
         WPAUfg23TehbkNye2R6AgCXgF16aKK8S+RfkwW36U0w/qiNUlcjNKlmkX9mzs/A/JX66
         uoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8nCXhQJKkKKuyaxRP+kI4tFBVY7YOkqCOtRp204xus=;
        b=tkV0OBeRe4zpbnSzAyMFXn80UVEbIYMsbTOY84T6eXx3fcHEMu8eJZoGqVAMkEpwdY
         iw2ta1+Hmgm6o/VmO6cr5WchK5yYw9ksrlG5CkmH/0XH+S5upjZCkeouL6J5k9ItKW1l
         jmp9bWtTV2awraeeGfeLkQp3Fx4zmj4ks5ZD9SmTY53I202EiSWRshwzGWU/DVYIoYqk
         LQKpwQyH1oMBwXbLeSWkZsmDpk8vd8wWserA/if+ie7++kEj2fxZ8ufYU+kJ57CuBduF
         bYahUQ2iCS6QIQpeL9EIZ7je+6Tqibu3zDLwq6w64v2cyk5k6fHX7+VJyGXM71GdMGCo
         CgyQ==
X-Gm-Message-State: AOAM531/Wxw6QCCcIqhiAYR621Dvd31iDmVtkR2kUTVhbkBkbUFnyoiz
        WX0uIePYATcu9brVXW+WLrm9VVQ5PC4p3eoyj1E=
X-Google-Smtp-Source: ABdhPJxsbMIVL7CHrybwBR/kMDQBVayQJjXHsb/sItuXZ+mMEbPPKxKZgMgN7PEhRkZg+ka8RxwOzvrjUKbS0w4PZKE=
X-Received: by 2002:a25:5606:: with SMTP id k6mr31632955ybb.51.1633544931857;
 Wed, 06 Oct 2021 11:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com>
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:28:40 -0700
Message-ID: <CAEf4Bzb1MftD6KEvBqgs=wR5VVSLrir_tVBPwwvLu2RvW5=tNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] install libbpf headers when using the library
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Libbpf is used at several locations in the repository. Most of the time,
> the tools relying on it build the library in its own directory, and include
> the headers from there. This works, but this is not the cleanest approach.
> It generates objects outside of the directory of the tool which is being
> built, and it also increases the risk that developers include a header file
> internal to libbpf, which is not supposed to be exposed to user
> applications.
>
> This set adjusts all involved Makefiles to make sure that libbpf is built
> locally (with respect to the tool's directory or provided build directory),
> and by ensuring that "make install_headers" is run from libbpf's Makefile
> to export user headers properly.
>
> This comes at a cost: given that the libbpf was so far mostly compiled in
> its own directory by the different components using it, compiling it once
> would be enough for all those components. With the new approach, each
> component compiles its own version. To mitigate this cost, efforts were
> made to reuse the compiled library when possible:
>
> - Make the bpftool version in samples/bpf reuse the library previously
>   compiled for the selftests.
> - Make the bpftool version in BPF selftests reuse the library previously
>   compiled for the selftests.
> - Similarly, make resolve_btfids in BPF selftests reuse the same compiled
>   library.
> - Similarly, make runqslower in BPF selftests reuse the same compiled
>   library; and make it rely on the bpftool version also compiled from the
>   selftests (instead of compiling its own version).
> - runqslower, when compiled independently, needs its own version of
>   bpftool: make them share the same compiled libbpf.
>
> As a result:
>
> - Compiling the samples/bpf should compile libbpf just once.
> - Compiling the BPF selftests should compile libbpf just once.
> - Compiling the kernel (with BTF support) should now lead to compiling
>   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
> - Compiling runqslower individually should compile libbpf just once. Same
>   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.
>
> (Not accounting for the boostrap version of libbpf required by bpftool,
> which was already placed under a dedicated .../boostrap/libbpf/ directory,
> and for which the count remains unchanged.)
>
> A few commits in the series also contain drive-by clean-up changes for
> bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. Please
> refer to individual commit logs for details.
>
> v3:

Please see few problems with libbpf_hdrs phony targets. Seems like
they all can be order-only dependencies and not causing unnecessary
rebuilds.
Can you please also normalize your patch prefixes for bpftool and
other tools? We've been using a short and simple "bpftool: " prefix
for bpftool-related changes, and for other tools it would be just
"tools/runqslower" or "tools/resolve_btfids". Please update
accordingly. Thanks!

>   - Remove order-only dependencies on $(LIBBPF_INCLUDE) (or equivalent)
>     directories, given that they are created by libbpf's Makefile.
>   - Add libbpf as a dependency for bpftool/resolve_btfids/runqslower when
>     they are supposed to reuse a libbpf compiled previously. This is to
>     avoid having several libbpf versions being compiled simultaneously in
>     the same directory with parallel builds. Even if this didn't show up
>     during tests, let's remain on the safe side.
>   - kernel/bpf/preload/Makefile: Rename libbpf-hdrs (dash) dependency as
>     libbpf_hdrs.
>   - samples/bpf/.gitignore: Add bpftool/
>   - samples/bpf/Makefile: Change "/bin/rm -rf" to "$(RM) -r".
>   - samples/bpf/Makefile: Add missing slashes for $(LIBBPF_OUTPUT) and
>     $(LIBBPF_DESTDIR) when buildling bpftool
>   - samples/bpf/Makefile: Add a dependency to libbpf's headers for
>     $(TRACE_HELPERS).
>   - bpftool's Makefile: Use $(LIBBPF) instead of equivalent (but longer)
>     $(LIBBPF_OUTPUT)libbpf.a
>   - BPF iterators' Makefile: build bpftool in .output/bpftool (instead of
>     .output/), add and clean up variables.
>   - runqslower's Makefile: Add an explicit dependency on libbpf's headers
>     to several objects. The dependency is not required (libbpf should have
>     been compiled and so the headers exported through other dependencies
>     for those targets), but they better mark the logical dependency and
>     should help if exporting the headers changed in the future.
>   - New commit to add an "install-bin" target to bpftool, to avoid
>     installing bash completion when buildling BPF iterators and selftests.
>
> v2: Declare an additional dependency on libbpf's headers for
>     iterators/iterators.o in kernel/preload/Makefile to make sure that
>     these headers are exported before we compile the object file (and not
>     just before we link it).
>
> Quentin Monnet (10):
>   tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
>   tools: bpftool: install libbpf headers instead of including the dir
>   tools: resolve_btfids: install libbpf headers when building
>   tools: runqslower: install libbpf headers when building
>   bpf: preload: install libbpf headers when building
>   bpf: iterators: install libbpf headers when building
>   samples/bpf: install libbpf headers when building
>   samples/bpf: update .gitignore
>   selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
>   tools: bpftool: add install-bin target to install binary only
>
>  kernel/bpf/preload/Makefile                   | 25 ++++++++---
>  kernel/bpf/preload/iterators/Makefile         | 39 ++++++++++++------
>  samples/bpf/.gitignore                        |  4 ++
>  samples/bpf/Makefile                          | 41 ++++++++++++++-----
>  tools/bpf/bpftool/Makefile                    | 32 +++++++++------
>  tools/bpf/bpftool/gen.c                       |  1 -
>  tools/bpf/bpftool/prog.c                      |  1 -
>  tools/bpf/resolve_btfids/Makefile             | 17 +++++---
>  tools/bpf/resolve_btfids/main.c               |  4 +-
>  tools/bpf/runqslower/Makefile                 | 22 ++++++----
>  tools/testing/selftests/bpf/Makefile          | 26 ++++++++----
>  .../selftests/bpf/test_bpftool_build.sh       |  4 ++
>  12 files changed, 148 insertions(+), 68 deletions(-)
>
> --
> 2.30.2
>
