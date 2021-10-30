Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D594409A8
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhJ3Osn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhJ3Osm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:42 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0CCC061714;
        Sat, 30 Oct 2021 07:46:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so9478164pjb.0;
        Sat, 30 Oct 2021 07:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tc4Uu5doNIsZ4Fi08H6OKtXtfZOclf/dWxReOXLjFqA=;
        b=YqoanpuOWt251E5mr2RgsMfO94+xTtqegbrBBG33Ajm4JSjJ7+o/mJ/cnf0e0MvO0j
         gmJmAjYOSmtRzFXO1ILUPzMLqXUu2fJ4w+qH8n2LvEpixP0JieKtAkukcYDgxwwmvgig
         zYhM2cYF2WAFcjYxXyU/SkYKv/Yj5DWGDMVJHQGBIy6cWHtve7YeIALgYpLbRXgrXBSw
         bm7eqfCPk6f3XMZStBulOJAuJbaFkR55cLyLRXxbmC0D/9SrFeX1jFLI7XNFbMotHs9L
         zemUvhzhpMdQ1Ms1yNUhPnTvgclcC0vFxTlZGmxM7pZVTBqFa+0tZ9BBAFI9hyxT57jz
         z5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tc4Uu5doNIsZ4Fi08H6OKtXtfZOclf/dWxReOXLjFqA=;
        b=Ewiwm0VqGhAK0Qm2pNHkavMzn0Mv65JXwcTjnrcMskXCaCqN4tmzdqDNPoiVJfkEDM
         KBplNaycwgIP4qAfuhitZsmaQ9Ce3YzNZ8LLxUo3yto8n1LNcmLcq5J6QjC0v+7TWz8T
         Y0aGroLbkGtDP18gymHM8mh8y1449NrqrlxGUiITkJLUjuTgtcfsa9tEKEFXkoSQ6Htp
         z21YCBG47YuJJkWSDxNuCe61AETSIBZlHk8vgPaVR4m31oLl9VlIFsSmwnxMdJDFBFMR
         B5WdzAzBTdBvIq0am63JGtPIKnqYWvQS+lYNTf+PqUZM5PrGlp+8Du2rwLCLO/8hkE6X
         O3hA==
X-Gm-Message-State: AOAM533tYHFdKnrrJUQ0dpw2NWb98Tz4Vkdu/sgF5b8PmbcSiOMnHCnl
        yfp41f9qtg23t9PK2UGl+4NzujF0X61S6A==
X-Google-Smtp-Source: ABdhPJyqvmfRL9MbgFncmyU3IPwHcON/knCJIG8MyoqbK27eRbVGoqWJur3rJj0E5TFDllsLg0NQZg==
X-Received: by 2002:a17:90a:c398:: with SMTP id h24mr4896237pjt.73.1635605171770;
        Sat, 30 Oct 2021 07:46:11 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id g18sm11028029pfj.67.2021.10.30.07.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:11 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 0/6] Introduce unstable CT lookup helpers
Date:   Sat, 30 Oct 2021 20:16:03 +0530
Message-Id: <20211030144609.263572-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2265; h=from:subject; bh=VIBX0gIYz4+9tYndzOGxYKZZ0l9v3CqjAG+7q9iefAQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRmLAOuHHjXggYtzohDvWcQBdEuZXEqlwlSRje S1kc0SKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyjDID/ 9iF+916lkrG/GaOh0gErFlnP9M6FY7+WgZkxzsT2gexSb/3XYrtkq1vqzK7mm6mKaugIQV7A3Wjea+ iwRhM50UdopVXYqcemBmwjq6cryxt9lQC2mHdJGU5XDm7VamXKrDFMhA8PwgO3ZGY7+j3NGikhgOcl 8XiS5PSIf/F4XJuGx2D455PGme8SPuqwiEbE8gRJ8l10ZIsAo946+BZw9rIIH8+NjO7Gs3XaIIccgX 7Tw9SwEQUTqYlTrzcp/OxW05MAKGi3Tv/d6rDSdDXqdu03u93PUS81SzjkxlBDMiAj49X2oOdlx0hq f0wphRltc3z3/FYPvDG33rvjQnwqYWCGPEtgC1JC+PfJIj2dvcIWDyNzydl++yb/mCZMEaZhsMyRox 4hPT1ZsWE+EE81GyG36DZpnx0SKU4qPT4lW7AFkodOCT75ES/6k3YKgz+8xGQ3FnRdqnDoC6wMJK1D IPq4PFcXEqFfHHdfDigmZUH8M84bPHwU+Q/SOCBvUU5st7274tu7k2o6uX73LqUpWdTOqMTRATUrkX L/49FVC3bMDTVyktu9rPFb/KjUC3/jOb59QIMkwvWEtrH26pR0BICCTmvsYcB7CjAYhBP1gzFKH6x7 Y1oUVcZjpeEcwNdQYmZAmrsJykTm+OE7KcS0XxAtvTJGRdowgab7njk2Amgw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
patch adding the lookup helper is based off of Maxim's recent patch to aid in
rebasing their series on top of this, all adjusted to work with kfunc support
[0].

This is an RFC series, as I'm unsure whether the reference tracking for
PTR_TO_BTF_ID will be accepted. If not, we can go back to doing it the typical
way with PTR_TO_NF_CONN type, guarded with #if IS_ENABLED(CONFIG_NF_CONNTRACK).

Also, I want to understand whether it would make sense to introduce
check_helper_call style bpf_func_proto based argument checking for kfuncs, or
continue with how it is right now, since it doesn't seem correct that PTR_TO_MEM
can be passed where PTR_TO_BTF_ID may be expected. Only PTR_TO_CTX is enforced.

[0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com

Kumar Kartikeya Dwivedi (6):
  bpf: Refactor bpf_check_mod_kfunc_call
  bpf: Remove DEFINE_KFUNC_BTF_ID_SET
  bpf: Extend kfunc with PTR_TO_CTX and PTR_TO_MEM arguments
  bpf: Add reference tracking support to kfunc returned PTR_TO_BTF_ID
  net: netfilter: Add unstable CT lookup helper for XDP and TC-BPF
  selftests/bpf: Add referenced PTR_TO_BTF_ID selftest

 include/linux/bpf.h                           |  29 +-
 include/linux/btf.h                           |  54 +++-
 kernel/bpf/btf.c                              | 188 ++++++++++---
 kernel/bpf/verifier.c                         | 101 ++++++-
 net/bpf/test_run.c                            |  55 ++++
 net/core/filter.c                             |  56 ++++
 net/core/net_namespace.c                      |   1 +
 net/ipv4/tcp_bbr.c                            |   5 +-
 net/ipv4/tcp_cubic.c                          |   5 +-
 net/ipv4/tcp_dctcp.c                          |   5 +-
 net/netfilter/nf_conntrack_core.c             | 255 ++++++++++++++++++
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   5 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     |  18 +-
 .../selftests/bpf/progs/kfunc_call_test.c     |  21 ++
 16 files changed, 741 insertions(+), 64 deletions(-)

-- 
2.33.1

