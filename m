Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCD3367AC1
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhDVHPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhDVHPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:15:46 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B88EC06174A;
        Thu, 22 Apr 2021 00:15:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p2so16740822pgh.4;
        Thu, 22 Apr 2021 00:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=08Beg/X2DkMw4LbTKV9DGPwWfP+ZIvVZ0dj7l+E72oA=;
        b=UoKZx+pJyvG7CInq3T4GJnngnw8xESG9QlEpGhdwnoNUAGLFqpVqVigfw7S2mt+Cyq
         2rbxVlXptoBzYP42V1cCjjO+M3UwHWu17zmUw9r34C4qCaNNQVD3GRd3Dc3+1NWX4VQb
         Y/vw7b9C9QFiECCSRwrM8qHuK3vsbhY72EZJGVRLTcdzqQgVMp1S/XiKSnrqskFhPWt+
         8vJisN3VGc9KeousnbXV2KsROclnEp/51OthsnNaaqyzxi5XK5sNTxiSA5jpJZJCqeTE
         zaSAKGV1wfU8FY4/NAxQm6risXk1YwU52ZptXGJYcheAmEKIVDI4z8QiKxaL6xKREKjG
         RZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=08Beg/X2DkMw4LbTKV9DGPwWfP+ZIvVZ0dj7l+E72oA=;
        b=OcllMrxfxBK1gkSBP5vfydx7UD/Mk1+waob+Cf3NRwGCVVzdT48N3015m4NpMitt/m
         aPD+v/YgNN6i/aMCgGBSDn38bgJ0YJBh1vOssQLneTIA2g1Y1qAe6UrWsfqrDQeWmIQM
         27QCmmLKw4Fq+5ZxrwyXZ82Og7tOgtFotrlJ/vqXkk5wbdy+6sK9Y9dZemNvw64H4Gpz
         oQhZtjWgutmSjLwI7TzNzGFuC97G6QbsHsyGH5xMFoPWRyLUimY3aFTzMMU0BU/Q0y/r
         sCSG0xgAposrJ8uJxRj+yd/ihWeYGzJQk/4zxJgcTAnawLrzNKKHgIQqoUcmfYx5VPc7
         eggA==
X-Gm-Message-State: AOAM531kbAKzF+mXk/7cIDGbIOepFVwzQKFTKlDy+QeKzT89KVYrmskZ
        5DluVXjzW7t2HazXhMVrlOajH397CGVLlw==
X-Google-Smtp-Source: ABdhPJxchR3BUy9g7TRPj11sGHjyeuSm/IiPy0p1lRnfpjR7S1B8xx6ZRm8xDme877oFPhq37Okl4g==
X-Received: by 2002:a65:4382:: with SMTP id m2mr2160268pgp.354.1619075711784;
        Thu, 22 Apr 2021 00:15:11 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u21sm1181816pfm.89.2021.04.22.00.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:15:11 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv9 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Thu, 22 Apr 2021 15:14:50 +0800
Message-Id: <20210422071454.2023282-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel thinks
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increases the complexity of verifier and has
drawback of performance.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv8 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210415135320.4084595-1-liuhangbin@gmail.com

v9: Update patch 01 commit description
v8: use hlist_for_each_entry_rcu() when looping the devmap hash ojbs
v7: No need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
v6: Fix a skb leak in the error path for generic XDP
v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed.
    After update the performace has improved 10% compired with v4.
v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 304 +++++++++++++++---
 net/core/filter.c                             |  33 +-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  99 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 205 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 17 files changed, 1316 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

