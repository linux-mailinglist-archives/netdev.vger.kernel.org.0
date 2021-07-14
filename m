Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7093C94BF
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhGOADE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGOADC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:03:02 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1F6C06175F;
        Wed, 14 Jul 2021 17:00:10 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g19so6042201ybe.11;
        Wed, 14 Jul 2021 17:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ghL2ejMczTD1do3SfLrIUCduz/hYZUyvvviL/RHelQM=;
        b=h4jXIxN18C6m+lpF9LUsY0N0K6bgy0F8EK7hDEZf9NYpPaBnJQwmw9bh83LabSb1G9
         V8J0iO3QJ/yueeEnYIJPExtYFYXBPEb2L9bvXRgDRDEf8EEsamNZOKTRC1RFbQBeSMNU
         /SAlHtyN5Ja5roQAixW+hamlsHfTQqMkc5kQ4qsiDFoPlRXP9Qr/59D28Gxym9PtYrLQ
         EFOSLqS7HdPN3+sQ5928VptD26LhFb3pRPCauXHb3CcWYNUsaiX3P5uv0FDqiZDYJJSf
         rp7Ba+u0dF10NVmdWUXQohatq7Ta5wAhaVsSlr3QroQy694hmZcRsk0HqIOvKnlQq2Uh
         Qmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ghL2ejMczTD1do3SfLrIUCduz/hYZUyvvviL/RHelQM=;
        b=rsSKqs6BllYxc/mPt83GCNP/VZKyRxqUbSwxmdXVGeF2H5PcoA4ijuGpPpUeKTbjZs
         W3zzTdADY744F9sCxOvLnySufI4ouacLEnjwJz5noOKDXUJEOy2sZXOd7f79NpRade3V
         vm6mQLI8V6gR059LbOlv6i3Pd1HHmEF1xX41jjuzET0f2HVrbguAcG0DMq4gPG/JsgbY
         w0sb8qS8mvnEdrwR1LfRMIaYYcDmpXUSo94XYpyHUuNBD0zwXPEIg/Kyh4Ngr1B8bTpE
         M18NOEBDWWXvKa2hO2qxslCczxlekND5nS4y53x15tRgbPOc5atd1x2XfZxl3T8csdDb
         YJog==
X-Gm-Message-State: AOAM532evB870vfTACa+/K6QKvuL9x2vdO2kVvmVXyCrv2TbWLklrW70
        sTWOeMugc/RiQQkOafYGlodoQQIXvq0LE0GBRj8=
X-Google-Smtp-Source: ABdhPJxm9nDRz9t1+cTCnX/sdncukhzrcoyIV8p1qmt6Rmkf2gSKqGM9rvYAv2rSEJPOL5VfcH58Omzlag6L5/CV9vI=
X-Received: by 2002:a25:3787:: with SMTP id e129mr681810yba.459.1626307209953;
 Wed, 14 Jul 2021 17:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Jul 2021 16:59:58 -0700
Message-ID: <CAEf4BzaSXZJV82dU0AZAry06-P6wfYXZM9H7ewPe9o++a1AvbQ@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 00/11] bpf: Introduce BPF timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 6:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The first request to support timers in bpf was made in 2013 before sys_bp=
f syscall
> was added. That use case was periodic sampling. It was address with attac=
hing
> bpf programs to perf_events. Then during XDP development the timers were =
requested
> to do garbage collection and health checks. They were worked around by im=
plementing
> timers in user space and triggering progs with BPF_PROG_RUN command.
> The user space timers and perf_event+bpf timers are not armed by the bpf =
program.
> They're done asynchronously vs program execution. The XDP program cannot =
send a
> packet and arm the timer at the same time. The tracing prog cannot record=
 an
> event and arm the timer right away. This large class of use cases remaine=
d
> unaddressed. The jiffy based and hrtimer based timers are essential part =
of the
> kernel development and with this patch set the hrtimer based timers will =
be
> available to bpf programs.
>
> TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
> to make sure bpf progs cannot crash the kernel.
>
> v5->v6:
> - address code review feedback from Martin and add his Acks.
> - add usercnt > 0 check to bpf_timer_init and remove timers_cancel_and_fr=
ee
> second loop in map_free callbacks.
> - add cond_resched_rcu.
>
> v4->v5:
> - Martin noticed the following issues:
> . prog could be reallocated bpf_patch_insn_data().
> Fixed by passing 'aux' into bpf_timer_set_callback, since 'aux' is stable
> during insn patching.
> . Added missing rcu_read_lock.
> . Removed redundant record_map.
> - Discovered few bugs with stress testing:
> . One cpu does htab_free_prealloced_timers->bpf_timer_cancel_and_free->hr=
timer_cancel
> while another is trying to do something with the timer like bpf_timer_sta=
rt/set_callback.
> Those ops try to acquire bpf_spin_lock that is already taken by bpf_timer=
_cancel_and_free,
> so both cpus spin forever. The same problem existed in bpf_timer_cancel()=
.
> One bpf prog on one cpu might call bpf_timer_cancel and wait, while anoth=
er cpu is in
> the timer callback that tries to do bpf_timer_*() helper on the same time=
r.
> The fix is to do drop_prog_refcnt() and unlock. And only then hrtimer_can=
cel.
> Because of this had to add callback_fn !=3D NULL check to bpf_timer_cb().
> Also removed redundant bpf_prog_inc/put from bpf_timer_cb() and replaced
> with rcu_dereference_check similar to recent rcu_read_lock-removal from d=
rivers.
> bpf_timer_cb is in softirq.
> . Managed to hit refcnt=3D=3D0 while doing bpf_prog_put from bpf_timer_ca=
ncel_and_free().
> That exposed the issue that bpf_prog_put wasn't ready to be called from i=
rq context.
> Fixed similar to bpf_map_put which is irq ready.
> - Refactored BPF_CALL_1(bpf_spin_lock) into __bpf_spin_lock_irqsave() to
> make the main logic more clear, since Martin and Yonghong brought up this=
 concern.
>
> v3->v4:
> 1.
> Split callback_fn from bpf_timer_start into bpf_timer_set_callback as
> suggested by Martin. That makes bpf timer api match one to one to
> kernel hrtimer api and provides greater flexibility.
> 2.
> Martin also discovered the following issue with uref approach:
> bpftool prog load xdp_timer.o /sys/fs/bpf/xdp_timer type xdp
> bpftool net attach xdpgeneric pinned /sys/fs/bpf/xdp_timer dev lo
> rm /sys/fs/bpf/xdp_timer
> nc -6 ::1 8888
> bpftool net detach xdpgeneric dev lo
> The timer callback stays active in the kernel though the prog was detache=
d
> and map usercnt =3D=3D 0.
> It happened because 'bpftool prog load' pinned the prog only.
> The map usercnt went to zero. Subsequent attach and runs didn't
> affect map usercnt. The timer was able to start and bpf_prog_inc itself.
> When the prog was detached the prog stayed active.
> To address this issue added
> if (!atomic64_read(&(t->map->usercnt))) return -EPERM;
> to the first patch.
> Which means that timers are allowed only in the maps that are held
> by user space with open file descriptor or maps pinned in bpffs.
> 3.
> Discovered that timers in inner maps were broken.
> The inner map pointers are dynamic. Therefore changed bpf_timer_init()
> to accept explicit map pointer supplied by the program instead
> of hidden map pointer supplied by the verifier.
> To make sure that pointer to a timer actually belongs to that map
> added the verifier check in patch 3.
> 4.
> Addressed Yonghong's feedback. Improved comments and added
> dynamic in_nmi() check.
> Added Acks.
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> # for the fe=
ature
>
> v2->v3:
> The v2 approach attempted to bump bpf_prog refcnt when bpf_timer_start is
> called to make sure callback code doesn't disappear when timer is active =
and
> drop refcnt when timer cb is done. That led to a ton of race conditions b=
etween
> callback running and concurrent bpf_timer_init/start/cancel on another cp=
u,
> and concurrent bpf_map_update/delete_elem, and map destroy.
>
> Then v2.5 approach skipped prog refcnt altogether. Instead it remembered =
all
> timers that bpf prog armed in a link list and canceled them when prog ref=
cnt
> went to zero. The race conditions disappeared, but timers in map-in-map c=
ould
> not be supported cleanly, since timers in inner maps have inner map's lif=
e time
> and don't match prog's life time.
>
> This v3 approach makes timers to be owned by maps. It allows timers in in=
ner
> maps to be supported from the start. This apporach relies on "user refcnt=
"
> scheme used in prog_array that stores bpf programs for bpf_tail_call. The
> bpf_timer_start() increments prog refcnt, but unlike 1st approach the tim=
er
> callback does decrement the refcnt. The ops->map_release_uref is
> responsible for cancelling the timers and dropping prog refcnt when user =
space
> reference to a map is dropped. That addressed all the races and simplifie=
d
> locking.
>
> Andrii presented a use case where specifying callback_fn in bpf_timer_ini=
t()
> is inconvenient vs specifying in bpf_timer_start(). The bpf_timer_init()
> typically is called outside for timer callback, while bpf_timer_start() m=
ost
> likely will be called from the callback.
> timer_cb() { ... bpf_timer_start(timer_cb); ...} looks like recursion and=
 as
> infinite loop to the verifier. The verifier had to be made smarter to rec=
ognize
> such async callbacks. Patches 7,8,9 addressed that.
>
> Patch 1 and 2 refactoring.
> Patch 3 implements bpf timer helpers and locking.
> Patch 4 implements map side of bpf timer support.
> Patch 5 prevent pointer mismatch in bpf_timer_init.
> Patch 6 adds support for BTF in inner maps.
> Patch 7 teaches check_cfg() pass to understand async callbacks.
> Patch 8 teaches do_check() pass to understand async callbacks.
> Patch 9 teaches check_max_stack_depth() pass to understand async callback=
s.
> Patches 10 and 11 are the tests.
>
> v1->v2:
> - Addressed great feedback from Andrii and Toke.
> - Fixed race between parallel bpf_timer_*() ops.
> - Fixed deadlock between timer callback and LRU eviction or bpf_map_delet=
e/update.
> - Disallowed mmap and global timers.
> - Allow spin_lock and bpf_timer in an element.
> - Fixed memory leaks due to map destruction and LRU eviction.
> - A ton more tests.
>
> Alexei Starovoitov (11):
>   bpf: Prepare bpf_prog_put() to be called from irq context.
>   bpf: Factor out bpf_spin_lock into helpers.
>   bpf: Introduce bpf timers.
>   bpf: Add map side support for bpf timers.
>   bpf: Prevent pointer mismatch in bpf_timer_init.
>   bpf: Remember BTF of inner maps.
>   bpf: Relax verifier recursion check.
>   bpf: Implement verifier support for validation of async callbacks.
>   bpf: Teach stack depth check about async callbacks.
>   selftests/bpf: Add bpf_timer test.
>   selftests/bpf: Add a test with bpf_timer in inner map.
>
>  include/linux/bpf.h                           |  47 ++-
>  include/linux/bpf_verifier.h                  |  19 +-
>  include/linux/btf.h                           |   1 +
>  include/uapi/linux/bpf.h                      |  73 ++++
>  kernel/bpf/arraymap.c                         |  21 ++
>  kernel/bpf/btf.c                              |  77 +++-
>  kernel/bpf/hashtab.c                          | 104 +++++-
>  kernel/bpf/helpers.c                          | 341 +++++++++++++++++-
>  kernel/bpf/local_storage.c                    |   4 +-
>  kernel/bpf/map_in_map.c                       |   8 +
>  kernel/bpf/syscall.c                          |  53 ++-
>  kernel/bpf/verifier.c                         | 307 +++++++++++++++-
>  kernel/trace/bpf_trace.c                      |   2 +-
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |  73 ++++
>  .../testing/selftests/bpf/prog_tests/timer.c  |  55 +++
>  .../selftests/bpf/prog_tests/timer_mim.c      |  69 ++++
>  tools/testing/selftests/bpf/progs/timer.c     | 297 +++++++++++++++
>  tools/testing/selftests/bpf/progs/timer_mim.c |  88 +++++
>  .../selftests/bpf/progs/timer_mim_reject.c    |  74 ++++
>  20 files changed, 1651 insertions(+), 64 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
>  create mode 100644 tools/testing/selftests/bpf/progs/timer.c
>  create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
>  create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c
>
> --
> 2.30.2
>

It all looks good to me overall:

Acked-by: Andrii Nakryiko <andrii@kernel.org>
