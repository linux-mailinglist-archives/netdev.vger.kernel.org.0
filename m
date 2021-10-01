Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94B041EB6B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352819AbhJALLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhJALLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D19C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u18so14888245wrg.5
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JvLJxK3P0GCoXF/oSZwFSUmuC1DetqjiPtOivAS6OGs=;
        b=AI+X2y1j55CiaVoomGtMVbhadhugcZ5GjJkdIlSn46tPxLm/tLpPU4Vb7RMpnfkoxJ
         +raMsiN5ei1bBNy1c0UV3RRka7L7R5FknSNGaLQ5dKuMCuzpc3q1S8j+/2pBuqkMrOTf
         pGJfpMgrZVKTlXMYELaMV2LtS8rQOwR64qVPgZmxIuEC3QfSfcoeULwNaFtrBLq/7oKx
         iWAuFKhSrRHyaEC8hurHUCJlSwKwLJnBnHUeyqUxerO9qPKIDvErYiw0zuoY6VXSpFiA
         hdLmJ6YXxHDztvICR1hGD3nt4xZUoJIWEuytS2BvOYMe4V5VGSN067YeUYmdyzgithi/
         +QIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JvLJxK3P0GCoXF/oSZwFSUmuC1DetqjiPtOivAS6OGs=;
        b=ttWD8OodwmiU8dDloHu9DysG5+IZnCZhmAeukk2HfFPz8xQCpK6OBZEsAQAHg2nn+O
         F0a4x76QUBn5JOJblGQmPCvjkbLLsC2uGi/0Gdj7wSTU06CZ5izUO+OkU5luLaKsy3L1
         /USdW8ualU1qPeK1kYJNMhE1SYc+zuzgHTrfwwrSIfDWUuStCombglBzhK9+BIYp6V8u
         9F+Gks8a7m/rYzNr5B1oaeUSScqcZ4luGhJ632gFf02PbbObPz1ID5IFI0LFuWmYQ0YQ
         eyp0pHeiFBmDKzzsSjV8RnYJjvq+x8SRkP/KeQ5IWff1FKhqTMhi47u2dOCxBJcYf7uy
         W92A==
X-Gm-Message-State: AOAM530x4Cx5yYsZ0NUyOv3OwkomPewgiiLOlYjjW3kZiKqSWbCTWW3T
        uZNDKhnMHsk/5aG8lDYePlydNA==
X-Google-Smtp-Source: ABdhPJzDAqPiplVc8X0Gup4fej9D4oL2TDVeXV76EF6uEBiNJEOFcCl/DDlkyvOKjelvIEjqfQWaig==
X-Received: by 2002:adf:e906:: with SMTP id f6mr11705333wrm.207.1633086561015;
        Fri, 01 Oct 2021 04:09:21 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:20 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/9] install libbpf headers when using the library
Date:   Fri,  1 Oct 2021 12:08:47 +0100
Message-Id: <20211001110856.14730-1-quentin@isovalent.com>
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

v2: Declare an additional dependency on libbpf's headers for
    iterators/iterators.o in kernel/preload/Makefile to make sure that
    these headers are exported before we compile the object file (and not
    just before we link it).

Quentin Monnet (9):
  tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
  tools: bpftool: install libbpf headers instead of including the dir
  tools: resolve_btfids: install libbpf headers when building
  tools: runqslower: install libbpf headers when building
  bpf: preload: install libbpf headers when building
  bpf: iterators: install libbpf headers when building
  samples/bpf: install libbpf headers when building
  samples/bpf: update .gitignore
  selftests/bpf: better clean up for runqslower in test_bpftool_build.sh

 kernel/bpf/preload/Makefile                   | 25 ++++++++++---
 kernel/bpf/preload/iterators/Makefile         | 18 ++++++----
 samples/bpf/.gitignore                        |  3 ++
 samples/bpf/Makefile                          | 36 +++++++++++++------
 tools/bpf/bpftool/Makefile                    | 27 ++++++++------
 tools/bpf/bpftool/gen.c                       |  1 -
 tools/bpf/bpftool/prog.c                      |  1 -
 tools/bpf/resolve_btfids/Makefile             | 17 ++++++---
 tools/bpf/resolve_btfids/main.c               |  4 +--
 tools/bpf/runqslower/Makefile                 | 12 ++++---
 tools/testing/selftests/bpf/Makefile          | 22 ++++++++----
 .../selftests/bpf/test_bpftool_build.sh       |  4 +++
 12 files changed, 116 insertions(+), 54 deletions(-)

-- 
2.30.2

