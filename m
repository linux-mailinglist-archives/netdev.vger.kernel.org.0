Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B648189D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhL3ChK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhL3ChJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:09 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C01C061574;
        Wed, 29 Dec 2021 18:37:09 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 8so20204004pfo.4;
        Wed, 29 Dec 2021 18:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/uajn2jmvBmuupZ05y07FHeO8LYjfWjG5jTNHi86Co=;
        b=WYuqfYwZJ6VN8l7Aj1RfWjQljCJuigp2HrjHZhH0WYKnGGibLrErIF+UI19VNvqXmJ
         8DBnNMWWTkkYFFQn1v6q+oljxTDfO2xkahw2QtSRzvN928XSh1BqSIrPTX2+U0w2eDGl
         FLI50KkkUlBSmXRWzkCJh2vp/dUXDY+BCH+lw9GHMkjQTXVLcRivUO5QG8i42EBZdNpq
         1XXnPK8azmUrwJzTOrXfOrA+O9RHNtEcCtr/Ua29wbvCBLAISqXrpH88VKl7f18F/amE
         D0gQxR48Yn37Xzk5HtK1dSKNP4Qm2xCR+rz3ZjkYmRXsWpolXV6qGs4BKd+xmP84eq+j
         R2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/uajn2jmvBmuupZ05y07FHeO8LYjfWjG5jTNHi86Co=;
        b=P95ek45oKk95WruDUVDsvC6UKTt9LlraphMMvG0jhbaqNogjZnXbuEeRP+H/EG+Pip
         IWnWDHr9GN97RU1xBS0pIsOSLCbTZMHiFzsgMt7/96Lg3LKc9AXvZ+TxRPiOJzL1Xq7B
         rO027M6vJJxAdsZ/sdYu9M+/b+NIVVaK2G5b/Y7oCy4s3d44j4u86kxm5RhACLSYqK+q
         A3FRyu8caYwmjTdRvOENLAyy5sSfP7HCpNPLlrPNqPtNlkz/mRSLEuH0QQ49PNFvvMbL
         MVXrabGaFI8MtwD96VlUyzRZNy8D46xwHJZPiq642+zx7w83lWx6g37oV3oxQdU+HXSh
         QwfA==
X-Gm-Message-State: AOAM533TqVf95F0GfJtOh/lXXBXal+JGBUdasxlYMVc4m39apBw0BNkh
        uMwIEGq2bBXSV5Wbmz4JrxZUtLbiMYY=
X-Google-Smtp-Source: ABdhPJxnpWFiBgtndDoUi9Bl8gkyoukPUSOFVTePqHyvmcWmp7Rrvd38qjoHzr5t47bgiYX9APSR7Q==
X-Received: by 2002:a63:340c:: with SMTP id b12mr20589840pga.360.1640831828765;
        Wed, 29 Dec 2021 18:37:08 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id v8sm19690989pfu.68.2021.12.29.18.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:08 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 0/9] Introduce unstable CT lookup helpers
Date:   Thu, 30 Dec 2021 08:06:56 +0530
Message-Id: <20211230023705.3860970-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5083; h=from:subject; bh=FNs9IV+i+1RViNTH6XCtw2Wq2JgK1XSxAGXLlwKAtvA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr9eKXSQb9e0LUx3vBJXPZUTmWO/xoFFLtxbFEA CfwS6hCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/QAKCRBM4MiGSL8Ryi1iD/ 4tCyCmB+m4qwK72vLhZHsEc16Rx2We8V8IfcHmJF+Br/qMiFodVTvvnfZ0B8T8Zxqe6kZlxjfhumRU lI1O+NVVn+nffqNjDDEQ3gmrk3DTQWhzaVQY8v3aRd85TdL0EBONGUgiekOFnQznbAOUs2S7T3Qylv RYTr/33aBBcOS9gWl3oxU9ZaJQjAnxVGSd6qkqGjQmt8uUwqEYYMf8A904S3goCElV+ecbQtDz74QC WfLZU7n0KL419pX5izYhDUvL7s+hbKqoXgAQZUkfrgWsunlb3mE6D/gn+5/H4NdxzfQDBpL6sKdsVU 1gB79hkg+oyvXAjiG9PD1EGzR2KotdIfv8T5m9Ht8q5iSiFp6zTM8me+F3mTGrDmAsubtAt7Xlyv8p ZVGLLMrHlrokh3Lzb4F9eUJ5KfVMtKPRacnGDXCW9wgJov8/kGG7myfFvEDOpCIyL7wlssyEE1MoH6 tWcniiY8KnuHO4Fnzi9xTIX34xyBS3s46eD5DD/XP8s7/SRaixyfksoSKiaV4jwkoLERL70ynYdK8f YrhxiR/T7jEPMR+wPACv2+HciHB8YurDimZ9NrrcsbHKr0sLAkFYGnlMJHZT4ajQJOKsDx++iCIFKp ssk2iwkCQt3OZrHn45xyoMmBouiXvL6J6/ShkbYWOOYXOW6DektNpdwm7pwA==
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

Changelog:
----------
v4 -> v5:
v4: https://lore.kernel.org/bpf/20211217015031.1278167-1-memxor@gmail.com

 * Move nf_conntrack helpers code to its own separate file (Toke, Pablo)
 * Remove verifier callbacks, put btf_id_sets in struct btf (Alexei)
  * Convert the in-kernel users away from the old API
 * Change len__ prefix convention to __sz suffix (Alexei)
 * Drop parent_ref_obj_id patch (Alexei)

v3 -> v4:
v3: https://lore.kernel.org/bpf/20211210130230.4128676-1-memxor@gmail.com

 * Guard unstable CT helpers with CONFIG_DEBUG_INFO_BTF_MODULES
 * Move addition of prog_test test kfuncs to selftest commit
 * Move negative kfunc tests to test_verifier suite
 * Limit struct nesting depth to 4, which should be enough for now

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
  kernel: Add kallsyms_on_each_symbol variant for single module
  bpf: Prepare kfunc BTF ID sets when parsing kernel BTF
  bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
  bpf: Introduce mem, size argument pair support for kfunc
  bpf: Add reference tracking support to kfunc
  net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
  selftests/bpf: Add test for unstable CT lookup API
  selftests/bpf: Add test_verifier support to fixup kfunc call insns
  selftests/bpf: Extend kfunc selftests

 include/linux/bpf.h                           |   8 -
 include/linux/bpf_verifier.h                  |   7 +
 include/linux/btf.h                           |  63 +--
 include/linux/btf_ids.h                       |  20 +-
 include/linux/kallsyms.h                      |  11 +-
 include/linux/module.h                        |  37 +-
 kernel/bpf/btf.c                              | 401 +++++++++++++++---
 kernel/bpf/verifier.c                         | 196 ++++++---
 kernel/kallsyms.c                             |   4 +-
 kernel/livepatch/core.c                       |   2 +-
 kernel/module.c                               |  62 ++-
 net/bpf/test_run.c                            | 121 +++++-
 net/core/filter.c                             |   1 -
 net/core/net_namespace.c                      |   1 +
 net/ipv4/bpf_tcp_ca.c                         |  12 +-
 net/ipv4/tcp_bbr.c                            |  15 +-
 net/ipv4/tcp_cubic.c                          |  15 +-
 net/ipv4/tcp_dctcp.c                          |  15 +-
 net/netfilter/Makefile                        |   5 +
 net/netfilter/nf_conntrack_bpf.c              | 253 +++++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  15 +-
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++-
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 +++++
 tools/testing/selftests/bpf/test_verifier.c   |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++
 28 files changed, 1314 insertions(+), 268 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

-- 
2.34.1

