Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832632D6B05
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394140AbgLJWbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:20 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33708 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405134AbgLJW0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:26:45 -0500
Received: by mail-pf1-f193.google.com with SMTP id p4so5522784pfg.0;
        Thu, 10 Dec 2020 14:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmpTAXH6TQaMqLKLYHpt2JiaznUgIMZlc7z9SKykbbA=;
        b=IoJgxjjCIdYTjq+UGPavlSUpceKeKXAVWIAoRPwITNeinTNjHZPoSSGXPAs+BJfZRL
         QPKSeO1yIVEyzDHI7PF9HHRayQ9uy9FtaqCnEQ4VJhOpS13Q1LQlkUC9YkGwdwTOlKt5
         KaPxTmlWmpUwoajqOq/umyEAiMKnCxkTot22sZQ1u2IWVgSJJlydKZctOLVHXVPwX1HI
         Oyp+uTwrboewd9mxPXzWFFpNo8tpGg4d2zDoVtEC/bkrkQvN4vIAn3g2DUhFm+DQohzN
         1gT8X4NH3GmIEVICR+iAQdyCeskd2494rgHmCOxy7DeKvqsFDFBnS+nLBWkz5GGkRVvY
         ttFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmpTAXH6TQaMqLKLYHpt2JiaznUgIMZlc7z9SKykbbA=;
        b=qA2Cro73WGnDyMUj5xcOd4g9zCdwRGwrX5AxwVhRZbABIGAX/83FqYgSNlsTNpTyzd
         p6hak9uPSEB9LumhZToqRtpBTSAhzWi+yftyc1MFOZWxhOMAONY5saQI9IiSs+O8mwkh
         mqUvE1ktJu6OwKSEE0ogjWPZR49oh4ONcvADJ3QUp0JcAWKHXWE1InX0SdFWxHEEMQue
         uF1V/Y0LgspT+LUjLq0/qyQ/MiXfAUOB135RMc/q9l3j9OZMwMrGYYk+C+36n/PNbjWM
         5Pa/EjLJsY1aEt4MHRtej3/FJldtrPCUNwKGkOV0U4RpE5GLnvVdzylx4FZEb6OivWtX
         rjXA==
X-Gm-Message-State: AOAM531I2vof19s3PrqExSjDwY9/Lt7G4juwCyCydY0Go46afhgCoDiE
        IH6SE/tZNOnUfbuONWrZWZk=
X-Google-Smtp-Source: ABdhPJzf5Ivvk2hvyIrirBsLROfWSW1Q1CpU7j7hQ3CEe51NdmdYhCEVLUHUnLnWDWi7BGi6NisHIQ==
X-Received: by 2002:a17:90a:a502:: with SMTP id a2mr5704214pjq.155.1607639104736;
        Thu, 10 Dec 2020 14:25:04 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id d142sm7326953pfd.6.2020.12.10.14.25.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 14:25:03 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2020-12-10
Date:   Thu, 10 Dec 2020 14:25:01 -0800
Message-Id: <20201210222501.72430-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 21 non-merge commits during the last 12 day(s) which contain
a total of 21 files changed, 163 insertions(+), 88 deletions(-).

The main changes are:

1) Fix propagation of 32-bit signed bounds from 64-bit bounds, from Alexei.

2) Fix ring_buffer__poll() return value, from Andrii.

3) Fix race in lwt_bpf, from Cong.

4) Fix test_offload, from Toke.

5) Various xsk fixes.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Cong Wang, Hulk Robot, Jakub Kicinski, Jean-Philippe Brucker, John 
Fastabend, Magnus Karlsson, Maxim Mikityanskiy, Yonghong Song

----------------------------------------------------------------

The following changes since commit 4d521943f76bd0d1e68ea5e02df7aadd30b2838a:

  dt-bindings: net: correct interrupt flags in examples (2020-11-28 14:47:56 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 3615bdf6d9b19db12b1589861609b4f1c6a8d303:

  selftests/bpf: Fix "dubious pointer arithmetic" test (2020-12-10 13:11:30 -0800)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix propagation of 32-bit signed bounds from 64-bit bounds.

Andrii Nakryiko (3):
      libbpf: Fix ring_buffer__poll() to return number of consumed samples
      selftests/bpf: Drain ringbuf samples at the end of test
      tools/bpftool: Fix PID fetching with a lot of results

Björn Töpel (1):
      xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in xdp_return_buff()

Cong Wang (1):
      lwt_bpf: Replace preempt_disable() with migrate_disable()

Daniel Borkmann (1):
      Merge branch 'bpf-xdp-offload-fixes'

Dongdong Wang (1):
      lwt: Disable BH too in run_lwt_bpf()

Jean-Philippe Brucker (3):
      selftests/bpf: Add test for signed 32-bit bound check bug
      selftests/bpf: Fix array access with signed variable test
      selftests/bpf: Fix "dubious pointer arithmetic" test

KP Singh (1):
      bpf, doc: Update KP's email in MAINTAINERS

Toke Høiland-Jørgensen (7):
      xdp: Remove the xdp_attachment_flags_ok() callback
      selftests/bpf/test_offload.py: Remove check for program load flags match
      netdevsim: Add debugfs toggle to reject BPF programs in verifier
      selftests/bpf/test_offload.py: Only check verifier log on verification fails
      selftests/bpf/test_offload.py: Fix expected case of extack messages
      selftests/bpf/test_offload.py: Reset ethtool features after failed setting
      selftests/bpf/test_offload.py: Filter bpftool internal map when counting maps

Xuan Zhuo (2):
      xsk: Replace datagram_poll by sock_poll_wait
      xsk: Change the tx writeable condition

Zhang Changzhong (1):
      xsk: Return error code if force_zc is set

 MAINTAINERS                                        |  4 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  6 ---
 drivers/net/ethernet/ti/cpsw_priv.c                |  3 --
 drivers/net/netdevsim/bpf.c                        | 15 ++++--
 drivers/net/netdevsim/netdevsim.h                  |  1 +
 include/net/xdp.h                                  |  2 -
 kernel/bpf/verifier.c                              | 10 ++--
 net/core/dev.c                                     | 22 ++++++++-
 net/core/lwt_bpf.c                                 | 12 ++---
 net/core/xdp.c                                     | 29 ++++--------
 net/xdp/xsk.c                                      | 20 ++++++--
 net/xdp/xsk_buff_pool.c                            |  1 +
 net/xdp/xsk_queue.h                                |  6 +++
 tools/bpf/bpftool/pids.c                           |  4 +-
 tools/lib/bpf/ringbuf.c                            |  2 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |  8 ++--
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |  8 +++-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |  2 +-
 tools/testing/selftests/bpf/test_offload.py        | 53 ++++++++++++----------
 .../testing/selftests/bpf/verifier/array_access.c  |  2 +-
 tools/testing/selftests/bpf/verifier/bounds.c      | 41 +++++++++++++++++
 21 files changed, 163 insertions(+), 88 deletions(-)
