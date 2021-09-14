Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC04E40ADE5
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhINMjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhINMjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1CCC061574;
        Tue, 14 Sep 2021 05:37:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id j1so8761592pjv.3;
        Tue, 14 Sep 2021 05:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYD/m3b2Xk2X8naBfXl1GBV3YhTAlAqRYF5wWM7FCKA=;
        b=HuUYJcPF/fNSo4qapjD1cQBJH3sQDo0QAGH8/ls4rD1rQQVh82eBelgLCY3Qtpdqx6
         6X7HTbmlFReqwSWRNk1UyNXWyg/YOlpeiqXWaJPBgQtqo/9VdmoGd+p8Xu8pu1HtvnGd
         xI1K5TgzIL5nYtgExPnXMpD/QHvarU5ol2LW3aAIxACOKJnQ1cC5NgbMTJh/ThPrLp3L
         csu+uQLE+d/Ly52bx4Y7qdojHCzbv2ciBSLvdbGLddA6+tWI2uGN5B39wg9avCl5om0O
         3IcX44QwkZJyfOtbdRp18PdbebyfAE/ABFZwu9NLrDGG+GZLp6dHOD5dR9oPBubMnvKa
         qyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYD/m3b2Xk2X8naBfXl1GBV3YhTAlAqRYF5wWM7FCKA=;
        b=NwM9al85EgzayT2u68xfySWt55mnx2g/vQlYrQ+NkKOZhrkxzsBH/DNNVWyaOCao/T
         TGrht4/6OlFoYf9cyJw+UWfOpPxjOzDCnsGlHrPNVZ7KjJXlBOR7EiYLkSoUyAi/oxdH
         CNI8KkIrdO9gVjtWQGVg0nlb6XOcYvHPJjNuNdk4qVcGx9I87PwYAR+9PtaE7A11XU7e
         +xvSTHu4c8HwwlkKEInef9x8s397OnoK78PmzOyFSQBVG8biinlijnSvycbNt1VmjLeA
         XTY3+yeH+5lp9K3nkkIYx4htUWRHHFqpLAHZ5E8NuBXp5bCQfiYKOmbSlw7J3GRV+KhO
         4wow==
X-Gm-Message-State: AOAM530uofj26lcSmsAteHWhzNMofBANZ6T5e/WI/GwEr7LRaJVU6rDp
        bIbmQ0Vips+NIOGEPMr6kKA4o5dPXEy1OQ==
X-Google-Smtp-Source: ABdhPJzFDuTI19DZQZBBqK0+rzUbVW6xRxb7iNBVcSoc3JgM5R9LzUubL9EIlqEFgylbUd5lfrL/KA==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr1822342pjp.167.1631623077176;
        Tue, 14 Sep 2021 05:37:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p18sm11683006pgk.28.2021.09.14.05.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:37:56 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 00/10] Support kernel module function calls from eBPF
Date:   Tue, 14 Sep 2021 18:07:39 +0530
Message-Id: <20210914123750.460750-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3872; h=from:subject; bh=Kb1FWmgAk3OV0RE2BfjxxKQA8rcri3S4RjYcS7QjK4g=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdVKIuNZlOdz1t7OybdkjWRNREutsaNMMKKIh0h QQ1sYWCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVQAKCRBM4MiGSL8RykUXEA CbHMN00uSNJoAigQCPh2zBIBzOPGyFGYTXUAOCotPq6mEdSh9VYAhbeL0I+FsokR9YWC2SupVUMIBe Xzlfhkftv6sF8ZS02GpIHH8M2ZpBBscmhexykIxwq9Oq8JA2pFIIWi4ZYeZ0r9yFsJCWAdrvvS3g+W iALDzJpw1MZvwYFIflI8OTgCObUUlLJuNDDJe7BHoG0US/OJYEgU8Bq78WCKcAxGsaUpjOsqBIo0ia 498XKbsd+mq5ydSEmHp9lfwlyxBGxtsoY3xq4nabf4aweueJ4bnVJQEZiWLwm9hcTB8yQtuOYhotMo FP0fyNZmudqFsCXpmooIhGJZAOw6t0Fw7OP6eQ0ez4041khvriH4aNptisD7v3UHj1BrmFK217G1bD yWDIEzPWajIoQtu6I7FWL2+yE6w/4Jyc8OzPkS8K1IC5qQtIvIXPN34NS1wWXxptMfh51pxdCVFaaQ BEos3jyyBIyMsccbNs83N32fxf9iz8TRDpl36CoRTdLn8Pq9yg+UK12k5JvON1gmwzfVKqP1NzcE7E xqpPKLHIQ6O+sDdQ84aLyCYadOOtd0cX0diw3e0fUR9PGyN2EJY91tJu0kSbpwn4pWuvQLjcU4OEhp TcUe0z93FN1YXGiLXuVBWgFhp5Uysikl0GN3tJXM2g1DGuo89vmBhFKaRnjQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enables kernel module function calls, and also modifies verifier logic
to permit invalid kernel function calls as long as they are pruned as part of
dead code elimination. This is done to provide better runtime portability for
BPF objects, which can conditionally disable parts of code that are pruned later
by the verifier (e.g. const volatile vars, kconfig options). libbpf
modifications are made along with kernel changes to support module function
calls. The set includes gen_loader support for emitting kfunc relocations.

It also converts TCP congestion control objects to use the module kfunc support
instead of relying on IS_BUILTIN ifdef.

Changelog:
----------
RFC v1 -> v2
v1: https://lore.kernel.org/bpf/20210830173424.1385796-1-memxor@gmail.com

 * Address comments from Alexei
   * Reuse fd_array instead of introducing kfunc_btf_fds array
   * Take btf and module reference as needed, instead of preloading
   * Add BTF_KIND_FUNC relocation support to gen_loader infrastructure
 * Address comments from Andrii
   * Drop hashmap in libbpf for finding index of existing BTF in fd_array
   * Preserve invalid kfunc calls only when the symbol is weak
 * Adjust verifier selftests

Kumar Kartikeya Dwivedi (10):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative while processing invalid kfunc calls
  bpf: btf: Introduce helpers for dynamic BTF set registration
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: Enable TCP congestion control kfunc from modules
  bpf: Bump MAX_BPF_STACK size to 768 bytes
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
  libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
  bpf, selftests: Add basic test for module kfunc call

 include/linux/bpf.h                           |   8 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  38 ++++
 include/linux/filter.h                        |   4 +-
 kernel/bpf/btf.c                              |  56 +++++
 kernel/bpf/core.c                             |   2 +
 kernel/bpf/verifier.c                         | 200 ++++++++++++++++--
 kernel/trace/bpf_trace.c                      |   1 +
 net/bpf/test_run.c                            |   2 +-
 net/ipv4/bpf_tcp_ca.c                         |  36 +---
 net/ipv4/tcp_bbr.c                            |  28 ++-
 net/ipv4/tcp_cubic.c                          |  26 ++-
 net/ipv4/tcp_dctcp.c                          |  26 ++-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/resolve_btfids/main.c               |  19 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/gen_loader.c                    |  93 +++++++-
 tools/lib/bpf/libbpf.c                        |  81 +++++--
 tools/lib/bpf/libbpf_internal.h               |   1 +
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  13 +-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  18 ++
 .../selftests/bpf/progs/test_ksyms_module.c   |   9 +
 .../bpf/progs/test_ksyms_module_libbpf.c      |  35 +++
 tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
 .../selftests/bpf/verifier/raw_stack.c        |   4 +-
 .../selftests/bpf/verifier/stack_ptr.c        |   6 +-
 .../testing/selftests/bpf/verifier/var_off.c  |   4 +-
 31 files changed, 661 insertions(+), 112 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c

-- 
2.33.0

