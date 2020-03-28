Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D797196900
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 20:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgC1Tx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 15:53:58 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45061 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgC1Tx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 15:53:57 -0400
Received: by mail-oi1-f193.google.com with SMTP id l22so12026239oii.12;
        Sat, 28 Mar 2020 12:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSGii26mjz2GbRfXuI9GdKWKXO3EKbaZ2YcgLef0z1M=;
        b=JBcSEl5OaB0xLPzVCwwVB6wAco0wSHH3GuEkqXqb0gzGRn5O1IXFtfGlcwJGnFg2ah
         KyUnUuicvCP1p0BBGAT5ukyON3xbjdIlWSsz4Kr4G+D9X/qkvoFsE5uy0kOfigQqktnz
         aQdD0eYs/D/mosgROtjLHBE01yQ65lI1i5xLoYG3wvuQD6Alp57H98LO9jReht6Vdjaf
         vCXv2SxA+ZVjPT5nqyQXOLRab5bsf3L+I38ILFlxgl0ZY9vKUFlnbq2QkpJJxNiGab9d
         u6ix93mSsD2QKc0RBwDudqJoBAxrHTip8zkDmI4kEJf7xM3hXPec4GtWZ6Mrx0FTBE8S
         b7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSGii26mjz2GbRfXuI9GdKWKXO3EKbaZ2YcgLef0z1M=;
        b=pZZAPxrop9tpujscpk1tZz/vMyIDPz3OrJV7Egxsxr6L7ZMYVA8VwQlSIgnoBKMbyn
         fMfVjUmbIAgwf9uGD5j1UfvnSiX4sCM+PyFBZxvG0xmVoMfFjiZ1aH7MHEjdtjgdNw9g
         3SZYIuglAua5gEL6kRHlE1E1QIT+ZksgHRa+veAh7HQfkAQk1oTGqJnmtolQlUjGTkbM
         JRFgTb4oCLAUADDhbp7XgDJg95Trlf7WeyyNnUUW545/rmokOcUI70OT9gXNv9iU12hE
         Tp6lO8GXEUpGk5/lnNaSNIfqOLmXls9tDEGUZSt6r2DXwbUgNH5wdy3dQx2kmMsYE1ih
         SHvg==
X-Gm-Message-State: ANhLgQ3Bamo/0iL3EYC+6PLtAQRIlcnOg3V10Dt7PAH/329OfcKburlg
        6IsQHdHf5Obh0n3nvCxBmGPqYVcy3TV50k750GQ=
X-Google-Smtp-Source: ADFU+vsgokPGvH1o8RU0G0zljPIpDdJwtA6WmoJoFnXBhgdhpNNYd6jwDERiqmPldDZfVApLggznBqxkFFbatWDEf+I=
X-Received: by 2002:aca:4b56:: with SMTP id y83mr3307244oia.142.1585425235301;
 Sat, 28 Mar 2020 12:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de> <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de> <CAM_iQpWkNJ+yQ1g+pdkhJBCZ-CJfUGGpvJqOz1JH7LPVtqbRxg@mail.gmail.com>
 <20200325185815.GW19865@paulmck-ThinkPad-P72>
In-Reply-To: <20200325185815.GW19865@paulmck-ThinkPad-P72>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 28 Mar 2020 12:53:43 -0700
Message-ID: <CAM_iQpU+1as_RAE64wfq+rWcCb16_amFP3V4rZVFRr29SfwD4Q@mail.gmail.com>
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

On Wed, Mar 25, 2020 at 11:58 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Wed, Mar 25, 2020 at 11:36:16AM -0700, Cong Wang wrote:
> > On Mon, Mar 23, 2020 at 6:01 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > >
> > > Cong Wang <xiyou.wangcong@gmail.com> writes:
> > > > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >> > We use an ordered workqueue for tc filters, so these two
> > > >> > works are executed in the same order as they are queued.
> > > >>
> > > >> The workqueue is ordered, but look how the work is queued on the work
> > > >> queue:
> > > >>
> > > >> tcf_queue_work()
> > > >>   queue_rcu_work()
> > > >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> > > >>
> > > >> So after the grace period elapses rcu_work_rcufn() queues it in the
> > > >> actual work queue.
> > > >>
> > > >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> > > >> invoked from preemtible context. Now assume the following:
> > > >>
> > > >> CPU0
> > > >>   tcf_queue_work()
> > > >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > > >>
> > > >> -> Migration
> > > >>
> > > >> CPU1
> > > >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > > >>
> > > >> So your RCU callbacks can be placed on different CPUs which obviously
> > > >> has no ordering guarantee at all. See also:
> > > >
> > > > Good catch!
> > > >
> > > > I thought about this when I added this ordered workqueue, but it
> > > > seems I misinterpret max_active, so despite we have max_active==1,
> > > > more than 1 work could still be queued on different CPU's here.
> > >
> > > The workqueue is not the problem. it works perfectly fine. The way how
> > > the work gets queued is the issue.
> >
> > Well, a RCU work is also a work, so the ordered workqueue should
> > apply to RCU works too, from users' perspective. Users should not
> > need to learn queue_rcu_work() is actually a call_rcu() which does
> > not guarantee the ordering for an ordered workqueue.
>
> And the workqueues might well guarantee the ordering in cases where the
> pair of RCU callbacks are invoked in a known order.  But that workqueues
> ordering guarantee does not extend upstream to RCU, nor do I know of a
> reasonable way to make this happen within the confines of RCU.
>
> If you have ideas, please do not keep them a secret, but please also
> understand that call_rcu() must meet some pretty severe performance and
> scalability constraints.
>
> I suppose that queue_rcu_work() could track outstanding call_rcu()
> invocations, and (one way or another) defer the second queue_rcu_work()
> if a first one is still pending from the current task, but that might not
> make the common-case user of queue_rcu_work() all that happy.  But perhaps
> there is a way to restrict these semantics to ordered workqueues.  In that
> case, one could imagine the second and subsequent too-quick call to
> queue_rcu_work() using the rcu_head structure's ->next field to queue these
> too-quick callbacks, and then having rcu_work_rcufn() check for queued
> too-quick callbacks, queuing the first one.
>
> But I must defer to Tejun on this one.
>
> And one additional caution...  This would meter out ordered
> queue_rcu_work() requests at a rate of no faster than one per RCU
> grace period.  The queue might build up, resulting in long delays.
> Are you sure that your use case can live with this?

I don't know, I guess we might be able to add a call_rcu() takes a cpu
as a parameter so that all of these call_rcu() callbacks will be queued
on a same CPU thusly guarantees the ordering. But of course we
need to figure out which cpu to use. :)

Just my two cents.


>
> > > > I don't know how to fix this properly, I think essentially RCU work
> > > > should be guaranteed the same ordering with regular work. But this
> > > > seems impossible unless RCU offers some API to achieve that.
> > >
> > > I don't think that's possible w/o putting constraints on the flexibility
> > > of RCU (Paul of course might disagree).
> > >
> > > I assume that the filters which hang of tcindex_data::perfect and
> > > tcindex_data:p must be freed before tcindex_data, right?
> > >
> > > Refcounting of tcindex_data should do the trick. I.e. any element which
> > > you add to a tcindex_data instance takes a refcount and when that is
> > > destroyed then the rcu/work callback drops a reference which once it
> > > reaches 0 triggers tcindex_data to be freed.
> >
> > Yeah, but the problem is more than just tcindex filter, we have many
> > places make the same assumption of ordering.
>
> But don't you also have a situation where there might be a large group
> of queue_rcu_work() invocations whose order doesn't matter, followed by a
> single queue_rcu_work() invocation that must be ordered after the earlier
> group?  If so, ordering -all- of these invocations might be overkill.
>
> Or did I misread your code?

You are right. Previously I thought all non-trivial tc filters would need
to address this ordering bug, but it turns out probably only tcindex
needs it, because most of them actually use linked lists. As long as
we remove the entry from the list before tcf_queue_work(), it is fine
to free the list head before each entry in the list.

I just sent out a minimal fix using the refcnt.

Thanks!
