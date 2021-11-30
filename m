Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4209146368E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbhK3O0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhK3O0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:26:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B3DC061574;
        Tue, 30 Nov 2021 06:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F03CB819E7;
        Tue, 30 Nov 2021 14:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D55C53FC1;
        Tue, 30 Nov 2021 14:22:41 +0000 (UTC)
Date:   Tue, 30 Nov 2021 09:22:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 4/7] fs/binfmt_elf: replace open-coded string copy
 with get_task_comm
Message-ID: <20211130092240.312f68a4@gandalf.local.home>
In-Reply-To: <CALOAHbB-2ESG0QgESN_b=bXzESbq+UBP-dqttirKnt1c9TZHZA@mail.gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-5-laoar.shao@gmail.com>
        <20211129110140.733475f3@gandalf.local.home>
        <CALOAHbB-2ESG0QgESN_b=bXzESbq+UBP-dqttirKnt1c9TZHZA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 11:01:27 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> There are three options,
> - option 1
>   comment on all the hard-coded 16 to explain why it is hard-coded
> - option 2
>   replace the hard-coded 16 that can be replaced and comment on the
> others which can't be replaced.
> - option 3
>    replace the hard-coded 16 that can be replaced and specifically
> define TASK_COMM_LEN_16 in other files which can't include
> linux/sched.h.
> 
> Which one do you prefer ?
> 

Option 3. Since TASK_COMM_LEN_16 is, by it's name, already hard coded to
16, it doesn't really matter if you define it in more than one location.

Or we could define it in another header that include/sched.h can include.

The idea of having TASK_COMM_LEN_16 is to easily grep for it, and also know
exactly what it is used for when people see it being used.

-- Steve
