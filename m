Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0030720ED43
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgF3FOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3FOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:14:30 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57F5C061755;
        Mon, 29 Jun 2020 22:14:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u17so14716026qtq.1;
        Mon, 29 Jun 2020 22:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2nmhZc8pm0sRpbKQTG6rJbFvpc1bwe11GwaDWI19db4=;
        b=i/diRNn5XBW4i77XeaTs269iAH5xXndnrlMJKEQKp+Gx4gsv2DkDDLXvMhbakaizPm
         EZpLxLI+zCSyZXFTh8NDvbrOIEuFXtU8OP6ktu8/ANxVmJqJOAALZJq9gbWp4Nyd9Xvh
         9xWnyCdpODnxGHI7ud6A6+IMk+QPRKuFdHpaLsknwgCx4VGrewz/2gCRgo47IUACZt4V
         /sXMVHzieroBwzCcEyv6/hnUYBMr2ZGfSslaQNUoBYOdhO5pGbwlChJDFraNCpKmhBN3
         Bhj3KwRJYnf68qHdNibfTLmXU6uM+PpCNzt6UOJ7nU40p0GDTeV3CrQcehDX0EcsN9ew
         mZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2nmhZc8pm0sRpbKQTG6rJbFvpc1bwe11GwaDWI19db4=;
        b=dBOoh8JbytAB+4xh+h45neR6mxjNtlHYbJUV7lKeQpEnws5Zzy4mBf5Ax8q14Mw48H
         4KgEWKdp1rPPMO7bNiBWvPBCHUWy2yPmBT/Gtn+30kAoBpU/6EEWeJ8gNQ8/qiJCwD6N
         /D0JKHJytfdTA2lW3N/kYt1kDBAXwGvna6qZ2zrqXg+kQDSoZXHNMKJMq5dhys7bkVgX
         5WLUrpEBSIpBwFsVOYYug8kTR/5IEwZgOQL7fSoycrJgaV4I3ig1f9ID0z0TGyUsm7Rb
         N+cBCMKe0ylGbyFFGCfwU9xx58p7i4T5htlPXSicJYsSedFSdNR22CY6gB7px1inbfti
         9AEA==
X-Gm-Message-State: AOAM5336jmQySeSDZF9RmtNvRWZ7FeiVuFG4KYdNXq7Ie6BRjqKZIyuZ
        FxuVxtKMAz3FCK7Swhky8WmK20NO8IGpIP0TYi0=
X-Google-Smtp-Source: ABdhPJwUCKD48jXksKVUbAXS7zaohoSu3rOdKkoxfjUmSsb79rUG4NRk8rEJVMt/WhbIS2BG+q4jPZ5azzUqrPjiCwA=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr19052303qtd.59.1593494069918;
 Mon, 29 Jun 2020 22:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 22:14:18 -0700
Message-ID: <CAEf4BzYG2drMiUvjgAF5vgdjAo5+N3zL+5TTvCoUUK=Z3ErVwA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/5] bpf: Introduce minimal support for
 sleepable progs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 9:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> v4->v5:
> - addressed Andrii's feedback.
>
> v3->v4:
> - fixed synchronize_rcu_tasks_trace() usage and accelerated with synchronize_rcu_mult().
> - removed redundant synchronize_rcu(). Otherwise it won't be clear why
>   synchronize_rcu_tasks_trace() is not needed in free_map callbacks.
> - improved test coverage.
>
> v2->v3:
> - switched to rcu_trace
> - added bpf_copy_from_user
>
> Here is 'perf report' differences:
> sleepable with SRCU:
>    3.86%  bench     [k] __srcu_read_unlock
>    3.22%  bench     [k] __srcu_read_lock
>    0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>    0.50%  bench     [k] bpf_trampoline_10297
>    0.26%  bench     [k] __bpf_prog_exit_sleepable
>    0.21%  bench     [k] __bpf_prog_enter_sleepable
>
> sleepable with RCU_TRACE:
>    0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>    0.72%  bench     [k] bpf_trampoline_10381
>    0.31%  bench     [k] __bpf_prog_exit_sleepable
>    0.29%  bench     [k] __bpf_prog_enter_sleepable
>
> non-sleepable with RCU:
>    0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
>    0.84%  bench     [k] bpf_trampoline_10297
>    0.13%  bench     [k] __bpf_prog_enter
>    0.12%  bench     [k] __bpf_prog_exit
>
> Happy to confirm that rcu_trace overhead is negligible.
>
> v1->v2:
> - split fmod_ret fix into separate patch
> - added blacklist
>
> v1:
> This patch set introduces the minimal viable support for sleepable bpf programs.
> In this patch only fentry/fexit/fmod_ret and lsm progs can be sleepable.
> Only array and pre-allocated hash and lru maps allowed.
>
> Alexei Starovoitov (5):
>   bpf: Remove redundant synchronize_rcu.
>   bpf: Introduce sleepable BPF programs
>   bpf: Add bpf_copy_from_user() helper.
>   libbpf: support sleepable progs
>   selftests/bpf: Add sleepable tests
>
>  arch/x86/net/bpf_jit_comp.c                   | 32 +++++----
>  include/linux/bpf.h                           |  4 ++
>  include/uapi/linux/bpf.h                      | 19 +++++-
>  init/Kconfig                                  |  1 +
>  kernel/bpf/arraymap.c                         | 10 +--
>  kernel/bpf/hashtab.c                          | 20 +++---
>  kernel/bpf/helpers.c                          | 22 +++++++
>  kernel/bpf/lpm_trie.c                         |  5 --
>  kernel/bpf/queue_stack_maps.c                 |  7 --
>  kernel/bpf/reuseport_array.c                  |  2 -
>  kernel/bpf/ringbuf.c                          |  7 --
>  kernel/bpf/stackmap.c                         |  3 -
>  kernel/bpf/syscall.c                          | 13 +++-
>  kernel/bpf/trampoline.c                       | 28 +++++++-
>  kernel/bpf/verifier.c                         | 62 ++++++++++++++++-
>  kernel/trace/bpf_trace.c                      |  2 +
>  tools/include/uapi/linux/bpf.h                | 19 +++++-
>  tools/lib/bpf/libbpf.c                        | 25 ++++++-
>  tools/testing/selftests/bpf/bench.c           |  2 +
>  .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
>  .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
>  tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++++++-
>  .../selftests/bpf/progs/trigger_bench.c       |  7 ++
>  23 files changed, 315 insertions(+), 67 deletions(-)
>
> --
> 2.23.0
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
