Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F235446D20
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhKFJPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbhKFJPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:15:42 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0BFC061570;
        Sat,  6 Nov 2021 02:13:01 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c20so942359qko.10;
        Sat, 06 Nov 2021 02:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PX63qJThybc8qmxgHYUMYlSyCq1NFMGIDZAgv7Xx9LM=;
        b=PCHCxhfQGKHkgBbVj/JAGlmlsEBIiLTckTLku56k8nvSzpt8kyEsjRRcmQ4m6iR4HX
         JATH+60zm+4MXfoSHnj6dC/BbNPVEwW/Ij1ErOTSiHbhSPYS0x5gez0wITXMVmG+8Se7
         dJ7YJiPmnxQB8biUc8cmmQvAev0Myq/+QqfRsJFGT6UMruKUFLfhoTQS+9C13YrKhPJS
         BvkwfuaaI4EndhzKlXMDowViJk/szsiW2q5mUEZHJrjEcnG3Gy76d7BbwO2Eapw4RPJt
         ZOYLVijLAdocPJKqnkxM6PU9CNjljiXI9dNg0xikdeTA0jp7yjIrfzIQCTDtWEMh57P3
         Jtpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PX63qJThybc8qmxgHYUMYlSyCq1NFMGIDZAgv7Xx9LM=;
        b=0ZCx1vgAfy9/6PcVi/aw3ERXMwL6J5ahGG9XyHzQEb4xqiZbRyRY2U8rbqnlp9UDF2
         Gou1lyBxNqWBVyTf2A88Jwzi7vkhD/6Ng7HaS0XSx3KfU1gZNHrlScXI4w7RM8dL8Mss
         xGm16WhGwhh7LJmLic/gTbhga5miHgvTyC8JEYMGO535bjcoHdVmm76AuC+QeNZjEa8c
         rmg98EEaV3rLu/APGv4csA++zCxPcNGmWAjOe20rO8nUISyZCwLW5XdJYUfMrU+MuH9x
         bP5ecrCrMqXlorXV4fJPcR+EPznHDWuBTYWELjuakqYqWFQYh0aDh/A+ItO3dUSS80Lt
         wZ5w==
X-Gm-Message-State: AOAM532yB9CZxeSnOMVjnGmj8RsV4dm7uXRAWDt8Qww6ObY5DDxS+M9J
        jOJPP/ub7PwxqPpD00Tsz00zEyrwBZPEAwUaHQw=
X-Google-Smtp-Source: ABdhPJzcgK4H7AdugIlTueY2VSiyaBGl6vbyH+oEMhigN1Ho/LAfp5M9vcc9nP1GB5Kg/0hVtXWP6INtd1Plta4Iqpc=
X-Received: by 2002:a37:9a42:: with SMTP id c63mr2527573qke.216.1636189981026;
 Sat, 06 Nov 2021 02:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
 <CALOAHbDtoBEr8TuuUEMAnw3aeOf=S10Lh_eBCS=5Ty+JHgdj0Q@mail.gmail.com> <YYXEzlHn28/d5C6A@qmqm.qmqm.pl>
In-Reply-To: <YYXEzlHn28/d5C6A@qmqm.qmqm.pl>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 6 Nov 2021 17:12:24 +0800
Message-ID: <CALOAHbAP5qhKjsgwhekcDcutWpHMsxxGfB+K1-=2RyOyJt9MeQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 6, 2021 at 7:57 AM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.q=
mqm.pl> wrote:
>
> On Fri, Nov 05, 2021 at 02:34:58PM +0800, Yafang Shao wrote:
> > On Thu, Nov 4, 2021 at 9:37 AM Micha=C5=82 Miros=C5=82aw <mirq-linux@re=
re.qmqm.pl> wrote:
> > >
> > > On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> > > > There're many truncated kthreads in the kernel, which may make trou=
ble
> > > > for the user, for example, the user can't get detailed device
> > > > information from the task comm.
> > > >
> > > > This patchset tries to improve this problem fundamentally by extend=
ing
> > > > the task comm size from 16 to 24, which is a very simple way.
> > > [...]
> > >
> > > Hi,
> > >
> > > I've tried something like this a few years back. My attempt got mostl=
y
> > > lost in the mailing lists, but I'm still carrying the patches in my
> > > tree [1]. My target was userspace thread names, and it turned out mor=
e
> > > involved than I had time for.
> > >
> > > [1] https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D2c3814268caf2b=
1fee6d1a0b61fd1730ce135d4a
> > >     and its parents
> > >
> >
> > Hi Michal,
> >
> > Thanks for the information.
> >
> > I have looked through your patches.  It seems to contain six patches
> > now and can be divided into three parts per my understanding.
> >
> > 1. extend task comm len
> > This parts contains below 4 patches:
> > [prctl: prepare for bigger
> > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dcfd99=
db9cf911bb4d106889aeba1dfe89b6527d0)
> > [bluetooth: prepare for bigger
> > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dba280=
5f5196865b81cc6fc938ea53af2c7c2c892)
> > [taskstats: prepare for bigger
> > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D4d29b=
fedc57b36607915a0171f4864ec504908ca)
> > [mm: make TASK_COMM_LEN
> > configurable](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D362acc=
35582445174589184c738c4d86ec7d174b)
> >
> > What kind of userspace issues makes you extend the task comm length ?
> > Why not just use /proc/[pid]/cmdline ?
>
> This was to enable longer thread names (as set by pthread_setname_np()).
> Currently its 16 bytes, and that's too short for e.g. Chrome's or Firefox=
'es
> threads. I believe that FreeBSD has 32-byte limit and so I expect that
> major portable code is already prepared for bigger thread names.
>

The comm len in FreeBSD is (19 + 1) bytes[1], but that is still larger
than Linux :)
The task comm is short for many applications, that is why cmdline is
introduced per my understanding, but pthread_{set, get}name_np() is
reading/writing the comm or via prctl(2) rather than reading/writing
the cmdline...

Is the truncated Chrome or Firefox thread comm really harmful or is
extending the task comm just for portable?
Could you pls show me some examples if the short comm is really harmful?

Per my understanding, if the short comm is harmful to applications
then it is worth extending it.
But if it is only for portable code, it may not be worth extending it.

[1]. https://github.com/freebsd/freebsd-src/blob/main/sys/sys/param.h#L126

> > 2.  A fix
> > Below patch:
> > [procfs: signal /proc/PID/comm write
> > truncation](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3Dd7202738=
8d4d95db5438a7a574e0a03ae4b5d6d7)
> >
> > It seems this patch is incomplete ?   I don't know what it means to do.
>
> Currently writes to /proc/PID/comm are silently truncated. This patch
> makes the write() call return the actual number of bytes actually written
> and on subsequent calls return -ENOSPC. glibc checks the length in
> pthread_setname_np() before write(), so the change is not currently
> relevant for it. I don't know/remember what other runtimes do, though.
>
> > 3. A feature provided for pthread_getname_np
> > Below patch:
> > [procfs: lseek(/proc/PID/comm, 0,
> > SEEK_END)](https://rere.qmqm.pl/git/?p=3Dlinux;a=3Dcommit;h=3D2c3814268=
caf2b1fee6d1a0b61fd1730ce135d4a)
> >
> > It seems this patch is useful. With this patch the userspace can
> > directly get the TASK_COMM_LEN through the API.
>
> This one I'm not really fond of because it abuses lseek() in that it
> doesn't move the write pointer. But in case of /proc files this normally
> would return EINVAL anyway.
>

Another possible way is introducing a new PR_GET_COMM_LEN for
prctl(2), but I'm not sure if it is worth it.

--=20
Thanks
Yafang
