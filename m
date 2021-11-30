Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33F462ADB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhK3DHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhK3DHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:07:44 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B36C061574;
        Mon, 29 Nov 2021 19:04:25 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id i13so16582253qvm.1;
        Mon, 29 Nov 2021 19:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qn3rCiMydHKwJRSqvEKBqOJQ42ze7JPZml2l4kAkwYE=;
        b=UWpY48Db8SSSvrI1MpFmmka3FNt2E40Ilz07diUL+rlM7Ybkp3oZER0vU6RA8FBNLB
         AjNAgOFvOuqN8bSUqDNbutYPGM/ubZZF3gbJqlTw8+BFVplkPcMsxAyYKWI2CltHW5SD
         01UCvWTIXS3pPbhomp3NFBzawnac/+QAeZEQ1mvQqjXjSRPlUgw2fIILZ18F34j4cp3R
         LWP98ME54aLX2n4dbxs7gBaohVBXQVo9hRXbuWK/YGs1zp7PnnJZZ8DDo0wtwOVz7tmj
         6HEWNE1MWGThUyb7WyNQb/I2txyAFbPnQRXXX3J8Prr8HaltOetdUg1M1wl6HD3hMBWz
         lovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qn3rCiMydHKwJRSqvEKBqOJQ42ze7JPZml2l4kAkwYE=;
        b=lrNKHVhXjrKHx5BrPnmkV/h7FEaQjkP3bneevuUwiYGYslEG44iuG0lCD1uWtXW6Ut
         Lw+WZZxx1FM8ff1wyKjviIKFnsM5PzQV5+M+uOpZjxfF4K2De0RJlsDSJRpRHk1NK3M5
         6z/opn520Ss8Mt649GHPZnfXsTrqSYwk4cNjvqkhCWrm+lSpDPxvNiCchO6NB4JJwm/6
         RpTwx0e9AWijklMi9IdOe3LCP5iSAhQ6dt27uOeye8bsj9qVdIYnV+pXp7ptUKBAacDL
         /Ftrg4wyoujSpXV4yMOpGk4jOZYaFD/ME0yB/GXZAUD6EVSsQSoalPfLFvAMzQCl10Cn
         +1pQ==
X-Gm-Message-State: AOAM531tWWLBczEY7D3chaUPhKydkBRn95DbEofl0aEi0jjyoBgnVH8I
        nyG7tPS3Pe7cxOrx+yN0oWLXqSVxpqPv6giA16UWcA3EuJyGofpI
X-Google-Smtp-Source: ABdhPJzye7Mau6MSRuZs3vTVhbPaBitlduhkL5wMdjAF8yiGEWsIUxxfoSh994+EmmAGwTuyk858XFoZnyNCCbpCA2A=
X-Received: by 2002:a05:6214:2303:: with SMTP id gc3mr34265426qvb.90.1638241464734;
 Mon, 29 Nov 2021 19:04:24 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com> <20211129123043.5cfd687a@gandalf.local.home>
In-Reply-To: <20211129123043.5cfd687a@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 30 Nov 2021 11:03:48 +0800
Message-ID: <CALOAHbCVJcPdYq2j_VvhHBE-xLBnizRRx2oBu-KNgOr5jMf6RQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Tom Zanussi <zanussi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 1:30 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 29 Nov 2021 11:13:31 +0100
> Sven Schnelle <svens@linux.ibm.com> wrote:
>
>
> > This breaks the trigger-field-variable-support.tc from the ftrace test
> > suite at least on s390:
> >
> > echo 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm) if next_comm=="ping"'
> > linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument
> >
> > I added a debugging line into check_synth_field():
> >
> > [   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0
> >
> > Note the difference in the signed field.
>
> That should not break on strings.
>
> Does this fix it (if you keep the patch)?
>
> -- Steve
>
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 9555b8e1d1e3..319f9c8ca7e7 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -3757,7 +3757,7 @@ static int check_synth_field(struct synth_event *event,
>
>         if (strcmp(field->type, hist_field->type) != 0) {
>                 if (field->size != hist_field->size ||
> -                   field->is_signed != hist_field->is_signed)
> +                   (!field->is_string && field->is_signed != hist_field->is_signed))
>                         return -EINVAL;
>         }
>

Many thanks for the quick fix!
It seems this fix should be ahead of patch #7.
I will send v3 which contains your fix.

-- 
Thanks
Yafang
