Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077683DA907
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhG2Q3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhG2Q3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:44 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D6BC0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:40 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b11so2326318wrx.6
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M78Ftq0r5+Gxb4834D7jHiP+RomZ8457QnIJIRUgcOI=;
        b=bKl7u3uaABVis3GH6fFOZjHTV255SrHgbHL/s1F0vYbV6E86Thhsqh/LtqJ/aYsRIO
         DvouSR/Vo4Tz1MfMIwDpdKB9+U5T/rlXL305cDtb47xVZopCYLuq8I0NxZHEXj1RlevY
         DrqorDn+fJ4AzOuaMcjUNkO+irniBAf7RFyt6/kozd+7JDLYgihbQE9+1hZHlE4kWLXe
         wl6LCtCwLRw8kXLrLOoPsuRxeLHgY2/S5pV//nug9Zsa09zrVa3y5DeMrXnycZrJVmJC
         aqao27l8Gu6ZdMbzDdTT8vLGCajym5PXCv/L9KQKPkEVnyvqKH1RZQDN8g0MEDEw03Ns
         WHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M78Ftq0r5+Gxb4834D7jHiP+RomZ8457QnIJIRUgcOI=;
        b=OlzdSH6P5eO20TqvsoKBgkWaj71A4SKSV1/byh00AZoZnJrw9RcKCZxuH1caU2zUXd
         R7P15zGGVMJXw25cC4uomv9m+pMfFlnJrCU0D6RfEQb8zH4lAujbU2bNBotSZNn639aB
         YzaDRbD8pvb+tqW5ACF12r5ux1cwDTce8sKQJR8T6egTUkhpi3bOeYSpS9E9qS7TKbue
         fRu5Nh/bmMh/8kWFXrAOJ3ixiXwgshAx4G5mjaRoPv/H/ZWX867LoNPNwksgMbFPSvnB
         O+uQQNDWx4DV4Ienv1CNcG3DGWZoyXQgcRnvkDXm7RErNRkOhHjXfiC1anwXY89ZB8dC
         NVMQ==
X-Gm-Message-State: AOAM532D8OqSwuy5yF86l2cyCD0woR9ZOUP+s7YEdUlJ6Mr49IPT+FaN
        9aFJQ5vPOTobN0ynEMm8OwiLUg==
X-Google-Smtp-Source: ABdhPJw7A6f24FlktQs4TQ8AAtJWJ81ViKwRx8vCAUlitboMB5jLzVgaM2/IYj7APrdnRsCipMez7w==
X-Received: by 2002:adf:ee4e:: with SMTP id w14mr5890955wro.15.1627576179314;
        Thu, 29 Jul 2021 09:29:39 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:38 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/7] tools: bpftool: update, synchronise and
Date:   Thu, 29 Jul 2021 17:29:25 +0100
Message-Id: <20210729162932.30365-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To work with the different program types, map types, attach types etc.
supported by eBPF, bpftool needs occasional updates to learn about the new
features supported by the kernel. When such types translate into new
keyword for the command line, updates are expected in several locations:
typically, the help message displayed from bpftool itself, the manual page,
and the bash completion file should be updated. The options used by the
different commands for bpftool should also remain synchronised at those
locations.

Several omissions have occurred in the past, and a number of types are
still missing today. This set is an attempt to improve the situation. It
brings up-to-date the lists of types or options in bpftool, and also adds a
Python script to the BPF selftests to automatically check that most of
these lists remain synchronised.

Quentin Monnet (7):
  tools: bpftool: slightly ease bash completion updates
  selftests/bpf: check consistency between bpftool source, doc,
    completion
  tools: bpftool: complete and synchronise attach or map types
  tools: bpftool: update and synchronise option list in doc and help msg
  selftests/bpf: update bpftool's consistency script for checking
    options
  tools: bpftool: document and add bash completion for -L, -B options
  tools: bpftool: complete metrics list in "bpftool prog profile" doc

 .../bpf/bpftool/Documentation/bpftool-btf.rst |  48 +-
 .../bpftool/Documentation/bpftool-cgroup.rst  |   3 +-
 .../bpftool/Documentation/bpftool-feature.rst |   2 +-
 .../bpf/bpftool/Documentation/bpftool-gen.rst |   9 +-
 .../bpftool/Documentation/bpftool-iter.rst    |   2 +
 .../bpftool/Documentation/bpftool-link.rst    |   3 +-
 .../bpf/bpftool/Documentation/bpftool-map.rst |   3 +-
 .../bpf/bpftool/Documentation/bpftool-net.rst |   2 +-
 .../bpftool/Documentation/bpftool-perf.rst    |   2 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  36 +-
 .../Documentation/bpftool-struct_ops.rst      |   2 +-
 tools/bpf/bpftool/Documentation/bpftool.rst   |  12 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  69 ++-
 tools/bpf/bpftool/btf.c                       |   3 +-
 tools/bpf/bpftool/cgroup.c                    |   3 +-
 tools/bpf/bpftool/common.c                    |  76 +--
 tools/bpf/bpftool/feature.c                   |   1 +
 tools/bpf/bpftool/gen.c                       |   3 +-
 tools/bpf/bpftool/iter.c                      |   2 +
 tools/bpf/bpftool/link.c                      |   3 +-
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   3 +-
 tools/bpf/bpftool/map.c                       |   5 +-
 tools/bpf/bpftool/net.c                       |   1 +
 tools/bpf/bpftool/perf.c                      |   5 +-
 tools/bpf/bpftool/prog.c                      |   8 +-
 tools/bpf/bpftool/struct_ops.c                |   2 +-
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/test_bpftool_synctypes.py   | 586 ++++++++++++++++++
 29 files changed, 802 insertions(+), 96 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py

-- 
2.30.2

