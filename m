Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CDE44135E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhKAGHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhKAGHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E769DC061714;
        Sun, 31 Oct 2021 23:04:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so15255713pji.5;
        Sun, 31 Oct 2021 23:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a2/IouPNFu5wyi245xdRfAAYC7lsGcupBh9KGLXXf00=;
        b=YsWtHI6NsvXSt6QQfPqv/Qv3K3tSJyfjP7ZoAV7ft7WfMR0HAqKm2asGGcRqw8t0GG
         om278XoO9zST4aqVEUeuY+jzGZFqlRrjdqfXmua+YSEZ+Z0QsqaM/YYyZ41x/ZuLuRAl
         sH2FhiEYN916iT658X2n7AqspVWS+RD110yr9oH13jwoCUB8Siejv04Fhml68LE7g4oL
         OIH/l9/tO7HBLTFjrszzJKqQ3ib3Kmu7nFS08QtyJQIPxxGaJOAD6HB8t5lWifwBgeLh
         7NyysJZw7YEPxu+1e+9mGJuNnvlGDgj/XeuJK7Yqdxl9ncBzLpPoeISRrKYQdAcX/mna
         HnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a2/IouPNFu5wyi245xdRfAAYC7lsGcupBh9KGLXXf00=;
        b=1aq+CYFno88VjNxYc8q0UqO3LpqrN3QFdfS+5NIQ6E8mNCC4iM1N/WMDs66A4Audxc
         6O80lSxwvbqksr5ZC0ZquzDc8gsPuVI4pIkbSt69mKsevr9prSc1+wwoXNtlafLWCLeI
         /pNxyF24E8UlvZe/5fYb5LCMIspqwbNPDprB0JyhXDFJfgSPZ/BTJ390HcZalCCNjD7d
         13pSPsp6cNJ2FuX4nOlNvEU/bUbgwuczKVK8cpOStxTIvyzNwZ7yhjncYRl/20Uea25+
         zlGZtO1FJeXZcLX3sx4IphRZcKOWlaFjG5QJVj7f8VSy4ZzzSXygIU/eTwxI0C4uvcbQ
         YNbg==
X-Gm-Message-State: AOAM530Crpvoo9djIVJXc7WIztLk/tMPK73B994C2S17KrnyQfZEAzsY
        w9o1AfUQfIygDZLp/5WkZIEzwWNw4XtARCVR
X-Google-Smtp-Source: ABdhPJzkg/WAYLUl9ag3Y8j/TZPBBsECAfgkSD6Vu+aWqdh9BmnGXE4iyfjNXyhkMiAqtmk9oQgGNg==
X-Received: by 2002:a17:90a:5d89:: with SMTP id t9mr27144039pji.21.1635746669453;
        Sun, 31 Oct 2021 23:04:29 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:28 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 00/11] extend task comm from 16 to 24 
Date:   Mon,  1 Nov 2021 06:04:08 +0000
Message-Id: <20211101060419.4682-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There're many truncated kthreads in the kernel, which may make trouble
for the user, for example, the user can't get detailed device
information from the task comm.

This patchset tries to improve this problem fundamentally by extending
the task comm size from 16 to 24, which is a very simple way. 

In order to do that, we have to do some cleanups first.

1. Make the copy of task comm always safe no matter what the task
   comm size is. For example,

      Unsafe                 Safe
      strlcpy                strscpy_pad
      strncpy                strscpy_pad
      bpf_probe_read_kernel  bpf_probe_read_kernel_str
                             bpf_core_read_str
                             bpf_get_current_comm
                             perf_event__prepare_comm
                             prctl(2)

   After this step, the comm size change won't make any trouble to the
   kernel or the in-tree tools for example perf, BPF programs.

2. Cleanup some old hard-coded 16
   Actually we don't need to convert all of them to TASK_COMM_LEN or
   TASK_COMM_LEN_16, what we really care about is if the convert can
   make the code more reasonable or easier to understand. For
   example, some in-tree tools read the comm from sched:sched_switch
   tracepoint, as it is derived from the kernel, we'd better make them
   consistent with the kernel.

3. Extend the task comm size from 16 to 24
   task_struct is growing rather regularly by 8 bytes. This size change
   should be acceptable. We used to think about extending the size for
   CONFIG_BASE_FULL only, but that would be a burden for maintenance
   and introduce code complexity.

4. Print a warning if the kthread comm is still truncated.

5. What will happen to the out-of-tree tools after this change?
   If the tool get task comm through kernel API, for example prctl(2),
   bpf_get_current_comm() and etc, then it doesn't matter how large the
   user buffer is, because it will always get a string with a nul
   terminator. While if it gets the task comm through direct string copy,
   the user tool must make sure the copied string has a nul terminator
   itself. As TASK_COMM_LEN is not exposed to userspace, there's no
   reason that it must require a fixed-size task comm.

Changes since v6:
Various suggestion from Kees:
- replace strscpy_pad() with the helper get_task_comm()
- fix typo
- replace BUILD_BUG_ON() with __must_be_array()
- don't change the size of pr_fname
- merge two samples/bpf/ patches to one patch
- keep TASK_COMM_LEN_16 per

Changes since v5:
- extend the comm size for both CONFIG_BASE_{FULL, SMALL} that could
  make the code more simple and easier to maintain.
- avoid changing too much hard-coded 16 in BPF programs per Andrii.

Changes since v4:
- introduce TASK_COMM_LEN_16 and TASK_COMM_LEN_24 per Steven
- replace hard-coded 16 with TASK_COMM_LEN_16 per Kees
- use strscpy_pad() instead of strlcpy()/strncpy() per Kees
- make perf test adopt to task comm size change per Arnaldo and Mathieu
- fix warning reported by kernel test robot

Changes since v3:
- fixes -Wstringop-truncation warning reported by kernel test robot

Changes since v2:
- avoid change UAPI code per Kees
- remove the description of out of tree code from commit log per Peter

Changes since v1:
- extend task comm to 24bytes, per Petr
- improve the warning per Petr
- make the checkpatch warning a separate patch


Yafang Shao (11):
  fs/exec: make __set_task_comm always set a nul terminated string
  fs/exec: make __get_task_comm always get a nul terminated string
  sched.h: use __must_be_array instead of BUILD_BUG_ON in get_task_comm
  drivers/infiniband: make setup_ctxt always get a nul terminated task
    comm
  fs/binfmt_elf: make prpsinfo always get a nul terminated task comm
  samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size
    change
  tools/bpf/bpftool/skeleton: make it adopt to task comm size change
  tools/perf/test: make perf test adopt to task comm size change
  tools/testing/selftests/bpf: make it adopt to task comm size change
  sched.h: extend task comm from 16 to 24
  kernel/kthread: show a warning if kthread's comm is truncated

 drivers/infiniband/hw/qib/qib.h               |  2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c      |  2 +-
 fs/binfmt_elf.c                               |  2 +-
 fs/exec.c                                     |  5 ++--
 include/linux/sched.h                         | 16 +++++++-----
 kernel/kthread.c                              |  7 ++++-
 samples/bpf/offwaketime_kern.c                |  4 +--
 samples/bpf/test_overhead_kprobe_kern.c       | 11 ++++----
 samples/bpf/test_overhead_tp_kern.c           |  5 ++--
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c     |  4 +--
 tools/include/linux/sched.h                   | 11 ++++++++
 tools/perf/tests/evsel-tp-sched.c             | 26 ++++++++++++++-----
 .../selftests/bpf/progs/test_stacktrace_map.c |  6 ++---
 .../selftests/bpf/progs/test_tracepoint.c     |  6 ++---
 14 files changed, 72 insertions(+), 35 deletions(-)
 create mode 100644 tools/include/linux/sched.h

-- 
2.17.1

