Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A242E470122
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbhLJNGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhLJNGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:08 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007BBC061746;
        Fri, 10 Dec 2021 05:02:33 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so9391569pju.3;
        Fri, 10 Dec 2021 05:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mO28Gr1Ebzjl+eyo2W/F3Ky3VW0PK2+l2qhNDeAI0+Y=;
        b=OkonDZICfL4t7GHpystfKqxB9+yVr4BQa3NFbVT36AE/QoppT/zcNHaeI0/yCGCgmD
         KG1q/g/CBycOOFrEAyLZOAAFJDos2pyLqDIEdB0h2F1fHbyJuU/GF43urj3TaSMAbtGg
         F0IbpN3STXKeSOg4JsrXFLYhdd0sArnbMG6zVcQxMySOHddQTsX4d2OBR9Jg+K9KkrLe
         65TwdxgHMoe5mqScj6sDvPn7i5R/0WdRhI/iRBmlt++9Xo+eNQfsB1iW/AmlM+tQdXB/
         G37xPRKHSalT5hEQwNXUNk1KEBimDeMK6EPA31dB+4T3ywdBV4tV7IRtDjvsl9I35eyf
         7uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mO28Gr1Ebzjl+eyo2W/F3Ky3VW0PK2+l2qhNDeAI0+Y=;
        b=eOxUaHzcb86fv+8o8n6BgkHmZTRvAVZ2rgw5/Xx4lPTloEAsW2LRzol8t0xALycE0g
         DwAkCnsrqvakHX3pQV1Ff4+ZIjfazh7Ezyp8Jb+JE5bgKPiCSLjkEDA2ywBnlVAXIz/G
         y3J97bm2paccc/T+rYyaAKHTg17/3Z8zakY7VgwQOG96krcOFY+XYianvklXENlEZVeu
         aNYW0GGksrJ4UuBt3GLA9nIcjF1z/qCwzgNepAB/hlpcXc3xl4Vs4IX0AlfTCH+JLy/k
         jQJ7DjDKEMn/X28iEHf0ZD0On9FW/2x327v69p84LyD0zNOlUf2dE1dF/kglGHz9uxEd
         VAoQ==
X-Gm-Message-State: AOAM531qZl3fn0Eevsh3CQr5Gf+8gNh7o2qCxsFXR2prvy+gmBFLHNTn
        Xlkc5muE290zRhBbQyHx+1bzHXpqjC0=
X-Google-Smtp-Source: ABdhPJwmlTMCIY/cY3CjFmIIMWOOcz+ajl1u62KEHZKo5HvN6VbdKiC9/8iUch5+5nCEmGI0FAYdQw==
X-Received: by 2002:a17:90a:ad47:: with SMTP id w7mr24041199pjv.16.1639141353136;
        Fri, 10 Dec 2021 05:02:33 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id p124sm3299124pfg.110.2021.12.10.05.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:32 -0800 (PST)
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
Subject: [PATCH bpf-next v3 0/9] Introduce unstable CT lookup helpers
Date:   Fri, 10 Dec 2021 18:32:21 +0530
Message-Id: <20211210130230.4128676-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5473; h=from:subject; bh=OzFwECfF4h2yHDW4HFFmHT5crPHxr09y0q3D4Gn0TLY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/Tf0u37BrdhP0AITm7H+5PieU8MLzPGn4o9rqJ odrbrNKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP0wAKCRBM4MiGSL8RyvepD/ 9uZ2B7wZ6VIuVSwSDyxCBya/6Lke8Eic0TY+ItcfRxW1BfCPrJ4MaqebGi4IR6jcwABDGgfovhKr72 sUJsYbMh3CIZA2VUaP8Zuk/q73IdgmSY8zoR5vuFKIp6pRB+gZ4uaUlOs+8JSELIWfpD56uFVUn3SM bnXc8wRz8QDfiXt0e8G/Ho0TOqsAbAqQDxckeC1ESMtsQ9AScus0Omx4qvwHrWmufZExicHKGLzfDJ j7CB5KalqlXETWx68EhUKgdrVw9lYy8iCYc66GzTjkvCwggZHEIgQgfxsRh+CQS40P4jCT3omed0cE Fag5xPHOz+G4HWX4I7W3FUZF5XTq5E7kkNYHtVZYlzx6ZLUcfw4jGdAdp1uU2PLzE3SFJUrnvBMw2x uXtbOb87OUobZAMfYWKWOBwvUDnFadO336mSgBgsA88vDIjLb0wAaWUPFkeq822CbfMVYKraiJHIbH 9pXg0l3dfPzIXzUGznHq14cLqFEPq/mAShUYLH+QBzJjpRn0Ep+2tTAQ3bZBJExKKpwgic48fn9mE2 eQDCO57seyDlVbLI2+SkBjSJBwzUgeBKERaCMcgXLdxp9WB4RX63TUlweU1HEBdGRr6nkPQVXQ3w5N YyXHazYlVaj3Nt6SVGogZvUb0/9eWq+/xgkirrmHuLcSIKnmmElSrj73j3SQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
patch adding the lookup helper is based off of Maxim's recent patch to aid in
rebasing their series on top of this, all adjusted to work with module kfuncs [0].

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com

To enable returning a reference to struct nf_conn, the verifier is extended to
support reference tracking for PTR_TO_BTF_ID, and kfunc is extended with support
for working as acquire/release functions, similar to existing BPF helpers. kfunc
returning pointer (limited to PTR_TO_BTF_ID in the kernel) can also return a
PTR_TO_BTF_ID_OR_NULL now, typically needed when acquiring a resource can fail.
kfunc can also receive PTR_TO_CTX and PTR_TO_MEM (with some limitations) as
arguments now. There is also support for passing a mem, len pair as argument
to kfunc now. In such cases, passing pointer to unsized type (void) is also
permitted.

Please see individual commits for details.

Note 1: Patch 1 in this series makes the same change as b12f03104324 ("bpf: Fix
bpf_check_mod_kfunc_call for built-in modules") in bpf tree, so there will be a
conflict if patch 1 is applied against that commit. I incorporated the same diff
change so that testing this set is possible (tests in patch 9 rely on it), but
before applying this, I'll rebase and resend, after bpf tree is merged into
bpf-next.

Note 2: BPF CI needs to add the following to config to test the set. I did
update the selftests config in patch 9, but not sure if that is enough.

	CONFIG_NETFILTER=y
	CONFIG_NF_DEFRAG_IPV4=y
	CONFIG_NF_DEFRAG_IPV6=y
	CONFIG_NF_CONNTRACK=y

Changelog:
----------
v2 -> v3:
v2: https://lore.kernel.org/bpf/20211209170929.3485242-1-memxor@gmail.com

 * Fix build error for !CONFIG_BPF_SYSCALL (Patchwork)

RFC v1 -> v2:
v1: https://lore.kernel.org/bpf/20211030144609.263572-1-memxor@gmail.com

 * Limit PTR_TO_MEM support to pointer to scalar, or struct with scalars (Alexei)
 * Use btf_id_set for checking acquire, release, ret type null (Alexei)
 * Introduce opts struct for CT helpers, move int err parameter to it
 * Add l4proto as parameter to CT helper's opts, remove separate tcp/udp helpers
 * Add support for mem, len argument pair to kfunc
 * Allow void * as pointer type for mem, len argument pair
 * Extend selftests to cover new additions to kfuncs
 * Copy ref_obj_id to PTR_TO_BTF_ID dst_reg on btf_struct_access, test it
 * Fix other misc nits, bugs, and expand commit messages

Kumar Kartikeya Dwivedi (9):
  bpf: Refactor bpf_check_mod_kfunc_call
  bpf: Remove DEFINE_KFUNC_BTF_ID_SET
  bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
  bpf: Introduce mem, size argument pair support for kfunc
  bpf: Add reference tracking support to kfunc
  bpf: Track provenance for pointers formed from referenced
    PTR_TO_BTF_ID
  net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
  selftests/bpf: Extend kfunc selftests
  selftests/bpf: Add test for unstable CT lookup API

 include/linux/bpf.h                           |  27 +-
 include/linux/bpf_verifier.h                  |  12 +
 include/linux/btf.h                           |  45 +++-
 kernel/bpf/btf.c                              | 218 ++++++++++++---
 kernel/bpf/verifier.c                         | 232 +++++++++++-----
 net/bpf/test_run.c                            | 147 ++++++++++
 net/core/filter.c                             |  27 ++
 net/core/net_namespace.c                      |   1 +
 net/ipv4/tcp_bbr.c                            |   5 +-
 net/ipv4/tcp_cubic.c                          |   5 +-
 net/ipv4/tcp_dctcp.c                          |   5 +-
 net/netfilter/nf_conntrack_core.c             | 252 ++++++++++++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   5 +-
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 ++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |  28 ++
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 +++-
 .../bpf/progs/kfunc_call_test_fail1.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail2.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail3.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail4.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail5.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail6.c         |  16 ++
 .../bpf/progs/kfunc_call_test_fail7.c         |  24 ++
 .../bpf/progs/kfunc_call_test_fail8.c         |  22 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 113 ++++++++
 26 files changed, 1258 insertions(+), 110 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

-- 
2.34.1

