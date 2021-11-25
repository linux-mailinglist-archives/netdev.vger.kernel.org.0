Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8374A45D700
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350476AbhKYJXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:23:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54716 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350483AbhKYJVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 04:21:20 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 648EE1FD37;
        Thu, 25 Nov 2021 09:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637831888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wwiQDOJPEAtzx84W81WwUuy+jKhgNVXmO5+Woa5hQic=;
        b=M/Ek+AulDH/wV30n8i89uCsJvOx1LasGO0CEKw1mF3nTtKNvw6GHp/8BcGum68QkcGGe0Y
        QNtXCVqyOlG6pGGmb6vvn2p2Cod/bdekR9z1FNTtZ93mC7vd9QvrjY4mBgWRpuTF1MGmg5
        EevC5cXRISLOJ6H5f4vGzbUcE63Et+U=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F35B4A3B81;
        Thu, 25 Nov 2021 09:18:07 +0000 (UTC)
Date:   Thu, 25 Nov 2021 10:18:07 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] kthread: dynamically allocate memory to store
 kthread's full name
Message-ID: <YZ9Uz3m42lfNR9pf@alley>
References: <20211120112850.46047-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120112850.46047-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 2021-11-20 11:28:50, Yafang Shao wrote:
> When I was implementing a new per-cpu kthread cfs_migration, I found the
> comm of it "cfs_migration/%u" is truncated due to the limitation of
> TASK_COMM_LEN.
> 
> One possible way to fix this issue is extending the task comm size, but
> as task->comm is used in lots of places, that may cause some potential
> buffer overflows. Another more conservative approach is introducing a new
> pointer to store kthread's full name if it is truncated, which won't
> introduce too much overhead as it is in the non-critical path. Finally we
> make a dicision to use the second approach. See also the discussions in
> this thread:
> https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
> 
> After this change, the full name of these truncated kthreads will be
> displayed via /proc/[pid]/comm:

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
