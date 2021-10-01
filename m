Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1B841F807
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhJAXHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhJAXHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:07:17 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43FEC061775;
        Fri,  1 Oct 2021 16:05:32 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id s4so7276215ybs.8;
        Fri, 01 Oct 2021 16:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+DL83G2lhfzTr71KCGrBXQakzOY6YKe5Qux+LpVhBs=;
        b=Y8zJAfbdgqGJLGtEetX3w3yxPr7MBpczMQ1ROQzJ6vgQa2em/c64/xEjUijh5H3V4o
         GYKxH+FvDx3PqJWc4/PpiDmowgyuAnqHmSXq2EFvanN9lnTDiuoInv7F0J22a5IFEV4P
         mNuMvkpS74QapV8z1vnu/B57tdLc3kRHE6mwe9mGhv/AZRrwM351kB9tWeCE2BCeKEHM
         LpK3DNsELiJTCpOBYKebLa5lZcyusNvsAzZLZVcpatSJ0OYj9xcF97GQ/MOdhxSTd0nG
         +IIrNDjXm5Nq5LiJ26pUqTivGBD1cWxZc/WwnHjjAejHAr4wWRKlvOa+g1r7LAIYbDOv
         +9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+DL83G2lhfzTr71KCGrBXQakzOY6YKe5Qux+LpVhBs=;
        b=49ZhKduBsXUGTYVDOOpzDpxqUYIyQz71KLlNwjYXckHbWJwrOqst/s+MALPWAD7hPs
         amFpmdjnBC4fjiUoOkoHsBK6oxeIzlIP52Nr5pBaMtJsdi1+cnmMItn5PR3hafA/Ej1F
         mDI0yHU1sLadyjcIfgwBvZ5I4QS1ropOFllVLiVwPYWJezA+BhNiezbzv6XWWDTeKxav
         5tgg7mUO2Zae5+TAZkZX6hlCZ27vCNIRZgU/lqVJLDGtd/CnFrg0jN6DLOdroBFsyMGp
         S/z/w/YcMekkFeJQmo+ksXpjheML0MyB6E/Awwh1ea5zU7xe4d++t4qiJ0Ws5WdneVOY
         AvhA==
X-Gm-Message-State: AOAM531I+4qQK5ZDkFQDtbpvDh84OqeVNdW39PolZfHrZPamDkAbeXcM
        7i4pF63BOKZuzTM7n7+r632y5CIy6uspOsqWxfUrR3faRhA=
X-Google-Smtp-Source: ABdhPJwcf8Um3koZ+8WKeSuQWR2CVsk+rU6+Fe3JRPK3KVwDi0q8aogBzFsBUojorlc1shkLzTFriMM2StttBxfbmjQ=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr468789ybf.455.1633129531906;
 Fri, 01 Oct 2021 16:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com>
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 16:05:20 -0700
Message-ID: <CAEf4Bza+C5cNJbvw_n_pR_mVL0rPH2VkZd-AJMx78Fp_m+CpRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/9] install libbpf headers when using the library
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
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

The whole sharing of libbpf build artifacts is great, I just want to
point out that it's also dangerous if those multiple Makefiles aren't
ordered properly. E.g., if you build runqslower and the rest of
selftests in parallel without making sure that libbpf already
completed its build, you might end up building libbpf in parallel in
two independent make instances and subsequently corrupting generated
object files. I haven't looked through all the changes (and I'll
confess that it's super hard to reason about dependencies and ordering
in Makefile) and I'll keep this in mind, but wanted to bring this up.
I suspect you already thought about that, but would be worth to call
out this explicitly.

>
> (Not accounting for the boostrap version of libbpf required by bpftool,
> which was already placed under a dedicated .../boostrap/libbpf/ directory,
> and for which the count remains unchanged.)
>
> A few commits in the series also contain drive-by clean-up changes for
> bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. Please
> refer to individual commit logs for details.
>
> v2: Declare an additional dependency on libbpf's headers for
>     iterators/iterators.o in kernel/preload/Makefile to make sure that
>     these headers are exported before we compile the object file (and not
>     just before we link it).
>
> Quentin Monnet (9):
>   tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
>   tools: bpftool: install libbpf headers instead of including the dir
>   tools: resolve_btfids: install libbpf headers when building
>   tools: runqslower: install libbpf headers when building
>   bpf: preload: install libbpf headers when building
>   bpf: iterators: install libbpf headers when building
>   samples/bpf: install libbpf headers when building
>   samples/bpf: update .gitignore
>   selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
>
>  kernel/bpf/preload/Makefile                   | 25 ++++++++++---
>  kernel/bpf/preload/iterators/Makefile         | 18 ++++++----
>  samples/bpf/.gitignore                        |  3 ++
>  samples/bpf/Makefile                          | 36 +++++++++++++------
>  tools/bpf/bpftool/Makefile                    | 27 ++++++++------
>  tools/bpf/bpftool/gen.c                       |  1 -
>  tools/bpf/bpftool/prog.c                      |  1 -
>  tools/bpf/resolve_btfids/Makefile             | 17 ++++++---
>  tools/bpf/resolve_btfids/main.c               |  4 +--
>  tools/bpf/runqslower/Makefile                 | 12 ++++---
>  tools/testing/selftests/bpf/Makefile          | 22 ++++++++----
>  .../selftests/bpf/test_bpftool_build.sh       |  4 +++
>  12 files changed, 116 insertions(+), 54 deletions(-)
>
> --
> 2.30.2
>
