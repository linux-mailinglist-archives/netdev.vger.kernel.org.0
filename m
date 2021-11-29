Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B4461FE7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351797AbhK2TLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhK2TJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:09:51 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227A5C05291D;
        Mon, 29 Nov 2021 07:29:33 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id j17so16933171qtx.2;
        Mon, 29 Nov 2021 07:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m35Uj2krYxANxP9t+ed7LtTcj7TW2cw/dyEjVSPqQT0=;
        b=cLxEFDVZ3ieInC8MJrsJ5iFSKK9uDzj3PngLBEurfcrviDABbKTIBY6sTQBjtHJOv3
         Ni8rIxlC5DijGOg8Wnn0akJyo1johm1HAE/5/FFQQiwVJUeffYQBu1pwT3x+DnmTon1l
         vFM9/PRzXA6MHHZs0WrVPWn8eSasotEsV4txjD6kLTJ4NVvB4fd3n8K62k3tPpuQIfJd
         8x2NSloB+uGcQ+3biCQLBCjqa45fT2l6yAYOiQm/Lu4mszLhDR2gttec7GUHtNfy3cC1
         WHqbC+vWCfoYglwsbF76sr4YYKYmvd79v1Gb2VGXNQ+qN18PLDQsIgt5jTuKo5NUXoi9
         AqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m35Uj2krYxANxP9t+ed7LtTcj7TW2cw/dyEjVSPqQT0=;
        b=rpcOW8jFW3NqWOjdchojf68z+puKDXDbALSuJXJn3K4tk9MgsHETvMDPxQuhrtjX4Y
         BZbCI8nYRimjWX0ceB8NrgaCTUzI0KdWJatFsH6zU9eHFjjq3I3DTKx9VxIvJR/TjsdB
         uoNCLDxk0JkV8zY02ThYZzWuMqTfAQpljbHGzhtEbNnPa/+q4kSP4fOa6JdDTWfxi+5l
         n5Q7i47yMyyKh4VSNNbA9yMDk9WfChlJehDBUCLnLp8RfBBlNwlVVmPV1HGk2TEEsaoU
         2xpT5YXUkJslOsr69OxnCH8ObLUNAAnOq3RtslfEMsS+5Am+nbWpeEMuBBqOGGMkRHed
         CsMA==
X-Gm-Message-State: AOAM532s5N2/7wjtuem72EM/9t8bSlE5p1rVCDpVXUc7GV4L4Z/mMrWr
        UQ6BO6k1Tu9WuemLPofLfeyTeUgT3j6ptWLmt5A=
X-Google-Smtp-Source: ABdhPJx61ZVmuKVGRhNCeSofdileIyrk+FUExv2FizSt9Nt5h8WQbouFLRUsTYW6uEQteyHw9o/8rapqVl00ixIucm8=
X-Received: by 2002:ac8:7e83:: with SMTP id w3mr45058346qtj.160.1638199772122;
 Mon, 29 Nov 2021 07:29:32 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com> <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
 <yt9d35nfvy8s.fsf@linux.ibm.com>
In-Reply-To: <yt9d35nfvy8s.fsf@linux.ibm.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 29 Nov 2021 23:28:55 +0800
Message-ID: <CALOAHbCeRXO7xMWC3Zpjbk4Dh3nGvQdEYBx_aUaQJOUE0z4H3A@mail.gmail.com>
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

On Mon, Nov 29, 2021 at 10:21 PM Sven Schnelle <svens@linux.ibm.com> wrote:
>
> Hi,
>
> Yafang Shao <laoar.shao@gmail.com> writes:
>
> > On Mon, Nov 29, 2021 at 6:13 PM Sven Schnelle <svens@linux.ibm.com> wrote:
> >> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> > index 78c351e35fec..cecd4806edc6 100644
> >> > --- a/include/linux/sched.h
> >> > +++ b/include/linux/sched.h
> >> > @@ -274,8 +274,13 @@ struct task_group;
> >> >
> >> >  #define get_current_state()  READ_ONCE(current->__state)
> >> >
> >> > -/* Task command name length: */
> >> > -#define TASK_COMM_LEN                        16
> >> > +/*
> >> > + * Define the task command name length as enum, then it can be visible to
> >> > + * BPF programs.
> >> > + */
> >> > +enum {
> >> > +     TASK_COMM_LEN = 16,
> >> > +};
> >>
> >> This breaks the trigger-field-variable-support.tc from the ftrace test
> >> suite at least on s390:
> >>
> >> echo
> >> 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm)
> >> if next_comm=="ping"'
> >> linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument
> >>
> >> I added a debugging line into check_synth_field():
> >>
> >> [   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0
> >>
> >> Note the difference in the signed field.
> >>
> >
> > Hi Sven,
> >
> > Thanks for the report and debugging!
> > Seems we should explicitly define it as signed ?
> > Could you pls. help verify it?
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index cecd4806edc6..44d36c6af3e1 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -278,7 +278,7 @@ struct task_group;
> >   * Define the task command name length as enum, then it can be visible to
> >   * BPF programs.
> >   */
> > -enum {
> > +enum SignedEnum {
> >         TASK_COMM_LEN = 16,
> >  };
>
> Umm no. What you're doing here is to define the name of the enum as
> 'SignedEnum'. This doesn't change the type. I think before C++0x you
> couldn't force an enum type.
>

Ah, I made a stupid mistake....


-- 
Thanks
Yafang
