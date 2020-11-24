Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D192C20BE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbgKXJDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgKXJDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:21 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C059C0613D6;
        Tue, 24 Nov 2020 01:03:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id n137so7818462pfd.3;
        Tue, 24 Nov 2020 01:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiLd0/TSwe2nuoLJss8waB08tybiqKtSb+1THieScy0=;
        b=dKu27BjEBhXB/oREyktx+6rQX5UrULhoij+0lIf4zJV4igyu8rF5ItzD2SJF91Lme1
         CewIye0LpSP8UU4C1ncnwAR5P3GyYmq6xzoDBwrsPzOrJronmxcZW/aeV2QgdWnMlQXV
         CUgzxioP3IR+fUMk9m7sWiRtL+rNO+GHMZJMn5MNZh6GJlqQNYjo5y78QuyszCCv6CT/
         Ug5ANkcfUkr5yp0l8NLJOYmDuyRquAHUuUnRkbOY/9aW82A8po/m2fJZE0uozMW6o8xy
         i45rps3aFebsMreJV29F7cInYkSqsgCassOyqFZZc4DtnYeHukN5Eh7NO2UUa6KCaYDc
         UoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiLd0/TSwe2nuoLJss8waB08tybiqKtSb+1THieScy0=;
        b=CQCufjr++Cl12dpfxdf7TPBy2Mf5BfpVbtzO1HlMeuRtuFG+yFYYDibSOAayrAP7w0
         mVcp+PIYOBJqoeAK5BnCnFsrt42mLkw5PkPzIOA7DowrrrsXyHTshTAFunmNRHk+HjzH
         ivap0GQ3YdRbcY7BO+y2fTPQy1vOs3gE8ccFdtzFeRLpD/CW4/cgUeuLSF2rFFcsM/Ix
         Hdr+yYduOYogv2FMlHDdPuTP3jV+J8fy4MGfDpu9F2gF8kaMb6MT7lIC57TL1GZM5LCo
         Ev6Rm7pXyoZyN/2eudDR3zvwd3CfCOmYN66RsoAskZlIQDYxldxODNHbHuExsz/R79hO
         osVQ==
X-Gm-Message-State: AOAM531pV94mz4+YtvewL5+TrjiMvALCSv8Vr1cPENY33YNgPO3p53Dz
        ESnA758kksJzD/SgH1aREpQru/hHavkg
X-Google-Smtp-Source: ABdhPJx/L8pqKN8Hysfiagr9yYREtEj4YyUcM2LdRFuyfHpkYe5/BY53sfyWrPhgKP+8yax+ChtLlg==
X-Received: by 2002:a63:e:: with SMTP id 14mr2889143pga.253.1606208600851;
        Tue, 24 Nov 2020 01:03:20 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:20 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v3 0/7] bpf: remove bpf_load loader completely
Date:   Tue, 24 Nov 2020 09:03:03 +0000
Message-Id: <20201124090310.24374-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Numerous refactoring that rewrites BPF programs written with bpf_load
to use the libbpf loader was finally completed, resulting in BPF
programs using bpf_load within the kernel being completely no longer
present.

This patchset refactors remaining bpf programs with libbpf and
completely removes bpf_load, an outdated bpf loader that is difficult
to keep up with the latest kernel BPF and causes confusion.

Changes in v2:
 - drop 'move tracing helpers to trace_helper' patch
 - add link pinning to prevent cleaning up on process exit
 - add static at global variable and remove unused variable
 - change to destroy link even after link__pin()
 - fix return error code on exit
 - merge commit with changing Makefile

Changes in v3:
 - cleanup bpf_link, bpf_object and cgroup fd both on success and error

Daniel T. Lee (7):
  samples: bpf: refactor hbm program with libbpf
  samples: bpf: refactor test_cgrp2_sock2 program with libbpf
  samples: bpf: refactor task_fd_query program with libbpf
  samples: bpf: refactor ibumad program with libbpf
  samples: bpf: refactor test_overhead program with libbpf
  samples: bpf: fix lwt_len_hist reusing previous BPF map
  samples: bpf: remove bpf_load loader completely

 samples/bpf/.gitignore           |   3 +
 samples/bpf/Makefile             |  20 +-
 samples/bpf/bpf_load.c           | 667 -------------------------------
 samples/bpf/bpf_load.h           |  57 ---
 samples/bpf/do_hbm_test.sh       |  32 +-
 samples/bpf/hbm.c                | 111 ++---
 samples/bpf/hbm_kern.h           |   2 +-
 samples/bpf/ibumad_kern.c        |  26 +-
 samples/bpf/ibumad_user.c        |  71 +++-
 samples/bpf/lwt_len_hist.sh      |   2 +
 samples/bpf/task_fd_query_user.c | 101 +++--
 samples/bpf/test_cgrp2_sock2.c   |  61 ++-
 samples/bpf/test_cgrp2_sock2.sh  |  21 +-
 samples/bpf/test_lwt_bpf.sh      |   0
 samples/bpf/test_overhead_user.c |  82 ++--
 samples/bpf/xdp2skb_meta_kern.c  |   2 +-
 16 files changed, 350 insertions(+), 908 deletions(-)
 delete mode 100644 samples/bpf/bpf_load.c
 delete mode 100644 samples/bpf/bpf_load.h
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

-- 
2.25.1

