Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206CC4428FD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhKBH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:58:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52976 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhKBH6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 03:58:54 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B46FE21956;
        Tue,  2 Nov 2021 07:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635839778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ap4olzBTfLejakCPItyAX9e8bDmpSosfrrPGCanr3k=;
        b=WwJzLSQXjGdAyznGGV6SpWmdhW49bQlRnvPytZ6fgxedhPeRJVVTgMy0Ih0O5QwjOYpS6a
        96PQR55FMHbwdMZIMobPll5efDcxRY2ZviZSkiefrXc10IHo417/75YCqs3hplKbT1wpnR
        lqnAN+Chyaj0oXodeKoyvl4MpccGfbE=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A7312A3B88;
        Tue,  2 Nov 2021 07:56:17 +0000 (UTC)
Date:   Tue, 2 Nov 2021 08:56:14 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
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
Message-ID: <YYDvHv76tJtJht8b@alley>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
 <YX/0h7j/nDwoBA+J@alley>
 <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
 <YYAPhE9uX7OYTlpv@alley>
 <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
 <20211101211845.20ff5b2e@gandalf.local.home>
 <CALOAHbCgaJ83qZVj6qt8tgJBd4ojuLfgSp2Ce7CgzQYshM-amQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCgaJ83qZVj6qt8tgJBd4ojuLfgSp2Ce7CgzQYshM-amQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2021-11-02 09:26:35, Yafang Shao wrote:
> On Tue, Nov 2, 2021 at 9:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2 Nov 2021 09:09:50 +0800
> > Yafang Shao <laoar.shao@gmail.com> wrote:
> > >      Now we only care about kthread, so we can put the pointer into a
> > > kthread specific struct.
> > >      For example in the struct kthread, or in kthread->data (which may
> > > conflict with workqueue).
> >
> > No, add a new field to the structure. "full_name" or something like that.
> > I'm guessing it should be NULL if the name fits in TASK_COMM_LEN and
> > allocated if the name had to be truncated.
> >
> > Do not overload data with this. That will just make things confusing.
> > There's not that many kthreads, where an addition of an 8 byte pointer is
> > going to cause issues.
> 
> Sure, I will add a new field named "full_name", which only be
> allocated if the kthread's comm is truncated.

The plan looks good to me.

One more thing. It should obsolete the workqueue-specific solution.
It would be great to clean up the workqueue code as the next step.

Best Regards,
Petr
