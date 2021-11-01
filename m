Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0A44244F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhKAXuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKAXuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:50:01 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD17C061714;
        Mon,  1 Nov 2021 16:47:27 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id t127so48522313ybf.13;
        Mon, 01 Nov 2021 16:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sf1MOARYDjP4TdzVuSLyJGMCk0C2bT96cLtb/iSHOvE=;
        b=SmRguYNmZ65IXjC5kS7UQZRTfWQSdxG3tt0NMqEE3jWrUYTo0GxWeERHGJGqffLMhO
         mUpNaR7C7soFG4z0owyxtBpWpkIIwvI7NmZ1X9AdSpHW94bF9X0F2JYuleAt/1sHg0L/
         5zrYaqQwj0Suq5S5VsmoV1AZdC6+4yP/fsMOSEXMRg6e4wm0lhJ2QLDw5Gk9S7qwsRw+
         4Ge1C6z+tXJAZUZgehS4GLqH1/7jQ+JcX7YrRez6DqCs2zac2rP50sEIyn+lO7WeZt0c
         XBXE/edBJBpIPW+IBzEvHdctfSqV5hvPkoQfNas342hISax3YHARRiHhQ7FBsPBgRiOl
         mZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sf1MOARYDjP4TdzVuSLyJGMCk0C2bT96cLtb/iSHOvE=;
        b=My1n7WexEEoJyWD0Ge/ODEjUZvs1Jnmp9d4kfbwVKWLOP9p795tdQvBGZTDovLK9Um
         ZSC1ZAX+MOxq2P37ETL6qyHv9dn7n8gy77QrXNPVm0V8MF23sydr4L7+6jCBmE1RkQmA
         5jdV4TMyuihtQfoDuxRoJnRawc4Tx6nF4OvrKlOM3O5+LYQAwLTp9MSJ8gg80YlYQx63
         vNsMthPCXzPetfHUx+KuQUAlh1kF2BTrtk35zQrprwZkfjmGH5s3+j+eXNQ78eelLokx
         41lXtJ4o/zAAsqWuOpIjS+okT6xfPfKvlw+8WAdWCk7OJ9ubYxs9FVJiZu7yBlXnY+8N
         SNZg==
X-Gm-Message-State: AOAM531vNQDgGTCBKyxAn6ybAGcEa6eQ+RGhH2LOM21ESFkZt2CB2Fcg
        66MNT14asz07ghieh1ghnV/jS7CGpdJoQo55MMOqKgH95w4=
X-Google-Smtp-Source: ABdhPJxxytkF+I+xIYE57g7IWWkQCLnoV8y619WwaJHG8gGGeHV30HWL8AmkKNk7EfNuLQNSutDI8kZo20T/HYQbqVA=
X-Received: by 2002:a25:d010:: with SMTP id h16mr25598551ybg.225.1635810447094;
 Mon, 01 Nov 2021 16:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <20211101060419.4682-10-laoar.shao@gmail.com>
In-Reply-To: <20211101060419.4682-10-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Nov 2021 16:47:15 -0700
Message-ID: <CAEf4BzafYdKmkJ_2sDMWibhWCZBPt=XLJwEAOgJDgnoYEvv4aA@mail.gmail.com>
Subject: Re: [PATCH v7 09/11] tools/testing/selftests/bpf: make it adopt to
 task comm size change
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 11:04 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> The hard-coded 16 is used in various bpf progs. These progs get task
> comm either via bpf_get_current_comm() or prctl() or
> bpf_core_read_str(), all of which can work well even if the task comm size
> is changed.
>
> In these BPF programs, one thing to be improved is the
> sched:sched_switch tracepoint args. As the tracepoint args are derived
> from the kernel, we'd better make it same with the kernel. So the macro
> TASK_COMM_LEN is converted to type enum, then all the BPF programs can
> get it through BTF.
>
> The BPF program which wants to use TASK_COMM_LEN should include the header
> vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> need to include linux/bpf.h again.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---

LGTM, thanks.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/sched.h                                   | 9 +++++++--
>  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
>  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
>  3 files changed, 13 insertions(+), 8 deletions(-)
>

[...]
