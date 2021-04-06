Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C00355BC9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhDFSyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbhDFSyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:54:50 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F160C06174A;
        Tue,  6 Apr 2021 11:54:40 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id n44so2671827qvg.12;
        Tue, 06 Apr 2021 11:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mq4zboVwgG7RX/zWtMqfC1lbGCW4ytsyD+Jtu8rxp4Q=;
        b=KGb3I7tY0ieqRMPjgNri6Kauk+AB1DD1L3RI6yu19lY/UE457TaZa9bANwsYVmFLB+
         FJRQuO9LYk681h1UOsfQYVx2cbsvwb4xdT7hh4kpjDP1ZiZ1tVjtnjtRW8ZUp8/YRc5d
         vct/it8nQUTBSRI8wSbToLT5+wLw40SkWwDRnKjodTKkI/kkPzZNbPUsnf2lN51wdRxC
         bqOcSpfWUi2PrB10K3mXLaxCyZ9gv50pLR96eWq601lKi9UgAU36PQVpczp5O1Dp8oDD
         61WMwDZo77O6YIiDDD8rqmTjYt4q3+grZN3fW2xHXD+BG6Y+eG3Ypn0eKwthq5iszdRa
         v4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mq4zboVwgG7RX/zWtMqfC1lbGCW4ytsyD+Jtu8rxp4Q=;
        b=UKrg9/psFBAuxR7XN5bdjLgtaRgUkj6rjQbT6S/QTyHBP6okGzCDD4Aw2XaUO8vDqC
         Zw1/ieaq1P3CBlzHjVc1l8tmpmBFjU2hD1mnk3FlarI7gIEk4ekYNOassywDjMzyiW83
         ksC+ZJ8qldigaZBnEP7pTXXRHmuaV9I+iSb69+THqLCVfLrVge3+v2BqUHUP4VzvVzPT
         WtK2L2LbGWjECC9IjbssQ79E+8Dy/d6grQkfJ660WBjtfZqlvjg1e1qm6bVAlS2qzHEU
         8hV/fkSuc3EakGLHIT0FjZ1ILF64R2LQO4gXSwqr/5SKhhpj3V/2KLkQOQM/9DDlyggr
         zSNg==
X-Gm-Message-State: AOAM531k+TZUvgpueSWNzVkeqTaGAjy13CGAixQfLuMRjBpLSXrdDKYg
        eYU1fth0i04RbqZKxG1rTpQ=
X-Google-Smtp-Source: ABdhPJxAFMdsKBkliMghidiCHHzY0b/fu9Y9pGy3RHy8D8ehZqkWvYDjz3XOuUsfsQjUTz+ffTUa8Q==
X-Received: by 2002:a0c:8b12:: with SMTP id q18mr30398917qva.51.1617735279536;
        Tue, 06 Apr 2021 11:54:39 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a19sm16581652qkl.126.2021.04.06.11.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:54:39 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v2 0/3] add batched ops support for percpu
Date:   Tue,  6 Apr 2021 15:53:51 -0300
Message-Id: <20210406185400.377293-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces batched operations for the per-cpu variant of
the array map.

It also introduces a standard way to define per-cpu values via the
'BPF_PERCPU_TYPE()' macro, which handles the alignment transparently.
This was already implemented in the selftests and was merely refactored
out to libbpf, with some simplifications for reuse.

The tests were updated to reflect all the new changes.

v1 -> v2:
- Amended a more descriptive commit message

Pedro Tammela (3):
  bpf: add batched ops support for percpu array
  libbpf: selftests: refactor 'BPF_PERCPU_TYPE()' and 'bpf_percpu()'
    macros
  bpf: selftests: update array map tests for per-cpu batched ops

 kernel/bpf/arraymap.c                         |   2 +
 tools/lib/bpf/bpf.h                           |  10 ++
 tools/testing/selftests/bpf/bpf_util.h        |   7 --
 .../bpf/map_tests/array_map_batch_ops.c       | 114 +++++++++++++-----
 .../bpf/map_tests/htab_map_batch_ops.c        |  48 ++++----
 .../selftests/bpf/prog_tests/map_init.c       |   5 +-
 tools/testing/selftests/bpf/test_maps.c       |  16 +--
 7 files changed, 133 insertions(+), 69 deletions(-)

-- 
2.25.1

