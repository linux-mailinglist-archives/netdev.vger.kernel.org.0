Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AD31CB642
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHRqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHRqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:46:15 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B058C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 10:46:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id r124so2850271qkf.1
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 10:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pFJAWwF2IYFGSuNhyWi8+LxiYsFNqud+sQYWYOLCvV4=;
        b=ilz/5UAiDfTGlXUz4W+e8E4imRg9sSumAF65t0ATDd2N9z+RtOEw1dI5pidDBLc9jz
         YF9q2HWUx70DHttcrVDvtYktnrybQVCXVO5ivg+ZHrNCN9YD0ADpmd87Rh9i3Qug2iGi
         dWpxL/LTSRELrXID1OI1sTNXDElXilkMmcgKj7hk46kRJyWtjRj7IfjFhNTyJ7TtI272
         v+hWKJYg4I6GKAkdnyEejectDqI+x1snIc9H9g+oq161KLPSVQAd9veqmgYGEwbbwlgY
         JbiFgS7n0+4tx6m81s611agRASCWKOxRtsz1IjUKujKHK6x4SSvZ9ZOh/Tfpqjno9FQb
         faJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pFJAWwF2IYFGSuNhyWi8+LxiYsFNqud+sQYWYOLCvV4=;
        b=FVtOMOtcxUeJRrF/AZ3ooFWfdKaLzz1gvUkjXbTTOdheQnmOBZE+dVZshvHCkIdPoV
         V3zyueWnSRWeft5TZhgIA1kM0k09IXYnGcvyXqK0Bonbl6M7Uvmn1KxF7rFwpYkusVrY
         GuW1PjlbDperQDuPE3gF3tcg3shQHIdZfs7AEYNCLG8PAmn+n/AYrHjo17HsPd0CQRtO
         Eek16QkvI75KmK4oApD2gnfhOdh/Px7TRRS/7x1MRem/+oYPapb/oBw2dDW35dvvCefq
         gNUllIPDwMyvDjg0EIqki1D8o126AnWgd/hRH8qp02srp5UnSp7Zg9SBADLlDSi+CKrB
         o2qg==
X-Gm-Message-State: AGi0Pua37YZnQ5uJ6vOIXqM1XHXpULciWaYcqpzaYK6d6xg10eIwEfM2
        De6xf99CZziWrpQGkP4EjuEjrLzqZu2RLlshdPQ5b5pS9OJMSspPDxHf98dgvFIsxEha3u7EFXU
        doGVvXdbDisl299O/dvHiYgwifhngMJ2KbrHTJ9V144IwhAIZs1krCA==
X-Google-Smtp-Source: APiQypLpgdpSnL7AkroQSK9bB8+yELDJ8erlaG2cxk866p0Xwn7u40ViCSM0PmRCG8y2FHgB6pXQObM=
X-Received: by 2002:ad4:5592:: with SMTP id e18mr3908560qvx.13.1588959973480;
 Fri, 08 May 2020 10:46:13 -0700 (PDT)
Date:   Fri,  8 May 2020 10:46:07 -0700
Message-Id: <20200508174611.228805-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH bpf-next v5 0/4] bpf: allow any port in bpf_bind helper
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have a tighter control on what ports we bind to in
the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
connect() becomes slightly more expensive.

The series goes like this:
1. selftests: move existing helpers that make it easy to create
   listener threads into common test_progs part
2. selftests: move some common functionality into network_helpers
3. do small refactoring of __inet{,6}_bind() flags to make it easy
   to extend them with the additional flags
4. remove the restriction on port being zero in bpf_bind() helper;
   add new bind flag to prevent POST_BIND hook from being called

Acked-by: Andrey Ignatov <rdna@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>

Stanislav Fomichev (4):
  selftests/bpf: generalize helpers to control background listener
  selftests/bpf: move existing common networking parts into
    network_helpers
  net: refactor arguments of inet{,6}_bind
  bpf: allow any port in bpf_bind helper

 include/net/inet_common.h                     |   8 +-
 include/net/ipv6_stubs.h                      |   2 +-
 include/uapi/linux/bpf.h                      |   9 +-
 net/core/filter.c                             |  16 ++-
 net/ipv4/af_inet.c                            |  20 +--
 net/ipv6/af_inet6.c                           |  22 ++--
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/network_helpers.c | 110 +++++++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  39 ++++++
 .../bpf/prog_tests/connect_force_port.c       | 115 +++++++++++++++++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   1 +
 .../selftests/bpf/prog_tests/flow_dissector.c |   1 +
 .../prog_tests/flow_dissector_load_bytes.c    |   1 +
 .../selftests/bpf/prog_tests/global_data.c    |   1 +
 .../selftests/bpf/prog_tests/kfree_skb.c      |   1 +
 .../selftests/bpf/prog_tests/l4lb_all.c       |   1 +
 .../selftests/bpf/prog_tests/map_lock.c       |  14 +++
 .../selftests/bpf/prog_tests/pkt_access.c     |   1 +
 .../selftests/bpf/prog_tests/pkt_md_access.c  |   1 +
 .../selftests/bpf/prog_tests/prog_run_xattr.c |   1 +
 .../bpf/prog_tests/queue_stack_map.c          |   1 +
 .../selftests/bpf/prog_tests/signal_pending.c |   1 +
 .../selftests/bpf/prog_tests/skb_ctx.c        |   1 +
 .../selftests/bpf/prog_tests/spinlock.c       |  14 +++
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +-----------------
 tools/testing/selftests/bpf/prog_tests/xdp.c  |   1 +
 .../bpf/prog_tests/xdp_adjust_tail.c          |   1 +
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    |   1 +
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   1 +
 .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
 .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
 tools/testing/selftests/bpf/test_progs.c      |  30 -----
 tools/testing/selftests/bpf/test_progs.h      |  23 ----
 34 files changed, 417 insertions(+), 204 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/network_helpers.c
 create mode 100644 tools/testing/selftests/bpf/network_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c

-- 
2.26.2.645.ge9eca65c58-goog
