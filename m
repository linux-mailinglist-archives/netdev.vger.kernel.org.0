Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A923447C03
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbhKHImK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhKHImJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4992C061570;
        Mon,  8 Nov 2021 00:39:24 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id iq11so7576342pjb.3;
        Mon, 08 Nov 2021 00:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xlgz5f/1O7j1fYQGwZaGYM2sPo7uBwCryb9I1PFva10=;
        b=mu+nQO3yTipG+EFeCqkGRpcXAHGb/8gxmZo+EDH9ytABe13PJCvj7yg40gSQ6BtopL
         W9cd7aLMbBxdIqQBDagjm5iSOLlZY5z016L1Wv/9B4M9HPspxdxK3cSEeNdPyAvXHC+t
         sescGDiM5vgOCBS7t2DeIhrjjZ14RQft4d+NRhEok4L8unqGF8CcIcek+xBmrSsRjVN8
         nVO3O2hheXB7EEmUUFvxj8JoJ/3FMtFdQaZfBpn/+hZmAIg1DMcsPC8f5Acm3rIaAQRS
         IiilGsYGP4yID21gz87Lttl9qljFoCNit3ACWlNxRWSR+Vi3ScaMIpQKr8HyhPtTG4T3
         kTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xlgz5f/1O7j1fYQGwZaGYM2sPo7uBwCryb9I1PFva10=;
        b=5TBIXvMVrC7d/Fl+S8GFAgvCAhGRdOSJ4QMHVHdH+GdWxX1zw664VoLPmsRUV6GHUq
         Lmb42ZZLRln8gEddQoXRKAHDzEgVPW0w9tmlPkowfULXQRR/M/9b5eBsNInVytAQ2JpP
         MtsbV8vQ1eRClWLS2b1I25ARcUDgipmeVLKg0xp4i3AitZwJwv0qGkRomeHjaqCeqZir
         yUL9BPbQpD57T4rm6GyK4SMm32GvYnOyIYiHRUeMhGpNE2iFK3UElk0B80cAW1JaLlE9
         k1FCJrvrDUgGBUvkBMLNbgE/feMXoL7zktO9qpzaWpuld/bihzBiXqGx9ABt8rBDvLI4
         HDCw==
X-Gm-Message-State: AOAM530Nwx1AF+dAqT72ftfzkZdXIqeEHT7OBXDpnGRTMTqmPNdOu7o+
        ZlUI1I9vtsEKeLwHWvYt7dc=
X-Google-Smtp-Source: ABdhPJy1+50gPKAmCT9Y0ZwuuPEAhduRynsf7+l9Q3TeWobNCHK2T8eiL59YlBTlGbJV4bZzZldAdA==
X-Received: by 2002:a17:90a:5986:: with SMTP id l6mr50152993pji.215.1636360764275;
        Mon, 08 Nov 2021 00:39:24 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:23 -0800 (PST)
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
Subject: [PATCH 0/7] task comm cleanups 
Date:   Mon,  8 Nov 2021 08:38:33 +0000
Message-Id: <20211108083840.4627-1-laoar.shao@gmail.com>
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

All of the patches except patch #4 have either a reviewed-by or a
acked-by now. I have verfied that the vmcore/crash works well after
patch #4.

[1]. https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/lkml/CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com/

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
  fs/exec: make __set_task_comm always set a nul terminated string
  fs/exec: make __get_task_comm always get a nul terminated string
  drivers/infiniband: use get_task_comm instead of open-coded string
    copy
  fs/binfmt_elf: use get_task_comm instead of open-coded string copy
  samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size
    change
  tools/bpf/bpftool/skeleton: use bpf_probe_read_kernel_str to get task
    comm
  tools/testing/selftests/bpf: make it adopt to task comm size change

 drivers/infiniband/hw/qib/qib.h                       |  2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c              |  2 +-
 fs/binfmt_elf.c                                       |  2 +-
 fs/exec.c                                             |  5 +++--
 include/linux/sched.h                                 |  9 +++++++--
 samples/bpf/offwaketime_kern.c                        |  4 ++--
 samples/bpf/test_overhead_kprobe_kern.c               | 11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c                   |  5 +++--
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c             |  4 ++--
 .../testing/selftests/bpf/progs/test_stacktrace_map.c |  6 +++---
 tools/testing/selftests/bpf/progs/test_tracepoint.c   |  6 +++---
 11 files changed, 32 insertions(+), 24 deletions(-)

-- 
2.17.1

