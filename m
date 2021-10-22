Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C44371B7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhJVG0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhJVG0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:26:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FDBC061764;
        Thu, 21 Oct 2021 23:24:04 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y67so3953364iof.10;
        Thu, 21 Oct 2021 23:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ctmgqf8uxyooX2WRkX0mknbdlJbxHMg1YGMmHUwmvMo=;
        b=XyZMPi56Rw07CUfQKmDI18LFyvuL2nRgfmj+7iHgcHle79EuBTDTtaH0Mj7Br3D9GX
         nLQhFIjno3jaMUF2jdbaYrZXedALQlCijEaOrit8/ewXjSzMITu0NjtvDR3wHc5xakIK
         AE4JBy6BpGRZuJTPoWG4QGvbhuCkPvFQkbOrjsW8Hd9W1EhNrge4A2XFwCJY8T9TrvR2
         iIXWtOl9DQY0GOfCu+gbmpCQFaRXM1PbOMLIP3O6pm5BRDaV0RndO5O+/xUHY+qEcTNR
         MdGZsEBRJU92Yb5iRW+HoZTZihEsF8Pg88qYoCq5k6peuh+lTPQXCvrZpNI9Rm9offnx
         +pnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ctmgqf8uxyooX2WRkX0mknbdlJbxHMg1YGMmHUwmvMo=;
        b=bxM8YJ/GUobiMI3JqYH3nIF/cxFAGp3nUFTmVlwMVBydALPaW35wiLwUjO6aOrNcdM
         kOfCmsP3RhBwNJiAsmnVZOZEphLtVGYHg5LIy2NdahPMpyuioFtE2NNA9r+F345lm/09
         moQDsAwQIJ4n8Ysrj9kpAYy6pSF0yR5YYugkBk7p5sRTr5lKC0wOgkNdIi9z6kvqzIBK
         KGhPKX9kLDsYOoUBZv/m6+Y+o71fvW1DKWQ4uk7rZWrZXnPYP05QsjhsMNKCD6kZCSg5
         bdUO5tZUGmhqEneVr9NIsJTYc5Y/8ttfulRdcPTJG4oIs5MkVCB8g5jlG1wYfNBQ/9yy
         Zw5Q==
X-Gm-Message-State: AOAM533HIict3ryK3a9cpu96ngcA4y43+9PZDAPczd43FgvMfN3H2Ry1
        KQwWNOJyYcNmNCAUfouDd3W/Kozws8FrFKeWQhI=
X-Google-Smtp-Source: ABdhPJwLZt7DEWJC59Q0R4KyCJo2IgKLomhbRWM91KQdg87yLztshdMdW65VPa3XJ6qnAbAG+eJ9OnGWBYcCvmnjD6Q=
X-Received: by 2002:a05:6638:1607:: with SMTP id x7mr6954700jas.128.1634883843551;
 Thu, 21 Oct 2021 23:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034516.4400-1-laoar.shao@gmail.com> <20211021034516.4400-4-laoar.shao@gmail.com>
 <CAEf4Bzb0YSwqoKn2N4gPJS40atWBRHLkK9fBy=wghkXUC5Sqmw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb0YSwqoKn2N4gPJS40atWBRHLkK9fBy=wghkXUC5Sqmw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 22 Oct 2021 14:23:27 +0800
Message-ID: <CALOAHbCu5vXT1DB+d-sv6r2ncBohnqry2uK9R4rYSvbHoVPLOg@mail.gmail.com>
Subject: Re: [PATCH v5 03/15] sched.h: introduce TASK_COMM_LEN_16
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 5:55 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 20, 2021 at 8:45 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > There're many hard-coded 16 used to store task comm in the kernel, that
> > makes it error prone if we want to change the value of TASK_COMM_LEN. A
> > new marco TASK_COMM_LEN_16 is introduced to replace these old ones, then
> > we can easily grep them.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  include/linux/sched.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index c1a927ddec64..62d5b30d310c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -274,6 +274,8 @@ struct task_group;
> >
> >  #define get_current_state()    READ_ONCE(current->__state)
> >
> > +/* To replace the old hard-coded 16 */
> > +#define TASK_COMM_LEN_16               16
> >  /* Task command name length: */
> >  #define TASK_COMM_LEN                  16
>
> Can we please convert these two constants into enum? That will allow
> BPF applications to deal with such kernel change more easily because
> these constants will now be available as part of kernel BTF.
>
> Something like this should be completely equivalent for all the kernel uses:
>
> enum {
>     TASK_COMM_LEN = 16,
>     TASK_COMM_LEN_16 = 16,
> };
>
> When later TASK_COMM_LEN is defined as = 24, BPF applications will be
> able to deal with that by querying BTF through BPF CO-RE.
>

Sure. I will convert it to enum.


-- 
Thanks
Yafang
