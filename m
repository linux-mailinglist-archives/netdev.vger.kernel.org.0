Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD97436D22
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhJUV6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 17:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhJUV57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 17:57:59 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F580C061764;
        Thu, 21 Oct 2021 14:55:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 67so2534153yba.6;
        Thu, 21 Oct 2021 14:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZCWSb4CNcUutmy67uPScB/N0o+yGwGltNZHm45vcOhk=;
        b=oCz0HlMe3i8pvE64pfiQxaOUsu9XUUMN5xWybWUwvozJ0s2n5tiW+pW/bwvs37ylSL
         cdrLjH9w95N1ZZUQnXKWpTckKiGhTa37QL52SsgRwxMkYwhJz2E1i8ofqI0mXmLOqXnI
         rgAXJk7seMHgDZAo/mF6KzY3RPOBSlQ9x7dwpqXPA99wGCa13yvRlKjm5Fdkb6kooUdR
         qbqqvoQWXpLWot3R/iDV2EQJCw3089PvAmI6FXiygyYWG3H30y87zvHDj+hKllx2ZJG+
         2/e4A0Fgn/bQFQSWCq1D8KNReyBhETh6izE1N4qQfVp1H1x9HWzClPhzaR5HFS24lhZO
         k5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZCWSb4CNcUutmy67uPScB/N0o+yGwGltNZHm45vcOhk=;
        b=Y+qNHHNN3ykkQHi2fbI0Xt8OIcvAoXmeL7Y3kfB7vIYe/px/mCuCHI2t3fleuqcBm4
         rjptd7wV5fNvyV0YaLEo1b0pkq7ZT0ZStfTmvXVM7p1ogyC8dSfFnM8LMma8FLkPBzT/
         bHOoDjcULwvgzgipLInoGBTX1cqkqPX8oyNq69sbOiyT+VPlQJmgRIqWmZ7fpwFj1KhL
         HbQn17ExFYeHWzoP69pNyq+nU939khWLaSiV1Z9QHW5xdC8lZ1BN1tw8e9bSiEFlb9Ej
         Ld++jkUw7sHP3iE9KcAD8C0sAWaVB1MFLfHZ87Fg3Fv23FOCd9kKbYizny046tt8v0pu
         yHug==
X-Gm-Message-State: AOAM533S1TUc5Vzxazef5PVDX+UUnBjKvCCGFxQPCeczO75470mtuwrQ
        rBj/9BEiYieyiCFzNFghbfu7Ca9QXvdTMUxZDgI=
X-Google-Smtp-Source: ABdhPJwAwl8RViPtIS5dyd7tQAtoGE+y8lEBBFlWKgnWIrQnjKbXS84OdOvxzGdFdIi80lqcpZxtfcD5HgdVhO0cX1c=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr9414694ybf.455.1634853341849;
 Thu, 21 Oct 2021 14:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034516.4400-1-laoar.shao@gmail.com> <20211021034516.4400-4-laoar.shao@gmail.com>
In-Reply-To: <20211021034516.4400-4-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Oct 2021 14:55:31 -0700
Message-ID: <CAEf4Bzb0YSwqoKn2N4gPJS40atWBRHLkK9fBy=wghkXUC5Sqmw@mail.gmail.com>
Subject: Re: [PATCH v5 03/15] sched.h: introduce TASK_COMM_LEN_16
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, juri.lelli@redhat.com,
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
        oliver.sang@intel.com, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 8:45 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> There're many hard-coded 16 used to store task comm in the kernel, that
> makes it error prone if we want to change the value of TASK_COMM_LEN. A
> new marco TASK_COMM_LEN_16 is introduced to replace these old ones, then
> we can easily grep them.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/sched.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c1a927ddec64..62d5b30d310c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -274,6 +274,8 @@ struct task_group;
>
>  #define get_current_state()    READ_ONCE(current->__state)
>
> +/* To replace the old hard-coded 16 */
> +#define TASK_COMM_LEN_16               16
>  /* Task command name length: */
>  #define TASK_COMM_LEN                  16

Can we please convert these two constants into enum? That will allow
BPF applications to deal with such kernel change more easily because
these constants will now be available as part of kernel BTF.

Something like this should be completely equivalent for all the kernel uses:

enum {
    TASK_COMM_LEN = 16,
    TASK_COMM_LEN_16 = 16,
};

When later TASK_COMM_LEN is defined as = 24, BPF applications will be
able to deal with that by querying BTF through BPF CO-RE.

>
> --
> 2.17.1
>
