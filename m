Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB7462019
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379889AbhK2TS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244423AbhK2TQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:16:56 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACDEC08EC6B;
        Mon, 29 Nov 2021 07:34:10 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id l8so16954821qtk.6;
        Mon, 29 Nov 2021 07:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2T0GkM465CLxYnAqMF+b7YZ0kWc7n3IIcbwmTM7QP0=;
        b=JXT5WXVCBDK3FzsXJSa2uYqiM0WoLQ1yXMA/RTOMlcdVpf3e/OPd8C/CCt5TixBK90
         Twpp5j7greFWY25lXiq0ABaJS7HcZOhv/37gZTiXiPkA8jg3mu7eagL/cnE5B4wSd28t
         zZ6E+9gBUbtiRJ7f2pNDi/1JmPqd3WyGLP1j4uy8r8gcXUhy0v+ZPattDspCONYnwxiB
         lDpReN7hfI8A0hFZxNPzS8QMhzmm8u0cLGAWJHBNBjL1KgWIW7a8tj1p6mfJSmcFMV7p
         2V4fDn5aWsH3gq1qbaR+2pwFiSJRo7UuL4dHXKOIWe5rnRN+nssX014EEvE2R18fjHSA
         3Qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2T0GkM465CLxYnAqMF+b7YZ0kWc7n3IIcbwmTM7QP0=;
        b=43lUJlTELFdpW24MjFJGc/4uBqibd4iE64RqQZm9WNbEHd4/scdze2ruRWhL7XRu+s
         HZfMWHUOnW0+Dhl0qheUSfhtnxqzD7RvXGFXNfHRtzPVRPm8V4lYqAMbtPQ8t/HWxxOV
         P8I2lVWSyHUySeO4lMIwF6OuIAWHxn2zcxKmpgeg2/2uHhEzinNMQH94JNl9H58tFEPZ
         aDsvcn7i0ICUwwi7owPQN+18xfDkF05D0qwwBRl40Ppa/w73So7A6vBx9zYU6j592fe+
         YdROvuMpVzEaFdtvLFXgB2ZRb6arddpLLqSd+mP37xhmLsImo1nkINylN9I4WA+Tj559
         NYkQ==
X-Gm-Message-State: AOAM530QmmAXFiRd7F3RZuBT16kbt9SlsoSULMmZicGZ+SoEM02gJUrn
        tLowEBmtw/rNrHLSazjx7dxj56XaBfXcWfTNiDg=
X-Google-Smtp-Source: ABdhPJyHn4eG/30zIiucx98a7erajhlmeiAoN+4npcSorK0RgbdUp5LB/Hp+l7vrKFjb+udNnVxvVv+qLnsbv+JY+X0=
X-Received: by 2002:ac8:7e83:: with SMTP id w3mr45092512qtj.160.1638200049519;
 Mon, 29 Nov 2021 07:34:09 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com> <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
 <yt9d35nfvy8s.fsf@linux.ibm.com> <54e1b56c-e424-a4b3-4d61-3018aa095f36@redhat.com>
 <yt9dy257uivg.fsf@linux.ibm.com>
In-Reply-To: <yt9dy257uivg.fsf@linux.ibm.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 29 Nov 2021 23:33:33 +0800
Message-ID: <CALOAHbDkMhnO_OfQiV4gA8rGnLpyQ27nUcWSnN_-8TXkfQ1Eyw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
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

On Mon, Nov 29, 2021 at 10:38 PM Sven Schnelle <svens@linux.ibm.com> wrote:
>
> Hi,
>
> David Hildenbrand <david@redhat.com> writes:
> > On 29.11.21 15:21, Sven Schnelle wrote:
> >> Yafang Shao <laoar.shao@gmail.com> writes:
> >>> Thanks for the report and debugging!
> >>> Seems we should explicitly define it as signed ?
> >>> Could you pls. help verify it?
> >>>
> >>> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >>> index cecd4806edc6..44d36c6af3e1 100644
> >>> --- a/include/linux/sched.h
> >>> +++ b/include/linux/sched.h
> >>> @@ -278,7 +278,7 @@ struct task_group;
> >>>   * Define the task command name length as enum, then it can be visible to
> >>>   * BPF programs.
> >>>   */
> >>> -enum {
> >>> +enum SignedEnum {
> >>>         TASK_COMM_LEN = 16,
> >>>  };
> >>
> >> Umm no. What you're doing here is to define the name of the enum as
> >> 'SignedEnum'. This doesn't change the type. I think before C++0x you
> >> couldn't force an enum type.
> >
> > I think there are only some "hacks" to modify the type with GCC. For
> > example, with "__attribute__((packed))" we can instruct GCC to use the
> > smallest type possible for the defined enum values.
>
> Yes, i meant no way that the standard defines. You could force it to
> signed by having a negative member.
>
> > I think with some fake entries one can eventually instruct GCC to use an
> > unsigned type in some cases:
> >
> > https://stackoverflow.com/questions/14635833/is-there-a-way-to-make-an-enum-unsigned-in-the-c90-standard-misra-c-2004-compl
> >
> > enum {
> >       TASK_COMM_LEN = 16,
> >       TASK_FORCE_UNSIGNED = 0x80000000,
> > };
> >
> > Haven't tested it, though, and I'm not sure if we should really do that
> > ... :)
>
> TBH, i would vote for reverting the change. defining an array size as
> enum feels really odd.
>

We changed it to enum because the BTF can't parse macro while it can
parse the enum type.
Anyway I don't insist on keeping this change if you think reverting it
is better.

Andrew, would you pls. help drop this patch from the -mm tree (the
other 6 patches in this series can be kept) ?


--
Thanks
Yafang
