Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF773D129A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240017AbhGUO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbhGUO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:57:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD0C0613C1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r11so2657469wro.9
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33SpBe959fa1CdZeT/RZuhePwiZ+3BM8bxkMEVqqlPo=;
        b=yvWWehJ3jOQl0IS8nX37zu88M18cNKg52+GA7FhRhnzCn8lyXExTOvbKtr35AznVCb
         yDVCcOy23vFD5Sm8tWxky/zdgXYqhZWxGxQImgVNe1dv/IWaz9aUy+D6CMjpsX/iPIK9
         WoZFIyh3g9e6JpptUacc8mSRZWfg6z6Q89d1uFG5uVMhgNcnbh22+c1F4c0qdUjujWBS
         wo+WDLk3myfvUD0zWEBwCvo+F+KnZNxexNLJa7WGLJe3VxpVEl4QfydfHSt9M0OL/wak
         b5lnJQEooNOQXUMGovB4NV1nuCCceb9kAb+PdW3sbOZmUi+dgcGOUSCror3Vr0ICCLaF
         uqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33SpBe959fa1CdZeT/RZuhePwiZ+3BM8bxkMEVqqlPo=;
        b=ZM5qi+s/tlagp/ztAzQcxlzhnyKFqf/a9O+3Tf9Dy4x2aFkOFY1edm5SNJaZPeVNVD
         Fe/G2Xx5hTvYnzTLor+q442w0xSmYAd33zeJjbPlI+n0ySmZhLdJg5stq1nA/s3FM0EU
         FUIVPSTcIwZ46DPASpx6HrJhf9aB2qnIZSQaPcCD0sXDCWYpygGX77VHSB26ypPYeCxP
         AGzH7r41fXfUhS4UGO4U01WB80/M2nVgsc6t4RpZ9LTmJLi34OmpqoZAuoFc/K5SxkVv
         fQBx+Zx4IKtvQJeAlf7dw48/XO2/3MuFQTIKUOEomQPqkGltHw4gRm5NGvQ+tzGeF/ue
         3pJA==
X-Gm-Message-State: AOAM531w9qHh1T1BKWCAiY8mpBIbo1qjpZ1oSMVVd9nEiLuQgjM27WzK
        Ywyc0zZmG+jaQ3wNe5iNAUazrw==
X-Google-Smtp-Source: ABdhPJwGpaeE/n04pLKeha86hdiY1mdJnWBY4lziudAGlqmQDU3AM6mCNoWMZMrkH79zwqlys3DfkQ==
X-Received: by 2002:a5d:6506:: with SMTP id x6mr42250747wru.86.1626881891916;
        Wed, 21 Jul 2021 08:38:11 -0700 (PDT)
Received: from localhost.localdomain ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id n18sm26209714wrt.89.2021.07.21.08.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:38:11 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and btf__load() APIs, support split BTF
Date:   Wed, 21 Jul 2021 16:38:03 +0100
Message-Id: <20210721153808.6902-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the effort to move towards a v1.0 for libbpf [0], this set
improves some confusing function names related to BTF loading from and to
the kernel:

- btf__load() becomes btf__load_into_kernel().
- btf__get_from_id becomes btf__load_from_kernel_by_id().
- A new version btf__load_from_kernel_by_id_split() extends the former to
  add support for split BTF.

The old functions are not removed or marked as deprecated yet, there
should be in a future libbpf version.

The last patch is a trivial change to bpftool to add support for dumping
split BTF objects by referencing them by their id (and not only by their
BTF path).

[0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis

v2:
- Remove deprecation marking of legacy functions (patch 4/6 from v1).
- Make btf__load_from_kernel_by_id{,_split}() return the btf struct.
- Add new functions to v0.5.0 API (and not v0.6.0).

Quentin Monnet (5):
  libbpf: rename btf__load() as btf__load_into_kernel()
  libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
  tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
  libbpf: add split BTF support for btf__load_from_kernel_by_id()
  tools: bpftool: support dumping split BTF by id

 tools/bpf/bpftool/btf.c                      |  8 ++---
 tools/bpf/bpftool/btf_dumper.c               |  6 ++--
 tools/bpf/bpftool/map.c                      | 16 +++++-----
 tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
 tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
 tools/lib/bpf/btf.h                          |  4 +++
 tools/lib/bpf/libbpf.c                       |  7 +++--
 tools/lib/bpf/libbpf.map                     |  3 ++
 tools/perf/util/bpf-event.c                  | 11 ++++---
 tools/perf/util/bpf_counter.c                | 12 +++++--
 tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
 11 files changed, 86 insertions(+), 47 deletions(-)

-- 
2.30.2

