Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332B461B90
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345388AbhK2QNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 11:13:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhK2QLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 11:11:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60926B811F6;
        Mon, 29 Nov 2021 16:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1FCC53FC7;
        Mon, 29 Nov 2021 16:07:56 +0000 (UTC)
Date:   Mon, 29 Nov 2021 11:07:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
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
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded
 16 with TASK_COMM_LEN
Message-ID: <20211129110755.616133df@gandalf.local.home>
In-Reply-To: <CALOAHbDkMhnO_OfQiV4gA8rGnLpyQ27nUcWSnN_-8TXkfQ1Eyw@mail.gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-8-laoar.shao@gmail.com>
        <yt9d35nf1d84.fsf@linux.ibm.com>
        <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
        <yt9d35nfvy8s.fsf@linux.ibm.com>
        <54e1b56c-e424-a4b3-4d61-3018aa095f36@redhat.com>
        <yt9dy257uivg.fsf@linux.ibm.com>
        <CALOAHbDkMhnO_OfQiV4gA8rGnLpyQ27nUcWSnN_-8TXkfQ1Eyw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 23:33:33 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> > TBH, i would vote for reverting the change. defining an array size as
> > enum feels really odd.
> >  
> 
> We changed it to enum because the BTF can't parse macro while it can
> parse the enum type.

I wonder if BTF could take advantage of the tracing:

TRACE_DEFINE_ENUM() macros?

This is how they are converted for user space tooling.

Anyway, I'd have to go and look at why that trigger test failed. I don't
see how the size of the array caused it to change the signage of value.

-- Steve


> Anyway I don't insist on keeping this change if you think reverting it
> is better.

