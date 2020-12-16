Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC42DBE98
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgLPK0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgLPK0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 05:26:13 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA36CC061282
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 02:25:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id w1so27271879ejf.11
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 02:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ym85wg7PtkG2USwglGkEQbjEp6lBmKatepEQs0Sb5n8=;
        b=h0B84yppIC6IiGOJapPayTD3ruNvsicUE+jHmSp6Jt7woATokjaUd9UoTFKL2KKM8h
         ej4ySorPDcwIVVR51oP7VaTjFyTlxbM/yScABuw9M0AlgBcFykVFmIL3y5pASA9cCFOu
         stXqIYxLmN4cdsIJKvw5yJ69S+PTzGtD2u3BkuvNaQrnwTKybrsn/os2ndz48VYMkvws
         e5qeoHpzBHpfRkTsUTgCetkSRpsm63P422+safCYVnJvZ0i1K9bctSh+Z2BZS6oZHj/B
         0k0FfNTxyfik78IEHOScK3YN941dQBtqGHmD3d/CBOpj+vQ3MJBxoOikwbUMYJhwkxFp
         u9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ym85wg7PtkG2USwglGkEQbjEp6lBmKatepEQs0Sb5n8=;
        b=MDHw33qcCQSVvbraBB1KSd9vLIQNNdkTEDwEeN3MGLAQgM9T3P+u6+1S1K2BTQLV6M
         WFG+9AvzcAs7dnZXd86c6pBQnV3b7d4UVnx5jL96hPTFGwmpPlvXUqG66Z/y4li2doX7
         k7BETeM1stwco+gf/JCSsKuUC1bORVkAh5AMEQoRa+KMvT0871JYmuEq6130y8zLZP3z
         KPfUjBO8uxxspkMJjr8fBUWhU+7mGdzGJBjKdI6VuIZUD4jTe9ZqKRl97GY2nTjRV4h0
         T66EEXc476YHI+dp/HJj2FX5OC47K2VpGlhMczzWmBVBM6tUg7DGeM+l6Jj6bFhPm1wM
         APIQ==
X-Gm-Message-State: AOAM533Kqq/SZL5YGryY35cS2sPc1GjHRAeX8Q/M3hYO0evb+azGIJ7e
        RbiXURtQ5+dgPlFXCw9LXTM54UK8yZNJVc1gat3wwV4Ob0mcVxjn
X-Google-Smtp-Source: ABdhPJzUzlL4dfw10lcm1m6wudRtiT3RMtghr3y3coNwH1YNtq227Ru0urZLsWzsMQTu8udtNGBBYdcJanwHlIz7hnQ=
X-Received: by 2002:a17:906:3499:: with SMTP id g25mr6371983ejb.18.1608114326375;
 Wed, 16 Dec 2020 02:25:26 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com>
 <20201215144531.GZ2657@paulmck-ThinkPad-P72> <20201215102246.4bdca3d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215102246.4bdca3d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 16 Dec 2020 15:55:14 +0530
Message-ID: <CA+G9fYt_zxDSN5Qkx=rBE_ZkjirOBQ3QpFRy-gkqbjbJ=n1Z4Q@mail.gmail.com>
Subject: Re: [stabe-rc 5.9 ] sched: core.c:7270 Illegal context switch in
 RCU-bh read-side critical section!
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>, rcu@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 at 23:52, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Dec 2020 06:45:31 -0800 Paul E. McKenney wrote:
> > > Crash log:
> > > --------------
> > > # selftests: bpf: test_tc_edt.sh
> > > [  503.796362]
> > > [  503.797960] =============================
> > > [  503.802131] WARNING: suspicious RCU usage
> > > [  503.806232] 5.9.15-rc1 #1 Tainted: G        W
> > > [  503.811358] -----------------------------
> > > [  503.815444] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
> > > context switch in RCU-bh read-side critical section!
> > > [  503.825858]
> > > [  503.825858] other info that might help us debug this:
> > > [  503.825858]
> > > [  503.833998]
> > > [  503.833998] rcu_scheduler_active = 2, debug_locks = 1
> > > [  503.840981] 3 locks held by kworker/u12:1/157:
> > > [  503.845514]  #0: ffff0009754ed538
> > > ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
> > > [  503.855048]  #1: ffff800013e63df0 (net_cleanup_work){+.+.}-{0:0},
> > > at: process_one_work+0x208/0x768
> > > [  503.864201]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
> > > at: cleanup_net+0x64/0x3b8
> > > [  503.872786]
> > > [  503.872786] stack backtrace:
> > > [  503.877229] CPU: 1 PID: 157 Comm: kworker/u12:1 Tainted: G        W
> > >         5.9.15-rc1 #1
> > > [  503.885433] Hardware name: ARM Juno development board (r2) (DT)
> > > [  503.891382] Workqueue: netns cleanup_net
> > > [  503.895324] Call trace:
> > > [  503.897786]  dump_backtrace+0x0/0x1f8
> > > [  503.901464]  show_stack+0x2c/0x38
> > > [  503.904796]  dump_stack+0xec/0x158
> > > [  503.908215]  lockdep_rcu_suspicious+0xd4/0xf8
> > > [  503.912591]  ___might_sleep+0x1e4/0x208
> >
> > You really are forbidden to invoke ___might_sleep() while in a BH-disable
> > region of code, whether due to rcu_read_lock_bh(), local_bh_disable(),
> > or whatever else.
> >
> > I do see the cond_resched() in inet_twsk_purge(), but I don't immediately
> > see a BH-disable region of code.  Maybe someone more familiar with this
> > code would have some ideas.
> >
> > Or you could place checks for being in a BH-disable further up in
> > the code.  Or build with CONFIG_DEBUG_INFO=y to allow more precise
> > interpretation of this stack trace.

I will try to reproduce this warning with DEBUG_INFO=y enabled kernel and
get back to you with a better crash log.

>
> My money would be on the option that whatever run on this workqueue
> before forgot to re-enable BH, but we already have a check for that...
> Naresh, do you have the full log? Is there nothing like "BUG: workqueue
> leaked lock" above the splat?

Yes [1] is the full test log link.
But i do not see "BUG: workqueue leaked lock" in the log.

full log link,
[1] https://lkft.validation.linaro.org/scheduler/job/2049484#L5979

- Naresh
