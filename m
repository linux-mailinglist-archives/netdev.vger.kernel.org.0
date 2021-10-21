Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69C443593B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhJUDrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUDri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC58C06161C;
        Wed, 20 Oct 2021 20:45:23 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t184so4738930pfd.0;
        Wed, 20 Oct 2021 20:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5kRttFnqDyMni18OAxsto47TLeLeI3Z8fqyF7mE1Fis=;
        b=kLRVNCc05x5aMMjJPHURO3uO5yA6yK8P7nuiOxqIMaJpJRtzMsYEDfh/i74qsxVHmC
         6e7nz8q9C9OEg/sM4FO08Z2HpbQF+t0/jShPa7XyK9r/N+B6bD0M5E+dl+CsRbD31qGW
         0Qfu5p3JMmqgwcpGpi2SS0/JLUFWvSH1181NwLJdWbdqLGrYQJglCKkDnoRq+yDY30+v
         9D8I2MPD6nLvvMG16iOczMpbkd0gwWrCtlGvA2tMAZTb29tMlg5xXKNWwD3JF8K6Pk5P
         Em1thcMLiIQOeyATJgfeJ2M08i9bopTCdv6BV2RPDgXADvotw0tpOWI4gOBK0co3Egph
         N+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5kRttFnqDyMni18OAxsto47TLeLeI3Z8fqyF7mE1Fis=;
        b=vIjoTpLVY438YCwBXU29+9jxOfjvxB5Tgxk99M7H3YqrPzWfcwJSOtC2n4uxIwpaPd
         9r3XkeFmn2bVpZCAArl3322riwOJPfyIzbuup01XSquLXmUmz1IajGikvSK30LCwqyHB
         62qTapjFVMr4WnjqKsD8nrKNmcl3lUsBQqVGrprs/40WqUEOGTBciOT3ziRwqCp7LH1t
         kddmHPSOXTwWlXp55K8JVpc6Ni9+hKMKAtaodSPdOgYIUEVxvY9WTlTkKRlG+hJ7aVPc
         WUvE6I7c+ZTMuB+I3vxZIAd1YLSiLPaK2ta5NdwQ17FMWsZK0u98AoyI2/BxL0JzvSIN
         kyHQ==
X-Gm-Message-State: AOAM533nK0QcGtp2j/qgm0kU7bDEyhfpyUghHC52FrIlmvG3PQ3o0Sv3
        ANVkNVifxIx6KGr2hxBZV4A=
X-Google-Smtp-Source: ABdhPJxDUWZxORefBHkXUWJn7UmjFJRQi36sfn7/BgQlaQ/sisJbzvS6natUXJR1teZtLta231GinQ==
X-Received: by 2002:aa7:88c2:0:b0:46c:3c50:bcc2 with SMTP id k2-20020aa788c2000000b0046c3c50bcc2mr1239865pff.71.1634787922886;
        Wed, 20 Oct 2021 20:45:22 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:22 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 00/15] extend task comm from 16 to 24 for CONFIG_BASE_FULL 
Date:   Thu, 21 Oct 2021 03:45:07 +0000
Message-Id: <20211021034516.4400-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset changes files among many subsystems. I don't know which
tree it should be applied to, so I just base it on Linus's tree.

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

2. Replace the old hard-coded 16 with a new macro TASK_COMM_LEN_16 to
make it more grepable.

3. Extend the task comm size to 24 for CONFIG_BASE_FULL case and keep it
as 16 for CONFIG_BASE_SMALL.

4. Print a warning if the kthread comm is still truncated.

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

Yafang Shao (15):
  fs/exec: make __set_task_comm always set a nul ternimated string
  fs/exec: make __get_task_comm always get a nul terminated string
  sched.h: introduce TASK_COMM_LEN_16
  cn_proc: make connector comm always nul ternimated
  drivers/infiniband: make setup_ctxt always get a nul terminated task
    comm
  elfcore: make prpsinfo always get a nul terminated task comm
  samples/bpf/kern: use TASK_COMM_LEN instead of hard-coded 16
  samples/bpf/user: use TASK_COMM_LEN_16 instead of hard-coded 16
  tools/include: introduce TASK_COMM_LEN_16
  tools/lib/perf: use TASK_COMM_LEN_16 instead of hard-coded 16
  tools/bpf/bpftool: use TASK_COMM_LEN_16 instead of hard-coded 16
  tools/perf/test: make perf test adopt to task comm size change
  tools/testing/selftests/bpf: use TASK_COMM_LEN_16 instead of
    hard-coded 16
  sched.h: extend task comm from 16 to 24 for CONFIG_BASE_FULL
  kernel/kthread: show a warning if kthread's comm is truncated

 drivers/connector/cn_proc.c                   |  5 +++-
 drivers/infiniband/hw/qib/qib.h               |  4 +--
 drivers/infiniband/hw/qib/qib_file_ops.c      |  2 +-
 fs/binfmt_elf.c                               |  2 +-
 fs/exec.c                                     |  5 ++--
 include/linux/elfcore-compat.h                |  3 ++-
 include/linux/elfcore.h                       |  4 +--
 include/linux/sched.h                         | 11 +++++++-
 include/uapi/linux/cn_proc.h                  |  7 ++++-
 kernel/kthread.c                              |  7 ++++-
 samples/bpf/offwaketime_kern.c                | 10 +++----
 samples/bpf/offwaketime_user.c                |  6 ++---
 samples/bpf/test_overhead_kprobe_kern.c       | 11 ++++----
 samples/bpf/test_overhead_tp_kern.c           |  5 ++--
 samples/bpf/tracex2_kern.c                    |  3 ++-
 samples/bpf/tracex2_user.c                    |  7 ++---
 tools/bpf/bpftool/Makefile                    |  1 +
 tools/bpf/bpftool/main.h                      |  3 ++-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c     |  4 +--
 tools/bpf/bpftool/skeleton/pid_iter.h         |  4 ++-
 tools/include/linux/sched/task.h              |  3 +++
 tools/lib/perf/include/perf/event.h           |  5 ++--
 tools/perf/tests/evsel-tp-sched.c             | 26 ++++++++++++++-----
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/ringbuf.c        |  3 ++-
 .../selftests/bpf/prog_tests/ringbuf_multi.c  |  3 ++-
 .../bpf/prog_tests/sk_storage_tracing.c       |  3 ++-
 .../selftests/bpf/prog_tests/test_overhead.c  |  3 ++-
 .../bpf/prog_tests/trampoline_count.c         |  3 ++-
 tools/testing/selftests/bpf/progs/profiler.h  |  7 ++---
 .../selftests/bpf/progs/profiler.inc.h        |  8 +++---
 tools/testing/selftests/bpf/progs/pyperf.h    |  4 +--
 .../testing/selftests/bpf/progs/strobemeta.h  |  6 ++---
 .../bpf/progs/test_core_reloc_kernel.c        |  3 ++-
 .../selftests/bpf/progs/test_ringbuf.c        |  3 ++-
 .../selftests/bpf/progs/test_ringbuf_multi.c  |  3 ++-
 .../bpf/progs/test_sk_storage_tracing.c       |  5 ++--
 .../selftests/bpf/progs/test_skb_helpers.c    |  5 ++--
 .../selftests/bpf/progs/test_stacktrace_map.c |  5 ++--
 .../selftests/bpf/progs/test_tracepoint.c     |  5 ++--
 40 files changed, 135 insertions(+), 74 deletions(-)

-- 
2.17.1

