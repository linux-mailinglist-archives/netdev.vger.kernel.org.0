Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F772B67FA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgKQO52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:27 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF574C0613CF;
        Tue, 17 Nov 2020 06:57:27 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so17462434pfn.0;
        Tue, 17 Nov 2020 06:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZbhU2TZHWnqYPBun+qg5b40n++jNQ+4uReZwgRohl7w=;
        b=XLkT5MM+qVOw9DxZT7TR1oQcSX8aRVtDr9ePzUR9Ax7DMlIXk4GZBhg3SWpKYg/lTC
         oNuX1V904DT8EfbRLxnbi/sAdfGCjTov/w7nGKzw1gdFwqZq4FNAGPk71gQL4qS39iNy
         fgnhtTjFMbWMA7eawPWelEr4l1B2ZSHg+JFjIHGLK5LtfC/SaKCm956MHVwmVvPI6ZOM
         yeFfjQN/BU1ml5wt+PnoBp/5TW49Z5vXigNef7MJakcjkpXemeBm7IGXeN3MEpAVRH2N
         MfloGhB2XwBkVH+5q7hN7PnE+oMlMG3++bm5v/AoG6mggHIJOsPM4ZSWJR5xLX2R4oPw
         fLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZbhU2TZHWnqYPBun+qg5b40n++jNQ+4uReZwgRohl7w=;
        b=pDL5e5enqZtD/YF0RafZX70QzBASvtAfNrVzmv7x77XjapPYkLr9qEm0RfxX50w/je
         o0tfu8/eNc6ko3MY7PXF5+SxIhlcoCNlNnqqt1+5blW1iAWNdl40CRziY96z9HCJFvzF
         gF89x5DOdDOixl5aJt7dbhLNRC73K3swsOdrwCEB/b+7wTTyVOGG8SHR1ckAgJG1ORrJ
         JLfcTwScn3DnCMVQGXcEe181JcVvSpaSX1YT3ZooU+UU/uOCNdT+lz7vjsg4OyZVxnMM
         0nyontFaQqin834qYyL8TEOIpL00yNTLyN4QG3BKOW8BxnagdbzkDjxm+K3QMSbnM6jS
         gOQQ==
X-Gm-Message-State: AOAM533zVHswWEV7ZOeSx+lfuZWNWgepoa6x7nAW9zgCElCWHqR3zeq4
        XVvLtx6+ZGFAXSzeCZEgIA==
X-Google-Smtp-Source: ABdhPJxb8duPvwJUwaa79sgTPiR8aevhWaUm8JnB7Ox324ybPBOQqmAIU5Ar0sBY0x8+DT7V6D922w==
X-Received: by 2002:a62:2a8a:0:b029:18b:83c1:60af with SMTP id q132-20020a622a8a0000b029018b83c160afmr19020356pfq.54.1605625047246;
        Tue, 17 Nov 2020 06:57:27 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:26 -0800 (PST)
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
Subject: [PATCH bpf-next 0/9] bpf: remove bpf_load loader completely
Date:   Tue, 17 Nov 2020 14:56:35 +0000
Message-Id: <20201117145644.1166255-1-danieltimlee@gmail.com>
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

Daniel T. Lee (9):
  selftests: bpf: move tracing helpers to trace_helper.h
  samples: bpf: refactor hbm program with libbpf
  samples: bpf: refactor test_cgrp2_sock2 program with libbpf
  samples: bpf: refactor task_fd_query program with libbpf
  samples: bpf: refactor ibumad program with libbpf
  samples: bpf: refactor test_overhead program with libbpf
  samples: bpf: fix lwt_len_hist reusing previous BPF map
  samples: bpf: remove unused trace_helper and bpf_load from Makefile
  samples: bpf: remove bpf_load loader completely

 samples/bpf/.gitignore                      |   3 +
 samples/bpf/Makefile                        |  20 +-
 samples/bpf/bpf_load.c                      | 667 --------------------
 samples/bpf/bpf_load.h                      |  57 --
 samples/bpf/hbm.c                           | 147 ++---
 samples/bpf/hbm_kern.h                      |   2 +-
 samples/bpf/ibumad_kern.c                   |  26 +-
 samples/bpf/ibumad_user.c                   |  66 +-
 samples/bpf/lwt_len_hist.sh                 |   2 +
 samples/bpf/task_fd_query_user.c            | 101 ++-
 samples/bpf/test_cgrp2_sock2.c              |  63 +-
 samples/bpf/test_cgrp2_sock2.sh             |  21 +-
 samples/bpf/test_lwt_bpf.sh                 |   0
 samples/bpf/test_overhead_user.c            |  82 ++-
 samples/bpf/xdp2skb_meta_kern.c             |   2 +-
 tools/testing/selftests/bpf/trace_helpers.c |  33 +-
 tools/testing/selftests/bpf/trace_helpers.h |   3 +
 17 files changed, 368 insertions(+), 927 deletions(-)
 delete mode 100644 samples/bpf/bpf_load.c
 delete mode 100644 samples/bpf/bpf_load.h
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

-- 
2.25.1

