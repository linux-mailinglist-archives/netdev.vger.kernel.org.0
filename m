Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9A446B62
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhKFAAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 20:00:00 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:20332 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233311AbhKEX75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 19:59:57 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4HmHVb6HGFzBs;
        Sat,  6 Nov 2021 00:57:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1636156635; bh=m5pndQqsZAfsS+FW1lbAnLViWscX+7vW/HS+H4mYBKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hhhHpB7ZS4HG39gN9VN9s41HVGTMpArfwk+CIFrRRUhAAn2nVMgZajsgWsAEvJ5Uh
         E5kVQtH50Hw+vS/SQw2R4N2aAeNeaQxjqX7ir5sEPslX0+QLwnK90B76F+LeCC0oAQ
         PIxCMskP3Gv3nwVt/hQmWgI+O03uONbc4LfkN9p5SDeJJBZ6ZRwwme7leUxbDszrVm
         dEbpNMH+ZwjXs15naK6R98AzrEPJWYY5dGiGyLyQtkGFN9d/rjaiicUDQ2N/I12qdE
         3ePV/0GKFuuOK26dKbitWlt3+bMzUazhaKZ5rx7dILwSez6IuMQDIpnakNB9l+ZBGt
         /qCnycePN9fPQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Sat, 6 Nov 2021 00:57:06 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Yafang Shao <laoar.shao@gmail.com>
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
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
Message-ID: <YYXEzlHn28/d5C6A@qmqm.qmqm.pl>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
 <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
 <CALOAHbDtoBEr8TuuUEMAnw3aeOf=S10Lh_eBCS=5Ty+JHgdj0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDtoBEr8TuuUEMAnw3aeOf=S10Lh_eBCS=5Ty+JHgdj0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 02:34:58PM +0800, Yafang Shao wrote:
> On Thu, Nov 4, 2021 at 9:37 AM Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> >
> > On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> > > There're many truncated kthreads in the kernel, which may make trouble
> > > for the user, for example, the user can't get detailed device
> > > information from the task comm.
> > >
> > > This patchset tries to improve this problem fundamentally by extending
> > > the task comm size from 16 to 24, which is a very simple way.
> > [...]
> >
> > Hi,
> >
> > I've tried something like this a few years back. My attempt got mostly
> > lost in the mailing lists, but I'm still carrying the patches in my
> > tree [1]. My target was userspace thread names, and it turned out more
> > involved than I had time for.
> >
> > [1] https://rere.qmqm.pl/git/?p=linux;a=commit;h=2c3814268caf2b1fee6d1a0b61fd1730ce135d4a
> >     and its parents
> >
> 
> Hi Michal,
> 
> Thanks for the information.
> 
> I have looked through your patches.  It seems to contain six patches
> now and can be divided into three parts per my understanding.
> 
> 1. extend task comm len
> This parts contains below 4 patches:
> [prctl: prepare for bigger
> TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=cfd99db9cf911bb4d106889aeba1dfe89b6527d0)
> [bluetooth: prepare for bigger
> TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=ba2805f5196865b81cc6fc938ea53af2c7c2c892)
> [taskstats: prepare for bigger
> TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=4d29bfedc57b36607915a0171f4864ec504908ca)
> [mm: make TASK_COMM_LEN
> configurable](https://rere.qmqm.pl/git/?p=linux;a=commit;h=362acc35582445174589184c738c4d86ec7d174b)
> 
> What kind of userspace issues makes you extend the task comm length ?
> Why not just use /proc/[pid]/cmdline ?

This was to enable longer thread names (as set by pthread_setname_np()).
Currently its 16 bytes, and that's too short for e.g. Chrome's or Firefox'es
threads. I believe that FreeBSD has 32-byte limit and so I expect that
major portable code is already prepared for bigger thread names.

> 2.  A fix
> Below patch:
> [procfs: signal /proc/PID/comm write
> truncation](https://rere.qmqm.pl/git/?p=linux;a=commit;h=d72027388d4d95db5438a7a574e0a03ae4b5d6d7)
> 
> It seems this patch is incomplete ?   I don't know what it means to do.

Currently writes to /proc/PID/comm are silently truncated. This patch
makes the write() call return the actual number of bytes actually written
and on subsequent calls return -ENOSPC. glibc checks the length in
pthread_setname_np() before write(), so the change is not currently
relevant for it. I don't know/remember what other runtimes do, though.

> 3. A feature provided for pthread_getname_np
> Below patch:
> [procfs: lseek(/proc/PID/comm, 0,
> SEEK_END)](https://rere.qmqm.pl/git/?p=linux;a=commit;h=2c3814268caf2b1fee6d1a0b61fd1730ce135d4a)
> 
> It seems this patch is useful. With this patch the userspace can
> directly get the TASK_COMM_LEN through the API.

This one I'm not really fond of because it abuses lseek() in that it
doesn't move the write pointer. But in case of /proc files this normally
would return EINVAL anyway.

Best Regards
Micha³ Miros³aw
