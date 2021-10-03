Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E797420399
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhJCTYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhJCTYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:08 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C1DC0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k21-20020a05600c0b5500b0030d6ac87a80so735770wmr.0
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKUF7N/YCbuMi+0w/FU92xrbDaf/HdbHShy9sQHFuwk=;
        b=vBKwx11DP7kd8AgG1kfxs8YqRhCQJ4Oid1n2aDvRRo0cqb/vBe3HGmt7LxH4L5s037
         XkGpVU7oIxCWd8YZ4qQFuW2qi+nhj9Xlxi09r3IEvCCf0m0QwGjUHyymrBbHJB1o9tJs
         IgNeSCvQKZEGjVluVk4S10nLHAgucAheM4GoK/p4c89xPVZinKP2J0n4ydHQKCZ0BTpu
         Lb0RsS+22fqyV7Ufln9BWO0E6eDK8v6lVAj2+6kkVx1kc3umyHJVLq97Hv+AULcEwYCb
         Ea3Q+JPudrE/fm5OqRQBThix/eq+Zii4/EgeBblRHowp/fJ5Nnwcv530mXAukATx6VXw
         vnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKUF7N/YCbuMi+0w/FU92xrbDaf/HdbHShy9sQHFuwk=;
        b=TvwcYv9n6ectE8m2qAPRF1VYaYwVUZkkHXiHDmWm1kRKQmTBufel6GSOdbNZURQQKv
         aCfeSXjUFa2CQ5vvog+1RgI1WZT0P710w2eBMVay255dzBlIB40QaDOuiVLEFtRaaCey
         Z7avooJzFVJop5vwqvfJzwyEb5OgEcw7pQgPKHC13Q6fua10Kbkyd1gt1CqZGMP2XTiE
         CQdYAqENavpExmPANjH3hlyPSFDua+0OYfrb4ce9GzKxnNZBGnVcoLE0eI0Ar4dwQOEe
         K34U4LsehRsTZQ1wdp91fqPY4h1Oihu2iu+HrXkQ+4ezB6KkEPmUnJYF3II6vdCPQAt1
         PTWA==
X-Gm-Message-State: AOAM532p7zBHPv8hf2mymbEWO4CVCx84wB/vYrldOh2BWO8YtjygQGvY
        n/ZsHL3lr2dixYoqkym69Fur6A==
X-Google-Smtp-Source: ABdhPJw4Zf38Dqs1TuFyf2mb/1lL9pLjAVMuRQdIipmUviusHSz6ncVIfvlHPr7Kz64GfNTYEvzk1g==
X-Received: by 2002:a1c:21d7:: with SMTP id h206mr9927426wmh.23.1633288938720;
        Sun, 03 Oct 2021 12:22:18 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:18 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 00/10] install libbpf headers when using the library
Date:   Sun,  3 Oct 2021 20:21:58 +0100
Message-Id: <20211003192208.6297-1-quentin@isovalent.com>
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

Quentin Monnet (10):
  tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
  tools: bpftool: install libbpf headers instead of including the dir
  tools: resolve_btfids: install libbpf headers when building
  tools: runqslower: install libbpf headers when building
  bpf: preload: install libbpf headers when building
  bpf: iterators: install libbpf headers when building
  samples/bpf: install libbpf headers when building
  samples/bpf: update .gitignore
  selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
  tools: bpftool: add install-bin target to install binary only

 kernel/bpf/preload/Makefile                   | 25 ++++++++---
 kernel/bpf/preload/iterators/Makefile         | 39 ++++++++++++------
 samples/bpf/.gitignore                        |  4 ++
 samples/bpf/Makefile                          | 41 ++++++++++++++-----
 tools/bpf/bpftool/Makefile                    | 32 +++++++++------
 tools/bpf/bpftool/gen.c                       |  1 -
 tools/bpf/bpftool/prog.c                      |  1 -
 tools/bpf/resolve_btfids/Makefile             | 17 +++++---
 tools/bpf/resolve_btfids/main.c               |  4 +-
 tools/bpf/runqslower/Makefile                 | 22 ++++++----
 tools/testing/selftests/bpf/Makefile          | 26 ++++++++----
 .../selftests/bpf/test_bpftool_build.sh       |  4 ++
 12 files changed, 148 insertions(+), 68 deletions(-)

-- 
2.30.2

