Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7DD3D0229
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhGTSqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhGTSqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:46:30 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359C1C0613DB
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 12:27:02 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c23so3576517ljr.8
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 12:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EI2a6CePBuQR5Qmt/hIAg9BsSGRZLvCH1L7dvlW0uiw=;
        b=C/IMoejLQ3TpAwWYMjgZegIoM3Ljsd0fchCpMbLPN0uYHEs1jmSCEBv6KPLLzExal4
         0LbYsqLNPRLzA3+wLI5TdzUtmrYg6vZAes3ebz8vsJgXKaIBilRm2/xQWyTTGjN5PzDK
         cMPnwUPZDMkvN5llO6UyNuK/a5D5WQectAgzehBqPkcz/Ac4EsX30+MR84+gFOaI1gzR
         4J2I88iq7Y2E2mq4ewAltFyL+qCLUXcBCmbCKDitSeGnYei1G843MWztVnuwFXYr6gX2
         2woprX0y3Iar4L4M24OgoI/JiMLIH+m199zJtJF6zCHRfxY5ijhU1s3YEHwnYB7coF6M
         Hxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EI2a6CePBuQR5Qmt/hIAg9BsSGRZLvCH1L7dvlW0uiw=;
        b=nN2cGlTX5/YJoyBK7lPqYbZNUnVb4UohHBHRur3YFTvY347EiWbrPtHeMpBDsKVSC5
         k8+dOLEwc7z/EQt0cSucMRjFH8ODForG4a7R+xi2GCF9w6GgfAlH9wJrucLn68NQJm68
         MckLZQhL2b54pRPGevxG+HJMfxVBgOq49w0O1bK+Oz/JIj8BM4t1wDFcl7V2qzG6sgnO
         jWsBdh9s7nGbGpPA77cYoKYdvy8imwrJz5DSAvvhgS88A+XVflgU8T3jRZTSLZAqIkRm
         ukXqDCGaJsiYqkVw51EUZdWDkD0m6JnbDC+8h9jEJjGlYtK2CP+7WbVVp0P48rrxCkJp
         o9pg==
X-Gm-Message-State: AOAM530zJGPyTprXZFZNzDfpg5qR0dYo5xxoRbhSl42YwaEbefE7dIFM
        Ka72UTlzX9Z2l+eOlj3En89WMVS8DozQ79EvvXKQEg==
X-Google-Smtp-Source: ABdhPJxSeCQrtKMGm2Qo3jOi9yp1Cpkh4gfKZo13daPxhKFclCpddl5nYSSjG2kXt4QMPJSwPWOccgx8xgttFS5DF8I=
X-Received: by 2002:a05:651c:1213:: with SMTP id i19mr22636901lja.81.1626809220205;
 Tue, 20 Jul 2021 12:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
In-Reply-To: <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 20 Jul 2021 12:26:48 -0700
Message-ID: <CALvZod4HCRHpPJtGE=8tU1Yj=WsWHpocP0q0JU3r4F2fMmAw5w@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 3:44 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> An netadmin inside container can use 'ip a a' and 'ip r a'
> to assign a large number of ipv4/ipv6 addresses and routing entries
> and force kernel to allocate megabytes of unaccounted memory
> for long-lived per-netdevice related kernel objects:
> 'struct in_ifaddr', 'struct inet6_ifaddr', 'struct fib6_node',
> 'struct rt6_info', 'struct fib_rules' and ip_fib caches.
>
> These objects can be manually removed, though usually they lives
> in memory till destroy of its net namespace.
>
> It makes sense to account for them to restrict the host's memory
> consumption from inside the memcg-limited container.
>
> One of such objects is the 'struct fib6_node' mostly allocated in
> net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
>
>  write_lock_bh(&table->tb6_lock);
>  err = fib6_add(&table->tb6_root, rt, info, mxc);
>  write_unlock_bh(&table->tb6_lock);
>
> In this case it is not enough to simply add SLAB_ACCOUNT to corresponding
> kmem cache. The proper memory cgroup still cannot be found due to the
> incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
>
> Obsoleted in_interrupt() does not describe real execution context properly.
> From include/linux/preempt.h:
>
>  The following macros are deprecated and should not be used in new code:
>  in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
>
> To verify the current execution context new macro should be used instead:
>  in_task()      - We're in task context
>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  mm/memcontrol.c      | 2 +-
>  net/core/fib_rules.c | 4 ++--
>  net/ipv4/devinet.c   | 2 +-
>  net/ipv4/fib_trie.c  | 4 ++--
>  net/ipv6/addrconf.c  | 2 +-
>  net/ipv6/ip6_fib.c   | 4 ++--
>  net/ipv6/route.c     | 2 +-
>  7 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae1f5d0..1bbf239 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>                 return false;
>
>         /* Memcg to charge can't be determined. */
> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>                 return true;
>
>         return false;

Can you please also change in_interrupt() in active_memcg() as well?
There are other unrelated in_interrupt() in that file but the one in
active_memcg() should be coupled with this change.
