Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D26457D45
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhKTLbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhKTLbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:02 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F467C061574;
        Sat, 20 Nov 2021 03:27:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so12921130pju.3;
        Sat, 20 Nov 2021 03:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mgmaoQ7WVjX7ocxIMV0FACmVlj4LoHfwU5mj0OexKdM=;
        b=S4y3JwNRrMAGuMJwsosIe3PcJ6XbMkUHIl9d954eAGt+u+QBFQcKtabuwG91d5g0jl
         IrZqpSurc/H8YMbS9n/LDTla/KFUN9aX9mVT75HQ5Qa06BJQ5Fb2wAE544GL63b123Ey
         6/PEmk/PWD18fAIWvNaXduPSG8WPUa+D0QY+rlqnXhr8EGUwJ5oUXPs/9QlGXcv+aXSS
         3emz8G442htfK6TmiJ1jgPNS68AEnqsD2UnWYg2sgq/H/MeZ1E/A3PR7otTqF9lEa13J
         wV8AnvYPh99RbLsZTetAkg9ad+hQcTJzbdMcM+QtNSPJXYP6sNdWzlcUqrgjWKk5Wn59
         XqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mgmaoQ7WVjX7ocxIMV0FACmVlj4LoHfwU5mj0OexKdM=;
        b=NPr1042hhLFAixHTEeWCF2b5u1kGwbc+Vtj7PddkZ4pl6pyVHYBBKX/uoWbiE77TNR
         kcpP5257lXmV6Dato2qOu0Ied9dMtA2fRxmHlrUDF7kb/Y2hDx/oF1jNU4GS+i6D/6bd
         uxEh516RF/FK8tbNZRb7mJkjYzMiIxq7fcDsdwO3ORXEO1+wgbzr+VXWm4q237qM7wZt
         ToKoEASkg5rENMiHQzz7wfnSa094XFFth0Kxa+4KbkORJ6fi5N7cs7XTNrz8naF1ZuQT
         V2UDLf/G/hQatgscYec99NPhJw5fxVzFxPuSXaRLdn80+c4tAnc6LdmGukp9QcDTxTf5
         g+wA==
X-Gm-Message-State: AOAM5314fpfPPRmMEJolaeGubtrpUTuAQtVWBN2FKcl86cONpgqv1QNS
        VvSLiDLzkyyyaMIzDlqNgHU=
X-Google-Smtp-Source: ABdhPJyxGUG4Lf6ezqV5ps6fISVl14knM2EzOSeswUoGLe+KRCige/jJED6Ic8dKukjHNTV2PFTiKA==
X-Received: by 2002:a17:90a:c398:: with SMTP id h24mr9332156pjt.73.1637407679121;
        Sat, 20 Nov 2021 03:27:59 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:27:58 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 0/7] task comm cleanups 
Date:   Sat, 20 Nov 2021 11:27:31 +0000
Message-Id: <20211120112738.45980-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is part of the patchset "extend task comm from 16 to 24"[1].
Now we have different opinion that dynamically allocates memory to store
kthread's long name into a separate pointer, so I decide to take the useful
cleanups apart from the original patchset and send it separately[2].

These useful cleanups can make the usage around task comm less
error-prone. Furthermore, it will be useful if we want to extend task
comm in the future.

[1]. https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/lkml/CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com/

Changes since v1:
- improve the subject and description
- add comment to explain the hard-coded 16 in patch #4

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>

Yafang Shao (7):
  fs/exec: replace strlcpy with strscpy_pad in __set_task_comm
  fs/exec: replace strncpy with strscpy_pad in __get_task_comm
  drivers/infiniband: replace open-coded string copy with get_task_comm
  fs/binfmt_elf: replace open-coded string copy with get_task_comm
  samples/bpf/test_overhead_kprobe_kern: replace bpf_probe_read_kernel
    with bpf_probe_read_kernel_str to get task comm
  tools/bpf/bpftool/skeleton: replace bpf_probe_read_kernel with
    bpf_probe_read_kernel_str to get task comm
  tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN

 drivers/infiniband/hw/qib/qib.h                       |  2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c              |  2 +-
 fs/binfmt_elf.c                                       |  2 +-
 fs/exec.c                                             |  5 +++--
 include/linux/elfcore-compat.h                        |  5 +++++
 include/linux/elfcore.h                               |  5 +++++
 include/linux/sched.h                                 |  9 +++++++--
 samples/bpf/offwaketime_kern.c                        |  4 ++--
 samples/bpf/test_overhead_kprobe_kern.c               | 11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c                   |  5 +++--
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c             |  4 ++--
 .../testing/selftests/bpf/progs/test_stacktrace_map.c |  6 +++---
 tools/testing/selftests/bpf/progs/test_tracepoint.c   |  6 +++---
 13 files changed, 42 insertions(+), 24 deletions(-)

-- 
2.17.1

