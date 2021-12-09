Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6004C46F0FA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242450AbhLIRNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbhLIRNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:06 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7FFC061746;
        Thu,  9 Dec 2021 09:09:33 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v19so4360315plo.7;
        Thu, 09 Dec 2021 09:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JNL+Wc+1xhZG0xbYS8UO1UpYjDPLiWp9xlSvuottUk=;
        b=McDE++6edbVHFJKO26fHRM7jn5Uxy3ScZC+muILuZHQf9lRA5OS/IxvpSxF1gOxNg6
         6pKpjEGRr4lzS7RMa6CIhod1w5Ebny97s/RizxaClPR2CaOxBdrzO0T+cPS+UMSL7LPb
         MTEhxxi6fx3XSNjraBhAFfbCxhsYvdjFoeS/yBKR48tHkAAVTO5COYfmhfz4jIn+f/QX
         pwlWyxvH0FJ9KWmENxm0OAOlTxSYAJfNKGEOyOqTE/152UiJEqYgvchCQpQGjNS7xxrz
         cSZdwJ2BirzwF9QQlv+N9HeXmE7TYa7iqJXTX6jaJ2q2AlL697/1UMSR0Ws55FOh5WpR
         RgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JNL+Wc+1xhZG0xbYS8UO1UpYjDPLiWp9xlSvuottUk=;
        b=skqW5k60QFTYQiLzdFIC4GovmrFvX8B/ZmxPMZwvQY1VlsdQGMZdSsnf4agYgtaluD
         JvBtt04kFYWqjuiGRCco6yr0Q4k0cMeY6XVCBxlOO8reYtgBL4KyNdnXz5e3419t2ASB
         iYBja6zTO0BZLvS6NokadPTj6lhSPd2B0lCb7OW72nf+//PnLcbKVlT8VsNTa8SW5gGT
         KeOeSeBVsr8qiERIXEug05pvRrIXkHvbmlB89xV46CLFiYWdaMGhAmH8lYuSSshnlzg8
         D9G1VhMzVe3wq7EaYsQErGkcLAa+b1djH4t9pV+Ti+xIDdfDCsYBwUeKvAC6noSkyO0J
         umnA==
X-Gm-Message-State: AOAM532xG+oLsfpb5eTMnbBiwSkwYV8cgrHOdx9y/0QDduKqvCOaC5nZ
        71f7g9MMsJnOQX1rgzPjl7hrB2scEFk=
X-Google-Smtp-Source: ABdhPJwm3aeU29ywUj3AzmhChOzHBB1i1NgJ69+U0Zl623FIrwFSWj+/uif1afxu3+rQrIVW6XSMYw==
X-Received: by 2002:a17:90a:284f:: with SMTP id p15mr960177pjf.1.1639069772359;
        Thu, 09 Dec 2021 09:09:32 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id k15sm179229pgn.91.2021.12.09.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:31 -0800 (PST)
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
Subject: [PATCH bpf-next v2 0/9] Introduce unstable CT lookup helpers
Date:   Thu,  9 Dec 2021 22:39:20 +0530
Message-Id: <20211209170929.3485242-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5329; h=from:subject; bh=2wAbs+O2N2WXsg37Hk0gMAiFUVaJTnu3lYSyHTO+aog=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgGXzAgRCeePjiVglmVv/rET2v+dq5PgOK5y5AQ L3lFic6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BgAKCRBM4MiGSL8RyrnWD/ 9JDWBFjlXThz4hO++83odRJd/7t4n4a1uX4Jk3vvcFomI9r3HUlNKxZD6531bo63WwFH1einhNCO4H g62SxFiX5shXx770/P79SEIvtUwBhw+y0nUDwSpCLe29+7Sxq8xbuc0I7v4/asFWWxhappzIXQ1SV0 ZkHtbIuLuNAJuy1ZLy3b3MaDzPwBVY2FmrJAlmZxb7T8y06kIcToIoIYiGatdHDN5dld/AghzQLkUt sp77RVcVaqydb2Hp6Ga+WleBfglnHjVv78E09yg/hk3wnlkDOd6RmbBoNdzmHWy3uS4c3xYb1HAwYS Ra4CXjxvMUpnlUG2Jb5qGvxSzl7jEukoLaXrLEI7i2oUCpCJlJqOMD8e1NNB428k2g9x44B3l9tPQ/ QUWK66pFwJwgeDc+MYnanP+fIWycJA/+p6+PRLP9caaW/wJo/1KVcqhhGIlmY9io1eG+edWt5B94qW cvvaNqwfyCU3s279de0xoYq25OzpeWFUdv4loAwnCAFCazzTR1eX45Pm0sunTmtvs3l/PylVGIpNZz sL7+zFkxwpCg9dFz9uyWX2QB8FvVABgHFCcZx7aF23TuXRpzVk9mvmAF7bQbyNsSIYcnVKG4gvbuzc O5yDSawm2UweafwXNY8V3HjBlqP+yx4IFyaOIO/H1vSM+0exCUjvzvU6jUwA==
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
change so that testing this set is possible (tests in patch 8 rely on it), but
before applying this, I'll rebase and resend, after bpf tree is merged into
bpf-next.

Note 2: BPF CI needs to add the following to config to test the set. I did
update the selftests config in patch 8, but not sure if that is enough.

	CONFIG_NETFILTER=y
	CONFIG_NF_DEFRAG_IPV4=y
	CONFIG_NF_DEFRAG_IPV6=y
	CONFIG_NF_CONNTRACK=y

Changelog:
----------

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
 include/linux/btf.h                           |  48 +++-
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
 26 files changed, 1259 insertions(+), 112 deletions(-)
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

