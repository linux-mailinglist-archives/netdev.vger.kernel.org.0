Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2947D446DA1
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 12:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhKFLcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 07:32:41 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:60803 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhKFLcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 07:32:41 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4HmZss2pjdz8K;
        Sat,  6 Nov 2021 12:29:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1636198197; bh=WAutzEgYEkmalNSwQrpbordkhKZLQ/Y22509TsCal1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoSDr5iITx3E3YPjbwkyIUAMMz2VmRaGqyp931kZX9YG+QyaLES6TvE+QwQNSCXlJ
         fpc5I73Jklg2OzmXxu2LMdsy9vNLA7EBPNnzQtR/b7pam2rbJ41auAZmoiKWDoGoTh
         33ZJgvXhhdDgMv5Gftq0VWNj2quwtGMnCQ05Vicp9WOB1XHJmcwdB4C6fV5moIbunY
         2pHxjtQgDkyQmIbCl5sYp6e9aq2kjDEzW8DTwxKTUYFbt5WG7t6QG/dNh1ogsZV3La
         pN/Cdf+ZUSXgzppa++BQRGky7Z/Oiq8oAuUHz4R2kaNp0awXgwxWySm/P9++rhyRyL
         YNV8/t5iEpSKQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Sat, 6 Nov 2021 12:29:51 +0100
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
Message-ID: <YYZnL58B+GsNypEn@qmqm.qmqm.pl>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
 <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
 <CALOAHbDtoBEr8TuuUEMAnw3aeOf=S10Lh_eBCS=5Ty+JHgdj0Q@mail.gmail.com>
 <YYXEzlHn28/d5C6A@qmqm.qmqm.pl>
 <CALOAHbAP5qhKjsgwhekcDcutWpHMsxxGfB+K1-=2RyOyJt9MeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbAP5qhKjsgwhekcDcutWpHMsxxGfB+K1-=2RyOyJt9MeQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 05:12:24PM +0800, Yafang Shao wrote:
> On Sat, Nov 6, 2021 at 7:57 AM Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> >
> > On Fri, Nov 05, 2021 at 02:34:58PM +0800, Yafang Shao wrote:
> > > On Thu, Nov 4, 2021 at 9:37 AM Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> > > >
> > > > On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> > > > > There're many truncated kthreads in the kernel, which may make trouble
> > > > > for the user, for example, the user can't get detailed device
> > > > > information from the task comm.
> > > > >
> > > > > This patchset tries to improve this problem fundamentally by extending
> > > > > the task comm size from 16 to 24, which is a very simple way.
> > > > [...]
> > > >
> > > > Hi,
> > > >
> > > > I've tried something like this a few years back. My attempt got mostly
> > > > lost in the mailing lists, but I'm still carrying the patches in my
> > > > tree [1]. My target was userspace thread names, and it turned out more
> > > > involved than I had time for.
> > > >
> > > > [1] https://rere.qmqm.pl/git/?p=linux;a=commit;h=2c3814268caf2b1fee6d1a0b61fd1730ce135d4a
> > > >     and its parents
> > > >
> > >
> > > Hi Michal,
> > >
> > > Thanks for the information.
> > >
> > > I have looked through your patches.  It seems to contain six patches
> > > now and can be divided into three parts per my understanding.
> > >
> > > 1. extend task comm len
> > > This parts contains below 4 patches:
> > > [prctl: prepare for bigger
> > > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=cfd99db9cf911bb4d106889aeba1dfe89b6527d0)
> > > [bluetooth: prepare for bigger
> > > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=ba2805f5196865b81cc6fc938ea53af2c7c2c892)
> > > [taskstats: prepare for bigger
> > > TASK_COMM_LEN](https://rere.qmqm.pl/git/?p=linux;a=commit;h=4d29bfedc57b36607915a0171f4864ec504908ca)
> > > [mm: make TASK_COMM_LEN
> > > configurable](https://rere.qmqm.pl/git/?p=linux;a=commit;h=362acc35582445174589184c738c4d86ec7d174b)
> > >
> > > What kind of userspace issues makes you extend the task comm length ?
> > > Why not just use /proc/[pid]/cmdline ?
> >
> > This was to enable longer thread names (as set by pthread_setname_np()).
> > Currently its 16 bytes, and that's too short for e.g. Chrome's or Firefox'es
> > threads. I believe that FreeBSD has 32-byte limit and so I expect that
> > major portable code is already prepared for bigger thread names.
> >
> 
> The comm len in FreeBSD is (19 + 1) bytes[1], but that is still larger
> than Linux :)
> The task comm is short for many applications, that is why cmdline is
> introduced per my understanding, but pthread_{set, get}name_np() is
> reading/writing the comm or via prctl(2) rather than reading/writing
> the cmdline...
> 
> Is the truncated Chrome or Firefox thread comm really harmful or is
> extending the task comm just for portable?
> Could you pls show me some examples if the short comm is really harmful?
> 
> Per my understanding, if the short comm is harmful to applications
> then it is worth extending it.
> But if it is only for portable code, it may not be worth extending it.
> 
> [1]. https://github.com/freebsd/freebsd-src/blob/main/sys/sys/param.h#L126

I don't think it is harmful as in exposing a bug or something. It's just
inconvenient when debugging a system where you can't differentiate
between threads because their names have been cut too short.

Best Regards
Micha³ Miros³aw
