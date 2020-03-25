Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB58D19307D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgCYSg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:36:29 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:45494 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYSg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:36:28 -0400
Received: by mail-ot1-f41.google.com with SMTP id c9so3028822otl.12;
        Wed, 25 Mar 2020 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZ2w8dYk3oZ7eIX0CA2JNbgc/d6IyN2hBn59JxaCzDQ=;
        b=X0rc0Q109Exh3m9jTkwhEw1/pcvNY4a4HA7bZ2zR7PzmRIo42JGfovwHGe2kb2a5+4
         Ah1oerFHqYjNPRkvCr9PDBr7nKu0J9XxYvW4VKL9Wye4qXdAcYFT0JIqdJmUQil0rdPS
         KGtI4e0kQsn/di37lUpe+ASWpfoI9yZ9hbWTOoLW5lex2T/PyuwtcFe3vBDg9PAb9tSP
         eqhQqMvqYU4SV6S6K+UiAZQkDyP8zUhKFz4aPodPva1rPMf921dPwPakdnbXQfEVMS8i
         jV/B/RoA809ppGOVkGEStVHMZWKDTqCU/KKb9JinjRiae4mfBur7kDUn1ReZOOQZiGk/
         cDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZ2w8dYk3oZ7eIX0CA2JNbgc/d6IyN2hBn59JxaCzDQ=;
        b=TR8cZJjlmHFSM38KAGpEh/b3jEjp3j90xO3daEOmWo0yjDjIR/4h4iyGa7I5y/VGr9
         aoG3W2I9TlOnAgMXNGX0Ywmmcu87xfa7D5ReWLQ0OHasFyYvPF4KwdtVcULgiCVAmsLm
         /buI85HoB8P6Iw37vej5MPWQP35NTd4XdDbtxbznOkELuf2z1k8zbyof/4FnA7/NPyVi
         0Poq0UfUdyxIBTPpkF+dlyDimB99lwSFCam3czGisLKOSrgD6VNY43XljxMJzF36LOVc
         Zwe8H8y3FbR3xoxw/ICNHtYeLQENKGTePDoa88U+tI5YMKr4kAkXWyc+JTTgPDC1TLi4
         jWXQ==
X-Gm-Message-State: ANhLgQ0N65mD04SnQXL4Tm5Hj3ZJZRemHKe/TFo0j6J8/Up7/gUvoxUu
        BiyKY/7q3Uf1ZEvOxeP0yf3m53jX0nvp1KHJhCY=
X-Google-Smtp-Source: ADFU+vu3vjQp1i3XCIHLj2Q88z2wpzZKwQ/3nlMdrnYxk4FTS2u6hpyZv3/dmo0hAQDjFSStvN923zlT4mFtz/QAG3I=
X-Received: by 2002:a9d:926:: with SMTP id 35mr3387794otp.319.1585161387764;
 Wed, 25 Mar 2020 11:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de> <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de>
In-Reply-To: <875zeuftwm.fsf@nanos.tec.linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 25 Mar 2020 11:36:16 -0700
Message-ID: <CAM_iQpWkNJ+yQ1g+pdkhJBCZ-CJfUGGpvJqOz1JH7LPVtqbRxg@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 6:01 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > We use an ordered workqueue for tc filters, so these two
> >> > works are executed in the same order as they are queued.
> >>
> >> The workqueue is ordered, but look how the work is queued on the work
> >> queue:
> >>
> >> tcf_queue_work()
> >>   queue_rcu_work()
> >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> >>
> >> So after the grace period elapses rcu_work_rcufn() queues it in the
> >> actual work queue.
> >>
> >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> >> invoked from preemtible context. Now assume the following:
> >>
> >> CPU0
> >>   tcf_queue_work()
> >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> >>
> >> -> Migration
> >>
> >> CPU1
> >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> >>
> >> So your RCU callbacks can be placed on different CPUs which obviously
> >> has no ordering guarantee at all. See also:
> >
> > Good catch!
> >
> > I thought about this when I added this ordered workqueue, but it
> > seems I misinterpret max_active, so despite we have max_active==1,
> > more than 1 work could still be queued on different CPU's here.
>
> The workqueue is not the problem. it works perfectly fine. The way how
> the work gets queued is the issue.

Well, a RCU work is also a work, so the ordered workqueue should
apply to RCU works too, from users' perspective. Users should not
need to learn queue_rcu_work() is actually a call_rcu() which does
not guarantee the ordering for an ordered workqueue.


> > I don't know how to fix this properly, I think essentially RCU work
> > should be guaranteed the same ordering with regular work. But this
> > seems impossible unless RCU offers some API to achieve that.
>
> I don't think that's possible w/o putting constraints on the flexibility
> of RCU (Paul of course might disagree).
>
> I assume that the filters which hang of tcindex_data::perfect and
> tcindex_data:p must be freed before tcindex_data, right?
>
> Refcounting of tcindex_data should do the trick. I.e. any element which
> you add to a tcindex_data instance takes a refcount and when that is
> destroyed then the rcu/work callback drops a reference which once it
> reaches 0 triggers tcindex_data to be freed.

Yeah, but the problem is more than just tcindex filter, we have many
places make the same assumption of ordering.

Thanks!
