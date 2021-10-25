Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAE439141
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhJYIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhJYIgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0759CC061745;
        Mon, 25 Oct 2021 01:33:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gn3so7715160pjb.0;
        Mon, 25 Oct 2021 01:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=baWGvL41dy19+4BZX6uDav+aolsx9Dk7kQUgS64bb1g=;
        b=as4g3fNzeC53JV1QW9l3PceZ7FSLOqm+yJq6vNLpKffQFUNwOQ+76VDeleJozGL7V5
         iIlFN02m6BFIhPRcEpe89vDEbCKxXwF0QDCz+IjNrDjf7Ob6aZdvBz2N/w4XeY5Fsyo/
         HVIzT0+QzJxtY5uoGe4XRnu56S79bMx0ec9tlZ7EBU7jt1MXf7O/Ljv5tf7eAYgyeeFB
         Hr/mNV8SFuF6TX8jVuKlzv985B1MruvJuXFg/kLvO/xXhxVRdiHnIgIRaToqE9uYh8ku
         UWborlia3oFOLcABtOiMjP7UPbJZuv5ik1GjBmrgKJxHZHS+xlL7r2v7mKniBRH6ng4V
         3r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=baWGvL41dy19+4BZX6uDav+aolsx9Dk7kQUgS64bb1g=;
        b=JyM9pOinhbe3Dx/ak2td5DFtWBMmhhnCWX+3gWwe88vZlf+4bIh3hADgEoA/GCZU1q
         mHSPxunAFzfViLb2kIQQqAd45wpV4HEbjyTgfQjd60Dq3N5Ng3YyFp88d1T8jBKZsswf
         Fc2OMQ0ORHPhU06NcvkXDLmQIvE+uscgbCRDcSrjjMjlZEVoDEGha1dZWlkPzylOnbUO
         n8eqtJo6++t4iHU2tQoXE9pTuF24enBmSS7f7UMut/Avm8XRxwhUcrv4muLYU7yM2Veu
         b/KCEc9AL5jqOj9CfvBayuj7ybl4SSM+q8t2mpVW8aXma2Rfd0JvJ/HbuAOFptcfEV9R
         gqHg==
X-Gm-Message-State: AOAM5332xMsSp74YeD/m6SwoQJRrtUbmEqQoHWP1R53lphvUqu0x1nly
        ILfwQ/CJGoUFf9NEkWlfjRM=
X-Google-Smtp-Source: ABdhPJwKKV3YHe5Kx2TD+5yPgrUQbt8S2s5EfBAbZQQPLcMJjqzjQTN1qjux7zaNTymJGxsM9r7acw==
X-Received: by 2002:a17:90b:2247:: with SMTP id hk7mr4087767pjb.159.1635150822423;
        Mon, 25 Oct 2021 01:33:42 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:42 -0700 (PDT)
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
Subject: [PATCH v6 00/12] extend task comm from 16 to 24
Date:   Mon, 25 Oct 2021 08:33:03 +0000
Message-Id: <20211025083315.4752-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There're many truncated kthreads in the kernel, which may make trouble
for the user, for example, the user can't get detailed device
information from the task comm.

This patchset tries to improve this problem fundamentally by extending
the task comm size from 16 to 24. In order to do that, we have to do
some cleanups first.

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

Yafang Shao (12):
  fs/exec: make __set_task_comm always set a nul ternimated string
  fs/exec: make __get_task_comm always get a nul terminated string
  drivers/connector: make connector comm always nul ternimated
  drivers/infiniband: make setup_ctxt always get a nul terminated task
    comm
  elfcore: make prpsinfo always get a nul terminated task comm
  samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size
    change
  samples/bpf/offwaketime_kern: make sched_switch tracepoint args adopt
    to comm size change
  tools/bpf/bpftool/skeleton: make it adopt to task comm size change
  tools/perf/test: make perf test adopt to task comm size change
  tools/testing/selftests/bpf: make it adopt to task comm size change
  sched.h: extend task comm from 16 to 24
  kernel/kthread: show a warning if kthread's comm is truncated

 drivers/connector/cn_proc.c                   |  5 +++-
 drivers/infiniband/hw/qib/qib.h               |  2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c      |  2 +-
 fs/binfmt_elf.c                               |  2 +-
 fs/exec.c                                     |  5 ++--
 include/linux/elfcore-compat.h                |  3 ++-
 include/linux/elfcore.h                       |  4 +--
 include/linux/sched.h                         |  9 +++++--
 kernel/kthread.c                              |  7 ++++-
 samples/bpf/offwaketime_kern.c                |  4 +--
 samples/bpf/test_overhead_kprobe_kern.c       | 11 ++++----
 samples/bpf/test_overhead_tp_kern.c           |  5 ++--
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c     |  4 +--
 tools/include/linux/sched.h                   | 11 ++++++++
 tools/perf/tests/evsel-tp-sched.c             | 26 ++++++++++++++-----
 .../selftests/bpf/progs/test_stacktrace_map.c |  6 ++---
 .../selftests/bpf/progs/test_tracepoint.c     |  6 ++---
 17 files changed, 77 insertions(+), 35 deletions(-)
 create mode 100644 tools/include/linux/sched.h

-- 
2.17.1

