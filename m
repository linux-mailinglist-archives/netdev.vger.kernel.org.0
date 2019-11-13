Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807A2FACA1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfKMJMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:12:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46651 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfKMJMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:12:09 -0500
Received: by mail-lj1-f193.google.com with SMTP id e9so1652279ljp.13
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 01:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CK7UCCTTRmrd6bADAAQ+MFCJsRvTgiOZVCVlKbT/4vQ=;
        b=puaLErPnobM4ee12zVXG5dpJaWU3tkOkq3izgKhDoWUw2+gcb95hX40rlGusOsMLw+
         DpdPw8zEGjPx1OFwYMaVFkIU7saWBTwBjmPRlhIDNelYQjf+8ON5cAM3aLA06DlmD5zC
         WjtiTF136As5rNzPl4/UUOLNupTH+mkpgN7gUW3aaB9nnzo8q4c1qCcDyfoeyitgHWaj
         Y0+y4R3ggIp7khEWgXZcDM/thXrqpBhWSluCcnxrqGBYn1F7L0QiQ6pYw7cnTk15IKRO
         VTM6bsob6in/XqBJJYTI/dZgGL8wefQkxJ1dxcRYOlIK6A8AJQZeFTMDu9EgYdU/h4xh
         RvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CK7UCCTTRmrd6bADAAQ+MFCJsRvTgiOZVCVlKbT/4vQ=;
        b=NILJSOCWDPsBWOG7gWCm5SU1NA8ciobxO6Rz2TZm/1DiKmfL7WHN49vyoZUogy5x3+
         9C/9ona1clHcgF9kuoX81TNpvHB/mmM82bcQeqWzot5ioYvmJN03dc9yo/9uejxcTGrC
         DUwF5bTK3FSsX4xtsktLA6OGacm1CWmboEY2+GIYl47LlzbBPWYKm6qB+LBd0vRk9yxu
         SbLpJump+uuQ8NKDWvGXLIa5ZkWumXqE4NKJXSK+XupS2aL29Wo5Rto0aA4M7Xr36QQ4
         aSn26M57t7N4fTT2EDFnZIrY70iKmmaoUZXUtesTEVOzceF+MzzynKcy59RnjQiYju3q
         Oq2w==
X-Gm-Message-State: APjAAAWlxtAq1Xd6GF8noKh5WAw9PAnz3sn9y/DeUVZtTsE9mad/g6Lw
        Dwb59PU/JZ9YVxfmYoQLAqvzoZrIjF2ChDviO+Td0g==
X-Google-Smtp-Source: APXvYqw/xKnZyRJTyXBLfh0Ffno0sQqTzpoTGqz3JzTt8hPXoKeViiVzv6sEj4uEYLH0K1kJZMl/E8w4yNfDHaPkZrw=
X-Received: by 2002:a2e:9106:: with SMTP id m6mr1815132ljg.146.1573636326431;
 Wed, 13 Nov 2019 01:12:06 -0800 (PST)
MIME-Version: 1.0
References: <20191111075925.GB25277@localhost.localdomain> <20191111133446.GK2865@paulmck-ThinkPad-P72>
In-Reply-To: <20191111133446.GK2865@paulmck-ThinkPad-P72>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 13 Nov 2019 10:11:55 +0100
Message-ID: <CADYN=9LCPfbpwdTWKw03B22-y3Text=RWXW7XP7wJBHYsMOgrA@mail.gmail.com>
Subject: Re: next-20191108: qemu arm64: WARNING: suspicious RCU usage
To:     paulmck@kernel.org
Cc:     joel@joelfernandes.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 at 14:34, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Mon, Nov 11, 2019 at 08:59:25AM +0100, Anders Roxell wrote:
> > Hi,
> >
> > I'm seeing the following warning when I'm booting an arm64 allmodconfig
> > kernel [1] on linux-next tag next-20191108, is this anything you've seen
> > before ?
> >
> >
> > The code seems to have introduced that is f0ad0860d01e ("ipv4: ipmr:
> > support multiple tables") in 2010 and the warning was added reacently
> > 28875945ba98 ("rcu: Add support for consolidated-RCU reader checking").
> >
> >
> > [   32.496021][    T1] =============================
> > [   32.497616][    T1] WARNING: suspicious RCU usage
> > [   32.499614][    T1] 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2 Not tainted
> > [   32.502018][    T1] -----------------------------
> > [   32.503976][    T1] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> > [   32.506746][    T1]
> > [   32.506746][    T1] other info that might help us debug this:
> > [   32.506746][    T1]
> > [   32.509794][    T1]
> > [   32.509794][    T1] rcu_scheduler_active = 2, debug_locks = 1
> > [   32.512661][    T1] 1 lock held by swapper/0/1:
> > [   32.514169][    T1]  #0: ffffa000150dd678 (pernet_ops_rwsem){+.+.}, at: register_pernet_subsys+0x24/0x50
> > [   32.517621][    T1]
> > [   32.517621][    T1] stack backtrace:
> > [   32.519930][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2
> > [   32.523063][    T1] Hardware name: linux,dummy-virt (DT)
> > [   32.524787][    T1] Call trace:
> > [   32.525946][    T1]  dump_backtrace+0x0/0x2d0
> > [   32.527433][    T1]  show_stack+0x20/0x30
> > [   32.528811][    T1]  dump_stack+0x204/0x2ac
> > [   32.530258][    T1]  lockdep_rcu_suspicious+0xf4/0x108
> > [   32.531993][    T1]  ipmr_get_table+0xc8/0x170
>
> So this one is invoking ipmr_for_each_table(), which in turn invokes
> list_for_each_entry_rcu(), which really does want to be in an
> RCU read-side critical section.  (But you can pass it an optional
> additional lockdep expressions.
>
> > [   32.533496][    T1]  ipmr_new_table+0x48/0xa0
>
> And this does look like update-side code...
>
> > [   32.535002][    T1]  ipmr_net_init+0xe8/0x258
>
> And this one is marked with "__net_init", which turns out to be __init.
> So this is being invoked during early boot (see inet_init() below).
> Or with RTNL held when invoked at runtime.  So, can we make a lockdep
> expression for this combination?
>
> The RTNL part is easy, something like this in include/linux/rtnetlink.h:
>
> #ifdef CONFIG_PROVE_LOCKING
> extern int lockdep_rtnl_is_held(void);
> #else
> #define lockdep_rtnl_is_held() 1
> #endif
>
> And in net/core/rtnetlink.c:
>
> #ifdef CONFIG_PROVE_LOCKING
> int lockdep_rtnl_is_held(void)
> {
>         return lockdep_is_held(&rtnl_mutex);
> }
> #endif
>
> > [   32.536465][    T1]  ops_init+0x280/0x2d8
> > [   32.537876][    T1]  register_pernet_operations+0x210/0x420
> > [   32.539707][    T1]  register_pernet_subsys+0x30/0x50
> > [   32.541372][    T1]  ip_mr_init+0x54/0x180
> > [   32.542785][    T1]  inet_init+0x25c/0x3e8
>
> And this is an fs_initcall().  This is late enough during boot that
> RTNL could conceivably be held, but I don't see evidence of that.
> One approach would be to hold RTNL across this initialization code.
>
> So the other approach would be to have a global variable in net/ipv4/ipmr.c
> whose definition depends on whether lockdep is enabled:
>
> #ifdef CONFIG_PROVE_LOCKING
> int ip_mr_initialized;
> void ip_mr_now_initialized(void) { ip_mr_initialized = 1; }
> #else
> const int ip_mr_initialized = 1;
> void ip_mr_now_initialized(void) { }
> #endif
>
> Then at the end of ip_mr_init():
>
>         ip_mr_now_initialized();
>
> And finally change the CONFIG_IP_MROUTE_MULTIPLE_TABLES definition
> of ipmr_for_each_table() to be something like:
>
> #define ipmr_for_each_table(mrt, net) \
>         list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
>                                 lockdep_rtnl_is_held() || !ip_mr_initialized)
>
> > [   32.544186][    T1]  do_one_initcall+0x4c0/0xad8
> > [   32.545757][    T1]  kernel_init_freeable+0x3e0/0x500
> > [   32.547443][    T1]  kernel_init+0x14/0x1f0
> > [   32.548875][    T1]  ret_from_fork+0x10/0x18
>
> Does that work for you?

Yes, that made the "suspicious RCU usage" warning go away.

Cheers,
Anders
