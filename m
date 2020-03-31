Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E48198A2E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgCaCyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:54:22 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34518 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaCyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:54:22 -0400
Received: by mail-oi1-f194.google.com with SMTP id d3so13131794oic.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 19:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kdsyqxGZUZMqbHFOHBlW9xn1q+d3ELW6X3BfqOz4CcY=;
        b=LsCCUm2kRD8ZwuL4JOWNsJKhusyDdhYSRbbaMrIRkUodvZhIDQlMDZXTKztwgxH8Ec
         4VcIYGXrr/N7mQd0SfmKw6KVtIkHvxmScsqBqh29xWSrnSaIxHuonh/LE68F5NNvGes2
         OaG8Rfh7P939aOA70AdRgyWPwuNxNqrsRFwctwbnROhjXhBD9wbohdgSKvVIV5Tj1YQ8
         +VHWxhovY0q8pel2KA3IoyI6DT2h+aMax18k5Sm/CbVluXBTMVeN9hVuFc3AQAawo7L6
         AutFjCaHZicHVmpb0WV7bjE8vniB6+qExmfTEectVRRUgFGMCQcglq2ncfpSyt/O1QJD
         Mjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kdsyqxGZUZMqbHFOHBlW9xn1q+d3ELW6X3BfqOz4CcY=;
        b=dnxjWTQQ8icNzTRicrziUR7X3xEtywvY9mbIwZ41Sm4+Usv0SCfMnYF37GGtSReKO0
         0lXr1WAgnlOnIrwceuze3jhCP4p8YPPzkfAzz4EZjPWqVpcdQRVItUR1QvFklA05Mlde
         niaNrO/p6zKZju77FI2bX13TiiVaGwrm82CN4iKlbF2gzqQzJrKfdzovr3WYf/dztSfl
         mf3FLHhsx2x1J0cQkTDVKIA8WniIkCpK3inAzBQkXKJKpv+NUeqG5QXWA/+uy61OgRMs
         w+xEX+IoXgx588uC0gN07BwsiIyFDpg0oNPi89KpZ+84UxmA/niOd37HCPUl5Mwtn7wd
         7GAQ==
X-Gm-Message-State: ANhLgQ1+jS5Yjn028g4zNvfC/7lfxdnYx/ItH841aZpEyGnRL5gSZu6j
        ihXDRl0AZNoJ0AD+ehW+5av3+jArJ20G6UaURt4=
X-Google-Smtp-Source: ADFU+vsOLbpwipZUXQknpgTfjOnu7+ntdChWQzqo4njvW/0G4sTH/503Uh+hzZgAGI//gLuzzm7rH9g7Rao/+LzmwDg=
X-Received: by 2002:aca:d489:: with SMTP id l131mr760525oig.5.1585623261189;
 Mon, 30 Mar 2020 19:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
 <20200330213514.GT19865@paulmck-ThinkPad-P72> <CAM_iQpUu6524ZyZDBu=nkuhpubyGBTHEJ-HK8qrpCW=EEKGujw@mail.gmail.com>
 <20200331023009.GI19865@paulmck-ThinkPad-P72>
In-Reply-To: <20200331023009.GI19865@paulmck-ThinkPad-P72>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Mar 2020 19:54:09 -0700
Message-ID: <CAM_iQpVrERPYoNNK+hywxLONEv3mF7f0Y37uMQ0gqVeR8E8kPQ@mail.gmail.com>
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct tcindex_data
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 7:30 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Mon, Mar 30, 2020 at 04:24:42PM -0700, Cong Wang wrote:
> > On Mon, Mar 30, 2020 at 2:35 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > On Sat, Mar 28, 2020 at 12:12:59PM -0700, Cong Wang wrote:
> > > > Although we intentionally use an ordered workqueue for all tc
> > > > filter works, the ordering is not guaranteed by RCU work,
> > > > given that tcf_queue_work() is esstenially a call_rcu().
> > > >
> > > > This problem is demostrated by Thomas:
> > > >
> > > >   CPU 0:
> > > >     tcf_queue_work()
> > > >       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > > >
> > > >   -> Migration to CPU 1
> > > >
> > > >   CPU 1:
> > > >      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > > >
> > > > so the 2nd work could be queued before the 1st one, which leads
> > > > to a free-after-free.
> > > >
> > > > Enforcing this order in RCU work is hard as it requires to change
> > > > RCU code too. Fortunately we can workaround this problem in tcindex
> > > > filter by taking a temporary refcnt, we only refcnt it right before
> > > > we begin to destroy it. This simplifies the code a lot as a full
> > > > refcnt requires much more changes in tcindex_set_parms().
> > > >
> > > > Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> > > > Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > >
> > > Looks plausible, but what did you do to verify that the structures
> > > were in fact being freed?  See below for more detail.
> >
> > I ran the syzbot reproducer for about 20 minutes, there was no
> > memory leak reported after scanning.
>
> And if you (say) set the initial reference count to two instead of one,
> there is a memory leak reported, correct?

No, I didn't do an A/B test. I just added a printk right before the kfree(),
if it helps to convince you, here is one portion of the kernel log:

[   39.159298] a.out (703) used greatest stack depth: 11624 bytes left
[   39.166365] a.out (701) used greatest stack depth: 11352 bytes left
[   39.453257] freeing struct tcindex_data.
[   39.573554] freeing struct tcindex_data.
[   39.681540] freeing struct tcindex_data.
[   39.781158] freeing struct tcindex_data.
[   39.877726] freeing struct tcindex_data.
[   39.985515] freeing struct tcindex_data.
[   40.097687] freeing struct tcindex_data.
[   40.213691] freeing struct tcindex_data.
[   40.271465] device bridge_slave_1 left promiscuous mode
[   40.274078] bridge0: port 2(bridge_slave_1) entered disabled state
[   40.297258] device bridge_slave_0 left promiscuous mode
[   40.299377] bridge0: port 1(bridge_slave_0) entered disabled state
[   40.733355] device hsr_slave_0 left promiscuous mode
[   40.749322] device hsr_slave_1 left promiscuous mode
[   40.784220] team0 (unregistering): Port device team_slave_1 removed
[   40.792641] team0 (unregistering): Port device team_slave_0 removed
[   40.806302] bond0 (unregistering): (slave bond_slave_1): Releasing
backup interface
[   40.836972] bond0 (unregistering): (slave bond_slave_0): Releasing
backup interface
[   40.931688] bond0 (unregistering): Released all slaves
[   44.149970] freeing struct tcindex_data.
[   44.159568] freeing struct tcindex_data.
[   44.172786] freeing struct tcindex_data.
[   44.813214] freeing struct tcindex_data.
[   44.821857] freeing struct tcindex_data.
[   44.825064] freeing struct tcindex_data.
[   44.826889] freeing struct tcindex_data.
[   45.294254] freeing struct tcindex_data.
[   45.297980] freeing struct tcindex_data.
[   45.300623] freeing struct tcindex_data.

And no memory leak of course:

[root@localhost tmp]# echo scan > /sys/kernel/debug/kmemleak
[root@localhost tmp]# echo scan > /sys/kernel/debug/kmemleak
[root@localhost tmp]# cat /sys/kernel/debug/kmemleak

Thanks.
