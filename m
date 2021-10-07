Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B9F425C74
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhJGTqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhJGTqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50CEC061755
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:47 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v25so22394022wra.2
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r28qX9w0iLLDpADw6g4H4gWjYU6PdqhFTlbNMC9M+qM=;
        b=f3/Y014jipi5SfoL2Q/zhyi6V5r6cixmDZz14c+LOdgkvjmtdlKwweoaKHLhSfB6fy
         Pxu03R5Nwi3rQoXtzHfgBc+Khp5gnUqa4SLJltMrBaeMTy8/2bcPemZvx7QuvCgs5qGz
         CpjuoqlGGk04Fmk3d8LJrY3Gqva5eukk1uBMPghh9HaFLOnTTDAJDwAFam5r+Q8+7X6g
         tkoxepXf6Hk8aUCYWRrHwk79H8nme971zA43VRnS7v2e4PmSn7teKoTCXVDpt7pceV43
         Z5hVpw+dKPs8mYYgwI/hF7/TBm1MwxRcs8nIoWjDk7jKGddXl2jmpKEcVj1NerRvlsFb
         PsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r28qX9w0iLLDpADw6g4H4gWjYU6PdqhFTlbNMC9M+qM=;
        b=RHiCVfzYO6NnKhnuSFCEUo1S1YS7YWPPQ+art2Ug/dNu7SqWgXH+fFYp0pHOf9ka9Z
         3tPa+83iwdLOd6wiJqrNKTnOwnd7WH35cDxNfgTU/wdBzzduqpPQ5loOYCjY6T2dhZzC
         tJ40SR3wuEvu01sJbqxmxF5JZ1EZGKAJ/X1iNWD8i+s5AxFfbV4KsxAOuzel+4YyP+Av
         kJIw8PaSTzWeAcWykcERYYTcYNvux8iUp99pxObvuGLHonmSwJAeXqzLoihBT2i573F9
         uXPlqQmxlR6M8N9uKVu1HmlcUr6LqkL1ZbFV16z10BsukZhYoO4EM/BUHRgu9VqpV/fm
         JygQ==
X-Gm-Message-State: AOAM531tTcNqC415nHH82yPwbnK28ovIIb5wYOxsTH1j/zhygfBAmuAk
        2scbahL8xZKmLpxx/QUZvAxZYg==
X-Google-Smtp-Source: ABdhPJyV4HK/n9JJzbaiH3gvOjfrf3kgZlPSCQL9vLTNaM9nY2zd4AQwSDJZ8Z7ZHFfEW2XAoSuyRA==
X-Received: by 2002:a05:6000:15c3:: with SMTP id y3mr7820369wry.7.1633635886362;
        Thu, 07 Oct 2021 12:44:46 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:46 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 00/12] install libbpf headers when using the library
Date:   Thu,  7 Oct 2021 20:44:26 +0100
Message-Id: <20211007194438.34443-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf is used at several locations in the repository. Most of the time,
the tools relying on it build the library in its own directory, and include
the headers from there. This works, but this is not the cleanest approach.
It generates objects outside of the directory of the tool which is being
built, and it also increases the risk that developers include a header file
internal to libbpf, which is not supposed to be exposed to user
applications.

This set adjusts all involved Makefiles to make sure that libbpf is built
locally (with respect to the tool's directory or provided build directory),
and by ensuring that "make install_headers" is run from libbpf's Makefile
to export user headers properly.

This comes at a cost: given that the libbpf was so far mostly compiled in
its own directory by the different components using it, compiling it once
would be enough for all those components. With the new approach, each
component compiles its own version. To mitigate this cost, efforts were
made to reuse the compiled library when possible:

- Make the bpftool version in samples/bpf reuse the library previously
  compiled for the selftests.
- Make the bpftool version in BPF selftests reuse the library previously
  compiled for the selftests.
- Similarly, make resolve_btfids in BPF selftests reuse the same compiled
  library.
- Similarly, make runqslower in BPF selftests reuse the same compiled
  library; and make it rely on the bpftool version also compiled from the
  selftests (instead of compiling its own version).
- runqslower, when compiled independently, needs its own version of
  bpftool: make them share the same compiled libbpf.

As a result:

- Compiling the samples/bpf should compile libbpf just once.
- Compiling the BPF selftests should compile libbpf just once.
- Compiling the kernel (with BTF support) should now lead to compiling
  libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
- Compiling runqslower individually should compile libbpf just once. Same
  thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.

(Not accounting for the boostrap version of libbpf required by bpftool,
which was already placed under a dedicated .../boostrap/libbpf/ directory,
and for which the count remains unchanged.)

A few commits in the series also contain drive-by clean-up changes for
bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. Please
refer to individual commit logs for details.

v4:
  - Make the "libbpf_hdrs" dependency an order-only dependency in
    kernel/bpf/preload/Makefile, samples/bpf/Makefile, and
    tools/bpf/runqslower/Makefile. This is to avoid to unconditionally
    recompile the targets.
  - samples/bpf/.gitignore: prefix objects with a "/" to mark that we
    ignore them when at the root of the samples/bpf/ directory.
  - libbpf: add a commit to make "install_headers" depend on the header
    files, to avoid exporting again if the sources are older than the
    targets. This ensures that applications relying on those headers are
    not rebuilt unnecessarily.
  - bpftool: uncouple the copy of nlattr.h from libbpf target, to have it
    depend on the source header itself. By avoiding to reinstall this
    header every time, we avoid unnecessary builds of bpftool.
  - samples/bpf: Add a new commit to remove the FORCE dependency for
    libbpf, and replace it with a "$(wildcard ...)" on the .c/.h files in
    libbpf's directory. This is to avoid always recompiling libbpf/bpftool.
  - Adjust prefixes in commit subjects.

v3:
  - Remove order-only dependencies on $(LIBBPF_INCLUDE) (or equivalent)
    directories, given that they are created by libbpf's Makefile.
  - Add libbpf as a dependency for bpftool/resolve_btfids/runqslower when
    they are supposed to reuse a libbpf compiled previously. This is to
    avoid having several libbpf versions being compiled simultaneously in
    the same directory with parallel builds. Even if this didn't show up
    during tests, let's remain on the safe side.
  - kernel/bpf/preload/Makefile: Rename libbpf-hdrs (dash) dependency as
    libbpf_hdrs.
  - samples/bpf/.gitignore: Add bpftool/
  - samples/bpf/Makefile: Change "/bin/rm -rf" to "$(RM) -r".
  - samples/bpf/Makefile: Add missing slashes for $(LIBBPF_OUTPUT) and
    $(LIBBPF_DESTDIR) when buildling bpftool
  - samples/bpf/Makefile: Add a dependency to libbpf's headers for
    $(TRACE_HELPERS).
  - bpftool's Makefile: Use $(LIBBPF) instead of equivalent (but longer)
    $(LIBBPF_OUTPUT)libbpf.a
  - BPF iterators' Makefile: build bpftool in .output/bpftool (instead of
    .output/), add and clean up variables.
  - runqslower's Makefile: Add an explicit dependency on libbpf's headers
    to several objects. The dependency is not required (libbpf should have
    been compiled and so the headers exported through other dependencies
    for those targets), but they better mark the logical dependency and
    should help if exporting the headers changed in the future.
  - New commit to add an "install-bin" target to bpftool, to avoid
    installing bash completion when buildling BPF iterators and selftests.

v2: Declare an additional dependency on libbpf's headers for
    iterators/iterators.o in kernel/preload/Makefile to make sure that
    these headers are exported before we compile the object file (and not
    just before we link it).

Quentin Monnet (12):
  libbpf: skip re-installing headers file if source is older than target
  bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
  bpftool: install libbpf headers instead of including the dir
  tools/resolve_btfids: install libbpf headers when building
  tools/runqslower: install libbpf headers when building
  bpf: preload: install libbpf headers when building
  bpf: iterators: install libbpf headers when building
  samples/bpf: update .gitignore
  samples/bpf: install libbpf headers when building
  samples/bpf: do not FORCE-recompile libbpf
  selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
  bpftool: add install-bin target to install binary only

 kernel/bpf/preload/Makefile                   | 25 ++++++++---
 kernel/bpf/preload/iterators/Makefile         | 39 +++++++++++------
 samples/bpf/.gitignore                        |  4 ++
 samples/bpf/Makefile                          | 42 ++++++++++++++-----
 tools/bpf/bpftool/Makefile                    | 39 ++++++++++-------
 tools/bpf/bpftool/gen.c                       |  1 -
 tools/bpf/bpftool/prog.c                      |  1 -
 tools/bpf/resolve_btfids/Makefile             | 17 +++++---
 tools/bpf/resolve_btfids/main.c               |  4 +-
 tools/bpf/runqslower/Makefile                 | 22 ++++++----
 tools/lib/bpf/Makefile                        | 24 +++++++----
 tools/testing/selftests/bpf/Makefile          | 26 ++++++++----
 .../selftests/bpf/test_bpftool_build.sh       |  4 ++
 13 files changed, 171 insertions(+), 77 deletions(-)

-- 
2.30.2

