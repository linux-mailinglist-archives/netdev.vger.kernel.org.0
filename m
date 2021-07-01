Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E093B966E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhGATXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhGATXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597D7C061762;
        Thu,  1 Jul 2021 12:20:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q91so4866684pjk.3;
        Thu, 01 Jul 2021 12:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPsySaJOV0CELwfmp3Orr8+aG/d5hkMyGgVtrCDVdRA=;
        b=GFAHhJAftFW22H1vjO0b897SW04dqlVsirDsQ74PNLQc9woIA9FQD15k3K0C1AzgWW
         O8tsK8nOVoEEhjUC//KfFfaY64Dvt+xcdLVAjJHdu43s0GXcMqT6wEXHYcnT2GzuioX8
         i09kOwxOC0OTsDatexA4Bc9GP4gc4o//lW0H86NJCVsoXfYX3c/+7FwP3c5jaqpWY8OJ
         nDmG7JaaCYwxyu1E3jO7rMgv97UhbAx06Qmged/cBse/I2wSQvqP+johs+YKOesKsF5P
         qaQp1CV+2cLyihm+sAc4jgz4AKKR494AkQ55jA+Vp33EsUHL3NuH0WFmBk8WSV+j9BcX
         7i5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPsySaJOV0CELwfmp3Orr8+aG/d5hkMyGgVtrCDVdRA=;
        b=ZXtLWNZaW/1kGHV5RxVZXoNj7nblPZvcIq/STi8moWb1ewuU46QN/iM+dW7hHIxVnR
         EHwJ1GGCLikBMs16u3lVZnrpw7jzLfAK8qK4s/LzyNJsEu1HeozBORAvG0Ty7s+Vqh4L
         8l3y2xBmwyCb3IC/oCJ17AN+5rDIXDXcVHfeo/jE4s2ovzvoZ7R/wwlGmo3ahGX+3C8T
         Rthe304YfE352DvYBiPYmPU9S/0BiCYq2egxAASlVVg+ZMCXFa3YFlAj0zPezefRxzVp
         WHtW0OmT/F2gZYKnHAREOzGTkX1Pc7mxv6drQBpCBwxMtNjzeXW5StPtyp+jUwV5eRLD
         W1pg==
X-Gm-Message-State: AOAM531rEI2nzVGhIqnEfFl2pCvbVqpQquR4Fc9m+KHfCw42Dax9GkWM
        HL9d46PQtFKpeTOcHtiNvMDRFfqAGfs=
X-Google-Smtp-Source: ABdhPJxQRX+y/7xBuTS0e7lT+2vo/yxahrS3pyOdaG9r3cg6Sv+0LpnB7r0ftK3tVYvLxvKTw8uKvQ==
X-Received: by 2002:a17:90b:2352:: with SMTP id ms18mr95216pjb.43.1625167247767;
        Thu, 01 Jul 2021 12:20:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.20.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:20:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 0/9] bpf: Introduce BPF timers.
Date:   Thu,  1 Jul 2021 12:20:35 -0700
Message-Id: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The first request to support timers in bpf was made in 2013 before sys_bpf syscall
was added. That use case was periodic sampling. It was address with attaching
bpf programs to perf_events. Then during XDP development the timers were requested
to do garbage collection and health checks. They were worked around by implementing
timers in user space and triggering progs with BPF_PROG_RUN command.
The user space timers and perf_event+bpf timers are not armed by the bpf program.
They're done asynchronously vs program execution. The XDP program cannot send a
packet and arm the timer at the same time. The tracing prog cannot record an
event and arm the timer right away. This large class of use cases remained
unaddressed. The jiffy based and hrtimer based timers are essential part of the
kernel development and with this patch set the hrtimer based timers will be
available to bpf programs.

TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
to make sure bpf progs cannot crash the kernel.

v3->v4:
1.
Split callback_fn from bpf_timer_start into bpf_timer_set_callback as
suggested by Martin. That makes bpf timer api match one to one to
kernel hrtimer api and provides greater flexibility.
2.
Martin also discovered the following issue with uref approach:
bpftool prog load xdp_timer.o /sys/fs/bpf/xdp_timer type xdp
bpftool net attach xdpgeneric pinned /sys/fs/bpf/xdp_timer dev lo
rm /sys/fs/bpf/xdp_timer
nc -6 ::1 8888
bpftool net detach xdpgeneric dev lo
The timer callback stays active in the kernel though the prog was detached
and map usercnt == 0.
It happened because 'bpftool prog load' pinned the prog only.
The map usercnt went to zero. Subsequent attach and runs didn't
affect map usercnt. The timer was able to start and bpf_prog_inc itself.
When the prog was detached the prog stayed active.
To address this issue added
if (!atomic64_read(&(t->map->usercnt))) return -EPERM;
to the first patch.
Which means that timers are allowed only in the maps that are held
by user space with open file descriptor or maps pinned in bpffs.
3.
Discovered that timers in inner maps were broken.
The inner map pointers are dynamic. Therefore changed bpf_timer_init()
to accept explicit map pointer supplied by the program instead
of hidden map pointer supplied by the verifier.
To make sure that pointer to a timer actually belongs to that map
added the verifier check in patch 3.
4.
Addressed Yonghong's feedback. Improved comments and added
dynamic in_nmi() check.
Added Acks.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com> # for the feature

v2->v3:
The v2 approach attempted to bump bpf_prog refcnt when bpf_timer_start is
called to make sure callback code doesn't disappear when timer is active and
drop refcnt when timer cb is done. That led to a ton of race conditions between
callback running and concurrent bpf_timer_init/start/cancel on another cpu,
and concurrent bpf_map_update/delete_elem, and map destroy.

Then v2.5 approach skipped prog refcnt altogether. Instead it remembered all
timers that bpf prog armed in a link list and canceled them when prog refcnt
went to zero. The race conditions disappeared, but timers in map-in-map could
not be supported cleanly, since timers in inner maps have inner map's life time
and don't match prog's life time.

This v3 approach makes timers to be owned by maps. It allows timers in inner
maps to be supported from the start. This apporach relies on "user refcnt"
scheme used in prog_array that stores bpf programs for bpf_tail_call. The
bpf_timer_start() increments prog refcnt, but unlike 1st approach the timer
callback does decrement the refcnt. The ops->map_release_uref is
responsible for cancelling the timers and dropping prog refcnt when user space
reference to a map is dropped. That addressed all the races and simplified
locking.

Andrii presented a use case where specifying callback_fn in bpf_timer_init()
is inconvenient vs specifying in bpf_timer_start(). The bpf_timer_init()
typically is called outside for timer callback, while bpf_timer_start() most
likely will be called from the callback. 
timer_cb() { ... bpf_timer_start(timer_cb); ...} looks like recursion and as
infinite loop to the verifier. The verifier had to be made smarter to recognize
such async callbacks. Patches 4,5,6 addressed that.

Patch 1 implements bpf timer helpers and locking.
Patch 2 implements map side of bpf timer support.
Patch 3 adds support for BTF in inner maps.
Patch 4 teaches check_cfg() pass to understand async callbacks.
Patch 5 teaches do_check() pass to understand async callbacks.
Patch 6 teaches check_max_stack_depth() pass to understand async callbacks.
Patches 7 and 8 are the tests.

v1->v2:
- Addressed great feedback from Andrii and Toke.
- Fixed race between parallel bpf_timer_*() ops.
- Fixed deadlock between timer callback and LRU eviction or bpf_map_delete/update.
- Disallowed mmap and global timers.
- Allow spin_lock and bpf_timer in an element.
- Fixed memory leaks due to map destruction and LRU eviction.
- A ton more tests.

Alexei Starovoitov (9):
  bpf: Introduce bpf timers.
  bpf: Add map side support for bpf timers.
  bpf: Prevent pointer mismatch in bpf_timer_init.
  bpf: Remember BTF of inner maps.
  bpf: Relax verifier recursion check.
  bpf: Implement verifier support for validation of async callbacks.
  bpf: Teach stack depth check about async callbacks.
  selftests/bpf: Add bpf_timer test.
  selftests/bpf: Add a test with bpf_timer in inner map.

 include/linux/bpf.h                           |  47 ++-
 include/linux/bpf_verifier.h                  |  19 +-
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  69 ++++
 kernel/bpf/arraymap.c                         |  22 ++
 kernel/bpf/btf.c                              |  77 +++-
 kernel/bpf/hashtab.c                          | 102 +++++-
 kernel/bpf/helpers.c                          | 328 ++++++++++++++++++
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/bpf/map_in_map.c                       |   8 +
 kernel/bpf/syscall.c                          |  21 +-
 kernel/bpf/verifier.c                         | 316 ++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  69 ++++
 .../testing/selftests/bpf/prog_tests/timer.c  |  55 +++
 .../selftests/bpf/prog_tests/timer_mim.c      |  69 ++++
 tools/testing/selftests/bpf/progs/timer.c     | 297 ++++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c |  88 +++++
 .../selftests/bpf/progs/timer_mim_reject.c    |  74 ++++
 20 files changed, 1616 insertions(+), 54 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c

-- 
2.30.2

