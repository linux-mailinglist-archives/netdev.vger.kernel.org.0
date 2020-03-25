Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E9E1930B3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCYSyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:54:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34217 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCYSyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:54:04 -0400
Received: by mail-oi1-f193.google.com with SMTP id e9so3154595oii.1;
        Wed, 25 Mar 2020 11:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWw78govt1jCZMTOGm30sOUc8tNMV0QPWqlJNzfJWWI=;
        b=Xql09Nf2OOJO07fx1b8npRsZZ63dIc7zbOgp7/7cw4DPczOSwwt7hip7Pt5bKKQFqS
         dKBg1mYXV1eQHi3seyBWSkTymITneF9jgWjHz/vmmuPG9jGrNITskAaUhCKofzG6tTm4
         6Juu/hopTUYaKE++RhnZSiigR8kkddc3saJVx15ToDA3/jGgtqFnH5nLTRjmKBBI9sdA
         0PFScrCb1UWVLwbbiCHjtScw1Jd0ogQOudJD7fRYW6XCjxVW20pBfVYHYCdBZnV9x1IV
         iAf9j+8fXyseidEFtNJXVrPF7Bd5XMFeogiPXKsfmDI2u5Fu5BwsJ4TlI682HtrCn8+i
         LgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWw78govt1jCZMTOGm30sOUc8tNMV0QPWqlJNzfJWWI=;
        b=nyqtdJMnWwcLfHyEMMjLKKMYf3UtcqTvjFkInTOQaNp8KnAwQXdeFIH1xMhISgT3jc
         X1w5e8XjmqgsgJyS+dyQraYcfaUuLF4Uip+C+qjTyra1J0hOIpLXux1gAUFisc4IInUz
         RTt7FH0dszXAzVWxdk4a1EkWRMBR5LA5WABB8oiCmCHBee7xlu0byE5e8Armb3GOlTXS
         hhFZJ1z8wobCuZFqwy8dcm4c3C+cIuva/oQAUK85hy4deKOxH4hpmMm4USLPKWvVmWOd
         r34uVQ8o2uV9T9dlwfP4AuTWWCeuMU2JUDxHlYxWxIXdWf0ENIFA4IkmNqOEomaVnvic
         NKWA==
X-Gm-Message-State: ANhLgQ3ugppc8TEM5NOxlX4CL3e+xJGw1RDBT2qGvdNC/ADZNO4LW0kW
        Np6Kc+JK8JVHcTt1KwtAN9/4Ag/o6uRJldAlrZI=
X-Google-Smtp-Source: ADFU+vthgnztGDzpqeOyOwWxg1D8ByJOoiqbKapZiuDqO3A3t7/JHbTDNJA1rqd5w+Jg5H2jliyGGIKSTVS+BihGYRo=
X-Received: by 2002:aca:4b56:: with SMTP id y83mr3616037oia.142.1585162443547;
 Wed, 25 Mar 2020 11:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de> <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de> <20200324020504.GR3199@paulmck-ThinkPad-P72>
In-Reply-To: <20200324020504.GR3199@paulmck-ThinkPad-P72>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 25 Mar 2020 11:53:51 -0700
Message-ID: <CAM_iQpVK5tNrer3UnnBVU82cRcdNAVtn5bxCm4rDVZM1_ffPAQ@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 7:05 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Tue, Mar 24, 2020 at 02:01:13AM +0100, Thomas Gleixner wrote:
> > Cong Wang <xiyou.wangcong@gmail.com> writes:
> > > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> > We use an ordered workqueue for tc filters, so these two
> > >> > works are executed in the same order as they are queued.
> > >>
> > >> The workqueue is ordered, but look how the work is queued on the work
> > >> queue:
> > >>
> > >> tcf_queue_work()
> > >>   queue_rcu_work()
> > >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> > >>
> > >> So after the grace period elapses rcu_work_rcufn() queues it in the
> > >> actual work queue.
> > >>
> > >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> > >> invoked from preemtible context. Now assume the following:
> > >>
> > >> CPU0
> > >>   tcf_queue_work()
> > >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > >>
> > >> -> Migration
> > >>
> > >> CPU1
> > >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > >>
> > >> So your RCU callbacks can be placed on different CPUs which obviously
> > >> has no ordering guarantee at all. See also:
> > >
> > > Good catch!
> > >
> > > I thought about this when I added this ordered workqueue, but it
> > > seems I misinterpret max_active, so despite we have max_active==1,
> > > more than 1 work could still be queued on different CPU's here.
> >
> > The workqueue is not the problem. it works perfectly fine. The way how
> > the work gets queued is the issue.
> >
> > > I don't know how to fix this properly, I think essentially RCU work
> > > should be guaranteed the same ordering with regular work. But this
> > > seems impossible unless RCU offers some API to achieve that.
> >
> > I don't think that's possible w/o putting constraints on the flexibility
> > of RCU (Paul of course might disagree).
>
> It is possible, but it does not come for free.
>
> From an RCU/workqueues perspective, if I understand the scenario, you
> can do the following:
>
>         tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
>
>         rcu_barrier(); // Wait for the RCU callback.
>         flush_work(...); // Wait for the workqueue handler.
>                          // But maybe for quite a few of them...
>
>         // All the earlier handlers have completed.
>         tcf_queue_work(&p->rwork, tcindex_destroy_work);
>
> This of course introduces overhead and latency.  Maybe that is not a
> problem at teardown time, or maybe the final tcf_queue_work() can itself
> be dumped into a workqueue in order to get it off of the critical path.

I personally agree, but nowadays NIC vendors care about tc filter
slow path performance as well. :-/


>
> However, depending on your constraints ...
>
> > I assume that the filters which hang of tcindex_data::perfect and
> > tcindex_data:p must be freed before tcindex_data, right?
> >
> > Refcounting of tcindex_data should do the trick. I.e. any element which
> > you add to a tcindex_data instance takes a refcount and when that is
> > destroyed then the rcu/work callback drops a reference which once it
> > reaches 0 triggers tcindex_data to be freed.
>
> ... reference counts might work much better for you.
>

I need to think about how much work is needed for refcnting, given
other filters have the same assumption.

Thanks.
