Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA19461AE8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349331AbhK2Pcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343859AbhK2Pap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:30:45 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E1C05291B;
        Mon, 29 Nov 2021 05:41:48 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id t11so16552401qtw.3;
        Mon, 29 Nov 2021 05:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fhEsQAK98bM5StiE4nhRYixbgK7BmdEmPc2JUmkzNuE=;
        b=OPD4a0BbOCx/FwKr9ugrv/ROrF8AV8trJRIupc+DGvBkpArkblK6Vf7ThfjN45aaQx
         +4tY0VYjZJxl8P1vbJ++e/HVMPYxXgxG7oPThz/y4Eyks1pROtqYrnlq27waj1Jvwhxn
         O1n97pTLMFzxnBa4efTROYFYfSml95/Ip3O7RBzVZvGZYo6+ChdPL8s0o2JFx2gDz7oQ
         RSQp/sslhuaFaXPYGRHaRVNKgR3xBYeXrI+SvAsiJXQkWnzqqQL3yFqzQ3ebLgRwmLo6
         ZJKNwzLsde6LoPB7PutSs3sH0wX6epaXkVO3m1jHVMV1yfypRsT1W5T5hQAJIvfPTIvN
         dN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fhEsQAK98bM5StiE4nhRYixbgK7BmdEmPc2JUmkzNuE=;
        b=CVUc3leK/qoKvDvp75+mQYFbCf2ly4Uvy8HkuswUcObMyMq7hbhs9V7ugSNvW4WOI6
         THBGpj6DCfMXAkOyv8TKzNuYOfa3Wc6dvblNO3pE8ezId/2jeccnvCBfTpIctMIlSsjt
         jitCxVhVF8ybHe9M1j166KUVzlN7jHuHNUmE+uzDjIo2Q90jGyDO/v1yvh6f5Qe8Ao7m
         t4O91X3iJYSHK8lkkeKVXZNQmlDp16zECW4/X/TcWE8yE0HFKV6ksyR9yAYA27VGr1fI
         1KcUcyoR2VrSZbXVRJ6pjH62CKj7faBUCd0cfbs24mbJjRXcYs2TMO97CpTJP9wKR7nU
         AFPQ==
X-Gm-Message-State: AOAM531CyfUhUWgtdoJaLXx4Ezyempvbgoqa0SvJrhDBLPhPR788v3u6
        SXJzimjCjiAhf/JMCak/X7jKy2fSOqxx1wX5jTkpt7LblJTTJryBAJQ=
X-Google-Smtp-Source: ABdhPJwtYuAs3Eyp35qBUS3u4YeJbSdbd0Fj/uaKBQS5Zkwii/UENBRf3c8ern+XfOlGXgg+DCkb17rNDqYBaO6+dq4=
X-Received: by 2002:ac8:5894:: with SMTP id t20mr34675354qta.450.1638193308018;
 Mon, 29 Nov 2021 05:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com>
In-Reply-To: <yt9d35nf1d84.fsf@linux.ibm.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 29 Nov 2021 21:41:11 +0800
Message-ID: <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 6:13 PM Sven Schnelle <svens@linux.ibm.com> wrote:
>
> Hi,
>
> Yafang Shao <laoar.shao@gmail.com> writes:
>
> > As the sched:sched_switch tracepoint args are derived from the kernel,
> > we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
> > converted to type enum, then all the BPF programs can get it through BTF.
> >
> > The BPF program which wants to use TASK_COMM_LEN should include the header
> > vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> > type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> > need to include linux/bpf.h again.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  include/linux/sched.h                                   | 9 +++++++--
> >  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
> >  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
> >  3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 78c351e35fec..cecd4806edc6 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -274,8 +274,13 @@ struct task_group;
> >
> >  #define get_current_state()  READ_ONCE(current->__state)
> >
> > -/* Task command name length: */
> > -#define TASK_COMM_LEN                        16
> > +/*
> > + * Define the task command name length as enum, then it can be visible to
> > + * BPF programs.
> > + */
> > +enum {
> > +     TASK_COMM_LEN = 16,
> > +};
>
> This breaks the trigger-field-variable-support.tc from the ftrace test
> suite at least on s390:
>
> echo 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm) if next_comm=="ping"'
> linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument
>
> I added a debugging line into check_synth_field():
>
> [   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0
>
> Note the difference in the signed field.
>

Hi Sven,

Thanks for the report and debugging!
Seems we should explicitly define it as signed ?
Could you pls. help verify it?

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cecd4806edc6..44d36c6af3e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -278,7 +278,7 @@ struct task_group;
  * Define the task command name length as enum, then it can be visible to
  * BPF programs.
  */
-enum {
+enum SignedEnum {
        TASK_COMM_LEN = 16,
 };

-- 
Thanks
Yafang
